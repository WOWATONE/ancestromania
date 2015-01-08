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

unit u_form_graph_config_roue;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  u_objet_graph_TViewer, Windows,
  JvXPCheckCtrls,JvXPButtons,
{$ELSE}
  ExtJvXPCheckCtrls,ExtJvXPButtons,
{$ENDIF}
  U_FormAdapt,u_comp_TYLanguage,Dialogs,
  StdCtrls,
  ExtCtrls,
  Classes, ComCtrls, u_objet_TState,Graphics, U_ExtColorCombos,
  u_ancestroviewer, u_ancestroarc,
  u_framework_components;

type

  { TFGraphConfigRoue }

  TFGraphConfigRoue=class(TF_FormAdapt)
    FontDialog:TFontDialog;
    pBorder:TPanel;
    Panel11:TPanel;
    Panel14:TPanel;
    Panel13:TPanel;
    Panel6:TPanel;
    Notebook:TPageControl;
    page1:TTabSheet;
    page2:TTabSheet;
    Label33:TLabel;
    Label34:TLabel;
    Label39:TLabel;
    Label40:TLabel;
    Label41:TLabel;
    edColorTexteHomme:TExtColorCombo;
    edColorTexteFemme:TExtColorCombo;
    FlaTCSpeedButton1:TJvXPButton;
    cNom:TJvXPCheckBox;
    cPrenom:TJvXPCheckBox;
    cProf:TJvXPCheckBox;
    cNaissance:TJvXPCheckBox;
    cDeces:TJvXPCheckBox;
    edLineHeight:TFWSpinEdit;
    panExempleFont:TPanel;
    Label3:TLabel;
    Label4:TLabel;
    Label5:TLabel;
    Label6:TLabel;
    Label7:TLabel;
    Label8:TLabel;
    Label9:TLabel;
    Label1:TLabel;
    edAngle:TFWSpinEdit;
    edRayon:TFWSpinEdit;
    edMargeLeft:TFWSpinEdit;
    edMargeTop:TFWSpinEdit;
    edColorCercle:TExtColorCombo;
    Label17:TLabel;
    Label18:TLabel;
    edColorRayon:TExtColorCombo;
    Label28:TLabel;
    Label29:TLabel;
    edDecalageIndiCentral:TFWSpinEdit;
    Language:TYLanguage;
    Label2:TLabel;
    edRecouvrementImpression:TFWSpinEdit;
    Label10:TLabel;
    procedure CaracteristiquesChange(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormDestroy(Sender:TObject);
    procedure SpeedButton1Click(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure onTabRoueChange(Sender:TObject);
    procedure onTabRoueDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
  private
    fFill:TState;
    RectMonitor:TRect;
    fOngletID:integer;
    FViewer : TGraphViewer;
    FGraphArc : TGraphArc;
    procedure ApplyChanges;
    procedure doActiveOnglet(onglet:integer);
  public
    constructor Create(Sender:TComponent);override;
    procedure InitView ( const AGraph : TGraphArc ); virtual;
  end;

implementation

uses u_common_functions,u_ancestro_strings,
     u_common_const,
     fonctions_init,
     Forms,
     u_genealogy_context;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFGraphConfigRoue.SuperFormShowFirstTime(Sender:TObject);
begin
  //Positionnement de la fenêtre en bas à droite du moniteur de la roue
  Top:=RectMonitor.Bottom-Height;
  Left:=RectMonitor.Right-Width;
  doActiveOnglet(0);
  Caption:=rs_Caption_Set_the_arc;
end;

procedure TFGraphConfigRoue.ApplyChanges;
begin
  if (fFill.Value=false)
  and Assigned(FGraphArc) then
  with FGraphArc do
  begin

    ColorCircle    :=edColorCercle.Value;
    ColorRadius     :=edColorRayon.Value;
    ColorTextMen   :=edColorTexteHomme.Value;
    ColorTextWomen :=edColorTexteFemme.Value;
    gci_context.ShouldSave:=true;
    ArcAngle:=edAngle.Value;
    ArcRadius:=edRayon.Value;
    MargeLeft:=edMargeLeft.Value;
    MargeTop:=edMargeTop.Value;
//    PaintArc.RoueRecouvrement:=edRecouvrementImpression.Value;
    Graph_RecouvrementImpression:=edRecouvrementImpression.Value;

    Font.Name:=FontToString(panExempleFont.Font);

    SetCheckShow ( atLastName, cNom.checked);
    SetCheckShow ( atName, cPrenom.checked);
    SetCheckShow ( atJob, cProf.checked);
    SetCheckShow ( atBirthDay,cNaissance .checked);
    SetCheckShow ( atDeathDay, cDeces.checked);

    LineHeight:=edLineHeight.Value;
    CenteredPersonShifting:=edDecalageIndiCentral.Value;

    ColorCircle:=edColorCercle.Value;
    ColorRadius:=edColorRayon.Value;

      //on rafraichit le graph
    fViewer.BeginUpdate;
    try
      {
      fViewer.PageWidth:=round(rm.rp.PageWidth-rm.rp.LeftWaste-rm.rp.RightWaste-edRecouvrementImpression.Value);
      fViewer.PageHeight:=round(rm.rp.PageHeight-rm.rp.TopWaste-rm.rp.BottomWaste-edRecouvrementImpression.Value);
      PtrGraph.Prepare;
       }
      fViewer.BuildZonesImpression;
      fViewer.BuildMiniature;
      fViewer.PrepareGraph;
    finally
      fViewer.EndUpdate;
    end;

    fViewer.Refresh;
    fViewer.RefreshMiniature;
    WriteSectionIni;
  end;
end;

procedure TFGraphConfigRoue.CaracteristiquesChange(Sender:TObject);
begin
  ApplyChanges;
end;

constructor TFGraphConfigRoue.Create(Sender:TComponent);
begin
  fFill:=TState.create(false);
  FGraphArc := nil;
  Inherited;
end;



procedure TFGraphConfigRoue.InitView ( const AGraph : TGraphArc );
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  panExempleFont.Color:=gci_context.ColorDark;
{  FlaTCSpeedButton1.ColorBorder:=gci_context.ColorLight;
  FlaTCSpeedButton1.ColorDown:=gci_context.ColorLight;
  FlaTCSpeedButton1.ColorFocused:=gci_context.ColorLight;
  FlaTCSpeedButton1.ColorHighlight:=gci_context.ColorLight;
  FlaTCSpeedButton1.ColorShadow:=gci_context.ColorLight;
 }
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  DefaultCloseAction:=caHide;
  fOngletID:=0;
  fViewer:=aGraph.Viewer;
  RectMonitor:=( aGraph.Owner as TCustomForm ).Monitor.WorkareaRect;
  fFill.Value:=true;
  FGraphArc:=AGraph;
  with FGraphArc do
  try
    ReadSectionIni;
    edAngle.Value:=ArcAngle;
    edRayon.Value:=ArcRadius;
    edMargeLeft.Value:=MargeLeft;
    edMargeTop.Value:=MargeTop;
    edRecouvrementImpression.Value:=gci_context.RoueRecouvrement;

    panExempleFont.Font.Assign(Font);
    edColorTexteHomme.Value:=ColorTextMen;
    edColorTexteFemme.Value:=ColorTextWomen;

    cNom.checked:=atLastName in ShowText;
    cPrenom.checked:=atName in ShowText;
    cProf.checked:=atJob in ShowText;
    cNaissance.checked:=atBirthDay in ShowText;
    cDeces.checked:=atDeathDay in ShowText;

    edLineHeight.Value:=LineHeight;
    edDecalageIndiCentral.Value:=CenteredPersonShifting;

    edColorCercle.Value:=ColorCircle;
    edColorRayon.Value:=ColorRadius;
  finally
    fFill.Value:=false;
  end;
end;

procedure TFGraphConfigRoue.SuperFormDestroy(Sender:TObject);
begin
  fFill.free;
end;

procedure TFGraphConfigRoue.SpeedButton1Click(Sender:TObject);
begin
  FontDialog.Font.Assign(panExempleFont.Font);
  if FontDialog.execute then
  begin
    panExempleFont.Font.Assign(FontDialog.Font);
    ApplyChanges;
  end;
end;

procedure TFGraphConfigRoue.doActiveOnglet(onglet:integer);
begin
  fOngletID:=onglet;
  Notebook.PageIndex:=onglet;
end;

procedure TFGraphConfigRoue.SuperFormKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  case Key of
    _KEY_HELP:p_ShowHelp(_ID_PRINT_ROUE);
  end;
end;

procedure TFGraphConfigRoue.onTabRoueChange(Sender:TObject);
begin
  doActiveOnglet((sender as TPanel).TabOrder);
end;

procedure TFGraphConfigRoue.onTabRoueDrawTabEx(
  AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  if ATab = ATab.PageControl.ActivePage then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
end;

end.
