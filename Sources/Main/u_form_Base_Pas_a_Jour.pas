{procédure de mise à jour entièremenent refaite par AL 2009}
unit u_form_Base_Pas_a_Jour;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  shellapi, jpeg, Windows,
{$ELSE}
  lazutf8classes,
{$ENDIF}
  Forms,StdCtrls,u_buttons_appli, u_ancestropictimages,ExtJvXPButtons,
  Controls,ExtCtrls,SysUtils,Dialogs;

const FIREBIRD_EXE = {$IFDEF WINDOWS}'isql.exe'{$ELSE}'isql-fb'{$ENDIF};

type

  { TFBasePasAJour }

  TFBasePasAJour=class(TForm)
    btnClose: TFWClose;
    btnMAJdirecte: TJvXPButton;
    btnMAJNet: TJvXPButton;
    IATitle1: TIATitle;
    Panel2: TPanel;
    Panel3:TPanel;
    Label2:TLabel;
    lInfos:TLabel;
    Memo1:TMemo;
//    Process: TProcess;
    procedure btnCloseClick(Sender:TObject);
    procedure FormClose(Sender:TObject;var Action:TCloseAction);
    procedure btnMAJdirecteClick(Sender:TObject);
    procedure FormCreate(Sender:TObject);
    procedure btnMAJNetClick(Sender:TObject);
    procedure FormShow(Sender:TObject);

  private
    { Déclarations privées }
    SqlAExec:TStringlistUTF8;
    FicMigration:string;
    function optimiser:boolean;
    function ExecuteScript(NomScript:string):boolean;

  public
    { Déclarations publiques }
    iRetour:integer;
  end;

implementation

uses u_common_functions,
     u_common_ancestro,
     u_firebird_functions,
     u_Dm,u_Common_Const,IBServices,IBSQL,
     u_genealogy_context,StrUtils,FileUtil,
     u_common_ancestro_functions,
     {$IFNDEF WINDOWS}
     fonctions_init,
     fonctions_file,
     {$ENDIF}
     fonctions_dialogs,
     fonctions_system,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

const CST_OPTIMISATION = 'optimisation';
      CST_SCRIPT_DIR = 'Scripts'+DirectorySeparator;

procedure TFBasePasAJour.btnCloseClick(Sender:TObject);
begin
  iRetour:=-1;
  Close;
end;

procedure TFBasePasAJour.FormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  Screen.Cursor:=crDefault;
  SqlAExec.Free;
  Action:=caHide;
end;

procedure TFBasePasAJour.btnMAJdirecteClick(Sender:TObject);
var
  sFichier:string;
  OkExec:boolean;
  i:integer;
begin
  if MyMessageDlg(rs_did_you_copy_this_database_before_updating+_CRLF+
    rs_If_no_you_should_cancel_update+_CRLF+
    rs_Youll_update_after_having_copied+_CRLF+
    rs_if_you_use_server_version_you_must_have_got_the_rights_from_server,mtConfirmation, [mbYes,mbCancel],Self)<>mrYes then
    exit;

  btnMAJdirecte.Enabled:=false;
  btnClose.Enabled:=false;
  btnMAJNet.Enabled:=false;
  OkExec:=false;
  iRetour:=-1;
  if FileExistsUTF8(FicMigration) { *Converted from FileExistsUTF8*  } then
    DeleteFileUTF8(FicMigration); { *Converted from DeleteFileUTF8*  }

  for i:=0 to SqlAExec.Count-1 do
  begin
    sFichier:=SqlAExec[i];
    if sFichier=CST_OPTIMISATION
     then OkExec:=optimiser
     else OkExec:=ExecuteScript(sFichier);
    if not OkExec then
      Break;
  end;
  if OkExec then
  begin
    iRetour:=1;
    dm.ibd_BASE.Open;
    dm.IBT_base.StartTransaction;
  end;
  close;
end;

{$IFDEF WiINDOWS}
function fs_executeFBProcess ( const sParams : String ):String;
var ls_File : String ;
    lh_handleFile : THandle;
Begin
  ls_File := fs_GetIniDir+'sql-firebird';
  if FileExistsUTF8(ls_File+CST_EXTENSION_BATCH_FILE) Then DeleteFileUTF8(ls_File+CST_EXTENSION_BATCH_FILE);
  lh_handleFile := {$IFDEF WINDOWS}FileCreate{$ELSE}FileCreateUTF8{$ENDIF}(ls_File+CST_EXTENSION_BATCH_FILE);
  try
    FileWriteln(lh_handleFile, FIREBIRD_EXE+ sParams);
  finally
    FileClose(lh_handleFile);
  end;

  Result := fs_ExecuteProcess({$IFNDEF WINDOWS}'sh',{$ENDIF}ls_File+CST_EXTENSION_BATCH_FILE,True);
End;
{$ENDIF}

function TFBasePasAJour.ExecuteScript(NomScript:string):boolean;
var
  sParams:string;
  //StartInfo:TStartupInfo;
//  ProcessInfo:TProcessInformation;
                            {
  procedure AttenteFin;
  var
    Fin:boolean;
  begin
    Fin:=False;
    repeat
      if WaitForSingleObject(ProcessInfo.hProcess,200)=WAIT_OBJECT_0 then
        Fin:=True;// L'application est terminée sinon on repart pour 200ms
      Application.ProcessMessages;
    until Fin;
  end;
                             }
begin
{  FillChar(StartInfo,SizeOf(StartInfo),#0);
  StartInfo.cb:=SizeOf(StartInfo);
  StartInfo.dwFlags:=STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow:=SW_HIDE;}
  try
    {$IFDEF WINDOWS}
    if AnsiPos(':',gci_context.PathFileNameBdd)=2 then
      sParams:=ExtractShortPathNameUTF8(gci_context.PathFileNameBdd)
    else
    {$ENDIF}
      sParams:=gci_context.PathFileNameBdd;

    sParams:=' "'+sParams+'" -ch UTF-8 -U '
               +_user_name+' -P '+_password+' -m -o "'+FicMigration+'" -i '
               +'"'+ExtractShortPathNameUTF8(gci_context.Path_Applis_Ancestro+CST_SCRIPT_DIR+NomScript)+'"';

    doShowWorking(rs_wait_script_execution+_CRLF+NomScript);
    sParams := fs_ExecuteProcess ( FIREBIRD_EXE, sParams{$IFNDEF WINDOWS},False{$ENDIF});
    if sParams >'' Then
     Begin
      ShowMessage(NomScript+' :'+_CRLF+sParams);
      result:=false;
     end
    Else
     result:=true;
    doCloseWorking;
   except
      result:=false;
      RaiseLastOSError;
   end;
end;

procedure TFBasePasAJour.FormCreate(Sender:TObject);
  function GetVersionScript(chaine:string;var V:integer):boolean;
  var
    i:integer;
    s:string;
    c:Char;
  begin
    s:='';
    for i:=Length(chaine)downto 1 do
    begin
      c:=chaine[i];
      if c in ['0'..'9'] then
        s:=c+s
      else
        break;
    end;
    result:=TryStrToInt(s,V);
  end;

var
  sInfos:string;
  FichOK:boolean;
  SR:TSearchRec;
  VersionMax,VersionCur:Integer;
  i:integer;
  ListSql:TStringlistUTF8;
  TmpDir:array[0..MAX_PATH] of char;
  VerBaseActuelle:Extended;
  procedure p_addSQL ( const s : String );
  Begin
    if ListSql.IndexOf(s)>=0 then
      SqlAExec.Add(s)
    else
      FichOK:=false;
  end;
  procedure p_oldUpdates;
  Begin
    if VerBaseActuelle<4.028 then
      p_addSQL ( 'maj_b357_b4028.sql');

    if VerBaseActuelle<4.01 then
      p_addSQL ( 'maj_tag_eve.sql');

    if VerBaseActuelle<4.043 then
      p_addSQL ( 'maj_b4028_b4043.sql');

    if VerBaseActuelle<5 then
    begin
      p_addSQL ( 'maj_b4043_b4060.sql');
      SqlAExec.Add(CST_OPTIMISATION);
    end;

    if VerBaseActuelle<5.04 then
      p_addSQL ( 'maj_b4060_b5040.sql');

    if VerBaseActuelle<5.06 then
      p_addSQL ( 'maj_b5041_b5060.sql');

    if VerBaseActuelle<5.1 then
      SqlAExec.Add(CST_OPTIMISATION);

    if VerBaseActuelle<5.16 then
      p_addSQL ( 'maj_b5160.sql');
    if VerBaseActuelle<5.161 then
      p_addSQL ( 'maj_b5161.sql');
  end;

begin
  Color:=gci_context.ColorLight;
  Memo1.Visible:=false;
  iRetour:=1;
  VersionMax:=0;
  SqlAExec:=TStringlistUTF8.Create;

  TmpDir :=GetTempDir;
  FicMigration:=TmpDir+'migration.log';

  FichOK:=false;
  if DirectoryExistsUTF8(gci_context.Path_Applis_Ancestro+CST_SCRIPT_DIR) then
   try
    if FindFirstUTF8(gci_context.Path_Applis_Ancestro+CST_SCRIPT_DIR+'*.sql', faAnyFile, SR) { *Converted from FindFirstUTF8*  }=0 then
    begin
      ListSql:=TStringlistUTF8.Create;
      try
        if GetVersionScript(extractFileNameWithoutExt(SR.Name),VersionCur) then
          VersionMax:=VersionCur;
        i:=0;
        ListSql.Add(SR.Name);
        while FindNextUTF8(SR) { *Converted from FindNextUTF8*  }=0 do
        begin
          ListSql.Add(SR.Name);
          inc(i);
          if GetVersionScript(extractFileNameWithoutExt(SR.Name),VersionCur) then
            if VersionCur>VersionMax then
              VersionMax:=VersionCur;
        end;
        FichOK:=true;

        if not ConvertStrToFloat(gci_context.VersionBase,VerBaseActuelle) then
          VerBaseActuelle:=0;

        p_oldUpdates;

        if VerBaseActuelle<5.170 then
         Begin
           p_addSQL ( 'maj_b5170.sql');
           MyMessageDlg(rs_Info_Base_must_use_utf8_characters);
         end
        Else
         Begin

           if VerBaseActuelle<5.172 then
              p_addSQL ( 'maj_b5172.sql');

           if VerBaseActuelle<5.180 then
              p_addSQL ( 'maj_b5180.sql');

           //next update here
         end;
        if VersionMax<trunc(dm.VersionBaseMini*1000)
         then
          FichOK:=false;

        SqlAExec.Add(CST_OPTIMISATION);
      finally
        ListSql.Free;
      end;
    end;
   finally
    FindCloseUTF8(SR); { *Converted from FindCloseUTF8*  }
   end;

  sInfos:=fs_RemplaceMsg(rs_Ancestromania_version_infos_too_old,
  [gci_context.VersionExe,sVersionBaseMini,gci_context.PathFileNameBdd,gci_context.VersionBase]);

  if FichOK then
  begin
    lInfos.Caption:=sInfos+_CRLF+_CRLF+
      fs_RemplaceMsg(rs_Ancestromania_update_exists_on_your_computer,[IntToStr(VersionMax div 1000)+'.'
      +LeftStr(IntToStr(VersionMax mod 1000)+'000',3)]);
  end
  else
  begin
    btnMAJNet.Left:=btnMAJdirecte.Left;
    btnMAJdirecte.Hide;
    btnMAJNet.Show;

    lInfos.Caption:=sInfos+_CRLF+_CRLF+
      rs_Ancestromania_update_files_have_not_been_found ;
  end;
end;

procedure TFBasePasAJour.btnMAJNetClick(Sender:TObject);
begin
  iRetour:=2;
  close;
  application.ProcessMessages;
end;

procedure TFBasePasAJour.FormShow(Sender:TObject);
begin
  caption:=rs_Database_must_be_updated;
end;

function TFBasePasAJour.optimiser:boolean;
var
  DiskSize:Int64;
  sr:TSearchRec;
  TailleFichier:LongInt;
  Pos:integer;
  ibRestore:TIBRestoreService;
  IBBackup:TIBBackupService;
  PathNameGBK,BackFile,Serveur,NomBase:string;
  Prot:Tprotocol;
  q:TIBSQL;
begin
  result:=false;
  doShowWorking(rs_wait_Optimising_database);
  try
    Memo1.Visible:=true;
    SendFocus(Memo1);
    Pos:=AnsiPos(':',gci_context.PathFileNameBdd);
    BackFile:='optimisation.fbk';
    if Pos>2 then //base réseau
    begin
      Prot:=TCP;
      Serveur:=copy(gci_context.PathFileNameBdd,1,Pos-1);
      NomBase:=copy(gci_context.PathFileNameBdd,Pos+1,250);
    end
    else //base locale
    begin
      Prot:=Local;
      Serveur:='';
      NomBase:=gci_context.PathFileNameBdd;
      {$IFDEF WINDOWS}
      PathNameGBK:=_TempPath;
      DiskSize:=DiskFree(ord(ExtractFileDrive(PathNameGBK)[1])-ord('A')+1);
      {$ELSE}
      PathNameGBK:=DEFAULT_FIREBIRD_DATA_DIR;
      DiskSize:=DiskFree(0);
      {$ENDIF}
      FindFirstUTF8(NomBase, faAnyFile, sr);
      TailleFichier:=sr.Size;
      FindCloseUTF8(sr);
      if DiskSize<TailleFichier then
      begin
        MyMessageDlg(fs_RemplaceMsg(rs_Error_Disk_space_not_Enough_You_have_bytes, [IntToStr(DiskSize)])
          ,mtInformation, [mbOK],Self);
        exit;
      end;
      BackFile:=ExcludeTrailingPathDelimiter(PathNameGBK)+DirectorySeparator+BackFile;
    end;

    try
      IBBackup:=TIBBackupService.Create(Self);
      with IBBackup do
      begin
        LoginPrompt:=False;
        Params.Add('user_name='+_user_name);
        Params.Add('password='+_password);
        Protocol:=Prot;
        ServerName:=Serveur;
        Active:=True;
        try
          Verbose:=True;
          Options:= [IgnoreLimbo];
          DatabaseName:=NomBase;
          BackupFile.Add(BackFile);
          ServiceStart;
          Memo1.Clear;
          while not Eof do
            Memo1.Lines.Append(GetNextLine);
        finally
          Active:=False;
          IBBackup.Free;
        end;
      end;

      ibRestore:=TIBRestoreService.Create(Self);
      with IBRestore do
      begin
        LoginPrompt:=False;
        Params.Add('user_name='+_user_name);
        Params.Add('password='+_password);
        Protocol:=Prot;
        ServerName:=Serveur;
        Active:=True;
        try
          Verbose:=True;
          Options:= [Replace];
          PageBuffers:=32000;
          PageSize:=4096;
          DatabaseName.Add(NomBase);
          BackupFile.Add(BackFile);
          ServiceStart;
          Memo1.Clear;
          while not Eof do
            Memo1.Lines.Append(GetNextLine);
        finally
          Active:=False;
          FreeAndNil(ibRestore);
        end;
      end;
    except
      MyMessageDlg(rs_Error_Has_append_during_restore
        ,mtError, [mbOK],Self);
      exit;
    end;

    dm.ibd_BASE.Connected:=true;
    dm.IBT_base.Active:=true;
    q:=TIBSQL.Create(self);
    try
      q.Database:=dm.ibd_BASE;
      q.Transaction:=dm.IBT_BASE;
      q.SQL.Text:='select rdb$get_context(''USER_SESSION'',''RATIO_TAILLE'') from rdb$database';
      q.ExecQuery;
      if not q.Fields[0].IsNull then
      begin
        q.Close;
        q.SQL.Text:='update t_version_base set octets_fichier=null';
        q.ExecQuery;
      end;
      gci_context.VersionBase:=fs_GetVersionBase (q);
    finally
      q.Free;
    end;
    dm.IBT_base.Commit;
    dm.ibd_BASE.Connected:=false;
    Memo1.Lines.Clear;
    memo1.Visible:=false;
    result:=true;
  finally
    doCloseWorking;
  end;
  Application.ProcessMessages;
end;

end.

