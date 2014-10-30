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
unit u_form_individu;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
{$IFNDEF FPC}
  ShellApi, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  u_objet_TCoherenceDate,
  u_buttons_flat,
  u_form_individu_identite,
  u_form_individu_Union,
  u_form_arbre,
  u_form_individu_photos_et_docs,
  u_form_individu_observations,
  u_form_individu_Domiciles,
  u_form_Actes_Liste,
  u_form_individu_Sa_Vie,
  u_objet_TState,
  u_form_coherence,
  ComCtrls, u_buttons_appli,
  u_comp_TYLanguage,U_FormAdapt,Menus,DB,Forms,
  IBCustomDataSet,IBUpdateSQL,IBQuery,StdCtrls,
  u_buttons_defs,Graphics,ExtCtrls,
  Controls,Classes,
  SysUtils,Dialogs, VirtualTrees,IB,
  u_ancestropictimages,IBSQL,
  u_ancestropictbuttons;

const
  _ONGLET_IDENTITE=0;
  _ONGLET_SES_CONJOINTS=1;
  _ONGLET_ARBRE=2;
  _ONGLET_PHOTOS_DOCS=3;
  _ONGLET_OBSERVATIONS=4;
  _ONGLET_DOMICILES=5;
  _ONGLET_ACTES=6;
  _ONGLET_SAVIE=7;

type
  { TFIndividu }
  TFIndividu=class(TF_FormAdapt)
    IBCities: TIBQuery;
    IBQCountries: TIBQuery;
    QueryIndividu:TIBQuery;
    IBPhoto: TIBQuery;
    QueryIndividuCLE_FICHE:TLongintField;
    QueryIndividuKLE_DOSSIER:TLongintField;
    QueryIndividuCLE_PERE:TLongintField;
    QueryIndividuCLE_MERE:TLongintField;
    QueryIndividuPREFIXE:TIBStringField;
    QueryIndividuNOM:TIBStringField;
    QueryIndividuPRENOM:TIBStringField;
    QueryIndividuSURNOM:TIBStringField;
    QueryIndividuSUFFIXE:TIBStringField;
    QueryIndividuDATE_NAISSANCE:TIBStringField;
    QueryIndividuDATE_DECES:TIBStringField;
    QueryIndividuSOURCE:TMemoField;
    QueryIndividuCOMMENT:TMemoField;
    QueryIndividuFILLIATION:TIBStringField;
    QueryIndividuNUM_SOSA:TFloatField;
    QueryIndividuDATE_MODIF:TDateTimeField;
    QueryIndividuDATE_CREATION:TDateTimeField;
    QueryIndividuMODIF_PAR_QUI:TIBStringField;
    QueryIndividuSEXE:TLongintField;
    QueryIndividuANNEE_NAISSANCE:TLongintField;
    QueryIndividuANNEE_DECES:TLongintField;
    QueryIndividuDECEDE:TLongintField;
    QueryIndividuINDI_TRIE_NOM:TIBStringField;
    QueryIndividuNCHI:TSmallintField;
    QueryIndividuNMR:TSmallintField;
    QueryIndividuCLE_FIXE:TLongintField;
    QueryIndividuCONSANGUINITE:TFloatField;
    QueryIndividuMP_CLEF:TLongintField;
    QueryIndividuMULTI_REDUITE:TBlobField;
    QueryIndividuTEMOIN:TLongintField;
    QueryIndividuINDI_NAISSANCE:TDateField;
    QueryIndividuVILLE_NAISSANCE:TStringField;
    QueryIndividuVILLE_DECES:TStringField;
    QueryIndividuAvecPatronyme:TLongintField;
    QueryIndividuTYPE_LIEN_GENE:TLongintField;
    QueryIndividuIND_CONFIDENTIEL:TSmallintField;
    QueryIndividuINDI_DECES:TDateField;
    QueryIndividuDERN_METIER:TStringField;
    QueryIndividuDATE_UNION:TStringField;
    UpdateIndividu:TIBUpdateSQL;
    Panel13:TPanel;
    panTop:TPanel;
    btnNaviguer:TFWXPButton;
    Panel6:TPanel;
    btnPrecedent:TXAPrior;
    btnSuivant:TXANext;
    popup_Precedent:TPopupMenu;
    popup_Suivant:TPopupMenu;
    btnPbCoherence:TCSpeedButton;
    panNobody:TPanel;
    LabelGenVide: TLabel;
    LabelCreationFiche: TLabel;
    LabelImportGedcom: TLabel;
    Language:TYLanguage;
    pmOnoMastique:TPopupMenu;
    SurVoila1:TMenuItem;
    N4441:TMenuItem;
    SurCartesdeFrance1:TMenuItem;
    SurGopatronymes2:TMenuItem;
    bsfbNouveau:TFWAdd;
    bsfbAppliquer:TFWOK;
    bsfbAnnuler:TFWCancel;
    btnPrint:TFWPrint;
    btnFermer:TFWClose;
    pBtn:TPanel;
    btnPatronyme:TXAHuman;
    btnTemoinDe:TXAPeople;
    btnOnomastique:TFWButtonList;
    btnInfos:TXAInfo;
    btnQuisontIls:TXAWho;
    ilZodiaque:TImageList;
    LabelImportDossier: TLabel;
    pNavigator:TPanel;
    btnFPrecedent:TXAPrior;
    btnFSuivant:TXANext;
    btnMoinsDix:TXAPriorPage;
    btnPlusDix:TXANextPage;
    btnHistoire:TXAHistory;
    ilOnoMastique:TImageList;
    btnChercheNIP:TFWSearch;
    bsfbSupprimer:TFWDelete;
    iPatronyme:TImage;
    iIndi:TImage;
    btValidAuto:TFWOK;
    ImSansRetour:TImage;
    imValidMan:TImage;
    Panel1:TPanel;
    PageControlIndividu:TPageControl;
    cxTabSheet1:TTabSheet;
    cxTabSheet2:TTabSheet;
    cxTabSheet3:TTabSheet;
    cxTabSheet4:TTabSheet;
    cxTabSheet5:TTabSheet;
    cxTabSheet6:TTabSheet;
    cxTabSheet7:TTabSheet;
    cxTabSheet8:TTabSheet;
    PanelIdentite:TPanel;
    PanelUnions:TPanel;
    PanelArbre:TPanel;
    PanelMedias:TPanel;
    PanelInfos:TPanel;
    PanelDomiciles:TPanel;
    PanelActes:TPanel;
    PanelSaVie:TPanel;
    QueryGetDatesInd:TIBSQL;
    btnNouvelleFiche:TFWAdd;
    btnImportGedcom:TFWImport;
    btnImportDossier:TFWImport;
    TimerTemporisation: TTimer;
    pmNom: TPopupMenu;
    procedure PageControlIndividuResize(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormDestroy(Sender:TObject);
    procedure btnNaviguerClick(Sender:TObject);
    procedure bsfbNouveauClick(Sender:TObject);
    procedure bsfbAppliquerClick(Sender:TObject);
    procedure bsfbAnnulerClick(Sender:TObject);
    procedure bsfbSupprimerClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure QueryIndividuNewRecord(DataSet:TDataSet);
    procedure btnNouvelleFicheClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure btnImportGedcomClick(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure btnFermerClick(Sender:TObject);
    procedure popup_PrecedentPopup(Sender:TObject);
    procedure btnPrecedentClick(Sender:TObject);
    procedure popup_SuivantPopup(Sender:TObject);
    procedure btnSuivantClick(Sender:TObject);
    procedure btnPbCoherenceClick(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure SuperFormMouseDown(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure btnInfosClick(Sender:TObject);
    procedure doPopUpOnomastique(Sender:TObject);
    procedure btnTemoinDeClick(Sender:TObject);
    procedure btnPatronymeClick(Sender:TObject);
    procedure btnQuisontIlsClick(Sender:TObject);
    procedure btnImportDossierClick(Sender:TObject);
    procedure doBtnDeplacement(Sender:TObject);
    procedure btnHistoireClick(Sender:TObject);
    procedure btnChercheNIPClick(Sender:TObject);
    procedure btValidAutoClick(Sender:TObject);
    procedure PageControlIndividuDrawTabEx(AControl:TPageControl;
      ATab:TTabSheet;Font:TFont);
    procedure PageControlIndividuChange(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure PageControlIndividuPageChanging(Sender: TObject;
      NewPage: TTabSheet; var AllowChange: Boolean);
    procedure TimerTemporisationTimer(Sender: TObject);
    procedure pmNomPopup(Sender: TObject);
    function GetIBQCities : TDataSet;
  private
    bPhotos:boolean;
    fFill:TState;
    fCleFiche:integer;
    XSouris,YSouris:Integer;
    //indique quelle forme est actuelle incrustée
    fOngletFormIncrusted:integer;
    //permet de savoir si les querys des onglets sont ouverts
    fOngletIdentiteIsLoaded:boolean;
    fOngletSesConjointsIsLoaded:boolean;
    fOngletArbreIsLoaded:boolean;
    fOngletPhotosDocsIsLoaded:boolean;
    fOngletObservationsIsLoaded:boolean;
    fOngletDomicilesIsLoaded:boolean;
    fOngletActesIsLoaded:boolean;
    fOngletSaVieIsLoaded:boolean;

    //Les fiches associées aux querys
    aFIndividuObservations:TFIndividuObservations;
    aFIndividuActes:TFActesListe;
    aFIndividuSavie:TFSaVie;
    fModified:boolean;
    fDialogMode:boolean;
    fProposeToCreateNewIndividuIfNotFind:boolean;
    fLocateOnFirstIndividuDossierIfNotFind:boolean;
    sClefQuiSontIls:string;
    bFirstTime:boolean;
    fCoherenceDate:TCoherenceDate;
    aFCoherence:TFCoherence;
    fTemporisation:boolean;
    procedure LoadCoherenceDates;
    procedure doInitialize;
    function doOpenQuerys:boolean;
    procedure RefreshNomIndividuActes(const AColor: TColor); overload;
    procedure RefreshNomIndividuActes; overload;
    procedure RefreshNomIndividuArbre(const AColor: TColor); overload;
    procedure RefreshNomIndividuArbre; overload;
    procedure RefreshNomIndividuDomiciles(const AColor: TColor); overload;
    procedure RefreshNomIndividuDomiciles; overload;
    procedure RefreshNomIndividuObservations(const AColor: TColor); overload;
    procedure RefreshNomIndividuObservations; overload;
    procedure RefreshNomIndividuPhotos(const AColor: TColor); overload;
    procedure RefreshNomIndividuPhotos; overload;
    procedure RefreshNomIndividuSaVie(const AColor: TColor); overload;
    procedure RefreshNomIndividuSaVie; overload;
    procedure RefreshNomIndividuUnion(const AColor: TColor); overload;
    procedure RefreshNomIndividuUnion; overload;
    procedure SetDialogMode(const Value:boolean);
    procedure DoNouvelleFiche;
    procedure DoAnnuler;
    procedure OnSelectIndividuInListPrevious(Sender:TObject);
    procedure OnSelectIndividuInListNext(Sender:TObject);
    procedure doGoToFiche(aIndexCleFicheInList,sens:integer);
    procedure doLoadQuisontils;
    procedure doEnableObjets(iMode:boolean);
    procedure doCompteOnglets;
    procedure InitOnglets;
    procedure doChangeRequete;
    procedure majbtValidAuto;
    procedure SetDialogModeDomiciles(const Value: boolean);
    procedure SetDialogModePhotos(const Value: boolean);
    procedure SetDialogModeUnions(const Value: boolean);
    procedure SetTemporisation(const Valeur:boolean);
    //procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    //autre méthode pour désactiver le TPageControl principal au profit des secondaires
  public
    aFIndividuIdentite:TFIndividuIdentite;
    aFIndividuUnion:TFIndividuUnion;
    aFIndividuArbre:TFArbre;
    aFIndividuPhotosEtDocs:TFIndividuPhotosEtDocs;
    aFIndividuDomiciles:TFIndividuDomiciles;

    bOpen:Boolean;
    bNew:boolean;
    ParenteCalculee:boolean;
    NomIndiComplet:string;
    IndiTrieNom:string;
    sDateNaissance,sDateDeces,sAnneeNaissance,sAnneeDeces
      ,sAgeTexte,sAgeUnion,sVilleNaissance,sVilleDeces:string;
    bJourNaissance,bJourDeces:boolean;
    AnneeNaissance,NumJourNaissance:Integer;
    bModale:boolean;

    procedure SetPaysVilles(const CountriesToSet,CitiesToSet: TDataSource);
    //en entrée
    property DialogMode:boolean read fDialogMode write SetDialogMode;
    property LocateOnFirstIndividuDossierIfNotFind:boolean read fLocateOnFirstIndividuDossierIfNotFind write
      fLocateOnFirstIndividuDossierIfNotFind;
    property ProposeToCreateNewIndividuIfNotFind:boolean read fProposeToCreateNewIndividuIfNotFind write
      fProposeToCreateNewIndividuIfNotFind;
    property Modified:boolean read fModified write fModified;
    property CleFiche:integer read fCleFiche;
    property CoherenceDate:TCoherenceDate read fCoherenceDate write fCoherenceDate;
    property FCoherence:TFCoherence read aFCoherence write aFCoherence;
    property OngletSesConjointsIsLoaded:boolean read fOngletSesConjointsIsLoaded;
    property OngletFormIncrusted:integer read fOngletFormIncrusted;
    property Temporisation:boolean read fTemporisation write SetTemporisation;

    procedure RefreshNomIndividu;
//    procedure RefreshPhoto;
    procedure doActiveOnglet(const onglet:integer);
    function GetNomIndividu:string;
    //pour fermer tous les query, sans poser de question
    procedure ForceCloseAllQuerys;
    //en entrée
    function doOpenFiche(aCleFiche:integer):boolean;
    //en sortie
    function VerifyCanCloseFiche:boolean;
    function ChangeFicheActive(const aCleFiche:integer):boolean;
    procedure doBouton(const bMode:boolean);
    function TestFicheIsModified:boolean;
    procedure MajAges(const Evenement:string);
    function TestAscDesc(const indi1,indi2:integer;const NomIndi1,NomIndi2:string
      ;AutoriseAsc:boolean=true;AutoriseDesc:boolean=true):boolean;
    function DoAppliquer(const bCommit:boolean=true):word;
    procedure PostIndividu;
    function CollerEvenement(var Nouv_Evenement:integer;EvenACopier:integer=0;IndiCible:integer=0):boolean;
    function AgesConjoints(const DateEv,DateNaisConjoint:string):string;//AL2011
    procedure RemplacerConjoint(const Union,A_Conjoint:integer;const NomA_Conjoint:string);
    procedure TestCoherenceDates;
    function CalcChampsDateInd(const Dataset:TDataset):String;overload;
    function CalcChampsDateInd(const Dataset:TDataset;const DateWriten:String):String;overload;
    procedure lNomMouseEnter(Sender:TObject);
    procedure lNomMouseLeave(Sender:TObject);
    procedure lNomMouseMove(Sender:TObject;
      Shift:TShiftState;X,Y:Integer);
    procedure lNomClick(Sender:TObject);
  end;

implementation
uses  u_common_functions,
      u_common_ancestro,
      u_form_main,u_common_const,u_dm,
      u_Form_Infos_Indi,u_Form_Temoin_De,u_Form_Patronymes,
      u_Form_ChercheNIP,u_genealogy_context,u_form_individu_Navigation, u_objet_TGedcomDate,FileUtil,
      u_common_ancestro_functions, fonctions_reports,
      u_common_treeind,
      fonctions_dialogs,
      fonctions_string,
      fonctions_forms,
      fonctions_init,
      dynlibs,fonctions_system;
{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}
{ TFIndividu }

procedure TFIndividu.SuperFormCreate(Sender:TObject);
var
  i:integer;
begin
  bPhotos:=True;
  OnRefreshControls:=SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorMedium;
  panNobody.Color:=gci_context.ColorLight;
  btnImportDossier.Color:=gci_context.ColorLight;
  btnNouvelleFiche.Color:=gci_context.ColorLight;
  btnImportGedcom.Color:=gci_context.ColorLight;
  btnImportDossier.ColorFrameFocus:=gci_context.ColorLight;
  btnNouvelleFiche.ColorFrameFocus:=gci_context.ColorLight;
  btnImportGedcom.Color:=gci_context.ColorLight;
  PanelIdentite.Color:=gci_context.ColorLight;
  PanelUnions.Color:=gci_context.ColorLight;
  PanelMedias.Color:=gci_context.ColorLight;
  PanelInfos.Color:=gci_context.ColorLight;
  PanelArbre.Color:=gci_context.ColorLight;
  PanelDomiciles.Color:=gci_context.ColorLight;
  PanelActes.Color:=gci_context.ColorLight;
  PanelSaVie.Color:=gci_context.ColorLight;

  Panel6.Color:=gci_context.ColorMedium;
{  btnPlusDix.ColorHighLight:=btnPlusDix.Color;
  btnFSuivant.ColorHighLight:=btnFSuivant.Color;
  btnFPrecedent.ColorHighLight:=btnFPrecedent.Color;
  btnMoinsDix.ColorHighLight:=btnMoinsDix.Color;
  btnPlusDix.ColorShadow:=btnPlusDix.Color;
  btnFSuivant.ColorShadow:=btnFSuivant.Color;
  btnFPrecedent.ColorShadow:=btnFPrecedent.Color;
  btnMoinsDix.ColorShadow:=btnMoinsDix.Color;
  btnPlusDix.ColorFocused:=btnPlusDix.Color;
  btnFSuivant.ColorFocused:=btnFSuivant.Color;
  btnFPrecedent.ColorFocused:=btnFPrecedent.Color;
  btnMoinsDix.ColorFocused:=btnMoinsDix.Color;
  btnPlusDix.ColorBorder:=btnPlusDix.Color;
  btnFSuivant.ColorBorder:=btnFSuivant.Color;
  btnFPrecedent.ColorBorder:=btnFPrecedent.Color;
  btnMoinsDix.ColorBorder:=btnMoinsDix.Color;    }

  // On vérifie que le répertoire de quisontils est correct
  btnQuisontIls.Visible:=false;
  if length(gci_context.PathQuiSontIls)>0 then
    btnQuisontIls.Visible:=FileExistsUTF8(gci_context.PathQuiSontIls+DirectorySeparator+'Quisontils.exe'); { *Converted from FileExistsUTF8*  }
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  fLocateOnFirstIndividuDossierIfNotFind:=false;
  fProposeToCreateNewIndividuIfNotFind:=false;

  ParenteCalculee:=false;
  fDialogMode:=false;
  panNobody.visible:=false;
  fModified:=false;
  fOngletFormIncrusted:=_ONGLET_IDENTITE;
  fFill:=TState.create(false);
  aFCoherence:=TFCoherence.create(self);//création de la fiche d'alerte sur les dates
  aFCoherence.FormIndividu:=Self;
  fCoherenceDate:=TCoherenceDate.Create;
  fCoherenceDate.FormIndividu:=self;
  fCoherenceDate.FormCoherence:=aFCoherence;
  Application.ProcessMessages;

  fFill.value:=true;
  try
    //Identité
    aFIndividuIdentite:=TFIndividuIdentite.create(self);
    aFIndividuIdentite.ShowIncrust(PanelIdentite);

      // Sa vie
    aFIndividuSavie:=nil;
    //unions
     // Matthieu refaire
    aFIndividuUnion:=nil;
    //l'arbre
    aFIndividuArbre:=nil;
    //Photos et Docs
    aFIndividuPhotosEtDocs:=nil;
    //Observations
    aFIndividuObservations:=nil;
    //Domiciles
    aFIndividuDomiciles:=nil;
    // Actes
    aFIndividuActes:=nil;
  doChangeRequete;
  finally
    fFill.value:=false;
  end;
  for i:=_ONGLET_IDENTITE to _ONGLET_SAVIE do
    PageControlIndividu.Pages[i].ImageIndex:=-1;
  FreeAndNil(FIniFile);
  bFirstTime:=true;
  bModale:=false;
  majbtValidAuto;
end;

procedure TFIndividu.PageControlIndividuResize(Sender: TObject);
begin
  panTop.Left:=PageControlIndividu.Width-panTop.Width;
end;

function TFIndividu.GetNomIndividu:string;
begin
  result:=AssembleString([QueryIndividuNOM.AsString,QueryIndividuPRENOM.AsString]);
end;
{
procedure TFIndividu.RefreshPhoto;
begin
  aFIndividuIdentite.RefreshPhoto;
end;
}
procedure TFIndividu.SuperFormDestroy(Sender:TObject);
begin
  if assigned(aFIndividuActes) then
    FreeAndNil(aFIndividuActes);

  if assigned(aFIndividuSaVie) then
    FreeAndNil(aFIndividuSaVie);

  if assigned(aFIndividuArbre) then
    FreeAndNil(aFIndividuArbre);

  if assigned(aFIndividuDomiciles) then
  begin
    aFIndividuDomiciles.Close;
    FreeAndNil(aFIndividuDomiciles);
  end;

  if assigned(aFIndividuPhotosEtDocs) then
  begin
    aFIndividuPhotosEtDocs.Close;
    FreeAndNil(aFIndividuPhotosEtDocs);
  end;

  if assigned(aFIndividuObservations) then
    FreeAndNil(aFIndividuObservations);

  if assigned(aFIndividuUnion) then
    FreeAndNil(aFIndividuUnion);

  if assigned(aFIndividuIdentite) then
    FreeAndNil(aFIndividuIdentite);

  QueryIndividu.close;

  FreeAndNil(fFill);
  FreeAndNil(fCoherenceDate);
  FreeAndNil(aFCoherence);
end;

procedure TFIndividu.doInitialize;
begin
  //On s'assure que tous les querys sont fermés
  QueryIndividu.Close;
  aFIndividuIdentite.doInitialize;
  if Assigned(aFIndividuUnion) Then
    aFIndividuUnion.doInitialize;
  if Assigned(aFIndividuPhotosEtDocs) Then
    aFIndividuPhotosEtDocs.doInitialize;
  if Assigned(aFIndividuDomiciles) Then
    aFIndividuDomiciles.doInitialize;

  //on indique que rien n'est chargé
  fOngletIdentiteIsLoaded:=false;
  fOngletSesConjointsIsLoaded:=false;
  fOngletArbreIsLoaded:=false;
  fOngletPhotosDocsIsLoaded:=false;
  fOngletObservationsIsLoaded:=false;
  fOngletDomicilesIsLoaded:=false;
  fOngletActesIsLoaded:=false;
  fOngletSaVieIsLoaded:=false;
end;

function TFIndividu.doOpenFiche(aCleFiche:integer):boolean;
var
  monhandle:TCustomForm;
begin
  if gci_context.OpenQuiSontIls then
  begin
    monhandle:=ffor_FindForm('TForm_MainPhoto');
    if monhandle<>nil then
    begin
      monhandle.Close;
      gci_context.OpenQuiSontIls:=False;
    end;
  end;
  result:=false;
  //on ferme tous les query en cours
  doInitialize;
  //On ouvre le query principal
  fCleFiche:=aCleFiche;

  if doOpenQuerys then
  begin
      //On a trouvé l'individu
    result:=true;
    if fDialogMode=false then
      dm.DoUpdateDLL;//on enregistre les données pour la table de dll
    panNobody.visible:=false;
    PageControlIndividu.Visible:=true;
    panTop.Visible:=true;
    doActiveOnglet(fOngletFormIncrusted);
    TestCoherenceDates;
  end
  else
  begin
      //on n'a pas trouvé l'individu
    doInitialize;
      //On regarde si il existe au moins quelqu'un dans la base
    if fLocateOnFirstIndividuDossierIfNotFind then //à quoi sert cette variable?
    begin
      aCleFiche:=dm.IndiPrecedent;//AL 2010
          //l'a-t'on trouvé ?
      if aCleFiche<>-1 then
      begin
        fCleFiche:=aCleFiche;
        if doOpenQuerys then
        begin//On a trouvé l'individu
          result:=true;
          if fDialogMode=false then
            dm.DoUpdateDLL;//on enregistre les données pour la table de dll
          //on active la form de l'onglet sélectionné
          panNobody.visible:=false;
          PageControlIndividu.Visible:=true;
          panTop.Visible:=true;
          doActiveOnglet(fOngletFormIncrusted);
          //On ouvre les querys de la form "identité"
          TestCoherenceDates;
        end;
      end
      else
      begin//on ne l'a pas trouvé
        if fProposeToCreateNewIndividuIfNotFind then
        begin//si personne n'existe dans le dossier courant,
          panNobody.visible:=true;
          PageControlIndividu.Visible:=false;
          panTop.Visible:=false;
        end;
      end;
    end;
  end;
  if (Result)and(not fDialogMode) then
  begin
    dm.AddFicheOpen(fCleFiche,QueryIndividuSEXE.AsInteger,NomIndiComplet);
    FMain.RefreshArbre;
  end;
  doRefreshControls;
end;

function TFIndividu.doOpenQuerys:boolean;
var
  s_Chaine:string;
  i:integer;
begin
  PageControlIndividu.DisableAlign;
  DisableAlign;
  ParenteCalculee:=false;
  with IBPhoto do
    try
      Close;
      ParamByName('I_CLEF').AsInteger:=fCleFiche;
      doChangeRequete;
    finally
    end;
  with QueryIndividu do
  try
    bOpen:=False;
    result:=false;
    DisableControls;
    try
      ParamByName('I_CLEF').AsInteger:=fCleFiche;
      try
        Open;
      except
        on E:EIBError do
          showmessage(E.Message);
      end;
      if not IsEmpty
        and Active Then
      begin
        sDateNaissance:=QueryIndividuDATE_NAISSANCE.AsString;
        if QueryIndividuANNEE_NAISSANCE.IsNull then
          AnneeNaissance:=_AnMini
        else
          AnneeNaissance:=QueryIndividuANNEE_NAISSANCE.AsInteger;
        _GDate.DecodeHumanDate(sDateNaissance);
        sAnneeNaissance:=_GDate.DateCourte;
        bJourNaissance:=(_GDate.Day1>0);
        if bJourNaissance then
        begin
          DefDateCode(_GDate.Year1,1,1,cGRE,0,i);
          NumJourNaissance:=_GDate.DateCode1-i+1;
        end
        else
          NumJourNaissance:=0;

        sVilleNaissance:=trim(QueryIndividuVILLE_NAISSANCE.AsString);
        sDateDeces:=QueryIndividuDATE_DECES.AsString;
        _GDate.DecodeHumanDate(sDateDeces);
        sAnneeDeces:=_GDate.DateCourte;
        bJourDeces:=(_GDate.Day1>0);

        sVilleDeces:=trim(FieldByName('VILLE_DECES').AsString);

        sAgeTexte:=Age_Texte(sDateNaissance,sDateDeces);//MD decodage soft
        sAgeUnion:=Age_Texte(sDateNaissance,FieldByName('DATE_UNION').AsString);

        IndiTrieNom:=FieldByName('INDI_TRIE_NOM').AsString;
        RefreshNomIndividu;
        if not fDialogMode then
        begin
          dm.individu_clef:=fCleFiche;
          FMain.NomIndi:=FieldByName('NOM').AsString;
          FMain.PrenomIndi:=FieldByName('PRENOM').AsString;
          FMain.IndiTrieNom:=IndiTrieNom;
          FMain.NomIndiComplet:=NomIndiComplet;

          if FieldByName('CLE_FIXE').AsInteger=0 then
          begin
            Edit;
            FieldByName('CLE_FIXE').AsInteger:=fCleFiche;
            dm.doActiveTriggerMajDate(false);
            Post;
            dm.doActiveTriggerMajDate(true);
            dm.IBT_base.CommitRetaining;
          end;

          if FieldByName('AvecPatronyme').AsInteger=1 then
          begin
            btnPatronyme.Glyph.assign ( iPatronyme.Picture );
            btnPatronyme.Hint:=rs_Hint_Surnames_associated_to_this_person;
          end
          else
          begin
            btnPatronyme.Glyph.assign ( iIndi.Picture );
            btnPatronyme.Hint:=rs_Hint_Associate_surnames_to_this_person;
          end;

          FMain.dxStatusBar.Panels[0].Text:='NIP '+FieldByName('CLE_FICHE').AsString;

          s_Chaine:='Fiche';
          if Length(FieldByName('DATE_CREATION').AsString)>0 then
            s_Chaine:=s_Chaine+' créée le '+FormatDateTime('dd/mm/yyyy',FieldByName('DATE_CREATION').AsDateTime);
          if Length(FieldByName('DATE_MODIF').AsString)>0 then
            s_Chaine:=s_Chaine+', modifiée le '+FormatDateTime('dd/mm/yyyy à hh:mm',
              FieldByName('DATE_MODIF').AsDateTime);
          FMain.dxStatusBar.Panels[1].Text:=s_Chaine;
        end;
        result:=true;
        btnTemoinDe.Enabled:=FieldByName('TEMOIN').AsInteger=1;
      end;
    finally
      EnableControls;
    end;
    doCompteOnglets;
    doLoadQuisontils;
    if fOngletFormIncrusted<>_ONGLET_IDENTITE then //AL2009
      aFIndividuIdentite.aFIndividuEditEventLife.Hide;
  finally
    bOpen:=True;
    PageControlIndividu.EnableAlign;
    EnableAlign;
  end;
end;

procedure TFIndividu.doActiveOnglet(const onglet:integer);
begin
  if (not fFill.Value) then
  begin
    fFill.Value:=true;
    try
        //on regarde si les données sont chargées dans l'onglet appelé
      case onglet of
        _ONGLET_SAVIE:
          begin
            // Sa vie
            if aFIndividuSavie = nil Then
             Begin
              aFIndividuSavie:=TFSaVie.Create(self);
              aFIndividuSaVie.ShowIncrust(PanelSaVie);
              RefreshNomIndividuSaVie;
             end;
            if fOngletSaVieIsLoaded=false then
              fOngletSaVieIsLoaded:=aFIndividuSaVie.doOpenQuerys;
            btnPrint.Hint:=rs_Hint_Print_upside_tree;
          end;
        _ONGLET_ACTES:
          begin
            // Actes
            if aFIndividuActes = nil Then
             Begin
              aFIndividuActes:=TFActesListe.Create(self);
              aFIndividuActes.ShowIncrust(PanelActes);
              RefreshNomIndividuActes;
             end;
            if fOngletActesIsLoaded=false then
              fOngletActesIsLoaded:=aFIndividuActes.doOpenQuerys;
            btnPrint.Hint:=rs_Hint_Print_upside_Acts_list;
          end;
        _ONGLET_IDENTITE:
          begin
            if fOngletIdentiteIsLoaded=false then
              fOngletIdentiteIsLoaded:=aFIndividuIdentite.doOpenQuerys;
            aFIndividuIdentite.DoRefreshControls;
          end;
        _ONGLET_SES_CONJOINTS:
          begin
            // Matthieu refaire
           if aFIndividuUnion = nil Then
            Begin
             aFIndividuUnion:=TFIndividuUnion.create(self);
             aFIndividuUnion.ShowIncrust(PanelUnions);
             SetDialogModeUnions(fDialogMode);
             aFIndividuUnion.doInitialize;
             RefreshNomIndividuUnion;
            end;
            if fOngletSesConjointsIsLoaded=false then
              fOngletSesConjointsIsLoaded:=aFIndividuUnion.doOpenQuerys(true);
            aFIndividuUnion.DoRefreshControls;
          end;
        _ONGLET_ARBRE:
          begin
            //l'arbre
            if aFIndividuArbre = nil Then
             Begin
              aFIndividuArbre:=TFArbre.create(self);
              aFIndividuArbre.ShowIncrust(PanelArbre);
              RefreshNomIndividuArbre;
             end;
            if not fOngletArbreIsLoaded then
            begin
              fOngletArbreIsLoaded:=true;
              aFIndividuArbre.Init_arbre;
              aFIndividuArbre.Refresh_arbre;
            end;
            btnPrint.Hint:=rs_Hint_Print_upside_tree;
          end;
        _ONGLET_PHOTOS_DOCS:
          begin
            //Photos et Docs
            if aFIndividuPhotosEtDocs = nil Then
             Begin
              aFIndividuPhotosEtDocs:=TFIndividuPhotosEtDocs.create(self);
              aFIndividuPhotosEtDocs.ShowIncrust(PanelMedias);
              SetDialogModePhotos(fDialogMode);
              aFIndividuPhotosEtDocs.doInitialize;
              RefreshNomIndividuPhotos;
             end;
            if fOngletPhotosDocsIsLoaded=false then
              fOngletPhotosDocsIsLoaded:=aFIndividuPhotosEtDocs.doOpenQuerys;
            aFIndividuPhotosEtDocs.DoRefreshControls;
          end;
        _ONGLET_OBSERVATIONS:
          begin
            //Observations
            if aFIndividuObservations = nil Then
             Begin
              aFIndividuObservations:=TFIndividuObservations.create(self);
              aFIndividuObservations.ShowIncrust(PanelInfos);
              RefreshNomIndividuObservations;
             end;
            fOngletObservationsIsLoaded:=true;
            aFIndividuObservations.DoRefreshControls;
          end;
        _ONGLET_DOMICILES:
          begin
            //Domiciles
            if aFIndividuDomiciles = nil Then
             Begin
              aFIndividuDomiciles:=TFIndividuDomiciles.Create(self);
              aFIndividuDomiciles.ShowIncrust(PanelDomiciles);
              SetDialogModeDomiciles(fDialogMode);
              aFIndividuDomiciles.doInitialize;
              RefreshNomIndividuDomiciles;
             end;
            if fOngletDomicilesIsLoaded=false then
              fOngletDomicilesIsLoaded:=aFIndividuDomiciles.doOpenQuerys;
            aFIndividuDomiciles.DoRefreshControls;
            btnPrint.Hint:=rs_Hint_Print_upside_homes_list;
          end;
      end;
        //on montre l'onglet
      if PageControlIndividu.ActivePageIndex<>onglet then
        PageControlIndividu.ActivePageIndex:=onglet;
      fOngletFormIncrusted:=onglet;
      btnPrint.Visible:=onglet in [_ONGLET_ARBRE,_ONGLET_ACTES,_ONGLET_DOMICILES,_ONGLET_SAVIE];

      bsfbSupprimer.Enabled:=(fCleFiche>0)and
        (onglet in [_ONGLET_IDENTITE,_ONGLET_ARBRE,_ONGLET_OBSERVATIONS,_ONGLET_ACTES,_ONGLET_SAVIE]);

      if Assigned(_FormHistoire) then//on rafraichit l'histoire
      begin
        case onglet of
          _ONGLET_IDENTITE:
            _FormHistoire.doPosition(aFIndividuIdentite.IBQEveEV_IND_CLEF.AsInteger,0);
          _ONGLET_SES_CONJOINTS:
            _FormHistoire.doPosition(aFIndividuUnion.IBQEveEV_FAM_CLEF.AsInteger,1);
        end;
      end;
    finally
      fFill.Value:=false;
    end;
  end;
//  RefreshNomIndividu; fait dans OpenQuery et mis à jour en cas de changement
end;

function TFIndividu.VerifyCanCloseFiche:boolean;
var
  rep:word;
begin
  result:=true;
  if TestFicheIsModified then
  begin
    if gci_context.ValidationAutomatique then
    begin
      if DoAppliquer=mrCancel then
        result:=false;
    end
    else
    begin
      rep:=MyMessageDlg(rs_Person_file_has_been_modified+_CRLF+_CRLF+
        rs_Do_you_save_the_changes,mtConfirmation, [mbYes,mbNo,mbCancel],FMain);
      case rep of
        mrYes:if DoAppliquer=mrCancel then
            result:=false;
        mrNo:DoAnnuler;
        else
          result:=false;
      end;
    end;
  end;
end;

procedure TFIndividu.SetPaysVilles(const CountriesToSet,CitiesToSet: TDataSource);
Begin
  if dm.IBBaseParam.Connected Then
   Begin
    CountriesToSet.DataSet:=IBQCountries;
    CitiesToSet.DataSet:=IBCities;
   end;
end;

procedure TFIndividu.SetDialogModePhotos(const Value:boolean);
begin
  if aFIndividuPhotosEtDocs = nil Then Exit;

  aFIndividuPhotosEtDocs.btnAjout.visible:=not Value;
  aFIndividuPhotosEtDocs.btnDel.visible:=not Value;

end;

procedure TFIndividu.SetDialogModeDomiciles(const Value:boolean);
begin
  if aFIndividuDomiciles = nil Then Exit;

  aFIndividuDomiciles.btnVillesFavoris.visible:=not Value;
  aFIndividuDomiciles.fbInfosVilles.visible:=not Value;
end;

procedure TFIndividu.SetDialogModeUnions(const Value:boolean);
begin
  if aFIndividuUnion = nil Then Exit;

  // aFIndividuDomiciles.fbCalend.visible:=not Value;
  aFIndividuUnion.bsfbAjout.Enabled:=not Value;
  aFIndividuUnion.bsfbRetirer.Enabled:=not Value;
  aFIndividuUnion.btnAddEvent.Enabled:=not Value;
  aFIndividuUnion.btnDelEvent.Enabled:=not Value;
  aFIndividuUnion.mRemplacerConjoint.visible:=not Value;
end;

procedure TFIndividu.SetDialogMode(const Value:boolean);
  var
    RectMonitor:TRect;
begin
  fDialogMode:=Value;
  bsfbNouveau.visible:=not Value;
  bsfbSupprimer.visible:=not Value;
  bsfbAppliquer.visible:=not Value;
  bsfbAnnuler.visible:=not Value;

  btnFermer.visible:=Value;
  btnNaviguer.visible:=not Value;
  btnPrecedent.visible:=not Value;
  btnSuivant.visible:=not Value;
  btValidAuto.visible:=not Value;
  btnPatronyme.Visible:=not Value;

  aFIndividuIdentite.btnAjoutPere.visible:=not Value;
  aFIndividuIdentite.fsbDelPere.visible:=not Value;
  aFIndividuIdentite.fsbDelMere.visible:=not Value;
  aFIndividuIdentite.btnAjoutMere.visible:=not Value;
  aFIndividuIdentite.btnAjoutEnfant.visible:=not Value;
  aFIndividuIdentite.mAjouterEnfant.visible:=not Value;
  aFIndividuIdentite.btnRetirerEnfant.visible:=not Value;
  aFIndividuIdentite.btnAjoutConjoint.visible:=not Value;
  aFIndividuIdentite.mAjouterConjoint.visible:=not Value;
  aFIndividuIdentite.btnRetirerConjoint.visible:=not Value;
  aFIndividuIdentite.mRemplacerConjoint.visible:=not Value;
  aFIndividuIdentite.mSupprimerlelien.visible:=not Value;
  aFIndividuIdentite.mSupprimerOrdre.visible:=not Value;
  aFIndividuIdentite.btnNewEvent.visible:=not Value;
  aFIndividuIdentite.btnDeleteEvent.visible:=not Value;
  aFIndividuIdentite.btnNaissance.visible:=not Value;
  aFIndividuIdentite.btnDeces.visible:=not Value;
  aFIndividuIdentite.btnProfession.visible:=not Value;
  SetDialogModePhotos( Value );
  SetDialogModeDomiciles( Value );
  SetDialogModeUnions( Value );

  if Value and bFirstTime then
  begin
    Caption:=rs_Caption_Person_s_file_in_consult_mode;
    pBtn.Left:=bsfbNouveau.Left;
    btnChercheNIP.Hide;
    ClientHeight:=FMain.panDock.Height;
    ClientWidth:=FMain.panDock.Width;
    if bModale then
    begin
      CentreLaFiche(self,FMain);
    end
    else
    begin
      Position:=poDesigned;
      RectMonitor:=FMain.Monitor.WorkareaRect;
      Top:=(RectMonitor.Bottom+RectMonitor.Top-Height)div 2;
      Left:=(RectMonitor.Right+RectMonitor.Left-Width)div 2;
    end;
  end;
  if Value then
  Begin
    aFIndividuIdentite.lbNomPere.Hint:=fs_RemplaceMsg(rs_Hint_Every_changes_are_executed_in_form_with_key_maj, [rs_main]);
    aFIndividuIdentite.lbNomMere.Hint:=fs_RemplaceMsg(rs_Hint_Every_changes_are_executed_in_form_with_key_maj, [rs_main]);
  end
  else
   Begin
     aFIndividuIdentite.lbNomPere.Hint:=fs_RemplaceMsg(rs_Hint_Every_changes_are_executed_in_form_with_key_maj, [rs_readonly_only]);
     aFIndividuIdentite.lbNomMere.Hint:=fs_RemplaceMsg(rs_Hint_Every_changes_are_executed_in_form_with_key_maj, [rs_readonly_only]);
   end;
end;

procedure TFIndividu.btnNaviguerClick(Sender:TObject);
var
  p:TPoint;
begin
  if not Assigned(_FormNavigation) then
  begin
    _FormNavigation:=TFIndividuNavigation.create(FMain);
  end;
  if _FormNavigation.visible=false then
  begin
    if _FormNavigation.FirstShow then
      if FMain.NavigationLeft=10000 then
      begin
        p.x:=panTop.width;
        p.y:=panTop.Height;
        p:=panTop.clienttoscreen(p);
        _FormNavigation.left:=p.x-_FormNavigation.Width;
        _FormNavigation.top:=p.y;
      end;
    _FormNavigation.Show;
  end;
  _FormNavigation.doInitialize(fCleFiche);
  _FormNavigation.SetFocus;
end;

procedure TFIndividu.bsfbNouveauClick(Sender:TObject);
begin
  DoNouvelleFiche;
end;

procedure TFIndividu.DoNouvelleFiche;
begin
  if VerifyCanCloseFiche then
  begin
    fCleFiche:=-1;
    bNew:=True;
      //par sécurité, on ferme les query
    QueryIndividu.DisableControls;
    try
      doInitialize;
      fCoherenceDate.Reset;
      doChangeRequete;
      QueryIndividu.Open;
      QueryIndividu.Insert;
      QueryIndividu.Post;//AL2010
      dm.individu_clef:=QueryIndividuCLE_FICHE.AsInteger;
    finally
      QueryIndividu.EnableControls;
    end;
    dm.DoUpdateDLL;
    RefreshNomIndividu;
      //On se place sur l'onglet "identité"
    doActiveOnglet(_ONGLET_IDENTITE);
    aFIndividuIdentite.pIdentiteReduite.Hide;
    aFIndividuIdentite.pIdentiteComplete.Show;
    if aFIndividuIdentite.sDBENom.CanFocus then
      aFIndividuIdentite.sDBENom.SetFocus;
    aFIndividuIdentite.sDBENom.Font.Color:=clWindowText;
    aFIndividuIdentite.sDBEPrenom.Font.Color:=clWindowText;
    aFIndividuIdentite.lbNomPere.Font.Color:=gci_context.ColorHomme;
    aFIndividuIdentite.lbNomMere.Font.Color:=gci_context.ColorFemme;
    aFIndividuIdentite.lSang.Visible:=false;
    aFIndividuIdentite.lSang.Caption:='';
    doEnableObjets(true);//AL2010
    InitOnglets;
    doBouton(true);
  end
  else
    DoRefreshControls;
end;

function TFIndividu.TestFicheIsModified:boolean;
begin
  result:=fModified;//quel manque de rigueur! on est incapable de distinguer si c'est Individu qui a été modifié ou un média ou autre!
  if result=false then
  begin
    if QueryIndividu.State in [dsEdit,dsInsert] then
      result:=true;
  end;
end;

procedure TFIndividu.bsfbAppliquerClick(Sender:TObject);
var
  bRecal,bDetail_ev_ind:boolean;
  i,iNumLigne,iLigne:integer;
  ANode : PVirtualNode;
begin
  bDetail_ev_ind:=fTemporisation;
  bNew:=False;
  bRecal:=false;
  iNumLigne:=0;
  iLigne:=-1;
  case fOngletFormIncrusted of
    _ONGLET_IDENTITE:
      begin
        if not aFIndividuIdentite.IBQEve.IsEmpty then
        begin
          iNumLigne:=aFIndividuIdentite.IBQEveEV_IND_CLEF.AsInteger;
          bRecal:=true;
        end;
        with aFIndividuIdentite.tvConjEnfants do
        if FocusedNode<>nil then
        begin
          iLigne:=PNodeIndividu(GetNodeData(FocusedNode))^.fCleFiche;
          bRecal:=true;
        end;
      end;

    _ONGLET_SES_CONJOINTS:
      with aFIndividuUnion.TreeConj do
      if FocusedNode<>nil then
      begin
        bRecal:=true;
        iLigne:=PNodeIndividu(GetNodeData(FocusedNode))^.fCleFiche;
        if not aFIndividuUnion.IBQEve.IsEmpty then
          iNumLigne:=aFIndividuUnion.IBQEveEV_FAM_CLEF.AsInteger;
      end;

    _ONGLET_PHOTOS_DOCS:
      begin
        if not aFIndividuPhotosEtDocs.IBMultimedia.IsEmpty then
        begin
          iNumLigne:=aFIndividuPhotosEtDocs.IBMultimediaMP_CLEF.AsInteger;
          bRecal:=true;
        end;
      end;

    _ONGLET_DOMICILES:
      begin
        if not aFIndividuDomiciles.IBQEve.IsEmpty then
        begin
          iNumLigne:=aFIndividuDomiciles.IBQEveEV_IND_CLEF.AsInteger;
          bRecal:=true;
        end;
      end;
  end;

  DoAppliquer(true);
  doOpenFiche(fCleFiche);//AL2010

  if bRecal then
  begin
    case fOngletFormIncrusted of
      _ONGLET_IDENTITE:
        begin
          if iNumLigne>0 then
          begin
            aFIndividuIdentite.IBQEve.DisableControls;
            aFIndividuIdentite.IBQEve.Locate('EV_IND_CLEF',iNumLigne, []);
            aFIndividuIdentite.IBQEve.EnableControls;
          end;
          if iLigne>-1 then
          begin
            with aFIndividuIdentite do
              fb_FocusNode(tvConjEnfants,tvConjEnfants.RootNode,iLigne);
          end;
        end;

      _ONGLET_SES_CONJOINTS:
        begin
          with aFIndividuUnion do
            fb_FocusNode(TreeConj,TreeConj.RootNode,iLigne);
        end;

      _ONGLET_PHOTOS_DOCS:
        aFIndividuPhotosEtDocs.doGoto(iNumLigne);

      _ONGLET_DOMICILES:
        begin
          aFIndividuDomiciles.doGoto(iNumLigne);
          aFIndividuDomiciles.doChangeNode(aFIndividuDomiciles.tvAdr);
        end;
    end;
  end;
  if bDetail_ev_ind then
    if Assigned(aFIndividuIdentite.aFIndividuEditEventLife) then
      if aFIndividuIdentite.aFIndividuEditEventLife.Visible then
        aFIndividuIdentite.aFIndividuEditEventLife.Show;
end;

function TFIndividu.DoAppliquer(const bCommit:boolean=true):word;//AL 2009
begin
  result:=mrOk;
  if (trim(QueryIndividuNOM.AsString)>'') then
  begin
    bOpen:=false;
    try
      if not(QueryIndividu.State in [dsEdit,dsInsert]) then
        QueryIndividu.Edit;
      QueryIndividuMODIF_PAR_QUI.AsString:=Copy(dm.Computer+':'+dm.UserName,1,30);
      try
        QueryIndividu.Post;
      except
        on E:EIBError do
          showmessage('Impossible de mettre à jour la fiche - '+E.Message);
      end;

      aFIndividuIdentite.RefreshTitle;//pourquoi faire çà ici?

      //On post les Evénements
      if (aFIndividuIdentite.IBQEve.State in [dsEdit,dsInsert]) then
        aFIndividuIdentite.IBQEve.Post;
      if (aFIndividuIdentite.aFIndividuEditEventLife.IBTemoins.State in [dsEdit,dsInsert]) then
        aFIndividuIdentite.aFIndividuEditEventLife.IBTemoins.Post;
      if (aFIndividuIdentite.aFIndividuEditEventLife.IBMedias.State in [dsEdit,dsInsert]) then
        aFIndividuIdentite.aFIndividuEditEventLife.IBMedias.Post;

      // Domiciles
      if assigned ( aFIndividuDomiciles) Then
       Begin
        if (aFIndividuDomiciles.IBQEve.State in [dsEdit,dsInsert]) then
         begin
          aFIndividuDomiciles.IBQEve.Post;
          aFIndividuDomiciles.doRempliTV;
         end;
        if (aFIndividuDomiciles.IBMedias.State in [dsEdit,dsInsert]) then
          aFIndividuDomiciles.IBMedias.Post;
       end;

      //Unions
      if Assigned(aFIndividuUnion) Then
       Begin
        if (aFIndividuUnion.IBQEve.State in [dsEdit,dsInsert]) then
          aFIndividuUnion.IBQEve.Post;
        if (aFIndividuUnion.IBTemoins.State in [dsEdit,dsInsert]) then
          aFIndividuUnion.IBTemoins.Post;
        if (aFIndividuUnion.IBMedias.State in [dsEdit,dsInsert]) then
          aFIndividuUnion.IBMedias.Post;
        if (aFIndividuUnion.QSourcesNotesUnion.Active) then
          if (aFIndividuUnion.QSourcesNotesUnion.State in [dsEdit,dsInsert]) then
            aFIndividuUnion.QSourcesNotesUnion.Post;
       end;

      //photos et docs
      if Assigned(aFIndividuPhotosEtDocs)
      and (aFIndividuPhotosEtDocs.IBMultimedia.State in [dsEdit,dsInsert]) then
        aFIndividuPhotosEtDocs.IBMultimedia.Post;

    finally
      //rafraichissement
      bOpen:=true;//pour autoriser le rafraîchissement
    end;

    //mise à jour des infos de la fiche dans la liste des fiches visitées
    dm.AddFicheOpen(fCleFiche,QueryIndividuSEXE.AsInteger,NomIndiComplet);

    if bCommit then
    begin
      doBouton(False);
      dm.individu_clef:=fCleFiche;
      try
        dm.IBT_base.CommitRetaining;
      except
        on E:EIBError do
          showmessage('Impossible de mettre à jour la fiche - '+E.Message);
      end;
    end
    else
    begin
      doEnableObjets(True);//AL2010 rafraîchissement partiel
      DoRefreshControls;//AL2010
      doCompteOnglets;//AL2010
    end;
  end
  else
  begin
    if (QueryIndividu.Active) then
    begin
      MyMessageDlg(rs_Error_please_set_a_name,mtError, [mbOk],FMain);
      dm.individu_clef:=fCleFiche;
      result:=mrCancel;
    end;
  end;
end;

procedure TFIndividu.bsfbAnnulerClick(Sender:TObject);
begin
  bNew:=False;
  DoAnnuler;
  doBouton(False);
end;

procedure TFIndividu.DoAnnuler;
begin
  doEnableObjets(True);
  //on annule tout ce qu'on a fait
  doInitialize;
  aFIndividuIdentite.bOpen:=false;
  aFIndividuIdentite.aFIndividuEditEventLife.Hide;
  try
    //Annulation de tout ce que l'utilisateur a fait dans la base depuis l'ouverture ou le dernier commit
    dm.IBT_base.RollbackRetaining;
    fModified:=false;
    //Réinitialisation de la fiche
    doOpenFiche(fCleFiche);
  finally
    aFIndividuIdentite.bOpen:=True;
  end;
end;

procedure TFIndividu.bsfbSupprimerClick(Sender:TObject);
begin
  if MyMessageDlg(
    rs_Confirm_deleting_every_events_and_other+_CRLF+_CRLF+
    rs_Confirm_deleting_selected_person_file,mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
  begin//suppression de l'individu
    DoAppliquer(false);
    dm.SupprimeFicheOpen(fCleFiche);
    QueryIndividu.Delete;
    //commit de tout ce qui a été modifié
    dm.IBT_base.CommitRetaining;
    doEnableObjets(True);
    doBouton(false);
    doOpenFiche(dm.IndiPrecedent);
    DoRefreshControls;
    FMain.RefreshFavoris;
  end;
end;

procedure TFIndividu.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  if (key=VK_ESCAPE) and fDialogMode then
    Close;
end;

procedure TFIndividu.SuperFormRefreshControls(Sender:TObject);
begin
  if not bOpen then
    exit;

  //dans quelle état est la fiche ?
  if fCleFiche=-1 then
  begin
    btnNaviguer.enabled:=false;
//    bsfbNouveau.enabled:=true;
    //bsfbSupprimer.enabled:=false;
    bsfbAppliquer.enabled:=false;
    bsfbAnnuler.enabled:=false;
    btnPbCoherence.visible:=false;
  end
  else
  begin
    fModified:=TestFicheIsModified and not fDialogMode;//fModified et TestFicheIsModified se mordent la queue
    btnNaviguer.enabled:=true; //déjà invisibles par SetDialogMode
//    bsfbNouveau.enabled:=true; //toujours!
    //bsfbSupprimer.enabled:=true;//fait dans doActiveOnglet
    doBouton(fModified);
  end;

  btnPrecedent.enabled:=(dm.FicheOpenIndex>0)and(dm.FicheOpenIndex<dm.ListFicheOpenInfos.Count);
  btnSuivant.enabled:=(dm.FicheOpenIndex>=0)and(dm.FicheOpenIndex<dm.ListFicheOpenInfos.Count-1);

  if not fDialogMode then
    FMain.option_RenumerotationSOSA.enabled:=not bsfbAppliquer.enabled;

  doActiveOnglet(fOngletFormIncrusted);//met à jour l'onglet affiché
end;

procedure TFIndividu.RefreshNomIndividuUnion ( const AColor : TColor );
begin
  if aFIndividuUnion=nil
   Then Exit;
  aFIndividuUnion.lNom.Font.Color:=AColor;
  aFIndividuUnion.lNom.Caption:=CoupeChaine(NomIndiComplet,aFIndividuUnion.lNom);
end;

procedure TFIndividu.RefreshNomIndividuDomiciles ( const AColor : TColor );
begin
  if aFIndividuDomiciles=nil
   Then Exit;
  aFIndividuDomiciles.lNom.Font.Color:=AColor;
  aFIndividuDomiciles.lNom.Caption:=CoupeChaine(NomIndiComplet,aFIndividuDomiciles.lNom);
end;

procedure TFIndividu.RefreshNomIndividuObservations ( const AColor : TColor );
begin
  if aFIndividuObservations=nil
   Then Exit;
  aFIndividuObservations.lNom.Font.Color:=AColor;
  aFIndividuObservations.lNom.Caption:=CoupeChaine(NomIndiComplet,aFIndividuObservations.lNom);
end;

procedure TFIndividu.RefreshNomIndividuPhotos ( const AColor : TColor );
begin
  if aFIndividuPhotosEtDocs=nil
   Then Exit;
  aFIndividuPhotosEtDocs.lNom.Font.Color:=AColor;
  aFIndividuPhotosEtDocs.lNom.Caption:=CoupeChaine(NomIndiComplet,aFIndividuPhotosEtDocs.lNom);
end;

procedure TFIndividu.RefreshNomIndividuArbre ( const AColor : TColor );
begin
  if aFIndividuArbre=nil
   Then Exit;
  aFIndividuArbre.lNom.Font.Color:=AColor;
  aFIndividuArbre.lNom.Caption:=CoupeChaine(NomIndiComplet,aFIndividuArbre.lNom);
end;

procedure TFIndividu.RefreshNomIndividuActes ( const AColor : TColor );
begin
  if aFIndividuActes=nil
   Then Exit;
  aFIndividuActes.lNom.Font.Color:=AColor;
  aFIndividuActes.lNom.Caption:=CoupeChaine(NomIndiComplet,aFIndividuActes.lNom);
end;

procedure TFIndividu.RefreshNomIndividuSaVie ( const AColor : TColor );
begin
  if aFIndividuSavie=nil
   Then Exit;
  aFIndividuSavie.lNom.Font.Color:=AColor;
  aFIndividuSavie.lNom.Caption:=CoupeChaine(NomIndiComplet,aFIndividuSavie.lNom);
end;

procedure TFIndividu.RefreshNomIndividuUnion;
begin
  case QueryIndividuSEXE.AsInteger of
    1: RefreshNomIndividuUnion  (gci_context.ColorHomme);
    2: RefreshNomIndividuUnion  (gci_context.ColorFemme);
    else  RefreshNomIndividuUnion  (clWindowText);
  end;
end;

procedure TFIndividu.RefreshNomIndividuDomiciles;
begin
  case QueryIndividuSEXE.AsInteger of
    1: RefreshNomIndividuDomiciles  (gci_context.ColorHomme);
    2: RefreshNomIndividuDomiciles  (gci_context.ColorFemme);
    else RefreshNomIndividuDomiciles  (clWindowText);
  end;
end;

procedure TFIndividu.RefreshNomIndividuObservations;
begin
  case QueryIndividuSEXE.AsInteger of
    1:  RefreshNomIndividuObservations  (gci_context.ColorHomme);
    2:  RefreshNomIndividuObservations  (gci_context.ColorFemme);
    else RefreshNomIndividuObservations  (clWindowText);
  end;
end;

procedure TFIndividu.RefreshNomIndividuPhotos;
begin
  case QueryIndividuSEXE.AsInteger of
    1:  RefreshNomIndividuPhotos  (gci_context.ColorHomme);
    2:  RefreshNomIndividuPhotos  (gci_context.ColorFemme);
    else RefreshNomIndividuPhotos  (clWindowText);
  end;
end;

procedure TFIndividu.RefreshNomIndividuArbre;
begin
  case QueryIndividuSEXE.AsInteger of
    1:  RefreshNomIndividuArbre  (gci_context.ColorHomme);
    2:  RefreshNomIndividuArbre  (gci_context.ColorFemme);
    else RefreshNomIndividuArbre  (clWindowText);
  end;
end;

procedure TFIndividu.RefreshNomIndividuActes;
begin
  case QueryIndividuSEXE.AsInteger of
    1: RefreshNomIndividuActes  (gci_context.ColorHomme);
    2: RefreshNomIndividuActes  (gci_context.ColorFemme);
    else RefreshNomIndividuActes  (clWindowText);
  end;
end;

procedure TFIndividu.RefreshNomIndividuSaVie;
begin
  case QueryIndividuSEXE.AsInteger of
    1:  RefreshNomIndividuSaVie  (gci_context.ColorHomme);
    2:  RefreshNomIndividuSaVie  (gci_context.ColorFemme);
    else RefreshNomIndividuSaVie  (clWindowText);
  end;
end;

procedure TFIndividu.RefreshNomIndividu;
begin
  NomIndiComplet:=GetNomIndividu+GetStringNaissanceDeces(sAnneeNaissance,sAnneeDeces);
  with gci_context do
  case QueryIndividuSEXE.AsInteger of
    1:
      begin
        RefreshNomIndividuUnion  (ColorHomme);
        RefreshNomIndividuArbre  (ColorHomme);
        RefreshNomIndividuPhotos (ColorHomme);
        RefreshNomIndividuSaVie  (ColorHomme);
        RefreshNomIndividuActes  (ColorHomme);
        RefreshNomIndividuDomiciles  (ColorHomme);
        RefreshNomIndividuObservations (ColorHomme);
      end;
    2:
      begin
        RefreshNomIndividuUnion  (ColorFemme);
        RefreshNomIndividuArbre  (ColorFemme);
        RefreshNomIndividuPhotos (ColorFemme);
        RefreshNomIndividuSaVie  (ColorFemme);
        RefreshNomIndividuActes  (ColorFemme);
        RefreshNomIndividuDomiciles  (ColorFemme);
        RefreshNomIndividuObservations (ColorFemme);
      end;
    else
      begin
        RefreshNomIndividuUnion  (clWindowText);
        RefreshNomIndividuArbre  (clWindowText);
        RefreshNomIndividuPhotos (clWindowText);
        RefreshNomIndividuSaVie  (clWindowText);
        RefreshNomIndividuActes  (clWindowText);
        RefreshNomIndividuDomiciles  (clWindowText);
        RefreshNomIndividuObservations (clWindowText);
      end;
  end;
end;

procedure TFIndividu.QueryIndividuNewRecord(DataSet:TDataSet);
begin
  fCleFiche:=dm.uf_GetClefUnique('INDIVIDU');
  QueryIndividuCLE_FICHE.AsInteger:=fCleFiche;
  QueryIndividuNOM.AsString:=gci_context.NomDefaut;//AL2010
  QueryIndividuCLE_FIXE.AsInteger:=fCleFiche;
  QueryIndividuSEXE.AsInteger:=0;
  QueryIndividuKLE_DOSSIER.AsInteger:=dm.NumDossier;
  QueryIndividutype_lien_gene.Clear;
  IndiTrieNom:=fs_FormatText(gci_context.NomDefaut,mftUpper,True);//MG 2014
  sDateNaissance:='';
  bJourNaissance:=false;
  sDateDeces:='';
  bJourDeces:=false;
  sAnneeNaissance:='';
  AnneeNaissance:=_AnMini;
  sAnneeDeces:='';
  sVilleNaissance:='';
  sVilleDeces:='';
  FMain.dxStatusBar.Panels[1].Text:='';
end;

procedure TFIndividu.btnNouvelleFicheClick(Sender:TObject);
begin
  panNobody.visible:=false;
  PageControlIndividu.Visible:=true;
  panTop.Visible:=true;
  DoNouvelleFiche;
end;

procedure TFIndividu.ForceCloseAllQuerys;
begin
  doInitialize;
end;

procedure TFIndividu.SuperFormShowFirstTime(Sender:TObject);
begin
  bFirstTime:=false;
{  if DialogMode then
    CentreLaFiche(aFCoherence,self)
  else
    CentreLaFiche(aFCoherence,FMain);}
  if aFCoherence.Visible then
    aFCoherence.BringToFront;
end;

procedure TFIndividu.btnImportGedcomClick(Sender:TObject);
begin
  DefaultCloseAction:=caFree;
  DoSendMessage(Owner,'OPEN_IMPORT_GEDCOM_FROM_FICHE_INDIVIDU');
  FMain.aFIndividu:=nil;
  Close;
end;

procedure TFIndividu.SuperFormShow(Sender:TObject);
begin
//  RefreshPhoto;
  DoRefreshControls;
end;

procedure TFIndividu.btnFermerClick(Sender:TObject);
begin
  Close;
end;

procedure TFIndividu.popup_PrecedentPopup(Sender:TObject);
var
  n:integer;
  item:TMenuItem;
  aFicheOpenInfo:TFicheOpenInfo;
begin
  popup_Precedent.Items.Clear;
  if (dm.FicheOpenIndex>=0)and(dm.FicheOpenIndex<dm.ListFicheOpenInfos.Count) then
  begin
    for n:=dm.FicheOpenIndex-1 downto 0 do
    begin
      aFicheOpenInfo:=TFicheOpenInfo(dm.ListFicheOpenInfos[n]);
      item:=TMenuItem.create(self);
      item.caption:=aFicheOpenInfo.TitreNomPrenom;
      case aFicheOpenInfo.Sexe of
        1:item.ImageIndex:=1;
        2:item.ImageIndex:=0;
        else
          item.ImageIndex:=2;
      end;
      item.Tag:=n;
      item.OnClick:=OnSelectIndividuInListPrevious;
      popup_Precedent.items.add(item);
    end;
  end;
end;

procedure TFIndividu.OnSelectIndividuInListPrevious(Sender:TObject);
begin
  doGoToFiche(TMenuItem(Sender).Tag,0);
end;

procedure TFIndividu.OnSelectIndividuInListNext(Sender:TObject);
begin
  doGoToFiche(TMenuItem(Sender).Tag,1);
end;

procedure TFIndividu.doGoToFiche(aIndexCleFicheInList,sens:integer);
var
  Ok:boolean;
begin
  dm.CanAddFicheOpenInList:=false;
  try
    if VerifyCanCloseFiche then
    begin
      repeat
        ok:=true;
        if (aIndexCleFicheInList>=0)and(aIndexCleFicheInList<dm.ListFicheOpenInfos.Count) then
        begin
          if doOpenFiche(TFicheOpenInfo(dm.ListFicheOpenInfos[aIndexCleFicheInList]).CleFiche) then
            dm.FicheOpenIndex:=aIndexCleFicheInList
          else
          begin
            if Sens=0 then
            begin
              if aIndexCleFicheInList>0 then
              begin
                dec(aIndexCleFicheInList);
                ok:=false;
              end;
            end
            else
            begin
              if aIndexCleFicheInList<dm.ListFicheOpenInfos.Count-1 then
              begin
                inc(aIndexCleFicheInList);
                ok:=false;
              end;
            end;
          end;
        end;
      until (Ok=true);
    end;
  finally
    dm.CanAddFicheOpenInList:=true;
  end;
  doRefreshControls;
end;

procedure TFIndividu.btnPrecedentClick(Sender:TObject);
var
  k:integer;
begin
  k:=dm.FicheOpenIndex-1;
  if (k>=0)and(k<dm.ListFicheOpenInfos.Count) then doGoToFiche(k,0);
end;

procedure TFIndividu.popup_SuivantPopup(Sender:TObject);
var
  n:integer;
  item:TMenuItem;
  aFicheOpenInfo:TFicheOpenInfo;
begin
  popup_Suivant.Items.Clear;
  if (dm.FicheOpenIndex>=0)and(dm.FicheOpenIndex<dm.ListFicheOpenInfos.Count) then
  begin
    for n:=dm.FicheOpenIndex+1 to dm.ListFicheOpenInfos.Count-1 do
    begin
      aFicheOpenInfo:=TFicheOpenInfo(dm.ListFicheOpenInfos[n]);
      item:=TMenuItem.create(self);
      item.caption:=aFicheOpenInfo.TitreNomPrenom;
      case aFicheOpenInfo.Sexe of
        1:item.ImageIndex:=1;
        2:item.ImageIndex:=0;
        else
          item.ImageIndex:=2;
      end;
      item.Tag:=n;
      item.OnClick:=OnSelectIndividuInListNext;
      popup_Suivant.items.add(item);
    end;
  end;
end;

procedure TFIndividu.btnSuivantClick(Sender:TObject);
var
  k:integer;
begin
  k:=dm.FicheOpenIndex+1;
  if (k>=0)and(k<dm.ListFicheOpenInfos.Count) then doGoToFiche(k,1);
end;

procedure TFIndividu.LoadCoherenceDates;
var
  s:string;
begin
  fCoherenceDate.Reset;
  if gci_context.CoherenceActive then
  with QueryGetDatesInd do
  begin
    fCoherenceDate.Sexe:=QueryIndividuSEXE.AsInteger;
    Close;
    try
      ParamByName('i_clef').AsInteger:=fCleFiche;
      ExecQuery;
      while not Eof do
      begin
        s:=FieldByName('EV_TYPE').AsString;
        if s='BIRT' then
        begin
          fCoherenceDate.Naissance.SetDateWriten(FieldByName('EV_DATE_WRITEN').AsString);
        end
        else if s='DEAT' then
        begin
          fCoherenceDate.Deces.SetDateWriten(FieldByName('EV_DATE_WRITEN').AsString);
        end
        else
        begin
          if FieldByName('S_TABLE').AsString='I' then
          begin
            fCoherenceDate.AddInfoDateWriten(
              FieldByName('EV_DATE_WRITEN').AsString,
              FieldByName('EV_TYPE').AsString,
              FieldByName('EV_CLEF').AsInteger,
              fCoherenceDate.AutresEventInd);
          end
          else if FieldByName('S_TABLE').AsString='F' then
          begin
            if s='MARR' then //doit être dans Mariages et AutresEventUnion pour tester avec naissance et décès
              fCoherenceDate.AddInfoDateWriten(
                FieldByName('EV_DATE_WRITEN').AsString,
                '',
                FieldByName('EV_CLEF').AsInteger,
                fCoherenceDate.Mariages );
            fCoherenceDate.AddInfoDateWriten(
              FieldByName('EV_DATE_WRITEN').AsString,
              FieldByName('EV_TYPE').AsString,
              FieldByName('EV_CLEF').AsInteger,
              fCoherenceDate.AutresEventUnion );
          end
          else if FieldByName('S_TABLE').AsString='E' then
          begin
            fCoherenceDate.AddInfoDateWriten(
              FieldByName('EV_DATE_WRITEN').AsString,
              '',//type pas utilisé pour les enfants
              FieldByName('EV_CLEF').AsInteger,
              fCoherenceDate.NaissancesEnfants );
          end;
        end;
        Next;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TFIndividu.btnPbCoherenceClick(Sender:TObject);
begin
  aFCoherence.Refresh;
  aFCoherence.Show;
end;

function TFIndividu.ChangeFicheActive(const aCleFiche:integer):boolean;
begin
  if VerifyCanCloseFiche then
    result:=doOpenFiche(aCleFiche)
  else
    result:=false;
  if result then
    self.SetFocus;
end;

procedure TFIndividu.btnPrintClick(Sender:TObject);
var
  bZoom:Boolean;
  LSTemp : String;
begin
  case fOngletFormIncrusted of
    _ONGLET_ARBRE:
      with aFIndividuArbre,oc do
      begin
        if cbDescendance.checked
          Then LSTemp := rs_Report_Descent_of
          Else LSTemp := rs_Ancestry_of;

        p_CreateAndPreviewReport ( oc, fs_RemplaceMsg( LSTemp, [lNom.Caption] ));
      end;
    _ONGLET_ACTES:aFIndividuActes.btnPrint.Click;
    _ONGLET_SAVIE:aFIndividuSavie.mOuvreDocumentClick(sender);
    _ONGLET_DOMICILES:
        p_CreateAndPreviewReport ( aFIndividuDomiciles.tvAdr, fs_RemplaceMsg(rs_Homes_of,[NomIndiComplet]) );    // Matthieu
  end;
end;

procedure TFIndividu.SuperFormMouseDown(Sender:TObject;
  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  ReleaseCapture;
  TForm(Self).perform(LM_SYSCOMMAND,$F012,0);
end;

procedure TFIndividu.btnInfosClick(Sender:TObject);
var
  aFInfosIndi:TFInfosIndi;
begin
  aFInfosIndi:=TFInfosIndi.create(self);
  try
    if fDialogMode then
      CentreLaFiche(aFInfosIndi,self)
    else
      CentreLaFiche(aFInfosIndi,FMain);
    aFInfosIndi.doInit(fCleFiche);
    aFInfosIndi.ShowModal;
  finally
    FreeAndNil(aFInfosIndi);
  end;
end;

procedure TFIndividu.doPopUpOnomastique(Sender:TObject);
var
  sNom,url:string;
begin
  sNom:=QueryIndividuNOM.AsString;
  case (Sender as TMenuItem).Tag of
    0:url:='http://noms.voila.fr/v2/services_noms/lastnames_stats.asp?nom='+sNom;
    1:url:='http://www.geneanet.org/onomastique/index.php3?nom='+sNom+'&lang=fr&x=15&y=4';
    2:url:='http://www.cartedefrance.tm.fr/cgi-bin/geopatro/avantcarte.cgi?nom='+sNom+'&submit=Valider';
    3:url:='http://www.geopatronyme.com/cgi-bin/geopatro/avantcarte.cgi?nom='+sNom+'&submit=Valider';
  end;
  GotoThisURL(url);
end;

procedure TFIndividu.btnTemoinDeClick(Sender:TObject);
var
  aFTemoinDe:TFTemoinDe;
begin
  aFTemoinDe:=TFTemoinDe.create(self);
  try
    if fDialogMode then
      CentreLaFiche(aFTemoinDe,self)
    else
      CentreLaFiche(aFTemoinDe,FMain);
    aFTemoinDe.doInit(GetNomIndividu,QueryIndividuCLE_FICHE.AsInteger);
    aFTemoinDe.ShowModal;
    if aFTemoinDe.CleFicheSelected<>0 then
    begin
      dm.individu_clef:=aFTemoinDe.CleFicheSelected;
      DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
    end;
  finally
    FreeAndNil(aFTemoinDe);
  end;
end;

procedure TFIndividu.btnPatronymeClick(Sender:TObject);
var
  aFPatronymes:TFPatronymes;
begin
  aFPatronymes:=TFPatronymes.create(self);
  try
    CentreLaFiche(aFPatronymes,FMain);
    aFPatronymes.doInit(GetNomIndividu,QueryIndividuNOM.AsString);
    aFPatronymes.ShowModal;
  finally
    FreeAndNil(aFPatronymes);
  end;
  if gci_context.AfficherPatAssoc then
  begin
    if Assigned(aFIndividuIdentite) then
      aFIndividuIdentite.RefreshTitle_Nom;
    if Assigned(aFIndDlg) then
      aFIndDlg.aFIndividuIdentite.RefreshTitle_Nom;
  end;
end;

// intégration de qui sont ils

procedure TFIndividu.doLoadQuisontils;
// Procedure appelée a chaque ouverture de fiche individu ---------
type
  tListeDesCles=function(Buff:PChar;const BuffSize:integer):integer;stdcall;
  tSignatureDll=function:ShortString;stdcall;
var
  HAddOn:LongWord;
  Buff:PChar;
  FListeDesCles:tListeDesCles;
const
  BuffSize=10000;// à ajuster selon l'accès par clé (-) ou nom (+)
begin
  // On charge la DLL si elle existe ----------------------Pour chaque individu!
  if gci_context.PathQuiSontIls>'' then
    if FileExistsUTF8(gci_context.PathQuiSontIls+DirectorySeparator+_DLLQUISONTILS) { *Converted from FileExistsUTF8*  } then
    begin
      Buff:=StrAlloc(BuffSize);
      try
        HAddOn:=LoadLibrary(pchar(gci_context.PathQuiSontIls+DirectorySeparator+_DLLQUISONTILS));
          // -- si l ouverture se passe bien -----------------------------------------------------------------------
        if HAddOn<>0 then
        begin
          FListeDesCles:=tListeDesCles(GetProcAddress(HAddOn,'ListeDesCles'));
          StrCopy(Buff,PChar(''));
          if FListeDesCles(Buff,BuffSize)>0 then
            sClefQuiSontIls:=PChar(Buff);
          btnQuisontIls.Enabled:=(length(sClefQuiSontIls)>0)and(pos('||'+
            IntToStr(QueryIndividuCLE_FIXE.AsInteger)+'||','||'+sClefQuiSontIls+'||')>0);
              // On libere la DLl ------------------------
          FreeLibrary(HaddOn);
        end;
      finally
        strDispose(Buff);
      end;
    end;
end;

procedure TFIndividu.btnQuisontIlsClick(Sender:TObject);
// Procédure appelée au clic de l'icône quisontils --------
var
  monhandle:TCustomForm;
begin
  if gci_context.OpenQuiSontIls then
  begin
    monhandle:=ffor_FindForm('TForm_MainPhoto');
    if monhandle<>nil then
    begin
      monhandle.Close;
      gci_context.OpenQuiSontIls:=False;
    end;
  end;

  sClefQuiSontIls:=format('"/CLE=%d"', [QueryIndividuCLE_FIXE.AsInteger]);
  sClefQuiSontIls:=sClefQuiSontIls+format(' "/ONGL=%d"', [1]);
  p_OpenFileOrDirectory(gci_context.PathQuiSontIls+DirectorySeparator+'Quisontils.exe');
{  shellexecute(application.handle,
    nil,
    pchar(gci_context.PathQuiSontIls+DirectorySeparator+'Quisontils.exe'),
    PChar(sClefQuiSontIls),
    nil,
    SW_SHOWNORMAL);}
  gci_context.OpenQuiSontIls:=True;
end;

procedure TFIndividu.btnImportDossierClick(Sender:TObject);
begin
  DoSendMessage(Owner,'OPEN_IMPORT_DOSSIER_AUTRE_BASE');
end;

procedure TFIndividu.doEnableObjets(iMode:boolean);
begin
  aFIndividuIdentite.btnAjoutPere.enabled:=iMode;
  aFIndividuIdentite.btnAjoutMere.enabled:=iMode;
  aFIndividuIdentite.btnNewEvent.enabled:=iMode;
  aFIndividuIdentite.btnDeleteEvent.enabled:=iMode;
  aFIndividuIdentite.btnNaissance.enabled:=iMode;
  aFIndividuIdentite.btnDeces.enabled:=iMode;
  aFIndividuIdentite.btnProfession.enabled:=iMode;
  aFIndividuIdentite.btnAjoutConjoint.enabled:=iMode;
  aFIndividuIdentite.btnAjoutEnfant.enabled:=iMode;
  aFIndividuIdentite.fsbDelMere.enabled:=iMode;
  aFIndividuIdentite.fsbDelPere.enabled:=iMode;
  aFIndividuIdentite.GdEve.enabled:=iMode;
  btnNaviguer.enabled:=iMode;

  pBtn.Visible:=iMode;
  btnPrecedent.Enabled:=iMode;
  btnSuivant.Enabled:=iMode;
  fMain.menu_Individu.enabled:=iMode;
  fMain.menu_Favoris.enabled:=iMode;
  fMain.menu_ImportExport.enabled:=iMode;
  fMain.menu_Impressions.enabled:=iMode;
  fMain.mAddon.enabled:=iMode;
  fMain.mLesLieux.enabled:=iMode;
  fMain.mExtras.enabled:=iMode;
  fMain.menu_Configuration.enabled:=iMode;
  fMain.Aide1.enabled:=iMode;
  fMain.Fichier1.enabled:=iMode;
end;

procedure TFIndividu.doBtnDeplacement(Sender:TObject);
var
  Suivante,i:integer;
  bNavigator:boolean;
begin
  bNavigator:=pNavigator.Enabled;
  pNavigator.Enabled:=False;//empêche double-clic provoquant une désynchronisation de l'en-tête
  try
    if bOpen then
    begin
      if sender=btnMoinsDix then
        i:=-10
      else if sender=btnFPrecedent then
        i:=-1
      else if sender=btnFSuivant then
        i:=1
      else //if sender=btnPlusDix then
        i:=10;
      with dm.ReqSansCheck do
      begin
        Close;
        SQL.Text:='select cle_fiche from proc_suivant('+IntToStr(fCleFiche)+','+IntToStr(i)+')';
        try
          ExecQuery;
          Suivante:=Fields[0].AsInteger;
        except
          on E:EIBError do
          begin
            ShowMessage('Erreur '+_CRLF+_CRLF+E.Message);
            Suivante:=-1;
          end;
        end;
        Close;
      end;
      if suivante>0 then
        ChangeFicheActive(suivante);
    end;
  finally
    pNavigator.Enabled:=bNavigator;
  end;
end;

procedure TFIndividu.btnHistoireClick(Sender:TObject);
begin
  FMain.doShowHistoire;
  if Assigned(_FormHistoire) then
  begin
    if fOngletFormIncrusted=_ONGLET_SES_CONJOINTS then
    begin
      _FormHistoire.doPosition(aFIndividuUnion.IBQEveEV_FAM_CLEF.AsInteger,1);
    end
    else
    begin
      _FormHistoire.doPosition(aFIndividuIdentite.IBQEveEV_IND_CLEF.AsInteger,0);
      aFIndividuIdentite.clef_ev_histoire:=aFIndividuIdentite.IBQEveEV_IND_CLEF.AsInteger;
    end;
  end;
end;

procedure TFIndividu.InitOnglets;
begin
  PageControlIndividu.Pages[_ONGLET_SES_CONJOINTS].ImageIndex:=-1;
  PageControlIndividu.Pages[_ONGLET_PHOTOS_DOCS].ImageIndex:=-1;
  PageControlIndividu.Pages[_ONGLET_DOMICILES].ImageIndex:=-1;
  PageControlIndividu.Pages[_ONGLET_ACTES].ImageIndex:=-1;
  PageControlIndividu.Pages[_ONGLET_OBSERVATIONS].ImageIndex:=-1;
end;

procedure TFIndividu.doCompteOnglets;
var
  q:TIBSQL;
  titre:string;
begin
  InitOnglets;
  if (Length(Trim(QueryIndividuCOMMENT.AsString))>0)
    or(Length(Trim(QueryIndividuSOURCE.AsString))>0) then
    PageControlIndividu.Pages[_ONGLET_OBSERVATIONS].ImageIndex:=74;

  q:=TIBSQL.Create(Self);
  q.DataBase:=dm.ibd_BASE;
  q.Transaction:=dm.IBT_BASE;
  q.SQL.Add('select ''UNION'' as titre from rdb$database'
    +' where exists (select 1 from individu i'
    +' inner join t_union u on (u.union_mari=:iclef or u.union_femme=:iclef)'
    +' and (u.comment>'''' or u.source>'''')'
    +' where i.cle_fiche=:iclef)'
    +' or exists (select 1 from individu i'
    +' inner join t_union u on u.union_mari=:iclef or u.union_femme=:iclef'
    +' inner join evenements_fam e on e.ev_fam_kle_famille=u.union_clef'
    +' where i.cle_fiche=:iclef)'
    +' union select ''MEDIA'' from rdb$database'
    +' where exists (select 1 from media_pointeurs where mp_cle_individu=:iclef)'
    +' union select ''ADRES'' from rdb$database'
    +' where exists (select 1 from evenements_ind where ev_ind_kle_fiche=:iclef and ev_ind_type=''RESI'')'
    +' union select ''ACTES'' from rdb$database where exists (select 1 from evenements_ind e'
    +' where e.ev_ind_acte=1 and e.ev_ind_kle_fiche=:iclef)'
    +' or exists (select 1 from t_union u'
    +' inner join evenements_fam e on e.ev_fam_kle_famille=u.union_clef and e.ev_fam_acte=1'
    +' where (u.union_mari=:iclef) or (u.union_femme=:iclef))');
  q.Params[0].AsInteger:=fCleFiche;
  q.ExecQuery;
  with q do
  while not eof do
  begin
    titre:=FieldByName('Titre').AsString;
    if titre='UNION' then
      PageControlIndividu.Pages[_ONGLET_SES_CONJOINTS].ImageIndex:=74
    else if titre='MEDIA' then
      PageControlIndividu.Pages[_ONGLET_PHOTOS_DOCS].ImageIndex:=74
    else if titre='ADRES' then
      PageControlIndividu.Pages[_ONGLET_DOMICILES].ImageIndex:=74
    else if titre='ACTES' then
      PageControlIndividu.Pages[_ONGLET_ACTES].ImageIndex:=74;
    next;
  end;
  q.Close;
  q.Free;
end;

procedure TFIndividu.doChangeRequete;
const
  // MD supprimé Age_Texte et Age_Indi, modifié AgeUnion pour avoir DateUnion
  Select1='select i.cle_fiche'
    +',i.kle_dossier'
    +',i.cle_pere'
    +',i.cle_mere'
    +',i.prefixe'
    +',i.nom'
    +',i.prenom'
    +',i.surnom'
    +',i.suffixe'
    +',i.sexe'
    +',i.date_naissance'
    +',i.annee_naissance'
    +',i.date_deces'
    +',i.annee_deces'
    +',i.decede'
    +',i.source'
    +',i.comment'
    +',i.filliation'
    +',i.num_sosa'
    +',i.date_modif'
    +',i.date_creation'
    +',i.modif_par_qui'
    +',i.nchi'
    +',i.nmr'
    +',i.cle_fixe'
    +',i.consanguinite'
    +',i.indi_trie_nom'
    +',i.type_lien_gene'
    +',i.ind_confidentiel';

  AvecPhotos1=',mp.mp_clef'
    +',mu.multi_reduite';

  SansPhotos=',0 as mp_clef'
    +',cast(null as blob)as multi_reduite';

  Select2=',n.ev_ind_ville as ville_naissance'
    +',d.ev_ind_ville as ville_deces'
    +',(select first(1) e.ev_fam_date_writen from t_union u'
    +' inner join evenements_fam e on e.ev_fam_kle_famille=u.union_clef'
    +' and e.ev_fam_type=''MARR'' and e.ev_fam_date_year is not null'
    +' where i.cle_fiche in (u.union_mari, u.union_femme)'
    +' order by e.ev_fam_datecode)as date_union'
    +',(select first(1) 1 from t_associations'
    +' where assoc_kle_associe=i.cle_fiche)as temoin'
    +',n.ev_ind_date as indi_naissance'
    +',d.ev_ind_date as indi_deces'
    +',(select 1 from rdb$database where exists'
    +' (select * from nom_attachement n where n.id_indi=i.cle_fiche) or exists'
    +' (select * from nom_attachement n where n.kle_dossier=i.kle_dossier and n.nom_indi=i.nom))'
    +' as AvecPatronyme'
    +',(select first(1) ev_ind_description from evenements_ind'
    +'  where ev_ind_type=''OCCU'' and ev_ind_kle_fiche=i.cle_fiche'
    +'  order by ev_ind_ordre desc nulls first,ev_ind_datecode desc nulls first)as dern_metier'
    +' from individu i'
    +' left join evenements_ind n on n.ev_ind_kle_fiche=i.cle_fiche and n.ev_ind_type=''BIRT'''
    +' left join evenements_ind d on d.ev_ind_kle_fiche=i.cle_fiche and d.ev_ind_type=''DEAT''';

  AvecPhotos2=' left join media_pointeurs mp on mp.mp_cle_individu=i.cle_fiche and mp.mp_identite=1'
    +' left join multimedia mu on mu.multi_clef=mp.mp_media';

  Select3=' where i.cle_fiche=:i_clef';

begin
  QueryIndividu.Close;
  if (gci_context.Photos=bPhotos) and not fFill.value then
    exit;
  if gci_context.Photos then
    QueryIndividu.SQL.Text:=Select1+AvecPhotos1+Select2+AvecPhotos2+Select3
  else
    QueryIndividu.SQL.Text:=Select1+SansPhotos+Select2+Select3;
  bPhotos:=gci_context.Photos;
end;

procedure TFIndividu.btnChercheNIPClick(Sender:TObject);
var
  aFChercheNIP:TFChercheNIP;
begin
  aFChercheNIP:=TFChercheNIP.create(self);
  try
    CentreLaFiche(aFChercheNIP,FMain);
    aFChercheNIP.ShowModal;
    if aFChercheNIP.iNip>0 then
    begin
      dm.individu_clef:=aFChercheNIP.iNip;
      DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
    end;
  finally
    FreeAndNil(aFChercheNIP);
  end;
end;

procedure TFIndividu.doBouton(const bMode:boolean);
begin
  fModified:=bMode;//il aurait été préférable de distinguer les modifications atteignant la fiche elle-même
  //de celles nécessitant uniquement une validation sans atteindre la fiche en cours.
  bsfbAppliquer.enabled:=bMode;
  bsfbAnnuler.enabled:=bMode;
  if not fDialogMode then
    FMain.option_RenumerotationSOSA.enabled:=not bMode;
end;

procedure TFIndividu.majbtValidAuto;
begin
  if gci_context.ValidationAutomatique then
  begin
    btValidAuto.Glyph.Assign(ImSansRetour.Picture);
    btValidAuto.Hint:=rs_Hint_Auto_validation_enabled;
  end
  else
  begin
    btValidAuto.Glyph.Assign(imValidMan.Picture);
    btValidAuto.Hint:=rs_Hint_Auto_validation_disabled;
  end;
end;

procedure TFIndividu.btValidAutoClick(Sender:TObject);
var
  bDetail_ev_ind:Boolean;
begin
  bDetail_ev_ind:=fTemporisation;
  gci_context.ValidationAutomatique:=not gci_context.ValidationAutomatique;
  majbtValidAuto;
  if bDetail_ev_ind then
    if Assigned(aFIndividuIdentite.aFIndividuEditEventLife) then
      if aFIndividuIdentite.aFIndividuEditEventLife.Visible then
        aFIndividuIdentite.aFIndividuEditEventLife.Show;
end;

procedure TFIndividu.MajAges(const Evenement:string);//AL
var
  q:TIBSQL;
  sDateUnion:string;
begin
  if QueryIndividuCLE_FICHE.AsInteger>0 then //empêche l'exécution pendant le changement d'individu
  begin
    if (Evenement='BIRT')or(Evenement='MARR') then
    begin
      q:=TIBSQL.Create(self);
      with q do
      try
        Database:=dm.ibd_BASE;
        Transaction:=dm.IBT_BASE;
        SQL.Add('select first(1) e.ev_fam_date_writen from t_union u'+
          ' inner join evenements_fam e on e.ev_fam_kle_famille=u.union_clef'+
          ' and e.ev_fam_type=''MARR'' and e.ev_fam_date_year is not null'+
          ' where '+IntToStr(fCleFiche)+' in (u.union_mari, u.union_femme)'+
          ' order by e.ev_fam_datecode');
        sDateUnion:='';
        ExecQuery;
        sDateUnion:=Fields[0].AsString;
        Close;
      finally
        Free;
      end;
      sAgeUnion:=Age_Texte(sDateNaissance,sDateUnion);
    end;
    if (Evenement='BIRT')or(Evenement='DEAT') then
    begin
      sAgeTexte:=Age_Texte(sDateNaissance,sDateDeces);
    end;
  end;
end;

procedure TFIndividu.PageControlIndividuDrawTabEx(
  AControl:TPageControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  if ATab = ATab.PageControl.ActivePage then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
end;

procedure TFIndividu.PageControlIndividuChange(Sender:TObject);
begin
  if bOpen Then
    doActiveOnglet(PageControlIndividu.ActivePageIndex);
end;

procedure TFIndividu.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  if fDialogMode and not bModale then
  begin
    Action:=caFree;
    CloseFicheIndividuInBox;
  end;
end;

function TFIndividu.TestAscDesc(const indi1,indi2:integer;const NomIndi1,NomIndi2:string
        ;AutoriseAsc:boolean=true;AutoriseDesc:boolean=true):boolean;
//AL: vérifie si l'indi2 fait partie de l'ascendance ou de la descendance
//de l'indi1 en cours avant de l'enregistrer (paramètre ignorenfant=0)
var
  q:TIBSQL;
begin
  result:=false;
  if (indi1>0)and(indi2>0) then
  begin
    q:=TIBSQL.Create(Self);
    with q do
    try
      DataBase:=dm.ibd_BASE;
      Transaction:=dm.IBT_BASE;
      SQL.Text:='delete from tq_ascendance';
      ExecQuery;
      Close;
      SQL.Text:='select niveau from proc_test_asc(:indi1,:indi2,0)';
      ParamByName('indi1').AsInteger:=indi1;
      ParamByName('indi2').AsInteger:=indi2;
      ExecQuery;
      if not Eof then
      begin
        AutoriseAsc:=AutoriseAsc and (Fields[0].AsInteger<4); //impossible si différence>3 générations
        if AutoriseAsc then
        begin
          if MyMessageDlg(NomIndi2+_CRLF
            +rs_is_ancestry_from+_CRLF
            +NomIndi1+'.'+_CRLF+_CRLF
            +rs_Do_you_record_unless,mtWarning, [mbYes,mbNo],FMain)<>mrYes then
          begin
            Close;
            result:=true;
            exit;
          end;
        end
        else
        begin
          MyMessageDlg(NomIndi2+_CRLF
            +rs_is_ancestry_from+_CRLF
            +NomIndi1+'.',mtError,[mbCancel],FMain);
          Close;
          result:=true;
          exit;
        end;
      end;
      Close;
      SQL.Text:='select niveau from proc_test_desc(:indi1,:indi2,0)';
      ParamByName('indi1').AsInteger:=indi1;
      ParamByName('indi2').AsInteger:=indi2;
      ExecQuery;
      if not Eof then
      begin
        AutoriseDesc:=AutoriseDesc and (Fields[0].AsInteger<4);//impossible si différence>3 générations
        if AutoriseDesc then
        begin
          if MyMessageDlg(NomIndi2+_CRLF
            +rs_is_descent_with+_CRLF
            +NomIndi1+'.'+_CRLF+_CRLF
            +rs_Do_you_record_unless,mtWarning, [mbYes,mbNo],FMain)<>mrYes then
          begin
            Close;
            result:=true;
            exit;
          end;
        end
        else
        begin
          MyMessageDlg(NomIndi2+_CRLF
            +rs_is_descent_with+_CRLF
            +NomIndi1+'.',mtError,[mbCancel],FMain);
          Close;
          result:=true;
          exit;
        end;
      end;
      Close;
    finally
      SQL.Text:='delete from tq_ascendance';
      ExecQuery;
      Close;
      Free;
    end;
  end;
end;

procedure TFIndividu.PostIndividu;
begin
  if QueryIndividu.State=dsEdit then
    QueryIndividu.Post;
end;

function TFIndividu.CollerEvenement(var Nouv_Evenement:integer;EvenACopier:integer=0;IndiCible:integer=0):boolean;
var
  q:TIBSQL;
begin
  result:=false;
  if EvenACopier=0 then
    EvenACopier:=dm.EvIndEnMemoire;
  if IndiCible=0 then
    IndiCible:=QueryIndividuCLE_FICHE.AsInteger;
  if (EvenACopier>0)and(DialogMode=false) then
  begin
    if TestFicheIsModified then
      DoAppliquer(false);
    doBouton(true);
    q:=TIBSQL.Create(self);
    with q do
    try
      Database:=dm.ibd_BASE;
      Transaction:=dm.IBT_BASE;
      ParamCheck:=false;
      SQL.Add('select gen_id(gen_ev_ind_clef,1) from rdb$database');
      ExecQuery;
      Nouv_Evenement:=Fields[0].AsInteger;
      Close;
      SQL.Clear;
      SQL.Add('execute block as'
        +' declare variable ev_ind_a_copier integer;'
        +'declare variable indi_cible integer;'
        +'declare variable id_ev_ind integer;'
        +'declare variable id_source_record integer;'
        +'begin'
        +' ev_ind_a_copier='+IntToStr(EvenACopier)+';'
        +'indi_cible='+IntToStr(IndiCible)+';'
        +'id_ev_ind='+IntToStr(Nouv_Evenement)+';'
        +'insert into evenements_ind(ev_ind_clef,ev_ind_kle_fiche,ev_ind_kle_dossier'
        +',ev_ind_type,ev_ind_date_writen,ev_ind_date,ev_ind_date_year,ev_ind_date_mois'
        +',ev_ind_date_year_fin,ev_ind_date_mois_fin'
        +',ev_ind_cp,ev_ind_ville,ev_ind_dept,ev_ind_pays,ev_ind_cause,ev_ind_source'
        +',ev_ind_comment,ev_ind_description,ev_ind_region,ev_ind_subd,ev_ind_acte'
        +',ev_ind_insee,ev_ind_ordre,ev_ind_heure,ev_ind_titre_event,ev_ind_latitude'
        +',ev_ind_longitude,ev_ind_lignes_adresse,ev_ind_tel,ev_ind_mail,ev_ind_web'
        +',ev_ind_date_jour,ev_ind_date_jour_fin,ev_ind_type_token1,ev_ind_type_token2'
        +',ev_ind_datecode,ev_ind_datecode_tot,ev_ind_datecode_tard)'
        +'select :id_ev_ind,:indi_cible,e.ev_ind_kle_dossier'
        +',e.ev_ind_type,e.ev_ind_date_writen,e.ev_ind_date,e.ev_ind_date_year,e.ev_ind_date_mois'
        +',e.ev_ind_date_year_fin,e.ev_ind_date_mois_fin'
        +',e.ev_ind_cp,e.ev_ind_ville,e.ev_ind_dept,e.ev_ind_pays,e.ev_ind_cause,e.ev_ind_source'
        +',e.ev_ind_comment,e.ev_ind_description,e.ev_ind_region,e.ev_ind_subd,e.ev_ind_acte'
        +',e.ev_ind_insee,e.ev_ind_ordre,e.ev_ind_heure,e.ev_ind_titre_event,e.ev_ind_latitude'
        +',e.ev_ind_longitude,e.ev_ind_lignes_adresse,e.ev_ind_tel,e.ev_ind_mail,e.ev_ind_web'
        +',e.ev_ind_date_jour,e.ev_ind_date_jour_fin,e.ev_ind_type_token1,e.ev_ind_type_token2'
        +',e.ev_ind_datecode,e.ev_ind_datecode_tot,e.ev_ind_datecode_tard'
        +' from  evenements_ind e where e.ev_ind_clef=:ev_ind_a_copier;'
        +'insert into t_associations(assoc_clef,assoc_kle_ind,assoc_kle_associe,assoc_kle_dossier'
        +',assoc_notes,assoc_sources,assoc_libelle,assoc_evenement,assoc_table)'
        +'select gen_id(gen_assoc_clef,1),:indi_cible,t.assoc_kle_associe,t.assoc_kle_dossier'
        +',t.assoc_notes,t.assoc_sources,t.assoc_libelle,:id_ev_ind,''I'''
        +'from  t_associations t where t.assoc_evenement=:ev_ind_a_copier and t.assoc_table=''I'';'
        +'select gen_id(sources_record_id_gen,1) from rdb$database into :id_source_record;'
        +'insert into sources_record(id,source_page,even,even_role,data_id,data_even'
        +',data_even_period,data_even_plac,data_agnc,quay,auth,titl,abr,publ'
        +',texte,user_ref,rin,change_date,change_note,kle_dossier,type_table)'
        +'select :id_source_record,s.source_page,s.even,s.even_role,:id_ev_ind,s.data_even'
        +',s.data_even_period,s.data_even_plac,s.data_agnc,s.quay,s.auth,s.titl,s.abr,s.publ'
        +',s.texte,s.user_ref,s.rin,s.change_date,s.change_note,s.kle_dossier,''I'''
        +' from sources_record s where s.type_table=''I'' and s.data_id=:ev_ind_a_copier;'
        +'insert into media_pointeurs(mp_clef,mp_media,mp_cle_individu,mp_pointe_sur'
        +',mp_table,mp_kle_dossier,mp_type_image)'
        +'select gen_id(biblio_pointeurs_id_gen,1),p.mp_media,:indi_cible,:id_ev_ind'
        +',''I'',p.mp_kle_dossier,''A'''
        +' from media_pointeurs p'
        +' where p.mp_type_image=''A'' and p.mp_table=''I'' and p.mp_pointe_sur=:ev_ind_a_copier;'
        +'insert into media_pointeurs(mp_clef,mp_media,mp_cle_individu,mp_pointe_sur'
        +',mp_table,mp_kle_dossier,mp_type_image)'
        +'select gen_id(biblio_pointeurs_id_gen,1),p.mp_media,:indi_cible,:id_source_record'
        +',''F'',p.mp_kle_dossier,''F'''
        +' from evenements_ind e'
        +' inner join sources_record s on s.data_id=e.ev_ind_clef and s.type_table=''I'''
        +' inner join media_pointeurs p on p.mp_type_image=''F'' and p.mp_table=''F'' and p.mp_pointe_sur=s.id'
        +' where e.ev_ind_clef=:ev_ind_a_copier;'
        +'end');
      ExecQuery;
      Close;
      result:=true;
    finally
      Free;
    end;
  end;
end;

function TFIndividu.AgesConjoints(const DateEv,DateNaisConjoint:string):string;//AL2011
var
  s,s1,s2:string;
begin
  case QueryIndividuSEXE.AsInteger of
    2:
      begin
        s1:='elle ';
        s2:='lui ';
      end;
    1:
      begin
        s1:='lui ';
        s2:='elle ';
      end;
    else
      begin
        s1:='lui ';
        s2:='lui ';
      end;
  end;
  s:=Age_Texte(sDateNaissance,DateEv);
  if s='' then
    result:=''
  else
    result:=s1+s;
  s:=Age_Texte(DateNaisConjoint,DateEv);
  if (s>'') then
  begin
    s:=s2+s;
    if result='' then
      result:=s
    else
      result:=result+', '+s;
  end;
end;

procedure TFIndividu.RemplacerConjoint(const Union,A_Conjoint:integer;const NomA_Conjoint:string);
var
  N_Conjoint,Pere,Mere:integer;
begin
  if MyMessageDlg(rs_Confirm_Option_which_consists_in_replacing_joint_in_union_and_parents+_CRLF+_CRLF
      +rs_Confirm_executing_this_option
      ,mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
  begin
    N_Conjoint:=A_Conjoint;
    if aFIndividuUnion.FajoutConjoint(true,N_Conjoint,NomA_Conjoint) then
    begin
      if (N_Conjoint>0)and(N_Conjoint<>A_Conjoint) then
      begin//remplacer dans les enfants et les unions
        if QueryIndividuSEXE.AsInteger=1 then
        begin
          Pere:=QueryIndividuCLE_FICHE.AsInteger;
          Mere:=N_Conjoint;
        end
        else
        begin
          Pere:=N_Conjoint;
          Mere:=QueryIndividuCLE_FICHE.AsInteger;
        end;
        with dm.ReqSansCheck do
        begin
          Close;
          SQL.Text:='execute block as '
            +'declare variable i_union integer='+IntToStr(Union)+';'
            +'declare variable i_pere integer='+IntToStr(Pere)+';'
            +'declare variable i_mere integer='+IntToStr(Mere)+';'
            +'declare variable n_union integer;'
            +'declare variable a_pere integer;'
            +'declare variable a_mere integer;'
            +'declare variable a_notes blob sub_type 1 segment size 80;'
            +'declare variable a_sources blob sub_type 1 segment size 80;'
            +'begin '
            +'select union_mari,union_femme,comment,source '
            +'from t_union '
            +'where union_clef=:i_union '
            +'into :a_pere,:a_mere,:a_notes,:a_sources;'
            +'select first(1) union_clef from t_union '
            +'where union_mari=:i_pere and union_femme=:i_mere '
            +'into :n_union;'
            +'if (n_union is null) then'
            +' n_union=i_union;'
            +'if (n_union=i_union) then '
            +'begin'
            +' update t_union'
            +' set union_mari=:i_pere,union_femme=:i_mere'
            +' where union_clef=:i_union;'
            +'end '
            +'else '
            +'begin'
            +' update evenements_fam'
            +' set ev_fam_kle_famille=:n_union'
            +' where ev_fam_kle_famille=:i_union;'
            +' delete from t_union'
            +' where union_clef=:i_union;'
            +'update t_union'
            +' set comment=iif(char_length(:a_notes)>0,iif(char_length(comment)>0'
              +',comment||ascii_char(13)||ascii_char(10)||:a_notes,:a_notes),comment)'
              +',source=iif(char_length(:a_sources)>0,iif(char_length(source)>0'
              +',source||ascii_char(13)||ascii_char(10)||:a_sources,:a_sources),source)'
            +'where union_clef=:n_union;'
            +'end '
            +'update individu '
            +'set cle_pere=:i_pere,cle_mere=:i_mere '
            +'where cle_pere is not distinct from :a_pere '
            +'and cle_mere is not distinct from :a_mere;'
            +'end';
          ExecQuery;
          Close;
        end;
        doBouton(true);
        aFIndividuIdentite.RempliConjEnfants;
        if OngletSesConjointsIsLoaded then
          aFIndividuUnion.doOpenQuerys(false);
      end;
    end;
  end;
end;

procedure TFIndividu.TestCoherenceDates;
begin
  LoadCoherenceDates;
  fCoherenceDate.Test;
end;


procedure TFIndividu.PageControlIndividuPageChanging(Sender: TObject;
  NewPage: TTabSheet; var AllowChange: Boolean);
var //pour désactiver le TPageControl principal au profit des secondaires
  control:TControl;
begin
  if ((Sender as TPageControl).ActivePageIndex in [_ONGLET_SES_CONJOINTS,_ONGLET_DOMICILES])
    and (GetKeyState(VK_TAB)<0) and (GetKeyState(VK_CONTROL)<0) then
  begin
    Control:=nil;
    if PageControlIndividu.ActivePageIndex=_ONGLET_SES_CONJOINTS then
    begin
      if aFIndividuUnion.bPageControlEve then
        control:=aFIndividuUnion.PageControlEve
      else if aFIndividuUnion.bPageControlNotesSources then
        control:=aFIndividuUnion.PageControlNotesSources;
    end
    else
    begin
      if aFIndividuDomiciles.bPageControl then
        control:=aFIndividuDomiciles.PageControl;
    end;
    if control is TPageControl then
    begin
      AllowChange:=false;;
      if (GetKeyState(VK_SHIFT)<0) then
        (Control as TPageControl).SelectNextPage(false)
      else
        (Control as TPageControl).SelectNextPage(true);
    end;
  end;
end;

procedure TFIndividu.SetTemporisation(const Valeur:boolean);
begin
  fTemporisation:=Valeur;
  TimerTemporisation.enabled:=true;
end;

procedure TFIndividu.TimerTemporisationTimer(Sender: TObject);
begin
  fTemporisation:=false;
  TimerTemporisation.enabled:=false;
end;


function TFIndividu.CalcChampsDateInd(const Dataset:TDataset):String;
begin
  Result:=CalcChampsDateInd(Dataset,Dataset.FieldByName('EV_IND_DATE_WRITEN').AsString);
end;

function TFIndividu.CalcChampsDateInd(const Dataset:TDataset;const DateWriten:String):String;
var
  LaDate:TGedcomDate;
  EtatCalcFields:Boolean;
  t:String;
  i:Integer;
begin
  if not (Dataset.State in [dsInsert,dsEdit]) then
    Dataset.Edit;
  EtatCalcFields:=Dataset.AutoCalcFields;
  Dataset.DisableControls;
  Dataset.AutoCalcFields:=False;
  LaDate:=TGedcomDate.Create;
  LaDate.InitTGedcomDate(_MotsClesDate,_MotsClesDate);
  try
    if LaDate.DecodeHumanDate(DateWriten) then
    begin
      if LaDate.ValidDateTime1 and (LaDate.DateTime1>-DateDelta) then
        DataSet.FieldByName('EV_IND_DATE').AsDateTime:=LaDate.DateTime1
      else
        DataSet.FieldByName('EV_IND_DATE').Clear;
      DataSet.FieldByName('EV_IND_DATECODE').AsInteger:=LaDate.DateCode1;
      DataSet.FieldByName('EV_IND_DATECODE_TOT').AsInteger:=LaDate.DateCodeTot;
      DataSet.FieldByName('EV_IND_DATECODE_TARD').AsInteger:=LaDate.DateCodeTard;
      DataSet.FieldByName('EV_IND_DATE_YEAR').AsInteger:=LaDate.Year1;
      if LaDate.Month1>0 then
        DataSet.FieldByName('EV_IND_DATE_MOIS').AsInteger:=LaDate.Month1
      else
        DataSet.FieldByName('EV_IND_DATE_MOIS').Clear;
      if LaDate.Day1>0 then
        DataSet.FieldByName('EV_IND_DATE_JOUR').AsInteger:=LaDate.Day1
      else
        DataSet.FieldByName('EV_IND_DATE_JOUR').Clear;
      if LaDate.Type_Key1>0 then
        DataSet.FieldByName('EV_IND_TYPE_TOKEN1').AsInteger:=LaDate.Type_Key1
      else
        DataSet.FieldByName('EV_IND_TYPE_TOKEN1').Clear;
      if LaDate.UseDate2 then
      begin
        DataSet.FieldByName('EV_IND_DATE_YEAR_FIN').AsInteger:=LaDate.Year2;
        if LaDate.Month2>0 then
          DataSet.FieldByName('EV_IND_DATE_MOIS_FIN').AsInteger:=LaDate.Month2
        else
          DataSet.FieldByName('EV_IND_DATE_MOIS_FIN').Clear;
        if LaDate.Day2>0 then
          DataSet.FieldByName('EV_IND_DATE_JOUR_FIN').AsInteger:=LaDate.Day2
        else
          DataSet.FieldByName('EV_IND_DATE_JOUR_FIN').Clear;
        if LaDate.Type_Key2>0 then
          DataSet.FieldByName('EV_IND_TYPE_TOKEN2').AsInteger:=LaDate.Type_Key2
        else
          DataSet.FieldByName('EV_IND_TYPE_TOKEN2').Clear;
        DataSet.FieldByName('EV_IND_CALENDRIER2').AsInteger:=ord(LaDate.Calendrier2);
      end
      else
      begin
        DataSet.FieldByName('EV_IND_DATE_YEAR_FIN').Clear;
        DataSet.FieldByName('EV_IND_DATE_MOIS_FIN').Clear;
        DataSet.FieldByName('EV_IND_DATE_JOUR_FIN').Clear;
        DataSet.FieldByName('EV_IND_TYPE_TOKEN2').Clear;
        DataSet.FieldByName('EV_IND_CALENDRIER2').AsInteger:=0;
      end;
    end
    else
    begin
      DataSet.FieldByName('EV_IND_DATE').Clear;
      DataSet.FieldByName('EV_IND_DATECODE').Clear;
      DataSet.FieldByName('EV_IND_DATECODE_TOT').Clear;
      DataSet.FieldByName('EV_IND_DATECODE_TARD').Clear;
      DataSet.FieldByName('EV_IND_DATE_YEAR').Clear;
      DataSet.FieldByName('EV_IND_DATE_MOIS').Clear;
      DataSet.FieldByName('EV_IND_DATE_JOUR').Clear;
      DataSet.FieldByName('EV_IND_TYPE_TOKEN1').Clear;
      DataSet.FieldByName('EV_IND_DATE_YEAR_FIN').Clear;
      DataSet.FieldByName('EV_IND_DATE_MOIS_FIN').Clear;
      DataSet.FieldByName('EV_IND_DATE_JOUR_FIN').Clear;
      DataSet.FieldByName('EV_IND_TYPE_TOKEN2').Clear;
      DataSet.FieldByName('EV_IND_CALENDRIER1').AsInteger:=0;
      DataSet.FieldByName('EV_IND_CALENDRIER2').AsInteger:=0;
    end;
    Result:=LaDate.HumanDate;

    if  (DataSet.FindField('EV_IND_KLE_FICHE')<>nil) //pour vérifier qu'il s'agit bien de l'indi principal
    and (DataSet.FieldByName('EV_IND_KLE_FICHE').AsInteger=QueryIndividu.FieldByName('CLE_FICHE').AsInteger)
    and (Dataset.FindField('EV_IND_TYPE')<>nil) then //ce champ peut ne pas être dans le dataset
    begin
      t:=DataSet.FieldByName('EV_IND_TYPE').AsString;
      if (t='BIRT')or(t='DEAT') then
      begin
        if t='BIRT' then
        begin
          sDateNaissance:=Result;
          AnneeNaissance:=LaDate.Year1;
          sAnneeNaissance:=LaDate.DateCourte;
          bJourNaissance:=(DataSet.FieldByName('EV_IND_DATE_JOUR').AsInteger>0);
          if bJourNaissance then //la date est valide
          begin
            DefDateCode(LaDate.Year1,1,1,LaDate.Calendrier1,0,i);
            NumJourNaissance:=LaDate.DateCode1-i+1;
          end
          else
            NumJourNaissance:=0;
        end
        else //t='DEAT'
        begin
          sDateDeces:=Result;
          sAnneeDeces:=LaDate.DateCourte;
          bJourDeces:=(DataSet.FieldByName('EV_IND_DATE_JOUR').AsInteger>0);
        end;
        MajAges(t);
        aFIndividuIdentite.RefreshTitle;
        RefreshNomIndividu;
      end;//de if (t='BIRT')or(t='DEAT')
    end;
  finally
    LaDate.Free;
    Dataset.AutoCalcFields:=EtatCalcFields;
    Dataset.EnableControls;
  end;//dÃ©clanchement du OnCalcFields une seule fois
  if Result='' then
    DataSet.FieldByName('EV_IND_DATE_WRITEN').Clear
  else
    DataSet.FieldByName('EV_IND_DATE_WRITEN').AsString:=Result;
end;

procedure TFIndividu.pmNomPopup(Sender: TObject);
var
  i:integer;
begin
  for i:=pmNom.Items.Count-1 downto 0 do
    pmNom.Items[i].Free;
  FMain.RempliPopMenuParentsConjointsEnfants(pmNom,QueryIndividu.FieldByName('CLE_FICHE').AsInteger
    ,QueryIndividu.FieldByName('SEXE').AsInteger,false);
end;

function TFIndividu.GetIBQCities: TDataSet;
begin
  if IBCities.Database.Connected
   Then Result := IBCities
   Else Result := nil;
end;

procedure TFIndividu.lNomMouseEnter(Sender:TObject);
begin
  (Sender as TLabel).Font.Style:=(Sender as TLabel).Font.Style+ [fsUnderline]
end;

procedure TFIndividu.lNomMouseLeave(Sender:TObject);
begin
  (Sender as TLabel).Font.Style:=(Sender as TLabel).Font.Style- [fsUnderline]
end;

procedure TFIndividu.lNomMouseMove(Sender:TObject;
  Shift:TShiftState;X,Y:Integer);
begin
  XSouris:=X;
  YSouris:=Y;
end;

procedure TFIndividu.lNomClick(Sender:TObject);
var
  P:TPoint;
begin
  P:=(Sender as TLabel).ClientToScreen(Point(XSouris,YSouris));
  (Sender as TLabel).PopupMenu.Popup(P.X,P.Y);
end;

{procedure TFIndividu.CMDialogKey(var Message: TCMDialogKey);
var //autre méthode pour désactiver le TPageControl principal au profit des secondaires
  control:TControl;
begin
  if (PageControlIndividu.ActivePageIndex in [_ONGLET_SES_CONJOINTS,_ONGLET_DOMICILES])
    and (Message.CharCode=VK_TAB) and (GetKeyState(VK_CONTROL)<0) then
  begin
    Control:=nil;
    if PageControlIndividu.ActivePageIndex=_ONGLET_SES_CONJOINTS then
    begin
      if aFIndividuUnion.bPageControlEve then
        control:=aFIndividuUnion.PageControlEve
      else if aFIndividuUnion.bPageControlNotesSources then
        control:=aFIndividuUnion.PageControlNotesSources;
    end
    else
    begin
      if aFIndividuDomiciles.bPageControl then
        control:=aFIndividuDomiciles.PageControl;
    end;
    if control is TPageControl then
    begin
      Message.Result:=1;
      if (GetKeyState(VK_SHIFT)<0) then
        (Control as TPageControl).SelectNextPage(false)
      else
        (Control as TPageControl).SelectNextPage(true);
    end;
  end;
  inherited;
end; }

end.

