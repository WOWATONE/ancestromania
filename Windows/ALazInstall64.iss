[Setup]
Uninstallable=No
PrivilegesRequired=admin
AppName=Mise à jour de Ancestromania
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;Versions de la base et du logiciel à actualiser à chaque nouvelle version car utilisées dans le code
AppVerName=Mise à jour Lazarus v2014.1.b5.180
VersionInfoVersion=2014.1.3.1
;Attention, toujours 3 décimales pour la version de la base
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AppPublisher=André Langlet et Matthieu GIROUX
AppSupportURL=https://code.google.com/p/ancestromania/issues/list
AppUpdatesURL=http://genealogie.liberlog.fr/
DefaultDirName={code:doPathAncestro}
AppPublisherURL=http://genealogie.liberlog.fr/
DefaultGroupName=Ancestromania
DisableProgramGroupPage=yes
OutputBaseFilename=Install_AncestroIntel64
Compression=lzma
SolidCompression=yes
LicenseFile=LicenceTout.rtf
InfoBeforeFile=..\Docs\Evolutions.rtf
DisableDirPage=yes
DisableFinishedPage=no
DisableReadyPage=yes
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"

[Dirs]
Name: "{commonappdata}\Ancestromania"; Permissions: users-modify authusers-modify
Name: "{commonappdata}\Ancestromania\Update"; Permissions: users-modify authusers-modify
Name: "{commonappdata}\Ancestromania\Scripts"; Permissions: users-modify authusers-modify
Name: "{commonappdata}\Ancestromania\Reports"; Permissions: users-modify authusers-modify

[Files]
;fichiers de Firebird
Source: "..\x86_64-win64\embed\fbclient.dll"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\ib_util.dll"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\icudt30.dll"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\icuin30.dll"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\icuuc30.dll"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\firebird.conf"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\intl\fbintl.dll"; DestDir: "{tmp}\intl";
Source: "..\x86_64-win64\embed\intl\fbintl.conf"; DestDir: "{tmp}\intl";
Source: "..\x86_64-win64\embed\udf\fbudf.dll"; DestDir: "{tmp}\udf";
Source: "..\x86_64-win64\embed\udf\ib_udf.dll"; DestDir: "{tmp}\udf";
Source: "..\x86_64-win64\embed\udf\fbudf.sql"; DestDir: "{tmp}\udf";
Source: "..\x86_64-win64\embed\udf\ib_udf2.sql"; DestDir: "{tmp}\udf";
Source: "..\x86_64-win64\embed\firebird.msg"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\aliases.conf"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\msvcp80.dll"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\msvcr80.dll"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\Microsoft.VC80.CRT.manifest"; DestDir: "{tmp}";
Source: "..\x86_64-win64\embed\isql.exe"; DestDir: "{app}"; Flags : 64bit

Source: "..\x86_64-win64\Ancestromania.exe"; DestDir: "{app}";  BeforeInstall: BeforeInstallExe; Flags : 64bit
Source: "..\x86_64-win64\Ancestromania.ini"; DestDir: "{app}"; 
Source: "..\x86_64-win64\Images\*.*"; DestDir: "{app}\Images";
Source: "..\i386-win32\Help\*.*"; DestDir: "{app}\Help";
Source: "..\x86_64-win64\Tables de references\*.*"; DestDir: "{app}\Tables de references";
Source: "..\x86_64-win64\AncestroWeb\Classes\Box\*.*"; DestDir: "{app}\AncestroWeb\Classes\Box";
Source: "..\x86_64-win64\AncestroWeb\Classes\Scripts\*.*"; DestDir: "{app}\AncestroWeb\Classes\Scripts";
Source: "..\x86_64-win64\AncestroWeb\Classes\PhpMailer\*.*"; DestDir: "{app}\AncestroWeb\Classes\PhpMailer";
Source: "..\x86_64-win64\AncestroWeb\Classes\PhpMailer\language\*.*"; DestDir: "{app}\AncestroWeb\Classes\PhpMailer\language";
Source: "..\x86_64-win64\AncestroWeb\Files\default\*.*"; DestDir: "{app}\AncestroWeb\Files\default";
Source: "..\x86_64-win64\AncestroWeb\Themes\*.*"; DestDir: "{app}\AncestroWeb\Themes";
Source: "..\x86_64-win64\AncestroWeb\Themes\blue\Css\*.*"; DestDir: "{app}\AncestroWeb\Themes\blue\Css";
Source: "..\x86_64-win64\AncestroWeb\Themes\blue\Files\*.*"; DestDir: "{app}\AncestroWeb\Themes\blue\Files";
Source: "..\x86_64-win64\AncestroWeb\Themes\blue\Images\*.*"; DestDir: "{app}\AncestroWeb\Themes\blue\Images";
Source: "..\x86_64-win64\AncestroWeb\Themes\blue\Images\Map\*.*"; DestDir: "{app}\AncestroWeb\Themes\blue\Images\Map";
Source: "..\x86_64-win64\AncestroWeb\Themes\blue\Tree\*.*"; DestDir: "{app}\AncestroWeb\Themes\blue\Tree";
Source: "..\x86_64-win64\AncestroWeb\Themes\default\Css\*.*"; DestDir: "{app}\AncestroWeb\Themes\default\Css";
Source: "..\x86_64-win64\AncestroWeb\Themes\default\Files\*.*"; DestDir: "{app}\AncestroWeb\Themes\default\Files";
Source: "..\x86_64-win64\AncestroWeb\Themes\default\Images\*.*"; DestDir: "{app}\AncestroWeb\Themes\default\Images";
Source: "..\x86_64-win64\AncestroWeb\Themes\default\Images\Map\*.*"; DestDir: "{app}\AncestroWeb\Themes\default\Images\Map";
;scripts de mise à jour de la base toujours terminer le nom par 4 caractères numériques
Source: "..\x86_64-win64\Scripts\*.sql"; DestDir: "{commonappdata}\Ancestromania\Scripts";
Source: "..\i386-win32\MaBase.fdb"; DestDir: "{commonappdata}\Ancestromania\"; Flags : onlyifdoesntexist
Source: "..\i386-win32\Parances.fdb"; DestDir: "{commonappdata}\Ancestromania\"; 

; install only
;Source: "shfolder.dll"; Flags: dontcopy
                                                                                                                     
;fichiers devant rester en place
Source: "TablesReference.exe"; DestDir: "{app}"; Flags : 32bit 
Source: "RestaureBases.exe"; DestDir: "{app}"; Flags : 32bit
Source: "Cassinimania.exe"; DestDir: "{app}"; Flags : 32bit

;fichiers en attente de transfert ou utilisation

;fichiers des tables de référence
Source: "LisezMoiTR.txt"; DestDir: "{app}\Tables de references";
Source: "REF_EVENEMENTS.txt"; DestDir: "{tmp}";
Source: "REF_FILIATION.txt"; DestDir: "{tmp}";
Source: "REF_RELA_TEMOINS.txt"; DestDir: "{tmp}";
Source: "REF_TOKEN_DATE.txt"; DestDir: "{tmp}";
Source: "REF_CP_VILLES.txt"; DestDir: "{tmp}";
Source: "REF_DEPARTEMENTS.txt"; DestDir: "{tmp}";
Source: "REF_REGIONS.txt"; DestDir: "{tmp}";
Source: "REF_PAYS.txt"; DestDir: "{tmp}";
Source: "REF_PARTICULES.txt"; DestDir: "{tmp}";
Source: "REF_RACCOURCIS.txt"; DestDir: "{tmp}";
Source: "REF_PREFIXES.txt"; DestDir: "{tmp}";
Source: "REF_DIVERS_IND.txt"; DestDir: "{tmp}";
Source: "REF_DIVERS_FAM.txt"; DestDir: "{tmp}";
Source: "REF_MARR.txt"; DestDir: "{tmp}";

;fichiers des rapports
;Source: "age_premiere_union.rtm"; DestDir: "{tmp}";

[Icons]
Name: "{group}\Ancestromania"; Filename: "{app}\Ancestromania.exe"  ; WorkingDir: "{app}"
Name: "{group}\Cassinimania"; Filename: "{app}\Cassinimania.exe"  ; WorkingDir: "{app}"


[Run]
Filename: "{tmp}\migration.bat"; flags:runhidden
Filename: "{app}\Ancestromania.exe"; Description: "Démarrer Ancestromania"; flags: postinstall nowait unchecked


[Code]

var PathAppli:string;
    IniFile:String;

function InitializeSetup(): Boolean;
var ExeOk:boolean;
  VerSetup:string;
  VersionLS,NumVersion:cardinal;
  NumVersionMajor,NumVersionMinor,NumVersionRevision,NumVersionBuild:cardinal;
begin
  ExeOk:=false;
  IniFile := ExpandConstant('{localappdata}') + '\Ancestromania\user_config.ini' ;
  while not ExeOk do
  begin
    PathAppli := GetIniString( 'Path', 'PathAppli', ExpandConstant('{pf64}')+'\Ancestromania\', IniFile); 
    if PathAppli<>AddBackslash(PathAppli) then
      begin
        PathAppli:=AddBackslash(PathAppli);
        SetIniString( 'Path', 'PathAppli', PathAppli, IniFile);
      end;
      // 64 bits directory
    if ( pos ( ExpandConstant('{pf}'), PathAppli ) > 0 ) then
     PathAppli:=ExpandConstant('{pf64}')+'\Ancestromania\';
    if FileExists(PathAppli+'Ancestromania.exe') then
       ExeOk:=true
     else
      if  (PathAppli > '')
      and (MsgBox('Ancestromania.exe n''est pas dans le répertoire'+#13#10+PathAppli+#13#10
                  +'Confirmez-vous quand même la mise à jour dans ce répertoire?',mbConfirmation,MB_YESNO)=IDYES) then
         Begin
           ExeOk:=true;
           SetIniString( 'Path', 'PathAppli', PathAppli, IniFile);
         End;
    if not ExeOk then
    begin
      MsgBox('Le répertoire d''installation d''Ancestromania n''a pas été trouvé.'+#13#10
            +'Veuillez le sélectionner dans la fenêtre suivante.',mbError,MB_OK);
      if BrowseForFolder('Répertoire d''installation d''Ancestromania.',PathAppli,false) then
      begin
        PathAppli:=AddBackslash(PathAppli);
        if FileExists(PathAppli+'Ancestromania.exe') then
          ExeOk:=true
        else
    	    if MsgBox('Ancestromania.exe n''est pas dans le répertoire'+#13#10+PathAppli+#13#10
                  +'Confirmez-vous quand même la mise à jour dans ce répertoire?',mbConfirmation,MB_YESNO)=IDYES then
              ExeOk:=true;
        if ExeOk then
          SetIniString( 'Path', 'PathAppli', PathAppli, IniFile);
      end
      else
      begin
  	    MsgBox('Ancestromania n''est pas installé sur cet ordinateur!',mbError,MB_OK);
     	  abort;
   	  end;
    end;
  end;

  if FileExists(PathAppli+'Ancestromania.exe') then
  begin
    while CheckForMutexes('Ancestromania') do
    begin
      if MsgBox('Ancestromania est ouvert!'+#13
               +'Fermez-le avant de continuer!'+#13+#13
               +'Voulez-vous continuer?',mbError,MB_YESNO)=IDNO then
        abort;
    end;
  end;

  if FileExists(PathAppli+'gds32.dll') then
    DeleteFile(PathAppli+'gds32.dll');
  
  NumVersion:=(2006 shl 16)+420;
  if FileExists(PathAppli+'Ancestromania.exe') then
    if GetVersionNumbersString(PathAppli+'Ancestromania.exe',VerSetup) then
      GetVersionNumbers(PathAppli+'Ancestromania.exe',NumVersion,VersionLS)
     else
      if not FileExists(PathAppli+'Ancestromania.ini') then
        //Begin
         //IniFile := PathAppli + 'Ancestromania.ini' ;
         //NumVersion := (GetIniInt( 'Version', 'Major', 2006, 2006, 30050, IniFile) shl 16 ) + (GetIniInt( 'Version', 'Minor', 0, 0, 1000, IniFile) shl 8) +GetIniInt( 'Version', 'Buildr', 420, 0, 10000, IniFile);
      // End;
 if (NumVersion<(2006 shl 16)+420) then
  begin
    MsgBox('Votre logiciel V'+VerSetup+#13
          +'est trop ancien pour permettre la mise à jour automatique.'+#13
          +'Sauvegardez votre base de données et vos documents personnels,'+#13
          +'désinstallez Ancestromania et refaites une installation complète'+#13
          +'à la dernière version.'+#13
          +'Utilisez ensuite la fonction intégrée de transfert de dossier ou'+#13
          +'Mutancestre pour transférer les dossiers de votre ancienne base'+#13
          +'dans une base vide à la dernière version.',mbInformation,MB_OK);
    abort;
  end

  result:=true;
end;

procedure CopyFileToApp ( const AFile : String );
Begin
  FileCopy ( ExpandConstant('{tmp}') + '\' + AFile, PathAppli + AFile, False );
End;

procedure BeforeInstallExe();
begin
  if not FileExists(PathAppli+'Ancestromania.exe') then
    begin
      CreateDir(PathAppli+'intl\');
      CreateDir(PathAppli+'udf\');
      CopyFileToApp ( 'fbclient.dll' );
      CopyFileToApp ( 'ib_util.dll' );
      CopyFileToApp ( 'icudt30.dll' );
      CopyFileToApp ( 'icuin30.dll' );
      CopyFileToApp ( 'icuuc30.dll' );
      CopyFileToApp ( 'firebird.conf' );
      CopyFileToApp ( 'intl\fbintl.dll' );
      CopyFileToApp ( 'intl\fbintl.conf' );
      CopyFileToApp ( 'udf\fbudf.dll' );
      CopyFileToApp ( 'udf\ib_udf.dll' );
      CopyFileToApp ( 'udf\fbudf.sql' );
      CopyFileToApp ( 'udf\ib_udf2.sql' );
      CopyFileToApp ( 'firebird.msg' );
      CopyFileToApp ( 'README_embedded.txt' );
      CopyFileToApp ( 'aliases.conf' );
      CopyFileToApp ( 'msvcp80.dll' );
      CopyFileToApp ( 'msvcr80.dll' );
      CopyFileToApp ( 'Microsoft.VC80.CRT.manifest' );
    end;
End;

function doPathAncestro(Param: String): string;

var sCopy,sBat:String;
    VerSetup,NewFileName:String;
    FSortie,stmp,Dscripts:String;
    VerLogActuel,VersionMS,VersionLS: Cardinal;
    NomClefs:TArrayOfString;
    I:integer;
    DelIni:Boolean;
    Path_Reports:string;
begin
  result:=PathAppli;
  Path_Reports:=ExpandConstant('{commonappdata}')+'\Ancestromania\Reports\'
  FSortie:=PathAppli+'migration.log';
  if FileExists(FSortie) then
    DeleteFile(FSortie);
  SaveStringToFile(FSortie,'Date/heure de migration: '+GetDateTimeString('dd/mm/yyyy hh:nn:ss', '-', ':'),false);
  SaveStringToFile(FSortie,#13#10+'Version de Windows: '+GetWindowsVersionString,true);
  SaveStringToFile(FSortie,#13#10+'Compte utilisateur: '+GetUserNameString,true);
  if IsAdminLoggedOn then
    SaveStringToFile(FSortie,#13#10+'est membre du groupe des administrateurs.',true)
  else
    if IsPowerUserLoggedOn then
      SaveStringToFile(FSortie,#13#10+'est membre du groupe des utilisateurs avec pouvoirs.',true)
    else
      SaveStringToFile(FSortie,#13#10+'n''a pas de pouvoirs.',true);

  FileSize(PathAppli+'fbclient.dll',I);
  if (I>1000000) 
   then SaveStringToFile(FSortie,#13#10+'Firebird version embedded est installé',true)
   else SaveStringToFile(FSortie,#13#10+'Firebird version embedded n''est pas installé.',true);

  //récupération des nouvelles versions dans les paramètres du fichier de mise à jour
  GetVersionNumbersString(ExpandConstant('{srcexe}'),VerSetup);
  SaveStringToFile(FSortie,#13#10+'Version de Update_Ancestro.exe: '+VerSetup,true);
  GetVersionNumbers(ExpandConstant('{srcexe}'),VerLogActuel,VersionLS);
//  VerBaseActuelle:=IntToStr(VersionLS shr 16)+'.'+IntToStr(VersionLS and $FFFF);
  DelIni:=true;
  if FileExists(PathAppli+'Ancestromania.exe') then
  begin
    DelIni:=false;
    //si Ancestromania.exe est d'une version inférieure (donc remplacé) il est sauvegardé
    if GetVersionNumbers(PathAppli+'Ancestromania.exe',VersionMS,VersionLS) then
    begin
      GetVersionNumbersString(PathAppli+'Ancestromania.exe',VerSetup);
      SaveStringToFile(FSortie,#13#10+'Version de Ancestromania.exe en place: '+VerSetup,true);
      if VersionMS<VerLogActuel then
      begin
        if not DirExists(PathAppli+'Sauve_Avant_MAJ_Internet\') then
          CreateDir(PathAppli+'Sauve_Avant_MAJ_Internet\');
        NewFileName:=PathAppli+'Sauve_Avant_MAJ_Internet\V'+VerSetup+'Ancestromania.exe';
        if FileCopy(PathAppli+'Ancestromania.exe',NewFileName,false) then
          SaveStringToFile(FSortie,#13#10+'Fichier Ancestromania.exe sauvegardé: '+NewFileName,true)
        else
        begin
          SaveStringToFile(FSortie,#13#10+'La sauvegarde de votre ancien Ancestromania.exe a échoué!',true);
  			  MsgBox('La sauvegarde de votre ancien Ancestromania.exe a échoué!',mbError,MB_OK);
  			end;
      end;
    end
    else
    begin
      SaveStringToFile(FSortie,#13#10+'Version de Ancestromania.exe en place : inconnue',true);
      VersionMS:=0;
    end;
  end
  else
  begin
    SaveStringToFile(FSortie,#13#10+'Ancestromania.exe absent de : '+PathAppli,true);
    VersionMS:=0;
  end;
  if DelIni then  //réinitialisation des fenêtres et du menu et du répertoire des scripts
  begin
    DeleteFile ( IniFile );
    Dscripts:=ExpandConstant('{commonappdata}')+'\Ancestromania\Scripts\';
    if DirExists(Dscripts) then
    begin
      DelTree(Dscripts+'*.sql',false,true,false);
    end;
  end;
   
  sBat:=ExpandConstant('{tmp}') + '\migration.bat';
  stmp:=ExpandConstant('{tmp}')+'\';
  sCopy:='COPY "'+stmp;
   {
  SaveStringToFile(sBat,'IF NOT EXIST "'+PathAppli+'fbembed.dll" GOTO suite9',False);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'fbembed.dll"',True); //fbembed.dll nécessaire uniquement si FB embedded
  SaveStringToFile(sBat,#13#10+':suite9',True);
  SaveStringToFile(sBat,'IF NOT EXIST "'+PathAppli+'fbclient.dll" GOTO suite8',False);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'fbclient.dll"',True); //fbembed.dll nécessaire uniquement si FB embedded
  SaveStringToFile(sBat,#13#10+':suite8',True);
  SaveStringToFile(sBat,#13#10+'IF NOT EXIST "'+PathAppli+'gds32.dll" GOTO suite1',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'gds32.dll"',True);//mise à jour de firebird
  SaveStringToFile(sBat,#13#10+sCopy+'gds32.dll" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'fbclient.dll" "'+PathAppli+'fbclient.dll"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'ib_util.dll"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'ib_util.dll" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'icudt30.dll"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'icudt30.dll" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'icuin30.dll"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'icuin30.dll" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'icuuc30.dll"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'icuuc30.dll" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'firebird.conf"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'firebird.conf" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'firebird.msg"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'firebird.msg" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'README_embedded.txt"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'doc\README_embedded.txt"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'README_embedded.txt" "'+PathAppli+'\doc"',True);
  SaveStringToFile(sBat,#13#10+'IF EXIST "'+PathAppli+'aliases.conf" GOTO suite7',True);
  SaveStringToFile(sBat,#13#10+sCopy+'aliases.conf" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+':suite7',True);
  SaveStringToFile(sBat,#13#10+'md "'+PathAppli+'intl"',True);
  SaveStringToFile(sBat,#13#10+'md "'+PathAppli+'udf"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'intl\fbintl.dll"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'fbintl.dll" "'+PathAppli+'intl\"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'intl\fbintl.conf"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'fbintl.conf" "'+PathAppli+'intl\"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'udf\fbudf.dll"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'fbudf.dll" "'+PathAppli+'udf\"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'udf\fbudf.sql"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'fbudf.sql" "'+PathAppli+'udf\"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'udf\ib_udf.dll"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'ib_udf.dll" "'+PathAppli+'udf\"',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'udf\ib_udf2.sql"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'ib_udf2.sql" "'+PathAppli+'udf\"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'msvcp80.dll" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'msvcr80.dll" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+sCopy+'Microsoft.VC80.CRT.manifest" "'+PathAppli+'"',True);
  SaveStringToFile(sBat,#13#10+'IF NOT EXIST "'+PathAppli+'firebird" GOTO suite6',True);
  SaveStringToFile(sBat,#13#10+'rd /S /Q "'+PathAppli+'firebird"',True);//résidus de firebird avant V793
  SaveStringToFile(sBat,#13#10+':suite6',True);
  SaveStringToFile(sBat,#13#10+'IF NOT EXIST "'+PathAppli+'msvcp71.dll" GOTO suite4',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'msvcp71.dll"',True);//résidus de firebird 2.0
  SaveStringToFile(sBat,#13#10+':suite4',True);
  SaveStringToFile(sBat,#13#10+'IF NOT EXIST "'+PathAppli+'msvcr71.dll" GOTO suite1',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'msvcr71.dll"',True);
  SaveStringToFile(sBat,#13#10+':suite1',True);

  SaveStringToFile(sBat,#13#10+'IF NOT EXIST "'+PathAppli+'Tables de references\TablesReference.exe" GOTO suite3',True);
  SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\TablesReference.exe"',True);
  SaveStringToFile(sBat,#13#10+':suite3',True);
            }
  //mise à jour des documents et tables de référence
  if VersionMS < (2009 shl 16 + 16) then //<'2009.16'
  begin
    SaveStringToFile(sBat,#13#10+sCopy+'denombrement_ascendance.rtm" "'+PathAppli+'Reports\_REP_STAT_DENOMBREMENT_ASCENDANCE"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'denombrement_descendance.rtm" "'+PathAppli+'Reports\_REP_STAT_DENOMBREMENT_DESCENDANCE"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Descendance_Patronymique.rtm" "'+PathAppli+'Reports\_REP_DESCENDANCE_PATRONYMIQUE"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Stat_Graph_naiss_dept.rtm" "'+PathAppli+'Reports\_REP_STAT_GRAPH_NAISS_DEPT"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'anniversaires.rtm" "'+PathAppli+'Reports\_REP_LISTE_DIVERS_ANNIVERSAIRE"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Stat_Nom_Dx_Col.rtm" "'+PathAppli+'Reports\_REP_STAT_PATRONYME"',True);
    SaveStringToFile(sBat,#13#10+'md "'+PathAppli+'Reports\_REP_STAT_PROFESSIONS"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Stat_Professions.rtm" "'+PathAppli+'Reports\_REP_STAT_PROFESSIONS"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Stat_Prenom_Dx_Col.rtm" "'+PathAppli+'Reports\_REP_STAT_PRENOM"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Divers_Alphabetique.rtm" "'+PathAppli+'Reports\_REP_LISTE_ALPHA"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Divers_Unions_Sosa.rtm" "'+PathAppli+'Reports\_REP_LISTE_DIVERS_UNION"',True);
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE\Divers_Fiche_Detaille_2.rtm"',True);
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE\Divers_Fiche_Condensee_2.rtm"',True);
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_FICHE_FAMILIALE\Fiche_familiale2.rtm"',True);
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_FICHE_FAMILIALE\Fiche_familiale_Condensee_2.rtm"',True) ;

    SaveStringToFile(sBat,#13#10+sCopy+'REF_PAYS.txt" "'+PathAppli+'Tables de references"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_TOKEN_DATE2.txt"',True);
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_EVENEMENTS2.txt"',True);
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_REGION2.txt"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_DEPARTEMENTS2.txt"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_CP_VILLE2.txt"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_ASCENDANCE\Ascendance_Mariage.anc"',True) ;
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Reports\_REP_ASCENDANCE\Ascendance_Mariage.rtm" Ascendance_Mariage.anc',True) ;
    SaveStringToFile(sBat,#13#10+sCopy+'Ascendance_Mariage.rtm" "'+PathAppli+'Reports\_REP_ASCENDANCE"',True) ;

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_DESCENDANCE_COMPLET\Descendance_Complet_Mariage.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Reports\_REP_DESCENDANCE_COMPLET\Descendance_Complet_Mariage.rtm" Descendance_Complet_Mariage.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Descendance_Complet_Mariage.rtm" "'+PathAppli+'Reports\_REP_DESCENDANCE_COMPLET"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE\Divers_Fiche_Detaille.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE\Divers_Fiche_Detaille.rtm" Divers_Fiche_Detaille.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Divers_Fiche_Detaille.rtm" "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE\Divers_Fiche_Condensee.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE\Divers_Fiche_Condensee.rtm" Divers_Fiche_Condensee.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Divers_Fiche_Condensee.rtm" "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE\Divers_Fiche_Condensee_sans_medias.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE\Divers_Fiche_Condensee_sans_medias.rtm" Divers_Fiche_Condensee_sans_medias.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Divers_Fiche_Condensee_sans_medias.rtm" "'+PathAppli+'Reports\_REP_FICHE_INDIVIDUELLE"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_FILIATION.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_FILIATION.txt" REF_FILIATION.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_FILIATION.txt" "'+PathAppli+'Tables de references"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_PARTICULES.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_PARTICULES.txt" REF_PARTICULES.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_PARTICULES.txt" "'+PathAppli+'Tables de references"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_RACCOURCIS.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_RACCOURCIS.txt" REF_RACCOURCIS.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_RACCOURCIS.txt" "'+PathAppli+'Tables de references"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_PREFIXES.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_PREFIXES.txt" REF_PREFIXES.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_PREFIXES.txt" "'+PathAppli+'Tables de references"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_DIVERS_IND.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_DIVERS_IND.txt" REF_DIVERS_IND.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_DIVERS_IND.txt" "'+PathAppli+'Tables de references"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_DIVERS_FAM.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_DIVERS_FAM.txt" REF_DIVERS_FAM.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_DIVERS_FAM.txt" "'+PathAppli+'Tables de references"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_RELA_TEMOINS2.txt"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_FICHE_FAMILIALE\Fiche_familiale.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Reports\_REP_FICHE_FAMILIALE\Fiche_familiale.rtm" Fiche_familiale.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Fiche_familiale.rtm" "'+PathAppli+'Reports\_REP_FICHE_FAMILIALE"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Reports\_REP_FICHE_FAMILIALE\Fiche_familiale_Condensee.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Reports\_REP_FICHE_FAMILIALE\Fiche_familiale_Condensee.rtm" Fiche_familiale_Condensee.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Fiche_familiale_Condensee.rtm" "'+PathAppli+'Reports\_REP_FICHE_FAMILIALE"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_RELA_TEMOINS.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_RELA_TEMOINS.txt" REF_RELA_TEMOINS.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_RELA_TEMOINS.txt" "'+PathAppli+'Tables de references"',True);
  end;

  //ATTENTION déplacement du répertoire Reports à partir de la version 2009.20
  
  if VersionMS<(2009 shl 16 + 20) then  //<'2009.20'
  begin
    SaveStringToFile(sBat,#13#10+'XCOPY "'+PathAppli+'Reports\*.*" "'+Path_Reports+'" /S',True);
    SaveStringToFile(sBat,#13#10+'rd /S /Q "'+PathAppli+'Reports"', True); //suppression de l'ancien Reports
    SaveStringToFile(sBat,#13#10+sCopy+'age_premiere_union.rtm" "'+Path_Reports+'_REP_STAT_AGE_PREMIERE_UNION"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Longevite.rtm" "'+Path_Reports+'_REP_STAT_LONGEVITE"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'nombre_enfant_par_union.rtm" "'+Path_Reports+'_REP_STAT_NB_ENFANT_UNION"',True) ;
    SaveStringToFile(sBat,#13#10+sCopy+'nombre_enfant_par_union_Dx_Col.rtm" "'+Path_Reports+'_REP_STAT_NB_ENFANT_UNION"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'recensement_Dx_Col.rtm" "'+Path_Reports+'_REP_STAT_RECENSEMENT"',True);
    SaveStringToFile(sBat,#13#10+sCopy+'recensement.rtm" "'+Path_Reports+'_REP_STAT_RECENSEMENT"',True);
  end;

  if VersionMS<(2009 shl 16 + 23) then  //2009.23
  begin
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_TOKEN_DATE.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_TOKEN_DATE.txt" REF_TOKEN_DATE.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_TOKEN_DATE.txt" "'+PathAppli+'Tables de references"',True);
  end;

  if VersionMS<(2010 shl 16 + 9) then //<'2010.9'
  begin
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_EVENEMENTS.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_EVENEMENTS.txt" REF_EVENEMENTS.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_EVENEMENTS.txt" "'+PathAppli+'Tables de references"',True);
  end;

  if VersionMS<(2010 shl 16 + 10) then //<'2010.10'
  begin //première ligne: récupération pour erreur sur Path_Reports dans script de maj en 2010.3
    SaveStringToFile(sBat,#13#10+sCopy+'Fiche_familiale_Condensee_sans_medias.rtm" "'+Path_Reports+'_REP_FICHE_FAMILIALE"',True);

    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_ASCENDANCE\Ascendance_Complet.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_ASCENDANCE\Ascendance_Complet.rtm" Ascendance_Complet.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Ascendance_Actes_Absents.rtm" "'+Path_Reports+'_REP_ASCENDANCE"',True);
  end;

  if VersionMS<(2010 shl 16 + 12) then //<'2010.12'
  begin //retouches pour chevauchement n° et nom du conjoint 06/09/2010
    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_DESCENDANCE_COMPLET\Descendance_Complet_Mariage.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_DESCENDANCE_COMPLET\Descendance_Complet_Mariage.rtm" Descendance_Complet_Mariage.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Descendance_Complet_Mariage.rtm" "'+Path_Reports+'_REP_DESCENDANCE_COMPLET"',True);

    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_DESCENDANCE_COMPLET\Descendance_Actes_Absents.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_DESCENDANCE_COMPLET\Descendance_Actes_Absents.rtm" Descendance_Actes_Absents.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Descendance_Actes_Absents.rtm" "'+Path_Reports+'_REP_DESCENDANCE_COMPLET"',True);
    //retouches pour titre autosize
    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR\Liste_Eclair_par_Patronymes.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR\Liste_Eclair_par_Patronymes.rtm" Liste_Eclair_par_Patronymes.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Liste_Eclair_par_Patronymes.rtm" "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR"',True);

    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR\Liste_Eclair_par_Dept_Patronymes.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR\Liste_Eclair_par_Dept_Patronymes.rtm" Liste_Eclair_par_Dept_Patronymes.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Liste_Eclair_par_Dept_Patronymes.rtm" "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR"',True);

    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR\Liste_Eclair_par_Dept_Villes.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR\Liste_Eclair_par_Dept_Villes.rtm" Liste_Eclair_par_Dept_Villes.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Liste_Eclair_par_Dept_Villes.rtm" "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR"',True);

    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR\Liste_Eclair_par_Villes.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR\Liste_Eclair_par_Villes.rtm" Liste_Eclair_par_Villes.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Liste_Eclair_par_Villes.rtm" "'+Path_Reports+'_REP_LISTE_DIVERS_ECLAIR"',True);
  end;

  if VersionMS<(2010 shl 16 + 14) then //<'2010.14'
  begin
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Plugins\DllCassiniVision.dll"',True);
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Plugins\DllCassiniVision.dlm"',True);
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Plugins\DllCassiniVision.dla"',True);
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Plugins\ancestromania.exe"',True);
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Plugins\Cassinivision\Lisez_Moi.rtf"',True);
  end;
  
  if VersionMS<(2010 shl 16 + 16) then //<'2010.16'
  begin
    SaveStringToFile(sBat,#13#10+sCopy+'REF_MARR.txt" "'+PathAppli+'Tables de references"',True);
  end;

  if VersionMS<(2011 shl 16 + 1) then //<'2011.1'
  begin
    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Plugins\Dll_BOA.dll"',True);
  end;

  if VersionMS<(2012 shl 16 + 3) then  //<'2012.3'
  begin
    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_ASCENDANCE\Ascendance_Actes_Absents.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_ASCENDANCE\Ascendance_Actes_Absents.rtm" Ascendance_Actes_Absents.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Ascendance_Actes_Absents.rtm" "'+Path_Reports+'_REP_ASCENDANCE"',True);

    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_ASCENDANCE\Ascendance_Mariage.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_ASCENDANCE\Ascendance_Mariage.rtm" Ascendance_Mariage.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Ascendance_Mariage.rtm" "'+Path_Reports+'_REP_ASCENDANCE"',True);

    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_DESCENDANCE_COMPLET\Descendance_Actes_Absents.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_DESCENDANCE_COMPLET\Descendance_Actes_Absents.rtm" Descendance_Actes_Absents.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Descendance_Actes_Absents.rtm" "'+Path_Reports+'_REP_DESCENDANCE_COMPLET"',True);

    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_DESCENDANCE_COMPLET\Descendance_Complet_Mariage.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_DESCENDANCE_COMPLET\Descendance_Complet_Mariage.rtm" Descendance_Complet_Mariage.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Descendance_Complet_Mariage.rtm" "'+Path_Reports+'_REP_DESCENDANCE_COMPLET"',True);

    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_DESCENDANCE_PATRONYMIQUE\Descendance_Patronymique.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_DESCENDANCE_PATRONYMIQUE\Descendance_Patronymique.rtm" Descendance_Patronymique.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Descendance_Patronymique.rtm" "'+Path_Reports+'_REP_DESCENDANCE_PATRONYMIQUE"',True);
  end;

  if VersionMS<(2012 shl 16 + 4) then  //<'2012.4'
  begin
    SaveStringToFile(sBat,#13#10+'del "'+Path_Reports+'_REP_STAT_LONGEVITE\Longevite.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+Path_Reports+'_REP_STAT_LONGEVITE\Longevite.rtm" Longevite.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'Longevite.rtm" "'+Path_Reports+'_REP_STAT_LONGEVITE"',True);
  end;

  if VersionMS<(2012 shl 16 + 5) then  //<'2012.5'
  begin
    SaveStringToFile(sBat,#13#10+sCopy+'Ascendance_Parents.rtm" "'+Path_Reports+'_REP_ASCENDANCE"',True); //ajout pour 2012.5

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_DEPARTEMENTS.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_DEPARTEMENTS.txt" REF_DEPARTEMENTS.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_DEPARTEMENTS.txt" "'+PathAppli+'Tables de references"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_REGION.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_REGION.txt" REF_REGION.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_REGIONS.txt" "'+PathAppli+'Tables de references"',True);

    SaveStringToFile(sBat,#13#10+'del "'+PathAppli+'Tables de references\REF_CP_VILLE.anc"',True);
    SaveStringToFile(sBat,#13#10+'ren "'+PathAppli+'Tables de references\REF_CP_VILLE.txt" REF_CP_VILLE.anc',True);
    SaveStringToFile(sBat,#13#10+sCopy+'REF_CP_VILLES.txt" "'+PathAppli+'Tables de references"',True);
  end;

  {if VersionMS<VerLogActuel then  //<'2012.6'
  begin
  
  end;}

  SaveStringToFile(FSortie,#13#10#13#10,true);
end;

