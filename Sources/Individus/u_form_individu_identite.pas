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
{           v#    ,Date       ,Author Name     ,Description             }
{ Dernières modifs AL 2009-2011                                         }
{-----------------------------------------------------------------------}
unit u_form_individu_identite;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Mask, Windows,
  ExtJvXPCheckCtrls,
{$ELSE}
  LCLIntf, LCLType, ExtJvXPCheckCtrls,
{$ENDIF}
  U_FormAdapt, u_ancestropictimages, Forms, Menus, Controls,
  u_comp_TYLanguage, DB, IBCustomDataSet,
  IBUpdateSQL, IBQuery, Graphics,
  ExtCtrls, SysUtils, StdCtrls, Classes,
  u_form_individu_edit_event_life, Dialogs,
  DateUtils, u_buttons_appli,
  u_framework_dbcomponents, U_ExtImage,
  U_ExtDBImage, U_ExtDBPictCombo,
  u_extsearchedit, U_ExtMapImageIndex, U_ExtDBImageList, u_buttons_defs,
  u_scrollclones, u_extimagelist, IB, IBSQL, DBCtrls,
  U_OnFormInfoIni, CompSuperForm,
  VirtualTrees, URLLink;

type
  { TFIndividuIdentite }

  TFIndividuIdentite=class(TF_FormAdapt)
    btnAjoutConjoint: TFWAdd;
    btnAjoutEnfant: TFWAdd;
    btnAjoutMere: TFWAdd;
    btnAjoutPere: TFWAdd;
    btnRetirerConjoint: TFWDelete;
    btnRetirerEnfant: TFWDelete;
    cbGarde: TJvXPCheckbox;
    dbeCleFixe: TFWDBEdit;
    DBRSexe: TExtDBPictCombo;
    dr_confidentiel: TDBRadioGroup;
    dsPhoto: TDatasource;
    ds_Prenoms: TDatasource;
    ds_noms: TDatasource;
    edCivilite: TFWDBComboBox;
    edNCHI: TFWDBEdit;
    edNMR: TFWDBEdit;
    edSuffixe: TFWDBEdit;
    edSurnom: TExtSearchDBEdit;
    event_type: TExtImageList;
    event_action: TExtImageList;
    fsbDelMere: TFWDelete;
    fsbDelPere: TFWDelete;
    imgSexe: TExtDBImageList;
    i_source: TExtImage;
    ExtMapSexes: TExtMapImages;
    IAMan: TIAGender;
    IAWoman: TIAGender;
    IBQEve:TIBQuery;
    dsEve:TDataSource;
    IBQEveREF_EVE_CAT: TLongintField;
    IBQEveREF_EVE_LIB_LONG: TIBStringField;
    IBQNoms: TIBQuery;
    Image2: TExtDBImage;
    ImageAstro: TExtImage;
    ImContinuerRecherches: TImage;
    ImIdentiteIncertaine: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabelParamDivers: TLabel;
    lAgePremiereUnion: TLabel;
    lbMariageParents: TLabel;
    lbNeLeDecesLeMere: TLabel;
    lbNeLeDecesLePere: TLabel;
    lbNomMere: TLabel;
    lbNomPere: TLabel;
    lConjoints: TLabel;
    lDeces: TLabel;
    lDernMetier: TLabel;
    lEnfants: TLabel;
    LinkB: TURLLink;
    lNaissance: TLabel;
    lNbreConjoints: TLabel;
    lNbreEnfants: TLabel;
    lSang: TLabel;
    lSosa: TLabel;
    lTitre: TLabel;
    l_cloned: TLabel;
    LinkA: TURLLink;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel18: TPanel;
    Panel2: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    pIdentiteComplete: TPanel;
    p_events: TPanel;
    plabels: TPanel;
    Panel8:TPanel;
    DataSourceIndividu:TDataSource;
    IBQPrenoms:TIBQuery;
    Language:TYLanguage;
    Panel17:TPanel;
    Panel9:TPanel;
    Panel1:TPanel;
    LabelListeEven:TLabel;
    btnNewEvent:TFWAdd;
    btnDeleteEvent:TFWDelete;
    Panel3:TPanel;
    panParents:TPanel;
    panPere:TPanel;
    PanMere: TPanel;
    Panel5:TPanel;
    PopupVideEve:TPopupMenu;
    mtri:TMenuItem;
    N1:TMenuItem;
    mdel:TMenuItem;
    mAjout:TMenuItem;
    IBUEve:TIBUpdateSQL;
    cxSplitter1:TSplitter;
    IBQEveEV_IND_CLEF:TLongintField;
    IBQEveEV_IND_KLE_FICHE:TLongintField;
    IBQEveEV_IND_KLE_DOSSIER:TLongintField;
    IBQEveEV_IND_TYPE:TIBStringField;
    IBQEveEV_IND_DATE_WRITEN:TIBStringField;
    IBQEveEV_IND_DATE_YEAR:TLongintField;
    IBQEveEV_IND_DATE:TDateField;
    IBQEveEV_IND_CP:TIBStringField;
    IBQEveEV_IND_VILLE:TIBStringField;
    IBQEveEV_IND_DEPT:TIBStringField;
    IBQEveEV_IND_PAYS:TIBStringField;
    IBQEveEV_IND_CAUSE:TIBStringField;
    IBQEveEV_IND_SOURCE:TBlobField;
    IBQEveEV_IND_COMMENT:TBlobField;
    IBQEveEV_IND_DESCRIPTION:TIBStringField;
    IBQEveEV_IND_REGION:TIBStringField;
    IBQEveEV_IND_SUBD:TIBStringField;
    IBQEveEV_IND_ACTE:TLongintField;
    IBQEveEV_IND_INSEE:TIBStringField;
    IBQEveEV_IND_HEURE:TTimeField;
    IBQEveEV_IND_ORDRE:TLongintField;
    IBQEveEV_IND_TITRE_EVENT:TIBStringField;
    IBQEveEV_IND_LATITUDE:TFloatField;
    IBQEveEV_IND_LONGITUDE:TFloatField;
    IBQEveEV_IND_CALENDRIER1: TSmallintField;
    IBQEveEV_IND_CALENDRIER2: TSmallintField;
    IBQEve_LONG_EVENT_NAME:TStringField;
    IBQEve_IMG_EVENT:TLongintField;
    IBQEve_DETAIL:TStringField;
    IBQEveQUID_SOURCES:TLongintField;
    IBQEveQUID_NOTES:TLongintField;
    IBQEveQUID_IMAGE:TLongintField;
    IBQEveEV_IND_MEDIA:TLongintField;
    IBQEveEV_IND_DETAILS:TLongintField;
    IBQEve_LIBELLE:TStringField;
    IBQEveEV_IND_DATE_MOIS:TLongintField;
    IBQEveEV_IND_DATE_YEAR_FIN:TLongintField;
    IBQEveEV_IND_DATE_MOIS_FIN:TLongintField;
    IBQEveEV_IND_AGE_EVE:TStringField;
    IBQEveEV_IND_JOUR_SEM:TStringField;
    IBQEveEV_IND_DATE_JOUR: TSmallintField;
    IBQEveEV_IND_DATE_JOUR_FIN: TSmallintField;
    IBQEveEV_IND_TYPE_TOKEN1: TSmallintField;
    IBQEveEV_IND_TYPE_TOKEN2: TSmallintField;
    IBQEveEV_IND_DATECODE: TLongintField;
    IBQEveEV_IND_DATECODE_TOT: TLongintField;
    IBQEveEV_IND_DATECODE_TARD: TLongintField;
    btnNaissance:TFWXPButton;
    btnDeces:TFWXPButton;
    btnProfession:TFWXPButton;
    mRAZTri:TMenuItem;
    pmPhoto:TPopupMenu;
    mDelIdentite:TMenuItem;
    PPhoto: TPanel;
    pmValiderTelQuel:TPopupMenu;
    mTelQuel:TMenuItem;
    mVoirPhoto:TMenuItem;
    N2:TMenuItem;
    GdEve: TExtClonedPanel;
    sDBCBfiliation: TFWDBComboBox;
    sDBENom: TExtSearchDBEdit;
    sDBEPrenom: TExtSearchDBEdit;
    Shape1: TShape;
    Splitter1: TSplitter;
    tvConjEnfants: TVirtualStringTree;
    Visualiserlacte:TMenuItem;
    pmSosa:TPopupMenu;
    Plusdinformations:TMenuItem;
    ReqParente:TIBSQL;
    LiensAncetreCommun:TMenuItem;
    cxImageListZodiac:TImageList;
    pIdentiteReduite:TPanel;
    IBQtv:TIBSQL;
    pmTvConjEnfants:TPopupMenu;
    mOuvrirlafiche:TMenuItem;
    mSupprimerlelien:TMenuItem;
    IBQPatronymes:TIBSQL;
    pmParamDivers:TPopupMenu;
    mIndividuconfidentiel:TMenuItem;
    mSansalertesurdates:TMenuItem;
    mIdentiteIncertaine:TMenuItem;
    mContinuerRecherches:TMenuItem;
    N3:TMenuItem;
    mCopierEvenement:TMenuItem;
    mCollerEvenement:TMenuItem;
    IBQmariageParents:TIBSQL;
    LiensAvecSosa1:TMenuItem;
    mOuvrirEvenement:TMenuItem;
    pmPere:TPopupMenu;
    pmMere:TPopupMenu;
    mSupprimerOrdre:TMenuItem;
    mAjouterConjoint:TMenuItem;
    mAjouterEnfant:TMenuItem;
    mRemplacerConjoint:TMenuItem;
    pmFiltreEven:TPopupMenu;
    mCalculssurlesdates: TMenuItem;
    procedure btnAjoutPereClick(Sender:TObject);
    procedure FormShow(Sender: TObject);
    procedure fsbDelPereClick(Sender:TObject);
    procedure btnAjoutMereClick(Sender:TObject);
    procedure fsbDelMereClick(Sender:TObject);
    procedure btnAjoutEnfantClick(Sender:TObject);
    procedure btnRetirerEnfantClick(Sender:TObject);
    procedure GdEveCloningControl(Sender: TObject);
    procedure GdEveDblClick(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure lbNomPereClick(Sender:TObject);
    procedure lbNomMereClick(Sender:TObject);
    procedure SuperFormResize(Sender:TObject);
    procedure lTitreClick(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure DBRSexeChange(Sender:TObject);
    procedure DataSourceIndividuDataChange(Sender:TObject;Field:TField);
    procedure SuperFormDestroy(Sender:TObject);
    procedure IBQEveNewRecord(DataSet:TDataSet);
    procedure btnRetirerConjointClick(Sender:TObject);
    procedure btnAjoutConjointClick(Sender:TObject);
    procedure tvConjEnfantsDblClick(Sender: TObject);
    procedure tvConjEnfantsGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure tvConjEnfantsGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
    procedure tvConjEnfantsPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure tvEveDblClick(Sender: TObject);
    procedure IBQEveCalcFields(DataSet:TDataSet);
    procedure btnNewEventClick(Sender:TObject);
    procedure btnDeleteEventClick(Sender:TObject);
    procedure pIdentiteCompleteClick(Sender:TObject);
    procedure mtriClick(Sender:TObject);
    procedure lbNomPereMouseEnter(Sender:TObject);
    procedure lbNomPereMouseLeave(Sender:TObject);
    procedure lbNomMereMouseEnter(Sender:TObject);
    procedure lbNomMereMouseLeave(Sender:TObject);
    procedure cbGardeChange(Sender:TObject);
    procedure dbeCleFixeExit(Sender:TObject);
    procedure dxDBGEveKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure btnDecesClick(Sender:TObject);
    procedure mRAZTriClick(Sender:TObject);
    procedure mDelIdentiteClick(Sender:TObject);
    procedure pmPhotoPopup(Sender:TObject);
    procedure pmValiderTelQuelPopup(Sender:TObject);
    procedure mVoirPhotoClick(Sender:TObject);
    procedure VisualiserlacteClick(Sender:TObject);
    procedure PopupVideEvePopup(Sender:TObject);
    procedure lSosaMouseEnter(Sender:TObject);
    procedure lSosaMouseLeave(Sender:TObject);
    procedure PlusdinformationsClick(Sender:TObject);
    procedure LiensAncetreCommunClick(Sender:TObject);
    procedure dxDBGEve_DetailDrawColumnCell(Sender:TObject;
      ACanvas:TCanvas;AViewInfo:Longint;
      var ADone:Boolean);
    procedure sDBENomEnter(Sender:TObject);
    procedure sDBENomExit(Sender:TObject);
//    procedure sDBEPrenomChange(Sender:TObject);
//    procedure sDBEPrenomExit(Sender:TObject);
//    procedure sDBEPrenomEnter(Sender:TObject);
    procedure tvConjEnfantsDrawColumnCell(Sender:TObject;
      ACanvas:TCanvas;AViewInfo:TVTPaintInfo;
      var ADone:Boolean);

    procedure mOuvrirlaficheClick(Sender:TObject);
    procedure mSupprimerlelienClick(Sender:TObject);
    procedure tvConjEnfantsMouseMove(Sender:TObject;Shift:TShiftState;
      X,Y:Integer);
    procedure tvConjEnfantsChange(Sender:TObject);
    procedure pmParamDiversPopup(Sender:TObject);
    procedure mIndividuconfidentielClick(Sender:TObject);
    procedure LabelParamDiversClick(Sender:TObject);
    procedure LabelParamDiversMouseEnter(Sender:TObject);
    procedure LabelParamDiversMouseLeave(Sender:TObject);
    procedure mCopierEvenementClick(Sender:TObject);
    procedure mCollerEvenementClick(Sender:TObject);
    procedure LiensAvecSosa1Click(Sender:TObject);
    procedure mOuvrirEvenementClick(Sender:TObject);
    procedure pmTvConjEnfantsPopup(Sender:TObject);
    procedure pmPerePopup(Sender:TObject);
    procedure pmMerePopup(Sender:TObject);
    procedure tvConjEnfantsMouseDown(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure mSupprimerOrdreClick(Sender:TObject);
    procedure tvConjEnfantsDragOver(Sender,Source:TObject;X,Y:Integer;
      State:TDragState;var Accept:Boolean);
    procedure t(Sender,Source:TObject;X,
      Y:Integer);
    procedure dsEveDataChange(Sender:TObject;Field:TField);
    procedure IBQEveBeforeScrollOrClose(DataSet:TDataSet);
    procedure mRemplacerConjointClick(Sender:TObject);
    procedure lbNeLeDecesLePereMouseEnter(Sender:TObject);
    procedure lbNeLeDecesLePereMouseLeave(Sender:TObject);
    procedure Image2DblClick(Sender:TObject);
    procedure LabelListeEvenMouseEnter(Sender:TObject);
    procedure LabelListeEvenMouseLeave(Sender:TObject);
    procedure LabelListeEvenClick(Sender:TObject);
    procedure LabelListeEvenMouseMove(Sender:TObject;Shift:TShiftState;
      X,Y:Integer);
    procedure LabelListeEvenContextPopup(Sender:TObject;MousePos:TPoint;
      var Handled:Boolean);
    procedure lSosaClick(Sender:TObject);
    procedure panPereDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure panPereDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PanMereDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PanMereDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure mCalculssurlesdatesClick(Sender: TObject);
    procedure edCiviliteExit(Sender: TObject);
    procedure sDBCBfiliationExit(Sender: TObject);
    procedure edSuffixeExit(Sender: TObject);
    procedure edSurnomExit(Sender: TObject);
  private
    CurNodeC:PVirtualNode;
    CurNodeE:PVirtualNode;
    fFill:boolean;
    NomEnter,PrenomEnter:string;
    NbrConjoints,NbrEnfants:integer;
    NoeudSurvolTv:PVirtualNode;
    ColSurvolTv:integer;
    GFormIndividu : TSuperForm;
    XSouris,YSouris:integer;

    procedure cbGardeLabel;
    procedure SupprimeParent(const Enfant,Parent:Integer);
    procedure DefiniParents(const Enfant,Pere,Mere:Integer);
    procedure doRefreshZodiaque;
//    procedure InitListePrenoms;
    procedure AfficheSosa;
    procedure CreatFichEvInd(const LibCourt,LibLong:string);
    procedure AfficheMariageParents;
    procedure SynchroHistoire;
    procedure SuppressionFiltreEven(Sender:TObject);
    procedure ApplicationFiltreEven(Sender:TObject);
    function AutoriseSupprimeParents(Enfant:integer):Boolean;//autorise l'ajout
      //ou le remplacement des parents de Enfant en supprimant les précédents parents si nécessaire
    procedure AjoutePere(const cle:integer;const NomPrenom:string);
    procedure AjouteMere(const cle:integer;const NomPrenom:string);
    procedure RefreshTitle_Naissance;
    procedure AfficheDetailsEvent;
  public
    sAGE_EVE,
    sJOUR_SEM : String;
    bOpen:boolean;
    idPhoto:integer;
    bIdentiteVisible:boolean;
    aFIndividuEditEventLife:TFIndividuEditEventLife;
    clef_ev_histoire:integer;

    procedure RefreshPhoto;
    procedure doInitialize;
    function doOpenQuerys:boolean;
    procedure SetColorFromContext;
    procedure RefreshTitle;
    procedure doCompteConjoints;
    procedure doCompteEnfants;
    procedure doRefreshConSang;
    procedure doGoto(iNumLigne:integer);
//    procedure AjouteNomAliste(UnNom:string);
    procedure InitCivilites;
    procedure InitFiliations;
    procedure RempliConjEnfants;
    procedure RefreshTitle_Nom;
  end;
implementation
uses  u_dm,
      u_form_individu,
      fonctions_dialogs,
      u_form_individu_repertoire,
      u_common_functions,u_common_ancestro,
      u_genealogy_context,u_form_Evements_Ajout,u_common_const,
      u_form_individu_Affecte_Enfant,
      u_gedcom_const,lazutf8classes,
      fonctions_init, u_common_treeind,
      u_common_ancestro_functions,
      fonctions_string,
      u_form_TriEvent,u_Form_Main,Math;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFIndividuIdentite }

procedure TFIndividuIdentite.SuperFormCreate(Sender:TObject);
begin
  GFormIndividu:=owner as TSuperForm;
  OnRefreshControls:=SuperFormRefreshControls;
  tvConjEnfants.NodeDataSize := Sizeof(TNodeIndividu)+1;
//  tvEve        .NodeDataSize := Sizeof(TTVNodeEve)+1;
  Color:=gci_context.ColorLight;
  pIdentiteComplete.Color:=gci_context.ColorMedium;
  btnNewEvent.Color:=gci_context.ColorLight;
  btnNewEvent.ColorFrameFocus:=gci_context.ColorLight;
  btnDeleteEvent.Color:=gci_context.ColorLight;
  btnDeleteEvent.ColorFrameFocus:=gci_context.ColorLight;
  btnNaissance.Color:=gci_context.ColorLight;
  btnNaissance.ColorFrameFocus:=gci_context.ColorLight;
  btnDeces.Color:=gci_context.ColorLight;
  btnDeces.ColorFrameFocus:=gci_context.ColorLight;
  btnProfession.Color:=gci_context.ColorLight;
  btnProfession.ColorFrameFocus:=gci_context.ColorLight;
  btnAjoutConjoint.Color:=gci_context.ColorLight;
  btnAjoutConjoint.ColorFrameFocus:=gci_context.ColorLight;
  btnRetirerConjoint.Color:=gci_context.ColorLight;
  btnRetirerConjoint.ColorFrameFocus:=gci_context.ColorLight;
  btnAjoutEnfant.Color:=gci_context.ColorLight;
  btnAjoutEnfant.ColorFrameFocus:=gci_context.ColorLight;
  btnRetirerEnfant.Color:=gci_context.ColorLight;
  btnRetirerEnfant.ColorFrameFocus:=gci_context.ColorLight;
  btnAjoutPere.Color:=gci_context.ColorLight;
  btnAjoutPere.ColorFrameFocus:=gci_context.ColorLight;
  fsbDelPere.Color:=gci_context.ColorLight;
  fsbDelPere.ColorFrameFocus:=gci_context.ColorLight;
  btnAjoutMere.Color:=gci_context.ColorLight;
  btnAjoutMere.ColorFrameFocus:=gci_context.ColorLight;
  fsbDelMere.Color:=gci_context.ColorLight;
  fsbDelMere.ColorFrameFocus:=gci_context.ColorLight;

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  sDBENom.ModeFormat:=gci_context.ModeSaisieNom;
  sDBENom.Hint:=rs_Hint_Press_first_key_of_surname_to_be_helped;//Tapez la première lettre du nom pour obtenir de l'assistance.
  sDBEPrenom.ModeFormat:=gci_context.ModeSaisiePrenom;
  sDBEPrenom.Hint:=rs_Hint_Press_first_key_of_name_to_be_helped;//Tapez la première lettre du prénom pour obtenir de l'assistance.
  lSang.Hint:=rs_Caption_Person_s_consanguinity_is_equal_to_parents_parenty;
  LabelParamDivers.Hint:=rs_Caption_Setting_person_as_confidential_permits_to_hide_himherself;
  panPere.Hint:=rs_Caption_You_can_add_the_father_by_drag_drop;
  panMere.Hint:=rs_Caption_You_can_add_the_mother_by_drag_drop;
  CurNodeC:=nil;
  CurNodeE:=nil;
  fFill:=false;
  Panel8.Height:=120;
  pIdentiteComplete.Left:=5;
  pIdentiteComplete.Top:=8;
  pIdentiteReduite.Left:=5;
  pIdentiteReduite.Top:=8;
  cbGarde.Checked:=not gci_context.Garde;
  cbGardeLabel;
  pIdentiteComplete.Hide;
  SetColorFromContext;
  PPhoto.Visible:=gci_context.Photos;
  //initialisation de listes
  InitCivilites;
  InitFiliations;
  LabelParamDivers.Cursor:=_CURPOPUP;
  lSosa.Cursor:=_CURPOPUP;
  Image2.Cursor:=_CURPOPUP;
  lbNomPere.Cursor:=_CURPOPUP;
  lbNomMere.Cursor:=_CURPOPUP;
  GdEve.Cursor:=_CURPOPUP;//ne marche pas?
  with GFormIndividu as TFIndividu do
   Begin
    DataSourceIndividu.DataSet:=QueryIndividu;
    dsPhoto.DataSet           :=IBPhoto;
   end;
  aFIndividuEditEventLife:=TFIndividuEditEventLife.create(self);
end;

procedure TFIndividuIdentite.doInitialize;
begin
  tvConjEnfants.Clear;
  IBQEve.Close;
  IBQPrenoms.Close;
  lbNomPere.Caption:='';
  lbNeLeDecesLePere.Caption:='';
  lbNomMere.Caption:='';
  lbNeLeDecesLeMere.Caption:='';
  NoeudSurvolTv:=nil;
  tvConjEnfants.Hint:='';
  tvConjEnfants.ShowHint:=false;
end;

function TFIndividuIdentite.doOpenQuerys:boolean;
begin
  bOpen:=False;
  try
    RefreshTitle;
    AfficheMariageParents;
    if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=1 then
      lConjoints.Font.Color:=gci_context.ColorFemme
    else
      lConjoints.Font.Color:=gci_context.ColorHomme;

    IBQNoms.Params[0].AsInteger:=dm.NumDossier;

    pIdentiteReduite.Visible:=cbGarde.Checked;
    pIdentiteComplete.Visible:=not cbGarde.Checked;

    try
      SuppressionFiltreEven(self);
      IBQEve.Close;
      IBQEve.Params[0].AsString:=gci_context.Langue;
      IBQEve.Params[1].AsInteger:=TFIndividu(GFormIndividu).CleFiche;
      try
        IBQEve.Open;
      except
        on E:Exception do
          MyMessageDlg(rs_Error_while_reading_events+_CRLF
            +E.Message,mtError, [mbOK],FMain);
      end;
    finally
      p_FillClonesEvent ( IBQEve, GdEve, l_cloned, LinkA, LinkB, event_action, event_type, i_source, IBQEve_Libelle, 'ind' );
    end;
    if IBQEve.IsEmpty then
      aFIndividuEditEventLife.Hide;
    RefreshPhoto;
    RempliConjEnfants;
    Result:=True;
  finally
    bOpen:=True;
  end;
end;
procedure TFIndividuIdentite.RefreshPhoto;
begin
  if gci_context.Photos then
  with TFIndividu(GFormIndividu).QueryIndividu do
  if Active Then
    begin
      with TFIndividu(GFormIndividu),ibphoto do
        try
          Close;
          ParamByName('i_clef').Value:=CleFiche;
          Open;

        finally
        end;
      idPhoto:=FieldByName('mp_clef').AsInteger;
      bIdentiteVisible:=Assigned (Image2.Field) and not Image2.Field.IsNull;
      if not bIdentiteVisible then
        if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=2 then
          Image2.Picture.Assign(IAWoman.Picture)
        else
          Image2.Picture.Assign(IAMan.Picture);

      Image2.ShowHint:=not bIdentiteVisible;
      PPhoto.Visible:=True;
    end
    else
    begin
      PPhoto.Visible:=False;
      bIdentiteVisible:=False;
      Image2.ShowHint:=False;
    end;
end;

procedure TFIndividuIdentite.AjoutePere(const cle:integer;const NomPrenom:string);
var
  NomIndi1:string;
  i:integer;
  UnNoeud:PVirtualNode;
begin
  with TFIndividu(GFormIndividu),QueryIndividu do
  if Active Then
   Begin
    NomIndi1:=GetNomIndividu;
    if TestAscDesc(CleFiche
      ,cle
      ,NomIndi1
      ,NomPrenom
      ,true,false) then //asc possible en cas d'inceste
      exit;
    if FieldByName('CLE_MERE').AsInteger>0 then
    begin//vérifier si le père n'est pas dans l'ascendance ou la descendance de la mère
      if TestAscDesc(FieldByName('CLE_MERE').AsInteger
        ,cle
        ,lbNomMere.Caption
        ,NomPrenom
        ,true,true) then //asc et desc possible en cas d'inceste
        exit;
    end;
    if FieldByName('SEXE').AsInteger=2 then
    begin//vérifier si l'individu sélectionné n'est pas un conjoint
      UnNoeud:=nil;
      TreeFindNode( tvConjEnfants, tvConjEnfants.RootNode, cle,UnNoeud);
      if ( UnNoeud <> nil )
      and (MyMessageDlg(NomPrenom+_CRLF
              +rs_he_is_joint_with+NomIndi1+'.'+_CRLF+_CRLF
              +rs_Confirm_father_s_link
              ,mtWarning, [mbYes,mbNo],FMain)<>mrYes) then
              exit;
    end;
    if (not(State in [dsEdit,dsInsert])) then
      Edit;
    FieldByName('CLE_PERE').AsInteger:=cle;
    DefiniParents(CleFiche
      ,cle
      ,FieldByName('CLE_MERE').AsInteger);
   end;
  AfficheMariageParents;
  doRefreshControls;
end;

procedure TFIndividuIdentite.btnAjoutPereClick(Sender:TObject);
var
  aFIndividuRepertoire:TFIndividuRepertoire;
  aLettre:string;
begin
  //Création de la boite de recherche d'un individu par le prénom
  TFIndividu(GFormIndividu).PostIndividu;
  aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
  try
    CentreLaFiche(aFIndividuRepertoire,FMain);
    aFIndividuRepertoire.NomIndi:=TFIndividu(GFormIndividu).QueryIndividuNOM.AsString;
    aLettre:=copy(fs_FormatText(aFIndividuRepertoire.NomIndi,mftUpper,True),1,1);
    aFIndividuRepertoire.InitIndividuPrenom(aLettre,'',1,0,False,True);
    aFIndividuRepertoire.Caption:=rs_caption_Select_Father;
    if aFIndividuRepertoire.ShowModal=mrOk then
    begin
      if aFIndividuRepertoire.Creation then //pour permettre d'annuler l'individu créé
      begin
        TFIndividu(GFormIndividu).doBouton(true);
      end;
      if aFIndividuRepertoire.SexeIndividuSelected=2 then
        MyMessageDlg(rs_Error_Father_cannot_be_a_woman,mtError, [mbOK],FMain)
      else if aFIndividuRepertoire.ClefIndividuSelected=TFIndividu(GFormIndividu).Clefiche then
        MyMessageDlg(rs_Error_person_cannot_be_himself_and_the_father,mtError, [mbOK],FMain)
      else
      begin
        AjoutePere(aFIndividuRepertoire.ClefIndividuSelected,aFIndividuRepertoire.NomPrenomIndividuSelected);
      end;
    end;
  finally
    FreeAndNil(aFIndividuRepertoire);
  end;
end;

procedure TFIndividuIdentite.FormShow(Sender: TObject);
begin
  f_GetMemIniFile;
  cxSplitter1.SetSplitterPosition( FIniFile.ReadInteger ( Name,cxSplitter1.Name +CST_ONFORMINI_DOT + CST_ONFORMINI_LEFT , cxSplitter1.Left));
end;

procedure TFIndividuIdentite.fsbDelPereClick(Sender:TObject);
begin
  if MyMessageDlg(fs_RemplaceMsg(rs_Confirm_is_not_the_father_of,[lbNomPere.Caption])
   +_CRLF+ lTitre.Caption+'?',
    mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
  begin
    if (not(TFIndividu(GFormIndividu).QueryIndividu.State in [dsEdit,dsInsert])) then
      TFIndividu(GFormIndividu).QueryIndividu.Edit;
    SupprimeParent(TFIndividu(GFormIndividu).CleFiche,1);
    TFIndividu(GFormIndividu).QueryIndividuCLE_PERE.Clear;
    AfficheMariageParents;
    doRefreshControls;
  end;
end;

procedure TFIndividuIdentite.AjouteMere(const cle:integer;const NomPrenom:string);
var
  NomIndi1:string;
  i:integer;
  UnNoeud:PVirtualNode;
begin
  with TFIndividu(GFormIndividu), QueryIndividu do
   Begin
    NomIndi1:=GetNomIndividu;
    if TestAscDesc(CleFiche
      ,cle
      ,NomIndi1
      ,NomPrenom
      ,true,false) then //asc possible en cas d'inceste
      exit;
    if FieldByName('CLE_PERE').AsInteger>0 then
    begin//vérifier si la mère n'est pas dans l'ascendance ou la descendance du père
      if TestAscDesc(FieldByName('CLE_PERE').AsInteger
        ,cle
        ,lbNomPere.Caption
        ,NomPrenom
        ,true,true) then //asc et desc possible en cas d'inceste
        exit;
    end;
    if FieldByName('SEXE').AsInteger=1 then
    begin//vérifier si l'individu sélectionné n'est pas un conjoint
      UnNoeud:=nil;
      TreeFindNode( tvConjEnfants, tvConjEnfants.RootNode, cle,UnNoeud);
      if ( UnNoeud <> nil )
      and ( MyMessageDlg(NomPrenom+_CRLF
              +rs_she_is_joint_with+NomIndi1+_CRLF+_CRLF
              +rs_Confirm_she_is_the_mother_too
              ,mtWarning, [mbYes,mbNo],FMain)<>mrYes) then
              exit;
    end;
    if (not(State in [dsEdit,dsInsert])) then
      Edit;
    FieldByName('CLE_MERE').AsInteger:=cle;
    DefiniParents(CleFiche
      ,FieldByName('CLE_PERE').AsInteger
      ,cle);
   end;
  AfficheMariageParents;
  doRefreshControls;
end;

procedure TFIndividuIdentite.btnAjoutMereClick(Sender:TObject);
var
  aFIndividuRepertoire:TFIndividuRepertoire;
  aLettre:string;
begin
  //Création de la fiche de recherche d'un individu par le prénom
  TFIndividu(GFormIndividu).PostIndividu;
  aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
  try
    CentreLaFiche(aFIndividuRepertoire,FMain);
    aFIndividuRepertoire.NomIndi:=TFIndividu(GFormIndividu).QueryIndividuNOM.AsString;
    aLettre:=copy(fs_FormatText(aFIndividuRepertoire.NomIndi,mftUpper,True),1,1);
    aFIndividuRepertoire.InitIndividuPrenom(aLettre,'',2,0,False,True);
    aFIndividuRepertoire.Caption:=rs_Caption_Select_Mother;
    if aFIndividuRepertoire.ShowModal=mrOk then
    begin
      if aFIndividuRepertoire.Creation then //pour permettre d'annuler l'individu créé
      begin
        TFIndividu(GFormIndividu).doBouton(true);
      end;
      if aFIndividuRepertoire.SexeIndividuSelected=1 then
        MyMessageDlg(rs_Error_Mother_cannot_be_a_woman,mtError, [mbOK],FMain)
      else if aFIndividuRepertoire.ClefIndividuSelected=TFIndividu(GFormIndividu).Clefiche then
        MyMessageDlg(rs_Error_person_cannot_be_herself_and_the_mother,mtError, [mbOK],FMain)
      else
      begin
        AjouteMere(aFIndividuRepertoire.ClefIndividuSelected,aFIndividuRepertoire.NomPrenomIndividuSelected);
      end;
    end;
  finally
    FreeAndNil(aFIndividuRepertoire);
  end;
end;

procedure TFIndividuIdentite.fsbDelMereClick(Sender:TObject);
begin
  if MyMessageDlg(fs_RemplaceMsg(rs_Confirm_is_not_the_mother_of,[lbNomMere.Caption])+_CRLF+
    lTitre.Caption+'?',
    mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
  begin
    if not(TFIndividu(GFormIndividu).QueryIndividu.State in [dsEdit,dsInsert]) then
      TFIndividu(GFormIndividu).QueryIndividu.Edit;
    SupprimeParent(TFIndividu(GFormIndividu).CleFiche,2);
    TFIndividu(GFormIndividu).QueryIndividuCLE_MERE.Clear;
    AfficheMariageParents;
    doRefreshControls;
  end;
end;

function TFIndividuIdentite.AutoriseSupprimeParents(Enfant:integer):Boolean;//autorise l'ajout
var
  q:TIBSQL;
  unMessage:string;
begin
  q:=TIBSQL.Create(Self);
  try
    q.DataBase:=dm.ibd_BASE;
    q.Transaction:=dm.IBT_BASE;
    q.SQL.Text:='select p.nom||coalesce('', ''||p.prenom,'''')'
      +',m.nom||coalesce('', ''||m.prenom,'''')'
      +',i.nom||coalesce('', ''||i.prenom,'''')'
      +' from individu i'
      +' left join individu p on p.cle_fiche=i.cle_pere'
      +' left join individu m on m.cle_fiche=i.cle_mere'
      +' where i.cle_fiche=:cle_fiche';
    q.Params[0].AsInteger:=Enfant;
    q.ExecQuery;
    if q.Fields[0].IsNull and q.Fields[1].IsNull then
    begin
      Result:=True;
    end
    else if q.Eof then
    begin
      Result:=False;
    end
    else
    begin
      unMessage:=q.Fields[2].AsString+rs_is_always_parent_with;
      if (q.Fields[0].AsString>'')and(q.Fields[1].AsString>'') then
        unMessage:=fs_RemplaceMsg(rs_plural,[unMessage])+_CRLF
      else
        unMessage:=unMessage+_CRLF;
      if q.Fields[0].AsString>'' then
      begin
        unMessage:=unMessage+q.Fields[0].AsString;
        if q.Fields[1].AsString>'' then
          unMessage:= fs_RemplaceMsg(rs_and, [unMessage,_CRLF+q.Fields[1].AsString]);
      end
      else
      begin
        if q.Fields[1].AsString>'' then
          unMessage:=unMessage+q.Fields[1].AsString;
      end;
      unMessage:=unMessage+_CRLF;
      if (q.Fields[0].AsString>'')and(q.Fields[1].AsString>'') then
        unMessage:=unMessage+rs_Confirm_links_will_be_deleted
      else
        unMessage:=unMessage+rs_Confirm_link_will_be_deleted;

      if MyMessageDlg(unMessage+_CRLF+_CRLF+rs_Confirm_your_selection
        ,mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
      begin
        SupprimeParent(Enfant,0);
        TFIndividu(GFormIndividu).doBouton(true);//pour pouvoir tout annuler
        Result:=True;
      end
      else
        Result:=false;
    end;
  finally
    q.Free;
  end;
end;

procedure TFIndividuIdentite.btnAjoutEnfantClick(Sender:TObject);
var
  aFIndividuRepertoire:TFIndividuRepertoire;
  aFAffecte_Enfant:TFAffecte_Enfant;
  aLettre,sPere,sMere,NomIndi1:string;
  i_Conjoint,pere,mere,NbConjoints:integer;
begin
  if btnAjoutEnfant.Visible and btnAjoutEnfant.Enabled then
  begin
    if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=0 then
    begin
      MyMessageDlg(rs_Error_Unknown_sexe_please_set_it,mtError, [mbOK],FMain);
      exit;
    end;

    TFIndividu(GFormIndividu).PostIndividu;//au cas où le nom de l'individu aurait été changé ou nouveau
    aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
    try
      CentreLaFiche(aFIndividuRepertoire,FMain);
      if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=1 then
        aFIndividuRepertoire.NomIndi:=TFIndividu(GFormIndividu).QueryIndividuNOM.AsString
      else if tvConjEnfants.FocusedNode<>nil then
      with tvConjEnfants do
      begin
        if FocusedNode = nil Then
         FocusedNode:=RootNode.FirstChild;
        if FocusedNode^.Parent=RootNode
         then aFIndividuRepertoire.NomIndi:=PNodeIndividu(GetNodeData(FocusedNode))^.fNom
         else aFIndividuRepertoire.NomIndi:=PNodeIndividu(GetNodeData(FocusedNode.Parent))^.fNom;
        if aFIndividuRepertoire.NomIndi='?' then
          aFIndividuRepertoire.NomIndi:=TFIndividu(GFormIndividu).QueryIndividuNOM.AsString;
      end
      else
        aFIndividuRepertoire.NomIndi:=TFIndividu(GFormIndividu).QueryIndividuNOM.AsString;

      aLettre:=copy(fs_FormatText(aFIndividuRepertoire.NomIndi,mftUpper,True),1,1);

      aFIndividuRepertoire.InitIndividuPrenom(aLettre,'',0,0,False,True);
      aFIndividuRepertoire.Caption:=rs_caption_Select_Child;
      if aFIndividuRepertoire.ShowModal=mrOk then
      begin
        if aFIndividuRepertoire.Creation then //pour permettre d'annuler l'individu créé
        begin
          TFIndividu(GFormIndividu).doBouton(true);
        end;
        if (aFIndividuRepertoire.ClefIndividuSelected>0) then
        begin
          if aFIndividuRepertoire.ClefIndividuSelected=TFIndividu(GFormIndividu).Clefiche then
          begin
            MyMessageDlg(rs_Error_person_cannot_be_itself_and_the_child,mtError, [mbOK],FMain);
            exit;
          end;
          if ((aFIndividuRepertoire.IBQListePreNomMERE_CLE_FICHE.AsInteger>0)or
            (aFIndividuRepertoire.IBQListePreNomPERE_CLE_FICHE.AsInteger>0))and not aFIndividuRepertoire.Creation then
          begin
            if not AutoriseSupprimeParents(aFIndividuRepertoire.ClefIndividuSelected) then
              exit;
          end;

          NomIndi1:=TFIndividu(GFormIndividu).GetNomIndividu;
          if TFIndividu(GFormIndividu).TestAscDesc(TFIndividu(GFormIndividu).CleFiche
            ,aFIndividuRepertoire.ClefIndividuSelected
            ,NomIndi1
            ,aFIndividuRepertoire.NomPrenomIndividuSelected
            ,false,false) then //les 2 cas impossibles puisque asc impossible et filiation supprimée si elle existait
            exit;

          //Affection de l'enfant aux parents
          with tvConjEnfants do
          if FocusedNode<>nil then
          begin
            if FocusedNode^.Parent=RootNode then
              i_conjoint:=PNodeIndividu(GetNodeData(FocusedNode))^.fCleFiche
            else
              i_conjoint:=PNodeIndividu(GetNodeData(FocusedNode^.Parent))^.fCleFiche;
          end
          else
            i_conjoint:=0;

          aFAffecte_Enfant:=TFAffecte_Enfant.Create(Self);
          try
            CentreLaFiche(aFAffecte_Enfant,FMain);
            aFAffecte_Enfant.DoInit(TFIndividu(GFormIndividu).CleFiche
              ,i_conjoint
              ,aFIndividuRepertoire.ClefIndividuSelected
              ,TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger
              ,AssembleString([TFIndividu(GFormIndividu).QueryIndividuNOM.AsString
              ,TFIndividu(GFormIndividu).QueryIndividuPRENOM.AsString]));
            if aFAffecte_Enfant.ShowModal=mrOk then
            begin
              if aFAffecte_Enfant.creation then //pour permettre de l'annuler.
              begin
                TFIndividu(GFormIndividu).doBouton(true);
              end;
              pere:=aFAffecte_Enfant.ClefPere;
              mere:=aFAffecte_Enfant.ClefMere;
              sPere:=aFAffecte_Enfant.lPere.Caption;
              sMere:=aFAffecte_Enfant.lMere.Caption;
              if TFIndividu(GFormIndividu).TestAscDesc(mere
                ,pere
                ,sMere
                ,sPere
                ,true,true) then //possible si inceste
                exit;
              //vérifier que l'enfant n'est pas dans l'asc/desc du conjoint
              if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=1 then
              begin
                if mere>0 then
                  if TFIndividu(GFormIndividu).TestAscDesc(mere
                    ,aFIndividuRepertoire.ClefIndividuSelected
                    ,sMere
                    ,aFIndividuRepertoire.NomPrenomIndividuSelected
                    ,false,false) then //les 2 cas impossibles puisque asc impossible et filiation supprimée si elle existait
                    exit;
              end
              else
              begin
                if pere>0 then
                  if TFIndividu(GFormIndividu).TestAscDesc(pere
                    ,aFIndividuRepertoire.ClefIndividuSelected
                    ,sPere
                    ,aFIndividuRepertoire.NomPrenomIndividuSelected
                    ,false,false) then //les 2 cas impossibles puisque asc impossible et filiation supprimée si elle existait
                    exit;
              end;
              DefiniParents(aFIndividuRepertoire.ClefIndividuSelected,pere,mere);
              TFIndividu(GFormIndividu).doBouton(True);
              TFIndividu(GFormIndividu).TestCoherenceDates;
              NbConjoints:=NbrConjoints;
              RempliConjEnfants;//on met à jour le tv
              if NbrConjoints<>NbConjoints then
                if TFIndividu(GFormIndividu).OngletSesConjointsIsLoaded then
                  TFIndividu(GFormIndividu).aFIndividuUnion.doOpenQuerys(true);
              TFIndividu(GFormIndividu).DoRefreshControls;//remis par André
                  //car doOpenFiche(dm.individu_clef) réinitialise toutes les requêtes
                  //perdant toutes les autres modifications en cours non validées
                  //TFIndividu(GFormIndividu).doOpenFiche(dm.individu_clef);
            end
            else
            begin
              if aFAffecte_Enfant.creation then //pour permettre de l'annuler.
              begin
                TFIndividu(GFormIndividu).doBouton(true);
              end;
            end;
          finally
            FreeAndNil(aFAffecte_Enfant);
          end;
        end;
      end
      else
      begin
        if aFIndividuRepertoire.Creation then //pour permettre d'annuler l'individu créé.
        begin
          TFIndividu(GFormIndividu).doBouton(true);
        end;
      end;
    finally
      FreeAndNil(aFIndividuRepertoire);
    end;
  end;
end;

procedure TFIndividuIdentite.btnRetirerEnfantClick(Sender:TObject);
var
  ClefEnfant:integer;
begin
  with tvConjEnfants do
  if (FocusedNode<>nil)
    and(GetNodeData(FocusedNode)<>nil)
    and(FocusedNode^.Parent<>nil) then
    with PNodeIndividu(GetNodeData(FocusedNode))^ do
  begin
    ClefEnfant:=fCleFiche;
    if MyMessageDlg(rs_Confirm_deleting_this_child+_CRLF+
      fNomComplet+' '+
      fDateNaissanceDeces+'?',
      mtWarning, [mbYes,mbNo],FMain)=mrYes then
    begin
      if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=1 then
        SupprimeParent(ClefEnfant,1)
      else
        SupprimeParent(ClefEnfant,2);
      TFIndividu(GFormIndividu).doBouton(True);
      TFIndividu(GFormIndividu).TestCoherenceDates;
      TFIndividu(GFormIndividu).DoRefreshControls;
      RempliConjEnfants;
    end;
    doRefreshControls;
  end;
end;

procedure TFIndividuIdentite.GdEveCloningControl(Sender: TObject);
begin
 ( sender as TControl ).OnClick:=GdEveDblClick;
end;

procedure TFIndividuIdentite.GdEveDblClick(Sender: TObject);
begin
  IBQEve.RecNo:= ( Sender as TControl ).Tag;
  AfficheDetailsEvent;
end;

procedure TFIndividuIdentite.Panel2Resize(Sender: TObject);
begin
  lSang.Left:=Panel2.ClientWidth-lSang.Width;
end;


procedure TFIndividuIdentite.SuperFormRefreshControls(Sender:TObject);
var
  SavePlace:TBookmark;
  CouleurTitre:TColor;
begin
  //Shape1.Width:=plabels.Width-2;
  btnNewEvent.enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)and(TFIndividu(GFormIndividu).DialogMode=false);
  btnDeleteEvent.enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)
    and IBQEve.Active
    and not IBQEve.IsEmpty
    and(TFIndividu(GFormIndividu).DialogMode=false);
  if (TFIndividu(GFormIndividu).DialogMode=True) then
    pIdentiteComplete.Cursor:=crArrow;
  btnAjoutPere.enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)and
    (TFIndividu(GFormIndividu).QueryIndividuCLE_PERE.IsNull=true)and
    (TFIndividu(GFormIndividu).DialogMode=false);
  panPere.ShowHint:=btnAjoutPere.Enabled and btnAjoutPere.Visible;
  fsbDelPere.enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)
    and(TFIndividu(GFormIndividu).QueryIndividu.Active)
    and(TFIndividu(GFormIndividu).QueryIndividuCLE_PERE.IsNull=false)
    and(TFIndividu(GFormIndividu).DialogMode=false);
  btnAjoutMere.enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)and
    (TFIndividu(GFormIndividu).QueryIndividuCLE_MERE.IsNull=true)and
    (TFIndividu(GFormIndividu).DialogMode=false);
  panMere.ShowHint:=btnAjoutMere.Enabled and btnAjoutMere.Visible;
  fsbDelMere.enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)
    and(TFIndividu(GFormIndividu).QueryIndividu.Active)
    and(TFIndividu(GFormIndividu).QueryIndividuCLE_MERE.IsNull=false)
    and(TFIndividu(GFormIndividu).DialogMode=false);
  //Conjoints
  btnAjoutConjoint.Enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)
    and(TFIndividu(GFormIndividu).DialogMode=false);
  //Enfants
  btnAjoutEnfant.Enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)
    and(TFIndividu(GFormIndividu).DialogMode=false);
  dsEve.AutoEdit:=(TFIndividu(GFormIndividu).DialogMode=false);
  doRefreshConSang;
  doRefreshZodiaque;
  doCompteConjoints;
  doCompteEnfants;

  case TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger of
    1:
      begin
        CouleurTitre:=gci_context.ColorHomme;
        sDBENom.Font.Color:=gci_context.ColorHomme;
      end;
    2:
      begin
        CouleurTitre:=gci_context.ColorFemme;
        sDBENom.Font.Color:=gci_context.ColorFemme;
      end
    else
      begin
        CouleurTitre:=clWindowText;
        sDBENom.Font.Color:=clWindowText;
      end;
  end;
  if TFIndividu(GFormIndividu).QueryIndividuNUM_SOSA.AsFloat>0 then
    CouleurTitre:=_COLOR_SOSA;
  lTitre.Font.Color:=CouleurTitre;
  sDBEPrenom.Font.Color:=sDBENom.Font.Color;

  if TFIndividu(GFormIndividu).QueryIndividuIND_CONFIDENTIEL.AsInteger>0 then
    LabelParamDivers.Font.Color:=clRed
  else
    LabelParamDivers.Font.Color:=clWindowText;
  if (TFIndividu(GFormIndividu).QueryIndividuIND_CONFIDENTIEL.AsInteger and _i_IndiConf)=_i_IndiConf then
    lTitre.Font.Style:=lTitre.Font.Style+ [fsStrikeOut]
  else
    lTitre.Font.Style:=lTitre.Font.Style- [fsStrikeOut];
  ImIdentiteIncertaine.Visible:=
    (TFIndividu(GFormIndividu).QueryIndividuIND_CONFIDENTIEL.AsInteger and _i_IdentiteIncertaine)=_i_IdentiteIncertaine;
  ImContinuerRecherches.Visible:=
    (TFIndividu(GFormIndividu).QueryIndividuIND_CONFIDENTIEL.AsInteger and _i_ContinuerRecherches)=_i_ContinuerRecherches;

  if (IBQEve.Active)and(IBQEve.IsEmpty) then
  begin
    btnNaissance.Enabled:=True;
    btnDeces.Enabled:=True;
  end
  else if IBQEve.Active and not IBQEve.IsEmpty and(IBQEve.State=dsBrowse) then
  begin 
    GdEve.Hint:=rs_Hint_Click_twice_or_click_on_icon_to_see_details;
    btnNaissance.Enabled:=True;
    btnDeces.Enabled:=True;
    SavePlace:=IBQEve.GetBookmark;
    IBQEve.DisableControls;
    IBQEve.First;
    while not IBQEve.Eof do
    begin
      if IBQEveEV_IND_TYPE.AsString='BIRT' then
        btnNaissance.Enabled:=False;
      if IBQEveEV_IND_TYPE.AsString='DEAT' then
        btnDeces.Enabled:=False;
      if (not btnNaissance.Enabled)and(not btnDeces.Enabled) then
        Break;
      IBQEve.Next;
    end;
    IBQEve.GotoBookmark(SavePlace);
    IBQEve.FreeBookmark(SavePlace);
    IBQEve.EnableControls;
  end;
end;

procedure TFIndividuIdentite.lbNomPereClick(Sender:TObject);
begin
  if TFIndividu(GFormIndividu).QueryIndividuCLE_PERE.AsInteger>0 then
  begin
    dm.individu_clef:=TFIndividu(GFormIndividu).QueryIndividuCLE_PERE.AsInteger;
    DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
  end;
end;

procedure TFIndividuIdentite.lbNomMereClick(Sender:TObject);
begin
  if TFIndividu(GFormIndividu).QueryIndividuCLE_MERE.AsInteger>0 then
  begin
    dm.individu_clef:=TFIndividu(GFormIndividu).QueryIndividuCLE_MERE.AsInteger;
    DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
  end;
end;

procedure TFIndividuIdentite.SuperFormResize(Sender:TObject);
begin
  panPere.Width:=width div 2;
end;

procedure TFIndividuIdentite.RefreshTitle_Nom;
var
  s,sNom:string;
begin
  with TFIndividu(GFormIndividu).QueryIndividu do
  if Active Then
   Begin
    sNom:=FieldByName('NOM').AsString;
    //les patronymes associés
    if gci_context.AfficherPatAssoc then
    begin
      IBQPatronymes.ParamByName('ID_INDI').AsInteger:=FieldByName('CLE_FICHE').AsInteger;
      IBQPatronymes.ParamByName('NOM_INDI').AsString:=FieldByName('NOM').AsString;
      IBQPatronymes.ParamByName('DOSSIER').AsInteger:=dm.NumDossier;
      IBQPatronymes.ExecQuery;
      if not IBQPatronymes.Eof then
      begin
        sNom:=sNom+' ['+IBQPatronymes.Fields[0].AsString;
        IBQPatronymes.Next;
        while not IBQPatronymes.Eof do
        begin
          sNom:=sNom+', '+IBQPatronymes.Fields[0].AsString;
          IBQPatronymes.Next;
        end;
        sNom:=sNom+']';
      end;
      IBQPatronymes.Close;
    end;
    //surnom
    if gci_context.SurnomAlaFin and(trim(FieldByName('SURNOM').AsString)>'') then
    begin
      sNom:=sNom+' (';
      if FieldByName('SEXE').AsInteger=2 then
      begin
        if gci_context.FormatSurnomF>'' then
          sNom:=sNom+gci_context.FormatSurnomF+' ';
      end
      else
      begin
        if gci_context.FormatSurnom>'' then
          sNom:=sNom+gci_context.FormatSurnom+' ';
      end;
      sNom:=sNom+trim(FieldByName('SURNOM').AsString)+')';
    end;
    //Nom, Prénom, Suffixe
    sNom:=AssembleString([sNom,
      FieldByName('PRENOM').AsString,
        FieldByName('SUFFIXE').AsString]);
    //surnom
    if (not gci_context.SurnomAlaFin)and(trim(FieldByName('SURNOM').AsString)>'') then
    begin
      sNom:=sNom+' (';
      if FieldByName('SEXE').AsInteger=2 then
      begin
        if gci_context.FormatSurnomF>'' then
          sNom:=sNom+gci_context.FormatSurnomF+' ';
      end
      else
      begin
        if gci_context.FormatSurnom>'' then
          sNom:=sNom+gci_context.FormatSurnom+' ';
      end;
      sNom:=sNom+trim(FieldByName('SURNOM').AsString)+')';
    end;
    //Civilite
    s:=trim(FieldByName('PREFIXE').AsString);
    if gci_context.Civilite then
      if Length(s)>0 then
        sNom:=s+' '+sNom;
    lTitre.Caption:=CoupeChaine(sNom,lTitre);
   end;
end;

procedure TFIndividuIdentite.RefreshTitle_Naissance;
var
  s,s2:string;
  sexe:integer;
begin
  with TFIndividu(GFormIndividu) do
  if QueryIndividu.Active Then
   Begin
    sexe:=QueryIndividuSEXE.AsInteger;
    //chaine liée à la naissance --> s2
    if length(sDBCBfiliation.Text)>0 then
      s:=sDBCBfiliation.Text
    else
      s:='';
    if (length(sDateNaissance)>0)
      or(length(sVilleNaissance)>0) then
    begin
      if sexe=2 then
        s2:=rs_born_female+' '
      else
        s2:=rs_born_male+' ';
      if length(s)>0 then
        s:=s+' '+s2
      else
        s:=fs_FormatText(s2,mftFirstIsMaj);
      if (length(sDateNaissance)>0) then
      begin
        if not _MotsClesDate.CommenceParToken(sDateNaissance) then
          if bJourNaissance then
            s:=s+rs_on_date +' '
          else
            s:=s+  rs_in_date+' ';
        s:=s+sDateNaissance;
        if length(sVilleNaissance)>0 then
          s:=s+' '+rs_at_where+' '+sVilleNaissance;
      end
      else if length(sVilleNaissance)>0 then
        s:=s+rs_at_where+' '+sVilleNaissance;

    end;
  end;
  lNaissance.Caption:=s;
end;

procedure TFIndividuIdentite.RefreshTitle;
var
  s,s3:string;
  sexe:integer;
  dd,mm,yy:string;
  iEspoirVie:integer;
begin
  RefreshTitle_Nom;
  RefreshTitle_Naissance;

  with TFIndividu(GFormIndividu) do
  if QueryIndividu.Active Then
   Begin
    sexe:=QueryIndividuSEXE.AsInteger;
    case sexe of
      1:iEspoirVie:=gci_context.AgeMaxiAuDecesHommes;
      2:iEspoirVie:=gci_context.AgeMaxiAuDecesFemmes;
      else
        iEspoirVie:=max(gci_context.AgeMaxiAuDecesFemmes,gci_context.AgeMaxiAuDecesHommes);
    end;

    //chaine liée au décés --> s3
    s3:='';
    if (length(sDateDeces)>0)
      or(length(sVilleDeces)>0) then
    begin
      if sexe=2 then
        s3:=rs_Dead_female+' '
      else
        s3:=rs_Dead_male+' ';
      if (length(sDateDeces)>0) then
      begin
        if not _MotsClesDate.CommenceParToken(sDateDeces) then
          if bJourDeces then
            s3:=s3+rs_on_date+' '
          else
            s3:=s3+rs_in_date+' ';
        s3:=s3+sDateDeces;
        if length(sVilleDeces)>0 then
          s3:=s3+' '+rs_at_where+' '+sVilleDeces;
      end
      else if length(sVilleDeces)>0 then
        s3:=s3+rs_at_where+' '+sVilleDeces;
      if length(sAgeTexte)>0 then //AL
      begin
        s:=sAgeTexte;
        if s[1]in ['a','e','i','o','u','y'] then
          s3:=s3+fs_RemplaceMsg(rs_oldd,[s])
        else
          s3:=s3+fs_RemplaceMsg(rs_olded,[s]);
      end;
    end
    else if (YearOf(Now)-TFIndividu(GFormIndividu).AnneeNaissance)>iEspoirVie Then
      s3:=rs_Death_date_unknown
    else
    begin
      dd:=IntToStr(DayOf(Date));
      mm:=IntToStr(MonthOf(Date));
      yy:=IntToStr(YearOf(Date));
      //MD Il faut tester date DMY/MDY/YMD et construire la date  _TYPE_TOKEN_FORME
      if (_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][0]='DMY') then
        S:=Age_Texte(TFIndividu(GFormIndividu).sDateNaissance,AssembleStringWithSep([dd,mm,yy],_MotsClesDate.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][0]))
      else if (_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][0]='MDY') then
        S:=Age_Texte(TFIndividu(GFormIndividu).sDateNaissance,AssembleStringWithSep([mm,dd,yy],_MotsClesDate.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][0]))
      else //YMD
        S:=Age_Texte(TFIndividu(GFormIndividu).sDateNaissance,AssembleStringWithSep([yy,mm,dd],_MotsClesDate.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][0]));

      if s>'' then //AL ajout AGE_TEXTE
      begin
        if sexe=2 then
          s3:=rs_Now_olded_female+' '
        else
          s3:=rs_Now_olded_male+' ';
        if s[1]in ['a','e','i','o','u','y'] then
          s3:=s3+fs_RemplaceMsg(rs_o_age,[s]) //AL MG
        else
          s3:=s3+fs_RemplaceMsg(rs_of_age,[s]); //AL MG
      end;
    end;
    lDeces.Caption:=s3;

    if length(sAgeUnion)>0 then //AL 2009
    begin
      lAgePremiereUnion.Caption:=fs_RemplaceMsg(rs_Caption_Age_on_first_union,[sAgeUnion]);
      lAgePremiereUnion.Visible:=true;
    end
    else
    begin
      lAgePremiereUnion.Caption:='';
      lAgePremiereUnion.Visible:=false;
    end;

    with QueryIndividuDERN_METIER do
    if length(AsString)>0 then //AL 2009
    begin
      lDernMetier.Caption:=fs_RemplaceMsg(rs_Caption_Last_job,[AsString]);
      lDernMetier.Visible:=true;
    end
    else
    begin
      lDernMetier.Caption:='';
      lDernMetier.Visible:=false;
    end;
   end;

  AfficheSosa;
end;

procedure TFIndividuIdentite.AfficheDetailsEvent;
 begin
   if IBQEve.Active and not IBQEve.IsEmpty then
     aFIndividuEditEventLife.Show;
 end;

procedure TFIndividuIdentite.lTitreClick(Sender:TObject);
begin
  if not TFIndividu(GFormIndividu).DialogMode then
  begin
    pIdentiteReduite.Hide;
    pIdentiteComplete.Show;
    if sDBENom.CanFocus then
      sDBENom.SetFocus;
  end;
end;

procedure TFIndividuIdentite.DBRSexeChange(Sender:TObject);
begin
  if DataSourceIndividu.State in [dsInsert,dsEdit] then
//    if DBRSexe.ModifiedAfterEnter then
      TFIndividu(GFormIndividu).RefreshNomIndividu;
end;

procedure TFIndividuIdentite.DataSourceIndividuDataChange(Sender:TObject;
  Field:TField);
begin
  TFIndividu(GFormIndividu).DoRefreshControls;
end;

procedure TFIndividuIdentite.SuperFormDestroy(Sender:TObject);
begin
  if assigned ( FIniFile ) Then
   Begin
    FIniFile.WriteInteger ( Name, cxSplitter1.Name +CST_ONFORMINI_DOT + CST_ONFORMINI_LEFT , cxSplitter1.Left);
    fb_iniWriteFile(FIniFile);
   end;
  ReqParente.Close;
  if assigned(aFIndividuEditEventLife) then
    FreeAndNil(aFIndividuEditEventLife);
  IBQEve.Close;
  IBQEve.UpdateObject:=nil;
  FreeAndNil(IBUEve);
end;

procedure TFIndividuIdentite.IBQEveNewRecord(DataSet:TDataSet);
begin
  ibqEveEV_IND_CLEF.AsInteger:=dm.uf_GetClefUnique('EVENEMENTS_IND');
  ibqEveEV_IND_KLE_FICHE.AsInteger:=TFIndividu(GFormIndividu).CleFiche;
  ibqEveEV_IND_KLE_DOSSIER.AsInteger:=dm.NumDossier;
  TFIndividu(GFormIndividu).doBouton(true);
end;

procedure TFIndividuIdentite.btnRetirerConjointClick(Sender:TObject);
var
  q:TIBSQL;
begin
  with tvConjEnfants do
  if FocusedNode<>nil then
  with PNodeIndividu(GetNodeData(FocusedNode))^ do
  begin
    if (FocusedNode^.Parent=RootNode)and(fClefUnion>0) then
    begin
      if MyMessageDlg(rs_Confirm_deleting_union+_CRLF+
        fNomComplet+' '+
        fDateNaissanceDeces+'?',
        mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
      begin
        q:=TIBSQL.create(self);
        try
          q.Database:=dm.ibd_BASE;
          q.Transaction:=dm.IBT_BASE;
          q.SQL.Add('select first(1) i.cle_fiche from t_union u'
            +' inner join individu i'
            +' on i.cle_pere is not distinct from u.union_mari'
            +' and i.cle_mere is not distinct from u.union_femme'
            +' where u.union_clef='+IntToStr(fClefUnion));
          q.ExecQuery;
          if q.eof then
          begin
            q.Close;
            q.SQL.Clear;
            q.SQL.Add('delete from t_union where union_clef='+IntToStr(fClefUnion));
            q.ExecQuery;
            TFIndividu(GFormIndividu).doBouton(true);
            TFIndividu(GFormIndividu).TestCoherenceDates;
            RempliConjEnfants;
            //On rafraichit  l'onglet Unions
            if TFIndividu(GFormIndividu).OngletSesConjointsIsLoaded then
              TFIndividu(GFormIndividu).aFIndividuUnion.doOpenQuerys(false);
          end
          else
            MyMessageDlg(rs_Error_Deleting_joint_with_child_is_forbidden,
              mtError, [mbOK],FMain);
          q.Close;
        finally
          q.Free;
        end;
      end;
    end;
  end;
end;

procedure TFIndividuIdentite.btnAjoutConjointClick(Sender:TObject);
var
  Conjoint:integer;
begin
  Conjoint:=-1;
  if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=0 then
  begin
    MyMessageDlg(rs_Error_Unknown_sexe_please_set_it,mtError, [mbOK],FMain);
    exit;
  end;
  if btnAjoutConjoint.Visible and btnAjoutConjoint.Enabled then
    if TFIndividu(GFormIndividu).aFIndividuUnion.FajoutConjoint(false,Conjoint,'') then //AL
      if gci_context.CreationMARRConjoint then
       begin
        TFIndividu(GFormIndividu).doActiveOnglet(_ONGLET_SES_CONJOINTS);
        TFIndividu(GFormIndividu).aFIndividuUnion.doGoto(Conjoint);
        TFIndividu(GFormIndividu).aFIndividuUnion.CreationEvFam('MARR','');
       end;
end;

procedure TFIndividuIdentite.tvConjEnfantsDblClick(Sender: TObject);
var
  UnIndi:integer;
  FHasChild : Boolean;
begin
  with tvConjEnfants do
  if (FocusedNode<>nil) then
  begin//tvConjEnfants.Cursor:=crHandPoint uniquement si sur icône
    UnIndi:=PNodeIndividu(GetNodeData(FocusedNode))^.fCleFiche;
    if UnIndi>0 then
    begin
      FHasChild := FocusedNode.FirstChild <> nil;
      dm.individu_clef:=UnIndi;
      DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
      if FHasChild Then
        FullCollapse(FocusedNode);  // inversion because of double click
    end;
  end;
end;

procedure TFIndividuIdentite.tvConjEnfantsGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex := PNodeIndividu(tvConjEnfants.GetNodeData(Node))^.fImageIndex;

end;

procedure TFIndividuIdentite.tvConjEnfantsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  CellText := PNodeIndividu(tvConjEnfants.GetNodeData(Node))^.fCaption;

end;

procedure TFIndividuIdentite.tvConjEnfantsPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  with tvConjEnfants,PNodeIndividu(GetNodeData(Node))^,TargetCanvas,Font do
   begin
    if FHasSosa and(FImageIndex<5) then
      Color:=_COLOR_SOSA
    else
      case FImageIndex of
        2:Color:=gci_context.ColorFemme;
        4:Color:=gci_context.ColorFemme;
        1:Color:=gci_context.ColorHomme;
        3:Color:=gci_context.ColorHomme;
        else
          Color:=clWindowText;
      end;

    if fCleFiche=0 then
      Style:=Style+ [fsBold]
    else
      Style:=Style- [fsBold];

    if FocusedNode=Node then
      Brush.Color:=gci_context.ColorMedium;
  end;
end;

procedure TFIndividuIdentite.tvEveDblClick(Sender: TObject);
begin
{  with GdEve do
   if Assigned(FocusedNode) Then
    IBQEve.Locate('ev_ind_clef',PTVNodeEve(GetNodeData(FocusedNode))^.FKey,[]);}
  AfficheDetailsEvent;
end;
{
procedure TFIndividuIdentite.tvEveFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  IBQEve.Locate('ev_ind_clef',PTVNodeEve(tvEve.GetNodeData(Node))^.FKey,[]);
end;

procedure TFIndividuIdentite.tvEveGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
    ImageIndex := PTVNodeEve(tvEve.GetNodeData(Node))^.ImageIdx;

end;

procedure TFIndividuIdentite.tvEveGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  CellText := PTVNodeEve(tvEve.GetNodeData(Node))^.FCaption;
end;
}

procedure TFIndividuIdentite.IBQEveCalcFields(DataSet:TDataSet);
var
  s,sa:string;
begin
  with IBQEve do
   Begin
    if (IBQEveEV_IND_TYPE.AsString='EVEN') and (Length(IBQEveEV_IND_TITRE_EVENT.AsString)>0) then
      IBQEve_LIBELLE.AsString:=IBQEveEV_IND_TITRE_EVENT.AsString
    else
      IBQEve_LIBELLE.AsString:=IBQEve_LONG_EVENT_NAME.AsString;

    case FieldByName('EV_IND_ACTE').AsInteger of
      1:
        begin
          if FieldByName('EV_IND_MEDIA').AsInteger>0 then
            IBQEveQUID_IMAGE.AsInteger:=1
          else
            IBQEveQUID_IMAGE.AsInteger:=9;
        end;
      -1:IBQEveQUID_IMAGE.AsInteger:=7;
      -2:IBQEveQUID_IMAGE.AsInteger:=6;
      -3:IBQEveQUID_IMAGE.AsInteger:=8;
      else
        IBQEveQUID_IMAGE.AsInteger:=5;
    end;

   if Length(IBQEveEV_IND_COMMENT.AsString)>0 then
    IBQEveQUID_NOTES.AsInteger:=1
  else
    IBQEveQUID_NOTES.AsInteger:=-1;
   if IBQEveEV_IND_DETAILS.AsInteger=1 then
    IBQEveQUID_SOURCES.AsInteger:=1
  else
    IBQEveQUID_SOURCES.AsInteger:=-1;

    //    Date
    if _GDate.DecodeHumanDate(FieldByName('EV_IND_DATE_WRITEN').AsString)
      and _GDate.ValidDateTime1 and not _GDate.UseDate2 then
    begin
      sJOUR_SEM:='('+LongDayNames[DayOfWeek(_GDate.DateTime1)]+')';
      s:=FieldByName('EV_IND_DATE_WRITEN').AsString+' '+sJOUR_SEM;
    end
    else
    begin
      sJOUR_SEM:='';
      s:=FieldByName('EV_IND_DATE_WRITEN').AsString;
    end;

    //Adresse
    if gci_context.AfficheCPdansListeEV then
      sa:=AssembleString([FieldByName('EV_IND_SUBD').AsString,
        FieldByName('EV_IND_CP').AsString,
          FieldByName('EV_IND_VILLE').AsString,
          FieldByName('EV_IND_DEPT').AsString])
    else
      sa:=AssembleString([FieldByName('EV_IND_SUBD').AsString,
        FieldByName('EV_IND_VILLE').AsString,
          FieldByName('EV_IND_DEPT').AsString]);

    if gci_context.AfficheRegiondansListeEV then
      sa:=AssembleString([sa,
        FieldByName('EV_IND_REGION').AsString,
          FieldByName('EV_IND_PAYS').AsString])
    else
      sa:=AssembleString([sa,
        FieldByName('EV_IND_PAYS').AsString]);


    if Length(FieldByName('EV_IND_DESCRIPTION').AsString)>0 then
      FieldByName('_DETAIL').AsString:=FieldByName('EV_IND_DESCRIPTION').AsString
    else
      FieldByName('_DETAIL').AsString:='';

    if Length(s)>0 then
      if Length(FieldByName('_DETAIL').AsString)>0 then
        FieldByName('_DETAIL').AsString:=FieldByName('_DETAIL').AsString+_CRLF+s
      else
        FieldByName('_DETAIL').AsString:=s;

    if Length(sa)>0 then
      if Length(FieldByName('_DETAIL').AsString)>0 then
        FieldByName('_DETAIL').AsString:=FieldByName('_DETAIL').AsString+_CRLF+sa
      else
        FieldByName('_DETAIL').AsString:=sa;

    if FieldByName('EV_IND_TYPE').AsString='BIRT' then
      sAGE_EVE:=''
    else
    begin
      s:=Age_Texte(TFIndividu(GFormIndividu).sDateNaissance,FieldByName('EV_IND_DATE_WRITEN').AsString);
      if s='' then
        sAGE_EVE:=''
      else if s[1]in ['a','e','i','o','u','y'] then
        sAGE_EVE:='à l''âge d'''+s
      else
        sAGE_EVE:='à l''âge de '+s;
    end;
   end;
end;

procedure TFIndividuIdentite.btnNewEventClick(Sender:TObject);
var
  aFEvenement_Ajout:TFEvenement_Ajout;
begin
  if btnNewEvent.Visible and btnNewEvent.Enabled then
  begin
    aFEvenement_Ajout:=TFEvenement_Ajout.create(self);
    try
      CentreLaFiche(aFEvenement_Ajout);
      aFEvenement_Ajout.up_Init(TFIndividu(GFormIndividu).CleFiche,'I');
      if aFEvenement_Ajout.ShowModal=mrOk then
      begin
        CreatFichEvInd(aFEvenement_Ajout.Ref_Eve_Lib_Court,aFEvenement_Ajout.REF_EVE_LIB_LONG);
      end;
    finally
      FreeAndNil(aFEvenement_Ajout);
    end;
    TFIndividu(GFormIndividu).doRefreshControls;
  end;
end;

procedure TFIndividuIdentite.btnDeleteEventClick(Sender:TObject);
var
  t:string;
begin
  if btnDeleteEvent.Visible and btnDeleteEvent.Enabled then
  begin
    if MyMessageDlg(rs_Confirm_deleting_this_event,
      mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
    with IBQEve,TFIndividu(GFormIndividu) do
      begin
        DisableControls;
        t:=FieldByName('EV_IND_TYPE').AsString;
        if t='BIRT' then
        begin
          sDateNaissance:='';
          sAnneeNaissance:='';
          bJourNaissance:=false;
          AnneeNaissance:=_AnMini;
          sVilleNaissance:='';
          MajAges(t);
          RefreshTitle;
        end
        else if t='DEAT' then
        begin
          sDateDeces:='';
          sAnneeDeces:='';
          bJourDeces:=false;
          sVilleDeces:='';
          MajAges(t);
          RefreshTitle;
        end;
        delete;
        doBouton(true);
        if (Active)and(IsEmpty) then
        begin
          aFIndividuEditEventLife.Hide;
        end;
        if Filtered then
          if IsEmpty then
            SuppressionFiltreEven(self);
        EnableControls;
        with GdEve do
         Refresh;

        TestCoherenceDates;
      end;
  end;
end;

procedure TFIndividuIdentite.SetColorFromContext;
begin
  lbNomPere.Font.Color:=gci_context.ColorHomme;
  lbNomMere.Font.Color:=gci_context.ColorFemme;
  lSosa.Font.Color:=_COLOR_SOSA;
end;

procedure TFIndividuIdentite.pIdentiteCompleteClick(Sender:TObject);
begin
  if TFIndividu(GFormIndividu).bNew then
    exit;
  if not TFIndividu(GFormIndividu).DialogMode then
  begin
    pIdentiteReduite.Show;
    pIdentiteComplete.Hide;
  end;
end;

procedure TFIndividuIdentite.mtriClick(Sender:TObject);
var
  aFTriEvent:TFTriEvent;
begin
  if IBQEve.Modified then
    IBQEve.Post;
  aFTriEvent:=TFTriEvent.create(self);
  try
    CentreLaFiche(aFTriEvent,FMain);
    aFTriEvent.doInit(TFIndividu(GFormIndividu).CleFiche,'I');
    aFTriEvent.ShowModal;
    if aFTriEvent.Modif then
    begin
      IBQEve.DisableControls;
      IBQEve.Close;
      IBQEve.Open;
      IBQEve.EnableControls;
      TFIndividu(GFormIndividu).Modified:=True;
      TFIndividu(GFormIndividu).DoRefreshControls;
    end;
  finally
    FreeAndNil(aFTriEvent);
  end;
end;

procedure TFIndividuIdentite.SupprimeParent(const Enfant,Parent:Integer);
//Parent: 1 supprime le père, 2 la mère, 0 les deux
begin
  with dm.ReqSansCheck do
  begin
    Close;
    SQL.Text:='execute block as '
      +'declare variable i_enfant integer='+IntToStr(Enfant)+';'
      +'declare variable pere integer;'
      +'declare variable mere integer;'
      +'declare variable i_kle_dossier integer='+IntToStr(dm.NumDossier)+';'
      +'declare variable compte integer;'
      +'begin '
      +'select cle_pere,cle_mere from individu '
      +'where cle_fiche=:i_enfant '
      +'into :pere,:mere;'
      +'if (';
    case Parent of
      1:SQL.Add('pere is null');
      2:SQL.Add('mere is null');
      else
        SQL.Add('pere is null and mere is null');
    end;
    SQL.Add(') then exit;'
      +'update individu');
    case Parent of //mise à null du père et/ou de la mère
      1:SQL.Add('set cle_pere=null');
      2:SQL.Add('set cle_mere=null');
      else
        SQL.Add('set cle_pere=null,cle_mere=null');
    end;
    SQL.Add('where cle_fiche=:i_enfant;');
    //suppression d'une union borgne (mari ou femme null) plus utilisée (sans enfant)
    if Parent in [0,1] then
      SQL.Add('if ((pere is not null) and (mere is null)) then '
        +'begin '
        +'compte=0;'
        +'select 1 from rdb$database where exists'
        +'(select * from individu '
        +'where cle_pere=:pere and cle_mere is null)'
        +'into :compte;'
        +'if (compte<1) then '
        +'delete from t_union '
        +'where union_mari=:pere and union_femme is null;'
        +'end');
    if Parent in [0,2] then
      SQL.Add('if ((mere is not null) and (pere is null)) then '
        +'begin '
        +'compte=0;'
        +'select 1 from rdb$database where exists'
        +'(select * from individu '
        +'where cle_mere=:mere and cle_pere is null)'
        +'into :compte;'
        +'if (compte<1) then '
        +'delete from t_union '
        +'where union_femme=:mere and union_mari is null;'
        +'end');
    //création éventuelle d'une union borgne si un seul est supprimé et que l'autre existe
    case Parent of
      1:SQL.Add('if (mere is not null) then '
          +'begin '
          +'compte=0;'
          +'select 1 from rdb$database where exists'
          +'(select * from t_union where union_mari is null and union_femme=:mere)'
          +'into :compte;'
          +'if (compte<1) then '
          +'insert into t_union (union_femme,kle_dossier,union_type)'
          +'values (:mere,:i_kle_dossier,0);'
          +'end');
      2:SQL.Add('if (pere is not null) then '
          +'begin '
          +'compte=0;'
          +'select 1 from rdb$database where exists'
          +'(select * from t_union where union_mari=:pere and union_femme is null)'
          +'into :compte;'
          +'if (compte<1) then '
          +'insert into t_union (union_mari,kle_dossier,union_type)'
          +'values (:pere,:i_kle_dossier,0);'
          +'end');
    end;
    SQL.Add('end');
    ExecQuery;
    Close;
  end;
end;

procedure TFIndividuIdentite.DefiniParents(const Enfant,Pere,Mere:Integer);
begin
  SupprimeParent(Enfant,0);// nécessaire pour supprimer une éventuelle union borgne
  if (Pere>0)or(Mere>0) then //sinon plus rien à faire
  begin
    with dm.ReqSansCheck do
    begin
      Close;
      SQL.Text:='execute block as '
        +'declare variable i_enfant integer='+IntToStr(Enfant)+';'
        +'declare variable i_pere integer='+IntToStr(Pere)+';'
        +'declare variable i_mere integer='+IntToStr(Mere)+';'
        +'declare variable i_kle_dossier integer='+IntToStr(dm.NumDossier)+';'
        +'declare variable compte integer;'
        +'declare variable famille integer;'
        +'begin '
        +'if (i_pere=0) then i_pere=null;'
        +'if (i_mere=0) then i_mere=null;'
        +'update individu'//mise à jour de l'individu
        +' set cle_pere=:i_pere,cle_mere=:i_mere'
        +' where cle_fiche=:i_enfant;'
        +'compte=0;'//création de l'union si elle n'existe pas
        +'select 1 from rdb$database where exists'
        +'(select 1 from t_union where union_mari is not distinct from :i_pere'
        +' and union_femme is not distinct from :i_mere)'
        +'into :compte;'
        +'if (compte<1) then'
        +' begin'
        +' insert into t_union (union_mari,union_femme,kle_dossier,union_type)'
        +' values (:i_pere,:i_mere,:i_kle_dossier,0)returning union_clef into :famille;';
      if gci_context.CreationMARRParent then
        SQL.Add('if((i_pere>0)and(i_mere>0))then'
          +' insert into evenements_fam(ev_fam_kle_famille,ev_fam_kle_dossier,ev_fam_type)'
          +'values(:famille,:i_kle_dossier,''MARR'');');
      SQL.Add('end end');
      ExecQuery;
      Close;
    end;
  end;
end;

procedure TFIndividuIdentite.lbNomPereMouseEnter(Sender:TObject);
begin
  if TFIndividu(GFormIndividu).QueryIndividuCLE_PERE.AsInteger>0 then
  begin
    lbNomPere.Font.Style:=lbNomPere.Font.Style+ [fsUnderline];
    FMain.MsgBarreEtat(1);
  end
  else
    lbNomPere.Font.Style:=lbNomPere.Font.Style- [fsUnderline];
end;

procedure TFIndividuIdentite.lbNomPereMouseLeave(Sender:TObject);
begin
  lbNomPere.Font.Style:=lbNomPere.Font.Style- [fsUnderline];
  FMain.MsgBarreEtat(0);
end;

procedure TFIndividuIdentite.lbNomMereMouseEnter(Sender:TObject);
begin
  if TFIndividu(GFormIndividu).QueryIndividuCLE_MERE.AsInteger>0 then
  begin
    lbNomMere.Font.Style:=lbNomMere.Font.Style+ [fsUnderline];
    FMain.MsgBarreEtat(1);
  end
  else
    lbNomMere.Font.Style:=lbNomMere.Font.Style- [fsUnderline];
end;

procedure TFIndividuIdentite.lbNomMereMouseLeave(Sender:TObject);
begin
  lbNomMere.Font.Style:=lbNomMere.Font.Style- [fsUnderline];
  FMain.MsgBarreEtat(0);
end;

procedure TFIndividuIdentite.doCompteConjoints;
var
  i:integer;
begin
  if TFIndividu(GFormIndividu).QueryIndividuNMR.IsNull then
    lNbreConjoints.Visible:=False
  else
  begin
    lNbreConjoints.Visible:=True;
    i:=TFIndividu(GFormIndividu).QueryIndividuNMR.AsInteger;
    if i=1 then
      lNbreConjoints.Caption:=rs_Caption_One_known_union
    else if i>1 then
      lNbreConjoints.Caption:=fs_RemplaceMsg(rs_Caption_Known_unions,[IntToStr(i)])
    else
      lNbreConjoints.Caption:=rs_Caption_None_union;
  end;
end;

procedure TFIndividuIdentite.doCompteEnfants;
var
  i:integer;
begin
  if TFIndividu(GFormIndividu).QueryIndividuNCHI.IsNull then
    lNbreEnfants.visible:=false
  else
  begin
    lNbreEnfants.visible:=True;
    i:=TFIndividu(GFormIndividu).QueryIndividuNCHI.AsInteger;
    if i=1 then
      lNbreEnfants.Caption:=rs_Caption_One_known_child
    else if i>1 then
      lNbreEnfants.Caption:=fs_RemplaceMsg(rs_Caption_Known_children, [IntToStr(i)])
    else
      lNbreEnfants.Caption:=rs_Caption_Childless;
  end;
end;

procedure TFIndividuIdentite.cbGardeChange(Sender:TObject);
begin
  gci_context.Garde:=not cbGarde.Checked;
  cbGardeLabel;
end;

procedure TFIndividuIdentite.cbGardeLabel;
begin
  if CbGarde.Checked
    then cbGarde.Caption:=rs_Caption_Panel_enabled
    else cbGarde.Caption:=rs_Caption_Panel_disabled;
end;

procedure TFIndividuIdentite.dbeCleFixeExit(Sender:TObject);
var
  q:TIBSQL;
  i:integer;
begin
  q:=TIBSQL.create(self);
  try
    q.Database:=dm.ibd_BASE;
    q.Transaction:=dm.IBT_BASE;
    q.SQL.Add('SELECT COUNT(*) FROM INDIVIDU WHERE CLE_FIXE=:CLE');
    q.Params[0].AsInteger:=TFIndividu(GFormIndividu).QueryIndividuCLE_FIXE.AsInteger;
    q.ExecQuery;
    i:=q.Fields[0].AsInteger;
    q.Close;
  finally
    q.Free;
  end;
  if i>0 then
    MyMessageDlg(fs_RemplaceMsg(rs_Warning_Number_already_exists_a_new_number_will_be_set,
    [IntToStr(TFIndividu(GFormIndividu).QueryIndividuCLE_FIXE.AsInteger)]),mtWarning, [mbOK],FMain);
end;

procedure TFIndividuIdentite.doRefreshConSang;
begin
  if (gci_context.NiveauConsang>0)
    and(not TFIndividu(GFormIndividu).QueryIndividuCONSANGUINITE.IsNull) then
  begin
    lSang.Caption:=rs_Caption_Consanguinity+' : '+
      FormatFloat('0.00',TFIndividu(GFormIndividu).QueryIndividuCONSANGUINITE.AsFloat*100)+'%';
  end
  else
  begin
    lSang.Caption:='';
  end;
end;

procedure TFIndividuIdentite.dxDBGEveKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
 if key=VK_RETURN then
    AfficheDetailsEvent;
end;

procedure TFIndividuIdentite.btnDecesClick(Sender:TObject);
var
  s:string;
begin
  s:=(Sender as TFWXPButton).Name;
  if s='btnNaissance' then
    s:='BIRT'
  else if s='btnDeces' then
    s:='DEAT'
  else if s='btnProfession' then
    s:='OCCU'
  else
    exit;

  CreatFichEvInd(s,'');
end;

procedure TFIndividuIdentite.mRAZTriClick(Sender:TObject);
begin
  if MyMessageDlg(rs_Warning_Date_sorting_excepting_birth_will_be_default+_CRLF+_CRLF
    +rs_Do_you_continue,mtWarning, [mbYes,mbNo],FMain)=mrYes then
  begin
    if IBQEve.Modified then
      IBQEve.Post;
    with dm.ReqSansCheck do
    begin
      SQL.Text:='UPDATE EVENEMENTS_IND SET EV_IND_ORDRE=NULL WHERE EV_IND_KLE_FICHE='
        +TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsString;
      ExecQuery;
      Close;
    end;
    IBQEve.DisableControls;
    IBQEve.Close;
    IBQEve.Open;
    IBQEve.EnableControls;
    TFIndividu(GFormIndividu).Modified:=True;
    TFIndividu(GFormIndividu).DoRefreshControls;
  end;
end;

procedure TFIndividuIdentite.mDelIdentiteClick(Sender:TObject);
begin
  if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=2 then
    Image2.Picture.Assign(IAWoman.Picture)
  else
    Image2.Picture.Assign(IAMan.Picture);
  bIdentiteVisible:=false;
  Image2.ShowHint:=True;
  with dm.ReqSansCheck do
  begin
    try
      SQL.Text:='Update MEDIA_POINTEURS set MP_IDENTITE=0 where MP_CLEF='+IntToStr(idPhoto);
      ExecQuery;
      TFIndividu(GFormIndividu).doBouton(true);
    except
      on E:EIBError do
        showmessage('Impossible de supprimer la photo d''identité '+E.Message);
    end;
    Close;
  end;
end;

procedure TFIndividuIdentite.pmPhotoPopup(Sender:TObject);
begin
  mDelIdentite.Enabled:=bIdentiteVisible;
  mVoirPhoto.Enabled:=bIdentiteVisible;
  mDelIdentite.Visible:=(TFIndividu(GFormIndividu).DialogMode=false);
end;

procedure TFIndividuIdentite.pmValiderTelQuelPopup(Sender:TObject);
begin
  if ((Sender as TPopupMenu).PopupComponent as TDBComboBox).CanFocus then
    ((Sender as TPopupMenu).PopupComponent as TDBComboBox).SetFocus;
end;

procedure TFIndividuIdentite.doGoto(iNumLigne:integer);
begin
  IBQEve.Locate('EV_IND_CLEF',iNumLigne, []);
  AfficheDetailsEvent;
end;

procedure TFIndividuIdentite.mVoirPhotoClick(Sender:TObject);
var
  id:integer;
begin
  try
    with dm.ReqSansCheck do
    begin
      SQL.Text:='SELECT MP_MEDIA FROM MEDIA_POINTEURS where MP_CLEF='+IntToStr(idPhoto);
      ExecQuery;
      id:=Fields[0].asInteger;
      Close;
    end;
    VisualiseMedia(id,dm.ReqSansCheck);
  except
  end;
end;

procedure TFIndividuIdentite.VisualiserlacteClick(Sender:TObject);
begin
  if IBQEveQUID_IMAGE.AsInteger=1 then
    VisualiseMedia(IBQEveEV_IND_MEDIA.AsInteger,dm.ReqSansCheck);
end;

procedure TFIndividuIdentite.PopupVideEvePopup(Sender:TObject);
begin
  with IBQEve do
   Begin
    mOuvrirEvenement.Visible:=not IsEmpty;
    Visualiserlacte.Visible:=(IBQEveQUID_IMAGE.AsInteger=1);
    mAjout.Visible:=(TFIndividu(GFormIndividu).DialogMode=false);
    mdel.Visible:=not IsEmpty and(TFIndividu(GFormIndividu).DialogMode=false);
    mtri.Visible:=not IsEmpty and(TFIndividu(GFormIndividu).DialogMode=false);
    mRAZTri.Visible:=not IsEmpty and(TFIndividu(GFormIndividu).DialogMode=false);
    mCopierEvenement.Visible:=not IsEmpty;
    mCollerEvenement.Visible:=(dm.EvIndEnMemoire>0)and(TFIndividu(GFormIndividu).DialogMode=false);
   end;
end;

procedure TFIndividuIdentite.lSosaMouseEnter(Sender:TObject);
begin
  FMain.MsgBarreEtat(0,dm.sSosa1);
  lSosa.Font.Style:=lSosa.Font.Style+ [fsUnderline]
end;

procedure TFIndividuIdentite.lSosaMouseLeave(Sender:TObject);
begin
  FMain.MsgBarreEtat(0);
  lSosa.Font.Style:=lSosa.Font.Style- [fsUnderline]
end;

procedure TFIndividuIdentite.lSosaClick(Sender:TObject);
var
  P:TPoint;
begin
  P:=lSosa.ClientToScreen(Point(XSouris,YSouris));
  pmSosa.Popup(P.X,P.Y);
end;

procedure TFIndividuIdentite.LiensAncetreCommunClick(Sender:TObject);
begin
  FMain.OuvreLienGene(TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsInteger,dm.iSosa1,
    '['+IntToStr(TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsInteger)+'] '+TFIndividu(GFormIndividu).NomIndiComplet,
    dm.sSosa1);
end;
{

procedure TFIndividuIdentite.dxDBGraphicEdit1GetGraphicClass(
  Sender:TObject;APastingFromClipboard:Boolean;
  var AGraphicClass:TGraphicClass);
begin
  AGraphicClass:=tjpegimage;
end;
 }
procedure TFIndividuIdentite.dxDBGEve_DetailDrawColumnCell(
  Sender:TObject;ACanvas:TCanvas;
  AViewInfo:Longint;var ADone:Boolean);
begin
  acanvas.Font.Color:=clBlue;
end;

procedure TFIndividuIdentite.doRefreshZodiaque;
var
  iZodiaque:integer;
begin
  if gci_context.Astro and TFIndividu(GFormIndividu).QueryIndividu.Active then
  begin
    if TFIndividu(GFormIndividu).bJourNaissance then
    begin
      iZodiaque:=doZodiaque(TFIndividu(GFormIndividu).NumJourNaissance);
      case gci_context.SetAstro of
        0:cxImageListZodiac.GetBitmap(iZodiaque,ImageAstro.Picture.Bitmap);
        1:cxImageListZodiac.GetBitmap(iZodiaque+12,ImageAstro.Picture.Bitmap);
        2:cxImageListZodiac.GetBitmap(iZodiaque+24,ImageAstro.Picture.Bitmap);
        3:cxImageListZodiac.GetBitmap(iZodiaque+36,ImageAstro.Picture.Bitmap);
      end;
      ImageAstro.Visible:=iZodiaque<>-1;
      case iZodiaque of
        0:ImageAstro.Hint:=rs_Astro_Aquarius;
        1:ImageAstro.Hint:=rs_Astro_Pisces;
        2:ImageAstro.Hint:=rs_Astro_Aries;
        3:ImageAstro.Hint:=rs_Astro_Taurus;
        4:ImageAstro.Hint:=rs_Astro_Gemini;
        5:ImageAstro.Hint:=rs_Astro_Cancer;
        6:ImageAstro.Hint:=rs_Astro_Lion;
        7:ImageAstro.Hint:=rs_Astro_Virgin;
        8:ImageAstro.Hint:=rs_Astro_Balance;
        9:ImageAstro.Hint:=rs_Astro_Scorpion;
        10:ImageAstro.Hint:=rs_Astro_Sagittarius;
        11:ImageAstro.Hint:=rs_Astro_Capricorn;
      end;
    end
    else
      ImageAstro.Visible:=False;
  end
  else
    ImageAstro.Visible:=False;
end;

  {
procedure TFIndividuIdentite.sDBEPrenomChange(Sender:TObject);
var
  s:string;
  p,i:integer;
begin
//  if  not sDBEPrenom.ModifiedAfterEnter then //indispensable avec Tcx sans celà déclenche au changement d'indi
//    exit;
  s:=sDBEPrenom.Text;
  p:=length(s);
  if p=0 then
    InitListePrenoms
  else
  begin
    if s[p]in [' ',',','(',')','?'] then //le dernier caractère est un séparateur
    begin
      if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=0 then //si le sexe n'est pas encore déterminé
      begin
        for i:=p-1 downto 1 do //on cherche le séparateur précédent
          if s[i]in [' ',',','(',')','?'] then
            break;

        s:=copy(s,i+1,p-i-1);//chaîne entre les 2 séparateurs
        if IBQPrenoms.Locate('PRENOM',s, [loCaseInsensitive]) then
          TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger:=IBQPrenomsSEXE.AsInteger;
      end;
      InitListePrenoms;
    end;
  end;
end;
{
procedure TFIndividuIdentite.InitListePrenoms;
var
  s:string;
  i,p:integer;
begin
  sDBEPrenom.AutoComplete:=false;
  s:=sDBEPrenom.Text;
  p:=sDBEPrenom.SelStart;
  for i:=length(s)downto 1 do
    if s[i]in [' ',',','(',')','?'] then
      break;

  if i>0 then
    s:=copy(sDBEPrenom.Text,1,i)
  else
    s:='';
  sDBEPrenom.Items.Clear;
  IBQPrenoms.First;
  while not IBQPrenoms.Eof do
  begin
    sDBEPrenom.Items.Add(s+IBQPrenomsPRENOM.asString);
    IBQPrenoms.Next;
  end;
  sDBEPrenom.AutoComplete:=true;
  sDBEPrenom.SelStart:=p;
end;
procedure TFIndividuIdentite.sDBEPrenomExit(Sender:TObject);
var
  s:string;
  i:integer;
begin
  if PrenomEnter<>sDBEPrenom.text then
    if DataSourceIndividu.State in [dsEdit,dsInsert] then
    begin
      if (TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=0)
        and IBQPrenoms.Active then //le sexe n'est pas encore déterminé
      begin
        s:=sDBEPrenom.Text;
        for i:=length(s)downto 1 do
          if s[i]in [' ',',','(',')','?'] then
            break;
        s:=copy(s,i+1,length(s)-i);
        if IBQPrenoms.Locate('PRENOM',s, [loCaseInsensitive]) then
          TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger:=IBQPrenomsSEXE.AsInteger;
      end;
      if mTelQuel.Checked then
        TFIndividu(GFormIndividu).QueryIndividuPRENOM.AsString:=Trim(sDBEPrenom.Text)
      else
        TFIndividu(GFormIndividu).QueryIndividuPRENOM.AsString:=fs_FormatText(sDBEPrenom.Text);
      TFIndividu(GFormIndividu).RefreshNomIndividu;
      RefreshTitle_Nom;
    end;
  IBQPrenoms.Close;
  IBQNoms   .Close;
  mTelQuel.Checked:=False;
end;
}

procedure TFIndividuIdentite.sDBENomEnter(Sender:TObject);
begin
  NomEnter:=sDBENom.Text;
end;

procedure TFIndividuIdentite.sDBENomExit(Sender:TObject);
begin
  if NomEnter<>sDBENom.Text then
    if DataSourceIndividu.State in [dsEdit,dsInsert] then
    begin
      if mTelQuel.Checked then
        TFIndividu(GFormIndividu).QueryIndividuNOM.AsString:=Trim(sDBENom.Text)
      else
        TFIndividu(GFormIndividu).QueryIndividuNOM.AsString:=fs_FormatText(sDBENom.Text,mftUpper);
      TFIndividu(GFormIndividu).RefreshNomIndividu;
      RefreshTitle_Nom;
    end;
  mTelQuel.Checked:=False
end;
{
procedure TFIndividuIdentite.AjouteNomAliste(UnNom:string);
var
  i:integer;
begin
  if UnNom>'' then
  begin
    i:=sDBENom.Items.IndexOf(UnNom);
    if i=-1 then
      sDBENom.Items.Add(UnNom);
  end;
end;
}
procedure TFIndividuIdentite.InitCivilites;
var
  q:TIBSQL;
begin//initialisation combo préfixes
  q:=TIBSQL.Create(self);
  try
    q.Database:=dm.ibd_BASE;
    q.Transaction:=dm.IBT_BASE;
    q.SQL.Clear;
    q.SQL.Add('select distinct pr_libelle from ref_prefixes order by pr_libelle');
    q.ExecQuery;
    edCivilite.Items.Clear;
    while not q.Eof do
    begin
      edCivilite.Items.Add(q.Fields[0].AsString);
      q.Next;
    end;
    q.Close;
  finally
    q.free;
  end;
end;

procedure TFIndividuIdentite.InitFiliations;
var
  q:TIBSQL;
begin//initialisation combo filiation
  q:=TIBSQL.Create(self);
  try
    q.Database:=dm.ibd_BASE;
    q.Transaction:=dm.IBT_BASE;
    q.SQL.Clear;
    q.SQL.Add('SELECT fil_libelle FROM REF_FILIATION where fil_langue=:langue order by fil_libelle');
    q.Params[0].AsString:=gci_context.Langue;
    q.ExecQuery;
    sDBCBfiliation.Items.Clear;
    while not q.Eof do
    begin
      sDBCBfiliation.Items.Add(q.Fields[0].AsString);
      q.Next;
    end;
    q.Close;
  finally
    q.free;
  end;
end;

procedure TFIndividuIdentite.RempliConjEnfants;
var
  j,k:Integer;
  indivAjoute,NodeSelected:PVirtualNode;
  s:string;

  procedure TermineAjout;
  var
    libelle:string;
  Begin
    with PNodeIndividu (tvConjEnfants.GetNodeData(indivAjoute))^ do
     begin
      if fOrdre2<>0 then
      begin
        libelle:='{X '+IntToStr(fOrdre2)+'} ';
      end
      else
        libelle:='';
      fCaption:=libelle+fNomComplet+' '+fDateNaissanceDeces;
      case fSexe of
        1:fImageIndex:=1;
        2:FImageIndex:=2;
        -1:FImageIndex:=3;
        -2:FImageIndex:=4;
        -3:FImageIndex:=5;
        -4:FImageIndex:=6;
        else
          FImageIndex:=0;
      end;
//       SelectedIndex:=FImageIndex;

    end;

  end;

  function AjouteAtv(parent:PVirtualNode):integer;
  begin
    indivAjoute:=tvConjEnfants.AddChild(parent,nil);
    with tvConjEnfants do
     Begin
      ValidateNode(indivAjoute,False);
      result:=indivAjoute^.Index;
     end;
  end;

begin
  tvConjEnfants.BeginUpdate;
  tvConjEnfants.DisableAlign;
  with tvConjEnfants do
  try
    NodeSelected:=nil;
 {   if NodeSelected<>nil then
    begin
      CleIndiSelected:=PNodeIndividu(GetNodeData(NodeSelected))^.fCleFiche;
      NodeSelected:=nil;
    end
    else
      CleIndiSelected:=-1;
           }
    Clear;
    IBQtv.close;
    IBQtv.ParamByName('cle_fiche').AsInteger:=TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsInteger;
    IBQtv.ExecQuery;
    NbrConjoints:=0;
    NbrEnfants:=0;
    j:=-10;
    k:=0;
    with IBQtv do
    while not Eof do
    begin
      if (FieldByName('CLE_CONJOINT').AsInteger<>j) then
      //on ajoute un conjoint
      begin
        inc(NbrConjoints);
        j:=FieldByName('CLE_CONJOINT').AsInteger;
        k:=AjouteAtv(nil);
        with PNodeIndividu ( GetNodeData(indivAjoute))^ do
         Begin
            fCleFiche:=j;
            fClefUnion:=FieldByName('UNION_CLEF').AsInteger;
            fOrdre2:=FieldByName('AN_MAR').AsInteger;
            fSexe:=FieldByName('SEXE_CONJOINT').AsInteger;
            if fSexe=0 then
              fSexe:=TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger-3;
            fNomComplet:=FieldByName('NOMPRENOM_CONJOINT').AsString;
            fNom:=FieldByName('NOM_CONJOINT').AsString;
            fDateNaissanceDeces:=FieldByName('NAISSDECES_CONJOINT').AsString;
            FHasSosa:=FieldByName('SOSA_CONJOINT').AsInteger>0;
            fHint:=AssembleString([FieldByName('naissanceconjoint').AsString
              ,FieldByName('villenaissanceconjoint').AsString
                ,FieldByName('deptnaissanceconjoint').AsString]);
            if gci_context.AfficheRegiondansListeEV then
              FHint:=AssembleString([FHint
                ,FieldByName('regionnaissanceconjoint').AsString
                  ,FieldByName('paysnaissanceconjoint').AsString])
            else
              FHint:=AssembleString([FHint
                ,FieldByName('paysnaissanceconjoint').AsString]);
            s:=AssembleString([FieldByName('decesconjoint').AsString
              ,FieldByName('villedecesconjoint').AsString
                ,FieldByName('deptdecesconjoint').AsString]);
            if gci_context.AfficheRegiondansListeEV then
              s:=AssembleString([s,FieldByName('regiondecesconjoint').AsString
                ,FieldByName('paysdecesconjoint').AsString])
            else
              s:=AssembleString([s,FieldByName('paysdecesconjoint').AsString]);
            if FHint>'' then
              if FSexe=-2 then
                FHint:=fs_RemplaceMsg(rs_Born_on_female,[FHint])
              else
                FHint:=fs_RemplaceMsg(rs_Born_on_male,[FHint]);
            if s>'' then
            begin
              if FHint>'' then
                FHint:=FHint+_CRLF;
              if FSexe=-2 then
                FHint:=FHint+fs_RemplaceMsg(rs_Death_on_female,[s])
              else
                FHint:=FHint+fs_RemplaceMsg(rs_Death_on_male,[s]);
            end;
            FOrdre:=-1;
            TermineAjout;
//            if fCleFiche=CleIndiSelected then
            NodeSelected:=indivAjoute;
         end;
      end;
      if FieldByName('CLE_FICHE').AsInteger>0 then
      begin
        inc(NbrEnfants);
        AjouteAtv(NodeSelected);
        with PNodeIndividu ( GetNodeData(indivAjoute))^ do
         Begin
            fCleFiche:=FieldByName('CLE_FICHE').AsInteger;
            fClefUnion:=FieldByName('UNION_CLEF').AsInteger;
            FOrdre2:=0;
            FSexe:=FieldByName('SEXE').AsInteger;
            fNomComplet:=FieldByName('NOMPRENOM').AsString;
            fDateNaissanceDeces:=FieldByName('NAISSDECES').AsString;
            FHasSosa:=FieldByName('SOSA').AsInteger>0;
            FHint:=AssembleString([FieldByName('naissanceenfant').AsString
              ,FieldByName('villenaissanceenfant').AsString
                ,FieldByName('deptnaissanceenfant').AsString]);
            if gci_context.AfficheRegiondansListeEV then
              FHint:=AssembleString([FHint
                ,FieldByName('regionnaissanceenfant').AsString
                  ,FieldByName('paysnaissanceenfant').AsString])
            else
              FHint:=AssembleString([FHint
                ,FieldByName('paysnaissanceenfant').AsString]);
            s:=AssembleString([FieldByName('decesenfant').AsString
              ,FieldByName('villedecesenfant').AsString
                ,FieldByName('deptdecesenfant').AsString]);
            if gci_context.AfficheRegiondansListeEV then
              s:=AssembleString([s,FieldByName('regiondecesenfant').AsString
                ,FieldByName('paysdecesenfant').AsString])
            else
              s:=AssembleString([s,FieldByName('paysdecesenfant').AsString]);
            if FHint>'' then
              if FSexe=2 then
                FHint:=fs_RemplaceMsg(rs_Born_on_female,[FHint])
              else
                FHint:=fs_RemplaceMsg(rs_Born_on_male,[FHint]);
            if s>'' then
            begin
              if FHint>'' then
                FHint:=FHint+_CRLF;
              if FSexe=2 then
                FHint:=FHint+fs_RemplaceMsg(rs_Death_on_female,[s])
              else
                FHint:=FHint+fs_RemplaceMsg(rs_Death_on_male,[s]);
            end;
            if FieldByName('cle_parents').IsNull then
              FOrdre:=-1
            else
              FOrdre:=FieldByName('cle_parents').AsInteger;
            TermineAjout;
//            if fCleFiche=CleIndiSelected then
  //            NodeSelected:=indivAjoute;

         end;
      end;
      Next;
    end;
    IBQtv.close;
    tvConjEnfants.FullExpand;
  finally
    tvConjEnfants.EnableAlign;
    tvConjEnfants.EndUpdate;
  end;
  with tvConjEnfants do
  if NodeSelected<>nil then
    FocusedNode := NodeSelected
  else if tvConjEnfants.TotalCount>0 then
    FocusedNode := RootNode^.FirstChild;

  if NbrEnfants>1 then
    lEnfants.Caption:=fs_RemplaceMsg(rs_Caption_Her_his_children,[IntToStr(NbrEnfants)])
  else if NbrEnfants=1 then
    lEnfants.Caption:=rs_Caption_Her_his_child
  else
  begin
    lEnfants.Caption:=rs_Caption_None_child;
    btnRetirerEnfant.Enabled:=false;//n'est pas mis à jour par tvConjEnfantsChange dans ce cas
  end;

  if NbrConjoints>1 then
    lConjoints.Caption:=fs_RemplaceMsg(rs_Caption_Her_his_joints,[IntToStr(NbrConjoints)])
  else if NbrConjoints=1 then
    lConjoints.Caption:=rs_Caption_Her_his_joint
  else
  begin
    lConjoints.Caption:=rs_Caption_None_joint;
    btnRetirerConjoint.Enabled:=false;//n'est pas mis à jour par tvConjEnfantsChange dans ce cas
  end;

  if tvConjEnfants.RootNode.FirstChild <> nil Then
  DBRSexe.ReadOnly:=tvConjEnfants.RootNode.FirstChild <> nil;
end;


procedure TFIndividuIdentite.tvConjEnfantsDrawColumnCell(Sender:TObject;
  ACanvas:TCanvas;AViewInfo:TVTPaintInfo;
  var ADone:Boolean);
begin
end;

procedure TFIndividuIdentite.mOuvrirlaficheClick(Sender:TObject);
begin
  tvConjEnfantsDblClick(Sender);
end;

procedure TFIndividuIdentite.mSupprimerlelienClick(Sender:TObject);
begin
  with tvConjEnfants,FocusedNode^ do
  if (Parent<>nil) and (Parent^.Parent = RootNode)  then
  begin
    if btnRetirerEnfant.Visible and btnRetirerEnfant.Enabled then
      btnRetirerEnfantClick(Sender);
  end
  else
  begin
    if btnRetirerConjoint.Visible and btnRetirerConjoint.Enabled then
      btnRetirerConjointClick(Sender);
  end;
end;

procedure TFIndividuIdentite.tvConjEnfantsChange(Sender:TObject);
var
  bConjoint,bEnfant,bOuvrir,bOrdre:boolean;
begin//tvConjEnfantsChange non déclanchée quand on passe à un TV vide
  if tvConjEnfants.FocusedNode<>nil then
  begin
    with tvConjEnfants,FocusedNode^ do
    if (Parent<>nil) and (Parent^.Parent = RootNode)  then
    begin
      bConjoint:=false;
      bEnfant:=true;
      bOuvrir:=true;
      bOrdre:=PNodeIndividu(GetNodeData(FocusedNode))^.fOrdre>=0;
    end
    else
    begin
      bEnfant:=false;
      if FirstChild=nil then
        bConjoint:=true
      else
        bConjoint:=false;
      if PNodeIndividu(GetNOdeData (FocusedNode))^.fCleFiche>0 then
        bOuvrir:=true
      else
        bOuvrir:=false;
      bOrdre:=false;
    end;
  end
  else
  begin
    bConjoint:=false;
    bEnfant:=false;
    bOuvrir:=false;
    bOrdre:=false;
  end;
  btnRetirerConjoint.Enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)
    and(TFIndividu(GFormIndividu).DialogMode=false)and bConjoint;
  btnRetirerEnfant.Enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)
    and(TFIndividu(GFormIndividu).DialogMode=false)and bEnfant;
  mSupprimerlelien.Enabled:=btnRetirerConjoint.Enabled or btnRetirerEnfant.Enabled;
  mOuvrirlafiche.Enabled:=bOuvrir;
  mSupprimerOrdre.Enabled:=(TFIndividu(GFormIndividu).CleFiche<>-1)
    and(TFIndividu(GFormIndividu).DialogMode=false)and bOrdre;
end;

procedure TFIndividuIdentite.LabelParamDiversClick(Sender:TObject);
var
  p:TPoint;
begin
  p:=LabelParamDivers.ClientToScreen(Point(XSouris,YSouris));
  pmParamDivers.Popup(p.X,p.Y);
end;

procedure TFIndividuIdentite.pmParamDiversPopup(Sender:TObject);
var
  i:Smallint;
begin
  i:=TFIndividu(GFormIndividu).QueryIndividuIND_CONFIDENTIEL.AsInteger;
  mIndividuconfidentiel.Checked:=(i and _i_IndiConf)=_i_IndiConf;
  mSansalertesurdates.Checked:=(i and _i_SansCtrlDates)=_i_SansCtrlDates;
  mIdentiteIncertaine.Checked:=(i and _i_IdentiteIncertaine)=_i_IdentiteIncertaine;
  mContinuerRecherches.Checked:=(i and _i_ContinuerRecherches)=_i_ContinuerRecherches;
end;

procedure TFIndividuIdentite.mIndividuconfidentielClick(Sender:TObject);
var
  ItemMenu:TmenuItem;
  i:Smallint;
begin
  if TFIndividu(GFormIndividu).DialogMode then
    Exit;
  if not(TFIndividu(GFormIndividu).QueryIndividu.State in [dsEdit,dsInsert]) then
    TFIndividu(GFormIndividu).QueryIndividu.Edit;
  ItemMenu:=Sender as TMenuItem;
  ItemMenu.Checked:=not ItemMenu.Checked;
  i:=0;
  if mIndividuconfidentiel.Checked then
    i:=i or _i_IndiConf;
  if mSansalertesurdates.Checked then
    i:=i or _i_SansCtrlDates;
  if mIdentiteIncertaine.Checked then
    i:=i or _i_IdentiteIncertaine;
  if mContinuerRecherches.Checked then
    i:=i or _i_ContinuerRecherches;
  TFIndividu(GFormIndividu).QueryIndividuIND_CONFIDENTIEL.AsInteger:=i;
  if TFIndividu(GFormIndividu).QueryIndividuIND_CONFIDENTIEL.AsInteger>0 then
    LabelParamDivers.Font.Color:=clRed
  else
    LabelParamDivers.Font.Color:=clWindowText;
end;

procedure TFIndividuIdentite.LabelParamDiversMouseEnter(Sender:TObject);
begin
  (Sender as TLabel).Font.Style:=(Sender as TLabel).Font.Style+ [fsUnderline];
end;

procedure TFIndividuIdentite.LabelParamDiversMouseLeave(Sender:TObject);
begin
  (Sender as TLabel).Font.Style:=(Sender as TLabel).Font.Style- [fsUnderline];
end;


procedure TFIndividuIdentite.tvConjEnfantsMouseMove(Sender:TObject;
  Shift:TShiftState;X,Y:Integer);
var
  Noeud:PVirtualNode;
  Col:integer;

begin
  Noeud:= tvConjEnfants.GetNodeAt(X,Y);
  if Noeud<>nil then
  with tvConjEnfants,Noeud^ do
  begin
    if (Parent=nil)and(X>20)and(X<38) then
      Col:=0
    else if (Parent<>nil)and(parent^.parent=RootNode)and(X>40)and(X<58) then
      Col:=1
    else
      Col:=3;
  end
  else
    Col:=4;
  if (Noeud<>NoeudSurvolTv)or(Col<>ColSurvolTv)or(Noeud=nil) then
  with tvConjEnfants,Noeud^ do
  begin
    if Noeud<>nil then
    begin
      Application.CancelHint;
      if Col<3 then
        Cursor:=crHandPoint
      else
        Cursor:=_CURPOPUP;
      if (Parent<>nil)and(parent^.parent=RootNode)and not TFIndividu(GFormIndividu).DialogMode then
        DragMode:=dmAutomatic
      else
        DragMode:=dmManual;
      pmTvConjEnfants.AutoPopup:=true;
      Application.ShowHint:=True;
      tvConjEnfants.Hint:=PNodeIndividu(GetNodeData(Noeud))^.FHint;
      dm.TimerHint.Interval:=Max(3000,length(Hint)*80);
      dm.TimerHint.Enabled:=True;
    end
    else
    begin
      Cursor:=crDefault;
      DragMode:=dmManual;
      pmTvConjEnfants.AutoPopup:=false;
      Application.ShowHint:=gci_context.CanSeeHint;
      if gci_context.CanSeeHint and (Hint<>rs_Hint_Double_clic_open_individual_file) then
      begin
        Application.CancelHint;
        tvConjEnfants.Hint:=rs_Hint_Double_clic_open_individual_file;
      end;
    end;
    tvConjEnfants.ShowHint:=tvConjEnfants.Hint>'';
    NoeudSurvolTv:=Noeud;
    ColSurvolTv:=Col;
  end;
end;

procedure TFIndividuIdentite.AfficheSosa;
var
  i,generation,sexe,degre_1,degre_2:integer;
  sosa:Double;
begin
  with TFIndividu(GFormIndividu).QueryIndividu do
   begin
    if not Active Then Exit;
    sosa:=FieldByName('NUM_SOSA').AsFloat;
   end;
  if not(sosa>0) then
    if gci_context.AvecLienGene then
      if dm.iSosa1>0 then
        if gci_context.CalculParenteAuto then
          if not TFIndividu(GFormIndividu).ParenteCalculee then
          begin
            PlusdinformationsClick(nil);
            exit;//relance AfficheSosa avec ParenteCalculee=true en fin d'exécution
          end;

  lSosa.Hint:=rs_Hint_Look_at_ancestry;
  Plusdinformations.Visible:=false;
  LiensAncetreCommun.Visible:=false;
  LiensAvecSosa1.Visible:=false;
  sexe:=TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger;
  if sosa>0 then
  begin
    lSosa.Visible:=true;
    generation:=Trunc(Log2(sosa))+1;
    lSosa.Caption:=fs_RemplaceMsg(rs_Caption_SOSA_No_Generation,
                   [FloatToStr(sosa),IntToStr(generation)]);
    LiensAncetreCommun.Visible:=true;
    LiensAvecSosa1.Visible:=true;
//    lTitre.Font.Color:=_COLOR_SOSA; //fait dans RefreshControls
  end
  else //sosa null
  begin
    if gci_context.AvecLienGene then
    begin
      lSosa.Visible:=True;
      if dm.iSosa1=0 then
      begin
        lSosa.Caption:=rs_Caption_SOSA_No_1_not_defined_in_folder;
        lSosa.Hint:='';
      end
      else
      begin
        LiensAncetreCommun.Visible:=true;
        LiensAvecSosa1.Visible:=true;
        Plusdinformations.Visible:=not TFIndividu(GFormIndividu).ParenteCalculee;
        if TFIndividu(GFormIndividu).QueryIndividuTYPE_LIEN_GENE.IsNull then
        begin
          lSosa.Caption:=rs_Caption_Unknown_genealogy_link_with_SOSA_no_1;
          if TFIndividu(GFormIndividu).ParenteCalculee then
          begin
            LiensAncetreCommun.Visible:=false;
          end;
        end
        else
        begin
          i:=TFIndividu(GFormIndividu).QueryIndividuTYPE_LIEN_GENE.AsInteger and $FFFFFF03;
          if i=0 then //éliminer 4 qui a été utilisé comme marqueur de l'exécution du calcul
          begin
            lSosa.Caption:=rs_Caption_No_link_to_SOSA_no_1_genealogy;
            if TFIndividu(GFormIndividu).ParenteCalculee then
            begin
              LiensAncetreCommun.Visible:=false;
            end;
          end
          else if i=1 then //liaison uniquement par témoin
          begin
            if sexe=2 then
              lSosa.Caption:=rs_Caption_Witness_link_to_SOSA_no_1_female
            else
              lSosa.Caption:=rs_Caption_Witness_link_to_SOSA_no_1_male;
            if TFIndividu(GFormIndividu).ParenteCalculee then
            begin
              LiensAncetreCommun.Visible:=false;
            end;
          end
          else if (i and $0000FF00)>0 then
          begin//bits 8 à 15=descendants du SOSA n°1
            generation:=(i and $0000FF00)shr 8;
            if sexe=2 then
              lSosa.Caption:=fs_RemplaceMsg(rs_Caption_Descending_at_arggeneration_female ,[IntToStr(generation)])
            else
              lSosa.Caption:=fs_RemplaceMsg(rs_Caption_Descending_at_arggeneration_male,[IntToStr(generation)]);
            if generation=1 then
              lSosa.Caption:=fs_RemplaceMsg(lSosa.Caption,[rs_generation_minus])
            else
              lSosa.Caption:=fs_RemplaceMsg(lSosa.Caption,[rs_generations_minus]);
          end
          else if i and $FFFF0000>0 then
          begin
            degre_1:=i shr 24;
            degre_2:=(i and $00FF0000)shr 16;
            if sexe=2 then
              lSosa.Caption:=fs_RemplaceMsg(rs_Caption_Degrees_of_ancestry_to_SOSA_no_1_female ,[IntToStr(degre_1)+'+'+IntToStr(degre_2)])
            else
              lSosa.Caption:=fs_RemplaceMsg(rs_Caption_Degrees_of_ancestry_to_SOSA_no_1_male,[IntToStr(degre_1)+'+'+IntToStr(degre_2)]);
          end
          else //i=3
          begin
            if sexe=2 then
              lSosa.Caption:=rs_Caption_Linked_to_SOSA_no_1_genealogy_female
            else
              lSosa.Caption:=rs_Caption_Linked_to_SOSA_no_1_genealogy_male;
            if TFIndividu(GFormIndividu).ParenteCalculee then
            begin
              LiensAncetreCommun.Visible:=false;
            end;
          end;
        end;//de not QueryIndividuTYPE_LIEN_GENE.IsNull else
      end;//de dm.iSosa1=0 else
    end
    else //de gci_context.AvecLienGene
      lSosa.Visible:=false;
  end;//de sosa null
  lSosa.ShowHint:=lSosa.Hint>'';
  pmSosa.AutoPopup:=LiensAncetreCommun.Visible or LiensAvecSosa1.Visible or Plusdinformations.Visible;
end;

procedure TFIndividuIdentite.PlusdinformationsClick(Sender:TObject);
var
  degre_1,degre_2,i,GenDesc,ValLien:integer;
begin
  degre_1:=0;
  degre_2:=0;
  dm.IBTrans_Courte.StartTransaction;
  with ReqParente do
   Begin
    Params[0].AsInteger:=TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsInteger;
    Params[1].AsInteger:=dm.iSosa1;
   end;
  i:=0;
  while i<5 do
  try
    ReqParente.ExecQuery;
    if not ReqParente.Eof then
    begin
      degre_1:=ReqParente.Fields[0].AsInteger;
      degre_2:=ReqParente.Fields[1].AsInteger;
    end;
    ReqParente.Close;
    dm.IBTrans_Courte.Commit;
    i:=6;
  except
    ReqParente.Close;
    dm.IBTrans_Courte.Rollback;
    inc(i);
    Sleep(500);
  end;
  if i<>5 then
  begin
    if degre_2=0 then //c'est un descendant
      GenDesc:=degre_1
    else
      GenDesc:=0;
    ValLien:=(degre_1 shl 24)or(degre_2 shl 16)or(GenDesc shl 8)//or 4
      or(TFIndividu(GFormIndividu).QueryIndividuTYPE_LIEN_GENE.AsInteger and $000000FF);
    if TFIndividu(GFormIndividu).QueryIndividuTYPE_LIEN_GENE.AsInteger<>ValLien then
    try
      TFIndividu(GFormIndividu).bOpen:=false;//empêche le DoRefreshControls général
      if not(TFIndividu(GFormIndividu).QueryIndividu.State in [dsEdit,dsInsert]) then
        TFIndividu(GFormIndividu).QueryIndividu.Edit;
      TFIndividu(GFormIndividu).QueryIndividuTYPE_LIEN_GENE.AsInteger:=ValLien;
      if not TFIndividu(GFormIndividu).Modified then
      begin
        dm.doActiveTriggerMajDate(false);
        TFIndividu(GFormIndividu).QueryIndividu.Post;
        dm.doActiveTriggerMajDate(true);
        dm.IBT_base.CommitRetaining;
      end;
    finally
      TFIndividu(GFormIndividu).bOpen:=true;
    end;
  end;
  TFIndividu(GFormIndividu).ParenteCalculee:=true;//avant AfficheSosa pour éviter le bouclage
  AfficheSosa;
end;

procedure TFIndividuIdentite.CreatFichEvInd(const LibCourt,LibLong:string);
var ANode : PVirtualNode;
begin
  if IBQEve.State in [dsInsert,dsEdit] then
    IBQEve.Post;
  IBQEve.DisableControls;
  IBQEve.Insert;
  IBQEveEV_IND_TYPE.AsString:=LibCourt;
  if LibCourt='EVEN' then
    IBQEveEV_IND_TITRE_EVENT.AsString:=LibLong
  else if LibCourt='BIRT' then
    btnNaissance.Enabled:=false
  else if LibCourt='DEAT' then
    btnDeces.Enabled:=false;
  IBQEve.Post;
  TFIndividu(GFormIndividu).doBouton(true);
  IBQEve.EnableControls;
  btnDeleteEvent.Enabled:=True;

  aFIndividuEditEventLife.Show;
  if LibCourt='OCCU' then
  begin
    SendFocus(aFIndividuEditEventLife.edDesc);
//    aFIndividuEditEventLife.edDesc.DroppedDown:=true;
  end
  else if LibCourt='EVEN' then
    SendFocus(aFIndividuEditEventLife.dbcbDivers)
  else if (LibCourt='CAST')
    or(LibCourt='DSCR')
    or(LibCourt='EDUC')
    or(LibCourt='EMIG')
    or(LibCourt='GRAD')
    or(LibCourt='IDNO')
    or(LibCourt='IMMI')
    or(LibCourt='NATI')
    or(LibCourt='NATU')
    or(LibCourt='PROP')
    or(LibCourt='RELI')
    or(LibCourt='SSN')
    or(LibCourt='TITL') then
    SendFocus(aFIndividuEditEventLife.edDesc)
  else
    SendFocus(aFIndividuEditEventLife.edDate);
end;

procedure TFIndividuIdentite.mCopierEvenementClick(Sender:TObject);
begin
  if not IBQEve.IsEmpty then
    dm.EvIndEnMemoire:=IBQEveEV_IND_CLEF.AsInteger;
end;

procedure TFIndividuIdentite.mCollerEvenementClick(Sender:TObject);
var
  id_ev_ind:integer;
begin
  if TFIndividu(GFormIndividu).CollerEvenement(id_ev_ind) then
  begin
    TFIndividu(GFormIndividu).doOpenFiche(dm.individu_clef);
    IBQEve.Locate('EV_IND_CLEF',id_ev_ind, []);

    aFIndividuEditEventLife.Show;
    SendFocus(aFIndividuEditEventLife.edDate);
  end;
end;

procedure TFIndividuIdentite.AfficheMariageParents;
var
  s,sd:string;
  OK:boolean;
begin
  with IBQmariageParents do
  begin
   with TFIndividu(GFormIndividu) do
    Begin
      if not QueryIndividu.Active Then Exit;
      Params[0].AsInteger:=QueryIndividuCLE_FICHE.AsInteger;
    end;
    ExecQuery;
    if Eof then
    begin
      lbNomPere.Caption:='';
      lbNeLeDecesLePere.Caption:='';
      lbNeLeDecesLePere.Hint:='';
      lbNomMere.Caption:='';
      lbNeLeDecesLeMere.Caption:='';
      lbNeLeDecesLeMere.Hint:='';
      lbMariageParents.Caption:='';
      lbMariageParents.Hint:='';
    end
    else
    begin
      // On fabrique le nom du pere
      if Length(FieldByName('NOM_PERE').AsString)>0 then
      begin
        lbNomPere.Caption:=AssembleString([FieldByName('NOM_PERE').AsString,
          FieldByName('PRENOM_PERE').AsString]);
        s:=trim(FieldByName('PERE_NAISSANCE').AsString);
        if s>'' then
        begin
          OK:=_GDate.DecodeHumanDate(s);
          if OK and(_GDate.Key1='') then
          begin
            if _GDate.Day1>0 then
              s:='né le '+s
            else
              s:='né en '+s;
          end
          else
            s:='né '+s;
        end;
        sd:=trim(FieldByName('PERE_DECES').AsString);
        if sd>'' then
        begin
          OK:=_GDate.DecodeHumanDate(sd);
          if OK and(_GDate.Key1='') then
          begin
            if _GDate.Day1>0 then
              sd:='décédé le '+sd
            else
              sd:='décédé en '+sd;
          end
          else
            sd:='décédé '+sd;
          if s>'' then
            s:=s+' / ';
        end;
        s:=s+sd;
        lbNeLeDecesLePere.Caption:=s;
        lbNeLeDecesLePere.Hint:=AssembleString([FieldByName('pere_subd_naissance').AsString
          ,FieldByName('pere_ville_naissance').AsString
            ,FieldByName('pere_dept_naissance').AsString]);
        if gci_context.AfficheRegiondansListeEV then
          lbNeLeDecesLePere.Hint:=AssembleString([lbNeLeDecesLePere.Hint
            ,FieldByName('pere_region_naissance').AsString
              ,FieldByName('pere_pays_naissance').AsString])
        else
          lbNeLeDecesLePere.Hint:=AssembleString([lbNeLeDecesLePere.Hint
            ,FieldByName('pere_pays_naissance').AsString]);
        s:=AssembleString([FieldByName('pere_subd_deces').AsString
          ,FieldByName('pere_ville_deces').AsString
            ,FieldByName('pere_dept_deces').AsString]);
        if gci_context.AfficheRegiondansListeEV then
          s:=AssembleString([s
            ,FieldByName('pere_region_deces').AsString
              ,FieldByName('pere_pays_deces').AsString])
        else
          s:=AssembleString([s,FieldByName('pere_pays_deces').AsString]);
        if lbNeLeDecesLePere.Hint>'' then
          lbNeLeDecesLePere.Hint:=fs_RemplaceMsg(rs_Born_in_male,[lbNeLeDecesLePere.Hint]);
        if s>'' then
        begin
          if lbNeLeDecesLePere.Hint>'' then
            lbNeLeDecesLePere.Hint:=lbNeLeDecesLePere.Hint+_CRLF;
          lbNeLeDecesLePere.Hint:=lbNeLeDecesLePere.Hint+fs_RemplaceMsg(rs_Death_in_male,[s]);
        end;
        if (FieldByName('PERE_SOSA').AsFloat>0) then
          lbNomPere.Font.Color:=_COLOR_SOSA
        else
          lbNomPere.Font.Color:=gci_context.ColorHomme;
      end
      else
      begin
        lbNomPere.Font.Color:=gci_context.ColorHomme;
        lbNomPere.Caption:='';
        lbNeLeDecesLePere.Caption:='';
        lbNeLeDecesLePere.Hint:='';
      end;
      // On fabrique le nom de la mère
      if Length(FieldByName('NOM_MERE').AsString)>0 then
      begin
        lbNomMere.Caption:=AssembleString([FieldByName('NOM_MERE').AsString,
          FieldByName('PRENOM_MERE').AsString]);
        s:=trim(FieldByName('MERE_NAISSANCE').AsString);
        if s>'' then
        begin
          OK:=_GDate.DecodeHumanDate(s);
          if OK and(_GDate.Key1='') then
          begin
            if _GDate.Day1>0 then
              s:='née le '+s
            else
              s:='née en '+s;
          end
          else
            s:='née '+s;
        end;
        sd:=trim(FieldByName('MERE_DECES').AsString);
        if sd>'' then
        begin
          OK:=_GDate.DecodeHumanDate(sd);
          if OK and(_GDate.Key1='') then
          begin
            if _GDate.Day1>0 then
              sd:='décédée le '+sd
            else
              sd:='décédée en '+sd;
          end
          else
            sd:='décédée '+sd;
          if s>'' then
            s:=s+' / ';
        end;
        s:=s+sd;
        lbNeLeDecesLeMere.Caption:=s;
        lbNeLeDecesLeMere.Hint:=AssembleString([FieldByName('mere_subd_naissance').AsString
          ,FieldByName('mere_ville_naissance').AsString
            ,FieldByName('mere_dept_naissance').AsString]);
        if gci_context.AfficheRegiondansListeEV then
          lbNeLeDecesLeMere.Hint:=AssembleString([lbNeLeDecesLeMere.Hint
            ,FieldByName('mere_region_naissance').AsString
              ,FieldByName('mere_pays_naissance').AsString])
        else
          lbNeLeDecesLeMere.Hint:=AssembleString([lbNeLeDecesLeMere.Hint
            ,FieldByName('mere_pays_naissance').AsString]);
        s:=AssembleString([FieldByName('mere_subd_deces').AsString
          ,FieldByName('mere_ville_deces').AsString
            ,FieldByName('mere_dept_deces').AsString]);
        if gci_context.AfficheRegiondansListeEV then
          s:=AssembleString([s,FieldByName('mere_region_deces').AsString
            ,FieldByName('mere_pays_deces').AsString])
        else
          s:=AssembleString([s,FieldByName('mere_pays_deces').AsString]);
        if lbNeLeDecesLeMere.Hint>'' then
          lbNeLeDecesLeMere.Hint:=fs_RemplaceMsg(rs_Born_in_female,[lbNeLeDecesLeMere.Hint]);
        if s>'' then
        begin
          if lbNeLeDecesLeMere.Hint>'' then
            lbNeLeDecesLeMere.Hint:=lbNeLeDecesLeMere.Hint+_CRLF;
          lbNeLeDecesLeMere.Hint:=lbNeLeDecesLeMere.Hint+fs_RemplaceMsg(rs_Death_in_female,[s]);
        end;
        if (FieldByName('MERE_SOSA').AsFloat>0) then
          lbNomMere.Font.Color:=_COLOR_SOSA
        else
          lbNomMere.Font.Color:=gci_context.ColorFemme;
      end
      else
      begin
        lbNomMere.Font.Color:=gci_context.ColorFemme;
        lbNomMere.Caption:='';
        lbNeLeDecesLeMere.Caption:='';
        lbNeLeDecesLeMere.Hint:='';
      end;
      if TFIndividu(GFormIndividu).QueryIndividuNUM_SOSA.AsFloat>0 then
      begin
        lbNomPere.Font.Color:=_COLOR_SOSA;
        lbNomMere.Font.Color:=_COLOR_SOSA;
      end;
      lbMariageParents.Caption:=FieldByName('DATE_UNION_PARENTS').AsString;
      lbMariageParents.Hint:=AssembleString([FieldByName('ev_fam_subd').AsString
        ,FieldByName('ev_fam_ville').AsString
          ,FieldByName('ev_fam_dept').AsString]);
      if gci_context.AfficheRegiondansListeEV then
        lbMariageParents.Hint:=AssembleString([lbMariageParents.Hint
          ,FieldByName('ev_fam_region').AsString
            ,FieldByName('ev_fam_pays').AsString])
      else
        lbMariageParents.Hint:=AssembleString([lbMariageParents.Hint
          ,FieldByName('ev_fam_pays').AsString]);
    end;
    Close;
  end;
  lbMariageParents.Visible:=lbMariageParents.Caption>'';
  lbMariageParents.ShowHint:=lbMariageParents.Hint>'';
  lbNeLeDecesLePere.ShowHint:=lbNeLeDecesLePere.Hint>'';
  lbNeLeDecesLeMere.ShowHint:=lbNeLeDecesLeMere.Hint>'';
  lbNomPere.Visible:=lbNomPere.Caption>'';
  lbNomMere.Visible:=lbNomMere.Caption>'';
end;

procedure TFIndividuIdentite.LiensAvecSosa1Click(Sender:TObject);
var
  ValLien:integer;
begin
  ValLien:=0;
  if FMain.OuvreLienIndividus(dm.iSosa1,TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsInteger) then
    ValLien:=3;//lié d'une manière générale on ignore si par témoins uniquement
  if TFIndividu(GFormIndividu).DialogMode then
    exit;
  if (((TFIndividu(GFormIndividu).QueryIndividuTYPE_LIEN_GENE.AsInteger and 3)=0)and(ValLien=3))
    or(((TFIndividu(GFormIndividu).QueryIndividuTYPE_LIEN_GENE.AsInteger and 3)>0)and(ValLien=0)) then
  try
    ValLien:=(TFIndividu(GFormIndividu).QueryIndividuTYPE_LIEN_GENE.AsInteger and $FFFFFFFC)or ValLien;
    TFIndividu(GFormIndividu).bOpen:=false;//empêche le DoRefreshControls général
    if not(TFIndividu(GFormIndividu).QueryIndividu.State in [dsEdit,dsInsert]) then
      TFIndividu(GFormIndividu).QueryIndividu.Edit;
    TFIndividu(GFormIndividu).QueryIndividuTYPE_LIEN_GENE.AsInteger:=ValLien;
    if not TFIndividu(GFormIndividu).Modified then
    begin
      dm.doActiveTriggerMajDate(false);
      TFIndividu(GFormIndividu).QueryIndividu.Post;
      dm.doActiveTriggerMajDate(true);
      dm.IBT_base.CommitRetaining;
    end;
    AfficheSosa;

  finally
    TFIndividu(GFormIndividu).bOpen:=true;
  end;
end;

procedure TFIndividuIdentite.mOuvrirEvenementClick(Sender:TObject);
begin
  AfficheDetailsEvent;
end;

procedure TFIndividuIdentite.pmTvConjEnfantsPopup(Sender:TObject);
var
  i:integer;
begin
  for i:=pmTvConjEnfants.Items.Count-1 downto 6 do
    pmTvConjEnfants.Items[i].Free;
  with tvConjEnfants do
  if FocusedNode<>nil then
    FMain.RempliPopMenuParentsConjointsEnfants(pmTvConjEnfants
      ,PNodeIndividu(GetNodeData(FocusedNode))^.fCleFiche
      ,PNodeIndividu(GetNodeData(FocusedNode))^.FSexe,false);
  pmTvConjEnfants.Items[0].Default:=true;
  for i:=pmTvConjEnfants.Items.Count-1 downto 6 do
    pmTvConjEnfants.Items[i].Default:=pmTvConjEnfants.Items[i].Tag=TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsInteger;
end;

procedure TFIndividuIdentite.pmPerePopup(Sender:TObject);
var
  i:integer;
begin
  for i:=pmPere.Items.Count-1 downto 0 do
    pmPere.Items[i].Free;
  FMain.RempliPopMenuParentsConjointsEnfants(pmPere
    ,TFIndividu(GFormIndividu).QueryIndividuCLE_PERE.AsInteger,1,false);
  for i:=pmPere.Items.Count-1 downto 0 do
    pmPere.Items[i].Default:=pmPere.Items[i].Tag=TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsInteger;
end;

procedure TFIndividuIdentite.pmMerePopup(Sender:TObject);
var
  i:integer;
begin
  for i:=pmMere.Items.Count-1 downto 0 do
    pmMere.Items[i].Free;
  FMain.RempliPopMenuParentsConjointsEnfants(pmMere
    ,TFIndividu(GFormIndividu).QueryIndividuCLE_MERE.AsInteger,2,false);
  for i:=pmMere.Items.Count-1 downto 0 do
    pmMere.Items[i].Default:=pmMere.Items[i].Tag=TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsInteger;
end;

procedure TFIndividuIdentite.tvConjEnfantsMouseDown(Sender:TObject;
  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
var
  Noeud:PVirtualNode;
begin
  Noeud:=tvConjEnfants.GetNodeAt(X,Y);
  with tvConjEnfants do
  if Noeud<>nil then
  begin
    FocusedNode:=Noeud;
  end;
end;

procedure TFIndividuIdentite.mSupprimerOrdreClick(Sender:TObject);
var
  q:TIBSQL;
begin
  q:=TIBSQL.Create(self);
  with tvConjEnfants do
  try
    q.Database:=dm.ibd_BASE;
    q.Transaction:=dm.IBT_BASE;
    q.SQL.Text:='update individu set cle_parents=null'
      +' where cle_pere is not distinct from (select cle_pere from individu where cle_fiche=:indi)'
      +' and cle_mere is not distinct from (select cle_mere from individu where cle_fiche=:indi)';
    q.ParamByName('indi').AsInteger:=PNodeIndividu(GetNodeData(FocusedNode))^.fCleFiche;
    q.ExecQuery;
  finally
    q.Free;
  end;
  RempliConjEnfants;
  TFIndividu(GFormIndividu).doBouton(true);
end;

procedure TFIndividuIdentite.tvConjEnfantsDragOver(Sender,Source:TObject;
  X,Y:Integer;State:TDragState;var Accept:Boolean);
var
  NoeudSurvole,NoeudDrag:PVirtualNode;
  i:integer;
begin
  if TFIndividu(GFormIndividu).DialogMode then
  begin
    Accept:=false;//sinon autorise le DragAndDrop de la fiche normale à la fiche en consultation
    exit;
  end;
  try
    NoeudSurvole:=tvConjEnfants.GetNodeAt(X,Y);
    if Source=tvConjEnfants then //DragAndDrop d'un conjoint ou d'un enfant
    begin
      NoeudDrag:=tvConjEnfants.FocusedNode;
      if NoeudSurvole<>nil then
        Accept:=NoeudSurvole<>NoeudDrag
      else
        Accept:=true;
    end
    else if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=0 then
      Accept:=False//on ne peut ajouter un conjoint ou un enfant à un individu sans sexe connu
    else if TFIndividu(GFormIndividu).CleFiche=FMain.IndiDrag.cle then
      Accept:=False//on ne peut ajouter l'individu lui-même
    else if (GetKeyState(VK_SHIFT)<0)
      and ((TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=FMain.IndiDrag.sexe)
        or (FMain.IndiDrag.sexe=0) or (not btnAjoutConjoint.Visible) or (not btnAjoutConjoint.Enabled)) then //ajout d'un conjoint
      Accept:=False//on ne peut ajouter un conjoint du même sexe ni de sexe nul
    else
    begin
      //on ne peut pas ajouter un individu qui y est déjà
      Accept:=not TreeNodeIsPresent(tvConjEnfants,FMain.IndiDrag.cle);
    end;
  except
    Accept:=false;
  end;
end;

procedure TFIndividuIdentite.t(Sender,Source:TObject;
  X,Y:Integer);
var
  NoeudSurvole,NoeudDrag:PVirtualNode;
  i,s,d,sexe:integer;
  NbConjoints,conjoint,pere,mere:integer;
  sconjoint,spere,smere:string;
  q:TIBSQL;
begin
  with tvConjEnfants do
  try
    NoeudDrag:=FocusedNode;
    NoeudSurvole:=GetNodeAt(X,Y);
    if Source=tvConjEnfants then
    begin
      if (NoeudSurvole<>nil)and((NoeudDrag.Parent=NoeudSurvole.Parent)or(NoeudDrag.Parent=NoeudSurvole)) then
      begin//définition de l'ordre des enfants
        if NoeudDrag.Parent=NoeudSurvole then
          NoeudSurvole:=NoeudSurvole^.FirstChild;
        d:=NoeudDrag.Index;
        s:=NoeudSurvole.Index;
        q:=TIBSQL.Create(self);
        try
          q.Database:=dm.ibd_BASE;
          q.Transaction:=dm.IBT_BASE;
          q.SQL.Add('update individu set cle_parents=:ordre where cle_fiche=:indi');
          NoeudDrag:=NoeudDrag^.Parent^.FirstChild;
          while NoeudDrag<>nil do
          begin
            q.ParamByName('indi').AsInteger:=PNodeIndividu(GetNodeData(NoeudDrag))^.fCleFiche;
            if ((i<s)and(i<d))or((i>s)and(i>d)) then
              q.ParamByName('ordre').AsInteger:=i
            else if s>d then
            begin
              if i=d then
                q.ParamByName('ordre').AsInteger:=s
              else if i<s then
                q.ParamByName('ordre').AsInteger:=i-1
              else
                q.ParamByName('ordre').AsInteger:=s-1;
            end
            else
            begin
              if i=s then
                q.ParamByName('ordre').AsInteger:=s+1
              else if i<d then
                q.ParamByName('ordre').AsInteger:=i+1
              else
                q.ParamByName('ordre').AsInteger:=s;
            end;
            q.ExecQuery;
            NoeudDrag:=NoeudDrag^.NextSibling;
          end;
        finally
          q.Free;
        end;
      end
      else //changement du parent/conjoint
      begin
        if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=1 then
          sexe:=2
        else
          sexe:=1;
        if NoeudSurvole<>nil then
        with NoeudSurvole^ do
          while Parent<>nil do
            NoeudSurvole:=Parent;
        with PNodeIndividu(GetNodeData(NoeudDrag))^do
         Begin
          if PNodeIndividu(GetNodeData(NoeudDrag^.Parent)).fCleFiche>0 then //le détache du conjoint précédent
            SupprimeParent(fCleFiche,sexe);
          if (NoeudSurvole<>nil)and(PNodeIndividu(GetNodeData(NoeudSurvole)).fCleFiche>0) then
          begin
            if sexe=1 then
              DefiniParents(fCleFiche
                ,PNodeIndividu(GetNodeData(NoeudSurvole)).fCleFiche
                ,TFIndividu(GFormIndividu).CleFiche)
            else
              DefiniParents(fCleFiche
                ,TFIndividu(GFormIndividu).CleFiche
                ,PNodeIndividu(GetNodeData(NoeudSurvole)).fCleFiche);
          end;
         end;
      end;
      RempliConjEnfants;
      TFIndividu(GFormIndividu).doBouton(true);
    end
    else
    begin
      if (GetKeyState(VK_SHIFT)<0) then //on veut ajouter un conjoint
      begin
        if TFIndividu(GFormIndividu).TestAscDesc(TFIndividu(GFormIndividu).CleFiche
          ,FMain.IndiDrag.cle
          ,TFIndividu(GFormIndividu).GetNomIndividu
          ,FMain.IndiDrag.nomprenom
          ,true,true) then //possible si inceste
          exit;
        if TFIndividu(GFormIndividu).aFIndividuUnion.CreationUnion(FMain.IndiDrag.cle) then
        begin
          TFIndividu(GFormIndividu).doActiveOnglet(_ONGLET_SES_CONJOINTS);
          TFIndividu(GFormIndividu).aFIndividuUnion.doGoto(FMain.IndiDrag.cle);
          if gci_context.CreationMARRConjoint then
            TFIndividu(GFormIndividu).aFIndividuUnion.CreationEvFam('MARR','');
        end;
      end
      else //on veut ajouter un enfant
      begin
        if not AutoriseSupprimeParents(FMain.IndiDrag.cle) then
          exit;
        //vérifier si indi principal et enfant pas déjà dans ascdesc
        if TFIndividu(GFormIndividu).TestAscDesc(TFIndividu(GFormIndividu).CleFiche
          ,FMain.IndiDrag.cle
          ,TFIndividu(GFormIndividu).GetNomIndividu
          ,FMain.IndiDrag.nomprenom
          ,false,false) then //les 2 cas impossibles puisque asc impossible et filiation supprimée si elle existait
          exit;
        if NoeudSurvole<>nil then
        begin
          while NoeudSurvole^.Parent<>nil do
            NoeudSurvole:=NoeudSurvole^.Parent;
          with PNodeIndividu(GetNodeData(NoeudSurvole))^ do
           Begin
            conjoint:=fCleFiche;
            sconjoint:=fNomComplet;
           end;
        end
        else
        begin
          conjoint:=0;
          sconjoint:='';
        end;
        //vérifier si enfant et conjoint pas dans ascdesc
        if TFIndividu(GFormIndividu).TestAscDesc(conjoint
          ,FMain.IndiDrag.cle
          ,sconjoint
          ,FMain.IndiDrag.nomprenom
          ,false,false) then //les 2 cas impossibles puisque asc impossible et filiation supprimée si elle existait
          exit;

        if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=1 then
        begin
          pere:=TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsInteger;
          spere:=TFIndividu(GFormIndividu).GetNomIndividu;
          mere:=conjoint;
          smere:=sconjoint;
        end
        else
        begin
          mere:=TFIndividu(GFormIndividu).QueryIndividuCLE_FICHE.AsInteger;
          smere:=TFIndividu(GFormIndividu).GetNomIndividu;
          pere:=conjoint;
          spere:=sconjoint;
        end;
        //vérifier si indi principal et conjoint pas dans ascdesc trop éloignée
        if TFIndividu(GFormIndividu).TestAscDesc(mere
          ,pere
          ,sMere
          ,sPere
          ,true,true) then //possible si inceste
          exit;

        DefiniParents(FMain.IndiDrag.cle,pere,mere);
        TFIndividu(GFormIndividu).doBouton(True);
        TFIndividu(GFormIndividu).TestCoherenceDates;
        NbConjoints:=NbrConjoints;
        RempliConjEnfants;//on met à jour le tv
        if NbrConjoints<>NbConjoints then
          if TFIndividu(GFormIndividu).OngletSesConjointsIsLoaded then
            TFIndividu(GFormIndividu).aFIndividuUnion.doOpenQuerys(true);
        TFIndividu(GFormIndividu).DoRefreshControls;
      end;
      tvConjEnfants.SetFocus;
    end;
  finally
    Abort;//pour ne pas effectuer le déplacement par défaut
  end;
end;

procedure TFIndividuIdentite.SynchroHistoire;
begin
  if Assigned(_FormHistoire) then
  begin
    _FormHistoire.doPosition(IBQEveEV_IND_CLEF.AsInteger,0);
    clef_ev_histoire:=IBQEveEV_IND_CLEF.AsInteger;
  end;
end;

procedure TFIndividuIdentite.dsEveDataChange(Sender:TObject;
  Field:TField);
begin
  with IBQEve do
  if Active
  and ( clef_ev_histoire<>FieldByName('EV_IND_CLEF').AsInteger ) then
  begin
    SynchroHistoire;
  end;
end;

procedure TFIndividuIdentite.IBQEveBeforeScrollOrClose(DataSet:TDataSet);
var
  bDetail_ev_ind:boolean;
begin
  bDetail_ev_ind:=TFIndividu(GFormIndividu).Temporisation;
  if IBQEve.State in [dsInsert,dsEdit] then
    IBQEve.Post;
  if aFIndividuEditEventLife.IBTemoins.State in [dsInsert,dsEdit] then
    aFIndividuEditEventLife.IBTemoins.Post;
  if aFIndividuEditEventLife.IBMedias.State in [dsInsert,dsEdit] then
    aFIndividuEditEventLife.IBMedias.Post;
  if bDetail_ev_ind then
    if Assigned(aFIndividuEditEventLife) then
      if aFIndividuEditEventLife.Visible then
      begin
        aFIndividuEditEventLife.Show;
      end;
end;

procedure TFIndividuIdentite.mRemplacerConjointClick(Sender:TObject);
var
  NoeudConjoint:PVirtualNode;
  A_Conjoint,Union:integer;
  NomA_Conjoint:string;
begin
  NoeudConjoint:=tvConjEnfants.FocusedNode;
  with tvConjEnfants do
  if NoeudConjoint<>nil then
  with PNodeIndividu(GetNodeData(NoeudConjoint))^ do
  begin
    while NoeudConjoint^.Parent<>nil do
      NoeudConjoint:=NoeudConjoint^.Parent;
    A_Conjoint:=fCleFiche;
    Union:=fClefUnion;
    if A_Conjoint>0 then
      NomA_Conjoint:=fNom
    else
      NomA_Conjoint:='';
    TFIndividu(GFormIndividu).RemplacerConjoint(Union,A_Conjoint,NomA_Conjoint);
  end;
end;

procedure TFIndividuIdentite.lbNeLeDecesLePereMouseEnter(Sender:TObject);
begin
  Application.ShowHint:=True;
end;

procedure TFIndividuIdentite.lbNeLeDecesLePereMouseLeave(Sender:TObject);
begin
  Application.ShowHint:=gci_context.CanSeeHint;
end;

procedure TFIndividuIdentite.Image2DblClick(Sender:TObject);
begin
  if bIdentiteVisible then
    mVoirPhotoClick(Sender);
end;

procedure TFIndividuIdentite.LabelListeEvenMouseEnter(Sender:TObject);
begin
  if IBQEve.RecordCount>1 then
  begin
    LabelListeEven.Font.Style:=LabelListeEven.Font.Style+ [fsUnderline];
    LabelListeEven.ShowHint:=True;
    LabelListeEven.Cursor:=_CURPOPUP;
  end
  else
    LabelListeEven.ShowHint:=False;
end;

procedure TFIndividuIdentite.LabelListeEvenMouseLeave(Sender:TObject);
begin
  LabelListeEven.Font.Style:=LabelListeEven.Font.Style- [fsUnderline];
  LabelListeEven.Cursor:=crDefault;
end;

procedure TFIndividuIdentite.LabelListeEvenMouseMove(Sender:TObject;
  Shift:TShiftState;X,Y:Integer);
begin
  XSouris:=X;
  YSouris:=Y;
end;

procedure TFIndividuIdentite.LabelListeEvenContextPopup(Sender:TObject;
  MousePos:TPoint;var Handled:Boolean);
begin
  LabelListeEvenClick(Sender);
end;

procedure TFIndividuIdentite.LabelListeEvenClick(Sender:TObject);
var
  NewItem:TMenuItem;
  i:integer;
  P:TPoint;
  SavePlace:TBookmark;
  LN:TStringlistUTF8;
  s:string;
begin
  if LabelListeEven.ShowHint then
  begin
    pmFiltreEven.Items.Clear;
    if IBQEve.Filtered then
    begin
      NewItem:=TMenuItem.Create(pmFiltreEven);
      pmFiltreEven.Items.Add(NewItem);
      NewItem.Caption:=rs_Caption_Delete_current_filter;
      NewItem.OnClick:=SuppressionFiltreEven;
      NewItem.ImageIndex:=5;
      NewItem:=TMenuItem.Create(pmFiltreEven);
      pmFiltreEven.Items.Add(NewItem);
      NewItem.Caption:='-';
    end;
    if IBQEve.Active and not IBQEve.IsEmpty and(IBQEve.State=dsBrowse) then
    begin
      NewItem:=TMenuItem.Create(pmFiltreEven);
      pmFiltreEven.Items.Add(NewItem);
      NewItem.Caption:=rs_Caption_Filter_events_of_this_type;
      NewItem.ImageIndex:=2;
      NewItem:=TMenuItem.Create(pmFiltreEven);
      pmFiltreEven.Items.Add(NewItem);
      NewItem.Caption:='-';
      SavePlace:=IBQEve.GetBookmark;
      IBQEve.DisableControls;
      try
        IBQEve.First;
        LN:=TStringlistUTF8.Create;
        try
          while not IBQEve.Eof do
          begin
            s:=IBQEve_LIBELLE.AsString;
            if LN.IndexOf(s)<0 then
              LN.Add(s);
            IBQEve.Next;
          end;
          LN.Sort;
          for i:=0 to LN.Count-1 do
          begin
            NewItem:=TMenuItem.Create(pmFiltreEven);
            pmFiltreEven.Items.Add(NewItem);
            NewItem.Caption:=LN[i];
            NewItem.OnClick:=ApplicationFiltreEven;
            with IBQEve do
            if Filtered then
              if Pos(LN[i],Filter)>0 then
                NewItem.Checked:=True;
          end;
        finally
          LN.Free;
        end;
      finally
        IBQEve.GotoBookmark(SavePlace);
        IBQEve.FreeBookmark(SavePlace);
        IBQEve.EnableControls;
      end;
    end;
    P:=LabelListeEven.ClientToScreen(Point(XSouris,YSouris));
    pmFiltreEven.Popup(P.X,P.Y);
  end;
end;

procedure TFIndividuIdentite.SuppressionFiltreEven(Sender:TObject);
begin
  LabelListeEven.Font.Color:=$00C16100;
  with IBQeve do
   Begin
    try
      Filtered:=False;
      Filter:='';
    finally
    end;
   end;
end;

procedure TFIndividuIdentite.ApplicationFiltreEven(Sender:TObject);
var
  Filtre:string;
begin
  LabelListeEven.Font.Color:=clRed;
  Filtre:=(Sender as TMenuItem).Caption;
  with IBQeve do
   Begin
      try
        {            Matthieu ?
        GrilleEve.DataController.Filter.Root.BoolOperatorKind:=fboAnd;
        GrilleEve.DataController.Filter.Root.Clear;
        GrilleEve.DataController.Filter.Root.AddItem(dxDBGEveColumn2,foEqual,Filtre,'Evénement');
        }
        Filter := '';
        Filtered:=True;
      finally
      end;
   end;
end;

procedure TFIndividuIdentite.panPereDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if TFIndividu(GFormIndividu).DialogMode
    or (Source=tvConjEnfants)
    or not (btnAjoutPere.Visible)
    or not btnAjoutPere.Enabled
    or (FMain.IndiDrag.sexe=2)
    or (FMain.IndiDrag.sexe=0)
    or (TFIndividu(GFormIndividu).CleFiche=FMain.IndiDrag.cle) then
    Accept:=False
  else Accept:=True;
end;

procedure TFIndividuIdentite.PanMereDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if TFIndividu(GFormIndividu).DialogMode
    or (Source=tvConjEnfants)
    or not (btnAjoutMere.Visible)
    or not btnAjoutMere.Enabled
    or (FMain.IndiDrag.sexe=1)
    or (FMain.IndiDrag.sexe=0)
    or (TFIndividu(GFormIndividu).CleFiche=FMain.IndiDrag.cle) then
    Accept:=False
  else Accept:=True;
end;

procedure TFIndividuIdentite.panPereDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  try
    AjoutePere(FMain.IndiDrag.cle,FMain.IndiDrag.nomprenom);
    FMain.SetFocus;
  Finally
    Abort;
  end;
end;

procedure TFIndividuIdentite.PanMereDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  try
    AjouteMere(FMain.IndiDrag.cle,FMain.IndiDrag.nomprenom);
    FMain.SetFocus;
  Finally
    Abort;
  end;
end;

procedure TFIndividuIdentite.mCalculssurlesdatesClick(Sender: TObject);
begin
  if (IBQEve.Active)and not IBQEve.IsEmpty then
  begin
    FMain.OuvreCalculsDates(IBQEveEV_IND_DATE_WRITEN.AsString);
  end;
end;

procedure TFIndividuIdentite.edCiviliteExit(Sender: TObject);
begin
  if DataSourceIndividu.State in [dsInsert,dsEdit] then
//    if gci_context.Civilite and edCivilite.ModifiedAfterEnter then
      RefreshTitle_Nom;
end;

procedure TFIndividuIdentite.sDBCBfiliationExit(Sender: TObject);
begin
  if DataSourceIndividu.State in [dsInsert,dsEdit] then
//    if sDBCBfiliation.ModifiedAfterEnter then
      RefreshTitle_Naissance;
end;

procedure TFIndividuIdentite.edSuffixeExit(Sender: TObject);
begin
  if DataSourceIndividu.State in [dsInsert,dsEdit] then
//    if edSuffixe.ModifiedAfterEnter then
      RefreshTitle_Nom;
end;

procedure TFIndividuIdentite.edSurnomExit(Sender: TObject);
begin
  if DataSourceIndividu.State in [dsInsert,dsEdit] then
//    if edSurnom.ModifiedAfterEnter then
      RefreshTitle_Nom;
end;



end.


