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

unit u_ancestrotree;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  LCLType, LCLIntf, FPCanvas,
{$ELSE}
  Windows,
{$ENDIF}
  Classes, contnrs,
  SysUtils,
  ExtCtrls,
  Graphics,
  Controls,
  u_ancestroboxes,
  u_ancestroviewer,
  u_objects_components,
  u_objet_graph_TPlot,
  u_common_graph_type;

type
  TGraphTreeText = (ttName, ttLastName, ttJob, ttBirthDay, ttBirthCity,
    ttDeathDay, ttDeathCity, ttMarriage, ttMarriageCity, ttSOSA, ttNCHI);
  TGraphTreeOption = (toOptimise, toDescent, toInverted, toAct, toBourg,
                      toCities,toOptimiseWidth,
                      toSubd, toNameDept, toCodeDept, toRegion, toCountry,
                      toWellKnown);
  TGraphTreeElement = (teBox, teBack, teLink, teSOSA, teBackMan,
    teBackWoman, teTextMan, teTextWoman, teRectMan, teRectWoman);
  TGraphTreePlots = ttName..ttDeathCity;
  TGraphTreeTextArrayPlot = array [TGraphTreePlots] of TPlot;
  TGraphTreeTextArrayText = array [TGraphTreeText] of string;
  TGraphTreeTextArrayBool = array [ttBirthDay..ttMarriageCity] of boolean;
  TGraphTreeElementArray  = array [teBox..teRectWoman] of TColor;
  TGraphTreeElementShowArray = array [teBox..teRectWoman] of boolean;
  TGraphTreeBack = teBackMan..teBackWoman;
  TGraphTreeBacks = set of TGraphTreeBack;
  TGraphTreeTextsShow = set of TGraphTreeText;
  TGraphTreeOptions = set of TGraphTreeOption;

const
  GRAPH_TREE_DEFAULT_COLOR_BOX = clWindowText;
  GRAPH_TREE_DEFAULT_COLOR_LINK = clWindowText;
  GRAPH_TREE_DEFAULT_WIDTH = 30;
  GRAPH_TREE_DEFAULT_HEIGHT = 20;
  GRAPH_TREE_DEFAULT_SHOW_BACK = [teBackMan, teBackWoman];
  GRAPH_TREE_DEFAULT_SHOW_TEXT =
    [ttName, ttLastName, ttJob, ttBirthDay, ttMarriage, ttDeathDay, ttSOSA];
  GRAPH_TREE_DEFAULT_OPTIONS = [];
  GRAPH_TREE_DEFAULT_COLOR_SOSA = clGreen;

type
  TPersonTree = class(TPerson)
  private
    FA: TPlot;
    FB: TPlot;
    FC: TPlot;
    OrdreNiveau: integer;
    //procedure OrdreHommeFemme;
    OrderNum: integer;
  protected

  public
    Parent: TPersonTree;
    Implexe: string;
    ActeMariage: boolean;
    NumSosa: double;//AL2010
    FTexts: TGraphTreeTextArrayText;
    FPlots: TGraphTreeTextArrayPlot;
    FShowed, FShowedPrint: TGraphTreeTextArrayText;
    FAct: TGraphTreeTextArrayBool;
    procedure Order(var NumOrderTete: integer); virtual;
    constructor Create;
    procedure Clear; override;
    destructor Destroy; override;

  end;

  { TGraphTreeData }

  TGraphTreeData = class(TGraphData)

  private
    fStartIndividu: TPersonTree;
  protected
    procedure VerifyObjects(const AGraph: TGraphComponent); virtual;

  public
    procedure Prepare(const ACanvas: TCanvas); override;
    procedure PreparePrint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Order; override;

    property FirstPerson: TPersonTree read fStartIndividu;

  published
  end;

  { TGraphTree }

  TGraphTree = class(TGraphBoxes)

  private
    //    fModeArbre:boolean;
    FColors: TGraphTreeElementArray;
    FShowTexts: TGraphTreeTextsShow;
    FShowBack: TGraphTreeBacks;
    FOptions: TGraphTreeOptions;

    FSpaceBetween2Gen, FSpaceBetween2Person, fSizeFont: single;
    levelMax: integer;
    fNomIndiComplet: string;

    function GetAColor(const AIndex: TGraphTreeElement): TColor;
    procedure SetAColor(const AIndex: TGraphTreeElement; const AValue: TColor);
  protected
    procedure InitGraph(const coef: single); override;
    procedure InitGraphMiniature(const coef: single); override;

    procedure PaintGraph(const ACanvas : TCanvas ; const DecalX, DecalY: integer); override;
    procedure PaintGraphMiniature(const DecalX, DecalY: integer); override;

  public
    constructor Create(Aowner: TComponent); override;
    procedure ReadSectionIni; override;
    procedure WriteSectionIni; override;
    //    function GetNbIndi:integer;

    //disposition
    procedure GetRectEncadrement(var R: TFloatRect); override;
    procedure Print(const DecalX, DecalY: extended); override;

    function GetCleIndividuAtXY(const X, Y: integer; var sNom, sNaisDec: string;
      var iSexe, iGene, iParent: integer): integer; override;
    function IndiDansListe: integer; override;
    function PositionIndi(Indi: integer): TPoint; override;

    procedure SetCheckShow(const AShow : TGraphTreeText; const ACheck : Boolean ); virtual;
    procedure SetCheckOption(const AShow: TGraphTreeOption;
      const ACheck: Boolean); virtual;
    procedure SetCheckElement(const AShow: TGraphTreeBack;
      const ACheck: Boolean); virtual;

    property NomIndiComplet: string read fNomIndiComplet write fNomIndiComplet;
  published
    property ColorBox: TColor index teBox
      read GetAColor write SetAColor default GRAPH_TREE_DEFAULT_COLOR_BOX;
    property ColorLink: TColor index teLink
      read GetAColor write SetAColor default GRAPH_TREE_DEFAULT_COLOR_LINK;
    property ColorRectMan: TColor index teRectMan
      read GetAColor write SetAColor default GRAPH_BOXES_DEFAULT_COLOR_RECT_MAN;
    property ColorRectWoman: TColor index teRectWoman
      read GetAColor write SetAColor default GRAPH_BOXES_DEFAULT_COLOR_RECT_WOMAN;
    property ColorTextMan: TColor index teTextMan
      read GetAColor write SetAColor default GRAPH_BOXES_DEFAULT_COLOR_TEXT_MAN;
    property ColorTextWoman: TColor index teTextWoman
      read GetAColor write SetAColor default GRAPH_BOXES_DEFAULT_COLOR_TEXT_WOMAN;
    property ColorBackMan: TColor index teBackMan
      read GetAColor write SetAColor default GRAPH_BOXES_DEFAULT_COLOR_BACK_MAN;
    property ColorBackWoman: TColor index teBackWoman
      read GetAColor write SetAColor default GRAPH_BOXES_DEFAULT_COLOR_BACK_WOMAN;
    property ColorSOSA: TColor index teSOSA
      read GetAColor write SetAColor default GRAPH_TREE_DEFAULT_COLOR_SOSA;
    property ShowBack: TGraphTreeBacks read FShowBack write FShowBack default
      GRAPH_TREE_DEFAULT_SHOW_BACK;
    property ShowText: TGraphTreeTextsShow
      read FShowTexts write FShowTexts default GRAPH_TREE_DEFAULT_SHOW_TEXT;
    property Options: TGraphTreeOptions read FOptions write FOptions default
      GRAPH_TREE_DEFAULT_OPTIONS;
  end;

implementation

uses
  Forms,
  Math,
  Dialogs,
  u_objet_TGedcomDate,
  u_common_functions,
  u_common_const;

{ TGraphTreeData }

constructor TGraphTreeData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fStartIndividu := TPersonTree.Create;
end;

destructor TGraphTreeData.Destroy;
begin
  inherited Destroy;
end;

procedure TGraphTreeData.Order;
var
  k: integer;
begin
  k := 0;
  fStartIndividu.Order(k);
end;

procedure TGraphTreeData.VerifyObjects(const AGraph: TGraphComponent);
begin
  if not (AGraph is TGraphTree) then
    AbortMessage('Please set a TGraphTreeData type on TGraphViewer.Data.');
end;

procedure TGraphTreeData.Prepare(const ACanvas: TCanvas);
type
  enr = record
    indice: integer;
    hauteur: single
    end;

var
  n, i, j: integer;
  indi, indiParent: TPersonTree;
  OrderMax: integer;
  Decal, interligne, hRectangle, MaxXC, MaxPrec, decalVmar, DecalTexte, Hboite: single;
  CurseurSauve: TCursor;
  TextElement: TGraphTreePlots;
  MaListe: array of enr;
  enrt: enr;
  Inversion: boolean;

  procedure PlaceParents;//place les individus par rapport à ceux de tête
  var
    w, n, k: integer;
    XA, XB: single;
  begin

    with TGraphTree(Graph) do
      for n := levelMax - 1 downto 0 do
        begin
        for w := 0 to Persons.Count - 1 do
          begin
          indi := TPersonTree(Persons[w]);

          if (indi.Level = n) and (indi.OrderNum = 0) then
            begin
            //nb d'enfants
            if indi.Childs.Count = 1 then
              begin
              indi.FA.XC := TPersonTree(indi.Childs[0]).FA.XC;
              indi.FB.XC := TPersonTree(indi.Childs[0]).FB.XC;
              end
            else
              begin
              XA := MaxInt;
              XB := -MaxInt;
              for k := 0 to indi.Childs.Count - 1 do
                begin
                if XA > TPersonTree(indi.Childs[k]).FA.XC then
                  XA := TPersonTree(indi.Childs[k]).FA.XC;
                if XB < TPersonTree(indi.Childs[k]).FA.XC then
                  XB := TPersonTree(indi.Childs[k]).FA.XC;
                end;
              indi.FA.XC := (XA + XB) / 2;
              indi.FB.XC := indi.FA.XC + BoxWidth;
              end;
            indi.FC.XC := (indi.FA.XC + indi.FB.XC) / 2;
            end;
          end;
        end;
  end;

begin
  VerifyObjects(Graph);
  CurseurSauve := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  //on assigne la police, qui correspond à celle utilisée en 100%
  //  fFontText.Name:=Font.Name;
  with TGraphTree(Graph) do
    begin
    levelMax := -1;
    decalVmar := Font.Size * 25.4 / 72;
    if (toCities in FOptions) then
      interligne := decalVmar * 1.3
    else
      interligne := 0;
    Hboite := BoxHeight + 2 * interligne;
    if (ttBirthDay in FShowTexts) then
      begin
      if (toCities in FOptions)
        then decalVmar := 3 * decalVmar
        else decalVmar := 1.6 * decalVmar;
      end
    else
      begin
      decalVmar := 0;
      end;

    for n := 0 to Persons.Count - 1 do
      begin
      indi := TPersonTree(Persons[n]);

      with indi do
        begin
        levelMax := max(level, levelMax);

        if n = 0 then //pour le Caption de la fiche
          begin
          if (toDescent in FOptions) then
            fNomIndiComplet := 'Descendance'
          else
            fNomIndiComplet := 'Ascendance';
          fNomIndiComplet :=
            fNomIndiComplet + ' de ' + AssembleString([FTexts[ttName], FTexts[ttLastName]]) +
            ' ' + GetStringNaissanceDeces(FTexts[ttBirthDay], FTexts[ttDeathDay]);
          end;
        //Y n'étant défini que par level, on place toutes les boîtes en Y
        if ((toDescent in FOptions) and not
          (toInverted in FOptions)) or
          (not (toDescent in FOptions) and (toInverted in FOptions)) then
          begin
          if (toDescent in FOptions) then
            begin
            if (Level and 1) = 1 then //impair
              begin
              FA.YC := MargeTop + Level * (FSpaceBetween2Gen + Hboite + decalVmar / 2) - decalVmar / 2;
              FB.YC := FA.YC + Hboite + decalVmar;
              end
            else
              begin
              FA.YC := MargeTop + Level * (FSpaceBetween2Gen + Hboite + decalVmar / 2);
              FB.YC := FA.YC + Hboite;
              end;
            end
          else
            begin
            FA.YC := MargeTop + Level * (FSpaceBetween2Gen + Hboite + decalVmar);
            FB.YC := FA.YC + Hboite;
            end;
          end
        else
          begin
          if (toDescent in FOptions) then
            begin
            if (Level and 1) = 1 then //impair
              begin
              FB.YC := MargeTop + hRectangle - Level * (FSpaceBetween2Gen + Hboite + decalVmar / 2) + decalVmar / 2;
              FA.YC := FB.YC - Hboite - decalVmar;
              end
            else
              begin
              FB.YC := MargeTop + hRectangle - Level * (FSpaceBetween2Gen + Hboite + decalVmar / 2);
              FA.YC := FB.YC - Hboite;
              end;
            end
          else
            begin
            FB.YC := MargeTop + hRectangle - Level * (FSpaceBetween2Gen + Hboite + decalVmar);
            FA.YC := FB.YC - Hboite;
            end;
          end;
        //on place en X les têtes uniquement, X étant défini par OrderNum
        if OrderNum > 0 then
          begin
          if OrderNum > OrderMax then
            OrderMax := OrderNum;
          FA.XC := MargeLeft + (BoxWidth + FSpaceBetween2Person) * (OrderNum - 1);
          FB.XC := FA.XC + BoxWidth;
          FC.XC := (FA.XC + FB.XC) / 2;
          if FB.XC > MaxXC then
            MaxXC := FB.XC;
          end;
        end;
      end;

    MaxXC := 0;
    OrderMax := 0;// init ordre maxi des têtes
    if (toDescent in FOptions) then
      begin
      if Odd(levelMax) then
        hRectangle := (levelMax - 1) *
          (Hboite + FSpaceBetween2Gen + decalVmar / 2) + FSpaceBetween2Gen + 2 * Hboite + decalVmar
      else
        hRectangle := levelMax * (Hboite + FSpaceBetween2Gen + decalVmar / 2) + Hboite;
      end
    else
      hRectangle := levelMax * (Hboite + FSpaceBetween2Gen + decalVmar) + Hboite;


    PlaceParents;//pour placer les autres boîtes en X par rapport aux têtes
    if (toOptimise in FOptions) then
      begin
      MaListe := nil;//initialisation du tableau
      for n := 1 to levelMax do //on fait un tableau par niveau
        begin
        j := 0;
        for i := 0 to Persons.Count - 1 do //on remplit le tableau du niveau
          begin
          if TPersonTree(Persons[i]).Level = n then
            begin
            Inc(j);
            SetLength(MaListe, j);
            MaListe[j - 1].indice := i;
            MaListe[j - 1].hauteur := TPersonTree(Persons[i]).FA.XC;
            end;
          end;
        //on trie le tableau
        Inversion := True;
        while Inversion do
          begin
          Inversion := False;
          for i := 0 to j - 2 do
            begin
            if MaListe[i].hauteur > MaListe[i + 1].hauteur then
              begin
              Inversion := True;
              enrt := MaListe[i];
              MaListe[i] := MaListe[i + 1];
              MaListe[i + 1] := enrt;
              end;
            end;
          end;
        //on affecte les OrdreNiveau
        for i := 0 to j - 1 do
          TPersonTree(Persons[MaListe[i].indice]).OrdreNiveau := i;
        MaListe := nil;//initialisation du tableau
        end;


      repeat
        MaxPrec := MaxXC;
        MaxXC := 0;

        for n := OrderMax - 1 downto 1 do
          //on prend les têtes (noeuds sans enfants) à partir de l'avant dernière
          begin
          for i := 0 to Persons.Count - 1 do
            if TPersonTree(Persons[i]).OrderNum = n then
              break;
          indi := TPersonTree(Persons[i]);//l'individu de tête
          with indi do
            begin
            for i := 0 to Persons.Count - 1 do
              //on cherche FB.XC de l'indi le plus ? droite
              if (TPersonTree(Persons[i]).Level = Level) and
                (TPersonTree(Persons[i]).FB.XC > MaxXC) then
                MaxXC := TPersonTree(Persons[i]).FB.XC;
            Decal := MaxXC - FB.XC;
            //la distance depuis le bord est le décalage maxi possible
            MaxXC := 0;
            indiParent := indi;
            while indiParent <> nil do
              //pour chaque noeud et ses parents on recherche le décalage possible
              begin//par rapport aux autres noeuds plus proches du bord au m?me niveau
              for i := 0 to Persons.Count - 1 do
                if (TPersonTree(Persons[i]).Level = indiParent.Level)
                  and (TPersonTree(Persons[i]).OrdreNiveau >
                  indiParent.OrdreNiveau) then
                  //pas tr?s bon car le d?placement r?el du parent peut ?tre inf?rieur ? cette distance
                  Decal :=
                    Min(Decal, TPersonTree(Persons[i]).FA.XC - indiParent.FB.XC - FSpaceBetween2Person);
              indiParent := indiParent.Parent;
              end;
            FA.XC := FA.XC + Decal;//on applique le décalage au noeud
            FB.XC := FB.XC + Decal;
            FC.XC := (FA.XC + FB.XC) / 2;
            for j := 1 to n - 1 do //et ? tous les pr?FC?dents
              begin
              for i := 0 to Persons.Count - 1 do
                if TPersonTree(Persons[i]).OrderNum = j then
                  break;
              indi := TPersonTree(Persons[i]);
              FA.XC := FA.XC + Decal;//on applique le décalage au noeud
              FB.XC := FB.XC + Decal;
              FC.XC := (FA.XC + FB.XC) / 2;
              end;
            end;
          PlaceParents;
          end;

        for n := 1 to OrderMax do
          //on prend les têtes (noeuds sans enfants) ? partir de la premi?re
          begin
          for i := 0 to Persons.Count - 1 do
            if TPersonTree(Persons[i]).OrderNum = n then
              break;
          indi := TPersonTree(Persons[i]);//l'individu de tête
          Decal := indi.FA.XC - MargeLeft;
          //la distance depuis le bord est le décalage maxi possible
          with indi do
            begin
            indiParent := indi;
            while indiParent <> nil do
              //pour chaque noeud et ses parents on recherche le décalage possible
              begin//par rapport aux autres noeuds plus proches du bord au même niveau
              for i := 0 to Persons.Count - 1 do
                if (TPersonTree(Persons[i]).Level = indiParent.Level)
                  and (TPersonTree(Persons[i]).OrdreNiveau <
                  indiParent.OrdreNiveau) then
                  //pas très bon car le déplacement réel du parent peut être inférieur à cette distance
                  Decal :=
                    Min(Decal, indiParent.FA.XC - TPersonTree(Persons[i]).FB.XC - FSpaceBetween2Person);
              indiParent := indiParent.Parent;
              end;
            FA.XC := FA.XC - Decal;//on applique le décalage au noeud
            FB.XC := FB.XC - Decal;
            if FB.XC > MaxXC then
              MaxXC := FB.XC;
            FC.XC := (FA.XC + FB.XC) / 2;
            for j := n + 1 to OrderMax do //et ? tous les suivants
              begin
              for i := 0 to Persons.Count - 1 do
                if TPersonTree(Persons[i]).OrderNum = j then
                  break;
              indi := TPersonTree(Persons[i]);
              FA.XC := FA.XC - Decal;//on applique le décalage au noeud
              FB.XC := FB.XC - Decal;
              if FB.XC > MaxXC then
                MaxXC := FB.XC;
              FC.XC := (FA.XC + FB.XC) / 2;
              end;
            end;
          PlaceParents;
          end;
      until MaxXC >= MaxPrec;
      end;

    //les textes
    for n := 0 to Persons.Count - 1 do
      begin
       indi := TPersonTree(Persons[n]);
       J:=0;
       with indi do
        begin
          if (toDescent in FOptions) and ((Level and 1) = 1)
            then DecalTexte := decalVmar
            else DecalTexte := 0;
          for TextElement := ttName to ttDeathCity do
            if TextElement in FShowTexts Then
              Begin
                FPlots[TextElement].YC := FA.YC + LineHeight * j + DecalTexte;
                inc(j);
              end;
        end;
      end;

    end;
  Screen.Cursor := CurseurSauve;
end;

procedure TGraphTreeData.PreparePrint;
begin
  //ne fait rien dans ce cas, mais appelé car utilisé dans tgrapharcdata
end;

constructor TGraphTree.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);

  // default font
  Font.Name := 'Tahoma';
  Font.Size := 8;
  Font.Color := clWindowText;

  // component colors init
  FColors[teBox] := GRAPH_TREE_DEFAULT_COLOR_BOX;
  FColors[teRectMan] := GRAPH_BOXES_DEFAULT_COLOR_RECT_MAN;
  FColors[teRectWoman] := GRAPH_BOXES_DEFAULT_COLOR_RECT_WOMAN;
  FColors[teTextMan] := GRAPH_BOXES_DEFAULT_COLOR_TEXT_MAN;
  FColors[teTextWoman] := GRAPH_BOXES_DEFAULT_COLOR_TEXT_WOMAN;
  FColors[teBackMan] := GRAPH_BOXES_DEFAULT_COLOR_BACK_MAN;
  FColors[teBackWoman] := GRAPH_BOXES_DEFAULT_COLOR_BACK_WOMAN;
  FColors[teSOSA] := GRAPH_TREE_DEFAULT_COLOR_SOSA;

  // component init
  FShowBack := GRAPH_TREE_DEFAULT_SHOW_BACK;
  FShowTexts := GRAPH_TREE_DEFAULT_SHOW_TEXT;
  FOptions := GRAPH_TREE_DEFAULT_OPTIONS;

  // objects creation
  //  fFontText:=TFont.create;
end;

procedure TGraphTree.ReadSectionIni;
begin
  inherited;
  ReadInteger(GRAPH_INI_COLORBOX);
  ReadInteger(GRAPH_INI_COLORLINK);
  ReadInteger(GRAPH_INI_COLORRECTMAN);
  ReadInteger(GRAPH_INI_COLORRECTWOMAN);
  ReadInteger(GRAPH_INI_COLORTEXTWOMAN);
  ReadInteger(GRAPH_INI_COLORTEXTMAN);
  ReadInteger(GRAPH_INI_COLORBACKWOMAN);
  ReadInteger(GRAPH_INI_COLORTEXTMAN);
  ReadInteger(GRAPH_INI_COLORSOSA);
  ReadInteger(GRAPH_INI_LINE_HEIGHT);
  ReadSet(GRAPH_INI_SHOWBACK);
  ReadSet(GRAPH_INI_SHOWTEXT);
end;

procedure TGraphTree.WriteSectionIni;
begin
  inherited;
  WriteInteger(GRAPH_INI_COLORBOX);
  WriteInteger(GRAPH_INI_COLORLINK);
  WriteInteger(GRAPH_INI_COLORRECTMAN);
  WriteInteger(GRAPH_INI_COLORRECTWOMAN);
  WriteInteger(GRAPH_INI_COLORTEXTWOMAN);
  WriteInteger(GRAPH_INI_COLORTEXTMAN);
  WriteInteger(GRAPH_INI_COLORBACKWOMAN);
  WriteInteger(GRAPH_INI_COLORTEXTMAN);
  WriteInteger(GRAPH_INI_COLORSOSA);
  WriteInteger(GRAPH_INI_LINE_HEIGHT);
  WriteSet(GRAPH_INI_SHOWBACK);
  WriteSet(GRAPH_INI_SHOWTEXT);
end;

procedure TGraphTree.InitGraphMiniature(const coef: single);
var
  n: integer;
begin
  with Data do
    for n := 0 to Persons.Count - 1 do
      begin
      TPersonTree(Persons[n]).FA.CoordChantier_2_CoordMiniature(coef);
      TPersonTree(Persons[n]).FB.CoordChantier_2_CoordMiniature(coef);
      TPersonTree(Persons[n]).FC.CoordChantier_2_CoordMiniature(coef);
      end;
end;

procedure TGraphTree.InitGraph(const coef: single);
var
  n: integer;
  indi: TPersonTree;
  TextElement: TGraphTreePlots;
begin
  fSizeFont := coef * Font.Size * 25.4 / Screen.PixelsPerInch;

  //les individus
  with Data do
    for n := 0 to Persons.Count - 1 do
      begin
      indi := TPersonTree(Persons[n]);

      with indi do
        begin
        FA.CoordChantier_2_CoordViewer(coef);
        FB.CoordChantier_2_CoordViewer(coef);
        FC.CoordChantier_2_CoordViewer(coef);

        for TextElement := ttName to ttDeathCity do
          FPlots[TextElement].YV := round(FPlots[TextElement].YC * coef);

        end;
      end;
end;

procedure TGraphTree.GetRectEncadrement(var R: TFloatRect);
var
  n: integer;
  indi: TPersonTree;
begin
  //Rectangle de délimitation de tout le chantier, en m
  R.left := Maxint;
  R.Top := Maxint;
  R.Right := -Maxint;
  R.Bottom := -Maxint;

  with Data do
    for n := 0 to Persons.Count - 1 do
      begin
      indi := TPersonTree(Persons[n]);

      with indi do
        begin
        if R.Left > FA.XC then
          R.Left := FA.XC;
        if R.Right < FA.XC then
          R.Right := FA.XC;
        if R.Top > FA.YC then
          R.Top := FA.YC;
        if R.Bottom < FA.YC then
          R.Bottom := FA.YC;

        if R.Left > FB.XC then
          R.Left := FB.XC;
        if R.Right < FB.XC then
          R.Right := FB.XC;
        if R.Top > FB.YC then
          R.Top := FB.YC;
        if R.Bottom < FB.YC then
          R.Bottom := FB.YC;
        end;
      end;
  R.Right := R.Right + MargeLeft;
  R.Bottom := R.Bottom + MargeTop;
end;

procedure TGraphTree.PaintGraph(const ACanvas : TCanvas ; const DecalX, DecalY: integer);
var
  l: integer;
  lRect: TRect;

  procedure EcritDansRect(const s: string;const AX, AY, BX, BY: integer);//AL2009
  begin
    lRect := Rect(AX, AY, BX, BY);
    with ACanvas do
      begin
      DrawText(ACanvas.handle, PChar(s), -1, lRect, DT_CALCRECT);
      l := lRect.Right - lRect.Left;
      lRect := Rect(AX, AY, BX, BY);
      if l > BX - AX
        then DrawText(ACanvas.handle, PChar(s), -1, lRect, DT_LEFT)
        else DrawText(ACanvas.handle, PChar(s), -1, lRect, DT_CENTER);
      //        writeln ( IntToStr ( AX ) + ' ' + IntToStr ( AY ) + ' ' + IntToStr ( BX ) + ' ' + IntToStr ( BY ));
      end;
  end;

var
  n, k: integer;
  ym, h, h1, h2, xa, ya, xb, yb: integer;
  indi, indiChild: TPersonTree;
  TextElement: TGraphTreeText;
  s: string;
  CouleurFontSexe: TColor;
  bIndiPresent: boolean;
begin
  //on adapte la taille en fonction du zoom
  ACanvas.Font.Size := round(fSizeFont);
  ACanvas.Font.Name := Font.Name;
  h := Abs(round(fSizeFont));
  h1 := Abs(round(fSizeFont * 2.5));//hauteur de la boîte mariage si une ligne
  h2 := Abs(round(fSizeFont * 4));//si 2 lignes
  bIndiPresent := False;//ne sera activé que si indi en cours dans l'arbre
  with Data do
    for n := 0 to Persons.Count - 1 do
      begin
      indi := TPersonTree(Persons[n]);
      with indi do
        begin
        if Implexe <> '' then
          begin
          ACanvas.Pen.Style := psDot;
          ACanvas.Brush.Style := bsFDiagonal;
          end
        else
          begin
          ACanvas.Pen.Style := psSolid;
          ACanvas.Brush.Style := bsSolid;
          end;

        //le cadre
        if Sexe = 1 then
          begin
          //homme
          ACanvas.Pen.Color := FColors[teRectMan];
          ACanvas.Brush.Color := FColors[teBackMan];
          if not (teBackMan in FShowBack) then
            ACanvas.Brush.Style := bsClear;
          CouleurFontSexe := FColors[teTextMan];
          end
        else
          begin
          //femme
          ACanvas.Pen.Color := FColors[teRectWoman];
          ACanvas.Brush.Color := FColors[teBackWoman];
          if not (teBackWoman in FShowBack) then
            ACanvas.Brush.Style := bsClear;
          CouleurFontSexe := FColors[teTextWoman];
          end;
        if NumSosa > 0 then //AL2010
          begin
          ACanvas.Pen.Color := FColors[teSOSA];
          //CouleurFontSexe:=_COLOR_SOSA;
          end;
        if KeyPerson = KeyFirst then
          begin
          ACanvas.Pen.Width := 2;
          bIndiPresent := True;
          end
        else
          ACanvas.Pen.Width := 1;
        if (toDescent in FOptions) and (ttBirthDay in FShowTexts) and
          ((Level and 1) = 1) then
          begin
          ACanvas.RoundRect(FA.XV + DecalX, FA.YV + DecalY, FB.XV + DecalX, FB.YV + DecalY
            , round(fSizeFont), round(fSizeFont));
          end
        else
          ACanvas.Rectangle(FA.XV + DecalX, FA.YV + DecalY, FB.XV + DecalX, FB.YV + DecalY);
        //            writeln ( InttoStr ( FA.XV+DecalX ) + ' ' + InttoStr ( FA.YV +DecalX) + ' ' + InttoStr ( FB.XV+DecalX ) + ' ' + InttoStr ( FB.YV+DecalX ) + ' ' + FloattoStr ( fSizeFont) + ' ' + FloattoStr ( fSizeFont ));
        //les traits
        ACanvas.Pen.Width := 1;
        ACanvas.Pen.Style := psSolid;
        ACanvas.Pen.Color := FColors[teLink];
        ym := 0;
        if Childs.Count > 0 then
          begin
          for k := 0 to Childs.Count - 1 do
            begin
            indiChild := TPersonTree(Childs[k]);
            if (FOptions * [toDescent, toInverted] = [toDescent]) or
              (FOptions * [toDescent, toInverted] = [toInverted]) then
              begin
              ACanvas.MoveTo(FC.XV + DecalX, FB.YV + DecalY);
              ym := round((FB.YV + indiChild.FA.YV) / 2 + DecalY);
              ACanvas.LineTo(FC.XV + DecalX, ym);
              ACanvas.LineTo(indiChild.FC.XV + DecalX, ym);
              ACanvas.LineTo(indiChild.FC.XV + DecalX, indiChild.FA.YV + DecalY);
              end
            else
              begin
              ACanvas.MoveTo(FC.XV + DecalX, FA.YV + DecalY);
              ym := round((FA.YV + indiChild.FB.YV) / 2 + DecalY);
              ACanvas.LineTo(FC.XV + DecalX, ym);
              ACanvas.LineTo(indiChild.FC.XV + DecalX, ym);
              ACanvas.LineTo(indiChild.FC.XV + DecalX, indiChild.FB.YV + DecalY);
              end;
            end;
          end;
        if (ttMarriage in FShowTexts) then
         begin
          if (toDescent in FOptions) then
            begin
            if (Level and 1) = 1 then      // niveau impair uniquement
              begin
              xa := FA.XV + DecalX;
              xb := FB.XV + DecalX;
              ya := FA.YV + DecalY;
              yb := FB.YV + DecalY;
              ACanvas.Font.Color := CouleurFontSexe;
              if (toAct in FOptions) and not ActeMariage
                then ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderline]
                else ACanvas.Font.Style := ACanvas.Font.Style - [fsUnderline];
              if FTexts[ttMarriage] <> '' then
                begin
                s := 'x ' + FTexts[ttMarriage];
                EcritDansRect(s, xa + 1, ya + 1, xb - 1, yb);
                if (toCities in FOptions) and (FTexts[ttMarriageCity] <> '') then
                  begin
                  EcritDansRect(FTexts[ttMarriageCity], xa + 1, ya +
                    h1-1, xb - 1, yb);
                  end;
                end
              else if (toCities in FOptions) and (FTexts[ttMarriageCity] <> '') then
                begin
                s := 'x ' + FTexts[ttMarriageCity];
                EcritDansRect(s, xa + 1, ya + 1, xb - 1, yb);
                end
              else
                begin
                EcritDansRect('x', xa + 1, ya + 1, xb - 1, yb);
                end;
              end;
            end
          else
            begin
            if ((FTexts[ttMarriage] <> '') or (FTexts[ttMarriageCity] <> '')) and
              (OrderNum = 0) then
              begin
              if (FTexts[ttMarriage] <> '') and (FTexts[ttMarriageCity] <> '') and
                (toCities in FOptions) then
                h := h2
              else
                h := h1;
              xa := FA.XV + DecalX;
              xb := FB.XV + DecalX;
              ya := ym - (h div 2);
              yb := ya + h;
              ACanvas.Pen.Color := FColors[teLink];
              ACanvas.Brush.Color := clWhite;
              ACanvas.Brush.Style := bsSolid;
              ACanvas.RoundRect(xa, ya, xb, yb, ACanvas.Font.Size, ACanvas.Font.Size);
              if ACanvas.Font.Size >= 1 then
                begin
                ACanvas.Font.Color := FColors[teLink];
                if (toAct in FOptions) and not ActeMariage then
                  ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderline]
                else
                  ACanvas.Font.Style := ACanvas.Font.Style - [fsUnderline];
                ACanvas.Brush.Style := bsClear;
                if FTexts[ttMarriage] <> '' then
                  begin
                  s := 'x ' + FTexts[ttMarriage];
                  EcritDansRect(s, xa + 1, ya + 1, xb - 1, yb);
                  if (toCities in FOptions) and (FTexts[ttMarriageCity] <> '') then
                    EcritDansRect(FTexts[ttMarriageCity], xa + 1, ya + h1, xb - 1, yb);
                  end
                else if (toCities in FOptions) and (FTexts[ttMarriageCity] <> '') then
                  begin
                  s := 'x ' + FTexts[ttMarriageCity];
                  EcritDansRect(s, xa + 1, ya+1, xb - 1, yb);
                  end;
                end;
              end;
            end;
          end;

        if ACanvas.Font.Size >= 1 then
          begin
          ACanvas.Brush.Style := bsClear;

          ACanvas.Font.Color := CouleurFontSexe;
          ACanvas.Font.Style := ACanvas.Font.Style - [fsUnderline];

          for TextElement := ttName to ttSOSA do
            begin
            case TextElement of
              ttName, ttLastName, ttJob:
                if FTexts[TextElement] <> '' then
                  EcritDansRect(FTexts[TextElement], FA.XV +
                    DecalX + 1, FPlots[TextElement].YV + DecalY
                    , FB.XV + DecalX - 1, FB.YV + DecalY);
              ttBirthDay:
                begin
                if (toAct in FOptions) and not
                  (ttBirthDay in FShowTexts)
                 then ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderline]
                 else ACanvas.Font.Style := ACanvas.Font.Style - [fsUnderline];

                if FTexts[TextElement] <> '' then
                  begin
                  s := '°' + FTexts[TextElement];
                  EcritDansRect(FTexts[TextElement], FA.XV +
                    DecalX + 1, FPlots[TextElement].YV + DecalY
                    , FB.XV + DecalX - 1, FB.YV + DecalY);
                  if (toCities in FOptions) and
                    (FTexts[ttBirthCity] <> '') then
                    begin
                    EcritDansRect(FTexts[ttBirthCity],
                      FA.XV + DecalX + 1, FPlots[ttBirthCity].YV + DecalY
                      , FB.XV + DecalX - 1, FB.YV + DecalY);
                    end;
                  end
                else if (toCities in FOptions) and
                  (FTexts[ttBirthCity] <> '') then
                  begin
                  s := '°' + FTexts[ttBirthCity];
                  EcritDansRect(FTexts[ttBirthCity],
                    FA.XV + DecalX + 1, FPlots[ttBirthDay].YV + DecalY
                    , FB.XV + DecalX - 1, FB.YV + DecalY);
                  end;
                end;
              ttDeathDay:
                begin
                if (toAct in FOptions) and not
                  (ttDeathDay in FShowTexts) then
                  ACanvas.Font.Style := ACanvas.Font.Style + [fsUnderline]
                else
                  ACanvas.Font.Style := ACanvas.Font.Style - [fsUnderline];

                if FTexts[TextElement] <> '' then
                  begin
                  s := '†' + FTexts[TextElement];
                  EcritDansRect(FTexts[TextElement], FA.XV +
                    DecalX + 1, FPlots[TextElement].YV + DecalY
                    , FB.XV + DecalX - 1, FB.YV + DecalY);
                  if (toCities in FOptions) and
                    (FTexts[ttDeathCity] <> '') then
                    begin
                    EcritDansRect(FTexts[ttDeathCity],
                      FA.XV + DecalX + 1, FPlots[ttDeathCity].YV + DecalY
                      , FB.XV + DecalX - 1, FB.YV + DecalY);
                    end;
                  end
                else if (toCities in FOptions) and
                  (FTexts[ttDeathCity] <> '') then
                  begin
                  s := '†' + FTexts[ttDeathCity];
                  EcritDansRect(FTexts[ttDeathCity],
                    FA.XV + DecalX + 1, FPlots[ttDeathDay].YV + DecalY
                    , FB.XV + DecalX - 1, FB.YV + DecalY);
                  end;
                end;
              ttSOSA:
                begin
                s := FTexts[ttSOSA];
                l := ACanvas.TextWidth(s);
                lRect := Rect(FB.XV + DecalX - 2 - l, FB.YV + DecalY - ACanvas.TextHeight(s), FB.XV + DecalX, FB.YV + DecalY);
                ACanvas.Brush.Style := bsSolid;
                DrawText(ACanvas.handle, PChar(s), -1, lRect,
                  DT_CENTER + DT_VCENTER);
                end;
              end;
            end;
          end;

        end;
      end;
  p_setButtonEnabled(bIndiPresent);
end;

procedure TGraphTree.PaintGraphMiniature(const DecalX, DecalY: integer);
var
  n, k: integer;
  indi: TPersonTree;
begin
  if Parent.Visible then
    begin
    Canvas.Pen.Color := clRed;
    Canvas.Pen.Style := psSolid;

    with Data do
      for n := 0 to Persons.Count - 1 do
        begin
        indi := TPersonTree(Persons[n]);

        with indi do
          begin
          //le cadre
          Canvas.MoveTo(FA.XM + DecalX, FA.YM + DecalY);
          Canvas.LineTo(FB.XM + DecalX, FA.YM + DecalY);
          Canvas.LineTo(FB.XM + DecalX, FB.YM + DecalY);
          Canvas.LineTo(FA.XM + DecalX, FB.YM + DecalY);
          Canvas.LineTo(FA.XM + DecalX, FA.YM + DecalY);

          //les traits
          if Childs.Count > 0 then
            begin
            for k := 0 to Childs.Count - 1 do
              begin
              if ((toDescent in FOptions) and not
                (toInverted in FOptions)) or
                (not (toDescent in FOptions) and (toInverted in FOptions)) then
                begin
                Canvas.MoveTo(FC.XM + DecalX, FB.YM + DecalY);
                Canvas.LineTo(TPersonTree(Childs[k]).FC.XM +
                  DecalX, TPersonTree(Childs[k]).FA.YM + DecalY);
                end
              else
                begin
                Canvas.MoveTo(FC.XM + DecalX, FA.YM + DecalY);
                Canvas.LineTo(TPersonTree(Childs[k]).FC.XM +
                  DecalX, TPersonTree(Childs[k]).FB.YM + DecalY);
                end;
              end;
            end;
          end;
        end;
    end;
end;

procedure TGraphTree.SetCheckShow(const AShow: TGraphTreeText;
  const ACheck: Boolean);
begin
  if ACheck
  Then FShowTexts:=FShowTexts+[AShow]
  Else FShowTexts:=FShowTexts-[AShow];

end;

procedure TGraphTree.SetCheckOption(const AShow: TGraphTreeOption;
  const ACheck: Boolean);
begin
  if ACheck
  Then FOptions:=FOptions+[AShow]
  Else FOptions:=FOptions-[AShow];

end;

procedure TGraphTree.SetCheckElement(const AShow: TGraphTreeBack;
  const ACheck: Boolean);
begin
  if ACheck
  Then FShowBack:=FShowBack+[AShow]
  Else FShowBack:=FShowBack-[AShow];

end;

{$WARNINGS ON}
{ TPersonTree }

procedure TPersonTree.Clear;
var
  TextElement: TGraphTreeText;
begin
  KeyPerson := -1;
  Level := 0;
  for TextElement := low(TGraphTreeText) to high(TGraphTreeText) do
    begin
    FTexts[TextElement] := '';
    end;
  OrderNum := 0;
  Implexe := '';
  NumSosa := 0;//AL2010
  inherited;
end;

constructor TPersonTree.Create;
var
  TextElement: TGraphTreePlots;
begin
  FA := TPlot.Create;
  FB := TPlot.Create;
  FC := TPlot.Create;

  for TextElement := low(TGraphTreePlots) to high(TGraphTreePlots) do
    FPlots[TextElement] := TPlot.Create;
  inherited;
end;

destructor TPersonTree.Destroy;
var
  TextElement: TGraphTreeText;
begin
  FA.Free;
  FB.Free;
  FC.Free;

  for TextElement := low(TGraphTreeText) to high(TGraphTreeText) do
    FPlots[TextElement].Free;

  inherited Destroy;
end;

function TGraphTree.GetAColor(const AIndex: TGraphTreeElement): TColor;
begin
  Result := FColors[AIndex];
end;

procedure TGraphTree.SetAColor(const AIndex: TGraphTreeElement; const AValue: TColor);
begin
  FColors[AIndex] := AValue;

end;

procedure TPersonTree.Order(var NumOrderTete: integer);
var
  n: integer;
begin
  if Childs.Count = 0 then
    begin
    Inc(NumOrderTete);
    OrderNum := NumOrderTete;
    end
  else
    begin
    for n := 0 to Childs.Count - 1 do
      TPersonTree(Childs[n]).Order(NumOrderTete);
    end;
end;

{procedure TPersonTree.OrdreHommeFemme; //pas utilis?
var
  n:integer;
begin
  if Childs.count=2 then
    if TPersonTree(Childs[0]).Sexe=2 then //femme
      Childs.Exchange(0,1);//invertion

  //on ordonne les suivants
  for n:=0 to Childs.count-1 do
    TPersonTree(Childs[n]).OrdreHommeFemme;
end;}

{function TGraphTree.GetNbIndi:integer;
begin
  result:=Persons.count;
end;}

procedure TGraphTree.Print(const DecalX, DecalY: extended);
var
  n, k: integer;
  indi: TPersonTree;
  s: string;
  ym, h, xa, xb, ya, yb: extended;
  CouleurFontSexe: TColor;
  l: double;
  lRect: TFloatRect;
  TextElement: TGraphTreeText;

  procedure EcritDansRect(const Text: string;const X1, Y1, X2: double);//MG2014
  var w,h : Single;
  begin
    w := Canvas.TextWidth (Text);
    h := Canvas.TextHeight(Text);

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
        lrect.Bottom := Y1+h;
        // with LRect do
        //   PaintRect(Left,Top,Right,Bottom);
        PaintTextRect(lRect,X1,Y1, Text);
      end;
  end;

begin
  h := GRAPH_BOXES_PRINT_FONT_SIZE * 25.4 / 72;
  ya := 0;
  yb := 0;
  with Canvas.Font do
    Begin
      Assign(Font);
      Size := GRAPH_BOXES_PRINT_FONT_SIZE;
      Color := clBlack;
    end;
  try
    PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
    //on récupère la fonte à utiliser, avec la taille en 100 %
    {
    rp.SetFont(fFontText.Name,fFontText.Size);
    rp.Bold:=(fsBold in fFontText.Style);
    rp.Italic:=(fsItalic in fFontText.Style);
    rp.StrikeOut:=(fsStrikeOut in fFontText.Style);
  }
    with Data do
      for n := 0 to Persons.Count - 1 do
        begin
        indi := TPersonTree(Persons[n]);

        //le cadre
        with indi do
          begin
          if Sexe = 1 then
            begin //homme
            if Implexe <> '' then
              begin
              if (ttSOSA in FShowTexts) and (NumSosa > 0)
                then PaintSetPen(FColors[teSOSA], psDot, 0.2, pmCopy)
                else PaintSetPen(FColors[teRectMan], psDot, 0.2, pmCopy);
              PaintSetBrush(FColors[teBackMan], bsFDiagonal);
              end
            else
              begin
              if (ttSOSA in FShowTexts) and (NumSosa > 0)
                then PaintSetPen(FColors[teSOSA], psSolid, 0.2, pmCopy)
                else PaintSetPen(FColors[teRectMan], psSolid, 0.2, pmCopy);
              PaintSetBrush(FColors[teBackMan], bsSolid);
              end;
            if not (teBackMan in FShowBack) then
              PaintSetBrush(FColors[teBackMan], bsClear);
            CouleurFontSexe := FColors[teTextMan];
            end
          else
            begin //femme
            if Implexe <> '' then
              begin
              if (ttSOSA in FShowTexts) and (NumSosa > 0)
                then PaintSetPen(FColors[teSOSA], psDot, 0.2, pmCopy)
                else PaintSetPen(FColors[teRectWoman], psDot, 0.2, pmCopy);
              PaintSetBrush(FColors[teBackWoman], bsFDiagonal);
              end
            else
              begin
              if (ttSOSA in FShowTexts) and (NumSosa > 0)
                then PaintSetPen(FColors[teSOSA], psSolid, 0.2, pmCopy)
                else PaintSetPen(FColors[teRectWoman], psSolid, 0.2, pmCopy);
              PaintSetBrush(FColors[teBackWoman], bsSolid);
              end;
            if not (teBackWoman in FShowBack) then
              PaintSetBrush(FColors[teBackWoman], bsClear);
            CouleurFontSexe := FColors[teTextWoman];
            end;
          h := Canvas.TextHeight('A')+1;
          if (toDescent in FOptions) and (ttBirthDay in FShowTexts) and
            ((Level and 1) = 1)
            then PaintRoundRect(FA.XC + DecalX, FA.YC + DecalY, FB.XC + DecalX, FB.YC + DecalY, h, h)
            else PaintRect     (FA.XC + DecalX, FA.YC + DecalY, FB.XC + DecalX, FB.YC + DecalY);

          //les traits
          PaintSetPen(FColors[teLink], psSolid, 0.2, pmCopy);
          PaintSetBrush(clBlack, bsClear);
          if Childs.Count > 0 then
            begin
            for k := 0 to Childs.Count - 1 do
              begin
              if ((toDescent in FOptions) and not
                (toInverted in FOptions)) or
                (not (toDescent in FOptions) and (toInverted in FOptions)) then
                begin
                PaintMoveTo(FC.XC + DecalX, FB.YC + DecalY);
                ym := (FB.YC + TPersonTree(Childs[k]).FA.YC) / 2 + DecalY;
                if toCities in FOptions
                 then
                  begin
                  ya := ym - 1.5 * h;
                  yb := ym + 1.5 * h;
                  end
                else
                  begin
                  ya := ym - 0.8 * h;
                  yb := ym + 0.8 * h;
                  end;
                if (ttBirthDay in FShowTexts) and
                  ((FTexts[ttMarriage] <> '') or (FTexts[ttMarriageCity] <> '')) and
                  (OrderNum = 0) and not (toDescent in FOptions) then
                  begin
                  PaintLineTo(FC.XC + DecalX, ya);
                  if TPersonTree(Childs[k]).FC.XC > FC.XC then
                    PaintMoveTo(FB.XC + DecalX, ym)
                  else if TPersonTree(Childs[k]).FC.XC < FC.XC then
                    PaintMoveTo(FA.XC + DecalX, ym)
                  else
                    PaintMoveTo(FC.XC + DecalX, yb);
                  end
                else
                  PaintLineTo(FC.XC + DecalX, ym);

                if TPersonTree(Childs[k]).FC.XC <> FC.XC then
                  PaintLineTo(TPersonTree(Childs[k]).FC.XC + DecalX, ym);
                PaintLineTo(TPersonTree(Childs[k]).FC.XC + DecalX,
                  TPersonTree(Childs[k]).FA.YC + DecalY);
                end
              else
                begin
                PaintMoveTo(FC.XC + DecalX, FA.YC + DecalY);
                ym := (FA.YC + TPersonTree(Childs[k]).FB.YC) / 2 + DecalY;
                if (toCities in FOptions) and (FTexts[ttMarriage] <> '') and
                  (FTexts[ttMarriageCity] <> '') then
                  begin
                  ya := ym - 1.5 * h;
                  yb := ym + 1.5 * h;
                  end
                else
                  begin
                  ya := ym - 0.8 * h;
                  yb := ym + 0.8 * h;
                  end;
                if (ttBirthDay in FShowTexts) and
                  ((FTexts[ttMarriage] <> '') or (FTexts[ttMarriageCity] <> '')) and
                  (OrderNum = 0) and not (toDescent in FOptions) then
                  begin
                  PaintLineTo(FC.XC + DecalX, yb);
                  if TPersonTree(Childs[k]).FC.XC > FC.XC then
                    PaintMoveTo(FB.XC + DecalX, ym)
                  else if TPersonTree(Childs[k]).FC.XC < FC.XC then
                    PaintMoveTo(FA.XC + DecalX, ym)
                  else
                    PaintMoveTo(FC.XC + DecalX, ya);
                  end
                else
                  PaintLineTo(FC.XC + DecalX, ym);

                if TPersonTree(Childs[k]).FC.XC <> FC.XC then
                  PaintLineTo(TPersonTree(Childs[k]).FC.XC + DecalX, ym);
                PaintLineTo(TPersonTree(Childs[k]).FC.XC + DecalX,
                  TPersonTree(Childs[k]).FB.YC + DecalY);
                end;
              end;
            end;

          if (ttMarriage in FShowTexts) then
            begin
            h := Canvas.TextHeight('A')+1;
            if (toDescent in FOptions) then
              begin
              if (Level and 1) = 1 then     // niveau impair seulement
                begin
                xa := FA.XC + DecalX;
                xb := FB.XC + DecalX;
                ya := FA.YC + DecalX;
                yb := FB.YC + DecalX;
                Canvas.Font.color := CouleurFontSexe;
                PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
                // Matthieu
                with Canvas.Font do
                 if (toAct in FOptions) and not ActeMariage
                  then Style := Style + [fsUnderline]
                  else Style := Style - [fsUnderline];
                PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
                if FTexts[ttMarriage] <> '' then
                  begin
                  s := 'x ' + FTexts[ttMarriage];
                  EcritDansRect(s, xa + 0.5, ya + h +1.5, xb - 0.5);
                  if (toCities in FOptions) and (FTexts[ttMarriageCity] <> '') then
                    EcritDansRect(FTexts[ttMarriageCity], xa + 0.5, ya + h *2 +1, xb - 0.5);
                  end
                else if (toCities in FOptions) and (FTexts[ttMarriageCity] <> '') then
                  begin
                  s := 'x ' + FTexts[ttMarriageCity];
                  EcritDansRect(s, xa + 0.5, ya + h + 1.5, xb - 0.5);
                  end
                else
                  EcritDansRect('x', xa + 0.5, ya + h + 1.5, xb - 0.5);
                end;
              end
            else
              begin
              if ((FTexts[ttMarriage] <> '') or (FTexts[ttMarriageCity] <> '')) and
                (OrderNum = 0) then
               begin
                xa := FA.XC + DecalX;
                xb := FB.XC + DecalX;
                if toCities in FOptions Then
                 Begin
                  ya := ym - h;
                  yb := ya + h * 2;
                 end
                Else
                  Begin
                   ya := ym - (h / 2);
                   yb := ya + h;
                  end;
                PaintSetPen(FColors[teLink], psSolid, 0.2, pmCopy);
                PaintSetBrush(clWhite, bsSolid);
                PaintRoundRect(xa, ya, xb, yb, h, h);
                PaintSetBrush(clBlack, bsClear);
                Canvas.Font.Color := FColors[teLink];
                PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
                if (toAct in FOptions) and not ActeMariage then
                  Canvas.Font.Style := Canvas.Font.Style + [fsUnderline]
                else
                  Canvas.Font.Style := Canvas.Font.Style - [fsUnderline];
                PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
                if FTexts[ttMarriage] <> '' then
                  begin
                  s := 'x ' + FTexts[ttMarriage];
                  EcritDansRect(s, xa+0.5, ya, xb-0.5);
                  if (toCities in FOptions) and (FTexts[ttMarriageCity] <> '') then
                    EcritDansRect(FTexts[ttMarriageCity], xa+0.5, ya + h, xb-0.5);
                  end
                else if (toCities in FOptions) and (FTexts[ttMarriageCity] <> '') then
                  begin
                  s := 'x ' + FTexts[ttMarriageCity];
                  EcritDansRect(s, xa+0.5, ya, xb-0.5);
                  end;
                end;
              end;
            end;

          //le texte
          Canvas.Font.Color := CouleurFontSexe;
          PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);

          //  ShowMessage('Prénom ' +FloatToStr(FPlots [ ttName ].YC)+'Nom ' +FloatToStr(FPlots [ ttLastName ].YC)+'FA ' +FloatToStr(FA.YC)+'FB ' +FloatToStr(FB.YC)+'decaly '+FloatToStr(DecalY));


          for TextElement := low(TGraphTreeText) to high(TGraphTreeText) do
            begin
            case TextElement of
              ttName, ttLastName, ttJob:
                if FTexts[TextElement] <> '' then
                  EcritDansRect(FTexts[TextElement], FA.XC +
                    DecalX + 1, FPlots[TextElement].YC + DecalY
                    , FB.XC + DecalX - 1);
              ttBirthDay:
                begin
                if (toAct in FOptions) and not
                  (ttBirthDay in FShowTexts) then
                  Canvas.Font.Style := Canvas.Font.Style + [fsUnderline]
                else
                  Canvas.Font.Style := Canvas.Font.Style - [fsUnderline];

                PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
                if FTexts[TextElement] <> '' then
                  begin
                  s := '°' + FTexts[TextElement];
                  EcritDansRect(FTexts[TextElement],
                    FA.XC + DecalX + 1, FPlots[TextElement].YC + DecalY
                    , FB.XC + DecalX - 1);
                  if (toCities in FOptions) and
                    (FTexts[ttBirthCity] <> '') then
                    begin
                    EcritDansRect(
                      FTexts[ttBirthCity], FA.XC + DecalX + 1, FPlots[ttBirthCity].YC + DecalY
                      , FB.XC + DecalX - 1);
                    end;
                  end
                else if (toCities in FOptions) and
                  (FTexts[ttBirthCity] <> '') then
                  begin
                  s := '°' + FTexts[ttBirthCity];
                  EcritDansRect(
                    FTexts[ttBirthCity], FA.XC + DecalX + 1, FPlots[ttBirthDay].YC + DecalY
                    , FB.XC + DecalX - 1);
                  end;
                end;
              ttDeathDay:
                begin
                if (toAct in FOptions) and not
                  (ttDeathDay in FShowTexts)
                 then Canvas.Font.Style := Canvas.Font.Style + [fsUnderline]
                 else Canvas.Font.Style := Canvas.Font.Style - [fsUnderline];
                PaintFont(Canvas.Font, GRAPH_BOXES_PRINT_FONT_SIZE);
                if FTexts[TextElement] <> '' then
                  begin
                  s := '†' + FTexts[TextElement];
                  EcritDansRect(FTexts[TextElement],
                    FA.XC + DecalX + 1, FPlots[TextElement].YC + DecalY, FB.XC + DecalX - 1);
                  if (toCities in FOptions) and
                    (FTexts[ttDeathCity] <> '') then
                    begin
                    EcritDansRect(
                      FTexts[ttDeathCity], FA.XC + DecalX + 1, FPlots[ttDeathCity].YC + DecalY
                      , FB.XC + DecalX - 1);
                    end;
                  end
                else if (toCities in FOptions) and
                  (FTexts[ttDeathCity] <> '') then
                  begin
                  s := '†' + FTexts[ttDeathCity];
                  EcritDansRect(
                    FTexts[ttDeathCity], FA.XC + DecalX + 1, FPlots[ttDeathDay].YC + DecalY
                    , FB.XC + DecalX - 1);
                  end;
                end;
              ttSOSA:
                begin
                s := FTexts[ttSOSA];
                lrect.Left := FB.XC + DecalX - 0.254 - Canvas.TextWidth(s);
                lrect.Top := FB.YC + DecalY - h;
                lrect.Right := FB.XC + DecalX - 0.254;
                lrect.Bottom := FB.YC + DecalY;
                //with lRect do
                //   PaintRect(Left,Top,Right,Bottom);
                PaintSetBrush(clWhite, bsSolid);
                PaintTextRect(lRect, lrect.Left, lrect.Top, s);
                end;
              end;
            end;
          end;
        end;
    finally
    end;
end;


function TGraphTree.GetCleIndividuAtXY(const X, Y: integer; var sNom, sNaisDec: string;
  var iSexe, iGene, iParent: integer): integer;

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
        Result := Result + #13#10 + '†' + sd
      else
        Result := '†' + sd;
      if (length(sd) > 0) and (length(ld) > 0) then
        Result := Result + '-' + ld
      else
        Result := Result + ld;
      end;
  end;

var
  n, i, decal: integer;
  indi, indiImplex: TPersonTree;
begin
  if not assigned(Viewer) then
    Exit;
  Result := -1;
  sNom := '';
  sNaisDec := '';
  with Data do
    for n := 0 to Persons.Count - 1 do
      begin
      indi := TPersonTree(Persons[n]);
      with indi do
        begin
        if (X >= FA.XV + Viewer.ShiftX) and
          (X <= FB.XV + Viewer.ShiftX) and (Y >= FA.YV + Viewer.ShiftY) and
          (Y <= FB.YV + Viewer.ShiftY) then //curseur sur une boîte
          begin
          Result := KeyPerson;
          sNom := AssembleString([FTexts[ttName], FTexts[ttLastName]]);
          sNaisDec := GetStringNaissanceDeces(FTexts[ttBirthDay],
            FTexts[ttBirthCity], FTexts[ttDeathDay], FTexts[ttDeathCity]);
          iSexe := Sexe;
          iGene := Level;
          if (toDescent in FOptions) and (ttBirthDay in FShowTexts) then
            iGene := iGene div 2;
          iGene := iGene + 1;
          if Parent <> nil then
            iParent := Parent.KeyPerson
          else
            iParent := -1;

          if Implexe <> '' then //remplace l'indi de d?part par le sosa
            begin
            for i := 0 to Persons.Count - 1 do
              begin
              if TPersonTree(Persons[i]).FTexts[ttSOSA] = Implexe then
                begin
                indi := TPersonTree(Persons[i]);
                break;
                end;
              end;
            end;
          //fixation du style du trait
          with Canvas do
            begin
            if Sexe = 1 then
              begin
              Pen.Color := clBlue;
              decal := -2;
              end
            else
              begin
              Pen.Color := clRed;
              decal := 2;
              end;
            Pen.Style := psSolid;
            Pen.Width := 2;
            end;
          for i := 0 to Persons.Count - 1 do //recherche implexes et trac? des traits
            begin
            if TPersonTree(Persons[i]).Implexe = FTexts[ttSOSA] then
              begin
              indiImplex := TPersonTree(Persons[i]);
              with Canvas do
                begin
                MoveTo((FA.XV + FB.XV) div 2 + Viewer.ShiftX
                  , (FA.YV + FB.YV) div 2 + Viewer.ShiftY + decal);
                LineTo((indiImplex.FA.XV + indiImplex.FB.XV) div 2 + Viewer.ShiftX
                  , (indiImplex.FA.YV + indiImplex.FB.YV) div 2 + Viewer.ShiftY + decal);
                end;
              end;
            end;
          break;
          end;
        end;
      end;
end;

function TGraphTree.IndiDansListe: integer;
var
  i: integer;
begin
  Result := -1;
  with Data do
    for i := 0 to Persons.Count - 1 do
      begin
      if TPersonTree(Persons[i]).KeyPerson = KeyFirst then
        begin
        Result := i;
        Break;
        end;
      end;
end;

function TGraphTree.PositionIndi(Indi: integer): TPoint;
var
  individu: TPersonTree;
begin
  individu := TPersonTree(Data.Persons[Indi]);
  Result.X := (individu.FA.XV + individu.FB.XV) div 2 + Viewer.ShiftX;
  Result.Y := (individu.FA.YV + individu.FB.YV) div 2 + Viewer.ShiftY;
end;

end.