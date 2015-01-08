// EZTWAIN.H - interface to Easy TWAIN library
//
// EZTWAIN is not a product, and is not the work of any company involved
// in promoting or using the TWAIN standard.  This code is sample code,
// provided without charge, and you use it entirely at your own risk.
// No rights or ownership is claimed by the author, or by any company
// or organization.  There are no restrictions on use or (re)distribution.
//
// 0.0	05/11/94	created
// 1.0a	06/23/94	first alpha version
// 1.04 05/03/95	added: WriteNativeToFile, WriteNativeToFilename,
//					FreeNative, SetHideUI, GetHideUI, SetCurrentUnits,
//					GetCurrentUnits, SetCurrentResolution, SetBitDepth,
//					SetCurrentPixelType, SetCapOneValue.
// 1.05 11/06/96	32-bit conversion
// 1.06 08/21/97        correction to message hook, fixed 32-bit exports

#ifndef EZTWAIN_H
#define EZTWAIN_H

#ifndef _WINDOWS_
#include "windows.h"
#endif

#ifdef __cplusplus
extern "C" {            /* Assume C declarations for C++ */
#endif	/* __cplusplus */

/*#ifndef EZTAPI
  #ifdef _WIN32
	 #define EZTAPI WINAPI
  #else
	 #define EZTAPI FAR PASCAL
  #endif
#endif replace with below -- dsn */
#ifndef EZTAPI
  #ifdef _WIN32
	 #define EZTAPI _stdcall
  #else
	 #define EZTAPI FAR PASCAL
  #endif
#endif

//--------- Basic calls

HANDLE EZTAPI TWAIN_AcquireNative(HWND hwndApp, unsigned wPixTypes);
// The minimal use of EZTWAIN.DLL is to just call this routine, with 0 for
// both params.  EZTWAIN creates a window if hwndApp is 0.
//
// Acquires a single image, from the currently selected Data Source, using
// Native-mode transfer. It waits until the source closes (if it's modal) or
// forces the source closed if not.  The return value is a handle to the
// acquired image.  Only one image can be acquired per call.
//
// Under Windows, the return value is a global memory handle - applying
// GlobalLock to it will return a (huge) pointer to the DIB, which
// starts with a BITMAPINFOHEADER.
// NOTE: You are responsible for disposing of the returned DIB - these things
// can eat up your Windows memory fast!  See TWAIN_FreeNative below.
//
// The image type can be restricted using the following masks.  A mask of 0
// means 'any pixel type is welcome'.
// Caution: You should not assume that the source will honor a pixel type
// restriction!  If you care, check the parameters of the DIB.

#define TWAIN_BW		0x0001	// 1-bit per pixel, B&W 	(== TWPT_BW)
#define TWAIN_GRAY		0x0002	// 1,4, or 8-bit grayscale  (== TWPT_GRAY)
#define TWAIN_RGB		0x0004	// 24-bit RGB color         (== TWPT_RGB)
#define TWAIN_PALETTE	0x0008	// 1,4, or 8-bit palette    (== TWPT_PALETTE)
#define TWAIN_ANYTYPE	0x0000	// any of the above

void EZTAPI TWAIN_FreeNative(HANDLE hdib);
// Release the memory allocated to a native format image, as returned by
// TWAIN_AcquireNative. (If you are coding in C or C++, this is just a call
// to GlobalFree.)
// If you use TWAIN_AcquireNative and don't free the returned image handle,
// it stays around taking up Windows (virtual) memory until your application
// terminates.  Memory required per square inch:
//             1 bit B&W       8-bit grayscale     24-bit color
// 100 dpi      1.25KB              10KB               30KB
// 200 dpi        5KB               40KB              120KB
// 300 dpi      11.25KB             90KB              270KB
// 400 dpi       20KB              160KB              480KB
//

int EZTAPI TWAIN_AcquireToClipboard(HWND hwndApp, unsigned wPixTypes);
// Like AcquireNative, but puts the resulting image, if any, into the system
// clipboard.  Under Windows, this will put a CF_DIB item in the clipboard
// if successful.  If this call fails, the clipboard is either empty or
// contains the old contents.
// A return value of 1 indicates success, 0 indicates failure.
//
// Useful for environments like Visual Basic where it is hard to make direct
// use of a DIB handle.  In fact, TWAIN_AcquireToClipboard uses
// TWAIN_AcquireNative for all the hard work.

int EZTAPI TWAIN_AcquireToFilename(HWND hwndApp, char *pszFile);
// Acquire an image and write it to a .BMP (Windows Bitmap) file.
// The file name and path in pszFile are used.  If pszFile is NULL or
// points to an empty string, the user is prompted with a Save File dialog.
// Return values:
// -1 means the Acquire failed.
//  0 means the Save failed (or was cancelled)
//  1 indicates success.

int EZTAPI TWAIN_SelectImageSource(HWND hwnd);
// This is the routine to call when the user chooses the "Select Source..."
// menu command from your application's File menu.  Your app has one of
// these, right?  The TWAIN spec calls for this feature to be available in
// your user interface, preferably as described.
// Note: If only one TWAIN device is installed on a system, it is selected
// automatically, so there is no need for the user to do Select Source.
// You should not require your users to do Select Source before Acquire.
//
// This function posts the Source Manager's Select Source dialog box.
// It returns after the user either OK's or CANCEL's that dialog.
// A return of 1 indicates OK, 0 indicates one of the following:
//   a) The user cancelled the dialog
//   b) The Source Manager found no data sources installed
//   c) There was a failure before the Select Source dialog could be posted
// -- details --
// Only sources that can return images (that are in the DG_IMAGE group) are
// displayed.  The current default source will be highlighted initially.
// In the standard implementation of "Select Source...", your application
// doesn't need to do anything except make this one call.
//
// If you want to be meticulous, disable your "Acquire" and "Select Source"
// menu items or buttons if TWAIN_IsAvailable() returns 0 - see below.


//--------- Basic TWAIN Inquiries

int EZTAPI TWAIN_IsAvailable(void);
// Call this function any time to find out if TWAIN is installed on the
// system.  It takes a little time on the first call, after that it's fast,
// just testing a flag.  It returns 1 if the TWAIN Source Manager is
// installed & can be loaded, 0 otherwise. 


int EZTAPI TWAIN_EasyVersion(void);
// Returns the version number of EZTWAIN.DLL, multiplied by 100.
// So e.g. version 2.01 will return 201 from this call.

int EZTAPI TWAIN_State(void);
// Returns the TWAIN Protocol State per the spec.
#define TWAIN_PRESESSION		1	// source manager not loaded
#define TWAIN_SM_LOADED			2	// source manager loaded
#define TWAIN_SM_OPEN			3	// source manager open
#define TWAIN_SOURCE_OPEN		4	// source open but not enabled
#define TWAIN_SOURCE_ENABLED	5	// source enabled to acquire
#define TWAIN_TRANSFER_READY	6	// image ready to transfer
#define TWAIN_TRANSFERRING		7	// image in transit

//--------- Callback mechanism -------------
// Added by DSN 7/98, this allows the user to specify an
// optional callback function to be called each time a new image comes
// in.  This can be a potentially powerful way to increase the primary
// application's efficiency, because upon receipt of an hdib the app
// could start a background thread to begin processing the images as
// needed.  Why bother with this?  Because on my Pentium 150, the Windows
// NT task monitor indicates that when I download images at 112kbps that
// I'm only using 15% of the processor's power, and the remaining 85% of
// the time it is idle!  It's silly to wait to begin processing because
// there's so much untapped processing capacity here.

typedef void (EZTAPI *HDIBCALLBACKPROC)(HANDLE, int);
void EZTAPI TWAIN_RegisterCallback(HDIBCALLBACKPROC *fxn);
void EZTAPI TWAIN_UnRegisterCallback();

//--------- DIB handling utilities ---------
// The next three functions were added by DSN 7/98
// They are used to clear the list of hDibs as well as provide
// access to the total number of images scanned and access any
// particular image's hDib.

void EZTAPI TWAIN_ClearDibList(void);
int EZTAPI TWAIN_GetNumDibs();
HANDLE EZTAPI TWAIN_GetDib(int n);

int EZTAPI TWAIN_DibDepth(HANDLE hdib);
// Depth of DIB, in bits i.e. bits per pixel.
int EZTAPI TWAIN_DibWidth(HANDLE hdib);
// Width of DIB, in pixels (columns)
int EZTAPI TWAIN_DibHeight(HANDLE hdib);
// Height of DIB, in lines (rows)
int EZTAPI TWAIN_DibNumColors(HANDLE hdib);
// Number of colors in color table of DIB

HPALETTE EZTAPI TWAIN_CreateDibPalette(HANDLE hdib);
// Create and return a logical palette to be used for drawing the DIB.
// For 1, 4, and 8-bit DIBs the palette contains the DIB color table.
// For 24-bit DIBs, a default halftone palette is returned.

void EZTAPI TWAIN_DrawDibToDC(
		HDC hDC,		// destination device context
		int dx, int dy,	// destination (x,y)
		int w, int h,	// width and height
		HANDLE hdib,	// DIB handle
		int sx, int sy	// source (x,y) in DIB
		);
// Draws a DIB on a device context.
// You should call CreateDibPalette, select that palette
// into the DC, and do a RealizePalette(hDC) first.

//--------- BMP file utilities
 
int EZTAPI TWAIN_WriteNativeToFilename(HANDLE hdib, LPCSTR pszFile);
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

int EZTAPI TWAIN_WriteNativeToFile(HANDLE hdib, HFILE fh);
// Writes a DIB to a file in .BMP format.
//
// hdib		= DIB handle, as returned by TWAIN_AcquireNative
// fh		= file handle, as returned by _open, _lopen or OpenFile
//
// Return value as for TWAIN_WriteNativeToFilename

HANDLE EZTAPI TWAIN_LoadNativeFromFilename(LPCSTR pszFile);
// Load a .BMP file and return a DIB handle (as from AcquireNative.)
// Accepts a filename (including path & extension).
// If pszFile is NULL or points to a null string, the user is prompted.
// Returns a DIB handle if successful, otherwise NULL.

HANDLE EZTAPI TWAIN_LoadNativeFromFile(HFILE fh);
// Like LoadNativeFromFilename, but takes an already open file handle.

//--------- Application Registration

void EZTAPI TWAIN_RegisterApp(	// record application information
	int		nMajorNum, int nMinorNum,	// major and incremental revision of application. E.g.
										// for version 2.1, nMajorNum == 2 and nMinorNum == 1
	int		nLanguage,					// language of this version (use TWLG_xxx from TWAIN.H)
	int		nCountry,					// country of this version (use TWCY_xxx from TWAIN.H)
	LPSTR	lpszVersion,				// version info string e.g. "1.0b3 Beta release"
	LPSTR	lpszMfg,					// name of manufacturer/developer e.g. "Crazbat Software"
	LPSTR	lpszFamily,					// product family e.g. "BitStomper"
	LPSTR	lpszProduct);				// specific product e.g. "BitStomper Deluxe Pro"
//
// TWAIN_RegisterApp can be called *AS THE FIRST CALL*, to register the
// application. If this function is not called, the application is given a
// 'generic' registration by EZTWAIN.
// Registration only provides this information to the Source Manager and any
// sources you may open - it is used for debugging, and (frankly) by some
// sources to give special treatment to certain applications.

//--------- Lower-level functions for greater control of the TWAIN protocol --------

void EZTAPI TWAIN_SetHideUI(int fHide);
int EZTAPI TWAIN_GetHideUI(void);
// These functions control the 'hide source user interface' flag.
// This flag is cleared initially, but if you set it non-zero, then when
// a source is enabled it will be asked to hide its user interface.
// Note that this is only a request - some sources will ignore it!
// This affects AcquireNative, AcquireToClipboard, and EnableSource.
// If the user interface is hidden, you will probably want to set at least
// some of the basic acquisition parameters yourself - see
// SetCurrentUnits, SetBitDepth, SetCurrentPixelType and
// SetCurrentResolution below.

unsigned EZTAPI TWAIN_GetResultCode(void);
// Return the result code (TWRC_xxx) from the last triplet sent to TWAIN

unsigned EZTAPI TWAIN_GetConditionCode(void);
// Return the condition code from the last triplet sent to TWAIN.
// (To be precise, from the last call to TWAIN_DS below)
// If a source is NOT open, return the condition code of the source manager.

int EZTAPI TWAIN_LoadSourceManager(void);
// Finds and loads the Data Source Manager, TWAIN.DLL.
// If Source Manager is already loaded, does nothing and returns TRUE.
// This can fail if TWAIN.DLL is not installed (in the right place), or
// if the library cannot load for some reason (insufficient memory?) or
// if TWAIN.DLL has been corrupted.

int EZTAPI TWAIN_OpenSourceManager(HWND hwnd);
// Opens the Data Source Manager, if not already open.
// If the Source Manager is already open, does nothing and returns TRUE.
// This call will fail if the Source Manager is not loaded.

int EZTAPI TWAIN_OpenDefaultSource(void);
// This opens the source selected in the Select Source dialog.
// If a source is already open, does nothing and returns TRUE.
// Fails if the source manager is not loaded and open.

int EZTAPI TWAIN_EnableSource(HWND hwnd);
// Enables the open Data Source. This posts the source's user interface
// and allows image acquisition to begin.  If the source is already enabled,
// this call does nothing and returns TRUE.

int EZTAPI TWAIN_DisableSource(void);
// Disables the open Data Source, if any.
// This closes the source's user interface.
// If there is not an enabled source, does nothing and returns TRUE.

int EZTAPI TWAIN_CloseSource(void);
// Closes the open Data Source, if any.
// If the source is enabled, disables it first.
// If there is not an open source, does nothing and returns TRUE.

int EZTAPI TWAIN_CloseSourceManager(HWND hwnd);
// Closes the Data Source Manager, if it is open.
// If a source is open, disables and closes it as needed.
// If the Source Manager is not open, does nothing and returns TRUE.

int EZTAPI TWAIN_UnloadSourceManager(void);
// Unloads the Data Source Manager i.e. TWAIN.DLL - releasing
// any associated memory or resources.
// This call will fail if the Source Manager is open, otherwise
// it always succeeds and returns TRUE.


int EZTAPI TWAIN_MessageHook(LPMSG lpmsg);
// This function detects Windows messages that should be routed
// to an enabled Data Source, and picks them off.  In a full TWAIN
// app, TWAIN_MessageHook is called inside the main GetMessage loop.
// The skeleton code looks like this:  
//		MSG msg;
//  	while (GetMessage((LPMSG)&msg, NULL, 0, 0)) {
//			if (!TWAIN_MessageHook ((LPMSG)&msg)) {
//				TranslateMessage ((LPMSG)&msg);
//				DispatchMessage ((LPMSG)&msg);
//			}
//		} // while


void EZTAPI TWAIN_ModalEventLoop(void);
// Process messages until termination, source disable, or image transfer.
//
// Executes exactly the sample code given above for TWAIN_MessageHook, but
// terminates as soon as the source is disabled or a transfer completes.
// This function is called by TWAIN_AcquireNative.

void EZTAPI TWAIN_NativeXferGetAll(LPMSG pmsg);
// above functions added by DSN 7/98.  They are based on Spike's code in
// CTWAIN.  They allow for acquisition of multiple images.  The use of
// TWAIN_NativeXferGetAll replaces the use of TWAIN_NativeXferReady
// (prototype not here, but rather in eztwain.c for some reason).

int EZTAPI TWAIN_AbortAllPendingXfers(void);

int EZTAPI TWAIN_WriteDibToFile(LPBITMAPINFOHEADER lpDIB, HFILE fh);
// Writes a DIB to a file in .BMP format.
// Returns TRUE if successful, FALSE otherwise.
// (Likely causes of failure: device full, or permission denied to write to file or device
// lpDIB	= pointer to DIB, as from GlobalLock of DIB handle
// fh		= file handle, as returned by C _open or Windows _lopen or OpenFile
// For example of use, see TWAIN_WriteNativeToFilename in EZTWAIN.C

int EZTAPI TWAIN_NegotiateXferCount(int nXfers);
// Negotiate with open Source the number of images application will accept.
// This is only allowed in State 4 (TWAIN_SOURCE_OPEN)
// nXfers = -1 means any number

int EZTAPI TWAIN_NegotiatePixelTypes(unsigned wPixTypes);
// Negotiate with the source to restrict pixel types that can be acquired.
// This tries to restrict the source to a *set* of pixel types,
// See TWAIN_AcquireNative above for some mask constants.
// --> This is only allowed in State 4 (TWAIN_SOURCE_OPEN)
// A parameter of 0 (TWAIN_ANYTYPE) causes no negotiation & no restriction.
// You should not assume that the source will honor your restrictions, even
// if this call succeeds!

int EZTAPI TWAIN_GetCurrentUnits(void);
// Ask the source what its current unit of measure is.
// If anything goes wrong, this function just returns TWUN_INCHES (0).

int EZTAPI TWAIN_SetCurrentUnits(int nUnits);
// Set the current unit of measure for the source.
// Unit of measure codes are in TWAIN.H, but TWUN_INCHES is 0.

int EZTAPI TWAIN_GetBitDepth(void);
// Get the current bitdepth, which can depend on the current PixelType.
// Bit depth is per color channel e.g. 24-bit RGB has bit depth 8.
// If anything goes wrong, this function returns 0.

int EZTAPI TWAIN_SetBitDepth(int nBits);
// (Try to) set the current bitdepth (for the current pixel type).

int EZTAPI TWAIN_GetPixelType(void);
// Ask the source for the current pixel type.
// If anything goes wrong (it shouldn't), this function returns 0 (TWPT_BW).

int EZTAPI TWAIN_SetCurrentPixelType(int nPixType);
// (Try to) set the current pixel type for acquisition.
// This is only allowed in State 4 (TWAIN_SOURCE_OPEN)
// The source may select this pixel type, but don't assume it will.

/*double EZTAPI TWAIN_GetCurrentResolution(void);
// Ask the source for the current resolution.
// Resolution is in dots per current unit! (See TWAIN_GetCurrentUnits above)
// If anything goes wrong (it shouldn't) this function returns 0.0

int EZTAPI TWAIN_SetCurrentResolution(double dRes);
// (Try to) set the current resolution for acquisition.
// Resolution is in dots per current unit! (See TWAIN_GetCurrentUnits above)
// This is only allowed in State 4 (TWAIN_SOURCE_OPEN)
// Note: The source may select this resolution, but don't assume it will.
*/

//--------- Low-level capability negotiation functions --------

// Setting a capability is valid only in State 4 (TWAIN_SOURCE_OPEN)
// Getting a capability is valid in State 4 or any higher state.
 
int EZTAPI TWAIN_SetCapOneValue(unsigned Cap,
                                           unsigned ItemType,
                                           long ItemVal);
// Do a DAT_CAPABILITY/MSG_SET, on capability 'Cap' (e.g. ICAP_PIXELTYPE,
// CAP_AUTOFEED, etc.) using a TW_ONEVALUE container with the given item type
// and value.  Obviously, the item value must fit into 32 bits.
// Returns TRUE (1) if successful, FALSE (0) otherwise.

int EZTAPI TWAIN_GetCapCurrent(unsigned Cap,
                                          unsigned ItemType,
                                          void FAR *pVal);
// Do a DAT_CAPABILITY/MSG_GETCURRENT on capability 'Cap'.
// Copy the current value out of the returned container into *pVal.
// If the operation fails (the source refuses the request), or if the
// container is not a ONEVALUE or ENUMERATION, or if the item type of the
// returned container is incompatible with the expected TWTY_ type in nType,
// returns FALSE.  If this function returns FALSE, *pVal is not touched.

//--------- Lowest-level functions for TWAIN protocol --------


int EZTAPI TWAIN_DS(unsigned long DG, unsigned DAT, unsigned MSG, void FAR *pData);
// Passes the triplet (DG, DAT, MSG, pData) to the open data source if any.
// Returns 1 (TRUE) if the result code is TWRC_SUCCESS, 0 (FALSE) otherwise.
// The last result code can be retrieved with TWAIN_GetResultCode(), and the corresponding
// condition code can be retrieved with TWAIN_GetConditionCode().
// If no source is open this call will fail, result code TWRC_FAILURE, condition code TWCC_NODS.

int EZTAPI TWAIN_Mgr(unsigned long DG, unsigned DAT, unsigned MSG, void FAR *pData);
// Passes a triplet to the Data Source Manager (DSM).
// Returns 1 (TRUE) if the result code is TWRC_SUCCESS, 0 (FALSE) otherwise.
// The last result code can be retrieved with TWAIN_GetResultCode(), and the corresponding
// condition code can be retrieved with TWAIN_GetConditionCode().
// If the Source Manager is not open, this call will fail, and set the result code to TWRC_FAILURE,
// with a condition code of TWCC_SEQERROR (triplet out of sequence).


#ifdef __cplusplus
}
#endif

#endif
