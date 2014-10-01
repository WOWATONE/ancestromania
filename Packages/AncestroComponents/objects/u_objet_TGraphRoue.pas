{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Andr? Langlet (Main), Matthieu Giroux (LAZARUS),            }
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

unit u_objet_TGraphRoue;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  RPrinter, RPRPTF, RPBase, RPDefine,
{$ELSE}
{$ENDIF}
  Classes,LCLType,contnrs,graphics,extctrls,u_common_graph_type,
  u_objet_graph_TGraph,
  u_objet_graph_TPlot, RLPrinters,
  u_objet_graph_TPlotList,
  sysutils;

type

  TIndividu=class
  private
    fCleFiche:integer;
    fLevel:integer;
    fChilds:TObjectList;
    fNom:string;
    fPrenom:string;
    fCleMere:integer;
    fClePere:integer;
    fDeces:string;
    fNaissance:string;
    fidxPlotCentre:integer;
    fidxOrdre:integer;
    fAngle:integer;
    fPlotNom:TPlot;
    fPlotPrenom:TPlot;
    fPlotProf:TPlot;
    fPlotDeces:TPlot;
    fPlotNaissance:TPlot;
    fProf:string;

    AffNom,AffPrenom,AffProf,AffNaissance,AffDeces:string;
    AffPrintNom,AffPrintPrenom,AffPrintProf,AffPrintNaissance,AffPrintDeces:string;
    fSexe:integer;
    fAngleNom:integer;
    fAnglePrenom:integer;

    fAnglePrintNom:integer;
    fAnglePrintPrenom:integer;

    procedure OrdreHommeFemme;

  protected

    fOrderTete:integer;
    procedure EquilibreNoeuds(var NumOrderTete:integer);

  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    property CleFiche:integer read fCleFiche write fCleFiche;
    property Nom:string read fNom write fNom;
    property Prenom:string read fPrenom write fPrenom;
    property Prof:string read fProf write fProf;
    property Naissance:string read fNaissance write fNaissance;
    property Deces:string read fDeces write fDeces;

    property Sexe:integer read fSexe write fSexe;

    property Level:integer read fLevel write fLevel;
    property Childs:TObjectList read fChilds write fChilds;
    property idxOrdre:integer read fidxOrdre write fidxOrdre;
    property idxPlotCentre:integer read fidxPlotCentre write fidxPlotCentre;
    property Angle:integer read fAngle write fAngle;

    property AngleNom:integer read fAngleNom write fAngleNom;
    property AnglePrenom:integer read fAnglePrenom write fAnglePrenom;

    property AnglePrintNom:integer read fAnglePrintNom write fAnglePrintNom;
    property AnglePrintPrenom:integer read fAnglePrintPrenom write fAnglePrintPrenom;

    property ClePere:integer read fClePere write fClePere;
    property CleMere:integer read fCleMere write fCleMere;

    property PlotNom:TPlot read fPlotNom write fPlotNom;
    property PlotPrenom:TPlot read fPlotPrenom write fPlotPrenom;
    property PlotProf:TPlot read fPlotProf write fPlotProf;
    property PlotNaissance:TPlot read fPlotNaissance write fPlotNaissance;
    property PlotDeces:TPlot read fPlotDeces write fPlotDeces;
  end;

  TGraphRoue=class(TGraph)

  private
    fNbGeneration:integer;
    fCentre:TPlot;
    fCercleList:TObjectList;

    fRayonV:single;
    fRayonM:single;

    fAll:TObjectList;
    fStartIndividu:TIndividu;
    fCleIndiDepart:integer;

    fHeightFont:integer;
    fCanvas:TCanvas;
    fFontText:TFont;

    fLevelMaxTexteNormal:integer;
    function GetIndividuByCleMere(CleMere:integer):TIndividu;
    function GetIndividuByClePere(ClePere:integer):TIndividu;
  public
    property CleIndiDepart:integer read fCleIndiDepart write fCleIndiDepart;
    property Canvas:TCanvas read fCanvas write fCanvas;

    constructor Create; override;
    destructor Destroy; override;

    //chargement
    procedure Load; override;

    procedure Prepare; override;

    procedure CoordChantier_2_CoordViewer(coef:single); override;
    procedure CoordChantier_2_CoordMiniature(coef:single); override;

    procedure Paint(PaintBox:TPaintBox;DecalX,DecalY:integer); override;
    procedure PaintMiniature(PaintBox:TPaintBox;DecalX,DecalY:integer); override;
    procedure GetRectEncadrement(var R:TFloatRect); override;

    procedure Print(rp:TRLPrinterWrapper); override;
    procedure PreparePrint; override;

    function GetCleIndividuAtXY(X,Y:integer;var sNom,sNaisDec:string;var iSexe,iGene,iParent:integer):integer; override;
  end;

implementation

uses
  Math,u_dm,u_common_graph_func,u_common_var,u_rm,
  u_common_func,IBSQL;

{ TMonGraph }

constructor TGraphRoue.Create;
begin
  inherited Create;

  fNbGeneration:=7;
  fCleIndiDepart:=-1;

  fLevelMaxTexteNormal:=3;
  fFontText:=TFont.create;

  fCentre:=TPlot.create;
  fCercleList:=TObjectList.create;

  fStartIndividu:=TIndividu.create;
  fAll:=TObjectList.create(false);
end;

destructor TGraphRoue.Destroy;
begin
  fCentre.free;
  fCercleList.free;

  fStartIndividu.free;
  fAll.free;

  fFontText.free;

  inherited Destroy;
end;

procedure TGraphRoue.CoordChantier_2_CoordMiniature(coef:single);
var
  n,k:integer;
  aCercle:TPlotList;
begin
  //le centre
  fCentre.CoordChantier_2_CoordMiniature(coef);

  //les cercles
  for n:=0 to fCercleList.Count-1 do
  begin
    aCercle:=TPlotList(fCercleList[n]);
    for k:=0 to aCercle.Count-1 do
      aCercle[k].CoordChantier_2_CoordMiniature(coef);
  end;

  //Le rayon
  fRayonM:=round(coef*_Context.RoueRayon);
end;

procedure TGraphRoue.CoordChantier_2_CoordViewer(coef:single);
var
  n,k:integer;
  aCercle:TPlotList;
begin
  //le centre
  fCentre.CoordChantier_2_CoordViewer(coef);

  //les cercles
  for n:=0 to fCercleList.Count-1 do
  begin
    aCercle:=TPlotList(fCercleList[n]);
    for k:=0 to aCercle.Count-1 do
      aCercle[k].CoordChantier_2_CoordViewer(coef);
  end;

  //le rayon
  fRayonV:=round(coef*_Context.RoueRayon);

  //les individus
  for n:=0 to fAll.count-1 do
  begin
    TIndividu(fAll[n]).PlotNom.CoordChantier_2_CoordViewer(coef);
    TIndividu(fAll[n]).PlotPrenom.CoordChantier_2_CoordViewer(coef);
    TIndividu(fAll[n]).PlotProf.CoordChantier_2_CoordViewer(coef);
    TIndividu(fAll[n]).PlotDeces.CoordChantier_2_CoordViewer(coef);
    TIndividu(fAll[n]).PlotNaissance.CoordChantier_2_CoordViewer(coef);
  end;

  fHeightFont:=round((coef*25.4*fFontText.Size)/72);
end;

procedure TGraphRoue.GetRectEncadrement(var R:TFloatRect);
var
  n,k:integer;
  aCercle:TPlotList;
begin
  //Rectangle de d?limitation de tout le chantier, en m
  R.left:=Maxint;
  R.Top:=Maxint;
  R.Right:=-Maxint;
  R.Bottom:=-Maxint;

  //le centre
  if R.Left>fCentre.XC then R.Left:=fCentre.XC;
  if R.Right<fCentre.XC then R.Right:=fCentre.XC;
  if R.Top>fCentre.YC then R.Top:=fCentre.YC;
  if R.Bottom<fCentre.YC then R.Bottom:=fCentre.YC;

  //les cercles
  for n:=0 to fCercleList.Count-1 do
  begin
    aCercle:=TPlotList(fCercleList[n]);
    for k:=0 to aCercle.Count-1 do
    begin
      if R.Left>aCercle[k].XC then R.Left:=aCercle[k].XC;
      if R.Right<aCercle[k].XC then R.Right:=aCercle[k].XC;
      if R.Top>aCercle[k].YC then R.Top:=aCercle[k].YC;
      if R.Bottom<aCercle[k].YC then R.Bottom:=aCercle[k].YC;
    end;
  end;
  R.Right:=R.Right+_Context.RoueMargeLeft;
  R.Bottom:=R.Bottom+_Context.RoueMargeTop;
end;

procedure TGraphRoue.Paint(PaintBox:TPaintBox;DecalX,DecalY:integer);
var
  n,k,w,i,p:integer;
  aCercle,LastCercle:TPlotList;
  R:TRect;
  indi:TIndividu;
  lf:TLogFont;
  tf:TFont;
begin
  //on r?cup?re la font ? utilisez, avec la taille en 100 %
  StringToFont(_Context.RoueFont,PaintBox.Canvas.Font);

  //on adapte la taille en fonction du zoom
  PaintBox.Canvas.Font.Size:=fHeightFont;

  PaintBox.Canvas.Pen.Style:=psSolid;

  PaintBox.Canvas.Brush.Style:=bsClear;

  //les cercles

  LastCercle:=TPlotList(fCercleList.last);
  for n:=0 to fCercleList.Count-1 do
  begin
    aCercle:=TPlotList(fCercleList[n]);

    w:=round((n+1)*fRayonV);

    R.left:=fCentre.XV-w+DecalX;
    R.right:=fCentre.XV+w+DecalX;
    R.top:=fCentre.YV-w+DecalY;
    R.bottom:=fCentre.YV+w+DecalY;

    PaintBox.Canvas.Pen.Color:=_Context.RoueCouleurCercle;

    PaintBox.Canvas.Arc(
      R.Left,R.Top,
      R.Right,R.Bottom,
      aCercle[0].XV+DecalX,
      aCercle[0].YV+DecalY,
      aCercle.last.XV+DecalX,
      aCercle.last.YV+DecalY);

    PaintBox.Canvas.Pen.Color:=_Context.RoueCouleurRayon;
    p:=trunc(Ldexp(1,fCercleList.Count-n-1));
    i:=p;
    for k:=1 to aCercle.count-2 do
    begin
      PaintBox.Canvas.MoveTo(aCercle[k].XV+DecalX,aCercle[k].YV+DecalY);
      PaintBox.Canvas.LineTo(LastCercle[i].XV+DecalX,LastCercle[i].YV+DecalY);
      i:=i+p;
    end;
  end;

  //les lignes
  PaintBox.Canvas.Pen.Color:=_Context.RoueCouleurRayon;
  if fCercleList.Count>0 then
  begin
    if _Context.RoueAngle<>360 then
    begin
      PaintBox.Canvas.MoveTo(LastCercle[0].XV+DecalX,LastCercle[0].YV+DecalY);
      PaintBox.Canvas.LineTo(fCentre.XV+DecalX,fCentre.YV+DecalY);
      PaintBox.Canvas.LineTo(LastCercle.last.XV+DecalX,LastCercle.last.YV+DecalY);
    end
    else
    begin
      aCercle:=TPlotList(fCercleList[0]);
      if aCercle<>nil then
      begin
        PaintBox.Canvas.MoveTo(aCercle[0].XV+DecalX,aCercle[0].YV+DecalY);
        PaintBox.Canvas.LineTo(LastCercle[0].XV+DecalX,LastCercle[0].YV+DecalY);
      end;
    end;
  end;

  if fHeightFont>=1 then
  begin
      //les individus
    for n:=0 to fAll.Count-1 do
    begin
      indi:=TIndividu(fAll[n]);

      if indi.Sexe=1 then
        PaintBox.Canvas.Font.Color:=_Context.RoueCouleurTexteHomme
      else
        PaintBox.Canvas.Font.Color:=_Context.RoueCouleurTexteFemme;

      if indi.level<=fLevelMaxTexteNormal then
      begin
        tf:=TFont.Create;
        tf.Assign(PaintBox.Canvas.Font);
        GetObject(tf.Handle,sizeof(lf),@lf);
        lf.lfEscapement:=indi.Angle;
        lf.lfOrientation:=indi.Angle;
        tf.Handle:=CreateFontIndirect(lf);
        PaintBox.Canvas.Font.Assign(tf);
        tf.Free;

              //le texte
        if _Context.RoueShowNom then
          PaintBox.Canvas.TextOut(indi.PlotNom.XV+DecalX,indi.PlotNom.YV+DecalY,indi.AffNom);

        if _Context.RoueShowPrenom then
          PaintBox.Canvas.TextOut(indi.PlotPrenom.XV+DecalX,indi.PlotPrenom.YV+DecalY,indi.AffPrenom);

        if _Context.RoueShowProfession then
          PaintBox.Canvas.TextOut(indi.PlotProf.XV+DecalX,indi.PlotProf.YV+DecalY,indi.AffProf);

        if _Context.RoueShowNaissance then
          PaintBox.Canvas.TextOut(indi.PlotNaissance.XV+DecalX,indi.PlotNaissance.YV+DecalY,indi.AffNaissance);

        if _Context.RoueShowDeces then
          PaintBox.Canvas.TextOut(indi.PlotDeces.XV+DecalX,indi.PlotDeces.YV+DecalY,indi.AffDeces);

      end
      else
      begin
        tf:=TFont.Create;
        tf.Assign(PaintBox.Canvas.Font);
        GetObject(tf.Handle,sizeof(lf),@lf);
        lf.lfEscapement:=indi.AngleNom;
        lf.lfOrientation:=indi.AngleNom;
        tf.Handle:=CreateFontIndirect(lf);
        PaintBox.Canvas.Font.Assign(tf);
        tf.Free;

        if _Context.RoueShowNom then
          PaintBox.Canvas.TextOut(indi.PlotNom.XV+DecalX,indi.PlotNom.YV+DecalY,indi.AffNom);

        tf:=TFont.Create;
        tf.Assign(PaintBox.Canvas.Font);
        GetObject(tf.Handle,sizeof(lf),@lf);
        lf.lfEscapement:=indi.AnglePrenom;
        lf.lfOrientation:=indi.AnglePrenom;
        tf.Handle:=CreateFontIndirect(lf);
        PaintBox.Canvas.Font.Assign(tf);
        tf.Free;

        if _Context.RoueShowPrenom then
          PaintBox.Canvas.TextOut(indi.PlotPrenom.XV+DecalX,indi.PlotPrenom.YV+DecalY,indi.AffPrenom);
      end;
    end;
  end;

end;

procedure TGraphRoue.PaintMiniature(PaintBox:TPaintBox;DecalX,DecalY:integer);
var
  n,k,w,i,p:integer;
  aCercle,LastCercle:TPlotList;
  R:TRect;
begin
  PaintBox.Canvas.Pen.Color:=clRed;
  PaintBox.Canvas.Pen.Style:=psSolid;

  LastCercle:=TPlotList(fCercleList.last);

  for n:=0 to fCercleList.Count-1 do
  begin
    aCercle:=TPlotList(fCercleList[n]);
    w:=round((n+1)*fRayonM);

    R.left:=fCentre.XM-w+DecalX;
    R.right:=fCentre.XM+w+DecalX;
    R.top:=fCentre.YM-w+DecalY;
    R.bottom:=fCentre.YM+w+DecalY;

    PaintBox.Canvas.Arc(
      R.Left,R.Top,
      R.Right,R.Bottom,
      aCercle[0].XM+DecalX,
      aCercle[0].YM+DecalY,
      aCercle.last.XM+DecalX,
      aCercle.last.YM+DecalY);

    p:=trunc(Ldexp(1,fCercleList.Count-n-1));
    i:=p;
    for k:=1 to aCercle.count-2 do
    begin
      PaintBox.Canvas.MoveTo(aCercle[k].XM+DecalX,aCercle[k].YM+DecalY);
      PaintBox.Canvas.LineTo(LastCercle[i].XM+DecalX,LastCercle[i].YM+DecalY);
      i:=i+p;
    end;

  end;

  if fCercleList.Count>0 then
  begin
    if _Context.RoueAngle<>360 then
    begin
      PaintBox.Canvas.MoveTo(LastCercle[0].XM+DecalX,LastCercle[0].YM+DecalY);
      PaintBox.Canvas.LineTo(fCentre.XM+DecalX,fCentre.YM+DecalY);
      PaintBox.Canvas.LineTo(LastCercle.last.XM+DecalX,LastCercle.last.YM+DecalY);
    end
    else
    begin
      aCercle:=TPlotList(fCercleList[0]);
      if aCercle<>nil then
      begin
        PaintBox.Canvas.MoveTo(aCercle[0].XM+DecalX,aCercle[0].YM+DecalY);
        PaintBox.Canvas.LineTo(LastCercle[0].XM+DecalX,LastCercle[0].YM+DecalY);
      end;
    end;
  end;
end;

procedure TGraphRoue.Prepare;
var
  w,n,k:integer;
  b,e,ep,h,edep,ht,wt:extended;
  aCercle:TPlotList;
  aPlot:TPlot;
  indi:TIndividu;
  d:extended;
  Lmm:single;
  dt:extended;
  x,y:extended;
  xa,ya,xb,yb:extended;
  s:string;

  procedure PlaceTexteIndi0(text:string;indi:TIndividu;moins_n_mm:integer;aPlot:TPlot);
  var
    s:string;
    x,y:extended;
    lng,lngmax:extended;
  begin
    s:=trim(text);
    if s<>'' then
    begin
      Lmm:=fCanvas.TextWidth(s)/(72/25.4);
      lngmax:=norme(
        fCentre.XC-_Context.RoueRayon,TPlotList(fCercleList[indi.level])[indi.idxPlotCentre].YC+moins_n_mm,
        fCentre.XC+_Context.RoueRayon,TPlotList(fCercleList[indi.level])[indi.idxPlotCentre].YC+moins_n_mm);

      lng:=(lngMax-Lmm)/2;
      TrouvePoint(
        fCentre.XC-_Context.RoueRayon,TPlotList(fCercleList[indi.level])[indi.idxPlotCentre].YC+moins_n_mm,
        fCentre.XC+_Context.RoueRayon,TPlotList(fCercleList[indi.level])[indi.idxPlotCentre].YC+moins_n_mm,
        Lng,
        x,
        y);

      aPlot.XC:=x;//x+ fCentre.XC;
      aPlot.YC:=y;//fCentre.YC -y;
    end
    else
    begin
      aPlot.XC:=0;
      aPlot.YC:=0;
    end;
  end;

  procedure ReduceText(var s:string;LngMax:extended);
  var
    Lmm:extended;
  begin
    Lmm:=fCanvas.TextWidth(s)/(72/25.4);
    if Lmm>=LngMax then
    begin
      repeat
        if length(s)<1 then
        begin
          s:='';
          break;
        end;

        delete(s,length(s),1);
        Lmm:=fCanvas.TextWidth(s+'?')/(72/25.4);
      until (Lmm<=LngMax);

      s:=s+'?';
    end;
  end;

  procedure PlaceTexteIndiCentral(text:string;indi:TIndividu;moins_n_mm:integer;aPlot:TPlot;var TextAff:string);
  var
    s:string;
    lngmax:extended;
    py,a,b,c,d,x1,x2,xr,v:extended;
  begin
    s:=trim(text);
    TextAff:=s;
    aPlot.XC:=0;
    aPlot.YC:=0;

    if s<>'' then
    begin
        //on cherche la droite horizontale qui passe par le haut du texte, et qui coupe le cercle
      try
        py:=TPlotList(fCercleList[indi.level])[indi.idxPlotCentre].YC+moins_n_mm+_Context.RoueDecalageIndiCentral;
        a:=1;
        b:=-2*fCentre.XC;
        c:=-sqr(_Context.RoueRayon)+sqr(py-fCentre.YC)+sqr(fCentre.XC);
        d:=sqr(b)-(4*a*c);
        x1:=(-b+sqrt(d))/(2*a);
        x2:=(-b-sqrt(d))/(2*a);
        lngmax:=norme(x1,py,x2,py);

          //R?duction de la taille du texte, si ?a tient pas
        ReduceText(s,lngmax);
        TextAff:=s;

          //On positionne le texte
        if x1>x2 then
        begin xr:=x1;
          x1:=x2;
          x2:=xr;
        end;
        Lmm:=fCanvas.TextWidth(s)/(72/25.4);

        v:=(x2-x1-Lmm)/2;
        if v<0 then v:=0;

        aPlot.XC:=x1+v;
        aPlot.YC:=py;
      except

      end;
    end;
  end;

  procedure calcPlotText(text:string;indi:TIndividu;moins_n_mm:integer;aPlot:TPlot;var NomAff:string);
  var
    s:string;
    x,y:extended;
    lng,lngmax:extended;
    xa,ya,xb,yb:extended;
    LargeurMaxPossibleText:extended;
  begin
    s:=trim(text);
    NomAff:=s;

    if s<>'' then
    begin
      TrouveCoords(
        fCentre.XC,
        fCentre.YC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre+1].XC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre+1].YC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre].XC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre].YC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre-1].XC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre-1].YC,
        moins_n_mm,
        xa,ya,xb,yb);

      Lmm:=fCanvas.TextWidth(s)/(72/25.4);
      lngmax:=norme(xa,ya,xb,yb);

      if LargeurPossibleTexte(xa,ya,xb,yb,fCentre.XC,fCentre.YC,_Context.RoueRayon*(indi.level+1),LargeurMaxPossibleText) then
      begin
        LargeurMaxPossibleText:=min(LargeurMaxPossibleText,lngmax);
        begin
          reduceText(s,LargeurMaxPossibleText);
          Lmm:=fCanvas.TextWidth(s)/(72/25.4);
          NomAff:=s;
        end;
      end;

      lng:=(lngMax-Lmm)/2;

      TrouvePoint(xa,ya,xb,yb,
        Lng,
        x,
        y);

      aPlot.XC:=x;//x+ fCentre.XC;
      aPlot.YC:=y;//fCentre.YC -y;
    end
    else
    begin
      aPlot.XC:=0;
      aPlot.YC:=0;
    end;
  end;

begin
  //on assigne la police, qui correspond ? celle utilis?e en 100%
  StringToFont(_Context.RoueFont,fFontText);
  StringToFont(_Context.RoueFont,fCanvas.Font);

  //on vide les cercles
  fCercleList.Clear;

  //ou est le centre ?
  fCentre.XC:=_Context.RoueMargeLeft+(fNbGeneration*_Context.RoueRayon);
  fCentre.YC:=_Context.RoueMargeTop+(fNbGeneration*_Context.RoueRayon);

  //les cercles
  for n:=1 to fNbGeneration do
  begin
      //combien de quartiers ?
    w:=trunc(Ldexp(1,n));

      //Nb de degr? d'un quartier
    e:=_Context.RoueAngle/(w);

    b:=(_Context.RoueAngle-180)/2;

      //rayon pour cette g?n?ration
    h:=n*_Context.RoueRayon;

      //cr?ation d'un cercle
    aCercle:=TPlotList.create;
    fCercleList.Add(aCercle);

      //angle de d?part
    edep:=0;

    for k:=1 to w+1 do
    begin
      ep:=DegToRad(edep-b);
      aPlot:=TPlot.Create;
      aCercle.Add(aPlot);

      aPlot.XC:=(h*cos(ep))+fCentre.XC;
      aPlot.YC:=fCentre.YC-(h*sin(ep));

      if TrouveIntersectionCercleDroite(
        aPlot.XC,
        aPlot.YC,
        fCentre.XC,
        fCentre.YC,
        fCentre.XC,
        fCentre.YC,
        h,
        xa,ya,xb,yb) then
      begin
        PointLePlusProcheDeP(xa,ya,xb,yb,aPlot.XC,aPlot.YC,x,y);
        aPlot.XC:=x;
        aPlot.YC:=y;

        if y>5000 then
        begin
          y:=y;
        end;
      end;

      edep:=edep+e;
    end;
  end;

  for n:=0 to fAll.Count-1 do
  begin
    indi:=TIndividu(fAll[n]);

      //combien de quartiers ?
    w:=trunc(Ldexp(1,indi.level+1));

      //Nb de degr? d'un quartier (du niveau supp?rieur)
    e:=_Context.RoueAngle/(w);

      //angle de d?marrage
    b:=(_Context.RoueAngle-180)/2;

    if indi.level<=fLevelMaxTexteNormal then
    begin
          //angle au point central du quartier
      d:=(indi.idxPlotCentre*e)-b;

          //-------------------------------------
          //on calcul le point de d?marrage du texte

      if n=0 then
      begin
              //seulement pour l'individu central
        PlaceTexteIndiCentral(indi.Nom,indi,_Context.RoueDistNom,indi.PlotNom,s);
        indi.AffNom:=s;
        PlaceTexteIndiCentral(indi.Prenom,indi,_Context.RoueDistPrenom,indi.PlotPrenom,s);
        indi.AffPrenom:=s;
        PlaceTexteIndiCentral(indi.Prof,indi,_Context.RoueDistProfession,indi.PlotProf,s);
        indi.AffProf:=s;
        PlaceTexteIndiCentral(indi.Naissance,indi,_Context.RoueDistNaissance,indi.PlotNaissance,s);
        indi.AffNaissance:=s;
        PlaceTexteIndiCentral(indi.Deces,indi,_Context.RoueDistDeces,indi.PlotDeces,s);
        indi.AffDeces:=s;
      end
      else
      begin
        calcPlotText(indi.Nom,indi,_Context.RoueDistNom,indi.PlotNom,s);
        indi.AffNom:=s;
        calcPlotText(indi.Prenom,indi,_Context.RoueDistPrenom,indi.PlotPrenom,s);
        indi.AffPrenom:=s;
        calcPlotText(indi.Prof,indi,_Context.RoueDistProfession,indi.PlotProf,s);
        indi.AffProf:=s;
        calcPlotText(indi.Naissance,indi,_Context.RoueDistNaissance,indi.PlotNaissance,s);
        indi.AffNaissance:=s;
        calcPlotText(indi.Deces,indi,_Context.RoueDistDeces,indi.PlotDeces,s);
        indi.AffDeces:=s;
      end;

          //angle du texte
      dt:=d-90;

          //on remet dans le bon interval
      if dt<0 then
      begin
        while dt<-360 do
          dt:=dt+360;
        dt:=360+dt;
      end;
      while dt>360 do
        dt:=dt-360;

      indi.Angle:=round(10*dt);
    end
    else
        //texte apres levelMax
    begin
          //angle au point gauche du quartier
      d:=(indi.idxPlotCentre*e)-b;
      Ht:=fCanvas.TextHeight(indi.Nom)/(72/25.4);
      dt:=arcsin((Ht/2)/(indi.level*_Context.RoueRayon));
      h:=(indi.level*_Context.RoueRayon);

      ep:=DegToRad(d)+dt+dt;
      indi.PlotNom.XC:=(h*cos(ep))+fCentre.XC;
      indi.PlotNom.YC:=fCentre.YC-(h*sin(ep));
      indi.AngleNom:=round(10*(radtodeg(ep)));
      s:=indi.Nom;
      ReduceText(s,_Context.RoueRayon);
      indi.AffNom:=s;

          //inversion
      if d>=90 then
      begin
        Wt:=fCanvas.TextWidth(indi.AffNom)/(72/25.4);
        ep:=DegToRad(d)-dt-dt;
        indi.PlotNom.XC:=((h+Wt)*cos(ep))+fCentre.XC;
        indi.PlotNom.YC:=fCentre.YC-((h+Wt)*sin(ep));
              //                    indi.AngleNom := round(10 * (d + 180));
        indi.AngleNom:=round(10*(radtodeg(ep)+180));
        if indi.AngleNom>3600 then indi.AngleNom:=indi.AngleNom-3600;
      end;

      ep:=DegToRad(d);
      indi.PlotPrenom.XC:=(h*cos(ep))+fCentre.XC;
      indi.PlotPrenom.YC:=fCentre.YC-(h*sin(ep));
      indi.AnglePrenom:=round(10*(radtodeg(ep)));
      s:=indi.Prenom;
      ReduceText(s,_Context.RoueRayon);
      indi.AffPrenom:=s;

          //inversion
      if d>=90 then
      begin
        Wt:=fCanvas.TextWidth(indi.AffPrenom)/(72/25.4);
        ep:=DegToRad(d);
        indi.PlotPrenom.XC:=((h+Wt)*cos(ep))+fCentre.XC;
        indi.PlotPrenom.YC:=fCentre.YC-((h+Wt)*sin(ep));
        indi.AnglePrenom:=round(10*(radtodeg(ep)+180));
        if indi.AnglePrenom>3600 then indi.AnglePrenom:=indi.AnglePrenom-3600;
      end;
    end;
  end;
end;

procedure TGraphRoue.Load;
var
  k,level,CleFiche:integer;
  indi,indiParent:TIndividu;
  Q:TIBSQL;
begin
  fAll.Clear;
  fStartIndividu.Clear;
  fNbGeneration:=_Context.RoueShowNbGeneration;

  //celui de d?part
  fAll.Add(fStartIndividu);

  //On charge les individus
  Q:=TIB.FieldByName('SQL').Create(nil);
  try
    Q.Database:=dm.ibd_BASE;
    Q.Transaction:=dm.IBT_BASE;
    Q.SQL.Add('SELECT  t.tq_niveau as niveau'
      +',t.tq_cle_fiche as cle_fiche'
      +',i.CLE_PERE'
      +',i.CLE_MERE'
      +',i.NOM'
      +',i.PRENOM'
      +',i.SEXE'
      +',i.DATE_NAISSANCE'
      +',i.DATE_DECES'
      +',(select occupation from proc_dernier_metier(t.tq_cle_fiche))'
      +' FROM PROC_TQ_ASCENDANCE(:I_CLEF,:I_NIVEAU,0,0) t'
      +' inner join individu i on i.cle_fiche=t.tq_cle_fiche'
      +' ORDER BY t.tq_SOSA');
    Q.ParamByName('I_CLEF').AsInteger:=fCleIndiDepart;
    Q.ParamByName('I_NIVEAU').AsInteger:=fNbGeneration-1;

    Q.ExecQuery;

    while not Q.Eof do
    begin
      Level:=Q.FieldByName('NIVEAU').AsInteger;
      CleFiche:=Q.FieldByName('CLE_FICHE').AsInteger;

      if level=0 then
      begin
        indi:=fStartIndividu;
        indi.idxOrdre:=0;
        indi.idxPlotCentre:=1;
        indiParent:=nil;
      end
      else
      begin
            //le sexe ne peut-?tre que 1 ou 2
        if Q.FieldByName('SEXE').AsInteger=1 then
          indiParent:=GetIndividuByClePere(CleFiche)
        else
          indiParent:=GetIndividuByCleMere(CleFiche);

        if indiParent<>nil then
        begin
          indi:=TIndividu.create;
          fAll.Add(indi);
        end
        else
          indi:=nil;

      end;

      if indi<>nil then
      begin
            //1=Homme, 2=Femme
        indi.Sexe:=Q.FieldByName('SEXE').AsInteger;

        indi.Angle:=0;
        indi.CleFiche:=CleFiche;
        indi.level:=level;
        indi.ClePere:=Q.FieldByName('CLE_PERE').AsInteger;
        indi.CleMere:=Q.FieldByName('CLE_MERE').AsInteger;
        indi.Nom:=Q.FieldByName('NOM').AsString;
        indi.Prof:=Q.FieldByName('OCCUPATION').AsString;
        indi.Prenom:=Q.FieldByName('PRENOM').AsString;
        indi.Naissance:=Q.FieldByName('DATE_NAISSANCE').AsString;
        indi.Deces:=Q.FieldByName('DATE_DECES').AsString;

        if indiParent<>nil then
        begin
          k:=indiParent.Childs.Add(indi);
          indi.idxOrdre:=(indiParent.idxOrdre*2)+k;
          indi.idxPlotCentre:=(indi.idxOrdre*2)+1;
        end;
      end;

      Q.next;
    end;
  finally
    Q.Free;
  end;

  //on s'assure que les hommes sont ? droite, et les femmes ? gauche
  fStartIndividu.OrdreHommeFemme;

end;

{ TIndividu }

procedure TIndividu.Clear;
begin
  fSexe:=-1;
  fCleFiche:=-1;
  fLevel:=0;
  fNom:='';
  fProf:='';
  fPrenom:='';
  fDeces:='';
  fNaissance:='';

  fCleMere:=-1;
  fClePere:=-1;

  fidxOrdre:=-1;
  fidxPlotCentre:=-1;
  fChilds.Clear;
end;

constructor TIndividu.Create;
begin
  fChilds:=TObjectList.create(true);
  fPlotNom:=TPlot.create;
  fPlotPrenom:=TPlot.create;
  fPlotProf:=TPlot.create;
  fPlotDeces:=TPlot.create;
  fPlotNaissance:=TPlot.create;

  Clear;
end;

destructor TIndividu.Destroy;
begin
  fChilds.Free;
  fPlotNom.Free;
  fPlotPrenom.Free;
  fPlotProf.Free;
  fPlotDeces.Free;
  fPlotNaissance.Free;

  inherited Destroy;
end;

procedure TIndividu.EquilibreNoeuds(var NumOrderTete:integer);
begin

end;

procedure TIndividu.OrdreHommeFemme;
var
  n,k:integer;
begin
  case fChilds.count of
    2:
      begin
        if TIndividu(fChilds[0]).Sexe=1 then //homme
        begin
            //invertion
          fChilds.Exchange(0,1);
        end;
      end;

  end;

  //on ordonne les suivants
  k:=idxOrdre*2;
  if fChilds.count>1 then
  begin
    for n:=0 to fChilds.count-1 do
    begin
      TIndividu(fChilds[n]).idxOrdre:=k+n;
      TIndividu(fChilds[n]).idxPlotCentre:=((k+n)*2)+1;

      TIndividu(fChilds[n]).OrdreHommeFemme;
    end;
  end
  else if fChilds.count=1 then
  begin
    if TIndividu(fChilds[0]).Sexe=1 then //homme
    begin
      TIndividu(fChilds[0]).idxOrdre:=k+1;
      TIndividu(fChilds[0]).idxPlotCentre:=((k+1)*2)+1;
    end
    else
    begin
      TIndividu(fChilds[0]).idxOrdre:=k+0;
      TIndividu(fChilds[0]).idxPlotCentre:=((k+0)*2)+1;
    end;

    TIndividu(fChilds[0]).OrdreHommeFemme;
  end;
end;

function TGraphRoue.GetIndividuByClePere(ClePere:integer):TIndividu;
var
  n:integer;
begin
  result:=nil;
  for n:=0 to fAll.count-1 do
  begin
    if TIndividu(fAll[n]).ClePere=ClePere then
    begin
      result:=TIndividu(fAll[n]);
      break;
    end;
  end;
end;

function TGraphRoue.GetIndividuByCleMere(CleMere:integer):TIndividu;
var
  n:integer;
begin
  result:=nil;
  for n:=0 to fAll.count-1 do
  begin
    if TIndividu(fAll[n]).CleMere=CleMere then
    begin
      result:=TIndividu(fAll[n]);
      break;
    end;
  end;
end;

procedure TGraphRoue.PreparePrint;
var
  w,n:integer;
  b,e,ep,h,ht,wt:extended;
  indi:TIndividu;
  d:extended;
  Lmm,Hmm:single;
  dt:extended;
  s:string;

  procedure ReduceText(var s:string;LngMax:extended);
  var
    Lmm:extended;
  begin
    Lmm:=rm.rp.TextWidth(s);

    if Lmm>=LngMax then
    begin
      repeat
        if length(s)<1 then
        begin
          s:='';
          break;
        end;

        delete(s,length(s),1);
        Lmm:=rm.rp.TextWidth(s+'...');
      until (Lmm<=LngMax);

      s:=s+'...';
    end;
  end;

  procedure PlacePrintTexteIndiCentral(text:string;indi:TIndividu;moins_n_mm:integer;aPlot:TPlot;var TextAff:string);
  var
    s:string;
    lngmax:extended;
    py,a,b,c,d,x1,x2,xr,v:extended;
  begin
    s:=trim(text);
    TextAff:=s;
    aPlot.XI:=0;
    aPlot.YI:=0;

    if s<>'' then
    begin
        //on cherche la droite horizontale qui passe par le haut du texte, et qui coupe le cercle
      try
        py:=TPlotList(fCercleList[indi.level])[indi.idxPlotCentre].YC+moins_n_mm+_Context.RoueDecalageIndiCentral;
        a:=1;
        b:=-2*fCentre.XC;
        c:=-sqr(_Context.RoueRayon)+sqr(py-fCentre.YC)+sqr(fCentre.XC);
        d:=sqr(b)-(4*a*c);
        x1:=(-b+sqrt(d))/(2*a);
        x2:=(-b-sqrt(d))/(2*a);
        lngmax:=norme(x1,py,x2,py);

          //R?duction de la taille du texte, si ?a tient pas
        ReduceText(s,lngmax);
        TextAff:=s;

          //On positionne le texte
        if x1>x2 then
        begin xr:=x1;
          x1:=x2;
          x2:=xr;
        end;

        Lmm:=rm.rp.TextWidth(s);
        Hmm:=RPTFTextHeight(rm.rp,s);

        v:=(x2-x1-Lmm)/2;
        if v<0 then v:=0;

        aPlot.XI:=x1+v;
        aPlot.YI:=py+Hmm;
      except

      end;
    end;
  end;

  procedure calcPlotText(text:string;indi:TIndividu;moins_n_mm:integer;aPlot:TPlot;var NomAff:string);
  var
    s:string;
    x,y:extended;
    lng,lngmax:extended;
    xa,ya,xb,yb:extended;
    LargeurMaxPossibleText,Hmm:extended;
  begin
    s:=trim(text);
    NomAff:=s;

    if s<>'' then
    begin
      Hmm:=RPTFTextHeight(rm.rp,s);

      TrouveCoords(
        fCentre.XC,
        fCentre.YC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre+1].XC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre+1].YC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre].XC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre].YC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre-1].XC,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCentre-1].YC,
        moins_n_mm+Hmm,
        xa,ya,xb,yb);

      Lmm:=rm.rp.TextWidth(s);
      lngmax:=norme(xa,ya,xb,yb);

      if LargeurPossibleTexte(xa,ya,xb,yb,fCentre.XC,fCentre.YC,_Context.RoueRayon*(indi.level+1),LargeurMaxPossibleText) then
      begin
        LargeurMaxPossibleText:=min(LargeurMaxPossibleText,lngmax);
        begin
          reduceText(s,LargeurMaxPossibleText);
          Lmm:=rm.rp.TextWidth(s);
          NomAff:=s;
        end;
      end;

      lng:=(lngMax-Lmm)/2;

      TrouvePoint(xa,ya,xb,yb,
        Lng,
        x,
        y);

      aPlot.XI:=x;//x+ fCentre.XC;
      aPlot.YI:=y;//fCentre.YC -y;
    end
    else
    begin
      aPlot.XI:=0;
      aPlot.YI:=0;
    end;
  end;

begin
  //on r?cup?re la font ? utilisez, avec la taille en 100 %
  rm.rp.SetFont(fFontText.Name,fFontText.Size);
  rm.rp.Bold:=(fsBold in fFontText.Style);
  rm.rp.Underline:=(fsUnderLine in fFontText.Style);
  rm.rp.Italic:=(fsItalic in fFontText.Style);
  rm.rp.StrikeOut:=(fsStrikeOut in fFontText.Style);
  rm.rp.FontColor:=fFontText.Color;

  for n:=0 to fAll.Count-1 do
  begin
    indi:=TIndividu(fAll[n]);

      //combien de quartiers ?
    w:=trunc(Ldexp(1,indi.level+1));

      //Nb de degr? d'un quartier (du niveau supp?rieur)
    e:=_Context.RoueAngle/(w);

      //angle de d?marrage
    b:=(_Context.RoueAngle-180)/2;

    if indi.level<=fLevelMaxTexteNormal then
    begin
          //angle au point central du quartier

          //-------------------------------------
          //on calcul le point de d?marrage du texte

      if n=0 then
      begin
              //seulement pour l'individu central
        PlacePrintTexteIndiCentral(indi.Nom,indi,_Context.RoueDistNom,indi.PlotNom,s);
        indi.AffPrintNom:=s;
        PlacePrintTexteIndiCentral(indi.Prenom,indi,_Context.RoueDistPrenom,indi.PlotPrenom,s);
        indi.AffPrintPrenom:=s;
        PlacePrintTexteIndiCentral(indi.Prof,indi,_Context.RoueDistProfession,indi.PlotProf,s);
        indi.AffPrintProf:=s;
        PlacePrintTexteIndiCentral(indi.Naissance,indi,_Context.RoueDistNaissance,indi.PlotNaissance,s);
        indi.AffPrintNaissance:=s;
        PlacePrintTexteIndiCentral(indi.Deces,indi,_Context.RoueDistDeces,indi.PlotDeces,s);
        indi.AffPrintDeces:=s;
      end
      else
      begin
        calcPlotText(indi.Nom,indi,_Context.RoueDistNom,indi.PlotNom,s);
        indi.AffPrintNom:=s;
        calcPlotText(indi.Prenom,indi,_Context.RoueDistPrenom,indi.PlotPrenom,s);
        indi.AffPrintPrenom:=s;
        calcPlotText(indi.Prof,indi,_Context.RoueDistProfession,indi.PlotProf,s);
        indi.AffPrintProf:=s;
        calcPlotText(indi.Naissance,indi,_Context.RoueDistNaissance,indi.PlotNaissance,s);
        indi.AffPrintNaissance:=s;
        calcPlotText(indi.Deces,indi,_Context.RoueDistDeces,indi.PlotDeces,s);
        indi.AffPrintDeces:=s;
      end;
    end
    else
        //texte apres levelMax
    begin
          //angle au point gauche du quartier
      d:=(indi.idxPlotCentre*e)-b;
      Ht:=RPTFTextHeight(rm.rp,indi.Nom);
      dt:=arcsin((Ht/2)/(indi.level*_Context.RoueRayon));
          //rayon pour cette g?n?ration
      h:=(indi.level*_Context.RoueRayon)+0.5;

      ep:=DegToRad(d);
      indi.PlotNom.XI:=(h*cos(ep))+fCentre.XC;
      indi.PlotNom.YI:=fCentre.YC-(h*sin(ep));
      indi.AnglePrintNom:=round(10*(radtodeg(ep)));
      s:=indi.Nom;
      ReduceText(s,(_Context.RoueRayon-0.5));
      indi.AffPrintNom:=s;

          //inversion
      if d>=90 then
      begin
        Wt:=rm.rp.TextWidth(indi.AffPrintNom);
        ep:=DegToRad(d);
        indi.PlotNom.XI:=((h+Wt)*cos(ep))+fCentre.XC;
        indi.PlotNom.YI:=fCentre.YC-((h+Wt)*sin(ep));
        indi.AnglePrintNom:=round(10*(radtodeg(ep)+180));
        if indi.AnglePrintNom>3600 then indi.AnglePrintNom:=indi.AnglePrintNom-3600;
      end;

      ep:=DegToRad(d)-dt-dt;
      indi.PlotPrenom.XI:=(h*cos(ep))+fCentre.XC;
      indi.PlotPrenom.YI:=fCentre.YC-(h*sin(ep));
      indi.AnglePrintPrenom:=round(10*(radtodeg(ep)));
      s:=indi.Prenom;
      ReduceText(s,(_Context.RoueRayon-0.5));
      indi.AffPrintPrenom:=s;

          //inversion
      if d>=90 then
      begin
        Wt:=rm.rp.TextWidth(indi.AffPrintPrenom);
        ep:=DegToRad(d)+dt+dt;
        indi.PlotPrenom.XI:=((h+Wt)*cos(ep))+fCentre.XC;
        indi.PlotPrenom.YI:=fCentre.YC-((h+Wt)*sin(ep));
        indi.AnglePrintPrenom:=round(10*(radtodeg(ep)+180));
        if indi.AnglePrintPrenom>3600 then indi.AnglePrintPrenom:=indi.AnglePrintPrenom-3600;
      end;
    end;
  end;
end;

procedure TGraphRoue.Print(rp:TReportPrinter);
var
  n,k:integer;
  indi:TIndividu;
  DecalX,DecalY:extended;
  w,i,p:integer;
  aCercle,LastCercle:TPlotList;
  rf:TFloatRect;
  F,FR:TSaveFont;

  procedure PrintTheText(R:TRect;Text:string);
  var
    w,h,l:double;
    OkName:boolean;
  begin
    w:=rp.TextWidth(text);
    h:=RPTFTextHeight(rp,text);

    //est-ce que le nom du pieu rentre dans le rectangle de d?limitation ?
    okName:=(w<=abs(R.right-R.Left+1));

    //soit le texte entre dans le rectangle
    if okName then
    begin
      l:=(abs(R.left-R.right)-w)/2;
      rp.PrintXY(R.left+l,R.top+h,text);
    end
    else
    begin
      rp.TextRect(R,R.left,R.top+h,text);
    end;
  end;

  function MyCreateRect(X1,Y1,X2,Y2:double):TRect;
  begin{ CreateRect }
    Result.Left:=round(X1);
    Result.Top:=round(Y1);
    Result.Right:=round(X2);
    Result.Bottom:=round(Y2);
  end;

begin
  DecalX:=rp.MarginLeft+rm.DecalagePapierX;
  DecalY:=rp.MarginTop+rm.DecalagePapierY;

  //on r?cup?re la font ? utilisez, avec la taille en 100 %
  rp.SetFont(fFontText.Name,fFontText.Size);
  rp.Bold:=(fsBold in fFontText.Style);
  rp.Underline:=(fsUnderLine in fFontText.Style);
  rp.Italic:=(fsItalic in fFontText.Style);
  rp.StrikeOut:=(fsStrikeOut in fFontText.Style);
  rp.FontColor:=fFontText.Color;

  LastCercle:=TPlotList(fCercleList.last);
  for n:=0 to fCercleList.Count-1 do
  begin
    aCercle:=TPlotList(fCercleList[n]);
    w:=round((n+1)*_Context.RoueRayon);

    Rf.left:=fCentre.XC-w+DecalX;
    Rf.right:=fCentre.XC+w+DecalX;
    Rf.top:=fCentre.YC-w+DecalY;
    Rf.bottom:=fCentre.YC+w+DecalY;

    rp.SetPen(_Context.RoueCouleurCercle,psSolid,2,pmCopy);
    rp.SetBrush(clBlack,bsClear,nil);

    rp.Arc(
      Rf.Left,Rf.Top,
      Rf.Right,Rf.Bottom,
      aCercle[0].XC+DecalX,
      aCercle[0].YC+DecalY,
      aCercle.last.XC+DecalX,
      aCercle.last.YC+DecalY);

    rp.SetPen(_Context.RoueCouleurRayon,psSolid,2,pmCopy);

    p:=trunc(Ldexp(1,fCercleList.Count-n-1));
    i:=p;
    for k:=1 to aCercle.count-2 do
    begin
      rp.MoveTo(aCercle[k].XC+DecalX,aCercle[k].YC+DecalY);
      rp.LineTo(LastCercle[i].XC+DecalX,LastCercle[i].YC+DecalY);
      i:=i+p;
    end;
  end;

  //les lignes
  rp.SetPen(_Context.RoueCouleurRayon,psSolid,2,pmCopy);
  if fCercleList.Count>0 then
  begin
    if _Context.RoueAngle<>360 then
    begin
      rp.MoveTo(LastCercle[0].XC+DecalX,LastCercle[0].YC+DecalY);
      rp.LineTo(fCentre.XC+DecalX,fCentre.YC+DecalY);
      rp.LineTo(LastCercle.last.XC+DecalX,LastCercle.last.YC+DecalY);
    end
    else
    begin
      aCercle:=TPlotList(fCercleList[0]);
      if aCercle<>nil then
      begin
        rp.MoveTo(aCercle[0].XC+DecalX,aCercle[0].YC+DecalY);
        rp.LineTo(LastCercle[0].XC+DecalX,LastCercle[0].YC+DecalY);
      end;
    end;
  end;

  begin
    //les individus
    for n:=0 to fAll.Count-1 do
    begin
      indi:=TIndividu(fAll[n]);

      if indi.Sexe=1 then
        rp.FontColor:=_Context.RoueCouleurTexteHomme
      else
        rp.FontColor:=_Context.RoueCouleurTexteFemme;

      if indi.level<=fLevelMaxTexteNormal then
      begin
        F:=rp.GetBaseFont;
        FR:=F;

        FR.Rotation:=indi.Angle div 10;
        rp.SetBaseFont(FR);

            //le texte
        if _Context.RoueShowNom then
          rp.PrintXY(indi.PlotNom.XI+DecalX,indi.PlotNom.YI+DecalY,indi.AffPrintNom);

        if _Context.RoueShowPrenom then
          rp.PrintXY(indi.PlotPrenom.XI+DecalX,indi.PlotPrenom.YI+DecalY,indi.AffPrintPrenom);

        if _Context.RoueShowProfession then
          rp.PrintXY(indi.PlotProf.XI+DecalX,indi.PlotProf.YI+DecalY,indi.AffPrintProf);

        if _Context.RoueShowNaissance then
          rp.PrintXY(indi.PlotNaissance.XI+DecalX,indi.PlotNaissance.YI+DecalY,indi.AffPrintNaissance);

        if _Context.RoueShowDeces then
          rp.PrintXY(indi.PlotDeces.XI+DecalX,indi.PlotDeces.YI+DecalY,indi.AffPrintDeces);
      end
      else
      begin
        F:=rp.GetBaseFont;
        FR:=F;
        FR.Rotation:=indi.AngleNom div 10;
        rp.SetBaseFont(FR);

        if _Context.RoueShowNom then
          rp.PrintXY(indi.PlotNom.XI+DecalX,indi.PlotNom.YI+DecalY,indi.AffPrintNom);

        F:=rp.GetBaseFont;
        FR:=F;
        FR.Rotation:=indi.AnglePrenom div 10;
        rp.SetBaseFont(FR);

        if _Context.RoueShowPrenom then
          rp.PrintXY(indi.PlotPrenom.XI+DecalX,indi.PlotPrenom.YI+DecalY,indi.AffPrintPrenom);

      end;
    end;
  end;
end;

function TGraphRoue.GetCleIndividuAtXY(X,Y:integer;var sNom,sNaisDec:string;var iSexe,iGene,iParent:integer):integer;
begin
  result:=-1;
end;

end.

