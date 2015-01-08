unit u_connexion;

interface

uses IBDatabase,Forms, u_common_resources;

procedure setBaseParams ( const ADatabase : TIBDataBase; const UserName,PassWord,RoleName,lc_type:string);
function ConnexionBase(Connexion:TIBDatabase;const NomBase:string;Transaction:TIBTransaction
  ;const lc_type:string
  ;var UserName,PassWord,RoleName:string
  ;const NomTableTest:string
  ;var UtilEstAdmin:Boolean //le test n'est effectué que si True au départ
  ;Proprio:TForm=nil):Boolean;

procedure p_setLibrary (var libname: string);

implementation

uses SysUtils,
  {$IFNDEF FPC}
   Windows,
  {$ELSE}
    LCLIntf, LCLType, FileUtil,
  {$ENDIF}
  IB,IBSQL,Controls,Dialogs,IdentFB,
  fonctions_string,
  fonctions_dialogs,
  u_genealogy_context,
  IBIntf,
  u_common_functions,u_common_const,
  process,
  fonctions_system;


procedure setBaseParams ( const ADatabase : TIBDataBase; const UserName,PassWord,RoleName,lc_type:string);
Begin
  with ADatabase.Params do
   Begin
     Clear;
     Add('user_name='+UserName);
     Add('password='+PassWord);
     if lc_type > '' Then
       Add(CST_LC_CTYPE+lc_type);
     if RoleName>'' then
       Add('sql_role_name='+RoleName);
   end;
end;


procedure p_setLibrary (var libname: string);
var Alib : String;
    version : String;
Begin
  {$IFDEF WINDOWS}
  libname:= ExtractFileDir(Application.ExeName)+DirectorySeparator+'fbclient'+CST_EXTENSION_LIBRARY;
  if not FileExistsUTF8(libname) Then
   libname:= 'fbembed'+CST_EXTENSION_LIBRARY;
  {$ELSE}
  if not Assigned ( gci_context )
     or  (    ( gci_context.PathFileNameBdd <> '' )
          and ( gci_context.PathFileNameBdd [1] = '/' ))
  Then Begin Alib := 'libfbembed';  version := '.2.5'; End
  Else Begin Alib := 'libfbclient'; version := '.2'; End ;
  libname:= ExtractFileDir(Application.ExeName)+DirectorySeparator+Alib+CST_EXTENSION_LIBRARY;
  if not FileExistsUTF8(libname)
    Then libname:='/usr/lib/'+Alib + CST_EXTENSION_LIBRARY + version;
  if not FileExistsUTF8(libname)
    Then libname:='/usr/lib/'+Alib + CST_EXTENSION_LIBRARY;
  if not FileExistsUTF8(libname)
    Then libname:='/usr/lib/i386-linux-gnu/'+Alib + CST_EXTENSION_LIBRARY + version;
  if not FileExistsUTF8(libname)
    Then libname:='/usr/lib/x86_64-linux-gnu/'+Alib + CST_EXTENSION_LIBRARY + version;
  if FileExistsUTF8(libname)
  and FileExistsUTF8(ExtractFileDir(Application.ExeName)+DirectorySeparator+'exec.sh"') Then
     fs_ExecuteProcess('sh',' "'+ExtractFileDir(Application.ExeName)+DirectorySeparator+'exec.sh"');
  {$ENDIF}
end;

function ConnexionBase(Connexion:TIBDatabase;const NomBase:string;Transaction:TIBTransaction
  ;const lc_type:string
  ;var UserName,PassWord,RoleName:string
  ;const NomTableTest:string
  ;var UtilEstAdmin:Boolean
  ;Proprio:TForm=nil):Boolean;
const
  UserName_defaut='SYSDBA';
  Password_defaut='masterkey';

var
  Attrs,PosSep:integer;
  bContinue,bShift:boolean;
  q:TIBSQL;
  s:string;

  function AskIdentFB:boolean;
  var
    Id,Pw,Rl:string;
  begin
    Id:=UserName;
    Pw:=PassWord;
    Rl:=RoleName;
    Result:=False;
    if LoginDialogFB(NomBase,Id,Pw,Rl,Proprio) then
    begin
      Result:=True;
      UserName:=Id;
      PassWord:=Pw;
      RoleName:=Rl;
      setBaseParams ( Connexion,UserName,PassWord,RoleName,lc_type);
    end;
  end;

  function ActiveTransaction(var Merreur:string):boolean;
  begin
    Result:=True;
    try
      Transaction.DefaultDatabase:=Connexion;
      Transaction.StartTransaction;
      q:=TIBSQL.Create(Application);
      q.ParamCheck:=False;
      q.Database:=Connexion;
      q.Transaction:=Transaction;
      q.SQL.Text:='select first(1) * from '+NomTableTest;
      q.ExecQuery;
      q.CLose;
    except
      on E:EIBError do
      begin
        Merreur:=E.Message;
        q.Free;
        if Transaction.Active then
          Transaction.Rollback;
        if Connexion.Connected then
          Connexion.Close;
        Result:=False;
      end;
    end;
  end;

  function ActiveBaseReseau(var Merreur:string):boolean;
  var
    s:string;
  begin
    Result:=True;
    try
      Connexion.Open;
      if not ActiveTransaction(s) then
      begin
        Result:=False;
        Merreur:=rs_Error_You_are_identified_on_server_but_you_have_no_right_on_database+_CRLF+_CRLF
          +rs_Firebird_Message+_CRLF+s;
        ;
      end;
    except
      on E:EIBError do
      begin
        Result:=False;
        s:=rs_Error_Cannot_connect_to_database+_CRLF+_CRLF;
        if PosSep>2 then
          s:=s+fs_RemplaceMsg(rs_Error_Verify_that_your_connected_to_network_server_address_alias_password,
                 [copy(NomBase,1,PosSep-1),copy(NomBase,PosSep+1,100)])+_CRLF+_CRLF
        else if PosSep=0 then
          s:=s+fs_RemplaceMsg(rs_Error_Verify_that_database_alias_is_defined_in_alias_conf_file,[copy(NomBase,1,100)])+_CRLF+_CRLF
        else
          s:=s+rs_Error_Verify_that_its_file_exists+_CRLF+_CRLF;
        Merreur:=s+rs_Firebird_Message+_CRLF+E.Message;
      end;
    end;
  end;

  function EstAdmin:Boolean;
  begin
    Result:=False;
    with q do
    try
      if UtilEstAdmin then //test effectué uniquement si True au départ
      begin
        if UserName=UserName_defaut then
          Result:=True
        else
        try
          Close;
          SQL.Text:='select first(1) rdb$grantor from rdb$user_privileges where rdb$user=current_user';
          ExecQuery;
          if Fields[0].AsString=UserName then //propriétaire
            Result:=True;
        except
          //Result:=False;
        end;
      end;
    finally
      Free;
    end;
  end;

begin

  result:=True;
  bShift:=GetKeyState(VK_SHIFT)<0;
  Screen.Cursor:=crHourGlass;
  try
    if Transaction.Active then
      Transaction.Rollback;
    if Connexion.Connected then
      Connexion.Close;
    s:='';

    PosSep:=pos(':',NomBase);
    {$IFDEF WINDOWS}
    if ( PosSep=2 ) then //FB embedded et base locale
    {$ELSE}
    if (NomBase <> '' ) and  (NomBase[1] = '/' )  Then
    {$ENDIF}
    begin
      if not FileExistsUTF8(NomBase) then
      begin
        Screen.Cursor:=crDefault;
        AMessageDlg(fs_RemplaceMsg(rs_Error_Database_file_doesnt_exist,[NomBase]),mtError, [mbOK],Proprio);
        result:=False;
        exit;
      end;

      Attrs:=FileGetAttrUTF8(NomBase);
      bContinue:=True;

      if (Attrs and faReadOnly)<>0 then
      begin
        Screen.Cursor:=crDefault;
        if AMessageDlg(rs_Confirm_using_readonly_database,mtError, [mbYes,mbNo],Proprio)=mrYes then
        begin
          if AMessageDlg(rs_Confirm_readonly_supress
            ,mtError, [mbYes,mbNo],Proprio)=mrYes then
            bContinue:=FileSetAttr(NomBase,Attrs-faReadOnly)=0
          else
            bContinue:=False;
        end
        else
          bContinue:=False;
      end;
      if bContinue=False then
      begin
        AMessageDlg(rs_Error_Cannot_start_software_with_a_readonly_database,mtError, [mbOK],Proprio);
        result:=False;
        exit;
      end
      else
        Screen.Cursor:=crHourGlass;
    end;

    try
      Connexion.DatabaseName:=NomBase;
      setBaseParams(Connexion,UserName,PassWord,RoleName,lc_type);
      {$IFDEF WINDOWS}
      if (FileExistsUTF8(ExtractFilePath(Application.ExeName)+'fbclient.dll')or FileExistsUTF8(ExtractFilePath(Application.ExeName)+'fbembed.dll'))and(PosSep in [0,2]) then //FB embedded et base locale
      {$ELSE}
      if (NomBase > '' ) and  (NomBase[1] = '/' )  Then
      {$ENDIF}
      begin//avec FB embedded, l'utilisateur est toujours SYSDBA et le mot de passe indifférent
        try
          Connexion.Open;
          if not ActiveTransaction(s) then
          begin
            Screen.Cursor:=crDefault;
            AMessageDlg(rs_Error_Database_too_old_or_corrupted+rs_Firebird_Message+_CRLF+s,mtError, [mbOK],Proprio);
            Result:=False;
            exit;
          end;
          UserName:=UserName_defaut;
        except
          on E:EIBError do
          try
            AskIdentFB;
            if not Connexion.Connected Then
             begin
              Result:=False;
              Screen.Cursor:=crDefault;
              exit;
             end;
          except
            on E:EIBError do
             Begin
              s:=rs_Error_Cannot_connect_to_database+_CRLF+_CRLF;
              if PosSep=0 then //base locale définie par un alias
                s:=s+fs_RemplaceMsg(rs_Error_Verify_that_database_alias_is_defined_in_alias_conf_file,
                  [copy(NomBase,1,100)]);
              Screen.Cursor:=crDefault;
              AMessageDlg(s+rs_Firebird_Message+_CRLF+E.Message,mtError, [mbOK],Proprio);
              result:=False;
              exit;
            end;
          end;
        end;
      end
      else
      begin
        if bShift then
          bShift:=AskIdentFB;
        if ActiveBaseReseau(s) then
        begin
          if not bShift then
          begin
            UserName:=UserName_defaut;
            RoleName:='';
          end;
        end
        else //n'accepte pas les valeurs par défaut
        begin
          if not bShift then //si bShift LoginDialogFB a déjà été présenté et accepté
          begin
            setBaseParams(Connexion,UserName,PassWord,RoleName,lc_type);
            if not ActiveBaseReseau(s) then //n'accepte pas les valeurs précédentes
            begin
              if AskIdentFB then
                ActiveBaseReseau(s);
            end;
          end;
        end;

        if not Connexion.Connected Then
         begin
          Result:=False;
          Screen.Cursor:=crDefault;
          // will retry with full db path name
          if gci_context.PathFileNameBdd <> ANCESTROMANIA_DATABASE Then
            AMessageDlg(s,mtError, [mbOK],Proprio);
          exit;
         end;
      end;
      UtilEstAdmin:=EstAdmin;
    except
      if Transaction.Active then
        Transaction.Rollback;
      if Connexion.Connected then
        Connexion.Close;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
  Application.ProcessMessages;
end;

end.
