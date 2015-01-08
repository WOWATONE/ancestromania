{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                           }
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

unit u_common_resources;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, u_common_const;

const CST_THREE_POINTS = '…';
      CST_LC_CTYPE = 'lc_ctype=';


resourcestring
  rs_charset_gedcom = 'iso88591';
  rs_charset_windows = 'cp1252';
  rs_Caption_Universal_calendar = 'Calendrier universel.';
  rs_Confirm_using_readonly_database = 'La base sélectionnée est en lecture seule !'+_CRLF+_CRLF
          +'Désirez-vous quand même l''utiliser ?';
  rs_Confirm_readonly_supress = 'Etes-vous certain d''enlever l''attribut "lecture seule" de cette base de données?';
  rs_Error_Cannot_connect_to_database = 'Erreur BASE : Impossible de se connecter à la base...';
  rs_Error_Cannot_start_software_with_a_readonly_database = 'Impossible d''utiliser le logiciel avec une base en lecture seule.';
  rs_Error_Database_file_doesnt_exist = 'Le fichier demandé :'+_CRLF
          +'@ARG'+_CRLF+'n''existe pas.';
  rs_Error_Database_too_old_or_corrupted = 'Base trop ancienne ou corrompue.'+_CRLF+_CRLF;
  rs_Error_Verify_that_database_alias_is_defined_in_alias_conf_file = 'Vérifiez que l''alias de la base '+_CRLF+'"@ARG"'+_CRLF
                +'est bien défini dans le fichier alias.conf de l''installation d''Ancestromania,'+_CRLF
                +'et que le fichier correspondant existe.'+_CRLF+_CRLF;
  rs_Error_Verify_that_its_file_exists = 'Vérifiez que son fichier existe.';
  rs_Error_Verify_that_your_connected_to_network_server_address_alias_password =
             'Vérifiez que vous êtes bien connecté à votre réseau,'+_CRLF+_CRLF
            +'que l''adresse du serveur "@ARG" est bonne,'+_CRLF+_CRLF
            +'que l''alias de la base "@ARG"'
            +'est bien défini sur le serveur,'+_CRLF+_CRLF
            +'que le fichier correspondant existe,'+_CRLF+_CRLF
            +'et que l''identifiant et le mot de passe fournis lors de la connexion'+_CRLF
            +'sont bien enregistrés sur le serveur.';
  rs_Error_You_are_identified_on_server_but_you_have_no_right_on_database =
        'Vous êtes bien identifié sur ce serveur mais vous ne possédez'+_CRLF
          +'pas les droits d''utilisation de cette base de données ou'+_CRLF
          +'la base n''a pas la structure attendue.';
  rs_Firebird_Message = 'Message reçu de Firebird : ';
  rs_Firebird_Version = 'Version de Firebird : @ARG.';
  rs_Function_by_Thierry_Colier = 'Cette fonction a été initialement développée par Thierry Colier.'+_CRLF+_CRLF
    +'Merci à lui.';
    rs_Info_Calendar_Copt =   'Calendrier Copte.'+_CRLF+_CRLF

    +'Encore utilisé de nos jours en Égypte.'+_CRLF+_CRLF

    +'Ce calendrier est de type solaire.'+_CRLF
    +'L''année se compose de douze mois de 30 jours, suivis, trois années de suite,'+_CRLF
    +'de 5 jours complémentaires dits épagomènes et la 4ème année de 6 jours '+_CRLF
    +'épagomènes.'+_CRLF
    +'La durée moyenne de l''année (365,25 jours) est donc la même que dans le'+_CRLF
    +'calendrier julien.'+_CRLF+_CRLF

    +'Ce calendrier définit l''ère de Dioclétien dont l''origine (1 Tout de l''an 1)'+_CRLF
    +'correspond au 29 août 284 julien. Les années de 366 jours correspondent à'+_CRLF
    +'celles dont le millésime plus 1 est multiple de 4.'+_CRLF+_CRLF

    +'L''année copte commence le 29 ou le 30 août julien.';

  rs_Info_Calendar_Gregorian =    'Calendrier Grégorien.'+_CRLF+_CRLF
    +'En fait, la terre tourne autour du soleil en 365.24219879 jours, soit avec 11 mn'+_CRLF
    +'et 14 s de moins que l''année julienne. En 1582, le pape Grégoire XIII, sous les'+_CRLF
    +'conseils de l''astronome Louis LILIO, décida donc de réformer le calendrier julien'+_CRLF
    +'pour rattraper le retard (18 h 40 mn par siècle soit 10 jours depuis sa création).'+_CRLF
    +'Le jeudi 4 Octobre 1582 fut donc suivi du vendredi 15 Octobre, la succession'+_CRLF
    +'des jours de la semaine étant respectée.'+_CRLF
    +'En France, il fallut attendre que Henri III approuve cette réforme, par'+_CRLF
    +'l''ordonnance royale de Novembre 1582; le dimanche 9 Décembre 1582 fut'+_CRLF
    +'donc suivi du lundi 20 Décembre 1582.'+_CRLF
    +'L''année resta de 365 jours, mais certaines années bissextiles furent supprimées.'+_CRLF
    +'Ainsi, sont bissextiles les années divisibles par 4 sans obtenir de reste ainsi que'+_CRLF
    +'les années se terminant par 2 zéros si elles sont divisibles par 400 sans obtenir'+_CRLF
    +'de reste; exemple 1900 n''est pas bissextile contrairement à 2000. Cette année'+_CRLF
    +'réformée est encore trop longue de 25 s et le retard atteindra 1 jour en 4317...'+_CRLF
    +'Dans les autres pays, cette réforme s''étala dans le temps:'+_CRLF
    +'1582: Italie, Espagne, Portugal, Pays-Bas catholiques'+_CRLF
    +'1584: Autriche, Allemagne catholique, Suisse catholique'+_CRLF
    +'1586: Pologne'+_CRLF
    +'1587: Hongrie'+_CRLF
    +'1610: Prusse'+_CRLF
    +'1700: Allemagne protestante, Pays-Bas protestants, Danemark, Norvège'+_CRLF
    +'1752: Grande Bretagne, Suède'+_CRLF
    +'1753: Suisse protestante'+_CRLF
    +'1917: Bulgarie'+_CRLF
    +'1919: Roumanie, Yougoslavie'+_CRLF
    +'1923: URSS, Grèce';
  rs_Info_Calendar_Juive = 'Calendrier Israélite.'+_CRLF+_CRLF

    +'Le calendrier israélite remonte, sous sa forme actuelle, au IVème siècle après'+_CRLF
    +'J.-C.'+_CRLF+_CRLF

    +'Il est de type luni-solaire. Il assure une durée moyenne du mois (29,530594'+_CRLF
    +'jours) très voisine de celle de la lunaison en utilisant des mois d''une durée de 29'+_CRLF
    +'ou 30 jours.'+_CRLF+_CRLF

    +'Il assure aussi une durée moyenne de l''année (365,2468 jours) voisine de celle '+_CRLF
    +'de l''année tropique en faisant alterner 12 années communes de 12 mois et 7'+_CRLF
    +'années embolismiques de 13 mois à l''intérieur d''un cycle de 19 ans.'+_CRLF+_CRLF

    +'Dans chaque cycle les années embolismiques sont celles numérotées 3, 6, 8,'+_CRLF
    +'11, 14, 17 et 19. Le cycle actuel a commencé le 1 Tisseri de l''an 5739 qui'+_CRLF
    +'correspond au lundi 2 octobre 1978.'+_CRLF+_CRLF

    +'Les années communes peuvent durer 353, 354, ou 355 jours et les années'+_CRLF
    +'embolismiques, 383, 384, ou 385 jours. Les trois espèces d''années ainsi'+_CRLF
    +'définies sont dites, respectivement, défectives, régulières ou abondantes.'+_CRLF+_CRLF

    +'La date origine du calendrier israélite est le 1 Tisseri de l''an 1. Elle correspond'+_CRLF
    +'au 7 octobre -3760 julien.';
  rs_Info_Calendar_Julian = 'Calendrier Julien.'+_CRLF+_CRLF

    +'Le calendrier julien est, dans ses principales dispositions, conforme au'+_CRLF
    +'calendrier romain réformé par Jules César. Dans l''usage moderne, on l''emploie'+_CRLF
    +'avec l''ère chrétienne dont l''an 1 fut la 47ème de cette réforme julienne.'+_CRLF
    +'Ce calendrier est de type solaire. Il comporte deux sortes d''années, les années'+_CRLF
    +'communes de 365 jours, divisées en 12 mois de 31, 28, 31, 30, 31, 30, 31, 31,'+_CRLF
    +'30, 31, 30 et 31 jours, et les années bissextiles de 366 jours dans lesquelles le'+_CRLF
    +'deuxième mois est de 29 jours. Les années bissextiles sont celles dont le'+_CRLF
    +'millésime est divisible par 4; une année sur 4 est donc bissextile.'+_CRLF
    +'La durée moyenne de l''année julienne (365,25 jours) est une approximation'+_CRLF
    +'médiocre de celle de l''année tropique. Il en résulte que les dates des saisons se'+_CRLF
    +'décalent d´environ 3 jours tous les 400 ans, soit d´un mois tous les 4000 ans.'+_CRLF
    +'Le calendrier julien a été en usage dans la plupart des nations d''Europe'+_CRLF
    +'jusqu''au XVIème siècle.'+_CRLF
    +'Il a été remplacé ensuite par le calendrier grégorien mais il est encore utilisé de'+_CRLF
    +'nos jours pour déterminer les fêtes religieuses orthodoxes.';
  rs_Info_Calendar_Musulman = 'Calendrier Musulman.'+_CRLF+_CRLF

    +'Le calendrier musulman a été adopté, sous sa forme actuelle, vers 632 après'+_CRLF
    +'J.-C. Il définit l''ère musulmane dont l''origine, 1er jour de l''an 1 (Hégire),'+_CRLF
    +'correspond au vendredi 16 juillet 622 julien.'+_CRLF+_CRLF

    +'C''est un calendrier de type lunaire. Les années sont de 12 mois. Le cycle'+_CRLF
    +'lunaire des musulmans est de 30 ans.'+_CRLF+_CRLF

    +'Il comporte 19 années communes de 354 jours et 11 années abondantes de'+_CRLF
    +'355 jours. D''une année à l''autre le début de l''année musulmane se décale'+_CRLF
    +'donc de 10 à 12 jours par rapport aux saisons (en moyenne de 10.875523...'+_CRLF
    +'jours par an).'+_CRLF+_CRLF

    +'A l''intérieur d''un cycle les années abondantes sont les années numérotées 2, 5,'+_CRLF
    +'7, 10, 13, 16, 18, 21, 24, 26, 29.'+_CRLF
    +'Le cycle actuel a commencé le 1 Mouharram de l''an 1411 de l''ère musulmane'+_CRLF
    +'qui correspond au mardi 24 juillet 1990.'+_CRLF+_CRLF

    +'Les mois sont d''une durée de 30 et 29 jours alternativement, le premier mois de'+_CRLF
    +'l''année étant de 30 jours et le dernier de 29 jours (année commune) ou 30 jours'+_CRLF
    +'(année abondante). La durée moyenne du mois (29,530556 jours) est voisine de'+_CRLF
    +'celle de la lunaison.';
  rs_Info_Calendar_Republican = 'Calendrier Républicain.'+_CRLF+_CRLF

    +'Institué par la Convention Nationale le 24 Novembre 1793, il fut en usage en'+_CRLF
    +'France du 6 Octobre 1793 au 1er Janvier 1806.'+_CRLF+_CRLF

    +'L''année républicaine débute à l''équinoxe d''automne, date anniversaire de la'+_CRLF
    +'proclamation de la République (22 septembre 1792). Elle est constituée de 12'+_CRLF
    +'mois égaux que Fabre d''Eglantine baptisa : Vendémiaire, Brumaire, Frimaire,'+_CRLF
    +'Nivôse, Pluviôse, Ventôse, Germinal, Floréal, Prairial, Messidor, Thermidor,'+_CRLF
    +'Fructidor.'+_CRLF
    +'Chaque mois est composé de trois décades comprenant chacune 10 jours nommés:'+_CRLF
    +'Primidi, Duodi, Tridi, Quartidi, Quintidi, Sextidi, Septidi, Octidi, Nonidi et Décadi.'+_CRLF
    +'Ce qui fait 360 jours.'+_CRLF
    +'Donc, l''ajustement avec le cycle solaire se fait par l''addition de 5 jours'+_CRLF
    +'complémentaires appelés Sans-Culottides (6 pour les années bissextiles), qui'+_CRLF
    +'sont consacrés aux valeurs républicaines:'+_CRLF
    +'Fête de la Vertu, Fête du Génie, Fête du Travail, Fête de l''Opinion, Fête des'+_CRLF
    +'Récompenses et Jour de la Révolution.';


implementation

end.
