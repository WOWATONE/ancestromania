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
{      2009 MD et AL refonte pour dates avJC et calcul âges                                                                 }
{-----------------------------------------------------------------------}
// TYPE_TOKEN 23 ORDRE (TOKEN DMY/MDY/YMD)
// TYPE_TOKEN 24 FORME (TOKEN LIT/NUM) pour LIT la forme est toujours DMY :FAUX AL

unit u_form_edit_ref_token_date;

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
  U_FormAdapt,u_comp_TYLanguage,Forms,U_ExtDBGrid,
  u_comp_TBlueFlatSpeedButton,StdCtrls,
  Controls,Classes,ExtCtrls,u_buttons_appli, MaskEdit,
  IBTable,IBSQL, DB;

type

  { TFEditRefTokenDate }

  TFEditRefTokenDate=class(TF_FormAdapt)
    DataSource:TDataSource;
    pBorder:TPanel;
    Panel7:TPanel;
    Panel4:TPanel;
    lbTitle:TLabel;
    Panel6:TPanel;
    btnAdd:TFWAdd;
    btnDel:TFWDelete;
    Panel3:TPanel;
    BlueFlaTCSpeedButton1:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton2:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton3:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton4:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton5:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton6:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton7:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton8:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton9:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton10:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton11:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton12:TBlueFlatSpeedButton;
    Label1:TLabel;
    BlueFlaTCSpeedButton13:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton14:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton15:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton16:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton17:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton18:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton19:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton20:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton21:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton22:TBlueFlatSpeedButton;
    Label2:TLabel;
    Panel5:TPanel;
    Panel9:TPanel;
    Panel10:TPanel;
    Panel1:TPanel;
    dxDBGrid1:TExtDBGrid;
    Panel8:TPanel;
    Language:TYLanguage;
    btnImport:TFWImport;
    btnExport:TFWExport;
    btnFermer:TFWClose;
    BlueFlaTCSpeedButton23:TBlueFlatSpeedButton;
    BlueFlaTCSpeedButton24:TBlueFlatSpeedButton;
    Query:TIBTable;
{$IFNDEF FPC}
    QueryID:TLongintField;
    QueryTYPE_TOKEN:TLongintField;
    QueryLANGUE:TStringField;
    QueryTOKEN:TStringField;
    QuerySOUS_TYPE:TStringField;
{$ENDIF}
    QueryClearErrors: TIBSQL;
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure btnAddClick(Sender:TObject);
    procedure btnDelClick(Sender:TObject);
    procedure btnExportClick(Sender:TObject);
    procedure btnImportClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure SuperFormCreate(Sender:TObject);
    procedure BlueFlaTCSpeedButton1Click(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure dxDBGrid1Column1PropertiesExit(Sender:TObject);
    procedure dxDBGrid1Column1PropertiesEditValueChanged(Sender:TObject);
    procedure QueryAfterInsert(DataSet:TDataSet);
    procedure QueryBeforeDelete(DataSet:TDataSet);
    procedure QueryAfterDelete(DataSet:TDataSet);
    procedure QueryBeforePost(DataSet:TDataSet);
  private
    fTypeToken:integer;
    Forme_Date,OrdreLIT,OrdreNUM:string;//MD AL
    ListeHints:array[1..24] of string;//AL
    bBloque:boolean;//AL
    procedure OpenQuery;
  public

  end;

implementation

uses  u_dm,
      u_common_functions,u_common_ancestro,
      LazUTF8,
      fonctions_dialogs,
      u_common_const,
      u_common_ancestro_functions,
      u_form_export_table_2_textfile,
      u_form_Import_textfile_2_table,
      u_gedcom_const,
      Dialogs,
      u_genealogy_context,
      SysUtils;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFEditRefTokenDate }

procedure TFEditRefTokenDate.SuperFormCreate(Sender:TObject);
var
  n:integer;
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  btnAdd.Color:=gci_context.ColorLight;
  btnDel.Color:=gci_context.ColorLight;
  btnAdd.ColorFrameFocus:=gci_context.ColorLight;
  btnDel.ColorFrameFocus:=gci_context.ColorLight;
  Panel3.Color:=gci_context.ColorDark;

  for n:=0 to ComponentCount-1 do
  begin
    if (Components[n]is TBlueFlatSpeedButton) then
    begin
      TBlueFlatSpeedButton(Components[n]).ColorFrameFocus:=gci_context.ColorLight;
//      TBlueFlatSpeedButton(Components[n]).ColorHighlight:=gci_context.ColorLight;
      if Components[n].Tag in [1..12] then //c'est un mois
      begin
        TBlueFlatSpeedButton(Components[n]).Hint:=
          rs_Hint_The_first_keyword_on_the_first_line_must_be_name_of_month;
      end;
      if Components[n].Tag in [13,14] then //c'est un mot pour identifier une période
      begin
        TBlueFlatSpeedButton(Components[n]).Hint:=
          rs_Hint_These_keywords_can_identify_the_event_period+
          rs_Hint_D1_M1_Y1_Indentify_same_cases_when_second_date_is_empty;
      end;
      if Components[n].Tag in [15..21] then //c'est un mot pour identifier une période
      begin
        TBlueFlatSpeedButton(Components[n]).Hint:=
          rs_Hint_These_keywords_can_identify_the_event_period+
          rs_Hint_D_M_Y_must_be_only_once_per_period;
      end;
      if Components[n].Tag=22 then //c'est le séparateur de dates
      begin
        TBlueFlatSpeedButton(Components[n]).Hint:=
          rs_Hint_The_first_keyword_on_the_first_line_must_be_used_separator;
      end;
      if Components[n].Tag=23 then //c'est l'ordre des éléments de la date
      begin
        TBlueFlatSpeedButton(Components[n]).Hint:=
          rs_Hint_This_keyword_can_identify_the_events_sorting_of_date;
      end;
      if Components[n].Tag=24 then //c'est la forme de la date
      begin
        TBlueFlatSpeedButton(Components[n]).Hint:=
          rs_Hint_This_keyword_can_identify_the_alpha_or_numeric_format_of_dates;
      end;
      ListeHints[Components[n].Tag]:=TBlueFlatSpeedButton(Components[n]).Hint;
    end;
  end;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  fTypeToken:=_TYPE_TOKEN_JANVIER;
  // Matthieu
//      dxDBGrid1Column2.Options.Editing:=False
  dxDBGrid1.Columns [ 1 ].ReadOnly:=True;
  bBloque:=false;
  Forme_Date:=_MotsClesDate.Token_mots[_TYPE_TOKEN_FORME][0];
  OrdreLIT:=_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][0];
  OrdreNUM:=_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][1];
end;

procedure TFEditRefTokenDate.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_Refering_the_keywords_to_set_the_dates;
  OpenQuery;
end;

procedure TFEditRefTokenDate.OpenQuery;
begin
  Query.DisableControls;
  try
    Query.Close;
    Query.Filtered:=false;
    Query.Open;
    Query.Filter:='LANGUE='''+gci_context.Langue+''' and TYPE_TOKEN='+IntToStr(fTypeToken);
    Query.Filtered:=true;
  finally
    Query.EnableControls;
  end;
  doRefreshControls;
end;

procedure TFEditRefTokenDate.SuperFormRefreshControls(Sender:TObject);
begin
  btnAdd.enabled:=Query.Active;
  btnDel.enabled:=Query.Active and not Query.IsEmpty;
end;

procedure TFEditRefTokenDate.btnAddClick(Sender:TObject);
begin
  Query.Insert;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefTokenDate.QueryAfterInsert(DataSet:TDataSet);
begin
  doRefreshControls;
end;

procedure TFEditRefTokenDate.btnDelClick(Sender:TObject);
begin
  Query.Delete;
end;

procedure TFEditRefTokenDate.QueryBeforeDelete(DataSet:TDataSet);
begin
  if MyMessageDlg(rs_Confirm_deleting_this_keyword
    ,mtConfirmation, [mbYes,mbNo],Self)<>mrYes then
    Abort;
end;

procedure TFEditRefTokenDate.QueryAfterDelete(DataSet:TDataSet);
begin
  doRefreshControls;
  SendFocus(dxDBGrid1);
end;

procedure TFEditRefTokenDate.QueryBeforePost(DataSet:TDataSet);
begin
  if Trim(DataSet.FieldByName('TOKEN').AsString)='' then
  begin
    MyMessageDlg(rs_Error_Label_not_to_be_empty_or_spaces_filled
      ,mtError, [mbOk],Self);
    SendFocus(dxDBGrid1);
    Abort;
  end
  else
  begin
    if DataSet.FieldByName('ID').AsInteger=0 then
      DataSet.FieldByName('ID').AsInteger:=dm.uf_GetClefUnique('TOKEN_DATE');
    if DataSet.FieldByName('LANGUE').AsString='' then
      DataSet.FieldByName('LANGUE').AsString:=gci_context.Langue;
    if DataSet.FieldByName('TYPE_TOKEN').AsInteger=0 then
      DataSet.FieldByName('TYPE_TOKEN').AsInteger:=fTypeToken;
  end;
end;

procedure TFEditRefTokenDate.btnExportClick(Sender:TObject);
var
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
  try
    aFExportTable2TextFile.TableName:='REF_TOKEN_DATE';
    aFExportTable2TextFile.PropositionFileNameExport:='MotsClefDate.txt';
    aFExportTable2TextFile.ShowModal;
  finally
    aFExportTable2TextFile.Free;
  end;
end;

procedure TFEditRefTokenDate.btnImportClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    aFImportTextFile2Table.TableName:='REF_TOKEN_DATE';
    aFImportTextFile2Table.NamePrimaryIndex:='ID';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex:='GEN_TOKEN_DATE';
    aFImportTextFile2Table.ParamsTable.Add('ID');
    aFImportTextFile2Table.ParamsTable.Add('TYPE_TOKEN');
    aFImportTextFile2Table.ParamsTable.Add('LANGUE');
    aFImportTextFile2Table.ParamsTable.Add('TOKEN');
    aFImportTextFile2Table.ParamsTable.Add('SOUS_TYPE');
    aFImportTextFile2Table.chbVider.Checked:=true;
    if aFImportTextFile2Table.ShowModal=mrOk then
    begin
        //Petit nettoyage...
      QueryClearErrors.Close;
      QueryClearErrors.ParamByName('LANGUE').AsString:=gci_context.Langue;
      QueryClearErrors.ParamByName('MIN_TYPE').AsInteger:=_TYPE_TOKEN_JANVIER;
      QueryClearErrors.ParamByName('MAX_TYPE').AsInteger:=_TYPE_TOKEN_FORME;//AL
      QueryClearErrors.ExecQuery;
      QueryClearErrors.Close;
      dm.IBTrans_Secondaire.CommitRetaining;
      OpenQuery;
    end;
  finally
    aFImportTextFile2Table.free;
  end;
end;

procedure TFEditRefTokenDate.SuperFormKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        dm.IBTrans_Secondaire.RollbackRetaining;
        OpenQuery;
      end;
    _KEY_HELP:p_ShowHelp(_ID_EDIT_TOKEN_DATE);
  end;
end;

procedure TFEditRefTokenDate.BlueFlaTCSpeedButton1Click(Sender:TObject);
begin
  fTypeToken:=TControl(Sender).Tag;
  if fTypeToken in [13..21] then
  // Matthieu
//    dxDBGrid1Column2.Options.Editing:=true
    dxDBGrid1.Columns [ 1 ].ReadOnly:=False
  else
//    dxDBGrid1Column2.Options.Editing:=false;
    dxDBGrid1.Columns [ 1 ].ReadOnly:=True;

  OpenQuery;
end;

procedure TFEditRefTokenDate.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
var
  bchange:boolean;
begin
  if Query.Active and(Query.State in [dsEdit,dsInsert]) then
    Query.Post;
  dm.IBTrans_Secondaire.CommitRetaining;
  Query.Close;
  _MotsClesDate.LoadMotClefDate(dm.IBQSources_Record,gci_context.Langue);
  bchange:=_MotsClesDate.Token_mots[_TYPE_TOKEN_FORME][0]<>Forme_Date;
  if not bchange then
  begin
    bchange:=_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][0]<>OrdreLIT;
    if not bchange then
      bchange:=_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][1]<>OrdreNUM;
    sOrdreLIT:='';
    sOrdreNUM:='';
  end
  else
  begin
    sOrdreLIT:=OrdreLIT;
    sOrdreNUM:=OrdreNUM;
    dm.doMajOrdreDateWriten;
  end;
end;

procedure TFEditRefTokenDate.dxDBGrid1Column1PropertiesExit(
  Sender:TObject);
var
  s:string;
  Error : Boolean;
begin
  with dxDBGrid1.DataSource.DataSet do
  if (fTypeToken in [23,24])
  and ( State in [dsEdit,dsInsert]) then
  begin
    Error:=false;
    s:=UTF8UpperCase(FieldByName('SOUS_TYPE').AsString);
    if fTypeToken=24 then
    begin
      if (s<>'LIT')and(s<>'NUM') then
        Error:=true;
    end
    else
    begin
      if (s<>'DMY')and(s<>'MDY')and(s<>'YMD') then
        Error:=true;
    end;
    if Error then
    begin
      MyMessageDlg(ListeHints[fTypeToken],mtWarning,[mbOK],Self);
      Abort;
    end
     else
      FieldByName('SOUS_TYPE').AsString := s;
  end;
end;

procedure TFEditRefTokenDate.dxDBGrid1Column1PropertiesEditValueChanged(
  Sender:TObject);
begin
  if (fTypeToken in [23,24])and(not bBloque) then
  begin
    bBloque:=true;
    TMaskEdit(sender).Text:=UTF8UpperCase(TMaskEdit(sender).Text);
    bBloque:=false;
  end;
end;

end.

