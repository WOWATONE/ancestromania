SET ECHO ON;
/*Ce script maj_b4.060_b5xxx.sql ne doit s'appliquer qu'à des bases de niveau b4.060
Il met  à jour les procédures et triggers afin d'utiliser les fonctions de chaînes
de caractères intégrées dans FB2.0, en remplacement des fonctions externes
Si Firebird 2.0 est bien installé, il ne doit provoquer aucune erreur.*/
SET ECHO OFF;
SET NAMES ISO8859_1;
COMMIT WORK;
SET AUTODDL OFF;

SET TERM ^ ; 

alter PROCEDURE PROC_DEL_CASCADE_INDIVIDU (
    KLE_DOSSIER INTEGER,
    I_CLE INTEGER)
AS
begin
/*Procédure inutile, la mise à jour des données suite à la suppression
d'un individu est assurée par t_bd_individu. Maintenue car utilisée dans
proc_lr_elagage_dossier, supprimée et recrée par le BOA*/
exit;
end^
commit^

ALTER TRIGGER EVENEMENTS_FAM_BI
ACTIVE BEFORE INSERT POSITION 0
AS
declare variable i integer;
declare variable l integer;
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
  Créé le : 01/08/2001
   à : 05:34:06
   Modifié par André le 01/06/2006 ajout des mois,date de fin et normalisation des dates
   le 1/10/2006 traitement Y
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
  IF (NEW.EV_FAM_CLEF IS NULL) THEN
      NEW.EV_FAM_CLEF = GEN_ID(GEN_EV_FAM_CLEF,1);
  SELECT IMOIS,IAN,DDATE,IMOIS_FIN,IAN_FIN,DDATE_FIN,DATE_WRITEN_S
    FROM PROC_DATE_WRITEN(NEW.EV_FAM_DATE_WRITEN)
    INTO NEW.EV_FAM_DATE_MOIS,NEW.EV_FAM_DATE_YEAR,NEW.EV_FAM_DATE,
         NEW.EV_FAM_DATE_MOIS_FIN,NEW.EV_FAM_DATE_YEAR_FIN,NEW.EV_FAM_DATE_FIN,
         NEW.EV_FAM_DATE_WRITEN;
  NEW.EV_FAM_DESCRIPTION=trim(NEW.EV_FAM_DESCRIPTION);
  if (upper(NEW.EV_FAM_DESCRIPTION)='Y') then NEW.EV_FAM_DESCRIPTION=null;
END^
commit work^

alter TRIGGER TBU_EVENEMENTS_IND
ACTIVE BEFORE UPDATE POSITION 0
as
declare variable i integer;
BEGIN
/* Créé par André le 18/11/2005 pour mettre à jour les dates
   01/06/2006 ajout des mois, dates de fin et normalisation date saisie
   Modifié le 12/2/2007 pour contrôle événement en double
   11/05/2007 mise à jour media_pointeurs*/
IF (NEW.EV_IND_DATE_WRITEN <> OLD.EV_IND_DATE_WRITEN OR
   (NEW.EV_IND_DATE_WRITEN IS NULL AND OLD.EV_IND_DATE_WRITEN IS NOT NULL) OR
   (NEW.EV_IND_DATE_WRITEN IS NOT NULL AND OLD.EV_IND_DATE_WRITEN IS NULL)) then
  SELECT IMOIS,IAN,DDATE,IMOIS_FIN,IAN_FIN,DDATE_FIN,DATE_WRITEN_S
  FROM PROC_DATE_WRITEN(NEW.EV_IND_DATE_WRITEN)
    INTO NEW.EV_IND_DATE_MOIS,NEW.EV_IND_DATE_YEAR,NEW.EV_IND_DATE,
         NEW.EV_IND_DATE_MOIS_FIN,NEW.EV_IND_DATE_YEAR_FIN,NEW.EV_IND_DATE_FIN,
         NEW.EV_IND_DATE_WRITEN;
if (new.ev_ind_type<>old.ev_ind_type) then
  for select first(1) e.ev_ind_clef
      from evenements_ind e
      inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type
                                 and r.ref_eve_une_fois=1
      where e.ev_ind_kle_fiche=new.ev_ind_kle_fiche
        and e.ev_ind_clef<>new.ev_ind_clef
        and e.ev_ind_type=new.ev_ind_type
      into :i
      do
      begin
        select r.ref_eve_lib_long from ref_evenements r
        where r.ref_eve_lib_court=new.ev_ind_type
        into new.ev_ind_titre_event;
        new.ev_ind_type='EVEN';
      end
if (new.ev_ind_acte=0 or new.ev_ind_acte is null) then
begin
  new.ev_ind_acte=null;
  if (old.ev_ind_acte=1) then
    delete from media_pointeurs
    where mp_pointe_sur=old.ev_ind_clef
      and mp_table='I'
      and mp_type_image='A';
end
END^
commit^

alter TRIGGER TBU_EVENEMENTS_FAM
ACTIVE BEFORE UPDATE POSITION 0
as
BEGIN
/* Créé par André le 18/11/2005 pour mettre à jour les dates
01/06/2006 ajout des mois,date de fin et normalisation des dates
11/05/2007 mise à jour media_pointeurs*/
IF ((NEW.EV_FAM_DATE_WRITEN<>OLD.EV_FAM_DATE_WRITEN) OR
   (NEW.EV_FAM_DATE_WRITEN IS NULL AND OLD.EV_FAM_DATE_WRITEN IS NOT NULL) OR
   (NEW.EV_FAM_DATE_WRITEN IS NOT NULL AND OLD.EV_FAM_DATE_WRITEN IS NULL)) THEN
  SELECT IMOIS,IAN,DDATE,IMOIS_FIN,IAN_FIN,DDATE_FIN,DATE_WRITEN_S
    FROM PROC_DATE_WRITEN(NEW.EV_FAM_DATE_WRITEN)
    INTO NEW.EV_FAM_DATE_MOIS,NEW.EV_FAM_DATE_YEAR,NEW.EV_FAM_DATE,
         NEW.EV_FAM_DATE_MOIS_FIN,NEW.EV_FAM_DATE_YEAR_FIN,NEW.EV_FAM_DATE_FIN,
         NEW.EV_FAM_DATE_WRITEN;
if (new.ev_fam_acte=0 or new.ev_fam_acte is null) then
begin
  new.ev_fam_acte=null;
  if (old.ev_fam_acte=1) then
    delete from media_pointeurs
    where mp_pointe_sur=old.ev_fam_clef
      and mp_table='F'
      and mp_type_image='A';
end
END^
commit^

alter TRIGGER REF_EVENEMENTS_BI
ACTIVE BEFORE INSERT POSITION 0
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
commit^

/******************************************************************************/
/****                          Stored Procedures                           ****/
/******************************************************************************/

alter PROCEDURE PROC_COMPTE_ONGLETS (
    IDOSSIER INTEGER,
    ICLEF INTEGER)
RETURNS (
    COMBIEN INTEGER,
    TITRE VARCHAR(5))
AS
BEGIN suspend; END^
commit^

ALTER PROCEDURE PROC_LISTE_INDIVIDU (
    I_DOSSIER INTEGER,
    I_LETTRE VARCHAR(1),
    I_MODE INTEGER,
    I_SEXE INTEGER)
RETURNS (
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SURNOM VARCHAR(120),
    SEXE INTEGER,
    CLE_FICHE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    KLE_DOSSIER INTEGER,
    DATE_NAISSANCE VARCHAR(100),
    ANNEE_DECES INTEGER,
    CP VARCHAR(10),
    VILLE VARCHAR(50),
    NUM_SOSA DOUBLE PRECISION,
    DATE_DECES VARCHAR(100),
    CP_DECES VARCHAR(10),
    VILLE_DECES VARCHAR(50),
    ANNEE_NAISSANCE INTEGER)
AS
begin suspend; end^
commit^

ALTER PROCEDURE PROC_TROUVE_CHAINE_INDI (
    I_DOSSIER INTEGER,
    SNOM VARCHAR(20) CHARACTER SET ISO8859_1,
    SPRENOM VARCHAR(20) CHARACTER SET ISO8859_1)
RETURNS (
    NOM VARCHAR(40) CHARACTER SET ISO8859_1,
    PRENOM VARCHAR(60) CHARACTER SET ISO8859_1,
    SURNOM VARCHAR(120) CHARACTER SET ISO8859_1,
    SEXE INTEGER,
    CLE_FICHE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    KLE_DOSSIER INTEGER,
    DATE_NAISSANCE VARCHAR(100) CHARACTER SET ISO8859_1,
    ANNEE_DECES INTEGER,
    CP VARCHAR(10) CHARACTER SET ISO8859_1,
    VILLE VARCHAR(50) CHARACTER SET ISO8859_1,
    NUM_SOSA DOUBLE PRECISION,
    DATE_DECES VARCHAR(100) CHARACTER SET ISO8859_1,
    CP_DECES VARCHAR(10) CHARACTER SET ISO8859_1,
    VILLE_DECES VARCHAR(50) CHARACTER SET ISO8859_1,
    ANNEE_NAISSANCE INTEGER)
AS
begin suspend; end^
commit^

ALTER PROCEDURE PROC_TROUVE_INDIVIDU (
    I_DOSSIER INTEGER,
    A_NOM VARCHAR(40),
    A_PRENOM VARCHAR(60),
    A_SEXE INTEGER,
    A_CP_NAISSANCE VARCHAR(10),
    A_LIEU_NAISSANCE VARCHAR(50),
    A_PAYS_NAISSANCE VARCHAR(30),
    A_CP_DECES VARCHAR(10),
    A_LIEU_DECES VARCHAR(50),
    A_PAYS_DECES VARCHAR(30),
    D_SOSA DOUBLE PRECISION,
    I_ANNEE_NAISS INTEGER,
    I_ANNEE_DECES INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SEXE INTEGER,
    DATE_NAISSANCE VARCHAR(100),
    CP_NAISSANCE VARCHAR(10),
    LIEU_NAISSANCE VARCHAR(50),
    PAYS_NAISSANCE VARCHAR(30),
    DATE_DECES VARCHAR(100),
    CP_DECES VARCHAR(10),
    LIEU_DECES VARCHAR(50),
    PAYS_DECES VARCHAR(30))
AS
begin suspend; end^
commit^

ALTER PROCEDURE F_MAJ_SANS_ACCENT (
    S_IN VARCHAR(255))
RETURNS (
    S_OUT VARCHAR(255))
AS
DECLARE VARIABLE L INTEGER;
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE CAR CHAR(1) CHARACTER SET ISO8859_1;
DECLARE VARIABLE S_TEMP VARCHAR(255) CHARACTER SET ISO8859_1;
begin
  S_OUT=coalesce(upper(lower(S_IN)collate FR_FR),'');
  for select :s_out from rdb$database
  where :s_out containing ''
     or :s_out containing ''
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
      if (car='') then s_out=s_out||'OE';
      else if (car='') then s_out=s_out||'OE';
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
commit work^

ALTER PROCEDURE PROC_AJOUT_VILLE (
    S_CP VARCHAR(10),
    S_VILLE VARCHAR(50),
    S_DEPT VARCHAR(30),
    S_REGION VARCHAR(30),
    S_PAYS VARCHAR(30),
    S_INSEE VARCHAR(6),
    D_LATITUDE DECIMAL(15,8),
    N_LONGITUDE NUMERIC(15,8))
AS
DECLARE VARIABLE I_COUNT INTEGER;
DECLARE VARIABLE I_PAYS INTEGER;
DECLARE VARIABLE I_REGION INTEGER;
DECLARE VARIABLE I_DEPT INTEGER;
DECLARE VARIABLE I_VILLE INTEGER;
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 09/06/2002
   à : 17:48:10
   Modifiée le : 17/01/2007 par André, ajout coordonnées et INSEE
   Description : Cette prococedure crée pays, region, departement et ville
                 si ceux-ci n'existent pas
   Usage       :
   ---------------------------------------------------------------------------*/
  /* On cherche sur les pays */
  if (char_length(S_PAYS) > 0 ) then
    INSERT INTO REF_PAYS
              (RPA_CODE
              ,RPA_LIBELLE
              ,RPA_ABBREVIATION)
       SELECT CLE_UNIQUE
             , UPPER(:S_PAYS)
             , 'NEW'
       FROM proc_get_clef_unique('REF_PAYS')
       where not exists (select * from ref_pays
                         where UPPER(RPA_LIBELLE)=UPPER(:S_PAYS));
  /* On cherche sur les régions*/
  if (char_length(S_REGION) > 0 ) then
     begin
        SELECT RPA_CODE
           FROM REF_PAYS
           WHERE UPPER(RPA_LIBELLE) = UPPER(:S_PAYS)
           INTO :I_PAYS;
        SELECT COUNT(1)
           FROM REF_REGION
           WHERE UPPER(RRG_LIBELLE) = UPPER(:S_REGION) AND
                 RRG_PAYS = :I_PAYS
           INTO :I_COUNT;
        /* sila region n existe pas on le cree */
        if (I_COUNT <= 0) then
           BEGIN
            SELECT CLE_UNIQUE FROM proc_get_clef_unique('REF_REGION')
               INTO :I_REGION;
            INSERT INTO REF_REGION
               (RRG_CODE, RRG_LIBELLE, RRG_PAYS)
               Values
               (:I_REGION, :S_REGION, :I_PAYS);
            END
     end
  /* On cherche sur les departements*/
  if (char_length(:S_DEPT) > 0 ) then
     begin
        SELECT RPA_CODE
           FROM REF_PAYS
           WHERE UPPER(RPA_LIBELLE) = UPPER(:S_PAYS)
           INTO :I_PAYS;
        SELECT RRG_CODE
           FROM REF_REGION
           WHERE UPPER(RRG_LIBELLE) = UPPER(:S_REGION)
           INTO :I_REGION;
        SELECT COUNT(1)
           FROM REF_DEPARTEMENTS
           WHERE UPPER(RDP_LIBELLE) = UPPER(:S_DEPT) AND
                 RRG_CODE = :I_REGION AND
                 RDP_PAYS = :I_PAYS
           INTO :I_COUNT;
        /* sile Dept existe pas on le cree */
        if (I_COUNT <= 0) then
           BEGIN
            SELECT CLE_UNIQUE FROM proc_get_clef_unique('REF_DEPARTEMENTS')
               INTO :I_DEPT;
            INSERT INTO REF_DEPARTEMENTS
               (RDP_CODE, RDP_LIBELLE, RRG_CODE, RDP_PAYS)
               Values
               (:I_DEPT, :S_DEPT, :I_REGION, :I_PAYS);
            END
     end
  /* On cherche sur les villes*/
  if ((char_length(:S_CP) > 0 ) or (char_length(:S_VILLE) > 0 )) then
     begin
        SELECT RPA_CODE
           FROM REF_PAYS
           WHERE UPPER(RPA_LIBELLE) = UPPER(:S_PAYS)
           INTO :I_PAYS;
        SELECT RRG_CODE
           FROM REF_REGION
           WHERE UPPER(RRG_LIBELLE) = UPPER(:S_REGION)
           INTO :I_REGION;
        SELECT RDP_CODE
           FROM REF_DEPARTEMENTS
           WHERE UPPER(RDP_LIBELLE) = UPPER(:S_DEPT)
           INTO :I_DEPT;
        SELECT COUNT(1)
           FROM REF_CP_VILLE
           WHERE CP_CP = :S_CP AND
                 CP_VILLE = :S_VILLE AND
                 CP_DEPT = :I_DEPT AND
                 CP_REGION = :I_REGION AND
                 CP_PAYS = :I_PAYS
           INTO :I_COUNT;
        /* si la ville existe pas on la crée */
        if (I_COUNT <= 0) then
           BEGIN
            SELECT CLE_UNIQUE FROM proc_get_clef_unique('REF_CP_VILLE')
               INTO :I_VILLE;
            INSERT INTO REF_CP_VILLE
                   (CP_CODE
                   ,CP_CP
                   ,CP_VILLE
                   ,CP_DEPT
                   ,CP_REGION
                   ,CP_PAYS
                   ,CP_INSEE
                   ,CP_LATITUDE
                   ,CP_LONGITUDE)
               Values
                   (:I_VILLE
                   ,:S_CP
                   ,:S_VILLE
                   ,:I_DEPT
                   ,:I_REGION
                   ,:I_PAYS
                   ,:s_insee
                   ,:d_latitude
                   ,:n_longitude);
            END
     end
END^
commit work^

ALTER PROCEDURE PROC_COMPTAGE (
    I_DOSSIER INTEGER,
    I_MODE INTEGER)
RETURNS (
    LIBELLE VARCHAR(10),
    COMPTAGE INTEGER)
AS
DECLARE VARIABLE S_VILLE VARCHAR(50);
DECLARE VARIABLE S_DEPT VARCHAR(30);
DECLARE VARIABLE S_REGION VARCHAR(50);
DECLARE VARIABLE S_PAYS VARCHAR(30);
DECLARE VARIABLE I INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 18:11:18
   Modifiée le : 8/12/2005 par André pour comptage villes, dept, régions et pays du dossier
   et le 12/12/2005 pour ignorer les erreurs de minuscules, espaces
   le 23/08/2007 suppression du comptage des lieux, unions avec 2 conjoints
  par :
   Description : Permet de compter les enregistrement du dossier
                en cours
   Usage       :
   ---------------------------------------------------------------------------*/
  if (I_MODE=1) then
  begin
      DELETE from TQ_TRANSIT;
      I=GEN_ID(TQ_TRANSIT_CLEF_GEN,-GEN_ID(TQ_TRANSIT_CLEF_GEN,0));
      FOR
      SELECT EV_IND_VILLE,
               EV_IND_DEPT,
               EV_IND_REGION,
               EV_IND_PAYS
           FROM evenements_ind
           WHERE EV_IND_KLE_DOSSIER = :I_DOSSIER AND
                NOT(EV_IND_VILLE IS NULL AND EV_IND_DEPT IS NULL AND
                    EV_IND_REGION IS NULL AND EV_IND_PAYS IS NULL)
      UNION
      SELECT EV_FAM_VILLE,
               EV_FAM_DEPT,
               EV_FAM_REGION,
               EV_FAM_PAYS
           FROM evenements_FAM
           WHERE EV_FAM_KLE_DOSSIER = :I_DOSSIER AND
                NOT(EV_FAM_VILLE IS NULL AND EV_FAM_DEPT IS NULL AND
                    EV_FAM_REGION IS NULL AND EV_FAM_PAYS IS NULL)
      UNION
      SELECT ADR_VILLE,
               ADR_DEPT,
               ADR_REGION,
               ADR_PAYS
           FROM ADRESSES_IND
           WHERE ADR_KLE_DOSSIER = :I_DOSSIER AND
                NOT(ADR_VILLE IS NULL AND ADR_DEPT IS NULL AND
                    ADR_REGION IS NULL AND ADR_PAYS IS NULL)
      INTO :S_VILLE,
           :S_DEPT,
           :S_REGION,
           :S_PAYS
      Do
          INSERT INTO TQ_TRANSIT (CHAMP1,CHAMP2,CHAMP3,CHAMP4)
              VALUES(:S_VILLE, :S_DEPT, :S_REGION, :S_PAYS);
      UPDATE TQ_TRANSIT SET CHAMP1='' WHERE CHAMP1 IS NULL;
      UPDATE TQ_TRANSIT SET CHAMP2='' WHERE CHAMP2 IS NULL;
      UPDATE TQ_TRANSIT SET CHAMP3='' WHERE CHAMP3 IS NULL;
      UPDATE TQ_TRANSIT SET CHAMP4='' WHERE CHAMP4 IS NULL;
      FOR
       SELECT  'EVE_IND', Count(ev_ind_clef)
           FROM  evenements_ind
           WHERE (ev_ind_kle_dossier = :I_DOSSIER)
       UNION
       SELECT  'EVE_FAM',Count(ev_fam_clef)
           FROM  evenements_fam
           WHERE (ev_fam_kle_dossier = :I_DOSSIER)
       UNION
       SELECT  '_VILLES',Count(DISTINCT UPPER(TRIM(CHAMP1)
                                            ||TRIM(CHAMP2)
                                            ||TRIM(CHAMP3)
                                            ||TRIM(CHAMP4)))
           FROM  TQ_TRANSIT
       UNION
       SELECT  'DEPARTE',Count(DISTINCT UPPER(TRIM(CHAMP2)
                                            ||TRIM(CHAMP3)
                                            ||TRIM(CHAMP4)))
           FROM  TQ_TRANSIT
       UNION
       SELECT  'REGIONS',Count(DISTINCT UPPER(TRIM(CHAMP3)
                                            ||TRIM(CHAMP4)))
           FROM  TQ_TRANSIT
       UNION
       SELECT  '___PAYS',Count(DISTINCT UPPER(TRIM(CHAMP4)))
           FROM  TQ_TRANSIT
       UNION
       SELECT  'ADRESSE',Count(adr_clef)
           FROM  ADRESSES_IND
           WHERE adr_kle_dossier=:I_DOSSIER
       UNION
       SELECT  'MULTIME',Count(multi_clef)
           FROM  MULTIMEDIA
           WHERE multi_dossier=:I_DOSSIER
       UNION
       SELECT  'EVE_FAM', Count(ev_fam_clef)
           FROM  evenements_fam
           WHERE ev_fam_kle_dossier=:I_DOSSIER
       UNION
       SELECT  'INDIVID', Count(cle_fiche)
           FROM  individu
           WHERE kle_dossier=:I_DOSSIER
       UNION
       SELECT  'PATRONY', COUNT(DISTINCT NOM)
           FROM INDIVIDU
           WHERE kle_dossier=:I_DOSSIER
       UNION
       SELECT  'TUNIONS', Count(union_clef)
           FROM  T_UNION
           WHERE kle_dossier=:I_DOSSIER
             and union_mari>0
             and union_femme>0
       UNION
       SELECT  '_HOMMES', Count(cle_fiche)
           FROM  INDIVIDU
           WHERE kle_dossier=:I_DOSSIER AND SEXE=1
       UNION
       SELECT  '_FEMMES', Count(cle_fiche)
           FROM  INDIVIDU
           WHERE kle_dossier=:I_DOSSIER AND SEXE=2
       UNION
       SELECT  'INDETER', Count(cle_fiche)
           FROM  INDIVIDU
           WHERE kle_dossier=:I_DOSSIER AND SEXE<>1 and SEXE<>2
       INTO
         :LIBELLE ,
         :COMPTAGE
      DO
      suspend;
      DELETE from TQ_TRANSIT;
      I=GEN_ID(TQ_TRANSIT_CLEF_GEN,-GEN_ID(TQ_TRANSIT_CLEF_GEN,0));
   END
   ELSE
     FOR
       SELECT  'INDIVID', Count(cle_fiche)
           FROM  individu
           WHERE kle_dossier=:I_DOSSIER
       UNION
       SELECT  'PATRONY', COUNT(DISTINCT NOM)
           FROM INDIVIDU
           WHERE kle_dossier=:I_DOSSIER
       UNION
       SELECT  'TUNIONS', Count(union_clef)
           FROM  T_UNION
           WHERE kle_dossier=:I_DOSSIER
             and union_mari>0
             and union_femme>0
       UNION
       SELECT  '_HOMMES', Count(cle_fiche)
           FROM  INDIVIDU
           WHERE kle_dossier=:I_DOSSIER AND SEXE=1
       UNION
       SELECT  '_FEMMES', Count(cle_fiche)
           FROM  INDIVIDU
           WHERE kle_dossier=:I_DOSSIER AND SEXE=2
       UNION
       SELECT  'INDETER', Count(cle_fiche)
           FROM  INDIVIDU
           WHERE kle_dossier=:I_DOSSIER AND SEXE<>1 and SEXE<>2
       INTO
         :LIBELLE ,
         :COMPTAGE
     DO
     suspend;
end^
commit work^

ALTER PROCEDURE PROC_COMPTE_VILLES (
    I_DOSSIER INTEGER)
RETURNS (
    COMBIEN INTEGER,
    RPA_LIBELLE VARCHAR(30) CHARACTER SET ISO8859_1)
AS
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE S_VILLE VARCHAR(50);
DECLARE VARIABLE S_DEPT VARCHAR(30);
DECLARE VARIABLE S_REGION VARCHAR(50);
DECLARE VARIABLE S_PAYS VARCHAR(30);
BEGIN
  DELETE from TQ_TRANSIT;
  I=GEN_ID(TQ_TRANSIT_CLEF_GEN,-GEN_ID(TQ_TRANSIT_CLEF_GEN,0));
  FOR SELECT EV_IND_VILLE,
               EV_IND_DEPT,
               EV_IND_REGION,
               EV_IND_PAYS
           FROM evenements_ind
           WHERE EV_IND_KLE_DOSSIER = :I_DOSSIER AND
                NOT(EV_IND_VILLE IS NULL AND EV_IND_DEPT IS NULL AND
                    EV_IND_REGION IS NULL AND EV_IND_PAYS IS NULL)
      UNION
      SELECT EV_FAM_VILLE,
               EV_FAM_DEPT,
               EV_FAM_REGION,
               EV_FAM_PAYS
           FROM evenements_FAM
           WHERE EV_FAM_KLE_DOSSIER = :I_DOSSIER AND
                NOT(EV_FAM_VILLE IS NULL AND EV_FAM_DEPT IS NULL AND
                    EV_FAM_REGION IS NULL AND EV_FAM_PAYS IS NULL)
      UNION
      SELECT ADR_VILLE,
               ADR_DEPT,
               ADR_REGION,
               ADR_PAYS
           FROM ADRESSES_IND
           WHERE ADR_KLE_DOSSIER = :I_DOSSIER AND
                NOT(ADR_VILLE IS NULL AND ADR_DEPT IS NULL AND
                    ADR_REGION IS NULL AND ADR_PAYS IS NULL)
      INTO :S_VILLE,
           :S_DEPT,
           :S_REGION,
           :S_PAYS
      Do
          INSERT INTO TQ_TRANSIT (CHAMP1,CHAMP2,CHAMP3,CHAMP4)
              VALUES(:S_VILLE, :S_DEPT, :S_REGION, :S_PAYS);
      UPDATE TQ_TRANSIT SET CHAMP1='' WHERE CHAMP1 IS NULL;
      UPDATE TQ_TRANSIT SET CHAMP2='' WHERE CHAMP2 IS NULL;
      UPDATE TQ_TRANSIT SET CHAMP3='' WHERE CHAMP3 IS NULL;
      UPDATE TQ_TRANSIT SET CHAMP4='' WHERE CHAMP4 IS NULL;
  FOR
    Select  count(DISTINCT UPPER(TRIM(CHAMP1)
                               ||TRIM(CHAMP2)
                               ||TRIM(CHAMP3)
                               ||TRIM(CHAMP4)))
                               ,CAST(UPPER(TRIM(CHAMP4)) AS varchar(30))
       from TQ_TRANSIT
       group by UPPER(TRIM(CHAMP4))
       ORDER BY UPPER(TRIM(CHAMP4))
    INTO
      :COMBIEN,
      :RPA_LIBELLE
  DO
    begin
      if (RPA_LIBELLE='') then RPA_LIBELLE='INCONNU';
      SUSPEND;
    end
  DELETE from TQ_TRANSIT;

 I=GEN_ID(TQ_TRANSIT_CLEF_GEN,-GEN_ID(TQ_TRANSIT_CLEF_GEN,0));
END^
commit work^

alter PROCEDURE PROC_DATE_WRITEN_UN (
    DATE_WRITEN VARCHAR(100))
RETURNS (
    IJOUR INTEGER,
    IMOIS INTEGER,
    IAN INTEGER,
    TOKEN VARCHAR(30),
    TYPE_TOKEN INTEGER,
    DATE_WRITEN_S VARCHAR(100),
    VALIDE SMALLINT)
AS
DECLARE VARIABLE L INTEGER;
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE CH CHAR(1);
DECLARE VARIABLE CHD VARCHAR(5);
DECLARE VARIABLE INTD INTEGER;
DECLARE VARIABLE PLACEMOIS INTEGER;
DECLARE VARIABLE CHD1 VARCHAR(5);
DECLARE VARIABLE CHD2 VARCHAR(5);
DECLARE VARIABLE CHD3 VARCHAR(5);
DECLARE VARIABLE CONT VARCHAR(3);
DECLARE VARIABLE ORDRE VARCHAR(30);
DECLARE VARIABLE M VARCHAR(5);
DECLARE VARIABLE D VARCHAR(5);
DECLARE VARIABLE Y VARCHAR(5);
DECLARE VARIABLE DDATE DATE;
begin
/*Procédure créée par André, dernière modification 13 mars 2007*/
  DATE_WRITEN_S=UPPER(TRIM(lower(DATE_WRITEN) collate FR_FR));
  VALIDE=1;
  IF (char_length(DATE_WRITEN_S)>0) THEN
    BEGIN
      VALIDE=0;
      CHD1='';
      CHD2='';
      CHD3='';
      PLACEMOIS=0;
      L=1;
      WHILE (L>0) DO   /*élimination des token et espaces*/
        begin
          L=0;
          SELECT MAX(char_length(TOKEN))
            FROM REF_TOKEN_DATE
            WHERE TYPE_TOKEN>12 AND TYPE_TOKEN<22
                 AND :DATE_WRITEN_S STARTING WITH UPPER(lower(TOKEN) collate FR_FR)||' '
            INTO :L;
          IF (L>0) THEN
            BEGIN
              SELECT first(1) TYPE_TOKEN
                FROM REF_TOKEN_DATE
                WHERE TYPE_TOKEN>12 AND TYPE_TOKEN<22
                     AND UPPER(lower(TOKEN) collate FR_FR)=SUBSTRing(:DATE_WRITEN_S from 1 for :L)
                INTO :TYPE_TOKEN;
              IF (char_length(DATE_WRITEN_S)>L) THEN
                DATE_WRITEN_S=TRIM(SUBSTRING(DATE_WRITEN_S from L+1));
              ELSE
                begin
                  DATE_WRITEN_S='';
                  L=0;
                end
            END
          ELSE
            L=0;
        end
      I=0;
      WHILE (char_length(DATE_WRITEN_S)>0 AND I<3) DO /*Recherche composants de la date*/
        BEGIN
          I=I+1;
          CONT='OUI';
          L=0;
          FOR SELECT char_length(TOKEN) /*élimination séparateurs*/
            FROM REF_TOKEN_DATE
            WHERE TYPE_TOKEN=22
                  AND :DATE_WRITEN_S STARTING WITH TOKEN
            INTO :L
          DO IF (L>0) THEN
              begin
              IF (char_length(DATE_WRITEN_S)>L) THEN
                DATE_WRITEN_S=TRIM(SUBSTRING(DATE_WRITEN_S FROM L+1));
              ELSE
                begin
                  DATE_WRITEN_S='';
                  CONT='NON';
                end
              end  /*fin de élimination séparateurs*/
          CHD='';
          IF (CONT='OUI') THEN /* si chiffres, premier caractère*/
            begin
              CH=SUBSTRing(DATE_WRITEN_S from 1 for 1);
              IF (CH IN('-','+','0','1','2','3','4','5','6','7','8','9')) THEN
                begin
                  CHD=CH;
                  IF (char_length(DATE_WRITEN_S)>1) THEN
                    DATE_WRITEN_S=SUBSTRING(DATE_WRITEN_S from 2);
                  ELSE
                    begin
                      DATE_WRITEN_S='';
                      CONT='NON';
                    end
                end
              ELSE
                CONT='NON';
            end
          WHILE (CONT='OUI' AND char_length(CHD)<5) DO /* si chiffres, suivants*/
             begin
              CH=SUBSTRING(DATE_WRITEN_S from 1 for 1);
              IF (CH IN('0','1','2','3','4','5','6','7','8','9')) THEN
                begin
                  CHD=CHD||CH;
                  IF (char_length(DATE_WRITEN_S) > 1) THEN
                    DATE_WRITEN_S=SUBSTRING(DATE_WRITEN_S from 2);
                  ELSE
                    begin
                      DATE_WRITEN_S='';
                      CONT='NON';
                    end
                end
              ELSE
                CONT='NON';
             end
          /* fin de si chiffres*/
          IF (CHD='') THEN /* voir si token mois*/
            BEGIN
              L=0;
              SELECT MAX(char_length(TOKEN)),TYPE_TOKEN
                FROM REF_TOKEN_DATE
                WHERE TYPE_TOKEN<13
                  AND :DATE_WRITEN_S STARTING WITH UPPER(lower(TOKEN) collate FR_FR)
                GROUP BY TYPE_TOKEN
                INTO :L,:INTD;
              IF (L>0) THEN
                begin
                  CHD=CAST(INTD AS varchar(5));
                  PLACEMOIS=I;
                  IF (char_length(DATE_WRITEN_S) > L) THEN
                    DATE_WRITEN_S=SUBSTRING(DATE_WRITEN_S from L+1);
                  ELSE
                    DATE_WRITEN_S='';
                end
            END  /* fin de si token mois*/
            DATE_WRITEN_S=TRIM(DATE_WRITEN_S);
          IF (CHD IN('+','-')) THEN
            BEGIN
              SUSPEND;
              EXIT;
            END
          IF (I=1) THEN CHD1=CHD;
          ELSE IF (I=2) THEN CHD2=CHD;
               ELSE CHD3=CHD;
        END /*fin recherche des composants de la date*/
      SELECT FIRST(1) TOKEN    /*cherche ordre jour, mois, année dans TYPE_TOKEN 23*/
            FROM REF_TOKEN_DATE
            WHERE TYPE_TOKEN = 23
            INTO :ORDRE;
      if (CHD1='') then  --pas un nombre
      begin
         valide=0;
         IJOUR=NULL;
         IMOIS=NULL;
         IAN=NULL;
      end
      else
      begin
         if (CHD2='') then  --que l'année dans CHD1
         begin
            valide=1;
            IJOUR=NULL;
            IMOIS=NULL;
            IAN=CAST(CHD1 as integer);
            if (placemois>0) then
            begin
               valide=0;
               IAN=NULL;
               IMOIS=NULL;
               IJOUR=NULL;
            end
         end
         else
         begin
            if (CHD3='') then  --que année et mois dans CHD1 et CHD2
            begin
               IJOUR=NULL;
               I=0;
               CHD=CHD1;
               while (I<3 and I<char_length(ORDRE)) do
               begin
                  I=I+1;
                  CH=SUBSTRING(ORDRE from I for 1);
                  if (CH in ('M','Y')) then  --pour le premier trouvé
                  begin
                     if (CH='M') then
                     begin
                        if (placemois=2) then M='0';
                        else M=CHD1;
                     end
                     else Y=CHD1;
                     leave;
                  end
               end
               while (I<3 and I<char_length(ORDRE)) do
               begin
                  I=I+1;
                  CH=SUBSTRING(ORDRE from I for 1);
                  if (CH in ('M','Y')) then  --pour le second trouvé
                  begin
                     if (CH='M') then
                     begin
                        if (placemois=1) then M='0';
                        else M=CHD2;
                     end
                     else Y=CHD2;
                     leave;
                  end
               end
               IAN=CAST(Y as integer);
               IMOIS=CAST(M as integer);
               valide=1;
               IF (IMOIS<1 OR IMOIS>12) THEN
               begin
                  valide=0;
                  IAN=NULL;
                  IMOIS=NULL;
                  IJOUR=NULL;
               end
            end
            else  -- tout est complet
            begin
               I=0;
               WHILE (I<3 AND I<char_length(ORDRE)) DO
               BEGIN
                  I=I +1;
                  CH=SUBSTRING(ORDRE from I for 1);
                  IF (I=1) THEN CHD=CHD1;
                  ELSE IF (I=2) THEN CHD=CHD2;
                       ELSE CHD=CHD3;
                  IF (CH ='D') THEN D=CHD;
                  ELSE IF (CH='M') THEN M=CHD;
                       ELSE Y=CHD;
               END
               BEGIN
                  IF (ABS(CAST(Y AS INTEGER))<100) THEN
                  begin
                    CHD='0'; --ajouter 0 devant
                    IF (ABS(CAST(Y AS INTEGER))<10) THEN  CHD='00';--ajouter 00 devant
                    IF (SUBSTRING(Y from 1 for 1) IN ('-','+')) THEN
                       Y=SUBSTRING(Y from 1 for 1)||CHD||CAST(CAST(ABS(Y) AS INTEGER) AS varchar(2));
                    ELSE
                      Y=CHD||CAST(CAST(ABS(Y) AS INTEGER) AS varchar(2));
                  end
                  DDATE=CAST(M||'/'||D||'/'||Y AS DATE);
                  IMOIS=CAST(M AS INTEGER);
                  IAN=CAST(Y AS INTEGER);
                  IJOUR=extract(day from DDATE);
                  VALIDE=1;
                  WHEN ANY DO
                  begin
                     valide=0;
                     IAN=NULL;
                     IMOIS=NULL;
                     IJOUR=NULL;
                  end
               END
               if (placemois>0) then
               begin
                  if (placemois=1) then CHD=CHD1;
                  else if (placemois=2) then CHD=CHD2;
                       else if (placemois=3) then CHD=CHD3;
                  if (CHD<>M) then
                  begin
                     valide=0;
                     IAN=NULL;
                     IMOIS=NULL;
                     IJOUR=NULL;
                  end
               end
            end
         end
      end

      IF (IJOUR IS NOT NULL) THEN
        SELECT FIRST(1) TOKEN FROM REF_TOKEN_DATE
               WHERE TYPE_TOKEN=:TYPE_TOKEN AND SOUS_TYPE='D'
               INTO :TOKEN;
      IF (TOKEN IS NULL AND IMOIS IS NOT NULL) THEN
        SELECT FIRST(1) TOKEN FROM REF_TOKEN_DATE
               WHERE TYPE_TOKEN=:TYPE_TOKEN AND SOUS_TYPE='M'
               INTO :TOKEN;
      IF (TOKEN IS NULL AND IAN IS NOT NULL) THEN
        SELECT FIRST(1) TOKEN FROM REF_TOKEN_DATE
               WHERE TYPE_TOKEN=:TYPE_TOKEN AND SOUS_TYPE='Y'
               INTO :TOKEN;
      IF (TOKEN IS NULL AND IAN IS NOT NULL) THEN
        SELECT FIRST(1) TOKEN FROM REF_TOKEN_DATE
               WHERE TYPE_TOKEN=:TYPE_TOKEN
               ORDER BY ID
			   INTO :TOKEN;
    END
    SUSPEND;
end^
commit^

alter PROCEDURE PROC_DATE_WRITEN (
    DATE_WRITEN VARCHAR(100))
RETURNS (
    IMOIS INTEGER,
    IAN INTEGER,
    DDATE DATE,
    IMOIS_FIN INTEGER,
    IAN_FIN INTEGER,
    DDATE_FIN DATE,
    DATE_WRITEN_S VARCHAR(100),
    TYPE_TOKEN1 INTEGER,
    TYPE_TOKEN2 INTEGER,
    VALIDE SMALLINT)
AS
begin
  SUSPEND;
end^
commit work^

ALTER PROCEDURE PROC_ETAT_LISTE_ALPHA (
    I_DOSSIER INTEGER,
    I_SEXE INTEGER)
RETURNS (
    NOM VARCHAR(40) CHARACTER SET ISO8859_1,
    PRENOM VARCHAR(60) CHARACTER SET ISO8859_1,
    DATE_NAISSANCE VARCHAR(100) CHARACTER SET ISO8859_1,
    CP_NAISSANCE VARCHAR(10) CHARACTER SET ISO8859_1,
    LIEU_NAISSANCE VARCHAR(50) CHARACTER SET ISO8859_1,
    DATE_DECES VARCHAR(100) CHARACTER SET ISO8859_1,
    CP_DECES VARCHAR(10) CHARACTER SET ISO8859_1,
    LIEU_DECES VARCHAR(50) CHARACTER SET ISO8859_1,
    SEXE INTEGER,
    FILLIATION VARCHAR(30) CHARACTER SET ISO8859_1,
    LETTRE VARCHAR(1) CHARACTER SET ISO8859_1,
    AGE INTEGER,
    SOSA DOUBLE PRECISION,
    CLE_FICHE INTEGER)
AS
begin
   suspend;
end^
commit work^

ALTER PROCEDURE PROC_ETAT_LISTE_ALPHA_BORNE (
    I_DOSSIER INTEGER,
    I_DEBUT VARCHAR(20) CHARACTER SET ISO8859_1,
    I_FIN VARCHAR(20) CHARACTER SET ISO8859_1)
RETURNS (
    NOM VARCHAR(40) CHARACTER SET ISO8859_1,
    PRENOM VARCHAR(60) CHARACTER SET ISO8859_1,
    DATE_NAISSANCE VARCHAR(100) CHARACTER SET ISO8859_1,
    LIEU_NAISSANCE VARCHAR(61) CHARACTER SET ISO8859_1,
    DATE_DECES VARCHAR(100) CHARACTER SET ISO8859_1,
    LIEU_DECES VARCHAR(61) CHARACTER SET ISO8859_1,
    SEXE INTEGER,
    FILLIATION VARCHAR(30) CHARACTER SET ISO8859_1,
    LETTRE VARCHAR(1) CHARACTER SET ISO8859_1)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:08:21
   Modifiée le :
   à : :
   par :
   Description : Cette procedure permet de preparer l'etat alphabétique
                avec bornes
   Usage       :
   ---------------------------------------------------------------------------*/
   for
            SELECT  individu.nom,
              individu.prenom,
              naissance.ev_ind_date_writen Naissance,
              naissance.ev_ind_cp || ' ' || naissance.ev_ind_ville Lieu_Naissance,
              deces.ev_ind_date_writen Deces,
              deces.ev_ind_cp || ' ' || deces.ev_ind_ville Lieu_Deces,
              individu.sexe,
              individu.filliation,
              SUBSTRing(individu.nom from 1 for 1)
        FROM  individu
              LEFT JOIN evenements_ind naissance
                ON (individu.cle_fiche = naissance.ev_ind_kle_fiche and
                    naissance.ev_ind_type = 'BIRT' )
              LEFT JOIN evenements_ind deces
                ON (individu.cle_fiche = deces.ev_ind_kle_fiche and
                    deces.ev_ind_type = 'DEAT' )
        where individu.kle_dossier = :I_DOSSIER and
              UPPER(individu.nom) between UPPER(:I_DEBUT) and UPPER(:I_FIN)
        ORDER BY individu.nom, individu.prenom
        INTO  :NOM,
              :PRENOM,
              :DATE_NAISSANCE,
              :LIEU_NAISSANCE,
              :DATE_DECES,
              :LIEU_DECES,
              :SEXE,
              :FILLIATION,
              :LETTRE
   do
   suspend;
end^
commit work^

ALTER PROCEDURE PROC_EXPORT_IMAGES (
    I_DOSSIER INTEGER)
RETURNS (
    NOM VARCHAR(105),
    MULTI_MEDIA BLOB SUB_TYPE 0 SEGMENT SIZE 80)
AS
DECLARE VARIABLE I_CLEF INTEGER;
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE J INTEGER;
DECLARE VARIABLE NOM_TEMP VARCHAR(110) CHARACTER SET ISO8859_1;
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
      from multimedia m
      where m.multi_dossier=:i_dossier
        and m.multi_image_rtf=0
      into :i_clef
          ,:multi_media
          ,:nom_temp
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
    update multimedia m
    set m.multi_nom=:nom||'.jpg'
    where m.multi_clef=:i_clef;
    I=I+1;
    suspend;
  end
END^
commit work^

ALTER PROCEDURE PROC_FAVORIS_GRAPHE (
    I_DOSSIER INTEGER)
RETURNS (
    COMBIEN INTEGER,
    RDP_LIBELLE VARCHAR(30),
    RDP_CODE INTEGER)
AS
/*modifications par André le 16/05/2007*/
BEGIN
  FOR 
    Select  count(0),
            COALESCE(TRIM(v.EV_IND_DEPT),'Dépt. inconnu')
       from (SELECT DISTINCT EV_IND_VILLE
                            ,EV_IND_DEPT
             from proc_prep_villes_favoris(:I_DOSSIER)) as v
       inner join ref_departements r
               on r.rdp_libelle=v.ev_ind_dept
       group by r.RDP_PAYS,2
       order by r.RDP_PAYS,2
    INTO
      :COMBIEN, 
      :RDP_LIBELLE
  DO
    SUSPEND;
END^
commit work^

ALTER PROCEDURE PROC_GENEANET (
    S_PATRONYME VARCHAR(40) CHARACTER SET ISO8859_1,
    I_DOSSIER INTEGER,
    S_TYPE VARCHAR(10) CHARACTER SET ISO8859_1)
RETURNS (
    NOM VARCHAR(40) CHARACTER SET ISO8859_1,
    DATE_DEBUT INTEGER,
    DATE_FIN INTEGER,
    COMBIEN INTEGER,
    CP VARCHAR(10) CHARACTER SET ISO8859_1,
    VILLE VARCHAR(50) CHARACTER SET ISO8859_1,
    PAYS VARCHAR(30) CHARACTER SET ISO8859_1,
    PAYS_CODE VARCHAR(3) CHARACTER SET ISO8859_1)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:11:29
   Modifiée le :
   à : :
   par :
   Description : Pour l'export GENEANET
   Usage       :
   Parametres  : S_PATRONYME : un nom ou null pour tous
                 I_DOSSIER : N° de dossier
                 S_TYPE : on y passe le type dévenement souhaité (default : BIRT)
   ---------------------------------------------------------------------------*/
    S_TYPE = UPPER(TRIM(S_TYPE));
    S_PATRONYME = UPPER(TRIM(S_PATRONYME));
    if ((S_TYPE is Null) or ( S_TYPE = '' )) then S_TYPE = 'BIRT';
    if ((S_PATRONYME is Null) or (S_PATRONYME = '' )) then  S_PATRONYME = Null;
    FOR
        select  Ind.nom,
                Count(*),
                MIN(eve.ev_ind_date_year),
                MAX(eve.ev_ind_date_year),
                eve.ev_ind_cp,
                eve.ev_ind_ville,
                eve.ev_ind_pays,
                pays.rpa_abbreviation
            from individu Ind,
                 evenements_ind eve
            LEFT JOIN ref_pays pays
                ON (Upper(eve.ev_ind_pays) = Upper(pays.rpa_libelle))
            where Ind.cle_fiche = eve.ev_ind_kle_fiche AND
                  eve.ev_ind_type = :S_TYPE AND
                  eve.ev_ind_kle_dossier = :I_DOSSIER AND
                  ( Upper(ind.Nom) = Upper(:S_PATRONYME) AND :S_PATRONYME is not Null OR
                  ind.Nom Like '%' AND :S_PATRONYME is Null)
            group by nom,
                     ev_ind_ville,
                     ev_ind_cp,
                     ev_ind_pays,
                     rpa_abbreviation
            Order By nom,
                     ev_ind_cp
            INTO :NOM,
                 :COMBIEN,
                 :DATE_DEBUT,
                 :DATE_FIN,
                 :CP,
                 :VILLE,
                 :PAYS,
                 :PAYS_CODE
    DO
    suspend;
end
^
commit work^

ALTER PROCEDURE PROC_INSERT_LANGUE (
    A_TABLE VARCHAR(30) CHARACTER SET ISO8859_1,
    A_LANGUE_ORIGINE VARCHAR(3) CHARACTER SET ISO8859_1,
    A_LANGUE_DEST VARCHAR(3) CHARACTER SET ISO8859_1)
AS
DECLARE VARIABLE PR_LIBELLE VARCHAR(50);
DECLARE VARIABLE S_TEMPO VARCHAR(50);
DECLARE VARIABLE I_TYPE INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:13:17
   Modifiée le :
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
   if (A_TABLE = 'REF_PREFIXES') then begin
      FOR
         SELECT PR_LIBELLE
         FROM REF_PREFIXES
         WHERE LANGUE = :A_LANGUE_ORIGINE
         ORDER BY PR_LIBELLE
         INTO :PR_LIBELLE
      DO
         BEGIN
            if (char_length(PR_LIBELLE) > 25 )  then
               S_TEMPO = SUBSTRing(PR_LIBELLE from 1 for char_length(PR_LIBELLE) - 5);
            ELSE
               S_TEMPO = PR_LIBELLE;
            S_TEMPO = 'FRA: ' || S_TEMPO;
            INSERT
                INTO REF_PREFIXES
                    (PR_LIBELLE, LANGUE)
                VALUES
                    (:S_TEMPO, :A_LANGUE_DEST);
         END
   end
   /*-------------------------------------------------------------------------*/
   if (A_TABLE = 'REF_FILIATION') then begin
      FOR
         SELECT FIL_LIBELLE
         FROM REF_FILIATION
         WHERE FIL_LANGUE = :A_LANGUE_ORIGINE
         ORDER BY FIL_LIBELLE
         INTO :PR_LIBELLE
      DO
         BEGIN
            if (char_length(PR_LIBELLE) > 25 )  then
               S_TEMPO = SUBSTRing(PR_LIBELLE from 1 for char_length(PR_LIBELLE) - 5);
            ELSE
               S_TEMPO = PR_LIBELLE;
            S_TEMPO = 'FRA: ' || S_TEMPO;
            INSERT
                INTO REF_FILIATION
                    (FIL_LIBELLE, FIL_LANGUE)
                VALUES
                    (:S_TEMPO, :A_LANGUE_DEST);
         END
   end
   /*-------------------------------------------------------------------------*/
   if (A_TABLE = 'REF_ASSOCIATIONS') then begin
     FOR
         SELECT REF_ASSOC_LIBELLE,
                REF_ASSOC_TYPE
         FROM REF_ASSOCIATIONS
         WHERE LANGUE = :A_LANGUE_ORIGINE
         ORDER BY REF_ASSOC_LIBELLE
         INTO :PR_LIBELLE,
              :I_TYPE
      DO
         BEGIN
            if (char_length(PR_LIBELLE) > 45 )  then
               S_TEMPO = SUBSTRing(PR_LIBELLE from 1 for char_length(PR_LIBELLE) - 5);
            ELSE
               S_TEMPO = PR_LIBELLE;
            S_TEMPO = 'FRA: ' || S_TEMPO;
            INSERT
                INTO REF_ASSOCIATIONS
                    (REF_ASSOC_LIBELLE, REF_ASSOC_TYPE, LANGUE)
                VALUES
                    (:S_TEMPO, :I_TYPE, :A_LANGUE_DEST);
         END
    end
    /*------------------------------------------------------------------------*/
   if (A_TABLE = 'REF_PARTICULES') then begin
     FOR
         SELECT PART_LIBELLE
         FROM REF_PARTICULES
         WHERE LANGUE = :A_LANGUE_ORIGINE
         ORDER BY PART_LIBELLE
         INTO :PR_LIBELLE
      DO
         BEGIN
            if (char_length(PR_LIBELLE) > 5 )  then
               S_TEMPO = SUBSTRing(PR_LIBELLE from 1 for char_length(PR_LIBELLE) - 5);
            ELSE
               S_TEMPO = PR_LIBELLE;
            S_TEMPO = 'FRA: ' || S_TEMPO;
            INSERT
                INTO REF_PARTICULES
                    (PART_LIBELLE, LANGUE)
                VALUES
                    (:S_TEMPO, :A_LANGUE_DEST);
         END
    end
    /*------------------------------------------------------------------------*/
   if (A_TABLE = 'REF_RELA_TEMOINS') then begin
     FOR
         SELECT REF_RELA_LIBELLE,
                REF_RELA_CODE
         FROM REF_RELA_TEMOINS
         WHERE LANGUE = :A_LANGUE_ORIGINE
         ORDER BY REF_RELA_LIBELLE
         INTO :PR_LIBELLE,
              :I_TYPE
      DO
         BEGIN
            if (char_length(PR_LIBELLE) > 35 )  then
               S_TEMPO = SUBSTRing(PR_LIBELLE from 1 for char_length(PR_LIBELLE) - 5);
            ELSE
               S_TEMPO = PR_LIBELLE;
            S_TEMPO = 'FRA: ' || S_TEMPO;
            INSERT
                INTO REF_RELA_TEMOINS
                    (REF_RELA_LIBELLE, REF_RELA_CODE, LANGUE)
                VALUES
                    (:S_TEMPO, :I_TYPE, :A_LANGUE_DEST);
         END
    end
    /*------------------------------------------------------------------------*/
   if (A_TABLE = 'REF_RELIGION') then begin
     FOR
         SELECT RELI_LIBELLE
         FROM REF_RELIGION
         WHERE LANGUE = :A_LANGUE_ORIGINE
         ORDER BY RELI_LIBELLE
         INTO :PR_LIBELLE
      DO
         BEGIN
            if (char_length(PR_LIBELLE) > 35 )  then
               S_TEMPO = SUBSTRing(PR_LIBELLE from 1 for char_length(PR_LIBELLE) - 5);
            ELSE
               S_TEMPO = PR_LIBELLE;
            S_TEMPO = 'FRA: ' || S_TEMPO;
            INSERT
                INTO REF_RELIGION
                    (RELI_LIBELLE, LANGUE)
                VALUES
                    (:S_TEMPO, :A_LANGUE_DEST);
         END
    end
    /*------------------------------------------------------------------------*/
   if (A_TABLE = 'REF_TYPE_UNION') then begin
     FOR
         SELECT REF_TU_LIBELLE,
                REF_TU_CODE
         FROM REF_TYPE_UNION
         WHERE LANGUE = :A_LANGUE_ORIGINE
         ORDER BY REF_TU_LIBELLE
         INTO :PR_LIBELLE,
              :I_TYPE
      DO
         BEGIN
            if (char_length(PR_LIBELLE) > 35 )  then
               S_TEMPO = SUBSTRing(PR_LIBELLE from 1 for char_length(PR_LIBELLE) - 5);
            ELSE
               S_TEMPO = PR_LIBELLE;
            S_TEMPO = 'FRA: ' || S_TEMPO;
            INSERT
                INTO REF_TYPE_UNION
                    (REF_TU_LIBELLE, REF_TU_CODE, LANGUE)
                VALUES
                    (:S_TEMPO, :I_TYPE, :A_LANGUE_DEST);
         END
    end
    suspend;
end^
commit work^

ALTER PROCEDURE PROC_LR_MODIF_CASSE_NOM (
    I_DOSSIER INTEGER,
    I_MODE INTEGER)
AS
DECLARE VARIABLE ANCIEN_NOM VARCHAR(40);
DECLARE VARIABLE NOUVEAU_NOM VARCHAR(40);
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE I_LEN INTEGER;
DECLARE VARIABLE CHAINE VARCHAR(40);
DECLARE VARIABLE CAR VARCHAR(10);
DECLARE VARIABLE TOP_DEBMOT INTEGER;
DECLARE VARIABLE PARTICULE VARCHAR(10);
DECLARE VARIABLE LG_PARTICULE INTEGER;
DECLARE VARIABLE LG_NOM INTEGER;
DECLARE VARIABLE SUITE VARCHAR(1);
DECLARE VARIABLE TYPE_PARTIC VARCHAR(10);
begin
   /*---------------------------------------------------------------------------
   Copyright Laurent Robbe. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:14:10
   Modifiée le :
   à : :
   par :
   Description : Cette procedure modifie la casse du nom des individus
   Usage       : I_MODE = 0 : met en minuscules (avec première lettre en
                              majuscules)
                 I_MODE = 1 : met en majuscules
   ---------------------------------------------------------------------------*/
  for select distinct upper(nom)
          from individu 
          where KLE_DOSSIER = :I_DOSSIER
          into :ANCIEN_NOM
  do begin
    CHAINE = TRIM(ANCIEN_NOM);
    I_LEN = char_length(chaine);
    NOUVEAU_NOM='';
    if (I_MODE=2) then
    begin
      update individu
      set nom = upper(:CHAINE)
      where KLE_DOSSIER = :I_DOSSIER
      and upper(nom) = :ANCIEN_NOM;
    end
    else
    begin
      I = 1;
      TOP_DEBMOT = 1;
      while (I <= I_LEN) do
      begin
        CAR = substring(chaine from I for 1);
        if (CAR in(' ','-','''')) then
        begin
          TOP_DEBMOT = 1;
          NOUVEAU_NOM = NOUVEAU_NOM  || CAR;
        end
        else
        begin
          if ((TOP_DEBMOT=1) or (I_MODE=1)) then
          begin
            CAR= upper(CAR);
            NOUVEAU_NOM = NOUVEAU_NOM || CAR;
          end
          else
          begin
            CAR =lower(CAR);
            NOUVEAU_NOM = NOUVEAU_NOM || CAR;
          end
          TOP_DEBMOT = 0;
        end
        I = I + 1;
      end

      /* Gestion des particules pour Aquablue */
        LG_NOM=char_length(NOUVEAU_NOM);
        for select part_libelle
        from ref_particules
        into :PARTICULE
        do
        begin
          PARTICULE=TRIM(PARTICULE);
          LG_PARTICULE = char_length(PARTICULE);
          if (SUBSTRING(PARTICULE from LG_PARTICULE for 1)='''') then
            TYPE_PARTIC='APOSTROPHE';
          else
            TYPE_PARTIC='NORMAL';
          i=1;
          top_debmot=1;
          while (i<=LG_NOM - LG_PARTICULE+1) do
          begin
            if (top_debmot=1) then
            begin
              if (upper(SUBSTRING(NOUVEAU_NOM from i for LG_PARTICULE))=upper(PARTICULE)) then
              begin  --la particule est en position i
                if (i=LG_NOM - LG_PARTICULE+1) then --on est à la fin du mot
                  NOUVEAU_NOM=SUBSTRING(NOUVEAU_NOM from 1 for i-1)||PARTICULE;
                else
                begin
                  SUITE=SUBSTRING(NOUVEAU_NOM from i+LG_PARTICULE for 1);
                  if (TYPE_PARTIC='APOSTROPHE' or SUITE in(' ','''','(',')','-')) then
                    if (i=1) then
                    begin
                      NOUVEAU_NOM=PARTICULE||SUBSTRING(NOUVEAU_NOM from LG_PARTICULE+1);
                      i=LG_PARTICULE;
                    end
                    else
                    begin
                      NOUVEAU_NOM=SUBSTRING(NOUVEAU_NOM from 1 for i-1)||PARTICULE||SUBSTRING(NOUVEAU_NOM from i+LG_PARTICULE);
                      i=i+LG_PARTICULE-1;
                    end
                end
              end
            end
            SUITE=SUBSTRING(NOUVEAU_NOM from i for 1);
            if (SUITE in(' ','''','(',')','-')) then
              top_debmot=1;
            else
              top_debmot=0;
            i=i+1;
          end
        end
        update individu
           set nom = :NOUVEAU_NOM
           where KLE_DOSSIER = :I_DOSSIER
           and upper(nom)=:ANCIEN_NOM;
    end
  end
  suspend;
end^
commit work^

ALTER PROCEDURE PROC_LR_MODIF_CASSE_PRENOM (
    I_DOSSIER INTEGER,
    I_MODE INTEGER)
AS
DECLARE VARIABLE NOUVEAU_NOM VARCHAR(60);
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE I_LEN INTEGER;
DECLARE VARIABLE CHAINE VARCHAR(60);
DECLARE VARIABLE CAR VARCHAR(1);
DECLARE VARIABLE TOP_DEBMOT INTEGER;
DECLARE VARIABLE CLEF INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Laurent Robbe. Tous droits réservés.
   Créé le : 10/02/2004
   à : 19:14:10
   Modifiée le : 24/08/2006 par André erreurs dimentionnement variables
   et mode d'emploi, optimisation
   Description : Cette procedure modifie la casse du nom des individus
   Usage       : I_MODE = 0 : met en minuscules (avec première lettre en
                              majuscule)
                 I_MODE = 1 : met en majuscules accentuées  (identiques FB2)
                 I_MODE = 2 : met en majuscules avec UPPER
   ---------------------------------------------------------------------------*/
  if (I_MODE=1 or I_MODE=2) then
    begin
      update individu
        set prenom=upper(TRIM(prenom))
        where KLE_DOSSIER=:I_DOSSIER;
      exit;
    end
  for select cle_fiche, upper(TRIM(prenom))
          from individu
          where KLE_DOSSIER = :I_DOSSIER
          into :clef,
               :CHAINE
  do
  begin
    I_LEN=char_length(chaine);
    NOUVEAU_NOM='';
      I=1;
      TOP_DEBMOT=1;
      while (I<=I_LEN) do
      begin
        CAR=substring(chaine from i for 1);
        if (CAR in (' ','-','''')) then
        begin
          TOP_DEBMOT = 1;
          NOUVEAU_NOM = NOUVEAU_NOM  || CAR;
        end
        else
        begin
          if (TOP_DEBMOT=1) then
            NOUVEAU_NOM=NOUVEAU_NOM||CAR;
          else
          begin
            CAR = lower(CAR);
            NOUVEAU_NOM=NOUVEAU_NOM||CAR;
          end
          TOP_DEBMOT=0;
        end
        I=I+1;
      end
      update individu
        set prenom=:NOUVEAU_NOM
        where CLE_FICHE=:CLEF;
  end
end^
commit work^

ALTER PROCEDURE PROC_MAJ_EVE_FAM (
    I_DOSSIER INTEGER)
AS
DECLARE VARIABLE I_EVE INTEGER;
DECLARE VARIABLE I_RRG INTEGER;
DECLARE VARIABLE I_RPA INTEGER;
DECLARE VARIABLE S_CP VARCHAR(2);
DECLARE VARIABLE S_DEPT VARCHAR(30);
DECLARE VARIABLE S_REGION VARCHAR(30);
DECLARE VARIABLE S_PAYS VARCHAR(30);
DECLARE VARIABLE SDOMTOM VARCHAR(30);
begin
/*--------------------------------------------------------------------------
-
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:22:21
   Modifiée le :
   à : :
   par :
   Description : Mets a jour les champs
                 ville, dept, region, pays de la table evenement ind
   Usage       :
   -------------------------------------------------------------------------
--*/
 SELECT RPA_LIBELLE
     FROM PROC_TROUVE_DOMTOM('DOM')
     INTO :SDOMTOM;
     
  FOR SELECT
    SUBSTRing(fam.EV_fam_cp from 1 for 2),
    fam.EV_fam_CLEF
    FROM evenements_fam fam
    WHERE char_length(fam.ev_fam_cp) = 5 AND
          Upper(fam.EV_fam_PAYS) in('FRANCE',:SDOMTOM ) AND
          fam.ev_fam_kle_dossier = :I_DOSSIER
    INTO :S_CP,
         :I_EVE
    do
    begin
      S_DEPT = NULL;
      S_REGION = NULL;
      S_PAYS = NULL;
      SELECT
            RDP_LIBELLE,
            RRG_CODE,
            RDP_PAYS
            FROM ref_departements
            WHERE RDP_CODE = :S_CP
            INTO :S_DEPT,
                 :I_RRG,
                 :I_RPA;
      if (S_DEPT <> '' and S_DEPT IS NOT NULL) then
             begin
                SELECT RRG_LIBELLE
                   FROM ref_region
                   WHERE rrg_code = :I_RRG
                   INTO S_REGION;
                SELECT RPA_LIBELLE
                   FROM ref_pays
                   WHERE rpa_code = :I_RPA
                   INTO S_PAYS;
             end
      UPDATE evenements_fam
      SET
             ev_fam_dept = :S_DEPT,
             ev_fam_region = :S_REGION,
             ev_fam_pays = :S_PAYS
      WHERE EV_FAM_CLEF = :I_EVE;
    end
end^
commit work^

ALTER PROCEDURE PROC_MAJ_EVE_IND (
    I_DOSSIER INTEGER)
AS
DECLARE VARIABLE I_EVE INTEGER;
DECLARE VARIABLE I_RRG INTEGER;
DECLARE VARIABLE I_RPA INTEGER;
DECLARE VARIABLE S_CP CHAR(2);
DECLARE VARIABLE S_DEPT VARCHAR(30);
DECLARE VARIABLE S_REGION VARCHAR(30);
DECLARE VARIABLE S_PAYS VARCHAR(30);
DECLARE VARIABLE SDOMTOM VARCHAR(30);
begin
/*--------------------------------------------------------------------------
-
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:22:39
   Modifiée le : 26/12/2006 par André
   à : :
   par :
   Description : Mtes a jour les champs
                 ville, dept, region, pays de la table evenement ind
   Usage       :
   -------------------------------------------------------------------------
--*/
 SELECT RPA_LIBELLE
     FROM PROC_TROUVE_DOMTOM('DOM')
     INTO :SDOMTOM;
     
  FOR SELECT
    SUBSTRing(eve.EV_ind_cp from 1 for 2),
    eve.EV_IND_CLEF
    FROM evenements_ind eve
    WHERE char_length(eve.ev_ind_cp) = 5 AND
         Upper(eve.EV_IND_PAYS) in('FRANCE',:SDOMTOM ) AND
          eve.ev_ind_kle_dossier = :I_DOSSIER
    INTO :S_CP,
         :I_EVE
    do
       begin
          S_DEPT = NULL;
          S_REGION = NULL;
          S_PAYS = NULL;
          SELECT
            RDP_LIBELLE,
            RRG_CODE,
            RDP_PAYS
            FROM ref_departements
            WHERE RDP_CODE = :S_CP
            INTO :S_DEPT,
                 :I_RRG,
                 :I_RPA;
          if (S_DEPT <> '' and S_DEPT IS NOT NULL) then
             begin
                SELECT RRG_LIBELLE
                   FROM ref_region
                   WHERE rrg_code = :I_RRG
                   INTO S_REGION;
                SELECT RPA_LIBELLE
                   FROM ref_pays
                   WHERE rpa_code = :I_RPA
                   INTO S_PAYS;
             end
          UPDATE evenements_ind
          SET
             ev_ind_dept = :S_DEPT,
             ev_ind_region = :S_REGION,
             ev_ind_pays = :S_PAYS
          WHERE EV_IND_CLEF = :I_EVE;
       end
end^
commit work^

ALTER PROCEDURE PROC_MAJ_INSEE (
    I_DOSSIER INTEGER)
AS
begin
exit; end^
commit work^

ALTER PROCEDURE PROC_SEPARATION_PRENOMS (
    I_DOSSIER INTEGER,
    I_VIRGULE INTEGER)
AS
DECLARE VARIABLE NOUVEAU_NOM VARCHAR(60) CHARACTER SET ISO8859_1;
DECLARE VARIABLE SEPARATION INTEGER;
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE I_LEN INTEGER;
DECLARE VARIABLE CHAINE VARCHAR(60) CHARACTER SET ISO8859_1;
DECLARE VARIABLE CAR VARCHAR(1) CHARACTER SET ISO8859_1;
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
commit work^

ALTER PROCEDURE PROC_STATISTIQUES (
    I_DOSSIER INTEGER,
    I_QUI INTEGER,
    I_QUOI INTEGER)
RETURNS (
    COMBIEN INTEGER,
    DEPT VARCHAR(30) CHARACTER SET ISO8859_1,
    CODE VARCHAR(30) CHARACTER SET ISO8859_1)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tous droits réservés.
   Créé le : 31/07/2001
   à : 19:31:40
   Modifiée le : 24/01/2006 corrections fonctionnelles par André
   à : :
   par :
   Description : Remonte les statistiques
   Naissance par dept
   Mort part dept
   Usage       :
   ---------------------------------------------------------------------------*/
   if (:I_QUOI = 0) then /* sélection sur département*/
     for
      SELECT  Count(0),
              COALESCE(TRIM(EVE.EV_IND_DEPT),'')
         FROM EVENEMENTS_IND EVE
           LEFT JOIN  REF_DEPARTEMENTS DEPT
             ON DEPT.RDP_LIBELLE=EVE.EV_IND_DEPT
           where EVE.EV_IND_KLE_DOSSIER = :I_DOSSIER AND
               ((EVE.EV_IND_TYPE = 'BIRT' and :I_QUI = 1) OR
               (EVE.EV_IND_TYPE = 'DEAT' and :I_QUI = 0))
         GROUP BY DEPT.RDP_PAYS,2
         ORDER BY DEPT.RDP_PAYS,2
         INTO :COMBIEN,
              :DEPT
     do
       begin
         if (DEPT='') then DEPT='Département inconnu';
         suspend;
       end
   else
   if (:I_QUOI = 1) then  /* sélection sur pays*/
     for
        SELECT  Count(0),
                COALESCE(TRIM(upper(EVE.EV_IND_PAYS)),'')
        FROM EVENEMENTS_IND EVE
        where EVE.EV_IND_KLE_DOSSIER = :I_DOSSIER AND
              ((EVE.EV_IND_TYPE = 'BIRT' and :I_QUI = 1) OR
              (EVE.EV_IND_TYPE = 'DEAT' and :I_QUI = 0))
              GROUP BY 2
              ORDER BY 2
        INTO :COMBIEN,
             :DEPT
     do
       begin
         if (DEPT='') then DEPT='Pays inconnu';
         DEPT=upper(dept);
         suspend;
       end
end^
commit work^

ALTER PROCEDURE PROC_TROUVE_DOMTOM (
    SCODE VARCHAR(3) CHARACTER SET ISO8859_1)
RETURNS (
    RPA_LIBELLE VARCHAR(30) CHARACTER SET ISO8859_1)
AS
DECLARE VARIABLE SRPA_CODE INTEGER;
BEGIN

  if (sCode = 'DOM') then
     SRPA_CODE = 97000;
  if (sCode = 'TOM') then
     SRPA_CODE = 98000;
  FOR
    SELECT TRIM(RPA_LIBELLE)
    FROM ref_pays
    WHERE RPA_CODE = :SRPA_CODE
    INTO
      :RPA_LIBELLE
  DO
  BEGIN
    SUSPEND;
  END
END^
commit work^

ALTER PROCEDURE PROC_AFTER_IMPORT (
    I_DOSSIER INTEGER,
    I_MODE INTEGER)
AS
begin exit; end^
COMMIT WORK^

alter PROCEDURE PROC_PREP_VILLES_FAVORIS (
    I_DOSSIER INTEGER)
RETURNS (
    EV_IND_VILLE VARCHAR(50),
    EV_IND_CP VARCHAR(10),
    EV_IND_DEPT VARCHAR(30),
    EV_IND_REGION VARCHAR(50),
    EV_IND_PAYS VARCHAR(30),
    EV_IND_INSEE VARCHAR(6),
    EV_IND_SUBD VARCHAR(50),
    EV_IND_LATITUDE DOUBLE PRECISION,
    EV_IND_LONGITUDE DOUBLE PRECISION)
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 21:29:58
   Modifiée le : 05/09/2006 ajouté SUBD, LATITUDE et LONGITUDE
   par : André
   Description :
   Usage       :
   ---------------------------------------------------------------------------*/
FOR SELECT DISTINCT EV_IND_VILLE
                   ,EV_IND_CP
                   ,EV_IND_DEPT
                   ,EV_IND_REGION
                   ,EV_IND_PAYS
                   ,EV_IND_INSEE
                   ,EV_IND_SUBD
                   ,EV_IND_LATITUDE
                   ,EV_IND_LONGITUDE
       FROM evenements_ind
       WHERE EV_IND_KLE_DOSSIER = :I_DOSSIER AND
             EV_IND_VILLE IS NOT NULL
UNION SELECT DISTINCT EV_FAM_VILLE
                   ,EV_FAM_CP
                   ,EV_FAM_DEPT
                   ,EV_FAM_REGION
                   ,EV_FAM_PAYS
                   ,EV_FAM_INSEE
                   ,EV_FAM_SUBD
                   ,EV_FAM_LATITUDE
                   ,EV_FAM_LONGITUDE
       FROM evenements_fam
       WHERE EV_FAM_KLE_DOSSIER = :I_DOSSIER AND
             EV_FAM_VILLE IS NOT NULL
UNION SELECT DISTINCT ADR_VILLE
                   ,ADR_CP
                   ,ADR_DEPT
                   ,ADR_REGION
                   ,ADR_PAYS
                   ,ADR_INSEE
                   ,ADR_SUBD
                   ,ADR_LATITUDE
                   ,ADR_LONGITUDE
      FROM ADRESSES_IND
      WHERE ADR_KLE_DOSSIER = :I_DOSSIER AND
             ADR_VILLE IS NOT NULL
    INTO :EV_IND_VILLE,
         :EV_IND_CP,
         :EV_IND_DEPT,
         :EV_IND_REGION,
         :EV_IND_PAYS,
         :EV_IND_INSEE,
         :EV_IND_SUBD,
         :EV_IND_LATITUDE,
         :EV_IND_LONGITUDE
  DO
  BEGIN
    SUSPEND;
  END
END^
commit^

ALTER PROCEDURE PROC_VILLES_FAVORIS (
    I_DOSSIER INTEGER)
RETURNS (
    FAV_ID INTEGER,
    EV_IND_VILLE VARCHAR(50),
    EV_IND_CP VARCHAR(10),
    EV_IND_DEPT VARCHAR(30),
    EV_IND_REGION VARCHAR(50),
    EV_IND_PAYS VARCHAR(30),
    EV_IND_INSEE VARCHAR(6),
    EV_IND_SUBD VARCHAR(50),
    EV_IND_LATITUDE DECIMAL(15,8),
    EV_IND_LONGITUDE NUMERIC(15,8))
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 21:29:58
   Modifiée le : 05/09/2006 par André ajouté SUBD, LATITUDE et LONGITUDE
appel à PROC_PREP_VILLES_FAVORIS pour ajouter champ indexé sur distinct trié
   Description :
   Usage       :
   ---------------------------------------------------------------------------*/
FAV_ID=0;
FOR SELECT DISTINCT EV_IND_VILLE
                   ,EV_IND_CP
                   ,EV_IND_DEPT
                   ,EV_IND_REGION
                   ,EV_IND_PAYS
                   ,EV_IND_INSEE
                   ,EV_IND_SUBD
                   ,EV_IND_LATITUDE
                   ,EV_IND_LONGITUDE
                   ,:FAV_ID+1
      FROM PROC_PREP_VILLES_FAVORIS(:I_DOSSIER)
      ORDER BY EV_IND_VILLE collate FR_FR
              ,EV_IND_SUBD collate FR_FR NULLS FIRST
    INTO :EV_IND_VILLE,
         :EV_IND_CP,
         :EV_IND_DEPT,
         :EV_IND_REGION,
         :EV_IND_PAYS,
         :EV_IND_INSEE,
         :EV_IND_SUBD,
         :EV_IND_LATITUDE,
         :EV_IND_LONGITUDE,
         :FAV_ID
DO
  SUSPEND;
END^
COMMIT WORK^

alter PROCEDURE PROC_PREP_VILLES_RAYON (
    LIMITE DOUBLE PRECISION,
    LATITUDEA DOUBLE PRECISION,
    LONGITUDEA DOUBLE PRECISION,
    I_DOSSIER INTEGER)
RETURNS (
    CP_CODE INTEGER,
    CP_CP VARCHAR(8),
    CP_PREFIXE VARCHAR(4),
    CP_VILLE VARCHAR(103),
    CP_INDIC_TEL VARCHAR(2),
    CP_DEPT INTEGER,
    CP_REGION INTEGER,
    CP_PAYS INTEGER,
    CP_INSEE VARCHAR(6),
    CP_HABITANTS DOUBLE PRECISION,
    CP_DENSITE DOUBLE PRECISION,
    CP_DIVERS VARCHAR(90),
    CP_LATITUDE DOUBLE PRECISION,
    CP_LONGITUDE DOUBLE PRECISION,
    CP_MAJ_INSEE INTEGER,
    CP_VILLE_MAJ VARCHAR(50),
    DISTANCE DOUBLE PRECISION)
AS
DECLARE VARIABLE DEGRAD DOUBLE PRECISION;
DECLARE VARIABLE SINLAT DOUBLE PRECISION;
DECLARE VARIABLE COSLAT DOUBLE PRECISION;
DECLARE VARIABLE DELTALAT DOUBLE PRECISION;
DECLARE VARIABLE DELTALONG DOUBLE PRECISION;
DECLARE VARIABLE LATMAX DOUBLE PRECISION;
DECLARE VARIABLE LATMIN DOUBLE PRECISION;
DECLARE VARIABLE LONGMAX DOUBLE PRECISION;
DECLARE VARIABLE LONGMIN DOUBLE PRECISION;
begin
/*création par André, modifiée le 09/02/2007*/
DegRad=pi()/180;
SinLat=Sin(LATITUDEA*DegRad);
CosLat=Cos(LATITUDEA*DegRad);
deltalat=limite/6367;
latmax=latitudea+deltalat/Degrad;
latmin=latitudea-deltalat/Degrad;
if (latmax>90 or latmin<-90) then
begin
   longmax=180;
   longmin=-180;
end
else
begin
   deltalong=asin(deltalat/coslat)/DegRad;
   longmax=longitudea+deltalong;
   longmin=longitudea-deltalong;
end
if (I_DOSSIER>0) then
  FOR
  SELECT
         EV_IND_CP,
         COALESCE(EV_IND_VILLE,'')||COALESCE(' - '||EV_IND_SUBD,''),
         EV_IND_INSEE,
         EV_IND_LATITUDE,
         EV_IND_LONGITUDE
  FROM PROC_PREP_VILLES_FAVORIS(:I_DOSSIER)
  WHERE EV_IND_LATITUDE between :latmin and :latmax
    and (ev_ind_longitude between :longmin and :longmax
         or ev_ind_longitude between :longmin+360 and 180
         or ev_ind_longitude between -180 and :longmax-360)
  INTO
        :CP_CP,
        :CP_VILLE,
        :CP_INSEE,
        :CP_LATITUDE,
        :CP_LONGITUDE
  DO
  begin
    if (CP_LATITUDE=LATITUDEA and CP_LONGITUDE=LONGITUDEA) then
    begin
       distance=0;
       suspend;
    end
    else
    begin
       distance=6367*Acos(SinLat*Sin(CP_LATITUDE*DegRad)+CosLat*Cos(CP_LATITUDE*DegRad)*Cos((LONGITUDEA-CP_LONGITUDE)*DegRad));
       if (distance<=limite) then
          suspend;
    end
  end
else
  FOR
  SELECT
         CP_CODE,
         CP_CP,
         CP_PREFIXE,
         CP_VILLE,
         CP_INDIC_TEL,
         CP_DEPT,
         CP_REGION,
         CP_PAYS,
         CP_INSEE,
         CP_HABITANTS,
         CP_DENSITE,
         CP_DIVERS,
         CP_LATITUDE,
         CP_LONGITUDE,
         CP_MAJ_INSEE,
         CP_VILLE_MAJ
  FROM REF_CP_VILLE
  WHERE CP_LATITUDE between cast(:latmin as decimal(15,8)) and cast(:latmax as decimal(15,8))
    and (cp_longitude between cast(:longmin as decimal(15,8)) and cast(:longmax as decimal(15,8))
         or cp_longitude between cast(:longmin+360 as decimal(15,8)) and cast(180 as decimal(15,8))
         or cp_longitude between cast(-180 as decimal(15,8)) and cast(:longmax-360 as decimal(15,8)))
  INTO
        :CP_CODE,
        :CP_CP,
        :CP_PREFIXE,
        :CP_VILLE,
        :CP_INDIC_TEL,
        :CP_DEPT,
        :CP_REGION,
        :CP_PAYS,
        :CP_INSEE,
        :CP_HABITANTS,
        :CP_DENSITE,
        :CP_DIVERS,
        :CP_LATITUDE,
        :CP_LONGITUDE,
        :CP_MAJ_INSEE,
        :CP_VILLE_MAJ
  DO
  begin
    if (CP_LATITUDE=LATITUDEA and CP_LONGITUDE=LONGITUDEA) then
    begin
       distance=0;
       suspend;
    end
    else
    begin
       distance=6367*Acos(SinLat*Sin(CP_LATITUDE*DegRad)+CosLat*Cos(CP_LATITUDE*DegRad)*Cos((LONGITUDEA-CP_LONGITUDE)*DegRad));
       if (distance<=limite) then
          suspend;
    end
  end
end^
commit^

alter PROCEDURE PROC_VILLES_RAYON (
    LIMITE DOUBLE PRECISION,
    LATITUDEA DOUBLE PRECISION,
    LONGITUDEA DOUBLE PRECISION,
    I_DOSSIER INTEGER)
RETURNS (
    CP_CODE INTEGER,
    CP_CP VARCHAR(8),
    CP_PREFIXE VARCHAR(4),
    CP_VILLE VARCHAR(103),
    CP_INDIC_TEL VARCHAR(2),
    CP_DEPT INTEGER,
    CP_REGION INTEGER,
    CP_PAYS INTEGER,
    CP_INSEE VARCHAR(6),
    CP_HABITANTS DOUBLE PRECISION,
    CP_DENSITE DOUBLE PRECISION,
    CP_DIVERS VARCHAR(90),
    CP_LATITUDE DECIMAL(15,8),
    CP_LONGITUDE NUMERIC(15,8),
    CP_MAJ_INSEE INTEGER,
    CP_VILLE_MAJ VARCHAR(50),
    DISTANCE DECIMAL(15,2))
AS
begin
  FOR SELECT
         CP_CODE,
         CP_CP,
         CP_PREFIXE,
         CP_VILLE,
         CP_INDIC_TEL,
         CP_DEPT,
         CP_REGION,
         CP_PAYS,
         CP_INSEE,
         CP_HABITANTS,
         CP_DENSITE,
         CP_DIVERS,
         CP_LATITUDE,
         CP_LONGITUDE,
         CP_MAJ_INSEE,
         CP_VILLE_MAJ,
         DISTANCE
  FROM PROC_PREP_VILLES_RAYON(:LIMITE,:LATITUDEA,:LONGITUDEA,:I_DOSSIER)
  order by DISTANCE,CP_VILLE collate FR_FR
  INTO
        :CP_CODE,
        :CP_CP,
        :CP_PREFIXE,
        :CP_VILLE,
        :CP_INDIC_TEL,
        :CP_DEPT,
        :CP_REGION,
        :CP_PAYS,
        :CP_INSEE,
        :CP_HABITANTS,
        :CP_DENSITE,
        :CP_DIVERS,
        :CP_LATITUDE,
        :CP_LONGITUDE,
        :CP_MAJ_INSEE,
        :CP_VILLE_MAJ,
        :DISTANCE
  DO
  suspend;
end^
COMMIT WORK^

ALTER PROCEDURE PROC_LISTE_PRENOM (
    I_DOSSIER INTEGER)
RETURNS (
    PRENOM VARCHAR(60),
    SEXE INTEGER,
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM_COMPLET VARCHAR(60),
    CLE_PERE INTEGER,
    CLE_MERE INTEGER)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:14:10
   Modifiée le :24/10/2006 par André, éclatement en 2 procédures
   Description : Cette procedure remonte la liste de tous les prenoms du
   dossier passé en parametres, les prenoms séparés par des
   virgules ou espaces seront décomposés.
   ---------------------------------------------------------------------------*/
  for  select SEXE,CLE_FICHE,NOM,PRENOM,
              CLE_PERE,CLE_MERE
          from individu
          where KLE_DOSSIER=:I_DOSSIER
          INTO :SEXE,:CLE_FICHE,:NOM,:PRENOM_COMPLET,
               :CLE_PERE,:CLE_MERE
  do for select prenom from proc_eclate_prenom(:PRENOM_COMPLET)
         where prenom is not null
         into :prenom
     do suspend;
end^
COMMIT WORK^

/*
--ajout de collate FR_FR aux champs texte
ALTER TABLE REF_FILIATION DROP CONSTRAINT PK_REF_FILIATION^
COMMIT WORK^

update rdb$relation_fields r
set r.rdb$collation_id=4
where r.rdb$collation_id=0
and (select rdb$character_set_id from rdb$fields
     where rdb$field_name=r.rdb$field_source)=21
and (select rdb$field_type from rdb$fields
     where rdb$field_name=r.rdb$field_source)=37^
COMMIT WORK^

alter table REF_FILIATION
add constraint PK_REF_FILIATION
primary key (FIL_LIBELLE,FIL_LANGUE)^
COMMIT WORK^
*/
alter PROCEDURE PROC_EVE_IND (
    I_CLE INTEGER)
RETURNS (
    EV_IND_CLEF INTEGER,
    EV_IND_KLE_FICHE INTEGER,
    EV_IND_KLE_DOSSIER INTEGER,
    EV_IND_TYPE VARCHAR(7),
    EV_IND_DATE_WRITEN VARCHAR(100),
    EV_IND_DATE_YEAR INTEGER,
    EV_IND_DATE DATE,
    EV_IND_ADRESSE VARCHAR(50),
    EV_IND_CP VARCHAR(10),
    EV_IND_VILLE VARCHAR(50),
    EV_IND_DEPT VARCHAR(30),
    EV_IND_PAYS VARCHAR(30),
    EV_IND_CAUSE VARCHAR(90),
    EV_IND_SOURCE BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    EV_IND_COMMENT BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    EV_IND_TYPEANNEE INTEGER,
    EV_IND_DESCRIPTION VARCHAR(90),
    EV_IND_REGION VARCHAR(50),
    EV_IND_SUBD VARCHAR(50),
    EV_LIBELLE VARCHAR(30),
    EV_IND_ACTE INTEGER,
    EV_IND_INSEE VARCHAR(6),
    EV_IND_HEURE TIME,
    EV_IND_ORDRE INTEGER,
    EV_IND_TITRE_EVENT VARCHAR(40),
    EV_IND_LATITUDE DECIMAL(15,8),
    EV_IND_LONGITUDE NUMERIC(15,8),
    EV_IND_MEDIA INTEGER,
    EV_IND_AGE INTEGER)
AS
BEGIN
    SUSPEND;
END^
COMMIT WORK^

alter PROCEDURE PROC_ETAT_EVENEMENTS_SANS_TRI (
    I_CLEF INTEGER,
    S_MODE VARCHAR(1))
RETURNS (
    EV_IND_KLE_FICHE INTEGER,
    EV_IND_TYPE VARCHAR(7),
    EV_IND_DATE_WRITEN VARCHAR(100),
    EV_IND_DATE_YEAR INTEGER,
    EV_IND_DATE_MOIS INTEGER,
    EV_IND_DATE DATE,
    EV_IND_ADRESSE VARCHAR(50),
    EV_IND_CP VARCHAR(10),
    EV_IND_VILLE VARCHAR(50),
    EV_IND_DEPT VARCHAR(30),
    EV_IND_PAYS VARCHAR(30),
    EV_IND_CAUSE VARCHAR(90),
    EV_IND_SOURCE BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    EV_IND_COMMENT BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    EV_IND_DESCRIPTION VARCHAR(90),
    EV_IND_REGION VARCHAR(50),
    EV_IND_SUBD VARCHAR(50),
    EV_LIBELLE VARCHAR(30),
    EV_IND_INSEE VARCHAR(6),
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    NOM_COMPLET VARCHAR(160),
    SEXE INTEGER,
    TYPE_EVENT VARCHAR(3),
    SOURCE_VIDE INTEGER,
    COMMENT_VIDE INTEGER)
AS
begin suspend; end^
commit^


ALTER PROCEDURE PROC_ETAT_EVENEMENTS (
    I_DOSSIER INTEGER)
RETURNS (
    DATE_EVE VARCHAR(100),
    CP VARCHAR(10),
    VILLE VARCHAR(50),
    S_TYPE VARCHAR(7),
    NOM_COMPLET VARCHAR(160),
    SEXE INTEGER)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:07:26
   Modifiée le :23/08/2006 par André: redéfinition de l'ordre de tri et ajout ev_fam
   30/10/2006 ajout adresses, 30/08/07 suppression NOM et PRENOM
   par :
   Description : Cette procedure permet de récuperer tous les evements
                 d'un dossier
   Usage       :
   ---------------------------------------------------------------------------*/
   FOR SELECT  distinct EV_IND_DATE_WRITEN
              ,EV_IND_TYPE
              ,EV_IND_CP
              ,EV_IND_VILLE
              ,NOM_COMPLET
              ,SEXE
          FROM PROC_ETAT_EVENEMENTS_SANS_TRI(:I_DOSSIER,'D')
          ORDER BY EV_IND_DATE_YEAR NULLS LAST
                  ,EV_IND_DATE_MOIS NULLS LAST
                  ,EV_IND_DATE NULLS LAST
          INTO :DATE_EVE
              ,:s_type
              ,:CP
              ,:VILLE
              ,:NOM_COMPLET
              ,:SEXE
   do
   suspend;
end ^
COMMIT WORK ^

ALTER PROCEDURE PROC_NEW_PRENOMS (
    I_DOSSIER INTEGER)
AS
begin
exit; end^
COMMIT WORK ^

alter TRIGGER TRIG_PRENOMS_BIBU 
ACTIVE BEFORE INSERT OR UPDATE POSITION 0
as
begin
if (new.sexe<>old.sexe) then new.sexe=0;
end^
commit^

update RDB$RELATION_FIELDS set
RDB$COLLATION_ID = 5
where (RDB$FIELD_NAME = 'NOM') and
(RDB$RELATION_NAME = 'INDIVIDU')^
commit^

update RDB$RELATION_FIELDS set
RDB$COLLATION_ID = 5
where (RDB$FIELD_NAME = 'PRENOM') and
(RDB$RELATION_NAME = 'INDIVIDU')^
commit^

alter TRIGGER T_AIU_INDIVIDU
ACTIVE AFTER INSERT OR UPDATE POSITION 0
as
begin
exit; end^
commit^

drop TRIGGER T_BI_INDIVIDU^
commit^

drop TRIGGER T_BU_INDIVIDU^
commit^

alter PROCEDURE PROC_TROUVE_IND_PAR_LETTRE (
    A_LETTRE VARCHAR(1),
    I_DOSSIER INTEGER)
RETURNS (
    NOM VARCHAR(40))
AS
BEGIN suspend; END^
commit^

update RDB$RELATION_FIELDS set
RDB$COLLATION_ID = 4
where (RDB$FIELD_NAME = 'TOKEN') and
(RDB$RELATION_NAME = 'REF_TOKEN_DATE')^
commit^

ALTER TRIGGER AI_REF_CP_VILLE_CP_CODE
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.CP_CODE IS NULL) THEN
      NEW.CP_CODE = GEN_ID(GEN_REF_CP_VILLE, 1);
  select s_out from f_maj_sans_accent(NEW.CP_VILLE) into NEW.CP_VILLE_MAJ;
END^
commit^

ALTER TRIGGER BU_REF_CP_VILLE
ACTIVE BEFORE UPDATE POSITION 0
as
begin
  select s_out from f_maj_sans_accent(NEW.CP_VILLE) into NEW.CP_VILLE_MAJ;
end^
commit^

ALTER PROCEDURE PROC_ETAT_ECLAIR (
    I_DOSSIER INTEGER,
    I_SOSA INTEGER,
    A_VILLE VARCHAR(50))
RETURNS (
    NOM VARCHAR(40),
    CP VARCHAR(10),
    VILLE VARCHAR(50),
    PAYS VARCHAR(30),
    DATE_DEBUT INTEGER,
    DATE_FIN INTEGER,
    NAISSANCE INTEGER,
    BAPTEME INTEGER,
    MARIAGE INTEGER,
    DECES INTEGER,
    SEP INTEGER,
    INSEE VARCHAR(6),
    DEPT VARCHAR(30),
    REGION VARCHAR(50))
AS
DECLARE VARIABLE I INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:07:00
   Modifiée le :23/12/2006 par André
   Refonte complète le 26/10/2006 par André (avec TQ_ECLAIR et état) pour calculer
   les nombres de naissances, baptêmes, mariages, décès et sépultures, ajouter le champ INSEE
   Description : Pour l'état de la liste eclair
   Usage       :
   Parametres  : I_DOSSIER : N° de dossier
                 I_SOSA : si 1 on ne sort que les ind avec N° sosa
                 S_VILLE : si une ville alors on ne remonte que pour cette ville
   ---------------------------------------------------------------------------*/
    select s_out from f_maj_sans_accent(:a_ville) into :a_ville;
    if (A_VILLE='') then
      a_ville='%';
    if (I_SOSA is null) then I_SOSA = 0;
    DELETE FROM TQ_ECLAIR;
    I=gen_id(GEN_TQ_ECLAIR,-gen_id(GEN_TQ_ECLAIR,0));
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
commit^

ALTER PROCEDURE PROC_DOUBLONS_FIND (
    I_DOSSIER INTEGER,
    CLE_IND INTEGER,
    PRENOM_VARIABLE INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISS VARCHAR(100),
    LIEU_NAISS VARCHAR(50),
    DATE_DECES VARCHAR(100),
    LIEU_DECES VARCHAR(50))
AS
DECLARE VARIABLE I_CLE_FICHE INTEGER;
DECLARE VARIABLE DATE_N DATE;
DECLARE VARIABLE DATE_N_FIN DATE;
DECLARE VARIABLE VILLE_N VARCHAR(50);
DECLARE VARIABLE DATE_D DATE;
DECLARE VARIABLE DATE_D_FIN DATE;
DECLARE VARIABLE VILLE_D VARCHAR(50);
DECLARE VARIABLE DN_IMOIS INTEGER;
DECLARE VARIABLE DN_IAN INTEGER;
DECLARE VARIABLE DN_DDATE DATE;
DECLARE VARIABLE DN_IMOIS_FIN INTEGER;
DECLARE VARIABLE DN_IAN_FIN INTEGER;
DECLARE VARIABLE DN_DDATE_FIN DATE;
DECLARE VARIABLE DN_TYPE_TOKEN1 INTEGER;
DECLARE VARIABLE DN_TYPE_TOKEN2 INTEGER;
DECLARE VARIABLE DD_IMOIS INTEGER;
DECLARE VARIABLE DD_IAN INTEGER;
DECLARE VARIABLE DD_DDATE DATE;
DECLARE VARIABLE DD_IMOIS_FIN INTEGER;
DECLARE VARIABLE DD_IAN_FIN INTEGER;
DECLARE VARIABLE DD_DDATE_FIN DATE;
DECLARE VARIABLE DD_TYPE_TOKEN1 INTEGER;
DECLARE VARIABLE DD_TYPE_TOKEN2 INTEGER;
DECLARE VARIABLE DATE_N_W VARCHAR(100);
DECLARE VARIABLE DATE_D_W VARCHAR(100);
DECLARE VARIABLE S_NOM VARCHAR(40);
DECLARE VARIABLE S_PRENOM VARCHAR(60);
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE CLE_FICHE2 INTEGER;
DECLARE VARIABLE NOM2 VARCHAR(40);
DECLARE VARIABLE PRENOM2 VARCHAR(60);
DECLARE VARIABLE DATE_NAISS2 VARCHAR(100);
DECLARE VARIABLE LIEU_NAISS2 VARCHAR(50);
DECLARE VARIABLE DATE_DECES2 VARCHAR(100);
DECLARE VARIABLE LIEU_DECES2 VARCHAR(50);
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 18:14:37
   Modifiée le :16/11/2006 par André pour élargir aux doublons "possibles"
   avec en option l'élargissement aux indis ayant les mêmes prénoms dans un
   ordre différent
   Description :remonte la liste des doublons contenus dans le dossier I_DOSSIER
   Usage       :si CLE_IND=0 tout le dossier est analysé,
   si CLE_IND>0 on recherche les doublons de l'individu.
   PRENOM_VARIABLE=0 impose la similitude complète de la liste des prénoms
   des individus doublons.
   PRENOM_VARIABLE=1 demande que tous les prénoms de l'un soient contenus dans
   les prénoms de l'autre.
   PRENOM_VARIABLE=2 et 3 sont similaires respectivement à 0 et 1, mais la
   recherche s'effectue sur tous les individus du même patronyme que CLE_IND.
   ---------------------------------------------------------------------------*/
  delete from tq_id;
  delete from tq_rech_doublons;
  for select i.cle_fiche
            ,i.nom
            ,i.prenom
            ,i.date_naissance
            ,i.date_deces
            ,n.ev_ind_ville
            ,d.ev_ind_ville
         from individu i
           left join evenements_ind n on n.ev_ind_kle_fiche=i.cle_fiche and n.ev_ind_type='BIRT'
           left join evenements_ind d on d.ev_ind_kle_fiche=i.cle_fiche and d.ev_ind_type='DEAT'
         where i.kle_dossier=:I_DOSSIER
           and (:cle_ind=0 or i.nom=(select nom from individu where cle_fiche=:cle_ind))
         into :i_cle_fiche
             ,:s_nom
             ,:s_prenom
             ,:date_n_w
             ,:date_d_w
             ,:ville_n
             ,:ville_d
      do
      begin
        select imois
              ,ian
              ,ddate
              ,imois_fin
              ,ian_fin
              ,ddate_fin
              ,type_token1
              ,type_token2
          from proc_date_writen(:date_n_w)
          into :dn_imois
              ,:dn_ian
              ,:dn_ddate
              ,:dn_imois_fin
              ,:dn_ian_fin
              ,:dn_ddate_fin
              ,:dn_type_token1
              ,:dn_type_token2;
        select imois
              ,ian
              ,ddate
              ,imois_fin
              ,ian_fin
              ,ddate_fin
              ,type_token1
              ,type_token2
          from proc_date_writen(:date_d_w)
          into :dd_imois
              ,:dd_ian
              ,:dd_ddate
              ,:dd_imois_fin
              ,:dd_ian_fin
              ,:dd_ddate_fin
              ,:dd_type_token1
              ,:dd_type_token2;
        date_n=case
                  when dn_type_token1=19
                    then coalesce(dn_ddate-31
                                 ,cast(dn_imois||'/'||1||'/'||dn_ian as date)-183
                                 ,cast('1'||'/'||'1'||'/'||dn_ian as date)-1000)
                  when dn_type_token1 in(20,21)
                    then coalesce(dn_ddate-31
                                 ,cast(dn_imois||'/'||1||'/'||dn_ian as date)-183
                                 ,cast('1'||'/'||'1'||'/'||dn_ian as date)-4000)
                  when dn_type_token1 in(13,16,17) and dn_type_token2 in(14,15,18)
                    then coalesce(dn_ddate
                                 ,cast(dn_imois||'/'||'1'||'/'||dn_ian as date)
                                 ,cast('1'||'/'||'1'||'/'||dn_ian as date))
                  when dn_type_token1 in(13,16,17)
                    then coalesce(dn_ddate
                                 ,cast(dn_imois||'/'||'1'||'/'||dn_ian as date)
                                 ,cast('1'||'/'||'1'||'/'||dn_ian as date))
                  when dn_type_token1 in(14,15,18)
                    then coalesce(dn_ddate-10000
                                 ,cast(dn_imois||'/'||1||'/'||dn_ian as date)-10000
                                 ,cast('1'||'/'||'1'||'/'||dn_ian as date)-10000)
                  else coalesce(dn_ddate
                                 ,cast(dn_imois||'/'||'1'||'/'||dn_ian as date)
                                 ,cast('1'||'/'||'1'||'/'||dn_ian as date))
               end;
        date_n_fin=case
                  when dn_type_token1=19
                    then coalesce(dn_ddate+31
                                 ,cast(dn_imois||'/'||'1'||'/'||dn_ian as date)+215
                                 ,cast('1'||'/'||'1'||'/'||dn_ian as date)+1400)
                  when dn_type_token1 in(20,21)
                    then coalesce(dn_ddate+31
                                 ,cast(dn_imois||'/'||'1'||'/'||dn_ian as date)+215
                                 ,cast('1'||'/'||'1'||'/'||dn_ian as date)+4400)
                  when dn_type_token1 in(13,16,17) and dn_type_token2 in(14,15,18)
                    then coalesce(dn_ddate_fin
                                 ,cast(dn_imois_fin||'/'||'1'||'/'||dn_ian_fin as date)+31
                                 ,cast('1'||'/'||'1'||'/'||dn_ian_fin as date)+366)
                  when dn_type_token1 in(13,16,17)
                    then coalesce(dn_ddate+10000
                                 ,cast(dn_imois||'/'||'1'||'/'||dn_ian as date)+10000
                                 ,cast('1'||'/'||'1'||'/'||dn_ian as date)+10000)
                  when dn_type_token1 in(14,15,18)
                    then coalesce(dn_ddate
                                 ,cast(dn_imois||'/'||'1'||'/'||dn_ian as date)+31
                                 ,cast('1'||'/'||1||'/'||dn_ian as date)+366)
                  else coalesce(dn_ddate
                                 ,cast(dn_imois||'/'||'1'||'/'||dn_ian as date)+31
                                 ,cast('1'||'/'||'1'||'/'||dn_ian as date)+366)
                end;
        date_d=case
                  when dd_type_token1=19
                    then coalesce(dd_ddate-31
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)-183
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date)-1000)
                  when dd_type_token1 in(20,21)
                    then coalesce(dd_ddate-31
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)-183
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date)-4000)
                  when dd_type_token1 in(13,16,17) and dd_type_token2 in(14,15,18)
                    then coalesce(dd_ddate
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date))
                  when dd_type_token1 in(13,16,17)
                    then coalesce(dd_ddate
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date))
                  when dd_type_token1 in(14,15,18)
                    then coalesce(dd_ddate-10000
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)-10000
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date)-10000)
                  else coalesce(dd_ddate
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date))
                end;
        date_d_fin=case
                  when dd_type_token1=19
                    then coalesce(dd_ddate+31
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)+215
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date)+1400)
                  when dd_type_token1 in(20,21)
                    then coalesce(dd_ddate+31
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)+215
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date)+4400)
                  when dd_type_token1 in(13,16,17) and dd_type_token2 in(14,15,18)
                    then coalesce(dd_ddate_fin
                                 ,cast(dd_imois_fin||'/'||'1'||'/'||dd_ian_fin as date)+31
                                 ,cast('1'||'/'||'1'||'/'||dd_ian_fin as date)+366)
                  when dd_type_token1 in(13,16,17)
                    then coalesce(dd_ddate+10000
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)+10030
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date)+10365)
                  when dd_type_token1 in(14,15,18)
                    then coalesce(dd_ddate
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)+31
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date)+366)
                  else coalesce(dd_ddate
                                 ,cast(dd_imois||'/'||'1'||'/'||dd_ian as date)+31
                                 ,cast('1'||'/'||'1'||'/'||dd_ian as date)+366)
                end;
        if (date_n_fin>date_d_fin and date_n_fin is not null)  then
          date_n_fin=date_d_fin;
        if (date_n>date_d and date_d is not null)  then
          date_d=date_n;
        begin
          insert into tq_rech_doublons (
                                CLE_FICHE
                               ,DATE_NAISSANCE
                               ,DATE_NAISSANCE_FIN
                               ,VILLE_NAISSANCE
                               ,DATE_DECES
                               ,DATE_DECES_FIN
                               ,VILLE_DECES
                               )
          values (
                :i_cle_fiche
               ,:date_n
               ,:date_n_fin
               ,:ville_n
               ,:date_d
               ,:date_d_fin
               ,:ville_d
                );
          when any do
          begin
            cle_fiche=i_cle_fiche;
            nom=s_nom;
            prenom=s_prenom;
            date_naiss='Erreur, naissance ou décès en double';
            delete from tq_rech_doublons;
            suspend;
            exit;
          end
        end
      end
  if (prenom_variable in (1,3)) then
  begin
    delete from tq_prenoms;
    insert into tq_prenoms (
                            combien
                           ,dossier
                           ,prenom
                           )
                  select
                         p.cle_fiche
                        ,:i_dossier
                        ,(select s_out from f_maj_sans_accent(p.prenom))
                  from proc_liste_prenom(:I_DOSSIER) p;
  end
  if (CLE_IND>0) then --doublons de cle_ind
    if (prenom_variable in (1,3)) then
      for select distinct
                atq.cle_fiche
               ,btq.cle_fiche
        from tq_rech_doublons atq,
             tq_rech_doublons btq
             inner join individu a on a.cle_fiche=atq.cle_fiche
             inner join individu b on b.cle_fiche=btq.cle_fiche
        where a.sexe=b.sexe
          and (not exists(select * from tq_prenoms where combien=atq.cle_fiche
                          and prenom not in (select prenom from tq_prenoms where combien=btq.cle_fiche))
              or not exists(select * from tq_prenoms where combien=btq.cle_fiche
                          and prenom not in (select prenom from tq_prenoms where combien=atq.cle_fiche)))
          and atq.cle_fiche <> btq.cle_fiche
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
             INTO :CLE_FICHE,
                  :i_cle_fiche
      DO
        insert into tq_id (id1,id2) values(:cle_fiche,:i_cle_fiche);
    else  --(CLE_IND>0) et (prenom_variable=0)
      for select distinct
                atq.cle_fiche
               ,btq.cle_fiche
        from tq_rech_doublons atq,
             tq_rech_doublons btq
             inner join individu a on a.cle_fiche=atq.cle_fiche
             inner join individu b on b.cle_fiche=btq.cle_fiche
        where a.sexe=b.sexe
          and a.prenom = b.prenom
          and atq.cle_fiche <> btq.cle_fiche
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
             INTO :CLE_FICHE,
                  :i_cle_fiche
      DO
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
        where a.sexe=b.sexe
          and a.nom = b.nom
          and (not exists(select * from tq_prenoms where combien=atq.cle_fiche
                          and prenom not in (select prenom from tq_prenoms where combien=btq.cle_fiche))
              or not exists(select * from tq_prenoms where combien=btq.cle_fiche
                          and prenom not in (select prenom from tq_prenoms where combien=atq.cle_fiche)))
          and atq.cle_fiche <> btq.cle_fiche
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
             INTO :CLE_FICHE,
                  :i_cle_fiche
      DO
        insert into tq_id (id1,id2) values(:cle_fiche,:i_cle_fiche);
    else --(CLE_IND=0) et (prenom_variable=0)
      for select distinct
                atq.cle_fiche
               ,btq.cle_fiche
        from tq_rech_doublons atq,
             tq_rech_doublons btq
             inner join individu a on a.cle_fiche=atq.cle_fiche
             inner join individu b on b.cle_fiche=btq.cle_fiche
        where a.sexe=b.sexe
          and a.nom = b.nom
          and a.prenom = b.prenom
          and atq.cle_fiche <> btq.cle_fiche
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
             INTO :CLE_FICHE,
                  :i_cle_fiche
      DO
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
  if (prenom_variable in (1,3)) then
  begin
    delete from tq_id t
      where (select oui from proc_test_parente(t.id1,t.id2,5))=1;
    delete from tq_consang;
  end
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
             INTO
                  :CLE_FICHE
                 ,:NOM
                 ,:PRENOM
                 ,:DATE_NAISS
                 ,:LIEU_NAISS
                 ,:DATE_DECES
                 ,:LIEU_DECES
                 ,:CLE_FICHE2
                 ,:NOM2
                 ,:PRENOM2
                 ,:DATE_NAISS2
                 ,:LIEU_NAISS2
                 ,:DATE_DECES2
                 ,:LIEU_DECES2
                 ,:i
      do
      begin
        PRENOM=substring(cast(i as varchar(6))||'-'||PRENOM from 1 for 60);
        suspend;
        CLE_FICHE=CLE_FICHE2;
        NOM=NOM2;
        PRENOM=substring(cast(i as varchar(6))||'-'||PRENOM2 from 1 for 60);
        DATE_NAISS=DATE_NAISS2;
        LIEU_NAISS=LIEU_NAISS2;
        DATE_DECES=DATE_DECES2;
        LIEU_DECES=LIEU_DECES2;
        suspend;
      end
  delete from tq_rech_doublons;
  delete from tq_id;
END^
commit^

alter PROCEDURE PROC_TROUVE_ENFANTS (
    A_CLE_PERE INTEGER,
    A_CLE_MERE INTEGER,
    I_DOSSIER INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SEXE INTEGER,
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    KLE_DOSSIER INTEGER,
    SOSA DOUBLE PRECISION,
    PHOTO BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    VILLE_NAISS VARCHAR(166),
    VILLE_DECES VARCHAR(166),
    ANNEE INTEGER,
    ANNEE_DECES INTEGER,
    AGE_DECES INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER)
AS
BEGIN
    SUSPEND;
END^
commit^

alter PROCEDURE PROC_TROUVE_FRERES_SOEURS (
    I_CLEF INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    F_1 INTEGER,
    DECEDE INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    ANNEE_NAISSANCE INTEGER,
    ANNEE_DECES INTEGER)
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
commit^

alter PROCEDURE PROC_TROUVE_GRANDS_PARENT (
    I_CLEF INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    SOSA INTEGER,
    DECEDE INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    ANNEE_NAISSANCE INTEGER,
    ANNEE_DECES INTEGER)
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
commit^

alter PROCEDURE PROC_TROUVE_ONCLES_TANTES (
    I_CLEF INTEGER,
    I_DOSSIER INTEGER,
    I_MAX INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SEXE INTEGER,
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    SOSA DOUBLE PRECISION,
    DECEDE INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    ANNEE_NAISSANCE INTEGER,
    ANNEE_DECES INTEGER)
AS
DECLARE VARIABLE A_CLEF_PERE INTEGER;
DECLARE VARIABLE A_CLEF_MERE INTEGER;
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE S INTEGER;
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée le 23/07/2007 par André optimisation, I_MAX et I_DOSSIER plus utilisés
   ---------------------------------------------------------------------------*/
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
  order by p.sosa,i.annee_naissance,e.ev_ind_date_mois,e.ev_ind_date
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
commit^

alter PROCEDURE PROC_TROUVE_UNIONS (
    I_DOSSIER INTEGER,
    I_CLEF INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISSANCE VARCHAR(100),
    ANNEE_NAISSANCE INTEGER,
    DATE_DECES VARCHAR(100),
    ANNEE_DECES INTEGER,
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    TYPE_UNION INTEGER,
    UNION_CLEF INTEGER,
    ANNEE_MARIAGE INTEGER,
    DECEDE INTEGER)
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:49:06
   Modifiée le : 10/01/2007 par André pour ordre chronologique des conjoints
   ajout du mois dans l'ordre de tri, requête indépendante du sexe ,ajout decede
   par :
   Description :
   Usage       :
   ---------------------------------------------------------------------------*/
      FOR SELECT
            i.CLE_FICHE,
            i.NOM,
            i.PRENOM,
            i.DATE_NAISSANCE,
            i.ANNEE_NAISSANCE,
            i.DATE_DECES,
            i.ANNEE_DECES,
            i.SEXE,
            i.CLE_PERE,
            i.CLE_MERE,
            i.NUM_SOSA ,
            u.union_type,
            u.union_clef ,
            MIN(m.EV_FAM_DATE_YEAR),
            i.decede
        FROM individu i,
            t_union u
            LEFT join evenements_fam m
               on (m.ev_fam_kle_famille = u.union_clef)
        Where u.union_mari=:I_CLEF
          and i.cle_fiche=u.union_femme
        GROUP BY
            i.CLE_FICHE,
            i.NOM,
            i.PRENOM,
            i.DATE_NAISSANCE,
            i.ANNEE_NAISSANCE,
            i.DATE_DECES,
            i.ANNEE_DECES,
            i.SEXE,
            i.CLE_PERE,
            i.CLE_MERE,
            i.NUM_SOSA ,
            u.union_type,
            u.union_clef,
            i.decede
        ORDER BY 14
              ,MIN(m.EV_FAM_DATE_YEAR+m.EV_FAM_DATE_MOIS/100)
              ,MIN(m.EV_FAM_DATE)
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
      if (:CLE_FICHE>0) then exit;
      FOR SELECT
            i.CLE_FICHE,
            i.NOM,
            i.PRENOM,
            i.DATE_NAISSANCE,
            i.ANNEE_NAISSANCE,
            i.DATE_DECES,
            i.ANNEE_DECES,
            i.SEXE,
            i.CLE_PERE,
            i.CLE_MERE,
            i.NUM_SOSA ,
            u.union_type,
            u.union_clef ,
            MIN(m.EV_FAM_DATE_YEAR),
            i.decede
        FROM individu i,
            t_union u
            LEFT join evenements_fam m
               on (m.ev_fam_kle_famille = u.union_clef)
        Where u.union_femme=:I_CLEF
          and i.cle_fiche=u.union_mari
        GROUP BY
            i.CLE_FICHE,
            i.NOM,
            i.PRENOM,
            i.DATE_NAISSANCE,
            i.ANNEE_NAISSANCE,
            i.DATE_DECES,
            i.ANNEE_DECES,
            i.SEXE,
            i.CLE_PERE,
            i.CLE_MERE,
            i.NUM_SOSA ,
            u.union_type,
            u.union_clef,
            i.decede
        ORDER BY 14
              ,MIN(m.EV_FAM_DATE_YEAR+m.EV_FAM_DATE_MOIS/100)
              ,MIN(m.EV_FAM_DATE)
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
commit^

alter PROCEDURE PROC_ETAT_COUSINAGE (
    I_CLEF INTEGER,
    I_DOSSIER INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    NOM_PERE VARCHAR(40),
    PRENOM_PERE VARCHAR(60),
    NOM_MERE VARCHAR(40),
    PRENOM_MERE VARCHAR(60))
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée le :09/01/2007 suppression proc_cousins_cousines, optimisation
   par : André
   Description : Cette procedure permet de récuperer tous les cousins d'un individu
   Usage       :
   ---------------------------------------------------------------------------*/
   FOR SELECT indi.CLE_FICHE,
              indi.NOM,
              indi.PRENOM,
              indi.DATE_NAISSANCE,
              indi.DATE_DECES,
              indi.SEXE,
              indi.CLE_PERE,
              indi.CLE_MERE,
              (select nom from individu where cle_fiche=indi.cle_pere),
              (select prenom from individu where cle_fiche=indi.cle_pere),
              (select nom from individu where cle_fiche=indi.cle_mere),
              (select prenom from individu where cle_fiche=indi.cle_mere)
           FROM proc_trouve_oncles_tantes (:I_CLEF,0,0) p,
                INDIVIDU indi
           WHERE (p.sexe=1 and indi.cle_pere=p.cle_fiche)
              or (p.sexe=2 and indi.cle_mere=p.cle_fiche)
            ORDER BY p.sosa,indi.annee_naissance
         INTO :CLE_FICHE,
              :NOM,
              :PRENOM,
              :DATE_NAISSANCE,
              :DATE_DECES,
              :SEXE,
              :CLE_PERE,
              :CLE_MERE,
              :NOM_PERE,
              :PRENOM_PERE,
              :NOM_MERE,
              :PRENOM_MERE
   do
   suspend;
end^
commit^

alter PROCEDURE PROC_INFOS_INDI (
    IDOSSIER INTEGER,
    ICLEF INTEGER)
RETURNS (
    COMBIEN INTEGER,
    TITRE VARCHAR(5))
AS
DECLARE VARIABLE ISEXE INTEGER;
DECLARE VARIABLE IHOMME INTEGER;
DECLARE VARIABLE IFEMME INTEGER;
BEGIN
   IHOMME = 0;
   IFEMME = 0;
   SELECT SEXE
     FROM INDIVIDU
     WHERE CLE_FICHE = :ICLEF
     INTO : ISEXE;
   if (ISEXE = 1) then IHOMME = ICLEF;
   if (ISEXE = 2) then IFEMME = ICLEF;
   FOR
    select count(*),'UNION' from proc_trouve_unions(0,:ICLEF)
    UNION
    select Count(distinct m.MULTI_CLEF),'MEDIA'
       FROM MULTIMEDIA m,
            MEDIA_POINTEURS mp
       WHERE mp.MP_MEDIA=m.MULTI_CLEF AND
             mp.MP_CLE_INDIVIDU=:ICLEF
    UNION
    select Count(*),'ADRES'
      from ADRESSES_IND
      WHERE ADR_KLE_IND = :ICLEF
    UNION
    SELECT COUNT(COMMENT),'COMME'
      FROM INDIVIDU
      WHERE CLE_FICHE = :ICLEF AND
      COMMENT IS NOT NULL
    UNION
    SELECT COUNT(0), 'EVENT'
      FROM evenements_ind
      where ev_ind_kle_fiche=:iclef
    UNION
    SELECT COUNT(*), 'ENFAN'
      FROM INDIVIDU
      WHERE (:isexe=1 and CLE_PERE=:iclef)
         OR (:isexe=2 and CLE_MERE=:iclef)
    UNION
    SELECT COUNT(*), 'FRERE'
      FROM PROC_TROUVE_FRERES_SOEURS(:ICLEF)
    UNION
    SELECT COUNT(*), 'ONCLE'
      FROM PROC_TROUVE_ONCLES_TANTES (:ICLEF,0,0)
    UNION
    SELECT COUNT(*), 'COUSI'
           FROM proc_trouve_oncles_tantes (:ICLEF,0,0) p,
                INDIVIDU i
           WHERE (p.sexe=1 and i.cle_pere=p.cle_fiche)
              or (p.sexe=2 and i.cle_mere=p.cle_fiche)
    UNION
    SELECT COUNT(*), 'CONJO'
      from proc_trouve_unions(0,:ICLEF)
    UNION
    SELECT COUNT(*), 'PTENF'
           FROM (SELECT CLE_FICHE,SEXE
                 FROM INDIVIDU
                 WHERE (:isexe=1 and CLE_PERE=:iclef)
                    OR (:isexe=2 and CLE_MERE=:iclef)) as p,
                individu i
           where (p.sexe=1 and i.cle_pere=p.cle_fiche)
              or (p.sexe=2 and i.cle_mere=p.cle_fiche)
    UNION
    SELECT COUNT(*), 'NEVEU'
    FROM proc_trouve_freres_soeurs (:ICLEF) p,
         INDIVIDU i
    WHERE (p.sexe=1 and i.cle_pere=p.cle_fiche)
       or (p.sexe=2 and i.cle_mere=p.cle_fiche)
    INTO
      :COMBIEN,
      :TITRE
  DO
    SUSPEND;
END^
commit^

alter PROCEDURE PROC_VIDE_BASE (
    I_CLEF INTEGER)
AS
begin
  exit;
end^
commit^

alter PROCEDURE PROC_VIDE_DOSSIER (
    I_CLEF INTEGER)
AS
begin exit; end^
commit^

alter PROCEDURE PROC_NAVIGATION (
    I_CLEF INTEGER,
    I_DOSSIER INTEGER,
    I_MAX INTEGER)
RETURNS (
    NIVEAU INTEGER,
    CLE_FICHE INTEGER,
    NOM VARCHAR(60),
    PRENOM VARCHAR(100),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    SOSA DOUBLE PRECISION,
    DECEDE INTEGER,
    VILLE_NAISSANCE VARCHAR(50),
    VILLE_DECES VARCHAR(50),
    AGE_EN_JOURS INTEGER,
    PROFESSION VARCHAR(90),
    DATE_UNION VARCHAR(90),
    VILLE_UNION VARCHAR(50),
    PHOTO BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    ENFANTS INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    PERIODE_VIE VARCHAR(15),
    AGE_UNION_JOURS INTEGER,
    AGE_UNION_IND_JOURS INTEGER)
AS
begin suspend; end^
commit^

alter PROCEDURE PROC_AGE_INDIVIDU (
    I_CLEF INTEGER)
RETURNS (
    DATE_DECES INTEGER,
    DATE_NAISSANCE INTEGER,
    AGE INTEGER)
AS
BEGIN
  SUSPEND;
END^
commit^

alter PROCEDURE PROC_AGE_EVENT (
    I_CLEF_EVE INTEGER,
    TYPE_EVE VARCHAR(1),
    I_CLEF_INDI INTEGER)
RETURNS (
    AGE INTEGER)
AS
begin
  suspend;
end^
commit^

alter PROCEDURE PROC_GET_CLEF_UNIQUE (
    A_TABLE VARCHAR(30))
RETURNS (
    CLE_UNIQUE INTEGER)
AS
begin
SUSPEND;
end^
commit^

alter PROCEDURE PROC_INCOHERENCES (
    I_KLE_DOSSIER INTEGER,
    I_MODE INTEGER)
RETURNS (
    O_TABLE VARCHAR(30),
    O_CLE_TABLE INTEGER,
    O_CLE_FICHE INTEGER,
    O_LIBELLE VARCHAR(160))
AS
DECLARE VARIABLE CONJOINT INTEGER;
DECLARE VARIABLE I_COUNT INTEGER;
DECLARE VARIABLE PERE INTEGER;
DECLARE VARIABLE MERE INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Laurent Robbe. Tout droits réservés.
   Créé le : 31/05/2003
   à : 11:54:11
   Modifiée le :12/01/2007 par André: ajout test sur évènement individuel dans T_ASSOCIATIONS
   et EVENEMENT_FAM sans UNION, correction T_UNION avec un conjoint=0 ou null
   ajout I_MODE=2 pour exécution sans messages.
   Description : Renvoie les individus de nom passé en paramètre
   Usage       : I_MODE = 0 : Consultation
                 I_MODE = 1 : Mise à jour
                 I_MODE=2 : Mise à jour sans messages
   ---------------------------------------------------------------------------*/
  O_LIBELLE='Adresse pointant sur un individu inexistant';
  O_TABLE='adresses_ind';
  for select adr_clef, adr_kle_ind from adresses_ind a
  where  a.adr_kle_dossier = :i_kle_dossier
  and    not exists (
    select * from individu b
    where b.kle_dossier = :i_kle_dossier
    and   b.cle_fiche = a.adr_kle_ind
  )
  into :o_cle_table, :O_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from adresses_ind z
      where z.adr_kle_dossier=:i_kle_dossier
      and   z.adr_clef=:o_cle_table;
    end
  end

  O_LIBELLE='Evénement individu pointant sur un individu inexistant';
  O_TABLE='evenements_ind';
  for select ev_ind_clef, ev_ind_kle_fiche from evenements_ind a
  where  ev_ind_kle_dossier = :i_kle_dossier
  and    not exists (
    select * from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.ev_ind_kle_fiche
  )
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from evenements_ind z
      where z.ev_ind_kle_dossier=:i_kle_dossier
      and   z.ev_ind_clef=:o_cle_table;
    end
  end

  O_LIBELLE='union pointant sur un mari inexistant';
  O_TABLE='t_union';
  for select a.union_clef, a.union_mari, a.union_femme from t_union a
  where  a.kle_dossier = :i_kle_dossier
  and    a.union_mari IS NOT NULL
  and    not exists (
    select * from individu b
    where  b.kle_dossier = :i_kle_dossier
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
      update T_UNION set UNION_MARI = NULL
               where UNION_CLEF = :o_cle_table;
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
          SELECT COUNT(*) FROM INDIVIDU
                WHERE CLE_MERE = :conjoint AND (CLE_PERE IS NULL OR CLE_PERE = 0)
                INTO :i_count;
          if (i_count > 0) then
          insert into t_union (union_femme,kle_dossier,union_type)
          values (:conjoint, :i_kle_dossier, 0);
        end
    end
  end

  O_LIBELLE='union pointant sur une épouse inexistante';
  O_TABLE='t_union';
  for select a.union_clef, a.union_mari, a.union_femme from t_union a
    where  a.kle_dossier = :i_kle_dossier
  and    a.union_femme IS NOT NULL
  and    not exists (
    select * from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.union_femme
  )
  into :o_cle_table, :conjoint, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then
      BEGIN
      if (conjoint is null or conjoint=0) then
      begin
        delete from t_union c
        where  c.union_clef = :o_cle_table
        and    c.kle_dossier = :i_kle_dossier;
      end
      update T_UNION set UNION_FEMME = NULL
               where UNION_CLEF = :o_cle_table;
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
          SELECT COUNT(*) FROM INDIVIDU
                WHERE CLE_PERE = :conjoint AND (CLE_MERE IS NULL OR CLE_MERE = 0)
                INTO :i_count;
          if (i_count > 0) then
          insert into t_union (union_mari,kle_dossier,union_type)
          values (:conjoint,:i_kle_dossier, 0);
        end
      END
  end

  O_LIBELLE='Media Pointeurs pointant sur un individu inexistant';
  O_TABLE='media_pointeurs';
  for select mp_clef, mp_cle_individu from media_pointeurs a
  where  mp_kle_dossier = :i_kle_dossier
  and    not exists (
    select * from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.mp_cle_individu
  )
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from media_pointeurs z
      where z.mp_kle_dossier=:i_kle_dossier
      and   z.mp_clef=:o_cle_table;
    end
  end

  O_LIBELLE='Association pointant sur un individu inexistant';
  O_TABLE='t_associations';
  for select assoc_clef, assoc_kle_ind from t_associations a
  where  assoc_kle_dossier = :i_kle_dossier
  and    assoc_table = 'I'
  and   not exists (
    select * from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.assoc_kle_ind
  )
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from t_associations z
      where z.assoc_kle_dossier=:i_kle_dossier
      and   z.assoc_clef=:o_cle_table;
    end
  end

  O_LIBELLE='Associé d une association pointant sur un individu inexistant';
  O_TABLE='t_associations';
  for select assoc_clef, assoc_kle_associe from t_associations a
  where  assoc_kle_dossier = :i_kle_dossier
  and    not exists (
    select * from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.assoc_kle_associe
  )
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from t_associations z
      where z.assoc_kle_dossier=:i_kle_dossier
      and   z.assoc_clef=:o_cle_table;
    end
  end

  O_LIBELLE='Evénement familial pointant sur une union inexistante';
  O_TABLE='EVENEMENTS_FAM';
  for select a.EV_FAM_CLEF, a.EV_FAM_KLE_FAMILLE from EVENEMENTS_FAM a
  where  a.EV_FAM_KLE_DOSSIER = :i_kle_dossier
  and    not exists (
    select * from T_UNION b
    where  b.KLE_DOSSIER = :i_kle_dossier
    and    b.UNION_CLEF = a.EV_FAM_KLE_FAMILLE
  )
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from EVENEMENTS_FAM z
      where z.EV_FAM_KLE_DOSSIER=:i_kle_dossier
      and   z.EV_FAM_CLEF=:o_cle_table;
    end
  end

  O_LIBELLE='Association pointant sur un événement familial inexistant';
  O_TABLE='t_associations';
  for select assoc_clef, assoc_kle_ind from t_associations a
  where  assoc_kle_dossier = :i_kle_dossier
  and    assoc_table = 'U'
  and    not exists (
    select * from evenements_fam b
    where  b.ev_fam_kle_dossier = :i_kle_dossier
    and    b.ev_fam_clef = a.assoc_kle_ind
  )
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from t_associations z
      where z.assoc_kle_dossier=:i_kle_dossier
      and   z.assoc_clef=:o_cle_table;
    end
  end

  O_LIBELLE='Association pointant sur un événement individuel inexistant';
  O_TABLE='t_associations';
  for select assoc_clef, assoc_evenement from t_associations a
  where  assoc_kle_dossier = :i_kle_dossier
  and    assoc_table = 'I'
  and    not exists (
    select * from evenements_ind b
    where  b.ev_ind_kle_dossier = :i_kle_dossier
    and    b.ev_ind_clef = a.assoc_evenement
  )
  into :o_cle_table, :o_cle_fiche
  do begin
    if (i_mode<2) then suspend;
    if (i_mode>0) then begin
      delete from t_associations z
      where z.assoc_kle_dossier=:i_kle_dossier
      and   z.assoc_clef=:o_cle_table;
    end
  end

  O_LIBELLE='Père présent dans la fiche individu mais inexistant';
  O_TABLE='individu';
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

  O_LIBELLE='Mère présente dans la fiche individu mais inexistante';
  O_TABLE='individu';
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

  O_LIBELLE='Enfant dont les parents n ont pas d union dans la table T_UNION';
  O_TABLE='individu';
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
end^
commit^

alter PROCEDURE PROC_MAJ_LIEUX_FAVORIS (
    I_DOSSIER INTEGER)
AS
DECLARE VARIABLE VILLE VARCHAR(50);
DECLARE VARIABLE CP VARCHAR(10);
DECLARE VARIABLE DEPARTEMENT VARCHAR(30);
DECLARE VARIABLE REGION VARCHAR(50);
DECLARE VARIABLE LATITUDE DECIMAL(15,8);
DECLARE VARIABLE LONGITUDE NUMERIC(15,8);
DECLARE VARIABLE DBKEY CHAR(8);
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 08/06/2002
   à : 19:23:10
   Modifiée le : 20/05/2007 par André: optimisation
   Description : Procedure mettant a jour les tables des evenements et adresses,
   en remettant les villes, départements et régions comme dans la table de
   référence des villes, ainsi que latitude et longitude si la subdivision est vide
   ---------------------------------------------------------------------------*/
for select e.RDB$DB_KEY
          ,v.cp_ville
          ,v.cp_cp
          ,v.cp_latitude
          ,v.cp_longitude
          ,d.rdp_libelle
          ,r.rrg_libelle
    from evenements_ind e
    inner join ref_cp_ville v
            on v.cp_insee=e.ev_ind_insee
    inner join ref_pays p
            on p.rpa_code=v.cp_pays
           and p.rpa_libelle=upper(e.ev_ind_pays)
    left join ref_departements d
           on d.rdp_code=v.cp_dept
    left join ref_region r
           on r.rrg_code=v.cp_region
    where ev_ind_kle_dossier=:i_dossier
    into :dbkey
        ,:ville
        ,:cp
        ,:latitude
        ,:longitude
        ,:departement
        ,:region
  do
  begin
    update evenements_ind e
      set e.ev_ind_ville=:ville
         ,e.ev_ind_dept=:departement
         ,e.ev_ind_region=:region
         ,e.ev_ind_pays=upper(e.ev_ind_pays)
      WHERE e.RDB$DB_KEY=:dbkey;
    update evenements_ind e
      set e.ev_ind_latitude=:latitude
         ,e.ev_ind_longitude=:longitude
      WHERE e.RDB$DB_KEY=:dbkey
        and e.ev_ind_cp=:cp
        and char_length(e.ev_ind_subd)=0;
  end
for select e.RDB$DB_KEY
          ,v.cp_ville
          ,v.cp_cp
          ,v.cp_latitude
          ,v.cp_longitude
          ,d.rdp_libelle
          ,r.rrg_libelle
    from evenements_fam e
    inner join ref_cp_ville v
            on v.cp_insee=e.ev_fam_insee
    inner join ref_pays p
            on p.rpa_code=v.cp_pays
           and p.rpa_libelle=upper(e.ev_fam_pays)
    left join ref_departements d
           on d.rdp_code=v.cp_dept
    left join ref_region r
           on r.rrg_code=v.cp_region
    where ev_fam_kle_dossier=:i_dossier
    into :dbkey
        ,:ville
        ,:cp
        ,:latitude
        ,:longitude
        ,:departement
        ,:region
  do
  begin
    update evenements_fam e
      set e.ev_fam_ville=:ville
         ,e.ev_fam_dept=:departement
         ,e.ev_fam_region=:region
         ,e.ev_fam_pays=upper(e.ev_fam_pays)
      WHERE e.RDB$DB_KEY=:dbkey;
    update evenements_fam e
      set e.ev_fam_latitude=:latitude
         ,e.ev_fam_longitude=:longitude
      WHERE e.RDB$DB_KEY=:dbkey
        and e.ev_fam_cp=:cp
        and char_length(e.ev_fam_subd)=0;
  end
for select e.RDB$DB_KEY
          ,v.cp_ville
          ,v.cp_cp
          ,v.cp_latitude
          ,v.cp_longitude
          ,d.rdp_libelle
          ,r.rrg_libelle
    from adresses_ind e
    inner join ref_cp_ville v
            on v.cp_insee=e.adr_insee
    inner join ref_pays p
            on p.rpa_code=v.cp_pays
           and p.rpa_libelle=upper(e.adr_pays)
    left join ref_departements d
           on d.rdp_code=v.cp_dept
    left join ref_region r
           on r.rrg_code=v.cp_region
    where adr_kle_dossier=:i_dossier
    into :dbkey
        ,:ville
        ,:cp
        ,:latitude
        ,:longitude
        ,:departement
        ,:region
  do
  begin
    update adresses_ind e
      set e.adr_ville=:ville
         ,e.adr_dept=:departement
         ,e.adr_region=:region
         ,e.adr_pays=upper(e.adr_pays)
      WHERE e.RDB$DB_KEY=:dbkey;
    update adresses_ind e
      set e.adr_latitude=:latitude
         ,e.adr_longitude=:longitude
      WHERE e.RDB$DB_KEY=:dbkey
        and e.adr_cp=:cp
        and char_length(e.adr_subd)=0;
  end
end^
commit^

alter PROCEDURE PROC_TROUVE_DOSSIER (
    I_CLE INTEGER,
    I_NOM VARCHAR(30),
    I_INFOS VARCHAR(254))
RETURNS (
    CLE_DOSSIER INTEGER,
    NOM_DOSSIER VARCHAR(30),
    "LAST" INTEGER,
    VERROU INTEGER)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:33:02
   Modifiée le : 21/05/2007 par André si I_CLE=0, retourne le dernier dossier
   ouvert. 02/07/07 ajout champ VERROU en sortie
   Description : Retourne un dossier valable et -1 s'il est vide
   Usage       :
   ---------------------------------------------------------------------------*/
   if (i_cle>0) then  --ouverture d'un dossier
     SELECT  CLE_DOSSIER,
             NOM_DOSSIER,
             coalesce(DS_LAST,-1)
        FROM dossier
        WHERE CLE_DOSSIER=:I_CLE
        INTO :CLE_DOSSIER,
             :NOM_DOSSIER,
             :LAST;
   else  --ouverture de la base
     SELECT  first(1) CLE_DOSSIER,
             NOM_DOSSIER,
             coalesce(DS_LAST,-1)
        FROM dossier
        WHERE ds_fermeture=(select max(ds_fermeture) from dossier)
        INTO :CLE_DOSSIER,
             :NOM_DOSSIER,
             :LAST;
   if (CLE_DOSSIER IS NULL) then
   begin
     SELECT  CLE_DOSSIER,
             NOM_DOSSIER,
             coalesce(DS_LAST,-1)
         FROM dossier
         WHERE CLE_DOSSIER=(SELECT MAX(CLE_DOSSIER) FROM DOSSIER)
         INTO :CLE_DOSSIER,
              :NOM_DOSSIER,
              :LAST;
     if (CLE_DOSSIER IS NULL) then
     begin
       if (char_length(trim(I_NOM))=0) then
         I_NOM='Mon premier dossier';
       if (char_length(trim(I_INFOS))=0) then
         I_INFOS='Ce dossier, est le dossier créé par défaut, '
               ||'vous pouvez changer son nom et ses informations';
       CLE_DOSSIER=gen_id(GEN_DOSSIER,-gen_id(GEN_DOSSIER,0)+1); --=1
       INSERT INTO DOSSIER (CLE_DOSSIER,NOM_DOSSIER,DS_VERROU,DS_INFOS)
                    VALUES (:CLE_DOSSIER,:I_NOM,0,:I_INFOS);
       NOM_DOSSIER=:I_NOM;
       LAST=-1;
     end
   end
   if (CLE_DOSSIER IS NOT NULL) then
   begin
      select DS_VERROU
        from dossier
        where CLE_DOSSIER=:CLE_DOSSIER
        into :verrou;
      UPDATE DOSSIER
        SET DS_OUVERTURE='NOW',DS_VERROU=1
        WHERE CLE_DOSSIER=:CLE_DOSSIER;
   end
   update gestion_dll set dll_indi=:last,dll_dossier=:cle_dossier;
   if (row_count=0) then
     Insert into GESTION_DLL (DLL_INDI,DLL_DOSSIER)
                      values (:last,:CLE_DOSSIER);
   suspend;
end^
commit^

alter PROCEDURE PROC_LISTE_UNIONS (
    I_DOSSIER INTEGER)
RETURNS (
    UNION_CLE INTEGER,
    MARI_CLE INTEGER,
    MARI_NOM VARCHAR(40),
    MARI_PRENOM VARCHAR(60),
    FEMME_CLE INTEGER,
    FEMME_NOM VARCHAR(40),
    FEMME_PRENOM VARCHAR(60),
    VILLE VARCHAR(50),
    PAYS VARCHAR(30),
    DATE_UNION DATE)
AS
begin
   suspend;
end^
commit^
SET ECHO ON^
/*Les instructions suivantes peuvent provoquer des erreurs.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
DROP PROCEDURE PROC_SELECTION_DOSSIER^
commit^
DROP PROCEDURE PROC_VIDE_TABLE_TECHNIQUE^
commit^
DROP PROCEDURE PROC_VIDE_TABLE^
commit^
DROP PROCEDURE PROC_ACTES_DEJA_TROUVES^
commit^
DROP PROCEDURE PROC_ACTES_A_TROUVER_INDIVIDUS^
commit^
DROP PROCEDURE PROC_ACTES_A_TROUVER_FAMILLES^
commit^
DROP PROCEDURE PROC_ACTES_RAZ^
commit^
DROP PROCEDURE PROC_BIBLIO_LOAD^
commit^
DROP PROCEDURE PROC_VIDE_BIBLIO^
commit^
DROP TABLE BIBLIO_POINTEURS^
commit^
DROP TABLE MULTIMEDIA_RECORD^
commit^
DROP GENERATOR MULTIMEDIA_RECORD_ID_GEN^
commit^
DROP TABLE NOTE_RECORD^
commit^
DROP GENERATOR NOTE_RECORD_ID_GEN^
commit^
DROP TABLE SOURCE_POINTEURS^
commit^
DROP GENERATOR MEDIA_POINTEURS_MP_CLEF_GEN^
commit^
DROP TABLE X_JOURNAL^
commit^
DROP GENERATOR X_JOURNAL_ID_GEN^
commit^
DROP GENERATOR GEN_USER_ID^
commit^
DROP GENERATOR GEN_REF_EVE_CODE^
commit^
DROP GENERATOR GEN_REF_ANC_CODE^
commit^
DROP TABLE DIVERS^
commit^
DROP GENERATOR DIVERS_DIV_CLEF_GEN^
commit^
DROP PROCEDURE PROC_TROUVE_VILLE_ALPHA^
commit^
DROP PROCEDURE PROC_TROUVE_VILLE_PAR_DEPT^
commit^
DROP PROCEDURE PROC_PERMUTATION_INSEE^
commit^
DROP PROCEDURE PROC_PERMUTATION_INSEE_SUITE^
commit^
DROP PROCEDURE PROC_FIXE_UNIQUE_PHOTO_IDENTITE^
commit^
DROP PROCEDURE PROC_MAJ_VILLES^
commit^

DROP PROCEDURE PROC_TROUVE_PETITS_ENFANTS^
commit^

DROP PROCEDURE PROC_TROUVE_NEVEUX_NIECES^
commit^

DROP PROCEDURE PROC_TROUVE_COUSINS_COUSINES^
commit^

DROP TABLE TQ_ONCLES^
commit^

DROP TABLE TQ_COUSINS^
commit^

DROP GENERATOR GEN_TQ_COUSINS^
commit^

DROP GENERATOR GEN_TQ_ONCLES^
commit^

DROP GENERATOR GEN_T_CONTROLE_VERSION^
commit^

DROP INDEX FAVORIS_KLE_DOSSIER^
commit^

DROP PROCEDURE PROC_DOUBLONS^
commit^
DROP EXCEPTION EX_DOUBLONS^
commit^

DROP PROCEDURE PROC_MAJ_PATRONYMES^
commit^
DROP TABLE PATRONYMES^
commit^
DROP GENERATOR GEN_PAT_CLEF^
commit^
DROP TABLE T_CONTROLE_CLEF^
commit^

CREATE PROCEDURE PROC_TROUVE_COUSINS_COUSINES (
    I_CLEF INTEGER,
    I_DOSSIER INTEGER,
    I_MAX INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SEXE INTEGER,
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    SOSA DOUBLE PRECISION)
AS
BEGIN suspend; end^
commit^

CREATE PROCEDURE PROC_SUIVANT (
    IND_ORIGINE INTEGER,
    DELTA INTEGER)
RETURNS (
    CLE_FICHE INTEGER)
AS
DECLARE VARIABLE I INTEGER;
begin suspend; end^
COMMIT WORK ^

alter PROCEDURE PROC_SUIVANT (
    IND_ORIGINE INTEGER,
    DELTA INTEGER)
RETURNS (
    CLE_FICHE INTEGER)
AS
DECLARE VARIABLE I INTEGER;
begin suspend; end^
COMMIT WORK ^

DROP INDEX IDX_PRENOMS_PRENOM_MAJ^
commit^

ALTER TABLE PRENOMS DROP PRENOM_MAJ^
commit^

CREATE PROCEDURE PROC_PREP_PRENOMS (
    I_DOSSIER INTEGER)
RETURNS (
    PRENOM VARCHAR(60),
    SEXE INTEGER)
AS
begin suspend; end^
commit^

DROP GENERATOR REF_CP_VILLE_CP_CODE_GEN^
commit^

DROP PROCEDURE PROC_MAJ_INDI_UPPER^
commit^

DROP PROCEDURE TEST^
commit^

DROP INDEX INDIVIDU_KLE_DOSSIER^
commit^

DROP INDEX INDIVIDU_IDX_TRIE_NOM^
commit^

DROP INDEX INDIVIDU_TRI_NOM^
commit^

DROP INDEX INDIVIDU_TRI_NOM_DESC^
commit^

ALTER TABLE INDIVIDU DROP INDI_TRIE_NOM^
commit^

alter table individu
add INDI_TRIE_NOM varchar(110) collate iso8859_1^
commit^

CREATE INDEX IDX_MP_POINTE_SUR ON MEDIA_POINTEURS (MP_POINTE_SUR, MP_TABLE, MP_TYPE_IMAGE)^
commit^

CREATE DESCENDING INDEX IDX_MP_CLE_INDIVIDU ON MEDIA_POINTEURS (MP_CLE_INDIVIDU, MP_CLEF)^
commit^

CREATE GENERATOR GEN_REF_HISTOIRE^
commit^

drop trigger ref_histoire_biu^
commit^

ALTER TABLE REF_HISTOIRE DROP HI_TYPE^
commit^

CREATE TABLE REF_HISTOIRE (
    HI_ID          INTEGER NOT NULL,
    HI_DOSSIER     INTEGER DEFAULT 0,
    HI_DICORIGINE  VARCHAR(8),
    HI_DATE_TEXTE  VARCHAR(50) NOT NULL,
    HI_DATE_DEBUT  DATE,
    HI_DATE_FIN    DATE,
    HI_CAT         INTEGER,
    HI_TITRE       VARCHAR(50) COLLATE FR_FR,
    HI_TEXTE       BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    HI_IMAGE       BLOB SUB_TYPE 0 SEGMENT SIZE 80
)^
commit^

ALTER TABLE REF_HISTOIRE ADD CONSTRAINT PK_REF_HISTOIRE PRIMARY KEY (HI_ID)^
commit^

CREATE INDEX IDX_REF_HISTOIRE_DEBUT ON REF_HISTOIRE (HI_DATE_DEBUT)^
commit^

CREATE INDEX IDX_REF_HISTOIRE_FIN ON REF_HISTOIRE (HI_DATE_FIN)^
commit^

CREATE DESCENDING INDEX IDX_REF_HISTOIRE_DEBUT_DESC ON REF_HISTOIRE (HI_DATE_DEBUT)^
commit^

alter table REF_HISTOIRE add HI_DOSSIER INTEGER  DEFAULT 0^
commit^
alter table REF_HISTOIRE alter HI_DOSSIER position 2^
commit^

ALTER TABLE REF_HISTOIRE ADD HI_DICORIGINE VARCHAR(5)^
commit^
alter table REF_HISTOIRE alter HI_DICORIGINE position 3^
commit^

ALTER TABLE REF_HISTOIRE ADD HI_CAT INTEGER^
commit^
alter table REF_HISTOIRE alter HI_CAT position 7^
commit^

CREATE INDEX IDX_REF_HISTOIRE_DOSSIER ON REF_HISTOIRE (HI_DOSSIER)^
commit^

CREATE PROCEDURE PROC_TEMOINS_DE_IND (
    I_CLEF INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(60),
    PRENOM VARCHAR(100),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    DECEDE INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    PERIODE_VIE VARCHAR(15),
    EVENEMENT INTEGER,
    TYPE_TABLE VARCHAR(1),
    ANNEE INTEGER,
    TYPE_EV VARCHAR(7))
AS
begin suspend; end^
commit^

CREATE PROCEDURE PROC_IND_EST_TEMOIN (
    I_CLEF INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(60),
    PRENOM VARCHAR(100),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    DECEDE INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    PERIODE_VIE VARCHAR(15),
    EVENEMENT INTEGER,
    TYPE_TABLE VARCHAR(1),
    ANNEE INTEGER,
    TYPE_EV VARCHAR(7))
AS
begin suspend; end^
commit^

DROP PROCEDURE PROC_ACTES_AFFECT_IMAGE^
commit^

DROP PROCEDURE PROC_DER_PHOTO^
commit^

alter table ref_histoire
alter hi_dicorigine type varchar(8)^
commit^

CREATE INDEX IDX_REF_HISTOIRE_DICORIGINE
ON REF_HISTOIRE (HI_DICORIGINE)^
commit^

CREATE INDEX IDX_REF_CP_VILLE_LATITUDE ON REF_CP_VILLE (CP_LATITUDE)^
commit^

CREATE INDEX IDX_REF_CP_VILLE_LONGITUDE ON REF_CP_VILLE (CP_LONGITUDE)^
commit^

CREATE TRIGGER EVENEMENTS_IND_BIU FOR EVENEMENTS_IND
ACTIVE BEFORE INSERT OR UPDATE POSITION 1
AS
begin
  exit;
end^
commit^

CREATE TRIGGER EVENEMENTS_FAM_BIU FOR EVENEMENTS_FAM
ACTIVE BEFORE INSERT OR UPDATE POSITION 1
AS
begin
  exit;
end^
commit^

CREATE INDEX IDX_REF_TOKEN_DATE_TYPE ON REF_TOKEN_DATE (TYPE_TOKEN, ID)^
commit^

CREATE PROCEDURE PROC_DATES_INCOHERENTES (
    I_DOSSIER INTEGER,
    MIN_MAR_HOM INTEGER,
    MIN_MAR_FEM INTEGER,
    MAX_MAR_HOM INTEGER,
    MAX_MAR_FEM INTEGER,
    MIN_ENF_HOM INTEGER,
    MIN_ENF_FEM INTEGER,
    MAX_ENF_HOM INTEGER,
    MAX_ENF_FEM INTEGER,
    MAX_VIE_HOM INTEGER,
    MAX_VIE_FEM INTEGER,
    MAX_ECART_EPOUX INTEGER,
    MIN_ENTRE_ENF INTEGER)
RETURNS (
    CLEF_IND INTEGER,
    LIBELLE VARCHAR(121),
    AGE DECIMAL(15,1),
    TITRE SMALLINT)
AS
begin suspend; end^
commit^

DROP INDEX IDX_MULTIMEDIA_IDENTITE^
commit^
DROP INDEX IDX_MULTIMEDIA_NUM_ACTE^
commit^
DROP INDEX IDX_MULTIMEDIA_TYPE_ACTE^
commit^
DROP INDEX MULTIMEDIA_DOSSIER^
commit^
CREATE INDEX IDX_MULTIMEDIA_PATH
ON MULTIMEDIA (MULTI_PATH)^
commit^

DROP DOMAIN BOOLEEN^
commit^
DROP DOMAIN "SMALLINT"^
commit^
DROP EXTERNAL FUNCTION "LOWER"^
commit^

CREATE TRIGGER MEDIA_POINTEURS_BIU FOR MEDIA_POINTEURS
ACTIVE BEFORE INSERT OR UPDATE POSITION 0
AS
begin exit; end^
commit^

ALTER TABLE REF_CP_VILLE
ADD CP_NOM_HABITANTS VARCHAR(50) CHARACTER SET ISO8859_1 
COLLATE ISO8859_1 ^
commit^

alter table REF_CP_VILLE
alter CP_NOM_HABITANTS position 16^
commit^

CREATE INDEX INDIVIDU_NOM_PRENOM_CLE ON INDIVIDU (NOM,PRENOM,CLE_FICHE)^
commit^
CREATE DESCENDING INDEX INDIVIDU_NOM_PRENOM_CLE_DESC ON INDIVIDU (NOM,PRENOM,CLE_FICHE)^
commit^

CREATE PROCEDURE PROC_ECLATE_DESCRIPTION (
    DESCRIPTION VARCHAR(90))
RETURNS (
    S_DESCRIPTION VARCHAR(90))
AS
begin suspend; end^
commit^

CREATE PROCEDURE PROC_LISTE_PROFESSION (
    I_DOSSIER INTEGER)
RETURNS (
    PROFESSION VARCHAR(90),
    CLE_FICHE INTEGER,
    SEXE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISSANCE VARCHAR(100),
    ANNEE_NAISSANCE INTEGER,
    DATE_DECES VARCHAR(100),
    ANNEE_DECES INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    DESCRIPTION VARCHAR(90),
    DATE_PROFESSION VARCHAR(100),
    ANNEE_PROFESSION INTEGER,
    VILLE_PROFESSION VARCHAR(50),
    DEPT_PROFESSION VARCHAR(30))
AS
begin suspend; end^
commit^

CREATE PROCEDURE PROC_PREP_PROFESSIONS (
    I_DOSSIER INTEGER)
RETURNS (
    PROFESSION VARCHAR(90))
AS
DECLARE VARIABLE S_PROFESSION VARCHAR(90) CHARACTER SET ISO8859_1;
begin
suspend; end^
commit^

DROP PROCEDURE PROC_UPDATE_VERSION^
commit^

CREATE INDEX INDIVIDU_ID_IMPORT ON INDIVIDU (ID_IMPORT_GEDCOM)^
commit^

DROP PROCEDURE PROC_CHARGE_MEDIA^
commit^

CREATE PROCEDURE PROC_COPIE_DOSSIER (
    DOSSIERS INTEGER,
    I_DOSSIERC INTEGER)
RETURNS (
    DOSSIERC INTEGER)
AS
begin suspend; end^
commit^

DROP PROCEDURE PROC_COMPTE_LIEUX^
commit^

CREATE INDEX T_ASSOCIATIONS_TABLE_EVE
ON T_ASSOCIATIONS (ASSOC_TABLE,ASSOC_EVENEMENT)^
commit^

CREATE INDEX IDX_NOM_ATTACHEMENT_ID_INDI
ON NOM_ATTACHEMENT (ID_INDI)^
commit^

CREATE INDEX IDX_HISTORIQUE_IND
ON HISTORIQUE (HISTO_KLE_IND)^
commit^

CREATE TRIGGER TBD_DOSSIER FOR DOSSIER
ACTIVE BEFORE DELETE POSITION 0
AS
begin
/*créé par André le 23/08/2007 pour assurer l'intégrité des données*/
  execute procedure proc_vide_dossier(old.cle_dossier);
end^
commit^

CREATE TRIGGER T_BD_INDIVIDU FOR INDIVIDU
ACTIVE BEFORE DELETE POSITION 0
AS
begin
exit;
end^
commit^

CREATE TRIGGER T_BI_REF_PARTICULES FOR REF_PARTICULES
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  if (new.part_clef is null) then
    new.part_clef=gen_id(gen_ref_particules,1);
end^
commit^

/*Fin des instructions pouvant provoquer des erreurs normales
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
SET ECHO OFF^

alter TRIGGER MEDIA_POINTEURS_BIU
ACTIVE BEFORE INSERT OR UPDATE POSITION 0
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
commit^

alter TRIGGER EVENEMENTS_IND_BIU
ACTIVE BEFORE INSERT OR UPDATE POSITION 1
AS
/*Créé par André le 27/02/2007
Mise en majuscule de la première lettre de Titre*/
begin
  if (new.ev_ind_titre_event is not null) then
  begin
    new.ev_ind_titre_event=trim(new.ev_ind_titre_event);
    if (char_length(new.ev_ind_titre_event)=1) then
      new.ev_ind_titre_event= upper(substring(new.ev_ind_titre_event from 1 for 1));
    else
      if (char_length(new.ev_ind_titre_event)>1) then
        new.ev_ind_titre_event= upper(substring(new.ev_ind_titre_event from 1 for 1))||
                          substring(new.ev_ind_titre_event from 2);
  end
end^
commit^

alter TRIGGER EVENEMENTS_FAM_BIU
ACTIVE BEFORE INSERT OR UPDATE POSITION 1
AS
/*Créé par André le 27/02/2007
Mise en majuscule de la première lettre de Titre*/
begin
  if (new.ev_fam_titre_event is not null) then
  begin
    new.ev_fam_titre_event=trim(new.ev_fam_titre_event);
    if (char_length(new.ev_fam_titre_event)=1) then
      new.ev_fam_titre_event= upper(substring(new.ev_fam_titre_event from 1 for 1));
    else
      if (char_length(new.ev_fam_titre_event)>1) then
        new.ev_fam_titre_event= upper(substring(new.ev_fam_titre_event from 1 for 1))||
                          substring(new.ev_fam_titre_event from 2);
  end
end^
commit^

CREATE TRIGGER REF_HISTOIRE_BIU FOR REF_HISTOIRE
ACTIVE BEFORE INSERT OR UPDATE POSITION 0
AS
declare variable i_mois_deb integer;
declare variable i_an_deb integer;
declare variable i_mois_fin integer;
declare variable i_an_fin integer;
BEGIN
   /*---------------------------------------------------------------------------
   créée par André le 18/01.2007,  modifiée le 24/02/2007
   ---------------------------------------------------------------------------*/
  IF (NEW.HI_ID IS NULL) THEN
      NEW.HI_ID = GEN_ID(gen_ref_histoire,1);
  SELECT IMOIS,IAN,DDATE,IMOIS_FIN,IAN_FIN,DDATE_FIN,DATE_WRITEN_S
  FROM PROC_DATE_WRITEN(NEW.HI_DATE_TEXTE)
    INTO :i_mois_deb,:i_an_deb,NEW.HI_DATE_DEBUT,
         :i_mois_fin,i_an_fin,NEW.HI_DATE_FIN,
         NEW.HI_DATE_TEXTE;
  if (NEW.HI_DATE_FIN is null) then
    if (i_an_fin>0) then
      if (i_mois_fin is null or i_mois_fin=12) then
        if (i_an_fin<99) then
           NEW.HI_DATE_FIN=cast('1/1/'||'00'||(i_an_fin+1) as date)-1;
        else
           NEW.HI_DATE_FIN=cast('1/1/'||(i_an_fin+1) as date)-1;
      else
        if (i_an_fin<100) then
           NEW.HI_DATE_FIN=cast((i_mois_fin+1)||'/1/'||'00'||i_an_fin as date)-1;
        else
           NEW.HI_DATE_FIN=cast((i_mois_fin+1)||'/1/'||i_an_fin as date)-1;
    else
      if (NEW.HI_DATE_DEBUT is not null) then
        NEW.HI_DATE_FIN=NEW.HI_DATE_DEBUT;
      else
        if (i_an_deb>0) then
          if (i_mois_deb is null or i_mois_deb=12) then
            if (i_an_deb<99) then
              NEW.HI_DATE_FIN=cast('1/1/'||'00'||(i_an_deb+1) as date)-1;
            else
              NEW.HI_DATE_FIN=cast('1/1/'||(i_an_deb+1) as date)-1;
          else
            if (i_an_deb<100) then
              NEW.HI_DATE_FIN=cast((i_mois_deb+1)||'/1/'||'00'||i_an_deb as date)-1;
            else
              NEW.HI_DATE_FIN=cast((i_mois_deb+1)||'/1/'||i_an_deb as date)-1;
  if (NEW.HI_DATE_DEBUT is null and i_an_deb>0) then
    if (i_an_deb<100) then
      NEW.HI_DATE_DEBUT=cast(coalesce(i_mois_deb,1)||'/1/'||'00'||i_an_deb as date);
    else
      NEW.HI_DATE_DEBUT=cast(coalesce(i_mois_deb,1)||'/1/'||i_an_deb as date);
  new.hi_dicorigine=upper(new.hi_dicorigine);
END^
commit^

alter PROCEDURE PROC_TEMOINS_DE_IND (
    I_CLEF INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(60),
    PRENOM VARCHAR(100),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    DECEDE INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    PERIODE_VIE VARCHAR(15),
    EVENEMENT INTEGER,
    TYPE_TABLE VARCHAR(1),
    ANNEE INTEGER,
    TYPE_EV VARCHAR(7))
AS
begin
/*procédure créée par André le 01/02/2007*/
 for SELECT --les individus témoins de ses événements familiaux
           i.CLE_FICHE,
           i.NOM,
           i.PRENOM,
           i.DATE_NAISSANCE,
           i.DATE_DECES,
           i.SEXE,
           i.Cle_Pere,
           i.Cle_Mere
           ,i.decede
           ,i.Num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '( '||coalesce(cast(i.annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(i.annee_deces as varchar(5)),' ')||' )')
           ,e.ev_fam_clef
           ,'U'
           ,e.ev_fam_date_year
           ,e.ev_fam_type
            from t_union u
            inner join evenements_fam e on e.ev_fam_kle_famille=u.union_clef
            inner join t_associations a on a.assoc_kle_ind=e.ev_fam_clef and
                                           a.ASSOC_TABLE = 'U'
            inner join individu i on i.cle_fiche=a.assoc_kle_associe
            where :i_clef in(u.union_mari,u.union_femme)
    UNION
    SELECT --les individus témoins de ses événéments individuels
           i.CLE_FICHE,
           i.NOM,
           i.PRENOM,
           i.DATE_NAISSANCE,
           i.DATE_DECES,
           i.SEXE,
           i.Cle_Pere,
           i.Cle_Mere
           ,i.decede
           ,i.Num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '( '||coalesce(cast(i.annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(i.annee_deces as varchar(5)),' ')||' )')
           ,e.ev_ind_clef
           ,'I'
           ,e.ev_ind_date_year
           ,e.ev_ind_type
            FROM T_ASSOCIATIONS A
            inner join evenements_ind e on e.ev_ind_clef=a.assoc_evenement
            inner join INDIVIDU I on i.CLE_FICHE=A.ASSOC_KLE_ASSOCIE
            WHERE  a.ASSOC_KLE_IND=:I_CLEF
              and A.ASSOC_TABLE = 'I'
    order by 2,3
    INTO
         :CLE_FICHE,
         :NOM,
         :PRENOM,
         :DATE_NAISSANCE,
         :DATE_DECES,
         :SEXE,
         :CLE_PERE,
         :CLE_MERE,
         :DECEDE,
         :num_sosa,
         :periode_vie,
         :evenement,
         :type_table,
         :annee,
         :type_ev
    do
    suspend;
end^
commit^

alter PROCEDURE PROC_IND_EST_TEMOIN (
    I_CLEF INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(60),
    PRENOM VARCHAR(100),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    DECEDE INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    PERIODE_VIE VARCHAR(15),
    EVENEMENT INTEGER,
    TYPE_TABLE VARCHAR(1),
    ANNEE INTEGER,
    TYPE_EV VARCHAR(7))
AS
begin
/*procédure créée par André le 01/02/2007*/
 for SELECT --les maris dont il est témoin
           i.CLE_FICHE,
           i.NOM,
           i.PRENOM,
           i.DATE_NAISSANCE,
           i.DATE_DECES,
           i.SEXE,
           i.Cle_Pere,
           i.Cle_Mere
           ,i.decede
           ,i.Num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '( '||coalesce(cast(i.annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(i.annee_deces as varchar(5)),' ')||' )')
           ,e.ev_fam_clef
           ,'U'
           ,e.ev_fam_date_year
           ,e.ev_fam_type
            from t_associations A
            inner join evenements_fam E on E.EV_FAM_CLEF=A.ASSOC_KLE_IND
            inner join t_union u on U.UNION_CLEF=E.EV_FAM_KLE_FAMILLE
            inner join individu I on I.CLE_FICHE =U.UNION_MARI
            where A.ASSOC_KLE_ASSOCIE =:I_CLEF
            and A.ASSOC_TABLE = 'U'
    UNION
    SELECT --les femmes dont il est témoin
           i.CLE_FICHE,
           i.NOM,
           i.PRENOM,
           i.DATE_NAISSANCE,
           i.DATE_DECES,
           i.SEXE,
           i.Cle_Pere,
           i.Cle_Mere
           ,i.decede
           ,i.Num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '( '||coalesce(cast(i.annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(i.annee_deces as varchar(5)),' ')||' )')
           ,e.ev_fam_clef
           ,'U'
           ,e.ev_fam_date_year
           ,e.ev_fam_type
            from t_associations A
            inner join evenements_fam E on E.EV_FAM_CLEF=A.ASSOC_KLE_IND
            inner join t_union u on U.UNION_CLEF=E.EV_FAM_KLE_FAMILLE
            inner join individu I on I.CLE_FICHE =U.UNION_FEMME
            where A.ASSOC_KLE_ASSOCIE =:I_CLEF
            and A.ASSOC_TABLE = 'U'
    UNION
    SELECT --les individus dont il est témoin d'ev_ind
           i.CLE_FICHE,
           i.NOM,
           i.PRENOM,
           i.DATE_NAISSANCE,
           i.DATE_DECES,
           i.SEXE,
           i.Cle_Pere,
           i.Cle_Mere
           ,i.decede
           ,i.Num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '( '||coalesce(cast(i.annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(i.annee_deces as varchar(5)),' ')||' )')
           ,e.ev_ind_clef
           ,'I'
           ,e.ev_ind_date_year
           ,e.ev_ind_type
            FROM T_ASSOCIATIONS A
            inner join evenements_ind e on e.ev_ind_clef=a.assoc_evenement
            inner join INDIVIDU I on i.CLE_FICHE=a.ASSOC_KLE_IND
            WHERE A.ASSOC_KLE_ASSOCIE =:I_CLEF
              and A.ASSOC_TABLE = 'I'
    order by 2,3
    INTO
         :CLE_FICHE,
         :NOM,
         :PRENOM,
         :DATE_NAISSANCE,
         :DATE_DECES,
         :SEXE,
         :CLE_PERE,
         :CLE_MERE,
         :DECEDE,
         :num_sosa,
         :periode_vie,
         :evenement,
         :type_table,
         :annee,
         :type_ev
    do
    suspend;
end^
commit^

alter PROCEDURE PROC_NAVIGATION (
    I_CLEF INTEGER,
    I_DOSSIER INTEGER,
    I_MAX INTEGER)
RETURNS (
    NIVEAU INTEGER,
    CLE_FICHE INTEGER,
    NOM VARCHAR(60),
    PRENOM VARCHAR(100),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    SOSA DOUBLE PRECISION,
    DECEDE INTEGER,
    VILLE_NAISSANCE VARCHAR(50),
    VILLE_DECES VARCHAR(50),
    AGE_EN_JOURS INTEGER,
    PROFESSION VARCHAR(90),
    DATE_UNION VARCHAR(90),
    VILLE_UNION VARCHAR(50),
    PHOTO BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    ENFANTS INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    PERIODE_VIE VARCHAR(15),
    AGE_UNION_JOURS INTEGER,
    AGE_UNION_IND_JOURS INTEGER)
AS
DECLARE VARIABLE I_SEXE INTEGER;
DECLARE VARIABLE I_CLE_PERE INTEGER;
DECLARE VARIABLE I_CLE_MERE INTEGER;
DECLARE VARIABLE I_CLE_PERE_PERE INTEGER;
DECLARE VARIABLE I_CLE_PERE_MERE INTEGER;
DECLARE VARIABLE I_CLE_MERE_PERE INTEGER;
DECLARE VARIABLE I_CLE_MERE_MERE INTEGER;
DECLARE VARIABLE DATE_NAIS DATE;
DECLARE VARIABLE MOIS_NAIS INTEGER;
DECLARE VARIABLE AN_NAIS INTEGER;
DECLARE VARIABLE DATE_EVE DATE;
DECLARE VARIABLE MOIS_EVE INTEGER;
DECLARE VARIABLE AN_EVE INTEGER;
DECLARE VARIABLE DATE_NAIS_IND DATE;
DECLARE VARIABLE DATE_NAIS_PERE DATE;
DECLARE VARIABLE DATE_NAIS_MERE DATE;
DECLARE VARIABLE DATE_MARIAGE DATE;
DECLARE VARIABLE I INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   dernières modifications André le 01/02/2007 (ajout témoins)
   I_DOSSIER n'est plus utilisé mais reste nécessaire
   tant que le programme ancestrologie.exe n'aura pas été mis à jour.
   I_MAX est utilisé pour définir le mode de fonctionnement
   0: peu d'informations pour petite fenêtre de navigation
   1:: informations complètes pour grande fenêtre de navigation
   2: idem 1 avec grandes photos
   3: idem sans photos
   Description :    Cette procedure permet de récuperer la famille d'un individu
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
   9 - Neveux et nièces
   10- Individus dont il est témoin
   11- Témoins de ses événements
   Usage       :
   ---------------------------------------------------------------------------*/
   SELECT  SEXE,cle_pere,cle_mere
      FROM INDIVIDU
      WHERE CLE_FICHE = :I_CLEF
      INTO :I_SEXE,:i_cle_pere,:i_cle_mere;
   I=0;
   for
   SELECT  0,      --l'individu
           cle_fiche,
           nom,
           prenom,
           Date_Naissance,
           Date_deces,
           Sexe,
           Cle_Pere,
           Cle_Mere,
           1
           ,decede
           ,Num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '( '||coalesce(cast(annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(annee_deces as varchar(5)),' ')||' )')
         FROM individu
              Where cle_fiche  = :i_clef
    UNION
    SELECT 1,    --son père
           cle_fiche,
           nom,
           prenom,
           Date_Naissance,
           Date_deces,
           Sexe,
           Cle_Pere,
           Cle_Mere,
           2
           ,decede
           ,Num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '( '||coalesce(cast(annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(annee_deces as varchar(5)),' ')||' )')
         FROM individu
              Where cle_fiche=(SELECT CLE_PERE FROM individu
                                 WHERE CLE_FICHE=:I_CLEF)
    UNION
    SELECT 1,   --sa mère
           cle_fiche,
           nom,
           prenom,
           Date_Naissance,
           Date_deces,
           Sexe,
           Cle_Pere,
           Cle_Mere,
           3
           ,decede
           ,Num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '( '||coalesce(cast(annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(annee_deces as varchar(5)),' ')||' )')
         FROM individu
              Where cle_fiche=(SELECT CLE_MERE FROM individu
                                 WHERE CLE_FICHE=:I_CLEF)
    UNION
    SELECT 2,   --ses grands parents
           cle_fiche,
           nom,
           prenom,
           Date_Naissance,
           Date_deces,
           Sexe,
           Cle_Pere,
           Cle_Mere,
           SOSA
           ,decede
           ,Num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '( '||coalesce(cast(annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(annee_deces as varchar(5)),' ')||' )')
           FROM PROC_TROUVE_GRANDS_PARENT(:I_CLEF)
   UNION
    SELECT 4,  --ses frères et soeurs
           CLE_FICHE,
           NOM,
           PRENOM,
           DATE_NAISSANCE,
           DATE_DECES,
           SEXE,
           Cle_Pere,
           Cle_Mere
           ,F_1
           ,decede
           ,Num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '( '||coalesce(cast(annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(annee_deces as varchar(5)),' ')||' )')
           FROM PROC_TROUVE_FRERES_SOEURS(:I_CLEF)
    UNION
    SELECT 3,
           CLE_FICHE,
           NOM,
           PRENOM,
           DATE_NAISSANCE,
           DATE_DECES,
           SEXE,
           Cle_Pere,
           Cle_Mere
           ,SOSA
           ,decede
           ,Num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '( '||coalesce(cast(annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(annee_deces as varchar(5)),' ')||' )')
           FROM PROC_TROUVE_ONCLES_TANTES(:I_CLEF,0,0)
    UNION
    SELECT 5,   -- ses enfants
           CLE_FICHE,
           NOM,
           PRENOM,
           DATE_NAISSANCE,
           DATE_DECES,
           SEXE,
           Cle_Pere,
           Cle_Mere
           ,annee_naissance
           ,decede
           ,Num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '( '||coalesce(cast(annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(annee_deces as varchar(5)),' ')||' )')
      FROM INDIVIDU
      WHERE (:i_sexe=1 and CLE_PERE=:i_clef)
         OR (:i_sexe=2 and CLE_MERE=:i_clef)
    UNION
    SELECT 7,  --ses conjoints
           CLE_FICHE,
           NOM,
           PRENOM,
           DATE_NAISSANCE,
           DATE_DECES,
           SEXE,
           Cle_Pere,
           Cle_Mere
           ,annee_mariage
           ,decede
           ,Num_sosa
           ,iif(annee_naissance is null and annee_deces is null,null,
            '( '||coalesce(cast(annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(annee_deces as varchar(5)),' ')||' )')
           FROM PROC_TROUVE_UNIONS (0,:I_CLEF)
    UNION
    SELECT 6,  --ses cousins et cousines
           i.CLE_FICHE,
           i.NOM,
           i.PRENOM,
           i.DATE_NAISSANCE,
           i.DATE_DECES,
           i.SEXE,
           i.Cle_Pere,
           i.Cle_Mere
           ,p.SOSA*10000+coalesce(i.annee_naissance,0)
           ,i.decede
           ,i.Num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '( '||coalesce(cast(i.annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(i.annee_deces as varchar(5)),' ')||' )')
           FROM proc_trouve_oncles_tantes (:I_CLEF,0,0) p,
                INDIVIDU i
           WHERE (p.sexe=1 and i.cle_pere=p.cle_fiche)
              or (p.sexe=2 and i.cle_mere=p.cle_fiche)
    UNION
    SELECT 8,  --ses petits enfants
           i.CLE_FICHE,
           i.NOM,
           i.PRENOM,
           i.DATE_NAISSANCE,
           i.DATE_DECES,
           i.SEXE,
           i.Cle_Pere,
           i.Cle_Mere
           ,coalesce(p.annee_naissance,0)*10000+coalesce(i.annee_naissance,0)
           ,i.decede
           ,i.Num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '( '||coalesce(cast(i.annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(i.annee_deces as varchar(5)),' ')||' )')
           FROM (SELECT CLE_FICHE,SEXE,annee_naissance
                 FROM INDIVIDU
                 WHERE (:i_sexe=1 and CLE_PERE=:i_clef)
                    OR (:i_sexe=2 and CLE_MERE=:i_clef)) as p,
                individu i
           where (p.sexe=1 and i.cle_pere=p.cle_fiche)
              or (p.sexe=2 and i.cle_mere=p.cle_fiche)
    UNION
    SELECT 9,   --ses neveux et nièces
           i.CLE_FICHE,
           i.NOM,
           i.PRENOM,
           i.DATE_NAISSANCE,
           i.DATE_DECES,
           i.SEXE,
           i.Cle_Pere,
           i.Cle_Mere
           ,p.F_1*10000+coalesce(i.annee_naissance,0)
           ,i.decede
           ,i.Num_sosa
           ,iif(i.annee_naissance is null and i.annee_deces is null,null,
            '( '||coalesce(cast(i.annee_naissance as varchar(5)),' ')||
            ' - '||coalesce(cast(i.annee_deces as varchar(5)),' ')||' )')
           FROM proc_trouve_freres_soeurs (:I_CLEF) p,
                INDIVIDU i
           WHERE (p.sexe=1 and i.cle_pere=p.cle_fiche)
              or (p.sexe=2 and i.cle_mere=p.cle_fiche)
    UNION
    SELECT distinct 10,   --les individus dont il est témoin
           CLE_FICHE,
           NOM,
           PRENOM,
           DATE_NAISSANCE,
           DATE_DECES,
           SEXE,
           Cle_Pere,
           Cle_Mere
           ,:i+1
           ,decede
           ,Num_sosa
           ,periode_vie
            from proc_ind_est_temoin(:I_clef)
    UNION
    SELECT distinct 11,   --les individus témoins de ses événements
           CLE_FICHE,
           NOM,
           PRENOM,
           DATE_NAISSANCE,
           DATE_DECES,
           SEXE,
           Cle_Pere,
           Cle_Mere
           ,:i+1
           ,decede
           ,Num_sosa
           ,periode_vie
            from proc_temoins_de_ind(:I_clef)
    order by 1,10
    INTO :NIVEAU,
         :CLE_FICHE,
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
         :periode_vie
   do
   begin
     if (i_max in(1,2,3)) then
     begin
       ville_naissance=null;
       ville_deces=null;
       age_en_jours=null;
       profession=null;
       photo=null;
       enfants=null;
       age_union_jours=null;
       age_union_ind_jours=null;
       if (not(niveau=1 and sosa=3)) then
       begin
         date_union=null;
         ville_union=null;
         date_mariage=null;
       end
       if (niveau in (0,1,2,5,7)) then
       begin
         date_nais=null;
         mois_nais=null;
         an_nais=null;
         date_eve=null;
         mois_eve=null;
         an_eve=null;
         select first(1) ev_ind_ville
                        ,ev_ind_date
                        ,ev_ind_date_mois
                        ,ev_ind_date_year
         from evenements_ind  --les villes de naissances
         where ev_ind_kle_fiche=:cle_fiche and ev_ind_type='BIRT'
         into :ville_naissance
             ,:date_nais
             ,:mois_nais
             ,:an_nais;
         if (AN_NAIS is not null and DATE_NAIS is null) then
           DATE_NAIS=cast(coalesce(MOIS_NAIS,1)||'/'||1||'/'||AN_NAIS as date);
         select first(1) ev_ind_ville
                        ,ev_ind_date
                        ,ev_ind_date_mois
                        ,ev_ind_date_year
         from evenements_ind  --les villes de décès
         where ev_ind_kle_fiche=:cle_fiche and ev_ind_type='DEAT'
         into :ville_deces
             ,:date_eve
             ,:mois_eve
             ,:an_eve;
         if (DATE_NAIS is not null) then
         begin
           if (decede is null) then
             date_eve=current_date;
           else
             if (DATE_EVE is null and an_eve is not null) then
               DATE_EVE=cast(coalesce(MOIS_EVE,1)||'/'||1||'/'||AN_EVE as date);
           if (DATE_EVE is not null) then
             AGE_EN_JOURS=DATE_EVE-DATE_NAIS;
         end
         if (i_max=1) then
           select count(*)  --le petit média et le nombre d'enfants
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
           into :ENFANTS
               ,:photo;
         else
         if (i_max=2) then
           select count(*)  --le grand média et le nombre d'enfants
                 ,coalesce((select multi_media from multimedia
                         where multi_clef=(select first(1)mp_media from media_pointeurs
                                           where mp_cle_individu=:cle_fiche
                                             and mp_identite=1))
                        ,(select multi_media from multimedia
                          where multi_clef=(select first(1)mp_media from media_pointeurs
                                           where mp_cle_individu=:cle_fiche
                                             order by mp_clef desc)))
           from individu
           where (:sexe=1 and cle_pere=:cle_fiche)
              or (:sexe=2 and cle_mere=:cle_fiche)
           into :ENFANTS
               ,:photo;
           else  --i_max=3
           select count(*)  --le nombre d'enfants
           from individu
           where (:sexe=1 and cle_pere=:cle_fiche)
              or (:sexe=2 and cle_mere=:cle_fiche)
           into :ENFANTS;
         select first(1) ev_ind_description from evenements_ind
         where ev_ind_kle_fiche=:cle_fiche and ev_ind_type='OCCU'
         order by ev_ind_ordre DESC, ev_ind_date_year desc, ev_ind_date desc
         into :profession;
         date_eve=null;
         mois_eve=null;
         an_eve=null;

         if (niveau=0) then  --individu central
           date_nais_ind=date_nais;

         if (niveau=1) then  --ses parents
         begin
           if (sosa=2) then  --le père
           begin
             if (i_cle_mere is not null) then
               select first(1) e.ev_fam_date_writen  --l'union des parents
                              ,e.ev_fam_ville
                              ,ev_fam_date
                              ,ev_fam_date_mois
                              ,ev_fam_date_year
               from t_union u
               inner join evenements_fam e on ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
               where u.union_mari=:i_cle_pere and u.union_femme=:i_cle_mere
               order by ev_fam_date_year,ev_fam_date_mois,ev_fam_date
               into :date_union
                   ,:ville_union
                   ,:date_eve
                   ,:mois_eve
                   ,:an_eve;
             if (AN_EVE is null) then
               date_mariage=null;
             else
               if (DATE_EVE is null) then
                 date_mariage=cast(coalesce(MOIS_EVE,1)||'/'||1||'/'||AN_EVE as date);
               else
                 date_mariage=date_eve;
             date_nais_pere=date_nais;
             i_cle_pere_pere=cle_pere;  --parents du père
             i_cle_mere_pere=cle_mere;
           end
           else     --la mère
           begin
             date_nais_mere=date_nais;
             i_cle_pere_mere=cle_pere;  --parents de la mère
             i_cle_mere_mere=cle_mere;
           end
           if (DATE_NAIS is not null and date_mariage is not null) then
             AGE_UNION_JOURS=date_mariage-DATE_NAIS;
           if (DATE_NAIS is not null and DATE_NAIS_IND is not null) then
             AGE_UNION_IND_JOURS=DATE_NAIS_IND-DATE_NAIS; --âge des parents à la naissance
         end  --de niveau=1

         if (niveau=2) then --les grands parents
         begin
           if (sosa in(4,5)) then --parents du père
           begin
             if (i_cle_pere_pere is not null and i_cle_mere_pere is not null) then
             begin
              select first(1) e.ev_fam_date_writen   --l'union des parents du père
                              ,e.ev_fam_ville
                              ,ev_fam_date
                              ,ev_fam_date_mois
                              ,ev_fam_date_year
               from t_union u
               inner join evenements_fam e on ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
               where u.union_mari=:i_cle_pere_pere and u.union_femme=:i_cle_mere_pere
               order by ev_fam_date_year,ev_fam_date_mois,ev_fam_date
               into :date_union
                   ,:ville_union
                   ,:date_eve
                   ,:mois_eve
                   ,:an_eve;
               if (AN_EVE is null) then
                 date_mariage=null;
               else
               if (DATE_EVE is null) then
                 date_mariage=cast(coalesce(MOIS_EVE,1)||'/'||1||'/'||AN_EVE as date);
               else
                 date_mariage=date_eve;
             end  --de l'union des parents du père
             if (DATE_NAIS is not null and date_mariage is not null) then
               AGE_UNION_JOURS=date_mariage-DATE_NAIS;
             if (DATE_NAIS is not null and DATE_NAIS_PERE is not null) then
               AGE_UNION_IND_JOURS=DATE_NAIS_PERE-DATE_NAIS; --âge GP à la naissance du père
           end  --des parents du père
           else --parents de la mère
           begin
             if (i_cle_pere_mere is not null and i_cle_mere_mere is not null) then
             begin
               date_mariage=null;
               select first(1) e.ev_fam_date_writen   --l'union des parents de la mère
                              ,e.ev_fam_ville
                              ,ev_fam_date
                              ,ev_fam_date_mois
                              ,ev_fam_date_year
               from t_union u
               inner join evenements_fam e on ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
               where u.union_mari=:i_cle_pere_mere and u.union_femme=:i_cle_mere_mere
               order by ev_fam_date_year,ev_fam_date_mois,ev_fam_date
               into :date_union
                   ,:ville_union
                   ,:date_eve
                   ,:mois_eve
                   ,:an_eve;
               if (AN_EVE is null) then
                 date_mariage=null;
               else
               if (DATE_EVE is null) then
                 date_mariage=cast(coalesce(MOIS_EVE,1)||'/'||1||'/'||AN_EVE as date);
               else
                 date_mariage=date_eve;
             end  --de l'union des parents de la mère
             if (DATE_NAIS is not null and date_mariage is not null) then
               AGE_UNION_JOURS=date_mariage-DATE_NAIS;
             if (DATE_NAIS is not null and DATE_NAIS_MERE is not null) then
               AGE_UNION_IND_JOURS=DATE_NAIS_MERE-DATE_NAIS; --âge GP à la naissance de la mère
           end  --des parents de la mère
         end  --des grands-parents

         if (niveau=5) then  --les enfants
         begin
           if (DATE_NAIS is not null and DATE_NAIS_IND is not null) then
             AGE_UNION_IND_JOURS=DATE_NAIS-DATE_NAIS_IND; --âge indi à la naissance de l'enfant
           if (DATE_NAIS is not null
             and((i_sexe=1 and cle_mere is not null)
                 or(i_sexe=2 and cle_pere is not null))) then
           begin
             select first(1) ev_ind_date
                        ,ev_ind_date_mois
                        ,ev_ind_date_year
             from evenements_ind  --la naissance du conjoint père ou mère de l'enfant
             where ((:i_sexe=2 and ev_ind_kle_fiche=:cle_pere)
                    or (:i_sexe=1 and ev_ind_kle_fiche=:cle_mere))
               and ev_ind_type='BIRT'
             into :date_eve
                 ,:mois_eve
                 ,:an_eve;
             if (an_eve is not null) then
             begin
               if (DATE_EVE is null) then
                   DATE_EVE=cast(coalesce(MOIS_EVE,1)||'/'||1||'/'||AN_EVE as date);
               AGE_UNION_JOURS=DATE_NAIS-DATE_EVE;
             end
           end
         end
         if (niveau=7) then  --les conjoints
         begin
           select first(1) e.ev_fam_date_writen
                          ,e.ev_fam_ville
                          ,ev_fam_date
                          ,ev_fam_date_mois
                          ,ev_fam_date_year
           from t_union u
           inner join evenements_fam e on ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
           where (:i_sexe=1 and u.union_mari=:i_clef and u.union_femme=:cle_fiche)
              or (:i_sexe=2 and u.union_mari=:cle_fiche and u.union_femme=:i_clef)
           order by ev_fam_date_year,ev_fam_date_mois,ev_fam_date
           into :date_union
               ,:ville_union
               ,:date_eve
               ,:mois_eve
               ,:an_eve;
           if (AN_EVE is not null) then
           begin
             if (DATE_EVE is null) then
               date_eve=cast(coalesce(MOIS_EVE,1)||'/'||1||'/'||AN_EVE as date);
             if (DATE_NAIS is not null and DATE_EVE is not null) then
               AGE_UNION_JOURS=DATE_EVE-DATE_NAIS;  --âge conjoint au mariage
             if (DATE_NAIS_IND is not null and DATE_EVE is not null) then
               AGE_UNION_IND_JOURS=DATE_EVE-DATE_NAIS_IND; --âge indi au mariage
           end
         end -- de conjoints

       end -- de (niveau in (0,1,2,5,7))
     end --de I_MAX in(1,2,3)
     suspend;
   end
end^
commit^

alter PROCEDURE PROC_TROUVE_COUSINS_COUSINES (
    I_CLEF INTEGER,
    I_DOSSIER INTEGER,
    I_MAX INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SEXE INTEGER,
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    SOSA DOUBLE PRECISION)
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée le :18/01/2007 I_MAX, I_DOSSIER plus utilisés
   utilisation proc_trouve_oncles_tantes
   par :André
   ---------------------------------------------------------------------------*/
for SELECT i.CLE_FICHE,
           i.NOM,
           i.PRENOM,
           i.SEXE,
           i.DATE_NAISSANCE,
           i.DATE_DECES,
           i.Cle_Pere,
           i.Cle_Mere,
           i.Num_sosa
           FROM proc_trouve_oncles_tantes (:I_CLEF,0,0) p,
                INDIVIDU i
           WHERE (p.sexe=1 and i.cle_pere=p.cle_fiche)
              or (p.sexe=2 and i.cle_mere=p.cle_fiche)
         order by i.nom,i.Prenom
         INTO :CLE_FICHE,
              :NOM,
              :PRENOM,
              :SEXE,
              :DATE_NAISSANCE,
              :DATE_DECES,
              :CLE_PERE,
              :CLE_MERE,
              :SOSA
    do suspend;
END^
commit^

alter PROCEDURE PROC_PREP_PRENOMS (
    I_DOSSIER INTEGER)
RETURNS (
    PRENOM VARCHAR(60),
    SEXE INTEGER)
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
commit^

alter PROCEDURE PROC_NEW_PRENOMS (
    I_DOSSIER INTEGER)
AS
DECLARE VARIABLE PRENOM VARCHAR(60) CHARACTER SET ISO8859_1;
DECLARE VARIABLE SEXE INTEGER;
begin
  delete from prenoms;
  for select distinct prenom,sexe from proc_prep_prenoms(:I_DOSSIER)
      where prenom is not null and prenom<>''
      into :prenom,:sexe
  do
  begin
    update prenoms set sexe=0 where prenom=:prenom;
    if (row_count=0) then
    insert into prenoms (prenom,sexe)
           values(:prenom,:sexe);
  end
end^
commit^

CREATE TRIGGER T_BU_INDIVIDU FOR INDIVIDU
ACTIVE BEFORE UPDATE POSITION 0
as
begin
exit; end^
commit^

CREATE TRIGGER T_BI_INDIVIDU FOR INDIVIDU
ACTIVE BEFORE INSERT POSITION 0
as
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 01/08/2001
   à : 05:37:37
   Modifiée le : 03/05/2007 par André 
   à :
   par :
   Description :
   Usage       :
   ---------------------------------------------------------------------------*/
  NEW.DATE_CREATION = 'NOW';
  if (NEW.NOM IS NOT NULL) then
    select s_out from f_maj_sans_accent(NEW.NOM)
    into NEW.INDI_TRIE_NOM;
/*01/07/2006 en attendant que l'individu soit créé avant l'évènement....*/
  IF (NEW.DATE_NAISSANCE IS NULL) then
    SELECT EV_IND_DATE_WRITEN,EV_IND_DATE_YEAR FROM EVENEMENTS_IND
      WHERE EV_IND_KLE_FICHE=NEW.CLE_FICHE AND EV_IND_TYPE='BIRT'
      INTO NEW.DATE_NAISSANCE,NEW.ANNEE_NAISSANCE;
  IF (NEW.DATE_DECES IS NULL) then
    SELECT EV_IND_DATE_WRITEN,EV_IND_DATE_YEAR,1 FROM EVENEMENTS_IND
      WHERE EV_IND_KLE_FICHE=NEW.CLE_FICHE AND EV_IND_TYPE='DEAT'
      INTO NEW.DATE_DECES,NEW.ANNEE_DECES,NEW.DECEDE;
  if (NEW.ANNEE_DECES is NOT NULL AND NEW.ANNEE_NAISSANCE is NOT NULL) then
   NEW.AGE_AU_DECES=NEW.ANNEE_DECES-NEW.ANNEE_NAISSANCE;
  else
   NEW.AGE_AU_DECES=NULL;
end^
commit^

alter PROCEDURE PROC_AFTER_IMPORT (
    I_DOSSIER INTEGER,
    I_MODE INTEGER)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 17:48:10
   Modifiée le :30/12/2006  par André, mise à jour INDI_TRIE_NOM par triggers
   Maj du champ uniquement si I_MODE=0, tous les dossiers si I_DOSSIER=0
   par :
   Description :
   Usage       :
   ---------------------------------------------------------------------------*/
  if (I_MODE=0) then
    if (I_DOSSIER=0) then
      update individu i set indi_trie_nom=(select s_out from f_maj_sans_accent(nom));
    else
      update individu i set indi_trie_nom=(select s_out from f_maj_sans_accent(nom))
             WHERE i.KLE_DOSSIER = :I_DOSSIER;
  if (I_MODE = 1 ) then
  begin
     EXECUTE procedure PROC_MAJ_EVE_IND(I_DOSSIER);
     EXECUTE procedure PROC_MAJ_EVE_FAM(I_DOSSIER);
     EXECUTE procedure PROC_MAJ_INSEE(I_DOSSIER);
  end
  suspend;
end^
commit^

ALTER PROCEDURE PROC_SUIVANT (
    IND_ORIGINE INTEGER,
    DELTA INTEGER)
RETURNS (
    CLE_FICHE INTEGER)
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
end^
COMMIT WORK ^

ALTER PROCEDURE PROC_LISTE_INDIVIDU (
    I_DOSSIER INTEGER,
    I_LETTRE VARCHAR(1),
    I_MODE INTEGER,
    I_SEXE INTEGER)
RETURNS (
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SURNOM VARCHAR(120),
    SEXE INTEGER,
    CLE_FICHE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    KLE_DOSSIER INTEGER,
    DATE_NAISSANCE VARCHAR(100),
    ANNEE_DECES INTEGER,
    CP VARCHAR(10),
    VILLE VARCHAR(50),
    NUM_SOSA DOUBLE PRECISION,
    DATE_DECES VARCHAR(100),
    CP_DECES VARCHAR(10),
    VILLE_DECES VARCHAR(50),
    ANNEE_NAISSANCE INTEGER)
AS
begin
/*---------------------------------------------------------------------------
Copyright Philippe Cazaux-Moutou. Tout droits réservés.
Créé le : 2/07/2002 
à : 06:13:52 
Modifiée le :03/05/2007 par André
à : :
par : 
Description : Liste des individus par lettre 
I_MODE : 0 - les morts
1 - les vivants 
2 - tous 
I_LETTRE : Alpha - que ceux de la lettre 
* - Tous 
I_SEXE : 1 - Homme
2 - Femme 
0 - Tous 
Usage :
---------------------------------------------------------------------------*/ 
select s_out from f_maj_sans_accent(:i_lettre) into :i_lettre;
if (I_LETTRE<>'*' AND I_SEXE = 0) then /* Une lettre et tous les sexes */
for 
    SELECT enfant.nom,
           enfant.prenom,
           enfant.surnom,
           enfant.sexe,
           enfant.cle_fiche,
           enfant.cle_pere,
           enfant.cle_mere,
           enfant.kle_dossier,
           enfant.date_naissance,
           enfant.annee_deces,
           ne.ev_ind_cp,
           ne.ev_ind_ville,
           enfant.num_sosa,
           enfant.date_deces,
           deces.ev_ind_cp,
           deces.ev_ind_ville,
           enfant.annee_naissance
         FROM individu enfant
         LEFT JOIN evenements_ind ne
                ON enfant.cle_fiche = ne.ev_ind_kle_fiche and
                   ne.ev_ind_type='BIRT'
         LEFT JOIN evenements_ind deces
                ON enfant.cle_fiche = deces.ev_ind_kle_fiche and
                   deces.ev_ind_type = 'DEAT'
    where
         enfant.kle_dossier = :I_DOSSIER AND
         enfant.indi_trie_nom STARTING WITH :I_LETTRE
   ORDER BY enfant.nom,enfant.prenom
    INTO :NOM,
         :PRENOM,
         :SURNOM,
         :SEXE,
         :CLE_FICHE,
         :CLE_PERE,
         :CLE_MERE,
         :KLE_DOSSIER,
         :DATE_NAISSANCE,
         :ANNEE_DECES,
         :CP,
         :VILLE,
         :NUM_SOSA,
         :DATE_DECES,
         :CP_DECES,
         :VILLE_DECES,
         :ANNEE_NAISSANCE
    do
    suspend;
if (I_LETTRE<>'*' AND I_SEXE > 0) then /* Une lettre et sexe defini */
for
   SELECT enfant.nom,
          enfant.prenom,
          enfant.surnom,
          enfant.sexe,
          enfant.cle_fiche,
          enfant.cle_pere,
          enfant.cle_mere,
          enfant.kle_dossier,
          enfant.date_naissance,
          enfant.annee_deces,
          ne.ev_ind_cp,
          ne.ev_ind_ville,
          enfant.num_sosa,
          enfant.date_deces,
          deces.ev_ind_cp,
          deces.ev_ind_ville,
          enfant.annee_naissance
        FROM individu enfant
        LEFT JOIN evenements_ind ne
               ON enfant.cle_fiche = ne.ev_ind_kle_fiche and
                  ne.ev_ind_type = 'BIRT'
        LEFT JOIN evenements_ind deces
               ON enfant.cle_fiche = deces.ev_ind_kle_fiche and
                  deces.ev_ind_type = 'DEAT'
        where
              enfant.kle_dossier = :I_DOSSIER AND
              enfant.indi_trie_nom STARTING WITH :I_LETTRE AND
              enfant.sexe = :I_SEXE
   ORDER BY enfant.nom,enfant.prenom
   INTO :NOM,
        :PRENOM,
        :SURNOM,
        :SEXE,
        :CLE_FICHE,
        :CLE_PERE,
        :CLE_MERE,
        :KLE_DOSSIER,
        :DATE_NAISSANCE,
        :ANNEE_DECES,
        :CP,
        :VILLE,
        :NUM_SOSA,
        :DATE_DECES,
        :CP_DECES,
        :VILLE_DECES,
        :ANNEE_NAISSANCE
    do
    suspend;
if (I_LETTRE ='*' AND I_SEXE = 0) then /* Toutes lettres et tous les sexes */
    for
        SELECT enfant.nom,
               enfant.prenom,
               enfant.surnom,
               enfant.sexe,
               enfant.cle_fiche,
               enfant.cle_pere,
               enfant.cle_mere,
               enfant.kle_dossier,
               enfant.date_naissance,
               enfant.annee_deces,
               ne.ev_ind_cp,
               ne.ev_ind_ville,
               enfant.num_sosa,
               enfant.date_deces,
               deces.ev_ind_cp,
               deces.ev_ind_ville,
               enfant.annee_naissance
        FROM individu enfant
            LEFT JOIN evenements_ind ne
                   ON enfant.cle_fiche = ne.ev_ind_kle_fiche and
                      ne.ev_ind_type = 'BIRT'
            LEFT JOIN evenements_ind deces
                   ON enfant.cle_fiche = deces.ev_ind_kle_fiche and
                      deces.ev_ind_type = 'DEAT'
        where
              enfant.kle_dossier = :I_DOSSIER
        ORDER BY enfant.nom,enfant.prenom 
        INTO :NOM,
             :PRENOM,
             :SURNOM,
             :SEXE,
             :CLE_FICHE,
             :CLE_PERE,
             :CLE_MERE,
             :KLE_DOSSIER,
             :DATE_NAISSANCE,
             :ANNEE_DECES,
             :CP,
             :VILLE,
             :NUM_SOSA,
             :DATE_DECES,
             :CP_DECES,
             :VILLE_DECES,
             :ANNEE_NAISSANCE
      do
        suspend;
if (I_LETTRE='*' AND I_SEXE>0) then /* Toutes lettres et un sexe */
    for
       SELECT enfant.nom,
              enfant.prenom,
              enfant.surnom,
              enfant.sexe,
              enfant.cle_fiche,
              enfant.cle_pere,
              enfant.cle_mere,
              enfant.kle_dossier,
              enfant.date_naissance,
              enfant.annee_deces,
              ne.ev_ind_cp,
              ne.ev_ind_ville,
              enfant.num_sosa,
              enfant.date_deces,
              deces.ev_ind_cp,
              deces.ev_ind_ville,
              enfant.annee_naissance
       FROM individu enfant
           LEFT JOIN evenements_ind ne
                  ON enfant.cle_fiche = ne.ev_ind_kle_fiche and
                     ne.ev_ind_type = 'BIRT'
           LEFT JOIN evenements_ind deces
                  ON enfant.cle_fiche = deces.ev_ind_kle_fiche and
                     deces.ev_ind_type = 'DEAT'
       where
             enfant.kle_dossier = :I_DOSSIER AND
             enfant.sexe = :I_SEXE
       ORDER BY enfant.nom,enfant.prenom
       INTO :NOM,
            :PRENOM,
            :SURNOM,
            :SEXE,
            :CLE_FICHE,
            :CLE_PERE,
            :CLE_MERE,
            :KLE_DOSSIER,
            :DATE_NAISSANCE,
            :ANNEE_DECES,
            :CP,
            :VILLE,
            :NUM_SOSA,
            :DATE_DECES,
            :CP_DECES,
            :VILLE_DECES,
            :ANNEE_NAISSANCE
      do
         suspend;
end^
COMMIT WORK ^

ALTER PROCEDURE PROC_TROUVE_CHAINE_INDI (
    I_DOSSIER INTEGER,
    SNOM VARCHAR(20),
    SPRENOM VARCHAR(20))
RETURNS (
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SURNOM VARCHAR(120),
    SEXE INTEGER,
    CLE_FICHE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    KLE_DOSSIER INTEGER,
    DATE_NAISSANCE VARCHAR(100),
    ANNEE_DECES INTEGER,
    CP VARCHAR(10),
    VILLE VARCHAR(50),
    NUM_SOSA DOUBLE PRECISION,
    DATE_DECES VARCHAR(100),
    CP_DECES VARCHAR(10),
    VILLE_DECES VARCHAR(50),
    ANNEE_NAISSANCE INTEGER)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 2/07/2002
   à : 06:13:52
   Modifiée le :03/05/2007  par André utilisation de F_MAJ_SANS_ACCENT
   à : :
   par :
   Usage       :
   ---------------------------------------------------------------------------*/
   select s_out from f_maj_sans_accent(:snom) into :snom;
   select s_out from f_maj_sans_accent(:SPRENOM) into :SPRENOM;
   if (char_length(SNOM)>0 AND char_length(SPRENOM)>0) then
     for
      SELECT  enfant.nom,
              enfant.prenom,
              enfant.surnom,
              enfant.sexe,
              enfant.cle_fiche,
              enfant.cle_pere,
              enfant.cle_mere,
              enfant.kle_dossier,
              enfant.date_naissance,
              enfant.annee_deces,
              ne.ev_ind_cp,
              ne.ev_ind_ville,
              enfant.num_sosa,
              enfant.date_deces,
              deces.ev_ind_cp,
              deces.ev_ind_ville,
              enfant.annee_naissance
        FROM  individu enfant
        LEFT JOIN evenements_ind ne
                ON enfant.cle_fiche = ne.ev_ind_kle_fiche and
                   ne.ev_ind_type = 'BIRT'
        LEFT JOIN evenements_ind deces
               ON enfant.cle_fiche = deces.ev_ind_kle_fiche and
                  deces.ev_ind_type = 'DEAT'
        where enfant.kle_dossier = :I_DOSSIER and
          enfant.indi_trie_nom STARTING WITH :SNOM AND
          (select s_out from f_maj_sans_accent(enfant.prenom)) STARTING WITH :SPRENOM
        ORDER BY enfant.nom,enfant.prenom
        INTO  :NOM,
              :PRENOM,
              :SURNOM,
              :SEXE,
              :CLE_FICHE,
              :CLE_PERE,
              :CLE_MERE,
              :KLE_DOSSIER,
              :DATE_NAISSANCE,
              :ANNEE_DECES,
              :CP,
              :VILLE ,
              :NUM_SOSA,
              :DATE_DECES,
              :CP_DECES,
              :VILLE_DECES,
              :ANNEE_NAISSANCE
   do
   suspend;
   if (char_length(SNOM)>0 AND char_length(SPRENOM)=0) then
     for
      SELECT  enfant.nom,
              enfant.prenom,
              enfant.surnom,
              enfant.sexe,
              enfant.cle_fiche,
              enfant.cle_pere,
              enfant.cle_mere,
              enfant.kle_dossier,
              enfant.date_naissance,
              enfant.annee_deces,
              ne.ev_ind_cp,
              ne.ev_ind_ville,
              enfant.num_sosa,
              enfant.date_deces,
              deces.ev_ind_cp,
              deces.ev_ind_ville,
              enfant.annee_naissance
        FROM  individu enfant
        LEFT JOIN evenements_ind ne
               ON enfant.cle_fiche = ne.ev_ind_kle_fiche and
                  ne.ev_ind_type = 'BIRT'
        LEFT JOIN evenements_ind deces
               ON enfant.cle_fiche = deces.ev_ind_kle_fiche and
                  deces.ev_ind_type = 'DEAT'
        where enfant.kle_dossier = :I_DOSSIER and
              enfant.indi_trie_nom STARTING WITH :SNOM
        ORDER BY enfant.nom,enfant.prenom
        INTO  :NOM,
              :PRENOM,
              :SURNOM,
              :SEXE,
              :CLE_FICHE,
              :CLE_PERE,
              :CLE_MERE,
              :KLE_DOSSIER,
              :DATE_NAISSANCE,
              :ANNEE_DECES,
              :CP,
              :VILLE,
              :NUM_SOSA,
              :DATE_DECES,
              :CP_DECES,
              :VILLE_DECES,
              :ANNEE_NAISSANCE
   do
   suspend;
   if (char_length(SNOM)=0 AND char_length(SPRENOM)>0) then
     for
      SELECT  enfant.nom,
              enfant.prenom,
              enfant.surnom,
              enfant.sexe,
              enfant.cle_fiche,
              enfant.cle_pere,
              enfant.cle_mere,
              enfant.kle_dossier,
              enfant.date_naissance,
              enfant.annee_deces,
              ne.ev_ind_cp,
              ne.ev_ind_ville,
              enfant.num_sosa,
              enfant.date_deces,
              deces.ev_ind_cp,
              deces.ev_ind_ville,
              enfant.annee_naissance
        FROM  individu enfant
        LEFT JOIN evenements_ind ne
               ON enfant.cle_fiche = ne.ev_ind_kle_fiche and
                  ne.ev_ind_type = 'BIRT'
        LEFT JOIN evenements_ind deces
               ON enfant.cle_fiche = deces.ev_ind_kle_fiche and
                  deces.ev_ind_type = 'DEAT'
        where enfant.kle_dossier = :I_DOSSIER and
          (select s_out from f_maj_sans_accent(enfant.prenom)) STARTING WITH :SPRENOM
        ORDER BY enfant.nom,enfant.prenom
        INTO  :NOM,
              :PRENOM,
              :SURNOM,
              :SEXE,
              :CLE_FICHE,
              :CLE_PERE,
              :CLE_MERE,
              :KLE_DOSSIER,
              :DATE_NAISSANCE,
              :ANNEE_DECES,
              :CP,
              :VILLE,
              :NUM_SOSA,
              :DATE_DECES,
              :CP_DECES,
              :VILLE_DECES,
              :ANNEE_NAISSANCE
   do
   suspend;
end^
commit work^

ALTER PROCEDURE PROC_TROUVE_INDIVIDU (
    I_DOSSIER INTEGER,
    A_NOM VARCHAR(40),
    A_PRENOM VARCHAR(60),
    A_SEXE INTEGER,
    A_CP_NAISSANCE VARCHAR(10),
    A_LIEU_NAISSANCE VARCHAR(50),
    A_PAYS_NAISSANCE VARCHAR(30),
    A_CP_DECES VARCHAR(10),
    A_LIEU_DECES VARCHAR(50),
    A_PAYS_DECES VARCHAR(30),
    D_SOSA DOUBLE PRECISION,
    I_ANNEE_NAISS INTEGER,
    I_ANNEE_DECES INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SEXE INTEGER,
    DATE_NAISSANCE VARCHAR(100),
    CP_NAISSANCE VARCHAR(10),
    LIEU_NAISSANCE VARCHAR(50),
    PAYS_NAISSANCE VARCHAR(30),
    DATE_DECES VARCHAR(100),
    CP_DECES VARCHAR(10),
    LIEU_DECES VARCHAR(50),
    PAYS_DECES VARCHAR(30))
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:47:33
   Modifiée le : 03/05/2007 par André 
   à cause de majuscules accentuées dans les noms et prénoms
   par :
   Description : Cette procedure sera appelée depuis un écran de recherche multicritere, ou depuis des etats multicriteres
   Le seul argument obligatoire est le N° de dossier
   Cette procedure ramene tous les individus repondant a un crietere sur
   nom
   ou/et prenom
   ou/et Code postal naissance
   ou/et ville naissance
   ou/et code postal deces
   ou/et ville deces
   ou/et pays naissance
   ou/et pays deces
   les combinaisons possibles sont
   Cazaux-Moutou : que les Cazaux-Moutou
   Caza%         : Tous les noms commencant par Caza
   %ou           : Tous les noms finissant par ou
   %mou%         : Tous les nom contenant mou
   meme type de combinaison avec les autres criteres
   Usage       :
   ---------------------------------------------------------------------------*/
   if ((I_DOSSIER IS NULL) or (I_DOSSIER = 0)) then EXCEPTION EX_NUM_DOSSIER_MANQUANT;
   /* Affectation des variables */
   if (A_NOM IS NULL ) then A_NOM = '%';
   else select s_out from f_maj_sans_accent(:A_NOM) into :A_NOM;
   if (A_PRENOM IS NULL ) then A_PRENOM = '%';
   else select s_out from f_maj_sans_accent(:A_PRENOM) into :A_PRENOM;
   if (A_SEXE IS NULL) then A_SEXE = 3;
   if (A_CP_NAISSANCE IS NULL ) then A_CP_NAISSANCE = '%';
   else select s_out from f_maj_sans_accent(:A_CP_NAISSANCE) into :A_CP_NAISSANCE;
   if (A_LIEU_NAISSANCE IS NULL ) then A_LIEU_NAISSANCE = '%';
   else select s_out from f_maj_sans_accent(:A_LIEU_NAISSANCE) into :A_LIEU_NAISSANCE;
   if (A_PAYS_NAISSANCE IS NULL ) then A_PAYS_NAISSANCE = '%';
   else select s_out from f_maj_sans_accent(:A_PAYS_NAISSANCE) into :A_PAYS_NAISSANCE;
   if (A_CP_DECES IS NULL ) then A_CP_DECES = '%';
   else select s_out from f_maj_sans_accent(:A_CP_DECES) into :A_CP_DECES;
   if (A_LIEU_DECES IS NULL ) then A_LIEU_DECES = '%';
   else select s_out from f_maj_sans_accent(:A_LIEU_DECES) into :A_LIEU_DECES;
   if (A_PAYS_DECES IS NULL ) then A_PAYS_DECES = '%';
   else select s_out from f_maj_sans_accent(:A_PAYS_DECES) into :A_PAYS_DECES;
   if (I_ANNEE_NAISS = 0 ) then I_ANNEE_NAISS  = NULL;
   if (I_ANNEE_DECES= 0 ) then I_ANNEE_DECES  = NULL;
   if (D_SOSA > 0 ) then
     for SELECT
              i.Cle_fiche,
              i.Nom,
              i.Prenom,
              i.Sexe,
              n.ev_ind_date_writen,
              n.ev_ind_cp,
              n.ev_ind_ville,
              n.ev_ind_pays,
              d.ev_ind_date_writen,
              d.ev_ind_cp,
              d.ev_ind_ville,
              d.ev_ind_pays
         FROM  individu i
         LEFT  JOIN evenements_ind n
               ON n.ev_ind_kle_fiche=i.cle_fiche and n.ev_ind_type='BIRT'
         LEFT  JOIN evenements_ind d
                ON d.ev_ind_kle_fiche=i.cle_fiche and d.ev_ind_type='DEAT'
         WHERE i.Kle_dossier = :I_DOSSIER
           AND i.NUM_SOSA=:D_SOSA
         ORDER BY i.nom,i.prenom
         INTO 
              :CLE_FICHE,
              :NOM,
              :PRENOM,
              :SEXE,
              :DATE_NAISSANCE,
              :CP_NAISSANCE,
              :LIEU_NAISSANCE,
              :PAYS_NAISSANCE,              
              :DATE_DECES,
              :CP_DECES,
              :LIEU_DECES,
              :PAYS_DECES
     do
       suspend;
   else
     for SELECT
              i.Cle_fiche,
              i.Nom,
              i.Prenom,
              i.Sexe,
              n.ev_ind_date_writen,
              n.ev_ind_cp,
              n.ev_ind_ville,
              n.ev_ind_pays,
              d.ev_ind_date_writen,
              d.ev_ind_cp,
              d.ev_ind_ville,
              d.ev_ind_pays
         FROM  individu i
         LEFT  JOIN evenements_ind n
               ON n.ev_ind_kle_fiche=i.cle_fiche and n.ev_ind_type='BIRT'
         LEFT  JOIN evenements_ind d
                ON d.ev_ind_kle_fiche=i.cle_fiche and d.ev_ind_type='DEAT'
         WHERE
               /* Sur le N° de dossier */   
               i.Kle_dossier = :I_DOSSIER
               /* Sur le nom */
               AND i.indi_trie_nom LIKE :A_NOM
               /* Sur le Prénom */
               AND (((select s_out from f_maj_sans_accent(i.PRENOM)) LIKE :A_PRENOM AND
                  i.PRENOM IS NOT NULL)OR
                  (:A_PRENOM = '%' AND i.PRENOM IS NULL))
               /* Sur le sexe */
               AND ((i.SEXE = :A_SEXE AND i.Sexe < 3) OR
               ( i.Sexe >= 0 AND :A_SEXE = 3))
               /* Sur le code postal de naissance */
               AND (((select s_out from f_maj_sans_accent(n.ev_ind_cp)) LIKE :A_CP_NAISSANCE AND
                  n.ev_ind_cp IS NOT NULL) or
                  (:A_CP_NAISSANCE = '%' AND n.ev_ind_cp IS NULL))
               /* Sur la ville de naissance */
               AND (((select s_out from f_maj_sans_accent(n.ev_ind_ville)) LIKE :A_LIEU_NAISSANCE AND
                  n.ev_ind_ville IS NOT NULL) or
                  (:A_LIEU_NAISSANCE = '%' AND n.ev_ind_ville IS NULL))
               /* Sur le Pays de Naissance */
               AND (((select s_out from f_maj_sans_accent(n.ev_ind_pays)) LIKE :A_PAYS_NAISSANCE AND
                  n.ev_ind_pays IS NOT NULL) OR
                  (:A_PAYS_NAISSANCE = '%' AND n.ev_ind_pays IS NULL))
               /* Sur le code postal de Décès */
               AND (((select s_out from f_maj_sans_accent(d.ev_ind_cp)) LIKE :A_CP_DECES AND
                  d.ev_ind_cp IS NOT NULL) OR
                  (:A_CP_DECES = '%' AND d.ev_ind_cp IS NULL))
               /* Sur la ville de Décès */
               AND (((select s_out from f_maj_sans_accent(d.ev_ind_ville)) LIKE :A_LIEU_DECES AND
                  d.ev_ind_ville IS NOT NULL) OR
                  (:A_LIEU_DECES = '%' AND d.ev_ind_ville IS NULL))
               /* Sur le pays de Décès */
               AND (((select s_out from f_maj_sans_accent(d.ev_ind_pays)) LIKE :A_PAYS_DECES AND
                  d.ev_ind_pays IS NOT NULL ) OR
                  (:A_PAYS_DECES = '%' AND d.ev_ind_pays IS NULL))
               /* Sur l annee de naissance */
               AND ((i.annee_naissance = :I_ANNEE_NAISS AND
                     i.annee_naissance IS NOT NULL)OR
                     (:I_ANNEE_NAISS IS NULL ))
                /* Sur l annee de deces */
               AND ((i.annee_deces = :I_ANNEE_DECES AND
                     i.annee_DECES IS NOT NULL)OR
                  (:I_ANNEE_DECES IS NULL ))
         ORDER BY i.nom,i.prenom
         INTO 
              :CLE_FICHE,
              :NOM,
              :PRENOM,
              :SEXE,
              :DATE_NAISSANCE,
              :CP_NAISSANCE,
              :LIEU_NAISSANCE,
              :PAYS_NAISSANCE,              
              :DATE_DECES,
              :CP_DECES,
              :LIEU_DECES,
              :PAYS_DECES
     do
       suspend;
end^
commit^

alter PROCEDURE PROC_TROUVE_IND_PAR_LETTRE (
    A_LETTRE VARCHAR(1),
    I_DOSSIER INTEGER)
RETURNS (
    NOM VARCHAR(40))
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
commit^

execute procedure proc_after_import(0,0)^
commit^

alter PROCEDURE PROC_ORPHELINS (
    IDOSSIER INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER)
AS
/*rectifiée par André le 30/12/2006*/
BEGIN
  FOR
    SELECT i.CLE_FICHE,
           i.NOM,
           i.PRENOM,
           i.DATE_NAISSANCE,
           i.DATE_DECES,
           i.SEXE
    FROM INDIVIDU i
    WHERE i.KLE_DOSSIER = :IDOSSIER
      and i.CLE_PERE IS NULL
      and i.CLE_MERE IS NULL
      and not exists (select * from individu where cle_pere=i.cle_fiche
                                                or cle_mere=i.cle_fiche)
      and not exists (select * from T_UNION where union_mari=i.cle_fiche
                                               or union_femme=i.cle_fiche)
      and not exists (select * from T_ASSOCIATIONS
                       where assoc_kle_associe=i.cle_fiche)
    ORDER BY i.NOM, i.PRENOM
    INTO
      :CLE_FICHE,
      :NOM,
      :PRENOM,
      :DATE_NAISSANCE,
      :DATE_DECES,
      :SEXE
  DO
    SUSPEND;
END^
commit^

alter PROCEDURE PROC_RENUM_SOSA (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_DOSSIER INTEGER)
AS
begin
   exit;
end^
commit^

alter PROCEDURE PROC_TQ_ASCENDANCE (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_PARQUI INTEGER,
    I_MODE INTEGER)
AS
begin
exit;
end^
commit^

alter PROCEDURE PROC_TQ_DESCENDANCE (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_MODE INTEGER)
AS
begin
exit;
end^
commit^

alter PROCEDURE PROC_COMPTE_ONGLETS (
    IDOSSIER INTEGER,
    ICLEF INTEGER)
RETURNS (
    COMBIEN INTEGER,
    TITRE VARCHAR(5))
AS
BEGIN
   FOR
    select count(e.EV_FAM_CLEF),'UNION'
           from INDIVIDU i
             inner join T_UNION u on (i.SEXE=1 and u.UNION_MARI=:ICLEF)
                                  or (i.SEXE=2 and u.UNION_FEMME=:ICLEF)
             inner join EVENEMENTS_FAM e on e.EV_FAM_KLE_FAMILLE=u.UNION_CLEF
           where i.CLE_FICHE=:ICLEF
    UNION
    select Count(*),'MEDIA'
       FROM MEDIA_POINTEURS
       WHERE MP_CLE_INDIVIDU=:ICLEF
    UNION
    select Count(*),'ADRES'
    from ADRESSES_IND
    WHERE ADR_KLE_IND=:ICLEF
    UNION
    select
          (select count(*) from t_union u
                            inner join evenements_fam e
                               on e.ev_fam_kle_famille=u.union_clef
                              and e.ev_fam_acte=1
                            inner join ref_evenements r
                               on r.ref_eve_lib_court=e.ev_fam_type
                              and r.ref_eve_visible=1
                            where :iclef in (u.union_mari,u.union_femme))
         +(select count(*) from evenements_ind e
                            inner join ref_evenements r
                               on r.ref_eve_lib_court=e.ev_ind_type
                              and r.ref_eve_visible=1
                            where e.ev_ind_acte=1 and e.ev_ind_kle_fiche=:iclef)
         ,'ACTES'
    from rdb$database
    INTO
      :COMBIEN,
      :TITRE
  DO
  BEGIN
    SUSPEND;
  END
END^
commit^

alter PROCEDURE PROC_PURGE_IMPORT_GEDCOM (
    I_CLEF INTEGER,
    I_MODE INTEGER)
RETURNS (
    INFO VARCHAR(50))
AS
DECLARE VARIABLE I_INDIV INTEGER;
DECLARE VARIABLE I_IND INTEGER;
DECLARE VARIABLE I_COUNT INTEGER;
DECLARE VARIABLE I_DOSSIER INTEGER;
DECLARE VARIABLE I INTEGER;
begin
/*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 003/03/2006
   Modifiée le 05/03/2006 par André. 28/07/2006 ajout mode 3
   17/01/2007 liaison des "importés" étendue au delà des liens directs
   Description : permet de purger la base d un import gedcom selectionné
   Usage       :I_MODE=1 pour supprimer les éléments de l'importation I_CLEF
                       2 pour ne garder dans le dossier que ces éléments
                       3 pour effacer les traces de l'import
---------------------------------------------------------------------------*/
  IF (I_MODE=3) THEN
  BEGIN
    UPDATE INDIVIDU SET ID_IMPORT_GEDCOM=NULL WHERE ID_IMPORT_GEDCOM=:I_CLEF;
    UPDATE EVENEMENTS_FAM SET ID_IMPORT_GEDCOM=NULL WHERE ID_IMPORT_GEDCOM=:I_CLEF;
    UPDATE MULTIMEDIA SET ID_IMPORT_GEDCOM=NULL WHERE ID_IMPORT_GEDCOM=:I_CLEF;
    delete from t_import_gedcom where ig_id=:I_CLEF;
    INFO='Traces de l''importation supprimées';
    SUSPEND;
    EXIT;
  END
  SELECT COUNT(DISTINCT KLE_DOSSIER) FROM INDIVIDU
         WHERE ID_IMPORT_GEDCOM=:I_CLEF
         INTO :I_COUNT;
  IF (I_COUNT>1) THEN
    BEGIN
      INFO='Plusieurs dossiers dans le groupe';
      SUSPEND;
      EXIT;
    END
  DELETE FROM TQ_ID; --création d'une table temporaire des associations dans les 2 sens
  FOR SELECT a.ASSOC_KLE_IND,a.ASSOC_KLE_ASSOCIE FROM T_ASSOCIATIONS a
          WHERE a.ASSOC_TABLE='I'
            AND a.ASSOC_KLE_IND>0
            AND a.ASSOC_KLE_ASSOCIE>0
            AND a.ASSOC_KLE_ASSOCIE NOT IN (SELECT "ID2" FROM TQ_ID WHERE "ID1"=a.ASSOC_KLE_IND)
          INTO :I_IND,:I_INDIV
        DO
        BEGIN
          INSERT INTO tq_id ("ID1","ID2") VALUES(:I_IND,:I_INDIV);
          IF (I_IND<>I_INDIV) THEN
            INSERT INTO tq_id ("ID1","ID2") VALUES(:I_INDIV , :I_IND);
        END
  FOR SELECT a.ASSOC_KLE_ASSOCIE,u.UNION_MARI FROM T_ASSOCIATIONS a
               INNER JOIN evenements_fam e ON e.ev_fam_clef=a.ASSOC_EVENEMENT
               INNER JOIN T_UNION u ON u.UNION_CLEF=e.ev_fam_kle_famille
               WHERE a.assoc_table='U'
                 AND u.UNION_MARI>0
                 AND a.ASSOC_KLE_ASSOCIE>0
                 AND a.ASSOC_KLE_ASSOCIE NOT IN (SELECT "ID2" FROM tq_id WHERE "ID1"=u.UNION_MARI)
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
                 AND a.ASSOC_KLE_ASSOCIE NOT IN (SELECT "ID2" FROM tq_id WHERE "ID1"=u.UNION_FEMME)
               INTO :i_ind,:i_indiv
        DO
        BEGIN
          INSERT INTO tq_id ("ID1","ID2") VALUES(:I_IND,:I_INDIV);
          IF (I_IND<>I_INDIV) THEN
            INSERT INTO tq_id ("ID1","ID2") VALUES(:I_INDIV,:I_IND);
        END
  DELETE FROM TQ_ASCENDANCE;
  IF (I_MODE=1) THEN  --suppression des enregistrements
    begin
      INSERT INTO TQ_ASCENDANCE (TQ_CLE_FICHE,TQ_SOSA)
        select CLE_FICHE,0 from individu WHERE ID_IMPORT_GEDCOM=:I_CLEF;
      select count(*) from tq_ascendance into :i;
      i_count=i+1;
      while (i<i_count) do
      begin
        i_count=i;
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
        --ne pas supprimer s'il est père ou mère d'un individu hors importation
        and EXISTS (SELECT * FROM INDIVIDU i
                     WHERE (i.CLE_PERE=tq.TQ_CLE_FICHE or i.CLE_MERE=tq.TQ_CLE_FICHE)
                       AND (i.ID_IMPORT_GEDCOM<>:I_CLEF OR i.ID_IMPORT_GEDCOM IS NULL
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
         --ne pas supprimer s'il est marié à une femme hors importation
         and EXISTS (SELECT * FROM INDIVIDU i,
                                  T_UNION u
                    WHERE u.UNION_MARI=tq.TQ_CLE_FICHE
                      and i.CLE_FICHE=u.UNION_FEMME
                      AND (i.ID_IMPORT_GEDCOM<>:I_CLEF OR i.ID_IMPORT_GEDCOM IS NULL
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
         --ne pas supprimer s'il est marié à un mari hors importation
         and EXISTS (SELECT * FROM INDIVIDU i,
                                  T_UNION u
                    WHERE u.UNION_FEMME=tq.TQ_CLE_FICHE
                      and i.CLE_FICHE=u.UNION_MARI
                      AND (i.ID_IMPORT_GEDCOM<>:I_CLEF OR i.ID_IMPORT_GEDCOM IS NULL
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
         --ne pas supprimer son père est un individu hors importation
         and EXISTS (SELECT * FROM INDIVIDU i,
                                  INDIVIDU e
                     WHERE e.CLE_FICHE=tq.TQ_CLE_FICHE
                       and i.CLE_FICHE=e.CLE_PERE
                       and (i.ID_IMPORT_GEDCOM<>:I_CLEF OR i.ID_IMPORT_GEDCOM IS NULL
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
         --ne pas supprimer sa mère est un individu hors importation
         and EXISTS (SELECT * FROM INDIVIDU i,
                                  INDIVIDU e
                     WHERE e.CLE_FICHE=tq.TQ_CLE_FICHE
                       and i.CLE_FICHE=e.CLE_MERE
                       and (i.ID_IMPORT_GEDCOM<>:I_CLEF OR i.ID_IMPORT_GEDCOM IS NULL
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
         --ne pas supprimer s'il est associé à un individu hors importation
         and EXISTS (SELECT * FROM INDIVIDU i
                    INNER JOIN TQ_ID t ON t.ID2=i.CLE_FICHE
                    WHERE t.ID1=tq.TQ_CLE_FICHE
                      AND (i.ID_IMPORT_GEDCOM<>:I_CLEF OR i.ID_IMPORT_GEDCOM IS NULL
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        select count(*) from tq_ascendance where tq_sosa=0 into :i;
      end
      delete from tq_ascendance where tq_sosa=1;
    end
  ELSE  --I_MODE=2 élagage
    begin
      SELECT DISTINCT KLE_DOSSIER FROM INDIVIDU
         WHERE ID_IMPORT_GEDCOM=:I_CLEF
         INTO :I_DOSSIER;
      INSERT INTO TQ_ASCENDANCE (TQ_CLE_FICHE,TQ_SOSA)
      SELECT CLE_FICHE,0 FROM INDIVIDU
       WHERE KLE_DOSSIER=:I_DOSSIER
         AND (ID_IMPORT_GEDCOM<>:I_CLEF OR ID_IMPORT_GEDCOM IS NULL);
      select count(*) from tq_ascendance into :i;
      i_count=i+1;
      while (i<i_count) do
      begin
        i_count=i;
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
        --ne pas supprimer s'il est père ou mère d'un individu de l'importation
        and EXISTS (SELECT * FROM INDIVIDU i
                     WHERE (i.CLE_PERE=tq.TQ_CLE_FICHE or i.CLE_MERE=tq.TQ_CLE_FICHE)
                       AND (i.ID_IMPORT_GEDCOM=:I_CLEF
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
         --ne pas supprimer sa femme est un individu de l'importation
         and EXISTS (SELECT * FROM T_UNION u,
                                  INDIVIDU i
                    WHERE u.UNION_MARI=tq.TQ_CLE_FICHE
                      and i.CLE_FICHE=u.UNION_FEMME
                      AND (i.ID_IMPORT_GEDCOM=:I_CLEF
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
         --ne pas supprimer son mari est un individu de l'importation
         and EXISTS (SELECT * FROM T_UNION u,
                                  INDIVIDU i
                    WHERE u.UNION_FEMME=tq.TQ_CLE_FICHE
                      and i.CLE_FICHE=u.UNION_MARI
                      AND (i.ID_IMPORT_GEDCOM=:I_CLEF
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
         --ne pas supprimer son père est un individu de l'importation
         and EXISTS (SELECT * FROM INDIVIDU i,
                                  INDIVIDU e
                     WHERE e.CLE_FICHE=tq.TQ_CLE_FICHE
                       and i.CLE_FICHE=e.CLE_PERE
                       and (i.ID_IMPORT_GEDCOM=:I_CLEF
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
         --ne pas supprimer sa mère est un individu de l'importation
         and EXISTS (SELECT * FROM INDIVIDU i,
                                  INDIVIDU e
                     WHERE e.CLE_FICHE=tq.TQ_CLE_FICHE
                       and i.CLE_FICHE=e.CLE_MERE
                       and (i.ID_IMPORT_GEDCOM=:I_CLEF
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        UPDATE TQ_ASCENDANCE tq set TQ_SOSA=1
        where TQ_SOSA=0
         --ne pas supprimer s'il est associé à un individu de l'importation
         and EXISTS (SELECT * FROM INDIVIDU i
                    INNER JOIN TQ_ID t ON t.ID2=i.CLE_FICHE
                    WHERE t.ID1=tq.TQ_CLE_FICHE
                      AND (i.ID_IMPORT_GEDCOM=:I_CLEF
                            or exists (select * from tq_ascendance where TQ_SOSA=1
                                                          and tq_cle_fiche=i.cle_fiche)));
        select count(*) from tq_ascendance where tq_sosa=0 into :i;
      end
      delete from tq_ascendance where tq_sosa=1;
    end
  DELETE FROM TQ_ID;
  SELECT CAST(COUNT(TQ_CLE_FICHE) AS VARCHAR(20))||' individus supprimés' FROM TQ_ASCENDANCE
      INTO :INFO;
  DELETE FROM INDIVIDU i WHERE exists (SELECT * FROM TQ_ASCENDANCE
                                    where TQ_CLE_FICHE=i.CLE_FICHE);
  UPDATE INDIVIDU i SET i.CLE_PERE=NULL WHERE exists (SELECT * FROM TQ_ASCENDANCE
                                                      where TQ_CLE_FICHE=i.CLE_PERE);
  UPDATE INDIVIDU i SET i.CLE_MERE=NULL WHERE exists (SELECT * FROM TQ_ASCENDANCE
                                                      where TQ_CLE_FICHE=i.CLE_MERE);
  DELETE FROM ADRESSES_IND a WHERE exists (SELECT * FROM TQ_ASCENDANCE
                                           where TQ_CLE_FICHE=a.ADR_KLE_IND);
  DELETE FROM EVENEMENTS_IND e WHERE exists (SELECT * FROM TQ_ASCENDANCE
                                             where TQ_CLE_FICHE=e.EV_IND_KLE_FICHE);
  UPDATE T_UNION u SET u.UNION_MARI=NULL WHERE exists (SELECT * FROM TQ_ASCENDANCE
                                                       where TQ_CLE_FICHE=u.UNION_MARI);
  UPDATE T_UNION u SET u.UNION_FEMME=NULL WHERE exists (SELECT * FROM TQ_ASCENDANCE
                                                       where TQ_CLE_FICHE=u.UNION_FEMME);
  DELETE FROM T_UNION WHERE UNION_MARI IS NULL AND UNION_FEMME IS NULL;
  DELETE FROM T_UNION t WHERE (t.UNION_MARI IS NULL AND NOT EXISTS (SELECT * FROM INDIVIDU
                               WHERE CLE_MERE=t.UNION_FEMME))
                           OR (t.UNION_FEMME IS NULL AND NOT EXISTS (SELECT * FROM INDIVIDU
                               WHERE CLE_PERE=t.UNION_MARI));
  DELETE FROM EVENEMENTS_FAM e WHERE exists (SELECT * FROM T_UNION
                                             WHERE UNION_CLEF=e.EV_FAM_KLE_FAMILLE
                                               and (UNION_MARI IS NULL
                                                OR UNION_FEMME IS NULL));
  DELETE FROM MEDIA_POINTEURS mp WHERE NOT exists (SELECT * FROM INDIVIDU
                                                where cle_fiche=mp.MP_CLE_INDIVIDU);
  DELETE FROM TQ_ASCENDANCE;
  IF (I_MODE=1) THEN  --suppression des enregistrements multimédia
    DELETE FROM MULTIMEDIA m WHERE m.ID_IMPORT_GEDCOM=:I_CLEF
                             AND NOT EXISTS (SELECT * FROM MEDIA_POINTEURS
                                             WHERE MP_MEDIA=m.MULTI_CLEF);
  ELSE  --I_MODE=2
    DELETE FROM MULTIMEDIA m WHERE MULTI_DOSSIER=:I_DOSSIER
                               AND (m.ID_IMPORT_GEDCOM<>:I_CLEF OR m.ID_IMPORT_GEDCOM IS NULL)
                               AND NOT EXISTS (SELECT * FROM MEDIA_POINTEURS
                                             WHERE MP_MEDIA=m.MULTI_CLEF);
  SUSPEND;
End^
commit^
--remise à jour du champ DECEDE
update individu i set i.decede=iif(exists (select * from evenements_ind
                                       where ev_ind_kle_fiche=i.cle_fiche
                                         and ev_ind_type in('DEAT','BURI'))
                                    ,1,null)^
commit^

alter PROCEDURE PROC_VIDE_TABLES_REF (
    I_CLEF INTEGER)
AS
DECLARE VARIABLE I INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 21:29:25
   Modifiée le :
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
  if ( I_CLEF = 1 ) then 
  begin
      /* Les villes, pays, regions depts */
      DELETE FROM REF_PAYS;
      DELETE FROM REF_REGION;
      DELETE FROM REF_DEPARTEMENTS;
      DELETE FROM REF_CP_VILLE;
      /* Les autres tables de ref */
      DELETE FROM ref_associations;
      DELETE FROM ref_evenements;
      DELETE FROM ref_filiation;
      DELETE FROM ref_particules;
      DELETE FROM ref_prefixes;
      DELETE FROM ref_raccourcis;
      DELETE FROM ref_recherche;
      DELETE FROM ref_rela_temoins;
      DELETE FROM ref_religion;
      DELETE FROM ref_token_date;
      DELETE FROM ref_type_union;
      DELETE FROM ref_histoire;
      i = gen_id(GEN_REF_PAYS,         -gen_id(GEN_REF_PAYS, 0));
      i = gen_id(GEN_REF_REGION,       -gen_id(GEN_REF_REGION, 0));
      i = gen_id(GEN_REF_DEPARTEMENTS, -gen_id(GEN_REF_DEPARTEMENTS, 0));
      i = gen_id(GEN_REF_CP_VILLE,     -gen_id(GEN_REF_CP_VILLE, 0));
      i = gen_id(gen_ref_assoc_clef, -gen_id(gen_ref_assoc_clef, 0));
      i = gen_id(gen_ref_evenements, -gen_id(gen_ref_evenements, 0));
      i = gen_id(gen_ref_particules, -gen_id(gen_ref_particules, 0));
      i = gen_id(GEN_REF_prefixes,   -gen_id(GEN_REF_prefixes, 0));
      i = gen_id(gen_ref_raccourcis, -gen_id(gen_ref_raccourcis, 0));
      i = gen_id(gen_ref_recherche,  -gen_id(gen_ref_recherche, 0));
      i = gen_id(gen_ref_rela_clef,  -gen_id(gen_ref_rela_clef, 0));
      i = gen_id(gen_ref_religions,  -gen_id(gen_ref_religions, 0));
      i = gen_id(gen_token_date,     -gen_id(gen_token_date, 0));
      i = gen_id(gen_reli_clef,      -gen_id(gen_reli_clef, 0));
      i = gen_id(gen_ref_tu_clef,    -gen_id(gen_ref_tu_clef, 0));
      i = gen_id(gen_ref_histoire,    -gen_id(gen_ref_histoire, 0));
  end
end^
commit^

alter PROCEDURE PROC_VIDE_HISTORIQUE 
AS
begin
  exit;
end^
commit^

/*Mise à jour des champs titre pour la majuscule en tête*/
update evenements_ind e
set e.ev_ind_titre_event=e.ev_ind_titre_event^
commit^
update evenements_fam e
set e.ev_fam_titre_event=e.ev_fam_titre_event^
commit^

alter TRIGGER TAD_EVENEMENTS_IND
ACTIVE AFTER DELETE POSITION 0
as
BEGIN
END^
commit^

alter TRIGGER EVENEMENTS_IND_AI
ACTIVE AFTER INSERT POSITION 0
as
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 01/08/2001
   à : 05:34:22
   Modifiée le : 22/03/2007 par André, maj DECEDE
   à : :
   par :
   Description : Mets a jour les dates naissance et deces de l individu
   Usage       :
   ---------------------------------------------------------------------------*/
    if (NEW.ev_ind_type in('BIRT','DEAT')) then
      EXECUTE PROCEDURE PROC_MAJ_DATE_UN_IND(
                          NEW.ev_ind_kle_fiche,
                          NEW.ev_ind_type,
                          NEW.ev_ind_date_writen,
                          NEW.ev_ind_date_year  );
    if (NEW.ev_ind_type in('BURI','CREM')) then
      update individu set decede=1
           where cle_fiche=NEW.ev_ind_kle_fiche;
end^
commit^

alter PROCEDURE PROC_TROUVE_VILLE_PAR_VILLE (
    I_VILLE VARCHAR(50),
    I_MODE INTEGER)
RETURNS (
    CODE VARCHAR(8),
    VILLE VARCHAR(50),
    TEL VARCHAR(2),
    DEPARTEMENT VARCHAR(30),
    REGION VARCHAR(30),
    PAYS VARCHAR(30),
    CLEF INTEGER,
    CP_PREFIXE VARCHAR(4),
    CP_DEPT INTEGER,
    CP_REGION INTEGER,
    CP_PAYS INTEGER,
    CP_INSEE VARCHAR(6),
    CP_HABITANTS DOUBLE PRECISION,
    CP_DENSITE DOUBLE PRECISION,
    CP_DIVERS VARCHAR(90),
    CP_LONGITUDE DOUBLE PRECISION,
    CP_LATITUDE DOUBLE PRECISION,
    CP_NOM_HABITANTS VARCHAR(50))
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:50:02
   Modifiée le :06/08/2006 par André utilisation CP_VILLE_MAJ
   15/05/2007 ajout CP_NOM_HABITANTS
   Description : Cette procedure permets de remonter
   Code
   Ville
   L indicatif telephonique
   Departement
   Region
   Pays
   pour une ville
   Usage       :
   ---------------------------------------------------------------------------*/
  select s_out from f_maj_sans_accent(:I_VILLE) into :i_ville;
  if (:I_MODE = 0) then
     for
      SELECT  VILLE.CP_CP,
              VILLE.CP_VILLE,
              DEPT.RDP_TEL,
              DEPT.RDP_LIBELLE,
              REGION.RRG_LIBELLE,
              PAYS.RPA_LIBELLE,
              VILLE.CP_CODE,
              VILLE.CP_PREFIXE,
              VILLE.CP_DEPT,
              VILLE.CP_REGION,
              VILLE.CP_PAYS,
              VILLE.CP_INSEE,
              VILLE.CP_HABITANTS,
              VILLE.CP_DENSITE,
              VILLE.CP_DIVERS,
              VILLE.CP_LONGITUDE,
              VILLE.CP_LATITUDE,
              ville.cp_nom_habitants
        FROM  REF_CP_VILLE VILLE
        LEFT  JOIN REF_DEPARTEMENTS DEPT
             ON DEPT.RDP_CODE = VILLE.CP_DEPT
        LEFT JOIN REF_REGION REGION
             ON REGION.RRG_CODE = VILLE.CP_REGION
        LEFT JOIN REF_PAYS PAYS
             ON PAYS.RPA_CODE = VILLE.CP_PAYS
        WHERE VILLE.CP_VILLE_MAJ STARTING WITH :I_VILLE
        ORDER BY VILLE.CP_VILLE_MAJ,ville.cp_insee,ville.cp_cp
        INTO :CODE,
             :VILLE,
             :TEL,
             :DEPARTEMENT,
             :REGION,
             :PAYS,
             :CLEF,
             :CP_PREFIXE,
             :CP_DEPT,
             :CP_REGION,
             :CP_PAYS,
             :CP_INSEE,
             :CP_HABITANTS,
             :CP_DENSITE,
             :CP_DIVERS,
             :CP_LONGITUDE,
             :CP_LATITUDE,
             :cp_nom_habitants
     do
     suspend;
  if (:I_MODE = 1) then
     for
         SELECT  VILLE.CP_CP,
              VILLE.CP_VILLE,
              DEPT.RDP_TEL,
              DEPT.RDP_LIBELLE,
              REGION.RRG_LIBELLE,
              PAYS.RPA_LIBELLE,
              VILLE.CP_PREFIXE,
              VILLE.CP_DEPT,
              VILLE.CP_REGION,
              VILLE.CP_PAYS,
              VILLE.CP_INSEE,
              VILLE.CP_HABITANTS,
              VILLE.CP_DENSITE,
              VILLE.CP_DIVERS,
              VILLE.CP_LONGITUDE,
              VILLE.CP_LATITUDE,
              ville.cp_nom_habitants
        FROM  REF_CP_VILLE VILLE
        LEFT  JOIN REF_DEPARTEMENTS DEPT
             ON DEPT.RDP_CODE = VILLE.CP_DEPT
        LEFT JOIN REF_REGION REGION
             ON REGION.RRG_CODE = VILLE.CP_REGION
        LEFT JOIN REF_PAYS PAYS
             ON PAYS.RPA_CODE = VILLE.CP_PAYS
        WHERE VILLE.CP_VILLE_MAJ CONTAINING :I_VILLE
        ORDER BY VILLE.CP_VILLE_MAJ,ville.cp_insee,ville.cp_cp
        INTO :CODE,
             :VILLE,
             :TEL,
             :DEPARTEMENT,
             :REGION,
             :PAYS,
             :CP_PREFIXE,
             :CP_DEPT,
             :CP_REGION,
             :CP_PAYS,
             :CP_INSEE,
             :CP_HABITANTS,
             :CP_DENSITE,
             :CP_DIVERS,
             :CP_LONGITUDE,
             :CP_LATITUDE,
             :cp_nom_habitants
    do
  suspend;
end^
commit^

alter PROCEDURE PROC_TROUVE_VILLE_PAR_INSEE (
    I_CODE VARCHAR(8))
RETURNS (
    VILLE VARCHAR(50),
    TEL VARCHAR(2),
    DEPARTEMENT VARCHAR(30),
    REGION VARCHAR(30),
    PAYS VARCHAR(30),
    CODE VARCHAR(8),
    CLEF INTEGER,
    CP_PREFIXE VARCHAR(4),
    CP_DEPT INTEGER,
    CP_REGION INTEGER,
    CP_PAYS INTEGER,
    CP_INSEE VARCHAR(6),
    CP_HABITANTS DOUBLE PRECISION,
    CP_DENSITE DOUBLE PRECISION,
    CP_DIVERS VARCHAR(90),
    CP_LONGITUDE DOUBLE PRECISION,
    CP_LATITUDE DOUBLE PRECISION,
    CP_NOM_HABITANTS VARCHAR(50))
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:49:32
   Modifiée le :15/05/2007 par André, ajout CP_NOM_HABITANTS
   à : :
   par :
   Description : Cette procedure permets de remonter
   la
   Ville
   L indicatif telephonique
   Departement
   Region
   Pays
   pour un code postal
   Usage       :
   ---------------------------------------------------------------------------*/
 for
      SELECT  VILLE.CP_VILLE,
              DEPT.RDP_TEL,
              DEPT.RDP_LIBELLE,
              REGION.RRG_LIBELLE,
              PAYS.RPA_LIBELLE,
              VILLE.CP_CP,
              VILLE.CP_CODE,
              VILLE.CP_PREFIXE,
              VILLE.CP_DEPT,
              VILLE.CP_REGION,
              VILLE.CP_PAYS,
              VILLE.CP_INSEE,
              VILLE.CP_HABITANTS,
              VILLE.CP_DENSITE,
              VILLE.CP_DIVERS,
              VILLE.CP_LONGITUDE,
              VILLE.CP_LATITUDE,
              ville.cp_nom_habitants
        FROM  REF_CP_VILLE VILLE
        LEFT  JOIN REF_DEPARTEMENTS DEPT
             ON DEPT.RDP_CODE = VILLE.CP_DEPT
        LEFT JOIN REF_REGION REGION
             ON REGION.RRG_CODE = DEPT.RRG_CODE
        LEFT JOIN REF_PAYS PAYS
             ON PAYS.RPA_CODE = DEPT.RDP_PAYS
        WHERE (VILLE.CP_INSEE STARTING WITH :I_CODE)
        INTO
             :VILLE,
             :TEL,
             :DEPARTEMENT,
             :REGION,
             :PAYS,
             :CODE,
             :CLEF,
             :CP_PREFIXE,
             :CP_DEPT,
             :CP_REGION,
             :CP_PAYS,
             :CP_INSEE,
             :CP_HABITANTS,
             :CP_DENSITE,
             :CP_DIVERS,
             :CP_LONGITUDE,
             :CP_LATITUDE,
             :cp_nom_habitants
  do
  suspend;
end^
commit^

alter PROCEDURE PROC_TROUVE_VILLE_PAR_CP (
    I_CODE VARCHAR(8))
RETURNS (
    VILLE VARCHAR(50),
    TEL VARCHAR(2),
    DEPARTEMENT VARCHAR(30),
    REGION VARCHAR(30),
    PAYS VARCHAR(30),
    CODE VARCHAR(8),
    CLEF INTEGER,
    CP_PREFIXE VARCHAR(4),
    CP_DEPT INTEGER,
    CP_REGION INTEGER,
    CP_PAYS INTEGER,
    CP_INSEE VARCHAR(6),
    CP_HABITANTS DOUBLE PRECISION,
    CP_DENSITE DOUBLE PRECISION,
    CP_DIVERS VARCHAR(90),
    CP_LONGITUDE DOUBLE PRECISION,
    CP_LATITUDE DOUBLE PRECISION,
    CP_NOM_HABITANTS VARCHAR(50))
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:49:32
   Modifiée le :15/05/2007 par André, ajout CP_NOM_HABITANTS
   à : :
   par :
   Description : Cette procedure permets de remonter
   la
   Ville
   L indicatif telephonique
   Departement
   Region
   Pays
   pour un code postal
   Usage       :
   ---------------------------------------------------------------------------*/
 for
      SELECT  VILLE.CP_VILLE,
              DEPT.RDP_TEL,
              DEPT.RDP_LIBELLE,
              REGION.RRG_LIBELLE,
              PAYS.RPA_LIBELLE,
              VILLE.CP_CP,
              VILLE.CP_CODE,
              VILLE.CP_PREFIXE,
              VILLE.CP_DEPT,
              VILLE.CP_REGION,
              VILLE.CP_PAYS,
              VILLE.CP_INSEE,
              VILLE.CP_HABITANTS,
              VILLE.CP_DENSITE,
              VILLE.CP_DIVERS,
              VILLE.CP_LONGITUDE,
              VILLE.CP_LATITUDE,
              ville.cp_nom_habitants
        FROM  REF_CP_VILLE VILLE
        LEFT JOIN REF_DEPARTEMENTS DEPT
             ON DEPT.RDP_CODE = VILLE.CP_DEPT
        LEFT JOIN REF_REGION REGION
             ON REGION.RRG_CODE = VILLE.CP_REGION
        LEFT JOIN REF_PAYS PAYS
             ON PAYS.RPA_CODE = VILLE.CP_PAYS
        WHERE (UPPER(VILLE.CP_CP) STARTING WITH UPPER(:I_CODE))
        INTO
             :VILLE,
             :TEL,
             :DEPARTEMENT,
             :REGION,
             :PAYS,
             :CODE,
             :CLEF,
             :CP_PREFIXE,
             :CP_DEPT,
             :CP_REGION,
             :CP_PAYS,
             :CP_INSEE,
             :CP_HABITANTS,
             :CP_DENSITE,
             :CP_DIVERS,
             :CP_LONGITUDE,
             :CP_LATITUDE,
             :cp_nom_habitants
  do
  suspend;
end^
commit^

alter PROCEDURE PROC_COPIE_DOSSIER (
    DOSSIERS INTEGER,
    I_DOSSIERC INTEGER)
RETURNS (
    DOSSIERC INTEGER)
AS
DECLARE VARIABLE IG_ID INTEGER;
DECLARE VARIABLE OLD_ID INTEGER;
DECLARE VARIABLE NEW_ID INTEGER;
DECLARE VARIABLE SOURCE_PAGE VARCHAR(248);
DECLARE VARIABLE EVEN VARCHAR(15);
DECLARE VARIABLE EVEN_ROLE VARCHAR(25);
DECLARE VARIABLE DATA_EVEN VARCHAR(90);
DECLARE VARIABLE DATA_EVEN_PERIOD VARCHAR(35);
DECLARE VARIABLE DATA_EVEN_PLAC VARCHAR(120);
DECLARE VARIABLE DATA_AGNC VARCHAR(120);
DECLARE VARIABLE QUAY INTEGER;
DECLARE VARIABLE AUTH BLOB SUB_TYPE 1 SEGMENT SIZE 0;
DECLARE VARIABLE TITL BLOB SUB_TYPE 1 SEGMENT SIZE 0;
DECLARE VARIABLE ABR VARCHAR(60);
DECLARE VARIABLE PUBL BLOB SUB_TYPE 1 SEGMENT SIZE 0;
DECLARE VARIABLE TEXTE BLOB SUB_TYPE 1 SEGMENT SIZE 0;
DECLARE VARIABLE USER_REF BLOB SUB_TYPE 1 SEGMENT SIZE 0;
DECLARE VARIABLE RIN VARCHAR(12);
DECLARE VARIABLE CHANGE_NOTE BLOB SUB_TYPE 1 SEGMENT SIZE 0;
DECLARE VARIABLE POINT_ENR CHAR(8);
DECLARE VARIABLE I_PERE INTEGER;
DECLARE VARIABLE I_MERE INTEGER;
begin
/*Procédure créée par André le 03/06/2007
Copie un dossier DOSSIERS (dossier source) dans un autre dossier I_DOSSIERC
(dossier cible).
Si I_DOSSIERC n'existe pas, un nouveau dossier est créé.
Le code du dossier cible est retourné dans DOSSIERC.*/
  select cle_dossier from dossier
  where cle_dossier=:i_dossierc
  into :dossierc; --si n'existe pas reste null
  if (dossierc is null) then
  begin --création d'un nouveau dossier
    dossierc=gen_id(GEN_DOSSIER,1);
    insert into DOSSIER (CLE_DOSSIER
                         ,NOM_DOSSIER
                         ,DS_VERROU
                         ,DS_INFOS
                         ,DS_LAST)
                  values( :dossierc
                         ,'Copie du dossier '||:dossiers
                         ,0
                         ,'Dossier créé le '||current_date||' à:'
                          ||substring(cast(current_time as varchar(15)) from 1 for 5)
                         ,-1);
  end
  else
  begin --enregistrement comme importation
    ig_id=gen_id(T_IMPORT_GEDCOM_IG_ID_GEN,1);
    insert into T_IMPORT_GEDCOM ( IG_ID
                                 ,IG_PATH)
                          values( :ig_id
                                 ,'Copie du dossier '||:dossiers||
                                  ' dans le dossier '||:dossierc);
  end
  DELETE FROM  TQ_CONSANG; --nettoyage de la table temporaire
  insert into TQ_CONSANG (ID,INDI,DECUJUS) --correspondances individus
         select 1
               ,cle_fiche
               ,gen_id(gen_individu,1)
         from individu
         where kle_dossier=:dossiers;
  insert into INDIVIDU ( CLE_FICHE
                        ,KLE_DOSSIER
                        ,CLE_IMPORTATION
                        ,CLE_PARENTS
                        ,CLE_PERE
                        ,CLE_MERE
                        ,PREFIXE
                        ,NOM
                        ,PRENOM
                        ,SURNOM
                        ,SUFFIXE
                        ,SEXE
                        ,SOURCE
                        ,COMMENT
                        ,FILLIATION
                        ,MODIF_PAR_QUI
                        ,NCHI
                        ,NMR
                        ,CLE_FIXE
                        ,ID_IMPORT_GEDCOM)
                 select t.decujus
                       ,:dossierc
                       ,t.decujus
                       ,i.cle_parents
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
                       ,:ig_id
                 from tq_consang t
                 inner join individu i on i.cle_fiche=t.indi
                 where t.id=1;
  for select i.RDB$DB_KEY --mise à jour cle_père et cle_mere
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
  insert into TQ_CONSANG (ID,INDI,DECUJUS) --correspondances multimedia
         select 2
               ,MULTI_CLEF
               ,gen_id(GEN_MULTIMEDIA,1)
         from MULTIMEDIA
         where MULTI_DOSSIER=:dossiers;
  insert into MULTIMEDIA ( MULTI_CLEF
                          ,MULTI_INDIVIDU
                          ,MULTI_INFOS
                          ,MULTI_MEDIA
                          ,MULTI_DOSSIER
                          ,MULTI_DATE_MODIF
                          ,MULTI_MEMO
                          ,MULTI_STRETCH
                          ,MULTI_IDENTITE
                          ,MULTI_TYPE
                          ,MULTI_REDUITE
                          ,MULTI_DEVISE
                          ,MULTI_CRI
                          ,MULTI_DOCRTF
                          ,MULTI_IMAGE_RTF
                          ,MULTI_NUM_ACTE
                          ,MULTI_TYPE_ACTE
                          ,MULTI_SONS_VIDEOS
                          ,MULTI_PATH
                          ,MULTI_NOM
                          ,ID_IMPORT_GEDCOM)
                   select t.decujus
                         ,m.MULTI_INDIVIDU
                         ,m.MULTI_INFOS
                         ,m.MULTI_MEDIA
                         ,:dossierc
                         ,m.MULTI_DATE_MODIF
                         ,m.MULTI_MEMO
                         ,m.MULTI_STRETCH
                         ,m.MULTI_IDENTITE
                         ,m.MULTI_TYPE
                         ,m.MULTI_REDUITE
                         ,m.MULTI_DEVISE
                         ,m.MULTI_CRI
                         ,m.MULTI_DOCRTF
                         ,m.MULTI_IMAGE_RTF
                         ,m.MULTI_NUM_ACTE
                         ,m.MULTI_TYPE_ACTE
                         ,m.MULTI_SONS_VIDEOS
                         ,m.MULTI_PATH
                         ,m.MULTI_NOM
                         ,:ig_id
                   from tq_consang t
                   inner join multimedia m on m.multi_clef=t.indi
                   where t.id=2;
  insert into ADRESSES_IND ( ADR_CLEF
                            ,ADR_TYPE
                            ,ADR_KLE_DOSSIER
                            ,ADR_KLE_IND
                            ,ADR_ADRESSE
                            ,ADR_CP
                            ,ADR_VILLE
                            ,ADR_DEPT
                            ,ADR_REGION
                            ,ADR_PAYS
                            ,ADR_TEL
                            ,ADR_MAIL
                            ,ADR_DATE_WRITEN
                            ,ADR_INSEE
                            ,ADR_PHOTO
                            ,ADR_WEB
                            ,ADR_MEMO
                            ,ADR_SUBD
                            ,ADR_LATITUDE
                            ,ADR_LONGITUDE)
                    select gen_id(GEN_ADRESSES_IND,1)
                          ,a.ADR_TYPE
                          ,:dossierc
                          ,t.DECUJUS
                          ,a.ADR_ADRESSE
                          ,a.ADR_CP
                          ,a.ADR_VILLE
                          ,a.ADR_DEPT
                          ,a.ADR_REGION
                          ,a.ADR_PAYS
                          ,a.ADR_TEL
                          ,a.ADR_MAIL
                          ,a.ADR_DATE_WRITEN
                          ,a.ADR_INSEE
                          ,a.ADR_PHOTO
                          ,a.ADR_WEB
                          ,a.ADR_MEMO
                          ,a.ADR_SUBD
                          ,a.ADR_LATITUDE
                          ,a.ADR_LONGITUDE
                    from tq_consang t
                    inner join adresses_ind a on a.adr_kle_ind=t.indi
                    where t.id=1;
  insert into TQ_CONSANG (ID,INDI,DECUJUS) --correspondances événements individuels
         select 3
               ,e.EV_IND_CLEF
               ,gen_id(GEN_EV_IND_CLEF,1)
         from evenements_ind e
         inner join tq_consang t on t.indi=e.ev_ind_kle_fiche
         where t.id=1;
  insert into EVENEMENTS_IND ( EV_IND_CLEF
                              ,EV_IND_KLE_FICHE
                              ,EV_IND_KLE_DOSSIER
                              ,EV_IND_TYPE
                              ,EV_IND_DATE_WRITEN
                              ,EV_IND_ADRESSE
                              ,EV_IND_CP
                              ,EV_IND_VILLE
                              ,EV_IND_DEPT
                              ,EV_IND_PAYS
                              ,EV_IND_CAUSE
                              ,EV_IND_SOURCE
                              ,EV_IND_COMMENT
                              ,EV_IND_TYPEANNEE
                              ,EV_IND_DESCRIPTION
                              ,EV_IND_REGION
                              ,EV_IND_SUBD
                              ,EV_IND_ACTE
                              ,EV_IND_INSEE
                              ,EV_IND_ORDRE
                              ,EV_IND_HEURE
                              ,EV_IND_TITRE_EVENT
                              ,EV_IND_LATITUDE
                              ,EV_IND_LONGITUDE)
                       select t.decujus
                             ,(select DECUJUS from TQ_CONSANG where ID=1 AND INDI=e.EV_IND_KLE_FICHE)
                             ,:dossierc
                             ,e.EV_IND_TYPE
                             ,e.EV_IND_DATE_WRITEN
                             ,e.EV_IND_ADRESSE
                             ,e.EV_IND_CP
                             ,e.EV_IND_VILLE
                             ,e.EV_IND_DEPT
                             ,e.EV_IND_PAYS
                             ,e.EV_IND_CAUSE
                             ,e.EV_IND_SOURCE
                             ,e.EV_IND_COMMENT
                             ,e.EV_IND_TYPEANNEE
                             ,e.EV_IND_DESCRIPTION
                             ,e.EV_IND_REGION
                             ,e.EV_IND_SUBD
                             ,e.EV_IND_ACTE
                             ,e.EV_IND_INSEE
                             ,e.EV_IND_ORDRE
                             ,e.EV_IND_HEURE
                             ,e.EV_IND_TITRE_EVENT
                             ,e.EV_IND_LATITUDE
                             ,e.EV_IND_LONGITUDE
                       from  tq_consang t
                       inner join evenements_ind e on e.ev_ind_clef=t.indi
                       where t.id=3;
  insert into TQ_CONSANG (ID,INDI,DECUJUS) --correspondances unions
         select 4
               ,t.union_clef
               ,gen_id(GEN_T_UNION,1)
         from T_UNION t WHERE (t.UNION_MARI is not null
                               AND t.UNION_FEMME is not null --2 époux
                               AND exists (SELECT 0 FROM TQ_CONSANG WHERE ID=1
                                            and indi=t.UNION_MARI)
                               AND exists (SELECT 0 FROM TQ_CONSANG WHERE ID=1
                                            and indi=t.union_femme))
                           or (t.UNION_MARI is not null --pères seuls
                               AND t.UNION_FEMME is null
                               AND exists (SELECT 0 FROM TQ_CONSANG WHERE ID=1
                                            and indi=t.UNION_MARI))
                           or (t.UNION_MARI is null
                               AND t.UNION_FEMME is not null --mères seules
                               AND exists (SELECT 0 FROM TQ_CONSANG WHERE ID=1
                                            and indi=t.union_femme));
  insert into T_UNION ( UNION_CLEF
                       ,UNION_MARI
                       ,UNION_FEMME
                       ,KLE_DOSSIER
                       ,UNION_TYPE
                       ,SOURCE
                       ,COMMENT)
                select t.decujus
                      ,(select DECUJUS from TQ_CONSANG where ID=1 AND INDI=u.UNION_MARI)
                      ,(select DECUJUS from TQ_CONSANG where ID=1 AND INDI=u.UNION_FEMME)
                      ,:dossierc
                      ,u.UNION_TYPE
                      ,u.SOURCE
                      ,u.COMMENT
                from tq_consang t
                inner join t_union u on u.union_clef=t.indi
                where t.id=4;
  insert into TQ_CONSANG (ID,INDI,DECUJUS) --correspondances événements familiaux
         select 5
               ,e.EV_FAM_CLEF
               ,gen_id(GEN_EV_FAM_CLEF,1)
         from evenements_fam e
         inner join tq_consang t on t.indi=e.ev_fam_kle_famille
         where t.id=4;
  insert into EVENEMENTS_FAM ( EV_FAM_CLEF
                              ,EV_FAM_KLE_FAMILLE
                              ,EV_FAM_KLE_DOSSIER
                              ,EV_FAM_TYPE
                              ,EV_FAM_DATE_WRITEN
                              ,EV_FAM_ADRESSE
                              ,EV_FAM_CP
                              ,EV_FAM_VILLE
                              ,EV_FAM_DEPT
                              ,EV_FAM_PAYS
                              ,EV_FAM_SOURCE
                              ,EV_FAM_COMMENT
                              ,EV_FAM_REGION
                              ,EV_FAM_SUBD
                              ,EV_FAM_ACTE
                              ,EV_FAM_INSEE
                              ,EV_FAM_ORDRE
                              ,EV_FAM_HEURE
                              ,EV_FAM_TITRE_EVENT
                              ,EV_FAM_LATITUDE
                              ,EV_FAM_LONGITUDE
                              ,EV_FAM_DESCRIPTION
                              ,EV_FAM_CAUSE)
                       select t.decujus
                             ,(select DECUJUS from TQ_CONSANG where ID=4 AND INDI=e.EV_FAM_KLE_FAMILLE)
                             ,:dossierc
                             ,e.EV_FAM_TYPE
                             ,e.EV_FAM_DATE_WRITEN
                             ,e.EV_FAM_ADRESSE
                             ,e.EV_FAM_CP
                             ,e.EV_FAM_VILLE
                             ,e.EV_FAM_DEPT
                             ,e.EV_FAM_PAYS
                             ,e.EV_FAM_SOURCE
                             ,e.EV_FAM_COMMENT
                             ,e.EV_FAM_REGION
                             ,e.EV_FAM_SUBD
                             ,e.EV_FAM_ACTE
                             ,e.EV_FAM_INSEE
                             ,e.EV_FAM_ORDRE
                             ,e.EV_FAM_HEURE
                             ,e.EV_FAM_TITRE_EVENT
                             ,e.EV_FAM_LATITUDE
                             ,e.EV_FAM_LONGITUDE
                             ,e.EV_FAM_DESCRIPTION
                             ,e.EV_FAM_CAUSE
                       from tq_consang t
                       inner join evenements_fam e on e.ev_fam_clef=t.indi
                       where t.id=5;
  insert into T_ASSOCIATIONS ( ASSOC_CLEF --associés à événements individuels
                              ,ASSOC_KLE_IND
                              ,ASSOC_KLE_ASSOCIE
                              ,ASSOC_KLE_DOSSIER
                              ,ASSOC_NOTES
                              ,ASSOC_SOURCES
                              ,ASSOC_TYPE
                              ,ASSOC_EVENEMENT
                              ,ASSOC_TABLE)
                      select gen_id(gen_assoc_clef,1)
                            ,ev.ev_ind_kle_fiche
                            ,a.decujus
                            ,:dossierc
                            ,t.ASSOC_NOTES
                            ,t.ASSOC_SOURCES
                            ,t.ASSOC_TYPE
                            ,e.decujus
                            ,'I'
                      from  t_associations t
                      inner join tq_consang a on a.id=1 and a.indi=t.assoc_kle_associe
                      inner join tq_consang e on e.id=3 and e.indi=t.assoc_evenement
                      inner join evenements_ind ev on ev.ev_ind_clef=e.decujus
                      where t.assoc_table='I';
  insert into T_ASSOCIATIONS ( ASSOC_CLEF --associés à événements familiaux
                              ,ASSOC_KLE_IND
                              ,ASSOC_KLE_ASSOCIE
                              ,ASSOC_KLE_DOSSIER
                              ,ASSOC_NOTES
                              ,ASSOC_SOURCES
                              ,ASSOC_TYPE
                              ,ASSOC_EVENEMENT
                              ,ASSOC_TABLE)
                      select gen_id(gen_assoc_clef,1)
                            ,e.decujus
                            ,a.decujus
                            ,:dossierc
                            ,t.ASSOC_NOTES
                            ,t.ASSOC_SOURCES
                            ,t.ASSOC_TYPE
                            ,e.decujus
                            ,'U'
                      from  t_associations t
                      inner join tq_consang a on a.id=1 and a.indi=t.assoc_kle_associe
                      inner join tq_consang e on e.id=5 and e.indi=t.assoc_evenement
                      where t.assoc_table='U';
  for select a.id  --mise à jour Sources_record familiaux
            ,n.id
            ,a.SOURCE_PAGE
            ,a.EVEN
            ,a.EVEN_ROLE
            ,a.DATA_EVEN
            ,a.DATA_EVEN_PERIOD
            ,a.DATA_EVEN_PLAC
            ,a.DATA_AGNC
            ,a.QUAY
            ,a.AUTH
            ,a.TITL
            ,a.ABR
            ,a.PUBL
            ,a.TEXTE
            ,a.USER_REF
            ,a.RIN
            ,a.CHANGE_NOTE
  from sources_record a
  inner join tq_consang t on t.id=5 and t.indi=a.data_id
  inner join sources_record n on n.data_id=t.decujus and n.type_table='F'
  where a.kle_dossier=:dossiers and a.type_table='F'
  into :old_id
      ,:new_id
      ,:SOURCE_PAGE
      ,:EVEN
      ,:EVEN_ROLE
      ,:DATA_EVEN
      ,:DATA_EVEN_PERIOD
      ,:DATA_EVEN_PLAC
      ,:DATA_AGNC
      ,:QUAY
      ,:AUTH
      ,:TITL
      ,:ABR
      ,:PUBL
      ,:TEXTE
      ,:USER_REF
      ,:RIN
      ,:CHANGE_NOTE
  do
  begin
    insert into TQ_CONSANG (ID,INDI,DECUJUS) --correspondances Sources_record familiaux
           values(6,:old_id,:new_id);
    update SOURCES_RECORD set SOURCE_PAGE=:SOURCE_PAGE
                             ,EVEN=:EVEN
                             ,EVEN_ROLE=:EVEN_ROLE
                             ,DATA_EVEN=:DATA_EVEN
                             ,DATA_EVEN_PERIOD=:DATA_EVEN_PERIOD
                             ,DATA_EVEN_PLAC=:DATA_EVEN_PLAC
                             ,DATA_AGNC=:DATA_AGNC
                             ,QUAY=:QUAY
                             ,AUTH=:AUTH
                             ,TITL=:TITL
                             ,ABR=:ABR
                             ,PUBL=:PUBL
                             ,TEXTE=:TEXTE
                             ,USER_REF=:USER_REF
                             ,RIN=:RIN
                             ,CHANGE_NOTE=:CHANGE_NOTE
    where id=:new_id;
  end
  insert into TQ_CONSANG (ID,INDI,DECUJUS) --correspondances Sources_record individuels
         select 6
               ,s.id
               ,gen_id(SOURCES_RECORD_ID_GEN,1)
         from sources_record s
         inner join tq_consang t on t.indi=s.data_id and t.id=3
         where s.type_table='I';
  insert into SOURCES_RECORD ( ID
                              ,SOURCE_PAGE
                              ,EVEN
                              ,EVEN_ROLE
                              ,DATA_ID
                              ,DATA_EVEN
                              ,DATA_EVEN_PERIOD
                              ,DATA_EVEN_PLAC
                              ,DATA_AGNC
                              ,QUAY
                              ,AUTH
                              ,TITL
                              ,ABR
                              ,PUBL
                              ,TEXTE
                              ,USER_REF
                              ,RIN
                              ,CHANGE_DATE
                              ,CHANGE_NOTE
                              ,KLE_DOSSIER
                              ,TYPE_TABLE)
                       select t.decujus
                             ,s.SOURCE_PAGE
                             ,s.EVEN
                             ,s.EVEN_ROLE
                             ,(select DECUJUS from TQ_CONSANG where ID=3 AND INDI=s.DATA_ID)
                             ,s.DATA_EVEN
                             ,s.DATA_EVEN_PERIOD
                             ,s.DATA_EVEN_PLAC
                             ,s.DATA_AGNC
                             ,s.QUAY
                             ,s.AUTH
                             ,s.TITL
                             ,s.ABR
                             ,s.PUBL
                             ,s.TEXTE
                             ,s.USER_REF
                             ,s.RIN
                             ,'now'
                             ,s.CHANGE_NOTE
                             ,:dossierc
                             ,'I'
                        from tq_consang t
                        inner join sources_record s on s.id=t.indi and s.type_table='I'
                        where t.id=6;
  insert into MEDIA_POINTEURS (MP_CLEF --1-MEDIA_POINTEURS sur individus
                              ,MP_MEDIA
                              ,MP_CLE_INDIVIDU
                              ,MP_POINTE_SUR
                              ,MP_TABLE
                              ,MP_IDENTITE
                              ,MP_KLE_DOSSIER
                              ,MP_TYPE_IMAGE)
                      select gen_id(BIBLIO_POINTEURS_ID_GEN,1)
                            ,m.DECUJUS
                            ,i.DECUJUS
                            ,i.DECUJUS
                            ,'I'
                            ,p.MP_IDENTITE
                            ,:dossierc
                            ,'I'
                      from media_pointeurs p
                      inner join tq_consang i on i.id=1 and i.indi=p.mp_cle_individu
                      inner join tq_consang m on m.id=2 and m.indi=p.mp_media
                      where p.mp_type_image='I';
  insert into MEDIA_POINTEURS (MP_CLEF --2-MEDIA_POINTEURS sur actes d'événements individuels
                              ,MP_MEDIA
                              ,MP_CLE_INDIVIDU
                              ,MP_POINTE_SUR
                              ,MP_TABLE
                              ,MP_IDENTITE
                              ,MP_KLE_DOSSIER
                              ,MP_TYPE_IMAGE)
                      select gen_id(BIBLIO_POINTEURS_ID_GEN,1)
                            ,m.DECUJUS
                            ,i.DECUJUS
                            ,e.DECUJUS
                            ,'I'
                            ,p.MP_IDENTITE
                            ,:dossierc
                            ,'A'
                      from media_pointeurs p
                      inner join tq_consang i on i.id=1 and i.indi=p.mp_cle_individu
                      inner join tq_consang m on m.id=2 and m.indi=p.mp_media
                      inner join tq_consang e on e.id=3 and e.indi=p.mp_pointe_sur
                      where p.mp_type_image='A' and p.mp_table='I';
  insert into MEDIA_POINTEURS (MP_CLEF --3-MEDIA_POINTEURS sur actes d'événements familiaux
                              ,MP_MEDIA
                              ,MP_CLE_INDIVIDU
                              ,MP_POINTE_SUR
                              ,MP_TABLE
                              ,MP_IDENTITE
                              ,MP_KLE_DOSSIER
                              ,MP_TYPE_IMAGE)
                      select gen_id(BIBLIO_POINTEURS_ID_GEN,1)
                            ,m.DECUJUS
                            ,i.DECUJUS
                            ,e.DECUJUS
                            ,'F'
                            ,p.MP_IDENTITE
                            ,:dossierc
                            ,'A'
                      from media_pointeurs p
                      inner join tq_consang i on i.id=1 and i.indi=p.mp_cle_individu
                      inner join tq_consang m on m.id=2 and m.indi=p.mp_media
                      inner join tq_consang e on e.id=5 and e.indi=p.mp_pointe_sur
                      where p.mp_type_image='A' and p.mp_table='F';
  insert into MEDIA_POINTEURS (MP_CLEF --4-MEDIA_POINTEURS sur sources d'événements
                              ,MP_MEDIA
                              ,MP_CLE_INDIVIDU
                              ,MP_POINTE_SUR
                              ,MP_TABLE
                              ,MP_IDENTITE
                              ,MP_KLE_DOSSIER
                              ,MP_TYPE_IMAGE)
                      select gen_id(BIBLIO_POINTEURS_ID_GEN,1)
                            ,m.DECUJUS
                            ,i.DECUJUS
                            ,s.DECUJUS
                            ,'F'
                            ,p.MP_IDENTITE
                            ,:dossierc
                            ,'F'
                      from media_pointeurs p
                      inner join tq_consang i on i.id=1 and i.indi=p.mp_cle_individu
                      inner join tq_consang m on m.id=2 and m.indi=p.mp_media
                      inner join tq_consang s on s.id=6 and s.indi=p.mp_pointe_sur
                      where p.mp_type_image='F' and p.mp_table='F';
  insert into NOM_ATTACHEMENT ( id_indi
                               ,nom
                               ,nom_indi
                               ,kle_dossier)
                        select t.decujus
                              ,n.nom
                              ,i.nom
                              ,:dossierc
                         from nom_attachement n
                         inner join tq_consang t on t.id=1 and t.indi=n.id_indi
                         inner join individu i on i.cle_fiche=n.id_indi;
  DELETE FROM  TQ_CONSANG; --nettoyage de la table temporaire
  suspend;
end^
commit^

alter PROCEDURE PROC_POSITION_GEO_EVENT (
    ICLEF INTEGER)
RETURNS (
    EV_LIBELLE VARCHAR(30),
    EV_IND_CP VARCHAR(10),
    EV_IND_VILLE VARCHAR(50),
    CP_LONGITUDE NUMERIC(15,8),
    CP_LATITUDE NUMERIC(18,8))
AS
BEGIN 
    SUSPEND; 
END^
commit^

alter PROCEDURE PROC_SELECT_REF (
    A_TABLE VARCHAR(50),
    A_LANG VARCHAR(3))
RETURNS (
    LIBELLE VARCHAR(30),
    I_TYPE INTEGER)
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:31:14
   Modifiée le : 08/06/2007 par André: optimisation
   à : :
   par :
   Description : Remonte les données d 'une table de reference passee en
                 parametre en fonction de la langue
                 si la langue n'existe pas, on lance la proc de
                 duplication d items pour la nouvelle langue
   Usage       :
   ---------------------------------------------------------------------------*/
  A_TABLE = Upper(A_TABLE);
  if (A_LANG is Null) then A_LANG = 'FRA';
  if (A_TABLE = 'REF_PREFIXES' ) then
  begin
    FOR SELECT PR_LIBELLE,
               1
        FROM REF_PREFIXES
        WHERE LANGUE = :A_LANG
        ORDER BY PR_LIBELLE
        INTO :LIBELLE,
             :I_TYPE
    DO
      SUSPEND;
    if (row_count=0) then
    begin
      EXECUTE PROCEDURE PROC_INSERT_LANGUE('REF_PREFIXES','FRA',:A_LANG);
      FOR SELECT PR_LIBELLE,
                 1
        FROM REF_PREFIXES
        WHERE LANGUE = :A_LANG
        ORDER BY PR_LIBELLE
        INTO :LIBELLE,
             :I_TYPE
      DO
        SUSPEND;
    end
    exit;
  end
  if (A_TABLE = 'REF_TYPE_UNION' ) then
  begin
    FOR SELECT REF_TU_LIBELLE,
               REF_TU_CODE
        FROM REF_TYPE_UNION
        WHERE LANGUE = :A_LANG
        ORDER BY REF_TU_CODE
        INTO :LIBELLE,
             :I_TYPE
    DO
      SUSPEND;
    if (row_count=0) then
    begin
      EXECUTE PROCEDURE PROC_INSERT_LANGUE('REF_TYPE_UNION','FRA',:A_LANG);
      FOR SELECT REF_TU_LIBELLE,
                 REF_TU_CODE
          FROM REF_TYPE_UNION
          WHERE LANGUE = :A_LANG
          ORDER BY REF_TU_CODE
          INTO :LIBELLE,
               :I_TYPE
      DO
        SUSPEND;
    end
    exit;
  END
  if (A_TABLE = 'REF_RELA_TEMOINS' ) then
  begin
    FOR SELECT REF_RELA_LIBELLE,
               REF_RELA_CODE
     FROM REF_RELA_TEMOINS
     WHERE LANGUE = :A_LANG
     ORDER BY REF_RELA_LIBELLE
     INTO :LIBELLE,
          :I_TYPE
    DO
      SUSPEND;
    if (row_count=0) then
    begin
      EXECUTE PROCEDURE PROC_INSERT_LANGUE('REF_RELA_TEMOINS','FRA',:A_LANG);
      FOR SELECT REF_RELA_LIBELLE,
                 REF_RELA_CODE
          FROM REF_RELA_TEMOINS
          WHERE LANGUE = :A_LANG
          ORDER BY REF_RELA_LIBELLE
          INTO :LIBELLE,
               :I_TYPE
      DO
        SUSPEND;
    end
    exit;
  end
  if (A_TABLE = 'REF_FILIATION' ) then
  begin
    FOR SELECT FIL_LIBELLE,
               1
        FROM REF_FILIATION
        WHERE FIL_LANGUE = :A_LANG
        ORDER BY FIL_LIBELLE
        INTO :LIBELLE,
             :I_TYPE
    DO
      SUSPEND;
    if (row_count=0) then
    begin
      EXECUTE PROCEDURE PROC_INSERT_LANGUE('REF_FILIATION','FRA',:A_LANG);
      FOR SELECT FIL_LIBELLE,
                 1
        FROM REF_FILIATION
        WHERE FIL_LANGUE = :A_LANG
        ORDER BY FIL_LIBELLE
        INTO :LIBELLE,
             :I_TYPE
      DO
        SUSPEND;
    end
    exit;
  end
  if (A_TABLE = 'REF_ASSOCIATIONS' ) then
  begin
    FOR SELECT REF_ASSOC_LIBELLE,
               REF_ASSOC_TYPE
     FROM REF_ASSOCIATIONS
     WHERE LANGUE = :A_LANG
     ORDER BY REF_ASSOC_LIBELLE
     INTO :LIBELLE,
          :I_TYPE
    DO
      SUSPEND;
    if (row_count=0) then
    begin
      EXECUTE PROCEDURE PROC_INSERT_LANGUE('REF_ASSOCIATIONS','FRA',:A_LANG);
      FOR SELECT REF_ASSOC_LIBELLE,
                 REF_ASSOC_TYPE
          FROM REF_ASSOCIATIONS
          WHERE LANGUE = :A_LANG
          ORDER BY REF_ASSOC_LIBELLE
      INTO :LIBELLE,
           :I_TYPE
      DO
        SUSPEND;
    end
    exit;
  end
  if (A_TABLE = 'REF_PARTICULES' ) then
  begin
    FOR SELECT PART_LIBELLE,
               1
     FROM REF_PARTICULES
     WHERE LANGUE = :A_LANG
     ORDER BY PART_LIBELLE
     INTO :LIBELLE,
          :I_TYPE
    DO
      SUSPEND;
    if (row_count=0) then
    begin
      EXECUTE PROCEDURE PROC_INSERT_LANGUE('REF_PARTICULES','FRA',:A_LANG);
      FOR SELECT PART_LIBELLE,
                 1
         FROM REF_PARTICULES
         WHERE LANGUE = :A_LANG
         ORDER BY PART_LIBELLE
         INTO :LIBELLE,
              :I_TYPE
      DO
        SUSPEND;
    end
    exit;
  end
  if (A_TABLE = 'REF_RELIGION' ) then
  begin
    FOR SELECT RELI_LIBELLE,
               1
       FROM REF_RELIGION
       WHERE LANGUE = :A_LANG
       ORDER BY RELI_LIBELLE
       INTO :LIBELLE,
            :I_TYPE
    DO
      SUSPEND;
    if (row_count=0) then
    begin
      EXECUTE PROCEDURE PROC_INSERT_LANGUE('REF_RELIGION','FRA',:A_LANG);
      FOR SELECT RELI_LIBELLE,
                 1
          FROM REF_RELIGION
          WHERE LANGUE = :A_LANG
          ORDER BY RELI_LIBELLE
          INTO :LIBELLE,
               :I_TYPE
      DO
        SUSPEND;
    end
    exit;
  END
END^
commit^

alter PROCEDURE PROC_FERME_DOSSIER (
    I_CLE INTEGER,
    I_DOSSIER INTEGER)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:11:10
   Modifiée le :02/07/07 par André: ds_verrou=0 en sortie
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
    UPDATE DOSSIER
        SET DS_FERMETURE = 'NOW',
            DS_LAST = :I_CLE,
            ds_verrou=0
        WHERE CLE_DOSSIER = :I_DOSSIER;
   suspend;
end^
commit^

alter PROCEDURE PROC_DESCENDANCE (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_DOSSIER INTEGER)
RETURNS (
    NIVEAU INTEGER,
    SOSA VARCHAR(120),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    OCCUPATION VARCHAR(90),
    CLE_FICHE INTEGER,
    CLE_IMPORTATION VARCHAR(20),
    CLE_PARENTS INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    PREFIXE VARCHAR(30),
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SURNOM VARCHAR(120),
    SUFFIXE VARCHAR(30),
    SEXE INTEGER,
    I_DATE_NAISSANCE VARCHAR(100),
    ANNEE_NAISSANCE INTEGER,
    I_DATE_DECES VARCHAR(100),
    ANNEE_DECES INTEGER,
    DECEDE INTEGER,
    AGE_AU_DECES INTEGER,
    SOURCE BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    COMMENT BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    FILLIATION VARCHAR(30),
    NUM_SOSA DOUBLE PRECISION,
    ORDRE VARCHAR(255),
    NCHI INTEGER,
    NMR INTEGER,
    CLE_FIXE INTEGER)
AS
begin
     suspend;
end^
commit^

alter PROCEDURE PROC_TROUVE_CONJOINTS (
    I_DOSSIER INTEGER,
    I_CLEF INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(60),
    PRENOM VARCHAR(100),
    DATE_NAISSANCE VARCHAR(100),
    ANNEE_NAISSANCE INTEGER,
    DATE_DECES VARCHAR(100),
    ANNEE_DECES INTEGER,
    SEXE INTEGER,
    TYPE_UNION INTEGER,
    UNION_CLEF INTEGER,
    SOSA DOUBLE PRECISION,
    DATE_MARIAGE VARCHAR(100),
    ANNEE_MARIAGE INTEGER,
    CLE_MARIAGE INTEGER,
    ORDRE_UNION INTEGER)
AS
DECLARE VARIABLE DATE_PREM_EV DATE;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:32:22
   Modifiée le :22/02/2006 modification order by par André
   le 8/10/2006 requête indépendante du sexe, 11/08/07 ajout cle_mariage, ordre
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
  ORDRE_union=0;
  for SELECT CLE_FICHE
            ,NOM
            ,PRENOM
            ,SEXE
            ,NUM_SOSA
            ,date_naissance
            ,annee_naissance
            ,date_deces
            ,annee_deces
            ,union_type
            ,union_clef
            ,date_mariage
            ,annee_mariage
            ,cle_mariage
            ,:ordre_union+1
            ,case
               when (date_prem_enf is null) then date_prem_fam
               when (date_prem_fam is null) then date_prem_enf
               when (date_prem_fam<=date_prem_enf) then date_prem_fam
               else date_prem_enf
               end
  from (SELECT i.CLE_FICHE
            ,i.NOM
            ,i.PRENOM
            ,i.SEXE
            ,i.NUM_SOSA
            ,i.date_naissance
            ,i.annee_naissance
            ,i.date_deces
            ,i.annee_deces
            ,u.union_type
            ,u.union_clef
            ,(select first(1) ev_fam_date_writen
              from evenements_fam
              where ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
              order by ev_fam_date_year
                      ,ev_fam_date_mois
                      ,ev_fam_date) as date_mariage
            ,(select first(1) ev_fam_date_year
              from evenements_fam
              where ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
              order by ev_fam_date_year
                      ,ev_fam_date_mois
                      ,ev_fam_date) as annee_mariage
            ,(select first(1) ev_fam_clef
              from evenements_fam
              where ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
              order by ev_fam_date_year
                      ,ev_fam_date_mois
                      ,ev_fam_date) as cle_mariage
            ,(select first(1) coalesce(ev_fam_date,
                                       cast(coalesce(ev_fam_date_mois,1)||'/1/'||
                                            ev_fam_date_year as date)
                                       )
                       from evenements_fam
                       where ev_fam_kle_famille=u.union_clef
                         and ev_fam_date_year is not null
                       order by ev_fam_date_year
                               ,ev_fam_date_mois
                               ,ev_fam_date) as date_prem_fam
            ,(select first(1) coalesce(n.ev_ind_date,
                                       cast(coalesce(n.ev_ind_date_mois,1)||'/1/'||
                                            n.ev_ind_date_year as date))
                       from individu e
                       inner join evenements_ind n on n.ev_ind_kle_fiche=e.cle_fiche
                       where e.cle_pere=u.union_mari
                         and e.cle_mere=u.union_femme
                         and n.ev_ind_date_year is not null
                       order by n.ev_ind_date_year
                               ,n.ev_ind_date_mois
                               ,n.ev_ind_date) as date_prem_enf
        FROM t_union u
             inner join individu i on i.cle_fiche=u.union_femme
       Where u.union_mari = :I_CLEF)
        ORDER BY 16
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
            ,:date_prem_ev
     do
     suspend;
  if (:CLE_FICHE>0) then exit;
  for SELECT CLE_FICHE
            ,NOM
            ,PRENOM
            ,SEXE
            ,NUM_SOSA
            ,date_naissance
            ,annee_naissance
            ,date_deces
            ,annee_deces
            ,union_type
            ,union_clef
            ,date_mariage
            ,annee_mariage
            ,cle_mariage
            ,:ordre_union+1
            ,case
               when (date_prem_enf is null) then date_prem_fam
               when (date_prem_fam is null) then date_prem_enf
               when (date_prem_fam<=date_prem_enf) then date_prem_fam
               else date_prem_enf
               end
  from (SELECT i.CLE_FICHE
            ,i.NOM
            ,i.PRENOM
            ,i.SEXE
            ,i.NUM_SOSA
            ,i.date_naissance
            ,i.annee_naissance
            ,i.date_deces
            ,i.annee_deces
            ,u.union_type
            ,u.union_clef
            ,(select first(1) ev_fam_date_writen
              from evenements_fam
              where ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
              order by ev_fam_date_year
                      ,ev_fam_date_mois
                      ,ev_fam_date) as date_mariage
            ,(select first(1) ev_fam_date_year
              from evenements_fam
              where ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
              order by ev_fam_date_year
                      ,ev_fam_date_mois
                      ,ev_fam_date) as annee_mariage
            ,(select first(1) ev_fam_clef
              from evenements_fam
              where ev_fam_kle_famille=u.union_clef and ev_fam_type='MARR'
              order by ev_fam_date_year
                      ,ev_fam_date_mois
                      ,ev_fam_date) as cle_mariage
            ,(select first(1) coalesce(ev_fam_date,
                                       cast(coalesce(ev_fam_date_mois,1)||'/1/'||
                                            ev_fam_date_year as date)
                                       )
                       from evenements_fam
                       where ev_fam_kle_famille=u.union_clef
                         and ev_fam_date_year is not null
                       order by ev_fam_date_year
                               ,ev_fam_date_mois
                               ,ev_fam_date) as date_prem_fam
            ,(select first(1) coalesce(n.ev_ind_date,
                                       cast(coalesce(n.ev_ind_date_mois,1)||'/1/'||
                                            n.ev_ind_date_year as date))
                       from individu e
                       inner join evenements_ind n on n.ev_ind_kle_fiche=e.cle_fiche
                       where e.cle_pere=u.union_mari
                         and e.cle_mere=u.union_femme
                         and n.ev_ind_date_year is not null
                       order by n.ev_ind_date_year
                               ,n.ev_ind_date_mois
                               ,n.ev_ind_date) as date_prem_enf
        FROM t_union u
             inner join individu i on i.cle_fiche=u.union_mari
       Where u.union_femme = :I_CLEF)
        ORDER BY 16
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
            ,:date_prem_ev
     do
     suspend;
end^
commit^

alter PROCEDURE PROC_ETAT_DESCENDANCE (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_DOSSIER INTEGER)
RETURNS (
    NIVEAU INTEGER,
    SOSA VARCHAR(120),
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    AGE INTEGER,
    ORDRE VARCHAR(255),
    CLE_NAISSANCE INTEGER,
    VILLE_NAISSANCE VARCHAR(50),
    CP_NAISSANCE VARCHAR(10),
    DEPT_NAISSANCE VARCHAR(30),
    PAYS_NAISSANCE VARCHAR(30),
    CODE_DEPT_NAISSANCE VARCHAR(2),
    CLE_DECES INTEGER,
    VILLE_DECES VARCHAR(50),
    CP_DECES VARCHAR(10),
    DEPT_DECES VARCHAR(30),
    PAYS_DECES VARCHAR(30),
    CODE_DEPT_DECES VARCHAR(2),
    OCCUPATION VARCHAR(90),
    CLE_CONJOINT INTEGER,
    NOM_CONJOINT VARCHAR(40),
    PRENOM_CONJOINT VARCHAR(60),
    CLE_NAISSANCE_CONJOINT INTEGER,
    DATE_NAISSANCE_CONJOINT VARCHAR(100),
    VILLE_NAISSANCE_CONJOINT VARCHAR(50),
    CP_NAISSANCE_CONJOINT VARCHAR(10),
    DEPT_NAISSANCE_CONJOINT VARCHAR(30),
    PAYS_NAISSANCE_CONJOINT VARCHAR(30),
    CODE_DEPT_NAISSANCE_CONJOINT VARCHAR(2),
    CLE_DECES_CONJOINT INTEGER,
    DATE_DECES_CONJOINT VARCHAR(100),
    VILLE_DECES_CONJOINT VARCHAR(50),
    CP_DECES_CONJOINT VARCHAR(10),
    DEPT_DECES_CONJOINT VARCHAR(30),
    PAYS_DECES_CONJOINT VARCHAR(30),
    CODE_DEPT_DECES_CONJOINT VARCHAR(2),
    OCCUPATION_CONJOINT VARCHAR(90),
    CLE_MARIAGE INTEGER,
    DATE_MARIAGE VARCHAR(100),
    VILLE_MARIAGE VARCHAR(100),
    CP_MARIAGE VARCHAR(10),
    DEPT_MARIAGE VARCHAR(30),
    PAYS_MARIAGE VARCHAR(30),
    CODE_DEPT_MARIAGE VARCHAR(2),
    CLE_UNION INTEGER,
    ORDRE_UNION INTEGER,
    ISSU_UNION INTEGER,
    CODE_UNION INTEGER)
AS
begin
   suspend;
end^
commit^

alter PROCEDURE PROC_TROUVE_INDI_SUR_FAVORIS (
    I_DOSSIER INTEGER,
    I_VILLE VARCHAR(50),
    I_CP VARCHAR(10),
    I_INSEE VARCHAR(6))
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISSANCE VARCHAR(100),
    EV_IND_CP VARCHAR(10),
    EV_IND_VILLE VARCHAR(50),
    EV_IND_PAYS VARCHAR(30),
    SEXE INTEGER,
    VILLE_NAISS VARCHAR(50),
    TYPE_EVENT VARCHAR(7),
    EV_IND_DATE VARCHAR(100))
AS
BEGIN
  I_VILLE=coalesce(I_VILLE,'');
  I_CP=coalesce(I_CP,'');
  I_INSEE=coalesce(I_INSEE,'');
  FOR
    Select  DISTINCT Indi.CLE_FICHE,
            Indi.NOM,
            Indi.PRENOM,
            Indi.DATE_NAISSANCE,
            Eve.EV_IND_CP,
            Eve.EV_IND_VILLE,
            Eve.EV_IND_PAYS,
            Indi.SEXE,
            Eve.EV_IND_SUBD,
            EVE.ev_ind_type,
            eve.ev_ind_date_writen
    FROM    evenements_ind Eve
            inner join INDIVIDU Indi on Indi.CLE_FICHE = Eve.EV_IND_KLE_FICHE
    WHERE   Indi.KLE_DOSSIER=:I_DOSSIER
            and coalesce(Eve.EV_IND_VILLE,'')=:I_VILLE
            and coalesce(Eve.ev_ind_CP,'')=:I_CP
            and coalesce(Eve.ev_ind_INSEE,'')=:I_INSEE
    UNION
    Select  DISTINCT Indi.CLE_FICHE,
            Indi.NOM,
            Indi.PRENOM,
            Indi.DATE_NAISSANCE,
            Fam.EV_FAM_CP,
            Fam.EV_FAM_VILLE,
            Fam.EV_FAM_PAYS,
            Indi.SEXE,
            Fam.EV_FAM_SUBD,
            FAM.ev_fam_type,
            fam.ev_fam_date_writen
    FROM    evenements_fam Fam
            inner join T_UNION Mar on Mar.UNION_CLEF = Fam.EV_FAM_KLE_FAMILLE
            inner join INDIVIDU Indi on Indi.CLE_FICHE=Mar.UNION_MARI
                                     or Indi.CLE_FICHE=Mar.UNION_FEMME
    WHERE   Indi.KLE_DOSSIER=:I_DOSSIER
            and coalesce(Fam.EV_FAM_VILLE,'')=:I_VILLE
            and coalesce(Fam.ev_fam_cp,'')=:I_CP
            and coalesce(Fam.ev_fam_INSEE,'')=:I_INSEE
   UNION
      Select DISTINCT Indi.CLE_FICHE,
            Indi.NOM,
            Indi.PRENOM,
            Indi.DATE_NAISSANCE,
            Adr.Adr_CP,
            Adr.Adr_VILLE,
            Adr.Adr_PAYS,
            Indi.SEXE,
            Adr.Adr_SUBD,
            CAST('ADRESSE' as VARCHAR(7)),
            adr.adr_date_writen
    FROM    adresses_ind Adr
            inner join INDIVIDU Indi on Indi.CLE_FICHE=Adr.ADR_KLE_IND
    WHERE   Indi.KLE_DOSSIER=:I_DOSSIER
            and coalesce(Adr.ADR_VILLE,'')=:I_VILLE
            and coalesce(Adr.adr_cp,'')=:I_CP
            and coalesce(Adr.adr_INSEE,'')=:I_INSEE
    INTO
      :CLE_FICHE,
      :NOM,
      :PRENOM,
      :DATE_NAISSANCE,
      :EV_IND_CP,
      :EV_IND_VILLE,
      :EV_IND_PAYS,
      :SEXE,
      :VILLE_NAISS,
      :TYPE_EVENT,
      :ev_ind_date
  DO
    SUSPEND;
END^
commit^

alter PROCEDURE PROC_ANC_COMMUNS (
    INDIVIDU INTEGER,
    INDIVIDU2 INTEGER)
RETURNS (
    COMMUN INTEGER,
    ENFANT_1 INTEGER,
    NIVEAU_MIN_1 INTEGER,
    ENFANT_2 INTEGER,
    NIVEAU_MIN_2 INTEGER)
AS
DECLARE VARIABLE PERE INTEGER;
DECLARE VARIABLE MERE INTEGER;
DECLARE VARIABLE K INTEGER;
DECLARE VARIABLE I_COUNT INTEGER;
begin
/*Procédure créée par André. Dernière modification: 02/08/2007
Cette procédure liste les ancêtres communs à 2 individus. INDIVIDU et INDIVIDU2
ENFANT_1 et ENFANT_2 sont les enfants de l'ancêtre à l'origine de la branche
arrivant respectivement à INDIVIDU et INDIVIDU2. NIVEAU_MIN_1 et NIVEAU_MIN_2
sont les nombres de générations minimum séparant respectivement INDIVIDU et
INDIVIDU2 de l'ancêtre en passant par les branches issues de ENFANT_1 et ENFANT_2.
Si INDIVIDU2 est nul, les ancêtres communs aux parents de INDIVIDU sont recherchés.
Les nombres de générations sont celles qui séparent INDIVIDU de son ancêtre par
chacune des branches paternelle et maternelle.*/
  DELETE FROM TQ_CONSANG;
  IF (INDIVIDU2<>0) THEN
    begin
      PERE=INDIVIDU;
      MERE=INDIVIDU2;
    end
  ELSE
    SELECT CLE_PERE,CLE_MERE FROM INDIVIDU
          WHERE CLE_FICHE=:INDIVIDU
          INTO :PERE,:MERE;
  IF (PERE=0 OR PERE IS NULL OR MERE=0 OR MERE IS NULL) THEN
    BEGIN
      SUSPEND;
      EXIT;
    END
  IF (PERE=MERE) THEN
    BEGIN
      SUSPEND;
      EXIT;
    END
  INSERT INTO TQ_CONSANG (DECUJUS,NIVEAU,INDI,ENFANT)
                 VALUES(:PERE,0,:PERE,:PERE);
  INSERT INTO TQ_CONSANG (DECUJUS,NIVEAU,INDI,ENFANT)
                 VALUES(:MERE,0,:MERE,:MERE);
  I_COUNT=1;
  K=0;
  WHILE (I_COUNT>0) DO
    BEGIN
      /* l'ascendance du père*/
      /*par les hommes*/
      INSERT INTO TQ_CONSANG (DECUJUS,NIVEAU,INDI,ENFANT)
                SELECT :PERE,:K+1,i.CLE_PERE,tq.INDI
            FROM TQ_CONSANG tq, INDIVIDU i
            WHERE tq.DECUJUS=:PERE
              AND tq.NIVEAU=:K
              AND i.CLE_FICHE= tq.INDI
              AND i.CLE_PERE IS NOT NULL;
      /*par les femmes*/
      INSERT INTO TQ_CONSANG (DECUJUS,NIVEAU,INDI,ENFANT)
                SELECT :PERE,:K+1,i.CLE_MERE,tq.INDI
            FROM TQ_CONSANG tq, INDIVIDU i
            WHERE tq.DECUJUS=:PERE
              AND tq.NIVEAU=:K
              AND i.CLE_FICHE= tq.INDI
              AND i.CLE_MERE IS NOT NULL;
      /* l'ascendance de la mère*/
      /*par les hommes*/
      INSERT INTO TQ_CONSANG (DECUJUS,NIVEAU,INDI,ENFANT)
                SELECT :MERE,:K+1,i.CLE_PERE,tq.INDI
            FROM TQ_CONSANG tq, INDIVIDU i
            WHERE tq.DECUJUS=:MERE
              AND tq.NIVEAU=:K
              AND i.CLE_FICHE= tq.INDI
              AND i.CLE_PERE IS NOT NULL;
      /*par les femmes*/
      INSERT INTO TQ_CONSANG (DECUJUS,NIVEAU,INDI,ENFANT)
                SELECT :MERE,:K+1,i.CLE_MERE,tq.INDI
            FROM TQ_CONSANG tq, INDIVIDU i
            WHERE tq.DECUJUS=:MERE
              AND tq.NIVEAU=:K
              AND i.CLE_FICHE= tq.INDI
              AND i.CLE_MERE IS NOT NULL;
      SELECT COUNT(*) FROM TQ_CONSANG WHERE NIVEAU=:K+1
            INTO :I_COUNT;
      K=K+1;
    END
  FOR SELECT DISTINCT p.INDI
                     ,p.ENFANT
                     ,(select min(niveau) from tq_consang
                       where decujus=:pere 
                         and indi=p.indi
                         and enfant=p.enfant)
                     ,m.ENFANT
                     ,(select min(niveau) from tq_consang
                       where decujus=:mere
                         and indi=m.indi
                         and enfant=m.enfant)
            FROM TQ_CONSANG p,TQ_CONSANG m
            WHERE p.DECUJUS=:PERE
              AND m.DECUJUS=:MERE
              AND p.INDI=m.INDI
              AND p.ENFANT<>m.ENFANT
/*              AND (p.ENFANT NOT IN(SELECT ENFANT FROM TQ_CONSANG
                           WHERE DECUJUS=:MERE AND INDI=p.INDI)
                   OR m.ENFANT NOT IN(SELECT ENFANT FROM TQ_CONSANG
                           WHERE DECUJUS=:PERE AND INDI=p.INDI))*/
          INTO :COMMUN
              ,:ENFANT_1
              ,:niveau_min_1
              ,:ENFANT_2
              ,:niveau_min_2
      DO
      begin
        if (individu2=0) then
        begin
          niveau_min_1=niveau_min_1+1;
          niveau_min_2=niveau_min_2+1;
        end
        SUSPEND;
      end
end^
commit^

alter PROCEDURE PROC_GROUPE (
    I_GROUPE INTEGER,
    I_INDIVIDU INTEGER,
    MODE VARCHAR(1),
    STRICTE VARCHAR(1),
    TEMOINS VARCHAR(1),
    INITIALISATION VARCHAR(1),
    EFFET VARCHAR(1),
    VERBOSE VARCHAR(1))
RETURNS (
    INFO VARCHAR(50))
AS
BEGIN
  SUSPEND;
END^
commit^

update ref_filiation
set fil_libelle='Enfant adultérin'
where fil_libelle in ('Enfant aldutérin','Enfant aldutérien','Enfant adultérien')^
commit^
update individu
set filliation='Enfant adultérin'
where filliation in ('Enfant aldutérin','Enfant aldutérien','Enfant adultérien')^
commit^

update ref_cp_ville
set cp_ville_maj=null^
commit^

update evenements_ind
set ev_ind_acte=null
where ev_ind_acte=0^
commit^
update evenements_fam
set ev_fam_acte=null
where ev_fam_acte=0^
commit^

CREATE INDEX INDIVIDU_TRI_NOM ON INDIVIDU (indi_trie_nom)^
commit^

UPDATE T_VERSION_BASE SET VER_VERSION='5.040'^
COMMIT WORK^

SET ECHO ON^

/*Passage en version 5.040
L'utilisation de la base modifiée avec une version du logiciel inférieure à V750 peut entraîner des disfonctonnements.*/
SET ECHO OFF^
SET TERM ; ^
SET AUTODDL ON;
OUTPUT;
exit;
