{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_Form_Maj_Internet;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
{$IFDEF WINDOWS}
{$DEFINE HTMLVIEW}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  ShellApi, OleCtrls, SHDocVw, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
{$IFDEF HTMLVIEW}
  FramView,HTMLView, Readhtml, HtmlGlobals,StyleTypes,
{$ELSE}
  lazbro,
{$ENDIF}
  U_FormAdapt, Controls, Graphics, StdCtrls, ExtCtrls,
  ComCtrls, Classes, Forms,
  SysUtils, Dialogs, u_buttons_appli, ExtJvXPButtons,
  lNetComponents, U_OnFormInfoIni, u_netupdate,
  u_ancestropictimages;

type

  { TFMajInternet }

  TFMajInternet=class(TF_FormAdapt)
    btnFermer: TFWClose;
    btnMAJ: TJvXPButton;
    HTTPClient: TLHTTPClientComponent;
    NetUpdate: TNetUpdate;
    OnFormInfoIni1: TOnFormInfoIni;
    Panel1: TPanel;
    Panel9:TPanel;
    Image2:TImage;
    Label2:TLabel;
    Panel10:TPanel;
    TabInternet:TPageControl;
    TabMaj:TTabSheet;
    TabNews:TTabSheet;
    lRun:TLabel;
    Label8:TLabel;
    Label9:TLabel;
    lAlerte:TLabel;
    Image1:TIATitle;
    GroupBox1:TGroupBox;
    lBuild:TLabel;
    lDateAncien:TLabel;
    GroupBox2:TGroupBox;
    lSite:TLabel;
    lTailleDistant:TLabel;
    lDate:TLabel;
    Gauge:TProgressBar;
    pConnect:TGroupBox;
    Label1:TLabel;
    lTaille:TLabel;
    Label3:TLabel;
    lReste:TLabel;
    {$IFDEF HTMLVIEW}
    Browser : TFrameViewer;
    {$ELSE}
    Browser : TLazbro;
    {$ENDIF}
    procedure FormDestroy(Sender: TObject);
    procedure NetUpdateDownloaded(const Sender: TObject; const TheFile: string;
      const TheStep: TUpdateStep);
    procedure NetUpdateDownloading(const Sender: TObject;
      const Step: TUpdateStep);
    procedure NetUpdateErrorMessage(const Sender: TObject;
      const ErrorCode: integer; const ErrorMessage: string);
    procedure NetUpdateFileDownloaded(const Sender: TObject;
      const MD5OK: Boolean);
    procedure NetUpdateIniRead(const Sender: TObject; const Total: integer);
    procedure NetUpdatePageDownloaded(const Sender: TObject;
      const MD5OK: Boolean);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure SuperFormCreate(Sender:TObject);
    procedure btnMAJClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure btnFermerClick(Sender:TObject);
    procedure TabInternetDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
    {$IFDEF HTMLVIEW}
    procedure WebBrowserHotSpotClick(Sender: TObject; const Target, URL: ThtString;
      var Handled: boolean);
    procedure WebBrowserHotSpotCovered(Sender: TObject; const Target, URL: ThtString);
    procedure WebBrowserLink(Sender: TObject; const Rel, Rev, Href: THtString);
    {$ELSE}
    procedure WebBrowserLink(const Sender: TLazbro);
    {$ENDIF}
    procedure p_AfterDownloadExe;
  private
    bOK,bExeEtBaseAjour:Boolean;
    sDate:string;
    iBaseEnCours:integer;
    iExeEnCours:int64;
    procedure ErrorUpdateMessage;
  public

  end;

implementation

uses u_dm,u_common_const,u_genealogy_context,
     u_common_functions,u_common_ancestro,
     LazUTF8,
     StrUtils,
     FileUtil, //md5Api,
     fonctions_net,
     fonctions_dialogs,
     u_common_ancestro_functions,
     u_form_main, unite_messages,
     fonctions_system, fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFMajInternet.FormDestroy(Sender: TObject);
begin

end;

procedure TFMajInternet.NetUpdateDownloaded(const Sender: TObject;
  const TheFile: string; const TheStep: TUpdateStep);
begin
  btnFermer.Enabled:=True;
end;

procedure TFMajInternet.NetUpdateDownloading(const Sender: TObject;
  const Step: TUpdateStep);
Begin
  bOk:=True;
  btnMAJ.Enabled:=False;
  btnFermer.Enabled:=false;
  if (btnMAJ.Caption=gs_Download_update) then
  begin
    pConnect.Visible:=True;
    Gauge.Cursor:=crHourGlass;
    lRun.Visible:=True;
    lRun.Caption:=fs_RemplaceMsg(gs_Downloading_in_progress,[NetUpdate.FileUpdate]);
    Gauge.Visible:=True;
    Application.ProcessMessages;
  end ;

end;

procedure TFMajInternet.NetUpdateErrorMessage(const Sender: TObject;
  const ErrorCode: integer; const ErrorMessage: string);
begin
  btnFermer.Enabled:=True;
  ErrorUpdateMessage;
end;

procedure TFMajInternet.ErrorUpdateMessage;
begin
  MyMessageDlg(rs_Error_MD5,mtError, [mbOK],Self);
  lRun.Visible:=false;
  lReste.Caption:='';
  Gauge.Visible:=false;
  pConnect.Visible:=false;
end;

procedure TFMajInternet.NetUpdateFileDownloaded(const Sender: TObject;
  const MD5OK: Boolean);
begin
  lRun.Caption:=gs_Download_finished;
  // matthieu : MD5Hash problem
  with NetUpdate do
  if MD5OK then
    begin
      btnMAJ.Caption:=rs_Update;
      bok:=True;
      if bExeEtBaseAjour then
        MyMessageDlg(rs_File_Downloaded,mtInformation, [mbOK],Self);
    end
  else
    begin
      DeleteFileUTF8(UpdateDir+FileUpdate);
      ErrorUpdateMessage;
      bok:=false;
    end;
  if bOk and(not bExeEtBaseAjour) then
    begin
      pConnect.Visible:=False;
      if MyMessageDlg(rs_Ancestromania_will_be_updated_and_saved
        ,mtConfirmation, [mbCancel,mbOK],Self)=mrCancel then
      begin
        btnMAJ.Enabled:=true;
        exit;
      end;
      with NetUpdate do
        p_OpenFileOrDirectory(UpdateDir+FileUpdate);
      gb_ForceClose := True;
      FMain.Close;
     end;
  if not(bExeEtBaseAjour and bOK) then
    btnMAJ.Enabled:=true;
end;

procedure TFMajInternet.NetUpdateIniRead(const Sender: TObject;
  const Total: integer);
begin
  with NetUpdate do
   Begin
    if fi64_VersionExeInt64(VersionExeUpdate)>iExeEnCours then
      begin
        MyMessageDlg(rs_Ancestromania_must_be_updated +
         _CRLF+_CRLF+rs_Ancestromania_should_be_updated,mtWarning, [mbOK],Self);
        bOK:=True;
      end
      else if fi_BaseVersionToInt(VersionBaseUpdate)>iBaseEnCours then
      begin
        MyMessageDlg(rs_Ancestromania_is_not_fully_updated+
         _CRLF+_CRLF+rs_Ancestromania_should_be_updated,mtWarning, [mbOK],Self);
        bOK:=True;
      end
      else
      begin
        MyMessageDlg(rs_Ancestromania_is_fully_updated,mtInformation, [mbOK],Self);
        bExeEtBaseAjour:=true;
      end;

      TabNews.TabVisible:=True;
      if bOK then
      begin
        with NetUpdate do
        if MD5File<>MD5Ini then
          btnMAJ.Caption:=gs_Download_update
        else
          btnMAJ.Caption:=rs_Update;
        btnMAJ.Enabled:=True;
        btnMAJ.SetFocus;
        lDate.Caption:=sDate;
      end
      else
      begin
        btnMAJ.Enabled:=False;
      end;
      TabInternet.ActivePage:=TabNews;
      Application.ProcessMessages;
   end;

end;

procedure TFMajInternet.NetUpdatePageDownloaded(const Sender: TObject;
  const MD5OK: Boolean);
begin
  with NetUpdate do
  try
    {$IFDEF HTMLVIEW}
//    Browser.Base := UpdateDir + FilePage;
    {$ELSE}
//      Browser.BaseUrl := UpdateDir + FilePage;
    {$ENDIF}
    Browser.LoadFromFile ( UpdateDir + FilePage );
    TabNews.TabVisible:=True;
    if bOK then
    begin
      if md5ok then
       btnMAJ.Caption:=rs_Update
      else
       btnMAJ.Caption:=gs_Download_update;
      btnMAJ.Enabled:=True;
      btnMAJ.SetFocus;
      lDate.Caption:=sDate;
    end
    else
    begin
      btnMAJ.Enabled:=False;
    end;
    TabInternet.ActivePage:=TabNews;
    Application.ProcessMessages;

  Except
      MyMessageDlg(rs_Error_Cannot_load_corrupted_file,mtError, [mbOk],Self);

  end;
end;


procedure TFMajInternet.SuperFormKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:ModalResult:=mrOk;
  end;
end;


procedure TFMajInternet.SuperFormCreate(Sender:TObject);
var
  SR:TSearchRec;
  VersionCur,VersionMax:string;
  lat_ArchitectureType : TArchitectureType;
begin
  Browser := {$IFDEF HTMLVIEW}TFrameViewer{$ELSE}TLazbro{$ENDIF}.Create(Self);
  Browser.Parent:=TabNews;
  Browser.Align:=alClient;
  Browser.Visible:=True;
  {$IFDEF HTMLVIEW}
  Browser.OnLink:=WebBrowserLink;
  Browser.OnHotSpotTargetClick  :=WebBrowserHotSpotClick;
  Browser.OnHotSpotTargetCovered:=WebBrowserHotSpotCovered;
  {$ELSE}
  Browser.OnUrlChange:=WebBrowserLink;
  {$ENDIF}
  Color:=gci_context.ColorLight;
  with NetUpdate do
   Begin
    UpdateDir:=sUpdateDir+'Updates' +DirectorySeparator;
    lat_ArchitectureType := fat_GetArchitectureType;
    URLBase:=urlMajAuto;
    FileIni:=fs_GetIniFileNameUpdate(lat_ArchitectureType,fpt_GetPackagesType,CST_PROCESSOR_TYPE,IniFilename);
    FilePage:= WebPage;
    FileUpdate:=fs_GetFileNameUpdate(lat_ArchitectureType,fpt_GetPackagesType,CST_PROCESSOR_TYPE,'Update_Ancestro');
   end;

  Panel10.Color:=gci_context.ColorDark;
  TabNews.TabVisible:=False;
  lBuild.Caption:=fs_RemplaceMsg(rs_Caption_Exe_database, [NumVersionCourt(0,gr_ExeVersion),gci_context.VersionBase]);
  lDateAncien.Caption:=rs_from+' : '+fs_DateTime2Str(FileDateToDateTime(FileAgeUTF8(Application.ExeName) ));
  bExeEtBaseAjour:=False;
  VersionMax:='';
  try
    if DirectoryExistsUTF8(gci_context.Path_Applis_Ancestro+ScriptsDir) then
    begin
      if FindFirstUTF8(gci_context.Path_Applis_Ancestro+ScriptsDir+DirectorySeparator+'*.sql', faAnyFile, SR) { *Converted from FindFirstUTF8*  }=0 then
      begin
        VersionCur:=RightStr(extractFileNameWithoutExt(gci_context.Path_Applis_Ancestro+ScriptsDir+DirectorySeparator+SR.Name),4);
        if StrToIntDef(VersionCur,-1)<>-1 then
          VersionMax:=VersionCur;
        while FindNextUTF8(SR) { *Converted from FindNextUTF8*  }=0 do
        begin
          VersionCur:=RightStr(extractFileNameWithoutExt(gci_context.Path_Applis_Ancestro+ScriptsDir+DirectorySeparator+SR.Name),4);
          if (VersionCur>VersionMax)and(StrToIntDef(VersionCur,-1)<>-1) then
            VersionMax:=VersionCur;
        end;
      end;
      FindCloseUTF8(SR); { *Converted from FindCloseUTF8*  }
    end;
    try
      if VersionMax>'' then
      begin
        VersionMax:=LeftStr(VersionMax,Length(VersionMax)-3)+'.'+RightStr(VersionMax,3);
        iBaseEnCours:=fi_BaseVersionToInt (VersionMax);
      end
      else
        iBaseEnCours:=0;
    except
      iBaseEnCours:=0;
    end;

    iExeEnCours:=fi64_VersionExeInt64;
  except
    on E:Exception do
    begin
      ShowMessage(rs_Error_Initializing_Internet_Update+_CRLF+_CRLF+E.Message);
      Close;
    end;
  end;
end;

procedure TFMajInternet.btnMAJClick(Sender:TObject);
begin
  btnMAJ.Enabled:=false;
  application.ProcessMessages;

  bOK:=False;

  lAlerte.Visible:=true;

  if (btnMAJ.Caption=gs_Download_update)or(btnMAJ.Caption=rs_Update) then
  begin
    TabInternet.ActivePage:=TabMaj;
    NetUpdate.Update;
  end
  else
  begin
    screen.Cursor:=crHourGlass;
    lRun.Visible:=True;

    Application.ProcessMessages;

    lRun.Caption:=rs_Caption_Verify_updates;

    NetUpdate.UpdateIniPage;

  end;
end;

procedure TFMajInternet.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  Application.ProcessMessages;
//  Action:=caFree; //lib?r?e par la fonction qui l'appelle
end;

procedure TFMajInternet.btnFermerClick(Sender:TObject);
begin
  //WebBrowser.Clear;
  Close;
end;

procedure TFMajInternet.TabInternetDrawTabEx(AControl:TCustomTabControl;
  ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  if ATab.PageIndex = AControl.PageIndex then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
end;

procedure TFMajInternet.p_AfterDownloadExe;
begin

end;

{$IFDEF HTMLVIEW}

procedure TFMajInternet.WebBrowserHotSpotClick(Sender: TObject;
  const Target, URL: ThtString; var Handled: boolean);
{This routine handles what happens when a hot spot is clicked.  The assumption
 is made that DOS filenames are being used. .EXE, .WAV, .MID, and .AVI files are
 handled here, but other file types could be easily added.

 If the URL is handled here, set Handled to True.  If not handled here, set it
 to False and ThtmlViewer will handle it.}
{$ifndef MultiMediaMissing}
const
  snd_Async = $0001;  { play asynchronously }
{$endif}
var
  PC: array[0..255] of {$ifdef UNICODE} WideChar {$else} AnsiChar {$endif};
  S, Params: ThtString;
  Ext: string;
  I, J, K: integer;
begin
  Handled := False;

  {check for various file types}
  I := Pos(':', URL);
  J := Pos('FILE:', UpperCase(URL));
  if (I <= 2) or (J > 0) then
  begin                      {apparently the URL is a filename}
    S := URL;
    K := Pos(' ', S);     {look for parameters}
    if K = 0 then K := Pos('?', S);  {could be '?x,y' , etc}
    if K > 0 then
    begin
      Params := Copy(S, K+1, 255); {save any parameters}
      setLength(S, K-1);            {truncate S}
    end
    else
      Params := '';
    S := (Sender as TFrameViewer).HTMLExpandFileName(S);
    Ext := Uppercase(ExtractFileExt(S));
    if Ext = '.WAV' then
    begin
      Handled := True;
  {$ifndef MultiMediaMissing}
//      sndPlaySound(StrPCopy(PC, S), snd_ASync);
  {$endif}
    end
    else if Ext = '.EXE' then
    begin
      Handled := True;
      fs_executeprocess(S, ' ' + Params, False,[]);
    end
    else if (Ext = '.MID') or (Ext = '.AVI')  then
    begin
      Handled := True;
      fs_executeprocess('MPlayer.exe',' /play /close ' + S, False,[]);
    end;
    {else ignore other extensions}
//    Edit2.Text := URL;
    Exit;
  end;

  I := Pos('MAILTO:', UpperCase(URL));
  J := Pos('HTTP://', UpperCase(URL));
  if (I > 0) or (J > 0) then
  begin
    {Note: ShellExecute causes problems when run from Delphi 4 IDE}
    p_OpenFileOrDirectory( URL);
    Handled := True;
    Exit;
  end;

//  Edit2.Text := URL;   {other protocall}
end;

procedure TFMajInternet.WebBrowserHotSpotCovered(Sender: TObject;
  const Target, URL: ThtString);
{mouse moved over or away from a hot spot.  Change the status line}
var
  Text: ThtString;
begin
  if URL = '' then
    Text := ''
  else if Target <> '' then
    Text := 'Target: '+Target+'  URL: '+URL
  else
    Text := 'URL: '+URL;

{$ifdef UseTNT}
  TntLabel.Caption := Text;
{$else}
//  InfoPanel.Caption := Text;
{$endif}
end;

procedure TFMajInternet.WebBrowserLink(Sender: TObject; const Rel, Rev,
  Href: THtString);
begin
  p_OpenFileOrDirectory(Href);
end;

{$ELSE}
procedure TFMajInternet.WebBrowserLink(const Sender: TLazbro);
begin
  p_OpenFileOrDirectory(Sender.BaseUrl);
end;

{$ENDIF}


end.

