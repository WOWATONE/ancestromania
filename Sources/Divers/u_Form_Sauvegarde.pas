unit u_Form_Sauvegarde;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  ShellApi, jpeg, Windows,
{$ELSE}
{$ENDIF}
  SysUtils,Dialogs,U_FormAdapt,
  StdCtrls,ExtCtrls,Controls,Forms,
  u_ancestropictimages,ExtJvXPCheckCtrls,
  u_buttons_appli, U_OnFormInfoIni, MaskEdit;

type

  { TFSauvegarde }

  TFSauvegarde=class(TF_FormAdapt)
    btnclose: TFWClose;
    btnGO: TFWOK;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    Panel3:TPanel;
    Image1:TIATitle;
    Label1:TLabel;
    gbNomBase:TGroupBox;
    lDate:TLabel;
    eNomBase:TMaskEdit;
    cbAjoutDate:TJvXPCheckBox;
    Label2: TLabel;
    procedure FormCreate(Sender:TObject);
    procedure btncloseClick(Sender:TObject);
    procedure btnGOClick(Sender:TObject);
    procedure cbAjoutDateClick(Sender:TObject);
  private

  public

  end;

implementation

uses u_dm,
     u_common_functions,
     u_form_main,
     u_common_ancestro,
     fonctions_dialogs,
     u_common_const,
     u_common_ancestro_functions,
     u_genealogy_context,
     FileUtil,fonctions_string,fonctions_system;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFSauvegarde.FormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  eNomBase.Text:=ExtractFileName(gci_context.PathFileNameBdd);
  lDate.Caption:=eNomBase.Text;
  cbAjoutDateClick(self);
end;

procedure TFSauvegarde.btncloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFSauvegarde.btnGOClick(Sender:TObject);

var
  DiskSize,FileSize:Int64;
  lecteur:string;
  PathNameGBK,s:string;
begin
  btnGO.Enabled:=False;
  if dm.ibd_BASE.Connected then //AL
  begin
    dm.IBT_BASE.CommitRetaining;
    dm.IBTrans_Secondaire.CommitRetaining;
  end;

  PathNameGBK:=ExcludeTrailingPathDelimiter(gci_context.PathSauvegarde);//AL
  s:=eNomBase.Text;
  while IsDelimiter(PathDelim,s,1) do
    Delete(s,1,1);
  eNomBase.Text:=s;
  s:=ExtractFilePath(PathNameGBK+PathDelim+eNomBase.Text);
  if not DirectoryExistsUTF8(s) then
    if not ForceDirectoriesUTF8(s) then
    begin
      MyMessageDlg(fs_RemplaceMsg(rs_Error_Directory_cannot_be_created,[s])+_CRLF
        +rs_Error_You_should_choose_another_save_directory_without_readonly
        ,mtWarning,[mbOK],Self);
    end;

  if Length(eNomBase.Text)>0 then
  begin
    if SelectRepertoire(rs_Select_dir_directory_destination_of_base,s,self) then
    begin
      eNomBase.Text:=ExtractFileName(eNomBase.Text);//lDate.Caption est mis à jour
      lecteur:=AnsiUpperCase(ExtractFileDrive(s+PathDelim+lDate.Caption));
      if length(lecteur)=2 then //contrôle possible uniquement sur un disque local
      begin
        DiskSize:=DiskFree(ord(lecteur[1])-64);
        FileSize:=fi_TailleFichier(gci_context.PathFileNameBdd);
        if DiskSize<FileSize then
        begin
          MyMessageDlg(fs_RemplaceMsg(rs_Error_Not_enough_space_only_bytes_but_bytes_needed,[IntToStr(DiskSize),IntToStr(FileSize)])
            ,mtError, [mbOK],Self);
          btnGO.Enabled:=True;
          exit;
        end;
      end;

      if not DirectoryExistsUTF8(s) then
      begin
        if not ForceDirectoriesUTF8(s) then
        begin
          MyMessageDlg(fs_RemplaceMsg(rs_Error_Directory_cannot_be_created,[s])+_CRLF
            +rs_Error_Writing_is_forbidden_on_this_dir_or_device
            ,mtError, [mbOK],Self);
          btnGO.Enabled:=True;
          Exit;
        end;
      end;
      Screen.Cursor:=crHourglass;
      Application.ProcessMessages;//pour que la fiche de sélection ait le temps de se cacher
      dm.doCloseDatabase;
      try
        if CopyFile(gci_context.PathFileNameBdd,
          s+PathDelim+lDate.Caption,False) then
        begin
          Screen.Cursor:=crDefault;
          if dm.ibd_BASE.Connected then
            dm.doMAJTableJournal(rs_Log_Copy_database_in+s);
          MyMessageDlg(rs_Database_copied_in+_CRLF+s+'.',mtInformation, [mbOK],Self);
        end
        else
        begin
          Screen.Cursor:=crDefault;
          MyMessageDlg(rs_Error_Database_not_copied,mtError,[mbOK],Self);
        end;
      finally
        with FMain do
         if dm.doOpenDatabase=1
          then dm.doOpenCurrentFolder
          else OpenModule(_ID_EMPLACEMENT_BDD);
      end;
    end;
  end;
  btnGO.Enabled:=True;
end;

procedure TFSauvegarde.cbAjoutDateClick(Sender:TObject);
var
  s:string;
begin
  if cbAjoutDate.Checked then
  begin
    S:=FormatDateTime('yymmdd"-"hhnn',Now);
    lDate.Caption:=eNomBase.Text+s;
  end
  else
    lDate.Caption:=eNomBase.Text;
  lDate.Visible:=cbAjoutDate.Checked;
end;

end.

