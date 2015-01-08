unit ancestroweb_strings_delphi;

{$IFDEF FPC}
  {$mode Delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils;

resourcestring
  gs_ANCESTROWEB_LittleDateFormat = 'dd-mm-yyyy';
  gs_ANCESTROWEB_Language = 'Français';
  gs_ANCESTROWEB_DoEraseOldExport = 'Effacer le répertoire ';
  gs_ANCESTROWEB_FORM_CAPTION = 'Générer un Site Web Généalogique Statique';
  gs_ANCESTROWEB_EXPORT_WEB_BORN = ' - Naissance : ';
  gs_ANCESTROWEB_EXPORT_WEB_DIED = ' - D&eacute;c&egrave;s : ';
  // -- Titre de la DLL qui s'affichera dans le menu ADD'ON, a vous d'y mettre votre titre ----------------
  gs_ANCESTROWEB_TITRE = 'AncestroWeb : Générer un Site Web Généalogique';
  gs_ANCESTROWEB_ExportMoreThan5Chars =
    'Le chemin d''exportation web doit faire plus de 5 caractères.';
  gs_ANCESTROWEB_Delete =
    'Effacement';
  gs_ANCESTROWEB_ExportDelete =
    'Confirmez-vous l''effacement du dossier d''exportation'+#13#10+'@ARG ?';
  gs_ANCESTROWEB_ExportErrorCreate = 'Erreur à la copie de ';
  gs_ANCESTROWEB_ExportErrorErase = 'Erreur à l''effacement de ';
  gs_ANCESTROWEB_ErrorCreateSOSA = 'Erreur : Effectuez une numérotation SOSA.';
  gs_ANCESTROWEB_ErrorThemes = 'Erreur : Aucun thème dans le répertoire ';
  gs_ANCESTROWEB_ErrorFiles = 'Erreur : Aucune source dans le répertoire ';
  gs_ANCESTROWEB_HTMLTitle = 'Généalogie @ARG';
  gs_ANCESTROWEB_FullTree = 'Arbre';
  gs_ANCESTROWEB_FamilyTree = 'Arbre familial';
  gs_ANCESTROWEB_FamilyPersons = 'membres';
  gs_ANCESTROWEB_FamilyPerson = 'membre';
  gs_ANCESTROWEB_Search = 'Recherche';
  gs_ANCESTROWEB_SearchLong = 'Rechercher sur le site';
  gs_ANCESTROWEB_Ages   = 'Âges';
  gs_ANCESTROWEB_Job   = 'Métier';
  gs_ANCESTROWEB_Jobs   = 'Métiers';
  gs_ANCESTROWEB_Jobs_Count= 'Métiers';
  gs_ANCESTROWEB_Jobs_Total= 'Totaux des métiers et villes :';
  gs_ANCESTROWEB_Jobs_Cities= 'Villes';
  gs_ANCESTROWEB_A_Job  = 'Métier';
  gs_ANCESTROWEB_Jobs_Long  = 'Statistiques des métiers';
  gs_ANCESTROWEB_Send   = 'Envoyer';
  gs_ANCESTROWEB_MailCaption   = 'Envoyer un message';
  gs_ANCESTROWEB_Reset  = 'Effacer';
  gs_ANCESTROWEB_Home = 'Accueil';
  gs_ANCESTROWEB_Welcome = 'Bienvenue !';
  gs_ANCESTROWEB_WomanBornOn = 'Née le ';
  gs_ANCESTROWEB_ManBornOn = 'Né le ';
  gs_ANCESTROWEB_Map = 'Carte';
  gs_ANCESTROWEB_Map_To = 'à';
  gs_ANCESTROWEB_MapMaxZoom = '13';
  gs_ANCESTROWEB_MapCaptions = 'Évaluation visuelle du nombre de membres de la famille';
  gs_ANCESTROWEB_Map_Long = 'Carte des patronymes';
  gs_ANCESTROWEB_MapCountry = 'FRANCE';
  gs_ANCESTROWEB_MapProblemNoPostalCode = 'Problème : Pas de code postal';
  gs_ANCESTROWEB_MapProblemNoCity = 'Problème : Pas de ville';
  gs_ANCESTROWEB_WomanDiedOn = 'Décédée le ';
  gs_ANCESTROWEB_ManDiedOn = 'Décédé le ';
  gs_ANCESTROWEB_Surnames = 'Patronymes';
  gs_ANCESTROWEB_Surnames_Long = 'Scruter les patronymes';
  gs_ANCESTROWEB_Contact = 'Contact';
  gs_ANCESTROWEB_Files = 'Fiches';
  gs_ANCESTROWEB_Files_Long = 'Trouver un individu';
  gs_ANCESTROWEB_List = 'Liste';
  gs_ANCESTROWEB_Person = 'Individu';
  gs_ANCESTROWEB_Born = 'Naissance';
  gs_ANCESTROWEB_Died = 'Décès';
  gs_ANCESTROWEB_Years = ' Ans';
  gs_ANCESTROWEB_At = ' à ';
  gs_ANCESTROWEB_Finished = 'Finie.';
  gs_ANCESTROWEB_Generation = ' génération';
  gs_ANCESTROWEB_Generating = 'Création : ';
  gs_ANCESTROWEB_Generations = ' générations';
  gs_ANCESTROWEB_Ancestry = 'Ascendance';
  gs_ANCESTROWEB_Descent = 'Descendance';
  gs_ANCESTROWEB_AnAge = 'Âge';
  gs_ANCESTROWEB_TotalAgeDead = 'Total des individus avec un âge au décès :';
  gs_ANCESTROWEB_Persons_Count = 'Nombre d''individus';
  gs_ANCESTROWEB_Men_Count = 'Hommes';
  gs_ANCESTROWEB_Women_Count = 'Femmes';
  gs_ANCESTROWEB_Ages_Long  = 'Statistiques de longévités';
  gs_ANCESTROWEB_The_Medias = 'les médias : ';
  gs_ANCESTROWEB_Family_On = 'Union le ';
  gs_ANCESTROWEB_Union = 'Union';
  gs_ANCESTROWEB_Unions = 'Unions';
  gs_ANCESTROWEB_Statistics = 'Statistiques';
  gs_ANCESTROWEB_NoData = 'Pas de base de données ouvertes';
  gs_ANCESTROWEB_ArchiveLinkBegin = 'A';

  gs_ANCESTROWEB_cantConnect = 'Impossible de se connecter à la base : ';
  gs_ANCESTROWEB_cantCreateATree = 'Impossible de créer l''arbre : ';
  gs_ANCESTROWEB_cantSaveTree = 'Impossible de sauver l''arbre ici : ';
  gs_ANCESTROWEB_cantSaveFile = 'Impossible de sauver le fichier ici : ';
  gs_ANCESTROWEB_cantCreateImage = 'Impossible de manipuler cette image : ';
  gs_ANCESTROWEB_cantOpenData = 'Impossible d''ouvrir les données sur ';
  gs_ANCESTROWEB_cantOpenFile = 'Impossible d''ouvrir le fichier ici : ';
  gs_ANCESTROWEB_cantUseData = 'Impossible d''utiliser les données sur ';
  gs_ANCESTROWEB_cantCreateHere = 'Impossible de sauver ici : ';
  gs_ANCESTROWEB_cantCreateContact = 'Impossible de sauver la fiche de contact ici : ';
  gs_ANCESTROWEB_DownloadGedcom = 'Téléchargez mon Gedcom ici.';
  gs_ANCESTROWEB_CreatedBy = 'Créé par';
  gs_ANCESTROWEB_Please_Restart = 'Succès de la mise à jour !'+#10+' Veuillez redémarrer...';
  gs_ANCESTROWEB_StartUpdate = 'Une mise à jour de la base est nécessaire à partir de ce script :'+#10;
  gs_ANCESTROWEB_FileName_NotACopy = '-original';
  gs_ANCESTROWEB_Unset_Stats = 'Veuillez désactiver les statistiques dans l''onglet "Accueil".';

implementation

end.

