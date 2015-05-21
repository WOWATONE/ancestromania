unit U_DMWeb;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
// AncestroWeb
// Plugin libre de création d'un site web généalogique statique en HTML et PHP
// Pour Freelogy et Ancestrologie
// Licence : GPL
// LIBERLOG 2011
// Auteur : Matthieu GIROUX
// Descriptions
// Création d'un arbre complet, d'une page de contact en PHP, de fiches, etc.
////////////////////////////////////////////////////////////////////////////////

{--------------------------------------------------------------------------------------------------------
Ce module permets de se connecter a la base d Ancestrologie
Il recois en parametre depuis FMain, le chemin et nom de la base de donnée

Le Query IBS_DLL, vous permet de récuperer
Dossier
Identifiant
Nom
Prenom
de l individu actif dans Ancestrologie
Ancestrologie, mets a jour la table GESTION_DLL à chaque changement d individu

A partir de la vous pouvez faire toutes vos requetes sur la base
--------------------------------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, IBDatabase,
{$IFDEF FPC}
  process,
{$ELSE}
  fonctions_system,
{$ENDIF}
  IBQuery, IBSQL, Dialogs, functions_html,
  fonctions_images;

var
  gt_TabSheets: TaHTMLULTabSheet;
  gi_FilesPerPage: integer = 15;
  gi_FilesPerList: integer = 60;


const
  CST_MAP_FILE = 'MapFile';
  CST_MAP_CASE_END = 'MapCaseEnd';
  CST_MAP_CASE = 'MapCase';
  CST_MAP_NAME = 'AName';
  CST_MAP_CAPTIONS = 'MapCaptions';
  CST_MAP_LINE = 'MapLine';
  CST_MAP_N = 'n';
  CST_MAP_TO = 'To';
  CST_MAP_MIN_LONGITUD = 'MinLongitud';
  CST_MAP_MIN_LATITUD = 'MinLatitud';
  CST_MAP_MAX_LONGITUD = 'MaxLongitud';
  CST_MAP_MAX_LATITUD = 'MaxLatitud';
  CST_MAP_LONGITUD = 'Longitud';
  CST_MAP_LATITUD = 'Latitud';
  CST_MAP_ICON = 'Icon';
  CST_MAP_NAME_CITY = 'NameOrCity';
  CST_MAP_ZOOM = 'Zoom';
  CST_MAP_LITTLE_DOT = 'littleDot';
  CST_MAP_LI_MID_DOT = 'littleMiddleDot';
  CST_MAP_MIDDLE_DOT = 'middleDot';
  CST_MAP_BIG_MID_DOT = 'bigMiddleDot';
  CST_MAP_BIG_DOT = 'bigDot';

  CST_MAP_MAX_ZOOM = 'MaxZoom';
  CST_SUBDIR_THEMES = 'Themes';
  CST_SUBDIR_CLASSES = 'Classes';
  CST_SUBDIR_EXPORT = 'HTML';
  CST_SUBDIR_SAVE = 'Sauve';
  CST_SUBDIR_SOURCES = 'Files';
  CST_SUBDIR_HTML_FILES = 'Files';
  CST_SUBDIR_HTML_FILES_DIR = CST_SUBDIR_HTML_FILES+'/';
  CST_SUBDIR_HTML_LISTS = 'Lists';
  CST_SUBDIR_HTML_ARCHIVE = 'Archive';
  CST_SUBDIR_HTML_IMAGES = 'Images';
  CST_SUBDIR_HTML_CSS = 'Css';
  CST_SUBDIR_HTML_MAILER = 'PhpMailer';
  CST_SUBDIR_HTML_SCRIPTS = 'Scripts';
  CST_SUBDIR_HTML_TREE = 'Tree';
  CST_SUBDIR_HTML_MAPS = 'Maps';
  KLE_DOSSIER = 'KLE_DOSSIER';
  CST_FILE_Home = 'index';
  CST_FILE_BIRTH = 'birth' + CST_EXTENSION_GIF;
  CST_FILE_DEATH = 'death' + CST_EXTENSION_GIF;
  CST_FILE_Button = 'Button';
  CST_FILE_Contact = 'Contact';
  CST_FILE_ContactInBody = 'ContactInsideBody';
  CST_FILE_MapCase = 'MapCase';
  CST_FILE_MapLine = 'MapLine';
  CST_FILE_ContactBefore = 'ContactBeforeHTML';
  CST_FILE_SearchInBody = 'SearchInsideBody';
  CST_FILE_FILES = 'Files';
  CST_FILE_FILE = 'File';
  CST_FILE_LIST = 'Liste';
  CST_FILE_SUBFILES = 'SubFiles';
  CST_FILE_SEARCH = 'Search';
  CST_FILE_AGES = 'Ages';
  CST_FILE_AGES_LINE = 'AgesLine';
  CST_FILE_JOBS = 'Jobs';
  CST_FILE_JOB = 'Job';
  CST_FILE_JOBS_LINE = 'JobsLine';
  CST_FILE_Surnames = 'Names';
  CST_FILE_MAP = 'Map';
  CST_FILE_Number = ' no';
  CST_FILE_UNION = 'union';
  CST_FILE_COUNTING = 'counting';
  CST_FILE_MAN = 'man';
  CST_FILE_WOMAN = 'woman';
  CST_FILE_PERSON = 'person';
  CST_FILE_UPDATE = 'script_update';
  CST_PAGE_PREVIOUS = 'previous';
  CST_PAGE_NEXT = 'next';

  CST_EXTENSION_SQL = '.sql';
  CST_TABLE_TITLE = 'title';
  CST_TABLE_CENTER = 'center';

  // Search page word replace
  CST_SEARCH_SEARCH = 'Search';
  CST_SEARCH_SEARCH_TOOL = 'SearchTool';
  CST_SEARCH_SEARCH_QUER = 'SearchQuery';
  CST_SEARCH_DOMAIN = 'Domain';

  // Ages words' replace
  CST_AGES_LINES = 'Ages_Lines';
  CST_AGES_AN_AGE = 'Age';
  CST_AGES_MEN_COUNT = 'Count_Ages_Men';
  CST_AGES_WOMEN_COUNT = 'Count_Ages_Women';
  CST_AGES_COUNT = 'Count_Ages';

  // Jobs words' replace
  CST_JOBS_LINES = 'Jobs_Lines';
  CST_JOBS_A_JOB = 'Job';
  CST_JOBS_COUNT = 'Count_Jobs';
  CST_JOBS_CITY = 'City';

  CST_ZERO = '0';


  // contact page word replace
  CST_CONTACT_MAIL = 'Mail';
  CST_CONTACT_MAILER = 'Mailer';
  CST_CONTACT_PASSWORD = 'Password';
  CST_CONTACT_USERNAME = 'Username';
  CST_CONTACT_HOST = 'Host';
  CST_CONTACT_LANG = 'Lang';
  CST_CONTACT_SECURITY = 'Security';
  CST_CONTACT_IDENTIFY = 'Identify';
  CST_CONTACT_FILE = 'File';
  CST_CONTACT_PORT = 'Port';
  CST_CONTACT_AUTHOR = 'Author';
  CST_HTML_CONTACT_IN_LANG: array [0..9] of string =
    ('Name', 'Surname', 'MailFrom', 'MailSubject', 'Message', 'Send', 'Reset',
    'SendMessage', 'MailSentMessage', 'Lang');

  // letters' sheet
  CST_HTML_BEGIN_LETTER = 'A';
  CST_HTML_END_LETTER = 'Z';

  CST_HTML_SHADOWBOX = CST_HTML_REL_EQUAL+'"shadowbox"';

type

  { TDMWeb }

  TDMWeb = class(TDataModule)
    ibd_BASE: TIBDatabase;
    IBQ_CountMapAll: TIBQuery;
    IBQ_TreeDescCount: TIBQuery;
    IBQ_TreeMapCount: TIBQuery;
    IBS_City: TIBSQL;
    IBS_MapAll: TIBSQL;
    IBS_Sources_Record: TIBSQL;
    IBS_Jobs: TIBSQL;
    IBS_Compte: TIBSQL;
    IBS_Fiche: TIBSQL;
    IBS_JobsInd: TIBSQL;
    IBQ_Dossier: TIBQuery;
    IBS_Surnames: TIBSQL;
    IBQ_ConjointSources: TIBQuery;
    IBS_Conjoint: TIBSQL;
    IBQ_Medias: TIBQuery;
    IBS_Ages: TIBSQL;
    IBQ_TreeAsc: TIBQuery;
    IBQ_TreeBySurnames: TIBQuery;
    IBQ_TreeDescBySurnames: TIBQuery;
    IBS_TreeMap: TIBSQL;
    IBS_TreeMapDes: TIBSQL;
    IBS_TreeSurnames: TIBSQL;
    IBQ_TreeDesc: TIBQuery;
    IBS_TreeSurnamesDesc: TIBSQL;
    IBS_Temp: TIBSQL;
    IBS_DLL: TIBSQL;
    IBS_UpdateDLL: TIBSQL;
    {$IFDEF FPC}
    Execute:TProcess;
    IBT_BASE: TIBTransaction;
    {$ENDIF}
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure p_setCledossier(const AValue: integer);
  private
    { Déclarations privées }
    fCleDossier: integer;
    s_User_Name, s_PassWord: string;

  public
    { Déclarations publiques }
    function doOpenDatabase(const sBase: string): boolean;
    function LitDllDossier: boolean;
    property CleDossier: integer read fCleDossier write p_setCledossier;

  end;

var
  DMWeb: TDMWeb = nil;
  sDataBaseName: string;
  fNom_Dossier: string;
  fbddpath:String;
  fCleFiche: integer;
  fNomIndi: string;
  fPrenomIndi: string;
  fSoftUserPath: string;
  fFolderBasePath: string;
  gs_Root: string;


implementation

{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}
uses
{$IFNDEF FPC}
  AncestroWeb_strings_delphi,
{$ELSE}
  AncestroWeb_strings,
{$ENDIF}
  fonctions_string,
  u_common_ancestro,
  u_common_functions,u_dm;

procedure TDMWeb.DataModuleCreate(Sender: TObject);
begin
  s_User_Name := 'SYSDBA';
  s_PassWord := 'masterkey';
  IBS_City.Database:=dm.IBBaseParam;
end;

function TDMWeb.doOpenDatabase(const sBase: string): boolean;
begin
  Result := True;
  //f_GetMemIniFile();  on verra sous Linux mais IniFile est déjà initialisé dans le FormCreate
  if IBT_BASE.Active then
    IBT_BASE.Commit;
  if ibd_BASE.Connected then
    ibd_BASE.Close;
  ibd_BASE.DatabaseName := sBase;

  ibd_BASE.Params.Clear;
  ibd_BASE.Params.Add('user_name=' + s_User_Name);
  ibd_BASE.Params.Add('password=' + s_PassWord);
  {$IFDEF FPC}
  ibd_BASE.Params.Add('lc_ctype=UTF8');
  //attention avec champs iso8859_1 "corrompus" dans les bases Ancestro
  {$ENDIF}//delphi: dépend de la version
  try
    ibd_BASE.Open;
    IBT_Base.StartTransaction;
    sDataBaseName := sBase;
  except
    On E: Exception do
    begin
      ShowMessage(fs_getCorrectString(gs_ANCESTROWEB_cantConnect) +
        sDataBaseName + #13#10 + E.Message);
      Result := False;
    end;
  end;
end;

function TDMWeb.LitDllDossier: boolean;
begin
  Result := True;
  try
    IBS_DLL.ExecQuery;
    fCleFiche := IBS_DLL.FieldByName(IBQ_CLE_FICHE).AsInteger;
    fCleDossier := IBS_DLL.FieldByName(IBQ_DLL_DOSSIER).AsInteger;
    fNomIndi := fs_getCorrectString(IBS_DLL.FieldByName(IBQ_NOM).AsString);
    fPrenomIndi := fs_getCorrectString(IBS_DLL.FieldByName(IBQ_PRENOM).AsString);
    fNom_Dossier := fs_getCorrectString(IBS_DLL.FieldByName(NOM_DOSSIER).AsString);
    IBS_DLL.Close;
  except
    On E: Exception do
    begin
      ShowMessage(fs_getCorrectString('Erreur lecture table Dll_Dossier') +
        #13#10 + E.Message);
      Result := False; //chaine à ajouter dans AncestroWeb_strings
    end;
  end;
end;

procedure TDMWeb.DataModuleDestroy(Sender: TObject);
begin
  //enregistrement du retour dans la table GESTION_DLL inutilisé
  with DMWeb,IBT_BASE do
   Begin
    if Active then
      try
        Commit
      except
        Rollback;
      end;
    if ibd_BASE.Connected then
     try
       ibd_BASE.Close;
     Except
       ibd_BASE.Destroy;
     end;
  end;
end;

procedure TDMWeb.p_setCledossier(const AValue: integer);
begin
  if AValue <> fCleDossier then
  begin
    fCleDossier := AValue;
    with IBQ_Dossier do
    begin
      Open;
      Locate(CLE_DOSSIER, fCleDossier, []);
      fNom_Dossier := fs_getCorrectString(Fields[1].AsString);
      fFolderBasePath := Fields[2].AsString;
      if {$IFDEF WINDOWS}(pos(':',fFolderBasePath)<>2) or {$ENDIF}
       ( fFolderBasePath = '' ) Then
        fFolderBasePath:=fSoftUserPath+fNom_Dossier;
    end;
  end;
end;

end.
