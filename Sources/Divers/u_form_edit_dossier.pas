{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
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

unit u_form_edit_dossier;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, ShlObj, Mask, Windows,
{$ELSE}
  LCLType, FileUtil,
{$ENDIF}
  U_FormAdapt,u_comp_TYLanguage,DB,
  StdCtrls,Controls,DBCtrls,Classes,
  ExtCtrls,u_framework_dbcomponents,
  u_buttons_appli,
  u_extDBDirectoryEdit,
  Dialogs,SysUtils, ExtJvXPCheckCtrls, Forms;

type

  { TFEditDossier }

  TFEditDossier=class(TF_FormAdapt)
    bsfbSelection: TFWOK;
    btnFermer: TFWClose;
    cbImages: TJvXPCheckbox;
    cbLangue: TFWDBComboBox;
    DBText1: TDBText;
    dxDBEdit1: TFWDBEdit;
    dxDBMemo1: TFWDBMemo;
    edFicNotes: TFWDBEdit;
    edPathBaseMedias: TExtDBDirectoryEdit;
    fpBoutons: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    panDock: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    pBorder:TPanel;
    DataSource:TDataSource;
    Language:TYLanguage;
    pGlobal: TPanel;
    SelectFichier:TOpenDialog;

    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure edPathBaseMediasButtonClick(Sender:TObject;
      AbsoluteIndex:Integer);
    procedure edFicNotesButtonClick(Sender:TObject;
      AbsoluteIndex:Integer);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure edPathBaseMediasPropertiesExit(Sender: TObject);
  private

  public

  end;

implementation

uses  u_dm,
      u_common_const,
      fonctions_dialogs,
      u_common_functions,
      u_common_ancestro_functions,
      u_genealogy_context,
      u_common_ancestro,IBSQL;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFEditDossier.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  edFicNotes.Hint:=rs_Hint_Directory_select;
end;

procedure TFEditDossier.SuperFormKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:ModalResult:=mrCancel;
    _KEY_HELP:p_ShowHelp(_ID_DOSSIER);
  end;
end;

procedure TFEditDossier.edPathBaseMediasButtonClick(Sender:TObject;
  AbsoluteIndex:Integer);
var
  s:string;
begin
  s:=edPathBaseMedias.Text;
  if SelectRepertoire(rs_Directory_of_Medias,s,self) then
  begin
    DataSource.DataSet.FieldByName('ds_base_path').AsString:=s;
    edPathBaseMedias.Text:=s;
  end;
end;

procedure TFEditDossier.edFicNotesButtonClick(Sender:TObject;
  AbsoluteIndex:Integer);
begin
  SelectFichier.Title:=rs_Choose_notes_file;
  if DirectoryExistsUTF8(edFicNotes.Text) { *Converted from DirectoryExistsUTF8*  } then
    SelectFichier.InitialDir:=edFicNotes.Text
  else if FileExistsUTF8(edFicNotes.Text) { *Converted from FileExistsUTF8*  } then
    SelectFichier.FileName:=edFicNotes.Text;
  if SelectFichier.Execute then
  begin
    DataSource.DataSet.FieldByName('ds_fic_notes').AsString:=SelectFichier.FileName;
    edFicNotes.Text:=SelectFichier.FileName;
  end;
end;

procedure TFEditDossier.SuperFormShowFirstTime(Sender:TObject);
var
  q:TIBSQL;
begin
  caption:=rs_Form_Modifying_folder;
  q:=TIBSQL.Create(self);
  try
    q.Database:=dm.ibd_BASE;
    q.Transaction:=dm.IBT_BASE;
    q.SQL.Clear;
    q.SQL.Add('select count(*) from individu where kle_dossier=:dossier');
    q.Params[0].AsInteger:=DataSource.DataSet.FieldByName('CLE_DOSSIER').AsInteger;
    q.ExecQuery;
    cbLangue.Enabled:=q.Fields[0].AsInteger=0;
    q.Close;
  finally
    q.Free;
  end;
end;

procedure TFEditDossier.edPathBaseMediasPropertiesExit(Sender: TObject);
var
  s:string;
begin
  s:=edPathBaseMedias.Text;
  if s='' then
  begin
    MyMessageDlg(rs_Error_Directory_name_empty,mtError,[mbOK],Self);
  end
  else
  begin
    if not DirectoryExistsUTF8(s) { *Converted from DirectoryExistsUTF8*  } then
    begin
      if MyMessageDlg(rs_Warning_directory_does_not_exists+_CRLF
        +rs_Do_you_create_it,mtWarning,[mbYes,mbNo],Self)= mrYes then
        if not ForceDirectoriesUTF8(s) { *Converted from ForceDirectories*  } then
        begin
          MyMessageDlg(rs_Error_Directory_cannot_be_created, mtWarning, [mbOK], Self );
          Abort;
        end;
    end;
  end;
end;

end.

