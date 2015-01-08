{-----------------------------------------------------------------------}
{ Ancestromania                                                         }
 { Création u_form_edit_ref_filiation André Langlet 2009                 }
{-----------------------------------------------------------------------}

unit u_form_edit_ref_filiation;

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
  U_FormAdapt,u_comp_TYLanguage,Forms,
  DB,U_ExtDBGrid,
  StdCtrls,Controls,Classes,ExtCtrls,
  u_buttons_appli,
  IBTable;

type
  TFEditRefFiliation=class(TF_FormAdapt)
    DataSource:TDataSource;
    pBorder:TPanel;
    Panel7:TPanel;
    Panel4:TPanel;
    lbTitle:TLabel;
    Panel8:TPanel;
    Panel6:TPanel;
    Panel1:TPanel;
    dxDBGrid1:TExtDBGrid;
    btnAdd:TFWAdd;
    btnDel:TFWDelete;
    btnImport:TFWImport;
    btnExport:TFWExport;
    btnFermer:TFWClose;
    Language:TYLanguage;
    Query: TIBTable;
{$IFNDEF FPC}
    QueryFIL_LIBELLE: TStringField;
    QueryFIL_LANGUE: TStringField;
{$ENDIF}
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure btnAddClick(Sender:TObject);
    procedure btnDelClick(Sender:TObject);
    procedure btnExportClick(Sender:TObject);
    procedure btnImportClick(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure QueryBeforeDelete(DataSet: TDataSet);
    procedure QueryAfterDelete(DataSet: TDataSet);
    procedure QueryBeforePost(DataSet: TDataSet);
    procedure SuperFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    Dialogs,
    SysUtils;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFEditRefFiliation }

procedure TFEditRefFiliation.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Panel7.Color:=gci_context.ColorLight;
  btnAdd.Color:=gci_context.ColorLight;
  btnDel.Color:=gci_context.ColorLight;
  {
  btnAdd.ColorFocus:=gci_context.ColorLight;
  btnDel.ColorFocus:=gci_context.ColorLight;
  }
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
end;

procedure TFEditRefFiliation.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_Refering_childness;
  OpenQuery;
end;

procedure TFEditRefFiliation.OpenQuery;
begin
  Query.DisableControls;
  try
    Query.Close;
    Query.Filtered:=false;
    Query.Open;
    Query.Filter:='FIL_LANGUE='''+gci_context.Langue+'''';
    Query.Filtered:=true;
  finally
    Query.EnableControls;
  end;
  doRefreshControls;
end;

procedure TFEditRefFiliation.SuperFormRefreshControls(Sender:TObject);
begin
  btnAdd.enabled:=Query.Active;
  btnDel.enabled:=Query.Active and not Query.IsEmpty;
end;

procedure TFEditRefFiliation.btnAddClick(Sender:TObject);
begin
  Query.Insert;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefFiliation.QueryAfterInsert(DataSet: TDataSet);
begin
  doRefreshControls;
end;

procedure TFEditRefFiliation.btnDelClick(Sender:TObject);
begin
  Query.Delete;
end;

procedure TFEditRefFiliation.QueryBeforeDelete(DataSet: TDataSet);
begin
  if MyMessageDlg(rs_Do_you_delete_this_child_link
    ,mtConfirmation,[mbYes,mbNo],Self)<>mrYes then
    Abort;
end;

procedure TFEditRefFiliation.QueryAfterDelete(DataSet: TDataSet);
begin
  doRefreshControls;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefFiliation.QueryBeforePost(DataSet: TDataSet);
begin
  if Trim(DataSet.FieldByName('FIL_LIBELLE').AsString)='' then
  begin
    MyMessageDlg(rs_Error_child_link_not_to_be_empty_or_spaces_filled
    ,mtError,[mbOk],Self);
    SendFocus(dxDBGrid1);
    Abort;
  end
  else
  begin
    if DataSet.FieldByName('FIL_LANGUE').AsString='' then
      DataSet.FieldByName('FIL_LANGUE').AsString:=gci_context.Langue;
  end;
end;

procedure TFEditRefFiliation.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  if Query.Active and(Query.State in [dsEdit,dsInsert]) then
    Query.Post;
  dm.IBTrans_Secondaire.CommitRetaining;
  Query.Close;
end;

procedure TFEditRefFiliation.SuperFormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
    begin
      dm.IBTrans_Secondaire.RollbackRetaining;
      OpenQuery;
    end;
  end;
end;

procedure TFEditRefFiliation.btnExportClick(Sender:TObject);
var
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
  try
    aFExportTable2TextFile.TableName:='REF_FILIATION';
    aFExportTable2TextFile.PropositionFileNameExport:='Filiations.txt';
    aFExportTable2TextFile.ShowModal;
  finally
    aFExportTable2TextFile.Free;
  end;
end;

procedure TFEditRefFiliation.btnImportClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    aFImportTextFile2Table.TableName:='REF_FILIATION';
    aFImportTextFile2Table.ParamsTable.Add('FIL_LIBELLE');
    aFImportTextFile2Table.ParamsTable.Add('FIL_LANGUE');
    aFImportTextFile2Table.chbVider.Checked:=true;
    if aFImportTextFile2Table.ShowModal=mrOk then
      OpenQuery;
  finally
    aFImportTextFile2Table.free;
  end;
end;

end.

