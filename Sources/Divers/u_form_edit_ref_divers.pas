{-----------------------------------------------------------------------}
{ Ancestromania                                                         }
{ Création u_form_edit_ref_Divers André Langlet 2009                 }
{-----------------------------------------------------------------------}

unit u_form_edit_ref_Divers;

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
  U_FormAdapt,Forms,
  DB,U_ExtDBGrid,
  StdCtrls,Controls,Classes,ExtCtrls,
  u_buttons_appli,
  IBTable;

type
  TFEditRefDivers=class(TF_FormAdapt)
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
    Query:TIBTable;
{$IFNDEF FPC}
    QueryREF_LANGUE:TStringField;
    QueryREF_LIBELLE:TStringField;
{$ENDIF}
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure btnAddClick(Sender:TObject);
    procedure btnDelClick(Sender:TObject);
    procedure btnExportClick(Sender:TObject);
    procedure btnImportClick(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure QueryAfterInsert(DataSet:TDataSet);
    procedure QueryBeforeDelete(DataSet:TDataSet);
    procedure QueryAfterDelete(DataSet:TDataSet);
    procedure QueryBeforePost(DataSet:TDataSet);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
  private
    procedure OpenQuery;
  public
    NomTable:string;
  end;

implementation

uses  u_dm,
      u_common_functions,u_common_ancestro,
      u_common_ancestro_functions,
      u_form_export_table_2_textfile,
      u_form_Import_textfile_2_table,
      u_genealogy_context,
      fonctions_dialogs,
      Dialogs,
      SysUtils;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFEditRefDivers }

procedure TFEditRefDivers.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls :=SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Panel7.Color:=gci_context.ColorLight;
  btnAdd.Color:=gci_context.ColorLight;
  btnDel.Color:=gci_context.ColorLight;
  btnAdd.ColorFrameFocus:=gci_context.ColorLight;
  btnDel.ColorFrameFocus:=gci_context.ColorLight;
end;

procedure TFEditRefDivers.SuperFormShowFirstTime(Sender:TObject);
begin
  Query.TableName:=NomTable;
  Width:=310;
  if NomTable='REF_DIVERS_IND' then
    Caption:=rs_Caption_Label_of_other_events_of_persons
  else if NomTable='REF_DIVERS_FAM' then
    Caption:=rs_Caption_Label_of_other_events_of_families
  else if NomTable='REF_MARR' then
  begin
    Width:=360;
    Caption:=rs_Caption_Label_of_unions;
  end;
  OpenQuery;
end;

procedure TFEditRefDivers.OpenQuery;
begin
  Query.DisableControls;
  try
    Query.Close;
    Query.Filtered:=false;
    Query.Open;
    Query.Filter:='REF_LANGUE='''+gci_context.Langue+'''';
    Query.Filtered:=true;
  finally
    Query.EnableControls;
  end;
  doRefreshControls;
end;

procedure TFEditRefDivers.SuperFormRefreshControls(Sender:TObject);
begin
  btnAdd.enabled:=Query.Active;
  btnDel.enabled:=Query.Active and not Query.IsEmpty;
end;

procedure TFEditRefDivers.btnAddClick(Sender:TObject);
begin
  Query.Insert;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefDivers.QueryAfterInsert(DataSet:TDataSet);
begin
  doRefreshControls;
end;

procedure TFEditRefDivers.btnDelClick(Sender:TObject);
begin
  Query.Delete;
end;

procedure TFEditRefDivers.QueryBeforeDelete(DataSet:TDataSet);
begin
  if MyMessageDlg(rs_Do_you_delete_this_label
    ,mtConfirmation, [mbYes,mbNo],Self)<>mrYes then
    Abort;
end;

procedure TFEditRefDivers.QueryAfterDelete(DataSet:TDataSet);
begin
  doRefreshControls;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefDivers.QueryBeforePost(DataSet:TDataSet);
begin
  if Trim(DataSet.FieldByName('REF_LIBELLE').AsString)='' then
  begin
    MyMessageDlg(rs_Error_label_not_to_be_empty_or_spaces_filled
      ,mtError, [mbOk],Self);
    SendFocus(dxDBGrid1);
    Abort;
  end
  else
  begin
    if DataSet.FieldByName('REF_LANGUE').AsString='' then
      DataSet.FieldByName('REF_LANGUE').AsString:=gci_context.Langue;
  end;
end;

procedure TFEditRefDivers.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  if Query.Active and(Query.State in [dsEdit,dsInsert]) then
    Query.Post;
  dm.IBTrans_Secondaire.CommitRetaining;
  Query.Close;
end;

procedure TFEditRefDivers.SuperFormKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        dm.IBTrans_Secondaire.RollbackRetaining;
        OpenQuery;
      end;
  end;
end;

procedure TFEditRefDivers.btnExportClick(Sender:TObject);
var
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
  try
    aFExportTable2TextFile.TableName:=NomTable;
    aFExportTable2TextFile.PropositionFileNameExport:=NomTable+'.txt';
    aFExportTable2TextFile.ShowModal;
  finally
    aFExportTable2TextFile.Free;
  end;
end;

procedure TFEditRefDivers.btnImportClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    aFImportTextFile2Table.TableName:=NomTable;
    aFImportTextFile2Table.ParamsTable.Add('REF_LANGUE');
    aFImportTextFile2Table.ParamsTable.Add('REF_LIBELLE');
    aFImportTextFile2Table.chbVider.Checked:=true;
    if aFImportTextFile2Table.ShowModal=mrOk then
      OpenQuery;
  finally
    aFImportTextFile2Table.free;
  end;
end;

end.

