unit u_calendriers_gregorien;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses SysUtils,Dialogs;

procedure julien;
procedure julienj;
procedure JCOPTE;
procedure COPTEJ;
procedure JMUSUL;
procedure MUSULJ;
procedure JISR;
procedure ISRJ;
procedure jjdatej;
procedure jjdate;
procedure bisg;
procedure bisr;
procedure BISJ;
procedure BISC;
procedure BISM;
procedure BISI;
function debanr(an:integer):real;
function DEBANJ(an:integer):real;
procedure jrepu;
procedure repuj;
procedure nomjour;
procedure nbjrs;
procedure nbjrsj;
procedure nbjrsm;
procedure nbjrsc;
procedure nbjrsr;
procedure affcc;
procedure calculerGregorien;
procedure calculerJulien;
procedure calculerRepublicain;
procedure calculerIsraelien;
procedure calculerMusulman;
procedure calculerCopte;

type
  TDateCal=record
    jour,mois,an,
    jourGre,moisGre,anGre,
    jourJul,moisJul,anJul,
    jourRep,moisRep,anRep,
    jourMus,moisMus,anMus,
    jourIsr,moisIsr,anIsr,
    jourCop,moisCop,anCop,
    nbmois,
    typea,
    typeai,//AL pour identifier une année israélite à 13 mois
    nbjrs,
    code6,
    jsem,
    anc,
    espea:integer;

    cycle,
    jjd:real;

    valeurGre,
    valeurJul,
    valeurRep,
    valeurMus,
    valeurIsr,
    valeurCop,
    erreur:string;
end;

var
  dateCal:TDateCal;

const
  lmoisr:array[0..13] of string=('null','vendémiaire','brumaire','frimaire','nivôse',
    'pluviôse','ventôse','germinal',
    'floréal','prairial','messidor','thermidor',
    'fructidor','sanculottides');

  lmoisc:array[0..13] of string=('null','Tout','Babah','Hâtour','Keihak','Toubah',
    'Amchir','Barmahat','Barmoudah','Bachnas',
    'Bou''nah','Abib','Masari','Jours épagomènes');

  lmoism:array[0..12] of string=('null','Mouharram','Safar','Rabi''-oul-Aououal',
    'Rabi''-out-Tani','Djoumada-l-Oula','Djoumada-t-Tania',
    'Radjab','Cha''ban','Ramadan','Chaououal',
    'Dou-l-Qa''da','Dou-l-Hidjja');

  lmoisie:array[0..13] of string=('null','Tisseri','Hesvan','Kislev','Tébeth',
    'Schébat','Adar','Véadar','Nissan','Iyar','Sivan',
    'Tamouz','Ab','Elloul');

  CstPasEnUsage=' -- pas en usage à cette date --';

implementation

uses Math;

procedure julien;
var
  D,M,Y:integer;
  A:real;
begin
  D:=dateCal.jour;
  Y:=dateCal.an;
  M:=dateCal.mois;
  A:=Y+M/100+D/10000;
  if (dateCal.mois<=2) then
  begin
    Y:=Y-1;
    M:=M+12;
  end;
  if (Y<0) then
    dateCal.jjd:=Ceil(365.25*Y-0.75)
  else
    dateCal.jjd:=Floor(365.25*Y);
  dateCal.jjd:=dateCal.jjd+Trunc(30.6001*(M+1))+D+1720994.5;
  if A>1582.1014 then
    dateCal.jjd:=dateCal.jjd+2-Trunc(Y/100)+Trunc(Trunc(Y/100)/4);
end;

procedure JULIENJ();
var
  D,M,Y:integer;
begin
  D:=dateCal.JOUR;
  Y:=dateCal.AN;
  M:=dateCal.MOIS;
  if (dateCal.MOIS<=2) then
  begin
    Y:=Y-1;
    M:=M+12;
  end;
  if (Y<0) then
    dateCal.JJD:=Ceil(365.25*Y-0.75)
  else
    dateCal.JJD:=Floor(365.25*Y);
  dateCal.JJD:=dateCal.JJD+Trunc(30.6001*(M+1))+D+1720994.5;
end;

procedure JCOPTE();
const
  BORNE:array[0..4] of integer=(0,365,730,1096,1461);
var
  dt,aan,dj:real;
  i,jan:integer;
begin
  DT:=dateCal.JJD-1825029.5;
  AAN:=DT/1461;
  dateCal.AN:=Trunc(AAN);
  DT:=DT-(Floor(AAN)*1461)+1;
  dateCal.AN:=dateCal.AN*4;
  jan:=0;
  for I:=0 to 3 do
  begin
    if ((BORNE[I]<DT)and(DT<=BORNE[I+1])) then
    begin
      JAN:=I+1;
      DT:=DT-BORNE[I];
    end;
  end;
  dateCal.AN:=dateCal.AN+JAN;
  if (JAN=3) then
    dateCal.TYPEA:=1
  else
    dateCal.TYPEA:=0;
  DJ:=(DT-1)/30;
  dateCal.MOIS:=Trunc(DJ)+1;
  dateCal.JOUR:=Trunc(DT-(Trunc(DJ)*30));
end;

procedure COPTEJ;
var
  dan,jan:integer;
begin
  JAN:=Trunc((dateCal.AN-1)/4);
  dateCal.JJD:=JAN*1461;
  DAN:=dateCal.AN-(JAN*4);
  dateCal.JJD:=1825028.5+dateCal.JJD+(DAN-1)*365+30*(dateCal.MOIS-1)+dateCal.JOUR;
  if DAN=4 then
    dateCal.JJD:=dateCal.JJD+1;
end;

procedure JMUSUL();
const
  BORNE:array[0..30] of integer=(0,354,709,1063,1417,1772,2126,
    2481,2835,3189,3544,3898,4252,4607,4961,5315,5670,6024,6379,
    6733,7087,7442,7796,8150,8505,8859,9214,9568,9922,10277,10631);
  CMOIS:array[0..12] of integer=(0,30,59,89,118,148,177,
    207,236,266,295,325,354);
var
  i,ndt,jan:integer;
  dt:real;
  BMOIS:array[0..12] of integer;
begin
  for I:=0 to 12 do
  begin
    BMOIS[I]:=CMOIS[I];
  end;
  DT:=dateCal.JJD-1948438.5;
  NDT:=Trunc(DT/10631);
  dateCal.AN:=NDT*30;
  dateCal.CYCLE:=NDT+1;
  DT:=DT-NDT*10631;
  jan:=0;
  if (DT=0) then
  begin
    dateCal.ANC:=30;
    dateCal.CYCLE:=NDT;
  end
  else
  begin
    for I:=0 to 29 do
    begin
      if ((BORNE[I]<DT)and(DT<=BORNE[I+1])) then
      begin
        JAN:=I+1;
        dateCal.ANC:=JAN;
        DT:=DT-BORNE[I];
      end;
    end;
  end;
  dateCal.AN:=dateCal.AN+JAN;
  if ((dateCal.ANC=2)or(dateCal.ANC=5)or(dateCal.ANC=7)or(dateCal.ANC=10)or
    (dateCal.ANC=13)or(dateCal.ANC=16)or(dateCal.ANC=18)or(dateCal.ANC=21)or
    (dateCal.ANC=24)or(dateCal.ANC=26)or(dateCal.ANC=29)) then
  begin
    dateCal.TYPEA:=1;
    BMOIS[12]:=355;
  end
  else
    dateCal.TYPEA:=0;
  if (DT=0) then
  begin
    dateCal.MOIS:=12;
    dateCal.JOUR:=29;
  end
  else
  begin
    for I:=0 to 11 do
    begin
      if ((BMOIS[I]<DT)and(DT<=BMOIS[I+1])) then
      begin
        dateCal.MOIS:=I+1;
        dateCal.JOUR:=Trunc(DT)-BMOIS[I];
      end;
    end;
  end;
end;

procedure MUSULJ;
const
  BORNE:array[0..30] of integer=(0,354,709,1063,1417,1772,2126,
    2481,2835,3189,3544,3898,4252,4607,4961,5315,5670,6024,6379,
    6733,7087,7442,7796,8150,8505,8859,9214,9568,9922,10277,10631);
  CMOIS:array[0..12] of integer=(0,30,59,89,118,148,177,
    207,236,266,295,325,354);
var
  BMOIS:array[0..12] of integer;
  i,jan:integer;
  dt:real;
begin
  for I:=0 to 12 do
    BMOIS[I]:=CMOIS[I];
  DT:=(dateCal.AN-1)/30;
  dateCal.CYCLE:=Trunc(DT)+1;
  dateCal.ANC:=dateCal.AN-Trunc(DT)*30;
  DT:=Trunc(DT);
  JAN:=Trunc(DT);
  dateCal.JJD:=Trunc(DT*10631);
  JAN:=dateCal.AN-JAN*30;
  if ((JAN=2)or(JAN=5)or(JAN=7)or(JAN=10)or
    (JAN=13)or(JAN=16)or(JAN=18)or(JAN=21)or
    (JAN=24)or(JAN=26)or(JAN=29)) then
  begin
    dateCal.TYPEA:=1;
    BMOIS[12]:=355;
  end
  else
    dateCal.TYPEA:=0;
  dateCal.JJD:=dateCal.JJD+BORNE[JAN-1]+BMOIS[dateCal.MOIS-1]+dateCal.JOUR+1948438.5;
end;

procedure JISR();
const
  MOISC:array[0..35] of integer=(
    1,31,60,89,118,148,177,207,236,266,295,325,
    1,31,60,90,119,149,178,208,237,267,296,326,
    1,31,61,91,120,150,179,209,238,268,297,327);
  MOISE:array[0..38] of integer=(
    1,31,60,89,118,148,178,207,237,266,296,325,355,
    1,31,60,90,119,149,179,208,238,267,297,326,356,
    1,31,61,91,120,150,180,209,239,268,298,327,357);
var
  Z1,jjd1,jjdeb,dt:real;
  Z,AA,AAN,B,C,D,E,ALPHA,type1,argc,arge,a,i:integer;
begin
  Z1:=dateCal.JJD+0.5;
  Z:=Trunc(Z1);
  if Z<2299161 then
    AA:=Z
  else
  begin
    ALPHA:=Trunc((Z-1867216.25)/36524.25);
    AA:=Z+1+ALPHA-Trunc(ALPHA/4);
  end;
  B:=AA+1524;
  C:=Trunc((B-122.1)/365.25);
  D:=Trunc(365.25*C);
  E:=Trunc((B-D)/30.6001);
  dateCal.JOUR:=B-D-Trunc(30.6001*E);
  if E<14 then
    dateCal.MOIS:=E-1
  else
    dateCal.MOIS:=E-13;
  if dateCal.MOIS>=3 then
    dateCal.AN:=C-4716
  else
    dateCal.AN:=C-4715;
  AAN:=dateCal.AN+3761;
  JJD1:=DEBANJ(AAN);
  if (dateCal.JJD<JJD1) then
  begin
    dateCal.AN:=AAN-1;
    JJDEB:=DEBANJ(dateCal.AN);
  end
  else
  begin
    dateCal.AN:=AAN;
    JJDEB:=JJD1;
    AAN:=AAN+1;
    JJD1:=DEBANJ(AAN);
  end;
  dateCal.CYCLE:=(dateCal.AN-1)/19+1;
  dateCal.ANC:=1+(dateCal.AN-1)mod 19;
  AA:=dateCal.AN;
  AA:=12*AA+5;
  A:=AA mod 19;
  if (A>6) then
  begin
    TYPE1:=0;
    dateCal.TYPEA:=0;
  end
  else
  begin
    TYPE1:=1;
    dateCal.TYPEA:=1;
  end;
  DT:=JJD1-JJDEB;
  if TYPE1=1 then
    dateCal.ESPEA:=Round(DT-382)
  else
    dateCal.ESPEA:=Round(DT-352);
  DT:=dateCal.JJD-JJDEB+1;
  ARGC:=12*(dateCal.ESPEA-1);
  ARGE:=13*(dateCal.ESPEA-1);
  if TYPE1=1 then
  begin
    if DT>=MOISE[ARGE+12] then
    begin
      dateCal.MOIS:=13;
      dateCal.JOUR:=Round(DT)-MOISE[ARGE+12]+1;
    end
    else
      for I:=0 to 11 do
      begin
        if (DT>=MOISE[ARGE+I])and(DT<MOISE[ARGE+I+1]) then
        begin
          dateCal.JOUR:=Round(DT)-MOISE[ARGE+I]+1;
          dateCal.MOIS:=I+1;
        end;
      end;
  end
  else
  begin
    if DT>=MOISC[ARGC+11] then
    begin
      dateCal.MOIS:=12;
      dateCal.JOUR:=Round(DT)-MOISC[ARGC+11]+1;
    end
    else
      for I:=0 to 10 do
      begin
        if (DT>=MOISC[ARGC+I])and(DT<MOISC[ARGC+I+1]) then
        begin
          dateCal.MOIS:=I+1;
          dateCal.JOUR:=Round(DT)-MOISC[ARGC+I]+1;
        end;
      end;
  end;
  dateCal.typeai:=dateCal.typea;
end;

procedure ISRJ;
const
  MOISC:array[0..35] of integer=(
    1,31,60,89,118,148,177,207,236,266,295,325,
    1,31,60,90,119,149,178,208,237,267,296,326,
    1,31,61,91,120,150,179,209,238,268,297,327);
  MOISE:array[0..38] of integer=(
    1,31,60,89,118,148,178,207,237,266,296,325,355,
    1,31,60,90,119,149,179,208,238,267,297,326,356,
    1,31,61,91,120,150,180,209,239,268,298,327,357);
var
  jjd,jjd1,dt:real;
  AA,a:integer;
begin
  dateCal.CYCLE:=(dateCal.AN-1)/19+1;
  dateCal.ANC:=1+(dateCal.AN-1)mod 19;
  AA:=dateCal.AN;
  AA:=12*AA+5;
  A:=AA mod 19;
  jjd1:=DEBANJ(dateCal.AN+1);
  jjd:=DEBANJ(dateCal.AN);
  DT:=jjd1-jjd;
  if A<=6 then
  begin
    dateCal.ESPEA:=Trunc(DT-382);
    dateCal.JJD:=jjd+MOISE[13*(dateCal.ESPEA-1)+(dateCal.MOIS-1)]-2+dateCal.JOUR;
    dateCal.NBMOIS:=13;
    dateCal.TYPEA:=1;
  end
  else
  begin
    dateCal.ESPEA:=Trunc(DT-352);
    if dateCal.mois<7 then
      dateCal.JJD:=jjd+MOISC[12*(dateCal.ESPEA-1)+dateCal.MOIS-1]-2+dateCal.JOUR
    else
      dateCal.JJD:=jjd+MOISC[12*(dateCal.ESPEA-1)+dateCal.MOIS-2]-2+dateCal.JOUR;
    dateCal.NBMOIS:=12;
    dateCal.TYPEA:=0;
  end;
  dateCal.typeai:=dateCal.typea;
end;

procedure jjdatej;
var
  Z1:real;
  Z,A,B,C,D,E:integer;
begin
  Z1:=dateCal.jjd+0.5;
  Z:=Trunc(Z1);
  A:=Z;
  B:=A+1524;
  C:=Trunc((B-122.1)/365.25);
  D:=Trunc(365.25*C);
  E:=Trunc((B-D)/30.6001);
  dateCal.jour:=B-D-Trunc(30.6001*E);
  if E<14 then
    dateCal.mois:=E-1
  else
    dateCal.mois:=E-13;
  if dateCal.mois>=3 then
    dateCal.an:=C-4716
  else
    dateCal.an:=C-4715;
end;

procedure jjdate;
var
  Z1:real;
  Z,A,B,C,D,E,ALPHA:integer;
begin
  Z1:=dateCal.jjd+0.5;
  Z:=Trunc(Z1);
  if (Z<2299161) then
    A:=Z
  else
  begin
    ALPHA:=Trunc((Z-1867216.25)/36524.25);
    A:=Z+1+ALPHA-Trunc(ALPHA/4);
  end;
  B:=A+1524;
  C:=Trunc((B-122.1)/365.25);
  D:=Trunc(365.25*C);
  E:=Trunc((B-D)/30.6001);
  dateCal.jour:=B-D-Trunc(30.6001*E);
  if E<14 then
    dateCal.mois:=E-1
  else
    dateCal.mois:=E-13;
  if dateCal.mois>=3 then
    dateCal.an:=C-4716
  else
    dateCal.an:=C-4715;
end;

procedure bisg;
begin
  dateCal.nbmois:=12;
  if ((dateCal.an mod 100)=0)and((dateCal.an mod 400)<>0) then
    dateCal.typea:=0
  else if ((dateCal.an mod 4)=0) then
    dateCal.typea:=1
  else
    dateCal.typea:=0;
  end;

procedure bisr;
begin
  dateCal.nbmois:=13;
  if ((dateCal.an+1)mod 4)=0 then
    dateCal.typea:=1
  else
    dateCal.typea:=0;
end;

procedure BISJ;
begin
  dateCal.nbmois:=12;
  if (dateCal.an mod 4)=0 then
    dateCal.typea:=1
  else
    dateCal.typea:=0;
end;

procedure BISC;
begin
  dateCal.nbmois:=13;
  if ((dateCal.an+1)mod 4)=0 then
    dateCal.typea:=1
  else
    dateCal.typea:=0;
end;

procedure BISM;
var
  dt:real;
begin
  dateCal.nbmois:=12;
  dt:=(dateCal.an-1)/30;
  dateCal.cycle:=Trunc(dt)+1;
  dateCal.ANC:=dateCal.AN-(Trunc(dt)*30);
  if ((dateCal.ANC=2)or(dateCal.ANC=5)or(dateCal.ANC=7)or(dateCal.ANC=10)or
    (dateCal.ANC=13)or(dateCal.ANC=16)or(dateCal.ANC=18)or(dateCal.ANC=21)or
    (dateCal.ANC=24)or(dateCal.ANC=26)or(dateCal.ANC=29)) then
    dateCal.TYPEA:=1
  else
    dateCal.TYPEA:=0;
end;

procedure BISI;
var
  a,aa:integer;
  jjd,jjd1,dt:real;
begin
  dateCal.CYCLE:=1+(dateCal.AN-1)/19;
  dateCal.ANC:=1+(dateCal.AN-1)mod 19;
  aa:=dateCal.AN;
  aa:=12*aa+5;
  a:=aa mod 19;
  jjd:=DEBANJ(dateCal.AN);
  jjd1:=DEBANJ(dateCal.AN+1);
  dt:=jjd1-jjd;
  if (a>6) then
  begin
    dateCal.ESPEA:=Trunc(dt-352);
    dateCal.TYPEA:=0;
    dateCal.NBMOIS:=12;
  end
  else
  begin
    dateCal.ESPEA:=Trunc(dt-382);
    dateCal.TYPEA:=1;
    dateCal.NBMOIS:=13;
  end;
end;

function debanr(an:integer):real;
var
  dt,dj:real;
  jan,dan:integer;
begin
  dt:=an;
  dt:=(dt-1)/4;
  jan:=Trunc(dt);
  dt:=Trunc(dt);
  dj:=dt*1461;
  dan:=an-(jan*4);
  dj:=2375838.5+dj+(dan-1)*365+1;
  if dan=4 then
    dj:=dj+1;
  Result:=dj;
end;

function DEBANJ(an:integer):real;
var
  x1,x2,x3,x4,x5,x6,aa,a,jj,j:integer;
  t,dt:real;
begin
  x1:=392640;
  x2:=121555;
  x3:=272953;
  x4:=492480;
  x5:=347605;
  x6:=365;
  aa:=an;
  aa:=12*aa+5;
  a:=aa mod 19;
  t:=(x1+x2*an+x3*a)/x4;
  t:=t+x5+x6*an+a;
  jj:=Trunc(t);
  dt:=t-jj;
  t:=jj+1;
  t:=t-Trunc(t/7)*7;
  j:=Round(t);
  Result:=jj+0.5;
  if (j=2)or(j=4)or(j=6) then
    Result:=jj+1.5;
  if (j=1)and(a>6)and(dt>=0.632870) then
    Result:=jj+2.5;
  if (j=0)and(a>11)and(dt>=0.897724) then
    Result:=jj+1.5;
end;

procedure jrepu;
const
  BORNE:array[0..4] of Integer=(0,365,730,1096,1461);
var
  DT,DJ,AAN:real;
  I,JAN:Integer;
begin
  DT:=dateCal.jjd-2375839.5;
  AAN:=DT/1461;
  dateCal.an:=Trunc(AAN);
  DT:=DT-(Floor(AAN)*1461)+1;
  dateCal.an:=dateCal.an*4;
  jan:=0;
  for I:=0 to 3 do
  begin
    if ((BORNE[I]<DT)and(DT<=BORNE[I+1])) then
    begin
      JAN:=I+1;
      DT:=DT-BORNE[I];
    end;
  end;
  dateCal.an:=dateCal.an+JAN;
  if (JAN=3) then
    dateCal.typea:=1
  else
    dateCal.typea:=0;
  DJ:=(DT-1)/30;
  dateCal.mois:=Trunc(DJ)+1;
  dateCal.jour:=Trunc(DT-(Trunc(DJ)*30));
  DT:=dateCal.jour;
  while (DT>10) do
    DT:=DT-10;
  DT:=DT-1;
  dateCal.code6:=Round(DT);
end;

procedure repuj;
var
  DT:real;
  DAN,JAN:Integer;
begin
  DT:=dateCal.an;
  DT:=(DT-1)/4;
  JAN:=Trunc(DT);
  DT:=Trunc(DT);
  dateCal.jjd:=DT*1461;
  DAN:=dateCal.an-(JAN*4);
  dateCal.jjd:=2375838.5+dateCal.jjd+(DAN-1)*365+30*(dateCal.mois-1)+dateCal.jour;
  if ((DAN/4)=1) then
    dateCal.jjd:=dateCal.jjd+1;
  DT:=dateCal.jour;
  while (DT>10) do
    DT:=DT-10;
  DT:=DT-1;
  dateCal.code6:=Round(DT);
end;

procedure nomjour;
begin
  dateCal.jsem:=Round(Frac((dateCal.jjd+1.5)/7)*7)+1; //AL
end;

// Calcul du nb de jours pour les mois du calendrier Grégorien et Julien
procedure nbjrs;
begin
  if (dateCal.mois=2) then
  begin
    if (dateCal.typea=0) then
      dateCal.nbjrs:=28
    else
      dateCal.nbjrs:=29;
  end
  else
  begin
    if (dateCal.mois<8) then
    begin
      if ((dateCal.mois and 1)<>0) then
        dateCal.nbjrs:=31
      else
        dateCal.nbjrs:=30;
    end
    else
    begin
      if ((dateCal.mois and 1)<>0) then
        dateCal.nbjrs:=30
      else
        dateCal.nbjrs:=31;
    end;
  end;
end;

// Calcul du nb de jours pour les mois du calendrier Républicain
procedure nbjrsr;
begin
  if (dateCal.mois=13) then
  begin
    if (dateCal.typea=0) then
      dateCal.nbjrs:=5
    else
      dateCal.nbjrs:=6;
  end
  else
    dateCal.nbjrs:=30;
end;

// Calcul du nb de jours pour les mois du calendrier Israélien
procedure nbjrsj;
const
  tabmois:array[0..77] of integer=(
    30,29,29,29,30,29,30,29,30,29,30,29,0,
    30,29,30,29,30,29,30,29,30,29,30,29,0,
    30,30,30,29,30,29,30,29,30,29,30,29,0,
    30,29,29,29,30,30,29,30,29,30,29,30,29,
    30,29,30,29,30,30,29,30,29,30,29,30,29,
    30,30,30,29,30,30,29,30,29,30,29,30,29);
var
  NOLIG,NOCOL:Integer;
begin
  NOLIG:=3*dateCal.typea+dateCal.espea-1;
  NOCOL:=dateCal.mois-1;
  dateCal.nbjrs:=tabmois[13*(NOLIG)+NOCOL];
end;

// Calcul du nb de jours pour les mois du calendrier Musulman
procedure nbjrsm;
begin
  if (dateCal.mois=12) then
  begin
    if (dateCal.typea=0) then
      dateCal.nbjrs:=29
    else
      dateCal.nbjrs:=30;
  end
  else
  begin
    if ((dateCal.mois and 1)<>0) then
      dateCal.nbjrs:=30
    else
      dateCal.nbjrs:=29;
  end;
end;

// Calcul du nb de jours pour les mois du calendrier Copte
procedure nbjrsc;
begin
  if (dateCal.mois=13) then
  begin
    if (dateCal.typea=0) then
      dateCal.nbjrs:=5
    else
      dateCal.nbjrs:=6;
  end
  else
    dateCal.nbjrs:=30;
end;

procedure affcc();
const
  rjour:array[0..9] of string=('primidi','duodi','tridi','quatidi',
    'quintidi','sextidi','septidi','octidi',
    'nonidi','décadi');
  lmoisic:array[0..12] of string=('null','Tisseri','Hesvan','Kislev','Tébeth',
    'Schébat','Adar','Nissan','Iyar','Sivan',
    'Tamouz','Ab','Elloul');
  tean:array[0..10] of string=('année commune','année bissextile',
    'année abondante','année embolismique',
    'et défective','et régulière',
    'et abondante',
    'année de 365 jours','année de 366 jours',
    'année ordinaire','année sextile');
begin
  NOMJOUR();

  //julien
  if dateCal.JJD<=1.5 then
  begin
    dateCal.valeurJul:=CstPasEnUsage;
    dateCal.jourJul:=0;
    dateCal.moisJul:=0;
    dateCal.anJul:=0;
  end
  else
  begin
    JJDATEJ();
    BISJ();
    dateCal.jourJul:=dateCal.jour;
    dateCal.moisJul:=dateCal.mois;
    dateCal.anJul:=dateCal.an;
    dateCal.valeurJul:=' '+LongDayNames[dateCal.jsem]
      +' '+IntToStr(dateCal.JOUR)+' '+LongMonthNames[dateCal.MOIS]+' '+IntToStr(dateCal.AN);

    if dateCal.TYPEA=0 then
      dateCal.valeurJul:=dateCal.valeurJul+'   '+tean[0]
    else
      dateCal.valeurJul:=dateCal.valeurJul+'   '+tean[1];
  end;

  //républicain
  if (dateCal.jjd<2375839)or(dateCal.an>1805) then //correction AL2009 pour dates avant le 22 septembre 1792
  begin
    dateCal.valeurRep:=CstPasEnUsage;
    dateCal.jourRep:=0;
    dateCal.moisRep:=0;
    dateCal.anRep:=0;
  end
  else
  begin
    JREPU;
    BISR;
    dateCal.jourRep:=dateCal.jour;
    dateCal.moisRep:=dateCal.mois;
    dateCal.anRep:=dateCal.an;
    dateCal.valeurRep:=' '+rjour[dateCal.code6]+' '+IntToStr(dateCal.jour)+' '+
      lmoisr[dateCal.mois]+' an '+IntToStr(dateCal.an);

    if (dateCal.typea=0) then
      dateCal.valeurRep:=dateCal.valeurRep+'   '+tean[9]
    else
      dateCal.valeurRep:=dateCal.valeurRep+'   '+tean[10];
  end;

  //grégorien
  if dateCal.JJD<=1.5 then
  begin
    dateCal.valeurGre:=CstPasEnUsage;
    dateCal.jourGre:=0;
    dateCal.moisGre:=0;
    dateCal.anGre:=0;
  end
  else
  begin
    JJDATE();
    BISG();
    // on sauve pour pouvoir afficher les bonnes valeurs dans la
    // date de référence en fonction du calendrier si on change de
    // calendrier
    dateCal.jourGre:=dateCal.jour;
    dateCal.moisGre:=dateCal.mois;
    dateCal.anGre:=dateCal.an;
    if (dateCal.JJD<2299160.5) then
      dateCal.valeurGre:=CstPasEnUsage
    else
    begin
      dateCal.valeurGre:=' '+LongDayNames[dateCal.jsem]
      +' '+IntToStr(dateCal.JOUR)+' '+LongMonthNames[dateCal.MOIS]+' '+IntToStr(dateCal.AN);
      if (dateCal.TYPEA=0) then
        dateCal.valeurGre:=dateCal.valeurGre+'   '+tean[0]
      else
        dateCal.valeurGre:=dateCal.valeurGre+'   '+tean[1];
    end;
  end;

  //copte
  if (dateCal.JJD<1825029.5) then
  begin
    dateCal.valeurCop:=CstPasEnUsage;
    dateCal.jourCop:=0;
    dateCal.moisCop:=0;
    dateCal.anCop:=0;
  end
  else
  begin
    JCOPTE();
    BISC();
    dateCal.jourCop:=dateCal.jour;
    dateCal.moisCop:=dateCal.mois;
    dateCal.anCop:=dateCal.an;
    dateCal.valeurCop:=' '+IntToStr(dateCal.JOUR)+' '+
      lmoisc[dateCal.MOIS]+' '+IntToStr(dateCal.AN);

    if (dateCal.TYPEA=0) then
      dateCal.valeurCop:=dateCal.valeurCop+'   '+tean[7]
    else if (dateCal.TYPEA=1) then
      dateCal.valeurCop:=dateCal.valeurCop+'   '+tean[8];
  end;

  //musulman
  if (dateCal.JJD<1948439.5) then
  begin
    dateCal.valeurMus:=CstPasEnUsage;
    dateCal.jourMus:=0;
    dateCal.moisMus:=0;
    dateCal.anMus:=0;
  end
  else
  begin
    JMUSUL();
    BISM();
    dateCal.jourMus:=dateCal.jour;
    dateCal.moisMus:=dateCal.mois;
    dateCal.anMus:=dateCal.an;
    dateCal.valeurMus:=' '+IntToStr(dateCal.JOUR)+' '+
      lmoism[dateCal.MOIS]+' '+IntToStr(dateCal.AN);

    if (dateCal.TYPEA=0) then
      dateCal.valeurMus:=dateCal.valeurMus+'   '+tean[0]
    else if (dateCal.TYPEA=1) then
      dateCal.valeurMus:=dateCal.valeurMus+'   '+tean[2];
  end;

  //israélite
  if (dateCal.JJD<347997.5) then
  begin
    dateCal.valeurIsr:=CstPasEnUsage;
    dateCal.jourIsr:=0;
    dateCal.moisIsr:=0;
    dateCal.anIsr:=0;
  end
  else
  begin
    JISR();
      //BISI();
    dateCal.jourIsr:=dateCal.jour;
    dateCal.moisIsr:=dateCal.mois;
    dateCal.anIsr:=dateCal.an;
    
    if (dateCal.TYPEA=0) then
      dateCal.valeurIsr:=' '+IntToStr(dateCal.JOUR)+' '+
        lmoisic[dateCal.MOIS]+' '+IntToStr(dateCal.AN)+'  '+tean[0]
    else
      dateCal.valeurIsr:=' '+IntToStr(dateCal.JOUR)+' '+
        lmoisie[dateCal.MOIS]+' '+IntToStr(dateCal.AN)+'  '+tean[3];

    if (dateCal.ESPEA=1) then
      dateCal.valeurIsr:=dateCal.valeurIsr+' '+tean[4]
    else if (dateCal.ESPEA=2) then
      dateCal.valeurIsr:=dateCal.valeurIsr+' '+tean[5]
    else if (dateCal.ESPEA=3) then
      dateCal.valeurIsr:=dateCal.valeurIsr+' '+tean[6];
  end;
end;

procedure calculerGregorien;
begin
  //       if (dateCal.jjd<2375839.5 or dateCal.jjd>2380686.5) {alert("hors limites"); return;}
  bisg;
  nbjrs;
  if ((dateCal.jour<1)or(dateCal.jour>dateCal.nbjrs)) then
    //ShowMessage('Date saisie incorrecte')
    dateCal.erreur:='Date saisie incorrecte'
  else
  begin
    julien;// calcul du JJD
    affcc;
  end;
end;

procedure calculerJulien;
begin
  bisj;
  nbjrs;
  if ((dateCal.jour<1)or(dateCal.jour>dateCal.nbjrs)) then
    //ShowMessage('Date saisie incorrecte')
    dateCal.erreur:='Date saisie incorrecte'
  else
  begin
    julienj;
    affcc;
  end;
end;

procedure calculerRepublicain;
begin
  bisr;
  nbjrsr;

  if ((dateCal.jour<1)or(dateCal.jour>dateCal.nbjrs)) then
    //ShowMessage('Date saisie incorrecte')
    dateCal.erreur:='Date saisie incorrecte'
  else
  begin
    repuj;
    affcc;
  end;
end;

procedure calculerIsraelien;
begin
  //if (date.AN<1 || date.AN>6260) {alert('hors limites');return;}
  BISI;

  if (dateCal.jour<1)or(dateCal.jour>dateCal.nbjrs)
    or((dateCal.TYPEA=0) and (dateCal.mois=7)) then
    //ShowMessage('Date saisie incorrecte')
    dateCal.erreur:='Date saisie incorrecte'
  else
  begin
    ISRJ;// calcul du JJD
    affcc;
  end;
end;

procedure calculerMusulman;
begin
  //if (date.AN<1 || date.AN>1936) {alert('hors limites');return;}
  BISM;
  nbjrsm;

  if ((dateCal.jour<1)or(dateCal.jour>dateCal.nbjrs)) then
    //ShowMessage('Date saisie incorrecte')
    dateCal.erreur:='Date saisie incorrecte'
  else
  begin
    MUSULJ;// calcul du JJD
    affcc;
  end;
end;

procedure calculerCopte;
begin
  //if (date.AN<1 || date.AN>2216) {alert('hors limites');return;}
  BISC;
  nbjrsc;

  if ((dateCal.jour<1)or(dateCal.jour>dateCal.nbjrs)) then
    //ShowMessage('Date saisie incorrecte')
    dateCal.erreur:='Date saisie incorrecte'
  else
  begin
    COPTEJ;
    affcc;
  end;
end;

end.
