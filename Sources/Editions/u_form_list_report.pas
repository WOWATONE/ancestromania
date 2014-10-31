{-----------------------------------------------------------------------}

{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
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

unit u_form_list_report;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  shellapi, jpeg, u_comp_TFWPrint, TXComp, ppDBJIT, ppEndUsr, ppModule,
  raCodMod, ppCtrls, ppVar, ppBands, ppPrnabl, ppClass, ppCache, ppProd,
  ppComm, ppRelatv, ppDBPipe, daDataModule, ppTypes, ppRegion, ppSubRpt,
  ppStrtch, ppMemo, ppPrintr, ppParameter, TXRB, Mask, Windows,
{$ELSE}
  MaskEdit, LCLIntf,
{$ENDIF}
  U_FormAdapt, u_comp_TYLanguage, Dialogs, DB, RLReport, Menus,
  IBCustomDataSet, IBQuery, RLPreview, ExtCtrls, StdCtrls, u_buttons_flat,
  ExtJvXPCheckCtrls, ComCtrls, Controls, Classes, Forms,
  Printers, Spin, SysUtils, u_form_param_reports,
  u_objet_TState, u_objet_TCut, u_form_working,
  u_buttons_appli, u_buttons_speed,
  u_ancestropictimages, u_reports_components,
  U_OnFormInfoIni, u_scrollclones, fonctions_dialogs, IBDatabase;

type

  { TFListReport }

  TFListReport = class(TF_FormAdapt)
    Bevel3: TBevel;
    cb_papersize: TComboBox;
    ch_Portrait: TCheckBox;
    cp_Widths: TExtClonedPanel;
    FWRefresh: TFWRefresh;
    IBStringField1: TIBStringField;
    ImgChecks: TImageList;
    IntegerField1: TLongintField;
    ch_photo: TJvXPCheckbox;
    L_Width: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel4: TPanel;
    PDSEnfants: TFWPrintData;
    PDSEveConjoint: TFWPrintData;
    p_Width: TPanel;
    QCousinage: TIBQuery;
    QUnions: TIBQuery;
    QEvenements: TIBQuery;
    QStatNomPrenom: TIBQuery;
    QFiche: TIBQuery;
    QListeAlpha: TIBQuery;
    QAscendance: TIBQuery;
    QDescendance: TIBQuery;
    QDesPat: TIBQuery;
    QCousinageCLE_FICHE: TLongintField;
    QCousinageNOM: TIBStringField;
    QCousinagePRENOM: TIBStringField;
    QCousinageDATE_NAISSANCE: TIBStringField;
    QCousinageDATE_DECES: TIBStringField;
    QCousinageSEXE: TLongintField;
    QCousinageCLE_PERE: TLongintField;
    QCousinageCLE_MERE: TLongintField;
    QCousinageNOM_PERE: TIBStringField;
    QCousinagePRENOM_PERE: TIBStringField;
    QCousinageNOM_MERE: TIBStringField;
    QCousinagePRENOM_MERE: TIBStringField;
    QStatNomPrenomCOMBIEN: TLongintField;
    QStatNomPrenomNOM: TIBStringField;
    QStatPrenoms: TIBQuery;
    ppReport: TRLReport;
    ppDesigner: TRLReport;
    QAnniv: TIBQuery;
    QCouple: TIBQuery;
    QEnfantsCouple: TIBQuery;
    QEveCouple: TIBQuery;
    QAgePremiereUnion: TIBQuery;
    QLongevite: TIBQuery;
    QNbEnfantUnion: TIBQuery;
    QRecensement: TIBQuery;
    QDenombreAscendance: TIBQuery;
    QDenombreDescendance: TIBQuery;
    QEclair: TIBQuery;
    QGetNomPrenom: TIBQuery;
    Panel3: TPanel;
    Panel2: TPanel;
    Label37: TLabel;
    lNom: TLabel;
    Panel6: TPanel;
    Panel7: TPanel;
    p_config: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    btnConfig: TFWConfig;
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnPrint: TFWPrint;
    RLPreview: TRLPreview;
    rvPrinter: TRadioButton;
    rbPDF: TRadioButton;
    rbRTF: TRadioButton;
    rbTXT: TRadioButton;
    Panel8: TPanel;
    se_Width: TSpinEdit;
    spbPreviewFirst: TCSpeedButton;
    spbPreviewPrior: TSBPrior;
    spbPreviewNext: TSBNext;
    spbPreviewLast: TCSpeedButton;
    spbPreviewWidth: TCSpeedButton;
    spbPreview100Percent: TCSpeedButton;
    spbPreviewWhole: TCSpeedButton;
    mskPreviewPage: TMaskEdit;
    QAnnivNOM: TIBStringField;
    QAnnivPRENOM: TIBStringField;
    QAnnivADATE: TIBStringField;
    QAnnivANNEE: TLongintField;
    QAnnivEV_TYPE: TIBStringField;
    QAnnivSEXE: TLongintField;
    QEveIndi: TIBQuery;
    QMultimedia: TIBQuery;
    DSAnniv: TDataSource;
    DSCouple: TDataSource;
    DSCousinage: TDataSource;
    DSUnions: TDataSource;
    DSEvenements: TDataSource;
    DSStatNomPrenom: TDataSource;
    DSFiche: TDataSource;
    DSListeAlpha: TDataSource;
    DSDesPat: TDataSource;
    DSAscendance: TDataSource;
    DSDescendance: TDataSource;
    dsStatPrenoms: TDataSource;
    DSEnfantsCouple: TDataSource;
    DSEveCouple: TDataSource;
    DSAgePremiereUnion: TDataSource;
    DSLongevite: TDataSource;
    DSNbEnfantUnion: TDataSource;
    DSRecensement: TDataSource;
    DSDenombreAscendance: TDataSource;
    DSDenombreDescendance: TDataSource;
    DSEclair: TDataSource;
    DSOnclesTantes: TDataSource;
    DSEveIndi: TDataSource;
    DSMultimedia: TDataSource;
    dsProfessions: TDataSource;
    DSParentEnfants: TDataSource;
    DSEveConjoint: TDataSource;
    DSFratrie: TDataSource;
    DSEnfants: TDataSource;
    DSStatGraph: TDataSource;
    PDSAnniv: TFWPrintData;
    PDSCouple: TFWPrintData;
    PDSCousinage: TFWPrintData;
    PDSUnions: TFWPrintData;
    PDSEvenements: TFWPrintData;
    PDSStatNoms: TFWPrintData;
    PDSFiche: TFWPrintData;
    PDSListeAlpha: TFWPrintData;
    PDSDesPat: TFWPrintData;
    PDSAscendance: TFWPrintData;
    PDSDescendance: TFWPrintData;
    PDSStatPrenoms: TFWPrintData;
    PDSEnfantsCouple: TFWPrintData;
    PDSEveCouple: TFWPrintData;
    PDSAgePremiereUnion: TFWPrintData;
    PDSLongevite: TFWPrintData;
    PDSNbEnfantUnion: TFWPrintData;
    PDSRecensement: TFWPrintData;
    PDSDenombreAscendance: TFWPrintData;
    PDSDenombreDescendance: TFWPrintData;
    PDSEclair: TFWPrintData;
    PDSOnclesTantes: TFWPrintData;
    PDSEveIndi: TFWPrintData;
    PDSMultimedia: TFWPrintData;
    PDSProfessions: TFWPrintData;
    PDSParentEnfants: TFWPrintData;
    PDSFratrie: TFWPrintData;
    PDSStatGraph: TFWPrintData;
    rbHtml: TRadioButton;
    QFratrie: TIBQuery;
    QOnclesTantes: TIBQuery;
    QEnfants: TIBQuery;
    pRien: TPanel;
    Image2: TIASearch;
    Label4: TLabel;
    SaveDialogRTF: TSaveDialog;
    SaveDialogPDF: TSaveDialog;
    SaveDialogHTML: TSaveDialog;
    Language: TYLanguage;
    IBStatGraph: TIBQuery;
    IBQParentEnfants: TIBQuery;
    btnShowConfigBox: TFWConfig;
    s_tree: TSplitter;
    ppSystemVariable2: TRLSystemInfo;
    QEveConjoint: TIBQuery;
    QProfessions: TIBQuery;
    S_widths: TSplitter;
    TransactionPropre: TIBTransaction;
    TL: TTreeView;
    procedure cb_papersizeChange(Sender: TObject);
    procedure ch_photoClick(Sender: TObject);
    procedure ch_PortraitChange(Sender: TObject);
    procedure cp_WidthsCloningControl(Sender: TObject);
    procedure FWRefreshClick(Sender: TObject);
    procedure pRienClick(Sender: TObject);
    procedure SuperFormCreate(Sender: TObject);
    procedure spbPreviewFirstClick(Sender: TObject);
    procedure spbPreviewPriorClick(Sender: TObject);
    procedure spbPreviewNextClick(Sender: TObject);
    procedure spbPreviewLastClick(Sender: TObject);
    procedure mskPreviewPageKeyPress(Sender: TObject; var Key: char);
    procedure ppViewerPageChange(Sender: TObject);
    procedure spbPreviewWholeClick(Sender: TObject);
    procedure spbPreviewWidthClick(Sender: TObject);
    procedure spbPreview100PercentClick(Sender: TObject);
    procedure Nouveaurapport1Click(Sender: TObject);
    procedure option_EditReportClick(Sender: TObject);
    procedure ppDesignerClose(Sender: TObject; var Action: TCloseAction);
    procedure Ajouterunrapport1Click(Sender: TObject);
    procedure SuperFormRefreshControls(Sender: TObject);
    procedure SuperFormShowFirstTime(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure rvPrinterChange(Sender: TObject);
    procedure SuperFormDestroy(Sender: TObject);
    procedure rbPDFChange(Sender: TObject);
    procedure rbRTFChange(Sender: TObject);
    procedure rbTXTChange(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure TLChangeNode(Sender: TObject; OldNode, Node: TTreeNode);
    procedure btnShowConfigBoxClick(Sender: TObject);
    function ppJITPVariableGetFieldValue(aFieldName: string): variant;
    procedure rbHtmlChange(Sender: TObject);
    procedure ppDesignerShow(Sender: TObject);
    procedure SuperFormClose(Sender: TObject; var Action: TCloseAction);
    procedure SuperFormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: boolean);
    procedure SuperFormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: boolean);
    procedure TLClick(Sender: TObject);

  private
    fFill: TState;
    LFWPrint: TFWPrintData;
    fIDTypeReport: integer;
    fRelPathSaveReport: string;

    aFParamReports: TFParamReports;
    s_Nom: string;
    bShowingReport: boolean;
    bSosa: boolean;
    fCut: TCut;
    fFileName1, fFileName2, fFileName3: string;
    aFile: THandle;
    fAddEntete: boolean;
    i_Sexe: integer;
    FicheActive, NumDossier: integer;
    NomDossier: string;
    fOccupe: TFWorking;
    bOk: boolean;

    procedure ChargeMedias(const mode: integer);
    procedure doLoadIni;
    procedure doReportIndPhotos(const as_title: string);
    procedure doSaveColsWidths(const APrintData: TFWPrintData);
    procedure doShowColsWidths(const APrintData: TFWPrintData);
    procedure doShowReport(const TagReport: integer);
    procedure doWriteIni;
    function fi_getColWidthsCount(const APrintData: TFWPrintData): integer;
    function frep_getReport: TRLReport;
    procedure OnClickOnMenuItemReport(Sender: TObject);
//    procedure PreparePopup;
    function GetDefaultFileNameReportInContext(aIDReport: integer): string;
    procedure PreviewMedia(const as_title: string; const APriorReport: TRLReport);
    procedure SetDefaultFileNameReportInContext(aIDReport: integer; aFileName: string);
    function GetRelPathReport(aIDReport: integer): string;

    //    function GetPipeline:TppDBPipeline;
    procedure doPrepareReport(TagReport: integer);
    function GetFileNameReportForExport: boolean;
    procedure doExportReportInTextFile;
    procedure ExportATable(const Q: TIBQuery; aPathFileName: string);
    procedure doTryToShowReport;
    procedure doGetNom;
    procedure InitIndi;
    procedure doOpenWorking(sTexte: string);
    procedure doCloseWorking;
    procedure ShowAReport(const AFWPrint: TFWPrintData; const aTitle: string);
    procedure ShowReport;
    procedure ShowReportFamily(const SQLIndi, SQLFam, reqMediasIndi,
      reqMediasUnion: string);

  public
    bOkClose: boolean;

    procedure doRefreshReport;
    procedure Init;

  end;

implementation

uses u_dm, u_common_functions, u_common_ancestro, u_common_const,
  u_form_ask_name_files_to_export_report, u_form_main,
  fonctions_string, fonctions_init, fonctions_reports,
  fonctions_system, u_reports_rlcomponents,
  fonctions_proprietes,
  fonctions_file,
  u_genealogy_context, IBSQL, IBTable, FileUtil,
  u_common_ancestro_functions,
  u_form_report_fiche_ind, lazutf8classes,
  u_form_report_media;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}

{$ENDIF}
const
  CST_Anniv = 0;
  CST_FicheFamiliale = 1;
  CST_Interval = 2;
  CST_Eclair = 3;
  CST_FicheIndi = 4;
  CST_GraphStat = 5;

procedure TFListReport.doTryToShowReport;
var
  s: string;
begin
  bOkClose := False;
  doOpenWorking(rs_Please_Wait);
  try
    //On récupère le rapport défini dans le context
    s := gci_context.Path_Applis_Ancestro + _REL_PATH_REPORT +
      fRelPathSaveReport + GetDefaultFileNameReportInContext(fIDTypeReport);

    if FileExistsUTF8(s) { *Converted from FileExistsUTF8*  } then
    begin
      //on charge le rapport
      {
      ppReport.Template.FileName:=s;
      ppReport.Template.LoadFromFile;
      doPrepareReport(fIDTypeReport);

      aFParamReports.cbPhotosIndi.Checked:=True;
      aFParamReports.cbPhotos.Checked:=True;

      doShowReport(fIDTypeReport);}
    end
    else
      RLPreview.Visible := False;
  finally
    bOkClose := True;
    doCloseWorking;
  end;
  doRefreshControls;
end;

procedure TFListReport.doReportIndPhotos(const as_title: string);
begin
  FReportFicheInd.Free;
  FReportFicheInd := TFReportFicheInd.Create(Self);
  FReportFicheInd.RLTitle.Caption := as_Title;
end;

procedure TFListReport.ShowReportFamily(
  const SQLIndi, SQLFam, reqMediasIndi, reqMediasUnion: string);
var
  iConjoint: integer;
  AReport: TRLReport;
begin
  s_Nom := lNom.Caption;
  s_Nom := s_Nom + ' - FF';

  //          RLPreview.Report:=ppReport;
  bSosa := aFParamReports.cbSosaFam.Checked;
  // not needed
//  aFParamReports.btnShowConfigBox.Enabled :=
  //  aFParamReports.IBConjointsunion_clef.AsInteger > 0;

  if (aFParamReports.IBConjointsunion_clef.AsInteger > 0) and bOk then
  begin
    try
      QCouple.ParamByName('ACLE_UNION').AsInteger :=
        aFParamReports.IBConjointsunion_clef.AsInteger;
      QCouple.Open;
    except
      on E: Exception do
      begin
        ShowMessage(fs_RemplaceMsg(rs_Error_On_request, ['QCouple']) +
          _CRLF + _CRLF + E.Message);
        bOk := False;
      end;
    end;
    if bOk then
      try
        QEveCouple.ParamByName('CLE_FAMILLE').AsInteger :=
          aFParamReports.IBConjointsunion_clef.AsInteger;
        QEveCouple.Open;
      except
        on E: Exception do
        begin
          ShowMessage(fs_RemplaceMsg(rs_Error_On_request, ['QEveCouple']) +
            _CRLF + _CRLF + E.Message);
          bOk := False;
        end;
      end;

    if bOk then
      try
        if (aFParamReports.cbTous.Checked) and (i_Sexe = 2) then
          QEnfantsCouple.ParamByName('A_CLE_PERE').AsInteger := 0
        else
          QEnfantsCouple.ParamByName('A_CLE_PERE').AsInteger :=
            QCouple.FieldByName('A_EPOUX_CLE').AsInteger;

        if (aFParamReports.cbTous.Checked) and (i_Sexe = 1) then
          QEnfantsCouple.ParamByName('A_CLE_MERE').AsInteger := 0
        else
          QEnfantsCouple.ParamByName('A_CLE_MERE').AsInteger :=
            QCouple.FieldByName('A_EPOUSE_CLE').AsInteger;

        QEnfantsCouple.ParamByName('DOSSIER').AsInteger := NumDossier;
        QEnfantsCouple.Open;
      except
        on E: Exception do
        begin
          ShowMessage(fs_RemplaceMsg(rs_Error_On_request, ['QEnfantsCouple']) +
            _CRLF + _CRLF + E.Message);
          bOk := False;
        end;
      end;

    if bOk then
      try
        IBQParentEnfants.Open;
      except
        on E: Exception do
        begin
          ShowMessage(fs_RemplaceMsg(rs_Error_On_request, ['IBQParentEnfants']) +
            _CRLF + _CRLF + E.Message);
          bOk := False;
        end;
      end;

    if bOk then
      try
        QEveIndi.SQL.Text := 'select * from (' + SQLIndi;
        if (aFParamReports.cbTous.Checked) then
          QEveIndi.SQL.Add(SQLFam);
        QEveIndi.SQL.Add(')order by ev_ind_datecode NULLS LAST' +
          ',ev_ind_heure NULLS LAST,ref_eve_ecran');
        QEveIndi.ParamByName('i_clef').AsInteger := FicheActive;
        QEveIndi.Open;
      except
        on E: Exception do
        begin
          ShowMessage(fs_RemplaceMsg(rs_Error_On_request, ['QEveIndi']) +
            _CRLF + _CRLF + E.Message);
          bOk := False;
        end;
      end;

    if i_Sexe = 2
     then iConjoint := QCouple.FieldByName('A_EPOUX_CLE' ).AsInteger
     else iConjoint := QCouple.FieldByName('A_EPOUSE_CLE').AsInteger;

    if (iConjoint > 0) and bOk then
      try
        QEveConjoint.SQL.Text :=
          'select * from (' + SQLIndi +
          ')order by ev_ind_datecode NULLS LAST' +
          ',ev_ind_heure NULLS LAST,ref_eve_ecran';
        QEveConjoint.ParamByName('i_clef').AsInteger := iConjoint;
        QEveConjoint.Open;
      except
        on E: Exception do
        begin
          ShowMessage(fs_RemplaceMsg(rs_Error_On_request, ['QEveConjoint']) +
            _CRLF + _CRLF + E.Message);
          bOk := False;
        end;
      end;

    QMultimedia.SQL.Clear;

    if bOk then
    begin
      if (aFParamReports.cbTous.Checked) then
      begin
        try
          ChargeMedias(1);
        except
          ShowMessage(rs_Error_while_getting_medias);
          bOk := False;
        end;
        QMultimedia.SQL.Add(reqMediasIndi);
        QMultimedia.ParamByName('indi').AsInteger := FicheActive;
      end
      else
      begin
        try
          ChargeMedias(2);
        except
          ShowMessage(rs_Error_while_getting_medias);
          bOk := False;
        end;
        QMultimedia.SQL.Add(reqMediasUnion);
        QMultimedia.ParamByName('indi').AsInteger := FicheActive;
        QMultimedia.ParamByName('union').AsInteger :=
          aFParamReports.IBConjointsUNION_CLEF.AsInteger;
      end;
    end;
    if bOk then
      try
        QMultimedia.Open;
      except
        on E: Exception do
        begin
          ShowMessage(fs_RemplaceMsg(rs_Error_On_request, ['QMultimedia']) +
            _CRLF + _CRLF + E.Message);
          bOk := False;
        end;
      end;

    Screen.Cursor := crDefault;
    RLPreview.Visible := True;
    pRien.Visible := False;
    if bOk then
      try
        PDSEveIndi.DBTitle := LFWPrint.DBTitle;
        PDSEveIndi.AddPreview;
        AReport := PDSEveIndi.FormReport.RLReport;
        if not QEveConjoint.IsEmpty then
        begin
          PDSEveConjoint.DBTitle := PDSEveIndi.DBTitle;
          PDSEveConjoint.AddPreview;
          PDSEveConjoint.FormReport.RLReport.PriorReport := AReport;
          AReport := PDSEveConjoint.FormReport.RLReport;
        end;
        if not QEveCouple.IsEmpty then
        begin
          PDSEveCouple.DBTitle := PDSEveIndi.DBTitle;
          PDSEveCouple.AddPreview;
          PDSEveCouple.FormReport.RLReport.PriorReport := AReport;
          AReport := PDSEveCouple.FormReport.RLReport;
        end;
        if not QEveCouple.IsEmpty then
        begin
          doReportIndPhotos(PDSEveIndi.DBTitle);
          FReportFicheInd.SetDatasource(DSEnfantsCouple);
          FReportFicheInd.RLReport.PriorReport := AReport;
          AReport := FReportFicheInd.RLReport;
        end;
        PreviewMedia(LFWPrint.DBTitle, AReport);
        PDSEveIndi.FormReport.RLReport.Preview(RLPreview);

      except
        on E: Exception do
        begin
          ShowMessage(rs_Report_This_report_generated_an_error + #13#10 + e.Message);
          bOk := False;
        end;
      end;
  end
  else
  begin
    RLPreview.Visible := False;
    pRien.Visible := True;
  end;

  if not bOk then
  begin
    QMultimedia.Close;
    QEveConjoint.Close;
    QEveIndi.Close;
    IBQParentEnfants.Close;
    QEnfantsCouple.Close;
    QEveCouple.Close;
    QCouple.Close;
    aFParamReports.IBConjoints.Close;
  end;
end;

procedure TFListReport.ChargeMedias(const mode: integer);
const
  reqMediasTempIndi = 'insert into tq_medias (multi_clef,multi_path,multi_media)' +
    'select t.MP_MEDIA,m.multi_path,m.multi_media from' +
    '(select distinct MP_MEDIA from' + '(select p.MP_MEDIA' +
    ' FROM MEDIA_POINTEURS p' +
    ' WHERE p.mp_type_image=''I'' and p.MP_CLE_INDIVIDU=:indi' +
    ' union' + ' select p.MP_MEDIA' + ' FROM evenements_ind e' +
    ' inner join MEDIA_POINTEURS p on p.mp_type_image=''A'' and p.mp_table=''I'' and p.mp_pointe_sur=e.ev_ind_clef'
    + ' WHERE e.ev_ind_kle_fiche=:indi' + ' union' + ' select p.MP_MEDIA' +
    ' FROM t_union u' + ' inner join evenements_fam f on f.ev_fam_kle_famille=u.union_clef'
    + ' inner join MEDIA_POINTEURS p on p.mp_type_image=''A'' and p.mp_table=''F'' and p.mp_pointe_sur=f.ev_fam_clef'
    + '   and p.mp_cle_individu=:indi' +
    ' WHERE u.union_mari=:indi or u.union_femme=:indi' + ' union' +
    ' select p.MP_MEDIA' + ' FROM evenements_ind e' +
    ' inner join sources_record s on s.type_table=''I'' and s.data_id=e.ev_ind_clef' +
    ' inner join MEDIA_POINTEURS p on p.mp_type_image=''F'' and p.mp_pointe_sur=s.id' +
    ' WHERE e.ev_ind_kle_fiche=:indi' + ' union' + ' select p.MP_MEDIA' +
    ' FROM t_union u' + ' inner join evenements_fam f on f.ev_fam_kle_famille=u.union_clef'
    + ' inner join sources_record s on s.type_table=''F'' and s.data_id=f.ev_fam_clef'
    + ' inner join MEDIA_POINTEURS p on p.mp_type_image=''F'' and p.mp_pointe_sur=s.id'
    + '   and p.mp_cle_individu=:indi' +
    ' WHERE u.union_mari=:indi or u.union_femme=:indi))t' +
    ' inner join MULTIMEDIA m on m.MULTI_CLEF=t.MP_MEDIA';

  reqMediasTempUnion = 'insert into tq_medias (multi_clef,multi_path,multi_media)' +
    'select t.MP_MEDIA,m.multi_path,m.multi_media from' +
    '(select distinct MP_MEDIA from' + '(select p.MP_MEDIA' +
    ' FROM t_union u' +
    ' inner join evenements_fam f on f.ev_fam_kle_famille=u.union_clef'
    + ' inner join MEDIA_POINTEURS p on p.mp_type_image=''A'' and p.mp_table=''F'' and p.mp_pointe_sur=f.ev_fam_clef'
    + '   and p.mp_cle_individu=:indi' + ' WHERE u.union_clef=:union' +
    ' union' + ' select p.MP_MEDIA' + ' FROM t_union u' +
    ' inner join evenements_fam f on f.ev_fam_kle_famille=u.union_clef' +
    ' inner join sources_record s on s.type_table=''F'' and s.data_id=f.ev_fam_clef' +
    ' inner join MEDIA_POINTEURS p on p.mp_type_image=''F'' and p.mp_pointe_sur=s.id' +
    '   and p.mp_cle_individu=:indi' + ' WHERE u.union_clef=:union))t' +
    ' inner join MULTIMEDIA m on m.MULTI_CLEF=t.MP_MEDIA';

var
  q: TIBSQL;
  t: TIBTable;
  NomFich: string;
  MS, MS2: TMemoryStream;
begin
  q := TIBSQL.Create(self);
  try
    q.Database := dm.ibd_BASE;
    q.Transaction := TransactionPropre;
    q.SQL.Add('delete from tq_medias');
    //plus indispensable car le commitretaining vide la table temporaire
    q.ExecQuery;
    q.SQL.Clear;
    if mode = 1 then
    begin
      q.SQL.Add(reqMediasTempIndi);
      q.ParamByName('indi').AsInteger := FicheActive;
    end
    else
    begin
      q.SQL.Add(reqMediasTempUnion);
      q.ParamByName('indi').AsInteger := FicheActive;
      q.ParamByName('union').AsInteger :=
        aFParamReports.IBConjointsUNION_CLEF.AsInteger;
    end;
    try
      q.ExecQuery;
    except
      ShowMessage('erreur remplissage tq_medias');
    end;
  finally
    q.Free;
  end;
  t := TIBTable.Create(self);
  MS := TMemoryStream.Create;
  MS2 := TMemoryStream.Create;
  with t do
    try
      Database := dm.ibd_BASE;
      Transaction := TransactionPropre;
      TableName := 'TQ_MEDIAS';
      Open;
      First;
      while not EOF do
      begin
        NomFich := FieldByName('multi_path').AsString;
        if FichEstImage(NomFich) then
        begin
          if FileExistsUTF8(NomFich) { *Converted from FileExistsUTF8*  } then
          begin
            try
              if ComprImageInMS(NomFich, MS, MS2, True, 4096, 4096) then
              begin
                t.Edit;
                TBlobField(FieldByName('multi_media')).LoadFromStream(MS);
              end;
            except
              //erreur de chargement
            end;
          end;
          if TBlobField(FieldByName('multi_media')).BlobSize = 0 then
            Delete
          else
            Next;
        end
        else
          Delete;
      end;
      if State in [dsEdit] then
        Post;
    finally
      MS.Free;
      MS2.Free;
      Free;
    end;
end;

procedure TFListReport.doShowReport(const TagReport: integer);
const
  reqMediasIndi = 'select -2147483647 as ordre' + ',p.mp_clef' +
    ',m.multi_infos' + ',t.multi_media as multi_media_normale' +
    ',m.multi_memo' + ',m.multi_reduite as multi_media' +
    ',upper(right(m.multi_path,position(''.'' in reverse(m.multi_path))-1)) as extension'
    +
    ' FROM MEDIA_POINTEURS p' + ' inner join MULTIMEDIA m on p.MP_MEDIA=m.MULTI_CLEF'
    +
    ' inner join tq_medias t on t.multi_clef=p.MP_MEDIA' +
    ' WHERE p.mp_type_image=''I'' and p.MP_CLE_INDIVIDU=:indi' +
    ' union' + ' select e.ev_ind_datecode' + ',p.mp_clef' +
    ',m.multi_infos' + ',t.multi_media' + ',m.multi_memo' + ',m.multi_reduite' +
    ',upper(right(m.multi_path,position(''.'' in reverse(m.multi_path))-1))' +
    ' FROM evenements_ind e' +
    ' inner join MEDIA_POINTEURS p on p.mp_type_image=''A'' and p.mp_table=''I'' and p.mp_pointe_sur=e.ev_ind_clef'
    + ' inner join MULTIMEDIA m on p.MP_MEDIA=m.MULTI_CLEF' +
    ' inner join tq_medias t on t.multi_clef=p.MP_MEDIA' +
    ' WHERE e.ev_ind_kle_fiche=:indi' + ' union' + ' select f.ev_fam_datecode' +
    ',p.mp_clef' + ',m.multi_infos' + ',t.multi_media' + ',m.multi_memo' +
    ',m.multi_reduite' +
    ',upper(right(m.multi_path,position(''.'' in reverse(m.multi_path))-1))' +
    ' FROM t_union u' + ' inner join evenements_fam f on f.ev_fam_kle_famille=u.union_clef'
    + ' inner join MEDIA_POINTEURS p on p.mp_type_image=''A'' and p.mp_table=''F'' and p.mp_pointe_sur=f.ev_fam_clef'
    + '   and p.mp_cle_individu=:indi' +
    ' inner join MULTIMEDIA m on p.MP_MEDIA=m.MULTI_CLEF' +
    ' inner join tq_medias t on t.multi_clef=p.MP_MEDIA' +
    ' WHERE u.union_mari=:indi or u.union_femme=:indi' + ' union' +
    ' select e.ev_ind_datecode' + ',p.mp_clef' + ',m.multi_infos' +
    ',t.multi_media' + ',m.multi_memo' + ',m.multi_reduite' +
    ',upper(right(m.multi_path,position(''.'' in reverse(m.multi_path))-1))' +
    ' FROM evenements_ind e' +
    ' inner join sources_record s on s.type_table=''I'' and s.data_id=e.ev_ind_clef' +
    ' inner join MEDIA_POINTEURS p on p.mp_type_image=''F'' and p.mp_pointe_sur=s.id' +
    ' inner join MULTIMEDIA m on p.MP_MEDIA=m.MULTI_CLEF' +
    ' inner join tq_medias t on t.multi_clef=p.MP_MEDIA' +
    ' WHERE e.ev_ind_kle_fiche=:indi' + ' union' + ' select f.ev_fam_datecode' +
    ',p.mp_clef' + ',m.multi_infos' + ',t.multi_media' + ',m.multi_memo' +
    ',m.multi_reduite' +
    ',upper(right(m.multi_path,position(''.'' in reverse(m.multi_path))-1))' +
    ' FROM t_union u' + ' inner join evenements_fam f on f.ev_fam_kle_famille=u.union_clef'
    + ' inner join sources_record s on s.type_table=''F'' and s.data_id=f.ev_fam_clef'
    + ' inner join MEDIA_POINTEURS p on p.mp_type_image=''F'' and p.mp_pointe_sur=s.id'
    + '   and p.mp_cle_individu=:indi' +
    ' inner join MULTIMEDIA m on p.MP_MEDIA=m.MULTI_CLEF' +
    ' inner join tq_medias t on t.multi_clef=p.MP_MEDIA' +
    ' WHERE u.union_mari=:indi or u.union_femme=:indi' + ' order by 1 nulls last,2';

  reqMediasUnion = 'select f.ev_fam_datecode as ordre' + ',p.mp_clef' +
    ',m.multi_infos' + ',t.multi_media as multi_media_normale' +
    ',m.multi_memo' + ',m.multi_reduite as multi_media' +
    ',upper(right(m.multi_path,position(''.'' in reverse(m.multi_path))-1)) as extension'
    +
    ' FROM t_union u' + ' inner join evenements_fam f on f.ev_fam_kle_famille=u.union_clef'
    + ' inner join MEDIA_POINTEURS p on p.mp_type_image=''A'' and p.mp_table=''F'' and p.mp_pointe_sur=f.ev_fam_clef'
    + '   and p.mp_cle_individu=:indi' +
    ' inner join MULTIMEDIA m on p.MP_MEDIA=m.MULTI_CLEF' +
    ' inner join tq_medias t on t.multi_clef=p.MP_MEDIA' +
    ' WHERE u.union_clef=:union' + ' union' + ' select f.ev_fam_datecode' +
    ',p.mp_clef' + ',m.multi_infos' + ',t.multi_media' + ',m.multi_memo' +
    ',m.multi_reduite' +
    ',upper(right(m.multi_path,position(''.'' in reverse(m.multi_path))-1))' +
    ' FROM t_union u' + ' inner join evenements_fam f on f.ev_fam_kle_famille=u.union_clef'
    + ' inner join sources_record s on s.type_table=''F'' and s.data_id=f.ev_fam_clef'
    + ' inner join MEDIA_POINTEURS p on p.mp_type_image=''F'' and p.mp_pointe_sur=s.id'
    + '   and p.mp_cle_individu=:indi' +
    ' inner join MULTIMEDIA m on p.MP_MEDIA=m.MULTI_CLEF' +
    ' inner join tq_medias t on t.multi_clef=p.MP_MEDIA' +
    ' WHERE u.union_clef=:union' + ' order by 1 nulls last,2';

  SQLIndi = 'select e.ev_ind_kle_fiche'//événements individuels
    + ',e.ev_ind_type' + ',e.ev_ind_date_writen'
    //    +',e.ev_ind_date_year'
    //    +',e.ev_ind_date_mois'
    + ',e.ev_ind_datecode'
    //    +',e.ev_ind_date'
    + ',e.ev_ind_heure' + ',e.ev_ind_cp' + ',e.ev_ind_ville' +
    ',e.ev_ind_dept' + ',e.ev_ind_pays' + ',e.ev_ind_cause' +
    ',e.ev_ind_source' + ',e.ev_ind_comment' + ',e.ev_ind_description' +
    ',e.ev_ind_region' + ',e.ev_ind_subd' +
    ',coalesce(e.ev_ind_titre_event,r.ref_eve_lib_long) as ev_libelle' +
    ',e.ev_ind_insee' + ',i.nom' + ',i.prenom' +
    ',cast(coalesce(e.ev_ind_titre_event,r.ref_eve_lib_long)||'' : de ''||i.nom||'', ''||i.prenom as varchar(160)) as nom_complet'
    + ',i.sexe' + ',''IND'' as type_event' +
    ',iif(e.ev_ind_source is null,1,0) as source_vide' +
    ',iif(e.ev_ind_comment is null,1,0) as comment_vide' + ',r.ref_eve_ecran' +
    ' from individu i' + ' inner join evenements_ind e on e.ev_ind_kle_fiche=i.cle_fiche'
    + ' inner join dossier d on d.cle_dossier=i.kle_dossier' +
    ' inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type' +
    ' and r.ref_eve_langue=d.ds_langue' + ' where i.cle_fiche=:i_clef';

  SQLFam = ' union all'//ev fam du mari avec nom et prénom de la femme
    + ' select u.union_mari' + ',e.ev_fam_type' + ',e.ev_fam_date_writen'
    //    +',e.ev_fam_date_year'
    //    +',e.ev_fam_date_mois'
    + ',e.ev_fam_datecode'
    //    +',e.ev_fam_date'
    + ',e.ev_fam_heure' + ',e.ev_fam_cp' + ',e.ev_fam_ville' +
    ',e.ev_fam_dept' + ',e.ev_fam_pays' + ',e.ev_fam_cause' +
    ',e.ev_fam_source' + ',e.ev_fam_comment' + ',e.ev_fam_description' +
    ',e.ev_fam_region' + ',e.ev_fam_subd' +
    ',coalesce(e.ev_fam_titre_event,r.ref_eve_lib_long)' + ',e.ev_fam_insee' +
    ',f.nom' + ',f.prenom' +
    ',cast(substring(coalesce(e.ev_fam_titre_event,r.ref_eve_lib_long)||'' : de ''||m.nom||'', ''||m.prenom'
    + '||'' avec ''||f.nom||'', ''||f.prenom from 1 for 160) as varchar(160))' +
    ',0' + ',''FAM''' + ',iif(e.ev_fam_source is null,1,0)' +
    ',iif(e.ev_fam_comment is null,1,0)' + ',r.ref_eve_ecran' +
    ' from t_union u' + ' inner join individu m on m.cle_fiche=u.union_mari' +
    ' inner join dossier d on d.cle_dossier=m.kle_dossier' +
    ' inner join individu f on f.cle_fiche=u.union_femme' +
    ' inner join evenements_fam e on e.ev_fam_kle_famille=u.union_clef' +
    ' inner join ref_evenements r on r.ref_eve_lib_court=e.ev_fam_type' +
    ' and r.ref_eve_langue=d.ds_langue' + ' where u.union_mari=:i_clef' +
    ' union all'//ev fam de la femme avec nom et prénom du mari
    + ' select u.union_femme' + ',e.ev_fam_type' + ',e.ev_fam_date_writen'
    //    +',e.ev_fam_date_year'
    //    +',e.ev_fam_date_mois'
    + ',e.ev_fam_datecode'
    //    +',e.ev_fam_date'
    + ',e.ev_fam_heure' + ',e.ev_fam_cp' + ',e.ev_fam_ville' +
    ',e.ev_fam_dept' + ',e.ev_fam_pays' + ',e.ev_fam_cause' +
    ',e.ev_fam_source' + ',e.ev_fam_comment' + ',e.ev_fam_description' +
    ',e.ev_fam_region ' + ',e.ev_fam_subd' +
    ',coalesce(e.ev_fam_titre_event,r.ref_eve_lib_long)' + ',e.ev_fam_insee' +
    ',f.nom' + ',f.prenom' +
    ',cast(substring(coalesce(e.ev_fam_titre_event,r.ref_eve_lib_long)||'' : de ''||m.nom||'', ''||m.prenom'
    + '||'' avec ''||f.nom||'', ''||f.prenom from 1 for 160) as varchar(160))' +
    ',0' + ',''FAM''' + ',iif(e.ev_fam_source is null,1,0)' +
    ',iif(e.ev_fam_comment is null,1,0)' + ',r.ref_eve_ecran' +
    ' from t_union u' + ' inner join individu m on m.cle_fiche=u.union_femme' +
    ' inner join dossier d on d.cle_dossier=m.kle_dossier' +
    ' inner join individu f on f.cle_fiche=u.union_mari' +
    ' inner join evenements_fam e on e.ev_fam_kle_famille=u.union_clef' +
    ' inner join ref_evenements r on r.ref_eve_lib_court=e.ev_fam_type' +
    ' and r.ref_eve_langue=d.ds_langue' + ' where u.union_femme=:i_clef';

  SQLEnf = ' union all'//ev ind de l'enfant dont l'individu est le père
    + ' select e.cle_fiche' + ',ev.ev_ind_type' + ',ev.ev_ind_date_writen'
    //    +',ev.ev_ind_date_year'
    //    +',ev.ev_ind_date_mois'
    + ',ev.ev_ind_datecode'
    //    +',ev.ev_ind_date'
    + ',ev.ev_ind_heure' + ',ev.ev_ind_cp' + ',ev.ev_ind_ville' +
    ',ev.ev_ind_dept' + ',ev.ev_ind_pays' + ',ev.ev_ind_cause' +
    ',ev.ev_ind_source' + ',ev.ev_ind_comment' + ',ev.ev_ind_description' +
    ',ev.ev_ind_region' + ',ev.ev_ind_subd' +
    ',cast(''Naissance enfant'' as varchar(30))' + ',ev.ev_ind_insee' +
    ',e.nom' + ',e.prenom' + ',cast(substring(''Naissance de ''||e.nom||'', ''||e.prenom'
    + '||coalesce(''. Mère : ''||m.nom||'', ''||m.prenom,'''') from 1 for 160) as varchar(160))'
    + ',e.sexe' + ',''ENF''' + ',iif(ev.ev_ind_source is null,1,0)' +
    ',iif(ev.ev_ind_comment is null,1,0)' + ',0' + ' from individu e' +
    ' left join evenements_ind ev on ev.ev_ind_kle_fiche=e.cle_fiche' +
    ' and ev.ev_ind_type=''BIRT''' + ' left join individu m on m.cle_fiche=e.cle_mere' +
    ' where e.cle_pere=:i_clef' +
    ' union all'//ev ind de l'enfant dont l'individu est la mère
    + ' select e.cle_fiche' + ',ev.ev_ind_type' + ',ev.ev_ind_date_writen'
    //    +',ev.ev_ind_date_year'
    //    +',ev.ev_ind_date_mois'
    + ',ev.ev_ind_datecode'
    //    +',ev.ev_ind_date'
    + ',ev.ev_ind_heure' + ',ev.ev_ind_cp' + ',ev.ev_ind_ville' +
    ',ev.ev_ind_dept' + ',ev.ev_ind_pays' + ',ev.ev_ind_cause' +
    ',ev.ev_ind_source' + ',ev.ev_ind_comment' + ',ev.ev_ind_description' +
    ',ev.ev_ind_region' + ',ev.ev_ind_subd' +
    ',cast(''Naissance enfant'' as varchar(30))' + ',ev.ev_ind_insee' +
    ',e.nom' + ',e.prenom' + ',cast(substring(''Naissance de ''||e.nom||'', ''||e.prenom'
    + '||coalesce(''. Père : ''||p.nom||'', ''||p.prenom,'''') from 1 for 160) as varchar(160))'
    + ',e.sexe' + ',''ENF''' + ',iif(ev.ev_ind_source is null,1,0)' +
    ',iif(ev.ev_ind_comment is null,1,0)' + ',0' + ' from individu e' +
    ' left join evenements_ind ev on ev.ev_ind_kle_fiche=e.cle_fiche' +
    ' and ev.ev_ind_type=''BIRT''' + ' left join individu p on p.cle_fiche=e.cle_pere' +
    ' where e.cle_mere=:i_clef';

var
  k1, k2, k3, k: integer;
  sListeEclair: string;
begin
  Screen.Cursor := crHourGlass;

  try
{    RLPreview.Reset;
    RLPreview.PaintBox.Repaint;
 }
    QAscendance.Close;
    QFiche.Close;
    QDescendance.Close;
    QDesPat.Close;
    QListeAlpha.Close;
    QEvenements.Close;
    QUnions.Close;
    QCousinage.Close;
    QStatNomPrenom.Close;
    QStatPrenoms.Close;
    QAnniv.Close;
    QCouple.Close;
    QEnfantsCouple.Close;
    QEveCouple.Close;
    QAgePremiereUnion.Close;
    QLongevite.Close;
    QNbEnfantUnion.Close;
    QRecensement.Close;
    QDenombreAscendance.Close;
    QDenombreDescendance.Close;
    QEclair.Close;
    QMultimedia.Close;
    QEveIndi.Close;
    QFratrie.Close;
    QOnclesTantes.Close;
    QEnfants.Close;
    IBStatGraph.Close;
    IBQParentEnfants.Close;
    QEveConjoint.Close;

    pRien.BringToFront;

    doGetNom;
    bSosa := False;

    if TransactionPropre.Active then
      TransactionPropre.CommitRetaining;//exécution des fiches dans la transaction propre
    //car il n'y a que le commit de la transaction qui permet de vider la table temporaire
    //qui contient des champs Blob sur un serveur Windows. Sans celà, erreurs au remplissage suivant de la table.

    case TagReport of
      _REP_ASCENDANCE_COMPLET:
      begin
        s_Nom := lNom.Caption;
        s_Nom := s_Nom + ' - AC';

        //  RLPreview.Report:=ppReport;

        QAscendance.ParamByName('i_clef').AsInteger := FicheActive;
        QAscendance.ParamByName('i_parqui').AsInteger := 0;
        QAscendance.Open;
        RLPreview.Visible := not QAscendance.IsEmpty;
        pRien.Visible := QAscendance.IsEmpty;
        LFWPrint.ShowPreview;
      end;
      _REP_ASCENDANCE_PAR_HOMMES:
      begin
        s_Nom := lNom.Caption;
        s_Nom := s_Nom + ' - AH';

        //          RLPreview.Report:=ppReport;
        QAscendance.ParamByName('i_clef').AsInteger := FicheActive;
        QAscendance.ParamByName('i_parqui').AsInteger := 1;
        QAscendance.Open;
        RLPreview.Visible := not QAscendance.IsEmpty;
        pRien.Visible := QAscendance.IsEmpty;
        LFWPrint.ShowPreview;
      end;
      _REP_ASCENDANCE_PAR_FEMMES:
      begin
        s_Nom := lNom.Caption;
        s_Nom := s_Nom + ' - AF';

        //          RLPreview.Report:=ppReport;
        QAscendance.ParamByName('i_clef').AsInteger := FicheActive;
        QAscendance.ParamByName('i_parqui').AsInteger := 2;
        QAscendance.Open;
        RLPreview.Visible := not QAscendance.IsEmpty;
        pRien.Visible := QAscendance.IsEmpty;
        LFWPrint.ShowPreview;
      end;
      _REP_DESCENDANCE_COMPLET:
      begin
        s_Nom := lNom.Caption;
        s_Nom := s_Nom + ' - DC';

        //          RLPreview.Report:=ppReport;
        QDescendance.ParamByName('i_clef').AsInteger := FicheActive;
        QDescendance.Open;
        RLPreview.Visible := not QDescendance.IsEmpty;
        pRien.Visible := QDescendance.IsEmpty;
        LFWPrint.ShowPreview;
      end;
      _REP_DESCENDANCE_PATRONYMIQUE:
      begin
        s_Nom := lNom.Caption;
        s_Nom := s_Nom + ' - DP';

        //          RLPreview.Report:=ppReport;
        QDesPat.ParamByName('i_clef').AsInteger := FicheActive;
        QDesPat.Open;
        RLPreview.Visible := not QDesPat.IsEmpty;
        pRien.Visible := QDesPat.IsEmpty;
        LFWPrint.ShowPreview;
      end;
      _REP_LISTE_ALPHA_HOMME, _REP_LISTE_ALPHA_TOUS, _REP_LISTE_ALPHA_FEMME:
      begin

        //          RLPreview.Report:=ppReport;
        QListeAlpha.Params[0].AsInteger := NumDossier;
        case fIDTypeReport of
          _REP_LISTE_ALPHA_TOUS : QListeAlpha.Params[1].AsInteger := 0;
          _REP_LISTE_ALPHA_HOMME: QListeAlpha.Params[1].AsInteger := 1;
          _REP_LISTE_ALPHA_FEMME: QListeAlpha.Params[1].AsInteger := 2;
        end;
        LFWPrint.Columns[0].Visible := fIDTypeReport = _REP_LISTE_ALPHA_TOUS;
        QListeAlpha.Open;
        RLPreview.Visible := not QListeAlpha.IsEmpty;
        pRien.Visible := QListeAlpha.IsEmpty;
        LFWPrint.ShowPreview;
      end;

      _REP_LISTE_DIVERS_UNION:
      begin

        //          RLPreview.Report:=ppReport;
        QUnions.Params[0].AsInteger := NumDossier;
        QUnions.Open;
        RLPreview.Visible := not QUnions.IsEmpty;
        pRien.Visible := QUnions.IsEmpty;
        LFWPrint.ShowPreview;
        ;
      end;

      _REP_LISTE_DIVERS_ECLAIR:
      begin

        sListeEclair := gci_context.Path_Applis_Ancestro + _REL_PATH_REPORT +
          fRelPathSaveReport;

        QEclair.SQL.Text :=
          'select * from PROC_ETAT_ECLAIR(:I_DOSSIER,:I_SOSA,:A_VILLE) order by';

        if aFParamReports.chDept.Checked then
          QEclair.SQL.Add('pays,dept,');

        if aFParamReports.rbTrieParPatronyme.Checked then
          QEclair.SQL.Add('nom, ville')
        else
          QEclair.SQL.Add('pays,ville,nom');

        if aFParamReports.cbOnlySosaEclair.Checked then
          k := 1
        else
          k := 0;

        {  if aFParamReports.rbChoixUser.checked then
            sListeEclair:=ppReport.Template.FileName
          else
          begin
            if aFParamReports.chDept.Checked then
              if aFParamReports.rbTrieParPatronyme.checked then
                sListeEclair:=sListeEclair+'Liste_Eclair_par_Dept_Patronymes.rtm'
              else
                sListeEclair:=sListeEclair+'Liste_Eclair_par_Dept_Villes.rtm'
            else if aFParamReports.rbTrieParPatronyme.checked then
              sListeEclair:=sListeEclair+'Liste_Eclair_par_Patronymes.rtm'
            else
              sListeEclair:=sListeEclair+'Liste_Eclair_par_Villes.rtm';
          end;
         }
        //if not FileExistsUTF8(sListeEclair) { *Converted from FileExistsUTF8*  } then
        {  ShowMessage('Le rapport spécifié n''existe pas ...')
        else }
        begin
         {   ppReport.Template.FileName:=sListeEclair;
            ppReport.template.LoadFromFile;
//            RLPreview.Report:=ppReport;
         }
          QEclair.ParamByName('I_DOSSIER').AsInteger := NumDossier;
          QEclair.ParamByName('I_SOSA').AsInteger := k;
          QEclair.ParamByName('A_VILLE').AsString := aFParamReports.edVilleEclair.Text;
          QEclair.Open;

          RLPreview.Visible := not QEclair.IsEmpty;
          pRien.Visible := QEclair.IsEmpty;
          LFWPrint.ShowPreview;
          ;
        end;

        SetDefaultFileNameReportInContext(fIDTypeReport, ExtractFileName(sListeEclair));
      end;

      _REP_LISTE_DIVERS_EVENEMENT:
      begin

        //          RLPreview.Report:=ppReport;
        QEvenements.ParamByName('i_clef').AsInteger := NumDossier;
        QEvenements.Open;
        RLPreview.Visible := not QEvenements.IsEmpty;
        pRien.Visible := QEvenements.IsEmpty;
        LFWPrint.ShowPreview;
        ;
      end;
      _REP_LISTE_DIVERS_ANNIVERSAIRE:
      begin

        //          RLPreview.Report:=ppReport;

        //Requête
        if aFParamReports.cbAnniv_Naissance.Checked then
          k1 := 1
        else
          k1 := 0;
        if aFParamReports.cbAnniv_Deces.Checked then
          k2 := 1
        else
          k2 := 0;
        if aFParamReports.cbAnniv_Mariage.Checked then
          k3 := 1
        else
          k3 := 0;

        QAnniv.ParamByName('A_MOIS').AsInteger := aFParamReports.PickMonth.ItemIndex + 1;
        QAnniv.ParamByName('I_DOSSIER').AsInteger := NumDossier;
        QAnniv.ParamByName('GET_BIRT').AsInteger := k1;
        QAnniv.ParamByName('GET_DEAT').AsInteger := k2;
        QAnniv.ParamByName('GET_MARR').AsInteger := k3;
        QAnniv.Open;
        RLPreview.Visible := not QAnniv.IsEmpty;
        pRien.Visible := QAnniv.IsEmpty;
        LFWPrint.ShowPreview;
        ;
      end;
      _REP_LISTE_DIVERS_ENFANTS:
      begin
        s_Nom := lNom.Caption;
        s_Nom := s_Nom + ' - CO';

        //          RLPreview.Report:=ppReport;

        if (I_SEXE = 1) then
        begin
          QEnfants.Params[0].AsInteger := FicheActive;
          QEnfants.Params[1].AsInteger := 0;
        end
        else
        begin
          QEnfants.Params[0].AsInteger := 0;
          QEnfants.Params[1].AsInteger := FicheActive;
        end;

        QEnfants.Params[2].AsInteger := NumDossier;
        QEnfants.Open;
        RLPreview.Visible := not QEnfants.IsEmpty;
        pRien.Visible := QEnfants.IsEmpty;
        if ch_photo.Checked then
        begin
          doReportIndPhotos(LFWPrint.DBTitle);
          FReportFicheInd.SetDatasource(DSEnfants);
          FReportFicheInd.RLReport.Preview(RLPreview);
        end
        else
          LFWPrint.ShowPreview;
      end;
      _REP_LISTE_DIVERS_COUSINAGE:
      begin
        s_Nom := lNom.Caption;
        s_Nom := s_Nom + ' - CO';


        //          RLPreview.Report:=ppReport;
        QCousinage.Params[0].AsInteger := FicheActive;
        QCousinage.Open;
        RLPreview.Visible := not QCousinage.IsEmpty;
        pRien.Visible := QCousinage.IsEmpty;
        LFWPrint.ShowPreview;
        ;
      end;
      _REP_LISTE_DIVERS_FRATRIE:
      begin
        s_Nom := lNom.Caption;
        s_Nom := s_Nom + ' - FR';


        //          RLPreview.Report:=ppReport;
        QFratrie.Params[0].AsInteger := FicheActive;
        QFratrie.Open;
        RLPreview.Visible := not QFratrie.IsEmpty;
        pRien.Visible := QFratrie.IsEmpty;
        LFWPrint.ShowPreview;
        ;
      end;
      _REP_LISTE_DIVERS_ONCLES_TANTES:
      begin
        s_Nom := lNom.Caption;
        s_Nom := s_Nom + ' - OT';

        //          RLPreview.Report:=ppReport;
        QOnclesTantes.Params[0].AsInteger := FicheActive;
        QOnclesTantes.Open;
        RLPreview.Visible := not QOnclesTantes.IsEmpty;
        pRien.Visible := QOnclesTantes.IsEmpty;
        LFWPrint.ShowPreview;
        ;
      end;

      _REP_FICHE_INDIVIDUELLE:
      begin
        bOk := True;
        s_Nom := lNom.Caption;
        s_Nom := s_Nom + ' - FI';

        //          RLPreview.Report:=ppReport;
//        aFParamReports.btnShowConfigBox.Enabled := True;
        bSosa := aFParamReports.cbSosaIndi.Checked;
        QFiche.SQL.Clear;
        QFiche.SQL.Add('select * from PROC_ETAT_FICHE(:CLE_FICHE)');
        QFiche.ParamByName('CLE_FICHE').AsInteger := FicheActive;
        try
          QFiche.Open;
        except
          on E: Exception do
          begin
            ShowMessage(fs_RemplaceMsg(rs_Error_On_request, ['QFiche']) +
              _CRLF + _CRLF + E.Message);
            bOk := False;
          end;
        end;

        if bOk then
        begin
          QEveIndi.SQL.Text := 'select * from (' + SQLIndi;
          if aFParamReports.cbAvecMariages.Checked then
            QEveIndi.SQL.Text := QEveIndi.SQL.Text + SQLFam;
          if aFParamReports.cbAvecEnfants.Checked then
            QEveIndi.SQL.Text := QEveIndi.SQL.Text + SQLEnf;
          QEveIndi.SQL.Text :=
            QEveIndi.SQL.Text + ')order by ' +
            'ev_ind_datecode NULLS LAST,ev_ind_heure NULLS LAST,ref_eve_ecran';
          try
            QEveIndi.ParamByName('i_clef').AsInteger := FicheActive;
            QEveIndi.Open;
          except
            on E: Exception do
            begin
              ShowMessage(fs_RemplaceMsg(rs_Error_On_request, ['QEveIndi']) +
                _CRLF + _CRLF + E.Message);
              bOk := False;
            end;
          end;
        end;

        if bOk then
          try
            ChargeMedias(1);
          except
            ShowMessage(rs_Error_while_getting_medias);
            bOk := False;
          end;

        if bOk then
          try
            QMultimedia.SQL.Clear;
            QMultimedia.SQL.Add(reqMediasIndi);
            QMultimedia.ParamByName('indi').AsInteger := FicheActive;
            QMultimedia.Open;
          except
            on E: Exception do
            begin
              ShowMessage(fs_RemplaceMsg(rs_Error_On_request, ['QMultimedia']) +
                _CRLF + _CRLF + E.Message);
              bOk := False;
            end;
          end;

        RLPreview.Visible := not QFiche.IsEmpty;
        pRien.Visible := QFiche.IsEmpty;

        if bOk then
          try
            LFWPrint.AddPreview;
            PreviewMedia(LFWPrint.DBTitle, LFWPrint.FormReport.RLReport);
            LFWPrint.FormReport.RLReport.Preview(RLPreview);

          except
            on E: Exception do
            begin
              ShowMessage(rs_Report_This_report_generated_an_error + #13#10 + E.Message);
              bOk := False;
            end;
          end;
        if not bOk then
        begin
          QFiche.Close;
          QEveIndi.Close;
          QMultimedia.Close;
        end;
      end;

      _REP_FICHE_FAMILIALE: ShowReportFamily(
          SQLIndi, SQLFam, reqMediasIndi, reqMediasUnion);

      _REP_STAT_PATRONYME:
      begin
        RLPreview.Visible := True;


        //          RLPreview.Report:=ppReport;
        QStatNomPrenom.Params[0].AsInteger := NumDossier;
        QStatNomPrenom.Open;
        pRien.Visible := QStatNomPrenom.IsEmpty;
        LFWPrint.ShowPreview;
        ;
      end;
      _REP_STAT_PRENOM:
      begin

        //          RLPreview.Report:=ppReport;
        QStatPrenoms.Params[0].AsInteger := NumDossier;
        QStatPrenoms.Open;
        RLPreview.Visible := not QStatPrenoms.IsEmpty;
        pRien.Visible := QStatPrenoms.IsEmpty;
        LFWPrint.ShowPreview;
        ;
      end;
      _REP_STAT_PROFESSIONS:
      begin

        //   RLPreview.Report:=ppReport;
        QProfessions.Params[0].AsInteger := NumDossier;
        QProfessions.Open;
        RLPreview.Visible := not QProfessions.IsEmpty;
        pRien.Visible := QProfessions.IsEmpty;
        LFWPrint.ShowPreview;
        ;
      end;

      _REP_STAT_AGE_PREMIERE_UNION:
        with QAgePremiereUnion do
        begin

          //    RLPreview.Report:=ppReport;
          ParamByName('A_CLE_DOSSIER').AsInteger := NumDossier;
          if aFParamReports.cbLimitOnYear.Checked then
            ParamByName('LIMIT_ON_DATE').AsInteger := 1
          else
            ParamByName('LIMIT_ON_DATE').AsInteger := 0;
          if aFParamReports.cbLimitOnSosa.Checked then
            ParamByName('LIMIT_ON_SOSA').AsInteger := 1
          else
            ParamByName('LIMIT_ON_SOSA').AsInteger := 0;
          ParamByName('YEAR_FROM').AsInteger := aFParamReports.edYearFrom.Value;
          ParamByName('YEAR_TO').AsInteger := aFParamReports.edYearTo.Value;
          k := StrToIntDef(aFParamReports.edInterval.Text, 1);
          if k < 1 then
            k := 1;
          ParamByName('INTERVAL').AsInteger := k;
          Open;
          RLPreview.Visible := not IsEmpty;
          pRien.Visible := IsEmpty;
          LFWPrint.ShowPreview;
        end;
      _REP_STAT_LONGEVITE:
        with QLongevite do
        begin

          //     RLPreview.Report:=ppReport;
          ParamByName('A_CLE_DOSSIER').AsInteger := NumDossier;
          if aFParamReports.cbLimitOnYear.Checked then
            ParamByName('LIMIT_ON_DATE').AsInteger := 1
          else
            ParamByName('LIMIT_ON_DATE').AsInteger := 0;
          if aFParamReports.cbLimitOnSosa.Checked then
            ParamByName('LIMIT_ON_SOSA').AsInteger := 1
          else
            ParamByName('LIMIT_ON_SOSA').AsInteger := 0;
          ParamByName('YEAR_FROM').AsInteger := aFParamReports.edYearFrom.Value;
          ParamByName('YEAR_TO').AsInteger := aFParamReports.edYearTo.Value;
          k := StrToIntDef(aFParamReports.edInterval.Text, 1);
          if k < 1 then
            k := 1;
          ParamByName('INTERVAL').AsInteger := k;
          Open;
          RLPreview.Visible := not IsEmpty;
          pRien.Visible := IsEmpty;
          LFWPrint.ShowPreview;
        end;
      _REP_STAT_NB_ENFANT_UNION:
        with QNbEnfantUnion do
        begin

          //     RLPreview.Report:=ppReport;
          ParamByName('A_CLE_DOSSIER').AsInteger := NumDossier;
          if aFParamReports.cbLimitOnYear.Checked then
            ParamByName('LIMIT_ON_DATE').AsInteger := 1
          else
            ParamByName('LIMIT_ON_DATE').AsInteger := 0;
          if aFParamReports.cbLimitOnSosa.Checked then
            ParamByName('LIMIT_ON_SOSA').AsInteger := 1
          else
            ParamByName('LIMIT_ON_SOSA').AsInteger := 0;
          ParamByName('YEAR_FROM').AsInteger := aFParamReports.edYearFrom.Value;
          ParamByName('YEAR_TO').AsInteger := aFParamReports.edYearTo.Value;
          k := StrToIntDef(aFParamReports.edInterval.Text, 1);
          if k < 1 then
            k := 1;
          ParamByName('INTERVAL').AsInteger := k;
          Open;
          RLPreview.Visible := not IsEmpty;
          pRien.Visible := IsEmpty;
          LFWPrint.ShowPreview;
        end;
      _REP_STAT_RECENSEMENT:
        with QRecensement do
        begin

          //    RLPreview.Report:=ppReport;
          ParamByName('CLE_DOSSIER').AsInteger := NumDossier;
          if aFParamReports.cbLimitOnYear.Checked then
            ParamByName('LIMIT_ON_DATE').AsInteger := 1
          else
            ParamByName('LIMIT_ON_DATE').AsInteger := 0;
          if aFParamReports.cbLimitOnSosa.Checked then
            ParamByName('LIMIT_ON_SOSA').AsInteger := 1
          else
            ParamByName('LIMIT_ON_SOSA').AsInteger := 0;
          ParamByName('YEAR_FROM').AsInteger := aFParamReports.edYearFrom.Value;
          ParamByName('YEAR_TO').AsInteger := aFParamReports.edYearTo.Value;
          k := StrToIntDef(aFParamReports.edInterval.Text, 1);
          if k < 1 then
            k := 1;
          ParamByName('INTERVAL').AsInteger := k;
          ParamByName('LONGEVITE_H').AsInteger := gci_context.AgeMaxiAuDecesHommes;
          ParamByName('LONGEVITE_F').AsInteger := gci_context.AgeMaxiAuDecesFemmes;
          Open;
          RLPreview.Visible := not IsEmpty;
          pRien.Visible := IsEmpty;
          LFWPrint.ShowPreview;
          ;
        end;
      _REP_STAT_DENOMBREMENT_ASCENDANCE:
        with QDenombreAscendance do
        begin

          //    RLPreview.Report:=ppReport;
          Params[0].AsInteger := FicheActive;
          Open;
          RLPreview.Visible := not IsEmpty;
          pRien.Visible := IsEmpty;
          LFWPrint.ShowPreview;
          ;
        end;
      _REP_STAT_DENOMBREMENT_DESCENDANCE:
        with QDenombreDescendance do
        begin

          //  RLPreview.Report:=ppReport;
          ParamByName('A_CLE_FICHE').AsInteger := FicheActive;
          Open;
          RLPreview.Visible := not IsEmpty;
          pRien.Visible := IsEmpty;
          LFWPrint.ShowPreview;
          ;
        end;
      _REP_STAT_GRAPH_NAISS_DEPT:
        with IBStatGraph do
        begin
          with IBStatGraph do
          begin
            SQL.Text := 'select Count(0) as combien';
            case aFParamReports.rgStats.ItemIndex of
              0, 1: SQL.Add(
                  ',case when (ev_ind_dept is null or char_length(trim(ev_ind_dept))=0) '
                  + 'and (ev_ind_pays is null or char_length(trim(ev_ind_pays))=0) '
                  + 'then ''Département inconnu'' ' +
                  'when ev_ind_dept is null or char_length(trim(ev_ind_dept))=0 '
                  + 'then ''Département inconnu (''||upper(trim(ev_ind_pays))||'')'' '
                  + 'else trim(ev_ind_dept) end as dept' +
                  ',case when ev_ind_pays is null or char_length(trim(ev_ind_pays))=0 '
                  + 'then null else upper(trim(ev_ind_pays)) end as pays');
              else
                SQL.Add(',case when ev_ind_pays is null or char_length(trim(ev_ind_pays))=0 '
                  + 'then ''PAYS INCONNU'' else upper(trim(ev_ind_pays)) end as dept');
            end;
            SQL.Add('from evenements_ind where ev_ind_kle_dossier=' +
              IntToStr(NumDossier) + ' and ev_ind_type=');
            case aFParamReports.rgStats.ItemIndex of
              0, 2: SQL.Add('''BIRT''');
              else
                SQL.Add('''DEAT''');
            end;
            case aFParamReports.rgStats.ItemIndex of
              0, 1: SQL.Add('group by 3,2 order by 3 nulls last,2');
              else
                SQL.Add('group by 2 order by 2');
            end;
            Open;
          end;

          RLPreview.Visible := not IsEmpty;
          pRien.Visible := IsEmpty;
          LFWPrint.ShowPreview;
          ;
        end;

    end;
  finally
    Screen.Cursor := crDefault;

  end;
  if spbPreview100Percent.Down then
    spbPreview100Percent.Click
  else if spbPreviewWidth.Down then
    spbPreviewWidth.Click;
end;

procedure TFListReport.SuperFormCreate(Sender: TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime := SuperFormShowFirstTime;
  Color := gci_context.ColorLight;
  pRien.Color := gci_context.ColorLight;
  bShowingReport := False;
  // Matthieu ?
  //  TL.Styles.Selection.Color:=gci_context.ColorLight;

  Language.RessourcesFileName := _REL_PATH_TRADUCTIONS + _FileNameTraduction;
  Language.Translate;
  fIDTypeReport := -1;
  LFWPrint := nil;
  fFill := TState.Create(False);
  aFParamReports := TFParamReports.Create(self);
  fCut := TCut.Create;

  SaveDialogRTF.InitialDir := gci_context.PathDocs;
  SaveDialogPDF.InitialDir := gci_context.PathDocs;
  bOkClose := True;
  InitIndi;
  p_ReadReportsViewFromIni(f_GetMemIniFile);
end;

procedure TFListReport.FWRefreshClick(Sender: TObject);
begin
  ShowReport;
end;

procedure TFListReport.pRienClick(Sender: TObject);
begin

end;

procedure TFListReport.SuperFormDestroy(Sender: TObject);
begin
  QAscendance.Close;
  QFiche.Close;
  QDescendance.Close;
  QDesPat.Close;
  QListeAlpha.Close;
  QEvenements.Close;
  QUnions.Close;
  QCousinage.Close;
  QStatNomPrenom.Close;
  QStatPrenoms.Close;
  QAnniv.Close;
  QCouple.Close;
  QEnfantsCouple.Close;
  QEveCouple.Close;
  QAgePremiereUnion.Close;
  QLongevite.Close;
  QNbEnfantUnion.Close;
  QRecensement.Close;
  QDenombreAscendance.Close;
  QDenombreDescendance.Close;
  QEclair.Close;
  QMultimedia.Close;
  QEveIndi.Close;
  QFratrie.Close;
  QOnclesTantes.Close;
  QEnfants.Close;
  IBQParentEnfants.Close;
  QProfessions.Close;

  IBStatGraph.Close;
  fFill.Free;
  fCut.Free;
  RLPreview.Free;
  aFParamReports.Destroy;
end;

procedure TFListReport.PreviewMedia(const as_title: string;
  const APriorReport: TRLReport);
begin
  if QMultimedia.IsEmpty then
    Exit;
  FReportMedia.Free;
  FReportMedia := TFReportMedia.Create(Self);
  with FReportMedia do
  begin
    RLReport.PriorReport := APriorReport;
    RLTitle.Caption := as_title;
  end;
end;
    {
procedure TFListReport.PreparePopup;
var
  n: integer;
  item: TMenuItem;
  List: TStringlistUTF8;
  k: integer;
  FileNameReportInContext: string;
begin
  //Nettoyage du popup
  for n := popup_report.items.Count - 1 downto 6 do
    popup_report.items.Delete(n);

  //Construction du popup
  List := TStringlistUTF8.Create;
  try
    GetDirContent(gci_context.Path_Applis_Ancestro + _REL_PATH_REPORT +
      fRelPathSaveReport, List, '*.rtm');
    k := -1;
    FileNameReportInContext :=
      AnsiUpperCase(GetDefaultFileNameReportInContext(fIDTypeReport));
    for n := 0 to List.Count - 1 do
      if AnsiUpperCase(List[n]) = FileNameReportInContext then
        k := n;

    for n := 0 to List.Count - 1 do
    begin
      item := TMenuItem.Create(self);
      item.Caption := fRelPathSaveReport + List[n];

      if (n = 0) and (k = -1) then
        item.Checked := True
      else if (n = k) then
        item.Checked := True;

      item.OnClick := OnClickOnMenuItemReport;

      popup_report.items.add(item);
    end;

    option_EditReport.Enabled := (List.Count > 0);

  finally
    List.Free;
  end;
end;
    }
procedure TFListReport.spbPreviewFirstClick(Sender: TObject);
var
  Save_Cursor: TCursor;
begin
  Save_Cursor := Screen.Cursor;
  try
    Screen.Cursor := crHourglass;
    RLPreview.FirstPage;
  finally
    Screen.Cursor := Save_Cursor;
  end;
end;

procedure TFListReport.spbPreviewPriorClick(Sender: TObject);
var
  Save_Cursor: TCursor;
begin
  Save_Cursor := Screen.Cursor;
  try
    Screen.Cursor := crHourglass;
    RLPreview.PriorPage;
  finally
    Screen.Cursor := Save_Cursor;
  end;
end;

procedure TFListReport.spbPreviewNextClick(Sender: TObject);
var
  Save_Cursor: TCursor;
begin
  Save_Cursor := Screen.Cursor;
  try
    Screen.Cursor := crHourglass;
    RLPreview.NextPage;
  finally
    Screen.Cursor := Save_Cursor;
  end;
end;

procedure TFListReport.spbPreviewLastClick(Sender: TObject);
var
  Save_Cursor: TCursor;
begin
  Save_Cursor := Screen.Cursor;
  try
    Screen.Cursor := crHourglass;
    RLPreview.LastPage;
  finally
    Screen.Cursor := Save_Cursor;
  end;
end;

procedure TFListReport.mskPreviewPageKeyPress(Sender: TObject; var Key: char);
var
  liPage: longint;
begin
  if (Key = #13) then
  begin
    liPage := StrToInt(mskPreviewPage.Text);
    //    RLPreview.GotoPage(liPage);
  end;
end;

procedure TFListReport.ppViewerPageChange(Sender: TObject);
begin
  //  mskPreviewPage.Text:=IntToStr(RLPreview.AbsolutePageNo);
end;

procedure TFListReport.spbPreviewWholeClick(Sender: TObject);
begin
  RLPreview.ZoomMultiplePages;
end;

procedure TFListReport.spbPreviewWidthClick(Sender: TObject);
begin
  RLPreview.ZoomFullWidth;
end;

procedure TFListReport.spbPreview100PercentClick(Sender: TObject);
begin
  RLPreview.MultipleMode := False;
  RLPreview.ZoomFactor := 100;
end;

procedure TFListReport.OnClickOnMenuItemReport(Sender: TObject);
var
  s, p: string;
begin
  //On charge le rapport
  s := gci_context.Path_Applis_Ancestro + _REL_PATH_REPORT + TMenuItem(Sender).Caption;
  if FileExistsUTF8(s) { *Converted from FileExistsUTF8*  } then
  begin
    p := ExtractFileName(s);
    if AnsiUpperCase(p) <> AnsiUpperCase(GetDefaultFileNameReportInContext(
      fIDTypeReport)) then
      SetDefaultFileNameReportInContext(fIDTypeReport, p);
{
    ppReport.Template.FileName:=s;
    ppReport.Template.LoadFromFile;

    aFParamReports.rbChoixUser.checked:=True;
    aFParamReports.chDept.Checked:=False;
    aFParamReports.cbOnlySosaEclair.Checked:=False;
                                   }
    doShowReport(fIDTypeReport);
  end;
end;
procedure TFListReport.Nouveaurapport1Click(Sender: TObject);
var
  s: string;
begin
  {
  //On demande un nom de rapport
  s := GetRelPathReport(fIDTypeReport);
  if s > '' then
  begin
    SaveDialog.InitialDir := gci_context.Path_Applis_Ancestro + _REL_PATH_REPORT + s;
    SaveDialog.FileName := '';
    if SaveDialog.Execute then
    begin
      if FileExistsUTF8(SaveDialog.FileName)  then // *Converted from FileExistsUTF8*
      begin
        MyMessageDlg(rs_Warning_There_is_another_report_with_same_name, mtWarning,
          [mbOK], 0, self);
      end
      else
      begin
        ppReport.Reset;
        ppReport.Template.New;
        ppreport.Template.FileName:=SaveDialog.FileName;
        ppReport.Template.SaveToFile;

              //On relie les compos
        ppReport.DataPipeline:=GetPipeline;
        ppDesigner.report:=ppReport;

        //Affichage de l'éditeur
        //        ppDesigner.ShowModal;
      end;
    end;
  end;
end;
}

end;
procedure TFListReport.option_EditReportClick(Sender: TObject);
var
  n: integer;
  s: string;
begin
  {
  //On recherche l'item qui est check
  s := '';
  for n := 0 to popup_report.Items.Count - 1 do
    if popup_report.Items[n].Checked then
      s := _REL_PATH_REPORT + popup_report.Items[n].Caption;

  s := gci_context.Path_Applis_Ancestro + s;

  if FileExistsUTF8(s) then // *Converted from FileExistsUTF8*
  begin
    //     RLPreview.Report := nil;
    ppReport.Reset;
    ppreport.Template.FileName:=s;
    ppreport.Template.LoadFromFile;

      //On relie les compos
    ppReport.DataPipeline:=GetPipeline;
    ppDesigner.report:=ppReport;

      //Affichage de l'éditeur
    ppDesigner.Caption:='Editeur de rapport Ancestromania';
    ppDesigner.ShowModal;
  end;
  }
end;

procedure TFListReport.ppDesignerClose(Sender: TObject; var Action: TCloseAction);
begin
  //  if FileExistsUTF8(ppReport.Template.FileName) { *Converted from FileExistsUTF8*  } then
{  begin
      //est-il dans le bon répertoire ?
    if AnsiUpperCase(SetValidPathString(ExtractFilePath(ppReport.Template.FileName)))
      <>AnsiUpperCase(gci_context.Path_Applis_Ancestro+_REL_PATH_REPORT+fRelPathSaveReport) then
    begin
      if MyMessageDlg(rs_Confirm_adding_report,
        mtWarning, [mbYes,mbNo],0,self)=mrYes then
      begin
        if CopyFile(PChar(ppReport.Template.FileName),PChar(gci_context.Path_Applis_Ancestro+_REL_PATH_REPORT+fRelPathSaveReport+ExtractFileName(ppReport.Template.FileName)),true) then
        begin
          SetDefaultFileNameReportInContext(fIDTypeReport,ExtractFileName(ppReport.Template.FileName));
           //On rafraichit le rapport
          doTryToShowReport;
        end;
      end;
    end
    else //Il est dans le bon répertoire
    begin
      SetDefaultFileNameReportInContext(fIDTypeReport,ExtractFileName(ppReport.Template.FileName));
      //On rafraichit le rapport
      doTryToShowReport;
    end;
  end;    }
end;

function TFListReport.GetDefaultFileNameReportInContext(aIDReport: integer): string;
begin
  if (aIDReport >= 0) and (aIDReport <= _MAX_REP_PATH) then
    Result := gci_context.FileNameReport[aIDReport]
  else
    Result := '';
end;

procedure TFListReport.SetDefaultFileNameReportInContext(aIDReport: integer;
  aFileName: string);
begin
  if (aIDReport >= 0) and (aIDReport <= _MAX_REP_PATH) then
  begin
    gci_context.FileNameReport[aIDReport] := aFileName;
    gci_context.ShouldSave := True;
  end;
end;
procedure TFListReport.Ajouterunrapport1Click(Sender: TObject);
begin
  {
  OpenDialog.FileName := '';
  if OpenDialog.Execute then
  begin
    if AnsiUpperCase(SetValidPathString(ExtractFilePath(OpenDialog.FileName))) <>
      AnsiUpperCase(gci_context.Path_Applis_Ancestro + _REL_PATH_REPORT +
      fRelPathSaveReport) then
    begin
      if CopyFile(PChar(OpenDialog.FileName), PChar(
        gci_context.Path_Applis_Ancestro + _REL_PATH_REPORT + fRelPathSaveReport +
        ExtractFileName(OpenDialog.FileName)), True) then
      begin
        SetDefaultFileNameReportInContext(fIDTypeReport, ExtractFileName(
          OpenDialog.FileName));
        //On rafraichit le rapport
        doTryToShowReport;
      end;
    end;
  end;
  }
end;
procedure TFListReport.SuperFormRefreshControls(Sender: TObject);
begin
  btnConfig.Enabled := fIDTypeReport <> -1;
  btnPrint.Enabled := fIDTypeReport <> -1;
end;

procedure TFListReport.SuperFormShowFirstTime(Sender: TObject);
begin
  //  FMain.MemeMoniteur(self);
  btnShowConfigBox.Visible := False;
  aFParamReports.PtrListReport := self;
  Caption := rs_Caption_Print_out_documents;
  TL.FullExpand;
  doRefreshControls;
  doGetNom;
end;

procedure TFListReport.doGetNom;
begin
  lNom.Caption := '?';
  try
    with QGetNomPrenom do
      try
        Close;
        ParamByName('CLE_FICHE').AsInteger := FicheActive;
        Open;
        Last;
        First;
        if RecordCount = 1 then
        begin
          lNom.Caption := CoupeChaine(
            AssembleString([FieldByName('Nom').AsString,
            FieldByName('PRENOM').AsString]), lNom);
          i_Sexe := FieldByName('SEXE').AsInteger;
        end;
      finally
        Close;
      end;
  except
  end;
end;

function TFListReport.GetRelPathReport(aIDReport: integer): string;
begin
  if (aIDReport >= 0) and (aIDReport <= _MAX_REP_PATH) then
    Result := _REP_PATH_REPORT[aIDReport]
  else
    Result := '';
end;

function TFListReport.frep_getReport: TRLReport;
begin
  if ch_photo.Visible and ch_photo.Checked then
    case fIDTypeReport of
      _REP_LISTE_DIVERS_ENFANTS: Result := FReportFicheInd.RLReport;
      else
        Result := LFWPrint.FormReport.RLReport
    end
  else
    Result := LFWPrint.FormReport.RLReport;

end;

procedure TFListReport.btnPrintClick(Sender: TObject);
var
  suite: boolean;
  SaveDialog: TSaveDialog;
begin
  bOkClose := False;
  with frep_getReport do
    try
      if not rbTXT.Checked then
      begin
     { if Printer.Printers.Count = 0 then
      begin
        MyMessageDlg(rs_Error_None_printer_turned_on, mtError, [mbOK], 0, self);
      end
      else}
        begin
          if rbRTF.Checked then
          begin
            SaveDialogRTF.FileName := s_Nom + EXTENSION_RTF;
            SaveDialog := SaveDialogRTF;
          end
          else if rbPDF.Checked then
          begin
            SaveDialogPDF.FileName := s_Nom + EXTENSION_PDF;
            SaveDialog := SaveDialogPDF;
          end
          else if rbHTML.Checked then
          begin
            SaveDialogHTML.FileName := s_Nom + EXTENSION_HTM;
            SaveDialog := SaveDialogHTML;
          end
          else
            PreviewModal;

          if rbRTF.Checked or rbPDF.Checked or rbHtml.Checked then
          begin
            suite := SaveDialog.Execute;
            if suite then
              try
                RLPreview.Visible := False;

                SaveToFile(SaveDialog.FileName);
                p_OpenFileOrDirectory(SaveDialog.FileName);
              except
                on e: Exception do
                begin
                  WriteLn(rs_Error_Writing_is_forbidden_on_this_dir_or_device +
                    #13#10 + e.Message);
                  MyMessageDlg(rs_Error_Writing_is_forbidden_on_this_dir_or_device +
                    #13#10 + e.Message, mtError, [mbOK], Self);
                end;
              end;
          end;
        end;
      end
      else
      begin
        //selon le type de rapport, on demande des noms de fichier pour l'extraction
        if GetFileNameReportForExport then
        begin
          doExportReportInTextFile;
        end;
      end;
    finally
      bOkClose := True;
    end;
end;

procedure TFListReport.rvPrinterChange(Sender: TObject);
begin
  if not fFill.Value then
  begin
    fFill.Value := True;
    try
      rvPrinter.Checked := True;
      rbPDF.Checked := False;
      rbRTF.Checked := False;
      rbHtml.Checked := False;
      rbTXT.Checked := False;
    finally
      fFill.Value := False;
    end;
  end;
end;

procedure TFListReport.rbPDFChange(Sender: TObject);
begin
  if not fFill.Value then
  begin
    fFill.Value := True;
    try
      rvPrinter.Checked := False;
      rbPDF.Checked := True;
      rbRTF.Checked := False;
      rbHtml.Checked := False;
      rbTXT.Checked := False;
    finally
      fFill.Value := False;
    end;
  end;
end;

procedure TFListReport.rbRTFChange(Sender: TObject);
begin
  if not fFill.Value then
  begin
    fFill.Value := True;
    try
      rvPrinter.Checked := False;
      rbPDF.Checked := False;
      rbHtml.Checked := False;
      rbRTF.Checked := True;
      rbTXT.Checked := False;
    finally
      fFill.Value := False;
    end;
  end;
end;

procedure TFListReport.rbTXTChange(Sender: TObject);
begin
  if not fFill.Value then
  begin
    fFill.Value := True;
    try
      rvPrinter.Checked := False;
      rbPDF.Checked := False;
      rbRTF.Checked := False;
      rbHtml.Checked := False;
      rbTXT.Checked := True;
    finally
      fFill.Value := False;
    end;
  end;
end;

procedure TFListReport.rbHtmlChange(Sender: TObject);
begin
  if not fFill.Value then
  begin
    fFill.Value := True;
    try
      rvPrinter.Checked := False;
      rbPDF.Checked := False;
      rbRTF.Checked := False;
      rbHtml.Checked := True;
      rbTXT.Checked := False;
    finally
      fFill.Value := False;
    end;
  end;
end;

procedure TFListReport.btnConfigClick(Sender: TObject);
var
  p: tpoint;
begin
  //    fIDTypeReport := TControl(Sender).Tag;
  if fIDTypeReport <> -1 then
  begin

{    fRelPathSaveReport := GetRelPathReport(fIDTypeReport);
    preparePopup;

    //Ouverture du popup
    p.x := 0;
    p.y := 0;
    p := TControl(Sender).clienttoscreen(p);
    popup_report.popup(p.x, p.y + TControl(Sender).Height);}
  end;
end;

procedure TFListReport.TLChangeNode(Sender: TObject; OldNode, Node: TTreeNode);
var
  k: integer;
  Item: TTreeNode;
begin

  TL.Enabled := False;
  try
    if fFill.Value = False then
    begin
      fFill.Value := True;
      try
        if TL.Selected <> nil then
        begin
          Item := TL.Selected;
          try
{            k:=StrToInt(item.Texts[1]);

            if k<>fIDTypeReport then
            begin
              fIDTypeReport:=k;
              fRelPathSaveReport:=GetRelPathReport(fIDTypeReport);
              doRefreshControls;
              doTryToShowReport;
            end;       }
          except
          end;

        end;
      finally
        fFill.Value := False;
      end;
    end;

    doRefreshControls;
  finally
    TL.Enabled := True;
  end;
end;

                      {
function TFListReport.GetPipeline:TppDBPipeline;
begin
  case fIDTypeReport of
    _REP_ASCENDANCE_COMPLET:result:=ppDBAscendance;
    _REP_ASCENDANCE_PAR_HOMMES:result:=ppDBAscendance;
    _REP_ASCENDANCE_PAR_FEMMES:result:=ppDBAscendance;
    _REP_DESCENDANCE_COMPLET:result:=ppDBDescendance;
    _REP_DESCENDANCE_PATRONYMIQUE:result:=ppDBDesPat;
    _REP_LISTE_ALPHA_TOUS:result:=ppDBListeAlpha;
    _REP_LISTE_ALPHA_HOMME:result:=ppDBListeAlpha;
    _REP_LISTE_ALPHA_FEMME:result:=ppDBListeAlpha;
    _REP_LISTE_DIVERS_UNION:result:=ppDBUnions;
    _REP_LISTE_DIVERS_ECLAIR:result:=ppDBEclair;
    _REP_LISTE_DIVERS_EVENEMENT:result:=ppDBEvenements;
    _REP_LISTE_DIVERS_ANNIVERSAIRE:result:=ppDBAnniv;
    _REP_LISTE_DIVERS_ENFANTS:result:=ppDBEnfants;
    _REP_LISTE_DIVERS_FRATRIE:result:=ppDBFratrie;
    _REP_LISTE_DIVERS_ONCLES_TANTES:result:=ppDBOnclesTantes;
    _REP_LISTE_DIVERS_COUSINAGE:result:=ppDBCousinage;
    _REP_FICHE_INDIVIDUELLE:result:=ppDBFiche;
    _REP_FICHE_FAMILIALE:result:=ppDBCouple;
    _REP_STAT_PATRONYME:result:=ppDBStatNomPrenom;
    _REP_STAT_PRENOM:result:=ppDBStatPrenoms;
    _REP_STAT_AGE_PREMIERE_UNION:result:=ppDBAgePremiereUnion;
    _REP_STAT_LONGEVITE:result:=ppDBLongevite;
    _REP_STAT_NB_ENFANT_UNION:result:=ppDBNbEnfantUnion;
    _REP_STAT_RECENSEMENT:result:=ppDBRecensement;
    _REP_STAT_DENOMBREMENT_ASCENDANCE:result:=ppDBDenombreAscendance;
    _REP_STAT_DENOMBREMENT_DESCENDANCE:result:=ppDBDenombreDescendance;
    _REP_STAT_GRAPH_NAISS_DEPT:result:=ppDBStatGraph;
    _REP_STAT_PROFESSIONS:result:=ppDBProfessions;
    else
      result:=nil;
  end;
end;
     }
procedure TFListReport.btnShowConfigBoxClick(Sender: TObject);
begin
  aFParamReports.Show;
end;

procedure TFListReport.doRefreshReport;
begin
  InitIndi;
  ShowReport;
end;

procedure TFListReport.doPrepareReport(TagReport: integer);
var
  ExistConfig: boolean;
begin
  ExistConfig := True;
  //  ppReport.DataPipeline:=GetPipeline;

  case TagReport of
    _REP_STAT_GRAPH_NAISS_DEPT: aFParamReports.Notebook.PageIndex := CST_GraphStat;
    _REP_LISTE_DIVERS_ANNIVERSAIRE: aFParamReports.Notebook.PageIndex := CST_Anniv;
    _REP_LISTE_DIVERS_ECLAIR: aFParamReports.Notebook.PageIndex := CST_Eclair;
    _REP_FICHE_INDIVIDUELLE: aFParamReports.Notebook.PageIndex := CST_FicheIndi;
    _REP_FICHE_FAMILIALE:
    begin
      aFParamReports.Notebook.PageIndex := CST_FicheFamiliale;
      bOk := True;
      aFParamReports.IBConjoints.Close;
      aFParamReports.IBConjoints.Params[0].AsInteger := FicheActive;
      try
        aFParamReports.IBConjoints.Open;
      except
        on E: Exception do
        begin
          ShowMessage('Erreur sur la requête - IBConjoints' + _CRLF + _CRLF + E.Message);
          bOk := False;
        end;
      end;
    end;

    _REP_STAT_AGE_PREMIERE_UNION, _REP_STAT_LONGEVITE, _REP_STAT_NB_ENFANT_UNION,
    _REP_STAT_RECENSEMENT:
    begin
      aFParamReports.Notebook.PageIndex := CST_Interval;
    end;
    else
      ExistConfig := False;
  end;

  aFParamReports.Visible := ExistConfig;
  btnShowConfigBox.Visible := ExistConfig;

end;

function TFListReport.GetFileNameReportForExport: boolean;
var
  s: string;
  aFAskNameFilesToExportReport: TFAskNameFilesToExportReport;
begin
  Result := False;
  //Nom du rapport
  s := '';
  if TL.Selected <> nil then
  begin
    //s:=TL.seleFocusedNode.Texts[0];
  end;
  aFAskNameFilesToExportReport := TFAskNameFilesToExportReport.Create(self);
  try
    if fIDTypeReport = _REP_FICHE_FAMILIALE then
    begin//3 fichiers à demander
      aFAskNameFilesToExportReport.NbFileToAsk := 3;
      aFAskNameFilesToExportReport.lbFile1.Caption := rs_Caption_Couple;
      aFAskNameFilesToExportReport.lbFile2.Caption := rs_Caption_Couple_events;
      aFAskNameFilesToExportReport.lbFile3.Caption := rs_Caption_Couple_children;
    end
    else //un seul fichier à demander
      aFAskNameFilesToExportReport.NbFileToAsk := 1;

    if aFAskNameFilesToExportReport.ShowModal = mrOk then
    begin
      fFileName1 := aFAskNameFilesToExportReport.edNameFile1.Text;
      fFileName2 := aFAskNameFilesToExportReport.edNameFile2.Text;
      fFileName3 := aFAskNameFilesToExportReport.edNameFile3.Text;

      //EntÃªtes
      fAddEntete := aFAskNameFilesToExportReport.cbIncludeEntete.Checked;

      //SÃ©parateur de colonne
      if aFAskNameFilesToExportReport.rbPV.Checked then
        fCut.ParamSeparator := ';'
      else if aFAskNameFilesToExportReport.rbV.Checked then
        fCut.ParamSeparator := ','
      else if aFAskNameFilesToExportReport.rbTab.Checked then
        fCut.ParamSeparator := #9
      else if aFAskNameFilesToExportReport.rbAutre.Checked then
        fCut.ParamSeparator := aFAskNameFilesToExportReport.edAutreSep.Text;
      Result := True;
    end;
  finally
    aFAskNameFilesToExportReport.Free;
  end;
end;

procedure TFListReport.doExportReportInTextFile;
begin
  if fIDTypeReport = _REP_FICHE_FAMILIALE then
  begin
    ExportATable(QCouple, fFileName1);
    ExportATable(QEveCouple, fFileName2);
    ExportATable(QEnfantsCouple, fFileName3);
  end
  else
  if fIDTypeReport > -1 then
    ExportATable(TIBQuery(LFWPrint.Datasource.DataSet), fFileName1);
end;

procedure TFListReport.ExportATable(const Q: TIBQuery; aPathFileName: string);
var
  n: integer;
  s: string;
  ListParamName: TStringlistUTF8;
begin
  ListParamName := TStringlistUTF8.Create;
  try
    fCut.Params.Clear;
    s := '';
    //Récupération des champs
    for n := 0 to Q.FieldCount - 1 do
      if not (Q.Fields[n] is TBlobField) then
      begin
        if n > 0 then
          s := s + fCut.ParamSeparator;
        s := s + Q.Fields[n].FieldName;
        fCut.Params.CreateParam(Q.Fields[n].DataType, Q.Fields[n].FieldName,
          ptInputOutput);
        ListParamName.Add(Q.Fields[n].FieldName);
      end;
    //Maintenant, on connait les noms des paramètres
    if fCut.Params.Count > 0 then
    begin
      aFile := FileCreateUTF8(aPathFileName);
      try
        if fAddEntete then
          FileWriteln(aFile, s);
        Q.First;
        while (not Q.EOF) do
        begin
          for n := 0 to ListParamName.Count - 1 do
          begin
            s := Q.FieldByName(ListParamName[n]).AsString;
            RemoveStrFromString(s, fCut.ParamSeparator);
            fCut.Params[n].AsString := s;
          end;
          fCut.ParamsToStr;
          FileWriteLn(aFile, fCut.Line);
          Q.Next;
        end;
      finally
        FileClose(aFile);
      end;
    end;
  finally
    ListParamName.Free;
  end;
end;

function TFListReport.ppJITPVariableGetFieldValue(aFieldName: string): variant;
begin
  if aFieldName = 'I_PHOTOS' then
    if (aFParamReports.cbPhotos.Checked) then
      Result := 1
    else
      Result := 0;

  if aFieldName = 'I_PHOTOS_INDI' then
    if (aFParamReports.cbPhotosIndi.Checked) then
      Result := 1
    else
      Result := 0;

  if aFieldName = 'I_SOSA_INDI' then
    if (aFParamReports.cbSosaIndi.Checked) then
      Result := 1
    else
      Result := 0;

  if aFieldName = 'I_SOSA_FAM' then
    if (aFParamReports.cbSosaFam.Checked) then
      Result := 1
    else
      Result := 0;

  if aFieldName = 'I_TOUS_ENFANTS' then
    if (aFParamReports.cbTous.Checked) then
      Result := 1
    else
      Result := 0;

  if aFieldName = 'S_SEXE' then
    Result := i_Sexe;
  if aFieldName = 'S_PIED_PAGE' then
    Result := FMain.TitreAppli + ' - Dossier : ' + NomDossier +
      '  - Imprimé le : ' + FormatDateTime('dddd dd mmmm yyyy', date);
end;

// Get real printed columns count
// some columns are not visibles
function TFListReport.fi_getColWidthsCount(const APrintData: TFWPrintData): integer;
var
  i: integer;
begin
  Result := 0;
  with APrintData do
    for i := 0 to Columns.Count - 1 do
      with Columns[i] do
        if Visible then
        begin
          Inc(Result);
          if LineBreak > -1 then
            Exit;
        end;

end;

// setting links with controls created by component
procedure TFListReport.cp_WidthsCloningControl(Sender: TObject);
var
  i, counter: integer;
begin
  if LFWPrint = nil then
    Exit;
  with Sender as TControl do
  begin
    Counter := Tag;
    Tag := Tag div 1000;
    Counter := 1;
    with LFWPrint do
      for i := 0 to Columns.Count - 1 do
        if fb_IsVisibleAPrintedColumn(Columns[i]) then
        begin
          if ((Sender as TControl).Tag = Counter) then
            with Columns[i] do
            begin
              (Sender as TControl).Tag := i + 1;
              if Sender is TLabel then
                if DBTitle > '' then
                  (Sender as TLabel).Caption := DBTitle
                else
                  (Sender as TLabel).Caption := rs_Column_mini + IntToStr((Sender as TControl).Tag);
              Break;
            end;
          Inc(counter);
        end;
  end;
  if Sender is TSpinEdit then
    (Sender as TSpinEdit).MaxValue := se_Width.MaxValue;
end;

procedure TFListReport.ch_photoClick(Sender: TObject);
begin
  if ch_photo.Visible then
    ShowReport;
end;

procedure TFListReport.cb_papersizeChange(Sender: TObject);
begin
  if bShowingReport Then Exit;
  p_SetPageSetup(LFWPrint, cb_papersize.Text);
  ShowReport;
end;

procedure TFListReport.ch_PortraitChange(Sender: TObject);
begin
  if bShowingReport Then Exit;
  p_SetPageSetup(LFWPrint, ch_Portrait.Checked);
  ShowReport;
end;

// set modifying widths of columns
procedure TFListReport.doShowColsWidths(const APrintData: TFWPrintData);
var
  i, atemp: integer;

  procedure p_readIniWidth(const se_awidth: TSpinEdit;
  const APrintDataColumn: TExtPrintColumn);
  begin
    with APrintDataColumn do
    begin
      se_awidth.Value := f_IniReadSectionInt(CST_PRINT_INI_SECTION_REPORT,
        APrintData.Name + '.' + FieldName + IntToStr(se_awidth.Tag), Width);
      Width := se_awidth.Value;
    end;

  end;

begin
  cp_Widths.Reinit;
  cp_Widths.Cols := fi_getColWidthsCount(APrintData);
  if cp_Widths.Cols = 0 then
    Exit;
  with APrintData do
    for i := 0 to Columns.Count - 1 do
      if Columns[i].Visible then
      begin
        se_Width.Tag := i + 1;
        p_readIniWidth(se_Width, APrintData.Columns[i]);
        Break;
      end;
  with cp_Widths do
  begin
    for i := 0 to AutoControlCount - 1 do
    begin
      if AutoControls[i] is TSpinEdit then
      begin
        atemp := (AutoControls[i] as TControl).Tag - 1;
        if APrintData.Columns.Count > atemp then
          p_readIniWidth(AutoControls[i] as TSpinEdit,
            APrintData.Columns[atemp]);
      end;
    end;
    with PanelCloned do
      for i := 0 to ControlCount - 1 do
      begin
        if Controls[i] is TSpinEdit then
        begin
          atemp := (Controls[i] as TControl).Tag - 1;
          if APrintData.Columns.Count > atemp then
            p_readIniWidth(Controls[i] as TSpinEdit,
              APrintData.Columns[atemp]);
        end;
      end;
  end;
  doLoadIni;
end;

procedure TFListReport.doLoadIni;
var  ls_temp: string;
Begin
  ch_Portrait.Checked := f_IniReadSectionBol(CST_PRINT_INI_SECTION_REPORT,
    LFWPrint.Name+'.'+ch_Portrait.Name, LFWPrint.Orientation in [poPortrait, poReversePortrait]);
  WriteStr(ls_temp, fvar_getComponentProperty(LFWPrint, 'PaperSize'));
  cb_papersize.Text := f_IniReadSectionStr(CST_PRINT_INI_SECTION_REPORT,
    LFWPrint.Name+'.'+cb_papersize.Name, copy(ls_temp, 3, Length(ls_temp) - 2));
end;
procedure TFListReport.doWriteIni;
Begin
  if LFWPrint = nil
   Then Exit;
  p_IniWriteSectionBol(CST_PRINT_INI_SECTION_REPORT, LFWPrint.Name+'.'+ ch_Portrait.Name,
    ch_Portrait.Checked);
  p_IniWriteSectionStr(CST_PRINT_INI_SECTION_REPORT, LFWPrint.Name+'.'+cb_papersize.Name,
    cb_papersize.Text);
  fb_iniWriteFile(FIniFile, False);
end;

// saving printed widths columns in ini
procedure TFListReport.doSaveColsWidths(const APrintData: TFWPrintData);
var
  i: integer;

  procedure p_WriteIniWidth(const se_awidth: TSpinEdit;
  const APrintDataColumn: TExtPrintColumn);
  begin
    with APrintDataColumn do
    begin
      p_IniWriteSectionInt(CST_PRINT_INI_SECTION_REPORT, APrintData.Name +
        '.' + FieldName + IntToStr(se_awidth.Tag), se_awidth.Value);
    end;

  end;

begin
  if APrintData = nil then
    Exit;
  if cp_Widths.Cols = 0 then
    Exit;
  p_WriteIniWidth(se_Width, APrintData.Columns[se_Width.Tag - 1]);
  with cp_Widths do
  begin
    for i := 0 to AutoControlCount - 1 do
      if AutoControls[i] is TSpinEdit then
      begin
        p_WriteIniWidth(AutoControls[i] as TSpinEdit,
          APrintData.Columns[(AutoControls[i] as TControl).Tag - 1]);
      end;
    with PanelCloned do
      for i := 0 to ControlCount - 1 do
        if Controls[i] is TSpinEdit then
        begin
          p_WriteIniWidth(Controls[i] as TSpinEdit,
            APrintData.Columns[(Controls[i] as TControl).Tag - 1]);
        end;
  end;
  doWriteIni;
end;

// auto reports showing
procedure TFListReport.ShowAReport(const AFWPrint: TFWPrintData; const aTitle: string);
begin
  AFWPrint.Clear;
  case fIDTypeReport of
    _REP_LISTE_DIVERS_ENFANTS: with ch_photo do
      begin
        Visible := True;
        cp_widths.Visible := not Checked;
        S_widths.Visible := not Checked;
      end;
    else
    begin
      ch_photo.Visible := False;
      cp_Widths.Visible := True;
      S_widths.Visible := True;
    end;
  end;
  f_GetMemIniFile;
  doSaveColsWidths(LFWPrint);
  LFWPrint := AFWPrint;
  p_Width.Visible := True;
  LFWPrint.DBTitle := aTitle;
  doPrepareReport(fIDTypeReport);
  doShowReport(fIDTypeReport);
  doShowColsWidths(LFWPrint);
end;

procedure TFListReport.ShowReport;
var
  sNom: string;
begin
  sNom := lNom.Caption;
  p_Width.Visible := False;
  case fIDTypeReport of
    _REP_ASCENDANCE_COMPLET: ShowAReport(
        PDSAscendance, fs_RemplaceMsg(rs_Report_Ascending_of, [sNom]));
    _REP_ASCENDANCE_PAR_HOMMES: ShowAReport(
        PDSAscendance, fs_RemplaceMsg(rs_Report_Ascending_men_of, [sNom]));
    _REP_ASCENDANCE_PAR_FEMMES: ShowAReport(
        PDSAscendance, fs_RemplaceMsg(rs_Report_Ascending_women_of, [sNom]));
    _REP_DESCENDANCE_COMPLET: ShowAReport(PDSDescendance,
        fs_RemplaceMsg(rs_Report_Descent_of, [sNom]));
    _REP_DESCENDANCE_PATRONYMIQUE: ShowAReport(
        PDSDesPat, fs_RemplaceMsg(rs_Report_Surnames_Descent_of, [sNom]));
    _REP_LISTE_ALPHA_TOUS: ShowAReport(PDSListeAlpha, rs_Report_Alphabet_List);
    _REP_LISTE_ALPHA_HOMME: ShowAReport(PDSListeAlpha, rs_Report_Alphabet_List_by_men);
    _REP_LISTE_ALPHA_FEMME: ShowAReport(
        PDSListeAlpha, rs_Report_Alphabet_List_by_women);
    _REP_LISTE_DIVERS_UNION: ShowAReport(PDSUnions, rs_Report_Unions_List);
    _REP_LISTE_DIVERS_ECLAIR: ShowAReport(PDSEclair, rs_Report_Fast_List);
    _REP_LISTE_DIVERS_EVENEMENT: ShowAReport(PDSEvenements, rs_Report_Events_List);
    _REP_LISTE_DIVERS_ANNIVERSAIRE: ShowAReport(
        PDSAnniv, fs_RemplaceMsg(rs_Report_Birth_List_of_month,
        [aFParamReports.PickMonth.Text]));
    _REP_LISTE_DIVERS_ENFANTS: ShowAReport(
        PDSEnfants, fs_RemplaceMsg(rs_Report_Children_of, [sNom]));
    _REP_LISTE_DIVERS_FRATRIE: ShowAReport(
        PDSFratrie, fs_RemplaceMsg(rs_Report_Brothers_and_Sisters_of, [sNom]));
    _REP_LISTE_DIVERS_ONCLES_TANTES: ShowAReport(PDSOnclesTantes,
        fs_RemplaceMsg(rs_Report_Haunts_and_uncles_of, [sNom]));
    _REP_LISTE_DIVERS_COUSINAGE: ShowAReport(
        PDSCousinage, fs_RemplaceMsg(rs_Report_Cousins_of, [sNom]));
    _REP_FICHE_INDIVIDUELLE: ShowAReport(
        PDSEveIndi, fs_RemplaceMsg(rs_Report_Individual_file_of, [sNom]));
    _REP_STAT_PATRONYME: ShowAReport(PDSStatNoms, rs_Report_Surnames_List);
    _REP_STAT_PRENOM: ShowAReport(PDSStatPrenoms, rs_Report_Names_List);
    _REP_STAT_PROFESSIONS: ShowAReport(PDSProfessions, rs_Report_Jobs_List);
    _REP_STAT_AGE_PREMIERE_UNION: ShowAReport(PDSAgePremiereUnion,
        rs_Report_Ages_on_first_union);
    _REP_STAT_LONGEVITE: ShowAReport(PDSLongevite, rs_Report_Average_longevities);
    _REP_STAT_NB_ENFANT_UNION: ShowAReport(PDSNbEnfantUnion,
        rs_Report_Children_count_by_families);
    _REP_STAT_RECENSEMENT: ShowAReport(PDSRecensement,
        rs_Report_Identification_of_individuals);
    _REP_STAT_DENOMBREMENT_ASCENDANCE: ShowAReport(
        PDSDenombreAscendance, rs_Report_Counting_Ascending);
    _REP_STAT_DENOMBREMENT_DESCENDANCE: ShowAReport(
        PDSDenombreDescendance, rs_Report_Counting_Descent);
    _REP_FICHE_FAMILIALE: ShowAReport(
        PDSCouple, fs_RemplaceMsg(rs_Report_Family_file_of, [sNom]));
    _REP_STAT_GRAPH_NAISS_DEPT:
    begin
      case aFParamReports.rgStats.ItemIndex of
        0: ShowAReport(PDSStatGraph, rs_Report_Birthdays_by_department);
        1: ShowAReport(PDSStatGraph, rs_Report_Deathdays_by_department);
        2: ShowAReport(PDSStatGraph, rs_Report_Birthdays_by_countries);
        3: ShowAReport(PDSStatGraph, rs_Report_Deathdays_by_countries);
      end;
    end
  end;
end;

procedure TFListReport.ppDesignerShow(Sender: TObject);
begin
  ppDesigner.Caption := rs_Caption_Reports_editing;
end;


procedure TFListReport.SuperFormClose(Sender: TObject; var Action: TCloseAction);
begin
  if bOkClose then
  begin
    TransactionPropre.Active := False;
    Action := caFree;
    DoSendMessage(Owner, 'FERME_FORM_LIST_REPORT');
  end;
end;

procedure TFListReport.InitIndi;
begin
  NumDossier := dm.NumDossier;
  FicheActive := dm.individu_clef;
  NomDossier := fNomDossier;
end;

procedure TFListReport.Init;
begin
  InitIndi;
  btnShowConfigBox.Visible := False;
  TL.FullCollapse;
  TL.FullExpand;
  aFParamReports.Hide;
  doRefreshControls;
  doGetNom;
end;

procedure TFListReport.doCloseWorking;
begin
  FreeAndNil(fOccupe);
end;

procedure TFListReport.doOpenWorking(sTexte: string);
begin
  fOccupe := TFWorking.Create(self);
  CentreLaFiche(fOccupe, Self);
  fOccupe.doInit(sTexte);

end;

procedure TFListReport.SuperFormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: boolean);
var
  P: TPoint;
begin
  P := RLPreview.ScreenToClient(MousePos);
{  if (p.X>0)and(p.X<RLPreview.Width)and(p.Y>0)and(p.Y<RLPreview.Height)
    and (RLPreview.Report<>nil) and RLPreview.Visible then
  begin
    RLPreview.ScrollBy(0,1);
    RLPreview.Scroll(dtDown);
  end;}
end;

procedure TFListReport.SuperFormMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: boolean);
var
  P: TPoint;
begin
  P := RLPreview.ScreenToClient(MousePos);
{  if (p.X>0)and(p.X<RLPreview.Width)and(p.Y>0)and(p.Y<RLPreview.Height)
    and (RLPreview.Report<>nil) and RLPreview.Visible then
  begin
    RLPreview.ScrollBy(0,1);
    RLPreview.Scroll(dtUp);
  end;}
end;

procedure TFListReport.TLClick(Sender: TObject);
begin
  bShowingReport := True;
  with TL do
   try
    if (Selected <> nil) then
      if (Selected.Level > 0) then
      begin
        if Selected.SelectedIndex <> fIDTypeReport then
        begin
          fIDTypeReport := Selected.SelectedIndex;
          SuperFormRefreshControls(Self);
          if fIDTypeReport > -1 then
          begin
            ShowReport;
          end;
        end;
      end
      else
        with tl.selected do
          if Expanded then
            Collapse(False)
          else
            expand(False);

   finally
     bShowingReport := False;
   end;
end;

end.

































