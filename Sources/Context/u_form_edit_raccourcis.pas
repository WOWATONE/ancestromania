{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania GPL                             }
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

unit u_form_edit_raccourcis;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  U_FormAdapt,u_comp_TYLanguage,DB,
  U_ExtDBGrid,
  StdCtrls,Controls,Classes,ExtCtrls,
  u_buttons_appli,
  IBTable;

type

  { TFEditRaccourcis }

  TFEditRaccourcis=class(TF_FormAdapt)
    DataSource:TDataSource;
    dxDBGrid1: TExtDBGrid;
    pBorder:TPanel;
    Panel7:TPanel;
    Panel4:TPanel;
    Panel5:TPanel;
    Panel6:TPanel;
    btnAdd:TFWAdd;
    btnDel:TFWDelete;
    Label3:TLabel;
    Language:TYLanguage;
    btnFermer:TFWClose;
    btnImport:TFWImport;
    btnExport:TFWExport;
    Query:TIBTable;
{$IFNDEF FPC}
    QueryRAC_CLEF: TLongintField;
    QueryRAC_RAC: TIBStringField;
    QueryRAC_LIBELLE: TIBStringField;
{$ENDIF}
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure btnAddClick(Sender:TObject);
    procedure btnDelClick(Sender:TObject);
    procedure SuperFormCloseQuery(Sender:TObject;var CanClose:Boolean);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);

    procedure SuperFormCreate(Sender:TObject);
    procedure btnImportClick(Sender:TObject);
    procedure btnExportClick(Sender:TObject);
    procedure QueryBeforePost(DataSet:TDataSet);
    procedure QueryBeforeDelete(DataSet:TDataSet);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure QueryAfterDelete(DataSet: TDataSet);
  private
    procedure OpenQuery;
  public

  end;

implementation

uses u_dm,
    u_common_functions,
    u_common_ancestro,u_common_ancestro_functions,
    u_common_const,
    u_genealogy_context,
    u_form_export_table_2_textfile,
    u_form_Import_textfile_2_table,
    fonctions_dialogs,
    fonctions_string,
    Dialogs,
    SysUtils;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFEditRefParticules }

procedure TFEditRaccourcis.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Panel7.Color:=gci_context.ColorLight;
  btnAdd.Color:=gci_context.ColorLight;
  btnDel.Color:=gci_context.ColorLight;
  btnAdd.ColorFrameFocus:=gci_context.ColorLight;
  btnDel.ColorFrameFocus:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
end;

procedure TFEditRaccourcis.SuperFormShowFirstTime(Sender:TObject);
begin
  caption:=rs_Caption_keyboard_shortcuts;
  OpenQuery;
end;

procedure TFEditRaccourcis.OpenQuery;
begin
  Query.DisableControls;
  try
    Query.Close;
    Query.Open;
  finally
    Query.EnableControls;
  end;
  doRefreshControls;
end;

procedure TFEditRaccourcis.SuperFormRefreshControls(Sender:TObject);
begin
  btnAdd.enabled:=Query.Active;
  btnDel.enabled:=Query.Active and not Query.IsEmpty;
end;

procedure TFEditRaccourcis.btnAddClick(Sender:TObject);
begin
  Query.Insert;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRaccourcis.QueryAfterInsert(DataSet: TDataSet);
begin
  doRefreshControls;
end;

procedure TFEditRaccourcis.btnDelClick(Sender:TObject);
begin
  Query.Delete;
end;

procedure TFEditRaccourcis.QueryBeforeDelete(DataSet:TDataSet);
begin
  if MyMessageDlg(rs_Do_you_delete_this_shortcut_input
    ,mtConfirmation, [mbYes,mbNo],Self)<>mrYes then
    Abort;
end;

procedure TFEditRaccourcis.QueryAfterDelete(DataSet: TDataSet);
begin
  doRefreshControls;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRaccourcis.QueryBeforePost(DataSet:TDataSet);
var
  chaine:string;
  continue:boolean;
begin
  chaine:='';
  continue:=true;
  if DataSet.FieldByName('RAC_LIBELLE').AsString='' then
  begin
    continue:=false;
    chaine:='Le texte';
  end;
  if Trim(DataSet.FieldByName('RAC_RAC').AsString)='' then
  begin
    continue:=false;
    chaine:='L''abréviation';
  end;
  if continue then
  begin
    if DataSet.FieldByName('RAC_CLEF').AsInteger=0 then
      DataSet.FieldByName('RAC_CLEF').AsInteger:=dm.uf_GetClefUnique('REF_RACCOURCIS');
  end
  else
  begin
    MyMessageDlg(fs_RemplaceMsg(rs_Error_must_not_to_be_empty,[chaine])
    ,mtError,[mbOk],Self);
    SendFocus(dxDBGrid1);
    Abort;
  end;
end;

procedure TFEditRaccourcis.SuperFormCloseQuery(Sender:TObject;var CanClose:Boolean);
begin
  if Query.Active and(Query.State in [dsEdit,dsInsert])then
    Query.Post;
  dm.IBTrans_Secondaire.CommitRetaining;
  Query.Close;
  dm.LoadRaccourcis;
end;

procedure TFEditRaccourcis.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        dm.IBTrans_Secondaire.RollbackRetaining;
        OpenQuery;
      end;
    _KEY_HELP:p_ShowHelp(_ID_EDIT_RACCOURCIS_SAISIE);
  end;
end;

procedure TFEditRaccourcis.btnImportClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    aFImportTextFile2Table.TableName:='REF_RACCOURCIS';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex:='GEN_REF_RACCOURCIS';
    aFImportTextFile2Table.NamePrimaryIndex:='RAC_CLEF';
    aFImportTextFile2Table.ParamsTable.Add('RAC_CLEF');
    aFImportTextFile2Table.ParamsTable.Add('RAC_RAC');
    aFImportTextFile2Table.ParamsTable.Add('RAC_LIBELLE');
    aFImportTextFile2Table.chbVider.Checked:=true;
    if aFImportTextFile2Table.ShowModal=mrOk then
      OpenQuery;
  finally
    aFImportTextFile2Table.free;
  end;
end;

procedure TFEditRaccourcis.btnExportClick(Sender:TObject);
var
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
  try
    aFExportTable2TextFile.TableName:='REF_RACCOURCIS';
    aFExportTable2TextFile.PropositionFileNameExport:='REF_RACCOURCIS.txt';
    aFExportTable2TextFile.ShowModal;
  finally
    aFExportTable2TextFile.Free;
  end;
end;

end.

