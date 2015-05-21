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
{ refonte par AL 2011                                                   }
{-----------------------------------------------------------------------}

unit u_form_Import_textfile_2_table;

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
  U_FormAdapt,u_comp_TYLanguage,
  Dialogs, MaskEdit,
  Controls,ComCtrls,
  lazutf8classes,
  ExtJvXPCheckCtrls,u_comp_TBlueFlatSpeedButton,
  StdCtrls,Classes,ExtCtrls,u_objet_TIntegerList,
  SysUtils,Forms,u_buttons_appli,
  u_framework_components, IBSQL;

type

  { TFImportTextFile2Table }

  TFImportTextFile2Table=class(TF_FormAdapt)
    BlueFlaTCSpeedButton1: TBlueFlatSpeedButton;
    btnEqual: TBlueFlatSpeedButton;
    btnNot: TBlueFlatSpeedButton;
    cbIncludeEntete: TJvXPCheckbox;
    DstList: TListView;
    edAutreSep: TMaskEdit;
    edFileName: TMaskEdit;
    edStringDelimitor: TFWComboBox;
    FlatGroupBox1: TGroupBox;
    FlatGroupBox2: TGroupBox;
    Label10: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    pBorder:TPanel;
    Panel5:TPanel;
    Panel8:TPanel;
    Panel9:TPanel;
    Label1:TLabel;
    panEtape1:TPanel;
    Label3:TLabel;
    Label6:TLabel;
    panEtape2:TPanel;
    Label5:TLabel;
    Label7:TLabel;
    rbAutre: TRadioButton;
    rbPV: TRadioButton;
    rbTab: TRadioButton;
    rbV: TRadioButton;
    panEtape3:TPanel;
    Label8:TLabel;
    Label9:TLabel;
    OpenDialog:TOpenDialog;
    Language:TYLanguage;
    chbVider:TCheckBox;
    btnImport:TFWImport;
    btnCancel:TFWCancel;
    QueryAdd: TIBSQL;
    SrcList: TListView;
    procedure BlueFlaTCSpeedButton1Click(Sender:TObject);
    procedure FormatFichierChange(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormDestroy(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure btnEqualClick(Sender:TObject);
    procedure btnNotClick(Sender:TObject);
    procedure DstListClick(Sender:TObject);
    procedure SrcListDblClick(Sender:TObject);
    procedure btnImportClick(Sender:TObject);
    procedure SpeedButton1Click(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);

  private

    fNumColumnsSource:TIntegerList;
    fTableName:string;
    fParamsTable:TStringlistUTF8;
    fNamePrimaryIndex:string;
    fNameGeneratorPrimaryIndex:string;

    procedure DetectColonnes;
    function LoadFirstLine(var line:string):boolean;
    procedure DoMakeEquivalence;
    procedure UploadInDatabase;

  public
    property TableName:string read fTableName write fTableName;
    property ParamsTable:TStringlistUTF8 read fParamsTable write fParamsTable;
    property NamePrimaryIndex:string read fNamePrimaryIndex write fNamePrimaryIndex;
    property NameGeneratorPrimaryIndex:string read fNameGeneratorPrimaryIndex write fNameGeneratorPrimaryIndex;
  end;

implementation

uses
  u_objet_TCut,u_common_const,
  FileUtil,fonctions_file,
  u_common_functions,
  u_common_ancestro,
  fonctions_string,
  fonctions_dialogs,
  u_common_ancestro_functions,
  u_genealogy_context;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFImportTextFile2Table.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Panel5.Color:=gci_context.ColorLight;
  panEtape1.Color:=gci_context.ColorDark;
  panEtape2.Color:=gci_context.ColorDark;
  panEtape3.Color:=gci_context.ColorDark;
  BlueFlaTCSpeedButton1.Color:=gci_context.ColorDark;
//  BlueFlaTCSpeedButton1.ColorDown:=gci_context.ColorMedium;
  BlueFlaTCSpeedButton1.ColorFrameFocus:=gci_context.ColorMedium;
  Panel1.Color:=gci_context.ColorDark;
  Panel2.Color:=gci_context.ColorDark;
  btnEqual.Color:=gci_context.ColorDark;
  btnNot.Color:=gci_context.ColorDark;

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  fParamsTable:=TStringlistUTF8.create;
  fNumColumnsSource:=TIntegerList.create;
  fTableName:='';
  fNamePrimaryIndex:='';
  fNameGeneratorPrimaryIndex:='';
  OpenDialog.InitialDir:=gci_context.PathDocs;
end;

procedure TFImportTextFile2Table.BlueFlaTCSpeedButton1Click(Sender:TObject);
begin
  if OpenDialog.Execute then
  begin
    edFileName.Text:=OpenDialog.FileName;
    DetectColonnes;
  end;
end;

function TFImportTextFile2Table.LoadFirstLine(var line:string):boolean;
var
  F:THandle;
begin
  result:=false;
  try
    try
      F:=FileOpenUTF8(edFileName.Text,fmOpenRead);
      FileReadln(F,Line);
    finally
      FileClose(F);
    end;
    result:=true;
  except
  end;
end;

procedure TFImportTextFile2Table.DetectColonnes;
var
  s,m:string;
  fCut:TCut;
  n:integer;
  aItem:TListItem;
begin
  try
    SrcList.Items.Clear;
    if LoadFirstLine(s) then
    begin
      fCut:=TCut.create;
      try
        //Chaîne à découper
        fCut.Line:=s;

        //Séparateur de colonnes
        if rbPV.checked then
          fCut.ParamSeparator:=';'
        else if rbV.checked then
          fCut.ParamSeparator:=','
        else if rbTab.checked then
          fCut.ParamSeparator:=#9
        else if rbAutre.checked then
          fCut.ParamSeparator:=edAutreSep.text;

        //Délimiteur de chaîne de caractères
        fCut.StringDelimitor:=edStringDelimitor.Text;
        fCut.SetParamCountAsInLine;
        fCut.StrToParams;

        for n:=0 to fCut.Params.Count-1 do
        begin
          m:=fCut.Params[n].AsString;
          if not cbIncludeEntete.checked then
            m:=fs_RemplaceMsg(rs_Column_arg,[inttostr(n+1),m]);
          aItem:=SrcList.Items.Add;
          aItem.Caption:=m;
        end;
      finally
        fCut.Free;
      end;
    end;
  except
  end;
  DoRefreshControls;
end;

procedure TFImportTextFile2Table.FormatFichierChange(Sender:TObject);
begin
  DetectColonnes;
end;

procedure TFImportTextFile2Table.SuperFormRefreshControls(Sender:TObject);
var
  n:integer;
  ok:boolean;
begin
  Ok:=(trim(edFileName.Text)>'');
  panEtape1.Color:=gci_context.ColorMedium;

  if Ok then
    panEtape2.Color:=gci_context.ColorMedium
  else
    panEtape2.Color:=gci_context.ColorDark;

  Ok:=(trim(edFileName.Text)>'')and(SrcList.Items.Count>0);
  if Ok then
    panEtape3.Color:=gci_context.ColorMedium
  else
    panEtape3.Color:=gci_context.ColorDark;
  btnEqual.enabled:=(DstList.Selected<>nil)and(SrcList.Selected<>nil);
  btnNot.enabled:=(DstList.Selected<>nil);

  ok:=false;
  for n:=0 to fNumColumnsSource.Count-1 do
  begin
    if fNumColumnsSource[n]<>-1 then
    begin
      ok:=true;
      Break;
    end;
  end;
  btnImport.enabled:=ok;
end;

procedure TFImportTextFile2Table.SuperFormDestroy(Sender:TObject);
begin
  fParamsTable.Free;
  fNumColumnsSource.Free;
end;

procedure TFImportTextFile2Table.SuperFormShowFirstTime(Sender:TObject);
var
  n:integer;
  aItem:TListItem;
begin
  Caption:=fs_RemplaceMsg(rs_Caption_Import_in_table_from_textfile,[fTableName]);
  //Correspondance avec les numéros de colonne du fichier texte
  fNumColumnsSource.Clear;
  for n:=0 to fParamsTable.Count-1 do
  begin
    fNumColumnsSource.Add(-1);
    aItem:=DstList.Items.Add;
    aItem.Caption:=fParamsTable[n];
    aItem.SubItems.Add('');
  end;
  DoRefreshControls;
end;

procedure TFImportTextFile2Table.DoMakeEquivalence;
var
  k,p:integer;
  aItem,aItemSrc:TListItem;
begin
  aItem:=DstList.Selected;
  k:=aItem.Index;
  aItemSrc:=SrcList.Selected;
  p:=aItemSrc.Index;

  fNumColumnsSource[k]:=p;
  aItem.SubItems[0]:=aItemSrc.Caption;

  //On sélectionne les lignes suivantes, si possible
  if k<DstList.Items.Count-1 then
    DstList.Selected:=DstList.Items[k+1];
  if p<SrcList.Items.Count-1 then
    SrcList.Selected:=SrcList.Items[p+1];
end;

procedure TFImportTextFile2Table.btnEqualClick(Sender:TObject);
begin
  DoMakeEquivalence;
  DoRefreshControls;
end;

procedure TFImportTextFile2Table.btnNotClick(Sender:TObject);
var
  k:integer;
  aItem:TListItem;
begin
  aItem:=DstList.Selected;
  k:=aItem.Index;

  fNumColumnsSource[k]:=-1;
  aItem.SubItems[0]:='';
  DoRefreshControls;
end;

procedure TFImportTextFile2Table.DstListClick(Sender:TObject);
begin
  DoRefreshControls;
end;

procedure TFImportTextFile2Table.SrcListDblClick(Sender:TObject);
begin
  if (DstList.Selected<>nil)and(SrcList.Selected<>nil) then
  begin
    DoMakeEquivalence;
    DoRefreshControls;
  end;
end;

procedure TFImportTextFile2Table.UploadInDatabase;
var
  n,tot:integer;
  s:string;
  F:THandle;
  iCompteur:integer;
  fCut:TCut;
  TotRecordOk:integer;
  TotRecordError:integer;
  TotRecordInSourceFile:integer;

begin
  TotRecordOk:=0;
  TotRecordError:=0;
  TotRecordInSourceFile:=0;
  iCompteur:=0;
  QueryAdd.Close;

  if chbVider.Checked then
  begin
    QueryAdd.Sql.Text:='delete from '+fTableName;
    QueryAdd.ExecQuery;
    QueryAdd.Close;
    if fNameGeneratorPrimaryIndex>'' then
    begin
      QueryAdd.Sql.Text:='alter sequence '+fNameGeneratorPrimaryIndex+' restart with 0';
      QueryAdd.ExecQuery;
      QueryAdd.Close;
    end;
  end;

  if (fNamePrimaryIndex='')or chbVider.Checked then
    QueryAdd.Sql.Text:='insert into '+fTableName+'('
  else
    QueryAdd.Sql.Text:='update or insert into '+fTableName+'(';

  tot:=0;
  for n:=0 to fNumColumnsSource.count-1 do
  begin
    if fNumColumnsSource[n]<>-1 then
    begin
      if tot>0 then
        s:=','
      else
        s:='';
      s:=s+fParamsTable[n];
      QueryAdd.Sql.Add(s);
      inc(tot);
    end;
  end;
  QueryAdd.Sql.Add(')');
  if tot>0 then
  begin
    //Fin de la requête d'ajout
    QueryAdd.Sql.Add('values (');
    tot:=0;

    for n:=0 to fNumColumnsSource.count-1 do
    begin
      if fNumColumnsSource[n]<>-1 then
      begin
        if tot>0 then
          s:=','
        else
          s:='';
        s:=s+':'+fParamsTable[n];
        QueryAdd.Sql.Add(s);
        inc(tot);
      end;
    end;
    QueryAdd.Sql.Add(')');

    fCut:=TCut.create;
    try
      //Séparateur de colonne
      if rbPV.checked then
        fCut.ParamSeparator:=';'
      else if rbV.checked then
        fCut.ParamSeparator:=','
      else if rbTab.checked then
        fCut.ParamSeparator:=#9
      else if rbAutre.checked then
        fCut.ParamSeparator:=edAutreSep.text;

      //Délimiteur de chaîne de caractères
      fCut.StringDelimitor:=edStringDelimitor.Text;

      //Nombre de paramètres
      fCut.SetTotalStringParams(SrcList.Items.Count);

      if fCut.Params.Count>0 then
      begin
        F:=FileOpenUTF8(edFileName.Text,fmOpenRead);

        //On saute la ligne des entêtes si demandé
        if cbIncludeEntete.checked then
          FileReadLn(F,S);

        while FileReadLn(F,S) > 0 do
        begin
          fCut.Line:=S;
          if fCut.StrToParams then
          begin
            inc(TotRecordInSourceFile);

            try
              //On fixe les paramètres de la requête
              for n:=0 to fNumColumnsSource.count-1 do
              begin
                if fNumColumnsSource[n]<>-1 then
                begin
                  if fCut.Params[fNumColumnsSource[n]].Value>'' then
                    QueryAdd.ParamByName(fParamsTable[n]).Value:=fCut.Params[fNumColumnsSource[n]].Value
                  else
                    QueryAdd.ParamByName(fParamsTable[n]).Clear;
                end;
              end;

              QueryAdd.ExecQuery;

              inc(iCompteur);

              if iCompteur=5000 then
              begin
                QueryAdd.Transaction.CommitRetaining;
                iCompteur:=0;
              end;
              inc(TotRecordOk);
            except
              inc(TotRecordError);
            end;
          end;
        end;
        FileClose(F);
        QueryAdd.Close;
      end;
    finally
      fCut.Free;
    end;
    if (fNameGeneratorPrimaryIndex>'') and (fNamePrimaryIndex>'') then
    begin
      QueryAdd.Sql.Text:='select max('+fNamePrimaryIndex+') from '+fTableName;
      QueryAdd.ExecQuery;
      if not QueryAdd.Eof then
      begin
        n:=QueryAdd.Fields[0].AsInteger;
        QueryAdd.Close;
        QueryAdd.Sql.Text:='alter sequence '+fNameGeneratorPrimaryIndex+' restart with '+IntToStr(n);
        QueryAdd.ExecQuery;
      end;
      QueryAdd.Close;
    end;
  end;

  QueryAdd.Transaction.CommitRetaining;

  MyMessageDlg(fs_RemplaceMsg(rs_Resume_records_treated_records_back_records_with_error,
   [inttostr(TotRecordInSourceFile),inttostr(TotRecordOk),inttostr(TotRecordError)])
    ,mtInformation, [mbOK],Self);
end;

procedure TFImportTextFile2Table.btnImportClick(Sender:TObject);
var
  Save_Cursor:TCursor;
  i:integer;
begin
  if fNamePrimaryIndex>'' then
  begin
    for i:=0 to ParamsTable.Count-1 do
    begin
      if ParamsTable[i]=fNamePrimaryIndex then
      begin
        if fNumColumnsSource[i]=-1 then
        begin
          MyMessageDlg(fNamePrimaryIndex+fs_RemplaceMsg(rs_Error_key_of_table_must_be_set_to_import,[fTableName])
            ,mtError, [mbCancel],Self);
          exit;
        end;
        break;
      end;
    end;
  end;

  if MyMessageDlg(rs_Confirm_importing_textfile_into_data,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    Save_Cursor:=Screen.Cursor;
    Screen.Cursor:=crHourglass;
    btnImport.Enabled:=False;
    btnCancel.Enabled:=False;
    UploadInDatabase;

    btnImport.Enabled:=True;
    btnCancel.Enabled:=True;
    Screen.Cursor:=Save_Cursor;
    ModalResult:=mrOk;
  end;
end;

procedure TFImportTextFile2Table.SpeedButton1Click(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFImportTextFile2Table.SuperFormKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  if Key=VK_ESCAPE then ModalResult:=mrCancel;
end;

procedure TFImportTextFile2Table.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  Action:=caFree;
end;

end.

