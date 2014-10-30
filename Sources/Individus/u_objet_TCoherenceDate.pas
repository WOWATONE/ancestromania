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
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_objet_TCoherenceDate;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  contnrs,Forms,
  lazutf8classes,
  u_form_coherence;

type
  TInfoDate=class
  private
    fiDate:Integer;
    fiDateM:Integer;
    fKnowDate:boolean;
    fInfos:string;
    fID:integer;

  public
    constructor Create;
    procedure Reset;
    procedure SetDateWriten(s:string);
  end;

const
  _MAX_PB=19;

type
  TCoherenceDate=class

  private
    fFormIndividu:TForm;
    fFormCoherence:TFCoherence;
  public
    Sexe:integer;

    Naissance:TInfoDate;
    Deces:TInfoDate;
    AutresEventInd:TObjectList;
    Mariages:TObjectList;
    AutresEventUnion:TObjectList;
    NaissancesEnfants:TObjectList;

    ListEventNotTestedWithDeces:TStringlistUTF8;

    Pb:array[1.._MAX_PB] of boolean;

    property FormCoherence:TFCoherence {read fFormCoherence} write fFormCoherence;
    property FormIndividu:TForm {read fFormIndividu} write fFormIndividu;

    constructor Create;
    destructor Destroy; override;
    procedure Reset;
    procedure Test;

    procedure AddInfoDateWriten(dWriten,Infos:string;ID:integer;List:TObjectList);
  end;

implementation

uses
  u_common_const,
  u_common_functions,
  u_form_individu,
  u_form_main,
  u_genealogy_context,
  Math;

// TInfoDate

constructor TInfoDate.Create;
begin
  Reset;
end;

procedure TInfoDate.Reset;
begin
  fKnowDate:=false;
  fInfos:='';
  fID:=-1;
end;

procedure TInfoDate.SetDateWriten(s:string);
begin
  fKnowDate:=false;
  if _GedDateCoherence.DecodeHumanDate(s) then
   begin
     fKnowDate:=true;
    fiDate:=_GedDateCoherence.DateCodeTot;
    fiDateM:=_GedDateCoherence.DateCodeTard;
  end;
end;

{ TCoherenceDate }
procedure TCoherenceDate.AddInfoDateWriten(dWriten,Infos:string;ID:integer;List:TObjectList);
  function FindInfoDate:TInfoDate;
  var
    n:integer;
  begin
    result:=nil;
    for n:=0 to List.Count-1 do
    begin
      if TInfoDate(List[n]).fID=ID then
      begin
        result:=TInfoDate(List[n]);
        break;
      end;
    end;
  end;

var
  Find:boolean;
  aInfoDate:TInfoDate;
begin
  aInfoDate:=FindInfoDate;
  Find:=aInfoDate<>nil;
  if not Find then
  begin
    aInfoDate:=TInfoDate.create;
    aInfoDate.fID:=ID;
    List.Add(aInfoDate);
  end;
  aInfoDate.fInfos:=Infos;
  aInfoDate.SetDateWriten(dWriten);
end;

constructor TCoherenceDate.Create;
begin

  fFormCoherence:=nil;
  fFormIndividu:=nil;

  Naissance:=TInfoDate.create;
  Deces:=TInfoDate.create;
  AutresEventInd:=TObjectList.create(true);
  Mariages:=TObjectList.create(true);
  AutresEventUnion:=TObjectList.create(true);
  NaissancesEnfants:=TObjectList.create(true);

  ListEventNotTestedWithDeces:=TStringlistUTF8.create;
  ListEventNotTestedWithDeces.Add('INHU');
  ListEventNotTestedWithDeces.Add('TITL');
  ListEventNotTestedWithDeces.Add('ANUL');
  ListEventNotTestedWithDeces.Add('BENE');
  ListEventNotTestedWithDeces.Add('BLES');
  ListEventNotTestedWithDeces.Add('BURI');
  ListEventNotTestedWithDeces.Add('CREM');
  ListEventNotTestedWithDeces.Add('DECO');
  ListEventNotTestedWithDeces.Add('DIV');

  Reset;
end;

destructor TCoherenceDate.Destroy;
begin
  Naissance.free;
  Deces.free;
  AutresEventInd.free;
  Mariages.free;
  AutresEventUnion.free;
  NaissancesEnfants.free;
  ListEventNotTestedWithDeces.free;

  inherited;
end;

procedure TCoherenceDate.Reset;
begin
  Naissance.Reset;
  Deces.Reset;
  AutresEventInd.Clear;
  Mariages.Clear;
  AutresEventUnion.Clear;
  NaissancesEnfants.Clear;
  if fFormCoherence<>nil then
    fFormCoherence.Hide;
end;

procedure TCoherenceDate.Test;
  function MinDate(List:TObjectList;var aDate:Integer;Maximize:boolean):boolean;
  var
    n:integer;
  begin
    result:=false;
    for n:=0 to List.Count-1 do
    begin
      if TInfoDate(List[n]).fKnowDate then
      begin
        if result=false then
        begin
          if Maximize then
            aDate:=TInfoDate(List[n]).fiDateM
          else
            aDate:=TInfoDate(List[n]).fiDate;
          result:=true;
        end
        else
        begin
          if Maximize then
          begin
            if aDate>TInfoDate(List[n]).fiDateM then
              aDate:=TInfoDate(List[n]).fiDateM;
          end
          else
          begin
            if aDate>TInfoDate(List[n]).fiDate then
              aDate:=TInfoDate(List[n]).fiDate;
          end;
        end;
      end;
    end;
  end;

  function MaxDate(List:TObjectList;var aDate:Integer;Maximize:boolean):boolean;
  var
    n:integer;
  begin
    result:=false;
    for n:=0 to List.Count-1 do
    begin
      if TInfoDate(List[n]).fKnowDate then
      begin
        if result=false then
        begin
          if Maximize then
            aDate:=TInfoDate(List[n]).fiDateM
          else
            aDate:=TInfoDate(List[n]).fiDate;
          result:=true;
        end
        else
        begin
          if Maximize then
          begin
            if aDate<TInfoDate(List[n]).fiDateM then
              aDate:=TInfoDate(List[n]).fiDateM;
          end
          else
          begin
            if aDate<TInfoDate(List[n]).fiDate then
              aDate:=TInfoDate(List[n]).fiDate;
          end;
        end;
      end;
    end;
  end;

var
  n,i,j:integer;
  d:Integer;
  fShouldShowInfos:boolean;
begin
  if fFormCoherence<>nil then
    fFormCoherence.Hide;
  for n:=1 to _MAX_PB do
    Pb[n]:=false;

  if gci_context.CoherenceActive then
  begin
    //né avant décès
    if Naissance.fKnowDate and Deces.fKnowDate then
    begin
      if Naissance.fiDate>Deces.fiDateM then
        if Sexe=2 then
          Pb[2]:=true
        else
          Pb[1]:=true;
    end;

    //Espérance de vie
    if gci_context.CheckEsperanceVie then
    begin
      if Naissance.fKnowDate and Deces.fKnowDate then
      begin
        if Sexe=2 then
          Pb[4]:=Deces.fiDate>Naissance.fiDateM+trunc(gci_context.AgeMaxiAuDecesFemmes*365.25)
        else
          Pb[3]:=Deces.fiDate>Naissance.fiDateM+trunc(gci_context.AgeMaxiAuDecesHommes*365.25);
      end;
    end;

    //Age minimum pour se marier
    if gci_context.CheckAgeMiniMariage then
    begin
      if Naissance.fKnowDate then
      begin
        if MinDate(Mariages,d,true) then
        begin
          if Sexe=1 then
            Pb[5]:=d<Naissance.fiDate+trunc(gci_context.AgeMiniMariageHommes*365.25)
          else if Sexe=2 then
            Pb[6]:=d<Naissance.fiDate+trunc(gci_context.AgeMiniMariageFemmes*365.25);
        end;
      end;
    end;

    //Age maximum pour se marier
    if gci_context.CheckAgeMaxiMariage then
    begin
      if Naissance.fKnowDate then
      begin
        if MaxDate(Mariages,d,false) then
        begin
          if Sexe=1 then
            Pb[7]:=d>Naissance.fiDateM+trunc(gci_context.AgeMaxiMariageHommes*365.25)
          else if Sexe=2 then
            Pb[8]:=d>Naissance.fiDateM+trunc(gci_context.AgeMaxiMariageFemmes*365.25);
        end;
      end;
    end;

    //Age minimum pour avoir un enfant
    if gci_context.CheckAgeMiniNaissanceEnfant then
    begin
      if Naissance.fKnowDate then
      begin
        if MinDate(NaissancesEnfants,d,true) then
        begin
          if Sexe=1 then
            Pb[9]:=d<Naissance.fiDate+trunc(gci_context.AgeMiniNaissanceEnfantHommes*365.25)
          else if Sexe=2 then
            Pb[10]:=d<Naissance.fiDate+trunc(gci_context.AgeMiniNaissanceEnfantFemmes*365.25);
        end;
      end;
    end;

    if MaxDate(NaissancesEnfants,d,false) then
    begin
      //Age maximum pour avoir un enfant
      if gci_context.CheckAgeMaxiNaissanceEnfant then
      begin
        if Naissance.fKnowDate then
        begin
          if Sexe=1 then
            Pb[11]:=d>Naissance.fiDateM+trunc(gci_context.AgeMaxiNaissanceEnfantHommes*365.25)
          else if Sexe=2 then
            Pb[12]:=d>Naissance.fiDateM+trunc(gci_context.AgeMaxiNaissanceEnfantFemmes*365.25);
        end;
      end;
      if Deces.fKnowDate then //enfant né après le décès
      begin
        if Sexe=1 then
          Pb[18]:=d>Deces.fiDateM+270
        else if Sexe=2 then
          Pb[19]:=d>Deces.fiDateM;
      end;
    end;

    //on teste tous les autres événements individuels
    for n:=0 to AutresEventInd.Count-1 do
    begin
      if TInfoDate(AutresEventInd[n]).fKnowDate then
      begin
        //On teste par rapport à la naissance
        if not Pb[13]and Naissance.fKnowDate then
        begin
          if TInfoDate(AutresEventInd[n]).fiDateM<Naissance.fiDate then
          begin
            Pb[13]:=True;
          end;
        end;
        //On teste par rapport au décès
        if not Pb[14]and(ListEventNotTestedWithDeces.IndexOf(TInfoDate(AutresEventInd[n]).fInfos)=-1) then
        begin
          if Deces.fKnowDate then
          begin
            if TInfoDate(AutresEventInd[n]).fiDate>Deces.fiDateM then
            begin
              Pb[14]:=True;
            end;
          end;
        end;
      end;
    end;

    //on teste tous les autres événements de l'union
    for n:=0 to AutresEventUnion.Count-1 do
    begin
      if TInfoDate(AutresEventUnion[n]).fKnowDate then
      begin
        //On teste par rapport à la naissance
        if not Pb[15]and Naissance.fKnowDate then
        begin
          if TInfoDate(AutresEventUnion[n]).fiDateM<Naissance.fiDate then
          begin
            Pb[15]:=True;
          end;
        end;

        //On teste par rapport au décès
        if not Pb[16]and(ListEventNotTestedWithDeces.IndexOf(TInfoDate(AutresEventUnion[n]).fInfos)=-1) then
        begin
          if Deces.fKnowDate then
          begin
            if TInfoDate(AutresEventUnion[n]).fiDate>Deces.fiDateM then
            begin
              Pb[16]:=True;
            end;
          end;
        end;
      end;
    end;

    if (Sexe=2) and gci_context.CheckNbJourEntreNaissance then
    begin
      for n:=0 to NaissancesEnfants.Count-1 do
      begin
        if TInfoDate(NaissancesEnfants[n]).fKnowDate then
        begin
          for i:=n+1 to NaissancesEnfants.Count-1 do
          begin
            if TInfoDate(NaissancesEnfants[i]).fKnowDate then
            begin
              j:=Trunc(Max(
                 IfThen(TInfoDate(NaissancesEnfants[i]).fiDate=-MaxInt,MaxInt
                        ,IfThen((TInfoDate(NaissancesEnfants[n]).fiDateM-TInfoDate(NaissancesEnfants[i]).fiDate)>0
                        ,TInfoDate(NaissancesEnfants[n]).fiDateM-TInfoDate(NaissancesEnfants[i]).fiDate,-MaxInt))
                ,IfThen(TInfoDate(NaissancesEnfants[n]).fiDate=-MaxInt,MaxInt
                      ,IfThen((TInfoDate(NaissancesEnfants[i]).fiDateM-TInfoDate(NaissancesEnfants[n]).fiDate)>0
                      ,TInfoDate(NaissancesEnfants[i]).fiDateM-TInfoDate(NaissancesEnfants[n]).fiDate,-MaxInt))
                ));
              if (j>-MaxInt) and
                (j<gci_context.NbJourEntre2NaissancesNormales)and(j>gci_context.NbJourEntre2NaissancesJumeaux) then
              begin
                Pb[17]:=true;
                Break;
              end;
            end;
          end;
          if Pb[17]=true then
            Break;
        end;
      end;
    end;
  end;

  fShouldShowInfos:=false;
  for n:=1 to _MAX_PB do
    if Pb[n] then
    begin
      fShouldShowInfos:=true;
      Break;
    end;

  if fShouldShowInfos then
  begin
    if fFormIndividu<>nil then
    begin
      if (fFormCoherence<>nil)
        and((TFIndividu(fFormindividu).QueryIndividuIND_CONFIDENTIEL.AsInteger and _i_SansCtrlDates)<>_i_SansCtrlDates) then
      begin
        if TFIndividu(fFormindividu).DialogMode then
        begin
          if fFormCoherence.Monitor<>fFormindividu.Monitor then
            CentreLaFiche(fFormCoherence,fFormindividu);
        end
        else
        begin
          if fFormCoherence.Monitor<>FMain.Monitor then
            CentreLaFiche(fFormCoherence,FMain);
        end;

        fFormCoherence.Refresh;
        fFormCoherence.Show;
        fFormCoherence.BringToFront;
      end;
      TFIndividu(fFormIndividu).btnPbCoherence.visible:=true;
    end;
  end
  else
  begin
    if fFormIndividu<>nil then
      TFIndividu(fFormIndividu).btnPbCoherence.visible:=false;
  end;
end;

end.

