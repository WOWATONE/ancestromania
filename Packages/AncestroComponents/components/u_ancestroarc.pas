{-----------------------------------------------------------------------}
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{-----------------------------------------------------------------------}
{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }
{-----------------------------------------------------------------------}
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{-----------------------------------------------------------------------}

unit u_ancestroarc;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, contnrs, Graphics, ExtCtrls, u_common_graph_type,
{$IFDEF FPC}
  LCLType, FPCanvas,
{$ELSE}
  Windows,
{$ENDIF}
  u_objet_graph_TPlot,
  u_ancestroviewer,u_objects_components,
  u_objet_graph_TPlotList,
  SysUtils;

type
  TGraphArcText = (atName, atLastName, atJob, atBirthDay, atDeathDay);
  TGraphArcElement = (ceCircle, ceRayon, ceMen, ceWomen);
  TGraphArcTexts = set of TGraphArcText;
  TGraphArcTextArrayText = array [TGraphArcText] of String;
  TGraphArcTextArrayPlot = array [TGraphArcText] of TPlot;
  TGraphArcElementArray = array [TGraphArcElement] of TColor;

const
  GRAPH_ARC_DEFAULT_COLOR_CIRCLE = clWindowText;
  GRAPH_ARC_DEFAULT_COLOR_RAYON  = clGray;
  GRAPH_ARC_DEFAULT_COLOR_MEN    = clBlue;
  GRAPH_ARC_DEFAULT_COLOR_WOMEN  = clRed;
  GRAPH_ARC_DEFAULT_SHOW_TEXT    = [atName, atLastName,atJob];
  GRAPH_ARC_DEFAULT_RADIUS       = 29;
  GRAPH_ARC_DEFAULT_ANGLE        = 200;
  GRAPH_ARC_DEFAULT_SHIFTING     = 0;
  GRAPH_ARC_DEFAULT_LINE_HEIGHT  = 3;
  GRAPH_ARC_PRINT_FONT_SIZE      = 2.6;

  GRAPH_ARC_INI_RADIUS='ArcRadius';
  GRAPH_ARC_INI_ANGLE ='ArcAngle';
  GRAPH_ARC_INI_CENTERED_SHIFT = 'CenteredPersonShifting';
  GRAPH_ARC_INI_COLOR_CIRCLE = 'ColorCircle';
  GRAPH_ARC_INI_COLOR_RADIUS = 'ColorRadius';
  GRAPH_ARC_INI_COLOR_TEXT_MEN = 'ColorTextMen';
  GRAPH_ARC_INI_COLOR_TEXT_WOMEN = 'ColorTextWomen';
  GRAPH_ARC_INI_SHOW_TEXT = 'ShowText';

type
  TGraphArcData = class;
  { TPersonArc }

  TPersonArc = class  ( TPerson )
  private
    fidxPlotCentre: integer;
    fidxOrdre: integer;
    fAngle: integer;
    fAngleNom: integer;
    fAnglePrenom: integer;
    fAnglePrintNom: integer;
    fAnglePrintPrenom: integer;

  protected

    fOrderTete: integer;
  public
    FTexts        ,
    FShowed      ,
    FShowedPrint : TGraphArcTextArrayText;
    FPlots       : TGraphArcTextArrayPlot;
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Order; virtual;
    procedure CalcAngle ( const MiddleAngle : Double );virtual;
    procedure CalcAngle90 ( const ACanvas : TCanvas ; const ACentre: TPlot; const ATextType : TGraphArcText; const MiddleAngle : Double ; const RoueRayon : Integer; const ADivider : Double; const ab_decal : Boolean; const hauteur : Double );virtual;
    procedure ReduceText(const ACanvas : TCanvas ; var s: string;const LngMax: extended;const ADivider : Double = 1); virtual;
  published

    property idxOrder: integer read fidxOrdre write fidxOrdre;
    property idxPlotCenter: integer read fidxPlotCentre write fidxPlotCentre;
    property Angle: integer read fAngle write fAngle;

    property AngleName: integer read fAngleNom write fAngleNom;
    property AngleLastName: integer read fAnglePrenom write fAnglePrenom;

    property AnglePrintName: integer read fAnglePrintNom write fAnglePrintNom;
    property AnglePrintLastName: integer read fAnglePrintPrenom write fAnglePrintPrenom;

  end;

  { TGraphArcData }

  TGraphArcData = class(TGraphData)

    private
      fStartIndividu: TPersonArc;
      fCentre: TPlot;
      fCercleList: TObjectList;
    protected
      procedure VerifyObjects ( const AGraph : TGraphComponent ); virtual;
    public
      procedure Prepare  ( const ACanvas : TCanvas ); override;
      procedure PreparePrint; override;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;

      procedure Order; override;

      property FirstPerson : TPersonArc read fStartIndividu;
    End;

  TGraphArc = class(TGraphComponent)

  private
    EPrintFont: TPaintFont;
    FRoueAngle, FRoueDecalageIndiCentral, FRoueRayon : Integer;
    fRayonV, fRayonM: Double;
    FShowTexts: TGraphArcTexts;

    FColors:TGraphArcElementArray;

    EPrintTextRect : TPaintTextRect;
    EPrintText     : TPaintText;
    EPrintArc      : TPaintArc;
    EPrintMoveTo   ,
    EPrintLineTo   : TPaintCoord;
    EPrintBrushSet : TPaintBrushSet;
    EPrintPenSet   : TPaintPenSet;
    EPrintColor    : TPaintColor;

    fHeightFont: integer;

    fLevelMaxTexteNormal: integer;
    procedure SetRadius( const AValue: integer);
    procedure SetAngle(const AValue: integer);
    function GetAColor(const AIndex: TGraphArcElement): TColor;
    procedure SetAColor ( const AIndex : TGraphArcElement; const AValue: TColor);
  protected
    procedure PaintTextXY(const aleft, atop:Double;const s: string;const Angle: Integer); virtual;
    procedure PaintTextRect(var ARect : TFloatRect;const aleft, atop:Double;const s: string;const Angle: Integer);virtual;
    procedure PaintSetPen(const AColor:TColor;const PenStyle : {$IFDEF FPC}TFPPenStyle{$ENDIF}; const PenWidth : Double ; const PenMode : {$IFDEF FPC}TFPPenMode{$ENDIF}); virtual;
    procedure PaintSetBrush(const AColor:TColor;const BrushStyle : {$IFDEF FPC}TFPBrushStyle{$ENDIF}); virtual;
    procedure PaintOutArc(const ARect : TFloatRect ; const ABeginArcXC, ABeginArcYC, AEndArcXC, AEndArcYC : Extended ); virtual;
    procedure PaintOutMoveTo(const AX, AY : Extended ); virtual;
    procedure PaintOutLineTo(const AX, AY : Extended ); virtual;
    procedure PaintFont (const AFont : TFont ; const AFontSize : Double); virtual;

    procedure InitGraph(const coef:Single); override;
    procedure InitGraphMiniature(const coef:Single); override;

    procedure PaintGraph(const ACanvas : TCanvas ; const DecalX,DecalY:integer); override;
    procedure PaintGraphMiniature(const DecalX,DecalY:integer); override;
  public
    procedure ReadSectionIni; override;
    procedure WriteSectionIni; override;

    function GetIndividuByCleMere(const KeyMother: integer): TPersonArc; virtual;
    function GetIndividuByClePere(const KeyFather: integer): TPersonArc; virtual;
    constructor Create ( AOwner : TComponent ); override;
    procedure Print(const DecalX,DecalY:Extended); override;

    procedure GetRectEncadrement(var R: TFloatRect); override;
    function GetCleIndividuAtXY(const X,Y:integer;var sNom,sNaisDec:string;var iSexe,iGene,iParent:integer):integer; override;
    procedure SetCheckShow(const AShow : TGraphArcText; const ACheck : Boolean ); virtual;
  published
    property ArcRadius: integer read FRoueRayon write SetRadius default GRAPH_ARC_DEFAULT_RADIUS;
    property ArcAngle: integer read FRoueAngle write SetAngle default GRAPH_ARC_DEFAULT_ANGLE;
    property CenteredPersonShifting: integer read FRoueDecalageIndiCentral
      write FRoueDecalageIndiCentral default GRAPH_ARC_DEFAULT_SHIFTING;
    property ColorCircle: TColor index ceCircle read GetAColor
      write SetAColor default GRAPH_ARC_DEFAULT_COLOR_CIRCLE;
    property ColorRadius: TColor index ceRayon read GetAColor
      write SetAColor default GRAPH_ARC_DEFAULT_COLOR_RAYON;
    property ColorTextMen: TColor index ceMen read GetAColor
      write SetAColor default GRAPH_ARC_DEFAULT_COLOR_MEN;
    property ColorTextWomen: TColor index ceWomen read GetAColor
      write SetAColor default GRAPH_ARC_DEFAULT_COLOR_WOMEN;
    property ShowText: TGraphArcTexts read FShowTexts write FShowTexts default
      GRAPH_ARC_DEFAULT_SHOW_TEXT;
    property PrintOutTextXY : TPaintText read EPrintText write EPrintText;
    property PrintSetRectXY : TPaintTextRect read EPrintTextRect write EPrintTextRect;
    property PrintFont     : TPaintFont   read EPrintFont write EPrintFont;
    property PrintArc      : TPaintArc read EPrintArc write EPrintArc;
    property PrintMoveTo   : TPaintCoord read EPrintMoveTo write EPrintMoveTo;
    property PrintLineTo   : TPaintCoord read EPrintLineTo write EPrintLineTo;
    property PrintBrushSet : TPaintBrushSet read EPrintBrushSet write EPrintBrushSet;
    property PrintPenSet   : TPaintPenSet read EPrintPenSet write EPrintPenSet;
    property PrintColor    : TPaintColor read EPrintColor write EPrintColor;
  end;

implementation

uses
  Math,
  u_common_graph_func,
  fonctions_dialogs,
  Controls,
  u_common_functions, Dialogs;

{ TGraphArcData }

constructor TGraphArcData.Create ( AOwner : TComponent );
begin
  inherited Create ( AOwner );
  fStartIndividu := TPersonArc.Create;
  fCentre := TPlot.Create;
  fCercleList := TObjectList.Create;
End;
procedure TGraphArcData.Order;
begin
  fStartIndividu.Order;
end;
destructor TGraphArcData.Destroy;
begin
  fCentre.Free;
  fCercleList.Free;
  fStartIndividu.Free;
  inherited Destroy;
end;


{ TGraphArc }

procedure TGraphArc.InitGraphMiniature(const coef: Single );
var
  n, k: integer;
  aCercle: TPlotList;
begin
  if not Assigned ( Data ) Then Exit;
  //le centre
  with TGraphArcData(Data) do
    Begin
      FCentre.CoordChantier_2_CoordMiniature(coef);

      //les cercles
      for n := 0 to fCercleList.Count - 1 do
      begin
        aCercle := TPlotList(fCercleList[n]);
        for k := 0 to aCercle.Count - 1 do
          aCercle[k].CoordChantier_2_CoordMiniature(coef);
      end;
    end;

  //Le Radius
  fRayonM := round(coef * FRoueRayon);
end;

procedure TGraphArc.InitGraph(const coef: Single );
var
  n, k: integer;
  TextElement : TGraphArcText;
  aCercle: TPlotList;
begin
  if not Assigned ( Data ) Then Exit;
  with TGraphArcData(Data) do
    Begin
      //le centre
      fCentre.CoordChantier_2_CoordViewer(coef);

      //les cercles
      for n := 0 to fCercleList.Count - 1 do
      begin
        aCercle := TPlotList(fCercleList[n]);
        for k := 0 to aCercle.Count - 1 do
          aCercle[k].CoordChantier_2_CoordViewer(coef);
      end;
    end;

  //le Radius
  fRayonV := round(coef * FRoueRayon);

  //les individus
  with Data do
    for n := 0 to Persons.Count - 1 do
      for TextElement := low(TGraphArcText) to high(TGraphArcText) do
        TPersonArc(Persons[n]).FPlots[TextElement].CoordChantier_2_CoordViewer(coef);

  fHeightFont := round((coef * 25.4 * Font.Size) / 72);
end;

constructor TGraphArc.Create ( AOwner : TComponent );
begin
  inherited Create ( AOwner );

  FColors [ceCircle] := GRAPH_ARC_DEFAULT_COLOR_CIRCLE;
  FColors [ceRayon ] := GRAPH_ARC_DEFAULT_COLOR_RAYON;
  FColors [ceMen   ] := GRAPH_ARC_DEFAULT_COLOR_MEN;
  FColors [ceWomen ] := GRAPH_ARC_DEFAULT_COLOR_WOMEN;
  FShowTexts := GRAPH_ARC_DEFAULT_SHOW_TEXT;
  FRoueRayon := GRAPH_ARC_DEFAULT_RADIUS;
  FRoueAngle := GRAPH_ARC_DEFAULT_ANGLE;
  FRoueDecalageIndiCentral := GRAPH_ARC_DEFAULT_SHIFTING ;

  fLevelMaxTexteNormal := 3;
  Font.Name:='Tahoma';
  Font.Size:=4;
  Font.Color:=clWindowText;
end;


function TGraphArc.GetAColor(const AIndex: TGraphArcElement): TColor;
Begin
   Result := FColors[AIndex];
End;

procedure TGraphArc.SetAColor ( const AIndex : TGraphArcElement; const AValue: TColor);
Begin
   FColors[AIndex]:=AValue;
End;

procedure TGraphArc.PaintTextXY(const aleft, atop:Double;const s: string;const Angle: Integer);
Begin
  if assigned ( EPrintText ) Then
    EPrintText ( Self, s, aleft, atop, Angle )
  else
    AbortMessage('You have to set PrintOutTextXY Event.');
End;


procedure TGraphArc.PaintTextRect(var ARect : TFloatRect;const aleft, atop:Double;const s: string;const Angle: Integer);
Begin
  if assigned ( EPrintTextRect ) Then
    EPrintTextRect ( Self, ARect, s, aleft, atop,  Angle )
  else
    AbortMessage('You have to set PrintSetRectXY Event.');
End;

procedure TGraphArc.PaintSetPen(const AColor:TColor;const PenStyle : {$IFDEF FPC}TFPPenStyle{$ENDIF}; const PenWidth : Double ; const PenMode : {$IFDEF FPC}TFPPenMode{$ENDIF});
Begin
  if assigned ( EPrintPenSet ) Then
    EPrintPenSet ( Self, AColor, PenStyle, PenWidth, PenMode )
  else
    AbortMessage('You have to set PrintPenSet Event.');
End;

procedure TGraphArc.PaintSetBrush(const AColor:TColor;const BrushStyle : {$IFDEF FPC}TFPBrushStyle{$ENDIF});
Begin
  if assigned ( EPrintBrushSet ) Then
    EPrintBrushSet ( Self, AColor, BrushStyle )
  else
    AbortMessage('You have to set PrintBrushSet Event.');
End;

procedure TGraphArc.PaintOutArc(const ARect : TFloatRect ; const ABeginArcXC, ABeginArcYC, AEndArcXC, AEndArcYC : Extended );
Begin
  if assigned ( EPrintArc ) Then
    EPrintArc ( Self, ARect, ABeginArcXC, ABeginArcYC, AEndArcXC, AEndArcYC )
  else
    AbortMessage('You have to set PrintArc Event.');
End;

procedure TGraphArc.PaintOutMoveTo(const AX, AY : Extended );
Begin
  if assigned ( EPrintMoveTo ) Then
    EPrintMoveTo ( Self, AX, AY )
  else
    AbortMessage('You have to set PrintMoveTo Event.');
End;

procedure TGraphArc.PaintOutLineTo(const AX, AY : Extended );
Begin
  if assigned ( EPrintLineTo ) Then
    EPrintLineTo ( Self, AX, AY )
  else
    AbortMessage('You have to set PrintLineTo Event.');
End;

procedure TGraphArc.PaintFont(const AFont: TFont; const AFontSize : Double);
begin
  if assigned ( EPrintFont ) then
    EPrintFont ( Self, Afont, AFontSize );
end;

procedure TGraphArc.GetRectEncadrement(var R: TFloatRect);
var
  n, k: integer;
  aCercle: TPlotList;
begin
  //Rectangle de délimitation de tout le chantier, en m
  R.left := Maxint;
  R.Top := Maxint;
  R.Right := -Maxint;
  R.Bottom := -Maxint;

  //le centre
  with ( TGraphArcData ( Data )) do
    begin
      if R.Left > fCentre.XC then
        R.Left := fCentre.XC;
      if R.Right < fCentre.XC then
        R.Right := fCentre.XC;
      if R.Top > fCentre.YC then
        R.Top := fCentre.YC;
      if R.Bottom < fCentre.YC then
        R.Bottom := fCentre.YC;

      //les cercles
      for n := 0 to fCercleList.Count - 1 do
      begin
        aCercle := TPlotList(fCercleList[n]);
        for k := 0 to aCercle.Count - 1 do
        begin
          if R.Left > aCercle[k].XC then
            R.Left := aCercle[k].XC;
          if R.Right < aCercle[k].XC then
            R.Right := aCercle[k].XC;
          if R.Top > aCercle[k].YC then
            R.Top := aCercle[k].YC;
          if R.Bottom < aCercle[k].YC then
            R.Bottom := aCercle[k].YC;
        end;
      end;

    end;
  R.Right := R.Right + MargeLeft;
  R.Bottom := R.Bottom + MargeTop;
end;

procedure TGraphArc.PaintGraph(const ACanvas : TCanvas ; const DecalX, DecalY: integer);
var
  n, k, w, i, p: integer;
  aCercle, LastCercle: TPlotList;
  TextElement : TGraphArcText;
  R: TRect;
  indi: TPersonArc;
begin
  //on adapte la taille en fonction du zoom
  ACanvas.Font.Size := fHeightFont;

  ACanvas.Pen.Style := psSolid;

  ACanvas.Brush.Style := bsClear;

  //les cercles

  with ( TGraphArcData ( Data )) do
    begin
      LastCercle := TPlotList(fCercleList.last);
      for n := 0 to fCercleList.Count - 1 do
      begin
        aCercle := TPlotList(fCercleList[n]);

        w := round((n + 1) * fRayonV);

        R.left := fCentre.XV - w + DecalX;
        R.right := fCentre.XV + w + DecalX;
        R.top := fCentre.YV - w + DecalY;
        R.bottom := fCentre.YV + w + DecalY;

        ACanvas.Pen.Color:=FColors[ceCircle];

        ACanvas.Arc(
          R.Left, R.Top,
          R.Right, R.Bottom,
          aCercle[0].XV + DecalX,
          aCercle[0].YV + DecalY,
          aCercle.last.XV + DecalX,
          aCercle.last.YV + DecalY);

        ACanvas.Pen.Color := FColors[ceRayon];
        p := trunc(Ldexp(1, fCercleList.Count - n - 1));
        i := p;
        for k := 1 to aCercle.Count - 2 do
        begin
          ACanvas.MoveTo(aCercle[k].XV + DecalX, aCercle[k].YV + DecalY);
          ACanvas.LineTo(LastCercle[i].XV + DecalX, LastCercle[i].YV + DecalY);
          i := i + p;
        end;
      end;

      //les lignes
      ACanvas.Pen.Color := FColors[ceRayon];
      if fCercleList.Count > 0 then
      begin
        if FRoueAngle <> 360 then
        begin
          ACanvas.MoveTo(LastCercle[0].XV + DecalX, LastCercle[0].YV + DecalY);
          ACanvas.LineTo(fCentre.XV + DecalX, fCentre.YV + DecalY);
          ACanvas.LineTo(LastCercle.last.XV + DecalX, LastCercle.last.YV + DecalY);
        end
        else
        begin
          aCercle := TPlotList(fCercleList[0]);
          if aCercle <> nil then
          begin
            ACanvas.MoveTo(aCercle[0].XV + DecalX, aCercle[0].YV + DecalY);
            ACanvas.LineTo(LastCercle[0].XV + DecalX, LastCercle[0].YV + DecalY);
          end;
        end;
      end;

      if fHeightFont >= 1 then
       begin
        //les individus
        for n := 0 to Persons.Count - 1 do
        begin
          indi := TPersonArc(Persons[n]);

          with indi do
            Begin
              if Sexe = 1 then
                ACanvas.Font.Color := FColors[ceMen]
              else
                ACanvas.Font.Color := FColors[ceWomen];

              if level <= fLevelMaxTexteNormal then
              begin
                SetFontAngle(ACanvas.Font, Angle);

                //le texte
                for TextElement := low(TGraphArcText) to high(TGraphArcText) do
                  ACanvas.TextOut(FPlots[TextElement].XV + DecalX, FPlots[TextElement].YV +
                    DecalY, FShowed[TextElement]);

              end
              else
              begin
                SetFontAngle(ACanvas.Font, AngleName);

                if atName in FShowTexts then
                  ACanvas.TextOut(FPlots[atName].XV + DecalX, FPlots[atName].YV +
                    DecalY, FShowed[atName]);

                SetFontAngle(ACanvas.Font, AngleLastName);

                if atLastName in FShowTexts then
                  ACanvas.TextOut(FPlots[atLastName].XV + DecalX,
                    FPlots[atLastName].YV + DecalY, FShowed[atLastName]);
        //        writeln(IntToStr (PlotName.YV)+' ' +IntToStr (PlotName.XV)+' '+IntToStr (Angle)+' ');
              end;
            end;
        end;
      end;

    end;

end;

procedure TGraphArc.PaintGraphMiniature(
  const DecalX, DecalY: integer);
var
  n, k, w, i, p: integer;
  aCercle, LastCercle: TPlotList;
  R: TRect;
begin
  Canvas.Pen.Color := clRed;
  Canvas.Pen.Style := psSolid;

  with ( TGraphArcData ( Data )) do
    begin
      LastCercle := TPlotList(fCercleList.last);

      for n := 0 to fCercleList.Count - 1 do
      begin
        aCercle := TPlotList(fCercleList[n]);
        w := round((n + 1) * fRayonM);

        R.left := fCentre.XM - w + DecalX;
        R.right := fCentre.XM + w + DecalX;
        R.top := fCentre.YM - w + DecalY;
        R.bottom := fCentre.YM + w + DecalY;

        Canvas.Arc(
          R.Left, R.Top,
          R.Right, R.Bottom,
          aCercle[0].XM + DecalX,
          aCercle[0].YM + DecalY,
          aCercle.last.XM + DecalX,
          aCercle.last.YM + DecalY);

        p := trunc(Ldexp(1, fCercleList.Count - n - 1));
        i := p;
        for k := 1 to aCercle.Count - 2 do
        begin
          Canvas.MoveTo(aCercle[k].XM + DecalX, aCercle[k].YM + DecalY);
          Canvas.LineTo(LastCercle[i].XM + DecalX, LastCercle[i].YM + DecalY);
          i := i + p;
        end;

      end;

      if fCercleList.Count > 0 then
      begin
        if FRoueAngle <> 360 then
        begin
          Canvas.MoveTo(LastCercle[0].XM + DecalX, LastCercle[0].YM + DecalY);
          Canvas.LineTo(fCentre.XM + DecalX, fCentre.YM + DecalY);
          Canvas.LineTo(LastCercle.last.XM + DecalX, LastCercle.last.YM + DecalY);
        end
        else
        begin
          aCercle := TPlotList(fCercleList[0]);
          if aCercle <> nil then
          begin
            Canvas.MoveTo(aCercle[0].XM + DecalX, aCercle[0].YM + DecalY);
            Canvas.LineTo(LastCercle[0].XM + DecalX, LastCercle[0].YM + DecalY);
          end;
        end;
      end;

    end;
end;

procedure TGraphArc.ReadSectionIni;
begin
  inherited ReadSectionIni;
  ReadInteger(GRAPH_ARC_INI_ANGLE);
  ReadInteger(GRAPH_ARC_INI_CENTERED_SHIFT);
  ReadInteger(GRAPH_ARC_INI_COLOR_RADIUS);
  ReadInteger(GRAPH_ARC_INI_COLOR_TEXT_MEN);
  ReadInteger(GRAPH_ARC_INI_COLOR_TEXT_WOMEN);
  ReadInteger(GRAPH_ARC_INI_RADIUS);
  ReadSet    (GRAPH_ARC_INI_SHOW_TEXT);
end;

procedure TGraphArc.WriteSectionIni;
begin
  inherited WriteSectionIni;
  WriteInteger(GRAPH_ARC_INI_ANGLE);
  WriteInteger(GRAPH_ARC_INI_CENTERED_SHIFT);
  WriteInteger(GRAPH_ARC_INI_COLOR_RADIUS);
  WriteInteger(GRAPH_ARC_INI_COLOR_TEXT_MEN);
  WriteInteger(GRAPH_ARC_INI_COLOR_TEXT_WOMEN);
  WriteInteger(GRAPH_ARC_INI_RADIUS);
  WriteSet    (GRAPH_ARC_INI_SHOW_TEXT);
end;

procedure TGraphArcData.VerifyObjects(const AGraph: TGraphComponent);
begin
  if not ( AGraph is TGraphArc ) Then
    AbortMessage('Please set a TGraphTreeData type on TGraphViewer.Data.');

end;

procedure TGraphArcData.Prepare  ( const ACanvas : TCanvas );
var
  pies, n: integer;
  Middle, piesDegrees, radius, h, edep, wt: extended;
  TextElement : TGraphArcText;
  aCercle: TPlotList;
  aPlot: TPlot;
  indi: TPersonArc;
  MiddleAngle: extended;
  Lmm,ht: Double;
  x, y: extended;
  xa, ya, xb, yb: extended;
  s: string;

  procedure PlaceTexteIndi0(Text: string; indi: TPersonArc; moins_n_mm: integer; aPlot: TPlot);
  var
    s: string;
    x, y: extended;
    lng, lngmax: extended;
  begin
    s := trim(Text);
    if s <> '' then
    with TGraphArc ( Graph ) do
    begin
      Lmm := ACanvas.TextWidth(s) / (72 / 25.4);
      lngmax := norme(fCentre.XC - FRoueRayon, TPlotList(fCercleList[indi.level])
        [indi.idxPlotCenter].YC + moins_n_mm, fCentre.XC + FRoueRayon,
        TPlotList(fCercleList[indi.level])[indi.idxPlotCenter].YC + moins_n_mm);

      lng := (lngMax - Lmm) / 2;
      x := 0;
      y := 0;
      TrouvePoint(
        fCentre.XC - FRoueRayon, TPlotList(fCercleList[indi.level])
        [indi.idxPlotCenter].YC + moins_n_mm,
        fCentre.XC + FRoueRayon, TPlotList(fCercleList[indi.level])
        [indi.idxPlotCenter].YC + moins_n_mm,
        Lng,
        x,
        y);

      aPlot.XC := x;//x+ fCentre.XC;
      aPlot.YC := y;//fCentre.YC -y;
    end
    else
    begin
      aPlot.XC := 0;
      aPlot.YC := 0;
    end;
  end;

  procedure PlaceTexteIndiCentral(const Text: string; indi: TPersonArc;
    var moins_n_mm: Integer; const aPlot: TPlot; var TextAff: string);
  var
    s: string;
    lngmax: extended;
    py, a, b, c, d, x1, x2, xr, v: extended;
  begin
    s := trim(Text);
    TextAff := s;
    aPlot.XC := 0;
    aPlot.YC := 0;

    if s <> '' then
    with TGraphArc ( Graph ) do
    begin
      //on cherche la droite horizontale qui passe par le haut du texte, et qui coupe le cercle
      try
        py := TPlotList(fCercleList[indi.level])
          [indi.idxPlotCenter].YC + moins_n_mm + FRoueDecalageIndiCentral;
        a := 1;
        b := -2 * fCentre.XC;
        c := -sqr(FRoueRayon) + sqr(py - fCentre.YC) + sqr(fCentre.XC);
        d := sqr(b) - (4 * a * c);
        x1 := (-b + sqrt(d)) / (2 * a);
        x2 := (-b - sqrt(d)) / (2 * a);
        lngmax := norme(x1, py, x2, py);

        //Réduction de la taille du texte, si ça tient pas
        indi.ReduceText(ACanvas,s, lngmax, 72 / 25.4);
        TextAff := s;

        //On positionne le texte
        if x1 > x2 then
        begin
          xr := x1;
          x1 := x2;
          x2 := xr;
        end;
        Lmm := Canvas.TextWidth(s) / (72 / 25.4);

        v := (x2 - x1 - Lmm) / 2;
        if v < 0 then
          v := 0;

        aPlot.XC := x1 + v;
        aPlot.YC := py;
      except

      end;
    end;
  end;

  procedure calcPlotText(Text: string; indi: TPersonArc; moins_n_mm: integer; aPlot: TPlot;
  var NomAff: string);
  var
    s: string;
    x, y: extended;
    lng, lngmax: extended;
    xa, ya, xb, yb: extended;
    LargeurMaxPossibleText: extended;
  begin
    s := trim(Text);
    NomAff := s;

    if s <> '' then
    with TGraphArc ( Graph ) do
    begin
      xa := 0;
      ya := 0;
      xb := 0;
      yb := 0;
      with indi do
        TrouveCoords(
          fCentre.XC,
          fCentre.YC,
          TPlotList(fCercleList[level])[idxPlotCenter + 1].XC,
          TPlotList(fCercleList[level])[idxPlotCenter + 1].YC,
          TPlotList(fCercleList[level])[idxPlotCenter].XC,
          TPlotList(fCercleList[level])[idxPlotCenter].YC,
          TPlotList(fCercleList[level])[idxPlotCenter - 1].XC,
          TPlotList(fCercleList[level])[idxPlotCenter - 1].YC,
          moins_n_mm,
          xa, ya, xb, yb);

      Lmm := ACanvas.TextWidth(s) / (72 / 25.4);
      lngmax := norme(xa, ya, xb, yb);

      LargeurMaxPossibleText:=0;
      if LargeurPossibleTexte(xa, ya, xb, yb, fCentre.XC, fCentre.YC, FRoueRayon *
        (indi.level + 1), LargeurMaxPossibleText) then
      begin
        LargeurMaxPossibleText := min(LargeurMaxPossibleText, lngmax);
        begin
          indi.ReduceText(ACanvas,s, LargeurMaxPossibleText, 72 / 25.4);
          Lmm := Canvas.TextWidth(s) / (72 / 25.4);
          NomAff := s;
        end;
      end;

      lng := (lngMax - Lmm) / 2;

      x := 0;
      y := 0;

      TrouvePoint(xa, ya, xb, yb,
        Lng,
        x,
        y);

      aPlot.XC := x;//x+ fCentre.XC;
      aPlot.YC := y;//fCentre.YC -y;
    end
    else
    begin
      aPlot.XC := 0;
      aPlot.YC := 0;
    end;
  end;

  procedure Init;
  begin
      //on assigne la police, qui correspond à celle utilisée en 100%
    with TGraphArc ( Graph ) do
      begin
        Canvas.Font.Name:=Font.Name;
        Canvas.Font.Size:=Font.Size;

        //on vide les cercles
        fCercleList.Clear;

        //ou est le centre ?
        with Data do
          begin
            fCentre.XC := MargeLeft + (Generations * FRoueRayon);
            fCentre.YC := MargeTop + (Generations * FRoueRayon);
          end;

      end;

  end;
  procedure CalculateCircles;
  var
    n,k: integer;
  begin
    //les cercles
    with TGraphArc ( Graph ) do
    for n := 1 to Generations do
     begin
      //combien de quartiers ?
      pies := trunc(Ldexp(1, n));

      //Nb de degré d'un quartier
      piesDegrees := FRoueAngle / (pies);

      Middle := (FRoueAngle - 180) / 2;

      //Radius pour cette g?n?ration
      h := n * FRoueRayon;

      //création d'un cercle
      aCercle := TPlotList.Create;

      //angle de départ
      edep := 0;

      for k := 1 to pies + 1 do
      begin
        radius := DegToRad(edep - Middle);
        aPlot := TPlot.Create;

        aPlot.XC := (h * cos(radius)) + fCentre.XC;
        aPlot.YC := fCentre.YC - (h * sin(radius));

        aCercle.Add(aPlot);

        xa := 0;
        ya := 0;
        xb := 0;
        yb := 0;

        if TrouveIntersectionCercleDroite(aPlot.XC, aPlot.YC,
          fCentre.XC, fCentre.YC, fCentre.XC, fCentre.YC,
          h, xa, ya, xb, yb) then
        begin
          x := 0;
          y := 0;
          PointLePlusProcheDeP(xa, ya, xb, yb, aPlot.XC, aPlot.YC, x, y);
          aPlot.XC := x;
          aPlot.YC := y;

          if y > 5000 then
          begin
            y := y;
          end;
        end;

        edep := edep + piesDegrees;
      end;
      fCercleList.Add(aCercle);
    end;
  End;
  var ai_TextY : Integer;
begin
  VerifyObjects ( Graph );

  //on assigne la police, qui correspond à celle utilisée en 100%
  Init;

  CalculateCircles;

  with TGraphArc ( Graph ) do
    for n := 0 to Persons.Count - 1 do
      begin
        indi := TPersonArc(Persons[n]);

        //combien de quartiers ?
        pies := trunc(Ldexp(1, indi.level + 1));

        //Nb de degrés d'un quartier (du niveau supérieur)
        piesDegrees := FRoueAngle / pies;

        //angle de démarrage
        Middle := (FRoueAngle - 180) / 2;

        with indi do
         Begin
          //angle au point central du quartier
          MiddleAngle := (idxPlotCenter * piesDegrees) - Middle;

           if level <= fLevelMaxTexteNormal then
            begin

              //-------------------------------------
              //on calcule le point de démarrage du texte
              ai_TextY:=LineHeight+1;

              s := '';
              if n = 0 then
              begin
                //seulement pour l'individu central
                for TextElement := low(TGraphArcText) to high(TGraphArcText) do
                 if TextElement in FShowTexts Then
                  begin
                   PlaceTexteIndiCentral(FTexts [ TextElement], indi, ai_TextY, FPlots[ TextElement], s);
                   inc ( ai_TextY, LineHeight);
                   FShowed [ TextElement ] := s;
                  End;
              end
              else
                for TextElement := low(TGraphArcText) to high(TGraphArcText) do
                 if TextElement in FShowTexts Then
                  begin
                   calcPlotText(FTexts [ TextElement], indi, ai_TextY, FPlots[ TextElement], s);
                   inc ( ai_TextY, LineHeight);
                   FShowed [ TextElement ] := s;
                  End;
              CalcAngle ( MiddleAngle );
        //      writeln(FloatToStr (indi.PlotName.YC)+' ' +FloatToStr (indi.PlotName.XC)+' angle : '+IntToStr (indi.Angle)+' middle : '+FloatToStr (MiddleAngle)+' '+IntToStr (indi.Level)+' ');
            end
          else
            //texte apres levelMax
            begin
              //angle au point gauche du quartier
              ht := LineHeight / (72 / 25.4);
              if atName in FShowTexts Then
               Begin
                CalcAngle90(Canvas,fCentre,atName,MiddleAngle,FRoueRayon,72 / 25.4,False,ht);
                ht := ht + LineHeight / (72 / 25.4);
               end;
              if (atLastName in FShowTexts) or not (atName in FShowTexts) Then
                CalcAngle90(Canvas,fCentre,atLastName,MiddleAngle,FRoueRayon,72 / 25.4,True,ht);


    //            writeln(FloatToStr (FPlots[atName].YC)+' ' +FloatToStr (FPlots[atName].XC)+' '+IntToStr (AngleName)+' '+IntToStr (Level)+' ');
            end;
         end;
      end;

end;

{ TPersonArc }

procedure TPersonArc.Clear;
var TextElement : TGraphArcText;
begin
  for TextElement := low(TGraphArcText) to high(TGraphArcText) do
    Begin
      FShowed[TextElement] := '';
      FShowedPrint[TextElement] := '';
      FTexts[TextElement] := '';
    end;
  fidxOrdre := -1;
  fidxPlotCentre := -1;
  Inherited;
end;

constructor TPersonArc.Create ;
var TextElement : TGraphArcText;
begin
  for TextElement := low(TGraphArcText) to high(TGraphArcText) do
    FPlots[TextElement] := TPlot.Create;
  Inherited Create;
end;

destructor TPersonArc.Destroy;
var TextElement : TGraphArcText;
begin
  for TextElement := low(TGraphArcText) to high(TGraphArcText) do
    FPlots[TextElement].Destroy;
  inherited Destroy;
end;

procedure TPersonArc.Order;
var
  n, k: integer;
begin
  case Childs.Count of
    2:
    begin
      if TPersonArc(Childs[0]).Sexe = 1 then //homme
      begin
        //invertion
        Childs.Exchange(0, 1);
      end;
    end;

  end;

  //on ordonne les suivants
  k := idxOrder * 2;
  if Childs.Count > 1 then
  begin
    for n := 0 to Childs.Count - 1 do
    begin
      TPersonArc(Childs[n]).idxOrder := k + n;
      TPersonArc(Childs[n]).idxPlotCenter := ((k + n) * 2) + 1;

      TPersonArc(Childs[n]).Order;
    end;
  end
  else if Childs.Count = 1 then
  begin
    if TPersonArc(Childs[0]).Sexe = 1 then //homme
    begin
      TPersonArc(Childs[0]).idxOrder := k + 1;
      TPersonArc(Childs[0]).idxPlotCenter := ((k + 1) * 2) + 1;
    end
    else
    begin
      TPersonArc(Childs[0]).idxOrder := k + 0;
      TPersonArc(Childs[0]).idxPlotCenter := ((k + 0) * 2) + 1;
    end;

    TPersonArc(Childs[0]).Order;
  end;
end;

procedure TPersonArc.CalcAngle ( const MiddleAngle : Double );
var TextAngle : Double;
begin
  //angle du texte
  TextAngle := MiddleAngle - 90;
//          write(' angle : '+FloatToStr (TextAngle) + ' ');

  //on remet dans le bon interval
  if TextAngle < 0 then
  begin
    while TextAngle < -360 do
      TextAngle := TextAngle + 360;
    TextAngle := 360 + TextAngle;
  end;
  while TextAngle > 360 do
    TextAngle := TextAngle - 360;

  FAngle := round(10 * TextAngle);
end;

procedure TPersonArc.CalcAngle90(const ACanvas : TCanvas ; const ACentre: TPlot; const ATextType : TGraphArcText; const MiddleAngle : Double ; const RoueRayon : Integer;const ADivider : Double;  const ab_decal : Boolean ; const hauteur : Double );
var radius, TextAngle, Wt : Double;
    h, AAngle : Integer;
    s : String;
    I : Integer;
Begin
  i := 0;
  TextAngle := arcsin((hauteur / 2) / (level * RoueRayon));
  h := (Level * RoueRayon);
  s := FTexts[ATextType];
  ReduceText(ACanvas,s, RoueRayon,ADivider);
  FShowed[ATextType] := s;
  //inversion
  if MiddleAngle >= 90 then
   begin
    Wt := ACanvas.TextWidth(FShowed[ATextType]) / (72 / 25.4);
    radius := DegToRad(MiddleAngle);
    if ab_decal Then
      radius:=radius-2*TextAngle;
    FPlots[ATextType].XC := ((h + Wt) * cos(radius)) + ACentre.XC;
    FPlots[ATextType].YC := ACentre.YC - ((h + Wt) * sin(radius));
    //                    AngleName := round(10 * (MiddleAngle + 180));
    AAngle := round(10 * (radtodeg(radius) + 180));
    if AAngle > 3600 then
      AAngle := AngleName - 3600;
   end
   Else
    Begin
      radius := DegToRad(MiddleAngle);
      if ab_decal Then
        radius:=radius+2*TextAngle;
      FPlots[ATextType].XC := (h * cos(radius)) + ACentre.XC;
      FPlots[ATextType].YC := ACentre.YC - (h * sin(radius));
      AAngle := round(10 * (radtodeg(radius)));
    end;
  if ATextType = atLastName
   Then fAngleNom:=AAngle
   Else fAnglePrenom:=AAngle;
end;

procedure TPersonArc.ReduceText(const ACanvas : TCanvas ; var s: string;const LngMax: extended;const ADivider : Double = 1);
var
  Lmm: extended;
begin
  Lmm := ACanvas.TextWidth(s) / ADivider;

  if Lmm >= LngMax then
  begin
    repeat
      if length(s) < 1 then
      begin
        s := '';
        break;
      end;

      Delete(s, length(s), 1);
      Lmm := ACanvas.TextWidth(s + '…') / ADivider;
    until (Lmm <= LngMax);

    s := s + '…';
  end;

end;

function TGraphArc.GetIndividuByClePere(const KeyFather: integer): TPersonArc;
var
  n: integer;
begin
  Result := nil;
  if not assigned ( Data ) Then
    Begin
      AMessageDlg('Please assign Data to Graphs.',mtError,[mbOK],Owner as TControl);
      Abort;
    End;
  with Data do
    for n := 0 to Persons.Count - 1 do
      if TPersonArc(Persons[n]).KeyFather = KeyFather then
        begin
          Result := TPersonArc(Persons[n]);
          break;
        end;
end;


procedure TGraphArc.SetRadius(const AValue: integer);
begin
  if Avalue > 0 Then
    FRoueRayon:=AValue;
end;

procedure TGraphArc.SetAngle(const AValue: integer);
begin
  if ( AValue >=0 ) and ( AValue <= 360 ) Then
    FRoueAngle:=AValue;
end;

function TGraphArc.GetIndividuByCleMere(const KeyMother: integer): TPersonArc;
var
  n: integer;
begin
  Result := nil;
  with Data do
    for n := 0 to Persons.Count - 1 do
      if TPersonArc(Persons[n]).KeyMother = KeyMother then
        begin
          Result := TPersonArc(Persons[n]);
          break;
        end;
end;

procedure TGraphArcData.PreparePrint;
var
  pies, n: integer;
  Middle, piesDegrees,TextAngle, radius, h, wt: extended;
  indi: TPersonArc;
  TextElement : TGraphArcText;
  MiddleAngle: extended;
  Lmm, Hmm: Double;
  s: string;


  procedure PlacePrintTexteIndiCentral(Text: string; indi: TPersonArc;
    moins_n_mm: integer; aPlot: TPlot; var TextAff: string);
  var
    s: string;
    lngmax: extended;
    py, a, b, c, d, x1, x2, xr, v: extended;
  begin
    s := trim(Text);
    TextAff := s;
    aPlot.XI := 0;
    aPlot.YI := 0;

    if s <> '' then
    with TGraphArc(Graph) do
    begin
      //on cherche la droite horizontale qui passe par le haut du texte, et qui coupe le cercle
      try
        py := TPlotList(fCercleList[indi.level])
          [indi.idxPlotCenter].YC + moins_n_mm + FRoueDecalageIndiCentral;
        a := 1;
        b := -2 * fCentre.XC;
        c := -sqr(FRoueRayon) + sqr(py - fCentre.YC) + sqr(fCentre.XC);
        d := sqr(b) - (4 * a * c);
        x1 := (-b + sqrt(d)) / (2 * a);
        x2 := (-b - sqrt(d)) / (2 * a);
        lngmax := norme(x1, py, x2, py);

        //Réduction de la taille du texte, si ?a tient pas
        indi.ReduceText(Canvas,s, lngmax);
        TextAff := s;

        //On positionne le texte
        if x1 > x2 then
        begin
          xr := x1;
          x1 := x2;
          x2 := xr;
        end;

        Lmm := Canvas.TextWidth(s);
        Hmm := Canvas.TextHeight(s);

        v := (x2 - x1 - Lmm) / 2;
        if v < 0 then
          v := 0;

        aPlot.XI := x1 + v;
        aPlot.YI := py + Hmm;
      except

      end;
    end;
  end;

  procedure calcPlotText(Text: string; indi: TPersonArc; moins_n_mm: integer; aPlot: TPlot;
  var NomAff: string);
  var
    s: string;
    x, y: extended;
    lng, lngmax: extended;
    xa, ya, xb, yb: extended;
    LargeurMaxPossibleText, Hmm: extended;
  begin
    s := trim(Text);
    NomAff := s;

    if s <> '' then
    with TGraphArc(Graph) do
    begin
      Hmm := Canvas.TextHeight(s);
      xa := 0;
      ya := 0;
      xb := 0;
      yb := 0;

      with indi do
        TrouveCoords(
          fCentre.XC,
          fCentre.YC,
          TPlotList(fCercleList[level])[idxPlotCenter + 1].XC,
          TPlotList(fCercleList[level])[idxPlotCenter + 1].YC,
          TPlotList(fCercleList[level])[idxPlotCenter].XC,
          TPlotList(fCercleList[level])[idxPlotCenter].YC,
          TPlotList(fCercleList[level])[idxPlotCenter - 1].XC,
          TPlotList(fCercleList[level])[idxPlotCenter - 1].YC,
          moins_n_mm + Hmm,
          xa, ya, xb, yb);

      Lmm := Canvas.TextWidth(s);
      lngmax := norme(xa, ya, xb, yb);

      LargeurMaxPossibleText:=0;

      if LargeurPossibleTexte(xa, ya, xb, yb, fCentre.XC, fCentre.YC, FRoueRayon *
        (indi.level + 1), LargeurMaxPossibleText) then
      begin
        LargeurMaxPossibleText := min(LargeurMaxPossibleText, lngmax);
        begin
          indi.reduceText(Canvas,s, LargeurMaxPossibleText);
          Lmm := Canvas.TextWidth(s);
          NomAff := s;
        end;
      end;

      lng := (lngMax - Lmm) / 2;
      x := 0;
      y := 0;

      TrouvePoint(xa, ya, xb, yb,
        Lng,
        x,
        y);

      aPlot.XI := x;//x+ fCentre.XC;
      aPlot.YI := y;//fCentre.YC -y;
    end
    else
    begin
      aPlot.XI := 0;
      aPlot.YI := 0;
    end;
  end;
var ai_TextY : Byte;
begin
  VerifyObjects ( Graph );
  //on récupère la font à utiliser, avec la taille en 100 %
  {
  rm.rp.SetFont(fFontText.Name,fFontText.Size);
  rm.rp.Bold:=(fsBold in fFontText.Style);
  rm.rp.Underline:=(fsUnderLine in fFontText.Style);
  rm.rp.Italic:=(fsItalic in fFontText.Style);
  rm.rp.StrikeOut:=(fsStrikeOut in fFontText.Style);
  rm.rp.FontColor:=fFontText.Color;
   }
  s := '';
  with TGraphArc(Graph) do
   Begin
    Canvas.Font.Size:=round(GRAPH_ARC_PRINT_FONT_SIZE);
    PaintFont(Canvas.Font,GRAPH_ARC_PRINT_FONT_SIZE);
    for n := 0 to Persons.Count - 1 do
      begin
        indi := TPersonArc(Persons[n]);

        //combien de quartiers ?
        pies := trunc(Ldexp(1, indi.level + 1));

        //Nb de degré d'un quartier (du niveau suppérieur)
        piesDegrees := FRoueAngle / pies;

        //angle de démarrage
        Middle := (FRoueAngle - 180) / 2;

        with indi do
         Begin
          //angle au point gauche du quartier
          MiddleAngle := (idxPlotCenter * piesDegrees) - Middle;
          ai_TextY:=0;
          if level <= fLevelMaxTexteNormal then
          begin
            //angle au point central du quartier

            //-------------------------------------
            //on calcul le point de démarrage du texte
            if n = 0 then
            begin
              //seulement pour l'individu central
              for TextElement := low(TGraphArcText) to high(TGraphArcText) do
               if TextElement in FShowTexts Then
                begin
                 PlacePrintTexteIndiCentral(FTexts [ TextElement], indi, ai_TextY, FPlots[ TextElement], s);
                 inc( ai_TextY, LineHeight );
                 FShowed [ TextElement ] := s;
                End;
            end
            else
              for TextElement := low(TGraphArcText) to high(TGraphArcText) do
               if TextElement in FShowTexts Then
                begin
                 calcPlotText(FTexts [ TextElement], indi, ai_TextY, FPlots[ TextElement], s);
                 inc( ai_TextY, LineHeight );
                 FShowed [ TextElement ] := s;
                 CalcAngle(MiddleAngle);
                End;
          end
          else
            //texte apres levelMax
          begin
            TextAngle := arcsin((Canvas.TextHeight(FTexts[atName]) / 2) / (level * FRoueRayon));
            //Rayon pour cette génération
            h := (level * FRoueRayon) + 0.5;
            s := FTexts[atName];
            indi.ReduceText(Canvas,s, (FRoueRayon - 0.5));
            FShowedPrint[atName] := s;

            //inversion
            if MiddleAngle >= 90 then
             begin
              Wt := Canvas.TextWidth(FShowedPrint[atName]);
              radius := DegToRad(MiddleAngle);
              FPlots[atName].XI := ((h + Wt) * cos(radius)) + fCentre.XC;
              FPlots[atName].YI := fCentre.YC - ((h + Wt) * sin(radius));
              AnglePrintName := round(10 * (radtodeg(radius) + 180));
              if AnglePrintName > 3600 then
                AnglePrintName := AnglePrintName - 3600;
             end
            else
             Begin
               radius := DegToRad(MiddleAngle);
               FPlots[atName].XI := (h * cos(radius)) + fCentre.XC;
               FPlots[atName].YI := fCentre.YC - (h * sin(radius));
               AnglePrintName := round(10 * (radtodeg(radius)));
             end;


            s := FTexts[atLastName];
            indi.ReduceText(Canvas,s, (FRoueRayon - 0.5));
            FShowedPrint[atLastName] := s;

            //inversion
            if MiddleAngle >= 90 then
             begin
              Wt := Canvas.TextWidth(FShowedPrint[atLastName]);
              radius := DegToRad(MiddleAngle) + TextAngle * 2;
              FPlots[atLastName].XI := ((h + Wt) * cos(radius)) + fCentre.XC;
              FPlots[atLastName].YI := fCentre.YC - ((h + Wt) * sin(radius));
              AnglePrintLastName := round(10 * (radtodeg(radius) + 180));
              if AnglePrintLastName > 3600 then
                AnglePrintLastName := AnglePrintLastName - 3600;
             end
            else
             Begin
               radius := DegToRad(MiddleAngle) - TextAngle * 2;
               FPlots[atLastName].XI := (h * cos(radius)) + fCentre.XC;
               FPlots[atLastName].YI := fCentre.YC - (h * sin(radius));
               AnglePrintLastName := round(10 * (radtodeg(radius)));
             end;
           end;
         end;
      end;
   end;
end;

procedure TGraphArc.Print( const DecalX, DecalY : Extended );
var
  n, k: integer;
  indi: TPersonArc;
  pies, i, p: integer;
  TextElement : TGraphArcText;
  aCercle, LastCercle: TPlotList;
  rf: TFloatRect;

  procedure PrintTheText(R: TFloatRect; Text: string);
  var
    w, h, l: double;
    OkName: boolean;
  begin
    w := Canvas.TextWidth(Text);
    h := Canvas.TextHeight( Text);

    //est-ce que le Nom du pieu rentre dans le rectangle de délimitation ?
    okName := (w <= abs(R.right - R.Left + 1));

    //soit le texte entre dans le rectangle
    if okName then
    begin
      l := (abs(R.left - R.right) - w) / 2;
      PaintTextXY(R.left + l, R.top + h, Text,Canvas.Font.Orientation);
    end
    else
    begin
      PaintTextRect(R, R.left, R.top + h, Text,Canvas.Font.Orientation);
    end;
  end;

  function MyCreateRect(X1, Y1, X2, Y2: double): TRect;
  begin{ CreateRect }
    Result.Left := round(X1);
    Result.Top := round(Y1);
    Result.Right := round(X2);
    Result.Bottom := round(Y2);
  end;

begin
  {
  DecalX := rp.MarginLeft + rm.DecalagePapierX;
  DecalY := rp.MarginTop + rm.DecalagePapierY;

  //on récupère la font à utiliser, avec la taille en 100 %
  rp.SetFont(fFontText.Name, fFontText.Size);
  rp.Bold := (fsBold in fFontText.Style);
  rp.Underline := (fsUnderLine in fFontText.Style);
  rp.Italic := (fsItalic in fFontText.Style);
  rp.StrikeOut := (fsStrikeOut in fFontText.Style);
  rp.FontColor := fFontText.Color;
   }
  Canvas.Font.Assign(Font);
  Canvas.Font.Color:=clBlack;
  Canvas.Font.Size :=round(GRAPH_ARC_PRINT_FONT_SIZE);
  PaintFont(Canvas.Font,GRAPH_ARC_PRINT_FONT_SIZE);
  try

    with TGraphArcData(Data) do
      begin
        LastCercle := TPlotList(fCercleList.last);
        for n := 0 to fCercleList.Count - 1 do
        begin
          aCercle := TPlotList(fCercleList[n]);
          pies := round((n + 1) * FRoueRayon);

          Rf.left := fCentre.XC - pies + DecalX;
          Rf.right := fCentre.XC + pies + DecalX;
          Rf.top := fCentre.YC - pies + DecalY;
          Rf.bottom := fCentre.YC + pies + DecalY;

          PaintSetPen(FColors[ceCircle], psSolid, 1.3, pmCopy);
          PaintSetBrush(clNone, bsClear);

          PaintOutArc(
            Rf,
            aCercle[0].XC + DecalX,
            aCercle[0].YC + DecalY,
            aCercle.last.XC + DecalX,
            aCercle.last.YC + DecalY);

          PaintSetPen(FColors[ceRayon], psSolid, 1.3, pmCopy);

          p := trunc(Ldexp(1, fCercleList.Count - n - 1));
          i := p;
          for k := 1 to aCercle.Count - 2 do
          begin
            PaintOutMoveTo(aCercle[k].XC + DecalX, aCercle[k].YC + DecalY);
            PaintOutLineTo(LastCercle[i].XC + DecalX, LastCercle[i].YC + DecalY);
            i := i + p;
          end;
        end;

        //les lignes
        PaintSetPen(FColors[ceRayon], psSolid, 1.3, pmCopy);
        if fCercleList.Count > 0 then
        begin
          if FRoueAngle <> 360 then
          begin
            PaintOutMoveTo(LastCercle[0].XC + DecalX, LastCercle[0].YC + DecalY);
            PaintOutLineTo(fCentre.XC + DecalX, fCentre.YC + DecalY);
            PaintOutLineTo(LastCercle.last.XC + DecalX, LastCercle.last.YC + DecalY);
          end
          else
          begin
            aCercle := TPlotList(fCercleList[0]);
            if aCercle <> nil then
            begin
              PaintOutMoveTo(aCercle[0].XC + DecalX, aCercle[0].YC + DecalY);
              PaintOutLineTo(LastCercle[0].XC + DecalX, LastCercle[0].YC + DecalY);
            end;
          end;
        end;

        begin
          //les individus
          With Data do
            for n := 0 to Persons.Count - 1 do
              begin
                indi := TPersonArc(Persons[n]);

                if indi.Sexe = 1
                 then Canvas.Font.Color := FColors[ceMen]
                 else Canvas.Font.Color := FColors[ceWomen];

                PaintFont ( Canvas.Font, GRAPH_ARC_PRINT_FONT_SIZE );

                with indi do
                if level <= fLevelMaxTexteNormal then
                begin
                  //le texte
                  for TextElement := low(TGraphArcText) to high(TGraphArcText) do
                    PaintTextXY(FPlots[TextElement].XI + DecalX, FPlots[TextElement].YI + DecalY, FShowedPrint[TextElement], Angle);
                end
                else
                begin

                  if atName in FShowTexts then
                    PaintTextXY(FPlots[atName].XI + DecalX, FPlots[atName].YI + DecalY, FShowedPrint[atName], AnglePrintName);


                  if atLastName in FShowTexts then
                    PaintTextXY(FPlots[atLastName].XI + DecalX, FPlots[atLastName].YI +
                      DecalY, FShowedPrint[atLastName], AnglePrintLastName);

                end;
              end;
            end;

    end;

  finally
  end;
end;

function TGraphArc.GetCleIndividuAtXY(const X,Y:integer;var sNom,sNaisDec:string;var iSexe,iGene,iParent:integer):integer;
begin
  Result := -1;
end;

procedure TGraphArc.SetCheckShow(const AShow: TGraphArcText;
  const ACheck: Boolean);
begin
  if ACheck
  Then FShowTexts:=FShowTexts+[AShow]
  Else FShowTexts:=FShowTexts-[AShow];

end;

end.
