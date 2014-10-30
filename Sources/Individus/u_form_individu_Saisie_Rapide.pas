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
{   refonte complète (il n'y a plus que le nom d'original) par AL 2010  }
{-----------------------------------------------------------------------}

unit u_form_individu_Saisie_Rapide;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  U_FormAdapt,DB,u_comp_TYLanguage,variants,Forms,Dialogs,
  SysUtils,Classes,IBCustomDataSet,IBUpdateSQL,IBQuery,
  ExtCtrls,Controls,StdCtrls,graphics,IB,StrUtils,Menus,
  U_ExtImage,IBSQL,u_framework_components, u_buttons_appli,
  u_ancestropictbuttons,  u_ancestropictimages, u_extdateedit,
  ExtJvXPCheckCtrls, MaskEdit,u_framework_dbcomponents,
  u_buttons_defs,ExtJvXPButtons, U_ExtPictCombo,
  u_extsearchedit,lazutf8classes, U_ExtMapImageIndex;

type

  { TFIndividuSaisieRapide }

  TFIndividuSaisieRapide=class(TF_FormAdapt)
    BtnInfos: TXAInfo;
    btnInfosVillesNais: TXAFavorite;
    btnInfosVillesProf: TXAFavorite;
    btnInfosVillesDC: TXAFavorite;
    cbActeNaissance: TFWComboBox;
    cbActeProfession: TFWComboBox;
    cbActeDeces: TFWComboBox;
    cbNaissance: TJvXPCheckbox;
    cbProfession: TJvXPCheckbox;
    cbDeces: TJvXPCheckbox;
    cxLieuNaissance: TFWEdit;
    cxLieuProfession: TFWEdit;
    cxLieuDeces: TFWEdit;
    cxSexe: TExtPictCombo;
    edDateNaiss: TExtDateEdit;
    edDateProfession: TExtDateEdit;
    edDateDeces: TExtDateEdit;
    edNotesNaissance: TFWMemo;
    edNotesProfession: TFWMemo;
    edNotesDeces: TFWMemo;
    edSourcesNaissance: TFWMemo;
    edSourcesProfession: TFWMemo;
    edSourcesDeces: TFWMemo;
    gbProfession: TGroupBox;
    gbDeces: TGroupBox;
    LabDateNaissance: TLabel;
    LabDateProfession: TLabel;
    LabDateDeces: TLabel;
    LabNom: TLabel;
    LabPrenom: TLabel;
    Label7: TLabel;
    LabLieuNaissance: TLabel;
    LabLieuProfession: TLabel;
    LabLieuDeces: TLabel;
    LabNotesNaissance: TLabel;
    LabNotesProfession: TLabel;
    LabNotesDeces: TLabel;
    LabSexe: TLabel;
    LabSourcesNaissance: TLabel;
    LabSourcesProfession: TLabel;
    LabSourcesDeces: TLabel;
    lbDayNaiss: TLabel;
    lbDayProfession: TLabel;
    lbDayDeces: TLabel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel2: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel4: TPanel;
    DSPrenom: TDatasource;
    DSPat: TDatasource;
    panDock:TPanel;
    Language:TYLanguage;
    DSVillesFavorites:TDataSource;
    IBQVillesFavorites:TIBQuery;
    fpBoutons:TPanel;
    btnAbandonner:TFWClose;
    fsbEffacer:TFWErase;
    fsbEnregistrer:TFWOK;
    cxGroupBox1:TGroupBox;
    Panel1: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    sDBELieuNaissance: TExtSearchEdit;
    sDBELieuProfession: TExtSearchEdit;
    sDBELieuDeces: TExtSearchEdit;
    gbDetail:TGroupBox;
    Panel3:TPanel;
    Image1:TIATitle;
    cxLabel1:TFWLabel;
    IBQVillesFavoritesVILLE: TIBStringField;
    IBQVillesFavoritesCP: TIBStringField;
    IBQVillesFavoritesDEPT: TIBStringField;
    IBQVillesFavoritesREGION: TIBStringField;
    IBQVillesFavoritesPAYS: TIBStringField;
    IBQVillesFavoritesINSEE: TIBStringField;
    IBQVillesFavoritesSUBD: TIBStringField;
    IBQVillesFavoritesLATITUDE: TFloatField;
    IBQVillesFavoritesLONGITUDE: TFloatField;
    IBQVillesFavoritesVILLE_SUBD:TStringField;
    dsProfession:TDataSource;
    ibqProfession:TIBQuery;
    ibqProfessionPROFESSION:TIBStringField;
    IBQPatronymes:TIBQuery;
    IBQPrenoms:TIBQuery;
    gbNotesIndi: TGroupBox;
    edNotesIndi: TFWMemo;
    gbSourcesIndi: TGroupBox;
    edSourcesIndi: TFWMemo;
    pmClearLieuNaissance: TPopupMenu;
    mClearLieuNaissance: TMenuItem;
    pmClearLieuDeces: TPopupMenu;
    mClearLieuDeces: TMenuItem;
    pmClearLieuProfession: TPopupMenu;
    mClearLieuProfession: TMenuItem;
    cbCacheRep: TJvXPCheckBox;
    Label18: TIAInfo;
    sDBENom: TExtSearchEdit;
    sdbePrenom: TExtSearchEdit;
    procedure sDBELieuDecesLocate(Sender: TObject);
    procedure sDBELieuDecesSet(Sender: TObject);
    procedure sDBELieuNaissanceLocate(Sender: TObject);
    procedure sDBELieuNaissanceSet(Sender: TObject);
    procedure sDBELieuProfessionLocate(Sender: TObject);
    procedure sDBELieuProfessionSet(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure fsbEffacerClick(Sender:TObject);
    procedure sDBENomChange(Sender:TObject);
    procedure fsbEnregistrerClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure btnInfosVillesNaisClick(Sender:TObject);
    procedure btnInfosVillesDCClick(Sender:TObject);
    procedure cbNaissanceClick(Sender:TObject);
    procedure cbDecesClick(Sender:TObject);
    procedure cxLieuNaissanceExit(Sender:TObject);
    procedure cxLieuDecesExit(Sender:TObject);
    procedure ComboPrenomChange(Sender:TObject);
    procedure edDateDecesExit(Sender:TObject);
    procedure btnInfosVillesProfClick(Sender:TObject);
    procedure cxLieuProfessionExit(Sender:TObject);
    procedure cbProfessionClick(Sender:TObject);
    procedure edNotesNaissanceExit(Sender:TObject);
    procedure edNotesNaissanceEnter(Sender:TObject);
    procedure edNotesNaissanceKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure edSourcesNaissanceExit(Sender:TObject);
    procedure edSourcesDecesExit(Sender:TObject);
    procedure edNotesDecesExit(Sender:TObject);
    procedure edNotesProfessionExit(Sender:TObject);
    procedure edSourcesProfessionExit(Sender:TObject);
    procedure cbActeNaissanceExit(Sender: TObject);
    procedure cbActeDecesExit(Sender: TObject);
    procedure cbProfExit(Sender: TObject);
    procedure cbActeProfessionExit(Sender: TObject);
    procedure fsbEnregistrerExit(Sender: TObject);
    procedure gbDecesClick(Sender: TObject);
    procedure gbProfessionClick(Sender: TObject);
    procedure LabLieuNaissanceClick(Sender: TObject);
    procedure LabLieuDecesClick(Sender: TObject);
    procedure LabLieuProfessionClick(Sender: TObject);
    procedure LabNotesNaissanceClick(Sender: TObject);
    procedure LabSourcesNaissanceClick(Sender: TObject);
    procedure LabNotesDecesClick(Sender: TObject);
    procedure LabSourcesDecesClick(Sender: TObject);
    procedure LabDateLabDateProfessionClick(Sender: TObject);
    procedure LabNotesProfessionClick(Sender: TObject);
    procedure LabSourcesProfessionClick(Sender: TObject);
    procedure cxGroupBox1Click(Sender: TObject);
    procedure gbDetailClick(Sender: TObject);
    procedure LabSexeClick(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnInfosClick(Sender: TObject);
    procedure gbNotesIndiClick(Sender: TObject);
    procedure gbSourcesIndiClick(Sender: TObject);
    procedure sDBELieuPropertiesCloseUp(Sender: TObject);
    procedure mClearLieuNaissanceClick(Sender: TObject);
    procedure mClearLieuDecesClick(Sender: TObject);
    procedure mClearLieuProfessionClick(Sender: TObject);
    procedure cbCacheRepClick(Sender: TObject);
    procedure SuperFormActivate(Sender: TObject);
    procedure Label18Click(Sender: TObject);
    procedure HintStyleControllerShowHintEx(Sender: TObject; var Caption,
      HintStr: String; var CanShow: Boolean; var HintInfo: THintInfo);
  private
    fCleFiche:integer;
    fSexe:integer;
    fNomFiche:string;
    fNomPrenomFiche,
    fDateNaiss,fDateDeces,
    aLieuProfVille,aLieuDecesVille,aLieuNaissVille,
    aLieuNaissCP,aLieuNaissInsee,aLieuNaissSubd,aLieuNaissDept,aLieuNaissRegion
      ,aLieuNaissPays,aLieuNaissLat,aLieuNaissLong
      ,aLieuDecesCP,aLieuDecesInsee,aLieuDecesSubd,aLieuDecesDept,aLieuDecesRegion
      ,aLieuDecesPays,aLieuDecesLat,aLieuDecesLong
      ,aLieuProfCP,aLieuProfInsee,aLieuProfSubd,aLieuProfDept,aLieuProfRegion
      ,aLieuProfPays,aLieuProfLat,aLieuProfLong:string;
    BloqueCar:boolean;

    procedure doAppliquer;
    procedure doInitVariable;
    procedure InitLieuNaiss;
    procedure InitLieuDeces;
    procedure InitLieuProf;
    procedure QuitteMemo(Sender:TObject);
    procedure ModeSaisie(Mode:integer);
    procedure ActiverAideNom;
    procedure ActiverAideProfession;
  public
    property CleFiche:integer read fCleFiche write fCleFiche;
    property NomFiche:string read fNomFiche write fNomFiche;

    property NomPrenomFiche:string read fNomPrenomFiche write fNomPrenomFiche;
    property Sexe:integer read fSexe write fSexe;
    property DateNaiss:string read fDateNaiss write fDateNaiss;
    property DateDeces:string read fDateDeces write fDateDeces;
  end;

implementation
{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

uses u_dm,
     u_genealogy_context,
     LazUTF8,
     u_common_functions,
     fonctions_dialogs,
     u_common_ancestro,
     u_common_const,
     u_common_ancestro_functions,
     u_form_main,u_Form_Calendriers,u_objet_TGedcomDate,FMTBcd,Math,
     fonctions_string;

const
  HmemoUp=106;
  HmemoDown=21;

procedure TFIndividuSaisieRapide.SuperFormCreate(Sender:TObject);
begin
  DefaultCloseAction:=caHide;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  btnInfosVillesNais.Color:=gci_context.ColorLight;
  btnInfosVillesDC.Color:=gci_context.ColorLight;
  btnInfosVillesProf.Color:=gci_context.ColorLight;
  btnInfosVillesNais.ColorFrameFocus:=gci_context.ColorLight;
  btnInfosVillesDC.ColorFrameFocus:=gci_context.ColorLight;
  btnInfosVillesProf.ColorFrameFocus:=gci_context.ColorLight;
  cxLieuNaissance.Left:=sDBELieuNaissance.Left;
  cxLieuNaissance.Top:=sDBELieuNaissance.Top;
  cxLieuNaissance.Width:=sDBELieuNaissance.Width;

  cxLieuDeces.Left:=sDBELieuDeces.Left;
  cxLieuDeces.Top:=sDBELieuDeces.Top;
  cxLieuDeces.Width:=sDBELieuDeces.Width;

  cxLieuProfession.Left:=sDBELieuProfession.Left;
  cxLieuProfession.Top:=sDBELieuProfession.Top;
  cxLieuProfession.Width:=sDBELieuProfession.Width;

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  fCleFiche:=-1;
  fNomFiche:='';
  fNomPrenomFiche:='';
  BloqueCar:=false;
  doInitVariable;
  sDBENom.ModeFormat:=gci_context.ModeSaisieNom;
  sdbePrenom.ModeFormat:=gci_context.ModeSaisiePrenom;
end;

procedure TFIndividuSaisieRapide.sDBELieuNaissanceLocate(Sender: TObject);
begin
  cbNaissance.Checked:=sDBELieuNaissance.Located;

end;

procedure TFIndividuSaisieRapide.sDBELieuNaissanceSet(Sender: TObject);
begin
  sDBELieuPropertiesCloseUp(Sender);
  cbActeNaissance.SetFocus;
end;

procedure TFIndividuSaisieRapide.sDBELieuProfessionLocate(Sender: TObject);
begin
  cbProfession.Checked:=sDBELieuProfession.Located;

end;

procedure TFIndividuSaisieRapide.sDBELieuProfessionSet(Sender: TObject);
begin
  sDBELieuPropertiesCloseUp(Sender);

  cbActeProfession.SetFocus;

end;

procedure TFIndividuSaisieRapide.sDBELieuDecesLocate(Sender: TObject);
begin
  cbDeces.Checked:=sDBELieuDeces.Located;

end;

procedure TFIndividuSaisieRapide.sDBELieuDecesSet(Sender: TObject);
begin
  sDBELieuPropertiesCloseUp(Sender);
  cbActeDeces.SetFocus;
end;

procedure TFIndividuSaisieRapide.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  if fsbEnregistrer.Enabled then
    if MyMessageDlg(rs_Confirm_recording_this_person,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
      doAppliquer
    else
      fNomFiche:='';
  IBQVillesFavorites.Close;
  IBQPatronymes.Close;
  IBQPrenoms.Close;
  ibqProfession.Close;
  FMain.bSRCacheRep:=cbCacheRep.Checked;
end;

procedure TFIndividuSaisieRapide.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFIndividuSaisieRapide.SuperFormShowFirstTime(Sender:TObject);
begin
  cxSexe.ItemIndex:=fSexe;
  sDBENom.text:=trim(sDBENom.text);
  ActiverAideProfession;
  ActiverAideNom;
  IBQPrenoms.Open;
  fsbEffacer.Enabled:=sDBENom.text>'';
  fsbEnregistrer.enabled:=fsbEffacer.Enabled;
  gbDetail.Enabled:=fsbEffacer.Enabled;
  BtnInfos.Enabled:=fsbEffacer.Enabled;
end;

procedure TFIndividuSaisieRapide.SuperFormActivate(Sender: TObject);
begin
  cbCacheRep.Visible:=self.Owner.ClassName='TFIndividuRepertoire';
  if cbCacheRep.Visible then
    cbCacheRep.Checked:=FMain.bSRCacheRep;//déclanche si true puisque Checked=false au départ
  //mis là parce que le Self.Show ne doit pas être déclanché avant le ShowModal de la fiche.
end;

procedure TFIndividuSaisieRapide.ActiverAideNom;
begin
  IBQPatronymes.Close;
  IBQPatronymes.ParamByName('DOSSIER').AsInteger:=dm.NumDossier;
  IBQPatronymes.Open;
end;

procedure TFIndividuSaisieRapide.ActiverAideProfession;
begin
  Screen.Cursor:=crSQLWait;
  try
    ibqProfession.Close;
    ibqProfession.Params[0].AsInteger:=dm.NumDossier;
    ibqProfession.Open;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFIndividuSaisieRapide.fsbEffacerClick(Sender:TObject);
begin
  sDBENom.Text:='';
  sdbePrenom.Text:='';
  doInitVariable;

  cbNaissance.Checked:=False;
  cbDeces.Checked:=False;

  if cxSexe.Enabled then
    cxSexe.ItemIndex:=2;

  fsbEnregistrer.Enabled:=False;
  fsbEffacer.Enabled:=False;
  gbDetail.Enabled:=False;
  BtnInfos.Enabled:=false;

  SendFocus(sDBENom);
end;

procedure TFIndividuSaisieRapide.sDBENomChange(Sender:TObject);
begin
  fsbEffacer.enabled:=sDBENom.Text>'';
  fsbEnregistrer.enabled:=trim(sDBENom.Text)>'';
  gbDetail.Enabled:=fsbEnregistrer.enabled;
  BtnInfos.Enabled:=fsbEnregistrer.enabled;
end;

procedure TFIndividuSaisieRapide.fsbEnregistrerClick(Sender:TObject);
begin
  doAppliquer;
end;

procedure TFIndividuSaisieRapide.SuperFormKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  case Key of
    _KEY_HELP:p_ShowHelp(_ID_SAISIE_RAPIDE);
    VK_RETURN,ord('I'):if (shift=[ssCtrl])and BtnInfos.Enabled then
    begin//bascule rapide entre les 2 "pages" par Ctrl+I ou Ctrl+Entrée
      BtnInfos.SetFocus;//pour activer les OnExit des champs memo
      BtnInfosClick(sender);
    end;
  end;
end;

procedure TFIndividuSaisieRapide.btnInfosVillesNaisClick(Sender:TObject);
var
  Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string;
begin
  if FMain.ChercheVille(self,-1,'',cxLieuNaissance.Text,
    Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long) then
  begin
    cbNaissance.Checked:=True;

    aLieuNaissPays:=Pays;
    aLieuNaissRegion:=Region;
    aLieuNaissDept:=Dept;
    aLieuNaissCP:=Code;
    aLieuNaissInsee:=Insee;
    aLieuNaissVille:=Ville;
    aLieuNaissSubd:=Subd;
    aLieuNaissLat:=Lat;
    aLieuNaissLong:=Long;

    sDBELieuNaissance.Text:=aLieuNaissVille;
    cxLieuNaissance.Text:=aLieuNaissVille;
    cbActeNaissance.SetFocus;
  end;
end;

procedure TFIndividuSaisieRapide.btnInfosVillesDCClick(Sender:TObject);
var
  Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string;
begin
  if FMain.ChercheVille(self,-1,'',cxLieuDeces.Text,
    Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long) then
  begin
    cbDeces.Checked:=True;

    aLieuDecesPays:=Pays;
    aLieuDecesRegion:=Region;
    aLieuDecesDept:=Dept;
    aLieuDecesCP:=Code;
    aLieuDecesInsee:=Insee;
    aLieuDecesVille:=Ville;
    aLieuDecesSubd:=Subd;
    aLieuDecesLat:=Lat;
    aLieuDecesLong:=Long;

    sDBELieuDeces.Text:=aLieuDecesVille;
    cxLieuDeces.Text:=aLieuDecesVille;
    cbActeDeces.SetFocus;
  end;
end;

procedure TFIndividuSaisieRapide.btnInfosVillesProfClick(Sender:TObject);
var
  Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string;
begin
  if FMain.ChercheVille(self,-1,'',cxLieuProfession.Text,
    Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long) then
  begin
    cbProfession.Checked:=True;

    aLieuProfPays:=Pays;
    aLieuProfRegion:=Region;
    aLieuProfDept:=Dept;
    aLieuProfCP:=Code;
    aLieuProfInsee:=Insee;
    aLieuProfVille:=Ville;
    aLieuProfSubd:=Subd;
    aLieuProfLat:=Lat;
    aLieuProfLong:=Long;

    sDBELieuProfession.Text:=aLieuProfVille;
    cxLieuProfession.Text:=aLieuProfVille;
    cbActeProfession.SetFocus;
  end;
end;



procedure TFIndividuSaisieRapide.doAppliquer;
const
  sSQLIndi='insert into individu('
    +'CLE_FICHE'
    +',KLE_DOSSIER'
    +',NOM'
    +',PRENOM'
    +',SEXE'
    +',MODIF_PAR_QUI'
    +',COMMENT'
    +',SOURCE)'
    +'values('
    +'gen_id(gen_individu,1)'
    +',:KLE_DOSSIER'
    +',:NOM'
    +',:PRENOM'
    +',:SEXE'
    +',:MODIF_PAR_QUI'
    +',:COMMENT'
    +',:SOURCE)returning cle_fiche';

  sSQLEve='INSERT INTO EVENEMENTS_IND ('
    +'EV_IND_KLE_FICHE'
    +',EV_IND_KLE_DOSSIER'
    +',EV_IND_TYPE'
    +',EV_IND_DATE_WRITEN'
    +',EV_IND_DATE'
    +',EV_IND_DATE_YEAR'
    +',EV_IND_DATE_MOIS'
    +',EV_IND_DATE_YEAR_FIN'
    +',EV_IND_DATE_MOIS_FIN'
    +',EV_IND_CP'
    +',EV_IND_VILLE'
    +',EV_IND_DEPT'
    +',EV_IND_PAYS'
    +',EV_IND_REGION'
    +',EV_IND_SUBD'
    +',EV_IND_INSEE'
    +',EV_IND_LATITUDE'
    +',EV_IND_LONGITUDE'
    +',EV_IND_ACTE'
    +',EV_IND_COMMENT'
    +',EV_IND_SOURCE'
    +',EV_IND_DESCRIPTION'
    +',ev_ind_date_jour'
    +',ev_ind_date_jour_fin'
    +',ev_ind_type_token1'
    +',ev_ind_type_token2'
    +',ev_ind_datecode'
    +',ev_ind_datecode_tot'
    +',ev_ind_datecode_tard'
    +',ev_ind_calendrier1'
    +',ev_ind_calendrier2'
    +')'
    +' VALUES('
    +':EV_IND_KLE_FICHE'
    +',:EV_IND_KLE_DOSSIER'
    +',:EV_IND_TYPE'
    +',:EV_IND_DATE_WRITEN'
    +',:EV_IND_DATE'
    +',:EV_IND_DATE_YEAR'
    +',:EV_IND_DATE_MOIS'
    +',:EV_IND_DATE_YEAR_FIN'
    +',:EV_IND_DATE_MOIS_FIN'
    +',:EV_IND_CP'
    +',:EV_IND_VILLE'
    +',:EV_IND_DEPT'
    +',:EV_IND_PAYS'
    +',:EV_IND_REGION'
    +',:EV_IND_SUBD'
    +',:EV_IND_INSEE'
    +',:EV_IND_LATITUDE'
    +',:EV_IND_LONGITUDE'
    +',:EV_IND_ACTE'
    +',:EV_IND_COMMENT'
    +',:EV_IND_SOURCE'
    +',:EV_IND_DESCRIPTION'
    +',:ev_ind_date_jour'
    +',:ev_ind_date_jour_fin'
    +',:ev_ind_type_token1'
    +',:ev_ind_type_token2'
    +',:ev_ind_datecode'
    +',:ev_ind_datecode_tot'
    +',:ev_ind_datecode_tard'
    +',:ev_ind_calendrier1'
    +',:ev_ind_calendrier2'
    +')';

var
  qInsert:TIBSQL;
  bContinue:boolean;
  i:integer;
  LaDate:TGedcomDate;
  fDateProf:string;
  n,s:string;

  procedure InitQinsertEve;
  var i:integer;
  begin
    with qInsert do
    begin
      close;
      SQL.text:=sSQLEve;
      ParamByName('EV_IND_KLE_FICHE').AsInteger:=fCleFiche;
      ParamByName('EV_IND_KLE_DOSSIER').AsInteger:=dm.NumDossier;
      for i:=2 to Params.Count-1 do
        Params[i].Clear;
    end;
  end;

  procedure ParamDateEve(DateEcrite:string);
  var s:string;
  begin
    if DateEcrite>'' then
    begin
      with qInsert do
      begin
        if LaDate.DecodeHumanDate(DateEcrite) then
        begin
          if LaDate.ValidDateTime1 then
            ParamByName('EV_IND_DATE').AsDateTime:=LaDate.DateTime1;
          ParamByName('EV_IND_DATECODE').AsInteger:=LaDate.DateCode1;
          ParamByName('EV_IND_DATECODE_TOT').AsInteger:=LaDate.DateCodeTot;
          ParamByName('EV_IND_DATECODE_TARD').AsInteger:=LaDate.DateCodeTard;
          ParamByName('EV_IND_DATE_YEAR').AsInteger:=LaDate.Year1;
          if LaDate.Month1>0 then
            ParamByName('EV_IND_DATE_MOIS').AsInteger:=LaDate.Month1;
          if LaDate.Day1>0 then
            ParamByName('EV_IND_DATE_JOUR').AsInteger:=LaDate.Day1;
          if LaDate.Type_Key1>0 then
            ParamByName('EV_IND_TYPE_TOKEN1').AsInteger:=LaDate.Type_Key1;
          if LaDate.UseDate2 then
          begin
            ParamByName('EV_IND_DATE_YEAR_FIN').AsInteger:=LaDate.Year2;
            if LaDate.Month2>0 then
              ParamByName('EV_IND_DATE_MOIS_FIN').AsInteger:=LaDate.Month2;
            if LaDate.Day2>0 then
              ParamByName('EV_IND_DATE_JOUR_FIN').AsInteger:=LaDate.Day2;
            if LaDate.Type_Key2>0 then
              ParamByName('EV_IND_TYPE_TOKEN2').AsInteger:=LaDate.Type_Key2;
          end;
        end;
        s:=LaDate.HumanDate;
        if Length(s)>0 then
          ParamByName('EV_IND_DATE_WRITEN').AsString:=s;
      end;
    end;
  end;

  function ValActe(s:string):integer;
  begin
    if s='Acte trouvé' then
      result:=1
    else if s='Acte absent' then
      result:=0
    else if s='Acte demandé' then
      result:=-1
    else if s='Acte à chercher' then
      result:=-2
    else if s='Acte à ignorer' then
      result:=-3
    else
      result:=0;
  end;

begin
  fNomFiche:=sdbenom.Text;
  fSexe:=cxSexe.ItemIndex;
  fNomPrenomFiche:=sDBENom.Text+', '+sdbePrenom.Text;
  fDateDeces:=edDateDeces.Text;
  fDateNaiss:=edDateNaiss.Text;
  LaDate:=TGedcomDate.Create;
  LaDate.InitTGedcomDate(_MotsClesDate,_MotsClesDate);

  qInsert:=TIBSQL.Create(self);
  try
    with qInsert do
    begin
      try
        DataBase:=dm.ibd_BASE;
        SQL.Text:=sSQLIndi;
        for i:=0 to ParamCount-1 do
          Params[i].Clear;
        ParamByName('KLE_DOSSIER').AsInteger:=dm.NumDossier;
        ParamByName('NOM').AsString:=sDBENom.Text;
        s:=trim(sdbePrenom.Text);
        if s>'' then
          ParamByName('PRENOM').AsString:=s;
        ParamByName('SEXE').AsInteger:=fSexe;
        ParamByName('MODIF_PAR_QUI').AsString:=Copy(dm.Computer+':'+dm.UserName,1,30);
        n:=trim(edNotesIndi.Text);
        if n>'' then
          ParamByName('COMMENT').AsString:=n;
        s:=trim(edSourcesIndi.Text);
        if s>'' then
          ParamByName('SOURCE').AsString:=s;
        ExecQuery;
        fCleFiche:=Fields[0].AsInteger;
        Close;
        bContinue:=True;
      except
        on E:EIBError do
        begin
          ShowMessage('Erreur MAJ : Table Individu...'+_CRLF+_CRLF+E.Message);
          bContinue:=False;
        end;
      end;

      if bContinue then
      begin
        i:=ValActe(cbActeNaissance.Text);
        n:=trim(edNotesNaissance.Text);
        s:=trim(edSourcesNaissance.Text);
        aLieuNaissVille:=sDBELieuNaissance.Text;
        fDateNaiss:=edDateNaiss.Text;
        if (aLieuNaissVille>'')or(fDateNaiss>'')or(i<>0)or(n>'')or(s>'') then
        begin
          try
            InitQinsertEve;
            ParamByName('EV_IND_TYPE').AsString:='BIRT';
            ParamDateEve(fDateNaiss);
            if aLieuNaissCP>'' then
              ParamByName('EV_IND_CP').AsString:=aLieuNaissCP;
            if aLieuNaissVille>'' then
              ParamByName('EV_IND_VILLE').AsString:=aLieuNaissVille;
            if aLieuNaissDept>'' then
              ParamByName('EV_IND_DEPT').AsString:=aLieuNaissDept;
            if aLieuNaissPays>'' then
              ParamByName('EV_IND_PAYS').AsString:=aLieuNaissPays;
            if aLieuNaissRegion>'' then
              ParamByName('EV_IND_REGION').AsString:=aLieuNaissRegion;
            if aLieuNaissSubd>'' then
              ParamByName('EV_IND_SUBD').AsString:=aLieuNaissSubd;
            if aLieuNaissInsee>'' then
              ParamByName('EV_IND_INSEE').AsString:=aLieuNaissInsee;
            if aLieuNaissLat>'' then
              ParamByName('EV_IND_LATITUDE').AsDouble:=StrToBcd(aLieuNaissLat);
            if aLieuNaissLong>'' then
              ParamByName('EV_IND_LONGITUDE').AsDouble:=StrToBcd(aLieuNaissLong);
            ParamByName('EV_IND_ACTE').AsInteger:=i;
            if n>'' then
              ParamByName('EV_IND_COMMENT').AsString:=n;
            if s>'' then
              ParamByName('EV_IND_SOURCE').AsString:=s;
            ExecQuery;
            Close;
          except
            on E:EIBError do
            begin
              ShowMessage('Erreur MAJ : Table EV_IND BIRT'+_CRLF+_CRLF+E.Message);
            end;
          end;
        end;

        i:=ValActe(cbActeDeces.Text);
        n:=trim(edNotesDeces.Text);
        s:=trim(edSourcesDeces.Text);
        aLieuDecesVille:=sDBELieuDeces.Text;
        fDateDeces:=edDateDeces.Text;
        if (aLieuDecesVille>'')or(FDateDeces>'')or(i<>0)or(n>'')or(s>'') then
        begin
          try
            InitQinsertEve;
            ParamByName('EV_IND_TYPE').AsString:='DEAT';
            ParamDateEve(FDateDeces);
            if aLieuDecesCP>'' then
              ParamByName('EV_IND_CP').AsString:=aLieuDecesCP;
            if aLieuDecesVille>'' then
              ParamByName('EV_IND_VILLE').AsString:=aLieuDecesVille;
            if aLieuDecesDept>'' then
              ParamByName('EV_IND_DEPT').AsString:=aLieuDecesDept;
            if aLieuDecesPays>'' then
              ParamByName('EV_IND_PAYS').AsString:=aLieuDecesPays;
            if aLieuDecesRegion>'' then
              ParamByName('EV_IND_REGION').AsString:=aLieuDecesRegion;
            if aLieuDecesSubd>'' then
              ParamByName('EV_IND_SUBD').AsString:=aLieuDecesSubd;
            if aLieuDecesInsee>'' then
              ParamByName('EV_IND_INSEE').AsString:=aLieuDecesInsee;
            if aLieuDecesLat>'' then
              ParamByName('EV_IND_LATITUDE').AsDouble:=StrToBcd(aLieuDecesLat);
            if aLieuDecesLong>'' then
              ParamByName('EV_IND_LONGITUDE').AsDouble:=StrToBcd(aLieuDecesLong);
            ParamByName('EV_IND_ACTE').AsInteger:=i;
            if n>'' then
              ParamByName('EV_IND_COMMENT').AsString:=n;
            if s>'' then
              ParamByName('EV_IND_SOURCE').AsString:=s;
            ExecQuery;
            Close;
          except
            on E:EIBError do
            begin
              ShowMessage('Erreur MAJ : Table EV_IND DEAT'+_CRLF+_CRLF+E.Message);
            end;
          end;
        end;

        i:=ValActe(cbActeProfession.Text);
        n:=trim(edNotesProfession.Text);
        s:=trim(edSourcesProfession.Text);
        aLieuProfVille:=sDBELieuProfession.Text;
        fDateProf:=edDateNaiss.Text;
        if (trim(cbActeProfession.Text)>'')or(aLieuProfVille>'')or(fDateProf>'')
          or(i<>0)or(n>'')or(s>'') then
        begin
          try
            InitQinsertEve;
            ParamByName('EV_IND_TYPE').AsString:='OCCU';
            if trim(cbActeProfession.Text)>'' then
              ParamByName('EV_IND_DESCRIPTION').AsString:=trim(cbActeProfession.Text);
            ParamDateEve(fDateProf);
            if aLieuProfCP>'' then
              ParamByName('EV_IND_CP').AsString:=aLieuProfCP;
            if aLieuProfVille>'' then
              ParamByName('EV_IND_VILLE').AsString:=aLieuProfVille;
            if aLieuProfDept>'' then
              ParamByName('EV_IND_DEPT').AsString:=aLieuProfDept;
            if aLieuProfPays>'' then
              ParamByName('EV_IND_PAYS').AsString:=aLieuProfPays;
            if aLieuProfRegion>'' then
              ParamByName('EV_IND_REGION').AsString:=aLieuProfRegion;
            if aLieuProfSubd>'' then
              ParamByName('EV_IND_SUBD').AsString:=aLieuProfSubd;
            if aLieuProfInsee>'' then
              ParamByName('EV_IND_INSEE').AsString:=aLieuProfInsee;
            if aLieuProfLat>'' then
              ParamByName('EV_IND_LATITUDE').AsDouble:=StrToBcd(aLieuProfLat);
            if aLieuProfLong>'' then
              ParamByName('EV_IND_LONGITUDE').AsDouble:=StrToBcd(aLieuProfLong);
            ParamByName('EV_IND_ACTE').AsInteger:=i;
            if n>'' then
              ParamByName('EV_IND_COMMENT').AsString:=n;
            if s>'' then
              ParamByName('EV_IND_SOURCE').AsString:=s;
            ExecQuery;
            Close;
          except
            on E:EIBError do
            begin
              ShowMessage('Erreur MAJ : Table EV_IND DEAT'+_CRLF+_CRLF+E.Message);
            end;
          end;
        end;
      end;//de if bContinue
    end;//de with qInsert
  finally
    qInsert.Free;
  end;
  Screen.Cursor:=crDefault;
{
  if Assigned(FMain.aFIndividu) then
    if Assigned(FMain.aFIndividu.aFIndividuIdentite) then
      FMain.aFIndividu.aFIndividuIdentite.AjouteNomAliste(sDBENom.Text);
}
  fsbEnregistrer.Enabled:=False; //doit être fait avant le close car utilisé comme marqueur de l'enregistrement

  if self.Caption<>rs_caption_Create_Person then
    sbCloseClick(self)
  else
  begin
    IBQPatronymes.Close;
    IBQPatronymes.Open;
    if FMain.aFIndividu<>nil then
      FMain.aFIndividu.doBouton(true);
    fsbEffacerClick(self);
  end;
end;

procedure TFIndividuSaisieRapide.cbNaissanceClick(Sender:TObject);
begin
  InitLieuNaiss;
  sDBELieuNaissance.Clear;
  cxLieuNaissance.Clear;

  sDBELieuNaissance.visible:=not cbNaissance.Checked;
  cxLieuNaissance.visible:=cbNaissance.Checked;

  if cxLieuNaissance.Visible then
  begin
    cxLieuNaissance.TabStop:=true;
    sDBELieuNaissance.TabStop:=False;
    cxLieuNaissance.SetFocus
  end
  else
  begin
    cxLieuNaissance.TabStop:=False;
    sDBELieuNaissance.TabStop:=True;
    sDBELieuNaissance.SetFocus;
  end;
end;

procedure TFIndividuSaisieRapide.cbDecesClick(Sender:TObject);
begin
  InitLieuDeces;
  sDBELieuDeces.Clear;
  cxLieuDeces.Clear;

  sDBELieuDeces.visible:=not cbDeces.Checked;
  cxLieuDeces.visible:=cbDeces.Checked;

  if cxLieuDeces.Visible then
  begin
    cxLieuDeces.TabStop:=true;
    sDBELieuDeces.TabStop:=False;
    cxLieuDeces.SetFocus
  end
  else
  begin
    cxLieuDeces.TabStop:=False;
    sDBELieuDeces.TabStop:=True;
    sDBELieuDeces.SetFocus;
  end;
end;

procedure TFIndividuSaisieRapide.cbProfessionClick(Sender:TObject);
begin
  InitLieuProf;
  sDBELieuProfession.Clear;
  cxLieuProfession.Clear;

  sDBELieuProfession.visible:=not cbProfession.Checked;
  cxLieuProfession.visible:=cbProfession.Checked;

  if cxLieuProfession.Visible then
  begin
    cxLieuProfession.TabStop:=true;
    sDBELieuProfession.TabStop:=False;
    cxLieuProfession.SetFocus
  end
  else
  begin
    cxLieuProfession.TabStop:=False;
    sDBELieuProfession.TabStop:=True;
    sDBELieuProfession.SetFocus;
  end;
end;

procedure TFIndividuSaisieRapide.doInitVariable;
begin
  ModeSaisie(0);
  edDateNaiss.Clear;
  sDBELieuNaissance.Clear;
  cxLieuNaissance.Clear;
  cbActeNaissance.Text:='Acte absent';
  edNotesNaissance.Clear;
  edSourcesNaissance.Clear;
  InitLieuNaiss;

  edDateDeces.Clear;
  sDBELieuDeces.Clear;
  cxLieuDeces.Clear;
  cbActeDeces.Text:='Acte absent';
  edNotesDeces.Clear;
  edSourcesDeces.Clear;
  InitLieuDeces;

  cbActeProfession.Clear;
  edDateProfession.Clear;
  sDBELieuProfession.Clear;
  cbActeProfession.Text:='Acte absent';
  cxLieuProfession.Clear;
  edNotesProfession.Clear;
  edSourcesProfession.Clear;
  InitLieuProf;

  edNotesIndi.Clear;
  edSourcesIndi.Clear;
  IBQVillesFavorites.Close; //pour rafraîchir la liste
  IBQVillesFavorites.Open;
end;

procedure TFIndividuSaisieRapide.InitLieuNaiss;
begin
  aLieuNaissCP:='';
  aLieuNaissInsee:='';
  aLieuNaissSubd:='';
  aLieuNaissDept:='';
  aLieuNaissRegion:='';
  aLieuNaissPays:='';
  aLieuNaissLat:='';
  aLieuNaissLong:='';
end;

procedure TFIndividuSaisieRapide.InitLieuDeces;
begin
  aLieuDecesCP:='';
  aLieuDecesInsee:='';
  aLieuDecesSubd:='';
  aLieuDecesDept:='';
  aLieuDecesRegion:='';
  aLieuDecesPays:='';
  aLieuDecesLat:='';
  aLieuDecesLong:='';
end;

procedure TFIndividuSaisieRapide.InitLieuProf;
begin
  aLieuProfCP:='';
  aLieuProfInsee:='';
  aLieuProfSubd:='';
  aLieuProfDept:='';
  aLieuProfRegion:='';
  aLieuProfPays:='';
  aLieuProfLat:='';
  aLieuProfLong:='';
end;

procedure TFIndividuSaisieRapide.sDBELieuPropertiesCloseUp(
  Sender: TObject);
var
  s:String;
begin
  s:=Trim((Sender as TCustomEdit).Caption);
  if Sender=sDBELieuNaissance then
    cxLieuNaissance.Text:=s
  else if Sender=sDBELieuDeces then
    cxLieuDeces.Text:=s
  else if Sender=sDBELieuProfession then
    cxLieuProfession.Text:=s;
  if s='' then
   begin
    if Sender=sDBELieuNaissance then
      InitLieuNaiss
    else if Sender=sDBELieuDeces then
      InitLieuDeces
    else if Sender=sDBELieuProfession then
      InitLieuProf;
  end
  else if UTF8UpperCase(s)=Copy(UTF8UpperCase(IBQVillesFavorites.FieldByName('VILLE_SUBD').AsString),1,Length(s)) then
  begin
     (Sender as TCustomEdit).Caption:=IBQVillesFavorites.FieldByName('VILLE_SUBD').AsString;
    if Sender=sDBELieuNaissance then
    begin
      aLieuNaissVille:=IBQVillesFavoritesVILLE.AsString;
      aLieuNaissCP:=IBQVillesFavoritesCP.AsString;
      aLieuNaissInsee:=IBQVillesFavoritesINSEE.AsString;
      aLieuNaissSubd:=IBQVillesFavoritesSUBD.AsString;
      aLieuNaissDept:=IBQVillesFavoritesDEPT.AsString;
      aLieuNaissRegion:=IBQVillesFavoritesREGION.AsString;
      aLieuNaissPays:=IBQVillesFavoritesPAYS.AsString;
      aLieuNaissLat:=IBQVillesFavoritesLATITUDE.AsString;
      aLieuNaissLong:=IBQVillesFavoritesLONGITUDE.AsString;
    end
    else if Sender=sDBELieuDeces then
    begin
      aLieuDecesVille:=IBQVillesFavoritesVILLE.AsString;
      aLieuDecesCP:=IBQVillesFavoritesCP.AsString;
      aLieuDecesInsee:=IBQVillesFavoritesINSEE.AsString;
      aLieuDecesSubd:=IBQVillesFavoritesSUBD.AsString;
      aLieuDecesDept:=IBQVillesFavoritesDEPT.AsString;
      aLieuDecesRegion:=IBQVillesFavoritesREGION.AsString;
      aLieuDecesPays:=IBQVillesFavoritesPAYS.AsString;
      aLieuDecesLat:=IBQVillesFavoritesLATITUDE.AsString;
      aLieuDecesLong:=IBQVillesFavoritesLONGITUDE.AsString;
    end
    else if Sender=sDBELieuProfession then
    begin
      aLieuProfVille:=IBQVillesFavoritesVILLE.AsString;
      aLieuProfCP:=IBQVillesFavoritesCP.AsString;
      aLieuProfInsee:=IBQVillesFavoritesINSEE.AsString;
      aLieuProfSubd:=IBQVillesFavoritesSUBD.AsString;
      aLieuProfDept:=IBQVillesFavoritesDEPT.AsString;
      aLieuProfRegion:=IBQVillesFavoritesREGION.AsString;
      aLieuProfPays:=IBQVillesFavoritesPAYS.AsString;
      aLieuProfLat:=IBQVillesFavoritesLATITUDE.AsString;
      aLieuProfLong:=IBQVillesFavoritesLONGITUDE.AsString;
    end;
  end;
end;

procedure TFIndividuSaisieRapide.cxLieuNaissanceExit(Sender:TObject);
begin
  aLieuNaissVille:=trim(cxLieuNaissance.Text);
end;

procedure TFIndividuSaisieRapide.cxLieuDecesExit(Sender:TObject);
begin
  aLieuDecesVille:=trim(cxLieuDeces.Text);
end;

procedure TFIndividuSaisieRapide.cxLieuProfessionExit(Sender:TObject);
begin
  aLieuProfVille:=trim(cxLieuProfession.Text);
end;

procedure TFIndividuSaisieRapide.mClearLieuNaissanceClick(Sender: TObject);
begin
  sDBELieuNaissance.Text:='';
  InitLieuNaiss;
end;

procedure TFIndividuSaisieRapide.mClearLieuDecesClick(Sender: TObject);
begin
  sDBELieuDeces.Text:='';
  InitLieuDeces;
end;

procedure TFIndividuSaisieRapide.mClearLieuProfessionClick(
  Sender: TObject);
begin
  sDBELieuProfession.Text:='';
  InitLieuProf;
end;

procedure TFIndividuSaisieRapide.ComboPrenomChange(Sender:TObject);
var
  TempIndexPrenom:Integer;
  s:string;
begin
  if length(sdbePrenom.Text)=0 then
  begin
    if cxSexe.Enabled then
      cxSexe.ItemIndex:=2;
  end
  else
  begin
    s:=RightStr(sdbePrenom.text,1);
    if (s=' ')or(s=',') then //si dernier caractère est un séparateur
    begin
      if cxSexe.ItemIndex=2 then //rechercher le sexe correspondant au prénom
      begin
        s:=LeftStr(sdbePrenom.Text,Length(sdbePrenom.Text)-1);
        //avant d'avoir tapé le séparateur
        //dernier prénom (s'il fait partie de la liste)
        cxSexe.ItemIndex:=2-IBQPrenoms.FieldByName('sexe').AsInteger;
      end;
    end
  end;
end;

procedure TFIndividuSaisieRapide.edDateDecesExit(Sender:TObject);
begin
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0)and(GetKeyState(VK_SHIFT)<0) then
    SendFocus(edSourcesNaissance);
end;

procedure TFIndividuSaisieRapide.QuitteMemo(Sender:TObject);
begin
  (Sender as TControl).Height:=HmemoDown;
  if (Sender=edNotesProfession)or(Sender=edSourcesProfession) then
    (Sender as TControl).Top:=(Sender as TControl).Top+HmemoUp-HmemoDown;
  edNotesNaissance.Show;
  edSourcesNaissance.Show;
  edNotesDeces.Show;
  edSourcesDeces.Show;
  edNotesProfession.Show;
  edSourcesProfession.Show;
end;

procedure TFIndividuSaisieRapide.edNotesNaissanceEnter(Sender:TObject);
begin
  (Sender as TControl).Height:=HmemoUp;
  if (Sender=edNotesProfession)or(Sender=edSourcesProfession) then
    (Sender as TControl).Top:=(Sender as TControl).Top-HmemoUp+HmemoDown;
  if Sender=edNotesNaissance then //bug composant?: si pas invisibles certains réapparaissent au travers
  begin//du composant agrandi et peuvent être sélectionné...
    LabNotesNaissance.Font.Style:=[fsBold];
    edSourcesNaissance.Hide;
  end
  else if Sender=edSourcesNaissance then
  begin
    LabSourcesNaissance.Font.Style:=[fsBold];
    edNotesDeces.Hide;
  end
  else if Sender=edNotesDeces then
  begin
    LabNotesDeces.Font.Style:=[fsBold];
    edSourcesDeces.Hide;
  end
  else if Sender=edSourcesDeces then
  begin
    LabSourcesDeces.Font.Style:=[fsBold];
  end
  else if Sender=edNotesProfession then
  begin
    LabNotesProfession.Font.Style:=[fsBold];
  end
  else if Sender=edSourcesProfession then
  begin
    LabSourcesProfession.Font.Style:=[fsBold];
    edNotesProfession.Hide;
  end;
end;

procedure TFIndividuSaisieRapide.edNotesNaissanceKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
  champ:TCustomMemo;
begin
  champ:=Sender as TCustomMemo;
  s:=champ.Text;
  k:=champ.SelStart;
  if dm.RemplaceRaccourcis(Key,Shift,s,k) then
  begin
    champ.Text:=s;
    champ.SelStart:=k;
    BloqueCar:=true;
  end
  else if (Key=Ord('F')) and (Shift=[ssCtrl]) then
  begin
    if Sender=sDBELieuNaissance then
    begin
      cbActeNaissance.SetFocus;
      btnInfosVillesNaisClick(Sender);
    end
    else if Sender=sDBELieuDeces then
    begin
      cbActeDeces.SetFocus;
      btnInfosVillesDCClick(Sender);
    end
    else if Sender=sDBELieuProfession then
    begin
      cbActeProfession.SetFocus;
      btnInfosVillesProfClick(Sender);
    end;
  end
  else EditKeyDown(Sender,Key,Shift);
end;

procedure TFIndividuSaisieRapide.cbActeNaissanceExit(Sender: TObject);
begin
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0)and(GetKeyState(VK_SHIFT)>=0) then
    SendFocus(edNotesNaissance);
end;

procedure TFIndividuSaisieRapide.edNotesNaissanceExit(Sender:TObject);
begin
  QuitteMemo(Sender);
  LabNotesNaissance.Font.Style:=[];
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0) then
    if GetKeyState(VK_SHIFT)<0 then
      SendFocus(cbActeNaissance)
    else
      SendFocus(edSourcesNaissance);
end;

procedure TFIndividuSaisieRapide.edSourcesNaissanceExit(Sender:TObject);
begin
  QuitteMemo(Sender);
  LabSourcesNaissance.Font.Style:=[];
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0) then
    if GetKeyState(VK_SHIFT)<0 then
      SendFocus(edNotesNaissance)
    else
      SendFocus(edDateDeces);
end;

procedure TFIndividuSaisieRapide.cbActeDecesExit(Sender: TObject);
begin
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0)and(GetKeyState(VK_SHIFT)>=0) then
    SendFocus(edNotesDeces);
end;

procedure TFIndividuSaisieRapide.edNotesDecesExit(Sender:TObject);
begin
  QuitteMemo(Sender);
  LabNotesDeces.Font.Style:=[];
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0) then
    if GetKeyState(VK_SHIFT)<0 then
      SendFocus(cbActeDeces)
    else
      SendFocus(edSourcesDeces);
end;

procedure TFIndividuSaisieRapide.edSourcesDecesExit(Sender:TObject);
begin
  QuitteMemo(Sender);
  LabSourcesDeces.Font.Style:=[];
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0) then
    if GetKeyState(VK_SHIFT)<0 then
      SendFocus(edNotesDeces)
    else
      SendFocus(cbActeProfession);
end;

procedure TFIndividuSaisieRapide.cbProfExit(Sender: TObject);
begin
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0)and(GetKeyState(VK_SHIFT)<0) then
    SendFocus(edSourcesDeces);
end;

procedure TFIndividuSaisieRapide.cbActeProfessionExit(Sender: TObject);
begin
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0)and(GetKeyState(VK_SHIFT)>=0) then
    SendFocus(edNotesProfession);
end;

procedure TFIndividuSaisieRapide.edNotesProfessionExit(Sender:TObject);
begin
  QuitteMemo(Sender);
  LabNotesProfession.Font.Style:=[];
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0) then
    if GetKeyState(VK_SHIFT)<0 then
      SendFocus(cbActeProfession)
    else
      SendFocus(edSourcesProfession);
end;

procedure TFIndividuSaisieRapide.edSourcesProfessionExit(Sender:TObject);
begin
  QuitteMemo(Sender);
  LabSourcesProfession.Font.Style:=[];
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0) then
    if GetKeyState(VK_SHIFT)<0 then
      SendFocus(edNotesProfession);
end;

procedure TFIndividuSaisieRapide.fsbEnregistrerExit(Sender: TObject);
begin
  if (GetKeyState(VK_TAB)<0)and(GetKeyState(VK_CONTROL)>=0) then
    if GetKeyState(VK_SHIFT)<0 then
      SendFocus(edSourcesProfession);
end;

procedure TFIndividuSaisieRapide.LabLieuNaissanceClick(Sender: TObject);
begin
  if sDBELieuNaissance.Visible then
    SendFocus(sDBELieuNaissance)
  else
    SendFocus(cxLieuNaissance);
end;

procedure TFIndividuSaisieRapide.LabNotesNaissanceClick(Sender: TObject);
begin
  SendFocus(edNotesNaissance);
end;

procedure TFIndividuSaisieRapide.LabSourcesNaissanceClick(Sender: TObject);
begin
  edSourcesNaissance.Visible:=true;
  SendFocus(edSourcesNaissance);
end;

procedure TFIndividuSaisieRapide.gbDecesClick(Sender: TObject);
begin
  SendFocus(edDateDeces);
end;

procedure TFIndividuSaisieRapide.LabLieuDecesClick(Sender: TObject);
begin
  if sDBELieuDeces.Visible then
    SendFocus(sDBELieuDeces)
  else
    SendFocus(cxLieuDeces);
end;

procedure TFIndividuSaisieRapide.LabNotesDecesClick(Sender: TObject);
begin
  edNotesDeces.Visible:=true;
  SendFocus(edNotesDeces);
end;

procedure TFIndividuSaisieRapide.LabSourcesDecesClick(Sender: TObject);
begin
  edSourcesDeces.Visible:=true;
  SendFocus(edSourcesDeces);
end;

procedure TFIndividuSaisieRapide.gbProfessionClick(Sender: TObject);
begin
  SendFocus(cbActeProfession);
end;

procedure TFIndividuSaisieRapide.LabDateLabDateProfessionClick(
  Sender: TObject);
begin
  SendFocus(edDateProfession);
end;

procedure TFIndividuSaisieRapide.LabLieuProfessionClick(Sender: TObject);
begin
  if sDBELieuProfession.Visible then
    SendFocus(sDBELieuProfession)
  else
    SendFocus(cxLieuProfession);
end;

procedure TFIndividuSaisieRapide.LabNotesProfessionClick(Sender: TObject);
begin
  edNotesProfession.Visible:=true;
  SendFocus(edNotesProfession);
end;

procedure TFIndividuSaisieRapide.LabSourcesProfessionClick(
  Sender: TObject);
begin
  SendFocus(edSourcesProfession);
end;

procedure TFIndividuSaisieRapide.cxGroupBox1Click(Sender: TObject);
begin
  SendFocus(sDBENom);
end;

procedure TFIndividuSaisieRapide.gbDetailClick(Sender: TObject);
begin
  SendFocus(sdbePrenom);
end;

procedure TFIndividuSaisieRapide.LabSexeClick(Sender: TObject);
begin
  SendFocus(cxSexe);
end;

procedure TFIndividuSaisieRapide.EditKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  s:string;
begin
  if (sender is TComponent)and(ssCtrl in Shift)and(Key=VK_TAB)then
  begin
    s:=(Sender as TComponent).Name;
    if Pos('Naiss',s)>0 then
      SendFocus(edDateDeces)
    else if Pos('Deces',s)>0 then
      SendFocus(cbActeProfession)
    else if Pos('Prof',s)>0 then
      SendFocus(fsbEnregistrer)
    else if s='sDBENom' then
      SendFocus(sdbePrenom)
    else if (s='ComboPrenom')or(s='cxSexe') then
      SendFocus(edDateNaiss);
  end;
end;

procedure TFIndividuSaisieRapide.ModeSaisie(Mode:integer);
begin
  if mode=0 then
  begin
    BtnInfos.Caption:=rs_Infos;
    edNotesNaissance.Visible:=true;
    edNotesDeces.Visible:=true;
    edNotesProfession.Visible:=true;
    edSourcesNaissance.Visible:=true;
    edSourcesDeces.Visible:=true;
    edSourcesProfession.Visible:=true;
    gbDeces.Visible:=true;
    if edDateNaiss.CanFocus then
      edDateNaiss.SetFocus;
    gbDeces.Visible:=true;
    gbProfession.Visible:=true;
    gbNotesIndi.Visible:=false;
    gbSourcesIndi.Visible:=false;
    btnInfos.Hint:=rs_Hint_Person_s_Notes_and_sources_access;
  end
  else
  begin
    BtnInfos.Caption:=rs_Caption_Birth_Death_Job;
    edNotesNaissance.Visible:=false;
    edNotesDeces.Visible:=false;
    edNotesProfession.Visible:=false;
    edSourcesNaissance.Visible:=false;
    edSourcesDeces.Visible:=false;
    edSourcesProfession.Visible:=false;
    gbDeces.Visible:=false;
    gbDeces.Visible:=false;
    gbProfession.Visible:=false;
    gbNotesIndi.Visible:=true;
    if edNotesIndi.CanFocus then
      edNotesIndi.SetFocus;
    gbSourcesIndi.Visible:=true;
    btnInfos.Hint:=rs_Hint_Person_s_events_access;
  end;
  btnInfos.Hint:=btnInfos.Hint+_CRLF+rs_Hint_Ctrl_and_enter_to_access_with_keyboard;
end;

procedure TFIndividuSaisieRapide.BtnInfosClick(Sender: TObject);
begin
  if BtnInfos.Caption='N·D·P' then
    ModeSaisie(0)
  else
    ModeSaisie(1);
end;

procedure TFIndividuSaisieRapide.gbNotesIndiClick(Sender: TObject);
begin
  edNotesIndi.SetFocus;
end;

procedure TFIndividuSaisieRapide.gbSourcesIndiClick(Sender: TObject);
begin
  edSourcesIndi.SetFocus;
end;


procedure TFIndividuSaisieRapide.cbCacheRepClick(Sender: TObject);
begin
  if (Self.Owner as TForm).WindowState=wsNormal then
    (Self.Owner as TForm).WindowState:=wsMinimized
  else
    (Self.Owner as TForm).WindowState:=wsNormal;
  self.BringToFront;//pour la ramener au premier plan
end;

procedure TFIndividuSaisieRapide.Label18Click(Sender: TObject);
begin
  MyMessageDlg(rs_Function_Fast_Creating_Infos
    ,mtInformation, [mbOK],self);
end;

procedure TFIndividuSaisieRapide.HintStyleControllerShowHintEx(
  Sender: TObject; var Caption, HintStr: String; var CanShow: Boolean;
  var HintInfo: THintInfo);
var
  l:integer;
begin //HintStyleController local ajouté pour tenter de règler l'anomalie du hint passant derrière la fiche.
  l:=length(HintInfo.HintStr);
  HintInfo.HideTimeout:=Max(2500,l*100);
end;


end.

