program Ancestromania;

{$IFDEF FPC}
  {$MODE Delphi}
{$ELSE}
//ligne à activer uniquement après tests car elle empêche le fonctionnement en mode déboggage dans delphi
//le manifest intégré désactive le mode virtualisation sous Vista
{$R 'MonManifest.res' 'MonManifest.rc'}
{$ENDIF}
{$IFDEF WIN64}
{.$R Ancestromania.rc}
{$ENDIF}

uses
  Forms, Interfaces,
  u_dm in '../Main/u_dm.pas' {dm: TDataModule},
  u_form_main in '../Main/u_form_main.pas' {FMain},
  u_Form_Voir_Point in '../Cartographie/u_Form_Voir_Point.pas' {FVoirPoint: TSuperForm},
  u_form_anniversaires in '../Divers/u_form_anniversaires.pas' {FAnniversaires},
  u_form_arbre in '../Arbre/u_form_arbre.pas' {FArbre: TSuperForm},
  u_form_arbre_Hierarchique in '../Arbre/u_form_arbre_Hierarchique.pas' {FArbreHierarchique: TSuperForm},
  u_form_ask_name_files_to_export_report in '../Editions/u_form_ask_name_files_to_export_report.pas' {FAskNameFilesToExportReport},
  u_Form_Bibliotheque_Multimedia in '../Multimedia/u_Form_Bibliotheque_Multimedia.pas' {FBiblioMultimedia},
  u_form_calendriers in '../Calendrier/u_form_calendriers.pas' {FCalendriers: TSuperForm},
  u_calendriers_gregorien in '../Calendrier/u_form_calendriers_gregorien.pas',
  u_form_individu_Sa_Vie in '../Individus/u_form_individu_Sa_Vie.pas' {FSaVie: TSuperForm},
  u_Form_Capture_Video in '../MultiMediaWebCam/u_Form_Capture_Video.pas' {FCapture_Video},
  u_Form_Capture_Photos in '../MultiMediaWebCam/u_Form_Capture_Photos.pas' {FCapture_Photos},
  u_form_coherence in '../Individus/u_form_coherence.pas' {FCoherence},
  u_Form_Compte_Villes in '../Divers/u_Form_Compte_Villes.pas' {FCompteVilles: TSuperForm},
  u_form_confirm_add_to_favoris in '../Divers/u_form_confirm_add_to_favoris.pas' {FConfirmAddToFavoris},
  u_form_edit_context in '../Context/u_form_edit_context.pas' {FEditContext},
  u_form_edit_dossier in '../Divers/u_form_edit_dossier.pas' {FEditDossier},
  u_form_edit_raccourcis in '../Context/u_form_edit_raccourcis.pas' {FEditRaccourcis},
  u_form_edit_ref_particules in '../Context/u_form_edit_ref_particules.pas' {FEditRefParticules},
  u_form_edit_ref_prefixes in '../Context/u_form_edit_ref_prefixes.pas' {FEditRefPrefixes},
  u_form_edit_ref_token_date in '../Gedcom/u_form_edit_ref_token_date.pas' {FEditRefTokenDate},
  u_form_Evements_Ajout in '../Divers/u_form_Evements_Ajout.pas' {FEvenement_Ajout: TSuperForm},
  u_form_export_gedcom in '../Gedcom/u_form_export_gedcom.pas' {FExportGedcom},
  u_form_export_geneanet in '../Gedcom/u_form_export_geneanet.pas' {FExportGeneanet},
  u_form_export_table_2_textfile in '../Context/u_form_export_table_2_textfile.pas' {FExportTable2TextFile},
  u_form_graph_config_hierarchie in '../Graph/u_form_graph_config_hierarchie.pas' {FGraphConfigHierarchie},
  u_form_graph_config_roue in '../Graph/u_form_graph_config_roue.pas' {FGraphConfigRoue},
  u_form_graph_paintbox in '../Graph/u_form_graph_paintbox.pas' {FGraphPaintBox},
  u_form_import_gedcom in '../Gedcom/u_form_import_gedcom.pas' {FImportGedcom},
  u_form_Import_textfile_2_table in '../Context/u_form_Import_textfile_2_table.pas' {FImportTextFile2Table},
  u_form_individu in '../Individus/u_form_individu.pas' {FIndividu},
  u_form_individu_Navigation in '../Individus/u_form_individu_Navigation.pas' {FIndividuNavigation: TSuperForm},
  u_form_individu_Affecte_Enfant in '../Individus/u_form_individu_Affecte_Enfant.pas' {FAffecte_Enfant},
  u_form_individu_Domiciles in '../Individus/u_form_individu_Domiciles.pas' {FIndividuDomiciles},
  u_form_individu_edit_event_life in '../Individus/u_form_individu_edit_event_life.pas' {FIndividuEditEventLife},
  u_form_individu_identite in '../Individus/u_form_individu_identite.pas' {FIndividuIdentite},
  u_form_individu_observations in '../Individus/u_form_individu_observations.pas' {FIndividuObservations: TSuperForm},
  u_form_individu_repertoire in '../Individus/u_form_individu_repertoire.pas' {FIndividuRepertoire},
  u_form_individu_photos_et_docs in '../Individus/u_form_individu_photos_et_docs.pas' {FIndividuPhotosEtDocs: TSuperForm},
  u_Form_Individu_Sur_Favoris in '../Individus/u_Form_Individu_Sur_Favoris.pas' {FIndividusSurFavoris: TSuperForm},
  u_form_individu_Union in '../Individus/u_form_individu_Union.pas' {FIndividuUnion},
  u_Form_Infos in '../Divers/u_Form_Infos.pas' {FInfos: TSuperForm},
  u_Form_Infos_Indi in '../Divers/u_Form_Infos_Indi.pas' {FInfosIndi},
  u_form_list_report in '../Editions/u_form_list_report.pas' {FListReport},
  u_form_Liste_Cousinage in '../Divers/u_form_Liste_Cousinage.pas' {FListeCousinage},
  u_Form_Journal_Operation in '../Context/u_Form_Journal_Operation.pas' {FJournalOperations: TSuperForm},
  u_Form_Indi_DateIncoherentes in '../Divers/u_Form_Indi_DateIncoherentes.pas' {FIndiDateIncoherente},
  u_Form_Liste_Unions in '../Divers/u_Form_Liste_Unions.pas' {FListeUnions: TSuperForm},
  u_Form_Maj_Internet in '../MAJInternet/u_Form_Maj_Internet.pas' {FMajInternet: TSuperForm},
  u_form_Modif_Favoris in '../Divers/u_form_Modif_Favoris.pas' {FModifFavoris: TSuperForm},
  u_form_OpenSources in '../Divers/u_form_OpenSources.pas' {FOpenSources},
  u_form_param_reports in '../Editions/u_form_param_reports.pas' {FParamReports},
  u_Form_Patronymes in '../Individus/u_Form_Patronymes.pas' {FPatronymes},
  u_Form_Posthumes in '../Individus/u_Form_Posthumes.pas' {FPosthumes: TSuperForm},
  u_form_postit in '../Divers/u_form_postit.pas' {FPostit},
  u_form_rechercher in '../Individus/u_form_rechercher.pas' {FRechercher},
  u_form_Restore in '../Divers/u_form_Restore.pas' {FRestore: TSuperForm},
  u_Form_Sauvegarde in '../Divers/u_Form_Sauvegarde.pas' {FSauvegarde},
  u_form_select_database in '../Divers/u_form_select_database.pas' {FSelectDatabase: TSuperForm},
  u_form_select_dossier in '../Divers/u_form_select_dossier.pas' {FSelectDossier},
  u_form_TAG_Gedcom in '../Divers/u_form_TAG_Gedcom.pas' {FTAGGedcom: TSuperForm},
  u_form_TriEvent in '../Divers/u_form_TriEvent.pas' {FTriEvent},
  u_form_Ville_Ajout in '../Divers/u_form_Ville_Ajout.pas' {FVilleAjout},
  u_objet_TCoherenceDate in '../Individus/u_objet_TCoherenceDate.pas',
  u_genealogy_context in '../Context/u_objet_TContext.pas',
  u_common_ancestro in '../Main/u_common_ancestro.pas',
  u_form_biblio_Sources in '../Evenements/u_form_biblio_Sources.pas' {FBiblio_Sources: TSuperForm},
  u_Form_Liste_Doublons in '../Divers/u_Form_Liste_Doublons.pas' {FListeDoublons: TSuperForm},
  u_Form_DeleteImportGedcom in '../Gedcom/u_Form_DeleteImportGedcom.pas' {FDeleteImportGedcom},
  u_Form_DeleteBranche in '../Individus/u_Form_DeleteBranche.pas' {FDeleteBranche},
  u_Form_About in '../Divers/u_Form_About.pas' {FAbout},
  u_Form_Orphelins in '../Individus/u_Form_Orphelins.pas' {FOrphelins: TSuperForm},
  u_Form_Mutation_Base in '../MutationBase/u_Form_Mutation_Base.pas' {FMutationBase: TSuperForm},
  u_form_individu_Saisie_Rapide in '../Individus/u_form_individu_Saisie_Rapide.pas' {FIndividuSaisieRapide: TSuperForm},
  u_form_CalculDate in '../CalculDate/u_form_CalculDate.pas' {FCalculDate: TSuperForm},
  u_form_list_villes_Voisines in '../Lieux/u_form_list_villes_Voisines.pas' {FVillesVoisines: TSuperForm},
  u_form_list_villes in '../Lieux/u_form_list_villes.pas' {FListVilles: TSuperForm},
  u_form_list_villes_Doublons in '../Lieux/u_form_list_villes_Doublons.pas' {FListeVillesDoublons: TSuperForm},
  u_form_biblio_Multimedia_Edit in '../Multimedia/u_form_biblio_Multimedia_Edit.pas' {FBiblio_Multimedia_Edit: TSuperForm},
  u_Form_Histoire in '../Divers/u_Form_Histoire.pas' {FHistoire},
  u_Form_Histoire_Detail in '../Divers/u_Form_Histoire_Detail.pas' {FormHistoireDetail},
  u_Form_Histoire_Import in '../Divers/u_Form_Histoire_Import.pas' {FHistoireImport},
  u_Form_Histoire_Export in '../Divers/u_Form_Histoire_Export.pas' {FHistoireExport},
  u_Form_Liste_Nouveaux_Indi in '../Individus/u_Form_Liste_Nouveaux_Indi.pas' {FListeNouveauxIndi: TSuperForm},
  u_Form_Temoin_De in '../Individus/u_Form_Temoin_De.pas' {FTemoinDe: TSuperForm},
  u_Form_Qui_Porte_ce_Titre in '../Divers/u_Form_Qui_Porte_ce_Titre.pas' {FQuiPorteCeTitre: TSuperForm},
  u_form_Base_Pas_a_Jour in '../Main/u_form_Base_Pas_a_Jour.pas' {FBasePasAJour},
  u_Form_ChercheNIP in '../Individus/u_Form_ChercheNIP.pas' {FChercheNIP},
  u_Form_Qui_Habite_La in '../Divers/u_Form_Qui_Habite_La.pas' {FQuiHabiteLa: TSuperForm},
  u_form_Actes_Liste in '../Individus/u_form_Actes_Liste.pas' {FActesListe: TSuperForm},
  u_Form_Recherche_Actes in '../Divers/u_Form_Recherche_Actes.pas' {FRechercheActes: TSuperForm},
  u_Form_Recherche_Ancetres in '../Divers/u_Form_Recherche_Ancetres.pas' {FRechercheAncetres: TSuperForm},
  u_Form_Groupe_Indis in '../Divers/u_Form_Groupe_Indis.pas' {FGroupeIndis: TSuperForm},
  u_form_path_medias in '../Multimedia/u_form_path_medias.pas' {FPathMedias: TSuperForm},
  sysutils,
  u_form_tv_ascendance in '../Arbre/u_form_tv_ascendance.pas' {FtvAscendance: TSuperForm},
  u_form_edit_ref_filiation in '../Context/u_form_edit_ref_filiation.pas' {FEditRefFiliation: TSuperForm},
  u_form_edit_ref_Divers in '../Divers/u_form_edit_ref_divers.pas' {FEditRefDivers: TSuperForm},
  u_form_edit_ref_temoins in '../Divers/u_form_edit_ref_temoins.pas' {FEditRefTemoins: TSuperForm},
  u_form_env_famille in '../Individus/u_form_env_famille.pas' {FEnvFamille: TSuperForm},
  u_Form_Utilisation_Media in '../Multimedia/u_Form_Utilisation_Media.pas' {FUtilisationMedia: TSuperForm},
  u_form_requetes in '../Divers/u_form_requetes.pas' {FRequete: TSuperForm},
  
  u_Form_select_rep in '../Divers/u_Form_select_rep.pas' {fSelect_rep},
  u_form_graph_config_liens in '../Graph/u_form_graph_config_liens.pas' {FGraphConfigLiens: TSuperForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := u_genealogy_context.Ancestromania;
  Application.Name  := u_genealogy_context.Ancestromania;
  Application.CreateForm(Tdm, dm);
  Application.Run;
  if not dm.ApplicationContinue then //parce qu'on peut arrêter dans le create de dm
    dm.Free;
//  SetHeapTraceOutput (ExtractFilePath (Application.ExeName) + 'heaptrclog.trc');

end.

