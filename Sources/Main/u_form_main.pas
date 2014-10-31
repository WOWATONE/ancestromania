{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}
unit u_form_main;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  // -- Fenetres et objets de l'appli -------------------------------------------
{$IFNDEF FPC}
  ShellApi, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  u_comp_TYLanguage,
  u_form_individu,
  u_form_list_report,
  u_form_rechercher,
  u_form_anniversaires,
  u_form_arbre_Hierarchique,
  u_form_tv_ascendance,
  u_form_import_gedcom,
  u_form_export_gedcom,
  u_form_graph_paintbox,
  u_form_export_geneanet,
  u_form_postit,
  u_form_edit_ref_particules,
  u_form_edit_ref_prefixes,
  u_form_edit_ref_filiation,
  u_form_edit_raccourcis,
  u_form_select_database,
  u_form_Restore,
  u_form_OpenSources,
  u_form_individu_repertoire,
  u_Form_Histoire,
  u_Form_Recherche_Actes,
  u_Form_Recherche_Ancetres,
  u_Form_Indi_DateIncoherentes,
  u_Form_Liste_Doublons,
  u_Form_Bibliotheque_Multimedia,
  u_Form_Groupe_Indis,
  u_Form_Liste_Unions,
  u_form_env_famille,
  u_Form_Utilisation_Media,
  u_form_list_villes_Voisines,
  u_Form_Orphelins,
  u_Form_Posthumes,
  u_Form_Qui_Porte_ce_Titre,
  u_form_CalculDate,
  // -- Compos standard -----------------------------------------------------------------
  Forms, U_FormAdapt, Menus, IniFiles, fonctions_init, ExtCtrls, SysUtils,
  StrUtils, IBSQL, Controls, StdCtrls, Graphics, Classes, Dialogs, ComCtrls,
  U_OnFormInfoIni, u_extmenutoolbar, u_extmenucustomize;

type

  { TFMain }

  TFMain=class(TF_FormAdapt)
    Aide2: TMenuItem;
    Anniversaires2: TMenuItem;
    Arbredascendance2: TMenuItem;
    ArbreDescendance1: TMenuItem;
    Blocnotes3: TMenuItem;
    Commentamarche2: TMenuItem;
    Documents2: TMenuItem;
    Dossiers2: TMenuItem;
    dxBarButton4: TMenuItem;
    MenuIni: TMainMenu;
    dxBarSubItem5: TMenuItem;
    dxBarSubItem6: TMenuItem;
    dxBarSubItem8: TMenuItem;
    dxbDoublonsVille1: TMenuItem;
    dxbJournal1: TMenuItem;
    Emplacementdelabasededonne2: TMenuItem;
    ExporterauformatGEDCOM2: TMenuItem;
    ExporterauformatGeneaNet2: TMenuItem;
    ExportImages1: TMenuItem;
    FicheIndividu2: TMenuItem;
    Fichier2: TMenuItem;
    ImporterauformatGEDCOM2: TMenuItem;
    Informations2: TMenuItem;
    LibelDiversFam1: TMenuItem;
    LibelDiversIndi1: TMenuItem;
    LibelUnions1: TMenuItem;
    Listeparprnom2: TMenuItem;
    mAddon1: TMenuItem;
    mAideSQL1: TMenuItem;
    mAncestroWeb1: TMenuItem;
    mAncetreSansParent1: TMenuItem;
    mArbrehier1: TMenuItem;
    mArbreHierAscendant1: TMenuItem;
    mBiblioMedias1: TMenuItem;
    mCalculDates1: TMenuItem;
    mCalendrier1: TMenuItem;
    mChercheNIP1: TMenuItem;
    mConsanguinTotal1: TMenuItem;
    mCousinage1: TMenuItem;
    mCreateIndi1: TMenuItem;
    mCtrlAscMere1: TMenuItem;
    mCtrlAscPere1: TMenuItem;
    mDateIncoherentes1: TMenuItem;
    mDeleteBranche1: TMenuItem;
    mDelImport1: TMenuItem;
    MenuCustomize: TExtMenuCustomize;
    ImagesDisabled: TImageList;
    MenuFavoris_Add1: TMenuItem;
    MenuLeft: TExtMenuToolBar;
    menu_Configuration1: TMenuItem;
    menu_Favoris1: TMenuItem;
    menu_go_web_la_guilde1: TMenuItem;
    menu_ImportExport1: TMenuItem;
    menu_Impressions1: TMenuItem;
    menu_Individu1: TMenuItem;
    mEnvFam1: TMenuItem;
    mExtras1: TMenuItem;
    mFenetres1: TMenuItem;
    mGroupeIndis1: TMenuItem;
    mImportDossier1: TMenuItem;
    mInfosVersion1: TMenuItem;
    mLesLieux1: TMenuItem;
    mListe1: TMenuItem;
    mListeUnions1: TMenuItem;
    mLivreSQL1: TMenuItem;
    mMaj1: TMenuItem;
    mMotsclefsDates1: TMenuItem;
    mNouveaux1: TMenuItem;
    mOpenSource1: TMenuItem;
    mOptimise1: TMenuItem;
    mOrphelins1: TMenuItem;
    mPatroMaj1: TMenuItem;
    mPatroMin1: TMenuItem;
    mPosthume1: TMenuItem;
    mPrenomsMaj1: TMenuItem;
    mPrenomsMin1: TMenuItem;
    mQuiPorteCeTitre1: TMenuItem;
    mRechercheActes1: TMenuItem;
    mRemplacerPatro1: TMenuItem;
    mRequetes1: TMenuItem;
    mResetToolBar1: TMenuItem;
    mResetWindows1: TMenuItem;
    mRestaureBases1: TMenuItem;
    mSaisierapide1: TMenuItem;
    mSauvegarde1: TMenuItem;
    mSepPrenomsEspace1: TMenuItem;
    mSepPrenomsVirg1: TMenuItem;
    mSupprimeSosa1: TMenuItem;
    mTagGedcom1: TMenuItem;
    mTrucs1: TMenuItem;
    mVoirPoint1: TMenuItem;
    OnFormInfoIni: TOnFormInfoIni;
    option_RenumerotationSOSA1: TMenuItem;
    Panel3:TPanel;
    panDock:TScrollBox;
    Language:TYLanguage;
    iBars4:TImage;
    lEnteteColonne:TLabel;
    dxBarManager:TMainMenu;
    Fichier1:TMenuItem;
    Dossiers1:TMenuItem;
    Informations1:TMenuItem;
    Blocnotes2:TMenuItem;
    Partenaires1: TMenuItem;
    Particules2: TMenuItem;
    Prfixes2: TMenuItem;
    Prfrences3: TMenuItem;
    Quitter1:TMenuItem;
    menu_Individu:TMenuItem;
    Listeparprnom1:TMenuItem;
    FicheIndividu1:TMenuItem;
    mSaisierapide:TMenuItem;
    Quitter2: TMenuItem;
    Raccourissaisie2: TMenuItem;
    Recherchededoublons1: TMenuItem;
    Rechercher2:TMenuItem;
    Recherchededoublons:TMenuItem;
    mNouveaux:TMenuItem;
    mListeUnions:TMenuItem;
    mCousinage:TMenuItem;
    mArbrehier:TMenuItem;
    Anniversaires1:TMenuItem;
    option_RenumerotationSOSA:TMenuItem;
    menu_Favoris:TMenuItem;
    MenuFavoris_Add:TMenuItem;
    menu_ImportExport:TMenuItem;
    ImporterauformatGEDCOM1:TMenuItem;
    ExporterauformatGEDCOM1:TMenuItem;
    ExporterauformatGeneaNet1:TMenuItem;
    ExportImages:TMenuItem;
    menu_Impressions:TMenuItem;
    Arbredascendance1:TMenuItem;
    Rechercher3: TMenuItem;
    RelaTemoins1: TMenuItem;
    Rouedascendance1:TMenuItem;
    Documents1:TMenuItem;
    menu_Configuration:TMenuItem;
    Prfrences2:TMenuItem;
    Raccourissaisie1:TMenuItem;
    Prfixes1:TMenuItem;
    Particules1:TMenuItem;
    mMotsclefsDates: TMenuItem;
    Rouedascendance2: TMenuItem;
    SubItemSuppFav1: TMenuItem;
    SuppTousFavoris1: TMenuItem;
    sxMListeDiffusion1: TMenuItem;
    TypesFiliation1: TMenuItem;
    VillesCodes1:TMenuItem;
    Emplacementdelabasededonne1:TMenuItem;
    mOptimise:TMenuItem;
    Aide1:TMenuItem;
    menu_go_web_la_guilde:TMenuItem;
    Partenaires:TMenuItem;
    dxBarButton1:TMenuItem;
    mOpenSource:TMenuItem;
    mAddon:TMenuItem;
    mCalendrier:TMenuItem;
    mOrphelins:TMenuItem;
    mPosthume:TMenuItem;
    mMajInsee:TMenuItem;
    mTagGedcom:TMenuItem;
    mMaj:TMenuItem;
    dxbDoublonsVille:TMenuItem;
    mBiblioMedias:TMenuItem;
    sxMListeDiffusion:TMenuItem;
    Image2:TImage;
    Image5:TImage;
    Image6:TImage;
    mInfosVersion:TMenuItem;
    mSauvegarde:TMenuItem;
    dxbJournal:TMenuItem;
    mLesLieux:TMenuItem;
    mAideSQL:TMenuItem;
    mLivreSQL:TMenuItem;
    mExtras:TMenuItem;
    mCreateIndi:TMenuItem;
    mConsanguinTotal:TMenuItem;
    mCalculDates:TMenuItem;
    mResetToolBar:TMenuItem;
    mDeleteBranche:TMenuItem;
    mDelImport:TMenuItem;
    mListe:TMenuItem;
    mResetWindows:TMenuItem;
    majCoordParCPAvecTransfert:TMenuItem;
    mMajCoordGeo:TMenuItem;
    majCoordParCPSansTransfert:TMenuItem;
    mImportDossier:TMenuItem;
    mVoirPoint:TMenuItem;
    mTrucs:TMenuItem;
    mDateIncoherentes:TMenuItem;
    mQuiPorteCeTitre:TMenuItem;
    dxStatusBar:TStatusBar;
    mChercheNIP:TMenuItem;
    mSupprimeSosa:TMenuItem;
    mRechercheActes:TMenuItem;
    mAncetreSansParent:TMenuItem;
    mGroupeIndis:TMenuItem;
    SubItemSuppFav:TMenuItem;
    SuppTousFavoris:TMenuItem;
    SelectFichier:TOpenDialog;
    majCoordParCP:TMenuItem;
    majCoordParInsee:TMenuItem;
    majCoordParInseeAvecTransfert:TMenuItem;
    majCoordParInseeSansTransfert:TMenuItem;
    mAjustInsee:TMenuItem;
    mArbreHierAscendant:TMenuItem;
    pmLieuInternet:TPopupMenu;
    poCarteCassini:TMenuItem;
    poVueSatellite:TMenuItem;
    poCarteExpedia:TMenuItem;
    poWikipedia:TMenuItem;
    pmVillesVoisines:TPopupMenu;
    poVoisinsDansIndex:TMenuItem;
    poVoisinsDansFavoris:TMenuItem;
    TypesFiliation:TMenuItem;
    LibelDiversIndi:TMenuItem;
    LibelDiversFam:TMenuItem;
    RelaTemoins:TMenuItem;
    mEnvFam:TMenuItem;
    ArbreDescendance:TMenuItem;
    QParents:TIBSQL;
    QCjEnf:TIBSQL;
    QssCjEnf:TIBSQL;
    QssParents:TIBSQL;
    LibelUnions: TMenuItem;
    dxBarSubItem2: TMenuItem;
    dxBarSubItem3: TMenuItem;
    mPatroMaj: TMenuItem;
    mPatroMin: TMenuItem;
    mRemplacerPatro: TMenuItem;
    mPrenomsMaj: TMenuItem;
    mPrenomsMin: TMenuItem;
    mSepPrenomsEspace: TMenuItem;
    mSepPrenomsVirg: TMenuItem;
    mRequetes: TMenuItem;
    dxBarSubItem1: TMenuItem;
    mVisuErreursBase: TMenuItem;
    mCorrErreursBase: TMenuItem;
    dxBarSubItem4: TMenuItem;
    mCtrlAscPere: TMenuItem;
    mCtrlAscMere: TMenuItem;
    mAncestroWeb: TMenuItem;
    mFenetres: TMenuItem;
    mRestaureBases: TMenuItem;
    mMajLieuxParInsee: TMenuItem;
    mMajLieuxParCP:TMenuItem;
    poGeoportail:TMenuItem;
    VillesCodes2: TMenuItem;

    (* les proc et fonctions ---------------------------------*)
    procedure FormActivate(Sender: TObject);
    procedure MenuCustomizeMenuChange(Sender: TObject);
    procedure MenuLeftClickCustomize(Sender: TObject);
    procedure OnFormInfoIniIniLoad(const AInifile: TCustomInifile;
      var KeepOn: Boolean);
    procedure OnFormInfoIniIniWrite(const AInifile: TCustomInifile;
      var KeepOn: Boolean);
    procedure OpenModuleClick(Sender:TObject);

    procedure ChangeDossier(Sender:TObject);
    procedure FormCreate(Sender:TObject);
    procedure lAnniversaireClick(Sender:TObject);
    procedure poCarteExpediaClick(Sender: TObject);
    procedure SuperFormCloseQuery(Sender:TObject;var CanClose:Boolean);
    procedure SuperFormReceiveMessage(sender:TObject;theMessage:string);
    procedure lRechercherClick(Sender:TObject);
    procedure lVillesClick(Sender:TObject);
    procedure lPrefClick(Sender:TObject);
    procedure menu_go_web_la_guildeClick(Sender:TObject);
    procedure option_RenumerotationSOSAClick(Sender:TObject);
    procedure mSaisierapideClick(Sender:TObject);
    procedure mListeUnionsClick(Sender:TObject);
    procedure mCousinageClick(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure MenuFavoris_AddClick(Sender:TObject);
    procedure IInformationsClick(Sender:TObject);
    procedure URLBlockNotesClick(Sender:TObject);
    procedure Particules1Click(Sender:TObject);
    procedure Prfixes1Click(Sender:TObject);
    procedure Raccourissaisie1Click(Sender:TObject);
    procedure RecherchededoublonsClick(Sender:TObject);
    procedure SuperFormFirstActivate(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
    procedure mMotsclefsDatesClick(Sender:TObject);
    procedure ExportImagesClick(Sender:TObject);
    procedure mNouveauxClick(Sender:TObject);
    procedure Commentamarche1Click(Sender:TObject);
    procedure Fichier1PaintBar(Sender:TObject;Canvas:TCanvas;
      const R:TRect);
    procedure dxBarButton1Click(Sender:TObject);
    procedure dxbDelFavorisClick(Sender:TObject);
    procedure mCalendrierClick(Sender:TObject);
    procedure mOrphelinsClick(Sender:TObject);
    procedure mPosthumeClick(Sender:TObject);
    procedure mMajLieuxParInseeClick(Sender:TObject);
    procedure poGeoportailClick(Sender:TObject);
    procedure mTagGedcomClick(Sender:TObject);
    procedure mMajClick(Sender:TObject);
    procedure dxbDoublonsVilleClick(Sender:TObject);
    procedure mBiblioMediasClick(Sender:TObject);
    procedure lMainMouseEnter(Sender:TObject);
    procedure lMainMouseLeave(Sender:TObject);
    procedure bfsbQuitterClick(Sender:TObject);
    procedure mInfosVersionClick(Sender:TObject);
    procedure mSauvegardeClick(Sender:TObject);
    procedure sxMListeDiffusionClick(Sender:TObject);
    procedure dxbJournalClick(Sender:TObject);
    procedure mAideSQLClick(Sender:TObject);
    procedure mLivreSQLClick(Sender:TObject);
    procedure mCreateIndiClick(Sender:TObject);
    procedure mConsanguinTotalClick(Sender:TObject);
    procedure menu_IndividuPopup(Sender:TObject);
    procedure mCalculDatesClick(Sender:TObject);
    procedure mResetToolBarClick(Sender:TObject);
    procedure mDeleteBrancheClick(Sender:TObject);
    procedure mDelImportClick(Sender:TObject);
    procedure mResetWindowsClick(Sender:TObject);
    procedure majCoordParCPAvecTransfertClick(Sender:TObject);
    procedure mImportDossierClick(Sender:TObject);
    procedure mVoirPointClick(Sender:TObject);
    procedure mTrucsClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mDateIncoherentesClick(Sender:TObject);
    procedure mQuiPorteCeTitreClick(Sender:TObject);
    procedure mSupprimeSosaClick(Sender:TObject);
    procedure mRechercheActesClick(Sender:TObject);
    procedure mAncetreSansParentClick(Sender:TObject);
    procedure mGroupeIndisClick(Sender:TObject);
    procedure mPartenairesClick(Sender:TObject);
    procedure mAjustInseeClick(Sender:TObject);
    procedure mExtrasPopup(Sender:TObject);
    procedure mArbreHierAscendantClick(Sender:TObject);
    procedure poCarteCassiniClick(Sender:TObject);
    procedure poVueSatelliteClick(Sender:TObject);
    procedure poWikipediaClick(Sender:TObject);
    procedure pmVillesVoisinesPopup(Sender:TObject);
    procedure poVoisinsDansIndexClick(Sender:TObject);
    procedure dxStatusBarPanels3Click(Sender:TObject);
    procedure mChercheNIPClick(Sender:TObject);
    procedure Arbredascendance1Click(Sender:TObject);
    procedure Rouedascendance1Click(Sender:TObject);
    procedure TypesFiliationClick(Sender:TObject);
    procedure LibelDiversIndiClick(Sender:TObject);
    procedure EditRefDivers(Table:string);
    procedure LibelDiversFamClick(Sender:TObject);
    procedure RelaTemoinsClick(Sender:TObject);
    procedure mEnvFamClick(Sender:TObject);
    procedure ArbreDescendanceClick(Sender:TObject);
    procedure mArbrehierClick(Sender:TObject);
    procedure Documents1Click(Sender:TObject);
    procedure Listeparprnom1Click(Sender:TObject);
    procedure LibelUnionsClick(Sender: TObject);
    procedure mPrenomsMajClick(Sender: TObject);
    procedure mPatroMajClick(Sender: TObject);
    procedure mRemplacerPatroClick(Sender: TObject);
    procedure mSepPrenomsEspaceClick(Sender: TObject);
    procedure mRequetesClick(Sender: TObject);
    procedure mCorrErreursBaseClick(Sender: TObject);
    procedure mCtrlAscPereClick(Sender: TObject);
//    procedure menu_ImportExportPopup(Sender: TObject);
    procedure mAncestroWebClick(Sender: TObject);
    procedure mFenetresPopup(Sender: TObject);
    procedure mRestaureBasesClick(Sender: TObject);
    procedure Fichier1Popup(Sender: TObject);

  private
    FBoxChilds : TWinControl;
    aFArbreHierDesc:TFArbreHierarchique;
    aFtvAscendance:TFtvAscendance;
    aFExportGedcom:TFExportGedcom;
    aFImportGedcom:TFImportGedcom;
    FIniComponent : TOnFormInfoIni;

    aFListReport:TFListReport;

    aFIndividuRepertoireR:TFIndividuRepertoire;
    aFExportGeneanet:TFExportGeneanet;

    aFEditRefParticules:TFEditRefParticules;
    aFEditRefPrefixes:TFEditRefPrefixes;
    aFEditRaccourcis:TFEditRaccourcis;
    aFEditRefFiliation:TFEditRefFiliation;
    aFSelectDatabase:TFSelectDatabase;
    aFRestoreDatabase:TFRestore;
    aFOpenSources:TFOpenSources;
    aFRechercheActes:TFRechercheActes;
    aFIndiDateIncoherente:TFIndiDateIncoherente;
    aFListeDoublons:TFListeDoublons;
    aFBiblioMultimedia:TFBiblioMultimedia;
    aFGroupeIndis:TFGroupeIndis;
    aFRechercher:TFRechercher;
    aFListeUnions:TFListeUnions;
    aFAnniversaires:TFAnniversaires;
    aFEnvFamille:TFEnvFamille;
    aFVillesVoisines:TFVillesVoisines;
    aFRechercheAncetres:TFRechercheAncetres;
    aFOrphelins:TFOrphelins;
    aFPosthumes:TFPosthumes;
    aFQuiPorteCeTitre:TFQuiPorteCeTitre;
    aFCalculDate:TFCalculDate;

    //module actif en ce moment
    fIDModuleActif:integer;

    fDemarrageIsFinish:boolean;
    bFirsTime:boolean;

    BiblioTop,BiblioLeft,BiblioHeight,BiblioWidth:integer;//pour réouvrir la Bibliothèque comme elle a été fermée

    function fb_setNewFormStyle(const afor_Reference: TCustomForm;
      const afs_newFormStyle: TFormStyle; const ab_Ajuster: Boolean): Boolean;
    procedure mLesLieuxPopup(Sender: TObject);
    procedure mMajCoordGeoClick(Sender: TObject);
    procedure OnClickDll(sender:TObject);
    procedure doPrepareJusteAfterOpenDatabase;
    procedure p_SetChildForm(const afor_Reference: TCustomForm;
      const afs_newFormStyle: TFormStyle);
    procedure ShowIndividuRecents;
    procedure DoInitAddon;
    function GetQSIpath:string;
    procedure doCalculConsanguinite(iMode:integer);
    procedure doOpenCassini;
    procedure Ouvre_Et_Selecte_Individu;
    procedure OuvreIndiDuTagMenu(sender:TObject);
    function ChercheLieu(const Favori:boolean;const FicheAppelante:TForm;const ANumPays : Integer;const edPays,edVille,edSubd:string;
      var APays,ARegion,ADept,ACode,AInsee,AVille,ASubd,ALat,ALong:string):boolean; //MG2014
    procedure ExecuteRequete(TextReq:string;Execute:boolean);
    {$IFDEF WINDOWS}
    procedure PrepareExportWeb;
    {$ENDIF}
    procedure mFenetreOnClick(Sender:TObject);
    procedure MajmFenetres(Sender:TObject);
    procedure mFermeFenetres(Sender:Tobject);
    procedure TrouveVueGoogle(sVille, sLat, sLong: string);
    procedure doCloseFenetresFlottantes;
  public
    bClose:boolean;
    bPurgeRegistre:boolean;

    aFIndividu:TFIndividu;
    aFPostit:TFPostit;
    aFUtilisationMedia:TFUtilisationMedia;
    IndiDrag:record
      cle:integer;
      sexe:integer;
      nomprenom,naissance,deces:string;
      end;

    aFGraphPaintArbre,aFGraphPaintRoue,aFGraphPaintLiens,aFGraphPaintParente:TFGraphPaintBox;

    NomIndiComplet:string;
    IndiTrieNom:string;
    PrenomIndi:string;
    NomIndi:string;
    NavigationLeft,NavigationTop:Integer;
    Lieu_Pays,Lieu_Region,Lieu_CP,Lieu_Ville,Lieu_Latitude,Lieu_Longitude,
    Lieu_Subdivision,Lieu_Departement,Lieu_INSEE:string;
    Lieu_Proprietaire:TForm;
    TitreAppli:string;
    CtrlFbloqued:boolean;//créée pour désactiver le Ctrl+F de FMain
    bSRCacheRep:boolean;
    property IDModuleActif:integer read fIDModuleActif write fIDModuleActif;
    property DemarrageIsFinish:boolean read fDemarrageIsFinish;

    function CloseModuleActif:boolean;
    procedure OpenModule(ID:integer);
    procedure RefreshFavoris;
    procedure OnClickOnFavoris(sender:TObject);
    procedure RefreshMenuFavoris_Add(canAccess:boolean);
    procedure FirstUse;
    procedure BeforeGoHelp;
    procedure doTranslate;
    procedure doShowHistoire;
    procedure doMajBarreTitre;
    function OuvreBiblioMedias(bSelection:boolean;Indi:integer;sTable,sType:string):integer;
    procedure OnClickDelFavori(sender:TObject);
    procedure OuvreLienGene(indi1,indi2:integer;sIndi1,sIndi2:string);
    function OuvreLienIndividus(const indi1,indi2:integer):boolean;
    procedure OuvreFUtilisationMedia(clef_media:integer);
    procedure OuvreArbredascendance(indi:integer;mode:Char);
    procedure RempliPopMenuParentsConjointsEnfants(LePM:TPopupMenu;CleIndi,SexeIndi:integer;bRupture:boolean=false);
    procedure MsgBarreEtat(NumMessage:integer=0;Chaine:string='');
    procedure OuvreEnvFam(const Lindi:integer;const SonNom:string);
    procedure RefreshArbre;
    function ChercheLieuFavori(const FicheAppelante:TForm;const NumPays:Integer;const edPays,edVille,edSubd:string;
      var Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string):boolean; //AL2010
    function ChercheVille(const FicheAppelante:TForm;const NumPays :Integer; const edPays,edVille:string;
      var Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string):boolean;//AL2010
    procedure MajEtatOptim;
    procedure OuvreCalculsDates(const DateWriten:string);overload;
    procedure OuvreCalculsDates(const DateCode:Integer);overload;
    procedure OuvreCalculsDates(const An,Mois,Jour:Integer);overload;
  published
    property IniComponent : TOnFormInfoIni read FIniComponent write FIniComponent;

  end;

var
  FMain:TFMain;
  gb_ForceClose : Boolean = False ;

const CST_CASSINI = 'Cassini' ;

implementation

uses
  u_common_const,
  LazUTF8,
  U_AncestroWeb,
  u_form_working,
  u_gedcom_func,
  lazutf8classes,
  {$IFDEF WINDOWS}
  registry, windows,
  {$ENDIF}
  fonctions_string,
  u_Form_Infos,
  u_form_individu_Saisie_Rapide,
  u_form_select_dossier,
  u_common_functions,u_common_ancestro,
  u_form_Liste_Cousinage,
  fonctions_system,
  u_form_confirm_add_to_favoris,
  u_form_edit_context,
  u_Form_Liste_Nouveaux_Indi,
  u_form_calendriers,
  u_Form_About,
  u_form_TAG_Gedcom,
  u_common_ancestro_functions,
  u_Form_Maj_Internet,
  u_form_list_villes_Doublons,
  u_Form_Sauvegarde,
  u_Form_Journal_Operation,
  u_Dm,
  FileUtil,
  dynlibs,
  fonctions_dialogs,
  u_Form_DeleteBranche,
  u_Form_DeleteImportGedcom,
  u_Form_Mutation_Base,
  u_Form_Voir_Point,
  u_form_edit_ref_token_date,
  u_form_edit_ref_Divers,
  u_form_edit_ref_temoins,
  u_form_list_villes,
  u_form_requetes,
  fonctions_forms,
  DateUtils,
  IB,
  u_genealogy_context, Types;
var
  lstl_PathDLLs : TStringlistUTF8=nil;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFMain.FormCreate(Sender:TObject);
var
  s:string;
  i,p,l,t:Integer;
  R:TRect;
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnFirstActivate:=SuperFormFirstActivate;
  OnReceiveMessage:=SuperFormReceiveMessage;
  FBoxChilds:=panDock;
  Color:=gci_context.ColorLight;
  Position:=poDesigned;
  lstl_PathDLLs := TStringlistUTF8.Create;

  bFirsTime:=True;

  TitreAppli:=Application.Title;

  // Matthieu
//  dxBarManager.RegistryPath:=gci_context.KeyRegistry+DirectorySeparator+'W_MAIN_MENU';
//  dxBarManager.LoadFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_MAIN_MENU');
//  dxBarManager.Bars[0].DockingStyle:=dstop;
{
cxSetResourceString(@scxGridGroupByBoxCaption,lEnteteColonne.Caption);
cxSetResourceString(@scxGridDeletingConfirmationCaption,'Confirmation');
cxSetResourceString(@scxGridDeletingFocusedConfirmationText,'Supprimer l''enregistrement?');
cxSetResourceString(@scxGridNoDataInfoText,'');
cxSetResourceString(@scxGridDeletingSelectedConfirmationText,'Supprimer tous ces enregistrements?');
cxSetResourceString(@scxGridFilterCustomizeButtonCaption,'Personnaliser...');
cxSetResourceString(@scxGridToday,'Aujourd''hui');
cxSetResourceString(@scxGridFilterIsEmpty,'<Le filtre est vide>');
 }

  gci_context.PathQuiSontIls:=GetQSIpath;

  doTranslate;
  Application.ShowHint:=gci_context.CanSeeHint;

  fDemarrageIsFinish:=false;

  DoInitAddon;

  Application.ProcessMessages;

  fIDModuleActif:=-1;

  NavigationLeft:=10000;

  Lieu_Proprietaire:=nil;
  CtrlFbloqued:=false;
  BiblioHeight:=0;//sert d'indicateur d'ouverture
  bSRCacheRep:=false;
  Screen.OnActiveFormChange:=MajmFenetres;
end;

procedure TFMain.OpenModuleClick(Sender:TObject);
begin
  Enabled:=false;
  try
    if (fIDModuleActif<>TComponent(sender).Tag) then
    begin
      if CloseModuleActif then
        OpenModule(TComponent(sender).Tag);
    end;
  finally
    Enabled:=true;
  end;
end;

procedure TFMain.FormActivate(Sender: TObject);
begin
  doCloseWorking;
end;

procedure TFMain.MenuCustomizeMenuChange(Sender: TObject);
begin
  MenuCustomize.SaveIni;
  MenuLeft.LoadMenu;
end;

procedure TFMain.MenuLeftClickCustomize(Sender: TObject);
begin
  MenuCustomize.Click;
end;


procedure TFMain.OnFormInfoIniIniLoad(const AInifile: TCustomInifile;
  var KeepOn: Boolean);
begin
  p_IniOuvre;
  MenuCustomize.LoadIni;
end;

procedure TFMain.OnFormInfoIniIniWrite(const AInifile: TCustomInifile;
  var KeepOn: Boolean);
begin
  MenuCustomize.SaveIni;
  AInifile.WriteString('Path','PathAppli',_Path_Appli);
  p_IniWriteSectionInt(dm.Name,DM_INI_NOT_SHOWED_TASKS,0);
  p_IniMAJ;
  p_IniQuitte;
end;

procedure TFMain.OpenModule(ID:integer);
begin
  case ID of
    _ID_INDIVIDU:
      begin
        if not Assigned(aFIndividu) then
          aFIndividu:=TFIndividu.create(self);
        aFIndividu.DialogMode:=false;
        aFIndividu.LocateOnFirstIndividuDossierIfNotFind:=true;
        aFIndividu.ProposeToCreateNewIndividuIfNotFind:=true;

        aFIndividu.ShowIncrust(panDock);
        aFIndividu.doOpenFiche(dm.individu_clef);

        fIDModuleActif:=ID;
        RefreshMenuFavoris_Add(true);
      end;
    _ID_IMPORTATION_GEDCOM:
      begin
        doCloseFenetresFlottantes;
        aFImportGedcom:=TFImportGedcom.create(self);
        aFImportGedcom.ShowIncrust(panDock);
        fIDModuleActif:=ID;

        RefreshMenuFavoris_Add(false);
      end;
    _ID_EXPORTATION_GEDCOM:
      begin
        doCloseFenetresFlottantes;
        RefreshMenuFavoris_Add(false);

        aFExportGedcom:=TFExportGedcom.create(self);
        aFExportGedcom.ShowIncrust(panDock);
        fIDModuleActif:=ID;

        RefreshMenuFavoris_Add(false);
      end;
    _ID_EXPORTATION_GENEANET:
      begin
        doCloseFenetresFlottantes;
        aFExportGeneanet:=TFExportGeneanet.create(self);
        aFExportGeneanet.ShowIncrust(panDock);
        aFExportGeneanet.doPrepare;
        fIDModuleActif:=ID;

        RefreshMenuFavoris_Add(false);
      end;
    _ID_EMPLACEMENT_BDD:
      begin
        doCloseFenetresFlottantes;
        aFSelectDatabase:=TFSelectDatabase.create(self);
        aFSelectDatabase.ShowIncrust(panDock);

        RefreshMenuFavoris_Add(false);
        fIDModuleActif:=ID;
      end;
    _ID_RESTORE_BDD:
      begin
        doCloseFenetresFlottantes;
        aFRestoreDatabase:=TFRestore.create(self);
        aFRestoreDatabase.ShowIncrust(panDock);
        fIDModuleActif:=ID;
        RefreshMenuFavoris_Add(false);
      end;
    _ID_OPENSOURCES:
      begin
        aFOpenSources:=TFOpenSources.create(self);
        aFOpenSources.ShowIncrust(panDock);
        fIDModuleActif:=ID;

        RefreshMenuFavoris_Add(false);
      end;
  end;
  doRefreshControls;
  doCloseWorking;
end;

function TFMain.CloseModuleActif:boolean;
begin
  result:=true;
  case fIDModuleActif of
    _ID_INDIVIDU:
      begin
        if aFIndividu.VerifyCanCloseFiche then
        begin
          aFIndividu.HideIncrust;
          FreeAndNil(aFIndividu);
          option_RenumerotationSOSA.enabled:=true;
        end
        else
          result:=false;
      end;
    _ID_IMPORTATION_GEDCOM:
      begin
        aFImportGedcom.HideIncrust;
        FreeAndNil(aFImportGedcom);
      end;
    _ID_EXPORTATION_GEDCOM:
      begin
        aFExportGedcom.HideIncrust;
        FreeAndNil(aFExportGedcom);
      end;
    _ID_EXPORTATION_GENEANET:
      begin
        aFExportGeneanet.HideIncrust;
        FreeAndNil(aFExportGeneanet);
      end;
    _ID_EMPLACEMENT_BDD:
      begin
        aFSelectDatabase.HideIncrust;
        FreeAndNil(aFSelectDatabase);
      end;
    _ID_RESTORE_BDD:
      begin
        aFRestoreDatabase.HideIncrust;
        FreeAndNil(aFRestoreDatabase);
      end;
    _ID_OPENSOURCES:
      begin
        aFOpenSources.HideIncrust;
        FreeAndNil(aFOpenSources);
      end;
  end;

  RefreshMenuFavoris_Add(false);
  if result then
    fIDModuleActif:=-1;

  doRefreshControls;
end;

procedure TFMain.ChangeDossier(Sender:TObject);
var
  suite:boolean;
  aFSelectDossier:TFSelectDossier;
begin
  //Si on se trouve dans la fiche individu, alors on demande de sauvegarder si la fiche est modifiée
  if fIDModuleActif=_ID_INDIVIDU then
    suite:=aFIndividu.VerifyCanCloseFiche
  else
    suite:=true;

  if suite then
  begin
    doCloseFenetresFlottantes;
      //On commit avant de jouer avec les dossiers
    dm.doSaveLastFicheActiveOfDossier;
    dm.IBT_base.CommitRetaining;

    aFSelectDossier:=TFSelectDossier.create(self);
    try
      CentreLaFiche(aFSelectDossier);
      if aFSelectDossier.ShowModal=mrOk then
      begin
        if CloseModuleActif then
          OpenModule(_ID_INDIVIDU);
      end;
      doMajBarreTitre;
      dm.IBT_base.CommitRetaining;//pour être sûr d'enregistrer les modifications des dossiers
    finally
      FreeAndNil(aFSelectDossier);
    end;
    doRefreshControls;
  end;
end;

procedure TFMain.lAnniversaireClick(Sender:TObject);
begin
  Enabled:=false;
  try
    if not Assigned(aFAnniversaires) then
      aFAnniversaires:=TFAnniversaires.create(self);
    aFAnniversaires.Show;
  finally
    Enabled:=true;
  end;
end;

procedure TFMain.poCarteExpediaClick(Sender: TObject);
begin

end;



procedure TFMain.SuperFormCloseQuery(Sender:TObject;var CanClose:Boolean);
begin
  doCloseFenetresFlottantes;
  CanClose:=false;

  if gci_context.ShowExit then
  begin
    if gb_ForceClose or (MyMessageDlg(rs_Confirm_quitting_ancestromania,mtConfirmation, [mbYes,mbNo],Self)=mrYes) then
    begin
      if CloseModuleActif then
      begin
        Hide;
        CanClose:=True;
        dm.doCloseDatabase;
      end;
    end
    else
    begin
      CanClose:=false;
      exit;
    end;
  end
  else
  begin
    if CloseModuleActif then
    begin
      Hide;
      CanClose:=true;
      dm.doCloseDatabase;
    end;
  end;
end;

procedure TFMain.SuperFormReceiveMessage(sender:TObject;theMessage:string);
begin
  if theMessage='OPEN_MODULE_INDIVIDU' then
  begin
    Ouvre_Et_Selecte_Individu;
  end
  else
  begin
    if theMessage='OPEN_IMPORT_GEDCOM_FROM_FICHE_INDIVIDU' then
      OpenModule(_ID_IMPORTATION_GEDCOM)
    else if theMessage='OPEN_IMPORT_DOSSIER_AUTRE_BASE' then
    begin
      mImportDossierClick(Sender);
      OpenModule(_ID_INDIVIDU);
    end
    else if theMessage='DO_AFTER_SELECT_DATABASE' then
    begin
      fIDModuleActif:=-1;
      doPrepareJusteAfterOpenDatabase;
    end
    else if theMessage='FERME_ARBRE_HIER_DESC' then
    begin
      aFArbreHierDesc:=nil;
    end
    else if theMessage='FERME_ARBRE_HIER_ASC' then
    begin
      aFtvAscendance:=nil;
    end
    else if theMessage='FERME_FORM_RECHERCHER' then
    begin
      aFRechercher:=nil;
    end
    else if theMessage='FERME_FORM_ENV_FAMILLE' then
    begin
      aFEnvFamille:=nil;
    end
    else if theMessage='FERME_form_individu_repertoire_R' then
    begin
      aFIndividuRepertoireR:=nil;
    end
    else if theMessage='FERME_LISTE_UNIONS' then
    begin
      aFListeUnions:=nil;
    end
    else if theMessage='FERME_FORM_LIST_REPORT' then
    begin
      aFListReport:=nil;
    end
    else if theMessage='FERME_FORM_ANNIVERSAIRES' then
    begin
      aFAnniversaires:=nil;
    end
    else if theMessage='FERME_RECHERCHE_ACTES' then
    begin
      aFRechercheActes:=nil;
    end
    else if theMessage='FERME_INDIS_DATEINCOHERENTES' then
    begin
      aFIndiDateIncoherente:=nil;
    end
    else if theMessage='FERME_RECHERCHE_ANCETRES' then
    begin
      aFRechercheAncetres:=nil;
    end
    else if theMessage='FERME_GROUPE_INDIS' then
    begin
      aFGroupeIndis:=nil;
    end
    else if theMessage='FERME_INDIS_ISOLES' then
    begin
      aFOrphelins:=nil;
    end
    else if theMessage='FERME_POSTHUMES' then
    begin
      aFPosthumes:=nil;
    end
    else if theMessage='FERME_TITRES' then
    begin
      aFQuiPorteCeTitre:=nil;
    end
    else if theMessage='FERME_NAVIGATION' then
    begin
      _FormNavigation:=nil;
    end
    else if theMessage='FERME_HISTOIRE' then
    begin
      _FormHistoire:=nil;
    end
    else if theMessage='FERME_FORME_ARBRE_IMP' then
    begin
      aFGraphPaintArbre:=nil;
    end
    else if theMessage='FERME_FORME_ROUE_IMP' then
    begin
      aFGraphPaintRoue:=nil;
    end
    else if theMessage='FERME_FORME_LIENS_IMP' then
    begin
      aFGraphPaintLiens:=nil;
    end
    else if theMessage='FERME_FORME_PARENTE_IMP' then
    begin
      aFGraphPaintParente:=nil;
    end
    else if theMessage='FERME_FORM_LISTE_DOUBLONS' then
    begin
      aFListeDoublons:=nil;
    end
    else if theMessage='FERME_UTILISATION_MEDIA' then
    begin
      aFUtilisationMedia:=nil;
    end
    else if theMessage='FERME_FORM_VILLES_VOISINES' then
    begin
      aFVillesVoisines:=nil;
    end
    else if theMessage='FERME_CALCULDATES' then
    begin
      aFCalculDate:=nil;
    end
    else if theMessage='FERME_POSTIT' then
    begin
      aFPostit:=nil;
    end
    else if theMessage='MAJ_APRES_PRINTERSETUP' then
    begin
      if aFGraphPaintArbre<>nil then
        aFGraphPaintArbre.MajApresPrinterSetup;
      if aFGraphPaintRoue<>nil then
        aFGraphPaintRoue.MajApresPrinterSetup;
      if aFGraphPaintLiens<>nil then
        aFGraphPaintLiens.MajApresPrinterSetup;
      if aFGraphPaintParente<>nil then
        aFGraphPaintParente.MajApresPrinterSetup;
    end
    else
      MyMessageDlg(rs_Error_FMain_Message_not_processed+_CRLF+theMessage,mtError, [mbOK],Self);

    doRefreshControls;
  end;
end;

procedure TFMain.lRechercherClick(Sender:TObject);
begin
  Rechercher2.Enabled:=false;
  if not assigned(aFRechercher) then
  begin
    aFRechercher:=TFRechercher.create(self);
  end;
  aFRechercher.TabControlStdNotes.TabOrder:=0;
  aFRechercher.ActiveControl:=aFRechercher.sENom;
  aFRechercher.Show;
  Rechercher2.Enabled:=true;
end;

procedure TFMain.lVillesClick(Sender:TObject);
var
  aFListVilles:TFListVilles;
begin
  enabled:=false;
  try
    aFListVilles:=TFListVilles.create(self);
    try
      CentreLaFiche(aFListVilles,self);
      aFListVilles.CanSelect:=false;
      aFListVilles.ShowModal;
    finally
      FreeAndNil(aFListVilles);
    end;
  finally
    enabled:=true;
  end;
end;

procedure TFMain.lPrefClick(Sender:TObject);
var
  aFEditContext:TFEditContext;
begin
  enabled:=false;
  try
    doCloseFenetresFlottantes;
    aFEditContext:=TFEditContext.create(self);
    try
      CentreLaFiche(aFEditContext);
      if aFEditContext.ShowModal=mrOk then //appel et retour de edit_context
      begin
        //La fiche individu est-elle active ?
        if fIDModuleActif=_ID_INDIVIDU then
        begin
            //on rafraichit les cohérences
          aFIndividu.FCoherence.InitMessages;
          aFIndividu.TestCoherenceDates;
          aFIndividu.aFIndividuIdentite.SetColorFromContext;
          aFIndividu.DoRefreshControls;
{
          if aFEditContext.cbPhotos.Checked then
            aFIndividu.RefreshPhoto;
 }
          aFIndividu.aFIndividuIdentite.IBQEve.Close;
          aFIndividu.aFIndividuIdentite.IBQEve.Open;
        end;
      end;
    finally
      FreeAndNil(aFEditContext);
    end;
  finally
    enabled:=true;
  end;
end;

procedure TFMain.mSaisierapideClick(Sender:TObject);
var
  aFIndividuSaisieRapide:TFIndividuSaisieRapide;
begin
  Enabled:=false;
  try
    aFIndividuSaisieRapide:=TFIndividuSaisieRapide.create(self);
    CentreLaFiche(aFIndividuSaisieRapide);
    aFIndividuSaisieRapide.caption:=rs_caption_Create_Person;
    aFIndividuSaisieRapide.sDBENom.Text:='';
    try
      aFIndividuSaisieRapide.ShowModal;
    finally
      FreeAndNil(aFIndividuSaisieRapide);
    end;
  finally
    Enabled:=true;
  end;
end;

procedure TFMain.mListeUnionsClick(Sender:TObject);
begin
  Enabled:=false;
  try
    if not Assigned(aFListeUnions) then
    begin
      aFListeUnions:=TFListeUnions.create(self);
    end;
    aFListeUnions.Show;
  finally
    Enabled:=true;
  end;
end;

procedure TFMain.mCousinageClick(Sender:TObject);
var
  aFListeCousinage:TFListeCousinage;
begin
  Enabled:=false;
  try
    aFListeCousinage:=TFListeCousinage.create(self);
    try
      CentreLaFiche(aFListeCousinage);
      if aFListeCousinage.ShowModal=mrOk then
      begin
        dm.individu_clef:=aFListeCousinage.ClefIndividuSelected;
        DoSendMessage(self,'OPEN_MODULE_INDIVIDU');
      end;
    finally
      FreeAndNil(aFListeCousinage);
    end;
  finally
    Enabled:=true;
  end;
end;

procedure TFMain.SuperFormRefreshControls(Sender:TObject);
var
  dbc:boolean;
  connected_and_folder:boolean;
  S:TStringlistUTF8;
  iCount:integer;
begin
  if bFirsTime then Exit;

  s:=TStringlistUTF8.Create;
  iCount:=LoadStringListWithFichier(_Path_Appli+_REL_PATH_PLUGINS+'*'+CST_EXTENSION_LIBRARY,s);
  FreeAndNil(s);
  dbc:=dm.ibd_BASE.Connected and fDemarrageIsFinish;
  connected_and_folder := dbc and(dm.NumDossier>0);

  Rechercher2.enabled:=connected_and_folder and(fIDModuleActif=_ID_INDIVIDU);

  Informations1.enabled:=connected_and_folder ;
  Blocnotes2.enabled:=connected_and_folder ;
  Arbredascendance1.enabled:=connected_and_folder ;
  Rouedascendance1.enabled:=connected_and_folder ;

  Dossiers1.enabled:=dbc;
  menu_Individu.enabled:=connected_and_folder ;
  menu_Favoris.enabled:=connected_and_folder ;
  menu_ImportExport.enabled:=connected_and_folder ;
  mListe.enabled:=connected_and_folder ;
  menu_Impressions.enabled:=connected_and_folder ;
  mAddon.enabled:=connected_and_folder and(iCount>2);
  Prfrences2.enabled:=connected_and_folder ;
  Raccourissaisie1.enabled:=connected_and_folder ;
  Prfixes1.enabled:=connected_and_folder ;
  Particules1.enabled:=connected_and_folder ;
  mMotsclefsDates.enabled:=connected_and_folder ;
  VillesCodes1.enabled:=connected_and_folder ;
  menu_Configuration.Enabled:=connected_and_folder ;
  mLesLieux.Enabled:=connected_and_folder ;
end;

procedure TFMain.RefreshFavoris;
begin
  dm.LoadFavoris(menu_Favoris);
end;

procedure TFMain.OnClickOnFavoris(sender:TObject);
var
  cle:integer;
  nom:string;
begin
  cle:=TMenuItem(sender).Tag;//AL 2009: n'est pas un TMenuItem
  if GetKeyState(VK_SHIFT)<0 then
  begin
    OpenFicheIndividuInBox(cle);
  end
  else
  begin
    case fIDModuleActif of
      _ID_INDIVIDU:
        begin
          if aFIndividu.VerifyCanCloseFiche then
          begin
            aFIndividu.doOpenFiche(cle);
          end;
        end;
      _ID_EXPORTATION_GEDCOM:
        begin
          if aFExportGedcom.CanSetCleFicheFromFavoris then
          begin
            nom:=TMenuItem(sender).Caption;//AL 2009
            aFExportGedcom.CleIndiDepart:=cle;
            aFExportGedcom.NameIndiDepart:=nom;

            aFExportGedcom.DoRefreshControls;
          end;
        end;
    end;
  end;
end;

procedure TFMain.MenuFavoris_AddClick(Sender:TObject);
var
  cle:integer;
  nom:string;
  Sexe:Integer;
  aFConfirmAddToFavoris:TFConfirmAddToFavoris;
begin
  cle:=-1;
  nom:='';
  Sexe:=-1;

  //sur quel module somme-nous ?
  if fIDModuleActif=_ID_INDIVIDU then
  begin
    cle:=aFIndividu.CleFiche;
    nom:=aFIndividu.GetNomIndividu;
    Sexe:=aFIndividu.QueryIndividuSEXE.AsInteger;
  end;

  if cle<>-1 then
  begin
    aFConfirmAddToFavoris:=TFConfirmAddToFavoris.create(self);
    try
      CentreLaFiche(aFConfirmAddToFavoris);
      aFConfirmAddToFavoris.Nom:=nom;
      aFConfirmAddToFavoris.Sexe:=Sexe;
      aFConfirmAddToFavoris.doInit;
      if aFConfirmAddToFavoris.ShowModal=mrOk then
      begin
        dm.AddToFavoris(cle);
        RefreshFavoris;
      end;
    finally
      FreeAndNil(aFConfirmAddToFavoris);
    end;
  end;
end;

procedure TFMain.RefreshMenuFavoris_Add(canAccess:boolean);
begin
  MenuFavoris_Add.enabled:=canAccess;
end;

procedure TFMain.IInformationsClick(Sender:TObject);
var
  aFInfos:TFInfos;
begin
  aFInfos:=TFInfos.create(self);
  try
    CentreLaFiche(aFInfos);
    aFInfos.ShowStats;
    aFInfos.ShowModal;
  finally
    FreeAndNil(aFInfos);
  end;
end;

procedure TFMain.URLBlockNotesClick(Sender:TObject);
begin
  if FileExistsUTF8(dm.FicNotes) { *Converted from FileExistsUTF8*  } then
  // Matthieu
    p_OpenFileOrDirectory ( dm.FicNotes )
//    ShellExecute(0,nil,PChar(dm.FicNotes),nil,nil,SW_SHOWDEFAULT)
  else if DirectoryExistsUTF8(dm.FicNotes) { *Converted from DirectoryExistsUTF8*  } then
  begin
    SelectFichier.Title:=rs_Title_Select_folder_to_open;
    SelectFichier.InitialDir:=dm.FicNotes;
    if SelectFichier.Execute then
      p_OpenFileOrDirectory ( SelectFichier.FileName )
//      ShellExecute(0,nil,PChar(SelectFichier.FileName),nil,nil,SW_SHOWDEFAULT);
  end
  else
  begin
    if aFPostit=nil then
    begin
      aFPostit:=TFPostit.create(self);
      CentreLaFiche(aFPostit);
    end;
    if aFPostit.visible=false then
    begin
      aFPostit.Show;
      if aFPostit.doOpenQuery=false then
        aFPostit.Close;
    end;
  end;
end;

procedure TFMain.Particules1Click(Sender:TObject);
begin
  aFEditRefParticules:=TFEditRefParticules.create(self);
  try
    CentreLaFiche(aFEditRefParticules);
    aFEditRefParticules.ShowModal;
  finally
    FreeAndNil(aFEditRefParticules);
  end;
  dm.InitListeParticules;
end;

procedure TFMain.Prfixes1Click(Sender:TObject);
begin
  aFEditRefPrefixes:=TFEditRefPrefixes.create(self);
  try
    CentreLaFiche(aFEditRefPrefixes);
    aFEditRefPrefixes.ShowModal;
  finally
    FreeAndNil(aFEditRefPrefixes);
  end;
  aFIndividu.aFIndividuIdentite.InitCivilites;
end;

procedure TFMain.Raccourissaisie1Click(Sender:TObject);
begin
  aFEditRaccourcis:=TFEditRaccourcis.create(self);
  try
    CentreLaFiche(aFEditRaccourcis);
    aFEditRaccourcis.ShowModal;
  finally
    FreeAndNil(aFEditRaccourcis);
  end;
  dm.LoadRaccourcis;
end;

procedure TFMain.RecherchededoublonsClick(Sender:TObject);
begin
  if not assigned(aFListeDoublons) then
    aFListeDoublons:=TFListeDoublons.create(self);
  aFListeDoublons.Show;
end;

procedure TFMain.SuperFormFirstActivate(Sender:TObject);
begin
  Enabled:=True;

  FirstUse;
  fDemarrageIsFinish:=true;

  bFirsTime:=False;

  Enabled:=True;

  if gci_context.VerifMAJ then
    dm.doVerifNouvelleVersion;

  if gci_context.ShowNew and dm.ibd_BASE.Connected then
    if dm.doNouveaux>0 then ShowIndividuRecents;

  if gci_context.OuvreHistoire then
  begin
    doShowHistoire;
    if Assigned(aFIndividu) then
      _FormHistoire.doPosition(aFIndividu.aFIndividuIdentite.IBQEveEV_IND_CLEF.AsInteger,0);
  end;

  doRefreshControls;
end;

procedure TFMain.FirstUse;
begin
  if dm.bClose then
  begin
    dm.doCloseDatabase;
    Application.Terminate;
    Halt;
  end
  else
  begin //La base est-elle ouverte?
    if dm.ibd_BASE.Connected=false
      then OpenModule(_ID_EMPLACEMENT_BDD)
      else doPrepareJusteAfterOpenDatabase;
  end;
end;

procedure TFMain.doPrepareJusteAfterOpenDatabase;
begin
  if dm.NumDossier=-1 then
  begin
    MyMessageDlg(rs_Warning_Database_empty_Fill_a_folder,mtWarning, [mbOK],Self);
    ChangeDossier(self);
  end
  else
  begin
    OpenModule(_ID_INDIVIDU);
    RefreshFavoris;
  end;
  doMajBarreTitre;
end;

procedure TFMain.p_SetChildForm(const afor_Reference: TCustomForm;
  const afs_newFormStyle: TFormStyle);
begin

end;

procedure TFMain.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
var
  cont:boolean;
begin
  case Key of
    _KEY_HELP: BeforeGoHelp;
    Ord('F'): if Shift=[ssCtrl] then
      begin
        cont:=true;
        if Assigned(aFIndividu) then
        begin
          if (aFIndividu.OngletFormIncrusted in [_ONGLET_SES_CONJOINTS,_ONGLET_DOMICILES])
            and CtrlFbloqued then
            cont:=false;
        end;
        if cont then
          lRechercherClick(sender);
      end;
  end;
end;

procedure TFMain.mMotsclefsDatesClick(Sender:TObject);
var
  aFEditRefTokenDate:TFEditRefTokenDate;
  cont:boolean;
begin
  cont:=true;
  if Assigned(aFIndividu) then
    cont:=aFIndividu.VerifyCanCloseFiche;
  if cont then
  begin
    doCloseFenetresFlottantes;
    dm.IBT_base.CommitRetaining;
    aFEditRefTokenDate:=TFEditRefTokenDate.create(self);
    try
      CentreLaFiche(aFEditRefTokenDate);
      aFEditRefTokenDate.ShowModal;
    finally
      FreeAndNil(aFEditRefTokenDate);
    end;
  end;
end;

procedure TFMain.ExportImagesClick(Sender:TObject);
begin
  dm.doExportImages('',0,False,True);
end;

procedure TFMain.menu_go_web_la_guildeClick(Sender:TObject);
begin
  GotoThisURL(dm.GetUrlSite);
end;

procedure TFMain.mNouveauxClick(Sender:TObject);
begin
  ShowIndividuRecents;
end;

procedure TFMain.ShowIndividuRecents;
var
  aFListeNouveauxIndi:TFListeNouveauxIndi;
begin
  aFListeNouveauxIndi:=TFListeNouveauxIndi.create(self);
  try
    CentreLaFiche(aFListeNouveauxIndi);
    if aFListeNouveauxIndi.ShowModal=mrOk then
    begin
      dm.individu_clef:=aFListeNouveauxIndi.CleFicheSelected;
      DoSendMessage(self,'OPEN_MODULE_INDIVIDU');
    end;
  finally
    FreeAndNil(aFListeNouveauxIndi);
  end;
end;

procedure TFMain.Commentamarche1Click(Sender:TObject);
begin
  BeforeGoHelp;
end;

procedure TFMain.BeforeGoHelp;
var
  fIDHelp:integer;
begin
  if fIDModuleActif=_ID_INDIVIDU then
  begin
    case aFIndividu.OngletFormIncrusted of
      _ONGLET_IDENTITE:fIDHelp:=_HELP_INDI_IDENTITE;
      _ONGLET_SES_CONJOINTS:fIDHelp:=_HELP_INDI_UNIONS;
      _ONGLET_ARBRE:fIDHelp:=_HELP_INDI_ARBRE;
      _ONGLET_PHOTOS_DOCS:fIDHelp:=_HELP_INDI_PHOTO_DOC;
      _ONGLET_OBSERVATIONS:fIDHelp:=_HELP_INDI_INFOS;
      _ONGLET_DOMICILES:fIDHelp:=_HELP_INDI_DOMICILES;
      else
        if aFIndividu.panNobody.Visible then
          fIDHelp:=_HELP_INDI_START
        else
          fIDHelp:=-1;
    end;
  end
  else
    fIDHelp:=fIDModuleActif;

  if fIDHelp<>-1 then
    p_ShowHelp(fIDHelp);
end;

procedure TFMain.doTranslate;
begin
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
end;

procedure TFMain.Fichier1PaintBar(Sender:TObject;Canvas:TCanvas;const R:TRect);
var
  SR,BR:TRect;
begin
  // Matthieu : Ne sais pas
//  GradientFill(Canvas.Handle,R,0,0,0,0,0,205);
  SR:=R;
  with iBars4.Picture.Bitmap do
  begin
    TransparentColor:=clBlack;
    BR:=Rect(0,0,Width,Height);
  end;
  with SR do
  begin
    Left:=(Left+Right-BR.Right)div 2;
    Right:=Left+BR.Right;
    Top:=Bottom-BR.Bottom;
  end;
  if SR.Top>0 then
    with Canvas do
    begin
      Brush.Style:=bsClear;
      // Matthieu : Ne sais pas
//      Brush.CopyBrush(SR,iBars4.Picture.Bitmap,BR,clBlack);
      Brush.Style:=bsSolid;
    end;
end;

procedure TFMain.dxbDelFavorisClick(Sender:TObject);
begin
  if MyMessageDlg(rs_Confirm_deleting_favorite_shortcuts,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
    dm.DelFavoris;
end;

procedure TFMain.dxBarButton1Click(Sender:TObject);
var
  aFAbout:TFAbout;
begin
  aFAbout:=TFAbout.create(self);
  try
    CentreLaFiche(aFAbout);
    aFAbout.ShowModal;
  finally
    FreeAndNil(aFAbout);
  end;
end;

procedure TFMain.mCalendrierClick(Sender:TObject);
var
  aFCalendriers:TFCalendriers;
  ans,mois,jours:Word;
begin
  aFCalendriers:=TFCalendriers.create(self);
  try
    CentreLaFiche(aFCalendriers);
    DecodeDate(today,ans,mois,jours);
    aFCalendriers.doInit(ans,mois,jours,cGRE);
    aFCalendriers.CanSelect:=false;
    aFCalendriers.ShowModal;
  finally
    FreeAndNil(aFCalendriers);
  end;
end;

procedure TFMain.mOrphelinsClick(Sender:TObject);
begin
  if not assigned(aFOrphelins) then
    aFOrphelins:=TFOrphelins.create(self);
  aFOrphelins.Show;
end;

procedure TFMain.mPosthumeClick(Sender:TObject);
begin
  if not assigned(aFPosthumes) then
    aFPosthumes:=TFPosthumes.create(self);
  aFPosthumes.Show;
end;

//Gestion des PlugIns -------------------------------------------------------------------------------
procedure TFMain.DoInitAddon;
type
  Tfonction=function:Pchar;
var
  HAddOn:THandle;
  i:integer;
  S:TStringlistUTF8;
  AskTitle,FichDll:string;
  Menu:TMenuItem;
//  Link:TToolBarItemLink;
  NbIcon:hicon;
  Icon:TIcon;
  nIco:Integer;
begin
  mAddon.Clear;
  //Scanne le répertoire et met les chemins dans s TStringlistUTF8
  s:=TStringlistUTF8.Create;
  try
    LoadStringListWithFichier(_Path_Appli+_REL_PATH_PLUGINS+'*'+CST_EXTENSION_LIBRARY,s);
    // Matthieu
    //    dxBarManager.LockUpdate:=True;
    try
      for i:=0 to S.Count-1 do
      begin
        FichDll:=_Path_Appli+_REL_PATH_PLUGINS+S.Strings[i];
        try
          HAddOn:=LoadLibrary(PChar(FichDll));
          if HAddOn<>0 then
          begin
            try
              AskTitle:=Tfonction(GetProcAddress(HAddOn,'InitTitreDll'));
              Menu:=TMenuItem.Create(dxBarManager);
              Menu.Caption:=AskTitle;
              Menu.OnClick:=OnClickDll;
              Menu.Hint:=S.Strings[i];
              lstl_PathDLLs.Add(FichDll);
              //extraction de l'icône de la dll
//              NbIcon:=ExtractIcon(HInstance,Pchar(FichDll),UINT(-1));
              if NbIcon=0 then
              begin
                if (UTF8UpperCase(S.Strings[i])='DLLCREATIONWEB.DLL')
                  or (UTF8UpperCase(S.Strings[i])='ANCESTROWEB.DLL') then
                  Menu.ImageIndex:=17
                else
                  Menu.ImageIndex:=59;
              end
              else
              begin
                Icon:=TIcon.Create;
//                Icon.Handle:=ExtractIcon(HInstance,Pchar(FichDll),0);
                nIco:=dm.ImageListMenu.AddIcon(Icon);
                if nIco=-1 then
                begin
                  if UTF8UpperCase(S.Strings[i])='DLLCREATIONWEB.DLL' then //creationWeb retourne NbIcon=2 mais des icônes vides
                    Menu.ImageIndex:=17
                  else
                    Menu.ImageIndex:=59;
                end
                else
                  Menu.ImageIndex:=nIco;
                Icon.Free;
              end;
            finally
              FreeLibrary(HAddOn);
            end;
          end
          else
            ShowMessage('Erreur pendant le chargement de la dll : '+FichDll);
        except
          ShowMessage('Erreur pendant le chargement de la dll : '+FichDll);
        end;
      end;
    finally
//      dxBarManager.LockUpdate:=False;
    end;
  finally
    s.Free;
  end;
end;

procedure TFMain.OnClickDll(sender:TObject);
type
  tStartDll=procedure(sBase:pChar;Haut,Largeur:Pinteger);
  tRetourDll=function:Integer;
// Ici on ouvre la fonction principale de la dll ----------
var
  HAddOn:Cardinal;
  s_Query:TIBSQL;
  iRetourDll:Integer;
  i:Integer;
  ShowFrm:tStartDll;
  FichDll:string;
  ErrFermeture:boolean;
begin
  try
    doCloseFenetresFlottantes;
    // on vérifie qu'on est bien sur une bonne fiche
    s_Query:=TIBSQL.Create(Application);
    with s_Query do
    begin
      DataBase:=dm.ibd_BASE;
      Transaction:=dm.IBT_BASE;
      SQL.ADD('select first(1) dll_indi from gestion_dll');
      ExecQuery;
      if eof then
        i:=0
      else
        i:=Fields[0].AsInteger;
      Close;
      Free;
    end;
    if (i<1)or(dm.individu_clef<1) then
    begin
      MyMessageDlg(rs_Error_You_have_to_select_a_person_before,mtError,[mbCancel],Self);
      exit;
    end;

    Quitter1.Enabled:=False;

    FMAin.Enabled:=False;

//   dm.DoUpdateDLL; //déjà fait dans doOpenFiche et DoNouvelleFiche de l'individu
{$IFDEF WINDOWS}
if UTF8UpperCase((sender as TMenuItem).Hint)='DLLCREATIONWEB.DLL' then
  PrepareExportWeb;
{$ENDIF}
    FichDll:=_Path_Appli+_REL_PATH_PLUGINS+(sender as TMenuItem).Hint;
    //Ouverture de la dll
    HAddOn:=LoadLibrary(pchar(FichDll));
    if HAddOn>0 then //si l'ouverture se passe bien
    begin
      ErrFermeture:=false;
      try
        try
          @showFrm:=GetProcAddress(HAddOn,'InitStartDll');
          if @showFrm<>nil then
            showfrm(pChar(gci_context.PathFileNameBdd),PInteger(Height),PInteger(Width));

          try//récupération du code de retour de la dll
            iRetourDll:=tRetourDll(GetProcAddress(HAddOn,'RetourDll'));
          except
            iRetourDll:=-10;
            ErrFermeture:=true;
          end;
          if iRetourDll=-10 then
            dm.doCloseDatabase;//fermeture de la connexion
        except
          if ErrFermeture then
            MyMessageDlg(rs_Error_Closing+_CRLF+FichDll,mtError,[mbOK],Self)
          else
            MyMessageDlg(rs_Error_Launching+_CRLF+FichDll,mtError,[mbCancel],Self);
        end;
      finally
        if not FreeLibrary(HaddOn) then
          MyMessageDlg(rs_Error_while_closing+_CRLF+FichDll,mtError,[mbOK],Self);
      end;
    end
    else
      MyMessageDlg(rs_Error_Loading+_CRLF+FichDll,mtError,[mbCancel],Self);

    if not dm.ibd_BASE.Connected then
    begin
      dm.doOpenDatabase;
      if CloseModuleActif then
        OpenModule(_ID_INDIVIDU);
    end;

    FMAin.Enabled:=True;
    Quitter1.Enabled:=True;
  finally
    Screen.Cursor:=crDefault;
  end;
end;
//Fin de gestion des PlugIns ------------------------------------------------------------------------

procedure TFMain.mTagGedcomClick(Sender:TObject);
var
  aFTAGGedcom:TFTAGGedcom;
begin
  dm.IBQueryRefEvInd.DisableControls;
  dm.IBQueryRefEvInd.Close;
  aFTAGGedcom:=TFTAGGedcom.create(self);
  try
    CentreLaFiche(aFTAGGedcom);
    aFTAGGedcom.ShowModal;
  finally
    FreeAndNil(aFTAGGedcom);
    dm.IBQueryRefEvInd.Open;
    dm.IBQueryRefEvInd.EnableControls;
  end;
end;

procedure TFMain.mMajClick(Sender:TObject);
var
  aFMajInternet:TFMajInternet;
begin
  try
    aFMajInternet:=TFMajInternet.create(self);
    try
      CentreLaFiche(aFMajInternet);
      aFMajInternet.ShowModal;
    finally
      FreeAndNil(aFMajInternet);
    end;
  except
    on E:Exception do ShowMessage('Erreur fiche MajInternet'+_CRLF+_CRLF+E.Message);
  end;
end;

procedure TFMain.dxbDoublonsVilleClick(Sender:TObject);
var
  aFListeVillesDoublons:TFListeVillesDoublons;
begin
  aFListeVillesDoublons:=TFListeVillesDoublons.create(self);
  try
    CentreLaFiche(aFListeVillesDoublons);
    aFListeVillesDoublons.ShowModal;
  finally
    FreeAndNil(aFListeVillesDoublons);
  end;
end;

procedure TFMain.mBiblioMediasClick(Sender:TObject);
begin
  OuvreBiblioMedias(false,0,'','');
end;

function TFMain.OuvreBiblioMedias(bSelection:boolean;Indi:integer;sTable,sType:string):integer;
var
  retour:TModalResult;
  bdr:TIniFile;
  GardeEnMemoire:boolean;
begin
  if not assigned(aFBiblioMultimedia) then
  begin
    aFBiblioMultimedia:=TFBiblioMultimedia.create(self);
    if BiblioHeight=0 then//elle n'a pas encore été ouverte dans la session
      CentreLaFiche(aFBiblioMultimedia)
    else
    begin
      aFBiblioMultimedia.Top:=BiblioTop;
      aFBiblioMultimedia.Left:=BiblioLeft;
      aFBiblioMultimedia.Height:=BiblioHeight;
      aFBiblioMultimedia.Width:=BiblioWidth;
    end;
  end;
  aFBiblioMultimedia.doInit(bSelection,Indi,sTable,sType);
  retour:=aFBiblioMultimedia.ShowModal;
  if aFBiblioMultimedia.CleFicheSelected>0 then
    result:=aFBiblioMultimedia.CleFicheSelected
  else
    result:=0;
  BiblioTop:=aFBiblioMultimedia.Top;
  BiblioLeft:=aFBiblioMultimedia.Left;
  BiblioHeight:=aFBiblioMultimedia.Height;
  BiblioWidth:=aFBiblioMultimedia.Width;
  if retour<>mrOk then
    FreeAndNil(aFBiblioMultimedia)
  else
  begin
    bdr:=f_GetMemIniFile;
    try
//      bdr.RootKey:=HKEY_CURRENT_USER;
      if bdr.ReadBool('Main','W_BIBLIO_MULTIMEDIA', False) then
      GardeEnMemoire:=bdr.ReadBool('Appli','GardeEnMemoire', False);
    finally
    end;
    if not GardeEnMemoire then
      FreeAndNil(aFBiblioMultimedia);
  end;
end;


procedure TFMain.lMainMouseEnter(Sender:TObject);
begin
  (Sender as TLabel).Font.Color:=clBlue;
  (Sender as TLabel).Font.Style:= [fsBold,fsUnderline];
end;

procedure TFMain.lMainMouseLeave(Sender:TObject);
begin
  (Sender as TLabel).Font.Color:=clWindowText;
  (Sender as TLabel).Font.Style:= [];
end;

procedure TFMain.bfsbQuitterClick(Sender:TObject);
begin
  Close;
end;

procedure TFMain.mInfosVersionClick(Sender:TObject);
begin
  GotoThisURL(dm.GetUrlInfosMaj);
end;

procedure TFMain.mSauvegardeClick(Sender:TObject);
var
  aFSauvegarde:TFSauvegarde;
begin
  if fIDModuleActif=_ID_INDIVIDU then //AL
    if not aFIndividu.VerifyCanCloseFiche then
      exit;
  doCloseFenetresFlottantes;
  aFSauvegarde:=TFSauvegarde.create(self);
  try
    CentreLaFiche(aFSauvegarde,self,0,0);
    aFSauvegarde.ShowModal;
  finally
    FreeAndNil(aFSauvegarde);
  end;
end;

procedure TFMain.sxMListeDiffusionClick(Sender:TObject);
begin
  GotoThisURL(dm.GeturlListeDiffusion);
end;

procedure TFMain.dxbJournalClick(Sender:TObject);
var
  aFJournalOperations:TFJournalOperations;
begin
  aFJournalOperations:=TFJournalOperations.create(self);
  try
    CentreLaFiche(aFJournalOperations);
    aFJournalOperations.ShowModal;
  finally
    FreeAndNil(aFJournalOperations);
  end;
end;

procedure TFMain.mAideSQLClick(Sender:TObject);
begin
  GotoThisUrl('http://sqlpro.developpez.com/TransactSQL/SQL_MSTransactSQL.html');
end;

procedure TFMain.mLivreSQLClick(Sender:TObject);
begin
  GotoThisUrl('http://sgbd.developpez.com/livres/#L2');
end;

function TFMain.GetQSIpath:string;
begin
  if FileExistsUTF8(gci_context.PathQuiSontIls+DirectorySeparator+_DLLQUISONTILS) { *Converted from FileExistsUTF8*  } then
    result:=gci_context.PathQuiSontIls
  else
    result:='';
  gci_context.OpenQuiSontIls:=false;
end;

procedure TFMain.mCreateIndiClick(Sender:TObject);
begin
  OpenModuleClick(Sender);
  aFIndividu.bsfbNouveau.OnClick(Self);
end;

procedure TFMain.mConsanguinTotalClick(Sender:TObject);
begin
  if fIDModuleActif=_ID_INDIVIDU then
    aFIndividu.VerifyCanCloseFiche;
  doCloseFenetresFlottantes;
  doCalculConsanguinite(0);
end;

procedure TFMain.doCalculConsanguinite(iMode:integer);
var
  aFOccupe:TFWorking;
  sTexte,sTextOrigine:string;
begin
  if iMode=0 then
    sTexte:=rs_inbreeding_Calculation_on_the_entire_folder
  else
    sTexte:=rs_inbreeding_Calculation_on_the_SOSA;

  sTextOrigine:=sTexte;
  sTexte:=sTexte+_CRLF+_CRLF+rs_Action_can_be_long + rs_Do_you_continue;

  if MyMessageDlg(sTexte,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    aFOccupe:=TFWorking.create(self);
    Screen.Cursor:=crHourGlass;
    try
      CentreLaFiche(aFOccupe);
      aFOccupe.Show;
      dm.doCalculConsang(iMode);
      dm.doMAJTableJournal(sTextOrigine);
    finally
      FreeAndNil(aFOccupe);
      Screen.Cursor:=crDefault;
    end;
    if aFIndividu<>nil then
      aFIndividu.doOpenFiche(dm.individu_clef);
  end;
end;

procedure TFMain.menu_IndividuPopup(Sender:TObject);
var
  req:TIBSQL;
begin
  req:=TIBSQL.Create(self);
  req.Database:=dm.ibd_BASE;
  req.Transaction:=dm.IBT_BASE;
  req.SQL.Add('select 1 as actif from rdb$database'
    +'  where exists (select 1 from individu where kle_dossier='+IntToStr(dm.NumDossier)
    +'  and num_sosa>0)');
  req.ExecQuery;
  mSupprimeSosa.Enabled:=req.FieldByName('actif').AsInteger=1;
  req.Close;
  req.Free;
  mChercheNIP.Enabled:=fIDModuleActif=_ID_INDIVIDU;
end;

procedure TFMain.mCalculDatesClick(Sender:TObject);
begin
  if not Assigned(aFCalculDate) then
  begin
    aFCalculDate:=TFCalculDate.create(self);
    CentreLaFiche(aFCalculDate);
  end;
  aFCalculDate.Show;
end;

procedure TFMain.OuvreCalculsDates(const DateWriten:string);
begin
  if _DateTest.DecodeHumanDate(DateWriten) then
    OuvreCalculsDates(_DateTest.DateCode1)
  else
    mCalculDatesClick(Self);
end;

procedure TFMain.OuvreCalculsDates(const DateCode:Integer);
var
  An,Mois,Jour:Integer;
begin
 DecodeDateCode(DateCode,An,Mois,Jour,cGRE);
 OuvreCalculsDates(An,Mois,Jour);
end;

procedure TFMain.OuvreCalculsDates(const An,Mois,Jour:Integer);
begin
  if not Assigned(aFCalculDate) then
  begin
    aFCalculDate:=TFCalculDate.create(self);
    CentreLaFiche(aFCalculDate);
  end;
  aFCalculDate.InitDates(An,Mois,Jour);
  aFCalculDate.Show;
end;

procedure TFMain.mResetToolBarClick(Sender:TObject);
begin
  { Matthieu ?
  for i:=0 to dxBarManager.Bars.Count-1 do
  begin
    if MyMessageDlg(rs_Do_you_reset_the_menu+dxBarManager.Bars[i].Caption,mtWarning
      ,[mbYes,mbNo],Self)=mrYes then
    begin
      dxBarManager.Bars[i].Reset;
      dxBarManager.Bars[i].Visible:=true;
    end;
  end;
  for i:=menu_Favoris.ItemLinks.count-1 downto 0 do
  begin
    if TMenuItem(menu_Favoris.itemLinks[i].item).Tag>0 then
      menu_Favoris.itemLinks.Delete(i);
  end;
  for i:=SubItemSuppFav.ItemLinks.count-1 downto 0 do
  begin
    if TMenuItem(SubItemSuppFav.itemLinks[i].item).Tag>0 then
      SubItemSuppFav.itemLinks.Delete(i);
  end;       }
  mAddon.Clear;
//  dxBarManager.SaveToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_MAIN_MENU');
  DoInitAddon;
  RefreshFavoris;

  //Mise à jour du journal
  dm.doMAJTableJournal(rs_Log_Menu_reset);
end;

procedure TFMain.mDeleteBrancheClick(Sender:TObject);
var
  aFDeleteBranche:TFDeleteBranche;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    aFIndividu.VerifyCanCloseFiche;
  doCloseFenetresFlottantes;
  aFDeleteBranche:=TFDeleteBranche.create(self);
  try
    CentreLaFiche(aFDeleteBranche);
    aFDeleteBranche.ShowModal;
  finally
    FreeAndNil(aFDeleteBranche);
  end;
end;

procedure TFMain.mDelImportClick(Sender:TObject);
var
  aFDeleteImportGedcom:TFDeleteImportGedcom;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    aFIndividu.VerifyCanCloseFiche;
  doCloseFenetresFlottantes;
  dm.doSaveLastFicheActiveOfDossier;
  aFDeleteImportGedcom:=TFDeleteImportGedcom.create(self);
  try
    CentreLaFiche(aFDeleteImportGedcom);
    aFDeleteImportGedcom.ShowModal;
    if aFDeleteImportGedcom.bModif then
    begin
      Screen.Cursor:=crHourGlass;
      dm.doOpenDossier(dm.NumDossier);
      if CloseModuleActif then
        OpenModule(_ID_INDIVIDU);
    end;
  finally
    FreeAndNil(aFDeleteImportGedcom);
  end;
end;

procedure TFMain.mResetWindowsClick(Sender:TObject);
begin
  if MyMessageDlg(rs_Action_will_reset_some_Ancestromania_parameters+_CRLF+_CRLF+
    rs_Do_you_continue,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    MyMessageDlg(rs_Ancestromania_will_be_closed_Youll_have_to_restart_it,mtInformation, [mbOK],Self);
    doCloseFenetresFlottantes;
    dm.doResetFenetres(True);
  end;
end;

procedure TFMain.mImportDossierClick(Sender:TObject);
var
  aFMutationBase:TFMutationBase;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    aFIndividu.VerifyCanCloseFiche;
  doCloseFenetresFlottantes;
  aFMutationBase:=TFMutationBase.create(self);
  try
    CentreLaFiche(aFMutationBase);
    aFMutationBase.ShowModal;
  finally
    FreeAndNil(aFMutationBase);
  end;
end;

procedure TFMain.mVoirPointClick(Sender:TObject);
var
  aFVoirPoint:TFVoirPoint;
begin
  aFVoirPoint:=TFVoirPoint.create(self);
  try
    CentreLaFiche(aFVoirPoint);
    aFVoirPoint.ShowModal;
  finally
    FreeAndNil(aFVoirPoint);
  end;
end;

procedure TFMain.mTrucsClick(Sender:TObject);
begin
  GotoThisUrl('http://ancestrosphere.free.fr/forum/index.php?board=26.0');
end;

procedure TFMain.doShowHistoire;
begin
  if not Assigned(_FormHistoire) then
  begin
    if dm.IBBaseParam.Connected then
    begin
      _FormHistoire := TFHistoire.Create(Self);
      _FormHistoire.Show;
    end;
  end
  else
    _FormHistoire.Close;
end;



procedure TFMain.SuperFormClose(Sender:TObject;var Action:TCloseAction);
var
  monhandle:TCustomForm;
  n:integer;
begin
  doCloseFenetresFlottantes;
  mFenetres.Clear;

  for n:=menu_Favoris.Count-1 downto 0 do
    if menu_Favoris.Items[n].Tag>0 then
      menu_Favoris.Delete(n);

  for n:=SubItemSuppFav.Count-1 downto 0 do
    if SubItemSuppFav.Items[n].Tag>0 then
      SubItemSuppFav.Delete(n);

  mAddon.Clear;
  lstl_PathDLLs.Clear;
  // Matthieu : ?
//  dxBarManager.SaveToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_MAIN_MENU');

  if gci_context.OpenQuiSontIls then
  begin
    monhandle:=ffor_FindForm('TForm_MainPhoto');
    if monhandle<>nil then
      monhandle.close;
  end;
end;

procedure TFMain.doCloseFenetresFlottantes;
begin
  if Assigned(_FormNavigation) then
    _FormNavigation.Close;

  if Assigned(_FormHistoire) then
    _FormHistoire.Close;

  if Assigned(aFRechercher) then
  begin
    aFRechercher.Close;
  end;

  if Assigned(aFEnvFamille) then
  begin
    aFEnvFamille.Close;
  end;

  if Assigned(aFIndiDateIncoherente) then
  begin
    aFIndiDateIncoherente.Close;
  end;

  if Assigned(aFRechercheActes) then
  begin
    aFRechercheActes.Close;
  end;

  if Assigned(aFRechercheAncetres) then
  begin
    aFRechercheAncetres.Close;
  end;

  if Assigned(aFGroupeIndis) then
  begin
    aFGroupeIndis.Close;
  end;

  if Assigned(aFOrphelins) then
  begin
    aFOrphelins.Close;
  end;

  if Assigned(aFPosthumes) then
  begin
    aFPosthumes.Close;
  end;

  if Assigned(aFQuiPorteCeTitre) then
  begin
    aFQuiPorteCeTitre.Close;
  end;

  if Assigned(aFBiblioMultimedia) then
  begin
    aFBiblioMultimedia.IBMultimedia.Close;
    FreeAndNil(aFBiblioMultimedia);
  end;

  if Assigned(aFListeUnions) then
  begin
    aFListeUnions.Close;
  end;

  if Assigned(aFAnniversaires) then
  begin
    aFAnniversaires.Close;
  end;

  if Assigned(aFGraphPaintArbre) then
  begin
    aFGraphPaintArbre.Close;
  end;

  if Assigned(aFGraphPaintRoue) then
  begin
    aFGraphPaintRoue.Close;
  end;

  if Assigned(aFGraphPaintLiens) then
  begin
    aFGraphPaintLiens.Close;
  end;

  if Assigned(aFGraphPaintParente) then
  begin
    aFGraphPaintParente.Close;
  end;

  if Assigned(aFListeDoublons) then
  begin
    aFListeDoublons.Close;
  end;

  if Assigned(aFIndDlg) then
  begin
    aFIndDlg.Close;
  end;

  if Assigned(aFtvAscendance) then
  begin
    aFtvAscendance.Close;
  end;

  if Assigned(aFUtilisationMedia) then
  begin
    aFUtilisationMedia.Close;
  end;

  if Assigned(aFArbreHierDesc) then
  begin
    aFArbreHierDesc.Close;
  end;

  if Assigned(aFIndividuRepertoireR) then
  begin
    aFIndividuRepertoireR.Close;
  end;

  if Assigned(aFListReport) then
  begin
    aFListReport.Close;
  end;

  if Assigned(aFVillesVoisines) then
  begin
    aFVillesVoisines.Close;
  end;

  if Assigned(aFPostit) then
  begin
    aFPostit.Close;
  end;

  if Assigned(aFCalculDate) then
  begin
    aFCalculDate.Close;
  end;

  if Assigned(aFIndividu) then
  with aFIndividu do
   if  Assigned(aFIndividuIdentite)
   and Assigned(aFIndividuIdentite.aFIndividuEditEventLife) then
      begin
       aFIndividuIdentite.aFIndividuEditEventLife.Close;
      end;

  MajmFenetres(self);
end;

procedure TFMain.mDateIncoherentesClick(Sender:TObject);
begin
  if not assigned(aFIndiDateIncoherente) then
    aFIndiDateIncoherente:=TFIndiDateIncoherente.create(self);
  aFIndiDateIncoherente.Show;
  aFIndiDateIncoherente.FirstOpen;
end;

procedure TFMain.mQuiPorteCeTitreClick(Sender:TObject);
begin
  if not assigned(aFQuiPorteCeTitre) then
    aFQuiPorteCeTitre:=TFQuiPorteCeTitre.create(self);
  aFQuiPorteCeTitre.Show;
end;

procedure TFMain.doMajBarreTitre;
var
  s:string;
  i:integer;
begin
  MajEtatOptim;
  Caption:=TitreAppli;
  s:=extractFileNameWithoutExt(Application.ExeName);
  if AnsiUpperCase(s)<>AnsiUpperCase(TitreAppli) then
  begin
    Application.Title:=s;
    Caption:=Caption+' - '+fs_RemplaceMsg(rs_Caption_Session ,[s]);
  end;
  if dm.ibd_BASE.Connected and(dm.NumDossier>0) then
  begin
    i:=Length(gci_context.PathFileNameBdd)-LastDelimiter(DirectorySeparator,gci_context.PathFileNameBdd);
    s:=RightStr(gci_context.PathFileNameBdd,i);
    Caption:=Caption+fs_RemplaceMsg(rs_Caption_Base_folder_no_path,[s,IntToStr(dm.NumDossier),fNomDossier]);
  end;
end;

procedure TFMain.option_RenumerotationSOSAClick(Sender:TObject);
var
  aFIndividuRepertoire:TFIndividuRepertoire;
  aFConfirmAddToFavoris:TFConfirmAddToFavoris;
  aLettre:string;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    aFIndividu.VerifyCanCloseFiche;
  doCloseFenetresFlottantes;
  if ( Sender as TComponent ).Name = 'FImportGedcom'
   Then aLettre := rs_Confirm_Creating_SOSA_from_first_imported_person
   Else aLettre := rs_Confirm_Creating_SOSA_from_selected_person;
  case MyMessageDlg(aLettre,mtConfirmation,mbYesNoCancel,Self) of
    mrCancel:Exit;
    mrNo:Begin
          //Création de la boite de recherche d'un individu par le prénom
          aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
          try
            CentreLaFiche(aFIndividuRepertoire);
            aFIndividuRepertoire.NomIndi:=NomIndi;

            aLettre:=Copy(IndiTrieNom,1,1);
            aFIndividuRepertoire.InitIndividuPrenom(aLettre,'SOSA',0,dm.individu_clef,False,True);
            //pour identifier l'indi par sa clef
            aFIndividuRepertoire.Caption:=rs_Select_SOSA_Number_One;
            if aFIndividuRepertoire.ShowModal=mrOk then
             begin
              if MyMessageDlg(rs_Confirm_SOSA_renumbering
                ,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
              begin
                doShowWorking(rs_Please_Wait);
                try
                  dm.up_RenumSosa(aFIndividuRepertoire.ClefIndividuSelected);
                finally
                  doCloseWorking;
                end;

                aFConfirmAddToFavoris:=TFConfirmAddToFavoris.create(self);
                try
                  CentreLaFiche(aFConfirmAddToFavoris);
                  aFConfirmAddToFavoris.Nom:=aFIndividuRepertoire.NomPrenomIndividuSelected;
                  aFConfirmAddToFavoris.Sexe:=aFIndividuRepertoire.SexeIndividuSelected;
                  if aFConfirmAddToFavoris.ShowModal=mrOk then
                    if CloseModuleActif then
                    begin
                      dm.individu_clef:=aFIndividuRepertoire.ClefIndividuSelected;
                      dm.AddToFavoris(aFIndividuRepertoire.ClefIndividuSelected);
                      dm.AddToFavoris(dm.doRecupMaxSosa);
                      RefreshFavoris;
                    end;
                finally
                  FreeAndNil(aFConfirmAddToFavoris);
                end;
                if CloseModuleActif then //AL
                  OpenModule(_ID_INDIVIDU);

              end;

              doCalculConsanguinite(1);
             end;
          finally
            FreeAndNil(aFIndividuRepertoire);
          end;
         End;
    mrYes:Begin
            with dm do
             up_RenumSosa(individu_clef);
            doCalculConsanguinite(1);
          end;
  end;
end;

procedure TFMain.mSupprimeSosaClick(Sender:TObject);
var
  req:TIBSQL;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    aFIndividu.VerifyCanCloseFiche;

  if MyMessageDlg(rs_Confirm_SOSA_deleting,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
  begin
    dm.doActiveTriggerMajDate(false);
    try
      req:=TIBSQL.Create(self);
      req.Database:=dm.ibd_BASE;
      req.ParamCheck:=false;
      req.SQL.Add('UPDATE INDIVIDU SET NUM_SOSA=Null,Type_Lien_Gene=null'
        +' WHERE KLE_DOSSIER='+IntToStr(dm.NumDossier));
      try
        req.ExecQuery;
        req.Close;
      finally
        req.Free;
      end;
      dm.IBT_base.CommitRetaining;
    finally
      dm.doActiveTriggerMajDate(true);
    end;

    dm.iSosa1:=0;
    dm.sSosa1:='Sosa n°1 non défini dans ce dossier';

    if fIDModuleActif=_ID_INDIVIDU then
      aFIndividu.doOpenFiche(dm.individu_clef);
  end;
end;

procedure TFMain.mRechercheActesClick(Sender:TObject);
begin
  if not assigned(aFRechercheActes) then
  begin
    aFRechercheActes:=TFRechercheActes.create(self);
    aFRechercheActes.Label1.Caption:=rs_Caption_List_of_acts;
    aFRechercheActes.IBQActes.Close;
  end;
  aFRechercheActes.Show;
end;

procedure TFMain.mAncetreSansParentClick(Sender:TObject);
begin
  if not assigned(aFRechercheAncetres) then
    aFRechercheAncetres:=TFRechercheAncetres.create(self);
  aFRechercheAncetres.Show;
  aFRechercheAncetres.DoRefreshControls;
end;

procedure TFMain.mGroupeIndisClick(Sender:TObject);
begin
  if not assigned(aFGroupeIndis) then
    aFGroupeIndis:=TFGroupeIndis.create(self);
  aFGroupeIndis.Show;
  aFGroupeIndis.DoInit;
end;

procedure TFMain.OnClickDelFavori(sender:TObject);
begin
  with dm.ReqSansCheck do
  begin
    Close;
    SQL.Text:='delete from favoris where kle_fiche='+IntToStr(TMenuItem(sender).Tag);
    ExecQuery;
    Close;
  end;
  RefreshFavoris;
end;

procedure TFMain.mPartenairesClick(Sender:TObject);
begin
  p_OpenFileOrDirectory ( _Path_Appli+_REL_PATH_GOODIES+_FileNamePartenaires );
end;

procedure TFMain.majCoordParCPAvecTransfertClick(Sender:TObject);
begin
  if fIDModuleActif=_ID_INDIVIDU then
    if not aFIndividu.VerifyCanCloseFiche Then
      Exit;
  doCloseFenetresFlottantes;
end;


procedure TFMain.mMajLieuxParInseeClick(Sender:TObject);
var
  qFav,qRef,qMaj:TIBSQL;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    if not aFIndividu.VerifyCanCloseFiche then
      exit;
  doCloseFenetresFlottantes;
  if MyMessageDlg(rs_Confirm_this_function_updates_city_names_departments_countries_etc+_CRLF+rs_Do_you_continue,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    try
      doShowWorking(rs_Updating_sites_names+_CRLF+rs_Wait);
      Screen.Cursor:=crSQLWait;
      Application.ProcessMessages;
      dm.InactiveTriggersLieuxFavoris(true);
      qFav:=TIBSQL.Create(self);
      try
        qFav.Database:=dm.ibd_BASE;
        qFav.Transaction:=dm.IBT_BASE;
        qFav.ParamCheck:=false;
        qFav.SQL.Text:='select distinct insee,upper(pays) from lieux_favoris'
          +' where char_length(insee)>0'
          +' and char_length(pays)>0';
        qFav.ExecQuery;
        if not qFav.Eof then
        begin
          qRef:=TIBSQL.Create(self);
          qMaj:=TIBSQL.Create(self);
          try
            qRef.Database:=dm.IBBaseParam;
            qRef.Transaction:=dm.IBTransParam;
            qMaj.Database:=dm.ibd_BASE;
            qMaj.Transaction:=dm.IBT_BASE;
            qRef.SQL.Text:='select first(1) v.rcv_ville,v.rcv_poste'
              +',d.rdp_libelle,r.rrg_libelle from ref_cp_villes v'
              +' inner join ref_pays p on p.rpa_code=v.rcv_pays and p.rpa_libelle=:pays'
              +' left join ref_departements d on d.rdp_code=v.rcv_dept'
              +' left join ref_regions r on r.rrg_code=v.rcv_region'
              +' where v.rcv_insee=:insee';
            qRef.Prepare;
            qMaj.SQL.Text:='execute block('
              +'insee varchar(6)=:insee'
              +',pays varchar(30)=:pays'
              +',ville varchar(50)=:ville'
              +',cp varchar(10)=:cp'
              +',departement varchar(30)=:departement'
              +',region varchar(50)=:region)'
              +'as begin'

            +' if (char_length(ville)=0) then ville=null;'
              +' if (char_length(cp)=0) then cp=null;'
              +' if (char_length(departement)=0) then departement=null;'
              +' if (char_length(region)=0) then region=null;'

            +' update evenements_ind'
              +' set ev_ind_ville=:ville'
              +',ev_ind_dept=:departement'
              +',ev_ind_region=:region'
              +',ev_ind_pays=upper(ev_ind_pays)'
              +' WHERE ev_ind_kle_dossier='+IntToStr(dm.NumDossier)
              +' and ev_ind_insee=:insee and upper(ev_ind_pays)=:pays;'

            +'update evenements_ind'
              +' set ev_ind_cp=:cp'
              +' WHERE ev_ind_kle_dossier='+IntToStr(dm.NumDossier)
              +' and ev_ind_insee=:insee and ev_ind_pays=:pays'
              +' and (ev_ind_cp is null or char_length(ev_ind_cp)=0);'

            +' update evenements_fam'
              +' set ev_fam_ville=:ville'
              +',ev_fam_dept=:departement'
              +',ev_fam_region=:region'
              +',ev_fam_pays=upper(ev_fam_pays)'
              +' WHERE ev_fam_kle_dossier='+IntToStr(dm.NumDossier)
              +' and ev_fam_insee=:insee and upper(ev_fam_pays)=:pays;'

            +'update evenements_fam'
              +' set ev_fam_cp=:cp'
              +' WHERE ev_fam_kle_dossier='+IntToStr(dm.NumDossier)
              +' and ev_fam_insee=:insee and ev_fam_pays=:pays'
              +' and (ev_fam_cp is null or char_length(ev_fam_cp)=0);'

            +' end';
            qMaj.Prepare;
            while not qFav.Eof do
            begin
              qRef.ParamByName('insee').AsString:=qFav.Fields[0].AsString;
              qRef.ParamByName('pays').AsString:=qFav.Fields[1].AsString;
              qRef.ExecQuery;
              if not qRef.Eof then
              begin
                qMaj.Params[0].AsString:=qFav.Fields[0].AsString;
                qMaj.Params[1].AsString:=qFav.Fields[1].AsString;
                qMaj.Params[2].AsString:=qRef.Fields[0].AsString;
                qMaj.Params[3].AsString:=qRef.Fields[1].AsString;
                qMaj.Params[4].AsString:=qRef.Fields[2].AsString;
                qMaj.Params[5].AsString:=qRef.Fields[3].AsString;
                qMaj.ExecQuery;
              end;
              qRef.Close;
              qFav.Next;
            end;
          finally
            qRef.Free;
            qMaj.Free;
          end;
        end;
        qFav.Close;
      finally
        qFav.Free;
        dm.InactiveTriggersLieuxFavoris(false);
        Screen.Cursor:=crDefault;
        doCloseWorking;
      end;
      dm.IBT_BASE.CommitRetaining;
    except
      on E:EIBError do
      begin
        MyMessageDlg('Erreur lors de la mise à jour.'+_CRLF
          +'Message reÃ§u de Firebird:'+_CRLF+E.Message,mtError, [mbOK],Self);
      end;
      else
        MyMessageDlg('Erreur lors de la mise à jour.',mtError, [mbOK],Self);
        dm.IBT_BASE.RollbackRetaining;
    end;
    dm.doInitLieuxFavoris;
    if fIDModuleActif=_ID_INDIVIDU then
      aFIndividu.doOpenFiche(dm.individu_clef);
  end;
end;

procedure TFMain.mMajCoordGeoClick(Sender:TObject);
var
  qFav,qRef,qMaj:TIBSQL;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    if not aFIndividu.VerifyCanCloseFiche then
      exit;
  doCloseFenetresFlottantes;
  if MyMessageDlg(rs_Confirm_this_function_updates_geographic_coord_of_every_events_and_sites+_CRLF+rs_Do_you_continue,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    try
      doShowWorking(rs_Updating_coord+_CRLF+rs_Wait);
      Screen.Cursor:=crSQLWait;
      Application.ProcessMessages;
      dm.InactiveTriggersLieuxFavoris(true);
      qFav:=TIBSQL.Create(self);
      try
        qFav.Database:=dm.ibd_BASE;
        qFav.Transaction:=dm.IBT_BASE;
        qFav.ParamCheck:=false;
        qFav.SQL.Text:='execute block as'//d'abord comme dans les lieux favoris identiques déjà documentés
          +' declare variable ville varchar(50);'
          +' declare variable cp varchar(10);'
          +' declare variable insee varchar(6);'
          +' declare variable subd varchar(50);'
          +' declare variable latitude decimal(15,8);'
          +' declare variable longitude numeric(15,8);'
          +' declare variable pays varchar(30);'
          +' begin'
          +' for select distinct ville'
          +',cp'
          +',insee'
          +',subd'
          +',pays'
          +',latitude'
          +',longitude'
          +' from lieux_favoris'
          +' where latitude is not null and longitude is not null'
          +' and ville is not null'
          +' order by subd nulls last'
          +' into'
          +' :ville'
          +',:cp'
          +',:insee'
          +',:subd'
          +',:pays'
          +',:latitude'
          +',:longitude'
          +' do begin'

        +' update evenements_ind set ev_ind_latitude=:latitude,ev_ind_longitude=:longitude'
          +' where ev_ind_kle_dossier='+IntToStr(dm.NumDossier)
          +' and (ev_ind_latitude is null or ev_ind_longitude is null)'
          +' and ev_ind_ville=:ville'
          +' and ev_ind_pays=:pays'
          +' and ev_ind_cp is not distinct from :cp'
          +' and ev_ind_insee is not distinct from :insee'
          +' and (:subd is null or ev_ind_subd is not distinct from :subd);'

        +' update evenements_fam set ev_fam_latitude=:latitude,ev_fam_longitude=:longitude'
          +' where ev_fam_kle_dossier='+IntToStr(dm.NumDossier)
          +' and (ev_fam_latitude is null or ev_fam_longitude is null)'
          +' and ev_fam_ville=:ville'
          +' and ev_fam_pays=:pays'
          +' and ev_fam_cp is not distinct from :cp'
          +' and ev_fam_insee is not distinct from :insee'
          +' and (:subd is null or ev_fam_subd is not distinct from :subd);'

        +' end'
          +' end';

        qFav.ExecQuery;
        dm.IBT_BASE.CommitRetaining;
        dm.doInitLieuxFavoris;//reconstruit le table lieux_favoris
        qFav.SQL.Text:='select distinct ville'
          +',cp'
          +',insee'
          +',pays'
          +' from lieux_favoris'
          +' where latitude is null or longitude is null'
          +' and ville is not null'
          +' and pays is not null'
          +' and (cp is null or char_length(cp)<9)'; //sinon n'existe pas dans table de référence
        qFav.ExecQuery;
        if not qFav.Eof then
        begin
          qRef:=TIBSQL.Create(self);
          qMaj:=TIBSQL.Create(self);
          try
            qRef.Database:=dm.IBBaseParam;
            qRef.Transaction:=dm.IBTransParam;
            qMaj.Database:=dm.ibd_BASE;
            qMaj.Transaction:=dm.IBT_BASE;
            qRef.SQL.Text:='select first(1) v.rcv_latitude,v.rcv_longitude from ref_cp_villes v'
              +' inner join ref_pays p on p.rpa_code=v.rcv_pays and p.rpa_libelle=:pays'
              +' where v.rcv_latitude is not null and v.rcv_longitude is not null'
              +' and v.rcv_ville=:ville'
              +' and v.rcv_poste=:cp'
              +' and v.rcv_insee=:insee';
            qRef.Prepare;
            qMaj.SQL.Text:='execute block('
              +'ville varchar(50)=:ville'
              +',cp varchar(10)=:cp'
              +',insee varchar(6)=:insee'
              +',pays varchar(30)=:pays'
              +',latitude decimal(15,8)=:latitude'
              +',longitude numeric(15,8)=:longitude)'
              +'as begin'

            +' if (char_length(cp)=0) then cp=null;'
              +' if (char_length(insee)=0) then insee=null;'

            +' update evenements_ind'
              +' set ev_ind_latitude=:latitude'
              +',ev_ind_longitude=:longitude'
              +' WHERE ev_ind_kle_dossier='+IntToStr(dm.NumDossier)
              +' and ev_ind_latitude is null or ev_ind_longitude is null'
              +' and ev_ind_pays=:pays'
              +' and ev_ind_ville=:ville'
              +' and ev_ind_cp is not distinct from :cp'
              +' and ev_ind_insee is not distinct from :insee;'

            +' update evenements_fam'
              +' set ev_fam_latitude=:latitude'
              +',ev_fam_longitude=:longitude'
              +' WHERE ev_fam_kle_dossier='+IntToStr(dm.NumDossier)
              +' and ev_fam_latitude is null or ev_fam_longitude is null'
              +' and ev_fam_pays=:pays'
              +' and ev_fam_ville=:ville'
              +' and ev_fam_cp is not distinct from :cp'
              +' and ev_fam_insee is not distinct from :insee;'

            +' end';
            qMaj.Prepare;
            while not qFav.Eof do
            begin
              qRef.ParamByName('pays').AsString:=qFav.Fields[3].AsString;
              qRef.ParamByName('ville').AsString:=qFav.Fields[0].AsString;
              qRef.ParamByName('cp').AsString:=qFav.Fields[1].AsString;
              qRef.ParamByName('insee').AsString:=qFav.Fields[2].AsString;
              qRef.ExecQuery;
              if not qRef.Eof then
              begin
                qMaj.Params[0].AsString:=qFav.Fields[0].AsString;//ville
                qMaj.Params[1].AsString:=qFav.Fields[1].AsString;//cp
                qMaj.Params[2].AsString:=qFav.Fields[2].AsString;//insee
                qMaj.Params[3].AsString:=qFav.Fields[3].AsString;//pays
                qMaj.Params[4].AsDouble:=qRef.Fields[0].AsDouble;//latitude
                qMaj.Params[5].AsDouble:=qRef.Fields[1].AsDouble;//longitude
                qMaj.ExecQuery;
              end;
              qRef.Close;
              qFav.Next;
            end;
          finally
            qRef.Free;
            qMaj.Free;
          end;
        end;
        qFav.Close;
      finally
        qFav.Free;
        dm.InactiveTriggersLieuxFavoris(false);
        Screen.Cursor:=crDefault;
        doCloseWorking;
      end;
      dm.IBT_BASE.CommitRetaining;
    except
      on E:EIBError do
      begin
        MyMessageDlg('Erreur lors de la mise à jour.'+_CRLF
          +'Message reÃ§u de Firebird:'+_CRLF+E.Message,mtError, [mbOK],Self);
      end;
      else
        MyMessageDlg('Erreur lors de la mise à jour.',mtError, [mbOK],Self);
        dm.IBT_BASE.RollbackRetaining;
    end;
    dm.doInitLieuxFavoris;
    if fIDModuleActif=_ID_INDIVIDU then
      aFIndividu.doOpenFiche(dm.individu_clef);
  end;
end;

procedure TFMain.mAjustInseeClick(Sender:TObject);
var
  q:TIBSQL;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    aFIndividu.VerifyCanCloseFiche;
  doCloseFenetresFlottantes;
  if MyMessageDlg(rs_Warning_Action_will_update_sites_identified_by_postal_code_city_country+_CRLF+_CRLF
    +rs_Do_you_continue,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    Screen.Cursor:=crHourGlass;
    q:=TIBSQL.Create(Application);
    try
      q.Database:=dm.ibd_BASE;
      q.Transaction:=dm.IBT_BASE;
      q.SQL.Add('execute procedure PROC_MAJ_INSEE(:I_DOSSIER)');
      q.params[0].AsInteger:=dm.NumDossier;
      q.ExecQuery;
    finally
      q.Free;
      Screen.Cursor:=crDefault;
    end;
    dm.IBT_base.CommitRetaining;
  end;
end;

procedure TFMain.OuvreLienGene(indi1,indi2:integer;sIndi1,sIndi2:string);
begin
  if not Assigned(aFGraphPaintParente) then
  begin
    aFGraphPaintParente:=TFGraphPaintBox.Create(self);
    aFGraphPaintParente.ChargeGraph('PARENTE');
  end;
  aFGraphPaintParente.Caption:=fs_RemplaceMsg(rs_Caption_ancestry_from_to,[sIndi1,sIndi2]);
  if not aFGraphPaintParente.doSelectOtherIndividu(indi1,true,indi2) then
    aFGraphPaintParente.Close;
end;

function TFMain.OuvreLienIndividus(const indi1,indi2:integer):boolean;
begin
  if not Assigned(aFGraphPaintLiens) then
  begin
    aFGraphPaintLiens:=TFGraphPaintBox.Create(self);
    aFGraphPaintLiens.ChargeGraph('LIENS');
  end;
  if not aFGraphPaintLiens.doSelectOtherIndividu(indi1,true,indi2) then
  begin
    Result:=False;
    aFGraphPaintLiens.Close;
  end
  else
    Result:=True;
end;

procedure TFMain.mExtrasPopup(Sender:TObject);
var
  i:integer;
begin
  for i:=0 to mExtras.Count-1 do
    if mExtras.Items[i].Tag=0 then
      mExtras.Items[i].Enabled:=dm.ibd_BASE.Connected and fDemarrageIsFinish
        and(dm.NumDossier>0);
  mConsanguinTotal.Enabled:=mConsanguinTotal.Enabled and (gci_context.NiveauConsang>0);
end;

procedure TFMain.mArbreHierAscendantClick(Sender:TObject);
begin
  if not assigned(aFtvAscendance) then
    aFtvAscendance:=TFtvAscendance.create(self);
  aFtvAscendance.Show;
  aFtvAscendance.Init_Arbre;
end;

procedure TFMain.mArbrehierClick(Sender:TObject);
begin
  if not assigned(aFArbreHierDesc) then
    aFArbreHierDesc:=TFArbreHierarchique.create(self);
  aFArbreHierDesc.Show;
  aFArbreHierDesc.Init_Arbre;
end;

procedure TFMain.doOpenCassini;
var
  s_Query:TIBSQL;
  KeyName:string;
{$IFDEF WINDOWS}
  Reg:TRegistry;
{$ELSE}
  Reg:TIniFile;
{$ENDIF}
  HCassini:THandle;
begin
  if fCassiniDll then
  begin
    {$IFDEF WINDOWS}
    Reg:=TRegistry.Create;
    try
      Reg.RootKey:=HKEY_CURRENT_USER;
      KeyName:='\SOFTWARE\CassiniVision\Ancestromania';
      Reg.OpenKey(KeyName,True);
   {$ELSE}
   try
      Reg:=f_GetMemIniFile;
   {$ENDIF}
      Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'Base',gci_context.PathFileNameBdd);
      Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'IdUtilisateur',_user_name);
      Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'PwUtilisateur',_password);
      Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'RlUtilisateur',_role_name);
      Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'UtilPARANCES',gci_context.UtilPARANCES);
      Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'PwUtilPARANCES',gci_context.PwUtilPARANCES);
      Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'RolePARANCES',gci_context.RolePARANCES);
      Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'CleDossier',IntToStr(dm.NumDossier));
      Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'LATITUDE','');
      Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'LONGITUDE','');
      if (Length(Lieu_INSEE)>0)and(Length(Lieu_Ville)>0) then
      begin
        Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'INSEE',Lieu_INSEE);
        Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'VILLE',Lieu_Ville);
        if (Length(Lieu_Latitude)>0)and(Length(Lieu_Longitude)>0) then
        begin
          Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'LATITUDE',Lieu_Latitude);
          Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'LONGITUDE',Lieu_Longitude);
        end
        else if dm.IBBaseParam.Connected then
        begin
          s_Query:=TIBSQL.Create(Application);
          with s_Query do
          begin
            DataBase:=dm.IBBaseParam;
            Transaction:=dm.IBTransParam;
            SQL.Clear;
            SQL.Text:='SELECT rcv_LATITUDE,rcv_LONGITUDE FROM REF_CP_VILLES WHERE rcv_INSEE=:INSEE AND rcv_VILLE=:VILLE AND rcv_PAYS=1';
            Params[0].asString:=Lieu_INSEE;
            Params[1].asString:=Lieu_Ville;
            ExecQuery;
            Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'LATITUDE',s_Query.FieldByName('rcv_LATITUDE').AsString);
            Reg.WriteString({$IFNDEF WINDOWS}CST_CASSINI,{$ENDIF}'LONGITUDE',s_Query.FieldByName('rcv_LONGITUDE').AsString);
            Close;
            Free;
          end;
        end;
      end;
    finally
      Reg.Free;
    end;
   {$IFDEF WINDOWS}
   HCassini:=FindWindow('CassiniMania',nil);
   if HCassini=0 then
   {$ENDIF}
      p_OpenFileOrDirectory(_Path_Appli+'CassiniMania.exe')
      {$IFDEF WINDOWS}
    else
    begin
      SendMessage(HCassini,WM_USER,0,0);
      BringWindowToTop(HCassini);
    end;
   {$ENDIF}
  end;
end;

procedure TFMain.TrouveVueGoogle(sVille,sLat,sLong:string);
var
  sUrl:string;
  sZoom:string;
begin
  if (sLat>'')and(sLong>'') then
  begin
    sLat:=StringReplace(sLat,',','.', [rfReplaceAll,rfIgnoreCase]);
    sLong:=StringReplace(sLong,',','.', [rfReplaceAll,rfIgnoreCase]);
    sZoom:=IntTostr(gci_context.Zoom);
    case gci_context.QuelSat of
      0:sUrl:='http://maps.google.com/maps?ie=UTF8&hl=fr&f=q&q='+sLat+','+sLong+'+('+sVille+')'+'&om=0&z='+sZoom+'&iwloc=A&t=h';
      1:sUrl:='http://www.geonames.org/maps/google_'+sLat+'_'+sLong+'.html';
      2:sUrl:='http://mapper.acme.com/?ll='+sLat+','+sLong+'&z='+sZoom+'&t=S';
    end;
    GoToThisUrl(sUrl);
  end;
end;

function TFMain.ChercheVille(const FicheAppelante: TForm; const NumPays :Integer; const edPays, edVille: string;
  var Pays, Region, Dept, Code, Insee, Ville, Subd, Lat, Long: string): boolean;
begin
   result:=ChercheLieu(false,FicheAppelante,NumPays,edPays,edVille,'',
     Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long);
end;


procedure TFMain.poCarteCassiniClick(Sender:TObject);
begin
  poCarteCassini.Enabled:=false;
  doOpenCassini;
  poCarteCassini.Enabled:=True;
end;

procedure TFMain.poVueSatelliteClick(Sender:TObject);
var
  sLat,sLong,sUrl,sZoom,s:string;
begin
  sLat:=Lieu_Latitude;
  sLong:=Lieu_Longitude;
  sZoom:=IntTostr(gci_context.Zoom);
  if (slat>'') and (sLong>'') then
  begin
    sLat:=StringReplace(sLat,',','.', [rfReplaceAll]);
    sLong:=StringReplace(sLong,',','.', [rfReplaceAll]);
    case gci_context.QuelSat of
      0:sUrl:=URL_GOOGLE_MAPS+'hl=fr&f=q&q='+sLat+','+sLong+'+('+Lieu_Ville+')'+'&om=0&z='+sZoom+'&iwloc=A&t=h';
      1:sUrl:=URL_GEONAMES+'/maps/google_'+sLat+'_'+sLong+'.html';
      2:sUrl:=URL_MAPPER_ACME+'?ll='+sLat+','+sLong+'&z='+sZoom+'&t=h';
      3:sUrl:=URL_OPEN_STREET_MAP+'?lat='+sLat+',&lon='+sLong+'&zoom='+sZoom;
    end;
  end
  else
  begin
    s:='';
    if Lieu_Subdivision>'' then
      s:=Lieu_Subdivision;
    if Lieu_Ville>'' then
      if s>'' then
        s:=s+','+Lieu_Ville
      else
        s:=Lieu_Ville;
    if Lieu_Departement>'' then
      if s>'' then
        s:=s+','+Lieu_Departement
      else
        s:=Lieu_Departement;
    if Lieu_Region>'' then
      if s>'' then
        s:=s+','+Lieu_Region
      else
        s:=Lieu_Region;
    if Lieu_Pays>'' then
      if s>'' then
        s:=s+','+Lieu_Pays
      else
        s:=Lieu_Pays;
    case gci_context.QuelSat of
      0:sUrl:=URL_GOOGLE_MAPS+'hl=fr&f=q&q='+s+'&om=0&z='+sZoom+'&iwloc=A&t=h';
      2:sUrl:=URL_MAPPER_ACME+'?q='+s+'&t=h';
      3:sUrl:=URL_NOMINATIM+'?q='+s+'&t=h';
    end;
  end;
  GoToThisUrl(sUrl);
end;

procedure TFMain.poGeoportailClick(Sender:TObject);
var
  sLong,sLat:string;
begin
  if (Lieu_Latitude>'')and(Lieu_Longitude>'') then
  begin
    sLat:=StringReplace(Lieu_Latitude,',','.', [rfReplaceAll]);
    sLong:=StringReplace(Lieu_Longitude,',','.', [rfReplaceAll]);
    GotoThisURL(URL_GEOPORTAIL+'?c='+sLong+','+sLat+'&z=6');
  end;
end;

procedure TFMain.poWikipediaClick(Sender:TObject);
begin
  GotoThisURL(URL_WIKIPEDIA+{$IFDEF WINDOWS}fs_convert_from_utf8_to_windows{$ENDIF}(Lieu_Ville));
end;

procedure TFMain.pmVillesVoisinesPopup(Sender:TObject);
begin
  poVoisinsDansIndex.Enabled:=(StrToFloatDef(Lieu_Latitude,1000)<>1000)and(StrToFloatDef(Lieu_Longitude,1000)<>1000);
  poVoisinsDansFavoris.Enabled:=poVoisinsDansIndex.Enabled;
end;

procedure TFMain.poVoisinsDansIndexClick(Sender:TObject);
var
  dossier:integer;
  aFModale:TFVillesVoisines;//utilisée quand la fiche appelante est elle-même modale
begin
  if TmenuItem(Sender).Tag=1 then
    dossier:=dm.NumDossier
  else
    dossier:=0;

  if Lieu_Proprietaire<>nil then
  begin
    aFModale:=TFVillesVoisines.create(self);
    try
      CentreLaFiche(aFModale,Lieu_Proprietaire);
      aFModale.doInit(Lieu_Ville,Lieu_Subdivision,StrToFloat(Lieu_Latitude),StrToFloat(Lieu_Longitude),dossier);
      aFModale.ShowModal;
    finally
      aFModale.Free;
    end;
  end
  else
  begin
    if not Assigned(aFVillesVoisines) then
    begin
      aFVillesVoisines:=TFVillesVoisines.create(self);
      CentreLaFiche(aFVillesVoisines);
    end;

    aFVillesVoisines.doInit(Lieu_Ville,Lieu_Subdivision,StrToFloat(Lieu_Latitude),StrToFloat(Lieu_Longitude),dossier);
    aFVillesVoisines.Show;
  end;
end;

procedure TFMain.MajEtatOptim;
var
  s:string;
begin
  s:='';
  if dm.iMajTaille>gci_context.BDD_Ratio_Taille then
  begin
    // Matthieu : Plus tard
    dxStatusBar.Font.Color:=clRed;
    s:=rs_Info_Optimising_is_recomended;
  end
  else
  begin
    // Matthieu : Plus tard
    dxStatusBar.Font.Color:=clGreen;
    s:=rs_Info_Optimising_is_unusefull;
  end;
  if dm.iMajTaille>0 then
    s:=s+fs_RemplaceMsg(rs_Info_Weight_of_base_has_growed_of,[IntToStr(dm.iMajTaille)]);
  MsgBarreEtat(0,s);
end;

procedure TFMain.dxStatusBarPanels3Click(Sender:TObject);
begin
  MajEtatOptim;
end;

procedure TFMain.mChercheNIPClick(Sender:TObject);
begin
  if fIDModuleActif=_ID_INDIVIDU then
    aFIndividu.btnChercheNIPClick(Sender);
end;

procedure TFMain.Arbredascendance1Click(Sender:TObject);
begin
  OuvreArbredascendance(dm.individu_clef,'A');
end;

procedure TFMain.ArbreDescendanceClick(Sender:TObject);
begin
  OuvreArbredascendance(dm.individu_clef,'D');
end;

procedure TFMain.OuvreArbredascendance(indi:integer;mode:Char);
begin
  if not Assigned(aFGraphPaintArbre) then
  begin
    aFGraphPaintArbre:=TFGraphPaintBox.Create(self);
    aFGraphPaintArbre.ChargeGraph('ARBRE');
  end;
  if mode='A' then
    aFGraphPaintArbre.sbDesc.Checked:=false
  else
    aFGraphPaintArbre.sbDesc.Checked:=true;
  gci_context.ShouldSave:=true;
  gci_context.ArbreDescendance:=aFGraphPaintArbre.sbDesc.Checked;
  aFGraphPaintArbre.doSelectOtherIndividu(indi,true);
end;

procedure TFMain.RefreshArbre;
begin
  if assigned(aFGraphPaintArbre) then
    aFGraphPaintArbre.RefreshArbre;
  if assigned(aFGraphPaintLiens) then
    aFGraphPaintLiens.RefreshArbre;
  if assigned(aFGraphPaintParente) then
    aFGraphPaintParente.RefreshArbre;
end;

procedure TFMain.Rouedascendance1Click(Sender:TObject);
begin
  if not Assigned(aFGraphPaintRoue) then
  begin
    aFGraphPaintRoue:=TFGraphPaintBox.Create(self);
    aFGraphPaintRoue.ChargeGraph('ROUE');
  end;
  aFGraphPaintRoue.doSelectOtherIndividu(dm.individu_clef,false)
end;

procedure TFMain.TypesFiliationClick(Sender:TObject);
begin
  aFEditRefFiliation:=TFEditRefFiliation.create(self);
  try
    CentreLaFiche(aFEditRefFiliation);
    aFEditRefFiliation.ShowModal;
  finally
    FreeAndNil(aFEditRefFiliation);
  end;
  aFIndividu.aFIndividuIdentite.InitFiliations;
end;

procedure TFMain.LibelDiversIndiClick(Sender:TObject);
begin
  EditRefDivers('REF_DIVERS_IND');
end;

procedure TFMain.LibelDiversFamClick(Sender:TObject);
begin
  EditRefDivers('REF_DIVERS_FAM');
end;

procedure TFMain.LibelUnionsClick(Sender: TObject);
begin
  EditRefDivers('REF_MARR');
end;

procedure TFMain.EditRefDivers(Table:string);
var
  aFEditRefDiversInd:TFEditRefDivers;
begin
  aFEditRefDiversInd:=TFEditRefDivers.Create(self);
  try
    CentreLaFiche(aFEditRefDiversInd);
    aFEditRefDiversInd.NomTable:=Table;
    aFEditRefDiversInd.ShowModal;
  finally
    FreeAndNil(aFEditRefDiversInd);
  end;
  dm.InitListeAssociations;
end;

procedure TFMain.RelaTemoinsClick(Sender:TObject);
var
  aFEditRefTemoins:TFEditRefTemoins;
begin
  aFEditRefTemoins:=TFEditRefTemoins.Create(self);
  try
    CentreLaFiche(aFEditRefTemoins);
    aFEditRefTemoins.ShowModal;
  finally
    FreeAndNil(aFEditRefTemoins);
  end;
  dm.InitListeAssociations;
end;

procedure TFMain.mEnvFamClick(Sender:TObject);
begin
  mEnvFam.Enabled:=false;
  OuvreEnvFam(dm.individu_clef,NomIndiComplet);
  mEnvFam.Enabled:=true;
end;

procedure TFMain.OuvreFUtilisationMedia(clef_media:integer);
begin
  if assigned(aFBiblioMultimedia) then
    if assigned(aFUtilisationMedia) then
      aFUtilisationMedia.Close;//sans celà aFBiblioMultimedia garde le focus
  if not assigned(aFUtilisationMedia) then
    aFUtilisationMedia:=TFUtilisationMedia.create(self);
  aFUtilisationMedia.doInit(clef_media);
  aFUtilisationMedia.Show;
end;

procedure TFMain.Ouvre_Et_Selecte_Individu;
var
  k:integer;
  CibleDlg:TForm;
  bShift:boolean;
begin
  bShift:=GetKeyState(VK_SHIFT)<0;
  CibleDlg:=Screen.ActiveForm;
  if CibleDlg is TFIndividu then
    bShift:=not bShift;
  if bShift then
  begin
    if (CibleDlg is TFIndividu)and(CibleDlg<>aFIndDlg)then
    begin
      if TFIndividu(CibleDlg).doOpenFiche(dm.individu_clef) then
        CibleDlg.Show
      else
        CibleDlg.Close;
    end
    else
      OpenFicheIndividuInBox(dm.individu_clef);
    if Assigned(aFIndividu) then
      dm.individu_clef:=aFIndividu.CleFiche;
  end
  else
  begin
    if fIDModuleActif=_ID_INDIVIDU then //soit la fiche individu est déjà active
    begin
      k:=dm.individu_clef;//on sauve dm.individu_clef car ChangeFicheActive peut le remettre à celui en cours dans la fiche
      aFIndividu.ChangeFicheActive(k);//si ok met dm.individu_clef=k
    end
    else //soit c'est un autre module qui est ouvert.
    begin//il est responsable, dans ce cas, de sa propre destruction
      OpenModule(_ID_INDIVIDU);
    end;
  end;
  DoRefreshControls;
end;

procedure TFMain.OuvreIndiDuTagMenu(sender:TObject);
begin
  if (sender as TMenuItem).Tag>0 then
  begin
    dm.individu_clef:=(sender as TMenuItem).Tag;
    Ouvre_Et_Selecte_Individu;
  end;
end;

procedure TFMain.RempliPopMenuParentsConjointsEnfants(LePM:TPopupMenu;CleIndi,SexeIndi:integer;bRupture:boolean=false);
var
  j,k,nc,ne:Integer;
  s:string;
  NewItem:TMenuItem;
  AdesItems,bParents:boolean;
  SexeItem:integer;

  function isAdulte(iSexe:integer):integer;
  begin //Image Sexe
    case iSexe of
      1:Result:=103;
      2:Result:=104;
    else
      Result:=86;
    end;
  end;

  function isEnfant(iSexe:integer):integer;
  begin
    case iSexe of
      1:Result:=101;
      2:Result:=102;
    else
      Result:=86;
    end;
  end;

  function AjouteSsMenu(NewItem:TMenuItem):boolean;
  var
    i,j,k,nc,ne:Integer;
    s:string;
    NewSItem:TMenuItem;
  begin
    j:=-10;
    ne:=0;
    nc:=0;
    k:=0;
    result:=false;
    with FMain.QssCjEnf do
    begin
      close;
      ParamByName('cle_fiche').AsInteger:=NewItem.Tag;
      ExecQuery;
      while not Eof do
      begin
        if (FieldByName('CLE_CONJOINT').AsInteger<>j) then //on ajoute un conjoint
        begin
          if nc=0 then
          begin
            NewSItem:=TMenuItem.Create(NewItem);
            NewItem.Add(NewSItem);
            NewSItem.Caption:=rs_Caption_Open_the_person_s_file_double_click;
            NewSItem.Tag:=NewItem.Tag;
            NewSItem.OnClick:=OuvreIndiDuTagMenu;
            NewSItem.Default:=true;
            NewSItem.ImageIndex:=isAdulte(SexeItem);
            NewSItem:=TMenuItem.Create(NewItem);
            NewItem.Add(NewSItem);
            NewSItem.Caption:='-';
            NewSItem:=TMenuItem.Create(NewItem);
            k:=NewItem.Count;
            NewItem.Add(NewSItem);
          end;
          inc(nc);
          NewSItem:=TMenuItem.Create(NewItem);
          NewItem.Add(NewSItem);
          NewSItem.Caption:='-';
          NewSItem:=TMenuItem.Create(NewItem);
          NewItem.Add(NewSItem);
          j:=FieldByName('CLE_CONJOINT').AsInteger;
          NewSItem.Tag:=j;
          s:=FieldByName('NOMPRENOM_CONJOINT').AsString;
          if s='' then
            if SexeItem=1 then
              s:=fs_FormatText(rs_unknown_female, mftFirstIsMaj)
            else
              s:=fs_FormatText(rs_unknown_male, mftFirstIsMaj);
          NewSItem.Caption:=s+' '+FieldByName('NAISSDECES_CONJOINT').AsString;
          i:=FieldByName('SEXE_CONJOINT').AsInteger;
          if i=0 then
            case SexeItem of
              1:i:=2;
              2:i:=1;
            end;
          NewSItem.ImageIndex:=isAdulte(i);
          if FieldByName('NOMPRENOM_CONJOINT').AsString>'' then
            NewSItem.Onclick:=OuvreIndiDuTagMenu;
        end;

        if FieldByName('CLE_FICHE').AsInteger>0 then
        begin
          inc(ne);
          NewSItem:=TMenuItem.Create(NewItem);
          NewItem.Add(NewSItem);
          NewSItem.Tag:=FieldByName('CLE_FICHE').AsInteger;
          NewSItem.Caption:=FieldByName('NOMPRENOM').AsString+' '+FieldByName('NAISSDECES').AsString;
          NewSItem.ImageIndex:=isEnfant(FieldByName('SEXE').AsInteger);
          NewSItem.Onclick:=OuvreIndiDuTagMenu;
        end;
        Next;
      end;
      close;
    end;
    if nc>0 then
    begin
      if nc=1 then
        s:=rs_Caption_Her_his_joint
      else
        s:=fs_RemplaceMsg(rs_Caption_Her_his_joints,[IntToStr(nc)]);
      if ne=1 then
        s:=s+rs_Caption_and_her_his_child
      else if ne>1 then
        s:=s+fs_RemplaceMsg(rs_Caption_and_her_his_child,[IntToStr(ne)]);
      NewItem.Items[k].Caption:=s;
      result:=true;
    end;
  end;

  function AjouteParents:boolean;
  var
    i:Integer;
    NewSItem:TMenuItem;
  begin
    result:=false;
    with FMain.QssParents do
    begin
      close;
      ParamByName('cle_fiche').AsInteger:=NewItem.Tag;
      ExecQuery;
      if (FieldByName('cle_pere').AsInteger>0)or(FieldByName('cle_mere').AsInteger>0) then
      begin
        result:=true;
        NewSItem:=TMenuItem.Create(NewItem);
        NewItem.Add(NewSItem);
        NewSItem.Caption:=rs_Caption_Open_the_person_s_file_double_click;
        NewSItem.Tag:=NewItem.Tag;
        NewSItem.OnClick:=OuvreIndiDuTagMenu;
        NewSItem.Default:=true;
        NewSItem.ImageIndex:=isEnfant(SexeItem);
        NewSItem:=TMenuItem.Create(NewItem);
        NewItem.Add(NewSItem);
        NewSItem.Caption:='-';
        NewSItem:=TMenuItem.Create(NewItem);
        NewItem.Add(NewSItem);
        if (FieldByName('cle_pere').AsInteger>0)and(FieldByName('cle_mere').AsInteger>0) then
          NewSItem.Caption:=rs_Caption_Her_his_parents +' '+FieldByName('annee_mar').AsString
        else if FieldByName('cle_pere').AsInteger>0 then
          NewSItem.Caption:=rs_Caption_Her_his_father
        else
          NewSItem.Caption:=rs_Caption_Her_his_mother;
        NewSItem:=TMenuItem.Create(NewItem);
        NewItem.Add(NewSItem);
        NewSItem.Caption:='-';
        if FieldByName('cle_pere').AsInteger>0 then
        begin
          NewSItem:=TMenuItem.Create(NewItem);
          NewItem.Add(NewSItem);
          NewSItem.Tag:=FieldByName('cle_pere').AsInteger;
          NewSItem.Caption:=FieldByName('nomprenom_pere').AsString;
          i:=FieldByName('sexe_pere').AsInteger;
          NewSItem.ImageIndex:=isAdulte(i);
          if not AjouteSsMenu(NewSItem) then
            NewSItem.Onclick:=OuvreIndiDuTagMenu;
        end;
        if FieldByName('cle_mere').AsInteger>0 then
        begin
          NewSItem:=TMenuItem.Create(NewItem);
          NewItem.Add(NewSItem);
          NewSItem.Tag:=FieldByName('cle_mere').AsInteger;
          NewSItem.Caption:=FieldByName('nomprenom_mere').AsString;
          i:=FieldByName('sexe_mere').AsInteger;
          NewSItem.ImageIndex:=isAdulte(i);
          if not AjouteSsMenu(NewSItem) then
            NewSItem.Onclick:=OuvreIndiDuTagMenu;
        end;
      end;
      close;
    end;
  end;

begin
  if (GetKeyState(VK_CONTROL)<0)or(GetKeyState(VK_SHIFT)<0) then
  begin
    bParents:=GetKeyState(VK_SHIFT)<0;
    NewItem:=TMenuItem.Create(LePM);
    LePM.Items.Add(NewItem);
    if bRupture then
      NewItem.Caption:='-'
    else
    begin
      NewItem.Caption:='-';
      NewItem:=TMenuItem.Create(LePM);
      LePM.Items.Add(NewItem);
    end;
    with FMain.QParents do
    begin
      close;
      ParamByName('cle_fiche').AsInteger:=CleIndi;
      ExecQuery;
      if (FieldByName('cle_pere').AsInteger>0)or(FieldByName('cle_mere').AsInteger>0) then
      begin
        if (FieldByName('cle_pere').AsInteger>0)and(FieldByName('cle_mere').AsInteger>0) then
          NewItem.Caption:=rs_Caption_Her_his_parents+' '+FieldByName('annee_mar').AsString
        else if FieldByName('cle_pere').AsInteger>0 then
          NewItem.Caption:=rs_Caption_Her_his_father
        else
          NewItem.Caption:=rs_Caption_Her_his_mother;
        NewItem:=TMenuItem.Create(LePM);
        LePM.Items.Add(NewItem);
        NewItem.Caption:='-';
        if FieldByName('cle_pere').AsInteger>0 then
        begin
          NewItem:=TMenuItem.Create(LePM);
          LePM.Items.Add(NewItem);
          NewItem.Tag:=FieldByName('cle_pere').AsInteger;
          NewItem.Caption:=FieldByName('nomprenom_pere').AsString;
          SexeItem:=FieldByName('sexe_pere').AsInteger;
          NewItem.ImageIndex:=isAdulte(SexeItem);
          if bParents then
            AdesItems:=AjouteParents
          else
            AdesItems:=AjouteSsMenu(NewItem);
          if not AdesItems then
            NewItem.Onclick:=OuvreIndiDuTagMenu;
        end;
        if FieldByName('cle_mere').AsInteger>0 then
        begin
          NewItem:=TMenuItem.Create(LePM);
          LePM.Items.Add(NewItem);
          NewItem.Tag:=FieldByName('cle_mere').AsInteger;
          NewItem.Caption:=FieldByName('nomprenom_mere').AsString;
          SexeItem:=FieldByName('sexe_mere').AsInteger;
          NewItem.ImageIndex:=isAdulte(SexeItem);
          if bParents then
            AdesItems:=AjouteParents
          else
            AdesItems:=AjouteSsMenu(NewItem);
          if not AdesItems then
            NewItem.Onclick:=OuvreIndiDuTagMenu;
        end;
      end
      else
        NewItem.Caption:=rs_Unknown_parents;
      close;
    end;
  end
  else
  begin
    j:=-10;
    ne:=0;
    nc:=0;
    NewItem:=TMenuItem.Create(LePM);
    LePM.Items.Add(NewItem);
    if bRupture then
      NewItem.Caption:='-'
    else
    begin
      NewItem.Caption:='-';
      NewItem:=TMenuItem.Create(LePM);
      LePM.Items.Add(NewItem);
    end;
    k:=LePM.Items.Count-1;
    with FMain.QCjEnf do
    begin
      close;
      ParamByName('cle_fiche').AsInteger:=CleIndi;
      ExecQuery;
      while not Eof do
      begin
        if (FieldByName('CLE_CONJOINT').AsInteger<>j) then //on ajoute un conjoint
        begin
          inc(nc);
          NewItem:=TMenuItem.Create(LePM);
          LePM.Items.Add(NewItem);
          NewItem.Caption:='-';
          NewItem:=TMenuItem.Create(LePM);
          LePM.Items.Add(NewItem);
          j:=FieldByName('CLE_CONJOINT').AsInteger;
          NewItem.Tag:=j;
          s:=FieldByName('NOMPRENOM_CONJOINT').AsString;
          if s='' then
            if SexeIndi=1 then
              s:='Inconnue'
            else
              s:='Inconnu';
          NewItem.Caption:=s+' '+FieldByName('NAISSDECES_CONJOINT').AsString;
          SexeItem:=FieldByName('SEXE_CONJOINT').AsInteger;
          if SexeItem=0 then
            case SexeIndi of
              1:SexeItem:=2;
              2:SexeItem:=1;
            end;
          NewItem.ImageIndex:=isAdulte(SexeItem);
          AdesItems:=AjouteSsMenu(NewItem);
          if (not AdesItems)and(FieldByName('NOMPRENOM_CONJOINT').AsString>'') then
            NewItem.Onclick:=OuvreIndiDuTagMenu;
        end;

        if FieldByName('CLE_FICHE').AsInteger>0 then
        begin
          inc(ne);
          NewItem:=TMenuItem.Create(LePM);
          LePM.Items.Add(NewItem);
          NewItem.Tag:=FieldByName('CLE_FICHE').AsInteger;
          NewItem.Caption:=FieldByName('NOMPRENOM').AsString+' '+FieldByName('NAISSDECES').AsString;
          SexeItem:=FieldByName('SEXE').AsInteger;
          NewItem.ImageIndex:=isEnfant(SexeItem);
          AdesItems:=AjouteSsMenu(NewItem);
          if not AdesItems then
            NewItem.Onclick:=OuvreIndiDuTagMenu;
        end;
        Next;
      end;
      close;
    end;
    if nc>0 then
    begin
      if nc=1 then
        s:=rs_Caption_Her_his_joint
      else
        s:=fs_RemplaceMsg(rs_Caption_Her_his_joints,[IntToStr(nc)]);
      if ne=1 then
        s:=s+rs_Caption_Her_his_child
      else if ne>1 then
        s:=s+fs_RemplaceMsg(rs_Caption_Her_his_children,[IntToStr(ne)]);
      LePM.Items[k].Caption:=s;
    end
    else
      LePM.Items[k].Caption:=rs_Caption_Without_joint_and_without_child;
  end;
end;

procedure TFMain.MsgBarreEtat(NumMessage:integer=0;Chaine:string='');
var
  alabel:Tlabel;
begin
  if Chaine='' then
  begin
    case NumMessage of
      1:Chaine:=rs_Caption_Menu_Children_Children_Ctrl_Menu_Parents_Children_Maj_Menu_Parents_Parents_Children;
      2:Chaine:=rs_Caption_Ctrl_F_in_city_and_division_selects_a_favorite_site;
      else
        Chaine:='';
    end;
  end;
  if Chaine>'' then
  begin
    alabel:=TLabel.Create(self);
    try
     // Matthieu : Plus tard
//      dxStatusBar.Panels[2].PanelStyle.Font.Size:=8;
//      aLabel.Font:=dxStatusBar.Panels[2].PanelStyle.Font;
      alabel.AutoSize:=true;
      alabel.Caption:=Chaine;
{      l:=dxStatusBar.Width-dxStatusBar.Panels[0].Width
        -dxStatusBar.Panels[1].Width
        -dxStatusBar.Panels[3].Width-35;}
  //    if alabel.Width>l then
//        dxStatusBar.Panels[2].PanelStyle.Font.Size:=7;
    finally
      alabel.Free;
    end;
  end;
  dxStatusBar.Panels[2].Text:=Chaine;
end;

procedure TFMain.Documents1Click(Sender:TObject);
begin
  if not assigned(aFListReport) then
    aFListReport:=TFListReport.create(self);
  aFListReport.Init;
  aFListReport.Show;
end;

procedure TFMain.Listeparprnom1Click(Sender:TObject);
begin
  Listeparprnom1.Enabled:=false;
  Screen.Cursor:=crSQLWait;
  try
    if not assigned(aFIndividuRepertoireR) then
    begin
      aFIndividuRepertoireR:=TFIndividuRepertoire.create(self);
      //aFIndividuRepertoireR.Position:=poDesigned;
      //MemeMoniteur(aFIndividuRepertoireR);
    end
    else
      aFIndividuRepertoireR.InitOngletsActifs;

    if dm.individu_clef>0 then
    begin
      aFIndividuRepertoireR.NomIndi:=NomIndi;
      aFIndividuRepertoireR.InitIndividuPrenom(Copy(IndiTrieNom,1,1),'INDEX',0,dm.individu_clef,False,False);
    end
    else
      aFIndividuRepertoireR.InitIndividuPrenom('A','',0,0,False,False);
    aFIndividuRepertoireR.bfsbCreation.Visible:=false;
    aFIndividuRepertoireR.Caption:=rs_Caption_Directory_showing_folder_s_persons;
    aFIndividuRepertoireR.Show;
  finally
    Listeparprnom1.Enabled:=true;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFMain.OuvreEnvFam(const Lindi:integer;const SonNom:string);
begin
  if not assigned(aFEnvFamille) then
  begin
    aFEnvFamille:=TFEnvFamille.create(self);
  end;
  aFEnvFamille.DoRechercher(Lindi,SonNom);
  aFEnvFamille.Show;
end;

function TFMain.ChercheLieuFavori(const FicheAppelante:TForm;const NumPays:Integer;const edPays,edVille,edSubd:string;
      var Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string):boolean; //AL2010
begin
  result:=ChercheLieu(true,FicheAppelante,NumPays,edPays,edVille,edSubd,
      Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long);
end;

function TFMain.ChercheLieu(const Favori:boolean;const FicheAppelante:TForm;const ANumPays : Integer;const edPays,edVille,edSubd:string;
      var APays,ARegion,ADept,ACode,AInsee,AVille,ASubd,ALat,ALong:string):boolean; //MG2014
var
  aFListVilles:TFListVilles;
begin
  result:=false;
  aFListVilles:=TFListVilles.create(self);
  with aFListVilles do
   Begin
    if Length(edPays)>0 then
    begin
      dxDBPEPays.Caption:=UTF8UpperCase(edPays);
      NomPaysFavoris:=UTF8UpperCase(edPays);
    end;
    if Favori then
    begin
      doActiveOnglet(2);
      LocateLieuFavoris(edVille,edSubd);
    end
    else
    begin
      doActiveOnglet(0);
    end;
    try
      CentreLaFiche(aFListVilles,FicheAppelante);
      if ShowModal=mrOk then
      begin
        APays:=Pays;
        ARegion:=Region;
        ADept:=Dept;
        ACode:=Code;
        AInsee:=Insee;
        AVille:=Ville;
        ASubd:=Subd;
        ALat:=Lat;
        ALong:=Long;
        result:=true;
      end;
    finally
      FreeAndNil(aFListVilles);
    end;
   end;
end;

procedure TFMain.mPrenomsMajClick(Sender: TObject);
var
  q:TIBSQL;
  ModeSaisie:TModeFormatText;
  TextDlg:string;
  Reponse:word;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    if not aFIndividu.VerifyCanCloseFiche then
      exit;
  q:=TIBSQL.Create(self);
  q.Database:=dm.ibd_BASE;
  q.Transaction:=dm.IBT_BASE;
  try
    ModeSaisie:=mftNone;
    if (Sender as TMenuItem).Tag=1 then //1=tout en majuscules
    begin
      if gci_context.ModeSaisiePrenom<>mftUpper then
      begin
        ModeSaisie:=mftUpper;
        TextDlg:=rs_Warning_Action_will_update_only_names_putting_them_to_upper+_CRLF
          +rs_Do_you_configure_this_action_to_default_in_software;
      end
      else
        TextDlg:=rs_Warning_Action_will_update_only_names_putting_them_to_upper+_CRLF+_CRLF
          +rs_Do_you_continue;
      q.SQL.Text:='update individu set prenom=upper(trim(prenom))'
        +' where kle_dossier=:dossier and prenom<>upper(trim(prenom))';
      q.params[0].AsInteger:=dm.NumDossier;
    end
    else //2=seulement la première lettre en majuscule
    begin
      if gci_context.ModeSaisiePrenom<>mftFirstCharOfWordsIsMaj then
      begin
        ModeSaisie:=mftFirstCharOfWordsIsMaj;
        TextDlg:=rs_Warning_Action_will_update_only_names_putting_first_char_to_upper+_CRLF
          +rs_Do_you_configure_this_action_to_default_in_software;
      end
      else
        TextDlg:=rs_Warning_Action_will_update_only_names_putting_first_char_to_upper+_CRLF+_CRLF
          +rs_Do_you_continue;
      q.ParamCheck:=false;
      q.SQL.Text:='execute block as'
        +' declare variable nouveau varchar(60);'
        +'declare variable i smallint;'
        +'declare variable i_len smallint;'
        +'declare variable chaine varchar(60);'
        +'declare variable car varchar(1);'
        +'declare variable debmot smallint;'
        +'declare variable clef integer;'
        +'begin'
        +'  for select cle_fiche,upper(trim(prenom))'
        +'      from individu'
        +'      where kle_dossier='+IntToStr(dm.NumDossier)
        +'      into :clef,:chaine'
        +'  do'
        +'  begin'
        +'    i_len=char_length(chaine);'
        +'    nouveau='''';'
        +'    i=1;'
        +'    debmot=1;'
        +'    while (i<=i_len) do'
        +'    begin'
        +'      car=substring(chaine from i for 1);'
        +'      if (car in ('' '',''-'','''''''')) then'
        +'      begin'
        +'        debmot=1;'
        +'        nouveau=nouveau||car;'
        +'      end'
        +'      else'
        +'      begin'
        +'        if (debmot=1) then'
        +'        begin'
        +'          nouveau=nouveau||car;'
        +'          debmot=0;'
        +'        end'
        +'        else'
        +'          nouveau=nouveau||lower(car);'
        +'      end'
        +'      i=i+1;'
        +'    end'
        +'    update individu'
        +'    set prenom=:nouveau'
        +'    where cle_fiche=:clef and prenom<>:nouveau;'
        +'  end'
        +' end';
    end;
    if ModeSaisie=mftNone then
    begin
      if MyMessageDlg(TextDlg,mtConfirmation,[mbYes,mbNo],Self)=mrNo then
        exit;
    end
    else
    begin
      Reponse:=MyMessageDlg(TextDlg,mtConfirmation,[mbYes,mbNo,mbCancel],Self);
      case Reponse of
        mrCancel:exit;
        mrYes:
          begin
            gci_context.ModeSaisiePrenom:=ModeSaisie;
            gci_context.ShouldSave:=true;
          end;
      end;
    end;
    Screen.Cursor:=crSQLWait;
    doCloseFenetresFlottantes;
    q.ExecQuery;
    dm.IBT_base.CommitRetaining;
    if fIDModuleActif=_ID_INDIVIDU then
      aFIndividu.doOpenFiche(dm.individu_clef);
  finally
    q.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFMain.mPatroMajClick(Sender: TObject);
var
  q:TIBSQL;
  ModeSaisie:TModeFormatText;
  TextDlg,NomTable:string;
  Reponse:word;
  Mode:integer;

  procedure TextReq;
  begin
    q.SQL.Text:='execute block as'
      +' declare variable ancien varchar(40);'
      +'declare variable nouveau varchar(40);'
      +'declare variable i smallint;'
      +'declare variable i_len smallint;'
      +'declare variable chaine varchar(40);'
      +'declare variable car varchar(1);'
      +'declare variable debmot smallint;'
      +'declare variable particule varchar(10);'
      +'declare variable lg_particule smallint;'
      +'declare variable partic_apostrophe smallint;'
      +'begin'
      +' for select distinct nom'
      +'     from '+NomTable
      +'     where kle_dossier='+IntToStr(dm.NumDossier)
      +'     into :ancien'
      +' do'
      +' begin'
      +'   chaine=trim(upper(ancien));'
      +'   i_len=char_length(chaine);';
    if Mode=1 then
      q.SQL.Add('nouveau=chaine;')
    else
      q.SQL.Add('nouveau='''';'
        +'i=1;'
        +'debmot=1;'
        +'while (i<=i_len) do '
        +'begin'
        +' car=substring(chaine from i for 1);'
        +' if (car in('' '',''-'','''''''')) then'
        +' begin'
        +'   debmot=1;'
        +'   nouveau=nouveau||car;'
        +' end'
        +' else'
        +' begin'
        +'   if (debmot=1) then'
        +'   begin'
        +'     nouveau=nouveau||car;'
        +'     debmot=0;'
        +'   end'
        +'   else'
        +'     nouveau=nouveau||lower(car);'
        +' end'
        +' i=i+1;'
        +'end');
    q.SQL.Add('for select trim(part_libelle)'
      +' from ref_particules'
      +' into :particule'
      +' do'
      +' begin'
      +'   lg_particule=char_length(particule);'
      +'   if (substring(particule from lg_particule for 1)='''''''') then'
      +'     partic_apostrophe=1;'
      +'   else'
      +'      partic_apostrophe=0;'
      +'   i=1;'
      +'   debmot=1;'
      +'   chaine=upper(nouveau);'
      +'   while (i<=i_len-lg_particule+1) do'
      +'   begin'
      +'     if (debmot=1) then'
      +'     begin'
      +'       if (substring(chaine from i for lg_particule)'
      +'         =upper(particule)) then'
      +'       begin'
      +'         if (i=i_len-lg_particule+1) then'
      +'           nouveau=substring(nouveau from 1 for i-1)||particule;'
      +'         else'
      +'         begin'
      +'           car=substring(nouveau from i+lg_particule for 1);'
      +'           if (partic_apostrophe=1 or car in('' '','''''''',''('','')'',''-'')) then'
      +'             if (i=1) then'
      +'             begin'
      +'               nouveau=particule'
      +'                 ||substring(nouveau from lg_particule+1);'
      +'               i=lg_particule;'
      +'             end'
      +'             else'
      +'             begin'
      +'               nouveau=substring(nouveau from 1 for i-1)||particule'
      +'                 ||substring(nouveau from i+lg_particule);'
      +'               i=i+lg_particule-1;'
      +'             end'
      +'         end'
      +'       end'
      +'     end'
      +'     car=substring(nouveau from i for 1);'
      +'     if (car in('' '','''''''',''('','')'',''-'')) then'
      +'       debmot=1;'
      +'     else'
      +'       debmot=0;'
      +'     i=i+1;'
      +'   end'
      +' end'
      +' update '+NomTable
      +' set nom=:nouveau'
      +' where kle_dossier='+IntToStr(dm.NumDossier)
      +' and nom=:ancien'
      +' and nom<>:nouveau;'
      +' end '
      +'end');
  end;

begin
  if fIDModuleActif=_ID_INDIVIDU then
    if not aFIndividu.VerifyCanCloseFiche then
      exit;
  q:=TIBSQL.Create(self);
  q.Database:=dm.ibd_BASE;
  q.Transaction:=dm.IBT_BASE;
  q.ParamCheck:=false;
  try
    ModeSaisie:=mftNone;
    if (Sender as TMenuItem).Tag=1 then //1=tout en majuscules
    begin
      if gci_context.ModeSaisieNom<>mftUpper then
      begin
        ModeSaisie:=mftUpper;
        TextDlg:=rs_Warning_Action_will_update_only_surnames_putting_them_to_upper+_CRLF
          +rs_Do_you_configure_this_action_to_default_in_software;
      end
      else
        TextDlg:=rs_Warning_Action_will_update_only_surnames_putting_them_to_upper+_CRLF+_CRLF
          +rs_Do_you_continue;
      Mode:=1;
    end
    else //2=seulement la première lettre en majuscule
    begin
      if gci_context.ModeSaisieNom<>mftFirstCharOfWordsIsMaj then
      begin
        ModeSaisie:=mftFirstCharOfWordsIsMaj;
        TextDlg:=rs_Warning_Action_will_update_only_surnames_putting_first_char_to_upper+_CRLF
          +rs_Do_you_configure_this_action_to_default_in_software;
      end
      else
        TextDlg:=rs_Warning_Action_will_update_only_surnames_putting_first_char_to_upper+_CRLF+_CRLF
          +rs_Do_you_continue;
      Mode:=2;
    end;
    if ModeSaisie=mftNone then
    begin
      if MyMessageDlg(TextDlg,mtConfirmation,[mbYes,mbNo],Self)=mrNo then
        exit;
    end
    else
    begin
      Reponse:=MyMessageDlg(TextDlg,mtConfirmation,[mbYes,mbNo,mbCancel],Self);
      case Reponse of
        mrCancel:exit;
        mrYes:
          begin
            gci_context.ModeSaisieNom:=ModeSaisie;
            gci_context.ShouldSave:=true;
          end;
      end;
    end;
    Screen.Cursor:=crSQLWait;
    doCloseFenetresFlottantes;
    NomTable:='individu';
    TextReq;
    q.ExecQuery;
    NomTable:='nom_attachement';
    TextReq;
    q.ExecQuery;
    dm.IBT_base.CommitRetaining;
    if fIDModuleActif=_ID_INDIVIDU then
      aFIndividu.doOpenFiche(dm.individu_clef);
  finally
    q.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFMain.mRemplacerPatroClick(Sender: TObject);
var
  q:TIBSQL;
  AncienNom,NouveauNom:string;
  Reponse:word;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    if not aFIndividu.VerifyCanCloseFiche then
      exit;
  AncienNom:=aFIndividu.QueryIndividuNOM.AsString;
  NouveauNom:=InputBox(rs_Replacing_of_a_surname,rs_New_surname+AncienNom+'?',AncienNom);
  if NouveauNom=AncienNom then
    exit;
  Reponse:=MyMessageDlg(rs_Do_you_ignore_case_difference,mtConfirmation,[mbYes,mbNo,mbCancel],Self);
  if Reponse=mrCancel then
    exit;
  Screen.Cursor:=crSQLWait;
  q:=TIBSQL.Create(self);
  q.Database:=dm.ibd_BASE;
  q.Transaction:=dm.IBT_BASE;
  try
    if Reponse=mrYes then
      q.SQL.Text:='update individu set nom=:NouveauNom where kle_dossier=:dossier'
        +' and upper(nom)=upper(:AncienNom) and nom<>:NouveauNom'
    else
      q.SQL.Text:='update individu set nom=:NouveauNom where kle_dossier=:dossier'
        +' and nom=:AncienNom and nom<>:NouveauNom';
    q.ParamByName('dossier').AsInteger:=dm.NumDossier;
    q.ParamByName('AncienNom').AsString:=AncienNom;
    q.ParamByName('NouveauNom').AsString:=NouveauNom;
    q.ExecQuery;
    dm.IBT_base.CommitRetaining;
    if fIDModuleActif=_ID_INDIVIDU then
      aFIndividu.doOpenFiche(dm.individu_clef);
  finally
    q.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFMain.mSepPrenomsEspaceClick(Sender: TObject);
var
  q:TIBSQL;
  Mode:integer;
  TextDlg:string;
begin
  if fIDModuleActif=_ID_INDIVIDU then
    if not aFIndividu.VerifyCanCloseFiche then
      exit;
  q:=TIBSQL.Create(self);
  q.Database:=dm.ibd_BASE;
  q.Transaction:=dm.IBT_BASE;
  try
    q.ParamCheck:=false;
    q.SQL.Text:='execute block as '
      +'declare variable nouveau_nom varchar(60);'
      +'declare variable separation integer;'
      +'declare variable i integer;'
      +'declare variable i_len integer;'
      +'declare variable chaine varchar(60);'
      +'declare variable car varchar(1);'
      +'declare variable clef integer;'
      +'begin'
      +'  for select cle_fiche,trim(prenom)'
      +'      from individu'
      +'      where kle_dossier='+IntToStr(dm.NumDossier)
      +'          into :clef,:chaine'
      +'  do'
      +'  begin'
      +'    while (char_length(chaine)>0'
      +'       and substring(chaine from 1 for 1) in('' '','','')) do'
      +'      chaine=substring(chaine from 2);'
      +'    while (char_length(chaine)>0'
      +'      and substring(chaine from char_length(chaine)) in('' '','','')) do'
      +'      chaine=substring(chaine from 1 for char_length(chaine)-1);'
      +'    i_len=char_length(chaine);'
      +'    nouveau_nom='''';'
      +'    separation=0;'
      +'    i=1;'
      +'    while (i<=i_len) do'
      +'    begin'
      +'      car=substring(chaine from i for 1);'
      +'      if (car in ('' '','','')) then'
      +'        separation=1;'
      +'      else'
      +'      begin'
      +'        if (separation=1) then'
      +'        begin'
      +'          nouveau_nom=nouveau_nom||';
    Mode:=(Sender as TMenuItem).Tag;
    if Mode=3 then //3=espace seul
    begin
      TextDlg:=rs_Warning_Action_will_separate_names_by_a_comma_with_space+_CRLF+_CRLF
        +rs_Do_you_continue;
      q.SQL.Add(''' '';');
    end
    else //4=virgule+espace
    begin
      TextDlg:=rs_Warning_Action_will_separate_names_by_a_comma_with_space+_CRLF+_CRLF
        +rs_Do_you_continue;
      q.SQL.Add(''', '';');
    end;
    q.SQL.Add('   separation=0;'
      +'        end'
      +'        nouveau_nom=nouveau_nom||car;'
      +'      end'
      +'      i=i+1;'
      +'    end'
      +'    update individu'
      +'    set prenom=:nouveau_nom'
      +'    where cle_fiche=:clef and prenom<>:nouveau_nom;'
      +'  end '
      +'end');
    if MyMessageDlg(TextDlg,mtConfirmation,[mbYes,mbNo],Self)=mrNo then
      exit;
    Screen.Cursor:=crSQLWait;
    doCloseFenetresFlottantes;
    q.ExecQuery;
    dm.IBT_base.CommitRetaining;
    if fIDModuleActif=_ID_INDIVIDU then
      aFIndividu.doOpenFiche(dm.individu_clef);
  finally
    q.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFMain.mRequetesClick(Sender: TObject);
begin
  ExecuteRequete('Select * from INDIVIDU'+_CRLF+'where kle_dossier=1',false);
end;

procedure TFMain.ExecuteRequete(TextReq:string;Execute:boolean);
var
  fRequetes:TFRequete;
begin
  if dm.ibd_BASE.Connected then
  begin
    if fIDModuleActif=_ID_INDIVIDU then
      if not aFIndividu.VerifyCanCloseFiche then
        exit;
    doCloseFenetresFlottantes;
    dm.doSaveLastFicheActiveOfDossier;
    dm.IBT_Base.Commit;
    dm.IBTrans_Secondaire.Commit;
  end;
  fRequetes:=TFRequete.Create(self);
  fRequetes.InitRequete(TextReq,Execute);
  try
    fRequetes.ShowModal;
  finally
    FreeAndNil(fRequetes);
  end;
  if dm.ibd_BASE.Connected then
    dm.ibd_BASE.Close;
  CloseModuleActif;
  if dm.doOpenDatabase=1 then
    begin
    OpenModule(_ID_INDIVIDU);
    doMajBarreTitre;
  end
  else
    OpenModule(_ID_EMPLACEMENT_BDD);
end;

procedure TFMain.mCorrErreursBaseClick(Sender: TObject);
var
  TextReq:string;
begin
  if (Sender as TMenuItem).Tag=1 then
  begin
    if MyMessageDlg( rs_Action_corrects_consistency+_CRLF+rs_Action_needs_backup+_CRLF+_CRLF
      +rs_Confirm_executing_this_action,mtWarning,[mbYes,mbNo],Self)<>mrYes then
      Exit;
    TextReq:='Select * from PROC_INCOHERENCES('+IntToStr(dm.NumDossier)+',1)';
  end
  else
  begin
    if MyMessageDlg(rs_Action_corrects_consistency+_CRLF+_CRLF
      +rs_Confirm_executing_this_action,mtInformation,[mbYes,mbNo],Self)<>mrYes then
      Exit;
    TextReq:='Select * from PROC_INCOHERENCES('+IntToStr(dm.NumDossier)+',0)';
  end;
  TextReq:=TextReq+_CRLF+'--Select * from  PROC_INCOHERENCES( :I_KLE_DOSSIER , :I_MODE'+_CRLF
    +'/*-------------------------------------------------------'+_CRLF
    +'Requête permettant de lister et corriger des anomalies'+_CRLF
    +'dans les données d''un dossier.'+_CRLF
    +'Remplacer :I_KLE_DOSSIER par le n° de votre dossier'+_CRLF
    +':I_MODE par 0 pour lister les anomalies'+_CRLF
    +':I_MODE par 1 pour corriger ces anomalies.'+_CRLF
    +'-------------------------------------------------------*/';
  ExecuteRequete(TextReq,true);
end;

procedure TFMain.mCtrlAscPereClick(Sender: TObject);
var
  s,TextReq:string;
begin
  if (Sender as TMenuItem).Tag=1 then
  begin
    s:='père.';
    TextReq:='select i.cle_fiche'+_CRLF
            +',i.nom'+_CRLF
            +',i.prenom'+_CRLF
            +',p.cle_fiche as cle_pere'+_CRLF
            +',p.nom as nom_pere'+_CRLF
            +',p.prenom as prenom_pere'+_CRLF
            +'from individu i'+_CRLF
            +'left join individu p on p.cle_fiche=i.cle_pere'+_CRLF
            +'where i.kle_dossier='+IntToStr(dm.NumDossier)+_CRLF
            +'and i.cle_pere is not null'+_CRLF
            +'and exists(select 1 from proc_test_asc(i.cle_pere,i.cle_fiche,0))';
  end
  else
  begin
    s:='mère.';
    TextReq:='select i.cle_fiche'+_CRLF
            +',i.nom'+_CRLF
            +',i.prenom'+_CRLF
            +',m.cle_fiche as cle_mere'+_CRLF
            +',m.nom as nom_mere'+_CRLF
            +',m.prenom as prenom_mere'+_CRLF
            +'from individu i'+_CRLF
            +'inner join individu m on m.cle_fiche=i.cle_mere'+_CRLF
            +'where i.kle_dossier='+IntToStr(dm.NumDossier)+_CRLF
            +'and i.cle_mere is not null'+_CRLF
            +'and exists(select 1 from proc_test_asc(i.cle_mere,i.cle_fiche,0))';
  end;
  if MyMessageDlg(fs_RemplaceMsg(rs_Action_corrects_closure,[s])+_CRLF+_CRLF
    +rs_Confirm_executing_this_action,mtInformation,[mbYes,mbNo],Self)<>mrYes then
    Exit;
  ExecuteRequete(TextReq,true);
end;

{$IFDEF WINDOWS}
procedure TFMain.PrepareExportWeb;
var
  reg:TRegistry;
  s,d:String;
begin
  if MyMessageDlg(rs_Do_you_update_export_list_with_confidential_persons,mtInformation,[mbYes,mbNo],Self)<>mrYes then
    Exit;
  s:='';
  try
    dm.ReqSansCheck.SQL.Text:='select cle_fiche from individu where kle_dossier='+IntToStr(dm.NumDossier)
      +' and bin_and(ind_confidentiel,1)=1';
    dm.ReqSansCheck.ExecQuery;
    while not dm.ReqSansCheck.Eof do
    begin
      if s>'' then
        s:=s+',';
      s:=s+dm.ReqSansCheck.Fields[0].AsString;
      dm.ReqSansCheck.Next;
    end;
  finally
    dm.ReqSansCheck.Close;
  end;
  d:=fs_TextToFileName(fNomDossier,True);
  reg:=TRegistry.Create;
  try
    reg.RootKey:=HKEY_CURRENT_USER;
    reg.OpenKey(DirectorySeparator+'Software'+DirectorySeparator+Ancestromania+DirectorySeparator+'CreationWeb'+DirectorySeparator+d,true);
    reg.WriteString({$IFNDEF WINDOWS}KeyName,{$ENDIF}'Exclusions',s);
  finally
    reg.Free;
  end;
end;
{$ENDIF}
(*
procedure TFMain.menu_ImportExportPopup(Sender: TObject);
begin
  if FileExistsUTF8(_Path_Appli+'AncestroWeb.exe') { *Converted from FileExistsUTF8*  }// and (NbrProcess('AncestroWeb.exe')=0)
   then
    mAncestroWeb.Visible:=True
   else
    mAncestroWeb.Visible:=False;
end;
*)
procedure TFMain.mAncestroWebClick(Sender: TObject);
//var
//  q:TIBSQL;
//  i:Integer;
var F_Ancestroweb : TF_AncestroWeb;
begin
  F_Ancestroweb:=TF_AncestroWeb(ffor_CreateUniqueChild(TF_AncestroWeb,fsNormal,False));
  with F_Ancestroweb do
   Begin
    FreeAndNil(FIniFile);
    if not Visible Then
      DoInit(dm.ibd_BASE.DatabaseName);
    F_Ancestroweb.Show;
   end;
 { q:=TIBSQL.Create(Application);
  with q do
  begin
    try
      DataBase:=dm.ibd_BASE;
      Transaction:=dm.IBT_BASE;
      SQL.Text:='select first(1) dll_indi from gestion_dll';
      ExecQuery;
      if eof then
        i:=0
      else
        i:=Fields[0].AsInteger;
      Close;
    finally
      Free;
    end;
  end;
  if (i<1)or(dm.individu_clef<1) then
    MyMessageDlg(rs_Error_You_have_to_select_a_person_before,mtError,[mbCancel],Self)
  else
   p_OpenFileOrDirectory(_Path_Appli+'AncestroWeb.exe');}
//    ShellExecute(0,'OPEN',PAnsiChar(_Path_Appli+'AncestroWeb.exe'),nil,nil,SW_SHOWNORMAL);
end;

procedure TFMain.mFenetresPopup(Sender: TObject);
var
  i:integer;
  NouvItem:TMenuItem;
begin
  mFenetres.Clear;
  if Screen.FormCount>1 then
  begin
    NouvItem:=TMenuItem.Create(mFenetres);
    NouvItem.Caption:=rs_Caption_Close_all;
    NouvItem.OnClick:=mFermeFenetres;
    NouvItem.ImageIndex:=4;
    // Matthieu ?
 //   mFenetres.Parent:=NouvItem;
    for i:=0 to Screen.FormCount-1 do
    begin
      if (Screen.Forms[i]<>Self)
        and(Screen.Forms[i].Parent=nil)
        and Screen.Forms[i].Visible
        and(Screen.Forms[i].Caption>'') then
      begin
        NouvItem:=TMenuItem.Create(Self);
        NouvItem.Caption:=Screen.Forms[i].Caption;
        NouvItem.Tag:=i;
        NouvItem.OnClick:=mFenetreOnClick;
//        mFenetres.ItemLinks.Add.Item:=NouvItem;
      end;
    end;
//    if mFenetres.Count>1 then
//      mFenetres.Items[1].BeginGroup:=True;
  end;
end;

procedure TFMain.mFenetreOnClick(Sender:TObject);
var
  i:integer;
begin
  if Sender is TMenuItem then
  begin
    i:=(Sender as TMenuItem).Tag;
    if (i>=0)and(i<Screen.FormCount) then
      if Screen.Forms[i].Visible then
        Screen.Forms[i].BringToFront;
  end;
end;

procedure TFMain.MajmFenetres(Sender:TObject);
var
  i:Integer;
  Ok:Boolean;
begin
  if bFirsTime then
    Exit;
  Ok:=False;
  for i:=0 to Screen.FormCount-1 do
  begin
    if (Screen.Forms[i]<>Self)
      and(Screen.Forms[i].Parent=nil)
      and Screen.Forms[i].Visible
      and(Screen.Forms[i].Caption>'') then
    begin
      Ok:=True;
      Break;
    end;
  end;
  mFenetres.Enabled:=Ok;
end;

procedure TFMain.mFermeFenetres(Sender:Tobject);
begin
  doCloseFenetresFlottantes;
end;

procedure TFMain.mRestaureBasesClick(Sender: TObject);
begin
  p_OpenFileOrDirectory(_Path_Appli+'RestaureBases.exe');
//  ShellExecute(0,'OPEN',PAnsiChar(_Path_Appli+'RestaureBases.exe'),nil,nil,SW_SHOWNORMAL);
end;

procedure TFMain.Fichier1Popup(Sender:TObject);
begin
  mOptimise.Enabled:=_utilEstAdmin;
  mSauvegarde.Enabled:=(pos(':',gci_context.PathFileNameBdd)=2)and FileExistsUTF8(gci_context.PathFileNameBdd);
  mRestaureBases.Enabled:=FileExistsUTF8(_Path_Appli+'RestaureBases.exe')and(NbrProcess('RestaureBases.exe')=0);
end;

function TFMain.fb_setNewFormStyle(const afor_Reference: TCustomForm;
  const afs_newFormStyle: TFormStyle; const ab_Ajuster: Boolean): Boolean;
begin

end;

procedure TFMain.mLesLieuxPopup(Sender: TObject);
begin
  mMajLieuxParInsee.Visible:=dm.IBBaseParam.Connected;
  mMajLieuxParCP.Visible:=dm.IBBaseParam.Connected;
  mMajCoordGeo.Visible:=dm.IBBaseParam.Connected;
end;

finalization
  lstl_PathDLLs.Free;
end.


