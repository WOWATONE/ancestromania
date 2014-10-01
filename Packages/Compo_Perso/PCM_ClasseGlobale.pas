unit PCM_ClasseGlobale;

interface

uses
   Dialogs,
   ExtCtrls,
   Classes,
   SysUtils,
   Forms,
   {$IFDEF FPC}
   LCLType,
   {$ELSE}
   Windows,
   {$ENDIF}
   Shellapi,
   Registry,
   Controls,
   MmSystem,
   FileCtrl,
   Stdctrls,
   Tlhelp32;

type
   TPCMGlobal = class
   private
      i_k_Key: hKey; {Clef principale de la base de registre}
      i_s_Key: string; {Clef secondaire de la base de reistre }
      i_s_SubKey: string; {Clef du programme }
      i_s_LangueCourante: string; {Langue courante}
      // Params generaux
      i_b_Sons: boolean;
      i_b_Grid: boolean;
      i_s_Media: string;
      i_s_Joker: string; {Caractere joker}
      i_s_Base: string;
      i_b_FlatButton: boolean;
      i_s_AppliDir: string;
      i_NumColor: Integer;
      ExtensionDataBase: string;
      UseExtension: boolean;
   public
      constructor Create;
      function Rinstr(source, str_rech: string): integer;
      procedure uf_Init(a_s_base, aExtensionDB: string; aUseExtension: boolean = TRUE);

      function uf_GetSystemDir: string; {La directory Windows\System}
      function uf_GetTempPath: string; {La directory Windows\Temp}
      function uf_GetWindowsDir: string; {La directory Windows}
      function uf_GetWindowsMedia: string; {La directory Windows\Media}
      function uf_GetCurrentDir: string; {La directory courante}
      function uf_GetEditionsDir: string; {La directory des editions}
      function uf_GetAppliDir: string; {La directory de l'appli}

      function uf_GetDataBaseName: string; {Retourne le nom de la base avec son path}
      function uf_GetAliasBase: string;
      function uf_GetExtensionBase: string;
      function uf_GetCompany: string;
      function uf_GetNumColor: integer;
      procedure up_SetNumColor(a_NumColor: integer);

      function uf_GetJoker: string; {Le joker pour les Like}
      procedure uf_SetJoker(a_Joker: string); {Le joker pour les Like}

      procedure uf_PlaySound(a_File: string); {Joue des sons}
      function uf_IsCarteSon: boolean; {Teste la presence de la carte sons}
      function uf_BoolToStr(Value: boolean): string;

      function uf_IsFrench: boolean; {On teste la langue}
      function uf_GetLangue: string;
      procedure uf_SetLangue(a_Langue: string);
      function uf_GetSons: boolean; {}
      procedure uf_SetSons(a_Mode: boolean); {}
      function uf_GetGrid: boolean; {}
      procedure uf_SetGrid(a_Mode: boolean); {}
      function AssembleString(s: array of string): string;

      {Gestion de la base de registre }
      procedure uf_SetTitreAppli(a_titre: string);
      function uf_GetRegistryKey: string;
      function GetRegKey(Name: string): string;
      procedure SetRegKey(Name: string; Value: string); {}
      function DelRegkey(Name: string): boolean; {}

      function GetLangFileName(sLangName: string): string;
      function uf_GetUserName: string;
      function uf_BeforeDelete(a_Message: string): Boolean;
      function uf_SoundMessage(a_Message: string): Boolean;
      function uf_GetWindowsVersion: string;
      function GetInfoAppli(Ressource: string): string;
      function uf_Year: integer;

      function fu_ProgEnCours(NomProg: string): boolean;
      function fu_UpString(Str: string): string;

   end;

implementation


constructor TPCMGlobal.Create;
begin
   {* ---------------------------------------------
     Initialisation des variables pour la gestion
     de la base de registre
    ---------------------------------------------- }
   i_k_Key := HKEY_CURRENT_USER;
   i_s_Key := '\SOFTWARE\' + uf_GetCompany + '\';
   i_s_SubKey := Application.Title;
   i_s_Media := 'Media';

   // --- valeurs par défaut
   i_b_FlatButton := TRUE;
   i_b_Grid := TRUE;
   // -----------------------------------------

   if GetRegKey('Hint') = '' then SetRegKey('Hint', '1');
   if GetRegKey('Sons') = '' then SetRegKey('Sons', '1');
   if GetRegKey('Splash') = '' then SetRegKey('Splash', '1');
   if GetRegKey('Grid') = '' then SetRegKey('Grid', '1');
   if GetRegKey('FileVersion') = '' then SetRegKey('FileVersion', '0.0.0');
   if GetRegKey('TauxCompressionJPG') = '' then SetRegKey('TauxCompressionJPG', '30');
   if GetRegKey('TempoDir') = '' then SetRegKey('TempoDir', 'C:\WINDOWS\TEMP');

   if not DirectoryExists(GetRegKey('TempoDir')) then
      SetRegKey('TempoDir', uf_GetTempPath);

   i_b_Sons := GetRegKey('Sons') = '1';
   i_b_Grid := GetRegKey('Grid') = '1';
   i_b_FlatButton := GetRegKey('FlatButton') = '1';

   // -- Choix de la langue courante ----------------------
   i_s_LangueCourante := GetRegKey('Langue');
end;

function TPCMGlobal.Rinstr(source, str_rech: string): integer;
var
   i: integer;
begin
   Result := 0;
   for i := Length(source) downto 1 do begin
         if source[i] = str_rech then begin
               Result := Succ(Length(source) - i);
               break;
            end;
      end;
end;

//---------------------------------------------------------------------------------------
function TPCMGlobal.AssembleString(s: array of string): string;
var
   i: Integer;
   sub: string;
begin
   result := '';
   for i := 0 to High(s) do
      begin
         sub := trim(s[i]);
         if sub <> '' then
            begin
               if (result <> '') and (i > 0) then result := result + ', ';
               result := result + sub;
            end;
      end;
end;
//---------------------------------------------------------------------------------------

function TPCMGlobal.fu_UpString(Str: string): string;
var i: integer;
begin
   result := '';
   for i := 1 to length(str) do
      result := result + UpCase(str[i]);
end;

function TPCMGlobal.fu_ProgEnCours(NomProg: string): boolean;
var
   LPPE: TProcessEntry32;
   H: Thandle;

begin
   result := false;
   h := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
   Lppe.DwSize := Sizeof(TProcessEntry32);
   if Process32First(h, lppe)
      then
      begin;
         if fu_UpString(ExtractFileName(LPPE.szexefile)) = fu_UpString(NomProg) then result := true;
         while Process32next(h, lppe) do
            begin
               if fu_UpString(ExtractFileName(LPPE.szexefile)) = fu_Upstring(NomProg) then result := true;
            end;
      end;
   Closehandle(h);
end;

procedure TPCMGlobal.up_SetNumColor(a_NumColor: integer);
begin
   i_NumColor := a_NumColor;
end;

function TPCMGlobal.uf_GetNumColor: integer;
begin
   result := i_NumColor;
end;

function TPCMGlobal.uf_GetCompany: string;
begin
   Result := 'PCM';
end;

procedure TPCMGlobal.uf_SetTitreAppli(a_titre: string);
begin
   i_s_SubKey := a_Titre;
end;

function TPCMGlobal.uf_GetWindowsMedia: string; {La directory Windows\Media}
begin
   Result := uf_GetWindowsDir + '\' + i_s_Media + '\'
end;

function TPCMGlobal.uf_GetEditionsDir: string; {La directory des editions}

begin
   SetCurrentDirectory(PChar(i_s_AppliDir));
   Result := i_s_AppliDir + '\Editions\';
end;

function TPCMGlobal.uf_GetAppliDir: string; {La directory de l'appli}
begin

   Result := ExtractFilePath(Application.ExeName);
   if Result[Length(Result)] <> '\' then
      Result := Result + '\';

   //result := i_s_AppliDir;
end;

function TPCMGlobal.uf_GetExtensionBase: string;
begin
   result := ExtensionDataBase;
end;

function TPCMGlobal.uf_GetTempPath: string;
var
   TmpDir: array[0..MAX_PATH] of char;
begin
   GetTempPath(MAX_PATH, TmpDir);
   result := TmpDir;
end;

{ renvoie la directory system }
function TPCMGlobal.uf_GetSystemDir: string;
{$IFDEF WIN32}
var
   Buffer: array[0..1023] of Char;
begin
   SetString(Result, Buffer, GetSystemDirectory(Buffer, SizeOf(Buffer)));
{$ELSE}
begin
   Result[0] := Char(GetSystemDirectory(@Result[1], 254));
{$ENDIF}
end;

{ Renvoie le rep de window }
function TPCMGlobal.uf_GetWindowsDir: string;
{$IFDEF WIN32}
var
   Buffer: array[0..1023] of Char;
begin
   SetString(Result, Buffer, GetWindowsDirectory(Buffer, SizeOf(Buffer)));
{$ELSE}
begin
   Result[0] := Char(GetWindowsDirectory(@Result[1], 254));
{$ENDIF}
end;

{Initialise la classe }
procedure TPCMGlobal.uf_Init(a_s_Base, aExtensionDB: string; aUseExtension: boolean);
{Initialisation de la classe }
begin
   i_s_Base := a_s_base;
   i_s_AppliDir := uf_GetCurrentDir;
   ExtensionDataBase := aExtensionDB;
   UseExtension := aUseExtension;
end;

function TPCMGlobal.uf_GetLangue: string;
{On renvoie la langue courante}
begin
   Result := i_s_LangueCourante;
end;

procedure TPCMGlobal.uf_SetLangue(a_Langue: string);
{On affecte la langue courante}
begin
   i_s_LangueCourante := UpperCase(a_Langue);
   SetRegKey('Langue', i_s_LangueCourante);
end;

function TPCMGlobal.uf_IsFrench: boolean;
{On teste la langue}
begin
   Result := (Length(i_s_LangueCourante) > 0) and (UpperCase(i_s_LangueCourante) <> 'FRANCAIS');
end;

function TPCMGlobal.uf_GetAliasBase: string;
begin
   result := GetRegKey('AliasOdbc');
end;

{ Renvoie le nom de la base de données }
function TPCMGlobal.uf_GetDataBaseName: string;
var
   CheminBdd: string;
begin
   CheminBdd := GetRegKey('DataBase');
   if CheminBdd <> '' then
      if not FileExists(CheminBdd) then CheminBdd := '';
   // ---
   if (Length(CheminBdd) <= 0) or (UpperCase(Copy(CheminBdd, Length(CheminBdd) - 2, 3)) <> UpperCase(ExtensionDataBase)) then begin
         SelectDirectory('Dans quel répertoire se trouve la base ' + i_s_Base + '.' + ExtensionDataBase, '', CheminBdd);
         if Length(CheminBdd) <= 0 then begin
               ShowMessage('Vous êtes obligé d''avoir une base de données...');
               Application.Terminate;
            end
         else begin
               CheminBdd := CheminBdd + '\' + i_s_Base + '.' + ExtensionDataBase;
               SetRegKey('DataBase', CheminBdd);
            end;
      end;
   // ---
   if (not UseExtension) and (CheminBdd <> '') then begin
         CheminBdd := ExtractFileName(CheminBdd);
         i_s_Base := Copy(CheminBdd, 1, Pos('.', CheminBdd) - 1);
      end
   else
      i_s_Base := CheminBdd;

   Application.ProcessMessages;
   // ---
   Result := i_s_Base;
end;

// -- Gestion de la base de registre --------------------------------------
procedure TPCMGlobal.SetRegKey(Name, Value: string);
{ Permet d'ecrire une clef dans la base de registre }
var
   Tampon: string;
begin
   StringReplace(Name, '/', '\', [rfReplaceAll]);
   try
      with TRegistry.Create do begin
            RootKey := i_k_Key;
            if Pos('\', Name) <> 0 then begin
                  Tampon := Copy(Name, 1, Length(Name) - Rinstr(Name, '\'));
                  Tampon := i_s_Key + i_s_SubKey + '\' + Tampon;
               end
            else
               Tampon := i_s_Key + i_s_SubKey;
            // --- une petite boucle pour récupérer le nom de la clé
            //     (au cas où il y aurait un chemin du style : PCM-TWS/OLIVE/NomDeLaClé)
            while Pos('\', Name) <> 0 do
               Delete(Name, 1, Pos('\', Name));
            if OpenKey(Tampon, True) then
               WriteString(Name, Value);
            Free;
         end;
   except
      //ShowMessage('Erreur écriture dans la bdr !');
   end;
end;

function TPCMGlobal.GetRegKey(Name: string): string;
{ Permet de lire une clef dans la base de registre }
var
   Tampon: string;
begin
   Result := '';
   StringReplace(Name, '\', '/', [rfReplaceAll]);
   try
      with TRegistry.Create do begin
            RootKey := i_k_Key;
            if Pos('\', Name) <> 0 then begin
                  Tampon := Copy(Name, 1, Length(Name) - Rinstr(Name, '\'));
                  Tampon := i_s_Key + i_s_SubKey + '\' + Tampon;
               end
            else
               Tampon := i_s_Key + i_s_SubKey;
            // --- une petite boucle pour récupérer le nom de la clé
            //     (au cas où il y aurait un chemin du style : PCM-TWS/OLIVE/NomDeLaClé)
            while Pos('\', Name) <> 0 do
               Delete(Name, 1, Pos('\', Name));
            if OpenKey(Tampon, False) then
               Result := ReadString(Name);
            Free;
         end;
   except
      //ShowMessage('Erreur de lecture dans la bdr !');
   end;
end;

function TPCMGlobal.DelRegkey(Name: string): boolean;
{Permet d'effacer une clef dans la base de registre }
var
   Tampon: string;
begin
   StringReplace(Name, '/', '\', [rfReplaceAll]);

   with TRegistry.Create do begin
         RootKey := i_k_Key;
         if Pos('\', Name) = 0 then
            Tampon := i_s_Key + i_s_SubKey + Name
         else
            Tampon := i_s_Key + i_s_SubKey;
         //showmessage(tampon);
         Result := DeleteKey(Tampon);
         Free;
      end;

end;

function TPCMGlobal.uf_GetRegistryKey: string;
begin
   Result := i_s_Key + i_s_SubKey;
end;

// -- Fin de la gestion de la base de registre ------------------------------

function TPCMGlobal.uf_GetCurrentDir: string;
{Retourne le repertoire courant}
begin
   Result := uf_GetAppliDir; // GetCurrentDir();
end;

function TPCMGlobal.uf_GetJoker: string;
{Retourne le type de joker }
begin
   Result := i_s_Joker;
end;

procedure TPCMGlobal.uf_SetJoker(a_Joker: string); {Le joker pour les Like}
begin
   i_s_Joker := a_Joker
end;

function TPCMGlobal.uf_GetSons: boolean;
begin
   Result := i_b_Sons;
end;

procedure TPCMGlobal.uf_SetSons(a_Mode: boolean);
begin
   i_b_Sons := a_Mode;
end;

function TPCMGlobal.uf_GetGrid: boolean;
begin
   Result := i_b_Grid;
end;
procedure TPCMGlobal.uf_SetGrid(a_Mode: boolean);
begin
   i_b_Grid := a_Mode;
end;

function TPCMGlobal.uf_IsCarteSon: boolean;
{On teste si une carte sons est installée}
begin
   Result := WaveOutGetNumDevs > 0;
end;

procedure TPCMGlobal.uf_PlaySound(a_File: string);
begin
   {Joue le fichier son}
   if not i_b_Sons then Exit;
   if uf_IsCarteSon then
      SndPlaySound(Pchar(a_File), SND_ASYNC);
end;


function TPCMGlobal.GetLangFileName(sLangName: string): string;
var
   sDir: string;
begin
   sDir := ExtractFilePath(Application.ExeName);
   if (sDir[Length(sDir)] <> '\') then
      sDir := sDir + '\';
   Result := sDir + LowerCase(sLangName) + '.lng';
end;

{Renvoi le nom utilisateur Window}
function TPCMGlobal.uf_GetUserName: string;
var
   UserName: PChar;
   Count: LongWord;
begin
   { On récupère la taille du buffer pour stocker le nom du user }
   Count := 0;
   GetUserName(nil, Count);

   { On alloue de la mémoire pour le nom }
   Username := StrAlloc(Count);

   { On récupère le nom }
   if GetUserName(UserName, count) then
      result := StrPas(UserName)
   else
      result := 'Unknown';

   { On libère la mémoire }
   StrDispose(UserName)
end;

{ -------------------------------------------------------------------
 Affiche un message avec un petit son en bonus
 --------------------------------------------------------------------}
function TPCMGlobal.uf_SoundMessage(a_Message: string): boolean;
begin
   Result := TRUE;
   uf_PlaySound(uf_GetWindowsMedia + 'Notify');
   if MessageDlg(a_Message, mtWarning, [mbYes, mbNo], 0) = mrNo then
      Result := FALSE;
end;
{ -------------------------------------------------------------------
 Affiche un message avant la suppression
 --------------------------------------------------------------------}
function TPCMGlobal.uf_BeforeDelete(a_Message: string): Boolean;
begin
   uf_PlaySound(uf_GetWindowsMedia + 'Notify');

   Result := MessageDlg(a_Message, mtWarning, [mbYes, mbNo], 0) = mrYes;
   if Result then
      uf_PlaySound(uf_GetWindowsMedia + 'Tada');
end;

function TPCMGlobal.uf_GetWindowsVersion: string;
var
   VersionInfo: TOsVersionInfo;
   {le Type TOsVersion équivaut à
   record
     dwOSVersionInfoSize: DWORD;
     dwMajorVersion: DWORD;
     dwMinorVersion: DWORD;
     dwBuildNumber: DWORD;
     dwPlatformId: DWORD;
     szCSDVersion: array[0..127] of AnsiChar;

   end;}
begin
   VersionInfo.dwOSVersionInfoSize := sizeof(VersionInfo); // à mettre avant un appel à GetVersionEx
   GetVersionEx(VersionInfo);
   //Label5.Caption:=IntToStr(VersionInfo.dwMajorVersion);
   //Label6.Caption:=IntToStr(VersionInfo.dwMinorVersion);
   //Label7.Caption:=IntToStr(VersionInfo.dwPlatformId);
   case
      VersionInfo.dwPlatformId of
      VER_PLATFORM_WIN32_WINDOWS: Result := 'Win 95';
      VER_PLATFORM_WIN32s: Result := 'Win 3.1';
      VER_PLATFORM_WIN32_NT: Result := 'Windows NT';
   end;

   Result := IntToStr(VersionInfo.dwMajorVersion);
end;

function TPCMGlobal.GetInfoAppli(Ressource: string): string;
var
   dump, Tai: Cardinal;
   vallen: Cardinal;
   buffer, VersionValue: PChar;
   VersionPointer: PChar;
   Chn: string;
begin
   {
   les ressources que tu peux lui demander sont :

   CompanyName
   FileDescription
   FileVersion
   InternalName
   LegalCopyright
   OriginalFilename
   ProductName
   ProductVersion
   Comments
   }
   Tai := GetFileVersionInfoSize(pchar(Application.Exename), dump);
   if Tai = 0 then
      Result := '< le projet n''a pas été renseigné avec les infos Version >'
   else begin
         buffer := StrAlloc(Tai + 1);
         GetFileVersionInfo(Pchar(Application.Exename), 0, Tai, buffer);
         Chn := '\\StringFileInfo\\040C04E4\\' + Ressource;
         if VerQueryValue(buffer, pchar(Chn), pointer(VersionPointer), vallen) then begin
               if (Vallen > 1) then begin
                     VersionValue := StrAlloc(vallen + 1);
                     StrLCopy(VersionValue, VersionPointer, vallen);
                     Result := VersionValue;
                     StrDispose(VersionValue);
                  end
               else
                  Result := '';
            end
         else
            Result := '';
         StrDispose(Buffer);
      end;
end;

function TPCMGlobal.uf_BoolToStr(Value: boolean): string;
begin
   Result := IntToStr(Integer(Value));
end;

function TPCMGlobal.uf_Year: integer;
begin
   result := StrToInt(FormatDateTime('yyyy', Now));
end;

end.
