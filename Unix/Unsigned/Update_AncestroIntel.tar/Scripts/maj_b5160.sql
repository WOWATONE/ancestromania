SET TERM ^ ;
CREATE OR ALTER PROCEDURE PROC_INDIVIDU_PAR_NOM (
    I_DOSSIER integer,
    I_NOM varchar(40),
    I_SEXE integer,
    I_NAISSANCE integer,
    I_DECES integer)
RETURNS (
    CLE_FICHE integer,
    CLE_PERE integer,
    CLE_MERE integer,
    NOM varchar(40),
    PRENOM varchar(60),
    SURNOM varchar(120),
    NUM_SOSA double precision,
    ind_confidentiel integer,
    SEXE integer,
    DATE_NAISSANCE varchar(100),
    ANNEE_NAISSANCE integer,
    DATE_DECES varchar(100),
    ANNEE_DECES integer,
    VILLE varchar(50),
    CP varchar(10),
    SUBD_NAISSANCE varchar(50),
    PAYS_NAISSANCE varchar(10),
    REGION_NAISSANCE varchar(50),
    DEPT_NAISSANCE varchar(30),
    SUBD_DECES varchar(50),
    PAYS_DECES varchar(10),
    REGION_DECES varchar(50),
    DEPT_DECES varchar(30),
    VILLE_DECES varchar(50),
    CP_DECES varchar(10))
AS
begin
   /*---------------------------------------------------------------------------
   Author Matthieu GIROUX
   Created on : 08/06/2012
   ---------------------------------------------------------------------------*/
  for
    select 
    i.cle_fiche
    ,i.cle_pere
    ,i.cle_mere
    ,i.nom
    ,i.prenom
    ,i.surnom
    ,i.num_sosa
    ,i.annee_naissance 
    ,i.date_naissance 
    ,i.annee_deces
    ,i.date_deces
    ,bin_and(i.ind_confidentiel,1) as ind_confidentiel
    ,i.sexe
     from individu i
      where i.kle_dossier=:I_DOSSIER and i.nom=:I_NOM and (0=:i_sexe or i.sexe=:i_sexe)
    union select 
    i.cle_fiche
    ,i.cle_pere
    ,i.cle_mere
    ,i.nom
    ,i.prenom
    ,i.surnom
    ,i.num_sosa
    ,i.annee_naissance 
    ,i.date_naissance 
    ,i.annee_deces
    ,i.date_deces
    ,bin_and(i.ind_confidentiel,1) as ind_confidentiel
    ,i.sexe
     from nom_attachement p inner join individu i on i.cle_fiche=p.id_indi
      where p.kle_dossier=:I_DOSSIER and p.nom=:I_NOM and (0=:i_sexe or i.sexe=:i_sexe)
    union select 
    i.cle_fiche
    ,i.cle_pere
    ,i.cle_mere
    ,i.nom
    ,i.prenom
    ,i.surnom
    ,i.num_sosa
    ,i.annee_naissance 
    ,i.date_naissance 
    ,i.annee_deces
    ,i.date_deces
    ,bin_and(i.ind_confidentiel,1) as ind_confidentiel
    ,i.sexe
     from nom_attachement p inner join individu i on i.nom=p.nom_indi and i.kle_dossier=p.kle_dossier
      where p.kle_dossier=:I_DOSSIER and p.nom=:I_NOM and (0=:i_sexe or i.sexe=:i_sexe)
    into 
    :cle_fiche
    ,:cle_pere
    ,:cle_mere
    ,:nom
    ,:prenom
    ,:surnom
    ,:num_sosa
    ,:annee_naissance 
    ,:date_naissance 
    ,:annee_deces
    ,:date_deces 
    ,:ind_confidentiel
    ,:sexe
  do
  begin
  if (i_naissance = 1) then
   begin
    for
     select 
      ev_ind_cp,
      ev_ind_ville,
      ev_ind_subd,
      ev_ind_dept,
      ev_ind_region,
      ev_ind_pays    
     from evenements_ind n
      WHERE ev_ind_type='BIRT' and n.ev_ind_kle_fiche=:cle_fiche
      INTO
      :CP,:ville,:SUBD_NAISSANCE,:DEPT_NAISSANCE,
      :REGION_NAISSANCE,:PAYS_NAISSANCE    
     do suspend;
    end	
  if (i_deces = 1) then
   begin
    for
     select 
      ev_ind_cp,
      ev_ind_ville,
      ev_ind_subd,
      ev_ind_dept,
      ev_ind_region,
      ev_ind_pays        
     from evenements_ind d 
      WHERE ev_ind_type='DEAT' and d.ev_ind_kle_fiche=:cle_fiche
      INTO
      :CP_deces,:ville_deces,:SUBD_DECES,
      :DEPT_DECES,:REGION_DECES,:PAYS_DECES
     do suspend;
    end	
    suspend;
   end
suspend;
end^
SET TERM ; ^

UPDATE T_VERSION_BASE SET VER_VERSION='5.160';
COMMIT WORK;

