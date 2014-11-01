/********************* ROLES **********************/

CREATE ROLE RDB$ADMIN;
/********************* UDFS ***********************/

/****************** GENERATORS ********************/

CREATE GENERATOR BIBLIO_POINTEURS_ID_GEN;
CREATE GENERATOR GEN_ASSOC_CLEF;
CREATE GENERATOR GEN_CONSANG;
CREATE GENERATOR GEN_DOSSIER;
CREATE GENERATOR GEN_EV_FAM_CLEF;
CREATE GENERATOR GEN_EV_IND_CLEF;
CREATE GENERATOR GEN_EX_ARBRES_ID;
CREATE GENERATOR GEN_FAVORIS;
CREATE GENERATOR GEN_INDIVIDU;
CREATE GENERATOR GEN_MEMO_INFOS;
CREATE GENERATOR GEN_MULTIMEDIA;
CREATE GENERATOR GEN_REF_EVENEMENTS;
CREATE GENERATOR GEN_REF_HISTOIRE;
CREATE GENERATOR GEN_REF_PARTICULES;
CREATE GENERATOR GEN_REF_PREFIXES;
CREATE GENERATOR GEN_REF_RACCOURCIS;
CREATE GENERATOR GEN_REF_RELA_CLEF;
CREATE GENERATOR GEN_TOKEN_DATE;
CREATE GENERATOR GEN_TQ_ID;
CREATE GENERATOR GEN_TQ_MEDIA;
CREATE GENERATOR GEN_T_UNION;
CREATE GENERATOR NOM_ATTACHEMENT_ID_GEN;
CREATE GENERATOR SOURCES_RECORD_ID_GEN;
CREATE GENERATOR T_IMPORT_GEDCOM_IG_ID_GEN;
/******************** DOMAINS *********************/

/******************* PROCEDURES ******************/

SET TERM ^ ;
CREATE PROCEDURE F_MAJ (
    S_IN Varchar(255) )
RETURNS (
    S_OUT Varchar(255) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE F_MAJ_SANS_ACCENT (
    S_IN Varchar(255) )
RETURNS (
    S_OUT Varchar(255) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_AGE_TEXTE (
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100) )
RETURNS (
    AGE_TEXTE Varchar(60) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ANC_COMMUNS (
    INDIVIDU1 Integer,
    INDIVIDU2 Integer )
RETURNS (
    COMMUN Integer,
    ENFANT_1 Integer,
    NIVEAU_MIN_1 Integer,
    ENFANT_2 Integer,
    NIVEAU_MIN_2 Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ARBRE_EXPORT (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_DOSSIER Integer,
    I_PARQUI Integer )
RETURNS (
    NIVEAU Integer,
    SOSA Double precision,
    CLE_FICHE Integer,
    CLE_IMPORTATION Varchar(20),
    CLE_PARENTS Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    PREFIXE Varchar(30),
    NOM Varchar(40),
    PRENOM Varchar(60),
    SURNOM Varchar(120),
    SUFFIXE Varchar(30),
    SEXE Integer,
    DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer,
    DATE_DECES Varchar(100),
    ANNEE_DECES Integer,
    DECEDE Integer,
    AGE_AU_DECES Integer,
    SOURCE Blob sub_type 1,
    "COMMENT" Blob sub_type 1,
    FILLIATION Varchar(30),
    NUM_SOSA Double precision,
    OCCUPATION Varchar(90),
    NCHI Integer,
    NMR Integer,
    CLE_FIXE Integer,
    IMPLEXE Double precision,
    DESCENDANT Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ASCEND_DESCEND (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_DOSSIER Integer,
    I_PARQUI Integer )
RETURNS (
    MODE Char(1),
    CLE_FICHE Integer,
    PREFIXE Varchar(30),
    NOM Varchar(40),
    PRENOM Varchar(60),
    SURNOM Varchar(120),
    SUFFIXE Varchar(30),
    SEXE Integer,
    CLE_PARENTS Integer,
    SOURCE Blob sub_type 1,
    "COMMENT" Blob sub_type 1,
    NUM_SOSA Varchar(120),
    NIVEAU Integer,
    FILLIATION Varchar(30),
    CLE_MERE Integer,
    CLE_PERE Integer,
    NCHI Integer,
    NMR Integer,
    CLE_FIXE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ASCEND_ORDONNEE (
    DECUJUS Integer,
    MAX_NIVEAU Smallint,
    MODE_IMPLEXE Smallint )
RETURNS (
    ORDRE Integer,
    NIVEAU Smallint,
    INDI Integer,
    SEXE Smallint,
    CONJOINT Integer,
    ENFANT Integer,
    SOSA Bigint,
    IMPLEXE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_CHERCHE_DOUBLONS (
    I_DOSSIER Integer,
    CLE_IND Integer,
    PRENOM_VARIABLE Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISS Varchar(100),
    LIEU_NAISS Varchar(50),
    DATE_DECES Varchar(100),
    LIEU_DECES Varchar(50) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_COMPTAGE (
    I_DOSSIER Integer )
RETURNS (
    LIBELLE Varchar(7),
    COMPTAGE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_CONJOINTS_ORDONNES (
    INDI Integer,
    C_INCONNU Integer )
RETURNS (
    ORDRE Integer,
    CLEF_UNION Integer,
    CONJOINT Integer,
    CLEF_MARR Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_CONSANG (
    INDIVIDU Integer,
    INDIVIDU2 Integer,
    NIVEAU_CALCUL Integer )
RETURNS (
    CONSANGUINITE Double precision )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_COPIE_DOSSIER (
    DOSSIERS Integer,
    I_DOSSIERC Integer )
RETURNS (
    DOSSIERC Integer,
    LANGUEDIFFERENTE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_DATES_INCOHERENTES (
    I_DOSSIER Integer DEFAULT 1,
    MIN_MAR_HOM Integer DEFAULT 12,
    MIN_MAR_FEM Integer DEFAULT 10,
    MAX_MAR_HOM Integer DEFAULT 85,
    MAX_MAR_FEM Integer DEFAULT 85,
    MIN_ENF_HOM Integer DEFAULT 14,
    MIN_ENF_FEM Integer DEFAULT 16,
    MAX_ENF_HOM Integer DEFAULT 65,
    MAX_ENF_FEM Integer DEFAULT 55,
    MAX_VIE_HOM Integer DEFAULT 95,
    MAX_VIE_FEM Integer DEFAULT 97,
    MAX_ECART_EPOUX Integer DEFAULT 40,
    MIN_ENTRE_ENF Integer DEFAULT 300,
    MAX_ENTRE_JUMEAUX Integer DEFAULT 2,
    MODE Integer DEFAULT 1 )
RETURNS (
    CLEF_IND Integer,
    LIBELLE Varchar(121),
    SEXE Integer,
    AGE Decimal(15,1),
    TITRE Smallint )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_DATE_CODE (
    IAN Integer,
    IMOIS Smallint,
    IJOUR Smallint,
    MODE Smallint,
    CALENDRIER Smallint )
RETURNS (
    DATE_CODE Integer,
    VALIDE Smallint )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_DATE_WRITEN (
    DATE_WRITEN Varchar(100) )
RETURNS (
    IAN Integer,
    IMOIS Smallint,
    IJOUR Smallint,
    DDATE Date,
    DATE_CODE Integer,
    TYPE_TOKEN1 Smallint,
    DATE_CODE_TOT Integer,
    IAN_FIN Integer,
    IMOIS_FIN Smallint,
    IJOUR_FIN Smallint,
    DDATE_FIN Date,
    DATE_CODE_TARD Integer,
    TYPE_TOKEN2 Smallint,
    VALIDE Smallint,
    DATE_WRITEN_S Varchar(100),
    CALENDRIER1 Smallint,
    CALENDRIER2 Smallint )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_DATE_WRITEN_UN (
    DATE_WRITEN Varchar(100),
    LANGUE Varchar(3) )
RETURNS (
    IAN Integer,
    IMOIS Smallint,
    IJOUR Smallint,
    DATE_CODE Integer,
    DDATE Date,
    TOKEN Varchar(30),
    TYPE_TOKEN Smallint,
    DATE_WRITEN_S Varchar(100),
    VALIDE Smallint,
    CALENDRIER Smallint )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_DELTA_DATES (
    NBRJOURS Integer )
RETURNS (
    IANS Integer,
    IMOIS Smallint,
    IJOURS Smallint )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_DERNIER_METIER (
    I_CLEF Integer )
RETURNS (
    OCCUPATION Varchar(90) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_DESCENDANCE (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_DOSSIER Integer )
RETURNS (
    NIVEAU Integer,
    SOSA Varchar(120),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    OCCUPATION Varchar(90),
    CLE_FICHE Integer,
    CLE_IMPORTATION Varchar(20),
    CLE_PARENTS Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    PREFIXE Varchar(30),
    NOM Varchar(40),
    PRENOM Varchar(60),
    SURNOM Varchar(120),
    SUFFIXE Varchar(30),
    SEXE Integer,
    I_DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer,
    I_DATE_DECES Varchar(100),
    ANNEE_DECES Integer,
    DECEDE Integer,
    AGE_AU_DECES Integer,
    SOURCE Blob sub_type 1,
    "COMMENT" Blob sub_type 1,
    FILLIATION Varchar(30),
    NUM_SOSA Double precision,
    ORDRE Varchar(255),
    NCHI Integer,
    NMR Integer,
    CLE_FIXE Integer,
    ASCENDANT Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ECLATE_DESCRIPTION (
    DESCRIPTION Varchar(255),
    SEPARATEUR Char(1) )
RETURNS (
    S_DESCRIPTION Varchar(255) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ECLATE_PRENOM (
    S_PRENOM Varchar(255) )
RETURNS (
    PRENOM Varchar(255) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_AGE_PREM_UNION (
    A_CLE_DOSSIER Integer,
    LIMIT_ON_DATE Integer,
    LIMIT_ON_SOSA Integer,
    YEAR_FROM Integer,
    YEAR_TO Integer,
    INTERVAL Integer )
RETURNS (
    ANNEE_DEBUT Integer,
    ANNEE_FIN Integer,
    FEMMES Integer,
    AGE_FEMMES Decimal(15,2),
    HOMMES Integer,
    AGE_HOMMES Decimal(15,2) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_ANNIV_ORDER (
    A_MOIS Integer,
    I_DOSSIER Integer,
    GET_BIRT Integer,
    GET_DEAT Integer,
    GET_MARR Integer )
RETURNS (
    NOM Varchar(100),
    PRENOM Varchar(100),
    ADATE Varchar(100),
    ANNEE Integer,
    EV_TYPE Varchar(7),
    SEXE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_ASCENDANCE (
    I_CLEF Integer,
    I_GENERATION Integer,
    I_DOSSIER Integer,
    I_PARQUI Integer )
RETURNS (
    GENERATTION Integer,
    SOSA Double precision,
    NOM Varchar(101),
    DATE_NAISSANCE Varchar(100),
    CP_NAISSANCE Varchar(10),
    VILLE_NAISSANCE Varchar(50),
    LIEU_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    CP_DECES Varchar(10),
    VILLE_DECES Varchar(50),
    LIEU_DECES Varchar(100),
    SEXE Integer,
    AGE Integer,
    CLE_FICHE Integer,
    IMPLEXE Double precision,
    DATE_MARIAGE Varchar(100),
    CP_MARIAGE Varchar(10),
    VILLE_MARIAGE Varchar(50),
    NUM_SOSA Double precision )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_DENOMB_ASCEND (
    A_CLE_FICHE Integer )
RETURNS (
    NIVEAU Integer,
    TOTAL_INDI Integer,
    TOTAL_INDI_DISTINCT Integer,
    TOTAL_INDI_THEORIQUE Double precision,
    CUMUL_INDI Integer,
    CUMUL_INDI_DISTINCT Integer,
    CUMUL_INDI_THEORIQUE Double precision,
    POURCENT_IMPLEXE Double precision )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_DENOMB_DESCEND (
    A_CLE_FICHE Integer )
RETURNS (
    NIVEAU Integer,
    TOTAL_INDI Integer,
    TOTAL_INDI_DISTINCT Integer,
    CUMUL_INDI Integer,
    CUMUL_INDI_DISTINCT Integer,
    POURCENT_IMPLEXE Double precision )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_DESCENDANCE (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_DOSSIER Integer )
RETURNS (
    NIVEAU Integer,
    SOSA Varchar(120),
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    AGE Integer,
    ORDRE Varchar(255),
    CLE_NAISSANCE Integer,
    VILLE_NAISSANCE Varchar(50),
    CP_NAISSANCE Varchar(10),
    DEPT_NAISSANCE Varchar(30),
    PAYS_NAISSANCE Varchar(30),
    CODE_DEPT_NAISSANCE Varchar(2),
    CLE_DECES Integer,
    VILLE_DECES Varchar(50),
    CP_DECES Varchar(10),
    DEPT_DECES Varchar(30),
    PAYS_DECES Varchar(30),
    CODE_DEPT_DECES Varchar(2),
    OCCUPATION Varchar(90),
    CLE_CONJOINT Integer,
    NOM_CONJOINT Varchar(40),
    PRENOM_CONJOINT Varchar(60),
    CLE_NAISSANCE_CONJOINT Integer,
    DATE_NAISSANCE_CONJOINT Varchar(100),
    VILLE_NAISSANCE_CONJOINT Varchar(50),
    CP_NAISSANCE_CONJOINT Varchar(10),
    DEPT_NAISSANCE_CONJOINT Varchar(30),
    PAYS_NAISSANCE_CONJOINT Varchar(30),
    CODE_DEPT_NAISSANCE_CONJOINT Varchar(2),
    CLE_DECES_CONJOINT Integer,
    DATE_DECES_CONJOINT Varchar(100),
    VILLE_DECES_CONJOINT Varchar(50),
    CP_DECES_CONJOINT Varchar(10),
    DEPT_DECES_CONJOINT Varchar(30),
    PAYS_DECES_CONJOINT Varchar(30),
    CODE_DEPT_DECES_CONJOINT Varchar(2),
    OCCUPATION_CONJOINT Varchar(90),
    CLE_MARIAGE Integer,
    DATE_MARIAGE Varchar(100),
    VILLE_MARIAGE Varchar(100),
    CP_MARIAGE Varchar(10),
    DEPT_MARIAGE Varchar(30),
    PAYS_MARIAGE Varchar(30),
    CODE_DEPT_MARIAGE Varchar(2),
    CLE_UNION Integer,
    ORDRE_UNION Integer,
    ISSU_UNION Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_ECLAIR (
    I_DOSSIER Integer,
    I_SOSA Integer,
    A_VILLE Varchar(50) )
RETURNS (
    NOM Varchar(40),
    CP Varchar(10),
    VILLE Varchar(50),
    PAYS Varchar(30),
    DATE_DEBUT Integer,
    DATE_FIN Integer,
    NAISSANCE Integer,
    BAPTEME Integer,
    MARIAGE Integer,
    DECES Integer,
    SEP Integer,
    INSEE Varchar(6),
    DEPT Varchar(30),
    REGION Varchar(50) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_FICHE (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    LIEU_NAISSANCE Varchar(210),
    DATE_DECES Varchar(100),
    LIEU_DECES Varchar(210),
    SEXE Integer,
    FILLIATION Varchar(30),
    "COMMENT" Blob sub_type 1,
    PERE_NOM Varchar(120),
    PERE_NAISSANCE Varchar(100),
    PERE_LIEU_NAISSANCE Varchar(210),
    PERE_DECES Varchar(100),
    PERE_LIEU_DECES Varchar(210),
    MERE_NOM Varchar(120),
    MERE_NAISSANCE Varchar(100),
    MERE_LIEU_NAISSANCE Varchar(210),
    MERE_DECES Varchar(100),
    MERE_LIEU_DECES Varchar(210),
    PHOTO Blob sub_type 0,
    PREFIXE Varchar(30),
    SUFFIXE Varchar(30),
    SURNOM Varchar(120),
    NUM_SOSA Double precision,
    SOSA1_NOMPRENOM Varchar(105),
    SOSAS Varchar(30),
    SOSAS_PERE Varchar(30),
    SOSAS_MERE Varchar(30),
    AGE_DECES Varchar(60),
    AGE_DECES_PERE Varchar(60),
    AGE_DECES_MERE Varchar(60) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_FICHE_FAMILIALE (
    ACLE_UNION Integer )
RETURNS (
    A_EPOUX_CLE Integer,
    A_EPOUX_NOMPRENOM Varchar(105),
    A_EPOUX_NAISSANCE Varchar(100),
    A_EPOUX_LIEU_NAISSANCE Varchar(166),
    A_EPOUX_DECES Varchar(100),
    A_EPOUX_LIEU_DECES Varchar(166),
    A_EPOUSE_CLE Integer,
    A_EPOUSE_NOMPRENOM Varchar(105),
    A_EPOUSE_NAISSANCE Varchar(100),
    A_EPOUSE_LIEU_NAISSANCE Varchar(166),
    A_EPOUSE_DECES Varchar(100),
    A_EPOUSE_LIEU_DECES Varchar(166),
    A_EPOUX_PHOTO Blob sub_type 0,
    A_EPOUSE_PHOTO Blob sub_type 0,
    A_EPOUX_PERE_NOM Varchar(40),
    A_EPOUX_PERE_PRENOM Varchar(60),
    A_EPOUX_MERE_NOM Varchar(40),
    A_EPOUX_MERE_PRENOM Varchar(60),
    A_EPOUSE_PERE_NOM Varchar(40),
    A_EPOUSE_PERE_PRENOM Varchar(60),
    A_EPOUSE_MERE_NOM Varchar(40),
    A_EPOUSE_MERE_PRENOM Varchar(60),
    A_EPOUX_ANNEE Integer,
    A_EPOUSE_ANNEE Integer,
    A_EPOUX_SOSA Double precision,
    A_EPOUSE_SOSA Double precision,
    A_SOSA1_NOMPRENOM Varchar(105),
    A_EPOUX_NOM Varchar(40),
    A_EPOUSE_NOM Varchar(40),
    SOSAS_EPOUX Varchar(30),
    SOSAS_EPOUSE Varchar(30),
    A_EPOUX_AGE Varchar(60),
    A_EPOUSE_AGE Varchar(60) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_LONGEVITE (
    A_CLE_DOSSIER Integer,
    LIMIT_ON_DATE Integer,
    LIMIT_ON_SOSA Integer,
    YEAR_FROM Integer,
    YEAR_TO Integer,
    INTERVAL Integer )
RETURNS (
    INTERVAL_START Integer,
    INTERVAL_END Integer,
    NB_HOMME Integer,
    MOYENNE_AGE_HOMME Double precision,
    ECART_TYPE_AGE_HOMME Double precision,
    NB_FEMME Integer,
    MOYENNE_AGE_FEMME Double precision,
    ECART_TYPE_AGE_FEMME Double precision )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_NB_ENFANT_UNION (
    A_CLE_DOSSIER Integer,
    LIMIT_ON_DATE Integer,
    LIMIT_ON_SOSA Integer,
    YEAR_FROM Integer,
    YEAR_TO Integer,
    INTERVAL Integer )
RETURNS (
    INTERVAL_START Integer,
    INTERVAL_END Integer,
    NB_UNION Integer,
    NB_ENFANTS Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_ETAT_RECENSEMENT (
    A_CLE_DOSSIER Integer,
    LIMIT_ON_DATE Integer,
    LIMIT_ON_SOSA Integer,
    YEAR_FROM Integer,
    YEAR_TO Integer,
    INTERVAL Integer,
    LONGEVITE_H Integer,
    LONGEVITE_F Integer )
RETURNS (
    ANNEE Integer,
    NOMBRE_INDIVIDUS Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_EVE_IND (
    I_CLE Integer )
RETURNS (
    EV_IND_CLEF Integer,
    EV_IND_KLE_FICHE Integer,
    EV_IND_KLE_DOSSIER Integer,
    EV_IND_TYPE Varchar(7),
    EV_IND_DATE_WRITEN Varchar(100),
    EV_IND_DATE_YEAR Integer,
    EV_IND_DATE Date,
    EV_IND_ADRESSE Varchar(50),
    EV_IND_CP Varchar(10),
    EV_IND_VILLE Varchar(50),
    EV_IND_DEPT Varchar(30),
    EV_IND_PAYS Varchar(30),
    EV_IND_CAUSE Varchar(90),
    EV_IND_SOURCE Blob sub_type 1,
    EV_IND_COMMENT Blob sub_type 1,
    EV_IND_TYPEANNEE Integer,
    EV_IND_DESCRIPTION Varchar(90),
    EV_IND_REGION Varchar(50),
    EV_IND_SUBD Varchar(50),
    EV_LIBELLE Varchar(30),
    EV_IND_ACTE Integer,
    EV_IND_INSEE Varchar(6),
    EV_IND_HEURE Time,
    EV_IND_ORDRE Integer,
    EV_IND_TITRE_EVENT Varchar(40),
    EV_IND_LATITUDE Decimal(15,8),
    EV_IND_LONGITUDE Numeric(15,8),
    EV_IND_MEDIA Integer,
    EV_IND_AGE Integer,
    EV_IND_DETAILS Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_EXPORT_IMAGES (
    I_DOSSIER Integer )
RETURNS (
    MULTI_CLEF Integer,
    NOM Varchar(105),
    MULTI_MEDIA Blob sub_type 0,
    FORMAT Varchar(4),
    MULTI_PATH Varchar(255) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_GESTION_DLL
RETURNS (
    DOSSIER Integer,
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    OPEN_BASE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_GET_CLEF_UNIQUE (
    A_TABLE Varchar(30) )
RETURNS (
    CLE_UNIQUE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_GROUPE (
    I_GROUPE Integer,
    I_INDIVIDU Integer,
    MODE Varchar(1),
    STRICTE Varchar(1),
    TEMOINS Varchar(1),
    INITIALISATION Varchar(1),
    EFFET Varchar(1),
    VERBOSE Varchar(1) )
RETURNS (
    INFO Varchar(50) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_INCOHERENCES (
    I_KLE_DOSSIER Integer,
    I_MODE Integer )
RETURNS (
    O_TABLE Varchar(30),
    O_CLE_TABLE Integer,
    O_CLE_FICHE Integer,
    O_LIBELLE Varchar(160) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_INSERT_FAVORIS (
    I_DOSSIER Integer,
    I_CLE Integer,
    I_NBRE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_JOURS_TEXTE (
    ANS Integer,
    MOIS Integer,
    JOURS Integer,
    PRECIS Smallint )
RETURNS (
    JOURS_TEXTE Varchar(25) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_LISTE_PARENTE (
    INDI1 Integer,
    INDI2 Integer )
RETURNS (
    ANCETRE_1 Integer,
    NOM_1 Varchar(130),
    SEXE_1 Integer,
    SOSA_1 Integer,
    ANCETRE_2 Integer,
    NOM_2 Varchar(130),
    SEXE_2 Integer,
    SOSA_2 Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_LISTE_PRENOM (
    I_DOSSIER Integer )
RETURNS (
    PRENOM Varchar(60),
    SEXE Integer,
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM_COMPLET Varchar(60),
    CLE_PERE Integer,
    CLE_MERE Integer,
    DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_LISTE_PROFESSION (
    I_DOSSIER Integer )
RETURNS (
    PROFESSION Varchar(90),
    CLE_FICHE Integer,
    SEXE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer,
    DATE_DECES Varchar(100),
    ANNEE_DECES Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    DESCRIPTION Varchar(90),
    DATE_PROFESSION Varchar(100),
    ANNEE_PROFESSION Integer,
    VILLE_PROFESSION Varchar(50),
    DEPT_PROFESSION Varchar(30) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_LISTE_UNIONS (
    I_DOSSIER Integer )
RETURNS (
    UNION_CLE Integer,
    MARI_CLE Integer,
    MARI_NOM Varchar(40),
    MARI_PRENOM Varchar(60),
    MARI_NUM_SOSA Double precision,
    AGE_MARI Integer,
    FEMME_CLE Integer,
    FEMME_NOM Varchar(40),
    FEMME_PRENOM Varchar(60),
    FEMME_NUM_SOSA Double precision,
    AGE_FEMME Integer,
    CLE_MARR Integer,
    DATE_MARR Varchar(100),
    AN_MARR Integer,
    MOIS_MARR Integer,
    DATE_UNION Date,
    SUBD Varchar(50),
    VILLE Varchar(50),
    DEPT Varchar(30),
    REGION Varchar(50),
    PAYS Varchar(30) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_MAJ_TAGS
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_NAVIGATION (
    I_CLEF Integer,
    I_MAX Integer )
RETURNS (
    NIVEAU Integer,
    CLE_FICHE Integer,
    NOM Varchar(60),
    PRENOM Varchar(100),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Double precision,
    DECEDE Integer,
    VILLE_NAISSANCE Varchar(50),
    VILLE_DECES Varchar(50),
    PROFESSION Varchar(90),
    DATE_UNION Varchar(90),
    VILLE_UNION Varchar(50),
    PHOTO Blob sub_type 0,
    ENFANTS Integer,
    NUM_SOSA Double precision,
    PERIODE_VIE Varchar(15) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_NEW_PRENOMS (
    I_DOSSIER Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_PREP_PRENOMS (
    I_DOSSIER Integer )
RETURNS (
    PRENOM Varchar(60),
    SEXE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_PREP_PROFESSIONS (
    I_DOSSIER Integer )
RETURNS (
    PROFESSION Varchar(90) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_PREP_VILLES_FAVORIS (
    I_DOSSIER Integer )
RETURNS (
    EV_IND_VILLE Varchar(50),
    EV_IND_CP Varchar(10),
    EV_IND_DEPT Varchar(30),
    EV_IND_REGION Varchar(50),
    EV_IND_PAYS Varchar(30),
    EV_IND_INSEE Varchar(6),
    EV_IND_SUBD Varchar(50),
    EV_IND_LATITUDE Decimal(15,8),
    EV_IND_LONGITUDE Numeric(15,8) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_PREP_VILLES_RAYON (
    LIMITE Double precision,
    LATITUDEA Double precision,
    LONGITUDEA Double precision,
    I_DOSSIER Integer )
RETURNS (
    CP_CODE Integer,
    CP_CP Varchar(8),
    CP_PREFIXE Varchar(4),
    CP_VILLE Varchar(103),
    CP_INDIC_TEL Varchar(2),
    CP_DEPT Integer,
    CP_REGION Integer,
    CP_PAYS Integer,
    CP_INSEE Varchar(6),
    CP_HABITANTS Double precision,
    CP_DENSITE Double precision,
    CP_DIVERS Varchar(90),
    CP_LATITUDE Double precision,
    CP_LONGITUDE Double precision,
    CP_MAJ_INSEE Integer,
    CP_VILLE_MAJ Varchar(50),
    DISTANCE Double precision,
    DEPARTEMENT Varchar(30),
    REGION Varchar(50),
    PAYS Varchar(30) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_PURGE_IMPORT_GEDCOM (
    I_CLEF Integer,
    I_MODE Integer )
RETURNS (
    INFO Varchar(50) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_RENUM_SOSA (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_DOSSIER Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_SEPARATION_PRENOMS (
    I_DOSSIER Integer,
    I_VIRGULE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_SOSAS (
    I_CLEF Integer )
RETURNS (
    SOSAS Varchar(30) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_SUIVANT (
    IND_ORIGINE Integer,
    DELTA Integer )
RETURNS (
    CLE_FICHE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TEST_ASC (
    INDI1 Integer,
    INDI2 Integer,
    IGNORENFANT Integer DEFAULT 0 )
RETURNS (
    NIVEAU Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TEST_DESC (
    INDI1 Integer,
    INDI2 Integer,
    IGNORENFANT Integer DEFAULT 0 )
RETURNS (
    NIVEAU Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TEST_PARENTE (
    INDI1 Integer,
    INDI2 Integer,
    NIVEAU_MAX Integer )
RETURNS (
    OUI Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TQ_ASCENDANCE (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_PARQUI Integer,
    I_MODE Integer )
RETURNS (
    TQ_NIVEAU Integer,
    TQ_CLE_FICHE Integer,
    TQ_SOSA Double precision,
    TQ_DOSSIER Integer,
    IMPLEXE Double precision,
    TQ_DESCENDANT Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TQ_DESCENDANCE (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_PARQUI Integer,
    I_MODE Integer )
RETURNS (
    TQ_NIVEAU Integer,
    TQ_CLE_FICHE Integer,
    TQ_SOSA Varchar(120),
    TQ_CLE_PERE Integer,
    TQ_CLE_MERE Integer,
    TQ_NUM_SOSA Varchar(120),
    TQ_ASCENDANT Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_CONJOINTS (
    I_DOSSIER Integer,
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(60),
    PRENOM Varchar(100),
    DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer,
    DATE_DECES Varchar(100),
    ANNEE_DECES Integer,
    SEXE Integer,
    TYPE_UNION Integer,
    UNION_CLEF Integer,
    SOSA Double precision,
    DATE_MARIAGE Varchar(100),
    ANNEE_MARIAGE Integer,
    CLE_MARIAGE Integer,
    ORDRE_UNION Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_COUSINS_COUSINES (
    I_CLEF Integer,
    I_DOSSIER Integer,
    I_MAX Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    SEXE Integer,
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Double precision )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_DOSSIER (
    I_CLE Integer,
    I_NOM Varchar(30),
    I_INFOS Varchar(254),
    I_LANGUE Varchar(3) )
RETURNS (
    CLE_DOSSIER Integer,
    NOM_DOSSIER Varchar(30),
    DERNIER Integer,
    LANGUE Varchar(3),
    PATH_IMAGES Varchar(254),
    FIC_NOTES Varchar(254),
    INDICATEURS Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_ENFANTS (
    A_CLE_PERE Integer,
    A_CLE_MERE Integer,
    I_DOSSIER Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    SEXE Integer,
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    KLE_DOSSIER Integer,
    SOSA Double precision,
    PHOTO Blob sub_type 0,
    VILLE_NAISS Varchar(166),
    VILLE_DECES Varchar(166),
    ANNEE Integer,
    ANNEE_DECES Integer,
    AGE_DECES Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSAS Varchar(30),
    AGE_PERE Varchar(60),
    AGE_MERE Varchar(60),
    AGE_DECES_TEXTE Varchar(60) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_FRERES_SOEURS (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    F_1 Integer,
    DECEDE Integer,
    NUM_SOSA Double precision,
    ANNEE_NAISSANCE Integer,
    ANNEE_DECES Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_GRANDS_PARENT (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Integer,
    DECEDE Integer,
    NUM_SOSA Double precision,
    ANNEE_NAISSANCE Integer,
    ANNEE_DECES Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_IND_PAR_LETTRE (
    A_LETTRE Varchar(1),
    I_DOSSIER Integer )
RETURNS (
    NOM Varchar(40) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_MERE (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_ONCLES_TANTES (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    SEXE Integer,
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Double precision,
    DECEDE Integer,
    NUM_SOSA Double precision,
    ANNEE_NAISSANCE Integer,
    ANNEE_DECES Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_PARENTS (
    I_CLEF Integer,
    I_DOSSIER Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM_PERE Varchar(40),
    PRENOM_PERE Varchar(60),
    PERE_CLE_FICHE Integer,
    PERE_NAISSANCE Varchar(100),
    PERE_DECES Varchar(100),
    PERE_SOSA Double precision,
    NOM_MERE Varchar(40),
    PRENOM_MERE Varchar(60),
    MERE_CLE_FICHE Integer,
    MERE_NAISSANCE Varchar(100),
    MERE_DECES Varchar(100),
    MERE_SOSA Double precision,
    PERE_ANNEE Integer,
    MERE_ANNEE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_PERE (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_TROUVE_UNIONS (
    I_DOSSIER Integer,
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer,
    DATE_DECES Varchar(100),
    ANNEE_DECES Integer,
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    NUM_SOSA Double precision,
    TYPE_UNION Integer,
    UNION_CLEF Integer,
    ANNEE_MARIAGE Integer,
    DECEDE Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_VIDE_BASE
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_VIDE_DOSSIER (
    I_CLEF Integer )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

/******************** TABLES **********************/

CREATE TABLE ADRESSES_IND
(
  ADR_CLEF Integer NOT NULL,
  ADR_KLE_DOSSIER Integer NOT NULL,
  ADR_KLE_IND Integer NOT NULL,
  ADR_ADRESSE Blob sub_type 1,
  ADR_CP Varchar(10),
  ADR_VILLE Varchar(50),
  ADR_DEPT Varchar(30),
  ADR_REGION Varchar(50),
  ADR_PAYS Varchar(30),
  ADR_TEL Blob sub_type 1,
  ADR_MAIL Varchar(250),
  ADR_DATE_WRITEN Varchar(100),
  ADR_DATE_YEAR_1 Integer,
  ADR_DATE_YEAR_2 Integer,
  ADR_DATE_1 Date,
  ADR_DATE_2 Date,
  ADR_INSEE Varchar(6),
  ADR_PHOTO Varchar(255),
  ADR_WEB Varchar(120),
  ADR_MEMO Blob sub_type 1,
  ADR_DATE_MOIS_1 Integer,
  ADR_DATE_MOIS_2 Integer,
  ADR_LATITUDE Decimal(15,8),
  ADR_LONGITUDE Numeric(15,8),
  ADR_SUBD Varchar(50),
  CONSTRAINT PK_ADRESSES_IND PRIMARY KEY (ADR_CLEF)
);
CREATE TABLE DOSSIER
(
  CLE_DOSSIER Integer NOT NULL,
  NOM_DOSSIER Varchar(30),
  DS_VERROU Integer NOT NULL,
  DS_BASE_PATH Varchar(254),
  DS_INFOS Varchar(254),
  DS_OUVERTURE Timestamp,
  DS_FERMETURE Timestamp,
  DS_LAST Integer,
  DS_FIC_NOTES Varchar(254),
  DS_LANGUE Varchar(3) DEFAULT 'FRA',
  DS_INDICATEURS Integer DEFAULT 0 NOT NULL,
  CONSTRAINT PK_DOSSIER PRIMARY KEY (CLE_DOSSIER)
);
CREATE TABLE EVENEMENTS_FAM
(
  EV_FAM_CLEF Integer NOT NULL,
  EV_FAM_KLE_FAMILLE Integer,
  EV_FAM_KLE_DOSSIER Integer,
  EV_FAM_TYPE Varchar(7),
  EV_FAM_DATE_WRITEN Varchar(100),
  EV_FAM_DATE_YEAR Integer,
  EV_FAM_DATE Date,
  EV_FAM_ADRESSE Varchar(50),
  EV_FAM_CP Varchar(10),
  EV_FAM_VILLE Varchar(50),
  EV_FAM_DEPT Varchar(30),
  EV_FAM_PAYS Varchar(30),
  EV_FAM_SOURCE Blob sub_type 1,
  EV_FAM_COMMENT Blob sub_type 1,
  EV_FAM_REGION Varchar(50),
  EV_FAM_SUBD Varchar(50),
  EV_FAM_ACTE Integer,
  EV_FAM_INSEE Varchar(6),
  EV_FAM_ORDRE Integer,
  EV_FAM_HEURE Time,
  EV_FAM_TITRE_EVENT Varchar(25),
  ID_IMPORT_GEDCOM Integer,
  EV_FAM_DATE_MOIS Integer,
  EV_FAM_DATE_MOIS_FIN Integer,
  EV_FAM_DATE_YEAR_FIN Integer,
  EV_FAM_LATITUDE Decimal(15,8),
  EV_FAM_LONGITUDE Numeric(15,8),
  EV_FAM_DESCRIPTION Varchar(90),
  EV_FAM_CAUSE Varchar(90),
  EV_FAM_DATE_JOUR Smallint,
  EV_FAM_DATECODE Integer,
  EV_FAM_DATE_JOUR_FIN Smallint,
  EV_FAM_DATECODE_TOT Integer,
  EV_FAM_DATECODE_TARD Integer,
  EV_FAM_TYPE_TOKEN1 Smallint,
  EV_FAM_TYPE_TOKEN2 Smallint,
  EV_FAM_CALENDRIER1 Smallint,
  EV_FAM_CALENDRIER2 Smallint,
  CONSTRAINT PK_EVENEMENTS_FAM PRIMARY KEY (EV_FAM_CLEF)
);
CREATE TABLE EVENEMENTS_IND
(
  EV_IND_CLEF Integer NOT NULL,
  EV_IND_KLE_FICHE Integer,
  EV_IND_KLE_DOSSIER Integer,
  EV_IND_TYPE Varchar(7),
  EV_IND_DATE_WRITEN Varchar(100),
  EV_IND_DATE_YEAR Integer,
  EV_IND_DATE Date,
  EV_IND_ADRESSE Varchar(50),
  EV_IND_CP Varchar(10),
  EV_IND_VILLE Varchar(50),
  EV_IND_DEPT Varchar(30),
  EV_IND_PAYS Varchar(30),
  EV_IND_CAUSE Varchar(90),
  EV_IND_SOURCE Blob sub_type 1,
  EV_IND_COMMENT Blob sub_type 1,
  EV_IND_TYPEANNEE Integer,
  EV_IND_DESCRIPTION Varchar(90),
  EV_IND_REGION Varchar(50),
  EV_IND_SUBD Varchar(50),
  EV_IND_ACTE Integer,
  EV_IND_INSEE Varchar(6),
  EV_IND_ORDRE Integer,
  EV_IND_HEURE Time,
  EV_IND_TITRE_EVENT Varchar(25),
  EV_IND_DATE_MOIS Integer,
  EV_IND_DATE_MOIS_FIN Integer,
  EV_IND_DATE_YEAR_FIN Integer,
  EV_IND_LATITUDE Decimal(15,8),
  EV_IND_LONGITUDE Numeric(15,8),
  EV_IND_LIGNES_ADRESSE Blob sub_type 1,
  EV_IND_TEL Blob sub_type 1,
  EV_IND_MAIL Varchar(120),
  EV_IND_WEB Varchar(120),
  EV_IND_DATE_JOUR Smallint,
  EV_IND_DATECODE Integer,
  EV_IND_DATE_JOUR_FIN Smallint,
  EV_IND_DATECODE_TOT Integer,
  EV_IND_DATECODE_TARD Integer,
  EV_IND_TYPE_TOKEN1 Smallint,
  EV_IND_TYPE_TOKEN2 Smallint,
  EV_IND_CALENDRIER1 Smallint,
  EV_IND_CALENDRIER2 Smallint,
  CONSTRAINT PK_EVENEMENTS_IND PRIMARY KEY (EV_IND_CLEF)
);
CREATE TABLE EX_ARBRES
(
  AR_ID Integer NOT NULL,
  AR_LIBELLE Varchar(40),
  AR_IMAGE Varchar(254),
  AR_TAB1_GENE Smallint,
  AR_TAB1_STYL Smallint,
  AR_TAB1_TYPE Smallint,
  AR_TAB1_IMPR Smallint,
  AR_TAB1_DESC Blob sub_type 1,
  AR_TAB2_POS Varchar(80),
  AR_TAB3_NOM Smallint,
  AR_TAB3_PREN Smallint,
  AR_TAB3_METI Smallint,
  AR_TAB3_NAIS Smallint,
  AR_TAB3_DECE Smallint,
  AR_TAB3_PHOT Smallint,
  AR_TAB3_NPRE Smallint,
  AR_TAB3_DNOM Smallint,
  AR_TAB3_DPRE Smallint,
  AR_TAB3_DMET Smallint,
  AR_TAB3_DNAI Smallint,
  AR_TAB3_DDEC Smallint,
  AR_TAB3_POLH Varchar(80),
  AR_TAB3_POLF Varchar(80),
  AR_TAB3_HCOL Integer,
  AR_TAB3_FCOL Integer,
  AR_TAB4_FIMA Varchar(64),
  AR_TAB4_FBOR Smallint,
  AR_TAB4_FTYP Smallint,
  AR_TAB4_FEPA Smallint,
  AR_TAB4_FFON Smallint,
  AR_TAB4_HIMA Varchar(64),
  AR_TAB4_HBOR Smallint,
  AR_TAB4_HTYP Smallint,
  AR_TAB4_HEPA Smallint,
  AR_TAB4_HFON Smallint,
  AR_TAB4_LIMA Varchar(64),
  AR_TAB4_LBOR Smallint,
  AR_TAB4_LTYP Smallint,
  AR_TAB4_LEPA Smallint,
  AR_TAB4_BLBO Smallint,
  AR_TAB4_BHBO Smallint,
  AR_TAB4_BEGE Smallint,
  AR_TAB4_BEIN Smallint,
  AR_TAB4_ACGA Smallint,
  AR_TAB4_ADCH Smallint,
  AR_TAB3_PHPH Smallint,
  AR_TAB3_PHGA Smallint,
  AR_TAB3_PHLA Smallint,
  AR_TAB3_PHHA Smallint,
  AR_TAB3_HCBB Integer,
  AR_TAB3_FCBB Integer,
  AR_TAB3_LCBB Integer,
  AR_TAB1_AASC Smallint,
  AR_TAB1_ADES Smallint,
  AR_TAB3_DATU Smallint,
  AR_TAB3_UNIO Smallint,
  AR_TAB3_LNAI Smallint,
  AR_TAB3_DLNA Smallint,
  AR_TAB3_LDEC Smallint,
  AR_TAB3_DLDE Smallint,
  AR_TAB3_IMPL Smallint,
  AR_TAB3_DIMP Smallint,
  AR_LIBRE_1 Smallint,
  AR_LIBRE_2 Smallint,
  AR_LIBRE_3 Smallint,
  AR_LIBRE_4 Smallint,
  AR_LIBRE_5 Smallint,
  AR_LIBRE_6 Smallint,
  AR_LIBRE_7 Varchar(40),
  AR_LIBRE_8 Varchar(40),
  AR_LIBRE_9 Varchar(40),
  AR_LIBRE_10 Varchar(40),
  AR_LIBRE_11 Varchar(40),
  AR_LIBRE_12 Varchar(40),
  CONSTRAINT PK_EX_ARBRES PRIMARY KEY (AR_ID)
);
CREATE TABLE FAVORIS
(
  ID Integer NOT NULL,
  KLE_DOSSIER Integer,
  KLE_FICHE Integer,
  CONSTRAINT PK_FAVORIS PRIMARY KEY (ID)
);
CREATE TABLE GESTION_DLL
(
  DLL_INDI Integer NOT NULL,
  DLL_DOSSIER Integer NOT NULL,
  DLL_RETOUR Varchar(240),
  DLL_OPEN_BASE Smallint
);
CREATE TABLE INDIVIDU
(
  CLE_FICHE Integer NOT NULL,
  KLE_DOSSIER Integer,
  CLE_IMPORTATION Varchar(20),
  CLE_PARENTS Integer,
  CLE_PERE Integer,
  CLE_MERE Integer,
  PREFIXE Varchar(30),
  NOM Varchar(40),
  PRENOM Varchar(60),
  SURNOM Varchar(120),
  SUFFIXE Varchar(30),
  SEXE Integer,
  DATE_NAISSANCE Varchar(100),
  ANNEE_NAISSANCE Integer,
  DATE_DECES Varchar(100),
  ANNEE_DECES Integer,
  DECEDE Integer,
  SOURCE Blob sub_type 1,
  "COMMENT" Blob sub_type 1,
  FILLIATION Varchar(30),
  NUM_SOSA Double precision,
  DATE_MODIF Timestamp,
  DATE_CREATION Timestamp,
  MODIF_PAR_QUI Varchar(30),
  NCHI Smallint,
  NMR Smallint,
  CLE_FIXE Integer,
  CONSANGUINITE Double precision,
  ID_IMPORT_GEDCOM Integer,
  INDI_TRIE_NOM Varchar(110),
  TYPE_LIEN_GENE Integer,
  IND_CONFIDENTIEL Smallint,
  CONSTRAINT PK_INDIVIDU PRIMARY KEY (CLE_FICHE)
);
CREATE GLOBAL TEMPORARY TABLE LIEUX_FAVORIS
(
  VILLE Varchar(50),
  SUBD Varchar(50),
  CP Varchar(10),
  DEPT Varchar(30),
  REGION Varchar(50),
  PAYS Varchar(30),
  INSEE Varchar(6),
  LATITUDE Decimal(15,8),
  LONGITUDE Numeric(15,8)
)
ON COMMIT PRESERVE ROWS;
CREATE TABLE MEDIA_POINTEURS
(
  MP_CLEF Integer NOT NULL,
  MP_MEDIA Integer NOT NULL,
  MP_CLE_INDIVIDU Integer NOT NULL,
  MP_POINTE_SUR Integer NOT NULL,
  MP_TABLE Char(1) NOT NULL,
  MP_IDENTITE Integer,
  MP_KLE_DOSSIER Integer NOT NULL,
  MP_TYPE_IMAGE Char(1),
  MP_POSITION Integer,
  CONSTRAINT PK_MEDIA_POINTEURS PRIMARY KEY (MP_CLEF)
);
CREATE TABLE MEMO_INFOS
(
  M_CLEF Integer NOT NULL,
  M_MEMO Blob sub_type 1,
  M_DOSSIER Integer NOT NULL,
  PRIMARY KEY (M_CLEF)
);
CREATE TABLE MULTIMEDIA
(
  MULTI_CLEF Integer NOT NULL,
  MULTI_INDIVIDU Integer,
  MULTI_INFOS Varchar(53) NOT NULL,
  MULTI_MEDIA Blob sub_type 0,
  MULTI_DOSSIER Integer,
  MULTI_DATE_MODIF Timestamp,
  MULTI_MEMO Blob sub_type 1,
  MULTI_STRETCH Integer,
  MULTI_IDENTITE Integer,
  MULTI_TYPE Char(1),
  MULTI_REDUITE Blob sub_type 0,
  MULTI_DEVISE Blob sub_type 1,
  MULTI_CRI Blob sub_type 1,
  MULTI_DOCRTF Blob sub_type 0,
  MULTI_IMAGE_RTF Integer,
  MULTI_NUM_ACTE Integer,
  MULTI_TYPE_ACTE Char(1),
  MULTI_SONS_VIDEOS Blob sub_type 0,
  MULTI_PATH Varchar(255),
  MULTI_NOM Varchar(255),
  ID_IMPORT_GEDCOM Integer,
  CONSTRAINT PK_MULTIMEDIA PRIMARY KEY (MULTI_CLEF)
);
CREATE TABLE NOM_ATTACHEMENT
(
  ID Integer NOT NULL,
  ID_INDI Integer NOT NULL,
  NOM Varchar(40) NOT NULL,
  NOM_INDI Varchar(40),
  KLE_DOSSIER Integer NOT NULL,
  NOM_LETTRE Varchar(1),
  CONSTRAINT PK_NOM_ATTACHEMENT PRIMARY KEY (ID)
);
CREATE GLOBAL TEMPORARY TABLE PRENOMS
(
  PRENOM Varchar(60) NOT NULL,
  M Integer DEFAULT 0,
  F Integer DEFAULT 0,
  CONSTRAINT PK_PRENOMS_PRENOM PRIMARY KEY (PRENOM)
)
ON COMMIT PRESERVE ROWS;
CREATE TABLE REF_DEPARTEMENTS
(
  RDP_CODE Integer NOT NULL,
  RDP_LIBELLE Varchar(30),
  RRG_CODE Integer,
  RDP_PAYS Integer,
  RDP_TEL Varchar(2),
  RDP_CODE_DEUX Varchar(2),
  CONSTRAINT PK_REF_DEPARTEMENTS PRIMARY KEY (RDP_CODE)
);
CREATE TABLE REF_DIVERS_FAM
(
  REF_LANGUE Varchar(3) NOT NULL,
  REF_LIBELLE Varchar(25) NOT NULL,
  CONSTRAINT PK_REF_DIVERS_FAM PRIMARY KEY (REF_LANGUE,REF_LIBELLE)
);
CREATE TABLE REF_DIVERS_IND
(
  REF_LANGUE Varchar(3) NOT NULL,
  REF_LIBELLE Varchar(25) NOT NULL,
  CONSTRAINT PK_REF_DIVERS_IND PRIMARY KEY (REF_LANGUE,REF_LIBELLE)
);
CREATE TABLE REF_EVENEMENTS
(
  REF_EVE_CODE Integer NOT NULL,
  REF_EVE_LIB_COURT Varchar(5) NOT NULL,
  REF_EVE_LIB_LONG Varchar(30),
  REF_EVE_CAT Integer,
  REF_EVE_VISIBLE Integer DEFAULT 0 NOT NULL,
  REF_EVE_A_TRAITER Integer DEFAULT 1,
  REF_EVE_ECRAN Integer DEFAULT 0,
  REF_EVE_OBLIGATOIRE Integer DEFAULT 1 NOT NULL,
  REF_EVE_LANGUE Varchar(3),
  REF_EVE_TYPE Char(1),
  REF_EVE_UNE_FOIS Integer,
  CONSTRAINT PK_REF_EVENEMENTS PRIMARY KEY (REF_EVE_CODE)
);
CREATE TABLE REF_FILIATION
(
  FIL_LIBELLE Varchar(30) NOT NULL,
  FIL_LANGUE Varchar(3) NOT NULL,
  CONSTRAINT PK_REF_FILIATION PRIMARY KEY (FIL_LIBELLE,FIL_LANGUE)
);
CREATE TABLE REF_HISTOIRE
(
  HI_ID Integer NOT NULL,
  HI_DOSSIER Integer DEFAULT 0,
  HI_DICORIGINE Varchar(8),
  HI_DATE_TEXTE Varchar(50) NOT NULL,
  HI_CAT Integer,
  HI_TITRE Varchar(50),
  HI_TEXTE Blob sub_type 1,
  HI_IMAGE Blob sub_type 0,
  HI_DATE_CODE_DEBUT Integer,
  HI_DATE_CODE_FIN Integer,
  CONSTRAINT PK_REF_HISTOIRE PRIMARY KEY (HI_ID)
);
CREATE TABLE REF_MARR
(
  REF_LANGUE Varchar(3) NOT NULL,
  REF_LIBELLE Varchar(90) NOT NULL,
  CONSTRAINT PK_REF_MARR PRIMARY KEY (REF_LANGUE,REF_LIBELLE)
  USING INDEX IDX_LANGUE_LIBELLE
);
CREATE TABLE REF_PARTICULES
(
  PART_CLEF Integer NOT NULL,
  PART_LIBELLE Varchar(10) NOT NULL,
  CONSTRAINT PK_REF_PARTICULES PRIMARY KEY (PART_CLEF)
);
CREATE TABLE REF_PAYS
(
  RPA_CODE Integer NOT NULL,
  RPA_LIBELLE Varchar(30) NOT NULL,
  RPA_ABBREVIATION Varchar(3),
  CONSTRAINT PK_REF_PAYS PRIMARY KEY (RPA_CODE)
);
CREATE TABLE REF_PREFIXES
(
  PR_CLEF Integer NOT NULL,
  PR_LIBELLE Varchar(30) NOT NULL,
  PRIMARY KEY (PR_CLEF)
);
CREATE TABLE REF_RACCOURCIS
(
  RAC_CLEF Integer NOT NULL,
  RAC_RAC Varchar(5),
  RAC_LIBELLE Varchar(255),
  CONSTRAINT PK_REF_RACCOURCIS PRIMARY KEY (RAC_CLEF)
);
CREATE TABLE REF_RELA_TEMOINS
(
  REF_RELA_CLEF Integer NOT NULL,
  REF_RELA_LIBELLE Varchar(40) NOT NULL,
  LANGUE Varchar(3) NOT NULL,
  REF_RELA_TAG Varchar(25),
  CONSTRAINT PK_REF_RELA_TEMOINS PRIMARY KEY (REF_RELA_CLEF)
);
CREATE TABLE REF_TOKEN_DATE
(
  ID Integer NOT NULL,
  TYPE_TOKEN Integer,
  LANGUE Varchar(3),
  TOKEN Varchar(30),
  SOUS_TYPE Varchar(2),
  PRIMARY KEY (ID)
);
CREATE TABLE SOURCES_RECORD
(
  ID Integer NOT NULL,
  SOURCE_PAGE Varchar(248),
  EVEN Varchar(15),
  EVEN_ROLE Varchar(25),
  DATA_ID Integer,
  DATA_EVEN Varchar(90),
  DATA_EVEN_PERIOD Varchar(35),
  DATA_EVEN_PLAC Varchar(120),
  DATA_AGNC Varchar(120),
  QUAY Integer,
  AUTH Blob sub_type 1,
  TITL Blob sub_type 1,
  ABR Varchar(60),
  PUBL Blob sub_type 1,
  TEXTE Blob sub_type 1,
  USER_REF Blob sub_type 1,
  RIN Varchar(12),
  CHANGE_DATE Timestamp,
  CHANGE_NOTE Blob sub_type 1,
  KLE_DOSSIER Integer NOT NULL,
  TYPE_TABLE Varchar(1),
  CONSTRAINT PK_SOURCES_RECORD PRIMARY KEY (ID)
);
CREATE TABLE TA_GROUPES
(
  TA_NIVEAU Integer,
  TA_CLE_FICHE Integer,
  TA_GROUPE Integer,
  TA_SEXE Integer
);
CREATE GLOBAL TEMPORARY TABLE TQ_ANC
(
  DECUJUS Integer,
  NIVEAU Integer,
  INDI Integer,
  ENFANT Integer
);
CREATE GLOBAL TEMPORARY TABLE TQ_ARBREDESCENDANT
(
  TQ_NIVEAU Integer,
  TQ_CLE_FICHE Integer,
  TQ_SOSA Varchar(120),
  TQ_CLE_PERE Integer,
  TQ_CLE_MERE Integer,
  TQ_NUM_SOSA Varchar(120),
  TQ_ASCENDANT Integer
);
CREATE GLOBAL TEMPORARY TABLE TQ_ARBREREDUIT
(
  TQ_NIVEAU Integer,
  TQ_CLE_FICHE Integer,
  TQ_SOSA Double precision,
  TQ_DOSSIER Integer,
  IMPLEXE Double precision,
  TQ_DESCENDANT Integer
);
CREATE GLOBAL TEMPORARY TABLE TQ_ASCENDANCE
(
  TQ_NIVEAU Integer,
  TQ_CLE_FICHE Integer,
  TQ_DOSSIER Integer
);
CREATE GLOBAL TEMPORARY TABLE TQ_ASCEND_DESCEND
(
  NIVEAU Integer,
  CLE_FICHE Integer
);
CREATE GLOBAL TEMPORARY TABLE TQ_CONSANG
(
  ID Integer,
  DECUJUS Integer,
  NIVEAU Integer,
  INDI Integer,
  ENFANT Integer
)
ON COMMIT PRESERVE ROWS;
CREATE GLOBAL TEMPORARY TABLE TQ_ECLAIR
(
  TQ_NOM Varchar(40),
  TQ_CP Varchar(10),
  TQ_VILLE Varchar(50),
  TQ_PAYS Varchar(30),
  TQ_DATE Integer,
  TQ_NAISSANCE Integer,
  TQ_BAPTEME Integer,
  TQ_MARIAGE Integer,
  TQ_DECES Integer,
  TQ_INSEE Varchar(6),
  TQ_SEPULTURE Integer,
  TQ_DEPT Varchar(30),
  TQ_REGION Varchar(50)
);
CREATE GLOBAL TEMPORARY TABLE TQ_ID
(
  ID1 Integer NOT NULL,
  ID2 Integer NOT NULL
);
CREATE GLOBAL TEMPORARY TABLE TQ_MEDIAS
(
  MULTI_CLEF Integer NOT NULL,
  MULTI_PATH Varchar(255),
  MULTI_MEDIA Blob sub_type 0,
  CONSTRAINT PK_TQ_MEDIAS PRIMARY KEY (MULTI_CLEF)
);
CREATE GLOBAL TEMPORARY TABLE TQ_PRENOMS
(
  COMBIEN Integer,
  DOSSIER Integer NOT NULL,
  PRENOM Varchar(80)
);
CREATE GLOBAL TEMPORARY TABLE TQ_RECH_DOUBLONS
(
  CLE_FICHE Integer NOT NULL,
  DATE_NAISSANCE Integer,
  DATE_NAISSANCE_FIN Integer,
  VILLE_NAISSANCE Varchar(50),
  DATE_DECES Integer,
  DATE_DECES_FIN Integer,
  VILLE_DECES Varchar(50),
  CONSTRAINT PK_TQ_RECH_DOUBLONS PRIMARY KEY (CLE_FICHE)
)
ON COMMIT PRESERVE ROWS;
CREATE GLOBAL TEMPORARY TABLE TQ_TRANSIT
(
  CHAMP1 Varchar(50),
  CHAMP2 Varchar(50),
  CHAMP3 Varchar(50),
  CHAMP4 Varchar(50)
);
CREATE GLOBAL TEMPORARY TABLE TRACES
(
  MOMENT Timestamp DEFAULT current_timestamp,
  NOM_TABLE Varchar(25),
  ENR_TABLE Integer,
  TEXTE_MESSAGE Varchar(255)
)
ON COMMIT PRESERVE ROWS;
CREATE GLOBAL TEMPORARY TABLE TT_ASCENDANCE
(
  ORDRE Integer NOT NULL,
  NIVEAU Smallint,
  INDI Integer,
  SEXE Smallint,
  CONJOINT Integer,
  ENFANT Integer,
  SOSA Bigint,
  IMPLEXE Integer,
  CONSTRAINT PK_TT_ASCENDANCE PRIMARY KEY (ORDRE)
);
CREATE TABLE T_ASSOCIATIONS
(
  ASSOC_CLEF Integer NOT NULL,
  ASSOC_KLE_IND Integer NOT NULL,
  ASSOC_KLE_ASSOCIE Integer NOT NULL,
  ASSOC_KLE_DOSSIER Integer NOT NULL,
  ASSOC_NOTES Blob sub_type 1,
  ASSOC_SOURCES Blob sub_type 1,
  ASSOC_EVENEMENT Integer,
  ASSOC_TABLE Char(1) DEFAULT 'I',
  ASSOC_LIBELLE Varchar(90),
  CONSTRAINT PK_T_ASSOCIATIONS PRIMARY KEY (ASSOC_CLEF)
);
CREATE GLOBAL TEMPORARY TABLE T_DOUBLONS
(
  CLE_FICHE Integer NOT NULL
);
CREATE TABLE T_IMPORT_GEDCOM
(
  IG_ID Integer NOT NULL,
  IG_PATH Varchar(255) NOT NULL,
  IG_DATE Timestamp DEFAULT 'NOW' NOT NULL,
  CONSTRAINT PK_T_IMPORT_GEDCOM PRIMARY KEY (IG_ID)
);
CREATE TABLE T_JOURNAL
(
  QUI Varchar(40),
  LE Timestamp,
  TEXTE Varchar(300),
  KLE_DOSSIER Integer
);
CREATE TABLE T_UNION
(
  UNION_CLEF Integer NOT NULL,
  UNION_MARI Integer,
  UNION_FEMME Integer,
  KLE_DOSSIER Integer NOT NULL,
  UNION_TYPE Integer,
  SOURCE Blob sub_type 1,
  "COMMENT" Blob sub_type 1,
  CONSTRAINT PK_T_UNION PRIMARY KEY (UNION_CLEF)
);
CREATE TABLE T_VERSION_BASE
(
  VER_VERSION Varchar(10) NOT NULL,
  OCTETS_FICHIER Bigint
);
CREATE TABLE YBTEMP
(
  CLE_FICHE Integer NOT NULL,
  SOSA Varchar(120),
  PRIMARY KEY (CLE_FICHE)
);
/********************* VIEWS **********************/

/******************* EXCEPTIONS *******************/

CREATE EXCEPTION EX_NUM_DOSSIER_MANQUANT
'Le N° du dossier est obligatoire....';
/******************** TRIGGERS ********************/

SET TERM ^ ;
CREATE TRIGGER BI_NOM_ATTACHEMENT_ID FOR NOM_ATTACHEMENT ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
AS
BEGIN
  IF (NEW.ID IS NULL) THEN
      NEW.ID = GEN_ID(NOM_ATTACHEMENT_ID_GEN, 1);
  select substring(s_out from 1 for 1) from f_maj_sans_accent(new.nom) into new.nom_lettre;
END^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER DOSSIER_BIU0 FOR DOSSIER ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
as
begin
  if (new.ds_langue is null) then
    new.ds_langue='FRA';
  new.ds_langue=upper(new.ds_langue);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER EVENEMENTS_FAM_BI FOR EVENEMENTS_FAM ACTIVE
BEFORE INSERT POSITION 0
as
declare variable valide smallint;
begin
  if (new.ev_fam_clef is null) then
      new.ev_fam_clef = gen_id(gen_ev_fam_clef,1);
  if (rdb$get_context('USER_SESSION','TRACE_DATE')='1'
      and char_length(new.ev_fam_date_writen)>0) then
  begin
    select valide
    from proc_date_writen(new.ev_fam_date_writen)
    into :valide;
    if (valide=0) then
      insert into traces (nom_table,enr_table,texte_message)
      values('EVENEMENTS_FAM',new.ev_fam_clef,'date invalide: '||new.ev_fam_date_writen);
  end
  new.ev_fam_description=trim(new.ev_fam_description);
  if (new.ev_fam_description in('y','Y')) then
    new.ev_fam_description=null;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER EVENEMENTS_FAM_BIU FOR EVENEMENTS_FAM ACTIVE
BEFORE INSERT OR UPDATE POSITION 1
as
begin
  if (new.ev_fam_titre_event is not null) then
  begin
    new.ev_fam_titre_event=trim(new.ev_fam_titre_event);
    if (new.ev_fam_titre_event='') then
      new.ev_fam_titre_event=null;
     else
      new.ev_fam_titre_event=upper(substring(new.ev_fam_titre_event from 1 for 1))
        ||substring(new.ev_fam_titre_event from 2);
  end
  if (new.ev_fam_source is not null) then
  begin
    new.ev_fam_source=trim(new.ev_fam_source);
    if (new.ev_fam_source='') then
      new.ev_fam_source=null;
  end
  if (new.ev_fam_calendrier1 is null and new.ev_fam_date_writen is not null) then
    new.ev_fam_calendrier1=0;
  if (new.ev_fam_calendrier2 is null and new.ev_fam_date_writen is not null) then
    new.ev_fam_calendrier2=0;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER EVENEMENTS_FAM_BIU2 FOR EVENEMENTS_FAM ACTIVE
BEFORE INSERT OR UPDATE POSITION 2
as
declare variable langue varchar(3);
begin
  if (rdb$get_context('USER_SESSION','TRIGGERS_DATES_INACTIFS') is null) then
    if (inserting or(updating and new.ev_fam_date_writen is distinct from old.ev_fam_date_writen))then
    begin
      for select first(1) ds.ds_langue
        from t_union u
        inner join individu i on i.cle_fiche=u.union_mari
        inner join dossier ds on ds.cle_dossier=i.kle_dossier
        where u.union_clef=new.ev_fam_kle_famille
        into :langue
      do
      begin
        rdb$set_context('USER_SESSION','LANGUE',langue);
        select imois
            ,ian
            ,ddate
            ,imois_fin
            ,ian_fin
            ,date_writen_s
            ,ijour
            ,ijour_fin
            ,type_token1
            ,type_token2
            ,date_code
            ,date_code_tot
            ,date_code_tard
            ,calendrier1
            ,calendrier2
        from proc_date_writen(new.ev_fam_date_writen)
        into new.ev_fam_date_mois
            ,new.ev_fam_date_year
            ,new.ev_fam_date
            ,new.ev_fam_date_mois_fin
            ,new.ev_fam_date_year_fin
            ,new.ev_fam_date_writen
            ,new.ev_fam_date_jour
            ,new.ev_fam_date_jour_fin
            ,new.ev_fam_type_token1
            ,new.ev_fam_type_token2
            ,new.ev_fam_datecode
            ,new.ev_fam_datecode_tot
            ,new.ev_fam_datecode_tard
            ,new.ev_fam_calendrier1
            ,new.ev_fam_calendrier2;
      end
    end
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER EVENEMENTS_IND_AIU FOR EVENEMENTS_IND ACTIVE
AFTER INSERT OR UPDATE POSITION 0
as
begin
  if (inserting or(updating and new.ev_ind_date_writen is distinct from old.ev_ind_date_writen)) then
    if (new.ev_ind_type='BIRT') then
      update individu
      set date_naissance=new.ev_ind_date_writen
         ,annee_naissance=new.ev_ind_date_year
      where cle_fiche=new.ev_ind_kle_fiche;
    else if (new.ev_ind_type='DEAT') then
      update individu
      set date_deces=new.ev_ind_date_writen
         ,annee_deces=new.ev_ind_date_year
         ,decede=1
      where cle_fiche=new.ev_ind_kle_fiche;

  if (inserting and new.ev_ind_type in('BURI','CREM')) then
    update individu set decede=1
    where cle_fiche=new.ev_ind_kle_fiche;

  delete from sources_record s
  where new.ev_ind_source is null
    and s.data_id=new.ev_ind_clef
    and s.type_table='I'
    and s.auth is null
    and s.titl is null
    and s.abr is null
    and s.publ is null
    and not exists(select 1 from media_pointeurs p
                   where p.mp_table='F'
                     and p.mp_type_image='F'
                     and p.mp_pointe_sur=s.id);

  if (row_count=0) then
  begin
    update sources_record s
    set s.texte=new.ev_ind_source
    where s.data_id=new.ev_ind_clef and s.type_table='I';
    if ((row_count=0) and (char_length(new.ev_ind_source)>0)) then
      insert into sources_record
        (data_id
        ,texte
        ,change_date
        ,kle_dossier
        ,type_table)
      values(new.ev_ind_clef
        ,new.ev_ind_source
        ,current_timestamp
        ,new.ev_ind_kle_dossier
        ,'I');
  end
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER EVENEMENTS_IND_BI FOR EVENEMENTS_IND ACTIVE
BEFORE INSERT POSITION 0
as
declare variable i integer;
declare variable l integer;
declare variable valide smallint;
begin
  if (new.ev_ind_clef is null) then
      new.ev_ind_clef = gen_id(gen_ev_ind_clef,1);
  if (rdb$get_context('USER_SESSION','TRACE_DATE')='1'
    and char_length(new.ev_ind_date_writen)>0) then
  begin
    select valide
    from proc_date_writen(new.ev_ind_date_writen)
    into :valide;
    if (valide=0) then
      insert into traces (nom_table,enr_table,texte_message)
      values('EVENEMENTS_IND',new.ev_ind_clef,'date invalide: '||new.ev_ind_date_writen);
  end
  new.ev_ind_description=trim(new.ev_ind_description);
  if (upper(new.ev_ind_description)='Y') then
    new.ev_ind_description=null;
  else
    if (new.ev_ind_type='EVEN') then
    begin
      l=char_length(new.ev_ind_description);
      i=1;
      while (i<=l-3 and i<27) do
      begin
        if (substring(new.ev_ind_description from i for 4)=' -  ') then--ancien séparateur
        begin
          new.ev_ind_titre_event=substring(new.ev_ind_description from 1 for i-1);
          if (i<l-3) then
            new.ev_ind_description=substring(new.ev_ind_description from i+4);
          else
            new.ev_ind_description=null;
          exit;
        end
        i=i+1;
      end
    end
  for select substring(r.ref_eve_lib_long from 1 for 25)
        ,'EVEN'
      from individu i
      inner join dossier ds on ds.cle_dossier=i.kle_dossier
      inner join ref_evenements r on r.ref_eve_lib_court=new.ev_ind_type
        and r.ref_eve_langue=ds.ds_langue
      where i.cle_fiche=new.ev_ind_kle_fiche
        and exists (select 1
                    from evenements_ind e
                    inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type
                                               and r.ref_eve_une_fois=1
                    where e.ev_ind_kle_fiche=new.ev_ind_kle_fiche
                      and e.ev_ind_type=new.ev_ind_type)
  into new.ev_ind_titre_event
      ,new.ev_ind_type
  do
    if (rdb$get_context('USER_SESSION','TRACE_DATE')='1') then
      insert into traces (nom_table,enr_table,texte_message)
      values('EVENEMENTS_IND',new.ev_ind_clef,new.ev_ind_titre_event||' en trop'
             ||coalesce(', date:'||new.ev_ind_date_writen,''));
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER EVENEMENTS_IND_BIU FOR EVENEMENTS_IND ACTIVE
BEFORE INSERT OR UPDATE POSITION 1
as
begin
  if (new.ev_ind_titre_event is not null) then
  begin
    new.ev_ind_titre_event=trim(new.ev_ind_titre_event);
    if (new.ev_ind_titre_event='') then
      new.ev_ind_titre_event=null;
    else
      new.ev_ind_titre_event=upper(substring(new.ev_ind_titre_event from 1 for 1))
        ||substring(new.ev_ind_titre_event from 2);
  end
  if (new.ev_ind_source is not null) then
  begin
    new.ev_ind_source=trim(new.ev_ind_source);
    if (new.ev_ind_source='') then
      new.ev_ind_source=null;
  end
  if (new.ev_ind_type='BIRT' and new.ev_ind_ordre is null) then
    new.ev_ind_ordre=0;
  if (new.ev_ind_calendrier1 is null and new.ev_ind_date_writen is not null) then
    new.ev_ind_calendrier1=0;
  if (new.ev_ind_calendrier2 is null and new.ev_ind_date_writen is not null) then
    new.ev_ind_calendrier2=0;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER EVENEMENTS_IND_BIU2 FOR EVENEMENTS_IND ACTIVE
BEFORE INSERT OR UPDATE POSITION 2
as
declare variable langue varchar(3);
begin
  if (rdb$get_context('USER_SESSION','TRIGGERS_DATES_INACTIFS') is null) then
    if (inserting or(updating and new.ev_ind_date_writen is distinct from old.ev_ind_date_writen))then
    begin
      for select ds.ds_langue
        from individu i
        inner join dossier ds on ds.cle_dossier=i.kle_dossier
        where i.cle_fiche=new.ev_ind_kle_fiche
        into :langue
      do
      begin
        rdb$set_context('USER_SESSION','LANGUE',langue);
        select imois
            ,ian
            ,ddate
            ,imois_fin
            ,ian_fin
            ,date_writen_s
            ,ijour
            ,ijour_fin
            ,type_token1
            ,type_token2
            ,date_code
            ,date_code_tot
            ,date_code_tard
            ,calendrier1
            ,calendrier2
        from proc_date_writen(new.ev_ind_date_writen)
        into new.ev_ind_date_mois
            ,new.ev_ind_date_year
            ,new.ev_ind_date
            ,new.ev_ind_date_mois_fin
            ,new.ev_ind_date_year_fin
            ,new.ev_ind_date_writen
            ,new.ev_ind_date_jour
            ,new.ev_ind_date_jour_fin
            ,new.ev_ind_type_token1
            ,new.ev_ind_type_token2
            ,new.ev_ind_datecode
            ,new.ev_ind_datecode_tot
            ,new.ev_ind_datecode_tard
            ,new.ev_ind_calendrier1
            ,new.ev_ind_calendrier2;
       end
     end
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER EV_FAM_TRIG_MAJ_LIEUX_FAVORIS FOR EVENEMENTS_FAM ACTIVE
AFTER INSERT OR UPDATE OR DELETE POSITION 1
as
begin
  if (rdb$get_context('USER_TRANSACTION','INACTIVE_MAJ_LIEUX')is null) then
  begin
    if (inserting or deleting or (updating and
      (new.ev_fam_ville is distinct from old.ev_fam_ville
      or new.ev_fam_subd is distinct from old.ev_fam_subd
      or new.ev_fam_cp is distinct from old.ev_fam_cp
      or new.ev_fam_insee is distinct from old.ev_fam_insee
      or new.ev_fam_dept is distinct from old.ev_fam_dept
      or new.ev_fam_region is distinct from old.ev_fam_region
      or new.ev_fam_pays is distinct from old.ev_fam_pays
      or new.ev_fam_latitude is distinct from old.ev_fam_latitude
      or new.ev_fam_longitude is distinct from old.ev_fam_longitude))) then
    begin
      if (updating or deleting) then
        if (not exists(select 1 from evenements_ind where
          ev_ind_kle_dossier=old.ev_fam_kle_dossier
          and ev_ind_ville is not distinct from old.ev_fam_ville
          and ev_ind_subd is not distinct from old.ev_fam_subd
          and ev_ind_cp is not distinct from old.ev_fam_cp
          and ev_ind_insee is not distinct from old.ev_fam_insee
          and ev_ind_dept is not distinct from old.ev_fam_dept
          and ev_ind_region is not distinct from old.ev_fam_region
          and ev_ind_pays is not distinct from old.ev_fam_pays
          and ev_ind_latitude is not distinct from old.ev_fam_latitude
          and ev_ind_longitude is not distinct from old.ev_fam_longitude)
          and not exists(select 1 from evenements_fam where
          ev_fam_kle_dossier=old.ev_fam_kle_dossier
          and ev_fam_ville is not distinct from old.ev_fam_ville
          and ev_fam_subd is not distinct from old.ev_fam_subd
          and ev_fam_cp is not distinct from old.ev_fam_cp
          and ev_fam_insee is not distinct from old.ev_fam_insee
          and ev_fam_dept is not distinct from old.ev_fam_dept
          and ev_fam_region is not distinct from old.ev_fam_region
          and ev_fam_pays is not distinct from old.ev_fam_pays
          and ev_fam_latitude is not distinct from old.ev_fam_latitude
          and ev_fam_longitude is not distinct from old.ev_fam_longitude))then
          delete from lieux_favoris where
          ville is not distinct from old.ev_fam_ville
          and subd is not distinct from old.ev_fam_subd
          and cp is not distinct from old.ev_fam_cp
          and insee is not distinct from old.ev_fam_insee
          and dept is not distinct from old.ev_fam_dept
          and region is not distinct from old.ev_fam_region
          and pays is not distinct from old.ev_fam_pays
          and latitude is not distinct from old.ev_fam_latitude
          and longitude is not distinct from old.ev_fam_longitude;

      if ((inserting or updating)and (new.ev_fam_ville is not null
        or new.ev_fam_subd is not null or new.ev_fam_cp is not null
        or new.ev_fam_insee is not null or new.ev_fam_dept is not null
        or new.ev_fam_region is not null or new.ev_fam_pays is not null)
        and not exists(select 1 from lieux_favoris where
        ville is not distinct from new.ev_fam_ville
        and subd is not distinct from new.ev_fam_subd
        and cp is not distinct from new.ev_fam_cp
        and insee is not distinct from new.ev_fam_insee
        and dept is not distinct from new.ev_fam_dept
        and region is not distinct from new.ev_fam_region
        and pays is not distinct from new.ev_fam_pays
        and latitude is not distinct from new.ev_fam_latitude
        and longitude is not distinct from new.ev_fam_longitude)) then
        insert into lieux_favoris
          (ville
          ,subd
          ,cp
          ,insee
          ,dept
          ,region
          ,pays
          ,latitude
          ,longitude)
          values(
           new.ev_fam_ville
          ,new.ev_fam_subd
          ,new.ev_fam_cp
          ,new.ev_fam_insee
          ,new.ev_fam_dept
          ,new.ev_fam_region
          ,new.ev_fam_pays
          ,new.ev_fam_latitude
          ,new.ev_fam_longitude);
    end
  end
end
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER EV_IND_TRIG_MAJ_LIEUX_FAVORIS FOR EVENEMENTS_IND ACTIVE
AFTER INSERT OR UPDATE OR DELETE POSITION 1
as
begin
  if (rdb$get_context('USER_TRANSACTION','INACTIVE_MAJ_LIEUX')is null) then
  begin
    if (inserting or deleting or (updating and
      (new.ev_ind_ville is distinct from old.ev_ind_ville
      or new.ev_ind_subd is distinct from old.ev_ind_subd
      or new.ev_ind_cp is distinct from old.ev_ind_cp
      or new.ev_ind_insee is distinct from old.ev_ind_insee
      or new.ev_ind_dept is distinct from old.ev_ind_dept
      or new.ev_ind_region is distinct from old.ev_ind_region
      or new.ev_ind_pays is distinct from old.ev_ind_pays
      or new.ev_ind_latitude is distinct from old.ev_ind_latitude
      or new.ev_ind_longitude is distinct from old.ev_ind_longitude))) then
    begin
      if (updating or deleting) then
        if (not exists(select 1 from evenements_ind where
          ev_ind_kle_dossier=old.ev_ind_kle_dossier
          and ev_ind_ville is not distinct from old.ev_ind_ville
          and ev_ind_subd is not distinct from old.ev_ind_subd
          and ev_ind_cp is not distinct from old.ev_ind_cp
          and ev_ind_insee is not distinct from old.ev_ind_insee
          and ev_ind_dept is not distinct from old.ev_ind_dept
          and ev_ind_region is not distinct from old.ev_ind_region
          and ev_ind_pays is not distinct from old.ev_ind_pays
          and ev_ind_latitude is not distinct from old.ev_ind_latitude
          and ev_ind_longitude is not distinct from old.ev_ind_longitude)
          and not exists(select 1 from evenements_fam where
          ev_fam_kle_dossier=old.ev_ind_kle_dossier
          and ev_fam_ville is not distinct from old.ev_ind_ville
          and ev_fam_subd is not distinct from old.ev_ind_subd
          and ev_fam_cp is not distinct from old.ev_ind_cp
          and ev_fam_insee is not distinct from old.ev_ind_insee
          and ev_fam_dept is not distinct from old.ev_ind_dept
          and ev_fam_region is not distinct from old.ev_ind_region
          and ev_fam_pays is not distinct from old.ev_ind_pays
          and ev_fam_latitude is not distinct from old.ev_ind_latitude
          and ev_fam_longitude is not distinct from old.ev_ind_longitude))then
          delete from lieux_favoris where
          ville is not distinct from old.ev_ind_ville
          and subd is not distinct from old.ev_ind_subd
          and cp is not distinct from old.ev_ind_cp
          and insee is not distinct from old.ev_ind_insee
          and dept is not distinct from old.ev_ind_dept
          and region is not distinct from old.ev_ind_region
          and pays is not distinct from old.ev_ind_pays
          and latitude is not distinct from old.ev_ind_latitude
          and longitude is not distinct from old.ev_ind_longitude;

      if ((inserting or updating)and (new.ev_ind_ville is not null
        or new.ev_ind_subd is not null or new.ev_ind_cp is not null
        or new.ev_ind_insee is not null or new.ev_ind_dept is not null
        or new.ev_ind_region is not null or new.ev_ind_pays is not null)
        and not exists(select 1 from lieux_favoris where
        ville is not distinct from new.ev_ind_ville
        and subd is not distinct from new.ev_ind_subd
        and cp is not distinct from new.ev_ind_cp
        and insee is not distinct from new.ev_ind_insee
        and dept is not distinct from new.ev_ind_dept
        and region is not distinct from new.ev_ind_region
        and pays is not distinct from new.ev_ind_pays
        and latitude is not distinct from new.ev_ind_latitude
        and longitude is not distinct from new.ev_ind_longitude)) then
        insert into lieux_favoris
          (ville
          ,subd
          ,cp
          ,insee
          ,dept
          ,region
          ,pays
          ,latitude
          ,longitude)
          values(
           new.ev_ind_ville
          ,new.ev_ind_subd
          ,new.ev_ind_cp
          ,new.ev_ind_insee
          ,new.ev_ind_dept
          ,new.ev_ind_region
          ,new.ev_ind_pays
          ,new.ev_ind_latitude
          ,new.ev_ind_longitude);
    end
  end
end
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER EX_ARBRES_BI0 FOR EX_ARBRES ACTIVE
BEFORE INSERT POSITION 0
as
begin
  if (new.ar_id is null) then
    new.ar_id=gen_id(gen_ex_arbres_id,1);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER MEDIA_POINTEURS_BIU FOR MEDIA_POINTEURS ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
AS
/*créé par André le 20/04/2007 pour empêcher d'attribuer 2 photos d'identité*/
begin
  if (new.mp_identite=1) then
    update media_pointeurs
      set mp_identite=0
      where mp_clef<>new.mp_clef
        and mp_cle_individu=new.mp_cle_individu
        and mp_identite=1;
  else
    new.mp_identite=0;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER REF_DIVERS_FAM_BIU0 FOR REF_DIVERS_FAM ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
as
begin
  new.ref_langue=upper(new.ref_langue);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER REF_DIVERS_IND_BIU0 FOR REF_DIVERS_IND ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
as
begin
  new.ref_langue=upper(new.ref_langue);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER REF_EVENEMENTS_BI FOR REF_EVENEMENTS ACTIVE
BEFORE INSERT POSITION 0
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 01/08/2001
   à : 05:35:59
   Modifiée le :
   à : :
   par :
   Description : Incremente la table ref_evenements
   Usage       :
   ---------------------------------------------------------------------------*/
  IF (NEW.REF_EVE_CODE IS NULL) THEN
      NEW.REF_EVE_CODE = GEN_ID(gen_ref_evenements,1);
END^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER REF_EVENEMENTS_BU FOR REF_EVENEMENTS ACTIVE
BEFORE UPDATE POSITION 0
as
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 01/08/2001
   à : 05:36:15
   Modifiée le :
   à : :
   par :
   Description : mets a jour le champ obligatoire
   Usage       :
   ---------------------------------------------------------------------------*/
  if (NEW.ref_eve_obligatoire = 1) then
     NEW.ref_eve_a_traiter = 1;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER REF_HISTOIRE_BIU FOR REF_HISTOIRE ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
as
begin
  if (new.hi_id is null) then
      new.hi_id = gen_id(gen_ref_histoire,1);
  select date_code_tot,date_code_tard,date_writen_s
  from proc_date_writen(new.hi_date_texte)
    into new.hi_date_code_debut,new.hi_date_code_fin,new.hi_date_texte;
  new.hi_dicorigine=upper(new.hi_dicorigine);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER REF_MARR_BIU0 FOR REF_MARR ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
as
begin
  new.ref_langue=upper(new.ref_langue);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER REF_RELA_TEMOINS_BI FOR REF_RELA_TEMOINS ACTIVE
BEFORE INSERT POSITION 0
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 01/08/2001
   à : 05:36:32
   Modifiée le :
   à : :
   par :
   Description : increment la table des relations temoins
   Usage       :
   ---------------------------------------------------------------------------*/
  IF (NEW.REF_RELA_CLEF IS NULL) THEN
      NEW.REF_RELA_CLEF = GEN_ID(GEN_REF_RELA_CLEF,1);
END^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER SOURCES_RECORD_BI0 FOR SOURCES_RECORD ACTIVE
BEFORE INSERT POSITION 0
AS
begin
  delete from sources_record
  where data_id=new.data_id
    and type_table=new.type_table;
  if (new.id is null) then
    new.id=gen_id(sources_record_id_gen,1);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER SOURCES_RECORD_BIU FOR SOURCES_RECORD ACTIVE
BEFORE INSERT OR UPDATE POSITION 1
as
begin
  new.auth=trim(new.auth);
  if (new.auth='') then new.auth=null;
  new.titl=trim(new.titl);
  if (new.titl='') then new.titl=null;
  new.abr=trim(new.abr);
  if (new.abr='') then new.abr=null;
  new.publ=trim(new.publ);
  if (new.publ='') then new.publ=null;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TAD_EVENEMENTS_IND FOR EVENEMENTS_IND ACTIVE
AFTER DELETE POSITION 0
as
begin
  if (old.ev_ind_type='BIRT') then
    update individu
      set date_naissance=null
         ,annee_naissance=null
      where cle_fiche=old.ev_ind_kle_fiche;
  if (old.ev_ind_type='DEAT') then
    update individu
      set date_deces=null
         ,annee_deces=null
      where cle_fiche=old.ev_ind_kle_fiche;
  if (old.ev_ind_type in('DEAT','BURI','CREM')) then
    update individu
      set decede=null
      where cle_fiche=old.ev_ind_kle_fiche
          and not exists (select 1 from evenements_ind
              where ev_ind_type in('DEAT','BURI','CREM')
                and ev_ind_kle_fiche=old.ev_ind_kle_fiche);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TAD_MEDIA_POINTEURS FOR MEDIA_POINTEURS ACTIVE
AFTER DELETE POSITION 0
as
declare variable ttable char(1);
begin
  ttable='I';
  if (old.mp_type_image='F') then
    select type_table
    from sources_record
    where id=old.mp_pointe_sur
    into :ttable;
  else
    if ((old.mp_type_image='A') and (old.mp_table='F')) then
      ttable='F';
  if (ttable='F') then
    delete from media_pointeurs
    where mp_media=old.mp_media
      and mp_pointe_sur=old.mp_pointe_sur
      and mp_table=old.mp_table
      and mp_kle_dossier=old.mp_kle_dossier
      and mp_type_image=old.mp_type_image ;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TAI_EVENEMENTS_FAM FOR EVENEMENTS_FAM ACTIVE
AFTER INSERT OR UPDATE POSITION 0
as
begin
  update sources_record s
  set s.texte=new.ev_fam_source
  where s.data_id=new.ev_fam_clef and s.type_table='F';
  if (row_count=0) then
    insert into sources_record (data_id
      ,texte
      ,change_date
      ,kle_dossier
      ,type_table)
    values(new.ev_fam_clef
      ,new.ev_fam_source
      ,current_timestamp
      ,new.ev_fam_kle_dossier
      ,'F');
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TAI_MEDIA_POINTEURS FOR MEDIA_POINTEURS ACTIVE
AFTER INSERT POSITION 0
as
declare variable ttable char(1);
declare variable did integer;
declare variable mari integer;
declare variable femme integer;
declare variable conjoint integer;
declare variable compte integer;
begin
  ttable='I';
  if (new.mp_type_image='F') then  --Déclaration par les sources
  begin                            --Nécessite l'existence dans
    select type_table,             --SOURCES_RECORD
           data_id
    from sources_record
    where id=new.mp_pointe_sur
    into :ttable,
         :did ;
  end
  else
    if ((new.mp_type_image='A') and (new.mp_table='F')) then
    begin
      ttable='F';
      did=new.mp_pointe_sur;
    end
  if (ttable='F') then
  begin
    delete from media_pointeurs  --Supprime les doublons qui pourraient être
      --créés par les 2 conjoints lors de la récupération d'un gedcom.
      --On ne garde que l'enregistrement en cours.
    where mp_clef<>new.mp_clef
      and mp_media=new.mp_media
      and mp_cle_individu=new.mp_cle_individu
      and mp_pointe_sur=new.mp_pointe_sur
      and mp_table=new.mp_table
      and mp_kle_dossier=new.mp_kle_dossier
      and mp_type_image=new.mp_type_image ;
    select count(mp_clef)
    from media_pointeurs
    where mp_media=new.mp_media
      and mp_pointe_sur=new.mp_pointe_sur
      and mp_table=new.mp_table
      and mp_kle_dossier=new.mp_kle_dossier
      and mp_type_image=new.mp_type_image
    into :compte;
    if (compte>1) then
      exit; --enregistrement déjà créé pour conjoint
    select u.union_mari
          ,u.union_femme
    from evenements_fam ev
    inner join t_union u on u.union_clef=ev.ev_fam_kle_famille
    where ev.ev_fam_clef=:did
    into :mari
        ,:femme;
    if (new.mp_cle_individu=mari) then
      conjoint=femme;
    else
      if (new.mp_cle_individu=femme) then
        conjoint=mari;
      else
        exit; --Union "orpheline"
    insert into media_pointeurs
          (mp_clef
          ,mp_media
          ,mp_cle_individu
          ,mp_pointe_sur
          ,mp_table
          ,mp_identite
          ,mp_kle_dossier
          ,mp_type_image)
    values(gen_id(biblio_pointeurs_id_gen, 1)
          ,new.mp_media
          ,:conjoint
          ,new.mp_pointe_sur
          ,new.mp_table
          ,0
          ,new.mp_kle_dossier
          ,new.mp_type_image);
  end
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TBD_DOSSIER FOR DOSSIER ACTIVE
BEFORE DELETE POSITION 0
AS
begin
/*créé par André le 23/08/2007 pour assurer l'intégrité des données*/
  execute procedure proc_vide_dossier(old.cle_dossier);
end
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TBD_EVENEMENTS_FAM FOR EVENEMENTS_FAM ACTIVE
BEFORE DELETE POSITION 0
as
begin
  delete from sources_record
  where data_id=old.ev_fam_clef
    and type_table='F';
  delete from media_pointeurs
  where mp_pointe_sur=old.ev_fam_clef
    and mp_type_image='A'
    and mp_table='F';
  delete from t_associations
  where assoc_evenement=old.ev_fam_clef
    and assoc_table='U';
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TBD_EVENEMENTS_IND FOR EVENEMENTS_IND ACTIVE
BEFORE DELETE POSITION 0
as
begin
  delete from sources_record
  where data_id=old.ev_ind_clef
    and type_table='I';
  delete from media_pointeurs
  where mp_pointe_sur=old.ev_ind_clef
    and mp_type_image='A'
    and mp_table='I';
  delete from t_associations
  where assoc_evenement=old.ev_ind_clef
    and assoc_table='I';
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TBD_SOURCES_RECORD FOR SOURCES_RECORD ACTIVE
BEFORE DELETE POSITION 0
as
/* Création par André pour fonctionnement média (01/10/05)
   Suppression des enregistrements de MEDIA_POINTEURS
   liés à cet enregistrement */
BEGIN
  DELETE FROM MEDIA_POINTEURS
    WHERE MP_TYPE_IMAGE = 'F' AND
          MP_POINTE_SUR = OLD.ID ;
END^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TBD_T_UNION FOR T_UNION ACTIVE
BEFORE DELETE POSITION 0
as
/* Créé par André le 25/10/2005 pour assurer intégrité*/
BEGIN
  DELETE FROM EVENEMENTS_FAM
  WHERE EV_FAM_KLE_FAMILLE = OLD.UNION_CLEF ;
END^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TBU_EVENEMENTS_FAM FOR EVENEMENTS_FAM ACTIVE
BEFORE UPDATE POSITION 0
as
declare variable valide smallint;
begin
  if (new.ev_fam_date_writen is distinct from old.ev_fam_date_writen) then
    if (rdb$get_context('USER_SESSION','TRACE_DATE')='1') then
      if (char_length(new.ev_fam_date_writen)>0) then
      begin
        select valide
        from proc_date_writen(new.ev_fam_date_writen)
        into :valide;
        if (valide=0) then
          insert into traces (nom_table,enr_table,texte_message)
          values('EVENEMENTS_FAM',old.ev_fam_clef,'date invalide: '||new.ev_fam_date_writen);
      end
  if (new.ev_fam_acte is null) then
    new.ev_fam_acte=0;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TBU_EVENEMENTS_IND FOR EVENEMENTS_IND ACTIVE
BEFORE UPDATE POSITION 0
as
declare variable valide smallint;
begin
  if (new.ev_ind_date_writen is distinct from old.ev_ind_date_writen) then
    if (rdb$get_context('USER_SESSION','TRACE_DATE')='1') then
      if (char_length(new.ev_ind_date_writen)>0) then
      begin
        select valide
        from proc_date_writen(new.ev_ind_date_writen)
        into :valide;
        if (valide=0) then
          insert into traces (nom_table,enr_table,texte_message)
          values('EVENEMENTS_IND',old.ev_ind_clef,'date invalide: '||new.ev_ind_date_writen);
      end
  if (new.ev_ind_type is distinct from old.ev_ind_type) then
    select substring(r.ref_eve_lib_long from 1 for 25)
          ,'EVEN'
      from individu i
      inner join dossier ds on ds.cle_dossier=i.kle_dossier
      inner join ref_evenements r on r.ref_eve_lib_court=new.ev_ind_type
        and r.ref_eve_langue=ds.ds_langue
      where i.cle_fiche=new.ev_ind_kle_fiche
        and exists (select 1
                    from evenements_ind e
                    inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type
                                               and r.ref_eve_une_fois=1
                    where e.ev_ind_kle_fiche=new.ev_ind_kle_fiche
                      and e.ev_ind_type=new.ev_ind_type)
    into new.ev_ind_titre_event
        ,new.ev_ind_type;
  if (new.ev_ind_acte is null) then
    new.ev_ind_acte=0;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TBU_T_UNION FOR T_UNION ACTIVE
BEFORE UPDATE POSITION 0
as
/* Créé par André le 05/03/2006 pour assurer intégrité*/
BEGIN
  IF (NEW.UNION_MARI IS NULL OR NEW.UNION_FEMME IS NULL) THEN
    DELETE FROM EVENEMENTS_FAM
           WHERE EV_FAM_KLE_FAMILLE=NEW.UNION_CLEF;
END^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TQ_MEDIAS_BIU0 FOR TQ_MEDIAS ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
as
begin
  if (new.multi_clef is null) then
    new.multi_clef=gen_id(gen_tq_media,1);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TRIG_MULTIMEDIA_BD FOR MULTIMEDIA ACTIVE
BEFORE DELETE POSITION 0
as
/* Création par André pour fonctionnement média le 20/06/06*/
BEGIN
DELETE FROM MEDIA_POINTEURS
WHERE MP_MEDIA=OLD.MULTI_CLEF;
END^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TT_ASCENDANCE_AI0 FOR TT_ASCENDANCE ACTIVE
AFTER INSERT POSITION 0
AS
DECLARE VARIABLE MAX_NIVEAU SMALLINT;
DECLARE VARIABLE PERE INTEGER;
DECLARE VARIABLE MERE INTEGER;
DECLARE VARIABLE MODE_IMPLEXE SMALLINT;
begin
  max_niveau=rdb$get_context('USER_TRANSACTION','MAX_NIVEAU');
  mode_implexe=rdb$get_context('USER_TRANSACTION','MODE_IMPLEXE');
  if (new.niveau<max_niveau) then
  begin
    if (mode_implexe=0) then --pas d'implexes
    begin
      select cle_pere,cle_mere
      from individu where cle_fiche=new.indi
      into :pere,:mere;
      if (pere is not null and pere>0) then
        if (not exists(select 1 from tt_ascendance where indi=:pere)) then
          insert into tt_ascendance (niveau,indi,sexe,conjoint,enfant,sosa)
          values(new.niveau+1
                ,:pere
                ,1
                ,:mere
                ,new.ordre
                ,bin_shl(new.sosa,1));
      if (mere is not null and mere>0) then
        if (not exists(select 1 from tt_ascendance where indi=:mere)) then
          insert into tt_ascendance (niveau,indi,sexe,conjoint,enfant,sosa)
          values(new.niveau+1
                ,:mere
                ,2
                ,:pere
                ,new.ordre
                ,bin_shl(new.sosa,1)+1);
    end
    else
    if (mode_implexe=1) then --implexes une seule fois
    begin
      if (new.implexe is null) then
      begin
        select cle_pere,cle_mere
        from individu where cle_fiche=new.indi
        into :pere,:mere;
        if (pere is not null and pere>0) then
          insert into tt_ascendance (niveau,indi,sexe,conjoint,enfant,sosa,implexe)
          values(new.niveau+1
                ,:pere
                ,1
                ,:mere
                ,new.ordre
                ,bin_shl(new.sosa,1)
                ,(select first(1) ordre from tt_ascendance
                  where indi=:pere order by ordre));
        if (mere is not null and mere>0) then
          insert into tt_ascendance (niveau,indi,sexe,conjoint,enfant,sosa,implexe)
          values(new.niveau+1
                  ,:mere
                  ,2
                  ,:pere
                  ,new.ordre
                  ,bin_shl(new.sosa,1)+1
                  ,(select first(1) ordre from tt_ascendance
                    where indi=:mere order by ordre));
      end
    end
    else --mode_implexe=2  tous les implexes
    begin
      select cle_pere,cle_mere
      from individu where cle_fiche=new.indi
      into :pere,:mere;
      if (pere is not null and pere>0) then
        insert into tt_ascendance (niveau,indi,sexe,conjoint,enfant,sosa,implexe)
        values(new.niveau+1
              ,:pere
              ,1
              ,:mere
              ,new.ordre
              ,bin_shl(new.sosa,1)
              ,(select first(1) ordre from tt_ascendance
                where indi=:pere order by ordre));
      if (mere is not null and mere>0) then
        insert into tt_ascendance (niveau,indi,sexe,conjoint,enfant,sosa,implexe)
        values(new.niveau+1
              ,:mere
              ,2
              ,:pere
              ,new.ordre
              ,bin_shl(new.sosa,1)+1
              ,(select first(1) ordre from tt_ascendance
                where indi=:mere order by ordre));
    end
  end
end
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TT_ASCENDANCE_BI0 FOR TT_ASCENDANCE ACTIVE
BEFORE INSERT POSITION 0
as
begin
  new.ordre=rdb$get_context('USER_TRANSACTION','NUM_ORDRE');
  if (new.ordre is null) then
    new.ordre=0;
  rdb$set_context('USER_TRANSACTION','NUM_ORDRE',new.ordre+1);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_AD_INDIVIDU FOR INDIVIDU ACTIVE
AFTER DELETE POSITION 0
AS
DECLARE VARIABLE TEST INTEGER;
begin
  if (rdb$get_context('USER_TRANSACTION','ACTIVE_MAJ_SOSA')is not null) then
  begin
    if (old.num_sosa is not null) then
    begin
      select rdb$set_context('USER_TRANSACTION','INACTIVE_MAJ_DATE','1')
      from rdb$database into :test;
      if (old.cle_pere is not null) then --rechercher s'il n'a pas un autre enfant sosa sinon le mettre à null
        update individu
        set num_sosa=(select first (1) 2*num_sosa from individu
                      where cle_pere=old.cle_pere
                      and num_sosa is not null)
        where cle_fiche=old.cle_pere and num_sosa=2*old.num_sosa;
      if (old.cle_mere is not null) then --rechercher s'il n'a pas un autre enfant sosa sinon le mettre à null
        update individu
        set num_sosa=(select first (1) 2*num_sosa+1 from individu
                      where cle_mere=old.cle_mere
                      and num_sosa is not null)
        where cle_fiche=old.cle_mere and num_sosa=2*old.num_sosa+1;
      if (test=0) then
        rdb$set_context('USER_TRANSACTION','INACTIVE_MAJ_DATE',null);
    end
  end
end
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_AI_INDIVIDU FOR INDIVIDU ACTIVE
AFTER INSERT POSITION 0
as
declare variable s_prenom varchar(60);
begin
  for select prenom from proc_eclate_prenom(new.prenom)
      where prenom is not null and prenom<>''
      into :S_PRENOM
  do
  begin
    if (new.sexe>1) then
      update prenoms set F=F+1 where prenom=:s_prenom;
    else
      update prenoms set M=M+1 where prenom=:s_prenom;
    if (row_count=0) then
      if (new.sexe>1) then
        insert into prenoms (prenom,F)
        values(:s_prenom,1);
       else
        insert into prenoms (prenom,M)
        values(:s_prenom,1);
  end
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_AU_INDIVIDU FOR INDIVIDU ACTIVE
AFTER UPDATE POSITION 0
as
DECLARE VARIABLE S_PRENOM VARCHAR(60);
DECLARE VARIABLE TEST INTEGER;
begin
  if (new.prenom<>old.prenom or new.sexe<>old.sexe)  then
  begin
    for select prenom from proc_eclate_prenom(old.prenom)
        where prenom is not null and prenom<>''
        into :S_PRENOM
    do
    begin
      if (old.sexe>1) then
        update prenoms set F=F-1 where prenom=:s_prenom;
      else
        update prenoms set M=M-1 where prenom=:s_prenom;
    end

    for select prenom from proc_eclate_prenom(new.prenom)
        where prenom is not null and prenom<>''
        into :S_PRENOM
    do
    begin
      if (new.sexe>1) then
        update prenoms set F=F+1 where prenom=:s_prenom;
      else
        update prenoms set M=M+1 where prenom=:s_prenom;
      if (row_count=0) then
        if (new.sexe>1) then
          insert into prenoms (prenom,F)
          values(:s_prenom,1);
        else
          insert into prenoms (prenom,M)
          values(:s_prenom,1);
    end
  end

  if (new.nom<>old.nom) then
    update nom_attachement
    set nom_indi=new.nom
    where id_indi=new.cle_fiche and nom_indi=old.nom;

  if (rdb$get_context('USER_TRANSACTION','ACTIVE_MAJ_SOSA')is not null) then
  begin
    if (new.num_sosa is distinct from old.num_sosa
        or new.cle_pere is distinct from old.cle_pere
        or new.cle_mere is distinct from old.cle_mere) then
    begin
      if (old.num_sosa is null) then
      begin
        if (new.num_sosa is not null) then
        begin --autrement rien à faire car num_sosa est resté null
          select rdb$set_context('USER_TRANSACTION','INACTIVE_MAJ_DATE','1')
            from rdb$database into :test;
          if (new.cle_pere is not null) then
            update individu set num_sosa=2*new.num_sosa
            where cle_fiche=new.cle_pere and num_sosa is null;
          if (new.cle_mere is not null) then
            update individu set num_sosa=2*new.num_sosa+1
            where cle_fiche=new.cle_mere and num_sosa is null;
          if (test=0) then
            rdb$set_context('USER_TRANSACTION','INACTIVE_MAJ_DATE',null);
        end
      end
      else --old.num_sosa n'était pas null
      begin
        if (new.num_sosa is null) then
        begin
          select rdb$set_context('USER_TRANSACTION','INACTIVE_MAJ_DATE','1')
            from rdb$database into :test;
          if (old.cle_pere is not null) then --rechercher s'il n'a pas un autre enfant sosa sinon le mettre à null
            update individu
            set num_sosa=(select first (1) 2*num_sosa from individu
                          where cle_pere=old.cle_pere
                          and num_sosa is not null)
            where cle_fiche=old.cle_pere and num_sosa=2*old.num_sosa;
            --rien à faire pour le nouveau père
          if (old.cle_mere is not null) then --rechercher s'il n'a pas un autre enfant sosa sinon le mettre à null
            update individu
            set num_sosa=(select first (1) 2*num_sosa+1 from individu
                          where cle_mere=old.cle_mere
                          and num_sosa is not null)
            where cle_fiche=old.cle_mere and num_sosa=2*old.num_sosa+1;
          --rien à faire pour la nouvelle mère
          if (test=0) then
            rdb$set_context('USER_TRANSACTION','INACTIVE_MAJ_DATE',null);
        end
        else --le num_sosa a gardé ou pas sa valeur
        begin
          select rdb$set_context('USER_TRANSACTION','INACTIVE_MAJ_DATE','1')
            from rdb$database into :test;
          if (new.cle_pere is distinct from old.cle_pere) then
          begin
            if (old.cle_pere is not null) then --rechercher s'il n'a pas un autre enfant sosa sinon le mettre à null
              update individu
              set num_sosa=(select first (1) 2*num_sosa from individu
                            where cle_pere=old.cle_pere
                            and num_sosa is not null)
              where cle_fiche=old.cle_pere and num_sosa=2*old.num_sosa;
            if (new.cle_pere is not null) then
              update individu set num_sosa=2*new.num_sosa
              where cle_fiche=new.cle_pere and num_sosa is null;
          end
          else
          begin
            if (new.num_sosa<>old.num_sosa and new.cle_pere is not null) then
              update individu set num_sosa=2*new.num_sosa
              where cle_fiche=new.cle_pere and num_sosa=2*old.num_sosa;
          end
          if (new.cle_mere is distinct from old.cle_mere) then
          begin
            if (old.cle_mere is not null) then --rechercher s'il n'a pas un autre enfant sosa sinon le mettre à null
              update individu
              set num_sosa=(select first (1) 2*num_sosa+1 from individu
                            where cle_mere=old.cle_mere
                            and num_sosa is not null)
              where cle_fiche=old.cle_mere and num_sosa=2*old.num_sosa+1;
            if (new.cle_mere is not null) then
              update individu set num_sosa=2*new.num_sosa+1
              where cle_fiche=new.cle_mere and num_sosa is null;
          end
          else
          begin
            if (new.num_sosa<>old.num_sosa and new.cle_mere is not null) then
              update individu set num_sosa=2*new.num_sosa+1
              where cle_fiche=new.cle_mere and num_sosa=2*old.num_sosa+1;
          end
          if (test=0) then
            rdb$set_context('USER_TRANSACTION','INACTIVE_MAJ_DATE',null);
        end
      end
    end
  end
end
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_BD_INDIVIDU FOR INDIVIDU ACTIVE
BEFORE DELETE POSITION 0
as
declare variable parent integer;
declare variable s_prenom varchar(60);
begin
/*créé par André le 23/08/2007 pour assurer l'intégrité des données*/
  delete from favoris where kle_fiche=old.cle_fiche;
  delete from t_associations where (assoc_kle_ind=old.cle_fiche and assoc_table='I')
                                   or assoc_kle_associe=old.cle_fiche;
  delete from media_pointeurs where mp_cle_individu=old.cle_fiche;
  delete from evenements_ind where ev_ind_kle_fiche=old.cle_fiche;
  delete from nom_attachement where id_indi=old.cle_fiche;
/* Cas d'un enfant unique avec seulement un parent :
   suppression de l'enregistrement T_UNION du parent */
  if (old.cle_pere is not null and old.cle_pere>0
      and (old.cle_mere is null or old.cle_mere=0)) then
  begin
     delete from t_union
     where union_mari=old.cle_pere
       and (union_femme is null or union_femme=0)
       and not exists (select 0 from individu
                       where cle_pere=old.cle_pere
                         and (cle_mere is null or cle_mere=0)
                         and cle_fiche<>old.cle_fiche);
  end
  else
    if (old.cle_mere is not null and old.cle_mere>0
        and (old.cle_pere is null or old.cle_pere=0)) then
    begin
       delete from t_union
       where union_femme=old.cle_mere
         and (union_mari is null or union_mari=0)
         and not exists (select 0 from individu
                         where cle_mere=old.cle_mere
                           and (cle_pere is null or cle_pere=0)
                           and cle_fiche<>old.cle_fiche);
    end
/* -- Détachement des enfants (cas suppression du père avec conjoint) */
  for select i.cle_mere from individu i
      where i.cle_pere=old.cle_fiche
        and i.cle_mere is not null
        and i.cle_mere <> 0
        and not exists (select 0 from t_union
                        where union_femme=i.cle_mere
                          and (union_mari is null or union_mari=0))
      into :parent
  do
    insert into t_union (union_femme,kle_dossier,union_type)
                 values (:parent,old.kle_dossier,0);
  update individu
     set cle_pere=null
   where cle_pere=old.cle_fiche;
/* -- Détachement des enfants (cas suppression de la mère avec conjoint) */
  for select i.cle_pere from individu i
      where i.cle_mere=old.cle_fiche
        and i.cle_pere is not null
        and i.cle_pere <> 0
        and not exists (select 0 from t_union
                        where union_mari=i.cle_pere
                          and (union_femme is null or union_femme=0))
      into :parent
  do
    insert into t_union (union_mari,kle_dossier,union_type)
                 values (:parent,old.kle_dossier,0);
  update individu
     set cle_mere=null
   where cle_mere=old.cle_fiche;
  delete from t_union where union_mari=old.cle_fiche or union_femme=old.cle_fiche;
--ajout André le 28/07/2008 pour maj table PRENOMS
  for select prenom from proc_eclate_prenom(old.prenom)
      where prenom is not null and prenom<>''
      into :S_PRENOM
  do
  begin
    if (old.sexe>1) then
      update prenoms set F=F-1 where prenom=:s_prenom;
    else
      update prenoms set M=M-1 where prenom=:s_prenom;
  end
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_BI_INDIVIDU FOR INDIVIDU ACTIVE
BEFORE INSERT POSITION 0
as
begin
  if (NEW.DATE_CREATION is null) then
    NEW.DATE_CREATION='NOW';
  if  (NEW.DATE_MODIF is null) then
    NEW.DATE_MODIF='NOW';
  if (NEW.NOM IS NOT NULL) then
    select s_out from f_maj_sans_accent(NEW.NOM)
    into NEW.INDI_TRIE_NOM;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_BI_INDIVIDU_2 FOR INDIVIDU ACTIVE
BEFORE INSERT POSITION 1
as
declare variable cmpt_cfx integer;
begin
   /*---------------------------------------------------------------------------
   Créé le : 28/10/2005 par André pour vérifier que la CLE_FIXE est unique
   si non en chercher une nouvelle
   ---------------------------------------------------------------------------*/
  if (new.cle_fixe is null) then exit;
  select first 1 1 from individu
  where cle_fixe=new.cle_fixe
  into :cmpt_cfx;
  if (cmpt_cfx is not null and new.cle_fixe<>new.cle_fiche) then
  begin
    new.cle_fixe=new.cle_fiche;
    cmpt_cfx=null;
    select first 1 1 from individu
    where cle_fixe=new.cle_fixe
    into :cmpt_cfx;
  end
  if (cmpt_cfx is not null) then
  begin
    new.cle_fixe=0;
    while (cmpt_cfx is not null) do
    begin
      cmpt_cfx=null;
      new.cle_fixe=new.cle_fixe+1;
      select first 1 1 from individu
      where cle_fixe=new.cle_fixe
      into :cmpt_cfx;
    end
  end
 end
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_BI_REF_PARTICULES FOR REF_PARTICULES ACTIVE
BEFORE INSERT POSITION 0
AS
begin
  if (new.part_clef is null) then
    new.part_clef=gen_id(gen_ref_particules,1);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_BU_INDIVIDU FOR INDIVIDU ACTIVE
BEFORE UPDATE POSITION 0
as
begin
  if  (rdb$get_context('USER_TRANSACTION','INACTIVE_MAJ_DATE')is null) then
    new.date_modif='NOW';
  if (new.nom is distinct from old.nom) then
    select s_out from f_maj_sans_accent(new.nom)
    into new.indi_trie_nom;
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_BU_INDIVIDU_2 FOR INDIVIDU ACTIVE
BEFORE UPDATE POSITION 1
as
declare variable cmpt_cfx integer;
begin
   /*---------------------------------------------------------------------------
   Créé le : 28/10/2005 par André pour vérifier que la CLE_FIXE est unique
   si non en chercher une nouvelle
   ---------------------------------------------------------------------------*/
  if (new.cle_fixe = old.cle_fixe or new.cle_fixe is null) then exit;
  select first 1 1 from individu
  where cle_fixe=new.cle_fixe
  into :cmpt_cfx;
  if (cmpt_cfx is not null and new.cle_fixe<>new.cle_fiche) then
  begin
    new.cle_fixe=new.cle_fiche;
    select first 1 1 from individu
    where cle_fixe=new.cle_fixe
    into :cmpt_cfx;
  end
  if (cmpt_cfx is not null) then
  begin
    new.cle_fixe=0;
    while (cmpt_cfx is not null) do
    begin
      new.cle_fixe=new.cle_fixe+1;
      cmpt_cfx=null;
      select first 1 1 from individu
      where cle_fixe=new.cle_fixe
      into :cmpt_cfx;
    end
  end
end
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_CONNECTION ACTIVE
ON CONNECT POSITION 0
as
declare variable taille_initiale bigint;
declare variable taille_actuelle bigint;
declare variable ratio smallint;
declare variable i integer;
begin
  select first(1) octets_fichier from t_version_base into :taille_initiale;
  select mon$page_size*mon$pages from mon$database into :taille_actuelle;
  if (taille_initiale is null) then
  begin
    update t_version_base
    set octets_fichier=:taille_actuelle;
    taille_initiale=taille_actuelle;
    i = gen_id(gen_tq_id,-gen_id(gen_tq_id, 0));
    i = gen_id(gen_consang,-gen_id(gen_consang, 0));
    i = gen_id(gen_tq_media,-gen_id(gen_tq_media, 0));
  end
  ratio=(taille_actuelle-taille_initiale)*100/taille_initiale;
  rdb$set_context('USER_SESSION','RATIO_TAILLE',ratio);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_REF_TOKEN_DATE_BUI FOR REF_TOKEN_DATE ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
AS
begin
  NEW.SOUS_TYPE=UPPER(NEW.SOUS_TYPE);
  if (new.id is null) then
    new.id=gen_id(gen_token_date,1);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER T_UNION_BI FOR T_UNION ACTIVE
BEFORE INSERT POSITION 0
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 01/08/2001
   à : 05:38:30
   Modifiée le :
   à : :
   par :
   Description : Incremente la table des unions
   Usage       :
   ---------------------------------------------------------------------------*/
  IF (NEW.UNION_CLEF IS NULL) THEN
      NEW.UNION_CLEF = GEN_ID(GEN_T_UNION,1);
END^
SET TERM ; ^

SET TERM ^ ;
ALTER PROCEDURE F_MAJ (
    S_IN Varchar(255) )
RETURNS (
    S_OUT Varchar(255) )
AS
begin
  S_OUT=UPPER(S_IN);
  suspend;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE F_MAJ_SANS_ACCENT (
    S_IN Varchar(255) )
RETURNS (
    S_OUT Varchar(255) )
AS
DECLARE VARIABLE L INTEGER;
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE CAR CHAR(1);
DECLARE VARIABLE S_TEMP VARCHAR(255);
begin
  S_OUT=coalesce(upper(lower(S_IN)),'');
  for select :s_out from rdb$database
  where :s_out containing '?'
     or :s_out containing '?'
     or :s_out containing 'Æ'
     or :s_out containing 'Ä'
     or :s_out containing 'Ã'
     or :s_out containing 'Ö'
     or :s_out containing 'Õ'
     or :s_out containing 'Ñ'
     or :s_out containing 'Ý'
     or :s_out containing 'Ð'
     or :s_out containing 'Ø'
  into :s_temp
  do
  begin
    l=char_length(s_temp);
    s_out='';
    i=1;
    while (i<=l) do
    begin
      car=substring(s_temp from i for 1);
      if (car='?') then s_out=s_out||'OE';
      else if (car='?') then s_out=s_out||'OE';
      else if (car='Æ') then s_out=s_out||'AE';
      else if (car='Ä') then s_out=s_out||'A';
      else if (car='Ã') then s_out=s_out||'A';
      else if (car='Ö') then s_out=s_out||'O';
      else if (car='Õ') then s_out=s_out||'O';
      else if (car='Ñ') then s_out=s_out||'N';
      else if (car='Ý') then s_out=s_out||'Y';
      else if (car='Ð') then s_out=s_out||'D';
      else if (car='Ø') then s_out=s_out||'O';
      else s_out=s_out||car;
      i=i+1;
    end
  end
  suspend;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_AGE_TEXTE (
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100) )
RETURNS (
    AGE_TEXTE Varchar(60) )
AS
declare variable valide smallint;
declare variable jour_d_n smallint;
declare variable token_d_n smallint;
declare variable datecode_tot_n integer;
declare variable an_f_n integer;
declare variable jour_f_n smallint;
declare variable datecode_tard_n integer;
declare variable jour_d_d smallint;
declare variable token_d_d smallint;
declare variable an_f_d integer;
declare variable jour_f_d smallint;
declare variable datecode_tot_d integer;
declare variable datecode_tard_d integer;
declare variable age_texte_min varchar(25);
declare variable age_texte_max varchar(25);
declare variable precis smallint;
declare variable ians integer;
declare variable imois smallint;
declare variable ijours smallint;
declare variable nbrjours_min integer;
declare variable nbrjours_max integer;
declare variable datecode_n integer;
declare variable datecode_d integer;
begin
  age_texte='';
  if (char_length(trim(date_naissance))=0 or char_length(trim(date_deces))=0) then
  begin
    suspend;
    exit;
  end

  select valide
        ,ijour
        ,type_token1
        ,date_code_tot
        ,ian_fin
        ,ijour_fin
        ,date_code_tard
        ,date_code
  from proc_date_writen(trim(:date_naissance))
  into :valide
      ,:jour_d_n
      ,:token_d_n
      ,:datecode_tot_n
      ,:an_f_n
      ,:jour_f_n
      ,:datecode_tard_n
      ,:datecode_n;
  if (valide=0) then
  begin
    suspend;
    exit;
  end

  select valide
        ,ijour
        ,type_token1
        ,date_code_tot
        ,ian_fin
        ,ijour_fin
        ,date_code_tard
        ,date_code
  from proc_date_writen(trim(:date_deces))
  into :valide
      ,:jour_d_d
      ,:token_d_d
      ,:datecode_tot_d
      ,:an_f_d
      ,:jour_f_d
      ,:datecode_tard_d
      ,:datecode_d;
  if (valide=0) then
  begin
    suspend;
    exit;
  end

  if (token_d_n in (19,20,21) or token_d_d in (19,20,21)) then
  begin
    nbrjours_min=datecode_d-datecode_n;
    nbrjours_max=nbrjours_min;
  end
  else
  begin
    if (datecode_tot_d>-2147483647 and datecode_tot_n>-2147483647) then
    begin
      nbrjours_min=datecode_tot_d-datecode_tard_n;
      nbrjours_max=datecode_tard_d-datecode_tot_n;
    end
    else
    begin
      suspend;
      exit;
    end
  end

  if ((jour_d_n is null or jour_d_d is null)
    or(an_f_n is not null and jour_f_n is null)
    or(an_f_d is not null and jour_f_d is null)) then
    precis=0;
  else
    precis=1;

  if (nbrjours_min<50000) then
  begin
    select ians,imois,ijours from proc_delta_dates(:nbrjours_min)
    into :ians,:imois,:ijours;
    if (ians is null) then
    begin
      suspend;
      exit;
    end
    else
      select jours_texte from proc_jours_texte(:ians,:imois,:ijours,:precis)
      into :age_texte_min;
  end

  if (nbrjours_max<50000) then
  begin
    select ians,imois,ijours from proc_delta_dates(:nbrjours_max)
    into :ians,:imois,:ijours;
    if (ians is null) then
    begin
      suspend;
      exit;
    end
    else
      select jours_texte from proc_jours_texte(:ians,:imois,:ijours,:precis)
      into :age_texte_max;
  end
  if (age_texte_min is null and age_texte_max is null) then
  begin
    suspend;
    exit;
  end

  if (token_d_n in (19,20,21) or token_d_d in (19,20,21)) then
    age_texte='environ ';

  if (age_texte_min is null) then
    age_texte=age_texte||'au plus '||age_texte_max;
  else if (age_texte_max is null) then
    age_texte=age_texte||'au moins '||age_texte_min;
  else if (age_texte_min=age_texte_max) then
    age_texte=age_texte||age_texte_min;
  else
    age_texte=age_texte||age_texte_min||' à '||age_texte_max;

  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André Langlet le 11/05/2008.
Refonte complète avec datecodes le 13/03/2012.
Elle permet d''exprimer un âge sous forme de texte.
Les dates de naissance et de décès doivent être au format standard de saisie des dates.'
  where RDB$PROCEDURE_NAME = 'PROC_AGE_TEXTE';

SET TERM ^ ;
ALTER PROCEDURE PROC_ANC_COMMUNS (
    INDIVIDU1 Integer,
    INDIVIDU2 Integer )
RETURNS (
    COMMUN Integer,
    ENFANT_1 Integer,
    NIVEAU_MIN_1 Integer,
    ENFANT_2 Integer,
    NIVEAU_MIN_2 Integer )
AS
declare variable pere integer;
declare variable mere integer;
declare variable k integer;
declare variable i_count integer;
declare variable indip integer;
declare variable indim integer;
declare variable enfant integer;
declare variable ascendant integer;
begin
--  delete from tq_anc;
  if (individu2<>0) then
  begin
    k=0;
    pere=individu1;
    mere=individu2;
  end
  else
  begin
    k=1;
    select cle_pere,cle_mere from individu
    where cle_fiche=:individu1
    into :pere,:mere;
  end
  if (pere=0 or pere is null or mere=0 or mere is null) then
  begin
    suspend;
    exit;
  end
  if (pere=mere) then
  begin
    suspend;
    exit;
  end
  insert into tq_anc (decujus,niveau,indi,enfant)
                 values(:pere,:k,:pere,:pere);
  insert into tq_anc (decujus,niveau,indi,enfant)
                 values(:mere,:k,:mere,:mere);
  i_count=1;
  while (i_count>0) do
  begin
    i_count=0;
    for select i.cle_pere,i.cle_mere,tq.indi,tq.decujus
        from tq_anc tq
        inner join individu i on i.cle_fiche=tq.indi
        where tq.decujus in(:pere,:mere)
          and tq.niveau=:k
        into :indip,:indim,:enfant,:ascendant
    do
    begin
      --par les hommes
      if (:indip>0) then
        if (not exists (select 1 from tq_anc where decujus=:ascendant
                                     and indi=:indip
                                     and enfant=:enfant)) then
        begin
          insert into tq_anc (decujus,niveau,indi,enfant)
          values(:ascendant,:k+1,:indip,:enfant);
          i_count=1;
        end
      --par les femmes
      if (:indim>0) then
        if (not exists (select 1 from tq_anc where decujus=:ascendant
                                     and indi=:indim
                                     and enfant=:enfant)) then
        begin
          insert into tq_anc (decujus,niveau,indi,enfant)
            values(:ascendant,:k+1,:indim,:enfant);
          i_count=1;
        end
    end
    k=k+1;
  end
  for select distinct p.indi
                     ,p.enfant
                     ,p.niveau
                     ,m.enfant
                     ,m.niveau
      from tq_anc p
      inner join tq_anc m on m.decujus=:mere
                             and m.indi=p.indi
                             and m.enfant<>p.enfant
      where p.decujus=:pere
      into :commun
          ,:enfant_1
          ,:niveau_min_1
          ,:enfant_2
          ,:niveau_min_2
  do
  begin
    suspend;
  end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André. Dernière modification: 30/10/2010
Cette procédure liste les ancêtres communs à 2 individus. INDIVIDU et INDIVIDU2
ENFANT_1 et ENFANT_2 sont les enfants de l''ancêtre à l''origine de la branche
arrivant respectivement à INDIVIDU et INDIVIDU2. NIVEAU_MIN_1 et NIVEAU_MIN_2
sont les nombres de générations minimum séparant respectivement INDIVIDU et
INDIVIDU2 de l''ancêtre en passant par les branches issues de ENFANT_1 et ENFANT_2.
Si INDIVIDU2 est nul, les ancêtres communs aux parents de INDIVIDU sont recherchés.
Les nombres de générations sont celles qui séparent INDIVIDU de son ancêtre par
chacune des branches paternelle et maternelle.'
  where RDB$PROCEDURE_NAME = 'PROC_ANC_COMMUNS';

SET TERM ^ ;
ALTER PROCEDURE PROC_ARBRE_EXPORT (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_DOSSIER Integer,
    I_PARQUI Integer )
RETURNS (
    NIVEAU Integer,
    SOSA Double precision,
    CLE_FICHE Integer,
    CLE_IMPORTATION Varchar(20),
    CLE_PARENTS Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    PREFIXE Varchar(30),
    NOM Varchar(40),
    PRENOM Varchar(60),
    SURNOM Varchar(120),
    SUFFIXE Varchar(30),
    SEXE Integer,
    DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer,
    DATE_DECES Varchar(100),
    ANNEE_DECES Integer,
    DECEDE Integer,
    AGE_AU_DECES Integer,
    SOURCE Blob sub_type 1,
    "COMMENT" Blob sub_type 1,
    FILLIATION Varchar(30),
    NUM_SOSA Double precision,
    OCCUPATION Varchar(90),
    NCHI Integer,
    NMR Integer,
    CLE_FIXE Integer,
    IMPLEXE Double precision,
    DESCENDANT Integer )
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 18:10:14
   Modifiée le :12/02/2006 par André pour séparer le remplissage de la table temporaire
   à : : et le calcul du dernier métier
   par :
   Description : Cette procedure permet de récuperer la fam d'un individu
   en se servant d'une table technique
   Le remplissage de la table est fonction de Niveaux
   0 - Lui Meme
   1 - Parents
   x - les autres
   I_PARQUI : 1 par les hommes
              2 par les femmes
              0 tous
   Usage       :
   ---------------------------------------------------------------------------*/
   for
      SELECT  t.tq_niveau,
              t.tq_sosa,
              i.CLE_FICHE,
              i.CLE_IMPORTATION,
              i.CLE_PARENTS,
              i.CLE_PERE,
              i.CLE_MERE,
              i.PREFIXE,
              i.NOM,
              i.PRENOM,
              i.SURNOM,
              i.SUFFIXE,
              i.SEXE,
              i.DATE_NAISSANCE,
              i.ANNEE_NAISSANCE,
              i.DATE_DECES,
              i.ANNEE_DECES,
              i.DECEDE,
              i.AGE_AU_DECES,
              i.SOURCE,
              i.COMMENT,
              i.FILLIATION,
              i.NUM_SOSA,
              i.NCHI,
              i.NMR,
              i.CLE_FIXE,
              t.IMPLEXE,
              t.tq_descendant
         FROM PROC_TQ_ASCENDANCE(:I_CLEF,:I_NIVEAU,:I_PARQUI,1) t
              inner join individu i on i.cle_fiche=t.tq_cle_fiche
         ORDER BY t.tq_SOSA
         INTO :NIVEAU,
              :SOSA,
              :CLE_FICHE,
              :CLE_IMPORTATION,
              :CLE_PARENTS,
              :CLE_PERE,
              :CLE_MERE,
              :PREFIXE,
              :NOM,
              :PRENOM,
              :SURNOM,
              :SUFFIXE,
              :SEXE,
              :DATE_NAISSANCE,
              :ANNEE_NAISSANCE,
              :DATE_DECES,
              :ANNEE_DECES,
              :DECEDE,
              :AGE_AU_DECES,
              :SOURCE,
              :COMMENT,
              :FILLIATION,
              :NUM_SOSA,
              :NCHI,
              :NMR,
              :CLE_FIXE,
              :IMPLEXE,
              :descendant
   do
     begin
       OCCUPATION=NULL;
       SELECT OCCUPATION FROM PROC_DERNIER_METIER(:CLE_FICHE)
             INTO :OCCUPATION;
       suspend;
     end
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_ASCEND_DESCEND (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_DOSSIER Integer,
    I_PARQUI Integer )
RETURNS (
    MODE Char(1),
    CLE_FICHE Integer,
    PREFIXE Varchar(30),
    NOM Varchar(40),
    PRENOM Varchar(60),
    SURNOM Varchar(120),
    SUFFIXE Varchar(30),
    SEXE Integer,
    CLE_PARENTS Integer,
    SOURCE Blob sub_type 1,
    "COMMENT" Blob sub_type 1,
    NUM_SOSA Varchar(120),
    NIVEAU Integer,
    FILLIATION Varchar(30),
    CLE_MERE Integer,
    CLE_PERE Integer,
    NCHI Integer,
    NMR Integer,
    CLE_FIXE Integer )
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 18:11:02
   Modifiée le :27/12/2005 par André à cause de la gestion des implexes
   le 02/10/2007 suppression renumérotation sosa du dossier.
   par :
   Description : Recupere les ascendant et descendants d'un individu
   Usage       :
   ---------------------------------------------------------------------------*/
    FOR
    SELECT  'A',
            CLE_FICHE,
            PREFIXE,
            NOM,
            PRENOM,
            SURNOM,
            SUFFIXE,
            SEXE,
            CLE_PARENTS,
            SOURCE,
            COMMENT,
            CAST(SOSA AS VARCHAR(120)),
            NIVEAU,
            FILLIATION,
            CLE_MERE,
            CLE_PERE,
            NCHI,
            NMR,
            CLE_FIXE
    FROM PROC_ARBRE_EXPORT (:I_CLEF, :I_NIVEAU, :I_DOSSIER, :I_PARQUI)
         WHERE IMPLEXE IS NULL
    UNION all
    SELECT  'D',
            CLE_FICHE,
            PREFIXE,
            NOM,
            PRENOM,
            SURNOM,
            SUFFIXE,
            SEXE,
            CLE_PARENTS,
            SOURCE,
            COMMENT,
            SOSA,
            NIVEAU,
            FILLIATION,
            CLE_MERE,
            CLE_PERE,
            NCHI,
            NMR,
            CLE_FIXE
    FROM PROC_DESCENDANCE (:I_CLEF, :I_NIVEAU, :I_DOSSIER)
    WHERE CLE_FICHE <> :I_CLEF AND ORDRE IS NULL
    INTO    :MODE,
            :CLE_FICHE,
            :PREFIXE,
            :NOM,
            :PRENOM,
            :SURNOM,
            :SUFFIXE,
            :SEXE,
            :CLE_PARENTS,
            :SOURCE,
            :COMMENT,
            :NUM_SOSA,
            :NIVEAU,
            :FILLIATION,
            :CLE_MERE,
            :CLE_PERE,
            :nchi, 
            :NMR,
            :CLE_FIXE
    DO
    suspend;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_ASCEND_ORDONNEE (
    DECUJUS Integer,
    MAX_NIVEAU Smallint,
    MODE_IMPLEXE Smallint )
RETURNS (
    ORDRE Integer,
    NIVEAU Smallint,
    INDI Integer,
    SEXE Smallint,
    CONJOINT Integer,
    ENFANT Integer,
    SOSA Bigint,
    IMPLEXE Integer )
AS
begin
  delete from tt_ascendance;
  if (max_niveau is null or max_niveau=0) then
    max_niveau=128;
  else
    max_niveau=minvalue(max_niveau,128);
  if (mode_implexe is null or mode_implexe<0) then
    mode_implexe=0;
  else
    mode_implexe=minvalue(mode_implexe,2);
  rdb$set_context('USER_TRANSACTION','MAX_NIVEAU',max_niveau);
  rdb$set_context('USER_TRANSACTION','MODE_IMPLEXE',mode_implexe);
  rdb$set_context('USER_TRANSACTION','NUM_ORDRE',0);
  insert into tt_ascendance (niveau,indi,sosa)
    values (0,:decujus,1);
  for select ordre
            ,niveau
            ,indi
            ,sexe
            ,conjoint
            ,enfant
            ,sosa
            ,implexe
       from tt_ascendance
       order by ordre
       into ordre
            ,niveau
            ,indi
            ,sexe
            ,conjoint
            ,enfant
            ,sosa
            ,implexe
  do
    suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Création André le 14/12/2008 pour automatiser le calcul de l''ascendance.
Dernière modification 14/04/2011: ordre donné par variable du contexte.'
  where RDB$PROCEDURE_NAME = 'PROC_ASCEND_ORDONNEE';

SET TERM ^ ;
ALTER PROCEDURE PROC_CHERCHE_DOUBLONS (
    I_DOSSIER Integer,
    CLE_IND Integer,
    PRENOM_VARIABLE Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISS Varchar(100),
    LIEU_NAISS Varchar(50),
    DATE_DECES Varchar(100),
    LIEU_DECES Varchar(50) )
AS
declare variable i_cle_fiche integer;
declare variable i integer;
declare variable cle_fiche2 integer;
declare variable nom2 varchar(40);
declare variable prenom2 varchar(60);
declare variable date_naiss2 varchar(100);
declare variable lieu_naiss2 varchar(50);
declare variable date_deces2 varchar(100);
declare variable lieu_deces2 varchar(50);
declare variable langue varchar(3);
declare variable valmax integer = 3000000;
declare variable valmin integer = -2147483647;
begin
  valmax=3000000;
  valmin=-2147483647;
  select ds_langue
  from dossier
  where cle_dossier=:i_dossier
  into langue;
  select nom from individu where cle_fiche=:cle_ind into :nom2;
  rdb$set_context('USER_SESSION','LANGUE',langue);
  delete from tq_id;
  delete from tq_rech_doublons;
  insert into tq_rech_doublons (cle_fiche
                               ,ville_naissance
                               ,ville_deces
                               ,date_naissance
                               ,date_naissance_fin
                               ,date_deces
                               ,date_deces_fin)
    select i.cle_fiche
            ,n.ev_ind_ville
            ,d.ev_ind_ville
            ,case
              when n.ev_ind_datecode_tot=:valmin and n.ev_ind_datecode_tard<:valmax then n.ev_ind_datecode_tard-10000
              else n.ev_ind_datecode_tot
              end
            ,case
              when n.ev_ind_datecode_tard=:valmax and n.ev_ind_datecode_tot>:valmin then n.ev_ind_datecode_tot+10000
              else n.ev_ind_datecode_tard
              end
            ,case
              when d.ev_ind_datecode_tot=:valmin and d.ev_ind_datecode_tard<:valmax then d.ev_ind_datecode_tard-10000
              else d.ev_ind_datecode_tot
              end
            ,case
              when d.ev_ind_datecode_tard=:valmax and d.ev_ind_datecode_tot>:valmin then d.ev_ind_datecode_tot+10000
              else d.ev_ind_datecode_tard
              end
         from individu i
           left join evenements_ind n on n.ev_ind_kle_fiche=i.cle_fiche and n.ev_ind_type='BIRT'
           left join evenements_ind d on d.ev_ind_kle_fiche=i.cle_fiche and d.ev_ind_type='DEAT'
         where i.kle_dossier=:i_dossier
           and (:cle_ind=0 or i.nom=:nom2 or i.nom in(select distinct nom from(
                 select nom from nom_attachement where id_indi=:cle_ind
                 union select nom from nom_attachement where kle_dossier=:i_dossier and nom_indi=:nom2))
                 or :nom2 in(select distinct nom from(select nom from nom_attachement where id_indi=i.cle_fiche
                 union select nom from nom_attachement where kle_dossier=:i_dossier and nom_indi=i.nom)));

  if (prenom_variable in (1,3)) then
  begin
    delete from tq_prenoms;
    insert into tq_prenoms (combien
                           ,dossier
                           ,prenom)
                  select p.cle_fiche
                        ,:i_dossier
                        ,(select s_out from f_maj_sans_accent(p.prenom))
                  from proc_liste_prenom(:i_dossier) p;
  end
  if (cle_ind>0) then --doublons de cle_ind
    if (prenom_variable in (1,3)) then
      for select distinct
                atq.cle_fiche
               ,btq.cle_fiche
        from tq_rech_doublons atq,
             tq_rech_doublons btq
             inner join individu a on a.cle_fiche=atq.cle_fiche
             inner join individu b on b.cle_fiche=btq.cle_fiche
        where atq.cle_fiche<>btq.cle_fiche
          and a.sexe=b.sexe
          and (exists(select 1 from tq_prenoms x where x.combien=atq.cle_fiche
                      and exists(select 1 from tq_prenoms where combien=btq.cle_fiche and prenom=x.prenom)))
          and ((:prenom_variable=3) or (btq.cle_fiche=:cle_ind))
          and ((atq.date_naissance>=btq.date_naissance
                 and atq.date_naissance<=btq.date_naissance_fin)
               or (atq.date_naissance_fin>=btq.date_naissance
                 and atq.date_naissance_fin<=btq.date_naissance_fin)
               or (atq.date_naissance<=btq.date_naissance
                 and atq.date_naissance_fin>=btq.date_naissance_fin)
               or atq.date_naissance is  null
               or btq.date_naissance is  null)
          and (atq.ville_naissance=btq.ville_naissance
               or atq.ville_naissance is  null
               or btq.ville_naissance is  null)
          and ((atq.date_deces>=btq.date_deces
                 and atq.date_deces<=btq.date_deces_fin)
               or (atq.date_deces_fin>=btq.date_deces
                 and atq.date_deces_fin<=btq.date_deces_fin)
               or (atq.date_deces<=btq.date_deces
                 and atq.date_deces_fin>=btq.date_deces_fin)
               or atq.date_deces is  null
               or btq.date_deces is  null)
          and (atq.ville_deces=btq.ville_deces
               or atq.ville_deces is  null
               or btq.ville_deces is  null)
          and (atq.date_naissance<=btq.date_deces_fin
               or atq.date_naissance is null
               or btq.date_deces_fin is null)
          and (btq.date_naissance<=atq.date_deces_fin
               or btq.date_naissance is null
               or atq.date_deces_fin is null)
             into :cle_fiche,
                  :i_cle_fiche
      do
        insert into tq_id (id1,id2) values(:cle_fiche,:i_cle_fiche);
    else  --(CLE_IND>0) et (prenom_variable=0)
      for select distinct
                atq.cle_fiche
               ,btq.cle_fiche
        from tq_rech_doublons atq,
             tq_rech_doublons btq
             inner join individu a on a.cle_fiche=atq.cle_fiche
             inner join individu b on b.cle_fiche=btq.cle_fiche
        where atq.cle_fiche<>btq.cle_fiche
          and a.prenom=b.prenom
          and a.sexe=b.sexe
          and (:prenom_variable=2 or btq.cle_fiche=:cle_ind)
          and ((atq.date_naissance>=btq.date_naissance
                 and atq.date_naissance<=btq.date_naissance_fin)
               or (atq.date_naissance_fin>=btq.date_naissance
                 and atq.date_naissance_fin<=btq.date_naissance_fin)
               or (atq.date_naissance<=btq.date_naissance
                 and atq.date_naissance_fin>=btq.date_naissance_fin)
               or atq.date_naissance is  null
               or btq.date_naissance is  null)
          and (atq.ville_naissance=btq.ville_naissance
               or atq.ville_naissance is  null
               or btq.ville_naissance is  null)
          and ((atq.date_deces>=btq.date_deces
                 and atq.date_deces<=btq.date_deces_fin)
               or (atq.date_deces_fin>=btq.date_deces
                 and atq.date_deces_fin<=btq.date_deces_fin)
               or (atq.date_deces<=btq.date_deces
                 and atq.date_deces_fin>=btq.date_deces_fin)
               or atq.date_deces is  null
               or btq.date_deces is  null)
          and (atq.ville_deces=btq.ville_deces
               or atq.ville_deces is  null
               or btq.ville_deces is  null)
          and (atq.date_naissance<=btq.date_deces_fin
               or atq.date_naissance is null
               or btq.date_deces_fin is null)
          and (btq.date_naissance<=atq.date_deces_fin
               or btq.date_naissance is null
               or atq.date_deces_fin is null)
             into :cle_fiche,
                  :i_cle_fiche
      do
        insert into tq_id (id1,id2) values(:cle_fiche,:i_cle_fiche);
  else --(CLE_IND=0) => tous les doublons
    if (prenom_variable=1) then
      for select distinct
                atq.cle_fiche
               ,btq.cle_fiche
        from tq_rech_doublons atq,
             tq_rech_doublons btq
             inner join individu a on a.cle_fiche=atq.cle_fiche
             inner join individu b on b.cle_fiche=btq.cle_fiche
        where atq.cle_fiche <> btq.cle_fiche
          and a.nom = b.nom
          and a.sexe=b.sexe
          and (exists(select 1 from tq_prenoms x where x.combien=atq.cle_fiche
                      and exists(select 1 from tq_prenoms where combien=btq.cle_fiche and prenom=x.prenom)))
          and ((atq.date_naissance>=btq.date_naissance
                 and atq.date_naissance<=btq.date_naissance_fin)
               or (atq.date_naissance_fin>=btq.date_naissance
                 and atq.date_naissance_fin<=btq.date_naissance_fin)
               or (atq.date_naissance<=btq.date_naissance
                 and atq.date_naissance_fin>=btq.date_naissance_fin)
               or atq.date_naissance is  null
               or btq.date_naissance is  null)
          and (atq.ville_naissance=btq.ville_naissance
               or atq.ville_naissance is  null
               or btq.ville_naissance is  null)
          and ((atq.date_deces>=btq.date_deces
                 and atq.date_deces<=btq.date_deces_fin)
               or (atq.date_deces_fin>=btq.date_deces
                 and atq.date_deces_fin<=btq.date_deces_fin)
               or (atq.date_deces<=btq.date_deces
                 and atq.date_deces_fin>=btq.date_deces_fin)
               or atq.date_deces is  null
               or btq.date_deces is  null)
          and (atq.ville_deces=btq.ville_deces
               or atq.ville_deces is  null
               or btq.ville_deces is  null)
          and (atq.date_naissance<=btq.date_deces_fin
               or atq.date_naissance is null
               or btq.date_deces_fin is null)
          and (btq.date_naissance<=atq.date_deces_fin
               or btq.date_naissance is null
               or atq.date_deces_fin is null)
             into :cle_fiche,
                  :i_cle_fiche
      do
        insert into tq_id (id1,id2) values(:cle_fiche,:i_cle_fiche);
    else --(CLE_IND=0) et (prenom_variable=0)
      for select distinct
                atq.cle_fiche
               ,btq.cle_fiche
        from tq_rech_doublons atq,
             tq_rech_doublons btq
             inner join individu a on a.cle_fiche=atq.cle_fiche
             inner join individu b on b.cle_fiche=btq.cle_fiche
        where atq.cle_fiche<>btq.cle_fiche
          and a.nom=b.nom
          and a.prenom=b.prenom
          and a.sexe=b.sexe
          and ((atq.date_naissance>=btq.date_naissance
                 and atq.date_naissance<=btq.date_naissance_fin)
               or (atq.date_naissance_fin>=btq.date_naissance
                 and atq.date_naissance_fin<=btq.date_naissance_fin)
               or (atq.date_naissance<=btq.date_naissance
                 and atq.date_naissance_fin>=btq.date_naissance_fin)
               or atq.date_naissance is  null
               or btq.date_naissance is  null)
          and (atq.ville_naissance=btq.ville_naissance
               or atq.ville_naissance is  null
               or btq.ville_naissance is  null)
          and ((atq.date_deces>=btq.date_deces
                 and atq.date_deces<=btq.date_deces_fin)
               or (atq.date_deces_fin>=btq.date_deces
                 and atq.date_deces_fin<=btq.date_deces_fin)
               or (atq.date_deces<=btq.date_deces
                 and atq.date_deces_fin>=btq.date_deces_fin)
               or atq.date_deces is  null
               or btq.date_deces is  null)
          and (atq.ville_deces=btq.ville_deces
               or atq.ville_deces is  null
               or btq.ville_deces is  null)
          and (atq.date_naissance<=btq.date_deces_fin
               or atq.date_naissance is null
               or btq.date_deces_fin is null)
          and (btq.date_naissance<=atq.date_deces_fin
               or btq.date_naissance is null
               or atq.date_deces_fin is null)
             into :cle_fiche,
                  :i_cle_fiche
      do
        insert into tq_id (id1,id2) values(:cle_fiche,:i_cle_fiche);
  delete from tq_prenoms;
  delete from tq_id t  --élimination si parents différents
    where ((select cle_pere from individu where cle_fiche=t.id1) is not null
            and (select cle_pere from individu where cle_fiche=t.id2) is not null
            and not exists(select *
                     from individu i1
                         ,individu i2
                         ,tq_id tqp
                     where i1.cle_fiche=t.id1
                       and i2.cle_fiche=t.id2
                       and tqp.id1=i1.cle_pere and tqp.id2=i2.cle_pere))
           or ((select cle_mere from individu where cle_fiche=t.id1) is not null
                 and (select cle_mere from individu where cle_fiche=t.id2) is not null
                 and not exists(select *
                     from individu i1
                         ,individu i2
                         ,tq_id tqm
                     where i1.cle_fiche=t.id1
                       and i2.cle_fiche=t.id2
                       and tqm.id1=i1.cle_mere and tqm.id2=i2.cle_mere));
  delete from tq_id t --élimination si liés par parenté
    where (select oui from proc_test_parente(t.id1,t.id2,3))=1;
  delete from tq_consang;
  delete from tq_id t  --ne garder qu'une ligne par paire de doublons
    where exists(select * from tq_id tq where tq.id1=t.id2 and tq.id2=t.id1);
  i=0;
  for select   --émission des résultats
             t.id1
             ,i1.nom
             ,i1.prenom
             ,i1.date_naissance
             ,tq1.ville_naissance
             ,i1.date_deces
             ,tq1.ville_deces
             ,t.id2
             ,i2.nom
             ,i2.prenom
             ,i2.date_naissance
             ,tq2.ville_naissance
             ,i2.date_deces
             ,tq2.ville_deces
             ,:i+1
      from tq_id t
        inner join individu i1 on i1.cle_fiche=t.id1
        inner join tq_rech_doublons tq1 on tq1.cle_fiche=t.id1
        inner join individu i2 on i2.cle_fiche=t.id2
        inner join tq_rech_doublons tq2 on tq2.cle_fiche=t.id2
      order by i1.nom,i1.prenom,tq1.date_naissance nulls first
             into
                  :cle_fiche
                 ,:nom
                 ,:prenom
                 ,:date_naiss
                 ,:lieu_naiss
                 ,:date_deces
                 ,:lieu_deces
                 ,:cle_fiche2
                 ,:nom2
                 ,:prenom2
                 ,:date_naiss2
                 ,:lieu_naiss2
                 ,:date_deces2
                 ,:lieu_deces2
                 ,:i
      do
      begin
        prenom=substring(cast(i as varchar(6))||'-'||prenom from 1 for 60);
        suspend;
        cle_fiche=cle_fiche2;
        nom=nom2;
        prenom=substring(cast(i as varchar(6))||'-'||prenom2 from 1 for 60);
        date_naiss=date_naiss2;
        lieu_naiss=lieu_naiss2;
        date_deces=date_deces2;
        lieu_deces=lieu_deces2;
        suspend;
      end
  delete from tq_rech_doublons;
  delete from tq_id;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée le :16/11/2006 par André Langlet pour élargir aux doublons "possibles"
avec en option l''élargissement aux indis ayant les mêmes prénoms dans un
ordre différent.
Refaite le 10/03/2012 en utilisant les datecodes au plus tôt et au plus tard.
Description :remonte la liste des doublons contenus dans le dossier I_DOSSIER
Usage       :si CLE_IND=0 tout le dossier est analysé,
si CLE_IND>0 on recherche les doublons de l''individu.
PRENOM_VARIABLE=0 impose la similitude complète de la liste des prénoms
des individus doublons.
PRENOM_VARIABLE=1 demande que tous les prénoms de l''un soient contenus dans
les prénoms de l''autre.
PRENOM_VARIABLE=2 et 3 sont similaires respectivement à 0 et 1, mais la
recherche s''effectue sur tous les individus du même patronyme que CLE_IND.'
  where RDB$PROCEDURE_NAME = 'PROC_CHERCHE_DOUBLONS';

SET TERM ^ ;
ALTER PROCEDURE PROC_COMPTAGE (
    I_DOSSIER Integer )
RETURNS (
    LIBELLE Varchar(7),
    COMPTAGE Integer )
AS
declare variable s_ville varchar(50);
declare variable s_dept varchar(30);
declare variable s_region varchar(50);
declare variable s_pays varchar(30);
declare variable i integer;
begin
  delete from tq_transit;
  for select coalesce(lower(trim(ev_ind_ville)),'')
            ,coalesce(lower(trim(ev_ind_dept)),'')
            ,coalesce(lower(trim(ev_ind_region)),'')
            ,coalesce(lower(trim(ev_ind_pays)),'')
      from evenements_ind
      where ev_ind_kle_dossier=:i_dossier
        and not(ev_ind_ville is null and ev_ind_dept is null
                and ev_ind_region is null and ev_ind_pays is null)
      union
      select coalesce(lower(trim(ev_fam_ville)),'')
            ,coalesce(lower(trim(ev_fam_dept)),'')
            ,coalesce(lower(trim(ev_fam_region)),'')
            ,coalesce(lower(trim(ev_fam_pays)),'')
      from evenements_fam
      where ev_fam_kle_dossier=:i_dossier
        and not(ev_fam_ville is null and ev_fam_dept is null
                and ev_fam_region is null and ev_fam_pays is null)
      into :s_ville
          ,:s_dept
          ,:s_region
          ,:s_pays
  do insert into tq_transit (champ1,champ2,champ3,champ4)
            values(:s_ville,:s_dept,:s_region,:s_pays);
  for select cast('EVE_IND' as varchar(7)),count(*)
      from evenements_ind
      where (ev_ind_kle_dossier=:i_dossier and ev_ind_type<>'RESI')
      union
      select cast('EVE_FAM' as varchar(7)),count(*)
      from evenements_fam
      where (ev_fam_kle_dossier=:i_dossier)
      union
      select cast('_VILLES' as varchar(7)),count(*)
      from (select distinct champ1,champ2,champ3,champ4 from  tq_transit)
      union
      select cast('DEPARTE' as varchar(7)),count(*)
      from (select distinct champ2,champ3,champ4 from  tq_transit)
      union
      select cast('REGIONS' as varchar(7)),count(*)
      from (select distinct champ3,champ4 from  tq_transit)
      union
      select cast('___PAYS' as varchar(7)),count(*)
      from (select distinct champ4 from  tq_transit)
      union
      select cast('ADRESSE' as varchar(7)),count(*)
      from evenements_ind
      where (ev_ind_kle_dossier=:i_dossier and ev_ind_type='RESI')
      union
      select cast('MULTIME' as varchar(7)),count(*)
      from multimedia
      where multi_dossier=:i_dossier
      union
      select cast('INDIVID' as varchar(7)), count(*)
      from individu
      where kle_dossier=:i_dossier
      union
      select cast('PATRONY' as varchar(7)),count(distinct nom)
      from individu
      where kle_dossier=:i_dossier
      union
      select cast('TUNIONS' as varchar(7)),count(*)
      from t_union
      where kle_dossier=:i_dossier and union_mari>0 and union_femme>0
      union
      select cast('_HOMMES' as varchar(7)),count(*)
      from  individu
      where kle_dossier=:i_dossier and sexe=1
      union
      select cast('_FEMMES' as varchar(7)),count(*)
      from  individu
      where kle_dossier=:i_dossier and sexe=2
      union
      select cast('INDETER' as varchar(7)),count(*)
      from individu
      where kle_dossier=:i_dossier and sexe<>1 and sexe<>2
      into :libelle
          ,:comptage
  do suspend;
  delete from tq_transit;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Informations sur le dossier en cours
Refonte par André Langlet:
le 8/12/2005 comptage villes, dept, régions et pays du dossier
le 12/12/2005 ignorer les erreurs de minuscules, espaces
le 23/08/2007 suppression du comptage des lieux, unions avec 2 conjoints
le 26/12/2009 suppression du mode
le 25/10/2010 suppression des références à la table adresses_ind
le 26/03/2011 modification remplissage de TQ_TRANSIT'
  where RDB$PROCEDURE_NAME = 'PROC_COMPTAGE';

SET TERM ^ ;
ALTER PROCEDURE PROC_CONJOINTS_ORDONNES (
    INDI Integer,
    C_INCONNU Integer )
RETURNS (
    ORDRE Integer,
    CLEF_UNION Integer,
    CONJOINT Integer,
    CLEF_MARR Integer )
AS
begin
  if (rdb$get_context('USER_SESSION','LANGUE') is null) then
  begin
    rdb$set_context('USER_SESSION','LANGUE',(select d.ds_langue
    from individu i inner join dossier d on d.cle_dossier=i.kle_dossier
    where i.cle_fiche=:indi));
  end
  ordre=0;
  for select distinct
      :ordre+1
     ,r.union_clef
     ,r.conjoint
     ,r.clef_marr
  from (select
     u.union_clef
     ,case u.union_mari
        when :indi then u.union_femme
        else u.union_mari
        end as conjoint
     ,(select first(1) ev_fam_clef
       from evenements_fam
       where ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
       order by ev_fam_datecode,ev_fam_heure) as clef_marr
     ,(select first(1) ev_fam_datecode
       from evenements_fam
       where ev_fam_kle_famille=u.union_clef and ev_fam_datecode is not null
       order by ev_fam_datecode) as date_prem_fam
     ,(select first(1) n.ev_ind_datecode
       from individu e inner join evenements_ind n on n.ev_ind_kle_fiche=e.cle_fiche
       where e.cle_pere is not distinct from u.union_mari
         and e.cle_mere is not distinct from u.union_femme
         and n.ev_ind_datecode is not null
       order by n.ev_ind_datecode) as date_prem_enf
     ,(select first(1) ev_ind_datecode
       from evenements_ind
       where ev_ind_kle_fiche=case u.union_mari
                              when :indi then u.union_femme
                              else u.union_mari
                              end
        and ev_ind_datecode is not null
       order by ev_ind_datecode desc) as date_dern_eve
     from t_union u
      left join individu e on e.cle_pere is not distinct from u.union_mari and e.cle_mere is not distinct from u.union_femme
     where :indi in (u.union_mari,u.union_femme)) as r

     order by case
              when (r.date_prem_enf is null) and (r.date_prem_fam is null) then r.date_dern_eve
              when (r.date_prem_enf is null) then r.date_prem_fam
              when (r.date_prem_fam is null) then r.date_prem_enf
              when (r.date_prem_fam<=r.date_prem_enf) then r.date_prem_fam
              else r.date_prem_enf
              end
              ,r.union_clef
     into
        ordre
       ,clef_union
       ,conjoint
       ,clef_marr
  do
    if ((c_inconnu=1) or (conjoint>0)) then
    suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André Langlet le 07/04/2009 servant de base à toutes les requêtes
demandant les conjoints dans l''ordre chronologique.
Dernière modification: 08/03/2012 utilisation des date_code pour le tri.'
  where RDB$PROCEDURE_NAME = 'PROC_CONJOINTS_ORDONNES';

SET TERM ^ ;
ALTER PROCEDURE PROC_CONSANG (
    INDIVIDU Integer,
    INDIVIDU2 Integer,
    NIVEAU_CALCUL Integer )
RETURNS (
    CONSANGUINITE Double precision )
AS
declare variable pere integer;
declare variable mere integer;
declare variable k integer;
declare variable niveaux integer;
declare variable id integer;
declare variable cle_indi integer;
declare variable cle_pere integer;
declare variable cle_mere integer;
declare variable cle_parent integer;
begin
  if (individu2<>0) then
  begin
    pere=individu;
    mere=individu2;
  end
  else
    select cle_pere,cle_mere from individu
    where cle_fiche=:individu
    into :pere,:mere;
  if (pere=0 or pere is null or mere=0 or mere is null) then
  begin
    consanguinite=0;
    suspend;
    exit;
  end
  if (pere=mere) then
  begin
    consanguinite=1;
    suspend;
    exit;
  end
  id=gen_id(gen_consang,1);
  insert into tq_consang (id,decujus,niveau,indi,enfant)
                 values(:id,:pere,0,:pere,:pere);
  insert into tq_consang (id,decujus,niveau,indi,enfant)
                 values(:id,:mere,0,:mere,:mere);
  k=0;
  while (1=1) do
  begin
    k=k+1;
    for select i.cle_pere,i.cle_mere,tq.indi,tq.decujus
      from tq_consang tq
      inner join individu i on i.cle_fiche=tq.indi
      where tq.id=:id and tq.niveau=:k-1
      into :cle_pere,:cle_mere,:cle_indi,:cle_parent
    do
    begin
      if (cle_pere is not null) then
        insert into tq_consang (id,decujus,niveau,indi,enfant)
        values(:id,:cle_parent,:k,:cle_pere,:cle_indi);
      if (cle_mere is not null) then
        insert into tq_consang (id,decujus,niveau,indi,enfant)
        values(:id,:cle_parent,:k,:cle_mere,:cle_indi);
    end
    if ((not exists(select 1 from tq_consang where id=:id and niveau=:k))
      or (k=niveau_calcul)) then leave; --pas plus de NIVEAU_CALCUL générations si boucle
  end
  consanguinite=0;
  for select all p.niveau+m.niveau+1
    from tq_consang p
    inner join tq_consang m on m.id=p.id and m.decujus=:mere
      and m.indi=p.indi and m.enfant<>p.enfant
    where p.id=:id and p.decujus=:pere
    into :niveaux
  do
    consanguinite=consanguinite+power(0.5,niveaux);
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Création par André Langlet le 16/12/2005. Dernière modification 20/05/2011
Si INDIVIDU2=0, retourne dans CONSANGUINITE la consanguinité de INDIVIDU.
Sinon, retourne dans CONSANGUINITE la parenté entre INDIVIDU et INDIVIDU2
NIVEAU_CALCUL limite le nombre de niveaux sur lequel est effectué le calcul.'
  where RDB$PROCEDURE_NAME = 'PROC_CONSANG';

SET TERM ^ ;
ALTER PROCEDURE PROC_COPIE_DOSSIER (
    DOSSIERS Integer,
    I_DOSSIERC Integer )
RETURNS (
    DOSSIERC Integer,
    LANGUEDIFFERENTE Integer )
AS
declare variable ig_id integer;
declare variable old_id integer;
declare variable new_id integer;
declare variable source_page varchar(248);
declare variable even varchar(15);
declare variable even_role varchar(25);
declare variable data_even varchar(90);
declare variable data_even_period varchar(35);
declare variable data_even_plac varchar(120);
declare variable data_agnc varchar(120);
declare variable quay integer;
declare variable auth blob sub_type 1 segment size 80;
declare variable titl blob sub_type 1 segment size 80;
declare variable abr varchar(60);
declare variable publ blob sub_type 1 segment size 80;
declare variable texte blob sub_type 1 segment size 80;
declare variable user_ref blob sub_type 1 segment size 80;
declare variable rin varchar(12);
declare variable change_note blob sub_type 1 segment size 80;
declare variable point_enr char(8);
declare variable i_pere integer;
declare variable i_mere integer;
begin
  select cle_dossier from dossier
  where cle_dossier=:i_dossierc
  into :dossierc; --si n'existe pas reste null
  if (dossierc is null) then
  begin --création d'un nouveau dossier
    dossierc=gen_id(gen_dossier,1);
    insert into dossier (cle_dossier
                         ,nom_dossier
                         ,ds_verrou
                         ,ds_infos
                         ,ds_last
                         ,ds_langue)
                  values( :dossierc
                         ,'Copie du dossier '||:dossiers
                         ,0
                         ,'Dossier créé le '||current_date||' à:'
                          ||substring(cast(current_time as varchar(15)) from 1 for 5)
                         ,-1
                         ,(select ds_langue from dossier where cle_dossier=:dossiers));
    languedifferente=0;
  end
  else
  begin --enregistrement comme importation
    if((select ds_langue from dossier where cle_dossier=:dossiers)<>
      (select ds_langue from dossier where cle_dossier=:dossierc))then
    begin
      languedifferente=1;
      suspend;
      exit;
    end
    ig_id=gen_id(t_import_gedcom_ig_id_gen,1);
    insert into t_import_gedcom ( ig_id
                                 ,ig_path)
                          values( :ig_id
                                 ,'Copie du dossier '||:dossiers||
                                  ' dans le dossier '||:dossierc);
  end
  delete from  tq_consang; --nettoyage de la table temporaire
  insert into tq_consang (id,indi,decujus) --correspondances individus
         select 1
               ,cle_fiche
               ,gen_id(gen_individu,1)
         from individu
         where kle_dossier=:dossiers;
  insert into individu ( cle_fiche
                        ,kle_dossier
                        ,cle_pere
                        ,cle_mere
                        ,prefixe
                        ,nom
                        ,prenom
                        ,surnom
                        ,suffixe
                        ,sexe
                        ,source
                        ,comment
                        ,filliation
                        ,modif_par_qui
                        ,nchi
                        ,nmr
                        ,cle_fixe
                        ,ind_confidentiel
                        ,id_import_gedcom)
                 select t.decujus
                       ,:dossierc
                       ,i.cle_pere
                       ,i.cle_mere
                       ,i.prefixe
                       ,i.nom
                       ,i.prenom
                       ,i.surnom
                       ,i.suffixe
                       ,i.sexe
                       ,i.source
                       ,i.comment
                       ,i.filliation
                       ,i.modif_par_qui
                       ,i.nchi
                       ,i.nmr
                       ,i.cle_fixe
                       ,i.ind_confidentiel
                       ,:ig_id
                 from tq_consang t
                 inner join individu i on i.cle_fiche=t.indi
                 where t.id=1;
  for select i.rdb$db_key --mise à jour cle_père et cle_mere
            ,i.cle_pere
            ,i.cle_mere
    from tq_consang t
    inner join individu i on i.cle_fiche=t.decujus
    where t.id=1
    into :point_enr
        ,:i_pere
        ,:i_mere
    do
    begin
      if (i_pere is not null) then
        update individu
        set cle_pere=(select decujus from tq_consang where id=1 and indi=:i_pere)
        where rdb$db_key=:point_enr;
      if (i_mere is not null) then
        update individu
        set cle_mere=(select decujus from tq_consang where id=1 and indi=:i_mere)
        where rdb$db_key=:point_enr;
    end
  insert into tq_consang (id,indi,decujus) --correspondances multimedia
         select 2
               ,multi_clef
               ,gen_id(gen_multimedia,1)
         from multimedia
         where multi_dossier=:dossiers;
  insert into multimedia ( multi_clef
                          ,multi_infos
                          ,multi_media
                          ,multi_dossier
                          ,multi_date_modif
                          ,multi_memo
                          ,multi_reduite
                          ,multi_image_rtf
                          ,multi_path
                          ,id_import_gedcom)
                   select t.decujus
                         ,m.multi_infos
                         ,m.multi_media
                         ,:dossierc
                         ,m.multi_date_modif
                         ,m.multi_memo
                         ,m.multi_reduite
                         ,m.multi_image_rtf
                         ,m.multi_path
                         ,:ig_id
                   from tq_consang t
                   inner join multimedia m on m.multi_clef=t.indi
                   where t.id=2;
  insert into tq_consang (id,indi,decujus) --correspondances événements individuels
         select 3
               ,e.ev_ind_clef
               ,gen_id(gen_ev_ind_clef,1)
         from evenements_ind e
         inner join tq_consang t on t.id=1 and t.indi=e.ev_ind_kle_fiche;
  insert into evenements_ind ( ev_ind_clef
                              ,ev_ind_kle_fiche
                              ,ev_ind_kle_dossier
                              ,ev_ind_type
                              ,ev_ind_date_writen
                              ,ev_ind_date
                              ,ev_ind_date_year
                              ,ev_ind_date_mois
                              ,ev_ind_date_year_fin
                              ,ev_ind_date_mois_fin
                              ,ev_ind_adresse
                              ,ev_ind_cp
                              ,ev_ind_ville
                              ,ev_ind_dept
                              ,ev_ind_pays
                              ,ev_ind_cause
                              ,ev_ind_source
                              ,ev_ind_comment
                              ,ev_ind_description
                              ,ev_ind_region
                              ,ev_ind_subd
                              ,ev_ind_acte
                              ,ev_ind_insee
                              ,ev_ind_ordre
                              ,ev_ind_heure
                              ,ev_ind_titre_event
                              ,ev_ind_latitude
                              ,ev_ind_longitude
                              ,ev_ind_lignes_adresse
                              ,ev_ind_tel
                              ,ev_ind_mail
                              ,ev_ind_web
                              ,ev_ind_date_jour
                              ,ev_ind_date_jour_fin
                              ,ev_ind_type_token1
                              ,ev_ind_type_token2
                              ,ev_ind_calendrier1
                              ,ev_ind_calendrier2
                              ,ev_ind_datecode
                              ,ev_ind_datecode_tot
                              ,ev_ind_datecode_tard)
                       select t.decujus
                             ,(select decujus from tq_consang where id=1 and indi=e.ev_ind_kle_fiche)
                             ,:dossierc
                             ,e.ev_ind_type
                             ,e.ev_ind_date_writen
                             ,e.ev_ind_date
                             ,e.ev_ind_date_year
                             ,e.ev_ind_date_mois
                             ,e.ev_ind_date_year_fin
                             ,e.ev_ind_date_mois_fin
                             ,e.ev_ind_adresse
                             ,e.ev_ind_cp
                             ,e.ev_ind_ville
                             ,e.ev_ind_dept
                             ,e.ev_ind_pays
                             ,e.ev_ind_cause
                             ,e.ev_ind_source
                             ,e.ev_ind_comment
                             ,e.ev_ind_description
                             ,e.ev_ind_region
                             ,e.ev_ind_subd
                             ,e.ev_ind_acte
                             ,e.ev_ind_insee
                             ,e.ev_ind_ordre
                             ,e.ev_ind_heure
                             ,e.ev_ind_titre_event
                             ,e.ev_ind_latitude
                             ,e.ev_ind_longitude
                             ,e.ev_ind_lignes_adresse
                             ,e.ev_ind_tel
                             ,e.ev_ind_mail
                             ,e.ev_ind_web
                             ,e.ev_ind_date_jour
                             ,e.ev_ind_date_jour_fin
                             ,e.ev_ind_type_token1
                             ,e.ev_ind_type_token2
                             ,e.ev_ind_calendrier1
                             ,e.ev_ind_calendrier2
                             ,e.ev_ind_datecode
                             ,e.ev_ind_datecode_tot
                             ,e.ev_ind_datecode_tard
                       from  tq_consang t
                       inner join evenements_ind e on e.ev_ind_clef=t.indi
                       where t.id=3;
  insert into tq_consang (id,indi,decujus) --correspondances unions
         select 4
               ,t.union_clef
               ,gen_id(gen_t_union,1)
         from t_union t where (t.union_mari is not null
                               and t.union_femme is not null --2 époux
                               and exists (select 0 from tq_consang where id=1
                                            and indi=t.union_mari)
                               and exists (select 0 from tq_consang where id=1
                                            and indi=t.union_femme))
                           or (t.union_mari is not null --pères seuls
                               and t.union_femme is null
                               and exists (select 0 from tq_consang where id=1
                                            and indi=t.union_mari))
                           or (t.union_mari is null
                               and t.union_femme is not null --mères seules
                               and exists (select 0 from tq_consang where id=1
                                            and indi=t.union_femme));
  insert into t_union ( union_clef
                       ,union_mari
                       ,union_femme
                       ,kle_dossier
                       ,union_type
                       ,source
                       ,comment)
                select t.decujus
                      ,(select decujus from tq_consang where id=1 and indi=u.union_mari)
                      ,(select decujus from tq_consang where id=1 and indi=u.union_femme)
                      ,:dossierc
                      ,u.union_type
                      ,u.source
                      ,u.comment
                from tq_consang t
                inner join t_union u on u.union_clef=t.indi
                where t.id=4;
  insert into tq_consang (id,indi,decujus) --correspondances événements familiaux
         select 5
               ,e.ev_fam_clef
               ,gen_id(gen_ev_fam_clef,1)
         from evenements_fam e
         inner join tq_consang t on t.indi=e.ev_fam_kle_famille
         where t.id=4;
  insert into evenements_fam ( ev_fam_clef
                              ,ev_fam_kle_famille
                              ,ev_fam_kle_dossier
                              ,ev_fam_type
                              ,ev_fam_date_writen
                              ,ev_fam_date
                              ,ev_fam_date_year
                              ,ev_fam_date_mois
                              ,ev_fam_date_year_fin
                              ,ev_fam_date_mois_fin
                              ,ev_fam_adresse
                              ,ev_fam_cp
                              ,ev_fam_ville
                              ,ev_fam_dept
                              ,ev_fam_pays
                              ,ev_fam_source
                              ,ev_fam_comment
                              ,ev_fam_region
                              ,ev_fam_subd
                              ,ev_fam_acte
                              ,ev_fam_insee
                              ,ev_fam_ordre
                              ,ev_fam_heure
                              ,ev_fam_titre_event
                              ,ev_fam_latitude
                              ,ev_fam_longitude
                              ,ev_fam_description
                              ,ev_fam_cause
                              ,ev_fam_date_jour
                              ,ev_fam_date_jour_fin
                              ,ev_fam_type_token1
                              ,ev_fam_type_token2
                              ,ev_fam_calendrier1
                              ,ev_fam_calendrier2
                              ,ev_fam_datecode
                              ,ev_fam_datecode_tot
                              ,ev_fam_datecode_tard)
                       select t.decujus
                             ,(select decujus from tq_consang where id=4 and indi=e.ev_fam_kle_famille)
                             ,:dossierc
                             ,e.ev_fam_type
                             ,e.ev_fam_date_writen
                             ,e.ev_fam_date
                             ,e.ev_fam_date_year
                             ,e.ev_fam_date_mois
                             ,e.ev_fam_date_year_fin
                             ,e.ev_fam_date_mois_fin
                             ,e.ev_fam_adresse
                             ,e.ev_fam_cp
                             ,e.ev_fam_ville
                             ,e.ev_fam_dept
                             ,e.ev_fam_pays
                             ,e.ev_fam_source
                             ,e.ev_fam_comment
                             ,e.ev_fam_region
                             ,e.ev_fam_subd
                             ,e.ev_fam_acte
                             ,e.ev_fam_insee
                             ,e.ev_fam_ordre
                             ,e.ev_fam_heure
                             ,e.ev_fam_titre_event
                             ,e.ev_fam_latitude
                             ,e.ev_fam_longitude
                             ,e.ev_fam_description
                             ,e.ev_fam_cause
                             ,e.ev_fam_date_jour
                             ,e.ev_fam_date_jour_fin
                             ,e.ev_fam_type_token1
                             ,e.ev_fam_type_token2
                             ,e.ev_fam_calendrier1
                             ,e.ev_fam_calendrier2
                             ,e.ev_fam_datecode
                             ,e.ev_fam_datecode_tot
                             ,e.ev_fam_datecode_tard
                       from tq_consang t
                       inner join evenements_fam e on e.ev_fam_clef=t.indi
                       where t.id=5;
  insert into t_associations ( assoc_clef --associés à événements individuels
                              ,assoc_kle_ind
                              ,assoc_kle_associe
                              ,assoc_kle_dossier
                              ,assoc_notes
                              ,assoc_sources
                              ,assoc_libelle
                              ,assoc_evenement
                              ,assoc_table)
                      select gen_id(gen_assoc_clef,1)
                            ,ev.ev_ind_kle_fiche
                            ,a.decujus
                            ,:dossierc
                            ,t.assoc_notes
                            ,t.assoc_sources
                            ,t.assoc_libelle
                            ,e.decujus
                            ,'I'
                      from  t_associations t
                      inner join tq_consang a on a.id=1 and a.indi=t.assoc_kle_associe
                      inner join tq_consang e on e.id=3 and e.indi=t.assoc_evenement
                      inner join evenements_ind ev on ev.ev_ind_clef=e.decujus
                      where t.assoc_table='I';
  insert into t_associations ( assoc_clef --associés à événements familiaux
                              ,assoc_kle_ind
                              ,assoc_kle_associe
                              ,assoc_kle_dossier
                              ,assoc_notes
                              ,assoc_sources
                              ,assoc_libelle
                              ,assoc_evenement
                              ,assoc_table)
                      select gen_id(gen_assoc_clef,1)
                            ,e.decujus
                            ,a.decujus
                            ,:dossierc
                            ,t.assoc_notes
                            ,t.assoc_sources
                            ,t.assoc_libelle
                            ,e.decujus
                            ,'U'
                      from  t_associations t
                      inner join tq_consang a on a.id=1 and a.indi=t.assoc_kle_associe
                      inner join tq_consang e on e.id=5 and e.indi=t.assoc_evenement
                      where t.assoc_table='U';
  for select a.id  --mise à jour Sources_record familiaux
            ,n.id
            ,a.source_page
            ,a.even
            ,a.even_role
            ,a.data_even
            ,a.data_even_period
            ,a.data_even_plac
            ,a.data_agnc
            ,a.quay
            ,a.auth
            ,a.titl
            ,a.abr
            ,a.publ
            ,a.texte
            ,a.user_ref
            ,a.rin
            ,a.change_note
  from sources_record a
  inner join tq_consang t on t.id=5 and t.indi=a.data_id
  inner join sources_record n on n.data_id=t.decujus and n.type_table='F'
  where a.kle_dossier=:dossiers and a.type_table='F'
  into :old_id
      ,:new_id
      ,:source_page
      ,:even
      ,:even_role
      ,:data_even
      ,:data_even_period
      ,:data_even_plac
      ,:data_agnc
      ,:quay
      ,:auth
      ,:titl
      ,:abr
      ,:publ
      ,:texte
      ,:user_ref
      ,:rin
      ,:change_note
  do
  begin
    insert into tq_consang (id,indi,decujus) --correspondances Sources_record familiaux
           values(6,:old_id,:new_id);
    update sources_record set source_page=:source_page
                             ,even=:even
                             ,even_role=:even_role
                             ,data_even=:data_even
                             ,data_even_period=:data_even_period
                             ,data_even_plac=:data_even_plac
                             ,data_agnc=:data_agnc
                             ,quay=:quay
                             ,auth=:auth
                             ,titl=:titl
                             ,abr=:abr
                             ,publ=:publ
                             ,texte=:texte
                             ,user_ref=:user_ref
                             ,rin=:rin
                             ,change_note=:change_note
    where id=:new_id;
  end
  insert into tq_consang (id,indi,decujus) --correspondances Sources_record individuels
         select 6
               ,s.id
               ,gen_id(sources_record_id_gen,1)
         from sources_record s
         inner join tq_consang t on t.indi=s.data_id and t.id=3
         where s.type_table='I';
  insert into sources_record ( id
                              ,source_page
                              ,even
                              ,even_role
                              ,data_id
                              ,data_even
                              ,data_even_period
                              ,data_even_plac
                              ,data_agnc
                              ,quay
                              ,auth
                              ,titl
                              ,abr
                              ,publ
                              ,texte
                              ,user_ref
                              ,rin
                              ,change_date
                              ,change_note
                              ,kle_dossier
                              ,type_table)
                       select t.decujus
                             ,s.source_page
                             ,s.even
                             ,s.even_role
                             ,(select decujus from tq_consang where id=3 and indi=s.data_id)
                             ,s.data_even
                             ,s.data_even_period
                             ,s.data_even_plac
                             ,s.data_agnc
                             ,s.quay
                             ,s.auth
                             ,s.titl
                             ,s.abr
                             ,s.publ
                             ,s.texte
                             ,s.user_ref
                             ,s.rin
                             ,'now'
                             ,s.change_note
                             ,:dossierc
                             ,'I'
                        from tq_consang t
                        inner join sources_record s on s.id=t.indi and s.type_table='I'
                        where t.id=6;
  insert into media_pointeurs (mp_clef --1-MEDIA_POINTEURS sur individus
                              ,mp_media
                              ,mp_cle_individu
                              ,mp_pointe_sur
                              ,mp_table
                              ,mp_identite
                              ,mp_kle_dossier
                              ,mp_type_image
                              ,mp_position)
                      select gen_id(biblio_pointeurs_id_gen,1)
                            ,m.decujus
                            ,i.decujus
                            ,i.decujus
                            ,'I'
                            ,p.mp_identite
                            ,:dossierc
                            ,'I'
                            ,p.mp_position
                      from media_pointeurs p
                      inner join tq_consang i on i.id=1 and i.indi=p.mp_cle_individu
                      inner join tq_consang m on m.id=2 and m.indi=p.mp_media
                      where p.mp_type_image='I';
  insert into media_pointeurs (mp_clef --2-MEDIA_POINTEURS sur actes d'événements individuels
                              ,mp_media
                              ,mp_cle_individu
                              ,mp_pointe_sur
                              ,mp_table
                              ,mp_identite
                              ,mp_kle_dossier
                              ,mp_type_image
                              ,mp_position)
                      select gen_id(biblio_pointeurs_id_gen,1)
                            ,m.decujus
                            ,i.decujus
                            ,e.decujus
                            ,'I'
                            ,p.mp_identite
                            ,:dossierc
                            ,'A'
                            ,p.mp_position
                      from media_pointeurs p
                      inner join tq_consang i on i.id=1 and i.indi=p.mp_cle_individu
                      inner join tq_consang m on m.id=2 and m.indi=p.mp_media
                      inner join tq_consang e on e.id=3 and e.indi=p.mp_pointe_sur
                      where p.mp_type_image='A' and p.mp_table='I';
  insert into media_pointeurs (mp_clef --3-MEDIA_POINTEURS sur actes d'événements familiaux
                              ,mp_media
                              ,mp_cle_individu
                              ,mp_pointe_sur
                              ,mp_table
                              ,mp_identite
                              ,mp_kle_dossier
                              ,mp_type_image
                              ,mp_position)
                      select gen_id(biblio_pointeurs_id_gen,1)
                            ,m.decujus
                            ,i.decujus
                            ,e.decujus
                            ,'F'
                            ,p.mp_identite
                            ,:dossierc
                            ,'A'
                            ,p.mp_position
                      from media_pointeurs p
                      inner join tq_consang i on i.id=1 and i.indi=p.mp_cle_individu
                      inner join tq_consang m on m.id=2 and m.indi=p.mp_media
                      inner join tq_consang e on e.id=5 and e.indi=p.mp_pointe_sur
                      where p.mp_type_image='A' and p.mp_table='F';
  insert into media_pointeurs (mp_clef --4-MEDIA_POINTEURS sur sources d'événements
                              ,mp_media
                              ,mp_cle_individu
                              ,mp_pointe_sur
                              ,mp_table
                              ,mp_identite
                              ,mp_kle_dossier
                              ,mp_type_image
                              ,mp_position)
                      select gen_id(biblio_pointeurs_id_gen,1)
                            ,m.decujus
                            ,i.decujus
                            ,s.decujus
                            ,'F'
                            ,p.mp_identite
                            ,:dossierc
                            ,'F'
                            ,p.mp_position
                      from media_pointeurs p
                      inner join tq_consang i on i.id=1 and i.indi=p.mp_cle_individu
                      inner join tq_consang m on m.id=2 and m.indi=p.mp_media
                      inner join tq_consang s on s.id=6 and s.indi=p.mp_pointe_sur
                      where p.mp_type_image='F' and p.mp_table='F';
  insert into nom_attachement ( id_indi
                               ,nom
                               ,nom_indi
                               ,kle_dossier)
                        select t.decujus
                              ,n.nom
                              ,n.nom_indi
                              ,:dossierc
                         from nom_attachement n
                         inner join tq_consang t on t.id=1 and t.indi=n.id_indi;
  delete from tq_consang; --nettoyage de la table temporaire
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André le 03/06/2007
dernière modification le 07/11/2012
Copie un dossier DOSSIERS (dossier source) dans un autre dossier I_DOSSIERC
(dossier cible).
Les 2 dossiers doivent utiliser la même langue.
Si I_DOSSIERC n''existe pas, un nouveau dossier est créé.
Le code du dossier cible est retourné dans DOSSIERC.'
  where RDB$PROCEDURE_NAME = 'PROC_COPIE_DOSSIER';

SET TERM ^ ;
ALTER PROCEDURE PROC_DATES_INCOHERENTES (
    I_DOSSIER Integer DEFAULT 1,
    MIN_MAR_HOM Integer DEFAULT 12,
    MIN_MAR_FEM Integer DEFAULT 10,
    MAX_MAR_HOM Integer DEFAULT 85,
    MAX_MAR_FEM Integer DEFAULT 85,
    MIN_ENF_HOM Integer DEFAULT 14,
    MIN_ENF_FEM Integer DEFAULT 16,
    MAX_ENF_HOM Integer DEFAULT 65,
    MAX_ENF_FEM Integer DEFAULT 55,
    MAX_VIE_HOM Integer DEFAULT 95,
    MAX_VIE_FEM Integer DEFAULT 97,
    MAX_ECART_EPOUX Integer DEFAULT 40,
    MIN_ENTRE_ENF Integer DEFAULT 300,
    MAX_ENTRE_JUMEAUX Integer DEFAULT 2,
    MODE Integer DEFAULT 1 )
RETURNS (
    CLEF_IND Integer,
    LIBELLE Varchar(121),
    SEXE Integer,
    AGE Decimal(15,1),
    TITRE Smallint )
AS
declare variable date_nais float;
declare variable date_nais_tard float;
declare variable date_dc float;
declare variable date_dc_tot float;
declare variable date_eve float;
declare variable date_evf float;
declare variable epouse varchar(121);
declare variable agetempo float;
declare variable clef integer;
declare variable nbr integer;
declare variable langue varchar(3);
declare variable valmax integer = 3000000;
declare variable valmin integer = -2147483647;
declare variable annaissance integer;
begin
  select ds_langue
  from dossier
  where cle_dossier=:i_dossier
  into langue;
  rdb$set_context('USER_SESSION','LANGUE',langue);

  if (mode=0 or mode=1) then
  begin
  valmax=3000000;
  valmin=-2147483647;
  libelle='Individus(s) dont la date de décès est antérieure à la date de naissance:';
  titre=1;
  nbr=0;
  suspend;
  titre=null;
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' '||trim(iif(i.sexe=2,'née','né'))||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
      from evenements_ind ni
      inner join individu i on i.cle_fiche=ni.ev_ind_kle_fiche
      left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_fiche
                                  and nd.ev_ind_type='DEAT'
                                  and nd.ev_ind_datecode is not null
      left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_fiche
                                  and nb.ev_ind_type='BURI'
                                  and nb.ev_ind_datecode is not null
      left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_fiche
                                  and nc.ev_ind_type='CREM'
                                  and nc.ev_ind_datecode is not null
      where ni.ev_ind_kle_dossier=:i_dossier
        and ni.ev_ind_type='BIRT'
        and ni.ev_ind_datecode is not null
        and minvalue(coalesce(nd.ev_ind_datecode_tard,:valmax),coalesce(nb.ev_ind_datecode_tard,:valmax)
            ,coalesce(nc.ev_ind_datecode_tard,:valmax))<ni.ev_ind_datecode_tot
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:sexe
  do
  begin
    nbr=1;
    suspend;
  end
  age=null;
  clef_ind=null;
  sexe=null;
  if (nbr=0) then
  begin
    libelle='(néant)';
    suspend;
  end
  libelle=null;
  suspend;

  if (max_vie_hom>0) then
  begin
    libelle='Homme(s) ayant dépassé l''âge de '|| max_vie_hom ||' ans: (âge en années)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    sexe=1;
    for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né en '||i.annee_naissance,'')
              ,i.cle_fiche
              ,ni.ev_ind_datecode_tard
              ,maxvalue(coalesce(nd.ev_ind_datecode_tot,:valmin),coalesce(nb.ev_ind_datecode_tot,:valmin)
                  ,coalesce(nc.ev_ind_datecode_tot,:valmin))
        from evenements_ind ni
        inner join individu i on i.cle_fiche=ni.ev_ind_kle_fiche
                              and i.sexe=:sexe
        left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_fiche
                                    and nd.ev_ind_type='DEAT'
                                    and nd.ev_ind_datecode is not null
        left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_fiche
                                    and nb.ev_ind_type='BURI'
                                    and nb.ev_ind_datecode is not null
        left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_fiche
                                    and nc.ev_ind_type='CREM'
                                    and nc.ev_ind_datecode is not null
        where ni.ev_ind_kle_dossier=:i_dossier
          and ni.ev_ind_type='BIRT'
          and ni.ev_ind_datecode is not null
          order by 1,i.annee_naissance,i.cle_fiche
          into :libelle
              ,:clef_ind
              ,:date_nais
              ,:date_eve
    do
    begin
      if (date_eve>valmin and (date_eve-date_nais)>max_vie_hom*365.25) then
      begin
        age=(date_eve-date_nais)/365.25;
        nbr=1;
        suspend;
      end
    end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (max_vie_fem>0) then
  begin
    libelle='Femme(s) ayant dépassé l''âge de '|| max_vie_fem ||' ans: (âge en années)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    sexe=2;
    for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' née en '||i.annee_naissance,'')
              ,i.cle_fiche
              ,ni.ev_ind_datecode_tard
              ,maxvalue(coalesce(nd.ev_ind_datecode_tot,:valmin),coalesce(nb.ev_ind_datecode_tot,:valmin)
                  ,coalesce(nc.ev_ind_datecode_tot,:valmin))
        from evenements_ind ni
        inner join individu i on i.cle_fiche=ni.ev_ind_kle_fiche
                              and i.sexe=:sexe
        left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_fiche
                                    and nd.ev_ind_type='DEAT'
                                    and nd.ev_ind_datecode is not null
        left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_fiche
                                    and nb.ev_ind_type='BURI'
                                    and nb.ev_ind_datecode is not null
        left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_fiche
                                    and nc.ev_ind_type='CREM'
                                    and nc.ev_ind_datecode is not null
        where ni.ev_ind_kle_dossier=:i_dossier
          and ni.ev_ind_type='BIRT'
          and ni.ev_ind_datecode is not null
          order by 1,i.annee_naissance,i.cle_fiche
          into :libelle
              ,:clef_ind
              ,:date_nais
              ,:date_eve
    do
    begin
      if (date_eve>valmin and (date_eve-date_nais)>max_vie_fem*365.25) then
      begin
        age=(date_eve-date_nais)/365.25;
        nbr=1;
        suspend;
      end
    end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (min_mar_hom>0) then
  begin
    libelle='Homme(s) marié(s) avant l''âge de '|| min_mar_hom ||' ans: (âge en années)';
    titre=1;
    suspend;
    nbr=0;
    titre=null;
    sexe=1;
    for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,ni.ev_ind_datecode_tot
            ,m.ev_fam_datecode_tard
          from evenements_fam m
          inner join t_union u on u.union_clef=m.ev_fam_kle_famille
          inner join individu i on i.cle_fiche=u.union_mari
          inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                      and ni.ev_ind_type='BIRT'
                                      and ni.ev_ind_datecode is not null
        where m.ev_fam_kle_dossier=:i_dossier
          and m.ev_fam_type='MARR'
          and m.ev_fam_datecode is not null
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_eve
    do
      if (date_eve<(date_nais+min_mar_hom*365.25)) then
      begin
        age=(date_eve-date_nais)/365.25;
        nbr=1;
        suspend;
      end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (min_mar_fem>0) then
  begin
    libelle='Femme(s) mariée(s) avant l''âge de '|| min_mar_fem ||' ans: (âge en années)';
    titre=1;
    suspend;
    nbr=0;
    titre=null;
    sexe=2;
    for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' née en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,ni.ev_ind_datecode_tot
            ,m.ev_fam_datecode_tard
          from evenements_fam m
          inner join t_union u on u.union_clef=m.ev_fam_kle_famille
          inner join individu i on i.cle_fiche=u.union_femme
          inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                      and ni.ev_ind_type='BIRT'
                                      and ni.ev_ind_datecode is not null
        where m.ev_fam_kle_dossier=:i_dossier
          and m.ev_fam_type='MARR'
          and m.ev_fam_datecode is not null
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_eve
    do
      if (date_eve<(date_nais+min_mar_fem*365.25)) then
      begin
        age=(date_eve-date_nais)/365.25;
        nbr=1;
        suspend;
      end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (max_mar_hom>0) then
  begin
    libelle='Homme(s) marié(s) après l''âge de '|| max_mar_hom ||' ans: (âge en années)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    sexe=1;
    for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,ni.ev_ind_datecode_tard
            ,m.ev_fam_datecode_tot
          from evenements_fam m
          inner join t_union u on u.union_clef=m.ev_fam_kle_famille
          inner join individu i on i.cle_fiche=u.union_mari
          inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                      and ni.ev_ind_type='BIRT'
                                      and ni.ev_ind_datecode is not null
        where m.ev_fam_kle_dossier=:i_dossier
          and m.ev_fam_type='MARR'
          and m.ev_fam_datecode is not null
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_eve
    do
      if (date_eve>(date_nais+max_mar_hom*365.25)) then
      begin
        age=(date_eve-date_nais)/365.25;
        nbr=1;
        suspend;
      end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (max_mar_fem>0) then
  begin
    libelle='Femme(s) mariée(s) après l''âge de '|| max_mar_fem ||' ans: (âge en années)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    sexe=2;
    for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' née en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,ni.ev_ind_datecode_tard
            ,m.ev_fam_datecode_tot
          from evenements_fam m
          inner join t_union u on u.union_clef=m.ev_fam_kle_famille
          inner join individu i on i.cle_fiche=u.union_femme
          inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                      and ni.ev_ind_type='BIRT'
                                      and ni.ev_ind_datecode is not null
        where m.ev_fam_kle_dossier=:i_dossier
          and m.ev_fam_type='MARR'
          and m.ev_fam_datecode is not null
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_eve
    do
      if (date_eve>(date_nais+max_mar_fem*365.25)) then
      begin
        age=(date_eve-date_nais)/365.25;
        nbr=1;
        suspend;
      end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (min_enf_hom>0) then
  begin
    libelle='Homme(s) père(s) avant l''âge de '|| min_enf_hom ||' ans: (âge en années)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    sexe=1;
    for select distinct i.nom||coalesce(', '||i.prenom,'')||coalesce(' né en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,ni.ev_ind_datecode_tot
            ,ne.ev_ind_datecode_tard
        from evenements_ind ni
        inner join individu i on i.cle_fiche=ni.ev_ind_kle_fiche
        inner join individu e on e.cle_pere=i.cle_fiche
        inner join evenements_ind ne on ne.ev_ind_kle_fiche=e.cle_fiche
                                    and ne.ev_ind_type='BIRT'
                                    and ne.ev_ind_datecode is not null
        where ni.ev_ind_kle_dossier=:i_dossier
          and ni.ev_ind_type='BIRT'
          and ni.ev_ind_datecode is not null
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_eve
    do
    begin
      if (date_eve<(date_nais+min_enf_hom*365.25)) then
      begin
        age=(date_eve-date_nais)/365.25;
        nbr=1;
        suspend;
      end
    end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (min_enf_fem>0) then
  begin
    libelle='Femme(s) mère(s) avant l''âge de '|| min_enf_fem ||' ans: (âge en années)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    sexe=2;
    for select distinct i.nom||coalesce(', '||i.prenom,'')||coalesce(' née en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,ni.ev_ind_datecode_tot
            ,ne.ev_ind_datecode_tard
        from evenements_ind ni
        inner join individu i on i.cle_fiche=ni.ev_ind_kle_fiche
        inner join individu e on e.cle_mere=i.cle_fiche
        inner join evenements_ind ne on ne.ev_ind_kle_fiche=e.cle_fiche
                                    and ne.ev_ind_type='BIRT'
                                    and ne.ev_ind_datecode is not null
        where ni.ev_ind_kle_dossier=:i_dossier
          and ni.ev_ind_type='BIRT'
          and ni.ev_ind_datecode is not null
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_eve
    do
    begin
      if (date_eve<(date_nais+min_enf_fem*365.25)) then
      begin
        age=(date_eve-date_nais)/365.25;
        nbr=1;
        suspend;
      end
    end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (max_enf_hom>0) then
  begin
    libelle='Homme(s) père(s) après l''âge de '|| max_enf_hom ||' ans: (âge en années)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    sexe=1;
    for select distinct i.nom||coalesce(', '||i.prenom,'')||coalesce(' né en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,ni.ev_ind_datecode_tard
            ,ne.ev_ind_datecode_tot
        from evenements_ind ni
        inner join individu i on i.cle_fiche=ni.ev_ind_kle_fiche
        inner join individu e on e.cle_pere=i.cle_fiche
        inner join evenements_ind ne on ne.ev_ind_kle_fiche=e.cle_fiche
                                    and ne.ev_ind_type='BIRT'
                                    and ne.ev_ind_datecode is not null
        where ni.ev_ind_kle_dossier=:i_dossier
          and ni.ev_ind_type='BIRT'
          and ni.ev_ind_datecode is not null
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_eve
    do
    begin
      if (date_eve>(date_nais+max_enf_hom*365.25)) then
      begin
        age=(date_eve-date_nais)/365.25;
        nbr=1;
        suspend;
      end
    end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (max_enf_fem>0) then
  begin
    libelle='Femme(s) mère(s) après l''âge de '|| max_enf_fem ||' ans: (âge en années)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    sexe=2;
    for select distinct i.nom||coalesce(', '||i.prenom,'')||coalesce(' née en '||i.annee_naissance,'')
              ,i.cle_fiche
            ,ni.ev_ind_datecode_tard
            ,ne.ev_ind_datecode_tot
        from evenements_ind ni
        inner join individu i on i.cle_fiche=ni.ev_ind_kle_fiche
        inner join individu e on e.cle_mere=i.cle_fiche
        inner join evenements_ind ne on ne.ev_ind_kle_fiche=e.cle_fiche
                                    and ne.ev_ind_type='BIRT'
                                    and ne.ev_ind_datecode is not null
        where ni.ev_ind_kle_dossier=:i_dossier
          and ni.ev_ind_type='BIRT'
          and ni.ev_ind_datecode is not null
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_eve
    do
    begin
      if (date_eve>(date_nais+max_enf_fem*365.25)) then
      begin
        age=(date_eve-date_nais)/365.25;
        nbr=1;
        suspend;
      end
    end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (max_ecart_epoux>0) then
  begin
    libelle='Couple(s) dont l''écart d''âge est supérieur à '|| max_ecart_epoux ||' ans: (écart en années)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    for select distinct m.nom||coalesce(', '||m.prenom,'')||coalesce(' né en '||m.annee_naissance,'')
              ,'marié avec '||f.nom||', '||f.prenom||coalesce(' née en '||f.annee_naissance,'')
              ,m.cle_fiche
              ,f.cle_fiche
              ,minvalue(iif(nm.ev_ind_datecode_tot-nf.ev_ind_datecode_tard>0,nm.ev_ind_datecode_tot-nf.ev_ind_datecode_tard,:valmax)
                        ,iif(nf.ev_ind_datecode_tot-nm.ev_ind_datecode_tard>0,nf.ev_ind_datecode_tot-nm.ev_ind_datecode_tard,:valmax))
        from evenements_fam e
             inner join t_union u on u.union_clef=e.ev_fam_kle_famille
             inner join individu m on m.cle_fiche=u.union_mari
             inner join evenements_ind nm on nm.ev_ind_kle_fiche=m.cle_fiche
                                         and nm.ev_ind_type='BIRT'
                                         and nm.ev_ind_datecode is not null
             inner join individu f on f.cle_fiche =u.union_femme
             inner join evenements_ind nf on nf.ev_ind_kle_fiche=f.cle_fiche
                                         and nf.ev_ind_type='BIRT'
                                         and nf.ev_ind_datecode is not null
        where e.ev_fam_kle_dossier=:i_dossier
          and e.ev_fam_type='MARR'
        order by 1,m.annee_naissance,m.cle_fiche
        into :libelle
            ,:epouse
            ,:clef_ind
            ,:clef
            ,:agetempo --en jours
    do
    begin
      if (agetempo<valmax and agetempo/365.25>max_ecart_epoux) then
      begin
        age=null;
        sexe=1;
        suspend;
        libelle=epouse;
        clef_ind=clef;
        age=agetempo/365.25;
        sexe=2;
        nbr=1;
        suspend;
      end
    end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  if (min_entre_enf>0) then
  begin
    libelle='Femme(s) ayant eu deux enfants en moins de '|| min_entre_enf ||' jours: (écart en jours)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    sexe=2;
    for select distinct m.nom||coalesce(', '||m.prenom,'')||coalesce(' née en '||m.annee_naissance,'')
              ,m.cle_fiche
              ,maxvalue(iif(n1.ev_ind_datecode_tard-n2.ev_ind_datecode_tot>0,n1.ev_ind_datecode_tard-n2.ev_ind_datecode_tot,:valmin)
                        ,iif(n2.ev_ind_datecode_tard-n1.ev_ind_datecode_tot>0,n2.ev_ind_datecode_tard-n1.ev_ind_datecode_tot,:valmin))
        from evenements_ind n1
          inner join individu e1 on e1.cle_fiche=n1.ev_ind_kle_fiche
          inner join individu m on m.cle_fiche=e1.cle_mere
          inner join individu e2 on e2.cle_mere=m.cle_fiche and e1.cle_fiche<>e2.cle_fiche
          inner join evenements_ind n2 on n2.ev_ind_kle_fiche=e2.cle_fiche
                                      and n2.ev_ind_type='BIRT'
                                      and n2.ev_ind_datecode is not null
                                      and n2.ev_ind_date_writen<>n1.ev_ind_date_writen
        where n1.ev_ind_kle_dossier=:i_dossier
          and n1.ev_ind_type='BIRT'
          and n1.ev_ind_datecode is not null
        order by 1,m.annee_naissance,m.cle_fiche
        into :libelle
            ,:clef_ind
            ,:age
    do
    begin
      if (age>valmin and age<min_entre_enf and age>max_entre_jumeaux) then
      begin
        nbr=1;
        suspend;
      end
    end
    age=null;
    clef_ind=null;
    sexe=null;
    if (nbr=0) then
    begin
      libelle='(néant)';
      suspend;
    end
    libelle=null;
    suspend;
  end

  libelle='Individu(s) né(s) plus de 270 jours après le décés de leur père: (écart en jours)';
  titre=1;
  nbr=0;
  suspend;
  titre=null;
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||trim(case when i.sexe=2 then 'e' else '' end)||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
            ,ni.ev_ind_datecode_tot
            ,np.ev_ind_datecode_tard+:max_vie_hom*365.25
            ,minvalue(coalesce(nd.ev_ind_datecode_tard,:valmax),coalesce(nb.ev_ind_datecode_tard,:valmax)
                  ,coalesce(nc.ev_ind_datecode_tard,:valmax))
      from evenements_ind ni
         inner join individu i on i.cle_fiche=ni.ev_ind_kle_fiche
                                     and ni.ev_ind_datecode is not null
         left join evenements_ind np on np.ev_ind_kle_fiche=i.cle_pere
                                     and np.ev_ind_type='BIRT'
                                     and np.ev_ind_datecode is not null
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_pere
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_datecode is not null
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_pere
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_datecode is not null
         left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_pere
                                     and nc.ev_ind_type='CREM'
                                     and nc.ev_ind_datecode is not null
      where ni.ev_ind_kle_dossier=:i_dossier
        and ni.ev_ind_type='BIRT'
        and ni.ev_ind_datecode is not null
      order by 1,i.annee_naissance,i.cle_fiche
      into :libelle
          ,:clef_ind
          ,:sexe
          ,:date_eve
          ,:date_nais
          ,:date_dc
  do
  begin
    if (max_vie_hom>0 or date_dc<>valmax) then
    begin
      if (date_dc=valmax) then
        date_dc=date_nais;
      if (date_eve>date_dc+270) then
      begin
        age=date_eve-date_dc;
        nbr=1;
        suspend;
      end
    end
  end
  age=null;
  clef_ind=null;
  sexe=null;
  if (nbr=0) then
  begin
    libelle='(néant)';
    suspend;
  end
  libelle=null;
  suspend;

  libelle='Individu(s) né(s) après le décés de leur mère:';
  titre=1;
  nbr=0;
  suspend;
  titre=null;
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||trim(case when i.sexe=2 then 'e' else '' end)||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
            ,ni.ev_ind_datecode_tot
            ,np.ev_ind_datecode_tard+:max_vie_fem*365.25
            ,minvalue(coalesce(nd.ev_ind_datecode_tard,:valmax),coalesce(nb.ev_ind_datecode_tard,:valmax)
                  ,coalesce(nc.ev_ind_datecode_tard,:valmax))
      from evenements_ind ni
         inner join individu i on i.cle_fiche=ni.ev_ind_kle_fiche
                                     and ni.ev_ind_datecode is not null
         left join evenements_ind np on np.ev_ind_kle_fiche=i.cle_mere
                                     and np.ev_ind_type='BIRT'
                                     and np.ev_ind_datecode is not null
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_mere
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_datecode is not null
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_mere
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_datecode is not null
         left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_mere
                                     and nc.ev_ind_type='CREM'
                                     and nc.ev_ind_datecode is not null
      where ni.ev_ind_kle_dossier=:i_dossier
        and ni.ev_ind_type='BIRT'
        and ni.ev_ind_datecode is not null
      order by 1,i.annee_naissance,i.cle_fiche
      into :libelle
          ,:clef_ind
          ,:sexe
          ,:date_eve
          ,:date_nais
          ,:date_dc
  do
  begin
    if (max_vie_fem>0 or date_dc<>valmax) then
    begin
      if (date_dc=valmax) then
        date_dc=date_nais;
      if (date_eve>date_dc) then
      begin
        nbr=1;
        suspend;
      end
    end
  end
  age=null;
  clef_ind=null;
  sexe=null;
  if (nbr=0) then
  begin
    libelle='(néant)';
    suspend;
  end
  libelle=null;
  suspend;

  libelle='Individu(s) ayant un événement avant la naissance:';
  titre=1;
  nbr=0;
  suspend;
  titre=null;
  for select distinct i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||trim(case when i.sexe=2 then 'e' else '' end)||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
      from evenements_ind ni
         inner join individu i on i.cle_fiche=ni.ev_ind_kle_fiche
         left join evenements_ind ne on ne.ev_ind_kle_fiche=i.cle_fiche
                                     and ne.ev_ind_clef<>ni.ev_ind_clef
                                     and ne.ev_ind_datecode is not null
                                     and ne.ev_ind_datecode_tard<:valmax
         left join t_union u on (i.sexe=1 and u.union_mari=i.cle_fiche)
                             or (i.sexe=2 and u.union_femme=i.cle_fiche)
         left join evenements_fam f on f.ev_fam_kle_famille=u.union_clef
                                   and f.ev_fam_datecode is not null
                                   and f.ev_fam_datecode_tard<:valmax
      where ni.ev_ind_kle_dossier=:i_dossier
        and ni.ev_ind_type='BIRT'
        and ni.ev_ind_datecode is not null
        and ni.ev_ind_datecode_tot>:valmin
        and (ni.ev_ind_datecode_tot>ne.ev_ind_datecode_tard
         or ni.ev_ind_datecode_tot>f.ev_fam_datecode_tard)
      order by 1,i.annee_naissance,i.cle_fiche
      into :libelle
          ,:clef_ind
          ,:sexe
  do
  begin
    nbr=1;
    suspend;
  end
  age=null;
  clef_ind=null;
  sexe=null;
  if (nbr=0) then
  begin
    libelle='(néant)';
    suspend;
  end
  libelle=null;
  suspend;

  libelle='Individu(s) ayant un événement individuel après le décès, l''inhumation, la crémation ou l''espérance de vie:';
  titre=1;
  suspend;
  nbr=0;
  titre=null;
  sexe=0;
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||trim(case when i.sexe=2 then 'e' else '' end)||' en '||i.annee_naissance,'')
            ,i.annee_naissance
            ,i.cle_fiche
            ,i.sexe
            ,ni.ev_ind_datecode_tard+case when i.sexe=1 then :max_vie_hom else :max_vie_fem end*365.25
            ,minvalue(coalesce(nd.ev_ind_datecode_tard,:valmax),coalesce(nb.ev_ind_datecode_tard,:valmax)
              ,coalesce(nc.ev_ind_datecode_tard,:valmax))
            ,max(ne.ev_ind_datecode_tot)
      from individu i
         left join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                     and ni.ev_ind_type='BIRT'
                                     and ni.ev_ind_datecode is not null
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_fiche
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_datecode is not null
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_fiche
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_datecode is not null
         left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_fiche
                                     and nc.ev_ind_type='CREM'
                                     and nc.ev_ind_datecode is not null
         inner join evenements_ind ne on ne.ev_ind_kle_fiche=i.cle_fiche
                                     and ne.ev_ind_type not in('BIRT','DEAT','BURI','CREM')
                                     and ne.ev_ind_datecode is not null
                                     and ne.ev_ind_datecode_tot>:valmin
      where i.kle_dossier=:i_dossier
      group by 1,2,3,4,5,6
      order by 1,2,3
      into :libelle
          ,:agetempo
          ,:clef_ind
          ,:sexe
          ,:date_nais
          ,:date_dc
          ,:date_eve
  do
  begin
    if (date_eve<>valmin
       and not ((date_nais is null or max_vie_hom=0 or max_vie_fem=0)
                and date_dc=valmax)) then
    begin
      if (date_dc=valmax) then
        date_dc=date_nais;
      if (date_dc<date_eve) then
      begin
        nbr=1;
        suspend;
      end
    end
  end
  age=null;
  clef_ind=null;
  sexe=null;
  if (nbr=0) then
  begin
    libelle='(néant)';
    suspend;
  end
  libelle=null;
  suspend;

  libelle='Individu(s) ayant un événement familial après le décès, l''inhumation, la crémation ou l''espérance de vie:';
  titre=1;
  suspend;
  nbr=0;
  titre=null;
  sexe=0;
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||trim(case when i.sexe=2 then 'e' else '' end)||' en '||i.annee_naissance,'')
            ,i.annee_naissance
            ,i.cle_fiche
            ,i.sexe
            ,ni.ev_ind_datecode_tard+case when i.sexe=1 then :max_vie_hom else :max_vie_fem end*365.25
            ,minvalue(coalesce(nd.ev_ind_datecode_tard,:valmax),coalesce(nb.ev_ind_datecode_tard,:valmax)
              ,coalesce(nc.ev_ind_datecode_tard,:valmax))
            ,max(f.ev_fam_datecode_tot)
      from individu i
         left join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                     and ni.ev_ind_type='BIRT'
                                     and ni.ev_ind_datecode is not null
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_fiche
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_datecode is not null
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_fiche
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_datecode is not null
         left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_fiche
                                     and nc.ev_ind_type='CREM'
                                     and nc.ev_ind_datecode is not null
         inner join t_union u on (i.sexe=1 and u.union_mari=i.cle_fiche)
                             or (i.sexe=2 and u.union_femme=i.cle_fiche)
         inner join evenements_fam f on f.ev_fam_kle_famille=u.union_clef
                                   and f.ev_fam_datecode is not null
                                   and f.ev_fam_datecode_tot>:valmin
      where i.kle_dossier=:i_dossier
      group by 1,2,3,4,5,6
      order by 1,2,3
      into :libelle
          ,:agetempo
          ,:clef_ind
          ,:sexe
          ,:date_nais
          ,:date_dc
          ,:date_eve
  do
  begin
    if (date_eve<>valmin
       and not ((date_nais is null or max_vie_hom=0 or max_vie_fem=0)
                and date_dc=valmax)) then
    begin
      if (date_dc=valmax) then
        date_dc=date_nais;
      if (date_dc<date_eve) then
      begin
        nbr=1;
        suspend;
      end
    end
  end
  age=null;
  clef_ind=null;
  sexe=null;
  if (nbr=0) then
  begin
    libelle='(néant)';
    suspend;
  end
  libelle=null;
  suspend;

  libelle='Individu(s) déclaré(s) présent(s) à un événement individuel hors de leur période de vie:';
  titre=1;
  suspend;
  nbr=0;
  titre=null;
  sexe=0;
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||trim(case when i.sexe=2 then 'e' else '' end)||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.annee_naissance
            ,i.sexe
            ,coalesce(ni.ev_ind_datecode_tot,:valmin)--date de naissance au plus tôt
            ,coalesce(ni.ev_ind_datecode_tard,:valmax)--date de naissance au plus tard
            ,minvalue(coalesce(nd.ev_ind_datecode_tard,:valmax),coalesce(nb.ev_ind_datecode_tard,:valmax)
              ,coalesce(nc.ev_ind_datecode_tard,:valmax))--date de décès au plus tard
            ,maxvalue(coalesce(nd.ev_ind_datecode_tot,:valmin),coalesce(nb.ev_ind_datecode_tot,:valmin)
              ,coalesce(nc.ev_ind_datecode_tot,:valmin))--date de décès au plus tot
            ,max(ne.ev_ind_datecode_tot)
            ,min(ne.ev_ind_datecode_tard)
      from t_associations a
         inner join individu i on i.cle_fiche=a.assoc_kle_associe
         left join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                     and ni.ev_ind_type='BIRT'
                                     and ni.ev_ind_datecode is not null
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_fiche
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_datecode is not null
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_fiche
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_datecode is not null
         left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_fiche
                                     and nc.ev_ind_type='CREM'
                                     and nc.ev_ind_datecode is not null
         inner join evenements_ind ne on a.assoc_table='I'
                                     and ne.ev_ind_clef=a.assoc_evenement
                                     and ne.ev_ind_datecode is not null
      where a.assoc_kle_dossier=:i_dossier
      group by 1,2,3,4,5,6,7,8
      order by 1,i.annee_naissance,i.cle_fiche
      into :libelle
          ,:clef_ind
          ,:annaissance
          ,:sexe
          ,:date_nais
          ,:date_nais_tard
          ,:date_dc
          ,:date_dc_tot
          ,:date_eve
          ,:date_evf
  do
  begin
    if (date_eve>valmin or date_evf<valmax) then
    begin
      if (date_dc=valmax) then
        if (date_nais_tard<valmax and max_vie_hom>0 and max_vie_fem>0) then
          date_dc=date_nais_tard+case when sexe=1 then max_vie_hom else max_vie_fem end*365.25;
      if (date_nais=valmin) then
        if (date_dc_tot>valmin and max_vie_hom>0 and max_vie_fem>0) then
          date_nais=date_dc_tot-case when sexe=1 then max_vie_hom else max_vie_fem end*365.25;
      if (date_dc<date_eve or date_nais>date_evf) then
      begin
        nbr=1;
        suspend;
      end
    end
  end
  age=null;
  clef_ind=null;
  sexe=null;
  if (nbr=0) then
  begin
    libelle='(néant)';
    suspend;
  end
  libelle=null;
  suspend;

  libelle='Individu(s) déclaré(s) présent(s) à un événement familial hors de leur période de vie:';
  titre=1;
  suspend;
  nbr=0;
  titre=null;
  sexe=0;
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||trim(case when i.sexe=2 then 'e' else '' end)||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.annee_naissance
            ,i.sexe
            ,coalesce(ni.ev_ind_datecode_tot,:valmin)--date de naissance au plus tôt
            ,coalesce(ni.ev_ind_datecode_tard,:valmax)--date de naissance au plus tard
            ,minvalue(coalesce(nd.ev_ind_datecode_tard,:valmax),coalesce(nb.ev_ind_datecode_tard,:valmax)
              ,coalesce(nc.ev_ind_datecode_tard,:valmax))--date de décès au plus tard
            ,maxvalue(coalesce(nd.ev_ind_datecode_tot,:valmin),coalesce(nb.ev_ind_datecode_tot,:valmin)
              ,coalesce(nc.ev_ind_datecode_tot,:valmin))--date de décès au plus tot
            ,max(f.ev_fam_datecode_tot)
            ,min(f.ev_fam_datecode_tard)
      from t_associations a
         inner join individu i on i.cle_fiche=a.assoc_kle_associe
         left join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                     and ni.ev_ind_type='BIRT'
                                     and ni.ev_ind_datecode is not null
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_fiche
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_datecode is not null
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_fiche
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_datecode is not null
         left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_fiche
                                     and nc.ev_ind_type='CREM'
                                     and nc.ev_ind_datecode is not null
         inner join evenements_fam f on a.assoc_table='U'
                                   and f.ev_fam_clef=a.assoc_evenement
                                   and f.ev_fam_datecode is not null
      where a.assoc_kle_dossier=:i_dossier
      group by 1,2,3,4,5,6,7,8
      order by 1,i.annee_naissance,i.cle_fiche
      into :libelle
          ,:clef_ind
          ,:annaissance
          ,:sexe
          ,:date_nais
          ,:date_nais_tard
          ,:date_dc
          ,:date_dc_tot
          ,:date_eve
          ,:date_evf
  do
  begin
    if (date_eve>valmin or date_evf<valmax) then
    begin
      if (date_dc=valmax) then
        if (date_nais_tard<valmax and max_vie_hom>0 and max_vie_fem>0) then
          date_dc=date_nais_tard+case when sexe=1 then max_vie_hom else max_vie_fem end*365.25;
      if (date_nais=valmin) then
        if (date_dc_tot>valmin and max_vie_hom>0 and max_vie_fem>0) then
          date_nais=date_dc_tot-case when sexe=1 then max_vie_hom else max_vie_fem end*365.25;
      if (date_dc<date_eve or date_nais>date_evf) then
      begin
        nbr=1;
        suspend;
      end
    end
  end
  age=null;
  clef_ind=null;
  sexe=null;
  if (nbr=0) then
  begin
    libelle='(néant)';
    suspend;
  end
  if (mode=0) then
  begin
    libelle=null;
    suspend;
  end
  end

  if (mode=0 or mode=2) then
  begin
  libelle='Individu(s) ayant une date d''événement individuel de forme anormale:';
  titre=1;
  suspend;
  titre=null;
  nbr=0;
  for select distinct i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||trim(case when i.sexe=2 then 'e' else '' end)||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
      from evenements_ind e
      inner join individu i on i.cle_fiche=e.ev_ind_kle_fiche
      where e.ev_ind_kle_dossier=:i_dossier
        and e.ev_ind_date_writen is not null
        and (select valide from proc_date_writen(e.ev_ind_date_writen))=0
      order by 1,i.date_naissance,i.cle_fiche
      into :libelle
          ,:clef_ind
          ,:sexe
  do
  begin
    nbr=1;
    suspend;
  end
  age=null;
  clef_ind=null;
  sexe=null;
  if (nbr=0) then
  begin
    libelle='(néant)';
    suspend;
  end
  libelle=null;
  suspend;

  libelle='Individu(s) ayant une date d''événement familial de forme anormale:';
  titre=1;
  suspend;
  titre=null;
  nbr=0;
  for select distinct i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||trim(case when i.sexe=2 then 'e' else '' end)||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
      from evenements_fam e
      inner join t_union u on u.union_clef=e.ev_fam_kle_famille
      inner join individu i on i.cle_fiche in (u.union_mari,u.union_femme)
      where e.ev_fam_kle_dossier=:i_dossier
        and e.ev_fam_date_writen is not null
        and (select valide from proc_date_writen(e.ev_fam_date_writen))=0
      order by 1,i.date_naissance,i.cle_fiche
      into :libelle
          ,:clef_ind
          ,:sexe
  do
  begin
    nbr=1;
    suspend;
  end
  age=null;
  clef_ind=null;
  sexe=null;
  if (nbr=0) then
  begin
    libelle='(néant)';
    suspend;
  end
  end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André Langlet.
Dernière modification 12/11/2012.'
  where RDB$PROCEDURE_NAME = 'PROC_DATES_INCOHERENTES';

SET TERM ^ ;
ALTER PROCEDURE PROC_DATE_CODE (
    IAN Integer,
    IMOIS Smallint,
    IJOUR Smallint,
    MODE Smallint,
    CALENDRIER Smallint )
RETURNS (
    DATE_CODE Integer,
    VALIDE Smallint )
AS
declare variable delta smallint;
declare variable m integer;
begin
  if (imois=0) then
    imois=null;
  if (ijour=0) then
    ijour=null;
  if (ian is null or ian<=-5800000 or ian>8000 or(calendrier=1 and ian=0)
    or(imois is null and ijour is not null)
    or(imois is not null and ((imois<1) or (imois>12)))
    or(ijour is not null and ((ijour<1) or (ijour>31)))) then
  begin
    suspend;
    exit;
  end
  delta=0;
  if (ijour is null) then
  begin
    if (imois is not null) then
    begin
      if (mode=1) then
      begin
        ijour=1;
      end
      else if (mode=2) then
      begin
        ijour=1;
        imois=imois+1;
        delta=-1;
      end else
      begin
        ijour=15;
      end
      if (imois>12) then
      begin
        ian=ian+1;
        imois=1;
      end
    end
    else
    begin
      if (mode=1) then
      begin
        ijour=1;
        imois=1;
      end
      else if (mode=2) then
      begin
        ijour=1;
        imois=1;
        ian=ian+1;
        delta=-1;
      end else
      begin
        ijour=1;
        imois=7;
      end
    end
  end
  if (calendrier=1 and ian<0) then
    ian=ian+1;
  date_code=ijour+delta;
  M=31;
  if (imois>1) then
  begin
    date_code=date_code+M;
    if ((calendrier=0 and mod(ian,4)=0 and (mod(ian,100)<>0 or mod(ian,400)=0))
      or(calendrier=1 and mod(ian,4)=0))then
      M=29;
    else
      M=28;
    if (imois>2) then
    begin
      date_code=date_code+M;
      M=31;
      if (imois>3) then
      begin
        date_code=date_code+M;
        M=30;
        if (imois>4) then
        begin
          date_code=date_code+M;
          M=31;
          if (imois>5) then
          begin
            date_code=date_code+M;
            M=30;
            if (imois>6) then
            begin
              date_code=date_code+M;
              M=31;
              if (imois>7) then
              begin
                date_code=date_code+M;
                M=31;
                if (imois>8) then
                begin
                  date_code=date_code+M;
                  M=30;
                  if (imois>9) then
                  begin
                    date_code=date_code+M;
                    M=31;
                    if (imois>10) then
                    begin
                      date_code=date_code+M;
                      M=30;
                      if (imois>11) then
                      begin
                        date_code=date_code+M;
                        M=31;
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if (ijour<=M) then
  begin
    valide=1;
    ian=ian+5800000-1;
    if (calendrier=1) then
      date_code=date_code-2119143596+ian*365+trunc(ian/4);
    else
      date_code=date_code-2119100094+ian*365+trunc(ian/4)-trunc(ian/100)+trunc(ian/400);
  end
  else
  begin
    valide=0;
    date_code=null;
  end
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André Langlet le 16/11/2011, modifiée le 31/10/2012.
La date code est le nombre de jours entre le 30/12/1899 et la date entrée
sous la forme Année, Mois, Jour.
Mode est un paramètre permettant de:
Mode=1 minimiser la date_code
Mode=2 maximiser la date_code
si le jour ou le mois sont absents.
Mode=0 correspond au 15 du mois si le jour est absent ou au 1 juillet de l''année
si le mois est absent.
Mode est sans effet si le jour est fourni.'
  where RDB$PROCEDURE_NAME = 'PROC_DATE_CODE';

SET TERM ^ ;
ALTER PROCEDURE PROC_DATE_WRITEN (
    DATE_WRITEN Varchar(100) )
RETURNS (
    IAN Integer,
    IMOIS Smallint,
    IJOUR Smallint,
    DDATE Date,
    DATE_CODE Integer,
    TYPE_TOKEN1 Smallint,
    DATE_CODE_TOT Integer,
    IAN_FIN Integer,
    IMOIS_FIN Smallint,
    IJOUR_FIN Smallint,
    DDATE_FIN Date,
    DATE_CODE_TARD Integer,
    TYPE_TOKEN2 Smallint,
    VALIDE Smallint,
    DATE_WRITEN_S Varchar(100),
    CALENDRIER1 Smallint,
    CALENDRIER2 Smallint )
AS
declare variable jour1 smallint;
declare variable mois1 smallint;
declare variable an1 integer;
declare variable date1 date;
declare variable date_code1 integer;
declare variable token1 varchar(30);
declare variable reste varchar(100);
declare variable jour2 smallint;
declare variable mois2 smallint;
declare variable an2 integer;
declare variable date2 date;
declare variable date_code2 integer;
declare variable token2 varchar(30);
declare variable ordre varchar(30);
declare variable forme varchar(30);
declare variable langue varchar(3);
declare variable i integer;
declare variable smois varchar(30);
declare variable sjour varchar(30);
declare variable san varchar(30);
declare variable ch varchar(30);
declare variable separateur varchar(1);
declare variable token varchar(30);
declare variable ordren varchar(30);
declare variable julien varchar(30);
begin
  date_code_tot=-2147483647;-- = -MaxInt
  date_code_tard=3000000;
  langue=rdb$get_context('USER_SESSION','LANGUE');
  if (langue is null) then
  begin
    valide=0;
    date_writen_s=date_writen;
    suspend;
    exit;
  end

  select first(1) id,trim(upper(token)) --cherche ordre jour, mois, année dans TYPE_TOKEN 23
    from ref_token_date  --ordre pour LIT
    where type_token=23 and langue=:langue order by id
    into :i,:ordre;
  if ((ordre is null) or (char_length(ordre)=0) or
    (ordre<>'DMY' and ordre<>'MDY' and ordre<>'YMD')) then --créer TYPE_TOKEN 23, fait une seule fois
  begin
    ordre='DMY';
    if (i is null) then --il n'existe pas
    begin
      select max(id)+1 from ref_token_date into :i;
      i=gen_id(gen_token_date,i-gen_id(gen_token_date,0));--recale le générateur au cas où
      insert into ref_token_date (id,type_token,langue,token)
                 values(:i,23,:langue,:ordre);
    end
    else
      update ref_token_date
      set token=:ordre
      where id=:i and type_token=23;
  end
  i=null;
  select first(1) skip (1) id,trim(upper(token)) --cherche ordre jour, mois, année dans TYPE_TOKEN 23
    from ref_token_date  --ordre pour NUM
    where type_token=23 and langue=:langue order by id
    into :i,:ordren;
  if ((ordren is null) or (char_length(ordren)=0) or
    (ordren<>'DMY' and ordren<>'MDY' and ordren<>'YMD')) then --créer TYPE_TOKEN 23, fait une seule fois
  begin --on utilise même ordre que LIT
    ordren=ordre;
    if (i is null) then --il n'existe pas
    begin
      select max(id)+1 from ref_token_date into :i;
      i=gen_id(gen_token_date,i-gen_id(gen_token_date,0));--recale le générateur au cas où
      insert into ref_token_date (id,type_token,langue,token)
                 values(:i,23,:langue,:ordren);
    end
    else
      update ref_token_date
      set token=:ordren
      where id=:i and type_token=23;
  end
  i=null;
  select first(1) type_token,trim(upper(token)) --cherche la forme LIT ou NUM dans TYPE_TOKEN 24
    from ref_token_date
    where type_token=24 and langue=:langue
    into :i,:forme;
  if (forme is null) then --créer TYPE_TOKEN 24, fait une seule fois
  begin
    forme='LIT';
    if (i is null) then
    begin
      select max(id)+1 from ref_token_date into :i;
      i=gen_id(gen_token_date,i-gen_id(gen_token_date,0));
      insert into ref_token_date (id,type_token,langue,token)
             values(:i,24,:langue,:forme);
    end
    else
      update ref_token_date
      set langue=:langue,token=:forme
      where type_token=24;
  end
  if (forme not in('LIT','NUM')) then
  begin
    date_writen_s=date_writen;
    suspend;
    exit;
  end
  i=null;
  select first(1) id,token from ref_token_date
  where type_token=25 and langue=:langue order by id into :i,:julien;
  if (i is null) then
  begin
    julien='Ju';
    select max(id)+1 from ref_token_date into :i;
    i=gen_id(gen_token_date,i-gen_id(gen_token_date,0));
    insert into ref_token_date (id,type_token,langue,token)
           values(:i,25,:langue,:julien);
  end
  calendrier1=0;
  reste=upper(trim(lower(date_writen)));
  select ijour,imois,ian,token,type_token,date_writen_s,valide,date_code,ddate,calendrier --extrait la première date
    from proc_date_writen_un(:reste,:langue)
    into :jour1,:mois1,:an1,:token1,:type_token1,:reste,:valide,:date_code1,:date1,:calendrier1;
  if (valide=0 or type_token1=18) then
  begin
    date_writen_s=date_writen;
    valide=0;
    suspend;
    exit;
  end
  if (type_token1 is null) then
  begin --pas de mot-clé
    select date_code from proc_date_code(:an1,:mois1,:jour1,1,:calendrier1)
      into :date_code_tot;
    select date_code from proc_date_code(:an1,:mois1,:jour1,2,:calendrier1)
      into :date_code_tard;
  end
  else if (type_token1=19) then
  begin --CAL
    select case when :mois1 is null then date_code-365
                when :jour1 is null then date_code-31
                else date_code
                end
      from proc_date_code(:an1,:mois1,:jour1,1,:calendrier1)
      into :date_code_tot;
    select case when :mois1 is null then date_code+365
                when :jour1 is null then date_code+31
                else date_code
                end
      from proc_date_code(:an1,:mois1,:jour1,2,:calendrier1)
      into :date_code_tard;
  end
  else if (type_token1=20) then
  begin --EST
    select case when :mois1 is null then date_code-5000
                when :jour1 is null then date_code-93
                else date_code-31
                end
      from proc_date_code(:an1,:mois1,:jour1,1,:calendrier1)
      into :date_code_tot;
    select case when :mois1 is null then date_code+5000
                when :jour1 is null then date_code+93
                else date_code+31
                end
      from proc_date_code(:an1,:mois1,:jour1,2,:calendrier1)
      into :date_code_tard;
  end
  else if (type_token1=21) then
  begin --ABT
    select case when :mois1 is null then date_code-1500
                when :jour1 is null then date_code-31
                else date_code-15
                end
      from proc_date_code(:an1,:mois1,:jour1,1,:calendrier1)
      into :date_code_tot;
    select case when :mois1 is null then date_code+1500
                when :jour1 is null then date_code+31
                else date_code+15
                end
      from proc_date_code(:an1,:mois1,:jour1,2,:calendrier1)
      into :date_code_tard;
  end
  else if (type_token1 in (14,15)) then
  begin --jusque=TO, avant=BEF
    date_code_tard=date_code1;
  end
  else  --13=depuis=FROM, 16=après=AFT, 17=entre=BET
  begin
    date_code_tot=date_code1;
  end
  if (char_length(reste)>0) then --cherche deuxième date
  begin
    if (token1 is null or type_token1 not in (13,17)) then
    begin
      valide=0;
      date_writen_s=date_writen;
      suspend;
      exit;
    end
    select ijour,imois,ian,token,type_token,date_writen_s,valide,date_code,ddate,calendrier
      from proc_date_writen_un(:reste,:langue)
      into :jour2,:mois2,:an2,:token2,:type_token2,:date_writen_s,:valide,date_code2,:date2,:calendrier2;
    if (valide=0
        or char_length(date_writen_s)>0
        or type_token2 not in (14,18)
        or (type_token1=17 and type_token2=14)
        or (type_token1=13 and type_token2=18)
        or date_code1>=date_code2) then
    begin
      valide=0;
      date_writen_s=date_writen;
      suspend;
      exit;
    end
    ijour_fin=jour2;
    imois_fin=mois2;
    ian_fin=an2;
    date_code_tard=date_code2;
    ddate_fin=date2;
  end

  ijour=jour1;
  imois=mois1;
  ian=an1;
  date_code=date_code1;
  ddate=date1;

  if (type_token1 in (13,14) and type_token2 is null) then
  begin
    if (jour1 is not null) then
      select first(1) token from ref_token_date
             where type_token=:type_token1 and sous_type='D1'
             into :token;
    if (token is null and mois1 is not null) then
      select first(1) token from ref_token_date
             where type_token=:type_token1 and sous_type='M1'
             into :token;
    if (token is null) then
      select first(1) token from ref_token_date
             where type_token=:type_token1 and sous_type='Y1'
             into :token;
    if (token is not null) then
      token1=token;
  end
  date_writen_s=coalesce(token1||' ','');
  if (jour1<10 and forme='NUM') then --ajouter 0 devant
    sjour='0'||cast(jour1 as varchar(1));
  else
    sjour=cast(jour1 as varchar(2));
  if (forme='LIT') then
    san=cast(an1 as varchar(20));
  else
  begin
    if (an1<0) then
    begin
      san='-';
      an1=-an1;
    end
    else
      san='';
    if (an1<10) then
      san=san||'000'||cast(an1 as varchar(20));
    else if (an1<100) then
      san=san||'00'||cast(an1 as varchar(20));
    else if (an1<1000) then
      san=san||'0'||cast(an1 as varchar(20));
    else
      san=san||cast(an1 as varchar(20));
  end
  if (forme='LIT') then
  begin
    select first(1) token from ref_token_date
         where type_token=:mois1
         order by id
         into :smois;
    separateur=' ';
  end
  else
  begin
    if (mois1<10) then --ajouter 0 devant
      smois='0'||cast(mois1 as varchar(1));
    else
      smois=cast(mois1 as varchar(2));
    select first(1) token from ref_token_date
         where type_token=22 and langue=:langue
         order by id
         into :separateur;
  end
  i=0;

  if (forme='NUM') then
    ordre=ordren;

  while (i<3 and i<char_length(ordre)) do
  begin
    i=i+1;
    ch=substring(ordre from i for 1);
    if (i<3) then
      if (ch='D') then
      begin
        if (sjour is not null) then
          date_writen_s=date_writen_s||sjour||separateur;
      end
      else
        if (ch='M') then
        begin
          if (smois is not null) then
            date_writen_s=date_writen_s||smois||separateur;
        end
        else
          date_writen_s=date_writen_s||san||separateur;
    else
      if (ch ='D') then
      begin
        if (sjour is not null) then date_writen_s=date_writen_s||sjour;
      end
      else
        if (ch='M') then
        begin
          if (smois is not null) then
            date_writen_s=date_writen_s||smois;
        end
        else
          date_writen_s=date_writen_s||san;
  end
  if (calendrier1=1) then
    date_writen_s=date_writen_s||' '||julien;

  if (token2 is not null) then --il y a une deuxième date
  begin
    sjour=null;
    smois=null;
    san=null;
    date_writen_s=date_writen_s||' '||token2||' ';
    if (jour2<10 and forme='NUM') then --ajouter 0 devant
      sjour='0'||cast(jour2 as varchar(1));
    else
      sjour=cast(jour2 as varchar(2));
    if (forme='LIT') then
      san=cast(an2 as varchar(5));
    else
    begin
      if (an2<0) then
      begin
        san='-';
        an2=-an2;
      end
      else
        san='';
      if (an2<10) then
        san=san||'000'||cast(an2 as varchar(5));
      else if (an2<100) then
        san=san||'00'||cast(an2 as varchar(5));
      else if (an2<1000) then
        san=san||'0'||cast(an2 as varchar(5));
      else
        san=san||cast(an2 as varchar(5));
    end
    if (forme='LIT') then
    begin
      select first(1) token from ref_token_date
        where type_token=:mois2 and langue=:langue
        order by id
        into :smois;
    end
    else
    begin
      if (mois2<10) then --ajouter 0 devant
        smois='0'||cast(mois2 as varchar(1));
      else
        smois=cast(mois2 as varchar(2));
    end
    i=0;
    while (i<3 and i<char_length(ordre)) do
    begin
      i=i+1;
      ch=substring(ordre from i for 1);
      if (i<3) then
        if (ch ='D') then
        begin
          if (sjour is not null) then
            date_writen_s=date_writen_s||sjour||separateur;
        end
        else
          if (ch='M') then
          begin
            if (smois is not null) then
              date_writen_s=date_writen_s||smois||separateur;
          end
          else
            date_writen_s=date_writen_s||san||separateur;
      else
        if (ch ='D') then
        begin
          if (sjour is not null) then date_writen_s=date_writen_s||sjour;
        end
        else
          if (ch='M') then
          begin
            if (smois is not null) then
              date_writen_s=date_writen_s||smois;
          end
          else
            date_writen_s=date_writen_s||san;
    end
    if (calendrier2=1) then
      date_writen_s=date_writen_s||' '||julien;
  end
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée en 2006 par André Langlet.
Dernière modification 31/10/2012 ajout du calendrier en sortie.'
  where RDB$PROCEDURE_NAME = 'PROC_DATE_WRITEN';

SET TERM ^ ;
ALTER PROCEDURE PROC_DATE_WRITEN_UN (
    DATE_WRITEN Varchar(100),
    LANGUE Varchar(3) )
RETURNS (
    IAN Integer,
    IMOIS Smallint,
    IJOUR Smallint,
    DATE_CODE Integer,
    DDATE Date,
    TOKEN Varchar(30),
    TYPE_TOKEN Smallint,
    DATE_WRITEN_S Varchar(100),
    VALIDE Smallint,
    CALENDRIER Smallint )
AS
declare variable i smallint;
declare variable ch char(1);
declare variable chd varchar(10);
declare variable intd smallint;
declare variable placemois smallint;
declare variable chd1 varchar(10);
declare variable chd2 varchar(10);
declare variable chd3 varchar(10);
declare variable cont varchar(3);
declare variable m varchar(5);
declare variable d varchar(5);
declare variable y varchar(5);
declare variable ordre varchar(3);
declare variable mode smallint;
declare variable delta smallint;
begin
  date_writen_s=date_writen;
  valide=0;
  if (char_length(date_writen_s)>0) then
  begin
    chd1='';
    chd2='';
    chd3='';
    placemois=0;
    calendrier=0;
    select first(1) type_token,trim(leading from substring(:date_writen_s from char_length(token)+1))
      from ref_token_date --recherche et élimination des token et espaces
      where type_token>12 and type_token<22 and langue=:langue
      and :date_writen_s starting with upper(lower(token))||' '
      order by char_length(token) desc
      into :type_token,:date_writen_s;

    i=0;
    chd='?';
    while (date_writen_s>'' and i<4 and chd>'' and char_length(chd)<10) do --Recherche composants de la date
    begin
      i=i+1;
      cont='OUI';
      if (i>1) then
      begin--élimination séparateurs
        if (substring(date_writen_s from 1 for 1)=' ') then
          date_writen_s=trim(leading from date_writen_s);
        else
          select first(1) trim(leading from substring(:date_writen_s from char_length(token)+1))
            from ref_token_date
            where type_token=22 and langue=:langue
            and :date_writen_s starting with token
            order by char_length(token) desc
            into :date_writen_s;
        if (date_writen_s='') then
          cont='NON';
      end

      chd='';
      if (cont='OUI') then --voir si token mois ou julien
      begin
        if (i=4) then
        begin
          for select first(1) substring(:date_writen_s from char_length(token)+1)
            from ref_token_date
            where type_token=25 and langue=:langue
            and :date_writen_s||' ' starting with upper(lower(token))||' '
            order by char_length(token) desc
            into :date_writen_s
          do
            calendrier=1;
          leave;--c'est obligatoirement le dernier de la date
        end
        else
          for select first(1) type_token,substring(:date_writen_s from char_length(token)+1)
            from ref_token_date
            where langue=:langue and
              ((type_token<13 and :date_writen_s starting with upper(lower(token)))
               or (type_token=25 and :date_writen_s||' ' starting with upper(lower(token))||' '))
            order by char_length(token) desc
            into :intd,:date_writen_s
          do
            if (intd=25) then
            begin
              if (i=1) then
              begin
                suspend;
                exit;
              end
              calendrier=1;
              leave;--c'est obligatoirement le dernier de la date
            end
            else
            begin
              placemois=i;
              chd=cast(intd as varchar(10));
            end
      end  --fin de si token mois ou julien

      if (chd='') then --voir si nombre
      begin
        ch=substring(date_writen_s from 1 for 1);
        if (ch in('-','(','0','1','2','3','4','5','6','7','8','9')) then
        begin --premier caractère
          if (ch='(') then
            ch='-';
          chd=ch;
          if (char_length(date_writen_s)>1) then
            date_writen_s=substring(date_writen_s from 2);
          else
          begin
            date_writen_s='';
            cont='NON';
          end
        end
        else
          cont='NON';
        while (cont='OUI') do --si chiffres, suivants
        begin
          ch=substring(date_writen_s from 1 for 1);
          if (ch in(')','0','1','2','3','4','5','6','7','8','9')) then
          begin
            if (ch=')') then
              cont='NON';
            else
              chd=chd||ch;
            if (char_length(date_writen_s)>1) then
              date_writen_s=substring(date_writen_s from 2);
            else
            begin
              date_writen_s='';
              cont='NON';
            end
          end
          else
            cont='NON';
        end
        if (chd='-') then
        begin
          suspend;
          exit;
        end
      end --fin de si nombre

      if (i=1) then
      begin
        chd1=chd;
        if (chd='') then --pas de date donc erreur
        begin
          suspend;
          exit;
        end
      end
      else if (i=2) then
        chd2=chd;
      else chd3=chd;
    end --fin recherche des composants de la date

    date_writen_s=trim(leading from date_writen_s);

    if (placemois=0) then --on décode une date au format NUM
      select first(1) skip (1) trim(upper(token))
      from ref_token_date  --ordre pour NUM
      where type_token=23 and langue=:langue order by id
      into :ordre;
    else --c'est une date au format LIT
      select first(1) trim(upper(token))
      from ref_token_date  --ordre pour LIT
      where type_token=23 and langue=:langue order by id
      into :ordre;

    if (chd2='') then  --que l'année dans CHD1
    begin
      ijour=null;
      imois=null;
      ian=cast(chd1 as integer);
      if (placemois=0) then
        valide=1;
    end
    else
    begin
      if (chd3='') then  --que année et mois dans CHD1 et CHD2
      begin
        ijour=null;
        i=0;
        while (i<3) do
        begin
          i=i+1;
          ch=substring(ordre from i for 1);
          if (ch in ('M','Y')) then  --pour le premier trouvé
          begin
            if (ch='M') then
            begin
              if (placemois=2) then
                m='0';
              else
                m=chd1;
            end
            else
              y=chd1;
            leave;
          end
        end
        while (i<3) do
        begin
          i=i+1;
          ch=substring(ordre from i for 1);
          if (ch in ('M','Y')) then --pour le second trouvé
          begin
            if (ch='M') then
            begin
              if (placemois=1) then
                m='0';
              else
                m=chd2;
            end
            else
              y=chd2;
            leave;
          end
        end
        ian=cast(y as integer);
        imois=cast(m as integer);
        if (imois>0 and imois<13) then
          valide=1;
      end
      else --tout est complet
      begin
        i=0;
        while (i<3) do
        begin
          i=i+1;
          ch=substring(ordre from i for 1);
          if (i=1) then
            chd=chd1;
          else if (i=2) then
              chd=chd2;
          else chd=chd3;
          if (ch ='D') then
            d=chd;
          else if (ch='M') then
            m=chd;
          else y=chd;
        end
        imois=cast(m as integer);
        ian=cast(y as integer);
        ijour=cast(d as integer);
        if (imois>0 and imois<13 and ijour>0 and ijour<32) then
        begin
          if (placemois>0) then
          begin
            if (placemois=1) then
              chd=chd1;
            else if (placemois=2) then
              chd=chd2;
            else if (placemois=3) then
              chd=chd3;
            if (chd=m) then
              valide=1;
          end
          else
            valide=1;
        end

        if (ian>0 and valide=1 and calendrier=0) then
        begin --bloc pour WHEN ANY
          if (ian<100) then
            y='00'||ian;
          ddate=cast(m||'/'||d||'/'||y as date);
          when any do
            valide=0;
        end
      end
    end

    if (valide=0) then
    begin
      ijour=null;
      imois=null;
      ian=null;
      date_code=null;
      token=null;
      type_token=null;
    end
    else
    begin
      if (ijour is not null) then
        select first(1) token from ref_token_date
          where type_token=:type_token and sous_type='D' and langue=:langue
          into :token;
      if (token is null and imois is not null) then
        select first(1) token from ref_token_date
          where type_token=:type_token and sous_type='M' and langue=:langue
          into :token;
      if (token is null) then
        select first(1) token from ref_token_date
          where type_token=:type_token and sous_type='Y' and langue=:langue
          into :token;
      if (token is null) then
        select first(1) token from ref_token_date
          where type_token=:type_token and langue=:langue
          order by id
          into :token;

      if (type_token in (13,17)) then --depuis, entre
      begin
        mode=1;
        delta=0;
      end
      else if (type_token in (14,18)) then --jusque,à,et
      begin
        mode=2;
        delta=0;
      end
      else if (type_token=15) then --avant
      begin
        mode=1;
        delta=-1;
      end
      else if (type_token=16) then --après
      begin
        mode=2;
        delta=1;
      end
      else
      begin
        mode=0;
        delta=0;
      end
      select date_code+:delta,valide from proc_date_code(:ian,:imois,:ijour,:mode,:calendrier)
        into :date_code,:valide;
    end
  end
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée en 2006 par André Langlet
Dernière modification 31/10/2012: ajout calendrier'
  where RDB$PROCEDURE_NAME = 'PROC_DATE_WRITEN_UN';

SET TERM ^ ;
ALTER PROCEDURE PROC_DELTA_DATES (
    NBRJOURS Integer )
RETURNS (
    IANS Integer,
    IMOIS Smallint,
    IJOURS Smallint )
AS
begin
  if (nbrjours>=0) then
  begin
    ians=trunc(NbrJours/365.25);
    imois=trunc((NbrJours-trunc(ians*365.25))/30.4375);
    ijours=NbrJours-trunc(ians*365.25)-trunc(imois*30.4375);
  end
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Création par André le 14/11/2007.
Refonte complète le 08/03/2012.'
  where RDB$PROCEDURE_NAME = 'PROC_DELTA_DATES';

SET TERM ^ ;
ALTER PROCEDURE PROC_DERNIER_METIER (
    I_CLEF Integer )
RETURNS (
    OCCUPATION Varchar(90) )
AS
begin
  select first(1) ev_ind_description
  from evenements_ind
  where ev_ind_kle_fiche=:i_clef and ev_ind_type='OCCU'
  order by ev_ind_ordre desc nulls first,
           ev_ind_datecode desc nulls first
  into :occupation;
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André Langlet
Dernière modification le 08/03/2012'
  where RDB$PROCEDURE_NAME = 'PROC_DERNIER_METIER';

SET TERM ^ ;
ALTER PROCEDURE PROC_DESCENDANCE (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_DOSSIER Integer )
RETURNS (
    NIVEAU Integer,
    SOSA Varchar(120),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    OCCUPATION Varchar(90),
    CLE_FICHE Integer,
    CLE_IMPORTATION Varchar(20),
    CLE_PARENTS Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    PREFIXE Varchar(30),
    NOM Varchar(40),
    PRENOM Varchar(60),
    SURNOM Varchar(120),
    SUFFIXE Varchar(30),
    SEXE Integer,
    I_DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer,
    I_DATE_DECES Varchar(100),
    ANNEE_DECES Integer,
    DECEDE Integer,
    AGE_AU_DECES Integer,
    SOURCE Blob sub_type 1,
    "COMMENT" Blob sub_type 1,
    FILLIATION Varchar(30),
    NUM_SOSA Double precision,
    ORDRE Varchar(255),
    NCHI Integer,
    NMR Integer,
    CLE_FIXE Integer,
    ASCENDANT Integer )
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 18:13:51
   Modifiée le : 10/02/2006 par André, remplissage table tempo par PROC_TQ_DESCENDANCE
   Calcul dernier métier par PROC_DERNIER_METIER. 09/07/07 optimisation
   à : :
   par :
   Description : Cette procedure permet de récuperer tous les descendants d'un individu
   en se servant d'une table technique
   Le remplissage de la table est fonction de Niveaux
   0 - Lui Meme
   x - les descendant par niveau
   Usage       :
   ---------------------------------------------------------------------------*/
   for
      SELECT   t.tq_niveau
              ,t.tq_num_sosa
              ,i.date_naissance
              ,i.date_deces
              ,t.tq_cle_fiche
              ,i.CLE_IMPORTATION
              ,i.CLE_PARENTS
              ,t.tq_cle_pere
              ,t.tq_cle_mere
              ,i.PREFIXE
              ,i.NOM
              ,i.PRENOM
              ,i.SURNOM
              ,i.SUFFIXE
              ,i.SEXE
              ,i.DATE_NAISSANCE
              ,i.ANNEE_NAISSANCE
              ,i.DATE_DECES
              ,i.ANNEE_DECES
              ,i.DECEDE
              ,i.AGE_AU_DECES
              ,i.SOURCE
              ,i."COMMENT"
              ,i.FILLIATION
              ,i.NUM_SOSA
              ,t.TQ_SOSA
              ,i.NCHI
              ,i.NMR
              ,i.CLE_FIXE
              ,(SELECT OCCUPATION FROM PROC_DERNIER_METIER(t.tq_cle_fiche))
              ,t.tq_ascendant
          FROM PROC_TQ_DESCENDANCE(:I_CLEF,:I_NIVEAU,0,1) t
               inner join individu i on i.cle_fiche=t.tq_cle_fiche
         ORDER BY t.TQ_NIVEAU,
                  t.tq_num_sosa
         INTO  :NIVEAU
              ,:SOSA
              ,:DATE_NAISSANCE
              ,:DATE_DECES
              ,:CLE_FICHE
              ,:CLE_IMPORTATION
              ,:CLE_PARENTS
              ,:CLE_PERE
              ,:CLE_MERE
              ,:PREFIXE
              ,:NOM
              ,:PRENOM
              ,:SURNOM
              ,:SUFFIXE
              ,:SEXE
              ,:I_DATE_NAISSANCE
              ,:ANNEE_NAISSANCE
              ,:I_DATE_DECES
              ,:ANNEE_DECES
              ,:DECEDE
              ,:AGE_AU_DECES
              ,:SOURCE
              ,:"COMMENT"
              ,:FILLIATION
              ,:NUM_SOSA
              ,:ORDRE
              ,:nchi
              ,:NMR
              ,:CLE_FIXE
              ,:OCCUPATION
              ,:ascendant
   do
     suspend;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_ECLATE_DESCRIPTION (
    DESCRIPTION Varchar(255),
    SEPARATEUR Char(1) )
RETURNS (
    S_DESCRIPTION Varchar(255) )
AS
declare variable i integer;
declare variable d integer;
begin
  description=trim(description);
  d=0;
  i=position(separateur in description);
  while (i>0) do
  begin
    s_description=trim(substring(description from d+1 for i-d-1));
    if (s_description>'') then suspend;
    d=i;
    i=position(separateur,description,d+1);
  end
  s_description=trim(substring(description from d+1));
  if (s_description>'') then suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André le 22/05/2007, dernière modification 5/10/2010
Découpe la description contenant le séparateur en descriptions élémentaires'
  where RDB$PROCEDURE_NAME = 'PROC_ECLATE_DESCRIPTION';

SET TERM ^ ;
ALTER PROCEDURE PROC_ECLATE_PRENOM (
    S_PRENOM Varchar(255) )
RETURNS (
    PRENOM Varchar(255) )
AS
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE I_LEN INTEGER;
DECLARE VARIABLE D INTEGER;
begin
   /*Créée par André le 24/10/2006, dernière modification 24/09/2007*/
  I_LEN=char_length(S_PRENOM);
  I=1;
  D=I;
  while (I<=I_LEN) do
  begin
    if (SUBSTRING(S_PRENOM from I for 1) in (' ',',','(',')','?')) then
    begin
      PRENOM=trim(SUBSTRING(S_PRENOM from D for I-D));
      if (PRENOM<>'') then SUSPEND;
      I=I+1;
      D=I;
    end
    else
      I=I+1;
  end
  PRENOM=trim(SUBSTRING(S_PRENOM from D));
  if (char_length(PRENOM)>0) then SUSPEND;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_AGE_PREM_UNION (
    A_CLE_DOSSIER Integer,
    LIMIT_ON_DATE Integer,
    LIMIT_ON_SOSA Integer,
    YEAR_FROM Integer,
    YEAR_TO Integer,
    INTERVAL Integer )
RETURNS (
    ANNEE_DEBUT Integer,
    ANNEE_FIN Integer,
    FEMMES Integer,
    AGE_FEMMES Decimal(15,2),
    HOMMES Integer,
    AGE_HOMMES Decimal(15,2) )
AS
declare variable annee integer;
declare variable age_mari integer;
declare variable age_femme integer;
declare variable cumul_age_maris integer;
declare variable cumul_age_femmes integer;
begin
  annee_debut=-10000;
  femmes=0;
  hommes=0;
  cumul_age_femmes=0;
  cumul_age_maris=0;
  for select annee
    ,age_femme
    ,age_mari
  from (select min(ef.ev_fam_date_year)as annee
            ,min(ef.ev_fam_date_year)-m.ev_ind_date_year as age_femme
            ,min(ef.ev_fam_date_year)-p.ev_ind_date_year as age_mari
    from t_union u
      inner join individu fi on fi.cle_fiche=u.union_femme
      inner join individu mi on mi.cle_fiche=u.union_mari
      inner join evenements_fam ef on ef.ev_fam_kle_famille=u.union_clef
      left join evenements_ind m on m.ev_ind_kle_fiche=u.union_femme
                                and m.ev_ind_type='BIRT'
      left join evenements_ind p on p.ev_ind_kle_fiche=u.union_mari
                                and p.ev_ind_type='BIRT'
    where u.kle_dossier=:a_cle_dossier
      and ef.ev_fam_date_year is not null
      and (:limit_on_sosa=0 or(fi.num_sosa>0 and mi.num_sosa>0))
    group by u.union_clef,m.ev_ind_date_year,p.ev_ind_date_year)
    where :limit_on_date=0
       or annee between :year_from and :year_to
    order by annee
  into :annee,
       :age_femme,
       :age_mari
  do
  begin
    if (annee_debut=-10000) then
    begin
      annee_debut=annee-mod(annee,interval);
      annee_fin=annee_debut+interval-1;
    end
    else
      if (annee>annee_fin) then
      begin
        while (annee>annee_fin) do
        begin
          if (femmes>0) then
            age_femmes=cast(cumul_age_femmes as double precision)/femmes;
          else
            age_femmes=null;
          cumul_age_femmes=0;
          if (hommes>0) then
            age_hommes=cast(cumul_age_maris as double precision)/hommes;
          else
            age_hommes=null;
          cumul_age_maris=0;
          suspend;
          femmes=0;
          hommes=0;
          annee_debut=annee_debut+interval;
          annee_fin=annee_debut+interval-1;
        end
      end
    if (age_femme is not null) then
    begin
      cumul_age_femmes=cumul_age_femmes+age_femme;
      femmes=femmes+1;
    end
    if (age_mari is not null) then
    begin
      cumul_age_maris=cumul_age_maris+age_mari;
      hommes=hommes+1;
    end
  end
  if (femmes>0 or hommes>0) then
  begin
    if (femmes>0) then
      age_femmes=cast(cumul_age_femmes as double precision)/femmes;
    else
      age_femmes=null;
    if (hommes>0) then
      age_hommes=cast(cumul_age_maris as double precision)/hommes;
    else
      age_hommes=null;
    suspend;
  end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure entièrement refaite par André Langlet le 11/08/2009
pour pouvoir définir les périodes et intervals de calcul'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_AGE_PREM_UNION';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_ANNIV_ORDER (
    A_MOIS Integer,
    I_DOSSIER Integer,
    GET_BIRT Integer,
    GET_DEAT Integer,
    GET_MARR Integer )
RETURNS (
    NOM Varchar(100),
    PRENOM Varchar(100),
    ADATE Varchar(100),
    ANNEE Integer,
    EV_TYPE Varchar(7),
    SEXE Integer )
AS
begin
  if (get_birt=1) then
    for select i.nom
              ,i.prenom
              ,n.ev_ind_date_writen
              ,n.ev_ind_date_year
              ,'BIRT'
              ,i.sexe
        from evenements_ind n
        inner join individu i on i.cle_fiche=n.ev_ind_kle_fiche
        where n.ev_ind_date_mois=:a_mois
          and n.ev_ind_type='BIRT'
          and i.kle_dossier=:i_dossier
        order by n.ev_ind_date_year,n.ev_ind_date_jour nulls last
        into :nom
            ,:prenom
            ,:adate
            ,:annee
            ,:ev_type
            ,:sexe
    do
      suspend;
  if (get_marr=1) then
    for select m.nom || ' ' || m.prenom
      ,f.nom || ' ' || f.prenom
      ,'MARR'
      ,1
      ,e.ev_fam_date_writen
      ,e.ev_fam_date_year
    from (select u.union_clef
      ,u.union_mari
      ,u.union_femme
      ,(select first(1) ev_fam_clef from evenements_fam
        where ev_fam_kle_famille=u.union_clef
          and ev_fam_type='MARR'
        order by ev_fam_datecode nulls last)
        from t_union u
        where u.kle_dossier=:i_dossier)r
    inner join individu m on m.cle_fiche=r.union_mari
    inner join individu f on f.cle_fiche=r.union_femme
    inner join evenements_fam e on e.ev_fam_clef=r.ev_fam_clef
        and e.ev_fam_date_mois=:a_mois
    order by e.ev_fam_date_year,e.ev_fam_date_jour nulls last
    into :nom
        ,:prenom
        ,:ev_type
        ,:sexe
        ,:adate
        ,:annee
    do
      suspend;

  if (get_deat=1) then
    for select r.nom
              ,r.prenom
              ,'DEAT'
              ,r.sexe
              ,d.ev_ind_date_writen
              ,d.ev_ind_date_year
      from (select i.nom
              ,i.prenom
              ,i.sexe
              ,(select first(1) ev_ind_clef from evenements_ind
                where ev_ind_kle_fiche=i.cle_fiche
                  and ev_ind_type in ('DEAT','BURI','CREM')
                  order by ev_ind_datecode nulls last)
            from individu i where i.kle_dossier=:i_dossier)r
      inner join evenements_ind d on d.ev_ind_clef=r.ev_ind_clef
          and d.ev_ind_date_mois=:a_mois
      order by d.ev_ind_date_year,d.ev_ind_date_jour nulls last
    into :nom
        ,:prenom
        ,:ev_type
        ,:sexe
        ,:adate
        ,:annee
    do
      suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Refonte complète par André le 25/11/2007: correction erreur ordre sur
date writen. Suppression requêtes intermédiaires.
Refonte 08/03/2012: correction erreurs mariages et décès pouvant apparaître
sur plusieurs mois.'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_ANNIV_ORDER';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_ASCENDANCE (
    I_CLEF Integer,
    I_GENERATION Integer,
    I_DOSSIER Integer,
    I_PARQUI Integer )
RETURNS (
    GENERATTION Integer,
    SOSA Double precision,
    NOM Varchar(101),
    DATE_NAISSANCE Varchar(100),
    CP_NAISSANCE Varchar(10),
    VILLE_NAISSANCE Varchar(50),
    LIEU_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    CP_DECES Varchar(10),
    VILLE_DECES Varchar(50),
    LIEU_DECES Varchar(100),
    SEXE Integer,
    AGE Integer,
    CLE_FICHE Integer,
    IMPLEXE Double precision,
    DATE_MARIAGE Varchar(100),
    CP_MARIAGE Varchar(10),
    VILLE_MARIAGE Varchar(50),
    NUM_SOSA Double precision )
AS
declare variable clef_union integer;
begin
   for select t.tq_niveau+1
             ,t.tq_sosa
             ,i.nom||coalesce(' '||i.prenom,'')
             ,n.ev_ind_date_writen
             ,n.ev_ind_cp
             ,n.ev_ind_ville
             ,n.ev_ind_ville||coalesce(', '||n.ev_ind_subd,'')
             ,d.ev_ind_date_writen
             ,d.ev_ind_cp
             ,d.ev_ind_ville
             ,d.ev_ind_ville||coalesce(', '||d.ev_ind_subd,'')
             ,i.sexe
             ,d.ev_ind_date_year-n.ev_ind_date_year
             ,t.tq_cle_fiche
             ,t.implexe
             ,u.union_clef
             ,i.num_sosa
       from proc_tq_ascendance(:i_clef,:i_generation,:i_parqui,1) t
       inner join individu i on i.cle_fiche=t.tq_cle_fiche
       left join evenements_ind n on n.ev_ind_kle_fiche=t.tq_cle_fiche
              and n.ev_ind_type = 'BIRT'
       left join evenements_ind d on d.ev_ind_kle_fiche=t.tq_cle_fiche and d.ev_ind_type='DEAT'
       left join t_union u
              on (i.sexe=1 and u.union_mari=t.tq_cle_fiche and u.union_femme=t.tq_dossier)
              or (i.sexe=2 and u.union_femme=t.tq_cle_fiche and u.union_mari=t.tq_dossier)
       order by 1,2
       into :generattion
           ,:sosa
           ,:nom
           ,:date_naissance
           ,:cp_naissance
           ,:ville_naissance
           ,:lieu_naissance
           ,:date_deces
           ,:cp_deces
           ,:ville_deces
           ,:lieu_deces
           ,:sexe
           ,:age
           ,:cle_fiche
           ,:implexe
           ,:clef_union
           ,:num_sosa
   do
   begin
     date_mariage=null;
     cp_mariage=null;
     ville_mariage=null;
     select first(1) ev_fam_date_writen
           ,ev_fam_cp
           ,ev_fam_ville
     from evenements_fam
     where ev_fam_type='MARR'
       and ev_fam_kle_famille=:clef_union
     order by ev_fam_datecode nulls last,ev_fam_heure
     into :date_mariage
         ,:cp_mariage
         ,:ville_mariage;
     suspend;
   end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Cette procedure prépare l''état complet d''ascendance d''un individu sur un nombre
de générations défini.
Procédure modifiée le :11/01/2006 par André Langlet, ajout du champ implexe
le 27/09/2006 pour concat avec prenom NULL et subd,
le 19/10/2006 ajout mariage
Refonte complète le 10/03/2012: utilisation tq_ascendance et datecode'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_ASCENDANCE';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_DENOMB_ASCEND (
    A_CLE_FICHE Integer )
RETURNS (
    NIVEAU Integer,
    TOTAL_INDI Integer,
    TOTAL_INDI_DISTINCT Integer,
    TOTAL_INDI_THEORIQUE Double precision,
    CUMUL_INDI Integer,
    CUMUL_INDI_DISTINCT Integer,
    CUMUL_INDI_THEORIQUE Double precision,
    POURCENT_IMPLEXE Double precision )
AS
begin
  delete from tq_ascendance;
  insert into tq_ascendance (tq_niveau,tq_cle_fiche)
           values (1,:a_cle_fiche);
  niveau=1;
  total_indi=1;
  total_indi_theorique=1;
  cumul_indi_theorique=0;
  delete from tq_consang;
  select 100*consanguinite
    from proc_consang(:a_cle_fiche,0,10)
    into :pourcent_implexe;
  delete from tq_consang;
  while (total_indi>0) do
  begin
    insert into tq_ascendance (tq_niveau,tq_cle_fiche)
      select :niveau+1,i.cle_pere
      from tq_ascendance t
      inner join individu i on i.cle_fiche=t.tq_cle_fiche
      where t.tq_niveau=:niveau;
    insert into tq_ascendance (tq_niveau,tq_cle_fiche)
      select :niveau+1,i.cle_mere
      from tq_ascendance t
      inner join individu i on i.cle_fiche=t.tq_cle_fiche
      where t.tq_niveau=:niveau;
    select count(tq_cle_fiche),count(distinct tq_cle_fiche)
    from tq_ascendance where tq_niveau=:niveau+1
    into :total_indi,:total_indi_distinct;
    if (total_indi>0) then
    begin
      select count(tq_cle_fiche)-1,count(distinct tq_cle_fiche)-1
      from tq_ascendance
      into :cumul_indi,:cumul_indi_distinct;
      total_indi_theorique=total_indi_theorique*2;
      cumul_indi_theorique=cumul_indi_theorique+total_indi_theorique;
      if (niveau>1) then
        pourcent_implexe=100*cast(cumul_indi-cumul_indi_distinct as double precision)/cumul_indi;
      niveau=niveau+1;
      suspend;
      if (niveau>100) then total_indi=0;
    end
  end
  delete from tq_ascendance;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Créé le : 31/07/2001 par Philippe Cazaux-Moutou
Modifiée le : 19/12/2005 par André pour fonctionnement état et calcul consanguinité
Pour des raisons de compatibilité avec l''état de dénombrement d''ascendance,
100*CONSANGUINITE est retourné dans la variable POURCENT_IMPLEXE
Réécriture et suppression paramètre Dossier: André Langlet décembre 2009
Dernière modification 13/04/2011.'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_DENOMB_ASCEND';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_DENOMB_DESCEND (
    A_CLE_FICHE Integer )
RETURNS (
    NIVEAU Integer,
    TOTAL_INDI Integer,
    TOTAL_INDI_DISTINCT Integer,
    CUMUL_INDI Integer,
    CUMUL_INDI_DISTINCT Integer,
    POURCENT_IMPLEXE Double precision )
AS
begin
  delete from tq_ascendance;
  insert into tq_ascendance (tq_niveau,tq_cle_fiche)
         values (1,:a_cle_fiche);
  niveau=1;
  total_indi=1;
  while (total_indi>0) do
  begin
    insert into tq_ascendance (tq_niveau,tq_cle_fiche)
      select :niveau+1, i.cle_fiche
      from tq_ascendance t
      inner join individu i on i.cle_pere=t.tq_cle_fiche or i.cle_mere=t.tq_cle_fiche
      where t.tq_niveau=:niveau;
    select count(tq_cle_fiche),count(distinct tq_cle_fiche)
    from tq_ascendance where tq_niveau=:niveau+1
    into :total_indi,:total_indi_distinct;
    if (total_indi>0) then
    begin
      select count(tq_cle_fiche)-1,count(distinct tq_cle_fiche)-1
      from tq_ascendance
      into :cumul_indi,:cumul_indi_distinct;
      pourcent_implexe=100*cast(cumul_indi-cumul_indi_distinct as double precision)/cumul_indi;
      niveau=niveau+1;
      suspend;
      if (niveau>100) then total_indi=0;
    end
  end
  delete from tq_ascendance;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Créé le : 31/07/2001 par Philippe Cazaux-Moutou.
Modifiée le : 19/12/2005 par André le calcul utilisant PROC_DESCENDANCE ne
comptant que les individus distincts, et les individus étant comptés deux
fois dans les cumuls.
Réécriture complète par André Langlet: décembre 2009, suppression paramètre Dossier'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_DENOMB_DESCEND';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_DESCENDANCE (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_DOSSIER Integer )
RETURNS (
    NIVEAU Integer,
    SOSA Varchar(120),
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    AGE Integer,
    ORDRE Varchar(255),
    CLE_NAISSANCE Integer,
    VILLE_NAISSANCE Varchar(50),
    CP_NAISSANCE Varchar(10),
    DEPT_NAISSANCE Varchar(30),
    PAYS_NAISSANCE Varchar(30),
    CODE_DEPT_NAISSANCE Varchar(2),
    CLE_DECES Integer,
    VILLE_DECES Varchar(50),
    CP_DECES Varchar(10),
    DEPT_DECES Varchar(30),
    PAYS_DECES Varchar(30),
    CODE_DEPT_DECES Varchar(2),
    OCCUPATION Varchar(90),
    CLE_CONJOINT Integer,
    NOM_CONJOINT Varchar(40),
    PRENOM_CONJOINT Varchar(60),
    CLE_NAISSANCE_CONJOINT Integer,
    DATE_NAISSANCE_CONJOINT Varchar(100),
    VILLE_NAISSANCE_CONJOINT Varchar(50),
    CP_NAISSANCE_CONJOINT Varchar(10),
    DEPT_NAISSANCE_CONJOINT Varchar(30),
    PAYS_NAISSANCE_CONJOINT Varchar(30),
    CODE_DEPT_NAISSANCE_CONJOINT Varchar(2),
    CLE_DECES_CONJOINT Integer,
    DATE_DECES_CONJOINT Varchar(100),
    VILLE_DECES_CONJOINT Varchar(50),
    CP_DECES_CONJOINT Varchar(10),
    DEPT_DECES_CONJOINT Varchar(30),
    PAYS_DECES_CONJOINT Varchar(30),
    CODE_DEPT_DECES_CONJOINT Varchar(2),
    OCCUPATION_CONJOINT Varchar(90),
    CLE_MARIAGE Integer,
    DATE_MARIAGE Varchar(100),
    VILLE_MARIAGE Varchar(100),
    CP_MARIAGE Varchar(10),
    DEPT_MARIAGE Varchar(30),
    PAYS_MARIAGE Varchar(30),
    CODE_DEPT_MARIAGE Varchar(2),
    CLE_UNION Integer,
    ORDRE_UNION Integer,
    ISSU_UNION Integer )
AS
begin
   FOR SELECT
     t.tq_niveau
    ,t.tq_num_sosa
    ,t.tq_cle_fiche
    ,i.NOM
    ,i.prenom
    ,i.DATE_NAISSANCE
    ,i.DATE_DECES
    ,i.SEXE
    ,i.CLE_PERE
    ,i.CLE_MERE
    ,i.AGE_AU_DECES
    ,t.TQ_SOSA
    ,n.ev_ind_clef
    ,n.EV_IND_VILLE
    ,n.EV_IND_CP
    ,n.ev_ind_dept
    ,n.ev_ind_pays
    ,substring(n.ev_ind_insee from 1 for 2)
    ,d.ev_ind_clef
    ,d.EV_IND_VILLE
    ,d.EV_IND_CP
    ,d.ev_ind_dept
    ,d.ev_ind_pays
    ,substring(d.ev_ind_insee from 1 for 2)
    ,(SELECT OCCUPATION FROM PROC_DERNIER_METIER(t.tq_cle_fiche))
    ,p.conjoint
    ,c.NOM
    ,c.prenom
    ,nc.ev_ind_clef
    ,c.date_naissance
    ,nc.EV_IND_VILLE
    ,nc.EV_IND_CP
    ,nc.ev_ind_dept
    ,nc.ev_ind_pays
    ,substring(nc.ev_ind_insee from 1 for 2)
    ,dc.ev_ind_clef
    ,c.date_deces
    ,dc.EV_IND_VILLE
    ,dc.EV_IND_CP
    ,dc.ev_ind_dept
    ,dc.ev_ind_pays
    ,substring(dc.ev_ind_insee from 1 for 2)
    ,(SELECT OCCUPATION FROM PROC_DERNIER_METIER(p.conjoint))
    ,p.clef_marr
    ,m.ev_fam_date_writen
    ,m.EV_fam_VILLE
    ,m.EV_fam_CP
    ,m.ev_fam_dept
    ,m.ev_fam_pays
    ,substring(m.ev_fam_insee from 1 for 2)
    ,p.clef_union
    ,p.ordre
    ,(select first(1) ordre
      from proc_conjoints_ordonnes(t.tq_ascendant,0)
      where conjoint in (i.cle_pere,i.cle_mere))
    FROM PROC_TQ_DESCENDANCE(:I_CLEF,:I_NIVEAU,0,1) t
    inner join individu i on i.cle_fiche=t.tq_cle_fiche
    left join EVENEMENTS_IND n on n.EV_IND_KLE_FICHE=i.cle_fiche
                               and n.EV_IND_TYPE='BIRT'
    left join EVENEMENTS_IND d on d.EV_IND_KLE_FICHE=i.cle_fiche
                               and d.EV_IND_TYPE='DEAT'
    left join proc_conjoints_ordonnes(i.cle_fiche,0) p ON 1=1
    left join individu c on c.cle_fiche=p.conjoint
    left join EVENEMENTS_IND nc on nc.EV_IND_KLE_FICHE=p.conjoint
                               and nc.EV_IND_TYPE='BIRT'
    left join EVENEMENTS_IND dc on dc.EV_IND_KLE_FICHE=p.conjoint
                               and dc.EV_IND_TYPE='DEAT'
    left join EVENEMENTS_FAM m on m.ev_fam_clef=p.clef_marr
    ORDER BY t.tq_niveau
            ,t.tq_num_sosa
            ,p.ordre
    INTO :NIVEAU
         ,:SOSA
         ,:CLE_FICHE
         ,:NOM
         ,:prenom
         ,:DATE_NAISSANCE
         ,:DATE_DECES
         ,:SEXE
         ,:CLE_PERE
         ,:CLE_MERE
         ,:AGE
         ,:ORDRE
         ,:cle_naissance
         ,:ville_naissance
         ,:cp_naissance
         ,:dept_naissance
         ,:pays_naissance
         ,:code_dept_naissance
         ,:cle_deces
         ,:ville_deces
         ,:cp_deces
         ,:dept_deces
         ,:pays_deces
         ,:code_dept_deces
         ,:occupation
         ,:cle_conjoint
         ,:nom_conjoint
         ,:prenom_conjoint
         ,:cle_naissance_conjoint
         ,:date_naissance_conjoint
         ,:ville_naissance_conjoint
         ,:cp_naissance_conjoint
         ,:dept_naissance_conjoint
         ,:pays_naissance_conjoint
         ,:code_dept_naissance_conjoint
         ,:cle_deces_conjoint
         ,:date_deces_conjoint
         ,:ville_deces_conjoint
         ,:cp_deces_conjoint
         ,:dept_deces_conjoint
         ,:pays_deces_conjoint
         ,:code_dept_deces_conjoint
         ,:occupation_conjoint
         ,:cle_mariage
         ,:date_mariage
         ,:ville_mariage
         ,:cp_mariage
         ,:dept_mariage
         ,:pays_mariage
         ,:code_dept_mariage
         ,:cle_union
         ,:ordre_union
         ,:issu_union
   do
   suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par Philippe Cazaux-Moutou le : 31/07/2001 à : 19:06:20
Modifiée le : 12/01/2006 par André Langlet pour erreur concaténation si prénom NULL
09/07/07 ajout conjoints, mariages et précisions du lieu
Entièrement refaite le 07/04/2009: utilisation de PROC_CONJOINTS_ORDONNES
15/06/2012 code département à 2 caractères déduit du code INSEE
Description : Cette procedure permet de récuperer tous les descendant d''un individu'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_DESCENDANCE';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_ECLAIR (
    I_DOSSIER Integer,
    I_SOSA Integer,
    A_VILLE Varchar(50) )
RETURNS (
    NOM Varchar(40),
    CP Varchar(10),
    VILLE Varchar(50),
    PAYS Varchar(30),
    DATE_DEBUT Integer,
    DATE_FIN Integer,
    NAISSANCE Integer,
    BAPTEME Integer,
    MARIAGE Integer,
    DECES Integer,
    SEP Integer,
    INSEE Varchar(6),
    DEPT Varchar(30),
    REGION Varchar(50) )
AS
begin
  select s_out from f_maj_sans_accent(:a_ville) into :a_ville;
  if (A_VILLE='') then a_ville='%';
  if (I_SOSA is null) then I_SOSA = 0;
  DELETE FROM TQ_ECLAIR;
  INSERT INTO TQ_ECLAIR(TQ_NOM
                       ,TQ_CP
                       ,TQ_VILLE
                       ,TQ_PAYS
                       ,TQ_INSEE
                       ,TQ_DEPT
                       ,TQ_REGION
                       ,TQ_DATE
                       ,TQ_NAISSANCE)
                 select i.NOM
                       ,e.EV_IND_CP
                       ,e.EV_IND_VILLE
                       ,e.EV_IND_PAYS
                       ,e.EV_IND_INSEE
                       ,e.EV_IND_DEPT
                       ,e.EV_IND_REGION
                       ,e.EV_IND_DATE_YEAR
                       ,1
                 from EVENEMENTS_IND e
                   inner join INDIVIDU i on i.CLE_FICHE=e.EV_IND_KLE_FICHE
                 where e.EV_IND_TYPE='BIRT'
                   and e.EV_IND_DATE_YEAR is not null
                   and e.EV_IND_VILLE is not null
                   and (:A_VILLE='%' or
                     (select s_out from f_maj_sans_accent(e.EV_IND_VILLE)) like :A_VILLE)
                     and i.KLE_DOSSIER=:I_DOSSIER
                     and (:I_SOSA=0 or (:I_SOSA=1 and i.NUM_SOSA>0));
  INSERT INTO TQ_ECLAIR(TQ_NOM
                       ,TQ_CP
                       ,TQ_VILLE
                       ,TQ_PAYS
                       ,TQ_INSEE
                       ,TQ_DEPT
                       ,TQ_REGION
                       ,TQ_DATE
                       ,TQ_BAPTEME)
                 select i.NOM
                       ,e.EV_IND_CP
                       ,e.EV_IND_VILLE
                       ,e.EV_IND_PAYS
                       ,e.EV_IND_INSEE
                       ,e.EV_IND_DEPT
                       ,e.EV_IND_REGION
                       ,e.EV_IND_DATE_YEAR
                       ,1
                 from EVENEMENTS_IND e
                   inner join INDIVIDU i on i.CLE_FICHE=e.EV_IND_KLE_FICHE
                 where e.EV_IND_TYPE in ('CHR','BAPM')
                   and e.EV_IND_DATE_YEAR is not null
                   and e.EV_IND_VILLE is not null
                   and (:A_VILLE='%' or
                     (select s_out from f_maj_sans_accent(e.EV_IND_VILLE)) like :A_VILLE)
                     and i.KLE_DOSSIER=:I_DOSSIER
                     and (:I_SOSA=0 or (:I_SOSA=1 and i.NUM_SOSA>0));
  INSERT INTO TQ_ECLAIR(TQ_NOM
                       ,TQ_CP
                       ,TQ_VILLE
                       ,TQ_PAYS
                       ,TQ_INSEE
                       ,TQ_DEPT
                       ,TQ_REGION
                       ,TQ_DATE
                       ,TQ_DECES)
                 select i.NOM
                       ,e.EV_IND_CP
                       ,e.EV_IND_VILLE
                       ,e.EV_IND_PAYS
                       ,e.EV_IND_INSEE
                       ,e.EV_IND_DEPT
                       ,e.EV_IND_REGION
                       ,e.EV_IND_DATE_YEAR
                       ,1
                 from EVENEMENTS_IND e
                   inner join INDIVIDU i on i.CLE_FICHE=e.EV_IND_KLE_FICHE
                 where e.EV_IND_TYPE='DEAT'
                   and e.EV_IND_DATE_YEAR is not null
                   and e.EV_IND_VILLE is not null
                   and (:A_VILLE='%' or
                     (select s_out from f_maj_sans_accent(e.EV_IND_VILLE)) like :A_VILLE)
                     and i.KLE_DOSSIER=:I_DOSSIER
                     and (:I_SOSA=0 or (:I_SOSA=1 and i.NUM_SOSA>0));
  INSERT INTO TQ_ECLAIR(TQ_NOM
                       ,TQ_CP
                       ,TQ_VILLE
                       ,TQ_PAYS
                       ,TQ_INSEE
                       ,TQ_DEPT
                       ,TQ_REGION
                       ,TQ_DATE
                       ,TQ_SEPULTURE)
                 select i.NOM
                       ,e.EV_IND_CP
                       ,e.EV_IND_VILLE
                       ,e.EV_IND_PAYS
                       ,e.EV_IND_INSEE
                       ,e.EV_IND_DEPT
                       ,e.EV_IND_REGION
                       ,e.EV_IND_DATE_YEAR
                       ,1
                 from EVENEMENTS_IND e
                   inner join INDIVIDU i on i.CLE_FICHE=e.EV_IND_KLE_FICHE
                 where e.EV_IND_TYPE='BURI'
                   and e.EV_IND_DATE_YEAR is not null
                   and e.EV_IND_VILLE is not null
                   and (:A_VILLE='%' or
                     (select s_out from f_maj_sans_accent(e.EV_IND_VILLE)) like :A_VILLE)
                     and i.KLE_DOSSIER=:I_DOSSIER
                     and (:I_SOSA=0 or (:I_SOSA=1 and i.NUM_SOSA>0));
  INSERT INTO TQ_ECLAIR(TQ_NOM
                       ,TQ_CP
                       ,TQ_VILLE
                       ,TQ_PAYS
                       ,TQ_INSEE
                       ,TQ_DEPT
                       ,TQ_REGION
                       ,TQ_DATE
                       ,TQ_MARIAGE)
                 select i.NOM
                       ,e.EV_FAM_CP
                       ,e.EV_FAM_VILLE
                       ,e.EV_FAM_PAYS
                       ,e.EV_FAM_INSEE
                       ,e.EV_FAM_DEPT
                       ,e.EV_FAM_REGION
                       ,e.EV_FAM_DATE_YEAR
                       ,1
                 from T_UNION u
                   inner join EVENEMENTS_FAM e on e.EV_FAM_KLE_FAMILLE=u.UNION_CLEF
                   inner join INDIVIDU i on i.CLE_FICHE=u.UNION_MARI
                 where e.EV_FAM_TYPE='MARR'
                   and e.EV_FAM_DATE_YEAR is not null
                   and e.EV_FAM_VILLE is not null
                   and (:A_VILLE='%' or
                     (select s_out from f_maj_sans_accent(e.EV_FAM_VILLE)) like :A_VILLE)
                     and i.KLE_DOSSIER=:I_DOSSIER
                     and (:I_SOSA=0 or (:I_SOSA=1 and i.NUM_SOSA>0));
  INSERT INTO TQ_ECLAIR(TQ_NOM
                       ,TQ_CP
                       ,TQ_VILLE
                       ,TQ_PAYS
                       ,TQ_INSEE
                       ,TQ_DEPT
                       ,TQ_REGION
                       ,TQ_DATE
                       ,TQ_MARIAGE)
                 select i.NOM
                       ,e.EV_FAM_CP
                       ,e.EV_FAM_VILLE
                       ,e.EV_FAM_PAYS
                       ,e.EV_FAM_INSEE
                       ,e.EV_FAM_DEPT
                       ,e.EV_FAM_REGION
                       ,e.EV_FAM_DATE_YEAR
                       ,1
                 from T_UNION u
                   inner join EVENEMENTS_FAM e  on e.EV_FAM_KLE_FAMILLE=u.UNION_CLEF
                   inner join INDIVIDU i on i.CLE_FICHE=u.UNION_FEMME
                 where e.EV_FAM_TYPE='MARR'
                   and e.EV_FAM_DATE_YEAR is not null
                   and e.EV_FAM_VILLE is not null
                   and (:A_VILLE='%' or
                     (select s_out from f_maj_sans_accent(e.EV_FAM_VILLE)) like :A_VILLE)
                     and i.KLE_DOSSIER=:I_DOSSIER
                     and (:I_SOSA=0 or (:I_SOSA=1 and i.NUM_SOSA>0));
  for select TQ_NOM
            ,TQ_CP
            ,TQ_VILLE
            ,TQ_PAYS
            ,TQ_INSEE
            ,TQ_DEPT
            ,TQ_REGION
            ,min(TQ_DATE)
            ,max(TQ_DATE)
            ,sum(TQ_NAISSANCE)
            ,sum(TQ_BAPTEME)
            ,sum(TQ_MARIAGE)
            ,sum(TQ_DECES)
            ,sum(TQ_SEPULTURE)
      from TQ_ECLAIR
      group by TQ_NOM
            ,TQ_CP
            ,TQ_VILLE
            ,TQ_PAYS
            ,TQ_INSEE
            ,TQ_DEPT
            ,TQ_REGION
      INTO :NOM
          ,:CP
          ,:VILLE
          ,:PAYS
          ,:INSEE
          ,:DEPT
          ,:REGION
          ,:DATE_DEBUT
          ,:DATE_FIN
          ,:NAISSANCE
          ,:BAPTEME
          ,:MARIAGE
          ,:DECES
          ,:SEP
      DO
        SUSPEND;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Refonte complète le 26/10/2006 par André (avec TQ_ECLAIR et état) pour calculer
les nombres de naissances, baptêmes, mariages, décès et sépultures, ajouter le champ INSEE
11/05/2011: suppression champ clef inutile.
Usage       : Pour l''état de la liste eclair
Parametres  : I_DOSSIER : N° de dossier
              I_SOSA : si 1 on ne sort que les ind avec N° sosa
              S_VILLE : si une ville alors on ne remonte que pour cette ville'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_ECLAIR';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_FICHE (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    LIEU_NAISSANCE Varchar(210),
    DATE_DECES Varchar(100),
    LIEU_DECES Varchar(210),
    SEXE Integer,
    FILLIATION Varchar(30),
    "COMMENT" Blob sub_type 1,
    PERE_NOM Varchar(120),
    PERE_NAISSANCE Varchar(100),
    PERE_LIEU_NAISSANCE Varchar(210),
    PERE_DECES Varchar(100),
    PERE_LIEU_DECES Varchar(210),
    MERE_NOM Varchar(120),
    MERE_NAISSANCE Varchar(100),
    MERE_LIEU_NAISSANCE Varchar(210),
    MERE_DECES Varchar(100),
    MERE_LIEU_DECES Varchar(210),
    PHOTO Blob sub_type 0,
    PREFIXE Varchar(30),
    SUFFIXE Varchar(30),
    SURNOM Varchar(120),
    NUM_SOSA Double precision,
    SOSA1_NOMPRENOM Varchar(105),
    SOSAS Varchar(30),
    SOSAS_PERE Varchar(30),
    SOSAS_MERE Varchar(30),
    AGE_DECES Varchar(60),
    AGE_DECES_PERE Varchar(60),
    AGE_DECES_MERE Varchar(60) )
AS
declare variable langue varchar(3);
begin
  select ds.ds_langue
  from individu i
  inner join dossier ds on ds.cle_dossier=i.kle_dossier
  where i.cle_fiche=:i_clef
  into langue;
  rdb$set_context('USER_SESSION','LANGUE',langue);
   select  i.cle_fiche
          ,i.nom
          ,i.prenom
          ,n.ev_ind_date_writen
          ,coalesce(n.ev_ind_ville,'')||coalesce(', '||n.ev_ind_subd,'')
                     ||coalesce(', '||n.ev_ind_dept,'')||coalesce(', '||n.ev_ind_pays,'')
          ,d.ev_ind_date_writen
          ,coalesce(d.ev_ind_ville,'')||coalesce(', '||d.ev_ind_subd,'')
                     ||coalesce(', '||d.ev_ind_dept,'')||coalesce(', '||d.ev_ind_pays,'')
          ,i.sexe
          ,i.filliation
          ,i.comment
          ,i.prefixe
          ,i.suffixe
          ,i.surnom
          ,i.num_sosa
          ,mu.multi_reduite
          ,p.nom||coalesce(', '||p.prenom,'')
          ,np.ev_ind_date_writen
          ,coalesce(np.ev_ind_ville,'')||coalesce(', '||np.ev_ind_subd,'')
                     ||coalesce(', '||np.ev_ind_dept,'')||coalesce(', '||np.ev_ind_pays,'')
          ,dp.ev_ind_date_writen
          ,coalesce(dp.ev_ind_ville,'')||coalesce(', '||dp.ev_ind_subd,'')
                     ||coalesce(', '||dp.ev_ind_dept,'')||coalesce(', '||dp.ev_ind_pays,'')
          ,m.nom||coalesce(', '||m.prenom,'')
          ,nm.ev_ind_date_writen
          ,coalesce(nm.ev_ind_ville,'')||coalesce(', '||nm.ev_ind_subd,'')
                     ||coalesce(', '||nm.ev_ind_dept,'')||coalesce(', '||nm.ev_ind_pays,'')
          ,dm.ev_ind_date_writen
          ,coalesce(dm.ev_ind_ville,'')||coalesce(', '||dm.ev_ind_subd,'')
                     ||coalesce(', '||dm.ev_ind_dept,'')||coalesce(', '||dm.ev_ind_pays,'')
          ,s.nom||coalesce(', '||s.prenom,'')
          ,(select sosas from proc_sosas(i.cle_fiche))
          ,(select sosas from proc_sosas(p.cle_fiche))
          ,(select sosas from proc_sosas(m.cle_fiche))
          ,(select age_texte from proc_age_texte(i.date_naissance,i.date_deces))
          ,(select age_texte from proc_age_texte(p.date_naissance,p.date_deces))
          ,(select age_texte from proc_age_texte(m.date_naissance,m.date_deces))
        from  individu i
              left join evenements_ind n on i.cle_fiche=n.ev_ind_kle_fiche
                                        and n.ev_ind_type='BIRT'
              left join evenements_ind d on i.cle_fiche=d.ev_ind_kle_fiche
                                        and d.ev_ind_type='DEAT'
              left join media_pointeurs mp on mp.mp_cle_individu=i.cle_fiche
                                           and mp.mp_identite=1
              left join multimedia mu on mu.multi_clef=mp.mp_media
              left join individu p on p.cle_fiche=i.cle_pere
              left join evenements_ind np on np.ev_ind_kle_fiche=p.cle_fiche
                                         and np.ev_ind_type='BIRT'
              left join evenements_ind dp on dp.ev_ind_kle_fiche=p.cle_fiche
                                         and dp.ev_ind_type='DEAT'
              left join individu m on m.cle_fiche=i.cle_mere
              left join evenements_ind nm on nm.ev_ind_kle_fiche=m.cle_fiche
                                         and nm.ev_ind_type='BIRT'
              left join evenements_ind dm on dm.ev_ind_kle_fiche=m.cle_fiche
                                         and dm.ev_ind_type='DEAT'
              left join individu s on s.kle_dossier=i.kle_dossier
                                   and s.num_sosa=1
          where i.cle_fiche = :i_clef
         into :cle_fiche
             ,:nom
             ,:prenom
             ,:date_naissance
             ,:lieu_naissance
             ,:date_deces
             ,:lieu_deces
             ,:sexe
             ,:filliation
             ,:comment
             ,:prefixe
             ,:suffixe
             ,:surnom
             ,:num_sosa
             ,:photo
             ,:pere_nom
             ,:pere_naissance
             ,:pere_lieu_naissance
             ,:pere_deces
             ,:pere_lieu_deces
             ,:mere_nom
             ,:mere_naissance
             ,:mere_lieu_naissance
             ,:mere_deces
             ,:mere_lieu_deces
             ,:sosa1_nomprenom
             ,:sosas
             ,:sosas_pere
             ,:sosas_mere
             ,:age_deces
             ,:age_deces_pere
             ,:age_deces_mere;
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure entièrement refaite par André Langlet le 13/06/2009'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_FICHE';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_FICHE_FAMILIALE (
    ACLE_UNION Integer )
RETURNS (
    A_EPOUX_CLE Integer,
    A_EPOUX_NOMPRENOM Varchar(105),
    A_EPOUX_NAISSANCE Varchar(100),
    A_EPOUX_LIEU_NAISSANCE Varchar(166),
    A_EPOUX_DECES Varchar(100),
    A_EPOUX_LIEU_DECES Varchar(166),
    A_EPOUSE_CLE Integer,
    A_EPOUSE_NOMPRENOM Varchar(105),
    A_EPOUSE_NAISSANCE Varchar(100),
    A_EPOUSE_LIEU_NAISSANCE Varchar(166),
    A_EPOUSE_DECES Varchar(100),
    A_EPOUSE_LIEU_DECES Varchar(166),
    A_EPOUX_PHOTO Blob sub_type 0,
    A_EPOUSE_PHOTO Blob sub_type 0,
    A_EPOUX_PERE_NOM Varchar(40),
    A_EPOUX_PERE_PRENOM Varchar(60),
    A_EPOUX_MERE_NOM Varchar(40),
    A_EPOUX_MERE_PRENOM Varchar(60),
    A_EPOUSE_PERE_NOM Varchar(40),
    A_EPOUSE_PERE_PRENOM Varchar(60),
    A_EPOUSE_MERE_NOM Varchar(40),
    A_EPOUSE_MERE_PRENOM Varchar(60),
    A_EPOUX_ANNEE Integer,
    A_EPOUSE_ANNEE Integer,
    A_EPOUX_SOSA Double precision,
    A_EPOUSE_SOSA Double precision,
    A_SOSA1_NOMPRENOM Varchar(105),
    A_EPOUX_NOM Varchar(40),
    A_EPOUSE_NOM Varchar(40),
    SOSAS_EPOUX Varchar(30),
    SOSAS_EPOUSE Varchar(30),
    A_EPOUX_AGE Varchar(60),
    A_EPOUSE_AGE Varchar(60) )
AS
declare variable mari integer;
declare variable femme integer;
declare variable langue varchar(3);
begin
     select union_mari,
            union_femme
     from t_union
     where union_clef=:acle_union
     into :mari
         ,:femme;

     select first(1) ds.ds_langue
     from individu i
     inner join dossier ds on ds.cle_dossier=i.kle_dossier
     where (:mari>0 and i.cle_fiche=:mari)or(:femme>0 and i.cle_fiche=:femme)
     into langue;
     rdb$set_context('USER_SESSION','LANGUE',langue);

        /*l epoux*/
     if (mari>0) then
       select
            i.cle_fiche
           ,i.nom
           ,coalesce(i.nom||', ','')||coalesce(i.prenom,'')
           ,n.ev_ind_date_writen
           ,coalesce(n.ev_ind_ville,'')||coalesce(', '||n.ev_ind_subd,'')
                     ||coalesce(', '||n.ev_ind_dept,'')||coalesce(', '||n.ev_ind_pays,'')
           ,d.ev_ind_date_writen
           ,coalesce(d.ev_ind_ville,'')||coalesce(', '||d.ev_ind_subd,'')
                     ||coalesce(', '||d.ev_ind_dept,'')||coalesce(', '||d.ev_ind_pays,'')
           ,i.annee_naissance
           ,i.num_sosa
           ,p.nom
           ,p.prenom
           ,m.nom
           ,m.prenom
           ,mu.multi_reduite
           ,(select sosas from proc_sosas(i.cle_fiche))
           ,(select age_texte from proc_age_texte(i.date_naissance,i.date_deces))
       from individu i
         left join evenements_ind n on i.cle_fiche=n.ev_ind_kle_fiche
                                   and n.ev_ind_type='BIRT'
         left join evenements_ind d on i.cle_fiche=d.ev_ind_kle_fiche
                                   and d.ev_ind_type='DEAT'
         left join individu p on p.cle_fiche=i.cle_pere
         left join individu m on m.cle_fiche=i.cle_mere
         left join media_pointeurs mp on mp.mp_cle_individu=i.cle_fiche
                                     and mp.mp_identite=1
         left join multimedia mu on mu.multi_clef=mp.mp_media
       where i.cle_fiche =:mari
       into   :a_epoux_cle
             ,:a_epoux_nom
             ,:a_epoux_nomprenom
             ,:a_epoux_naissance
             ,:a_epoux_lieu_naissance
             ,:a_epoux_deces
             ,:a_epoux_lieu_deces
             ,:a_epoux_annee
             ,:a_epoux_sosa
             ,:a_epoux_pere_nom
             ,:a_epoux_pere_prenom
             ,:a_epoux_mere_nom
             ,:a_epoux_mere_prenom
             ,:a_epoux_photo
             ,:sosas_epoux
             ,:a_epoux_age;
        /*l epouse*/
     if (femme>0) then
       select
            i.cle_fiche,
            i.nom, 
            coalesce(i.nom||', ','')||coalesce(i.prenom,''),
            n.ev_ind_date_writen,
            coalesce(n.ev_ind_ville,'')||coalesce(', '||n.ev_ind_subd,'')
                     ||coalesce(', '||n.ev_ind_dept,'')||coalesce(', '||n.ev_ind_pays,''),
            d.ev_ind_date_writen,
            coalesce(d.ev_ind_ville,'')||coalesce(', '||d.ev_ind_subd,'')
                     ||coalesce(', '||d.ev_ind_dept,'')||coalesce(', '||d.ev_ind_pays,''),
            i.annee_naissance,
            i.num_sosa,
            p.nom,
            p.prenom,
            m.nom,
            m.prenom,
            mu.multi_reduite
           ,(select sosas from proc_sosas(i.cle_fiche))
           ,(select age_texte from proc_age_texte(i.date_naissance,i.date_deces))
       from individu i
         left join evenements_ind n on i.cle_fiche=n.ev_ind_kle_fiche
                                   and n.ev_ind_type='BIRT'
         left join evenements_ind d on i.cle_fiche=d.ev_ind_kle_fiche
                                   and d.ev_ind_type='DEAT'
         left join individu p on p.cle_fiche=i.cle_pere
         left join individu m on m.cle_fiche=i.cle_mere
         left join media_pointeurs mp on mp.mp_cle_individu=i.cle_fiche
                                     and mp.mp_identite=1
         left join multimedia mu on mu.multi_clef=mp.mp_media
       where i.cle_fiche =:femme
       into   :a_epouse_cle
             ,:a_epouse_nom
             ,:a_epouse_nomprenom
             ,:a_epouse_naissance
             ,:a_epouse_lieu_naissance
             ,:a_epouse_deces
             ,:a_epouse_lieu_deces
             ,:a_epouse_annee
             ,:a_epouse_sosa
             ,:a_epouse_pere_nom
             ,:a_epouse_pere_prenom
             ,:a_epouse_mere_nom
             ,:a_epouse_mere_prenom
             ,:a_epouse_photo
             ,:sosas_epouse
             ,:a_epouse_age;
     select nom||coalesce(', '||prenom,'') from individu where num_sosa=1
          and kle_dossier=(select first (1) kle_dossier from individu
                           where (:a_epoux_cle>0 and cle_fiche=:a_epoux_cle)
                             or (:a_epouse_cle>0 and cle_fiche=:a_epouse_cle))
     into :a_sosa1_nomprenom;
     suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Dernière modification le 05/07/2011 par André Langlet, remplacement multi_media
par multi_reduite'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_FICHE_FAMILIALE';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_LONGEVITE (
    A_CLE_DOSSIER Integer,
    LIMIT_ON_DATE Integer,
    LIMIT_ON_SOSA Integer,
    YEAR_FROM Integer,
    YEAR_TO Integer,
    INTERVAL Integer )
RETURNS (
    INTERVAL_START Integer,
    INTERVAL_END Integer,
    NB_HOMME Integer,
    MOYENNE_AGE_HOMME Double precision,
    ECART_TYPE_AGE_HOMME Double precision,
    NB_FEMME Integer,
    MOYENNE_AGE_FEMME Double precision,
    ECART_TYPE_AGE_FEMME Double precision )
AS
declare variable ok_suspend integer;
declare variable age double precision;
declare variable annee_deces integer;
declare variable sexe integer;
declare variable cumul_carre_homme double precision;
declare variable cumul_carre_femme double precision;
declare variable cumul_age_homme double precision;
declare variable cumul_age_femme double precision;
begin
  ok_suspend=0;
  for select (d.ev_ind_datecode-n.ev_ind_datecode)/365.25
    ,annee_deces
    ,i.sexe
  from individu i
  inner join evenements_ind n on n.ev_ind_kle_fiche=i.cle_fiche and n.ev_ind_type='BIRT'
  inner join evenements_ind d on d.ev_ind_kle_fiche=i.cle_fiche and d.ev_ind_type='DEAT'
  where i.kle_dossier=:a_cle_dossier
  and i.sexe>0
  and n.ev_ind_datecode is not null
  and d.ev_ind_datecode is not null
  and (:limit_on_sosa=0 or num_sosa>0)
  and (:limit_on_date=0 or i.annee_deces between :year_from and :year_to)
  order by i.annee_deces
  into :age
      ,:annee_deces
      ,:sexe
  do
  begin
    if (ok_suspend=0) then --c'est le premier enregistrement
    begin
      --initialisation des intervals et autorisation dernier suspend
      interval_start=annee_deces-mod(annee_deces,interval);
      interval_end=interval_start+interval-1;
      nb_homme=0;
      cumul_age_homme=0;
      cumul_carre_homme=0;
      nb_femme=0;
      cumul_age_femme=0;
      cumul_carre_femme=0;
      ok_suspend=1;
    end
    else
    begin
      if (annee_deces>interval_end) then --l'année est dans un interval suivant
      begin
        --on expédie le record
        if (nb_homme>0) then
        begin
          moyenne_age_homme=cumul_age_homme/nb_homme;
          ecart_type_age_homme=cumul_carre_homme/nb_homme-moyenne_age_homme*moyenne_age_homme;
          if (ecart_type_age_homme>0) then
            ecart_type_age_homme=sqrt(ecart_type_age_homme);
          else
            ecart_type_age_homme=0;
        end
        else
        begin
          moyenne_age_homme=0;
          ecart_type_age_homme=0;
        end
        if (nb_femme>0) then
        begin
          moyenne_age_femme=cumul_age_femme/nb_femme;
          ecart_type_age_femme=cumul_carre_femme/nb_femme-moyenne_age_femme*moyenne_age_femme;
          if (ecart_type_age_femme>0) then
            ecart_type_age_femme=sqrt(ecart_type_age_femme);
          else
            ecart_type_age_femme=0;
        end
        else
        begin
          moyenne_age_femme=0;
          ecart_type_age_femme=0;
        end
        suspend;
        --changement d'interval
        while (annee_deces>interval_end) do
        begin
          --initialisation du suspend
          interval_start=interval_start+interval;
          interval_end=interval_start+interval-1;
          nb_homme=0;
          cumul_age_homme=0;
          cumul_carre_homme=0;
          nb_femme=0;
          cumul_age_femme=0;
          cumul_carre_femme=0;
          --si l'année est encore après, on édite
          if (annee_deces>interval_end) then
          begin
            moyenne_age_homme=0;
            moyenne_age_femme=0;
            ecart_type_age_homme=0;
            ecart_type_age_femme=0;
            suspend;
          end
        end
      end
    end
    if (sexe=1) then
    begin
      nb_homme=nb_homme+1;
      cumul_age_homme=cumul_age_homme+age;
      cumul_carre_homme=cumul_carre_homme+age*age;
    end
    else
    begin
      nb_femme=nb_femme+1;
      cumul_age_femme=cumul_age_femme+age;
      cumul_carre_femme=cumul_carre_femme+age*age;
    end
  end
  if (ok_suspend=1) then
  begin
    if (nb_homme>0) then
    begin
      moyenne_age_homme=cumul_age_homme/nb_homme;
      ecart_type_age_homme=cumul_carre_homme/nb_homme-moyenne_age_homme*moyenne_age_homme;
      if (ecart_type_age_homme>0) then
        ecart_type_age_homme=sqrt(ecart_type_age_homme);
      else
        ecart_type_age_homme=0;
    end
    else
    begin
      moyenne_age_homme=0;
      ecart_type_age_homme=0;
    end
    if (nb_femme>0) then
    begin
      moyenne_age_femme=cumul_age_femme/nb_femme;
      ecart_type_age_femme=cumul_carre_femme/nb_femme-moyenne_age_femme*moyenne_age_femme;
      if (ecart_type_age_femme>0) then
        ecart_type_age_femme=sqrt(ecart_type_age_femme);
      else
        ecart_type_age_femme=0;
    end
    else
    begin
      moyenne_age_femme=0;
      ecart_type_age_femme=0;
    end
    suspend;
  end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure refaite par André Langlet le 02/08/2009
pour correction erreurs et optimisation.
Refonte le 10/03/2012: calcul des âges plus précis, calcul direct de la moyenne
et de l''écart-type.'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_LONGEVITE';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_NB_ENFANT_UNION (
    A_CLE_DOSSIER Integer,
    LIMIT_ON_DATE Integer,
    LIMIT_ON_SOSA Integer,
    YEAR_FROM Integer,
    YEAR_TO Integer,
    INTERVAL Integer )
RETURNS (
    INTERVAL_START Integer,
    INTERVAL_END Integer,
    NB_UNION Integer,
    NB_ENFANTS Integer )
AS
declare variable ok_suspend integer;
declare variable nombre_enfants integer;
declare variable annee_union integer;
begin
  ok_suspend=0;
  for
    select nombre_enfants
    ,annee_union
    from (select nombre_enfants
          ,iif(prem_enf is null,prem_eve,iif(prem_eve is null,prem_enf,minvalue(prem_enf,prem_eve)))as annee_union
          from (select q.nombre_enfants
                ,(select min(annee_naissance)
                  from individu 
                  where cle_pere is not distinct from q.union_mari
                    and cle_mere is not distinct from q.union_femme)as prem_enf
                ,(select min(ev_fam_date_year)
                  from evenements_fam
                  where ev_fam_kle_famille=q.union_clef)as prem_eve
                from (select count(*) as nombre_enfants
                      ,u.union_clef
                      ,u.union_mari
                      ,u.union_femme
                      from individu i
                      inner join t_union u on u.union_mari is not distinct from i.cle_pere
                        and u.union_femme is not distinct from i.cle_mere
                      where i.kle_dossier=:a_cle_dossier
                        and (:limit_on_sosa=0 or i.num_sosa>0)
                      group by u.union_clef,u.union_mari, u.union_femme) as q))
    where annee_union is not null
    and (:limit_on_date=0 or annee_union between :year_from and :year_to)
    order by annee_union
  into :nombre_enfants
      ,:annee_union
  do
  begin
    if (ok_suspend=0) then --c'est le premier enregistrement
    begin
      --initialisation des intervals et autorisation dernier suspend
      interval_start=annee_union-mod(annee_union,interval);
      interval_end=interval_start+interval-1;
      nb_union=1;
      nb_enfants=nombre_enfants;
      ok_suspend=1;
    end
    else
      if (annee_union>interval_end) then --l'année est dans un interval suivant
      begin
        --on expédie le record
        suspend;
        --changement d'interval
        while (annee_union>interval_end) do
        begin
          --initialisation du suspend
          interval_start=interval_start+interval;
          interval_end=interval_start+interval-1;
          nb_union=0;
          nb_enfants=0;
          --si l'année est encore après, on édite
          if (annee_union>interval_end) then
            suspend;
        end
        nb_union=1;
        nb_enfants=nombre_enfants;
      end
      else
      begin
        nb_union=nb_union+1;
        nb_enfants=nb_enfants+nombre_enfants;
      end
  end
  if (ok_suspend=1) then
    suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure refaite par André Langlet le 08/08/2009
pour correction erreurs et optimisation'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_NB_ENFANT_UNION';

SET TERM ^ ;
ALTER PROCEDURE PROC_ETAT_RECENSEMENT (
    A_CLE_DOSSIER Integer,
    LIMIT_ON_DATE Integer,
    LIMIT_ON_SOSA Integer,
    YEAR_FROM Integer,
    YEAR_TO Integer,
    INTERVAL Integer,
    LONGEVITE_H Integer,
    LONGEVITE_F Integer )
RETURNS (
    ANNEE Integer,
    NOMBRE_INDIVIDUS Integer )
AS
declare variable prem_date integer;
declare variable dern_date integer;
declare variable i integer;
declare variable an_actuel integer;
declare variable reste integer;
begin
  delete from tq_id;
  if (not interval>0) then
    interval=1;
  an_actuel=extract(year from cast('now' as date));
  for select prem_date
            ,iif(decede=1 or prem_date<:an_actuel-iif(sexe=1,:longevite_h,iif(sexe=2,:longevite_f,0))
                ,dern_date,:an_actuel)
    from(select decede
        ,sexe
        ,minvalue(ev_ind_min,ev_fam_min,enf_min) as prem_date
        ,maxvalue(ev_ind_max,ev_fam_max,enf_max) as dern_date
        from (select i.decede
              ,i.sexe
              ,coalesce(min(e.ev_ind_date_year),9000) as ev_ind_min
              ,coalesce(max(e.ev_ind_date_year),-9000) as ev_ind_max
              ,coalesce(min(f.ev_fam_date_year),9000) as ev_fam_min
              ,coalesce(max(f.ev_fam_date_year),-9000) as ev_fam_max
              ,coalesce(min(p.annee_naissance),9000) as enf_min
              ,coalesce(max(p.annee_naissance),-9000) as enf_max
              from individu i
              left join evenements_ind e on e.ev_ind_kle_fiche=i.cle_fiche
                                and e.ev_ind_date_year is not null
              left join t_union u on i.cle_fiche in (u.union_mari,u.union_femme)
              left join evenements_fam f on f.ev_fam_kle_famille=u.union_clef
                                and f.ev_fam_date_year is not null
              left join individu p on i.cle_fiche in (p.cle_pere,p.cle_mere)
              where i.kle_dossier=:a_cle_dossier
                and (:limit_on_sosa=0 or i.num_sosa>0)
              group by i.cle_fiche,i.decede,i.sexe))
    where prem_date<>9000
    and (:limit_on_date=0 or (dern_date>:year_from and prem_date<:year_to))
  into :prem_date
      ,:dern_date
  do
  begin
    if (limit_on_date=1) then
    begin
      if (prem_date<year_from) then
        prem_date=year_from;
      if (dern_date>year_to) then
        dern_date=year_to;
    end
    i=prem_date;
    reste=mod(i,interval);
    if (reste>0) then
      i=i-reste+interval;
    while (i<=dern_date) do
    begin
      update tq_id
        set id2=id2+1
        where id1=:i;
      if (row_count=0) then
        insert into tq_id (id1,id2)
          values(:i,1);
      i=i+interval;
    end
  end
  for select id1,id2
    from tq_id
    order by id1
  into :annee
      ,:nombre_individus
  do
    suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure refaite par André Langlet le 10/08/2009
Précédente version incohérente!'
  where RDB$PROCEDURE_NAME = 'PROC_ETAT_RECENSEMENT';

SET TERM ^ ;
ALTER PROCEDURE PROC_EVE_IND (
    I_CLE Integer )
RETURNS (
    EV_IND_CLEF Integer,
    EV_IND_KLE_FICHE Integer,
    EV_IND_KLE_DOSSIER Integer,
    EV_IND_TYPE Varchar(7),
    EV_IND_DATE_WRITEN Varchar(100),
    EV_IND_DATE_YEAR Integer,
    EV_IND_DATE Date,
    EV_IND_ADRESSE Varchar(50),
    EV_IND_CP Varchar(10),
    EV_IND_VILLE Varchar(50),
    EV_IND_DEPT Varchar(30),
    EV_IND_PAYS Varchar(30),
    EV_IND_CAUSE Varchar(90),
    EV_IND_SOURCE Blob sub_type 1,
    EV_IND_COMMENT Blob sub_type 1,
    EV_IND_TYPEANNEE Integer,
    EV_IND_DESCRIPTION Varchar(90),
    EV_IND_REGION Varchar(50),
    EV_IND_SUBD Varchar(50),
    EV_LIBELLE Varchar(30),
    EV_IND_ACTE Integer,
    EV_IND_INSEE Varchar(6),
    EV_IND_HEURE Time,
    EV_IND_ORDRE Integer,
    EV_IND_TITRE_EVENT Varchar(40),
    EV_IND_LATITUDE Decimal(15,8),
    EV_IND_LONGITUDE Numeric(15,8),
    EV_IND_MEDIA Integer,
    EV_IND_AGE Integer,
    EV_IND_DETAILS Integer )
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:10:10
   Modifications par André, ajout eve.EV_IND_DATE, eve.EV_IND_TYPE dans order by
   et EV_LIBELLE dépendant du type EVEN. Ajout MOIS,latitude, longitude, TITRE='Divers'
   EV_IND_MEDIA, EV_IND_AGE, EV_IND_DETAILS
   Dernière modification: 07/03/2012
   Usage       :
   ---------------------------------------------------------------------------*/
  for
    select e.ev_ind_clef
          ,e.ev_ind_kle_fiche
          ,e.ev_ind_kle_dossier
          ,e.ev_ind_type
          ,e.ev_ind_date_writen
          ,e.ev_ind_date_year
          ,e.ev_ind_date
          ,e.ev_ind_adresse
          ,e.ev_ind_cp
          ,e.ev_ind_ville
          ,e.ev_ind_dept
          ,e.ev_ind_pays
          ,e.ev_ind_cause
          ,e.ev_ind_source
          ,e.ev_ind_comment
          ,e.ev_ind_typeannee
          ,e.ev_ind_description
          ,e.ev_ind_region
          ,e.ev_ind_subd
          ,case e.ev_ind_type
                when 'EVEN' then coalesce(e.ev_ind_titre_event,r.ref_eve_lib_long)
                else r.ref_eve_lib_long
                end
          ,e.ev_ind_acte
          ,e.ev_ind_insee
          ,e.ev_ind_heure
          ,e.ev_ind_ordre
          ,case e.ev_ind_type
                when 'EVEN' then coalesce(e.ev_ind_titre_event,r.ref_eve_lib_long)
                else e.ev_ind_titre_event
                end
          ,e.ev_ind_latitude
          ,e.ev_ind_longitude
          ,(select first(1) p.mp_media from media_pointeurs p
            where p.mp_pointe_sur=e.ev_ind_clef
            and p.mp_table='I'
            and p.mp_type_image='A')
          ,case e.ev_ind_type
                when 'BIRT' then 0
                else coalesce(e.ev_ind_datecode-(select ev_ind_datecode
                     from evenements_ind where ev_ind_kle_fiche=i.cle_fiche
                        and ev_ind_type='BIRT'),0)
                end
          ,(select 1 from rdb$database
            where exists (select *
                          from sources_record s
                          left join media_pointeurs p on p.mp_table='F'
                                                     and p.mp_type_image='F'
                                                     and p.mp_pointe_sur=s.id
                          where s.type_table='I'
                            and s.data_id=e.ev_ind_clef
                            and (char_length(s.auth)>0
                                 or char_length(s.titl)>0
                                 or char_length(s.abr)>0
                                 or char_length(s.publ)>0
                                 or char_length(s.texte)>0
                                 or p.mp_media is not null)))
       from individu i
       inner join dossier ds on ds.cle_dossier=i.kle_dossier
       inner join evenements_ind e on e.ev_ind_kle_fiche=i.cle_fiche
       inner join ref_evenements r on r.ref_eve_lib_court = e.ev_ind_type
        and r.ref_eve_langue=ds.ds_langue
       where  i.cle_fiche = :i_cle
       order by e.ev_ind_ordre nulls last
               ,e.ev_ind_datecode nulls last
               ,e.ev_ind_type
    into :ev_ind_clef
        ,:ev_ind_kle_fiche
        ,:ev_ind_kle_dossier
        ,:ev_ind_type
        ,:ev_ind_date_writen
        ,:ev_ind_date_year
        ,:ev_ind_date
        ,:ev_ind_adresse
        ,:ev_ind_cp
        ,:ev_ind_ville
        ,:ev_ind_dept
        ,:ev_ind_pays
        ,:ev_ind_cause
        ,:ev_ind_source
        ,:ev_ind_comment
        ,:ev_ind_typeannee
        ,:ev_ind_description
        ,:ev_ind_region
        ,:ev_ind_subd
        ,:ev_libelle
        ,:ev_ind_acte
        ,:ev_ind_insee
        ,:ev_ind_heure
        ,:ev_ind_ordre
        ,:ev_ind_titre_event
        ,:ev_ind_latitude
        ,:ev_ind_longitude
        ,:ev_ind_media
        ,:ev_ind_age
        ,:ev_ind_details
  do
    suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure recréée uniquement pour rester compatible avec la dll Arbres.dll.
A supprimer dès que possible'
  where RDB$PROCEDURE_NAME = 'PROC_EVE_IND';

SET TERM ^ ;
ALTER PROCEDURE PROC_EXPORT_IMAGES (
    I_DOSSIER Integer )
RETURNS (
    MULTI_CLEF Integer,
    NOM Varchar(105),
    MULTI_MEDIA Blob sub_type 0,
    FORMAT Varchar(4),
    MULTI_PATH Varchar(255) )
AS
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE J INTEGER;
DECLARE VARIABLE NOM_TEMP VARCHAR(110);
DECLARE VARIABLE CARACT CHAR(1);
BEGIN
  I = 1;
  for select m.multi_clef
           , m.multi_media
           , coalesce((select first (1)
              trim(substring(coalesce(lower((select s_out from f_maj_sans_accent(i.nom))),'sans nom')||
              coalesce(' '||lower((select s_out from f_maj_sans_accent(i.prenom))),'') from 1 for
              30-char_length(coalesce(' '||i.annee_naissance,''))))
              ||coalesce(' '||i.annee_naissance,'')
              from media_pointeurs mp
                  inner join individu i on i.cle_fiche=mp.mp_cle_individu
              where mp.mp_media=m.multi_clef)
             ,'non affecte')
              ||' '||:i
           ,case m.multi_image_rtf when 0 then 'jpg'
                                   when 2 then 'wav'
                                   when 3 then 'avi'
            end
           ,m.multi_path
      from multimedia m
      where m.multi_dossier=:i_dossier
      into :multi_clef
          ,:multi_media
          ,:nom_temp
          ,:format
          ,:multi_path
  do
  begin
    nom='';
    j=1;
    while (j<=char_length(nom_temp)) do
    begin
      caract=substring(nom_temp from j for 1);
      if ((caract>='a' and caract<='z') or (caract>='0' and caract<='9')) then
        nom=nom||caract;
      else
        if (caract in ('-',' ',' ','''','"','\','/','#','~')) then
          nom=nom||'_';
      j=j+1;
    end
    I=I+1;
    suspend;
  end
end
^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_GESTION_DLL
RETURNS (
    DOSSIER Integer,
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    OPEN_BASE Integer )
AS
BEGIN
  FOR
      SELECT indi.CLE_FICHE,
             indi.NOM,
             indi.PRENOM,
             dll.DLL_DOSSIER ,
             dll.dll_open_base
      FROM individu indi,
           gestion_dll dll
      WHERE indi.cle_fiche = dll.dll_indi 
    INTO
      :CLE_FICHE,
      :NOM,
      :PRENOM,
      :DOSSIER,
      :OPEN_BASE
  DO
  BEGIN
    SUSPEND;
  END
END^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_GET_CLEF_UNIQUE (
    A_TABLE Varchar(30) )
RETURNS (
    CLE_UNIQUE Integer )
AS
begin
cle_unique=case upper(a_table)
           when 'DOSSIER' then gen_id(gen_dossier,1)
           when 'EVENEMENTS_FAM' then gen_id(gen_ev_fam_clef,1)
           when 'EVENEMENTS_IND' then gen_id(gen_ev_ind_clef,1)
           when 'INDIVIDU' then gen_id(gen_individu,1)
           when 'MULTIMEDIA' then gen_id(gen_multimedia,1)
           when 'REF_EVENEMENTS' then gen_id(gen_ref_evenements,1)
           when 'REF_PREFIXES' then gen_id(gen_ref_prefixes,1)
           when 'REF_PARTICULES' then gen_id(gen_ref_particules,1)
           when 'REF_RACCOURCIS' then gen_id(gen_ref_raccourcis,1)
           when 'REF_RELA_TEMOINS' then gen_id(gen_ref_rela_clef,1)
           when 'T_UNION' then gen_id(gen_t_union,1)
           when 'T_ASSOCIATIONS' then gen_id(gen_assoc_clef,1)
           when 'FAVORIS' then gen_id(gen_favoris,1)
           when 'TOKEN_DATE' then gen_id(gen_token_date,1)
           when 'MEMO_INFOS' then gen_id(gen_memo_infos,1)
           when 'SOURCES_RECORD' then gen_id(sources_record_id_gen,1)
           when 'MEDIA_POINTEURS' then gen_id(biblio_pointeurs_id_gen,1)
           when 'T_IMPORT_GEDCOM' then gen_id(t_import_gedcom_ig_id_gen,1)
           else -1
  end;
suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Refonte par André Langlet, utilisation CASE, ajout T_IMPORT_GEDCOM
suppression PATRONYMES, HISTORIQUE et tables supprimées
Dernière modification: 31/08/2012 suppression tables de référence des lieux
Description : Donne une clef unique'
  where RDB$PROCEDURE_NAME = 'PROC_GET_CLEF_UNIQUE';

SET TERM ^ ;
ALTER PROCEDURE PROC_GROUPE (
    I_GROUPE Integer,
    I_INDIVIDU Integer,
    MODE Varchar(1),
    STRICTE Varchar(1),
    TEMOINS Varchar(1),
    INITIALISATION Varchar(1),
    EFFET Varchar(1),
    VERBOSE Varchar(1) )
RETURNS (
    INFO Varchar(50) )
AS
DECLARE VARIABLE I_DOSSIER INTEGER; /* nécessaire à suppression ou élagage */
DECLARE VARIABLE I_COUNT INTEGER; /* comptage du niveau */
DECLARE VARIABLE I INTEGER; /* niveau pour calcul */
DECLARE VARIABLE I_SEXE INTEGER; /* Sexe individu de départ */
DECLARE VARIABLE I_SX INTEGER; /* Sexe individu sélectionné */
DECLARE VARIABLE I_IND INTEGER; /* nouvel individu */
DECLARE VARIABLE I_INDIV INTEGER; /* individu sélectionné */
DECLARE VARIABLE I_S INTEGER; /* sexe nouvel individu */
BEGIN
/*Procédure créée par André le 15/02/2006. Dernière maj 28/10/2008
Syntaxe: SELECT * FROM PROC_GROUPE(I_GROUPE,I_INDIVIDU,MODE,STRICTE,TEMOINS,INITIALISATION,EFFET,VERBOSE);
Cette procédure permet de remplir la table temporaire TA_GROUPES avec des
groupes I_GROUPE d'individus liés avec l'individu I_INDIVIDU.
MODE = 'A' permet de sélectionner les Ascendants de I_INDIVIDU,
       'D' permet de sélectionner les Descendants de I_INDIVIDU,
       'B' permet de sélectionner l'ensemble de la Branche, I_INDIVIDU compris.
STRICTE = 'Y' ou 'N' (oui ou non)
STRICTE='Y' s'utilise avec MODE 'A' ou 'D' pour exclure de la liste l'individu et son
conjoint ainsi que, les ascendants et leurs conjoints si MODE='D', ou les
descendants et leurs conjoints si MODE='A'.
STRICTE='N' n'empêche pas le sélection, mais les individus qui auraient été éliminés
de la sélection avec STRICTE =Y' sont listés en fin de procédure.
TEMOINS= 'Y' sélectionne également les témoins (option très dangereuse),
        'N' ne les sélectionne pas.
INITIALISATION = 'Y' vide complètement la table TA_GROUPES avant de commencer,
                 'N' n'en supprime aucun enregistrement,
                 'P' en supprime les enregistrement du même groupe.
EFFET = 'A' Aucun individu n'est supprimé de la base
        'E' Elagage: les individus qui ne font pas partie du groupe sélectionné
        sont supprimés.
        'S' Suppression des individus du groupe sélectionné
Si I_INDIVIDU=0 seule l'action prévue par EFFET est exécutée.
VERBOSE = 'Y' Tous les messages sont émis
          'N' Seul le dernier message est émis.
ATTENTION : Quand un individu est sélectionné dans cette liste, ses parents
            (sauf l'individu de départ et son conjoint si MODE='A'), ses enfants
            (sauf l'individu de départ et son conjoint si MODE='D'), ses conjoints
            et témoins (si TEMOINS='Y') le sont également.
Dans la table TA_GROUPES:
    le NIP des individus sélectionnés figure dans TA_CLE_FICHE,
    le N° de groupe est dans TA_GROUPE,
    le sexe de l'individu est dans TA_SEXE,
    TA_NIVEAU n'est utilisé que pour des raisons techniques.*/
  EFFET=UPPER(EFFET);
  IF (EFFET NOT IN ('A','E','S')) THEN
    BEGIN
      INFO='EFFET '||EFFET||' inconnu';
      SUSPEND;
      EXIT;
    END
  VERBOSE=UPPER(VERBOSE);
  IF (VERBOSE <>'N') THEN
    VERBOSE='Y';
  IF (I_INDIVIDU>0) THEN /*faire analyse*/
  BEGIN
   MODE=UPPER(MODE);
   IF (MODE NOT IN('A','D','B')) THEN
    BEGIN
      INFO='MODE '||MODE||' inconnu';
      SUSPEND;
      EXIT;
    END
   TEMOINS=UPPER(TEMOINS);
   IF (TEMOINS NOT IN('N','Y')) THEN
    BEGIN
      INFO='TEMOINS '||TEMOINS||' inconnu';
      SUSPEND;
      EXIT;
    END
   INITIALISATION=UPPER(INITIALISATION);
   IF (INITIALISATION NOT IN('N','P','Y')) THEN
    BEGIN
      INFO='INITIALISATION '||INITIALISATION||' inconnu';
      SUSPEND;
      EXIT;
    END
   FOR SELECT 'I_INDIVIDU '||CAST(:I_INDIVIDU AS VARCHAR(20))||' inconnu' FROM INDIVIDU
        WHERE :I_INDIVIDU NOT IN (SELECT CLE_FICHE FROM INDIVIDU)
        INTO :INFO
    DO
      BEGIN
        SUSPEND;
        EXIT;
      END
   IF (TEMOINS='Y') THEN
    BEGIN
      DELETE FROM TQ_ID;
      FOR SELECT a.ASSOC_KLE_IND,a.ASSOC_KLE_ASSOCIE FROM T_ASSOCIATIONS a
          WHERE a.ASSOC_TABLE='I'
            AND a.ASSOC_KLE_IND>0
            AND a.ASSOC_KLE_ASSOCIE>0
            AND NOT exists (SELECT 1 FROM TQ_ID WHERE "ID1"=a.ASSOC_KLE_IND and "ID2"=a.ASSOC_KLE_ASSOCIE)
          INTO :I_IND,:I_INDIV
        DO
        BEGIN
          INSERT INTO tq_id ("ID1","ID2") VALUES(:I_IND,:I_INDIV);
          IF (I_IND<>I_INDIV) THEN
            INSERT INTO tq_id ("ID1","ID2") VALUES(:I_INDIV,:I_IND);
        END
      FOR SELECT a.ASSOC_KLE_ASSOCIE,u.UNION_MARI FROM T_ASSOCIATIONS a
               INNER JOIN evenements_fam e ON e.ev_fam_clef=a.ASSOC_EVENEMENT
               INNER JOIN T_UNION u ON u.UNION_CLEF=e.ev_fam_kle_famille
               WHERE a.assoc_table='U'
                 AND u.UNION_MARI>0
                 AND a.ASSOC_KLE_ASSOCIE>0
                 AND NOT exists (SELECT 1 FROM tq_id WHERE "ID1"=u.UNION_MARI and "ID2"=a.ASSOC_KLE_ASSOCIE)
               INTO :i_ind,:i_indiv
        DO
        BEGIN
          INSERT INTO tq_id ("ID1","ID2") VALUES(:I_IND,:I_INDIV);
          IF (I_IND<>I_INDIV) THEN
            INSERT INTO tq_id ("ID1","ID2") VALUES(:I_INDIV,:I_IND);
        END
      FOR SELECT a.ASSOC_KLE_ASSOCIE,u.UNION_FEMME FROM T_ASSOCIATIONS a
               INNER JOIN evenements_fam e ON e.ev_fam_clef=a.ASSOC_EVENEMENT
               INNER JOIN T_UNION u ON u.UNION_CLEF=e.ev_fam_kle_famille
               WHERE a.assoc_table='U'
                 AND u.UNION_FEMME>0
                 AND a.ASSOC_KLE_ASSOCIE>0
                 AND NOT exists (SELECT 1 FROM tq_id WHERE "ID1"=u.UNION_FEMME and "ID2"=a.ASSOC_KLE_ASSOCIE)
               INTO :i_ind,:i_indiv
        DO
        BEGIN
          INSERT INTO tq_id ("ID1","ID2") VALUES(:I_IND,:I_INDIV);
          IF (I_IND<>I_INDIV) THEN
            INSERT INTO tq_id ("ID1","ID2") VALUES(:I_INDIV,:I_IND);
        END
     END
   SELECT SEXE FROM INDIVIDU WHERE CLE_FICHE=:I_INDIVIDU INTO :I_SEXE;
   DELETE FROM T_DOUBLONS;   /*contiendra la liste des exclusions*/
   IF (MODE='A' OR MODE='D') THEN
    BEGIN
      STRICTE=UPPER(STRICTE);
      IF (STRICTE NOT IN('Y','N')) THEN
        BEGIN
          INFO='STRICTE '||STRICTE||' inconnu';
          SUSPEND;
          EXIT;
        END
      IF (STRICTE='Y') THEN  /* remplir la liste des exclus*/
        BEGIN
          IF (MODE='A') THEN  /*descendants de l'individu et de ses conjoints*/
            BEGIN
              FOR SELECT TQ_CLE_FICHE FROM PROC_TQ_DESCENDANCE(:I_INDIVIDU,0,0,0) INTO :I_INDIV
                DO INSERT INTO T_DOUBLONS (CLE_FICHE)  VALUES(:I_INDIV);
              FOR SELECT UNION_MARI FROM T_UNION WHERE :I_SEXE=2 AND UNION_FEMME=:I_INDIVIDU
                                                      AND UNION_MARI>0
                  UNION
                  SELECT UNION_FEMME FROM T_UNION WHERE :I_SEXE=1 AND UNION_MARI=:I_INDIVIDU
                                                      AND UNION_FEMME>0
                INTO :I_INDIV
                DO
                  BEGIN
                    FOR SELECT  p.TQ_CLE_FICHE FROM PROC_TQ_DESCENDANCE(:I_INDIV,0,0,0) p
                        WHERE NOT exists (SELECT 1 FROM T_DOUBLONS where CLE_FICHE=p.TQ_CLE_FICHE)
                        INTO :I_IND
                      DO INSERT INTO T_DOUBLONS (CLE_FICHE)  VALUES(:I_IND);
                  END
            END
          IF (MODE='D') THEN  /*ascendants de l'individu et de ses conjoints*/
            BEGIN
              FOR SELECT TQ_CLE_FICHE FROM PROC_TQ_ASCENDANCE(:I_INDIVIDU,0,0,0) INTO :I_INDIV
                DO INSERT INTO T_DOUBLONS (CLE_FICHE)  VALUES(:I_INDIV);
              FOR SELECT UNION_MARI FROM T_UNION WHERE :I_SEXE=2 AND UNION_FEMME=:I_INDIVIDU
                                                      AND UNION_MARI>0
                  UNION
                  SELECT UNION_FEMME FROM T_UNION WHERE :I_SEXE=1 AND UNION_MARI=:I_INDIVIDU
                                                      AND UNION_FEMME>0
                INTO :I_INDIV
                DO
                  BEGIN
                    FOR SELECT  p.TQ_CLE_FICHE FROM PROC_TQ_ASCENDANCE(:I_INDIV,0,0,0) p
                        WHERE NOT exists (SELECT 1 FROM T_DOUBLONS where CLE_FICHE=p.TQ_CLE_FICHE)
                        INTO :I_IND
                      DO INSERT INTO T_DOUBLONS (CLE_FICHE)  VALUES(:I_IND);
                  END
            END
          /* ajout des conjoints à la liste*/
          FOR SELECT u.UNION_MARI FROM T_UNION u
              inner join T_DOUBLONS t on t.CLE_FICHE=u.UNION_FEMME
                         WHERE u.UNION_MARI>0
                           AND NOT exists (SELECT 1 FROM T_DOUBLONS where CLE_FICHE=u.UNION_MARI)
              UNION
              SELECT u.UNION_FEMME FROM T_UNION u
              inner join T_DOUBLONS t on t.CLE_FICHE=u.UNION_MARI
                         WHERE u.UNION_FEMME>0
                           AND NOT exists (SELECT 1 FROM T_DOUBLONS where CLE_FICHE=u.UNION_FEMME)
              INTO :I_INDIV
              DO INSERT INTO T_DOUBLONS (CLE_FICHE)  VALUES(:I_IND);
        END
    END
   IF (INITIALISATION='P') THEN DELETE FROM TA_GROUPES WHERE TA_GROUPE=:I_GROUPE;
    ELSE IF (INITIALISATION='Y') THEN DELETE FROM TA_GROUPES;
   UPDATE TA_GROUPES SET TA_NIVEAU=NULL;
   IF (MODE='B') THEN   /*mise de l'individu en tête de la sélection*/
    BEGIN
      I=0;
      INSERT INTO TA_GROUPES (TA_NIVEAU,TA_CLE_FICHE,TA_GROUPE,TA_SEXE)
             VALUES(:I,:I_INDIVIDU,:I_GROUPE,:I_SEXE);
    END
   IF (MODE='D') THEN   /*mise des enfants de l'individu en tête de la sélection*/
    BEGIN
      I=0;
      FOR SELECT CLE_FICHE,SEXE FROM INDIVIDU
                WHERE (:I_SEXE=1 AND CLE_PERE=:I_INDIVIDU)
                   OR (:I_SEXE=2 AND CLE_MERE=:I_INDIVIDU)
                INTO :I_IND,:I_S
        DO INSERT INTO TA_GROUPES (TA_NIVEAU,TA_CLE_FICHE,TA_GROUPE,TA_SEXE)
                          VALUES(:I,:I_IND,:I_GROUPE,:I_S);
    END
   IF (MODE='A') THEN   /*mise des parents de l'individu en tête de la sélection*/
    BEGIN
      I=0;
      FOR SELECT CLE_PERE,1 FROM INDIVIDU
           WHERE CLE_FICHE=:I_INDIVIDU AND CLE_PERE IS NOT NULL
          UNION
          SELECT CLE_MERE,2 FROM INDIVIDU
           WHERE CLE_FICHE=:I_INDIVIDU AND CLE_MERE IS NOT NULL
           INTO :I_IND,:I_S
        DO INSERT INTO TA_GROUPES (TA_NIVEAU,TA_CLE_FICHE,TA_GROUPE,TA_SEXE)
                          VALUES(:I,:I_IND,:I_GROUPE,:I_S);
    END
   SELECT COUNT(*) FROM TA_GROUPES WHERE TA_NIVEAU=:I INTO :I_COUNT;
   WHILE (I_COUNT>0) DO
    BEGIN  /*pour chaque niveau I*/
      /*pour chaque individu de la sélection*/
      FOR SELECT TA_CLE_FICHE,TA_SEXE FROM TA_GROUPES
          WHERE TA_NIVEAU=:I
          INTO :I_INDIV,:I_SX
        DO BEGIN
          IF (MODE<>'A' OR I>0) THEN
            /*ajout des enfants au niveau I+1*/
            IF (:I_SX=1) THEN
              FOR SELECT i.CLE_FICHE,i.SEXE FROM INDIVIDU i
                 WHERE i.CLE_PERE=:I_INDIV
                 AND NOT exists (SELECT 1 FROM TA_GROUPES
                                 WHERE TA_NIVEAU IS NOT NULL and ta_cle_fiche=i.CLE_FICHE)
                 AND NOT exists (SELECT 1 FROM T_DOUBLONS where CLE_FICHE=i.CLE_FICHE)
                 INTO :I_IND,:I_S
              DO INSERT INTO TA_GROUPES (TA_NIVEAU,TA_CLE_FICHE,TA_GROUPE,TA_SEXE)
                          VALUES(:I+1,:I_IND,:I_GROUPE,:I_S);
            ELSE
              FOR SELECT i.CLE_FICHE,i.SEXE FROM INDIVIDU i
                 WHERE i.CLE_MERE=:I_INDIV
                 AND NOT exists (SELECT 1 FROM TA_GROUPES
                                 WHERE TA_NIVEAU IS NOT NULL and ta_cle_fiche=i.CLE_FICHE)
                 AND NOT exists (SELECT 1 FROM T_DOUBLONS where CLE_FICHE=i.CLE_FICHE)
                 INTO :I_IND,:I_S
              DO INSERT INTO TA_GROUPES (TA_NIVEAU,TA_CLE_FICHE,TA_GROUPE,TA_SEXE)
                          VALUES(:I+1,:I_IND,:I_GROUPE,:I_S);
          IF (MODE<>'D' OR I>0) THEN
            BEGIN /*ajout des parents au niveau I+1*/
              FOR SELECT i.CLE_PERE,1 FROM INDIVIDU i
                WHERE i.CLE_FICHE=:I_INDIV AND i.CLE_PERE >0
                 AND NOT exists (SELECT 1 FROM TA_GROUPES
                                 WHERE TA_NIVEAU IS NOT NULL and ta_cle_fiche=i.CLE_PERE)
                 AND NOT exists (SELECT 1 FROM T_DOUBLONS where CLE_FICHE=i.CLE_PERE)
                UNION
                SELECT i.CLE_MERE,2 FROM INDIVIDU i
                WHERE i.CLE_FICHE=:I_INDIV AND i.CLE_MERE >0
                 AND NOT exists (SELECT 1 FROM TA_GROUPES
                                 WHERE TA_NIVEAU IS NOT NULL and ta_cle_fiche=i.CLE_MERE)
                 AND NOT exists (SELECT 1 FROM T_DOUBLONS where CLE_FICHE=i.CLE_MERE)
                INTO :I_IND,:I_S
              DO INSERT INTO TA_GROUPES (TA_NIVEAU,TA_CLE_FICHE,TA_GROUPE,TA_SEXE)
                          VALUES(:I+1,:I_IND,:I_GROUPE,:I_S);
            END
          IF (TEMOINS='Y') THEN  /*ajout des témoins au niveau I+1*/
              FOR SELECT a."ID2",i.SEXE FROM TQ_ID a
                        INNER JOIN INDIVIDU i ON i.CLE_FICHE=a."ID2"
                  WHERE a."ID1"=:I_INDIV
                       AND NOT exists (SELECT 1 FROM TA_GROUPES
                                             WHERE TA_NIVEAU IS NOT NULL and ta_cle_fiche=a."ID2")
                       AND NOT exists (SELECT 1 FROM T_DOUBLONS where cle_fiche=a."ID2")
                 INTO :I_IND,:I_S
                 DO INSERT INTO TA_GROUPES (TA_NIVEAU,TA_CLE_FICHE,TA_GROUPE,TA_SEXE)
                          VALUES(:I+1,:I_IND,:I_GROUPE,:I_S);
          IF (I_SX=1) THEN /*ajout des conjoints*/
            FOR SELECT UNION_FEMME,2 FROM T_UNION u
            WHERE u.UNION_MARI=:I_INDIV AND u.UNION_FEMME>0
              AND NOT exists (SELECT 1 FROM TA_GROUPES
                                             WHERE TA_NIVEAU IS NOT NULL and ta_cle_fiche=u.UNION_FEMME)
              AND NOT exists (SELECT 1 FROM T_DOUBLONS where cle_fiche=u.UNION_FEMME)
                INTO :I_IND,:I_S
              DO INSERT INTO TA_GROUPES (TA_NIVEAU,TA_CLE_FICHE,TA_GROUPE,TA_SEXE)
                          VALUES(:I+1,:I_IND,:I_GROUPE,:I_S);
          ELSE
            FOR SELECT u.UNION_MARI,1 FROM T_UNION u
            WHERE u.UNION_FEMME=:I_INDIV AND u.UNION_MARI>0
              AND NOT exists (SELECT 1 FROM TA_GROUPES
                                             WHERE TA_NIVEAU IS NOT NULL and ta_cle_fiche=u.UNION_MARI)
              AND NOT exists (SELECT 1 FROM T_DOUBLONS where cle_fiche=u.UNION_MARI)
                INTO :I_IND,:I_S
              DO INSERT INTO TA_GROUPES (TA_NIVEAU,TA_CLE_FICHE,TA_GROUPE,TA_SEXE)
                          VALUES(:I+1,:I_IND,:I_GROUPE,:I_S);
        END
      I=I+1;
      SELECT COUNT(*) FROM TA_GROUPES WHERE TA_NIVEAU=:I INTO :I_COUNT;
    END
   DELETE FROM TQ_ID;
   DELETE FROM T_DOUBLONS;
   SELECT CAST(COUNT(*) AS VARCHAR(20))||' individus selectionnes' FROM TA_GROUPES
      WHERE TA_NIVEAU IS NOT NULL
      INTO :INFO;
   IF (VERBOSE='Y') THEN SUSPEND;
   SELECT CAST(COUNT(DISTINCT TA_CLE_FICHE) AS VARCHAR(20))||' individus dans le groupe' FROM TA_GROUPES
      WHERE TA_GROUPE=:I_GROUPE
      INTO :INFO;
   IF (VERBOSE='Y') THEN SUSPEND;
   IF (MODE='D' AND STRICTE='N') THEN
    BEGIN
      FOR SELECT 'erreur '||CAST(t.TA_CLE_FICHE AS VARCHAR(20))||' dans l''ascendance'
          FROM PROC_TQ_ASCENDANCE(:I_INDIVIDU,0,0,0) a
               INNER JOIN TA_GROUPES t ON t.TA_CLE_FICHE=a.TQ_CLE_FICHE
                INTO :INFO
        DO IF (VERBOSE='Y') THEN SUSPEND;
      FOR SELECT UNION_MARI FROM T_UNION WHERE :I_SEXE=2 AND UNION_FEMME=:I_INDIVIDU
                                                      AND UNION_MARI>0
          UNION
          SELECT UNION_FEMME FROM T_UNION WHERE :I_SEXE=1 AND UNION_MARI=:I_INDIVIDU
                                                      AND UNION_FEMME>0
          INTO :I_INDIV
        DO
        BEGIN
          FOR SELECT 'erreur '||CAST(t.TA_CLE_FICHE AS VARCHAR(20))||' dans l''ascendance'
              FROM PROC_TQ_ASCENDANCE(:I_INDIV,0,0,0) a
                   INNER JOIN TA_GROUPES t ON t.TA_CLE_FICHE=a.TQ_CLE_FICHE
                INTO :INFO
          DO IF (VERBOSE='Y') THEN SUSPEND;
        END
    END
   IF (MODE='A' AND STRICTE='N') THEN
    BEGIN
      FOR SELECT 'erreur '||CAST(t.TA_CLE_FICHE AS VARCHAR(20))||' dans la descendance'
          FROM PROC_TQ_DESCENDANCE(:I_INDIVIDU,0,0,0) a
               INNER JOIN TA_GROUPES t ON t.TA_CLE_FICHE=a.TQ_CLE_FICHE
                INTO :INFO
        DO IF (VERBOSE='Y') THEN SUSPEND;
      FOR SELECT UNION_MARI FROM T_UNION WHERE :I_SEXE=2 AND UNION_FEMME=:I_INDIVIDU
                                                      AND UNION_MARI>0
          UNION
          SELECT UNION_FEMME FROM T_UNION WHERE :I_SEXE=1 AND UNION_MARI=:I_INDIVIDU
                                                      AND UNION_FEMME>0
          INTO :I_INDIV
        DO
        BEGIN
          FOR SELECT 'erreur '||CAST(t.TA_CLE_FICHE AS VARCHAR(20))||' dans la descendance'
              FROM PROC_TQ_DESCENDANCE(:I_INDIV,0,0,0) a
                  INNER JOIN TA_GROUPES t ON t.TA_CLE_FICHE=a.TQ_CLE_FICHE
                INTO :INFO
          DO IF (VERBOSE='Y') THEN SUSPEND;
        END
    END
  END /*Fin de I_INDIVIDU>0, action faite */
  IF (EFFET='A') THEN
    BEGIN
      DELETE FROM T_DOUBLONS;
      IF (I_INDIVIDU=0) THEN
        BEGIN
          INFO='Rien à faire';
          SUSPEND;
        END
      ELSE IF (VERBOSE='N') THEN SUSPEND;
      EXIT;
    END
  SELECT COUNT(DISTINCT i.KLE_DOSSIER) FROM TA_GROUPES t
         INNER JOIN INDIVIDU i ON i.CLE_FICHE=t.TA_CLE_FICHE
         WHERE t.TA_GROUPE=:I_GROUPE
         INTO :I_COUNT;
  IF (I_COUNT>1) THEN
    BEGIN
      INFO='Plusieurs dossiers dans le groupe';
      SUSPEND;
      EXIT;
    END
  SELECT COUNT(TA_CLE_FICHE) FROM TA_GROUPES
         WHERE TA_GROUPE=:I_GROUPE
         INTO :I_COUNT;
  IF (I_COUNT=0) THEN
    BEGIN
      INFO='Pas d''individu dans la sélection';
      SUSPEND;
      EXIT;
    END
  SELECT DISTINCT i.KLE_DOSSIER FROM TA_GROUPES t
         INNER JOIN INDIVIDU i ON i.CLE_FICHE=t.TA_CLE_FICHE
         WHERE t.TA_GROUPE=:I_GROUPE
         INTO :I_DOSSIER;
  DELETE FROM T_DOUBLONS;
  IF (EFFET='S') THEN
    FOR SELECT DISTINCT TA_CLE_FICHE FROM TA_GROUPES
          WHERE TA_GROUPE=:I_GROUPE
        INTO :I_IND
        DO INSERT INTO T_DOUBLONS (CLE_FICHE)  VALUES(:I_IND);
  ELSE /* EFFET='E' */
    FOR SELECT CLE_FICHE FROM INDIVIDU
        WHERE KLE_DOSSIER=:I_DOSSIER
          AND CLE_FICHE NOT IN (SELECT TA_CLE_FICHE FROM TA_GROUPES
          WHERE TA_GROUPE=:I_GROUPE)
        INTO :I_IND
        DO INSERT INTO T_DOUBLONS (CLE_FICHE)  VALUES(:I_IND);
  SELECT CAST(COUNT(CLE_FICHE) AS VARCHAR(20))||' individus supprimés' FROM T_DOUBLONS
      INTO :INFO;
  DELETE FROM INDIVIDU WHERE CLE_FICHE IN (SELECT CLE_FICHE FROM T_DOUBLONS);
  DELETE FROM T_UNION WHERE UNION_MARI IS NULL AND UNION_FEMME IS NULL;
  DELETE FROM T_UNION t WHERE (t.UNION_MARI IS NULL AND NOT EXISTS (SELECT 1 FROM INDIVIDU
                               WHERE CLE_MERE=t.UNION_FEMME))
                           OR (t.UNION_FEMME IS NULL AND NOT EXISTS (SELECT 1 FROM INDIVIDU
                               WHERE CLE_PERE=t.UNION_MARI));
  DELETE FROM EVENEMENTS_FAM WHERE EV_FAM_KLE_FAMILLE IN
        (SELECT UNION_CLEF FROM T_UNION
               WHERE UNION_MARI IS NULL OR UNION_FEMME IS NULL);
  DELETE FROM MEDIA_POINTEURS WHERE MP_CLE_INDIVIDU NOT IN (SELECT CLE_FICHE FROM INDIVIDU);
  DELETE FROM T_DOUBLONS;
  SUSPEND;
END^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_INCOHERENCES (
    I_KLE_DOSSIER Integer,
    I_MODE Integer )
RETURNS (
    O_TABLE Varchar(30),
    O_CLE_TABLE Integer,
    O_CLE_FICHE Integer,
    O_LIBELLE Varchar(160) )
AS
declare variable conjoint integer;
declare variable i_count integer;
declare variable pere integer;
declare variable mere integer;
declare variable sexe integer;
declare variable dossier integer;
begin
   /*---------------------------------------------------------------------------
   Copyright Laurent Robbe. Tout droits réservés.
   Créé le : 31/05/2003
   à : 11:54:11
   Modifiée le :12/01/2007 par André: ajout test sur évènement individuel dans T_ASSOCIATIONS
   et EVENEMENT_FAM sans UNION, correction T_UNION avec un conjoint=0 ou null
   ajout I_MODE=2 pour exécution sans messages.
   13/01/08 ajout tests sur SOURCES_RECORD, événements sans type et conjoints identiques.
   25/10/2010 suppression références à ADRESSES_IND
   28/06/2012 correction erreur dans "Unions dont mari et femme sont le même individu"
   Description : Renvoie les individus de nom passé en paramètre
   Usage       : I_MODE = 0 : Consultation
                 I_MODE = 1 : Mise à jour
                 I_MODE=2 : Mise à jour sans messages
   ---------------------------------------------------------------------------*/
  o_libelle='Evénement individuel pointant sur un individu inexistant ou sans type';
  o_table='EVENEMENT_IND';
  for select a.ev_ind_clef,a.ev_ind_kle_fiche from evenements_ind a
  where not exists (select 1 from individu b
                    where b.kle_dossier=a.ev_ind_kle_dossier
                      and b.cle_fiche=a.ev_ind_kle_fiche)
     or not exists (select 1 from ref_evenements
                    where ref_eve_lib_court=a.ev_ind_type)
  into :o_cle_table,:o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from evenements_ind
      where ev_ind_clef=:o_cle_table;
    end
  end

  o_libelle='Unions dont mari et femme sont le même individu';
  o_table='T_UNION';
  for select u.union_clef
            ,u.union_mari
            ,i.sexe
            ,i.kle_dossier
  from t_union u
  inner join individu i on i.cle_fiche=u.union_mari
  where u.union_mari=u.union_femme
  into :o_cle_table, :o_cle_fiche,:sexe ,:dossier
  do
  begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then
    begin
      if (sexe=1) then
      begin
        update t_union u
        set u.union_femme=null
        where u.union_clef=:o_cle_table;
        update individu i
        set i.cle_mere=null
        where i.cle_pere=:o_cle_fiche and i.cle_mere=:o_cle_fiche;
        select count(*) from t_union
        where union_mari=:o_cle_fiche
        and (union_femme = 0 or union_femme is null)
        into :i_count;
        if (i_count > 1) then
        begin
          delete from t_union e
          where e.union_mari=:o_cle_fiche
          and  (e.union_femme = 0 or e.union_femme is null);
          i_count=0;
        end
        if (i_count < 1) then
        begin
          select count(*) from individu
          where cle_pere = :o_cle_fiche
            and (cle_mere is null or cle_mere = 0)
            and kle_dossier=:dossier
          into :i_count;
          if (i_count > 0) then
          insert into t_union (union_mari,kle_dossier,union_type)
          values (:o_cle_fiche,:dossier, 0);
        end
      end
      else
      if (sexe=2) then
      begin
        update t_union u
        set u.union_mari=null
        where u.union_clef=:o_cle_table;
        update individu i
        set i.cle_pere=null
        where i.cle_pere=:o_cle_fiche and i.cle_mere=:o_cle_fiche;
        select count(*) from t_union
        where union_femme=:o_cle_fiche
        and (union_mari = 0 or union_mari is null)
        into :i_count;
        if (i_count > 1) then
        begin
          delete from t_union e
          where e.union_femme=:o_cle_fiche
          and  (e.union_mari = 0 or e.union_mari is null);
          i_count=0;
        end
        if (i_count < 1) then
        begin
          select count(*) from individu
          where cle_mere = :o_cle_fiche
            and (cle_pere is null or cle_pere = 0)
            and kle_dossier=:dossier
          into :i_count;
          if (i_count > 0) then
          insert into t_union (union_femme,kle_dossier,union_type)
          values (:o_cle_fiche,:dossier, 0);
        end
      end
      else --sexe inconnu
      begin
        delete from t_union where union_clef=:o_cle_table;
        update individu
        set cle_pere=null,cle_mere=null
        where cle_pere=:o_cle_fiche and cle_mere=:o_cle_fiche;
      end
    end
  end

  o_libelle='Union pointant sur un mari inexistant';
  o_table='T_UNION';
  for select a.union_clef, a.union_mari, a.union_femme from t_union a
  where  a.kle_dossier = :i_kle_dossier
  and    a.union_mari is not null
  and    not exists (select 1 from individu b
    where  b.kle_dossier = a.kle_dossier
    and    b.cle_fiche = a.union_mari
  )
  into :o_cle_table, :o_cle_fiche, :conjoint
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then
    begin
      if (conjoint is null or conjoint=0) then
      begin
        delete from t_union c
        where  c.union_clef = :o_cle_table
        and    c.kle_dossier = :i_kle_dossier;
      end
      update t_union set union_mari = null
               where union_clef = :o_cle_table;
      select count(*) from t_union
        where union_femme=:conjoint
        and  (union_mari is null or union_mari = 0)
        into :i_count;
      if (i_count > 1) then
        begin
          delete from t_union
          where union_femme=:conjoint
          and  (union_mari = 0 or union_mari is null);
          i_count=0;
        end
      if (i_count < 1) then
        begin
          select count(*) from individu
                where cle_mere = :conjoint and (cle_pere is null or cle_pere = 0)
                into :i_count;
          if (i_count > 0) then
          insert into t_union (union_femme,kle_dossier,union_type)
          values (:conjoint, :i_kle_dossier, 0);
        end
    end
  end

  o_libelle='Union pointant sur une épouse inexistante';
  o_table='T_UNION';
  for select a.union_clef, a.union_mari, a.union_femme from t_union a
    where  a.kle_dossier = :i_kle_dossier
  and    a.union_femme is not null
  and    not exists (select 1 from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.union_femme)
  into :o_cle_table, :conjoint, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then
      begin
      if (conjoint is null or conjoint=0) then
      begin
        delete from t_union c
        where  c.union_clef = :o_cle_table
        and    c.kle_dossier = :i_kle_dossier;
      end
      update t_union set union_femme = null
               where union_clef = :o_cle_table;
      select count(*) from t_union
        where union_mari=:conjoint
        and  (union_femme = 0 or union_femme is null)
        into :i_count;
        if (i_count > 1) then
        begin
          delete from t_union e
          where e.union_mari=:conjoint
          and  (e.union_femme = 0 or e.union_femme is null);
          i_count=0;
        end
        if (i_count < 1) then
        begin
          select count(*) from individu
                where cle_pere = :conjoint and (cle_mere is null or cle_mere = 0)
                into :i_count;
          if (i_count > 0) then
          insert into t_union (union_mari,kle_dossier,union_type)
          values (:conjoint,:i_kle_dossier, 0);
        end
      end
  end

  o_libelle='Média Pointeurs pointant sur un individu inexistant';
  o_table='MEDIA_POINTEURS';
  for select a.mp_clef,a.mp_cle_individu from media_pointeurs a
  where not exists (select 1 from individu b
                    where b.kle_dossier=a.mp_kle_dossier
                      and b.cle_fiche=a.mp_cle_individu)
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from media_pointeurs
      where mp_clef=:o_cle_table;
    end
  end

  o_libelle='Association pointant sur un individu inexistant';
  o_table='T_ASSOCIATIONS';
  for select assoc_clef, assoc_kle_ind from t_associations a
  where  assoc_kle_dossier = :i_kle_dossier
  and    assoc_table = 'I'
  and   not exists (select 1 from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.assoc_kle_ind)
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from t_associations z
      where z.assoc_kle_dossier=:i_kle_dossier
      and   z.assoc_clef=:o_cle_table;
    end
  end

  o_libelle='Associé d''une association pointant sur un individu inexistant';
  o_table='T_ASSOCIATIONS';
  for select assoc_clef, assoc_kle_associe from t_associations a
  where  assoc_kle_dossier = :i_kle_dossier
  and    not exists (select 1 from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.assoc_kle_associe)
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from t_associations z
      where z.assoc_kle_dossier=:i_kle_dossier
      and   z.assoc_clef=:o_cle_table;
    end
  end

  o_libelle='Evénement familial pointant sur une union inexistante ou sans type';
  o_table='EVENEMENTS_FAM';
  for select a.ev_fam_clef, a.ev_fam_kle_famille from evenements_fam a
  where not exists (select 1 from t_union b
                    where b.kle_dossier=a.ev_fam_kle_dossier
                      and b.union_clef = a.ev_fam_kle_famille)
     or not exists (select 1 from ref_evenements
                    where ref_eve_lib_court=a.ev_fam_type)
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from evenements_fam z
      where z.ev_fam_clef=:o_cle_table;
    end
  end

  o_libelle='Association pointant sur un événement familial inexistant';
  o_table='T_ASSOCIATIONS';
  for select assoc_clef, assoc_kle_ind from t_associations a
  where  assoc_kle_dossier = :i_kle_dossier
  and    assoc_table = 'U'
  and    not exists (select 1 from evenements_fam b
    where  b.ev_fam_kle_dossier = :i_kle_dossier
    and    b.ev_fam_clef = a.assoc_kle_ind)
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from t_associations z
      where z.assoc_kle_dossier=:i_kle_dossier
      and   z.assoc_clef=:o_cle_table;
    end
  end

  o_libelle='Association pointant sur un événement individuel inexistant';
  o_table='T_ASSOCIATIONS';
  for select assoc_clef, assoc_evenement from t_associations a
  where  assoc_kle_dossier = :i_kle_dossier
  and    assoc_table = 'I'
  and    not exists (select 1 from evenements_ind b
    where  b.ev_ind_kle_dossier = :i_kle_dossier
    and    b.ev_ind_clef = a.assoc_evenement)
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from t_associations z
      where z.assoc_kle_dossier=:i_kle_dossier
      and   z.assoc_clef=:o_cle_table;
    end
  end

  o_libelle='Père présent dans la fiche individu mais inexistant';
  o_table='INDIVIDU';
  for select cle_fiche, cle_pere from individu a
  where a.kle_dossier = :i_kle_dossier
  and   a.cle_pere is not null
    and not exists (
    select b.cle_fiche from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.cle_pere
  )
  into :o_cle_table, o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
  end
    if (i_mode>0) then begin
      update individu a
      set   a.cle_pere = null
      where a.kle_dossier = :i_kle_dossier
      and   a.cle_pere is not null
      and not exists (
      select b.cle_fiche from individu b
      where  b.kle_dossier = :i_kle_dossier
      and    b.cle_fiche = a.cle_pere
    );
  end

  o_libelle='Mère présente dans la fiche individu mais inexistante';
  o_table='INDIVIDU';
  for select cle_fiche, cle_mere from individu a
  where a.kle_dossier = :i_kle_dossier
  and   a.cle_mere is not null
    and not exists (
    select b.cle_fiche from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.cle_mere
  )
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
  end
  if (i_mode>0) then begin
    update individu a
    set   a.cle_mere = null
    where a.kle_dossier = :i_kle_dossier
    and   a.cle_mere is not null
      and not exists (
      select b.cle_fiche from individu b
      where  b.kle_dossier = :i_kle_dossier
      and    b.cle_fiche = a.cle_mere
      );
  end

  o_libelle='Enfant dont les parents n''ont pas d''union dans la table T_UNION';
  o_table='INDIVIDU';
  for select a.cle_fiche, a.cle_pere, a.cle_mere from individu a
  where  a.kle_dossier = :i_kle_dossier
  and   (( a.cle_pere is not null and a.cle_pere <> 0) or
         ( a.cle_mere is not null and a.cle_mere <> 0)   )
  into :o_cle_fiche, :pere, :mere
  do begin
    if (pere is null or pere = 0) then begin
      select count(*) from t_union b
      where b.union_mari is null
      and   b.union_femme=:mere
      into :i_count;
    end else if (mere is null or mere = 0) then begin
      select count(*) from t_union b
      where b.union_mari=:pere
      and   b.union_femme is null
      into :i_count;
    end else begin
      select count(*) from t_union b
      where b.union_mari=:pere
      and   b.union_femme=:mere
      into :i_count;
    end
    if (i_count<=0) then begin
      o_cle_table=o_cle_fiche;
      if (i_mode<2) then suspend;
      if (i_mode>0) then begin
        insert into t_union (union_mari,union_femme,kle_dossier,union_type)
        values (:pere,:mere,:i_kle_dossier,0);
      end
    end
  end

  o_libelle='Enregistrement sources pointant sur un événement individuel inexistant';
  o_table='SOURCES_RECORD';
  for select s.id,s.data_id from sources_record s
  where s.type_table='I'
    and not exists (select 1 from evenements_ind e
                    where e.ev_ind_kle_dossier=s.kle_dossier
                      and e.ev_ind_clef=s.data_id)
  into :o_cle_table,:o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from sources_record s
      where s.id=:o_cle_table;
    end
  end

  o_libelle='Enregistrement sources pointant sur un événement familial inexistant';
  o_table='SOURCES_RECORD';
  for select s.id,s.data_id from sources_record s
  where s.type_table='F'
    and not exists (select 1 from evenements_fam e
                    where e.ev_fam_kle_dossier=s.kle_dossier
                      and e.ev_fam_clef=s.data_id)
  into :o_cle_table,:o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from sources_record s
      where s.id=:o_cle_table;
    end
  end
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_INSERT_FAVORIS (
    I_DOSSIER Integer,
    I_CLE Integer,
    I_NBRE Integer )
AS
DECLARE VARIABLE I INTEGER;
begin
  if (not exists (select 1 from favoris where kle_fiche=:i_cle)) then
    insert into favoris (id,kle_dossier,kle_fiche)
    values (gen_id(gen_favoris,1),:i_dossier,:i_cle);
  select first(1) skip(:i_nbre) id
    from favoris
    where kle_dossier=:i_dossier
    order by id desc
    into :i;
  delete from favoris where id<=:i and kle_dossier=:i_dossier;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure entièrement refaite par André le 01/11/2008.
Insère un individu dans la liste des favoris de son dossier s''il n''y existe pas
et supprime les favoris en excédent.'
  where RDB$PROCEDURE_NAME = 'PROC_INSERT_FAVORIS';

SET TERM ^ ;
ALTER PROCEDURE PROC_JOURS_TEXTE (
    ANS Integer,
    MOIS Integer,
    JOURS Integer,
    PRECIS Smallint )
RETURNS (
    JOURS_TEXTE Varchar(25) )
AS
begin
  if (jours is null or jours<0 or mois is null
      or mois<0 or ans is null or ans<0) then
  begin
    suspend;
    exit;
  end
  if (ans=0 and mois=0 and jours<15) then
  begin
    if (jours<2) then
      jours_texte=cast(jours as varchar(1))||' jour';
    else
      jours_texte=cast(jours as varchar(2))||' jours';
    suspend;
    exit;
  end
  if (ans=0 and mois<2) then
  begin
    if (mois>0) then
    begin
      jours_texte='1 mois';
      if (floor(jours/7)=1) then
        jours_texte=jours_texte||'et 1 semaine';
      else
        if (floor(jours/7)>1) then
          jours_texte=jours_texte||' et '||cast(floor(jours/7) as varchar(1))||' semaines';
    end
    else
      jours_texte=cast(floor(jours/7) as varchar(1))||' semaines';
    suspend;
    exit;
  end
  if (ans=0) then
  begin
    jours_texte=cast(mois as varchar(2))||' mois';
    if (precis=1 and jours>14) then
      jours_texte=jours_texte||' et demi';
    suspend;
    exit;
  end
  if (ans>0) then
  begin
    if (ans=1) then
      jours_texte='1 an';
    else
      jours_texte=cast(ans as varchar(5))||' ans';
    if (precis=1 and mois>0) then
        jours_texte=jours_texte||' et '||cast(mois as varchar(2))||' mois';
  end
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André le 11/05/2008 pour transformer une différence entre
2 dates exprimée en années, mois, jours, en format textuel.
PRECIS=1 permet d''exprimer cette date avec plus de précision.'
  where RDB$PROCEDURE_NAME = 'PROC_JOURS_TEXTE';

SET TERM ^ ;
ALTER PROCEDURE PROC_LISTE_PARENTE (
    INDI1 Integer,
    INDI2 Integer )
RETURNS (
    ANCETRE_1 Integer,
    NOM_1 Varchar(130),
    SEXE_1 Integer,
    SOSA_1 Integer,
    ANCETRE_2 Integer,
    NOM_2 Varchar(130),
    SEXE_2 Integer,
    SOSA_2 Integer )
AS
declare variable enfant_1 integer;
declare variable nom_enfant_1 varchar(130);
declare variable sexe_enfant_1 integer;
declare variable sosa_enfant_1 integer;
declare variable enfant_2 integer;
declare variable nom_enfant_2 varchar(130);
declare variable sexe_enfant_2 integer;
declare variable sosa_enfant_2 integer;
declare variable i integer;
declare variable i_1 integer;
declare variable i_2 integer;
begin
  select first(1) p.commun
        ,i.nom||coalesce(' '||i.prenom,'')||case 
          when ((i.annee_naissance is null) and (i.annee_deces is null)) then ''
          when (i.annee_naissance is null) then ' (?'||cast(i.annee_deces as varchar(5))||')'
          when (i.annee_deces is null) then ' (°'||cast(i.annee_naissance as varchar(5))||')'
          else ' (°'||cast(i.annee_naissance as varchar(5))||' ?'||cast(i.annee_deces as varchar(5))||')'
          end
        ,i.sexe
        ,case when i.num_sosa>0 then 1 else 0 end
        ,p.enfant_1
        ,e1.nom||coalesce(' '||e1.prenom,'')||case
          when ((e1.annee_naissance is null) and (e1.annee_deces is null)) then ''
          when (e1.annee_naissance is null) then ' (?'||cast(e1.annee_deces as varchar(5))||')'
          when (e1.annee_deces is null) then ' (°'||cast(e1.annee_naissance as varchar(5))||')'
          else ' (°'||cast(e1.annee_naissance as varchar(5))||' ?'||cast(e1.annee_deces as varchar(5))||')'
          end
        ,e1.sexe
        ,case when e1.num_sosa>0 then 1 else 0 end
        ,p.enfant_2
        ,e2.nom||coalesce(' '||e2.prenom,'')||case
          when ((e2.annee_naissance is null) and (e2.annee_deces is null)) then ''
          when (e2.annee_naissance is null) then ' (?'||cast(e2.annee_deces as varchar(5))||')'
          when (e2.annee_deces is null) then ' (°'||cast(e2.annee_naissance as varchar(5))||')'
          else ' (°'||cast(e2.annee_naissance as varchar(5))||' ?'||cast(e2.annee_deces as varchar(5))||')'
          end
        ,e2.sexe
        ,case when e2.num_sosa>0 then 1 else 0 end
        ,p.niveau_min_1
        ,p.niveau_min_2
        from proc_anc_communs(:indi1,:indi2) p
        inner join individu i on i.cle_fiche=p.commun
        inner join individu e1 on e1.cle_fiche=p.enfant_1
        inner join individu e2 on e2.cle_fiche=p.enfant_2
        order by p.niveau_min_1+p.niveau_min_2
  into :ancetre_1
      ,:nom_1
      ,:sexe_1
      ,:sosa_1
      ,:enfant_1
      ,:nom_enfant_1
      ,:sexe_enfant_1
      ,:sosa_enfant_1
      ,:enfant_2
      ,:nom_enfant_2
      ,:sexe_enfant_2
      ,:sosa_enfant_2
      ,:i_1
      ,:i_2;
  ancetre_2=ancetre_1;
  nom_2=nom_1;
  sexe_2=sexe_1;
  sosa_2=sosa_1;
  if (ancetre_1>0) then
    suspend;
  else
    exit;
  if (enfant_1>0 or enfant_2>0) then
  begin
    if (enfant_1<>ancetre_1) then
    begin
      ancetre_1=enfant_1;
      nom_1=nom_enfant_1;
      sexe_1=sexe_enfant_1;
      sosa_1=sosa_enfant_1;
    end
    else
    begin
      ancetre_1=0;
      nom_1=null;
      sexe_1=0;
      sosa_1=0;
    end
    if (enfant_2<>ancetre_2) then
    begin
      ancetre_2=enfant_2;
      nom_2=nom_enfant_2;
      sexe_2=sexe_enfant_2;
      sosa_2=sosa_enfant_2;
    end
    else
    begin
      ancetre_2=0;
      nom_2=null;
      sexe_2=0;
      sosa_2=0;
    end
    suspend;
  end
  else
    exit;
  i=1;
  while (i<i_1 or i<i_2) do
  begin
    ancetre_1=0;
    ancetre_2=0;
    nom_1=null;
    nom_2=null;
    sexe_1=0;
    sexe_2=0;
    if (i<i_1) then
    begin
      select first(1) t.enfant
        ,i.nom||coalesce(' '||i.prenom,'')||case
          when ((i.annee_naissance is null) and (i.annee_deces is null)) then ''
          when (i.annee_naissance is null) then ' (?'||cast(i.annee_deces as varchar(5))||')'
          when (i.annee_deces is null) then ' (°'||cast(i.annee_naissance as varchar(5))||')'
          else ' (°'||cast(i.annee_naissance as varchar(5))||' ?'||cast(i.annee_deces as varchar(5))||')'
          end
        ,i.sexe
        ,case when i.num_sosa>0 then 1 else 0 end
      from tq_anc t
      inner join individu i on i.cle_fiche=t.enfant
      where t.decujus=:indi1 and t.indi=:enfant_1 and t.niveau=:i_1-:i
      into :ancetre_1
          ,:nom_1
          ,:sexe_1
          ,:sosa_1;
      enfant_1=ancetre_1;
    end
    else
    begin
      ancetre_1=0;
      nom_1=null;
      sexe_1=0;
      sosa_1=0;
    end
    if (i<i_2) then
    begin
      select first(1) t.enfant
        ,i.nom||coalesce(' '||i.prenom,'')||case
          when ((i.annee_naissance is null) and (i.annee_deces is null)) then ''
          when (i.annee_naissance is null) then ' (?'||cast(i.annee_deces as varchar(5))||')'
          when (i.annee_deces is null) then ' (°'||cast(i.annee_naissance as varchar(5))||')'
          else ' (°'||cast(i.annee_naissance as varchar(5))||' ?'||cast(i.annee_deces as varchar(5))||')'
          end
        ,i.sexe
        ,case when i.num_sosa>0 then 1 else 0 end
      from tq_anc t
      inner join individu i on i.cle_fiche=t.enfant
      where t.decujus=:indi2 and t.indi=:enfant_2 and t.niveau=:i_2-:i
      into :ancetre_2
          ,:nom_2
          ,:sexe_2
          ,:sosa_2;
      enfant_2=ancetre_2;
    end
    else
    begin
      ancetre_2=0;
      nom_2=null;
      sexe_2=0;
      sosa_2=0;
    end
    suspend;
    i=i+1;
  end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André pour lister les ascendants de deux individus ayant
un ancêtre commun'
  where RDB$PROCEDURE_NAME = 'PROC_LISTE_PARENTE';

SET TERM ^ ;
ALTER PROCEDURE PROC_LISTE_PRENOM (
    I_DOSSIER Integer )
RETURNS (
    PRENOM Varchar(60),
    SEXE Integer,
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM_COMPLET Varchar(60),
    CLE_PERE Integer,
    CLE_MERE Integer,
    DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer )
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:14:10
   Modifiée le :24/10/2006 par André, éclatement en 2 procédures
   17/01/08 ajout date_naissance
   Description : Cette procedure remonte la liste de tous les prenoms du
   dossier passé en parametres, les prenoms séparés par des
   virgules ou espaces seront décomposés.
   ---------------------------------------------------------------------------*/
  for  select sexe,cle_fiche,nom,prenom,
              cle_pere,cle_mere,date_naissance,annee_naissance
          from individu
          where kle_dossier=:i_dossier
          into :sexe,:cle_fiche,:nom,:prenom_complet,
               :cle_pere,:cle_mere,:date_naissance,:annee_naissance
  do for select prenom from proc_eclate_prenom(:prenom_complet)
         where prenom is not null
         into :prenom
     do suspend;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_LISTE_PROFESSION (
    I_DOSSIER Integer )
RETURNS (
    PROFESSION Varchar(90),
    CLE_FICHE Integer,
    SEXE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer,
    DATE_DECES Varchar(100),
    ANNEE_DECES Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    DESCRIPTION Varchar(90),
    DATE_PROFESSION Varchar(100),
    ANNEE_PROFESSION Integer,
    VILLE_PROFESSION Varchar(50),
    DEPT_PROFESSION Varchar(30) )
AS
begin
/*donne la liste des individus d'un dossier avec leurs professions séparées.
Procédure créée par André le 22/05/2007, dernière modification 24/09/2007*/
  for  select i.CLE_FICHE
             ,i.sexe
             ,i.NOM
             ,i.PRENOM
             ,i.date_naissance
             ,i.annee_naissance
             ,i.date_deces
             ,i.annee_deces
             ,i.CLE_PERE
             ,i.CLE_MERE
             ,e.ev_ind_description
             ,e.ev_ind_date_writen
             ,e.ev_ind_date_year
             ,e.ev_ind_ville
             ,e.ev_ind_dept
          from individu i
          inner join evenements_ind e
                  on e.ev_ind_kle_fiche=i.cle_fiche
                 and e.ev_ind_type='OCCU'
          where i.KLE_DOSSIER=:I_DOSSIER
          INTO :CLE_FICHE
              ,:sexe
              ,:NOM
              ,:PRENOM
              ,:date_naissance
              ,:annee_naissance
              ,:date_deces
              ,:annee_deces
              ,:CLE_PERE
              ,:CLE_MERE
              ,:description
              ,:date_profession
              ,:annee_profession
              ,:ville_profession
              ,:dept_profession
  do for select s_description
         from proc_eclate_description(:description,',')
         where s_description is not null
         into :profession
     do suspend;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_LISTE_UNIONS (
    I_DOSSIER Integer )
RETURNS (
    UNION_CLE Integer,
    MARI_CLE Integer,
    MARI_NOM Varchar(40),
    MARI_PRENOM Varchar(60),
    MARI_NUM_SOSA Double precision,
    AGE_MARI Integer,
    FEMME_CLE Integer,
    FEMME_NOM Varchar(40),
    FEMME_PRENOM Varchar(60),
    FEMME_NUM_SOSA Double precision,
    AGE_FEMME Integer,
    CLE_MARR Integer,
    DATE_MARR Varchar(100),
    AN_MARR Integer,
    MOIS_MARR Integer,
    DATE_UNION Date,
    SUBD Varchar(50),
    VILLE Varchar(50),
    DEPT Varchar(30),
    REGION Varchar(50),
    PAYS Varchar(30) )
AS
declare variable annee_naissance_mari integer;
declare variable annee_naissance_femme integer;
begin
  for select u.union_clef
            ,m.cle_fiche
            ,m.nom
            ,m.prenom
            ,m.num_sosa
            ,m.annee_naissance
            ,f.cle_fiche
            ,f.nom
            ,f.prenom
            ,f.num_sosa
            ,f.annee_naissance
      from individu m
      inner join t_union u on u.union_mari=m.cle_fiche
      inner join individu f on f.cle_fiche=u.union_femme
      where m.kle_dossier=:i_dossier
      into :union_cle
          ,:mari_cle
          ,:mari_nom
          ,:mari_prenom
          ,:mari_num_sosa
          ,:annee_naissance_mari
          ,:femme_cle
          ,:femme_nom
          ,:femme_prenom
          ,:femme_num_sosa
          ,:annee_naissance_femme
  do
  begin
    subd=null;
    ville=null;
    dept=null;
    region=null;
    pays=null;
    an_marr=null;
    mois_marr=null;
    date_union=null;
    cle_marr=null;
    date_marr=null;
    age_mari=null;
    age_femme=null;
    select first(1) ev_fam_subd
          ,ev_fam_ville
          ,ev_fam_dept
          ,ev_fam_region
          ,ev_fam_pays
          ,ev_fam_date_year
          ,ev_fam_date_mois
          ,ev_fam_date
          ,ev_fam_clef
          ,ev_fam_date_writen
          ,ev_fam_date_year-:annee_naissance_mari
          ,ev_fam_date_year-:annee_naissance_femme
    from evenements_fam
    where ev_fam_kle_famille=:union_cle and ev_fam_type='MARR'
    order by ev_fam_ordre nulls last,ev_fam_datecode nulls last
    into :subd
        ,:ville
        ,:dept
        ,:region
        ,:pays
        ,:an_marr
        ,:mois_marr
        ,:date_union
        ,:cle_marr
        ,:date_marr
        ,:age_mari
        ,:age_femme;
    suspend;
  end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure entièrement refaite par André Langlet le 25/12/2009
pour nouvelle liste des unions.
le 10/03/2012 utilisation ordre et datecode.'
  where RDB$PROCEDURE_NAME = 'PROC_LISTE_UNIONS';

SET TERM ^ ;
ALTER PROCEDURE PROC_MAJ_TAGS
AS
declare variable code_union integer;
declare variable compte integer;
declare variable code_type integer;
declare variable dossier integer;
begin
  for select union_type,union_clef,kle_dossier
      from t_union
      where union_type>0
      into :code_type,:code_union,:dossier
      do
  begin
    compte=0;
    if (code_type=1) then --Mariés
    begin
      select 1 from rdb$database where exists
      (select 1 from evenements_fam
      where ev_fam_type='MARR'
        and ev_fam_kle_famille=:code_union)
      into :compte;
      if (compte<1) then
        insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                   ,ev_fam_type)
        values(:code_union,:dossier,'MARR');
    end
    else
    if (code_type=2) then--Concubinage
    begin
      select 1 from rdb$database where exists
      (select 1 from evenements_fam
      where ev_fam_type='EVEN'
        and ev_fam_description='Concubinage'
        and ev_fam_kle_famille=:code_union)
      into :compte;
      if (compte<1) then
        insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                   ,ev_fam_type,ev_fam_description)
        values(:code_union,:dossier,'EVEN','Concubinage');
    end
    if (code_type=3) then--Séparés
    begin
      select 1 from rdb$database where exists
      (select 1 from evenements_fam
      where ev_fam_type='EVEN'
        and ev_fam_description='Séparés'
        and ev_fam_kle_famille=:code_union)
      into :compte;
      if (compte<1) then
        insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                   ,ev_fam_type,ev_fam_description)
        values(:code_union,:dossier,'EVEN','Séparés');
    end
    if (code_type=4) then--Union libre
    begin
      select 1 from rdb$database where exists
      (select 1 from evenements_fam
      where ev_fam_type='EVEN'
        and ev_fam_description='Union libre'
        and ev_fam_kle_famille=:code_union)
      into :compte;
      if (compte<1) then
        insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                   ,ev_fam_type,ev_fam_description)
        values(:code_union,:dossier,'EVEN','Union libre');
    end
    if (code_type=5) then--Relations extra-conjugales
    begin
      select 1 from rdb$database where exists
      (select 1 from evenements_fam
      where ev_fam_type='EVEN'
        and ev_fam_description='Relations extra-conjugales'
        and ev_fam_kle_famille=:code_union)
      into :compte;
      if (compte<1) then
        insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                   ,ev_fam_type,ev_fam_description)
        values(:code_union,:dossier,'EVEN','Relations extra-conjugales');
    end
    if (code_type=6) then--PACS
    begin
      select 1 from rdb$database where exists
      (select 1 from evenements_fam
      where ev_fam_type='MARR'
        and ev_fam_kle_famille=:code_union)
      into :compte;
      if (compte<1) then
        insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                   ,ev_fam_type,ev_fam_description)
        values(:code_union,:dossier,'MARR','PACS');
    end
  end

  update t_union set union_type=0 where union_type<>0;

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Circoncision'
  where ev_ind_type='X_MU1';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Chahada'
  where ev_ind_type='X_MU2';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='El hadj'
  where ev_ind_type='X_MU3';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Sports'
  where ev_ind_type='XSPO';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Loisirs'
  where ev_ind_type='XLOI';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Henné - Fiancailles'
  where ev_ind_type='XHENN';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Houpa - Bénéd. religieuse'
  where ev_ind_type='XHOUP';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Service militaire'
  where ev_ind_type='MILI';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Voyage'
  where ev_ind_type='TRIP';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Voyage long'
  where ev_ind_type='VOYA';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Brit Mila'
  where ev_ind_type='BRIT';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Communion'
  where ev_ind_type='COMU';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Décoration'
  where ev_ind_type='DECO';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Sacre'
  where ev_ind_type='SACR';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Acquisition'
  where ev_ind_type='PURC';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Héritage'
  where ev_ind_type='LEGA';

  update evenements_ind
  set ev_ind_type='EVEN'
     ,ev_ind_titre_event='Vente'
  where ev_ind_type='SALE';

  update evenements_ind
  set ev_ind_type='BURI'
  where ev_ind_type='INHU';

  update evenements_ind
  set ev_ind_type='BLES'
  where ev_ind_type='BENE';

  update evenements_ind
  set ev_ind_type='GRAD'
  where ev_ind_type='DIPL';

  update evenements_ind
  set ev_ind_type='TITL'
  where ev_ind_type='TITR';

end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André le 30/01/2008 pour transformer le champ UNION_TYPE
en événements familiaux, et les tags spéciaux en événements divers.'
  where RDB$PROCEDURE_NAME = 'PROC_MAJ_TAGS';

SET TERM ^ ;
ALTER PROCEDURE PROC_NAVIGATION (
    I_CLEF Integer,
    I_MAX Integer )
RETURNS (
    NIVEAU Integer,
    CLE_FICHE Integer,
    NOM Varchar(60),
    PRENOM Varchar(100),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Double precision,
    DECEDE Integer,
    VILLE_NAISSANCE Varchar(50),
    VILLE_DECES Varchar(50),
    PROFESSION Varchar(90),
    DATE_UNION Varchar(90),
    VILLE_UNION Varchar(50),
    PHOTO Blob sub_type 0,
    ENFANTS Integer,
    NUM_SOSA Double precision,
    PERIODE_VIE Varchar(15) )
AS
declare variable i_sexe integer;
declare variable i_cle_pere integer;
declare variable i_cle_mere integer;
declare variable i_cle_pere_pere integer;
declare variable i_cle_pere_mere integer;
declare variable i_cle_mere_pere integer;
declare variable i_cle_mere_mere integer;
begin
   select  sexe,cle_pere,cle_mere
      from individu
      where cle_fiche = :i_clef
      into :i_sexe,:i_cle_pere,:i_cle_mere;
   for
   select  0,      --l'individu
           cle_fiche,
           nom,
           prenom,
           date_naissance,
           date_deces,
           sexe,
           cle_pere,
           cle_mere,
           1
           ,decede
           ,num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '('||coalesce('°'||cast(annee_naissance as varchar(5)),'')||
            iif(annee_naissance is null or annee_deces is null,'',' ')||
            coalesce('?'||cast(annee_deces as varchar(5)),'')||')')
         from individu
              where cle_fiche  = :i_clef
    union
    select 1,    --son père
           cle_fiche,
           nom,
           prenom,
           date_naissance,
           date_deces,
           sexe,
           cle_pere,
           cle_mere,
           2
           ,decede
           ,num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '('||coalesce('°'||cast(annee_naissance as varchar(5)),'')||
            iif(annee_naissance is null or annee_deces is null,'',' ')||
            coalesce('?'||cast(annee_deces as varchar(5)),'')||')')
         from individu
              where cle_fiche=(select cle_pere from individu
                                 where cle_fiche=:i_clef)
    union
    select 1,   --sa mère
           cle_fiche,
           nom,
           prenom,
           date_naissance,
           date_deces,
           sexe,
           cle_pere,
           cle_mere,
           3
           ,decede
           ,num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '('||coalesce('°'||cast(annee_naissance as varchar(5)),'')||
            iif(annee_naissance is null or annee_deces is null,'',' ')||
            coalesce('?'||cast(annee_deces as varchar(5)),'')||')')
         from individu
              where cle_fiche=(select cle_mere from individu
                                 where cle_fiche=:i_clef)
    union
    select 2,   --ses grands parents
           cle_fiche,
           nom,
           prenom,
           date_naissance,
           date_deces,
           sexe,
           cle_pere,
           cle_mere,
           sosa
           ,decede
           ,num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '('||coalesce('°'||cast(annee_naissance as varchar(5)),'')||
            iif(annee_naissance is null or annee_deces is null,'',' ')||
            coalesce('?'||cast(annee_deces as varchar(5)),'')||')')
           from proc_trouve_grands_parent(:i_clef)
   union
    select 4,  --ses frères et soeurs
           cle_fiche,
           nom,
           prenom,
           date_naissance,
           date_deces,
           sexe,
           cle_pere,
           cle_mere
           ,f_1
           ,decede
           ,num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '('||coalesce('°'||cast(annee_naissance as varchar(5)),'')||
            iif(annee_naissance is null or annee_deces is null,'',' ')||
            coalesce('?'||cast(annee_deces as varchar(5)),'')||')')
           from proc_trouve_freres_soeurs(:i_clef)
    union
    select 3,
           cle_fiche,
           nom,
           prenom,
           date_naissance,
           date_deces,
           sexe,
           cle_pere,
           cle_mere
           ,sosa
           ,decede
           ,num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '('||coalesce('°'||cast(annee_naissance as varchar(5)),'')||
            iif(annee_naissance is null or annee_deces is null,'',' ')||
            coalesce('?'||cast(annee_deces as varchar(5)),'')||')')
           from proc_trouve_oncles_tantes(:i_clef)
    union
    select 5,   -- ses enfants
           cle_fiche,
           nom,
           prenom,
           date_naissance,
           date_deces,
           sexe,
           cle_pere,
           cle_mere
           ,annee_naissance
           ,decede
           ,num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '('||coalesce('°'||cast(annee_naissance as varchar(5)),'')||
            iif(annee_naissance is null or annee_deces is null,'',' ')||
            coalesce('?'||cast(annee_deces as varchar(5)),'')||')')
      from individu
      where (:i_sexe=1 and cle_pere=:i_clef)
         or (:i_sexe=2 and cle_mere=:i_clef)
    union
    select 7,  --ses conjoints
            p.conjoint
           ,c.nom
           ,c.prenom
           ,c.date_naissance
           ,c.date_deces
           ,c.sexe
           ,c.cle_pere
           ,c.cle_mere
           ,p.ordre
           ,c.decede
           ,c.num_sosa
           ,iif(c.annee_naissance is null and c.annee_deces is null,null,
            '('||coalesce('°'||cast(c.annee_naissance as varchar(5)),'')||
            iif(c.annee_naissance is null or c.annee_deces is null,'',' ')||
            coalesce('?'||cast(c.annee_deces as varchar(5)),'')||')')
      from proc_conjoints_ordonnes(:i_clef,0) p
        left join individu c on c.cle_fiche=p.conjoint
    union
    select 6,  --ses cousins et cousines
           i.cle_fiche,
           i.nom,
           i.prenom,
           i.date_naissance,
           i.date_deces,
           i.sexe,
           i.cle_pere,
           i.cle_mere
           ,p.sosa*10000+coalesce(i.annee_naissance,0)
           ,i.decede
           ,i.num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '('||coalesce('°'||cast(i.annee_naissance as varchar(5)),'')||
            iif(i.annee_naissance is null or i.annee_deces is null,'',' ')||
            coalesce('?'||cast(i.annee_deces as varchar(5)),'')||')')
           from proc_trouve_oncles_tantes (:i_clef) p,
                individu i
           where (p.sexe=1 and i.cle_pere=p.cle_fiche)
              or (p.sexe=2 and i.cle_mere=p.cle_fiche)
    union
    select 8,  --ses petits enfants
           i.cle_fiche,
           i.nom,
           i.prenom,
           i.date_naissance,
           i.date_deces,
           i.sexe,
           i.cle_pere,
           i.cle_mere
           ,coalesce(p.annee_naissance,0)*10000+coalesce(i.annee_naissance,0)
           ,i.decede
           ,i.num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '('||coalesce('°'||cast(i.annee_naissance as varchar(5)),'')||
            iif(i.annee_naissance is null or i.annee_deces is null,'',' ')||
            coalesce('?'||cast(i.annee_deces as varchar(5)),'')||')')
           from (select cle_fiche,sexe,annee_naissance
                 from individu
                 where (:i_sexe=1 and cle_pere=:i_clef)
                    or (:i_sexe=2 and cle_mere=:i_clef)) as p,
                individu i
           where (p.sexe=1 and i.cle_pere=p.cle_fiche)
              or (p.sexe=2 and i.cle_mere=p.cle_fiche)
    union
    select 9,   --ses neveux et nièces
           i.cle_fiche,
           i.nom,
           i.prenom,
           i.date_naissance,
           i.date_deces,
           i.sexe,
           i.cle_pere,
           i.cle_mere
           ,p.f_1*10000+coalesce(i.annee_naissance,0)
           ,i.decede
           ,i.num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '('||coalesce('°'||cast(i.annee_naissance as varchar(5)),'')||
            iif(i.annee_naissance is null or i.annee_deces is null,'',' ')||
            coalesce('?'||cast(i.annee_deces as varchar(5)),'')||')')
           from proc_trouve_freres_soeurs (:i_clef) p,
                individu i
           where (p.sexe=1 and i.cle_pere=p.cle_fiche)
              or (p.sexe=2 and i.cle_mere=p.cle_fiche)
    order by 1,10
    into :niveau,
         :cle_fiche,
         :nom,
         :prenom,
         :date_naissance,
         :date_deces,
         :sexe,
         :cle_pere,
         :cle_mere,
         :sosa,
         :decede,
         :num_sosa,
         :periode_vie
   do
   begin
     ville_naissance=null;
     ville_deces=null;
     profession=null;
     photo=null;
     enfants=null;
     if (not(niveau=1 and sosa=3)) then
     begin
       date_union=null;
       ville_union=null;
     end
     if (niveau in (0,1,2,5,7)) then
     begin
       select first(1) ev_ind_ville
       from evenements_ind  --les villes de naissances
       where ev_ind_kle_fiche=:cle_fiche and ev_ind_type='BIRT'
       into :ville_naissance;
       select first(1) ev_ind_ville
       from evenements_ind  --les villes de décès
       where ev_ind_kle_fiche=:cle_fiche and ev_ind_type='DEAT'
       into :ville_deces;
       if (i_max=1) then
         select count(1)  --le petit média et le nombre d'enfants
           ,coalesce((select multi_reduite from multimedia
                       where multi_clef=(select first(1)mp_media from media_pointeurs
                                         where mp_cle_individu=:cle_fiche
                                           and mp_identite=1))
           ,(select multi_reduite from multimedia
             where multi_clef=(select first(1)mp_media from media_pointeurs
                               where mp_cle_individu=:cle_fiche
                               order by mp_clef desc)))
         from individu
         where (:sexe=1 and cle_pere=:cle_fiche)
            or (:sexe=2 and cle_mere=:cle_fiche)
         into :enfants
             ,:photo;
       else --i_max=3
         select count(1)  --le nombre d'enfants
         from individu
         where (:sexe=1 and cle_pere=:cle_fiche)
            or (:sexe=2 and cle_mere=:cle_fiche)
         into :enfants;
       select first(1) ev_ind_description from evenements_ind
       where ev_ind_kle_fiche=:cle_fiche and ev_ind_type='OCCU'
       order by ev_ind_ordre desc, ev_ind_datecode desc nulls last
       into :profession;

       if (niveau=1) then  --ses parents
       begin
         if (sosa=2) then  --le père
         begin
           if (i_cle_mere is not null) then
             select first(1) e.ev_fam_date_writen  --l'union des parents
                            ,e.ev_fam_ville
             from t_union u
             inner join evenements_fam e on ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
             where u.union_mari=:i_cle_pere and u.union_femme=:i_cle_mere
             order by ev_fam_ordre,ev_fam_datecode nulls last
             into :date_union
                 ,:ville_union;
           i_cle_pere_pere=cle_pere;  --parents du père
           i_cle_mere_pere=cle_mere;
         end
         else     --la mère
         begin
           i_cle_pere_mere=cle_pere;  --parents de la mère
           i_cle_mere_mere=cle_mere;
         end
       end  --de niveau=1

       if (niveau=2) then --les grands parents
       begin
         if (sosa in(4,5)) then --parents du père
         begin
           if (i_cle_pere_pere is not null and i_cle_mere_pere is not null) then
           begin
            select first(1) e.ev_fam_date_writen   --l'union des parents du père
                           ,e.ev_fam_ville
            from t_union u
            inner join evenements_fam e on ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
            where u.union_mari=:i_cle_pere_pere and u.union_femme=:i_cle_mere_pere
            order by ev_fam_date_year,ev_fam_date_mois,ev_fam_date
            into :date_union
                ,:ville_union;
           end  --de l'union des parents du père
         end  --des parents du père
         else --parents de la mère
         begin
           if (i_cle_pere_mere is not null and i_cle_mere_mere is not null) then
           begin
             select first(1) e.ev_fam_date_writen   --l'union des parents de la mère
                            ,e.ev_fam_ville
             from t_union u
             inner join evenements_fam e on ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
             where u.union_mari=:i_cle_pere_mere and u.union_femme=:i_cle_mere_mere
             order by ev_fam_ordre,ev_fam_datecode nulls last
             into :date_union
                 ,:ville_union;
           end  --de l'union des parents de la mère
         end  --des parents de la mère
       end  --des grands-parents

       if (niveau=7) then  --les conjoints
       begin
         select first(1) e.ev_fam_date_writen
                        ,e.ev_fam_ville
         from t_union u
         inner join evenements_fam e on ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
         where (:i_sexe=1 and u.union_mari=:i_clef and u.union_femme=:cle_fiche)
            or (:i_sexe=2 and u.union_mari=:cle_fiche and u.union_femme=:i_clef)
         order by ev_fam_ordre,ev_fam_datecode nulls last
         into :date_union
             ,:ville_union;
       end -- de conjoints

     end -- de (niveau in (0,1,2,5,7))
   suspend;
 end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure entièrement refaite en 2007 par André Langlet.
Dernières modifications par André le 14/3/2008 pour dates avec° et ?
le 07/04/2009 suppression utilisation proc_trouve_unions
le 28/12/2009 correction suite à suppression des paramètres inutiles de
PROC_TROUVE_ONCLES_TANTES et de I_DOSSIER.
le 27/03/2011 suppression des témoins
le 08/03/2012 simplification suite à utilisation datecode
I_MAX est utilisé pour définir le mode de fonctionnement
   1:: informations complètes pour grande fenêtre de navigation
   3: idem sans photos
Description :    Cette procedure permet de récuperer la famille d''un individu
   Le Niveau est le suivant:
   0 - Lui Meme
   1 - Parents
   2 - Grands Parents
   3 - Oncles et tantes
   4 - Freres et soeurs
   5 - Enfants
   6 - Cousins et cousines
   7 - Conjoints
   8 - Petits-enfants
   9 - Neveux et nièces'
  where RDB$PROCEDURE_NAME = 'PROC_NAVIGATION';

SET TERM ^ ;
ALTER PROCEDURE PROC_NEW_PRENOMS (
    I_DOSSIER Integer )
AS
declare variable prenom varchar(60);
declare variable sexe integer;
declare variable courant varchar(60);
declare variable m integer;
declare variable f integer;
begin
  delete from prenoms;
  courant='';
  M=0;
  F=0;
  for select all prenom,sexe from proc_prep_prenoms(:I_DOSSIER)
      where prenom is not null and prenom<>'' and sexe>0
      order by prenom
      into :prenom,:sexe
  do
  begin
    if (prenom<>courant) then
    begin
      if (char_length(courant)>0) then
        insert into prenoms (prenom,M,F)
        values(:courant,:M,:F);
      M=0;
      F=0;
      courant=prenom;
    end
    if (sexe>1) then
      F=F+1;
    else
      M=M+1;
  end
  if (char_length(courant)>0) then
    insert into prenoms (prenom,M,F)
    values(:courant,:M,:F);
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_PREP_PRENOMS (
    I_DOSSIER Integer )
RETURNS (
    PRENOM Varchar(60),
    SEXE Integer )
AS
DECLARE VARIABLE PRENOM_COMPLET VARCHAR(60);
begin
   /*---------------------------------------------------------------------------
   Version allégée de proc_liste_prenom utilisée par proc_new_prenoms
   créée par André le 23/12/2006
   ---------------------------------------------------------------------------*/
  for  select distinct PRENOM,sexe
          from individu
          where KLE_DOSSIER=:I_DOSSIER
          INTO :PRENOM_COMPLET,:SEXE
  do for select prenom from proc_eclate_prenom(:PRENOM_COMPLET)
         into :prenom
     do suspend;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_PREP_PROFESSIONS (
    I_DOSSIER Integer )
RETURNS (
    PROFESSION Varchar(90) )
AS
DECLARE VARIABLE S_PROFESSION VARCHAR(90);
begin
/*donne la liste de toutes les professions d'un dossier.
Procédure créée par André le 22/05/2007, dernière modification 24/09/2007*/
  for select e.ev_ind_description
      from evenements_ind e
      where e.ev_ind_kle_dossier=:i_dossier
        and e.ev_ind_type='OCCU'
      into :s_profession
  do
    for select s_description from proc_eclate_description(:s_profession,',')
        where s_description is not null
        into :profession
        do
  suspend;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_PREP_VILLES_FAVORIS (
    I_DOSSIER Integer )
RETURNS (
    EV_IND_VILLE Varchar(50),
    EV_IND_CP Varchar(10),
    EV_IND_DEPT Varchar(30),
    EV_IND_REGION Varchar(50),
    EV_IND_PAYS Varchar(30),
    EV_IND_INSEE Varchar(6),
    EV_IND_SUBD Varchar(50),
    EV_IND_LATITUDE Decimal(15,8),
    EV_IND_LONGITUDE Numeric(15,8) )
AS
begin
  for select distinct ev_ind_ville
    ,ev_ind_cp
    ,ev_ind_dept
    ,ev_ind_region
    ,ev_ind_pays
    ,ev_ind_insee
    ,ev_ind_subd
    ,ev_ind_latitude
    ,ev_ind_longitude
  from (select distinct ev_ind_ville
    ,ev_ind_cp
    ,ev_ind_dept
    ,ev_ind_region
    ,ev_ind_pays
    ,ev_ind_insee
    ,ev_ind_subd
    ,ev_ind_latitude
    ,ev_ind_longitude
  from evenements_ind
  where ev_ind_kle_dossier = :i_dossier and
    (ev_ind_ville is not null or ev_ind_subd is not null or ev_ind_cp is not null
    or ev_ind_insee is not null or ev_ind_dept is not null
    or ev_ind_region is not null or ev_ind_pays is not null)
  union select distinct ev_fam_ville
    ,ev_fam_cp
    ,ev_fam_dept
    ,ev_fam_region
    ,ev_fam_pays
    ,ev_fam_insee
    ,ev_fam_subd
    ,ev_fam_latitude
    ,ev_fam_longitude
  from evenements_fam
  where ev_fam_kle_dossier = :i_dossier and
    (ev_fam_ville is not null or ev_fam_subd is not null or ev_fam_cp is not null
    or ev_fam_insee is not null or ev_fam_dept is not null
    or ev_fam_region is not null or ev_fam_pays is not null))
  into :ev_ind_ville
    ,:ev_ind_cp
    ,:ev_ind_dept
    ,:ev_ind_region
    ,:ev_ind_pays
    ,:ev_ind_insee
    ,:ev_ind_subd
    ,:ev_ind_latitude
    ,:ev_ind_longitude
  do
    suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par André Langlet le 05/09/2006
Dernières modifications le 07/02/2012'
  where RDB$PROCEDURE_NAME = 'PROC_PREP_VILLES_FAVORIS';

SET TERM ^ ;
ALTER PROCEDURE PROC_PREP_VILLES_RAYON (
    LIMITE Double precision,
    LATITUDEA Double precision,
    LONGITUDEA Double precision,
    I_DOSSIER Integer )
RETURNS (
    CP_CODE Integer,
    CP_CP Varchar(8),
    CP_PREFIXE Varchar(4),
    CP_VILLE Varchar(103),
    CP_INDIC_TEL Varchar(2),
    CP_DEPT Integer,
    CP_REGION Integer,
    CP_PAYS Integer,
    CP_INSEE Varchar(6),
    CP_HABITANTS Double precision,
    CP_DENSITE Double precision,
    CP_DIVERS Varchar(90),
    CP_LATITUDE Double precision,
    CP_LONGITUDE Double precision,
    CP_MAJ_INSEE Integer,
    CP_VILLE_MAJ Varchar(50),
    DISTANCE Double precision,
    DEPARTEMENT Varchar(30),
    REGION Varchar(50),
    PAYS Varchar(30) )
AS
declare variable degrad double precision;
declare variable sinlat double precision;
declare variable coslat double precision;
declare variable deltalat double precision;
declare variable deltalong double precision;
declare variable latmax double precision;
declare variable latmin double precision;
declare variable longmax double precision;
declare variable longmin double precision;
declare variable ok integer;
begin
degrad=pi()/180;
sinlat=sin(latitudea*degrad);
coslat=cos(latitudea*degrad);
deltalat=limite/6367;
latmax=latitudea+deltalat/degrad;
latmin=latitudea-deltalat/degrad;
if (latmax>90 or latmin<-90) then
begin
   longmax=180;
   longmin=-180;
end
else
begin
   deltalong=asin(deltalat/coslat)/degrad;
   longmax=longitudea+deltalong;
   longmin=longitudea-deltalong;
end
  for
  select ev_ind_cp,
         coalesce(ev_ind_ville,'')||coalesce(' - '||ev_ind_subd,''),
         ev_ind_insee,
         ev_ind_latitude,
         ev_ind_longitude,
         ev_ind_dept,
         ev_ind_region,
         ev_ind_pays
  from proc_prep_villes_favoris(:i_dossier)
  where ev_ind_ville is not null
    and ev_ind_latitude between :latmin and :latmax
    and (ev_ind_longitude between :longmin and :longmax
         or ev_ind_longitude between :longmin+360 and 180
         or ev_ind_longitude between -180 and :longmax-360)
  into
        :cp_cp,
        :cp_ville,
        :cp_insee,
        :cp_latitude,
        :cp_longitude,
        :departement,
        :region,
        :pays
  do
  begin
    if (cp_latitude=latitudea and cp_longitude=longitudea) then
    begin
       distance=0;
       suspend;
    end
    else
    begin
       distance=6367*acos(sinlat*sin(cp_latitude*degrad)+coslat*cos(cp_latitude*degrad)*cos((longitudea-cp_longitude)*degrad));
       if (distance<=limite) then
          suspend;
    end
  end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'création par André 2006
Dernière modification le 31/08/2012 suppression calcul sur REF_CP_VILLE
Utilisations:Villes voisines Ancestromania et Cassinivision'
  where RDB$PROCEDURE_NAME = 'PROC_PREP_VILLES_RAYON';

SET TERM ^ ;
ALTER PROCEDURE PROC_PURGE_IMPORT_GEDCOM (
    I_CLEF Integer,
    I_MODE Integer )
RETURNS (
    INFO Varchar(50) )
AS
declare variable i_indiv integer;
declare variable i_ind integer;
declare variable i_count integer;
declare variable i_dossier integer;
declare variable i integer;
begin
  if (i_mode=3) then
  begin
    update individu set id_import_gedcom=null where id_import_gedcom=:i_clef;
    update evenements_fam set id_import_gedcom=null where id_import_gedcom=:i_clef;
    update multimedia set id_import_gedcom=null where id_import_gedcom=:i_clef;
    delete from t_import_gedcom where ig_id=:i_clef;
    info='Traces de l''importation supprimées';
    suspend;
    exit;
  end
  select count(distinct kle_dossier) from individu
         where id_import_gedcom=:i_clef
         into :i_count;
  if (i_count>1) then
    begin
      info='Plusieurs dossiers dans le groupe';
      suspend;
      exit;
    end
  delete from tq_id; --création d'une table temporaire des associations dans les 2 sens
  for select a.assoc_kle_ind,a.assoc_kle_associe from t_associations a
          where a.assoc_table='I'
            and a.assoc_kle_ind>0
            and a.assoc_kle_associe>0
            and a.assoc_kle_associe not in (select "ID2" from tq_id where "ID1"=a.assoc_kle_ind)
          into :i_ind,:i_indiv
        do
        begin
          insert into tq_id ("ID1","ID2") values(:i_ind,:i_indiv);
          if (i_ind<>i_indiv) then
            insert into tq_id ("ID1","ID2") values(:i_indiv , :i_ind);
        end
  for select a.assoc_kle_associe,u.union_mari from t_associations a
               inner join evenements_fam e on e.ev_fam_clef=a.assoc_evenement
               inner join t_union u on u.union_clef=e.ev_fam_kle_famille
               where a.assoc_table='U'
                 and u.union_mari>0
                 and a.assoc_kle_associe>0
                 and a.assoc_kle_associe not in (select "ID2" from tq_id where "ID1"=u.union_mari)
               into :i_ind,:i_indiv
        do
        begin
          insert into tq_id ("ID1","ID2") values(:i_ind,:i_indiv);
          if (i_ind<>i_indiv) then
            insert into tq_id ("ID1","ID2") values(:i_indiv,:i_ind);
        end
  for select a.assoc_kle_associe,u.union_femme from t_associations a
               inner join evenements_fam e on e.ev_fam_clef=a.assoc_evenement
               inner join t_union u on u.union_clef=e.ev_fam_kle_famille
               where a.assoc_table='U'
                 and u.union_femme>0
                 and a.assoc_kle_associe>0
                 and a.assoc_kle_associe not in (select "ID2" from tq_id where "ID1"=u.union_femme)
               into :i_ind,:i_indiv
        do
        begin
          insert into tq_id ("ID1","ID2") values(:i_ind,:i_indiv);
          if (i_ind<>i_indiv) then
            insert into tq_id ("ID1","ID2") values(:i_indiv,:i_ind);
        end
  delete from tq_ascendance;
  if (i_mode=1) then  --suppression des enregistrements
    begin
      insert into tq_ascendance (tq_cle_fiche,tq_niveau)
        select cle_fiche,0 from individu where id_import_gedcom=:i_clef;
      select count(*) from tq_ascendance into :i;
      i_count=i+1;
      while (i<i_count) do
      begin
        i_count=i;
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
        --ne pas supprimer s'il est père ou mère d'un individu hors importation
        and exists (select 1 from individu i
                     where (i.cle_pere=tq.tq_cle_fiche or i.cle_mere=tq.tq_cle_fiche)
                       and (i.id_import_gedcom<>:i_clef or i.id_import_gedcom is null
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
         --ne pas supprimer s'il est marié à une femme hors importation
         and exists (select 1 from individu i,
                                  t_union u
                    where u.union_mari=tq.tq_cle_fiche
                      and i.cle_fiche=u.union_femme
                      and (i.id_import_gedcom<>:i_clef or i.id_import_gedcom is null
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
         --ne pas supprimer s'il est marié à un mari hors importation
         and exists (select 1 from individu i,
                                  t_union u
                    where u.union_femme=tq.tq_cle_fiche
                      and i.cle_fiche=u.union_mari
                      and (i.id_import_gedcom<>:i_clef or i.id_import_gedcom is null
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
         --ne pas supprimer son père est un individu hors importation
         and exists (select 1 from individu i,
                                  individu e
                     where e.cle_fiche=tq.tq_cle_fiche
                       and i.cle_fiche=e.cle_pere
                       and (i.id_import_gedcom<>:i_clef or i.id_import_gedcom is null
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
         --ne pas supprimer sa mère est un individu hors importation
         and exists (select 1 from individu i,
                                  individu e
                     where e.cle_fiche=tq.tq_cle_fiche
                       and i.cle_fiche=e.cle_mere
                       and (i.id_import_gedcom<>:i_clef or i.id_import_gedcom is null
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
         --ne pas supprimer s'il est associé à un individu hors importation
         and exists (select 1 from individu i
                    inner join tq_id t on t.id2=i.cle_fiche
                    where t.id1=tq.tq_cle_fiche
                      and (i.id_import_gedcom<>:i_clef or i.id_import_gedcom is null
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        select count(*) from tq_ascendance where tq_niveau=0 into :i;
      end
      delete from tq_ascendance where tq_niveau=1;
    end
  else  --I_MODE=2 élagage
    begin
      select distinct kle_dossier from individu
         where id_import_gedcom=:i_clef
         into :i_dossier;
      insert into tq_ascendance (tq_cle_fiche,tq_niveau)
      select cle_fiche,0 from individu
       where kle_dossier=:i_dossier
         and (id_import_gedcom<>:i_clef or id_import_gedcom is null);
      select count(*) from tq_ascendance into :i;
      i_count=i+1;
      while (i<i_count) do
      begin
        i_count=i;
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
        --ne pas supprimer s'il est père ou mère d'un individu de l'importation
        and exists (select 1 from individu i
                     where (i.cle_pere=tq.tq_cle_fiche or i.cle_mere=tq.tq_cle_fiche)
                       and (i.id_import_gedcom=:i_clef
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
         --ne pas supprimer sa femme est un individu de l'importation
         and exists (select 1 from t_union u,
                                  individu i
                    where u.union_mari=tq.tq_cle_fiche
                      and i.cle_fiche=u.union_femme
                      and (i.id_import_gedcom=:i_clef
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
         --ne pas supprimer son mari est un individu de l'importation
         and exists (select 1 from t_union u,
                                  individu i
                    where u.union_femme=tq.tq_cle_fiche
                      and i.cle_fiche=u.union_mari
                      and (i.id_import_gedcom=:i_clef
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
         --ne pas supprimer son père est un individu de l'importation
         and exists (select 1 from individu i,
                                  individu e
                     where e.cle_fiche=tq.tq_cle_fiche
                       and i.cle_fiche=e.cle_pere
                       and (i.id_import_gedcom=:i_clef
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
         --ne pas supprimer sa mère est un individu de l'importation
         and exists (select 1 from individu i,
                                  individu e
                     where e.cle_fiche=tq.tq_cle_fiche
                       and i.cle_fiche=e.cle_mere
                       and (i.id_import_gedcom=:i_clef
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        update tq_ascendance tq set tq_niveau=1
        where tq_niveau=0
         --ne pas supprimer s'il est associé à un individu de l'importation
         and exists (select 1 from individu i
                    inner join tq_id t on t.id2=i.cle_fiche
                    where t.id1=tq.tq_cle_fiche
                      and (i.id_import_gedcom=:i_clef
                            or exists (select 1 from tq_ascendance where tq_niveau=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        select count(*) from tq_ascendance where tq_niveau=0 into :i;
      end
      delete from tq_ascendance where tq_niveau=1;
    end
  delete from tq_id;
  select cast(count(tq_cle_fiche) as varchar(20))||' individus supprimés' from tq_ascendance
      into :info;
  delete from individu i where exists (select 1 from tq_ascendance
                                    where tq_cle_fiche=i.cle_fiche);
  update individu i set i.cle_pere=null where exists (select 1 from tq_ascendance
                                                      where tq_cle_fiche=i.cle_pere);
  update individu i set i.cle_mere=null where exists (select 1 from tq_ascendance
                                                      where tq_cle_fiche=i.cle_mere);
  delete from evenements_ind e where exists (select 1 from tq_ascendance
                                             where tq_cle_fiche=e.ev_ind_kle_fiche);
  update t_union u set u.union_mari=null where exists (select 1 from tq_ascendance
                                                       where tq_cle_fiche=u.union_mari);
  update t_union u set u.union_femme=null where exists (select 1 from tq_ascendance
                                                       where tq_cle_fiche=u.union_femme);
  delete from t_union where union_mari is null and union_femme is null;
  delete from t_union t where (t.union_mari is null and not exists (select 1 from individu
                               where cle_mere=t.union_femme))
                           or (t.union_femme is null and not exists (select 1 from individu
                               where cle_pere=t.union_mari));
  delete from evenements_fam e where exists (select 1 from t_union
                                             where union_clef=e.ev_fam_kle_famille
                                               and (union_mari is null
                                                or union_femme is null));
  delete from media_pointeurs mp where not exists (select 1 from individu
                                                where cle_fiche=mp.mp_cle_individu);
  delete from tq_ascendance;
  if (i_mode=1) then  --suppression des enregistrements multimédia
    delete from multimedia m where m.id_import_gedcom=:i_clef
                             and not exists (select 1 from media_pointeurs
                                             where mp_media=m.multi_clef);
  else  --I_MODE=2
    delete from multimedia m where multi_dossier=:i_dossier
                               and (m.id_import_gedcom<>:i_clef or m.id_import_gedcom is null)
                               and not exists (select 1 from media_pointeurs
                                             where mp_media=m.multi_clef);
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée le :05/03/2006 par André Langlet.
le 28/07/2006 ajout mode 3
le 17/01/2007 liaison des "importés" étendue au delà des liens directs
le 25/10/2010 suppression références à ADRESSES_IND
Description : permet de purger la base d''un import gedcom selectionné
Usage       :I_MODE=1 pour supprimer les éléments de l''importation I_CLEF
                    2 pour ne garder dans le dossier que ces éléments
                    3 pour effacer les traces de l''import'
  where RDB$PROCEDURE_NAME = 'PROC_PURGE_IMPORT_GEDCOM';

SET TERM ^ ;
ALTER PROCEDURE PROC_RENUM_SOSA (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_DOSSIER Integer )
AS
DECLARE VARIABLE I_INDI INTEGER;
DECLARE VARIABLE D_SOSA DOUBLE PRECISION;
DECLARE VARIABLE TESTS INTEGER;
DECLARE VARIABLE TESTD INTEGER;
begin
  select kle_dossier from individu where cle_fiche=:i_clef
  into :i_dossier;
  select rdb$set_context('USER_TRANSACTION','ACTIVE_MAJ_SOSA',null)
    from rdb$database into :tests;
  select rdb$set_context('USER_TRANSACTION','INACTIVE_MAJ_DATE','1')
    from rdb$database into :testd;
  update INDIVIDU
    SET  NUM_SOSA=null,type_lien_gene=0
    WHERE KLE_DOSSIER=:i_dossier;
  for SELECT tq_cle_fiche,TQ_SOSA
      FROM proc_tq_ascendance(:i_clef,:i_niveau,0,0)
      into :i_indi,:d_sosa
  do
    update INDIVIDU
    SET NUM_SOSA=:d_sosa
    WHERE cle_fiche=:i_indi;
  if (testd=0) then
    rdb$set_context('USER_TRANSACTION','INACTIVE_MAJ_DATE',null);
  if (tests=1) then
    rdb$set_context('USER_TRANSACTION','ACTIVE_MAJ_SOSA','1');
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Cette procedure permet de faire une renumérotation SOSA de tous les
individus.
Modifiée le : 01/10/2007 par André: utilisation de proc_tq_ascendance
le 26/10/2008 ajout type_lien_gene
le 13/11/2008 mise à jour des variables du context'
  where RDB$PROCEDURE_NAME = 'PROC_RENUM_SOSA';

SET TERM ^ ;
ALTER PROCEDURE PROC_SEPARATION_PRENOMS (
    I_DOSSIER Integer,
    I_VIRGULE Integer )
AS
DECLARE VARIABLE NOUVEAU_NOM VARCHAR(60);
DECLARE VARIABLE SEPARATION INTEGER;
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE I_LEN INTEGER;
DECLARE VARIABLE CHAINE VARCHAR(60);
DECLARE VARIABLE CAR VARCHAR(1);
DECLARE VARIABLE CLEF INTEGER;
begin
   /*---------------------------------------------------------------------------
   Créée le : 26/08/2006 par André
   Description : Cette procédure modifie le séparateur dans les prénoms
   Usage       : I_VIRGULE=0 : met un seul espace de séparation
                      I_VIRGULE=1 : met une virgule et un espace de séparation
   ---------------------------------------------------------------------------*/
  for select cle_fiche,TRIM(prenom)
          from individu
          where KLE_DOSSIER=:I_DOSSIER
          into :clef,
               :CHAINE
  do
  begin
    while (char_length(CHAINE)>0
       and substring(CHAINE from 1 for 1) in(' ',',')) do
      CHAINE=substring(CHAINE from 2);
    while (char_length(CHAINE)>0
       and substring(CHAINE from char_length(CHAINE)) in(' ',',')) do
      CHAINE=substring(CHAINE from 1 for char_length(CHAINE)-1);
    I_LEN=char_length(chaine);
    NOUVEAU_NOM='';
    SEPARATION=0;
    I=1;
    while (I<=I_LEN) do
    begin
      CAR=substring(chaine from i for 1);
      if (CAR in (' ',',')) then
        SEPARATION=1;
      else
      begin
        if (SEPARATION=1) then
        begin
          if (I_VIRGULE=1) then
            NOUVEAU_NOM=NOUVEAU_NOM||', ';
          else
            NOUVEAU_NOM=NOUVEAU_NOM||' ';
          SEPARATION=0;
        end
        NOUVEAU_NOM=NOUVEAU_NOM||CAR;
      end
      I=I+1;
    end
    update individu
    set prenom=:NOUVEAU_NOM
    where CLE_FICHE=:CLEF;
  end
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_SOSAS (
    I_CLEF Integer )
RETURNS (
    SOSAS Varchar(30) )
AS
DECLARE VARIABLE I SMALLINT;
DECLARE VARIABLE D_SOSA DOUBLE PRECISION;
DECLARE VARIABLE S_SOSA VARCHAR(15);
DECLARE VARIABLE C INTEGER;
DECLARE VARIABLE P INTEGER;
begin
   /*---------------------------------------------------------------------------
   Procédure créée par André le 18/10/2007.
   Retourne dans une chaîne de caractères la génération d'un individu,
   son premier numéro sosa s'il fait moins de 10 chiffres, suivi si
   nécessaire du nombre de fois qu'il est implexe.
   ---------------------------------------------------------------------------*/
  select num_sosa
  from individu
  where cle_fiche=:i_clef
  into :d_sosa;
  if (d_sosa=1.0) then
    sosas='G:1 S:1';
  else
  begin
    i=0;
    for select case :i_clef
               when i.cle_pere then i.num_sosa*2
               else i.num_sosa*2+1
               end
              ,:i+1
        from individu i
        where :i_clef in (i.cle_pere,i.cle_mere)
          and i.num_sosa is not null
        order by i.num_sosa
        into :d_sosa
            ,:i
        do
        begin
          if (i=1) then
            if (d_sosa<1e+10) then
            begin
              s_sosa=cast(cast(d_sosa as bigint)as varchar(15));
              p=char_length(s_sosa);
              c=0;
              sosas='';
              while (p>0) do
              begin
                if (c=3) then
                begin
                  sosas=' '||sosas;
                  c=0;
                end
                sosas=substring(s_sosa from p for 1)||sosas;
                p=p-1;
                c=c+1;
              end
              sosas='G:'||cast(cast(floor(ln(d_sosa)/ln(2)+1) as smallint)
                               as varchar(3))||' S:'||sosas;
            end
            else
              sosas='G:'||cast(cast(floor(ln(d_sosa)/ln(2)+1) as smallint)
                                           as varchar(3));
        end
    if (i>1) then
      sosas=sosas||' +I:'||(i-1);
  end
  suspend;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_SUIVANT (
    IND_ORIGINE Integer,
    DELTA Integer )
RETURNS (
    CLE_FICHE Integer )
AS
DECLARE VARIABLE DOSSIER INTEGER;
DECLARE VARIABLE NOM VARCHAR(40);
DECLARE VARIABLE PRENOM VARCHAR(60);
begin
/*Procédure créée par André*/
  select kle_dossier,nom,prenom from individu
  where cle_fiche=:ind_origine
  into :dossier,:nom,:prenom;
  if (delta>0) then
    for select first (1) skip(:delta-1) cle_fiche
        from individu
        where kle_dossier=:dossier
          and ((nom>:nom)
               or (nom=:nom and prenom>:prenom)
               or (nom=:nom and prenom=:prenom and cle_fiche>:ind_origine))
        order by nom
                ,prenom
                ,cle_fiche
        into :cle_fiche
    do
      suspend;
  if (delta<0) then
    for select first (1) skip(-:delta-1) cle_fiche
        from individu
        where kle_dossier=:dossier
          and ((nom<:nom)
               or (nom=:nom and prenom<:prenom)
               or (nom=:nom and prenom=:prenom and cle_fiche<:ind_origine))
        order by nom desc
                ,prenom desc
                ,cle_fiche desc
        into :cle_fiche
    do
      suspend;
  if (cle_fiche is null) then
  begin
    if (delta<0) then
      select first (1) cle_fiche
      from individu
      where kle_dossier=:dossier
      order by nom
              ,prenom
              ,cle_fiche
      into :cle_fiche;
    else
      if (delta>0) then
        select first (1) cle_fiche
        from individu
        where kle_dossier=:dossier
        order by nom desc
                ,prenom desc
                ,cle_fiche desc
        into :cle_fiche;
      else
        cle_fiche=ind_origine;
    suspend;
  end
end
^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_TEST_ASC (
    INDI1 Integer,
    INDI2 Integer,
    IGNORENFANT Integer DEFAULT 0 )
RETURNS (
    NIVEAU Integer )
AS
declare variable present integer;
declare variable pere integer;
declare variable mere integer;
declare variable id integer;
begin
  niveau=0;
  if (indi1=indi2) then
  begin
    suspend;
    exit;
  end
  id=gen_id(gen_tq_id,1);
  insert into tq_ascendance (tq_dossier,tq_cle_fiche,tq_niveau) values(:id,:indi1,:niveau);
  present=1;
  while (present=1) do
  begin
    present=0;
    for select i.cle_pere,i.cle_mere from tq_ascendance t
    inner join individu i on i.cle_fiche=t.tq_cle_fiche
    where t.tq_dossier=:id and t.tq_niveau=:niveau
    into :pere,:mere
    do
    begin
      if (((pere=indi2)or(mere=indi2))and((ignorenfant=0)or(niveau>0))) then
      begin
        present=0;
        niveau=niveau+1;
        suspend;
        leave;
      end
      else
      begin
        insert into tq_ascendance (tq_dossier,tq_cle_fiche,tq_niveau)
        select :id,:pere,:niveau+1 from rdb$database
        where :pere is not null and not exists (select 1 from tq_ascendance where tq_dossier=:id and tq_cle_fiche=:pere);
        if (row_count>0) then
          present=1;
        insert into tq_ascendance (tq_dossier,tq_cle_fiche,tq_niveau)
        select :id,:mere,:niveau+1 from rdb$database
        where :mere is not null and not exists (select 1 from tq_ascendance where tq_dossier=:id and tq_cle_fiche=:mere);
        if (row_count>0) then
          present=1;
      end
    end
    niveau=niveau+1;
  end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée le 13/04/2011 par André Langlet.
Permet de vérifier si INDI2 est dans l''ascendance de INDI1.'
  where RDB$PROCEDURE_NAME = 'PROC_TEST_ASC';

SET TERM ^ ;
ALTER PROCEDURE PROC_TEST_DESC (
    INDI1 Integer,
    INDI2 Integer,
    IGNORENFANT Integer DEFAULT 0 )
RETURNS (
    NIVEAU Integer )
AS
declare variable present integer;
declare variable enfant integer;
declare variable id integer;
begin
  niveau=0;
  if (indi1=indi2) then
  begin
    suspend;
    exit;
  end
  id=gen_id(gen_tq_id,1);
  insert into tq_ascendance (tq_dossier,tq_cle_fiche,tq_niveau) values(:id,:indi1,:niveau);
  present=1;
  while (present=1) do
  begin
    present=0;
    for select i.cle_fiche from tq_ascendance t
    inner join individu i on i.cle_pere=t.tq_cle_fiche or i.cle_mere=t.tq_cle_fiche
    where t.tq_dossier=:id and t.tq_niveau=:niveau
    into :enfant
    do
    begin
      if ((enfant=indi2)and((ignorenfant=0)or(niveau>0))) then
      begin
        present=0;
        niveau=niveau+1;
        suspend;
        leave;
      end
      else
      begin
        insert into tq_ascendance (tq_dossier,tq_cle_fiche,tq_niveau)
        select :id,:enfant,:niveau+1 from rdb$database
        where :enfant is not null and not exists (select 1 from tq_ascendance where tq_dossier=:id and tq_cle_fiche=:enfant);
        if (row_count>0) then
          present=1;
      end
    end
    niveau=niveau+1;
  end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée le 14/04/2011 par André Langlet.
Permet de vérifier si INDI2 est dans la descendance de INDI1.'
  where RDB$PROCEDURE_NAME = 'PROC_TEST_DESC';

SET TERM ^ ;
ALTER PROCEDURE PROC_TEST_PARENTE (
    INDI1 Integer,
    INDI2 Integer,
    NIVEAU_MAX Integer )
RETURNS (
    OUI Integer )
AS
declare variable i integer;
declare variable idxd integer;
declare variable idxf integer;
declare variable idt integer;
declare variable ipere integer;
declare variable imere integer;
declare variable imemo integer;
declare variable niveau integer;
begin
  delete from tq_consang;
  if (niveau_max=0) then niveau_max=10;
  insert into tq_consang (id,indi) values (1,:indi1);
  i=1;
  idxd=0;
  idxf=i;
  niveau=0;
  while (idxf>idxd and niveau<niveau_max) do
  begin
    for select indi from tq_consang where id>:idxd and id<=:idxf
      into :idt
      do
      begin
        select cle_pere,cle_mere from individu
        where cle_fiche=:idt
        into :ipere,:imere;
        if (ipere>0) then
        begin
          i=i+1;
          insert into tq_consang (id,indi) values (:i,:ipere);
        end
        if (imere>0) then
        begin
          i=i+1;
          insert into tq_consang (id,indi) values (:i,:imere);
        end
      end
    idxd=idxf;
    idxf=i;
    niveau=niveau+1;
  end
  imemo=i;
  i=i+1;
  insert into tq_consang (id,indi) values (:i,:indi2);
  idxf=i;
  niveau=0;
  while (idxf>idxd and niveau<niveau_max) do
  begin
    for select indi from tq_consang where id>:idxd and id<=:idxf
      into :idt
      do
      begin
        select cle_pere,cle_mere from individu
        where cle_fiche=:idt
        into :ipere,:imere;
        if (ipere>0) then
        begin
          i=i+1;
          insert into tq_consang (id,indi) values (:i,:ipere);
        end
        if (imere>0) then
        begin
          i=i+1;
          insert into tq_consang (id,indi) values (:i,:imere);
        end
      end
    idxd=idxf;
    idxf=i;
    niveau=niveau+1;
  end
  select 1 from rdb$database where exists(
  select * from tq_consang i1,tq_consang i2
  where i1.id>0 and i1.id<=:imemo
    and i2.id>:imemo
    and i1.indi=i2.indi)
  into oui;
  suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Recréation André Langlet le 10/03/2012.'
  where RDB$PROCEDURE_NAME = 'PROC_TEST_PARENTE';

SET TERM ^ ;
ALTER PROCEDURE PROC_TQ_ASCENDANCE (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_PARQUI Integer,
    I_MODE Integer )
RETURNS (
    TQ_NIVEAU Integer,
    TQ_CLE_FICHE Integer,
    TQ_SOSA Double precision,
    TQ_DOSSIER Integer,
    IMPLEXE Double precision,
    TQ_DESCENDANT Integer )
AS
DECLARE VARIABLE I_COUNT INTEGER;
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE SOSA DOUBLE PRECISION;
begin
  /*---------------------------------------------------------------------------
  Copyright Philippe Cazaux-Moutou. Tout droits réservés.
  Créé le : 31/07/2001
  à : 18:10:14
  Procédure séparée le :12/02/2006 par André, 19/10/2006 ajout conjoint de
  l'ascendant dans tq_dossier.
  par :
  Description : Cette procedure permet de récuperer la fam d'un individu
  dans la table temporaire TQ_ARBREREDUIT
  Le remplissage de la table est fonction de Niveaux
  0 - Lui Meme
  1 - Parents
  x - les autres
  I_PARQUI : 1 par les hommes
             2 par les femmes
             0 tous
  I_MODE : 0 pas d'implexes
           1 les implexes en plus
           2 tous les ascendants
  ---------------------------------------------------------------------------*/
  i = 0;
  /* purge de la table pour le meme proprio de la table ---------------------*/
  delete from TQ_ARBREREDUIT;
  /*lui meme-----------------------------------------------------------------*/
  insert into TQ_ARBREREDUIT (tq_niveau,tq_cle_fiche,tq_sosa)
         values (0,:i_clef,1);
  I_COUNT=1;
  /*Tous les ancetres -------------------------------------------------------*/
  IF (I_MODE=1) THEN
    while (:i_count>0) do
    begin
         FOR SELECT tq_cle_fiche,TQ_SOSA FROM tq_arbrereduit
           WHERE tq_niveau =:i and IMPLEXE IS NULL
           ORDER BY TQ_SOSA
           INTO :I_CLEF,:SOSA
           DO
           BEGIN /*Par les hommes */
             if (I_PARQUI=1 or I_PARQUI=0) then
               insert into TQ_ARBREREDUIT
                      (tq_niveau,tq_cle_fiche,tq_dossier,tq_sosa,IMPLEXE,tq_descendant)
               select :i+1,i.cle_pere,i.cle_mere,:SOSA*2,
                      (SELECT TQ_SOSA FROM TQ_ARBREREDUIT
                      WHERE tq_cle_fiche=i.cle_pere AND IMPLEXE IS NULL),:i_clef
                  from individu i
                  WHERE i.cle_fiche =:I_CLEF
                    AND i.CLE_PERE IS NOT NULL;
             /*Par les femmes */
             if (I_PARQUI =2 or I_PARQUI =0) then
               insert into TQ_ARBREREDUIT
                      (tq_niveau,tq_cle_fiche,tq_dossier,tq_sosa,IMPLEXE,tq_descendant)
               select :i+1,i.cle_mere,i.cle_pere,:SOSA*2+1,
                      (SELECT TQ_SOSA FROM TQ_ARBREREDUIT
                      WHERE tq_cle_fiche=i.cle_mere AND IMPLEXE IS NULL),:i_clef
                  from individu i
                  WHERE i.cle_fiche =:I_CLEF
                    AND i.CLE_MERE IS NOT NULL;
           END
           i=i+1;
           Select Count(0) from tq_arbrereduit where tq_niveau=:i into :i_Count;
           if (I_NIVEAU>0) then if (i = I_NIVEAU) then I_COUNT=0;
    end
  ELSE IF (I_MODE=2) THEN
    while (:i_count>0) do
    begin
         FOR SELECT tq_cle_fiche,TQ_SOSA FROM tq_arbrereduit
           WHERE tq_niveau =:i
           ORDER BY TQ_SOSA
           INTO :I_CLEF,:SOSA
           DO
           BEGIN /*Par les hommes */
             if (I_PARQUI=1 or I_PARQUI=0) then
               insert into TQ_ARBREREDUIT
                      (tq_niveau,tq_cle_fiche,tq_dossier,tq_sosa,IMPLEXE,tq_descendant)
               select :i+1,i.cle_pere,i.cle_mere,:SOSA*2,
                      (SELECT TQ_SOSA FROM TQ_ARBREREDUIT
                      WHERE tq_cle_fiche=i.cle_pere AND IMPLEXE IS NULL),:i_clef
                  from individu i
                  WHERE i.cle_fiche =:I_CLEF
                    AND i.CLE_PERE IS NOT NULL;
             /*Par les femmes */
             if (I_PARQUI =2 or I_PARQUI =0) then
               insert into TQ_ARBREREDUIT
                      (tq_niveau,tq_cle_fiche,tq_dossier,tq_sosa,IMPLEXE,tq_descendant)
               select :i+1,i.cle_mere,i.cle_pere,:SOSA*2+1,
                      (SELECT TQ_SOSA FROM TQ_ARBREREDUIT
                      WHERE tq_cle_fiche=i.cle_mere AND IMPLEXE IS NULL),:i_clef
                  from individu i
                  WHERE i.cle_fiche =:I_CLEF
                    AND i.CLE_MERE IS NOT NULL;
           END
           i=i+1;
           Select Count(0) from tq_arbrereduit where tq_niveau=:i into :i_Count;
           if (I_NIVEAU>0) then if (i = I_NIVEAU) then I_COUNT=0;
    end
  ELSE
    while (:i_count>0) do
    begin
         FOR SELECT tq_cle_fiche,TQ_SOSA FROM tq_arbrereduit
           WHERE tq_niveau =:i
           ORDER BY TQ_SOSA
           INTO :I_CLEF,:SOSA
           DO
           BEGIN /*Par les hommes */
             if (I_PARQUI=1 or I_PARQUI=0) then
               insert into TQ_ARBREREDUIT
                      (tq_niveau,tq_cle_fiche,tq_dossier,tq_sosa,tq_descendant)
               select :i+1,i.cle_pere,i.cle_mere,:SOSA*2,:i_clef
                  from individu i
                  WHERE i.cle_fiche =:I_CLEF
                    AND i.CLE_PERE IS NOT NULL
                    AND NOT exists (select 1 FROM TQ_ARBREREDUIT
                                           where tq_cle_fiche=i.CLE_PERE);
             /*Par les femmes */
             if (I_PARQUI =2 or I_PARQUI =0) then
               insert into TQ_ARBREREDUIT
                      (tq_niveau,tq_cle_fiche,tq_dossier,tq_sosa,tq_descendant)
               select :i+1,i.cle_mere,i.cle_pere,:SOSA*2+1,:i_clef
                  from individu i
                  WHERE i.cle_fiche =:I_CLEF
                    AND i.CLE_MERE IS NOT NULL
                    AND NOT exists (select 1 FROM TQ_ARBREREDUIT
                                           where tq_cle_fiche=i.CLE_MERE);
           END
           i=i+1;
           Select Count(0) from tq_arbrereduit where tq_niveau=:i into :i_Count;
           if (I_NIVEAU>0) then if (i = I_NIVEAU) then I_COUNT=0;
    end
  for select tq_niveau
            ,tq_cle_fiche
            ,tq_sosa
            ,tq_dossier
            ,implexe
            ,tq_descendant
      from tq_arbrereduit
      into :tq_niveau
          ,:tq_cle_fiche
          ,:tq_sosa
          ,:tq_dossier
          ,:implexe
          ,:tq_descendant
      do suspend;
  delete from TQ_ARBREREDUIT;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_TQ_DESCENDANCE (
    I_CLEF Integer,
    I_NIVEAU Integer,
    I_PARQUI Integer,
    I_MODE Integer )
RETURNS (
    TQ_NIVEAU Integer,
    TQ_CLE_FICHE Integer,
    TQ_SOSA Varchar(120),
    TQ_CLE_PERE Integer,
    TQ_CLE_MERE Integer,
    TQ_NUM_SOSA Varchar(120),
    TQ_ASCENDANT Integer )
AS
declare variable i_count integer;
declare variable i integer;
declare variable j integer;
declare variable i_num_sosa varchar(120);
declare variable i_fiche integer;
declare variable i_pere integer;
declare variable i_mere integer;
declare variable sj char(1);
begin
  i = 1;
  delete from tq_arbredescendant;
  insert into tq_arbredescendant
          (tq_niveau,tq_cle_fiche,tq_num_sosa,tq_cle_pere,tq_cle_mere)
          select 1,:i_clef,'1',cle_pere,cle_mere
          from individu
          where cle_fiche=:i_clef;
  if (i_niveau=1) then
    i_count=0;
  else
    select count(1)
    from tq_arbredescendant
    where tq_niveau=:i into :i_count;
  if (i_mode=1) then --un seul niveau d'implexe
  begin
    while (i_count>0) do
    begin
      i_count=0;
      for select tq_cle_fiche,tq_num_sosa from tq_arbredescendant
          where tq_niveau=:i and tq_sosa is null
          order by tq_num_sosa
          into :i_clef,:i_num_sosa
      do
      begin
        j=0;
        for select i.cle_fiche,i.cle_pere,i.cle_mere
            from individu i
            where i.cle_pere=:i_clef or i.cle_mere=:i_clef
            order by i.cle_parents nulls last
              ,(select first(1)ev_ind_datecode*1440+extract(hour from ev_ind_heure)*60+extract(minute from ev_ind_heure)
                from evenements_ind where ev_ind_kle_fiche=i.cle_fiche
                order by ev_ind_datecode nulls last,ev_ind_heure nulls last) nulls last
        into :i_fiche,:i_pere,:i_mere
        do
        begin
          j=j+1;
          if (j<10) then sj=cast(j as char(1));
          else sj=ascii_char(j+55);
          insert into tq_arbredescendant
                (tq_niveau,tq_cle_fiche,tq_num_sosa,
                 tq_cle_pere,tq_cle_mere,tq_sosa,tq_ascendant)
          values (:i+1,:i_fiche,:i_num_sosa||:sj,:i_pere,:i_mere,
                 (select tq_num_sosa from tq_arbredescendant
                  where tq_cle_fiche=:i_fiche and tq_sosa is null),:i_clef);
          i_count=1;
        end
      end
      i=i+1;
      if (i_niveau>1 and i=i_niveau) then
        i_count=0;
    end
  end
  else
  if (i_mode=2) then  --tous les implexes
  begin
    while (i_count>0) do
    begin
      i_count=0;
      for select tq_cle_fiche,tq_num_sosa from tq_arbredescendant
          where tq_niveau=:i
          order by tq_num_sosa
          into :i_clef,:i_num_sosa
      do
      begin
        j=0;
        for select i.cle_fiche,i.cle_pere,i.cle_mere
            from individu i
            where i.cle_pere=:i_clef or i.cle_mere=:i_clef
            order by i.cle_parents nulls last
              ,(select first(1)ev_ind_datecode*1440+extract(hour from ev_ind_heure)*60+extract(minute from ev_ind_heure)
                from evenements_ind where ev_ind_kle_fiche=i.cle_fiche
                order by ev_ind_datecode nulls last,ev_ind_heure nulls last) nulls last
            into :i_fiche,:i_pere,:i_mere
        do
        begin
          j=j+1;
          if (j<10) then sj=cast(j as char(1));
          else sj=ascii_char(j+55);
          insert into tq_arbredescendant
                (tq_niveau,tq_cle_fiche,tq_num_sosa,
                 tq_cle_pere,tq_cle_mere,tq_sosa,tq_ascendant)
          values (:i+1,:i_fiche,:i_num_sosa||:sj,:i_pere,:i_mere,
           (select tq_num_sosa from tq_arbredescendant
            where tq_cle_fiche=:i_fiche and tq_sosa is null),:i_clef);
          i_count=1;
        end
      end
      i=i+1;
      if (i_niveau>1 and i=i_niveau) then
        i_count=0;
    end
  end
  else --i_mode=0 sans implexes
  begin
    while (i_count>0) do
    begin
      i_count=0;
      for select tq_cle_fiche,tq_num_sosa from tq_arbredescendant
          where tq_niveau=:i
          order by tq_num_sosa
          into :i_clef,
               :i_num_sosa
      do
      begin
        j=0;
        for select i.cle_fiche,i.cle_pere,i.cle_mere
            from individu i
            where i.cle_pere=:i_clef or i.cle_mere=:i_clef
              and not exists (select 1 from tq_arbredescendant
                              where tq_cle_fiche=i.cle_fiche)
            order by i.cle_parents nulls last
              ,(select first(1)ev_ind_datecode*1440+extract(hour from ev_ind_heure)*60+extract(minute from ev_ind_heure)
                from evenements_ind where ev_ind_kle_fiche=i.cle_fiche
                order by ev_ind_datecode nulls last,ev_ind_heure nulls last) nulls last
            into :i_fiche,:i_pere,:i_mere
        do
        begin
          j=j+1;
          if (j<10) then sj=cast(j as char(1));
          else sj=ascii_char(j+55);
          insert into tq_arbredescendant
            (tq_niveau,tq_cle_fiche,tq_num_sosa,tq_cle_pere,tq_cle_mere,tq_ascendant)
          values (:i+1,:i_fiche,:i_num_sosa||:sj,:i_pere,:i_mere,:i_clef);
          i_count=1;
        end
      end
      i=i+1;
      if (i_niveau>1 and i=i_niveau) then
        i_count=0;
    end
  end
  if (i_parqui=1) then
    for select t.tq_niveau
              ,t.tq_cle_fiche
              ,t.tq_sosa
              ,t.tq_cle_pere
              ,t.tq_cle_mere
              ,t.tq_num_sosa
              ,t.tq_ascendant
        from tq_arbredescendant t
        inner join individu i on i.cle_fiche=t.tq_cle_fiche
        where t.tq_niveau=1
           or (t.tq_niveau=2 and i.sexe=1)
           or (t.tq_ascendant=t.tq_cle_pere and i.sexe=1)
        into :tq_niveau
            ,:tq_cle_fiche
            ,:tq_sosa
            ,:tq_cle_pere
            ,:tq_cle_mere
            ,:tq_num_sosa
            ,:tq_ascendant
    do suspend;
  else
  if (i_parqui=2) then
    for select t.tq_niveau
              ,t.tq_cle_fiche
              ,t.tq_sosa
              ,t.tq_cle_pere
              ,t.tq_cle_mere
              ,t.tq_num_sosa
              ,t.tq_ascendant
        from tq_arbredescendant t
        inner join individu i on i.cle_fiche=t.tq_cle_fiche
        where t.tq_niveau=1
           or (t.tq_niveau=2 and i.sexe=2)
           or (t.tq_ascendant=t.tq_cle_mere and i.sexe=2)
        into :tq_niveau
            ,:tq_cle_fiche
            ,:tq_sosa
            ,:tq_cle_pere
            ,:tq_cle_mere
            ,:tq_num_sosa
            ,:tq_ascendant
    do suspend;
  else
    for select tq_niveau
              ,tq_cle_fiche
              ,tq_sosa
              ,tq_cle_pere
              ,tq_cle_mere
              ,tq_num_sosa
              ,tq_ascendant
        from tq_arbredescendant
        into :tq_niveau
            ,:tq_cle_fiche
            ,:tq_sosa
            ,:tq_cle_pere
            ,:tq_cle_mere
            ,:tq_num_sosa
            ,:tq_ascendant
    do suspend;
  delete from tq_arbredescendant;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée le 10/02/2006 par André Langlet pour servir de référence à
toutes les procédures et requêtes utilisant les calculs de descendance.
2012 ajustement pour éditer plus rapidement les enfants dans l''ordre chronologique
de naissance
Dernière mise à jour: 10/03/2012 par André Langlet.
Codification d''Aboville alphanumérique dans champ TQ_NUM_SOSA
Implexe dans champ TQ_SOSA.
Création I_MODE: 0=sans implexe, 1=un niveau d''implexes, 2=tous les implexes.
Description : Cette procedure permet de récuperer tous les descendants d''un individu.
I_NIVEAU défini le nombre de générations à éditer.
si I_NIVEAU=0 alors toute la descendance de l''individu I_CLEF est éditée.
i_parqui=1 descendance par les hommes, 2 par les femmes, 0 tous.'
  where RDB$PROCEDURE_NAME = 'PROC_TQ_DESCENDANCE';

SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_CONJOINTS (
    I_DOSSIER Integer,
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(60),
    PRENOM Varchar(100),
    DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer,
    DATE_DECES Varchar(100),
    ANNEE_DECES Integer,
    SEXE Integer,
    TYPE_UNION Integer,
    UNION_CLEF Integer,
    SOSA Double precision,
    DATE_MARIAGE Varchar(100),
    ANNEE_MARIAGE Integer,
    CLE_MARIAGE Integer,
    ORDRE_UNION Integer )
AS
begin
  for SELECT p.conjoint
            ,c.NOM
            ,c.PRENOM
            ,c.SEXE
            ,c.NUM_SOSA
            ,c.date_naissance
            ,c.annee_naissance
            ,c.date_deces
            ,c.annee_deces
            ,0
            ,p.clef_union
            ,m.ev_fam_date_writen
            ,m.ev_fam_date_year
            ,p.clef_marr
            ,p.ordre
      from proc_conjoints_ordonnes(:i_clef,0) p
        left join evenements_fam m on m.ev_fam_clef=p.clef_marr
        left join individu c on c.cle_fiche=p.conjoint
        INTO :CLE_FICHE
            ,:NOM
            ,:PRENOM
            ,:SEXE
            ,:SOSA
            ,:DATE_NAISSANCE
            ,:ANNEE_NAISSANCE
            ,:DATE_DECES
            ,:ANNEE_DECES
            ,:TYPE_UNION
            ,:UNION_CLEF
            ,:DATE_MARIAGE
            ,:ANNEE_MARIAGE
            ,:cle_mariage
            ,:ordre_union
     do
     suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par Philippe Cazaux-Moutou le : 31/07/2001 à : 19:32:22 .
Améliorée depuis 2006 et entièrement refaite par André Langlet le 07/04/2009.
Conservée uniquement pour compatibilité avec dllArbres.'
  where RDB$PROCEDURE_NAME = 'PROC_TROUVE_CONJOINTS';

SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_COUSINS_COUSINES (
    I_CLEF Integer,
    I_DOSSIER Integer,
    I_MAX Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    SEXE Integer,
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Double precision )
AS
begin
for select distinct i.cle_fiche,
           i.nom,
           i.prenom,
           i.sexe,
           i.date_naissance,
           i.date_deces,
           i.cle_pere,
           i.cle_mere,
           i.num_sosa
           from proc_trouve_oncles_tantes (:i_clef) p
           inner join individu i on p.cle_fiche in(i.cle_pere,i.cle_mere)
         order by i.nom,i.prenom
         into :cle_fiche,
              :nom,
              :prenom,
              :sexe,
              :date_naissance,
              :date_deces,
              :cle_pere,
              :cle_mere,
              :sosa
    do suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Copyright Philippe Cazaux-Moutou. Tout droits réservés.
Créé le : 31/07/2001
Modifiée le :18/01/2007 I_MAX, I_DOSSIER plus utilisés
utilisation proc_trouve_oncles_tantes
par :André
Dernière modification par André Langlet le 25/07/2009.
Procédure inutile conservée uniquement parce qu''utilisée par LesArbres.dll.'
  where RDB$PROCEDURE_NAME = 'PROC_TROUVE_COUSINS_COUSINES';

SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_DOSSIER (
    I_CLE Integer,
    I_NOM Varchar(30),
    I_INFOS Varchar(254),
    I_LANGUE Varchar(3) )
RETURNS (
    CLE_DOSSIER Integer,
    NOM_DOSSIER Varchar(30),
    DERNIER Integer,
    LANGUE Varchar(3),
    PATH_IMAGES Varchar(254),
    FIC_NOTES Varchar(254),
    INDICATEURS Integer )
AS
begin
   if (i_cle>0) then  --ouverture d'un dossier
     select  cle_dossier,
             nom_dossier,
             coalesce(ds_last,-1),
             ds_langue,
             ds_base_path,
             ds_fic_notes,
             ds_indicateurs
        from dossier
        where cle_dossier=:i_cle
        into :cle_dossier,
             :nom_dossier,
             :dernier,
             :langue,
             :path_images,
             :fic_notes,
             :indicateurs;
   else  --ouverture de la base
     select  first(1) cle_dossier,
             nom_dossier,
             coalesce(ds_last,-1),
             ds_langue,
             ds_base_path,
             ds_fic_notes,
             ds_indicateurs
        from dossier
        where ds_fermeture=(select max(ds_fermeture) from dossier)
        into :cle_dossier,
             :nom_dossier,
             :dernier,
             :langue,
             :path_images,
             :fic_notes,
             :indicateurs;
   if (cle_dossier is null) then
   begin
     select cle_dossier,
            nom_dossier,
            coalesce(ds_last,-1),
            ds_langue,
            ds_base_path,
            ds_fic_notes,
            ds_indicateurs
       from dossier
       where cle_dossier=(select max(cle_dossier) from dossier)
       into :cle_dossier,
            :nom_dossier,
            :dernier,
            :langue,
            :path_images,
            :fic_notes,
            :indicateurs;
     if (cle_dossier is null) then
     begin
       if (char_length(trim(i_nom))=0) then
         i_nom='Mon premier dossier';
       nom_dossier=:i_nom;
       if (char_length(trim(i_infos))=0) then
         i_infos='Ce dossier, est le dossier créé par défaut, '
               ||'vous pouvez changer son nom et ses informations';
       if (char_length(i_langue)=0) then
         i_langue='FRA';
       cle_dossier=gen_id(gen_dossier,-gen_id(gen_dossier,0)+1); --=1
       insert into dossier (cle_dossier,nom_dossier,ds_verrou,ds_infos,ds_langue)
                    values (:cle_dossier,:nom_dossier,0,:i_infos,:i_langue);
       dernier=-1;
     end
   end
   update dossier
     set ds_ouverture='NOW',ds_verrou=1
     where cle_dossier=:cle_dossier;
   update gestion_dll set dll_indi=:dernier,dll_dossier=:cle_dossier;
   if (row_count=0) then
     insert into gestion_dll (dll_indi,dll_dossier)
                      values (:dernier,:cle_dossier);
   suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Créée le : 31/07/2001 par Philippe Cazaux-Moutou.
Modifications par André Langlet:
le 21/05/2007: si I_CLE=0 retourne le dernier dossier ouvert.
le 08/02/2010: ajout des champs LANGUE, FIC_NOTES, INDICATEURS, DERNIER, PATH_IMAGES.
décembre 2010: ajout du champ I_LANGUE en entrée pour toujour définir la langue en sortie.
Description : Retourne un dossier valide, en créant un si nécessaire.'
  where RDB$PROCEDURE_NAME = 'PROC_TROUVE_DOSSIER';

SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_ENFANTS (
    A_CLE_PERE Integer,
    A_CLE_MERE Integer,
    I_DOSSIER Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    SEXE Integer,
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    KLE_DOSSIER Integer,
    SOSA Double precision,
    PHOTO Blob sub_type 0,
    VILLE_NAISS Varchar(166),
    VILLE_DECES Varchar(166),
    ANNEE Integer,
    ANNEE_DECES Integer,
    AGE_DECES Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSAS Varchar(30),
    AGE_PERE Varchar(60),
    AGE_MERE Varchar(60),
    AGE_DECES_TEXTE Varchar(60) )
AS
declare variable langue varchar(3);
begin
  if (a_cle_pere is null) then a_cle_pere=0;
  if (a_cle_mere is null) then a_cle_mere=0;
  if (a_cle_mere=0 and a_cle_pere=0) then exit;
  select first(1) ds.ds_langue
  from individu i
  inner join dossier ds on ds.cle_dossier=i.kle_dossier
  where (:a_cle_pere>0 and i.cle_fiche=:a_cle_pere)or(:a_cle_mere>0 and i.cle_fiche=:a_cle_mere)
  into langue;
  rdb$set_context('USER_SESSION','LANGUE',langue);

  for select i.cle_fiche
            ,i.nom
            ,i.prenom
            ,i.sexe
            ,i.date_naissance
            ,i.date_deces
            ,i.num_sosa
            ,m.multi_reduite
            ,coalesce(n.ev_ind_ville,'')||coalesce(', '||n.ev_ind_subd,'')
                     ||coalesce(', '||n.ev_ind_dept,'')||coalesce(', '||n.ev_ind_pays,'')
            ,coalesce(d.ev_ind_ville,'')||coalesce(', '||d.ev_ind_subd,'')
                     ||coalesce(', '||d.ev_ind_dept,'')||coalesce(', '||d.ev_ind_pays,'')
            ,i.annee_naissance
            ,i.annee_deces
            ,i.age_au_deces
            ,i.cle_pere
            ,i.cle_mere
            ,(select sosas from proc_sosas(i.cle_fiche))
            ,(select age_texte from proc_age_texte(pe.date_naissance,i.date_naissance))
            ,(select age_texte from proc_age_texte(me.date_naissance,i.date_naissance))
            ,(select age_texte from proc_age_texte(i.date_naissance,i.date_deces))
      from individu i
         left join media_pointeurs mp on mp.mp_cle_individu=i.cle_fiche
                                     and mp.mp_identite=1
         left join multimedia m on m.multi_clef=mp.mp_media
         left join evenements_ind n on n.ev_ind_kle_fiche=i.cle_fiche
                                   and n.ev_ind_type = 'BIRT'
         left join evenements_ind d on d.ev_ind_kle_fiche=i.cle_fiche
                                   and d.ev_ind_type = 'DEAT'
         left join individu pe on pe.cle_fiche=i.cle_pere
         left join individu me on me.cle_fiche=i.cle_mere
      where (:a_cle_mere=0 and i.cle_pere=:a_cle_pere)
            or (:a_cle_pere=0 and i.cle_mere=:a_cle_mere)
            or (i.cle_pere=:a_cle_pere and i.cle_mere=:a_cle_mere)
      order by i.cle_parents nulls last,n.ev_ind_datecode nulls last,n.ev_ind_heure nulls last
      into :cle_fiche
          ,:nom
          ,:prenom
          ,:sexe
          ,:date_naissance
          ,:date_deces
          ,:sosa
          ,:photo
          ,:ville_naiss
          ,:ville_deces
          ,:annee
          ,:annee_deces
          ,:age_deces
          ,:cle_pere
          ,:cle_mere
          ,:sosas
          ,:age_pere
          ,:age_mere
          ,:age_deces_texte
  do
    suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Permet de trouver les enfants d''un individu ou d''un couple.
Créée par Philippe Cazaux-Moutou le : 31/07/2001
Modifications par André le 11/05/2008, ajout âges au format texte
le 13/06/2009 positionnement de la langue dans le contexte,
5/2/2010 utilisation de MULTI_REDUITE au lieu de MULTI_MEDIA
10/03/2012 utilisation ordre et datecode'
  where RDB$PROCEDURE_NAME = 'PROC_TROUVE_ENFANTS';

SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_FRERES_SOEURS (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    F_1 Integer,
    DECEDE Integer,
    NUM_SOSA Double precision,
    ANNEE_NAISSANCE Integer,
    ANNEE_DECES Integer )
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée le : 08/01/2007 par André: optimisation
   ---------------------------------------------------------------------------*/
  FOR
    SELECT  f.cle_fiche
           ,f.nom
           ,f.prenom
           ,f.Date_Naissance
           ,f.Date_deces
           ,f.Sexe
           ,f.Cle_Pere
           ,f.Cle_Mere
           ,coalesce(f.ANNEE_NAISSANCE,0)
           ,f.decede
           ,f.num_sosa
           ,f.annee_naissance
           ,f.annee_deces
           FROM INDIVIDU i
           inner join individu f on (f.cle_pere=i.cle_pere
                                  or f.cle_mere=i.cle_mere)
                                and f.cle_fiche<>i.cle_fiche
           WHERE i.CLE_FICHE=:I_CLEF
           ORDER BY f.ANNEE_NAISSANCE
    INTO  :CLE_FICHE
         ,:NOM
         ,:PRENOM
         ,:DATE_NAISSANCE
         ,:DATE_DECES
         ,:SEXE
         ,:CLE_PERE
         ,:CLE_MERE
         ,:F_1
         ,:decede
         ,:num_sosa
         ,:annee_naissance
         ,:annee_deces
  DO
    SUSPEND;
END^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_GRANDS_PARENT (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Integer,
    DECEDE Integer,
    NUM_SOSA Double precision,
    ANNEE_NAISSANCE Integer,
    ANNEE_DECES Integer )
AS
DECLARE VARIABLE I_PERE INTEGER;
DECLARE VARIABLE I_MERE INTEGER;
DECLARE VARIABLE I_PERE_PERE INTEGER;
DECLARE VARIABLE I_MERE_PERE INTEGER;
DECLARE VARIABLE I_PERE_MERE INTEGER;
DECLARE VARIABLE I_MERE_MERE INTEGER;
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée le : 08/01/2007 par André pour la rapidité et ajout decede
   ---------------------------------------------------------------------------*/
   SELECT CLE_PERE, CLE_MERE FROM INDIVIDU WHERE CLE_FICHE = :I_CLEF
     INTO :I_PERE,
          :I_MERE;
   SELECT CLE_PERE, CLE_MERE FROM INDIVIDU WHERE CLE_FICHE = :I_PERE
     INTO :I_PERE_PERE,
          :I_MERE_PERE;
   SELECT CLE_PERE, CLE_MERE FROM INDIVIDU WHERE CLE_FICHE = :I_MERE
     INTO :I_PERE_MERE,
          :I_MERE_MERE;
   FOR
    SELECT  cle_fiche,
                nom,
                prenom,
                Date_Naissance,
                Date_deces,
                Sexe,
                Cle_Pere,
                Cle_Mere,
                4
               ,decede
               ,num_sosa
               ,annee_naissance
               ,annee_deces
           FROM INDIVIDU
           WHERE CLE_FICHE =:I_PERE_PERE
    UNION
    SELECT  cle_fiche,
                nom,
                prenom,
                Date_Naissance,
                Date_deces,
                Sexe,
                Cle_Pere,
                Cle_Mere,
                5
               ,decede
               ,num_sosa
               ,annee_naissance
               ,annee_deces
           FROM INDIVIDU
           WHERE CLE_FICHE =:I_MERE_PERE
    UNION
    SELECT  cle_fiche,
                nom,
                prenom,
                Date_Naissance,
                Date_deces,
                Sexe,
                Cle_Pere,
                Cle_Mere,
                6
               ,decede
               ,num_sosa
               ,annee_naissance
               ,annee_deces
           FROM INDIVIDU
           WHERE CLE_FICHE =:I_PERE_MERE
    UNION
    SELECT  cle_fiche,
                nom,
                prenom,
                Date_Naissance,
                Date_deces,
                Sexe,
                Cle_Pere,
                Cle_Mere,
                7
               ,decede
               ,num_sosa
               ,annee_naissance
               ,annee_deces
           FROM INDIVIDU
           WHERE CLE_FICHE =:I_MERE_MERE
    INTO :CLE_FICHE,
         :NOM,
         :PRENOM,
         :DATE_NAISSANCE,
         :DATE_DECES,
         :SEXE,
         :CLE_PERE,
         :CLE_MERE,
         :SOSA,
         :DECEDE,
         :num_sosa,
         :annee_naissance,
         :annee_deces
  DO
    SUSPEND;
END^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_IND_PAR_LETTRE (
    A_LETTRE Varchar(1),
    I_DOSSIER Integer )
RETURNS (
    NOM Varchar(40) )
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:47:54
   Modifiée le :
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
  select s_out from f_maj_sans_accent(:a_lettre) into :a_lettre;
  FOR
    SELECT DISTINCT NOM
       FROM INDIVIDU
       WHERE indi_trie_nom starting WITH :A_LETTRE AND
             KLE_DOSSIER = :I_DOSSIER
       ORDER BY NOM
    INTO :NOM
  DO
    SUSPEND;
END^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_MERE (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Integer )
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:48:03
   Modifiée le :
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
  FOR
    SELECT cle_fiche,
                nom,
                prenom,
                Date_Naissance,
                Date_deces,
                Sexe,
                Cle_Pere,
                Cle_Mere,
                3
             FROM  individu
                   Where cle_fiche  = (SELECT mere.CLE_MERE
                                               FROM individu mere
                                               WHERE mere.CLE_FICHE = :I_CLEF)
    INTO :CLE_FICHE,
         :NOM,
         :PRENOM,
         :DATE_NAISSANCE,
         :DATE_DECES,
         :SEXE,
         :CLE_PERE,
         :CLE_MERE,
         :SOSA
  DO
  BEGIN
    SUSPEND;
  END
END^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure honteuse recréée uniquement pour rester compatible avec la dll Arbres.dll.
A supprimer dès que possible'
  where RDB$PROCEDURE_NAME = 'PROC_TROUVE_MERE';

SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_ONCLES_TANTES (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    SEXE Integer,
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Double precision,
    DECEDE Integer,
    NUM_SOSA Double precision,
    ANNEE_NAISSANCE Integer,
    ANNEE_DECES Integer )
AS
declare variable a_clef_pere integer;
declare variable a_clef_mere integer;
declare variable i integer;
declare variable s integer;
BEGIN
  s=0;
  SELECT CLE_PERE,
         CLE_MERE
     FROM INDIVIDU
     WHERE CLE_FICHE = :I_CLEF
     INTO :a_clef_pere,
          :a_clef_mere;
  FOR SELECT distinct  i.cle_fiche
                      ,i.NOM
                      ,i.PRENOM
                      ,i.SEXE
                      ,i.DATE_NAISSANCE
                      ,i.DATE_DECES
                      ,i.CLE_PERE
                      ,i.CLE_MERE
                      ,case when p.sosa<6 then 100
                            else 200
                            end
                      ,i.decede
                      ,i.num_sosa
                      ,i.annee_naissance
                      ,i.annee_deces
  FROM PROC_TROUVE_GRANDS_PARENT (:I_CLEF) p
      inner join INDIVIDU i on (i.cle_fiche<>:a_clef_pere
                                and((p.sosa=4 and i.CLE_PERE=p.cle_fiche)
                                    OR (p.sosa=5 and i.CLE_MERE=p.cle_fiche)))
                            or (i.cle_fiche<>:a_clef_mere
                                and((p.sosa=6 and i.CLE_PERE=p.cle_fiche)
                                    OR (p.sosa=7 and i.CLE_MERE=p.cle_fiche)))
      left join evenements_ind e on e.ev_ind_kle_fiche=i.cle_fiche
                                    and e.ev_ind_type='BIRT'
  order by p.sosa,e.ev_ind_datecode,e.ev_ind_heure
  INTO :CLE_FICHE
      ,:NOM
      ,:PRENOM
      ,:SEXE
      ,:DATE_NAISSANCE
      ,:DATE_DECES
      ,:CLE_PERE
      ,:CLE_MERE
      ,:SOSA
      ,:DECEDE
      ,:num_sosa
      ,:annee_naissance
      ,:annee_deces
  do
  begin
    if (s<>sosa) then
    begin
      i=0;
      s=sosa;
    end
    i=i+1;
    sosa=sosa+i;
    suspend;
  end
END^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Créé le : 31/07/2001 Philippe Cazaux-Moutou.
Modifiée le 23/07/2007 par André optimisation, I_MAX et I_DOSSIER plus utilisés
le 28/12/2009 suppression de I_MAX et I_DOSSIER
le 10/03/2012 utilisation datecode'
  where RDB$PROCEDURE_NAME = 'PROC_TROUVE_ONCLES_TANTES';

SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_PARENTS (
    I_CLEF Integer,
    I_DOSSIER Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM_PERE Varchar(40),
    PRENOM_PERE Varchar(60),
    PERE_CLE_FICHE Integer,
    PERE_NAISSANCE Varchar(100),
    PERE_DECES Varchar(100),
    PERE_SOSA Double precision,
    NOM_MERE Varchar(40),
    PRENOM_MERE Varchar(60),
    MERE_CLE_FICHE Integer,
    MERE_NAISSANCE Varchar(100),
    MERE_DECES Varchar(100),
    MERE_SOSA Double precision,
    PERE_ANNEE Integer,
    MERE_ANNEE Integer )
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:48:38
   Modifiée le :
   à : :
   par :
   Description : Trouve les parents d'un individu
   Usage       :
   ---------------------------------------------------------------------------*/
   for
      SELECT  Enfant.cle_fiche,
              Pere.nom,
              Pere.prenom,
              Pere.cle_fiche,
              Pere.Date_Naissance,
              Pere.Date_deces,
              Pere.num_sosa,
              Mere.nom,
              Mere.prenom,
              Mere.cle_fiche,
              Mere.Date_Naissance,
              Mere.Date_deces,
              Mere.Num_Sosa,
              Pere.annee_naissance,
              Mere.annee_naissance
         FROM  individu Enfant
         LEFT JOIN individu pere
                       on Enfant.cle_pere = pere.cle_fiche
         LEFT JOIN individu mere
                       on Enfant.cle_mere = mere.cle_fiche
         WHERE Enfant.kle_dossier = :I_DOSSIER AND Enfant.Cle_Fiche = :I_CLEF
         ORDER BY Enfant.prenom
         INTO :CLE_FICHE,
              :NOM_PERE,
              :PRENOM_PERE,
              :PERE_CLE_FICHE,
              :PERE_NAISSANCE,
              :PERE_DECES,
              :PERE_SOSA,
              :NOM_MERE,
              :PRENOM_MERE,
              :MERE_CLE_FICHE,
              :MERE_NAISSANCE,
              :MERE_DECES,
              :MERE_SOSA,
              :PERE_ANNEE,
              :MERE_ANNEE
   do
   suspend;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure honteuse recréée uniquement pour rester compatible avec la dll Arbres.dll.
A supprimer dès que possible'
  where RDB$PROCEDURE_NAME = 'PROC_TROUVE_PARENTS';

SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_PERE (
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    DATE_DECES Varchar(100),
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    SOSA Integer )
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:48:58
   Modifiée le :
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
  FOR
    SELECT cle_fiche,
                nom,
                prenom,
                Date_Naissance,
                Date_deces,
                Sexe,
                Cle_Pere,
                Cle_Mere,
                2
             FROM  individu
                   Where cle_fiche  = (SELECT pere.CLE_PERE
                                               FROM individu Pere
                                               WHERE pere.CLE_FICHE = :I_CLEF)
    INTO :CLE_FICHE,
         :NOM,
         :PRENOM,
         :DATE_NAISSANCE,
         :DATE_DECES,
         :SEXE,
         :CLE_PERE,
         :CLE_MERE,
         :SOSA
  DO
  BEGIN
    SUSPEND;
  END
END^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure honteuse recréée uniquement pour rester compatible avec la dll Arbres.dll.
A supprimer dès que possible'
  where RDB$PROCEDURE_NAME = 'PROC_TROUVE_PERE';

SET TERM ^ ;
ALTER PROCEDURE PROC_TROUVE_UNIONS (
    I_DOSSIER Integer,
    I_CLEF Integer )
RETURNS (
    CLE_FICHE Integer,
    NOM Varchar(40),
    PRENOM Varchar(60),
    DATE_NAISSANCE Varchar(100),
    ANNEE_NAISSANCE Integer,
    DATE_DECES Varchar(100),
    ANNEE_DECES Integer,
    SEXE Integer,
    CLE_PERE Integer,
    CLE_MERE Integer,
    NUM_SOSA Double precision,
    TYPE_UNION Integer,
    UNION_CLEF Integer,
    ANNEE_MARIAGE Integer,
    DECEDE Integer )
AS
BEGIN
      FOR SELECT
            p.conjoint
           ,c.NOM
           ,c.PRENOM
           ,c.DATE_NAISSANCE
           ,c.ANNEE_NAISSANCE
           ,c.DATE_DECES
           ,c.ANNEE_DECES
           ,c.SEXE
           ,c.CLE_PERE
           ,c.CLE_MERE
           ,c.NUM_SOSA
           ,0
           ,p.clef_union
           ,p.ordre
           ,c.decede
      from proc_conjoints_ordonnes(:i_clef,0) p
        left join individu c on c.cle_fiche=p.conjoint
      INTO
            :CLE_FICHE,
            :NOM,
            :PRENOM,
            :DATE_NAISSANCE,
            :ANNEE_NAISSANCE,
            :DATE_DECES,
            :ANNEE_DECES,
            :SEXE,
            :CLE_PERE,
            :CLE_MERE,
            :NUM_SOSA,
            :TYPE_UNION,
            :UNION_CLEF,
            :ANNEE_MARIAGE,
            :DECEDE
      DO
        SUSPEND;
END^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure créée par Philippe Cazaux-Moutou le : 31/07/2001 à : 19:49:06
Modifiée le : 10/01/2007 par André Langlet pour ordre chronologique des conjoints
ajout du mois dans l''ordre de tri, requête indépendante du sexe ,ajout decede
Entièrement refaite le 07/04/2009 en utilisant PROC_CONJOINTS_ORDONNES.
Procédure plus utilisée par Ancestromania, mais conservée uniquement
pour compatibilité avec dllArbres.'
  where RDB$PROCEDURE_NAME = 'PROC_TROUVE_UNIONS';

SET TERM ^ ;
ALTER PROCEDURE PROC_VIDE_BASE
AS
declare variable i integer;
begin
      delete from prenoms;
      delete from t_associations;
      delete from memo_infos;
      delete from media_pointeurs;
      delete from sources_record;
      delete from evenements_fam;
      delete from evenements_ind;
      delete from favoris;
      delete from t_union ;
      delete from multimedia;
      delete from individu;
      delete from t_import_gedcom;
      delete from nom_attachement;
      delete from tq_ascend_descend;
      delete from tq_consang;
      delete from tq_id;
      delete from tq_transit;
      delete from tq_arbredescendant ;
      delete from tq_arbrereduit;
      delete from tq_ascendance;
      delete from tq_eclair;
      delete from tq_prenoms;
      delete from tq_rech_doublons;
      delete from t_doublons;
      delete from gestion_dll;
      delete from dossier;
      delete from t_journal;
      i = gen_id(gen_ev_ind_clef,-gen_id(gen_ev_ind_clef, 0));
      i = gen_id(gen_ev_fam_clef,-gen_id(gen_ev_fam_clef, 0));
      i = gen_id(gen_individu,-gen_id(gen_individu, 0));
      i = gen_id(gen_multimedia,-gen_id(gen_multimedia, 0));
      i = gen_id(t_import_gedcom_ig_id_gen,-gen_id(t_import_gedcom_ig_id_gen, 0));
      i = gen_id(nom_attachement_id_gen,-gen_id(nom_attachement_id_gen, 0));
      i = gen_id(gen_assoc_clef,-gen_id(gen_assoc_clef, 0));
      i = gen_id(gen_t_union,-gen_id(gen_t_union, 0));
      i = gen_id(gen_dossier,-gen_id(gen_dossier, 0));
      i = gen_id(gen_favoris,-gen_id(gen_favoris, 0));
      i = gen_id(gen_memo_infos,-gen_id(gen_memo_infos, 0));
      i = gen_id(sources_record_id_gen,-gen_id(sources_record_id_gen, 0));
      i = gen_id(biblio_pointeurs_id_gen,-gen_id(biblio_pointeurs_id_gen, 0));
      i = gen_id(gen_tq_id,-gen_id(gen_tq_id, 0));
      i = gen_id(gen_consang,-gen_id(gen_consang, 0));
      i = gen_id(gen_tq_media,-gen_id(gen_tq_media, 0));
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure refaite par André Langlet pour respecter l''ordre des dépendances
lors de la suppression des enregistrements, vidage T_IMPORT_GEDCOM.
Remplacement PATRONYMES par NOM_ATTACHEMENT. 01/06/2007
Suppression ADRESSES_IND le 25/10/2010
Ajout des générateurs de tables temporaires le 13/04/2011
Suppression de l''appel à PROC_VIDE_TABLES_REF jamais utilisé le 28/08/2012.'
  where RDB$PROCEDURE_NAME = 'PROC_VIDE_BASE';

SET TERM ^ ;
ALTER PROCEDURE PROC_VIDE_DOSSIER (
    I_CLEF Integer )
AS
begin
      DELETE FROM PRENOMS;
      DELETE FROM MEDIA_POINTEURS WHERE MP_KLE_DOSSIER = :I_CLEF;
      DELETE FROM MEMO_INFOS WHERE M_DOSSIER = :I_CLEF;
      DELETE FROM SOURCES_RECORD WHERE KLE_DOSSIER = :I_CLEF;
      DELETE FROM T_ASSOCIATIONS WHERE ASSOC_KLE_DOSSIER = :I_CLEF;
      DELETE FROM evenements_fam WHERE EV_FAM_KLE_DOSSIER = :I_CLEF;
      DELETE FROM evenements_ind WHERE EV_IND_KLE_DOSSIER = :I_CLEF;
      DELETE FROM MULTIMEDIA  WHERE MULTI_DOSSIER = :I_CLEF;
      DELETE FROM NOM_ATTACHEMENT WHERE KLE_DOSSIER = :I_CLEF;
      DELETE FROM TQ_ASCEND_DESCEND;
      DELETE FROM TQ_CONSANG;
      DELETE FROM TQ_ID;
      DELETE FROM TQ_ARBREDESCENDANT ;
      DELETE FROM tq_arbrereduit;
      DELETE FROM tq_ascendance;
      DELETE FROM TQ_ECLAIR;
      DELETE FROM TQ_PRENOMS;
      DELETE FROM T_DOUBLONS;
      DELETE FROM TQ_RECH_DOUBLONS;
      DELETE FROM TQ_TRANSIT;
      DELETE FROM T_UNION WHERE KLE_DOSSIER = :I_CLEF;
      DELETE FROM T_IMPORT_GEDCOM WHERE IG_ID IN (select ID_IMPORT_GEDCOM
             FROM INDIVIDU WHERE KLE_DOSSIER=:I_CLEF and ID_IMPORT_GEDCOM is not null);
      DELETE FROM INDIVIDU WHERE KLE_DOSSIER = :I_CLEF;
      DELETE FROM FAVORIS WHERE KLE_DOSSIER = :I_CLEF;
      DELETE FROM ref_histoire WHERE hi_dossier=:I_CLEF;
      DELETE FROM t_journal WHERE kle_dossier=:I_CLEF;
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'Procédure refaite par André Langlet pour respecter l''ordre des dépendances
lors de la suppression des enregistrements et suppresion des références au dossier
pour les tables temporaires, vidage T_IMPORT_GEDCOM, REF_HISTOIRE, remplacement
PATRONYMES par NOM_ATTACHEMENT 01/06/2007
suppression références à ADRESSES_IND 25/10/2010'
  where RDB$PROCEDURE_NAME = 'PROC_VIDE_DOSSIER';

ALTER TABLE ADRESSES_IND ADD ADR_TYPE COMPUTED BY (1);
ALTER TABLE ADRESSES_IND ADD CONSTRAINT FK_ADRESSES_IND
  FOREIGN KEY (ADR_KLE_DOSSIER) REFERENCES DOSSIER (CLE_DOSSIER) ON DELETE CASCADE;
CREATE INDEX ADRESSES_IND_CP ON ADRESSES_IND (ADR_CP);
CREATE INDEX ADRESSES_IND_KLE_IND ON ADRESSES_IND (ADR_KLE_IND);
CREATE INDEX ADRESSES_IND_PAYS ON ADRESSES_IND (ADR_PAYS);
CREATE INDEX ADRESSES_IND_VILLE ON ADRESSES_IND (ADR_VILLE);
UPDATE RDB$RELATIONS set
RDB$DESCRIPTION = 'ADR_TYPE recréé uniquement pour compatibilité avec dll Arbres'
where RDB$RELATION_NAME = 'ADRESSES_IND';
ALTER TABLE EVENEMENTS_FAM ADD EV_FAM_DATE_COURTE COMPUTED BY (trim(case when ev_fam_type_token2 in(14,18)then ev_fam_date_year||'_'||ev_fam_date_year_fin
 else case when ev_fam_type_token1=16 then '>'
  when ev_fam_type_token1=15 then '<'
  when ev_fam_type_token1 in (19,20,21) then '~'
  else ''
  end||ev_fam_date_year||
  case when ev_fam_type_token1=14 then '<'
  when ev_fam_type_token1 in (13,17) then '>'
  else ''
 end
end));
ALTER TABLE EVENEMENTS_FAM ADD CONSTRAINT FK_EVENEMENTS_FAM
  FOREIGN KEY (EV_FAM_KLE_DOSSIER) REFERENCES DOSSIER (CLE_DOSSIER) ON DELETE CASCADE;
CREATE INDEX EVENEMENTS_FAM_KLE_FAM ON EVENEMENTS_FAM (EV_FAM_KLE_FAMILLE);
CREATE INDEX EVENEMENTS_FAM_TYPE ON EVENEMENTS_FAM (EV_FAM_TYPE);
CREATE INDEX EVENEMENTS_FAM_VILLE ON EVENEMENTS_FAM (EV_FAM_VILLE);
CREATE INDEX IDX_EVENEMENTS_FAM_ACTE ON EVENEMENTS_FAM (EV_FAM_ACTE);
CREATE INDEX IDX_EVENEMENTS_FAM_CP ON EVENEMENTS_FAM (EV_FAM_CP);
CREATE INDEX IDX_EVENEMENTS_FAM_DATECODE ON EVENEMENTS_FAM (EV_FAM_DATECODE);
CREATE INDEX IDX_EVENEMENTS_FAM_INSEE ON EVENEMENTS_FAM (EV_FAM_INSEE);
CREATE INDEX IDX_EVENEMENTS_FAM_MOIS ON EVENEMENTS_FAM (EV_FAM_DATE_MOIS);
CREATE INDEX IDX_EVENEMENTS_FAM_ORDRE ON EVENEMENTS_FAM (EV_FAM_ORDRE);
CREATE INDEX IDX_EVENEMENTS_FAM_YEAR ON EVENEMENTS_FAM (EV_FAM_DATE_YEAR);
ALTER TABLE EVENEMENTS_IND ADD EV_IND_DATE_COURTE COMPUTED BY (trim(case when ev_ind_type_token2 in(14,18)then ev_ind_date_year||'_'||ev_ind_date_year_fin
 else case when ev_ind_type_token1=16 then '>'
  when ev_ind_type_token1=15 then '<'
  when ev_ind_type_token1 in (19,20,21) then '~'
  else ''
  end||ev_ind_date_year||
  case when ev_ind_type_token1=14 then '<'
  when ev_ind_type_token1 in (13,17) then '>'
  else ''
 end
end));
ALTER TABLE EVENEMENTS_IND ADD CONSTRAINT FK_EVENEMENTS_IND
  FOREIGN KEY (EV_IND_KLE_DOSSIER) REFERENCES DOSSIER (CLE_DOSSIER) ON DELETE CASCADE;
CREATE INDEX EVENEMENTS_IND_IDX1 ON EVENEMENTS_IND (EV_IND_KLE_DOSSIER);
CREATE INDEX EVENEMENTS_IND_IDX2 ON EVENEMENTS_IND (EV_IND_KLE_FICHE);
CREATE INDEX EVENEMENTS_IND_IDX3 ON EVENEMENTS_IND (EV_IND_TYPE);
CREATE INDEX IDX_EVENEMENTS_IND_ACTE ON EVENEMENTS_IND (EV_IND_ACTE);
CREATE INDEX IDX_EVENEMENTS_IND_CP ON EVENEMENTS_IND (EV_IND_CP);
CREATE INDEX IDX_EVENEMENTS_IND_DATECODE ON EVENEMENTS_IND (EV_IND_DATECODE);
CREATE INDEX IDX_EVENEMENTS_IND_INSEE ON EVENEMENTS_IND (EV_IND_INSEE);
CREATE INDEX IDX_EVENEMENTS_IND_MOIS ON EVENEMENTS_IND (EV_IND_DATE_MOIS);
CREATE INDEX IDX_EVENEMENTS_IND_ORDRE ON EVENEMENTS_IND (EV_IND_ORDRE);
CREATE INDEX IDX_EVENEMENTS_IND_VILLE ON EVENEMENTS_IND (EV_IND_VILLE);
CREATE INDEX IDX_EVENEMENTS_IND_YEAR ON EVENEMENTS_IND (EV_IND_DATE_YEAR);
ALTER TABLE FAVORIS ADD CONSTRAINT FK_FAVORIS
  FOREIGN KEY (KLE_DOSSIER) REFERENCES DOSSIER (CLE_DOSSIER) ON DELETE CASCADE;
CREATE UNIQUE INDEX FAVORIS_ID ON FAVORIS (ID);
CREATE INDEX FAVORIS_KLE_FICHE ON FAVORIS (KLE_FICHE);
CREATE INDEX IDX_GESTION_DLL_DOSSIER ON GESTION_DLL (DLL_DOSSIER);
CREATE INDEX IDX_GESTION_DLL_INDI ON GESTION_DLL (DLL_INDI);
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'Liens avec le decujus.
bit 0 (masque 1): 1=lien avec le decujus (peut-être témoin)
bit 1 (masque 2): 1=lien avec le decujus (sauf témoin)
bit 2 (masque 4): 1=descendant du decujus
bits 8 à 15: si descendant du decujus, nombre de générations entre le decujus et l''individu, 0 autrement
bits 18 à 23: nombre de générations entre l''individu et le premier ancêtre commun
bits 24 à 32: nombre de générations entre le decujus et le premier ancêtre commun'  where RDB$FIELD_NAME = 'TYPE_LIEN_GENE' and RDB$RELATION_NAME = 'INDIVIDU';
UPDATE RDB$RELATION_FIELDS set RDB$DESCRIPTION = 'bit 0=Individu confidentiel (masque=1)
bit 1=Sans contrôle des dates (masque=2)
bit 2=Identité incertaine (masque=4)
bit 3=Continuer recherches (masque=8)'  where RDB$FIELD_NAME = 'IND_CONFIDENTIEL' and RDB$RELATION_NAME = 'INDIVIDU';
ALTER TABLE INDIVIDU ADD AGE_AU_DECES COMPUTED BY (annee_deces-annee_naissance);
ALTER TABLE INDIVIDU ADD CONSTRAINT FK_INDIVIDU
  FOREIGN KEY (KLE_DOSSIER) REFERENCES DOSSIER (CLE_DOSSIER) ON DELETE CASCADE;
CREATE INDEX INDIVIDU_CLE_IMPORTATION ON INDIVIDU (CLE_IMPORTATION);
CREATE INDEX INDIVIDU_CLE_MERE ON INDIVIDU (CLE_MERE);
CREATE INDEX INDIVIDU_CLE_PERE ON INDIVIDU (CLE_PERE);
CREATE INDEX INDIVIDU_DATE_DECES ON INDIVIDU (DATE_DECES);
CREATE INDEX INDIVIDU_DATE_NAISSANCE ON INDIVIDU (DATE_NAISSANCE);
CREATE INDEX INDIVIDU_IDX1_CLE_FIXE ON INDIVIDU (CLE_FIXE);
CREATE INDEX INDIVIDU_ID_IMPORT ON INDIVIDU (ID_IMPORT_GEDCOM);
CREATE INDEX INDIVIDU_NOM ON INDIVIDU (NOM);
CREATE INDEX INDIVIDU_NOM_PRENOM_CLE ON INDIVIDU (NOM,PRENOM,CLE_FICHE);
CREATE DESCENDING INDEX INDIVIDU_NOM_PRENOM_CLE_DESC ON INDIVIDU (NOM,PRENOM,CLE_FICHE);
CREATE INDEX INDIVIDU_NUM_SOSA ON INDIVIDU (NUM_SOSA);
CREATE INDEX INDIVIDU_PRENOM ON INDIVIDU (PRENOM);
CREATE INDEX INDIVIDU_SURNOM ON INDIVIDU (SURNOM);
CREATE INDEX INDIVIDU_TRI_NOM ON INDIVIDU (INDI_TRIE_NOM);
CREATE INDEX INDIVIDU_TYPE_LIEN_GENE ON INDIVIDU (TYPE_LIEN_GENE);
CREATE INDEX CLEF_LIEUX_FAVORIS ON LIEUX_FAVORIS (VILLE,SUBD,CP,DEPT,REGION,PAYS,INSEE,LATITUDE,LONGITUDE);
CREATE INDEX IDX_MEDIA_POINTEURS ON MEDIA_POINTEURS (MP_MEDIA,MP_POINTE_SUR,MP_TABLE);
CREATE DESCENDING INDEX IDX_MP_CLE_INDIVIDU ON MEDIA_POINTEURS (MP_CLE_INDIVIDU,MP_CLEF);
CREATE INDEX IDX_MP_POINTE_SUR ON MEDIA_POINTEURS (MP_POINTE_SUR,MP_TABLE,MP_TYPE_IMAGE);
ALTER TABLE MEMO_INFOS ADD CONSTRAINT FK_MEMO_INFOS
  FOREIGN KEY (M_DOSSIER) REFERENCES DOSSIER (CLE_DOSSIER) ON DELETE CASCADE;
ALTER TABLE MULTIMEDIA ADD CONSTRAINT FK_MULTIMEDIA_DOSSIER
  FOREIGN KEY (MULTI_DOSSIER) REFERENCES DOSSIER (CLE_DOSSIER) ON DELETE CASCADE;
CREATE INDEX IDX_MULTIMEDIA_PATH ON MULTIMEDIA (MULTI_PATH);
CREATE INDEX IDX_MULTIMEDIA_PATH_MAJ ON MULTIMEDIA COMPUTED BY (upper(multi_path));
CREATE INDEX MULTIMEDIA_TYPE ON MULTIMEDIA (MULTI_TYPE);
CREATE INDEX IDX_NOM_ATTACHEMENT_DOSSIER ON NOM_ATTACHEMENT (KLE_DOSSIER);
CREATE INDEX IDX_NOM_ATTACHEMENT_ID_INDI ON NOM_ATTACHEMENT (ID_INDI);
CREATE INDEX IDX_NOM_ATTACHEMENT_INDI ON NOM_ATTACHEMENT (NOM_INDI);
CREATE INDEX IDX_NOM_ATTACHEMENT_NOM ON NOM_ATTACHEMENT (NOM);
CREATE INDEX IDX_NOM_ATTACHEMENT_NOM_LETTRE ON NOM_ATTACHEMENT (NOM_LETTRE);
ALTER TABLE PRENOMS ADD SEXE COMPUTED BY (iif((F>M),2,1));
CREATE INDEX IDX_REF_DEPARTEMENTS_DEUX ON REF_DEPARTEMENTS (RDP_CODE_DEUX);
CREATE INDEX IDX_REF_DEPARTEMENTS_LIBELLE ON REF_DEPARTEMENTS (RDP_LIBELLE);
UPDATE RDB$RELATIONS set
RDB$DESCRIPTION = 'Table maintenue uniquement pour compatibilité avec dllArbres'
where RDB$RELATION_NAME = 'REF_DEPARTEMENTS';
UPDATE RDB$RELATIONS set
RDB$DESCRIPTION = 'Création André Langlet 2009'
where RDB$RELATION_NAME = 'REF_DIVERS_FAM';
UPDATE RDB$RELATIONS set
RDB$DESCRIPTION = 'Création André Langlet 2009'
where RDB$RELATION_NAME = 'REF_DIVERS_IND';
CREATE INDEX IDX_LIB_COURT_LANGUE ON REF_EVENEMENTS (REF_EVE_LIB_COURT,REF_EVE_LANGUE);
CREATE INDEX IDX_REF_HISTOIRE_DEBUT ON REF_HISTOIRE (HI_DATE_CODE_DEBUT);
CREATE DESCENDING INDEX IDX_REF_HISTOIRE_DEBUT_DESC ON REF_HISTOIRE (HI_DATE_CODE_DEBUT);
CREATE INDEX IDX_REF_HISTOIRE_DICORIGINE ON REF_HISTOIRE (HI_DICORIGINE);
CREATE INDEX IDX_REF_HISTOIRE_DOSSIER ON REF_HISTOIRE (HI_DOSSIER);
CREATE INDEX IDX_REF_HISTOIRE_FIN ON REF_HISTOIRE (HI_DATE_CODE_FIN);
UPDATE RDB$RELATIONS set
RDB$DESCRIPTION = 'Création par André Langlet décembre 2010.'
where RDB$RELATION_NAME = 'REF_MARR';
CREATE INDEX REF_PAYS_LIBELLE ON REF_PAYS (RPA_LIBELLE);
UPDATE RDB$RELATIONS set
RDB$DESCRIPTION = 'Table maintenue uniquement pour compatibilité avec dllArbres'
where RDB$RELATION_NAME = 'REF_PAYS';
CREATE INDEX REF_RELA_TEMOINS_LANGUE ON REF_RELA_TEMOINS (LANGUE);
CREATE INDEX IDX_REF_TOKEN_DATE_TYPE ON REF_TOKEN_DATE (TYPE_TOKEN,ID);
CREATE INDEX REF_TOKEN_DATE_IDX1 ON REF_TOKEN_DATE (LANGUE);
CREATE INDEX IDX_SOURCES_RECORD_DATA_ID ON SOURCES_RECORD (DATA_ID);
CREATE INDEX SOURCES_RECORD_DOSSIER ON SOURCES_RECORD (KLE_DOSSIER);
CREATE INDEX TA_GROUPES_IDX1 ON TA_GROUPES (TA_NIVEAU);
CREATE INDEX TA_GROUPES_IDX2 ON TA_GROUPES (TA_CLE_FICHE);
CREATE INDEX TA_GROUPES_IDX3 ON TA_GROUPES (TA_GROUPE);
CREATE INDEX TA_GROUPES_IDX4 ON TA_GROUPES (TA_SEXE);
CREATE INDEX TQ_ANC_DECUJUS ON TQ_ANC (DECUJUS);
CREATE INDEX TQ_ANC_ENFANT ON TQ_ANC (ENFANT);
CREATE INDEX TQ_ANC_INDI ON TQ_ANC (INDI);
CREATE INDEX TQ_ANC_NIVEAU ON TQ_ANC (NIVEAU);
CREATE INDEX TQ_ARBREDESCENDANT_ASCENDANT ON TQ_ARBREDESCENDANT (TQ_ASCENDANT);
CREATE INDEX TQ_ARBREDESCENDANT_IDX1 ON TQ_ARBREDESCENDANT (TQ_NIVEAU);
CREATE INDEX TQ_ARBREDESCENDANT_IDX2 ON TQ_ARBREDESCENDANT (TQ_CLE_FICHE);
CREATE INDEX TQ_ARBREDESCENDANT_IDX4 ON TQ_ARBREDESCENDANT (TQ_CLE_PERE);
CREATE INDEX TQ_ARBREDESCENDANT_IDX5 ON TQ_ARBREDESCENDANT (TQ_CLE_MERE);
CREATE INDEX TQ_ARBREDESCENDANT_NUM_SOSA ON TQ_ARBREDESCENDANT (TQ_NUM_SOSA);
CREATE INDEX TQ_ARBREDESCENDANT_SOSA ON TQ_ARBREDESCENDANT (TQ_SOSA);
CREATE INDEX TQ_ARBREREDUIT_IDX1 ON TQ_ARBREREDUIT (TQ_NIVEAU);
CREATE INDEX TQ_ARBREREDUIT_IDX2 ON TQ_ARBREREDUIT (TQ_CLE_FICHE);
CREATE INDEX TQ_ARBREREDUIT_IDX3 ON TQ_ARBREREDUIT (IMPLEXE);
CREATE INDEX TQ_ARBREREDUIT_SOSA ON TQ_ARBREREDUIT (TQ_SOSA);
CREATE INDEX TQ_ASCENDANCE_CLE_FICHE ON TQ_ASCENDANCE (TQ_CLE_FICHE);
CREATE INDEX TQ_ASCENDANCE_DOSSIER ON TQ_ASCENDANCE (TQ_DOSSIER);
CREATE INDEX TQ_ASCENDANCE_NIVEAU ON TQ_ASCENDANCE (TQ_NIVEAU);
CREATE INDEX TQ_CONSANG_DECUJUS ON TQ_CONSANG (DECUJUS);
CREATE INDEX TQ_CONSANG_ENFANT ON TQ_CONSANG (ENFANT);
CREATE INDEX TQ_CONSANG_ID ON TQ_CONSANG (ID);
CREATE INDEX TQ_CONSANG_INDI ON TQ_CONSANG (INDI);
CREATE INDEX TQ_CONSANG_NIVEAU ON TQ_CONSANG (NIVEAU);
CREATE INDEX IDX_TQ_ECLAIR_DATE ON TQ_ECLAIR (TQ_DATE);
CREATE INDEX IDX_TQ_ECLAIR_NOM ON TQ_ECLAIR (TQ_NOM);
CREATE INDEX IDX_TQ_ECLAIR_VILLE ON TQ_ECLAIR (TQ_VILLE);
CREATE INDEX TQ_ID_IDX_ID1 ON TQ_ID (ID1);
CREATE INDEX TQ_ID_IDX_ID2 ON TQ_ID (ID2);
CREATE INDEX TQ_PRENOMS_COMBIEN ON TQ_PRENOMS (COMBIEN);
CREATE INDEX TQ_PRENOMS_DOSSIER ON TQ_PRENOMS (DOSSIER);
CREATE INDEX TQ_PRENOMS_PRENOM ON TQ_PRENOMS (PRENOM);
CREATE INDEX IDX_TRACES_MOMENT ON TRACES (MOMENT);
CREATE INDEX IDX_TRACES_TABLE ON TRACES (NOM_TABLE);
CREATE INDEX TT_ASCENDANCE_IDX_INDI ON TT_ASCENDANCE (INDI);
UPDATE RDB$RELATIONS set
RDB$DESCRIPTION = 'Création André le 14/12/2008 pour automatiser le calcul de l''ascendance.'
where RDB$RELATION_NAME = 'TT_ASCENDANCE';
CREATE INDEX T_ASSOCIATIONS_ASSOC ON T_ASSOCIATIONS (ASSOC_KLE_ASSOCIE);
CREATE INDEX T_ASSOCIATIONS_DOSSIER ON T_ASSOCIATIONS (ASSOC_KLE_DOSSIER);
CREATE INDEX T_ASSOCIATIONS_IND ON T_ASSOCIATIONS (ASSOC_KLE_IND);
CREATE INDEX T_ASSOCIATIONS_TABLE_EVE ON T_ASSOCIATIONS (ASSOC_TABLE,ASSOC_EVENEMENT);
CREATE INDEX T_DOUBLONS_IDX1 ON T_DOUBLONS (CLE_FICHE);
ALTER TABLE T_UNION ADD CONSTRAINT FK_T_UNION
  FOREIGN KEY (KLE_DOSSIER) REFERENCES DOSSIER (CLE_DOSSIER) ON DELETE CASCADE;
CREATE INDEX IDX_UNION_TYPE ON T_UNION (UNION_TYPE);
CREATE INDEX T_UNION_FEMME ON T_UNION (UNION_FEMME);
CREATE INDEX T_UNION_MARI ON T_UNION (UNION_MARI);
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Créé par André Langlet le 10/05/2009'
  where RDB$TRIGGER_NAME = 'DOSSIER_BIU0';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Modifié par André depuis le 01/06/2006 traitement Y
04/05/2008 traçage des dates invalides'
  where RDB$TRIGGER_NAME = 'EVENEMENTS_FAM_BI';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création André Langlet
Dernière mise à jour AL le 27/10/2012'
  where RDB$TRIGGER_NAME = 'EVENEMENTS_FAM_BIU';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Trigger créé par André Langlet le 20/04/2009. Dernière maj AL 31/10/2012
A n''activer que dans le cas de transfert de la date par DATE_WRITEN uniquement.'
  where RDB$TRIGGER_NAME = 'EVENEMENTS_FAM_BIU2';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création par André Langlet
Dernière mise à jour AL le 29/02/2012
Met à jour les champs de la table INDIVIDU et permet l''enregistrement du champ
Sources de l''événement dans un enregistrement de SOURCES_RECORD.'
  where RDB$TRIGGER_NAME = 'EVENEMENTS_IND_AIU';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Modifié par André le 01/06/2006 ajout des mois, dates de fin et normalisation date saisie
le 1/10/2006 traitement Y et EVEN, 12/2/2007 contrôle événement en double
le 04/05/2008 traçage des dates invalides, le 16/04/2009 traçage des événements en double'
  where RDB$TRIGGER_NAME = 'EVENEMENTS_IND_BI';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Créé par André LANGLET le 27/02/2007
Dernière modification par AL le 27/10/2012'
  where RDB$TRIGGER_NAME = 'EVENEMENTS_IND_BIU';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Trigger créé par André Langlet le 20/04/2009. Dernière maj AL 31/10/2012.
A n''activer que dans le cas de transfert de la date par DATE_WRITEN uniquement.'
  where RDB$TRIGGER_NAME = 'EVENEMENTS_IND_BIU2';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création André Langlet 03/2011 pour la gestion des lieux favoris.'
  where RDB$TRIGGER_NAME = 'EV_FAM_TRIG_MAJ_LIEUX_FAVORIS';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création André Langlet 03/2011 pour la gestion des lieux favoris.'
  where RDB$TRIGGER_NAME = 'EV_IND_TRIG_MAJ_LIEUX_FAVORIS';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'créé par André en 2009 pour importation des modèles d''arbres.'
  where RDB$TRIGGER_NAME = 'EX_ARBRES_BI0';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création André Langlet 2009'
  where RDB$TRIGGER_NAME = 'REF_DIVERS_FAM_BIU0';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création André Langlet 2009'
  where RDB$TRIGGER_NAME = 'REF_DIVERS_IND_BIU0';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Déclencheur créé par André le 18/01/2007
Dernière modification par André le 05/03/2012'
  where RDB$TRIGGER_NAME = 'REF_HISTOIRE_BIU';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création André Langlet le 29/02/2012.'
  where RDB$TRIGGER_NAME = 'SOURCES_RECORD_BIU';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création par André le 25/03/2006 modifié le 14/11/2007: ajout CREM.
Dernière modification 05/07/2011'
  where RDB$TRIGGER_NAME = 'TAD_EVENEMENTS_IND';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création par André Langlet pour fonctionnement des médias le 01/10/2005.
Dernière modifications par AL le 23/07/2009.
Suppression de l''enregistrement pour le conjoint
s''il est lié au même événement familial.'
  where RDB$TRIGGER_NAME = 'TAD_MEDIA_POINTEURS';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création par André pour fonctionnement média (01/10/05)
Le doublement de l''enregistrement dans MEDIA_POINTEURS
pour le conjoint ne fonctionne pas si l''enregistrement
de l''évènement familial dans SOURCES_RECORD n''existe pas.
Ne sera plus nécessaire le jour où le programme créera
l''enregistrement dans SOURCES_RECORD avant celui dans
MEDIA_POINTEURS que si le champ Sources de l''événement n''est pas vide'
  where RDB$TRIGGER_NAME = 'TAI_EVENEMENTS_FAM';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création par André Langlet pour fonctionnement des médias le 01/10/2005.
Dernière modification par AL le 23/07/2009.
Double l''enregistrement pour le conjoint s''il est lié à un évènement familial.'
  where RDB$TRIGGER_NAME = 'TAI_MEDIA_POINTEURS';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création André Langlet
Dernière modification 23/07/2009'
  where RDB$TRIGGER_NAME = 'TBD_EVENEMENTS_FAM';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création par André Langlet pour fonctionnement média (01/10/05)
Suppression des enregistrements dans SOURCES_RECORD et
dans MEDIA_POINTEURS si l''enregistrement disparaît.
24/10/05 ajout maj table T_ASSOCIATIONS'
  where RDB$TRIGGER_NAME = 'TBD_EVENEMENTS_IND';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Créé par André le 18/11/2005
01/06/2006 ajout des mois,date de fin et normalisation des dates
11/05/2007 mise à jour media_pointeurs
04/05/2008 traçage des erreurs de dates
08/01/2010 maj pour gestion des actes.'
  where RDB$TRIGGER_NAME = 'TBU_EVENEMENTS_FAM';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Créé par André le 18/11/2005
12/2/2007 contrôle événement en double
11/05/2007 mise à jour media_pointeurs
14/11/2007 optimisation
16/04/2009 Traçage des erreurs
10/01/2010 maj pour gestion des actes.'
  where RDB$TRIGGER_NAME = 'TBU_EVENEMENTS_IND';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création André le 14/12/2008 pour automatiser le calcul de l''ascendance.'
  where RDB$TRIGGER_NAME = 'TT_ASCENDANCE_AI0';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création André le 14/12/2008 pour automatiser le calcul de l''ascendance.'
  where RDB$TRIGGER_NAME = 'TT_ASCENDANCE_BI0';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'créé par André le 13/11/2008 pour maj auto des sosas'
  where RDB$TRIGGER_NAME = 'T_AD_INDIVIDU';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création par André le 28/07/2008'
  where RDB$TRIGGER_NAME = 'T_AI_INDIVIDU';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création par André le 28/07/2008
Modification le 13/11/2008 pour maj auto de num_sosa'
  where RDB$TRIGGER_NAME = 'T_AU_INDIVIDU';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Trigger modifié par André
Dernière modification 16/04/2009'
  where RDB$TRIGGER_NAME = 'T_BI_INDIVIDU';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Modifications par André
10/06/2006 suppressions corrections dues à valeurs non mises à jour par fiche individu
01/11/2008 utilisation variable contextuelle pour empêcher la maj de la date de modification'
  where RDB$TRIGGER_NAME = 'T_BU_INDIVIDU';
UPDATE RDB$TRIGGERS set
  RDB$DESCRIPTION = 'Création André Langlet le 06/02/2009
Dernière modification le 13/04/2011'
  where RDB$TRIGGER_NAME = 'T_CONNECTION';
GRANT EXECUTE
 ON PROCEDURE F_MAJ TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE F_MAJ_SANS_ACCENT TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_AGE_TEXTE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ANC_COMMUNS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ARBRE_EXPORT TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ASCEND_DESCEND TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ASCEND_ORDONNEE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_CHERCHE_DOUBLONS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_COMPTAGE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_CONJOINTS_ORDONNES TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_CONSANG TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_COPIE_DOSSIER TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_DATES_INCOHERENTES TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_DATE_CODE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_DATE_WRITEN TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_DATE_WRITEN_UN TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_DELTA_DATES TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_DERNIER_METIER TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_DESCENDANCE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ECLATE_DESCRIPTION TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ECLATE_PRENOM TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_AGE_PREM_UNION TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_ANNIV_ORDER TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_ASCENDANCE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_DENOMB_ASCEND TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_DENOMB_DESCEND TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_DESCENDANCE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_ECLAIR TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_FICHE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_FICHE_FAMILIALE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_LONGEVITE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_NB_ENFANT_UNION TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_ETAT_RECENSEMENT TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_EVE_IND TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_EXPORT_IMAGES TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_GESTION_DLL TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_GET_CLEF_UNIQUE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_GROUPE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_INCOHERENCES TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_INSERT_FAVORIS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_JOURS_TEXTE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_LISTE_PARENTE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_LISTE_PRENOM TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_LISTE_PROFESSION TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_LISTE_UNIONS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_MAJ_TAGS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_NAVIGATION TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_NEW_PRENOMS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_PREP_PRENOMS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_PREP_PROFESSIONS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_PREP_VILLES_FAVORIS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_PREP_VILLES_RAYON TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_PURGE_IMPORT_GEDCOM TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_RENUM_SOSA TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_SEPARATION_PRENOMS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_SOSAS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_SUIVANT TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TEST_ASC TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TEST_DESC TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TEST_PARENTE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TQ_ASCENDANCE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TQ_DESCENDANCE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_CONJOINTS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_COUSINS_COUSINES TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_DOSSIER TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_ENFANTS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_FRERES_SOEURS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_GRANDS_PARENT TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_IND_PAR_LETTRE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_MERE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_ONCLES_TANTES TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_PARENTS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_PERE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_TROUVE_UNIONS TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_VIDE_BASE TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_VIDE_DOSSIER TO  SYSDBA;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON ADRESSES_IND TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON DOSSIER TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EVENEMENTS_FAM TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EVENEMENTS_IND TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON EX_ARBRES TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON FAVORIS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON GESTION_DLL TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON INDIVIDU TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON LIEUX_FAVORIS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON MEDIA_POINTEURS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON MEMO_INFOS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON MULTIMEDIA TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON NOM_ATTACHEMENT TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON PRENOMS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_DEPARTEMENTS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_DIVERS_FAM TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_DIVERS_IND TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_EVENEMENTS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_FILIATION TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_HISTOIRE TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_MARR TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_PARTICULES TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_PAYS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_PREFIXES TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_RACCOURCIS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_RELA_TEMOINS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_TOKEN_DATE TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON SOURCES_RECORD TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TA_GROUPES TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_ANC TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_ARBREDESCENDANT TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_ARBREREDUIT TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_ASCENDANCE TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_ASCEND_DESCEND TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_CONSANG TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_ECLAIR TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_ID TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_MEDIAS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_PRENOMS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_RECH_DOUBLONS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TQ_TRANSIT TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TRACES TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TT_ASCENDANCE TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON T_ASSOCIATIONS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON T_DOUBLONS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON T_IMPORT_GEDCOM TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON T_JOURNAL TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON T_UNION TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON T_VERSION_BASE TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON YBTEMP TO  SYSDBA WITH GRANT OPTION;
