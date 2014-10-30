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
{ André Langlet 2011: il n'y a que le nom de l'unité qui n'a pas changé }
{-----------------------------------------------------------------------}

unit u_form_TAG_Gedcom;

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
  U_FormAdapt,DB,Forms,IBQuery,StdCtrls,U_ExtDBGrid,Controls,Classes,ExtCtrls,IBUpdateSQL,
  u_buttons_appli;

type
  TFTAGGedcom=class(TF_FormAdapt)
    Query:TIBQuery;
    DataSource:TDataSource;
    pBorder:TPanel;
    Panel7:TPanel;
    Panel4:TPanel;
    lbTitle:TLabel;
    Panel5:TPanel;
    Panel6:TPanel;
    Panel1:TPanel;
    dxDBGrid1:TExtDBGrid;
    IBUpdateSQL1:TIBUpdateSQL;
    btnFermer:TFWClose;
    btnImport:TFWImport;
    btnExport:TFWExport;
    QueryREF_EVE_LIB_COURT: TStringField;
    QueryREF_EVE_LIB_LONG: TStringField;
    QueryREF_EVE_VISIBLE: TLongintField;
    QueryREF_EVE_A_TRAITER: TLongintField;
    QueryREF_EVE_LANGUE: TStringField;
    QueryREF_EVE_OBLIGATOIRE: TLongintField;
    procedure SuperFormShowFirstTime(Sender:TObject);

    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure SuperFormCreate(Sender:TObject);
    procedure btnFermerClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure btnImportClick(Sender:TObject);
    procedure btnExportClick(Sender:TObject);
    procedure QueryBeforePost(DataSet: TDataSet);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
  private
    procedure OpenQuery;
  public

  end;

implementation

uses u_dm,
     fonctions_dialogs,
     u_form_export_table_2_textfile,
     u_form_Import_textfile_2_table,u_common_functions,
     u_common_ancestro,
     u_genealogy_context,
     u_common_ancestro_functions,
     SysUtils,Dialogs;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFTAGGedcom }

procedure TFTAGGedcom.OpenQuery;
begin
  Query.DisableControls;
  try
    Query.Close;
    Query.Params[0].AsString:=gci_context.Langue;
    Query.Open;
  finally
    Query.EnableControls;
  end;
end;

procedure TFTAGGedcom.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_Labels_of_default_events;
  OpenQuery;
end;

procedure TFTAGGedcom.SuperFormKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  if Key=VK_ESCAPE then
  begin
    dm.IBTrans_Secondaire.RollbackRetaining;
    OpenQuery;
  end;
end;

procedure TFTAGGedcom.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Panel7.Color:=gci_context.ColorLight;
end;

procedure TFTAGGedcom.btnFermerClick(Sender:TObject);
begin
  if Query.State in [dsEdit] then
    Query.Post;
end;

procedure TFTAGGedcom.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  Query.Close;
  dm.IBTrans_Secondaire.CommitRetaining;
end;

procedure TFTAGGedcom.btnImportClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    aFImportTextFile2Table.TableName:='REF_EVENEMENTS';
    aFImportTextFile2Table.NamePrimaryIndex:='REF_EVE_CODE';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex:='GEN_REF_EVENEMENTS';
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_CODE');
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_LIB_COURT');
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_LIB_LONG');
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_CAT');
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_VISIBLE');
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_A_TRAITER');
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_ECRAN');
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_OBLIGATOIRE');
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_LANGUE');
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_TYPE');
    aFImportTextFile2Table.ParamsTable.Add('REF_EVE_UNE_FOIS');
    aFImportTextFile2Table.chbVider.Checked:=true;
    if aFImportTextFile2Table.ShowModal=mrOk then
      OpenQuery;
  finally
    aFImportTextFile2Table.free;
  end;
end;

procedure TFTAGGedcom.btnExportClick(Sender:TObject);
var
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
  try
    aFExportTable2TextFile.TableName:='REF_EVENEMENTS';
    aFExportTable2TextFile.PropositionFileNameExport:='Tags_Gedcom.txt';
    aFExportTable2TextFile.ShowModal;
  finally
    aFExportTable2TextFile.Free;
  end;
end;

procedure TFTAGGedcom.QueryBeforePost(DataSet: TDataSet);
begin
  if Trim(DataSet.FieldByName('REF_EVE_LIB_LONG').AsString)='' then
  begin
    MyMessageDlg(rs_Error_label_not_to_be_empty_or_spaces_filled
      ,mtError, [mbOk],Self);
    SendFocus(dxDBGrid1);
    Abort;
  end;
end;

procedure TFTAGGedcom.DataSourceDataChange(Sender: TObject; Field: TField);
begin
  if QueryREF_EVE_OBLIGATOIRE.AsInteger=1 then
  begin
    if QueryREF_EVE_A_TRAITER.AsInteger<>1 then
    begin
      if not (Query.State in [dsEdit]) then
        Query.Edit;
      QueryREF_EVE_A_TRAITER.AsInteger:=1;
    end;
  end;
end;

end.

