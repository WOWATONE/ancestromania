{Fiche créée par André le 10/06/2008 afin d'autoriser le transfert d'une généalogie
accompagnée de ses médias entre PC.
Elle permet de mettre à jour dans la base les chemins des médias mémorisés,
avec leurs nouvelles adresses.}

unit u_Form_Path_Medias;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,  Dialogs, forms, Controls, StdCtrls,
  ExtCtrls, u_framework_dbcomponents,
  u_framework_components,   IBSQL,SysUtils,  u_buttons_appli,ExtJvXPButtons;


type

  { TFPathMedias }

  TFPathMedias = class(TF_FormAdapt)
    pBorder: TPanel;
    Panel2: TPanel;
    Panel8: TPanel;
    Panel3: TPanel;
    btnFermer: TFWClose;
    btnRemplace: TFWRefresh;
    EdNouveauChemin: TFWEdit;
    Label1: TLabel;
    Label2: TLabel;
    EdPathActuel: TFWComboBox;
    procedure EdNouveauCheminPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure btnRemplaceClick(Sender: TObject);
    procedure onFormCreate(Sender: TObject);
    procedure EdNouveauCheminPropertiesExit(Sender: TObject);

  private
  procedure init;

  public

  end;

implementation

uses u_dm,
     u_common_const,
     u_common_functions,
     u_common_ancestro,
     u_genealogy_context,
     u_common_ancestro_functions,
     FileUtil,
     fonctions_dialogs,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFPathMedias.init;
var
  q:TIBSQL;
begin
  EdPathActuel.Items.Clear;
  EdPathActuel.Clear;
  EdNouveauChemin.Clear;
  q:=TIBSQL.Create(self);
  q.Database:=dm.ibd_BASE;
  q.Transaction:=dm.IBTrans_Secondaire;
  q.SQL.Text:='select distinct sr.path'
            +' from'
            +' (select'
            +' lower(left(multi_path,char_length(multi_path)-position('''+DirectorySeparator+''' in reverse(multi_path)))) as path'
            +' from multimedia'
            +' where char_length(multi_path)>0 and multi_dossier='+IntToStr(dm.NumDossier)+') as sr'
            +' order by sr.path';
  q.ExecQuery;
  while not q.Eof do
  begin
    EdPathActuel.Items.Add(q.fieldbyname('path').AsString);
    q.Next;
  end;
  q.Close;
  q.Free;
  if EdPathActuel.Items.Count>0 then
    EdPathActuel.ItemIndex:=0;
end;

procedure TFPathMedias.EdNouveauCheminPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var
  s:string;
begin
  s:=fPathBaseMedias;
  if SelectRepertoire(rs_Select_dir_New_Media_directory,s,self) then
    EdNouveauChemin.Text:=s;
end;

procedure TFPathMedias.btnRemplaceClick(Sender: TObject);
var
  q:TIBSQL;
begin
  if (length(EdNouveauChemin.Text)=0) or (length(EdPathActuel.Text)=0) then
  begin
    MyMessageDlg(rs_Error_Set_Old_and_new_path_before_asking_replacing,mtError,[mbOK],Self);
    exit;
  end;
  if MyMessageDlg(fs_RemplaceMsg (rs_Error_Every_Medias_adresses_in_library_and_homes_begining_by_will_be_modified,
                  [EdPathActuel.Text])+_CRLF+_CRLF
                  +rs_confirm_replacing,mtWarning,[mbYes,mbNo],Self)=mrNo then
    exit;
  q:=TIBSQL.Create(self);
  q.Database:=dm.ibd_BASE;
  q.Transaction:=dm.IBTrans_Secondaire;
  Screen.Cursor:=crSQLWait;
  try
    try
      q.SQL.Add('update multimedia set multi_path='''
              +EdNouveauChemin.Text+'''||substring(multi_path from char_length('''
              +EdPathActuel.Text+''')+1)'
              +'where upper(multi_path) starting with upper('''+EdPathActuel.Text+''')'
              +' and multi_dossier='+IntToStr(dm.NumDossier));
      q.ExecQuery;
      q.Close;
      dm.doMAJTableJournal(copy(fs_RemplaceMsg (rs_Log_Replace_Media_by,[EdPathActuel.Text])+EdNouveauChemin.Text,1,300));
      dm.IBTrans_Secondaire.CommitRetaining;
      Screen.Cursor:=crDefault;
      MyMessageDlg(rs_Replace_done,mtInformation,[mbOK],Self);
    except
      dm.IBTrans_Secondaire.RollbackRetaining;
      MyMessageDlg(rs_Error_while_replacing+_CRLF
                  +rs_Error_update_Cancelled,mtError,[mbOK],Self);
    end;
  finally
    q.Free;
    Screen.Cursor:=crDefault;
  end;
  init;
end;

procedure TFPathMedias.onFormCreate(Sender: TObject);
begin
   Color:=gci_context.ColorLight;
   init;
end;

procedure TFPathMedias.EdNouveauCheminPropertiesExit(Sender: TObject);
var
  s:string;
begin
  s:=EdNouveauChemin.Text;
  if s='' then
  begin
    MyMessageDlg(rs_Error_directory_name_empty,mtError,[mbOK],Self);
  end
  else
  begin
    if not DirectoryExistsUTF8(s) { *Converted from DirectoryExistsUTF8*  } then
    begin
      if MyMessageDlg(rs_Warning_directory_does_not_exists+_CRLF
        +rs_do_you_create_it,mtWarning,[mbYes,mbNo],Self)= mrYes then
        if not ForceDirectoriesUTF8(s) { *Converted from ForceDirectories*  } then
        begin
          MyMessageDlg(rs_Error_cannot_create_this_directory,mtError,[mbOK],Self);
          Abort;
        end;
    end;
  end;
end;

end.
