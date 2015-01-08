unit u_comp_TInfoVersion;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
	TInfoVersion = class(TComponent)
	private
		fAbout: string;
		fNoMineur: string;
		fNoMajeur: string;
		fNoSousVersion: string;
		fNoConstruction: string;
		procedure SetAbout(const Value: string);
		function GetOsInfoCode: string;
		function GetOsInfoText: string;
		function GetNoConstruction: string;
		function GetNoMajeur: string;
		function GetNoMineur: string;
		function GetNoSousVersion: string;
		procedure GetVersion;
		function GetCodeClient: string;
		function GetNumSerieHDC: string;


	public
		constructor Create(AOwner: TComponent); override;
		function Version: string;


	published

		property About: string read fAbout write SetAbout;
		property NoMajeur: string read GetNoMajeur;
		property NoMineur: string read GetNoMineur;
		property NoSousVersion: string read GetNoSousVersion;
		property NoConstruction: string read GetNoConstruction;
                property OSInfoText: string read GetOsInfoText;
		property OSInfoCode: string read GetOsInfoCode;
		property NumSerieHDC: string read GetNumSerieHDC;

                property CodeClient: string read GetCodeClient;

        end;

procedure Register;

implementation

procedure Register;
begin
        RegisterComponents('VisualPak', [TInfoVersion]);
end;

{ TInfoVersion }

constructor TInfoVersion.Create(AOwner: TComponent);
begin
        inherited Create(AOwner);
        fAbout := 'Yann UHEL - 10051999';

end;


function TInfoVersion.Version: string;
begin
        GetVersion;
        result := fNoMineur + '.' + fNoMajeur + '.' + fNoSousVersion + '.' + fNoConstruction;
end;



procedure TInfoVersion.SetAbout(const Value: string);
begin
end;



function TInfoVersion.GetOsInfoCode: string;
var
	OsInfo: TOSVERSIONINFO;
begin
	OsInfo.dwOSVersionInfoSize := sizeof(TOSVERSIONINFO);
	if GetVersionEx(OsInfo) then
	begin
		case OsInfo.dwPlatformId of
			VER_PLATFORM_WIN32s: result := '31';
			VER_PLATFORM_WIN32_WINDOWS: result := '95';
			VER_PLATFORM_WIN32_NT: result := 'NT';
		end;
	end
	else
		result := '??';
end;

function TInfoVersion.GetOsInfoText: string;
var
        OsInfo: TOSVERSIONINFO;
begin
        OsInfo.dwOSVersionInfoSize := sizeof(TOSVERSIONINFO);
        if GetVersionEx(OsInfo) then
        begin
                case OsInfo.dwPlatformId of
                        VER_PLATFORM_WIN32s: result := 'Windows 3.1';
                        VER_PLATFORM_WIN32_WINDOWS: result := 'Windows 95';
                        VER_PLATFORM_WIN32_NT: result := 'Windows NT';
                end;
        end
	else
                result := '?';
end;

function TInfoVersion.GetNoConstruction: string;
begin
        GetVersion;
        result := fNoConstruction;
end;

function TInfoVersion.GetNoMajeur: string;
begin
        GetVersion;
        result := fNoMajeur;

end;

function TInfoVersion.GetNoMineur: string;
begin
        GetVersion;
        result := fNoMajeur;
end;

function TInfoVersion.GetNoSousVersion: string;
begin
        GetVersion;
        result := fNoSousVersion;
end;


procedure TInfoVersion.GetVersion;
var
        Wnd: DWord;
        theSize: DWord;
        verBuf: pointer;
	FI: PVSFixedFileInfo;
begin
	fNoMineur := '0';
	fNoMajeur := '0';
	fNoSousVersion := '0';
	fNoConstruction := '0';
	theSize := getFileVersionInfoSize(PChar(application.exename), Wnd);

	if theSize <> 0 then
	begin
		GetMem(verBuf, theSize);
		try
			if GetFileVersionInfo(PChar(application.exename), Wnd, theSize, VerBuf) then
			begin
				if VerQueryValue(VerBuf, '\', Pointer(FI), theSize) then
				begin
					fNoMineur := inttostr(FI.dwProductVersionMS shr 16);
					fNoMajeur := inttostr((FI.dwProductVersionMS shl 16) shr 16);
					fNoSousVersion := inttostr(FI.dwProductVersionLS shr 16);
					fNoConstruction := inttostr((FI.dwProductVersionLS shl 16) shr 16);
				end;
			end;
		finally
			FreeMem(VerBuf);
		end;
	end;
end;



function TInfoVersion.GetNumSerieHDC: string;
var
	OldErrorMode: Integer;
	NotUsed, VolFlags: DWORD;
	Buf: array[0..MAX_PATH] of char;
	b2: array[0..255] of byte;
	s1, s2, s3, s4: string;
begin
	OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
	try

		try
			GetVolumeInformation(PChar('C:\'), Buf, DWORD(sizeof(Buf)), @b2, NotUsed, VolFlags, nil, 0);
			s1 := format('%x', [B2[0]]); if length(s1) = 1 then s1 := '0' + s1;
			s2 := format('%x', [B2[1]]); if length(s2) = 1 then s2 := '0' + s2;
			s3 := format('%x', [B2[2]]); if length(s3) = 1 then s3 := '0' + s3;
			s4 := format('%x', [B2[3]]); if length(s4) = 1 then s4 := '0' + s4;

			result := s4 + s3 + ':' + s2 + s1;
		except
			result := '????-????';
		end;
	finally
		SetErrorMode(OldErrorMode);
	end;

end;



function TInfoVersion.GetCodeClient: string;
begin
	result := 'à déterminer !';
end;




end.

