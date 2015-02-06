{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{AL 2009 création nouvelles variables date, suppression _LastPosMiniature}
{-----------------------------------------------------------------------}

unit u_common_ancestro;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
  u_common_const;

const IBQ_DLL_DOSSIER = 'dll_DOSSIER';
      NOM_DOSSIER = 'NOM_DOSSIER';

      EQUAL = '=';

      CST_AUTHOR = 'LIBERLOG 2014';

      CST_PROGRESS_COUNTER_TITLE = 1;
      CST_PROGRESS_COUNTER_Surnames = 1;
      CST_PROGRESS_COUNTER_MAP = 1;
      CST_PROGRESS_COUNTER_SEARCH = 1;
      CST_PROGRESS_COUNTER_AGES = 1;
      CST_PROGRESS_COUNTER_JOBS = 1;
      CST_PROGRESS_COUNTER_TREE = 1;
      CST_PROGRESS_COUNTER_CONTACT = 1;
      CST_PROGRESS_COUNTER_HOME = 1;
      CST_PROGRESS_COUNTER_FILES = 1;
      CST_PROGRESS_COUNTER_LIST = 1;
      CST_PROGRESS_COUNTER_COPY = 1;
      SQL_OR = ' OR ';
      CST_AncestroWeb = 'AncestroWeb';
      CST_AncestroWeb_WithLicense = CST_AncestroWeb + ' LGPL';

      IBQ_CLE_FICHE = 'CLE_FICHE';
      IBQ_CLE_PERE = 'CLE_PERE';
      IBQ_CLE_MERE = 'CLE_MERE';
      IBQ_SOSA = 'NUM_SOSA';
      IBQ_SEXE = 'SEXE';
      IBQ_SEXE_MAN = 1;
      IBQ_SEXE_WOMAN = 2;

      IBQ_EV_IND_DESCRIPTION = 'EV_IND_DESCRIPTION';
      IBQ_EV_IND_CP = 'EV_IND_CP';
      IBQ_EV_IND_LATITUDE = 'EV_IND_LATITUDE';
      IBQ_EV_IND_LONGITUDE = 'EV_IND_LONGITUDE';
      IBQ_EV_IND_VILLE = 'EV_IND_VILLE';
      IBQ_EV_IND_DATE = 'EV_IND_DATE';
      IBQ_EV_IND_PAYS = 'EV_IND_PAYS';

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

      I_CLEF = 'I_CLEF';
      I_PAYS = 'I_PAYS';
      I_CP = 'I_CP';
      I_CITY = 'I_CITY';
      I_CLEF_MULTI = 'I_CLEF_MULTI';
      I_NIVEAU = 'I_NIVEAU';
      I_DOSSIER = 'I_DOSSIER';
      I_PARQUI = 'I_PARQUI';
      I_CLEF_UNION = 'I_CLEF_UNION';

      CST_INI_PATH_BDD = 'PathFileNameBdd';
      CST_INI_PATH     = 'Path';
      END_EXTENSION_HTML = 'html';
      EXTENSION_HTML = '.'+END_EXTENSION_HTML;
      EXTENSION_RTF  = '.rtf';
      EXTENSION_PDF  = '.pdf';
      EXTENSION_HTM  = '.htm';
      PLEASE_WAIT = 'pleasewait.gif';

      MEDIAS_TABLE_SOURCE = 'S';
      MEDIAS_TABLE_PERSON = 'I';
      MEDIAS_TABLE_ARCHIV = 'A';
      MEDIAS_TABLE_UNION = 'F';
      MEDIAS_TYPE_IMAGE = 0;
      MEDIAS_TYPE_DOCU = 1;
      MEDIAS_TYPE_VIDEO = 3;
      MEDIAS_TYPE_SON = 2;
      URL_WIKIPEDIA = 'http://fr.wikipedia.org/wiki/';
      URL_GEOPORTAIL = 'http://www.geoportail.fr/';
      URL_GOOGLE_MAPS = 'http://maps.google.com/maps?';
      URL_NOMINATIM = 'http://nominatim.openstreetmap.org/search';
      URL_GEONAMES = 'http://www.geonames.org';
      URL_MAPPER_ACME = 'http://mapper.acme.com/';
      URL_OPEN_STREET_MAP = 'http://www.openstreetmap.org/';

      DM_INI_NOT_SHOWED_TASKS = 'NotShowedTasks';
      _ZOOM_MIN = 3;  //limites du zoom dans le TViewer
      _ZOOM_MAX = 200;

type
  TTVNodeEve = record
     FKey,
     ImageIdx : Integer;
     FCaption : String ;
  end;
  PTVNodeEve = ^TTVNodeEve;
var
  fCassiniDll:Boolean;
  fNomAppli:string;
  //valeurs qui restent privées
  fKeyRegistry:string;



resourcestring
  rs_actions_executed_from_commit_have_been_cancelled = 'Les actions depuis le dernier COMMIT ou la dernière'+_CRLF
        +'instruction DDL valide ont été annulées.';
  rs_Action_can_be_long = 'Cette action peut être longue.';
  rs_Action_corrects_consistency =
        'Cette fonction corrige d''éventuelles erreurs de cohérence'+_CRLF
      +'de votre base telles qu''un événement individuel ou un'+_CRLF
      +'média affecté à un individu n''existant pas, un événement'+_CRLF
      +'familial sans famille etc...';
  rs_Action_corrects_closure =
  'Cette fonction permet de détecter d''éventuelles erreurs de bouclage entre'+_CRLF
    +'générations. Elle liste les individus présents dans l''ascendance de leur @ARG'+_CRLF
    +'Son exécution peut être longue (de l''ordre de la minute pour 6000 individus).';
  rs_Action_needs_backup =
      'Avant de l''exécuter il est impératif de sauvegarder votre'+_CRLF
      +'base afin de pouvoir la récupérer en cas d''erreur.'+_CRLF
      +'Il est aussi fortement conseillé de vérifier au préalable'+_CRLF
      +'son utilité en visualisant les erreurs éventuelles.';
  rs_Action_will_reset_some_Ancestromania_parameters = 'Cette action va réinitialiser certains paramètres d''Ancestromania.';
  rs_Ancestromania_is_starting = 'Ancestromania démarre';
  rs_Ancestromania_must_be_updated = 'Ancestromania n''est pas à jour.';
  rs_Ancestromania_will_be_closed_Youll_have_to_restart_it = 'Ancestromania va être fermé, vous devrez le relancer.';
  rs_Ancestromania_will_be_updated_and_saved = 'Attention, vous avez choisi de mettre à jour Ancestromania.'+_CRLF+_CRLF+
      'Pour exécuter cette mise à jour, vous devez utiliser un compte d''utilisateur'+_CRLF+
      'possédant des droits d''administration (compte de type administrateur).'+_CRLF+_CRLF+
      'Cette opération sauvegarde automatiquement l''ancienne version d''Ancestromania.exe'+_CRLF+
      'dans le sous-répertoire "Sauve_Avant_MAJ_Internet" du répertoire où est'+_CRLF+
      'installé le logiciel.'+_CRLF+_CRLF+
      'Nul ne vous oblige à faire cette mise à jour.'+_CRLF+
      'Si vous le faites, c''est que vous acceptez en connaissance de cause.'+_CRLF+_CRLF+
      'Si vous avez le moindre doûte, vous pouvez annuler cette mise à jour'+_CRLF+
      'et la recommencer plus tard.';
  rs_Ancestromania_is_connected_to_this_database = 'Ancestromania est connecté à la base de données :'+_CRLF+'@ARG';
  rs_Ancestromania_is_not_connected_to_a_database = 'Ancestromania n''est pas connecté à une base de données.';
  rs_Ancestromania_is_fully_updated = 'Ancestromania est à jour, ainsi que les scripts nécessaires'+_CRLF+
              'à la mise à jour de la base en dernière version.'+_CRLF+_CRLF+
              'Le téléchargement de la mise à jour n''est pas nécessaire.';
  rs_Ancestromania_is_not_fully_updated = 'Ancestromania est à jour, mais pas les scripts nécessaires'+_CRLF+
              'à la mise à jour de la base en dernière version.'+_CRLF+
              'Sur le site il y a la version suivante : @ARG';
  rs_Ancestromania_should_be_updated = 'Il est conseillé de télécharger et d''exécuter cette mise à jour.';
  rs_Ancestromania_update_exists_on_your_computer = 'Une mise à jour en @ARG existe sur votre ordinateur';
  rs_Ancestromania_update_files_have_not_been_found = 'Les fichiers de mise à jour n''ont pas été trouvés sur votre ordinateur';
  rs_Ancestromania_version_infos_too_old = 'Votre version d''Ancestromania est @ARG'
    +_CRLF+'Votre base doit être à la version @ARG au minimum.'
    +_CRLF+_CRLF+'Votre base: @ARG'
    +_CRLF+'La version @ARG actuelle est trop ancienne.';
  rs_Ancestry_of = 'Ascendance de @ARG';
  rs_Ancestries_of = 'Ancêtres de ';
  rs_Ancestries_Arc_of = 'Roue des ascendants de @ARG';
  rs_Ancestry_s_tree = 'Arbre d''ascendance';
  rs_Astro_Aquarius = 'Verseau';
  rs_Astro_Aries = 'Bélier';
  rs_Astro_Balance = 'Balance';
  rs_Astro_Cancer = 'Cancer';
  rs_Astro_Capricorn = 'Capricorne';
  rs_Astro_Gemini = 'Gémeaux';
  rs_Astro_Lion = 'Lion';
  rs_Astro_Pisces = 'Poissons';
  rs_Astro_Sagittarius = 'Sagittaire';
  rs_Astro_Scorpion = 'Scorpion';
  rs_Astro_Taurus = 'Taureau';
  rs_Astro_Virgin = 'Vierge';
  rs_and = '@ARG et @ARG';
  rs_at_where = 'à';
  rs_on_when = 'à';
  rs_asked = 'demandés';
  rs_bytes = 'octets';
  rs_born_female = 'née';
  rs_born_male = 'né';
  rs_Born_in_female = 'Née à @ARG';
  rs_Born_in_male = 'Né à @ARG';
  rs_Born_on = 'Né(e) le @ARG';
  rs_Born_on_female = 'Née le @ARG';
  rs_Born_on_male = 'Né le @ARG';
  rs_integrity_dead_before_birth_man =' Décédé avant sa naissance.';
  rs_integrity_dead_before_birth_woman =' Décédée avant sa naissance.';
  rs_integrity_age_hope_to_much_man =' Espérance de vie pour un homme, @ARG ans, dépassée.';
  rs_integrity_age_hope_to_much_woman =' Espérance de vie pour une femme, @ARG ans, dépassée.';
  rs_integrity_married_age_less_than_minimum_man=' Âge au mariage inférieur à l''âge minimum'+_CRLF+
    ' pour un homme: @ARG ans.';
  rs_integrity_married_age_less_than_minimum_woman=' Âge au mariage inférieur à l''âge minimum'+_CRLF+
    ' pour une femme: @ARG ans.';
  rs_integrity_married_more_than_maximum_man=' Âge au mariage supérieur à l''âge maximum'+_CRLF+
    ' pour un homme: @ARG ans.';
  rs_integrity_married_more_than_maximum_woman=' Âge au mariage supérieur à l''âge maximum'+_CRLF+
    ' pour une femme: @ARG ans.';
  rs_integrity_child_birth_date_less_than_man_mini=' Âge à la naissance d''un enfant inférieur'+_CRLF+
    ' à l''âge minimum pour un homme: @ARG ans.';
  rs_integrity_child_birth_date_less_than_woman_mini=' Âge à la naissance d''un enfant inférieur'+_CRLF+
    ' à l''âge minimum pour une femme: @ARG ans.';
  rs_integrity_child_birth_date_more_than_man_maxi=' Âge à la naissance d''un enfant supérieur'+_CRLF+
    ' à l''âge maximum pour un homme: @ARG ans.';
  rs_integrity_child_birth_date_more_than_woman_maxi=' Âge à la naissance d''un enfant supérieur'+_CRLF+
    ' à l''âge maximum pour une femme: @ARG ans.';
  rs_integrity_individual_event_before_birth=' Événement individuel avant la naissance.';
  rs_integrity_individual_event_after_death=' Événement individuel après le décès.';
  rs_integrity_family_event_before_birth=' Événement familial avant la naissance.';
  rs_integrity_family_event_after_death=' Événement familial après le décès.';
  rs_integrity_woman_must_have_two_children_in_more_than_days=' Une femme ne peut normalement avoir'+_CRLF+
    ' deux enfants en moins de @ARG jours.';
  rs_integrity_child_born_more_than_270_days_after_father_death=' Enfant né plus de 270 jours après le décès de son père.';
  rs_integrity_child_born_after_mother_death=' Enfant né après le décès de sa mère.';
  rs_Caption_Add_a_city = 'Ajout d''une ville';
  rs_Caption_Add_to_favorites = 'Ajout aux Favoris';
  rs_Caption_Age_on_first_union = 'Âge à la première union: @ARG';
  rs_Caption_ancestries_shown = ' ascendants affichés';
  rs_Caption_ancestries_without_parents = 'Ancêtres sans parent de @ARG.';
  rs_Caption_ancestry_from_to = 'Parenté entre @ARG et @ARG';
  rs_Caption_and_her_his_child = ' et son enfant';
  rs_Caption_and_her_his_children = ' et ses @ARG enfants';
  rs_Caption_Associating_surnames = 'Association de patronymes';
  rs_Caption_Bad_dates = 'Dates incohérentes';
  rs_Caption_Base_folder_no_path = ' - Base @ARG - Dossier @ARG: @ARG';
  rs_Caption_Birth_Death_Job = 'N·D·P';
  rs_Caption_Birthdays = 'Les anniversaires';
  rs_Caption_Brothers_Sisters = 'Frères/Soeurs (@ARG)';
  rs_Caption_Calculate_dates = 'Calculs sur les dates';
  rs_Caption_Capture_a_picture = 'Capture d''une photographie';
  rs_Caption_Central_person = 'Individu central';
  rs_Caption_Check_all = 'Tout cocher';
  rs_Caption_Childless = 'Sans postérité';
  rs_Caption_Children = 'Enfants (@ARG)';
  rs_Caption_Close_all = 'Fermer tout';
  rs_Caption_Complete_descent_of = 'Descendance complète de';
  rs_Caption_Connect = 'Connecter';
  rs_Caption_Consanguinity = 'Consanguinité';
  rs_Caption_Consult_the_file_on_another_window = 'Consulter la fiche dans une autre fenêtre';
  rs_Caption_Countries = 'Pays';
  rs_Caption_Couple = 'Couple: ';
  rs_Caption_Couple_events = 'Événements du couple :';
  rs_Caption_Couple_children = 'Enfants du couple :';
  rs_Caption_Cousins = 'Cousin(es) (@ARG)';
  rs_Caption_Cousin_of = 'Cousin de @ARG';
  rs_Caption_Cousins_of = 'Cousins de @ARG';
  rs_Caption_Create_Child='Création d''un enfant.';
  rs_Caption_Create_Joint='Création d''un conjoint.';
  rs_Caption_Create_Father='Création du père.';
  rs_Caption_Create_Mother='Création de la mère.';
  rs_Caption_Create_Person='Création d''un individu.';
  rs_Caption_Create_Witness='Création d''un individu cité.';
  rs_Caption_Create_your_thema_in = 'Créez votre thème dans @ARG' ;
  rs_Caption_Ctrl_F_in_city_and_division_selects_a_favorite_site = 'Le raccourci Ctrl+F dans Ville ou Subdivision présélectionne un lieu favori';
  rs_Caption_Database_source_version_no = 'Base origine version @ARG';
  rs_Caption_Default_config_makes_exporting_everything =
                        'Par défaut tous les éléments sont exportés.'+_CRLF
                        +'Vous pouvez choisir ci-dessous de ne pas exporter certains éléments'+_CRLF
                        +'en décochant les cases correspondantes.'+_CRLF
                        +'Les événements à exporter sont définis dans la liste des "Événements'+_CRLF
                        +'standards Gedcom" modifiable par le menu Configuration ci-dessus.';
  rs_Caption_Default_config_makes_importing_everything = 'Par défaut tous les éléments sont importés.'+_CRLF
                        +'Vous pouvez choisir ci-dessous de ne pas importer certains éléments'+_CRLF
                        +'en décochant les cases correspondantes.'+_CRLF+_CRLF
                        +'Les événements à importer sont définis dans la liste des "Événements'+_CRLF
                        +'standards Gedcom" modifiable par le menu Configuration ci-dessus.';
  rs_Caption_Degrees_of_ancestry_to_SOSA_no_1_female = 'Parente à (@ARG) degrés du Sosa n°1';
  rs_Caption_Degrees_of_ancestry_to_SOSA_no_1_male = 'Parent à (@ARG) degrés du Sosa n°1';
  rs_Caption_Delete_current_filter ='Supprimer le filtre en cours';
  rs_Caption_Delete_selected_person_s_files = 'Supprimer les @ARG fiches sélectionnées';
  rs_Caption_Delete_selected_person_s_file = 'Supprimer la fiche sélectionnée';
  rs_Caption_Departments = 'Départements';
  rs_Caption_Describe_you_can_press_arg_chars = 'Description : reste à taper @ARG caractères';
  rs_Caption_Descending_at_arggeneration_female  = 'Descendante à @ARG @ARG du Sosa n°1';
  rs_Caption_Descending_at_arggeneration_male = 'Descendant à @ARG @ARG du Sosa n°1';
  rs_Caption_Descending_tree = 'Arbre de descendance';
  rs_Caption_Descent_from_the = 'Descendance par les ';
  rs_Caption_Destination_Persons = ' Destination : @ARG individus ';
  rs_Caption_Details_of_event = 'Détails de l''événement';
  rs_Caption_Directory_showing_folder_s_persons = 'Répertoire des individus du dossier en cours';
  rs_Caption_Disconnect = 'Déconnecter';
  rs_Caption_Duplicated_cities = 'Liste des villes en double';
  rs_Caption_Environment_Family_of = 'Environnement familial de ';
  rs_Caption_eandvents_on_the_list = ' é&vénements dans la liste';
  rs_Caption_Error_on_a_date = 'Erreur dans une date.';
  rs_Caption_Events_order = 'Ordre des événements';
  rs_Caption_Event_s_sources = 'Sources de l''événement @ARG';
  rs_Caption_Executing_requests_on_database = 'Exécution de requêtes. Base: @ARG';
  rs_Caption_Exe_database = 'Exe: @ARG, Base: @ARG';
  rs_Caption_Export = 'Exporter';
  rs_Caption_Export_from_arg = 'Exporter à partir de : @ARG';
  rs_Caption_Export_in_table_from_textfile = 'Exportation de @ARG dans un fichier texte';
  rs_Caption_Filter_events_of_this_type = 'Filtrer les événements du type suivant:';
  rs_Caption_folder_infos = 'Informations sur le dossier';
  rs_Caption_File_is_not_a_gedcom = 'Le fichier @ARG'+ _CRLF + ' n''est pas un fichier GEDCOM';
  rs_Caption_Grandchildren = 'Petits enfants (@ARG)';
  rs_Caption_Has_got_father = 'A pour père : ';
  rs_Caption_Has_got_mother = 'A pour mère : ';
  rs_Caption_Have_a_look_at_person = 'Consulter la fiche de @ARG';
  rs_Caption_Her_his_child = 'Son enfant';
  rs_Caption_Her_his_children = 'Ses @ARG enfants';
  rs_Caption_Her_his_father = 'Son père';
  rs_Caption_Her_his_joint = 'Son conjoint';
  rs_Caption_Her_his_joints = 'Ses @ARG conjoints';
  rs_Caption_Her_his_mother = 'Sa mère';
  rs_Caption_Her_his_parents = 'Ses parents';
  rs_Caption_Herself = 'Elle : @ARG';
  rs_Caption_Himself = 'Lui : @ARG';
  rs_Caption_History_Events = 'Histoire : @ARG événements.';
  rs_Caption_History_module_is_empty_Clic_on_Import_button = 'Votre module d''histoire est vide,'
                     +' cliquez sur le bouton Importer pour ajouter un dictionnaire.';
  rs_Caption_History_No_event = 'Histoire : pas d''événement.';
  rs_Caption_History_No_event_in_folder_change_folder_or_import = 'Pas d''événement dans cette catégorie,'
                     +' changez de catégorie ou'
                     +' cliquez sur le bouton Importer pour ajouter un dictionnaire.';
  rs_Caption_History_One_event = 'Histoire : un événement.';
  rs_Caption_Import = 'Importer';
  rs_Caption_Import_in_table_from_textfile = 'Importation dans @ARG depuis un fichier texte.';
  rs_Caption_Import_Medias_some_copy_of_pictures_will_be_set_in_database =
             'En cas d''importation des médias, une copie des images sera intégrée'+_CRLF
            +'dans la base comme il est défini dans les "détails" de ce dossier.';
  rs_Caption_Import_Medias_only_address_and_icon_will_be_set_in_database =
  'En cas d''importation des médias, seules l''adresse et une icône seront intégrées'+_CRLF
            +'dans la base comme il est défini dans les "détails" de ce dossier.';
  rs_Caption_Importing_table_of_records_in_progress = 'Importation @ARG @ARG/@ARG en cours...';
  rs_Caption_Invalid_date_or_value = 'Date ou valeur invalide.';
  rs_Caption_Itself_union = 'Elle : @ARG';
  rs_Caption_Joints = 'Conjoints (@ARG)';
  rs_Caption_keyboard_shortcuts = 'Raccourcis de saisie';
  rs_Caption_Known_unions = '@ARG unions connues';
  rs_Caption_Known_children = '@ARG enfants connus';
  rs_Caption_Own_at_the_same_address = 'Habitent à la même adresse...';
  rs_Caption_Persons_with_an_event_in_the_site = 'Individus ayant eu un événement dans ce lieu.';
  rs_Caption_Label_of_other_events_of_persons = 'Libellés des événements divers individuels';
  rs_Caption_Label_of_other_events_of_families = 'Libellés des événements divers familiaux';
  rs_Caption_Label_of_unions = 'Libellés de unions (mariages)';
  rs_Caption_Labels_of_default_events = 'Libellés des événements standards';
  rs_Caption_Last_job = 'Dernier métier: @ARG';
  rs_Caption_Last_persons_files = 'Fiches saisies récemment';
  rs_Caption_Linked_to_SOSA_no_1_genealogy_female  ='Liée à la généalogie du Sosa n°1';
  rs_Caption_Linked_to_SOSA_no_1_genealogy_male ='Lié à la généalogie du Sosa n°1';
  rs_Caption_List_of_acts = 'Liste des actes';
  rs_Caption_List_of_cousins = 'Liste des cousins';
  rs_Caption_List_of_isolated_persons = 'Liste des individus isolés';
  rs_Caption_List_of_probably_cloned_persons = 'Liste des individus potentiellement en double.';
  rs_Caption_List_of_unions = 'Liste des unions';
  rs_Caption_List_of_folder_unions = 'Liste des @ARG unions du dossier.';
  rs_Caption_Look_at_person_s_file = 'Consulter la fiche';
  rs_Caption_Media_s_users = 'Utilisateurs du média.';
  rs_Caption_Medias_library = 'Bibliothèque multimédia.';
  rs_Caption_Medias_library_has_gone_modified_waiting_validate = 'La bibliothèque multimédia a été modifiée : En attente de validation...';
  rs_Caption_Medias_library_consult = 'Bibliothèque multimédia : En consultation...';
  rs_Caption_men_of = 'hommes de';
  rs_Caption_men_with_daughters_of = 'hommes avec les filles de';
  rs_Caption_Menu_Children_Children_Ctrl_Menu_Parents_Children_Maj_Menu_Parents_Parents_Children = 'Menu=Enfants>Enfants|Ctrl+Menu=Parents>Enfants|Maj+Menu=Parents>Parents>Enfants';
  rs_Caption_Modify_a_city = 'Modification d''une ville';
  rs_Caption_Name_of_file_to_export = 'Nom du fichier à exporter';
  rs_Caption_Names_of_files_to_export = 'Noms des fichiers à exporter';
  rs_Caption_Neighbor_cities_in_cities_index = 'Villes voisines dans l''index des villes';
  rs_Caption_Neighbor_cities_of_in_cities_index = 'Villes voisines de @ARG dans l''index des villes';
  rs_Caption_Neighbor_sites_recorded_in_folder = 'Lieux voisins enregistrés dans ce dossier';
  rs_Caption_Nephews_Nieces = 'Neveux/Nièces (@ARG)';
  rs_Caption_New_folder = 'Nouveau dossier';
  rs_Caption_No_link_to_SOSA_no_1_genealogy = 'Sans lien à la généalogie du Sosa n°1';
  rs_Caption_None_child = 'Pas d''enfant';
  rs_Caption_None_copy_will_be_added_into_database = 'Aucune copie de l''image ne sera ajoutée dans la base lors de son chargement.';
  rs_Caption_None_joint = 'Pas de conjoint';
  rs_Caption_None_union_found = 'Aucune union.';
  rs_Caption_None_union = 'Sans alliance';
  rs_Caption_None_union_in_this_folder = 'Aucune union dans ce dossier.';
  rs_Caption_Noone_in_this_folder = 'Pas d''individu isolé dans ce dossier';
  rs_Caption_Noone_with_this_surname_in_selection = 'Aucun individu de ce patronyme dans la sélection';
  rs_Caption_Number_of_cities_by_country = 'Nombre de villes par pays';
  rs_Caption_One_copy_will_be_added_into_database_loading_itself = 'Une copie de l''image sera ajoutée dans la base lors de son chargement.';
  rs_Caption_One_known_child = 'Un enfant connu';
  rs_Caption_One_person_in_this_folder = '1 individu isolé dans ce dossier';
  rs_Caption_One_person_with_this_surname_in_selection = 'Un seul individu porte ce patronyme dans la sélection';
  rs_Caption_One_union_found = 'Une seule union trouvée.';
  rs_Caption_One_union_in_this_folder = 'Une seule union dans ce dossier.';
  rs_Caption_On_families = 'familiaux';
  rs_Caption_On_family_events = 'év.familiaux';
  rs_Caption_On_persons = 'sur individus';
  rs_Caption_On_persons_events = 'à ev.individuels';
  rs_Caption_On_sources = 'sur sources';
  rs_Caption_One_eandvent_on_the_list = '1 é&vénement dans la liste';
  rs_Caption_One_known_union ='Une union connue';
  rs_Caption_One_person_on_the_list = '1 individu dans la liste';
  rs_Caption_One_andperson_on_the_list = '1 &individu dans la liste';
  rs_Caption_Only_one_ancestry_shown = 'Un seul ascendant affiché';
  rs_Caption_Open_the_person_s_file = 'Ouvrir la fiche';
  rs_Caption_Open_the_person_s_file_double_click = 'Ouvrir la fiche (ou dbl-click)';
  rs_Caption_Original_source = ' Origine ';
  rs_Caption_Panel_disabled = 'Panneau'+_CRLF+'verrouillé';
  rs_Caption_Panel_enabled = 'Panneau'+_CRLF+'déverrouillé';
  rs_Caption_Percent = '@ARG %';
  rs_Caption_Person_s_file_in_consult_mode = 'Fiche individu en mode consultation uniquement';
  rs_Caption_Person_s_consanguinity_is_equal_to_parents_parenty = 'La consanguinité d''un individu est égale'+_CRLF+
    'à la parenté de ses parents.';
  rs_Caption_persons_with_this_surname_in_selection = '@ARG individus portent ce patronyme dans la sélection';
  rs_Caption_persons_in_this_folder = '@ARG individus isolés dans ce dossier';
  rs_Caption_persons_born_after_father_s_death = 'Individus nés après le décès de leur père';
  rs_Caption_Persons_linked_to = 'Individus ayant des liens avec';
  rs_Caption_Persons_unlinked_to = 'Individus sans lien avec';
  rs_Caption_Persons_linked_or_linked_with_central_person = 'Liste des individus avec ou sans liens avec l''individu central';
  rs_Caption_Pages_count = 'Nombre de pages: @ARG';
  rs_Caption_Persons_on_the_list = ' individus dans la liste';
  rs_Caption_Preferences = ' Préférences générales';
  rs_Caption_Preparing_to_import_on_table = 'Préparation importation @ARG...';
  rs_Caption_Printed_documents_options = 'Options des documents imprimables';
  rs_Caption_Print_out_documents = 'Documents imprimables';
  rs_Caption_Print_this_tree = 'Imprimer cet arbre';
  rs_Caption_Print_this_page = 'Imprimer cette page @ARG';
  rs_Caption_andPersons_on_the_list = ' &individus dans la liste';
  rs_Caption_Recorded_sites_on_this_folder_neighbor_of = 'Lieux enregistrés dans ce dossier, voisins de @ARG';
  rs_Caption_Refering_childness = 'Références: Filiations';
  rs_Caption_Refering_civilities = 'Références: Civilités';
  rs_Caption_Refering_particles = 'Références: Particules';
  rs_Caption_Refering_the_keywords_to_set_the_dates = 'Références: Mots clefs pour saisir les dates';
  rs_Caption_Regions = 'Régions';
  rs_Caption_Renumber = 'Renuméroter';
  rs_Caption_Reports_editing = 'Editeur de rapport Ancestromania';
  rs_Caption_Restore_database = 'Restauration base @ARG';
  rs_Caption_Roles_and_Relationships_of_the_witnesses = 'Rôles et relations des témoins';
  rs_Caption_Save_in = 'Sauvegarde dans @ARG';
  rs_Caption_Surnames_associated_with = 'Patronymes associés à : ';
  rs_Caption_Searching_a_site = 'Index des lieux';
  rs_Caption_Search_persons = 'Rechercher des individus';
  rs_Caption_Select_a_folder = 'Sélection d''un dossier';
  rs_Caption_Select_Child='Sélection d''un enfant.';
  rs_Caption_Select_Joint='Sélection d''un conjoint.';
  rs_Caption_Select_Father='Sélection du père.';
  rs_Caption_Select_the_father='Sélectionner le père';
  rs_Caption_Select_the_mother='Sélectionner la mère';
  rs_Caption_Select_Mother='Sélection de la mère.';
  rs_Caption_Select_Person='Sélection d''un individu.';
  rs_Caption_Select_Persons_to_set_this_address = 'Sélectionner les individus auxquels affecter cette adresse.';
  rs_Caption_Select_Persons_whose_set_the_media = 'Sélectionner les individus auquels affecter ce média.';
  rs_Caption_Select_starting_person = 'Sélectionner l''individu de départ.';
  rs_Caption_Select_Witness='Sélection ou création d''un individu cité.';
  rs_Caption_Session = 'Session @ARG';
  rs_Caption_Set_to_other_persons = 'Affecter à'+_CRLF+'d''autres individus';
  rs_Caption_Setting_person_as_confidential_permits_to_hide_himherself = 'Déclarer un individu comme confidentiel permet'+_CRLF+
    'de le cacher ou de cacher son identité lors'+_CRLF+
    'd''une exportation au format Gedcom.'+_CRLF+_CRLF+
    '''Sans alerte sur dates'' permet de désactiver'+_CRLF+
    'l''apparition de la fenêtre d''alerte'+_CRLF+
    'en cas d''une incohérence de dates.';
  rs_Caption_Source_Persons = ' Origine : @ARG individus ';
  rs_Caption_Sources_of_home_event = 'Sources de l''événement domicile';
  rs_Caption_SOSA_No_Generation = 'N° Sosa : @ARG - Génération : @ARG';
  rs_Caption_SOSA_No_Generation_mini = 'S @ARG - G @ARG';
  rs_Caption_SOSA_No_1_not_defined_in_folder = 'Sosa n°1 non défini dans ce dossier';
  rs_Caption_Start_tree_from_this_person = 'Démarrer l''arbre depuis cet individu';
  rs_Caption_These_persons_are_not_linked = 'Ces individus n''ont pas de liens.';
  rs_Caption_These_persons_have_no_mixed_ancestor = 'Ces individus n''ont pas d''ancêtre commun.';
  rs_Caption_Title_s_owner = 'Porteur du titre: @ARG';
  rs_Caption_Title_s_owners = 'Porteurs du titre: @ARG';
  rs_Caption_Title_you_can_press_arg_chars = 'Titre : reste à taper @ARG caractères';
  rs_Caption_Uncheck_all = 'Tout décocher';
  rs_Caption_Uncles_Aunts = 'Oncles/Tantes (@ARG)';
  rs_Caption_Unknown_genealogy_link_with_SOSA_no_1 ='Lien avec la généalogie du Sosa n°1 inconnu';
  rs_Caption_unions_found = '@ARG unions trouvées.';
  rs_Caption_Updating_father_key_of_PERSON = 'Mise à jour INDIVIDU cle_pere...';
  rs_Caption_Updating_Mother_key_of_PERSON = 'Mise à jour INDIVIDU cle_mere...';
  rs_Caption_Verify_updates = 'Vérification des mises à jour';
  rs_Caption_Without_joint_and_without_child = 'Sans conjoint ni enfant connu';
  rs_Caption_Without_witness_links = 'Sans les liens de témoins';
  rs_Caption_Witness_link_to_SOSA_no_1_female = 'Liée par témoin à la généalogie du Sosa n°1';
  rs_Caption_Witness_link_to_SOSA_no_1_male = 'Lié par témoin à la généalogie du Sosa n°1';
  rs_Caption_Who_has_this_job = 'Qui porte ce titre?';
  rs_Caption_women_of = 'femmes de';
  rs_Caption_women_with_sons_of = 'femmes avec les fils de';
  rs_Caption_You_have_disabled_this_sheet_in_Preferences = 'Vous avez désactivé cet onglet dans les "Préférences générales".'+_CRLF+_CRLF
      +'Pour le faire réapparaître, dans l''onglet "Réseau" des "Préférences générales",'+_CRLF
      +'cochez l''option "Activer onglet média même en réseau"';
  rs_Caption_You_can_add_the_father_by_drag_drop = 'On peut ajouter le père par glisser/déposer depuis le Répertoire'+_CRLF
    +'ou les fiches Recherche et Environnement familial';
  rs_Caption_You_can_add_the_mother_by_drag_drop = 'On peut ajouter la mère par glisser/déposer depuis le Répertoire'+_CRLF
    +'ou les fiches Recherche et Environnement familial';
  rs_Cat_Event = 'Événement';
  rs_Cat_Death = 'Décès';
  rs_Cat_Birth = 'Na';
  rs_Cat_Job = 'Métier';
  rs_Cat_DSCR = 'Décès';
  rs_Cat_EDUC = 'Éducation';
  rs_Cat_EMIG = '';
  rs_Cat_GRAD = '';
  rs_Cat_IDNO = '';
  rs_Cat_IMMI = '';
  rs_Cat_NATI = '';
  rs_Cat_Naturalisation = 'Naturalisation';
  rs_Cat_PROP = '';
  rs_Cat_Religion = 'Religion';
  rs_Cat_SSN = '';
  rs_Cat_Title = 'Titre';
  rs_Column_arg = 'Colonne @ARG (@ARG)';
  rs_Column_mini = 'C.';
  rs_Confirm_adding_report = 'Pour être utilisable, le rapport doit être enregistré dans la structure des répertoires d''Ancestromania.'+_CRLF+_CRLF
        +'Souhaitez-vous copier ce fichier dans le bon répertoire ?';
  rs_Confirm_address_copying = 'Confirmez-vous la copie de cette adresse ?';
  rs_Confirm_address_found_on_the_web_Do_you_want_to_record_it = 'Adresse trouvée sur Internet:'+_CRLF
              +'@ARG'+_CRLF+_CRLF
              +'Voulez-vous enregistrer @ARG les coordonnées de ce lieu?';
  rs_Confirm_copying_media = 'Confirmez-vous la copie de ce média ?';
  rs_Confirm_this_deleting = 'Confirmez-vous cette suppression?';
  rs_Confirm_folder_copy_in = 'Voulez vous copier le dossier courant dans ';
  rs_Confirm_folder_replace = 'Confirmez-vous le remplacement du dossier courant ?';
  rs_Confirm_deleting_database = 'Cette commande va supprimer tous vos dossiers!!'+_CRLF+_CRLF+
   'Confirmez-vous la réinitialisation de votre base de données ?';
  rs_Confirm_deleting_every_events_and_other = 'Cette action supprimera tous les événements associés à cette fiche : adresses, actes, etc...';
  rs_Confirm_deleting_folder = 'Si vous continuez, tout le contenu de cette généalogie sera perdu !'+_CRLF+_CRLF
    +'Confirmez-vous le vidage ou la suppression de ce dossier ?';
  rs_Confirm_deleting_favorite_shortcuts ='Confirmez-vous la suppression des liens vers vos individus favoris ?';
  rs_Confirm_deleting_selected_files ='Confirmez-vous la suppression des @ARG fiches sélectionnées?';
  rs_Confirm_deleting_selected_file = 'Confirmez-vous la suppression de la fiche sélectionnée?';
  rs_Confirm_deleting_document = 'Confirmez-vous la suppression de ce document?';
  rs_Confirm_deleting_selected_cities ='Confirmez-vous la suppression des @ARG villes sélectionnées?';
  rs_Confirm_deleting_selected_city = 'Confirmez-vous la suppression de cette ville?';
  rs_Confirm_deleting_selected_persons_files ='Confirmez-vous la suppression des @ARG fiches individu?';
  rs_Confirm_deleting_selected_person_file ='Confirmez-vous la suppression de cette fiche individu?';
  rs_Confirm_deleting_this_event = 'Confirmez-vous la suppression'+_CRLF+
      'de cet événement?';
  rs_Confirm_deleting_this_media_with_links_deleting = 'La suppression de ce média'+_CRLF+
    '@ARG'+_CRLF+'supprimera aussi tous les liens de ce media..'+_CRLF+_CRLF+
    'Confirmez-vous cette suppression ?';
  rs_Confirm_deleting_this_witness_associated_with = 'Confirmez-vous la suppression de ce témoin associé à';
  rs_Confirm_deleting_this_child = 'Confirmez-vous la suppression de cet enfant :';
  rs_Confirm_deleting_this_civility = 'Voulez-vous supprimer cette civilité?' ;
  rs_Confirm_deleting_this_keyword = 'Voulez-vous supprimer ce mot clef?';
  rs_Confirm_deleting_this_particle = 'Voulez-vous supprimer cette particule?' ;
  rs_Confirm_executing_full_medias_renaming = 'Ce renommage complet n''est utile que si vous avez placé correctement'+_CRLF+
                                              'vos nouveaux médias dans le répertoire de la base.'+_CRLF+
                                              'Confirmez-vous l''exécution de renommage de répertoires ?';
  rs_Confirm_executing_this_option = 'Confirmez-vous l''exécution de cette option?';
  rs_Confirm_executing_this_action = 'Confirmez-vous l''exécution de cette fonction?';
  rs_Confirm_father_s_link = 'Confirmez-vous qu''il est aussi son père?';
  rs_Confirm_importing_textfile_into_data = 'Confirmez-vous l''importation des données'+_CRLF
    +'du fichier texte dans la base de données?';
  rs_Confirm_is_not_the_father_of = 'Confirmez-vous que'+_CRLF+ '@ARG'+_CRLF+ 'n''est pas le père de';
  rs_Confirm_is_not_the_mother_of = 'Confirmez-vous que'+_CRLF+ '@ARG'+_CRLF+ 'n''est pas la mère de';
  rs_Confirm_she_is_the_mother_too = 'Confirmez-vous qu''elle est aussi sa mère?';
  rs_Confirm_link_will_be_deleted = 'En confirmant, le lien avec ces parents sera brisé.' ;
  rs_Confirm_links_will_be_deleted = 'En confirmant, les liens avec ces parents seront brisés.';
  rs_Confirm_Pictures_reload_option_do_you_reload_with_this_mode  = 'Cette option recharge tous les documents dans la médiathèque à partir'+_CRLF
    +'des fichiers dont l''adresse est mémorisée. Cette adresse est celle du'+_CRLF
    +'fichier ayant servi au chargement initial, éventuellement modifiée en'+_CRLF
    +'utilisant la fonction "Remplacer chemin".'+_CRLF
    +'Il est donc nécessaire que ces fichiers existent aux adresses mémorisées,'+_CRLF
    +'sans cela les enregistrements concernés dans la médiathèque seront inchangés.'+_CRLF+_CRLF
    +'En mode "Avec copies des images", une version compressée des fichiers de type'+_CRLF
    +'image (fichiers d''extension bmp, jpg, jpeg, png, tif ou tiff) sera conservée'+_CRLF
    +'dans la base de données. Cette option augmente en conséquence la taille'+_CRLF
    +'de la base de données mais permet d''afficher les images dans le logiciel,'+_CRLF
    +'même en l''absence des fichiers originaux.'+_CRLF
    +'L''exécution de cette fonction met à jour le paramètre correspondant dans'+_CRLF
    +'les "détails" du dossier.'+_CRLF+_CRLF
    +'Voulez-vous recharger la médiathèque dans ce mode?';
  rs_Confirm_Creating_SOSA_from_selected_person  = 'Voulez-vous renuméroter les SOSA à partir de l''individu courant ?';
  rs_Confirm_Creating_SOSA_from_first_imported_person  = 'Voulez-vous renuméroter les SOSA à partir de la première personne importée ?';
  rs_Confirm_Documents_reload_option_do_you_reload_with_this_mode  = 'Cette option recharge tous les documents dans la médiathèque à partir'+_CRLF
    +'des fichiers dont l''adresse est mémorisée. Cette adresse est celle du'+_CRLF
    +'fichier ayant servi au chargement initial, éventuellement modifiée en'+_CRLF
    +'utilisant la fonction "Remplacer chemin".'+_CRLF
    +'Il est donc nécessaire que ces fichiers existent aux adresses mémorisées,'+_CRLF
    +'sans cela les enregistrements concernés dans la médiathèque seront inchangés.'+_CRLF+_CRLF
    +'En mode "Sans copies des images", seules l''adresse du fichier et une icône'+_CRLF
    +'sont conservées dans la base de données. Dans le cas des fichiers de type'+_CRLF
    +'image (fichiers d''extension bmp, jpg, jpeg, png, tif ou tiff) l''icône est'+_CRLF
    +'remplacée par une image réduite (format photo d''identité). Cette option'+_CRLF
    +'permet de diminuer la taille de la base de données mais nécessite la présence'+_CRLF
    +'des fichiers originaux aux mêmes adresses pour les afficher dans l''onglet'+_CRLF
    +'"Médias" et divers états du logiciel.'+_CRLF
    +'L''exécution de cette fonction met à jour le paramètre correspondant dans'+_CRLF
    +'les "détails" du dossier.'+_CRLF+_CRLF
    +'Voulez-vous recharger la médiathèque dans ce mode?';
  rs_Confirm_media_unlink_from_event = 'Confirmez-vous le détachement de ce média de l''événement en cours?';
  rs_Confirm_quitting_ancestromania = 'Confirmez-vous votre sortie d''Ancestromania ?';
  rs_Confirm_recording_this_person = 'Souhaitez-vous enregistrer cette personne ?';
  rs_Confirm_replacing = 'Confirmez-vous le remplacement?';
  rs_Confirm_supressing_database_readonly =
   'Êtes-vous certain d''enlever l''attribut "lecture seule" de cette base de données?';
  rs_Confirm_deleting_union = 'Confirmez-vous la suppression de cette union avec';
  rs_Confirm_your_selection = 'Confirmez-vous votre sélection ?';
  rs_Confirm_Option_which_consists_in_replacing_joint_in_union_and_parents =
      'Cette option permet de remplacer le conjoint en cours'+_CRLF
      +'dans l''union ainsi que comme père ou mère des enfants.' ;
  rs_Confirm_SOSA_renumbering = 'Confirmez-vous le lancement de la renumérotation SOSA ?';
  rs_Confirm_SOSA_deleting = 'Confirmez-vous la suppression de la numérotation SOSA ?';
  rs_Confirm_this_function_updates_city_names_departments_countries_etc = 'Cette fonction met à jour les noms des villes, départements, regions, pays'+_CRLF
    +'et codes postaux (s''ils sont vides) de tous les événements et domiciles.'+_CRLF
    +'Les lieux sont identifiés par leur pays et leur code INSEE.'+_CRLF;
  rs_Confirm_this_function_updates_geographic_coord_of_every_events_and_sites = 'Cette fonction met à jour les coordonnées géographiques de tous'+_CRLF
    +'les événements et domiciles.'+_CRLF
    +'Les lieux sont identifiés par le nom du pays, le code INSEE, le code'+_CRLF
    +'postal, le nom de la ville et éventuellement celui de la subdivision.'+_CRLF
    +'Il est donc préférable de mettre à jour ces champs avant d''exécuter'+_CRLF
    +'cette fonction.';
  rs_Confirm_unlinking_this_actual_home_media = 'Confirmez-vous le détachement de ce média du domicile en cours?';
  rs_Confirm_update = 'Validation des modifications.';
  rs_Choose_notes_file = 'Choisissez le fichier des notes';
  rs_Database = 'Base';
  rs_Database_copied_in = 'La copie s''est bien effectuée dans';
  rs_Database_must_be_updated = 'Base pas à jour';
  rs_Dead_female = 'Décédée';
  rs_Dead_male = 'Décédé';
  rs_Death_date_unknown = 'Date de décès inconnue';
  rs_Death_in_female = 'Décédée à @ARG';
  rs_Death_in_male = 'Décédé à @ARG';
  rs_Death_on = 'Décédé(e) le @ARG';
  rs_Death_on_female = 'Décédée le @ARG';
  rs_Death_on_male = 'Décédé le @ARG';
  rs_Destination_Persons_count = ' Destination : @ARG individus ';
  rs_Directory_of_Medias = 'Répertoire de base des médias:';
  rs_Do_you_create_it = 'Voulez-vous le créer?';
  rs_Do_you_configure_this_action_to_default_in_software =
      'Ce n''est pas l''option de saisie choisie dans les préférences générales.'+_CRLF+_CRLF
          +'Voulez vous aussi mettre à jour la configuration?';
  rs_Do_you_delete_this_address ='Voulez-vous supprimer cette adresse ?';
  rs_Do_you_delete_this_label = 'Voulez-vous supprimer ce libellé?';
  rs_Do_you_delete_this_name = 'Voulez-vous supprimer ce patronyme?';
  rs_Do_you_delete_this_shortcut_input = 'Voulez-vous supprimer ce raccourci de saisie?';
  rs_Do_you_delete_this_child_link = 'Voulez-vous supprimer cette filiation?';
  rs_Do_you_delete_the_content_of_this_notebook = 'Voulez-vous effacer le contenu de ce bloc-notes?';
  rs_Do_you_Validate = 'Voulez-vous valider les modifications effectuées?';
  rs_Do_you_continue = 'Voulez-vous continuer ?';
  rs_Do_you_continue_executing = 'Voulez-vous tout de même poursuivre l''exécution?';
  rs_Do_you_ignore_case_difference = 'Le remplacement doit-il ignorer la différence de casse?';
  rs_Do_you_overwrite_it = 'Souhaitez-vous l''écraser ?';
  rs_Do_you_replace_media_by_other_media_file_with_name = 'Le fichier @ARG'+_CRLF
          +'figure déjà dans la bibliothèque des médias.'+_CRLF+_CRLF
          +'Voulez-vous en charger une autre version ?';
  rs_Do_you_record_unless = 'Voulez-vous quand même l''enregistrer?';
  rs_Do_you_reset_the_menu = 'Voulez-vous réinitialiser la barre ';
  rs_Do_you_save_the_changes = 'Souhaitez-vous enregistrer les modifications ?';
  rs_Do_you_update_export_list_with_confidential_persons =
          'Souhaitez-vous mettre à jour la liste des exclusions de l''exportation'+_CRLF
    +'avec la liste des individus confidentiels?';
  rs_Do_you_validate_changed_data = 'Des données ont changé.'+_CRLF+_CRLF+
      'Voulez-vous les valider ?';
  rs_Do_you_want_to_delete_logbook = 'Voulez-vous vider le journal ?';
  rs_Do_you_want_to_see_bad_formated_dates = 'Cette fonction permet de lister les erreurs de dates.'+_CRLF
    +'Les erreurs de format dues à la saisie et les erreurs'+_CRLF
    +'dues à des valeurs incohérentes sont listées séparément.'+_CRLF+_CRLF
    +'Voulez-vous voir d''abord les erreurs de format de saisie?';
  rs_did_you_copy_this_database_before_updating = 'Avez-vous sauvegardé cette base de données avant d''effectuer cette mise à jour?';
  rs_Error_Disk_space_not_Enough_You_have_bytes = 'L''espace disque, n''est pas suffisant pour l''optimisation.'+_CRLF+_CRLF
          +'Il ne vous reste que @ARG octets disponibles sur votre disque.';
  rs_Error = 'Erreur';
  rs_Error_address_transfer = 'Erreur transfert adresse n° ';
  rs_Error_Access_refused = 'Accès interdit.';
  rs_Error_Address_Cannot_be_obtained = 'L''adresse et les coordonnées du lieu ne peuvent être obtenues.';
  rs_Error_Bad_URL = 'Mauvaise URL : @ARG';
  rs_Error_Bad_request = 'Mauvaise requête';
  rs_Error_Bad_Gateway = 'Mauvaise passerelle';
  rs_Error_Bad_Web_Connection='Problème de connexion internet.';
  rs_Error_Bad_Connection='Problème de connexion à @ARG.';
  rs_Error_City_not_found = 'La ville de: @ARG n''a pas été trouvée.';
  rs_Error_No_site_found_on_the_web = 'Sur internet, aucun lieu ne correspond à cette adresse.';
  rs_Error_No_Info_of_udpate_for_your_software = 'Aucune information de mise à jour sur internet pour votre programme.';
  rs_Error_Update_info_not_possible = 'La vérification d''une mise à jour par internet'+_CRLF
        +'ne peut être effectuée.';
  rs_Error_Web_site_unaccessible = 'Le site ne répond pas.';
  rs_Error_Site_found_but_in_this_city = 'Lieu trouvé, mais dans la ville de:';
  rs_Error_Subd_not_found_in_city = 'La subdivision @ARG n''a pas été trouvée à @ARG.';
  rs_Error_Two_many_times_to_respond = 'Problème de délai de réponse.';
  rs_Error_XML_of_Google_API = 'Erreur lors du traitement de la réponse XML.'+_CRLF+_CRLF
            +'Réponse complète de l''Api Google:';
  rs_Error_Bad_format_or_cannot_create_temp_file = 'Mauvais format enregistré ou impossible de créer le fichier temporaire.';
  rs_Error_Cannot_backup_because_there_is_no_Gbak_exe = 'Sauvegarde initiale de la base réseau impossible,'+_CRLF
          +'@ARG est absent de ce poste.';
  rs_Error_Cannot_begin_backup= 'La sauvegarde initiale de la base a échoué.';
  rs_Error_GBak_backup_aborted = 'La sauvegarde initiale de la base avec @ARG a échoué.';
  rs_Error_Cannot_copy_address='Impossible de copier l''adresse.';
  rs_Error_Cannot_copy_Database_folder = 'La copie ne peut être effectuée car ces dossiers'+_CRLF
                      +'utilisent des langues différentes.'+_CRLF+_CRLF
                      +'Utilisez l''importation d''un dossier.';
  rs_Error_Cannot_copy_Media = 'Impossible de copier le média :';
  rs_Error_Cannot_create_this_directory = 'Ce répertoire ne peut être créé.';
  rs_Error_Cannot_delete_Logbook = 'Impossible de purger le journal';
  rs_Error_Cannot_launch_with_readonly_database = 'Impossible de lancer Ancestromania avec une base en lecture seule.';
  rs_Error_Cannot_load_corrupted_file = 'Impossible de lire le fichier. Il est corrompu.';
  rs_Error_Cannot_read_this_file = 'Impossible de lire ce fichier !';
  rs_Error_Cannot_scan_No_source =  'Aucune source Twain installée.'+_CRLF
      +'Acquisition impossible';
  rs_Error_Cannot_Update_Database = 'Impossible de mettre à jour la base';
  rs_Error_Cannot_Validate_on_database = 'Erreur BASE : Impossible de valider...';
  rs_Error_Cannot_verify_update = 'La vérification d''une mise à jour par internet'+_CRLF
                +'ne peut être effectuée.';
  rs_Error_Child_link_not_to_be_empty_or_spaces_filled = 'La filiation ne doit pas être vide ou constituée uniquement d''espaces.';
  rs_Error_Civilit_not_to_be_empty_or_spaces_filled = 'La civilté ne doit pas être vide ou constituée uniquement d''espaces.';
  rs_Error_Closing = 'Erreur de fermeture de';
  rs_Error_Database_not_copied = 'La copie n''a pas pu se faire.';
  rs_Error_Default_country_not_found = 'Pays par défaut inconnu.';
  rs_Error_Deleting_joint_with_child_is_forbidden = 'Suppression d''un conjoint avec enfant(s) interdite.'+_CRLF+
                'Supprimez d''abord les liens du conjoint avec les enfants.';
  rs_Error_different_language_for_dates = 'La langue utilisée pour la saisie des dates dans le dossier d''origine'+_CRLF
          +'est différente de celle du dossier en cours.'+_CRLF
          +'Utilisez plutôt le transfert par un fichier gedcom.';
  rs_Error_Directory_name_empty = 'Ce répertoire doit avoir un nom.';
  rs_Error_Directory_cannot_be_created = 'Le répertoire @ARG ne peut être créé.';
  rs_Error_Document_opened_in_other_form = 'Ce document est en cours de modification dans une autre fiche.';
  rs_Error_request_error = 'Erreur @ARG : Problème de requête..';
  rs_Error_Every_Medias_adresses_in_library_and_homes_begining_by_will_be_modified =
                   'Toutes les adresses de médias mémorisées dans la bibliothèque et dans les domiciles'+_CRLF
                  +'qui commencent par @ARG seront modifiées.';
  rs_Error_Execute_line = 'Erreur d''exécution ligne ';
  rs_Error_Execute_Only_one_Ancestromania_session =
  'N''exécutez qu''une seule session d''Ancestromania depuis'+_CRLF
      +'un même fichier exécutable.'+_CRLF+_CRLF
      +'Pour exécuter plusieurs sessions simultanément, renommez une'+_CRLF
      +'copie d''Ancestromania.exe sous un autre nom (Ancestromania2.exe'+_CRLF
      +'par exemple) dans le même répertoire et exécutez ce fichier.'+_CRLF+_CRLF
      +'Rappels :'+_CRLF
      +'A partir de sa version 2.5, Firebird embedded autorise l''exécution de'+_CRLF
      +'plusieurs sessions d''Ancestromania selon les conditions ci-dessus.'+_CRLF
      +'Mais pour accéder simultanément à la base depuis des applications situées'+_CRLF
      +'dans un répertoire différent de celui d''Ancestromania, il est nécessaire'+_CRLF
      +'d''installer Firebird version serveur et de désactiver la version embedded'+_CRLF
      +'installée par défaut avec Ancestromania.'+_CRLF
      +'En cas d''accès à la même fiche individu depuis deux sessions différentes,'+_CRLF
      +'une seule doit modifier la fiche.'+_CRLF
      +'Certaines opérations globales, comme l''optimisation, exigent'+_CRLF
      +'qu''une seule session soit connectée à la base.';
  rs_Error_Exporting_medias = 'Erreur lors de l''exportation des médias.';
  rs_Error_Family_event_transfer = 'Erreur transfert événement familial n° ';
  rs_Error_Family_events_have_not_been_updated = 'Les événements individuels n''ont pas été mis à jour.';
  rs_Error_Father_cannot_be_a_woman = 'Le père d''un individu ne peut pas être une femme.';
  rs_Error_File_is_not_on_the_web_site = 'Le fichier que vous essayez de télécharger est absent du site.';
  rs_Error_File_format = 'Erreur de format du fichier:';
  rs_Error_File_named_doesnt_exists_Please_select_your_database_file =
  'Le fichier demandé : @ARG n''existe pas.'+_CRLF+_CRLF+
          'Sélectionnez le fichier de votre base de données dans l''écran suivant.';
  rs_Error_Firebird = 'Erreur Firebird';
  rs_Error_FMain_Message_not_processed = 'Message reçu par la fenêtre principale et non traité:';
  rs_Error_Folders_not_defined = 'Dossier d''origine ou de destination non défini.';
  rs_Error_Forbidden_Access = 'Acces interdit';
  rs_Error_Import_forbidden = 'Importation interdite:';
  rs_Error_Individual_events_have_not_been_updated = 'Les événements individuels n''ont pas été mis à jour.';
  rs_Error_Initializing_Internet_Update ='Erreur au cours de l''initialisation de MajInternet';
  rs_Error_Has_append_during_restore = 'Une erreur s''est produite pendant l''optimisation.'+_CRLF+_CRLF
        +'Vérifiez que vous possédez les droits d''administration'+_CRLF
        +'de cette base pour exécuter cette opération.';
  rs_Error_key_of_table_must_be_set_to_import = ', champ clef de la table @ARG'+_CRLF
            +'doit être affecté pour faire l''importation !';
  rs_Error_Label_not_to_be_empty_or_spaces_filled = 'Le libellé ne doit pas être vide ou constitué uniquement d''espaces.';
  rs_Error_Latitud_must_be_a_number = 'La valeur de la latitude n''est pas numérique.';
  rs_Error_Latitud_interval = 'La valeur de la latitude doit être comprise entre -90° et 90°.';
  rs_Error_Launching = 'Erreur de lancement de';
  rs_Error_Loading = 'Erreur de chargement de';
  rs_Error_Longitud_interval = 'La valeur de la longitude doit être comprise entre -180° et 180°.';
  rs_Error_Link_transfer = 'Erreur transfert association n° ';
  rs_Error_MD5 = 'Le fichier téléchargé n''est pas correct.'+_CRLF+_CRLF+
          'Recommencez le téléchargement.';
  rs_Error_Memory = 'Erreur mémoire';
  rs_Error_Media_number_transfer = 'Erreur transfert média n° ';
  rs_Error_Mother_cannot_be_a_woman = 'La mère d''un individu ne peut pas être un homme.';
  rs_Error_Must_record_file_before_deleting = 'Vous devez enregistrer les modifications de la fiche en cours'+_CRLF
        +'avant de supprimer des individus.';
  rs_Error_Must_Select_one_record_s_type_to_list = 'Vous devez sélectionner au moins un type d''actes à lister.';
  rs_error_need_disk_space_to_continue = 'L''espace disque, n''est pas suffisant pour sauvegarder'+_CRLF+_CRLF
              +'Il ne vous reste que @ARG octets disponibles sur votre lecteur de sauvegarde.';
  rs_error_need_disk_space_to_continue_directory_cannot_be_created = 'Sauvegarde initiale de la base impossible, le répertoire de sauvegarde'+_CRLF
        +'@ARG'+_CRLF
        +'ne peut être créé.';
  rs_Error_Name_not_to_be_empty_or_spaces_filled = 'Le patronyme ne doit pas être vide ou constitué uniquement d''espaces.';
  rs_Error_must_not_to_be_empty = '@ARG ne doit pas être vide.';
  rs_Error_None_printer_turned_on = 'Il n''y a aucune imprimante disponible.';
  rs_Error_No_update_info = 'Aucune information de mise à jour sur internet pour votre programme.';
  rs_Error_None_Coord_of = 'Il manque les coordonnées géographiques de @ARG';
  rs_Error_None_File = 'Le fichier @ARG'+_CRLF+'est absent !';
  rs_Error_None_picture_for_this_document = 'Pas d''image pour ce document.';
  rs_Error_Not_enough_space_only_bytes_but_bytes_needed =
             'L''espace disponible sur le support choisi n''est pas suffisant.'+_CRLF
            +'Il ne reste que @ARG octets alors que @ARG sont nécessaires.';
  rs_Error_Overflow_capacity = 'Erreur dépassement capacité';
  rs_Error_One_Error_has_occured_while_optimising_Verify_if_you_are_admin = 'Une erreur s''est produite pendant l''optimisation.'+_CRLF+_CRLF
      +'Vérifiez que vous possédez les droits d''administration'+_CRLF
      +'de cette base pour exécuter cette opération.';
  rs_Error_On_request = 'Erreur sur la requête - @ARG';
  rs_Error_Parances_file_isnt_downloadable = 'Le fichier PARANCES.FDB que vous essayez de télécharger est absent du site.'+_CRLF+_CRLF+
                  'Réessayez plus tard.';
  rs_Error_Particle_not_to_be_empty_or_spaces_filled = 'La particule ne doit pas être vide ou constituée uniquement d''espaces.';
  rs_Error_Period_must_be_set = 'La période est obligatoire...';
  rs_Error_person_cannot_be_the_couple = 'L''individu ne peut pas être à la fois lui même et son conjoint.';
  rs_Error_person_cannot_be_himself_and_the_father = 'L''individu ne peut pas être à la fois lui même et son père.';
  rs_Error_person_cannot_be_herself_and_the_mother = 'L''individu ne peut pas être à la fois lui même et sa mère.';
  rs_Error_person_cannot_be_itself_and_the_child = 'L''individu ne peut pas être à la fois lui même et son enfant.';
  rs_Error_person_cannot_be_itself_and = 'L''individu ne peut pas être à la fois lui même et ';
  rs_Error_person_opened_in_other_form = 'Cet individu est en cours de modification dans une autre fiche.';
  rs_Error_person_event_transfer = 'Erreur transfert événement individuel n° ';
  rs_Error_person_transfer_with_NIP = 'Erreur transfert individu NIP ';
  rs_Error_person_cle_pere_father_key = 'Erreur mise à jour cle_pere';
  rs_Error_person_cle_mere_mother_key = 'Erreur mise à jour cle_mere';
  rs_Error_please_set_a_name = 'Merci d''indiquer un patronyme pour cet individu.';
  rs_Error_reading_favorite_sites = 'Erreur lors de la lecture des lieux favoris.';
  rs_Error_request_execute = 'Erreur lors de l''exécution de la requête @ARG';
  rs_Error_request_syntax = 'Erreur de conception de la requête';
  rs_Error_Restore_Directory_does_not_exists =
          'Opération impossible, le répertoire de sauvegarde'+_CRLF
        +'@ARG'+_CRLF+'n''existe pas et ne peut être créé.';
  rs_Error_Same_folders = 'Dossiers d''origine et de destination identiques.';
  rs_Error_Set_Old_and_new_path_before_asking_replacing = 'Indiquez l''ancien et le nouveau chemin'+_CRLF
                +'avant de demander le remplacement.';
  rs_Error_script_execute = 'Erreur lors de l''exécution du script';
  rs_Error_Sites_base_is_unavailable_it_doesnt_exists = 'La base de référence des lieux n''est pas accessible.'+_CRLF
          +'Elle n''est pas visible par l''application pas à l''adresse :'+_CRLF
          +'@ARG.'+_CRLF
          +'Sans cet accès, l''aide à la saisie des lieux est limitée aux lieux déjà utilisés.'+_CRLF+_CRLF
          +'Si votre ordinateur est connecté à internet, vous avez la possibilité de le'+_CRLF
          +'télécharger et de l''installer directement.'+_CRLF
          +'Voulez-vous le télécharger et l''installer maintenant?';
  rs_Error_Sites_base_is_unavailable_it_exists = 'La base de référence des lieux n''est pas accessible.'+_CRLF
          +'Elle existe bien à l''adresse :'+_CRLF
          +'@ARG.'+_CRLF
          +'Vérifiez que vous possédez les droits d''accès à cette base '
          +'(Paramètres, Options de saisie).'+_CRLF
          +'Sans cet accès l''aide à la saisie des lieux est limitée aux lieux déjà utilisés.';
  rs_Error_source_transfer = 'Erreur transfert source n° ';
  rs_Error_sources_transfer = 'Les sources ne peuvent pas être transférées,'+_CRLF
        +'TYPE_TABLE absent de la base d''origine.';
  rs_Error_syntax = 'Erreur de syntaxe.';
  rs_Error_Table_MEDIA_POINTEURS =
  'Table MEDIA_POINTEURS absente,'+_CRLF
        +'vérifier les médias après importation.';
  rs_Error_dowloading_Parances_file_try_later = 'Erreur pendant le téléchargement du fichier PARANCES.FDB.'+_CRLF+_CRLF+
                  'Réessayez plus tard.';
  rs_Error_the_name_mustnt_be_empty_or_spaces_filled = 'Le patronyme ne doit pas être vide ou constitué uniquement d''espaces.';
  rs_Error_this_Database_version_is_too_old = 'Base version @ARG'+_CRLF
            +'trop ancienne pour être transférée par cette fonction.';
  rs_Error_this_Directory_must_have_a_name = 'Ce répertoire doit avoir un nom.';
  rs_Error_this_Directory_cannot_be_created = 'Ce répertoire ne peut être créé.';
  rs_error_this_name_is_set_to_everybody = 'Ce patronyme est déjà attribué à tous.';
  rs_Error_timeout_problem = 'Problème de timeOut';
  rs_Error_T_IMPORT_GEDCOM_update = 'Erreur mise à jour T_IMPORT_GEDCOM.';
  rs_Error_TQ_CONSANG_deleting = 'Erreur effacement TQ_CONSANG.';
  rs_Error_union_alreadx_exists = 'Cette union existe déjà.';
  rs_Error_union_transfer = 'Erreur transfert union n° ';
  rs_Error_unknown = 'Erreur inconnue';
  rs_Error_unknown_language_for_dates = 'La langue utilisée pour la saisie des dates'+_CRLF
        +'dans le dossier d''origine est inconnue.'+_CRLF+_CRLF
        +'Ne continuez que si vous êtes sûr que cette langue'+_CRLF
        +'est la même que celle de votre dossier, ou utilisez'+_CRLF
        +'le transfert par un fichier gedcom.';
  rs_Error_Unknown_sexe_please_set_it = 'Le sexe de cet individu est inconnu!'+_CRLF
        +'Définissez son sexe avant de lui attribuer un enfant.';
  rs_Error_update_Cancelled = 'Modifications annulées.';
  rs_Error_updating_old_tags = 'Erreur mise à jour des anciens tags.';
  rs_Error_validate_other_form = 'Validez les modifications en cours dans cette autre fiche avant de recommencer.';
  rs_Error_value_or_format_error = 'Erreur de valeur ou de format.';
  rs_Error_while_getting_medias = 'Erreur lors de la récupération des médias';
  rs_Error_while_replacing = 'Erreur pendant le remplacement.';
  rs_Error_while_downloading_the_file = 'Erreur pendant le téléchargement du fichier.';
  rs_Error_while_loading_data = 'Erreur lors du chargement des données.';
  rs_Error_while_reading_sites_list = 'Erreur lors de la lecture de la liste des domiciles.'+_CRLF;
  rs_Error_while_reading_events = 'Erreur lors de la lecture de la liste des événements.'+_CRLF;
  rs_Error_while_reading_union_events = 'Erreur lors de la lecture de la liste des événements des unions.'+_CRLF;
  rs_Error_Writing_is_forbidden_on_this_dir_or_device =
        'L''écriture vous est interdite dans ce répertoire ou sur ce support.';
  rs_Error_You_have_to_select_a_person_before = 'Vous devez d''abord sélectionner un individu....';
  rs_Error_You_should_choose_another_save_directory_without_readonly =
        'Vous devriez choisir un autre répertoire de sauvegarde'+_CRLF
        +'dans les "Préférences générales" car celui-ci n''est pas'+_CRLF
        +'accessible en écriture.';
  rs_Errors_while_address_copying = 'Erreurs en copiant l''adresse.';
  rs_Error_while_closing = 'Erreur lors la fermeture de';

  rs_Father = 'Père : @ARG';
  rs_FileName_NotACopy = '-original';
  rs_File_Downloaded = 'Fichier téléchargé avec succès.';
  rs_File_Not_Found_in = 'Fichier @ARG non trouvé dans @ARG.';
  rs_File_Replacing = 'Remplacement de @ARG.';
  rs_File_new_path  = 'Nouvel emplacement : @ARG.';
  rs_Form_Modifying_folder = 'Modification d''un dossier';
  rs_Filter_images_web = 'Image Web|*.gif;*.png;*.jpg;*.jpeg;*.GIF;*.PNG;*.JPG;*.JPEG|Toutes|*.*';

  rs_Function_Fast_Creating_Infos = 'Cette fenêtre permet de créer la fiche d''un individu'+_CRLF
    +'en saisissant ses éléments principaux.'+_CRLF+_CRLF
    +'La saisie du nom est obligatoire avant de pouvoir accéder au'+_CRLF
    +'autres champs de la fiche.'+_CRLF
    +'Vous avez trois possibilités pour saisir un lieu:'+_CRLF
    +'a)le lieu a déjà été utilisé et fait donc partie de la liste'+_CRLF
    +'  des lieux favoris. Dans ce cas commencez à taper directement'+_CRLF
    +'  le nom de la commune et aidez-vous de la liste déroulante.'+_CRLF
    +'b)vous pensez que le lieu n''a pas été utilisé dans cette généalogie'+_CRLF
    +'  mais figure dans la table de référence des villes. Cliquez sur le'+_CRLF
    +'  bouton rond pour le saisir dans l''Index des lieux.'+_CRLF
    +'c)le lieu n''a jamais été utilisé et ne figure pas dans l''Index des'+_CRLF
    +'  villes. Cochez la case en extrémité de ligne avant de taper le'+_CRLF
    +'  nom de la commune.'+_CRLF+_CRLF
    +'Raccourcis clavier:'+_CRLF
    +'- la touche Tab permet un passage séquentiel classique d''un champ au'+_CRLF
    +'  suivant. Utilisée conjointement, la touche Maj permet le cheminement'+_CRLF
    +'  inverse.'+_CRLF
    +'- Ctrl+Tab permet le passage direct d''un événement au champ date de'+_CRLF
    +'  l''événement suivant et de l''événement Décès au bouton Enregistrer.'+_CRLF
    +'- Ctrl+Entrée permet de passer de la page des événements à la page des'+_CRLF
    +'  informations (champs Notes et Sources de la fiche) et réciproquement.';
  rs_Function_to_calculate_Dates_Infos1 = 'Cette fonction permet de calculer la différence entre deux dates.'+_CRLF
    +'Si vous entrez une première date supérieure à la deuxième, le logiciel'+_CRLF
    +'fait automatiquement l''inversion.'+_CRLF
    +'En cas de date erronée, 32 dans le jour par exemple, un message "Erreur dans'+_CRLF
    +'une date" indique qu''au moins une des deux dates n''est pas conforme.'+_CRLF
    +'Il suffit de rectifier l''erreur pour relancer le calcul.'+_CRLF+_CRLF
    +'Une fois les deux dates spécifiées, le logiciel calcule les nombres de jours,'+_CRLF
    +'de mois et d''années qui les séparent.'+_CRLF
    +'Le passage du calendrier julien au calendrier grégorien s''étant effectué à'+_CRLF
    +'des époques différentes selon les pays, ce calcul considère que les dates'+_CRLF
    +'sont saisies dans le calendrier grégorien.';
  rs_Function_to_calculate_Dates_Infos2 = 'Cette fonction permet d''ajouter ou d''enlever, des jours, des mois ou/et des années'+_CRLF
    +'à une date précise.'+_CRLF
    +'Entrez une date de référence, puis spécifiez le sens de l''opération.'+_CRLF
    +'Indiquez ce que vous voulez ajouter ou enlever: des jours ou/et des mois'+_CRLF
    +'ou/et des années.'+_CRLF
    +'Vous pouvez ainsi retrouver plus facilement, une date de naissance, en fonction'+_CRLF
    +'de la date de décés ou de mariage et de l''âge de l''individu à ce moment là.'+_CRLF
    +'La date résultat de l''opération peut être copiée dans le presse-papier afin de'+_CRLF
    +'la coller par Ctrl+V dans le champ Date d''un événement par exemple.';
  rs_Execute_cancelled_due_to_error = 'Exécution annulée suite à erreur.';
  rs_Export_Only_regions_of_selected_country = 'Exporter seulement les régions du pays sélectionné ?';
  rs_Export_Only_departments_of_selected_region = 'Exporter seulement les départements de la région sélectionnée ?';
  rs_File_Request_Result  = 'Resultat_requete';
  rs_found = 'trouvés';
  rs_from = 'du';
  rs_Generation = 'Génération @ARG';
  rs_generation_minus = 'génération';
  rs_generations_minus = 'générations';
  rs_Greetings_BOA              = 'Développement d''après une idée originale de Laurent Robbe,'+_CRLF
    +'développeur du BOA (Boîte à Outils pour Ancestromania).'+_CRLF+_CRLF
    +'ATTENTION: l''exécution de requêtes peut modifier le'+_CRLF
    +'contenu des tables de la base.'+_CRLF
    +'Il est indispensable d''effectuer une sauvegarde de votre'+_CRLF
    +'base avant d''exécuter des requêtes avec cet outil.'+_CRLF
    +'C''est la seule méthode permettant de ramener votre base'+_CRLF
    +'dans son état initial en cas d''erreur lors de la modification'+_CRLF
    +'de vos données.';
  rs_Hint_Add_a_witness_to_this_event = 'Ajoute un témoin à cet événement';
  rs_Hint_Add_a_doc_to_this_event = 'Ajoute un document à cet événement';
  rs_Hint_Affect_A_Noone_is_deleted_E_Person_not_in_the_group_are_deleted_S_Supress_persons_of_group=
    'EFFET = A - Aucun individu n''est supprimé de la base  '+_CRLF+
    '        E - Elagage: les individus qui ne font pas partie du groupe sélectionné sont supprimés.'+_CRLF+
    '        S - Suppression des individus du groupe sélectionné Si I_INDIVIDU=0 seule l''action prévue par EFFET est exécutée.';
  rs_Hint_Associate_surnames_to_this_person = 'Associer des patronymes à cet individu.';
  rs_Hint_Associate_a_surname_with_a_person_permits_to_see_it_in_the_surnames_index_for =
    'Associer un patronyme à un individu permet de le'+_CRLF
    +'retrouver dans l''Index des noms et dans le Repertoire'+_CRLF
    +'en y sélectionnant ce patronyme.'+_CRLF
    +'Pour qu''une association fonctionne avec tous les'+_CRLF
    +'"@ARG",'+_CRLF
    +'il suffit d''un seul "à tous"="Oui" pour ce patronyme.'+_CRLF+_CRLF
    +'L''aide à la saisie d''un patronyme est initialement'+_CRLF
    +'limitée aux patronymes déjà associés à des individus de'+_CRLF
    +'même nom. Pour étendre l''aide à tous les patronymes'+_CRLF
    +'cliquez sur l''entête de la colonne.';
  rs_Hint_Auto_validation_enabled = 'Attention, validation automatique activée. Les'+_CRLF
      +'modifications sont enregistrées sans confirmation.';
  rs_Hint_Auto_validation_disabled = 'Validation automatique désactivée.'+_CRLF
      +'Cliquer pour enregistrer sans confirmation.';
  rs_Hint_for_ancestry_d_for_descent_A_c_every_persons = 'MODE = A - permet de sélectionner les Ascendants de I_INDIVIDU,'+_CRLF+
    '       D - permet de sélectionner les Descendants de I_INDIVIDU, '+_CRLF+
    '       C -  permet de sélectionner l''ensemble de la Branche, I_INDIVIDU compris.';
  rs_Hint_Ctrl_and_enter_to_access_with_keyboard = 'Ctrl+Entrée pour un accès au clavier.';
  rs_Hint_Click_twice_or_click_on_icon_to_see_details = 'Cliquez sur l''événement ou '+_CRLF
      +'sur son icône pour en voir les détails.';
  rs_Hint_Copy_everything_Ctrl_d_copy_field_by_field_and_next =
    'Copie tous les champs du haut en bas,'+_CRLF+
    '<CTRL><D> copie champ par champ et passe au suivant.';
  rs_Hint_Copy_every_fields = 'Copie tous les champs du haut en bas.'+_CRLF;
  rs_Hint_Copy_Field='Ctrl+D copie champ par champ et passe au suivant.';
  rs_Hint_Copy_Bottom_Coord='Ctrl+D copie champ par champ, Ctrl+G demande les coordonnées sur Google Maps.';
  rs_Hint_Copy_Top_Coord='Ctrl+D ou DblClick copie champ par champ et passe au suivant.';
  rs_Hint_Default_parameters_to_access_to_refering_base_are = 'Par défaut les paramètres d''accès à la base de référence des lieux sont:'+_CRLF
     +'Nom d''utilisateur: SYSDBA'+_CRLF
     +'Mot de passe: masterkey'+_CRLF
     +'Rôle: <vide>'+_CRLF
     +'Ces paramètres ne doivent être modifiés que si vous utilisez la version serveur de Firebird'+_CRLF
     +'avec des droits d''accès différents.';
  rs_Hint_Delete_the_doc_s_link = 'Enlève le lien avec le document sélectionné';
  rs_Hint_Delete_the_witness_s_link = 'Enlève le lien avec le témoin sélectionné';
  rs_Hint_Directory_select = 'Pour sélectionner un répertoire,'+_CRLF
    +'sélectionnez d''abord un fichier'+_CRLF
    +'de ce répertoire par le bouton ...'+_CRLF
    +'puis supprimez le nom du fichier'+_CRLF
    +'dans ce champ.';
  rs_Hint_Double_clic_to_select = 'Double-cliquer pour sélectionner.';
  rs_Hint_Duplicates_will_be_searched_in_persons_with_a_same_or_similar_surname =
    'Les doublons de l''individu en cours seront recherchés parmi'+_CRLF
                     +'les individus de même nom, ou ayant un patronyme associé'+_CRLF
                     +'identique à l''un des siens.';
  rs_Hint_Events_folder = 'Catégorie d''événements: ';
  rs_Hint_Every_changes_are_executed_in_form_with_key_maj = 'Tous les changements d''individu demandés en appuyant'+_CRLF
                    +'simultanément sur la touche <maj> s''exécutent dans'+_CRLF
                    +'la fiche @ARG';
  rs_Hint_Every_recorded_medias_are_loaded_in_library = 'Tous les médias enregistrés sont'+_CRLF
      +'chargés dans la bibliothèque.';
  rs_Hint_Forced_writing_Modify_is_quickly_saved_but_it_slows_software =
                       'Lorsque l''écriture forcée est activée, les modifications des'+_CRLF
                      +'informations sont immédiatement enregistrées dans le fichier de'+_CRLF
                      +'la base sans attendre dans le cache de Windows. Il en résulte une'+_CRLF
                      +'plus grande sécurité en cas d''interruption inattendue du système.'+_CRLF
                      +'En contrepartie celà peut ralentir le logiciel, en particulier lors'+_CRLF
                      +'d''opérations demandant beaucoup d''écritures comme l''importation'+_CRLF
                      +'d''un dossier ou d''un fichier au format GEDCOM.';
  rs_Hint_Full_path = 'Chemin complet : seule l''adresse du média original'+_CRLF
    +'                 figurera dans le fichier gedcom.'+_CRLF
    +'Pas de médias : les médias seront absents du fichier.'+_CRLF
    +'Copie interne exportée : les médias internes à la base'+_CRLF
    +'      seront copiés dans un répertoire de même nom que'+_CRLF
    +'      le fichier.'+_CRLF
    +'Original exporté : les fichiers médias originaux seront'+_CRLF
    +'      copiés dans un répertoire de même nom que le fichier.';
  rs_Hint_Generic_action_Maj_with_select_open_a_consult_form = 'Fonction générale:'+_CRLF+'Appuyer sur la touche Maj en sélectionnant'+_CRLF
    +'ouvre une fiche en mode consultation.';
  rs_Hint_History_on_year_of_birth_of = 'Histoire de l''année de naissance de @ARG';
  rs_Hint_Init_Y_Empty_table_N_Do_delete_nothing_P_Delete_records_of_same_group =
    'INITIALISATION = Y - vide complètement la table TA_GROUPES avant de commencer, '+_CRLF+
    '                 N - n''en supprime aucun enregistrement,'+_CRLF+
    '                 P - en supprime les enregistrement du même groupe.(P comme Partiel)';
  rs_Hint_if_server_version_is_used_maj_will_open_connexion_dialog ='Si la version serveur de Firebird est utilisée, appuyer'+_CRLF
    +'sur la touche MAJ en ouvrant la base de données ouvre la'+_CRLF
    +'boîte de dialogue de connexion permettant de spécifier un'+_CRLF
    +'identifiant et un mot de passe pour accéder à la base.';
  rs_Hint_Library_loading_can_be_strongly_accelerated_removing_the_display_thumbnail_images=
    'Le chargement de la bibliothèque peut être fortement'+_CRLF
    +'accéléré en supprimant l''affichage des images réduites.';
  rs_Hint_Look_at_ancestry = 'Voir parenté';
  rs_Hint_Modifying_Act_s_type_with_drag_drop = 'On peut modifier le type de l''acte par glisser/déposer à l''aide de la souris.';
  rs_Hint_Modify_a_surname_infos_base_dir_language_of_data_notes_file = 'Modifications du nom, de la description,'+_CRLF
    +'du répertoire de base des images et fichiers attachés'+_CRLF
    +'de la langue des données et du fichier des notes de ce dossier.';
  rs_Hint_Move_Graph = 'Déplacement du graphe.'+_CRLF+'Avec touche Alt, augmente la taille.'+_CRLF
    +'Avec touche Ctrl, diminue la taille.';
  rs_Hint_Notes='Des liens hypertextes peuvent être insérés dans tous les champs Notes et Sources.'+_CRLF
            +'Mettez l''adresse complète du document dans une ligne vide ou encadrez-la par les'+_CRLF
            +'symboles < et > sans ajouter d''espaces.'+_CRLF
            +'Double-cliquez sur cette adresse pour ouvrir le document.'+_CRLF+_CRLF
            +'Les raccourcis de saisie sont utilisables dans les champs Notes, Sources et Villes.';
  rs_Hint_Only_50_first_recorded_medias_are_loaded_in_library = 'Seuls les 50 derniers médias enregistrés'+_CRLF
      +'sont chargés dans la bibliothèque.';
  rs_Hint_Opens_favorite_sites_window_Ctrl_F_From_City_or_division_fields =
    'Ouvre la fenêtre de vos lieux favoris.'+_CRLF+'Raccourci:'+_CRLF
    +'Ctrl+F depuis les champs Ville ou Subdivision';
  rs_Hint_Person_s_Notes_and_sources_access = 'Accès aux champs Notes et Sources de la fiche de l''individu.';
  rs_Hint_Person_s_events_access = 'Accès à la Naissance, au Décès et à la Profession de l''individu.' ;
  rs_Hint_PLAC_stick = 'Code exporté sous l''étiquette PLAC'+_CRLF
    +'Le code postal est plus habituel.'+_CRLF
    +'Ancestromania exporte le code ignoré dans'+_CRLF
    +'les notes de PLAC, et sait l''importer';
  rs_Hint_Press_first_key_of_surname_to_be_helped = 'Tapez la première lettre du nom pour obtenir de l''assistance.';
  rs_Hint_Press_first_key_of_name_to_be_helped = 'Tapez la première lettre du prénom pour obtenir de l''assistance.';
  rs_Hint_Press_for_every_cities_bottom_arrow_selects_cities = 'Tapez * pour toutes les villes, ou un mot pour trouver'+_CRLF
    +'les villes dont le nom commence ou contient ce mot.'+_CRLF
    +'La touche "flêche en bas" sélectionne les villes.';
  rs_Hint_Print_upside_Acts_list = 'Imprime la liste des actes ci-dessus...';
  rs_Hint_Print_upside_homes_list = 'Imprime la liste des domiciles ci-dessus...';
  rs_Hint_Print_upside_tree = 'Imprime l''arborescence ci-dessus...';
  rs_Hint_Select_a_person_with_stick ='Cliquez sur l''étiquette pour sélectionner l''individu dans la liste.'+_CRLF
      +'Double-cliquez pour ouvrir sa fiche.'+_CRLF
      +'Maintenez le bouton de la souris enfoncé pour déplacer l''étiquette.';
  rs_Hint_Story_of_year = 'Histoire de l''année : ';
  rs_Hint_Surnames_associated_to_this_person = 'Patronymes associés à cet individu.';
  rs_Hint_This_person_has_got_child_ren = 'Cet individu a @ARG enfant(s)';
  rs_Hint_The_first_keyword_on_the_first_line_must_be_name_of_month =
    'Le mot clé en première ligne doit être le nom du mois comme'+_CRLF
          +'il doit s''afficher dans une date au format littéraire.'+_CRLF
          +'Les mots clés des lignes suivantes sont des formes abrégées'+_CRLF
          +'ou erronées permettant d''identifier le mois.'+_CRLF
          +'Tous les mots clés de mois doivent donc être différents.';
  rs_Hint_The_first_keyword_on_the_first_line_must_be_used_separator =
           'Le mot clé en première ligne doit être le séparateur utilisé'+_CRLF
          +'normalement dans les dates au format numérique.'+_CRLF
          +'Les mots clés des lignes suivantes sont des formes autorisées'+_CRLF
          +'permettant d''identifier un séparateur des éléments d''une date.';
  rs_Hint_This_keyword_can_identify_the_events_sorting_of_date =
           'Ce mot clé permet d''identifier l''ordre des éléments de la date'+_CRLF
          +'(D=jour, M=mois, Y=année) lors de la saisie ou l''affichage de cette date.'+_CRLF
          +'La première ligne identifie cet ordre dans les dates au format littéraire (LIT).'+_CRLF
          +'La seconde ligne identifie cet ordre dans les dates au format numérique (NUM).'+_CRLF
          +'Seuls les ordres DMY, MDY et YMD sont autorisés.';
  rs_Hint_This_keyword_can_identify_the_alpha_or_numeric_format_of_dates =
          'Ce mot clé permet d''identifier le format littéraire ou numérique des'+_CRLF
          +'dates lors de leur affichage.'+_CRLF
          +'Valeurs autorisées:'+_CRLF
          +' LIT pour un affichage au format littéraire,'+_CRLF
          +' NUM pour un affichage au format numérique.';
  rs_Hint_These_keywords_can_identify_the_event_period =
          'Ces mots clés permettent d''identifier la période de l''événement.'+_CRLF
          +'La colonne Utilisation identifie les formes à afficher selon les cas:'+_CRLF
          +' D si le jour est présent,'+_CRLF
          +' M si le mois est présent sans le jour,'+_CRLF
          +' Y si seule l''année est présente.'+_CRLF;
  rs_Hint_D1_M1_Y1_Indentify_same_cases_when_second_date_is_empty =
          'D1, M1 et Y1 identifient les mêmes cas lorsque la deuxième date de la'+_CRLF
          +'période est absente.'+_CRLF
          +'D, M, Y, D1, M1 et Y1 ne doivent figurer qu''une seule fois par période.'+_CRLF
          +'En cas d''absence de l''une d''elle, c''est la suivante dans l''ordre DMY qui'+_CRLF
          +'identifie le mot clé qui sera utilisée.'+_CRLF
          +'En cas d''absence totale de cette valeur, le premier mot clé est utilisé.';
 rs_Hint_D_M_Y_must_be_only_once_per_period =
   'Les lettres D, M, et Y ne doivent figurer qu''une seule fois par période.'+_CRLF
          +'En cas d''absence de l''une d''elle, c''est la suivante dans l''ordre DMY qui'+_CRLF
          +'identifie le mot clé qui sera utilisé.'+_CRLF
          +'En cas d''absence totale de cette valeur, le premier mot clé sera utilisé.';
 rs_Hint_Double_clic_open_individual_file =//'Modifiez l''ordre des naissances ou l''affectation à un parent par'+_CRLF
//    +'glisser/déposer de l''enfant.'+_CRLF+_CRLF
    'Un double-clic sur le texte ouvre'+_CRLF
    +'la fiche de l''individu.';//+_CRLF+_CRLF
//    +'On peut ajouter un enfant ou un conjoint par glisser/déposer'+_CRLF
//    +'depuis le Répertoire ou les fiches Recherche et Environnement'+_CRLF
//    +'familial. Pour ajouter un conjoint appuyer sur la touche "Maj"'+_CRLF
//    +'en relâchant le bouton de la souris.';
  rs_Hint_Right_clic_for_Options_Double_clic_to_open = 'Clic droit pour Options'+_CRLF+'Double-clic pour ouvrir une fiche';
  rs_Hint_Usefull_sites_for_satellites_views = 'Sites utilisables pour accéder à des vues par satellites.'+_CRLF+_CRLF
     +'La localisation des vues se fait à l''aide des coordonnées'+_CRLF
     +'enregistrées pour les lieux.'+_CRLF
     +'Seuls GoogleMap et Mapper.acme autorisent la localisation à l''aide de'+_CRLF
     +'l''adresse du lieu.';
  rs_Hint_Use_right_button_to_modify_a_site_or_see_an_event = 'Utiliser le bouton droit de la souris pour modifier un lieu'+_CRLF
    +'ou voir qui a eu un événement dans ce lieu.';
  rs_Hint_Unless_identity_of_names_Duplicates_will_be_searched='Au lieu de l''identité de l''ensemble des prénoms,'+_CRLF
                 +'les doublons seront recherchés parmi des individus'+_CRLF
                 +'dont au moins un prénom est commun.';
  rs_Hint_Use_right_button_to_modify_a_city='Utiliser le bouton droit de la souris pour modifier la ville.' ;
  rs_Hint_Witnesses_Y_Select_also_witness_N_Not = 'TEMOINS= Y - sélectionne également les témoins (option très dangereuse),'+_CRLF+
    '         N - ne les sélectionne pas.';
  rs_Hint_Y_Yes_N_No_Y_with_A_D_N_Do_not_refuse_selection =  'STRICTE = Y ou N (oui ou non) '+_CRLF+
    'STRICTE = Y - s''utilise avec MODE A ou D pour exclure de la liste l''individu et son conjoint ainsi que, les ascendants et leurs conjoints si MODE = D, ou les descendants et leurs conjoints si MODE= A .'+_CRLF+
    'STRICTE = N - n''empêche pas la sélection, mais les individus qui auraient été éliminés de la sélection avec STRICTE = Y sont listés en fin de procédure.';
  rs_Hint_You_can_add_a_joint_by_drag_drop = 'On peut ajouter un conjoint par glisser/déposer depuis le Répertoire'+_CRLF
    +'ou les fiches Recherche et Environnement familial';
  rs_Hint_You_can_add_a_wittness_by_drag_drop = 'On peut ajouter un témoin par glisser/déposer depuis le Répertoire'+_CRLF
    +'ou les fiches Recherche et Environnement familial';
  rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns = 'Vous pouvez redimensionner les colonnes de l''impression en redimensionnant les colonnes du tableau.' ;
  rs_History_File_has_got_this_name = 'Le fichier Histoire créé porte le nom:';
  rs_Homes_of = 'Liste des domiciles de @ARG';
  rs_if_you_use_server_version_you_must_have_got_the_rights_from_server = 'Si vous utilisez la version serveur de Firebird, vous devez posséder les droits'+_CRLF
     +'d''administration de la base de données pour exécuter cette opération.';
  rs_Image_Recorded_on_date = 'Image enregistrée le : @ARG';
  rs_Import_Document = 'Document importé le : @ARG à @ARG';
  rs_Import_Image    = 'Image importée le : @ARG à @ARG';
  rs_Import_Sound    = 'Son importé le : @ARG à @ARG';
  rs_Import_Video    = 'Vidéo importée le : @ARG à @ARG';
  rs_Sound_Recorded_on_date = 'Son enregistré le : @ARG';
  rs_Video_Recorded_on_date = 'Vidéo enregistrée le : @ARG';
  rs_Document_Recorded_on_date = 'Document enregistré le : @ARG';
  rs_Importing_a_big_file_can_be_long = 'L''importation d''un gros ficher, peut être longue,'+_CRLF+
        'de l''ordre de 30 minutes sur un PC moyen pour un fichier'+_CRLF+
        'gedcom de 75 000 individus et 40 000 familles.';
  rs_Import_finished = 'Importation terminée';
  rs_inbreeding_Calculation_on_the_entire_folder = 'Calcul de la consanguinité sur tout le dossier.';
  rs_inbreeding_Calculation_on_the_SOSA = 'Calcul de la consanguinité sur les SOSA.';
  rs_Info_A_new_realease_can_be_downloaded_go_into_help_menu = 'Une nouvelle version existe sur Internet : @ARG'+_CRLF+_CRLF+
                'Allez dans le menu Aide, et vérifiez les mises à jour en ligne';
  rs_Info_Base_is_now_this = 'La base est maintenant ici :'+_CRLF+' @ARG';
  rs_Info_Base_must_use_utf8_characters = 'Vos données utilisaient les caractères ANSI.'+
                _CRLF+' La base doit être migrée à partir du projet de migration vers les caractères internationaux. Ce projet est ici :'+
                _CRLF+'http://ancestromania.net'+_CRLF+'L''application va maintenant considérer que votre base est en caractères internationaux, au risque de mal fonctionner.';
  rs_Info_Export_is_a_success = 'L''exportation s''est bien passée.';
  rs_Info_Ancestry_calculate = 'Cette option permet d''afficher la parenté entre conjoints quand elle existe,'+_CRLF
      +'et autorise la mise à jour automatique de la parenté au Sosa n°1 si l''option'+_CRLF
      +'"Afficher les liens au Sosa n°1" est activée (onglet Visuels). Mais elle'+_CRLF
      +'peut augmenter le temps d''affichage au changement d''individu.';
  rs_Info_Export_is_a_success_in_hour_minutes_seconds = 'L''exportation a été effectuée avec succès, en @ARG'
      +'h, @ARG min, @ARG sec.';
  rs_Info_Export_of_pictures_is_a_success_They_are_in_this_directory =
    'L''exportation de @ARG image(s) s''est bien passée.'
      +_CRLF+_CRLF+'Celles-ci se trouvent dans le répertoire : ';
  rs_Info_Export_has_fallen_before_updating_database = 'L''exportation a échoué lors de la mise à jour de la base.';
  rs_Info_Export_has_fallen_medias_could_not_be_exported = 'L''exportation a échoué, les fichiers médias n''ont pu être exportés.';
  rs_Info_Export_has_fallen_ged_can_not_be_written = 'L''exportation a échoué, le fichier .ged ne peut être écrit.';
  rs_Info_Export_has_fallen_while_selecting_objects = 'L''exportation a échoué lors de la sélection des objets à exporter.';
  rs_Info_Export_has_fallen_while_persons_export = 'L''exportation a échoué lors de l''exportation des individus.';
  rs_Info_Export_has_fallen_while_families_export = 'L''exportation a échoué lors de l''exportation des familles.';
  rs_Info_Export_has_fallen_while_sources_export = 'L''exportation a échoué lors de l''exportation des sources.';
  rs_Info_Export_stopped_by_user = 'Exportation arrêtée par l''utilisateur.';
  rs_Info_Export_of_pictures_and_documents_will_begin_in_directory= 'L''exportation des images et des documents va se faire dans le répertoire'
      +_CRLF+'@ARG'+_CRLF+
      'Les fichiers portant les mêmes noms seront écrasés.'+_CRLF+_CRLF+
      'Voulez-vous exporter les images originales à la place de la version compressée dans la base?' ;
  rs_Info_File_is_not_Windows_formated_Will_create_a_copy_named = 'Ce fichier n''est pas au format Windows'+_CRLF+
        'Ancestromania en crée une copie au même emplacement'+_CRLF+
        'appelée ';
  rs_Info_Connected_Database = 'Base connectée: @ARG.';
  rs_Info_Database_version = 'Version de la base: @ARG.';
  rs_Info_Files_library_versions = 'Versions des fichiers en place:';
  rs_Info_File_size = 'Taille du fichier : @ARG octets.';
  rs_Info_Build = 'Construction: @ARG.';
  rs_Info_Version = 'Version: @ARG.';
  rs_Info_OS = 'Système d''exploitation:'+_CRLF+'@ARG';
  rs_Info_Ancestromania_version = 'Version d''Ancestromania: @ARG.';
  rs_Info_File_structure_version = 'Structure du fichier version: @ARG octets.';
  rs_Info_Used_memory = 'Mémoire utilisée: @ARG.';
  rs_Info_Users = 'Utilisateurs: @ARG';
  rs_Info_User  = 'Utilisateur : @ARG';
  rs_Info_Firebird_embedded_is_installed = 'Firebird embedded est installé.';
  rs_Info_Forced_Writing_on = 'Écriture forcée activée.';
  rs_Info_Forced_Writing_off = 'Écriture forcée désactivée.';
  rs_Info_Geneanet_Export_is_a_success_Import_it_on_geneanet_org = 'L''exportation au format "Geneanet" est réalisée.'+_CRLF+_CRLF
                +'Il vous reste maintenant à télécharger le fichier sur le site Internet "www.geneanet.org".';
  rs_Info_Import_is_a_success_in_hour_minutes_seconds = 'L''importation a été effectuée avec succès, en @ARG'
        +'h, @ARG min, @ARG sec.';
  rs_Info_It_is_necessary_to_optimise_your_database = 'Il est fortement conseillé de faire'+_CRLF
        +'une optimisation de votre base de données.';
  rs_Info_Medias_library = 'Avant de pouvoir attacher un média, image ou autre document à un'
    +' individu, une source ou un événement, il doit être enregistré dans'
    +' cette Bibliothèque multimédia par l''un des cinq boutons situés en'
    +' haut dans la colonne de gauche de la fenêtre.'+_CRLF
    +'Pour vous faciliter la vie lorsque vous devrez un jour ou l''autre'
    +' transférer ces documents sur un autre ordinateur, il est fortement'
    +' conseillé de stocker tous les documents liés à votre dossier à'
    +' l''intérieur d''une structure dont le point d''entrée est le'
    +' "répertoire de base des images et fichiers attachés au dossier"'
    +' défini dans les propriétés particulières à chaque dossier, menu'
    +' "Généalogies / Dossiers de la base", bouton "Modifier/détails".'+_CRLF+_CRLF
    +'Au même endroit vous devez définir également la façon dont Ancestromania'
    +' conservera les images que vous allez charger dans cette bibliothèque.'+_CRLF
    +'Si la case "Intégrer une copie des images dans la base" n''est pas cochée,'
    +' seules l''adresse et une copie très réduite (format "identité") de votre'
    +' image seront stockées dans la base lorsque vous la chargerez dans cette'
    +' bibliothèque. Vous aurez alors l''avantage d''une base de données de'
    +' taille plus réduite donc plus rapide, mais avec la contrainte de devoir'
    +' garder les fichiers originaux à l''adresse depuis laquelle ils ont été chargés'
    +' pour obtenir la meilleure qualité d''affichage dans les fiches et les états.'+_CRLF
    +'Si la case "Intégrer une copie des images dans la base" est cochée, une'
    +' copie, réduite à 1024 pixels dans sa plus grande dimension si nécessaire,'
    +' est ajoutée dans la base. Celà fait grossir plus rapidement votre base et'
    +' peut diminuer la qualité de l''affichage, mais il sera plus aisé de'
    +' transporter votre généalogie en assurant une qualité d''affichage'
    +' généralement suffisante.'+_CRLF
    +'Une option du menu contextuel permet de changer de mode de chargement et'
    +' met à jour votre base en rechargeant la totalité des images selon le nouveau'
    +' mode si les fichiers originaux sont trouvés aux adresses enregistrées.'+_CRLF
    +'Le bouton "Remplacer chemin" donne l''accès à une fonction permettant de'
    +' mettre à jour les adresses des fichiers originaux, suite à leur déplacement.'+_CRLF+_CRLF
    +'La durée du chargement de cette bibliothèque peut devenir relativement longue'
    +' si elle contient beaucoup de médias. Pour la réduire lorsqu''elle devient trop'
    +' importante 3 solutions vous sont proposées: la première consiste à ne pas vider'
    +' la liste à chaque fermeture de la bibliothèque, la deuxième consiste à ne charger'
    +' que les 50 derniers médias enregistrés et la troisième supprime l''affichage de la'
    +' colonne des images réduites.'+_CRLF
    +'La première solution est activable depuis le sous-menu du bouton "Fermer", la'
    +' deuxième par la case à cocher "Tout charger" et la troisième par la case à'
    +' cocher "Sans mini-images".'+_CRLF
    +'Chaque solution a ses avantages et ses inconvénients.'+_CRLF
    +'La première permet de faire en permanence toutes les recherches possibles avec'
    +' les outils de tri et de filtrage intégrés, mais peut demander un temps de'
    +' chargement important et les descriptions modifiées depuis les événements ou'
    +' l''onglet "Médias" de la fiche principale n''y sont pas mises à jour. Les ajouts'
    +' ou modifications effectués depuis une autre session d''Ancestromania n''y sont pas'
    +' visibles non plus. Cependant une option du menu déroulant principal permet de rafraîchir'
    +' la liste pour tenir compte des modifications faites hors de la bibliothèque.'+_CRLF
    +'La deuxième solution permet un chargement rapide mais limite la portée des tris'
    +' et filtres aux 50 derniers médias chargés.';
  rs_Info_No_record_to_export = 'Il n''y a aucun enregistrement à exporter !';
  rs_Info_Nobody_to_export = 'Il n''y a personne à exporter !';
  rs_Info_Nothing_to_export = 'Il n''y a rien à exporter !';
  rs_Info_No_picture_to_export = 'Il n''y avait aucune image à exporter.';
  rs_Info_Not_present_at_install = '@ARG manque à l''installation';
  rs_Info_Optimising_is_recomended = 'Optimisation conseillée.';
  rs_Info_Optimising_is_unusefull = 'Optimisation inutile.';
  rs_Info_Scan_Cancelled = 'Acquisition annulée.';
  rs_Info_Scan_Cancelled_from_source = 'Acquisition annulée depuis la source Twain.';
  rs_Info_Turn_it_off_if_software_slows_down = 'Désactivez-là en cas de ralentissement important du logiciel.';
  rs_Info_Weight_of_base_has_growed_of = ' La taille de la base a augmenté de @ARG%';
  rs_Info_SOSA_no_1 = 'Sosa n°1: [@ARG] ';
  rs_Information = 'Informations';
  rs_Infos = 'Infos';
  rs_If_no_you_should_cancel_update = 'Si non, il est préférable d''annuler afin d''exécuter cette sauvegarde.';
  rs_It_is_preferable_to_download_and_install_this_update =
        'Il est conseillé de télécharger et d''exécuter cette mise à jour.';
  rs_Item_Other_known_father = 'Autre père connu';
  rs_Item_Other_known_mother = 'Autre mère connue';
  rs_he_is_joint_with = 'est un conjoint de ';
  rs_she_is_joint_with = 'est une conjointe de ';
  rs_in_date = 'en' ;
  rs_Individual_event = 'Événement individuel';
  rs_Individual_events = 'Événements individuels';
  rs_Individual_Media = 'Média individuel';
  rs_Individual_Medias = 'Médias individuels';
  rs_Ini_Download_Again = 'Retélécharger la configuration.';
  rs_is_descent_with = 'figure dans la descendance de ';
  rs_is_ancestry_from = 'figure dans l''ascendance de';
  rs_is_always_parent_with = ' a déjà pour parent';
  rs_Job_is = 'Profession : @ARG';
  rs_Joint_s_Child_ren_of = 'Conjoint(s), enfant(s) de @ARG';
  rs_Joint = 'Conjoint';
  rs_Joints = 'Conjoints';
  rs_link_from_person_to_document_will_be_erased = 'L''affectation du document à l''individu en cours va être supprimée.';
  rs_missing = 'absents';
  rs_List_of_acts_by_type = 'Liste des actes par type';
  rs_List_of_acts_by_type_of = 'Liste des actes par type de @ARG';
  rs_List_of_tables = 'liste des tables';
  rs_List_of_procedures = 'liste des procédures';
  rs_Log_Copy_database_in = 'Copie de la base de données dans ';
  rs_Log_favorite_sites_Coord_Update = 'MAJ des coordonnées géographiques des lieux favoris ';
  rs_Log_Database_closing = 'Fermeture de la base';
  rs_Log_Database_opening = 'Ouverture de la base';
  rs_Log_deleting_a_branch = 'Suppression d''une branche';
  rs_Log_deleting_the_importation = 'Suppression de l''import ';
  rs_Log_Errors_Filename = 'ErreursImport';
  rs_Log_Errors_File_import = 'Fichier des erreurs d''importation: @ARG généré le @ARG.';
  rs_Log_File_Bad_picture_format = 'Fichier @ARG : mauvais format d''image.' ;
  rs_Log_File_cannot_read = 'Fichier @ARG : enregistrement verrouillé.';
  rs_Log_File_not_modified_record = 'Fichier @ARG absent, enregistrement non modifié.';
  rs_Log_GEDCOM_Export_to_file= 'Export GEDCOM du fichier ';
  rs_Log_GEDCOM_Import_from_file_with_folder = 'Import GEDCOM du fichier @ARG - Dossier: ';
  rs_Log_Import_from_a_folder_from_base = 'Import d''un dossier depuis la base : ';
  rs_Log_Menu_reset = 'Reset des barres de menus';
  rs_Log_Medias_Errors_File_import = 'Fichier des erreurs d''importation des médias: @ARG généré le @ARG.';
  rs_Log_Medias_Errors_File_Infos = 'Ce fichier étant supprimé lors de la fermeture d''Ancestromania,'
    +' enregistrez le à l''emplacement souhaité si vous voulez le conserver.';
  rs_Log_Optimising_database = 'Optimisation de la base de données';
  rs_Log_purge_processes_logbook = 'Purge du journal des opérations';
  rs_Log_Replace_Media_by = 'Médias: remplacement @ARG par ';
  rs_Log_Forms_reset = 'Réinitialisation des fenêtres';
  rs_main = 'principale';
  rs_Married_on = 'Marié(e) le @ARG';
  rs_MyDatabase='MaBase';
  rs_Message_Database_Directory_which_is_used_to_set_database_site =
        'Le répertoire @ARG'+_CRLF
        +'pour placer la base de données n''est pas accessible.';
  rs_Message_Exporting_Medias = 'Exportation des médias:'+_CRLF+_CRLF+'@ARG';
  rs_Modify_an_used_site = 'Modification d''un lieu utilisé';
  rs_Mother = 'Mère : @ARG';
  rs_Must_Select_A_Database = 'Vous devez d''abord sélectionner une base de données!';
  rs_New_version_please_update = 'Une nouvelle version existe sur Internet : @ARG'+_CRLF+_CRLF+
                'Allez dans le menu Aide, et vérifiez les mises à jour en ligne';
  rs_New_surname = 'Nom devant remplacer: ';
  rs_Next = 'Suivant';
  rs_No_result_With_Request = 'Aucun résultat à cette requête.';
  rs_No_person_with_this_key = 'Il n''y a pas d''individu de ce code dans ce dossier.';
  rs_Now_olded_female = 'Âgée aujourd''hui';
  rs_Now_olded_male = 'Âgé aujourd''hui';
  rs_plural = '@ARGs';
  rs_o_age = 'd''@ARG' ;
  rs_of_age = 'de @ARG' ;
  rs_on_date = 'le' ;
  rs_One_Record_Selected = '1 enregistrement sélectionné.';
  rs_Only_Modifying_from_last_commit_can_be_valided = 'Seules les modifications depuis le dernier COMMIT ou la'+_CRLF
          +'dernière instruction DDL valide peuvent être annulées.';
  rs_oldd =' à l''âge d''@ARG';
  rs_olded =' à l''âge de @ARG';
  rs_Optimising_database_is_a_success = 'L''optimisation de la base s''est bien passée.';
  rs_Parents_of = 'Parents de @ARG';
  rs_Person_file_has_been_modified = 'La fiche de l''individu en cours a été modifiée.';
  rs_Post_it = 'Post''it';
  rs_Previous_request_May_Modify_data = 'La requête précédente a pu modifier des données.';
  rs_Prior = 'Précédent';
  rs_Please_Wait = 'Merci de patienter...';
  rs_Print_list_of_cousins_of = 'Liste des cousins de @ARG';
  rs_Processes_Logbook = 'Journal des opérations';
  rs_readonly_only = 'en consultation seulement.';
  rs_Records_Selected = ' enregistrements sélectionnés.';
  rs_Request_Executed = 'Requête exécutée avec succès.';
  rs_Replace_done = 'Remplacement effectué.';
  rs_Replacing_of_a_surname = 'Remplacement d''un patronyme.';
  rs_Report_Ages_on_first_union = 'Âges à la première union';
  rs_Report_Alphabet_List = 'Liste alphabétique complète';
  rs_Report_Alphabet_List_by_men = 'Liste alphabétique par les hommes';
  rs_Report_Alphabet_List_by_women = 'Liste alphabétique par les femmes';
  rs_Report_Ascending_of = 'Ascendance complète de : @ARG';
  rs_Report_Ascending_men_of = 'Ascendance par les hommes de : @ARG';
  rs_Report_Ascending_women_of = 'Ascendance par les femmes de : @ARG';
  rs_Report_Average_longevities = 'Longévités moyennes';
  rs_Report_Birth_List_of_month = 'Liste des des anniversaires du mois : @ARG';
  rs_Report_Birthdays_by_countries  = 'Naissances par pays';
  rs_Report_Birthdays_by_department = 'Naissances par départements';
  rs_Report_Deathdays_by_countries   = 'Décès par pays';
  rs_Report_Deathdays_by_department = 'Décès par départements';
  rs_Report_EveryThing_About = 'Tout ce qui concerne : @ARG';
  rs_Report_Brothers_and_Sisters_of = 'Frères et sœurs de : @ARG';
  rs_Report_Children_of = 'Enfants de : @ARG';
  rs_Report_Children_count_by_families = 'Nombre d''enfants par union';
  rs_Report_Cousins_of = 'Cousins de : @ARG';
  rs_Report_Counting_Ascending = 'Dénombrement des ascendants';
  rs_Report_Counting_Descent   = 'Dénombrement des descendants' ;
  rs_Report_Descent_of = 'Descendance de @ARG';
  rs_Report_Events_List = 'Liste des événements';
  rs_Report_Family_file_of = 'Fiche familiale de : @ARG';
  rs_Report_Fast_List = 'Liste éclair';
  rs_Report_Haunts_and_uncles_of = 'Oncles et tantes de : @ARG';
  rs_Report_Identification_of_individuals = 'Recensement des individus';
  rs_Report_Individual_file_of = 'Fiche individuelle de : @ARG';
  rs_Report_Jobs_List = 'Liste des professions';
  rs_Report_Names_List = 'Liste des prénoms';
  rs_Report_Surnames_Descent_of = 'Descendance patronymique de : @ARG';
  rs_Report_Surnames_List = 'Liste des patronymes';
  rs_Report_Unions_List = 'Liste des unions';
  rs_Report_There_is_no_printer = 'Il n''y a aucune imprimante disponible.';
  rs_Report_This_report_generated_an_error = 'Cette édition a généré une erreur...';
  rs_Resume_records_treated_records_back_records_with_error =
          'Résumé :'+_CRLF+_CRLF+'@ARG enregistrement(s) traité(s).'+_CRLF
    +'@ARG enregistrement(s) récupéré(s).'+_CRLF
    +'@ARG enregistrement(s) non récupéré(s) car erreur.';
  rs_Searching_in_progress = 'Recherche en cours...';
  rs_Search_Form_infos ='Cette fiche permet deux types de recherche:'+_CRLF+_CRLF
    +'L''onglet Standard permet de sélectionner un individu selon'+_CRLF
    +'son numéro SOSA, son nom, son prénom et les propriétés de ses'+_CRLF
    +'événements naissance ou décès.'+_CRLF
    +'La recherche par SOSA est exclusive et ne tient pas compte'+_CRLF
    +'des autres critères.'+_CRLF
    +'Les autres critères se cumulent : pour être sélectionné, un'+_CRLF
    +'individu doit satisfaire ? l''ensemble des critères.'+_CRLF
    +'Le mot recherché peut être n''importe où dans le champ'+_CRLF
    +'correspondant au critère, seuls les critères Nom et Prénom'+_CRLF
    +'permettent de choisir si ce mot doit être au d?but du champ.'+_CRLF
    +'Les critères SOSA, Année de naissance ou de décès sont'+_CRLF
    +'exclusivement numériques.'+_CRLF+_CRLF
    +'L''onglet Notes/Sources permet de sélectionner un individu'+_CRLF
    +'en fonction du contenu des divers champs Notes ou Sources'+_CRLF
    +'de sa fiche, selon le champ de critère utilisé.'+_CRLF
    +'Le mot recherché peut se trouver n''importe où dans le champ'+_CRLF
    +'correspondant.'+_CRLF+_CRLF
    +'L''utilisation du symbole % dans un critère de recherche non'+_CRLF
    +'numérique permet de rechercher la présence de plusieurs mots'+_CRLF
    +'dans le champ. Exemple: "mariage%catherine" permet de retrouver'+_CRLF
    +'"mariagede Catherine" ainsi que "mariage de sa petite fille'+_CRLF
    +'Catherine".'+_CRLF
    +'Un symbole < ou > placé devant une année de naissance ou de décès'+_CRLF
    +'signifie avant ou après cette année.'+_CRLF
    +'Un symbole < ou > placé devant le nombre d''unions signifie moins'+_CRLF
    +'ou plus que ce nombre.'+_CRLF
    +'La recherche est insensible ? la casse des caractères.';
  rs_Selected_file_exists = 'Le fichier sélectionné existe déjà.';
  rs_Select_dir_Directory_destination_of_base = 'Répertoire où copier la base:';
  rs_Select_dir_Documents_Directory = 'Répertoire des documents:';
  rs_Select_dir_GEDCOM_Directory = 'Répertoire des fichiers GEDCOM:';
  rs_Select_dir_New_Media_directory = 'Nouveau répertoire de ces médias:';
  rs_Select_dir_Backup_directory = 'Répertoire des sauvegardes:';
  rs_Select_dir_WhoAreThey_Directory = 'Répertoire de QuiSontIls:';
  rs_Should_better_cancel_update = 'Il est préférable d''annuler les modifications.';
  rs_SOSA = 'SOSA';
  rs_SOSA_is_not_a_number = 'Le n° SOSA n''est pas numérique.';
  rs_Suppressing_temp_table = 'Suppression table temporaire.';
  rs_Records = 'Actes';
  rs_Select_SOSA_Number_One = 'Sélectionner le Sosa n°1';
  rs_Server_Side = 'Poste serveur: @ARG.';
  rs_Script_Executed  = 'Script exécuté avec succès.';
  rs_Script_Executed_Valided  = 'Script exécuté avec succès.'+_CRLF
                               +'et modifications validées.';
  rs_the_joint = 'Son conjoint';
  rs_Without_known_child_and_joint = 'Sans conjoint ni enfant connu';
  rs_the_joints = 'Ses @ARG conjoints';
  rs_and_the_child = ' et son enfant';
  rs_and_the_children = ' et ses @ARG enfants';
  rs_This_action_is_minutes_longer ='Cette action IRRÉVERSIBLE peut durer plusieurs minutes.';
  rs_This_file_has_been_imported_with_success = 'Le fichier: @ARG a été importé avec succès.';
  rs_Title_Have_a_look_into = 'Regarder dans...';
  rs_Title_Original_database = 'Base d''origine:';
  rs_Title_Select_folder_to_open = 'Sélectionner le fichier à ouvrir';
  rs_There_is_no_printer = 'Il n''y a pas d''imprimante disponible.';
  rs_to_other = 'à d''autres';
  rs_to_every = 'à tous les ';
  rs_to_search = 'à chercher';
  rs_to_ignore = 'à ignorer';
  rs_Tree_Brothers_and_Sisters = 'Frères et sœurs';
  rs_Try_Later = 'Réessayez plus tard.';
  rs_Try_to_destroy_task_intro = 'Il semble que vous ayez du mal à démarrer le logiciel.';
  rs_Try_to_destroy_task_windows = 'Sur Windows il est possible que des spywares ralentissent le démarrage de l''application.'+_CRLF+
                                   'Si c''est le cas installez Spybot (gratuit) et effectuez une vérification,'+_CRLF+
                                   'ou bien, après avoir sauvegardé votre compte et vos fichiers, réinstallez Windows en le réparant.';
  rs_Try_to_destroy_task_what_to_do = 'Il se peut que le logiciel soit sur un autre écran ou bureau.'+_CRLF+
                                      'Si ça n''est pas le cas et que vous ne voyez plus Ancestromania,'+_CRLF+
                                      'allez dans le gestionnaire de tâches, ou bien dans le gestionnaire système,' +_CRLF+
                                      'ou sur une ligne de commandes ou console, et tuez la tâche Ancestromania.';
  rs_unknown_female = 'inconnue';
  rs_unknown_male = 'inconnu';
  rs_Unknown_father = 'Père Inconnu';
  rs_Unknown_mother = 'Mère Inconnue';
  rs_Unknown_parents = 'Parents Inconnus';
  rs_Not_Connected_To_Database = 'Pas de base connectée';
  rs_Update = 'Mettre à jour';
  rs_Updating_coord = 'Mise à jour des coordonnées.';
  rs_Updating_deprecated_events_sticks = 'Mise à jour des étiquettes d''événements obsolètes.';
  rs_Updating_sites_names = 'Mise à jour des noms de lieux.';
  rs_Base = ' base ';
  rs_Version = 'Version';
  rs_Wait = 'Patienter...';
  rs_Wait_Adapting_families_dates = 'Adaptation des dates familiales.';
  rs_Wait_Adapting_persons_dates = 'Adaptation des dates individuelles.';
  rs_Wait_Adding_medias = 'Référencement des médias.';
  rs_Wait_Analysing_GEDCOM_file = 'Décodage du fichier GEDCOM.';
  rs_Wait_Asking_to_database = 'Interrogation de la base en cours.';
  rs_Wait_Exporting_families = 'Exportation des familles.';
  rs_Wait_Exporting_medias_files = 'Exportation des fichiers'+_CRLF+'des médias.';
  rs_Wait_Exporting_persons = 'Exportation des individus.';
  rs_Wait_Exporting_sources = 'Exportation des sources.';
  rs_Wait_Importing_witnesses = 'Importation des témoins.';
  rs_Wait_Loading_families = 'Chargement des familles.';
  rs_Wait_Loading_families_events = 'Chargement des événts. familiaux.';
  rs_Wait_Loading_persons = 'Chargement des individus.';
  rs_Wait_Loading_persons_events = 'Chargement des événts. individuels.';
  rs_Wait_Loading_medias = 'Chargement des médias.';
  rs_Wait_Loading_sources = 'Chargement des sources.';
  rs_Wait_Updating_medias = 'Patientez, mise à jour'+_CRLF+'des médias en cours...';
  rs_wait_Optimising_database = 'Optimisation de la base';
  rs_Wait_Preparing_export = 'Préparation de l''exportation.';
  rs_Wait_Preparing_import = 'Préparation de l''importation.';
  rs_Wait_script_execution = 'Exécution du script';
  rs_Wait_step_number = 'Patientez SVP, étape ';
  rs_Wait_Updating_Database = 'Mise à jour de la base.';
  rs_Wait_Validating_data = 'Validation des données.';
  rs_Wait_Verifying_media_files_presence = 'Contrôle présence des fichiers'+_CRLF+'des médias.';
  rs_Warning_Action_will_separate_names_by_a_comma_with_space =
  'Cette fonction sépare les prénoms par une virgule et un espace.';
  rs_Warning_Action_will_update_sites_identified_by_postal_code_city_country =
  'Cette fonction met à jour les codes INSEE des événements et domiciles.'+_CRLF
    +'Les lieux sont identifiés par le code postal, la ville et le pays.';
  rs_Warning_Action_will_update_only_names_putting_first_char_to_upper =
  'Cette fonction met seulement la première lettre des prénoms en majuscule.';
  rs_Warning_Action_will_update_only_names_putting_them_to_upper =
  'Cette fonction met les prénoms tout en majuscules.';
  rs_Warning_Action_will_update_only_surnames_putting_first_char_to_upper =
  'Cette fonction met seulement la première lettre des patronymes en majuscule.';
  rs_Warning_Action_will_update_only_surnames_putting_them_to_upper =
  'Cette fonction met les patronymes tout en majuscules.';
  rs_Warning_If_cannot_access_to_database_please_reopen_session =
  'Si vous ne pouvez accéder à la base veuillez rouvrir la session.';
  rs_Warning_Database_empty_Fill_a_folder = 'Votre base de données est vide.'+_CRLF+_CRLF
      +'Commencez par créer un dossier dans l''écran suivant.';
  rs_Warning_Database_is_readonly_Do_you_want_to_use_it =
      'La base sélectionnée est en lecture seule !'+_CRLF+_CRLF+'Désirez-vous quand même l''utiliser ?';
  rs_Warning_Date_sorting_will_be_default = 'Cette action va supprimer votre tri et remettre'+_CRLF
    +'le tri par date.';
  rs_Warning_Date_sorting_excepting_birth_will_be_default = 'Cette action va supprimer votre tri et remettre'+_CRLF
    +'le tri par date (sauf la Naissance toujours en premier).';
  rs_Warning_directory_does_not_exists = 'Ce répertoire n''existe pas.';
  rs_Warning_The_Base_image_and_folder_files_directory_must_be_correct = 'Le "Répertoire de base des images et fichiers attachés au dossier" doit'+_CRLF
      +'être valide et défini dans les détails du dossier en cours avant de'+_CRLF
      +'pouvoir attacher des médias, les exporter ou modifier leur chemin.'+_CRLF+_CRLF
      +'Accédez à la fonction permettant de le définir par le menu:'+_CRLF
      +'"Généalogies / Dossiers de la base", bouton "Modifier/détails".'+_CRLF+_CRLF
      +'La possibilité de transférer vos données sur un autre ordinateur'+_CRLF
      +'exige une bonne organisation de vos fichiers. Pour la faciliter,'+_CRLF
      +'il est recommandé d''organiser le stockage de tous les fichiers'+_CRLF
      +'attachés à votre dossier, à l''intérieur d''un seul répertoire de base.'+_CRLF
      +'La modification des adresses consécutive au tranfert des fichiers,'+_CRLF
      +'à l''aide de la fonction "Remplacer chemin", en sera grandement facilitée.';
  rs_Warning_file_already_exists_do_you_overwrite_it = 'Le fichier sélectionné existe déjà.'+_CRLF+_CRLF+'Souhaitez-vous l''écraser ?';
  rs_Warning_file_and_directory_already_exists_do_you_overwrite_it = 'Ce fichier et ce dossier sélectionnés existent déjà:'
                                                                   +_CRLF+'@ARG'+_CRLF+'@ARG'+_CRLF+_CRLF+'Souhaitez-vous les écraser ?';
  rs_Warning_There_is_another_report_with_same_name = 'Il existe déjà un rapport du même nom !';
  rs_Warning_this_Database_version_is_old = 'Base version @ARG.'+_CRLF+_CRLF
            +'Il est possible que des informations ne soient pas transférées'+_CRLF
            +'et que cela perturbe le fonctionnement du logiciel.'+_CRLF
            +'Nous vous conseillons fortement de faire ce transfert sur une'+_CRLF
            +'copie de votre base et de la vérifier.';
  rs_Warning_Number_already_exists_a_new_number_will_be_set = 'Le N° fixe @ARG existe déjà dans la base.'+_CRLF+_CRLF+
      'Un nouveau N° sera attribué par le logiciel.';
  rs_When_a_SOSA_is_searched_there_other_criterias_are_ignored =
            'Lorsqu''un N° SOSA est recherché, les autres critères sont ignorés.';
  rs_where_one_parent_is_unknown = 'dont au moins un parent est inconnu.';
  rs_while_Executing_request  = ' pendant l''exécution de la requête.';
  rs_while_showing  = ' lors de l''affichage.';
  rs_with = 'avec' ;
  rs_Witness = 'Témoin';
  rs_Witnesses = 'Témoins';
  rs_Youll_update_after_having_copied = 'Vous pourrez ensuite recommencer cette mise à jour.';
  rs_Youll_delete_the_record_of_this_event = 'Vous allez supprimer l''enregistrement de cet événement.';


implementation

end.

