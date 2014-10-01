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
{           Ancestrologie est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_objet_TGedcomDate;

interface

uses
  Classes,SysUtils,Dialogs,Math,Controls,DateUtils,
  u_objet_TMotsClesDate, u_common_const;

type

  { TGedcomDate }

  TGedcomDate=class
  private
    //date 1
    fUseDate1,
    fValidDateTime1:boolean;
    fType_Key1,
    fDay1,
    fMonth1,
    fYear1,
    fDateCode1:Integer;
    fDateTime1:TDateTime;
    fCalendrier1:TCalendrier;//calendrier dans lequel sont exprimés Year, Month, Day. Première date d'une période

    //date 2
    fUseDate2:boolean;
    fCalendrier2:TCalendrier;//calendrier dans lequel sont exprimés Year, Month, Day. Dernière date de la période

    //Dates Codes de comparaison
    fType_Key2,
    fDay2,
    fMonth2,
    fYear2,
    fDateCodeTot,
    fDateCodeTard:Integer;

    //Date format court avec l'année et les tokens symbolisés
    fDateCourte,
    fKey1,
    fKey2,
    fPhrase:string;

    PMotsClesDecode,
    PMotsClesEncode:TMotsClesDate;

    //vérification des parties d'une date
    function IsDay(s:string;var iDay:integer):boolean;
    function IsMonth(s:string;var iMonth:integer):boolean;
    function IsYear(s:string;var iYear:integer):boolean;

    //initialise le record GDate avant de le remplir
    procedure InitGDate;

    //calcul des Dates codées en integer
    procedure CalcDatesCodes;
    function EncodeGedcomDate:string;
    function EncodeHumanDate:string;

  public
    constructor Create;
    //date 1
    property UseDate1:boolean read fUseDate1;
    property ValidDateTime1:boolean read fValidDateTime1;
    property Key1:string read fKey1;
    property Type_Key1:Integer read fType_Key1;
    property Day1:integer read fDay1;
    property Month1:integer read fMonth1;
    property Year1:integer read fYear1;
    property DateCode1:Integer read fDateCode1;
    property DateTime1:TDateTime read fDateTime1;
    property Calendrier1:TCalendrier read fCalendrier1;//calendrier dans lequel sont exprimés Year, Month, Day. Première date d'une période

    //date 2
    property UseDate2:boolean read fUseDate2;
    property Key2:string read fKey2;
    property Type_Key2:Integer read fType_Key2;
    property Day2:integer read fDay2;
    property Month2:integer read fMonth2;
    property Year2:integer read fYear2;
    property Calendrier2:TCalendrier read fCalendrier2;//calendrier dans lequel sont exprimés Year, Month, Day. Dernière date de la période

    //Dates Codes de comparaison
    property DateCodeTot:Integer read fDateCodeTot;
    property DateCodeTard:Integer read fDateCodeTard;

    //Date format court avec l'année et les tokens symbolisés
    property DateCourte:string read fDateCourte;

    property Phrase:string read fPhrase;
    property GedcomDate:string read EncodeGedcomDate;
    property HumanDate:string read EncodeHumanDate;

    function DecodeHumanDate(line:string):boolean; virtual; overload;
    function DecodeHumanDate(const Year:Integer;const Month,Day,Type_Key:SmallInt;const Cal:TCalendrier):Boolean; virtual; overload;
    function DecodeHumanDate(const AYear1:Integer;const AMonth1,ADay1,AType_Key1:SmallInt;const Cal1:TCalendrier
  ;const AYear2:Integer;const AMonth2,ADay2,AType_Key2:SmallInt;const Cal2:TCalendrier):Boolean; overload; virtual;
    function DecodeGedcomDate(line:string):boolean; virtual;
    function MonthNum2MonthGedcom(const month:integer):string; virtual;
    procedure InitTGedcomDate(const MotsClesDecode,MotsClesEncode:TMotsClesDate); virtual;
  end;

implementation

uses
  u_common_functions,
  fonctions_string,
  u_gedcom_const,lazutf8classes,
  StrUtils;

const
  Mots_Ged:array[_TYPE_TOKEN_JANVIER.._TYPE_TOKEN_VERS] of string
    =('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'
      ,'FROM','TO','BEF','AFT','BET','AND','CAL','EST','ABT');

procedure TGedcomDate.InitTGedcomDate(const MotsClesDecode,MotsClesEncode:TMotsClesDate);
begin
  PMotsClesDecode:=MotsClesDecode;
  PMotsClesEncode:=MotsClesEncode;
end;

procedure TGedcomDate.InitGDate;
begin
  fPhrase:='';
  fKey1  :='';
  fKey2  :='';
  fDateCourte:='';

  fYear1:=_AnMini;
  fYear2:=_AnMini;

  fUseDate1:=false;
  fUseDate2:=false;

  fDay1:=-1;
  fDay2:=-1;

  fMonth1:=-1;
  fMonth2:=-1;

  fCalendrier1:=cGRE;
  fCalendrier2:=cGRE;

  fType_Key1:=-1;
  fType_Key2:=-1;

  fValidDateTime1:=false;
  fDateCode1:=-MaxInt;
  fDateCodeTot:=-MaxInt;
  fDateCodeTard:=3000000;
  fDateTime1:=0;
end;

function TGedcomDate.DecodeGedcomDate(line:string):boolean;//modifiée et corrigée MD 04/2009
  function GetNextToken(s:string;var token,NewS:string):boolean;
  var
    k:integer;
  begin
    result:=false;
    s:=trim(s);
    if s<>'' then
    begin
      k:=pos(' ',s);
      if k=0 then //pas d'autre espace
      begin
        Token:=s;
        NewS:='';
        result:=true;
      end
      else //soit plusieurs termes
      begin
        Token:=copy(s,1,k-1);
        NewS:=copy(s,k+1,length(s)-k);
        result:=true;
      end;
    end;
  end;

  function GetCalendrier(var line:string;var Cal:TCalendrier):Boolean;
  var
    token:string;
  begin
    Cal:=cGRE;
    if (copy(line,1,10)='@#DHEBREW@')or(copy(line,1,9)='@#DROMAN@')
      or(copy(line,1,12)='@#DFRENCH R@')or(copy(line,1,11)='@#DUNKNOWN@') then
    begin
      Result:=false;
      Exit;
    end;
    if (copy(line,1,10)='@#DJULIAN@') then
    begin
      token:='@#DJULIAN@';
      Cal:=cJUL;
    end
    else if (copy(line,1,13)='@#DGREGORIAN@') then
      token:='@#DGREGORIAN@'
    else
      token:='';

    if token>'' then
    begin
      delete(line,1,length(token));
      line:=TrimLeft(line);
    end;
    Result:=True;

    // En fait Roman et Unknown ne sont pas utilisés
    // Si Hebreu il faut verifier que la date est complete et la convertir Gregorien/Julien
    // si elle n'est pas complete --> Date_Phrase ??
    //if DATE_CALENDAR_ESCAPE='@#DHEBREW@' then
    //begin
       //fonction determineDateHebrew()
    //end;
    // Si Revolution il faut verifier que la date est complete et la convertir Gregorien
    // si elle n'est pas complete --> Date_Phrase ??
    //if DATE_CALENDAR_ESCAPE='@#DFRENCH R@' then
    //begin
      //fonction determineDateFrench()
    //end;
  end;

  function determineDate(line:string;var jour,mois,annee:integer;Cal:TCalendrier;
    var KnowFormatDateTime:boolean;var theDate:TDateTime;var NewS:string):boolean;
  var
    t1,t2,t3,t4:string;
    s1,s2,s3,S4:string;
  begin
    result:=false;
    KnowFormatDateTime:=false;
    t1:='';
    s1:='';
    t2:='';
    s2:='';
    t3:='';
    s3:='';
    t4:='';
    s4:='';

  //y-a-t'il au moins un terme ?
    if GetNextToken(line,t1,s1) then //AL t1 peut être jour, mois ou année
    begin
      if IsYear(t1,annee)or IsMonth(t1,mois)or IsDay(t1,jour) then
      begin
      //un autre ?
        if GetNextToken(s1,t2,s2) then //AL t2 peut être mois ou année ou B.C.
        begin
          if IsYear(t2,annee)or IsMonth(t2,mois)or(t2='B.C.') then
          begin
          //un autre terme ?
            if GetNextToken(s2,t3,s3) then //AL t3 doit être année ou B.C.
            begin
              if IsYear(t3,annee)or(t3='B.C.') then
              begin
              // un autre terme si date négative "B.C."
                if GetNextToken(s3,t4,s4) then //t4 doit être 'B.C.'
                begin
                  if t4<>'B.C.' then
                    t4:='';
                end;
              end
              else
              begin
                t3:='';
              end;
            end;
          end
          else
          begin
            t2:='';
          end;
        end;
      end
      else
      begin
        t1:='';
      end;
    end;
    jour:=-1;
    mois:=-1;
    annee:=_AnMini;

  //soit on connait 3 termes  (ajouté le 4ème pour traitement de B.C. MD)
    if t3<>'' then
    begin
      //t3 est une année ?
      if IsYear(t3,annee) then
      begin
        if IsMonth(t2,mois) then
        begin
          if isDay(t1,jour) then
          begin
            if t4='B.C.' then
            begin
              annee:=-annee;//la date est négative, convertible depuis R616
              NewS:=s4;
            end
            else
              NewS:=s3;
            Result:=_TryEncodeDate(annee,mois,jour,Cal,theDate);
            KnowFormatDateTime:=Result;
          end
          else
          begin
            result:=false;
            NewS:=s3;
          end;
        end
        else
        begin
          result:=false;
          NewS:=s3;
        end;
      end
      else if (t3='B.C.') then
        if (IsYear(t2,annee)) then
          if (IsMonth(t1,mois)) then
          begin
            result:=true;
            annee:=-annee;
            NewS:=S3;
          end
          else
          begin
            result:=false;
            NewS:=s3;
          end
        else
        begin
          result:=false;
          NewS:=s3;
        end
      else
      begin
        result:=false;
        NewS:=s3;
      end;
    end
    else if t2<>'' then
    begin
      //t2 est une année ?
      if IsYear(t2,annee) then
      begin
        if IsMonth(t1,mois) then
        begin
          result:=true;
          NewS:=s2;
        end
        else
        begin
          result:=false;
          NewS:=s2;
        end;
      end
      else if (t2='B.C.')and(IsYear(t1,annee)) then
      begin
        annee:=-annee;
        result:=true;
        NewS:=S2;
      end
      else
      begin
        result:=false;
        NewS:=s2;
      end;
    end
    else if t1<>'' then
    begin
      //c'est une année ?
      if IsYear(t1,annee) then
      begin
        result:=true;
        NewS:=s1;
      end
      else
      begin
        result:=false;
        NewS:=s1;
      end;
    end;
  end;

var
  token,newline:string;
  k:integer;
  Cle1:string;
  jour1,mois1,annee1:integer;
  KnowFormatDateTime1:boolean;
  theDate1:TDateTime;

  jour2,mois2,annee2:integer;
  KnowFormatDateTime2:boolean;
  theDate2:TDateTime;

  suite:boolean;
begin
  result:=false;

  InitGDate;
  //on recherche le premier terme
  line:=trim(line);
  Cle1:='';

  if line<>'' then
  begin
    //soit la date est inconnue, car sous forme de phrase
    if line[1]='(' then
    begin
      result:=true;
      fPhrase:=trim(copy(line,2,length(line)-2));
    end
    else
    begin
      //on cherche le premier terme
      if GetNextToken(line,token,NewLine) then
      begin
        token:=AnsiUpperCase(token);
        if (token='FROM')
          or(token='TO')
          or(token='BEF')
          or(token='AFT')
          or(token='BET')
          or(token='ABT')
          or(token='CAL')
          or(token='EST') then
        begin
          Cle1:=token;
          Line:=NewLine;
        end
        else if (token='INT') then
        begin
          //on se débarasse de la phrase qui doit se trouver à la fin
          k:=pos('(',newline);
          if k<>0 then
          begin
            fPhrase:=copy(newline,k+1,length(NewLine)-k-1);
            Line:=trim(copy(newline,1,k-1));
          end;
        end;

        //on ne peut convertir que si la date est en calendrier Gregorien ou Julien
        if GetCalendrier(line,fCalendrier1) then
        begin
          if determineDate(line,jour1,mois1,annee1,fCalendrier1,KnowFormatDateTime1,theDate1,NewLine)
            and((annee1<>0)or(fCalendrier1=cGRE)) then
          begin
            fUseDate1:=true;
            fDay1:=jour1;
            fMonth1:=mois1;
            fYear1:=annee1;
            fValidDateTime1:=KnowFormatDateTime1;
            fDateTime1:=theDate1;
            line:=NewLine;

            if Cle1='FROM' then
            begin
              suite:=false;
                          //on regarde si on trouve le mot-clef 'TO'
              if GetNextToken(line,token,NewLine) then
              begin
                if token='TO' then
                begin
                  line:=NewLine;
                  if GetCalendrier(line,fCalendrier2) then
                    if determineDate(line,jour2,mois2,annee2,fCalendrier2,KnowFormatDateTime2,theDate2,NewLine)
                      and((annee2<>0)or(fCalendrier2=cGRE)) then
                    begin
                      fUseDate2:=true;
                      fDay2:=jour2;
                      fMonth2:=mois2;
                      fYear2:=annee2;
                      fKey2:=token;
                      suite:=true;
                    end;
                end;
              end
              else //pas de problème : le 'TO' est facultatif
                suite:=true;
            end
            else if Cle1='BET' then
            begin
              suite:=false;
              //on regarde si on trouve le mot-clef 'AND'
              if GetNextToken(line,token,NewLine) then
              begin
                if token='AND' then
                begin
                  line:=NewLine;
                  if GetCalendrier(line,fCalendrier2) then
                    if determineDate(line,jour2,mois2,annee2,fCalendrier2,KnowFormatDateTime2,theDate2,NewLine)
                      and((annee2<>0)or(fCalendrier2=cGRE)) then
                    begin
                      fUseDate2:=true;
                      fDay2:=jour2;
                      fMonth2:=mois2;
                      fYear2:=annee2;
                      fKey2:=token;
                      suite:=true;
                    end;
                end;
              end;
            end
            else
              suite:=true;

            if suite then
            begin
              fKey1:=Cle1;
              result:=true;
            end;
          end;
        end;
      end;
      if Result then
        CalcDatesCodes;
    end;//ligne n'est pas une phrase
  end;
end;

function TGedcomDate.IsYear(s:string;var iYear:integer):boolean;
var
  s1,s2:string;
  p,i1,i2:integer;
begin
  //Si notation julienne 1725/26 ou 1725-1726 on garde la deuxième année (MD)
  //uniquement pour l'import GEDCOM (la décomposition de la date saisie ne le permet pas)
  Result:=False;
  p:=pos('/',s);
  if p>1 then //ne doit pas être au début
  begin
    s1:=copy(s,1,p-1);
    s2:=copy(s,p+1,length(s)-p);
    if TryStrToInt(s1,i1)and TryStrToInt(s2,i2) then
      if (i1+1)mod 100=i2 then
      begin
        iYear:=i1+1;
        Result:=True;
      end;
  end
  else
  begin
    p:=pos('-',s);
    if p>1 then //si est au début c'est une date avJC
    begin
      s1:=copy(s,1,p-1);
      s2:=copy(s,p+1,length(s)-p);
      if TryStrToInt(s1,i1)and TryStrToInt(s2,i2) then
        if i1+1=i2 then
        begin
          iYear:=i2;
          Result:=True;
        end;
    end
    else
    begin
      if p=length(s) then //signe - à la fin c'est une date avJC
        s:='-'+copy(s,1,length(s)-1);
      Result:=TryStrToInt(s,iYear);
    end;
  end;
  if Result then
    Result:=(iYear>_AnMini)and(iYear<_AnMaxi);
end;

function TGedcomDate.IsDay(s:string;var iDay:integer):boolean;
begin
  Result:=TryStrToInt(s,iDay);
  Result:=Result and(iDay>0)and(iDay<32);
end;

function TGedcomDate.DecodeHumanDate(const Year:Integer;const Month,Day,Type_Key:SmallInt;const Cal:TCalendrier):Boolean;
begin
  Result:=DecodeHumanDate(Year,Month,Day,Type_Key,Cal,_AnMini,0,0,0,cGRE);
end;

function TGedcomDate.DecodeHumanDate(const AYear1:Integer;const AMonth1,ADay1,AType_Key1:SmallInt;const Cal1:TCalendrier
  ;const AYear2:Integer;const AMonth2,ADay2,AType_Key2:SmallInt;const Cal2:TCalendrier):Boolean;

  function fKey(const type_key:SmallInt):string;
  begin
    if type_key in [_TYPE_TOKEN_DU.._TYPE_TOKEN_VERS]
      then Result:=Mots_Ged[type_key]
      else Result:='';
  end;
begin
  Result:=False;
  InitGDate;

  if (AYear1<=_AnMini+1)or(AYear1>_AnMaxi)or(AYear2<_AnMini)or(AYear2>_AnMaxi)
    or(not AMonth1 in [0..12])or(not AMonth2 in [0..12])or(not ADay1 in [0..31])or(not ADay2 in [0..31])
    or(not AType_Key1 in [0,_TYPE_TOKEN_DU.._TYPE_TOKEN_VERS])
    or(not AType_Key2 in [0,_TYPE_TOKEN_DU.._TYPE_TOKEN_VERS]) then
    exit;
  fCalendrier1:=Cal1;
  fCalendrier2:=Cal2;
  if (AYear1>_AnMini)and((AYear1<>0)or(Cal1<>cJUL)) then
  begin
    fUseDate1:=True;
    fYear1:=AYear1;
    if AMonth1=0 then
      fMonth1:=-1
    else
      fMonth1:=AMonth1;
    if ADay1=0 then
      fDay1:=-1
    else
      fDay1:=ADay1;
    if (AMonth1>0)and(ADay1>0) then
      fValidDateTime1:=_TryEncodeDate(AYear1,AMonth1,ADay1,Cal1,fDateTime1);
    if AType_Key1=0 then
      fType_Key1:=-1
    else
    begin
      fType_Key1:=AType_Key1;
      fKey1:=fKey(AType_Key1);
    end;
    if (AYear2>_AnMini)and((AYear2<>0)or(Cal2<>cJUL)) then
    begin
      fUseDate2:=True;
      fYear2:=AYear2;
      if AMonth2=0 then
        fMonth2:=-1
      else
        fMonth2:=AMonth2;
      if ADay2=0 then
        fDay2:=-1
      else
        fDay2:=ADay2;
      if AType_Key2=0 then
        fType_Key2:=-1
      else
      begin
        fType_Key2:=AType_Key2;
        fKey2:=fKey(AType_Key2);
      end;
    end;
    CalcDatesCodes;
    Result:=True;
  end;
end;

function TGedcomDate.DecodeHumanDate(line:string):boolean;

  function FindKeyToken(s:string;var token,NewS:string):boolean;
  var
    i:Integer;
    function FindKey(const list:TStrings):boolean;
    var
      n,k,p:integer;
    begin
      result:=false;
      k:=0;
      for n:=0 to list.count-1 do
      begin
        p:=length(list[n]);
        if copy(s,1,p+1)=list[n]+' ' then
        begin
          result:=true;
          if p>k then
          begin
            k:=p;
            token:=list[n];
          end;
        end;
      end;
      if result then
        delete(s,1,length(token));
    end;

  begin
    token:='';
    result:=False;
    for i:=_TYPE_TOKEN_DU to _TYPE_TOKEN_VERS do
    begin
      if FindKey(PMotsClesDecode.Token_mots_maj[i]) then
      begin
        token:=Mots_Ged[i];
        Result:=True;
        Break;
      end;
    end;
    NewS:=trim(s);
  end;

  function determineHumanDate(line:string;var jour,mois,annee:integer;var Cal:TCalendrier;
    var KnowFormatDateTime,ToSuit:boolean;
    var theDate:TDateTime;var NewS:string):boolean;

    function IsHumanMonth(s:string;var iMonth:integer):boolean;
    var
      i:integer;
      suite:boolean;
    begin
    //mois d'un calendrier grégorien
      result:=true;
      suite:=true;

      {on teste le mois sous forme de chiffres
      CR - Petite Modification pour éviter l'erreur du débogueur si ce n'est pas numérique }
      i:=StrToIntDef(s,0);
      if (i>0)and(i<13) then
      begin
        iMonth:=i;
        suite:=false;
      end;

      if suite then
      begin
        Result:=False;
        for i:=_TYPE_TOKEN_JANVIER to _TYPE_TOKEN_DECEMBRE do
        begin
          if PMotsClesDecode.Token_mots_maj[i].IndexOf(s)<>-1 then
          begin
            iMonth:=i;
            Result:=True;
            Break;
          end;
        end;
      end;
    end;

  var
    cont:boolean;
    k,i,l,PosMois:integer;
    t1,t2,t3,s,ordre:string;
  begin
    result:=false;
    KnowFormatDateTime:=false;
    ToSuit:=false;
    jour:=-1;
    mois:=-1;
    annee:=_AnMini;

    t1:='';
    t2:='';
    t3:='';

    //y-a-t'il au moins un terme ?
    //version AL2009 recodage pour détection des 3 parties de la date type PROC_DATE_WRITEN_UN
    NewS:=line;
    if length(line)=0 then exit;

    PosMois:=-1;
    i:=0;
    repeat
      inc(i);
      if i>1 then //on élimine les séparateurs en tête
        for k:=0 to PMotsClesDecode.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE].count-1 do
          while PMotsClesDecode.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][k]=LeftStr(line,1) do
          begin
            delete(line,1,1);
            Break;
          end;

      s:='';
      if (i<4)and(length(line)>0) then //voir si chaîne est un nombre
      begin
        if line[1]in ['(','-','0'..'9'] then
        begin
          s:=line[1];
          if s='(' then
            s:='-';
          delete(line,1,1);
          cont:=true;
          while (length(line)>0)and cont and(length(s)<8) do
          begin
            if line[1]in [')','0'..'9'] then
            begin
              if line[1]=')' then
              begin
                delete(line,1,1);
                cont:=false;
              end
              else
              begin
                s:=s+line[1];
                delete(line,1,1);
              end;
            end
            else
              cont:=false;
          end;
        end;
      end;//fin de chaîne est un nombre

      if s='' then //si ce n'est pas un nombre voir si c'est un nom de mois
      begin
        s:=line;
        for k:=0 to PMotsClesDecode.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE].count-1 do
        begin//on isole la chaîne. ' ' ajouté à Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE] car la chaîne peut se terminer par un séparateur ou un espace.
          l:=pos(PMotsClesDecode.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][k],s);
          if l>0 then
          begin
            s:=LeftStr(s,l-1);
          end;
        end;
        if i>1 then //voir si c'est julien
        begin
          if PMotsClesDecode.Token_Julien_maj.IndexOf(s)<>-1 then
          begin
            Cal:=cJUL;
            delete(line,1,length(s));
            s:='';
            i:=4;
          end;
        end;
        if (i<4)and(s>'')and IsHumanMonth(s,mois) then
        begin
          delete(line,1,length(s));
          s:=IntToStr(mois);
          PosMois:=i;
        end
        else
          s:='';
      end;//fin de voir si c'est un nom de mois
      if (s='-')or(s='(') then
      begin
        if i=1 then
          exit//erreur dans la ligne s'il est en tête
        else
        begin//on le supprime et on considère qu'il précède la dernière partie de la date
          ToSuit:=true;
          s:='';
          i:=4;
        end;
      end;
      case i of
        1:t1:=s;
        2:t2:=s;
        3:t3:=s;
      end;

    until (length(line)=0)or(i=4);
    NewS:=TrimLeft(line);
    //fin version AL2009

    //result:=false par défaut
    //soit on connait 3 termes  donc soit DMY t1t2t3 ou MDY t1t2t3 ou YMD t1t2t3
    if PosMois>0 then //PosMois>0 uniquement si le mois est exprimé en texte
    begin//si le mois n'existe pas aucun problème car seul t1=année n'est pas vide. L'ordre est indifférent.
      if sOrdreLIT='' then
        ordre:=PMotsClesDecode.Token_mots[_TYPE_TOKEN_ORDRE][0]//saisie LIT
      else
        ordre:=sOrdreLIT;
    end
    else //saisie NUM
    begin
      if sOrdreNUM='' then
        ordre:=PMotsClesDecode.Token_mots[_TYPE_TOKEN_ORDRE][1]
      else
        ordre:=sOrdreNUM;
    end;

    if (ordre='DMY') then
    begin
      if t3<>'' then //année, mois et jour doivent être valides
      begin
        if IsYear(t3,annee) then
        begin
          if ((Cal=cGRE)or(annee<>0))and IsHumanMonth(t2,mois)and((PosMois=-1)or(PosMois=2)) then
          begin
            if isDay(t1,jour) then
            begin
              Result:=_TryEncodeDate(annee,mois,jour,Cal,theDate);
              KnowFormatDateTime:=Result;
            end;
          end;
        end;
      end
      else if t2<>'' then
      begin
        //t2 est une année ?
        if IsYear(t2,annee) then
        begin
          if ((Cal=cGRE)or(annee<>0))and IsHumanMonth(t1,mois)and((PosMois=-1)or(PosMois=1)) then
            result:=true;
        end;
      end
      else if t1<>'' then
      begin
        //c'est une année ?
        if IsYear(t1,annee)and(PosMois=-1) then
          if (Cal=cGRE)or(annee<>0) then
            result:=true;
      end;
    end

    else if (ordre='MDY') then
    begin
      if t3<>'' then
      begin
        if IsYear(t3,annee) then
        begin
          if ((Cal=cGRE)or(annee<>0))and IsHumanMonth(t1,mois)and((PosMois=-1)or(PosMois=1)) then
          begin
            if isDay(t2,jour) then
            begin
              Result:=_TryEncodeDate(annee,mois,jour,Cal,theDate);
              KnowFormatDateTime:=Result;
            end;
          end;
        end;
      end
      else if t2<>'' then
      begin
        //t2 est une année ?
        if IsYear(t2,annee) then
        begin
          if ((Cal=cGRE)or(annee<>0))and IsHumanMonth(t1,mois)and((PosMois=-1)or(PosMois=1)) then
            result:=true;
        end;
      end
      else if t1<>'' then
      begin
        //c'est une année ?
        if IsYear(t1,annee)and(PosMois=-1) then
          if (Cal=cGRE)or(annee<>0) then
            result:=true;
      end;
    end

    else //YMD
    begin
      if t3<>'' then
      begin
        if IsYear(t1,annee) then
        begin
          if ((Cal=cGRE)or(annee<>0))and IsHumanMonth(t2,mois)and((PosMois=-1)or(PosMois=2)) then
          begin
            if isDay(t3,jour) then
            begin
              Result:=_TryEncodeDate(annee,mois,jour,Cal,theDate);
              KnowFormatDateTime:=Result;
            end;
          end;
        end;
      end
      else if t2<>'' then
      begin
        //t2 est une année ?
        if IsYear(t1,annee) then
          if ((Cal=cGRE)or(annee<>0))and IsHumanMonth(t2,mois)and((PosMois=-1)or(PosMois=2)) then
            result:=true;
      end
      else if t1<>'' then
      begin
        //c'est une année ?
        if IsYear(t1,annee)and(PosMois=-1) then
          if (Cal=cGRE)or(annee<>0) then
            result:=true;
      end;
    end;
  end;

var
  line0min:string;
  token:string;
  k:integer;
  Cle1:string;

  jour1,mois1,annee1:integer;
  KnowFormatDateTime1:boolean;
  theDate1:TDateTime;

  jour2,mois2,annee2:integer;
  KnowFormatDateTime2:boolean;
  theDate2:TDateTime;
  ToSuit:boolean;
  suite:boolean;
begin
  result:=false;
  InitGDate;
  //on recherche le premier terme
  line:=trim(line);
  repeat//on supprime les espaces en double
    k:=pos('  ',line);
    if k>0 then delete(line,k,1);
  until k=0;

  line0min:=line;
  line:=fs_FormatText(line,mftUpper,True);

  Cle1:='';

  if line<>'' then
  begin
    suite:=true;
      //on cherche le premier terme
  FindKeyToken(line,Cle1,Line);

      //on doit trouver une date
    if determineHumanDate(line,jour1,mois1,annee1,fCalendrier1,KnowFormatDateTime1,ToSuit,theDate1,Line) then
    begin
      fUseDate1:=true;
      fDay1:=jour1;
      fMonth1:=mois1;
      fYear1:=annee1;
      fValidDateTime1:=KnowFormatDateTime1;
      fDateTime1:=theDate1;

      if ToSuit then
      begin
        if Cle1='' then
          Cle1:='BET';
      end;

      if (Cle1='FROM') then //FROM
      begin
        suite:=false;
              //on regarde si on trouve le mot-clef 'TO'
        if FindKeyToken(line,token,Line)or ToSuit then
        begin
          if (token='')and Tosuit then
            token:='TO';
          if token='TO' then
          begin
            if determineHumanDate(line,jour2,mois2,annee2,fCalendrier2,KnowFormatDateTime2,ToSuit,theDate2,Line) then
            begin
              if (Line=''){//and(theDate2>theDate1)} then //la 2ième date doit être supérieure à la première
              begin
                fUseDate2:=true;
                fDay2:=jour2;
                fMonth2:=mois2;
                fYear2:=annee2;
                fKey2:='TO';
                suite:=true;
              end;
            end;
          end;
        end
        else
        begin
          //pas de problème : le 'TO' est facultatif
          if (Line='') then
            suite:=true;
        end;
      end
      else if (Cle1='BET') then //BET
      begin
        suite:=false;
        //on regarde si on trouve le mot-clef 'AND'
        if FindKeyToken(line,token,Line)or ToSuit then
        begin
          if (token='')and ToSuit then
            token:='AND';
          if token='AND' then
          begin
            if determineHumanDate(line,jour2,mois2,annee2,fCalendrier2,KnowFormatDateTime2,ToSuit,theDate2,Line) then
            begin//s'il ne reste rien
              if (Line=''){//and(theDate2>theDate1)} then
              begin
                fUseDate2:=true;
                fDay2:=jour2;
                fMonth2:=mois2;
                fYear2:=annee2;
                fKey2:='AND';
                suite:=true;
              end;
            end;
          end;
        end;
      end;

      if line<>'' then
        suite:=false;

      if suite then
      begin
        fKey1:=Cle1;
        result:=true;
      end;
    end;
  end;
  if result then
    CalcDatesCodes;
  Result:=Result and(fDateCodeTard>=fDateCodeTot);
  if not Result then
  begin
    InitGDate;
    fPhrase:=line0min;
  end;
end;

function TGedcomDate.IsMonth(s:string;var iMonth:integer):boolean;
var
  i:Integer;
begin
  //mois d'un calendrier grégorien ou julien
  Result:=False;
  i:=StrToIntDef(s,-1);
  if i in [_TYPE_TOKEN_JANVIER.._TYPE_TOKEN_DECEMBRE] then
  begin
    iMonth:=i;
    Result:=True;
    exit;
  end;
  s:=UpperCase(s);
  for i:=_TYPE_TOKEN_JANVIER to _TYPE_TOKEN_DECEMBRE do
  begin
    if Mots_Ged[i]=s then
    begin
      iMonth:=i;
      Result:=True;
      Break;
    end;
  end;
end;

function TGedcomDate.MonthNum2MonthGedcom(const month:integer):string;
begin
  if month in [_TYPE_TOKEN_JANVIER.._TYPE_TOKEN_DECEMBRE]
   then Result:=Mots_Ged[month]
   else Result:='';
end;

function TGedcomDate.EncodeGedcomDate:string;
  function AssembleGedcomDate(const Day,Month,Year:integer):string;
  var
    d,m,y:string;
  begin
    if Year<0 then
      y:=inttostr(Year*-1)+' B.C.'
    else
      y:=inttostr(Year);
    m:=MonthNum2MonthGedcom(Month);
    if Day<>-1 then
      d:=inttostr(Day)
    else
      d:='';
    result:=AssembleStringWithSep([d,m,y],' ');
  end;
var
  s1,s2:string;
begin
  result:='';
  s1:='';
  s2:='';
  //soit que du commentaire
  if (fUseDate1=false)and(fPhrase<>'') then
  begin
    result:='('+fPhrase+')';
  end
  else
  begin
    if (fUseDate1)and(fUseDate2) then
    begin
      if fCalendrier1=cJUL then
        s1:='@#DJULIAN@';
      if fCalendrier2=cJUL then
        s2:='@#DJULIAN@';
      Result:=AssembleStringWithSep([
        fKey1,s1,AssembleGedcomDate(fDay1,fMonth1,fYear1),
          fKey2,s2,AssembleGedcomDate(fDay2,fMonth2,fYear2)],
          ' ');
    end
    else if (fUseDate1) then
    begin
      if fCalendrier1=cJUL then
        s1:='@#DJULIAN@';
      Result:=AssembleStringWithSep([fKey1,s1,AssembleGedcomDate(fDay1,fMonth1,fYear1)],' ');
      if (fPhrase<>'')and(fKey1='') then
        Result:=AssembleStringWithSep(['INT',s1,'('+fPhrase+')'],' ');
    end;
  end;
end;

function TGedcomDate.EncodeHumanDate:string;
  function MonthNum2MonthHuman(month:integer):string;
  var
    s:TStringlistUTF8;
  begin
    if month in [_TYPE_TOKEN_JANVIER.._TYPE_TOKEN_DECEMBRE] then
      s:=PMotsClesEncode.Token_mots[month]
    else
      s:=nil;

    if s=nil then
      result:=''
    else
    begin
      if s.Count=0 then
        result:=''
      else
        result:=s[0];
    end;
  end;

  function GedcomKey2HumanKey(Ndate:integer):string;
  var
    s,t:TStringlistUTF8;
    key:string;
    jour,mois,i:integer;

    function Token(xst:string):string;
    var
      n:integer;
    begin
      n:=s.IndexOf(xst);
      if n>=0 then
        result:=t[n]
      else
        result:='';
    end;

  begin
    if Ndate=1 then
    begin
      key:=fKey1;
      jour:=fDay1;
      mois:=fMonth1;
    end
    else
    begin
      key:=fKey2;
      jour:=fDay2;
      mois:=fMonth2;
    end;

    result:='';
    t:=nil;
    for i:=_TYPE_TOKEN_DU to _TYPE_TOKEN_VERS do
    begin
      if Mots_Ged[i]=key then
      begin
        t:=PMotsClesEncode.Token_mots[i];
        s:=PMotsClesEncode.Token_mots_ST[i];
        Break;
      end;
    end;
    if t=nil then
      exit;

    if t.Count>0 then
    begin
      if ((key='FROM')or(key='TO'))and(not fUseDate2) then
      begin
        if jour>0 then
          result:=Token('D1');
        if result='' then
        begin
          if mois>0 then
            result:=Token('M1');
        end
        else
          exit;
        if result='' then
        begin
          result:=Token('Y1');
        end;
      end
      else
        result:='';

      if result='' then
      begin
        if jour>0 then
          result:=Token('D');
        if result='' then
        begin
          if mois>0 then
            result:=Token('M');
        end
        else
          exit;
        if result='' then
        begin
          result:=Token('Y');
        end
        else
          exit;
        if result='' then
          result:=t[0];
      end;
    end;
  end;

var
  s1,s2,sKey1,sKey2,d,m,y:string;
  OrdreDate:string;
begin
  if fPhrase='' then
  begin
    if PMotsClesEncode.Token_mots[_TYPE_TOKEN_FORME][0]='LIT'
      then OrdreDate:=PMotsClesEncode.Token_mots[_TYPE_TOKEN_ORDRE][0]
      else OrdreDate:=PMotsClesEncode.Token_mots[_TYPE_TOKEN_ORDRE][1];

    s1:='';
    sKey1:='';
    if fUseDate1 then
    begin
      d:='';
      m:='';
      y:='';

      if (fDay1<>-1) then
        if (fDay1<10)and(PMotsClesEncode.Token_mots[_TYPE_TOKEN_FORME][0]='NUM') then
          d:='0'+inttostr(fDay1)
        else
          d:=inttostr(fDay1);

      if (fMonth1<>-1) then
        if (PMotsClesEncode.Token_mots[_TYPE_TOKEN_FORME][0]='LIT') then
          m:=MonthNum2MonthHuman(fMonth1)
        else if (fMonth1<10) then
          m:='0'+inttostr(fMonth1)
        else
          m:=inttostr(fMonth1);

      y:=inttostr(fYear1);
      if PMotsClesEncode.Token_mots[_TYPE_TOKEN_FORME][0]='NUM' then
      begin
        if fYear1>=0 then
        begin
          if fYear1<10 then
            y:='000'+y
          else if fYear1<100 then
            y:='00'+y
          else if fYear1<1000 then
            y:='0'+y;
        end
        else //Year1<0
        begin
          delete(y,1,1);
          if fYear1>-10 then
            y:='-000'+y
          else if fYear1>-100 then
            y:='-00'+y
          else if fYear1>-1000 then
            y:='-0'+y
          else
            y:='-'+y;
        end;
      end;

      if fKey1<>'' then
        sKey1:=GedcomKey2HumanKey(1);

      if PMotsClesEncode.Token_mots[_TYPE_TOKEN_FORME][0]='LIT' then
      begin
        if (OrdreDate='DMY') then
          s1:=AssembleStringWithSep([sKey1,d,m,y],' ')
        else if (OrdreDate='MDY') then
          s1:=AssembleStringWithSep([sKey1,m,d,y],' ')
        else
          s1:=AssembleStringWithSep([sKey1,y,m,d],' ');
      end
      else
      begin//NUM
        if (OrdreDate='DMY') then
          s1:=AssembleStringWithSep([sKey1,AssembleStringWithSep([d,m,y]
            ,PMotsClesEncode.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][0])],' ')
        else if (OrdreDate='MDY') then
          s1:=AssembleStringWithSep([sKey1,AssembleStringWithSep([m,d,y]
            ,PMotsClesEncode.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][0])],' ')
        else
          s1:=AssembleStringWithSep([sKey1,AssembleStringWithSep([y,m,d]
            ,PMotsClesEncode.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][0])],' ');
      end;
      if fCalendrier1=cJUL then
        s1:=s1+' '+PMotsClesEncode.Token_mots[_TYPE_TOKEN_JULIEN][0];
    end;

    s2:='';
    sKey2:='';
    if fUseDate2 then
    begin
      d:='';
      m:='';
      y:='';

      if (fDay2<>-1) then
        if (fDay2<10)and(PMotsClesEncode.Token_mots[_TYPE_TOKEN_FORME][0]='NUM') then
          d:='0'+inttostr(fDay2)
        else
          d:=inttostr(fDay2);

      if (fMonth2<>-1) then
        if (PMotsClesEncode.Token_mots[_TYPE_TOKEN_FORME][0]='LIT') then
          m:=MonthNum2MonthHuman(fMonth2)
        else if (fMonth2<10) then
          m:='0'+inttostr(fMonth2)
        else
          m:=inttostr(fMonth2);

      y:=inttostr(fYear2);
      if PMotsClesEncode.Token_mots[_TYPE_TOKEN_FORME][0]='NUM' then
      begin
        if fYear2>=0 then //même s'il n'y  pas d'an 0
        begin
          if fYear2<10 then
            y:='000'+y
          else if fYear2<100 then
            y:='00'+y
          else if fYear2<1000 then
            y:='0'+y;
        end
        else //Year2<0
        begin
          y:=inttostr(-fYear2);
          if fYear2>-10 then
            y:='-000'+y
          else if fYear2>-100 then
            y:='-00'+y
          else if fYear2>-1000 then
            y:='-0'+y;
        end;
      end;

      if fKey2<>'' then
        sKey2:=GedcomKey2HumanKey(2);

      if PMotsClesEncode.Token_mots[_TYPE_TOKEN_FORME][0]='LIT' then
      begin
        if (OrdreDate='DMY') then
          s2:=AssembleStringWithSep([sKey2,d,m,y],' ')
        else if (OrdreDate='MDY') then
          s2:=AssembleStringWithSep([sKey2,m,d,y],' ')
        else
          s2:=AssembleStringWithSep([sKey2,y,m,d],' ');
      end
      else
      begin//NUM
        if (OrdreDate='DMY') then
          s2:=AssembleStringWithSep([sKey2,AssembleStringWithSep([d,m,y]
            ,PMotsClesEncode.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][0])],' ')
        else if (OrdreDate='MDY') then
          s2:=AssembleStringWithSep([sKey2,AssembleStringWithSep([m,d,y]
            ,PMotsClesEncode.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][0])],' ')
        else
          s2:=AssembleStringWithSep([sKey2,AssembleStringWithSep([y,m,d]
            ,PMotsClesEncode.Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE][0])],' ');
      end;
      if fCalendrier2=cJUL then
        s2:=s2+' '+PMotsClesEncode.Token_mots[_TYPE_TOKEN_JULIEN][0];
    end;
    Result:=AssembleStringWithSep([s1,s2],' ');
  end
  else
    result:=fPhrase;
end;

constructor TGedcomDate.Create;
begin
  inherited Create;
  InitGDate;
end;

procedure TGedcomDate.CalcDatesCodes;
  function Type_Token(Token:string):Integer;//donne le numéro du token comme il est mémorisé dans la base
  var
    i:Integer;
  begin
    Result:=-1;
    for i:=_TYPE_TOKEN_DU to _TYPE_TOKEN_VERS do
    begin
      if Mots_Ged[i]=Token then
      begin
        Result:=i;
        Break;
      end;
    end;
  end;

  function DefDateCodeToken(an,mois,jour,TypeToken:integer;Cal:TCalendrier
    ;var DateCode:Integer):Boolean;
  var
    mode,delta:Integer;
  begin
    case TypeToken of
      13,17:
        begin//depuis, entre
          mode:=1;
          delta:=0;
        end;
      14,18:
        begin//jusque, à, et
          mode:=2;
          delta:=0;
        end;
      15:
        begin//avant
          mode:=1;
          delta:=-1;
        end;
      16:
        begin//après
          mode:=2;
          delta:=1;
        end;
      else
        begin
          mode:=0;
          delta:=0;
        end;
    end;
    Result:=DefDateCode(an,mois,jour,Cal,mode,DateCode);
    if Result then
      DateCode:=DateCode+delta;
  end;

var
  b:boolean;
  DateCode:Integer;
  s:string;
begin
  if fUseDate1 then
  begin
    fType_Key1:=Type_Token(fKey1);
    b:=DefDateCodeToken(fYear1,fMonth1,fDay1,fType_Key1,fCalendrier1,DateCode);
    if b then
    begin
      fDateCode1:=DateCode;
      case fType_Key1 of
        -1://pas de mot-clé
          begin
            DefDateCode(fYear1,fMonth1,fDay1,fCalendrier1,1,fDateCodeTot);
            DefDateCode(fYear1,fMonth1,fDay1,fCalendrier1,2,fDateCodeTard);
          end;
        19://CAL
          begin
            DefDateCode(fYear1,fMonth1,fDay1,fCalendrier1,1,fDateCodeTot);
            DefDateCode(fYear1,fMonth1,fDay1,fCalendrier1,2,fDateCodeTard);
            if fMonth1<1 then
            begin
              fDateCodeTot:=fDateCodeTot-365;
              fDateCodeTard:=fDateCodeTard+365;
            end
            else if fDay1<1 then
            begin
              fDateCodeTot:=fDateCodeTot-31;
              fDateCodeTard:=fDateCodeTard+31;
            end;
          end;
        20://EST
          begin
            DefDateCode(fYear1,fMonth1,fDay1,fCalendrier1,1,fDateCodeTot);
            DefDateCode(fYear1,fMonth1,fDay1,fCalendrier1,2,fDateCodeTard);
            if fMonth1<1 then
            begin
              fDateCodeTot:=fDateCodeTot-5000;
              fDateCodeTard:=fDateCodeTard+5000;
            end
            else if fDay1<1 then
            begin
              fDateCodeTot:=fDateCodeTot-93;
              fDateCodeTard:=fDateCodeTard+93;
            end
            else
            begin
              fDateCodeTot:=fDateCodeTot-31;
              fDateCodeTard:=fDateCodeTard+31;
            end;
          end;
        21://ABT
          begin
            DefDateCode(fYear1,fMonth1,fDay1,fCalendrier1,1,fDateCodeTot);
            DefDateCode(fYear1,fMonth1,fDay1,fCalendrier1,2,fDateCodeTard);
            if fMonth1<1 then
            begin
              fDateCodeTot:=fDateCodeTot-1500;
              fDateCodeTard:=fDateCodeTard+1500;
            end
            else if fDay1<1 then
            begin
              fDateCodeTot:=fDateCodeTot-31;
              fDateCodeTard:=fDateCodeTard+31;
            end
            else
            begin
              fDateCodeTot:=fDateCodeTot-15;
              fDateCodeTard:=fDateCodeTard+15;
            end;
          end;
        13,16,17://depuis=FROM, après=AFT, entre=BET
          begin
            fDateCodeTot:=DateCode;
          end;
        14,15://jusque=TO, avant=BEF
          begin
            fDateCodeTard:=DateCode;
          end;
      end;
    end;
  end;
  if fUseDate2 then
  begin
    fType_Key2:=Type_Token(fKey2);
    b:=DefDateCodeToken(fYear2,fMonth2,fDay2,fType_Key2,fCalendrier2,DateCode);
    if b then
    begin
      fDateCodeTard:=DateCode;
    end;
  end;
  s:=IntToStr(fYear1);
  if fType_Key2 in [14,18] then
  begin
    fDateCourte:=s+'_'+IntToStr(fYear2);
  end
  else
  begin
    case fType_Key1 of
      16:fDateCourte:='>'+s;
      15:fDateCourte:='<'+s;
      19,20,21:fDateCourte:='~'+s;
      14:fDateCourte:=s+'<';
      13,17:fDateCourte:=s+'>';
      else
        fDateCourte:=s;
    end;
  end;
end;

end.
