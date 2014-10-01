{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                           }
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

unit u_genealogy_context;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  windows,
{$ELSE}
  LCLType, FileUtil,
{$ENDIF}
  lazutf8classes,
  Classes,Graphics,Forms,
  u_common_const,
  fonctions_string,
  fonctions_net,
  fonctions_db,
  IniFiles, u_common_functions;

const CST_BACKUP = 'Backup';
      ANCESTROMANIA = 'Ancestromania';
      ANCESTROMANIA_DATABASE = ANCESTROMANIA+CST_EXTENSION_FIREBIRD;


type

  { TContextIni }

  TContextIni=class ( TComponent )
  private

    //valeurs publiées en propriétés
    fShouldSave:boolean;
    fNumVersion:integer;

    fCDSVersion:string;
    fBuild:string;
    fProductName:string;

    fShowNew:boolean;
    fShowExit:boolean;
    fBackup:boolean;
    fCanSeeHint:boolean;

    //couleurs
    fColorHomme:integer;
    fColorFemme:integer;
    fColorLight:integer;
    fColorMedium:integer;
    fColorDark:integer;
    fColorTexteOnglets:integer;

    // Arbre
    fArbreRecouvrement,
    fArbreShowNbGeneration:integer;
    fArbreInverse,
    fArbreDescendance:Boolean;

    // Roue
    fRoueRecouvrement,
    fRoueShowNbGeneration:integer;

    // Liens
    fLiensRecouvrement:integer;

    fTauxCompressionJPeg:integer;

    //options de saisie
    fModeSaisieNom:TModeFormatText;
    fModeSaisiePrenom:TModeFormatText;

    fAideSaisieRapideNom:boolean;
    fAideSaisieRapidePrenom:boolean;
    fAideSaisieRapideProf:boolean;

    fCreationMARRConjoint:boolean;
    fCreationMARRParent:boolean;

    fPays:integer;
    fPaysNom:string;

    fPathFileNameBdd:string;
    fLangue:string;
    fLastNumDossier:integer;
    fFirstDemarrage:boolean;
    fVerifMAJ:boolean;


    fPathDocs:string;
    fPathImportExport:string;
    fPathImages:string;
    fMaxFavoris:integer;
    fPhotos:Boolean;
    fMontrerRepere:Boolean;

    fAgeMaxiAuDecesHommes:integer;
    fAgeMiniMariageHommes:integer;
    fAgeMiniNaissanceEnfantHommes:integer;
    fAgeMaxiMariageFemmes:integer;
    fNbJourEntre2NaissancesNormales:integer;
    fAgeMaxiNaissanceEnfantFemmes:integer;
    fNbJourEntre2NaissancesJumeaux:integer;
    fEcartAgeEntreEpoux:integer;
    fAgeMiniNaissanceEnfantFemmes:integer;
    fAgeMaxiAuDecesFemmes:integer;
    fAgeMaxiMariageHommes:integer;
    fAgeMiniMariageFemmes:integer;
    fAgeMaxiNaissanceEnfantHommes:integer;
    fCheckNbJourEntreNaissance:boolean;
    fCheckAgeMiniNaissanceEnfant:boolean;
    fCheckAgeMiniMariage:boolean;
    fCheckAgeMaxiMariage:boolean;
    fCheckAgeMaxiNaissanceEnfant:boolean;
    fCheckEcartAgeEpoux:boolean;
    fCheckEsperanceVie:boolean;
    fCoherenceActive:boolean;

    fArbreReduit:integer;
    fArbreHorizontal:boolean;
    fRoueDecalageIndiCentral:integer;
    fFileNameReport:TStringlistUTF8;
    fLanguage:string;
    fAfficheCPdansListeEV:boolean;
    fAfficheRegiondansListeEV:boolean;
    fPathSauvegarde:string;
    fPathQuiSontIls:string;
    fRepAutoWidth,fGarde,fConSang:Boolean;
    fNiveauConsang:Integer;
    fAvecLienGene,fCalculParenteAuto:Boolean;
    fValidationAutomatique:Boolean;
    fOuvreHistoire:boolean;

    fCivilite:Boolean;
    fSurnomAlaFin:boolean;
    fFormatSurnom:string;
    fFormatSurnomF:string;
    fNomDefaut:string;
    fAfficherPatAssoc:boolean;

    fOpenQuiSontIls:boolean;
    fSetAstro:Integer;
    fAstro:Boolean;
    fPanelInfosHeight,
    fPanelDomHoriz,fPanelMediaWidth:integer;
    fVersionBase:string;
    fDistanceVillesVoisines:integer;
    fPath_Applis_Ancestro:string;
    fHautEven:integer;

    fQuelSat:integer;

    // -- Gedcom ----------------------------------------------------------
    fGedcom_Nom,fGedcom_Adr1,fGedcom_Adr2,fGedcom_Adr3,fGedcom_Tel,fGedcom_Mail,fGedcom_Web:string;

    // -- Type de BDD ------------------------------------------------------
    fBDD_Ratio_Taille:SHORT;

    // -- Base locale PARANCES des tables de référence des lieux ------------
    fUtilPARANCES,fPwUtilPARANCES,fRolePARANCES:string;

    fOngletMultimediaReseau:boolean;

    fTailleFenetre:Integer;
    fCreateRepDefaut:boolean;
    fZoom:integer;

    //--paramètres de l'index des noms
    fIndexFHautInfos,fIndexFPosSplit:integer;
    fIndexFavecPat,fIndexFcolAuto:boolean;
    //--paramètres de la forme requ?tes
    function GetFirstFileNameReport(const aRelPathNameReport: string): string;

  public
    VersionExe:string;
    ImagesDansBase:boolean;

    property Zoom:integer read fZoom write fZoom;
    procedure WritePathNameBddIntoIni;


    constructor Create ( AOwner : TComponent ); override;
    destructor destroy; override;

    procedure LoadIni ( const AppName : String = '' );
    procedure SaveIni;
    procedure SaveOnlyIfShould;
    procedure WindowsVersion;
    property FileNameReport:TStringlistUTF8 read fFileNameReport write fFileNameReport;

    property OngletMultimediaReseau:boolean read fOngletMultimediaReseau write fOngletMultimediaReseau;
    property TailleFenetre:integer read fTailleFenetre write fTailleFenetre;

    // -- Type de BDD ------------------------------------------------------
    property BDD_Ratio_Taille:SHORT read fBDD_Ratio_Taille write fBDD_Ratio_Taille;
    // -- Base locale PARANCES des tables de référence des lieux ------------
    property UtilPARANCES:string read fUtilPARANCES write fUtilPARANCES;
    property PwUtilPARANCES:string read fPwUtilPARANCES write fPwUtilPARANCES;
    property RolePARANCES:string read fRolePARANCES write fRolePARANCES;

    property OpenQuiSontIls:boolean read fOpenQuiSontIls write fOpenQuiSontIls;

    property NumVersion:integer read fNumVersion write fNumVersion;

    // -- Gedcom ----------------------------------------------------------
    property Gedcom_Nom:string read fGedcom_Nom write fGedcom_Nom;
    property Gedcom_Adr1:string read fGedcom_Adr1 write fGedcom_Adr1;
    property Gedcom_Adr2:string read fGedcom_Adr2 write fGedcom_Adr2;
    property Gedcom_Adr3:string read fGedcom_Adr3 write fGedcom_Adr3;
    property Gedcom_Tel:string read fGedcom_Tel write fGedcom_Tel;
    property Gedcom_Mail:string read fGedcom_Mail write fGedcom_Mail;
    property Gedcom_Web:string read fGedcom_Web write fGedcom_Web;

    property CDSVersion:string read fCDSVersion write fCDSVersion;
    property Build:string read fBuild write fBuild;
    property ProductName:string read fProductName write fProductName;

    //La base de donnée
    property PathFileNameBdd:string read fPathFileNameBdd write fPathFileNameBdd;
    property VersionBase:string read fVersionBase write fVersionBase;

    //Les répertoires de l'application
    property Path_Applis_Ancestro:string read fPath_Applis_Ancestro write fPath_Applis_Ancestro;
    property PathQuiSontIls:string read fPathQuiSontIls write fPathQuiSontIls;

    //Les répertoires utilisateurs
    property PathImportExport:string read fPathImportExport write fPathImportExport;
    property PathImages:string read fPathImages write fPathImages;
    property PathDocs:string read fPathDocs write fPathDocs;
    property PathSauvegarde:string read fPathSauvegarde write fPathSauvegarde;

    //La langue utilisée pour la saisie des données (dates, ?v?nements) (code)
    //elle est particulière à chaque dossier AL2009
    property Langue:string read fLangue write fLangue;
    //Le pays préférentiel lors de la recherche des lieux
    property Pays:integer read fPays write fPays;
    property PaysNom:string read fPaysNom write fPaysNom;

    //Couleurs
    property ColorHomme:integer read fColorHomme write fColorHomme;
    property ColorFemme:integer read fColorFemme write fColorFemme;
    property ColorLight:integer read fColorLight write fColorLight;
    property ColorMedium:integer read fColorMedium write fColorMedium;
    property ColorDark:integer read fColorDark write fColorDark;
    property ColorTexteOnglets:integer read fColorTexteOnglets write fColorTexteOnglets;

    //JPeg
    property TauxCompressionJPeg:integer read fTauxCompressionJPeg write fTauxCompressionJPeg;

    //Nombre maximum de favoris par dossier
    property MaxFavoris:integer read fMaxFavoris write fMaxFavoris;

    // Arbre

    property ArbreRecouvrement:integer read fArbreRecouvrement write fArbreRecouvrement;
    property ArbreShowNbGeneration:integer read fArbreShowNbGeneration write fArbreShowNbGeneration;
    property ArbreDescendance:boolean read fArbreDescendance write fArbreDescendance;
    property ArbreInverse:boolean read fArbreInverse write fArbreInverse;
    // Roue
    property RoueShowNbGeneration:integer read fRoueShowNbGeneration write fRoueShowNbGeneration;
    property RoueRecouvrement:integer read fRoueRecouvrement write fRoueRecouvrement;
    // Arbre
    property LiensRecouvrement:integer read fLiensRecouvrement write fLiensRecouvrement;

    //Mode de saisie
    property ModeSaisieNom:TModeFormatText read fModeSaisieNom write fModeSaisieNom;
    property ModeSaisiePrenom:TModeFormatText read fModeSaisiePrenom write fModeSaisiePrenom;

    //activation des aides à l'ouverture de la saisie rapide
    property AideSaisieRapideNom:boolean read fAideSaisieRapideNom write fAideSaisieRapideNom;
    property AideSaisieRapidePrenom:boolean read fAideSaisieRapidePrenom write fAideSaisieRapidePrenom;
    property AideSaisieRapideProf:boolean read fAideSaisieRapideProf write fAideSaisieRapideProf;

    //activation de la création automatique de l'événement MARR
    property CreationMARRConjoint:boolean read fCreationMARRConjoint write fCreationMARRConjoint;
    property CreationMARRParent:boolean read fCreationMARRParent write fCreationMARRParent;


    property Photos:boolean read fPhotos write fPhotos;
    property MontrerRepere:boolean read fMontrerRepere write fMontrerRepere;
    property Garde:boolean read fGarde write fGarde;

    property CanSeeHint:boolean read fCanSeeHint write fCanSeeHint;
    property Backup:boolean read fBackup write fBackup;
    property ShowExit:boolean read fShowExit write fShowExit;
    property AfficheCPdansListeEV:boolean read fAfficheCPdansListeEV write fAfficheCPdansListeEV;
    property AfficheRegiondansListeEV:boolean read fAfficheRegiondansListeEV write fAfficheRegiondansListeEV;
    property ShowNew:boolean read fShowNew write fShowNew;
    property ArbreReduit:integer read fArbreReduit write fArbreReduit;
    property ArbreHorizontal:boolean read fArbreHorizontal write fArbreHorizontal;
    property VerifMAJ:boolean read fVerifMAJ write fVerifMAJ;
    property OuvreHistoire:boolean read fOuvreHistoire write fOuvreHistoire;

    //les derniers ?l?ments ouverts
    property LastNumDossier:integer read fLastNumDossier write fLastNumDossier;

    //Contr?les de coh?rences
    property CoherenceActive:boolean read fCoherenceActive write fCoherenceActive;

    property AgeMaxiAuDecesHommes:integer read fAgeMaxiAuDecesHommes write fAgeMaxiAuDecesHommes;
    property AgeMaxiAuDecesFemmes:integer read fAgeMaxiAuDecesFemmes write fAgeMaxiAuDecesFemmes;
    property AgeMiniMariageHommes:integer read fAgeMiniMariageHommes write fAgeMiniMariageHommes;
    property AgeMiniMariageFemmes:integer read fAgeMiniMariageFemmes write fAgeMiniMariageFemmes;
    property AgeMaxiMariageHommes:integer read fAgeMaxiMariageHommes write fAgeMaxiMariageHommes;
    property AgeMaxiMariageFemmes:integer read fAgeMaxiMariageFemmes write fAgeMaxiMariageFemmes;
    property AgeMiniNaissanceEnfantHommes:integer read fAgeMiniNaissanceEnfantHommes write fAgeMiniNaissanceEnfantHommes;
    property AgeMiniNaissanceEnfantFemmes:integer read fAgeMiniNaissanceEnfantFemmes write fAgeMiniNaissanceEnfantFemmes;
    property AgeMaxiNaissanceEnfantHommes:integer read fAgeMaxiNaissanceEnfantHommes write fAgeMaxiNaissanceEnfantHommes;
    property AgeMaxiNaissanceEnfantFemmes:integer read fAgeMaxiNaissanceEnfantFemmes write fAgeMaxiNaissanceEnfantFemmes;

    property NbJourEntre2NaissancesNormales:integer read fNbJourEntre2NaissancesNormales write fNbJourEntre2NaissancesNormales;
    property NbJourEntre2NaissancesJumeaux:integer read fNbJourEntre2NaissancesJumeaux write fNbJourEntre2NaissancesJumeaux;
    property EcartAgeEntreEpoux:integer read fEcartAgeEntreEpoux write fEcartAgeEntreEpoux;

    property CheckAgeMiniMariage:boolean read fCheckAgeMiniMariage write fCheckAgeMiniMariage;
    property CheckAgeMaxiMariage:boolean read fCheckAgeMaxiMariage write fCheckAgeMaxiMariage;
    property CheckAgeMiniNaissanceEnfant:boolean read fCheckAgeMiniNaissanceEnfant write fCheckAgeMiniNaissanceEnfant;
    property CheckAgeMaxiNaissanceEnfant:boolean read fCheckAgeMaxiNaissanceEnfant write fCheckAgeMaxiNaissanceEnfant;
    property CheckEsperanceVie:boolean read fCheckEsperanceVie write fCheckEsperanceVie;
    property CheckEcartAgeEpoux:boolean read fCheckEcartAgeEpoux write fCheckEcartAgeEpoux;
    property CheckNbJourEntreNaissance:boolean read fCheckNbJourEntreNaissance write fCheckNbJourEntreNaissance;

    //pour savoir si il faut enregistrer les modifications
    property ShouldSave:boolean read fShouldSave write fShouldSave;

    //savoir si c'est le premier d?marrage
    property FirstDemarrage:boolean read fFirstDemarrage;

    // Divers

    property ValidationAutomatique:boolean read fValidationAutomatique write fValidationAutomatique;
    property ConSang:boolean read fConSang write fConSang;
    property NiveauConsang:integer read fNiveauConsang write fNiveauConsang;
    property AvecLienGene:boolean read fAvecLienGene write fAvecLienGene;
    property CalculParenteAuto:boolean read fCalculParenteAuto write fCalculParenteAuto;
    property Astro:boolean read fAstro write fAstro;
    property SetAstro:integer read fSetAstro write fSetAstro;

    property PanelInfosHeight:integer read fPanelInfosHeight write fPanelInfosHeight;
    property PanelMediaWidth:integer read fPanelMediaWidth write fPanelMediaWidth;
    property SurnomAlaFin:boolean read fSurnomAlaFin write fSurnomAlaFin;
    property AfficherPatAssoc:boolean read fAfficherPatAssoc write fAfficherPatAssoc;
    property Civilite:boolean read fCivilite write fCivilite;
    property FormatSurnom:string read fFormatSurnom write fFormatSurnom;
    property FormatSurnomF:string read fFormatSurnomF write fFormatSurnomF;
    property NomDefaut:string read fNomDefaut write fNomDefaut;
    property DistanceVillesVoisines:integer read fDistanceVillesVoisines write fDistanceVillesVoisines;
    property QuelSat:integer read fQuelSat write fQuelSat;

    property RepAutoWidth:boolean read fRepAutoWidth write fRepAutoWidth;

    property HautEven:integer read fHautEven write fHautEven;
    property CreateRepDefaut:boolean read fCreateRepDefaut write fCreateRepDefaut;

    //--paramètres de l'index des noms
    property IndexFavecPat:boolean read fIndexFavecPat write fIndexFavecPat;
    property IndexFcolAuto:boolean read fIndexFcolAuto write fIndexFcolAuto;
  end;

var AIniFile : TInifile;
  _REP_PATH_REPORT:array[0.._MAX_REP_PATH] of string;
  gci_context:TContextIni=nil;

implementation

uses
  {$IFDEF WIN32}
  JwaWinNT, JwaWinBase,
  {$ENDIF}
  fonctions_init,sysutils,
  fonctions_system;

{ TContextIni }


function TContextIni.GetFirstFileNameReport(const aRelPathNameReport:string):string;
var
  List:TStringlistUTF8;
begin
  result:='';
  List:=TStringlistUTF8.create;
  try
    GetDirContent(Path_Applis_Ancestro+_REL_PATH_REPORT+aRelPathNameReport,List,'*.rtm');
    if List.Count>0 then
      result:=List[0];
  finally
    List.Free;
  end;
end;

procedure TContextIni.WritePathNameBddIntoIni;
begin
  p_IniWriteSectionStr('Path','PathFileNameBdd',fPathFileNameBdd);
end;

constructor TContextIni.Create ( AOwner : TComponent );
var
  n:integer;
begin
  inherited;
  ImagesDansBase:=false;
  fNumVersion:=StrToInt(NumVersionCourt(6,gr_ExeVersion))+StrToInt(NumVersionCourt(1, gr_ExeVersion))shl 16;
  VersionExe:=NumVersionCourt(2, gr_ExeVersion);
  fPath_MesDocuments:=GetDocDir+DirectorySeparator+Ancestromania+DirectorySeparator;
  {$IFDEF WINDOWS}
  fPath_Applis_Ancestro:=GetAppConfigDir(True)+DirectorySeparator;
  {$ELSE}
  fPath_Applis_Ancestro:=ExtractFileDir(Application.ExeName)+DirectorySeparator;
  {$ENDIF}

  // -- Divers ----------------------------
  fValidationAutomatique:=False;

  fFileNameReport:=TStringlistUTF8.create;
  for n:=0 to _MAX_REP_PATH do
    fFileNameReport.Add('');

  //La langue
  fLangue:='FRA';

end;

destructor TContextIni.destroy;
begin
  SaveOnlyIfShould;
  fFileNameReport.free;
  inherited;
end;

procedure TContextIni.LoadIni ( const AppName : String = '' );//serait mieux dans Initialization
var
  k:integer;
  fIni:TIniFile;

  procedure LoadStringList(Key:string;List:TStringlistUTF8);
  var
    n,p:integer;
  begin
    List.Clear;
    p:=fIni.ReadInteger(Key,'Count',0);
    for n:=0 to p-1 do
      List.Add(fIni.ReadString(Key,'Str'+inttostr(n),''));
  end;
begin
  fShouldSave:=False;

  fIni:=f_GetMainMemIniFile( nil,nil, Self, False , AppName );
  try
    fCreateRepDefaut:=fIni.ReadBool('Settings','CreateRepDefaut',True);
    fZoom:=fIni.ReadInteger('Settings','Zoom',15);
    fOngletMultimediaReseau:=fIni.ReadBool('Settings','OngletMultimediaReseau',True);
    fTailleFenetre:=fIni.ReadInteger('Settings','TailleFenetre',100);


      //gardé pour compatibilité avec dll Arbres et mise à jour
    fOuvreHistoire:=fIni.ReadBool('Settings','OuvreHistoire',True);

      // BDD ------------------------------------------------------
    fBDD_Ratio_Taille:=fIni.ReadInteger('Settings','BDD_Ratio_Taille',20);
    _user_name:=fIni.ReadString('Settings','IdUtilisateur',_user_name);
    _password:=fIni.ReadString('Settings','PwUtilisateur',_password);
    _role_name:=fIni.ReadString('Settings','RlUtilisateur','');
 
    // -- Base locale PARANCES des tables de référence des lieux ------------
    fUtilPARANCES:=fIni.ReadString('Settings','UtilPARANCES','SYSDBA');
    fPwUtilPARANCES:=fIni.ReadString('Settings','PwUtilPARANCES','masterkey');
    fRolePARANCES:=fIni.ReadString('Settings','RolePARANCES','');
      // -- Divers -----------------------------------------------------------

    fAstro:=fIni.ReadBool('Settings','Astro',True);
    fSetAstro:=fIni.ReadInteger('Settings','SetAstro',3);
    fConSang:=fIni.ReadBool('Settings','ConSang',True);
    fAvecLienGene:=fIni.ReadBool('Settings','AvecLienGene',True);
    fCalculParenteAuto:=fIni.ReadBool('Settings','CalculParenteAuto',True);

    fPanelDomHoriz:=fIni.ReadInteger('Settings','PanelDomHoriz',185);
    fPanelInfosHeight:=fIni.ReadInteger('Settings','PanelInfosHeight',127);
    fPanelMediaWidth:=fIni.ReadInteger('Settings','PanelMediaWidth',350);
    fHautEven:=fIni.ReadInteger('Settings','HautEven',525);
    fSurnomAlaFin:=fIni.ReadBool('Settings','SurnomAlaFin',false);
    fAfficherPatAssoc:=fIni.ReadBool('Settings','AfficherPatAssoc',True);
    fCivilite:=fIni.ReadBool('Settings','Civilite',True);
    fFormatSurnom:=fIni.ReadString('Settings','FormatSurnom','');
    fFormatSurnomF:=fIni.ReadString('Settings','FormatSurnomF','');
    if (fFormatSurnomF='') and (fFormatSurnom>'') then
      fFormatSurnomF:=fFormatSurnom+'e';
    fNomDefaut:=fIni.ReadString('Settings','NomDefaut','NOM DE L''INDIVIDU');
    fNiveauConsang:=fIni.ReadInteger('Settings','NiveauConsang',4);
    fDistanceVillesVoisines:=fIni.ReadInteger('Settings','DistanceVillesVoisines',15);

      // -- Gedcom -----------------------------------------------------------
    //fGedcom_KeepDonnees:=fIni.ReadBool('Gedcom','Gedcom_KeepDonnees',True);
    fGedcom_Nom:=fIni.ReadString('Gedcom','Gedcom_Nom','');
    fGedcom_Adr1:=fIni.ReadString('Gedcom','Gedcom_Adr1','');
    fGedcom_Adr2:=fIni.ReadString('Gedcom','Gedcom_Adr2','');
    fGedcom_Adr3:=fIni.ReadString('Gedcom','Gedcom_Adr3','');
    fGedcom_Tel:=fIni.ReadString('Gedcom','Gedcom_Tel','');
    fGedcom_Mail:=fIni.ReadString('Gedcom','Gedcom_Mail','');
    fGedcom_Web:=fIni.ReadString('Gedcom','Gedcom_Web','http://www.monsite.net');

    //Arbre
    fArbreRecouvrement:=fIni.ReadInteger('GraphArbre','ArbreRecouvrement',2);
    fArbreShowNbGeneration:=fIni.ReadInteger('GraphArbre','ArbreShowNbGeneration',12);
    fArbreDescendance:=fIni.ReadBool('GraphArbre','ArbreDescendance',False);
    fArbreInverse:=fIni.ReadBool('GraphArbre','ArbreInverse',False);

    //Roue
    fRoueRecouvrement:=fIni.ReadInteger('GraphRoue','RoueRecouvrement',2);
    fRoueShowNbGeneration:=fIni.ReadInteger('GraphRoue','RoueShowNbGeneration',6);

    //Arbre
    fLiensRecouvrement:=fIni.ReadInteger('GraphLiens','LiensRecouvrement',2);

    //La base de donnée
    fPathFileNameBdd:=fIni.ReadString('Path','PathFileNameBdd','');

    fPathSauvegarde:=fIni.ReadString('Path','PathSauvegarde','');

    fFirstDemarrage:=fPathFileNameBdd='';

    fPathQuiSontIls:=fIni.ReadString('Path','PathQuiSontIls','');

    fPathQuiSontIls:=ExcludeTrailingPathDelimiter(fPathQuiSontIls);
    fPathImportExport:=fIni.ReadString('Path','PathImportExport','');
    fPathImportExport:=ExcludeTrailingPathDelimiter(fPathImportExport);
    fPathDocs:=fIni.ReadString('Path','PathDocuments','');
    fPathDocs:=ExcludeTrailingPathDelimiter(fPathDocs);
      //Le Pays
    fPays:=fIni.ReadInteger('Settings','Pays',1);
    fPaysNom:=fIni.ReadString('Settings','PaysNom','FRANCE');
       //Couleurs
    fColorHomme:=fIni.ReadInteger('Colors','ColorHomme',$00FF8000);
    fColorFemme:=fIni.ReadInteger('Colors','ColorFemme',$008080FF);
    fColorLight:=fIni.ReadInteger('Colors','ColorLight',clWindow);
    fColorMedium:=fIni.ReadInteger('Colors','ColorMedium',clBtnFace);
    fColorDark:=fIni.ReadInteger('Colors','ColorDark',clDefault);
    fColorTexteOnglets:=fIni.ReadInteger('Colors','ColorTexteOnglets',clWindowText);

      //JPeg
    fTauxCompressionJPeg:=fIni.ReadInteger('Settings','TauxCompressionJPeg',70);

      //Nombre maximum de favoris par dossier
    fMaxFavoris:=fIni.ReadInteger('Settings','MaxFavoris',20);

      //Mode de saisie
    k:=fIni.ReadInteger('Settings','ModeSaisieNom',1);
    case k of
      0:fModeSaisieNom:=mftNone;
      1:fModeSaisieNom:=mftUpper;
      2:fModeSaisieNom:=mftFirstCharOfWordsIsMaj;
    end;

    k:=fIni.ReadInteger('Settings','ModeSaisiePrenom',2);
    case k of
      0:fModeSaisiePrenom:=mftNone;
      1:fModeSaisiePrenom:=mftUpper;
      2:fModeSaisiePrenom:=mftFirstCharOfWordsIsMaj;
    end;

    //activation des aides ? l'ouverture de la saisie rapide
    fAideSaisieRapideNom:=fIni.ReadBool('Settings','AideSaisieRapideNom',True);
    fAideSaisieRapidePrenom:=fIni.ReadBool('Settings','AideSaisieRapidePrenom',True);
    fAideSaisieRapideProf:=fIni.ReadBool('Settings','AideSaisieRapideProf',True);

    //activation de la cr?ation automatique de l'?v?nement MARR
    fCreationMARRConjoint:=fIni.ReadBool('Settings','CreationMARRConjoint',False);
    fCreationMARRParent:=fIni.ReadBool('Settings','CreationMARRParent',False);

    //paramètres g?n?raux
    fPhotos:=fIni.ReadBool('Settings','Photos',True);
    fMontrerRepere:=fIni.ReadBool('Settings','MontrerRepere',True);
    fGarde:=fIni.ReadBool('Settings','Garde',False);
    fQuelSat:=fIni.ReadInteger('Settings','QuelSat',2);

    fCanSeeHint:=fIni.ReadBool('Settings','CanSeeHint',True);
    fShowExit:=fIni.ReadBool('Settings','ShowExit',True);
    fBackup:=fIni.ReadBool('Settings','Backup',False);
    fAfficheCPdansListeEV:=fIni.ReadBool('Settings','AfficheCPdansListeEV',False);
    fAfficheRegiondansListeEV:=fIni.ReadBool('Settings','AfficheRegiondansListeEV',False);
    fVerifMAJ:=fIni.ReadBool('Settings','VerifMAJ',False);

    fShowNew:=fIni.ReadBool('Settings','ShowNew',True);
    fArbreReduit:=fIni.ReadInteger('Settings','ArbreReduit',3);
    fArbreHorizontal:=fIni.ReadBool('Settings','ArbreHorizontal',false);
    fRepAutoWidth:=fIni.ReadBool('Settings','RepAutoWidth',True);

      //les derniers éléments ouverts
    fLastNumDossier:=fIni.ReadInteger('Last','LastNumDossier',1);


    //Contrôles de cohérences
    fCoherenceActive:=fIni.ReadBool('Coherence','CoherenceActive',True);
    fAgeMiniMariageHommes:=fIni.ReadInteger('Coherence','AgeMiniMariageHommes',12);
    fAgeMiniMariageFemmes:=fIni.ReadInteger('Coherence','AgeMiniMariageFemmes',10);
    fAgeMaxiMariageHommes:=fIni.ReadInteger('Coherence','AgeMaxiMariageHommes',85);
    fAgeMaxiMariageFemmes:=fIni.ReadInteger('Coherence','AgeMaxiMariageFemmes',85);
    fAgeMiniNaissanceEnfantHommes:=fIni.ReadInteger('Coherence','AgeMiniNaissanceEnfantHommes',14);
    fAgeMiniNaissanceEnfantFemmes:=fIni.ReadInteger('Coherence','AgeMiniNaissanceEnfantFemmes',17);
    fAgeMaxiNaissanceEnfantHommes:=fIni.ReadInteger('Coherence','AgeMaxiNaissanceEnfantHommes',65);
    fAgeMaxiNaissanceEnfantFemmes:=fIni.ReadInteger('Coherence','AgeMaxiNaissanceEnfantFemmes',55);
    fAgeMaxiAuDecesHommes:=fIni.ReadInteger('Coherence','AgeMaxiAuDecesHommes',95);
    fAgeMaxiAuDecesFemmes:=fIni.ReadInteger('Coherence','AgeMaxiAuDecesFemmes',97);
    fNbJourEntre2NaissancesNormales:=fIni.ReadInteger('Coherence','NbJourEntre2NaissancesNormales',300);
    fNbJourEntre2NaissancesJumeaux:=2;//non modifiable
    fEcartAgeEntreEpoux:=fIni.ReadInteger('Coherence','EcartAgeEntreEpoux',40);

    fCheckAgeMiniMariage:=fIni.ReadBool('Coherence','CheckAgeMiniMariage',True);
    fCheckAgeMaxiMariage:=fIni.ReadBool('Coherence','CheckAgeMaxiMariage',True);
    fCheckAgeMiniNaissanceEnfant:=fIni.ReadBool('Coherence','CheckAgeMiniNaissanceEnfant',True);
    fCheckAgeMaxiNaissanceEnfant:=fIni.ReadBool('Coherence','CheckAgeMaxiNaissanceEnfant',True);
    fCheckEsperanceVie:=fIni.ReadBool('Coherence','CheckEsperanceVie',True);
    fCheckEcartAgeEpoux:=fIni.ReadBool('Coherence','CheckEcartAgeEpoux',True);
    fCheckNbJourEntreNaissance:=fIni.ReadBool('Coherence','CheckNbJourEntreNaissance',True);


      //fichiers 'rtm' des rapports utilis?s
    for k:=0 to _MAX_REP_PATH do
    begin
      fFileNameReport[k]:=fIni.ReadString('Reports','FileNameReport'+_REP_PATH_REPORT[k],'');

      if fFileNameReport[k]='' then
      begin
        fFileNameReport[k]:=GetFirstFileNameReport(_REP_PATH_REPORT[k]);
        if fFileNameReport[k]<>'' then
          fShouldSave:=True;
      end;
    end;

  finally
  end;

  //on vérifie que les répertoires existent
  if (not DirectoryExistsUTF8(fPathImportExport)) then
    fPathImportExport:=fPath_MesDocuments+_REL_PATH_IMPORT_EXPORT;
  if (not DirectoryExistsUTF8(fPathDocs)) then
    fPathDocs:=fPath_MesDocuments+_REL_PATH_DOC;

  WindowsVersion;
end;

procedure TContextIni.SaveIni;
var
  k:integer;
  fIni:TIniFile;

begin
  fShouldSave:=False;

  fIni:=f_GetMemIniFile;
  try
    fIni.WriteBool('Settings','CreateRepDefaut',fCreateRepDefaut);
    fIni.WriteInteger('Settings','Zoom',fZoom);

    fIni.WriteBool('Settings','OngletMultimediaReseau',fOngletMultimediaReseau);
    fIni.WriteInteger('Settings','TailleFenetre',fTailleFenetre);


    fIni.WriteBool('Settings','OuvreHistoire',fOuvreHistoire);

      // --  BDD ------------------------------------------------------
    fIni.WriteInteger('Settings','BDD_Ratio_Taille',fBDD_Ratio_Taille);
    fIni.WriteString('Settings','IdUtilisateur',_user_name);
    fIni.WriteString('Settings','PwUtilisateur',_password);
    fIni.WriteString('Settings','RlUtilisateur',_role_name);
 
    // -- Base locale PARANCES des tables de référence des lieux ------------
    fIni.WriteString('Settings','UtilPARANCES',fUtilPARANCES);
    fIni.WriteString('Settings','PwUtilPARANCES',fPwUtilPARANCES);
    fIni.WriteString('Settings','RolePARANCES',fRolePARANCES);

    //Arbre
    fIni.WriteInteger('GraphArbre','ArbreShowNbGeneration',fArbreShowNbGeneration);
    fIni.WriteInteger('GraphArbre','ArbreRecouvrement',fArbreRecouvrement);
    fIni.WriteBool('GraphArbre','ArbreDescendance',fArbreDescendance);
    fIni.WriteBool('GraphArbre','ArbreInverse',fArbreInverse);

    //Roue
    fIni.WriteInteger('GraphRoue','RoueRecouvrement',fRoueRecouvrement);
    fIni.WriteInteger('GraphRoue','RoueShowNbGeneration',fRoueShowNbGeneration);

    //Liens
    fIni.WriteInteger('GraphLiens','LiensRecouvrement',fRoueRecouvrement);

    // -- Divers -----------------------------------------------------------
    fIni.WriteBool('Settings','Astro',fAstro);
    fIni.WriteInteger('Settings','SetAstro',fSetAstro);
    fIni.WriteBool('Settings','ConSang',fConSang);
    fIni.WriteBool('Settings','AvecLienGene',fAvecLienGene);
    fIni.WriteBool('Settings','CalculParenteAuto',fCalculParenteAuto);

    fIni.WriteInteger('Settings','PanelDomHoriz',fPanelDomHoriz);
    fIni.WriteInteger('Settings','PanelInfosHeight',fPanelInfosHeight);
    fIni.WriteInteger('Settings','PanelMediaWidth',fPanelMediaWidth);
    fIni.WriteInteger('Settings','HautEven',fHautEven);
    fIni.WriteBool('Settings','SurnomAlaFin',fSurnomAlaFin);
    fIni.WriteBool('Settings','AfficherPatAssoc',fAfficherPatAssoc);
    fIni.WriteBool('Settings','Civilite',fCivilite);
    fIni.WriteString('Settings','FormatSurnom',fFormatSurnom);
    fIni.WriteString('Settings','FormatSurnomF',fFormatSurnomF);
    fIni.WriteString('Settings','NomDefaut',fNomDefaut);
    fIni.WriteInteger('Settings','NiveauConsang',fNiveauConsang);
    fIni.WriteInteger('Settings','DistanceVillesVoisines',fDistanceVillesVoisines);
    fIni.WriteInteger('Settings','QuelSat',fQuelSat);

      // -- Gedcom -----------------------------------------------------------
    //fIni.WriteBool('Gedcom','Gedcom_KeepDonnees',fGedcom_KeepDonnees);
    fIni.WriteString('Gedcom','Gedcom_Nom',fGedcom_Nom);
    fIni.WriteString('Gedcom','Gedcom_Adr1',fGedcom_Adr1);
    fIni.WriteString('Gedcom','Gedcom_Adr2',fGedcom_Adr2);
    fIni.WriteString('Gedcom','Gedcom_Adr3',fGedcom_Adr3);
    fIni.WriteString('Gedcom','Gedcom_Tel',fGedcom_Tel);
    fIni.WriteString('Gedcom','Gedcom_Mail',fGedcom_Mail);
    fIni.WriteString('Gedcom','Gedcom_Web',fGedcom_Web);


      //La base de donnée
    fIni.WriteString('Path','PathSauvegarde',fPathSauvegarde);
    fIni.WriteString('Path','PathQuiSontIls',fPathQuiSontIls);
      //Les répertoires
    fIni.WriteString('Path','PathImportExport',fPathImportExport);
    fIni.WriteString('Path','PathDocuments',fPathDocs);

      //La Langue
    fIni.WriteString('Settings','Language',fLanguage);

      //Le Pays
    fIni.WriteInteger('Settings','Pays',fPays);
    fIni.WriteString('Settings','PaysNom',fPaysNom);

      //Couleurs
    fIni.WriteInteger('Colors','ColorHomme',fColorHomme);
    fIni.WriteInteger('Colors','ColorFemme',fColorFemme);
    fIni.WriteInteger('Colors','ColorLight',fColorLight);
    fIni.WriteInteger('Colors','ColorMedium',fColorMedium);
    fIni.WriteInteger('Colors','ColorDark',fColorDark);
    fIni.WriteInteger('Colors','ColorTexteOnglets',fColorTexteOnglets);

      //JPeg
    fIni.WriteInteger('Settings','TauxCompressionJPeg',fTauxCompressionJPeg);

      //Nombre maximum de favoris par dossier: ?criture inutile car aucun acc?s ? la modification
    //fIni.WriteInteger('Settings','MaxFavoris',fMaxFavoris);

      //Mode de saisie
    case fModeSaisieNom of
      mftNone:fIni.WriteInteger('Settings','ModeSaisieNom',0);
      mftUpper:fIni.WriteInteger('Settings','ModeSaisieNom',1);
      else //msJustFirstLetterUpper
        fIni.WriteInteger('Settings','ModeSaisieNom',2);
    end;

    case fModeSaisiePrenom of
      mftNone:fIni.WriteInteger('Settings','ModeSaisiePrenom',0);
      mftUpper:fIni.WriteInteger('Settings','ModeSaisiePrenom',1);
      else //msJustFirstLetterUpper
        fIni.WriteInteger('Settings','ModeSaisiePrenom',2);
    end;

    //activation des aides ? l'ouverture de la saisie rapide
    fIni.WriteBool('Settings','AideSaisieRapideNom',fAideSaisieRapideNom);
    fIni.WriteBool('Settings','AideSaisieRapidePrenom',fAideSaisieRapidePrenom);
    fIni.WriteBool('Settings','AideSaisieRapideProf',fAideSaisieRapideProf);

    //activation de la cr?ation automatique de l'?v?nement MARR
    fIni.WriteBool('Settings','CreationMARRConjoint',fCreationMARRConjoint);
    fIni.WriteBool('Settings','CreationMARRParent',fCreationMARRParent);


    //paramètres g?n?raux
    fIni.WriteBool('Settings','Photos',fPhotos);
    fIni.WriteBool('Settings','MontrerRepere',fMontrerRepere);
    fIni.WriteBool('Settings','Garde',fGarde);

    fIni.WriteBool('Settings','CanSeeHint',fCanSeeHint);
    fIni.WriteBool('Settings','ShowExit',fShowExit);
    fIni.WriteBool('Settings','Backup',fBackup);
    fIni.WriteBool('Settings','ShowNew',fShowNew);

    fIni.WriteBool('Settings','AfficheCPdansListeEV',fAfficheCPdansListeEV);
    fIni.WriteBool('Settings','AfficheRegiondansListeEV',fAfficheRegiondansListeEV);
    fIni.WriteBool('Settings','VerifMAJ',fVerifMAJ);

    fIni.WriteInteger('Settings','ArbreReduit',fArbreReduit);
    fIni.WriteBool('Settings','ArbreHorizontal',fArbreHorizontal);

    fIni.WriteBool('Settings','RepAutoWidth',fRepAutoWidth);

      //les derniers éléments ouverts
    fIni.WriteInteger('Last','LastNumDossier',fLastNumDossier);

    //Contrôles de cohérences
    fIni.WriteBool('Coherence','CoherenceActive',fCoherenceActive);
    fIni.WriteInteger('Coherence','AgeMiniMariageHommes',fAgeMiniMariageHommes);
    fIni.WriteInteger('Coherence','AgeMiniMariageFemmes',fAgeMiniMariageFemmes);
    fIni.WriteInteger('Coherence','AgeMaxiMariageHommes',fAgeMaxiMariageHommes);
    fIni.WriteInteger('Coherence','AgeMaxiMariageFemmes',fAgeMaxiMariageFemmes);
    fIni.WriteInteger('Coherence','AgeMiniNaissanceEnfantHommes',fAgeMiniNaissanceEnfantHommes);
    fIni.WriteInteger('Coherence','AgeMiniNaissanceEnfantFemmes',fAgeMiniNaissanceEnfantFemmes);
    fIni.WriteInteger('Coherence','AgeMaxiNaissanceEnfantHommes',fAgeMaxiNaissanceEnfantHommes);
    fIni.WriteInteger('Coherence','AgeMaxiNaissanceEnfantFemmes',fAgeMaxiNaissanceEnfantFemmes);
    fIni.WriteInteger('Coherence','AgeMaxiAuDecesHommes',fAgeMaxiAuDecesHommes);
    fIni.WriteInteger('Coherence','AgeMaxiAuDecesFemmes',fAgeMaxiAuDecesFemmes);
    fIni.WriteInteger('Coherence','NbJourEntre2NaissancesNormales',fNbJourEntre2NaissancesNormales);
    fIni.WriteInteger('Coherence','EcartAgeEntreEpoux',fEcartAgeEntreEpoux);

    fIni.WriteBool('Coherence','CheckAgeMiniMariage',fCheckAgeMiniMariage);
    fIni.WriteBool('Coherence','CheckAgeMaxiMariage',fCheckAgeMaxiMariage);
    fIni.WriteBool('Coherence','CheckAgeMiniNaissanceEnfant',fCheckAgeMiniNaissanceEnfant);
    fIni.WriteBool('Coherence','CheckAgeMaxiNaissanceEnfant',fCheckAgeMaxiNaissanceEnfant);
    fIni.WriteBool('Coherence','CheckEsperanceVie',fCheckEsperanceVie);
    fIni.WriteBool('Coherence','CheckEcartAgeEpoux',fCheckEcartAgeEpoux);
    fIni.WriteBool('Coherence','CheckNbJourEntreNaissance',fCheckNbJourEntreNaissance);

      //fichiers 'rtm' des rapports utilis?s
    for k:=_MAX_REP_PATH downto 0 do
    begin//downto utilis? pour que la valeur de fFileNameReport[0] prime celles de k=1 ou 2
          //qui utilisent la m?me clef //AL
      if (fFileNameReport[k]<>'') then
        fIni.WriteString('Reports','FileNameReport'+_REP_PATH_REPORT[k],fFileNameReport[k]);
    end;

  finally
  end;
end;

procedure TContextIni.SaveOnlyIfShould;
begin
  if fShouldSave then SaveIni;
end;

function frGetWindowsVersion: String;
{$IFDEF WIN32}
var Ver: POsVersionInfo;
begin
  new(ver);
  Ver^.dwOSVersionInfoSize := SizeOf(Ver);
  GetVersionEx(Ver);
  with Ver^ do begin
    case dwPlatformId of
      VER_PLATFORM_WIN32s: Result := '32s';
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          dwBuildNumber := dwBuildNumber and $0000FFFF;
          if (dwMajorVersion > 4) or ((dwMajorVersion = 4) and
            (dwMinorVersion >= 10)) then
            Result := '98' else
            Result := '95';
        end;
      VER_PLATFORM_WIN32_NT: Result := 'NT';
    end;
  end;
end;
{$ELSE}
begin
  {$IFDEF LINUX}
  Result:='Linux';
  {$ELSE}
  {$IFDEF CARBON}
  Result:='Mac OSX Carbon';
  {$ELSE}
  {$IFDEF COCOA}
  Result:='iOS';
  {$ELSE}
  {$IFDEF BSD}
  Result:='BSD';
  {$ELSE}
  {$IFDEF UNIX}
  Result:='Unix';
  {$ELSE}
  Result:='Unknown';
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
end;
{$ENDIF}

procedure TContextIni.WindowsVersion;
begin
  fProductName:=frGetWindowsVersion;
end;

end.
