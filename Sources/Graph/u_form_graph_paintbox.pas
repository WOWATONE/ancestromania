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
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{    Refait par André Langlet 2009                                      }
{-----------------------------------------------------------------------}

unit u_form_graph_paintbox;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  u_objet_graph_Tviewer, u_comp_TFWPrint, u_objet_graph_TGraph, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  U_FormAdapt,u_comp_TYLanguage,Classes,Menus,Forms,
  Dialogs,ExtCtrls,StdCtrls,Controls,u_objet_TState,printers,SysUtils,
  u_framework_components,Graphics, PrintersDlgs,
  u_buttons_appli, U_OnFormInfoIni,ExtJvXPButtons,
  u_form_graph_config_hierarchie, u_ancestrolink,
  u_ancestroarc, u_ancestrotree, u_ancestroviewer,
  u_form_graph_config_roue,u_form_graph_config_liens,
  u_reports_components,
  u_common_graph_type, FPCanvas, types;

type
  TMyPopupMenu=class(TPopupMenu)
  public
    property PopupPoint;
  end;

  { TFGraphPaintBox }

  TFGraphPaintBox=class(TF_FormAdapt,IFormIniPaint)
    btnCfgGraph: TFWConfig;
    BtnGraphOnTopLeft: TFWInit;
    btnPrint: TFWPrint;
    btnPrintPicture: TFWPrintPicture;
    btnRefresh: TFWRefresh;
    btnSelectIndiGraph: TFWOK;
    cbInversion: TCheckBox;
    cb_papersize: TComboBox;
    ch_Portrait: TCheckBox;
    edNbGeneration: TFWSpinEdit;
    GraphArcMini: TGraphArc;
    GraphArcData: TGraphArcData;
    GraphLinkData: TGraphLinkData;
    GraphLinkMini: TGraphLink;
    GraphTreeMini: TGraphTree;
    GraphTreeData: TGraphTreeData;
    Arrow: TImage;
    lNaisDec: TLabel;
    lNbGenerations: TLabel;
    lNbGenerations1: TLabel;
    lNom: TLabel;
    LReglages: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel5: TPanel;
    rg_sortie: TRadioGroup;
    sbDesc: TCheckBox;
    sd_PDFRTF: TSaveDialog;
    Splitter1: TSplitter;
    Viewer: TGraphViewer;
    OnFormInfoIni: TOnFormInfoIni;
    PaintArc: TGraphArc;
    PaintLink: TGraphLink;
    PrinterSetupDialog:TPrinterSetupDialog;
    PanelPaintBox:TPanel;
    PaintTree:TGraphTree;
    popup:TPopupMenu;
    popup_VoirLaFicheInBox:TMenuItem;
    N1:TMenuItem;
    mImprimercettepage:TMenuItem;
    Language:TYLanguage;
    PanReglages:TPanel;
    btnSetMouseMoveOrSelect:TFWOK;
    btnSetMouseZoomMore:TFWZoomIn;
    btnSetZoomAll:TFWSearch;
    btnSetMouseZoomLess:TFWZoomOut;
    lZoom:TLabel;
    lbZoom:TLabel;
    TrackBar:TScrollBar;
    panDockMiniature:TPanel;
    Dmarrerlarbredepuiscetindividu:TMenuItem;
    Ouvrirlafichedecetindividu:TMenuItem;
    N2:TMenuItem;
    mNgene:TMenuItem;
    enfants1:TMenuItem;
    procedure btnPrintPictureClick(Sender: TObject);
    procedure cb_papersizeChange(Sender: TObject);
    procedure ch_PortraitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PaintArcMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintArcPrintArc(const AObject: TObject; const ARect: TFloatRect;
      const ABeginArcXC, ABeginArcYC, AEndArcXC, AEndArcYC: Extended);
    procedure PaintLinkPrintBrushSet(const AObject: TObject;
      const AColor: TColor; const PenStyle: TFPBrushStyle);
    procedure PaintLinkPrintColor(const AObject: TObject; const AColor: TColor);
    procedure PaintLinkPrintFont(const AObject: TObject;
      const AFont: TFont; const AFontSize: Single);
    procedure PaintLinkPrintLineTo(const AObject: TObject; const AX,
      AY: Extended);
    procedure PaintLinkPrintMoveTo(const AObject: TObject; const AX,
      AY: Extended);
    procedure PaintLinkPrintOutTextXY(const AObject: TObject;
      const AString: string; const ALeft, ATop: Double; const AAngle: Integer=0
      );
    procedure PaintLinkPrintPenSet(const AObject: TObject;
      const AColor: TColor; const PenStyle: TFPPenStyle;
      const PenWidth: Single; const PenMode: TFPPenMode);
    procedure PaintLinkPrintRect(const AObject: TObject; const AX1, AY1, AX2,
      AY2: Extended);
    procedure PaintLinkPrintRoundRect(const AObject: TObject; const AX1, AY1,
      AX2, AY2, W, H: Extended);
    procedure PaintLinkPrintSetRectXY(const AObject: TObject;
      const ARect: TFloatRect; const AString: string; const ALeft,
      ATop: Double; const AAngle: Integer);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure btnSetMouseZoomMoreClick(Sender:TObject);
    procedure SuperFormDestroy(Sender:TObject);
    procedure SuperFormResize(Sender:TObject);
    procedure btnCfgGraphClick(Sender:TObject);
    procedure edNbGenerationChange(Sender:TObject);
    procedure btnRefreshClick(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
//    procedure btnPrinterSetupClick(Sender:TObject);
    procedure BtnGraphOnTopLeftClick(Sender:TObject);
    procedure popupPopup(Sender:TObject);
    procedure popup_VoirLaFicheInBoxClick(Sender:TObject);
    procedure mImprimercettepageClick(Sender:TObject);
    procedure sbDescClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure btnSelectIndiGraphClick(Sender:TObject);
    procedure PanReglagesExit(Sender:TObject);
    procedure btnSetZoomAllClick(Sender:TObject);
    procedure btnSetMouseZoomLessClick(Sender:TObject);
    procedure TrackBarScroll(Sender:TObject;ScrollCode:TScrollCode;
      var ScrollPos:Integer);
    procedure TrackBarChange(Sender:TObject);
    procedure DmarrerlarbredepuiscetindividuClick(Sender:TObject);
    procedure OuvrirlafichedecetindividuClick(Sender:TObject);
    procedure cbInversionMouseUp(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure SuperFormShow(Sender:TObject);
    procedure PaintTreeDblClick(Sender:TObject);
    procedure LReglagesClick(Sender:TObject);
    procedure Panel5Click(Sender:TObject);
    procedure lNaisDecClick(Sender:TObject);
    procedure lNomClick(Sender:TObject);
    procedure SuperFormClick(Sender:TObject);
    procedure ViewerZoomChanged(Sender: TObject);

  private
    FData : TGraphData;
    //pour éviter les mises-à-jour circulaires entre controls, par leurs événements
    fFill:TState;

    //utilisé uniquement par le trackBar du Zoom
    fZooming:boolean;
    fZoomOnX_Viewer:integer;
    fZoomOnY_Viewer:integer;
    fZoomOnX_Chantier:single;
    fZoomOnY_Chantier:single;
    fCleIndi1: integer;
    fCleIndi2: integer;
    fNomIndiComplet: string;
    aFConfigHierarchie:TFGraphConfigHierarchie;
    aFConfigRoue:TFGraphConfigRoue;
    aFConfigLiens:TFGraphConfigLiens;
    fTypeGraph:string;
    PageX,PageY:integer;//page survolée par la souris
    AppelDirectRefreshTout:boolean;
    ListeActeTrouve : Array of integer;

    procedure AutoCreatePrintGraph;
    function fs_filter(const as_text: String): String;
    procedure InitGraph;
    procedure Load;
    function LoadArc: boolean;
    procedure LoadDescendance;
    function LoadLinks: boolean;
    function LoadTree: boolean;
    procedure p_EndPrinting;
    procedure p_PreparePrinting;
    procedure p_PrintAll;
    procedure p_printAPage;
    procedure p_PrintClick(const ab_printAll: Boolean=True);
  public
    fgraph, fMini : TGraphComponent;

    constructor Create(Sender:TComponent);override;
    procedure SetGraphOnTopLeft(sender:TObject);
    procedure RefreshTout;
    function doSelectOtherIndividu(const CleIndi:integer;const ForceRafraichis:boolean;const CleIndi2:Integer=-1):boolean;
    procedure ChargeGraph(const TypeGraph:string);
    procedure EnableBtnRefresh;
    procedure DisableBtnRefresh;
    procedure RefreshArbre;
    procedure MajApresPrinterSetup;

  end;

implementation

uses
  u_dm,
  IB,
  IBSQL,
  u_firebird_functions,
  Math,
  IBDatabase,
  u_common_graph_const,
  u_common_ancestro_functions,
  u_printreport,
  u_common_ancestro,
  fonctions_dialogs,
  fonctions_system,
  fonctions_string,
  u_form_main,
  u_common_const,
  u_common_functions,
  u_genealogy_context;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

constructor TFGraphPaintBox.Create(Sender:TComponent);
begin
  Inherited;
  fFill:=TState.create(false);
  OnShowFirstTime:=SuperFormShowFirstTime;
  AutoCreatePrintGraph;
  Panel5.Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  fZooming:=false;
  PanReglages.Left:=Width-PanReglages.Width;
  PanReglages.Color:=gci_context.ColorLight;
  btnSetMouseMoveOrSelect.Hint:=rs_Hint_Move_Graph;
  AppelDirectRefreshTout:=True;
  fgraph := nil;
end;

procedure TFGraphPaintBox.PaintArcMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var sNom,sNaisDec:String;
    iSexe,iGene,iParent: Integer;
begin
  if fGraph<>nil then
  begin
    if fGraph.GetCleIndividuAtXY(X,Y,sNom,sNaisDec,iSexe,iGene,iParent)>0 then
    begin
      case iSexe of
        1:
          begin
            lNom.Font.Color:=gci_context.ColorHomme;
            lNaisDec.Font.Color:=gci_context.ColorHomme;
          end;
        2:
          begin
            lNom.Font.Color:=gci_context.ColorFemme;
            lNaisDec.Font.Color:=gci_context.ColorFemme;
          end;
        else
          begin
            lNom.Font.Color:=clBlack;
            lNaisDec.Font.Color:=clBlack;
          end;
      end;
      lNom.Caption:=sNom;
      lNaisDec.Caption:=sNaisDec;
    end
    else
    begin
      lNom.Caption:='';
      lNaisDec.Caption:='';
    end;
  end
  else
  begin
    lNom.Caption:='';
    lNaisDec.Caption:='';
  end;

end;

procedure TFGraphPaintBox.PaintArcPrintArc(const AObject: TObject;
  const ARect: TFloatRect; const ABeginArcXC, ABeginArcYC, AEndArcXC,
  AEndArcYC: Extended);
begin
  with ARect, Viewer.PrintCanvas do
   Begin
  //   Arc(round(Left*ScaleWidth),round(Top*ScaleHeight),round(Right*ScaleWidth),round(Bottom*ScaleHeight),round(ABeginArcXC*ScaleWidth),round(ABeginArcYC*ScaleHeight),round(AEndArcXC*ScaleWidth),round(AEndArcYC*ScaleHeight));
   end;
//     round(ABeginArcXC),round(ABeginArcYC),round(AEndArcXC),round(AEndArcYC));
end;

procedure TFGraphPaintBox.PaintLinkPrintBrushSet(const AObject: TObject;
  const AColor: TColor; const PenStyle: TFPBrushStyle);
begin
  with Viewer.PrintCanvas.Brush do
   Begin
    Color := Acolor;
    Style:=PenStyle;
   end;
end;

procedure TFGraphPaintBox.PaintLinkPrintColor(const AObject: TObject;
  const AColor: TColor);
begin
  Viewer.PrintCanvas.Brush.Color:=AColor;
end;

procedure TFGraphPaintBox.PaintLinkPrintFont(const AObject: TObject;
  const AFont: TFont; const AFontSize: Single);
begin
  Viewer.PrintCanvas.Font.Assign(AFont);
  Viewer.PrintCanvas.Font.Size:=round(AFontSize*ScaleWidth);
end;

procedure TFGraphPaintBox.PaintLinkPrintLineTo(const AObject: TObject;
  const AX, AY: Extended);
begin
  Viewer.PrintCanvas.LineTo(round(AX*ScaleWidth),round(AY*ScaleHeight));
end;

procedure TFGraphPaintBox.PaintLinkPrintMoveTo(const AObject: TObject;
  const AX, AY: Extended);
begin
  Viewer.PrintCanvas.MoveTo(round(AX*ScaleWidth),round(AY*ScaleHeight));
end;

procedure TFGraphPaintBox.PaintLinkPrintOutTextXY(const AObject: TObject;
  const AString: string; const ALeft, ATop: Double; const AAngle: Integer=0);
begin
  if AString = '' Then Exit;
  Viewer.PrintCanvas.Font.Orientation:=AAngle;
  Viewer.PrintCanvas.TextOut(round(ALeft*ScaleWidth),round(ATop*ScaleHeight),AString);
//  ShowMessage('text ' + IntToStr(round(ATop*ScaleHeight))+ ' ' + IntToStr(round(ScaleHeight))+ ' ' + AString);
end;

procedure TFGraphPaintBox.PaintLinkPrintPenSet(const AObject: TObject;
  const AColor: TColor; const PenStyle: TFPPenStyle; const PenWidth: Single;
  const PenMode: TFPPenMode);
begin
  with Viewer.PrintCanvas.Pen do
   Begin
    Color := Acolor;
    Mode:=PenMode;
    Width:=round(PenWidth+0.5);
    Style:=PenStyle;
   end;
end;

procedure TFGraphPaintBox.PaintLinkPrintRect(const AObject: TObject; const AX1,
  AY1, AX2, AY2: Extended);
begin
  with Viewer.PrintCanvas do
   Begin
    Rectangle(round(AX1*ScaleWidth),round(AY1*ScaleHeight),round(AX2*ScaleWidth),round(AY2*ScaleHeight));
    MoveTo(round(AX1*ScaleWidth),round(AY1*ScaleHeight));
    LineTo(round(AX2*ScaleWidth),round(AY1*ScaleHeight));
    LineTo(round(AX2*ScaleWidth),round(AY2*ScaleHeight));
    LineTo(round(AX1*ScaleWidth),round(AY2*ScaleHeight));
    LineTo(round(AX1*ScaleWidth),round(AY1*ScaleHeight));
//    ShowMessage('ay1 ' + IntToStr(round(ay1*ScaleHeight))+ 'ay2 ' + IntToStr(round(ay2*ScaleHeight))+ ' ' + IntToStr(round(ScaleHeight)));
   end;
end;

procedure TFGraphPaintBox.PaintLinkPrintRoundRect(const AObject: TObject;
  const AX1, AY1, AX2, AY2, W, H: Extended);
begin
  with Viewer.PrintCanvas do
   Begin
    Rectangle(round(AX1*ScaleWidth),round(AY1*ScaleHeight),round(AX2*ScaleWidth),round(AY2*ScaleHeight));//,round(W),round(H));
    MoveTo(round(AX1*ScaleWidth),round(AY1*ScaleHeight));
    LineTo(round(AX2*ScaleWidth),round(AY1*ScaleHeight));
    LineTo(round(AX2*ScaleWidth),round(AY2*ScaleHeight));
    LineTo(round(AX1*ScaleWidth),round(AY2*ScaleHeight));
    LineTo(round(AX1*ScaleWidth),round(AY1*ScaleHeight));
//    ShowMessage('ay1 ' + IntToStr(round(ay1*ScaleHeight))+'ay2 ' + IntToStr(round(ay2*ScaleHeight))+ ' ' + IntToStr(round(ScaleHeight)));
   end;
end;

procedure TFGraphPaintBox.PaintLinkPrintSetRectXY(const AObject: TObject;
  const ARect: TFloatRect; const AString: string; const ALeft, ATop: Double;
  const AAngle: Integer);
var SomeRect : TRect;
begin
  with Viewer.PrintCanvas, Arect do
   Begin
    SomeRect.Left:=round(Left*ScaleWidth);
    SomeRect.Top :=round(Top*ScaleHeight);
    SomeRect.Right:=round(Right*ScaleWidth);
    SomeRect.Bottom:= round(Bottom*ScaleHeight);
    Font.Orientation:=AAngle;
    TextRect(SomeRect,round(ALeft*ScaleWidth),round(ATop*ScaleHeight),AString);
//    ShowMessage('text rect ' + IntToStr(round(ATop*ScaleHeight))+ ' '+ IntToStr(somerect.Top)+ ' ' + IntToStr(round(ScaleHeight))+ ' ' + AString);
   end;
end;


procedure TFGraphPaintBox.cb_papersizeChange(Sender: TObject);
begin
  p_SetPageSetup(PrintGraph.rp.PageSetup,cb_papersize.Text);
  MajApresPrinterSetup;
end;

procedure TFGraphPaintBox.btnPrintPictureClick(Sender: TObject);
var li_shiftx,li_shifty:Integer;
    lw_zoom : Word;
    lsi_Ratio : Single;
    ARect:TRect;
begin
  p_SetPageSetup(btnPrintPicture,cb_papersize.Text,ch_Portrait.Checked);
  with Viewer do
   Begin
    fgraph.Visible:=False;
    lsi_Ratio:=ScreenRatio;
    lw_zoom  :=Zoom;
    li_shiftx:=ShiftX;
    li_shifty:=ShiftY;
    with Viewer,fgraph,btnPrintPicture,Picture.Bitmap do
     try
       case rg_sortie.ItemIndex of
         0:PrinterType:=pfPrinter;
         1:PrinterType:=pfPDF;
         2:PrinterType:=pfRTF;
       end;
       if Graph = PaintArc
        Then ScreenRatio:=5 /Data.Generations
        else ScreenRatio:=10/Data.Generations;
       ApplyZoomAtPoint(6,0,0);
       //create a correct resolution
       ARect:=Graph.GetRectEncadrement();
       with arect do
        Begin
         Left   :=round(Left  *Zoom*ScreenRatio/lsi_Ratio/lw_zoom);
         Right  :=round(Right *Zoom*ScreenRatio/lsi_Ratio/lw_zoom);
         Top    :=round(Top   *Zoom*ScreenRatio/lsi_Ratio/lw_zoom);
         Bottom :=round(Bottom*Zoom*ScreenRatio/lsi_Ratio/lw_zoom);
         Width :=Right -Left;
         Height:=bottom-Top;
        end;
       if Width>Height
        Then Orientation:=poLandscape
        Else Orientation:=poPortrait;
       Canvas.Brush.Color:=clWhite;
       Canvas.FillRect(0,0,Width,Height);
       PaintGraph(Canvas,ARect.Left,ARect.Top);
       Modified := True ;
     finally
       //retrieve screen resolution
       ScreenRatio:=lsi_Ratio;
       Zoom   :=lw_zoom;
       ShiftX:=li_shiftx;
       ShiftY:=li_shifty;
       fgraph.Visible:=True;
     end;

   end;
end;

procedure TFGraphPaintBox.ch_PortraitClick(Sender: TObject);
begin
  p_SetPageSetup(PrintGraph.rp.PageSetup,ch_Portrait.Checked);
  MajApresPrinterSetup;
end;

procedure TFGraphPaintBox.FormActivate(Sender: TObject);
begin
  // PrintGraph can be destroy by some graphs
  AutoCreatePrintGraph;
end;

// PrintGraph can be destroy by some graphs
procedure TFGraphPaintBox.AutoCreatePrintGraph;
begin
  if PrintGraph = nil Then
    PrintGraph:=TPrintGraph.Create(Self);
end;

procedure TFGraphPaintBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP    : Viewer.ShiftY:=Viewer.ShiftY+round(Viewer.PageHeight / 9);
    VK_DOWN  : Viewer.ShiftY:=Viewer.ShiftY-round(Viewer.PageHeight / 9);
    VK_LEFT  : Viewer.ShiftX:=Viewer.ShiftX-round(Viewer.PageWidth  / 9);
    VK_RIGHT : Viewer.ShiftX:=Viewer.ShiftX+round(Viewer.PageWidth  / 9);
    VK_NEXT  : Viewer.Zoom:=Viewer.Zoom+10;
    VK_PRIOR : Viewer.Zoom:=Viewer.Zoom-10;
  end;
end;

procedure TFGraphPaintBox.SuperFormShowFirstTime(Sender:TObject);
begin
  TrackBar.Min:=_ZOOM_MIN;
  TrackBar.Max:=_ZOOM_MAX;
end;

procedure TFGraphPaintBox.btnSetMouseZoomMoreClick(Sender: TObject);
begin
  Viewer.Zoom:=Viewer.Zoom+10;
end;

procedure TFGraphPaintBox.SuperFormDestroy(Sender:TObject);
begin
  fgraph.WriteSectionIni;
  fFill.Destroy;
  FreeAndNil(PrintGraph);
  with FMain do
   Begin
         if Self = aFGraphPaintArbre   Then aFGraphPaintArbre   := nil
    Else if Self = aFGraphPaintRoue    then aFGraphPaintRoue    := nil
    else if Self = aFGraphPaintLiens   Then aFGraphPaintLiens   := nil
    Else if Self = aFGraphPaintParente Then aFGraphPaintParente := nil;
   end;
end;



procedure TFGraphPaintBox.SuperFormResize(Sender:TObject);
begin
  if Viewer<>nil then
    Viewer.RefreshMiniature;
end;

procedure TFGraphPaintBox.InitGraph;
Begin
  Viewer.Graph:=fgraph;
  Viewer.GraphMiniature:=fMini;
  fgraph.ReadSectionIni;
end;

procedure TFGraphPaintBox.ChargeGraph(const TypeGraph:string);
const
  deplacementL=20;
  deplacementP=150;
var
  deplacement:integer;
begin
  fTypeGraph:=TypeGraph;
  if assigned ( fgraph ) Then
    fgraph.WriteSectionIni;
  if fTypeGraph='ARBRE' then
    Graph_RecouvrementImpression:=gci_context.ArbreRecouvrement
  else if fTypeGraph='ROUE' then
    Graph_RecouvrementImpression:=gci_context.RoueRecouvrement
  else if (fTypeGraph='LIENS')or(fTypeGraph='PARENTE') then
    Graph_RecouvrementImpression:=gci_context.LiensRecouvrement;

  if fTypeGraph='ARBRE' then
  begin
    fgraph:=PaintTree;
    initgraph;
    FData := GraphTreeData;
    fMini:=GraphTreeMini;
    PaintArc.Hide;
    PaintLink.Hide;
    GraphArcMini.Hide;
    aFConfigHierarchie:=TFGraphConfigHierarchie.create(self);
    aFConfigHierarchie.InitView(painttree);

//    aFConfigHierarchie.PtrGraph:=TGraphArbre(fGraph);

    edNbGeneration.Value:=gci_context.ArbreShowNbGeneration;
    sbDesc.Checked:=gci_context.ArbreDescendance;
    sbDesc.Visible:=true;
    cbInversion.Visible:=true;
    cbInversion.Checked:=gci_context.ArbreInverse;
  end
  else if fTypeGraph='ROUE' then
  begin
    fgraph:=PaintArc;
    initgraph;
    FData := GraphArcData;
    fMini:=GraphArcMini;
    PaintTree.Hide;
    PaintLink.Hide;
    GraphTreeMini.Hide;
    GraphLinkMini.Hide;
    aFConfigRoue:=TFGraphConfigRoue.create(self);
    aFConfigroue.InitView(PaintArc);


//    aFConfigRoue.PtrGraph:=TGraphRoue(fGraph);

    GraphArcData.KeyFirst:=-1;
    edNbGeneration.Value:=gci_context.RoueShowNbGeneration;
    sbDesc.Visible:=false;
    cbInversion.Visible:=false;
  end
  else if (fTypeGraph='LIENS')or(fTypeGraph='PARENTE') then
  begin
    fgraph:=PaintLink;
    initgraph;
    FData := GraphLinkData;
    fMini:=GraphLinkMini;
    PaintTree.Hide;
    PaintArc.Hide;
    GraphTreeMini.Hide;
    GraphArcMini.Hide;
    aFConfigLiens:=TFGraphConfigLiens.create(self);
    aFConfigLiens.InitView(PaintLink);
//    aFConfigLiens.PtrGraph:=TGraphLiens(fGraph);

    FCleIndi1:=-1;
    FCleIndi2:=-1;
    if fTypeGraph='LIENS' then
    begin
      sbDesc.Width:=140;
      sbDesc.Caption:=rs_Caption_Without_witness_links;//pas coché au départ
      sbDesc.Visible:=true;//utilisé pour la sélection sans témoins
      deplacement:=deplacementL;
    end
    else
    begin
      sbDesc.Visible:=false;
      deplacement:=deplacementP;
    end;
    cbInversion.Visible:=false;
    edNbGeneration.Visible:=false;
    lNbGenerations.Visible:=false;
    btnRefresh.Left:=btnRefresh.Left-deplacement;
    btnPrint.Left:=btnPrint.Left-deplacement;
    lNom.Left:=lNom.Left-deplacement;
    lNaisDec.Left:=lNaisDec.Left-deplacement;
  end;

  fgraph.Show;
  fMini .Show;
  Viewer.Data:=FData;
  //FMain.MemeMoniteur(self);

  Viewer.BuildZonesImpression;
//  Viewer.MouseMode:=mmMoveOrSelect;

  //Miniature
  Viewer.BuildMiniature;

  btnSetZoomAllClick(nil);

  Viewer.ShiftX:=0;
  Viewer.ShiftY:=0;
  Viewer.Refresh;
  Viewer.RefreshMiniature;

  DisableBtnRefresh;
  show;
end;

procedure TFGraphPaintBox.SetGraphOnTopLeft(sender:TObject);
begin
  Viewer.ShiftX:=0;
  Viewer.ShiftY:=0;
  Viewer.Refresh;
  Viewer.RefreshMiniature;
end;

procedure TFGraphPaintBox.RefreshTout;
begin
  btnPrintPicture.Enabled:=False;
  Viewer.BeginUpdate;
  try
    Load;
    if (fTypeGraph='LIENS')or(fTypeGraph='PARENTE') then
      if FCleIndi1=-1 then
      begin
        if AppelDirectRefreshTout then
          close;
        exit;
      end;

    Viewer.BuildZonesImpression;
    Viewer.BuildMiniature;
    Viewer.PrepareGraph;
  finally
    Viewer.EndUpdate;
  end;
  Viewer.Refresh;
  Viewer.RefreshMiniature;
  Viewer.ZoomAll;
  if WindowState=wsMinimized then
    WindowState:=wsNormal;
  btnPrintPicture.Enabled:=(Viewer.ViewYC.Count < 4) and (Viewer.ViewXC.Count < 4);
end;

procedure TFGraphPaintBox.Load;
Begin
  if fgraph = PaintTree Then
    LoadTree
  else
  if fgraph = PaintArc Then
   Begin
     Caption:=fs_RemplaceMsg(rs_Ancestries_Arc_of,[FMain.NomIndiComplet]);
     LoadArc;
   end
  else
  if fgraph = PaintLink Then
     LoadLinks;
  Self.Caption:=StringReplace(fNomIndiComplet,_CRLF,'',[rfReplaceAll]);
  // roue mal imprimée ( manque rotation at arc )
  btnPrint.Enabled:=fgraph <> PaintArc;
  mImprimercettepage.Enabled:=btnPrint.Enabled;
end;

function TFGraphPaintBox.doSelectOtherIndividu(const CleIndi:integer;const ForceRafraichis:boolean;const CleIndi2:integer=-1):boolean;
begin
  DisableBtnRefresh;
  AppelDirectRefreshTout:=false;
  fCleIndi1:=CleIndi;
  fCleIndi2:=CleIndi2;
  result:=true;
  if FData.KeyFirst<>CleIndi then
  begin
    FData.KeyFirst:=CleIndi;
    RefreshTout;
  end
  else if ForceRafraichis then
    RefreshTout;
  show;
  AppelDirectRefreshTout:=True;
end;

procedure TFGraphPaintBox.btnCfgGraphClick(Sender:TObject);
begin
  if fTypeGraph='ARBRE' then
    aFConfigHierarchie.Show
  else if fTypeGraph='ROUE' then
    aFConfigRoue.Show
  else if (fTypeGraph='LIENS')or(fTypeGraph='PARENTE') then
    aFConfigLiens.Show;
end;

procedure TFGraphPaintBox.edNbGenerationChange(Sender:TObject);
begin
  EnableBtnRefresh;
  gci_context.ShouldSave:=true;
  if fTypeGraph='ARBRE' then
   Begin
    gci_context.ArbreShowNbGeneration:=edNbGeneration.Value;
    GraphTreeData.Generations:=edNbGeneration.Value;
   end
  else if fTypeGraph='ROUE' then
   Begin
    gci_context.RoueShowNbGeneration:=edNbGeneration.Value;
    GraphArcData.Generations:=edNbGeneration.Value;
   end
end;

procedure TFGraphPaintBox.btnRefreshClick(Sender:TObject);
begin
  DisableBtnRefresh;
  RefreshTout;
end;

procedure TFGraphPaintBox.btnPrintClick(Sender:TObject);
begin
  p_PrintClick ( True );
end;
procedure TFGraphPaintBox.p_PreparePrinting;
begin
  case rg_sortie.ItemIndex of
    1 : sd_PDFRTF.DefaultExt:='.pdf';
    2 : sd_PDFRTF.DefaultExt:='.rtf';
    0 : if Printer.Printers.Count=0 then
            begin
              MyMessageDlg(rs_Report_There_is_no_printer,mtError, [mbOK],Self);
              Exit;
            end;
   end;
  if rg_sortie.ItemIndex > 0 Then
   Begin
    sd_PDFRTF.filename:=fPathBaseMedias+Self.Caption+sd_PDFRTF.DefaultExt;
    sd_PDFRTF.InitialDir:=fPathBaseMedias;
    if not sd_PDFRTF.Execute Then
      Exit;
   end;
  p_SetPageSetup ( PrintGraph.rp.PageSetup, cb_papersize.Text, ch_Portrait.Checked );

end;

procedure TFGraphPaintBox.p_EndPrinting;
begin
  //if not printed open file
  if rg_sortie.ItemIndex > 0 Then
   p_OpenFileOrDirectory(sd_PDFRTF.FileName);

end;

procedure TFGraphPaintBox.p_PrintClick(const ab_printAll : Boolean = True);
begin
  p_PreparePrinting;
  if ab_printAll
   Then p_PrintAll
   Else p_printAPage;
  p_EndPrinting;
end;

procedure TFGraphPaintBox.p_printAPage;
begin
  if Printer.Printers.Count=0 then
    MyMessageDlg(rs_There_is_no_printer,mtError, [mbOK],Self)
  else //On imprime juste la page
  begin
    if fTypeGraph='ARBRE' then
      PrintGraph.PrintPage(Self,fgraph,PageX,PageY,rg_sortie.ItemIndex,sd_PDFRTF.Filename)
    else if fTypeGraph='ROUE' then
      PrintGraph.PrintPage(Self,fgraph,PageX,PageY,rg_sortie.ItemIndex,sd_PDFRTF.Filename)
    else if (fTypeGraph='LIENS')or(fTypeGraph='PARENTE') then
      PrintGraph.PrintPage(Self,fgraph,PageX,PageY,rg_sortie.ItemIndex,sd_PDFRTF.Filename);
  end;
end;

procedure TFGraphPaintBox.p_PrintAll;
Begin
  if fTypeGraph='ARBRE' then
    PrintGraph.Print(Self,fgraph,rg_sortie.ItemIndex,sd_PDFRTF.Filename)
  else if fTypeGraph='ROUE' then
    PrintGraph.Print(Self,fgraph,rg_sortie.ItemIndex,sd_PDFRTF.Filename)
  else if (fTypeGraph='LIENS')or(fTypeGraph='PARENTE') then
    PrintGraph.Print(Self,fgraph,rg_sortie.ItemIndex,sd_PDFRTF.Filename);
end;

{
procedure TFGraphPaintBox.btnPrinterSetupClick(Sender:TObject);
begin
  PrintGraph.PrinterSetup;
  DoSendMessage(Owner,'MAJ_APRES_PRINTERSETUP');
end;
}
procedure TFGraphPaintBox.MajApresPrinterSetup;
begin
  if Viewer<>nil then
  begin
    Viewer.BeginUpdate;
    with PrintGraph.rp,PageSetup,Margins do
    try
      case orientation of
        poPortrait : Begin
                       Viewer.PageWidth :=round(PaperWidth-LeftMargin-RightMargin-Graph_RecouvrementImpression);
                       Viewer.PageHeight:=round(PaperHeight-TopMargin-BottomMargin-Graph_RecouvrementImpression);
                     End;
        poLandscape : Begin
                        Viewer.PageHeight:=round(PaperWidth-LeftMargin-RightMargin-Graph_RecouvrementImpression);
                        Viewer.PageWidth :=round(PaperHeight-TopMargin-BottomMargin-Graph_RecouvrementImpression);
                       End;
        end;
//      fGraph.Prepare;
      Viewer.BuildZonesImpression;
      Viewer.BuildMiniature;
      Viewer.PrepareGraph;
    finally
      Viewer.EndUpdate;
    end;
    Viewer.Refresh;
    Viewer.RefreshMiniature;
  end;
end;

procedure TFGraphPaintBox.BtnGraphOnTopLeftClick(Sender:TObject);
begin
  SetGraphOnTopLeft(self);
end;

procedure TFGraphPaintBox.popupPopup(Sender:TObject);
var
  k,iSexe,iGene,iParent,i,j,ne,nc:integer;
  Px,Py,nx,ny:integer;
  P:TPoint;
  s,sNom,sNaisDec:string;
  NewSitem,NewItem:TMenuItem;

  procedure AjouteSsMenu;
  begin
    NewSitem:=TMenuItem.create(NewItem);
    NewItem.Add(NewSitem);
    NewSitem.Tag:=NewItem.Tag;
    NewSitem.Caption:=rs_Caption_Open_the_person_s_file_double_click;
    NewSitem.Onclick:=OuvrirlafichedecetindividuClick;
    NewSitem.Default:=true;
    NewSitem:=TMenuItem.create(NewItem);
    NewItem.Add(NewSitem);
    NewSitem.Tag:=NewItem.Tag;
    NewSitem.Caption:=rs_Caption_Consult_the_file_on_another_window;
    NewSitem.Onclick:=popup_VoirLaFicheInBoxClick;
    if fTypeGraph='ARBRE' then
    begin
      NewSitem:=TMenuItem.create(NewItem);
      NewItem.Add(NewSitem);
      NewSitem.Tag:=NewItem.Tag;
      NewSitem.Caption:=rs_Caption_Start_tree_from_this_person;
      NewSitem.Onclick:=DmarrerlarbredepuiscetindividuClick;
    end;
  end;

begin
  k:=-1;
  P:=PaintTree.ScreenToClient(TMyPopupMenu(popup).PopupPoint);

  if fGraph<>nil then
    k:=fGraph.GetCleIndividuAtXY(P.X,P.Y,sNom,sNaisDec,iSexe,iGene,iParent);//toujours -1 pour la roue

  popup_VoirLaFicheInBox.visible:=false;
  Ouvrirlafichedecetindividu.visible:=false;
  Dmarrerlarbredepuiscetindividu.visible:=false;
  mNgene.Visible:=false;
  if k>0 then
  begin
    popup_VoirLaFicheInBox.visible:=True;
    popup_VoirLaFicheInBox.tag:=k;
    Ouvrirlafichedecetindividu.visible:=True;
    Ouvrirlafichedecetindividu.tag:=k;
    if fTypeGraph='ARBRE' then
    begin
      Dmarrerlarbredepuiscetindividu.visible:=True;
      Dmarrerlarbredepuiscetindividu.tag:=k;
      mNgene.Visible:=true;
      mNgene.Caption:=fs_RemplaceMsg(rs_Generation,[IntToStr(iGene)]);
    end;
  end;

  PageX:=-1;
  PageY:=-1;
  Px:=P.x-Viewer.ShiftX;
  Py:=P.y-Viewer.ShiftY;
  for ny:=1 to Viewer.ViewYV.count-1 do
  begin
    for nx:=1 to Viewer.ViewXV.count-1 do
    begin
      if (Px>=Viewer.ViewXV[nx-1])and(Py>=Viewer.ViewYV[ny-1])and
        (Px<=Viewer.ViewXV[nx])and(Py<=Viewer.ViewYV[ny]) then
      begin
        PageX:=nx-1;
        PageY:=ny-1;
        break;
      end;
    end;
  end;
  if (PageX<>-1)and(PageY<>-1) then
    mImprimercettepage.Caption:=fs_RemplaceMsg(rs_Caption_Print_this_page,[IntToStr((Viewer.ViewXV.count-1)*PageY+(PageX+1))+'/'
      +IntToStr((Viewer.ViewXV.count-1)*(Viewer.ViewYV.count-1))])
  else
    mImprimercettepage.Caption:=fs_RemplaceMsg(rs_Caption_Pages_count,[IntToStr((Viewer.ViewXV.count-1)*(Viewer.ViewYV.count-1))]);

  Ouvrirlafichedecetindividu.Default:=true;//Ouvrir la fiche (ou dbl-click)
  for i:=popup.Items.Count-1 downto 7 do //supprime les items après Génération (n°6)
    popup.Items[i].Free;
  if (k>0)and((not gci_context.ArbreDescendance)or(fTypeGraph='LIENS')or(fTypeGraph='PARENTE')) then
  begin
    j:=-10;
    ne:=0;
    nc:=0;
    NewItem:=TMenuItem.Create(self);
    popup.Items.Add(NewItem);
    NewItem.Caption:='-';
    NewItem:=TMenuItem.Create(self);
    popup.Items.Add(NewItem);
    with FMain.QCjEnf do
    begin
      close;
      ParamByName('cle_fiche').AsInteger:=k;
      ExecQuery;
      while not Eof do
      begin
        if (FieldByName('CLE_CONJOINT').AsInteger<>j) then //on ajoute un conjoint
        begin
          inc(nc);
          NewItem:=TMenuItem.Create(self);
          popup.Items.Add(NewItem);
          NewItem.Caption:='-';
          NewItem:=TMenuItem.Create(self);
          popup.Items.Add(NewItem);
          j:=FieldByName('CLE_CONJOINT').AsInteger;
          NewItem.Tag:=j;
          s:=FieldByName('NOMPRENOM_CONJOINT').AsString;
          if s='' then
            if iSexe=1
             then s:=fs_FormatText(rs_unknown_female,mftFirstIsMaj)
             else s:=fs_FormatText(rs_unknown_male  ,mftFirstIsMaj);
          NewItem.Caption:=s+' '+FieldByName('NAISSDECES_CONJOINT').AsString;
          i:=FieldByName('SEXE_CONJOINT').AsInteger;
          if i=0 then
            case iSexe of
              1:i:=2;
              2:i:=1;
            end;
          case i of
            1:NewItem.ImageIndex:=103;
            2:NewItem.ImageIndex:=104;
            else
              NewItem.ImageIndex:=36;
          end;
          AjouteSsMenu;
        end;

        if FieldByName('CLE_FICHE').AsInteger>0 then
        begin
          inc(ne);
          NewItem:=TMenuItem.Create(self);
          popup.Items.Add(NewItem);
          NewItem.Tag:=FieldByName('CLE_FICHE').AsInteger;
          NewItem.Caption:=FieldByName('NOMPRENOM').AsString+' '+FieldByName('NAISSDECES').AsString;
          case FieldByName('SEXE').AsInteger of
            1:NewItem.ImageIndex:=101;
            2:NewItem.ImageIndex:=102;
            else
              NewItem.ImageIndex:=36;
          end;
          AjouteSsMenu;
        end;
        Next;
      end;
      close;
    end;
    if nc>0 then
    begin
      if nc=1 then
        s:=rs_the_joint
      else
        s:=fs_RemplaceMsg(rs_the_joints,[IntToStr(nc)]);
      if ne=1 then
        s:=s+rs_and_the_child
      else if ne>1 then
        s:=s+fs_RemplaceMsg(rs_and_the_children,[IntToStr(ne)]);
      popup.Items[8].Caption:=s;
      for i:=popup.Items.Count-1 downto 7 do
        popup.Items[i].Default:=popup.Items[i].Tag=iParent;
    end
    else
      popup.Items[8].Caption:=rs_Without_known_child_and_joint;
  end;
end;

{$WARNINGS OFF}

function TFGraphPaintBox.fs_filter ( const as_text : String ):String;
Begin
  Result:=StringReplace(StringReplace(StringReplace(StringReplace(as_text,':indi1',IntToStr(fCleIndi1),[rfReplaceAll,rfIgnoreCase]),':indi2',IntToStr(fCleIndi2),[rfReplaceAll,rfIgnoreCase]),'indi1',IntToStr(fCleIndi1),[rfReplaceAll,rfIgnoreCase]),'indi2',IntToStr(fCleIndi2),[rfReplaceAll,rfIgnoreCase]);
end;
function TFGraphPaintBox.LoadLinks:boolean;
var
  Q:TIBSQL;
  IBTransactionPropre:TIBTransaction;
  sniveau1,sniveau2:String;

  Function PreChargeLiens:Boolean;
  const
    req1='execute block'
          +_CRLF+'returns(indi integer'
          +_CRLF+',nom varchar(40)'
          +_CRLF+',prenom varchar(60)'
          +_CRLF+',sexe integer'
          +_CRLF+',sosa smallint'
          +_CRLF+',lien smallint'
          +_CRLF+',occu varchar(90)'
          +_CRLF+',annee_naissance varchar(23)'
          +_CRLF+',annee_deces varchar(23)'
          +_CRLF+',date_naissance varchar(100)'
          +_CRLF+',date_deces varchar(100)'
          +_CRLF+',subd_naissance varchar(50)'
          +_CRLF+',subd_deces varchar(50)'
          +_CRLF+',ville_naissance varchar(50)'
          +_CRLF+',ville_deces varchar(50)'
          +_CRLF+',dept_naissance varchar(30)'
          +_CRLF+',dept_deces varchar(30)'
          +_CRLF+',region_naissance varchar(50)'
          +_CRLF+',region_deces varchar(50)'
          +_CRLF+',pays_naissance varchar(30)'
          +_CRLF+',pays_deces varchar(30)'
          +_CRLF+')'
          +_CRLF+'as declare variable i_dossier integer;'
          +_CRLF+'declare variable i_count integer;'
          +_CRLF+'declare variable i integer;'
          +_CRLF+'declare variable i_ind integer;'
          +_CRLF+'declare variable i_indiv integer;'
          +_CRLF+'declare variable trouve smallint;'
          +_CRLF+'begin'
          +_CRLF+' select kle_dossier from individu where cle_fiche=:indi1 into :i_dossier;'
          +_CRLF+'delete from tq_anc;';

        reqt1='delete from tq_id;'
          +_CRLF+'for select e.ev_ind_kle_fiche,a.assoc_kle_associe'
          +_CRLF+' from t_associations a'
          +_CRLF+' inner join individu ind on ind.cle_fiche=a.assoc_kle_associe and ind.kle_dossier=:i_dossier'
          +_CRLF+' inner join evenements_ind e on e.ev_ind_clef=a.assoc_evenement'
          +_CRLF+' where a.assoc_table=''I'''
          +_CRLF+' and not exists (select 1 from tq_id where id1=e.ev_ind_kle_fiche and id2=a.assoc_kle_associe)'
          +_CRLF+' into :i_ind,:i_indiv'
          +_CRLF+' do insert into tq_id (id1,id2) values(:i_ind,:i_indiv);'
          +_CRLF+'for select u.union_mari,a.assoc_kle_associe'
          +_CRLF+' from t_associations a'
          +_CRLF+' inner join individu ind on ind.cle_fiche=a.assoc_kle_associe and ind.kle_dossier=:i_dossier'
          +_CRLF+' inner join evenements_fam e on e.ev_fam_clef=a.assoc_evenement'
          +_CRLF+' inner join t_union u on u.union_clef=e.ev_fam_kle_famille'
          +_CRLF+' where a.assoc_table=''U'''
          +_CRLF+' and not exists (select 1 from tq_id where id1=u.union_mari and id2=a.assoc_kle_associe)'
          +_CRLF+' into :i_ind,:i_indiv'
          +_CRLF+' do insert into tq_id (id1,id2) values(:i_ind,:i_indiv);'
          +_CRLF+'for select u.union_femme,a.assoc_kle_associe'
          +_CRLF+' from t_associations a'
          +_CRLF+' inner join evenements_fam e on e.ev_fam_clef=a.assoc_evenement'
          +_CRLF+' inner join t_union u on u.union_clef=e.ev_fam_kle_famille'
          +_CRLF+' where a.assoc_table=''U'''
          +_CRLF+' and not exists (select 1 from tq_id where id1=u.union_femme and id2=a.assoc_kle_associe)'
          +_CRLF+' into :i_ind,:i_indiv'
          +_CRLF+' do insert into tq_id (id1,id2) values(:i_ind,:i_indiv);';

        req2='i=0;'
          +_CRLF+'insert into tq_anc (niveau,indi,decujus,enfant)values(:i,:indi1,null,0);'
          +_CRLF+'trouve=0;'
          +_CRLF+'i_count=1;'
          +_CRLF+'while ((i_count>0)and(trouve=0)) do '
          +_CRLF+'begin '
          +_CRLF+'i_count=0;'
          +_CRLF+'for select indi from tq_anc where niveau=:i order by enfant into :i_indiv do '
          +_CRLF+'begin '
          +_CRLF+'for select ind.cle_fiche,iif(ind.cle_fiche=:indi2,1,0) '
          +_CRLF+'from individu ind '
          +_CRLF+'where ind.cle_pere=:i_indiv and :trouve=0 '
          +_CRLF+'and not exists (select 1 from tq_anc where indi=ind.cle_fiche) '
          +_CRLF+'into :i_ind,:trouve '
          +_CRLF+'do begin '
          +_CRLF+'insert into tq_anc (niveau,indi,decujus,enfant)values(:i+1,:i_ind,:i_indiv,1);'
          +_CRLF+'i_count=1;'
          +_CRLF+'end '
          +_CRLF+'for select ind.cle_fiche,iif(ind.cle_fiche=:indi2,1,0) '
          +_CRLF+'from individu ind '
          +_CRLF+'where ind.cle_mere=:i_indiv and :trouve=0 '
          +_CRLF+'and not exists (select 1 from tq_anc where indi=ind.cle_fiche) '
          +_CRLF+'into :i_ind,:trouve '
          +_CRLF+'do begin '
          +_CRLF+'insert into tq_anc (niveau,indi,decujus,enfant)values(:i+1,:i_ind,:i_indiv,2);'
          +_CRLF+'i_count=1;'
          +_CRLF+'end '
          +_CRLF+'for select ind.cle_pere,iif(ind.cle_pere=:indi2,1,0) '
          +_CRLF+'from individu ind '
          +_CRLF+'where ind.cle_fiche=:i_indiv and ind.cle_pere is not null and :trouve=0 '
          +_CRLF+'and not exists (select 1 from tq_anc where indi=ind.cle_pere) '
          +_CRLF+'into :i_ind,:trouve '
          +_CRLF+'do  begin '
          +_CRLF+'insert into tq_anc (niveau,indi,decujus,enfant)values(:i+1,:i_ind,:i_indiv,3);'
          +_CRLF+'i_count=1;'
          +_CRLF+'end '
          +_CRLF+'for select ind.cle_mere,iif(ind.cle_mere=:indi2,1,0) '
          +_CRLF+'from individu ind '
          +_CRLF+'where ind.cle_fiche=:i_indiv and ind.cle_mere is not null and :trouve=0 '
          +_CRLF+'and not exists (select 1 from tq_anc where indi=ind.cle_mere) '
          +_CRLF+'into :i_ind,:trouve '
          +_CRLF+'do  begin '
          +_CRLF+'insert into tq_anc (niveau,indi,decujus,enfant)values(:i+1,:i_ind,:i_indiv,4);'
          +_CRLF+'i_count=1;'
          +_CRLF+'end '
          +_CRLF+'for select u.union_mari,iif(u.union_mari=:indi2,1,0) '
          +_CRLF+'from t_union u '
          +_CRLF+'where u.union_femme=:i_indiv and u.union_mari is not null and :trouve=0 '
          +_CRLF+'and not exists (select 1 from tq_anc where indi=u.union_mari) '
          +_CRLF+'into :i_ind,:trouve '
          +_CRLF+'do begin '
          +_CRLF+'insert into tq_anc (niveau,indi,decujus,enfant)values(:i+1,:i_ind,:i_indiv,5);'
          +_CRLF+'i_count=1;'
          +_CRLF+'end '
          +_CRLF+'for select u.union_femme,iif(u.union_femme=:indi2,1,0) '
          +_CRLF+'from t_union u '
          +_CRLF+'where u.union_mari=:i_indiv and u.union_femme is not null and :trouve=0 '
          +_CRLF+'and not exists (select 1 from tq_anc where indi=u.union_femme) '
          +_CRLF+'into :i_ind,:trouve '
          +_CRLF+'do begin '
          +_CRLF+'insert into tq_anc (niveau,indi,decujus,enfant)values(:i+1,:i_ind,:i_indiv,6);'
          +_CRLF+'i_count=1;'
          +_CRLF+'end';

        reqt2=' for select a.id2,iif(a.id2=:indi2,1,0)'
          +_CRLF+' from tq_id a'
          +_CRLF+' where a.id1=:i_indiv and :trouve=0'
          +_CRLF+' and not exists (select 1 from tq_anc where indi=a.id2)'
          +_CRLF+' into :i_ind,:trouve'
          +_CRLF+' do begin'
          +_CRLF+' insert into tq_anc (niveau,indi,decujus,enfant)values(:i+1,:i_ind,:i_indiv,7);'
          +_CRLF+'i_count=1;'
          +_CRLF+'end'
          +_CRLF+' for select a.id1,iif(a.id1=:indi2,1,0)'
          +_CRLF+' from tq_id a'
          +_CRLF+' where a.id2=:i_indiv and :trouve=0'
          +_CRLF+' and not exists (select 1 from tq_anc where indi=a.id1)'
          +_CRLF+' into :i_ind,:trouve'
          +_CRLF+' do begin'
          +_CRLF+' insert into tq_anc (niveau,indi,decujus,enfant)values(:i+1,:i_ind,:i_indiv,8);'
          +_CRLF+'i_count=1;'
          +_CRLF+'end';

        req3=' end'
          +_CRLF+' i=i+1;'
          +_CRLF+'end'
          +_CRLF+' delete from tq_id;'
          +_CRLF+'if (trouve=1) then'
          +_CRLF+' begin'
          +_CRLF+' i_ind=indi2;'
          +_CRLF+'while (i_ind is not null) do'
          +_CRLF+' begin'
          +_CRLF+' select indi,decujus,enfant'
          +_CRLF+' from tq_anc where indi=:i_ind'
          +_CRLF+' into :i_indiv,:i_ind,:i;'
          +_CRLF+'insert into tq_id (id1,id2) values(:i_indiv,:i);'
          +_CRLF+'end'
          +_CRLF+' end'
          +_CRLF+' for select t.id1'
          +_CRLF+',ind.nom'
          +_CRLF+',ind.prenom'
          +_CRLF+',ind.sexe'
          +_CRLF+',case when ind.num_sosa>0 then 1 else 0 end'
          +_CRLF+',t.id2'
          +_CRLF+',(SELECT first(1) ev_ind_description from evenements_ind'
          +_CRLF+'  where ev_ind_type=''OCCU'' and ev_ind_kle_fiche=t.id1'
          +_CRLF+'  order by ev_ind_ordre desc,ev_ind_datecode desc)'
          +_CRLF+',n.ev_ind_date_courte as annee_naissance'
          +_CRLF+',d.ev_ind_date_courte as annee_deces'
          +_CRLF+',ind.date_naissance'
          +_CRLF+',ind.date_deces'
          +_CRLF+',n.ev_ind_subd'
          +_CRLF+',d.ev_ind_subd'
          +_CRLF+',n.ev_ind_ville'
          +_CRLF+',d.ev_ind_ville';

        req4=',n.ev_ind_region'
          +_CRLF+',d.ev_ind_region'
          +_CRLF+',n.ev_ind_pays'
          +_CRLF+',d.ev_ind_pays'
          +_CRLF+' from tq_id t inner join individu ind on ind.cle_fiche=t.id1'
          +_CRLF+' left join evenements_ind n on n.ev_ind_type=''BIRT'' and n.ev_ind_kle_fiche=t.id1'
          +_CRLF+' left join evenements_ind d on d.ev_ind_type=''DEAT'' and d.ev_ind_kle_fiche=t.id1'
          +_CRLF+' into :indi'
          +_CRLF+',:nom'
          +_CRLF+',:prenom'
          +_CRLF+',:sexe'
          +_CRLF+',:sosa'
          +_CRLF+',:lien'
          +_CRLF+',:occu'
          +_CRLF+',:annee_naissance'
          +_CRLF+',:annee_deces'
          +_CRLF+',:date_naissance'
          +_CRLF+',:date_deces'
          +_CRLF+',:subd_naissance'
          +_CRLF+',:subd_deces'
          +_CRLF+',:ville_naissance'
          +_CRLF+',:ville_deces'
          +_CRLF+',:dept_naissance'
          +_CRLF+',:dept_deces'
          +_CRLF+',:region_naissance'
          +_CRLF+',:region_deces'
          +_CRLF+',:pays_naissance'
          +_CRLF+',:pays_deces'
          +_CRLF+' do suspend;'
          +_CRLF+'delete from tq_anc;end';
  var
    fModeTemoins:boolean;

  begin
    fModeTemoins:=not sbDesc.Checked;
    Result:=False;
    with Q do
      Begin
        ParamCheck:=False;
        SQL.Text:=fs_filter (req1);
        if fModeTemoins then
          SQL.Add(fs_filter (reqt1));
        SQL.Add(fs_filter (req2));
        if fModeTemoins then
          SQL.Add(fs_filter (reqt2));
        SQL.Add(fs_filter (req3));
        if ( loCodeDept in PaintLink.Options ) then
          SQL.Add(',coalesce(substring(n.ev_ind_insee from 1 for 2)'
            +_CRLF+' ,n.ev_ind_Dept)'
            +_CRLF+',coalesce(substring(d.ev_ind_insee from 1 for 2)'
            +_CRLF+' ,d.ev_ind_Dept)')
        else
          SQL.Add(',n.ev_ind_Dept'
            +_CRLF+',d.ev_ind_Dept');
        SQL.Add(fs_filter (req4));
        IBTransactionPropre.StartTransaction;
        ExecQuery;

        if Eof then
        begin
          MyMessageDlg(rs_Caption_These_persons_are_not_linked,mtInformation, [mbOK],Self);
          fCleIndi1:=-1;
        end
        else
          Result:=True;
      end;
  end;

  Function PreChargeParente:Boolean;
  begin
    with q do
     Begin
      ParamCheck:=False;
      SQL.Text:=fs_filter('execute block'
        +_CRLF+'returns (niveau_1 integer,niveau_2 integer) '
        +_CRLF+'as '
        +_CRLF+'declare variable commun integer;'
        +_CRLF+'declare variable enfant_1 integer;'
        +_CRLF+'declare variable enfant_2 integer;'
        +_CRLF+'declare variable pere integer;'
        +_CRLF+'declare variable mere integer;'
        +_CRLF+'declare variable k smallint;'
        +_CRLF+'declare variable i_count smallint;'
        +_CRLF+'declare variable indip integer;'
        +_CRLF+'declare variable indim integer;'
        +_CRLF+'declare variable enfant integer;'
        +_CRLF+'declare variable ascendant integer;'
        +_CRLF+'declare variable trouve smallint;'
        +_CRLF+'begin '
        +_CRLF+'pere=indi1;'
        +_CRLF+'mere=indi2;'
        +_CRLF+'if (pere=0 or pere is null or mere=0 or mere is null) then '
        +_CRLF+'begin'
        +_CRLF+' exit;'
        +_CRLF+'end '
        +_CRLF+'if (pere=mere) then '
        +_CRLF+'begin'
        +_CRLF+' exit;'
        +_CRLF+'end '
        +_CRLF+'k=0;'
        +_CRLF+'insert into tq_anc (decujus,niveau,indi,enfant) values(:pere,:k,:pere,0);'
        +_CRLF+'insert into tq_anc (decujus,niveau,indi,enfant) values(:mere,:k,:mere,0);'
        +_CRLF+'i_count=1;'
        +_CRLF+'trouve=0;'
        +_CRLF+'while ((i_count>0)and(trouve=0)) do '
        +_CRLF+'begin'
        +_CRLF+' i_count=0;'
        +_CRLF+' for select ind.cle_pere,ind.cle_mere,tq.indi,tq.decujus'
        +_CRLF+'  from tq_anc tq'
        +_CRLF+'  inner join individu ind on ind.cle_fiche=tq.indi'
        +_CRLF+'  where tq.niveau=:k'
        +_CRLF+' into :indip,:indim,:enfant,:ascendant'
        +_CRLF+' do'
        +_CRLF+' begin'
        +_CRLF+'  if ((trouve=0)and(:indip>0)) then'
        +_CRLF+'  begin'
        +_CRLF+'   if (not exists (select 1 from tq_anc where decujus=:ascendant and indi=:indip)) then'
        +_CRLF+'   begin'
        +_CRLF+'    insert into tq_anc (decujus,niveau,indi,enfant) values(:ascendant,:k+1,:indip,:enfant);'
        +_CRLF+'    i_count=1;'
        +_CRLF+'    for select first(1) indi'
        +_CRLF+'     ,iif(:ascendant=:pere,:enfant,enfant)'
        +_CRLF+'     ,iif(:ascendant=:pere,:k+1,niveau)'
        +_CRLF+'     ,iif(:ascendant=:mere,:enfant,enfant)'
        +_CRLF+'     ,iif(:ascendant=:mere,:k+1,niveau)'
        +_CRLF+'    from tq_anc'
        +_CRLF+'    where decujus<>:ascendant and indi=:indip'
        +_CRLF+'    into :commun,:enfant_1,:niveau_1,:enfant_2,:niveau_2'
        +_CRLF+'    do trouve=1;'
        +_CRLF+'   end'
        +_CRLF+'  end'
        +_CRLF+'  if ((trouve=0)and(:indim>0)) then'
        +_CRLF+'  begin'
        +_CRLF+'   if (not exists (select 1 from tq_anc where decujus=:ascendant and indi=:indim)) then'
        +_CRLF+'   begin'
        +_CRLF+'    insert into tq_anc (decujus,niveau,indi,enfant) values(:ascendant,:k+1,:indim,:enfant);'
        +_CRLF+'    i_count=1;'
        +_CRLF+'    for select first(1) indi'
        +_CRLF+'      ,iif(:ascendant=:pere,:enfant,enfant)'
        +_CRLF+'      ,iif(:ascendant=:pere,:k+1,niveau)'
        +_CRLF+'      ,iif(:ascendant=:mere,:enfant,enfant)'
        +_CRLF+'      ,iif(:ascendant=:mere,:k+1,niveau)'
        +_CRLF+'    from tq_anc'
        +_CRLF+'    where decujus<>:ascendant and indi=:indim'
        +_CRLF+'    into :commun,:enfant_1,:niveau_1,:enfant_2,:niveau_2'
        +_CRLF+'    do trouve=1;'
        +_CRLF+'   end'
        +_CRLF+'  end'
        +_CRLF+' end'
        +_CRLF+' k=k+1;'
        +_CRLF+'end '
        +_CRLF+'if (trouve=1) then '
        +_CRLF+'begin'
        +_CRLF+' pere=commun;'
        +_CRLF+' insert into tq_id (id1,id2) values(:pere,0);'
        +_CRLF+' enfant=enfant_1;'
        +_CRLF+' k=0;'
        +_CRLF+' while (enfant>0) do'
        +_CRLF+' begin'
        +_CRLF+'  k=k-1;'
        +_CRLF+'  insert into tq_id (id1,id2) values (:enfant,:k);'
        +_CRLF+'  select enfant from tq_anc where indi=:enfant'
        +_CRLF+'  into :enfant;'
        +_CRLF+' end'
        +_CRLF+' enfant=enfant_2;'
        +_CRLF+' k=0;'
        +_CRLF+' while (enfant>0) do'
        +_CRLF+' begin'
        +_CRLF+'  k=k+1;'
        +_CRLF+'  insert into tq_id (id1,id2) values (:enfant,:k);'
        +_CRLF+'  select enfant from tq_anc where indi=:enfant'
        +_CRLF+'  into :enfant;'
        +_CRLF+' end'
        +_CRLF+' suspend;'
        +_CRLF+'end '
        +_CRLF+'end');
      IBTransactionPropre.StartTransaction;
  //    MyMessageDlg(sql.text,mtInformation, [mbOK],5,TForm(Owner));
  //    ParamByName('indi1').AsInteger:=fCleIndi1;
  //    ParamByName('indi2').AsInteger:=fCleIndi2;
      ExecQuery;
      Result:=False;
      if Eof then
      begin
        MyMessageDlg(rs_Caption_These_persons_have_no_mixed_ancestor,mtInformation, [mbOK],Self);
        fCleIndi1:=-1;
      end
      else
      begin
        Result:=True;
        sniveau1:=Fields[0].AsString;
        sniveau2:=Fields[1].AsString;
      end;
      if Result then
      begin
        Close;
        SQL.Text:='select t.id1 as indi'
          +_CRLF+',i.nom'
          +_CRLF+',i.prenom'
          +_CRLF+',i.sexe'
          +_CRLF+',case when i.num_sosa>0 then 1 else 0 end as sosa'
          +_CRLF+',case when t.id2<0 then 1 else 3 end as lien'
          +_CRLF+',(SELECT first(1) ev_ind_description from evenements_ind'
          +_CRLF+'  where ev_ind_type=''OCCU'' and ev_ind_kle_fiche=t.id1'
          +_CRLF+'  order by ev_ind_ordre desc,ev_ind_datecode desc) as occu'
          +_CRLF+',i.annee_naissance'
          +_CRLF+',i.annee_deces'
          +_CRLF+',i.date_naissance'
          +_CRLF+',i.date_deces'
          +_CRLF+',n.ev_ind_subd as subd_naissance'
          +_CRLF+',d.ev_ind_subd as subd_deces'
          +_CRLF+',n.ev_ind_ville as ville_naissance'
          +_CRLF+',d.ev_ind_ville as ville_deces';
        if loCodeDept in PaintLink.Options then
          SQL.Add(',coalesce(substring(n.ev_ind_insee from 1 for 2)'
            +_CRLF+' ,n.ev_ind_Dept)as dept_naissance'
            +_CRLF+',coalesce(substring(d.ev_ind_insee from 1 for 2)'
            +_CRLF+' ,d.ev_ind_Dept)as dept_naissance')
        else
        SQL.Add(',n.ev_ind_Dept as dept_naissance'
          +_CRLF+',d.ev_ind_Dept as dept_deces');
        SQL.Add(',n.ev_ind_region as region_naissance'
          +_CRLF+',d.ev_ind_region as region_deces'
          +_CRLF+',n.ev_ind_pays as pays_naissance'
          +_CRLF+',d.ev_ind_pays as pays_deces'
          +_CRLF+' from tq_id t inner join individu i on i.cle_fiche=t.id1'
          +_CRLF+' left join evenements_ind n on n.ev_ind_type=''BIRT'' and n.ev_ind_kle_fiche=t.id1'
          +_CRLF+' left join evenements_ind d on d.ev_ind_type=''DEAT'' and d.ev_ind_kle_fiche=t.id1'
          +_CRLF+' order by t.id2');
        ExecQuery;
      end;
     end;
  end;

var
  Niveau,Colonne,n,i:Integer;
  indi:TPersonLink;
  CurseurSauve:TCursor;
  ns,ds:array of string;
  bModeParente:Boolean;
  procedure p_AddRecords;
  Begin
    with GraphLinkData,q do
      while not Eof do
        begin
          indi:=TPersonLink.create;
          n:=Persons.Add(indi);
          with indi do
            Begin
              KeyPerson:=FieldByName('indi').AsInteger;
              Sexe:=FieldByName('sexe').AsInteger;
              FTexts [ ltLastName ]:=FieldByName('nom').AsString;
              FTexts [ ltJob ]:=FieldByName('occu').AsString;
              FTexts [ ltName ]:=FieldByName('prenom').AsString;
              FTexts [ ltBirthDay]:=FieldByName('date_naissance').AsString;
              FTexts [ ltDeathDay]:=FieldByName('date_deces').AsString;
              NumSosa:=FieldByName('sosa').AsInteger;
              Link:=FieldByName('lien').AsInteger;
              i:=0;
              if loSubD in PaintLink.Options then
                begin
                  ns[i]:=FieldByName('subd_naissance').AsString;
                  ds[i]:=FieldByName('subd_deces').AsString;
                  inc(i);
                end;
              if loCities in PaintLink.Options then
                begin
                  ns[i]:=FieldByName('ville_naissance').AsString;
                  ds[i]:=FieldByName('ville_deces').AsString;
                  inc(i);
                end;
              if [loCodeDept,loNameDept] * PaintLink.Options <> [] then
                begin
                  ns[i]:=FieldByName('dept_naissance').AsString;
                  ds[i]:=FieldByName('dept_deces').AsString;
                  inc(i);
                end;
              if loRegion in PaintLink.Options then
                begin
                  ns[i]:=FieldByName('region_naissance').AsString;
                  ds[i]:=FieldByName('region_deces').AsString;
                  inc(i);
                end;
              if loCountry in PaintLink.Options then
                begin
                  ns[i]:=FieldByName('pays_naissance').AsString;
                  ds[i]:=FieldByName('pays_deces').AsString;
                end;
              FTexts [ ltBirthCity ]:=AssembleString(ns);
              FTexts [ ltDeathCity ]:=AssembleString(ds);

              if Link=7 then
                LetterS:='T';

              if n=0 then //le premier
              begin
                if bModeParente then
                  fNomIndiComplet:='Parenté'
                else
                  fNomIndiComplet:='Liens';
                fNomIndiComplet:=fNomIndiComplet+_CRLF+' entre '+AssembleString([indi.FTexts [ ltLastName ],FTexts [ ltName ]])+_CRLF+' '
                  +GetStringNaissanceDeces(FieldByName('annee_naissance').AsString
                  ,FieldByName('annee_deces').AsString);
                Level:=0;
                Colonne:=0;
              end
              else
              begin
                case TPersonLink(Persons[n-1]).Link of
                  1,2:dec(Niveau);//c'est un ascendant du précédent
                  3,4:inc(Niveau);//c'est un descendant du précédent
                  5,6,7:Colonne:=Colonne+1;//c'est un conjoint ou a eu le précédent comme témoin
                  8:
                    begin//il a été témoin du précédent
                      Colonne:=Colonne+1;
                      LetterE:='T';
                    end;
                end;
                if (n>1) and (Niveau=TPersonLink(Persons[n-2]).Level)and(Colonne=TPersonLink(Persons[n-2]).Colonne) then
                  begin
                    TPersonLink(Persons[n-1]).Colonne:=TPersonLink(Persons[n-1]).Colonne+0.5;
                    Colonne:=Colonne+1;
                  end;
                Level:=Niveau;
                Colonne:=Colonne;
              end;
            end;

          next;
        end;

  end;

begin
  result:=true;
  CurseurSauve:=Screen.Cursor;
  Screen.Cursor:=crSQLWait;
  Application.ProcessMessages;
  fNomIndiComplet:='';
  with GraphLinkData do
    Begin
      Persons.Clear;
      bModeParente:=not sbDesc.Visible;
      try
        IBTransactionPropre:=TIBTransaction.Create(Application);
        IBTransactionPropre.Params.Add('read_committed');
        IBTransactionPropre.Params.Add('rec_version');
        IBTransactionPropre.Params.Add('nowait');
//        IBTransactionPropre.AutoStopAction:=saCommit;
        IBTransactionPropre.DefaultAction:=TACommit;
        IBTransactionPropre.DefaultDatabase:=dm.ibd_BASE;
        //On charge les individus
        Q:=TIBSQL.Create(Application);//AL2009
        with q do
        try
          Database:=dm.ibd_BASE;
          Transaction:=IBTransactionPropre;
          try
            if bModeParente then
            begin
              if not PreChargeParente then
                exit;
            end
            else
            begin
              if not PreChargeLiens then
                exit;
            end;

            i:=0;
            if ( loSubD in PaintLink.Options ) then
              inc(i);
            if ( [ltDeathCity,ltBirthCity] * PaintLink.ShowText ) <> [] then
              inc(i);
            if ( [loCodeDept,loNameDept] * PaintLink.Options <> [] ) then
              inc(i);
            if ( loRegion in PaintLink.Options ) then
              inc(i);
            if ( loCountry in PaintLink.Options ) then
              inc(i);
            SetLength(ns,i);
            SetLength(ds,i);

            Niveau:=0;
            Colonne:=0;

            p_AddRecords;

            fNomIndiComplet:=fs_remplaceMsg ( rs_and,  [fNomIndiComplet,AssembleString([indi.FTexts [ ltLastName ],indi.FTexts [ ltName ]])])+_CRLF+' '
              +GetStringNaissanceDeces(FieldByName('annee_naissance').AsString
              ,FieldByName('annee_deces').AsString);//le dernier
            if bModeParente then
              fNomIndiComplet:=fNomIndiComplet+_CRLF+' :('+sniveau1+'-'+sniveau2+_CRLF+')degrés';

            Close;
          except
            on E:EIBError do
            begin
              result:=false;
              MyMessageDlg(rs_Error_while_loading_data+_CRLF+E.Message,mtError, [mbCancel]);
              dm.IBT_BASE.RollbackRetaining;
            end;
          end;
        finally
          Free;
          IBTransactionPropre.Commit;
          IBTransactionPropre.Free;
        end;

        if result then
        begin
          i:=Maxint;
          for n:=0 to Persons.count-1 do //recherche du point le plus haut
          begin
            if TPersonLink(Persons[n]).Level<i then
              i:=TPersonLink(Persons[n]).Level;
          end;
          for n:=0 to Persons.count-1 do //repositioner le plus haut au niveau 0
          begin
            TPersonLink(Persons[n]).Level:=TPersonLink(Persons[n]).Level-i;
          end;
        end;
      finally
        Screen.Cursor:=CurseurSauve;
      end;
    end;
end;

function TFGraphPaintBox.LoadArc:boolean;
var
  k,alevel,CleFiche:integer;
  indi,indiParent:TPersonArc;
  Q:TIBSQL;
begin
  result:=true;
  with GraphArcData, PaintArc do
    Begin
      Persons.Clear;
      FirstPerson.Clear;
      Generations:=gci_context.RoueShowNbGeneration;
      //celui de départ
      Persons.Add(FirstPerson);

      //On charge les individus
      Q:=TIBSQL.Create(nil);
      with q do
      try
        Database:=dm.ibd_BASE;
        Transaction:=dm.IBT_BASE;
        SQL.Add('SELECT  t.tq_niveau as niveau'
          +_CRLF+',t.tq_cle_fiche as cle_fiche'
          +_CRLF+',i.CLE_PERE'
          +_CRLF+',i.CLE_MERE'
          +_CRLF+',i.NOM'
          +_CRLF+',i.PRENOM'
          +_CRLF+',i.SEXE'
          +_CRLF+',i.DATE_NAISSANCE'
          +_CRLF+',i.DATE_DECES'
          +_CRLF+',(select occupation from proc_dernier_metier(t.tq_cle_fiche))'
          +_CRLF+' FROM PROC_TQ_ASCENDANCE(:I_CLEF,:I_NIVEAU,0,0) t'
          +_CRLF+' inner join individu i on i.cle_fiche=t.tq_cle_fiche'
          +_CRLF+' ORDER BY t.tq_SOSA');
        ParamByName('I_CLEF').AsInteger:=KeyFirst;
        ParamByName('I_NIVEAU').AsInteger:=Generations-1;
        try
          ExecQuery;

          while not Eof do
          begin
            aLevel:=FieldByName('NIVEAU').AsInteger;
            CleFiche:=FieldByName('CLE_FICHE').AsInteger;

            if alevel=0 then
            begin
              indi:=FirstPerson;
              indi.idxOrder:=0;
              indi.idxPlotCenter:=1;
              indiParent:=nil;
              fNomIndiComplet:=fs_RemplaceMsg(rs_Ancestry_of,fs_getNameAndSurName(True,FieldByName(IBQ_NOM).AsString,FieldByName(IBQ_PRENOM).AsString));
          end
            else
            begin
                //le sexe ne peut-être que 1 ou 2
              if FieldByName('SEXE').AsInteger=1 then
                indiParent:=GetIndividuByClePere(CleFiche)
              else
                indiParent:=GetIndividuByCleMere(CleFiche);

              if indiParent<>nil then
              begin
                indi:=TPersonArc.create;
                Persons.Add(indi);
              end
              else
                indi:=nil;

            end;

            if indi<>nil then
            with indi do
            begin
                //1=Homme, 2=Femme
              Sexe:=FieldByName('SEXE').AsInteger;

              Angle:=0;
              KeyPerson:=CleFiche;
              level:=alevel;
              KeyFather:=FieldByName('CLE_PERE').AsInteger;
              KeyMother:=FieldByName('CLE_MERE').AsInteger;
              FTexts [ atLastName ]:=FieldByName('NOM').AsString;
              FTexts [ atJob ]:=FieldByName('OCCUPATION').AsString;
              FTexts [ atName ]:=FieldByName('PRENOM').AsString;
              FTexts [ atBirthDay ]:=FieldByName('DATE_NAISSANCE').AsString;
              FTexts [ atDeathDay ]:=FieldByName('DATE_DECES').AsString;

              if indiParent<>nil then
              begin
                k:=indiParent.Childs.Add(indi);
                idxOrder:=(indiParent.idxOrder*2)+k;
                idxPlotCenter:=(idxOrder*2)+1;
              end;
            end;

            next;
          end;
        except
          on E:EIBError do
          begin
            result:=false;
            MyMessageDlg(rs_Error_while_loading_data+_CRLF+E.Message,mtError,[mbCancel]);
            dm.IBT_BASE.RollbackRetaining;
          end;
        end;
      finally
        Free;
      end;

      if result then
        FirstPerson.Order;//on s'assure que les hommes sont Ã  droite, et les femmes Ã  gauche

    end;
end;


procedure TFGraphPaintBox.LoadDescendance;
var
  i,alevel,ordre,pere,mere:integer;
  indi,indiMere,indiTemp:TPersonTree;
  Q:TIBSQL;
  ns,ds,ms:array of string;

  function GetPere(Clef:string):TPersonTree;
  var
    n:integer;
  begin
    result:=nil;
    delete(Clef,length(Clef),1);
    with GraphTreeData do
    for n:=0 to Persons.count-1 do
    begin
      if TPersonTree(Persons[n]).FTexts[ttSOSA]=Clef then
      begin
        result:=TPersonTree(Persons[n]);
        break;
      end;
    end;
  end;

  procedure p_AddRecords;
  var li_i : Integer;
  Begin
    with GraphTreeData, PaintTree, q do
    while not Eof do
    begin
      if (FieldByName('niveau').AsInteger)>alevel then
      begin
        aLevel:=FieldByName('niveau').AsInteger;
        pere:=-1;
        mere:=-1;
      end;
      if (alevel>0)and ( ttMarriage in ShowText ) then
      begin
          if (FieldByName('tq_ascendant').AsInteger<>pere)
            or(FieldByName('cle_mere').AsInteger<>mere) then
          begin
            inc(ordre);
            pere:=FieldByName('tq_ascendant').AsInteger;
            mere:=FieldByName('cle_mere').AsInteger;
            indiMere:=TPersonTree.create;
            Persons.Add(indiMere);
            with indiMere do
              Begin
                Parent:=GetPere(FieldByName('tq_num_sosa').AsString);
                Sexe:=FieldByName('sexe_mere').AsInteger;
                if (Sexe=0)
                and assigned ( Parent ) then
                  Sexe:=3-Parent.Sexe;
                KeyPerson:=mere;
                Level:=alevel-1;
                NumSosa:=FieldByName('NUM_SOSA_mere').AsDouble;//AL2010
                FTexts [ ttLastName ]:=FieldByName('NOM_mere').AsString;
                FTexts [ ttName ]:=FieldByName('PRENOM_mere').AsString;
                FTexts [ ttJob ]:=FieldByName('metier_mere').AsString;
                FTexts [ ttSOSA ]:=FieldByName('ordre').AsString;
                FTexts [ ttBirthDay ]:=FieldByName('DATE_NAISSANCE_mere').AsString;
                FTexts [ ttDeathDay ]:=FieldByName('DATE_DECES_mere').AsString;
                FTexts [ ttNCHI     ]:=FieldByName('NCHI_mere').AsString;
                FTexts [ ttMarriage ]:=FieldByName('date_mariage').AsString;
                FAct   [ ttBirthCity ]:=PosIntDansListe(FieldByName('ActeNaissance_mere').AsInteger,ListeActeTrouve)>=0;
                FAct   [ ttDeathCity ]:=PosIntDansListe(FieldByName('ActeDeces_mere').AsInteger,ListeActeTrouve)>=0;
                FAct   [ ttMarriageCity ]:=PosIntDansListe(FieldByName('ActeMariage').AsInteger,ListeActeTrouve)>=0;
                i:=0;
                if toSubd in Options then
                  begin
                    ns[i]:=FieldByName('subd_naissance_mere').AsString;
                    ds[i]:=FieldByName('subd_deces_mere').AsString;
                    ms[i]:=FieldByName('subd_mariage').AsString;
                    inc(i);
                 end;
                if toCities in Options then
                  begin
                    ns[i]:=FieldByName('ville_naissance_mere').AsString;
                    ds[i]:=FieldByName('ville_deces_mere').AsString;
                    ms[i]:=FieldByName('ville_mariage').AsString;
                    inc(i);
                  end;
                if [toNameDept,toCodeDept] * Options <> [] then
                  begin
                    ns[i]:=FieldByName('dept_naissance_mere').AsString;
                    ds[i]:=FieldByName('dept_deces_mere').AsString;
                    ms[i]:=FieldByName('dept_mariage').AsString;
                    inc(i);
                  end;
                if toRegion in Options then
                  begin
                    ns[i]:=FieldByName('region_naissance_mere').AsString;
                    ds[i]:=FieldByName('region_deces_mere').AsString;
                    ms[i]:=FieldByName('region_mariage').AsString;
                    inc(i);
                  end;
                if toCountry in Options then
                  begin
                    ns[i]:=FieldByName('pays_naissance_mere').AsString;
                    ds[i]:=FieldByName('pays_deces_mere').AsString;
                    ms[i]:=FieldByName('pays_mariage').AsString;
                  end;
                FTexts [ ttBirthCity    ]:=AssembleString(ns);
                FTexts [ ttDeathCity    ]:=AssembleString(ds);
                FTexts [ ttMarriageCity ]:=AssembleString(ms);
                if assigned ( Parent ) Then
                  Parent.Childs.Add(indiMere);
                Maxlevel:=max(alevel-1,MaxLevel);
                FTexts [ ttSOSA ]:=IntToStr(-ordre);
               End;

          if indiMere.KeyPerson>0 then
            for li_i :=1 to Persons.Count-2 do
            begin
              indi:=TPersonTree(Persons[li_i]);
              if indi.KeyPerson=indiMere.KeyPerson then
              begin
                indiMere.Implexe:=indi.FTexts[ttSOSA];
                break;
              end;
            end;
          end;
      end;

      if FieldByName('CLE_FICHE').AsInteger>0 then
      begin
        if alevel=0 then
        begin
          indi:=FirstPerson;
          indi.Parent:=nil;
          fNomIndiComplet:=fs_RemplaceMsg(rs_Report_Descent_of,fs_getNameAndSurName(True,FieldByName(IBQ_NOM).AsString,FieldByName(IBQ_PRENOM).AsString));
        end
        else
        begin
          indi:=TPersonTree.create;
          Persons.Add(indi);
          if ttMarriage in ShowText then
              indi.Parent:=indiMere//avertissement ici, mais indiMere créé obligatoirement avant
          else
            indi.Parent:=GetPere(FieldByName('tq_num_sosa').AsString);
        end;

        inc(ordre);
        with indi do
          Begin
            Sexe:=FieldByName('SEXE').AsInteger;
            KeyPerson:=FieldByName('CLE_FICHE').AsInteger;
            Level:=alevel;
            FTexts [ ttLastName ]:=FieldByName('NOM').AsString;
            FTexts [ ttName ]:=FieldByName('PRENOM').AsString;
            FTexts [ ttNCHI ]:=FieldByName('NCHI').AsString;
            FTexts [ ttJob ]:=FieldByName('metier').AsString;
            FTexts [ ttBirthDay ]:=FieldByName('DATE_NAISSANCE').AsString;
            FTexts [ ttDeathDay ]:=FieldByName('DATE_DECES').AsString;
            FAct [ ttBirthDay ]:=PosIntDansListe(FieldByName('ActeNaissance').AsInteger,ListeActeTrouve)>=0;
            FAct [ ttDeathDay ]:=PosIntDansListe(FieldByName('ActeDeces').AsInteger,ListeActeTrouve)>=0;
            i:=0;
          if toSubd in Options then
            begin
              ns[i]:=FieldByName('subd_naissance').AsString;
              ds[i]:=FieldByName('subd_deces').AsString;
              inc(i);
            end;
          if toCities in Options then
            begin
              ns[i]:=FieldByName('ville_naissance').AsString;
              ds[i]:=FieldByName('ville_deces').AsString;
              inc(i);
            end;
            if [toCodeDept,toNameDept] * Options <> [] then
            begin
              ns[i]:=FieldByName('dept_naissance').AsString;
              ds[i]:=FieldByName('dept_deces').AsString;
              inc(i);
            end;
            if toRegion in Options then
            begin
              ns[i]:=FieldByName('region_naissance').AsString;
              ds[i]:=FieldByName('region_deces').AsString;
              inc(i);
            end;
            if toCountry in Options then
            begin
              ns[i]:=FieldByName('pays_naissance').AsString;
              ds[i]:=FieldByName('pays_deces').AsString;
            end;
            FTexts [ ttBirthCity ]:=AssembleString(ns);
            FTexts [ ttDeathDay ]:=AssembleString(ds);

            FTexts [ ttSOSA ]:=FieldByName('tq_num_sosa').AsString;//AL2009
            NumSosa:=FieldByName('NUM_SOSA').AsDouble;//AL2010
            Implexe:=FieldByName('tq_sosa').AsString;
            if Implexe='' then
              for li_i:=1 to Persons.Count-2 do
              begin
                indiTemp:=TPersonTree(Persons[li_i]);
                if KeyPerson=indiTemp.KeyPerson then
                begin
                  Implexe:=indiTemp.FTexts [ ttSOSA ];
                  break;
                end;
              end;

            if Parent<>nil then
              Parent.Childs.Add(indi);
            MaxLevel:=alevel;
          end;
      end;
      next;
    end;

  end;

begin
  with GraphTreeData, PaintTree do
    Begin
      Persons.Clear;
      FirstPerson.Clear;

      //celui de départ
      Persons.Add(FirstPerson);

      //On charge les individus
      Q:=TIBSQL.Create(Application);//AL2009
      with q do
      try
        Database:=dm.ibd_BASE;
        Transaction:=dm.IBT_BASE;
        ParamCheck:=false;
        SQL.Add('execute block as'
          +_CRLF+' declare variable i_clef integer;'
          +_CRLF+'declare variable i_niveau integer;'
          +_CRLF+'declare variable i_count integer;'
          +_CRLF+'declare variable i integer;'
          +_CRLF+'declare variable j integer;'
          +_CRLF+'declare variable i_num_sosa varchar(120);'
          +_CRLF+'declare variable i_fiche integer;'
          +_CRLF+'declare variable i_pere integer;'
          +_CRLF+'declare variable i_mere integer;'
          +_CRLF+'declare variable sj char(1);'
          +_CRLF+'begin'
          +_CRLF+' i=1;'
          +_CRLF+'i_clef='+IntToStr(KeyFirst)+_CRLF+';'
          +_CRLF+'i_niveau='+IntToStr(Generations)+_CRLF+';'
          +_CRLF+'delete from tq_arbredescendant;'
          +_CRLF+'insert into tq_arbredescendant'
          +_CRLF+'(tq_niveau,tq_cle_fiche,tq_num_sosa,tq_cle_pere,tq_cle_mere)'
          +_CRLF+'select 1,:i_clef,''1'',cle_pere,cle_mere'
          +_CRLF+' from individu where cle_fiche=:i_clef;'
          +_CRLF+'select count(0) from tq_arbredescendant where tq_niveau=:i into :i_count;'
          +_CRLF+'if (i_niveau=1) then i_count=0;'
          +_CRLF+'while (i_count>0) do'
          +_CRLF+' begin'
          +_CRLF+' i_count=0;'
          +_CRLF+'for select tq_cle_fiche,tq_num_sosa from tq_arbredescendant'
          +_CRLF+' where tq_niveau=:i and tq_sosa is null and tq_cle_fiche is not null '
          +_CRLF+' order by tq_num_sosa'
          +_CRLF+' into :i_clef,:i_num_sosa'
          +_CRLF+' do'
          +_CRLF+' begin'
          +_CRLF+' j=0;'
          +_CRLF+'for select i.cle_fiche,i.cle_pere,i.cle_mere'
          +_CRLF+' from individu i'
          +_CRLF+' left join evenements_ind ev on ev.ev_ind_kle_fiche=i.cle_fiche'
          +_CRLF+' where (i.cle_pere=:i_clef or i.cle_mere=:i_clef)'
          +_CRLF+' group by i.cle_fiche,i.cle_pere,i.cle_mere,i.cle_parents'
          +_CRLF+' order by i.cle_parents,min(ev.ev_ind_datecode)'
          +_CRLF+' into :i_fiche,:i_pere,:i_mere'
          +_CRLF+' do'
          +_CRLF+' begin'
          +_CRLF+' j=j+1;'
          +_CRLF+'if (j<10) then sj=cast(j as char(1));'
          +_CRLF+'else sj=ascii_char(j+55);'
          +_CRLF+'insert into tq_arbredescendant(tq_niveau,tq_cle_fiche,tq_num_sosa,tq_cle_pere,tq_cle_mere,tq_sosa,tq_ascendant)'
          +_CRLF+'values(:i+1,:i_fiche,:i_num_sosa||:sj,:i_pere,:i_mere,'
          +_CRLF+'(select tq_num_sosa from tq_arbredescendant where tq_cle_fiche=:i_fiche and tq_sosa is null),:i_clef);'
          +_CRLF+'i_count=1;'
          +_CRLF+'end');
        if ttMarriage in ShowText then
          SQL.Add('for select u.union_mari,u.union_femme from t_union u'
            +_CRLF+' where :i_clef in(u.union_mari,u.union_femme)'
            +_CRLF+' and u.union_mari is not null'
            +_CRLF+' and u.union_femme is not null'
            +_CRLF+' into :i_pere,:i_mere do'
            +_CRLF+' begin'
            +_CRLF+' if (not exists(select 1 from tq_arbredescendant where tq_niveau=:i+1'
            +_CRLF+' and tq_cle_pere=:i_pere and tq_cle_mere=:i_mere and tq_ascendant=:i_clef)) then'
            +_CRLF+' insert into tq_arbredescendant (tq_niveau,tq_num_sosa,tq_cle_pere,tq_cle_mere,tq_ascendant)'
            +_CRLF+'values (:i+1,:i_num_sosa||''0'',:i_pere,:i_mere,:i_clef);'
            +_CRLF+'end');

        SQL.Add('end i=i+1;'
          +_CRLF+'if (i_niveau>1 and i=i_niveau) then i_count=0;'
          +_CRLF+'end'
          +_CRLF+' end');
        try
        ExecQuery;
        Close;
        SQL.Clear;


            SQL.Add('SELECT');
            if ttMarriage in ShowText then
              SQL.Add('(t.tq_niveau-1)*2 as niveau')
            else
              SQL.Add('t.tq_niveau-1 as niveau');//1
            SQL.Add(',t.tq_num_sosa' //2
              +_CRLF+',i.CLE_FICHE' //3
              +_CRLF+',i.NOM' //4
              +_CRLF+',i.PRENOM'//5
              +_CRLF+',i.SEXE'//6
              +_CRLF+',i.DATE_NAISSANCE' //7
              +_CRLF+',i.DATE_DECES'//8
              +_CRLF+',i.NUM_SOSA'//9
              +_CRLF+',case i.NCHI when 0 then ''SP'' else null end as NCHI'//10
              +_CRLF+',t.tq_sosa'//11
              +_CRLF+',t.tq_ascendant' //12
              +_CRLF+',(SELECT first(1) ev_ind_description as metier from evenements_ind' //13
              +_CRLF+'  where ev_ind_type=''OCCU'' and ev_ind_kle_fiche=i.cle_fiche'
              +_CRLF+'  order by ev_ind_ordre desc,ev_ind_datecode desc)'
              +_CRLF+',n.ev_ind_acte as actenaissance' //14
              +_CRLF+',d.ev_ind_acte as actedeces'); //15
            i:=0;
            if toSubD in Options then
              begin
                SQL.Add(',n.ev_ind_subd as subd_naissance'
                  +_CRLF+',d.ev_ind_subd as subd_deces');
                inc(i);
              end;
            if toCities in Options then
              begin
                SQL.Add(',n.ev_ind_Ville as Ville_naissance'
                  +_CRLF+',d.ev_ind_Ville as Ville_deces');
                inc(i);
              end;
            if [toNameDept,toCodeDept] * Options <> [] then
              begin
                if toNameDept in Options then
                  SQL.Add(',n.ev_ind_Dept as Dept_naissance'
                    +_CRLF+',d.ev_ind_Dept as Dept_deces')
                else
                  SQL.Add(',coalesce(substring(n.ev_ind_insee from 1 for 2)'
                    +_CRLF+',n.ev_ind_Dept) as Dept_naissance'
                    +_CRLF+',coalesce(substring(d.ev_ind_insee from 1 for 2)'
                    +_CRLF+',d.ev_ind_Dept) as Dept_deces');
                inc(i);
              end;
            if toRegion in Options then
              begin
                SQL.Add(',n.ev_ind_Region as Region_naissance'
                  +_CRLF+',d.ev_ind_Region as Region_deces');
                inc(i);
              end;
            if toCountry in Options then
              begin
                SQL.Add(',n.ev_ind_pays as pays_naissance'
                  +_CRLF+',d.ev_ind_pays as pays_deces');
                inc(i);
              end;
            SetLength(ns,i);
            SetLength(ds,i);
            SetLength(ms,i);

            if ttMarriage in ShowText then
            begin
              SQL.Add(',c.cle_fiche as cle_mere' //16
                +_CRLF+',c.nom as nom_mere'//17
                +_CRLF+',c.prenom as prenom_mere' //18
                +_CRLF+',c.sexe as sexe_mere'//19
                +_CRLF+',c.date_naissance as date_naissance_mere' //20
                +_CRLF+',c.DATE_DECES as date_deces_mere'//21
                +_CRLF+',c.NUM_SOSA as NUM_SOSA_mere'//AL2010 22
                +_CRLF+',case c.NCHI when 0 then ''SP'' else null end as NCHI_mere'//23
                +_CRLF+',nc.ev_ind_acte as actenaissance_mere' //24
                +_CRLF+',dc.ev_ind_acte as actedeces_mere' //25
                +_CRLF+',(SELECT first(1) ev_fam_date_writen from evenements_fam' //26
                +_CRLF+'  where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                +_CRLF+'  order by ev_fam_datecode,ev_fam_heure) as date_mariage'
                +_CRLF+',(SELECT first(1) ev_fam_acte from evenements_fam' //27
                +_CRLF+'  where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                +_CRLF+'  order by ev_fam_datecode,ev_fam_heure) as actemariage');

              if toSubd in Options then
                SQL.Add(',nc.ev_ind_subd as subd_naissance_mere'
                  +_CRLF+',dc.ev_ind_subd as subd_deces_mere'
                  +_CRLF+',(SELECT first(1) ev_fam_subd from evenements_fam'
                  +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                  +_CRLF+' order by ev_fam_datecode,ev_fam_heure) as subd_mariage');
              if toCities in Options then
                SQL.Add(',nc.ev_ind_Ville as Ville_naissance_mere'
                  +_CRLF+',dc.ev_ind_Ville as Ville_deces_mere'
                  +_CRLF+',(SELECT first(1) ev_fam_Ville from evenements_fam'
                  +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                  +_CRLF+' order by ev_fam_datecode,ev_fam_heure) as Ville_mariage');
              if [toNameDept,toCodeDept] * Options <> [] then
                if toNameDept in Options then
                  SQL.Add(',nc.ev_ind_Dept as Dept_naissance_mere'
                    +_CRLF+',dc.ev_ind_Dept as Dept_deces_mere'
                    +_CRLF+',(SELECT first(1) ev_fam_Dept from evenements_fam'
                    +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                    +_CRLF+' order by ev_fam_datecode,ev_fam_heure) as Dept_mariage')
                else
                  SQL.Add(',coalesce(substring(nc.ev_ind_insee from 1 for 2)'
                    +_CRLF+',nc.ev_ind_Dept) as Dept_naissance_mere'
                    +_CRLF+',coalesce(substring(dc.ev_ind_insee from 1 for 2)'
                    +_CRLF+',dc.ev_ind_Dept) as Dept_deces_mere'
                    +_CRLF+',coalesce((SELECT first(1) substring(ev_fam_insee from 1 for 2) from evenements_fam'
                    +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                    +_CRLF+' order by ev_fam_datecode,ev_fam_heure)'
                    +_CRLF+',(SELECT first(1) ev_fam_Dept from evenements_fam'
                    +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                    +_CRLF+' order by ev_fam_datecode,ev_fam_heure)) as Dept_mariage');
              if toRegion in Options then
                SQL.Add(',nc.ev_ind_Region as Region_naissance_mere'
                  +_CRLF+',dc.ev_ind_Region as Region_deces_mere'
                  +_CRLF+',(SELECT first(1) ev_fam_Region from evenements_fam'
                  +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                  +_CRLF+' order by ev_fam_datecode,ev_fam_heure) as Region_mariage');
              if toCountry in Options then
                SQL.Add(',nc.ev_ind_pays as pays_naissance_mere'
                  +_CRLF+',dc.ev_ind_pays as pays_deces_mere'
                  +_CRLF+',(SELECT first(1) ev_fam_pays from evenements_fam'
                  +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                  +_CRLF+' order by ev_fam_datecode,ev_fam_heure) as pays_mariage');

            SQL.Add(',(SELECT first(1) ev_ind_description as metier_mere from evenements_ind' //28
                +_CRLF+'  where ev_ind_type=''OCCU'' and ev_ind_kle_fiche=c.cle_fiche'
                +_CRLF+'  order by ev_ind_ordre desc,ev_ind_datecode desc)'
                +_CRLF+',left(t.tq_num_sosa,char_length(t.tq_num_sosa)-1)' //29
                +_CRLF+',(select ordre from proc_conjoints_ordonnes(t.tq_ascendant,1) where conjoint is not distinct from c.cle_fiche)' //30
                +_CRLF+' from tq_arbredescendant t'
                +_CRLF+' left join individu i on i.cle_fiche=t.tq_cle_fiche');
            end
            else
              SQL.Add('from tq_arbredescendant t'
                +_CRLF+' inner join individu i on i.cle_fiche=t.tq_cle_fiche');
            SQL.Add('left join evenements_ind n on n.ev_ind_type=''BIRT'' and n.ev_ind_kle_fiche=t.tq_cle_fiche'
              +_CRLF+' left join evenements_ind d on d.ev_ind_type=''DEAT'' and d.ev_ind_kle_fiche=t.tq_cle_fiche');

            if ttMarriage in ShowText then
              SQL.Add('left join individu c on c.cle_fiche in (t.tq_cle_pere,t.tq_cle_mere)'
                +_CRLF+' and c.cle_fiche<>t.tq_ascendant'
                +_CRLF+' left join evenements_ind nc on nc.ev_ind_type=''BIRT'' and nc.ev_ind_kle_fiche=c.cle_fiche'
                +_CRLF+' left join evenements_ind dc on dc.ev_ind_type=''DEAT'' and dc.ev_ind_kle_fiche=c.cle_fiche'
                +_CRLF+' left join t_union u on (u.union_mari=t.tq_cle_pere and u.union_femme=t.tq_cle_mere)'
                +_CRLF+' ORDER BY t.tq_niveau,'+IntToStr(29+5*i)+_CRLF+','+IntToStr(30+5*i)+_CRLF+',t.tq_num_SOSA')
            else
              SQL.Add('ORDER BY t.tq_niveau,t.tq_num_SOSA');

        ExecQuery;

        alevel:=-1;
        ordre:=0;
        pere:=-1;
        mere:=-1;

        p_AddRecords;

        except
          on E: EIBError do
            begin
              MyMessageDlg(rs_Error_while_loading_data+_CRLF+E.Message,mtError,[mbCancel]);
              dm.IBT_BASE.RollbackRetaining;
            end;
        end;
      finally
        Free;
      end;

      //On équilibre les têtes
      Order;

    end;
end;

function TFGraphPaintBox.LoadTree:boolean;
var
  llevel,n,i:integer;
  indi:TPersonTree;
  Q:TIBSQL;
  CurseurSauve:TCursor;
  s:string;
  ns,ds,ms:array of string;
begin
  result:=true;
  CurseurSauve:=Screen.Cursor;
  Screen.Cursor:=crSQLWait;
  with GraphTreeData, PaintTree do
    Begin
      Persons.Clear;
      FirstPerson.Clear;
      Generations:=gci_context.ArbreShowNbGeneration;
      if gci_context.ArbreDescendance
       Then Options:=Options+[toDescent]
       Else Options:=Options-[toDescent];

      if toDescent in Options then
      begin
        try
          LoadDescendance;
        finally
          Screen.Cursor:=CurseurSauve;
        end;
        exit;
      end;

      //celui de départ
      Persons.Add(FirstPerson);
      i:=0;
      //On charge les individus
      Q:=TIBSQL.Create(Application);//AL2009
      with q do
      try
        Database:=dm.ibd_BASE;
        Transaction:=dm.IBT_BASE;
        ParamCheck:=false;
        SQL.Add('SELECT t.niveau'
            +_CRLF+',t.ordre'
            +_CRLF+',t.indi'
            +_CRLF+',i.NOM'
            +_CRLF+',i.PRENOM'
            +_CRLF+',i.SEXE'
            +_CRLF+',i.DATE_NAISSANCE'
            +_CRLF+',i.DATE_DECES'
            +_CRLF+',i.NUM_SOSA'
            +_CRLF+',t.IMPLEXE'
            +_CRLF+',t.enfant');

            if toCities in Options then
             Begin
              if toSubd in Options then
                begin
                  SQL.Add(',n.ev_ind_subd as subd_naissance'
                    +_CRLF+',d.ev_ind_subd as subd_deces'
                    +_CRLF+',(SELECT first(1) ev_fam_subd from evenements_fam'
                    +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                    +_CRLF+' order by ev_fam_datecode,ev_fam_heure) as subd_mariage');
                  inc(i);
                end;
              if [ttBirthCity,ttDeathCity] * ShowText <> [] then
                begin
                  SQL.Add(',n.ev_ind_Ville as Ville_naissance'
                    +_CRLF+',d.ev_ind_Ville as Ville_deces'
                    +_CRLF+',(SELECT first(1) ev_fam_Ville from evenements_fam'
                    +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                    +_CRLF+' order by ev_fam_datecode,ev_fam_heure) as Ville_mariage');
                  inc(i);
                end;
              if [toNameDept,toCodeDept] * Options <> [] then
                begin
                  if toNameDept in Options then
                    SQL.Add(',n.ev_ind_Dept as Dept_naissance'
                      +_CRLF+',d.ev_ind_Dept as Dept_deces'
                      +_CRLF+',(SELECT first(1) ev_fam_Dept from evenements_fam'
                      +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                      +_CRLF+' order by ev_fam_datecode,ev_fam_heure) as Dept_mariage')
                  else
                    SQL.Add(',coalesce(substring(n.ev_ind_insee from 1 for 2)'
                      +_CRLF+',n.ev_ind_Dept) as Dept_naissance'
                      +_CRLF+',coalesce(substring(d.ev_ind_insee from 1 for 2)'
                      +_CRLF+',d.ev_ind_Dept) as Dept_deces'
                      +_CRLF+',coalesce((SELECT first(1) substring(ev_fam_insee from 1 for 2) from evenements_fam'
                      +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                      +_CRLF+' order by ev_fam_datecode,ev_fam_heure)'
                      +_CRLF+',(SELECT first(1) ev_fam_Dept from evenements_fam'
                      +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                      +_CRLF+' order by ev_fam_datecode,ev_fam_heure)) as Dept_mariage');
                  inc(i);
                end;
              if toRegion in Options then
                begin
                  SQL.Add(',n.ev_ind_Region as Region_naissance'
                    +_CRLF+',d.ev_ind_Region as Region_deces'
                    +_CRLF+',(SELECT first(1) ev_fam_Region from evenements_fam'
                    +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                    +_CRLF+' order by ev_fam_datecode,ev_fam_heure) as Region_mariage');
                  inc(i);
                end;
                if toCountry in Options then
                begin
                  SQL.Add(',n.ev_ind_pays as pays_naissance'
                    +_CRLF+',d.ev_ind_pays as pays_deces'
                    +_CRLF+',(SELECT first(1) ev_fam_pays from evenements_fam'
                    +_CRLF+' where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
                    +_CRLF+' order by ev_fam_datecode,ev_fam_heure) as pays_mariage');
                  inc(i);
                end;

             end;
          SetLength(ns,i);
          SetLength(ds,i);
          SetLength(ms,i);
          SQL.Add(',(SELECT first(1) ev_ind_description from evenements_ind'
            +_CRLF+'  where ev_ind_type=''OCCU'' and ev_ind_kle_fiche=t.indi'
            +_CRLF+'  order by ev_ind_ordre desc,ev_ind_datecode desc)'
            +_CRLF+',(SELECT first(1) ev_fam_date_writen from evenements_fam'
            +_CRLF+'  where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
            +_CRLF+'  order by ev_fam_datecode,ev_fam_heure) as mariage'
            +_CRLF+',n.ev_ind_acte as actenaissance'
            +_CRLF+',d.ev_ind_acte as actedeces'
            +_CRLF+',(SELECT first(1) ev_fam_acte from evenements_fam'
            +_CRLF+'  where ev_fam_type=''MARR'' and ev_fam_kle_famille=u.union_clef'
            +_CRLF+'  order by ev_fam_datecode,ev_fam_heure) as actemariage'
            +_CRLF+' FROM PROC_ASCEND_ORDONNEE('+IntToStr(KeyFirst)+_CRLF+','+IntToStr(Generations-1)+_CRLF+',1) t'
            +_CRLF+' inner join individu i on i.cle_fiche=t.indi'
            +_CRLF+' left join evenements_ind n on n.ev_ind_type=''BIRT'' and n.ev_ind_kle_fiche=i.cle_fiche'
            +_CRLF+' left join evenements_ind d on d.ev_ind_type=''DEAT'' and d.ev_ind_kle_fiche=i.cle_fiche'
            +_CRLF+' left join t_union u on (u.union_mari=i.cle_pere and u.union_femme=i.cle_mere)'
            +_CRLF+' ORDER BY t.niveau,t.ordre');
          MaxLevel:=-1;
        try
        ExecQuery;

        llevel:=-1;
        while not Eof do
        begin
          llevel:=FieldByName('niveau').AsInteger;

          if llevel=0 then
          begin
            indi:=FirstPerson;
            fNomIndiComplet:=fs_RemplaceMsg(rs_Ancestry_of,fs_getNameAndSurName(True,FieldByName(IBQ_NOM).AsString,FieldByName(IBQ_PRENOM).AsString));
            indi.Parent:=nil;
          end
          else
          begin
            indi:=TPersonTree.create;
            Persons.Add(indi);
            s:=FieldByName('enfant').AsString;
            for n:=0 to Persons.count-1 do
              if TPersonTree(Persons[n]).FTexts [ ttSOSA ]=s then
              begin
                indi.Parent:=TPersonTree(Persons[n]);
                break;
              end;
          end;

          with indi do
           Begin
              Sexe:=FieldByName('SEXE').AsInteger;
              KeyPerson:=FieldByName('indi').AsInteger;
              Level:=llevel;
              FTexts [ ttLastName ]:=FieldByName('NOM').AsString;
              FTexts [ ttJob ]:=FieldByName('ev_ind_description').AsString;
              FTexts [ ttName ]:=FieldByName('PRENOM').AsString;
              FTexts [ ttBirthDay ]:=FieldByName('DATE_NAISSANCE').AsString;
              FTexts [ ttDeathDay ]:=FieldByName('DATE_DECES').AsString;
              FTexts [ ttSOSA ]:=FieldByName('ordre').AsString;//AL2009
              Implexe:=FieldByName('implexe').AsString;
              NumSosa:=FieldByName('NUM_SOSA').AsDouble;//AL2010
              FTexts [ ttMarriage ]:=FieldByName('MARIAGE').AsString;
              FAct [ ttBirthDay ]:=PosIntDansListe(FieldByName('ActeNaissance').AsInteger,ListeActeTrouve)>=0;
              FAct [ ttDeathDay ]:=PosIntDansListe(FieldByName('ActeDeces').AsInteger,ListeActeTrouve)>=0;
              FAct [ ttMarriage ]:=PosIntDansListe(FieldByName('ActeMariage').AsInteger,ListeActeTrouve)>=0;
              i:=0;
              if toCities in Options Then
               Begin
                if toSubd in Options then
                  begin
                    ns[i]:=FieldByName('subd_naissance').AsString;
                    ds[i]:=FieldByName('subd_deces').AsString;
                    ms[i]:=FieldByName('subd_mariage').AsString;
                    inc(i);
                  end;
                if [ttBirthCity,ttDeathCity] * ShowText <> [] then
                  begin
                    ns[i]:=FieldByName('ville_naissance').AsString;
                    ds[i]:=FieldByName('ville_deces').AsString;
                    ms[i]:=FieldByName('ville_mariage').AsString;
                    inc(i);
                  end;
                if [toCodeDept,toNameDept] * Options <> [] then
                  begin
                    ns[i]:=FieldByName('dept_naissance').AsString;
                    ds[i]:=FieldByName('dept_deces').AsString;
                    ms[i]:=FieldByName('dept_mariage').AsString;
                    inc(i);
                  end;
                if toRegion in Options then
                  begin
                    ns[i]:=FieldByName('region_naissance').AsString;
                    ds[i]:=FieldByName('region_deces').AsString;
                    ms[i]:=FieldByName('region_mariage').AsString;
                    inc(i);
                  end;
                if toCountry in Options then
                  begin
                    ns[i]:=FieldByName('pays_naissance').AsString;
                    ds[i]:=FieldByName('pays_deces').AsString;
                    ms[i]:=FieldByName('pays_mariage').AsString;
                  end;

                FTexts [ ttBirthCity ]:=AssembleString(ns);
                FTexts [ ttDeathDay ]:=AssembleString(ds);
                FTexts [ ttMarriageCity ]:=AssembleString(ms);
               end;

              if assigned ( Parent ) then
                Parent.Childs.Add(indi);

           end;

          next;
        end;
        MaxLevel:=llevel;
        except
          on E: EIBError do
            begin
              result:=false;
              MyMessageDlg(rs_Error_while_loading_data+_CRLF+E.Message,mtError,[mbCancel]);
              dm.IBT_BASE.RollbackRetaining;
            end;
        end;

        if result then
          Order;//On équilibre les têtes
      finally
        Destroy;
        Screen.Cursor:=CurseurSauve;
      end;

    end;
end;


{$WARNINGS ON}

procedure TFGraphPaintBox.popup_VoirLaFicheInBoxClick(Sender:TObject);
begin
  OpenFicheIndividuInBox(TMenuItem(Sender).Tag);
end;

procedure TFGraphPaintBox.mImprimercettepageClick(Sender:TObject);
begin
  p_PrintClick(False);
end;

procedure TFGraphPaintBox.sbDescClick(Sender:TObject);
begin
  if fTypeGraph='ARBRE' then
  begin
    EnableBtnRefresh;
    gci_context.ShouldSave:=true;
    gci_context.ArbreDescendance:=sbDesc.Checked;
    if sbDesc.Checked
      Then PaintTree.Options:=PaintTree.Options+[toDescent]
      Else PaintTree.Options:=PaintTree.Options-[toDescent];
  end
  else if fTypeGraph='LIENS' then
  begin
    if AppelDirectRefreshTout then //d?sactiver si changement d'individus
      RefreshTout;
  end;
end;

procedure TFGraphPaintBox.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  DefaultCloseAction:=caFree;
  Action:=caFree;
  if fTypeGraph='ARBRE' then
  begin
    DoSendMessage(Owner,'FERME_FORME_ARBRE_IMP');
  end
  else if fTypeGraph='ROUE' then
  begin
    DoSendMessage(Owner,'FERME_FORME_ROUE_IMP');
  end
  else if fTypeGraph='LIENS' then
  begin
    DoSendMessage(Owner,'FERME_FORME_LIENS_IMP');
  end
  else if fTypeGraph='PARENTE' then
  begin
    DoSendMessage(Owner,'FERME_FORME_PARENTE_IMP');
  end;
end;

procedure TFGraphPaintBox.btnSelectIndiGraphClick(Sender:TObject);
begin
  FMain.Show;
end;

procedure TFGraphPaintBox.PanReglagesExit(Sender:TObject);
begin
  PanReglages.Visible:=false;
end;

procedure TFGraphPaintBox.btnSetZoomAllClick(Sender:TObject);
begin
  Viewer.ZoomAll;
end;

procedure TFGraphPaintBox.btnSetMouseZoomLessClick(Sender:TObject);
begin
  Viewer.Zoom:=Viewer.Zoom-10;
//  Viewer.MouseMode:=mmZoomLess;
end;

procedure TFGraphPaintBox.TrackBarScroll(Sender:TObject;
  ScrollCode:TScrollCode;var ScrollPos:Integer);
begin
  if ScrollCode=scEndScroll then
    fZooming:=false;
end;

procedure TFGraphPaintBox.TrackBarChange(Sender:TObject);
begin
  if fFill.Value=False then
  begin
    fFill.Value:=True;
    try
      if fZooming=false then
      begin
        //On va zoomer avec comme point central, le centre du Viewer
        fZoomOnX_Viewer:=PaintTree.Width div 2;
        fZoomOnY_Viewer:=PaintTree.Height div 2;

        //Le point correspondant, en coord chantier est :
        Viewer.CoordViewer_To_CoordChantier(fZoomOnX_Viewer,fZoomOnY_Viewer,fZoomOnX_Chantier,fZoomOnY_Chantier);
      end;

      fZooming:=true;

      //Maintenant, on zoom, de fa?on à avoir, apr?s l'op?ration, le point central du zoom plac? au m?me endroit
      Viewer.ApplyZoomAtPoint(TrackBar.Position,fZoomOnX_Viewer,fZoomOnY_Viewer,fZoomOnX_Chantier,fZoomOnY_Chantier);
      Viewer.RefreshMiniature;
    finally
      fFill.Value:=false;
    end;
  end;
end;

procedure TFGraphPaintBox.DmarrerlarbredepuiscetindividuClick(
  Sender:TObject);
begin
  doSelectOtherIndividu(TMenuItem(Sender).Tag,false);
end;

procedure TFGraphPaintBox.OuvrirlafichedecetindividuClick(
  Sender:TObject);
var
  i,iSexe,iGene,iParent:integer;
  P:TPoint;
  sNom,sNaisDec:string;
begin
  if Sender is TMenuItem then
    i:=TMenuItem(Sender).Tag
  else
  begin
    P:=PaintTree.ScreenToClient(Mouse.CursorPos);
    i:=fGraph.GetCleIndividuAtXY(P.X,P.Y,sNom,sNaisDec,iSexe,iGene,iParent);//toujours -1 pour la roue
  end;
  if i>0 then
  begin
    dm.individu_clef:=i;
    DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
  end;
end;

procedure TFGraphPaintBox.cbInversionMouseUp(Sender:TObject;
  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  EnableBtnRefresh;
  gci_context.ShouldSave:=true;
  gci_context.ArbreInverse:=cbInversion.Checked;
  if Viewer.Graph=PaintTree Then
    if cbInversion.Checked
      Then PaintTree.Options:=PaintTree.Options+[toInverted]
      Else PaintTree.Options:=PaintTree.Options-[toInverted]
end;

procedure TFGraphPaintBox.SuperFormShow(Sender:TObject);
begin
  ActiveControl:=PanelPaintBox;
  p_SetPageSetup(PrintGraph.rp.PageSetup,cb_papersize.Text,ch_Portrait.Checked);
  MajApresPrinterSetup;
end;

procedure TFGraphPaintBox.PaintTreeDblClick(Sender:TObject);
begin
  OuvrirlafichedecetindividuClick(Sender);
end;

procedure TFGraphPaintBox.EnableBtnRefresh;
begin
  // Matthieu
  btnRefresh.Enabled:=True;
end;

procedure TFGraphPaintBox.DisableBtnRefresh;
begin
 // Matthieu
  btnRefresh.Enabled:=False;
end;

procedure TFGraphPaintBox.LReglagesClick(Sender:TObject);
begin
  PanReglages.Visible:=true;
  PanReglages.SetFocus;
end;

procedure TFGraphPaintBox.Panel5Click(Sender:TObject);
begin
  PanReglages.Visible:=false;
end;

procedure TFGraphPaintBox.lNaisDecClick(Sender:TObject);
begin
  PanReglages.Visible:=false;
end;

procedure TFGraphPaintBox.lNomClick(Sender:TObject);
begin
  PanReglages.Visible:=false;
end;

procedure TFGraphPaintBox.SuperFormClick(Sender:TObject);
begin
  PanReglages.Visible:=false;
end;

procedure TFGraphPaintBox.RefreshArbre;
begin
  PaintTree.Refresh;
end;


procedure TFGraphPaintBox.ViewerZoomChanged(Sender: TObject);
begin
  fFill.Value:=true;
  try
    lbZoom.Caption:=fs_RemplaceMsg(rs_Caption_Percent,[inttostr(Viewer.Zoom)]);
    TrackBar.Position:=Viewer.Zoom;
  finally
    fFill.Value:=false;
  end;
end;

end.

