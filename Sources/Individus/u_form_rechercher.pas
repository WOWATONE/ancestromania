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

unit u_form_rechercher;

interface

uses
  {$IFNDEF FPC}
    jpeg, CommCtrl, Windows,
  {$ELSE}
    LCLIntf, LCLType,
  {$ENDIF}
  U_FormAdapt,DB,u_comp_TYLanguage,
  Dialogs,Menus,IBCustomDataSet,
  IBQuery,StdCtrls,
  ExtCtrls,Controls,Classes,
  Forms,SysUtils,u_buttons_appli,ExtJvXPButtons,IBSQL,
  U_ExtDBGrid,ExtJvXPCheckCtrls,
  u_framework_components,
  PrintersDlgs,
  u_reports_components,
  u_ancestropictimages,
  U_OnFormInfoIni, u_extsearchedit,
  ComCtrls,VirtualTrees, Grids, DBGrids,
  Graphics, rxdbgrid;

type
  PIndivTree=^TIndivTree;
  TIndivTree=record
    DateNaiss,
    DateDeces,
    Nom,
    Prenom:string;
    cle,
    ImageIdx,
    sexe,
    sosa:integer;
  end;

  { TFRechercher }

  TFRechercher=class(TF_FormAdapt)
    dsRecherche:TDataSource;
    LabelParamDivers1: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    PopupMenuGrid:TPopupMenu;
    option_ExporterHTML:TMenuItem;
    Panel16:TPanel;
    Panel2:TPanel;
    Panel8:TPanel;
    Panel9:TPanel;
    dbgStd:TExtDBGrid;
    SaveDialog:TSaveDialog;
    lbNbIndiTrouve:TLabel;
    Panel11:TPanel;
    Panel7:TPanel;
    Label2:TLabel;
    Language:TYLanguage;
    dbgNotes:TExtDBGrid;
    IBSources:TIBQuery;
    dsSources:TDataSource;
    IBSourcesEV_IND_SOURCE:TMemoField;
    IBSourcesNOM:TIBStringField;
    IBSourcesPRENOM:TIBStringField;
    IBSourcesEV_IND_KLE_FICHE:TLongintField;
    IBSourcesEV_IND_VILLE:TIBStringField;
    IBSourcesSEXE:TLongintField;
    IBSourcesOU_CA:TIBStringField;
    IBSourcesNUM_SOSA:TFloatField;
    IBSourcesNUMRECORD:TLongintField;
    IBSourcesev_ind_date_year: TLongintField;
    IBSourcesDATE_NAISSANCE: TStringField;
    IBSourcesDATE_DECES: TStringField;
    Panel1:TPanel;
    Panel4:TPanel;
    pSTD:TPanel;
    Label1:TLabel;
    Label3:TLabel;
    Label4:TLabel;
    rbHomme:TRadioButton;
    rbFemme:TRadioButton;
    rbInconnu:TRadioButton;
    rbTous:TRadioButton;
    FlatPanel3:TPanel;
    rbNomCom:TRadioButton;
    rbNomCon:TRadioButton;
    FlatPanel2:TPanel;
    rbPrenomCom:TRadioButton;
    rbPrenom:TRadioButton;
    pNotes:TPanel;
    Label10:TLabel;
    Label16:TLabel;
    sNotes:TFWEdit;
    Splitter1: TSplitter;
    sSources:TFWEdit;
    Panel10:TPanel;
    Label7:TLabel;
    Label6:TLabel;
    Label8:TLabel;
    Label9:TLabel;
    Label13:TLabel;
    Label14:TLabel;
    Label15:TLabel;
    sECPNaissance:TFWEdit;
    sECPDeces:TFWEdit;
    sbRechercher:TFWSearch;
    sbClear:TFWErase;
    bsfbSelection:TFWOK;
    btnFermer:TFWClose;
    IBQRecherche:TIBQuery;
    IBQRechercheCLE_FICHE:TLongintField;
    IBQRechercheNOM:TIBStringField;
    IBQRecherchePRENOM:TIBStringField;
    IBQRechercheSEXE:TLongintField;
    IBQRechercheDATE_NAISSANCE:TIBStringField;
    IBQRechercheCP_NAISSANCE:TIBStringField;
    IBQRechercheLIEU_NAISSANCE:TIBStringField;
    IBQRecherchePAYS_NAISSANCE:TIBStringField;
    IBQRechercheDATE_DECES:TIBStringField;
    IBQRechercheCP_DECES:TIBStringField;
    IBQRechercheLIEU_DECES:TIBStringField;
    IBQRecherchePAYS_DECES:TIBStringField;
    IBQRechercheNUM_SOSA:TFloatField;
    IBQRechercheSUBD_NAISSANCE:TStringField;
    IBQRechercheSUBD_DECES:TStringField;
    IBQRechercheANNEE_NAISSANCE:TLongintField;
    IBQRechercheANNEE_DECES:TLongintField;
    IBQRechercheDEPT_NAISSANCE:TStringField;
    IBQRechercheDEPT_DECES:TStringField;
    IBQRechercheREGION_NAISSANCE:TStringField;
    IBQRechercheREGION_DECES:TStringField;
    IBQRechercheSURNOM:TStringField;
    Supprimerlestris:TMenuItem;
    cxSplitter1:TSplitter;
    N1:TMenuItem;
    PmGridNotes:TPopupMenu;
    mExportNotesHTML:TMenuItem;
    MenuItem2:TMenuItem;
    MenuItem11:TMenuItem;
    MenuItem12:TMenuItem;
    mEnvoirplussurlagrille:TMenuItem;
    sESubDeces:TFWEdit;
    Label11:TLabel;
    Label17:TLabel;
    sESubNaissance:TFWEdit;
    Label18:TIAInfo;
    IBQRechercheIND_CONFIDENTIEL:TSmallintField;
    mOuvrirlafiche:TMenuItem;
    N3:TMenuItem;
    Supprimerlafiche1:TMenuItem;
    Label20:TLabel;
    cbSosa:TJvXPCheckBox;
    IBSourcesIND_CONFIDENTIEL:TSmallintField;
    TabControlStdNotes:TTabControl;
    mOuvrirlaficheNotes:TMenuItem;
    LabelParamDivers:TLabel;
    pmParamDivers:TPopupMenu;
    mIndividuconfidentiel:TMenuItem;
    mSansalertesurdates:TMenuItem;
    mIdentiteIncertaine:TMenuItem;
    mContinuerRecherches:TMenuItem;
    btnPrint:TFWPrintGrid;
    ComponentPrinter:TPrinterSetupDialog;
    Label5:TLabel;
    Label19:TLabel;
    sENbrUnions:TFWEdit;
    seDateDeces:TFWEdit;
    seDateNe:TFWEdit;
    sESosa:TFWEdit;
    sEMetier:TExtSearchDBEdit;
    IBQProfession:TIBSQL;
    sEVilleNaissance:TExtSearchDBEdit;
    sEVilleDeces:TExtSearchDBEdit;
    sEPaysNaissance:TExtSearchDBEdit;
    sEPaysDeces:TExtSearchDBEdit;
    BarEtat:TStatusBar;
    PanelTV:TPanel;
    TVasc:TVirtualStringTree;
    cxSplitter3:TSplitter;
    TVdesc:TVirtualStringTree;
    PMasc:TPopupMenu;
    OuvreDepuisAsc:TMenuItem;
    PMdesc:TPopupMenu;
    OuvreDepuisDesc:TMenuItem;
    qAsc:TIBSQL;
    qDesc:TIBSQL;
    sENom:TExtSearchDBEdit;
    IBQNoms:TIBQuery;
    DSNoms:TDataSource;
    IBQPrenoms:TIBQuery;
    DSPrenoms:TDataSource;
    sEPrenom:TExtSearchDBEdit;
    procedure dbgStdGetCellProps(Sender: TObject; Field: TField; AFont: TFont;
      var Background: TColor);
    procedure IBQRechercheAfterScroll(DataSet: TDataSet);
    procedure sbRechercherClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure sbClearClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
    procedure option_ExporterHTMLClick(Sender:TObject);
    procedure PopupMenuGridPopup(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure bsfbSelectionClick(Sender:TObject);
    procedure TabControlStdNotesTabChanged(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure btnFermerClick(Sender:TObject);
    procedure SupprimerlestrisClick(Sender:TObject);
    procedure mEnvoirplussurlagrilleClick(Sender:TObject);
    procedure PmGridNotesPopup(Sender:TObject);
    procedure sSourcesKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure sNotesKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure Label18Click(Sender:TObject);
    procedure mOuvrirlaficheClick(Sender:TObject);
    procedure Supprimerlafiche1Click(Sender:TObject);
    procedure dbgNotesDBTableView1CellDblClick(
      Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure TabControlStdNotesDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
    procedure mOuvrirlaficheNotesClick(Sender:TObject);
    procedure LabelParamDiversClick(Sender:TObject);
    procedure mIndividuconfidentielClick(Sender:TObject);
    procedure IBSourcesCalcFields(DataSet:TDataSet);
    procedure DBTableViewFocusedRecordChanged(
      Sender:TObject;APrevFocusedRecord,
      AFocusedRecord:Longint;
      ANewItemRecordFocusingChanged:Boolean);
    procedure TVascClick(Sender:TObject);
    procedure TVascCollapsing(Sender:TObject;Node:PVirtualNode;
      var AllowCollapse:Boolean);
    procedure TVascExpanding(Sender:TObject;Node:PVirtualNode;
      var AllowExpansion:Boolean);
    procedure TVascGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure TVascGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure TVascPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure TVdescCollapsing(Sender:TObject;Node:PVirtualNode;
      var AllowCollapse:Boolean);
    procedure TVdescExpanding(Sender:TObject;Node:PVirtualNode;
      var AllowExpansion:Boolean);
    procedure TVascDblClick(Sender:TObject);
    procedure TVascMouseDown(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure TVascMouseMove(Sender:TObject;Shift:TShiftState;X,
      Y:Integer);
    procedure PMascPopup(Sender:TObject);
    procedure PMdescPopup(Sender:TObject);
    procedure OuvreDepuisAscClick(Sender:TObject);
    procedure dbgStdMouseEnter(Sender:TObject);
    procedure dbgStdMouseLeave(Sender:TObject);
    procedure dbgStdDBTableView1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure dbgNotesDBTableView1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
  private
    fCleFicheSelected:integer;
    NomIndiSelected,PrenomIndiSelected:string;
    SosaIndiSelected:Double;
    bDejaPasse,BloqueChange:boolean;
    NbrIndiTrouves,NbrSourcesTrouves:string;
    IndiTV:PIndivTree;
    XMouse:integer;
    bBloquExpand:boolean;
    procedure DoRechercher;
    procedure doSelect;
    procedure RempliTV;
    procedure EffacePageSources;
  protected
    procedure doShow; override;
  public
    //en retour (sinon -1)
    property CleFicheSelected:integer read fCleFicheSelected write fCleFicheSelected;

  end;

implementation

uses u_dm,
     u_form_main,
     u_common_functions,
     u_common_ancestro,u_common_const,
     u_genealogy_context,
     fonctions_components,
     fonctions_dialogs,
     u_common_ancestro_functions,
     fonctions_vtree,
     fonctions_proprietes,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFRechercher.sbRechercherClick(Sender:TObject);
begin
  DoRechercher;
end;

procedure TFRechercher.dbgStdGetCellProps(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor);
begin
  with (fobj_getComponentObjectProperty(Sender,CST_DBPROPERTY_DATASOURCE) as TDataSource).DataSet,AFont do
   Begin
      // Matthieu
    if not FieldByName('NUM_SOSA').IsNull
     then
      begin
        Style:=Style+ [fsBold];
        Color:=_COLOR_SOSA;
      end
      else
      begin
        Style:=Style- [fsBold];
        Color:=clWindowText;
      end;
    if FieldByName('IND_CONFIDENTIEL').AsInteger=1
      then Style:=Style+ [fsStrikeOut]
      else Style:=Style- [fsStrikeOut];
   end;
end;

procedure TFRechercher.IBQRechercheAfterScroll(DataSet: TDataSet);
begin
//  if DataSet.ControlsDisabled Then Exit;
  if DataSet = IBSources
    Then fCleFicheSelected := Dataset.FieldByName('EV_IND_KLE_FICHE').AsInteger
    Else fCleFicheSelected := Dataset.FieldByName('CLE_FICHE').AsInteger;
  RempliTV;
end;

procedure TFRechercher.DoRechercher;
const
  Req_Trouve_Notes='select e.ev_ind_comment as ev_ind_source'
    +',i.nom'
    +',i.prenom'
    +',i.date_naissance'
    +',i.date_deces'
    +',e.ev_ind_kle_fiche'
    +',e.ev_ind_ville'
    +',e.ev_ind_type as ou_ca'
    +',e.ev_ind_date_year'
    +',i.sexe'
    +',i.num_sosa'
    +',bin_and(i.ind_confidentiel,'+_s_IndiConf+') as ind_confidentiel'
    +' from evenements_ind e'
    +' inner join individu i on i.cle_fiche = e.ev_ind_kle_fiche'
    +' where e.ev_ind_kle_dossier=:idossier'
    +' and upper(e.ev_ind_comment) like upper(:ssource)'
    +' union all'
    +' select e.ev_fam_comment'
    +',i.nom'
    +',i.prenom'
    +',i.date_naissance'
    +',i.date_deces'
    +',u.union_mari'
    +',e.ev_fam_ville'
    +',e.ev_fam_type'
    +',e.ev_fam_date_year'
    +',i.sexe'
    +',i.num_sosa'
    +',bin_and(i.ind_confidentiel,'+_s_IndiConf+')'
    +' from evenements_fam e'
    +' inner join t_union u on u.union_clef=e.ev_fam_kle_famille'
    +' inner join individu i on i.cle_fiche=u.union_mari'
    +' where e.ev_fam_kle_dossier=:idossier'
    +' and upper(e.ev_fam_comment) like upper(:ssource)'
    +' union all'
    +' select u.comment'
    +',i.nom'
    +',i.prenom'
    +',i.date_naissance'
    +',i.date_deces'
    +',u.union_mari'
    +',cast('''' as varchar(50))'
    +',cast(''UNION'' as varchar(7))'
    +',(select first(1) ev_fam_date_year from evenements_fam where ev_fam_kle_famille=u.union_clef'
        +' order by ev_fam_date_year nulls last)'
    +',i.sexe'
    +',i.num_sosa'
    +',bin_and(i.ind_confidentiel,'+_s_IndiConf+')'
    +' from t_union u'
    +' inner join individu i on i.cle_fiche=u.union_mari'
    +' where u.kle_dossier =:idossier'
    +' and upper(u.comment) like upper(:ssource)'
    +' union all'
    +' select comment'
    +',nom'
    +',prenom'
    +',date_naissance'
    +',date_deces'
    +',cle_fiche'
    +',cast('''' as varchar(50))'
    +',cast(''INFO'' as varchar(7))'
    +',annee_naissance'
    +',sexe'
    +',num_sosa'
    +',bin_and(i.ind_confidentiel,'+_s_IndiConf+')'
    +' from individu i'
    +' where kle_dossier=:idossier'
    +' and upper(comment) like upper(:ssource)'
    +' order by 2,3';

  Req_Trouve_Sources='select e.ev_ind_source'
    +',i.nom'
    +',i.prenom'
    +',i.date_naissance'
    +',i.date_deces'
    +',e.ev_ind_kle_fiche'
    +',e.ev_ind_ville'
    +',e.ev_ind_type as ou_ca'
    +',e.ev_ind_date_year'
    +',i.sexe'
    +',i.num_sosa'
    +',bin_and(i.ind_confidentiel,'+_s_IndiConf+') as ind_confidentiel'
    +' from evenements_ind e'
    +' inner join individu i on i.cle_fiche = e.ev_ind_kle_fiche'
    +' where e.ev_ind_kle_dossier=:idossier'
    +' and upper(e.ev_ind_source) like upper(:ssource)'
    +' union all'
    +' select e.ev_fam_source'
    +',i.nom'
    +',i.prenom'
    +',i.date_naissance'
    +',i.date_deces'
    +',u.union_mari'
    +',e.ev_fam_ville'
    +',e.ev_fam_type'
    +',e.ev_fam_date_year'
    +',i.sexe'
    +',i.num_sosa'
    +',bin_and(i.ind_confidentiel,'+_s_IndiConf+')'
    +' from evenements_fam e'
    +' inner join t_union u on u.union_clef=e.ev_fam_kle_famille'
    +' inner join individu i on i.cle_fiche=u.union_mari'
    +' where e.ev_fam_kle_dossier=:idossier'
    +' and upper(e.ev_fam_source) like upper(:ssource)'
    +' union all'
    +' select u.source'
    +',i.nom'
    +',i.prenom'
    +',i.date_naissance'
    +',i.date_deces'
    +',u.union_mari'
    +',cast('''' as varchar(50))'
    +',cast(''UNION'' as varchar(7))'
    +',(select first(1) ev_fam_date_year from evenements_fam where ev_fam_kle_famille=u.union_clef'
        +' order by ev_fam_date_year nulls last)'
    +',i.sexe'
    +',i.num_sosa'
    +',bin_and(i.ind_confidentiel,'+_s_IndiConf+')'
    +' from t_union u'
    +' inner join individu i on i.cle_fiche=u.union_mari'
    +' where u.kle_dossier =:idossier'
    +' and upper(u.source) like upper(:ssource)'
    +' union all'
    +' select source'
    +',nom'
    +',prenom'
    +',date_naissance'
    +',date_deces'
    +',cle_fiche'
    +',cast('''' as varchar(50))'
    +',cast(''INFO'' as varchar(7))'
    +',annee_naissance'
    +',sexe'
    +',num_sosa'
    +',bin_and(i.ind_confidentiel,'+_s_IndiConf+')'
    +' from individu i'
    +' where kle_dossier=:idossier'
    +' and upper(source) like upper(:ssource)'
    +' order by 2,3';

var
  s:string;
  i_Sexe:Integer;
  i_Sosa:int64;
  s_Naiss,s_Deces,s_NbrUnions:string;
  Save_Cursor:TCursor;
begin
  Save_Cursor:=Screen.Cursor;
  Screen.Cursor:=crHourglass;
  BarEtat.Panels[0].Text:='';
  BloqueChange:=true;

  if pNotes.Visible then
  with IBSources do
  begin
    DisableControls;
    Close;
    SQL.Clear;

    if Length(sSources.Text)>0 then
    begin
      SQL.Add(Req_Trouve_Sources);
      ParamByName('IDOSSIER').AsInteger:=dm.NumDossier;
      ParamByName('SSOURCE').AsString:='%'+sSources.Text+'%';
      Open;
      Last;
      First;
      case RecordCount of
        0:NbrSourcesTrouves:='Aucune source trouvée';
        1:NbrSourcesTrouves:='Une seule source trouvée';
        else
          NbrSourcesTrouves:=IntToStr(RecordCount)+' sources trouvées';
      end;
      bsfbSelection.Enabled:=not IsEmpty;
    end
    else
    begin
      SQL.Add(Req_Trouve_Notes);
      ParamByName('IDOSSIER').AsInteger:=dm.NumDossier;
      ParamByName('SSOURCE').AsString:='%'+sNotes.Text+'%';
      Open;
      Last;
      First;
      case RecordCount of
        0:NbrSourcesTrouves:='Aucune note trouvée';
        1:NbrSourcesTrouves:='Une seule note trouvée';
        else
          NbrSourcesTrouves:=IntToStr(RecordCount)+' notes trouvées';
      end;
      bsfbSelection.Enabled:=not IsEmpty;
    end;
    EnableControls;
    lbNbIndiTrouve.Caption:=NbrSourcesTrouves;
    BloqueChange:=false;
    fCleFicheSelected:=IBSourcesEV_IND_KLE_FICHE.AsInteger;
    NomIndiSelected:=IBSourcesNOM.AsString;
    PrenomIndiSelected:=IBSourcesPRENOM.AsString;
    SosaIndiSelected:=IBSourcesNUM_SOSA.AsFloat;
    RempliTV;
//    BarEtat.Panels[0].Text:=dm.ChaineHintIndi(IBSourcesEV_IND_KLE_FICHE.AsInteger,' - ');
    if dbgNotes.CanFocus then
      dbgNotes.SetFocus;
  end
  else
  with IBQRecherche do
  begin
    Close;

    if rbInconnu.Checked then
      i_Sexe:=0
    else if rbHomme.Checked then
      i_Sexe:=1
    else if rbFemme.Checked then
      i_Sexe:=2
    else
      i_Sexe:=3;

    i_Sosa:=0;
    if Length(trim(sESosa.Text))>0 then
      if not TryStrToInt64(trim(sESosa.Text),i_Sosa) then
      begin
        Screen.Cursor:=Save_Cursor;
        MyMessageDlg(rs_SOSA_is_not_a_number,mtError, [mbCancel],Self);
        exit;
      end;

    if ((length(trim(sENom.Text))>0)
      or(length(trim(sEPrenom.Text))>0)
      or(length(trim(sECPNaissance.Text))>0)
      or(length(trim(sEVilleNaissance.Text))>0)
      or(length(trim(sEPaysNaissance.Text))>0)
      or(length(trim(sESubNaissance.Text))>0)
      or(length(trim(sECPDeces.Text))>0)
      or(length(trim(sEVilleDeces.Text))>0)
      or(length(trim(sEPaysDeces.Text))>0)
      or(length(trim(sESubDeces.Text))>0)
      or(i_Sexe<3)
      or(length(trim(seDateNe.Text))>0)
      or(length(trim(seDateDeces.Text))>0)
      or(length(trim(sEMetier.Text))>0)
      or(length(trim(sENbrUnions.Text))>0)
      or(mIndividuconfidentiel.Checked)
      or(mSansalertesurdates.Checked)
      or(mIdentiteIncertaine.Checked)
      or(mContinuerRecherches.Checked)
      or(cbSosa.Checked))and(Length(trim(sESosa.Text))>0) then
    begin
      if MyMessageDlg(rs_When_a_SOSA_is_searched_there_other_criterias_are_ignored+_CRLF+_CRLF+
        rs_Do_you_continue,mtConfirmation, [mbYes,mbNo],Self)<>mrYes then
      begin
        Screen.Cursor:=Save_Cursor;
        BloqueChange:=false;
        exit;
      end;
    end;

    SQL.Text :='select i.Cle_fiche'
      +',i.Nom'
      +',i.Prenom'
      +',i.Sexe'
      +',i.num_sosa'
      +',i.annee_naissance'
      +',i.date_naissance'
      +',i.surnom'
      +',n.ev_ind_cp as cp_naissance'
      +',n.ev_ind_ville as lieu_naissance'
      +',n.ev_ind_subd as subd_naissance'
      +',n.ev_ind_dept as dept_naissance'
      +',n.ev_ind_region as region_naissance'
      +',n.ev_ind_pays as pays_naissance'
      +',i.annee_deces'
      +',i.date_deces'
      +',d.ev_ind_cp as cp_deces'
      +',d.ev_ind_ville as lieu_deces'
      +',d.ev_ind_subd as subd_deces'
      +',d.ev_ind_dept as dept_deces'
      +',d.ev_ind_region as region_deces'
      +',d.ev_ind_pays as pays_deces'
      +',bin_and(i.ind_confidentiel,'+_s_IndiConf+') as ind_confidentiel'
      +' from individu i'
      +' left join evenements_ind n on n.ev_ind_kle_fiche=i.cle_fiche and n.ev_ind_type=''BIRT'''
      +' left join evenements_ind d on d.ev_ind_kle_fiche=i.cle_fiche and d.ev_ind_type=''DEAT'''
      +' where i.kle_dossier='+IntToStr(dm.NumDossier);

    if i_Sosa>0 then
      SQL.Add('and i.num_sosa='+sESosa.Text)
    else
    begin
      if Length(seNom.Text)>0 then
      begin
        if rbNomCom.Checked then
          s:=seNom.Text
        else
          s:='%'+seNom.Text+'%';
        SQL.Add('and i.nom like :s_Nom');
        ParamByName('s_Nom').AsString:=s;
      end;

      if Length(sEPrenom.Text)>0 then
      begin
        if rbPrenomCom.Checked then
          s:=sEPrenom.Text+'%'
        else
          s:='%'+sEPrenom.Text+'%';
        SQL.Add('and i.prenom like :s_Prenom');
        ParamByName('s_Prenom').AsString:=s;
      end;

      if Length(sECPNaissance.Text)>0 then
      begin
        s:=sECPNaissance.Text+'%';
        SQL.Add('and (select s_out from f_maj_sans_accent(n.ev_ind_cp)) like (select s_out from f_maj_sans_accent(:s_cp_naissance))');
        ParamByName('s_cp_naissance').AsString:=s;
      end;

      if Length(sEVilleNaissance.Text)>0 then
      begin
        s:=sEVilleNaissance.Text;
        IBQRecherche.SQL.Add('and n.ev_ind_Ville like :s_ville_naissance');
        ParamByName('s_ville_naissance').AsString:=s;
      end;

      if Length(sESubNaissance.Text)>0 then
      begin
        s:='%'+sESubNaissance.Text+'%';
        SQL.Add('and (select s_out from f_maj_sans_accent(n.ev_ind_subd)) like (select s_out from f_maj_sans_accent(:s_subd_naissance))');
        ParamByName('s_subd_naissance').AsString:=s;
      end;

      if Length(sEPaysNaissance.Text)>0 then
      begin
        s:=sEPaysNaissance.Text;
        IBQRecherche.SQL.Add('and n.ev_ind_pays=:s_pays_naissance');
        ParamByName('s_pays_naissance').AsString:=s;
      end;

      if Length(sECPDeces.Text)>0 then
      begin
        s:=sECPDeces.Text+'%';
        SQL.Add('and (select s_out from f_maj_sans_accent(d.ev_ind_cp)) like (select s_out from f_maj_sans_accent(:s_cp_deces))');
        ParamByName('s_cp_deces').AsString:=s;
      end;

      if Length(sEVilleDeces.Text)>0 then
      begin
        s:=sEVilleDeces.Text;
        IBQRecherche.SQL.Add('and d.ev_ind_Ville like :s_ville_deces');
        ParamByName('s_ville_deces').AsString:=s;
      end;

      if Length(sESubDeces.Text)>0 then
      begin
        s:='%'+sESubDeces.Text+'%';
        SQL.Add('and (select s_out from f_maj_sans_accent(d.ev_ind_subd)) like (select s_out from f_maj_sans_accent(:s_subd_deces))');
        ParamByName('s_subd_deces').AsString:=s;
      end;

      if Length(sEPaysDeces.Text)>0 then
      begin
        s:=sEPaysDeces.Text;
        IBQRecherche.SQL.Add('and d.ev_ind_pays=:s_pays_deces');
        ParamByName('s_pays_deces').AsString:=s;
      end;

      if Length(sEMetier.Text)>0 then
      begin
        SQL.Add('and exists(select * from evenements_ind where ev_ind_kle_fiche=i.cle_fiche and ev_ind_type=''OCCU'''
          +' and exists(select * from proc_eclate_description(ev_ind_description,'','') where s_description=:sEMetier))');
        ParamByName('sEMetier').AsString:=sEMetier.Text;
      end;

      s_Naiss:=trim(seDateNe.Text);
      if Length(s_Naiss)>0 then
      begin
        if s_Naiss[1]in ['>','<','='] then
          SQL.Add('and i.annee_naissance'+s_Naiss)
        else
          SQL.Add('and i.annee_naissance='+s_Naiss);
      end;

      s_Deces:=trim(seDateDeces.Text);
      if Length(s_Deces)>0 then
      begin
        if s_Deces[1]in ['>','<','='] then
          SQL.Add('and i.annee_deces'+s_Deces)
        else
          SQL.Add('and i.annee_deces='+s_Deces);
      end;

      s_NbrUnions:=trim(sENbrUnions.Text);
      if Length(s_NbrUnions)>0 then
      begin
        if s_NbrUnions[1]in ['>','<','='] then
          SQL.Add('and (select count(*) from t_union'
            +' where i.cle_fiche in(union_mari,union_femme))'+s_NbrUnions)
        else
          SQL.Add('and (select count(*) from t_union'
            +' where i.cle_fiche in(union_mari,union_femme))='+s_NbrUnions);
      end;

      if i_Sexe<3 then
        SQL.Add('and i.sexe='+IntToStr(i_Sexe));

      if mIndividuconfidentiel.Checked then
        SQL.Add('and bin_and(i.ind_confidentiel,'+_s_IndiConf+')='+_s_IndiConf);

      if mSansalertesurdates.Checked then
        SQL.Add('and bin_and(i.ind_confidentiel,'+_s_SansCtrlDates+')='+_s_SansCtrlDates);

      if mIdentiteIncertaine.Checked then
        SQL.Add('and bin_and(i.ind_confidentiel,'+_s_IdentiteIncertaine+')='+_s_IdentiteIncertaine);

      if mContinuerRecherches.Checked then
        SQL.Add('and bin_and(i.ind_confidentiel,'+_s_ContinuerRecherches+')='+_s_ContinuerRecherches);

      if cbSosa.Checked then
        SQL.Add('and i.num_sosa>0');

    end;
    SQL.Add('order by i.nom,i.prenom');
    DisableControls;
    Screen.Cursor:=crSQLWait;
    Application.ProcessMessages;
    try
      Open;
    finally
      EnableControls;
    end;
    case RecordCount of
      0:NbrIndiTrouves:='Aucun individu trouvé';
      1:NbrIndiTrouves:='Un seul individu trouvé';
      else
        NbrIndiTrouves:=IntToStr(RecordCount)+' individus trouvés';
    end;
    lbNbIndiTrouve.Caption:=NbrIndiTrouves;
    bsfbSelection.Enabled:=not IsEmpty;
    BloqueChange:=false;
    if bsfbSelection.Enabled
    and not IsEmpty Then
     Begin
      fCleFicheSelected:=FieldByName('CLE_FICHE').AsInteger;
      NomIndiSelected:=FieldByName('NOM').AsString;
      PrenomIndiSelected:=FieldByName('PRENOM').AsString;
      SosaIndiSelected:=FieldByName('NUM_SOSA').AsFloat;
     end;
    RempliTV;
    if dbgStd.CanFocus then
      dbgStd.SetFocus;
  end;
  btnPrint.Enabled:=bsfbSelection.Enabled;
  Screen.Cursor:=Save_Cursor;
end;

procedure TFRechercher.sbClearClick(Sender:TObject);
begin
  lbNbIndiTrouve.Caption:='';
  if not pNotes.Visible then
  begin
    IBQRecherche.Close;
    seNom.Text:='';
    sePreNom.Text:='';
    rbTous.Checked:=True;
    seCPNaissance.Text:='';
    seVilleNaissance.Text:='';
    sePaysNaissance.Text:='';
    seCPDeces.Text:='';
    seVilleDeces.Text:='';
    sePaysDeces.Text:='';
    seSosa.Text:='';
    seDateNe.Text:='';
    seDateDeces.Text:='';
    sESubNaissance.Text:='';
    sESubDeces.Text:='';
    sEMetier.Text:='';
    sENbrUnions.Text:='';
    NbrIndiTrouves:='';
    cbSosa.Checked:=false;
    mIndividuconfidentiel.Checked:=false;
    mSansalertesurdates.Checked:=false;
    mIdentiteIncertaine.Checked:=false;
    mContinuerRecherches.Checked:=false;
    LabelParamDivers.Font.Color:=$008F5345;
  end
  else
  begin
    IBSources.Close;
    sSources.Text:='';
    sNotes.Text:='';
    NbrSourcesTrouves:='';
  end;
  sbRechercher.Enabled:=True;
  bsfbSelection.Enabled:=False;
  TVdesc.Clear;
  TVasc.Clear;
  BarEtat.Panels[0].Text:='';
end;

procedure TFRechercher.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  BloqueChange:=true;
  IBQNoms.Close;
  IBQPrenoms.Close;
  IBQRecherche.Close;
  IBSources.Close;
  // Matthieu : Dans OnFormIni
//  dbgNotesDBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_RECHERCHE_NOTES');
//  dbgStdDBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_RECHERCHE_STANDARD');
  {
  fIni:=f_GetMemIniFile;
  try
    fIni.RootKey:=HKEY_CURRENT_USER;
    if fIni.OpenKey(gci_context.Keyfonctions_init,True) then
    begin
      fIni.WriteInteger('W_RECHERCHE_STANDARD','PanelTV',PanelTV.Height);
      fIni.WriteInteger('W_RECHERCHE_STANDARD','TVdesc',TVdesc.Width);
    end;
  finally
  end;}
  Action:=caFree;
  DoSendMessage(Owner,'FERME_FORM_RECHERCHER');
end;

procedure TFRechercher.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  case Key of
    VK_RETURN:DoRechercher;
    VK_ESCAPE:ModalResult:=mrCancel;
  end;
end;

procedure TFRechercher.option_ExporterHTMLClick(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SaveDialog.FileName:='ResultatRecherche.htm';
  if SaveDialog.Execute then
    if dbgSTD.Visible then
    begin
      IBQRecherche.DisableControls;
      SavePlace:=IBQRecherche.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dbgSTD,True,True);

      IBQRecherche.GotoBookmark(SavePlace);
      IBQRecherche.FreeBookmark(SavePlace);

      IBQRecherche.EnableControls;
    end
    else
    begin
      IBSources.DisableControls;
      SavePlace:=IBSources.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dbgNotes,True,True);

      IBSources.GotoBookmark(SavePlace);
      IBSources.FreeBookmark(SavePlace);

      IBSources.EnableControls;
    end
end;

procedure TFRechercher.PopupMenuGridPopup(Sender:TObject);
var
  i:integer;
begin
  if dbgStd.SelectedRows.Count>1 then
  begin
    Supprimerlafiche1.Caption:=fs_RemplaceMsg(rs_Caption_Delete_selected_person_s_files,
                               [intToStr(dbgStd.SelectedRows.Count)]);
  end
  else
    Supprimerlafiche1.Caption:=rs_Caption_Delete_selected_person_s_file;
  for i:=PopupMenuGrid.Items.Count-1 downto 6 do
    PopupMenuGrid.Items[i].Free;
  if IBQRecherche.Active and not IBQRecherche.IsEmpty then
  begin
    option_ExporterHTML.enabled:=true;
    Supprimerlafiche1.enabled:=true;
    mOuvrirlafiche.Enabled:=true;
    FMain.RempliPopMenuParentsConjointsEnfants(PopupMenuGrid,IBQRechercheCLE_FICHE.AsInteger
      ,IBQRechercheSEXE.AsInteger,false);
  end
  else
  begin
    option_ExporterHTML.enabled:=false;
    Supprimerlafiche1.enabled:=false;
    mOuvrirlafiche.Enabled:=false;
  end;
end;

procedure TFRechercher.doSelect;
begin
  if fCleFicheSelected>0 then
  begin
    DefaultCloseAction:=caNone;
    dm.individu_clef:=fCleFicheSelected;
    DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
  end;
end;

procedure TFRechercher.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  TVasc .NodeDataSize := Sizeof(TIndivTree)+1;
  TVdesc.NodeDataSize := Sizeof(TIndivTree)+1;
  TabControlStdNotes.color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
               { Matthieu ?
  dbgNotesDBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_RECHERCHE_NOTES');
  dbgStdDBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_RECHERCHE_STANDARD');
                }
  dbgSTD.Align:=alClient;
  dbgNotes.Align:=alClient;

  pSTD.Align:=AlClient;
  pNotes.Align:=AlClient;

  fCleFicheSelected:=-1;
  SaveDialog.InitialDir:=gci_context.PathDocs;
                 {
  fIni:=f_GetMemIniFile;
  try
    fIni.RootKey:=HKEY_CURRENT_USER;
    if fIni.OpenKey(gci_context.Keyfonctions_init,True) then
    begin
      PanelTV.Height:=fIni.ReadInteger('W_RECHERCHE_STANDARD','PanelTV',110);
      TVdesc.Width:=fIni.ReadInteger('W_RECHERCHE_STANDARD','TVdesc',250);
    end;
  finally
    fIni.Free;
  end;            }
  bDejaPasse:=false;
  btnPrint.DBTitle:=Panel1.Caption;
end;

procedure TFRechercher.bsfbSelectionClick(Sender:TObject);
begin
  doSelect;
end;

procedure TFRechercher.TabControlStdNotesTabChanged(
  Sender:TObject);
begin
  case TabControlStdNotes.TabIndex of
    0:
      begin
        pSTD.Show;
        pNotes.Hide;
        dbgSTD.Show;
        btnPrint.DBGrid:=dbgStd;
        dbgNotes.Hide;
{        ComponentPrinter.CurrentLink:=LinkdbgStd;}
        lbNbIndiTrouve.Caption:=NbrIndiTrouves;
        bsfbSelection.Enabled:=dbgStd.SelectedRows.Count>0;
      end;
    1:
      begin
        pSTD.Hide;
        pNotes.Show;
        dbgSTD.Hide;
        dbgNotes.Show;
        btnPrint.DBGrid:=dbgNotes;
        sNotes.SetFocus;
{//        ComponentPrinter.CurrentLink:=LinkdbgNotes;
        if mEnvoirplussurlagrille.Checked then
          dbgNotesDBTableView1.Preview.Visible:=true
        else
          dbgNotesDBTableView1.Preview.Visible:=false;}
        lbNbIndiTrouve.Caption:=NbrSourcesTrouves;
        bsfbSelection.Enabled:=dbgNotes.SelectedRows.Count>0;
      end;
  end;
  btnPrint.Enabled:=bsfbSelection.Enabled;
end;

procedure TFRechercher.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_Search_persons;
  //fMain.MemeMoniteur(self);
  Screen.Cursor:=crSQLWait;
  try
    IBQNoms.Params[0].AsInteger:=dm.NumDossier;
    IBQNoms.Open;
    IBQPrenoms.Open;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFRechercher.btnFermerClick(Sender:TObject);
begin
  close;
end;


procedure TFRechercher.SupprimerlestrisClick(Sender:TObject);
var
  i:integer;
begin
  if dbgStd.Visible then
  begin
    for i:=0 to dbgStd.Columns.Count-1 do
      dbgStd.Columns[i].SortOrder:=smNone;
    if IBQRecherche.Active then
    begin
      IBQRecherche.Close;
      IBQRecherche.Open;
    end;
  end
  else
  begin
    for i:=0 to dbgNotes.Columns.Count-1 do
      dbgNotes.Columns[i].SortOrder:=smNone;
    if IBSources.Active then
    begin
      IBSources.Close;
      IBSources.Open;
    end;
  end;
end;

procedure TFRechercher.mEnvoirplussurlagrilleClick(Sender:TObject);
begin
  mEnvoirplussurlagrille.Checked:=not mEnvoirplussurlagrille.Checked;
                        { Matthieu?Plus tard
  if mEnvoirplussurlagrille.Checked then
    dbgNotesDBTableView1.Preview.Visible:=true
  else
    dbgNotesDBTableView1.Preview.Visible:=false;}
end;

procedure TFRechercher.PmGridNotesPopup(Sender:TObject);
var
  i:integer;
begin
  for i:=PmGridNotes.Items.Count-1 downto 6 do
    PmGridNotes.Items[i].Free;
  if IBSources.Active and not IBSources.IsEmpty then
  begin
    mExportNotesHTML.enabled:=true;
    mOuvrirlaficheNotes.Enabled:=true;
    FMain.RempliPopMenuParentsConjointsEnfants(PmGridNotes,IBSourcesEV_IND_KLE_FICHE.AsInteger
      ,IBSourcesSEXE.AsInteger,false);
  end
  else
  begin
    mExportNotesHTML.enabled:=false;
    mOuvrirlaficheNotes.Enabled:=false;
  end;
end;

procedure TFRechercher.sSourcesKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  sNotes.Clear;
  EffacePageSources;
end;

procedure TFRechercher.sNotesKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  sSources.Clear;
  IBSources.Close;
  EffacePageSources;
end;

procedure TFRechercher.EffacePageSources;
begin
  IBSources.Close;
  NbrSourcesTrouves:='';
  lbNbIndiTrouve.Caption:='';
  TVdesc.Clear;
  TVasc.Clear;
  BarEtat.Panels[0].Text:='';
end;

procedure TFRechercher.doShow;
begin
  inherited doShow;
end;

procedure TFRechercher.Label18Click(Sender:TObject);
begin
  MyMessageDlg(rs_Search_Form_infos,mtInformation, [mbOK],self);
end;

procedure TFRechercher.mOuvrirlaficheClick(Sender:TObject);
begin
  doSelect;
end;

procedure TFRechercher.Supprimerlafiche1Click(Sender:TObject);
var
  q:TIBSQL;
  sMessage:string;
  i:integer;
  L:array of Integer;
begin
  if FMain.IDModuleActif=_ID_INDIVIDU then
  begin
    if FMain.aFIndividu.TestFicheIsModified then
    begin
      MyMessageDlg(rs_Error_Must_record_file_before_deleting,mtWarning, [mbOk],Self);
      exit;
    end;
  end;

  SetLength(L,dbgStd.SelectedRows.Count);
  if Length(L)>1 then
    sMessage:=fs_RemplaceMsg(rs_Confirm_deleting_selected_files,[intToStr(Length(L))])
  else
    sMessage:=rs_Confirm_deleting_selected_file;//
  if MyMessageDlg(sMessage,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    dbgStd.DataSource.DataSet.DisableControls;
    with dbgStd.DataSource.DataSet do
    for i:=0 to Length(L)-1 do
      Begin
        GotoBookMark(dbgStd.SelectedRows [i]);
        L[i]:=FieldByName('CLE_FICHE').AsInteger;
      end;
    IBQRecherche.Close;
    screen.Cursor:=crSQLWait;
    Application.ProcessMessages;
    try
      q:=TIBSQL.Create(Self);
      q.DataBase:=dm.ibd_BASE;
      q.Transaction:=dm.IBT_BASE;
      try
        q.SQL.Text:='delete from individu where CLE_FICHE=:CLE_FICHE';
        for i:=0 to Length(L)-1 do
        begin
          q.Params[0].AsInteger:=L[i];
          q.ExecQuery;
        end;
        q.Close;
      finally
        q.Free;
      end;
      dm.IBT_base.CommitRetaining;
      fMain.RefreshFavoris;
      DoRechercher;
      if FMain.IDModuleActif=_ID_INDIVIDU then
      begin//rafraichir la fiche au cas où elle serait concern?e directement ou par un lien
        DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
        Show;//ram?ne le focus
      end;
    finally
      screen.Cursor:=crDefault;
      dbgStd.DataSource.DataSet.EnableControls;

    end;
  end;
end;


procedure TFRechercher.dbgNotesDBTableView1CellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  if bDejaPasse then exit;
  bDejaPasse:=True;
  try
    doSelect;
  finally
    bDejaPasse:=False;
  end;
end;

procedure TFRechercher.TabControlStdNotesDrawTabEx(
  AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  if ATab = ATab.PageControl.ActivePage
   then ATab.Color:=gci_context.ColorLight
   else ATab.Color:=gci_context.ColorDark;
end;

procedure TFRechercher.mOuvrirlaficheNotesClick(Sender:TObject);
begin
  doselect;
end;

procedure TFRechercher.LabelParamDiversClick(Sender:TObject);
var
  p:TPoint;
begin
  p:=LabelParamDivers.ClientToScreen(Point(0,LabelParamDivers.Height));
  pmParamDivers.Popup(p.X,p.Y);
end;

procedure TFRechercher.mIndividuconfidentielClick(Sender:TObject);
begin
  TMenuItem(sender).Checked:=not TMenuItem(sender).Checked;
  if mIndividuconfidentiel.Checked or mSansalertesurdates.Checked
    or mIdentiteIncertaine.Checked or mContinuerRecherches.Checked
   then LabelParamDivers.Font.Color:=clRed
   else LabelParamDivers.Font.Color:=$008F5345;
end;

procedure TFRechercher.IBSourcesCalcFields(DataSet:TDataSet);
begin
  IBSourcesNUMRECORD.AsInteger:=IBSources.RecNo;
end;

procedure TFRechercher.DBTableViewFocusedRecordChanged(
  Sender:TObject;APrevFocusedRecord,
  AFocusedRecord:Longint;
  ANewItemRecordFocusingChanged:Boolean);
begin
  if pNotes.Visible then
  begin
    fCleFicheSelected:=IBSourcesEV_IND_KLE_FICHE.AsInteger;
    NomIndiSelected:=IBSourcesNOM.AsString;
    PrenomIndiSelected:=IBSourcesPRENOM.AsString;
    SosaIndiSelected:=IBSourcesNUM_SOSA.AsFloat;
  end
  else
  begin
    fCleFicheSelected:=IBQRechercheCLE_FICHE.AsInteger;
    NomIndiSelected:=IBQRechercheNOM.AsString;
    PrenomIndiSelected:=IBQRecherchePRENOM.AsString;
    SosaIndiSelected:=IBQRechercheNUM_SOSA.AsFloat;
  end;
  if not BloqueChange then
  begin
    RempliTV;
  end;
end;

procedure TFRechercher.TVascClick(Sender:TObject);
var
  Tree:TVirtualStringTree;
begin
  Tree:=(sender as TVirtualStringTree);
  if Tree.FocusedNode<>nil then
  begin
    fCleFicheSelected:=PIndivTree(Tree.GetNodeData(Tree.FocusedNode))^.cle;
    BarEtat.Panels[0].Text:=dm.ChaineHintIndi(fCleFicheSelected,' - ');
  end;
end;

procedure TFRechercher.TVascExpanding(Sender:TObject;Node:PVirtualNode;
  var AllowExpansion:Boolean);
begin
  if (Xmouse>(GetNodeLevel(Node,TVasc.RootNode)+1)*TVasc.Indent)and bBloquExpand then
    AllowExpansion:=false;
end;

procedure TFRechercher.TVascGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex:=PIndivTree(Sender.GetNodeData(Node))^.ImageIdx;
end;

procedure TFRechercher.TVascGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var monIndiv : PIndivTree;
begin
  monIndiv := Sender.GetNodeData(Node);
  with monIndiv^ do
    Begin
      CellText:=nom;
      if length(prenom)>0 then
        CellText:=CellText+' '+prenom;
      CellText:=CellText+GetStringNaissanceDeces(trim(DateNaiss),trim(DateDeces));
    end;
end;

procedure TFRechercher.TVascPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  with Sender,PIndivTree(GetNodeData(Node))^, TargetCanvas, Font do
   Begin
    if (sosa=1)and(ImageIdx<5) then
      Color:=_COLOR_SOSA
    else
      case ImageIdx of
        2,4:Color:=gci_context.ColorFemme;
        1,3:Color:=gci_context.ColorHomme;
        else
          Color:=clWindowText;
      end;

    if Node.Parent=RootNode then
      Style:= [fsBold];
    if Node= FocusedNode then
      Brush.Color:=gci_context.ColorMedium;
  end;
end;

procedure TFRechercher.TVascCollapsing(Sender:TObject;Node:PVirtualNode;
  var AllowCollapse:Boolean);
begin
  if (Xmouse>(GetNodeLevel(Node,TVasc.RootNode)+1)*TVasc.Indent)and bBloquExpand then
    AllowCollapse:=false;
end;

procedure TFRechercher.TVdescExpanding(Sender:TObject;Node:PVirtualNode;
  var AllowExpansion:Boolean);
begin
  if (Xmouse>(GetNodeLevel(Node,TVdesc.RootNode)+1)*TVdesc.Indent)and bBloquExpand then
    AllowExpansion:=false;
end;

procedure TFRechercher.TVdescCollapsing(Sender:TObject;Node:PVirtualNode;
  var AllowCollapse:Boolean);
begin
  if (Xmouse>(GetNodeLevel(Node,TVdesc.RootNode)+1)*TVdesc.Indent)and bBloquExpand then
    AllowCollapse:=false;
end;

procedure TFRechercher.TVascDblClick(Sender:TObject);
var
  Tree:TVirtualStringTree;
begin
  Tree:=(sender as TVirtualStringTree);
  if Tree.FocusedNode<>nil then
  begin
    fCleFicheSelected:=PIndivTree(Tree.GetNodeData(Tree.FocusedNode))^.cle;
    BarEtat.Panels[0].Text:=dm.ChaineHintIndi(fCleFicheSelected,' - ');
    doSelect;
  end;
end;

procedure TFRechercher.TVascMouseDown(Sender:TObject;
  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
var
  Noeud:PVirtualNode;
  Tree:TVirtualStringTree;
begin
  Tree:=(sender as TVirtualStringTree);
  Noeud:=Tree.GetNodeAt(X,Y);
  if Noeud<>nil then
  begin
    Tree.Selected[Noeud]:=True;
  end;
end;

procedure TFRechercher.TVascMouseMove(Sender:TObject;Shift:TShiftState;
  X,Y:Integer);
var
  Noeud:PVirtualNode;
  Tree:TVirtualStringTree;
begin
  Tree:=(sender as TVirtualStringTree);
  XMouse:=X;
  Noeud:=Tree.GetNodeAt(X,Y);
  if (Noeud<>nil)and(Noeud.Parent<>nil) then
    Tree.Cursor:=_CURPOPUP
  else
    Tree.Cursor:=crDefault;
end;

procedure TFRechercher.PMascPopup(Sender:TObject);
begin
  if TVasc.FocusedNode<>nil then
  begin
    IndiTV:=PIndivTree(TVasc.GetNodeData(TVasc.FocusedNode));
    OuvreDepuisAsc.Enabled:=true;
  end
  else
    OuvreDepuisAsc.Enabled:=false;
end;

procedure TFRechercher.PMdescPopup(Sender:TObject);
begin
  if TVdesc.FocusedNode<>nil then
  begin
    IndiTV:=PIndivTree(TVdesc.GetNodeData(TVdesc.FocusedNode));
    OuvreDepuisDesc.Enabled:=true;
  end
  else
    OuvreDepuisDesc.Enabled:=false;
end;

procedure TFRechercher.OuvreDepuisAscClick(Sender:TObject);
begin
  fCleFicheSelected:=IndiTV.cle;
  BarEtat.Panels[0].Text:=dm.ChaineHintIndi(fCleFicheSelected,' - ');
  doSelect;
end;


procedure TFRechercher.RempliTV;
var
  j:Integer;
  ANode, AParent : PVirtualNode;
  s:string;
begin
  Screen.Cursor:=crHourglass;
  TVdesc.Clear;
  TVasc.Clear;
  BarEtat.Panels[0].Text:=dm.ChaineHintIndi(fCleFicheSelected,' - ');
  if fCleFicheSelected>0 then
  begin
    OuvreDepuisAsc.Enabled:=true;
    OuvreDepuisDesc.Enabled:=true;
  end
  else
  begin
    OuvreDepuisAsc.Enabled:=false;
    OuvreDepuisDesc.Enabled:=false;
    Screen.Cursor:=crDefault;
    Exit
  end;
  with TVdesc, qDesc do
   Begin
    BeginUpdate;
    try
      ANode := TreeAjouterEnfant(TVdesc,nil);
      with PIndivTree ( GetNodeData(ANode))^ do
       Begin
        cle:=fCleFicheSelected;
        s:=fs_RemplaceMsg(rs_Joint_s_Child_ren_of,[NomIndiSelected]);
        if length(PrenomIndiSelected)>0 then
          Nom:=s+' '+PrenomIndiSelected
        else
          Nom:=s;
        sexe:=-4;
        if SosaIndiSelected>0 then
          sosa:=1
        else
          sosa:=0;
       end;

      close;
      ParamByName('cle_fiche').AsInteger:=fCleFicheSelected;
      ExecQuery;
      j:=-10;
      ANode:=nil;
      while not Eof do //on remplit TVdesc
      begin
        if (FieldByName('CLE_CONJOINT').AsInteger<>j) then //on ajoute un conjoint
        begin
          AParent := TreeAjouterEnfant(TVdesc,nil);
          with PIndivTree ( GetNodeData(AParent))^ do
           Begin

            j:=FieldByName('CLE_CONJOINT').AsInteger;
            if j=0 then
              cle:=IBQRechercheCLE_FICHE.AsInteger
            else
              cle:=j;
            sexe:=FieldByName('SEXE_CONJOINT').AsInteger;
            if sexe=0 then
              sexe:=IBQRechercheSEXE.AsInteger-3;
            if FieldByName('NOM_CONJOINT').AsString='?' then
            begin
              case sexe of
                1,-1:Nom:='Inconnu';
                2,-2:Nom:='Inconnue';
                else
                  Nom:='Inconnu';
              end;
            end
            else
              Nom:=FieldByName('NOM_CONJOINT').AsString;
            Prenom:=FieldByName('PRENOM_CONJOINT').AsString;
            DateNaiss:=FieldByName('DATE_NAISSANCE_CONJOINT').AsString;
            DateDeces:=FieldByName('DATE_DECES_CONJOINT').AsString;
            sosa:=FieldByName('SOSA_CONJOINT').AsInteger;
           end;
        end;
        if FieldByName('CLE_FICHE').AsInteger>0 then
        begin
          ANode := TreeAjouterEnfant(TVdesc,AParent);
          with PIndivTree ( GetNodeData(ANode))^ do
           Begin
            cle:=FieldByName('CLE_FICHE').AsInteger;
            Nom:=FieldByName('NOM').AsString;
            Prenom:=FieldByName('PRENOM').AsString;
            sexe:=FieldByName('SEXE').AsInteger;
            sosa:=FieldByName('SOSA').AsInteger;
            DateNaiss:=FieldByName('DATE_NAISSANCE').AsString;
            DateDeces:=FieldByName('DATE_DECES').AsString;
           end;
        end;
        Next;
      end;
      close;
      bBloquExpand:=false;
      FullExpand;
      bBloquExpand:=true;
      VisiblePath[TVdesc.RootNode.FirstChild]:=True;

    finally
      EndUpdate;
    end;
   end;

  AParent := nil;
  with TVasc, qAsc do
   Begin
    BeginUpdate;
    try
      ANode := TreeAjouterEnfant(TVasc,nil);
      with PIndivTree ( GetNodeData(ANode))^ do
       Begin

        cle:=fCleFicheSelected;
        s:=fs_RemplaceMsg(rs_Parents_of,[NomIndiSelected]);
        if length(PrenomIndiSelected)>0 then
          s:=s+' '+PrenomIndiSelected;
        Nom:=s+' (NIP '+IntToStr(fCleFicheSelected)+')';
        sexe:=-3;
        if SosaIndiSelected>0 then
          sosa:=1
        else
          sosa:=0;
       end;
      qAsc.close;
      qAsc.ParamByName('cle_fiche').AsInteger:=fCleFicheSelected;
      qAsc.ExecQuery;
      with qasc do
      while not Eof do //on remplit TVasc
       begin
        if (FieldByName('ordre').AsInteger=1)or(FieldByName('ordre').AsInteger=4) then
         Begin
          AParent:=TreeAjouterEnfant(TVasc,nil);
          ANode  :=AParent;
         end
        else
          ANode  :=TreeAjouterEnfant(TVasc,AParent);
         with PIndivTree ( GetNodeData(ANode))^ do
          Begin
            cle:=FieldByName('CLE_FICHE').AsInteger;
            Nom:=FieldByName('NOM').AsString;
            Prenom:=FieldByName('PRENOM').AsString;
            sexe:=FieldByName('SEXE').AsInteger;
            sosa:=FieldByName('SOSA').AsInteger;
            DateNaiss:=FieldByName('DATE_NAISSANCE').AsString;
            DateDeces:=FieldByName('DATE_DECES').AsString;
          end;
        Next;
       end;
      qAsc.Close;
      bBloquExpand:=false;
      FullExpand;
      bBloquExpand:=true;
      VisiblePath[RootNode.FirstChild]:=True;

    finally
      EndUpdate;
    end;
   end;

  Screen.Cursor:=crDefault;
end;


procedure TFRechercher.dbgStdMouseEnter(Sender:TObject);
begin
  // Matthieu ?
  //dm.cxHintStyleController1.HintStyle.Standard:=true;
end;

procedure TFRechercher.dbgStdMouseLeave(Sender:TObject);
begin
  // Matthieu ?
  //dm.cxHintStyleController1.HintStyle.Standard:=false;
end;

procedure TFRechercher.dbgStdDBTableView1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FMain.IndiDrag.cle:=IBQRechercheCLE_FICHE.AsInteger;
  FMain.IndiDrag.sexe:=IBQRechercheSEXE.AsInteger;
  FMain.IndiDrag.nomprenom:=AssembleString([IBQRechercheNOM.AsString,IBQRecherchePRENOM.AsString]);
  FMain.IndiDrag.naissance:= IBQRechercheDATE_NAISSANCE.AsString;
  FMain.IndiDrag.deces:= IBQRechercheDATE_DECES.AsString;
end;

procedure TFRechercher.dbgNotesDBTableView1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FMain.IndiDrag.cle:=IBSourcesEV_IND_KLE_FICHE.AsInteger;
  FMain.IndiDrag.sexe:=IBSourcesSEXE.AsInteger;
  FMain.IndiDrag.nomprenom:=AssembleString([IBSourcesNOM.AsString,IBSourcesPRENOM.AsString]);
  FMain.IndiDrag.naissance:= IBSourcesDATE_NAISSANCE.AsString;
  FMain.IndiDrag.deces:= IBSourcesDATE_DECES.AsString;
end;

end.
