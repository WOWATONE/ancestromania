/********************* ROLES **********************/

/********************* UDFS ***********************/

/****************** GENERATORS ********************/

CREATE GENERATOR GEN_REF_DEPARTEMENTS;
CREATE GENERATOR GEN_REF_PAYS;
CREATE GENERATOR GEN_REF_REGIONS;
/******************** DOMAINS *********************/

/******************* PROCEDURES ******************/

SET TERM ^ ;
CREATE PROCEDURE F_MAJ_SANS_ACCENT (
    S_IN varchar(255) )
RETURNS (
    S_OUT varchar(255) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
CREATE PROCEDURE PROC_PREP_VILLES_RAYON (
    LIMITE double precision,
    LATITUDEA double precision,
    LONGITUDEA double precision )
RETURNS (
    CP_CODE integer,
    CP_CP varchar(8),
    CP_VILLE varchar(103),
    CP_DEPT integer,
    CP_REGION integer,
    CP_PAYS integer,
    CP_INSEE varchar(6),
    CP_DIVERS varchar(90),
    CP_LATITUDE double precision,
    CP_LONGITUDE double precision,
    DISTANCE double precision,
    DEPARTEMENT varchar(30),
    REGION varchar(50),
    PAYS varchar(30) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

/******************** TABLES **********************/

CREATE TABLE PARAMETRES
(
  GROUPE varchar(25) CHARACTER SET ASCII NOT NULL,
  PARAMETRE varchar(25) CHARACTER SET ASCII NOT NULL,
  VALEUR varchar(255),
  CONSTRAINT PK_PARAMETRES PRIMARY KEY (GROUPE,PARAMETRE)
);
CREATE TABLE REF_CP_VILLES
(
  RCV_CODE integer NOT NULL,
  RCV_POSTE varchar(8),
  RCV_VILLE varchar(50),
  RCV_DEPT integer,
  RCV_REGION integer,
  RCV_PAYS integer,
  RCV_INSEE varchar(6),
  RCV_LATITUDE decimal(11,8),
  RCV_LONGITUDE decimal(11,8),
  RCV_DIVERS varchar(90),
  RCV_VILLE_MAJ varchar(50),
  CONSTRAINT PK_REF_CP_VILLES PRIMARY KEY (RCV_CODE)
);
CREATE TABLE REF_DEPARTEMENTS
(
  RDP_CODE integer NOT NULL,
  RDP_LIBELLE varchar(30),
  RDP_REGION integer,
  RDP_PAYS integer,
  CONSTRAINT PK_REF_DEPARTEMENTS PRIMARY KEY (RDP_CODE)
);
CREATE TABLE REF_HISTOIRE
(
  HI_ID integer NOT NULL,
  HI_DOSSIER integer DEFAULT 0,
  HI_DICORIGINE varchar(8),
  HI_DATE_TEXTE varchar(50) NOT NULL,
  HI_CAT integer,
  HI_TITRE varchar(50),
  HI_TEXTE blob sub_type 1,
  HI_IMAGE blob sub_type 0,
  HI_DATE_CODE_DEBUT integer,
  HI_DATE_CODE_FIN integer,
  CONSTRAINT PK_REF_HISTOIRE PRIMARY KEY (HI_ID)
);
CREATE TABLE REF_PAYS
(
  RPA_CODE integer NOT NULL,
  RPA_LIBELLE varchar(30) NOT NULL,
  RPA_ABREVIATION varchar(3),
  CONSTRAINT PK_REF_PAYS PRIMARY KEY (RPA_CODE)
);
CREATE TABLE REF_REGIONS
(
  RRG_CODE integer NOT NULL,
  RRG_LIBELLE varchar(30),
  RRG_PAYS integer,
  CONSTRAINT PK_REF_REGIONS PRIMARY KEY (RRG_CODE)
);
/********************* VIEWS **********************/

/******************* EXCEPTIONS *******************/

/******************** TRIGGERS ********************/

SET TERM ^ ;
CREATE TRIGGER PARAMETRES_BIU FOR PARAMETRES ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
as
begin
  new.parametre=upper(new.parametre);
  new.groupe=upper(new.groupe);
  new.valeur=trim(new.valeur);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER REF_DEPARTEMENTS_BIU FOR REF_DEPARTEMENTS ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
as
begin
  if (new.rdp_code is null) then
    new.rdp_code=gen_id(gen_ref_departements,1);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER REF_PAYS_BIU FOR REF_PAYS ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
as
begin
  if (new.rpa_code is null) then
    new.rpa_code=gen_id(gen_ref_pays,1);
end^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER REF_REGIONS_BIU FOR REF_REGIONS ACTIVE
BEFORE INSERT OR UPDATE POSITION 0
as
begin
  if (new.rrg_code is null) then
    new.rrg_code=gen_id(gen_ref_regions,1);
end^
SET TERM ; ^

SET TERM ^ ;
ALTER PROCEDURE F_MAJ_SANS_ACCENT (
    S_IN varchar(255) )
RETURNS (
    S_OUT varchar(255) )
AS
declare variable i integer;
declare variable l integer;
declare variable car char(1);
declare variable s_temp varchar(255);
begin
  s_temp=upper(lower(S_IN));
  l=char_length(s_temp);
  s_out='';
  i=1;
  while (i<=l) do
  begin
    car=substring(s_temp from i for 1);
    s_out=case car
      when 'Å“' then s_out||'OE'
      when 'Å’' then s_out||'OE'
      when 'Ã†' then s_out||'AE'
      when 'Ã„' then s_out||'A'
      when 'Ãƒ' then s_out||'A'
      when 'Ã–' then s_out||'O'
      when 'Ã•' then s_out||'O'
      when 'Ã‘' then s_out||'N'
      when 'Ã' then s_out||'Y'
      when 'Ã' then s_out||'D'
      when 'Ã˜' then s_out||'O'
      when 'Ãœ' then s_out||'U'
      when 'Ã‡' then s_out||'C'
    else s_out||car
    end;
    i=i+1;
  end
  suspend;
end^
SET TERM ; ^


SET TERM ^ ;
ALTER PROCEDURE PROC_PREP_VILLES_RAYON (
    LIMITE double precision,
    LATITUDEA double precision,
    LONGITUDEA double precision )
RETURNS (
    CP_CODE integer,
    CP_CP varchar(8),
    CP_VILLE varchar(103),
    CP_DEPT integer,
    CP_REGION integer,
    CP_PAYS integer,
    CP_INSEE varchar(6),
    CP_DIVERS varchar(90),
    CP_LATITUDE double precision,
    CP_LONGITUDE double precision,
    DISTANCE double precision,
    DEPARTEMENT varchar(30),
    REGION varchar(50),
    PAYS varchar(30) )
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
select rcv_code,
  rcv_poste,
  rcv_ville,
  rcv_dept,
  rcv_region,
  rcv_pays,
  rcv_insee,
  rcv_divers,
  rcv_latitude,
  rcv_longitude
from ref_cp_villes
where rcv_latitude between cast(:latmin as decimal(11,8)) and cast(:latmax as decimal(11,8))
  and (rcv_longitude between cast(:longmin as decimal(11,8)) and cast(:longmax as decimal(11,8))
  or rcv_longitude between cast(:longmin+360 as decimal(11,8)) and cast(180 as decimal(11,8))
  or rcv_longitude between cast(-180 as decimal(11,8)) and cast(:longmax-360 as decimal(11,8)))
into :cp_code,
  :cp_cp,
  :cp_ville,
  :cp_dept,
  :cp_region,
  :cp_pays,
  :cp_insee,
  :cp_divers,
  :cp_latitude,
  :cp_longitude
  do
  begin
    ok=0;
    if (cp_latitude=latitudea and cp_longitude=longitudea) then
    begin
      distance=0;
      ok=1;
    end
    else
    begin
      distance=6367*acos(sinlat*sin(cp_latitude*degrad)+coslat*cos(cp_latitude*degrad)*cos((longitudea-cp_longitude)*degrad));
      if (distance<=limite) then
        ok=1;
    end
    if (ok=1) then
    begin
      select first(1) rdp_libelle from ref_departements where rdp_code=:cp_dept
        into :departement;
      select first(1) rrg_libelle from ref_regions where rrg_code=:cp_region
        into :region;
      select first(1) rpa_libelle from ref_pays where rpa_code=:cp_pays
        into :pays;
      suspend;
    end
  end
end^
SET TERM ; ^

UPDATE RDB$PROCEDURES set
  RDB$DESCRIPTION = 'crÃ©ation par AndrÃ©
Utilisations: Villes voisines Ancestromania et Cassinivision'
  where RDB$PROCEDURE_NAME = 'PROC_PREP_VILLES_RAYON';

ALTER TABLE REF_CP_VILLES ADD CONSTRAINT FK_REF_CP_VILLES_DEPT
  FOREIGN KEY (RCV_DEPT) REFERENCES REF_DEPARTEMENTS (RDP_CODE) ON UPDATE CASCADE ON DELETE CASCADE
  USING INDEX IDX_REF_CP_VILLES_DEPT;
ALTER TABLE REF_CP_VILLES ADD CONSTRAINT FK_REF_CP_VILLES_PAYS
  FOREIGN KEY (RCV_PAYS) REFERENCES REF_PAYS (RPA_CODE) ON UPDATE CASCADE
  USING INDEX IDX_REF_CP_VILLES_PAYS;
ALTER TABLE REF_CP_VILLES ADD CONSTRAINT FK_REF_CP_VILLES_REGION
  FOREIGN KEY (RCV_REGION) REFERENCES REF_REGIONS (RRG_CODE) ON UPDATE CASCADE ON DELETE CASCADE
  USING INDEX IDX_REF_CP_VILLES_REGION;
CREATE INDEX IDX_REF_CP_VILLES_INSEE ON REF_CP_VILLES (RCV_INSEE);
CREATE INDEX IDX_REF_CP_VILLES_LATITUDE ON REF_CP_VILLES (RCV_LATITUDE);
CREATE INDEX IDX_REF_CP_VILLES_LONGITUDE ON REF_CP_VILLES (RCV_LONGITUDE);
CREATE INDEX IDX_REF_CP_VILLES_POSTE ON REF_CP_VILLES (RCV_POSTE);
CREATE INDEX IDX_REF_CP_VILLES_VILLE ON REF_CP_VILLES (RCV_VILLE);
CREATE INDEX IDX_REF_CP_VILLES_VILLE_MAJ ON REF_CP_VILLES (RCV_VILLE_MAJ);
ALTER TABLE REF_DEPARTEMENTS ADD CONSTRAINT FK_REF_DEPARTEMENTS_PAYS
  FOREIGN KEY (RDP_PAYS) REFERENCES REF_PAYS (RPA_CODE) ON UPDATE CASCADE ON DELETE CASCADE
  USING INDEX IDX_REF_DEPARTEMENT_PAYS;
ALTER TABLE REF_DEPARTEMENTS ADD CONSTRAINT FK_REF_DEPARTEMENTS_REGION
  FOREIGN KEY (RDP_REGION) REFERENCES REF_REGIONS (RRG_CODE) ON UPDATE CASCADE ON DELETE CASCADE
  USING INDEX IDX_REF_DEPARTEMENTS_REGION;
CREATE INDEX IDX_REF_DEPARTEMENTS_LIBELLE ON REF_DEPARTEMENTS (RDP_LIBELLE);
CREATE INDEX IDX_REF_HISTOIRE_DEBUT ON REF_HISTOIRE (HI_DATE_CODE_DEBUT);
CREATE DESCENDING INDEX IDX_REF_HISTOIRE_DEBUT_DESC ON REF_HISTOIRE (HI_DATE_CODE_DEBUT);
CREATE INDEX IDX_REF_HISTOIRE_DICORIGINE ON REF_HISTOIRE (HI_DICORIGINE);
CREATE INDEX IDX_REF_HISTOIRE_DOSSIER ON REF_HISTOIRE (HI_DOSSIER);
CREATE INDEX IDX_REF_HISTOIRE_FIN ON REF_HISTOIRE (HI_DATE_CODE_FIN);
CREATE INDEX IDX_REF_PAYS_LIBELLE ON REF_PAYS (RPA_LIBELLE);
ALTER TABLE REF_REGIONS ADD CONSTRAINT FK_REF_REGIONS
  FOREIGN KEY (RRG_PAYS) REFERENCES REF_PAYS (RPA_CODE) ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX IDX_REF_REGIONS_LIBELLE ON REF_REGIONS (RRG_LIBELLE);
GRANT EXECUTE
 ON PROCEDURE F_MAJ_SANS_ACCENT TO  SYSDBA;

GRANT EXECUTE
 ON PROCEDURE PROC_PREP_VILLES_RAYON TO  SYSDBA;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON PARAMETRES TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_CP_VILLES TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_DEPARTEMENTS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_HISTOIRE TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_PAYS TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON REF_REGIONS TO  SYSDBA WITH GRANT OPTION;


