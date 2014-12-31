{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
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

unit u_common_functions;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes,SysUtils,Forms,Dialogs,Controls,
  graphics, U_ExtImage, DB,
  Stdctrls,
{$IFDEF FPC}
  LCLType, process,
{$ELSE}
  Windows, ShlObj,
{$ENDIF}
  u_objet_TMotsClesDate,
  LazUTF8,
  VirtualTrees,
  u_reports_components, IniFiles,
  extctrls, u_common_const,
  fonctions_system,
  fonctions_net,
  fonctions_string,
  u_objet_TGedcomDate,lazutf8classes;

const
  MEDIAS_MULTI_MEDIA = 'MULTI_MEDIA';
  MEDIAS_MP_IDENTITE = 'MP_IDENTITE';
  MEDIAS_MP_POINTE_SUR = 'MP_POINTE_SUR';
  MEDIAS_PATH = 'MULTI_PATH';
  MEDIAS_CLEF = 'MULTI_CLEF';
  MEDIAS_NOM = 'MULTI_NOM';
  MEDIAS_TABLE = 'MP_TABLE';
  MEDIAS_MEDIA = 'MP_MEDIA';
  MEDIAS_TYPE = 'MULTI_IMAGE_RTF';

  IBQ_NOM = 'NOM';
  IBQ_PRENOM = 'PRENOM';
  IBQ_ANNEE_NAISSANCE = 'ANNEE_NAISSANCE';
  IBQ_ANNEE_DECES = 'ANNEE_DECES';
  IBQ_VILLE_NAISSANCE = 'VILLE_BIRTH';
  IBQ_PAYS_NAISSANCE = 'PAYS_BIRTH';
  IBQ_VILLE_DECES = 'VILLE_DEATH';
  IBQ_IND_CONFIDENTIEL='IND_CONFIDENTIEL';

  _D1=365;
  _D4=_D1*4+1;//1461
  _D100=_D4*25-1;//36524
  _D400=_D100*4+1;//146097
  _DecalDateG=DateDelta-(_AnMini div 400)*_D400;
  _DecalDateJ=DateDelta+2-(_AnMini div 4)*_D4;
  DoCoordNext : TProcedureOfObject = nil;
  IniFilename = 'Update';
  FileUpdate = 'Update_Ancestro';

var _FileNameTraduction:string;
    _FileNameHelp:string;
    _GDate:TGedcomDate=nil;
    _DateN:TGedcomDate=nil;
    _GedDateCoherence:TGedcomDate=nil;
    _DateEv:TGedcomDate=nil;
    _DateTest:TGedcomDate=nil;
    _MotsClesDate:TMotsClesDate=nil;
    sOrdreLIT, sOrdreNUM : String;
    fBaseEmbedded:Boolean=False;
    fNomDossier,fPathBaseMedias,fPath_MesDocuments:string;
    _user_name:string='SYSDBA';
    _password:string='masterkey';
    _role_name:string;
    _Path_Appli:string;

procedure p_ShowHelp(ID:integer);
procedure CreateDates;
procedure GotoThisURL(URL:string);
function fs_verifyBaseForFile ( const as_base, as_path : String ):String; overload;
function fs_verifyBaseForFile ( const as_base, as_path : String ; const l_list : TStrings ):String; overload;
function AssembleString(s:array of string):string;
function AssembleStringWithSep(s:array of string;sep:string=', '):string;
function GetStringNaissanceDeces(sn,sd:string):string;
//function fu_ProgEnCours(NomProg:string):boolean;
function ConvertDeathDate(const AS_DeathDate : String):string;
function coupechaine(const str:string;const aLabel:TLabel):string;
function LoadStringListWithFichier(path:string;SL:TStringlistUTF8):integer;
procedure GetDirContent(InThisDir:string;aList:TStrings;What:string);
function _DayOfWeek(const DateTime:TDateTime):Integer;
function _TryEncodeDate(const An,Mois:Integer;Jour:Integer;const Cal:TCalendrier;out Date:TDateTime):Boolean;
function _IsLeapYear(Year:Integer;Cal:TCalendrier):Boolean;
//function SelectRepertoire(const TitreFonction:string;Var Path:string;Proprio:TForm=nil):Boolean;

//procedure OpenFicheIndividuInBox(aCleFiche:integer);
//procedure OuvreFicheIndividuModale(aCleFiche:integer);
//procedure CloseFicheIndividuInBox;

//Récupère le premier fichier rtm qui se présente dans le répertoire relatif
function SetValidPathString(const Dir:string):string;
procedure PaintPointille(sender:TObject);
procedure SendFocus(aWinControl:TWinControl);
function RemoveStrFromString(s,c:string):string;
function CorrigeNomFich(s:string):string;
function extractFileNameWithoutExt(s:string):string;
function NumVersionCourt(const iCombien:integer; const AncestroManiaVersion : TAVersionInfo ):string;

function Age_Texte(Date_Nais,Date_Eve:string):string;

function FormaterChaine(const sChaine:string;const ModeFormat:TModeFormatText):string;
function LongueDate(const an,mois,jour:integer;const Cal:TCalendrier):string;

function doZodiaque(dDate:Tdate):integer;
function chAge(AgeEnJours:integer;bDetailAge:boolean;LimiteJrSem:integer):string;
procedure ExecuteChaineDansChaine(UnText:string;Position:integer;Selection:integer=1);
function FaitDateVille(d,v:string):string;
function XYZenInt(x,y,z:Smallint):integer;
procedure IntenXYZ(i:integer;var x,y,z:integer);
function FichEstImage(const NomFichier:string):boolean;//MG2014
function FichEstSon(NomFichier:string):boolean;//MG2014
function FichEstVideo(NomFichier:string):boolean;//MG2014
function PosStringDansListe(Chaine:string;Liste:array of string):integer;//AL2010
function PosIntDansListe(Int:Integer;Liste:array of Integer):integer;//AL2010
function ConvertStrToFloat(s:string;var F:Extended):Boolean;//AL2010
procedure SetFontAngle ( const FontToChange : TFont ; const Angle : Integer );
procedure DecodeDateCode(DateCode:Integer;var An,Mois,Jour:Integer;Cal:TCalendrier);
function DefDateCode(an,mois,jour:Integer;Cal:TCalendrier;mode:integer;var DateCode:Integer):Boolean;
procedure CentreLaFiche(const LaFiche:TCustomForm; LaMere:TCustomForm=nil;const DecalX:integer=0;const DecalY:integer=0);
function doTesteDateEtJour(sDate:string;var joursem,sDateTrans:string
    ;out ans,mois,jours:integer;out Cal:TCalendrier):boolean;
//procedure DefContextLangue;//d?fini _Context.Langue avec la valeur en cours si acceptable si non FRA
{function ComprImageInMS(Fichier:string;var MS1:TMemoryStream;var MS2:TMemoryStream;
  OkImg1:boolean=true;H1:integer=140;W1:integer=120;//vue r?duite ou qualité jpeg=90
  OkImg2:boolean=false;H2:integer=1024;W2:integer=1024//vue si image chargée
  ):boolean;
 }
function fs_getNameAndSurName ( const ab_Show : Boolean ; const as_surname, as_name : String ) : String; overload;
function fs_getNameAndSurName ( const as_surname, as_name : String ; const ai_confidential : integer ) : String; overload;

var gcol_Forms : TColor=clWindow;

implementation

uses
{$IFDEF FPC}
  LCLProc,
{$ELSE}
  ShellAPI, Shlobj, ComObj, Tlhelp32,
{$ENDIF}
  u_common_resources,
  fonctions_file,
  FileUtil,
  BGRABitmapTypes,
  fonctions_images,
  fonctions_db,
  StrUtils,Math,
  DateUtils,
  u_gedcom_const,
  Printers,
  fonctions_init,
  typinfo,
  FileCtrl;

// function TF_AncestroWeb.fs_getNameAndSurName
// Getting name and surname
function fs_getNameAndSurName ( const as_surname, as_name : String ; const ai_confidential : integer ) : String;
Begin
  Result := fs_getNameAndSurName (( ai_confidential < 1 ) or ( ai_confidential > 2 ), as_surname, as_name );
End;

// function TF_AncestroWeb.fs_getNameAndSurName
// Getting name and surname
function fs_getNameAndSurName (  const ab_Show : Boolean ; const as_surname, as_name : String ) : String;
Begin
  if ab_Show
    Then Result:=as_surname+' ' + as_name
    Else
     if as_name = ''
       Then Result:=as_surname
       else Result:=as_surname+' ' + as_name [ 1 ] +'.';
End;

//MD 04/2009 réécriture et remplacement de Date as DateTime par  ans,mois,jours as Integer
function doTesteDateEtJour(sDate:string;var joursem,sDateTrans:string
    ;out ans,mois,jours:integer;out Cal:TCalendrier):boolean;
  begin
    ans:=0;
    mois:=0;
    jours:=0;

    if _DateTest.DecodeHumanDate(sDate) then
    begin
      sDateTrans:=_DateTest.HumanDate;
      Cal:=_DateTest.Calendrier1;
      if _DateTest.ValidDateTime1 then
        joursem:=LongDayNames[_DayOfWeek(_DateTest.DateTime1)]
      else
        joursem:='';

      ans:=_DateTest.Year1;
      if _DateTest.Month1<1 then
        mois:=7
      else
        mois:=_DateTest.Month1;
      if _DateTest.Day1<1 then
      begin
        if _DateTest.Month1<1 then
          jours:=1
        else
          jours:=15
      end
      else
        jours:=_DateTest.Day1;
      result:=true;
    end
    else
    begin
      SDateTrans:=sDate;
      joursem:='';
      result:=false;
    end;
  end;

function Age_Vivant(Date_Nais:string;var AgeTexte:string):Integer;
  function DefDateWriten(LaDate:TDateTime):string;
  var//adaptation au calendrier inutile, utilisée uniquement avec "Maintenant" dans Age_Vivant
    y,m,d,vy,vm,vd:Word;
    sy,sm,sd:string;
  begin
    y:=Pos('Y',_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][1]);
    m:=Pos('M',_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][1]);
    d:=Pos('D',_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][1]);
    DecodeDate(LaDate,vy,vm,vd);
    sy:=IntToStr(vy);
    sm:=IntToStr(vm);
    sd:=IntToStr(vd);
    if (d<m)and(d<y) then
    begin
      if m<y then
        Result:=AssembleStringWithSep([sd,sm,sy],' ')
      else
        Result:=AssembleStringWithSep([sd,sy,sm],' ');
    end
    else if (m<d)and(m<y) then
    begin
      if d<y then
        Result:=AssembleStringWithSep([sm,sd,sy],' ')
      else
        Result:=AssembleStringWithSep([sm,sy,sd],' ');
    end
    else
    begin
      if d<m then
        Result:=AssembleStringWithSep([sy,sd,sm],' ')
      else
        Result:=AssembleStringWithSep([sy,sm,sd],' ');
    end;
  end;

var
  Maintenant:string;
begin
  Result:=-1;
  Maintenant:=DefDateWriten(Date);
  AgeTexte:=Age_Texte(Date_Nais,Maintenant);
  if Length(AgeTexte)>0 then
    Result:=_DateEv.DateCode1-_DateN.DateCode1;
end;

function Age_Texte(Date_Nais,Date_Eve:string):string;
//MD 04/2009 première transposition des procedures stockées du même nom
//AL2012 adaptation avec les datecodes
var
  precis,ians,imois,ijours,i,j:integer;
  age_max,age_min:string;
  bMin,bMax:Boolean;

  function jours_texte:string;
  //MD 04/2009 Transposition de la procedure stockée du même nom
  var
    S:string;
  begin
    result:='';
    if (ians=0)and(imois=0)and(ijours<15) then
    begin
      if (ijours<2) then
        S:=IntToStr(ijours)+' jour'
      else
        S:=IntToStr(ijours)+' jours';
      result:=S;
      exit;
    end;
    if (ians=0)and(imois<2) then
    begin
      if (imois>0) then
        S:=IntToStr(floor(ijours/7)+4)+' semaines'
      else
        S:=IntToStr(floor(ijours/7))+' semaines';
      result:=S;
      Exit;
    end;
    if (ians=0) then
    begin
      S:=IntToStr(imois)+' mois';
      if (Precis=1)and(ijours>14) then
        S:=S+' et demi';
      result:=S;
      Exit;
    end;
    if (ians=1)and(imois>0) then
    begin
      S:=IntToStr(12+imois)+' mois';
      if (Precis=1)and(ijours>14) then
        S:=S+' et demi';
      result:=S;
      Exit;
    end;
    if (ians>0) then
    begin
      if (ians=1) then
        S:='1 an'
      else
        S:=IntToStr(ians)+' ans';
      if (Precis=1)and(imois>0) then
        S:=S+' et '+IntToStr(imois)+' mois';
      result:=S;
    end;
  end;

  function Delta_Dates(NbrJours:Integer):boolean;
  begin
    if NbrJours>0 then
    begin
      ians:=trunc(NbrJours/365.25);
      imois:=trunc((NbrJours-trunc(ians*365.25))/30.4375);
      ijours:=NbrJours-trunc(ians*365.25)-trunc(imois*30.4375);
      Result:=True;
    end
    else
    begin
      ians:=0;
      imois:=0;
      ijours:=0;
      Result:=NbrJours=0;//NbrJours<0 erreur ordre des dates
    end;
  end;

begin
  age_max:='';
  age_min:='';
  ians:=0;
  imois:=0;
  ijours:=0;
  Result:='';
  Date_Nais:=Trim(Date_Nais);
  Date_Eve:=Trim(Date_Eve);

  if (length(Date_Nais)=0)or(length(Date_Eve)=0) then
    exit;
  if _DateN.DecodeHumanDate(Date_Nais)and _DateEv.DecodeHumanDate(Date_Eve) then
  begin
    if (_DateN.Type_Key1 in [19..21])or(_DateEv.Type_Key1 in [19..21]) then
    begin
      i:=_DateEv.DateCode1-_DateN.DateCode1;
      j:=i;
    end
    else
    begin
      if (_DateEv.DateCodeTot>-MaxInt)and(_DateN.DateCodeTot>-MaxInt) then
      begin
        i:=_DateEv.DateCodeTot-_DateN.DateCodeTard;
        j:=_DateEv.DateCodeTard-_DateN.DateCodeTot;
      end
      else //dépassement capacité Integer
        exit;
    end;

    if (_DateN.Day1=-1)or(_DateEv.Day1=-1)
      or(_DateN.UseDate2 and(_DateN.Day2=-1))
      or(_DateEv.UseDate2 and(_DateEv.Day2=-1)) then
      precis:=0
    else
      precis:=1;

    bMin:=False;
    if i<50000 then
      if delta_dates(i) then
      begin
        age_min:=Jours_Texte;
        bMin:=True;
      end
      else
        exit;

    bMax:=False;
    if j<50000 then
      if delta_dates(j) then
      begin
        age_max:=Jours_Texte;
        bMax:=True;
      end
      else
        exit;

    if not bMin and not bMax then
      exit;

    if (_DateN.Type_Key1 in [19..21])or(_DateEv.Type_Key1 in [19..21]) then
      Result:='environ ';

    if not bMin then
      Result:=Result+'au plus '+age_max
    else if not bMax then
      Result:=Result+'au moins '+age_min
    else if age_min=age_max then
      Result:=Result+age_min
    else
      Result:=Result+age_min+' à '+age_max;
  end;
end;

procedure DecodeDateCode(DateCode:Integer;var An,Mois,Jour:Integer;Cal:TCalendrier);
  procedure _DivMod(Dividende,Diviseur:Integer;out Resultat,Reste:Integer);
  begin
    Resultat:=Dividende div Diviseur;
    Reste:=Dividende-Resultat*Diviseur;
  end;
var
  T,Y,M,I:Integer;
  DayTable:PDayTable;
begin
  if Cal=cGRE then
    T:=DateCode+_DecalDateG
  else if Cal=cJUL then
    T:=DateCode+_DecalDateJ
  else
    T:=-1;
  if T<=0 then
  begin
    An:=0;
    Mois:=0;
    Jour:=0;
  end
  else
  begin
    Y:=1;
    if Cal=cGRE then
    begin
      _DivMod(T,_D400,I,T);
      Inc(Y,I*400);
      if T=0 then
      begin
        Dec(Y,400);
        Inc(T,_D400);
      end;
      _DivMod(T,_D100,I,T);
      Inc(Y,I*100);
      if T=0 then
      begin
        Dec(Y,100);
        Inc(T,_D100);
      end;
    end;
    _DivMod(T,_D4,I,T);
    Inc(Y,I*4);
    if T=0 then
    begin
      Dec(Y,4);
      Inc(T,_D4);
    end;
    _DivMod(T,_D1,I,T);
    Inc(Y,I);
    if T=0 then
    begin
      Dec(Y);
      Inc(T,_D1);
    end;
    DayTable:=@MonthDays[_IsLeapYear(Y,Cal)];
    M:=1;
    while True do
    begin
      I:=DayTable^[M];
      if T<=I then Break;
      Dec(T,I);
      Inc(M);
    end;
    An:=Y+_AnMini;
    if (Cal=cJUL)and(An<=0) then
      An:=An-1;
    Mois:=M;
    Jour:=T;
  end;
end;

function DefDateCode(an,mois,jour:Integer;Cal:TCalendrier;mode:integer;var DateCode:Integer):Boolean;
//transposition de la procédure stockée PROC_DATE_CODE permettant de générer une date_code
//moyenne Mode=0, minimisée Mode=1 ou maximisée Mode=2
var
  delta:integer;
  DateT:TDateTime;
begin
  delta:=0;
  if jour<=0 then //date incomplète: peut être moyenne, minimisée ou maximisée
  begin
    if mois>0 then
    begin
      case mode of
        1:jour:=1;
        2:
          begin
            jour:=1;
            mois:=mois+1;
            delta:=-1;
          end;
        else
          jour:=15;
      end;
      if mois>12 then
      begin
        an:=an+1;
        mois:=1;
      end;
    end
    else //que l'année
    begin
      case mode of
        1:
          begin
            jour:=1;
            mois:=1;
          end;
        2:
          begin
            jour:=1;
            mois:=1;
            an:=an+1;
            delta:=-1;
          end;
        else
          begin
            jour:=1;
            mois:=7;
          end;
      end;
    end;
  end;
  Result:=_TryEncodeDate(an,mois,jour,Cal,DateT);
  if Result then
    DateCode:=Trunc(DateT)+delta;
end;

procedure CentreLaFiche(const LaFiche:TCustomForm; LaMere:TCustomForm=nil;const DecalX:integer=0;const DecalY:integer=0);
var
  RectMonitor:TRect;
begin //créée parce que poMainFormCenter et poOwnerFormCenter ne marche pas sur l'écran secondaire.
  //poOwnerFormCenter fonctionne mal si la fiche propriétaire est incrustée (cas de l'index des villes
  // qui devrait être poOwnerFormCenter pour l'événement individuel et poMainFormCenter pour Unions et domiciles).
  if LaMere=nil then
    LaMere:=Application.MainForm; //FMain
  LaFiche.Position:=poDesigned;
  LaFiche.Top:=LaMere.Top+DecalY+(LaMere.Height-LaFiche.Height)div 2;
  LaFiche.Left:=LaMere.Left+DecalX+(LaMere.Width-LaFiche.Width)div 2;
  RectMonitor:=LaFiche.Monitor.WorkareaRect;

  if (LaFiche.Top+LaFiche.Height)>RectMonitor.Bottom then
    LaFiche.Top:=RectMonitor.Bottom-LaFiche.Height;
  if LaFiche.Top<RectMonitor.Top then
    LaFiche.Top:=RectMonitor.Top;

  if (LaFiche.Left+LaFiche.Width)>RectMonitor.Right then
    LaFiche.Left:=RectMonitor.Right-LaFiche.Width;
  if LaFiche.Left<RectMonitor.Left then
    LaFiche.Left:=RectMonitor.Left;
end;




function _IsLeapYear(Year:Integer;Cal:TCalendrier):Boolean;
var
  y:Integer;
begin//dans la version originale de IsLeapYear, Year est un Word toujours positif
  if Cal=cGRE then
    Result:=(Year mod 4=0)and((Year mod 100<>0)or(Year mod 400=0))
  else if Cal=cJUL then
  begin
    y:=Year;
    if y<0 then
      y:=y+1;
    Result:=y mod 4=0;
  end
  else
    Result:=False;
end;

function _DayOfWeek(const DateTime:TDateTime):Integer;
begin//version de DayOfWeek tenant compte des dates avJC
  Result:=1+((Trunc(DateTime)-1)mod 7);
  if Result<1 then
    Inc(Result,7);
end;

function _TryEncodeDate(const An,Mois:Integer;Jour:Integer;const Cal:TCalendrier;out Date:TDateTime):Boolean;
var
  I:Integer;
  DayTable:PDayTable;
begin//extension du calendrier grégorien vers les dates avJC
  Result:=False;
  DayTable:=@MonthDays[_IsLeapYear(An,Cal)];
  if (An>=_AnMini)and(An<=_AnMaxi)and(Mois>=1)and(Mois<=12)and((An<>0)or(Cal=cGRE))
    and(Jour>=1)and(Jour<=DayTable^[Mois]) then
  begin
    for I:=1 to Mois-1 do
      Inc(Jour,DayTable^[I]);
    I:=An-_AnMini-1;
    if Cal=cGRE then
    begin
      Date:=I*365+I div 4-I div 100+I div 400+Jour-_DecalDateG;
    end
    else if Cal=cJUL then
    begin
      if An<0 then
        I:=I+1;
      Date:=I*365+I div 4+Jour-_DecalDateJ;
    end;
    Result:=True;
  end;
end;




function LongueDate(const an,mois,jour:integer;const Cal:TCalendrier):string;
var
  s,sy,sm,sd:string;
  y,m,d:integer;
  dt:TDateTime;
begin
  if _TryEncodeDate(an,mois,jour,Cal,dt) then
    Result:=LongDayNames[_DayOfWeek(dt)]+' '
  else
    Result:='';
  s:=UpperCase(LongDateFormat);
  y:=Pos('Y',s);
  m:=Pos('M',s);
  d:=Pos('D',s);
  if jour>0 then
    sd:=IntToStr(jour)
  else
    sd:='';
  sm:=LongMonthNames[mois];
  sy:=IntToStr(an);
  if (d<m)and(d<y) then
  begin
    if m<y then
      Result:=Result+AssembleStringWithSep([sd,sm,sy],' ')
    else
      Result:=Result+AssembleStringWithSep([sd,sy,sm],' ');
  end
  else if (m<d)and(m<y) then
  begin
    if d<y then
      Result:=Result+AssembleStringWithSep([sm,sd,sy],' ')
    else
      Result:=Result+AssembleStringWithSep([sm,sy,sd],' ');
  end
  else
  begin
    if d<m then
      Result:=Result+AssembleStringWithSep([sy,sd,sm],' ')
    else
      Result:=Result+AssembleStringWithSep([sy,sm,sd],' ');
  end;
end;

procedure SetFontAngle ( const FontToChange : TFont ; const Angle : Integer );
var
  lf:TLogFont;
  tf:TFont;

begin
  {$IFDEF FPC}
  FontToChange.Orientation:=Angle;
  {$ELSE}
  tf:=TFont.Create;
  tf.Assign(PaintBox.Canvas.Font);
  GetObject(tf.Handle,sizeof(lf),@lf);
  lf.lfEscapement:=Angle;
  lf.lfOrientation:=Angle;
  tf.Handle:=CreateFontIndirect(lf);
  PaintBox.Canvas.Font.Assign(tf);
  tf.Free;
  {$ENDIF}
end;

function chAge(AgeEnJours:integer;bDetailAge:boolean;LimiteJrSem:integer):string;
// Cr?e par BT le 23.05.2005
// retourne une phrase présentant l'âge avec ou sans détail
// Param?tres:
//    - AgeEnJours: le nombre de jours représentant l'age (ex de date naissance à décès)
//    - bDetailAge
//          false --> sans détail sauf Bas Ages (ex: '47 ans', ou '2 jours')
//          true  --> avec 2 niveaux de detail ( exple: '47 ans et 2 mois')
//    - LimiteJrSem: indique à partir de combien de jours, on raisonne en semaines
//utilis?e uniquement dans Navigation
var
  AgeAnnee,AgeMois,AgeSem,AgeJours:integer;
  NbJours:extended;
  s:string;

begin
  NbJours:=AgeEnJours;
  AgeAnnee:=trunc(NbJours/365.25);// nbre annees entieres
  NbJours:=NbJours-(AgeAnnee*365.25);
  AgeMois:=trunc(NbJours/(365.25/12));// nbre mois entiers
  NbJours:=NbJours-(AgeMois*(365.25/12));
  AgeSem:=trunc(NbJours/7);// nbre semaines entieres
  NbJours:=NbJours-(AgeSem*7);
  AgeJours:=trunc(NbJours);// nbre jours entiers
  if AgeAnnee>0 then
  begin
    s:=IntTostr(AgeAnnee)+' an';
    if AgeAnnee>1 then
      s:=s+'s';
    if bDetailAge and(AgeMois>0) then
      s:=s+' et '+IntTostr(AgeMois)+' mois';
  end
  else
  begin
    if AgeMois>0 then
    begin
      s:=IntTostr(AgeMois)+' mois';
      if bDetailAge and(AgeSem>0) then
      begin
        s:=s+' et '+IntTostr(AgeSem)+' semaine';
        if AgeSem>1 then
          s:=s+'s';
      end;
    end
    else
    begin//Point à revoir le limitejrsem ne peut pas marcher correctement
      {LimiteJrSem:=0;//provisoire
      if (AgeSem>LimiteJrSem)and(AgeSem>0) then
      begin
        s:=s+IntTostr(AgeSem)+' semaine';
        if AgeSem>1 then s:=s+'s';
        if bDetailAge then
        begin
          if AgeSem>0 then s:=s+' et ';
          s:=s+IntTostr(AgeJours)+' jour';
          if AgeJours>1 then s:=s+'s';
        end;
      end
      else
      begin
        if AgeJours>0 then s:=s+IntTostr(AgeJours)+' jour';
        if AgeJours>1 then s:=s+'s';
      end;//If AgeSem > LimiteJrSem }
      if LimiteJrSem<1 then //reprise AL2010
        LimiteJrSem:=1;
      if AgeSem<LimiteJrSem then
      begin
        if AgeJours>0 then
          s:=IntTostr(AgeJours)+' jour';
        if AgeJours>1 then
          s:=s+'s';
      end
      else
      begin
        if bDetailAge then
          s:=IntTostr(AgeJours)+' jours'
        else
        begin
          s:=IntTostr(AgeSem)+' semaine';
          if AgeSem>1 then
            s:=s+'s';
        end;
      end;//if AgeSem<LimiteJrSem
    end;//If AgeMois > 0
  end;// If AgeAnnee > 0

  result:=s;
end;

function doZodiaque(dDate:Tdate):integer;
var
  iJour:Integer;
begin
  if dDate<>0 then
  begin
    iJour:=DayOfTheYear(dDate);

    if (iJour<=21) then
      Result:=11// Capricorne
    else if (iJour<=50) then
      Result:=0// Verseau
    else if (iJour<=79) then
      Result:=1// Poissons
    else if (iJour<=110) then
      Result:=2// B?lier
    else if (iJour<=141) then
      Result:=3// Taureau
    else if (iJour<=172) then
      Result:=4// G?maux
    else if (iJour<=204) then
      Result:=5// Cancer
    else if (iJour<=235) then
      Result:=6// Lion
    else if (iJour<=266) then
      Result:=7// Vierge
    else if (iJour<=296) then
      Result:=8// Balance
    else if (iJour<=326) then
      Result:=9// Scorpion
    else if (iJour<=355) then
      Result:=10// Sagittaire
    else
      Result:=11;// Capricorne
  end
  else
    result:=-1;
end;

function LoadStringListWithFichier(path:string;SL:TStringlistUTF8):integer;
// Remplissage d une string list
var
  F:TSearchRec;
  R:integer;
begin
  SL.Clear;
  r:={$IFDEF FPC}FindFirstUTF8{$ELSE}FindFirstUTF8{$ENDIF}  (path, faAnyFile, F); { *Converted from FindFirstUTF8*  }
  while r=0 do
  begin
    SL.Add(F.Name);
    r:={$IFDEF FPC}FindNextUTF8{$ELSE}FindNextUTF8{$ENDIF}(F); { *Converted from FindNextUTF8*  }
  end;
  {$IFDEF FPC}FindCloseUTF8{$ELSE}FindCloseUTF8{$ENDIF}(F); { *Converted from FindCloseUTF8*  }
  SL.Sort;
  Result:=r;
end;

function AssembleString(s:array of string):string;
//var
//  i:Integer;
//  sub:string;
begin
  result:=AssembleStringWithSep(s,', ');
{  for i:=0 to High(s) do
  begin
    sub:=trim(s[i]);
    if sub<>'' then
    begin
      if result<>'' then
        result:=result+', ';
      result:=result+sub;
    end;
  end;}
end;


function AssembleStringWithSep(s:array of string;sep:string=', '):string;
var
  i:Integer;
  sub:string;
begin
  result:='';
  for i:=0 to High(s) do
  begin
    sub:=trim(s[i]);
    if sub<>'' then
    begin
      if result<>'' then
        result:=result+sep;
      result:=result+sub;
    end;
  end;
end;

function coupechaine(const str:string;const aLabel:TLabel):string;
var
  s:string;
  n:integer;
begin
  //On assigne la font du label, à son canvas
  aLabel.Canvas.Font.Assign(aLabel.Font);
  if aLabel.Canvas.TextWidth(str)<=aLabel.width then
    result:=str
  else
  begin
    s:=fs_FormatText(str,mftNone,True);
    for n:=length(str) downto 1 do
    begin
      Delete(s,n,1);
      if aLabel.Canvas.TextWidth(s+CST_THREE_POINTS)>aLabel.Width then
        break;
    end;

    result:=utf8copy(str,1,n)+CST_THREE_POINTS;
  end;
end;

procedure GetDirContent(InThisDir:string;aList:TStrings;What:string);
var
  SearchRec:TSearchRec;
  found:word;
begin
  InThisDir:=InThisDir+What;
  aList.Clear;
  try
    found:=FindFirstUTF8 (InThisDir, faArchive, searchrec);
    while found=0 do
    begin
      aList.Add(searchrec.Name);

      found:=FindNextUTF8(searchrec);
    end;
  finally
    FindCloseUTF8(searchrec);
  end;
end;



function SetValidPathString(const Dir:string):string;
begin
  if (Dir<>'')and(Dir[Length(Dir)]<>'\') then
    result:=Dir+'\'
  else
    result:=Dir;
end;

procedure PaintPointille(sender:TObject);
var
  pb:TPaintBox;
  k:integer;
begin
  pb:=TPaintBox(sender);
  pb.Canvas.Pen.Color:=clGray;
  pb.Canvas.Pen.Width:=1;

  k:=0;
  if pb.width>pb.Height then
  begin
    while k<pb.width do
    begin
      pb.Canvas.MoveTo(k,0);
      pb.Canvas.LineTo(k+3,0);
      k:=k+6;
    end;
  end
  else
  begin
    while k<pb.height do
    begin
      pb.Canvas.MoveTo(0,k);
      pb.Canvas.LineTo(0,k+3);
      k:=k+6;
    end;
  end;
end;

procedure SendFocus(aWinControl:TWinControl);
begin
  if aWinControl.CanFocus then
    aWinControl.SetFocus;
end;


function RemoveStrFromString(s,c:string):string;
var
  p:integer;
begin
  repeat
    p:=pos(c,s);
    if p>0 then
      delete(s,p,length(c));
  until p=0;
  result:=s;
end;

function CorrigeNomFich(s:string):string;
const
  // Matthieu : Deux caractères ne passent pas entre ° et !
  ok='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_ 0123456789àâäãéèêëîïõôöùûüç+-{}[]#@²°!&$£€µ%§!~''';
var
  n,k:integer;
begin
  s:=trim(s);
  for n:=length(s)downto 1 do
  begin
    k:=pos(s[n],ok);
    if k=0 then
      s[n]:='_';
  end;
  if s='' then
    s:='MonFichier';
  result:=s;
end;

function extractFileNameWithoutExt(s:string):string;
var
  n:integer;//AL 2009
begin
  result:=ExtractFileName(s);
  n:=Length(ExtractFileExt(result));
  if n>0 then
    result:=LeftStr(result,Length(result)-n)
end;

function GetStringNaissanceDeces(sn,sd:string):string;
begin
  result:='';
  sn:=trim(sn);
  sd:=trim(sd);
  if (length(sn)>0)or(length(sd)>0) then
  begin
    result:=' (';
    if length(sn)>0 then
    begin
      result:=result+'°'+sn;
      if length(sd)>0 then
        result:=result+' †'+sd;
    end
    else
      result:=result+'†'+sd;
    result:=result+')';
  end;
end;


function FormaterChaine(const sChaine:string;const ModeFormat:TModeFormatText):string;
var
  s:string;
  i,l:integer;

  function lettre(i:integer):Char;
  begin
    if i<=l then
      result:=s[i]
    else
      result:=#0;
  end;

begin
  s:=trim(sChaine);
  result:='';
  l:=Length(s);
  for i:=1 to l do
  begin
    case s[i] of
      ',',';':
        if lettre(i+1)<>' ' then
          result:=result+', '
        else
          result:=result+',';
      ' ':
        if (not(s[i+1]in [' ','-',',',';']))and(not(s[i-1]='-')) then
          result:=result+' ';
      '-':
        if (not(lettre(i+1)in ['-',',',';'])) then
          result:=result+'-';
      else //case
          result:=result+s[i];
    end;//case
  end;//de For
  p_FormatText(Result,ModeFormat);
end;

{procedure doPlaySound(a_File:string);
const
  START='start.wav';
  INFOBULLE='LCLType XP Infobulle.wav';
  MENU='LCLType XP Commande de menu.wav';
begin
  //Joue le fichier son
  if _Context.IsSons then
  begin
    if a_File='start' then
      a_file:=START
    else if a_File='bulle' then
      a_file:=INFOBULLE
    else if a_File='menu' then
      a_file:=MENU;

    SndPlaySound(Pchar(a_File),SND_ASYNC);

    Application.ProcessMessages;
  end;
end;}


procedure ExecuteChaineDansChaine(UnText:string;Position:integer;Selection:integer=1);
const
  SepDebut= [#10,#13,'<'];
  SepFin= [#10,#13,'>'];
var
  s:string;
  i,deb,len:integer;
begin
  if UnText>'' then
  begin
    Position:=Position+Selection;
    for i:=Position downto 1 do
      if UnText[i]in SepDebut then
        break;
    deb:=i+1;
    len:=0;
    for i:=deb to length(UnText) do
    begin
      if UnText[i]in SepFin then
        break;
      inc(len);
    end;
    s:=trim(copy(UnText,deb,len));
    if s>'' then
      p_OpenFileOrDirectory(s);
  end;
end;

procedure GotoThisURL(URL:string);
begin
  if pos ( ':', URL ) = 0 Then
   URL := 'http://' + URL;
  p_OpenFileOrDirectory(URL);
end;

function fs_verifyBase ( const as_base, as_path : String ; const l_list : TStrings ):String;
var
    ls_dir : String;
    li_i, li_pos, li_j : Integer;
Begin
  li_j := 0;
  Result := as_path;
  if {$IFDEF WINDOWS}(pos(':',Result)=2) and {$ENDIF}
    FileExistsUTF8(Result) Then
     Exit;
  for li_i:=0 to l_list.Count - 1 do
   Begin
     ls_dir := l_list [ li_i ];
     inc ( li_j, Length(ls_dir) + 1 );
     if (ls_dir = '') or ( pos ( ':', ls_dir ) > 0 ) Then Continue;

     li_pos := pos ( ls_dir, as_path );
     if ( li_pos > 0 )
     and ( as_path [ li_pos -1 ] = DirectorySeparator )
     and ( as_path [ li_pos + Length(ls_dir) ] = DirectorySeparator ) Then
      Begin
        ls_dir:= copy ( as_base, 1, li_j - Length(ls_dir) - 1 ) + copy ( as_path, li_pos, Length(as_path) - li_pos + 1 );
        if FileExistsUTF8( ls_dir ) Then
          Begin
            Result := ls_dir;
            Exit;
          end;
      End;
   end;

end;


function fs_verifyBaseForFile ( const as_base, as_path : String ; const l_list : TStrings ):String;
Begin
  {$IFDEF WINDOWS}
  Result:= fs_verifyAndReplaceDriveLetter ( as_path );
  Result:= fs_verifyBase ( as_base, as_path, l_list );
  while not FileExistsUTF8(Result) and ( Result [ 1 ] <> 'C' ) do
   Begin
     Result:= fs_verifyAndReplaceDriveLetter ( chr ( ord ( Result [ 1 ] ) - 1 )
                                   + copy ( Result, 2, Length(Result) -1));
     Result:= fs_verifyBase ( as_base, Result, l_list );
   end;
  {$ELSE}
  Result:= fs_verifyBase ( as_base, as_path, l_list );
  {$ENDIF}
end;

function fs_verifyBaseForFile ( const as_base, as_path : String ):String;
var l_list : TStrings;

Begin
 l_list:=nil;
 p_ChampsVersListe(l_list,
                   as_base,
                   DirectorySeparator);

 Result:= fs_verifyBaseForFile (  as_base, as_path, l_list );

end;



function FaitDateVille(d,v:string):string;
begin
  if (length(d)>0)or(length(v)>0) then
    if length(d)>0 then
      if length(v)>0 then
        result:=d+'-'+v
      else
        result:=d
    else
      result:=v
  else
    result:='';
end;

//MD 04/2009 r??criture et remplacement de Date as DateTime en  ans,mois,jours as Integer
// en fait on pourrait supprimer cette fonction en ajoutant joursem dans DecodeHumanDate

function XYZenInt(x,y,z:Smallint):integer;
begin
  Result:=(x and $FFF)or((y and $FFF)shl 12)or((z and $FF)shl 24);
end;

procedure IntenXYZ(i:integer;var x,y,z:integer);
begin
  x:=i and $00000FFF;
  y:=(i and $00FFF000)shr 12;
  z:=(i and $FF000000)shr 24;
end;


function PosIntDansListe(Int:Integer;Liste:array of Integer):integer;//AL2010
var
  l:integer;
begin
  Result:=0;
  l:=Length(Liste);
  while (Result<l)and(Liste[Result]<>Int) do
  begin
    inc(Result)
  end;
  if Result=l then
    Result:=-1;
end;

function PosStringDansListe(Chaine:string;Liste:array of string):integer;
var
  l:integer;
begin
  Result:=0;
  l:=Length(Liste);
  while (Result<l)and(Liste[Result]<>Chaine) do
  begin
    inc(Result)
  end;
  if Result=l then
    Result:=-1;
end;

function NumVersionCourt(const iCombien:integer; const AncestroManiaVersion : TAVersionInfo ):string;
var
  VS:array[0..3] of string;
  S:string;
begin
  // En passant un chiffre de 1 à 8 on reçoit de 1 à 4 parametres
  S:=ParamStr(0);

  VS[0]:=IntToStr(AncestroManiaVersion[0]);
  VS[1]:=IntToStr(AncestroManiaVersion[1]);
  VS[2]:=IntToStr(AncestroManiaVersion[2]);
  VS[3]:=IntToStr(AncestroManiaVersion[3]);
  case iCombien of
    1:result:=VS[0];
    2:result:=VS[0]+'.'+VS[1];
    3:result:=VS[0]+'.'+VS[1]+'.'+VS[2];
    5:result:=VS[0]+VS[1]+VS[2]+VS[3];
    6:result:=VS[1];
    8:result:=VS[0]+'.'+VS[3];
    else
      result:=VS[0]+'.'+VS[1]+'.'+VS[2]+'.'+VS[3];
  end;
end;

function FichEstImage(const NomFichier:string):boolean;
begin
  Result:=SuggestImageFormat(NomFichier)>ifUnknown;
end;

function FichEstSon(NomFichier:string):boolean;
const
  Liste:array[0..3] of string=('.WAV','.MP3','.WMA','.OGG');
var
  s:string;
begin
  s:=UpperCase(ExtractFileExt(NomFichier));
  Result:=PosStringDansListe(s,Liste)>-1
end;

function FichEstVideo(NomFichier:string):boolean;
const
  Liste:array[0..4] of string=('.AVI','.MP4','.MPEG','.OGV','.OGM');
var
  s:string;
begin
  s:=UpperCase(ExtractFileExt(NomFichier));
  Result:=PosStringDansListe(s,Liste)>-1
end;

function ConvertStrToFloat(s:string;var F:Extended):Boolean;
begin
  result:=true;
  if DecimalSeparator=',' then
    s:=AnsiReplaceStr(s,'.',',')
  else if DecimalSeparator='.' then
    s:=AnsiReplaceStr(s,',','.')
  else
    result:=false;
  if result then
  begin
    F:=StrToFloatDef(s,PI);
    if F=PI then
      result:=false;
  end;
end;
procedure CreateDates;
Begin
  _MotsClesDate:=TMotsClesDate.create;
  _GDate:=TGedcomDate.create;
  _GDate.InitTGedcomDate(_MotsClesDate,_MotsClesDate);
  _DateN:=TGedcomDate.Create;
  _DateN.InitTGedcomDate(_MotsClesDate,_MotsClesDate);
  _DateEv:=TGedcomDate.Create;
  _DateEv.InitTGedcomDate(_MotsClesDate,_MotsClesDate);
  _DateTest:=TGedcomDate.Create;
  _DateTest.InitTGedcomDate(_MotsClesDate,_MotsClesDate);
  _GedDateCoherence:=TGedcomDate.Create;
  _GedDateCoherence.InitTGedcomDate(_MotsClesDate,_MotsClesDate);
End;

function ConvertDeathDate(const AS_DeathDate : String):string;
Begin
  Result := StringReplace(AS_DeathDate,chr(194)+chr(134),'†',[rfReplaceAll]);
end;

procedure p_ShowHelp(ID:integer);
var
  s:string;
begin
  {     Matthieu : Pour André
  if not _hhInstalled then
    MyMessageDlg('Vous n''avez pas installé Microsoft HTML Help.'+_CRLF+_CRLF+
      'Veuillez l''installer pour avoir accès à l''aide.',mtError, [mbOK],0)
  else }
  begin
    case ID of
      _HELP_BIENVENUE:s:='A-0';
      _HELP_INDI_START:s:='E-0';
      _HELP_INDI_IDENTITE:s:='E-1';
      _HELP_INDI_UNIONS:s:='E-2';
      _HELP_INDI_ARBRE:s:='E-3';
      _HELP_INDI_PHOTO_DOC:s:='E-4';
      _HELP_INDI_INFOS:s:='E-5';
      _HELP_INDI_DOMICILES:s:='E-6';
      _HELP_FAVORIS:s:='H-4';
      _ID_ARBRE:s:='E-3';
      _ID_RECHERCHER:s:='H-2';
      _ID_ANNIVERSAIRE:s:='N-0';
      _ID_VILLES:s:='G-4';
      _ID_IMPORTATION_GEDCOM:s:='T-2';
      _ID_EXPORTATION_GEDCOM:s:='T-1';
      _ID_EXPORTATION_GENEANET:s:='T-3';
      //_ID_INDIVIDU_PAR_PRENOM:s:='H-2';
      _ID_PARAMETRES:s:='WP-0';
      _ID_DOSSIER:s:='S-0';
      //_ID_NO_DOSSIER:s:='S-0';
      _ID_PRINT_ARBRE:s:='U-1';
      _ID_PRINT_ROUE:s:='U-2';
      _ID_PRINT:s:='U-3';
      _ID_POSTIT:s:='Q-0';
      _ID_EDIT_TABLE_REF_PARTICULES:s:='G-2';
      _ID_EDIT_TABLE_REF_PREFIXES:s:='G-2';
      _ID_EDIT_RACCOURCIS_SAISIE:s:='G-3';
      _ID_EMPLACEMENT_BDD:s:='R-0';
      _HELP_PB_BDD:s:='YA-2';
      _ID_RESTORE_BDD:s:='X-0';
      _ID_EDIT_TOKEN_DATE:s:='YA-1';
      _ID_SAISIE_RAPIDE:s:='F-0';
      _ID_INFOS_DOSSIER:s:='P-0';
      _ID_NOUVEAUX_INDI:s:='';
      _ID_NAVIGATEUR_INDI:s:='H-3';
      _ID_VILLES_FAVORIS:s:='F-1';
      else
        s:='';
    end;
    if s<>'' then
    begin
     {$IFDEF WINDOWS}
     fs_ExecuteProcess('hh',GetAppDir+_REL_PATH_HELP+_FileNameHelp+'::/'+s+'.htm');
     {$ELSE}
     {$IFDEF LINUX}
     fs_ExecuteProcess('chmsee',fs_getAppDir+_REL_PATH_HELP+_FileNameHelp+'::/'+s+'.htm');
     {$ENDIF}
     {$ENDIF}
    end;
  end;
end;

finalization

  _GDate.Free;
  _DateN.Free;
  _DateEv.Free;
  _DateTest.Free;
  _GedDateCoherence.Free;

  _MotsClesDate.Free;
end.

