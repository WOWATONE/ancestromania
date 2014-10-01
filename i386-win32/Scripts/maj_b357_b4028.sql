SET ECHO ON;
/*Ce script fait passer une base Ancestrologie de la b3.57 à la b4.028
Les erreurs pour des procédures ou des triggers déjà existants sont
nomales si une mise à jour même partielle a déjà été faite.
La procédure de mise à jour met un fichier REF_RELA_TEMOINS2.txt corrigé
dans le répertoire TablesReference. Si vous avez personnalisé votre table
des Témoins, adaptez le fichier REF_RELA_TEMOINS2.txt selon vos personnalisations
renommez-le REF_RELA_TEMOINS.txt et rechargez-le. Les 2 dernières colonnes sont
respectivement les nouveaux et les anciens TAG.
Exécuter la procédure PROC_REF_TEMOINS('N') dans le BOA pour utiliser les
nouveaux TAG, PROC_REF_TEMOINS('A') pour les anciens.
La requête SELECT * FROM PROC_REF_TEMOINS('x') où x=A ou N permet de visualiser
la liste des tags qui seront utilisés 
Pour utiliser la procédure de calcul de parenté entre deux individus, exécuter dans
le BOA ou autre requêteur, la requête 
SELECT CONSANGUINITE FROM PROC_PARENTE(CLE_INDIVIDU1,CLE_INDIVIDU2) 
Si CLE_INDIVIDU2=0, c'est la consanguinité de CLE_INDIVIDU1 qui est retournée.
PROC_MAJ_CONSANG(I_DOSSIER,SOSA,I_NIVEAU) met à jour le champ CONSANGUINITE de la table INDIVIDU 
pour tous les individus du dossier si SOSA=0, pour uniquement les SOSA si SOSA=1, la précision du calcul dépend du niveau
(nombre de générations prises en compte dans le calcul, conseillé de 5 à 10).
*/
SET NAMES ISO8859_1;
SET ECHO OFF;

COMMIT WORK;
SET AUTODDL OFF;

SET TERM ! ;

--modifications ramenées en début de script pour compatibilité avec FB2.0
DROP TRIGGER INDIVIDU_AU! 
COMMIT WORK!


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
end !
COMMIT WORK!

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
end !
COMMIT WORK!

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
end !
COMMIT WORK!

ALTER PROCEDURE PROC_AFTER_IMPORT (
    I_DOSSIER INTEGER,
    I_MODE INTEGER)
AS
begin
  exit;
end !
COMMIT WORK!

--fin des modifications décalées pour compatibilité avec FB2.0

/*PROC_LISTE_UNIONS nettoyage de la procédure pour utiliser les jointures LEFT JOIN.*/

ALTER PROCEDURE "PROC_LISTE_UNIONS" 
(
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "UNION_CLE" INTEGER,
  "MARI_CLE" INTEGER,
  "MARI_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "MARI_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "FEMME_CLE" INTEGER,
  "FEMME_NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "FEMME_PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "PAYS" VARCHAR(30) CHARACTER SET ISO8859_1,
  "DATE_UNION" DATE
)
AS
begin
   suspend;
end
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/*PROC_CHARGE_MEDIA suppression variable clef inutilisée. Listage des champs à sortir afin de mettre temporairement en commentaires les champs de la table MULTIMEDIA dont on modifie le type de BLOB BLR à BLOB TEXT*/
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

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
BEGIN
     SUSPEND;
END
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;


/*PROC_ORPHELINS Test si l'individu n'est pas témoin (table T_ASSOCIATIONS)*/
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_ORPHELINS" 
(
  "IDOSSIER" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER
)
AS
BEGIN
    SUSPEND;
END
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/*PROC_ACTES_A_TROUVER_FAMILLES pour que les actes à trouver familiaux figurent aussi sur la fiche de la femme.
*/
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_ACTES_A_TROUVER_FAMILLES" 
(
  "I_INDI" INTEGER
)
RETURNS
(
  "EVE_CLEF" INTEGER,
  "EVE_TYPE" VARCHAR(7) CHARACTER SET ISO8859_1,
  "EVE_LIB_LONG" VARCHAR(30) CHARACTER SET ISO8859_1,
  "EVE_DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1,
  "EVE_CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "EVE_VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "EVE_ACTE" INTEGER,
  "EVE_TABLE" CHAR(1) CHARACTER SET ISO8859_1
)
AS
BEGIN
    SUSPEND;
END
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/*PRO_ACTES_DEJA_TROUVES idem et ajout contrôle que média de type_image='A' pour supprimer sélection d'un média venant d'un autre individu de même code_fiche qu'un even_ind de l'individu.*/
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_ACTES_DEJA_TROUVES" 
(
  "I_INDI" INTEGER
)
RETURNS
(
  "EVE_IMAGE" INTEGER,
  "EVE_CLEF" INTEGER,
  "EVE_TYPE" VARCHAR(7) CHARACTER SET ISO8859_1,
  "EVE_LIB_LONG" VARCHAR(30) CHARACTER SET ISO8859_1,
  "EVE_DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1,
  "EVE_CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "EVE_VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "EVE_ACTE" INTEGER,
  "EVE_TABLE" CHAR(1) CHARACTER SET ISO8859_1
)
AS
BEGIN
    SUSPEND;
END
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/*PROC_ACTES_RAZ pour mettre à jour la fiche even_fam, même si l'acte est trouvé depuis la fiche de la femme.*/
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_ACTES_RAZ" 
(
  "INDI" INTEGER
)
AS
/* Modifications André DDdeberdeux le 20/09/2005 pour modifier
l'acte familial, que la fiche soit du mari ou de la femme*/
BEGIN
  exit;
END
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/* PROC_TROUVE_UNIONS simplification, une seule requête indépendante du sexe. 
Correction pour n'émettre qu'un enregistrement par union et classement par ordre 
chronologique du premier evènement familial.*/
COMMIT WORK;
/*SET AUTODDL OFF;*/
SET TERM ! ;

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
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/*PROC_EXPORT_IMAGES Edition d'une image par individu pour éviter l'erreur due aux images liées à plusieurs individus.*/
COMMIT WORK;
/*SET AUTODDL OFF;*/
SET TERM ! ;

ALTER PROCEDURE "PROC_EXPORT_IMAGES" 
(
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "NOM" VARCHAR(105) CHARACTER SET ISO8859_1,
  "MULTI_MEDIA" BLOB
)
AS
begin
suspend;
END
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/*PROC_FIXE_UNIQUE_PHOTO_IDENTITE pour que tout multimédia lié à l'individu puisse être photo d'identité*/
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_FIXE_UNIQUE_PHOTO_IDENTITE" 
(
  "I_CLEF" INTEGER,
  "I_INDIVIDU" INTEGER,
  "I_DOSSIER" INTEGER
)
AS
begin
  exit;
end
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/*Modification PROC_DELETE_UNION pour simplification et correction d'une erreur entrainant la suppression d'évènements familiaux d'une autre union.*/
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_DELETE_UNION" 
(
  "I_CLEF" INTEGER
)
RETURNS
(
  "COMBIEN" INTEGER
)
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 18:12:56
   Modifiée le : 24/10/2005 par André, simplification, suppression erreur
   provoquant la suppression d'évènements familiaux d'une autre union.
   à : :
   par :
   Description : Supprime une union s'il n'y a pas d'enfants
   Usage       :
   ---------------------------------------------------------------------------*/
   select count(ind.CLE_FICHE) from individu ind , T_UNION u
        where u.UNION_CLEF = :I_CLEF
              AND ind.CLE_PERE = u.UNION_MARI and ind.CLE_MERE = u.UNION_FEMME
        into :COMBIEN     ;

    if (:COMBIEN = 0 ) then
      DELETE FROM T_UNION
         WHERE UNION_CLEF = :I_CLEF;
    suspend;
END
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/*Modif présentation PROC_NAVIGATION et PROC_TROUVE_GRANDS_PARENT pour rapidité...*/
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_NAVIGATION" 
(
  "I_CLEF" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_MAX" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "SOSA" DOUBLE PRECISION
)
AS
begin
     suspend;
end
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_TROUVE_GRANDS_PARENT" 
(
  "I_CLEF" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "SOSA" INTEGER
)
AS
BEGIN
    SUSPEND;
END
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/*Modification des procédures PROC_VIDE_BASE, PROC_VIDE_TABLE, PROC_VIDE_DOSSIER, PROC_VIDE_BIBLIO pour supprimer les tables en respectant l'ordre des dépendances et diminuer l'effet des déclenchements inutiles des triggers before delete.*/
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_VIDE_BASE" 
(
  "I_CLEF" INTEGER
)
AS
begin
  exit;
end
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_VIDE_TABLE" 
(
  "I_CLEF" INTEGER
)
AS
begin
exit; end
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_VIDE_DOSSIER" 
(
  "I_CLEF" INTEGER
)
AS
begin
  exit;
end
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

ALTER PROCEDURE "PROC_VIDE_BIBLIO" 
AS
BEGIN
  exit;
END
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

/*Créations de triggers sur les tables pour assurer le fonctionnement des médias:
Bon enregistrement des medias depuis les sources des évènements individuels et familiaux;
Visibilité des médias enregistrés par les sources et par les actes depuis l'onglet Média de la fiche pour les femmes comme pour les hommes;
Suppression du rattachement des médias liés par les sources d'un évènement, lors de la suppression de cet évènement (individuel ou familial)*/

SET TERM ! ;

CREATE TRIGGER "TAI_EVENEMENTS_FAM" FOR "EVENEMENTS_FAM" 
ACTIVE AFTER INSERT POSITION 0
as
/* Création par André pour fonctionnement média (01/10/05)
   Le doublement de l'enregistrement dans MEDIA_POINTEURS
   pour le conjoint ne fonctionne pas si l'enregistrement
   de l'évènement familial dans SOURCES_RECORD n'existe pas.
   Ne sera plus nécessaire le jour où le programme créera
   l'enregistrement dans SOURCES_RECORD avant celui dans
   MEDIA_POINTEURS*/
DECLARE VARIABLE COMPTE INTEGER;
BEGIN
  SELECT COUNT(ID)
    FROM SOURCES_RECORD
    WHERE TYPE_TABLE = 'F' AND
          DATA_ID = NEW.EV_FAM_CLEF
    INTO :COMPTE;
  IF (COMPTE = 0) then
    BEGIN
      INSERT INTO SOURCES_RECORD (ID,
                                  DATA_ID,
                                  CHANGE_DATE,
                                  KLE_DOSSIER,
                                  TYPE_TABLE)
                          VALUES (GEN_ID(SOURCES_RECORD_ID_GEN, 1),
                                  NEW.EV_FAM_CLEF,
                                  'NOW',
                                  NEW.EV_FAM_KLE_DOSSIER,
                                  'F');
    END
END
 !
COMMIT WORK !

CREATE TRIGGER "TBD_EVENEMENTS_FAM" FOR "EVENEMENTS_FAM" 
ACTIVE BEFORE DELETE POSITION 0
as
/* Création par André pour fonctionnement média (01/10/05)
   Suppression des enregistrements dans SOURCES_RECORD et
   dans MEDIA_POINTEURS si l'enregistrement disparaît.
   24/10/05 ajout maj table T_ASSOCIATIONS  */
BEGIN
  DELETE FROM SOURCES_RECORD
    WHERE DATA_ID = OLD.EV_FAM_CLEF AND
          TYPE_TABLE = 'F' ;
  DELETE FROM MEDIA_POINTEURS
    WHERE MP_POINTE_SUR = OLD.EV_FAM_CLEF AND
          MP_TYPE_IMAGE = 'A' AND
          MP_TABLE = 'F' ;
  DELETE FROM T_ASSOCIATIONS
    WHERE ASSOC_EVENEMENT = OLD.EV_FAM_CLEF AND
          ASSOC_TABLE = 'U' ;
END
 !

COMMIT WORK !
SET TERM ;!

SET TERM ! ;

CREATE TRIGGER "TBD_EVENEMENTS_IND" FOR "EVENEMENTS_IND" 
ACTIVE BEFORE DELETE POSITION 0
as
/* Création par André pour fonctionnement média (01/10/05)
   Suppression des enregistrements dans SOURCES_RECORD et
   dans MEDIA_POINTEURS si l'enregistrement disparaît.
   24/10/05 ajout maj table T_ASSOCIATIONS */
BEGIN
  DELETE FROM SOURCES_RECORD
    WHERE DATA_ID = OLD.EV_IND_CLEF AND
          TYPE_TABLE = 'I' ;
  DELETE FROM MEDIA_POINTEURS
    WHERE MP_POINTE_SUR = OLD.EV_IND_CLEF AND
          MP_TYPE_IMAGE = 'A' AND
          MP_TABLE = 'I' ;
  DELETE FROM T_ASSOCIATIONS
    WHERE ASSOC_EVENEMENT = OLD.EV_IND_CLEF AND
          ASSOC_TABLE = 'I' ;
END
 !

COMMIT WORK !
SET TERM ;!

SET TERM ! ;

CREATE TRIGGER "TAI_MEDIA_POINTEURS" FOR "MEDIA_POINTEURS" 
ACTIVE AFTER INSERT POSITION 0
as
/* Création par André pour fonctionnement média(01/10/05)
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
             MP_IDENTITE = NEW.MP_IDENTITE AND
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
 !

CREATE TRIGGER "TAD_MEDIA_POINTEURS" FOR "MEDIA_POINTEURS" 
ACTIVE AFTER DELETE POSITION 0
as
/* Création par André pour fonctionnement média (01/10/05)
   Suppression de l'enregistrement pour le conjoint
   s'il est lié à un évènement familial */
DECLARE VARIABLE TTABLE char(1);
BEGIN
 TTABLE='I';
 IF (OLD.MP_TYPE_IMAGE = 'F') THEN
     SELECT TYPE_TABLE
     FROM SOURCES_RECORD
     WHERE SOURCES_RECORD.ID = OLD.MP_POINTE_SUR
     INTO :TTABLE;
 ELSE
   IF ((OLD.MP_TYPE_IMAGE = 'A') AND (OLD.MP_TABLE = 'F')) THEN
       TTABLE = 'F';
 IF (TTABLE = 'F') THEN
     DELETE FROM MEDIA_POINTEURS
       WHERE MP_MEDIA = OLD.MP_MEDIA AND
             MP_POINTE_SUR = OLD.MP_POINTE_SUR AND
             MP_TABLE = OLD.MP_TABLE AND
             MP_KLE_DOSSIER = OLD.MP_KLE_DOSSIER AND
             MP_TYPE_IMAGE = OLD.MP_TYPE_IMAGE ;
END
 !

COMMIT WORK !
SET TERM ;!

SET TERM ! ;

CREATE TRIGGER "TBD_SOURCES_RECORD" FOR "SOURCES_RECORD" 
ACTIVE BEFORE DELETE POSITION 0
as
/* Création par André pour fonctionnement média (01/10/05)
   Suppression des enregistrements de MEDIA_POINTEURS
   liés à cet enregistrement */
BEGIN
  DELETE FROM MEDIA_POINTEURS
    WHERE MP_TYPE_IMAGE = 'F' AND
          MP_POINTE_SUR = OLD.ID ;
END
 !

COMMIT WORK !
SET TERM ;!

/*Création du trigger TBD_T_UNION pour mettre à jour la table des évènements familiaux lors de la suppression d'une union.*/

SET TERM ! ;

CREATE TRIGGER "TBD_T_UNION" FOR "T_UNION" 
ACTIVE BEFORE DELETE POSITION 0
as
/* Créé par André le 25/10/2005 pour assurer intégrité*/
BEGIN
  DELETE FROM EVENEMENTS_FAM
  WHERE EV_FAM_KLE_FAMILLE = OLD.UNION_CLEF ;
END
 !

COMMIT WORK !
SET TERM ;!

/*Création des triggers T_BI_INDIVIDU_2 et T_BU_INDIVIDU_2 pour vérifier l'unicité de la CLE_FIXE si non essayer de lui attribuer CLE_FICHE, si non lui en attribuer une autre en cherchant une clé libre à partir de 1.*/

SET TERM ! ;

CREATE TRIGGER "T_BI_INDIVIDU_2" FOR "INDIVIDU" 
ACTIVE BEFORE INSERT POSITION 1
as
begin
exit; end
 !
COMMIT WORK !

CREATE TRIGGER "T_BU_INDIVIDU_2" FOR "INDIVIDU" 
ACTIVE BEFORE UPDATE POSITION 1
as
begin
exit; end
 !

COMMIT WORK !
SET TERM ;!

/* Ce script permet de mettre en type BLOB TEXT tous les champs d'Ancestrologie BLOB BLR ne contenant pourtant que du texte.
Cette opération permet en particulier l'exportation des données de ces champs par requêtes et dans d'autres logiciels.*/

COMMIT WORK;

ALTER TABLE ADRESSES_IND
ADD "ADR_ADRESSET"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "ADR_TELT"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "ADR_MEMOT"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1;
COMMIT WORK;

UPDATE ADRESSES_IND
SET ADR_ADRESSET = ADR_ADRESSE,
 ADR_TELT = ADR_TEL,
 ADR_MEMOT = ADR_MEMO;
COMMIT WORK;

ALTER TABLE ADRESSES_IND
DROP ADR_ADRESSE,
DROP ADR_TEL,
DROP ADR_MEMO;
COMMIT WORK;

ALTER TABLE ADRESSES_IND
ALTER COLUMN ADR_ADRESSET TO ADR_ADRESSE,
ALTER COLUMN ADR_ADRESSE POSITION 5,
ALTER COLUMN ADR_TELT TO ADR_TEL,
ALTER COLUMN ADR_TEL POSITION 11,
ALTER COLUMN ADR_MEMOT TO ADR_MEMO;
COMMIT WORK;


ALTER TABLE MEMO_INFOS
ADD "M_MEMOT" BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1;
COMMIT WORK;

UPDATE MEMO_INFOS
SET M_MEMOT = M_MEMO;
COMMIT WORK;

ALTER TABLE MEMO_INFOS
DROP M_MEMO;
COMMIT WORK;

ALTER TABLE MEMO_INFOS
ALTER COLUMN M_MEMOT TO M_MEMO,
ALTER COLUMN M_MEMO POSITION 2;
COMMIT WORK;


ALTER TABLE MULTIMEDIA_RECORD
ADD "USER_REFT"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "CHANGE_NOTET" BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1;
COMMIT WORK;

UPDATE MULTIMEDIA_RECORD
SET USER_REFT = USER_REF,
 CHANGE_NOTET = CHANGE_NOTE;
COMMIT WORK;

ALTER TABLE MULTIMEDIA_RECORD
DROP USER_REF,
DROP CHANGE_NOTE;
COMMIT WORK;

ALTER TABLE MULTIMEDIA_RECORD
ALTER COLUMN USER_REFT TO USER_REF,
ALTER COLUMN USER_REF POSITION 7,
ALTER COLUMN CHANGE_NOTET TO CHANGE_NOTE,
ALTER COLUMN CHANGE_NOTE POSITION 10;
COMMIT WORK;


ALTER TABLE NOTE_RECORD
ADD "NOTEST"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "USER_REFT"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "CHANGE_NOTET"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1;
COMMIT WORK;

UPDATE NOTE_RECORD
SET NOTEST = NOTES,
 USER_REFT = USER_REF,
 CHANGE_NOTET = CHANGE_NOTE;
COMMIT WORK;

ALTER TABLE NOTE_RECORD
DROP NOTES,
DROP USER_REF,
DROP CHANGE_NOTE;
COMMIT WORK;

ALTER TABLE NOTE_RECORD
ALTER COLUMN NOTEST TO NOTES,
ALTER COLUMN NOTES POSITION 2,
ALTER COLUMN USER_REFT TO USER_REF,
ALTER COLUMN USER_REF POSITION 3,
ALTER COLUMN CHANGE_NOTET TO CHANGE_NOTE,
ALTER COLUMN CHANGE_NOTE POSITION 6;
COMMIT WORK;



ALTER TABLE SOURCES_RECORD
ADD "AUTHT"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "TITLT"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "PUBLT"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "TEXTET"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "USER_REFT"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "CHANGE_NOTET"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1;
COMMIT WORK;

UPDATE SOURCES_RECORD
SET AUTHT = AUTH,
 TITLT = TITL,
 PUBLT = PUBL,
 TEXTET = TEXTE,
 USER_REFT = USER_REF,
 CHANGE_NOTET = CHANGE_NOTE;
COMMIT WORK;

ALTER TABLE SOURCES_RECORD
DROP AUTH,
DROP TITL,
DROP PUBL,
DROP TEXTE,
DROP USER_REF,
DROP CHANGE_NOTE;
COMMIT WORK;

ALTER TABLE SOURCES_RECORD
ALTER COLUMN AUTHT TO AUTH,
ALTER COLUMN AUTH POSITION 11,
ALTER COLUMN TITLT TO TITL,
ALTER COLUMN TITL POSITION 12,
ALTER COLUMN PUBLT TO PUBL,
ALTER COLUMN PUBL POSITION 14,
ALTER COLUMN TEXTET TO TEXTE,
ALTER COLUMN TEXTE POSITION 15,
ALTER COLUMN USER_REFT TO USER_REF,
ALTER COLUMN USER_REF POSITION 16,
ALTER COLUMN CHANGE_NOTET TO CHANGE_NOTE,
ALTER COLUMN CHANGE_NOTE POSITION 19;
COMMIT WORK;



ALTER TABLE T_ASSOCIATIONS
ADD "ASSOC_NOTEST"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "ASSOC_SOURCEST" BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1;
COMMIT WORK;

UPDATE T_ASSOCIATIONS
SET ASSOC_NOTEST = ASSOC_NOTES,
 ASSOC_SOURCEST = ASSOC_SOURCES;
COMMIT WORK;

ALTER TABLE T_ASSOCIATIONS
DROP ASSOC_NOTES,
DROP ASSOC_SOURCES;
COMMIT WORK;

ALTER TABLE T_ASSOCIATIONS
ALTER COLUMN ASSOC_NOTEST TO ASSOC_NOTES,
ALTER COLUMN ASSOC_NOTES POSITION 5,
ALTER COLUMN ASSOC_SOURCEST TO ASSOC_SOURCES,
ALTER COLUMN ASSOC_SOURCES POSITION 6;
COMMIT WORK;

/* la procedure PROC_CHARGE_MULTI doit être modifiée pour mettre en commentaires
les champs MULTI_DEVISE et MULTI_CRI afin de modifier MULTIMEDIA*/

COMMIT WORK;
SET AUTODDL OFF;
SET TERM ! ;

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
BEGIN
     SUSPEND;
END
 !

SET TERM ; !
COMMIT WORK;
SET AUTODDL ON;

ALTER TABLE MULTIMEDIA
ADD "MULTI_DEVISET"	 BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1,
ADD "MULTI_CRIT" BLOB SUB_TYPE TEXT SEGMENT SIZE 80 CHARACTER SET ISO8859_1;
COMMIT WORK;

UPDATE MULTIMEDIA
SET MULTI_DEVISET = MULTI_DEVISE,
 MULTI_CRIT = MULTI_CRI;
COMMIT WORK;


ALTER TABLE MULTIMEDIA
DROP MULTI_DEVISE,
DROP MULTI_CRI;
COMMIT WORK;

ALTER TABLE MULTIMEDIA
ALTER COLUMN MULTI_DEVISET TO MULTI_DEVISE,
ALTER COLUMN MULTI_DEVISE POSITION 12,
ALTER COLUMN MULTI_CRIT TO MULTI_CRI,
ALTER COLUMN MULTI_CRI POSITION 13;

COMMIT WORK;
SET AUTODDL OFF;
COMMIT WORK;
SET AUTODDL ON;
SET ECHO ON;
/*--------------------------------------------------------------------------------------
Fin du passage à la version 4.00
----------------------------------------------------------------------------------------
Passage de 4.00 à 4.006
----------------------------------------------------------------------------------------*/
SET ECHO OFF;
SET AUTODDL ON;
SET TERM ^ ;
/*Création préalable pour que ALTER PROCEDURE "PROC_DATE_WRITEN" suivant ne soit pas
soit pas rejeté lors d'une 2ième exécution*/
CREATE PROCEDURE "PROC_DATE_WRITEN" 
(
  "DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1
)
RETURNS
(
  "IAN" INTEGER,
  "DDATE" DATE,
  "DATE_WRITEN_S" VARCHAR(100) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend; END ^


/*Mise à jour pour utiliser les fonctions externes de 255 caractères*/

ALTER PROCEDURE "F_MAJ" 
(
  "S_IN" VARCHAR(255) CHARACTER SET ISO8859_1
)
RETURNS
(
  "S_OUT" VARCHAR(255) CHARACTER SET ISO8859_1
)
AS
begin suspend; end^

ALTER PROCEDURE "F_MAJ_SANS_ACCENT" 
(
  "S_IN" VARCHAR(255) CHARACTER SET ISO8859_1
)
RETURNS
(
  "S_OUT" VARCHAR(255) CHARACTER SET ISO8859_1
)
AS
begin suspend; end^

ALTER PROCEDURE "PROC_COMPTAGE" 
(
  "I_DOSSIER" INTEGER,
  "I_MODE" INTEGER
)
RETURNS
(
  "LIBELLE" VARCHAR(10) CHARACTER SET ISO8859_1,
  "COMPTAGE" INTEGER
)
AS
begin suspend; end^
ALTER PROCEDURE "PROC_COMPTE_VILLES" 
(
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "COMBIEN" INTEGER,
  "RPA_LIBELLE" VARCHAR(30) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend; end^


ALTER PROCEDURE "PROC_DATE_WRITEN" 
(
  "DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1
)
RETURNS
(
  "IAN" INTEGER,
  "DDATE" DATE,
  "DATE_WRITEN_S" VARCHAR(100) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend; END ^


ALTER PROCEDURE "F_DATE" 
(
  "ADATE" DATE
)
RETURNS
(
  "JOUR" INTEGER,
  "MOIS" INTEGER,
  "ANNEE" INTEGER,
  "SDATE" VARCHAR(10) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend;
END
 ^

ALTER PROCEDURE "F_POS" 
(
  "A_CHAINE" VARCHAR(250) CHARACTER SET ISO8859_1,
  "A_CHAR" CHAR(1) CHARACTER SET ISO8859_1
)
RETURNS
(
  "POS" INTEGER
)
AS
begin suspend;
end
 ^

ALTER PROCEDURE "PROC_ETAT_LISTE_ALPHA" 
(
  "I_DOSSIER" INTEGER,
  "I_SEXE" INTEGER
)
RETURNS
(
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_NAISSANCE" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_DECES" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "LETTRE" VARCHAR(1) CHARACTER SET ISO8859_1,
  "AGE" INTEGER,
  "SOSA" DOUBLE PRECISION,
  "CLE_FICHE" INTEGER
)
AS
begin suspend;
end
 ^

ALTER PROCEDURE "PROC_ETAT_LISTE_ALPHA_BORNE" 
(
  "I_DOSSIER" INTEGER,
  "I_DEBUT" VARCHAR(20) CHARACTER SET ISO8859_1,
  "I_FIN" VARCHAR(20) CHARACTER SET ISO8859_1
)
RETURNS
(
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(61) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(61) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "LETTRE" VARCHAR(1) CHARACTER SET ISO8859_1
)
AS
begin suspend;
end
 ^


ALTER PROCEDURE "PROC_FAVORIS_GRAPHE" 
(
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "COMBIEN" INTEGER,
  "RDP_LIBELLE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "RDP_CODE" INTEGER
)
AS
BEGIN suspend;
END
 ^


ALTER PROCEDURE "PROC_INSERT_LANGUE" 
(
  "A_TABLE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "A_LANGUE_ORIGINE" VARCHAR(3) CHARACTER SET ISO8859_1,
  "A_LANGUE_DEST" VARCHAR(3) CHARACTER SET ISO8859_1
)
AS
begin EXIT;
end
 ^


ALTER PROCEDURE "PROC_LISTE_PRENOM" 
(
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1
)
AS
begin suspend;
end
 ^


ALTER PROCEDURE "PROC_LR_MODIF_CASSE_NOM" 
(
  "I_DOSSIER" INTEGER,
  "I_MODE" INTEGER
)
AS
begin exit;
end
 ^


ALTER PROCEDURE "PROC_LR_MODIF_CASSE_PRENOM" 
(
  "I_DOSSIER" INTEGER,
  "I_MODE" INTEGER
)
AS
begin EXIT;
end
 ^


ALTER PROCEDURE "PROC_MAJ_EVE_FAM" 
(
  "I_DOSSIER" INTEGER
)
AS
begin EXIT;
end
 ^


ALTER PROCEDURE "PROC_MAJ_EVE_IND" 
(
  "I_DOSSIER" INTEGER
)
AS
begin EXIT;
end
 ^


ALTER PROCEDURE "PROC_MAJ_INSEE" 
(
  "I_DOSSIER" INTEGER
)
AS
begin EXIT;
end
 ^


ALTER PROCEDURE "PROC_PERMUTATION_INSEE" 
(
  "I_DOSSIER" INTEGER
)
AS
BEGIN EXIT; 
END
 ^


ALTER PROCEDURE "PROC_STATISTIQUES" 
(
  "I_DOSSIER" INTEGER,
  "I_QUI" INTEGER,
  "I_QUOI" INTEGER
)
RETURNS
(
  "COMBIEN" INTEGER,
  "DEPT" VARCHAR(30) CHARACTER SET ISO8859_1,
  "CODE" VARCHAR(30) CHARACTER SET ISO8859_1
)
AS
begin suspend;
end
 ^


ALTER PROCEDURE "PROC_UPDATE_VERSION" 
RETURNS
(
  "VERSION" VARCHAR(10) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend;
END
 ^


ALTER PROCEDURE "TEST" 
(
  "I_CLEF" INTEGER,
  "I_GENERATION" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER
)
RETURNS
(
  "GENERATTION" INTEGER,
  "NUM_SOSA" DOUBLE PRECISION,
  "O_NOM" VARCHAR(101) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_NAISSANCE" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_DECES" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "O_SEXE" INTEGER,
  "AGE" INTEGER,
  "O_CLE_FICHE" INTEGER,
  "DATE_UNION" VARCHAR(35) CHARACTER SET ISO8859_1,
  "LIEU_UNION" VARCHAR(50) CHARACTER SET ISO8859_1
)
AS
begin suspend;
end
 ^

ALTER PROCEDURE "PROC_GENEANET" 
(
  "S_PATRONYME" VARCHAR(40) CHARACTER SET ISO8859_1,
  "I_DOSSIER" INTEGER,
  "S_TYPE" VARCHAR(10) CHARACTER SET ISO8859_1
)
RETURNS
(
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "DATE_DEBUT" INTEGER,
  "DATE_FIN" INTEGER,
  "COMBIEN" INTEGER,
  "CP" VARCHAR(10) CHARACTER SET ISO8859_1,
  "VILLE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "PAYS" VARCHAR(30) CHARACTER SET ISO8859_1,
  "PAYS_CODE" VARCHAR(3) CHARACTER SET ISO8859_1
)
AS
begin suspend;
end
 ^


ALTER PROCEDURE "PROC_TROUVE_DOMTOM" 
(
  "SCODE" VARCHAR(3) CHARACTER SET ISO8859_1
)
RETURNS
(
  "RPA_LIBELLE" VARCHAR(30) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend;
END
 ^




SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;

DROP EXTERNAL FUNCTION LOWER;
DROP EXTERNAL FUNCTION LTRIM;
DROP EXTERNAL FUNCTION RTRIM;
DROP EXTERNAL FUNCTION SUBSTR;

DECLARE EXTERNAL FUNCTION SUBSTR
CSTRING(255) CHARACTER SET ISO8859_1, SMALLINT, SMALLINT
RETURNS CSTRING(255) CHARACTER SET ISO8859_1 FREE_IT
ENTRY_POINT 'IB_UDF_substr' MODULE_NAME 'ib_udf';

DECLARE EXTERNAL FUNCTION RTRIM
CSTRING(255) CHARACTER SET ISO8859_1
RETURNS CSTRING(255) CHARACTER SET ISO8859_1 FREE_IT
ENTRY_POINT 'IB_UDF_rtrim' MODULE_NAME 'ib_udf';

DECLARE EXTERNAL FUNCTION LTRIM
CSTRING(255) CHARACTER SET ISO8859_1
RETURNS CSTRING(255) CHARACTER SET ISO8859_1 FREE_IT
ENTRY_POINT 'IB_UDF_ltrim' MODULE_NAME 'ib_udf';

DECLARE EXTERNAL FUNCTION LOWER
CSTRING(255) CHARACTER SET ISO8859_1
RETURNS CSTRING(255) CHARACTER SET ISO8859_1 FREE_IT
ENTRY_POINT 'IB_UDF_lower' MODULE_NAME 'ib_udf';


COMMIT WORK;
SET AUTODDL OFF;
SET TERM ^ ;

ALTER PROCEDURE "F_DATE" 
(
  "ADATE" DATE
)
RETURNS
(
  "JOUR" INTEGER,
  "MOIS" INTEGER,
  "ANNEE" INTEGER,
  "SDATE" VARCHAR(10) CHARACTER SET ISO8859_1
)
AS
DECLARE VARIABLE A_DATE VARCHAR(10);
BEGIN
     /*---------------------------------------------------------------------------
     Copyright Philippe Cazaux-Moutou. Tout droits réservés.
     Créé le : 31/07/2001
     à : 17:47:14
     Modifiée le :
     à : :
     par :
     Description : 
     Usage       :
     ---------------------------------------------------------------------------*/
  A_DATE = CAST( ADATE AS Varchar(10) );
  SDATE = A_DATE;
  ANNEE = SUBSTR( A_DATE, 1, 4);
  MOIS  = SUBSTR( A_DATE, 6, 7);
  JOUR  = SUBSTR( A_DATE, 9, 10);
  suspend;
END
 ^

ALTER PROCEDURE "F_POS" 
(
  "A_CHAINE" VARCHAR(250) CHARACTER SET ISO8859_1,
  "A_CHAR" CHAR(1) CHARACTER SET ISO8859_1
)
RETURNS
(
  "POS" INTEGER
)
AS
begin
  suspend;
end
 ^

ALTER PROCEDURE "PROC_ETAT_LISTE_ALPHA" 
(
  "I_DOSSIER" INTEGER,
  "I_SEXE" INTEGER
)
RETURNS
(
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_NAISSANCE" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_DECES" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "LETTRE" VARCHAR(1) CHARACTER SET ISO8859_1,
  "AGE" INTEGER,
  "SOSA" DOUBLE PRECISION,
  "CLE_FICHE" INTEGER
)
AS
begin
   suspend;
end
 ^

ALTER PROCEDURE "TEST" 
(
  "I_CLEF" INTEGER,
  "I_GENERATION" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER
)
RETURNS
(
  "GENERATTION" INTEGER,
  "NUM_SOSA" DOUBLE PRECISION,
  "O_NOM" VARCHAR(101) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_NAISSANCE" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_DECES" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "O_SEXE" INTEGER,
  "AGE" INTEGER,
  "O_CLE_FICHE" INTEGER,
  "DATE_UNION" VARCHAR(35) CHARACTER SET ISO8859_1,
  "LIEU_UNION" VARCHAR(50) CHARACTER SET ISO8859_1
)
AS
begin
   suspend;
end
 ^

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;

/*Fin de mise à jour fonctions externes 255 caractères*/

/*Création et utilisation PROC_DATE_WRITEN pour mise à jour
  automatique des champs YEAR et DATE.
  (Réparation dates inexactes dans EVENEMENTS_IND)*/

COMMIT WORK;
SET AUTODDL ON;
SET TERM ^ ;

ALTER PROCEDURE "PROC_DATE_WRITEN" 
(
  "DATE_WRITEN" VARCHAR(100) CHARACTER SET ISO8859_1
)
RETURNS
(
  "IAN" INTEGER,
  "DDATE" DATE,
  "DATE_WRITEN_S" VARCHAR(100) CHARACTER SET ISO8859_1
)
AS
begin
    SUSPEND;
end
 ^
COMMIT WORK ^

CREATE TRIGGER "TBU_EVENEMENTS_IND" FOR "EVENEMENTS_IND" 
ACTIVE BEFORE UPDATE POSITION 0
as
BEGIN
exit; END
 ^

COMMIT WORK ^


ALTER TRIGGER "EVENEMENTS_FAM_BI" 
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE IAN INTEGER;
DECLARE VARIABLE DDATE DATE;
BEGIN
exit; END
 ^
COMMIT WORK ^

CREATE TRIGGER "TBU_EVENEMENTS_FAM" FOR "EVENEMENTS_FAM" 
ACTIVE BEFORE UPDATE POSITION 0
as
BEGIN
exit; END
 ^
COMMIT WORK ^

CREATE TRIGGER "TBI_ADRESSES_IND" FOR "ADRESSES_IND" 
ACTIVE BEFORE INSERT POSITION 0
as
DECLARE VARIABLE IAN INTEGER;
DECLARE VARIABLE DDATE DATE;
DECLARE VARIABLE DATE_WRITEN varchar(100);
BEGIN
/* Créé par André le 18/11/2005 pour mettre à jour les dates*/
  SELECT IAN , DDATE, DATE_WRITEN_S FROM PROC_DATE_WRITEN(NEW.ADR_DATE_WRITEN)
    INTO :IAN, :DDATE, :DATE_WRITEN;
    NEW.ADR_DATE_1 = DDATE;
    NEW.ADR_DATE_YEAR_1 = IAN;
  SELECT IAN , DDATE FROM PROC_DATE_WRITEN(:DATE_WRITEN)
    INTO :IAN, :DDATE;
    NEW.ADR_DATE_2 = DDATE;
    NEW.ADR_DATE_YEAR_2 = IAN;
END
 ^
COMMIT WORK ^

CREATE TRIGGER "TBU_ADRESSES_IND" FOR "ADRESSES_IND" 
ACTIVE BEFORE UPDATE POSITION 0
as
DECLARE VARIABLE IAN INTEGER;
DECLARE VARIABLE DDATE DATE;
DECLARE VARIABLE DATE_WRITEN varchar(100);
BEGIN
/* Créé par André le 18/11/2005 pour mettre à jour les dates*/
  SELECT IAN , DDATE, DATE_WRITEN_S FROM PROC_DATE_WRITEN(NEW.ADR_DATE_WRITEN)
    INTO :IAN, :DDATE, :DATE_WRITEN;
    NEW.ADR_DATE_1 = DDATE;
    NEW.ADR_DATE_YEAR_1 = IAN;
  SELECT IAN , DDATE FROM PROC_DATE_WRITEN(:DATE_WRITEN)
    INTO :IAN, :DDATE;
    NEW.ADR_DATE_2 = DDATE;
    NEW.ADR_DATE_YEAR_2 = IAN;
END
 ^
COMMIT WORK ^

ALTER PROCEDURE "PROC_TEST_STRTOINT" 
(
  "S" VARCHAR(20) CHARACTER SET ISO8859_1
)
RETURNS
(
  "ISINT" INTEGER
)
AS
BEGIN
/*--------------------------------------------------------------------------
-
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 10/08/2001
   à : 16:21:54
   Modifiée le :18/11/2005 par André. Enlevé variables inutiles
   à : :
   par :
   Description :
   Usage       :
   -------------------------------------------------------------------------
--*/
BEGIN
   ISINT = Cast (s  as INTEGER ) ;
   WHEN Any  do
   ISINT = -999 ;
   end
   suspend;
END
 ^
COMMIT WORK ^

SET TERM ;^
/*mise à jour des tables*/
UPDATE EVENEMENTS_IND SET EV_IND_DATE_WRITEN=EV_IND_DATE_WRITEN;
UPDATE EVENEMENTS_FAM SET EV_FAM_DATE_WRITEN=EV_FAM_DATE_WRITEN;
UPDATE ADRESSES_IND SET ADR_DATE_WRITEN=ADR_DATE_WRITEN;
COMMIT WORK ;

SET TERM ^ ; /* mise à jour des triggers après update des tables*/

ALTER TRIGGER "TBU_ADRESSES_IND" 
ACTIVE BEFORE UPDATE POSITION 0
as
DECLARE VARIABLE IAN INTEGER;
DECLARE VARIABLE DDATE DATE;
DECLARE VARIABLE DATE_WRITEN varchar(100);
BEGIN
/* Créé par André le 18/11/2005 pour mettre à jour les dates*/
IF (NEW.ADR_DATE_WRITEN <> OLD.ADR_DATE_WRITEN) THEN
BEGIN
  SELECT IAN , DDATE, DATE_WRITEN_S FROM PROC_DATE_WRITEN(NEW.ADR_DATE_WRITEN)
    INTO :IAN, :DDATE, :DATE_WRITEN;
    NEW.ADR_DATE_1 = DDATE;
    NEW.ADR_DATE_YEAR_1 = IAN;
  SELECT IAN , DDATE FROM PROC_DATE_WRITEN(:DATE_WRITEN)
    INTO :IAN, :DDATE;
    NEW.ADR_DATE_2 = DDATE;
    NEW.ADR_DATE_YEAR_2 = IAN;
END
END
 ^

ALTER TRIGGER "TBU_EVENEMENTS_FAM"
ACTIVE BEFORE UPDATE POSITION 0
as
BEGIN
exit; END
 ^

ALTER PROCEDURE "PROC_GET_VERSION_DATABASE" 
RETURNS
(
  "VERSION" VARCHAR(20) CHARACTER SET ISO8859_1
)
AS
BEGIN
FOR SELECT VER_VERSION FROM T_VERSION_BASE
INTO :VERSION
DO VERSION = VERSION;
SUSPEND;
END
 ^

ALTER PROCEDURE "PROC_ETAT_NB_ENFANT_UNION" 
(
  "A_CLE_DOSSIER" INTEGER,
  "LIMIT_ON_DATE" INTEGER,
  "LIMIT_ON_SOSA" INTEGER,
  "YEAR_FROM" INTEGER,
  "YEAR_TO" INTEGER,
  "INTERVAL" INTEGER
)
RETURNS
(
  "INTERVAL_START" INTEGER,
  "INTERVAL_END" INTEGER,
  "NB_UNION" INTEGER,
  "NB_ENFANTS" INTEGER
)
AS
begin suspend; 
end
 ^


ALTER PROCEDURE "PROC_ETAT_NB_ENFANT_UNION_BASE" 
(
  "CLE_DOSSIER" INTEGER,
  "LIMIT_ON_DATE" INTEGER,
  "LIMIT_ON_SOSA" INTEGER,
  "YEAR_FROM" INTEGER,
  "YEAR_TO" INTEGER
)
RETURNS
(
  "YEAR_UNION" INTEGER,
  "NB_ENFANTS" INTEGER
)
AS
DECLARE VARIABLE A_MARI INTEGER;
DECLARE VARIABLE A_FEMME INTEGER;
DECLARE VARIABLE NUM_SOSA_MARI DOUBLE PRECISION;
DECLARE VARIABLE NUM_SOSA_FEMME DOUBLE PRECISION;
DECLARE VARIABLE TAKE INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:09:01
   Modifiée le : 21/11/2005 par André, correction erreur sélection sur cle_parents
   à : :  au lieu de cle_pere et cle_mere, ajout order by  et selections sur YEAR_FROM et TO
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
    for
        select eve.ev_fam_date_year,t_union.union_mari,t_union.union_femme
        from t_union
            LEFT JOIN EVENEMENTS_FAM EVE
            ON
              EVE.EV_FAM_KLE_FAMILLE = T_UNION.UNION_CLEF
              AND EVE.EV_FAM_TYPE = 'MARR'
        where
            (t_union.kle_dossier=:cle_dossier)
            and
            (not (eve.ev_fam_date_year is null))
        ORDER BY eve.ev_fam_date_year
        into
            :year_union,
            :a_mari,
            :a_femme
    do
    begin
        take=1;
        IF (LIMIT_ON_DATE = 1) THEN
          IF (YEAR_UNION<YEAR_FROM OR YEAR_UNION>YEAR_TO) THEN
             TAKE = 0;
        if (TAKE = 1 AND limit_on_sosa=1) then
        begin
            /* on ne traite que smallintles parents ont un num sosa */
            select num_sosa from individu where cle_fiche=:a_mari
            into :num_sosa_mari;
            select num_sosa from individu where cle_fiche=:a_femme
            into :num_sosa_femme;
            if ((num_sosa_mari is null) or (num_sosa_femme is null))
                then take=0;
        end
        if (take=1) then
        begin
            select count(cle_fiche)
            from individu
            where CLE_PERE=:A_MARI AND CLE_MERE=:A_FEMME
            into :nb_enfants;
            suspend;
        end
    end
end
 ^

ALTER PROCEDURE "PROC_ETAT_NB_ENFANT_UNION" 
(
  "A_CLE_DOSSIER" INTEGER,
  "LIMIT_ON_DATE" INTEGER,
  "LIMIT_ON_SOSA" INTEGER,
  "YEAR_FROM" INTEGER,
  "YEAR_TO" INTEGER,
  "INTERVAL" INTEGER
)
RETURNS
(
  "INTERVAL_START" INTEGER,
  "INTERVAL_END" INTEGER,
  "NB_UNION" INTEGER,
  "NB_ENFANTS" INTEGER
)
AS
DECLARE VARIABLE LAST_YEAR INTEGER;
DECLARE VARIABLE START_YEAR INTEGER;
DECLARE VARIABLE SHOULD_SUSPEND INTEGER;
DECLARE VARIABLE YEAR_UNION INTEGER;
DECLARE VARIABLE NB_ENFANT_UNION INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:08:52
   Modifiée le :21/11/2005 par André, paramètres pour proc_etat_nb_enfant_union_base
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
    LAST_YEAR=-9999999;
    START_YEAR=-9999999;
    SHOULD_SUSPEND=0;
    for
        select YEAR_UNION,NB_ENFANTS
        from proc_etat_nb_enfant_union_base(:A_CLE_DOSSIER,:LIMIT_ON_DATE,
                  :LIMIT_ON_SOSA,:YEAR_FROM,:YEAR_TO)
        into :YEAR_UNION,
             :NB_ENFANT_UNION
    do
    begin
            /*soit c'est le premier record qu'on traite*/
            if (LAST_YEAR=-9999999) then
            begin 
                INTERVAL_START=YEAR_UNION-mod(YEAR_UNION,INTERVAL);
                INTERVAL_END=INTERVAL_START+INTERVAL-1;
                NB_UNION=1;
                NB_ENFANTS=NB_ENFANT_UNION;
                SHOULD_SUSPEND=1;
            end
            /*soit l'année est dans un interval suivant   */
            else
            if (YEAR_UNION>INTERVAL_END) then
            begin
                /*on expédie le record */
                SUSPEND;
                /*changement d'interval */
                while (YEAR_UNION>INTERVAL_END) do
                begin
                    INTERVAL_START=INTERVAL_START+INTERVAL;
                    INTERVAL_END=INTERVAL_START+INTERVAL-1;
                    NB_UNION=0;
                    NB_ENFANTS=0;
                    /* si l'année est encore après, on sauve */
                    if (YEAR_UNION>INTERVAL_END) then SUSPEND;
                end
                NB_UNION=1;
                NB_ENFANTS=NB_ENFANT_UNION;
                SHOULD_SUSPEND=1;
            end
            else
            begin
                NB_UNION=NB_UNION+1;
                NB_ENFANTS=NB_ENFANTS+NB_ENFANT_UNION;
            end
            LAST_YEAR=YEAR_UNION;
    end
    if (SHOULD_SUSPEND=1) then SUSPEND;
end
 ^

/* ajout d'une procedure absente de certaines bases*/

CREATE PROCEDURE "PROC_LR_MODIF_CASSE_PRENOM" 
(
  "I_DOSSIER" INTEGER,
  "I_MODE" INTEGER
)
AS
begin
  exit;
end
 ^


/*Création d'une procédure temporaire pour réparer la base pour l'utilisation des médias*/

CREATE PROCEDURE "PROC_MAJ_POUR_MEDIAS" 
AS
DECLARE VARIABLE COMPTE INTEGER;
DECLARE VARIABLE DOSSIER INTEGER;
DECLARE VARIABLE CLEF INTEGER;
DECLARE VARIABLE MP_MEDIA INTEGER;
DECLARE VARIABLE UNION_FEMME INTEGER;
DECLARE VARIABLE MP_POINTE_SUR INTEGER;
DECLARE VARIABLE MP_TABLE CHAR(1);
DECLARE VARIABLE MP_TYPE_IMAGE CHAR(1);

begin
/* suppression des enregistrements en trop dans SOURCES_RECORD*/
/* liés à des évènements familiaux disparus*/
  DELETE FROM SOURCES_RECORD
         WHERE TYPE_TABLE= 'F' AND
               DATA_ID NOT IN (select EV_FAM_CLEF FROM EVENEMENTS_FAM);
/* liés à des évènements individuels disparus*/
  DELETE FROM SOURCES_RECORD
         WHERE TYPE_TABLE= 'I' AND
               DATA_ID NOT IN (select EV_IND_CLEF FROM EVENEMENTS_IND);
/* suppression des enregistrements en trop dans MEDIA_POINTEURS*/
/* liés à des individus disparus*/
  DELETE FROM MEDIA_POINTEURS
         WHERE MP_CLE_INDIVIDU NOT IN (select CLE_FICHE FROM INDIVIDU);
/* liés à des médias disparus*/
  DELETE FROM MEDIA_POINTEURS
         WHERE MP_MEDIA NOT IN (select MULTI_CLEF FROM MULTIMEDIA);
/* liés à des évènements individuels disparus*/
  DELETE FROM MEDIA_POINTEURS
         WHERE MP_TYPE_IMAGE = 'A' AND MP_TABLE = 'I' AND
               MP_POINTE_SUR NOT IN (select EV_IND_CLEF FROM EVENEMENTS_IND);
/* liés à des évènements familiaux disparus*/
  DELETE FROM MEDIA_POINTEURS
         WHERE MP_TYPE_IMAGE = 'A' AND MP_TABLE = 'F' AND
               MP_POINTE_SUR NOT IN (select EV_FAM_CLEF FROM EVENEMENTS_FAM);
/* liés à des sources disparues*/
  DELETE FROM MEDIA_POINTEURS
         WHERE MP_TYPE_IMAGE = 'F' AND
               MP_POINTE_SUR NOT IN (select ID FROM SOURCES_RECORD);

/* Création des enregistrements manquants dans SOURCES_RECORD*/
/*solution provisoire en attendant que PCM crée cet enregistrement
avant de l'utiliser dans MEDIA_POINTEURS*/
  FOR SELECT EV_FAM_CLEF, EV_FAM_KLE_DOSSIER FROM EVENEMENTS_FAM
        INTO :CLEF, :DOSSIER
  DO
  BEGIN
    SELECT COUNT(ID)
      FROM SOURCES_RECORD
      WHERE TYPE_TABLE = 'F' AND
          DATA_ID = :CLEF
      INTO :COMPTE;
    IF (COMPTE = 0) then
      BEGIN
        INSERT INTO SOURCES_RECORD (ID,
                                  DATA_ID,
                                  CHANGE_DATE,
                                  KLE_DOSSIER,
                                  TYPE_TABLE)
                          VALUES (GEN_ID(SOURCES_RECORD_ID_GEN, 1),
                                  :CLEF,
                                  'NOW',
                                  :DOSSIER,
                                  'F');
      END
  END
/* Création des enregistrements manquants pour les femmes dans MEDIA_POINTEURS*/
/*enregistrements liés à des actes familiaux*/
For select COUNT(MP.MP_CLEF),
           MP.MP_MEDIA,
           UN.UNION_FEMME,
           MP.MP_POINTE_SUR,
           MP.MP_TABLE,
           MP.MP_KLE_DOSSIER,
           MP.MP_TYPE_IMAGE
       FROM MEDIA_POINTEURS MP, EVENEMENTS_FAM EF, T_UNION UN, INDIVIDU IND
       WHERE  MP_TYPE_IMAGE = 'A' AND
              MP_TABLE = 'F' AND
              EF.EV_FAM_CLEF = MP.MP_POINTE_SUR AND
              UN.UNION_CLEF = EF.EV_FAM_KLE_FAMILLE AND
              IND.CLE_FICHE = UN.UNION_FEMME
       GROUP BY MP.MP_MEDIA,
                UN.UNION_FEMME,
                MP.MP_POINTE_SUR,
                MP.MP_TABLE,
                MP.MP_KLE_DOSSIER,
                MP.MP_TYPE_IMAGE
       INTO :COMPTE,
            :MP_MEDIA,
            :UNION_FEMME,
            :MP_POINTE_SUR,
            :MP_TABLE,
            :DOSSIER,
            :MP_TYPE_IMAGE
    DO
    IF (COMPTE=1) THEN
        INSERT INTO MEDIA_POINTEURS (MP_CLEF,
                                     MP_MEDIA,
                                     MP_CLE_INDIVIDU,
                                     MP_POINTE_SUR,
                                     MP_TABLE,
                                     MP_IDENTITE,
                                     MP_KLE_DOSSIER,
                                     MP_TYPE_IMAGE)
                    VALUES(GEN_ID(BIBLIO_POINTEURS_ID_GEN, 1),
                           :MP_MEDIA,
                           :UNION_FEMME,
                           :MP_POINTE_SUR,
                           :MP_TABLE,
                           0 ,
                           :DOSSIER,
                           :MP_TYPE_IMAGE) ;

/*enregistrements liés à des sources d'évènements familiaux*/
For select COUNT(MP.MP_CLEF),
           MP.MP_MEDIA,
           UN.UNION_FEMME,
           MP.MP_POINTE_SUR,
           MP.MP_TABLE,
           MP.MP_KLE_DOSSIER,
           MP.MP_TYPE_IMAGE
       FROM MEDIA_POINTEURS MP, SOURCES_RECORD SR, EVENEMENTS_FAM EF, T_UNION UN, INDIVIDU IND
       WHERE  MP_TYPE_IMAGE = 'F' AND
              MP_TABLE = 'F' AND
              SR.ID = MP.MP_POINTE_SUR AND
              EF.EV_FAM_CLEF = SR.DATA_ID AND
              UN.UNION_CLEF = EF.EV_FAM_KLE_FAMILLE AND
              IND.CLE_FICHE = UN.UNION_FEMME
       GROUP BY MP.MP_MEDIA,
                UN.UNION_FEMME,
                MP.MP_POINTE_SUR,
                MP.MP_TABLE,
                MP.MP_KLE_DOSSIER,
                MP.MP_TYPE_IMAGE
       INTO :COMPTE,
            :MP_MEDIA,
            :UNION_FEMME,
            :MP_POINTE_SUR,
            :MP_TABLE,
            :DOSSIER,
            :MP_TYPE_IMAGE
    DO
    IF (COMPTE=1) THEN
        INSERT INTO MEDIA_POINTEURS (MP_CLEF,
                                     MP_MEDIA,
                                     MP_CLE_INDIVIDU,
                                     MP_POINTE_SUR,
                                     MP_TABLE,
                                     MP_IDENTITE,
                                     MP_KLE_DOSSIER,
                                     MP_TYPE_IMAGE)
                    VALUES(GEN_ID(BIBLIO_POINTEURS_ID_GEN, 1),
                           :MP_MEDIA,
                           :UNION_FEMME,
                           :MP_POINTE_SUR,
                           :MP_TABLE,
                           0 ,
                           :DOSSIER,
                           :MP_TYPE_IMAGE) ;

exit;
end
 ^

ALTER PROCEDURE "PROC_INCOHERENCES" 
(
  "I_KLE_DOSSIER" INTEGER,
  "I_MODE" INTEGER
)
RETURNS
(
  "O_TABLE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "O_CLE_TABLE" INTEGER,
  "O_CLE_FICHE" INTEGER,
  "O_LIBELLE" VARCHAR(160) CHARACTER SET ISO8859_1
)
AS
begin
suspend;
end
 ^



COMMIT WORK ^
SET TERM ;^
SET AUTODDL ON;

EXECUTE PROCEDURE "PROC_MAJ_POUR_MEDIAS" ;
DROP PROCEDURE "PROC_MAJ_POUR_MEDIAS" ;

COMMIT WORK;

UPDATE REF_DEPARTEMENTS SET RDP_LIBELLE = 'Nouvelle Calédonie du Nord' WHERE RDP_CODE = 9881;
UPDATE REF_DEPARTEMENTS SET RDP_LIBELLE = 'Nouvelle Calédonie du Sud' WHERE RDP_CODE = 9882;

COMMIT WORK;

ALTER TABLE REF_RELA_TEMOINS
ADD REF_RELA_TAG_N VARCHAR(25) CHARACTER SET ISO8859_1,
ADD REF_RELA_TAG_A VARCHAR(25) CHARACTER SET ISO8859_1;

COMMIT WORK;

/* Documentation des colonnes supplémentaires
pour correspondance les utilisateurs doivent utiliser REF_RELA_TEMOINS.txt corrigé*/
UPDATE REF_RELA_TEMOINS SET REF_RELA_TAG_N = REF_RELA_TAG WHERE REF_RELA_TAG_N IS NULL;
UPDATE REF_RELA_TEMOINS SET REF_RELA_TAG_A = REF_RELA_TAG WHERE REF_RELA_TAG_A IS NULL;

COMMIT WORK;

/* La procédure de mise à jour met un fichier REF_RELA_TEMOINS2.txt corrigé
dans le répertoire TablesReference. Si vous avez personnalisé votre table
des Témoins, adaptez le fichier REF_RELA_TEMOINS2.txt selon vos personnalisations
renommez-le REF_RELA_TEMOINS.txt et rechargez-le. Les 2 dernières colonnes sont
les nouveaux et les anciens TAG.
Exécuter la procédure PROC_REF_TEMOINS('N') dans le BOA pour utiliser les
nouveaux TAG, PROC_REF_TEMOINS('A') pour les anciens */


SET TERM ^ ;

CREATE PROCEDURE "PROC_REF_TEMOINS" 
(
  "MODE" CHAR(1) CHARACTER SET ISO8859_1
)
RETURNS
(
  "REF_RELA_CLEF" INTEGER,
  "REF_RELA_CODE" INTEGER,
  "REF_RELA_LIBELLE" VARCHAR(40) CHARACTER SET ISO8859_1,
  "LANGUE" VARCHAR(3) CHARACTER SET ISO8859_1,
  "REF_RELA_TAG" VARCHAR(25) CHARACTER SET ISO8859_1
)
AS begin suspend; end ^

COMMIT WORK^

ALTER PROCEDURE "PROC_REF_TEMOINS" 
(
  "MODE" CHAR(1) CHARACTER SET ISO8859_1
)
RETURNS
(
  "REF_RELA_CLEF" INTEGER,
  "REF_RELA_CODE" INTEGER,
  "REF_RELA_LIBELLE" VARCHAR(40) CHARACTER SET ISO8859_1,
  "LANGUE" VARCHAR(3) CHARACTER SET ISO8859_1,
  "REF_RELA_TAG" VARCHAR(25) CHARACTER SET ISO8859_1
)
AS
/*Création par André le 29/11/2005. Permet de choisir le type de tag témoins
 utilisés dans un gedcom*/
DECLARE VARIABLE I INTEGER;
begin
  IF (UPPER(MODE) = 'A') then
      UPDATE REF_RELA_TEMOINS SET REF_RELA_TAG = REF_RELA_TAG_A;
  ELSE IF (UPPER(MODE) = 'N') then
         UPDATE REF_RELA_TEMOINS SET REF_RELA_TAG = REF_RELA_TAG_N;
         ELSE EXIT;
  FOR SELECT REF_RELA_CLEF , REF_RELA_CODE , REF_RELA_LIBELLE , LANGUE , REF_RELA_TAG
            FROM REF_RELA_TEMOINS
            INTO :REF_RELA_CLEF, :REF_RELA_CODE,:REF_RELA_LIBELLE, :LANGUE,:REF_RELA_TAG
  DO
    SUSPEND;
end
 ^

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Titre', REF_EVE_VISIBLE = 1,REF_EVE_CAT = 6
WHERE REF_EVE_LIB_COURT = 'TITL' AND REF_EVE_CODE = 127;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Titres ne pas utiliser', REF_EVE_VISIBLE = 0
WHERE REF_EVE_LIB_COURT = 'TITR' AND REF_EVE_CODE = 128;

UPDATE EVENEMENTS_IND SET EV_IND_TYPE = 'TITL' Where EV_IND_TYPE = 'TITR';

SET ECHO ON;
/*Passage en version 4.006*/
SET ECHO OFF;

COMMIT WORK;
SET AUTODDL OFF;
SET TERM ^ ;

ALTER PROCEDURE "PROC_ETAT_AGE_PREM_UNION_BASE" 
(
  "A_CLE_DOSSIER" INTEGER
)
RETURNS
(
  "ANNEE_DEBUT" INTEGER,
  "FEMMES" INTEGER,
  "HOMMES" INTEGER,
  "AGE_FEMMES" DOUBLE PRECISION,
  "AGE_HOMMES" DOUBLE PRECISION
)
AS
DECLARE VARIABLE ANNEE INTEGER;
DECLARE VARIABLE AGE_MARI INTEGER;
DECLARE VARIABLE AGE_FEMME INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:05:00
   Modifiée le : 07/12/2005 par André pour mise en oeuvre état âge à la première union
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
  ANNEE_DEBUT=-10000;
  FEMMES=0;
  HOMMES=0;
  AGE_FEMMES=0;
  AGE_HOMMES=0;
  FOR SELECT MIN(ef.EV_FAM_DATE_YEAR)
            ,MIN(ef.EV_FAM_DATE_YEAR)-m.EV_IND_DATE_YEAR
            ,MIN(ef.EV_FAM_DATE_YEAR)-p.EV_IND_DATE_YEAR
        FROM T_UNION u
          INNER JOIN EVENEMENTS_FAM ef ON ef.EV_FAM_KLE_FAMILLE=u.UNION_CLEF
          LEFT JOIN EVENEMENTS_IND m ON m.EV_IND_KLE_FICHE=u.UNION_FEMME
                                    AND m.EV_IND_TYPE='BIRT'
          LEFT JOIN EVENEMENTS_IND p ON p.EV_IND_KLE_FICHE=u.UNION_MARI
                                    AND p.EV_IND_TYPE='BIRT'
        WHERE u.KLE_DOSSIER=:A_CLE_DOSSIER AND ef.EV_FAM_DATE_YEAR is NOT NULL
        GROUP BY m.EV_IND_DATE_YEAR,p.EV_IND_DATE_YEAR
        ORDER BY MIN(ef.EV_FAM_DATE_YEAR)
    INTO :ANNEE,
         :AGE_FEMME,
         :AGE_MARI
  DO
  BEGIN
    IF (ANNEE_DEBUT=-10000) THEN ANNEE_DEBUT=CAST(FLOOR(ANNEE/25)*25 AS INTEGER);
      IF (AGE_FEMME IS NOT NULL) THEN
        begin

          AGE_FEMMES=(AGE_FEMMES*FEMMES+AGE_FEMME)/(FEMMES+1);
          FEMMES=FEMMES+1;
        end
      IF (AGE_MARI IS NOT NULL) THEN
        begin
          AGE_HOMMES=(AGE_HOMMES*HOMMES+AGE_MARI)/(HOMMES+1);
          HOMMES=HOMMES+1;
        end
    IF (ANNEE_DEBUT<CAST(FLOOR(ANNEE/25)*25 AS INTEGER)) THEN   /* OR fin de la table?*/
      begin
        suspend;
        ANNEE_DEBUT=CAST(FLOOR(ANNEE/25)*25 AS INTEGER);
        FEMMES=0;
        HOMMES=0;
        AGE_FEMMES=0;
        AGE_HOMMES=0;
      end
  END
  IF (FEMMES>0 OR HOMMES>0) THEN
    suspend;
end
 ^

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;

SET ECHO ON;
/*Passage en version 4.007*/
/*Suppression des tables TQ_COMPTAGE et TQ_COMPTE_VILLE 
au cas où elles auraient été créées en b4.005
Attention les procédures PROC_COMPTAGE et PROC_COMPTE_VILLES
nécessitent une version au moins v392 du logiciel pour bien fonctionner*/
SET ECHO OFF;

COMMIT WORK;
SET AUTODDL ON;

DROP TABLE "TQ_COMPTAGE";  
DROP TABLE "TQ_COMPTE_VILLE"; 
COMMIT WORK;

SET ECHO ON;
/*Passage en version 4.008*/
SET ECHO OFF;


COMMIT WORK;
SET AUTODDL ON;

SET ECHO ON;
/*Passage en version 4.009*/
SET ECHO OFF;

COMMIT WORK;
SET TERM ^;
/* Désactivation des procédures PROC_PARENTE et PROC_ETAT_DENOMB_ASCEND
utilisant PROC_CONSANG*/
ALTER PROCEDURE "PROC_PARENTE" 
(
  "CLE_INDIVIDU1" INTEGER,
  "CLE_INDIVIDU2" INTEGER
)
RETURNS
(
  "PARENTE" DOUBLE PRECISION
)
AS
begin suspend; end^
COMMIT WORK^
ALTER PROCEDURE "PROC_MAJ_CONSANG" 
(
  "I_DOSSIER" INTEGER,
  "SOSA" INTEGER,
  "I_NIVEAU" INTEGER
)
AS
begin exit; end^
COMMIT WORK^
ALTER PROCEDURE "PROC_ANC_COMMUNS" 
(
  "INDIVIDU" INTEGER,
  "INDIVIDU2" INTEGER
)
RETURNS
(
  "COMMUN" INTEGER,
  "ENFANT_1" INTEGER,
  "NIVEAU_1" INTEGER,
  "ENFANT_2" INTEGER,
  "NIVEAU_2" INTEGER
)
AS
begin suspend; end^
COMMIT WORK^


DROP PROCEDURE "PROC_MAJ_CONSANG" ^ 
COMMIT WORK^
DROP PROCEDURE "PROC_ETAT_DENOMB_ASCEND" ^
COMMIT WORK^
DROP PROCEDURE "PROC_PARENTE" ^
COMMIT WORK^
DROP PROCEDURE "PROC_CONSANG" ^
COMMIT WORK^
DROP TABLE "TQ_CONSANG"^
COMMIT WORK^

ALTER TABLE INDIVIDU ADD CONSANGUINITE DOUBLE PRECISION^
COMMIT WORK^

/*Création table temporaire pour calcul de la consanguinité*/
CREATE TABLE "TQ_CONSANG" 
(
  "ID"	 INTEGER,
  "DECUJUS"	 INTEGER,
  "NIVEAU"	 INTEGER,
  "INDI"	 INTEGER,
  "ENFANT"	 INTEGER
)^
COMMIT WORK^
CREATE INDEX "IDX_TQ_CONSANG" ON "TQ_CONSANG"("ID", "INDI", "DECUJUS", "ENFANT", "NIVEAU")^
COMMIT WORK^

CREATE PROCEDURE "PROC_CONSANG" 
(
  "INDIVIDU" INTEGER,
  "INDIVIDU2" INTEGER,
  "NIVEAU_CALCUL" INTEGER
)
RETURNS
(
  "CONSANGUINITE" DOUBLE PRECISION
)
AS
begin suspend; end^
COMMIT WORK^

ALTER PROCEDURE "PROC_CONSANG" 
(
  "INDIVIDU" INTEGER,
  "INDIVIDU2" INTEGER,
  "NIVEAU_CALCUL" INTEGER
)
RETURNS
(
  "CONSANGUINITE" DOUBLE PRECISION
)
AS
/*Procédure créée le 16/12/2005 par André Langlet, modifiée le 17/01/2006
Si INDIVIDU2=0, retourne dans CONSANGUINITE la consanguinité de INDIVIDU.
Sinon, retourne dans CONSANGUINITE la parenté entre INDIVIDU et INDIVIDU2
NIVEAU_CALCUL limite le nombre de niveaux sur lequel est effectué le calcul
ATTENTION, la table TQ_CONSANG doit être vidée avant exécution de cette procédure*/
DECLARE VARIABLE PERE INTEGER;
DECLARE VARIABLE MERE INTEGER;
DECLARE VARIABLE I DOUBLE PRECISION;
DECLARE VARIABLE K INTEGER;
DECLARE VARIABLE I_COUNT INTEGER;
DECLARE VARIABLE NIVEAUX INTEGER;
DECLARE VARIABLE ID INTEGER;
begin
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
      CONSANGUINITE=0;
      SUSPEND;
      EXIT;
    END
  IF (PERE=MERE) THEN
    BEGIN
      CONSANGUINITE=1;
      SUSPEND;
      EXIT;
    END
  ID=GEN_ID(GEN_TQ_ID,1);
  INSERT INTO TQ_CONSANG (ID,DECUJUS,NIVEAU,INDI,ENFANT)
                 VALUES(:ID,:PERE,0,:PERE,:PERE);
  INSERT INTO TQ_CONSANG (ID,DECUJUS,NIVEAU,INDI,ENFANT)
                 VALUES(:ID,:MERE,0,:MERE,:MERE);
  I_COUNT=1;
  K=0;
  WHILE (I_COUNT>0) DO
    BEGIN
      /* l'ascendance du père*/
      /*par les hommes*/
      INSERT INTO TQ_CONSANG (ID,DECUJUS,NIVEAU,INDI,ENFANT)
                SELECT :ID,:PERE,:K+1,i.CLE_PERE,tq.INDI
            FROM TQ_CONSANG tq, INDIVIDU i
            WHERE tq.ID=:ID
              AND tq.DECUJUS=:PERE
              AND tq.NIVEAU=:K
              AND i.CLE_FICHE= tq.INDI
              AND i.CLE_PERE IS NOT NULL;
      /*par les femmes*/
      INSERT INTO TQ_CONSANG (ID,DECUJUS,NIVEAU,INDI,ENFANT)
                SELECT :ID,:PERE,:K+1,i.CLE_MERE,tq.INDI
            FROM TQ_CONSANG tq, INDIVIDU i
            WHERE tq.ID=:ID
              AND tq.DECUJUS=:PERE
              AND tq.NIVEAU=:K
              AND i.CLE_FICHE= tq.INDI
              AND i.CLE_MERE IS NOT NULL;
      /* l'ascendance de la mère*/
      /*par les hommes*/
      INSERT INTO TQ_CONSANG (ID,DECUJUS,NIVEAU,INDI,ENFANT)
                SELECT :ID,:MERE,:K+1,i.CLE_PERE,tq.INDI
            FROM TQ_CONSANG tq, INDIVIDU i
            WHERE tq.ID=:ID
              AND tq.DECUJUS=:MERE
              AND tq.NIVEAU=:K
              AND i.CLE_FICHE= tq.INDI
              AND i.CLE_PERE IS NOT NULL;
      /*par les femmes*/
      INSERT INTO TQ_CONSANG (ID,DECUJUS,NIVEAU,INDI,ENFANT)
                SELECT :ID,:MERE,:K+1,i.CLE_MERE,tq.INDI
            FROM TQ_CONSANG tq, INDIVIDU i
            WHERE tq.ID=:ID
              AND tq.DECUJUS=:MERE
              AND tq.NIVEAU=:K
              AND i.CLE_FICHE= tq.INDI
              AND i.CLE_MERE IS NOT NULL;
      SELECT COUNT(*) FROM TQ_CONSANG WHERE ID=:ID AND NIVEAU=:K+1
            INTO :I_COUNT;
      K=K+1;
      IF (K=NIVEAU_CALCUL) THEN I_COUNT=0; /* pas plus de NIVEAU_CALCUL générations si boucle*/
    END
  CONSANGUINITE=0;
  FOR SELECT ALL p.NIVEAU+m.NIVEAU+1
            FROM TQ_CONSANG p,TQ_CONSANG m
            WHERE p.ID=:ID
              AND p.DECUJUS=:PERE
              AND m.ID=:ID
              AND m.DECUJUS=:MERE
              AND p.INDI=m.INDI
              AND P.ENFANT<>m.ENFANT
          INTO :NIVEAUX
      DO
        begin
          K=1;
          I=1;
          WHILE (K<=NIVEAUX) DO
            BEGIN
              I=I/2;
              K=K+1;
            END
          CONSANGUINITE=CONSANGUINITE+I;
        end
  SUSPEND;
end
 ^

COMMIT WORK^

CREATE PROCEDURE "PROC_PARENTE" 
(
  "CLE_INDIVIDU1" INTEGER,
  "CLE_INDIVIDU2" INTEGER
)
RETURNS
(
  "PARENTE" DOUBLE PRECISION
)
AS
begin suspend; end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_PARENTE" 
(
  "CLE_INDIVIDU1" INTEGER,
  "CLE_INDIVIDU2" INTEGER
)
RETURNS
(
  "PARENTE" DOUBLE PRECISION
)
AS
/* Procédure créée le 16/12/2005 par André Langlet
Retourne dans PARENTE le coefficient de parenté entre deux individus dont
les CLE_FICHE sont entrées en paramètres.
Si CLE_INDIVIDU2=0, c'est la consanguinité de CLE_INDIVIDU1 qui est retournée.
Le calcul est limité à 10 générations*/
DECLARE VARIABLE ID INTEGER;
begin
    DELETE FROM TQ_CONSANG;
    ID=GEN_ID(GEN_TQ_ID,-GEN_ID(GEN_TQ_ID,0));
    SELECT CONSANGUINITE
        FROM PROC_CONSANG(:CLE_INDIVIDU1,:CLE_INDIVIDU2,10)
        INTO :PARENTE;
    DELETE FROM TQ_CONSANG;
    ID=GEN_ID(GEN_TQ_ID,-GEN_ID(GEN_TQ_ID,0));
    SUSPEND;
end
 ^
COMMIT WORK^

CREATE PROCEDURE "PROC_MAJ_CONSANG" 
(
  "I_DOSSIER" INTEGER,
  "SOSA" INTEGER,
  "I_NIVEAU" INTEGER
)
AS
BEGIN EXIT; END ^
COMMIT WORK^


ALTER PROCEDURE "PROC_MAJ_CONSANG" 
(
  "I_DOSSIER" INTEGER,
  "SOSA" INTEGER,
  "I_NIVEAU" INTEGER
)
AS
begin
exit; end
 ^
COMMIT WORK^

CREATE PROCEDURE "PROC_ETAT_DENOMB_ASCEND" 
(
  "A_CLE_FICHE" INTEGER,
  "A_CLE_DOSSIER" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "TOTAL_INDI" INTEGER,
  "TOTAL_INDI_DISTINCT" INTEGER,
  "TOTAL_INDI_THEORIQUE" DOUBLE PRECISION,
  "CUMUL_INDI" INTEGER,
  "CUMUL_INDI_DISTINCT" INTEGER,
  "CUMUL_INDI_THEORIQUE" DOUBLE PRECISION,
  "POURCENT_IMPLEXE" DOUBLE PRECISION
)
AS
begin suspend; end^
COMMIT WORK^

ALTER PROCEDURE "PROC_ETAT_DENOMB_DESCEND" 
(
  "A_CLE_FICHE" INTEGER,
  "A_CLE_DOSSIER" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "TOTAL_INDI" INTEGER,
  "TOTAL_INDI_DISTINCT" INTEGER,
  "CUMUL_INDI" INTEGER,
  "CUMUL_INDI_DISTINCT" INTEGER,
  "POURCENT_IMPLEXE" DOUBLE PRECISION
)
AS
begin
  suspend;
end
 ^

COMMIT WORK^

SET ECHO ON^
/*Passage en version 4.010*/
SET ECHO OFF^

CREATE PROCEDURE "PROC_ANC_COMMUNS" 
(
  "INDIVIDU" INTEGER,
  "INDIVIDU2" INTEGER
)
RETURNS
(
  "COMMUN" INTEGER,
  "ENFANT_1" INTEGER,
  "NIVEAU_1" INTEGER,
  "ENFANT_2" INTEGER,
  "NIVEAU_2" INTEGER
)
AS
BEGIN suspend; END ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ANC_COMMUNS" 
(
  "INDIVIDU" INTEGER,
  "INDIVIDU2" INTEGER
)
RETURNS
(
  "COMMUN" INTEGER,
  "ENFANT_1" INTEGER,
  "NIVEAU_1" INTEGER,
  "ENFANT_2" INTEGER,
  "NIVEAU_2" INTEGER
)
AS
begin
      SUSPEND;
end
 ^
COMMIT WORK^

/*script permettant de modifier la base ancestrologie afin de pouvoir gérer les implexes*/

ALTER TABLE TQ_ARBREREDUIT ADD IMPLEXE DOUBLE PRECISION^
COMMIT WORK^

ALTER PROCEDURE "PROC_ARBREREDUIT" 
(
  "I_CLEF" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER,
  "I_NIVEAU" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "SOSA" INTEGER,
  "NUM_SOSA" DOUBLE PRECISION,
  "IMPLEXE" DOUBLE PRECISION
)
AS
BEGIN suspend; END ^

COMMIT WORK^

ALTER PROCEDURE "PROC_ARBRE" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "SOSA" DOUBLE PRECISION,
  "NUM_SOSA" DOUBLE PRECISION,
  "IMPLEXE" DOUBLE PRECISION
)
AS
begin suspend; end^
COMMIT WORK^

ALTER PROCEDURE "PROC_ARBRE_EXPORT" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "SOSA" DOUBLE PRECISION,
  "CLE_FICHE" INTEGER,
  "CLE_IMPORTATION" VARCHAR(20) CHARACTER SET ISO8859_1,
  "CLE_PARENTS" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "PREFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "SUFFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_NAISSANCE" INTEGER,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_DECES" INTEGER,
  "DECEDE" INTEGER,
  "AGE_AU_DECES" INTEGER,
  "SOURCE" BLOB,
  "COMMENT" BLOB,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NUM_SOSA" DOUBLE PRECISION,
  "OCCUPATION" VARCHAR(90) CHARACTER SET ISO8859_1,
  "NCHI" INTEGER,
  "NMR" INTEGER,
  "CLE_FIXE" INTEGER,
  "IMPLEXE" DOUBLE PRECISION
)
AS begin suspend; end ^

COMMIT WORK^

ALTER PROCEDURE "PROC_ARBRE_ECRAN" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "SOSA" DOUBLE PRECISION,
  "CLE_FICHE" INTEGER,
  "CLE_IMPORTATION" VARCHAR(20) CHARACTER SET ISO8859_1,
  "CLE_PARENTS" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "PREFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "SUFFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_NAISSANCE" INTEGER,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_DECES" INTEGER,
  "DECEDE" INTEGER,
  "AGE_AU_DECES" INTEGER,
  "SOURCE" BLOB,
  "COMMENT" BLOB,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NUM_SOSA" DOUBLE PRECISION,
  "OCCUPATION" VARCHAR(90) CHARACTER SET ISO8859_1,
  "NCHI" INTEGER,
  "NMR" INTEGER,
  "CLE_FIXE" INTEGER,
  "IMPLEXE" DOUBLE PRECISION
)
AS
BEGIN suspend; END ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ETAT_ASCENDANCE" 
(
  "I_CLEF" INTEGER,
  "I_GENERATION" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER
)
RETURNS
(
  "GENERATTION" INTEGER,
  "SOSA" DOUBLE PRECISION,
  "NOM" VARCHAR(101) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_NAISSANCE" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_NAISSANCE" VARCHAR(50) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "CP_DECES" VARCHAR(10) CHARACTER SET ISO8859_1,
  "LIEU_DECES" VARCHAR(50) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "AGE" INTEGER,
  "CLE_FICHE" INTEGER,
  "IMPLEXE" DOUBLE PRECISION
)
AS
begin
     suspend;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ASCEND_DESCEND" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER
)
RETURNS
(
  "MODE" CHAR(1) CHARACTER SET ISO8859_1,
  "CLE_FICHE" INTEGER,
  "PREFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "SUFFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "CLE_PARENTS" INTEGER,
  "SOURCE" BLOB,
  "COMMENT" BLOB,
  "NUM_SOSA" VARCHAR(120) CHARACTER SET ISO8859_1,
  "NIVEAU" INTEGER,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "CLE_MERE" INTEGER,
  "CLE_PERE" INTEGER,
  "NCHI" INTEGER,
  "NMR" INTEGER,
  "CLE_FIXE" INTEGER
)
AS
begin   suspend; end^
COMMIT WORK^

ALTER PROCEDURE "PROC_ETAT_DESCENDANCE" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "SOSA" VARCHAR(120) CHARACTER SET ISO8859_1,
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(101) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "AGE" INTEGER,
  "ORDRE" VARCHAR(255) CHARACTER SET ISO8859_1
)
AS
begin
   suspend;
end
 ^
COMMIT WORK^
ALTER PROCEDURE "PROC_ETAT_DESCENDANCE_PATRONYME" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "SOSA" VARCHAR(120) CHARACTER SET ISO8859_1,
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(101) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "AGE" INTEGER
)
AS
DECLARE VARIABLE I_NOM VARCHAR(60);
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:06:38
   Modifiée le : 12/01/2006 par André pour erreur concaténation si prénom NULL
   à : :
   par :
   Description :  Cette procedure permet de récuperer tous les descendants d'un individu
   en se servant d'une table technique
   Le remplissage de la table est fonction de Niveaux
   0 - Lui Meme
   x - les descendant par niveau
   Usage       :
   ---------------------------------------------------------------------------*/
   /*on recherche le nom de l'individu----------------------------------------*/
   Select Nom
      from individu
      where (kle_dossier = :I_DOSSIER) AND
            (cle_fiche = :I_CLEF)
      INTO :I_NOM;
   FOR SELECT
    NIVEAU,
    SOSA,
    CLE_FICHE,
    COALESCE(NOM||' ','')||COALESCE(PRENOM,''),
    DATE_NAISSANCE,
    DATE_DECES,
    SEXE,
    CLE_PERE,
    CLE_MERE,
    AGE_AU_DECES
    FROM PROC_DESCENDANCE (:I_CLEF, :I_NIVEAU, :I_DOSSIER)
    WHERE NOM = :I_NOM AND ORDRE IS NULL
    INTO :NIVEAU,
         :SOSA,
         :CLE_FICHE,
         :NOM,
         :DATE_NAISSANCE,
         :DATE_DECES,
         :SEXE,
         :CLE_PERE,
         :CLE_MERE,
         :AGE
   do
   suspend;
end
 ^
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

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;

SET ECHO ON;
/*Passage en version 4.015*/
SET ECHO OFF;

COMMIT WORK;
SET AUTODDL OFF;
SET TERM ^ ;

CREATE PROCEDURE "F_MAJ" 
(
  "S_IN" VARCHAR(255) CHARACTER SET ISO8859_1
)
RETURNS
(
  "S_OUT" VARCHAR(255) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend; END ^


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
DECLARE VARIABLE CHR CHAR(1);
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

ALTER PROCEDURE "PROC_ANC_COMMUNS" 
(
  "INDIVIDU" INTEGER,
  "INDIVIDU2" INTEGER
)
RETURNS
(
  "COMMUN" INTEGER,
  "ENFANT_1" INTEGER,
  "ENFANT_2" INTEGER
)
AS
begin
      SUSPEND;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_RENUM_SOSA" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER
)
AS
begin
   exit;
end
 ^
COMMIT WORK^

DROP EXTERNAL FUNCTION MAJ^
COMMIT WORK^

ALTER TRIGGER "EVENEMENTS_IND_AU"
ACTIVE AFTER UPDATE POSITION 0
as
begin
end
 ^
COMMIT WORK^

ALTER TRIGGER "TBD_EVENEMENTS_IND"
ACTIVE BEFORE DELETE POSITION 0
as
/* Création par André pour fonctionnement média (01/10/05)
   Suppression des enregistrements dans SOURCES_RECORD et
   dans MEDIA_POINTEURS si l'enregistrement disparaît.
   24/10/05 ajout maj table T_ASSOCIATIONS
   22/01/2006 maj individu*/
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
  IF (OLD.EV_IND_TYPE='BIRT') THEN
    UPDATE INDIVIDU
      SET DATE_NAISSANCE=NULL,
          ANNEE_NAISSANCE=NULL,
          AGE_AU_DECES=NULL
      WHERE CLE_FICHE=OLD.EV_IND_KLE_FICHE;
  IF (OLD.EV_IND_TYPE='DEAT') THEN
    UPDATE INDIVIDU
      SET DATE_DECES=NULL,
          ANNEE_DECES=NULL,
          AGE_AU_DECES=NULL
      WHERE CLE_FICHE=OLD.EV_IND_KLE_FICHE;
END
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ETAT_TOUTES_FICHES_FAMILLE" 
(
  "I_DOSSIER" INTEGER
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
  "A_EPOUX_SOSA" DOUBLE PRECISION,
  "A_EPOUSE_SOSA" DOUBLE PRECISION
)
AS
BEGIN
           SUSPEND;
END
 ^
COMMIT WORK^

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;

SET ECHO ON;
/*Passage en version 4.019*/
SET ECHO OFF;
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ^ ;

/* Stored procedures */

CREATE PROCEDURE "F_MAJ_SANS_ACCENT" 
(
  "S_IN" VARCHAR(255) CHARACTER SET ISO8859_1
)
RETURNS
(
  "S_OUT" VARCHAR(255) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend; END ^


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
ALTER TRIGGER "T_BI_INDIVIDU" 
ACTIVE BEFORE INSERT POSITION 0
as
begin
exit; end
 ^
COMMIT WORK^
ALTER TRIGGER "T_BU_INDIVIDU"
ACTIVE BEFORE UPDATE POSITION 0
as
begin
exit; end
 ^
COMMIT WORK^

CREATE PROCEDURE "PROC_DERNIER_METIER" 
(
  "I_CLEF" INTEGER
)
RETURNS
(
  "OCCUPATION" VARCHAR(90) CHARACTER SET ISO8859_1
)
AS
/*Créée par André le 10/02/2006
Retourne le dernier métier de l'individu*/
begin
  FOR SELECT EV_IND_DESCRIPTION
             FROM evenements_ind
             WHERE EV_IND_KLE_FICHE=:I_CLEF AND EV_IND_TYPE = 'OCCU'
             ORDER BY EV_IND_ORDRE,EV_IND_DATE_YEAR,EV_IND_DATE
             INTO :OCCUPATION
             DO begin end
  suspend;
end
 ^
COMMIT WORK^
CREATE PROCEDURE "PROC_TQ_DESCENDANCE" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_MODE" INTEGER
)
AS
begin
exit;
end
 ^
COMMIT WORK^
ALTER PROCEDURE "PROC_DESCENDANCE" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "SOSA" VARCHAR(120) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "OCCUPATION" VARCHAR(90) CHARACTER SET ISO8859_1,
  "CLE_FICHE" INTEGER,
  "CLE_IMPORTATION" VARCHAR(20) CHARACTER SET ISO8859_1,
  "CLE_PARENTS" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "PREFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "SUFFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "I_DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_NAISSANCE" INTEGER,
  "I_DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_DECES" INTEGER,
  "DECEDE" INTEGER,
  "AGE_AU_DECES" INTEGER,
  "SOURCE" BLOB,
  "COMMENT" BLOB,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NUM_SOSA" DOUBLE PRECISION,
  "ORDRE" VARCHAR(255) CHARACTER SET ISO8859_1,
  "NCHI" INTEGER,
  "NMR" INTEGER,
  "CLE_FIXE" INTEGER
)
AS
begin
       suspend;
end
 ^
COMMIT WORK^
DROP INDEX TQ_ARBREDESCENDANT_IDX6^
COMMIT WORK^
ALTER TABLE TQ_ARBREDESCENDANT DROP CONSTRAINT FK_TQ_ARBREDESCENDANT^
COMMIT WORK^
ALTER TABLE TQ_ARBREDESCENDANT DROP TQ_DOSSIER^
COMMIT WORK^
ALTER TABLE TQ_ARBREDESCENDANT DROP TQ_ORDRE^
COMMIT WORK^
CREATE INDEX "TQ_ARBREDESCENDANT_NUM_SOSA" ON "TQ_ARBREDESCENDANT"("TQ_NUM_SOSA")^
COMMIT WORK^

CREATE PROCEDURE "PROC_TQ_ASCENDANCE" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_PARQUI" INTEGER,
  "I_MODE" INTEGER
)
AS
begin
EXIT;
end
 ^
COMMIT WORK^

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;

SET ECHO ON;
/*Passage en version 4.020*/
SET ECHO OFF;

ALTER TABLE TQ_ARBREREDUIT DROP CONSTRAINT FK_TQ_ARBREREDUIT;
COMMIT WORK;
CREATE INDEX "TQ_ARBREREDUIT_IDX3" ON "TQ_ARBREREDUIT"("IMPLEXE");
COMMIT WORK;
SET AUTODDL OFF;
SET TERM ^ ;

ALTER PROCEDURE "PROC_ARBRE" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "SOSA" DOUBLE PRECISION,
  "NUM_SOSA" DOUBLE PRECISION,
  "IMPLEXE" DOUBLE PRECISION
)
AS
begin
   suspend;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ARBRE_ECRAN" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "SOSA" DOUBLE PRECISION,
  "CLE_FICHE" INTEGER,
  "CLE_IMPORTATION" VARCHAR(20) CHARACTER SET ISO8859_1,
  "CLE_PARENTS" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "PREFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "SUFFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_NAISSANCE" INTEGER,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_DECES" INTEGER,
  "DECEDE" INTEGER,
  "AGE_AU_DECES" INTEGER,
  "SOURCE" BLOB,
  "COMMENT" BLOB,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NUM_SOSA" DOUBLE PRECISION,
  "OCCUPATION" VARCHAR(90) CHARACTER SET ISO8859_1,
  "NCHI" INTEGER,
  "NMR" INTEGER,
  "CLE_FIXE" INTEGER,
  "IMPLEXE" DOUBLE PRECISION
)
AS
begin
       suspend;
end
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_ARBRE_EXPORT" 
(
  "I_CLEF" INTEGER,
  "I_NIVEAU" INTEGER,
  "I_DOSSIER" INTEGER,
  "I_PARQUI" INTEGER
)
RETURNS
(
  "NIVEAU" INTEGER,
  "SOSA" DOUBLE PRECISION,
  "CLE_FICHE" INTEGER,
  "CLE_IMPORTATION" VARCHAR(20) CHARACTER SET ISO8859_1,
  "CLE_PARENTS" INTEGER,
  "CLE_PERE" INTEGER,
  "CLE_MERE" INTEGER,
  "PREFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NOM" VARCHAR(40) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "SURNOM" VARCHAR(120) CHARACTER SET ISO8859_1,
  "SUFFIXE" VARCHAR(30) CHARACTER SET ISO8859_1,
  "SEXE" INTEGER,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_NAISSANCE" INTEGER,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_DECES" INTEGER,
  "DECEDE" INTEGER,
  "AGE_AU_DECES" INTEGER,
  "SOURCE" BLOB,
  "COMMENT" BLOB,
  "FILLIATION" VARCHAR(30) CHARACTER SET ISO8859_1,
  "NUM_SOSA" DOUBLE PRECISION,
  "OCCUPATION" VARCHAR(90) CHARACTER SET ISO8859_1,
  "NCHI" INTEGER,
  "NMR" INTEGER,
  "CLE_FIXE" INTEGER,
  "IMPLEXE" DOUBLE PRECISION
)
AS
begin
       suspend;
end
 ^
COMMIT WORK^

CREATE PROCEDURE "PROC_GROUPE" 
(
  "I_GROUPE" INTEGER,
  "I_INDIVIDU" INTEGER,
  "MODE" VARCHAR(1) CHARACTER SET ISO8859_1,
  "STRICTE" VARCHAR(1) CHARACTER SET ISO8859_1,
  "TEMOINS" VARCHAR(1) CHARACTER SET ISO8859_1,
  "INITIALISATION" VARCHAR(1) CHARACTER SET ISO8859_1,
  "EFFET" VARCHAR(1) CHARACTER SET ISO8859_1,
  "VERBOSE" VARCHAR(1) CHARACTER SET ISO8859_1
)
RETURNS
(
  "INFO" VARCHAR(50) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend; END ^

COMMIT WORK^
SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;

SET ECHO ON;
/*Passage en version 4.022*/
SET ECHO OFF;
SET TERM ^;
COMMIT WORK^

ALTER PROCEDURE "PROC_GROUPE" 
(
  "I_GROUPE" INTEGER,
  "I_INDIVIDU" INTEGER,
  "MODE" VARCHAR(1) CHARACTER SET ISO8859_1,
  "STRICTE" VARCHAR(1) CHARACTER SET ISO8859_1,
  "TEMOINS" VARCHAR(1) CHARACTER SET ISO8859_1,
  "INITIALISATION" VARCHAR(1) CHARACTER SET ISO8859_1,
  "EFFET" VARCHAR(1) CHARACTER SET ISO8859_1,
  "VERBOSE" VARCHAR(1) CHARACTER SET ISO8859_1
)
RETURNS
(
  "INFO" VARCHAR(50) CHARACTER SET ISO8859_1
)
AS
BEGIN suspend; end^
COMMIT WORK^
SET TERM ; ^

DROP PROCEDURE PROC_GROUPE_EFFET;
COMMIT WORK;
DROP INDEX IDX_INDIVIDU_TRI;
COMMIT WORK;

SET ECHO ON;
/*Passage en version 4.023*/
SET ECHO OFF;

SET AUTODDL OFF;
SET TERM ^ ;

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

ALTER PROCEDURE "PROC_TROUVE_CONJOINTS" 
(
  "I_DOSSIER" INTEGER,
  "I_CLEF" INTEGER
)
RETURNS
(
  "CLE_FICHE" INTEGER,
  "NOM" VARCHAR(60) CHARACTER SET ISO8859_1,
  "PRENOM" VARCHAR(100) CHARACTER SET ISO8859_1,
  "DATE_NAISSANCE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_NAISSANCE" INTEGER,
  "DATE_DECES" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_DECES" INTEGER,
  "SEXE" INTEGER,
  "TYPE_UNION" INTEGER,
  "UNION_CLEF" INTEGER,
  "SOSA" DOUBLE PRECISION,
  "DATE_MARIAGE" VARCHAR(100) CHARACTER SET ISO8859_1,
  "ANNEE_MARIAGE" INTEGER
)
AS
begin
     suspend;
end
 ^
COMMIT WORK^

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;
SET ECHO ON;
/*Passage en version 4.025*/
SET ECHO OFF;
SET TERM ^;
COMMIT WORK^
SET AUTODDL OFF^

CREATE TRIGGER "TBU_T_UNION" FOR "T_UNION" 
ACTIVE BEFORE UPDATE POSITION 0
as
/* Créé par André le 05/03/2006 pour assurer intégrité*/
BEGIN
  IF (NEW.UNION_MARI IS NULL OR NEW.UNION_FEMME IS NULL) THEN
    DELETE FROM EVENEMENTS_FAM
           WHERE EV_FAM_KLE_FAMILLE=NEW.UNION_CLEF;
END
 ^
COMMIT WORK^

ALTER PROCEDURE "PROC_GROUPE" 
(
  "I_GROUPE" INTEGER,
  "I_INDIVIDU" INTEGER,
  "MODE" VARCHAR(1) CHARACTER SET ISO8859_1,
  "STRICTE" VARCHAR(1) CHARACTER SET ISO8859_1,
  "TEMOINS" VARCHAR(1) CHARACTER SET ISO8859_1,
  "INITIALISATION" VARCHAR(1) CHARACTER SET ISO8859_1,
  "EFFET" VARCHAR(1) CHARACTER SET ISO8859_1,
  "VERBOSE" VARCHAR(1) CHARACTER SET ISO8859_1
)
RETURNS
(
  "INFO" VARCHAR(50) CHARACTER SET ISO8859_1
)
AS
BEGIN
  SUSPEND;
END
 ^
COMMIT WORK^

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
ALTER TABLE TQ_ASCENDANCE DROP CONSTRAINT FK_TQ_ASCENDANCE^
COMMIT WORK^
DROP INDEX TQ_ASCENDANCE_NIVEAU^
COMMIT WORK^
ALTER TABLE TQ_COUSINS DROP CONSTRAINT FK_TQ_COUSINS^
COMMIT WORK^
ALTER TABLE TQ_ONCLES DROP CONSTRAINT FK_TQ_ONCLES^
COMMIT WORK^
ALTER TABLE TQ_PRENOMS DROP CONSTRAINT FK_TQ_PRENOMS^
COMMIT WORK^

SET TERM ; ^
COMMIT WORK;
SET AUTODDL ON;
SET ECHO ON;
/*Passage en version 4.027*/
SET ECHO OFF;
/* La version 4.028 a uniquement pour objet des corrections dans ce script et le changement de méthode d'exécution.
Les versions suivantes utiliseront un autre script*/
SET ECHO ON;
/*Passage en version 4.028*/
SET ECHO OFF;

UPDATE T_VERSION_BASE SET VER_VERSION='4.028';
OUTPUT;
exit;
