{création André Langlet Décembre 2011}

unit u_ancestrolink;

interface

uses
  Classes, contnrs,
  {$IFDEF FPC}
  FPCanvas,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils,
  Graphics,
  u_ancestroboxes,
  u_objects_components,
  u_objet_graph_TPlot,
  Controls,
  u_common_graph_type,
  u_ancestroviewer;

type
  TGraphLinkText = (ltName, ltLastName, ltJob, ltBirthDay, ltBirthCity, ltDeathDay, ltDeathCity, ltSOSA);
  TGraphLinkOption = (loPaintBackMen,loPaintBackWomen,loBourg,loCities,
                      loSubd, loNameDept, loCodeDept, loRegion, loCountry);
  TGraphLinkTextPlots = ltName..ltDeathCity;
  TGraphLinkTextArrayString = array [TGraphLinkTextPlots] of String;
  TGraphLinkTextArrayPlot = array [TGraphLinkTextPlots] of TPlot;
  TGraphLinkTexts = set of TGraphLinkText;
  TGraphLinkOptions = set of TGraphLinkOption;

const
  GRAPH_LINK_DEFAULT_COLOR_RECT_MEN = 8388608;
  GRAPH_LINK_DEFAULT_COLOR_RECT_SOSA = clGreen;
  GRAPH_LINK_DEFAULT_COLOR_TEXT_MEN = 8388608;
  GRAPH_LINK_DEFAULT_COLOR_LINKS = clWindowText;
  GRAPH_LINK_DEFAULT_COLOR_BACK_RECT_MEN = $00FFCC99;
  GRAPH_LINK_DEFAULT_COLOR_RECT_WOMEN = 128;
  GRAPH_LINK_DEFAULT_COLOR_TEXT_WOMEN = 128;
  GRAPH_LINK_DEFAULT_COLOR_BACK_RECT_WOMEN = $0099CCFF;
  GRAPH_LINK_DEFAULT_SHOW_TEXT = [ltName, ltLastName, ltJob];
  GRAPH_LINK_DEFAULT_OPTIONS = [loBourg,loCities];
  GRAPH_LINK_DEFAULT_LINE_HEIGHT = 3;
  GRAPH_INI_DISTBIRTHCITY = 'DistBirthCity';
  GRAPH_INI_DISTDEATHCITY = 'DistDeathCity';
  GRAPH_INI_BACKPAINTMAN = 'BackPaintMan';
  GRAPH_INI_BACKPAINTWOMAN = 'BackPaintWoman';

type
  TPersonLink = class(TPerson)
  private
    FA: TPlot;
    FB: TPlot;
    FC: TPlot;
    FS: TPlot;
    FColonne: single;
    FLettreE: string;
    FLettreS: string;
    FLink   ,
    FNumSosa: Integer;

    constructor Create; override;
    procedure Clear; override;

  protected

  public
    FTexts       : TGraphLinkTextArrayString;
    FPlots       : TGraphLinkTextArrayPlot;
    destructor Destroy; override;
    property A: TPlot read FA write FA;
    property B: TPlot read FB write FB;
    property C: TPlot read FC write FC;
    property S: TPlot read FS write FS;
    property Colonne: single read FColonne write FColonne;
    property LetterE: string read FLettreE write FLettreE;
    property LetterS: string read FLettreS write FLettreS;
    property NumSOSA: Integer read FNumSosa write FNumSosa;
    property Link: Integer read FLink write FLink;
  end;


  { TGraphLinkData }

  TGraphLinkData = class(TGraphData)

  private
    fStartIndividu: TPersonLink;
    fCentre: TPlot;
    fCercleList: TObjectList;
  public
    procedure Prepare(const ACanvas: TCanvas); override;
    procedure PreparePrint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Order; override;

    property FirstPerson: TPersonLink read fStartIndividu;

  published
  end;

  { TGraphLink }

  TGraphLink = class(TGraphBoxes)

  private
    FOptions: TGraphLinkOptions;
    FShowTexts: TGraphLinkTexts;
    FColorRectMan, FColorRectWoman, FColorRectSOSA,
    FColorLinks, FColorTextMan, FColorTextWoman, FColorBackMan,
    FColorBackWoman: TColor;
    FBackPaintMan, FBackPaintWoman: boolean;
    fSizeFont: single;
  protected
    procedure SetTextPlots ( const indi : TPersonLink ); virtual;
  public
    constructor Create ( AOwner : TComponent );override;
    procedure ReadSectionIni; override;
    procedure WriteSectionIni; override;
    //disposition
    procedure InitGraph(const coef: single); override;
    procedure InitGraphMiniature(const coef: single); override;

    procedure PaintGraph(const ACanvas : TCanvas ; const DecalX, DecalY: integer); override;
    procedure PaintGraphMiniature(const DecalX, DecalY: integer); override;
    procedure GetRectEncadrement(var R: TFloatRect); override;

    procedure Print(const DecalX, DecalY: extended); override;

    function GetCleIndividuAtXY(const X, Y: integer; var sNom, sNaisDec: string;
      var iSexe, iGene, iParent: integer): integer; override;
    function IndiDansListe: integer; override;
    function PositionIndi(Indi: integer): TPoint; override;
    procedure SetCheckShow(const AShow : TGraphLinkText; const ACheck : Boolean ); virtual;
    procedure SetCheckOption(const AShow: TGraphLinkOption;
      const ACheck: Boolean); virtual;

  published
    property Options: TGraphLinkOptions read FOptions write FOptions default
      GRAPH_LINK_DEFAULT_OPTIONS;
    property ShowText: TGraphLinkTexts read FShowTexts write FShowTexts default
      GRAPH_LINK_DEFAULT_SHOW_TEXT;
    property ColorRectMan: TColor read FColorRectMan write FColorRectMan default
      GRAPH_LINK_DEFAULT_COLOR_RECT_MEN;
    property ColorLinks: TColor read FColorLinks write FColorLinks default
      GRAPH_LINK_DEFAULT_COLOR_LINKS;
    property ColorRectWoman: TColor
      read FColorRectWoman write FColorRectWoman default GRAPH_LINK_DEFAULT_COLOR_RECT_WOMEN;
    property ColorSOSA: TColor read FColorRectSOSA write FColorRectSOSA default
      GRAPH_LINK_DEFAULT_COLOR_RECT_SOSA;
    property ColorTextMan: TColor read FColorTextMan write FColorTextMan default
      GRAPH_LINK_DEFAULT_COLOR_TEXT_MEN;
    property ColorTextWoman: TColor
      read FColorTextWoman write FColorTextWoman default GRAPH_LINK_DEFAULT_COLOR_TEXT_WOMEN;
    property ColorBackMan: TColor read FColorBackMan
      write FColorBackMan default GRAPH_LINK_DEFAULT_COLOR_BACK_RECT_MEN;
    property ColorBackWoman: TColor read FColorBackWoman
      write FColorBackWoman default GRAPH_LINK_DEFAULT_COLOR_BACK_RECT_WOMEN;
    property BackPaintMan: boolean read FBackPaintMan
      write FBackPaintMan default True;
    property BackPaintWoman: boolean read FBackPaintWoman
      write FBackPaintWoman default True;
  end;

implementation

uses
  Forms,
  Math,
  u_common_functions,
  u_common_const;

{TGraphLinkData}

procedure TGraphLinkData.Prepare(const ACanvas: TCanvas);
//activé quand il faut repositionner sans recharger
var
  n: integer;
  indi, indiP: TPersonLink;
  interligne, decalV, Hboite: single;
  CurseurSauve: TCursor;

begin
  //les individus
  CurseurSauve := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  with Graph as TGraphLink do
  try
    MaxLevel := -1;
    decalV := Font.Size * 25.4 / 72;
    if (ltBirthCity in FShowTexts)or (ltDeathCity in FShowTexts) then
      interligne := decalV * 1.3
    else
      interligne := 0;
    Hboite := BoxHeight + 2 * interligne;

    for n := 0 to Persons.Count - 1 do
    begin
      indi := TPersonLink(Persons[n]);
      with indi do
       Begin
        MaxLevel:=Max(Level,MaxLevel);
        A.XC := MargeLeft + (BoxWidth + SpacePerson) * Colonne;
        A.YC := MargeTop + (Hboite + SpaceGeneration) * Level;
        B.XC := A.XC + BoxWidth;
        B.YC := A.YC + Hboite;
        if n > 0 then
        begin
          indiP := TPersonLink(Persons[n - 1]);//précédent
          if indiP.Level > Level then
          begin
            indiP.S.XC := (indiP.A.XC + indiP.B.XC) / 2;
            indiP.S.YC := indiP.A.YC;
            C.XC := (A.XC + B.XC) / 2;
            C.YC := B.YC;
          end
          else if indiP.Level < Level then
          begin
            indiP.S.XC := (indiP.A.XC + indiP.B.XC) / 2;
            indiP.S.YC := indiP.B.YC;
            C.XC := (A.XC + B.XC) / 2;
            C.YC := A.YC;
          end
          else
          begin
            indiP.S.XC := indiP.B.XC;
            indiP.S.YC := (indiP.A.YC + indiP.B.YC) / 2;
            C.XC := A.XC;
            C.YC := (A.YC + B.YC) / 2;
          end;
        end;
        SetTextPlots(indi);
       end;
    end;
  finally
    Screen.Cursor := CurseurSauve;
  end;
end;

procedure TGraphLinkData.PreparePrint;
begin
end;

constructor TGraphLinkData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fStartIndividu:=TPersonLink.Create;
  fCercleList := TObjectList.Create;
  fCentre := TPlot.Create;
end;

destructor TGraphLinkData.Destroy;
begin
  inherited Destroy;
  fStartIndividu.Free;
  fCercleList.Free;
  fCentre.Free;
end;

procedure TGraphLinkData.Order;
begin
end;

{TGraphLink}

procedure TGraphLink.ReadSectionIni;
begin
  inherited;
  ReadInteger ( GRAPH_INI_COLORRECTMAN );
  ReadInteger ( GRAPH_INI_COLORRECTWOMAN );
  ReadInteger ( GRAPH_INI_COLORTEXTWOMAN );
  ReadInteger ( GRAPH_INI_COLORTEXTMAN );
  ReadInteger ( GRAPH_INI_COLORBACKWOMAN );
  ReadInteger ( GRAPH_INI_COLORTEXTMAN );
  ReadInteger ( GRAPH_INI_COLORSOSA );
  ReadInteger ( GRAPH_INI_LINE_HEIGHT );

  ReadBool    ( GRAPH_INI_BACKPAINTMAN );
  ReadBool    ( GRAPH_INI_BACKPAINTWOMAN );
end;

procedure TGraphLink.WriteSectionIni;
begin
  inherited;
  WriteInteger ( GRAPH_INI_COLORRECTMAN );
  WriteInteger ( GRAPH_INI_COLORRECTWOMAN );
  WriteInteger ( GRAPH_INI_COLORTEXTWOMAN );
  WriteInteger ( GRAPH_INI_COLORTEXTMAN );
  WriteInteger ( GRAPH_INI_COLORBACKWOMAN );
  WriteInteger ( GRAPH_INI_COLORTEXTMAN );
  WriteInteger ( GRAPH_INI_COLORSOSA );
  WriteInteger ( GRAPH_INI_LINE_HEIGHT );
  WriteBool    ( GRAPH_INI_BACKPAINTMAN );
  WriteBool    ( GRAPH_INI_BACKPAINTWOMAN );
end;



procedure TGraphLink.GetRectEncadrement(var R: TFloatRect);
var
  n: integer;
  indi: TPersonLink;
begin
  if not Assigned(Data) then
    Exit;
  //Rectangle de délimitation de tout le chantier
  R.left := Maxint;
  R.Top := Maxint;
  R.Right := -Maxint;
  R.Bottom := -Maxint;
  with Data do
    for n := 0 to Persons.Count - 1 do
    begin
      indi := TPersonLink(Persons[n]);
      with indi do
       Begin
        if R.Left > A.XC then
          R.Left := A.XC;
        if R.Top > A.YC then
          R.Top := A.YC;
        if R.Right < B.XC then
          R.Right := B.XC;
        if R.Bottom < B.YC then
          R.Bottom := B.YC;
       end;
    end;
end;

procedure TGraphLink.PaintGraph(const ACanvas : TCanvas ; const DecalX, DecalY: integer);
var
  l: integer;
  lRect: TRect;
  FTextStyle: TTextStyle;

  procedure EcritDansRect( const s: string; const AX, AY, BX, BY: integer);
  begin
    l := ACanvas.TextWidth(s);
    if l > BX - AX
     then FTextStyle.Alignment := taLeftJustify
     else FTextStyle.Alignment := taCenter;
    lRect := Rect(AX, AY, BX, BY);
    ACanvas.TextRect(lRect, Ax, BX, s, FTextStyle);
    lRect := Rect(AX, AY, BX, BY);
    ACanvas.TextRect(lRect, AX, BX, s, FTextStyle);
  end;

var
  n, h: integer;
  indi: TPersonLink;
  astring: string;
  CouleurFontSexe: TColor;
  TextPlots : TGraphLinkTextPlots;
  bIndiPresent: boolean;
begin
  //on récupère la fonte à utiliser, avec la taille en 100 %
  //  StringToFont(_Context.LiensFont,PaintBox.ACanvas.Font);

  //on adapte la taille en fonction du zoom
  with ACanvas.Font do
    Begin
     Size := round(fSizeFont);
     Name := Font.Name;
    end;
  bIndiPresent := False;//ne sera activé que si indi en cours dans l'Liens
  with Viewer, Data do
    for n := 0 to Persons.Count - 1 do
    begin
      indi := TPersonLink(Persons[n]);
      ACanvas.Pen.Style := psSolid;
      ACanvas.Brush.Style := bsSolid;

      with indi do
       Begin
          //le cadre
          if Sexe = 1 then
          begin//homme
            ACanvas.Pen.Color := FColorRectMan;
            ACanvas.Brush.Color := FColorBackMan;
            if not FBackPaintWoman then
              ACanvas.Brush.Style := bsClear;
            CouleurFontSexe := FColorTextMan;
          end
          else
          begin//femme
            ACanvas.Pen.Color := FColorRectWoman;
            ACanvas.Brush.Color := FColorBackWoman;
            if not FBackPaintMan then
              ACanvas.Brush.Style := bsClear;
            CouleurFontSexe := FColorTextWoman;
          end;
          if FNumSosa > 0 then
          begin
            ACanvas.Pen.Color := _COLOR_SOSA;
          end;
          if KeyPerson = ActivePersonKey then
          begin
            ACanvas.Pen.Width := 2;
            bIndiPresent := True;
          end
          else
            ACanvas.Pen.Width := 1;
          ACanvas.Rectangle(A.XV + DecalX, A.YV + DecalY,
            B.XV + DecalX, B.YV + DecalY);

          //les traits
          ACanvas.Pen.Width := 1;
          ACanvas.Pen.Style := psSolid;
          ACanvas.Pen.Color := FColorLinks;
          if n < Persons.Count - 1 then
          begin
            ACanvas.MoveTo(S.XV + DecalX, S.YV + DecalY);
            ACanvas.LineTo(TPersonLink(Persons[n + 1]).C.XV + DecalX,
              TPersonLink(Persons[n + 1]).C.YV + DecalY);
          end;

          //les textes
          if ACanvas.Font.Size >= 1 then
          begin
            ACanvas.Brush.Style := bsClear;
            ACanvas.Font.Color := CouleurFontSexe;

            for TextPlots:=ltName to ltJob do
             if TextPlots in FShowTexts then
                EcritDansRect(FTexts [ TextPlots ], A.XV + DecalX + 1, FPlots [ TextPlots ].YV + DecalY
                  , B.XV + DecalX - 1, B.YV + DecalY);

            if ltBirthDay in FShowTexts then
            begin
              if FTexts [ ltBirthDay ] <> '' then
              begin
                astring := '°' + FTexts [ ltBirthDay ];
                EcritDansRect(astring, A.XV + DecalX + 1, FPlots [ ltBirthDay ].YV + DecalY
                  , B.XV + DecalX - 1, B.YV + DecalY);
                if (ltBirthCity in FShowTexts) and (FTexts [ ltBirthCity ] <> '') then
                begin
                  EcritDansRect(FTexts [ ltBirthCity ], A.XV + DecalX + 1,
                    FPlots [ ltBirthCity ].YV + DecalY
                    , B.XV + DecalX - 1, B.YV + DecalY);
                end;
              end
              else if (ltBirthCity in FShowTexts) and (FTexts [ ltBirthCity ] <> '') then
              begin
                astring := '°' + FTexts [ ltBirthCity ];
                EcritDansRect(astring, A.XV + DecalX + 1, FPlots [ ltBirthDay ].YV + DecalY
                  , B.XV + DecalX - 1, B.YV + DecalY);
              end;
            end;

            if ltDeathDay in FShowTexts then
            begin
              if FTexts [ ltDeathDay ] <> '' then
              begin
                astring := '†' + FTexts [ ltDeathDay ];
                EcritDansRect(astring, A.XV + DecalX + 1, FPlots [ ltDeathDay ].YV + DecalY
                  , B.XV + DecalX - 1, B.YV + DecalY);
                if (ltDeathCity in FShowTexts) and (FTexts [ ltDeathCity ] <> '') then
                  EcritDansRect(FTexts [ ltDeathCity ], A.XV + DecalX + 1,
                    FPlots [ ltDeathCity ].YV + DecalY
                    , B.XV + DecalX - 1, B.YV + DecalY);
              end
              else if (ltDeathCity in FShowTexts) and (FTexts [ ltDeathCity ] <> '') then
              begin
                astring := '†' + FTexts [ ltDeathCity ];
                EcritDansRect(astring, A.XV + DecalX + 1, FPlots [ ltDeathDay ].YV + DecalY
                  , B.XV + DecalX - 1, B.YV + DecalY);
              end;
            end;

            if FLettreE > '' then
            begin
              astring := FLettreE;
              lRect := Rect(A.XV, A.YV, B.XV, B.YV);
              FTextStyle.Alignment := taLeftJustify;
              ACanvas.TextRect(lRect, lRect.Left, lRect.Top, astring, FTextStyle);
              l := ceil((lRect.Right - lRect.Left) / 2);
              h := ceil(-ACanvas.Font.Height / 2);
              lRect := Rect(C.XV + DecalX - l, C.YV + DecalY -
                h, C.XV + DecalX + l, C.YV + DecalY + h);
              ACanvas.Brush.Style := bsSolid;
              FTextStyle.Alignment := taCenter;
              ACanvas.TextRect(lRect, lRect.Left, lRect.Top, astring, FTextStyle);
            end;

            if FLettreS > '' then
            begin
              astring := FLettreS;
              lRect := Rect(A.XV, A.YV, B.XV, B.YV);
              FTextStyle.Alignment := taLeftJustify;
              ACanvas.TextRect(lRect, lRect.Left, lRect.Top, astring, FTextStyle);
              l := ceil((lRect.Right - lRect.Left) / 2);
              h := ceil(-ACanvas.Font.Height / 2);
              lRect := Rect(S.XV + DecalX - l, S.YV + DecalY -
                h, S.XV + DecalX + l, S.YV + DecalY + h);
              ACanvas.Brush.Style := bsSolid;
              FTextStyle.Alignment := taCenter;
              ACanvas.TextRect(lRect, lRect.Left, lRect.Top, astring, FTextStyle);
            end;
          end;
       end;
    end;
end;

procedure TGraphLink.PaintGraphMiniature(const DecalX, DecalY: integer);
var
  n: integer;
  indi: TPersonLink;
begin
  if Parent.Visible then
  begin
    Canvas.Pen.Color := clRed;
    Canvas.Pen.Style := psSolid;
    with Data do
    for n := 0 to Persons.Count - 1 do
    begin
      indi := TPersonLink(Persons[n]);
      //le cadre
      with indi do
       begin
        Canvas.MoveTo(A.XM + DecalX, A.YM + DecalY);
        Canvas.LineTo(B.XM + DecalX, A.YM + DecalY);
        Canvas.LineTo(B.XM + DecalX, B.YM + DecalY);
        Canvas.LineTo(A.XM + DecalX, B.YM + DecalY);
        Canvas.LineTo(A.XM + DecalX, A.YM + DecalY);
        //les traits
        if n < Persons.Count - 1 then
        begin
          Canvas.MoveTo(S.XM + DecalX, S.YM + DecalY);
          Canvas.LineTo(TPersonLink(Persons[n + 1]).C.XM + DecalX,
            TPersonLink(Persons[n + 1]).C.YM + DecalY);
        end;
       end;
    end;
  end;
end;

constructor TGraphLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorRectMan       := GRAPH_LINK_DEFAULT_COLOR_RECT_MEN;
  FColorRectWoman     := GRAPH_LINK_DEFAULT_COLOR_RECT_WOMEN;
  FColorBackMan   := GRAPH_LINK_DEFAULT_COLOR_BACK_RECT_MEN;
  FColorBackWoman := GRAPH_LINK_DEFAULT_COLOR_BACK_RECT_WOMEN;
  FColorRectSOSA      := GRAPH_LINK_DEFAULT_COLOR_RECT_SOSA;
  FColorLinks         := GRAPH_LINK_DEFAULT_COLOR_LINKS;
  FColorTextMan       := GRAPH_LINK_DEFAULT_COLOR_TEXT_MEN;
  FColorTextWoman     := GRAPH_LINK_DEFAULT_COLOR_TEXT_WOMEN;
  FColorRectSOSA      := GRAPH_LINK_DEFAULT_COLOR_RECT_SOSA;
  FColorRectSOSA      := GRAPH_LINK_DEFAULT_COLOR_RECT_SOSA;
  FBackPaintMan   := True ;
  FBackPaintWoman := True ;
  FShowTexts:=GRAPH_LINK_DEFAULT_SHOW_TEXT;
end;

procedure TGraphLink.SetTextPlots(const indi : TPersonLink);
var ATextIdent : TGraphLinkText;
    I : Integer;
Begin
  i := 0;
  with indi do
  for ATextIdent:=low(ATextIdent) to High(ATextIdent) do
  if ATextIdent in FShowTexts Then
   Begin
    FPlots [ ATextIdent ].YC := A.YC + LineHeight*i;
    inc (i);
   end;

end;

procedure TGraphLink.InitGraph(const coef: single);
//activé quand il faut repositionner sans recharger
var
  n: integer;
  indi, indiP: TPersonLink;
  interligne, decalV, Hboite: single;
  CurseurSauve: TCursor;

begin
  if not Assigned(Data) then
    Exit;
  fSizeFont := coef * Font.Size * 25.4 / Screen.PixelsPerInch;

  //les individus
  with Data do
  for n := 0 to Persons.Count - 1 do
  begin
    indi := TPersonLink(Persons[n]);

    with indi do
     Begin
      A.CoordChantier_2_CoordViewer(coef);
      B.CoordChantier_2_CoordViewer(coef);
      C.CoordChantier_2_CoordViewer(coef);
      S.CoordChantier_2_CoordViewer(coef);

      FPlots [ ltLastName ].YV := round(FPlots [ ltLastName ].YC * coef);
      FPlots [ ltName ].YV := round(FPlots [ ltName ].YC * coef);
      FPlots [ ltJob ].YV := round(FPlots [ ltJob ].YC * coef);
      FPlots [ ltDeathDay ].YV := round(FPlots [ ltDeathDay ].YC * coef);
      FPlots [ ltDeathCity ].YV := round(FPlots [ ltDeathCity ].YC * coef);
      FPlots [ ltBirthDay ].YV := round(FPlots [ ltBirthDay ].YC * coef);
      FPlots [ ltBirthCity ].YV := round(FPlots [ ltBirthCity ].YC * coef);
      CurseurSauve := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      try
        decalV := Font.Size * 25.4 / 72;
        if (ltBirthCity in FShowTexts) or (ltDeathCity in FShowTexts) then
          interligne := decalV * 1.3
        else
          interligne := 0;
        Hboite := BoxHeight + 2 * interligne;

        begin
          A.XC := MargeLeft + (BoxWidth + SpacePerson) * Colonne;
          A.YC := MargeTop + (Hboite + SpaceGeneration) * Level;
          B.XC := A.XC + BoxWidth;
          B.YC := A.YC + Hboite;
          if n > 0 then
          begin
            indiP := TPersonLink(Persons[n - 1]);//précédent
            if indiP.Level > Level then
            begin
              indiP.S.XC := (indiP.A.XC + indiP.B.XC) / 2;
              indiP.S.YC := indiP.A.YC;
              C.XC := (A.XC + B.XC) / 2;
              C.YC := B.YC;
            end
            else if indiP.Level < Level then
            begin
              indiP.S.XC := (indiP.A.XC + indiP.B.XC) / 2;
              indiP.S.YC := indiP.B.YC;
              C.XC := (A.XC + B.XC) / 2;
              C.YC := A.YC;
            end
            else
            begin
              indiP.S.XC := indiP.B.XC;
              indiP.S.YC := (indiP.A.YC + indiP.B.YC) / 2;
              C.XC := A.XC;
              C.YC := (A.YC + B.YC) / 2;
            end;
          end;
          SetTextPlots(indi);
        end;
      finally
        Screen.Cursor := CurseurSauve;
      end;
    end;
  end;
end;

procedure TGraphLink.InitGraphMiniature(const coef: single);
var
  n: longint;
begin
  with Data do
    for n := 0 to Persons.Count - 1 do
    begin
      TPersonLink(Persons[n]).A.CoordChantier_2_CoordMiniature(coef);
      TPersonLink(Persons[n]).B.CoordChantier_2_CoordMiniature(coef);
      TPersonLink(Persons[n]).C.CoordChantier_2_CoordMiniature(coef);
      TPersonLink(Persons[n]).S.CoordChantier_2_CoordMiniature(coef);
    end;
end;

{ TPersonLink }

procedure TPersonLink.Clear;
begin
  Inherited;
  FColonne := -1;
  FTexts [ ltLastName ] := '';
  FTexts [ ltName ] := '';
  FTexts [ ltJob ] := '';
  FTexts [ ltBirthDay ] := '';
  FTexts [ ltBirthCity ] := '';
  FTexts [ ltDeathDay ] := '';
  FTexts [ ltDeathCity ] := '';
  FLettreE := '';
  FLettreS := '';
  FNumSosa := 0;
end;

constructor TPersonLink.Create;
begin
  Inherited;
  FA := TPlot.Create;
  FB := TPlot.Create;
  FC := TPlot.Create;
  FS := TPlot.Create;

  FPlots [ ltLastName ] := TPlot.Create;
  FPlots [ ltName ] := TPlot.Create;
  FPlots [ ltJob ] := TPlot.Create;
  FPlots [ ltBirthDay ] := TPlot.Create;
  FPlots [ ltBirthCity ] := TPlot.Create;
  FPlots [ ltDeathDay ] := TPlot.Create;
  FPlots [ ltDeathCity ] := TPlot.Create;

  Clear;
end;

destructor TPersonLink.Destroy;
begin
  A.Free;
  B.Free;
  C.Free;
  S.Free;

  FPlots [ ltLastName ].Free;
  FPlots [ ltName ].Free;
  FPlots [ ltJob ].Free;
  FPlots [ ltBirthDay ].Free;
  FPlots [ ltBirthCity ].Free;
  FPlots [ ltDeathDay ].Free;
  FPlots [ ltDeathCity ].Free;

  inherited Destroy;
end;

procedure TGraphLink.Print(const DecalX, DecalY: extended);
var
  n: integer;
  indi: TPersonLink;
  astring: string;
  h: extended;
  CouleurFontSexe: TColor;
  w,l: Single;
  lRect: TFloatRect;
  AFont : TFont;
  TextPlots : TGraphLinkTextPlots;

  procedure EcritDansRect(const Text: string; const X1, Y1, X2: double);//AL2009
  begin
    w := Canvas.TextWidth (Text);

    if (X2 - X1) > w then
    begin
      l := (X2 - X1 - w) / 2;
      PaintTextXY(X1 + l, Y1, Text);
    end
    else
    begin
      lrect.Left := X1;
      lrect.Top := Y1;
      lrect.Right := X2;
      lrect.Bottom := Y1+Canvas.TextHeight(Text);
//      with lRect do
  //      PaintRect(Left,Top,Right,Bottom);
      PaintTextRect(lRect, X1, Y1, Text);
    end;
  end;

begin
  if not Assigned(Data) then
    Exit;

  //on récupère la fonte à utilisez, avec la taille en 100 %
  Canvas.Font.Assign(Font);
  Canvas.Font.Size:=GRAPH_BOXES_PRINT_FONT_SIZE;
  try
    Canvas.Font.Color:=clBlack;
    PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
    with Data do
      for n := 0 to Persons.Count - 1 do
      begin
        indi := TPersonLink(Persons[n]);

        //le cadre
        with indi do
         Begin
          if Sexe = 1 then
          begin//homme
            if ltSOSA in FShowTexts
             then PaintSetPen(FColorRectSOSA, psSolid, 0.1, pmCopy)
             else PaintSetPen(FColorRectMan , psSolid, 0.1, pmCopy);
            PaintSetBrush(FColorBackMan, bsSolid);
            if not FBackPaintMan then
              PaintSetBrush(FColorBackMan, bsClear);
          end
          else
          begin//femme
            if ltSOSA in FShowTexts
             then PaintSetPen(FColorRectSOSA , psSolid, 0.1, pmCopy)
             else PaintSetPen(FColorRectWoman, psSolid, 0.1, pmCopy);
            PaintSetBrush(FColorBackWoman, bsSolid);
            if not FBackPaintWoman then
              PaintSetBrush(FColorBackWoman, bsClear);
          end;
          PaintRect(A.XC + DecalX, A.YC + DecalY, B.XC +
            DecalX, B.YC + DecalY);

          //les traits
          if n < Persons.Count - 1 then
          begin
            PaintSetPen(FColorLinks, psSolid, 0.1, pmCopy);
            PaintSetBrush(clBlack, bsClear);
            PaintMoveTo(S.XC + DecalX, S.YC + DecalY);
            PaintLineTo(TPersonLink(Persons[n + 1]).C.XC + DecalX, TPersonLink(
              Persons[n + 1]).C.YC + DecalY);
          end;
          //le texte
          Canvas.Font.Style := [fsUnderline];
          Canvas.Font.Color := CouleurFontSexe;
          PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
          h := Canvas.TextHeight('A');


          for TextPlots:=ltName to ltJob do
           if TextPlots in FShowTexts then
            EcritDansRect(FTexts [ TextPlots ], A.XC + DecalX + 0.5, FPlots [ TextPlots ].YC + DecalY
              , B.XC + DecalX - 0.5);

          if ltBirthDay in FShowTexts then
          begin
            Canvas.Font.Style := [fsUnderline];
            PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
            if FTexts [ ltBirthDay ] <> '' then
            begin
              astring := '°' + FTexts [ ltBirthDay ];
              EcritDansRect(astring, A.XC + DecalX + 0.5, FPlots [ ltBirthDay ].YC + DecalY
                , B.XC + DecalX - 0.5);
              if (ltBirthCity in FShowTexts) and (FTexts [ ltBirthCity ] <> '') then
                EcritDansRect(FTexts [ ltBirthCity ], A.XC + DecalX + 0.5,
                  FPlots [ ltBirthCity ].YC + DecalY
                  , B.XC + DecalX - 0.5);
            end
            else if (ltBirthCity in FShowTexts) and (FTexts [ ltBirthCity ] <> '') then
            begin
              astring := '°' + FTexts [ ltBirthCity ];
              EcritDansRect(astring, A.XC + DecalX + 0.5, FPlots [ ltBirthDay ].YC + DecalY
                , B.XC + DecalX - 0.5);
            end;
          end;

          if ltDeathDay in FShowTexts then
          begin
            Canvas.Font.Style := [fsUnderline];
            PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
            if FTexts [ ltDeathDay ] <> '' then
            begin
              astring := '†' +
              FTexts [ ltDeathDay ];
              EcritDansRect(astring, A.XC + DecalX + 0.5, FPlots [ ltDeathDay ].YC + DecalY
                , B.XC + DecalX - 0.5);
              if (ltDeathCity in FShowTexts) and (FTexts [ ltDeathCity ] <> '') then
                EcritDansRect(FTexts [ ltDeathCity ], A.XC + DecalX + 0.5,
                  FPlots [ ltDeathCity ].YC + DecalY
                  , B.XC + DecalX - 0.5);
            end
            else if (ltDeathCity in FShowTexts) and (FTexts [ ltDeathCity ] <> '') then
            begin
              astring := '†' + FTexts [ ltDeathCity ];
              EcritDansRect(astring, A.XC + DecalX + 0.5, FPlots [ ltDeathDay ].YC + DecalY
                , B.XC + DecalX - 0.5);
            end;
          end;

          if FLettreE > '' then
          begin
            astring := FLettreE;
            w := Canvas.TextWidth(astring) / 2;
            lRect.Left := C.XC + DecalX - w;
            lRect.Top := C.YC + DecalY - h;
            lRect.Right := C.XC + DecalX + w;
            lRect.Bottom := C.YC + DecalY + h;
            PaintSetBrush(clWhite, bsSolid);
            PaintTextRect(lRect, C.XC + DecalX - w, C.YC + DecalY + 1, astring);
          end;

          if FLettreS > '' then
          begin
            astring := FLettreS;
            w := Canvas.TextWidth(astring) / 2;
            lRect.Left := S.XC + DecalX - w;
            lRect.Top := S.YC + DecalY - h;
            lRect.Right := S.XC + DecalX + w;
            lRect.Bottom := S.YC + DecalY + h;
            //PaintGetRect(lRect);
            PaintSetBrush(clWhite, bsSolid);
            PaintTextRect(lRect, S.XC + DecalX - w, S.YC + DecalY + 1, astring);
          end;
        End;

      end;

  finally
  end;
end;

function TGraphLink.GetCleIndividuAtXY(const X, Y: integer;
  var sNom, sNaisDec: string; var iSexe, iGene, iParent: integer): integer;

  function GetStringNaissanceDeces(sn, ln, sd, ld: string): string;
  begin
    Result := '';
    sn := trim(sn);
    ln := trim(ln);
    sd := trim(sd);
    ld := trim(ld);
    if length(sn + ln) > 0 then
    begin
      Result := Result + '°' + sn;
      if (length(sn) > 0) and (length(ln) > 0) then
        Result := Result + '-' + ln
      else
        Result := Result + ln;
    end;
    if length(sd + ld) > 0 then
    begin
      if length(Result) > 0 then
        Result := Result + #13#10 + '' + sd
      else
        Result := '' + sd;
      if (length(sd) > 0) and (length(ld) > 0) then
        Result := Result + '-' + ld
      else
        Result := Result + ld;
    end;
  end;

var
  n: integer;
  indi: TPersonLink;
begin
  Result := -1;
  sNom := '';
  sNaisDec := '';
  iGene := -1;
  iParent := -1;
  with Data do
  for n := 0 to Persons.Count - 1 do
  begin
    indi := TPersonLink(Persons[n]);
    with indi do
     Begin
      if (X >= A.XV + Viewer.ShiftX) and (X <= B.XV + Viewer.ShiftX) and
        (Y >= A.YV + Viewer.ShiftY) and (Y <= B.YV + Viewer.ShiftY) then
        //curseur sur une boîte
      begin
        Result := KeyPerson;
        sNom := AssembleString([FTexts [ ltLastName ], FTexts [ ltName ]]);
        sNaisDec := GetStringNaissanceDeces(FTexts [ ltBirthDay ], FTexts [ ltBirthCity ],
          FTexts [ ltDeathDay ], FTexts [ ltDeathCity ]);
        iSexe := Sexe;
        break;
      end;
    End;
  end;
end;

function TGraphLink.IndiDansListe: integer;
var
  i: integer;
begin
  Result := -1;
  if not assigned ( Data ) then Exit;
  with Data do
  for i := 0 to Persons.Count - 1 do
  begin
    if TPersonLink(Persons[i]).KeyPerson = Viewer.ActivePersonKey then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TGraphLink.PositionIndi(Indi: integer): TPoint;
var
  individu: TPersonLink;
begin
  individu := TPersonLink(Data.Persons[Indi]);
  Result.X := (individu.A.XV + individu.B.XV) div 2 + Viewer.ShiftX;
  Result.Y := (individu.A.YV + individu.B.YV) div 2 + Viewer.ShiftY;
end;

procedure TGraphLink.SetCheckShow(const AShow: TGraphLinkText;
  const ACheck: Boolean);
begin
  if ACheck
  Then FShowTexts:=FShowTexts+[AShow]
  Else FShowTexts:=FShowTexts-[AShow];
end;

procedure TGraphLink.SetCheckOption(const AShow: TGraphLinkOption;
  const ACheck: Boolean);
begin
  if ACheck
  Then FOptions:=FOptions+[AShow]
  Else FOptions:=FOptions-[AShow];
end;

end.
