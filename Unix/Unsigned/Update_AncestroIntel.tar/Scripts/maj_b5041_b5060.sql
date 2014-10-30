SET ECHO ON;
/*Ce script maj_b5041_b5060.sql ne doit s'appliquer qu'à des bases de niveau mini b5.040
Firebird 2.0 doit être installé.*/
SET ECHO OFF;
set sql dialect 3;
SET NAMES ISO8859_1;
COMMIT WORK;
SET AUTODDL OFF;

SET TERM ^ ; 

alter trigger tad_evenements_ind
active after delete position 0
as
begin
  if (old.ev_ind_type='BIRT') then
    update individu
      set date_naissance=null,
          annee_naissance=null,
          age_au_deces=null
      where cle_fiche=old.ev_ind_kle_fiche;
  if (old.ev_ind_type='DEAT') then
    update individu
      set date_deces=null,
          annee_deces=null,
          age_au_deces=null
      where cle_fiche=old.ev_ind_kle_fiche;
  if (old.ev_ind_type in('DEAT','BURI','CREM')) then
    update individu
      set decede=null
      where cle_fiche=old.ev_ind_kle_fiche
          and not exists (select * from evenements_ind
              where ev_ind_type in('DEAT','BURI','CREM')
                and ev_ind_kle_fiche=old.ev_ind_kle_fiche);
end^
commit^

comment on trigger tad_evenements_ind is 
'Création par André le 25/03/2006 modifié le 14/11/2007: ajout CREM.'^
commit^

alter trigger evenements_ind_au
active after update position 0
as
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 01/08/2001
   à : 05:34:41
   Modifiée le :25/03/2006 par André, activé si dates différentes
   à : :
   par :
   Description : Mets à jour les dates naissance et décès d un individu
   Usage       :
   ---------------------------------------------------------------------------*/
  if ((new.ev_ind_type='BIRT' or new.ev_ind_type='DEAT')
      and new.ev_ind_date_writen is distinct from old.ev_ind_date_writen) then
      execute procedure proc_maj_date_un_ind(
                          new.ev_ind_kle_fiche,
                          new.ev_ind_type,
                          new.ev_ind_date_writen,
                          new.ev_ind_date_year );
end^
commit^

alter trigger tbu_evenements_ind
active before update position 0
as
begin
if (new.ev_ind_date_writen is distinct from old.ev_ind_date_writen) then
  select imois,ian,ddate,imois_fin,ian_fin,ddate_fin,date_writen_s
  from proc_date_writen(new.ev_ind_date_writen)
    into new.ev_ind_date_mois,new.ev_ind_date_year,new.ev_ind_date,
         new.ev_ind_date_mois_fin,new.ev_ind_date_year_fin,new.ev_ind_date_fin,
         new.ev_ind_date_writen;
if (new.ev_ind_type is distinct from old.ev_ind_type) then
  select r.ref_eve_lib_long
        ,'EVEN'
  from ref_evenements r
  where r.ref_eve_lib_court=new.ev_ind_type
    and exists (select *
                from evenements_ind e
                inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type
                                           and r.ref_eve_une_fois=1
                where e.ev_ind_kle_fiche=new.ev_ind_kle_fiche
                  and e.ev_ind_type=new.ev_ind_type)
  into new.ev_ind_titre_event
      ,new.ev_ind_type;
if (new.ev_ind_acte<1 or new.ev_ind_acte is null) then
begin
  if (new.ev_ind_acte is null) then
    new.ev_ind_acte=0;
  if (old.ev_ind_acte=1) then
    delete from media_pointeurs
    where mp_pointe_sur=old.ev_ind_clef
      and mp_table='I'
      and mp_type_image='A';
end
end^
commit^

comment on trigger tbu_evenements_ind is 
'Créé par André le 18/11/2005 pour mettre à jour les dates
01/06/2006 ajout des mois, dates de fin et normalisation date saisie
12/2/2007 contrôle événement en double
11/05/2007 mise à jour media_pointeurs
14/11/2007 optimisation'^
commit^

alter trigger evenements_ind_bi
active before insert position 0
as
declare variable i integer;
declare variable l integer;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 01/08/2001
   à : 05:35:14
   Modifié par André le 01/06/2006 ajout des mois, dates de fin et normalisation date saisie
   le 1/10/2006 traitement Y et EVEN, 12/2/2007 contrôle événement en double.
   ---------------------------------------------------------------------------*/
  if (new.ev_ind_clef is null) then
      new.ev_ind_clef = gen_id(gen_ev_ind_clef,1);
  select imois,ian,ddate,imois_fin,ian_fin,ddate_fin,date_writen_s
  from proc_date_writen(new.ev_ind_date_writen)
    into new.ev_ind_date_mois,new.ev_ind_date_year,new.ev_ind_date,
         new.ev_ind_date_mois_fin,new.ev_ind_date_year_fin,new.ev_ind_date_fin,
         new.ev_ind_date_writen;
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
  select r.ref_eve_lib_long
        ,'EVEN'
  from ref_evenements r
  where r.ref_eve_lib_court=new.ev_ind_type
    and exists (select *
                from evenements_ind e
                inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type
                                           and r.ref_eve_une_fois=1
                where e.ev_ind_kle_fiche=new.ev_ind_kle_fiche
                  and e.ev_ind_type=new.ev_ind_type)
  into new.ev_ind_titre_event
      ,new.ev_ind_type;
end^
commit^

CREATE OR ALTER PROCEDURE PROC_DELTA_DATES (
    date_deb date,
    mois_deb integer,
    an_deb integer,
    date_fin date,
    mois_fin integer,
    an_fin integer)
returns (
    delta_jours integer)
as
begin
  if ((date_deb is null and an_deb is null)
    or (date_fin is null and an_fin is null)
    or (mois_deb is not null and mois_deb not between 1 and 12)
    or (mois_fin is not null and mois_fin not between 1 and 12)) then
  begin
    suspend;
    exit;
  end
  if ((date_deb is not null or an_deb>0) and (date_fin is not null or an_fin>0)) then
  begin
    if (date_deb is null) then
      date_deb=cast(coalesce(mois_deb||'/15','7/1')||'/'||an_deb as date);
    if (date_fin is null) then
      date_fin=cast(coalesce(mois_fin||'/15','7/1')||'/'||an_fin as date);
    delta_jours=date_fin-date_deb;
  end
  else
  begin
    if (date_deb is not null) then
    begin
      mois_deb=extract(month from date_deb);
      an_deb=extract(year from date_deb);
    end
    if (date_fin is not null) then
    begin
      mois_fin=extract(month from date_fin);
      an_fin=extract(year from date_fin);
    end
    if (an_deb is not null and an_fin is not null) then
    begin
      delta_jours=cast((an_fin-an_deb)*365.25
                      +(coalesce(mois_fin-0.5,6)-coalesce(mois_deb-0.5,6))*30.4375
                       as integer);
    end
  end
  suspend;
end^
commit^

COMMENT ON PROCEDURE PROC_DELTA_DATES IS
'Création par André le 14/11/2007.
Retourne le nombre de jours entre 2 dates.
Si la date complète existe (après JC uniquement), mois et année ne sont pas
nécessaires.'^
commit^

CREATE OR ALTER PROCEDURE PROC_AGE_A_DATE (
    i_clef_indi integer,
    date_eve date,
    mois_eve integer,
    an_eve integer)
returns (
    age integer,
    date_nais date,
    mois_nais integer,
    an_nais integer)
as
begin
  if (date_eve is null and an_eve is null) then
  begin
    suspend;
    exit;
  end
  select first 1
    ev_ind_date
   ,ev_ind_date_mois
   ,ev_ind_date_year
   from evenements_ind
   where ev_ind_kle_fiche=:i_clef_indi
     and ev_ind_type='BIRT'
   into
     :date_nais
    ,:mois_nais
    ,:an_nais;
  if (an_nais is not null) then
  begin
    select delta_jours
    from proc_delta_dates(:date_nais,:mois_nais,:an_nais
                          ,:date_eve,:mois_eve,:an_eve)
    into :age;
  end
  suspend;
end^
commit^

COMMENT ON PROCEDURE PROC_AGE_A_DATE IS
'Création par André le 14/11/2007.
Retourne l''âge d''un individu à une date.
Si la date complète existe (après JC uniquement), mois et année ne sont pas
imposés.'^
commit^

ALTER PROCEDURE PROC_EVE_IND (
    i_cle integer)
returns (
    ev_ind_clef integer,
    ev_ind_kle_fiche integer,
    ev_ind_kle_dossier integer,
    ev_ind_type varchar(7),
    ev_ind_date_writen varchar(100),
    ev_ind_date_year integer,
    ev_ind_date date,
    ev_ind_adresse varchar(50),
    ev_ind_cp varchar(10),
    ev_ind_ville varchar(50),
    ev_ind_dept varchar(30),
    ev_ind_pays varchar(30),
    ev_ind_cause varchar(90),
    ev_ind_source blob sub_type 1 segment size 80,
    ev_ind_comment blob sub_type 1 segment size 80,
    ev_ind_typeannee integer,
    ev_ind_description varchar(90),
    ev_ind_region varchar(50),
    ev_ind_subd varchar(50),
    ev_libelle varchar(30),
    ev_ind_acte integer,
    ev_ind_insee varchar(6),
    ev_ind_heure time,
    ev_ind_ordre integer,
    ev_ind_titre_event varchar(40),
    ev_ind_latitude decimal(15,8),
    ev_ind_longitude numeric(15,8),
    ev_ind_media integer,
    ev_ind_age integer,
    ev_ind_details integer)
as
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:10:10
   Modifications par André, ajout eve.EV_IND_DATE, eve.EV_IND_TYPE dans order by
   et EV_LIBELLE dépendant du type EVEN. Ajout MOIS,latitude, longitude, TITRE='Divers'
   EV_IND_MEDIA, EV_IND_AGE, EV_IND_DETAILS
   Dernière modification: 13/11/2007
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
                when 'EVEN' then coalesce(e.ev_ind_titre_event,'Divers')
                else r.ref_eve_lib_long
                end
          ,e.ev_ind_acte
          ,e.ev_ind_insee
          ,e.ev_ind_heure
          ,e.ev_ind_ordre
          ,case e.ev_ind_type
                when 'EVEN' then coalesce(e.ev_ind_titre_event,'Divers')
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
                else (select coalesce(age,0)
                      from proc_age_a_date( e.ev_ind_kle_fiche
                                           ,e.ev_ind_date
                                           ,e.ev_ind_date_mois
                                           ,e.ev_ind_date_year))
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
       from  evenements_ind e
       inner join ref_evenements r on r.ref_eve_lib_court = e.ev_ind_type
       where  e.ev_ind_kle_fiche = :i_cle
       order by e.ev_ind_ordre nulls last
               ,e.ev_ind_date_year nulls last
               ,e.ev_ind_date_mois nulls last
               ,e.ev_ind_date nulls last
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
commit^

ALTER PROCEDURE PROC_AGE_UNIONS (
    i_clef integer)
returns (
    age integer)
as
declare variable clef_union integer;
begin
for select union_clef from proc_trouve_unions(0,:I_CLEF)
    into clef_union
do
  for select (select age
              from proc_age_a_date(:i_clef
                                  ,e.ev_fam_date
                                  ,e.ev_fam_date_mois
                                  ,e.ev_fam_date_year))
      from evenements_fam e
      where e.ev_fam_kle_famille=:clef_union
        and e.ev_fam_type='MARR'
      into :age
  do
    if (age is not null) then
      suspend;
end^
commit^

COMMENT ON PROCEDURE PROC_AGE_UNIONS IS
'Créée par André
Retourne les âges d''un individu lors de ses mariages.'^
commit^

alter PROCEDURE PROC_ECLATE_PRENOM (
    S_PRENOM VARCHAR(255))
RETURNS (
    PRENOM VARCHAR(255))
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
commit^

alter PROCEDURE PROC_LISTE_PROFESSION (
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

alter PROCEDURE PROC_PREP_PROFESSIONS (
    I_DOSSIER INTEGER)
RETURNS (
    PROFESSION VARCHAR(90))
AS
begin suspend; end^
commit^

alter PROCEDURE PROC_ECLATE_DESCRIPTION(
    DESCRIPTION VARCHAR(255),
    SEPARATEUR CHAR(1))
RETURNS (
    S_DESCRIPTION VARCHAR(255))
AS
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE I_LEN INTEGER;
DECLARE VARIABLE D INTEGER;
begin
/*Procédure créée par André le 22/05/2007, dernière modification 24/09/2007
Découpe la description contenant le séparateur en descriptions élémentaires*/
  I_LEN=char_length(DESCRIPTION);
  I=1;
  D=I;
  while (I<=I_LEN) do
  begin
    if (SUBSTRING(DESCRIPTION from I for 1)=separateur) then
    begin
      S_DESCRIPTION=trim(SUBSTRING(DESCRIPTION from D for I-D));
      if (S_DESCRIPTION<>'') then SUSPEND;
      I=I+1;
      D=I;
    end
    else
      I=I+1;
  end
  S_DESCRIPTION=trim(SUBSTRING(DESCRIPTION from D));
  if (char_length(S_DESCRIPTION)>0) then SUSPEND;
end^
commit^

alter PROCEDURE PROC_PREP_PROFESSIONS (
    I_DOSSIER INTEGER)
RETURNS (
    PROFESSION VARCHAR(90))
AS
DECLARE VARIABLE S_PROFESSION VARCHAR(90) CHARACTER SET ISO8859_1;
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
commit^

alter PROCEDURE PROC_LISTE_PROFESSION (
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
commit^

alter PROCEDURE PROC_POSITION_GEO_EVENT (
    ICLEF INTEGER)
RETURNS (
    EV_LIBELLE VARCHAR(30),
    EV_IND_CP VARCHAR(10),
    EV_IND_VILLE VARCHAR(50),
    CP_LONGITUDE NUMERIC(15,8),
    CP_LATITUDE NUMERIC(15,8),
    ANNEE INTEGER)
AS
BEGIN
/*modifications André le 28/09/2007, EV_FAM sélectionné également pour la femme
utilisation des coordonnées mémorisées dans l'événement et classement par date*/
  FOR select all
             x.evenement
            ,x.cp
            ,substring(x.ville from 1 for 50)
            ,x.longitude
            ,x.latitude
            ,x.annee
    from
    (select case e.ev_ind_type
                when 'EVEN' then coalesce(e.ev_ind_titre_event,'Divers')
                else r.ref_eve_lib_long
                end  as evenement
           ,e.EV_IND_CP  as cp
           ,e.EV_IND_VILLE||coalesce('/'||e.ev_ind_subd,'') as ville
           ,e.ev_ind_longitude as longitude
           ,e.ev_ind_latitude as latitude
           ,e.ev_ind_date_year as annee
           ,e.ev_ind_date_mois as mois
           ,e.ev_ind_date as "date"
    FROM EVENEMENTS_IND e
    inner join ref_evenements r on r.REF_eve_lib_court = e.EV_IND_TYPE
    where  e.ev_ind_kle_fiche = :iclef
       and e.ev_ind_latitude is not null
       and e.ev_ind_longitude is not null
    UNION
    select rf.ref_eve_lib_long
          ,ef.ev_fam_cp
          ,ef.ev_fam_ville||coalesce('/'||ef.ev_fam_subd,'')
          ,ef.ev_fam_longitude
          ,ef.ev_fam_latitude
          ,ef.ev_fam_date_year
          ,ef.ev_fam_date_mois
          ,ef.ev_fam_date
       FROM T_UNION u
            inner join EVENEMENTS_FAM ef on ef.ev_fam_kle_famille=u.union_clef
                                        and ef.ev_fam_latitude is not null
                                        and ef.ev_fam_longitude is not null
            inner join ref_evenements rf on rf.ref_eve_lib_court=ef.ev_fam_type
       WHERE :ICLEF in (u.union_mari,u.union_femme)
    UNION
    select CAST('Domicile' AS VARCHAR(30))
          ,a.ADR_CP
          ,a.ADR_VILLE||coalesce('/'||a.adr_subd,'')
          ,a.adr_longitude
          ,a.adr_latitude
          ,a.adr_date_year_1
          ,a.adr_date_mois_1
          ,a.adr_date_1
       FROM ADRESSES_IND a
       WHERE a.ADR_KLE_IND=:ICLEF
         and a.adr_latitude is not null
         and a.adr_longitude is not null) as x
    order by x.annee
            ,x.mois
            ,x."date"
    INTO
      :EV_LIBELLE
     ,:EV_IND_CP
     ,:EV_IND_VILLE
     ,:CP_LONGITUDE
     ,:CP_LATITUDE
     ,:annee
  DO
    SUSPEND;
END^
commit^

alter PROCEDURE PROC_ETAT_DENOMB_ASCEND (
    A_CLE_FICHE INTEGER,
    A_CLE_DOSSIER INTEGER)
RETURNS (
    NIVEAU INTEGER,
    TOTAL_INDI INTEGER,
    TOTAL_INDI_DISTINCT INTEGER,
    TOTAL_INDI_THEORIQUE DOUBLE PRECISION,
    CUMUL_INDI INTEGER,
    CUMUL_INDI_DISTINCT INTEGER,
    CUMUL_INDI_THEORIQUE DOUBLE PRECISION,
    POURCENT_IMPLEXE DOUBLE PRECISION)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:06:04
   Modifiée le : 19/12/2005 par André pour fonctionnement état et calcul consanguinité
   Pour des raisons de compatibilité avec l'état de dénombrement d'ascendance,
   100*CONSANGUINITE est retourné dans la variable POURCENT_IMPLEXE
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
    delete from tq_ascendance;
    insert into tq_ascendance (TQ_NIVEAU,TQ_CLE_FICHE,TQ_DOSSIER)
           values ( 1, :A_CLE_FICHE, :A_CLE_DOSSIER);
    NIVEAU=1;
    TOTAL_INDI=1;
    TOTAL_INDI_THEORIQUE=1;
    CUMUL_INDI_THEORIQUE=0;
    SELECT 100*PARENTE FROM PROC_PARENTE(:A_CLE_FICHE,0) INTO :POURCENT_IMPLEXE;
    WHILE (TOTAL_INDI>0) DO
      BEGIN
        INSERT INTO tq_ascendance (TQ_NIVEAU,TQ_CLE_FICHE,TQ_DOSSIER)
          SELECT :NIVEAU+1, i.CLE_PERE, :A_CLE_DOSSIER
            FROM tq_ascendance t,INDIVIDU i
            WHERE t.TQ_NIVEAU=:NIVEAU AND i.CLE_FICHE= t.TQ_CLE_FICHE;
        INSERT INTO tq_ascendance (TQ_NIVEAU,TQ_CLE_FICHE,TQ_DOSSIER)
          SELECT :NIVEAU+1, i.CLE_MERE, :A_CLE_DOSSIER
            FROM tq_ascendance t,INDIVIDU i
            WHERE t.TQ_NIVEAU=:NIVEAU AND i.CLE_FICHE= t.TQ_CLE_FICHE;
        SELECT COUNT(TQ_CLE_FICHE),COUNT(DISTINCT TQ_CLE_FICHE)
               FROM tq_ascendance WHERE TQ_NIVEAU=:NIVEAU+1
               INTO :TOTAL_INDI,:TOTAL_INDI_DISTINCT;
        IF (TOTAL_INDI>0) THEN
          begin
            SELECT COUNT(TQ_CLE_FICHE)-1,COUNT(DISTINCT TQ_CLE_FICHE)-1
               FROM tq_ascendance
               INTO :CUMUL_INDI,:CUMUL_INDI_DISTINCT;
            TOTAL_INDI_THEORIQUE=TOTAL_INDI_THEORIQUE*2;
            CUMUL_INDI_THEORIQUE=CUMUL_INDI_THEORIQUE+TOTAL_INDI_THEORIQUE;
            IF (NIVEAU>1) THEN
              POURCENT_IMPLEXE=100*cast(CUMUL_INDI-CUMUL_INDI_DISTINCT AS DOUBLE PRECISION)/CUMUL_INDI;
            NIVEAU=NIVEAU+1;
            SUSPEND;
            IF (NIVEAU>100) THEN TOTAL_INDI=0;
          end
      END
    /* on vide la table temporaire */
    delete from tq_ascendance;
end^
commit^

alter PROCEDURE PROC_ETAT_DENOMB_DESCEND (
    A_CLE_FICHE INTEGER,
    A_CLE_DOSSIER INTEGER)
RETURNS (
    NIVEAU INTEGER,
    TOTAL_INDI INTEGER,
    TOTAL_INDI_DISTINCT INTEGER,
    CUMUL_INDI INTEGER,
    CUMUL_INDI_DISTINCT INTEGER,
    POURCENT_IMPLEXE DOUBLE PRECISION)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:06:13
   Modifiée le : 19/12/2005 par André le calcul utilisant PROC_DESCENDANCE ne
   comptant que les individus distincts, et les individus étant comptés deux
   fois dans les cumuls.
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
    delete from tq_ascendance;
    insert into tq_ascendance (TQ_NIVEAU,TQ_CLE_FICHE,TQ_DOSSIER)
           values ( 1, :A_CLE_FICHE, :A_CLE_DOSSIER);
    NIVEAU=1;
    TOTAL_INDI=1;
    WHILE (TOTAL_INDI>0) DO
      BEGIN
        INSERT INTO tq_ascendance (TQ_NIVEAU,TQ_CLE_FICHE,TQ_DOSSIER)
          SELECT :NIVEAU+1, i.CLE_FICHE, :A_CLE_DOSSIER
            FROM tq_ascendance t,INDIVIDU i
            WHERE t.TQ_NIVEAU=:NIVEAU AND
                 (i.CLE_PERE= t.TQ_CLE_FICHE OR i.CLE_MERE=t.TQ_CLE_FICHE);
        SELECT COUNT(TQ_CLE_FICHE),COUNT(DISTINCT TQ_CLE_FICHE)
               FROM tq_ascendance WHERE TQ_NIVEAU=:NIVEAU+1
               INTO :TOTAL_INDI,:TOTAL_INDI_DISTINCT;
        IF (TOTAL_INDI>0) THEN
          begin
            SELECT COUNT(TQ_CLE_FICHE)-1,COUNT(DISTINCT TQ_CLE_FICHE)-1
               FROM tq_ascendance
               INTO :CUMUL_INDI,:CUMUL_INDI_DISTINCT;
            POURCENT_IMPLEXE=100*cast(CUMUL_INDI-CUMUL_INDI_DISTINCT AS DOUBLE PRECISION)/CUMUL_INDI;
            NIVEAU=NIVEAU+1;
            SUSPEND;
            IF (NIVEAU>100) THEN TOTAL_INDI=0;
          end
      END
    /* on vide la table temporaire */
    delete from tq_ascendance;
end^
commit^

alter PROCEDURE PROC_ASCEND_DESCEND (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_DOSSIER INTEGER,
    I_PARQUI INTEGER)
RETURNS (
    MODE CHAR(1),
    CLE_FICHE INTEGER,
    PREFIXE VARCHAR(30),
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    SURNOM VARCHAR(120),
    SUFFIXE VARCHAR(30),
    SEXE INTEGER,
    CLE_PARENTS INTEGER,
    SOURCE BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    COMMENT BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    NUM_SOSA VARCHAR(120),
    NIVEAU INTEGER,
    FILLIATION VARCHAR(30),
    CLE_MERE INTEGER,
    CLE_PERE INTEGER,
    NCHI INTEGER,
    NMR INTEGER,
    CLE_FIXE INTEGER)
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
commit^

alter PROCEDURE PROC_MAJ_INSEE (
    I_DOSSIER INTEGER)
AS
DECLARE VARIABLE S_INSEE VARCHAR(6);
DECLARE VARIABLE I_CLEF INTEGER;
begin
/*Copyright Philippe Cazaux-Moutou. Tout droits réservés.
  Créé le : 31/07/2001
  Modifiée par André le 04/10/2007: mise à jour possible si le code INSEE
  existe dans la table de référence.
  Description : Met à jour le champ INSEE dans les événements et adresses*/
  /* Les individus --------------------------------------------------------- */
  for select e.ev_ind_clef
            ,max(v.cp_insee)
     from evenements_ind e
     inner join ref_pays p on p.rpa_libelle=upper(e.ev_ind_pays)
     inner join ref_cp_ville v on v.cp_pays=p.rpa_code
                              and v.cp_ville_maj=upper(e.ev_ind_ville)
                              and (v.cp_cp=e.ev_ind_cp
                                   or (v.cp_cp is null and e.ev_ind_cp is null))
     where e.ev_ind_kle_dossier=:I_DOSSIER
     group by e.ev_ind_clef
     into :I_CLEF
         ,:s_insee
     do update evenements_ind e
        set e.ev_ind_insee=:s_insee
        where e.ev_ind_clef=:I_CLEF;
  /* Les familles----------------------------------------------------------- */
  for select e.ev_fam_clef
            ,max(v.cp_insee)
     from evenements_fam e
     inner join ref_pays p on p.rpa_libelle=upper(e.ev_fam_pays)
     inner join ref_cp_ville v on v.cp_pays=p.rpa_code
                              and v.cp_ville_maj=upper(e.ev_fam_ville)
                              and (v.cp_cp=e.ev_fam_cp
                                   or (v.cp_cp is null and e.ev_fam_cp is null))
     where e.ev_fam_kle_dossier=:I_DOSSIER
     group by e.ev_fam_clef
     into :I_CLEF
         ,:s_insee
     do update evenements_fam e
        set e.ev_fam_insee=:s_insee
        where e.ev_fam_clef=:I_CLEF;

  /* Les Domiciles---------------------------------------------------------- */
  for select e.adr_clef
            ,max(v.cp_insee)
     from adresses_ind e
     inner join ref_pays p on p.rpa_libelle=upper(e.adr_pays)
     inner join ref_cp_ville v on v.cp_pays=p.rpa_code
                              and v.cp_ville_maj=upper(e.adr_ville)
                              and (v.cp_cp=e.adr_cp
                                   or (v.cp_cp is null and e.adr_cp is null))
     where e.adr_kle_dossier=:I_DOSSIER
     group by e.adr_clef
     into :I_CLEF
         ,:s_insee
     do update adresses_ind e
        set e.adr_insee=:s_insee
        where e.adr_clef=:I_CLEF;

end^
commit^

ALTER PROCEDURE PROC_GET_CLEF_UNIQUE (
    a_table varchar(30))
returns (
    cle_unique integer)
as
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:11:50
   Modifications par André, utilisation CASE, ajout T_IMPORT_GEDCOM
   suppression PATRONYMES, HISTORIQUE
   Dernière modification: 16/11/2007
   Description : Donne une clef unique
   Usage       : on donne en parametre le nom de la table
   -----------------------------------------------------------------*/
cle_unique=case upper(a_table)
           when 'ADRESSES_IND' then gen_id(gen_adresses_ind,1)
           when 'DOSSIER' then gen_id(gen_dossier,1)
           when 'EVENEMENTS_FAM' then gen_id(gen_ev_fam_clef,1)
           when 'EVENEMENTS_IND' then gen_id(gen_ev_ind_clef,1)
           when 'INDIVIDU' then gen_id(gen_individu,1)
           when 'MULTIMEDIA' then gen_id(gen_multimedia,1)
           when 'REF_CP_VILLE' then gen_id(gen_ref_cp_ville,1)
           when 'REF_DEPARTEMENTS' then gen_id(gen_ref_departements,1)
           when 'REF_EVENEMENTS' then gen_id(gen_ref_evenements,1)
           when 'REF_PREFIXES' then gen_id(gen_ref_prefixes,1)
           when 'REF_RELIGIONS' then gen_id(gen_ref_religions,1)
           when 'REF_PARTICULES' then gen_id(gen_ref_particules,1)
           when 'REF_RACCOURCIS' then gen_id(gen_ref_raccourcis,1)
           when 'REF_PAYS' then gen_id(gen_ref_pays,1)
           when 'REF_REGION' then gen_id(gen_ref_region,1)
           when 'T_UNION' then gen_id(gen_t_union,1)
           when 'T_ASSOCIATIONS' then gen_id(gen_assoc_clef,1)
           when 'FAVORIS' then gen_id(gen_favoris,1)
           when 'TOKEN_DATE' then gen_id(gen_token_date,1)
           when 'MEMO_INFOS' then gen_id(gen_memo_infos,1)
           when 'SOURCES_RECORD' then gen_id(sources_record_id_gen,1)
           when 'TQ_ID' then gen_id(gen_tq_id,1)
           when 'MEDIA_POINTEURS' then gen_id(biblio_pointeurs_id_gen,1)
           when 'T_IMPORT_GEDCOM' then gen_id(t_import_gedcom_ig_id_gen,1)
           else -1
  end;
suspend;
end^
commit^

ALTER PROCEDURE PROC_VIDE_BASE (
    i_clef integer)
as
declare variable i integer;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:50:18
   Modifications par André pour respecter l'ordre des dépendances
   lors de la suppression des enregistrements, vidage T_IMPORT_GEDCOM
   remplacement PATRONYMES par NOM_ATTACHEMENT. 01/06/2007
   à : :
   par :
   Description : Vide la base
   Usage       :
   ---------------------------------------------------------------------------*/
      DELETE FROM PRENOMS;
      DELETE FROM ADRESSES_IND;
      DELETE FROM T_ASSOCIATIONS;
      DELETE FROM MEMO_INFOS;
      DELETE FROM MEDIA_POINTEURS;
      DELETE FROM SOURCES_RECORD;
      DELETE FROM evenements_fam;
      DELETE FROM evenements_ind;
      DELETE FROM FAVORIS;
      DELETE FROM T_UNION ;
      DELETE FROM MULTIMEDIA;
      DELETE FROM INDIVIDU;
      DELETE FROM T_IMPORT_GEDCOM;
      DELETE FROM NOM_ATTACHEMENT;
      DELETE FROM TQ_ASCEND_DESCEND;
      DELETE FROM TQ_CONSANG;
      DELETE FROM TQ_ID;
      DELETE FROM TQ_ARBREDESCENDANT ;
      DELETE FROM tq_arbrereduit;
      DELETE FROM tq_ascendance;
      DELETE FROM TQ_ECLAIR;
      DELETE FROM TQ_PRENOMS;
      DELETE FROM TQ_RECH_DOUBLONS;
      DELETE FROM T_DOUBLONS;
      DELETE FROM TQ_TRANSIT;
      DELETE FROM GESTION_DLL;
      DELETE FROM DOSSIER;
      DELETE FROM t_journal;
      i = gen_id(GEN_ADRESSES_IND,     -gen_id(GEN_ADRESSES_IND, 0));
      i = gen_id(GEN_EV_IND_CLEF,      -gen_id(GEN_EV_IND_CLEF, 0));
      i = gen_id(GEN_EV_FAM_CLEF,      -gen_id(GEN_EV_FAM_CLEF, 0));
      i = gen_id(GEN_INDIVIDU,         -gen_id(GEN_INDIVIDU, 0));
      i = gen_id(GEN_MULTIMEDIA,       -gen_id(GEN_MULTIMEDIA, 0));
      i = gen_id(T_IMPORT_GEDCOM_IG_ID_GEN, -gen_id(T_IMPORT_GEDCOM_IG_ID_GEN, 0));
      i = gen_id(NOM_ATTACHEMENT_ID_GEN,-gen_id(NOM_ATTACHEMENT_ID_GEN, 0));
      i = gen_id(GEN_ASSOC_CLEF,       -gen_id(GEN_ASSOC_CLEF, 0));
      i = gen_id(GEN_T_UNION,          -gen_id(GEN_T_UNION, 0));
      i = gen_id(GEN_DOSSIER,          -gen_id(GEN_DOSSIER, 0));
      i = gen_id(GEN_FAVORIS,          -gen_id(GEN_FAVORIS, 0));
      i = gen_id(GEN_TQ_ECLAIR,        -gen_id(GEN_TQ_ECLAIR, 0));
      i = gen_id(GEN_MEMO_INFOS,       -gen_id(GEN_MEMO_INFOS, 0));
      i = gen_id(TQ_TRANSIT_CLEF_GEN,  -gen_id(TQ_TRANSIT_CLEF_GEN, 0));
      i = gen_id(SOURCES_RECORD_ID_GEN, -gen_id(SOURCES_RECORD_ID_GEN, 0));
      i = gen_id(BIBLIO_POINTEURS_ID_GEN, -gen_id(BIBLIO_POINTEURS_ID_GEN, 0));
      execute procedure PROC_VIDE_TABLES_REF(I_CLEF);
end^
commit^

ALTER PROCEDURE PROC_VIDE_DOSSIER (
    i_clef integer)
as
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:50:48
   Modifications par André pour respecter l'ordre des dépendances
   lors de la suppression des enregistrements et suppresion des références au dossier
   pour les tables temporaires, vidage T_IMPORT_GEDCOM, REF_HISTOIRE, remplacement
   PATRONYMES par NOM_ATTACHEMENT 01/06/2007
   à : :
   par :
   Description :
   Usage       :
   ---------------------------------------------------------------------------*/
      DELETE FROM PRENOMS;
      DELETE FROM MEDIA_POINTEURS WHERE MP_KLE_DOSSIER = :I_CLEF;
      DELETE FROM MEMO_INFOS WHERE M_DOSSIER = :I_CLEF;
      DELETE FROM SOURCES_RECORD WHERE KLE_DOSSIER = :I_CLEF;
      DELETE FROM ADRESSES_IND WHERE ADR_KLE_DOSSIER = :I_CLEF;
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
commit^

ALTER TRIGGER t_bd_individu
active before delete position 0
AS
DECLARE VARIABLE parent INTEGER;
begin
/*créé par André le 23/08/2007 pour assurer l'intégrité des données*/
  delete from favoris where kle_fiche=old.cle_fiche;
  delete from t_associations where (assoc_kle_ind=old.cle_fiche and assoc_table='I')
                                   or assoc_kle_associe=old.cle_fiche;
  delete from media_pointeurs where mp_cle_individu=old.cle_fiche;
  delete from adresses_ind where adr_kle_ind=old.cle_fiche;
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
end^
commit^

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

alter PROCEDURE PROC_ETAT_ANNIV_ORDER (
    A_MOIS INTEGER,
    I_DOSSIER INTEGER,
    GET_BIRT INTEGER,
    GET_DEAT INTEGER,
    GET_MARR INTEGER)
RETURNS (
    NOM VARCHAR(100),
    PRENOM VARCHAR(100),
    ADATE VARCHAR(100),
    ANNEE INTEGER,
    EV_TYPE VARCHAR(7),
    SEXE INTEGER)
AS
DECLARE VARIABLE CLEF INTEGER;
DECLARE VARIABLE DATE_MIN DATE;
DECLARE VARIABLE AN_MIN INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:05:19
   Refonte complète par André le 25/11/2007: correction erreur ordre sur
   date writen. Suppression requêtes intermédiaires.
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
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
        order by n.ev_ind_date_year,n.ev_ind_date nulls last
        into :nom
            ,:prenom
            ,:adate
            ,:annee
            ,:ev_type
            ,:sexe
    do
      suspend;
  if (get_marr=1) then
    for select t.union_clef
              ,m.nom || ' ' || m.prenom
              ,f.nom || ' ' || f.prenom
              ,'MARR'
              ,1
              ,min(e.ev_fam_date_year)
              ,min(e.ev_fam_date)
        from evenements_fam e
        inner join t_union t on t.union_clef=e.ev_fam_kle_famille
        inner join individu m on m.cle_fiche=t.union_mari
        inner join individu f on f.cle_fiche=t.union_femme
        where e.ev_fam_date_mois=:a_mois
          and e.ev_fam_type='MARR'
          and m.kle_dossier=:i_dossier
        group by 1,2,3,4,5
        order by 6,7 nulls last
        into :clef
            ,:nom
            ,:prenom
            ,:ev_type
            ,:sexe
            ,:an_min
            ,:date_min
    do
    begin
      adate=null;
      annee=null;
      select first (1)
             ev_fam_date_writen
            ,ev_fam_date_year
      from evenements_fam
      where ev_fam_kle_famille=:clef
        and ev_fam_date_mois=:a_mois
        and ev_fam_type='MARR'
      order by ev_fam_date_year,ev_fam_date nulls last
      into :adate
          ,:annee;
      suspend;
    end
  if (get_deat=1) then
    for select i.cle_fiche
              ,i.nom
              ,i.prenom
              ,'DEAT'
              ,i.sexe
              ,min(d.ev_ind_date_year)
              ,min(d.ev_ind_date)
        from evenements_ind d
        inner join individu i on i.cle_fiche=d.ev_ind_kle_fiche
        where d.ev_ind_date_mois=:a_mois
          and d.ev_ind_type in ('DEAT','BURI','CREM')
          and i.kle_dossier=:i_dossier
        group by 1,2,3,4,5
        order by 6,7 nulls last
        into :clef
            ,:nom
            ,:prenom
            ,:ev_type
            ,:sexe
            ,:an_min
            ,:date_min
    do
    begin
      adate=null;
      annee=null;
      select first (1)
             ev_ind_date_writen
            ,ev_ind_date_year
      from evenements_ind
      where ev_ind_kle_fiche=:clef
        and ev_ind_date_mois=:a_mois
        and ev_ind_type in ('DEAT','BURI','CREM')
      order by ev_ind_date_year,ev_ind_date nulls last
      into :adate
          ,:annee;
      suspend;
    end
end^
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
      DELETE FROM ref_evenements;
      DELETE FROM ref_filiation;
      DELETE FROM ref_particules;
      DELETE FROM ref_prefixes;
      DELETE FROM ref_raccourcis;
      DELETE FROM ref_rela_temoins;
      DELETE FROM ref_religion;
      DELETE FROM ref_token_date;
      DELETE FROM ref_type_union;
      DELETE FROM ref_histoire;
      i = gen_id(GEN_REF_PAYS,         -gen_id(GEN_REF_PAYS, 0));
      i = gen_id(GEN_REF_REGION,       -gen_id(GEN_REF_REGION, 0));
      i = gen_id(GEN_REF_DEPARTEMENTS, -gen_id(GEN_REF_DEPARTEMENTS, 0));
      i = gen_id(GEN_REF_CP_VILLE,     -gen_id(GEN_REF_CP_VILLE, 0));
      i = gen_id(gen_ref_evenements, -gen_id(gen_ref_evenements, 0));
      i = gen_id(gen_ref_particules, -gen_id(gen_ref_particules, 0));
      i = gen_id(GEN_REF_prefixes,   -gen_id(GEN_REF_prefixes, 0));
      i = gen_id(gen_ref_raccourcis, -gen_id(gen_ref_raccourcis, 0));
      i = gen_id(gen_ref_rela_clef,  -gen_id(gen_ref_rela_clef, 0));
      i = gen_id(gen_ref_religions,  -gen_id(gen_ref_religions, 0));
      i = gen_id(gen_token_date,     -gen_id(gen_token_date, 0));
      i = gen_id(gen_reli_clef,      -gen_id(gen_reli_clef, 0));
      i = gen_id(gen_ref_tu_clef,    -gen_id(gen_ref_tu_clef, 0));
      i = gen_id(gen_ref_histoire,    -gen_id(gen_ref_histoire, 0));
  end
end^
commit^

alter PROCEDURE PROC_INSERT_LANGUE (
    A_TABLE VARCHAR(30),
    A_LANGUE_ORIGINE VARCHAR(3),
    A_LANGUE_DEST VARCHAR(3))
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
commit^

CREATE or alter  PROCEDURE PROC_SELECT_REF (
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


SET ECHO ON^
/*Les instructions suivantes peuvent provoquer des erreurs.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
DROP GENERATOR GEN_REF_RECHERCHE^
commit^
DROP TABLE REF_RECHERCHE^
commit^

DROP PROCEDURE PROC_ETAT_ANNIV^
commit^
DROP PROCEDURE PROC_ANNIV_BIRT^
commit^
DROP PROCEDURE PROC_ANNIV_DEAT_INHU^
commit^
DROP PROCEDURE PROC_ANNIV_MARIAGE^
commit^

DROP PROCEDURE PROC_VIDE_HISTORIQUE^
commit^
DROP PROCEDURE PROC_HISTORIQUE^
commit^
DROP GENERATOR GEN_HISTORIQUE^
commit^
DROP TABLE HISTORIQUE^
commit^

CREATE PROCEDURE F_POS (
    STR_A_CHERCHER VARCHAR(255),
    STR_OU_TROUVER VARCHAR(255))
RETURNS (
    POS INTEGER)
AS
begin
  suspend;
end^
commit^

CREATE PROCEDURE F_REMPLACE (
    STR_A_TROUVER VARCHAR(255),
    STR_QUI_REMPLACE VARCHAR(255),
    STR_OU_TROUVER VARCHAR(255),
    CASSE_INDIF INTEGER)
RETURNS (
    REMPLACE VARCHAR(255))
AS
begin
  suspend;
end^
commit^

DROP PROCEDURE PROC_ASCENDANCE^
commit^

ALTER TABLE TQ_ARBREREDUIT DROP TQ_OCCUPATION^
commit^
ALTER TABLE TQ_ARBREREDUIT
ADD TQ_DESCENDANT INTEGER^
commit^
CREATE INDEX TQ_ARBREREDUIT_DESCENDANT
ON TQ_ARBREREDUIT (TQ_DESCENDANT)^
commit^

ALTER TABLE TQ_ARBREDESCENDANT
ADD TQ_ASCENDANT INTEGER^
commit^

CREATE INDEX TQ_ARBREDESCENDANT_ASCENDANT
ON TQ_ARBREDESCENDANT (TQ_ASCENDANT)^
commit^

CREATE PROCEDURE PROC_SOSAS (
    I_CLEF INTEGER)
RETURNS (
    SOSAS VARCHAR(100))
AS
begin suspend; end^
commit^

DROP TABLE T_INVERSE_INSEE_CP^
commit^

DROP PROCEDURE PROC_CONJOINTS_ENFANTS^
commit^

DROP PROCEDURE PROC_ETAT_TOUTES_FICHES^
commit^

DROP PROCEDURE PROC_ETAT_TOUTES_FICHES_FAMILLE^
commit^

CREATE TABLE TA_GROUPES (
    TA_NIVEAU     INTEGER,
    TA_CLE_FICHE  INTEGER,
    TA_GROUPE     INTEGER,
    TA_SEXE       INTEGER)^
CREATE INDEX TA_GROUPES_IDX1 ON TA_GROUPES (TA_NIVEAU)^
CREATE INDEX TA_GROUPES_IDX2 ON TA_GROUPES (TA_CLE_FICHE)^
CREATE INDEX TA_GROUPES_IDX3 ON TA_GROUPES (TA_GROUPE)^
CREATE INDEX TA_GROUPES_IDX4 ON TA_GROUPES (TA_SEXE)^
commit^

DROP PROCEDURE PROC_LISTE_INDIVIDU_ALPHA^
commit^

CREATE INDEX TQ_ID_IDX_ID2 ON TQ_ID (ID2)^
commit^

DROP PROCEDURE PROC_AGE_EVENT^
commit^

DROP PROCEDURE PROC_LISTE_INDIVIDU^
commit^

DROP PROCEDURE PROC_TROUVE_CHAINE_INDI^
commit^

DROP TABLE REF_ASSOCIATIONS^
commit^

DROP GENERATOR GEN_REF_ASSOC_CLEF^
commit^

DROP TRIGGER EVENEMENTS_FAM_AU^
commit^

ALTER TABLE TQ_ID DROP CONSTRAINT PK_TQ_ID^
commit^

CREATE INDEX TQ_ID_IDX_ID1
ON TQ_ID (ID1)^
commit^

DROP PROCEDURE PROC_TROUVE_PATRONYMES^
commit^

DROP PROCEDURE PROC_GENEANET^
commit^

update RDB$RELATION_FIELDS set
RDB$NULL_FLAG = NULL
where (RDB$FIELD_NAME = 'MULTI_INDIVIDU') and
(RDB$RELATION_NAME = 'MULTIMEDIA')^
commit^

DROP PROCEDURE PROC_GET_VERSION_DATABASE^
commit^

DROP PROCEDURE PROC_DATE_CONTROLE^
commit^

CREATE TABLE TRACES (
    MOMENT         TIMESTAMP DEFAULT current_timestamp,
    NOM_TABLE      VARCHAR(25),
    ENR_TABLE      INTEGER,
    TEXTE_MESSAGE  VARCHAR(255)
)^
commit^

/*Fin des instructions pouvant provoquer des erreurs normales
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
SET ECHO OFF^

alter PROCEDURE F_POS (
    STR_A_CHERCHER VARCHAR(255),
    STR_OU_TROUVER VARCHAR(255))
RETURNS (
    POS INTEGER)
AS
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE LGA INTEGER;
DECLARE VARIABLE LGS INTEGER;
begin
/*créée par André le 04/09/07 pour faciliter les modifications
de chaînes de caractères*/
  lga=char_length(str_a_chercher);
  lgs=char_length(str_ou_trouver)-lga+1;
  pos=0;
  i=1;
  while (i<=lgs) do
  begin
    if (substring(str_ou_trouver from i for lga)=str_a_chercher) then
    begin
      pos=i;
      suspend;
      exit;
    end
    else
      i=i+1;
  end
  suspend;
end^
commit^

alter PROCEDURE F_REMPLACE (
    STR_A_TROUVER VARCHAR(255),
    STR_QUI_REMPLACE VARCHAR(255),
    STR_OU_TROUVER VARCHAR(255),
    CASSE_INDIF INTEGER)
RETURNS (
    REMPLACE VARCHAR(255))
AS
DECLARE VARIABLE POS INTEGER;
DECLARE VARIABLE LGA INTEGER;
DECLARE VARIABLE LGQ INTEGER;
DECLARE VARIABLE POS_S INTEGER;
begin
/*créée par André le 04/09/07 pour remplacer toutes les occurrences de
STR_A_TROUVER par STR_QUI_REMPLACE dans la chaîne STR_OU_TROUVER.
Si CASSE_INDIF=1 le remplacement est exécuté même si la casse dans STR_OU_TROUVER
est différente.*/
  remplace=str_ou_trouver;
  lga=char_length(str_a_trouver);
  lgq=char_length(str_qui_remplace);
  pos_s=1;
  pos=1;
  while (pos>0) do
  begin
    if (casse_indif=1) then
      select pos from f_pos(upper(:str_a_trouver),upper(substring(:remplace from :pos_s)))
      into :pos;
    else
      select pos from f_pos(:str_a_trouver,substring(:remplace from :pos_s))
      into :pos;
    pos_s=pos_s+pos-1;
    if (pos>0 and (char_length(remplace)-lga+lgq)<256) then
      if (pos_s=1) then
        remplace=str_qui_remplace||substring(remplace from 1+lga);
      else
        remplace=substring(remplace from 1 for pos_s-1)||str_qui_remplace||
                 substring(remplace from pos_s+lga);
  end
  suspend;
end^
commit^

alter PROCEDURE PROC_DATES_INCOHERENTES (
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
    SEXE INTEGER,
    AGE DECIMAL(15,1),
    TITRE SMALLINT)
AS
DECLARE VARIABLE DATE_NAIS DATE;
DECLARE VARIABLE MOIS_NAIS INTEGER;
DECLARE VARIABLE AN_NAIS INTEGER;
DECLARE VARIABLE DATE_EVE DATE;
DECLARE VARIABLE MOIS_EVE INTEGER;
DECLARE VARIABLE AN_EVE INTEGER;
DECLARE VARIABLE EPOUSE VARCHAR(121);
DECLARE VARIABLE AGETEMPO DECIMAL(15,1);
DECLARE VARIABLE DATE_DC DATE;
DECLARE VARIABLE DATE_INH DATE;
DECLARE VARIABLE DATE_EVF DATE;
DECLARE VARIABLE LIBELLE_PREC VARCHAR(121);
DECLARE VARIABLE CLEF INTEGER;
DECLARE VARIABLE CLEF_PREC INTEGER;
DECLARE VARIABLE AGE_PREC INTEGER;
DECLARE VARIABLE DATE_CR DATE;
DECLARE VARIABLE NBR INTEGER;
begin
/*Procédure créée par André. Dernière modification 26/10/2007*/
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
            ,coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'1')
                                         ||'/1/'||ni.ev_ind_date_year as date))
            ,coalesce(m.ev_fam_date,cast(coalesce(m.ev_fam_date_mois,'12')
                                         ||'/28/'||m.ev_fam_date_year as date))
          from evenements_fam m
            inner join t_union u on u.union_clef=m.ev_fam_kle_famille
            inner join individu i on i.cle_fiche=u.union_mari
            inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                         and ni.ev_ind_type='BIRT'
        where m.ev_fam_type='MARR'
          and m.ev_fam_date_year>0
          and i.kle_dossier=:i_dossier
          and i.annee_naissance>0
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_evf
    do
      if (date_evf<date_nais+min_mar_hom*365.25) then
      begin
        age=(date_evf-date_nais)/365.25;
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
            ,coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'1')
                                         ||'/1/'||ni.ev_ind_date_year as date))
            ,coalesce(m.ev_fam_date,cast(coalesce(m.ev_fam_date_mois,'12')
                                         ||'/28/'||m.ev_fam_date_year as date))
          from evenements_fam m
            inner join t_union u on u.union_clef=m.ev_fam_kle_famille
            inner join individu i on i.cle_fiche=u.union_femme
            inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                         and ni.ev_ind_type='BIRT'
        where m.ev_fam_type='MARR'
          and m.ev_fam_date_year>0
          and i.kle_dossier=:i_dossier
          and i.annee_naissance>0
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_evf
    do
      if (date_evf<date_nais+min_mar_fem*365.25) then
      begin
        age=(date_evf-date_nais)/365.25;
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
            ,coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'12')
                                         ||'/28/'||ni.ev_ind_date_year as date))
            ,coalesce(m.ev_fam_date,cast(coalesce(m.ev_fam_date_mois,'1')
                                         ||'/1/'||m.ev_fam_date_year as date))
          from evenements_fam m
            inner join t_union u on u.union_clef=m.ev_fam_kle_famille
            inner join individu i on i.cle_fiche=u.union_mari
            inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                         and ni.ev_ind_type='BIRT'
        where m.ev_fam_type='MARR'
          and m.ev_fam_date_year>0
          and i.kle_dossier=:i_dossier
          and i.annee_naissance>0
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_evf
    do
      if (date_evf>date_nais+max_mar_hom*365.25) then
      begin
        age=(date_evf-date_nais)/365.25;
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
            ,coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'12')
                                         ||'/28/'||ni.ev_ind_date_year as date))
            ,coalesce(m.ev_fam_date,cast(coalesce(m.ev_fam_date_mois,'1')
                                         ||'/1/'||m.ev_fam_date_year as date))
          from evenements_fam m
            inner join t_union u on u.union_clef=m.ev_fam_kle_famille
            inner join individu i on i.cle_fiche=u.union_femme
            inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                         and ni.ev_ind_type='BIRT'
        where m.ev_fam_type='MARR'
          and m.ev_fam_date_year>0
          and i.kle_dossier=:i_dossier
          and i.annee_naissance>0
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_evf
    do
      if (date_evf>date_nais+max_mar_fem*365.25) then
      begin
        age=(date_evf-date_nais)/365.25;
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
              ,ni.ev_ind_date_year
              ,ni.ev_ind_date_mois
              ,ni.ev_ind_date
              ,ne.ev_ind_date_year
              ,ne.ev_ind_date_mois
              ,ne.ev_ind_date
        from individu i
             inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                         and ni.ev_ind_type='BIRT'
             inner join individu e on e.cle_pere=i.cle_fiche
             inner join evenements_ind ne on ne.ev_ind_kle_fiche=e.cle_fiche
                                         and ne.ev_ind_type='BIRT'
        where i.kle_dossier=:i_dossier
          and i.sexe=1
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:an_nais
            ,:mois_nais
            ,:date_nais
            ,:an_eve
            ,:mois_eve
            ,:date_eve
    do
    begin
      if (an_nais>0 and an_eve>0) then
      begin
        if (date_nais is null) then
          date_nais=cast(coalesce(mois_nais,'1')||'/1/'||an_nais as date);
        if (date_eve is null) then
          date_eve=cast(coalesce(mois_eve,'12')||'/28/'||an_eve as date);
        age=(date_eve-date_nais)/365.25;
      end
      else
        age=null;
      if (age is not null and age<min_enf_hom) then
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
              ,ni.ev_ind_date_year
              ,ni.ev_ind_date_mois
              ,ni.ev_ind_date
              ,ne.ev_ind_date_year
              ,ne.ev_ind_date_mois
              ,ne.ev_ind_date
        from individu i
             inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                         and ni.ev_ind_type='BIRT'
             inner join individu e on e.cle_mere=i.cle_fiche
             inner join evenements_ind ne on ne.ev_ind_kle_fiche=e.cle_fiche
                                         and ne.ev_ind_type='BIRT'
        where i.kle_dossier=:i_dossier
          and i.sexe=2
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:an_nais
            ,:mois_nais
            ,:date_nais
            ,:an_eve
            ,:mois_eve
            ,:date_eve
    do
    begin
      if (an_nais>0 and an_eve>0) then
      begin
        if (date_nais is null) then
          date_nais=cast(coalesce(mois_nais,'1')||'/1/'||an_nais as date);
        if (date_eve is null) then
          date_eve=cast(coalesce(mois_eve,'12')||'/28/'||an_eve as date);
        age=(date_eve-date_nais)/365.25;
      end
      else
        age=null;
      if (age is not null and age<min_enf_fem) then
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
              ,ni.ev_ind_date_year
              ,ni.ev_ind_date_mois
              ,ni.ev_ind_date
              ,ne.ev_ind_date_year
              ,ne.ev_ind_date_mois
              ,ne.ev_ind_date
        from individu i
             inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                         and ni.ev_ind_type='BIRT'
             inner join individu e on e.cle_pere=i.cle_fiche
             inner join evenements_ind ne on ne.ev_ind_kle_fiche=e.cle_fiche
                                         and ne.ev_ind_type='BIRT'
        where i.kle_dossier=:i_dossier
          and i.sexe=1
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:an_nais
            ,:mois_nais
            ,:date_nais
            ,:an_eve
            ,:mois_eve
            ,:date_eve
    do
    begin
      if (an_nais>0 and an_eve>0) then
      begin
        if (date_nais is null) then
          date_nais=cast(coalesce(mois_nais,'12')||'/28/'||an_nais as date);
        if (date_eve is null) then
          date_eve=cast(coalesce(mois_eve,'1')||'/1/'||an_eve as date);
        age=(date_eve-date_nais)/365.25;
      end
      else
        age=null;
      if (age is not null and age>max_enf_hom) then
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
              ,ni.ev_ind_date_year
              ,ni.ev_ind_date_mois
              ,ni.ev_ind_date
              ,ne.ev_ind_date_year
              ,ne.ev_ind_date_mois
              ,ne.ev_ind_date
        from individu i
             inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                         and ni.ev_ind_type='BIRT'
             inner join individu e on e.cle_mere=i.cle_fiche
             inner join evenements_ind ne on ne.ev_ind_kle_fiche=e.cle_fiche
                                         and ne.ev_ind_type='BIRT'
        where i.kle_dossier=:i_dossier
          and i.sexe=2
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:an_nais
            ,:mois_nais
            ,:date_nais
            ,:an_eve
            ,:mois_eve
            ,:date_eve
    do
    begin
      if (an_nais>0 and an_eve>0) then
      begin
        if (date_nais is null) then
          date_nais=cast(coalesce(mois_nais,'12')||'/28/'||an_nais as date);
        if (date_eve is null) then
          date_eve=cast(coalesce(mois_eve,'1')||'/1/'||an_eve as date);
        age=(date_eve-date_nais)/365.25;
      end
      else
        age=null;
      if (age is not null and age>max_enf_fem) then
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
            ,coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'12')
                                         ||'/28/'||ni.ev_ind_date_year as date))
            ,coalesce(nd.ev_ind_date,cast(coalesce(nd.ev_ind_date_mois,'1')
                                         ||'/1/'||nd.ev_ind_date_year as date))
            ,coalesce(nb.ev_ind_date,cast(coalesce(nb.ev_ind_date_mois,'1')
                                         ||'/1/'||nb.ev_ind_date_year as date))
        from individu i
         inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                         and ni.ev_ind_type='BIRT'
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_fiche
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_date_year>0
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_fiche
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_date_year>0
        where i.kle_dossier=:i_dossier
          and i.sexe=1
          and i.annee_naissance>0
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_dc
            ,:date_inh
    do
    begin
      if (date_dc is null)  then
        date_dc=date_inh;
      if (date_dc>date_nais+max_vie_hom*365.25) then
        begin
          age=(date_dc-date_nais)/365.25;
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
            ,coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'12')
                                         ||'/28/'||ni.ev_ind_date_year as date))
            ,coalesce(nd.ev_ind_date,cast(coalesce(nd.ev_ind_date_mois,'1')
                                         ||'/1/'||nd.ev_ind_date_year as date))
            ,coalesce(nb.ev_ind_date,cast(coalesce(nb.ev_ind_date_mois,'1')
                                         ||'/1/'||nb.ev_ind_date_year as date))
        from individu i
         inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                         and ni.ev_ind_type='BIRT'
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_fiche
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_date_year>0
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_fiche
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_date_year>0
        where i.kle_dossier=:i_dossier
          and i.sexe=2
          and i.annee_naissance>0
        order by 1,i.annee_naissance,i.cle_fiche
        into :libelle
            ,:clef_ind
            ,:date_nais
            ,:date_dc
            ,:date_inh
    do
    begin
      if (date_dc is null)  then
        date_dc=date_inh;
      if (date_dc>date_nais+max_vie_fem*365.25) then
        begin
          age=(date_dc-date_nais)/365.25;
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
              ,abs(coalesce(nm.ev_ind_date,cast(coalesce(nm.ev_ind_date_mois,'1')
                                                ||'/1/'||nm.ev_ind_date_year as date))
                   -coalesce(nf.ev_ind_date,cast(coalesce(nf.ev_ind_date_mois,'12')
                                                          ||'/28/'||nf.ev_ind_date_year as date)))
              ,abs(coalesce(nm.ev_ind_date,cast(coalesce(nm.ev_ind_date_mois,'12')
                                                ||'/28/'||nm.ev_ind_date_year as date))
                   -coalesce(nf.ev_ind_date,cast(coalesce(nf.ev_ind_date_mois,'1')
                                                          ||'/1/'||nf.ev_ind_date_year as date)))
        from evenements_fam e
             inner join t_union u on u.union_clef=e.ev_fam_kle_famille
             inner join individu m on m.cle_fiche=u.union_mari
             inner join evenements_ind nm on nm.ev_ind_kle_fiche=m.cle_fiche
                                         and nm.ev_ind_type='BIRT'
                                         and nm.ev_ind_date_year>0
             inner join individu f on f.cle_fiche =u.union_femme
             inner join evenements_ind nf on nf.ev_ind_kle_fiche=f.cle_fiche
                                         and nf.ev_ind_type='BIRT'
                                         and nf.ev_ind_date_year>0
        where m.kle_dossier=:i_dossier
          and e.ev_fam_type='MARR'
        order by 1,m.annee_naissance,m.cle_fiche
        into :libelle
            ,:epouse
            ,:clef_ind
            ,:clef
            ,:age
            ,:agetempo
    do
    begin
      if (agetempo>age) then
        agetempo=age;
      if (agetempo is not null and agetempo/365.25>max_ecart_epoux) then
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
              ,abs(coalesce(n2.ev_ind_date,cast(coalesce(n2.ev_ind_date_mois,'1')
                                                ||'/1/'||n2.ev_ind_date_year as date))
                   -coalesce(n1.ev_ind_date,cast(coalesce(n1.ev_ind_date_mois,'12')
                                                          ||'/28/'||n1.ev_ind_date_year as date)))
              ,abs(coalesce(n2.ev_ind_date,cast(coalesce(n2.ev_ind_date_mois,'12')
                                                ||'/28/'||n2.ev_ind_date_year as date))
                   -coalesce(n1.ev_ind_date,cast(coalesce(n1.ev_ind_date_mois,'1')
                                                          ||'/1/'||n1.ev_ind_date_year as date)))
        from individu m
             inner join individu e1 on e1.cle_mere=m.cle_fiche
             inner join evenements_ind n1 on n1.ev_ind_kle_fiche=e1.cle_fiche
                                         and n1.ev_ind_type='BIRT'
                                         and n1.ev_ind_date_year>0
             inner join individu e2 on e2.cle_mere=m.cle_fiche
             inner join evenements_ind n2 on n2.ev_ind_kle_fiche=e2.cle_fiche
                                         and n2.ev_ind_type='BIRT'
                                         and n2.ev_ind_date_year>0
        where m.kle_dossier=:i_dossier
          and e1.cle_fiche<>e2.cle_fiche
          and not (n1.ev_ind_date_year=n2.ev_ind_date_year
                   and n1.ev_ind_date_mois=n2.ev_ind_date_mois
                   and n1.ev_ind_date=n2.ev_ind_date)
        order by 1,m.annee_naissance,m.cle_fiche
        into :libelle
            ,:clef_ind
            ,:age
            ,:agetempo
    do
    begin
      if (agetempo>age) then
        age=agetempo;
      if (age<min_entre_enf and age>2) then
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
  if (max_enf_fem>0 and min_enf_fem>0) then
  begin
    libelle='Femme(s) ayant eu des enfants pendant plus de '|| (max_enf_fem-min_enf_fem) ||' ans: (écart en années)';
    titre=1;
    nbr=0;
    suspend;
    titre=null;
    sexe=2;
    for select distinct m.nom||coalesce(', '||m.prenom,'')||coalesce(' née en '||m.annee_naissance,'')
              ,m.cle_fiche
              ,((select max(coalesce(n.ev_ind_date,cast(coalesce(n.ev_ind_date_mois,'1')
                                                ||'/1/'||n.ev_ind_date_year as date)))
                from individu e
                inner join evenements_ind n on n.ev_ind_kle_fiche=e.cle_fiche
                                         and n.ev_ind_type='BIRT'
                where e.cle_mere=m.cle_fiche
                  and e.annee_naissance>0)
              -(select min(coalesce(n.ev_ind_date,cast(coalesce(n.ev_ind_date_mois,'12')
                                                ||'/28/'||n.ev_ind_date_year as date)))
                from individu e
                inner join evenements_ind n on n.ev_ind_kle_fiche=e.cle_fiche
                                         and n.ev_ind_type='BIRT'
                where e.cle_mere=m.cle_fiche
                  and e.annee_naissance>0))/365.25
        from individu m
        where m.kle_dossier=:i_dossier
        order by 1,m.annee_naissance,m.cle_fiche
        into :libelle
            ,:clef_ind
            ,:age
    do
    begin
      if (age>(max_enf_fem-min_enf_fem)) then
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
  libelle_prec='';
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||case when i.sexe=2 then 'e' else '' end||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
            ,coalesce(np.ev_ind_date,cast(coalesce(np.ev_ind_date_mois,'12')
                                         ||'/28/'||np.ev_ind_date_year as date))
             +:max_vie_hom*365.25
            ,coalesce(nd.ev_ind_date,cast(coalesce(nd.ev_ind_date_mois,'12')
                                         ||'/28/'||nd.ev_ind_date_year as date))
            ,coalesce(nb.ev_ind_date,cast(coalesce(nb.ev_ind_date_mois,'12')
                                         ||'/28/'||nb.ev_ind_date_year as date))
            ,coalesce(nc.ev_ind_date,cast(coalesce(nc.ev_ind_date_mois,'12')
                                         ||'/28/'||nc.ev_ind_date_year as date))
            ,coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'1')
                                         ||'/1/'||ni.ev_ind_date_year as date))
      from individu i
         inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                     and ni.ev_ind_type='BIRT'
         left join evenements_ind np on np.ev_ind_kle_fiche=i.cle_pere
                                     and np.ev_ind_type='BIRT'
                                     and np.ev_ind_date_year>0
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_pere
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_date_year>0
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_pere
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_date_year>0
         left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_pere
                                     and nc.ev_ind_type='CREM'
                                     and nc.ev_ind_date_year>0
      where i.kle_dossier=:i_dossier
        and i.annee_naissance>0
      order by 1,i.annee_naissance,i.cle_fiche
      into :libelle
          ,:clef_ind
          ,:sexe
          ,:date_nais
          ,:date_dc
          ,:date_inh
          ,:date_cr
          ,:date_eve
  do
  begin
    if (not ((date_nais is null or max_vie_hom<1) and date_dc is null and date_inh is null and date_cr is null)) then
    begin
      if (date_dc is null and date_inh is null and date_cr is null and max_vie_hom>0) then
          date_dc=date_nais;
      else
        if (date_dc is null)  then
          if (date_cr is null or date_cr>date_inh) then
            date_dc=date_inh;
          else
            date_dc=date_cr;
      if (date_dc+270<date_eve) then
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
  libelle_prec='';
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||case when i.sexe=2 then 'e' else '' end||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
            ,coalesce(np.ev_ind_date,cast(coalesce(np.ev_ind_date_mois,'12')
                                         ||'/28/'||np.ev_ind_date_year as date))
             +:max_vie_fem*365.25
            ,coalesce(nd.ev_ind_date,cast(coalesce(nd.ev_ind_date_mois,'12')
                                         ||'/28/'||nd.ev_ind_date_year as date))
            ,coalesce(nb.ev_ind_date,cast(coalesce(nb.ev_ind_date_mois,'12')
                                         ||'/28/'||nb.ev_ind_date_year as date))
            ,coalesce(nc.ev_ind_date,cast(coalesce(nc.ev_ind_date_mois,'12')
                                         ||'/28/'||nc.ev_ind_date_year as date))
            ,coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'1')
                                         ||'/1/'||ni.ev_ind_date_year as date))
      from individu i
         inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                     and ni.ev_ind_type='BIRT'
         left join evenements_ind np on np.ev_ind_kle_fiche=i.cle_mere
                                     and np.ev_ind_type='BIRT'
                                     and np.ev_ind_date_year>0
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_mere
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_date_year>0
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_mere
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_date_year>0
         left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_mere
                                     and nc.ev_ind_type='CREM'
                                     and nc.ev_ind_date_year>0
      where i.kle_dossier=:i_dossier
        and i.annee_naissance>0
      order by 1,i.annee_naissance,i.cle_fiche
      into :libelle
          ,:clef_ind
          ,:sexe
          ,:date_nais
          ,:date_dc
          ,:date_inh
          ,:date_cr
          ,:date_eve
  do
  begin
    if (not ((date_nais is null or max_vie_fem<1) and date_dc is null and date_inh is null)) then
    begin
        if (date_dc is null and date_inh is null and max_vie_fem>0) then
          date_dc=date_nais;
        else
          if (date_dc is null)  then
            if (date_cr is null or date_cr>date_inh) then
              date_dc=date_inh;
            else
              date_dc=date_cr;
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
  libelle='Individu(s) ayant un événement avant la naissance:';
  titre=1;
  nbr=0;
  suspend;
  titre=null;
  for select distinct i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||case when i.sexe=2 then 'e' else '' end||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
      from individu i
         inner join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                     and ni.ev_ind_type='BIRT'
         left join evenements_ind ne on ne.ev_ind_kle_fiche=i.cle_fiche
                                     and ne.ev_ind_type<>'BIRT'
                                     and ne.ev_ind_date_year>0
         left join t_union u on (i.sexe=1 and u.union_mari=i.cle_fiche)
                             or (i.sexe=2 and u.union_femme=i.cle_fiche)
         left join evenements_fam f on f.ev_fam_kle_famille=u.union_clef
                                   and f.ev_fam_date_year>0
      where i.kle_dossier=:i_dossier
        and i.annee_naissance>0
        and (coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'1')
                                         ||'/1/'||ni.ev_ind_date_year as date))
             >coalesce(ne.ev_ind_date,cast(coalesce(ne.ev_ind_date_mois,'12')
                                         ||'/28/'||ne.ev_ind_date_year as date))
         or coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'1')
                                         ||'/1/'||ni.ev_ind_date_year as date))
             >coalesce(f.ev_fam_date,cast(coalesce(f.ev_fam_date_mois,'12')
                                         ||'/28/'||f.ev_fam_date_year as date)))
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
  libelle='Individu(s) ayant un événement après le décès, l''inhumation, la crémation ou l''espérance de vie:';
  titre=1;
  suspend;
  nbr=0;
  titre=null;
  clef=0;
  sexe=0;
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||case when i.sexe=2 then 'e' else '' end||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
            ,coalesce(ni.ev_ind_date,cast(coalesce(ni.ev_ind_date_mois,'12')
                                         ||'/28/'||ni.ev_ind_date_year as date))
             +case when i.sexe=1 then :max_vie_hom else :max_vie_fem end*365.25
            ,coalesce(nb.ev_ind_date,cast(coalesce(nb.ev_ind_date_mois,'12')
                                         ||'/28/'||nb.ev_ind_date_year as date))
            -coalesce(nd.ev_ind_date,cast(coalesce(nd.ev_ind_date_mois,'1')
                                         ||'/1/'||nd.ev_ind_date_year as date))
            ,coalesce(nc.ev_ind_date,cast(coalesce(nc.ev_ind_date_mois,'12')
                                         ||'/28/'||nc.ev_ind_date_year as date))
            -coalesce(nd.ev_ind_date,cast(coalesce(nd.ev_ind_date_mois,'1')
                                         ||'/1/'||nd.ev_ind_date_year as date))
            ,coalesce(nd.ev_ind_date,cast(coalesce(nd.ev_ind_date_mois,'12')
                                         ||'/28/'||nd.ev_ind_date_year as date))
            ,coalesce(nb.ev_ind_date,cast(coalesce(nb.ev_ind_date_mois,'12')
                                         ||'/28/'||nb.ev_ind_date_year as date))
            ,coalesce(nc.ev_ind_date,cast(coalesce(nc.ev_ind_date_mois,'12')
                                         ||'/28/'||nc.ev_ind_date_year as date))
            ,coalesce(ne.ev_ind_date,cast(coalesce(ne.ev_ind_date_mois,'1')
                                         ||'/1/'||ne.ev_ind_date_year as date))
            ,coalesce(f.ev_fam_date,cast(coalesce(f.ev_fam_date_mois,'1')
                                         ||'/1/'||f.ev_fam_date_year as date))
      from individu i
         left join evenements_ind ni on ni.ev_ind_kle_fiche=i.cle_fiche
                                     and ni.ev_ind_type='BIRT'
                                     and ni.ev_ind_date_year>0
         left join evenements_ind nd on nd.ev_ind_kle_fiche=i.cle_fiche
                                     and nd.ev_ind_type='DEAT'
                                     and nd.ev_ind_date_year>0
         left join evenements_ind nb on nb.ev_ind_kle_fiche=i.cle_fiche
                                     and nb.ev_ind_type='BURI'
                                     and nb.ev_ind_date_year>0
         left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_fiche
                                     and nc.ev_ind_type='CREM'
                                     and nc.ev_ind_date_year>0
         left join evenements_ind ne on ne.ev_ind_kle_fiche=i.cle_fiche
                                     and ne.ev_ind_type not in('DEAT','BURI','CREM')
                                     and ne.ev_ind_date_year>0
         left join t_union u on (i.sexe=1 and u.union_mari=i.cle_fiche)
                             or (i.sexe=2 and u.union_femme=i.cle_fiche)
         left join evenements_fam f on f.ev_fam_kle_famille=u.union_clef
                                   and f.ev_fam_date_year>0
      where i.kle_dossier=:i_dossier
      order by 1,i.annee_naissance,i.cle_fiche
      into :libelle
          ,:clef_prec
          ,:sexe
          ,:date_nais
          ,:age_prec
          ,:agetempo
          ,:date_dc
          ,:date_inh
          ,:date_cr
          ,:date_eve
          ,:date_evf
  do
  begin
    if (clef<>clef_prec
       and not ((date_nais is null or max_vie_hom=0 or max_vie_fem=0)
                and date_dc is null and date_inh is null and date_cr is null)) then
    begin
      if (age_prec<0 or agetempo<0) then
      begin
        clef_ind=clef_prec;
        clef=clef_prec;
        nbr=1;
        suspend;
      end
      else
      begin
        if (date_dc is null and date_inh is null and date_cr is null
            and max_vie_hom>0 and max_vie_fem>0) then
          date_dc=date_nais;
        else
          if (date_dc is null)  then
            if (date_cr is null or date_cr>date_inh) then
              date_dc=date_inh;
            else
              date_dc=date_cr;
        if (date_dc<date_eve or date_dc<date_evf) then
        begin
          clef_ind=clef_prec;
          clef=clef_prec;
          nbr=1;
          suspend;
        end
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
  libelle='Individu(s) ayant une date d''événement individuel de forme anormale:';
  titre=1;
  suspend;
  titre=null;
  nbr=0;
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||case when i.sexe=2 then 'e' else '' end||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
      from individu i
      inner join evenements_ind e on e.ev_ind_kle_fiche=i.cle_fiche
                                 and e.ev_ind_date_writen is not null
      where i.kle_dossier=:i_dossier
        and (select valide from proc_date_writen(e.ev_ind_date_writen))=0
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
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||case when i.sexe=2 then 'e' else '' end||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
      from individu i
      inner join t_union u on u.union_mari=i.cle_fiche
                           or u.union_femme=i.cle_fiche
      inner join evenements_fam e on e.ev_fam_kle_famille=u.union_clef
                                 and e.ev_fam_date_writen is not null
      where i.kle_dossier=:i_dossier
        and (select valide from proc_date_writen(e.ev_fam_date_writen))=0
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
  libelle='Individu(s) ayant une date de domiciliation de forme anormale:';
  titre=1;
  suspend;
  titre=null;
  nbr=0;
  for select i.nom||coalesce(', '||i.prenom,'')||coalesce(' né'
             ||case when i.sexe=2 then 'e' else '' end||' en '||i.annee_naissance,'')
            ,i.cle_fiche
            ,i.sexe
      from individu i
      inner join adresses_ind a on a.adr_kle_ind=i.cle_fiche
                                 and a.adr_date_writen is not null
      where i.kle_dossier=:i_dossier
        and (select valide from proc_date_writen(a.adr_date_writen))=0
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
end^
commit^

alter PROCEDURE PROC_ARBREREDUIT (
    I_CLEF INTEGER,
    I_DOSSIER INTEGER,
    I_PARQUI INTEGER,
    I_NIVEAU INTEGER)
RETURNS (
    NIVEAU INTEGER,
    CLE_FICHE INTEGER,
    NOM VARCHAR(60),
    PRENOM VARCHAR(100),
    SURNOM VARCHAR(100),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    SOSA INTEGER,
    NUM_SOSA DOUBLE PRECISION,
    IMPLEXE DOUBLE PRECISION)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 17:51:15
   Modifiée le :25/12/2005 sélection explicite des champs, gestion des implexes
   à : :
   par :
   Description : 
   Usage       :
   ---------------------------------------------------------------------------*/
   for
         select NIVEAU,
                CLE_FICHE,
                NOM,
                PRENOM,
                SURNOM,
                DATE_NAISSANCE,
                DATE_DECES,
                SEXE,
                CLE_PERE,
                CLE_MERE,
                SOSA,
                NUM_SOSA,
                IMPLEXE
         from PROC_ARBRE(:I_CLEF, :I_NIVEAU, :I_DOSSIER, :I_PARQUI)
         INTO :NIVEAU,
              :CLE_FICHE,
              :NOM,
              :PRENOM,
              :SURNOM,
              :DATE_NAISSANCE,
              :DATE_DECES,
              :SEXE,
              :CLE_PERE,
              :CLE_MERE,
              :SOSA,
              :NUM_SOSA,
              :IMPLEXE
   do
   suspend;
end^
commit^

alter PROCEDURE PROC_TQ_ASCENDANCE (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_PARQUI INTEGER,
    I_MODE INTEGER)
RETURNS (
    TQ_NIVEAU INTEGER,
    TQ_CLE_FICHE INTEGER,
    TQ_SOSA DOUBLE PRECISION,
    TQ_DOSSIER INTEGER,
    IMPLEXE DOUBLE PRECISION,
    TQ_DESCENDANT INTEGER)
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
                    AND NOT exists (select * FROM TQ_ARBREREDUIT
                                           where tq_cle_fiche=i.CLE_PERE);
             /*Par les femmes */
             if (I_PARQUI =2 or I_PARQUI =0) then
               insert into TQ_ARBREREDUIT
                      (tq_niveau,tq_cle_fiche,tq_dossier,tq_sosa,tq_descendant)
               select :i+1,i.cle_mere,i.cle_pere,:SOSA*2+1,:i_clef
                  from individu i
                  WHERE i.cle_fiche =:I_CLEF
                    AND i.CLE_MERE IS NOT NULL
                    AND NOT exists (select * FROM TQ_ARBREREDUIT
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
commit^

alter PROCEDURE PROC_ARBRE (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_DOSSIER INTEGER,
    I_PARQUI INTEGER)
RETURNS (
    NIVEAU INTEGER,
    CLE_FICHE INTEGER,
    NOM VARCHAR(60),
    PRENOM VARCHAR(100),
    SURNOM VARCHAR(120),
    DATE_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    SOSA DOUBLE PRECISION,
    NUM_SOSA DOUBLE PRECISION,
    IMPLEXE DOUBLE PRECISION)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 17:45:26
   Modifiée le :15/02/2006 par André pour séparer le remplissage de la table temporaire
   le 3/1/2006 pour balayer la table dans l'ordre des SOSA et que ainsi IMPLEXE<SOSA
   à : :
   par :
   Description :    Cette procedure permet de récuperer la fam d'un individu
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
      SELECT  T.tq_niveau,
              i.cle_fiche,
              i.nom,
              i.prenom,
              i.surnom,
              i.date_naissance,
              i.date_deces,
              i.sexe,
              i.cle_pere,
              i.cle_mere,
              T.tq_sosa,
              i.num_sosa,
              T.IMPLEXE
         FROM PROC_TQ_ASCENDANCE(:I_CLEF,:I_NIVEAU,:I_PARQUI,1) t
              inner join individu i on i.cle_fiche=t.tq_cle_fiche
         ORDER BY T.tq_SOSA
         INTO :NIVEAU,
              :CLE_FICHE,
              :NOM,
              :PRENOM,
              :SURNOM,
              :DATE_NAISSANCE,
              :DATE_DECES,
              :SEXE,
              :CLE_PERE,
              :CLE_MERE,
              :SOSA,
              :NUM_SOSA,
              :IMPLEXE
   do
   suspend;
end^
commit^

alter PROCEDURE PROC_ARBRE_ECRAN (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_DOSSIER INTEGER,
    I_PARQUI INTEGER)
RETURNS (
    NIVEAU INTEGER,
    SOSA DOUBLE PRECISION,
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
    DATE_NAISSANCE VARCHAR(100),
    ANNEE_NAISSANCE INTEGER,
    DATE_DECES VARCHAR(100),
    ANNEE_DECES INTEGER,
    DECEDE INTEGER,
    AGE_AU_DECES INTEGER,
    SOURCE BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    COMMENT BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    FILLIATION VARCHAR(30),
    NUM_SOSA DOUBLE PRECISION,
    OCCUPATION VARCHAR(90),
    NCHI INTEGER,
    NMR INTEGER,
    CLE_FIXE INTEGER,
    IMPLEXE DOUBLE PRECISION)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 18:10:14
   Modifiée le :28/01/2006 par André pour mettre en évidence tous les ascendants même implexes
   à : : et correction dernier métier
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
              t.IMPLEXE
         FROM PROC_TQ_ASCENDANCE(:I_CLEF,:I_NIVEAU,:I_PARQUI,2) t
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
              :IMPLEXE
   do
     begin
       OCCUPATION=NULL;
       SELECT OCCUPATION FROM PROC_DERNIER_METIER(:CLE_FICHE)
             INTO :OCCUPATION;
       suspend;
     end
end^
commit^

alter PROCEDURE PROC_ARBRE_EXPORT (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_DOSSIER INTEGER,
    I_PARQUI INTEGER)
RETURNS (
    NIVEAU INTEGER,
    SOSA DOUBLE PRECISION,
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
    DATE_NAISSANCE VARCHAR(100),
    ANNEE_NAISSANCE INTEGER,
    DATE_DECES VARCHAR(100),
    ANNEE_DECES INTEGER,
    DECEDE INTEGER,
    AGE_AU_DECES INTEGER,
    SOURCE BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    COMMENT BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    FILLIATION VARCHAR(30),
    NUM_SOSA DOUBLE PRECISION,
    OCCUPATION VARCHAR(90),
    NCHI INTEGER,
    NMR INTEGER,
    CLE_FIXE INTEGER,
    IMPLEXE DOUBLE PRECISION,
    DESCENDANT INTEGER)
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
commit^

alter PROCEDURE proc_etat_ascendance (
    I_CLEF INTEGER,
    I_GENERATION INTEGER,
    I_DOSSIER INTEGER,
    I_PARQUI INTEGER)
RETURNS (
    GENERATTION INTEGER,
    SOSA DOUBLE PRECISION,
    NOM VARCHAR(101),
    DATE_NAISSANCE VARCHAR(100),
    CP_NAISSANCE VARCHAR(10),
    VILLE_NAISSANCE VARCHAR(50),
    LIEU_NAISSANCE VARCHAR(100),
    DATE_DECES VARCHAR(100),
    CP_DECES VARCHAR(10),
    VILLE_DECES VARCHAR(50),
    LIEU_DECES VARCHAR(100),
    SEXE INTEGER,
    AGE INTEGER,
    CLE_FICHE INTEGER,
    IMPLEXE DOUBLE PRECISION,
    DATE_MARIAGE VARCHAR(100),
    CP_MARIAGE VARCHAR(10),
    VILLE_MARIAGE VARCHAR(50))
AS
DECLARE VARIABLE CLEF_UNION INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:05:30
   Modifiée le :11/01/2006 par André, ajout du champ implexe
   le 27/09/2006 pour concat avec prenom NULL et subd, 19/10/2006 ajout mariage
   par :
   Description : Cette procedure permet de préparer l'état complet d'ascendance pour un
   individu, et sur un nombre de générations donné
   Usage       :
   ---------------------------------------------------------------------------*/
   for select t.tq_niveau + 1
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
             ,(d.ev_ind_date_year -  n.ev_ind_date_year)
             ,t.tq_cle_fiche
             ,t.implexe
             ,u.union_clef
       from proc_tq_ascendance(:i_clef,:i_generation,:i_parqui,1) t
       inner join individu i on i.cle_fiche=t.tq_cle_fiche
       left  join evenements_ind n
                on (n.ev_ind_kle_fiche=t.tq_cle_fiche and
                    n.ev_ind_type = 'BIRT')
       left  join evenements_ind d
                on (d.ev_ind_kle_fiche=t.tq_cle_fiche and
                    d.ev_ind_type = 'DEAT')
       left  join t_union u
                on (i.sexe=1 and u.union_mari=t.tq_cle_fiche and u.union_femme=t.tq_dossier)
                or (i.sexe=2 and u.union_femme=t.tq_cle_fiche and u.union_mari=t.tq_dossier)
       order by 1
               ,2
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
   do
   begin
     date_mariage=null;
     cp_mariage=null;
     ville_mariage=null;
     select first (1)
            ev_fam_date_writen
           ,ev_fam_cp
           ,ev_fam_ville
     from evenements_fam
     where ev_fam_type='MARR'
       and ev_fam_kle_famille=:clef_union
     order by ev_fam_date_year
             ,ev_fam_date_mois
             ,ev_fam_date
     into :date_mariage
         ,:cp_mariage
         ,:ville_mariage;
     suspend;
   end
end^
commit^

alter PROCEDURE PROC_TQ_DESCENDANCE (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_PARQUI INTEGER,
    I_MODE INTEGER)
RETURNS (
    TQ_NIVEAU INTEGER,
    TQ_CLE_FICHE INTEGER,
    TQ_SOSA VARCHAR(120),
    TQ_CLE_PERE INTEGER,
    TQ_CLE_MERE INTEGER,
    TQ_NUM_SOSA VARCHAR(120),
    TQ_ASCENDANT INTEGER)
AS
DECLARE VARIABLE I_COUNT INTEGER;
DECLARE VARIABLE I INTEGER;
DECLARE VARIABLE J INTEGER;
DECLARE VARIABLE I_NUM_SOSA VARCHAR(120);
DECLARE VARIABLE I_FICHE INTEGER;
DECLARE VARIABLE I_PERE INTEGER;
DECLARE VARIABLE I_MERE INTEGER;
DECLARE VARIABLE SJ CHAR(1);
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 18:13:51
   Modifiée par André: codification d'Aboville alphanumérique dans champ TQ_NUM_SOSA
   Implexe dans champ TQ_SOSA. 10/02/2006 Séparation remplissage table par proc séparée
   et création I_MODE: 0=sans implexe, 1= un niveau d'implexes, 2= tous les implexes
   Description : Cette procedure permet de récuperer tous les descendants d'un individu
   dans une table technique
   Le remplissage de la table est fonction de Niveaux
   0 - Lui Meme
   x - les descendant par niveau
   Usage       :
   ---------------------------------------------------------------------------*/
  i = 1;
   /* purge de la table pour le meme proprio de la table ---------------------*/
  delete from TQ_ARBREDESCENDANT;
   /*lui meme-----------------------------------------------------------------*/
  insert into TQ_ARBREDESCENDANT
              (tq_niveau,tq_cle_fiche,tq_num_sosa,TQ_CLE_PERE,TQ_CLE_MERE)
          SELECT 1,:i_clef,'1',CLE_PERE,CLE_MERE FROM INDIVIDU WHERE CLE_FICHE=:I_CLEF;
  Select Count(0)
      from TQ_ARBREDESCENDANT
      where tq_niveau=:I into :I_COUNT;
  if (:I_NIVEAU=1) Then I_COUNT=0;
   /*Tous les descendants ----------------------------------------------------*/
  IF (I_MODE=1) THEN
  BEGIN
      while (:I_COUNT>0) do
      begin
       For SELECT TQ_CLE_FICHE,TQ_NUM_SOSA FROM TQ_ARBREDESCENDANT
             WHERE TQ_NIVEAU=:i AND TQ_SOSA IS NULL
             ORDER BY TQ_NUM_SOSA
             INTO :I_CLEF,
                  :I_NUM_SOSA
         DO
         begin
           J=0;
           FOR SELECT i.CLE_FICHE,i.CLE_PERE,i.CLE_MERE
             FROM INDIVIDU i
                 LEFT JOIN EVENEMENTS_IND ev ON ev.EV_IND_KLE_FICHE=i.CLE_FICHE
             WHERE (i.CLE_PERE=:I_CLEF OR i.CLE_MERE=:I_CLEF)
             GROUP BY i.CLE_FICHE,i.CLE_PERE,i.CLE_MERE
             ORDER by MIN(ev.EV_IND_DATE_YEAR),MIN(ev.ev_ind_date_mois),MIN(ev.EV_IND_DATE)
             INTO :I_FICHE,
                  :I_PERE,
                  :I_MERE
             DO
             BEGIN
               J=J+1;
               IF (J<10) THEN SJ=CAST(J as char(1));
               ELSE SJ=ASCII_CHAR(J+55);
               INSERT INTO TQ_ARBREDESCENDANT
                 (TQ_NIVEAU,TQ_CLE_FICHE,TQ_NUM_SOSA,
                  TQ_CLE_PERE,TQ_CLE_MERE,TQ_SOSA,TQ_ASCENDANT)
                 VALUES
                 (:I+1,:I_FICHE,:I_NUM_SOSA||:SJ,:I_PERE,:I_MERE,
                  (SELECT TQ_NUM_SOSA FROM TQ_ARBREDESCENDANT
                     WHERE TQ_CLE_FICHE=:I_FICHE AND TQ_SOSA IS NULL),:i_clef);
             END
         end
        i = i + 1;
        Select Count(0)
         from TQ_ARBREDESCENDANT
         where TQ_NIVEAU=:i
         into :I_COUNT;
       if (:I_NIVEAU>1 AND :i=:I_NIVEAU) then I_COUNT=0;
      end
  END
  ELSE
    IF (I_MODE=2) THEN
    BEGIN
      while (:I_COUNT>0) do
      begin
       For SELECT TQ_CLE_FICHE,TQ_NUM_SOSA FROM TQ_ARBREDESCENDANT
             WHERE TQ_NIVEAU=:i
             ORDER BY TQ_NUM_SOSA
             INTO :I_CLEF,
                  :I_NUM_SOSA
         DO
         begin
           J=0;
           FOR SELECT i.CLE_FICHE,i.CLE_PERE,i.CLE_MERE
             FROM INDIVIDU i
                 LEFT JOIN EVENEMENTS_IND ev ON ev.EV_IND_KLE_FICHE=i.CLE_FICHE
             WHERE (i.CLE_PERE=:I_CLEF OR i.CLE_MERE=:I_CLEF)
             GROUP BY i.CLE_FICHE,i.CLE_PERE,i.CLE_MERE
             ORDER by MIN(ev.EV_IND_DATE_YEAR),MIN(ev.ev_ind_date_mois),MIN(ev.EV_IND_DATE)
             INTO :I_FICHE,
                  :I_PERE,
                  :I_MERE
             DO
             BEGIN
               J=J+1;
               IF (J<10) THEN SJ=CAST(J as char(1));
               ELSE SJ=ASCII_CHAR(J+55);
               INSERT INTO TQ_ARBREDESCENDANT
                 (TQ_NIVEAU,TQ_CLE_FICHE,TQ_NUM_SOSA,
                  TQ_CLE_PERE,TQ_CLE_MERE,TQ_SOSA,TQ_ASCENDANT)
                 VALUES
                 (:I+1,:I_FICHE,:I_NUM_SOSA||:SJ,:I_PERE,:I_MERE,
                  (SELECT TQ_NUM_SOSA FROM TQ_ARBREDESCENDANT
                     WHERE TQ_CLE_FICHE=:I_FICHE AND TQ_SOSA IS NULL),:i_clef);
             END
         end
        i = i + 1;
        Select Count(0)
         from TQ_ARBREDESCENDANT
         where TQ_NIVEAU=:i
         into :I_COUNT;
       if (:I_NIVEAU>1 AND :i=:I_NIVEAU) then I_COUNT=0;
      end
    END
    ELSE  /* I_MODE=0 */
    BEGIN
      while (:I_COUNT>0) do
      begin
       For SELECT TQ_CLE_FICHE,TQ_NUM_SOSA FROM TQ_ARBREDESCENDANT
             WHERE TQ_NIVEAU=:i
             ORDER BY TQ_NUM_SOSA
             INTO :I_CLEF,
                  :I_NUM_SOSA
         DO
         begin
           J=0;
           FOR SELECT i.CLE_FICHE,i.CLE_PERE,i.CLE_MERE
             FROM INDIVIDU i
                 LEFT JOIN EVENEMENTS_IND ev ON ev.EV_IND_KLE_FICHE=i.CLE_FICHE
             WHERE (i.CLE_PERE=:I_CLEF OR i.CLE_MERE=:I_CLEF)
                   AND  NOT exists (SELECT * FROM TQ_ARBREDESCENDANT
                                           where TQ_CLE_FICHE=i.CLE_FICHE)
             GROUP BY i.CLE_FICHE,i.CLE_PERE,i.CLE_MERE
             ORDER by MIN(ev.EV_IND_DATE_YEAR),MIN(ev.ev_ind_date_mois),MIN(ev.EV_IND_DATE)
             INTO :I_FICHE,
                  :I_PERE,
                  :I_MERE
             DO
             BEGIN
               J=J+1;
               IF (J<10) THEN SJ=CAST(J as char(1));
               ELSE SJ=ASCII_CHAR(J+55);
               INSERT INTO TQ_ARBREDESCENDANT
                 (TQ_NIVEAU,TQ_CLE_FICHE,TQ_NUM_SOSA,
                  TQ_CLE_PERE,TQ_CLE_MERE,TQ_ASCENDANT)
                 VALUES
                 (:I+1,:I_FICHE,:I_NUM_SOSA||:SJ,:I_PERE,:I_MERE,:i_clef);
             END
         end
        i = i + 1;
        Select Count(0)
         from TQ_ARBREDESCENDANT
         where TQ_NIVEAU=:i
         into :I_COUNT;
       if (:I_NIVEAU>1 AND :i=:I_NIVEAU) then I_COUNT=0;
      end
    END
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
  delete from TQ_ARBREDESCENDANT;
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
    SOURCE BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    COMMENT BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    FILLIATION VARCHAR(30),
    NUM_SOSA DOUBLE PRECISION,
    ORDRE VARCHAR(255),
    NCHI INTEGER,
    NMR INTEGER,
    CLE_FIXE INTEGER,
    ASCENDANT INTEGER)
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
commit^

CREATE OR ALTER PROCEDURE PROC_GROUPE (
    i_groupe integer,
    i_individu integer,
    mode varchar(1),
    stricte varchar(1),
    temoins varchar(1),
    initialisation varchar(1),
    effet varchar(1),
    verbose varchar(1))
returns (
    info varchar(50))
as
declare variable i_dossier integer; /* nécessaire à suppression ou élagage */
declare variable i_count integer; /* comptage du niveau */
declare variable i integer; /* niveau pour calcul */
declare variable i_sexe integer; /* Sexe individu de départ */
declare variable i_sx integer; /* Sexe individu sélectionné */
declare variable i_ind integer; /* nouvel individu */
declare variable i_indiv integer; /* individu sélectionné */
declare variable i_s integer; /* sexe nouvel individu */
begin
/*Procédure créée par André le 15/02/2006. Dernière maj 30/04/2008
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
TEMONS= 'Y' sélectionne également les témoins (option très dangereuse),
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
  effet=upper(effet);
  if (effet not in ('A','E','S')) then
  begin
    info='EFFET '||effet||' inconnu';
    suspend;
    exit;
  end
  verbose=upper(verbose);
  if (verbose <>'N') then
    verbose='Y';
  if (i_individu>0) then --faire analyse
  begin
    mode=upper(mode);
    if (mode not in('A','D','B')) then
    begin
      info='MODE '||mode||' inconnu';
      suspend;
      exit;
    end
    temoins=upper(temoins);
    if (temoins not in('N','Y')) then
    begin
      info='TEMOINS '||temoins||' inconnu';
      suspend;
      exit;
    end
    initialisation=upper(initialisation);
    if (initialisation not in('N','P','Y')) then
    begin
      info='INITIALISATION '||initialisation||' inconnu';
      suspend;
      exit;
    end
    for select 'I_INDIVIDU '||cast(:i_individu as varchar(20))||' inconnu' from individu
        where :i_individu not in (select cle_fiche from individu)
        into :info
    do
    begin
      suspend;
      exit;
    end
    if (temoins='Y') then
    begin
      delete from tq_id;
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
    end
    select sexe from individu where cle_fiche=:i_individu into :i_sexe;
    delete from t_doublons;   --contiendra la liste des exclusions
    if (mode='A' or mode='D') then
    begin
      stricte=upper(stricte);
      if (stricte not in('Y','N')) then
      begin
        info='STRICTE '||stricte||' inconnu';
        suspend;
        exit;
      end
      if (stricte='Y') then  --remplir la liste des exclus
      begin
        if (mode='A') then  --descendants de l'individu et de ses conjoints
        begin
          for select tq_cle_fiche from proc_tq_descendance(:i_individu,0,0,0) into :i_indiv
          do insert into t_doublons (cle_fiche)  values(:i_indiv);
          for select union_mari from t_union where :i_sexe=2 and union_femme=:i_individu
                                                      and union_mari>0
              union
              select union_femme from t_union where :i_sexe=1 and union_mari=:i_individu
                                                and union_femme>0
              into :i_indiv
          do
          begin
            for select  tq_cle_fiche from proc_tq_descendance(:i_indiv,0,0,0)
                where tq_cle_fiche not in (select cle_fiche from t_doublons)
                into :i_ind
            do insert into t_doublons (cle_fiche)  values(:i_ind);
          end
        end
        if (mode='D') then  --ascendants de l'individu et de ses conjoints
        begin
          for select tq_cle_fiche from proc_tq_ascendance(:i_individu,0,0,0) into :i_indiv
          do insert into t_doublons (cle_fiche)  values(:i_indiv);
          for select union_mari from t_union where :i_sexe=2 and union_femme=:i_individu
                                               and union_mari>0
              union
              select union_femme from t_union where :i_sexe=1 and union_mari=:i_individu
                                                and union_femme>0
              into :i_indiv
          do
          begin
            for select  tq_cle_fiche from proc_tq_ascendance(:i_indiv,0,0,0)
                where tq_cle_fiche not in (select cle_fiche from t_doublons)
                into :i_ind
            do insert into t_doublons (cle_fiche)  values(:i_ind);
          end
        end
        --ajout des conjoints à la liste
        for select u.union_mari from t_union u, t_doublons t
            where u.union_femme=t.cle_fiche and u.union_mari>0
              and u.union_mari not in (select cle_fiche from t_doublons)
            union
            select u.union_femme from t_union u, t_doublons t
            where u.union_mari=t.cle_fiche and u.union_femme>0
              and u.union_femme not in (select cle_fiche from t_doublons)
            into :i_indiv
            do insert into t_doublons (cle_fiche)  values(:i_ind);
      end
    end
    if (initialisation='P') then
      delete from ta_groupes where ta_groupe=:i_groupe;
    else
      if (initialisation='Y') then
        delete from ta_groupes;
    update ta_groupes set ta_niveau=null;
    if (mode='B') then   --mise de l'individu en tête de la sélection
    begin
      i=0;
      insert into ta_groupes (ta_niveau,ta_cle_fiche,ta_groupe,ta_sexe)
             values(:i,:i_individu,:i_groupe,:i_sexe);
    end
    if (mode='D') then   --mise des enfants de l'individu en tête de la sélection
    begin
      i=0;
      for select cle_fiche,sexe from individu
          where (:i_sexe=1 and cle_pere=:i_individu)
             or (:i_sexe=2 and cle_mere=:i_individu)
          into :i_ind,:i_s
      do insert into ta_groupes (ta_niveau,ta_cle_fiche,ta_groupe,ta_sexe)
                          values(:i,:i_ind,:i_groupe,:i_s);
    end
    if (mode='A') then   --mise des parents de l'individu en tête de la sélection
    begin
      i=0;
      for select cle_pere,1 from individu
          where cle_fiche=:i_individu and cle_pere is not null
          union
          select cle_mere,2 from individu
          where cle_fiche=:i_individu and cle_mere is not null
          into :i_ind,:i_s
      do insert into ta_groupes (ta_niveau,ta_cle_fiche,ta_groupe,ta_sexe)
                          values(:i,:i_ind,:i_groupe,:i_s);
    end
    select count(*) from ta_groupes where ta_niveau=:i into :i_count;
    while (i_count>0) do
    begin  --pour chaque niveau I
      --pour chaque individu de la sélection
      for select ta_cle_fiche,ta_sexe from ta_groupes
          where ta_niveau=:i
          into :i_indiv,:i_sx
      do
      begin
        if (mode<>'A' or i>0) then
            --ajout des enfants au niveau I+1
          if (:i_sx=1) then
            for select i.cle_fiche,i.sexe from individu i
                where i.cle_pere=:i_indiv
                  and not exists (select * from ta_groupes
                                  where ta_niveau is not null and ta_cle_fiche=i.cle_fiche)
                  and not exists (select * from t_doublons
                                  where cle_fiche=i.cle_fiche)
                into :i_ind,:i_s
            do insert into ta_groupes (ta_niveau,ta_cle_fiche,ta_groupe,ta_sexe)
                          values(:i+1,:i_ind,:i_groupe,:i_s);
          else
            for select i.cle_fiche,i.sexe from individu i
                where i.cle_mere=:i_indiv
                  and not exists (select * from ta_groupes
                                  where ta_niveau is not null and ta_cle_fiche=i.cle_fiche)
                  and not exists (select * from t_doublons
                                  where cle_fiche=i.cle_fiche)
                into :i_ind,:i_s
            do insert into ta_groupes (ta_niveau,ta_cle_fiche,ta_groupe,ta_sexe)
                          values(:i+1,:i_ind,:i_groupe,:i_s);
        if (mode<>'D' or i>0) then
        begin --ajout des parents au niveau I+1
          for select i.cle_pere,1 from individu i
              where i.cle_fiche=:i_indiv and i.cle_pere >0
                and not exists (select * from ta_groupes
                                where ta_niveau is not null and ta_cle_fiche=i.cle_pere)
                and not exists (select * from t_doublons
                                where cle_fiche=i.cle_pere)
              union
              select i.cle_mere,2 from individu i
              where i.cle_fiche=:i_indiv and i.cle_mere >0
                and not exists (select * from ta_groupes
                                where ta_niveau is not null and ta_cle_fiche=i.cle_mere)
                and not exists (select * from t_doublons
                                where cle_fiche=i.cle_mere)
              into :i_ind,:i_s
          do insert into ta_groupes (ta_niveau,ta_cle_fiche,ta_groupe,ta_sexe)
                          values(:i+1,:i_ind,:i_groupe,:i_s);
        end
        if (temoins='Y') then  --ajout des témoins au niveau I+1
          for select a."ID2",i.sexe
              from tq_id a
              inner join individu i on i.cle_fiche=a."ID2"
              where a."ID1"=:i_indiv
                and not exists (select * from ta_groupes
                                where ta_niveau is not null and ta_cle_fiche=a."ID2")
                and not exists (select * from t_doublons
                                where cle_fiche=a."ID2")
              into :i_ind,:i_s
          do insert into ta_groupes (ta_niveau,ta_cle_fiche,ta_groupe,ta_sexe)
                          values(:i+1,:i_ind,:i_groupe,:i_s);
        if (i_sx=1) then --ajout des conjoints
          for select u.union_femme,2 from t_union u
              where u.union_mari=:i_indiv and u.union_femme>0
                and not exists (select * from ta_groupes
                                where ta_niveau is not null and ta_cle_fiche=u.union_femme)
                and not exists (select * from t_doublons
                                where cle_fiche=u.union_femme)
              into :i_ind,:i_s
          do insert into ta_groupes (ta_niveau,ta_cle_fiche,ta_groupe,ta_sexe)
                          values(:i+1,:i_ind,:i_groupe,:i_s);
        else
          for select u.union_mari,1 from t_union u
              where u.union_femme=:i_indiv and u.union_mari>0
                and not exists (select * from ta_groupes
                                where ta_niveau is not null and ta_cle_fiche=u.union_mari)
                and not exists (select * from t_doublons
                                where cle_fiche=u.union_mari)
              into :i_ind,:i_s
          do insert into ta_groupes (ta_niveau,ta_cle_fiche,ta_groupe,ta_sexe)
                          values(:i+1,:i_ind,:i_groupe,:i_s);
      end
      i=i+1;
      select count(*) from ta_groupes where ta_niveau=:i into :i_count;
    end --de WHILE (I_COUNT>0), TA_GROUPES remplie
    delete from tq_id;
    delete from t_doublons;
    select cast(count(distinct ta_cle_fiche) as varchar(20))||' individus dans le groupe' from ta_groupes
    where ta_groupe=:i_groupe
    into :info;
    if (verbose='Y') then
    begin
      suspend;
      select cast(count(*) as varchar(20))||' individus au niveau' from ta_groupes
      where ta_niveau is not null
      into :info;
      suspend;
      if (mode='D' and stricte='N') then
      begin
        for select 'erreur '||cast(t.ta_cle_fiche as varchar(20))||' dans l''ascendance'
            from proc_tq_ascendance(:i_individu,0,0,0) a
            inner join ta_groupes t on t.ta_cle_fiche=a.tq_cle_fiche
            into :info
        do
          suspend;
        for select union_mari
            from t_union
            where :i_sexe=2 and union_femme=:i_individu and union_mari>0
            union
            select union_femme
            from t_union
            where :i_sexe=1 and union_mari=:i_individu and union_femme>0
            into :i_indiv
        do
        for select 'erreur '||cast(t.ta_cle_fiche as varchar(20))||' dans l''ascendance'
            from proc_tq_ascendance(:i_indiv,0,0,0) a
            inner join ta_groupes t on t.ta_cle_fiche=a.tq_cle_fiche
            into :info
        do
          suspend;
      end
      if (mode='A' and stricte='N') then
      begin
        for select 'erreur '||cast(t.ta_cle_fiche as varchar(20))||' dans la descendance'
            from proc_tq_descendance(:i_individu,0,0,0) a
            inner join ta_groupes t on t.ta_cle_fiche=a.tq_cle_fiche
            into :info
        do
          suspend;
        for select union_mari
            from t_union
            where :i_sexe=2 and union_femme=:i_individu and union_mari>0
            union
            select union_femme
            from t_union
            where :i_sexe=1 and union_mari=:i_individu and union_femme>0
            into :i_indiv
        do
        for select 'erreur '||cast(t.ta_cle_fiche as varchar(20))||' dans la descendance'
            from proc_tq_descendance(:i_indiv,0,0,0) a
            inner join ta_groupes t on t.ta_cle_fiche=a.tq_cle_fiche
            into :info
        do
          suspend;
      end
    end --de IF (VERBOSE='Y')
  end --Fin de I_INDIVIDU>0, action faite
  if (effet='A') then
  begin
    delete from t_doublons;
    if (i_individu=0) then
    begin
      info='Rien à faire';
      suspend;
    end
    else
    if (verbose='N') then
      suspend;
    exit;
  end
  select count(distinct i.kle_dossier) from ta_groupes t
  inner join individu i on i.cle_fiche=t.ta_cle_fiche
  where t.ta_groupe=:i_groupe
  into :i_count;
  if (i_count>1) then
  begin
    info='Plusieurs dossiers dans le groupe';
    suspend;
    exit;
  end
  select count(ta_cle_fiche) from ta_groupes
  where ta_groupe=:i_groupe
  into :i_count;
  if (i_count=0) then
  begin
    info='Pas d''individu dans la sélection';
    suspend;
    exit;
  end
  select distinct i.kle_dossier from ta_groupes t
  inner join individu i on i.cle_fiche=t.ta_cle_fiche
  where t.ta_groupe=:i_groupe
  into :i_dossier;
  delete from t_doublons;
  if (effet='S') then
    for select distinct ta_cle_fiche from ta_groupes
        where ta_groupe=:i_groupe
        into :i_ind
    do insert into t_doublons (cle_fiche)  values(:i_ind);
  else --EFFET='E'
    for select cle_fiche from individu
        where kle_dossier=:i_dossier
          and cle_fiche not in (select ta_cle_fiche from ta_groupes
                                where ta_groupe=:i_groupe)
        into :i_ind
    do
      insert into t_doublons (cle_fiche)  values(:i_ind);
  select cast(count(cle_fiche) as varchar(20))||' individus supprimés' from t_doublons
  into :info;
  delete from individu
  where cle_fiche in (select cle_fiche from t_doublons);
  delete from t_union
  where union_mari is null and union_femme is null;
  delete from t_union t
  where (t.union_mari is null
         and not exists (select * from individu where cle_mere=t.union_femme))
     or (t.union_femme is null
         and not exists (select * from individu where cle_pere=t.union_mari));
  delete from evenements_fam
  where ev_fam_kle_famille in (select union_clef from t_union
                               where union_mari is null or union_femme is null);
  delete from media_pointeurs where mp_cle_individu not in (select cle_fiche from individu);
  delete from t_doublons;
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
    ISSU_UNION INTEGER)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:06:20
   Modifiée le : 12/01/2006 par André pour erreur concaténation si prénom NULL
   09/07/07 ajout conjoints, mariages et précisions du lieu
   par :
   Description : Cette procedure permet de récuperer tous les descendant d'un individu
   en se servant d'une table technique
   Le remplissage de la table est fonction de Niveaux
   0 - Lui Meme
   x - les descendant par niveau
   Usage       :
   ---------------------------------------------------------------------------*/
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
    ,nd.rdp_code_deux
    ,d.ev_ind_clef
    ,d.EV_IND_VILLE
    ,d.EV_IND_CP
    ,d.ev_ind_dept
    ,d.ev_ind_pays
    ,dd.rdp_code_deux
    ,(SELECT OCCUPATION FROM PROC_DERNIER_METIER(t.tq_cle_fiche))
    ,c.cle_fiche
    ,c.NOM
    ,c.prenom
    ,nc.ev_ind_clef
    ,c.date_naissance
    ,nc.EV_IND_VILLE
    ,nc.EV_IND_CP
    ,nc.ev_ind_dept
    ,nc.ev_ind_pays
    ,ncd.rdp_code_deux
    ,dc.ev_ind_clef
    ,c.date_deces
    ,dc.EV_IND_VILLE
    ,dc.EV_IND_CP
    ,dc.ev_ind_dept
    ,dc.ev_ind_pays
    ,dcd.rdp_code_deux
    ,(SELECT OCCUPATION FROM PROC_DERNIER_METIER(c.cle_fiche))
    ,c.cle_mariage
    ,c.date_mariage
    ,m.EV_fam_VILLE
    ,m.EV_fam_CP
    ,m.ev_fam_dept
    ,m.ev_fam_pays
    ,md.rdp_code_deux
    ,c.union_clef
    ,c.ordre_union
    ,(select first(1) ordre_union
      from proc_trouve_conjoints(0,t.tq_ascendant)
      where cle_fiche in (i.cle_pere,i.cle_mere))
    FROM PROC_TQ_DESCENDANCE(:I_CLEF,:I_NIVEAU,0,1) t
    inner join individu i on i.cle_fiche=t.tq_cle_fiche
    left join EVENEMENTS_IND n on n.EV_IND_KLE_FICHE=i.cle_fiche
                               and n.EV_IND_TYPE='BIRT'
    left join ref_pays np on np.rpa_libelle=n.ev_ind_pays
    left join ref_departements nd on nd.rdp_libelle=n.ev_ind_dept
                                  and nd.rdp_pays=np.rpa_code
    left join EVENEMENTS_IND d on d.EV_IND_KLE_FICHE=i.cle_fiche
                               and d.EV_IND_TYPE='DEAT'
    left join ref_pays dp on dp.rpa_libelle=d.ev_ind_pays
    left join ref_departements dd on dd.rdp_libelle=d.ev_ind_dept
                                  and dd.rdp_pays=dp.rpa_code
    left join PROC_TROUVE_CONJOINTS(0,i.cle_fiche) c ON 1=1
    left join EVENEMENTS_IND nc on nc.EV_IND_KLE_FICHE=c.cle_fiche
                               and nc.EV_IND_TYPE='BIRT'
    left join ref_pays ncp on ncp.rpa_libelle=nc.ev_ind_pays
    left join ref_departements ncd on ncd.rdp_libelle=nc.ev_ind_dept
                                  and ncd.rdp_pays=ncp.rpa_code
    left join EVENEMENTS_IND dc on dc.EV_IND_KLE_FICHE=c.cle_fiche
                               and dc.EV_IND_TYPE='DEAT'
    left join ref_pays dcp on dcp.rpa_libelle=dc.ev_ind_pays
    left join ref_departements dcd on dcd.rdp_libelle=dc.ev_ind_dept
                                  and dcd.rdp_pays=dcp.rpa_code
    left join EVENEMENTS_FAM m on m.ev_fam_clef=c.cle_mariage
    left join ref_pays mp on mp.rpa_libelle=m.ev_fam_pays
    left join ref_departements md on md.rdp_libelle=m.ev_fam_dept
                                  and md.rdp_pays=mp.rpa_code
    ORDER BY t.tq_niveau
            ,t.tq_num_sosa
            ,c.ordre_union
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
commit^

alter PROCEDURE PROC_RENUM_SOSA (
    I_CLEF INTEGER,
    I_NIVEAU INTEGER,
    I_DOSSIER INTEGER)
AS
DECLARE VARIABLE I_INDI INTEGER;
DECLARE VARIABLE D_SOSA DOUBLE PRECISION;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:30:33
   Modifiée le : 01/10/2007 par André: utilisation de proc_tq_ascendance
   Description : Cette procedure permet de faire une renumérotation SOSA de tous les
   individus.
   Le remplissage de la table est fonction de Niveaux
   0 - Lui Meme
   1 - Parents
   2 - Grands Parents
   x - Les autres
   Usage       :i_dossier pas utilisé
   ---------------------------------------------------------------------------*/
   update INDIVIDU i
      SET  i.NUM_SOSA=null
      WHERE i.KLE_DOSSIER=(select kle_dossier
                           from individu
                           where cle_fiche=:i_clef);
   for SELECT tq_cle_fiche,TQ_SOSA
       FROM proc_tq_ascendance(:i_clef,:i_niveau,0,0)
       into :i_indi,:d_sosa
   do
     update INDIVIDU i
      SET i.NUM_SOSA=:d_sosa
      WHERE i.cle_fiche=:i_indi;
end^
commit^

alter PROCEDURE PROC_SOSAS (
    I_CLEF INTEGER)
RETURNS (
    SOSAS VARCHAR(30))
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
commit^

alter PROCEDURE PROC_ETAT_FICHE (
    I_CLEF INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISSANCE VARCHAR(100),
    LIEU_NAISSANCE VARCHAR(210),
    DATE_DECES VARCHAR(100),
    LIEU_DECES VARCHAR(210),
    SEXE INTEGER,
    FILLIATION VARCHAR(30),
    COMMENT BLOB SUB_TYPE 1 SEGMENT SIZE 80,
    PERE_NOM VARCHAR(120),
    PERE_NAISSANCE VARCHAR(100),
    PERE_LIEU_NAISSANCE VARCHAR(210),
    PERE_DECES VARCHAR(100),
    PERE_LIEU_DECES VARCHAR(210),
    MERE_NOM VARCHAR(120),
    MERE_NAISSANCE VARCHAR(100),
    MERE_LIEU_NAISSANCE VARCHAR(210),
    MERE_DECES VARCHAR(100),
    MERE_LIEU_DECES VARCHAR(210),
    PHOTO BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    PREFIXE VARCHAR(30),
    SUFFIXE VARCHAR(30),
    SURNOM VARCHAR(120),
    NUM_SOSA DOUBLE PRECISION,
    SOSA1_NOMPRENOM VARCHAR(105),
    SOSAS VARCHAR(30),
    SOSAS_PERE VARCHAR(30),
    SOSAS_MERE VARCHAR(30))
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Dernière modification le :16/10/2007 par André, refonte complète, ajout sosas
   Description : Cette procédure permet de préparer l'état fiche individuelle
   ---------------------------------------------------------------------------*/
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
             ,:sosas_mere;
suspend;
end^
commit^

alter PROCEDURE PROC_ETAT_FICHE_FAMILIALE (
    ACLE_UNION INTEGER)
RETURNS (
    A_TYPE_UNION VARCHAR(40),
    A_EPOUX_CLE INTEGER,
    A_EPOUX_NOMPRENOM VARCHAR(105),
    A_EPOUX_NAISSANCE VARCHAR(100),
    A_EPOUX_LIEU_NAISSANCE VARCHAR(166),
    A_EPOUX_DECES VARCHAR(100),
    A_EPOUX_LIEU_DECES VARCHAR(166),
    A_EPOUSE_CLE INTEGER,
    A_EPOUSE_NOMPRENOM VARCHAR(105),
    A_EPOUSE_NAISSANCE VARCHAR(100),
    A_EPOUSE_LIEU_NAISSANCE VARCHAR(166),
    A_EPOUSE_DECES VARCHAR(100),
    A_EPOUSE_LIEU_DECES VARCHAR(166),
    A_EPOUX_PHOTO BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    A_EPOUSE_PHOTO BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    A_EPOUX_PERE_NOM VARCHAR(40),
    A_EPOUX_PERE_PRENOM VARCHAR(60),
    A_EPOUX_MERE_NOM VARCHAR(40),
    A_EPOUX_MERE_PRENOM VARCHAR(60),
    A_EPOUSE_PERE_NOM VARCHAR(40),
    A_EPOUSE_PERE_PRENOM VARCHAR(60),
    A_EPOUSE_MERE_NOM VARCHAR(40),
    A_EPOUSE_MERE_PRENOM VARCHAR(60),
    A_EPOUX_ANNEE INTEGER,
    A_EPOUSE_ANNEE INTEGER,
    A_EPOUX_AGE_DECES INTEGER,
    A_EPOUSE_AGE_DECES INTEGER,
    A_EPOUX_SOSA DOUBLE PRECISION,
    A_EPOUSE_SOSA DOUBLE PRECISION,
    A_SOSA1_NOMPRENOM VARCHAR(105),
    A_EPOUX_NOM VARCHAR(40),
    A_EPOUSE_NOM VARCHAR(40),
    SOSAS_EPOUX VARCHAR(30),
    SOSAS_EPOUSE VARCHAR(30))
AS
DECLARE VARIABLE MARI INTEGER;
DECLARE VARIABLE FEMME INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Dernière modification le 16/10/2007 par André, ajout champs sosas
   ---------------------------------------------------------------------------*/
     select r.REF_TU_LIBELLE,
            t.UNION_MARI,
            t.UNION_FEMME
        from T_UNION t
             inner join ref_type_union r on r.REF_TU_CODE=t.UNION_TYPE
        where t.UNION_CLEF=:ACLE_UNION
        into :A_TYPE_UNION
            ,:mari
            ,:femme;
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
           ,i.age_au_deces
           ,i.NUM_SOSA
           ,p.NOM
           ,p.PRENOM
           ,m.NOM
           ,m.PRENOM
           ,mu.MULTI_MEDIA
           ,(select sosas from proc_sosas(i.cle_fiche))
       from INDIVIDU i
         left join evenements_ind n on i.cle_fiche=n.ev_ind_kle_fiche
                                   and n.ev_ind_type='BIRT'
         left join evenements_ind d on i.cle_fiche=d.ev_ind_kle_fiche
                                   and d.ev_ind_type='DEAT'
         left join INDIVIDU p on p.cle_fiche=i.cle_pere
         left join INDIVIDU m on m.cle_fiche=i.cle_mere
         left join MEDIA_POINTEURS mp on mp.MP_CLE_INDIVIDU=i.CLE_FICHE
                                     and mp.MP_IDENTITE=1
         left join MULTIMEDIA mu on mu.MULTI_CLEF=mp.MP_MEDIA
       where i.CLE_FICHE =:mari
       into   :A_EPOUX_CLE
             ,:a_epoux_nom
             ,:A_EPOUX_NOMPRENOM
             ,:A_EPOUX_NAISSANCE
             ,:A_EPOUX_LIEU_NAISSANCE
             ,:A_EPOUX_DECES
             ,:A_EPOUX_LIEU_DECES
             ,:A_EPOUX_ANNEE
             ,:A_EPOUX_AGE_DECES
             ,:A_EPOUX_SOSA
             ,:A_EPOUX_PERE_NOM
             ,:A_EPOUX_PERE_PRENOM
             ,:A_EPOUX_MERE_NOM
             ,:A_EPOUX_MERE_PRENOM
             ,:A_EPOUX_PHOTO
             ,:sosas_epoux;
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
            i.age_au_deces,
            i.NUM_SOSA,
            p.NOM,
            p.PRENOM,
            m.NOM,
            m.PRENOM,
            mu.MULTI_MEDIA
           ,(select sosas from proc_sosas(i.cle_fiche))
       from INDIVIDU i
         left join evenements_ind n on i.cle_fiche=n.ev_ind_kle_fiche
                                   and n.ev_ind_type='BIRT'
         left join evenements_ind d on i.cle_fiche=d.ev_ind_kle_fiche
                                   and d.ev_ind_type='DEAT'
         left join INDIVIDU p on p.cle_fiche=i.cle_pere
         left join INDIVIDU m on m.cle_fiche=i.cle_mere
         left join MEDIA_POINTEURS mp on mp.MP_CLE_INDIVIDU=i.CLE_FICHE
                                     and mp.MP_IDENTITE=1
         left join MULTIMEDIA mu on mu.MULTI_CLEF=mp.MP_MEDIA
       where i.CLE_FICHE =:femme
       into   :A_EPOUSE_CLE
             ,:a_epouse_nom
             ,:A_EPOUSE_NOMPRENOM
             ,:A_EPOUSE_NAISSANCE
             ,:A_EPOUSE_LIEU_NAISSANCE
             ,:A_EPOUSE_DECES
             ,:A_EPOUSE_LIEU_DECES
             ,:A_EPOUSE_ANNEE
             ,:A_EPOUSE_AGE_DECES
             ,:A_EPOUSE_SOSA
             ,:A_EPOUSE_PERE_NOM
             ,:A_EPOUSE_PERE_PRENOM
             ,:A_EPOUSE_MERE_NOM
             ,:A_EPOUSE_MERE_PRENOM
             ,:A_EPOUSE_PHOTO
             ,:sosas_epouse;
     select nom||coalesce(', '||prenom,'') from individu where num_sosa=1
          and kle_dossier=(select first (1) kle_dossier from individu
                           where (:A_EPOUX_CLE>0 and cle_fiche=:A_EPOUX_CLE)
                             or (:a_epouse_cle>0 and cle_fiche=:a_epouse_cle))
     into :a_sosa1_nomprenom;
     suspend;
end^
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
    CLE_MERE INTEGER,
    SOSAS VARCHAR(30))
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Dernière modifications par André le 16/10/2007, refonte et ajout sosas
   Description : Permet de trouver les enfants d'un individu ou d'un couple
   ---------------------------------------------------------------------------*/
  if (A_CLE_PERE is null) then A_CLE_PERE=0;
  if (A_CLE_MERE is null) then A_CLE_MERE=0;
  if (A_CLE_MERE=0 and A_CLE_PERE=0) then exit;
  for select i.CLE_FICHE
            ,i.NOM
            ,i.PRENOM
            ,i.SEXE
            ,i.DATE_NAISSANCE
            ,i.DATE_DECES
            ,i.NUM_SOSA
            ,m.MULTI_MEDIA
            ,coalesce(n.ev_ind_ville,'')||coalesce(', '||n.ev_ind_subd,'')
                     ||coalesce(', '||n.ev_ind_dept,'')||coalesce(', '||n.ev_ind_pays,'')
            ,coalesce(d.ev_ind_ville,'')||coalesce(', '||d.ev_ind_subd,'')
                     ||coalesce(', '||d.ev_ind_dept,'')||coalesce(', '||d.ev_ind_pays,'')
            ,i.annee_naissance
            ,i.annee_deces
            ,i.age_au_deces
            ,i.cle_pere
            ,i.cle_mere
            ,(select sosas from proc_sosas(i.CLE_FICHE))
      from INDIVIDU i
         left join media_pointeurs mp on mp.MP_CLE_INDIVIDU=i.CLE_FICHE
                                     and mp.mp_identite=1
         left join MULTIMEDIA m on m.MULTI_CLEF=mp.MP_MEDIA
         left join evenements_ind n on n.ev_ind_kle_fiche=i.cle_fiche
                                   and n.ev_ind_type = 'BIRT'
         left join evenements_ind d on d.ev_ind_kle_fiche=i.cle_fiche
                                   and d.ev_ind_type = 'DEAT'
      where (:A_CLE_MERE=0 and i.CLE_PERE=:A_CLE_PERE)
            or (:A_CLE_PERE=0 and i.CLE_MERE=:A_CLE_MERE)
            or (i.CLE_PERE=:A_CLE_PERE and i.CLE_MERE=:A_CLE_MERE)
      order by i.ANNEE_NAISSANCE,n.ev_ind_date_mois,n.ev_ind_date
      into :CLE_FICHE
          ,:NOM
          ,:PRENOM
          ,:SEXE
          ,:DATE_NAISSANCE
          ,:DATE_DECES
          ,:SOSA
          ,:PHOTO
          ,:VILLE_NAISS
          ,:VILLE_DECES
          ,:ANNEE
          ,:ANNEE_DECES
          ,:AGE_DECES
          ,:CLE_PERE
          ,:CLE_MERE
          ,:sosas
  do
    suspend;
end^
commit^

alter PROCEDURE PROC_ETAT_LISTE_ALPHA (
    I_DOSSIER INTEGER,
    I_SEXE INTEGER)
RETURNS (
    NOM VARCHAR(40),
    PRENOM VARCHAR(60),
    DATE_NAISSANCE VARCHAR(100),
    CP_NAISSANCE VARCHAR(10),
    LIEU_NAISSANCE VARCHAR(50),
    DATE_DECES VARCHAR(100),
    CP_DECES VARCHAR(10),
    LIEU_DECES VARCHAR(50),
    SEXE INTEGER,
    FILLIATION VARCHAR(30),
    LETTRE VARCHAR(1),
    AGE INTEGER,
    SOSA DOUBLE PRECISION,
    CLE_FICHE INTEGER,
    SOSAS VARCHAR(30))
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée le :19/10/2007 par André, ajout SOSAS
   à : :
   par :
   Description : ramène les indis par ordre alpha de nom/prenom,
                    selon le sexe
   Usage       : I_SEXE -> sexe.  si=0, alors tous
   ---------------------------------------------------------------------------*/
   if (I_SEXE=1 or I_SEXE=2) then
   begin
   for
      select  i.nom
             ,i.prenom
             ,n.ev_ind_date_writen Naissance
             ,n.ev_ind_cp
             ,n.ev_ind_ville Lieu_Naissance
             ,d.ev_ind_date_writen Deces
             ,d.ev_ind_cp
             ,d.ev_ind_ville Lieu_Deces
             ,i.sexe
             ,i.filliation
             ,substring(i.indi_trie_nom from 1 for 1)
             ,d.ev_ind_date_year-n.ev_ind_date_year
             ,i.num_sosa
             ,i.cle_fiche
             ,(select sosas from proc_sosas(i.cle_fiche))
        from  individu i
              left join evenements_ind n on (n.ev_ind_type='BIRT'
                                             and n.ev_ind_kle_fiche=i.cle_fiche)
              left join evenements_ind d on (d.ev_ind_type='DEAT'
                                             and d.ev_ind_kle_fiche=i.cle_fiche)
        where i.kle_dossier=:I_DOSSIER
          and i.sexe=:I_SEXE
        order by i.nom,
                 i.prenom
        into  :NOM
             ,:PRENOM
             ,:DATE_NAISSANCE
             ,:CP_NAISSANCE
             ,:LIEU_NAISSANCE
             ,:DATE_DECES
             ,:CP_DECES
             ,:LIEU_DECES
             ,:SEXE
             ,:FILLIATION
             ,:LETTRE
             ,:AGE
             ,:SOSA
             ,:CLE_FICHE
             ,:sosas
   do
   suspend;
   end
   else
   begin
   for
      select  i.nom
             ,i.prenom
             ,n.ev_ind_date_writen Naissance
             ,n.ev_ind_cp
             ,n.ev_ind_ville Lieu_Naissance
             ,d.ev_ind_date_writen Deces
             ,d.ev_ind_cp
             ,d.ev_ind_ville Lieu_Deces
             ,i.sexe
             ,i.filliation
             ,substring(i.indi_trie_nom from 1 for 1)
             ,d.ev_ind_date_year-n.ev_ind_date_year
             ,i.num_sosa
             ,i.cle_fiche
             ,(select sosas from proc_sosas(i.cle_fiche))
        from  individu i
              left join evenements_ind n on (n.ev_ind_type='BIRT'
                                             and n.ev_ind_kle_fiche=i.cle_fiche)
              left join evenements_ind d on (d.ev_ind_type='DEAT'
                                             and d.ev_ind_kle_fiche=i.cle_fiche)
        where i.kle_dossier=:I_DOSSIER
        order by i.nom,
                 i.prenom
        into  :NOM
             ,:PRENOM
             ,:DATE_NAISSANCE
             ,:CP_NAISSANCE
             ,:LIEU_NAISSANCE
             ,:DATE_DECES
             ,:CP_DECES
             ,:LIEU_DECES
             ,:SEXE
             ,:FILLIATION
             ,:LETTRE
             ,:AGE
             ,:SOSA
             ,:CLE_FICHE
             ,:sosas
   do
   suspend;
   end
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
    DATE_UNION DATE,
    MARI_NUM_SOSA DOUBLE PRECISION,
    FEMME_NUM_SOSA DOUBLE PRECISION,
    CLE_MARR INTEGER,
    DATE_MARR VARCHAR(100),
    AGE_MARI INTEGER,
    AGE_FEMME INTEGER,
    AN_MARR INTEGER,
    MOIS_MARR INTEGER)
AS
DECLARE VARIABLE ANNEE_NAISSANCE_MARI INTEGER;
DECLARE VARIABLE ANNEE_NAISSANCE_FEMME INTEGER;
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée par André le : 25/10/2007 pour ne tenir compte que du premier mariage
   et ajouter champs utiles dans état des unions
   Description :
   Usage       :
   ---------------------------------------------------------------------------*/
 for
      select u.union_clef
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
        order by m.nom,m.prenom
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
     ville=null;
     pays=null;
     date_union=null;
     cle_marr=null;
     an_marr=null;
     mois_marr=null;
     date_marr=null;
     age_mari=null;
     age_femme=null;
     select first(1) ev_fam_ville
                    ,ev_fam_pays
                    ,ev_fam_date_year
                    ,ev_fam_date_mois
                    ,ev_fam_date
                    ,ev_fam_clef
                    ,ev_fam_date_writen
                    ,ev_fam_date_year-:annee_naissance_mari
                    ,ev_fam_date_year-:annee_naissance_femme
     from evenements_fam
     where ev_fam_kle_famille=:union_cle
       and ev_fam_type='MARR'
     order by ev_fam_date_year
             ,ev_fam_date_mois
             ,ev_fam_date
     into :ville
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
commit^

alter PROCEDURE PROC_ETAT_UNIONS (
    I_DOSSIER INTEGER)
RETURNS (
    UNION_CLE INTEGER,
    MARI_CLE INTEGER,
    MARI_NOM VARCHAR(40),
    MARI_PRENOM VARCHAR(60),
    MARI_NUM_SOSA DOUBLE PRECISION,
    AGE_MARI INTEGER,
    FEMME_CLE INTEGER,
    FEMME_NOM VARCHAR(40),
    FEMME_PRENOM VARCHAR(60),
    FEMME_NUM_SOSA DOUBLE PRECISION,
    AGE_FEMME INTEGER,
    VILLE VARCHAR(50),
    PAYS VARCHAR(30),
    DATE_UNION VARCHAR(100),
    SOSAS_MARI VARCHAR(30),
    SOSAS_FEMME VARCHAR(30))
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée le :25/10/2007 par André, ajout SOSAS
   Description : Cette procedure ramène les unions d'un dossier
   Usage       :
   ---------------------------------------------------------------------------*/
 for
      select p.union_cle
            ,p.mari_cle
            ,p.mari_nom
            ,p.mari_prenom
            ,p.mari_num_sosa
            ,p.age_mari
            ,p.femme_cle
            ,p.femme_nom
            ,p.femme_prenom
            ,p.femme_num_sosa
            ,p.age_femme
            ,p.ville
            ,p.pays
            ,p.date_marr
            ,(select sosas from proc_sosas(p.mari_cle))
            ,(select sosas from proc_sosas(p.femme_cle))
      from proc_liste_unions(:i_dossier) p
        into :union_cle
            ,:mari_cle
            ,:mari_nom
            ,:mari_prenom
            ,:mari_num_sosa
            ,:age_mari
            ,:femme_cle
            ,:femme_nom
            ,:femme_prenom
            ,:femme_num_sosa
            ,:age_femme
            ,:ville
            ,:pays
            ,:date_union
            ,:sosas_mari
            ,:sosas_femme
  do
    suspend;
end^
commit^

alter PROCEDURE PROC_PRENOM_PAR_NOM (
    I_NOM VARCHAR(40),
    I_DOSSIER INTEGER,
    I_MODE INTEGER,
    I_SEXE INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    PRENOM VARCHAR(100),
    DATE_NAISSANCE VARCHAR(100),
    LIEU_NAISSANCE VARCHAR(50),
    DATE_DECES VARCHAR(100),
    LIEU_DECES VARCHAR(50),
    SEXE INTEGER,
    NOM_PERE VARCHAR(40),
    PRENOM_PERE VARCHAR(60),
    PERE_DATE_NAISSANCE VARCHAR(100),
    PERE_LIEU_NAISSANCE VARCHAR(50),
    PERE_CLE_FICHE INTEGER,
    NOM_MERE VARCHAR(40),
    PRENOM_MERE VARCHAR(60),
    MERE_DATE_NAISSANCE VARCHAR(100),
    MERE_LIEU_NAISSANCE VARCHAR(50),
    MERE_CLE_FICHE INTEGER)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée par André le 22/10/2007: suppression recherche sur upper(nom) qui
   remonte plusieurs fois les individus quand des noms ne diffèrent que par la
   casse.
   Description : Cette procedure ramene tous les prenoms d'un nom
                 et pour chaque prenom, on affiche le nom du pere
   Usage       :
   ---------------------------------------------------------------------------*/
   for
      select  e.cle_fiche
             ,e.prenom
             ,n.ev_ind_date_writen
             ,n.ev_ind_ville
             ,d.ev_ind_date_writen
             ,d.ev_ind_ville
             ,e.sexe
             ,p.nom
             ,p.prenom
             ,pn.ev_ind_date_writen
             ,pn.ev_ind_ville
             ,p.cle_fiche
             ,m.nom
             ,m.prenom
             ,mn.ev_ind_date_writen
             ,mn.ev_ind_ville
             ,m.cle_fiche
         from  individu e
         left  join evenements_ind n on n.ev_ind_kle_fiche=e.cle_fiche
                                     and n.ev_ind_type='BIRT'
         left  join evenements_ind d on d.ev_ind_kle_fiche=e.cle_fiche
                                    and d.ev_ind_type='DEAT'
         left join individu p on p.cle_fiche=e.cle_pere
         left  join evenements_ind pn on pn.ev_ind_kle_fiche=p.cle_fiche
                                     and pn.ev_ind_type='BIRT'
         left join individu m on m.cle_fiche=e.cle_mere
         left  join evenements_ind mn on mn.ev_ind_kle_fiche=m.cle_fiche
                                     and mn.ev_ind_type='BIRT'
         where e.kle_dossier = :i_dossier
           and e.nom=:i_nom
           and ((d.ev_ind_date_writen is not null and :i_mode=0)
                or (d.ev_ind_date_writen is null and :i_mode=1)
                or :i_mode=2)
               and (e.sexe=:i_sexe or :i_sexe=0)
         order by e.prenom
         into :cle_fiche
             ,:prenom
             ,:date_naissance
             ,:lieu_naissance
             ,:date_deces
             ,:lieu_deces
             ,:sexe
             ,:nom_pere
             ,:prenom_pere
             ,:pere_date_naissance
             ,:pere_lieu_naissance
             ,:pere_cle_fiche
             ,:nom_mere
             ,:prenom_mere
             ,:mere_date_naissance
             ,:mere_lieu_naissance
             ,:mere_cle_fiche
   do
   suspend;
end^
commit^

ALTER PROCEDURE PROC_AGE_INDIVIDU (
    i_clef integer)
returns (
    date_deces integer,
    date_naissance integer,
    age integer)
as
declare variable date_dc date;
declare variable mois_dc integer;
begin
   /*---------------------------------------------------------------------------
   Copyright Ph Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Dernière modification par André le 14/11/2007 pour supprimer erreur de
   conversion en date si année négative.
   Description : Retourne l'âge d'un individu en jours.
   Usage       :
   ---------------------------------------------------------------------------*/
  date_deces=9999;
  select first 1
    ev_ind_date_year
   ,ev_ind_date_mois
   ,ev_ind_date
   from evenements_ind
   where ev_ind_kle_fiche=:i_clef
     and ev_ind_type='DEAT'
   into
     :date_deces
    ,:mois_dc
    ,:date_dc;
  if (date_deces=9999) then
  begin
    date_dc=current_date;
    date_deces=extract(year from current_date);
  end
  select coalesce(age,0)
        ,an_nais
  from proc_age_a_date(:i_clef,:date_dc,:mois_dc,:date_deces)
  into :age
      ,:date_naissance;
  suspend;
end^
commit^

alter PROCEDURE PROC_TROUVE_MULTIMEDIA (
    I_CLEF INTEGER,
    S_TYPE CHAR(1))
RETURNS (
    MULTI_INFOS VARCHAR(53),
    MULTI_MEDIA BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    MULTI_MEDIA_NORMALE BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    MULTI_MEMO BLOB SUB_TYPE 1 SEGMENT SIZE 80)
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:48:12
   Modifiée le :31/10/2006 par André: MULTI_TYPE ne permet plus la séparation
   entre médias pour ev_ind et médias pour ev_fam. Ajout type U.
   2/11/2007 adaptations à FB2.1.
   Description : avec S_TYPE in ('I','F') retourne les médias de l'individu I_CLEF
               : avec S_TYPE='U' retourne les médias de l'union I_CLEF
   ---------------------------------------------------------------------------*/
s_type=upper(s_type);
if (s_type in ('I','F')) then
    for select m.multi_infos
              ,m.multi_reduite
              ,m.multi_media
              ,m.multi_memo
        from (select distinct mp_media
              from media_pointeurs
              where mp_cle_individu=:i_clef) mp
        inner join multimedia m on m.multi_clef=mp.mp_media
                               and m.multi_image_rtf=0
      into :multi_infos
          ,:multi_media
          ,:multi_media_normale
          ,:multi_memo
    do suspend;
else
    for select m.multi_infos
              ,m.multi_reduite
              ,m.multi_media
              ,m.multi_memo
        from (select distinct x.mp_media
              from t_union u
              inner join media_pointeurs x on x.mp_cle_individu=u.union_mari
                                           or x.mp_cle_individu=u.union_femme
              where u.union_clef=:i_clef
              order by x.mp_cle_individu) mp
        inner join multimedia m on m.multi_clef=mp.mp_media
                               and m.multi_image_rtf=0
      into :multi_infos
          ,:multi_media
          ,:multi_media_normale
          ,:multi_memo
    do suspend;
END^
commit^

CREATE OR ALTER PROCEDURE PROC_DATE_WRITEN (
    date_writen varchar(100))
returns (
    imois integer,
    ian integer,
    ddate date,
    imois_fin integer,
    ian_fin integer,
    ddate_fin date,
    date_writen_s varchar(100),
    type_token1 integer,
    type_token2 integer,
    valide smallint)
as
declare variable jour1 integer;
declare variable mois1 integer;
declare variable an1 integer;
declare variable date1 date;
declare variable token1 varchar(30);
declare variable reste varchar(100);
declare variable idate1 integer;
declare variable jour2 integer;
declare variable mois2 integer;
declare variable an2 integer;
declare variable date2 date;
declare variable token2 varchar(30);
declare variable idate2 integer;
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
declare variable valideun smallint;
begin
/*Procédure créée par André, dernière modification 20/01/2008, ordre DMY obligatoire pour import gedcom  */
  select first(1) type_token,trim(upper(token)) --cherche ordre jour, mois, année dans TYPE_TOKEN 23
    from ref_token_date
    where type_token=23
    into :i,:ordre;
  if (ordre is null) then   /*créer TYPE_TOKEN 23, fait une seule fois*/
  begin
    ordre='DMY';
    if (i is null) then
    begin
      select max(id)+1 from ref_token_date into :i;
      i=gen_id(gen_token_date,i-gen_id(gen_token_date,0));
      insert into ref_token_date (id,type_token,langue,token)
                 values(:i,23,:langue,:ordre);
    end
    else
      update ref_token_date
      set langue=:langue,token=:ordre
      where type_token=23;
  end
  i=null;
  select first(1) type_token,trim(upper(token)) --cherche la forme LIT ou NUM dans TYPE_TOKEN 24
    from ref_token_date
    where type_token=24
    into :i,:forme;
  if (forme is null) then --créer TYPE_TOKEN 24, fait une seule fois
  begin
    forme='LIT';
    select first(1) langue
    from ref_token_date
    into :langue;
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
  select ijour,imois,ian,token,type_token,date_writen_s,valide --extrait la première date
    from proc_date_writen_un(:date_writen)
    into :jour1,:mois1,:an1,:token1,:type_token1,:reste,:valide;
  if (an1 is null) then
    begin
      date_writen_s=date_writen;
      suspend;
      exit;
    end
  if (jour1 is not null) then
     if (an1<100) then
        date1=cast(mois1||'/'||jour1||'/00'||an1 as date);
     else
        date1=cast(mois1||'/'||jour1||'/'||an1 as date);
  imois=mois1;
  ian=an1;
  ddate=date1;
  if (type_token1 in(14,15,18)) then
    begin
      imois_fin=mois1;
      ian_fin=an1;
      ddate_fin=date1;
    end
  if (type_token1 in(17,18)) then
    begin
      idate1=an1*10000+
             coalesce(mois1,0)*100+
             coalesce(jour1,0);
    end
  if (char_length(reste)>0) then --cherche deuxième date
    begin
      select ijour,imois,ian,token,type_token,valide
        from proc_date_writen_un(:reste)
        into :jour2,:mois2,:an2,:token2,:type_token2,:valideun;
      if (valideun=0) then valide=0;
      if (an2 is null) then
        begin
          date_writen_s=date_writen;
          suspend;
          exit;
        end
      if (abs(an2)<100) then
        begin
          i=cast(floor(an1/100) as integer);
          if (100*i+an2>=an1) then an2=100*i+an2;
          else an2=100*(i+1)+an2;
        end
      if (jour2 is not null) then
         if (an2<100) then
            date2=cast(mois2||'/'||jour2||'/00'||an2 as date);
         else
            date2=cast(mois2||'/'||jour2||'/'||an2 as date);
      if (type_token2 not in(13,16,17)) then
        begin
          imois_fin=mois2;
          ian_fin=an2;
          ddate_fin=date2;
        end
      if (type_token1 in(17,18) and type_token2 in(17,18)) then
        begin
          idate2=an2*10000+
             coalesce(mois2,0)*100+
             coalesce(jour2,0);
          if (idate1>idate2) then --inverser les dates de sorties
            begin
              imois=mois2;
              ian=an2;
              ddate=date2;
              i=jour2;
              imois_fin=mois1;
              ian_fin=an1;
              ddate_fin=date1;
              jour2=jour1;
              jour1=i;
              mois2=mois1;
              mois1=imois;
              an2=an1;
              an1=ian;
            end
        end
    end
  if (forme not in('LIT','NUM')) then
    begin
      date_writen_s=date_writen;
      suspend;
      exit;
    end
  if (type_token1=13 and char_length(reste)=0) then
    begin
      if (jour1 is not null) then
        select first(1) token from ref_token_date
               where type_token=:type_token1 and sous_type='D1'
               into :token;
      if (token is null and mois1 is not null) then
        select first(1) token from ref_token_date
               where type_token=:type_token1 and sous_type='M1'
               into :token;
      if (token is null and an1 is not null) then
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
  if (forme<>'NUM') then
    san=cast(an1 as varchar(5));
  else
  begin
    if (an1<0) then
    begin
      san='-';
      an1=-an1;
    end
    else
      san='';
    if (an1<10) then san=san||'00'||cast(an1 as varchar(5));
    else if (an1>=100) then san=san||cast(an1 as varchar(5));
         else san=san||'0'||cast(an1 as varchar(5));
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
           where type_token=22 
           order by id
           into :separateur;
    end
  i=0;
  while (i<3 and i<char_length(ordre)) do
    begin
      i=i +1;
      ch=substring(ordre from i for 1);
      if (i<3) then
        if (ch ='D') then
          begin
            if (sjour is not null) then date_writen_s=date_writen_s||sjour||separateur;
          end
        else if (ch='M') then
          begin
            if (smois is not null) then date_writen_s=date_writen_s||smois||separateur;
          end
            else date_writen_s=date_writen_s||san||separateur;
      else
        if (ch ='D') then
          begin
            if (sjour is not null) then date_writen_s=date_writen_s||sjour;
          end
        else if (ch='M') then
          begin
            if (smois is not null) then date_writen_s=date_writen_s||smois;
          end
            else date_writen_s=date_writen_s||san;
    end
  if (char_length(reste)=0) then --pas de deuxième date
    begin
      suspend;
      exit;
    end
  sjour=null;
  smois=null;
  san=null;
  date_writen_s=date_writen_s||' ';
  if (token2 is not null) then date_writen_s=date_writen_s||token2||' ';
  if (jour2<10 and forme='NUM') then --ajouter 0 devant
    sjour='0'||cast(jour2 as varchar(1));
  else
    sjour=cast(jour2 as varchar(2));
  if (forme<>'NUM') then
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
    if (an2<10) then san=san||'00'||cast(an2 as varchar(5));
    else if (an2>=100) then san=san||cast(an2 as varchar(5));
         else san=san||'0'||cast(an2 as varchar(5));
  end
  if (forme='LIT') then
    begin
      select first(1) token from ref_token_date
           where type_token=:mois2 
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
      i=i +1;
      ch=substring(ordre from i for 1);
      if (i<3) then
        if (ch ='D') then
          begin
            if (sjour is not null) then date_writen_s=date_writen_s||sjour||separateur;
          end
        else if (ch='M') then
          begin
            if (smois is not null) then date_writen_s=date_writen_s||smois||separateur;
          end
            else date_writen_s=date_writen_s||san||separateur;
      else
        if (ch ='D') then
          begin
            if (sjour is not null) then date_writen_s=date_writen_s||sjour;
          end
        else if (ch='M') then
          begin
            if (smois is not null) then date_writen_s=date_writen_s||smois;
          end
            else date_writen_s=date_writen_s||san;
    end
  suspend;
end^
commit^

alter trigger t_aiu_individu
active after insert or update position 0
as
declare variable s_prenom varchar(60);
begin
  if (inserting or (new.prenom is distinct from old.prenom)) then
    for select prenom from proc_eclate_prenom(new.prenom)
      where prenom is not null and prenom<>''
      into :s_prenom
      do
      begin
        insert into prenoms (prenom,sexe)
        select :s_prenom,new.sexe from rdb$database
        where not exists(select * from prenoms
                         where prenom=:s_prenom);
        if (row_count=0) then
          update prenoms set sexe=0 where prenom=:s_prenom
                                      and sexe<>0
                                      and sexe<>new.sexe;
      end
end^
commit^

alter trigger t_bi_individu_2
active before insert position 1
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
 end^
commit^

alter trigger t_bu_individu
active before update position 0
as
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 01/08/2001
   à : 05:38:03
   Modifiée le :03/05/2007 par André
   10/06/2006 suppressions corrections dues à valeurs non mises à jour par fiche individu
   par :
   Description :
   Usage       :
   ---------------------------------------------------------------------------*/
  new.date_modif = 'NOW';
  if (new.nom is distinct from old.nom) then
    select s_out from f_maj_sans_accent(new.nom)
    into new.indi_trie_nom;
end^
commit^

alter trigger t_bu_individu_2
active before update position 1
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
end^
commit^

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
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée le :23/08/2006 par André: ajout des ev_fam
   30/10/2006 restructuration pour utiliser dans fiches individuelle et familiale
   28/11/2006 ajout des naissances des enfants aux eve ind en mode I.
   Description : Cette procedure permet de récuperer tous les evements
   d'un dossier si S_MODE='D', d'un individu S_MODE='I'
   ---------------------------------------------------------------------------*/
S_MODE=upper(S_MODE);
if (S_MODE='D') then
   FOR SELECT e.EV_IND_KLE_FICHE  --évènements individuels
             ,e.EV_IND_TYPE
             ,e.EV_IND_DATE_WRITEN
             ,e.EV_IND_DATE_YEAR
             ,e.EV_IND_DATE_MOIS
             ,e.EV_IND_DATE
             ,e.EV_IND_ADRESSE
             ,e.EV_IND_CP
             ,e.EV_IND_VILLE
             ,e.EV_IND_DEPT
             ,e.EV_IND_PAYS
             ,e.EV_IND_CAUSE
             ,e.EV_IND_SOURCE
             ,e.EV_IND_COMMENT
             ,e.EV_IND_DESCRIPTION
             ,e.EV_IND_REGION
             ,e.EV_IND_SUBD
             ,r.REF_EVE_LIB_LONG
             ,e.EV_IND_INSEE
             ,i.NOM
             ,i.PRENOM
             ,cast(r.REF_EVE_LIB_LONG || ' : de ' || i.NOM || ', ' || i.PRENOM as varchar(160))
             ,i.SEXE
             ,'IND'
          FROM EVENEMENTS_IND e
               inner join INDIVIDU i on i.cle_fiche=e.EV_IND_KLE_FICHE
               inner join REF_EVENEMENTS r on r.REF_EVE_LIB_COURT=e.EV_IND_TYPE
          WHERE i.KLE_DOSSIER=:I_CLEF
       UNION all  --ev fam du mari avec nom et prénom de la femme
       SELECT u.union_mari
             ,e.EV_FAM_TYPE
             ,e.EV_FAM_DATE_WRITEN
             ,e.EV_FAM_DATE_YEAR
             ,e.EV_FAM_DATE_MOIS
             ,e.EV_FAM_DATE
             ,e.EV_FAM_ADRESSE
             ,e.EV_FAM_CP
             ,e.EV_FAM_VILLE
             ,e.EV_FAM_DEPT
             ,e.EV_FAM_PAYS
             ,e.EV_FAM_CAUSE
             ,e.EV_FAM_SOURCE
             ,e.EV_FAM_COMMENT
             ,e.EV_FAM_DESCRIPTION
             ,e.EV_FAM_REGION
             ,e.EV_FAM_SUBD
             ,r.REF_EVE_LIB_LONG
             ,e.EV_FAM_INSEE
             ,f.NOM
             ,f.PRENOM
             ,cast(SUBSTRING(r.REF_EVE_LIB_LONG||' : de '||m.NOM||', '||m.PRENOM
              ||' avec '||f.NOM||', '||f.PRENOM from 1 for 160) as varchar(160))
             ,0
             ,'FAM'
          FROM EVENEMENTS_FAM e
               inner join REF_EVENEMENTS r on r.REF_EVE_LIB_COURT=e.EV_FAM_TYPE
               inner join T_UNION u on u.UNION_CLEF=e.EV_FAM_KLE_FAMILLE
               inner join INDIVIDU m on m.cle_fiche=u.UNION_MARI
               inner join INDIVIDU f on f.cle_fiche=u.UNION_FEMME
          WHERE f.KLE_DOSSIER=:I_CLEF
       UNION all --ev fam de la femme avec nom et prénom du mari
       SELECT u.union_femme
             ,e.EV_FAM_TYPE
             ,e.EV_FAM_DATE_WRITEN
             ,e.EV_FAM_DATE_YEAR
             ,e.EV_FAM_DATE_MOIS
             ,e.EV_FAM_DATE
             ,e.EV_FAM_ADRESSE
             ,e.EV_FAM_CP
             ,e.EV_FAM_VILLE
             ,e.EV_FAM_DEPT
             ,e.EV_FAM_PAYS
             ,e.EV_FAM_CAUSE
             ,e.EV_FAM_SOURCE
             ,e.EV_FAM_COMMENT
             ,e.EV_FAM_DESCRIPTION
             ,e.EV_FAM_REGION
             ,e.EV_FAM_SUBD
             ,r.REF_EVE_LIB_LONG
             ,e.EV_FAM_INSEE
             ,m.NOM
             ,m.PRENOM
             ,cast(SUBSTRING(r.REF_EVE_LIB_LONG||' : de '||m.NOM||', '||m.PRENOM
              ||' avec '||f.NOM||', '||f.PRENOM from 1 for 160) as varchar(160))
             ,0
             ,'FAM'
          FROM EVENEMENTS_FAM e
               inner join REF_EVENEMENTS r on r.REF_EVE_LIB_COURT=e.EV_FAM_TYPE
               inner join T_UNION u on u.UNION_CLEF=e.EV_FAM_KLE_FAMILLE
               inner join INDIVIDU m on m.cle_fiche=u.UNION_MARI
               inner join INDIVIDU f on f.cle_fiche=u.UNION_FEMME
          WHERE m.KLE_DOSSIER=:I_CLEF
       UNION all --adresses
       SELECT a.ADR_KLE_IND
             ,cast('ADDR' as varchar(7))
             ,a.ADR_DATE_WRITEN
             ,a.ADR_DATE_YEAR_1
             ,a.ADR_DATE_MOIS_1
             ,a.ADR_DATE_1
             ,cast(null as varchar(50))
             ,a.ADR_CP
             ,a.ADR_VILLE
             ,a.ADR_DEPT
             ,a.ADR_PAYS
             ,cast(null as varchar(90))
             ,a.ADR_ADRESSE
             ,a.ADR_MEMO
             ,cast(null as varchar(90))
             ,a.ADR_REGION
             ,a.ADR_SUBD
             ,cast('Adresse' as varchar(30))
             ,a.ADR_INSEE
             ,i.NOM
             ,i.PRENOM
             ,cast('Adresse' || ' : de ' || i.NOM || ', ' || i.PRENOM as varchar(160))
             ,i.sexe
             ,'ADR'
          FROM adresses_ind a
               inner join INDIVIDU i on i.cle_fiche=a.ADR_KLE_IND
          WHERE a.ADR_KLE_DOSSIER=:I_CLEF
          INTO :EV_IND_KLE_FICHE
              ,:EV_IND_TYPE
              ,:EV_IND_DATE_WRITEN
              ,:EV_IND_DATE_YEAR
              ,:EV_IND_DATE_MOIS
              ,:EV_IND_DATE
              ,:EV_IND_ADRESSE
              ,:EV_IND_CP
              ,:EV_IND_VILLE
              ,:EV_IND_DEPT
              ,:EV_IND_PAYS
              ,:EV_IND_CAUSE
              ,:EV_IND_SOURCE
              ,:EV_IND_COMMENT
              ,:EV_IND_DESCRIPTION
              ,:EV_IND_REGION
              ,:EV_IND_SUBD
              ,:EV_LIBELLE
              ,:EV_IND_INSEE
              ,:NOM
              ,:PRENOM
              ,:NOM_COMPLET
              ,:SEXE
              ,:TYPE_EVENT
   do
   begin
     if (EV_IND_SOURCE is null) then
       SOURCE_VIDE=1;
     else
       SOURCE_VIDE=0;
     if (EV_IND_COMMENT is null) then
       COMMENT_VIDE=1;
     else
       COMMENT_VIDE=0;
     suspend;
   end
else   --S_MODE='I'
   FOR SELECT e.EV_IND_KLE_FICHE  --évènements individuels
             ,e.EV_IND_TYPE
             ,e.EV_IND_DATE_WRITEN
             ,e.EV_IND_DATE_YEAR
             ,e.EV_IND_DATE_MOIS
             ,e.EV_IND_DATE
             ,e.EV_IND_ADRESSE
             ,e.EV_IND_CP
             ,e.EV_IND_VILLE
             ,e.EV_IND_DEPT
             ,e.EV_IND_PAYS
             ,e.EV_IND_CAUSE
             ,e.EV_IND_SOURCE
             ,e.EV_IND_COMMENT
             ,e.EV_IND_DESCRIPTION
             ,e.EV_IND_REGION
             ,e.EV_IND_SUBD
             ,r.REF_EVE_LIB_LONG
             ,e.EV_IND_INSEE
             ,i.NOM
             ,i.PRENOM
             ,cast(r.REF_EVE_LIB_LONG || ' : de ' || i.NOM || ', ' || i.PRENOM as varchar(160))
             ,i.SEXE
             ,'IND'
          FROM EVENEMENTS_IND e
               inner join INDIVIDU i on i.cle_fiche=e.EV_IND_KLE_FICHE
               inner join REF_EVENEMENTS r on r.REF_EVE_LIB_COURT=e.EV_IND_TYPE
          WHERE e.EV_IND_KLE_FICHE=:I_CLEF
       UNION all  --ev fam du mari avec nom et prénom de la femme
       SELECT u.union_mari
             ,e.EV_FAM_TYPE
             ,e.EV_FAM_DATE_WRITEN
             ,e.EV_FAM_DATE_YEAR
             ,e.EV_FAM_DATE_MOIS
             ,e.EV_FAM_DATE
             ,e.EV_FAM_ADRESSE
             ,e.EV_FAM_CP
             ,e.EV_FAM_VILLE
             ,e.EV_FAM_DEPT
             ,e.EV_FAM_PAYS
             ,e.EV_FAM_CAUSE
             ,e.EV_FAM_SOURCE
             ,e.EV_FAM_COMMENT
             ,e.EV_FAM_DESCRIPTION
             ,e.EV_FAM_REGION
             ,e.EV_FAM_SUBD
             ,r.REF_EVE_LIB_LONG
             ,e.EV_FAM_INSEE
             ,f.NOM
             ,f.PRENOM
             ,cast(SUBSTRING(r.REF_EVE_LIB_LONG||' : de '||m.NOM||', '||m.PRENOM
              ||' avec '||f.NOM||', '||f.PRENOM from 1 for 160) as varchar(160))
             ,0
             ,'FAM'
          FROM EVENEMENTS_FAM e
               inner join REF_EVENEMENTS r on r.REF_EVE_LIB_COURT=e.EV_FAM_TYPE
               inner join T_UNION u on u.UNION_CLEF=e.EV_FAM_KLE_FAMILLE
               inner join INDIVIDU m on m.cle_fiche=u.UNION_MARI
               inner join INDIVIDU f on f.cle_fiche=u.UNION_FEMME
          WHERE u.UNION_MARI=:I_CLEF
       UNION all --ev fam de la femme avec nom et prénom du mari
       SELECT u.union_femme
             ,e.EV_FAM_TYPE
             ,e.EV_FAM_DATE_WRITEN
             ,e.EV_FAM_DATE_YEAR
             ,e.EV_FAM_DATE_MOIS
             ,e.EV_FAM_DATE
             ,e.EV_FAM_ADRESSE
             ,e.EV_FAM_CP
             ,e.EV_FAM_VILLE
             ,e.EV_FAM_DEPT
             ,e.EV_FAM_PAYS
             ,e.EV_FAM_CAUSE
             ,e.EV_FAM_SOURCE
             ,e.EV_FAM_COMMENT
             ,e.EV_FAM_DESCRIPTION
             ,e.EV_FAM_REGION
             ,e.EV_FAM_SUBD
             ,r.REF_EVE_LIB_LONG
             ,e.EV_FAM_INSEE
             ,m.NOM
             ,m.PRENOM
             ,cast(SUBSTRING(r.REF_EVE_LIB_LONG||' : de '||m.NOM||', '||m.PRENOM
              ||' avec '||f.NOM||', '||f.PRENOM from 1 for 160) as varchar(160))
             ,0
             ,'FAM'
          FROM EVENEMENTS_FAM e
               inner join REF_EVENEMENTS r on r.REF_EVE_LIB_COURT=e.EV_FAM_TYPE
               inner join T_UNION u on u.UNION_CLEF=e.EV_FAM_KLE_FAMILLE
               inner join INDIVIDU m on m.cle_fiche=u.UNION_MARI
               inner join INDIVIDU f on f.cle_fiche=u.UNION_FEMME
          WHERE u.UNION_FEMME=:I_CLEF
       UNION all --adresses
       SELECT a.ADR_KLE_IND
             ,cast('ADDR' as varchar(7))
             ,a.ADR_DATE_WRITEN
             ,a.ADR_DATE_YEAR_1
             ,a.ADR_DATE_MOIS_1
             ,a.ADR_DATE_1
             ,cast(null as varchar(50))
             ,a.ADR_CP
             ,a.ADR_VILLE
             ,a.ADR_DEPT
             ,a.ADR_PAYS
             ,cast(null as varchar(90))
             ,a.ADR_ADRESSE
             ,a.ADR_MEMO
             ,cast(null as varchar(90))
             ,a.ADR_REGION
             ,a.ADR_SUBD
             ,cast('Adresse' as varchar(30))
             ,a.ADR_INSEE
             ,i.NOM
             ,i.PRENOM
             ,cast('Adresse' || ' : de ' || i.NOM || ', ' || i.PRENOM as varchar(160))
             ,i.sexe
             ,'ADR'
          FROM adresses_ind a
               inner join INDIVIDU i on i.cle_fiche=a.ADR_KLE_IND
          WHERE a.ADR_KLE_IND=:I_CLEF
       UNION all  --ev ind de l'enfant dont l'individu est le père
       SELECT e.cle_fiche
             ,ev.EV_IND_TYPE
             ,ev.EV_IND_DATE_WRITEN
             ,ev.EV_IND_DATE_YEAR
             ,ev.EV_IND_DATE_MOIS
             ,ev.EV_IND_DATE
             ,ev.EV_IND_ADRESSE
             ,ev.EV_IND_CP
             ,ev.EV_IND_VILLE
             ,ev.EV_IND_DEPT
             ,ev.EV_IND_PAYS
             ,ev.EV_IND_CAUSE
             ,ev.EV_IND_SOURCE
             ,ev.EV_IND_COMMENT
             ,ev.EV_IND_DESCRIPTION
             ,ev.EV_IND_REGION
             ,ev.EV_IND_SUBD
             ,cast('Naissance enfant' as varchar(30))
             ,ev.EV_IND_INSEE
             ,e.NOM
             ,e.PRENOM
             ,cast(SUBSTRING('Naissance de '||e.NOM||', '||e.PRENOM
              ||coalesce('. Mère : '||m.NOM||', '||m.PRENOM,'') from 1 for 160) as varchar(160))
             ,e.sexe
             ,'ENF'
          FROM individu e
               left join evenements_ind ev on ev.ev_ind_kle_fiche=e.cle_fiche
                                            and ev.ev_ind_type='BIRT'
               left join INDIVIDU m on m.cle_fiche=e.cle_mere
          WHERE e.cle_pere=:I_CLEF
       UNION all --ev ind de l'enfant dont l'individu est la mère
       SELECT e.cle_fiche
             ,ev.EV_IND_TYPE
             ,ev.EV_IND_DATE_WRITEN
             ,ev.EV_IND_DATE_YEAR
             ,ev.EV_IND_DATE_MOIS
             ,ev.EV_IND_DATE
             ,ev.EV_IND_ADRESSE
             ,ev.EV_IND_CP
             ,ev.EV_IND_VILLE
             ,ev.EV_IND_DEPT
             ,ev.EV_IND_PAYS
             ,ev.EV_IND_CAUSE
             ,ev.EV_IND_SOURCE
             ,ev.EV_IND_COMMENT
             ,ev.EV_IND_DESCRIPTION
             ,ev.EV_IND_REGION
             ,ev.EV_IND_SUBD
             ,cast('Naissance enfant' as varchar(30))
             ,ev.EV_IND_INSEE
             ,e.NOM
             ,e.PRENOM
             ,cast(SUBSTRING('Naissance de '||e.NOM||', '||e.PRENOM
              ||coalesce('. Père : '||p.NOM||', '||p.PRENOM,'') from 1 for 160) as varchar(160))
             ,e.sexe
             ,'ENF'
          FROM individu e
               left join evenements_ind ev on ev.ev_ind_kle_fiche=e.cle_fiche
                                            and ev.ev_ind_type='BIRT'
               left join INDIVIDU p on p.cle_fiche=e.cle_pere
          WHERE e.cle_mere=:I_CLEF
          INTO :EV_IND_KLE_FICHE
              ,:EV_IND_TYPE
              ,:EV_IND_DATE_WRITEN
              ,:EV_IND_DATE_YEAR
              ,:EV_IND_DATE_MOIS
              ,:EV_IND_DATE
              ,:EV_IND_ADRESSE
              ,:EV_IND_CP
              ,:EV_IND_VILLE
              ,:EV_IND_DEPT
              ,:EV_IND_PAYS
              ,:EV_IND_CAUSE
              ,:EV_IND_SOURCE
              ,:EV_IND_COMMENT
              ,:EV_IND_DESCRIPTION
              ,:EV_IND_REGION
              ,:EV_IND_SUBD
              ,:EV_LIBELLE
              ,:EV_IND_INSEE
              ,:NOM
              ,:PRENOM
              ,:NOM_COMPLET
              ,:SEXE
              ,:TYPE_EVENT
   do
   begin
     if (EV_IND_SOURCE is null) then
       SOURCE_VIDE=1;
     else
       SOURCE_VIDE=0;
     if (EV_IND_COMMENT is null) then
       COMMENT_VIDE=1;
     else
       COMMENT_VIDE=0;
     suspend;
   end
end^
commit^

alter procedure proc_trouve_notes (
    idossier integer,
    ssource varchar(20))
returns (
    ev_ind_source blob sub_type 1 segment size 80,
    nom varchar(40),
    prenom varchar(60),
    ev_ind_kle_fiche integer,
    ev_ind_cp varchar(10),
    ev_ind_ville varchar(50),
    ou_ca varchar(7),
    sexe integer)
as
begin
  for /* D'abord la NOTE des Evenements INDI */
    select eve.ev_ind_comment,
           indi.nom,
           indi.prenom,
           eve.ev_ind_kle_fiche,
           eve.ev_ind_cp,
           eve.ev_ind_ville,
           ev_ind_type as ou_ca,
           indi.sexe
    from individu indi,
         evenements_ind eve
    where  ev_ind_kle_dossier = :idossier and
           ev_ind_comment containing :ssource and
           indi.cle_fiche = eve.ev_ind_kle_fiche
union all /* Ici c'est la NOTE des Evenements FAM */
    select fam.ev_fam_comment,
           indi.nom,
           indi.prenom,
           indi.cle_fiche,
           fam.ev_fam_cp,
           fam.ev_fam_ville,
           ev_fam_type as ou_ca,
           indi.sexe
    from t_union
         left join evenements_fam fam on (fam.ev_fam_kle_famille = t_union.union_clef)
         left join individu indi on (indi.cle_fiche = t_union.union_mari)
    where  t_union.kle_dossier =  :idossier and
           fam.ev_fam_comment containing :ssource
union all /* Ici c'est la NOTE de l'UNION */
    select t_union.comment,
           indi.nom,
           indi.prenom,
           indi.cle_fiche,
           cast('' as varchar(10)),
           cast('' as varchar(50)),
           cast('UNION' as varchar(7)) as ou_ca,
           indi.sexe
    from individu indi
         inner join t_union on (indi.kle_dossier = t_union.kle_dossier) and
         indi.cle_fiche = t_union.union_mari
    where  indi.kle_dossier =  : idossier and
           t_union.comment containing :ssource
union all /* Ici c'est l'onglet INFO */
    select indi.comment,
           indi.nom,
           indi.prenom,
           indi.cle_fiche,
           cast('' as varchar(10)),
           cast('' as varchar(50)),
           cast('INFO' as varchar(7)) as ou_ca,
           indi.sexe
    from  individu indi
    where  indi.kle_dossier = :idossier and
           indi.comment containing :ssource

    into
      :ev_ind_source,
      :nom,
      :prenom,
      :ev_ind_kle_fiche,
      :ev_ind_cp,
      :ev_ind_ville,
      :ou_ca,
      :sexe
  do
  begin
    suspend;
  end
end^
commit^

alter procedure proc_trouve_source (
    idossier integer,
    ssource varchar(20))
returns (
    ev_ind_source blob sub_type 1 segment size 80,
    nom varchar(40),
    prenom varchar(60),
    ev_ind_kle_fiche integer,
    ev_ind_cp varchar(10),
    ev_ind_ville varchar(50),
    ou_ca varchar(7),
    sexe integer)
as
begin
  for /* D'abord la NOTE des Evenements INDI */
    select eve.ev_ind_source,
           indi.nom,
           indi.prenom,
           eve.ev_ind_kle_fiche,
           eve.ev_ind_cp,
           eve.ev_ind_ville,
           ev_ind_type as ou_ca,
           indi.sexe
    from individu indi,
         evenements_ind eve
    where  ev_ind_kle_dossier = :idossier and
           ev_ind_source containing :ssource and
           indi.cle_fiche = eve.ev_ind_kle_fiche
union all /* Ici c'est la NOTE des Evenements FAM */
    select fam.ev_fam_source,
           indi.nom,
           indi.prenom,
           indi.cle_fiche,
           fam.ev_fam_cp,
           fam.ev_fam_ville,
           ev_fam_type as ou_ca,
           indi.sexe
    from t_union
         left join evenements_fam fam on (fam.ev_fam_kle_famille = t_union.union_clef)
         left join individu indi on (indi.cle_fiche = t_union.union_mari)
    where  t_union.kle_dossier =  :idossier and
           fam.ev_fam_source containing :ssource
union all /* Ici c'est la NOTE de l'UNION */
    select t_union.source,
           indi.nom,
           indi.prenom,
           indi.cle_fiche,
           cast('' as varchar(10)),
           cast('' as varchar(50)),
           cast('UNION' as varchar(7)) as ou_ca,
           indi.sexe
    from individu indi
         inner join t_union on (indi.kle_dossier = t_union.kle_dossier) and
         indi.cle_fiche = t_union.union_mari
    where  indi.kle_dossier =  : idossier and
           t_union.source containing :ssource
union all /* Ici c'est l'onglet INFO */
    select indi.source,
           indi.nom,
           indi.prenom,
           indi.cle_fiche,
           cast('' as varchar(10)),
           cast('' as varchar(50)),
           cast('INFO' as varchar(7)) as ou_ca,
           indi.sexe
    from  individu indi
    where  indi.kle_dossier = :idossier and
           indi.source containing :ssource

    into
      :ev_ind_source,
      :nom,
      :prenom,
      :ev_ind_kle_fiche,
      :ev_ind_cp,
      :ev_ind_ville,
      :ou_ca,
      :sexe
  do
  begin
    suspend;
  end
end^
commit^

CREATE OR ALTER PROCEDURE GET_CLE_UNION (
    cle_dossier integer,
    cle_mari integer,
    cle_femme integer)
returns (
    cle_union integer)
as
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   Modifiée par André le 25/11/2007: utilisation distinct
   ---------------------------------------------------------------------------*/
   if (cle_mari=0) then cle_mari=null;
   if (cle_femme=0) then cle_femme=null;
   select union_clef
   from t_union
   where union_mari is not distinct from :cle_mari
     and union_femme is not distinct from :cle_femme
   into :cle_union;
   if (cle_union is null) then cle_union=-1;
   suspend;
end^
commit^

CREATE OR ALTER PROCEDURE F_MAJ (
    s_in varchar(255))
returns (
    s_out varchar(255))
as
begin
  S_OUT=UPPER(S_IN)collate FR_CA;
  suspend;
end^
commit^

alter PROCEDURE PROC_ANNIVERSAIRES (
    A_MOIS INTEGER,
    I_MODE INTEGER,
    I_DOSSIER INTEGER)
RETURNS (
    CLE_FICHE INTEGER,
    NOM VARCHAR(60),
    PRENOM VARCHAR(100),
    DATE_NAISSANCE DATE,
    DATE_DECES VARCHAR(100),
    SEXE INTEGER,
    JOUR VARCHAR(2),
    AGE INTEGER)
AS
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 17:48:27
   Dernières modifications par André le 25/11/2007: utilisation i.decede
   Description : Cette procedure remonte les données des individus
   Usage       :
   A_MOIS : est le mois qu'on cherche
   I_MODE :0 seulement les vivants - 1 avec les morts
   I_DOSSIER : Le dossier concerné
   ---------------------------------------------------------------------------*/
for  select i.cle_fiche
           ,i.nom
           ,i.prenom
           ,n.ev_ind_date
           ,i.date_deces
           ,i.sexe
           ,extract(day from n.ev_ind_date)
           ,extract(year from current_date)-n.ev_ind_date_year
     from evenements_ind n
     inner join individu i on i.cle_fiche=n.ev_ind_kle_fiche
     where n.ev_ind_type='BIRT'
       and n.ev_ind_date_mois=:a_mois
       and n.ev_ind_date is not null
       and (:i_mode=1
            or (i.decede is null
                and n.ev_ind_date_year>(extract(year from  current_date)-110)))
       and i.kle_dossier=:i_dossier
     order by 7,4
     into :cle_fiche
         ,:nom
         ,:prenom
         ,:date_naissance
         ,:date_deces
         ,:sexe
         ,:jour
         ,:age
do
   suspend; 
end^
commit^

alter PROCEDURE PROC_DELETE_UNION (
    I_CLEF INTEGER)
RETURNS (
    COMBIEN INTEGER)
AS
BEGIN
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 18:12:56
   Modifiée le : 24/10/2005 par André, simplification, suppression erreur
   provoquant la suppression d'évènements familiaux d'une autre union.
   correction 25/11/2007: ne pouvait supprimer union si un seul parent
   par :
   Description : Supprime une union s'il n'y a pas d'enfants
   Usage       :
   ---------------------------------------------------------------------------*/
   DELETE FROM T_UNION t
   WHERE t.UNION_CLEF=:I_CLEF
     and not exists(select *
                    from t_union u
                    inner join individu i
                     on i.cle_pere is not distinct from u.union_mari
                    and i.cle_mere is not distinct from u.union_femme
                    WHERE u.UNION_CLEF=t.UNION_CLEF);
   if (row_count>0) then
     combien=0;
   else
     combien=1;
   suspend;
END^
commit^

alter PROCEDURE PROC_EXPORT_IMAGES (
    I_DOSSIER INTEGER)
RETURNS (
    MULTI_CLEF INTEGER,
    NOM VARCHAR(105),
    MULTI_MEDIA BLOB SUB_TYPE 0 SEGMENT SIZE 80,
    FORMAT VARCHAR(4),
    MULTI_PATH VARCHAR(255))
AS
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
END^
commit^

create or alter PROCEDURE PROC_TROUVE_VILLE_PAR_CP (
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
   Modifiée le :2/12/2007 par André, ajout CP_NOM_HABITANTS+utilisation index
   sur cp_cp par suppression upper (cp_cp)
   Description : Cette procedure permets de remonter les infos desc tables de ref
   pour un code postal
   Usage       :
   ---------------------------------------------------------------------------*/
  for select v.cp_ville
            ,d.rdp_tel
            ,d.rdp_libelle
            ,r.rrg_libelle
            ,p.rpa_libelle
            ,v.cp_cp
            ,v.cp_code
            ,v.cp_prefixe
            ,v.cp_dept
            ,v.cp_region
            ,v.cp_pays
            ,v.cp_insee
            ,v.cp_habitants
            ,v.cp_densite
            ,v.cp_divers
            ,v.cp_longitude
            ,v.cp_latitude
            ,v.cp_nom_habitants
      from  ref_cp_ville v
      left join ref_departements d on d.rdp_code = v.cp_dept
      left join ref_region r on r.rrg_code = v.cp_region
      left join ref_pays p on p.rpa_code = v.cp_pays
      where v.cp_cp starting with upper(:i_code)
         or v.cp_cp starting with lower(:i_code)
      order by v.cp_ville collate FR_FR
      into :ville
          ,:tel
          ,:departement
          ,:region
          ,:pays
          ,:code
          ,:clef
          ,:cp_prefixe
          ,:cp_dept
          ,:cp_region
          ,:cp_pays
          ,:cp_insee
          ,:cp_habitants
          ,:cp_densite
          ,:cp_divers
          ,:cp_longitude
          ,:cp_latitude
          ,:cp_nom_habitants
  do
  suspend;
end^
commit^

CREATE OR ALTER TRIGGER EVENEMENTS_IND_AIU FOR EVENEMENTS_IND
ACTIVE AFTER INSERT OR UPDATE POSITION 1
AS
begin
  delete from sources_record s
  where char_length(new.ev_ind_source)=0
    and s.data_id=new.ev_ind_clef
    and s.type_table='I'
    and char_length(s.auth)=0
    and char_length(s.titl)=0
    and char_length(s.abr)=0
    and char_length(s.publ)=0
    and not exists(select * from media_pointeurs p
                   where p.mp_table='F'
                     and p.mp_type_image='F'
                     and p.mp_pointe_sur=s.id);
  if (row_count=0) then
  begin
    update sources_record s
    set s.texte=new.ev_ind_source
    where s.data_id=new.ev_ind_clef and s.type_table='I';
    if ((row_count=0) and (char_length(new.ev_ind_source)>0)) then
      insert into sources_record (id
                                 ,data_id
                                 ,texte
                                 ,change_date
                                 ,kle_dossier
                                 ,type_table)
                           values(gen_id(sources_record_id_gen,1)
                                 ,new.ev_ind_clef
                                 ,new.ev_ind_source
                                 ,current_timestamp
                                 ,new.ev_ind_kle_dossier
                                 ,'I');
  end
end^
commit^

COMMENT ON TRIGGER EVENEMENTS_IND_AIU IS 
'Permet l''enregistrement du champ Sources de l''événement dans un enregistrement
de SOURCES_RECORD.'^
commit^

CREATE OR ALTER TRIGGER TAI_EVENEMENTS_FAM FOR EVENEMENTS_FAM
ACTIVE AFTER INSERT OR UPDATE POSITION 0
as
begin
  update sources_record s
  set s.texte=new.ev_fam_source
  where s.data_id=new.ev_fam_clef and s.type_table='F';
  if (row_count=0) then
    insert into sources_record (id
                               ,data_id
                               ,texte
                               ,change_date
                               ,kle_dossier
                               ,type_table)
                         values(gen_id(sources_record_id_gen,1)
                               ,new.ev_fam_clef
                               ,new.ev_fam_source
                               ,current_timestamp
                               ,new.ev_fam_kle_dossier
                               ,'F');
END^
commit^

COMMENT ON TRIGGER TAI_EVENEMENTS_FAM IS 
'Création par André pour fonctionnement média (01/10/05)
Le doublement de l''enregistrement dans MEDIA_POINTEURS
pour le conjoint ne fonctionne pas si l''enregistrement
de l''évènement familial dans SOURCES_RECORD n''existe pas.
Ne sera plus nécessaire le jour où le programme créera
l''enregistrement dans SOURCES_RECORD avant celui dans
MEDIA_POINTEURS que si le champ Sources de l''événement n''est pas vide'^
commit^

CREATE OR ALTER TRIGGER SOURCES_RECORD_BI0 FOR SOURCES_RECORD
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  delete from sources_record
  where data_id=new.data_id
    and type_table=new.type_table;
end^
commit^

--mise à jour du champ TEXTE de SOURCES_RECORD avec le contenu de SOURCE des événements
execute block as
declare variable clef_eve integer;
declare variable dossier integer;
declare variable texte_source blob SUB_TYPE 1 SEGMENT SIZE 80;
begin
for select ev_fam_clef,ev_fam_kle_dossier,ev_fam_source
from evenements_fam
into :clef_eve,:dossier,:texte_source
do
begin
    update sources_record s
    set s.texte=:texte_source
    where s.data_id=:clef_eve and s.type_table='F';
    if (row_count=0 and char_length(:texte_source)>0) then
      insert into sources_record (id
                                  ,data_id
                                  ,texte
                                  ,change_date
                                  ,kle_dossier
                                  ,type_table)
                            values(gen_id(sources_record_id_gen,1)
                                  ,:clef_eve
                                  ,:texte_source
                                  ,current_timestamp
                                  ,:dossier
                                  ,'F');
end
for select ev_ind_clef,ev_ind_kle_dossier,ev_ind_source
from evenements_ind
into :clef_eve,:dossier,:texte_source
do
begin
    update sources_record s
    set s.texte=:texte_source
    where s.data_id=:clef_eve and s.type_table='I';
    if (row_count=0 and char_length(:texte_source)>0) then
      insert into sources_record (id
                                  ,data_id
                                  ,texte
                                  ,change_date
                                  ,kle_dossier
                                  ,type_table)
                            values(gen_id(sources_record_id_gen,1)
                                  ,:clef_eve
                                  ,:texte_source
                                  ,current_timestamp
                                  ,:dossier
                                  ,'I');
end
end^
commit^

CREATE OR ALTER PROCEDURE PROC_INCOHERENCES (
    i_kle_dossier integer,
    i_mode integer)
returns (
    o_table varchar(30),
    o_cle_table integer,
    o_cle_fiche integer,
    o_libelle varchar(160))
as
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
   Description : Renvoie les individus de nom passé en paramètre
   Usage       : I_MODE = 0 : Consultation
                 I_MODE = 1 : Mise à jour
                 I_MODE=2 : Mise à jour sans messages
   ---------------------------------------------------------------------------*/
  o_libelle='Adresse pointant sur un individu inexistant';
  o_table='ADRESSES_IND';
  for select a.adr_clef,a.adr_kle_ind
  from adresses_ind a
  where not exists (select * from individu b
                    where b.kle_dossier=a.adr_kle_dossier
                      and b.cle_fiche = a.adr_kle_ind)
  into :o_cle_table, :o_cle_fiche
    do
    begin
      if (i_mode<2) then suspend;
      if (i_mode>0) then begin
        delete from adresses_ind
        where adr_clef=:o_cle_table;
    end
  end

  o_libelle='Evénement individuel pointant sur un individu inexistant ou sans type';
  o_table='EVENEMENT_IND';
  for select a.ev_ind_clef,a.ev_ind_kle_fiche from evenements_ind a
  where not exists (select * from individu b
                    where b.kle_dossier=a.ev_ind_kle_dossier
                      and b.cle_fiche=a.ev_ind_kle_fiche)
     or not exists (select * from ref_evenements
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
        where u.union_clef=:o_table;
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
        where u.union_clef=:o_table;
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
  and    not exists (
    select * from individu b
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
  and    not exists (
    select * from individu b
    where  b.kle_dossier = :i_kle_dossier
    and    b.cle_fiche = a.union_femme
  )
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
  where not exists (select * from individu b
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

  o_libelle='Associé d''une association pointant sur un individu inexistant';
  o_table='T_ASSOCIATIONS';
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

  o_libelle='Evénement familial pointant sur une union inexistante ou sans type';
  o_table='EVENEMENTS_FAM';
  for select a.ev_fam_clef, a.ev_fam_kle_famille from evenements_fam a
  where not exists (select * from t_union b
                    where b.kle_dossier=a.ev_fam_kle_dossier
                      and b.union_clef = a.ev_fam_kle_famille)
     or not exists (select * from ref_evenements
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

  o_libelle='Association pointant sur un événement individuel inexistant';
  o_table='T_ASSOCIATIONS';
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
    and not exists (select * from evenements_ind e
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
    and not exists (select * from evenements_fam e
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
commit^

CREATE OR ALTER PROCEDURE PROC_COMPTE_ONGLETS (
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
             inner join T_UNION u on (u.UNION_MARI=:ICLEF)
                                  or (u.UNION_FEMME=:ICLEF)
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

CREATE OR ALTER PROCEDURE PROC_LISTE_PRENOM (
    I_DOSSIER INTEGER)
RETURNS (
    PRENOM VARCHAR(60),
    SEXE INTEGER,
    CLE_FICHE INTEGER,
    NOM VARCHAR(40),
    PRENOM_COMPLET VARCHAR(60),
    CLE_PERE INTEGER,
    CLE_MERE INTEGER,
    DATE_NAISSANCE VARCHAR(100),
    ANNEE_NAISSANCE INTEGER)
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
commit^

CREATE OR ALTER TRIGGER T_REF_TOKEN_DATE_BUI FOR REF_TOKEN_DATE
ACTIVE BEFORE INSERT OR UPDATE POSITION 0
AS
begin
  NEW.SOUS_TYPE=UPPER(NEW.SOUS_TYPE);
  if (new.id is null) then
    new.id=gen_id(gen_token_date,1);
end^
commit^

execute block
as
declare variable id integer;
begin
select first(1) id from ref_token_date
where langue='FRA' and type_token=1 and token='JAN'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',1,'JAN');

select first(1) id from ref_token_date
where langue='FRA' and type_token=2 and token='FEB'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',2,'FEB');

select first(1) id from ref_token_date
where langue='FRA' and type_token=3 and token='MAR'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',3,'MAR');

select first(1) id from ref_token_date
where langue='FRA' and type_token=4 and token='APR'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',4,'APR');

select first(1) id from ref_token_date
where langue='FRA' and type_token=5 and token='MAY'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',5,'MAY');

select first(1) id from ref_token_date
where langue='FRA' and type_token=6 and token='JUN'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',6,'JUN');

select first(1) id from ref_token_date
where langue='FRA' and type_token=7 and token='JUL'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',7,'JUL');

select first(1) id from ref_token_date
where langue='FRA' and type_token=8 and token='AUG'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',8,'AUG');

select first(1) id from ref_token_date
where langue='FRA' and type_token=9 and token='SEP'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',9,'SEP');

select first(1) id from ref_token_date
where langue='FRA' and type_token=10 and token='OCT'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',10,'OCT');

select first(1) id from ref_token_date
where langue='FRA' and type_token=11 and token='NOV'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',11,'NOV');

select first(1) id from ref_token_date
where langue='FRA' and type_token=12 and token='DEC'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',12,'DEC');

select first(1) id from ref_token_date
where langue='FRA' and type_token=13 and token='FROM'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',13,'FROM');

select first(1) id from ref_token_date
where langue='FRA' and type_token=14 and token='TO'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',14,'TO');

select first(1) id from ref_token_date
where langue='FRA' and type_token=15 and token='BEF'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',15,'BEF');

select first(1) id from ref_token_date
where langue='FRA' and type_token=16 and token='AFT'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',16,'AFT');

select first(1) id from ref_token_date
where langue='FRA' and type_token=17 and token='BET'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',17,'BET');

select first(1) id from ref_token_date
where langue='FRA' and type_token=18 and token='AND'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',18,'AND');

select first(1) id from ref_token_date
where langue='FRA' and type_token=19 and token='CAL'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',19,'CAL');

select first(1) id from ref_token_date
where langue='FRA' and type_token=20 and token='EST'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',20,'EST');

select first(1) id from ref_token_date
where langue='FRA' and type_token=21 and token='ABT'
into :id;
if (id is null) then
    insert into ref_token_date (langue,type_token,token) values('FRA',21,'ABT');
end^
commit^

update media_pointeurs
set mp_type_image='I'
where mp_type_image is null^
commit^

update ref_region
set rrg_libelle='Wallonie'
where upper(rrg_libelle)='WALLONNIE'^
commit^

update adresses_ind
set adr_region='Wallonie'
where upper(adr_region)='WALLONNIE'^
commit^

update evenements_fam
set ev_fam_region='Wallonie'
where upper(ev_fam_region)='WALLONNIE'^
commit^

update evenements_ind
set ev_ind_region='Wallonie'
where upper(ev_ind_region)='WALLONNIE'^
commit^

update version_dll --pour empêcher le BOA de modifier les procédures LR
set version=3
where nom_dll='BOA'^
commit^

CREATE OR ALTER PROCEDURE PROC_SUPPRESSION_FILIATION (
    i_kle_dossier integer,
    i_individu integer,
    i_mode integer)
as
declare variable pere integer;
declare variable mere integer;
declare variable compte integer;
begin
   /*---------------------------------------------------------------------------
   Copyright Laurent Robbe. Tout droits réservés.
   Créé le : 31/05/2003
   à : 11:54:11
   Modifiée le : 26/01/2008 par André optimisation
   à : :
   par :
   Description : Supprime le lien d'un individu avec son père et/ou sa mère
                 et si seul un des 2 parents était connu et que ce parent seul n'avait 
                    pas d'autre enfant de conjoint non identifié : suppression de l'union
                    du parent seul
   Usage       : I_MODE = 0 : détacher le père et la mère
                 I_MODE = 1 : détacher le père
                 I_MODE = 2 : détacher la mère
   ---------------------------------------------------------------------------*/
  select a.cle_pere, a.cle_mere from individu a
  where  a.kle_dossier = :i_kle_dossier
  and    a.cle_fiche   = :i_individu
  into   :pere, :mere;

  /* Etape 1 : Mise à jour de la fiche individu */
    if (i_mode = 0) then
      update individu a
      set cle_pere = null,cle_mere=null
      where  a.kle_dossier = :i_kle_dossier
      and    a.cle_fiche   = :i_individu;
    else
    if (i_mode = 1) then
      update individu a
      set cle_pere = null
      where  a.kle_dossier = :i_kle_dossier
      and    a.cle_fiche   = :i_individu;
    else
    if (i_mode = 2) then
      update individu a
      set cle_mere = null
      where  a.kle_dossier = :i_kle_dossier
      and    a.cle_fiche   = :i_individu;

  /* Etape 2 : suppression des unions fictives si besoin.
     Pour les pères (resp. mères) seuls (resp. seules) (i.e. dont le conjoint n'est
     pas créé dans la base), une union fictive est créée dans la table T_UNION 
     avec cle_pere (resp. cle_mere) renseigné et cle_mere (resp. cle_pere) à NULL.
     Si un parent seul a plusieurs enfants, cette union fictive ne doit être créée 
     qu'une seule fois.
     En conséquence, si l'on supprime le lien de filiation entre un parent seul et 
     son dernier enfant, il faut supprimer aussi l'union fictive. S'il reste des
     enfants, il ne faut pas la supprimer.
  */
  
    /* Cas détachement du père */
    if ((i_mode=0 or i_mode=1) and (pere is not null) and (mere is null)) then
    begin
        /* existe-t-il d'autres individus avec ce père seul ? */
        compte=0;
        select 1 from rdb$database where exists
        (select * from individu b
        where  b.kle_dossier = :i_kle_dossier
        and    b.cle_pere    = :pere
        and    b.cle_mere    is null)
        into :compte;
        if (compte<1) then
          /* suppression de l'union (un parent unique ==> pas d'événement union réel
             mais juste un enregistrement pour faire le lien avec l'enfant */
          delete from t_union c
            where c.union_mari  = :pere
            and   c.union_femme is null;
    end
    /* Cas détachement de la mère */
    if ((i_mode=0 or i_mode=2) and (mere is not null) and (pere is null)) then
    begin
        /* existe-t-il d'autres individus avec cette mère seule ? */
        compte=0;
        select 1 from rdb$database where exists
        (select * from individu b
        where  b.kle_dossier = :i_kle_dossier
        and    b.cle_mere    = :mere
        and    b.cle_pere    is null)
        into :compte;
        if (compte<1) then
          /* suppression de l'union (un parent unique ==> pas d'événement union réel
             mais juste un enregistrement pour faire le lien avec l'enfant */
          delete from t_union c
            where c.union_femme = :mere
            and   c.union_mari  is null;
    end

  /* Etape 3 : Création d'une union fictive si besoin */
  /* Si père et mère présents et détachement d'un seul, création d'une union fictive si besoin */
    if ((pere is not null) and (mere is not null)) then
    begin
      if (i_mode = 1) then
      begin
        compte=0;
        select 1 from rdb$database where exists
        (select * from t_union
        where  union_mari  is null
        and    union_femme = :mere)
        into :compte;
        if (compte<1) then
          insert into t_union (union_femme,kle_dossier,union_type)
          values (:mere, :i_kle_dossier, 0);
      end
      else
      if (i_mode = 2) then
      begin
        compte=0;
        select 1 from rdb$database where exists
        (select * from t_union
        where  union_mari  = :pere
        and    union_femme is null)
        into :compte;
        if (compte<1) then
          insert into t_union  (union_mari,kle_dossier,union_type)
          values ( :pere, :i_kle_dossier, 0);
      end
    end    
end^
commit^

CREATE OR ALTER PROCEDURE PROC_MODIF_FILIATION (
    i_kle_dossier integer,
    i_individu integer,
    i_pere integer,
    i_mere integer)
as
declare variable compte integer;
begin
   /*---------------------------------------------------------------------------
   Copyright Laurent Robbe. Tout droits réservés.
   Créé le : 12/06/2003
   à : 11:54:11
   Modifiée le :29/01/2008 par André, optimisation
   à : :
   par :
   Description : Met à jour si besoin la table T_UNION pour un individu et son (ses)
                 parents
   Usage       : Si le père ou la mère n'est pas présent, le (la) renseigner à zéro
                 Si les 2 sont absents, les mettre à zéro ou ne pas appeler la procédure
   ---------------------------------------------------------------------------*/

  /* Etape 1 : Suppression de ses liens de filiation actuels */
  /* mode=0 Détachement père et mère */
  execute procedure proc_suppression_filiation(:i_kle_dossier,:i_individu,0);

  /* Etape 2 : Ajout des unions si nécessaire */
  if (i_pere=0) then i_pere=null;
  if (i_mere=0) then i_mere=null;

  /* Si père et mère à null alors rien de plus à faire (effacement des liens fait
     plus haut
     Sinon */
  if (i_pere is not null or i_mere is not null) then
  begin
    /* Vérification de l'existence préalable du lien */
    compte=0;
    if (i_pere is null) then
    begin
      select 1 from rdb$database where exists
      (select * from t_union
      where union_mari  is null
        and union_femme = :i_mere)
      into :compte;
    end
    else
    if (i_mere is null) then
    begin
      select 1 from rdb$database where exists
      (select * from t_union
      where union_mari=:i_pere
        and union_femme is null)
      into :compte;
    end
    else
    begin
      select 1 from rdb$database where exists
      (select * from t_union
      where union_mari=:i_pere
        and union_femme=:i_mere)
      into :compte;
    end
    /* Si compte >= 1 : pas d'action à faire : une union (ou plus !?!) pour ces 2 individus
       Sinon */
    if (compte < 1) then
    begin
      insert into t_union (union_mari,union_femme,kle_dossier,union_type)
      values (:i_pere,:i_mere,:i_kle_dossier,0);
    end
  end

  /* Etape 3 : Modification de la fiche individu */
  update individu
  set cle_pere=:i_pere
     ,cle_mere=:i_mere
  where cle_fiche=:i_individu;
end^
commit^

CREATE OR ALTER PROCEDURE PROC_EVT_DISPO (
    i_clef integer,
    a_mode char(1))
returns (
    ref_eve_code integer,
    ref_eve_lib_court varchar(5),
    ref_eve_lib_long varchar(30),
    ref_eve_cat integer,
    ref_eve_visible integer)
as
begin
   /*---------------------------------------------------------------------------
   Copyright Philippe Cazaux-Moutou. Tout droits réservés.
   Créé le : 31/07/2001
   à : 19:10:18
   Dernière modification par André le 2/2/2008 pour autoriser REF_EVE_TYPE='D' et
   séparer les attributs A des événements E 
   Description : Donne tous les événemenst disponibles pour un individu
   Usage       :
   ---------------------------------------------------------------------------*/
   for
     select  ref_eve_code,
             ref_eve_lib_court,
             ref_eve_lib_long,
             ref_eve_cat,
             ref_eve_visible
        from ref_evenements
        where ref_eve_visible = 1
          and ((:a_mode='I' and ref_eve_type in('A','E','D')
                and ref_eve_lib_court not in
               (select e.ev_ind_type
                from evenements_ind e
                inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type
                                            and r.ref_eve_visible=1
                                            and r.ref_eve_une_fois=1
                where e.ev_ind_kle_fiche = :i_clef))
                or (:a_mode='U' and ref_eve_type in('U','D')))
        order by ref_eve_cat, ref_eve_lib_long
        into :ref_eve_code,
             :ref_eve_lib_court,
             :ref_eve_lib_long,
             :ref_eve_cat,
             :ref_eve_visible
     do  
  suspend;
end^
commit^

CREATE OR ALTER PROCEDURE PROC_MAJ_TAGS 
as
declare variable code_union integer;
declare variable compte integer;
declare variable dossier integer;
begin
  for select union_clef,kle_dossier
      from t_union
      where union_type=1 --Mariés
      into :code_union,:dossier
      do
  begin
    compte=0;
    select 1 from rdb$database where exists
    (select * from evenements_fam
    where ev_fam_type='MARR'
      and ev_fam_kle_famille=:code_union)
    into :compte;
    if (compte<1) then
      insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                 ,ev_fam_type)
      values(:code_union,:dossier,'MARR');
  end

  for select union_clef,kle_dossier
      from t_union
      where union_type=2 --Concubinage
      into :code_union,:dossier
      do
  begin
    compte=0;
    select 1 from rdb$database where exists
    (select * from evenements_fam
    where ev_fam_type='EVEN'
      and ev_fam_description='Concubinage'
      and ev_fam_kle_famille=:code_union)
    into :compte;
    if (compte<1) then
      insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                 ,ev_fam_type,ev_fam_description)
      values(:code_union,:dossier,'EVEN','Concubinage');
  end

  for select union_clef,kle_dossier
      from t_union
      where union_type=3 --Séparés
      into :code_union,:dossier
      do
  begin
    compte=0;
    select 1 from rdb$database where exists
    (select * from evenements_fam
    where ev_fam_type='EVEN'
      and ev_fam_description='Séparés'
      and ev_fam_kle_famille=:code_union)
    into :compte;
    if (compte<1) then
      insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                 ,ev_fam_type,ev_fam_description)
      values(:code_union,:dossier,'EVEN','Séparés');
  end

  for select union_clef,kle_dossier
      from t_union
      where union_type=4 --Union libre
      into :code_union,:dossier
      do
  begin
    compte=0;
    select 1 from rdb$database where exists
    (select * from evenements_fam
    where ev_fam_type='EVEN'
      and ev_fam_description='Union libre'
      and ev_fam_kle_famille=:code_union)
    into :compte;
    if (compte<1) then
      insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                 ,ev_fam_type,ev_fam_description)
      values(:code_union,:dossier,'EVEN','Union libre');
  end

  for select union_clef,kle_dossier
      from t_union
      where union_type=5 --Relations extra-conjugales
      into :code_union,:dossier
      do
  begin
    compte=0;
    select 1 from rdb$database where exists
    (select * from evenements_fam
    where ev_fam_type='EVEN'
      and ev_fam_description='Relations extra-conjugales'
      and ev_fam_kle_famille=:code_union)
    into :compte;
    if (compte<1) then
      insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                 ,ev_fam_type,ev_fam_description)
      values(:code_union,:dossier,'EVEN','Relations extra-conjugales');
  end

  for select union_clef,kle_dossier
      from t_union
      where union_type=6 --PACS
      into :code_union,:dossier
      do
  begin
    compte=0;
    select 1 from rdb$database where exists
    (select * from evenements_fam
    where ev_fam_type='MARR'
      and ev_fam_kle_famille=:code_union)
    into :compte;
    if (compte<1) then
      insert into evenements_fam (ev_fam_kle_famille,ev_fam_kle_dossier
                                 ,ev_fam_type,ev_fam_description)
      values(:code_union,:dossier,'MARR','PACS');
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
commit^

COMMENT ON PROCEDURE PROC_MAJ_TAGS IS
'Procédure créée par André le 30/01/2008 pour transformer le champ UNION_TYPE
en événements familiaux, et les tags spéciaux en événements divers.'^
commit^

CREATE OR ALTER TRIGGER TBU_EVENEMENTS_FAM FOR EVENEMENTS_FAM
ACTIVE BEFORE UPDATE POSITION 0
AS
begin
/* Créé par André le 18/11/2005 pour mettre à jour les dates
01/06/2006 ajout des mois,date de fin et normalisation des dates
11/05/2007 mise à jour media_pointeurs*/
if (new.ev_fam_date_writen is distinct from old.ev_fam_date_writen) then
  select imois,ian,ddate,imois_fin,ian_fin,ddate_fin,date_writen_s
    from proc_date_writen(new.ev_fam_date_writen)
    into new.ev_fam_date_mois,new.ev_fam_date_year,new.ev_fam_date,
         new.ev_fam_date_mois_fin,new.ev_fam_date_year_fin,new.ev_fam_date_fin,
         new.ev_fam_date_writen;
if (new.ev_fam_acte<1 or new.ev_fam_acte is null) then
begin
  if (new.ev_fam_acte is null) then
    new.ev_fam_acte=0;
  if (old.ev_fam_acte=1) then
    delete from media_pointeurs
    where mp_pointe_sur=old.ev_fam_clef
      and mp_table='F'
      and mp_type_image='A';
end
end^
commit^

execute procedure PROC_MAJ_TAGS^
commit^

update ref_evenements set ref_eve_type='A' where ref_eve_type='I'^
commit^

update ref_evenements set ref_eve_type='E' where ref_eve_cat in (0,1,3,4,12,13,14)^
commit^

update ref_evenements set ref_eve_type='D' where ref_eve_lib_court in ('CENS','EVEN')^
commit^

update ref_evenements set ref_eve_type='A' where ref_eve_lib_court='RELI'^
commit^

update ref_evenements set ref_eve_type='E' where ref_eve_lib_court='GRAD'^
commit^

update ref_evenements set ref_eve_type='E' where ref_eve_lib_court='ADOP'^
commit^

update ref_evenements set ref_eve_type='E' where ref_eve_lib_court='EMIG'^
commit^

update ref_evenements set ref_eve_type='E' where ref_eve_lib_court='IMMI'^
commit^

update ref_evenements set ref_eve_type='E' where ref_eve_lib_court='NATU'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='X_MU1'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='X_MU2'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='X_MU3'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='XSPO'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='XLOI'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='XHENN'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T',ref_eve_lib_long='Houpa - Bénéd. religieuse' where ref_eve_lib_court='XHOUP'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='VOYA'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='TRIP'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='MILI'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='COMU'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='BRIT'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='SACR'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='DECO'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='PURC'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='LEGA'^
commit^

update ref_evenements set ref_eve_visible=0,ref_eve_type='T' where ref_eve_lib_court='SALE'^
commit^

update ref_evenements set ref_eve_visible=1 where ref_eve_lib_court='CAST'^
commit^

update ref_evenements set ref_eve_visible=1,ref_eve_type='A',ref_eve_cat=10 where ref_eve_lib_court='IDNO'^
commit^

update ref_evenements set ref_eve_type='A' where ref_eve_lib_court='NCHI'^
commit^

update ref_evenements set ref_eve_type='A' where ref_eve_lib_court='NMR'^
commit^

update ref_evenements set ref_eve_type='A',ref_eve_cat=10 where ref_eve_lib_court='PROP'^
commit^

update ref_evenements set ref_eve_type='E' where ref_eve_lib_court='RESI'^
commit^

update ref_evenements set ref_eve_lib_long='Nationalité, Peuple ou Tribu' where ref_eve_lib_court='NATI'^
commit^

CREATE OR ALTER PROCEDURE PROC_NAVIGATION (
    i_clef integer,
    i_dossier integer,
    i_max integer)
returns (
    niveau integer,
    cle_fiche integer,
    nom varchar(60),
    prenom varchar(100),
    date_naissance varchar(100),
    date_deces varchar(100),
    sexe integer,
    cle_pere integer,
    cle_mere integer,
    sosa double precision,
    decede integer,
    ville_naissance varchar(50),
    ville_deces varchar(50),
    age_en_jours integer,
    profession varchar(90),
    date_union varchar(90),
    ville_union varchar(50),
    photo blob sub_type 0 segment size 80,
    enfants integer,
    num_sosa double precision,
    periode_vie varchar(15),
    age_union_jours integer,
    age_union_ind_jours integer)
as
begin
     suspend;
end^
commit^

CREATE OR ALTER PROCEDURE PROC_IND_EST_TEMOIN (
    i_clef integer)
returns (
    cle_fiche integer,
    nom varchar(60),
    prenom varchar(100),
    date_naissance varchar(100),
    date_deces varchar(100),
    sexe integer,
    cle_pere integer,
    cle_mere integer,
    decede integer,
    num_sosa double precision,
    periode_vie varchar(15),
    evenement integer,
    type_table varchar(1),
    annee integer,
    type_ev varchar(7))
as
begin
    suspend;
end^
commit^

CREATE OR ALTER PROCEDURE PROC_TEMOINS_DE_IND (
    i_clef integer)
returns (
    cle_fiche integer,
    nom varchar(60),
    prenom varchar(100),
    date_naissance varchar(100),
    date_deces varchar(100),
    sexe integer,
    cle_pere integer,
    cle_mere integer,
    decede integer,
    num_sosa double precision,
    periode_vie varchar(15),
    evenement integer,
    type_table varchar(1),
    annee integer,
    type_ev varchar(7))
as
begin
    suspend;
end^
commit^

CREATE OR ALTER PROCEDURE PROC_ORPHELINS (
    idossier integer)
returns (
    cle_fiche integer,
    nom varchar(40),
    prenom varchar(60),
    date_naissance varchar(100),
    date_deces varchar(100),
    sexe integer)
as
BEGIN
    SUSPEND;
END^
commit^

CREATE OR ALTER PROCEDURE PROC_TROUVE_CONJOINTS (
    i_dossier integer,
    i_clef integer)
returns (
    cle_fiche integer,
    nom varchar(60),
    prenom varchar(100),
    date_naissance varchar(100),
    annee_naissance integer,
    date_deces varchar(100),
    annee_deces integer,
    sexe integer,
    type_union integer,
    union_clef integer,
    sosa double precision,
    date_mariage varchar(100),
    annee_mariage integer,
    cle_mariage integer,
    ordre_union integer)
as
begin
     suspend;
end^
commit^

ALTER TABLE MULTIMEDIA DROP CONSTRAINT PK_MULTIMEDIA^
commit^
alter table MULTIMEDIA
add constraint PK_MULTIMEDIA
primary key (MULTI_CLEF)
using index PK_MULTIMEDIA^
commit^
ALTER TABLE INDIVIDU DROP CONSTRAINT PK_INDIVIDU^
commit^
alter table INDIVIDU
add constraint PK_INDIVIDU
primary key (CLE_FICHE)
using index PK_INDIVIDU^
commit^

UPDATE T_VERSION_BASE SET VER_VERSION='5.060'^
COMMIT WORK^

SET ECHO ON^

/*Passage en version 5.060
L'utilisation de la base modifiée avec une version du logiciel inférieure à V791 peut entraîner des disfonctonnements.*/
SET ECHO OFF^
SET TERM ; ^
SET AUTODDL ON;
OUTPUT;
exit;
