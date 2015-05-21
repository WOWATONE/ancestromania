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

unit u_form_export_table_2_textfile;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  U_FormAdapt,u_comp_TYLanguage,forms,
  Dialogs,Controls,ComCtrls,
  ExtJvXPCheckCtrls,SysUtils,
  StdCtrls,Classes,ExtCtrls,u_buttons_appli,
  lazutf8classes, MaskEdit, u_comp_TBlueFlatSpeedButton,
  u_framework_components,IBSQL;

type

  { TFExportTable2TextFile }

  TFExportTable2TextFile=class(TF_FormAdapt)
    BlueFlaTCSpeedButton1: TBlueFlatSpeedButton;
    cbIncludeEntete: TJvXPCheckbox;
    DstList: TListView;
    edAutreSep: TMaskEdit;
    edFileName: TMaskEdit;
    edStringDelimitor: TFWComboBox;
    FlatPanel1: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel9: TPanel;
    panEtape2: TPanel;
    panEtape3: TPanel;
    pBorder:TPanel;
    Panel4:TPanel;
    Panel8:TPanel;
    Panel5:TPanel;
    Label1:TLabel;
    panEtape1:TPanel;
    Label3:TLabel;
    Label6:TLabel;
    rbAutre: TRadioButton;
    rbPV: TRadioButton;
    rbTab: TRadioButton;
    rbV: TRadioButton;
    SaveDialog:TSaveDialog;
    Language:TYLanguage;
    btnOk:TFWOK;
    btnCancel:TFWCancel;
    Query:TIBSQL;
    procedure SuperFormCreate(Sender:TObject);
    procedure BlueFlaTCSpeedButton1Click(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure btnOkClick(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure SuperFormDestroy(Sender:TObject);
    procedure SpeedButton1Click(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);

  private
    fTableName:string;
    fFieldNames:TStringlistUTF8;
    fPropositionFileNameExport:string;
    fCondSelect:string;

  public
    property TableName:string read fTableName write fTableName;
    property PropositionFileNameExport:string read fPropositionFileNameExport write fPropositionFileNameExport;
    property CondSelect:string read fCondSelect write fCondSelect;
  end;

implementation

uses
  u_objet_TCut,u_common_functions,u_common_ancestro,
  u_common_const,IBHeader,DB,
  fonctions_dialogs,
  u_genealogy_context, FileUtil,fonctions_file,
  u_common_ancestro_functions,
  fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFExportTable2TextFile.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Panel4.Color:=gci_context.ColorLight;
  panEtape1.Color:=gci_context.ColorDark;
  panEtape2.Color:=gci_context.ColorDark;
  panEtape3.Color:=gci_context.ColorDark;
  BlueFlaTCSpeedButton1.Color:=gci_context.ColorDark;
//  BlueFlaTCSpeedButton1.ColorDown:=gci_context.ColorMedium;
  BlueFlaTCSpeedButton1.ColorFrameFocus:=gci_context.ColorMedium;
  Panel1.Color:=gci_context.ColorDark;

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  fCondSelect:='';
  fTableName:='';
  fFieldNames:=TStringlistUTF8.create;
  fPropositionFileNameExport:='';
end;

procedure TFExportTable2TextFile.BlueFlaTCSpeedButton1Click(Sender:TObject);
begin
  if (fPropositionFileNameExport>'')and(edFileName.Text='') then
  begin
    SaveDialog.InitialDir:=gci_context.PathDocs;
    SaveDialog.FileName:=fPropositionFileNameExport;
  end;
  if SaveDialog.Execute then
  begin
    edFileName.Text:=SaveDialog.FileName;
    DoRefreshControls;
  end;
end;

procedure TFExportTable2TextFile.SuperFormShowFirstTime(Sender:TObject);
var
  n:integer;
  item:TListItem;
begin
  Caption:=fs_RemplaceMsg(rs_Caption_Export_in_table_from_textfile,[fTableName]);
  fFieldNames.Clear;

  //Récupération de la liste des champs
  Query.Close;
  try
    Query.Sql.Text:='select * from '+fTableName+' where 0=1';
    Query.ExecQuery;

    for n:=0 to Query.FieldCount-1 do
    begin
      fFieldNames.Add(Query.Fields[n].Name);
    end;
  finally
    Query.Close;
  end;

  DstList.Items.BeginUpdate;
  try
    DstList.Items.Clear;
    for n:=0 to fFieldNames.Count-1 do
    begin
      item:=DstList.Items.Add;
      item.Caption:=fFieldNames[n];
      item.Checked:=true;
    end;
  finally
    DstList.Items.EndUpdate;
  end;

  DoRefreshControls;
end;

procedure TFExportTable2TextFile.btnOkClick(Sender:TObject);
var
  ok:boolean;
  k,n,w:integer;
  fCut:TCut;
  F:THandle;
  aField:TIBXSQLVAR;
  Save_Cursor:TCursor;
begin
  ok:=false;
  for n:=0 to DstList.items.Count-1 do
  begin
    if DstList.Items[n].Checked then
    begin
      ok:=true;
      break;
    end;
  end;

  if ok then
  begin
    Save_Cursor:=Screen.Cursor;
    Screen.Cursor:=crHourglass;
    fCut:=TCut.create;
    try
      try
        //Séparateur de colonnes
        if rbPV.checked then
          fCut.ParamSeparator:=';'
        else if rbV.checked then
          fCut.ParamSeparator:=','
        else if rbTab.checked then
          fCut.ParamSeparator:=#9
        else if rbAutre.checked then
          fCut.ParamSeparator:=edAutreSep.text;

        //Délimiteur de chaînes de caractères
        fCut.StringDelimitor:=edStringDelimitor.Text;

        fCut.Params.Clear;
        for k:=0 to DstList.Items.Count-1 do
        begin
          if DstList.Items[k].checked then
          begin
            fCut.Params.CreateParam(ftString,'Param'+inttostr(k),ptInputOutput);
          end;
        end;

        Query.Close;
        Query.Sql.Text:='select * from '+fTableName;
        if fCondSelect>'' then
          Query.Sql.Add('where '+fCondSelect);
        Query.ExecQuery;

        if not Query.Eof then
        begin
          btnOk.Enabled:=False;
          btnCancel.Enabled:=False;
          Application.ProcessMessages;

          F:=FileCreateUTF8(edFileName.Text);
          try
            if cbIncludeEntete.checked then
            begin
              w:=0;
              for k:=0 to DstList.Items.Count-1 do
              begin
                if DstList.Items[k].checked then
                begin
                  fCut.Params[w].AsString:=DstList.Items[k].Caption;
                  w:=w+1;
                end;
              end;

              fCut.ParamsToStr;
              FileWriteLn(F,fCut.Line);
            end;

            while not Query.Eof do
            begin
              w:=0;
              for k:=0 to DstList.Items.Count-1 do
              begin
                if DstList.Items[k].checked then
                begin
                  aField:=Query.FieldByName(DstList.Items[k].Caption);
                  if aField<>nil then
                  begin
                    if DecimalSeparator='.' then
                      fCut.Params[w].Value:=aField.Value
                    else
                    begin
                      // Matthieu ?
                      case aField.SQLType of
                        SQL_DOUBLE,SQL_FLOAT,SQL_D_FLOAT:
                          fCut.Params[w].AsString:=StringReplace(aField.AsString,DecimalSeparator,'.', []);
                        SQL_SHORT,SQL_LONG,SQL_INT64:
                          if aField.Data.SqlScale<0 then
                            fCut.Params[w].AsString:=StringReplace(aField.AsString,DecimalSeparator,'.', [])
                          else
                            fCut.Params[w].Value:=aField.Value;
                        else
                          fCut.Params[w].Value:=aField.Value;
                      end;
                    end;
                  end
                  else
                  begin
                    fCut.Params[w].Clear;
                  end;
                  w:=w+1;
                end;
              end;
              fCut.ParamsToStr;
              FileWriteLn(F,fCut.Line);
              Query.Next;
            end;
          finally
            FileClose(F);
          end;

          MyMessageDlg(rs_Info_Export_is_a_success,mtInformation, [mbOK],Self);
          btnOk.Enabled:=True;
          btnCancel.Enabled:=True;
          ModalResult:=mrOk;
        end
        else
        begin
          MyMessageDlg(rs_Info_No_record_to_export,mtInformation, [mbOK],Self);
        end;
      except
      end;
    finally
      Screen.Cursor:=Save_Cursor;
      fCut.Free;
    end;
  end
  else
    myMessageDlg(rs_Info_Nothing_to_export,mtInformation, [mbOK],Self);
end;

procedure TFExportTable2TextFile.SuperFormRefreshControls(Sender:TObject);
var
  ok:boolean;
begin
  ok:=(trim(edFileName.Text)>'');
  btnOk.enabled:=ok;
end;

procedure TFExportTable2TextFile.SuperFormDestroy(Sender:TObject);
begin
  fFieldNames.Free;
end;

procedure TFExportTable2TextFile.SpeedButton1Click(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFExportTable2TextFile.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  if Key=VK_ESCAPE then ModalResult:=mrCancel;
end;

procedure TFExportTable2TextFile.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  Action:=caFree;
end;

end.

