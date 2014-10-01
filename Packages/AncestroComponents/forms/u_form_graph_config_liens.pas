{Création André Langlet décembre 2011}

unit u_form_graph_config_liens;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  u_objet_graph_TViewer, u_objet_TGraphLiens, Windows,
  JvXPButtons, JvXPCheckCtrls,
{$ELSE}
  LCLIntf, ExtJvXPCheckCtrls, ExtJvXPButtons,
{$ENDIF}
  U_FormAdapt, Dialogs,
  StdCtrls, U_ExtColorCombos,
  ExtCtrls,
  Controls, Classes, ComCtrls, Graphics,
  u_framework_components,
  u_ancestroviewer, u_ancestrolink,
  Menus, u_objet_TState;

type

  { TFGraphConfigLiens }

  TFGraphConfigLiens = class(TF_FormAdapt)
    cAvecLieu: TJvXPCheckbox;
    cbShowSosas: TJvXPCheckbox;
    cDeces: TJvXPCheckbox;
    cNaissance: TJvXPCheckbox;
    cNom: TJvXPCheckbox;
    cPaintFondRecFemme: TJvXPCheckbox;
    cPaintFondRecHomme: TJvXPCheckbox;
    cPrenom: TJvXPCheckbox;
    cProf: TJvXPCheckbox;
    edColorTexteFemme: TExtColorCombo;
    edColorTexteHomme: TExtColorCombo;
    edCouleurFondFemme: TExtColorCombo;
    edCouleurFondRectHomme: TExtColorCombo;
    edCouleurLiens: TExtColorCombo;
    edCouleurRectFemme: TExtColorCombo;
    edCouleurRectHomme: TExtColorCombo;
    edEspaceEntreGenerations: TFWSpinEdit;
    edEspaceEntreIndis: TFWSpinEdit;
    edHeightIndi: TFWSpinEdit;
    edLineHeight: TFWSpinEdit;
    edMargeLeft: TFWSpinEdit;
    edMargeTop: TFWSpinEdit;
    edRecouvrementImpression: TFWSpinEdit;
    edWidthIndi: TFWSpinEdit;
    FlaTCSpeedButton1: TJvXPButton;
    FontDialog: TFontDialog;
    Label1: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lCompositionLieu: TLabel;
    Notebook: TPageControl;
    page1: TTabSheet;
    page2: TTabSheet;
    page3: TTabSheet;
    page4: TTabSheet;
    page5: TTabSheet;
    page6: TTabSheet;
    page7: TTabSheet;
    page8: TTabSheet;
    page9: TTabSheet;
    mLieu: TPopupMenu;
    mAvecSubd: TMenuItem;
    mAvecVille: TMenuItem;
    mAvecDept: TMenuItem;
    mAvecRegion: TMenuItem;
    mAvecPays: TMenuItem;
    mAvecCodeDept: TMenuItem;
    mAvecNomDept: TMenuItem;
    Panel11: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel6: TPanel;
    panExempleFont: TPanel;
    pBorder: TPanel;
    procedure FormDeactivate(Sender: TObject);
    procedure SuperFormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SuperFormShowFirstTime(Sender: TObject);
    procedure onTabControl1Change(Sender: TObject);
    procedure onTabControl1DrawEx(AControl: TCustomTabControl;
      ATab: TTabSheet; Font: TFont);
    procedure ApplyChanges(Sender: TObject);
    procedure lCompositionLieuClick(Sender: TObject);
    procedure cAvecLieuClick(Sender: TObject);
    procedure menuChange(Sender: TObject);
    procedure lCompositionLieuMouseEnter(Sender: TObject);
    procedure lCompositionLieuMouseLeave(Sender: TObject);
    procedure cbShowSosasClick(Sender: TObject);

  private
    RectMonitor: TRect;
    fFill: TState;
    fOngletID: integer;
    FViewer: TGraphViewer;
    FLinksBox: TGraphLink;

    procedure doActiveOnglet(onglet: integer);
  public
    constructor Create(Sender:TComponent);override;
    procedure InitView ( const AGraph : TGraphLink ); virtual;
  end;

implementation

uses
  u_ancestro_strings,
  Forms,
  u_common_const, u_genealogy_context;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFGraphConfigLiens.InitView( const AGraph : TGraphLink );
begin
  OnShowFirstTime := SuperFormShowFirstTime;
  Color := gci_context.ColorLight;
{  FlaTCSpeedButton1.ColorShadow := gci_context.ColorLight;
  FlaTCSpeedButton1.ColorBorder := gci_context.ColorLight;
  FlaTCSpeedButton1.ColorFocused := gci_context.ColorLight;
  FlaTCSpeedButton1.ColorHighlight := gci_context.ColorLight;
  FlaTCSpeedButton1.ColorDown := gci_context.ColorLight;}
  panExempleFont.Color := gci_context.ColorDark;

  DefaultCloseAction:=caHide;

  fOngletID := 0;
  fViewer   := AGraph.Viewer;
  FLinksBox := AGraph;
  RectMonitor := (AGraph.Owner as TCustomForm).Monitor.WorkareaRect;

  fFill.Value := True;
  with FLinksBox do
  try
    ReadSectionIni;
    edHeightIndi.Value:=BoxHeight;
    edWidthIndi .Value:=BoxWidth;
    edMargeLeft.Value:=Viewer.ShiftX;
    edMargeTop .Value:=Viewer.ShiftY;
    edEspaceEntreGenerations.Value := SpaceGeneration;
    edEspaceEntreIndis.Value := SpacePerson;
    edRecouvrementImpression.Value := gci_context.LiensRecouvrement;

    panExempleFont.Font.Assign(Font);
    edColorTexteHomme.Value := ColorTextMan;
    edColorTexteFemme.Value := ColorTextWoman;

    cNom.Checked := ltLastName in ShowText;
    cPrenom.Checked := ltName in ShowText;
    cProf.Checked := ltJob in ShowText;
    cNaissance.Checked := ltBirthDay in ShowText;
    cDeces.Checked := ltDeathDay in ShowText;
    cbShowSosas.Checked := ltSOSA in ShowText;
    cAvecLieu.Checked := loCities in Options;
    mAvecSubd.Checked := loSubd in Options;
    mAvecVille.Checked := loCities in Options;
    mAvecCodeDept.Checked := loCodeDept in Options;
    mAvecNomDept.Checked := loNameDept in Options;
    mAvecRegion.Checked := loRegion in Options;
    mAvecPays.Checked := loCountry in Options;
    lCompositionLieu.Visible := loBourg in Options;

    edLineHeight.Value := LineHeight;

    edCouleurLiens.Value := ColorLinks;
    edCouleurRectHomme.Value := ColorRectMan;
    cPaintFondRecHomme.Checked := loPaintBackMen in Options;
    edCouleurFondRectHomme.Value := ColorBackMan;
    edCouleurRectFemme.Value := ColorRectWoman;
    cPaintFondRecFemme.Checked := loPaintBackWomen in Options;
    edCouleurFondFemme.Value := ColorBackWoman;
  finally
    fFill.Value := False;
  end;
end;

procedure TFGraphConfigLiens.SuperFormDestroy(Sender: TObject);
begin
  fFill.Free;
end;

procedure TFGraphConfigLiens.FormDeactivate(Sender: TObject);
begin
  ApplyChanges ( sender );
end;

constructor TFGraphConfigLiens.Create(Sender:TComponent);
begin
  fFill:=TState.create(false);
  FLinksBox := nil;
  Inherited;
end;

procedure TFGraphConfigLiens.SpeedButton1Click(Sender: TObject);
begin
  FontDialog.Font.Assign(panExempleFont.Font);

  if FontDialog.Execute then
  begin
    panExempleFont.Font.Assign(FontDialog.Font);
    ApplyChanges(Sender);
  end;
end;

procedure TFGraphConfigLiens.ApplyChanges(Sender: TObject);
begin
  if (fFill.Value = False)
  and Assigned(FLinksBox) then
  with FLinksBox do
  begin
    gci_context.ShouldSave := True;

    BoxHeight:=edHeightIndi.Value;
    BoxWidth :=edWidthIndi .Value;
    Viewer.ShiftX:=edMargeLeft.Value;
    Viewer.ShiftY:=edMargeTop .Value;
    SpaceGeneration := edEspaceEntreGenerations.Value;
    SpacePerson := edEspaceEntreIndis.Value;
    gci_context.LiensRecouvrement := edRecouvrementImpression.Value;
    Graph_RecouvrementImpression:= edRecouvrementImpression.Value;

    Font.Assign(panExempleFont.Font);
    ColorTextMan := edColorTexteHomme.Value;
    ColorTextWoman := edColorTexteFemme.Value;

    SetCheckShow ( ltLastname ,cNom.Checked);
    SetCheckShow ( ltname ,cPrenom.Checked);
    SetCheckShow ( ltJob ,cProf.Checked);
    SetCheckShow ( ltBirthDay ,cNaissance.Checked);
    SetCheckShow ( ltDeathDay ,cDeces.Checked);

    LineHeight   := edLineHeight.Value;

    ColorLinks := edCouleurLiens.Value;
    ColorRectMan := edCouleurRectHomme.Value;
    SetCheckOption ( loPaintBackMen ,cPaintFondRecHomme.Checked);
    ColorBackMan := edCouleurFondRectHomme.Value;
    ColorRectWoman := edCouleurRectFemme.Value;
    SetCheckOption ( loPaintBackWomen ,cPaintFondRecFemme.Checked);
    ColorBackWoman := edCouleurFondFemme.Value;

    //on rafraichit le graph
    fViewer.BeginUpdate;
    try
      if Sender = edRecouvrementImpression then
      begin
        { // Plus tard
        fViewer.PageWidth:=round(rm.rp.PageWidth-rm.rp.LeftWaste-rm.rp.RightWaste-edRecouvrementImpression.Value);
        fViewer.PageHeight:=round(rm.rp.PageHeight-rm.rp.TopWaste-rm.rp.BottomWaste-edRecouvrementImpression.Value);
        }
      end;
      //  else
      //        if Sender.ClassType<>TExtColorCombo then
      //        FViewer.Data.Prepare;

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

procedure TFGraphConfigLiens.SuperFormShowFirstTime(Sender: TObject);
begin
  //Positionnement de la fenêtre en bas à droite du moniteur de l'Liens
  Top := RectMonitor.Bottom - Height;
  Left := RectMonitor.Right - Width;
  Caption := rs_Caption_Parental_and_links_parameters;
  doActiveOnglet(0);
end;

procedure TFGraphConfigLiens.doActiveOnglet(onglet: integer);
begin
  fOngletID := onglet;
  Notebook.PageIndex := onglet;
end;

procedure TFGraphConfigLiens.onTabControl1Change(Sender: TObject);
begin
  doActiveOnglet((Sender as TPanel).TabOrder);
end;

procedure TFGraphConfigLiens.onTabControl1DrawEx(AControl: TCustomTabControl;
  ATab: TTabSheet; Font: TFont);
begin
  Font.Color := gci_context.ColorTexteOnglets;
  if ATab = Atab.PageControl.ActivePage then
    ATab.Color := gci_context.ColorLight
  else
    ATab.Color := gci_context.ColorDark;
end;

procedure TFGraphConfigLiens.lCompositionLieuClick(Sender: TObject);
var
  p: TPoint;
begin
  p := lCompositionLieu.ClientToScreen(Point(0, lCompositionLieu.Height));
  mLieu.Popup(p.X, p.Y);
end;

procedure TFGraphConfigLiens.cAvecLieuClick(Sender: TObject);
begin
  if fFill.Value = False then
  begin
    (FLinksBox.Owner as IFormIniPaint).EnableBtnRefresh;
    gci_context.ShouldSave := True;
    FLinksBox.SetCheckOption(loBourg,cAvecLieu.Checked);
  end;
end;

procedure TFGraphConfigLiens.menuChange(Sender: TObject);
begin
  if fFill.Value = False then
  with FLinksBox do
  begin
    (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;
    if (Sender as TMenuItem).Checked then
    begin
      if Sender = mAvecCodeDept then
        mAvecNomDept.Checked := False;
      if Sender = mAvecNomDept then
        mAvecCodeDept.Checked := False;
    end;
    SetCheckOption(loSubd,mAvecSubd.Checked);
    SetCheckOption(loCities,mAvecVille.Checked);
    SetCheckOption(loCodeDept,mAvecCodeDept.Checked);;
    SetCheckOption(loNameDept,mAvecNomDept.Checked);;
    SetCheckOption(loRegion,mAvecRegion.Checked);;
    SetCheckOption(loCountry,mAvecPays.Checked);;
    gci_context.ShouldSave := True;
    (FLinksBox.Owner as IFormIniPaint).EnableBtnRefresh;
    lCompositionLieu.Font.Style := lCompositionLieu.Font.Style - [fsUnderline];
    lCompositionLieu.Cursor := crDefault;
  end;
end;

procedure TFGraphConfigLiens.lCompositionLieuMouseEnter(Sender: TObject);
begin
  lCompositionLieu.Font.Style := lCompositionLieu.Font.Style + [fsUnderline];
  lCompositionLieu.Cursor := _CURPOPUP;
end;

procedure TFGraphConfigLiens.lCompositionLieuMouseLeave(Sender: TObject);
begin
  lCompositionLieu.Font.Style := lCompositionLieu.Font.Style - [fsUnderline];
  lCompositionLieu.Cursor := crDefault;
end;

procedure TFGraphConfigLiens.cbShowSosasClick(Sender: TObject);
begin
  if fFill.Value = False then
  begin
    gci_context.ShouldSave := True;
    with FLinksBox do
    SetCheckShow(ltSOSA,cbShowSosas.Checked);
  end;
end;

end.


