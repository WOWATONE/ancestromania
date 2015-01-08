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
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}
unit u_dm;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
{$IFNDEF FPC}
  ShellApi, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  DB, IBCustomDataSet, IBUpdateSQL,
  DOM,
  U_ExtFileCopy,
  u_traducefile,
  IBQuery, IBDatabase, Classes,
  Controls, Contnrs, process, Menus,
  Forms, SysUtils, StrUtils, IB, Dialogs,
  IBServices,
  lazutf8classes,
  fonctions_init, u_netupdate,
  IBSQL, lNetComponents,
  ExtCtrls, UniqueInstance, ExtDlgs;

const
  WebPage = 'Evolutions.'+{$IFDEF WINDOWS}'html'{$ELSE}'txt'{$ENDIF};
  ScriptsDir = 'Scripts';
  Gbak='gbak'{$IFDEF WINDOWS}+'.exe'{$ENDIF};

type
  TFicheOpenInfo=class
  private
    fCleFiche:integer;
    fSexe:integer;
    fTitreNomPrenom:string;
  public
    constructor Create;
    property CleFiche:integer read fCleFiche write fCleFiche;
    property TitreNomPrenom:string read fTitreNomPrenom write fTitreNomPrenom;
    property Sexe:integer read fSexe write fSexe;
  end;

  { Tdm }

  Tdm=class(TDataModule)
    Execute: TProcess;
    FileCopy: TExtFileCopy;
    HTTPClient: TLHTTPClientComponent;
    IBSQLTemp1: TIBSQL;
    IBSQLTemp2: TIBSQL;
    ImageListMenu:TImageList;
    ImgCouple: TImageList;
    ImageTreeview:TImageList;
    ibd_BASE:TIBDatabase;
    IBT_BASE:TIBTransaction;
    IBBaseParam: TIBDatabase;
    IBTrans_Secondaire:TIBTransaction;
    IBTrans_Courte:TIBTransaction;
    IBQSources_Record:TIBQuery;
    IBUSources_Record:TIBUpdateSQL;
    IBQUpdateDLL:TIBSQL;
    IBQueryRefEvInd:TIBQuery;
    LHTTPClientBuffered: TLHTTPClientComponent;
    NetUpdate: TNetUpdate;
    NetUpdateBuffered: TNetUpdate;
    OpenFirebird: TOpenDialog;
    OpenPictureDialog: TOpenPictureDialog;
    IdentityOfIndividual: TIBSQL;
    ReqSansCheck:TIBSQL;
    ImgCat:TImageList;
    ImgCatFondBlanc:TImageList;
    ImageSexe:TImageList;
    imageEvent:TImageList;
    QClefUnique:TIBSQL;
    ImageTvAscDesc:TImageList;
    QHintIndi: TIBSQL;
    TimerHint: TTimer;
    TraduceImage: TTraduceFile;
    IBTransParam: TIBTransaction;
    UniqueInstance: TUniqueInstance;
    procedure DataModuleCreate(Sender:TObject);
    procedure DataModuleDestroy(Sender:TObject);
    procedure cxHintStyleController1ShowHintEx(Sender: TObject;
      var Caption, HintStr: String; var CanShow: Boolean;
      var HintInfo: THintInfo);
    procedure NetUpdateBufferedFileDownloaded(const Sender: TObject;
      const MD5OK: Boolean);
    procedure NetUpdateFileDownloaded(const Sender: TObject;
      const MD5OK: Boolean);
    procedure NetUpdateIniRead(const Sender: TObject; const Total: integer);
    procedure TimerHintTimer(Sender: TObject);
    procedure UniqueInstanceOtherInstance(Sender: TObject; ParamCount: Integer;
      Parameters: array of String);
  private
    bShift:Boolean;
    Doc:TXMLDocument;
    fNumDossier:integer;
    fFicNotes:string;//AL
    fFicheActive:int64;
    fNbInd:Integer;
    fListFicheOpenInfos:TObjectList;
    fFicheOpenIndex:integer;
    fCanAddFicheOpenInList:boolean;
    fRaccourcisRac:TStringlistUTF8;
    fRaccourcisLibelle:TStringlistUTF8;
    fTokenDate:TStringlistUTF8;
    fComputer,fUserName:string;
    FicStream:TFileStreamUTF8;
    procedure SetNumDossier(const Value:integer);
    procedure doInitialiseVariables;
    procedure doInfos;
  public
    bFirstime,bClose:Boolean;
    sTaille,
    UneSubd,
    UneVille,
    UneLatitude,
    UneLongitude,
    sSosa1:string;//AL
    iSosa1:integer;//AL
    bMajSosaActive:boolean;//AL
    iMajTaille:short;//AL
    ListeParticules:TStringlistUTF8;
    ListeAssociations:TStringlistUTF8;
    ListeDiversInd:TStringlistUTF8;
    ListeDiversFam:TStringlistUTF8;
    ListeLibellesUnions:TStringlistUTF8;
    AssociationDefaut:string;
    EvIndEnMemoire:integer;
    VersionBaseMini:Extended;
    ApplicationContinue:boolean;
    sPath:string;

    function fs_GetNameSurname(const AClef: Int64): String;
    function fs_GetCurrentNameSurname: String;

    property Computer:string read fComputer write fComputer;
    property UserName:string read fUserName write fUserName;
    property NbInd:integer read fNbInd write fNbInd;
    property NumDossier:integer read fNumDossier write SetNumDossier;
    property FicNotes:string read fFicNotes write fFicNotes;//AL
    property individu_clef:int64 read fFicheActive write fFicheActive;
    property ListFicheOpenInfos:TObjectList read fListFicheOpenInfos write fListFicheOpenInfos;
    property FicheOpenIndex:integer read fFicheOpenIndex write fFicheOpenIndex;
    property CanAddFicheOpenInList:boolean read fCanAddFicheOpenInList write fCanAddFicheOpenInList;

    procedure doSaveLastFicheActiveOfDossier;
    procedure doOpenDossier(i_dossier:integer);
    procedure doOpenCurrentFolder;
    procedure DoClearDatabase;
    procedure DoClearDossier(i_dossier:integer);
    function uf_GetClefUnique(a_Table:string):integer;// Remonte une clef unique
    procedure up_RenumSosa(a_Cle:integer);
    procedure DelFavoris;
    procedure LoadFavoris(menu:TMenuItem);
    procedure AddToFavoris(cle:integer);
    function doRecupMaxSosa:integer;
    procedure AddFicheOpen(CleFiche,Sexe:integer;TitreNomPrenom:string);
    procedure SupprimeFicheOpen(CleFiche:integer);
    procedure LoadRaccourcis;
    function RemplaceRaccourcis(var Key:Word;Shift:TShiftState;var aText:string;var aSelStart:integer):boolean;//AL
    function doOpenDatabase:integer;
    procedure doCloseDatabase;
    function PrepareExportImages(var RepBaseMedia, sDossier: String): Boolean;
    function doExportImage(const s_Query:TIBQuery;
                           const RepBaseMedia,sDossier,Extension : String;
                           var NomFich : String; const iMode:integer;
                           const ab_RecreateFilename,ab_Backup,ab_exportAll : Boolean):boolean;
    function doExportImages(const nomDossier:string; iMode:integer ; const ab_RecreateFilename, ab_hasasubdir : boolean ):string;
    function doNouveaux:integer;
    procedure doBackup;
    procedure DoUpdateDLL;
    function GetUrlMajAuto:string;
    function GetUrlSite:string;
    function GetUrlInfosMaj:string;
    function GeturlListeDiffusion:string;
    procedure doMAJTableJournal(sTexte:string);
    procedure doCalculConsang(iMode:integer);//AL
    procedure doInitPrenoms;//AL
    procedure doInitLieuxFavoris;//AL 03/2011
    procedure doResetFenetres(bMode:boolean);
    function ControleRepBase:boolean;
    procedure doActiveTriggerMajDate(bMode:boolean);//active ou inactive le trigger enregistrant la date de modification AL
    procedure doActiveTriggerMajSosa(bMode:boolean);//active ou inactive le trigger mettant à jour automatiquement num_sosa AL
    procedure InactiveTriggersLieuxFavoris(bMode:boolean);//AL 03/2011
    procedure doChargeVarSession;//met en place les variables contextuelles dans la base AL
    function CommenceParToken(ChaineDate:string):boolean;//AL
    procedure doMajOrdreDateWriten;//MD
    procedure InitListeParticules;//AL: spécifique à la base, pas de paramètre langue
    procedure InitListeAssociations;//AL: spécifique au dossier, charge également les libellés d'événements divers
    function IndiPrecedent:integer;
    function ChaineHintIndi(indi:integer;separateur:string=' - '):string;
    function AdresseGbak:string;
    procedure MetVarContextBase(Context,NomVar,Valeur:string);
    procedure doVerifNouvelleVersion;
    procedure GetCoordonneesInternet(const Ville,Dept,Region,Pays:string;Proprio:TForm=nil);
    function doOpenPARANCES:Boolean;
    procedure doClosePARANCES;
  end;

var
  dm:Tdm;
  sUpdateDir : String ;

const
  sVersionBaseMini:string='5.180';
  urlMajAutoMain = 'http://ancestromania.net/ancestroupdate';
  urlMajAutoInstall = 'http://ancestromania.net/ancestroinstall/';
  urlMajAuto:array[0..1] of string = (urlMajAutoMain,'http://ancestromania.net/ancestroupdate2');

function fs_geturlMajAuto ( const ab_testDir : Boolean = False ) : String;

implementation

uses  u_form_main,
      u_firebird_functions,
      fonctions_string,
      LazUTF8,
      fonctions_dialogs,
      fonctions_file,
      fonctions_net,
      Inifiles,
      u_common_const,
      {$IFNDEF WINDOWS}
      IBIntf,
      {$ENDIF}
      unite_messages,
      u_common_ancestro,
      FileUtil, u_common_functions,
      u_common_ancestro_functions,
      fonctions_system,
      u_connexion,
      u_form_Base_Pas_a_Jour,
      u_genealogy_context, Math;
{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}
{.$R CURPOPUP.RES}
{.$R curseur_ZoomPlus.res}
{.$R curseur_ZoomMoins.res}
{.$R curseur_Main.res}
const CST_PARANCES = 'Parances.fdb';

const
  urlSite:string='http://ancestrosphere.free.fr/forum/index.php';
//  urlMajAuto:string='http://andre.langlet.free.fr/ancestroDD/';
  urlListeDiffusion:string='http://ancestrosphere.free.fr/forum/index.php';
  urlApiCoordonnees:string='http://maps.googleapis.com/maps/api/geocode/xml?';

function fs_geturlMajAuto ( const ab_testDir : Boolean = False ) : String;
var lpt_Packages : TPackageType;
Begin
  lpt_Packages := fpt_GetPackagesType;
  case lpt_Packages of
    ptDmg : Result:=urlMajAuto[1];
    else
      Result:=urlMajAutoMain;
  End;
  if ab_testDir
   Then AppendStr(Result,'test/')
   Else AppendStr(Result,'/');
end;

procedure Tdm.DataModuleCreate(Sender:TObject);
var
  bShift:boolean;
begin
  with gci_context do
   Begin
    if pos ( DirectorySeparator, PathSauvegarde ) = 0 Then
      PathSauvegarde:= {$IFDEF WINDOWS}GetAppConfigDir(True)+CST_BACKUP{$ELSE}DEFAULT_FIREBIRD_DATA_DIR+CST_BACKUP{$ENDIF};
    PathSauvegarde:=ExcludeTrailingPathDelimiter(PathSauvegarde);
   end;
  fCassiniDll:=FileExistsUTF8(_Path_Appli+'CassiniMania.exe'); { *Converted from FileExistsUTF8*  }
  fNomAppli:=extractFileNameWithoutExt(Application.ExeName);
  fKeyRegistry:=DirectorySeparator+'SOFTWARE'+DirectorySeparator+fNomAppli;
  FicStream := nil;
  { Matthieu : Pour André
//  SetLastError(NO_ERROR);
///  _Mutex:=CreateMutex(nil,false,pchar(FNomAppli));
//  Erreur:=GetLastError;
{  if (_Mutex=0)or(Erreur=ERROR_ALREADY_EXISTS)or(Erreur=ERROR_ACCESS_DENIED) then
  begin
    MyMessageDlg(rs_Error_Execute_Only_one_Ancestromania_session,mtError, [mbCancel],0);
    _Ok_Supprime_TempPath:=false;
    ApplicationContinue:=false;//un Application.Terminate avant Run provoque une erreur normale
    exit;
  end;
      }
  bMajSosaActive:=false;
  bShift:=GetKeyState(VK_SHIFT)<0;
  doc := nil;
  {
  StyleEnTeteJaune.Color:=gci_context.ColorDark;
  StyleNoirNormaSurOcre.Color:=gci_context.ColorMedium;
  StyleNavyGrasSurGris.Color:=gci_context.ColorDark;
  StyleNavyGrasSurGris.TextColor:=gci_context.ColorTexteOnglets;
  cxStyleHomme.TextColor:=gci_context.ColorHomme;
  cxStyleHomme.Font.Color:=gci_context.ColorHomme;
  cxStyleFemme.TextColor:=gci_context.ColorFemme;
  cxStyleFemme.Font.Color:=gci_context.ColorFemme;
   }
//  with IBT_Base.Params do
//  begin
//    Add('write');
//    Add('read_committed');
//    Add('no_rec_version');
//    Add('rec_version');
//    Add('nowait');
//  end;
//  with IBTrans_Secondaire.Params do
//  begin
//    Add('write');
//    Add('read_committed');
//    Add('no_rec_version');
//    Add('rec_version');
//    Add('nowait');
//  end;
//  with IBTrans_Courte.Params do
//  begin
//    Add('write');
//    Add('read_committed');
//    Add('rec_version');
//    Add('nowait');
//  end;
  if not ConvertStrToFloat(sVersionBaseMini,VersionBaseMini) then
  begin
    ApplicationContinue:=false; //erreur format sVersionBaseMini
    exit;
  end;

  doInfos;


  //Curseurs de souris
{ Matthieu : Pour André
  Screen.Cursors[_CURPOPUP]:=LoadCursor(HInstance,'CURPOPUP');
  Screen.Cursors[_CURSOR_ZOOM_MOINS]:=LoadCursor(HInstance,'ZOOM_MOINS');
  Screen.Cursors[_CURSOR_ZOOM_PLUS]:=LoadCursor(HInstance,'ZOOM_PLUS');
  Screen.Cursors[_CURSOR_MAIN]:=LoadCursor(HInstance,'MAIN');}
  //Création de quelques objets globaux
  doShowWorking(rs_Ancestromania_is_starting+_CRLF+rs_Please_Wait);
  fListFicheOpenInfos:=TObjectList.Create;
  fRaccourcisRac:=TStringlistUTF8.Create;
  fRaccourcisLibelle:=TStringlistUTF8.Create;
  fTokenDate:=TStringlistUTF8.Create;
  ListeParticules:=TStringlistUTF8.Create;
  ListeParticules.CaseSensitive:=true;
  ListeAssociations:=TStringlistUTF8.Create;
  ListeDiversInd:=TStringlistUTF8.Create;
  ListeDiversFam:=TStringlistUTF8.Create;
  ListeLibellesUnions:=TStringlistUTF8.Create;
{   Matthieu : Fonctions fs_Str2Date
  if Pos('yyyy',ShortDateFormat)=0 then //AL
    MyMessageDlg('Le format court des dates de Windows n''affiche pas les années sur 4 chiffres.'+_CRLF+
      '"'+ShortDateFormat+'"'+_CRLF+_CRLF+
      'Ceci risque d''entraîner des erreurs lors de la convertion des dates'+_CRLF+
      'en particulier pour les années de 1 à 99.'+_CRLF+_CRLF+
      'Nous vous conseillons de modifier ce paramètre dans les Options régionales.',
      mtWarning, [mbOK],0);
}
  if not bShift and(doOpenDatabase=-1) then
  begin
    ApplicationContinue:=false;
    Application.Terminate;
  end
  else
  begin
    ApplicationContinue:=true;
    if not bShift then
    begin
      doShowWorking(rs_Ancestromania_is_starting+_CRLF
        +rs_Version+' '+gci_context.VersionExe+rs_Base+gci_context.VersionBase);
      Application.ProcessMessages;
    end;
    Application.CreateForm(TFMain,FMain);
  end;
end;

procedure Tdm.doInitialiseVariables;
begin
  fNumDossier:=-1;
  fNomDossier:='';
  fFicheActive:=-1;
  fFicheOpenIndex:=-1;
  fCanAddFicheOpenInList:=true;
  fListFicheOpenInfos.Clear;
  fRaccourcisRac.Clear;
  fRaccourcisLibelle.Clear;
  sOrdreLIT:='';
  sOrdreNUM:='';
end;

function Tdm.doOpenDatabase:integer;
var
  aFBasePasAJour:TFBasePasAJour;
  Proprio:TForm;
  lstemp : String;
  function doTesteVersion:boolean;
  var
    va,vm:Extended;
  begin
    ReqSansCheck.Close;
    ReqSansCheck.SQL.Text:='select VER_VERSION from T_VERSION_BASE';
    ReqSansCheck.ExecQuery;
    gci_context.VersionBase:=Trim(ReqSansCheck.Fields[0].AsString);
    ReqSansCheck.CLose;
   if gci_context.VersionBase>'' then
    begin
      vm:=0;
      if ConvertStrToFloat(sVersionBaseMini,vm) then
      begin
        va:=0;
        if ConvertStrToFloat(gci_context.VersionBase,va) then
          result:=va>=vm
        else
          result:=false;
      end
      else
        result:=false;
    end
    else
      Result:=False;
  end;
begin
  gci_context.VersionBase:=rs_unknown_female;
  IBTrans_Secondaire.Active:=False;
  _utilEstAdmin:=True;//initialisé à True pour permettre le contrôle
  if Assigned(FMain) then
    Proprio:=FMain
  else
    Proprio:=nil;

  {$IFNDEF WINDOWS}
  IBBaseParam.Connected:=False;
  ibd_BASE   .Connected:=False;
  FreeIBLibrary;
  LoadIBLibrary;
  {$ENDIF}

  with gci_context do
   if pos ( 'UTF8', PathFileNameBdd ) = 0 Then
    Begin
      lstemp:=ExtractFilePath(PathFileNameBdd)+extractFileNameWithoutExt(PathFileNameBdd)+'UTF8.fdb';
      if FileExistsUTF8(lstemp) Then
       Begin
         PathFileNameBdd:=lstemp;
         MyMessageDlg(fs_RemplaceMsg(rs_Info_Base_is_now_this,[PathFileNameBdd])+_CRLF+rs_Info_Base_must_use_utf8_characters);
       end;
    end;

  if ConnexionBase(ibd_BASE,gci_context.PathFileNameBdd,IBT_Base,_lc_ctype
    ,_user_name,_password,_role_name
    ,'T_VERSION_BASE',_utilEstAdmin,Proprio) then
  begin
    gci_context.ShouldSave:=True;
    Result:=1;
  end
  else
  begin
    {$IFNDEF WINDOWS}
    if (gci_context.PathFileNameBdd=ANCESTROMANIA_DATABASE)
     Then
      Begin
        gci_context.PathFileNameBdd:=DEFAULT_FIREBIRD_DATA_DIR+ANCESTROMANIA_DATABASE;
        Result:=doOpenDatabase;
        if Result<> 0
          Then gci_context.WritePathNameBddIntoIni;
      end
     Else

    {$ENDIF}
      Result:=0;
    exit;
  end;

  Screen.Cursor:=crHourGlass;
  try
  //initialisation des variables
    doInitialiseVariables;

    try
      if doTesteVersion=false then
       begin
         IBT_Base.Active:=False;
         ibd_BASE.Connected:=False;
         ibd_BASE.Close;
        result:=-1;
        aFBasePasAJour:=TFBasePasAJour.create(self);
        try
          aFBasePasAJour.ShowModal;
          result:=aFBasePasAJour.iretour
        finally
          FreeAndNil(aFBasePasAJour);
        end;
        if (result=-1)or(result=2) then
          exit;
      end;
      IBTrans_Secondaire.Active:=True;
      doOpenDossier(0);

      if assigned(FMain) then
        FMain.MajEtatOptim;
      if doOpenPARANCES then
        try

         doActiveTriggerMajSosa(gci_context.CalculParenteAuto);
         doMAJTableJournal(rs_Log_Database_opening);
        except
         //On ferme Transactions et base
         IBT_Base.Active:=False;
         IBTrans_Secondaire.Active:=False;
         ibd_BASE.Close;
        end;
   finally
     Screen.Cursor:=crDefault;
   end;
    Application.ProcessMessages;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

function Tdm.fs_GetNameSurname ( const AClef : Int64 ):String;
Begin
  with IdentityOfIndividual do
   Begin
    Params[0].AsInt64:=AClef;
    ExecQuery;
    Result:=fs_getNameAndSurName(True,FieldByName(IBQ_NOM).AsString,FieldByName(IBQ_PRENOM).AsString);
    Close;
   end;
End;

function Tdm.fs_GetCurrentNameSurname: String;
begin
  Result:=fs_GetNameSurname ( individu_clef );
end;

procedure Tdm.doCloseDatabase;
begin
  if ibd_BASE.Connected then
  begin
    try
      try
        if IBT_base.Active then
        begin
          doMAJTableJournal(rs_Log_Database_closing);
          doSaveLastFicheActiveOfDossier;
          IBT_Base.Commit;
        end;
        if IBTrans_Secondaire.Active then
          IBTrans_Secondaire.Commit;
      except
        if IBT_base.Active then
          IBT_base.Rollback;
        if IBTrans_Secondaire.Active then
          IBTrans_Secondaire.Rollback;
      end;
    finally
      ibd_BASE.Close;
    end;
  end;
end;

procedure Tdm.doSaveLastFicheActiveOfDossier;
var
  q:TIBSQL;
begin
  q:=TIBSQL.Create(self);
  q.Database:=ibd_BASE;
  q.Transaction:=IBTrans_Courte;
  IBTrans_Courte.StartTransaction;
  q.SQL.Add('update dossier set ds_fermeture=''NOW'',ds_verrou=0,ds_last=:cle');
  q.SQL.Add('where cle_dossier=:dossier');
  try
    q.Params[0].AsInteger:=fFicheActive;
    q.Params[1].AsInteger:=fNumDossier;
    q.ExecQuery;
  finally
    q.free;
    IBTrans_Courte.Commit;
  end;
end;

function Tdm.doRecupMaxSosa:integer;
var
  q:TIBSQL;
begin
  q:=TIBSQL.Create(Application);
  try
    with q do
    begin
      DataBase:=ibd_BASE;
      SQL.Add('select first(1) cle_fiche from individu'
        +' where kle_dossier=:dossier and num_sosa is not null order by num_sosa desc');
      Params[0].AsInteger:=fNumDossier;
      ExecQuery;
      result:=Fields[0].AsInteger;
      Close;
    end;
  finally
    q.Free;
  end;
end;

procedure Tdm.DataModuleDestroy(Sender:TObject);
begin
// Matthieu ?
//  if _hhInstalled then
//    HtmlHelp(0,nil,HH_CLOSE_ALL,0);//AL 2009
  doClosePARANCES;
  FreeAndNil(fListFicheOpenInfos);
  FreeAndNil(fRaccourcisRac);
  FreeAndNil(fRaccourcisLibelle);
  ListeParticules.Free;
  ListeAssociations.Free;
  ListeDiversInd.Free;
  ListeDiversFam.Free;
  ListeLibellesUnions.Free;
  FreeAndNil(fTokenDate);
  if ibd_BASE.Connected then
    try
      ibd_BASE.Close;
    except
      ibd_BASE.Free;//dernier essai au cas où...
    end;
end;

function Tdm.uf_GetClefUnique(a_Table:string):integer;//retourne une clef d'enregistrement dans la table
begin
  with QClefUnique do
  begin
    Close;
    Params[0].AsString:=a_Table;
    ExecQuery;
    result:=Fields[0].AsInteger;
    Close;
  end;
end;

procedure Tdm.DoClearDatabase;//vide la base
begin
  with ReqSansCheck do
  begin
    Close;
    SQL.Clear;
    SQL.Add('execute procedure proc_vide_base');
    ExecQuery;
    Close;
    SQL.Clear;
  end;
end;

procedure Tdm.DoClearDossier(i_dossier:integer);//vide le dossier sélectionné
begin
  with ReqSansCheck do
  begin
    Close;
    SQL.Clear;
    SQL.Add('execute procedure proc_vide_dossier('+IntToStr(i_dossier)+')');
    ExecQuery;
    Close;
    SQL.Clear;
  end;
end;

procedure Tdm.doOpenDossier(i_dossier:integer);//ouvre le dernier dossier fermé si i_dossier=0
var
  s_Proc:TIBSQL;
begin
  EvIndEnMemoire:=0;
  fFicheActive:=-1;
  fListFicheOpenInfos.Clear;
  fFicheOpenIndex:=-1;
  s_Proc:=TIBSQL.Create(self);
  try
    with s_Proc do
    begin
      DataBase:=ibd_BASE;
      Transaction:=IBT_BASE;
      SQL.Add('select sr.*,i.cle_fiche,i.sexe'
        +',i.nom,i.prenom,i.annee_naissance,i.annee_deces'
        +' from'
        +' (select * from proc_trouve_dossier(:i_cle,:i_nom,:i_infos,:i_langue)) as sr'
        +' left join individu i on i.kle_dossier=sr.cle_dossier and i.num_sosa=1');
      ParamByName('I_CLE').AsShort:=i_dossier;
      //les paramètres suivants sont nécessaires si la base est vide
      ParamByName('I_NOM').AsString:='Mon premier dossier';
      ParamByName('I_INFOS').AsString:='Ce dossier, est le dossier créé par défaut, vous pouvez changer son nom et ses informations';
      DefContextLangue;
      ParamByName('i_langue').AsString:=gci_context.Langue;
      ExecQuery;
      fNumDossier:=FieldByName('cle_dossier').AsInteger;
      fNomDossier:=FieldByName('nom_dossier').AsString;
      fFicheActive:=FieldByName('dernier').AsInteger;
      fPathBaseMedias:=FieldByName('path_images').AsString;
      fFicNotes:=FieldByName('fic_notes').AsString;
      gci_context.Langue:=FieldByName('langue').AsString;
      DefContextLangue;//permet de vérifier au cas où la langue aurait été modifiée dans la table
      gci_context.ImagesDansBase:=(FieldByName('indicateurs').AsInteger and 1)=1;
      if FieldByName('cle_fiche').IsNull then
      begin
        iSosa1:=0;
        sSosa1:=rs_Caption_SOSA_No_1_not_defined_in_folder
      end
      else
      begin
        iSosa1:=FieldByName('cle_fiche').AsInteger;
        sSosa1:='Sosa n°1: ['+FieldByName('cle_fiche').AsString+'] '
          +AssembleString([FieldByName('nom').AsString,FieldByName('prenom').AsString])
          +GetStringNaissanceDeces(FieldByName('annee_naissance').AsString,FieldByName('annee_deces').AsString);
      end;
      Close;
    end;
  finally
    s_Proc.Free;
  end;
  doChargeVarSession;
  InitListeAssociations;
  IBQueryRefEvInd.Close;
  IBQueryRefEvInd.Params[0].AsString:=gci_context.Langue;
  IBQueryRefEvInd.Open;
  CreateDates; // must be on initialization
  _MotsClesDate.LoadMotClefDate(dm.IBQSources_Record,gci_context.Langue);
  doInitPrenoms;
  doInitLieuxFavoris;
  LoadRaccourcis;
end;

procedure Tdm.doOpenCurrentFolder;
begin
  doOpenDossier(fNumDossier);
end;

procedure Tdm.up_RenumSosa(a_Cle:integer);//Lance la numerotation SOSA à partir d'un individu
const
  req1='execute block as '
      +'declare variable i_dossier integer;'
      +'declare variable i_count integer;'
      +'declare variable i integer;'
      +'declare variable i_ind integer;'
      +'declare variable i_indiv integer;'
      +'begin'+_CRLF
      +' select kle_dossier from individu where cle_fiche=@ARG into :i_dossier;'+_CRLF;

  reqt1='for select e.ev_ind_kle_fiche,a.assoc_kle_associe'
      +' from t_associations a'
      +' inner join individu i on i.cle_fiche=a.assoc_kle_associe and i.kle_dossier=:i_dossier'
      +' inner join evenements_ind e on e.ev_ind_clef=a.assoc_evenement'
      +' where a.assoc_table=''I'''
      +' and not exists (select 1 from tq_id where id1=e.ev_ind_kle_fiche and id2=a.assoc_kle_associe)'
      +' into :i_ind,:i_indiv'
      +' do insert into tq_id (id1,id2) values(:i_ind,:i_indiv);'
      +'for select u.union_mari,a.assoc_kle_associe'
      +' from t_associations a'
      +' inner join individu i on i.cle_fiche=a.assoc_kle_associe and i.kle_dossier=:i_dossier'
      +' inner join evenements_fam e on e.ev_fam_clef=a.assoc_evenement'
      +' inner join t_union u on u.union_clef=e.ev_fam_kle_famille'
      +' where a.assoc_table=''U'''
      +' and not exists (select 1 from tq_id where id1=u.union_mari and id2=a.assoc_kle_associe)'
      +' into :i_ind,:i_indiv'
      +' do insert into tq_id (id1,id2) values(:i_ind,:i_indiv);'
      +'for select u.union_femme,a.assoc_kle_associe'
      +' from t_associations a'
      +' inner join evenements_fam e on e.ev_fam_clef=a.assoc_evenement'
      +' inner join t_union u on u.union_clef=e.ev_fam_kle_famille'
      +' where a.assoc_table=''U'''
      +' and not exists (select 1 from tq_id where id1=u.union_femme and id2=a.assoc_kle_associe)'
      +' into :i_ind,:i_indiv'
      +' do insert into tq_id (id1,id2) values(:i_ind,:i_indiv);'+_CRLF ;

  req2='i=0;'
      +'insert into tq_ascendance (tq_niveau,tq_cle_fiche)values(:i,@ARG);'
      +'i_count=1;'
      +' while (i_count>0) do'
      +' begin'
      +' i_count=0;'
      +'for select tq_cle_fiche'
      +' from tq_ascendance'
      +' where tq_niveau=:i'
      +' into :i_indiv'
      +' do'
      +' begin' +_CRLF
      +' for select i.cle_fiche'
      +' from individu i'
      +' where i.cle_pere=:i_indiv'
      +' and not exists (select 1 from tq_ascendance where tq_cle_fiche=i.cle_fiche)'
      +' into :i_ind'
      +' do begin'
      +' insert into tq_ascendance (tq_niveau,tq_cle_fiche)values(:i+1,:i_ind);'
      +'i_count=1;'
      +'end'+_CRLF
      +' for select i.cle_fiche'
      +' from individu i'
      +' where i.cle_mere=:i_indiv'
      +' and not exists (select 1 from tq_ascendance where tq_cle_fiche=i.cle_fiche)'
      +' into :i_ind'
      +' do begin'
      +' insert into tq_ascendance (tq_niveau,tq_cle_fiche)values(:i+1,:i_ind);'
      +'i_count=1;'
      +'end'+_CRLF
      +' for select i.cle_pere'
      +' from individu i'
      +' where i.cle_fiche=:i_indiv and i.cle_pere is not null'
      +' and not exists (select 1 from tq_ascendance where tq_cle_fiche=i.cle_pere)'
      +' into :i_ind'
      +' do  begin'
      +' insert into tq_ascendance (tq_niveau,tq_cle_fiche)values(:i+1,:i_ind);'
      +'i_count=1;'
      +'end'+_CRLF
      +' for select i.cle_mere'
      +' from individu i'
      +' where i.cle_fiche=:i_indiv and i.cle_mere is not null'
      +' and not exists (select 1 from tq_ascendance where tq_cle_fiche=i.cle_mere)'
      +' into :i_ind'
      +' do  begin'
      +' insert into tq_ascendance (tq_niveau,tq_cle_fiche)values(:i+1,:i_ind);'
      +'i_count=1;'
      +'end'+_CRLF
      +' for select u.union_mari'
      +' from t_union u'
      +' where u.union_femme=:i_indiv and u.union_mari is not null'
      +' and not exists (select 1 from tq_ascendance where tq_cle_fiche=u.union_mari)'
      +' into :i_ind'
      +' do begin'
      +' insert into tq_ascendance (tq_niveau,tq_cle_fiche)values(:i+1,:i_ind);'
      +'i_count=1;'
      +'end'+_CRLF
      +' for select u.union_femme'
      +' from t_union u'
      +' where u.union_mari=:i_indiv and u.union_femme is not null'
      +' and not exists (select 1 from tq_ascendance where tq_cle_fiche=u.union_femme)'
      +' into :i_ind'
      +' do begin'
      +' insert into tq_ascendance (tq_niveau,tq_cle_fiche)values(:i+1,:i_ind);'
      +'i_count=1;'
      +'end'+_CRLF ;

  reqt2=' for select a.id2'
      +' from tq_id a'
      +' where a.id1=:i_indiv'
      +' and not exists (select 1 from tq_ascendance where tq_cle_fiche=a.id2)'
      +' into :i_ind'
      +' do begin'
      +' insert into tq_ascendance (tq_niveau,tq_cle_fiche)values(:i+1,:i_ind);'
      +'i_count=1;'
      +'end' +_CRLF
      +' for select a.id1'
      +' from tq_id a'
      +' where a.id2=:i_indiv'
      +' and not exists (select 1 from tq_ascendance where tq_cle_fiche=a.id1)'
      +' into :i_ind'
      +' do begin'
      +' insert into tq_ascendance (tq_niveau,tq_cle_fiche)values(:i+1,:i_ind);'
      +'i_count=1;'
      +'end'+_CRLF ;

  req3=' end'+_CRLF
      +' i=i+1;'
      +'end'
      +' for select tq_cle_fiche from tq_ascendance into :i_ind'
      +' do update individu';

var
  s_Proc:TIBSQL;
begin
  doActiveTriggerMajDate(false);
  try
    s_Proc:=TIBSQL.Create(Application);
    with s_Proc do
    begin
      DataBase:=ibd_BASE;
      Transaction:=IBT_BASE;
      try
        SQL.Add('execute procedure PROC_RENUM_SOSA('+IntToStr(a_Cle)+',0,'+IntToStr(fNumDossier)+')');
        ExecQuery;
        Close;
        IBT_base.CommitRetaining;
        SQL.Text:='select nom,prenom,annee_naissance,annee_deces from individu'
          +' where cle_fiche='+IntToStr(a_Cle);
        ExecQuery;
        iSosa1:=a_Cle;
        sSosa1:=fs_RemplaceMsg(rs_Info_SOSA_no_1,[IntToStr(a_Cle)])
          +AssembleString([FieldByName('nom').AsString,FieldByName('prenom').AsString])
          +GetStringNaissanceDeces(FieldByName('annee_naissance').AsString,FieldByName('annee_deces').AsString);
        Close;
        if gci_context.AvecLienGene then
        begin
          ParamCheck:=False;
          //les individus qui ont un lien avec le sosa 1
          SQL.Text:=fs_RemplaceMsg(req1,[IntToStr(a_Cle)])+reqt1+fs_RemplaceMsg(req2,[IntToStr(a_Cle)])+reqt2+req3;
          SQL.Add('set type_lien_gene=1 where cle_fiche=:i_ind;end');//bit 0
//          writeln(SQL.Text);
         // ParamByName('indi1').AsInteger:=a_Cle;
          ExecQuery;
          Close;
          IBT_base.CommitRetaining;
          //les individus qui ont un lien avec le sosa 1 sauf les témoins
          SQL.Text:=fs_RemplaceMsg(req1,[IntToStr(a_Cle)])+fs_RemplaceMsg(req2,[IntToStr(a_Cle)])+req3;
          SQL.Add('set type_lien_gene=3 where cle_fiche=:i_ind;end');//bits 0 et 1
    //      ParamByName('indi1').AsInteger:=a_Cle;
          ExecQuery;
          Close;
          IBT_base.CommitRetaining;
          //les descendants du sosa 1
          SQL.Text:='execute block as'
            +' DECLARE VARIABLE I_INDI INTEGER;'
            +' DECLARE VARIABLE NIVEAU INTEGER;'
            +' begin'
            +' for select tq_cle_fiche,bin_shl(tq_niveau-1,8) from proc_tq_descendance('+IntToStr(a_Cle)+',0,0,0)'
            +'   into :i_indi,:niveau'
            +' do'
            +'   update individu'
            +'   set type_lien_gene=:niveau' //met le niveau de descendance dans bits 8 à 15
            +'   where cle_fiche=:i_indi;'
            +'end';
          ExecQuery;
          Close;
          IBT_base.CommitRetaining;
        end;
      finally
        Free;
      end;
    end;
  finally
    doActiveTriggerMajDate(true);
  end;
end;

procedure Tdm.SetNumDossier(const Value:integer);
begin
  fNumDossier:=Value;
  gci_context.LastNumDossier:=Value;
  gci_context.ShouldSave:=true;
end;

procedure Tdm.LoadFavoris(menu:TMenuItem);
var
  n,sex:integer;
  s:string;
  sosa:Double;
  item,DelItem:TMenuItem;
  ok:boolean;
  MenuDel:TMenuItem;
  QueryGetFavoris:TIBSQL;
begin
//  FMain.Updating;
  ok:=false;
  MenuDel:=nil;
  try
    //destruction des options anciennes
    for n:=menu.Count-1 downto 0 do
    begin
      if menu.Items[n].Name='SubItemSuppFav' then
        MenuDel:=menu.Items[n]
      else if menu.Items[n].Tag>0 then
        menu.Delete(n);
    end;
    if Assigned(MenuDel) then
      for n:=MenuDel.count-1 downto 0 do
        if MenuDel.Items[n].Tag>0 then
          MenuDel.Delete(n);
    //chargement
    QueryGetFavoris:=TIBSQL.Create(self);
    QueryGetFavoris.Database:=ibd_BASE;
    QueryGetFavoris.SQL.Add('select i.cle_fiche,i.nom,i.prenom,i.sexe,i.num_sosa from favoris f'
      +' inner join individu i on i.cle_fiche=f.kle_fiche'
      +' where f.kle_dossier=:I_DOSSIER order by i.nom,i.prenom');
    with QueryGetFavoris do
    try
      ParamByName('I_DOSSIER').AsInteger:=fNumDossier;
      ExecQuery;
      n:=1;
      while not Eof do
      begin
        s:=AssembleString([
          FieldByName('NOM').AsString,
            FieldByName('PRENOM').AsString]);
        if s>'' then
        begin
          item:=TMenuItem.Create(Self);
          DelItem:=TMenuItem.Create(Self);
          item.caption:=s;
          DelItem.caption:=s;
          sex:=FieldByName('SEXE').AsInteger;
          sosa:=FieldByName('NUM_SOSA').AsDouble;//AL2009
          case sex of
            1:if sosa=1.0 then
                item.ImageIndex:=92
              else
                item.ImageIndex:=39;
            2:if sosa=1.0 then
                item.ImageIndex:=93
              else
                item.ImageIndex:=38;
            else
              item.ImageIndex:=36;
          end;
          DelItem.ImageIndex:=item.ImageIndex;
          item.tag:=FieldByName('CLE_FICHE').AsInteger;
          DelItem.tag:=FieldByName('CLE_FICHE').AsInteger;
          item.OnClick:=FMain.OnClickOnFavoris;
          DelItem.OnClick:=FMain.OnClickDelFavori;
          menu.Add(item);
          MenuDel.Add(DelItem);
          if n=1 then
          begin
            item:=TMenuItem.Create(Self);
            DelItem:=TMenuItem.Create(Self);
            item.Caption:='-';
            Delitem.Caption:='-';
            menu.Add(item);
            MenuDel.Add(DelItem);
            Ok:=true;
          end;
        end;
        Next;
        inc(n);
      end;
    finally
      Free;
    end;
  finally
    FMain.SubItemSuppFav.Enabled:=Ok;
//    FMain.dxBarManager.LockUpdate:=false;
  end;
end;

procedure Tdm.DelFavoris;
begin
  with ReqSansCheck do
  begin
    Close;
    SQL.Text:='delete from favoris where kle_dossier='+IntToStr(fNumDossier);
    ExecQuery;
  end;
  FMain.RefreshFavoris;
end;

procedure Tdm.AddToFavoris(cle:integer);
var
  req:TIBSQL;
begin
  req:=TIBSQL.Create(self);
  req.Database:=ibd_BASE;
  try
    req.SQL.Add('execute procedure PROC_INSERT_FAVORIS(:dossier,:cle,:maxfavoris)');
    req.Params[0].AsInteger:=fNumDossier;
    req.Params[1].AsInteger:=cle;
    req.Params[2].AsInteger:=gci_context.MaxFavoris;
    req.ExecQuery;
  finally
    req.Free;
  end;
end;

{TFicheOpenInfo }
constructor TFicheOpenInfo.Create;
begin
  fCleFiche:=-1;
  fSexe:=-1;
  fTitreNomPrenom:='';
end;

procedure Tdm.AddFicheOpen(CleFiche,Sexe:integer;TitreNomPrenom:string);
var //ajoute ou met à jour les infos
  suite:boolean;
  aFicheOpenInfo:TFicheOpenInfo;
  i:integer;

procedure MajFicheOpen;
var
  i:integer;
begin
  for i:=0 to fListFicheOpenInfos.Count-1 do
  begin //met à jour la fiche si elle y est
    if TFicheOpenInfo(fListFicheOpenInfos[i]).CleFiche=CleFiche then
    begin
      TFicheOpenInfo(fListFicheOpenInfos[i]).Sexe:=Sexe;
      TFicheOpenInfo(fListFicheOpenInfos[i]).TitreNomPrenom:=TitreNomPrenom;
      Break; //elle n'y est qu'une fois
    end;
  end;
end;

begin
  if fCanAddFicheOpenInList then
  begin
    suite:=true;
    if (fFicheOpenIndex>=0)and(fFicheOpenIndex<fListFicheOpenInfos.Count) then
      suite:=TFicheOpenInfo(fListFicheOpenInfos[fFicheOpenIndex]).CleFiche<>CleFiche;
    if suite then
    begin
      aFicheOpenInfo:=TFicheOpenInfo.create;
      aFicheOpenInfo.CleFiche:=CleFiche;
      aFicheOpenInfo.Sexe:=Sexe;
      aFicheOpenInfo.TitreNomPrenom:=TitreNomPrenom;
      //Où insérer ?
      if (fListFicheOpenInfos.Count=0)or(fFicheOpenIndex<0)
        {or(fFicheOpenIndex>=fListFicheOpenInfos.Count)
        or(fFicheOpenIndex=fListFicheOpenInfos.Count-1) then çà c'est du PCM!}
      or(fFicheOpenIndex>fListFicheOpenInfos.Count-1) then // ce dernier cas ne devrait pas se produire!
      begin
        if fListFicheOpenInfos.Count>20 then
          fListFicheOpenInfos.Delete(0);
        fFicheOpenIndex:=fListFicheOpenInfos.Add(aFicheOpenInfo);
      end
      else
      begin
        for i:=0 to fListFicheOpenInfos.Count-1 do
        begin //supprime la fiche de la liste si elle y est déjà
          if TFicheOpenInfo(fListFicheOpenInfos[i]).CleFiche=CleFiche then
          begin
            fListFicheOpenInfos.Delete(i);
            if i<=fFicheOpenIndex then
              dec(fFicheOpenIndex);
            Break;
          end;
        end;
        if fListFicheOpenInfos.Count>20 then
        begin
          if fFicheOpenIndex>=10 then //soit on enlève au début
          begin
            fListFicheOpenInfos.Delete(0);
            dec(fFicheOpenIndex);
          end
          else //soit on enlève à la fin
          begin
            fListFicheOpenInfos.Delete(fListFicheOpenInfos.count-1);
          end;
        end;
        inc(fFicheOpenIndex);
        fListFicheOpenInfos.Insert(fFicheOpenIndex,aFicheOpenInfo);
      end;
    end
    else
    begin
      MajFicheOpen;
    end;
  end
  else
  begin
    MajFicheOpen;
  end;
end;

procedure Tdm.SupprimeFicheOpen(CleFiche:integer);
var
  i:integer;
begin
  for i:=0 to fListFicheOpenInfos.Count-1 do
  begin //supprime la fiche si elle y est
    if TFicheOpenInfo(fListFicheOpenInfos[i]).CleFiche=CleFiche then
    begin
      fListFicheOpenInfos.Delete(i);
      dec(fFicheOpenIndex);
      if (fFicheOpenIndex=-1) and (fListFicheOpenInfos.Count>0) then
        fFicheOpenIndex:=0;
      Break; //elle n'y est qu'une fois
    end;
  end;
end;

function Tdm.RemplaceRaccourcis(var Key:Word;Shift:TShiftState;var aText:string;var aSelStart:integer):boolean;
var
  s,r:string;
  i,k:integer;
begin
  result:=false;
  if (Key=VK_SPACE)and(Shift=[ssCtrl]) then
  begin
    s:=aText;
    for k:=aSelStart downto 1 do
      if s[k]in [' ',',',#10] then
        break;
    r:=copy(s,k+1,aSelStart-k);
    i:=fRaccourcisRac.IndexOf(r);
    if i>=0 then
    begin
      aText:=copy(s,1,k)+fRaccourcisLibelle[i]+copy(s,aSelStart+1,length(s)-aSelStart);
      aSelStart:=aSelStart+length(fRaccourcisLibelle[i])-length(r);
      result:=true;
    end;
  end;
end;

procedure Tdm.LoadRaccourcis;
begin
  fRaccourcisRac.clear;
  fRaccourcisLibelle.clear;
  with ReqSansCheck do
  begin
    Close;
    SQL.Text:='select RAC_RAC,RAC_LIBELLE from REF_RACCOURCIS';
    ExecQuery;
    while not Eof do
    begin
      fRaccourcisRac.Add(Fields[0].AsString);
      fRaccourcisLibelle.Add(StringReplace(Fields[1].AsString,'#13',_CRLF,[rfReplaceAll]));
      Next;
    end;
    Close;
  end;
end;

function Tdm.doExportImage(const s_Query:TIBQuery;const RepBaseMedia,sDossier,Extension : String;
                           var NomFich : String; const iMode:integer;
                           const ab_RecreateFilename,ab_Backup,ab_exportAll : Boolean):boolean;
var
  s_file:string;
  i:integer;
Begin
  s_file:=fs_getMediaPath (nil,s_Query,RepBaseMedia,False);
  Result:=False;
{ Trop compliqué
  if Result = ''
   Then
    Begin
      if pos(UTF8UpperCase(RepBaseMedia),UTF8UpperCase(s_file))=1
       then Result:=Copy(s_file,lRepBase+1,255)//nom du fichier sans le chemin de base
       else //le nom complet
        begin
          Result:=s_file;
          repeat
            p:=pos(':',Result);//nom complet local, enlever les ':'
            if p>0 then
              system.Delete(Result,p,1);
          until p=0;
          while Copy(Result,1,1)=DirectorySeparator do //nom complet sur poste réseau, enlever les '+DirectorySeparator+''+DirectorySeparator+' de début
          begin
            system.Delete(Result,1,1);
          end;
        end;
      NomFich:=sDossier+DirectorySeparator+Result;
    end;
    }
  NomFich:=sDossier+DirectorySeparator+Nomfich;
  i:=0;
  if ab_backup
   Then NomFich := fs_GetBackupFileName(NomFich,Extension,'-')
   Else AppendStr ( NomFich, Extension );
  if ForceDirectoriesUTF8(ExtractFilePath(NomFich)) then
  with s_Query do
  begin
    if (iMode=0) or not FileExistsUTF8(s_file) then //on copie le média stocké dans la base
    begin
      if not FieldByName('MULTI_MEDIA').IsNull
       Then
        if ab_exportAll or (FieldByName('MULTI_IMAGE_RTF').AsInteger=0) then
          try
            if TBlobField(FieldByName('MULTI_MEDIA')).BlobSize>0 then
              TBlobField(FieldByName('MULTI_MEDIA')).SaveToFile(NomFich);
            Result:=True;
          except
          end
        else //et les fichiers autres que images depuis leur original
          begin
            if CopyFile(Pchar(s_file)
              ,pchar(NomFich),false) then
              Result:=True;
          end;
    end
    else // on copie l'original dans le répertoire
    begin
      Result:=CopyFile(Pchar(s_file),pchar(NomFich),false);
      if not Result Then
       begin//si l'original est absent on utilise la copie dans la base
        if FieldByName('MULTI_IMAGE_RTF').AsInteger=0 then
        try
          if TBlobField(FieldByName('MULTI_MEDIA')).BlobSize>0 then
            TBlobField(FieldByName('MULTI_MEDIA')).SaveToFile(NomFich);
          Result:=True;
        except
        end
      end;
    end;
  end;
  if ( Result ) Then
   Begin
     I:=length(sDossier)+2;
     NomFich:=copy(NomFich,i,length(NomFich) -i+2);
     if ab_RecreateFilename
     and not FileExistsUTF8(s_file) Then
      Begin
       IBSQLTemp2.ParamByName('MULTI_CLEF').AsInteger:=s_query.FieldByName('MULTI_CLEF').AsInteger;
       IBSQLTemp2.ParamByName('MULTI_NOM').AsString:=copy(NomFich,length(sDossier)+2,length(NomFich)-2);
       IBSQLTemp2.ExecQuery;
      end;
   end;
end;

function Tdm.PrepareExportImages(var RepBaseMedia,sDossier : String ):Boolean;
var i:integer;
Begin
  if not ControleRepBase then
   Begin
    Result:=False;
    exit;
   end;
  Result:=True;
  RepBaseMedia:=IncludeTrailingPathDelimiter(fPathBaseMedias);
  if Length(sDossier)>0 then //appel depuis export gedcom
  begin
    i:=LastDelimiter('.',sDossier);
    sDossier:=Copy(sDossier,1,i-1);
  end
  else //appel depuis export multimédia
   sDossier:=RepBaseMedia+'dossier_'+IntToStr(fNumDossier);

  IBSQLTemp2.SQL.Text := 'update multimedia set multi_nom=:multi_nom'
    +' where multi_clef=:multi_clef';
  IBSQLTemp2.Prepare;

end;

function Tdm.doExportImages(const nomDossier:string; iMode:integer ; const ab_RecreateFilename, ab_hasasubdir : boolean ):string;
var
  s_Query:TIBQuery;
  i:integer;
  Save_Cursor:TCursor;
  ok:boolean;
  reponse:word;
  sDossier,Extension,RepBaseMedia:String;
begin
  result:='';//pour indiquer que l'export n'a pas abouti
  RepBaseMedia:='';
  sDossier:=NomDossier;
  if not PrepareExportImages ( RepBaseMedia,sDossier )
   Then Exit;
  IBSQLTemp1.SQL.Text:= 'select CLE_FICHE,NOM,PRENOM,'
                      + 'IND_CONFIDENTIEL,'
                      + 'b.EV_IND_DATE_WRITEN as DATE_NAISSANCE,b.EV_IND_DATE_YEAR'
                      + ' as ANNEE_NAISSANCE,b.EV_IND_VILLE'
                      + ' as LIEU_NAISSANCE,'
                      + 'd.EV_IND_DATE_WRITEN as DATE_DECES,d.EV_IND_DATE_YEAR'
                      + ' as ANNEE_DECES,d.EV_IND_VILLE'
                      + ' as LIEU_DECES,'
                      + 'SEXE FROM INDIVIDU i LEFT JOIN EVENEMENTS_IND b '
                      + 'ON (b.EV_IND_KLE_FICHE = i.CLE_FICHE AND b.EV_IND_TYPE=''BIRT'') '
                      + 'LEFT JOIN EVENEMENTS_IND d ON (d.EV_IND_KLE_FICHE = i.CLE_FICHE AND d.EV_IND_TYPE=''DEAT'') '
                      + 'LEFT JOIN MEDIA_POINTEURS p ON ( i.CLE_FICHE = p.MP_CLE_INDIVIDU ) '
                      + 'WHERE p.MP_MEDIA = :MEDIA';
  try
    if not DirectoryExistsUTF8(sDossier) then //une fonction DirectoryExistsUTF8 existe dans hh_funcs
      if not ForceDirectoriesUTF8(sDossier) { *Converted from ForceDirectories*  } then
      begin
        MyMessageDlg(fs_RemplaceMsg(rs_Error_Directory_cannot_be_created,
        [sDossier]),mtError, [mbOK],FMain);
        exit;
      end;
  except
    MyMessageDlg(fs_RemplaceMsg(rs_Error_Directory_cannot_be_created,[sDossier])
      ,mtError, [mbOK],FMain);
    exit;
  end;
  if Length(nomDossier)>0 then
    ok:=True
  else
  begin
    reponse:=MyMessageDlg(fs_RemplaceMsg(rs_Info_Export_of_pictures_and_documents_will_begin_in_directory,[sDossier])
      ,mtConfirmation, [mbYes,mbNo,mbCancel],FMain);
    if reponse=mrYes then
      iMode:=1;
    ok:=reponse<>mrCancel;
  end;
  if ok then
  begin
    try
      Application.ProcessMessages;
      Save_Cursor:=Screen.Cursor;
      Screen.Cursor:=crHourglass;
      s_Query:=TIBQuery.Create(Application);
      try
        with s_Query do
        begin
          DataBase:=ibd_BASE;
          if Length(nomDossier)>0 then //export gedcom
            SQL.ADD('SELECT m.* FROM multimedia m where m.multi_dossier=:IDOSSIER'
              +' and exists(select 1 from tq_id'
              +' where id1=5 and id2=m.multi_clef)')
          else
            SQL.ADD('SELECT * FROM multimedia where multi_dossier=:IDOSSIER');
          Params[0].AsInteger:=fNumDossier;
          Open;
          i:=0;
          while not eof do
          begin
            IBSQLTemp1.Close;
            IBSQLTemp1.Params [ 0 ].Value:=FieldByName('MULTI_CLEF').AsInteger;
            IBSQLTemp1.ExecQuery;
            if not( IBSQLTemp1.eof and IBSQLTemp1.bof )
             Then
              Begin
               Extension:=LowerCase(ExtractFileExt(FieldByName('MULTI_PATH').AsString));
               Result:=fs_TextToFileName(fs_getNameAndSurName(IBSQLTemp1));
               if ab_Hasasubdir
                Then Result:=fs_TextToFileName(IBSQLTemp1.FieldByName(IBQ_NOM).Asstring)+DirectorySeparator+Result ;
               Result:=Result+'-'+IBSQLTemp1.FieldByName('CLE_FICHE').AsString;
              end;
            doExportImage ( s_query,RepBaseMedia,sDossier,Extension,Result,iMode,ab_RecreateFilename, True, False );
            next;
            Inc(i);
          end;
        end;//de with s_Query
      finally
        s_Query.Destroy;
        Screen.Cursor:=Save_Cursor;
      end;
      if Length(nomDossier)=0 then
      begin
        if i>0 then
        begin
          MyMessageDlg(fs_RemplaceMsg(rs_Info_Export_of_pictures_is_a_success_They_are_in_this_directory,
            [IntToStr(i)])
            +_CRLF+sDossier,mtInformation, [mbOK],FMain);
          p_OpenFileOrDirectory(sDossier);
//          shellexecute(application.handle,nil,pchar('EXPLORER')
  //          ,pchar(sDossier),nil,SW_SHOWNORMAL);
        end
        else
        begin
          MyMessageDlg(rs_Info_No_picture_to_export,mtInformation, [mbOK],FMain);
        end;
      end;
    except
      on e :Exception do
       Begin
        MyMessageDlg(rs_Error_Exporting_medias+_CRLF+e.Message,mtWarning, [mbOK],FMain);
        exit;
       end;
    end;
  end;
  if Length(nomDossier)>0 then
  begin
    i:=LastDelimiter(DirectorySeparator,sDossier);
    sDossier:=Copy(sDossier,i+1,Length(sDossier));
  end;
  result:=sDossier;
end;

function Tdm.doNouveaux:integer;
var
  s_Query:TIBSQL;
begin
  s_Query:=TIBSQL.Create(Application);
  with s_Query do
  begin
    try
      DataBase:=ibd_BASE;
      SQL.ADD('select count(*) from individu'
        +' where kle_dossier=:i_dossier and date_creation>=dateadd(-7 day to current_date)');
      Params[0].AsInteger:=fNumDossier;
      ExecQuery;
      result:=Fields[0].AsInteger;
      Close;
    finally
      Free;
    end;
  end;
end;

function Tdm.AdresseGbak:string;
var InstallDir: string;
    exePathName: string;
    reg:TIniFile;
begin
  Result:='';
  //d'abord voir si gbak.exe est installé dans le répertoire de l'application
  InstallDir:=ExtractFilePath(Application.ExeName);
  if FileExistsUTF8(InstallDir+Gbak) { *Converted from FileExistsUTF8*  } then
  begin
    Result:=InstallDir+Gbak;
  end
  else//sinon chercher avec la clé de registre de Firebird serveur
  begin
    reg:=f_GetMainMemIniFile(nil,nil,Self,True);
    with reg do
    try
//      RootKey:=HKEY_LOCAL_MACHINE;
//      if OpenKeyReadOnly('SOFTWARE'+DirectorySeparator+'Firebird Project'+DirectorySeparator+'Firebird Server'+DirectorySeparator+'Instances') then
      begin
        if reg.ReadString('Instances','DefaultInstance','')>'' then
        begin
          exePathName:=reg.ReadString('Instances','DefaultInstance','')+'bin'+DirectorySeparator+Gbak;
          if FileExistsUTF8(exePathName) { *Converted from FileExistsUTF8*  } then
          begin
            Result:=exePathName;
          end
        end;
      end;
    finally
      Free;
    end;
  end;
end;

procedure Tdm.doBackup;//AL
var
  IBBackup:TIBBackupService;
  s,PathNameGBK,BackFile,lecteur,Serveur:string;
  DiskSize:Int64;
  FileSize,Pos:integer;
  sr:TSearchRec;
//  StartInfo:TStartupInfo;
//  ProcessInfo:TProcessInformation;
begin
  IBT_base.CommitRetaining;
  IBTrans_Secondaire.CommitRetaining;
  try
    PathNameGBK:=gci_context.PathSauvegarde;
    Pos:=AnsiPos(':',gci_context.PathFileNameBdd);
    lecteur:=AnsiUpperCase(ExtractFileDrive(PathNameGBK));
    if (Length(lecteur)=2) and (Pos=2) then //taille non contrôlable sur un lecteur réseau
    begin
      try
        if FindFirstUTF8(gci_context.PathFileNameBdd, faAnyFile, sr) { *Converted from FindFirstUTF8*  }=0 then
        begin
          FileSize:=sr.Size;
          DiskSize:=DiskFree(ord(lecteur[1])-64);
          if DiskSize<FileSize then
          begin
            MyMessageDlg(fs_RemplaceMsg(rs_error_need_disk_space_to_continue,[IntToStr(DiskSize)])
              ,mtInformation, [mbOK]);
            exit;
          end;
        end;
      finally
        FindCloseUTF8(sr); { *Converted from FindCloseUTF8*  }
      end;
    end;

    if not ForceDirectoriesUTF8(PathNameGBK) { *Converted from ForceDirectories*  } then
    begin
      MyMessageDlg(fs_RemplaceMsg(rs_error_need_disk_space_to_continue_directory_cannot_be_created,[PathNameGBK]),mtError, [mbOK]);
      Exit;
    end;

    BackFile:=ExtractFileNameWithoutExt(gci_context.PathFileNameBdd)+FormatDateTime('yymmddhh',Now);
    Serveur:='';
    if Pos>2 then
    begin
      Serveur:=copy(gci_context.PathFileNameBdd,1,Pos-1);
      BackFile:=PathNameGBK+PathDelim+Serveur+'_'+BackFile+'.FBK';
    end
    else if Pos=0 then
      BackFile:=PathNameGBK+PathDelim+'Local_'+BackFile+'.FBK'
    else
      BackFile:=PathNameGBK+PathDelim+BackFile+'.FBK';

    s:=AnsiLowerCase(Serveur);
    if (s>'') and (s<>'127.0.0.1') and (s<>'localhost') then
    with Execute do
    begin
      //traitement avec gback obligatoire
      CommandLine:=AdresseGbak;
      if CommandLine='' then
      begin
        MyMessageDlg(fs_RemplaceMsg(rs_Error_Cannot_backup_because_there_is_no_Gbak_exe,[Gbak]),mtError, [mbOK]);
        exit;
      end;
      CommandLine:='"'+CommandLine+'" -B "'+gci_context.PathFileNameBdd+'" "'+BackFile+'" '
                 +'-USER SYSDBA -PAS masterkey';
{      FillChar(StartInfo,SizeOf(StartInfo),#0);
      StartInfo.cb:=SizeOf(StartInfo);
      StartInfo.dwFlags:=STARTF_USESHOWWINDOW;
      StartInfo.wShowWindow:=SW_HIDE;}
      try
        Execute;
      Except
        MyMessageDlg(fs_RemplaceMsg(rs_Error_GBak_backup_aborted,[Gbak]),mtError, [mbOK]);
        exit;
      end;
//      if not CreateProcess(nil,PAnsiChar(CommandLine),nil,nil,false,0,nil,nil,StartInfo,ProcessInfo) then
    end
    else
    begin
      IBBackup:=TIBBackupService.Create(Self);
      with IBBackup do
      begin
        LoginPrompt:=False;
        Protocol:=Local;
        Params.Add('user_name='+_user_name);
        Params.Add('password='+_password);
        Active:=True;
        try
          Verbose:=false;
          Options:= [IgnoreLimbo];
          DatabaseName:=gci_context.PathFileNameBdd;
          BackupFile.Add(BackFile);
          ServiceStart;
        finally
          Active:=False;
          IBBackup.Free;
        end;
      end;
    end;
  except
    MyMessageDlg(rs_Error_Cannot_begin_backup,mtError, [mbOK]);
  end;
end;

procedure Tdm.DoUpdateDLL;
begin
  IBTrans_Courte.StartTransaction;
  try
    with IBQUpdateDLL do
    begin
      Params[0].AsInteger:=fNumDossier;
      Params[1].AsInteger:=fFicheActive;
      ExecQuery;
    end;
  finally
    IBTrans_Courte.Commit;
  end;
end;

function Tdm.GetUrlMajAuto:string;
begin
  Result:=fs_geturlMajAuto;
end;

function Tdm.GetUrlSite:string;
begin
  Result:=urlSite;
end;

function Tdm.GetUrlInfosMaj:string;
begin
  Result:=fs_geturlMajAuto+WebPage;
end;

function Tdm.GeturlListeDiffusion:string;
begin
  Result:=urlListeDiffusion;
end;

procedure Tdm.doInfos;
{var
  Temp:array[0..255] of Char;
  Size:DWord;}
begin
  { Matthieu Plus tard
  Size:=255;
  GetComputerName(Temp,Size);}
  fComputer:='';//StrPas(Temp);
//  Size:=255;
//  GetUserName(Temp,Size);
  fUserName:='';//getcurrenStrPas(Temp);
end;

procedure Tdm.doMAJTableJournal(sTexte:string);
var
  sQui,sQuoi:string;
  q:TIBSQL;
begin
  q:=TIBSQL.Create(Self);
  q.DataBase:=ibd_BASE;
  q.Transaction:=IBTrans_Courte;
  IBTrans_Courte.StartTransaction;
  try
    try
      q.SQL.Add('INSERT INTO T_JOURNAL  '+
        '( QUI, LE, TEXTE, KLE_DOSSIER) '+
        'VALUES '+
        '( :QUI, :LE, :TEXTE, :DOSSIER) ');
      sQui:=Copy('['+fComputer+':'+fUserName+']',1,40);
      sQuoi:=Copy(sTexte,1,300);
      q.Params[0].AsString:=sQui;
      q.Params[1].AsDateTime:=NOW;
      q.Params[2].AsString:=sQuoi;
      q.Params[3].AsInteger:=fNumDossier;
      q.ExecQuery;
    except
    //on E: EIBError do
    //  showmessage('Impossible de mettre à jour le journal - ' + E.Message);
    end;
  finally
    q.Free;
    IBTrans_Courte.Commit;
  end;
end;

procedure Tdm.doCalculConsang(iMode:integer);
var
  q:TIBSQL;
begin
  if gci_context.NiveauConsang<=0 then
    exit;
  Screen.Cursor:=crHourGlass;
  doActiveTriggerMajDate(false);
  try
    q:=TIBSQL.Create(Application);
    with q do
    begin
      try
        DataBase:=ibd_BASE;
        SQL.Text:='delete from tq_consang';
        ExecQuery;
        Close;
        SQL.Text:='update individu set consanguinite=null where kle_dossier='+IntToStr(fNumDossier);
        ExecQuery;
        Close;
        SQL.Text:='update individu i'
          +' set i.consanguinite=(select consanguinite from proc_consang(i.cle_fiche,0,:i_niveau))'
          +' where i.kle_dossier='+IntToStr(fNumDossier);
        if iMode=1 then
          SQL.Add('and i.num_sosa>0');
        Params[0].AsInteger:=gci_context.NiveauConsang;
        ExecQuery;
        Close;
        SQL.Text:='delete from tq_consang';
        ExecQuery;
        Close;
      finally
        Free;
      end;
    end;
    dm.IBT_base.CommitRetaining;
  finally
    doActiveTriggerMajDate(true);
    Screen.Cursor:=crDefault;
  end;
end;


procedure Tdm.doInitPrenoms;
var
  q:TIBSQL;
begin
  Screen.Cursor:=crHourGlass;
  q:=TIBSQL.Create(Application);
  try
    try
      q.DataBase:=ibd_BASE;
      q.Transaction:=ibt_Base;
      q.SQL.Text:='execute procedure PROC_NEW_PRENOMS(:i_dossier)';
      q.ParamByName('I_DOSSIER').AsInteger:=fNumDossier;
      q.ExecQuery;
      q.Close;
    except
      on E:EIBError do
      begin
        ShowMessage(fs_RemplaceMsg(rs_Error_request_error,['doInitPrenoms'])+_CRLF+_CRLF+
          E.Message);
      end;
    end;
  finally
    q.Free;
    Screen.Cursor:=crDefault;
  end;
  IBT_base.CommitRetaining;
end;

procedure Tdm.doInitLieuxFavoris;
var
  q:TIBSQL;
begin
  Screen.Cursor:=crHourGlass;
  q:=TIBSQL.Create(Application);
  try
    try
      q.DataBase:=ibd_BASE;
      q.Transaction:=IBTrans_Secondaire;//dans IBTrans_Secondaire pour pouvoir être réinitialisée sans valider l'en-cours
      q.SQL.Text:='delete from lieux_favoris';
      q.ExecQuery;
      q.Close;
      q.SQL.Text:='insert into lieux_favoris'
          +'(ville'
          +',cp'
          +',dept'
          +',region'
          +',pays'
          +',insee'
          +',subd'
          +',latitude'
          +',longitude)'
          +'select ev_ind_ville'
          +',ev_ind_cp'
          +',ev_ind_dept'
          +',ev_ind_region'
          +',ev_ind_pays'
          +',ev_ind_insee'
          +',ev_ind_subd'
          +',ev_ind_latitude'
          +',ev_ind_longitude'
          +' from proc_prep_villes_favoris(:i_dossier)';
      q.ParamByName('i_dossier').AsInteger:=fNumDossier;
      q.ExecQuery;
      q.Close;
    except
      on E:EIBError do
      begin
        MyMessageDlg(fs_RemplaceMsg(rs_Error_request_error,['doInitLieuxFavoris'])
          +_CRLF+_CRLF+E.Message,mtError,[mbOK]);
      end;
    end;
  finally
    q.Free;
    Screen.Cursor:=crDefault;
  end;
  IBTrans_Secondaire.CommitRetaining;
end;

procedure Tdm.doResetFenetres(bMode:boolean);
var
  Reg:TIniFile;
  Val:TStringlistUTF8;
  I:Integer;
begin
  Reg:=f_GetMainMemIniFile(nil,nil,Self);
  try
    Val:=TStringlistUTF8.Create;
    try
//      Reg.RootKey:=HKEY_CURRENT_USER;
  //    if Reg.OpenKey('SOFTWARE'+DirectorySeparator+FNomAppli,False) then
      begin
    //    Reg.GetKeyNames(Val);
        for I:=0 to Val.Count-1 do
          if Copy(Val.Strings[I],0,2)='W_' then
            Reg.DeleteKey(FNomAppli,Val.Strings[I]);
        Reg.DeleteKey(FNomAppli,'Last');
      end;
      Reg.DeleteKey('Settings','PanelIndiVert');
      Reg.DeleteKey('Settings','PanelInfosHeight');
      //Mise à jour du journal
      doMAJTableJournal(rs_Log_Forms_reset);
      fmain.bPurgeRegistre:=True;
    finally
      FreeAndNil(Val);
    end;
  finally
  end;
  if bMode then fmain.Close;
end;

function Tdm.ControleRepBase:boolean;//AL
begin
  if not DirectoryExistsUTF8(fPathBaseMedias) then //une fonction DirectoryExistsUTF8 existe dans hh_funcs
  begin
    Result:=false;
    MyMessageDlg(
      rs_Warning_The_Base_image_and_folder_files_directory_must_be_correct
      ,mtWarning, [mbOK],FMain);
    exit;
  end;
  if (Pos(AnsiUpperCase(fPathBaseMedias),AnsiUpperCase(gci_context.PathImages))<>1) then
    gci_context.PathImages:=fPathBaseMedias;
  Result:=true;
end;

procedure Tdm.doActiveTriggerMajDate(bMode:boolean);//AL
begin//contrôle la mise à jour de la date de modification de l'individu
  if bMode then
    MetVarContextBase('USER_TRANSACTION','INACTIVE_MAJ_DATE','null')
  else
    MetVarContextBase('USER_TRANSACTION','INACTIVE_MAJ_DATE','1');
end;

procedure Tdm.doActiveTriggerMajSosa(bMode:boolean);//AL
begin
  if bMode then
    MetVarContextBase('USER_TRANSACTION','ACTIVE_MAJ_SOSA','1')
  else
    MetVarContextBase('USER_TRANSACTION','ACTIVE_MAJ_SOSA','null');
  bMajSosaActive:=bMode;
end;

procedure Tdm.InactiveTriggersLieuxFavoris(bMode:boolean);//AL 03/2011
begin
  if bMode then
    MetVarContextBase('USER_TRANSACTION','INACTIVE_MAJ_LIEUX','1')
  else
    MetVarContextBase('USER_TRANSACTION','INACTIVE_MAJ_LIEUX','null');
end;

function Tdm.CommenceParToken(ChaineDate:string):boolean;//AL
var//on pourrait utiliser _GDate.GDate.Key1='' à la place
  i,l,n:integer;
begin
  result:=false;
  n:=length(ChaineDate);
  for i:=0 to fTokenDate.count-1 do
  begin
    l:=length(fTokenDate[i]);
    if n>l+1 then
      if copy(ChaineDate,1,l+1)=fTokenDate[i]+' ' then
      begin
        result:=true;
        break;
      end;
  end;
end;

procedure Tdm.doMajOrdreDateWriten;//MD AL
//mise à jour de Date_Writen après changement de l'ordre ou de la forme
//pour LIT il faut DMY. AL: FAUX peut être différent suivant le pays et la langue
//les anciens ordres doivent être dans sOrdreLIT et sOrdreNUM
var
  dts:TIBDataSet;
begin
  if (sOrdreLIT>'')and(sOrdreNUM>'') then
  begin
    Screen.Cursor:=crHourGlass;
    doCloseWorking;
    doShowWorking(rs_Wait_Adapting_families_dates+_CRLF+rs_Wait);
    _MotsClesDate.LoadMotClefDate(dm.IBQSources_Record,gci_context.Langue);//pour rafraichir la liste
    dts:=TIBDataSet.Create(Application);
    with dts do
    try
      try
        DataBase:=ibd_BASE;
        Transaction:=IBT_BASE;
        Active:=false;
        SelectSQL.Clear;
        SelectSQL.Add('select EV_FAM_CLEF, EV_FAM_DATE_WRITEN from EVENEMENTS_FAM where EV_FAM_DATE_WRITEN is not Null');
        ModifySQL.Clear;
        ModifySQL.Add('update EVENEMENTS_FAM set EV_FAM_DATE_WRITEN=:EV_FAM_DATE_WRITEN where EV_FAM_CLEF =:EV_FAM_CLEF');
        Prepare;
        Active:=true;
        Open;
        if not IsEmpty then
        begin
          First;
          while not Eof do
          begin
            _Gdate.DecodeHumanDate(dts.FieldByName('EV_FAM_DATE_WRITEN').AsString);
            Edit;
            dts.FieldByName('EV_FAM_DATE_WRITEN').AsString:=_Gdate.HumanDate;
            Post;
            Next;
          end;//while
        end;//if
        Close;
        UnPrepare;
        ibt_Base.CommitRetaining;
        doCloseWorking;
        doShowWorking(rs_Wait_Adapting_persons_dates+_CRLF+rs_Wait);
        Active:=false;
        SelectSQL.Clear;
        SelectSQL.Add('select EV_IND_CLEF, EV_IND_DATE_WRITEN from EVENEMENTS_IND where EV_IND_DATE_WRITEN is not Null');
        ModifySQL.Clear;
        ModifySQL.Add('update EVENEMENTS_IND set EV_IND_DATE_WRITEN=:EV_IND_DATE_WRITEN where EV_IND_CLEF =:EV_IND_CLEF');
        Prepare;
        Active:=true;
        Open;
        if not IsEmpty then
        begin
          First;
          while not Eof do
          begin
            _Gdate.DecodeHumanDate(dts.FieldByName('EV_IND_DATE_WRITEN').AsString);
            Edit;
            dts.FieldByName('EV_IND_DATE_WRITEN').AsString:=_Gdate.HumanDate;
            Post;
            Next;
          end;//while
        end;//if
        Close;
        ibt_Base.CommitRetaining;
      except
        on E:EIBError do
        begin
          ShowMessage(fs_RemplaceMsg(rs_Error_request_error,['doMajOrdreDateWriten'])+_CRLF+_CRLF+
            E.Message);
        end;
      end;
    finally
      free;
      sOrdreLIT:='';
      sOrdreNUM:='';
      doCloseWorking;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure Tdm.doChargeVarSession;//met en place les variables contextuelles dans la base AL
begin
  MetVarContextBase('USER_SESSION','TRIGGERS_DATES_INACTIFS','1');
  MetVarContextBase('USER_SESSION','LANGUE',gci_context.Langue);
end;

procedure Tdm.InitListeParticules;//AL
var
  q:TIBSQL;
begin
  q:=TIBSQL.Create(Application);
  with q do
  try
    DataBase:=dm.ibd_BASE;
    Transaction:=dm.IBT_BASE;
    Sql.Add('Select distinct PART_LIBELLE from ref_particules order by char_length(PART_LIBELLE) desc');
    ExecQuery;
    ListeParticules.Clear;
    while not Eof do
    begin
      ListeParticules.Add(FieldByName('PART_LIBELLE').AsString);
      Next;
    end;
    Close;
  finally
    q.Free;
  end;
end;

procedure Tdm.InitListeAssociations;//charge également les libellés d'événements divers AL
var
  q:TIBSQL;
begin
  q:=TIBSQL.Create(Application);
  try
    q.DataBase:=dm.ibd_BASE;
    q.Transaction:=dm.IBT_BASE;
    q.Sql.Add('Select distinct ref_rela_libelle from ref_rela_temoins');
    q.Sql.Add('where langue=:langue order by ref_rela_libelle');
    q.Params[0].AsString:=gci_context.Langue;
    q.ExecQuery;
    ListeAssociations.Clear;
    AssociationDefaut:=q.Fields[0].AsString;
    while not q.Eof do
    begin
      ListeAssociations.Add(q.Fields[0].AsString);
      q.Next;
    end;
    q.Close;
    q.SQL.Clear;
    q.Sql.Add('Select s.ref_libelle from');
    q.Sql.Add('(Select ref_libelle from ref_divers_ind');
    q.Sql.Add('where ref_langue=:langue');
    q.Sql.Add('union Select substring(ref_eve_lib_long from 1 for 25) from ref_evenements');
    q.Sql.Add('where ref_eve_langue=:langue and ref_eve_type=''I'')as s');
    q.Sql.Add('order by s.ref_libelle');      // collate FR_FR
    q.Params[0].AsString:=gci_context.Langue;
    q.ExecQuery;
    ListeDiversInd.Clear;
    while not q.Eof do
    begin
      ListeDiversInd.Add(q.Fields[0].AsString);
      q.Next;
    end;
    q.Close;
    q.SQL.Clear;
    q.Sql.Add('Select ref_libelle from ref_divers_fam');
    q.Sql.Add('where ref_langue=:langue order by ref_libelle');  // collate FR_FR
    q.Params[0].AsString:=gci_context.Langue;
    q.ExecQuery;
    ListeDiversFam.Clear;
    while not q.Eof do
    begin
      ListeDiversFam.Add(q.Fields[0].AsString);
      q.Next;
    end;
    q.Close;
    q.SQL.Text:='select ref_libelle from ref_marr where ref_langue='''+gci_context.Langue+'''';
    q.ExecQuery;
    ListeLibellesUnions.Clear;
    while not q.Eof do
    begin
      ListeLibellesUnions.Add(q.Fields[0].AsString);
      q.Next;
    end;
    q.Close;
  finally
    q.Free;
  end;
end;

function Tdm.IndiPrecedent:integer;
var
  q:TIBSQL;
  n,i:integer;
begin
  result:=-1;
  n:=fFicheOpenIndex;
  q:=TIBSQL.Create(Application);
  try
    q.DataBase:=dm.ibd_BASE;
    q.Transaction:=dm.IBT_BASE;
    q.Sql.Add('Select 1 from individu where kle_dossier='+IntToStr(fNumDossier));
    q.Sql.Add('and cle_fiche=:cle_fiche');
    while (result=-1)and(n>=0) do
    begin
      i:=TFicheOpenInfo(ListFicheOpenInfos[n]).CleFiche;
      q.Params[0].AsInteger:=i;
      q.ExecQuery;
      if not q.Eof then
        result:=i;
      q.Close;
      dec(n);
    end;
    if result=-1 then
    begin
      n:=fFicheOpenIndex+1;
      while (result=-1)and(n<ListFicheOpenInfos.Count) do
      begin
        i:=TFicheOpenInfo(ListFicheOpenInfos[n]).CleFiche;
        q.Params[0].AsInteger:=i;
        q.ExecQuery;
        if not q.Eof then
          result:=i;
        q.Close;
        inc(n);
      end;
    end;
    if result=-1 then
    begin
      q.SQL.Clear;
      q.SQL.Add('select first(1) cle_fiche from individu where kle_dossier='+IntToStr(fNumDossier));
      q.SQL.Add('order by cle_fiche desc');
      q.ExecQuery;
      if not q.Eof then
        result:=q.Fields[0].AsInteger;
      q.Close;
    end;
  finally
    q.Free;
  end;
end;

function Tdm.ChaineHintIndi(indi:integer;separateur:string=' - '):string;
var
  s:string;
begin
  if indi>0 then
  begin
    with QHintIndi do
    begin
      Params[0].AsInteger:=indi;
      ExecQuery;
      result:=AssembleString([FieldByName('datenais').AsString
                              ,FieldByName('subdnais').AsString
                              ,FieldByName('villenais').AsString
                              ,FieldByName('deptnais').AsString]);
      if gci_context.AfficheRegiondansListeEV then
        result:=AssembleString([result,FieldByName('regnais').AsString]);
      result:=AssembleString([result,FieldByName('paysnais').AsString]);
      if result>'' then
        if FieldByName('sexe').AsInteger=2 then
          result:='Née '+result
        else
          result:='Né '+result;

      s:=AssembleString([FieldByName('dateDC').AsString
                              ,FieldByName('subdDC').AsString
                              ,FieldByName('villeDC').AsString
                              ,FieldByName('deptDC').AsString]);
      if gci_context.AfficheRegiondansListeEV then
        s:=AssembleString([s,FieldByName('regDC').AsString]);
      s:=AssembleString([s,FieldByName('paysDC').AsString]);
      if s>'' then
      begin
        if result>'' then
          result:=result+separateur;
        if FieldByName('sexe').AsInteger=2 then
          result:=result+rs_Dead_female+s
        else
          result:=result+rs_Dead_male+s;
      end;
      close;
    end;
  end
  else
    result:='';
end;

procedure Tdm.cxHintStyleController1ShowHintEx(Sender: TObject;
  var Caption, HintStr: String; var CanShow: Boolean;
  var HintInfo: THintInfo);
var
  l:integer;
begin
  l:=length(HintInfo.HintStr);
  HintInfo.HideTimeout:=Max(2500,l*80);
end;

procedure Tdm.NetUpdateBufferedFileDownloaded(const Sender: TObject;
  const MD5OK: Boolean);
var
  s,sMessage,locality,srComplete:string;
  UnNoeud,UnNoeudR:TDOMNode;
  i:Integer;
Begin
  with NetUpdateBuffered do
    begin
      if bShift then
        srComplete:=_CRLF+_CRLF+'Réponse complète de l''Api Google:'+_CRLF
          +StringReplace(Utf8ToAnsi(Buffer),#10,_CRLF, [rfReplaceAll])
      else
        srComplete:='';
      try
        Doc.CreateElement(Buffer);
        UnNoeud:=Doc.DocumentElement.FindNode('status');
        UnNoeudR:=Doc.DocumentElement.FindNode('result');
        if (UnNoeud=nil)or(UnNoeudR=nil)or(UnNoeud.NodeValue<>'OK') then
          sMessage:=rs_Error_No_site_found_on_the_web+srComplete
        else
        begin
          UnNoeud:=UnNoeudR.FindNode('formatted_address');
          if UnNoeud=nil then
          begin
            sMessage:=rs_Error_No_site_found_on_the_web+srComplete;
            exit;
          end;
          locality:='';
          for i:=0 to UnNoeudR.ChildNodes.Count-1 do
          begin
            UnNoeud:=UnNoeudR.ChildNodes[i];
            if UnNoeud.NodeValue='address_component' then
            begin
              if UnNoeud.FindNode('type').NodeValue='locality' then
              begin
                locality:=UnNoeud.FindNode('long_name').NodeValue;
                Break;
              end;
            end;
          end;
          if fs_FormatText(locality,mftUpper,True)<>fs_FormatText(UneVille,mftUpper,True) then
          begin
            if locality=''
             then sMessage:=fs_RemplaceMsg(rs_Error_City_not_found,[UneVille])+srComplete
             else sMessage:=rs_Error_Site_found_but_in_this_city+_CRLF+locality+srComplete;
            exit;
          end;
          if UnNoeudR.FindNode('type').NodeValue='locality' then
            s:=''
          else
            s:='le nom et ';
          if (UneSubd>'')and(s='') then
            sMessage:=fs_RemplaceMsg(rs_Error_Subd_not_found_in_city,[UneSubd,UneVille])+_CRLF+_CRLF;
          if MyMessageDlg(sMessage+fs_RemplaceMsg(rs_Confirm_address_found_on_the_web_Do_you_want_to_record_it,[UnNoeudR.FindNode('formatted_address').NodeValue,s])+srComplete
            ,mtConfirmation, [mbYes,mbNo])=mrYes then
          begin
            if UnNoeudR.FindNode('type').NodeValue='locality' then
              UneSubd:=''
            else
            begin
              UneSubd:=UnNoeudR.FindNode('formatted_address').NodeValue;
              UneSubd:=LeftStr(UneSubd,Pos(',',UneSubd)-1);
            end;
            UneLatitude:=UnNoeudR.FindNode('geometry').FindNode('location').FindNode('lat').NodeValue;
            UneLongitude:=UnNoeudR.FindNode('geometry').FindNode('location').FindNode('lng').NodeValue;
            if DecimalSeparator<>'.' then
            begin
              UneLatitude:=StringReplace(UneLatitude,'.',DecimalSeparator, []);
              UneLongitude:=StringReplace(UneLongitude,'.',DecimalSeparator, []);
            end;
          end;
        end;
        DoCoordNext();
      except
        sMessage:=rs_Error_XML_of_Google_API+_CRLF
          +StringReplace(Utf8ToAnsi(Buffer),#10,_CRLF, [rfReplaceAll]);
        exit;
      end;
    end;
end;

procedure Tdm.NetUpdateFileDownloaded(const Sender: TObject;
  const MD5OK: Boolean);
begin
  with NetUpdate do
    if FileUpdate = CST_PARANCES Then
      doOpenPARANCES;
end;

procedure Tdm.NetUpdateIniRead(const Sender: TObject; const Total: integer);
begin
  with NetUpdate do
  if fi64_VersionExeInt64 ( VersionExeUpdate )
    >gci_context.NumVersion then
    MyMessageDlg( fs_RemplaceMsg(rs_Info_A_new_realease_can_be_downloaded_go_into_help_menu,[VersionExeUpdate]),
      mtInformation, [mbOk]);
end;

procedure Tdm.TimerHintTimer(Sender: TObject);
begin //utilisé lorsque le composant n'a pas d'événements onMouseEnter et onMouseLeave
  //pour gérer l'activation du hint
  Application.ShowHint:=gci_context.CanSeeHint;
  TimerHint.Enabled:=false;
end;


procedure Tdm.MetVarContextBase(Context,NomVar,Valeur:string);
begin
  Context:=UTF8UpperCase(Context);
  NomVar:=UTF8UpperCase(NomVar);
  if (UTF8UpperCase(Valeur)='NULL') or (Valeur='') then
    ReqSansCheck.SQL.Text:='select rdb$set_context('''+Context+''','''+NomVar+''',null) from rdb$database'
  else
    ReqSansCheck.SQL.Text:='select rdb$set_context('''+Context+''','''+NomVar+''','''+Valeur+''') from rdb$database';
  ReqSansCheck.ExecQuery;
  ReqSansCheck.Close;
end;

procedure Tdm.doVerifNouvelleVersion;
begin

end;

procedure Tdm.GetCoordonneesInternet(const Ville,Dept,Region,Pays:string;Proprio:TForm=nil);
var
  s:string;
begin
  bShift:=GetKeyState(VK_SHIFT)<0;
  Screen.Cursor:=crHourGlass;
  doc.Free;
  doc:=TXMLDocument.Create;
  s:=UneSubd;
  UneVille := Ville;
  if Ville>'' then
  begin
    if s>'' then
      s:=s+',';
    s:=s+Ville;
  end;
  if Dept>'' then
  begin
    if s>'' then
      s:=s+',';
    s:=s+Dept;
  end;
  if Region>'' then
  begin
    if s>'' then
      s:=s+',';
    s:=s+Region;
  end;
  if Pays>'' then
  begin
    if s>'' then
      s:=s+',';
    s:=s+Pays;
  end;
  s:=StringReplace(s,' ','+', [rfReplaceAll]);
  s:=AnsiToUtf8(s);
  s:=urlApiCoordonnees+'address='+s+'&sensor=false';
  NetUpdateBuffered.URLBase:=s;
  NetUpdateBuffered.Update;
end;

function Tdm.doOpenPARANCES:Boolean;
begin
  if not IBBaseParam.Connected then
  begin
    {$IFDEF WINDOWS}
    with IBBaseParam do
    if DatabaseName = '' Then // lazarus windows bug for GetAppConfigDir(True)
     Begin
      DatabaseName:=GetAppConfigDir(True);
      if not DirectoryExistsUTF8(DatabaseName) Then
        CreateDirUTF8(DatabaseName);
      DatabaseName:=DatabaseName+CST_PARANCES;
     End;
    {$ELSE}
    IBBaseParam.DatabaseName:=DEFAULT_FIREBIRD_DATA_DIR+CST_PARANCES;
    {$ENDIF}
    setBaseParams ( IBBaseParam,gci_context.UtilPARANCES,gci_context.PwUtilPARANCES,_lc_ctype_params,gci_context.RolePARANCES);
    try
      IBBaseParam.Open;
      IBTransParam.StartTransaction;
      Result:=True;
    except
      Result:=False;
      if FileExistsUTF8(IBBaseParam.DatabaseName)
        and ( FileSize(IBBaseParam.DatabaseName)>0) then
        MyMessageDlg(fs_RemplaceMsg(rs_Error_Sites_base_is_unavailable_it_exists,[IBBaseParam.DatabaseName])
          ,mtError,[mbOK])
      else
        if MyMessageDlg(fs_RemplaceMsg(rs_Error_Sites_base_is_unavailable_it_doesnt_exists,[IBBaseParam.DatabaseName])
          ,mtError,[mbYes,mbNo])=mrYes then
         with NetUpdate do
          begin
            if FileExistsUTF8(IBBaseParam.DatabaseName) Then DeleteFileUTF8(IBBaseParam.DatabaseName);
            doShowWorking(rs_Please_Wait+_CRLF+fs_RemplaceMsg(gs_Downloading_in_progress,[urlMajAutoMain+CST_PARANCES]));
            URLBase:=urlMajAutoInstall;
            FileUpdate:=CST_PARANCES;
            UpdateDir:=ExtractFileDir(IBBaseParam.DatabaseName);
            Update;
          end;
    end;
  end
  else
    Result:=True;
end;


procedure Tdm.doClosePARANCES;
begin
  if IBBaseParam.Connected then
  begin
    try
      try
        if IBTransParam.Active then
          IBTransParam.Commit;
      except
        IBTransParam.Rollback;
      end;
    finally
      IBBaseParam.Close;
    end;
  end;
end;

procedure Tdm.UniqueInstanceOtherInstance(Sender: TObject; ParamCount: Integer;
  Parameters: array of String);
var li_Tasks : Integer;
begin
  f_GetMemIniFile;
  li_Tasks := f_IniReadSectionInt(Name,DM_INI_NOT_SHOWED_TASKS,0);
  if li_Tasks > 3 Then
   Begin
     MyMessageDlg    ( rs_Try_to_destroy_task_intro+_CRLF
                      +rs_Try_to_destroy_task_what_to_do
{$IFDEF WINDOWS}+_CRLF+rs_Try_to_destroy_task_windows{$ENDIF}
                     ,mtWarning,[mbOK]);
     p_IniWriteSectionInt(Name,DM_INI_NOT_SHOWED_TASKS,0);
   end
  else p_IniWriteSectionInt(Name,DM_INI_NOT_SHOWED_TASKS,li_Tasks+1);
  fb_iniWriteFile( FIniFile, False );
end;


initialization
  sUpdateDir := GetAppConfigDirUTF8({$IFDEF WINDOWS}True{$ELSE}False{$ENDIF});
end.


