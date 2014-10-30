{-----------------------------------------------------------------------}
{ Ancestromania                                                         }
{ Création u_form_edit_ref_temoins André Langlet 2009                 }
{-----------------------------------------------------------------------}

unit u_form_edit_ref_temoins;

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

  { TFEditRefTemoins }

  TFEditRefTemoins=class(TF_FormAdapt)
    btnAdd: TFWAdd;
    btnDel: TFWDelete;
    DataSource:TDataSource;
    lbTitle1: TLabel;
    lbTitle2: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    pBorder:TPanel;
    Panel7:TPanel;
    Panel4:TPanel;
    lbTitle:TLabel;
    Panel8:TPanel;
    Panel6:TPanel;
    Panel1:TPanel;
    dxDBGrid1:TExtDBGrid;
    btnImport:TFWImport;
    btnExport:TFWExport;
    btnFermer:TFWClose;
    Language:TYLanguage;
    Query:TIBTable;
{$IFNDEF FPC}
    QueryREF_RELA_CLEF:TLongintField;
    QueryREF_RELA_LIBELLE:TStringField;
    QueryLANGUE:TStringField;
    QueryREF_RELA_TAG:TStringField;
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

  end;

implementation

uses  u_dm,
      u_common_functions,
      fonctions_dialogs,
      u_common_ancestro,
      u_common_const,
      u_common_ancestro_functions,
      u_form_export_table_2_textfile,
      u_form_Import_textfile_2_table,
      u_genealogy_context,
      Dialogs,
      SysUtils;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFEditRefTemoins }

procedure TFEditRefTemoins.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime   :=SuperFormShowFirstTime;
  OnRefreshControls :=SuperFormRefreshControls;
  Panel7.Color:=gci_context.ColorLight;
  btnAdd.Color:=gci_context.ColorLight;
  btnDel.Color:=gci_context.ColorLight;
  btnAdd.ColorFrameFocus:=gci_context.ColorLight;
  btnDel.ColorFrameFocus:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
end;

procedure TFEditRefTemoins.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_Roles_and_Relationships_of_the_witnesses;
  OpenQuery;
end;

procedure TFEditRefTemoins.OpenQuery;
begin
  Query.DisableControls;
  try
    Query.Close;
    Query.Filtered:=false;
    Query.Open;
    Query.Filter:='LANGUE='''+gci_context.Langue+'''';
    Query.Filtered:=true;
  finally
    Query.EnableControls;
  end;
  doRefreshControls;
end;

procedure TFEditRefTemoins.SuperFormRefreshControls(Sender:TObject);
begin
  btnAdd.enabled:=Query.Active;
  btnDel.enabled:=Query.Active and not Query.IsEmpty;
end;

procedure TFEditRefTemoins.btnAddClick(Sender:TObject);
begin
  Query.Insert;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefTemoins.QueryAfterInsert(DataSet:TDataSet);
begin
  doRefreshControls;
end;

procedure TFEditRefTemoins.btnDelClick(Sender:TObject);
begin
  Query.Delete;
end;

procedure TFEditRefTemoins.QueryBeforeDelete(DataSet:TDataSet);
begin
  if MyMessageDlg(rs_Do_you_delete_this_label
    ,mtConfirmation, [mbYes,mbNo],Self)<>mrYes then
    Abort;
end;

procedure TFEditRefTemoins.QueryAfterDelete(DataSet:TDataSet);
begin
  doRefreshControls;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefTemoins.QueryBeforePost(DataSet:TDataSet);
begin
  if Trim(DataSet.FieldByName('REF_RELA_LIBELLE').AsString)='' then
  begin
    MyMessageDlg(rs_Error_label_not_to_be_empty_or_spaces_filled
      ,mtError, [mbOk],Self);
    SendFocus(dxDBGrid1);
    Abort;
  end
  else
  begin
    if DataSet.FieldByName('REF_RELA_CLEF').AsInteger=0 then
      DataSet.FieldByName('REF_RELA_CLEF').AsInteger:=dm.uf_GetClefUnique('REF_RELA_TEMOINS');
    if DataSet.FieldByName('LANGUE').AsString='' then
      DataSet.FieldByName('LANGUE').AsString:=gci_context.Langue;
  end;
end;

procedure TFEditRefTemoins.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  if Query.Active and(Query.State in [dsEdit,dsInsert]) then
    Query.Post;
  dm.IBTrans_Secondaire.CommitRetaining;
  Query.Close;
end;

procedure TFEditRefTemoins.SuperFormKeyDown(Sender:TObject;var Key:Word;
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

procedure TFEditRefTemoins.btnExportClick(Sender:TObject);
var
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
  try
    aFExportTable2TextFile.TableName:='REF_RELA_TEMOINS';
    aFExportTable2TextFile.PropositionFileNameExport:='REF_RELA_TEMOINS.txt';
    aFExportTable2TextFile.ShowModal;
  finally
    aFExportTable2TextFile.Free;
  end;
end;

procedure TFEditRefTemoins.btnImportClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    aFImportTextFile2Table.TableName:='REF_RELA_TEMOINS';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex:='GEN_REF_RELA_CLEF';
    aFImportTextFile2Table.NamePrimaryIndex:='REF_RELA_CLEF';
    
    aFImportTextFile2Table.ParamsTable.Add('REF_RELA_CLEF');
    aFImportTextFile2Table.ParamsTable.Add('REF_RELA_LIBELLE');
    aFImportTextFile2Table.ParamsTable.Add('LANGUE');
    aFImportTextFile2Table.ParamsTable.Add('REF_RELA_TAG');
    aFImportTextFile2Table.chbVider.Checked:=true;
    if aFImportTextFile2Table.ShowModal=mrOk then
      OpenQuery;
  finally
    aFImportTextFile2Table.free;
  end;
end;

end.

