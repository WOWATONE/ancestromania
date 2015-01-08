{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestrologie                             }
{           Source Language:  Francais                                  }
{           Auteur:                        }
{           Philippe Cazaux-Moutou                                       }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_common_const;

interface

uses
  Controls,Graphics, LCLType;

type TCalendrier=(cGRE,cJUL);

const
  //Les curseurs
  _CURPOPUP=5;
//  _CURHAND=6;
  _CURSOR_ZOOM_MOINS=6;
  _CURSOR_ZOOM_PLUS=7;
  _CURSOR_MAIN=8;
//  _CURSOR_NO=9;
//  _CURSOR_SELECT=crDefault;

  _KEY_HELP=VK_F1;
  _KEY_OPEN_LIST=VK_F4;

  //Les modules
  _ID_INDIVIDU=1;
  _ID_ARBRE=3;//laissé juste pour l'aide
  _ID_RECHERCHER=4;
  _ID_ANNIVERSAIRE=5;
  _ID_VILLES=6;
  _ID_ASSISTANT_CONFIG=8;
//  _ID_QUI_SUIS_JE=9;
  _ID_IMPORTATION_GEDCOM=10;
  _ID_EXPORTATION_GEDCOM=11;
  _ID_EXPORTATION_GENEANET=12;
//  _ID_INDIVIDU_PAR_PRENOM=20;
//  _ID_ARBRE_HIERARCHIQUE=21;
  _ID_PARAMETRES=98;
//  _ID_QUITTER=99;
  _ID_DOSSIER=30;
//  _ID_NO_DOSSIER=92;
  _ID_PRINT_ARBRE=31;
  _ID_PRINT_ROUE=32;
  _ID_PRINT=33;
  _ID_POSTIT=34;
  _ID_EDIT_TABLE_REF_PARTICULES=35;
  _ID_EDIT_TABLE_REF_PREFIXES=36;
//  _ID_EDIT_TABLE_REF_RELIGIONS=37;
  _ID_EDIT_RACCOURCIS_SAISIE=38;
  _ID_EMPLACEMENT_BDD=40;
  _ID_RESTORE_BDD=42;
//  _ID_WEB=43;
  _ID_EDIT_TOKEN_DATE=44;
  _ID_SAISIE_RAPIDE=45;
  _ID_INFOS_DOSSIER=46;
  _ID_NOUVEAUX_INDI=47;
  _ID_NAVIGATEUR_INDI=48;
  _ID_OPENSOURCES=65;
//  _ID_NAISSVILLES=66;
  _ID_VILLES_FAVORIS=70;
//  _ID_WEB_NEWS=80;
//  _ID_WEB_FORUM=81;

  _HELP_BIENVENUE=1000;
  _HELP_INDI_IDENTITE=1001;
  _HELP_INDI_UNIONS=1002;
  _HELP_INDI_ARBRE=1003;
  _HELP_INDI_PHOTO_DOC=1004;
  _HELP_INDI_INFOS=1005;
  _HELP_INDI_DOMICILES=1006;
  _HELP_INDI_START=1007;
  _HELP_FAVORIS=1008;
  _HELP_PB_BDD=1009;

  //les noms des répertoire par défaut
  _REL_PATH_DATABASE='Database'+DirectorySeparator;
  _REL_PATH_IMPORT_EXPORT='ImportExport'+DirectorySeparator;
  _REL_PATH_DOC='Documents'+DirectorySeparator;
  _REL_PATH_BACKUP='Backup'+DirectorySeparator;
  _REL_PATH_REPORT='Reports'+DirectorySeparator;
  _REL_PATH_HELP='Help'+DirectorySeparator;
  _REL_PATH_TRADUCTIONS='Traductions'+DirectorySeparator;
  _REL_PATH_GOODIES='Goodies'+DirectorySeparator;
  _REL_PATH_PLUGINS='PlugIns'+DirectorySeparator;

  EXTENSION_FIREBIRD = '.fdb';

  _EXT_TRADUC='.traduc';

  _MAX_REP_PATH=59;

  _REP_ASCENDANCE_COMPLET=0;
  _REP_ASCENDANCE_PAR_HOMMES=1;
  _REP_ASCENDANCE_PAR_FEMMES=2;

  _REP_DESCENDANCE_COMPLET=10;
  _REP_DESCENDANCE_PATRONYMIQUE=11;

  _REP_LISTE_ALPHA_HOMME=20;
  _REP_LISTE_ALPHA_FEMME=21;
  _REP_LISTE_ALPHA_TOUS=22;

  _REP_LISTE_DIVERS_UNION=30;
  _REP_LISTE_DIVERS_ECLAIR=31;
  _REP_LISTE_DIVERS_EVENEMENT=32;
  _REP_LISTE_DIVERS_ANNIVERSAIRE=33;
  _REP_LISTE_DIVERS_ENFANTS=34;
  _REP_LISTE_DIVERS_FRATRIE=35;
  _REP_LISTE_DIVERS_ONCLES_TANTES=36;
  _REP_LISTE_DIVERS_COUSINAGE=37;

  _REP_FICHE_INDIVIDUELLE=40;
  _REP_FICHE_FAMILIALE=41;

  _REP_STAT_PATRONYME=50;
  _REP_STAT_PRENOM=51;
  _REP_STAT_AGE_PREMIERE_UNION=52;
  _REP_STAT_LONGEVITE=53;
  _REP_STAT_NB_ENFANT_UNION=54;
  _REP_STAT_RECENSEMENT=55;
  _REP_STAT_DENOMBREMENT_ASCENDANCE=56;
  _REP_STAT_DENOMBREMENT_DESCENDANCE=57;
  _REP_STAT_GRAPH_NAISS_DEPT=58;
  _REP_STAT_PROFESSIONS=59;

  //mode menu
  _SHOW_MENU_PRINCIPAL=1;
  _SHOW_MENU_GRAPH=2;

  _COLOR_SOSA=clGreen;
  _CRLF=#13#10;
  _AnMini=-5800000;//année minimale gérable pour la transformation d'une date grégorienne en entier
    //doit toujours être un multiple de 400 pour rendre possible le calcul des années bisextiles
  _AnMaxi=8000;

  _DLLQUISONTILS='QuisontilsDll.dll';

  _i_IndiConf=1;
  _s_IndiConf='1';
  _i_SansCtrlDates=2;
  _s_SansCtrlDates='2';
  _i_IdentiteIncertaine=4;
  _s_IdentiteIncertaine='4';
  _i_ContinuerRecherches=8;
  _s_ContinuerRecherches='8';

  _lc_ctypeANSI={$IFDEF FPC}'UTF8'{$ELSE}'ISO8859_1'{$ENDIF};
  _lc_ctype='';
  _lc_ctypeUTF8='utf8';
  _lc_ctype_params='';


  _AlphabetMaj='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  {$IFNDEF WINDOWS}
  DEFAULT_FIREBIRD_SERVER_DIR = '/var/lib/firebird/2.5/';
  DEFAULT_FIREBIRD_DATA_DIR = DEFAULT_FIREBIRD_SERVER_DIR+'data/';
  {$ENDIF}

implementation

end.
