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

unit u_ancestroviewer;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
{$ELSE}
{$ENDIF}
u_objet_TIntegerList, u_objet_TSingleList,
  classes,
  controls,
  extctrls,
  contnrs,
  LCLType,
  dialogs,
  forms,
  RLMetaFile,
  IniFiles,
  u_common_graph_type,
  u_common_graph_const,
  fonctions_scaledpi,
  u_objet_TState,
  Graphics;

var Graph_RecouvrementImpression : Integer = 0;

       // dimensions
const GRAPH_DEFAULT_PAGE_WIDTH    = 800;
      GRAPH_DEFAULT_PAGE_HEIGHT   = 600;
      GRAPH_DEFAULT_PAGE_ZOOM     = 100;
      GRAPH_DEFAULT_PAGE_ZOOM_INC = 10;
      GRAPH_DEFAULT_LINE_HEIGHT   = 3;
      GRAPH_DEFAULT_PAGE_SHIFTX   = 0;
      GRAPH_DEFAULT_PAGE_SHIFTY   = 0;
      GRAPH_DEFAULT_MARGE_LEFT    = 15;
      GRAPH_DEFAULT_MARGE_TOP     = 10;

      // data
      GRAPH_DEFAULT_GENERATIONS  = 6;

      // moving
      GRAPH_DEFAULT_MOVE_MINI     = False ;

      // colors
      GRAPH_DEFAULT_COLOR_VIEW    = $00696969;
      GRAPH_DEFAULT_COLOR_VIEW_MIN= $000085FC;

      GRAPH_INI_GENERATIONS = 'Generations';
      GRAPH_INI_MARGELEFT = 'MargeLeft';
      GRAPH_INI_MARGETOP = 'MargeTop';
      GRAPH_INI_COLORVIEW = 'ColorView';
      GRAPH_INI_LINE_HEIGHT = 'LineHeight';
      GRAPH_INI_COLORVIEWMINI = 'ColorViewMini';
      GRAPH_INI_FONT        = 'GraphFont';

type
   IFormIniPaint = interface
     ['{18E99D92-A2C5-4F67-A39B-62E54D0CE893}']
     procedure EnableBtnRefresh;
   End;

   TGraphViewer=class;
   TGraphComponent=class;
    { TGraphComponent }

  { TGraphData }

  TGraphData = class ( TComponent )
   private
    fAll: TObjectList;
    fCleIndiDepart: integer;
    FGenerations: integer;
    FGraph : TGraphComponent;
    procedure SetGraph(const AValue:TGraphComponent);
   public
    constructor Create ( AOwner : TComponent ); override;
    destructor Destroy; override;
    procedure Prepare ( const ACanvas : TCanvas ); virtual; abstract;
    procedure PreparePrint ; virtual; abstract;
    property Persons : TObjectList read fAll;
    procedure Order; virtual; abstract;

    property KeyFirst: integer read fCleIndiDepart write fCleIndiDepart;
    property Graph:TGraphComponent read FGraph;
   published
     property Generations : Integer read FGenerations write FGenerations default GRAPH_DEFAULT_GENERATIONS;
   End;

 TGraphComponent = class ( TPaintBox, INoAdaptComponent )
  private
   FReCalculate:boolean;
   fCanDraw:TState;
   FFullRect:TFLoatRect;
   fStartPos:TPoint;
   fActualPos:TPoint;
   fInitialDecal:TPoint;
   FGraphData : TGraphData;
   FLevelMax : Integer;
   FMargeLeft, FMargeTop : single;
   FColorView,FColorViewMini : TColor;
   FViewer : TGraphViewer;
   FSaveIni, FLoadIni : Boolean;
   FInifile : TIniFile;
   FLineHeight: Byte;
   FShowPrintRects:Boolean;
   FDrawHeight,FDrawWidth:LongWord;

   procedure SetLoadFromIni(const AValue: Boolean);
   procedure SetSaveToIni(const AValue: Boolean);
  protected
    fLevelTemp: integer;
    procedure GraphMoved;virtual;
    procedure GetFullRect(var R: TFloatRect); virtual;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure MouseDown(Button:TMouseButton; Shift:TShiftState;X,Y:Integer); override;
    procedure MouseMove(Shift:TShiftState;X,Y:Integer); override;
    procedure MouseUp(Button:TMouseButton;Shift:TShiftState;X,Y:Integer); override;
    procedure Paint; override;
    procedure PaintMiniature; virtual;
    procedure InitGraph(const Coef : Single ); virtual; abstract;
    procedure InitGraphMiniature(const coef: single ); virtual; abstract;
    procedure PaintGraph( const DecalX, DecalY: integer   ); virtual; overload;
    procedure PaintGraphMiniature(const DecalX, DecalY: integer); virtual; abstract;
    function  GetSectionIni : String;
    function  GetKeyWordIni ( const AKeyWord : String ) : String;
    procedure ReadInteger  ( const AKeyWord : String );virtual;
    procedure WriteInteger ( const AKeyWord : String );virtual;
    procedure ReadString  ( const AKeyWord : String ; APropComponent : TComponent = nil );virtual; overload;
    function  ReadString  ( const AKeyWord, AValue : String ; APropComponent : TComponent = nil ):String;virtual; overload;
    procedure WriteString ( const AKeyWord : String ; APropComponent : TComponent = nil );virtual; overload;
    procedure WriteString(const AKeyWord, AValue: String; APropComponent: TComponent=nil); virtual; overload;
    procedure ReadSet  ( const AKeyWord : String );virtual;
    procedure WriteSet ( const AKeyWord : String );virtual;
    procedure ReadBool  ( const AKeyWord : String );virtual;
    procedure WriteBool ( const AKeyWord : String );virtual;
    procedure ReadIni ; virtual;
    procedure WriteIni ; virtual;
  public
    procedure PaintGraph( const ACanvas : TCanvas ; const DecalX, DecalY: integer ); virtual; abstract;overload;
    constructor create ( AOwner : TComponent ); override;
    destructor Destroy; override;
    procedure ReadSectionIni; virtual;
    procedure WriteSectionIni; virtual;
    procedure Loaded ; override;
    procedure AutoLoadIni; virtual;

    procedure Print     ( const DecalX, DecalY : Extended ); virtual; abstract;
    procedure GetRectEncadrement(var R: TFloatRect); virtual; abstract;

    function GetCleIndividuAtXY(const X,Y:integer;var sNom,sNaisDec:string;var iSexe,iGene,iParent:integer):integer; virtual; abstract;
    function IndiDansListe:integer; virtual; abstract;
    function PositionIndi(Indi:Integer):TPoint; virtual; abstract;
    property MaxLevel : Integer read FLevelMax write FLevelMax ;
    property CanDraw:TState read fCanDraw;
    property Viewer : TGraphViewer read FViewer;
    property Data: TGraphData read FGraphData;
    property Inifile : TIniFile read FInifile write FInifile;
    property FullRect : TFloatRect read FFullRect;
    property ReCalculate     : Boolean read FReCalculate     write FReCalculate;
    property DrawWidth  : LongWord read FDrawWidth write FDrawWidth default 0;
    property DrawHeight : LongWord read FDrawHeight write FDrawHeight default 0;
  published
   property ShowPrintRects: Boolean read FShowPrintRects write FShowPrintRects default True;
    property MargeLeft: single read FMargeLeft write FMargeLeft default GRAPH_DEFAULT_MARGE_LEFT;
    property MargeTop: single read FMargeTop write FMargeTop default GRAPH_DEFAULT_MARGE_TOP;
    property LineHeight: Byte read FLineHeight write FLineHeight default GRAPH_DEFAULT_LINE_HEIGHT;
    property ColorView: TColor read FColorView
      write FColorView default GRAPH_DEFAULT_COLOR_VIEW;
    property ColorViewMini: TColor read FColorViewMini
      write FColorViewMini default GRAPH_DEFAULT_COLOR_VIEW_MIN;
    property IniSave     : Boolean read FSaveIni     write SetSaveToIni default False;
    property IniLoad     : Boolean read FLoadIni     write SetLoadFromIni default False;
    property Color default clWhite;
  end;

  { TGraphViewer }

  TGraphViewer=class ( TComponent )

  private
    FCoeffEcran:Single;
    FGraphData: TGraphData;
    fGraphMiniature ,
    fGraph          :TGraphComponent;
    fZoom:integer;
    fDecalY:integer;
    fDecalX:integer;
    fOnZoomChanged:TNotifyEvent;
    //Miniature
    fZoomMiniature:single;
    fDecalMiniatureX:integer;
    fDecalMiniatureY:integer;
    fPanelGraph:TCustomPanel;
    fIncrementZoom:integer;
    fFont:TFont;
    FPageHeight ,
    FPageWidth  :single;

    //les lignes du papier
    fTPXC,fTPYC:TSingleList;
    fTPXV,fTPYV:TIntegerList;
    FPrintCanvas : TRLGraphicSurface;

    FActivePersonKey : Integer;

    procedure SetZoom(const Value:integer);
    procedure SetGraph(const AValue:TGraphComponent);
    procedure SetGraphMiniature(const Value:TGraphComponent);
    procedure SetGraphData ( const GraphData : TGraphData );
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure CallZoomChanged; virtual;
  public

    procedure ZoomMoreAtPoint(const x,y:integer);
    procedure ZoomLessAtPoint(const x,y:integer);

    constructor Create ( AOwner : TComponent ); override;
    destructor Destroy; override;
    procedure Init; overload; virtual;

    //avant de changer un group de Propriétés
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;

    //méthodes de zoom (sinon, Zoom:=.., simplement)
    procedure ZoomAll; virtual;
    procedure ApplyZoomAtPoint(aZoom :integer; const x,y:integer);overload;  virtual;
    procedure ApplyZoomAtPoint(aZoom :integer; const xv,yv:integer;const xc,yc:single);overload;  virtual;

    //Lance le calcul de la position des pieux dans le viewer, selon Zoom (avant d?callage)
    procedure PrepareGraph ( const AZoom : Word = 0 ); virtual;
    procedure Center; virtual;

    procedure CoordChantier_To_CoordViewer(const xc,yc:single;var xv,yv:integer); virtual;
    procedure CoordViewer_To_CoordChantier(const xv,yv:integer;var xc,yc:single); virtual;

    //zones d'impression
    procedure BuildZonesImpression; virtual;
    procedure Refresh; virtual;
    procedure RefreshMiniature; virtual;
    procedure RefreshGraph; virtual;

    //Pour la miniature
    procedure BuildMiniature; virtual;
    procedure CoordChantier_To_CoordViewerMiniature(const xc,yc:single;var xv,yv:integer); virtual;
    procedure CoordViewerMiniature_To_CoordChantier(const xv,yv:integer;var xc,yc:single); virtual;
    property ZoomMiniature:single read fZoomMiniature;
    property ViewXC:TSingleList read fTPXC write fTPXC;
    property ViewYC:TSingleList read fTPYC write fTPYC;
    property ViewXV:TIntegerList read fTPXV write fTPXV;
    property ViewYV:TIntegerList read fTPYV write fTPYV;
    property ActivePersonKey : Integer read FActivePersonKey write FActivePersonKey default -1;
    //les ligne en pointill?s
    property PrintCanvas : TRLGraphicSurface read FPrintCanvas write FPrintCanvas;
    property ScreenRatio : Single read FCoeffEcran;
   published
    //Le chantier
//    property Chantier:TGraphComponent read fChantier write SetChantier;

    //Diverses propriétés du viewer
    property Zoom:integer read fZoom write SetZoom default GRAPH_DEFAULT_PAGE_ZOOM;
    property IncrementZoom:integer read fIncrementZoom write fIncrementZoom default GRAPH_DEFAULT_PAGE_ZOOM_INC;
    property Font:TFont read fFont write fFont;

    property ShiftX:integer read fDecalX write fDecalX default GRAPH_DEFAULT_PAGE_SHIFTX;
    property ShiftY:integer read fDecalY write fDecalY default GRAPH_DEFAULT_PAGE_SHIFTY;

    property DecalMiniatureX:integer read fDecalMiniatureX;

    property OnZoomChanged:TNotifyEvent read fOnZoomChanged write fOnZoomChanged;

    //Propriétés du papier : zone imprimable en mm
    property PageWidth:single read FPageWidth write FPageWidth default GRAPH_DEFAULT_PAGE_WIDTH;
    property PageHeight:single read FPageHeight write FPageHeight default GRAPH_DEFAULT_PAGE_HEIGHT;
    //les composants d'affichage
    property Graph:TGraphComponent read fGraph write SetGraph;
    property PanelGraph:TCustomPanel read fPanelGraph write fPanelGraph;
    property Data: TGraphData read FGraphData write SetGraphData;
    //gestion du plan miniature
    property GraphMiniature:TGraphComponent read fGraphMiniature write SetGraphMiniature;
  end;

implementation

uses
  SysUtils, fonctions_init, typinfo, fonctions_proprietes,fonctions_images;

{ TGraphComponent }


procedure TGraphComponent.GetFullRect(var R: TFloatRect);
begin
  if FReCalculate then
   Begin
     R:=FFullRect;
     exit;
   end;
  GetRectEncadrement ( R );
  FFullRect:=R;
  FReCalculate:=True;
end;

function TGraphComponent.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint
  ): Boolean;
begin
  Result:=inherited DoMouseWheelDown(Shift, MousePos);
  if assigned ( FViewer )
   Then
     Begin
       with MousePos do
        FViewer.ZoomLessAtPoint(X,Y);
       Refresh;
       FViewer.RefreshMiniature;
     end;
end;

function TGraphComponent.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint
  ): Boolean;
begin
  Result:=inherited DoMouseWheelUp(Shift, MousePos);
  if assigned ( FViewer )
   Then
     Begin
      with MousePos do
        FViewer.ZoomMoreAtPoint(X,Y);
      Refresh;
      FViewer.RefreshMiniature;
    end;
end;

{ TGraphData }

procedure TGraphData.SetGraph(const AValue: TGraphComponent);
begin
  if fGraph <> AValue Then
   Begin
     fGraph := AValue;
     if ( fGraph <> nil )
      Then
       Begin
         fGraph.FGraphData := Self;
       end;
   end;
end;

constructor TGraphData.Create ( AOwner : TComponent );
begin
  inherited Create ( AOwner );
  FAll := TObjectList.Create(False);
  FGenerations:=GRAPH_DEFAULT_GENERATIONS;
  fCleIndiDepart := -1;
End;

destructor TGraphData.Destroy;
begin
  Fall.Free;
  inherited Destroy;
end;

{ TGraphViewer }

procedure TGraphViewer.BeginUpdate;
begin
  if Assigned(fGraph) Then
    fGraph.fCanDraw.Value:=false;
  if Assigned(fGraphMiniature) Then
    fGraphMiniature.fCanDraw.Value:=false;
end;

procedure TGraphViewer.EndUpdate;
begin
  if Assigned(fGraph) Then
    fGraph.fCanDraw.Value:=True;
  if Assigned(fGraphMiniature) Then
    fGraphMiniature.fCanDraw.Value:=True;
end;

constructor TGraphViewer.Create  ( AOwner : TComponent );
begin
  Inherited;
  FActivePersonKey := -1;
  Init;
  FPageWidth     := GRAPH_DEFAULT_PAGE_WIDTH;
  FPageHeight    := GRAPH_DEFAULT_PAGE_HEIGHT;
  fGraph:=nil;
  fPanelGraph:=nil;
  fGraphMiniature:=nil;
  fOnZoomChanged:=nil;
  fFont:=TFont.Create;
  fTPXC:=TSingleList.create;
  fTPYC:=TSingleList.create;
  fTPXV:=TIntegerList.create;
  fTPYV:=TIntegerList.create;
  FCoeffEcran:=Screen.PixelsPerInch/2540;

  //objects init
  FGraphData      :=nil;
  FGraph          :=nil;
  fGraphMiniature := nil;
end;


procedure TGraphViewer.Init;
begin
  fZoom:=GRAPH_DEFAULT_PAGE_ZOOM;
  fZoomMiniature:=GRAPH_DEFAULT_PAGE_ZOOM;
  fDecalY:=GRAPH_DEFAULT_PAGE_SHIFTY;
  fDecalX:=GRAPH_DEFAULT_PAGE_SHIFTX;

  fIncrementZoom:=GRAPH_DEFAULT_PAGE_ZOOM_INC;
  //en mm
  CallZoomChanged;
end;

destructor TGraphViewer.Destroy;
begin
  BeginUpdate;
  fGraph:=nil;
  fPanelGraph:=nil;
  GraphMiniature:=nil;
  fFont.Free;
  fTPXC.free;
  fTPYC.free;
  fTPXV.free;
  fTPYV.free;

  inherited;
end;


procedure TGraphViewer.SetZoom(const Value:integer);
begin
  //la valeur du nouveau Zoom est-elle correcte ?
  if (Value>=_ZOOM_MIN)and(Value<=_ZOOM_MAX) then
  begin
    if fGraph<>nil then
    with FGraph do
     begin
      ApplyZoomAtPoint(Value,Width div 2,Height div 2);
      GraphMoved;
     end;
  end;
end;

procedure TGraphViewer.ZoomAll;
var
  R:TFloatRect;
  wc,hc:single;
  fZoomW,fZoomH:single;
begin
  if (fGraph<>nil) then
  begin
      BeginUpdate;
      try
        //On encadre les coordonn?es chantiers des pieux
        fGraph.GetFullRect(R);

        //On ajoute une bordure au rectangle de délimitation, pour ne pas avoir des pieux collés sur les côtés
        wc:=R.Right-R.Left;//en m
        hc:=R.Bottom-R.Top;//en m

        if (wc>0)and(hc>0) then
        begin
          fZoomW:=fGraph.Width/wc/FCoeffEcran;
          fZoomH:=fGraph.Height/hc/FCoeffEcran;

          if fZoomW>fZoomH then
            fZoom:=trunc(fZoomH-1)
          else
            fZoom:=trunc(fZoomW-1);

          if fZoom<_ZOOM_MIN then
            fZoom:=_ZOOM_MIN;
          if fZoom>_ZOOM_MAX then
            fZoom:=_ZOOM_MAX;

          CallZoomChanged;

          PrepareGraph;

           //On centre tout ?a
          Center;
        end;
      finally
        EndUpdate;
      end;

      RefreshGraph;
      RefreshMiniature;
  end;
end;

procedure TGraphViewer.PrepareGraph ( const AZoom : Word = 0 );
var
  e:single;
  n:integer;
begin
  if AZoom > 0
   Then e:=AZoom*FCoeffEcran
   Else e:=fZoom*FCoeffEcran;
  FGraph.InitGraph(e);

  for n:=0 to fTPXC.count-1 do
  begin
    fTPXV[n]:=trunc(fTPXC[n]*e);
  end;
  for n:=0 to fTPYC.count-1 do
  begin
    fTPYV[n]:=trunc(fTPYC[n]*e);
  end;
end;

//but : avant d'appliquer le zoom, on cherche les coord du chantier qui correspondent ? (x;y)=coord sur le viewer
//on zoom, puis, on replace les coord chantier exactement sur (x,y) du viewer
//C'est pour zoomer, avec centre du zoom l? o? on clique

procedure TGraphViewer.ApplyZoomAtPoint(aZoom :integer; const x,y:integer);
var
  NewX,NewY:integer;
  XChant,YChant:single;
begin
  BeginUpdate;
  try
    //Quelles sont les coord du point sur lequel on a cliqu?, dans le chantier ?
    CoordViewer_To_CoordChantier(x,y,XChant,YChant);

    //on vérifie que le Zoom est correct
    if aZoom<_ZOOM_MIN then aZoom:=_ZOOM_MIN;
    if aZoom>_ZOOM_MAX then aZoom:=_ZOOM_MAX;

    fZoom:=aZoom;

    CallZoomChanged;

    //On recalcule tout, avec le nouveau Zoom
    PrepareGraph;

    CoordChantier_To_CoordViewer(XChant,YChant,NewX,NewY);

    fDecalX:=(x-NewX);
    fDecalY:=(y-NewY);
  finally
    EndUpdate;
  end;

  RefreshGraph;
  RefreshMiniature;
end;

//but : on applique le zoom,
//puis on fait correspondre (xc,yc) coord chantier, sur le pixel (xv,yv) du viewer

procedure TGraphViewer.ApplyZoomAtPoint(aZoom :integer; const xv,yv:integer;const xc,yc:single);
var
  NewX,NewY:integer;
begin
  BeginUpdate;
  try
    //on v?rifie que le Zoom est correct
    if aZoom<_ZOOM_MIN then aZoom:=_ZOOM_MIN;
    if aZoom>_ZOOM_MAX then aZoom:=_ZOOM_MAX;

    fZoom:=aZoom;

    CallZoomChanged;

    //On recalcule tout, avec le nouveau Zoom
    PrepareGraph;

    CoordChantier_To_CoordViewer(xc,yc,NewX,NewY);

    fDecalX:=(xv-NewX);
    fDecalY:=(yv-NewY);
  finally
    EndUpdate;
  end;

  RefreshGraph;
  RefreshMiniature;
end;

procedure TGraphViewer.ZoomLessAtPoint(const x,y:integer);
var
  value:integer;

  function DecreasePourcent(var P:integer):boolean;
  var
    a:integer;
  begin
    result:=false;

    //On r?duit de xx en xx, avec un min de yy
    a:=((P div fIncrementZoom))*fIncrementZoom;
    if a=P then
      a:=P-fIncrementZoom;
    if a<_ZOOM_MIN then
      a:=_ZOOM_MIN;

    if a<>p then
    begin
      p:=a;
      result:=true;
    end;
  end;

begin
  Value:=fZoom;
  if DecreasePourcent(Value) then
    ApplyZoomAtPoint(Value,x,y);
end;

procedure TGraphViewer.SetGraph(const AValue: TGraphComponent);
begin
  BeginUpdate;
  try
    if fGraph <> AValue Then
     Begin
       fGraph := AValue;
       if ( fGraph <> nil )
        Then
         Begin
           fGraph.FViewer:=Self;
           fGraph.FGraphData := FGraphData;
           if ( FGraphData <> nil )
            Then
             FGraphData.FGraph := FGraph;
         end;
     end;

  finally
    EndUpdate;
  end;
end;

procedure TGraphViewer.SetGraphMiniature(const Value:TGraphComponent);
begin
  BeginUpdate;
  try
    //décrochage
  if fGraphMiniature <> Value Then
   Begin
     fGraphMiniature:=Value;
     if ( fGraphMiniature <> nil )
      Then
       Begin
         fGraphMiniature.FViewer:=Self;
         fGraphMiniature.FGraphData := FGraphData;
       end;
   end;
    //branchement des événements
  finally
    EndUpdate;
  end;
end;

procedure TGraphViewer.SetGraphData(const GraphData: TGraphData);
begin
  if FGraphData <> GraphData Then
   begin
     FGraphData:=GraphData;
     if assigned ( FGraphData ) Then
       FGraphData.FGraph :=fGraph;
     if assigned ( fGraph ) Then
       Fgraph.FGraphData := FGraphData;
     if assigned ( fGraphMiniature ) Then
       fGraphMiniature.FGraphData := FGraphData;
   end;
end;


procedure TGraphViewer.ZoomMoreAtPoint(const x,y:integer);
var
  value:integer;

  function IncreasePourcent(var P:integer):boolean;
  var
    a:integer;
  begin
    result:=false;

    //On avance de xx en xx, avec un max de yy
    a:=((P div fIncrementZoom)+1)*fIncrementZoom;
    if a>_ZOOM_MAX then
      a:=_ZOOM_MAX;

    if a<>p then
    begin
      p:=a;
      result:=true;
    end;
  end;

begin
  Value:=fZoom;
  if IncreasePourcent(Value) then
    ApplyZoomAtPoint(Value,x,y);
end;

procedure TGraphViewer.CoordViewer_To_CoordChantier(const xv,yv:integer;var xc,yc:single);
var
  e:single;
begin
//  e:=(fZoom*72)/(100*25.4);
  e:=fZoom*FCoeffEcran;
  xc:=(xv-fDecalX)/e;
  yc:=(yv-fDecalY)/e;
end;

procedure TGraphViewer.CoordChantier_To_CoordViewer(const xc,yc:single;var xv,yv:integer);
var
  e:single;
begin
//  e:=(fZoom*72)/(100*25.4);
  e:=fZoom*FCoeffEcran;
  xv:=trunc(xc*e);
  yv:=trunc(yc*e);
end;

procedure TGraphViewer.Center;
var
  R:TFloatRect;
  pcx,pcy:single;
  x,y:integer;
begin
  //On calcul FDecalX et FDecalY, de façon à centrer le forage dans le viewer
  if (fGraph<>nil) then
  begin
    if (fGraph.Width>0)and(fGraph.Height>0) then
    begin
      fGraph.GetFullRect(R);

      //coordonn?es du centre du chantier
      pcx:=(R.Right+R.Left)/2;
      pcy:=(R.Bottom+R.Top)/2;

      //transformation des coord. pour le viewer
      //FGraph.InitGraph(fZoom*FCoeffEcran);
      CoordChantier_To_CoordViewer(pcx,pcy,x,y);

      //Calcul des d?calages
      fDecalX:=(fGraph.Width div 2)-x;
      fDecalY:=(fGraph.Height div 2)-y;
    end;
  end;
end;

procedure TGraphViewer.CallZoomChanged;
begin
  if assigned(fOnZoomChanged) then fOnZoomChanged(self);
end;

procedure TGraphViewer.BuildMiniature;
var
  e:single;
  R:TFloatRect;
  wc,hc:single;
  pcx,pcy:single;
  x,y:integer;
  fZoomW,fZoomH:single;
begin
  if (fGraphMiniature<>nil) then
  begin
    if (fGraphMiniature.Width>0)and(fGraphMiniature.Height>0) then
    begin
      BeginUpdate;
      try
        //On encadre les coordonn?es chantiers des pieux
        fGraph.GetFullRect(R);

        //On ajoute une bordure au rectangle de d?limitation, pour ne pas avoir des pieux coll?s sur les c?t?s
        wc:=R.Right-R.Left;//en m
        hc:=R.Bottom-R.Top;//en m

        if (wc>0)and(hc>0) then
        begin
          fZoomW:=fGraphMiniature.Width/wc/FCoeffEcran;
          fZoomH:=fGraphMiniature.Height/hc/FCoeffEcran;

          if fZoomW>fZoomH then
            fZoomMiniature:=fZoomH-0.1
          else
            fZoomMiniature:=fZoomW-0.1;

          if fZoomMiniature<=0 then
            fZoomMiniature:=0.001;

          //On centre tout ?a dans la miniature
          pcx:=(R.Right+R.Left)/2;
          pcy:=(R.Bottom+R.Top)/2;

          //transformation des coord. pour le viewer de la miniature
          CoordChantier_To_CoordViewerMiniature(pcx,pcy,x,y);

          //Calcul des d?calages
          fDecalMiniatureX:=(fGraphMiniature.Width div 2)-x;
          fDecalMiniatureY:=(fGraphMiniature.Height div 2)-y;
        end;
      finally
        EndUpdate;
      end;

      //Calcul des coord de tous les pieux, dans le Viewer miniature
      e:=fZoomMiniature*FCoeffEcran;
      FGraph.InitGraph(e);
      RefreshMiniature;
    end;
  end;
end;

procedure TGraphViewer.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) Then Exit;
  if (Graph <> nil) and (AComponent = Graph) then Graph := nil;
  if (Data  <> nil) and (AComponent = Data ) then Data := nil;
  if (GraphMiniature <> nil) and (AComponent = GraphMiniature) then GraphMiniature := nil;
  if (PanelGraph     <> nil) and (AComponent = PanelGraph    ) then PanelGraph := nil;
end;

procedure TGraphViewer.RefreshMiniature;
begin
  if fGraphMiniature<>nil then
    fGraphMiniature.PaintMiniature;
end;

procedure TGraphViewer.RefreshGraph;
begin
  if assigned ( fGraph )
   Then
    with fGraph do
     Begin
       Refresh;
       GraphMoved;
     end;
end;

procedure TGraphViewer.CoordChantier_To_CoordViewerMiniature(const xc,yc:single;var xv,yv:integer);
var
  e:single;
begin
//  e:=(fZoomMiniature*72)/(100*25.4);
  e:=fZoomMiniature*FCoeffEcran;
  xv:=trunc(xc*e);
  yv:=trunc(yc*e);
end;

procedure TGraphViewer.CoordViewerMiniature_To_CoordChantier(const xv,yv:integer;var xc,yc:single);
var
  e:single;
begin
//  e:=(fZoomMiniature*72)/(100*25.4);
  e:=fZoomMiniature*FCoeffEcran;
  xc:=(xv-fDecalMiniatureX)/e;
  yc:=(yv-fDecalMiniatureY)/e;
end;

procedure TGraphViewer.BuildZonesImpression;
var
  w,h:extended;
  n,k:integer;
  R:TFloatRect;
begin
  fTPXC.Clear;
  fTPYC.Clear;
  fTPXV.Clear;
  fTPYV.Clear;

  fGraph.GetFullRect(R);
  //il y en a au moins une.
  w:=R.Right-R.Left;
  k:=trunc(w/FPageWidth)+1;

  w:=R.Left;
  for n:=1 to k do
  begin
    fTPXC.Add(w);
    fTPXV.Add(0);
    w:=w+FPageWidth;
  end;
  fTPXC.Add(w);
  fTPXV.Add(0);

  h:=R.Bottom-R.Top;
  k:=trunc(h/FPageHeight)+1;

  h:=r.Top;
  for n:=1 to k do
  begin
    fTPYC.Add(h);
    fTPYV.Add(0);
    h:=h+FPageHeight;
  end;
  fTPYC.Add(h);
  fTPYV.Add(0);
end;

procedure TGraphViewer.Refresh;
begin
  if not Assigned(fGraph)
  or not Assigned(FGraphData) Then
    Exit;
  fGraph.FReCalculate:=False;
  BeginUpdate;
  FGraphData.Order;
  FGraphData.Prepare ( fGraph.Canvas );
  BuildZonesImpression;
  BuildMiniature;
  PrepareGraph;
  EndUpdate;
  RefreshGraph;
  RefreshMiniature;
end;
{ TGraphComponent }

procedure TGraphComponent.MouseDown(Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
  procedure Deplace;
  begin
    fStartPos.x:=x;
    fStartPos.y:=y;
    fActualPos.x:=x;
    fActualPos.y:=y;
    fInitialDecal.x:=FViewer.ShiftX;
    fInitialDecal.y:=FViewer.ShiftY;
    FViewer.RefreshMiniature;
  end;
var n : Byte;
begin
  Inherited;
  if not assigned (FViewer) Then Exit;
  with FViewer do
    if Self = fGraphMiniature Then
    Begin
     Exit;
    end;
//  (fGraph.Owner as TFoGraphGraph).PanReglages.Visible:=false;
  if  (Owner as TCustomForm).ActiveControl<>Parent then
      (Owner as TCustomForm).ActiveControl:=Parent;
      //ne pas mettre setfocus car reprend le focus apr?s un dblclic
  if (fCanDraw.Value) then
  begin
        if ( ssQuad in Shift ) then
          for n := 1 to 20 do FViewer.ZoomMoreAtPoint(X,Y)
        else if ( ssLeft  in Shift ) then
          Deplace
        else if ( ssDouble in Shift )
        or  ( ssAltGr in Shift )
        or  ( ssAlt in Shift ) then
          Viewer.ZoomMoreAtPoint(X,Y)
        else if ( ssCtrl in Shift )
        or ( ssRight in Shift )then
          FViewer.ZoomLessAtPoint(X,Y)
        else Refresh;
{
      mmZoomMore:
      begin
        if ssLeft in Shift then
          FViewer.ZoomMoreAtPoint(X,Y);
      end;

      mmZoomLess:
      begin
        if ssLeft in Shift then
          FViewer.ZoomLessAtPoint(X,Y);
      end;
    end;}
  end;
end;

procedure TGraphComponent.MouseMove(Shift:TShiftState;X,Y:Integer);
var
  deltaX,deltaY:integer;
  deltaViewerX,deltaViewerY:integer;
  deltaChantierX,deltaChantierY:single;
begin

  Inherited;
  if not assigned (FViewer) Then Exit;

  if (FViewer.fGraphMiniature=Self) Then
    with fViewer do
      begin
        //les delta de déplacement dans la miniature
        deltaX:=(x-fStartPos.x);
        deltaY:=(y-fStartPos.y);

        deltaChantierX:=(deltaX*100)/fViewer.ZoomMiniature;
        deltaChantierY:=(deltaY*100)/fViewer.ZoomMiniature;
        deltaViewerX:=round(deltaChantierX*fViewer.Zoom/100);
        deltaViewerY:=round(deltaChantierY*fViewer.Zoom/100);

        //On applique le décalage, dans le grand viewer
        fViewer.ShiftX:=fInitialDecal.x-deltaViewerX;
        fViewer.ShiftY:=fInitialDecal.y-deltaViewerY;

        //rafraichissement
        fViewer.Refresh;
        fViewer.RefreshMiniature;
        Exit;
      end;

  if (ssLeft in Shift) then
   begin
      //on recalcul le d?calage

    FViewer.ShiftX:=(x-fStartPos.x)+fInitialDecal.x;
    FViewer.ShiftY:=(y-fStartPos.y)+fInitialDecal.y;
    Refresh;
    GraphMoved;
    FViewer.RefreshMiniature;
   end;
  if (ssRight in Shift) then
   begin
      //on recalcul le décalage
    if x-fStartPos.x > 0
     Then FViewer.Zoom:=FViewer.Zoom+10
     Else FViewer.Zoom:=FViewer.Zoom-10;
    Refresh;
    GraphMoved;
    FViewer.RefreshMiniature;
   end;
end;

procedure TGraphComponent.SetLoadFromIni(const AValue: Boolean);
begin
  if FLoadIni=AValue then Exit;
  FLoadIni:=AValue;
end;

procedure TGraphComponent.SetSaveToIni(const AValue: Boolean);
begin
  if FSaveIni=AValue then Exit;
  FSaveIni:=AValue;
end;

procedure TGraphComponent.GraphMoved;
begin

end;


procedure TGraphComponent.MouseUp(Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  Inherited;
  with FViewer do
  begin
    if not assigned (FViewer) Then Exit;

    Refresh;
    RefreshMiniature;
  end;
end;

procedure TGraphComponent.Paint;
begin
  Inherited;
  if not Assigned ( FGraphData )
  or not assigned ( FViewer    ) Then Exit;

  if ( FViewer.GraphMiniature = Self ) Then
    Begin
      PaintMiniature;
    end
  else if (fCanDraw.Value) then
    with FViewer do
      begin
        //on appelle la procédure de dessin du graph
        PaintGraph(fDecalX,fDecalY);
      end;
end;

procedure TGraphComponent.PaintMiniature;
var
  xc0,yc0:single;
  xc1,yc1:single;
  xvm0,yvm0:integer;
  xvm1,yvm1:integer;
begin
  if (fCanDraw.Value) then
  with FViewer do
  begin
    Canvas.Pen.Color:=$000085FC;
    Canvas.Pen.Width:=1;
      //le graph
    PaintGraphMiniature(fDecalMiniatureX,fDecalMiniatureY);

      //Cadre correspondant au grand viewer
    Canvas.Pen.Color:=clWhite;
    if fGraph<>nil then
    begin
      xc0  := 0 ;
      yc0  := 0 ;
      xvm0 := 0 ;
      yvm0 := 0 ;
          //ou est le (0;0) et le (Width,Height)
      CoordViewer_To_CoordChantier(0,0,xc0,yc0);
      CoordViewer_To_CoordChantier(fGraph.Width-1,fGraph.Height-1,xc1,yc1);

          //On transpose ces coord dans la miniature
      CoordChantier_To_CoordViewerMiniature(xc0,yc0,xvm0,yvm0);
      CoordChantier_To_CoordViewerMiniature(xc1,yc1,xvm1,yvm1);

          //On dessine le cadre
      Canvas.MoveTo(xvm0+fDecalMiniatureX,yvm0+fDecalMiniatureY);
      Canvas.LineTo(xvm1+fDecalMiniatureX,yvm0+fDecalMiniatureY);
      Canvas.LineTo(xvm1+fDecalMiniatureX,yvm1+fDecalMiniatureY);
      Canvas.LineTo(xvm0+fDecalMiniatureX,yvm1+fDecalMiniatureY);
      Canvas.LineTo(xvm0+fDecalMiniatureX,yvm0+fDecalMiniatureY);
    end;
  end;
end;

procedure TGraphComponent.PaintGraph(const DecalX, DecalY: integer);
var ABitmap : TBitmap;
    n : Integer ;
begin
  if ( Canvas.Width  < 1 )
  or ( Canvas.Height < 1 ) Then
   Exit;
  ABitmap := TBitmap.Create;
  with ABitmap.Canvas, Viewer do
  try
    p_SetAndFillBitmap ( ABitmap, Canvas.Width, Canvas.Height, Self.Color );
    Brush.Color:=Color;
    FillRect(0,0,Width,Height);
    if FShowPrintRects Then
     Begin
      //on dessine les traits des feuilles de papier
      if (fTPXV.Count>1)and(fTPYV.Count>1) then
      begin
        Pen.Color:=FColorView;
        Pen.Width:=1;
        Pen.Style:=psDot;

        for n:=0 to fTPXV.count-1 do
        begin
          MoveTo(fTPXV[n]+FDecalX,fTPYV[0]+FDecalY);
          LineTo(fTPXV[n]+FDecalX,fTPYV.Last+FDecalY);
        end;
        for n:=0 to fTPYV.count-1 do
        begin
          MoveTo(fTPXV[0]+FDecalX,fTPYV[n]+FDecalY);
          LineTo(fTPXV.last+FDecalX,fTPYV[n]+FDecalY);
        end;
      end;
     end;

    PaintGraph(ABitmap.Canvas,DecalX,DecalY);
    Canvas.Draw(0,0,ABitmap);
  finally
    ABitmap.Destroy;
  end;
end;

function TGraphComponent.GetSectionIni: String;
begin
  Result := Owner.Name;
end;

function TGraphComponent.GetKeyWordIni(const AKeyWord: String): String;
begin
  Result := Name+'.'+AKeyWord;
end;

procedure TGraphComponent.ReadInteger(const AKeyWord: String);
begin
  SetPropValue( Self, AKeyWord, FInifile.ReadInteger ( GetSectionIni, GetKeyWordIni ( AKeyWord ), GetPropValue ( Self, AKeyWord )));
end;

procedure TGraphComponent.WriteInteger(const AKeyWord: String);
begin
  FInifile.WriteInteger ( GetSectionIni, GetKeyWordIni ( AKeyWord ), GetPropValue ( Self, AKeyWord ));
end;

procedure TGraphComponent.ReadString(const AKeyWord: String; APropComponent : TComponent = nil );
begin
  if APropComponent = nil Then APropComponent := Self;
  SetPropValue( Self, AKeyWord, ReadString ( AKeyWord, GetPropValue ( APropComponent, AKeyWord ),APropComponent));
end;

function TGraphComponent.ReadString(const AKeyWord, AValue: String;
  APropComponent: TComponent):String;
begin
  if APropComponent = nil Then APropComponent := Self;
  Result := FInifile.ReadString ( GetSectionIni, APropComponent.Name + '.' + AKeyWord, AValue);
end;

procedure TGraphComponent.WriteString(const AKeyWord: String; APropComponent : TComponent = nil );
begin
  if APropComponent = nil Then APropComponent := Self;
  WriteString ( AKeyWord, GetPropValue ( APropComponent, AKeyWord ),APropComponent);
end;

procedure TGraphComponent.WriteString(const AKeyWord, AValue : String; APropComponent : TComponent = nil );
begin
  if APropComponent = nil Then APropComponent := Self;
  FInifile.WriteString ( GetSectionIni, APropComponent.Name + '.' + AKeyWord, AValue );
end;

procedure TGraphComponent.ReadSet(const AKeyWord: String);
begin
  SetSetProp( Self, AKeyWord, FInifile.ReadString ( GetSectionIni, GetKeyWordIni ( AKeyWord ), GetSetProp( Self, AKeyWord )));
end;

procedure TGraphComponent.WriteSet(const AKeyWord: String);
begin
  FInifile.WriteString ( GetSectionIni, GetKeyWordIni ( AKeyWord ), GetSetProp ( Self, AKeyWord ));
end;

procedure TGraphComponent.ReadBool(const AKeyWord: String);
begin
  SetPropValue( Self, AKeyWord, FInifile.ReadBool ( GetSectionIni, GetKeyWordIni ( AKeyWord ), GetPropValue ( Self, AKeyWord )));
end;

procedure TGraphComponent.WriteBool(const AKeyWord: String);
begin
  FInifile.WriteBool ( GetSectionIni, GetKeyWordIni ( AKeyWord ), GetPropValue ( Self, AKeyWord ));
end;

constructor TGraphComponent.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FReCalculate:=False;
  FShowPrintRects:=True;
  FSaveIni:=False;
  FLoadIni:=False;
//  fMouseMode:=mmMoveOrSelect;
  fCanDraw:=TState.Create(true);
  FMargeLeft    := GRAPH_DEFAULT_MARGE_LEFT ;
  FMargeTop     := GRAPH_DEFAULT_MARGE_TOP ;
  FColorView    := GRAPH_DEFAULT_COLOR_VIEW;
  FColorViewMini:= GRAPH_DEFAULT_COLOR_VIEW_MIN;
  FLineHeight:=GRAPH_DEFAULT_LINE_HEIGHT;

  // objects init
  FGraphData := nil;
  FViewer    := nil;
  FInifile   := nil;

  FDrawHeight:=0;
  FDrawWidth :=0;
  Color := clWhite;
end;

procedure TGraphComponent.Loaded;
begin
  ReadIni;
  inherited Loaded;
end;

procedure TGraphComponent.ReadIni;
begin
  if ( csDesigning in ComponentState )
  or not FLoadIni Then
   Exit;
  if FIniFile <> nil Then
    ReadSectionIni;
end;

procedure TGraphComponent.WriteIni;
begin
  if ( csDesigning in ComponentState )
  or not FSaveIni Then
   Exit;
  if FIniFile <> nil Then
    WriteSectionIni;
end;

procedure TGraphComponent.AutoLoadIni;
Begin
  FIniFile := f_GetMemIniFile;
End;

procedure TGraphComponent.ReadSectionIni;
begin
  AutoLoadIni;
  ReadInteger ( GRAPH_INI_MARGETOP  );
  ReadInteger ( GRAPH_INI_MARGELEFT );
  ReadInteger ( GRAPH_INI_COLORVIEW );
  ReadInteger ( GRAPH_INI_LINE_HEIGHT );
  ReadInteger ( GRAPH_INI_COLORVIEWMINI);
  StringToFont(ReadString(GRAPH_INI_FONT,FontToString(Font)),Font);
  if FGraphData <> nil Then
    FGraphData.Generations := FInifile.ReadInteger(GetSectionIni,GetKeyWordIni(GRAPH_INI_GENERATIONS),FGraphData.Generations);
end;

procedure TGraphComponent.WriteSectionIni;
begin
  AutoLoadIni;
  WriteString  ( GRAPH_INI_MARGETOP  );
  WriteInteger ( GRAPH_INI_MARGELEFT );
  WriteInteger ( GRAPH_INI_COLORVIEW );
  WriteInteger ( GRAPH_INI_LINE_HEIGHT );
  WriteInteger ( GRAPH_INI_COLORVIEWMINI);
  WriteString  ( GRAPH_INI_FONT, FontToString(Font));
  if FGraphData <> nil Then
    FInifile.WriteInteger(GetSectionIni,GetKeyWordIni(GRAPH_INI_GENERATIONS),FGraphData.Generations);
end;


destructor TGraphComponent.Destroy;
begin
  WriteIni;
  fCanDraw.Free;
  inherited;
end;
{procedure TGraphComponent.SetMouseMode(const AValue:TMouseMode);
begin
  fMouseMode:=AValue;
  case AValue of
    mmZoomMore:Cursor:=_CURSOR_ZOOM_PLUS;
    mmZoomLess:Cursor:=_CURSOR_ZOOM_MOINS;
    else
      Cursor:=_CURSOR_MAIN;
  end;
end;


 }
end.
