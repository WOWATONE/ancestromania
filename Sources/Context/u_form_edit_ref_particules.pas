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

unit u_form_edit_ref_particules;

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
  U_FormAdapt, u_comp_TYLanguage, Forms,
  DB, U_ExtDBGrid,
  StdCtrls, Controls, Classes, ExtCtrls,
   u_buttons_appli,
     IBTable;

type
  TFEditRefParticules = class(TF_FormAdapt)
    DataSource: TDataSource;
    pBorder: TPanel;
    Panel7: TPanel;
    Panel4: TPanel;
    lbTitle: TLabel;
    Panel8: TPanel;
    Panel6: TPanel;
    Panel1: TPanel;
    dxDBGrid1: TExtDBGrid;
    btnAdd: TFWAdd;
    btnDel: TFWDelete;
    Language: TYLanguage;
    btnImport: TFWImport;
    btnExport: TFWExport;
    btnFermer: TFWClose;
    Query: TIBTable;
{$IFNDEF FPC}
    QueryPART_CLEF: TLongintField;
    QueryPART_LIBELLE: TStringField;
{$ENDIF}
    procedure SuperFormShowFirstTime(Sender: TObject);
    procedure SuperFormRefreshControls(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure SuperFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SuperFormCreate(Sender: TObject);
    procedure SuperFormClose(Sender: TObject; var Action: TCloseAction);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure QueryAfterDelete(DataSet: TDataSet);
    procedure QueryBeforePost(DataSet: TDataSet);
    procedure QueryBeforeDelete(DataSet: TDataSet);
  private
    procedure OpenQuery;
  public

  end;

implementation

uses u_dm,
    u_common_functions,
    u_common_ancestro,
    fonctions_dialogs,
    u_common_const,
    u_common_ancestro_functions,
    u_form_export_table_2_textfile,
    u_form_Import_textfile_2_table,
    u_genealogy_context,
    Dialogs,
    SysUtils;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFEditRefParticules }

procedure TFEditRefParticules.SuperFormCreate(Sender: TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Panel7.Color:=gci_context.ColorLight;
  btnAdd.Color:=gci_context.ColorLight;
  btnDel.Color:=gci_context.ColorLight;
  btnAdd.ColorFrameFocus:=gci_context.ColorLight;
  btnDel.ColorFrameFocus:=gci_context.ColorLight;

  Language.RessourcesFileName := _REL_PATH_TRADUCTIONS + _FileNameTraduction;
  Language.Translate;
end;

procedure TFEditRefParticules.SuperFormShowFirstTime(Sender: TObject);
begin
  OpenQuery;
  Caption:=rs_Caption_Refering_particles;
end;

procedure TFEditRefParticules.OpenQuery;
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

procedure TFEditRefParticules.SuperFormRefreshControls(Sender: TObject);
begin
  btnAdd.enabled := Query.Active;
  btnDel.enabled := Query.Active and not Query.IsEmpty;
end;

procedure TFEditRefParticules.btnAddClick(Sender: TObject);
begin
  Query.Insert;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefParticules.QueryAfterInsert(DataSet: TDataSet);
begin
  doRefreshControls;
end;

procedure TFEditRefParticules.btnDelClick(Sender: TObject);
begin
  Query.Delete;
end;

procedure TFEditRefParticules.QueryBeforeDelete(DataSet: TDataSet);
begin
  if MyMessageDlg(rs_Confirm_deleting_this_particle
    ,mtConfirmation,[mbYes,mbNo],Self)<>mrYes then
    Abort;
end;

procedure TFEditRefParticules.QueryAfterDelete(DataSet: TDataSet);
begin
  doRefreshControls;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefParticules.QueryBeforePost(DataSet: TDataSet);
begin
  with DataSet do
  if Trim(FieldByName('PART_LIBELLE').AsString)='' then
  begin
    MyMessageDlg(rs_Error_Particle_not_to_be_empty_or_spaces_filled
    ,mtError,[mbOk],Self);
    SendFocus(dxDBGrid1);
    Abort;
  end
  else
  begin
    if FieldByName('PART_CLEF').AsInteger=0 then
      FieldByName('PART_CLEF').AsInteger:=dm.uf_GetClefUnique('REF_PARTICULES');
  end;
end;

procedure TFEditRefParticules.SuperFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Query.Active and (Query.State in [dsEdit, dsInsert]) then
    Query.Post;
  dm.IBTrans_Secondaire.CommitRetaining;
  Query.Close;
end;

procedure TFEditRefParticules.SuperFormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
    begin
      dm.IBTrans_Secondaire.RollbackRetaining;
      OpenQuery;
    end;
    _KEY_HELP: p_ShowHelp(_ID_EDIT_TABLE_REF_PARTICULES);
  end;
end;

procedure TFEditRefParticules.btnExportClick(Sender: TObject);
var
  aFExportTable2TextFile: TFExportTable2TextFile;
begin
  aFExportTable2TextFile := TFExportTable2TextFile.create(self);
  try
    aFExportTable2TextFile.TableName := 'REF_PARTICULES';
    aFExportTable2TextFile.PropositionFileNameExport := 'Particules.txt';
    aFExportTable2TextFile.ShowModal;
  finally
    aFExportTable2TextFile.Free;
  end;
end;

procedure TFEditRefParticules.btnImportClick(Sender: TObject);
var
  aFImportTextFile2Table: TFImportTextFile2Table;
begin
  aFImportTextFile2Table := TFImportTextFile2Table.create(self);
  try
    aFImportTextFile2Table.TableName := 'REF_PARTICULES';
    aFImportTextFile2Table.NamePrimaryIndex := 'PART_CLEF';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex := 'GEN_REF_PARTICULES';
    aFImportTextFile2Table.ParamsTable.Add('PART_CLEF');
    aFImportTextFile2Table.ParamsTable.Add('PART_LIBELLE');
    aFImportTextFile2Table.chbVider.Checked:=true;
    if aFImportTextFile2Table.ShowModal = mrOk then
      OpenQuery;
  finally
    aFImportTextFile2Table.free;
  end;
end;

end.
