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

unit u_form_edit_ref_prefixes;

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
  U_ExtDBGrid,StdCtrls,Controls,
  Classes,ExtCtrls,u_buttons_appli,
  IBTable;

type
  TFEditRefPrefixes=class(TF_FormAdapt)
    DataSource:TDataSource;
    pBorder:TPanel;
    Panel7:TPanel;
    Panel4:TPanel;
    lbTitle:TLabel;
    Panel5:TPanel;
    Panel6:TPanel;
    Panel1:TPanel;
    dxDBGrid1:TExtDBGrid;
    btnAdd:TFWAdd;
    btnDel:TFWDelete;
    Language:TYLanguage;
    btnImport:TFWImport;
    btnExport:TFWExport;
    btnFermer:TFWClose;
    Query: TIBTable;
{$IFNDEF FPC}
    QueryPR_CLEF: TLongintField;
    QueryPR_LIBELLE: TStringField;
{$ENDIF}
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure btnAddClick(Sender:TObject);
    procedure btnDelClick(Sender:TObject);
    procedure SuperFormCloseQuery(Sender:TObject;var CanClose:Boolean);
    procedure btnExportClick(Sender:TObject);
    procedure btnImportClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);

    procedure SuperFormCreate(Sender:TObject);
    procedure QueryBeforePost(DataSet: TDataSet);
    procedure QueryAfterDelete(DataSet: TDataSet);
    procedure QueryBeforeDelete(DataSet: TDataSet);
    procedure QueryAfterInsert(DataSet: TDataSet);
  private
    procedure OpenQuery;
  public

  end;

implementation

uses u_dm,
    u_common_functions,u_common_ancestro,
    u_common_const,
    u_common_ancestro_functions,
    u_form_export_table_2_textfile,
    u_form_Import_textfile_2_table,
    u_genealogy_context,
    fonctions_dialogs,
    Dialogs,
    SysUtils;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFEditRefParticules }

procedure TFEditRefPrefixes.SuperFormCreate(Sender:TObject);
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

procedure TFEditRefPrefixes.SuperFormShowFirstTime(Sender:TObject);
begin
  OpenQuery;
  Caption:=rs_Caption_Refering_civilities;
end;

procedure TFEditRefPrefixes.OpenQuery;
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

procedure TFEditRefPrefixes.SuperFormRefreshControls(Sender:TObject);
begin
  btnAdd.enabled:=Query.Active;
  btnDel.enabled:=Query.Active and not Query.IsEmpty;
end;

procedure TFEditRefPrefixes.btnAddClick(Sender:TObject);
begin
  Query.Insert;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefPrefixes.QueryAfterInsert(DataSet: TDataSet);
begin
  doRefreshControls;
end;

procedure TFEditRefPrefixes.btnDelClick(Sender:TObject);
begin
  Query.Delete;
end;

procedure TFEditRefPrefixes.QueryBeforeDelete(DataSet: TDataSet);
begin
  if MyMessageDlg(rs_Confirm_deleting_this_civility
    ,mtConfirmation,[mbYes,mbNo],Self)<>mrYes then
    Abort;
end;

procedure TFEditRefPrefixes.QueryAfterDelete(DataSet: TDataSet);
begin
  doRefreshControls;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefPrefixes.QueryBeforePost(DataSet: TDataSet);
begin
  with Dataset do
  if Trim(FieldByName('PR_LIBELLE').AsString)='' then
  begin
    MyMessageDlg(rs_Error_Civilit_not_to_be_empty_or_spaces_filled
    ,mtError,[mbOk],Self);
    SendFocus(dxDBGrid1);
    Abort;
  end
  else
  begin
    if FieldByName('PR_CLEF').AsInteger=0 then
      FieldByName('PR_CLEF').AsInteger:=dm.uf_GetClefUnique('REF_PREFIXES');
  end;
end;

procedure TFEditRefPrefixes.SuperFormCloseQuery(Sender:TObject;var CanClose:Boolean);
begin
  if Query.Active and(Query.State in [dsEdit,dsInsert]) then
    Query.Post;
  dm.IBTrans_Secondaire.CommitRetaining;
  Query.Close;
end;

procedure TFEditRefPrefixes.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:
    begin
      dm.IBTrans_Secondaire.RollbackRetaining;
      OpenQuery;
    end;
    _KEY_HELP:p_ShowHelp(_ID_EDIT_TABLE_REF_PREFIXES);
  end;
end;

procedure TFEditRefPrefixes.btnExportClick(Sender:TObject);
var
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
  try
    aFExportTable2TextFile.TableName:='REF_PREFIXES';
    aFExportTable2TextFile.PropositionFileNameExport:='Prefixes.txt';
    aFExportTable2TextFile.ShowModal;
  finally
    aFExportTable2TextFile.Free;
  end;
end;

procedure TFEditRefPrefixes.btnImportClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    aFImportTextFile2Table.TableName:='REF_PREFIXES';
    aFImportTextFile2Table.NamePrimaryIndex:='PR_CLEF';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex:='GEN_REF_PREFIXES';
    aFImportTextFile2Table.ParamsTable.Add('PR_CLEF');
    aFImportTextFile2Table.ParamsTable.Add('PR_LIBELLE');
    aFImportTextFile2Table.chbVider.Checked:=true;

    if aFImportTextFile2Table.ShowModal=mrOk then
      OpenQuery;
  finally
    aFImportTextFile2Table.free;
  end;
end;

end.

