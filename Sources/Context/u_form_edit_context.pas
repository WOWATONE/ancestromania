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
{                                                                       }
{-----------------------------------------------------------------------}

unit u_form_edit_context;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  U_FormAdapt,Forms,
  fonctions_string,
  Dialogs,SysUtils, MaskEdit,
  StdCtrls,u_buttons_appli,ExtJvXPButtons,u_framework_components,
  ExtJvXPCheckCtrls,Controls,ExtCtrls,Classes,
  u_ancestropictimages,lazutf8classes,
  Graphics, U_ExtColorCombos,
  ComCtrls;

type

  { TFEditContext }

  TFEditContext=class(TF_FormAdapt)
    bsfbSelection: TFWOK;
    btnFermer: TFWClose;
    cbAfficheCPdansListeEV: TJvXPCheckbox;
    cbAfficheRegiondansListeEV: TJvXPCheckbox;
    cbAfficherPatronymes: TJvXPCheckbox;
    cbAideSaisieRapideNom: TJvXPCheckbox;
    cbAideSaisieRapidePrenom: TJvXPCheckbox;
    cbAideSaisieRapideProf: TJvXPCheckbox;
    cbAstro: TJvXPCheckbox;
    cbAvecLienGene: TJvXPCheckbox;
    cbCalculParenteAuto: TJvXPCheckbox;
    cbCivilite: TJvXPCheckbox;
    cbCreationMARRConjoint: TJvXPCheckbox;
    cbCreationMARRParent: TJvXPCheckbox;
    cbLangage: TFWComboBox;
    CBPays: TComboBox;
    cbShowHint: TJvXPCheckbox;
    cbSurnomApresNom: TJvXPCheckbox;
    chbExit: TJvXPCheckbox;
    CheckAgeMaxiMariage: TJvXPCheckbox;
    CheckAgeMaxiNaissanceEnfant: TJvXPCheckbox;
    CheckAgeMiniMariage: TJvXPCheckbox;
    CheckAgeMiniNaissanceEnfant: TJvXPCheckbox;
    CheckEcartAgeEpoux: TJvXPCheckbox;
    CheckEsperanceVie: TJvXPCheckbox;
    CheckNbJourEntreNaissance: TJvXPCheckbox;
    chVerifMaj: TJvXPCheckbox;
    ch_hborders: TJvXPCheckbox;
    ch_rounded_borders: TJvXPCheckbox;
    ch_vborders: TJvXPCheckbox;
    ColorDialog:TColorDialog;
    cpRapportBorderColor: TExtColorCombo;
    cpRapportColumnHeaderColor: TExtColorCombo;
    cpRapportColumnsColor: TExtColorCombo;
    cpRapportFontColumnColor: TExtColorCombo;
    cpRapportFontColumnHeaderColor: TExtColorCombo;
    cpRapportFontHeaderColor: TExtColorCombo;
    cpRapportHeaderColor: TExtColorCombo;
    csSeConsanguinite: TFWSpinEdit;
    cxButton10: TFWInit;
    cxButton11: TFWInit;
    cxButton12: TFWInit;
    cxButton13: TFWInit;
    cxButton14: TFWInit;
    cxButton15: TFWInit;
    cxButton16: TFWInit;
    cxButton7: TFWInit;
    cxButton8: TFWInit;
    cxButton9: TFWInit;
    cxFormatSurnom: TMaskEdit;
    cxFormatSurnomF: TMaskEdit;
    cxGroupBox1: TGroupBox;
    cxGroupBox12: TGroupBox;
    cxGroupBox15: TGroupBox;
    cxGroupBox16: TGroupBox;
    cxGroupBox2: TGroupBox;
    cxGroupBox3: TGroupBox;
    cxGroupBox7: TGroupBox;
    cxGroupBox8: TGroupBox;
    cxSatGeonames: TRadioButton;
    cxSatGoogle: TRadioButton;
    cxSatMapper: TRadioButton;
    cxSatOSM: TRadioButton;
    cxseZoom: TFWSpinEdit;
    ed7: TFWSpinEdit;
    edArbreShowNbGeneration: TFWSpinEdit;
    edF1: TFWSpinEdit;
    edF2: TFWSpinEdit;
    edF3: TFWSpinEdit;
    edF4: TFWSpinEdit;
    edF6: TFWSpinEdit;
    edH1: TFWSpinEdit;
    edH2: TFWSpinEdit;
    edH3: TFWSpinEdit;
    edH4: TFWSpinEdit;
    edH5: TFWSpinEdit;
    edH6: TFWSpinEdit;
    edNomDefaut: TMaskEdit;
    edPwUtilPARANCES: TMaskEdit;
    edRolePARANCES: TMaskEdit;
    edRoueShowNbGeneration: TFWSpinEdit;
    edUtilPARANCES: TMaskEdit;
    ed_RapportPoliceColumn: TEdit;
    ed_RapportPoliceColumnHeader: TEdit;
    ed_RapportPoliceHeader: TEdit;
    gbNouveauxLieux: TGroupBox;
    gbSatellites: TGroupBox;
    gb_borders: TGroupBox;
    Image2: TImage;
    Image3: TImage;
    ImageSet0: TImage;
    ImageSet1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    LabelCouleurs1: TLabel;
    LabLangage: TLabel;
    lDossiers1: TLabel;
    lDossiers2: TLabel;
    ltaillefont: TLabel;
    MemoVitesse: TMemo;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel2: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9:TPanel;
    Image1:TIATitle;
    Label8:TLabel;
    cxPageControl1:TPageControl;
    cxTabSheet1:TTabSheet;
    cxTabSheet2:TTabSheet;
    cxTabSheet3:TTabSheet;
    cxTabSheet4:TTabSheet;
    cxTabSheet5:TTabSheet;
    OpenDialog1:TOpenDialog;
    cbActiveControl:TJvXPCheckBox;
    ImageList1:TImageList;
    cxGroupBox5:TGroupBox;
    cxGroupBox9:TGroupBox;
    cxGroupBox10:TGroupBox;
    Label3:TLabel;
    Label26:TLabel;
    Label16:TLabel;
    prPreNormal: TRadioButton;
    rbPatFirst: TRadioButton;
    rbPatMaj: TRadioButton;
    rbPatNormal: TRadioButton;
    rbPreFirst: TRadioButton;
    rbPreMaj: TRadioButton;
    rbSet0: TRadioButton;
    rbSet1: TRadioButton;
    rbSet2: TRadioButton;
    rbSet3: TRadioButton;
    seTailleFenetre: TFWSpinEdit;
    seTailleFont: TFWSpinEdit;
    slGEDCOMDir:TFWEdit;
    edPathDocs:TFWEdit;
    Sauvegarde:TFWEdit;
    cxGroupBox11:TGroupBox;
    Label25:TLabel;
    QuiSontIls:TFWEdit;
    cxGroupBox13:TGroupBox;
    cxGroupBox14:TGroupBox;
    Label11:TLabel;
    Label12:TLabel;
    cpHommes:TExtColorCombo;
    cpFemmes:TExtColorCombo;
    cbCreateDirUTF8:TJvXPCheckBox;
    Label2:TLabel;
    cpFondsColor:TExtColorCombo;
    Label5:TLabel;
    cpSelectionColor:TExtColorCombo;
    Label14:TLabel;
    cpOngletsColor:TExtColorCombo;
    btInitColorFemmes:TFWInit;
    cxButton1:TJvXPButton;
    cxButton2:TJvXPButton;
    cxButton3:TJvXPButton;
    cxButton4:TJvXPButton;
    LabelCouleurs:TLabel;
    Label23:TLabel;
    cpTexteOngletsColor:TExtColorCombo;
    cxButton5:TJvXPButton;
    Label24: TLabel;
    TabSheet1: TTabSheet;
    Label29: TLabel;
    cxGroupBox6: TGroupBox;
    Label22: TLabel;
    cbDesactiveMedia: TJvXPCheckBox;
    cbPhotos: TJvXPCheckBox;
    chbBackup: TJvXPCheckBox;
    chOuvreHistoire: TJvXPCheckBox;
    MemoSauveAuto: TMemo;
    lDossiers: TLabel;
    TauxCompressJpeg: TFWSpinEdit;

    procedure cxButton10Click(Sender: TObject);
    procedure cxButton11Click(Sender: TObject);
    procedure cxButton12Click(Sender: TObject);
    procedure cxButton13Click(Sender: TObject);
    procedure cxButton14Click(Sender: TObject);
    procedure cxButton15Click(Sender: TObject);
    procedure cxButton16Click(Sender: TObject);
    procedure cxButton7Click(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);
    procedure cxButton9Click(Sender: TObject);
    procedure SpeedButton1Click(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
    procedure WizardTreeChanging(Sender:TObject;NewItemIndex:Integer;var AllowChange:Boolean);
    procedure SuperFormFillFields(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure bsfbSelectionClick(Sender:TObject);
    procedure SuperFormFillProperties(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure QuiSontIlsPropertiesButtonClick(Sender:TObject;
      AButtonIndex:Integer);
    procedure SauvegardePropertiesButtonClick(Sender:TObject;
      AButtonIndex:Integer);
    procedure edPathDocsPropertiesButtonClick(Sender:TObject;
      AButtonIndex:Integer);
    procedure slGEDCOMDirPropertiesButtonClick(Sender:TObject;
      AButtonIndex:Integer);
    procedure cbAstroPropertiesChange(Sender:TObject);
    procedure chbBackupClick(Sender:TObject);
    procedure cbCalculParenteAutoMouseEnter(Sender:TObject);
    procedure cbCalculParenteAutoContextPopup(Sender:TObject;
      MousePos:TPoint;var Handled:Boolean);
    procedure btInitColorFemmesClick(Sender:TObject);
    procedure onDrawTabEx(AControl:TCustomTabControl;ATab:TTabSheet;
      Font:TFont);
    procedure cbShowHintClick(Sender:TObject);
    procedure ValideRepertoire(Sender:TObject;
      var DisplayValue:Variant;var ErrorText:TCaption;
      var Error:Boolean);
    procedure chOuvreHistoireClick(Sender: TObject);
    procedure cbLangagePropertiesEditValueChanged(Sender: TObject);
    procedure cbCreationMARRConjointClick(Sender: TObject);
    procedure cbActiveControlPropertiesChange(Sender: TObject);

  private
    fFill:boolean;
    bMessageActif:boolean;
  public

  end;

implementation

uses u_common_functions,
     u_common_ancestro,
     fonctions_dialogs,
     fonctions_languages,
     u_dm,u_genealogy_context,u_common_const,
     u_common_ancestro_functions, fonctions_init, fonctions_reports,
     fonctions_scaledpi,
     u_form_main,IBSQL, FileUtil;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFEditContext.SpeedButton1Click(Sender:TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TFEditContext.cxButton7Click(Sender: TObject);
begin
  cpRapportHeaderColor.Value:=CST_PRINT_HEADER_COLOR;
end;

procedure TFEditContext.cxButton10Click(Sender: TObject);
begin
  cpRapportFontColumnHeaderColor.Value:=CST_PRINT_COLUMN_FONT_COLOR;
end;

procedure TFEditContext.cxButton11Click(Sender: TObject);
begin
  cpRapportColumnsColor.Value:=CST_PRINT_COLUMN_COLOR;
end;

procedure TFEditContext.cxButton12Click(Sender: TObject);
begin
  cpRapportFontColumnColor.Value:=CST_PRINT_COLUMN_FONT_COLOR;
end;

procedure TFEditContext.cxButton13Click(Sender: TObject);
begin
  ed_RapportPoliceHeader.Text:=CST_PRINT_HEADER_FONT_NAME;
end;

procedure TFEditContext.cxButton14Click(Sender: TObject);
begin
  ed_RapportPoliceColumn.Text:=CST_PRINT_COLUMN_FONT_NAME;
end;

procedure TFEditContext.cxButton15Click(Sender: TObject);
begin
  ed_RapportPoliceColumnHeader.Text:=CST_PRINT_COLUMN_HEADER_FONT_NAME;
end;

procedure TFEditContext.cxButton16Click(Sender: TObject);
begin
  cpRapportBorderColor.Value:=CST_PRINT_COLUMN_BORDER_COLOR;
end;

procedure TFEditContext.cxButton8Click(Sender: TObject);
begin
  cpRapportFontHeaderColor.Value:=CST_PRINT_HEADER_FONT_COLOR;
end;

procedure TFEditContext.cxButton9Click(Sender: TObject);
begin
  cpRapportColumnHeaderColor.Value:=CST_PRINT_COLUMN_COLOR;
end;


procedure TFEditContext.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:ModalResult:=mrCancel;
    _KEY_HELP:p_ShowHelp(_ID_PARAMETRES);
  end;
end;

procedure TFEditContext.WizardTreeChanging(Sender:TObject;
  NewItemIndex:Integer;var AllowChange:Boolean);
begin
  DoRefreshControls;
end;

procedure TFEditContext.SuperFormFillFields(Sender:TObject);
var
  k:integer;
  fListFiles:TStringlistUTF8;
  q:TIBSQL;
begin
  fFill:=true;
  p_ReadReportsViewFromIni ( f_GetMemIniFile );
  p_ReadScaleFromIni(f_GetMemIniFile);
  seTailleFont.Value:=ge_GlobalScaleForm*FromDPI;
  try
    case gci_context.ModeSaisieNom of
      mftUpper:rbPatMaj.checked:=true;
      mftFirstCharOfWordsIsMaj:rbPatFirst.checked:=true;
      else
        rbPatNormal.checked:=true;
    end;

    case gci_context.ModeSaisiePrenom of
      mftUpper:rbPreMaj.checked:=true;
      mftFirstCharOfWordsIsMaj:rbPreFirst.checked:=true;
      else
        prPreNormal.checked:=true;
    end;

    ch_rounded_borders.Checked := ExtColumnRoundedBorders;
    ch_hborders       .Checked := ExtColumnHBorders;
    ch_vborders       .Checked := ExtColumnVBorders;
    cbCreateDirUTF8       .Checked:=gci_context.CreateRepDefaut;
    cxseZoom.Value:=gci_context.Zoom;
    cbDesactiveMedia.Checked:=gci_context.OngletMultimediaReseau;
    chOuvreHistoire.Checked:=gci_context.OuvreHistoire;
    csSeConsanguinite.Value:=gci_context.NiveauConsang;
    cbSurnomApresNom.Checked:=gci_context.SurnomAlaFin;
    cxFormatSurnom.Text:=gci_context.FormatSurnom;
    cxFormatSurnomF.Text:=gci_context.FormatSurnomF;
    edNomDefaut.Text:=gci_context.NomDefaut;
    cbAvecLienGene.Checked:=gci_context.AvecLienGene;
    cbCalculParenteAuto.Checked:=gci_context.CalculParenteAuto;
    cbAstro.Checked:=gci_context.Astro;
    cbCivilite.Checked:=gci_context.Civilite;
    cbAfficherPatronymes.Checked:=gci_context.AfficherPatAssoc;

    cpRapportHeaderColor          .Value:=ExtHeaderColorBack;
    cpRapportBorderColor          .Value:=ExtColorBorder;
    cpRapportColumnHeaderColor    .Value:=ExtColumnHeaderColorBack;
    cpRapportColumnsColor         .Value:=ExtColumnColorBack;
    cpRapportFontHeaderColor      .Value:=ExtHeaderFont.Color;
    cpRapportFontColumnHeaderColor.Value:=ExtColumnHeaderFont.Color;
    cpRapportFontColumnColor      .Value:=ExtColumnFont.Color;

    ed_RapportPoliceColumn      .Text   :=ExtColumnFont.Name;
    ed_RapportPoliceColumnHeader.Text   :=ExtColumnHeaderFont.Name;
    ed_RapportPoliceHeader      .Text   :=ExtHeaderFont.Name;

    case gci_context.SetAstro of
      0:rbSet0.Checked:=true;
      1:rbSet1.Checked:=true;
      2:rbSet2.Checked:=true;
      else
        rbSet3.Checked:=true;
    end;

    cpHommes.Value:=gci_context.ColorHomme;
    cpFemmes.Value:=gci_context.ColorFemme;
    cpFondsColor.Value:=gci_context.ColorLight;
    cpSelectionColor.Value:=gci_context.ColorMedium;
    cpOngletsColor.Value:=gci_context.ColorDark;
    cpTexteOngletsColor.Value:=gci_context.ColorTexteOnglets;

    seTailleFenetre.Value:=gci_context.TailleFenetre;
    TauxCompressJpeg.Value:=gci_context.TauxCompressionJPeg;

    edH1.Value:=gci_context.AgeMiniMariageHommes;
    edF1.Value:=gci_context.AgeMiniMariageFemmes;
    edH2.Value:=gci_context.AgeMaxiMariageHommes;
    edF2.Value:=gci_context.AgeMaxiMariageFemmes;
    edH3.Value:=gci_context.AgeMiniNaissanceEnfantHommes;
    edF3.Value:=gci_context.AgeMiniNaissanceEnfantFemmes;
    edH4.Value:=gci_context.AgeMaxiNaissanceEnfantHommes;
    edF4.Value:=gci_context.AgeMaxiNaissanceEnfantFemmes;
    edH6.Value:=gci_context.AgeMaxiAuDecesHommes;
    edF6.Value:=gci_context.AgeMaxiAuDecesFemmes;
    ed7.Value:=gci_context.EcartAgeEntreEpoux;
    edH5.Value:=gci_context.NbJourEntre2NaissancesNormales;

    cbActiveControl.checked:=gci_context.CoherenceActive;
    CheckAgeMiniMariage.checked:=gci_context.CheckAgeMiniMariage;
    CheckAgeMaxiMariage.checked:=gci_context.CheckAgeMaxiMariage;
    CheckAgeMiniNaissanceEnfant.checked:=gci_context.CheckAgeMiniNaissanceEnfant;
    CheckAgeMaxiNaissanceEnfant.checked:=gci_context.CheckAgeMaxiNaissanceEnfant;
    CheckEsperanceVie.checked:=gci_context.CheckEsperanceVie;
    CheckEcartAgeEpoux.checked:=gci_context.CheckEcartAgeEpoux;
    CheckNbJourEntreNaissance.checked:=gci_context.CheckNbJourEntreNaissance;

    cbAfficheCPdansListeEV.checked:=gci_context.AfficheCPdansListeEV;
    cbAfficheRegiondansListeEV.checked:=gci_context.AfficheRegiondansListeEV;

    chVerifMaj.Checked:=gci_context.VerifMAJ;

    slGEDCOMDir.Text:=gci_context.PathImportExport;
    edPathDocs.Text:=gci_context.PathDocs;

    cbShowHint.checked:=gci_context.CanSeeHint;
    cbPhotos.Checked:=gci_context.Photos;
    chbExit.checked:=gci_context.ShowExit;
    chbBackup.Checked:=gci_context.Backup;

    cbAideSaisieRapideNom.Checked:=gci_context.AideSaisieRapideNom;
    cbAideSaisieRapidePrenom.Checked:=gci_context.AideSaisieRapidePrenom;
    cbAideSaisieRapideProf.Checked:=gci_context.AideSaisieRapideProf;

    cbCreationMARRParent.Checked:=gci_context.CreationMARRParent;
    cbCreationMARRConjoint.Checked:=gci_context.CreationMARRConjoint;

    edUtilPARANCES.Text:=gci_context.UtilPARANCES;
    edPwUtilPARANCES.Text:=gci_context.PwUtilPARANCES;
    edRolePARANCES.Text:=gci_context.RolePARANCES;

    CBPays.Items.Clear;
    if dm.IBBaseParam.Connected then
    begin
      q:=TIBSQL.Create(self);
      try
        q.Database:=dm.IBBaseParam;
        q.Transaction:=dm.IBTransParam;
        q.SQL.Text:='select RPA_CODE,RPA_LIBELLE from REF_PAYS order by RPA_LIBELLE';
        q.ExecQuery;
        while not q.Eof do
          begin
            CBPays.Items.Add(q.Fields[1].AsString);
            if q.Fields[0].AsInteger=gci_context.Pays then
              CBPays.Text:=q.Fields[1].AsString;
            q.Next;
          end;
        finally
          q.Free;
        end;
    End;
    edArbreShowNbGeneration.Value:=gci_context.ArbreShowNbGeneration;
    edRoueShowNbGeneration.Value:=gci_context.RoueShowNbGeneration;

    Sauvegarde.Text:=gci_context.PathSauvegarde;
    QuiSontIls.Text:=gci_context.PathQuiSontIls;

    case gci_context.QuelSat of
      0:cxSatGoogle.Checked:=true;
      1:cxSatGeonames.Checked:=true;
      2:cxSatMapper.Checked:=true;
      3:cxSatOSM.Checked:=true;
    end;

    fListFiles:=TStringlistUTF8.Create;
    try
      GetDirContent(_Path_Appli+_REL_PATH_TRADUCTIONS,fListFiles,'*'+_EXT_TRADUC);
      for k:=0 to fListFiles.count-1 do
        cbLangage.Items.Add(extractFileNameWithoutExt(fListFiles[k]));
    finally
      fListFiles.Free;
    end;
    cbLangage.Text:=gs_lang;
  finally
    fFill:=false;
  end;
end;

procedure TFEditContext.SuperFormShowFirstTime(Sender:TObject);
begin
  caption:=rs_Caption_Preferences;
  doFillFields;
  application.ProcessMessages;
end;

procedure TFEditContext.bsfbSelectionClick(Sender:TObject);
begin
  doFillProperties;
  Close;
end;

procedure TFEditContext.SuperFormFillProperties(Sender:TObject);
var
  q:TIBSQL;
begin
  gci_context.CreateRepDefaut:=cbCreateDirUTF8.Checked;
  gci_context.OngletMultimediaReseau:=cbDesactiveMedia.Checked;
  gci_context.NiveauConsang:=csSeConsanguinite.Value;
  gci_context.Astro:=cbAstro.Checked;
  gci_context.AvecLienGene:=cbAvecLienGene.Checked;
  gci_context.CalculParenteAuto:=cbCalculParenteAuto.Checked;
  dm.doActiveTriggerMajSosa(gci_context.CalculParenteAuto);

  {$IFNDEF WINDOWS}
  ge_GlobalScaleForm:=seTailleFont.Value/FromDPI*ge_GlobalScaleForm;
  {$ENDIF}

  ExtColumnRoundedBorders   := ch_rounded_borders.Checked;
  ExtColumnVBorders         := ch_vborders       .Checked;
  ExtColumnHBorders         := ch_hborders       .Checked;
  ExtHeaderColorBack        := cpRapportHeaderColor          .Value;
  ExtColorBorder            := cpRapportBorderColor          .Value;
  ExtColumnHeaderColorBack  := cpRapportColumnHeaderColor    .Value;
  ExtColumnColorBack        := cpRapportColumnsColor         .Value;
  ExtHeaderFont      .Color := cpRapportFontHeaderColor      .Value;
  ExtColumnHeaderFont.Color := cpRapportFontColumnHeaderColor.Value;
  ExtColumnFont      .Color := cpRapportFontColumnColor      .Value;

  ExtColumnFont      .Name := ed_RapportPoliceColumn      .Text;
  ExtColumnHeaderFont.Name := ed_RapportPoliceColumnHeader.Text;
  ExtHeaderFont      .Name := ed_RapportPoliceHeader      .Text;

  if rbSet0.Checked then
    gci_context.SetAstro:=0
  else if rbSet1.Checked then
    gci_context.SetAstro:=1
  else if rbSet2.Checked then
    gci_context.SetAstro:=2
  else
    gci_context.SetAstro:=3;

  gci_context.Civilite:=cbCivilite.Checked;
  gci_context.AfficherPatAssoc:=cbAfficherPatronymes.Checked;
  gci_context.SurnomAlaFin:=cbSurnomApresNom.Checked;
  gci_context.NomDefaut:=edNomDefaut.Text;
  gci_context.FormatSurnom:=cxFormatSurnom.Text;
  if cxFormatSurnomF.Text>'' then
    gci_context.FormatSurnomF:=cxFormatSurnomF.Text
  else
    if cxFormatSurnom.Text>'' then
      gci_context.FormatSurnomF:=cxFormatSurnom.Text+'e';

  gci_context.OuvreHistoire:=chOuvreHistoire.Checked;

  if rbPatMaj.checked then
    gci_context.ModeSaisieNom:=mftUpper
  else if rbPatFirst.checked then
    gci_context.ModeSaisieNom:=mftFirstCharOfWordsIsMaj
  else
    gci_context.ModeSaisieNom:=mftNone;

  if rbPreMaj.checked then
    gci_context.ModeSaisiePrenom:=mftUpper
  else if rbPreFirst.checked then
    gci_context.ModeSaisiePrenom:=mftFirstCharOfWordsIsMaj
  else
    gci_context.ModeSaisiePrenom:=mftNone;

  gci_context.ColorHomme:=cpHommes.Value;
  gci_context.ColorFemme:=cpFemmes.Value;
  gci_context.ColorLight:=cpFondsColor.Value;
  gci_context.ColorMedium:=cpSelectionColor.Value;
  gci_context.ColorDark:=cpOngletsColor.Value;
  gci_context.ColorTexteOnglets:=cpTexteOngletsColor.Value;

  // Matthieu  : Les styles ont ?t? enlev?s
  {
  dm.StyleEnTeteJaune.Color:=gci_context.ColorDark;
  dm.StyleNoirNormaSurOcre.Color:=gci_context.ColorMedium;
  dm.StyleNavyGrasSurGris.Color:=gci_context.ColorDark;
  dm.cxStyleFemme.TextColor:=gci_context.ColorFemme;
  dm.cxStyleHomme.TextColor:=gci_context.ColorHomme;
   }
  gci_context.TauxCompressionJPeg:=TauxCompressJpeg.Value;
  gci_context.TailleFenetre:=seTailleFenetre.Value;

  gci_context.AgeMiniMariageHommes:=edH1.Value;
  gci_context.AgeMiniMariageFemmes:=edF1.Value;
  gci_context.AgeMaxiMariageHommes:=edH2.Value;
  gci_context.AgeMaxiMariageFemmes:=edF2.Value;
  gci_context.AgeMiniNaissanceEnfantHommes:=edH3.Value;
  gci_context.AgeMiniNaissanceEnfantFemmes:=edF3.Value;
  gci_context.AgeMaxiNaissanceEnfantHommes:=edH4.Value;
  gci_context.AgeMaxiNaissanceEnfantFemmes:=edF4.Value;
  gci_context.AgeMaxiAuDecesHommes:=edH6.Value;
  gci_context.AgeMaxiAuDecesFemmes:=edF6.Value;
  gci_context.EcartAgeEntreEpoux:=ed7.Value;
  gci_context.NbJourEntre2NaissancesNormales:=edH5.Value;

  gci_context.CoherenceActive:=cbActiveControl.checked;
  gci_context.AfficheCPdansListeEV:=cbAfficheCPdansListeEV.checked;
  gci_context.AfficheRegiondansListeEV:=cbAfficheRegiondansListeEV.checked;

  gci_context.CheckAgeMiniMariage:=CheckAgeMiniMariage.checked;
  gci_context.CheckAgeMaxiMariage:=CheckAgeMaxiMariage.checked;
  gci_context.CheckAgeMiniNaissanceEnfant:=CheckAgeMiniNaissanceEnfant.checked;
  gci_context.CheckAgeMaxiNaissanceEnfant:=CheckAgeMaxiNaissanceEnfant.checked;
  gci_context.CheckEsperanceVie:=CheckEsperanceVie.checked;
  gci_context.CheckEcartAgeEpoux:=CheckEcartAgeEpoux.checked;
  gci_context.CheckNbJourEntreNaissance:=CheckNbJourEntreNaissance.checked;

  gci_context.PathImportExport:=ExcludeTrailingPathDelimiter(slGEDCOMDir.Text);
  gci_context.PathDocs:=ExcludeTrailingPathDelimiter(edPathDocs.Text);

  gci_context.PathSauvegarde:=ExcludeTrailingPathDelimiter(Sauvegarde.Text);
  gci_context.PathQuiSontIls:=ExcludeTrailingPathDelimiter(QuiSontIls.Text);

  gci_context.Photos:=cbPhotos.Checked;
  gci_context.CanSeeHint:=cbShowHint.checked;
  gci_context.Backup:=chbBackup.Checked;
  gci_context.ShowExit:=chbExit.checked;
  gci_context.ArbreShowNbGeneration:=edArbreShowNbGeneration.Value;
  gci_context.RoueShowNbGeneration:=edRoueShowNbGeneration.Value;

  gci_context.AideSaisieRapideNom:=cbAideSaisieRapideNom.Checked;
  gci_context.AideSaisieRapidePrenom:=cbAideSaisieRapidePrenom.Checked;
  gci_context.AideSaisieRapideProf:=cbAideSaisieRapideProf.Checked;

  gci_context.CreationMARRConjoint:=cbCreationMARRConjoint.Checked;
  gci_context.CreationMARRParent:=cbCreationMARRParent.Checked;

  gci_context.VerifMAJ:=chVerifMaj.Checked;

  gci_context.Zoom:=cxseZoom.Value;

  if cxSatGeonames.Checked then
    gci_context.QuelSat:=1
  else if cxSatGoogle.Checked then
    gci_context.QuelSat:=0
  else if cxSatOSM.Checked then
    gci_context.QuelSat:=3
  else //if cxSatMapper.Checked then
    gci_context.QuelSat:=2;

  if (gci_context.UtilPARANCES<>edUtilPARANCES.Text)
  or (gci_context.PwUtilPARANCES<>edPwUtilPARANCES.Text)
  or (gci_context.RolePARANCES<>edRolePARANCES.Text) then
  begin
    gci_context.UtilPARANCES:=edUtilPARANCES.Text;
    gci_context.PwUtilPARANCES:=edPwUtilPARANCES.Text;
    gci_context.RolePARANCES:=edRolePARANCES.Text;
    dm.doClosePARANCES;
  end;
  if dm.doOpenPARANCES then
    if gci_context.PaysNom<>CBPays.Text then
    begin
      q:=TIBSQL.Create(self);
      try
        q.Database:=dm.IBBaseParam;
        q.Transaction:=dm.IBTransParam;
        q.SQL.Text:='select RPA_CODE from REF_PAYS where RPA_LIBELLE=:pays';
        q.Params[0].AsString:=CBPays.Text;
        q.ExecQuery;
        gci_context.Pays:=q.Fields[0].AsInteger;
        q.Close;
      finally
        q.Free;
      end;
    gci_context.PaysNom:=CBPays.Text;
  end;

  if cbLangage.Text<>gs_Lang then
  begin
    gs_Lang:=cbLangage.Text;
    FMain.doTranslate;
  end;

  gci_context.ShouldSave:=true;

  p_WriteReportsViewToIni(f_GetMemIniFile);
  p_writeScaleToIni(f_GetMemIniFile);
  fb_iniWriteFile(f_GetMemIniFile);
end;

procedure TFEditContext.SuperFormCreate(Sender:TObject);
const
  sDossier='Remarque: Les propriétés particulières à chaque base et à chaque dossier'
           +' sont accessibles dans la fiche de sélection du dossier.'+_CRLF
           +'Pour cette raison, le répertoire de base des images et fichiers attachés'
           +' doit être défini dans les propriétés particulières à chaque dossier,'
           +' menu Généalogies / Dossiers de la base / bouton Modifier/détails.';
begin
  OnFillFields:=SuperFormFillFields;
  OnFillProperties:=SuperFormFillProperties;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  MemoSauveAuto.Color:=Color;
  MemoVitesse.Color:=Color;
  Width:=654;
  {$IFDEF WINDOWS}
  ltaillefont .Visible:=False;
  seTailleFont.Visible:=False;
  {$ENDIF}
  cxPageControl1.ActivePageIndex:=0;
  lDossiers.Caption:=sDossier;
  gbSatellites.Hint:=rs_Hint_Usefull_sites_for_satellites_views;
  gbNouveauxLieux.Hint:=rs_Hint_Default_parameters_to_access_to_refering_base_are;
end;

procedure TFEditContext.QuiSontIlsPropertiesButtonClick(Sender:TObject;
  AButtonIndex:Integer);
var
  s:string;
begin
  s:=QuiSontIls.Text;
  if SelectRepertoire(rs_Select_dir_WhoAreThey_Directory,s) then
    QuiSontIls.Text:=s;
end;

procedure TFEditContext.SauvegardePropertiesButtonClick(Sender:TObject;
  AButtonIndex:Integer);
var
  s:string;
begin
  s:=Sauvegarde.Text;
  if SelectRepertoire(rs_Select_dir_Backup_directory,s,FMain) then
    Sauvegarde.Text:=s;
end;

procedure TFEditContext.edPathDocsPropertiesButtonClick(Sender:TObject;
  AButtonIndex:Integer);
var
  s:string;
begin
  s:=edPathDocs.Text;
  if SelectRepertoire(rs_Select_dir_Documents_Directory,s,FMain) then
    edPathDocs.Text:=s;
end;

procedure TFEditContext.slGEDCOMDirPropertiesButtonClick(Sender:TObject;
  AButtonIndex:Integer);
var
  s:string;
begin
  s:=slGEDCOMDir.Text;
  if SelectRepertoire(rs_Select_dir_GEDCOM_Directory,s,FMain) then
    slGEDCOMDir.Text:=s;
end;

procedure TFEditContext.cbAstroPropertiesChange(Sender:TObject);
begin
  rbSet0.Enabled:=cbAstro.Checked;
  rbSet1.Enabled:=cbAstro.Checked;
end;

procedure TFEditContext.chOuvreHistoireClick(Sender: TObject);
begin
  if (sender as TJvXPCheckBox).Checked then
    (sender as TJvXPCheckBox).Font.Color:=clRed
  else
    (sender as TJvXPCheckBox).Font.Color:=clWindowText;
end;

procedure TFEditContext.chbBackupClick(Sender:TObject);
begin
  chOuvreHistoireClick(sender);
  Label22.Visible:=chbBackup.Checked;
  MemoSauveAuto.Visible:=chbBackup.Checked;
end;

procedure TFEditContext.cbCalculParenteAutoMouseEnter(Sender:TObject);
begin
  bMessageActif:=true;
end;

procedure TFEditContext.cbCalculParenteAutoContextPopup(Sender:TObject;
  MousePos:TPoint;var Handled:Boolean);
begin
  if bMessageActif then
    MyMessageDlg(rs_Info_Ancestry_calculate+_CRLF
      +rs_Info_Turn_it_off_if_software_slows_down,mtInformation, [mbOK]);
  bMessageActif:=false;
end;

procedure TFEditContext.btInitColorFemmesClick(Sender:TObject);
var
  BaseB,BaseV,BaseR:integer;

  procedure decompose(Base:Integer);
  begin
    BaseB:=(Base and $00FF0000)shr 16;
    BaseV:=(Base and $0000FF00)shr 8;
    BaseR:=Base and $000000FF;
  end;

  function DefCouleur(Bleu,Vert,Rouge:Integer):Integer;
  begin
    if Bleu<0 then Bleu:=0;
    if Vert<0 then Vert:=0;
    if Rouge<0 then Rouge:=0;
    result:=(Bleu shl 16)or(Vert shl 8)or Rouge;
  end;

begin
  case TJvXPButton(sender).tag of
    0:cpFemmes.Value:=$008080FF;
    1:cpHommes.Value:=$00FF8000;
    2:cpFondsColor.Value:=$00C5E8F3;
    3:
      begin
        decompose(cpFondsColor.Value);
        cpSelectionColor.Value:=DefCouleur(BaseB-39,BaseV-14,BaseR-6);//$009EDAED;
      end;
    4:
      begin
        decompose(cpFondsColor.Value);
        cpOngletsColor.Value:=DefCouleur(BaseB-54,BaseV-34,BaseR-27);//$008FC6D8;
      end;
    5:cpTexteOngletsColor.Value:=$00000080;
  end;
end;

procedure TFEditContext.onDrawTabEx(AControl:TCustomTabControl;
  ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  // Matthieu : plus de tab main
  {
  if ATab.IsMainTab then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;}
end;

procedure TFEditContext.cbShowHintClick(Sender:TObject);
begin
  Application.ShowHint:=cbShowHint.checked;
end;

procedure TFEditContext.ValideRepertoire(Sender:TObject;
  var DisplayValue:Variant;var ErrorText:TCaption;var Error:Boolean);
var
  s:string;
begin
  s:=DisplayValue;
  if s='' then
  begin
    MyMessageDlg(rs_Error_this_Directory_must_have_a_name,mtError, [mbOK]);
  end
  else
  begin
    if not DirectoryExistsUTF8(s) then
    begin
      if MyMessageDlg(rs_Warning_directory_does_not_exists+_CRLF
        +rs_Do_you_create_it,mtWarning, [mbYes,mbNo])=mrYes then
        if not ForceDirectoriesUTF8(s) then
        begin
          Error:=true;
          ErrorText:=rs_Error_this_Directory_cannot_be_created;
        end;
    end;
  end;
end;

procedure TFEditContext.cbLangagePropertiesEditValueChanged(
  Sender: TObject);
begin
  if not fFill then
    LabLangage.Visible:=LabLangage.Caption<>gs_Lang;
end;

procedure TFEditContext.cbCreationMARRConjointClick(Sender: TObject);
begin
  if not cbCreationMARRConjoint.Checked then
    cbCreationMARRParent.Checked:=false;
  cbCreationMARRParent.Enabled:=cbCreationMARRConjoint.Checked;
end;

procedure TFEditContext.cbActiveControlPropertiesChange(Sender: TObject);
begin
  if fFill=false then
  begin
    CheckAgeMiniMariage.checked:=cbActiveControl.checked;
    CheckAgeMaxiMariage.checked:=cbActiveControl.checked;
    CheckAgeMiniNaissanceEnfant.checked:=cbActiveControl.checked;
    CheckAgeMaxiNaissanceEnfant.checked:=cbActiveControl.checked;
    CheckEsperanceVie.checked:=cbActiveControl.checked;
    CheckEcartAgeEpoux.checked:=cbActiveControl.checked;
    CheckNbJourEntreNaissance.checked:=cbActiveControl.checked;
  end;
end;

end.

