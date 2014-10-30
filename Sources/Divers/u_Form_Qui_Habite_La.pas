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

unit u_Form_Qui_Habite_La;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,u_objet_TIntegerList, u_ancestropictimages,SysUtils,
  RVStyle,u_comp_TYLanguage,Dialogs,Menus,DB,
  IBCustomDataSet,IBQuery,RichView,ExtCtrls,
  U_ExtDBGrid,StdCtrls,u_buttons_appli,
  Controls,Graphics,IB,IBUpdateSQL;

type

  { TFQuiHabiteLa }

  TFQuiHabiteLa=class(TF_FormAdapt)
    IATitle1: TIATitle;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    IBQNom:TIBQuery;
    DSNom:TDataSource;
    pmUnions:TPopupMenu;
    mFiche:TMenuItem;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Panel2:TPanel;
    N1:TMenuItem;
    ExporterenHTML1:TMenuItem;
    RVStyle: TRVStyle;
    SaveDialog:TSaveDialog;
    Language:TYLanguage;
    Label8:TLabel;
    Panel9:TPanel;
    rv:TRichView;
    IBQPere:TIBQuery;
    IBQPereCLE_FICHE:TLongintField;
    IBQPereNOM:TIBStringField;
    IBQPerePRENOM:TIBStringField;
    IBQEvPere:TIBQuery;
    IBQEvPereEV_IND_DATE_WRITEN:TIBStringField;
    IBQEvPereEV_IND_VILLE:TIBStringField;
    lPere:TLabel;
    lMere:TLabel;
    IBQConjoint:TIBQuery;
    IBQConjointCLE_FICHE:TLongintField;
    IBQConjointNOM:TIBStringField;
    IBQConjointPRENOM:TIBStringField;
    IBQConjointSEXE:TLongintField;
    IBQEvMere:TIBQuery;
    IBQEvMereEV_IND_DATE_WRITEN:TIBStringField;
    IBQEvMereEV_IND_VILLE:TIBStringField;
    IBQMere:TIBQuery;
    IBQMereCLE_FICHE:TLongintField;
    IBQMereNOM:TIBStringField;
    IBQMerePRENOM:TIBStringField;
    lConjoint:TLabel;
    IBQNomCLE_FICHE:TLongintField;
    IBQNomNOM:TIBStringField;
    IBQNomPRENOM:TIBStringField;
    IBQNomSEXE:TLongintField;
    IBQNomCLE_PERE:TLongintField;
    IBQNomCLE_MERE:TLongintField;
    IBQNomDATE_NAISSANCE:TIBStringField;
    IBQNomDATE_DECES:TIBStringField;
    lVille:TLabel;
    IBQNomEV_IND_CLEF: TLongintField;
    fpBoutons:TPanel;
    GoodBtn7:TFWClose;
    btnCopier:TFWCopy;
    IBUAdresses:TIBUpdateSQL;
    IBQNomEV_IND_DATE_WRITEN: TStringField;
    IBQNomEV_IND_DATE_YEAR: TLongintField;
    IBQNomEV_IND_DATE_YEAR_FIN: TLongintField;
    IBQNomEV_IND_DATE_MOIS: TLongintField;
    IBQNomEV_IND_DATE_MOIS_FIN: TLongintField;
    IBQNomEV_IND_DATE: TDateField;
    IBQNomVILLE_NAISSANCE: TStringField;
    IBQNomEV_IND_DATECODE_TARD: TLongintField;
    IBQNomEV_IND_DATE_JOUR: TSmallintField;
    IBQNomEV_IND_DATE_JOUR_FIN: TSmallintField;
    IBQNomEV_IND_DATECODE: TLongintField;
    IBQNomEV_IND_DATECODE_TOT: TLongintField;
    IBQNomEV_IND_TYPE_TOKEN1: TSmallintField;
    IBQNomEV_IND_TYPE_TOKEN2: TSmallintField;

    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mFicheClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure pmUnionsPopup(Sender:TObject);
    procedure doFillBottomInfos;
    procedure btnCopierClick(Sender:TObject);
    procedure Image1Click(Sender:TObject);
    procedure dxDBGrid1DBTableView1FocusedRecordChanged(
      Sender:TObject;APrevFocusedRecord,
      AFocusedRecord:Longint;
      ANewItemRecordFocusingChanged:Boolean);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure IBQNomBeforePost(DataSet:TDataSet);
    procedure DSNomStateChange(Sender:TObject);
    procedure dxDBGrid1Column7PropertiesChange(Sender: TObject);
  private
    fDialogMode:boolean;
    fCleFicheSelected:integer;
    fIndiJumpTag:TIntegerList;
    fIndiCle:TIntegerList;
    iAdr:integer;
    lsNom,lsPrenom,lsVille:string;

    procedure SetDialogMode(const Value:boolean);
  public
    bModifier:boolean;
    property DialogMode:boolean read fDialogMode write SetDialogMode;
    property CleFicheSelected:integer read fCleFicheSelected write fCleFicheSelected;
    procedure doInit(iClef:integer;sNom,sPrenom,sville:string);
  end;

implementation

uses  u_common_const,
      u_common_ancestro,
      u_common_functions,
      fonctions_string,
      u_form_main,
      u_form_individu_repertoire,
      u_Form_Individu,
      MaskEdit,
      u_common_ancestro_functions,
      fonctions_components,
      fonctions_dialogs,
      rxdbgrid,
      u_genealogy_context;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFQuiHabiteLa.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  pGeneral.Color:=gci_context.ColorLight;
  fIndiCle:=TIntegerList.create;
  fIndiJumpTag:=TIntegerList.create;

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  SaveDialog.InitialDir:=gci_context.PathDocs;

  IBQPere.Close;
  IBQPere.Open;
  IBQEvPere.Close;
  IBQEvPere.Open;
  IBQMere.Close;
  IBQMere.Open;
  IBQEvMere.Close;
  IBQEvMere.Open;
  IBQConjoint.Close;
  IBQConjoint.Open;
end;

procedure TFQuiHabiteLa.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQNom.Close;

  IBQPere.Close;
  IBQEvPere.Close;
  IBQConjoint.Close;
  IBQMere.Close;
  IBQEvMere.Close;

  fIndiCle.Free;
  fIndiJumpTag.Free;
end;

procedure TFQuiHabiteLa.SetDialogMode(const Value:boolean);
begin
  fDialogMode:=Value;
end;

procedure TFQuiHabiteLa.sbCloseClick(Sender:TObject);
begin
  if (IBQNom.Active)and(IBQNom.State in [dsEdit,dsInsert]) then
  begin
    IBQNom.Post;
    bModifier:=true;
  end;

  ModalResult:=mrCancel;
  Close;
end;

procedure TFQuiHabiteLa.mFicheClick(Sender:TObject);
begin
  fCleFicheSelected:=IBQNomCLE_FICHE.AsInteger;
  ModalResult:=mrOk;
end;

procedure TFQuiHabiteLa.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Liste des habitants.HTM';
  if SaveDialog.Execute then
  begin
    IBQNom.DisableControls;
    try
      SavePlace:=IBQNom.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGrid1,True,True);
    finally
      IBQNom.GotoBookmark(SavePlace);
      IBQNom.FreeBookmark(SavePlace);
      IBQNom.EnableControls;
    end;
  end;
end;

procedure TFQuiHabiteLa.pmUnionsPopup(Sender:TObject);
begin
  mFiche.Enabled:=not IBQNom.IsEmpty;
  ExporterenHTML1.Enabled:=mFiche.Enabled;
end;

procedure TFQuiHabiteLa.doFillBottomInfos;
var
  JumpTag:integer;
  s,s2,s3:string;
  sexe:integer;
begin
  rv.Clear;
  rv.FirstJumpNo:=0;
  JumpTag:=0;
  fIndiJumpTag.Clear;
  fIndiCle.Clear;

  sexe:=IBQNomSexe.AsInteger;

  //le nom
  s:=AssembleString([IBQNomNOM.AsString,IBQNomPRENOM.AsString]);

  s:=s+'    ---    NIP : '+IBQNomCLE_FICHE.AsString;
  case sexe of
    1:RVStyle.TextStyles.Items[2].Color:=gci_context.ColorHomme;
    2:RVStyle.TextStyles.Items[2].Color:=gci_context.ColorFemme;
    else
      RVStyle.TextStyles.Items[2].Color:=clWindowText;
  end;
  rv.Add(s,rvsSubheading);
  rv.AddTextFromNewLine(' ',rvsNormal);

  s:=IBQNomDATE_NAISSANCE.AsString;
  if s>'' then
  begin
    case sexe of
      1:s3:='Né le';
      2:s3:='Née le';
      else
        s3:='Né(e) le';
    end;
    s:='                 '+s3+' '+s;
    s2:=trim(IBQNomVILLE_NAISSANCE.AsString);
    if s2>'' then
      s:=s+' '+'à'+' '+s2;
    rv.Add(s,rvsNormal);
    rv.AddTextFromNewLine(' ',rvsNormal);
  end;
  rv.AddTextFromNewLine(' ',rvsNormal);

  //le père
  s:=AssembleString([IBQPereNOM.AsString,IBQPerePRENOM.AsString]);
  if (Length(s)>0) then
    s:=s+'    ---    NIP : '+IBQPereCLE_FICHE.AsString;

  if s>'' then
  begin
    RVStyle.TextStyles.Items[4].Color:=gci_context.ColorHomme;
    rv.Add(lPere.Caption+' ',rvsNormal);
    rv.Add(s,rvsJump1);
    fIndiJumpTag.Add(JumpTag);
    fIndiCle.Add(IBQPereCLE_FICHE.AsInteger);
    inc(JumpTag);
    rv.AddTextFromNewLine(' ',rvsNormal);
    s2:=trim(IBQEvPereEV_IND_DATE_WRITEN.AsString);
    s3:=trim(IBQEvPereEV_IND_VILLE.AsString);
    s:='';
    if s2>'' then
      s:='Né le '+s2+' ';

    if s3>'' then
      s:=s+'à  '+s3;

    if s>'' then
      rv.Add('                 '+s,rvsNormal);

    rv.AddTextFromNewLine(' ',rvsNormal);
  end;

  //la mère
  s:=AssembleString([IBQMereNOM.AsString,IBQMerePRENOM.AsString]);
  if (Length(s)>0) then s:=s+'    ---    NIP : '+IBQMereCLE_FICHE.AsString;

  if s>'' then
  begin
    RVStyle.TextStyles.Items[5].Color:=gci_context.ColorFemme;
    rv.Add(lMere.Caption+' ',rvsNormal);
    rv.Add(s,rvsJump2);
    fIndiJumpTag.Add(JumpTag);
    fIndiCle.Add(IBQMereCLE_FICHE.AsInteger);
    inc(JumpTag);

    rv.AddTextFromNewLine(' ',rvsNormal);
    s2:=trim(IBQEvMereEV_IND_DATE_WRITEN.AsString);
    s3:=trim(IBQEvMereEV_IND_VILLE.AsString);
    s:='';
    if s2>'' then
      s:='Née le '+s2+' ';

    if s3>'' then
      s:=s+'à  '+s3;

    if s>'' then
      rv.Add('                 '+s,rvsNormal);

    rv.AddTextFromNewLine(' ',rvsNormal);
  end;

  //les conjoints
  s:=AssembleString([IBQConjointNOM.AsString,IBQConjointPRENOM.AsString]);

  if s>'' then
    s:=s+'    ---    NIP : '+IBQConjointCLE_FICHE.AsString;

  if s>'' then
  begin
    rv.Add(lConjoint.Caption+' ',rvsNormal);
    case IBQConjointSEXE.AsInteger of
      1:rv.Add(s,rvsJump1);
      2:rv.Add(s,rvsJump2);
    end;
    rv.Cursor:=crHandPoint;

    fIndiJumpTag.Add(JumpTag);
    fIndiCle.Add(IBQConjointCLE_FICHE.AsInteger);
  end;

  rv.format;
  rv.Paint;
end;

procedure TFQuiHabiteLa.doInit(iClef:integer;sNom,sPrenom,sville:string);
begin
  lsNom:=sNom;
  lsPrenom:=sPrenom;
  lsVille:=sVille;

  lVille.Caption:=lsVille;

  iAdr:=iClef;
  IBQNom.close;
  IBQNom.Params[0].AsInteger:=iClef;
  IBQNom.Open;
  if not dxDBGrid1.DataSource.DataSet.IsEmpty then
    doFillBottomInfos;
end;

procedure TFQuiHabiteLa.btnCopierClick(Sender:TObject);
var
  aFIndividuRepertoire:TFIndividuRepertoire;
  aLettre:string;
  ev,i:integer;
begin
  //recherche d'un individu par le prénom
  aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
  try
    aFIndividuRepertoire.Position:=poMainFormCenter;
    aFIndividuRepertoire.NomIndi:=IBQNomNOM.AsString;

    aLettre:=Copy(fs_FormatText(IBQNomNOM.AsString,mftUpper,True),1,1);
    aFIndividuRepertoire.InitIndividuPrenom(aLettre,'INDEX',0,IBQNomCLE_FICHE.AsInteger,True,True);
    aFIndividuRepertoire.Caption:=rs_Caption_Select_Persons_to_set_this_address;

    if aFIndividuRepertoire.ShowModal=mrOk then
    begin
      if MyMessageDlg(rs_confirm_address_copying,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
      begin
        try
          for i:=0 to Length(aFIndividuRepertoire.L)-1 do
          begin
            if not TFIndividu(Owner.Owner).CollerEvenement(ev,iAdr,aFIndividuRepertoire.L[i]) then
            begin
              MyMessageDlg(rs_Errors_while_address_copying+_CRLF+rs_Should_better_cancel_update,mtError,
                [mbOK],Self);
              break;
            end;
          end;
          doInit(iAdr,lsNom,lsPrenom,lsVille);
          bModifier:=true;
        except
          on E:EIBError do
            MyMessageDlg(rs_Error_Cannot_copy_address+_CRLF+E.Message,mtError,[mbOK],Self);
        end;
      end;
    end;
  finally
    FreeAndNil(aFIndividuRepertoire);
  end;
end;

procedure TFQuiHabiteLa.Image1Click(Sender:TObject);
var
  i:integer;
begin
  for i:=0 to dxDBGrid1.Columns.Count-1 do
    dxDBGrid1.Columns[i].SortOrder:=smNone;
  IBQNom.Close;
  Screen.Cursor:=crSQLWait;
  IBQNom.Open;
  Screen.Cursor:=crDefault;
end;

procedure TFQuiHabiteLa.dxDBGrid1DBTableView1FocusedRecordChanged(
  Sender:TObject;APrevFocusedRecord,
  AFocusedRecord:Longint;
  ANewItemRecordFocusingChanged:Boolean);
begin
  doFillBottomInfos;
end;

procedure TFQuiHabiteLa.SuperFormShowFirstTime(Sender:TObject);
begin
  Height:=round(FMain.height*gci_context.TailleFenetre/100);
  width:=round(FMain.width*gci_context.TailleFenetre/100);
  Caption:=rs_Caption_Own_at_the_same_address;
end;

procedure TFQuiHabiteLa.IBQNomBeforePost(DataSet:TDataSet);
begin
  TFIndividu(Owner.Owner).CalcChampsDateInd(DataSet);
end;

procedure TFQuiHabiteLa.DSNomStateChange(Sender:TObject);
begin
  if (DSNom.State in [dsEdit,dsInsert]) then
    bModifier:=true;
end;

procedure TFQuiHabiteLa.dxDBGrid1Column7PropertiesChange(Sender: TObject);
var
  joursem,sDateTrans:string;
  ans,mois,jours:integer;
  Cal:TCalendrier;
begin
  if doTesteDateEtJour((sender as TMaskEdit).Text,joursem,sDateTrans,ans,mois,jours,Cal) then
    (sender as TMaskEdit).Font.Color:=clWindowText
  else
    (sender as TMaskEdit).Font.Color:=clRed;
end;

end.

