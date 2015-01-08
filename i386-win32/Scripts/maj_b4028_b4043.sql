SET ECHO ON;
/*Ce script maj_b4028_b4043 ne doit s'appliquer qu'à des bases de niveau b4.028 à b4.042*/
SET ECHO OFF;
SET NAMES ISO8859_1;
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ^ ;

SET ECHO ON^
/*Modifications de la base permettant d'ajouter la fonction de suivi d'un import et en permettant la suppression ou l'élagage
Les instructions suivantes doivent provoquer des erreurs normales si la fonction est déjà installée*/
CREATE GENERATOR T_IMPORT_GEDCOM_IG_ID_GEN^
COMMIT WORK^
CREATE TABLE T_IMPORT_GEDCOM (
IG_ID INTEGER NOT NULL,
IG_PATH VARCHAR (255) CHARACTER SET ISO8859_1 NOT NULL COLLATE ISO8859_1,
IG_DATE TIMESTAMP DEFAULT 'NOW' NOT NULL)^
COMMIT WORK^
ALTER TABLE T_IMPORT_GEDCOM ADD CONSTRAINT PK_T_IMPORT_GEDCOM PRIMARY KEY (IG_ID)^
COMMIT WORK^
ALTER TABLE INDIVIDU ADD ID_IMPORT_GEDCOM INTEGER^
COMMIT WORK^
ALTER TABLE MULTIMEDIA ADD ID_IMPORT_GEDCOM INTEGER^
COMMIT WORK^
ALTER TABLE EVENEMENTS_FAM ADD ID_IMPORT_GEDCOM INTEGER^ 
COMMIT WORK^
CREATE PROCEDURE "PROC_PURGE_IMPORT_GEDCOM" 
(
  "I_CLEF" INTEGER,
  "I_MODE" INTEGER
)
RETURNS
(
  "INFO" VARCHAR(50) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend; END ^
COMMIT WORK^
/*Fin des instructions devant provoquer des erreurs dans certaines circonstances*/
SET ECHO OFF^

ALTER PROCEDURE "PROC_GET_CLEF_UNIQUE"
(
  "A_TABLE" VARCHAR(30) CHARACTER SET ISO8859_1
)
RETURNS
(
  "CLE_UNIQUE" INTEGER
)
AS
begin
SUSPEND;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_PURGE_IMPORT_GEDCOM" 
(
  "I_CLEF" INTEGER,
  "I_MODE" INTEGER
)
RETURNS
(
  "INFO" VARCHAR(50) CHARACTER SET ISO8859_1
)
AS
begin
  SUSPEND;
End
 ^
COMMIT WORK^

ALTER PROCEDURE "F_MAJ" 
(
  "S_IN" VARCHAR(255) CHARACTER SET ISO8859_1
)
RETURNS
(
  "S_OUT" VARCHAR(255) CHARACTER SET ISO8859_1
)
AS
/* Créé par André le 20/01/2006*/
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE L INTEGER;
DECLARE VARIABLE K INTEGER;
DECLARE VARIABLE CHR CHAR(1) CHARACTER SET ISO8859_1;
begin
  S_IN=UPPER(S_IN);
  S_OUT='';
  L=STRLEN(S_IN);
  I=1;
  WHILE (I<=L) DO
    begin
      CHR=SUBSTR(S_IN,I,I);
      K=ASCII_VAL(CHR);
      S_OUT=S_OUT||CASE WHEN (K=-1) THEN 'Y'
                        WHEN (K=-9) THEN CHR
                        WHEN  (K>-33 AND K<-2) THEN ASCII_CHAR(K-32)
                        ELSE CHR
                    END;
      I=I+1;
    end
  suspend;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "F_MAJ_SANS_ACCENT" 
(
  "S_IN" VARCHAR(255) CHARACTER SET ISO8859_1
)
RETURNS
(
  "S_OUT" VARCHAR(255) CHARACTER SET ISO8859_1
)
AS
begin
  suspend;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_TROUVE_INDIVIDU" 
(
  "I_DOSSIER" INTEGER,
  "A_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "A_SEXE" INTEGER,
  "A_CP_NAISSANCE" VARCHAR(10) CHARACTER SET ISO8859_1,
  "A_LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "A_PAYS_NAISSANCE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "A_CP_DECES" VARCHAR(10) CHARACTER SET ISO8859_1,
  "A_LIEU_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "A_PAYS_DECES" VARCHAR(30) CHARACTER SET ISO8859_1,
  "D_SOSA" DOUBLE PRECISION,
  "I_ANNEE_NAISS" INTEGER,
  "I_ANNEE_DECES" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_NAISSANCE" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "PAYS_NAISSANCE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_DECES" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "PAYS_DECES" VARCHAR(30) CHARACTER SET ISO8859_1
)
AS
begin
   suspend;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ETAT_ECLAIR" 
(
  "I_DOSSIER" INTEGER,
  "I_PATRONYME_SORT" INTEGER,
  "I_SOSA" INTEGER,
  "A_VILLE" VARCHAR(50) CHARACTER SET ISO8859_1
)
RETURNS
(
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "PAYS" VARCHAR(30) CHARACTER SET ISO8859_1,
  "DATE_DEBUT" INTEGER,
  "DATE_FIN" INTEGER,
  "NAISSANCE" INTEGER,
  "BAPTEME" INTEGER,
  "MARIAGE" INTEGER,
  "DECES" INTEGER
)
AS
begin
          SUSPEND;
end
 ^
COMMIT WORK^
SET ECHO ON^
/*Passage en version 4.029*/
SET ECHO OFF^

ALTER PROCEDURE "PROC_LISTE_INDIVIDU" 
(
  "I_DOSSIER" INTEGER,
  "I_LETTRE" VARCHAR(1) CHARACTER SET ISO8859_1,
  "I_MODE" INTEGER,
  "I_SEXE" INTEGER
)
RETURNS
(
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "CLE_FICHE" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "KLE_DOSSIER" INTEGER,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_DECES" INTEGER,
  "CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "NUM_SOSA" DOUBLE PRECISION,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_DECES" VARCHAR(10) CHARACTER SET ISO8859_1,
  "VILLE_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "ANNEE_NAISSANCE" INTEGER
)
AS
begin
         suspend;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_TROUVE_CHAINE_INDI" 
(
  "I_DOSSIER" INTEGER,
  "SNOM" VARCHAR(20) CHARACTER SET ISO8859_1,
  "SPRENOM" VARCHAR(20) CHARACTER SET ISO8859_1
)
RETURNS
(
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "CLE_FICHE" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "KLE_DOSSIER" INTEGER,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_DECES" INTEGER,
  "CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "NUM_SOSA" DOUBLE PRECISION,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_DECES" VARCHAR(10) CHARACTER SET ISO8859_1,
  "VILLE_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "ANNEE_NAISSANCE" INTEGER
)
AS
begin
   suspend;
end
 ^
COMMIT WORK^

ALTER TRIGGER "T_BI_INDIVIDU"
ACTIVE BEFORE INSERT POSITION 0
as
begin
exit; end
 ^
COMMIT WORK ^

ALTER TRIGGER "T_BI_INDIVIDU_2"
ACTIVE BEFORE INSERT POSITION 1
as
begin
exit; end
 ^
COMMIT WORK ^

ALTER TRIGGER "T_BU_INDIVIDU_2"
ACTIVE BEFORE UPDATE POSITION 1
as
begin
exit; end
 ^
COMMIT WORK ^

EXECUTE PROCEDURE PROC_AFTER_IMPORT(0,0)^
COMMIT WORK ^

ALTER PROCEDURE "PROC_ENFANTS_POSSIBLES" 
(
  "I_CLEF" INTEGER,
  "I_NOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "NOM_PERE" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM_PERE" VARCHAR(60) CHARACTER SET ISO8859_1,
  "NOM_MERE" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM_MERE" VARCHAR(60) CHARACTER SET ISO8859_1
)
AS
DECLARE VARIABLE I_SEXE INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 18:14:46
   Modifiée le :
   à : :
   par :
   Description :    Cette procedure permet de récuperer tous les enfants possible d'un individu
   en selectionnant un nom
   En sont exclus
   Lui ou elle meme
   sa mere
   son pere
   ses enfants
   et pour chaque prenom, on affiche le nom du pere
   Usage       :
   ---------------------------------------------------------------------------*/
   SELECT SEXE
      FROM INDIVIDU
      where (KLE_DOSSIER = :I_DOSSIER) and
            (CLE_FICHE = :I_CLEF)
      INTO
         :I_SEXE;
   for
      SELECT  Enfant.cle_fiche,
              Enfant.prenom,
              naissance.ev_ind_date_writen,
              deces.ev_ind_date_writen,
              Enfant.sexe,
              Pere.nom,
              Pere.prenom,
              Mere.nom,
              Mere.prenom
         FROM  individu Enfant
         LEFT  JOIN evenements_ind naissance
               ON (Enfant.cle_fiche = naissance.ev_ind_kle_fiche and
                    naissance.ev_ind_type = 'BIRT' and
                    naissance.ev_ind_kle_dossier = :I_DOSSIER  )
         LEFT  JOIN evenements_ind deces
                ON (Enfant.cle_fiche = deces.ev_ind_kle_fiche and
                    deces.ev_ind_type = 'DEAT' and
                    deces.ev_ind_kle_dossier = :I_DOSSIER )
         LEFT JOIN individu pere
                       on Enfant.cle_pere = pere.cle_fiche
         LEFT JOIN individu mere
                       on Enfant.cle_mere = mere.cle_fiche
         WHERE Enfant.kle_dossier = :I_DOSSIER AND
               UPPER(Enfant.nom) containing UPPER(:I_NOM) and
               Enfant.cle_fiche <> :I_CLEF and
               ((enfant.cle_pere is null and :I_SEXE = 1) or
               (enfant.cle_mere is null and :I_SEXE = 2))
         ORDER BY Enfant.prenom
         INTO :CLE_FICHE,
              :PRENOM,
              :DATE_NAISSANCE,
              :DATE_DECES,
              :SEXE,
              :NOM_PERE,
              :PRENOM_PERE,
              :NOM_MERE,
              :PRENOM_MERE
   do
   suspend;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_PRENOM_PAR_NOM" 
(
  "I_NOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "I_DOSSIER" INTEGER,
  "I_MODE" INTEGER,
  "I_SEXE" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "NOM_PERE" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM_PERE" VARCHAR(60) CHARACTER SET ISO8859_1,
  "PERE_DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "PERE_LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "PERE_CLE_FICHE" INTEGER,
  "NOM_MERE" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM_MERE" VARCHAR(60) CHARACTER SET ISO8859_1,
  "MERE_DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "MERE_LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "MERE_CLE_FICHE" INTEGER
)
AS
begin
   suspend;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_PRENOM_PAR_NOM_PAR_CLEF" 
(
  "I_CLEF" INTEGER,
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "NOM_PERE" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM_PERE" VARCHAR(60) CHARACTER SET ISO8859_1,
  "PERE_DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "PERE_ANNEE_NAISSANCE" INTEGER,
  "PERE_CLE_FICHE" INTEGER,
  "PERE_NUM_SOSA" DOUBLE PRECISION,
  "NOM_MERE" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM_MERE" VARCHAR(60) CHARACTER SET ISO8859_1,
  "MERE_DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "MERE_ANNEE_NAISSANCE" INTEGER,
  "MERE_CLE_FICHE" INTEGER,
  "MERE_NUM_SOSA" DOUBLE PRECISION,
  "NOM" VARCHAR(60) CHARACTER SET ISO8859_1
)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:29:46
   Modifiée le :
   à : :
   par :
    Description : Cette procedure ramene tous les prenoms d'un nom
                  et pour chaque prenom, on affiche le nom du pere
    Usage       :
    ---------------------------------------------------------------------------*/
 for
      SELECT  Enfant.cle_fiche,
              Enfant.prenom,
              naissance.ev_ind_date_writen,
              naissance.ev_ind_ville,
              deces.ev_ind_date_writen,
              deces.ev_ind_ville,
              Enfant.sexe,
              Pere.nom,
              Pere.prenom,
              Pere_naissance.ev_ind_date_writen,
              Pere_naissance.ev_ind_date_year,
              Pere.cle_fiche,
              Pere.Num_Sosa,
              Mere.nom,
              Mere.prenom,
              Mere_naissance.ev_ind_date_writen,
              Mere_naissance.ev_ind_date_year,
              Mere.cle_fiche,
              Mere.Num_Sosa,
              Enfant.Nom
         FROM  individu Enfant
         LEFT  JOIN evenements_ind naissance
               ON (Enfant.cle_fiche = naissance.ev_ind_kle_fiche and
                    naissance.ev_ind_type = 'BIRT' and
                    naissance.ev_ind_kle_dossier = :I_DOSSIER  )
         LEFT  JOIN evenements_ind deces
                ON (Enfant.cle_fiche = deces.ev_ind_kle_fiche and
                    deces.ev_ind_type = 'DEAT' and
                    deces.ev_ind_kle_dossier = :I_DOSSIER )
         LEFT JOIN individu pere
                       on Enfant.cle_pere = pere.cle_fiche
         LEFT  JOIN evenements_ind pere_naissance
                ON (pere.cle_fiche = pere_naissance.ev_ind_kle_fiche and
                    pere_naissance.ev_ind_type = 'BIRT' and
                    pere_naissance.ev_ind_kle_dossier = :I_DOSSIER )
         LEFT JOIN individu mere
                       on Enfant.cle_mere = mere.cle_fiche
         LEFT  JOIN evenements_ind mere_naissance
                ON (mere.cle_fiche = mere_naissance.ev_ind_kle_fiche and
                    mere_naissance.ev_ind_type = 'BIRT' and
                    mere_naissance.ev_ind_kle_dossier = :I_DOSSIER )
         WHERE Enfant.kle_dossier = :I_DOSSIER AND Enfant.Cle_Fiche = :I_CLEF
         ORDER BY Enfant.prenom
         INTO :CLE_FICHE,
              :PRENOM,
              :DATE_NAISSANCE,
              :LIEU_NAISSANCE,
              :DATE_DECES,
              :LIEU_DECES,
              :SEXE,
              :NOM_PERE,
              :PRENOM_PERE,
              :PERE_DATE_NAISSANCE,
              :PERE_ANNEE_NAISSANCE,
              :PERE_CLE_FICHE,
              :PERE_NUM_SOSA,
              :NOM_MERE,
              :PRENOM_MERE,
              :MERE_DATE_NAISSANCE,
              :MERE_ANNEE_NAISSANCE,
              :MERE_CLE_FICHE,
              :MERE_NUM_SOSA,
              :NOM
   do
   suspend;
end
 ^
COMMIT WORK^
SET ECHO ON^
/*Passage en version 4.030
L'instruction suivante doit provoquer une erreur normale si le trigger est déjà créé*/
CREATE TRIGGER "TAD_EVENEMENTS_IND" FOR "EVENEMENTS_IND" 
ACTIVE AFTER DELETE POSITION 0
as
BEGIN
END
 ^
COMMIT WORK ^
/*Fin erreurs normales*/
SET ECHO OFF^
ALTER TRIGGER "EVENEMENTS_IND_AI"
ACTIVE AFTER INSERT POSITION 0
as
begin
exit; end
 ^
COMMIT WORK ^
ALTER TRIGGER "TBD_EVENEMENTS_IND"
ACTIVE BEFORE DELETE POSITION 0
as
/* Création par André pour fonctionnement média (01/10/05)
   Suppression des enregistrements dans SOURCES_RECORD et
   dans MEDIA_POINTEURS si l'enregistrement disparaît.
   24/10/05 ajout maj table T_ASSOCIATIONS*/
BEGIN
  DELETE FROM SOURCES_RECORD
    WHERE DATA_ID=OLD.EV_IND_CLEF AND
          TYPE_TABLE ='I' ;
  DELETE FROM MEDIA_POINTEURS
    WHERE MP_POINTE_SUR=OLD.EV_IND_CLEF AND
          MP_TYPE_IMAGE ='A' AND
          MP_TABLE ='I';
  DELETE FROM T_ASSOCIATIONS
    WHERE ASSOC_EVENEMENT=OLD.EV_IND_CLEF AND
          ASSOC_TABLE = 'I' ;
END
 ^
COMMIT WORK ^

ALTER TRIGGER "T_BI_INDIVIDU"
ACTIVE BEFORE INSERT POSITION 0
as
begin
exit; end
 ^
COMMIT WORK ^

ALTER PROCEDURE "PROC_MAJ_DATE_UN_IND" 
(
  "CLE_IND" INTEGER,
  "S_MODE" VARCHAR(5) CHARACTER SET ISO8859_1,
  "S_DATE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "I_YEAR" INTEGER
)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:22:11
   Modifiée le : 25/03/2006 par André, suppression suspend
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
   if (s_Mode = 'BIRT') then
      update individu
          set
          date_naissance = :S_DATE,
          annee_naissance = :I_YEAR,
          age_au_deces = annee_deces - annee_naissance
       where  (individu.cle_fiche = :CLE_IND) ;
   else
       update individu
           set
           date_deces = :S_DATE,
           annee_deces = :I_YEAR,
           age_au_deces = annee_deces - annee_naissance
        where  (individu.cle_fiche = :CLE_IND) ;
end
 ^
COMMIT WORK^
/*Mise à jour des dates dans la table individu*/
EXECUTE PROCEDURE PROC_MAJ_DATE_ALL^
COMMIT WORK^

SET ECHO ON^
/*Passage en version 4.031

Les instructions suivantes doivent provoquer des erreurs normales si l'objet est déjà créé*/
ALTER TABLE INDIVIDU ADD NCHI SMALLINT^
COMMIT WORK^
ALTER TABLE INDIVIDU ADD NMR SMALLINT^
COMMIT WORK^
ALTER TABLE INDIVIDU ADD CLE_FIXE INTEGER^
COMMIT WORK^
CREATE TRIGGER "T_BI_INDIVIDU_2" FOR "INDIVIDU" 
ACTIVE BEFORE INSERT POSITION 1
as
begin exit; end^
COMMIT WORK^
CREATE TRIGGER "T_BU_INDIVIDU_2" FOR "INDIVIDU" 
ACTIVE BEFORE UPDATE POSITION 1
as
begin exit; end^
COMMIT WORK^
DROP TRIGGER INDIVIDU_AU^
COMMIT WORK^
ALTER TABLE ADRESSES_IND ADD ADR_DATE_MOIS_1 INTEGER,ADD ADR_DATE_MOIS_2 INTEGER^
COMMIT WORK^
ALTER TABLE EVENEMENTS_FAM ADD EV_FAM_DATE_MOIS INTEGER^
COMMIT WORK^
ALTER TABLE EVENEMENTS_IND ADD EV_IND_DATE_MOIS INTEGER^
COMMIT WORK^
ALTER TABLE EVENEMENTS_FAM ADD EV_FAM_DATE_MOIS_FIN INTEGER,ADD EV_FAM_DATE_YEAR_FIN INTEGER^
COMMIT WORK^
ALTER TABLE EVENEMENTS_IND ADD EV_IND_DATE_MOIS_FIN INTEGER,ADD EV_IND_DATE_YEAR_FIN INTEGER^
COMMIT WORK^
ALTER TABLE EVENEMENTS_FAM ADD EV_FAM_DATE_FIN DATE^
COMMIT WORK^
ALTER TABLE EVENEMENTS_IND ADD EV_IND_DATE_FIN DATE^
COMMIT WORK^
ALTER TABLE REF_TOKEN_DATE ADD SOUS_TYPE VARCHAR(2) CHARACTER SET ISO8859_1^
COMMIT WORK^
CREATE TRIGGER "T_REF_TOKEN_DATE_BUI" FOR "REF_TOKEN_DATE" 
ACTIVE BEFORE UPDATE OR INSERT POSITION 0
as
begin
  NEW.SOUS_TYPE=UPPER(NEW.SOUS_TYPE);
end ^
COMMIT WORK ^
CREATE PROCEDURE "PROC_MAJ_FORME_DATE" 
(
  "FORME" CHAR(3) CHARACTER SET ISO8859_1,
  "MODE_MAJ" INTEGER
)
AS
BEGIN EXIT; END ^
COMMIT WORK^
CREATE PROCEDURE "PROC_DATE_WRITEN_UN" 
(
  "DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1
)
RETURNS
(
  "IJOUR" INTEGER,
  "IMOIS" INTEGER,
  "IAN" INTEGER,
  "TOKEN" VARCHAR(30) CHARACTER SET ISO8859_1,
  "TYPE_TOKEN" INTEGER,
  "DATE_WRITEN_S" VARCHAR(100) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend; END ^
COMMIT WORK^
CREATE TABLE "T_GROUPES" 
(
  "KLE_DOSSIER"	 INTEGER NOT NULL,
  "CLE_GROUPE"	 INTEGER NOT NULL,
  "CLE_FICHE"	 INTEGER NOT NULL,
  "TOP_ASCENDANT"	 INTEGER,
  "TOP_DESCENDANT"	 INTEGER
)^
COMMIT WORK^
CREATE INDEX "T_GROUPES_IDX1" ON "T_GROUPES"("KLE_DOSSIER", "CLE_GROUPE", "CLE_FICHE")^
CREATE INDEX "T_GROUPES_IDX2" ON "T_GROUPES"("KLE_DOSSIER", "CLE_GROUPE", "TOP_ASCENDANT")^
CREATE INDEX "T_GROUPES_IDX3" ON "T_GROUPES"("KLE_DOSSIER", "CLE_GROUPE", "TOP_DESCENDANT")^
COMMIT WORK^
CREATE PROCEDURE "PROC_LR_MIX_GROUPES" 
(
  "I_DOSSIER" INTEGER,
  "I_GROUPE1" INTEGER,
  "I_GROUPE2" INTEGER,
  "I_GROUPE3" INTEGER,
  "I_MODE" INTEGER
)
AS
BEGIN
exit;
END ^
COMMIT WORK^
CREATE PROCEDURE "PROC_LR_SEL_GROUPE" 
(
  "I_DOSSIER" INTEGER,
  "I_GROUPE" INTEGER,
  "I_INDIVIDU" INTEGER,
  "I_CONJOINT" INTEGER,
  "I_NB_GENERATIONS" INTEGER,
  "I_MODE" INTEGER,
  "I_TYPE_MAJ" INTEGER
)
RETURNS
(
  "O_NB_AJOUT" INTEGER,
  "O_NB_GENERATIONS" INTEGER
)
AS
BEGIN suspend; END ^
COMMIT WORK^

/*Fin des erreurs normales*/
SET ECHO OFF^
ALTER PROCEDURE "PROC_LR_MIX_GROUPES" 
(
  "I_DOSSIER" INTEGER,
  "I_GROUPE1" INTEGER,
  "I_GROUPE2" INTEGER,
  "I_GROUPE3" INTEGER,
  "I_MODE" INTEGER
)
AS
DECLARE VARIABLE GROUPE INTEGER;
DECLARE VARIABLE CLE_FICHE INTEGER;
DECLARE VARIABLE TOP_ASCENDANT INTEGER;
DECLARE VARIABLE TOP_DESCENDANT INTEGER;
DECLARE VARIABLE NOMBRE INTEGER;
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Laurent Robbe. Tout droits réservés.
   Créé le : 03/08/2003
   à : 19:14:10
   Modifiée le :
   à : :
   par :
   Description : Cette procedure permet d'ajouter ou de soustraire un groupe à
                 un autre
   Usage       :
     I_DOSSIER        : Dossier
     I_GROUPE1        : Numéro du premier groupe
     I_GROUPE2        : Numéro du second groupe
     I_GROUPE3        : Numéro du groupe résultant
     I_MODE           : ajout (G1+G2), soustraction (G1-G2) ou intersection
                        (G1 Inter G2)
                        0 = G1+G2
                        1 = G1-G2
                        2 = G1 inter G2
   ---------------------------------------------------------------------------*/
  if ((I_GROUPE3 <> I_GROUPE1) and (I_GROUPE3 <> I_GROUPE2)) then begin
    delete from t_groupes
    where kle_dossier = :I_DOSSIER
    and   cle_groupe  = :I_GROUPE3;
    GROUPE=I_GROUPE3;
  end else begin
    /* Utilisation temporaire d'un numéro de groupe inutilisé */
    select max(cle_groupe)
    from t_groupes
    where kle_dossier = :I_DOSSIER
    into :GROUPE;
    GROUPE=GROUPE+1;
  end

  if (I_MODE=0) then begin
    /* Recopier le groupe G1 */
    for select cle_fiche, top_ascendant, top_descendant
    from t_groupes
    where kle_dossier = :I_DOSSIER
    and   cle_groupe  = :i_groupe1
    into :cle_fiche, :top_ascendant, :top_descendant
    do begin
      insert into t_groupes
      values (:i_dossier,:groupe,:cle_fiche,:top_ascendant,:top_descendant);
    end

    /* Ajouter le groupe G2 */
    for select cle_fiche, top_ascendant, top_descendant
    from t_groupes
    where kle_dossier = :I_DOSSIER
    and   cle_groupe  = :i_groupe2
    into :cle_fiche, :top_ascendant, :top_descendant
    do begin
      select count(0)
      from t_groupes
      where kle_dossier = :I_DOSSIER
      and   cle_groupe  = :groupe
      and   cle_fiche   = :cle_fiche
      into :nombre;
      if (nombre<=0) then begin
        insert into t_groupes
        values (:i_dossier,:groupe,:cle_fiche,:top_ascendant,:top_descendant);
      end else begin
        if (top_ascendant>0) then begin
          update t_groupes
          set top_ascendant = 1
          where kle_dossier = :I_DOSSIER
          and   cle_groupe  = :groupe
          and   cle_fiche   = :cle_fiche;
        end
        if (top_descendant>0) then begin
          update t_groupes
          set top_descendant = 1
          where kle_dossier = :I_DOSSIER
          and   cle_groupe  = :groupe
          and   cle_fiche   = :cle_fiche;
        end
      end
    end
  END

  /* G1-G2  */
  if (I_MODE=1) then begin
    /* top_ascendant et top_descendant doivent être remis à 0 sinon,
       usine à gaz... */
    for select cle_fiche
    from t_groupes G1
    where G1.kle_dossier = :I_DOSSIER
    and   G1.cle_groupe  = :i_groupe1
    and   not exists (
         select * from t_groupes G2
         where G2.kle_dossier = :I_DOSSIER
         and   G2.cle_groupe  = :i_groupe2
         and   G2.cle_fiche   = G1.cle_fiche)
    into :cle_fiche
    do begin
      insert into t_groupes
      values (:i_dossier,:groupe,:cle_fiche,0,0);
    end
  end

  /* G1 inter G2  */
  if (I_MODE=2) then begin
    /* top_ascendant et top_descendant doivent être remis à 0 sinon,
       usine à gaz... */
    for select cle_fiche
    from t_groupes G1
    where G1.kle_dossier = :I_DOSSIER
    and   G1.cle_groupe  = :i_groupe1
    and   exists (
         select * from t_groupes G2
         where G2.kle_dossier = :I_DOSSIER
         and   G2.cle_groupe  = :i_groupe2
         and   G2.cle_fiche   = G1.cle_fiche)
    into :cle_fiche
    do begin
      insert into t_groupes
      values (:i_dossier,:groupe,:cle_fiche,0,0);
    end
  end

  /* Si utilisation table temporaire, faire le transfert et vider */
  if (groupe<>I_GROUPE3) then begin
    /* Vidage de Groupe3  */
    delete from t_groupes
    where kle_dossier = :I_DOSSIER
    and   cle_groupe  = :I_GROUPE3;

    /* Recopier le groupe G vers G3 */
    for select cle_fiche, top_ascendant, top_descendant
    from t_groupes
    where kle_dossier = :I_DOSSIER
    and   cle_groupe  = :groupe
    into :cle_fiche, :top_ascendant, :top_descendant
    do begin
      insert into t_groupes
      values (:i_dossier,:i_groupe3,:cle_fiche,:top_ascendant,:top_descendant);
    end

    /* Vider le groupe G */
    delete from t_groupes
    where kle_dossier = :I_DOSSIER
    and   cle_groupe  = :GROUPE;
  end

END ^
COMMIT WORK^


/* ces corrections sont faîtes pour réparer des bases dont la migration aurait été faîte bien qu'elle ne soit pas en b3.57*/
ALTER TABLE INDIVIDU ALTER COLUMN NCHI POSITION 27 ^
COMMIT WORK^
ALTER TABLE INDIVIDU ALTER COLUMN NMR POSITION 28 ^
COMMIT WORK^
ALTER TABLE INDIVIDU ALTER COLUMN CLE_FIXE POSITION 29 ^
COMMIT WORK^
ALTER TRIGGER "T_BI_INDIVIDU_2"
ACTIVE BEFORE INSERT POSITION 1
as
begin
exit; end^
COMMIT WORK^

ALTER TRIGGER "T_BU_INDIVIDU_2"
ACTIVE BEFORE UPDATE POSITION 1
as
begin
exit; end^
COMMIT WORK^

ALTER PROCEDURE "PROC_DATE_WRITEN_UN" 
(
  "DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1
)
RETURNS
(
  "IJOUR" INTEGER,
  "IMOIS" INTEGER,
  "IAN" INTEGER,
  "TOKEN" VARCHAR(30) CHARACTER SET ISO8859_1,
  "TYPE_TOKEN" INTEGER,
  "DATE_WRITEN_S" VARCHAR(100) CHARACTER SET ISO8859_1
)
AS
declare variable L INTEGER;
declare variable I INTEGER;
declare variable CH char(1);
declare variable CHD varchar(5);
declare variable INTD INTEGER;
declare variable PLACEMOIS INTEGER;
declare variable CHD1 varchar(5);
declare variable CHD2 varchar(5);
declare variable CHD3 varchar(5);
declare variable CONT varchar(3);
declare variable ORDRE varchar(30);
declare variable M varchar(5);
declare variable D varchar(5);
declare variable Y varchar(5);
declare variable LANGUE varchar(3);
declare variable DDATE DATE;
/* Créé par André le 01/06/2006 pour transformer une date texte*/
begin
  DATE_WRITEN_S=UPPER(RTRIM(LTRIM(DATE_WRITEN)));
  IF (STRLEN(DATE_WRITEN_S)>0) THEN
    BEGIN
      CHD1='';
      CHD2='';
      CHD3='';
      PLACEMOIS=0;
      L=1;
      WHILE (L>0) DO   /*élimination des token et espaces*/
        begin
          L=0;
          SELECT MAX(STRLEN(TOKEN))
            FROM REF_TOKEN_DATE
            WHERE TYPE_TOKEN>12 AND TYPE_TOKEN<22
                 AND :DATE_WRITEN_S STARTING WITH UPPER(TOKEN)||' '
            INTO :L;
          IF (L>0) THEN
            BEGIN
              SELECT TYPE_TOKEN
                FROM REF_TOKEN_DATE
                WHERE TYPE_TOKEN>12 AND TYPE_TOKEN<22
                     AND UPPER(TOKEN)=SUBSTR(:DATE_WRITEN_S,1,:L)
                INTO :TYPE_TOKEN;
              IF (STRLEN(DATE_WRITEN_S)>L) THEN
                DATE_WRITEN_S=LTRIM(SUBSTR(DATE_WRITEN_S,L+1,STRLEN(DATE_WRITEN_S)));
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
      WHILE (STRLEN(DATE_WRITEN_S)>0 AND I<3) DO /*Recherche composants de la date*/
        BEGIN
          I=I+1;
          CONT='OUI';
          L=0;
          FOR SELECT STRLEN(TOKEN) /*élimination séparateurs*/
            FROM REF_TOKEN_DATE
            WHERE TYPE_TOKEN=22
                  AND :DATE_WRITEN_S STARTING WITH TOKEN
            INTO :L
          DO IF (L>0) THEN
              begin
              IF (STRLEN(DATE_WRITEN_S)>L) THEN
                DATE_WRITEN_S=LTRIM(SUBSTR(DATE_WRITEN_S,L+1,STRLEN(DATE_WRITEN_S)));
              ELSE
                begin
                  DATE_WRITEN_S='';
                  CONT='NON';
                end
              end  /*fin de élimination séparateurs*/
          CHD='';
          IF (CONT='OUI') THEN /* si chiffres, premier caractère*/
            begin
              CH=SUBSTR(DATE_WRITEN_S,1,1);
              IF (CH IN('-','+','0','1','2','3','4','5','6','7','8','9')) THEN
                begin
                  CHD=CH;
                  IF (STRLEN(DATE_WRITEN_S)>1) THEN
                    DATE_WRITEN_S=SUBSTR(DATE_WRITEN_S,2,STRLEN(DATE_WRITEN_S));
                  ELSE
                    begin
                      DATE_WRITEN_S='';
                      CONT='NON';
                    end
                end
              ELSE
                CONT='NON';
            end
          WHILE (CONT='OUI' AND STRLEN(CHD)<5) DO /* si chiffres, suivants*/
             begin
              CH=SUBSTR(DATE_WRITEN_S,1,1);
              IF (CH IN('0','1','2','3','4','5','6','7','8','9')) THEN
                begin
                  CHD=CHD||CH;
                  IF (STRLEN(DATE_WRITEN_S) > 1) THEN
                    DATE_WRITEN_S=SUBSTR(DATE_WRITEN_S,2,STRLEN(DATE_WRITEN_S));
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
              SELECT MAX(STRLEN(TOKEN)),TYPE_TOKEN
                FROM REF_TOKEN_DATE
                WHERE TYPE_TOKEN<13
                  AND :DATE_WRITEN_S STARTING WITH UPPER(TOKEN)
                GROUP BY TYPE_TOKEN
                INTO :L,:INTD;
              IF (L>0) THEN
                begin
                  CHD=CAST(INTD AS varchar(5));
                  PLACEMOIS=I;
                  IF (STRLEN(DATE_WRITEN_S) > L) THEN
                    DATE_WRITEN_S=SUBSTR(DATE_WRITEN_S,L+1,STRLEN(DATE_WRITEN_S));
                  ELSE
                    DATE_WRITEN_S='';
                end
            END  /* fin de si token mois*/
            DATE_WRITEN_S=LTRIM(DATE_WRITEN_S);
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
      I=0;
      WHILE (I<3 AND I<STRLEN(ORDRE)) DO
        BEGIN
          I=I +1;
          CH=SUBSTR(ORDRE,I,I);
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
            CHD='0'; /*ajouter 0 devant */
            IF (ABS(CAST(Y AS INTEGER))<10) THEN  CHD='00';/*ajouter 00 devant */
            IF (SUBSTR(Y,1,1) IN ('-','+')) THEN
              Y=SUBSTR(Y,1,1)||CHD||CAST(CAST(ABS(Y) AS INTEGER) AS varchar(2));
            ELSE
              Y=CHD||CAST(CAST(ABS(Y) AS INTEGER) AS varchar(2));
          end
        DDATE=CAST(M||'/'||D||'/'||Y AS DATE);
        IMOIS=CAST(M AS INTEGER);
        IAN=CAST(Y AS INTEGER);
        IJOUR=extract(day from DDATE);
        WHEN ANY DO
         begin
           IF (STRLEN(Y) >0) THEN
             begin
               IAN = CAST(Y AS INTEGER);
               IMOIS = CAST(M AS INTEGER);
               IF (IMOIS<1 OR IMOIS>12) THEN IMOIS=NULL;
             end
           ELSE
            IF (PLACEMOIS=1) THEN
              begin
                IMOIS = CAST(CHD1 AS INTEGER);
                IF (IMOIS<1 OR IMOIS>12) THEN IMOIS=NULL;
                IF (STRLEN(CHD2)>0) THEN IAN=CAST(CHD2 AS INTEGER);
              end
            ELSE
              IF (PLACEMOIS=2) THEN
                begin
                  IMOIS=CAST(CHD2 AS INTEGER);
                  IF (IMOIS<1 OR IMOIS>12) THEN IMOIS=NULL;
                  IF (STRLEN(CHD1)>0) THEN IAN=CAST(CHD1 AS INTEGER);
                end
              ELSE
                IF (STRLEN(CHD1)>0 AND STRLEN(CHD2)>0) THEN
                  begin
                    IF (CAST(CHD2 AS INTEGER)<1) THEN
                      begin
                        IAN=CAST(CHD2 AS INTEGER);
                        IMOIS=CAST(CHD1 AS INTEGER);
                        IF (IMOIS<1 OR IMOIS>12) THEN IMOIS=NULL;
                      end
                    ELSE IF (CAST(CHD1 AS INTEGER)<1) THEN
                           begin
                             IAN=CAST(CHD1 AS INTEGER);
                             IMOIS=CAST(CHD2 AS INTEGER);
                             IF (IMOIS<1 OR IMOIS>12) THEN IMOIS=NULL;
                           end
                         ELSE IF (ABS(CAST(CHD1 AS INTEGER))>ABS(CAST(CHD2 AS INTEGER))) THEN
                                begin
                                  IAN=CAST(CHD1 AS INTEGER);
                                  IMOIS=CAST(CHD2 AS INTEGER);
                                  IF (IMOIS<1 OR IMOIS>12) THEN IMOIS=NULL;
                                end
                              ELSE
                                begin
                                  IAN=CAST(CHD2 AS INTEGER);
                                  IMOIS=CAST(CHD1 AS INTEGER);
                                  IF (IMOIS<1 OR IMOIS>12) THEN IMOIS=NULL;
                                end
                  end
                ELSE
                  IF (STRLEN(CHD1)>0) THEN IAN=CAST(CHD1 AS INTEGER);
                  ELSE
                    IF (STRLEN(CHD2)>0) THEN IAN=CAST(CHD2 AS INTEGER);
         end
      END
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
               INTO :TOKEN;
    END
    SUSPEND;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_DATE_WRITEN" 
(
  "DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1
)
RETURNS
(
  "IMOIS" INTEGER,
  "IAN" INTEGER,
  "DDATE" DATE,
  "IMOIS_FIN" INTEGER,
  "IAN_FIN" INTEGER,
  "DDATE_FIN" DATE,
  "DATE_WRITEN_S" VARCHAR(100) CHARACTER SET ISO8859_1
)
AS
declare variable JOUR1 INTEGER;
declare variable MOIS1 INTEGER;
declare variable AN1 INTEGER;
declare variable DATE1 DATE;
declare variable TOKEN1 varchar(30);
declare variable TYPE_TOKEN1 INTEGER;
declare variable RESTE varchar(100);
declare variable SDATE1 varchar(100);
declare variable IDATE1 INTEGER;
declare variable JOUR2 INTEGER;
declare variable MOIS2 INTEGER;
declare variable AN2 INTEGER;
declare variable DATE2 DATE;
declare variable TOKEN2 varchar(30);
declare variable TYPE_TOKEN2 INTEGER;
declare variable SDATE2 varchar(100);
declare variable IDATE2 INTEGER;
declare variable ORDRE varchar(30);
declare variable FORME varchar(30);
declare variable LANGUE varchar(3);
declare variable I INTEGER;
declare variable SMOIS varchar(30);
declare variable SJOUR varchar(30);
declare variable SAN varchar(30);
declare variable CH varchar(30);
declare variable SEPARATEUR varchar(1);
declare variable TOKEN varchar(30);
/* Créé par André le 01/06/2006 pour transformer une date texte */
begin
  SELECT FIRST(1) LTRIM(RTRIM(UPPER(TOKEN))) --cherche ordre jour, mois, année dans TYPE_TOKEN 23
    FROM REF_TOKEN_DATE
    WHERE TYPE_TOKEN=23
    INTO :ORDRE;
  IF (ORDRE IS NULL) THEN   /*créer TYPE_TOKEN 23, fait une seule fois*/
    begin
      SELECT FIRST(1) LANGUE
            FROM REF_TOKEN_DATE
            INTO :LANGUE;
      IF (LANGUE IN('USA','GBR','ENG')) THEN  /*ajouter langues si nécessaire*/
        ORDRE ='MDY';
      ELSE
        ORDRE='DMY';
      SELECT MAX(ID)+1 FROM REF_TOKEN_DATE INTO :I;
      I=gen_id(gen_token_date,I-gen_id(gen_token_date,0));
      INSERT INTO REF_TOKEN_DATE (ID,TYPE_TOKEN,LANGUE,TOKEN)
                 VALUES(:I,23,:LANGUE,:ORDRE);
    end
  SELECT FIRST(1) LTRIM(RTRIM(UPPER(TOKEN))) --cherche la forme LIT ou NUM dans TYPE_TOKEN 24
    FROM REF_TOKEN_DATE
    WHERE TYPE_TOKEN=24
    INTO :FORME;
  IF (FORME IS NULL) THEN --créer TYPE_TOKEN 24, fait une seule fois
    begin
      FORME='LIT';
      SELECT MAX(ID)+1 FROM REF_TOKEN_DATE INTO :I;
      I=gen_id(gen_token_date,I-gen_id(gen_token_date,0));
      SELECT FIRST(1) LANGUE
             FROM REF_TOKEN_DATE
             INTO :LANGUE;
      INSERT INTO REF_TOKEN_DATE (ID,TYPE_TOKEN,LANGUE,TOKEN)
             VALUES(:I,24,:LANGUE,:FORME);
    end
  SELECT IJOUR,IMOIS,IAN,TOKEN,TYPE_TOKEN,DATE_WRITEN_S --extrait la première date
    FROM PROC_DATE_WRITEN_UN(:DATE_WRITEN)
    INTO :JOUR1,:MOIS1,:AN1,:TOKEN1,:TYPE_TOKEN1,:RESTE;
  IF (AN1 IS NULL) THEN
    begin
      DATE_WRITEN_S=DATE_WRITEN;
      SUSPEND;
      EXIT;
    end
  IF (JOUR1 IS NOT NULL) THEN DATE1=cast(MOIS1||'/'||JOUR1||'/'||AN1 as date);
  IMOIS=MOIS1;
  IAN=AN1;
  DDATE=DATE1;
  IF (TYPE_TOKEN1 IN(14,15,18)) THEN
    BEGIN
      IMOIS_FIN=MOIS1;
      IAN_FIN=AN1;
      DDATE_FIN=DATE1;
    END
  IF (TYPE_TOKEN1 IN(17,18)) THEN
    BEGIN
      IDATE1=AN1*10000+
             COALESCE(MOIS1,0)*100+
             COALESCE(JOUR1,0);
    END
  IF (STRLEN(RESTE)>0) THEN --cherche deuxième date
    BEGIN
      SELECT IJOUR,IMOIS,IAN,TOKEN,TYPE_TOKEN
        FROM PROC_DATE_WRITEN_UN(:RESTE)
        INTO :JOUR2,:MOIS2,:AN2,:TOKEN2,:TYPE_TOKEN2;
      IF (AN2 IS NULL) THEN
        begin
          DATE_WRITEN_S=DATE_WRITEN;
          SUSPEND;
          EXIT;
        end
      IF (ABS(AN2)<100) THEN
        begin
          I=cast(FLOOR(AN1/100) AS INTEGER);
          IF (100*I+AN2>=AN1) THEN AN2=100*I+AN2;
          ELSE AN2=100*(I+1)+AN2;
        end
      IF (JOUR2 IS NOT NULL) THEN DATE2=cast(MOIS2||'/'||JOUR2||'/'||AN2 as date);
      IF (TYPE_TOKEN2 NOT IN(13,16,17)) THEN
        begin
          IMOIS_FIN=MOIS2;
          IAN_FIN=AN2;
          DDATE_FIN=DATE2;
        end
      IF (TYPE_TOKEN1 IN(17,18) AND TYPE_TOKEN2 IN(17,18)) THEN
        begin
          IDATE2=AN2*10000+
             COALESCE(MOIS2,0)*100+
             COALESCE(JOUR2,0);
          IF (IDATE1>IDATE2) THEN --inverser les dates de sorties
            BEGIN
              IMOIS=MOIS2;
              IAN=AN2;
              DDATE=DATE2;
              I=JOUR2;
              IMOIS_FIN=MOIS1;
              IAN_FIN=AN1;
              DDATE_FIN=DATE1;
              JOUR2=JOUR1;
              JOUR1=I;
              MOIS2=MOIS1;
              MOIS1=IMOIS;
              AN2=AN1;
              AN1=IAN;
            END
        end
    END
  IF (FORME NOT IN('LIT','NUM')) THEN
    BEGIN
      DATE_WRITEN_S=DATE_WRITEN;
      SUSPEND;
      EXIT;
    END
  IF (TYPE_TOKEN1=13 AND STRLEN(RESTE)=0) THEN
    begin
      IF (JOUR1 IS NOT NULL) THEN
        SELECT FIRST(1) TOKEN FROM REF_TOKEN_DATE
               WHERE TYPE_TOKEN=:TYPE_TOKEN1 AND SOUS_TYPE='D1'
               INTO :TOKEN;
      IF (TOKEN IS NULL AND MOIS1 IS NOT NULL) THEN
        SELECT FIRST(1) TOKEN FROM REF_TOKEN_DATE
               WHERE TYPE_TOKEN=:TYPE_TOKEN1 AND SOUS_TYPE='M1'
               INTO :TOKEN;
      IF (TOKEN IS NULL AND AN1 IS NOT NULL) THEN
        SELECT FIRST(1) TOKEN FROM REF_TOKEN_DATE
               WHERE TYPE_TOKEN=:TYPE_TOKEN1 AND SOUS_TYPE='Y1'
               INTO :TOKEN;
      IF (TOKEN IS NOT NULL) THEN
        TOKEN1=TOKEN;
    end
  DATE_WRITEN_S=COALESCE(TOKEN1||' ','');
  IF (JOUR1<10 AND FORME='NUM') THEN --ajouter 0 devant
    SJOUR='0'||cast(JOUR1 as varchar(1));
  ELSE
    SJOUR=cast(JOUR1 as varchar(2));
  IF (ABS(AN1)<100 AND FORME='NUM') THEN
    begin
      CH='0'; --ajouter 0 devant
      IF (ABS(AN1)<10) THEN  CH='00';--ajouter 00 devant
      IF (AN1<0) THEN
        SAN='-'||CH||CAST(ABS(AN1) AS varchar(2));
      ELSE
        SAN=CH||CAST(ABS(AN1) AS varchar(2));
    end
  ELSE
    SAN=cast(AN1 as varchar(5));
  IF (FORME='LIT') THEN
    begin
      SELECT FIRST(1) TOKEN FROM REF_TOKEN_DATE
           WHERE TYPE_TOKEN=:MOIS1 INTO :SMOIS;
      SEPARATEUR=' ';
    end
  ELSE
    begin
      IF (MOIS1<10) THEN --ajouter 0 devant
        SMOIS='0'||cast(MOIS1 as varchar(1));
      ELSE
        SMOIS=cast(MOIS1 as varchar(2));
      SELECT FIRST(1) TOKEN FROM REF_TOKEN_DATE
           WHERE TYPE_TOKEN=22 INTO :SEPARATEUR;
    end
  I=0;
  WHILE (I<3 AND I<STRLEN(ORDRE)) DO
    BEGIN
      I=I +1;
      CH=SUBSTR(ORDRE,I,I);
      IF (I<3) THEN
        IF (CH ='D') then
          begin
            IF (SJOUR IS NOT NULL) THEN DATE_WRITEN_S=DATE_WRITEN_S||SJOUR||SEPARATEUR;
          end
        ELSE IF (CH='M') then
          begin
            IF (SMOIS IS NOT NULL) THEN DATE_WRITEN_S=DATE_WRITEN_S||SMOIS||SEPARATEUR;
          end
            ELSE DATE_WRITEN_S=DATE_WRITEN_S||SAN||SEPARATEUR;
      ELSE
        IF (CH ='D') then
          begin
            IF (SJOUR IS NOT NULL) THEN DATE_WRITEN_S=DATE_WRITEN_S||SJOUR;
          end
        ELSE IF (CH='M') then
          begin
            IF (SMOIS IS NOT NULL) THEN DATE_WRITEN_S=DATE_WRITEN_S||SMOIS;
          end
            ELSE DATE_WRITEN_S=DATE_WRITEN_S||SAN;
    END
  IF (STRLEN(RESTE)=0) THEN --pas de deuxième date
    BEGIN
      SUSPEND;
      EXIT;
    END
  SJOUR=NULL;
  SMOIS=NULL;
  SAN=NULL;
  DATE_WRITEN_S=DATE_WRITEN_S||' ';
  IF (TOKEN2 IS NOT NULL) THEN DATE_WRITEN_S=DATE_WRITEN_S||TOKEN2||' ';
  IF (JOUR2<10 AND FORME='NUM') THEN --ajouter 0 devant
    SJOUR='0'||cast(JOUR2 as varchar(1));
  ELSE
    SJOUR=cast(JOUR2 as varchar(2));
  IF (ABS(AN2)<100 AND FORME='NUM') THEN
    begin
      CH='0'; --ajouter 0 devant
      IF (ABS(AN2)<10) THEN  CH='00';--ajouter 00 devant
      IF (AN2<0) THEN
        SAN='-'||CH||CAST(ABS(AN2) AS varchar(2));
      ELSE
        SAN=CH||CAST(ABS(AN2) AS varchar(2));
    end
  ELSE
    SAN=cast(AN2 as varchar(5));
  IF (FORME='LIT') THEN
    begin
      SELECT FIRST(1) TOKEN FROM REF_TOKEN_DATE
           WHERE TYPE_TOKEN=:MOIS2 INTO :SMOIS;
    end
  ELSE
    begin
      IF (MOIS2<10) THEN --ajouter 0 devant
        SMOIS='0'||cast(MOIS2 as varchar(1));
      ELSE
        SMOIS=cast(MOIS2 as varchar(2));
    end
  I=0;
  WHILE (I<3 AND I<STRLEN(ORDRE)) DO
    BEGIN
      I=I +1;
      CH=SUBSTR(ORDRE,I,I);
      IF (I<3) THEN
        IF (CH ='D') then
          begin
            IF (SJOUR IS NOT NULL) THEN DATE_WRITEN_S=DATE_WRITEN_S||SJOUR||SEPARATEUR;
          end
        ELSE IF (CH='M') then
          begin
            IF (SMOIS IS NOT NULL) THEN DATE_WRITEN_S=DATE_WRITEN_S||SMOIS||SEPARATEUR;
          end
            ELSE DATE_WRITEN_S=DATE_WRITEN_S||SAN||SEPARATEUR;
      ELSE
        IF (CH ='D') then
          begin
            IF (SJOUR IS NOT NULL) THEN DATE_WRITEN_S=DATE_WRITEN_S||SJOUR;
          end
        ELSE IF (CH='M') then
          begin
            IF (SMOIS IS NOT NULL) THEN DATE_WRITEN_S=DATE_WRITEN_S||SMOIS;
          end
            ELSE DATE_WRITEN_S=DATE_WRITEN_S||SAN;
    END
  SUSPEND;
end ^
COMMIT WORK^

ALTER PROCEDURE "PROC_VILLES_FAVORIS" 
(
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "EV_IND_VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "EV_IND_CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "EV_IND_DEPT" VARCHAR(30) CHARACTER SET ISO8859_1,
  "EV_IND_REGION" VARCHAR(50) CHARACTER SET ISO8859_1,
  "EV_IND_PAYS" VARCHAR(30) CHARACTER SET ISO8859_1,
  "EV_IND_INSEE" VARCHAR(6) CHARACTER SET ISO8859_1
)
AS
BEGIN
    SUSPEND;
END^
COMMIT WORK^

ALTER PROCEDURE "PROC_LR_SEL_GROUPE" 
(
  "I_DOSSIER" INTEGER,
  "I_GROUPE" INTEGER,
  "I_INDIVIDU" INTEGER,
  "I_CONJOINT" INTEGER,
  "I_NB_GENERATIONS" INTEGER,
  "I_MODE" INTEGER,
  "I_TYPE_MAJ" INTEGER
)
RETURNS
(
  "O_NB_AJOUT" INTEGER,
  "O_NB_GENERATIONS" INTEGER
)
AS
DECLARE VARIABLE CONJOINT INTEGER;
DECLARE VARIABLE NOMBRE INTEGER;
DECLARE VARIABLE FICHE INTEGER;
DECLARE VARIABLE PERE INTEGER;
DECLARE VARIABLE MERE INTEGER;
DECLARE VARIABLE ENFANT INTEGER;
DECLARE VARIABLE CONTINUER INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Laurent Robbe. Tout droits réservés.
   Créé le : 03/08/2003
   à : 19:14:10
   Modifiée le :25/05/2006 par André, erreur si I_MODE=2
   à : :
   par :
   Description : Cette procédure permet de sélectionner les ascendants et/ou
                 les descendants d'un individu. La liste des individus
                 sélectionnés se retrouve dans la table T_GROUPES. On peut
                 sélectionner un individu seul, ses ascendants sur n
                 générations, ses descendants sur n générations, ses
                 ascendants et descendants sur n générations.
                 Cette procédure peut être appelée plusieurs fois de suite :
                 l'action pourra alors porter sur les personnes déjà dans le
                 groupe sélectionné (si I_TYPE_MAJ=1)
   Usage       :
     I_DOSSIER        : Dossier
     I_GROUPE         : Numéro de groupe (permet de sélectionner plusieurs
                        groupes)
     I_INDIVIDU       : Individu central
                        en mode ajout, peut être égal à zéro. Dans ce cas, on
                        ajoutera uniquement les ascendants ou descendants aux
                        individus déjà trouvés
     I_CONJOINT       : Faut-il ajouter les conjoints
                        0 = ignorer les conjoints
                        1 = ajouter les conjoints
     I_NB_GENERATIONS : Nombre de générations à inclure (0 = l'individu
                        uniquement)
                        A noter que si I_MODE=2, pour inclure les frères et
                        soeurs, il faut I_NB_GENERATIONS=2 (parents, puis
                        enfants des parents). On aura donc aussi les
                        grand-parents.
                        Ceci signifie aussi que quand on choisi les 2 sens
                        sur n générations, on a les ascendants et descendants
                        directs sur n générations, les ascendants et descendants
                        des parents et des enfants sur n-1 générations, ...

     I_MODE           : Recherche des ascendants ou des descendants
                        0 = recherche des ascendants
                        1 = recherche des descendants
                        2 = recherche des ascendants et des descendants
     I_TYPE_MAJ       : indique si on écrase la sélection courante ou si on
                        la complète
                        0 = réinitialisation
                        1 = ajout
   ---------------------------------------------------------------------------*/

  if (I_TYPE_MAJ=0) then
    delete from t_groupes where cle_groupe = :I_GROUPE;

  O_NB_GENERATIONS = 0;
  O_NB_AJOUT=0;

  /* Ajout de l'individu s'il est renseigné et s'il n'est pas déjà présent
     dans le groupe  */
  if (I_INDIVIDU <> 0) then begin
    select count(0) from t_groupes
    where  kle_dossier = :I_DOSSIER
    and    cle_groupe  = :I_GROUPE
    and    cle_fiche   = :I_INDIVIDU
    into :NOMBRE;
    if (NOMBRE<=0) then begin
      insert into t_groupes
      values (:I_DOSSIER, :I_GROUPE, :I_INDIVIDU, 0, 0);
      O_NB_AJOUT = O_NB_AJOUT + 1;
    end

    /* Ajout du conjoint de l'individu si besoin  */
    if (I_CONJOINT=1) then begin
      for select union_mari  from t_union
      where kle_dossier = :I_DOSSIER
      and union_femme = :I_INDIVIDU
      and union_mari is not null
      union
          select union_femme from t_union
      where kle_dossier = :I_DOSSIER
      and union_mari = :I_INDIVIDU
      and union_femme is not null
      into :CONJOINT
      do begin
        select count(0) from t_groupes
        where  kle_dossier = :I_DOSSIER
        and    cle_groupe  = :I_GROUPE
        and    cle_fiche   = :CONJOINT
        into :NOMBRE;
        if (NOMBRE<=0) then begin
          insert into t_groupes
          values (:I_DOSSIER, :I_GROUPE, :CONJOINT, 0, 0);
        end
      end
    end
  end

  CONTINUER=1;
  while ((O_NB_GENERATIONS < I_NB_GENERATIONS) and (continuer=1)) do begin
    /* utilisation de la table technique tq_ascend_descend pour
       base de travail */
    delete from tq_ascend_descend;
    CONTINUER=0;
    /* Recherche des ascendants  */
    if ((I_MODE=0) or (I_MODE=2)) then begin
      for select cle_fiche from t_groupes
      where kle_dossier   = :i_dossier
      and   cle_groupe    = :i_groupe
      and   top_ascendant = 0
      into :FICHE
      do begin
        select cle_pere, cle_mere
        from individu
        where kle_dossier = :i_dossier
        and   cle_fiche   = :FICHE
        into :PERE, :MERE;
        if (PERE is not null) then begin
          insert into tq_ascend_descend
          values (0, :PERE);
          /* Ajout du conjoint de l'individu si besoin  */
          if (I_CONJOINT=1) then begin
            for select union_femme from t_union
            where kle_dossier = :I_DOSSIER
            and union_mari = :PERE
            and union_femme is not null
            into :CONJOINT
            do begin
              insert into tq_ascend_descend
              values (0, :CONJOINT);
            end
          end
        end

        if (MERE is not null) then begin
          insert into tq_ascend_descend
          values (0, :MERE);
          /* Ajout du conjoint de l'individu si besoin  */
          if (I_CONJOINT=1) then begin
            for select union_mari from t_union
            where kle_dossier = :I_DOSSIER
            and union_femme = :MERE
            and union_mari is not null
            into :CONJOINT
            do begin
              insert into tq_ascend_descend
              values (0, :CONJOINT);
            end
          end
        end
      end
      update t_groupes
      set   top_ascendant = 1
      where kle_dossier   = :i_dossier
      and   cle_groupe    = :I_GROUPE
      and   top_ascendant = 0;

      /* Recopie de la table technique dans la table groupe  */
      for select cle_fiche
      from tq_ascend_descend
      into :FICHE
      do begin
        select count(0)
        from t_groupes
        where kle_dossier=:I_DOSSIER
        and   cle_groupe =:I_GROUPE
        and   cle_fiche  =:FICHE
        into :NOMBRE;
        if (NOMBRE<=0) then begin
          insert into t_groupes
          values (:I_DOSSIER, :I_GROUPE, :FICHE, 0, 0);
          O_NB_AJOUT = O_NB_AJOUT + 1;
        end
      end

      select count(0)
      from t_groupes
      where kle_dossier=:I_DOSSIER
      and   cle_groupe=:I_GROUPE
      and   top_ascendant = 0
      into :NOMBRE;
      if (NOMBRE>0) then continuer=1;
      O_NB_GENERATIONS=O_NB_GENERATIONS+1;
    end

    /* Recherche des descendants  */
    if ((I_MODE=1) or (I_MODE=2)) then begin
      for select cle_fiche from t_groupes
      where kle_dossier   = :i_dossier
      and   cle_groupe    = :i_groupe
      and   top_descendant = 0
      into :FICHE
      do begin
        for select cle_fiche
        from individu
        where kle_dossier = :i_dossier
        and ((cle_pere    = :FICHE)
          or (cle_mere    = :FICHE))
        into :ENFANT
        do begin
          insert into tq_ascend_descend
          values (0, :ENFANT);
        end
      end
      update t_groupes
      set   top_descendant = 1
      where kle_dossier   = :i_dossier
      and   cle_groupe    = :I_GROUPE
      and   top_descendant = 0;

      /* Recopie de la table technique dans la table groupe  */
      for select cle_fiche
      from tq_ascend_descend
      into :FICHE
      do begin
        select count(0)
        from t_groupes
        where kle_dossier=:I_DOSSIER
        and   cle_groupe =:I_GROUPE
        and   cle_fiche  =:FICHE
        into :NOMBRE;
        if (NOMBRE<=0) then begin
          insert into t_groupes
          values (:I_DOSSIER, :I_GROUPE, :FICHE, 0, 0);
          O_NB_AJOUT = O_NB_AJOUT + 1;
        end
      end

      select count(0)
      from t_groupes
      where kle_dossier=:I_DOSSIER
      and   cle_groupe=:I_GROUPE
      and   top_descendant = 0
      into :NOMBRE;
      if (NOMBRE>0) then continuer=1;
      O_NB_GENERATIONS=O_NB_GENERATIONS+1;
    end
  end
  O_NB_GENERATIONS=O_NB_GENERATIONS-1;
  suspend;
end ^
COMMIT WORK^

ALTER PROCEDURE "PROC_COMPTE_ONGLETS" 
(
  "IDOSSIER" INTEGER,
  "ICLEF" INTEGER
)
RETURNS
(
  "COMBIEN" INTEGER,
  "TITRE" VARCHAR(5) CHARACTER SET ISO8859_1
)
AS
BEGIN
    SUSPEND;
END ^
COMMIT WORK^

ALTER TRIGGER "TBI_ADRESSES_IND"
ACTIVE BEFORE INSERT POSITION 0
as
BEGIN
/* Créé par André le 18/11/2005 pour mettre à jour les dates
modifié le 01/06/2006, ajout des mois et normalisation date*/
  SELECT IMOIS,IAN,DDATE,IMOIS_FIN,IAN_FIN,DDATE_FIN,DATE_WRITEN_S
    FROM PROC_DATE_WRITEN(NEW.ADR_DATE_WRITEN)
    INTO NEW.ADR_DATE_MOIS_1,NEW.ADR_DATE_YEAR_1,NEW.ADR_DATE_1,
         NEW.ADR_DATE_MOIS_2,NEW.ADR_DATE_YEAR_2,NEW.ADR_DATE_2,
         NEW.ADR_DATE_WRITEN;
END
 ^
COMMIT WORK^

ALTER TRIGGER "TBU_ADRESSES_IND"
ACTIVE BEFORE UPDATE POSITION 0
as
BEGIN
/* Créé par André le 18/11/2005 pour mettre à jour les dates
modifié le 01/06/2006, ajout des mois et normalisation date*/
IF ((NEW.ADR_DATE_WRITEN <> OLD.ADR_DATE_WRITEN) or
    (NEW.ADR_DATE_WRITEN IS NULL AND OLD.ADR_DATE_WRITEN IS NOT NULL) or
    (NEW.ADR_DATE_WRITEN IS NOT NULL AND OLD.ADR_DATE_WRITEN IS NULL)) THEN
BEGIN
  SELECT IMOIS,IAN,DDATE,IMOIS_FIN,IAN_FIN,DDATE_FIN,DATE_WRITEN_S
    FROM PROC_DATE_WRITEN(NEW.ADR_DATE_WRITEN)
    INTO NEW.ADR_DATE_MOIS_1,NEW.ADR_DATE_YEAR_1,NEW.ADR_DATE_1,
         NEW.ADR_DATE_MOIS_2,NEW.ADR_DATE_YEAR_2,NEW.ADR_DATE_2,
         NEW.ADR_DATE_WRITEN;
END
END
 ^
COMMIT WORK^

ALTER TRIGGER "EVENEMENTS_FAM_BI"
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
exit; END
 ^
COMMIT WORK^

ALTER TRIGGER "TBU_EVENEMENTS_FAM"
ACTIVE BEFORE UPDATE POSITION 0
as
BEGIN
exit; END
 ^
COMMIT WORK^

ALTER TRIGGER "TBU_EVENEMENTS_IND"
ACTIVE BEFORE UPDATE POSITION 0
as
BEGIN
exit; END
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_MAJ_FORME_DATE" 
(
  "FORME" CHAR(3) CHARACTER SET ISO8859_1,
  "MODE_MAJ" INTEGER
)
AS
/*Procédure créée par André le 01/06/2006 pour mettre à jour les dates dans la base,
définir la forme littéraire, numérique ou inchangée que doit prendre la date saisie.
Le TYPE_TOKEN 24 de la table REF_TOKEN_DATE correspondant à la forme est mis à jour.
FORME ne peut être que LIT, NUM ou NON.
MODE_MAJ =0 ne modifie que la table REF_TOKEN_DATE
          1 met a jour la table REF_TOKEN_DATE et les dates du dossier
          2 met en plus à jour les dates saisies avec la forme choisie*/
declare variable SFORME varchar(30);
declare variable I INTEGER;
declare variable LANGUE varchar(3);
declare variable CLEF INTEGER;
declare variable DATE_WRITEN varchar(100);
declare variable IMOIS INTEGER;
declare variable IAN INTEGER;
declare variable DDATE DATE;
declare variable IMOIS_FIN INTEGER;
declare variable IAN_FIN INTEGER;
declare variable DDATE_FIN DATE;
declare variable DATE_WRITEN_S varchar(100);
begin
  FORME=upper(FORME);
  if (FORME NOT IN('LIT','NUM','NON') or MODE_MAJ NOT IN(0,1,2)) then EXIT;
  SELECT FIRST(1) TOKEN
        FROM REF_TOKEN_DATE
        WHERE TYPE_TOKEN=24
        INTO :SFORME;
  IF (SFORME IS NULL) THEN
    begin
      SELECT MAX(ID)+1 FROM REF_TOKEN_DATE INTO :I;
      I=gen_id(gen_token_date,I-gen_id(gen_token_date,0));
      SELECT FIRST(1) LANGUE
             FROM REF_TOKEN_DATE
             INTO :LANGUE;
      INSERT INTO REF_TOKEN_DATE (ID,TYPE_TOKEN,LANGUE,TOKEN)
             VALUES(:I,24,:LANGUE,:FORME);
    end
  ELSE
    UPDATE REF_TOKEN_DATE SET TOKEN=:FORME
           WHERE TYPE_TOKEN=24;
  IF (MODE_MAJ<1) THEN EXIT;
  FOR SELECT ADR_CLEF,ADR_DATE_WRITEN
             FROM ADRESSES_IND
             INTO :CLEF,:DATE_WRITEN
    DO
    begin
      SELECT IMOIS,IAN,DDATE,IMOIS_FIN,IAN_FIN,DDATE_FIN,DATE_WRITEN_S
            FROM PROC_DATE_WRITEN(:DATE_WRITEN)
            INTO :IMOIS,:IAN,:DDATE,:IMOIS_FIN,:IAN_FIN,:DDATE_FIN,:DATE_WRITEN_S;
      IF (MODE_MAJ=2) THEN
        UPDATE ADRESSES_IND
         SET ADR_DATE_MOIS_1=:IMOIS,
             ADR_DATE_YEAR_1=:IAN,
             ADR_DATE_1=:DDATE,
             ADR_DATE_MOIS_2=:IMOIS_FIN,
             ADR_DATE_YEAR_2=:IAN_FIN,
             ADR_DATE_2=:DDATE_FIN,
             ADR_DATE_WRITEN=:DATE_WRITEN_S
         WHERE ADR_CLEF=:CLEF;
       ELSE
        UPDATE ADRESSES_IND
         SET ADR_DATE_MOIS_1=:IMOIS,
             ADR_DATE_YEAR_1=:IAN,
             ADR_DATE_1=:DDATE,
             ADR_DATE_MOIS_2=:IMOIS_FIN,
             ADR_DATE_YEAR_2=:IAN_FIN,
             ADR_DATE_2=:DDATE_FIN
         WHERE ADR_CLEF=:CLEF;
    end
  FOR SELECT EV_FAM_CLEF,EV_FAM_DATE_WRITEN
             FROM EVENEMENTS_FAM
             INTO :CLEF,:DATE_WRITEN
    DO
    begin
      SELECT IMOIS,IAN,DDATE,IMOIS_FIN,IAN_FIN,DDATE_FIN,DATE_WRITEN_S
            FROM PROC_DATE_WRITEN(:DATE_WRITEN)
            INTO :IMOIS,:IAN,:DDATE,:IMOIS_FIN,:IAN_FIN,:DDATE_FIN,:DATE_WRITEN_S;
      IF (MODE_MAJ=2) THEN
        UPDATE EVENEMENTS_FAM
         SET EV_FAM_DATE_MOIS=:IMOIS,
             EV_FAM_DATE_YEAR=:IAN,
             EV_FAM_DATE=:DDATE,
             EV_FAM_DATE_MOIS_FIN=:IMOIS_FIN,
             EV_FAM_DATE_YEAR_FIN=:IAN_FIN,
             EV_FAM_DATE_FIN=:DDATE_FIN,
             EV_FAM_DATE_WRITEN=:DATE_WRITEN_S
         WHERE EV_FAM_CLEF=:CLEF;
       ELSE
        UPDATE EVENEMENTS_FAM
         SET EV_FAM_DATE_MOIS=:IMOIS,
             EV_FAM_DATE_YEAR=:IAN,
             EV_FAM_DATE=:DDATE,
             EV_FAM_DATE_MOIS_FIN=:IMOIS_FIN,
             EV_FAM_DATE_YEAR_FIN=:IAN_FIN,
             EV_FAM_DATE_FIN=:DDATE_FIN
         WHERE EV_FAM_CLEF=:CLEF;
    end
  FOR SELECT EV_IND_CLEF,EV_IND_DATE_WRITEN
             FROM EVENEMENTS_IND
             INTO :CLEF,:DATE_WRITEN
    DO
    begin
      SELECT IMOIS,IAN,DDATE,IMOIS_FIN,IAN_FIN,DDATE_FIN,DATE_WRITEN_S
            FROM PROC_DATE_WRITEN(:DATE_WRITEN)
            INTO :IMOIS,:IAN,:DDATE,:IMOIS_FIN,:IAN_FIN,:DDATE_FIN,:DATE_WRITEN_S;
      IF (MODE_MAJ=2) THEN
        UPDATE EVENEMENTS_IND
         SET EV_IND_DATE_MOIS=:IMOIS,
             EV_IND_DATE_YEAR=:IAN,
             EV_IND_DATE=:DDATE,
             EV_IND_DATE_MOIS_FIN=:IMOIS_FIN,
             EV_IND_DATE_YEAR_FIN=:IAN_FIN,
             EV_IND_DATE_FIN=:DDATE_FIN,
             EV_IND_DATE_WRITEN=:DATE_WRITEN_S
         WHERE EV_IND_CLEF=:CLEF;
       ELSE
        UPDATE EVENEMENTS_IND
         SET EV_IND_DATE_MOIS=:IMOIS,
             EV_IND_DATE_YEAR=:IAN,
             EV_IND_DATE=:DDATE,
             EV_IND_DATE_MOIS_FIN=:IMOIS_FIN,
             EV_IND_DATE_YEAR_FIN=:IAN_FIN,
             EV_IND_DATE_FIN=:DDATE_FIN
         WHERE EV_IND_CLEF=:CLEF;
    end
end
 ^
COMMIT WORK^

/* script pour modifier les BLOB SUB_TYPE 2 en SUB_TYPE 0  */
ALTER TABLE DIVERS
ADD "DIV_IMAGEB"	 BLOB SUB_TYPE 0 SEGMENT SIZE 1,
ADD "DIV_REDUITEB"	 BLOB SUB_TYPE 0 SEGMENT SIZE 1,
ADD "DIV_DEVISEB"	 BLOB SUB_TYPE 0 SEGMENT SIZE 1,
ADD "DIV_DOCUMENTB"	 BLOB SUB_TYPE 0 SEGMENT SIZE 1,
ADD "DIV_CRIB"	 BLOB SUB_TYPE 0 SEGMENT SIZE 1^
COMMIT WORK^

UPDATE DIVERS
SET DIV_IMAGEB = DIV_IMAGE,
 DIV_REDUITEB = DIV_REDUITE,
 DIV_DEVISEB = DIV_DEVISE,
 DIV_DOCUMENTB = DIV_DOCUMENT,
 DIV_CRIB = DIV_CRI^
COMMIT WORK^

ALTER TABLE DIVERS
DROP DIV_IMAGE,
DROP DIV_REDUITE,
DROP DIV_DEVISE,
DROP DIV_DOCUMENT,
DROP DIV_CRI^
COMMIT WORK^

ALTER TABLE DIVERS
ALTER COLUMN DIV_IMAGEB TO DIV_IMAGE,
ALTER COLUMN DIV_IMAGE POSITION 7,
ALTER COLUMN DIV_REDUITEB TO DIV_REDUITE,
ALTER COLUMN DIV_REDUITE POSITION 8,
ALTER COLUMN DIV_DEVISEB TO DIV_DEVISE,
ALTER COLUMN DIV_DEVISE POSITION 9,
ALTER COLUMN DIV_DOCUMENTB TO DIV_DOCUMENT,
ALTER COLUMN DIV_DOCUMENT POSITION 10,
ALTER COLUMN DIV_CRIB TO DIV_CRI^
COMMIT WORK^

ALTER TABLE MULTIMEDIA_RECORD
ADD "X_IMAGEB"	 BLOB SUB_TYPE 0 SEGMENT SIZE 1,
ADD "X_VIGNETTEB"	 BLOB SUB_TYPE 0 SEGMENT SIZE 1^
COMMIT WORK^

UPDATE MULTIMEDIA_RECORD
SET X_IMAGEB = X_IMAGE,
 X_VIGNETTEB = X_VIGNETTE^
COMMIT WORK^

ALTER TABLE MULTIMEDIA_RECORD
DROP X_IMAGE,
DROP X_VIGNETTE^
COMMIT WORK^

ALTER TABLE MULTIMEDIA_RECORD
ALTER COLUMN X_IMAGEB TO X_IMAGE,
ALTER COLUMN X_IMAGE POSITION 5,
ALTER COLUMN X_VIGNETTEB TO X_VIGNETTE,
ALTER COLUMN X_VIGNETTE POSITION 6^
COMMIT WORK^

/*désactivation de procédures utilisant les champs de MULTIMEDIA modifiés*/
ALTER PROCEDURE "PROC_CHARGE_MEDIA" 
(
  "STABLE" CHAR(1) CHARACTER SET ISO8859_1,
  "IDOSSIER" INTEGER
)
RETURNS
(
  "MULTI_CLEF" INTEGER,
  "MULTI_INDIVIDU" INTEGER,
  "MULTI_INFOS" VARCHAR(53) CHARACTER SET ISO8859_1,
  "MULTI_MEDIA" BLOB,
  "MULTI_DOSSIER" INTEGER,
  "MULTI_DATE_MODIF" TIMESTAMP,
  "MULTI_MEMO" BLOB,
  "MULTI_STRETCH" INTEGER,
  "MULTI_IDENTITE" INTEGER,
  "MULTI_TYPE" CHAR(1) CHARACTER SET ISO8859_1,
  "MULTI_REDUITE" BLOB,
  "MULTI_DEVISE" BLOB,
  "MULTI_CRI" BLOB,
  "MULTI_DOCRTF" BLOB,
  "MULTI_IMAGE_RTF" INTEGER,
  "MULTI_NUM_ACTE" INTEGER,
  "MULTI_TYPE_ACTE" CHAR(1) CHARACTER SET ISO8859_1,
  "MULTI_SONS_VIDEOS" BLOB,
  "MULTI_PATH" VARCHAR(255) CHARACTER SET ISO8859_1,
  "MULTI_NOM" VARCHAR(255) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend; END ^
COMMIT WORK^
ALTER PROCEDURE "PROC_DER_PHOTO" 
(
  "I_CLE" INTEGER
)
RETURNS
(
  "MULTI_REDUITE" BLOB
)
AS
BEGIN suspend; END ^
COMMIT WORK^
ALTER PROCEDURE "PROC_ETAT_FICHE" 
(
  "I_CLEF" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(210) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(210) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "COMMENT" BLOB,
  "PERE_NOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "PERE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "PERE_LIEU_NAISSANCE" VARCHAR(210) CHARACTER SET ISO8859_1,
  "PERE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "PERE_LIEU_DECES" VARCHAR(210) CHARACTER SET ISO8859_1,
  "MERE_NOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "MERE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "MERE_LIEU_NAISSANCE" VARCHAR(210) CHARACTER SET ISO8859_1,
  "MERE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "MERE_LIEU_DECES" VARCHAR(210) CHARACTER SET ISO8859_1,
  "PHOTO" BLOB,
  "PREFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "SUFFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "NUM_SOSA" DOUBLE PRECISION
)
AS
BEGIN suspend; END ^
COMMIT WORK^
ALTER PROCEDURE "PROC_ETAT_FICHE_FAMILIALE" 
(
  "ACLE_UNION" INTEGER
)
RETURNS
(
  "A_TYPE_UNION" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_EPOUX_CLE" INTEGER,
  "A_EPOUX_NOMPRENOM" VARCHAR(105) CHARACTER SET ISO8859_1,
  "A_EPOUX_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "A_EPOUX_LIEU_NAISSANCE" VARCHAR(61) CHARACTER SET ISO8859_1,
  "A_EPOUX_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "A_EPOUX_LIEU_DECES" VARCHAR(61) CHARACTER SET ISO8859_1,
  "A_EPOUSE_CLE" INTEGER,
  "A_EPOUSE_NOMPRENOM" VARCHAR(105) CHARACTER SET ISO8859_1,
  "A_EPOUSE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "A_EPOUSE_LIEU_NAISSANCE" VARCHAR(61) CHARACTER SET ISO8859_1,
  "A_EPOUSE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "A_EPOUSE_LIEU_DECES" VARCHAR(61) CHARACTER SET ISO8859_1,
  "A_EPOUX_PHOTO" BLOB,
  "A_EPOUSE_PHOTO" BLOB,
  "A_EPOUX_PERE_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_EPOUX_PERE_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "A_EPOUX_MERE_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_EPOUX_MERE_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "A_EPOUSE_PERE_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_EPOUSE_PERE_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "A_EPOUSE_MERE_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_EPOUSE_MERE_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "A_EPOUX_ANNEE" INTEGER,
  "A_EPOUSE_ANNEE" INTEGER,
  "A_EPOUX_AGE_DECES" INTEGER,
  "A_EPOUSE_AGE_DECES" INTEGER,
  "A_EPOUX_SOSA" DOUBLE PRECISION,
  "A_EPOUSE_SOSA" DOUBLE PRECISION
)
AS
BEGIN suspend; END ^
COMMIT WORK^
ALTER PROCEDURE "PROC_TROUVE_MULTIMEDIA" 
(
  "I_INDI" INTEGER,
  "S_TYPE" CHAR(1) CHARACTER SET ISO8859_1
)
RETURNS
(
  "MULTI_INFOS" VARCHAR(53) CHARACTER SET ISO8859_1,
  "MULTI_MEDIA" BLOB,
  "MULTI_MEDIA_NORMALE" BLOB,
  "MULTI_MEMO" BLOB
)
AS
BEGIN suspend; END ^
COMMIT WORK^

ALTER TABLE MULTIMEDIA
ADD "MULTI_REDUITEB"	 BLOB SUB_TYPE 0 SEGMENT SIZE 1,
ADD "MULTI_DOCRTFB"	 BLOB SUB_TYPE 0 SEGMENT SIZE 1,
ADD "MULTI_SONS_VIDEOSB"	 BLOB SUB_TYPE 0 SEGMENT SIZE 1^
COMMIT WORK^

UPDATE MULTIMEDIA
SET MULTI_REDUITEB = MULTI_REDUITE,
 MULTI_DOCRTFB = MULTI_DOCRTF,
 MULTI_SONS_VIDEOSB = MULTI_SONS_VIDEOS^
COMMIT WORK^

ALTER TABLE MULTIMEDIA
DROP MULTI_REDUITE,
DROP MULTI_DOCRTF,
DROP MULTI_SONS_VIDEOS^
COMMIT WORK^

ALTER TABLE MULTIMEDIA
ALTER COLUMN MULTI_REDUITEB TO MULTI_REDUITE,
ALTER COLUMN MULTI_REDUITE POSITION 11,
ALTER COLUMN MULTI_DOCRTFB TO MULTI_DOCRTF,
ALTER COLUMN MULTI_DOCRTF POSITION 14,
ALTER COLUMN MULTI_SONS_VIDEOSB TO MULTI_SONS_VIDEOS,
ALTER COLUMN MULTI_SONS_VIDEOS POSITION 18^
COMMIT WORK^

/*réactivation de procédures utilisant les champs de MULTIMEDIA modifiés*/
ALTER PROCEDURE "PROC_ETAT_FICHE" 
(
  "I_CLEF" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(210) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(210) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "COMMENT" BLOB,
  "PERE_NOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "PERE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "PERE_LIEU_NAISSANCE" VARCHAR(210) CHARACTER SET ISO8859_1,
  "PERE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "PERE_LIEU_DECES" VARCHAR(210) CHARACTER SET ISO8859_1,
  "MERE_NOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "MERE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "MERE_LIEU_NAISSANCE" VARCHAR(210) CHARACTER SET ISO8859_1,
  "MERE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "MERE_LIEU_DECES" VARCHAR(210) CHARACTER SET ISO8859_1,
  "PHOTO" BLOB,
  "PREFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "SUFFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "NUM_SOSA" DOUBLE PRECISION
)
AS
begin
suspend;
end
 ^
COMMIT WORK^
ALTER PROCEDURE "PROC_ETAT_FICHE_FAMILIALE" 
(
  "ACLE_UNION" INTEGER
)
RETURNS
(
  "A_TYPE_UNION" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_EPOUX_CLE" INTEGER,
  "A_EPOUX_NOMPRENOM" VARCHAR(105) CHARACTER SET ISO8859_1,
  "A_EPOUX_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "A_EPOUX_LIEU_NAISSANCE" VARCHAR(61) CHARACTER SET ISO8859_1,
  "A_EPOUX_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "A_EPOUX_LIEU_DECES" VARCHAR(61) CHARACTER SET ISO8859_1,
  "A_EPOUSE_CLE" INTEGER,
  "A_EPOUSE_NOMPRENOM" VARCHAR(105) CHARACTER SET ISO8859_1,
  "A_EPOUSE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "A_EPOUSE_LIEU_NAISSANCE" VARCHAR(61) CHARACTER SET ISO8859_1,
  "A_EPOUSE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "A_EPOUSE_LIEU_DECES" VARCHAR(61) CHARACTER SET ISO8859_1,
  "A_EPOUX_PHOTO" BLOB,
  "A_EPOUSE_PHOTO" BLOB,
  "A_EPOUX_PERE_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_EPOUX_PERE_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "A_EPOUX_MERE_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_EPOUX_MERE_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "A_EPOUSE_PERE_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_EPOUSE_PERE_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "A_EPOUSE_MERE_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "A_EPOUSE_MERE_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "A_EPOUX_ANNEE" INTEGER,
  "A_EPOUSE_ANNEE" INTEGER,
  "A_EPOUX_AGE_DECES" INTEGER,
  "A_EPOUSE_AGE_DECES" INTEGER,
  "A_EPOUX_SOSA" DOUBLE PRECISION,
  "A_EPOUSE_SOSA" DOUBLE PRECISION
)
AS
begin
        suspend;
end
 ^
COMMIT WORK^

/*mise à jour de la table REF_TOKEN_DATE avec les valeurs de la colonne SOUS_TYPE*/
DELETE FROM REF_TOKEN_DATE ^
COMMIT WORK^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'159', 	'13', 	'FRA', 	'du', 	'D')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'160', 	'1', 	'FRA', 	'janvier', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'161', 	'13', 	'FRA', 	'de', 	'M')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'162', 	'13', 	'FRA', 	'de l''an', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'163', 	'13', 	'FRA', 	'de l''année', 	'Y')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'164', 	'13', 	'FRA', 	'de l''annee', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'165', 	'2', 	'FRA', 	'février', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'166', 	'2', 	'FRA', 	'fevrier', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'167', 	'2', 	'FRA', 	'fevr', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'168', 	'2', 	'FRA', 	'févr', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'169', 	'2', 	'FRA', 	'fev', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'170', 	'3', 	'FRA', 	'mars', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'171', 	'4', 	'FRA', 	'avril', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'172', 	'4', 	'FRA', 	'avr', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'173', 	'14', 	'FRA', 	'au', 	'D')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'174', 	'14', 	'FRA', 	'à', 	'M')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'175', 	'14', 	'FRA', 	'a', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'176', 	'14', 	'FRA', 	'à l''an', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'177', 	'14', 	'FRA', 	'a l''an', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'178', 	'14', 	'FRA', 	'à l''année', 	'Y')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'179', 	'14', 	'FRA', 	'à l''annee', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'180', 	'14', 	'FRA', 	'a l''année', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'181', 	'14', 	'FRA', 	'a l''annee', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'182', 	'15', 	'FRA', 	'avant', 	'M')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'183', 	'15', 	'FRA', 	'avant le', 	'D')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'184', 	'15', 	'FRA', 	'avant l''an', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'185', 	'15', 	'FRA', 	'avant l''année', 	'Y')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'186', 	'15', 	'FRA', 	'avant l''annee', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'187', 	'16', 	'FRA', 	'après', 	'M')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'188', 	'16', 	'FRA', 	'apres', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'189', 	'16', 	'FRA', 	'apres le', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'190', 	'16', 	'FRA', 	'après le', 	'D')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'191', 	'16', 	'FRA', 	'après l''an', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'192', 	'16', 	'FRA', 	'apres l''an', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'193', 	'16', 	'FRA', 	'apres l''année', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'194', 	'16', 	'FRA', 	'après l''année', 	'Y')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'195', 	'16', 	'FRA', 	'apres l''annee', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'196', 	'16', 	'FRA', 	'après l''annee', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'197', 	'17', 	'FRA', 	'entre', 	'M')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'198', 	'17', 	'FRA', 	'entre le', 	'D')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'199', 	'18', 	'FRA', 	'et', 	'M')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'200', 	'18', 	'FRA', 	'et le', 	'D')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'201', 	'18', 	'FRA', 	'et l''année', 	'Y')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'202', 	'18', 	'FRA', 	'et l''annee', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'203', 	'18', 	'FRA', 	'et l''an', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'204', 	'19', 	'FRA', 	'cal', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'205', 	'19', 	'FRA', 	'calculée', 	'Y')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'206', 	'19', 	'FRA', 	'calculee', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'207', 	'20', 	'FRA', 	'est', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'208', 	'20', 	'FRA', 	'estimée', 	'Y')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'209', 	'20', 	'FRA', 	'estimee', 	'I')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'210', 	'21', 	'FRA', 	'vers', 	'Y')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'211', 	'21', 	'FRA', 	'vers le', 	'D')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'212', 	'22', 	'FRA', 	'/', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'213', 	'22', 	'FRA', 	'.', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'214', 	'5', 	'FRA', 	'mai', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'215', 	'6', 	'FRA', 	'juin', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'216', 	'7', 	'FRA', 	'juillet', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'217', 	'7', 	'FRA', 	'juil', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'218', 	'8', 	'FRA', 	'août', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'219', 	'8', 	'FRA', 	'aout', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'220', 	'9', 	'FRA', 	'septembre', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'221', 	'9', 	'FRA', 	'sept', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'222', 	'10', 	'FRA', 	'octobre', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'223', 	'10', 	'FRA', 	'oct', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'224', 	'11', 	'FRA', 	'novembre', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'225', 	'11', 	'FRA', 	'nov', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'226', 	'12', 	'FRA', 	'décembre', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'227', 	'12', 	'FRA', 	'decembre', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'228', 	'12', 	'FRA', 	'dec', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'229', 	'12', 	'FRA', 	'déc', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'230', 	'1', 	'FRA', 	'janv', 	NULL)^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'231', 	'13', 	'FRA', 	'depuis', 	'Y1')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'232', 	'13', 	'FRA', 	'depuis le', 	'D1')^
INSERT INTO "REF_TOKEN_DATE"	 ("ID", 	"TYPE_TOKEN", 	"LANGUE", 	"TOKEN", 	"SOUS_TYPE") VALUES (	'233', 	'17', 	'FRA', 	'entre l''année', 	'Y')^
COMMIT WORK^
EXECUTE PROCEDURE PROC_MAJ_FORME_DATE('LIT',1)^ /*met à jour les champs sans modifier date_writen*/
COMMIT WORK^

ALTER PROCEDURE "PROC_DATE_WRITEN_UN" 
(
  "DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1
)
RETURNS
(
  "IJOUR" INTEGER,
  "IMOIS" INTEGER,
  "IAN" INTEGER,
  "TOKEN" VARCHAR(30) CHARACTER SET ISO8859_1,
  "TYPE_TOKEN" INTEGER,
  "DATE_WRITEN_S" VARCHAR(100) CHARACTER SET ISO8859_1
)
AS
begin suspend; end^
commit^

ALTER PROCEDURE "PROC_DATE_WRITEN" 
(
  "DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1
)
RETURNS
(
  "IMOIS" INTEGER,
  "IAN" INTEGER,
  "DDATE" DATE,
  "IMOIS_FIN" INTEGER,
  "IAN_FIN" INTEGER,
  "DDATE_FIN" DATE,
  "DATE_WRITEN_S" VARCHAR(100) CHARACTER SET ISO8859_1
)
AS
begin suspend; end^
commit^

SET ECHO ON^
/*Passage en version 4.034*/
SET ECHO OFF^

ALTER PROCEDURE "PROC_EVE_IND" 
(
  "I_CLE" INTEGER
)
RETURNS
(
  "EV_IND_CLEF" INTEGER,
  "EV_IND_KLE_FICHE" INTEGER,
  "EV_IND_KLE_DOSSIER" INTEGER,
  "EV_IND_TYPE" VARCHAR(7) CHARACTER SET ISO8859_1,
  "EV_IND_DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1,
  "EV_IND_DATE_YEAR" INTEGER,
  "EV_IND_DATE" DATE,
  "EV_IND_ADRESSE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "EV_IND_CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "EV_IND_VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "EV_IND_DEPT" VARCHAR(30) CHARACTER SET ISO8859_1,
  "EV_IND_PAYS" VARCHAR(30) CHARACTER SET ISO8859_1,
  "EV_IND_CAUSE" VARCHAR(90) CHARACTER SET ISO8859_1,
  "EV_IND_SOURCE" BLOB,
  "EV_IND_COMMENT" BLOB,
  "EV_IND_TYPEANNEE" INTEGER,
  "EV_IND_DESCRIPTION" VARCHAR(90) CHARACTER SET ISO8859_1,
  "EV_IND_REGION" VARCHAR(50) CHARACTER SET ISO8859_1,
  "EV_IND_SUBD" VARCHAR(50) CHARACTER SET ISO8859_1,
  "EV_LIBELLE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "EV_IND_ACTE" INTEGER,
  "EV_IND_INSEE" VARCHAR(6) CHARACTER SET ISO8859_1,
  "EV_IND_HEURE" TIME,
  "EV_IND_ORDRE" INTEGER,
  "EV_IND_TITRE_EVENT" VARCHAR(40) CHARACTER SET ISO8859_1
)
AS
BEGIN
    SUSPEND;
END
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_TROUVE_UNIONS" 
(
  "I_DOSSIER" INTEGER,
  "I_CLEF" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_NAISSANCE" INTEGER,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_DECES" INTEGER,
  "SEXE" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "NUM_SOSA" DOUBLE PRECISION,
  "TYPE_UNION" INTEGER,
  "UNION_CLEF" INTEGER,
  "ANNEE_MARIAGE" INTEGER
)
AS
BEGIN
   SUSPEND;
END
 ^
COMMIT WORK^
ALTER TRIGGER "T_BU_INDIVIDU"
ACTIVE BEFORE UPDATE POSITION 0
as
begin
exit; end
 ^
COMMIT WORK ^

SET ECHO ON^
/*Passage en version 4.035

Les instructions suivantes peuvent provoquer des erreurs normales */

CREATE TRIGGER "TRIG_MULTIMEDIA_BD" FOR "MULTIMEDIA" 
ACTIVE BEFORE DELETE POSITION 0
as
/* Création par André pour fonctionnement média le 20/06/06*/
BEGIN
DELETE FROM MEDIA_POINTEURS
WHERE MP_MEDIA=OLD.MULTI_CLEF;
END
 ^
COMMIT WORK ^
/* Fin des erreurs normales*/
SET ECHO OFF^

ALTER TRIGGER "TAI_MEDIA_POINTEURS"
ACTIVE AFTER INSERT POSITION 0
as
/* Création par André pour fonctionnement média(01/10/05) modif le 20/06/06
   Double l'enregistrement pour le conjoint
   s'il est lié à un évènement familial */
DECLARE VARIABLE TTABLE char(1);
DECLARE VARIABLE DID INTEGER;
DECLARE VARIABLE MARI INTEGER;
DECLARE VARIABLE FEMME INTEGER;
DECLARE VARIABLE CONJOINT INTEGER;
DECLARE VARIABLE COMPTE INTEGER;
BEGIN
 TTABLE='I';
 IF (NEW.MP_TYPE_IMAGE = 'F') THEN  /* Déclaration par les sources */
   BEGIN                            /* Nécessite l'existence dans  */
     SELECT TYPE_TABLE,             /* SOURCES_RECORD              */
            DATA_ID
     FROM SOURCES_RECORD
     WHERE SOURCES_RECORD.ID = NEW.MP_POINTE_SUR
     INTO :TTABLE,
          :DID ;
   END
 ELSE
   IF ((NEW.MP_TYPE_IMAGE = 'A') AND (NEW.MP_TABLE = 'F')) THEN
     BEGIN
       TTABLE = 'F';
       DID = NEW.MP_POINTE_SUR;
     END
 IF (TTABLE = 'F') THEN
   BEGIN
     DELETE FROM MEDIA_POINTEURS  /* Supprime les doublons qui pourraient être
     créés par les 2 conjoints lors de la récupération d'un gedcom, on ne
     garde que les derniers*/
       WHERE MP_CLEF <> NEW.MP_CLEF AND
             MP_MEDIA = NEW.MP_MEDIA AND
             MP_CLE_INDIVIDU = NEW.MP_CLE_INDIVIDU AND
             MP_POINTE_SUR = NEW.MP_POINTE_SUR AND
             MP_TABLE = NEW.MP_TABLE AND
             MP_KLE_DOSSIER = NEW.MP_KLE_DOSSIER AND
             MP_TYPE_IMAGE = NEW.MP_TYPE_IMAGE ;
     SELECT COUNT(MP_CLEF)
     FROM MEDIA_POINTEURS
     WHERE MP_MEDIA = NEW.MP_MEDIA AND
           MP_POINTE_SUR = NEW.MP_POINTE_SUR AND
           MP_TABLE = NEW.MP_TABLE AND
           MP_KLE_DOSSIER = NEW.MP_KLE_DOSSIER AND
           MP_TYPE_IMAGE = NEW.MP_TYPE_IMAGE
     INTO  :COMPTE;
     IF (COMPTE > 1) THEN EXIT; /* enregistrement déjà créé pour conjoint*/
     SELECT U.UNION_MARI,
            U.UNION_FEMME
     FROM EVENEMENTS_FAM EV, T_UNION U
     WHERE EV.EV_FAM_CLEF = :DID
           AND U.UNION_CLEF = EV.EV_FAM_KLE_FAMILLE
     INTO :MARI,
          :FEMME;
     IF (NEW.MP_CLE_INDIVIDU = MARI)
       THEN CONJOINT = FEMME;
       ELSE IF (NEW.MP_CLE_INDIVIDU = FEMME)
              THEN CONJOINT = MARI;
              ELSE EXIT;  /* Union "orpheline" */
     INSERT INTO MEDIA_POINTEURS (MP_CLEF,
                                  MP_MEDIA,
                                  MP_CLE_INDIVIDU,
                                  MP_POINTE_SUR,
                                  MP_TABLE,
                                  MP_IDENTITE,
                                  MP_KLE_DOSSIER,
                                  MP_TYPE_IMAGE)
                           VALUES(GEN_ID(BIBLIO_POINTEURS_ID_GEN, 1),
                                  NEW.MP_MEDIA,
                                  :CONJOINT,
                                  NEW.MP_POINTE_SUR,
                                  NEW.MP_TABLE,
                                  0,
                                  NEW.MP_KLE_DOSSIER,
                                  NEW.MP_TYPE_IMAGE);
   END
END
 ^
COMMIT WORK ^

ALTER PROCEDURE "PROC_VIDE_DOSSIER" 
(
  "I_CLEF" INTEGER
)
AS
begin
  exit;
end ^
COMMIT WORK^

ALTER PROCEDURE "PROC_VIDE_BASE" 
(
  "I_CLEF" INTEGER
)
AS
begin
  exit;
end ^
COMMIT WORK^

ALTER PROCEDURE "PROC_VIDE_TABLE" 
(
  "I_CLEF" INTEGER
)
AS
begin
exit; end ^
COMMIT WORK^

ALTER TRIGGER "T_BI_INDIVIDU" 
ACTIVE BEFORE INSERT POSITION 0
as
begin
exit; end ^
COMMIT WORK^

SET ECHO ON^
/*Passage en version 4.036 - 4.037 (identique + réinstallation complète de FBembedded si utilisée).*/
SET ECHO OFF^
/* Cette partie ne devrait pas provoquer d'erreurs*/
ALTER PROCEDURE "PROC_ETAT_ECLAIR" 
(
  "I_DOSSIER" INTEGER,
  "I_PATRONYME_SORT" INTEGER,
  "I_SOSA" INTEGER,
  "A_VILLE" VARCHAR(50) CHARACTER SET ISO8859_1
)
RETURNS
(
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "PAYS" VARCHAR(30) CHARACTER SET ISO8859_1,
  "DATE_DEBUT" INTEGER,
  "DATE_FIN" INTEGER,
  "NAISSANCE" INTEGER,
  "BAPTEME" INTEGER,
  "MARIAGE" INTEGER,
  "DECES" INTEGER,
  "INSEE" VARCHAR(6) CHARACTER SET ISO8859_1
)
AS
begin suspend; end ^
COMMIT WORK^

SET ECHO ON^
/* Cette partie doit  provoquer des erreurs si la base a déjà été modifiée*/
drop index IDX_TQ_ECLAIR_DOSSIER^
COMMIT WORK^
drop index IDX_TQ_ECLAIR_MARIAGE^
COMMIT WORK^
alter table TQ_ECLAIR drop TQ_DOSSIER^
COMMIT WORK^
alter table TQ_ECLAIR drop TQ_DATE_FIN^
COMMIT WORK^
alter table TQ_ECLAIR drop TQ_PAYS_CODE^
COMMIT WORK^
alter table TQ_ECLAIR alter column TQ_DATE_DEBUT to TQ_DATE^
COMMIT WORK^
alter table TQ_ECLAIR add TQ_INSEE  VARCHAR(6) CHARACTER SET ISO8859_1^
COMMIT WORK^
alter table TQ_ECLAIR add TQ_SEPULTURE  INTEGER^
COMMIT WORK^
alter table TQ_ECLAIR add TQ_DEPT  VARCHAR(30) CHARACTER SET ISO8859_1 COLLATE FR_FR^
COMMIT WORK^
alter table TQ_ECLAIR add TQ_REGION  VARCHAR(50) CHARACTER SET ISO8859_1 COLLATE FR_FR^
COMMIT WORK^
CREATE INDEX IDX_TQ_ECLAIR_DATE ON TQ_ECLAIR(TQ_DATE)^
COMMIT WORK^
alter table REF_CP_VILLE add CP_VILLE_MAJ  VARCHAR(50) CHARACTER SET ISO8859_1^
COMMIT WORK^
CREATE INDEX IDX_REF_CP_VILLE_MAJ ON REF_CP_VILLE(CP_VILLE_MAJ)^
COMMIT WORK^
CREATE TRIGGER "BU_REF_CP_VILLE" FOR "REF_CP_VILLE" 
ACTIVE BEFORE UPDATE POSITION 0
as
begin
  exit;
end ^
COMMIT WORK ^
/*Fin des erreurs normales*/
SET ECHO OFF^

ALTER PROCEDURE "PROC_ETAT_ECLAIR" 
(
  "I_DOSSIER" INTEGER,
  "I_SOSA" INTEGER,
  "A_VILLE" VARCHAR(50) CHARACTER SET ISO8859_1
)
RETURNS
(
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "PAYS" VARCHAR(30) CHARACTER SET ISO8859_1,
  "DATE_DEBUT" INTEGER,
  "DATE_FIN" INTEGER,
  "NAISSANCE" INTEGER,
  "BAPTEME" INTEGER,
  "MARIAGE" INTEGER,
  "DECES" INTEGER,
  "SEP" INTEGER,
  "INSEE" VARCHAR(6) CHARACTER SET ISO8859_1,
  "DEPT" VARCHAR(30) CHARACTER SET ISO8859_1,
  "REGION" VARCHAR(50) CHARACTER SET ISO8859_1
)
AS
begin
          SUSPEND;
end ^
COMMIT WORK^

ALTER TRIGGER "AI_REF_CP_VILLE_CP_CODE"
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
exit;
END ^
COMMIT WORK^

ALTER PROCEDURE "PROC_TROUVE_VILLE_PAR_VILLE" 
(
  "I_VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "I_MODE" INTEGER
)
RETURNS
(
  "CODE" VARCHAR(8) CHARACTER SET ISO8859_1,
  "VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "TEL" VARCHAR(2) CHARACTER SET ISO8859_1,
  "DEPARTEMENT" VARCHAR(30) CHARACTER SET ISO8859_1,
  "REGION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "PAYS" VARCHAR(30) CHARACTER SET ISO8859_1,
  "CLEF" INTEGER,
  "CP_PREFIXE" VARCHAR(4) CHARACTER SET ISO8859_1,
  "CP_DEPT" INTEGER,
  "CP_REGION" INTEGER,
  "CP_PAYS" INTEGER,
  "CP_INSEE" VARCHAR(6) CHARACTER SET ISO8859_1,
  "CP_HABITANTS" DOUBLE PRECISION,
  "CP_DENSITE" DOUBLE PRECISION,
  "CP_DIVERS" VARCHAR(90) CHARACTER SET ISO8859_1,
  "CP_LONGITUDE" DOUBLE PRECISION,
  "CP_LATITUDE" DOUBLE PRECISION
)
AS
begin
  suspend;
end ^
COMMIT WORK^

SET ECHO ON^
/*Passage en version 4.041.*/
/* Cette partie ne devrait pas provoquer d'erreurs*/
SET ECHO OFF^

ALTER PROCEDURE "PROC_ANNIV_BIRT" 
(
  "A_MOIS" INTEGER,
  "I_DOSSIER" INTEGER,
  "DO_IT" INTEGER
)
RETURNS
(
  "NOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ADATE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE" INTEGER,
  "EV_TYPE" VARCHAR(7) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER
)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 17:48:36
   Modifiée le :12/08/2006 par André utilisation champ mois
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
 if (DO_IT=1) then
   FOR SELECT     i.nom,
                  i.prenom,
                  n.ev_ind_date_writen,
                  n.ev_ind_date_year,
                  'BIRT',
                  i.sexe
               FROM evenements_ind n
                    inner join individu i on i.cle_fiche=n.ev_ind_kle_fiche
               WHERE
                  n.ev_ind_date_mois=:a_Mois
                  AND
                  n.ev_ind_type = 'BIRT'
                  and
                  n.ev_ind_date is not null
                  AND
                  i.kle_dossier=:I_DOSSIER
        INTO
                   :NOM,
                   :PRENOM,
                   :ADATE,
                   :ANNEE,
                   :EV_TYPE ,
                   :SEXE
   DO
       SUSPEND;
 else
   SUSPEND;
end ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ANNIV_DEAT_INHU" 
(
  "A_MOIS" INTEGER,
  "I_DOSSIER" INTEGER,
  "DO_IT" INTEGER
)
RETURNS
(
  "NOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ADATE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE" INTEGER,
  "EV_TYPE" VARCHAR(7) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER
)
AS
declare variable CLEF INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 17:48:36
   Modifiée le :12/08/2006 par André utilisation champ mois
   à : :
   par :
   Description :
   Usage       :
   ---------------------------------------------------------------------------*/
 if (DO_IT=1) then
   FOR SELECT     i.cle_fiche,
                  i.nom,
                  i.prenom,
                  MIN(d.ev_ind_date_writen),
                  MIN(d.ev_ind_date_year),
                  'DEAT',
                  i.sexe
               FROM evenements_ind d
                    inner join individu i on i.cle_fiche=d.ev_ind_kle_fiche
               WHERE
                  d.ev_ind_date_mois=:a_Mois
                  AND
                  d.ev_ind_type in ('DEAT','BURI')
                  and
                  d.ev_ind_date is not null
                  AND
                  i.kle_dossier=:I_DOSSIER
               GROUP BY 1,2,3,7
        INTO       :CLEF,
                   :NOM,
                   :PRENOM,
                   :ADATE,
                   :ANNEE,
                   :EV_TYPE ,
                   :SEXE
   DO
       SUSPEND;
 else
   SUSPEND;
end ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ANNIV_MARIAGE" 
(
  "A_MOIS" INTEGER,
  "I_DOSSIER" INTEGER,
  "DO_IT" INTEGER
)
RETURNS
(
  "NOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ADATE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE" INTEGER,
  "EV_TYPE" VARCHAR(7) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER
)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 17:48:52
   Modifiée le :12/08/2006 par André utilisation champ mois
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
if (:DO_IT=1) then
  FOR SELECT
             m.NOM || ' ' || m.PRENOM,
             f.NOM || ' ' || f.PRENOM,
             e.ev_fam_date_writen,
             e.ev_fam_date_year,
             'MARR',
             1
        FROM EVENEMENTS_FAM e
             inner join T_UNION t on t.UNION_CLEF=e.EV_FAM_KLE_FAMILLE
             inner join INDIVIDU m on m.cle_fiche=t.union_mari
             inner join INDIVIDU f on f.cle_fiche=t.union_femme
        WHERE
              :a_Mois=e.ev_fam_date_mois
              and e.EV_FAM_TYPE = 'MARR'
              and e.ev_fam_date is not null
              and m.KLE_DOSSIER = :I_DOSSIER
        INTO :NOM,
             :PRENOM,
             :ADATE,
             :ANNEE,
             :EV_TYPE,
             :SEXE
   do
   suspend;
else
  suspend;
end ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ANNIVERSAIRES" 
(
  "A_MOIS" INTEGER,
  "I_MODE" INTEGER,
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" DATE,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "JOUR" VARCHAR(2) CHARACTER SET ISO8859_1,
  "AGE" INTEGER
)
AS
begin
   SUSPEND; 
end ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ETAT_ANNIV_ORDER" 
(
  "A_MOIS" INTEGER,
  "I_DOSSIER" INTEGER,
  "GET_BIRT" INTEGER,
  "GET_DEAT" INTEGER,
  "GET_MARR" INTEGER
)
RETURNS
(
  "NOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ADATE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE" INTEGER,
  "EV_TYPE" VARCHAR(7) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER
)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:05:19
   Modifiée le :12/08/2006 par André: ajout ordre chronologique
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
for
select NOM,PRENOM,ADATE,ANNEE,EV_TYPE, SEXE
from PROC_ETAT_ANNIV(:A_MOIS,:I_DOSSIER,:GET_BIRT,:GET_DEAT,:GET_MARR)
order by EV_TYPE, ANNEE
        INTO
                   :NOM,
                   :PRENOM,
                   :ADATE,
                   :ANNEE,
                   :EV_TYPE,
                   :SEXE
   DO
       SUSPEND;
end ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ETAT_EVENEMENTS" 
(
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "DATE_EVE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "S_TYPE" VARCHAR(5) CHARACTER SET ISO8859_1,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "NOM_COMPLET" VARCHAR(160) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER
)
AS
begin
   suspend;
end ^
COMMIT WORK^

ALTER PROCEDURE "F_MAJ_SANS_ACCENT" 
(
  "S_IN" VARCHAR(255) CHARACTER SET ISO8859_1
)
RETURNS
(
  "S_OUT" VARCHAR(255) CHARACTER SET ISO8859_1
)
AS
begin
  suspend;
end ^
COMMIT WORK^

/*mise à jour du champ CP_VILLE_MAJ dans REF_CP_VILLE*/
update REF_CP_VILLE
	set CP_VILLE_MAJ=null^ 
COMMIT WORK^

SET ECHO ON^
/* Cette partie doit  provoquer des erreurs si la base a déjà été modifiée*/
DROP PROCEDURE F_YEAR^
COMMIT WORK^
DROP PROCEDURE F_DAY^
COMMIT WORK^
DROP PROCEDURE F_MONTH^
COMMIT WORK^
DROP PROCEDURE F_DATE^
COMMIT WORK^
DROP PROCEDURE F_POS^
COMMIT WORK ^
/*Fin des erreurs normales*/
SET ECHO OFF^



SET ECHO ON^
/*Passage en version 4.043
L'utilisation de la base modifiée avec une version du logiciel inférieure à V535 peut entraîner des disfonctonnements.*/
SET ECHO OFF^


SET TERM ; ^
SET AUTODDL ON;
UPDATE T_VERSION_BASE SET VER_VERSION='4.043';
OUTPUT;
exit;
