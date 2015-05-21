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
{           Ancestromania est un Logibiel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{ AL 2009 refonte complète de l'onglet Unions                           }
{-----------------------------------------------------------------------}
unit u_form_individu_Union;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
{$IFNDEF FPC}
  TPanelUnit, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  Forms,U_FormAdapt,u_comp_TYLanguage, URLLink,DB,
  IBCustomDataSet,IBUpdateSQL,IBQuery,Menus,StdCtrls,Graphics,
  Controls,ExtCtrls,Classes,
  sysutils,dialogs, u_ancestropictimages,
  U_ExtDBGrid, VirtualTrees, u_ancestropictbuttons, u_extdateedit,
  u_buttons_defs,
  u_framework_dbcomponents,IBSQL,U_ExtImage,
  U_OnFormInfoIni, ComCtrls,
  MaskEdit, u_buttons_appli, U_ExtNumEdits,
  DBCtrls, rxdbgrid, u_extsearchedit, u_scrollclones, u_extimagelist, u_extcomponent, types;
type
  { TFIndividuUnion }

  TFIndividuUnion=class(TF_FormAdapt)
    BtAjoutTemoin: TFWAdd;
    btnAddEvent: TFWAdd;
    btnDelEvent: TFWDelete;
    btnDetail: TFWXPButton;
    btnInternet: TXAWeb;
    btnVillesFavoris: TXAFavorite;
    btnVillesVoisines: TXANeighbor;
    BtSupprimeTemoin: TFWDelete;
    cxComboBoxActe: TFWDBComboBox;
    cxGridMedias: TExtDBGrid;
    cxGridTemoins: TExtDBGrid;
    DSCountries: TDatasource;
    edCause: TFWDBEdit;
    edDate: TExtDBDateEdit;
    edLatitude: TExtDBNumEdit;
    edLongitude: TExtDBNumEdit;
    edPays: TExtSearchDBEdit;
    edRegion: TFWDBEdit;
    edVille: TExtSearchDBEdit;
    fbInfosVilles: TXAInfo;
    gbEdits: TGroupBox;
    cxTabSheet1: TTabSheet;
    cxTabSheet2: TTabSheet;
    DBTextAge: TLabel;
    DBTextJour: TLabel;
    dsVilles: TDatasource;
    edCommentaires: TFWDBMemo;
    edCP: TExtSearchDBEdit;
    edDept: TFWDBEdit;
    edDesc: TFWDBComboBox;
    edHeure: TFWDBDateTimePicker;
    edInsee: TExtSearchDBEdit;
    edNotesEvenement: TFWDBMemo;
    edSources: TFWDBMemo;
    edSourcesEvenement: TFWDBMemo;
    edSubdi: TFWDBEdit;
    event_action: TExtImageList;
    event_type: TExtImageList;
    GdEve: TExtClonedPanel;
    i_source: TExtImage;
    Label3: TLabel;
    LabelA: TLabel;
    LabelParente: TLabel;
    lCause: TLabel;
    lCodePostal: TLabel;
    lDate: TLabel;
    lDepartement: TLabel;
    lDescript: TLabel;
    LinkA: TURLLink;
    LinkB: TURLLink;
    lInsee: TLabel;
    lLatitude: TLabel;
    lLongitude: TLabel;
    lPays: TLabel;
    lRegion: TLabel;
    lSubdiv: TLabel;
    lVille: TLabel;
    l_cloned: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    OngletMedias: TTabSheet;
    OngletNotes: TTabSheet;
    OngletSources: TTabSheet;
    OngletTemoins: TTabSheet;
    PageControlEve: TPageControl;
    PageControlNotesSources: TPageControl;
    Panel1: TPanel;
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
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    PanelButtons: TPanel;
    PanelbuttonsUnion: TPanel;
    PanLieu: TPanel;
    pmNom: TPopupMenu;
    popupConjoints:TPopupMenu;
    IBUEve:TIBUpdateSQL;
    dsEve:TDataSource;
    IBQEve:TIBQuery;
    mOuvrirFiche:TMenuItem;
    Language:TYLanguage;
    PaneauNom:TPanel;
    lNom:TLabel;
    Label8:TLabel;
    bsfbAjout:TFWAdd;
    bsfbRetirer:TFWDelete;
    p_events: TPanel;
    QSourcesNotesUnion:TIBQuery;
    IBUSourcesNotesUnion:TIBUpdateSQL;
    DataSourceSourceCommentUnion:TDataSource;
    IBQEveEV_FAM_CLEF:TLongintField;
    IBQEveEV_FAM_KLE_FAMILLE:TLongintField;
    IBQEveEV_FAM_KLE_DOSSIER:TLongintField;
    IBQEveEV_FAM_TYPE:TIBStringField;
    IBQEveEV_FAM_DATE_WRITEN:TIBStringField;
    IBQEveEV_FAM_DATE_YEAR:TLongintField;
    IBQEveREF_EVE_CAT:TLongintField;
    IBQEveEV_FAM_DATE:TDateField;
    IBQEveEV_FAM_CP:TIBStringField;
    IBQEveEV_FAM_VILLE:TIBStringField;
    IBQEveEV_FAM_DEPT:TIBStringField;
    IBQEveEV_FAM_PAYS:TIBStringField;
    IBQEveEV_FAM_SOURCE:TMemoField;
    IBQEveEV_FAM_COMMENT:TMemoField;
    IBQEveEV_FAM_REGION:TIBStringField;
    IBQEveEV_FAM_SUBD:TIBStringField;
    IBQEveEV_FAM_ACTE:TLongintField;
    IBQEveEV_FAM_INSEE:TIBStringField;
    IBQEveEV_FAM_HEURE:TTimeField;
    IBQEveEV_FAM_TITRE_EVENT:TIBStringField;
    IBQEveEV_FAM_DATE_MOIS:TLongintField;
    IBQEveEV_FAM_DATE_MOIS_FIN:TLongintField;
    IBQEveEV_FAM_DATE_YEAR_FIN:TLongintField;
    IBQEve_LONG_NAME_EVENT:TStringField;
    IBQEve_IMG_EVENT:TLongintField;
    IBQEve_EVE_DETAIL:TStringField;
    IBQEveEV_FAM_DESCRIPTION:TIBStringField;
    IBQEveEV_FAM_CAUSE:TIBStringField;
    IBQEveMULTI_CLEF:TLongintField;
    IBQEveEV_FAM_DETAILS:TLongintField;
    IBQEveEV_FAM_AGE_EVE:TStringField;
    IBQEveEV_FAM_JOUR_SEM:TStringField;
    IBQEveQUID_IMAGE:TLongintField;
    IBQEveQUID_SOURCES:TLongintField;
    IBQEveQUID_NOTES:TLongintField;
    IBQEveEV_FAM_LONGITUDE:TFloatField;
    IBQEveEV_FAM_LATITUDE:TFloatField;
    IBQEveEV_FAM_DATE_JOUR: TSmallintField;
    IBQEveEV_FAM_DATE_JOUR_FIN: TSmallintField;
    IBQEveEV_FAM_TYPE_TOKEN1: TSmallintField;
    IBQEveEV_FAM_TYPE_TOKEN2: TSmallintField;
    IBQEveEV_FAM_DATECODE: TLongintField;
    IBQEveEV_FAM_DATECODE_TOT: TLongintField;
    IBQEveEV_FAM_DATECODE_TARD: TLongintField;
    IBQEveEV_FAM_CALENDRIER1: TSmallintField;
    IBQEveEV_FAM_CALENDRIER2: TSmallintField;
    IBTemoinsASSOC_CLEF:TLongintField;
    IBTemoinsASSOC_KLE_IND:TLongintField;
    IBTemoinsASSOC_KLE_ASSOCIE:TLongintField;
    IBTemoinsASSOC_KLE_DOSSIER:TLongintField;
    IBTemoinsASSOC_EVENEMENT:TLongintField;
    IBTemoinsASSOC_TABLE:TStringField;
    IBTemoinsASSOC_LIBELLE:TStringField;
    IBTemoinsNOM:TStringField;
    IBTemoinsPRENOM:TStringField;
    IBTemoinsSEXE:TLongintField;
    IBTemoinsANNEE_NAISSANCE:TLongintField;
    IBTemoinsANNEE_DECES:TLongintField;
    IBTemoinsNOM_PRENOM:TStringField;
    ReqParente:TIBSQL;
    pmSupprimerHeure:TPopupMenu;
    mSupprimerheure:TMenuItem;
    pmImage:TPopupMenu;
    mImprimeActe:TMenuItem;
    pmDate:TPopupMenu;
    IBConjoints:TIBSQL;
    IBTemoins:TIBQuery;
    DSTemoins:TDataSource;
    IBUTemoins:TIBUpdateSQL;
    PmChangeFiche:TPopupMenu;
    Ouvrirlafiche1:TMenuItem;
    pmVideLieu:TPopupMenu;
    mEffacerlelieu:TMenuItem;
    IBMedias:TIBQuery;
    DSMedias:TDataSource;
    IBUMedias:TIBUpdateSQL;
    mVisualiseActe:TMenuItem;
    mRemplacerDocument:TMenuItem;
    mAjouterDocument:TMenuItem;
    mEnleverDocument:TMenuItem;
    mAjouterTemoin:TMenuItem;
    mEnleverTemoin:TMenuItem;
    PopupAjouteEve:TPopupMenu;
    mAjoutEvFam:TMenuItem;
    mSuppEvFam:TMenuItem;
    mAjouterConjoint:TMenuItem;
    mSupprimerConjoint:TMenuItem;
    N1:TMenuItem;
    N2:TMenuItem;
    mTrierEvents:TMenuItem;
    mSuppTriEvents:TMenuItem;
    mRemplacerConjoint:TMenuItem;
    N3: TMenuItem;
    Calculssurlesdates1: TMenuItem;
    ScrollBox1: TScrollBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    pmGoogle: TPopupMenu;
    mAcquerir: TMenuItem;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    TreeConj: TVirtualStringTree;
    procedure btnVillesVoisinesContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure cxGridTemoinsGetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
    procedure dsDeleteUnionStateChange(Sender:TObject);
    procedure PrepareCoordCity;
    procedure edDateChangeLabel(const DateControl: TExtDBDateEdit;
      const IsBlank: Boolean);
    procedure edVilleLocate(Sender: TObject);
    procedure GdEveCloningControl(Sender: TObject);
    procedure IBQEveAfterOpen(DataSet: TDataSet);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure TreeConjBeforeCellPaint(Sender: TBaseVirtualTree;
      ACanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure bsfbAjoutClick(Sender:TObject);
    procedure bsfbRetirerClick(Sender:TObject);
    procedure btnAddEventClick(Sender:TObject);
    procedure IBQEveNewRecord(DataSet:TDataSet);
    procedure dsEveStateChange(Sender:TObject);
    procedure btnDelEventClick(Sender:TObject);
    procedure IBQEveAfterScroll(DataSet:TDataSet);
    procedure mOuvrirFicheClick(Sender:TObject);
    procedure popupConjointsPopup(Sender:TObject);
    procedure TreeConjGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TreeConjGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure TreeConjMouseMove(Sender:TObject;Shift:TShiftState;X,
      Y:Integer);
    procedure DataSourceSourceCommentUnionStateChange(Sender:TObject);
    procedure btnDetailClick(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure IBQEveCalcFields(DataSet:TDataSet);
    procedure SuperFormDestroy(Sender:TObject);
    procedure TreeConjSelectionChanged(Sender:TObject);
    procedure PageControlNotesSourcesDrawTabEx(
      AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
    procedure edCommentairesKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure edSourcesKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure edCommentairesDblClick(Sender:TObject);
    procedure edSourcesDblClick(Sender:TObject);
    procedure edDatePropertiesChange(Sender:TObject);
    procedure mSupprimerheureClick(Sender:TObject);
    procedure edCPEnter(Sender:TObject);
    procedure edCPExit(Sender:TObject);
    procedure mImprimeActeClick(Sender:TObject);
    procedure pmImagePopup(Sender:TObject);
    procedure pmDatePopup(Sender:TObject);
    procedure edVilleMouseEnter(Sender:TObject);
    procedure EffaceBarreEtat(Sender:TObject);
    procedure edVilleEnter(Sender:TObject);
    procedure btnVillesFavorisClick(Sender:TObject);
    procedure edVillePropertiesExit(Sender:TObject);
    procedure fbInfosVillesClick(Sender:TObject);
    procedure edInseeEnter(Sender:TObject);
    procedure edInseeExit(Sender:TObject);
    procedure btnInternetPopupMenuPopup(Sender:TObject;
      var APopupMenu:TPopupMenu;var AHandled:Boolean);
    procedure cxComboBoxActePropertiesEditValueChanged(Sender:TObject);
    procedure PageControlEveChange(Sender:TObject);
    procedure edNotesEvenementKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure edSourcesEvenementKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure edSourcesEvenementDblClick(Sender:TObject);
    procedure edNotesEvenementDblClick(Sender:TObject);
    procedure IBTemoinsCalcFields(DataSet:TDataSet);
    procedure BtAjoutTemoinClick(Sender:TObject);
    procedure BtSupprimeTemoinClick(Sender:TObject);
    procedure cxGridTableTemoinsColRolePropertiesInitPopup(
      Sender:TObject);
    procedure DSTemoinsStateChange(Sender:TObject);
    procedure Ouvrirlafiche1Click(Sender:TObject);
    procedure gridEventsDBTableView1CanFocusRecord(
      Sender:TObject;ARecord:Longint;
      var AAllow:Boolean);
    procedure IBQEveBeforePost(DataSet:TDataSet);
    procedure gridEventsDBTableView1InitEdit(
      Sender:TObject;AItem:Longint;
      AEdit:TCustomMaskEdit);
    procedure edDescEnter(Sender:TObject);
    procedure edDescExit(Sender:TObject);
    procedure gridEventsColLibellePropertiesExit(Sender:TObject);
    procedure PmChangeFichePopup(Sender:TObject);
    procedure cxGridTableTemoinsDblClick(Sender:TObject);
    procedure edDatePropertiesExit(Sender:TObject);
    procedure PageControlNotesSourcesClick(Sender:TObject);
    procedure PageControlEveClick(Sender:TObject);
    procedure mEffacerlelieuClick(Sender:TObject);
    procedure TreeConjClick(Sender:TObject);
    procedure DSMediasStateChange(Sender:TObject);
    procedure mVisualiseActeClick(Sender:TObject);
    procedure cxGridTableMediasCellDblClick(Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure IBQEveBeforeScroll(DataSet:TDataSet);
    procedure mRemplacerDocumentClick(Sender:TObject);
    procedure TreeConjMouseDown(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure cxGridTemoinsExit(Sender:TObject);
    procedure PopupAjouteEvePopup(Sender:TObject);
    procedure cxGridTableMediasEditKeyDown(Sender:TObject;
      AItem:Longint;AEdit:TCustomMaskEdit;var Key:Word;
      Shift:TShiftState);
    procedure cxGridTableMediasEditKeyPress(Sender:TObject;
      AItem:Longint;AEdit:TCustomMaskEdit;var Key:Char);
    procedure edCommentairesMouseEnter(Sender:TObject);
    procedure edVilleExit(Sender:TObject);
    procedure edSubdiEnter(Sender:TObject);
    procedure cxGridTableTemoinsInitEdit(Sender:TObject;
      AItem:Longint;AEdit:TCustomMaskEdit);
    procedure dsEveDataChange(Sender:TObject;Field:TField);
    procedure IBTemoinsMediasBeforeScrollOrClose(DataSet:TDataSet);
    procedure mTrierEventsClick(Sender:TObject);
    procedure mSuppTriEventsClick(Sender:TObject);
    procedure mRemplacerConjointClick(Sender:TObject);
    procedure cxComboBoxActeExit(Sender:TObject);
    procedure PageControlEveExit(Sender:TObject);
    procedure PageControlEveEnter(Sender:TObject);
    procedure PageControlNotesSourcesEnter(Sender:TObject);
    procedure PageControlNotesSourcesExit(Sender:TObject);
    procedure LabelParenteMouseDown(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure TreeConjDragOver(Sender,Source:TObject;X,Y:Integer;
      State:TDragState;var Accept:Boolean);
    procedure TreeConjDragDrop(Sender,Source:TObject;X,Y:Integer);
    procedure cxGridTableTemoinsDragOver(Sender,Source:TObject;X,
      Y:Integer;State:TDragState;var Accept:Boolean);
    procedure cxGridTableTemoinsDragDrop(Sender,Source:TObject;X,
      Y:Integer);
    procedure Calculssurlesdates1Click(Sender: TObject);
    procedure TreeEventsClick(Sender: TObject);
    procedure edLatitudePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure edNotesEvenementPropertiesEditValueChanged(Sender: TObject);
    procedure colMemoPropertiesEditValueChanged(Sender: TObject);
    procedure mAcquerirClick(Sender: TObject);
    procedure pmGooglePopup(Sender: TObject);
    procedure InfoCopie(Sender: TObject);
  private
    fCanScroll:boolean;
    fCanScrollEvent:boolean;
    ConjointPrec:integer;
    UnionPrec:integer;
    CleConjoint:integer;
    NomConjointComplet:string;
    s_cp_entree,s_insee_entree:string;
    ev_cp_modifie:integer;
    cp_modifie,insee_modifie:boolean;
    bChanged:boolean;
    okEvent,okModif:boolean;
    NoeudSurvolTv:PVirtualNode;
    ColSurvolTv:integer;
    BloqueCar:boolean;
    procedure doScrollEvent;
    procedure p_AfterDownloadCoord;
    procedure up_SubMenu(Sender:TObject);
    procedure CalculerAgesConjoints(DateEv:string);//AL2011
    procedure VoirAncetreCommun;
    procedure AjouteTemoin(Temoin,Sexe:integer;NomPrenom,Naissance,Deces:string);
    procedure MajBtnLieux;
    function CalcChampsDateFam(Dataset:TDataset;DateWriten:String):String;
  public
    //pour désactiver le TPageControl principal au profit des secondaires
    bPageControlNotesSources,bPageControlEve:boolean;
    procedure doInitialize;
    function doOpenQuerys(GardeUnion:boolean):boolean;
    function GetCleEventUnionSelected:integer;
    procedure doGoto(const Conjoint:integer);
    function FajoutConjoint(Remplacer:boolean;var Conjoint:Integer;NomA_Conjoint:string=''):boolean;
    function CreationUnion(aConjoint:Integer):boolean;
    procedure ShowUnionEvents;
    procedure CreationEvFam(LibCourt,LibLong:string);
  end;

implementation

uses  u_dm,
      u_form_Main,
      LazUTF8,
      u_form_individu_repertoire,
      u_form_individu,
      u_form_Evements_Ajout,u_common_functions,u_common_ancestro,u_common_const,
      u_form_biblio_Sources,u_genealogy_context,u_objet_TGedcomDate,
      u_form_TriEvent,u_Form_Calendriers,variants,
      u_gedcom_const, u_common_treeind,
      u_common_ancestro_functions,
      fonctions_dialogs,
      fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

const
  _onglet_notes=0;
  _onglet_sources=1;
  _onglet_temoins=2;
  _onglet_medias=3;
var
      fFormIndividu:TFIndividu;

procedure TFIndividuUnion.SuperFormCreate(Sender:TObject);
var
  i:integer;
begin
  OnRefreshControls:=SuperFormRefreshControls;
  TFIndividu(Owner).SetPaysVilles(DSCountries,dsVilles);
  Color:=gci_context.ColorLight;
  PanLieu.Color:=gci_context.ColorLight;
  PanLieu.Cursor:=_CURPOPUP;
  bsfbAjout.Color:=gci_context.ColorLight;
  bsfbRetirer.Color:=gci_context.ColorLight;
  btnAddEvent.Color:=gci_context.ColorLight;
  btnDelEvent.Color:=gci_context.ColorLight;
  bsfbAjout.ColorFrameFocus:=gci_context.ColorLight;
  bsfbRetirer.ColorFrameFocus:=gci_context.ColorLight;
  btnAddEvent.ColorFrameFocus:=gci_context.ColorLight;
  btnDelEvent.ColorFrameFocus:=gci_context.ColorLight;
  fbInfosVilles.Color:=gci_context.ColorLight;
  btnVillesFavoris.Color:=gci_context.ColorLight;
  fbInfosVilles.ColorFrameFocus:=gci_context.ColorLight;
  btnVillesFavoris.ColorFrameFocus:=gci_context.ColorLight;
  btnVillesFavoris.Hint:=rs_Hint_Opens_favorite_sites_window_Ctrl_F_From_City_or_division_fields;
  s_cp_entree:=NullAsStringValue;

{  for i:=_onglet_notes to _onglet_medias do
    PageControlEve.Tabs[i].ImageIndex:=66;}
  btnInternet.PopupMenu:=FMain.pmLieuInternet;
  btnVillesVoisines.PopupMenu:=FMain.pmVillesVoisines;

  edCommentaires.Align:=AlClient;
  edSources.Align:=AlClient;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  BtAjoutTemoin.Color:=gci_context.ColorLight;
  BtSupprimeTemoin.Color:=gci_context.ColorLight;
  BtAjoutTemoin.ColorFrameFocus:=gci_context.ColorLight;
  BtSupprimeTemoin.ColorFrameFocus:=gci_context.ColorLight;
  ConjointPrec:=0;
  UnionPrec:=0;
  LabelParente.Caption:='';
  BloqueCar:=false;
  bPageControlNotesSources:=false;
  bPageControlEve:=false;
  TreeConj.Hint:=rs_Hint_You_can_add_a_joint_by_drag_drop;
  cxGridTemoins.Hint:=rs_Hint_You_can_add_a_wittness_by_drag_drop;
  fFormIndividu:=TFIndividu(Owner);
  lNom.PopupMenu:=fFormIndividu.pmNom;
  lNom.OnMouseEnter:=fFormIndividu.lNomMouseEnter;
  lNom.OnMouseLeave:=fFormIndividu.lNomMouseLeave;
  lNom.OnMouseMove:=fFormIndividu.lNomMouseMove;
  lNom.OnClick:=fFormIndividu.lNomClick;
end;

procedure TFIndividuUnion.TreeConjBeforeCellPaint(Sender: TBaseVirtualTree;
  ACanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  // Matthieu : Au hasard
  with TreeConj,PNodeIndividu(GetNodeData(Node))^ do
  if Column=1 then
  begin
    if FocusedNode=Node then
      Color:=gci_context.ColorMedium
    else
      Color:=clWhite;
    case fSexe of
      1:Font.Color:=gci_context.ColorHomme;
      2:Font.Color:=gci_context.ColorFemme;
      else
        Font.Color:=clWindowText
    end;
    if fSosa>0 then
    begin
      Font.Color:=_COLOR_SOSA;
    end;
  end;

end;

procedure TFIndividuUnion.dsDeleteUnionStateChange(Sender:TObject);
begin
  FFormIndividu.doRefreshControls;
end;


procedure TFIndividuUnion.edDateChangeLabel(const DateControl: TExtDBDateEdit;
  const IsBlank: Boolean);
begin
  if IsBlank
    then DBTextAge.Caption:=''
    else CalculerAgesConjoints(edDate.Text);
end;

procedure TFIndividuUnion.edVilleLocate(Sender: TObject);
begin
  with dsVilles.DataSet do
  begin
    ibqEveEV_FAM_CP.asString:=FieldByName('CODE').AsString;
    ibqEveEV_FAM_DEPT.asString:=FieldByName('DEPARTEMENT').AsString;
    ibqEveEV_FAM_PAYS.asString:=FieldByName('PAYS').AsString;
    ibqEveEV_FAM_REGION.asString:=FieldByName('REGION').AsString;
    ibqEveEV_FAM_INSEE.asString:=FieldByName('INSEE').AsString;
    ibqEveEV_FAM_LATITUDE.asString:=FieldByName('LATITUDE').AsString;
    ibqEveEV_FAM_LONGITUDE.asString:=FieldByName('LONGITUDE').AsString;
  end;
end;

procedure TFIndividuUnion.GdEveCloningControl(Sender: TObject);
begin
  ( sender as TControl ).OnClick:=TreeEventsClick;
end;

procedure TFIndividuUnion.IBQEveAfterOpen(DataSet: TDataSet);
begin
  p_FillClonesEvent ( IBQEve, GdEve, l_cloned, LinkA, LinkB, event_action, event_type, i_source, IBQEve_LONG_NAME_EVENT, 'fam' );
end;


procedure TFIndividuUnion.cxGridTemoinsGetBtnParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor;
  var SortMarker: TSortMarker; IsDown: Boolean);
var V : Variant;
begin
  if Field.FieldName <> 'SEXE' Then Exit;
  v:=Field.Value;
  if not VarIsNull(v) then
    case v of
      1:AFont.Color:=gci_context.ColorHomme;
      2:AFont.Color:=gci_context.ColorFemme;
      else
        AFont.Color:=clWindowText;
    end
  else
    AFont.Color:=clWindowText;

end;

procedure TFIndividuUnion.btnVillesVoisinesContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  PrepareCoordCity;
end;

procedure TFIndividuUnion.SuperFormRefreshControls(Sender:TObject);
var
  CleEventUnion,i:integer;
  OkMARR:boolean;
begin
  CleEventUnion:=GetCleEventUnionSelected;
  okEvent:=(FFormIndividu.CleFiche<>-1)and(IBQEve.active)and(CleEventUnion<>-1);
  okModif:=okEvent and(not FFormIndividu.DialogMode);
  OkMARR:=okModif and(IBQEveEV_FAM_TYPE.AsString='MARR');
  edDate.enabled:=okEvent;
  pmDate.AutoPopup:=okModif;
  edCP.enabled:=okEvent;
  edVille.enabled:=okEvent;
  edDept.enabled:=okEvent;
  edPays.enabled:=okEvent;
  edSubdi.enabled:=okEvent;
  edRegion.enabled:=okEvent;
  edInsee.enabled:=okEvent;
  edHeure.Enabled:=okEvent;
  edLatitude.enabled:=okEvent;
  edLongitude.enabled:=okEvent;
  edDesc.enabled:=okEvent;
  edCause.enabled:=okEvent;
  edNotesEvenement.Enabled:=okEvent;
  edSourcesEvenement.Enabled:=okEvent;
  pmVideLieu.AutoPopup:=okModif;

  fbInfosVilles.enabled:=okModif;
  btnVillesFavoris.enabled:=okModif;
  MajBtnLieux;

  bsfbRetirer.enabled:=(FFormIndividu.CleFiche<>-1)and(TreeConj.FocusedNode<>nil)and
    (TreeConj.FocusedNode^.parent=nil)and(FFormIndividu.DialogMode=false);
  bsfbAjout.enabled:=(FFormIndividu.CleFiche<>-1)and(FFormIndividu.DialogMode=false);
  TreeConj.ShowHint:=bsfbAjout.enabled and bsfbAjout.Visible;
  btnAddEvent.enabled:=(FFormIndividu.CleFiche<>-1)and(TreeConj.FocusedNode<>nil)and
    (IBQEve.active)and(FFormIndividu.DialogMode=false);
  btnDelEvent.enabled:=okModif;

  PageControlEveChange(nil);//met à jour le PageControlEve
  // Matthieu ?
{  for i:=0 to edPays.Properties.Buttons.Count-1 do
    edPays.Properties.Buttons.Items[i].Visible:=okModif;
  for i:=0 to edVille.Properties.Buttons.Count-1 do
    edVille.Properties.Buttons.Items[i].Visible:=okModif;
  for i:=0 to cxComboBoxActe.Properties.Buttons.Count-1 do
    cxComboBoxActe.Properties.Buttons.Items[i].Visible:=okModif;
  edDesc.Properties.ImmediateDropDown:=okModif and(IBQEveEV_FAM_TYPE.AsString='MARR');
  for i:=0 to edDesc.Properties.Buttons.Count-1 do
    edDesc.Properties.Buttons.Items[i].Visible:=OkMARR;
 }
  bChanged:=true;
  with IBQEve do
   if Active Then
    case FieldByName('EV_FAM_ACTE').AsInteger of
      1:cxComboBoxActe.Text:='Acte trouvé';
      -1:cxComboBoxActe.Text:='Acte demandé';
      -2:cxComboBoxActe.Text:='Acte à chercher';
      -3:cxComboBoxActe.Text:='Acte à ignorer';
      else
        cxComboBoxActe.Text:='Acte absent';
    end;
  cxComboBoxActe.ReadOnly:=not okModif;
  cxComboBoxActe.Visible:=okEvent;
  bChanged:=false;

  if OkMARR then
    edDesc.Items:=dm.ListeLibellesUnions
  else
    edDesc.Items.Clear;

//  newlistevilles; //AL11/2011 fait à l'entrée dans le champ ville
end;


procedure TFIndividuUnion.ShowUnionEvents;
var
  k,c,i:integer;
  aNodeIndividu:PNodeIndividu;
  aNode:PVirtualNode;
begin
  fCanScrollEvent:=false;
  try
    IBTemoins.Close;
    IBMedias.Close;
    IBMedias.ParamByName('indi').AsInteger:=FFormIndividu.CleFiche;
    aNodeIndividu:=nil;
  //On récupère la clé de l'union
    k:=-1;
    c:=-1;
    aNode:=TreeConj.FocusedNode;
    if (aNode<>nil)and(TreeConj.GetNodeData(aNode)<>nil) then
    begin
      if (aNode.Parent<>nil) and (aNode.Parent.Parent=nil) then
        aNode:=aNode.Parent;
      aNodeIndividu:=PNodeIndividu(TreeConj.GetNodeData(aNode));
      k:=aNodeIndividu^.fClefUnion;
      c:=aNodeIndividu^.fCleFiche;
    end;
  //Sauvegarde des notes et sources de l'union en cours, si besoin
    if (QSourcesNotesUnion.State in [dsEdit,dsInsert]) then
      QSourcesNotesUnion.Post;
  //on ouvre le query sur les sources et notes de cette union
    QSourcesNotesUnion.Close;
    with QSourcesNotesUnion do
    if k<>-1 then
    begin
      ParamByName('UNION_CLEF').AsInteger:=k;
      QSourcesNotesUnion.Open;
      if Length(FieldByName('COMMENT').AsString)>0 then
        PageControlNotesSources.Pages[0].ImageIndex:=74
      else
        PageControlNotesSources.Pages[0].ImageIndex:=66;
      if Length(FieldByName('SOURCE').AsString)>0 then
        PageControlNotesSources.Pages[1].ImageIndex:=74
      else
        PageControlNotesSources.Pages[1].ImageIndex:=66;
    end
    else
    begin
      PageControlNotesSources.Pages[0].ImageIndex:=66;
      PageControlNotesSources.Pages[1].ImageIndex:=66;
    end;
  //Sauvegarde de l'événement en cours si besoin
    if (dsEve.State in [dsEdit,dsInsert]) then
      IBQEve.Post;
  //Recherche des événements associés à cette union
    IBQEve.Close;
    if k<>-1 then
    begin
      IBQEve.DisableControls;
      try
        IBQEve.ParamByName('langue').AsString:=gci_context.Langue;
        IBQEve.ParamByName('i_union').AsInteger:=k;
        try
          IBQEve.Open;
        except
          on E:Exception do
            MyMessageDlg(rs_Error_while_reading_union_events+_CRLF
              +E.Message,mtError, [mbOK],FMain);
        end;
      finally
        IBQEve.EnableControls;
      end;
    end;
  finally
    fCanScrollEvent:=true;
  end;
  IBTemoins.Open;
  IBMedias.Open;
  doScrollEvent;

  if (c<>ConjointPrec)or(k<>UnionPrec) then
  begin
    LabelParente.Caption:='';
    LabelParente.Visible:=false;
    if (k<>-1)and(c>0) then
    begin
      CleConjoint:=c;
      NomConjointComplet:=aNodeIndividu.fNomComplet;
      if gci_context.CalculParenteAuto then
      begin
        // Matthieu : pour LAZARUS
        dm.IBTrans_Courte.StartTransaction;
        ReqParente.Params[0].AsInteger:=c;
        ReqParente.Params[1].AsInteger:=FFormIndividu.QueryIndividuCLE_FICHE.AsInteger;
        i:=0;
        while i<5 do
        try
          if i > 0 Then
            dm.IBTrans_Courte.StartTransaction;
          ReqParente.ExecQuery;
          if not ReqParente.Eof then
          begin
            LabelParente.Caption:=ReqParente.Fields[0].AsString;
            LabelParente.Visible:=True;
          end;
          ReqParente.Close;
          i:=6;
          dm.IBTrans_Courte.Commit;
        except
          ReqParente.Close;
          dm.IBTrans_Courte.Rollback;
          inc(i);
          Sleep(500);
        end;
        if i=5 then
          Exit;//pour ne pas modifier ConjointPrec et UnionPrec qui suivent et terminent la procédure
      end;
    end;
    ConjointPrec:=c;
    UnionPrec:=k;
  end;
end;

procedure TFIndividuUnion.bsfbAjoutClick(Sender:TObject);
var
  Conjoint:integer;
begin
  if bsfbAjout.Visible and bsfbAjout.Enabled then
  begin
    if FajoutConjoint(false,Conjoint,'') then
      if Conjoint>0 then
      begin
        doGoto(Conjoint);
        if gci_context.CreationMARRConjoint then
          CreationEvFam('MARR','');
      end;
  end;
end;

function TFIndividuUnion.CreationUnion(aConjoint:Integer):boolean;
var
  q:TIBSQL;
begin
  q:=TIBSQL.Create(Self);
  try
    q.DataBase:=dm.ibd_BASE;
    q.Transaction:=dm.IBT_BASE;
    q.SQL.Text:='update or insert into T_UNION'
      +'(UNION_MARI,UNION_FEMME,KLE_DOSSIER,UNION_TYPE)'
      +'values(:UNION_MARI,:UNION_FEMME,:KLE_DOSSIER,0)'
      +'matching(UNION_MARI,UNION_FEMME)'
      +'returning old.union_clef';
    q.ParamByName('KLE_DOSSIER').AsInteger:=dm.NumDossier;
    if FFormIndividu.QueryIndividuSEXE.AsInteger=1 then
    begin
      q.ParamByName('UNION_MARI').AsInteger:=FFormIndividu.CleFiche;
      q.ParamByName('UNION_FEMME').AsInteger:=aConjoint;
    end
    else
    begin
      q.ParamByName('UNION_MARI').AsInteger:=aConjoint;
      q.ParamByName('UNION_FEMME').AsInteger:=FFormIndividu.CleFiche;
    end;
    q.ExecQuery;
    if q.Fields[0].IsNull then //il y a création de l'union
    begin
      //on indique que l'individu est modifié
      FFormIndividu.doBouton(true);
      doOpenQuerys(false);
      FFormIndividu.aFIndividuIdentite.RempliConjEnfants;
      ShowUnionEvents;
      result:=true;
    end
    else
    begin
      MyMessageDlg(rs_Error_union_alreadx_exists,mtError, [mbOK],FMain);
      result:=false;
    end;
    q.Close;
  finally
    q.Free;
  end;
end;

function TFIndividuUnion.FajoutConjoint(Remplacer:boolean;var Conjoint:Integer;NomA_Conjoint:string=''):boolean;//AL
var
  aFIndividuRepertoire:TFIndividuRepertoire;
  i_Sexe,SexeConjoint,A_Conjoint:integer;
  aLettre:string;
begin
  result:=false;
  A_Conjoint:=Conjoint;
  Conjoint:=-1;
  i_Sexe:=FFormIndividu.QueryIndividuSEXE.AsInteger;
  //on peut ajouter un conjoint uniquement s'il est de sexe connu
  if (i_Sexe=1)or(i_Sexe=2) then
  begin
    if i_Sexe=1 then
      SexeConjoint:=2
    else
      SexeConjoint:=1;
    //Création de la boite de recherche d'un individu par le prénom
    FFormIndividu.PostIndividu;
    aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
    try
      CentreLaFiche(aFIndividuRepertoire,FMain);
      if Remplacer and(A_Conjoint>0) then
      begin
        aFIndividuRepertoire.NomIndi:=NomA_Conjoint;
        aLettre:=copy(fs_FormatText(NomA_Conjoint,mftUpper,True),1,1);
        aFIndividuRepertoire.InitIndividuPrenom(aLettre,'INDEX',SexeConjoint,A_Conjoint,False,True);
      end
      else
      begin
        aFIndividuRepertoire.NomIndi:=FFormIndividu.QueryIndividuNOM.AsString;
        aLettre:=copy(fs_FormatText(aFIndividuRepertoire.NomIndi,mftUpper,True),1,1);
        aFIndividuRepertoire.InitIndividuPrenom(aLettre,'',SexeConjoint,0,False,True);
      end;
      aFIndividuRepertoire.Caption:=rs_caption_Select_Joint;
      if aFIndividuRepertoire.ShowModal=mrOk then
      begin
        if aFIndividuRepertoire.Creation then //pour permettre d'annuler l'individu créé
        begin
          FFormIndividu.doBouton(true);
        end;
        if aFIndividuRepertoire.ClefIndividuSelected=FFormIndividu.Clefiche then
          MyMessageDlg(rs_Error_person_cannot_be_the_couple,mtError, [mbOK],FMain)
        else if aFIndividuRepertoire.ClefIndividuSelected>0 then
        begin
          if FFormIndividu.TestAscDesc(FFormIndividu.CleFiche
            ,aFIndividuRepertoire.ClefIndividuSelected
            ,FFormIndividu.GetNomIndividu
            ,aFIndividuRepertoire.NomPrenomIndividuSelected
            ,true,true) then //possible si inceste
            exit;
          if not Remplacer then
          begin
            Result:=CreationUnion(aFIndividuRepertoire.ClefIndividuSelected);
          end
          else
          begin
            result:=true;
          end;//de if not Remplacer
          Conjoint:=aFIndividuRepertoire.ClefIndividuSelected;
        end;
      end;
    finally
      FreeAndNil(aFIndividuRepertoire);
    end;
  end;
end;

procedure TFIndividuUnion.bsfbRetirerClick(Sender:TObject);
var
  aNodeIndividu:TNodeIndividu;
  aNode:PVirtualNode;
  q:TIBSQL;
begin
  if bsfbRetirer.Visible and bsfbRetirer.Enabled and(TreeConj.FocusedNode<>nil) then
  begin
    aNode:=TreeConj.FocusedNode;
    if (TreeConj.GetNodeData(aNode)<>nil)and(aNode.Parent=nil) then
    begin
      //on récupère le noeud de l'individu
      aNodeIndividu:=PNodeIndividu(TreeConj.GetNodeData(aNode))^;
      if aNodeIndividu.fClefUnion<>-1 then
      begin
        if MyMessageDlg(rs_Confirm_deleting_union+_CRLF+
          aNodeIndividu.fCaption+' ?',
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
              +' where u.union_clef='+IntToStr(aNodeIndividu.fClefUnion));
            q.ExecQuery;
            if q.eof then
            begin
              q.Close;
              q.SQL.Clear;
              q.SQL.Add('delete from t_union where union_clef='+IntToStr(aNodeIndividu.fClefUnion));
              q.ExecQuery;
              FFormIndividu.doBouton(true);
              TreeConj.DeleteNode(TreeConj.FocusedNode);
              if TreeConj.RootNode^.FirstChild<>nil then
              begin
                TreeConj.FocusedNode:=TreeConj.RootNode^.FirstChild;
                TreeConj.VisiblePath[TreeConj.RootNode^.FirstChild]:=True;
              end;
              FFormIndividu.TestCoherenceDates;
              //On rafraichit le tvConjointsEnfants dans FIndividuIdentite
              FFormIndividu.aFIndividuIdentite.RempliConjEnfants;
              ShowUnionEvents;
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
end;

procedure TFIndividuUnion.btnAddEventClick(Sender:TObject);
var
  aFEvenement_Ajout:TFEvenement_Ajout;
begin
  if btnAddEvent.Visible and btnAddEvent.Enabled then
  begin
    aFEvenement_Ajout:=TFEvenement_Ajout.create(self);
    try
      CentreLaFiche(aFEvenement_Ajout,FMain);
      aFEvenement_Ajout.up_Init(FFormIndividu.CleFiche,'U');
      if aFEvenement_Ajout.ShowModal=mrOk then
      begin
        CreationEvFam(aFEvenement_Ajout.Ref_Eve_Lib_Court,aFEvenement_Ajout.Ref_Eve_Lib_Long);
      end;
    finally
      FreeAndNil(aFEvenement_Ajout);
    end;
  end;
end;

procedure TFIndividuUnion.CreationEvFam(LibCourt,LibLong:string);
var Anode : PVirtualNode;
begin
  IBTemoins.Close;
  IBMedias.Close;
  if LibLong='' then
  begin
    with dm.ReqSansCheck do
    begin
      close;
      SQL.Text:='select ref_eve_lib_long from ref_evenements'
        +' where ref_eve_lib_court='''+LibCourt+''''
        +' and ref_eve_langue='''+gci_context.Langue+'''';
      ExecQuery;
      LibLong:=Fields[0].AsString;
      Close;
    end;
  end;
  IBQEve.Append;
  IBQEveEV_FAM_TYPE.AsString:=LibCourt;
  IBQEveEV_FAM_TITRE_EVENT.AsString:=LibLong;//ne doit pas être dans IBUEve.InsertSQL
  IBQEve.Post;
  if IBQEveEV_FAM_TYPE.AsString='EVEN' then
  begin
    if GdEve.CanFocus then
      GdEve.SetFocus;
  end
  else if edDate.CanFocus then
    edDate.SetFocus;
  IBTemoins.Open;
  IBMedias.Open;
  PageControlEveChange(nil);//met à jour le PageControlEve
  IBQEveAfterOpen(IBQEve);
end;

procedure TFIndividuUnion.IBQEveNewRecord(DataSet:TDataSet);
var
  k:integer;
  aNodeIndividu:TNodeIndividu;
  aNode:PVirtualNode;
begin
  k:=-1;
  aNode:=TreeConj.FocusedNode;
  with TreeConj do
  if (aNode<>nil)and(GetNodeData(aNode)<>nil) then
  begin
    if aNode^.Parent <> RootNode then
      aNode:=aNode.Parent;
    aNodeIndividu:=PNodeIndividu(GetNodeData(aNode))^;
    k:=aNodeIndividu.fClefUnion;
  end;
  if k<>-1 then
  begin
    IBQEveEV_FAM_CLEF.AsInteger:=dm.uf_GetClefUnique('EVENEMENTS_FAM');
    ibqEveEV_FAM_KLE_FAMILLE.AsInteger:=k;
    ibqEveEV_FAM_KLE_DOSSIER.AsInteger:=dm.NumDossier;
  end
  else
    DataSet.Cancel;
end;

procedure TFIndividuUnion.dsEveStateChange(Sender:TObject);
begin
  if (dsEve.State in [dsEdit,dsInsert]) then
    FFormIndividu.doBouton(true);
end;

procedure TFIndividuUnion.btnDelEventClick(Sender:TObject);
begin
  if btnDelEvent.Visible and btnDelEvent.Enabled then
  begin
    if MyMessageDlg(rs_Confirm_deleting_this_event,
      mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
    begin
      IBQEve.Delete;
      FFormIndividu.doBouton(true);
      FFormIndividu.TestCoherenceDates;
    end;
  end;
end;

function TFIndividuUnion.GetCleEventUnionSelected:integer;
begin
  result:=-1;
  if IBQEve.Active then
    if not IBQEve.IsEmpty then
      result:=IBQEveEV_FAM_CLEF.AsInteger;
end;

procedure TFIndividuUnion.doInitialize;
begin
  fCanScroll:=false;
  TreeConj.BeginUpdate;
  try
    TreeConj.Clear;
  finally
    TreeConj.EndUpdate;
  end;
  IBQEve.Close;
  IBConjoints.Close;
  QSourcesNotesUnion.Close;
  fCanScroll:=true;
end;

function TFIndividuUnion.doOpenQuerys(GardeUnion:boolean):boolean;
var//modifications et ajout GardeUnion par AL 2009
  NodeConjoint,ShoulSelectThisNode:PVirtualNode;
  aNode:PVirtualNode;
  s,libelle:string;
  LastCleFiche:integer;
  NodeIndividu:TNodeIndividu;
begin
  fCanScroll:=false;
  ShoulSelectThisNode:=nil;
  ibConjoints.Close;
  ibConjoints.Params[0].AsInteger:=FFormIndividu.QueryIndividuCLE_FICHE.AsInteger;
  ibConjoints.ExecQuery;
  TreeConj.BeginUpdate;
  NodeConjoint := nil;
  with TreeConj, ibConjoints do
  try
    NodeDataSize:=SizeOf(TNodeIndividu)+1;
    LastCleFiche:=-1;
    if GardeUnion then
    begin
      //on regarde si un indi est sélectionné
      aNode:=FocusedNode;
      if aNode<>nil then
        if GetNodeData(aNode)<>nil then
        begin
          if aNode.Parent<>nil then
            aNode:=aNode.Parent;
          NodeIndividu:=PNodeIndividu(GetNodeData(aNode))^;
          LastCleFiche:=NodeIndividu.fCleFiche;
        end;
    end;
    //on efface tout le treeview
    Clear;
    while not Eof do
    begin
     NodeConjoint:=AddChild(nil,nil);
     ValidateNode(NodeConjoint,False);
      with PNodeIndividu(GetNodeData(NodeConjoint))^, ibConjoints do
       Begin
        fNom:=FieldByName('NOM').AsString;
        s:=AssembleString([FieldByName('NOM').AsString,FieldByName('PRENOM').AsString]);
        fNomComplet:=s+GetStringNaissanceDeces(FieldByName('ANNEE_NAISSANCE').AsString
          ,FieldByName('ANNEE_DECES').AsString);
        fCaption:=fNomComplet;
        s:=FieldByName('AN_MAR').AsString;
        if s>'' then
        begin
          libelle:='{X '+s;
          s:=FFormIndividu.AgesConjoints(FieldByName('date_mar').AsString,
            FieldByName('date_naissance').AsString);
          if s>'' then
            libelle:=libelle+', '+s;
          libelle:=StringReplace(libelle,' ',' ', [rfReplaceAll]);//remplace l'espace par l'espace insécable
          fCaption:=fCaption+' '+libelle+'}';
        end;

        fCleFiche:=FieldByName('conjoint').AsInteger;
        fSexe:=FieldByName('SEXE').AsInteger;
        fClefUnion:=FieldByName('clef_union').AsInteger;
        fDateNaissanceDeces:=FieldByName('date_naissance').AsString;
        if FieldByName('NUM_SOSA').AsFloat>0 then
          fSosa:=FieldByName('NUM_SOSA').AsFloat;
       End;
        //On ajoute ce conjoint dans le treeView
     if ( FieldByName('NOM_PERE').AsString>'' ) or ( FieldByName('NOM_MERE').AsString>'' )
       then
        Begin

         if GardeUnion then
           if LastCleFiche=NodeIndividu.fCleFiche then
              ShoulSelectThisNode:=NodeConjoint;
                //Le père de ce conjoint
            if FieldByName('NOM_PERE').AsString>'' then
            //On ajoute le père du conjoint, dans le treeView
            begin
             NodeConjoint:=AddChild(NodeConjoint,nil);
             ValidateNode(NodeConjoint,False);
             NodeIndividu:=PNodeIndividu(GetNodeData(NodeConjoint))^;
              s:=AssembleString([FieldByName('NOM_PERE').AsString,
                FieldByName('PRENOM_PERE').AsString]);
              s:=s+GetStringNaissanceDeces(FieldByName('PERE_NAISSANCE').AsString
                ,FieldByName('PERE_DECES').AsString);
              with PNodeIndividu(GetNodeData(NodeConjoint))^ do
               Begin
                fCaption:=s;
                fCleFiche:=FieldByName('CLE_PERE').AsInteger;
                fSexe:=1;
               end;
            end;
                //la mere de ce conjoint
            if FieldByName('NOM_MERE').AsString>'' then
            //On ajoute la mère du conjoint, dans le treeView
            begin
              NodeConjoint:=AddChild(NodeConjoint,nil);
              ValidateNode(NodeConjoint,False);
              NodeIndividu:=PNodeIndividu(GetNodeData(NodeConjoint))^;
              s:=AssembleString([FieldByName('NOM_MERE').AsString,
                FieldByName('PRENOM_MERE').AsString]);
              s:=s+GetStringNaissanceDeces(FieldByName('MERE_NAISSANCE').AsString
                ,FieldByName('MERE_DECES').AsString);
              with PNodeIndividu(GetNodeData(NodeConjoint))^ do
               Begin
                fCaption:=s;
                fCleFiche:=FieldByName('CLE_MERE').AsInteger;
                fSexe:=2;
               end;
            end;
        end;
      next;
    end;
    Close;
    FullExpand;
  finally
    EndUpdate;
  end;
  if (TreeConj.VisibleCount+1)<TreeConj.TotalCount then
    TreeConj.FullCollapse;

  //on essaye de resélectionner l'ancien node
  with TreeConj do
  if ShoulSelectThisNode<>nil then
    FocusedNode := ShoulSelectThisNode
  else if TotalCount>0 then
  begin
    FocusedNode := RootNode.FirstChild;
    VisiblePath[FocusedNode]:=True;
  end;
  fCanScroll:=true;
  ShowUnionEvents;
  result:=true;
end;

procedure TFIndividuUnion.IBQEveBeforeScroll(DataSet:TDataSet);
begin
  IBMedias.Close;
  IBTemoins.Close;
end;

procedure TFIndividuUnion.IBQEveAfterScroll(DataSet:TDataSet);
begin
  if fCanScrollEvent then
  begin
    IBMedias.Open;
    IBTemoins.Open;
    doScrollEvent;
  end;
end;

procedure TFIndividuUnion.doScrollEvent;
begin
  if fCanScrollEvent then
  begin
    if Assigned(_FormHistoire) then //on rafraichit l'histoire
      _FormHistoire.doPosition(IBQEveEV_FAM_CLEF.AsInteger,1);
    ev_cp_modifie:=0;
    cp_modifie:=false;
    insee_modifie:=false;
    DoRefreshControls;
  end;
end;

procedure TFIndividuUnion.mOuvrirFicheClick(Sender:TObject);
var
  aNodeIndividu:TNodeIndividu;
  aNode:PVirtualNode;
begin
  with TreeConj do
  if FocusedNode<>nil then
  begin
    aNode:=FocusedNode;
    if (GetNodeData(aNode)<>nil)and(aNode^.Parent<>nil) then
    begin
          //on récupère l'objet de stockage de l'individu
      aNodeIndividu:=PNodeIndividu(TreeConj.GetNodeData(aNode))^;
      dm.individu_clef:=aNodeIndividu.fCleFiche;
      DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
    end;
  end;
end;

procedure TFIndividuUnion.popupConjointsPopup(Sender:TObject);
var
  i:integer;
begin
  for i:=popupConjoints.Items.Count-1 downto 4 do
    popupConjoints.Items[i].Free;
  with TreeConj do
  if (FocusedNode<>nil)and(GetNodeData(FocusedNode)<>nil)and
    (FocusedNode^.Parent<>nil) then
  begin
    mOuvrirFiche.enabled:=true;
    with PNodeIndividu(GetNodeData(FocusedNode))^ do
    FMain.RempliPopMenuParentsConjointsEnfants(popupConjoints,fCleFiche,fSexe,false);
  end
  else
    mOuvrirFiche.Enabled:=false;
  mAjouterConjoint.Visible:=bsfbAjout.Visible and bsfbAjout.Enabled;
  mSupprimerConjoint.Visible:=bsfbRetirer.Visible and bsfbRetirer.Enabled;
end;

procedure TFIndividuUnion.TreeConjGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  case PNodeIndividu ( Sender.GetNodeData(Node))^.fSexe of
    1:ImageIndex:=29;
    2:ImageIndex:=30;
    else
      ImageIndex:=31;
  end;

end;

procedure TFIndividuUnion.TreeConjGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  CellText:= PNodeIndividu ( Sender.GetNodeData(Node))^.fCaption;
end;

procedure TFIndividuUnion.TreeConjClick(Sender:TObject);
begin
  ShowUnionEvents;
end;

procedure TFIndividuUnion.TreeConjMouseMove(Sender:TObject;
  Shift:TShiftState;X,Y:Integer);
var
  niveau,Noeud:PVirtualNode;
  Col:integer;
begin
  Noeud:=TreeConj.GetNodeAt(X,Y);
  if Noeud<>nil then
  begin
    niveau:=Noeud^.Parent;
    if (parent=nil)and(X>20)and(X<38) then
      Col:=0
    else if (niveau.Parent<>nil)and(niveau.Parent.Parent=nil)and(X>40)and(X<58) then
      Col:=1
    else
      Col:=3;
  end
  else
    Col:=4;
  if (Noeud<>NoeudSurvolTv)or(Col<>ColSurvolTv) then
  begin
    if Noeud<>nil then
    begin
      if Col<3 then
        TreeConj.Cursor:=crHandPoint
      else
        TreeConj.Cursor:=_CURPOPUP;
      popupConjoints.AutoPopup:=true;
    end
    else
    begin
      TreeConj.Cursor:=crDefault;
      popupConjoints.AutoPopup:=false;
    end;
    NoeudSurvolTv:=Noeud;
    ColSurvolTv:=Col;
  end;
end;


procedure TFIndividuUnion.DataSourceSourceCommentUnionStateChange(Sender:TObject);
begin
  if DataSourceSourceCommentUnion.State in [dsEdit,dsInsert] then
    FFormIndividu.doBouton(true);//AL 2009 remplace un dorefresh de tout!
end;

procedure TFIndividuUnion.btnDetailClick(Sender:TObject);
var
  aFBiblio_Sources:TFBiblio_Sources;
  details:integer;
begin
  if dsEve.State in [dsEdit,dsInsert] then
    dsEve.DataSet.Post;
  PageControlEve.ActivePageIndex:=_onglet_sources;//1
  aFBiblio_Sources:=TFBiblio_Sources.create(self);
  try
    CentreLaFiche(aFBiblio_Sources,FMain);
    aFBiblio_Sources.FormIndividu:=FFormIndividu;
    aFBiblio_Sources.Caption:=fs_RemplaceMsg(rs_Caption_Event_s_sources,[IBQEveEV_FAM_TITRE_EVENT.AsString]);
    aFBiblio_Sources.doOpenQuerys(IBQEveEV_FAM_CLEF.AsInteger,'F');
    if aFBiblio_Sources.ShowModal=mrOk then
    begin
      if dm.IBQSources_Record.State in [dsEdit,dsInsert] then
      begin
        dsEve.Edit;
        IBQEveEV_FAM_SOURCE.asString:=aFBiblio_Sources.sText;
        dm.IBQSources_Record.Post;
      end;
      if aFBiblio_Sources.IBMultimedia.State in [dsEdit,dsInsert] then
        aFBiblio_Sources.IBMultimedia.Post;
    end
    else
    begin
      if dm.IBQSources_Record.State in [dsEdit,dsInsert] then
        dm.IBQSources_Record.CancelUpdates;
      if aFBiblio_Sources.IBMultimedia.State in [dsEdit,dsInsert] then
        aFBiblio_Sources.IBMultimedia.CancelUpdates;
    end;
    if aFBiblio_Sources.Modif=True then
    begin
      FFormIndividu.doBouton(true);
      if not aFBiblio_Sources.IBMultimedia.IsEmpty
        or(length(aFBiblio_Sources.dxDBMemo2.Text)>0)
        or(length(aFBiblio_Sources.dxDBMemo3.Text)>0)
        or(length(aFBiblio_Sources.dxDBMemo4.Text)>0)
        or(length(aFBiblio_Sources.dxDBMemo5.Text)>0)
        or(length(aFBiblio_Sources.dxDBEdit3.Text)>0) then
        details:=1
      else
        details:=0;
      if IBQEveEV_FAM_DETAILS.AsInteger<>details then
      begin
        dsEve.Edit;
        IBQEveEV_FAM_DETAILS.AsInteger:=details;
        PageControlEveChange(nil);
      end;
    end;
  finally
    FreeAndNil(aFBiblio_Sources);
  end;
end;

procedure TFIndividuUnion.SuperFormShow(Sender:TObject);
begin
  PageControlEve.ActivePageIndex:=_onglet_notes;
  btnDetail.Visible:=false;
  BtAjoutTemoin.Visible:=false;
  BtSupprimeTemoin.Visible:=false;
  if FFormIndividu.DialogMode then
  begin
    GdEve.Cursor:=crArrow;
    dsEve.AutoEdit:=false;
    DSTemoins.AutoEdit:=false;
    DSMedias.AutoEdit:=false;
    DataSourceSourceCommentUnion.AutoEdit:=false;
  end;
  doRefreshControls;
end;

procedure TFIndividuUnion.IBQEveCalcFields(DataSet:TDataSet);
var
  sa,s:string;
begin
  sa:=IBQEveEV_FAM_DESCRIPTION.AsString;
  DBTextJour.Caption:='';
  if _GDate.DecodeHumanDate(IBQEveEV_FAM_DATE_WRITEN.AsString) then
    if _GDate.ValidDateTime1 and not _GDate.UseDate2 then
      DBTextJour.Caption:='('+LongDayNames[DayOfWeek(_GDate.DateTime1)]+')';
  if DBTextJour.Caption>'' then
    s:=IBQEveEV_FAM_DATE_WRITEN.AsString+' '+DBTextJour.Caption
  else
    s:=IBQEveEV_FAM_DATE_WRITEN.AsString;

  if length(s)>0 then
    if length(sa)>0 then
      sa:=sa+_CRLF+s
    else
      sa:=s;
  if gci_context.AfficheCPdansListeEV then
    s:=AssembleString([IBQEveEV_FAM_SUBD.AsString,
      IBQEveEV_FAM_CP.AsString,
        IBQEveEV_FAM_VILLE.AsString,
        IBQEveEV_FAM_DEPT.AsString])
  else
    s:=AssembleString([IBQEveEV_FAM_SUBD.AsString,
      IBQEveEV_FAM_VILLE.AsString,
        IBQEveEV_FAM_DEPT.AsString]);

  if gci_context.AfficheRegiondansListeEV then
    s:=AssembleString([s,
      IBQEveEV_FAM_REGION.AsString,
        IBQEveEV_FAM_PAYS.AsString])
  else
    s:=AssembleString([s,
      IBQEveEV_FAM_PAYS.AsString]);

  if length(s)>0 then
    if length(sa)>0 then
      sa:=sa+_CRLF+s
    else
      sa:=s;
  IBQEve_EVE_DETAIL.AsString:=sa;

  CalculerAgesConjoints(IBQEveEV_FAM_DATE_WRITEN.AsString);

  case IBQEveEV_FAM_ACTE.AsInteger of
    1:
      begin
        if IBQEveMULTI_CLEF.AsInteger>0 then
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

  if Length(IBQEveEV_FAM_COMMENT.AsString)>0 then
    IBQEveQUID_NOTES.AsInteger:=1;
  if IBQEveEV_FAM_DETAILS.AsInteger=1 then
    IBQEveQUID_SOURCES.AsInteger:=1;
end;

procedure TFIndividuUnion.doGoto(const Conjoint:integer);
begin
  TreeSelectNode(TreeConj,TreeConj.RootNode,Conjoint);
end;

procedure TFIndividuUnion.SuperFormDestroy(Sender:TObject);
begin

  IBQEve.Close;
  QSourcesNotesUnion.Close;
  IBConjoints.Close;

  IBQEve.UpdateObject:=nil;
  FreeAndNil(IBUEve);
  QSourcesNotesUnion.UpdateObject:=nil;
  FreeAndNil(IBUSourcesNotesUnion);
end;

procedure TFIndividuUnion.TreeConjSelectionChanged(Sender:TObject);
begin
  ShowUnionEvents;
end;

procedure TFIndividuUnion.PageControlNotesSourcesDrawTabEx(
  AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  if TPageControl(AControl).ActivePageIndex=ATab.PageIndex then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
end;

procedure TFIndividuUnion.edCommentairesKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  if not FFormIndividu.DialogMode then
  begin
    s:=edCommentaires.Text;
    k:=edCommentaires.SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    with QSourcesNotesUnion do
    begin
      if not(State in [dsEdit,dsInsert]) then
        Edit;
      FieldByName('COMMENT').AsString:=s;
      edCommentaires.SelStart:=k;
      BloqueCar:=true;
    end;
  end;
end;

procedure TFIndividuUnion.edSourcesKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  if not FFormIndividu.DialogMode then
  begin
    s:=edSources.Text;
    k:=edSources.SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    with QSourcesNotesUnion do
    begin
      if not(State in [dsEdit,dsInsert]) then
        Edit;
      FieldByName('SOURCE').AsString:=s;
      edSources.SelStart:=k;
      BloqueCar:=true;
    end;
  end;
end;

procedure TFIndividuUnion.edCommentairesDblClick(Sender:TObject);
begin
  ExecuteChaineDansChaine(edCommentaires.Text,edCommentaires.SelStart,edCommentaires.SelLength);
end;

procedure TFIndividuUnion.edSourcesDblClick(Sender:TObject);
begin
  ExecuteChaineDansChaine(edSources.Text,edSources.SelStart,edSources.SelLength);
end;

procedure TFIndividuUnion.edDatePropertiesChange(Sender: TObject);
var
  sDateTrans,joursem:string;
  ans,mois,jours:integer;
  Cal:TCalendrier;
begin
  if IBQEve.RecordCount>0 then //sinon provoque une violation en voulant modifier un enregistrement inexistant
    if doTesteDateEtJour(edDate.Text,joursem,sDateTrans,ans,mois,jours,Cal) then
    begin
      if joursem>'' then
        IBQEveEV_FAM_JOUR_SEM.AsString:='('+joursem+')'
      else
        IBQEveEV_FAM_JOUR_SEM.AsString:='';
      edDate.Font.Color:=clWindowText;
      edDate.Font.Style:= [];
      CalculerAgesConjoints(edDate.Text);
    end
    else
    begin
      IBQEveEV_FAM_JOUR_SEM.AsString:='';
      edDate.Font.Color:=clRed;
      edDate.Font.Style:= [fsBold];
      IBQEveEV_FAM_AGE_EVE.AsString:='';
    end;
end;


procedure TFIndividuUnion.edDatePropertiesExit(Sender:TObject);
var
  s,t:string;
begin
  if edDate.Modified then
  begin
    edDate.Text:=CalcChampsDateFam(IBQEve,edDate.Text);
    //test de cohérence
    s:=edDate.Text;
    t:=IBQEveEV_FAM_TYPE.AsString;
    if t='MARR' then //doit être dans Mariages et dans AutresEventUnion
      FFormIndividu.CoherenceDate.AddInfoDateWriten(
        s,
        '',
        IBQEveEV_FAM_CLEF.AsInteger,
        FFormIndividu.CoherenceDate.Mariages);

    FFormIndividu.CoherenceDate.AddInfoDateWriten(
      s,
      t,
      IBQEveEV_FAM_CLEF.AsInteger,
      FFormIndividu.CoherenceDate.AutresEventUnion );
    FFormIndividu.CoherenceDate.Test;
  end;
end;

procedure TFIndividuUnion.mSupprimerheureClick(Sender:TObject);
begin
  IBQEve.Edit;
  IBQEveEV_FAM_HEURE.Clear;
end;

procedure TFIndividuUnion.edCPEnter(Sender:TObject);
begin
  s_cp_entree:=edCP.Text;
end;

procedure TFIndividuUnion.edCPExit(Sender:TObject);
begin
  if edCP.Text<>s_cp_entree then
  begin
    ev_cp_modifie:=IBQEveEV_FAM_CLEF.AsInteger;
    cp_modifie:=true;
    edVille.SetFocus;
  end;
end;

procedure TFIndividuUnion.mImprimeActeClick(Sender:TObject);
var
  iClef:Integer;
begin
  iClef:=IBMedias.FieldByName('mp_media').AsInteger;
  if iClef>0 then
    ImprimeImage(iClef,'')
  else
    MyMessageDlg(rs_Error_None_picture_for_this_document,mtError, [mbOK],FMain);
end;

procedure TFIndividuUnion.pmImagePopup(Sender:TObject);
var
  iClef:integer;
begin
  iClef:=IBMedias.FieldByName('mp_media').AsInteger;
  mImprimeActe.Visible:=(iClef>0)and(IBMedias.FieldByName('multi_image_rtf').AsInteger=0);
  mVisualiseActe.Visible:=iClef>0;
end;

procedure TFIndividuUnion.pmDatePopup(Sender:TObject);
var
  s,sq:string;
  NewItem:TMenuItem;
  i:integer;
  q:TIBSQL;
begin
  pmDate.Items.Clear;
  s:=trim(edDate.Text);
  if s='' then
    sq:=' in(13,14,15,16,17,19,20,21)'
  else
  begin
    i:=Pos(' ',s);
    if i>0 then
    begin
      s:=fs_FormatText(Copy(s,1,i-1),mftUpper,True);
      if _MotsClesDate.Token_mots_maj[_TYPE_TOKEN_ENTRE].IndexOf(s)>-1 then
        sq:='=18'
      else if _MotsClesDate.Token_mots_maj[_TYPE_TOKEN_DU].IndexOf(s)>-1 then
        sq:='=14'
      else
        exit;
    end
    else
      exit;
  end;
  q:=TIBSQL.Create(Self);
  with q do
  try
    DataBase:=dm.ibd_BASE;
    SQL.Add('select token from ref_token_date'
      +' where langue='''+gci_context.Langue
      +''' and sous_type=''Y'' and type_token'
      +sq
      +' order by type_token');
    ExecQuery;
    i:=0;
    while not Eof do
    begin
      NewItem:=TMenuItem.Create(Self);
      NewItem.Caption:=FieldByName('TOKEN').AsString;
      pmDate.Items.Add(NewItem);
      pmDate.Items[i].OnClick:=up_SubMenu;
      next;
      inc(i);
    end;
    Close;
  finally
    Free;
  end;
end;


procedure TFIndividuUnion.up_SubMenu(Sender:TObject);
var
  sToken:string;
begin
  sToken:=(sender as TMenuItem).Caption;
  if not(ibqEve.State in [dsEdit,dsInsert]) then
    ibqEve.Edit;
  if trim(edDate.text)='' then
    ibqEveEV_FAM_DATE_WRITEN.AsString:=sToken+' '
  else
    ibqEveEV_FAM_DATE_WRITEN.AsString:=trim(edDate.text)+' '+sToken+' ';
  edDate.SelStart:=Length(edDate.text)+1
end;

procedure TFIndividuUnion.edVilleMouseEnter(Sender:TObject);
begin
  FMain.MsgBarreEtat(2);
end;

procedure TFIndividuUnion.EffaceBarreEtat(Sender:TObject);
begin
  FMain.MsgBarreEtat(0);
end;

procedure TFIndividuUnion.edVilleEnter(Sender:TObject);
begin
  FMain.CtrlFbloqued:=true;
end;


procedure TFIndividuUnion.btnVillesFavorisClick(Sender:TObject);
var
  Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string;
  Numpays:Integer;
begin
  with DSCountries do
    if Assigned(DataSet)
    and DataSet.Active
     Then Numpays:=DataSet.FieldByName('RPA_CODE').AsInteger
     Else Numpays:=-1;
  if FMain.ChercheLieuFavori(FMain,Numpays,edPays.Text,edVille.Text,edSubdi.Text,
    Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long) then
  begin
    IBQEve.AutoCalcFields:=False;
    try
      if not(IBQEve.State in [dsEdit,dsInsert]) then
        IBQEve.Edit;
      IBQEveEV_FAM_PAYS.asString:=Pays;
      IBQEveEV_FAM_REGION.asString:=Region;
      IBQEveEV_FAM_DEPT.asString:=Dept;
      IBQEveEV_FAM_CP.asString:=Code;
      IBQEveEV_FAM_INSEE.asString:=Insee;
      IBQEveEV_FAM_VILLE.asString:=Ville;
      IBQEveEV_FAM_SUBD.asString:=Subd;
      IBQEveEV_FAM_LATITUDE.asString:=Lat;
    Finally
      IBQEve.AutoCalcFields:=True;
    end;
    IBQEveEV_FAM_LONGITUDE.asString:=Long;
    edCause.SetFocus;
  end;
end;


procedure TFIndividuUnion.edVillePropertiesExit(Sender:TObject);
var
  k:integer;
begin

end;

procedure TFIndividuUnion.fbInfosVillesClick(Sender:TObject);
var
  Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string;
  Numpays:Integer;
begin
  with DSCountries do
    if Assigned(DataSet)
    and DataSet.Active
     Then Numpays:=DataSet.FieldByName('RPA_CODE').AsInteger
     Else Numpays:=-1;
  if FMain.ChercheVille(FMain,Numpays,edPays.Text,edVille.Text,
    Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long) then
  begin
    IBQEve.AutoCalcFields:=False;
    try
      if not(IBQEve.State in [dsEdit,dsInsert]) then
        IBQEve.Edit;
      IBQEveEV_FAM_PAYS.asString:=Pays;
      IBQEveEV_FAM_REGION.asString:=Region;
      IBQEveEV_FAM_DEPT.asString:=Dept;
      IBQEveEV_FAM_CP.asString:=Code;
      IBQEveEV_FAM_INSEE.asString:=Insee;
      IBQEveEV_FAM_VILLE.asString:=Ville;
      IBQEveEV_FAM_SUBD.asString:=Subd;
      IBQEveEV_FAM_LATITUDE.asString:=Lat;
    Finally
      IBQEve.AutoCalcFields:=True;
    end;
    IBQEveEV_FAM_LONGITUDE.asString:=Long;
    edCause.SetFocus;
  end;
end;

procedure TFIndividuUnion.edInseeEnter(Sender:TObject);
begin
  s_Insee_entree:=edInsee.Text;
end;

procedure TFIndividuUnion.edInseeExit(Sender:TObject);
begin
  if edInsee.Text<>s_insee_entree then
  begin
    ev_cp_modifie:=IBQEveEV_FAM_CLEF.AsInteger;
    insee_modifie:=true;
    edVille.SetFocus;
  end;
end;

procedure TFIndividuUnion.PrepareCoordCity;
begin
  FMain.Lieu_Pays:=edPays.Text;
  FMain.Lieu_Region:=edRegion.Text;
  FMain.Lieu_CP:=edCP.Text;
  FMain.Lieu_Ville:=edVille.Text;
  FMain.Lieu_Latitude:=edLatitude.Text;
  FMain.Lieu_Longitude:=edLongitude.Text;
  FMain.Lieu_Subdivision:=edSubdi.Text;
end;

procedure TFIndividuUnion.btnInternetPopupMenuPopup(Sender:TObject;
  var APopupMenu:TPopupMenu;var AHandled:Boolean);
begin
  PrepareCoordCity;
end;

procedure TFIndividuUnion.cxComboBoxActePropertiesEditValueChanged(
  Sender:TObject);
begin
  if bChanged then exit;

  if not(ibqEve.State in [dsEdit,dsInsert]) then
    IBQEve.Edit;

  if cxComboBoxActe.Text='Acte trouvé' then
    IBQEveEV_FAM_ACTE.AsInteger:=1
  else if cxComboBoxActe.Text='Acte demandé' then
    IBQEveEV_FAM_ACTE.AsInteger:=-1
  else if cxComboBoxActe.Text='Acte à chercher' then
    IBQEveEV_FAM_ACTE.AsInteger:=-2
  else if cxComboBoxActe.Text='Acte à ignorer' then
    IBQEveEV_FAM_ACTE.AsInteger:=-3
  else
    IBQEveEV_FAM_ACTE.AsInteger:=0;
end;

procedure TFIndividuUnion.PageControlEveChange(Sender:TObject);
var
  k:integer;
begin
  k:=PageControlEve.ActivePageIndex;
  btnDetail.Visible:=(k=_onglet_sources)
    and((FFormIndividu.DialogMode=false)or(IBQEveEV_FAM_DETAILS.Value=1))
    and(GetCleEventUnionSelected<>-1);//1
  BtAjoutTemoin.Visible:=((k=_onglet_temoins)or(k=_onglet_medias))
    and(FFormIndividu.DialogMode=false);
  BtSupprimeTemoin.Visible:=BtAjoutTemoin.Visible;
  BtAjoutTemoin.Enabled:=(GetCleEventUnionSelected<>-1);
  if k=_onglet_temoins then
  begin
    BtSupprimeTemoin.Enabled:=not IBTemoins.IsEmpty;
    mAjouterTemoin.Visible:=BtAjoutTemoin.Visible and BtAjoutTemoin.Enabled;
    mEnleverTemoin.Visible:=BtSupprimeTemoin.Visible and BtSupprimeTemoin.Enabled;
    BtAjoutTemoin.Hint:=rs_Hint_Add_a_witness_to_this_event;
    BtSupprimeTemoin.Hint:=rs_Hint_Delete_the_witness_s_link;
  end
  else
  begin
    BtSupprimeTemoin.Enabled:=not IBMedias.IsEmpty;
    mAjouterDocument.Visible:=BtAjoutTemoin.Visible and BtAjoutTemoin.Enabled;
    mEnleverDocument.Visible:=BtSupprimeTemoin.Visible and BtSupprimeTemoin.Enabled;
    mRemplacerDocument.Visible:=mEnleverDocument.Visible;
    cxGridMedias.ShowHint:=mEnleverDocument.Visible;
    BtAjoutTemoin.Hint:=rs_Hint_Add_a_doc_to_this_event;
    BtSupprimeTemoin.Hint:=rs_Hint_Delete_the_doc_s_link;
  end;
  PageControlEve.ShowHint:=(k=_onglet_temoins) and BtAjoutTemoin.Visible and BtAjoutTemoin.Enabled;
  with IBQEve do
   if Active Then
   Begin
    if FieldByName('EV_FAM_COMMENT').AsString>'' then
      PageControlEve.Pages[_onglet_notes].ImageIndex:=74
    else
      PageControlEve.Pages[_onglet_notes].ImageIndex:=66;
    if (FieldByName('EV_FAM_DETAILS').AsInteger=1)or(FieldByName('EV_FAM_SOURCE').AsString>'') then
      PageControlEve.Pages[_onglet_sources].ImageIndex:=74
    else
      PageControlEve.Pages[_onglet_sources].ImageIndex:=66;
    if FieldByName('MULTI_CLEF').Value=1 then
      PageControlEve.Pages[_onglet_medias].ImageIndex:=74
    else
      PageControlEve.Pages[_onglet_medias].ImageIndex:=66;
   end;
  if not IBTemoins.IsEmpty then
    PageControlEve.Pages[_onglet_temoins].ImageIndex:=74
  else
    PageControlEve.Pages[_onglet_temoins].ImageIndex:=66;
end;

procedure TFIndividuUnion.edNotesEvenementKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  if not FFormIndividu.DialogMode then
  begin
    s:=edNotesEvenement.Text;
    k:=edNotesEvenement.SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      if not(IBQEve.state in [dsEdit,dsInsert]) then
        IBQEve.Edit;
      IBQEveEV_FAM_COMMENT.AsString:=s;
      edNotesEvenement.SelStart:=k;
      BloqueCar:=true;
    end;
  end;
end;

procedure TFIndividuUnion.edSourcesEvenementKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  if not FFormIndividu.DialogMode then
  begin
    s:=edSourcesEvenement.Text;
    k:=edSourcesEvenement.SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      if not(IBQEve.state in [dsEdit,dsInsert]) then
        IBQEve.Edit;
      IBQEveEV_FAM_SOURCE.AsString:=s;
      edSourcesEvenement.SelStart:=k;
      BloqueCar:=true;
    end;
  end;
end;

procedure TFIndividuUnion.edSourcesEvenementDblClick(Sender:TObject);
begin
  ExecuteChaineDansChaine(edSourcesEvenement.Text,edSourcesEvenement.SelStart,edSourcesEvenement.SelLength);
end;

procedure TFIndividuUnion.edNotesEvenementDblClick(Sender:TObject);
begin
  ExecuteChaineDansChaine(edNotesEvenement.Text,edNotesEvenement.SelStart,edNotesEvenement.SelLength);
end;

procedure TFIndividuUnion.IBTemoinsCalcFields(DataSet:TDataSet);
begin
  IBTemoinsNOM_PRENOM.AsString:=
    AssembleString([IBTemoinsNOM.AsString,IBTemoinsPRENOM.AsString])
  +GetStringNaissanceDeces(IBTemoinsANNEE_NAISSANCE.AsString
    ,IBTemoinsANNEE_DECES.AsString);
end;

procedure TFIndividuUnion.AjouteTemoin(Temoin,Sexe:integer;NomPrenom,Naissance,Deces:string);
var
  suite:boolean;
begin
  if IBTemoins.State in [dsInsert,dsEdit] then
    IBTemoins.Post;
  IBTemoins.DisableControls;
  try
    suite:=True;
    IBTemoins.First;
    while not IBTemoins.Eof do
    begin
      if IBTemoinsASSOC_KLE_ASSOCIE.AsInteger=Temoin then
      begin
        suite:=False;
        Break;
      end;
      IBTemoins.Next;
    end;
    if suite then
    begin
      IBTemoins.Append;
      IBTemoinsASSOC_CLEF.AsInteger:=dm.uf_GetClefUnique('T_ASSOCIATIONS');
      IBTemoinsASSOC_KLE_DOSSIER.AsInteger:=dm.NumDossier;
      IBTemoinsASSOC_TABLE.AsString:='U';
      IBTemoinsASSOC_EVENEMENT.AsInteger:=IBQEveEV_FAM_CLEF.AsInteger;
      IBTemoinsASSOC_KLE_IND.AsInteger:=IBQEveEV_FAM_CLEF.AsInteger;
      IBTemoinsASSOC_KLE_ASSOCIE.AsInteger:=Temoin;
      IBTemoinsASSOC_LIBELLE.AsString:=dm.AssociationDefaut;
      IBTemoinsNOM.AsString:=NomPrenom;
      IBTemoinsSEXE.AsInteger:=Sexe;
      if _GDate.DecodeHumanDate(Naissance) then
        if _GDate.UseDate1 then
          IBTemoinsANNEE_NAISSANCE.AsInteger:=_GDate.Year1;
      if _GDate.DecodeHumanDate(Deces) then
        if _GDate.UseDate1 then
          IBTemoinsANNEE_DECES.AsInteger:=_GDate.Year1;

      IBTemoins.Post;
      FFormIndividu.doBouton(true);
      PageControlEveChange(nil);
      cxGridTemoins.SetFocus;
    end;
  finally
    IBTemoins.EnableControls;
  end;
end;

procedure TFIndividuUnion.BtAjoutTemoinClick(Sender:TObject);
var
  aFIndividuRepertoire:TFIndividuRepertoire;
  {NewAssocCle,}i_clef:integer;
  lettre:string;
begin
  if BtAjoutTemoin.Visible and BtAjoutTemoin.Enabled then
  begin
    if PageControlEve.ActivePageIndex=_onglet_temoins then
    begin
      FFormIndividu.PostIndividu;
      //Création de la boite de recherche d'un individu par le prénom
      aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
      try
        CentreLaFiche(aFIndividuRepertoire);
        aFIndividuRepertoire.NomIndi:=FMain.NomIndi;
        lettre:=copy(fs_FormatText(aFIndividuRepertoire.NomIndi,mftUpper,True),1,1);
        aFIndividuRepertoire.InitIndividuPrenom(lettre,'INDEX',0,FFormIndividu.CleFiche,False,True);
        aFIndividuRepertoire.Caption:=rs_caption_Select_Witness;
        if aFIndividuRepertoire.ShowModal=mrOk then
        begin
          AjouteTemoin(aFIndividuRepertoire.ClefIndividuSelected,aFIndividuRepertoire.SexeIndividuSelected
            ,aFIndividuRepertoire.NomPrenomIndividuSelected,aFIndividuRepertoire.NaissanceIndividuSelected
            ,aFIndividuRepertoire.DecesIndividuSelected);
        end;
      finally
        FreeAndNil(aFIndividuRepertoire);
      end;
    end
    else //_onglet_medias
    begin
      i_clef:=FMain.OuvreBiblioMedias(True,IBQEveEV_FAM_CLEF.AsInteger,'F','A');
      if i_clef>0 then
      begin
        IBMedias.Close;
        IBMedias.Open;
        FFormIndividu.doBouton(true);
        if IBMedias.RecordCount=1 then //c'est le premier
        begin
          if not(IBQEve.State in [dsEdit,dsInsert]) then
            IBQEve.edit;
          IBQEveMULTI_CLEF.AsInteger:=1;
          PageControlEveChange(nil);
        end;
      end;
    end;
  end;
end;

procedure TFIndividuUnion.BtSupprimeTemoinClick(Sender:TObject);
begin
  if BtSupprimeTemoin.Visible and BtSupprimeTemoin.Enabled then
  begin
    if PageControlEve.ActivePageIndex=_onglet_temoins then
    begin
      if MyMessageDlg(rs_Confirm_deleting_this_witness_associated_with+_CRLF+FMain.NomIndiComplet+' ?',
        mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
      begin
        IBTemoins.Delete;
        FFormIndividu.doBouton(true);
        PageControlEveChange(nil);
      end;
    end
    else
    begin//_onglet_medias
      if MyMessageDlg(rs_Confirm_media_unlink_from_event,
        mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
      begin
        IBMedias.Delete;
        if IBMedias.IsEmpty then
        begin
          if not(IBQEve.state in [dsEdit,dsInsert]) then
            IBQEve.Edit;
          IBQEveMULTI_CLEF.AsInteger:=0;
          PageControlEveChange(nil);
        end;
        FFormIndividu.doBouton(true);
      end;
    end;
  end;
end;

procedure TFIndividuUnion.cxGridTableTemoinsColRolePropertiesInitPopup(
  Sender:TObject);
var
  i:integer;
  AText:string;
begin
  if DSTemoins.AutoEdit then
  begin
    Atext:=(sender as TFWDBLookupCombo).Caption;
    if (length(AText)=0)or(AText=dm.AssociationDefaut) then
      TFWDBComboBox(Sender).Items:=dm.ListeAssociations
    else
    begin
      TFWDBComboBox(Sender).Items.Clear;
      for i:=1 to dm.ListeAssociations.Count-1 do
        TFWDBComboBox(Sender).Items.Add(copy(AText+' '+dm.ListeAssociations[i],1,90));
    end;
  end
  else
    TFWDBComboBox(Sender).Items.Clear;
end;

procedure TFIndividuUnion.DSTemoinsStateChange(Sender:TObject);
begin
  if DSTemoins.State in [dsEdit,dsInsert] then
    FFormIndividu.doBouton(true);
end;

procedure TFIndividuUnion.Ouvrirlafiche1Click(Sender:TObject);
begin
  if IBTemoinsASSOC_KLE_ASSOCIE.AsInteger>0 then
  begin
    dm.individu_clef:=IBTemoinsASSOC_KLE_ASSOCIE.AsInteger;
    DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
  end
end;
procedure TFIndividuUnion.gridEventsDBTableView1CanFocusRecord(
  Sender:TObject;ARecord:Longint;
  var AAllow:Boolean);
begin
{
  Matthieu ?
  if ARecord.DisplayTexts[gridEventsType.Index]='EVEN' then
  begin
    sender.OptionsSelection.CellSelect:=true;
  end
  else
  begin
    sender.OptionsSelection.CellSelect:=false;
  end;}
end;

procedure TFIndividuUnion.IBQEveBeforePost(DataSet:TDataSet);
begin//ModifySQL doit exister, donc "y mettre quelque chose" en mode conception
  if not(IBQEve.State in [dsInsert]) then //ModifySQL pas concerné si Insert
  begin
    IBUEve.ModifySQL.Text:='update EVENEMENTS_FAM set'
      +' EV_FAM_DATE_WRITEN=:EV_FAM_DATE_WRITEN'
      +',EV_FAM_DATE=:EV_FAM_DATE'
      +',EV_FAM_DATE_YEAR=:EV_FAM_DATE_YEAR'
      +',EV_FAM_DATE_MOIS=:EV_FAM_DATE_MOIS'
      +',EV_FAM_DATE_YEAR_FIN=:EV_FAM_DATE_YEAR_FIN'
      +',EV_FAM_DATE_MOIS_FIN=:EV_FAM_DATE_MOIS_FIN'
      +',EV_FAM_CP=:EV_FAM_CP'
      +',EV_FAM_VILLE=:EV_FAM_VILLE'
      +',EV_FAM_DEPT=:EV_FAM_DEPT'
      +',EV_FAM_PAYS=:EV_FAM_PAYS'
      +',EV_FAM_SOURCE=:EV_FAM_SOURCE'
      +',EV_FAM_COMMENT=:EV_FAM_COMMENT'
      +',EV_FAM_REGION=:EV_FAM_REGION'
      +',EV_FAM_SUBD=:EV_FAM_SUBD'
      +',EV_FAM_ACTE=:EV_FAM_ACTE'
      +',EV_FAM_INSEE=:EV_FAM_INSEE'
      +',EV_FAM_HEURE=:EV_FAM_HEURE'
      +',EV_FAM_LATITUDE=:EV_FAM_LATITUDE'
      +',EV_FAM_LONGITUDE=:EV_FAM_LONGITUDE'
      +',EV_FAM_DESCRIPTION=:EV_FAM_DESCRIPTION'
      +',EV_FAM_CAUSE=:EV_FAM_CAUSE'
      +',ev_fam_date_jour=:ev_fam_date_jour'
      +',ev_fam_date_jour_fin=:ev_fam_date_jour_fin'
      +',ev_fam_type_token1=:ev_fam_type_token1'
      +',ev_fam_type_token2=:ev_fam_type_token2'
      +',ev_fam_datecode=:ev_fam_datecode'
      +',ev_fam_datecode_tot=:ev_fam_datecode_tot'
      +',ev_fam_datecode_tard=:ev_fam_datecode_tard';
    if IBQEveEV_FAM_TYPE.AsString='EVEN' then
      IBUEve.ModifySQL.Add(',EV_FAM_TITRE_EVENT=:EV_FAM_TITRE_EVENT')
    else
      IBUEve.ModifySQL.Add(',EV_FAM_TITRE_EVENT=null');
    IBUEve.ModifySQL.Add('where EV_FAM_CLEF=:OLD_EV_FAM_CLEF');
  end;
end;

procedure TFIndividuUnion.gridEventsDBTableView1InitEdit(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit);
var
  l,i:integer;
begin
 { Matthieu ?
 if IBQEveEV_FAM_TYPE.AsString='EVEN' then
  begin
    l:=69-length(IBQEveEV_FAM_DESCRIPTION.AsString);
    if l>25 then
      l:=25;
    TFWDBLookupCombo(AEdit).MaxLength:=l;
    TFWDBLookupCombo(AEdit).Style.ButtonStyle:=btsOffice11;
    TFWDBLookupCombo(AEdit).Style.ButtonTransparency:=ebtHideUnselected;
    for i:=0 to TFWDBLookupCombo(AEdit).Properties.Buttons.Count-1 do
      TFWDBLookupCombo(AEdit).Properties.Buttons.Items[i].Visible:=okModif;
    if okModif then
    begin
      TFWDBLookupCombo(AEdit).Items:=dm.ListeDiversFam;
      FMain.MsgBarreEtat(0,'titre de l''événement de '+IntToStr(l)+' caractères maxi');
    end;
  end
  else
  begin
    TFWDBLookupCombo(AEdit).MaxLength:=30;
  end;}
end;

procedure TFIndividuUnion.edDescEnter(Sender:TObject);
var
  l:integer;
begin
  if IBQEveEV_FAM_TYPE.AsString='EVEN' then
  begin
    l:=89-length(IBQEveEV_FAM_TITRE_EVENT.AsString);
    TFWDBEdit(sender).MaxLength:=l;
    if okModif then
      FMain.MsgBarreEtat(0,'description de '+IntToStr(l)+' caractères maxi');
  end
  else
    TFWDBEdit(sender).MaxLength:=90;
end;

procedure TFIndividuUnion.edDescExit(Sender:TObject);
begin
  FMain.MsgBarreEtat(0);
end;

procedure TFIndividuUnion.gridEventsColLibellePropertiesExit(
  Sender:TObject);
begin
  FMain.MsgBarreEtat(0);
end;

procedure TFIndividuUnion.PmChangeFichePopup(Sender:TObject);
begin
  if IBTemoinsASSOC_KLE_ASSOCIE.AsInteger>0 then
    Ouvrirlafiche1.Visible:=true
  else
    Ouvrirlafiche1.Visible:=false;
end;

procedure TFIndividuUnion.cxGridTableTemoinsDblClick(Sender:TObject);
begin
  Ouvrirlafiche1Click(Sender);
end;

procedure TFIndividuUnion.PageControlNotesSourcesClick(Sender:TObject);
begin
  case PageControlNotesSources.ActivePageIndex of
    0:SendFocus(edCommentaires);
    1:SendFocus(edSources);
  end;
end;

procedure TFIndividuUnion.PageControlEveClick(Sender:TObject);
begin
  case PageControlEve.ActivePageIndex of
    _onglet_notes:SendFocus(edNotesEvenement);
    _onglet_sources:SendFocus(edSourcesEvenement);
    _onglet_temoins:SendFocus(cxGridTemoins);
    _onglet_medias:SendFocus(cxGridMedias);
  end;
end;

procedure TFIndividuUnion.mEffacerlelieuClick(Sender:TObject);
begin
  if not(ibqEve.State in [dsEdit,dsInsert]) then
    ibqEve.Edit;
  ibqEveEV_FAM_CP.Clear;
  ibqEveEV_FAM_VILLE.Clear;
  ibqEveEV_FAM_PAYS.Clear;
  ibqEveEV_FAM_DEPT.Clear;
  IBQEveEV_FAM_REGION.Clear;
  IBQEveEV_FAM_INSEE.Clear;
  IBQEveEV_FAM_LATITUDE.Clear;
  IBQEveEV_FAM_LONGITUDE.Clear;
  IBQEveEV_FAM_SUBD.Clear;
end;

procedure TFIndividuUnion.DSMediasStateChange(Sender:TObject);
begin
  if DSMedias.State in [dsEdit,dsInsert] then
    FFormIndividu.doBouton(true);
end;

procedure TFIndividuUnion.mVisualiseActeClick(Sender:TObject);
var
  iClef:integer;
begin
  if IBMedias.Active and not IBMedias.IsEmpty then
  begin
    iClef:=IBMedias.FieldByName('mp_media').AsInteger;
    VisualiseMedia(iClef,dm.ReqSansCheck);
  end;
end;

procedure TFIndividuUnion.cxGridTableMediasCellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  mVisualiseActeClick(sender);
end;

procedure TFIndividuUnion.mRemplacerDocumentClick(Sender:TObject);
var
  q:TIBSQL;
  mp_clef,mp_media:integer;
begin
  mp_media:=FMain.OuvreBiblioMedias(True,0,'','');
  if mp_media>0 then
  begin
    mp_clef:=IBMedias.FieldByName('mp_clef').AsInteger;
    if IBMedias.State in [dsInsert,dsEdit] then
      IBMedias.Post;
    IBMedias.Close;
    q:=TIBSQL.Create(self);
    with q do
    try
      Database:=dm.ibd_BASE;
      Transaction:=dm.IBT_BASE;
      SQL.Add('update media_pointeurs set mp_media=:mp_media where mp_clef=:mp_clef');
      ParamByName('mp_media').AsInteger:=mp_media;
      ParamByName('mp_clef').AsInteger:=mp_clef;
      ExecQuery;
      Close;
    finally
      Free;
    end;
    IBMedias.Open;
    FFormIndividu.doBouton(true);
  end;
end;

procedure TFIndividuUnion.TreeConjMouseDown(Sender:TObject;
  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
var
  Noeud:PVirtualNode;
begin
  Noeud:=TreeConj.GetNodeAt(X,Y);
  if (Noeud<>nil) Then
  begin
    TreeConj.FocusedNode:=noeud;
  end;
end;

procedure TFIndividuUnion.cxGridTemoinsExit(Sender:TObject);
begin//nécessaire si l'utilisateur n'a pas validé par Enter
  if DSTemoins.State in [dsInsert,dsEdit] then
    IBTemoins.Post;
end;

procedure TFIndividuUnion.PopupAjouteEvePopup(Sender:TObject);
begin
  mAjoutEvFam.Visible:=btnAddEvent.Visible and btnAddEvent.Enabled;
  mSuppEvFam.Visible:=btnDelEvent.Visible and btnDelEvent.Enabled;
  mTrierEvents.Visible:=mSuppEvFam.Visible;
  mSuppTriEvents.Visible:=mSuppEvFam.Visible;
end;

procedure TFIndividuUnion.cxGridTableMediasEditKeyDown(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit;var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
begin
{ Matthieu ?
 if (AItem=colMemo)and(not FFormIndividu.DialogMode) then
  begin
    s:=(aEdit as TMemo).Text;
    k:=(aEdit as TMemo).SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      if not(IBMedias.State in [dsEdit,dsInsert]) then
        IBMedias.Edit;
      IBMediasMULTI_MEMO.AsString:=s;
      (aEdit as TMemo).SelStart:=k;
      BloqueCar:=true;
    end;
  end;}
end;

procedure TFIndividuUnion.cxGridTableMediasEditKeyPress(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit;var Key:Char);
begin
  if BloqueCar then
  begin
    BloqueCar:=false;
    Key:=#0;
  end;
end;

procedure TFIndividuUnion.edCommentairesMouseEnter(Sender:TObject);
begin
  FMain.MsgBarreEtat(0,'Les raccourcis de saisie sont utilisables dans les champs Notes, Sources et Ville');
end;

procedure TFIndividuUnion.edVilleExit(Sender:TObject);
begin
  FMain.CtrlFbloqued:=false;
end;

procedure TFIndividuUnion.edSubdiEnter(Sender:TObject);
begin
  FMain.CtrlFbloqued:=true;
end;

procedure TFIndividuUnion.cxGridTableTemoinsInitEdit(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit);
var
  i:integer;
begin
{ Matthieu ?
  if AItem=cxGridTableTemoinsColRole then
  begin
    for i:=0 to(AEdit as TFWDBLookupCombo).Properties.Buttons.Count-1 do
      (AEdit as TFWDBLookupCombo).Properties.Buttons.Items[i].Visible:=DSTemoins.AutoEdit;

    if DSTemoins.AutoEdit then
    begin
      (AEdit as TFWDBLookupCombo).Style.ButtonStyle:=btsOffice11;
      (AEdit as TFWDBLookupCombo).Style.ButtonTransparency:=ebtHideUnselected;
    end;
  end;}
end;

procedure TFIndividuUnion.dsEveDataChange(Sender:TObject;Field:TField);
begin
  MajBtnLieux;
end;

procedure TFIndividuUnion.IBTemoinsMediasBeforeScrollOrClose(DataSet:TDataSet);
begin
  if dataset.State in [dsInsert,dsEdit] then
    dataset.Post;
end;

procedure TFIndividuUnion.mTrierEventsClick(Sender:TObject);
var
  aFTriEvent:TFTriEvent;
begin
  if IBQEve.Modified then
    IBQEve.Post;
  aFTriEvent:=TFTriEvent.create(self);
  try
    CentreLaFiche(aFTriEvent,FMain);
    aFTriEvent.doInit(IBQEveEV_FAM_KLE_FAMILLE.AsInteger,'F');
    aFTriEvent.ShowModal;
    if aFTriEvent.Modif then
    begin
      FFormIndividu.doBouton(true);
      ShowUnionEvents;
    end;
  finally
    FreeAndNil(aFTriEvent);
  end;
end;

procedure TFIndividuUnion.mSuppTriEventsClick(Sender:TObject);
var
  q:TIBSQL;
begin
  if IBQEve.Modified then
    IBQEve.Post;
  if MyMessageDlg(rs_Warning_Date_sorting_will_be_default+_CRLF+_CRLF
    +rs_Do_you_continue,mtWarning, [mbYes,mbNo],FMain)=mrYes then
  begin
    q:=TIBSQL.create(self);
    try
      q.Database:=dm.ibd_BASE;
      q.Transaction:=dm.IBT_BASE;
      q.SQL.Add('UPDATE EVENEMENTS_FAM SET EV_FAM_ORDRE=NULL WHERE EV_FAM_KLE_FAMILLE=:CLEF');
      q.Params[0].AsInteger:=IBQEveEV_FAM_KLE_FAMILLE.AsInteger;
      q.ExecQuery;
      q.Close;
    finally
      q.Free;
    end;
    FFormIndividu.doBouton(true);
    ShowUnionEvents;
  end;
end;

procedure TFIndividuUnion.CalculerAgesConjoints(DateEv:string);//AL2011
const
  devant=3;
  derriere=4;
var
  aNode:PVirtualNode;
  aNodeIndividu:TNodeIndividu;
  DateNaisConjoint:string;
  esp:integer;
begin
  DateNaisConjoint:='';
  aNode:=TreeConj.FocusedNode;
  with TreeConj do
  if aNode<>nil then
  begin
    if GetNodeData(aNode)<>nil then
    begin
      if (aNode^.Parent<>RootNode) then
        aNode:=aNode^.Parent;
      aNodeIndividu:=PNodeIndividu(GetNodeData(aNode))^;
      DateNaisConjoint:=aNodeIndividu.fDateNaissanceDeces;
    end;
  end;
  DBTextAge.Left:=edDate.Left;
  DBTextAge.AutoSize:=true;
  DBTextAge.Caption:=FFormIndividu.AgesConjoints(DateEv,DateNaisConjoint);
  esp:=DBTextJour.Left-DBTextAge.Left-DBTextAge.Width-derriere;
  if esp<0 then //ajuster la position et la taille de DBTextAge
  begin
    if esp>-(DBTextAge.Left+devant) then
    begin
      DBTextAge.Left:=DBTextAge.Left+esp;
    end
    else
    begin
      DBTextAge.Left:=devant;
      DBTextAge.AutoSize:=false;
      DBTextAge.Width:=DBTextJour.Left-devant-derriere;
    end;
  end;
end;

procedure TFIndividuUnion.mRemplacerConjointClick(Sender:TObject);
var
  NoeudConjoint:PVirtualNode;
  A_Conjoint,Union:integer;
  NomA_Conjoint:string;
begin
  NoeudConjoint:=TreeConj.FocusedNode;
  if NoeudConjoint<>nil then
  begin
    while NoeudConjoint^.Parent<>nil do
      NoeudConjoint:=NoeudConjoint^.Parent;
    with TreeConj, PNodeIndividu(GetNodeData(NoeudConjoint))^ do
     Begin
      A_Conjoint:=fCleFiche;
      if A_Conjoint>0 then
        NomA_Conjoint:=fNom
      else
        NomA_Conjoint:='';
      Union:=fClefUnion;
      FFormIndividu.RemplacerConjoint(Union,A_Conjoint,NomA_Conjoint);
     end;
  end;
end;

procedure TFIndividuUnion.cxComboBoxActeExit(Sender:TObject);
begin
  if GetKeyState(VK_TAB)<0 then
  begin
    PageControlEve.ActivePage:=OngletNotes;
    SendFocus(edNotesEvenement);
  end;
end;

procedure TFIndividuUnion.PageControlEveEnter(Sender:TObject);
begin
  bPageControlEve:=true;
end;

procedure TFIndividuUnion.PageControlEveExit(Sender:TObject);
begin
  bPageControlEve:=false;
end;

procedure TFIndividuUnion.PageControlNotesSourcesEnter(Sender:TObject);
begin
  bPageControlNotesSources:=true;
end;

procedure TFIndividuUnion.PageControlNotesSourcesExit(Sender:TObject);
begin
  bPageControlNotesSources:=false;
end;

procedure TFIndividuUnion.LabelParenteMouseDown(Sender:TObject;
  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  VoirAncetreCommun;
end;

procedure TFIndividuUnion.VoirAncetreCommun;
begin
  FMain.OuvreLienGene(CleConjoint,FFormIndividu.QueryIndividuCLE_FICHE.AsInteger
    ,NomConjointComplet,FFormIndividu.NomIndiComplet);
end;

procedure TFIndividuUnion.TreeConjDragOver(Sender,Source:TObject;X,
  Y:Integer;State:TDragState;var Accept:Boolean);
var
  i:Integer;
begin
  try
    if FFormIndividu.DialogMode then
      Accept:=False
    else if FFormIndividu.QueryIndividuSEXE.AsInteger=0 then
      Accept:=False//on ne peut ajouter un conjoint ou un enfant à un individu sans sexe connu
    else if FFormIndividu.CleFiche=FMain.IndiDrag.cle then
      Accept:=False//on ne peut ajouter l'individu lui-même
    else if (FFormIndividu.QueryIndividuSEXE.AsInteger=FMain.IndiDrag.sexe)
      or(FMain.IndiDrag.sexe=0)or(not bsfbAjout.Visible)or(not bsfbAjout.Enabled) then //ajout d'un conjoint
      Accept:=False//on ne peut ajouter un conjoint du même sexe ni de sexe nul
    else
    begin
      //on ne peut pas ajouter un individu qui y est déjà
      Accept:=not TreeNodeIsPresent(TreeConj,fmain.IndiDrag.cle);
    end;
  except
    Accept:=false;
  end;
end;

procedure TFIndividuUnion.TreeConjDragDrop(Sender,Source:TObject;X,
  Y:Integer);
begin
  if FFormIndividu.TestAscDesc(FFormIndividu.CleFiche
    ,FMain.IndiDrag.cle
    ,FFormIndividu.GetNomIndividu
    ,FMain.IndiDrag.nomprenom
    ,true,true) then //possible si inceste
    exit;
  if CreationUnion(FMain.IndiDrag.cle) then
  begin
    doGoto(FMain.IndiDrag.cle);
    if gci_context.CreationMARRConjoint then
      CreationEvFam('MARR','');
  end;
end;

procedure TFIndividuUnion.cxGridTableTemoinsDragOver(Sender,
  Source:TObject;X,Y:Integer;State:TDragState;var Accept:Boolean);
begin
  if FFormIndividu.DialogMode
    or not BtAjoutTemoin.Visible
    or not BtAjoutTemoin.Enabled then
    Accept:=False
  else
    Accept:=True;
end;

procedure TFIndividuUnion.cxGridTableTemoinsDragDrop(Sender,
  Source:TObject;X,Y:Integer);
begin
  try
    AjouteTemoin(FMain.IndiDrag.cle,FMain.IndiDrag.sexe,FMain.IndiDrag.nomprenom
      ,FMain.IndiDrag.naissance,FMain.IndiDrag.deces);
  finally
    Abort;
  end;
end;

procedure TFIndividuUnion.Calculssurlesdates1Click(Sender: TObject);
begin
  if (IBQEve.Active)and not IBQEve.IsEmpty then
  begin
    FMain.OuvreCalculsDates(IBQEveEV_FAM_DATE_WRITEN.AsString);
  end;
end;

procedure TFIndividuUnion.TreeEventsClick(Sender: TObject);
begin
  IBQEve.RecNo:=( Sender as TControl ).Tag;
end;

procedure TFIndividuUnion.MajBtnLieux;
var i : Integer;
    curseur : TCursor;
begin
  with IBQEve do
  if Active Then
   Begin
    btnVillesVoisines.enabled:=(length(FieldByName('EV_FAM_LATITUDE').AsString)>0)
      and(length(FieldByName('EV_FAM_LONGITUDE').AsString)>0);
    btnInternet.Enabled:=not IsEmpty
      and not(FieldByName('EV_FAM_VILLE').IsNull
              and(not fCassiniDll or(UTF8UpperCase(FieldByName('EV_FAM_PAYS').AsString)<>'FRANCE'))
              and(not btnVillesVoisines.enabled));
   end;
  pmGoogle.AutoPopup:=(Trim(edVille.Text)>'')and(not FFormIndividu.DialogMode);
  if pmGoogle.AutoPopup then
    curseur:=crHandPoint
  else
    curseur:=crDefault;
  for i:=0 to PanLieu.ControlCount-1 do
    if (PanLieu.Controls[i] is TCustomMaskEdit)or(PanLieu.Controls[i] is TCustomComboBox) then
      TControl(PanLieu.Controls[i]).Cursor:=curseur;
end;

procedure TFIndividuUnion.edLatitudePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
  if not BcdIsValide(DisplayValue)then
  begin
    MyMessageDlg(rs_Error_value_or_format_error,mtError, [mbOk],FMain);
    (Sender as TMaskEdit).SetFocus;
    Abort;
  end;
end;

procedure TFIndividuUnion.edNotesEvenementPropertiesEditValueChanged(
  Sender: TObject);
begin //le Post n'est pas automatique lors du changement d'enregistrement si seul le mémo a été effacé!
  with Sender as TDBMemo do
  if (DataSource.State=dsEdit)
   and Field.IsNull then
      DataSource.DataSet.Post;
end;

procedure TFIndividuUnion.colMemoPropertiesEditValueChanged(
  Sender: TObject);
begin //le Post n'est pas automatique lors du changement d'enregistrement si seul le mémo a été effacé!
  if (DSMedias.State=dsEdit) and ((Sender as TExtDBGrid).Columns [ 1 ].Field.IsNull) then
    IBMedias.Post;
end;

procedure TFIndividuUnion.p_AfterDownloadCoord;
begin
  IBQEve.AutoCalcFields:=False;
  try
   if not(IBQEve.State in [dsEdit,dsInsert]) then
      IBQEve.Edit;
    if dm.UneSubd>'' then
      IBQEveEV_FAM_SUBD.asString:=dm.UneSubd;
    IBQEveEV_FAM_LATITUDE.asString:=dm.UneLatitude;
  Finally
    IBQEve.AutoCalcFields:=True;
  end;
  IBQEveEV_FAM_LONGITUDE.asString:=dm.UneLongitude;
end;

procedure TFIndividuUnion.mAcquerirClick(Sender: TObject);
begin
  dm.UneLatitude:=edLatitude.Text;
  dm.UneLongitude:=edLongitude.Text;
  dm.UneSubd:=edSubdi.Text;
  DoCoordNext:=TProcedureOfObject(p_AfterDownloadCoord);
  dm.GetCoordonneesInternet(edVille.Text,edDept.Text,edRegion.Text,edPays.Text,self);
end;

procedure TFIndividuUnion.pmGooglePopup(Sender: TObject);
begin
  FMain.MsgBarreEtat(0,mAcquerir.Hint);
end;

procedure TFIndividuUnion.InfoCopie(Sender: TObject);
begin
  FMain.MsgBarreEtat(0,'Ctrl+G demande les coordonnées sur Google Maps.');
end;

function TFIndividuUnion.CalcChampsDateFam(Dataset:TDataset;DateWriten:String):String;
var
  LaDate:TGedcomDate;
  EtatCalcFields:Boolean;
begin
  if not (Dataset.State in [dsInsert,dsEdit]) then
    Dataset.Edit;
  EtatCalcFields:=Dataset.AutoCalcFields;
  Dataset.DisableControls;
  Dataset.AutoCalcFields:=False;
  LaDate:=TGedcomDate.Create;
  LaDate.InitTGedcomDate(_MotsClesDate,_MotsClesDate);
  with DataSet do
  try
    if LaDate.DecodeHumanDate(DateWriten) then
    begin
      if LaDate.ValidDateTime1 and (LaDate.DateTime1>-DateDelta) then
        DataSet.FieldByName('EV_FAM_DATE').AsDateTime:=LaDate.DateTime1
      else
        FieldByName('EV_FAM_DATE').Clear;
      FieldByName('EV_FAM_DATECODE').AsInteger:=LaDate.DateCode1;
      FieldByName('EV_FAM_DATECODE_TOT').AsInteger:=LaDate.DateCodeTot;
      FieldByName('EV_FAM_DATECODE_TARD').AsInteger:=LaDate.DateCodeTard;
      FieldByName('EV_FAM_DATE_YEAR').AsInteger:=LaDate.Year1;
      if LaDate.Month1>0 then
        FieldByName('EV_FAM_DATE_MOIS').AsInteger:=LaDate.Month1
      else
        FieldByName('EV_FAM_DATE_MOIS').Clear;
      if LaDate.Day1>0 then
        FieldByName('EV_FAM_DATE_JOUR').AsInteger:=LaDate.Day1
      else
        FieldByName('EV_FAM_DATE_JOUR').Clear;
      if LaDate.Type_Key1>0 then
        FieldByName('EV_FAM_TYPE_TOKEN1').AsInteger:=LaDate.Type_Key1
      else
        FieldByName('EV_FAM_TYPE_TOKEN1').Clear;
      if LaDate.UseDate2 then
      begin
        FieldByName('EV_FAM_DATE_YEAR_FIN').AsInteger:=LaDate.Year2;
        if LaDate.Month2>0 then
          FieldByName('EV_FAM_DATE_MOIS_FIN').AsInteger:=LaDate.Month2
        else
          FieldByName('EV_FAM_DATE_MOIS_FIN').Clear;
        if LaDate.Day2>0 then
          FieldByName('EV_FAM_DATE_JOUR_FIN').AsInteger:=LaDate.Day2
        else
          FieldByName('EV_FAM_DATE_JOUR_FIN').Clear;
        if LaDate.Type_Key2>0 then
          FieldByName('EV_FAM_TYPE_TOKEN2').AsInteger:=LaDate.Type_Key2
        else
          FieldByName('EV_FAM_TYPE_TOKEN2').Clear;
        FieldByName('EV_FAM_CALENDRIER2').AsInteger:=ord(LaDate.Calendrier2);
      end
      else
      begin
        FieldByName('EV_FAM_DATE_YEAR_FIN').Clear;
        FieldByName('EV_FAM_DATE_MOIS_FIN').Clear;
        FieldByName('EV_FAM_DATE_JOUR_FIN').Clear;
        FieldByName('EV_FAM_TYPE_TOKEN2').Clear;
        FieldByName('EV_FAM_CALENDRIER2').AsInteger:=0;
      end;
    end
    else
    begin
      FieldByName('EV_FAM_DATE').Clear;
      FieldByName('EV_FAM_DATECODE').Clear;
      FieldByName('EV_FAM_DATECODE_TOT').Clear;
      FieldByName('EV_FAM_DATECODE_TARD').Clear;
      FieldByName('EV_FAM_DATE_YEAR').Clear;
      FieldByName('EV_FAM_DATE_MOIS').Clear;
      FieldByName('EV_FAM_DATE_JOUR').Clear;
      FieldByName('EV_FAM_TYPE_TOKEN1').Clear;
      FieldByName('EV_FAM_DATE_YEAR_FIN').Clear;
      FieldByName('EV_FAM_DATE_MOIS_FIN').Clear;
      FieldByName('EV_FAM_DATE_JOUR_FIN').Clear;
      FieldByName('EV_FAM_TYPE_TOKEN2').Clear;
      FieldByName('EV_FAM_CALENDRIER1').AsInteger:=0;
      FieldByName('EV_FAM_CALENDRIER2').AsInteger:=0;
    end;
    Result:=LaDate.HumanDate;
  finally
    LaDate.Free;
    AutoCalcFields:=EtatCalcFields;
    EnableControls;
  end;//déclanchement du OnCalcFields une seule fois
  if Result='' then
    DataSet.FieldByName('EV_FAM_DATE_WRITEN').Clear
  else
    DataSet.FieldByName('EV_FAM_DATE_WRITEN').AsString:=Result;
end;

end.


