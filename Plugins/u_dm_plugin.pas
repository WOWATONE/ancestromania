unit u_dm_plugin;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
// AncestroWeb
// Plugin libre de création d'un site web généalogique statique en HTML et PHP
// Pour Freelogy et Ancestrologie
// Licence : LGPL
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
  IBQuery, IBSQLMonitor, IBSQL, Dialogs, Forms,
  IBIntf, DB, IBCustomDataSet;


const
  IBQ_NOM = 'NOM';
  IBQ_PRENOM = 'PRENOM';
  IBQ_DLL_DOSSIER = 'dll_DOSSIER';
  NOM_DOSSIER = 'NOM_DOSSIER';

  EQUAL = '=';

  CST_AUTHOR = 'LIBERLOG 2011';

  IBQ_CLE_FICHE = 'CLE_FICHE';
  IBQ_CLE_PERE = 'CLE_PERE';
  IBQ_CLE_MERE = 'CLE_MERE';
  IBQ_ANNEE_NAISSANCE = 'ANNEE_NAISSANCE';
  IBQ_ANNEE_DECES = 'ANNEE_DECES';
  IBQ_VILLE_NAISSANCE = 'VILLE_BIRTH';
  IBQ_VILLE_DECES = 'VILLE_DEATH';
  IBQ_SOSA = 'NUM_SOSA';
  IBQ_SEXE = 'SEXE';
  IBQ_SEXE_MAN = 1;
  IBQ_SEXE_WOMAN = 2;

  IBQ_EV_IND_DESCRIPTION = 'EV_IND_DESCRIPTION';
  IBQ_EV_IND_CP = 'EV_IND_CP';
  IBQ_EV_IND_VILLE = 'EV_IND_VILLE';
  IBQ_EV_IND_LATITUDE = 'EV_IND_LATITUDE';
  IBQ_EV_IND_LONGITUDE = 'EV_IND_LONGITUDE';
  IBQ_EV_IND_DATE = 'EV_IND_DATE';
  IBQ_EV_IND_PAYS = 'EV_IND_PAYS';
  IBQ_IND_CONFIDENTIEL = 'EV_IND_CONFIDENTIEL';

  IBQ_DATE_NAISSANCE = 'DATE_NAISSANCE';
  IBQ_LIEU_NAISSANCE = 'LIEU_NAISSANCE';
  IBQ_DATE_DECES = 'DATE_DECES';
  IBQ_LIEU_DECES = 'LIEU_DECES';

  IBQ_COUNTER = 'COUNTER';

  UNION_DATE_MARIAGE = 'date_prem_fam';
  UNION_MARIAGE_WRITEN = 'date_prem_fam_writen';
  UNION_CP = 'EV_FAM_CP';
  UNION_CITY = 'EV_FAM_VILLE';

  UNION_CLEF = 'UNION_CLEF';
  CLE_DOSSIER = 'CLE_DOSSIER';

  CONJOINT_CLE_ID_UNKNOWN = 'CLE_ID_UNKNOWN';

  MEDIAS_MULTI_MEDIA = 'MULTI_MEDIA';
  MEDIAS_MP_IDENTITE = 'MP_IDENTITE';
  MEDIAS_MP_POINTE_SUR = 'MP_POINTE_SUR';
  MEDIAS_PATH = 'MULTI_PATH';
  MEDIAS_CLEF = 'MULTI_CLEF';
  MEDIAS_NOM = 'MULTI_NOM';
  MEDIAS_TABLE = 'MP_TABLE';
  MEDIAS_MEDIA = 'MP_MEDIA';
  MEDIAS_TYPE = 'MULTI_IMAGE_RTF';

  MEDIAS_TABLE_SOURCE = 'S';
  MEDIAS_TABLE_PERSON = 'I';
  MEDIAS_TABLE_ARCHIV = 'A';
  MEDIAS_TABLE_UNION = 'F';
  MEDIAS_TYPE_IMAGE = 0;
  MEDIAS_TYPE_DOCU = 1;
  MEDIAS_TYPE_VIDEO = 3;
  MEDIAS_TYPE_SON = 2;

  IBQ_CP_LATITUDE = 'CP_LATITUDE';
  IBQ_CP_LONGITUDE = 'CP_LONGITUDE';
  IBQ_CP_VILLE = 'CP_VILLE';

  COUNTING_LABEL = 'LIBELLE';
  COUNTING_COUNTING = 'COMPTAGE';

  CST_INI_ANCESTROWEB_SECTION = 'AncestroWeb';
  CST_INI_ANCESTROWEB_Image = 'Image';
  IBQ_AGE_AU_DECES = 'AGE_AU_DECES';
  IBQ_NIVEAU = 'TQ_NIVEAU';
  IBQ_TQ_SOSA = 'tq_sosa';
  IBQ_TQ_NUM_SOSA = 'tq_num_sosa';

  CST_LOGIE = 'Ancestrologie';
  CST_MANIA = 'Ancestromania';


  I_CLEF = 'I_CLEF';
  I_PAYS = 'I_PAYS';
  I_CP = 'I_CP';
  I_CITY = 'I_CITY';
  I_CLEF_MULTI = 'I_CLEF_MULTI';
  I_NIVEAU = 'I_NIVEAU';
  I_DOSSIER = 'I_DOSSIER';
  I_PARQUI = 'I_PARQUI';
  I_CLEF_UNION = 'I_CLEF_UNION';
  CST_MAP_FILE = 'MapFile';
  CST_MAP_CASE = 'MapCase';
  CST_MAP_NAME = 'AName';
  CST_MAP_CAPTIONS = 'MapCaptions';
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

  CST_INI_PATH_BDD = 'PathFileNameBdd';
  CST_INI_PATH     = 'Path';

type

  { TDMPlugin }

  TDMPlugin = class(TDataModule)
    IBT_BASE: TIBTransaction;
    ibd_BASE: TIBDatabase;
    IBS_DLL: TIBSQL;
    {$IFDEF FPC}
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
  DMPlugin: TDMPlugin = nil;
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
  fonctions_init,fonctions_string;

procedure TDMPlugin.DataModuleCreate(Sender: TObject);
begin
  s_User_Name := 'SYSDBA';
  s_PassWord := 'masterkey';
end;

function TDMPlugin.doOpenDatabase(const sBase: string): boolean;
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
      ShowMessage('Not connected :'+ #13#10 + E.Message);
      Result := False;
    end;
  end;
end;

function TDMPlugin.LitDllDossier: boolean;
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

procedure TDMPlugin.DataModuleDestroy(Sender: TObject);
begin
  //enregistrement du retour dans la table GESTION_DLL inutilisé
  if IBT_BASE.Active then
    try
      IBT_Base.Commit
    except
      IBT_BASE.Rollback;
    end;
  if ibd_BASE.Connected then
    ibd_BASE.Close;
end;

procedure TDMPlugin.p_setCledossier(const AValue: integer);
begin
  if AValue <> fCleDossier then
  begin
    fCleDossier := AValue;
 {   with IBQ_Dossier do
    begin
      Open;
      Locate(CLE_DOSSIER, fCleDossier, []);
      fFolderBasePath := Fields[2].AsString;
      if ( fFolderBasePath > '' )
      and ( fFolderBasePath [ length ( fFolderBasePath ) ] <> DirectorySeparator ) then
        appendstr ( fFolderBasePath, DirectorySeparator );
      if not DirectoryExistsUTF8 ( fFolderBasePath )
        then
         fFolderBasePath := fSoftUserPath ;
      fNom_Dossier := fs_getCorrectString(Fields[1].AsString);
    end; }
  end;
end;

end.
