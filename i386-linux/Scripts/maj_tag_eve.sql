SET ECHO ON;
/*Ce script met à jour les tags des tables de références des évènements 
et de la table des évènements individuels
*/
SET ECHO OFF;

SET AUTODDL ON;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Titre', REF_EVE_VISIBLE = 1,REF_EVE_CAT = 6
WHERE REF_EVE_LIB_COURT = 'TITL' AND REF_EVE_CODE = 127;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Utiliser Titre',REF_EVE_VISIBLE = 0
WHERE REF_EVE_LIB_COURT = 'TITR' AND REF_EVE_CODE = 128;

UPDATE EVENEMENTS_IND SET EV_IND_TYPE = 'TITL' Where EV_IND_TYPE = 'TITR';

UPDATE REF_EVENEMENTS 
SET REF_EVE_LIB_LONG = 'Inhumation/Sépulture',REF_EVE_UNE_FOIS = NULL
/*si on veut prévoir l'exhumation, plusieurs évènements Inhumation/Sépulture*/
WHERE REF_EVE_LIB_COURT = 'BURI' AND REF_EVE_CODE = 23;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Utiliser Inhumation/Sépulture', REF_EVE_VISIBLE = 0
WHERE REF_EVE_LIB_COURT = 'INHU' AND REF_EVE_CODE = 74;

UPDATE EVENEMENTS_IND SET EV_IND_TYPE = 'BURI' Where EV_IND_TYPE = 'INHU';

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Utiliser Bénédiction', REF_EVE_VISIBLE = 0
WHERE REF_EVE_LIB_COURT = 'BENE' AND REF_EVE_CODE = 19;

UPDATE EVENEMENTS_IND SET EV_IND_TYPE = 'BLES' Where EV_IND_TYPE = 'BENE';

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Bénédiction'
WHERE REF_EVE_LIB_COURT = 'BLES' AND REF_EVE_CODE = 21;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Diplôme'
WHERE REF_EVE_LIB_COURT = 'GRAD' AND REF_EVE_CODE = 68;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Utiliser Diplôme', REF_EVE_VISIBLE = 0
WHERE REF_EVE_LIB_COURT = 'DIPL' AND REF_EVE_CODE = 50;

UPDATE EVENEMENTS_IND SET EV_IND_TYPE = 'GRAD' Where EV_IND_TYPE = 'DIPL';

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Ancêtre'
WHERE REF_EVE_LIB_COURT = 'ANCE' AND REF_EVE_CODE = 10;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Ascendance à étudier'
WHERE REF_EVE_LIB_COURT = 'ANCI' AND REF_EVE_CODE = 11;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Annulation d''une union'
WHERE REF_EVE_LIB_COURT = 'ANUL' AND REF_EVE_CODE = 12;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Lien d''associés à un individu'
WHERE REF_EVE_LIB_COURT = 'ASSO' AND REF_EVE_CODE = 13;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Baptême non chrétien'
WHERE REF_EVE_LIB_COURT = 'BAPM' AND REF_EVE_CODE = 16;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Cote ou n° de classement pièce'
WHERE REF_EVE_LIB_COURT = 'CALN' AND REF_EVE_CODE = 24;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Baptême enfant (non Mormon)'
WHERE REF_EVE_LIB_COURT = 'CHR' AND REF_EVE_CODE = 31;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Baptême adulte (non Mormon)'
WHERE REF_EVE_LIB_COURT = 'CHRA' AND REF_EVE_CODE = 32;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Descendance à étudier'
WHERE REF_EVE_LIB_COURT = 'DESI' AND REF_EVE_CODE = 48;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Rupture de l''union (divorce)'
WHERE REF_EVE_LIB_COURT = 'DIV' AND REF_EVE_CODE = 51;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Demande de rupture (divorce)'
WHERE REF_EVE_LIB_COURT = 'DIVF' AND REF_EVE_CODE = 52;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Description physique',REF_EVE_VISIBLE = 1,REF_EVE_CAT=6,REF_EVE_TYPE='I'
WHERE REF_EVE_LIB_COURT = 'DSCR' AND REF_EVE_CODE = 53;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Niveau d''instruction',REF_EVE_VISIBLE = 1,REF_EVE_CAT=5,REF_EVE_TYPE='I'
WHERE REF_EVE_LIB_COURT = 'EDUC' AND REF_EVE_CODE = 54;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Émigration'
WHERE REF_EVE_LIB_COURT = 'EMIG' AND REF_EVE_CODE = 55;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Identifiant d''une personne'
WHERE REF_EVE_LIB_COURT = 'IDNO' AND REF_EVE_CODE = 71;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Publication des bans'
WHERE REF_EVE_LIB_COURT = 'MARB' AND REF_EVE_CODE = 77;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Contrat régissant l''union'
WHERE REF_EVE_LIB_COURT = 'MARC' AND REF_EVE_CODE = 78;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Autorisation légale d''union'
WHERE REF_EVE_LIB_COURT = 'MARL' AND REF_EVE_CODE = 79;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Union (Mariage)'
WHERE REF_EVE_LIB_COURT = 'MARR' AND REF_EVE_CODE = 135;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Contrat avant union'
WHERE REF_EVE_LIB_COURT = 'MARS' AND REF_EVE_CODE = 80;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Nation, Peuple ou Tribu'
WHERE REF_EVE_LIB_COURT = 'NATI' AND REF_EVE_CODE = 83;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Ordination'
WHERE REF_EVE_LIB_COURT = 'ORDN' AND REF_EVE_CODE = 94;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'N° de SS (USA seulement)'
WHERE REF_EVE_LIB_COURT = 'SSN' AND REF_EVE_CODE = 120;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Origine des données'
WHERE REF_EVE_LIB_COURT = 'SUBM' AND REF_EVE_CODE = 123;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Nom/n° code temple Mormon'
WHERE REF_EVE_LIB_COURT = 'TEMP' AND REF_EVE_CODE = 125;

UPDATE REF_EVENEMENTS
SET REF_EVE_LIB_LONG = 'Testament (rédaction)'
WHERE REF_EVE_LIB_COURT = 'WILL' AND REF_EVE_CODE = 134;

SET ECHO ON;
/*Modification des tags exécutée*/
SET ECHO OFF;

COMMIT WORK;
