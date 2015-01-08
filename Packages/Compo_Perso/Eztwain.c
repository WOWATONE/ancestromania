// EZTWAIN.C - Easy TWAIN DLL main module
//
// 	05/11/94	spike	initial version
// 1.00	06/17/94	spike
// 1.01	07/27/94	spike - added XferCount negotiation
// 1.02 10/26/94	spike - fixed bug in ModalEventLoop (thanks to Bill DeVoe of HP)
//							replaced random flags with state tracking
// 1.03 02/06/95	spike - fixed gross omissions in WriteDibToFile
// 1.04 04/05/95	spike - added WriteNativeToFile, WriteNativeToFilename, FreeNative
//							added Get/SetCurrentUnits, SetCurrentPixelType
//							added SetCurrentResolution, SetCapOneValue
//							corrected bug in SelectImageSource
// 1.05 04/02/97	spike - 32-bit version.
//							Correction to MessageHook, for thunking DSM.
//							Bugfix: 32-bit version of TWAIN_WriteDibToFile
// 1.06 08/21/97	spike
//							Yet another correction to MessageHook.
//							Figured out how to export names 'as is' in 32-bit version.

#define VERSION 106		// version number, times 100.

//------------ Includes

//#include <assert.h>
//#include <memory.h>		// memset, memcpy

#include "windows.h"
#include "commdlg.h"

#ifdef _WIN32
#ifndef _INC_VFW
#include <vfw.h>
#endif
#else
#include "commdlg.h"
#endif

#include "twain.h"

#ifdef _WIN32
  #define EZTAPI WINAPI
#else
  #define EZTAPI __export FAR PASCAL
#endif

#include "eztwain.h"

//------------ Constants and Macros

#define STATIC static
#ifdef __BORLANDC__
#define _WIN32
#endif

#ifdef _WIN32
  #define INT32 int
  #define DATAGROUP unsigned
  #define DSM_FILENAME "TWAIN_32.DLL"
  #define DSM_ENTRYPOINT "DSM_Entry"
  #define IsValidHandle(h) (h!=NULL)
  #define HUGEWRITE(fh, pb, bc) ((INT32)_lwrite(fh, pb, bc))
  #define FMEMSET(p, v, n) memset(p, v, n);
  #define FMEMCPY(p, q, n) memcpy(p, q, n);
#else
  #define INT32 long
  #define DATAGROUP unsigned long
  #define DSM_FILENAME "TWAIN.DLL"
  #define DSM_ENTRYPOINT "DSM_ENTRY"
  #define VALID_HANDLE 32
  #define IsValidHandle(h) ((h!=0) && ((h) >= 32))
  #define HUGEWRITE(fh, pb, bc) _hwrite(fh, pb, bc)
  #define FMEMSET(p, v, n) _fmemset(p, v, n);
  #define FMEMCPY(p, q, n) _fmemcpy(p, q, n);
#endif

#define MAX_IMAGES 999
#define TW_CALLBACK_REGISTERED 0xf0f0f

typedef enum {
	ED_NONE,
	ED_START_TRIPLET_ERRS,
	ED_CAP_GET,				// MSG_GET triplet on a capability failed
	ED_CAP_SET,				// MSG_SET triplet on capability failed
	ED_DSM_FAILURE,			// TWAIN DSM returned TWRC_FAILURE
	ED_DS_FAILURE,			// source returned TWRC_FAILURE
	ED_END_TRIPLET_ERRS,
	ED_NOT_STATE_4,			// operation invoked in wrong state
	ED_NULL_HCON,			// MSG_GET returned a null container handle
	ED_BAD_HCON,			// MSG_GET returned an invalid/unlockable container handle
	ED_BAD_CONTYPE,			// returned container ConType is not valid.
	ED_BAD_ITEMTYPE,		// returned container ItemType is not valid.
	ED_CAP_GET_EMPTY,		// returned container has 0 items.
	ED_CAP_SET_EMPTY,		// trying to restrict a cap to empty set
} ErrorDetail;

const char *pszErrDescrip[] =
	{	"[no details available]",
		"",
		"DAT_CAPABILITY/MSG_GET failed",
		"DAT_CAPABILITY/MSG_SET failed",
		"Source Manager operation failed",
		"DataSource operation failed",
		"",
		"TWAIN session not in State 4 (Source Open)",
		"MSG_GET returned a NULL container handle",
		"MSG_GET returned an invalid container handle",
		"Returned container is not valid type",
		"Returned container has invalid ItemType",
		"Returned container is empty",
		"App and source found NO values in common",
	};

const char *pszRC[] = {
	"TWRC_SUCCESS",
	"TWRC_FAILURE",
	"TWRC_CHECKSTATUS ('tried hard')",
	"TWRC_CANCEL",
	"TWRC_DSEVENT",
	"TWRC_NOTDSEVENT",
	"TWRC_XFERDONE",
	"TWRC_ENDOFLIST",
};

const char *pszCC[] = {
	"TWCC_SUCCESS",
	"TWCC_BUMMER (Failure due to unknown causes)",
	"TWCC_LOWMEMORY",
	"TWCC_NODS (No Data Source)",
	"TWCC_MAXCONNECTIONS (DS is connected to max possible apps)",
	"TWCC_OPERATIONERROR (DS or DSM reported error, app shouldn't)",
	"TWCC_BADCAP (Unknown capability)",
	"7 (undefined)",
	"8 (undefined)",
	"TWCC_BADPROTOCOL (Unrecognized triplet)",
	"TWCC_BADVALUE (Data parameter out of range)",
	"TWCC_SEQERROR (Triplet out of sequence)",
	"TWCC_BADDEST (Unknown dest. App/Src in DSM_Entry)",
};

//------------ Global variables

STATIC int			iAvailable;			// TWAIN available: 0:unknown, -1:No, 1:Yes
STATIC int			nState = 1;			// TWAIN state (per the standard)
STATIC int			nErrDetail;			// detailed error code
STATIC unsigned		nErrRC, nErrCC;		// result code and condition code for last error
STATIC char			szMsg[256];			// scratch buffer for messages
STATIC DSMENTRYPROC	pDSM_Entry;			// entry point of Data Source Manager (TWAIN.DLL)
STATIC HANDLE		hDSMLib;			// handle of DSM
STATIC TW_IDENTITY	AppId = {			// application identity structure
	0,									// Id, filled in by DSM
	{ 1, 0, TWLG_USA, TWCY_USA, "<?>"},	// Version
	 TWON_PROTOCOLMAJOR,
	 TWON_PROTOCOLMINOR,
	 DG_IMAGE | DG_CONTROL,
	 "<?>",								// Mfg
	 "<?>",								// Family
	 "<?>"								// Product
	 };
STATIC TW_IDENTITY	SourceId;			// source identity structure
STATIC BOOL			bHideUI;			// allow source u/i to be hidden
STATIC TW_USERINTERFACE twUI;
STATIC TW_PENDINGXFERS pendingXfers;
STATIC HANDLE		hDib;				// bitmap returned by native transfer
STATIC TW_INT16		rc;					// result code
STATIC HINSTANCE	hinstLib;			// instance handle for this DLL

STATIC HANDLE hDibList[MAX_IMAGES];
STATIC TW_INT32 nDibs;
STATIC HDIBCALLBACKPROC lpfnDibCallback;
STATIC int hDibCallback_registered = 0;

const char szInsuffMem[] = "Insufficient Memory";	// error message
STATIC int bTrace = 0;  // debugging helper

//------------ Forward declarations

void TWAIN_NativeXferReady(LPMSG pmsg);
HWND CreateProxyWindow(void);
unsigned Intersect16(unsigned wMask, unsigned nItems, TW_UINT16 far *pItem);
unsigned BitCount(unsigned W);
void TWAIN_ErrorBox(const char *szMsg);
int RecordError(ErrorDetail ed);
void ClearError(void);
void TWAIN_ReportLastError(LPSTR lpzGeneral);
// TW_UINT32 ToFix32(double r);
// double Fix32ToFloat(TW_FIX32 fix);
// above functions implemented on the Delphi side to avoid need for floating
// point library functions --DSN 7/98
void assert(int);

//------------ Public functions
// the two functions below are implemented by hand vs. the C RTL so that the
// resultant OBJ can be neatly linked into a Delphi DCU.
void assert(int a)
{
  if (a == 0)
	  MessageBox(NULL, "Assertion failed", "EZTWAIN", MB_OK);
}

void *memset(void *s, int c, size_t n)
{
	size_t j;
	char *p;
	p = (char *) s;

	for (j = 0; j < n; j++)
		p[j] = (char) c;

	return s;
}

void *memcpy(void *dest, const void *src, size_t n)
{
	size_t j;
	char *pdest, *psrc;
	pdest = (char *) dest;
	psrc = (char *)src;
	for (j = 0; j < n; j++)
		pdest[j] = psrc[j];

	return dest;
}

#ifdef _WIN32

// Win32 DLL main
/*BOOL WINAPI DllMain(HANDLE hModule,
						  ULONG  ulEvent,
						  LPVOID lpReserved)
{
	return 1;
}*/

#else

// Win16 DLL initialization and termination routines
int CALLBACK __export LibMain(HINSTANCE hinst, WORD wDataSeg, WORD cbHeapSize, LPSTR lpszCmdLine)
{
	wDataSeg = wDataSeg; cbHeapSize = cbHeapSize; lpszCmdLine = lpszCmdLine;

	hinstLib = hinst;
	return 1;		// indicate success
} // LibMain


int FAR PASCAL __export _WEP(int x)
{
	x = x;				// suppress 'is never used' warning
	return 1;
} // _WEP


#endif


void EZTAPI TWAIN_RegisterApp(	// record application information
	int		nMajorNum, int nMinorNum,	// major and incremental revision of application. E.g.
										// for version 2.1, nMajorNum == 2 and nMinorNum == 1
	int		nLanguage,					// language of this version (use TWLG_xxx from TWAIN.H)
	int		nCountry,					// country of this version (use TWCY_xxx from TWAIN.H)
	LPSTR	lpszVersion,				// version info string e.g. "1.0b3 Beta release"
	LPSTR	lpszMfg,					// name of manufacturer/developer e.g. "Crazbat Software"
	LPSTR	lpszFamily,					// product family e.g. "BitStomper"
	LPSTR	lpszProduct)				// specific product e.g. "BitStomper Deluxe Pro"
{
	 AppId.Id = 0;						// init to 0, but Source Manager will assign real value
    AppId.Version.MajorNum = nMajorNum;
    AppId.Version.MinorNum = nMinorNum;
    AppId.Version.Language = nLanguage;
    AppId.Version.Country  = nCountry;
    lstrcpy (AppId.Version.Info,  lpszVersion);

    AppId.ProtocolMajor =    TWON_PROTOCOLMAJOR;
	 AppId.ProtocolMinor =    TWON_PROTOCOLMINOR;
	 AppId.SupportedGroups =  DG_IMAGE | DG_CONTROL;
    lstrcpy (AppId.Manufacturer,  lpszMfg);
    lstrcpy (AppId.ProductFamily, lpszFamily);
    lstrcpy (AppId.ProductName,   lpszProduct);

} // TWAIN_RegisterApp


int EZTAPI TWAIN_SelectImageSource(HWND hwnd)
{

	int fSuccess = FALSE;
	int fProxyWindow = FALSE;

	if (!IsWindow(hwnd)) {
		if (hwnd != NULL) {
			TWAIN_ErrorBox("TWAIN_SelectImageSource: window handle is invalid");
			return FALSE;
		}
		hwnd = CreateProxyWindow();
		if (!IsWindow(hwnd)) {
			TWAIN_ErrorBox("TWAIN_SelectImageSource: Unable to create proxy window");
			return FALSE;
		}
		fProxyWindow = TRUE;
	}
	if (TWAIN_LoadSourceManager()) {
		if (TWAIN_OpenSourceManager(hwnd)) {
			TW_IDENTITY	NewSourceId;
#ifdef _WIN32
			FMEMSET(&NewSourceId, 0, sizeof NewSourceId);
#else
			// I will settle for the system default.  Shouldn't I get a highlight
			// on system default without this call?
			TWAIN_Mgr(DG_CONTROL, DAT_IDENTITY, MSG_GETDEFAULT, &NewSourceId);
#endif
			// Post the Select Source dialog
			fSuccess = TWAIN_Mgr(DG_CONTROL, DAT_IDENTITY, MSG_USERSELECT, &NewSourceId);
			 TWAIN_CloseSourceManager(hwnd);
		 } else {
			TWAIN_ErrorBox("Unable to open Source Manager (" DSM_FILENAME ")");
		 }
		 TWAIN_UnloadSourceManager();
	} else {
		TWAIN_ErrorBox("Unable to load Source Manager (" DSM_FILENAME ")");
	}
	 if (fProxyWindow) DestroyWindow(hwnd);

	return fSuccess;
} // TWAIN_SelectImageSource


HANDLE EZTAPI TWAIN_AcquireNative(HWND hwnd, unsigned wPixTypes)
{
	int fProxyWindow = FALSE;
	hDib = NULL;
	ClearError();			// clear error detail
	TWAIN_ClearDibList();

	if (!IsWindow(hwnd)) {
		// hwnd isn't a valid window handle - most likely NULL
		hwnd = CreateProxyWindow();
		if (hwnd) fProxyWindow = TRUE;
	}
	if (!IsWindow(hwnd)) {
		TWAIN_ErrorBox("Unable to create proxy window");
	} else if (!TWAIN_LoadSourceManager()) {
		TWAIN_ErrorBox("Unable to load Source Manager (" DSM_FILENAME ")");
	} else if (!TWAIN_OpenSourceManager(hwnd)) {
		TWAIN_ErrorBox("Unable to open Source Manager (" DSM_FILENAME ")");
	 } else if (!TWAIN_OpenDefaultSource()) {
		TWAIN_ReportLastError("Unable to open default Data Source.");
	} else if (!TWAIN_NegotiatePixelTypes(wPixTypes)) {
		TWAIN_ReportLastError("Failed to negotiate Pixel Type.");
	} else if (!TWAIN_EnableSource(hwnd)) {
		TWAIN_ReportLastError("Failed to enable Data Source.");
	} else {
		EnableWindow(hwnd, FALSE);
		// source is enabled, wait for transfer or source closed
		TWAIN_ModalEventLoop();

		EnableWindow(hwnd, TRUE);
	}

	// shut everything down in the right sequence
	// these routines do nothing if the corresponding 'open' failed
	TWAIN_DisableSource();
	TWAIN_CloseSource();
	 TWAIN_CloseSourceManager(hwnd);
	 TWAIN_UnloadSourceManager();

	 if (fProxyWindow) {
		DestroyWindow(hwnd);
	 }

	return hDib;
} // TWAIN_AcquireNative


void EZTAPI TWAIN_FreeNative(HANDLE hdib)
// Release the memory allocated to a native format image, as returned by TWAIN_AcquireNative.
// (For those coding in C or C++, this is just a call to GlobalFree.)
{
	if (hdib) GlobalFree(hdib);
} // TWAIN_FreeNative



int EZTAPI TWAIN_AcquireToClipboard(HWND hwndApp, unsigned wPixTypes)
// Like AcquireNative, but puts the resulting image, if any, into the system clipboard.
// Useful for environments like Visual Basic where it is hard to make direct use of a DIB handle.
// A return value of 1 indicates success, 0 indicates failure.
{
	int fOk = FALSE;
	HANDLE hDib = TWAIN_AcquireNative(hwndApp, wPixTypes);
	if (hDib) {
		if (OpenClipboard(hwndApp)) {
			if (EmptyClipboard()) {
				SetClipboardData(CF_DIB, hDib);
				fOk = TRUE;
				hDib = NULL;
			}
			CloseClipboard();
		}
		if (hDib) {
			// something went wrong, recycle the image
			GlobalFree(hDib);
		}
	}
	return fOk;		// failed
} // TWAIN_AcquireToClipboard


int EZTAPI TWAIN_AcquireToFilename(HWND hwndApp, char *pszFile)
// Adapted from a routine by David D. Henseler (ddh) of SOLUTIONS GmbH
{
	int result = -1;
	HANDLE	hDib = TWAIN_AcquireNative(hwndApp, TWAIN_ANYTYPE);
	if (hDib) {
		result = TWAIN_WriteNativeToFilename(hDib, pszFile);
		TWAIN_FreeNative(hDib);
	}
	return result;
} // TWAIN_AcquireToFile

//--------- Callback mechanism -------------
// These routines, added by DSN 7/98, allow the user to specify an
// optional callback function to be called each time a new image comes
// in.  This can be a potentially powerful way to increase the primary
// application's efficiency, because upon receipt of an hdib the app
// could start a background thread to begin processing the images as
// needed.  Why bother with this?  Because on my Pentium 150, the Windows
// NT task monitor indicates that when I download images at 112kbps that
// I'm only using 15% of the processor's power, and the remaining 85% of
// the time it is idle!  It's silly to wait to begin processing because
// there's so much untapped processing capacity here.

void EZTAPI TWAIN_RegisterCallback(HDIBCALLBACKPROC *fxn)
{
	  lpfnDibCallback = fxn;
	  hDibCallback_registered = TW_CALLBACK_REGISTERED;  // our signature, because I don't trust
													 // the supposed initialization to zero
													 // by the compiler
}

void EZTAPI TWAIN_UnRegisterCallback()
{
	  lpfnDibCallback = NULL;
	  hDibCallback_registered = TW_CALLBACK_REGISTERED;
}

///////////////////////////////////////////////////////////////////////
// DIB utilities

void EZTAPI TWAIN_ClearDibList()
/// new; added by DSN
/// note: user is responsible for calling TWAIN_FreeNative *before*
/// calling this function!

{
	  int i;
	  for (i = 0; i < MAX_IMAGES; i++)
			 hDibList[i] = 0;
	  nDibs = 0;
}

int EZTAPI TWAIN_GetNumDibs()
{
	  return nDibs;
}

HANDLE EZTAPI TWAIN_GetDib(int n)
{
	  return hDibList[n];
}
int EZTAPI TWAIN_DibDepth(HANDLE hdib)
{
	LPBITMAPINFOHEADER pbi = (LPBITMAPINFOHEADER)GlobalLock(hdib);
	int D = pbi->biBitCount;
	GlobalUnlock(hdib);
	return D;
} // TWAIN_DibDepth

int EZTAPI TWAIN_DibWidth(HANDLE hdib)
{
	LPBITMAPINFOHEADER pbi = (LPBITMAPINFOHEADER)GlobalLock(hdib);
	int W = (int)pbi->biWidth;
	GlobalUnlock(hdib);
	return W;
} // TWAIN_DibWidth


int EZTAPI TWAIN_DibHeight(HANDLE hdib)
{
	LPBITMAPINFOHEADER pbi = (LPBITMAPINFOHEADER)GlobalLock(hdib);
	int H = (int)pbi->biHeight;
	GlobalUnlock(hdib);
	return H;
} // TWAIN_DibHeight


static int DibNumColors(VOID FAR *pv)
{
	 LPBITMAPINFOHEADER    lpbi = ((LPBITMAPINFOHEADER)pv);
	 LPBITMAPCOREHEADER    lpbc = ((LPBITMAPCOREHEADER)pv);

	int nColors;

	 if (lpbi->biSize == sizeof(BITMAPCOREHEADER)) {
		nColors = 1 << lpbc->bcBitCount;
	 } else if (lpbi->biClrUsed == 0) {
		nColors = 1 << lpbi->biBitCount;
	} else {
        nColors = (int)lpbi->biClrUsed;
	}
	if (nColors > 256) nColors = 0;
    return nColors;
} // DibNumColors


int EZTAPI TWAIN_DibNumColors(HANDLE hdib)
// given a DIB handle, return the number of palette entries: 0,2,16, or 256
{
	VOID FAR *pv = GlobalLock(hdib);
	int nColors = DibNumColors(pv);
	GlobalUnlock(hdib);
    return nColors;
}


//---------------------------------------------------------------------------

const PALETTEENTRY peStock256[256] = {
	// from 0 .. 9 are Windows fixed colors
     0,   0,   0, 0,	// 000 always black
   128,   0,   0, 0,	// 001 dark red
     0, 128,   0, 0,	// 002 dark green
   128, 128,   0, 0,	// 003 dark brown
     0,   0, 128, 0,	// 004 dark blue
	128,   0, 128, 0,	// 005 dark purple
     0, 128, 128, 0,	// 006 dark teal
   192, 192, 192, 0,	// 007 light gray
	192, 220, 192, 0,	// 008 pale green
   166, 202, 240, 0,	// 009 sky blue
	  4,   4,   4, 4,	// 010 dark gray ramp
     8,   8,   8, 4,	// 011
	 12,  12,  12, 4,	// 012
    17,  17,  17, 4,	// 013
	 22,  22,  22, 4,	// 014
	 28,  28,  28, 4,	// 015
    34,  34,  34, 4,	// 016
    41,  41,  41, 4,	// 017
    85,  85,  85, 4,	// 018
    77,  77,  77, 4,	// 019
	 66,  66,  66, 4,	// 020
	 57,  57,  57, 4,	// 021
   255, 124, 128, 4,	// 022
   255,  80,  80, 4,	// 023
   214,   0, 147, 4,	// 024
   204, 236, 255, 4,	// 025
   239, 214, 198, 4,	// 026
   231, 231, 214, 4,	// 027
   173, 169, 144, 4,	// 028
    51,   0,   0, 4,	// 029
	102,   0,   0, 4,	// 030
   153,   0,   0, 4,	// 031 
   204,   0,   0, 4,	// 032
     0,  51,   0, 4,	// 033
	51,  51,   0, 4,	// 034
   102,  51,   0, 4,	// 035
   153,  51,   0, 4,	// 036
   204,  51,   0, 4,	// 037
   255,  51,   0, 4,	// 038
	  0, 102,   0, 4,	// 039
    51, 102,   0, 4,	// 040
   102, 102,   0, 4,	// 041
	153, 102,   0, 4,	// 042
	204, 102,   0, 4,	// 043
	255, 102,   0, 4,	// 044
     0, 153,   0, 4,	// 045     
	51, 153,   0, 4,	// 046
   102, 153,   0, 4,	// 047
	153, 153,   0, 4,	// 048
   204, 153,   0, 4,	// 049
   255, 153,   0, 4,	// 050
     0, 204,   0, 4,	// 051
    51, 204,   0, 4,	// 052
   102, 204,   0, 4,	// 053
	153, 204,   0, 4,	// 054
	204, 204,   0, 4,	// 055
   255, 204,   0, 4,	// 056
   102, 255,   0, 4,	// 057
   153, 255,   0, 4,	// 058
   204, 255,   0, 4,	// 059
     0,   0,  51, 4,	// 060
	 51,   0,  51, 4,	// 061
   102,   0,  51, 4,	// 062
   153,   0,  51, 4,	// 063
   204,   0,  51, 4,	// 064
   255,   0,  51, 4,	// 065
     0,  51,  51, 4,	// 066
    51,  51,  51, 4,	// 067
   102,  51,  51, 4,	// 068
   153,  51,  51, 4,	// 069
   204,  51,  51, 4,	// 070
	255,  51,  51, 4,	// 071
     0, 102,  51, 4,	// 072
	 51, 102,  51, 4,	// 073
   102, 102,  51, 4,	// 074
   153, 102,  51, 4,	// 075
	204, 102,  51, 4,	// 076
   255, 102,  51, 4,	// 077
	  0, 153,  51, 4,	// 078
    51, 153,  51, 4,	// 079
	102, 153,  51, 4,	// 080
   153, 153,  51, 4,	// 081
	204, 153,  51, 4,	// 082
   255, 153,  51, 4,	// 083
     0, 204,  51, 4,	// 084
    51, 204,  51, 4,	// 085
   102, 204,  51, 4,	// 086
   153, 204,  51, 4,	// 087
	204, 204,  51, 4,	// 088
	255, 204,  51, 4,	// 089
    51, 255,  51, 4,	// 090
   102, 255,  51, 4,	// 091
	153, 255,  51, 4,	// 092
   204, 255,  51, 4,	// 093
   255, 255,  51, 4,	// 094
     0,   0, 102, 4,	// 095
    51,   0, 102, 4,	// 096
   102,   0, 102, 4,	// 097
   153,   0, 102, 4,	// 098
	204,   0, 102, 4,	// 099
   255,   0, 102, 4,	// 100
     0,  51, 102, 4,	// 101
    51,  51, 102, 4,	// 102
   102,  51, 102, 4,	// 103
   153,  51, 102, 4,	// 104
   204,  51, 102, 4,	// 105
   255,  51, 102, 4,	// 106
	  0, 102, 102, 4,	// 107
    51, 102, 102, 4,	// 108
   102, 102, 102, 4,	// 109
	153, 102, 102, 4,	// 110
   204, 102, 102, 4,	// 111
	  0, 153, 102, 4,	// 112
    51, 153, 102, 4,	// 113
	102, 153, 102, 4,	// 114
   153, 153, 102, 4,	// 115
	204, 153, 102, 4,	// 116
   255, 153, 102, 4,	// 117
     0, 204, 102, 4,	// 118
    51, 204, 102, 4,	// 119
   153, 204, 102, 4,	// 120
   204, 204, 102, 4,	// 121
	255, 204, 102, 4,	// 122
	  0, 255, 102, 4,	// 123
    51, 255, 102, 4,	// 124
   153, 255, 102, 4,	// 125
   204, 255, 102, 4,	// 126
	255,   0, 204, 4,	// 127
   204,   0, 255, 4,	// 128
     0, 153, 153, 4,	// 129
   153,  51, 153, 4,	// 130
   153,   0, 153, 4,	// 131
   204,   0, 153, 4,	// 132
     0,   0, 153, 4,	// 133
    51,  51, 153, 4,	// 134
   102,   0, 153, 4,	// 135
   204,  51, 153, 4,	// 136
   255,   0, 153, 4,	// 137
     0, 102, 153, 4,	// 138
    51, 102, 153, 4,	// 139
   102,  51, 153, 4,	// 140
   153, 102, 153, 4,	// 141
   204, 102, 153, 4,	// 142
   255,  51, 153, 4,	// 143
    51, 153, 153, 4,	// 144
   102, 153, 153, 4,	// 145
	153, 153, 153, 4,	// 146
   204, 153, 153, 4,	// 147
	255, 153, 153, 4,	// 148
     0, 204, 153, 4,	// 149
	 51, 204, 153, 4,	// 150
   102, 204, 102, 4,	// 151
   153, 204, 153, 4,	// 152
   204, 204, 153, 4,	// 153
	255, 204, 153, 4,	// 154
	  0, 255, 153, 4,	// 155
	 51, 255, 153, 4,	// 156
	102, 204, 153, 4,	// 157
   153, 255, 153, 4,	// 158
   204, 255, 153, 4,	// 159
   255, 255, 153, 4,	// 160
     0,   0, 204, 4,	// 161
    51,   0, 153, 4,	// 162
   102,   0, 204, 4,	// 163
   153,   0, 204, 4,	// 164
   204,   0, 204, 4,	// 165
     0,  51, 153, 4,	// 166
    51,  51, 204, 4,	// 167
   102,  51, 204, 4,	// 168
   153,  51, 204, 4,	// 169
	204,  51, 204, 4,	// 170
   255,  51, 204, 4,	// 171
     0, 102, 204, 4,	// 172
    51, 102, 204, 4,	// 173
   102, 102, 153, 4,	// 174
   153, 102, 204, 4,	// 175
   204, 102, 204, 4,	// 176
   255, 102, 153, 4,	// 177
     0, 153, 204, 4,	// 178
    51, 153, 204, 4,	// 179
	102, 153, 204, 4,	// 180
   153, 153, 204, 4,	// 181
	204, 153, 204, 4,	// 182
	255, 153, 204, 4,	// 183
	  0, 204, 204, 4,	// 184
	 51, 204, 204, 4,	// 185
   102, 204, 204, 4,	// 186
   153, 204, 204, 4,	// 187
   204, 204, 204, 4,	// 188
   255, 204, 204, 4,	// 189
	  0, 255, 204, 4,	// 190
	 51, 255, 204, 4,	// 191
   102, 255, 153, 4,	// 192
   153, 255, 204, 4,	// 193
   204, 255, 204, 4,	// 194
   255, 255, 204, 4,	// 195
    51,   0, 204, 4,	// 196
   102,   0, 255, 4,	// 197
   153,   0, 255, 4,	// 198
     0,  51, 204, 4,	// 199
    51,  51, 255, 4,	// 200
   102,  51, 255, 4,	// 201
   153,  51, 255, 4,	// 202
   204,  51, 255, 4,	// 203
	255,  51, 255, 4,	// 204
     0, 102, 255, 4,	// 205
    51, 102, 255, 4,	// 206
   102, 102, 204, 4,	// 207
   153, 102, 255, 4,	// 208
   204, 102, 255, 4,	// 209
   255, 102, 204, 4,	// 210
	  0, 153, 255, 4,	// 211
    51, 153, 255, 4,	// 212
   102, 153, 255, 4,	// 213
	153, 153, 255, 4,	// 214
   204, 153, 255, 4,	// 215
	255, 153, 255, 4,	// 216
     0, 204, 255, 4,	// 217
	 51, 204, 255, 4,	// 218
   102, 204, 255, 4,	// 219
   153, 204, 255, 4,	// 220
   204, 204, 255, 4,	// 221
   255, 204, 255, 4,	// 222
    51, 255, 255, 4,	// 223
	102, 255, 204, 4,	// 224
	153, 255, 255, 4,	// 225
   204, 255, 255, 4,	// 226
   255, 102, 102, 4,	// 227
   102, 255, 102, 4,	// 228
   255, 255, 102, 4,	// 229
   102, 102, 255, 4,	// 230
   255, 102, 255, 4,	// 231
   102, 255, 255, 4,	// 232
   165,   0,  33, 4,	// 233
    95,  95,  95, 4,	// 234
   119, 119, 119, 4,	// 235 
   134, 134, 134, 4,	// 236
   150, 150, 150, 4,	// 237
	203, 203, 203, 4,	// 238
	178, 178, 178, 4,	// 239
   215, 215, 215, 4,	// 240
   221, 221, 221, 4,	// 241
   227, 227, 227, 4,	// 242
   234, 234, 234, 4,	// 243
   241, 241, 241, 4,	// 244
   248, 248, 248, 4,	// 245
   // 246 - 255 are Windows fixed colors    
	255, 251, 240, 0,	// 246
	160, 160, 164, 0,	// 247
   128, 128, 128, 0,	// 248
	255,   0,   0, 0,	// 249
     0, 255,   0, 0,	// 250
	255, 255,   0, 0,	// 251
     0,   0, 255, 0,	// 252
   255,   0, 255, 0,	// 253
     0, 255, 255, 0,	// 254
   255, 255, 255, 0,	// 255 always white 
};

HPALETTE EZTAPI TWAIN_CreateDibPalette (HANDLE hdib)
// given a pointer to a locked DIB, returns a handle to a plausible logical
// palette to be used for rendering the DIB
// For 24-bit dibs, returns a default palette.
{
    HPALETTE            hPalette = NULL;

	LPBITMAPINFOHEADER	lpbmi = (LPBITMAPINFOHEADER)GlobalLock(hdib);

    if (lpbmi) {
	    WORD nColors = TWAIN_DibNumColors(hdib);			// size of DIB palette
		WORD nEntries = nColors ? nColors : 256;			// size of palette to create
		// allocate logical palette structure
		 LOGPALETTE *pPal = (LOGPALETTE*)LocalAlloc(LPTR,
					sizeof(LOGPALETTE) + nEntries * sizeof(PALETTEENTRY));
		if (pPal) {
			// Fill in the palette entries
			pPal->palNumEntries = nEntries;
			pPal->palVersion    = 0x300;			// Windows 3.0 or later
			if (nColors) {
				// from the DIB color table
				// Get a pointer to the color table
				RGBQUAD FAR *pRgb = (RGBQUAD FAR *)((LPSTR)lpbmi + (WORD)lpbmi->biSize);
				 WORD i;
				// copy from DIB palette (triples, by the way) into the LOGPALETTE
				for (i = 0; i < nEntries; i++) {
					pPal->palPalEntry[i].peRed   = pRgb[i].rgbRed;
					pPal->palPalEntry[i].peGreen = pRgb[i].rgbGreen;
					pPal->palPalEntry[i].peBlue  = pRgb[i].rgbBlue;
					pPal->palPalEntry[i].peFlags = (BYTE)0;
				} // for
			} else {
				// Deep Dib: Synthesize halftone palette
				memcpy(pPal->palPalEntry, peStock256, sizeof peStock256);
			}
	
			// create a logical palette
			hPalette = CreatePalette(pPal);
			LocalFree((HANDLE)pPal);
		}
	
		GlobalUnlock(hdib);
	}
    return hPalette;
} // TWAIN_CreateDibPalette


LPBYTE DibBits(LPBITMAPINFOHEADER lpdib)
// Given a pointer to a locked DIB, return a pointer to the actual bits (pixels)
{
	 DWORD dwColorTableSize = (DWORD)(DibNumColors(lpdib) * sizeof(RGBQUAD));
    LPBYTE lpBits = (LPBYTE)lpdib + lpdib->biSize + dwColorTableSize;

    return lpBits;
} // end DibBits


void EZTAPI TWAIN_DrawDibToDC(HDC hDC, int dx, int dy, int w, int h,
									 HANDLE hdib, int sx, int sy)
{
	LPBITMAPINFOHEADER lpbmi = (LPBITMAPINFOHEADER)GlobalLock(hdib);
	if (lpbmi) {
/*#ifdef _WIN32
		HDRAWDIB hdd = DrawDibOpen();
		if (hdd) {
			DrawDibDraw(hdd, hDC,
						dx, dy, w, h,
						lpbmi, DibBits(lpbmi),
						sx, sy, w, h,
						0
						);
			DrawDibClose(hdd);
		}
#else*/
		StretchDIBits(hDC,
					dx, dy,			// x,y destination
					w, h,			// pixel width & height in destination
					sx, sy,			// x,y source
					w, h,			// width & height in source
					DibBits(lpbmi), // pointer to 'bits' - the pixels
					(LPBITMAPINFO)lpbmi,
					DIB_RGB_COLORS,	// DIB palette is (presumably?) RGB entries
					SRCCOPY);		// raster operation (copy)
//#endif
		GlobalUnlock(hdib);
	}
} // TWAIN_DrawDibToDC


///////////////////////////////////////////////////////////////////////
// TWAIN general


int EZTAPI TWAIN_IsAvailable(void)
// return 1 if TWAIN services are available, 0 if 'TWAIN-less' system
{
	if (pDSM_Entry) return TRUE;		// SM currently loaded

	if (iAvailable == 0) {
		if (TWAIN_LoadSourceManager()) {
			iAvailable = 1;
			TWAIN_UnloadSourceManager();
		} else {
			iAvailable = -1;
		}
	}
	return (iAvailable > 0);
} // TWAIN_IsAvailable


int EZTAPI TWAIN_EasyVersion(void)
// Returns the version number of EZTWAIN.DLL, multiplied by 100.
// So e.g. version 2.01 will return 201 from this call.
{
	return VERSION;
} // TWAIN_EasyVersion


int EZTAPI TWAIN_State(void)
// Returns the TWAIN Protocol State per the spec.
{
	return nState;
} 

int EZTAPI TWAIN_GetHideUI(void)
{
	return bHideUI;
} // TWAIN_GetHideUI

void EZTAPI TWAIN_SetHideUI(int fHide)
{
	bHideUI = (fHide != 0);
} // TWAIN_SetHideUI


///////////////////////////////////////////////////////////////////////
// TWAIN State Changers

int EZTAPI TWAIN_LoadSourceManager(void)
{
	char		szSMDir[128];
	int			cc;
	OFSTRUCT	of;

	if (nState >= 2) return TRUE;			// DSM already loaded

	GetWindowsDirectory(szSMDir, sizeof(szSMDir));
	cc = lstrlen(szSMDir);
	if (cc && szSMDir[cc-1] != ':') {
		lstrcat(szSMDir, "\\");
	}
	lstrcat(szSMDir, DSM_FILENAME);			// could crash!
	if (OpenFile(szSMDir, &of, OF_EXIST) != -1) {
		hDSMLib = LoadLibrary(szSMDir);
	} else {
		hDSMLib = NULL;
	}
	if (IsValidHandle(hDSMLib)) {
		pDSM_Entry = (DSMENTRYPROC) GetProcAddress(hDSMLib, DSM_ENTRYPOINT);
		if (pDSM_Entry) {
			iAvailable = 1;
			nState = 2;
		} else {
			FreeLibrary(hDSMLib);
			hDSMLib = NULL;
		}
	} else {
		pDSM_Entry = NULL;
	}

	return (nState >= 2);
} // TWAIN_LoadSourceManager


static TW_INT32 hwnd32SM;

int EZTAPI TWAIN_OpenSourceManager(HWND hwnd)
{
	hwnd32SM = (TW_INT32)hwnd;

	if (TWAIN_LoadSourceManager() &&
		TWAIN_Mgr(DG_CONTROL, DAT_PARENT, MSG_OPENDSM, &hwnd32SM)) {
		nState = TWAIN_SM_OPEN;
	}

	return (nState >= TWAIN_SM_OPEN);
} // TWAIN_OpenSourceManager


int EZTAPI TWAIN_OpenDefaultSource(void)
{
	if (nState != 3) return FALSE;
	// open the system default source
	SourceId.ProductName[0] = '\0';
	SourceId.Id = 0;
	if (TWAIN_Mgr(DG_CONTROL, DAT_IDENTITY, MSG_OPENDS, &SourceId)) {
		nState = 4;
	} else {
		RecordError(ED_DSM_FAILURE);
	}

	return (nState == 4);
} // TWAIN_OpenDefaultSource


int EZTAPI TWAIN_EnableSource(HWND hwnd)
{
	if (nState != 4) return FALSE;

	twUI.ShowUI = !bHideUI;
	twUI.hParent = (TW_HANDLE)hwnd;
	TWAIN_DS(DG_CONTROL, DAT_USERINTERFACE, MSG_ENABLEDS, &twUI);
	if (rc == TWRC_FAILURE) {
		RecordError(ED_DS_FAILURE);
	} else {
		// rc could be either SUCCESS or CHECKSTATUS
		nState = 5;
		// note, source will set twUI.ModalUI.
	}
	return (nState == 5);
} // TWAIN_EnableSource


int EZTAPI TWAIN_DisableSource(void)
{
	if (nState == 5 &&
		TWAIN_DS(DG_CONTROL, DAT_USERINTERFACE, MSG_DISABLEDS, &twUI)) {
		nState = 4;
	}
	return (nState <= 4);
} // TWAIN_DisableSource


int EZTAPI TWAIN_CloseSource(void)
{
	rc = TWRC_SUCCESS;

	if (nState == 5) TWAIN_DisableSource();
	if (nState == 4 &&
		TWAIN_Mgr(DG_CONTROL, DAT_IDENTITY, MSG_CLOSEDS, &SourceId)) {
		nState = 3;
	}
	return (nState <= 3);
} // TWAIN_CloseSource


int EZTAPI TWAIN_CloseSourceManager(HWND hwnd)
{
	TW_INT32 hwnd32 = (TW_INT32)hwnd;

	rc = TWRC_SUCCESS;

	if (TWAIN_CloseSource() &&
		TWAIN_Mgr(DG_CONTROL, DAT_PARENT, MSG_CLOSEDSM, &hwnd32)) {
		nState = 2;
	}
	return (nState <= 2);
} // TWAIN_CloseSourceManager


int EZTAPI TWAIN_UnloadSourceManager(void)
{
	if (nState == 2) {

		if (hDSMLib) {
			FreeLibrary(hDSMLib);
			hDSMLib = NULL;
		}
		pDSM_Entry = NULL;
		nState = 1;
	}
	return (nState == 1);
} // TWAIN_UnloadSourceManager



void EZTAPI TWAIN_ModalEventLoop(void)
{
	MSG msg;

	while ((nState >= 5) && !hDib && GetMessage((LPMSG)&msg, NULL, 0, 0)) {
		if (!TWAIN_MessageHook ((LPMSG)&msg)) {
			TranslateMessage ((LPMSG)&msg);
			DispatchMessage ((LPMSG)&msg);
		}
	} // while
} // TWAIN_ModalEventLoop


int EZTAPI TWAIN_MessageHook(LPMSG lpmsg)
// returns TRUE if msg processed by TWAIN (source)
{
	int   bProcessed = FALSE;

	if (nState >= 5) {
		// source enabled
		TW_EVENT	twEvent;
		twEvent.pEvent = (TW_MEMREF)lpmsg;
		twEvent.TWMessage = MSG_NULL;
		// see if source wants to process (eat) the message
		TWAIN_DS(DG_CONTROL, DAT_EVENT, MSG_PROCESSEVENT, &twEvent);
		bProcessed = (rc == TWRC_DSEVENT);
		switch (twEvent.TWMessage) {
			case MSG_XFERREADY:
				nState = 6;
				// TWAIN_NativeXferReady(lpmsg);  Spike's original code
				TWAIN_NativeXferGetAll(lpmsg);  // replace with this -- DSN 07/98
				break;
			case MSG_CLOSEDSREQ:
				TWAIN_DisableSource();
				break;
			case MSG_NULL:
				// no message returned from DS
				break;
		} // switch
	 }
	return bProcessed;
} // TWAIN_MessageHook



void TWAIN_NativeXferReady(LPMSG pmsg)
// Spike's original code.  Note that it doesn't get called any more; instead,
// Message_Hook calls NativeXferGetAll, which supports multiple image
// acquisition. -- DSN 7/13/98
{
	TW_UINT32		hNative;

	 pmsg = pmsg;		// suppress warning

	assert(nState == 6);
	TWAIN_DS(DG_IMAGE, DAT_IMAGENATIVEXFER, MSG_GET, &hNative);

	if (rc != TWRC_XFERDONE) hDib = NULL;

	switch (rc) {
		case TWRC_XFERDONE:
			// hNative contains a valid native image (handle)
			// application is responsible for de-allocating.
			nState = 7;
			// Need to acknowledge the end of the transfer
			hDib = (HANDLE)hNative;
			// above line added by DSN: add to list of hdibs and advance counter
			break;

		case TWRC_CANCEL:
			// user cancelled the transfer
			// hNative is invalid
			nState = 7;
			// acknowledge the end of the transfer
			break;

		case TWRC_FAILURE:
		default:
			// the transfer failed (e.g. insufficient memory)
			// hNative is invalid
			// check condition code for more info
			nState = 6;
			// state transition failed
			// image data is still pending
			break;
	} // switch
	assert(nState >= 6);

	TWAIN_AbortAllPendingXfers();	// state 7 or 6 -> state 5

} // TWAIN_NativeXferReady


int EZTAPI TWAIN_AbortAllPendingXfers(void)
// Not used any more because its only caller was TWAIN_NativeXferReady, which
// is now ignored in favor or TWAIN_NativeXferGetAll.  -- DSN 7/13/98
{
	if (nState == 7 &&
		TWAIN_DS(DG_CONTROL, DAT_PENDINGXFERS, MSG_ENDXFER, &pendingXfers)) {
		nState = pendingXfers.Count ? 6 : 5;
	}
	if (nState == 6 &&
		TWAIN_DS(DG_CONTROL, DAT_PENDINGXFERS, MSG_RESET, &pendingXfers)) {
		nState = 5;
	}
	return (nState <= 5);
} // TWAIN_AbortAllPendingXfers


void EZTAPI TWAIN_NativeXferGetAll(LPMSG pmsg)
// A modified version of Spike's original code that loops through until
// no more images are left. -- DSN 7/98
{
	TW_UINT32		hNative;

	pmsg = pmsg;		// suppress warning; (sic)  -- does this do anything?  DSN
	assert(nState == 6);

	do {
		TWAIN_DS(DG_IMAGE, DAT_IMAGENATIVEXFER, MSG_GET, &hNative);

		if (rc != TWRC_XFERDONE) hDib = NULL;

		switch (rc) {
			case TWRC_XFERDONE:
				// hNative contains a valid native image (handle)
				// application is responsible for de-allocating.
				nState = 7;
				// Need to acknowledge the end of the transfer
				hDib = (HANDLE)hNative;  // thus hDib represents MOST RECENT image!
				hDibList[nDibs] = hDib;
				// added by DSN: add to list of hdibs and advance counter
				if (hDibCallback_registered == TW_CALLBACK_REGISTERED)    // user may specify callback
					  (*lpfnDibCallback)(hDibList[nDibs], nDibs);   // great for multithreading!
				nDibs++;
				break;

			case TWRC_CANCEL:
				// user cancelled the transfer
				// hNative is invalid
				nState = 7;
				// acknowledge the end of the transfer
				break;

			case TWRC_FAILURE:
				default:
				// the transfer failed (e.g. insufficient memory)
				// hNative is invalid
				// check condition code for more info
				nState = 6;
				// state transition failed
				// image data is still pending
				break;
		} // switch
		assert(nState >= 6);
		if (nState == 7 && TWAIN_DS(DG_CONTROL, DAT_PENDINGXFERS, MSG_ENDXFER, &pendingXfers))
			nState = pendingXfers.Count ? 6 : 5;
	} while (nState == 6);

	//	TWAIN_AbortAllPendingXfers();	// state 7 or 6 -> state 5
	// Commented out the above; we want to get all xfers!!

} // TWAIN_NativeXferReady
///////////////////////////////////////////////////////////////////////
// DIB/BMP File I/O

int EZTAPI TWAIN_WriteNativeToFilename(HANDLE hdib, LPCSTR pszFile)
// Writes a DIB handle to a .BMP file
//
// hdib		= DIB handle, as returned by TWAIN_AcquireNative
// pszFile	= far pointer to NUL-terminated filename
// If pszFile is NULL or points to a null string, prompts the user
// for the filename with a standard file-save dialog.
//
// Return values:
//	 0	success
//	-1	user cancelled File Save dialog
//	-2	file open error (invalid path or name, or access denied)
//	-3	(weird) unable to lock DIB - probably an invalid handle.
//	-4	writing BMP data failed, possibly output device is full
{
	int result;
	char szFile[256];
	HFILE fh;
	OFSTRUCT ofs;

	if (!pszFile || !*pszFile) {
		// prompt for filename
		OPENFILENAME ofn;
		int nExt;

		FMEMSET(&ofn, 0, sizeof ofn);
		szFile[0] = '\0';
		ofn.lStructSize = sizeof(OPENFILENAME);
		ofn.hwndOwner = NULL;
		ofn.lpstrFilter = "Windows Bitmap (*.bmp)\0*.bmp\0\0";
		ofn.lpstrFile= szFile;
		ofn.nMaxFile = sizeof(szFile) - 5;
		ofn.Flags = OFN_OVERWRITEPROMPT | OFN_HIDEREADONLY |
					OFN_NOREADONLYRETURN;

		if (!GetSaveFileName(&ofn)) {
			return -1;					// user cancelled dialog
		}
		// supply default extension - GetSaveFileName doesn't seem to do it!
		nExt = ofn.nFileExtension;
		if (nExt && !szFile[nExt]) {
			// no extension
			lstrcat(szFile, ".bmp");
		}
		pszFile = szFile;
	}

	result = -2;
	fh = OpenFile(pszFile , &ofs, OF_CREATE | OF_WRITE | OF_SHARE_EXCLUSIVE);
	if (fh != HFILE_ERROR) {
		result = TWAIN_WriteNativeToFile(hdib, fh);
		_lclose(fh);
	}
	return result;
} // TWAIN_WriteNativeToFilename


int EZTAPI TWAIN_WriteNativeToFile(HANDLE hdib, HFILE fh)
// Writes a DIB to a file in .BMP format.
//
// hdib		= DIB handle, as returned by TWAIN_AcquireNative
// fh		= file handle, as returned by C _open or Windows _lopen or OpenFile
//
// Return value as for TWAIN_WriteNativeToFilename
{
	int result = -3;
	LPBITMAPINFOHEADER lpbmi = (LPBITMAPINFOHEADER)GlobalLock(hdib);
	if (lpbmi) {
		result = -4;
		if (TWAIN_WriteDibToFile(lpbmi, fh)) {
			result = 0;			// success
		}
		GlobalUnlock(hdib);
	}
	return result;
} //  TWAIN_WriteNativeToFile


int EZTAPI TWAIN_WriteDibToFile(LPBITMAPINFOHEADER lpDIB, HFILE fh)
{
	BITMAPFILEHEADER		bfh;
	int						fOk = FALSE;
	int						nBPP = lpDIB->biBitCount;
	int						nColors = (int)lpDIB->biClrUsed;

	// figure out actual size of color table
	if (nColors == 0 && nBPP <= 8) {
		nColors = (1 << nBPP);
	}
	if (lpDIB->biCompression == BI_RGB) {
		// uncompressed bitmap, image size might not be set
		DWORD dwBytesPerRow = (((lpDIB->biWidth * nBPP) + 31) / 32) * 4;
		lpDIB->biSizeImage = dwBytesPerRow * lpDIB->biHeight;
	} else if (lpDIB->biSizeImage == 0) {
		// compressed bitmap, image size had damn well better be set!
		return FALSE;
		// This could be hacked around with something like this:
		//lpDIB->biSizeImage = GlobalSize((HANDLE)GlobalHandle(HIWORD(lpDIB)));
	}

	// Set up BMP header.
	bfh.bfType = 0x4d42;                // "BM"
	bfh.bfReserved1 = 0;
	bfh.bfReserved2 = 0;
	bfh.bfOffBits = sizeof(BITMAPFILEHEADER) +
					sizeof(BITMAPINFOHEADER) +
					sizeof(RGBQUAD) * nColors;
	bfh.bfSize = bfh.bfOffBits + lpDIB->biSizeImage;

	if (_lwrite(fh, (LPCSTR)&bfh, sizeof bfh) == sizeof bfh) {

		INT32 towrite = bfh.bfSize - (INT32)sizeof bfh;

		if (HUGEWRITE(fh, (LPCSTR)lpDIB, towrite) == towrite) {
			fOk = TRUE;
		}
	}

	return fOk;

} // TWAIN_WriteDibToFile


HANDLE EZTAPI TWAIN_LoadNativeFromFilename(LPCSTR pszFile)
// Load a .BMP file and return a DIB handle (as from AcquireNative.)
//
// pszFile	= far pointer to NUL-terminated filename
// If pszFile is NULL or points to a null string, prompts the user
// for the filename with a standard file-open dialog.
//
// Return value:
//	handle to a DIB if successful, otherwise NULL (0).
{
	HANDLE hdib = NULL;
	char szFile[256];
	HFILE fh;
	OFSTRUCT ofs;

	if (!pszFile || !*pszFile) {
		// prompt for filename
		OPENFILENAME ofn;
		int nExt;

		FMEMSET(&ofn, 0, sizeof ofn);
		szFile[0] = '\0';
		ofn.lStructSize = sizeof(OPENFILENAME);
		ofn.hwndOwner = NULL;
		ofn.lpstrFilter = "Windows Bitmaps (*.bmp)\0*.bmp\0\0";
		ofn.lpstrFile= szFile;
		ofn.nMaxFile = sizeof(szFile) - 5;
		ofn.Flags = OFN_OVERWRITEPROMPT | OFN_HIDEREADONLY |
					OFN_NOREADONLYRETURN;

		if (!GetOpenFileName(&ofn)) {
			return NULL;					// user cancelled dialog
		}
		// supply default extension - GetOpenFileName doesn't seem to do it!
		nExt = ofn.nFileExtension;
		if (nExt && !szFile[nExt]) {
			// no extension
			lstrcat(szFile, ".bmp");
		}
		pszFile = szFile;
	}

	fh = OpenFile(pszFile, &ofs, OF_READ | OF_SHARE_DENY_WRITE);
	if (fh != HFILE_ERROR) {
		hdib = TWAIN_LoadNativeFromFile(fh);
		_lclose(fh);
	}
	return hdib;
} // TWAIN_LoadNativeFromFilename


HANDLE EZTAPI TWAIN_LoadNativeFromFile(HFILE fh)
// Like LoadNativeFromFilename, but takes an already open file handle.
{
	HANDLE hdib;
	LPBYTE pbi;
	BITMAPFILEHEADER bmh;
	INT32 dibSize;
	// Read BMP file header and validate
	if (_lread(fh, &bmh, sizeof bmh) != sizeof bmh ||
		bmh.bfType != 0x4d42) {
		return NULL;
	}
	// Allocate global block for DIB
	dibSize = bmh.bfSize - sizeof bmh;
	hdib = GlobalAlloc(0, dibSize);
	pbi = (LPBYTE)GlobalLock(hdib);
	if (!hdib || !pbi) {
		return NULL;
	}

	// Read DIB from file
	if (_hread(fh, pbi, dibSize) != dibSize) {
		GlobalUnlock(hdib);
		GlobalFree(hdib);
		return NULL;
	}
	GlobalUnlock(hdib);
	return hdib;
} // TWAIN_LoadNativeFromFile

///////////////////////////////////////////////////////////////////////
// TWAIN State 4 Negotiation Functions

int EZTAPI TWAIN_NegotiateXferCount(int nXfers)
{
	return TWAIN_SetCapOneValue(CAP_XFERCOUNT, TWTY_INT16, nXfers);
} // TWAIN_NegotiateXferCount


int EZTAPI TWAIN_NegotiatePixelTypes(unsigned wPixTypes)
{
	TW_CAPABILITY 		cap;
	void far *			pv;
	int					fSuccess = FALSE;

	if (nState != TWAIN_SOURCE_OPEN) {
		return RecordError(ED_NOT_STATE_4);
	}

	if (TWAIN_ANYTYPE == wPixTypes) {
		return TRUE;			// that was easy!
	}
                                                                           
                                                                           
	// Fill in capability structure
	cap.Cap = ICAP_PIXELTYPE;			// capability id
	cap.ConType = TWON_ENUMERATION;		// favorite type of container (should be ignored...)

	if (!TWAIN_DS(DG_CONTROL, DAT_CAPABILITY, MSG_GET, (TW_MEMREF)&cap)) {
		return RecordError(ED_CAP_GET);
	}
	if (!cap.hContainer) {
		return RecordError(ED_NULL_HCON);
	}
	if (!(pv = GlobalLock(cap.hContainer))) {
		// this source is invalid, further negotiation is unlikely to succeed
		return RecordError(ED_BAD_HCON);
	}

	switch (cap.ConType) {

		case TWON_ENUMERATION: {
			TW_ENUMERATION far *pcon = (TW_ENUMERATION far *)pv;
			if (pcon->NumItems < 1) {
				RecordError(ED_CAP_GET_EMPTY);
			} else if (pcon->ItemType != TWTY_UINT16 && pcon->ItemType != TWTY_INT16) {
				RecordError(ED_BAD_ITEMTYPE);
			} else {
				pcon->CurrentIndex = TWON_DONTCARE32;	// don't change current value
				pcon->DefaultIndex = TWON_DONTCARE32;	// don't change default value
				pcon->NumItems = Intersect16(wPixTypes, (unsigned)pcon->NumItems, (TW_UINT16 far *)pcon->ItemList);
				fSuccess = (pcon->NumItems != 0);
				if (!fSuccess) RecordError(ED_CAP_SET_EMPTY);
			}
			break;
		}
		
		case TWON_ARRAY: {
			// this is technically illegal - TWAIN 1.5, p9-30, Containers for MSG_GET: TW_ENUMERATION, TW_ONEVALUE
			TW_ARRAY far *pcon = (TW_ARRAY far *)pv;
			if (pcon->NumItems < 1) {
				RecordError(ED_CAP_GET_EMPTY);
			} else if (pcon->ItemType != TWTY_UINT16 && pcon->ItemType != TWTY_INT16) {
				RecordError(ED_BAD_ITEMTYPE);
			} else {
				pcon->NumItems = Intersect16(wPixTypes, (unsigned)pcon->NumItems, (TW_UINT16 far *)pcon->ItemList);
				fSuccess = (pcon->NumItems != 0);
				if (!fSuccess) RecordError(ED_CAP_SET_EMPTY);
			}
			break;
		}

		case TWON_ONEVALUE: {
			TW_ONEVALUE far *pcon = (TW_ONEVALUE far *)pv;
			fSuccess = ((1 << pcon->Item) & wPixTypes);
			if (!fSuccess) RecordError(ED_CAP_SET_EMPTY);
			break;
		}
		
		default:
			// something we don't understand, abandon negotiations
			RecordError(ED_BAD_CONTYPE);
			break;
	} // switch

	GlobalUnlock(cap.hContainer);

	if (fSuccess) {
		// For enums (and arrays) send intersection back, to restrict it.
		// For one vals, don't bother - could only cause confusion.
		if (cap.ConType != TWON_ONEVALUE) {
			fSuccess = TWAIN_DS(DG_CONTROL, DAT_CAPABILITY, MSG_SET, (TW_MEMREF)&cap);
			if (!fSuccess) RecordError(ED_CAP_SET);
		}
	}
	GlobalFree(cap.hContainer);
	
	return fSuccess;
} // TWAIN_NegotiatePixelTypes


int EZTAPI TWAIN_GetCurrentUnits(void)
{
	int nUnits = TWUN_INCHES;
	TWAIN_GetCapCurrent(ICAP_UNITS, TWTY_UINT16, &nUnits);
	return nUnits;
} // TWAIN_GetCurrentUnits


int EZTAPI TWAIN_SetCurrentUnits(int nUnits)
// Negotiate the current pixel type for acquisition.
// Negotiation is only allowed in State 4 (TWAIN_SOURCE_OPEN)
// The source may select this pixel type, but don't assume it will.
{
	return TWAIN_SetCapOneValue(ICAP_UNITS, TWTY_UINT16, (TW_UINT16)nUnits);
} // TWAIN_SetCurrentUnits


int EZTAPI TWAIN_GetBitDepth(void)
// Ask the source for the current bitdepth.
// This value depends on the current PixelType.
// Bit depth is per color channel e.g. 24-bit RGB has bit depth 8.
// If anything goes wrong, this function returns 0.
{
	int nBits = 0;
	TWAIN_GetCapCurrent(ICAP_BITDEPTH, TWTY_UINT16, &nBits);
	return nBits;
} // TWAIN_GetBitDepth

int EZTAPI TWAIN_SetBitDepth(int nBits)
// (Try to) set the current bitdepth (for the current pixel type).
{
	return TWAIN_SetCapOneValue(ICAP_BITDEPTH, TWTY_UINT16, (TW_UINT16)nBits);
} // TWAIN_SetBitDepth


int EZTAPI TWAIN_GetPixelType(void)
// Ask the source for the current pixel type.
// If anything goes wrong (it shouldn't!), this function returns 0 (TWPT_BW).
{
	int nPixType = 0;
	TWAIN_GetCapCurrent(ICAP_PIXELTYPE, TWTY_UINT16, &nPixType);
	return nPixType;
} // TWAIN_GetPixelType

int EZTAPI TWAIN_SetCurrentPixelType(int nPixType)
// Negotiate the current pixel type for acquisition.
// Negotiation is only allowed in State 4 (TWAIN_SOURCE_OPEN)
// The source may select this pixel type, but don't assume it will.
{
	return TWAIN_SetCapOneValue(ICAP_PIXELTYPE, TWTY_UINT16, (TW_UINT16)nPixType);
} // TWAIN_SetCurrentPixelType


/*double EZTAPI TWAIN_GetCurrentResolution(void)
{
	TW_FIX32 res;
	TWAIN_GetCapCurrent(ICAP_XRESOLUTION, TWTY_FIX32, &res);

	return Fix32ToFloat(res);
} // TWAIN_GetCurrentResolution

int EZTAPI TWAIN_SetCurrentResolution(double dRes)
// Negotiate the current resolution for acquisition.
// Negotiation is only allowed in State 4 (TWAIN_SOURCE_OPEN)
// The source may select this resolution, but don't assume it will.
{
	return TWAIN_SetCapOneValue(ICAP_XRESOLUTION, TWTY_FIX32, ToFix32(dRes));
} // TWAIN_SetCurrentResolution

*/

int EZTAPI TWAIN_SetCapOneValue(unsigned Cap, unsigned ItemType, long ItemVal)
{
	TW_CAPABILITY	cap;
	pTW_ONEVALUE	pv;
	BOOL			bSuccess;

	if (nState != TWAIN_SOURCE_OPEN) {
		TWAIN_ErrorBox("Attempt to set capability outside State 4.");
		return FALSE;
	}

	cap.Cap = Cap;			// capability id
	cap.ConType = TWON_ONEVALUE;		// container type
	cap.hContainer = GlobalAlloc(GHND, sizeof (TW_ONEVALUE));
	if (!cap.hContainer) {
		TWAIN_ErrorBox(szInsuffMem);
		return FALSE;
	}
	pv = (pTW_ONEVALUE)GlobalLock(cap.hContainer);
	pv->ItemType = ItemType;
	pv->Item = ItemVal;
	GlobalUnlock(cap.hContainer);
	bSuccess = TWAIN_DS(DG_CONTROL, DAT_CAPABILITY, MSG_SET, (TW_MEMREF)&cap);
	GlobalFree(cap.hContainer);
	return bSuccess;
} // TWAIN_SetCapOneValue


const size_t nTypeSize[13] =
	{	sizeof (TW_INT8),
		sizeof (TW_INT16),
		sizeof (TW_INT32),
		sizeof (TW_UINT8),
		sizeof (TW_UINT16),
		sizeof (TW_UINT32),
		sizeof (TW_BOOL),
		sizeof (TW_FIX32),
		sizeof (TW_FRAME),
		sizeof (TW_STR32),
		sizeof (TW_STR64),
		sizeof (TW_STR128),
		sizeof (TW_STR255),
	};

// helper function:
int TypeMatch(unsigned nTypeA, unsigned nTypeB)
{
	// Integral types match if they are the same size.
	// All other types match only if they are equal
	return nTypeA == nTypeB ||
		   (nTypeA <= TWTY_UINT32 &&
		    nTypeB <= TWTY_UINT32 &&
		    nTypeSize[nTypeA] == nTypeSize[nTypeB]);
} // TypeMatch



int EZTAPI TWAIN_GetCapCurrent(unsigned Cap, unsigned ItemType, void FAR *pVal)
{
	TW_CAPABILITY 	cap;
	void far *		pv = NULL;
	BOOL			bSuccess = FALSE;

	assert(pVal != NULL);

	if (nState < TWAIN_SOURCE_OPEN) {
		TWAIN_ErrorBox("Attempt to get capability value below State 4.");
		return FALSE;
	}

	// Fill in capability structure
	cap.Cap = Cap;					// capability id
	cap.ConType = TWON_ONEVALUE;	// favorite type of container (should be ignored...)
	cap.hContainer = NULL;

	if (TWAIN_DS(DG_CONTROL, DAT_CAPABILITY, MSG_GETCURRENT, (TW_MEMREF)&cap) &&
	    cap.hContainer &&
	    (pv = GlobalLock(cap.hContainer))) {

		if (cap.ConType == TWON_ENUMERATION) {
			TW_ENUMERATION far *pcon = (TW_ENUMERATION far *)pv;
			TW_UINT32 index = pcon->CurrentIndex;
			if (index < pcon->NumItems && TypeMatch(pcon->ItemType, ItemType)) {
				LPSTR pitem = (LPSTR)pcon->ItemList + index*nTypeSize[ItemType];
				FMEMCPY(pVal, pitem, nTypeSize[ItemType]);
				bSuccess = TRUE;
			}
		} else if (cap.ConType == TWON_ONEVALUE) {
			TW_ONEVALUE far *pcon = (TW_ONEVALUE far *)pv;
			if (TypeMatch(pcon->ItemType, ItemType)) {
				FMEMCPY(pVal, &pcon->Item, nTypeSize[ItemType]);
				bSuccess = TRUE;
			}
		}
	}

	if (pv) GlobalUnlock(cap.hContainer);
	if (cap.hContainer) GlobalFree(cap.hContainer);

	return bSuccess;
} 

//-------------------------- The primitive functions


int EZTAPI TWAIN_DS(unsigned long dg, unsigned dat, unsigned msg, void FAR *pd)
// Call the current source with a triplet
{
	assert(nState >= 4);
	rc = TWRC_FAILURE;
	if (pDSM_Entry) {
		rc = (*pDSM_Entry)(&AppId, &SourceId,
						   (TW_UINT32)dg,
						   (TW_UINT16)dat,
						   (TW_UINT16)msg,
						   (TW_MEMREF)pd);
	}
	return (rc == TWRC_SUCCESS);
} // TWAIN_DS



int EZTAPI TWAIN_Mgr(unsigned long dg, unsigned dat, unsigned msg, void FAR *pd)
// Call the Source Manager with a triplet
{
	rc = TWRC_FAILURE;
	if (pDSM_Entry) {
		rc = (*pDSM_Entry)(&AppId, NULL,
						   (TW_UINT32)dg,
						   (TW_UINT16)dat,
						   (TW_UINT16)msg,
						   (TW_MEMREF)pd);
	}
	return (rc == TWRC_SUCCESS);
} // TWAIN_Mgr



unsigned EZTAPI TWAIN_GetResultCode(void)
{
	return rc;
} // TWAIN_GetResultCode



unsigned EZTAPI TWAIN_GetConditionCode(void)
{
	TW_STATUS	twStatus;

	if (nState >= 4) {
		// get source status if open
		TWAIN_DS(DG_CONTROL, DAT_STATUS, MSG_GET, (TW_MEMREF)&twStatus);
	} else if (nState == 3) {
		// otherwise get source manager status
		TWAIN_Mgr(DG_CONTROL, DAT_STATUS, MSG_GET, (TW_MEMREF)&twStatus);
	} else {
		// nothing open, not a good time to get condition code!
		return TWCC_SEQERROR;
	}
	if (rc == TWRC_SUCCESS) {
		return twStatus.ConditionCode;
	} else {
		return TWCC_BUMMER;			// what can I say. 
	}
} // TWAIN_GetConditionCode


//------------ Private functions


HWND CreateProxyWindow(void)
{
	HWND hwnd;
	hwnd = CreateWindow("STATIC",						// class
						"Acquire Proxy",				// title
						WS_POPUPWINDOW | WS_VISIBLE,	// style
						CW_USEDEFAULT, CW_USEDEFAULT,	// x, y
						CW_USEDEFAULT, CW_USEDEFAULT,	// width, height
						HWND_DESKTOP,					// parent window
						NULL,							// hmenu
						hinstLib,						// hinst
						NULL);							// lpvparam
	return hwnd;
} // CreateProxyWindow


int RecordError(ErrorDetail ed)
{
	if (nErrDetail == ED_NONE) {
		nErrDetail = ed;
		if (ed > ED_START_TRIPLET_ERRS && ed < ED_END_TRIPLET_ERRS) {
			nErrRC = TWAIN_GetResultCode();
			nErrCC = TWAIN_GetConditionCode();
		} else {
			nErrRC = 0;
			nErrCC = 0;
		}
	}
	return FALSE;
} // RecordError


void ClearError(void)
{
	nErrDetail = ED_NONE;
} // ClearError


void TWAIN_ReportLastError(LPSTR lpzGeneral)
{
/*	if (nErrDetail > ED_START_TRIPLET_ERRS && nErrDetail < ED_END_TRIPLET_ERRS) {
		wvsprintf(szMsg, "%s\n%s\nRC:   %s\nCC:   %s",
			lpzGeneral, (LPSTR)pszErrDescrip[nErrDetail],
			(LPSTR)pszRC[nErrRC], (LPSTR)pszCC[nErrCC]);
	} else {
		wvsprintf(szMsg, "%s\n%s", lpzGeneral, (LPSTR)pszErrDescrip[nErrDetail]);
	}*/
	TWAIN_ErrorBox("TWAIN_ReportLastError: an error occurred");
} // ReportLastError; stripped down by dsn to avoid using C RTL


void TWAIN_ErrorBox(const char *szMsg)
{
	MessageBox(NULL, (LPSTR)szMsg, "TWAIN Error", MB_ICONEXCLAMATION | MB_OK);
} // TWAIN_ErrorBox


unsigned BitCount(unsigned W)
{
	unsigned n = 0;

	while (W) {
		n += (W & 1);
		W >>= 1;
	} // while
	return n;
} // BitCount


unsigned Intersect16(unsigned wMask, unsigned nItems, TW_UINT16 far *pItem)
{
	unsigned	wSet;
	unsigned	i;

	// In wSet, construct set of available items.
	// Note that items that cannot be represented in wMask are also
	// unrepresentable in wSet so are implicitly discarded
	for (i = wSet = 0 ; i < nItems; i++) {
		wSet |= 1 << pItem[i];
	} // for

	// Discard anything in wMask that isn't in wSet
	wMask &= wSet;

	// Re-fill the item table with intersection set
	for (i = nItems = 0; wMask ; wMask>>=1,i++) {
		if (wMask & 1) {
			pItem[nItems++] = i;
		}
	} // for

	return nItems;
}

/*
TW_UINT32 ToFix32(double r)
{
	TW_FIX32 fix;
	TW_INT32 val = (TW_INT32)(r * 65536.0 + 0.5);
	fix.Whole = (TW_INT16)(val >> 16);			// most significant 16 bits
	fix.Frac = (TW_UINT16)(val & 0xffff);		// least
	assert(sizeof (TW_FIX32) == sizeof (TW_UINT32));
	return *(TW_UINT32*)&fix;
} // ToFix32

double Fix32ToFloat(TW_FIX32 fix)
{
	TW_INT32 val = ((TW_INT32)fix.Whole << 16) | ((TW_UINT32)fix.Frac & 0xffff);
	return val / 65536.0;
} // Fix32ToFloat
*/

// The routine below is a modified version of code posted by Zafir Anjum
// on www.codeguru.com.  The original code was designed for MFC; below it
// has been translated into straight C.  Also, one other change is that rather
// than dynamically allocate only the memory needed for pLP, I fix the size of
// the array at the beginning so that it's sufficient for whatever might come
// along so as to eliminate any dependence on the C runtime library.

/*HBITMAP EZTAPI DIBToDDB( HANDLE hDIB )
{
	  LPBITMAPINFOHEADER      lpbi;
	  HBITMAP                 hbm;
	  HPALETTE                pal;
	  HPALETTE                pOldPal;
	  HDC                     dc;

	  UINT						  nSize;
	  LOGPALETTE				  *pLP;
	  BYTE						  logpalbuffer[5012];
			  // max size = sizeof(LOGPALETTE) + sizeof(PALETTEENTRY) *256 colors
			  //          = 2 + 2 + 1024 = 1028; theoretically only need this much
			  // overshoot just in case; above size ought to be PLENTY
	  int                     nColors;
	  int                     i;
	  LPVOID                  lpDIBBits;
	  BITMAPINFO              *bmInfo;

	  bmInfo = (LPBITMAPINFO) (&hDIB);

	  if (hDIB == NULL)
			 return NULL;

	  dc = GetDC(NULL);  // stuff normally taken care of when MFC is used
	  pal = NULL;

	  lpbi = (LPBITMAPINFOHEADER)hDIB;

	  nColors = lpbi->biClrUsed ? lpbi->biClrUsed :
																1 << lpbi->biBitCount;

	  if( bmInfo->bmiHeader.biBitCount > 8 )
			  lpDIBBits = (LPVOID)((LPDWORD)(bmInfo->bmiColors +
								bmInfo->bmiHeader.biClrUsed) +
								((bmInfo->bmiHeader.biCompression == BI_BITFIELDS) ? 3 : 0));
	  else
			 lpDIBBits = (LPVOID)(bmInfo->bmiColors + nColors);

		  // Create and select a logical palette if needed
	  if( nColors <= 256 && GetDeviceCaps(dc, RASTERCAPS) & RC_PALETTE)
	  {
					nSize = sizeof(LOGPALETTE) + (sizeof(PALETTEENTRY) * nColors);
					pLP = (LOGPALETTE *) logpalbuffer; //new BYTE[nSize];

					pLP->palVersion = 0x300;
					pLP->palNumEntries = nColors;

					for(i=0; i < nColors; i++)
					{
						  pLP->palPalEntry[i].peRed = bmInfo->bmiColors[i].rgbRed;
						  pLP->palPalEntry[i].peGreen = bmInfo->bmiColors[i].rgbGreen;
						  pLP->palPalEntry[i].peBlue = bmInfo->bmiColors[i].rgbBlue;
						  pLP->palPalEntry[i].peFlags = 0;
					}

					pal = CreatePalette( pLP );

					// Select and realize the palette
					pOldPal = SelectPalette( dc, &pal, FALSE );
					RealizePalette(dc);
	  }


	  hbm = CreateDIBitmap(dc,           // handle to device context
								(LPBITMAPINFOHEADER)lpbi,       // pointer to bitmap info header
								(LONG)CBM_INIT,                 // initialization flag
								lpDIBBits,                      // pointer to initialization data
								(LPBITMAPINFO)lpbi,             // pointer to bitmap info
								DIB_RGB_COLORS );               // color-data usage

	  if (pal)
			 SelectPalette(dc, pOldPal,FALSE);

	  ReleaseDC(NULL, dc);
	  return hbm;
}*/
