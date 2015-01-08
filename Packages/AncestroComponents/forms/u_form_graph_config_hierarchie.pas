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

unit u_form_graph_config_hierarchie;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  u_objet_TGraphArbre, u_objet_graph_TViewer, Windows,
  JvXPCheckCtrls, JvXPButtons,
{$ELSE}
  LCLIntf, ExtJvXPCheckCtrls, ExtJvXPButtons,
{$ENDIF}
  U_FormAdapt,u_comp_TYLanguage,Dialogs,
  StdCtrls, U_ExtColorCombos,
  u_buttons_flat,ExtCtrls,
  Controls,Classes,Graphics,
  Forms,
  u_ancestroviewer, u_ancestrotree,
  u_framework_components,
  Menus, ComCtrls, u_objet_TState;

type

  { TFGraphConfigHierarchie }

  TFGraphConfigHierarchie=class(TF_FormAdapt)
    btnExport: TFBExport;
    btnFont: TJvXPButton;
    btnImport: TFBImport;
    cAvecActe: TJvXPCheckbox;
    cAvecLieu: TJvXPCheckbox;
    cbShowSosas: TJvXPCheckbox;
    cDeces: TJvXPCheckbox;
    cMariage: TJvXPCheckbox;
    cNaissance: TJvXPCheckbox;
    cNom: TJvXPCheckbox;
    cOptimiseLargeur: TJvXPCheckbox;
    cPaintFondRecFemme: TJvXPCheckbox;
    cPaintFondRecHomme: TJvXPCheckbox;
    cPosterite: TJvXPCheckbox;
    cPrenom: TJvXPCheckbox;
    cProf: TJvXPCheckbox;
    edColorTexteFemme: TExtColorCombo;
    edColorTexteHomme: TExtColorCombo;
    edCouleurFondFemme: TExtColorCombo;
    edCouleurFondRectHomme: TExtColorCombo;
    edCouleurLiens: TExtColorCombo;
    edCouleurRectFemme: TExtColorCombo;
    edCouleurRectHomme: TExtColorCombo;
    edLineHeight: TFWSpinEdit;
    edEspaceEntreGenerations: TFWSpinEdit;
    edEspaceEntreIndis: TFWSpinEdit;
    edHeightIndi: TFWSpinEdit;
    edMargeLeft: TFWSpinEdit;
    edMargeTop: TFWSpinEdit;
    edRecouvrementImpression: TFWSpinEdit;
    edWidthIndi: TFWSpinEdit;
    FontDialog:TFontDialog;
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
    Label27: TLabel;
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
    Panel1: TPanel;
    panExempleFont: TPanel;
    pBorder:TPanel;
    Panel11:TPanel;
    Panel14:TPanel;
    Panel13:TPanel;
    Panel6:TPanel;
    page4:TTabSheet;
    page5:TTabSheet;
    page6:TTabSheet;
    page7:TTabSheet;
    page8:TTabSheet;
    page9:TTabSheet;
    Language:TYLanguage;
    mLieu: TPopupMenu;
    mAvecSubd: TMenuItem;
    mAvecVille: TMenuItem;
    mAvecDept: TMenuItem;
    mAvecRegion: TMenuItem;
    mAvecPays: TMenuItem;
    mAvecCodeDept: TMenuItem;
    mAvecNomDept: TMenuItem;
    OpenDialog:TOpenDialog;
    SaveDialog:TSaveDialog;
    procedure SuperFormDestroy(Sender:TObject);
    procedure btnFontClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure onTabControl1Change(Sender: TObject);
    procedure onTabControl1DrawEx(AControl: TCustomTabControl;
      ATab: TTabSheet; Font: TFont);
    procedure ApplyChanges(Sender:TObject);
    procedure cMariageClick(Sender: TObject);
    procedure lCompositionLieuClick(Sender: TObject);
    procedure cAvecLieuClick(Sender: TObject);
    procedure menuChange(Sender: TObject);
    procedure lCompositionLieuMouseEnter(Sender: TObject);
    procedure lCompositionLieuMouseLeave(Sender: TObject);
    procedure cAvecActeMouseEnter(Sender: TObject);
    procedure cAvecActeMouseLeave(Sender: TObject);
    procedure cbShowSosasClick(Sender: TObject);
    procedure btnImportClick(Sender:TObject);
    procedure btnExportClick(Sender:TObject);
  private
    RectMonitor:TRect;
    fFill:TState;
    fOngletID:integer;
    FViewer : TGraphViewer;
    FGraphTree : TGraphTree;
    NomFich:string;

    procedure doActiveOnglet(onglet:integer); virtual;
  public
    constructor Create(Sender:TComponent);override;
    procedure InitView ( const AGraph : TGraphTree ); virtual;
  end;

implementation

uses 
    u_common_functions,
    u_common_const,
    fonctions_dialogs,
    u_printreport,
    IniFiles,
    u_ancestro_strings,
    u_genealogy_context;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFGraphConfigHierarchie.InitView ( const AGraph : TGraphTree );
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
{  btnFont.ColorShadow:=gci_context.ColorLight;
  btnFont.ColorBorder:=gci_context.ColorLight;
  btnFont.ColorDown:=gci_context.ColorLight;
  btnFont.ColorFocused:=gci_context.ColorLight;
  btnFont.ColorHighlight:=gci_context.ColorLight;}
  panExempleFont.Color:=gci_context.ColorDark;
  
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  DefaultCloseAction:=caHide;

  fOngletID:=0;
  OpenDialog.InitialDir:=gci_context.PathDocs;
  SaveDialog.InitialDir:=gci_context.PathDocs;
  NomFich:='';

  fFill.Value:=true;
  FGraphTree := AGraph;
  FViewer:=AGraph.Viewer;
  RectMonitor:=(AGraph.Owner as TCustomForm).Monitor.WorkareaRect;
  with FGraphTree do
  try
    ReadSectionIni;
    edMargeLeft.Value:=MargeLeft;
    edMargeTop.Value:=MargeTop;

    edWidthIndi.Value:=BoxWidth;
    edHeightIndi.Value:=BoxHeight;
    edEspaceEntreGenerations.Value:=SpaceGeneration;
    edEspaceEntreIndis.Value:=SpacePerson;
    edRecouvrementImpression.Value:=gci_context.ArbreRecouvrement;

    panExempleFont.Font.Assign(Font);
    edColorTexteHomme.Value:=ColorTextMan;
    edColorTexteFemme.Value:=ColorTextWoman;

    cNom.checked:=ttLastName in ShowText;
    cPrenom.checked:=ttName in ShowText;
    cProf.checked:=ttJob in ShowText;
    cNaissance.checked:=ttBirthDay in ShowText;
    cDeces.checked:=ttDeathDay in ShowText;
    cMariage.checked:=ttMarriage in ShowText;
    cPosterite.checked:=toWellKnown in Options;
    cbShowSosas.checked:=ttSOSA in ShowText;
    cAvecActe.checked:=toAct in Options;
    cOptimiseLargeur.checked:=toOptimiseWidth in Options;
    cAvecLieu.checked:=toBourg in Options;
    mAvecSubd.checked:=toSubd in Options;
    mAvecVille.checked:=toCities in Options;
    mAvecCodeDept.checked:=toCodeDept in Options;
    mAvecNomDept.checked:= toNameDept in Options;
    mAvecRegion.checked:=toRegion in Options;
    mAvecPays.checked:=toCountry in Options;
    lCompositionLieu.Visible:=toBourg in Options;

    edLineHeight.Value:=LineHeight;

    edCouleurLiens.Value:=ColorLink;
    edCouleurRectHomme.Value:=ColorRectMan;
    cPaintFondRecHomme.checked:= teBackMan in ShowBack;
    edCouleurFondRectHomme.Value:=ColorBackMan;
    edCouleurRectFemme.Value:=ColorRectWoman;
    cPaintFondRecFemme.checked:=teBackWoman in ShowBack;
    edCouleurFondFemme.Value:=ColorBackWoman;
  finally
    fFill.Value:=false;
  end;
end;

procedure TFGraphConfigHierarchie.SuperFormDestroy(Sender:TObject);
begin
  fFill.Destroy;
end;

constructor TFGraphConfigHierarchie.Create(Sender:TComponent);
begin
  fFill:=TState.create(false);
  FGraphTree := nil;
  Inherited;
end;

procedure TFGraphConfigHierarchie.btnFontClick(Sender:TObject);
begin
  FontDialog.Font.Assign(panExempleFont.Font);

  if FontDialog.execute then
  begin
    panExempleFont.Font.Assign(FontDialog.Font);
    ApplyChanges(Sender);
  end;
end;

procedure TFGraphConfigHierarchie.ApplyChanges(Sender:TObject);
begin
  if (fFill.Value=false)
  and Assigned(FGraphTree) then
  with FGraphTree do
  begin
    gci_context.ShouldSave:=true;
    ColorBackMan  :=edCouleurFondRectHomme.Value;
    ColorBackWoman:=edCouleurFondFemme.Value;
    ColorBox      :=clBlack;
    ColorRectMan  :=edCouleurRectHomme.Value;
    ColorRectWoman:=edCouleurRectFemme.Value;
    ColorTextMan  :=ColorTextMan;
    ColorTextWoman:=ColorTextWoman;

    MargeLeft:=edMargeLeft.Value;
    MargeTop:=edMargeTop.Value;

    BoxWidth:=edWidthIndi.Value;
    BoxHeight:=edHeightIndi.Value;
    SpaceGeneration:=edEspaceEntreGenerations.Value;
    SpacePerson:=edEspaceEntreIndis.Value;
    gci_context.ArbreRecouvrement:=edRecouvrementImpression.Value;
    graph_RecouvrementImpression:=edRecouvrementImpression.Value;

    Font.Assign(panExempleFont.Font);
    ColorTextMan:=edColorTexteHomme.Value;
    ColorTextWoman:=edColorTexteFemme.Value;

    SetCheckShow ( ttLastName,cNom.Checked );
    SetCheckShow ( ttName,cPrenom.Checked);
    SetCheckShow ( ttJob,cProf.Checked);
    SetCheckShow ( ttBirthDay,cNaissance.Checked);
    SetCheckShow ( ttDeathDay,cDeces.Checked);

    SetCheckOption(toOptimiseWidth,cOptimiseLargeur.checked);

    LineHeight:=edLineHeight.Value;

    SetCheckOption(toAct,cAvecActe.checked);
    SetCheckOption(toWellKnown,cPosterite.checked);

    SetCheckElement ( teBackMan,cPaintFondRecHomme.Checked);
    SetCheckElement ( teBackWoman,cPaintFondRecFemme.Checked);

    ColorLink:=edCouleurLiens.Value;
    ColorRectMan:=edCouleurRectHomme.Value;
    ColorBackMan:=edCouleurFondRectHomme.Value;
    ColorRectWoman:=edCouleurRectFemme.Value;
    ColorBackWoman:=edCouleurFondFemme.Value;

    WriteSectionIni;
    //on rafraichit le graph
    fViewer.BeginUpdate;
    try                       {
      if sender=edRecouvrementImpression then
      begin
        fViewer.PageWidth:=round(rm.rp.PageWidth-rm.rp.LeftWaste-rm.rp.RightWaste-edRecouvrementImpression.Value);
        fViewer.PageHeight:=round(rm.rp.PageHeight-rm.rp.TopWaste-rm.rp.BottomWaste-edRecouvrementImpression.Value);
      end
      else
        if (Sender.ClassType<>TExtColorCombo)and(sender<>cAvecActe)then
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
  end;
end;

procedure TFGraphConfigHierarchie.SuperFormShowFirstTime(Sender:TObject);
begin
  //Positionnement de la fenêtre en bas à droite du moniteur de l'arbre
  Top:=RectMonitor.Bottom-Height;
  Left:=RectMonitor.Right-Width;
  Caption:=rs_Caption_Set_the_tree;
  doActiveOnglet(0);
end;

procedure TFGraphConfigHierarchie.doActiveOnglet(onglet:integer);
begin
  fOngletID:=onglet;
  Notebook.PageIndex:=onglet;
end;

procedure TFGraphConfigHierarchie.SuperFormKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  case Key of
    _KEY_HELP:p_ShowHelp(_ID_PRINT_ARBRE);
  end;
end;

procedure TFGraphConfigHierarchie.onTabControl1Change(Sender: TObject);
begin
  doActiveOnglet((sender as TPanel).TabOrder);
end;

procedure TFGraphConfigHierarchie.onTabControl1DrawEx(
  AControl: TCustomTabControl; ATab: TTabSheet; Font: TFont);
begin
  Font.Color:= gci_context.ColorTexteOnglets;
  if ATab = ATab.PageControl.ActivePage then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
end;

procedure TFGraphConfigHierarchie.cMariageClick(Sender: TObject);
begin
  if fFill.Value=false then
  with FGraphTree do
  begin
    (Owner as IFormIniPaint).EnableBtnRefresh;
    gci_context.ShouldSave:=true;
    SetCheckShow ( ttMarriage,cMariage.checked);
  end;
end;

procedure TFGraphConfigHierarchie.lCompositionLieuClick(Sender: TObject);
var
  p:TPoint;
begin
  p:=lCompositionLieu.ClientToScreen(Point(0,lCompositionLieu.Height));
  mLieu.Popup(p.X,p.Y);
end;

procedure TFGraphConfigHierarchie.cAvecLieuClick(Sender: TObject);
begin
  if fFill.Value=false then
  with FGraphTree do
  begin
    (Owner as IFormIniPaint).EnableBtnRefresh;
    SetCheckOption(toBourg,cAvecLieu.checked);
    lCompositionLieu.Visible:=cAvecLieu.checked;
  end;
end;

procedure TFGraphConfigHierarchie.menuChange(Sender: TObject);
begin
  if fFill.Value=false then
  with FGraphTree do
  begin
    (Sender as TMenuItem).Checked:=not (Sender as TMenuItem).Checked;
    if (Sender as TMenuItem).Checked then
    begin
      if sender=mAvecCodeDept then
        mAvecNomDept.Checked:=false;
      if sender=mAvecNomDept then
        mAvecCodeDept.Checked:=false;
    end;
    SetCheckOption ( toSubd,mAvecSubd.checked );
    SetCheckOption ( toCities,mAvecVille.Checked);
    SetCheckOption ( toCodeDept,mAvecCodeDept.checked);
    SetCheckOption ( toNameDept,mAvecNomDept.checked);
    SetCheckOption ( toRegion,mAvecRegion.checked);
    SetCheckOption ( toCountry,mAvecPays.checked);
    (Owner as IFormIniPaint).EnableBtnRefresh;
    lCompositionLieu.Font.Style:=lCompositionLieu.Font.Style-[fsUnderline];
    lCompositionLieu.Cursor:=crDefault;
  end;
end;

procedure TFGraphConfigHierarchie.lCompositionLieuMouseEnter(
  Sender: TObject);
begin
  lCompositionLieu.Font.Style:=lCompositionLieu.Font.Style+[fsUnderline];
  lCompositionLieu.Cursor:=_CURPOPUP;
end;

procedure TFGraphConfigHierarchie.lCompositionLieuMouseLeave(
  Sender: TObject);
begin
  lCompositionLieu.Font.Style:=lCompositionLieu.Font.Style-[fsUnderline];
  lCompositionLieu.Cursor:=crDefault;
end;

procedure TFGraphConfigHierarchie.cAvecActeMouseEnter(Sender: TObject);
begin
  cAvecActe.ShowHint:=true;//met le hint devant la fiche si celle-ci est en mode fsStayOnTop
end;

procedure TFGraphConfigHierarchie.cAvecActeMouseLeave(Sender: TObject);
begin
  cAvecActe.ShowHint:=false;
end;

procedure TFGraphConfigHierarchie.cbShowSosasClick(Sender: TObject);
begin
  if fFill.Value=false then
  FGraphTree.SetCheckShow(ttSOSA,cbShowSosas.Checked);
end;

procedure TFGraphConfigHierarchie.btnImportClick(Sender:TObject);
begin
  if NomFich<>'' then
    OpenDialog.FileName:=NomFich;
  if OpenDialog.Execute then
  begin
    NomFich:=OpenDialog.FileName;
    try
      with FGraphTree do
      try
        fFill.Value:=true;
        try
          Inifile:=TIniFile.Create(NomFich);
          ReadSectionIni;

          (Owner as IFormIniPaint).EnableBtnRefresh;
          fViewer.BeginUpdate;
          with PrintGraph,rp.PrinterMetrics do
          try
            fViewer.PageWidth:=round(PhysicalWidth-MarginLeft-MarginRight-edRecouvrementImpression.Value);
            fViewer.PageHeight:=round(PhysicalHeight-MarginTop-MarginBottom-edRecouvrementImpression.Value);
//            Graph.Prepare;
            fViewer.BuildZonesImpression;
            fViewer.BuildMiniature;
           fViewer.PrepareGraph;
          finally
            fViewer.EndUpdate;
          end;
          fViewer.Refresh;
          fViewer.RefreshMiniature;
        finally
          fFill.Value:=false;
        end;
      finally
        Inifile.Free;
        Inifile:=nil;
      end;
    except
      MyMessageDlg(rs_Error_This_File_is_not_a_tree_config_file
        ,mtError, [mbCancel],Self)
    end;
  end;
end;

procedure TFGraphConfigHierarchie.btnExportClick(Sender:TObject);
begin
  if NomFich<>'' then
    SaveDialog.FileName:=NomFich;
  if SaveDialog.Execute then
  begin
    NomFich:=SaveDialog.FileName;
    with FGraphTree do
    try
      Inifile := TIniFile.Create(NomFich);
      WriteSectionIni;
    finally
      Inifile.Free;
      Inifile:=nil;
    end;
  end;
end;
end.
