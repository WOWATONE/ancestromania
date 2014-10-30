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

unit u_form_list_villes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  U_FormAdapt,Menus,Dialogs,Classes,Controls,
  u_comp_TYLanguage,u_objet_TState,SysUtils,forms,graphics,
  Variants, MaskEdit, ComCtrls,DB,
  U_ExtDBGrid,IBCustomDataSet, u_buttons_appli,
  IBUpdateSQL,IBQuery,
  u_ancestropictbuttons, u_ancestropictimages,
  CompSuperForm,
  ExtCtrls,StdCtrls,u_framework_dbcomponents, U_ExtNumEdits, U_OnFormInfoIni,
  PrintersDlgs, rxdbgrid, Grids, DBGrids;

type

  { TFListVilles }

  TFListVilles=class(TF_FormAdapt)
    btnAddDept: TFWInsert;
    btnAddPays: TFWInsert;
    btnAddRegion: TFWInsert;
    btnAddVille: TFWAdd;
    btnDelDept: TFWDelete;
    btnDelPays: TFWDelete;
    btnDelRegion: TFWDelete;
    btnDelVille: TFWDelete;
    btnExportDepart: TFWExport;
    btnExportPays: TFWExport;
    btnExportRegion: TFWExport;
    BtnExportVilles: TFWExport;
    btnImportDepart: TFWImport;
    btnImportPays: TFWImport;
    btnImportRegion: TFWImport;
    BtnImportVilles: TFWImport;
    dbDept: TExtDBGrid;
    dbPays: TExtDBGrid;
    dbRegion: TExtDBGrid;
    dxDBGrid2: TExtDBGrid;
    dxDBPEPays: TFWDBLookupCombo;
    IBQDeptRRG_CODE: TLongintField;
    Label1: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
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
    Panel2:TPanel;
    DSCP:TDataSource;
    IBQCP:TIBQuery;
    Panel20: TPanel;
    Panel4: TPanel;
    Panel6:TPanel;
    Panel8: TPanel;
    pDept: TPanel;
    pPays: TPanel;
    pRegion: TPanel;
    rbContent: TRadioButton;
    rbStart: TRadioButton;
    dsPays:TDataSource;
    IBQPays:TIBQuery;
    dsRegion:TDataSource;
    IBQRegion:TIBQuery;
    dsDept:TDataSource;
    IBQDept:TIBQuery;
    IBQPaysRPA_CODE:TLongintField;
    IBQPaysRPA_LIBELLE:TIBStringField;
    IBQPaysRPA_ABREVIATION:TIBStringField;
    IBUPays:TIBUpdateSQL;
    IBQRegionRRG_CODE:TLongintField;
    IBQRegionRRG_LIBELLE:TIBStringField;
    IBURegion:TIBUpdateSQL;
    IBUDept:TIBUpdateSQL;
    IBQDeptRDP_CODE:TLongintField;
    IBQDeptRDP_LIBELLE:TIBStringField;
    IBQDeptRDP_REGION:TLongintField;
    IBQDeptRDP_PAYS:TLongintField;
    IBQCPCP_LATITUDE: TFloatField;
    IBQCPCP_LONGITUDE: TFloatField;
    Panel5:TPanel;
    Label2:TLabel;
    Label12:TLabel;
    dxDBEdit1:TFWDBEdit;
    dxDBEdit2:TFWDBEdit;
    Panel7:TPanel;
    IBQRegionRRG_PAYS:TLongintField;
    Panel3:TPanel;
    Image1:TIATitle;
    Language:TYLanguage;
    seCP: TMaskEdit;
    Panel9:TPanel;
    DSVillesFavoris:TDataSource;
    SaveDialog:TSaveDialog;
    pmVilles:TPopupMenu;
    mIndisSurVille: TMenuItem;
    N1:TMenuItem;
    ExporterenHTML1:TMenuItem;
    IBQVillesFavoris:TIBQuery;
    N2:TMenuItem;
    mModif:TMenuItem;
    pGeographie:TPanel;
    Label17:TLabel;
    Label18:TLabel;
    dbLong:TExtDBNumEdit;
    dbLat:TExtDBNumEdit;
    cxGrid1:TExtDBGrid;
    IBQCPVILLE:TIBStringField;
    IBQCPDEPARTEMENT:TIBStringField;
    IBQCPREGION:TIBStringField;
    IBQCPPAYS:TIBStringField;
    IBQCPCODE:TIBStringField;
    IBQCPCLEF:TLongintField;
    IBQCPCP_DEPT:TLongintField;
    IBQCPCP_REGION:TLongintField;
    IBQCPCP_PAYS:TLongintField;
    IBQCPCP_INSEE:TIBStringField;
    IBQCPCP_DIVERS:TIBStringField;
    IBQVillesFavorisVILLE: TIBStringField;
    IBQVillesFavorisCP: TIBStringField;
    IBQVillesFavorisDEPT: TIBStringField;
    IBQVillesFavorisREGION: TIBStringField;
    IBQVillesFavorisPAYS: TIBStringField;
    IBQVillesFavorisINSEE: TIBStringField;
    IBQVillesFavorisSUBD: TIBStringField;
    IBQVillesFavorisLATITUDE: TFloatField;
    IBQVillesFavorisLONGITUDE: TFloatField;
    IBQVillesFavorisCOORDONNEES: TStringField;
    mAfficherCoordonnes: TMenuItem;
    mIndisSurSubd:TMenuItem;
    pmIndex:TPopupMenu;
    mModifVille: TMenuItem;
    seInsee: TMaskEdit;
    seVille: TMaskEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Supprimerlestris1:TMenuItem;
    PopupMenuExport:TPopupMenu;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    toutexporter:TMenuItem;
    exporterlepays:TMenuItem;
    AnnulerExport:TMenuItem;
    dxComponentPrinter1:TPrinterSetupDialog;
    Imprimerlaliste1:TMenuItem;
    N3:TMenuItem;
    FlatPanel1:TPanel;
    bsfbSelection:TFWOK;
    btnFermer:TFWClose;
    btnInternet:TXAWeb;
    btnVillesVoisines:TXANeighbor;
    PageControlVilles:TPageControl;
    Page0:TTabSheet;
    Label4:TLabel;
    mSelectionner: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    mReInitFav: TMenuItem;
    procedure btnDelDeptClick(Sender: TObject);
    procedure cxGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cxGrid1GetBtnParams(Sender: TObject; Field: TField; AFont: TFont;
      var Background: TColor; var SortMarker: TSortMarker; IsDown: Boolean);
    procedure FormShow(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure seVilleEnter(Sender:TObject);
    procedure seVilleChange(Sender:TObject);
    procedure seCPChange(Sender:TObject);
    procedure seCPEnter(Sender:TObject);
    procedure rbStartClick(Sender:TObject);
    procedure rbContentClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure mModifVilleClick(Sender:TObject);
    procedure bsfbSelectionClick(Sender:TObject);
    procedure btnAddVilleClick(Sender:TObject);
    procedure btnDelVilleClick(Sender:TObject);
    procedure btnImportVillesClick(Sender:TObject);
    procedure btnExportVillesClick(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure SuperFormDestroy(Sender:TObject);
    procedure btnAddPaysClick(Sender:TObject);
    procedure IBQPaysNewRecord(DataSet:TDataSet);
    procedure btnDelPaysClick(Sender:TObject);
    procedure btnAddRegionClick(Sender:TObject);
    procedure IBQRegionNewRecord(DataSet:TDataSet);
    procedure btnDelRegionClick(Sender:TObject);
    procedure btnAddDeptClick(Sender:TObject);
    procedure IBQDeptNewRecord(DataSet:TDataSet);
    procedure IBQPaysAfterScroll(DataSet:TDataSet);
    procedure IBQRegionAfterScroll(DataSet:TDataSet);
    procedure sbCloseClick(Sender:TObject);
    procedure PaintBox5Paint(Sender:TObject);
    procedure SuperFormCloseQuery(Sender:TObject;var CanClose:Boolean);
    procedure btnExportPaysClick(Sender:TObject);
    procedure btnExportRegionClick(Sender:TObject);
    procedure btnExportDepartClick(Sender:TObject);
    procedure btnImportPaysClick(Sender:TObject);
    procedure btnImportRegionClick(Sender:TObject);
    procedure btnImportDepartClick(Sender:TObject);
    procedure IBQDeptAfterScroll(DataSet:TDataSet);
    procedure seInseeEnter(Sender:TObject);
    procedure seInseeChange(Sender:TObject);
    procedure pmVillesPopup(Sender:TObject);
    procedure mIndisSurVilleClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure mModifClick(Sender:TObject);
    procedure dxDBGrid1DblClick(Sender:TObject);
    procedure dxDBPEPaysPropertiesCloseUp(Sender:TObject);
    procedure mIndisSurSubdClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure pmIndexPopup(Sender:TObject);
    procedure Supprimerlestris1Click(Sender:TObject);
    procedure Image1Click(Sender:TObject);
    procedure Image1MouseMove(Sender:TObject;Shift:TShiftState;X,
      Y:Integer);
    procedure ExporterVillesClick(Sender:TObject);
    procedure Imprimerlaliste1Click(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure btnInternetPopupMenuPopup(Sender:TObject;
      var APopupMenu:TPopupMenu;var AHandled:Boolean);
    procedure dxDBGrid2DBTableView1CellDblClick(
      Sender:TObject);
    procedure PageControlVillesDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
    procedure PageControlVillesChange(Sender:TObject);
    procedure dxDBGrid2MouseEnter(Sender: TObject);
    procedure dxDBGrid2MouseLeave(Sender: TObject);
    procedure dbPaysDBTableView1DrawColumnCell(
      Sender: TObject; ACanvas: TCanvas;
      AViewInfo: Longint; var ADone: Boolean);
    procedure mReInitFavClick(Sender: TObject);
    procedure seVilleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dxDBGrid1FocusedRecordChanged(Sender: TObject;
      APrevFocusedRecord, AFocusedRecord: Longint;
      ANewItemRecordFocusingChanged: Boolean);
    procedure dxDBGrid2DBTableView1FocusedRecordChanged(
      Sender: TObject; APrevFocusedRecord,
      AFocusedRecord: Longint;
      ANewItemRecordFocusingChanged: Boolean);
    procedure IBQVillesFavorisCalcFields(DataSet: TDataSet);
    procedure mAfficherCoordonnesClick(Sender: TObject);
    function CleUnique(NomTable:String):Integer;
  private
    fFill:TState;
    fCode:string;
    fVille:string;
    fDept:string;
    fPays:string;
    fRegion:string;
    fInsee:string;
    fLat:string;
    fLong:string;
    fSubd:string;
    gb_reinitsort : Boolean;
    fCanSelect:boolean;
    ModeIBQCP:integer;
    fNumPays:integer;
    bPremiereFois:boolean;

    procedure doSelectVille;
    procedure doTryToSavePaysRegionDepartement;
    procedure doRefreshVillesByName;
  public
    NomPaysFavoris:string;
    //En entrée
    property NumPays:integer read fNumPays write fNumPays;
    property CanSelect:boolean read fCanSelect write fCanSelect;
    procedure doActiveOnglet(onglet:integer);

    //en retour
    property Code:string read fCode write fCode;
    property Ville:string read fVille write fVille;
    property Dept:string read fDept write fDept;
    property Pays:string read fPays write fPays;
    property Region:string read fRegion write fRegion;
    property Insee:string read fInsee write fInsee;
    property Lat:string read fLat write fLat;
    property Long:string read fLong write fLong;
    property Subd:string read fSubd write fSubd;

    procedure LocateLieuFavoris(ville,subdivision:string);
  end;

implementation

uses u_dm,
     LazUTF8,
     u_form_main,
     u_form_Ville_Ajout,
     fonctions_dialogs,
     fonctions_string,
     fonctions_components,
     u_form_export_table_2_textfile,
     u_form_Import_textfile_2_table,u_common_functions,u_common_ancestro,u_common_const,
     u_common_ancestro_functions,
     u_Form_Individu_Sur_Favoris,u_form_Modif_Favoris,Types,u_genealogy_context,IBSQL;

const PAGE_FAVORIS = 2;
      PAGE_PAR_REGION = 1;
      PAGE_RECHERCHE  = 0;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}
const//parties communes aux requêtes. AL
  req1='SELECT v.RCV_POSTE as code'
    +',v.RCV_VILLE as ville'
    +',d.RDP_LIBELLE as departement'
    +',r.RRG_LIBELLE as region'
    +',p.RPA_LIBELLE as pays'
    +',v.RCV_CODE as clef'
    +',v.RCV_DEPT'
    +',v.RCV_REGION'
    +',v.RCV_PAYS'
    +',v.RCV_INSEE'
    +',v.RCV_DIVERS'
    +',v.RCV_LATITUDE'
    +',v.RCV_LONGITUDE'
    +' FROM REF_CP_VILLES v'
    +' inner JOIN REF_DEPARTEMENTS d ON d.RDP_CODE=v.RCV_DEPT'
    +' inner JOIN REF_REGIONS r ON r.RRG_CODE=v.RCV_REGION'
    +' inner JOIN REF_PAYS p ON p.RPA_CODE=v.RCV_PAYS';

  req2='ORDER BY v.RCV_VILLE_MAJ,v.RCV_insee,v.RCV_POSTE';

procedure TFListVilles.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  gb_reinitsort := False ;
  Color:=gci_context.ColorLight;
  btnAddVille.Color:=gci_context.ColorLight;
  btnDelVille.Color:=gci_context.ColorLight;
  BtnImportVilles.Color:=gci_context.ColorLight;
  BtnExportVilles.Color:=gci_context.ColorLight;
  btnImportPays.Color:=gci_context.ColorLight;
  btnImportRegion.Color:=gci_context.ColorLight;
  btnImportDepart.Color:=gci_context.ColorLight;
  btnAddPays.Color:=gci_context.ColorLight;
  btnAddRegion.Color:=gci_context.ColorLight;
  btnAddDept.Color:=gci_context.ColorLight;
  btnDelPays.Color:=gci_context.ColorLight;
  btnDelRegion.Color:=gci_context.ColorLight;
  btnDelDept.Color:=gci_context.ColorLight;
  btnExportPays.Color:=gci_context.ColorLight;
  btnExportRegion.Color:=gci_context.ColorLight;
  btnExportDepart.Color:=gci_context.ColorLight;
  btnAddVille.ColorFrameFocus:=gci_context.ColorLight;
  btnDelVille.ColorFrameFocus:=gci_context.ColorLight;
  BtnImportVilles.ColorFrameFocus:=gci_context.ColorLight;
  BtnExportVilles.ColorFrameFocus:=gci_context.ColorLight;
  btnImportPays.ColorFrameFocus:=gci_context.ColorLight;
  btnImportRegion.ColorFrameFocus:=gci_context.ColorLight;
  btnImportDepart.ColorFrameFocus:=gci_context.ColorLight;
  btnAddPays.ColorFrameFocus:=gci_context.ColorLight;
  btnAddRegion.ColorFrameFocus:=gci_context.ColorLight;
  btnAddDept.ColorFrameFocus:=gci_context.ColorLight;
  btnDelPays.ColorFrameFocus:=gci_context.ColorLight;
  btnDelRegion.ColorFrameFocus:=gci_context.ColorLight;
  btnDelDept.ColorFrameFocus:=gci_context.ColorLight;
  btnExportPays.ColorFrameFocus:=gci_context.ColorLight;
  btnExportRegion.ColorFrameFocus:=gci_context.ColorLight;
  btnExportDepart.ColorFrameFocus:=gci_context.ColorLight;
  Label4.Font.Color:=gci_context.ColorTexteOnglets;

  { Matthieu
  dxDBGrid1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_LISTE_VILLES');
  dxDBGrid2DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_LISTE_VILLES');
  }
  bPremiereFois:=true;
  NomPaysFavoris:='';

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  fCanSelect:=true;
  fFill:=TState.create(false);
  fNumPays:=gci_context.Pays;

  IBQPays.Open;
  if dm.IBBaseParam.Connected then
  begin
    IBQPays.Open;
    dxDBPEPays.Caption:=gci_context.PaysNom;
    if not IBQPays.Locate('RPA_CODE',gci_context.Pays, []) then
      ShowMessage(rs_Error_Default_country_not_found);
    IBQRegion.Open;
    IBQDept.Open;
  end
  else
  begin
    Page0.Enabled:=False;
    TabSheet1.Enabled:=False;
  end;

  seVille.Hint:=rs_Hint_Press_for_every_cities_bottom_arrow_selects_cities;
  dxDBGrid2.Hint:=rs_Hint_Double_clic_to_select+_CRLF
    +rs_Hint_Use_right_button_to_modify_a_site_or_see_an_event;
  cxGrid1.Hint:=rs_Hint_Double_clic_to_select+_CRLF
    +rs_Hint_Use_right_button_to_modify_a_city;
  ModeIBQCP:=0;
  btnInternet.PopupMenu:=FMain.pmLieuInternet;
  btnVillesVoisines.PopupMenu:=FMain.pmVillesVoisines;
  FMain.Lieu_Proprietaire:=self as TForm;
end;

procedure TFListVilles.cxGrid1GetBtnParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
  IsDown: Boolean);
begin
  if gb_reinitsort Then
    SortMarker:=smNone;
end;

procedure TFListVilles.FormShow(Sender: TObject);
begin
  doActiveOnglet(PageControlVilles.ActivePageIndex);
end;

procedure TFListVilles.cxGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  // Matthieu
  with cxGrid1 do
   if Column.Index = DataCol then
    if Canvas.Brush.Color=Color then
      Canvas.Brush.Color:=gci_context.ColorMedium;
end;


procedure TFListVilles.seVilleEnter(Sender:TObject);
begin
  seCP.Text:='';
  seInsee.Clear;
  doRefreshControls;
end;

procedure TFListVilles.seVilleChange(Sender:TObject);
begin
  doRefreshVillesByName;
end;

procedure TFListVilles.doRefreshVillesByName;
var
  i_Mode:smallint;
begin
  if Length(seVille.Text)=0 then
  begin
    IBQCP.Close;
    doRefreshControls;
    Exit;
  end;
  Screen.Cursor:=crHourglass;
  if rbStart.Checked then
    i_Mode:=2
  else
    i_Mode:=3;
  try
    IBQCP.DisableControls;
    IBQCP.Close;
    try
      if Copy(seVille.Text,1,1)='*' then
      begin
        if ModeIBQCP<>1 then
        begin
          IBQCP.SQL.Clear;
          IBQCP.SQL.ADD(req1);
          IBQCP.SQL.ADD('WHERE v.RCV_PAYS=:PAYS');
          IBQCP.SQL.ADD(req2);
          ModeIBQCP:=1;
        end;
        IBQCP.Params[0].AsInteger:=fNumPays;
      end
      else
      begin
        if ModeIBQCP<>i_Mode then
        begin
          IBQCP.SQL.Clear;
          IBQCP.SQL.ADD(req1);
          if i_Mode=2 then
            IBQCP.SQL.Add('where v.RCV_VILLE_MAJ STARTING WITH :I_VILLE and v.RCV_PAYS=:PAYS')
          else
            IBQCP.SQL.Add('where v.RCV_VILLE_MAJ containing :I_VILLE and v.RCV_PAYS=:PAYS');
          IBQCP.SQL.ADD(req2);
          ModeIBQCP:=i_Mode;
        end;
        IBQCP.Params[0].AsString:=fs_FormatText(seVille.Text,mftUpper,True);
        IBQCP.Params[1].AsInteger:=fNumPays;
      end;
      IBQCP.Open;
    finally
      IBQCP.EnableControls;
    end;
  finally
    Screen.Cursor:=crArrow;
  end;
  doRefreshControls;
end;

procedure TFListVilles.seCPEnter(Sender:TObject);
begin
  seVille.Text:='';
  seInsee.Clear;

  with IBQCP do
  begin
    Close;
    SQL.Clear;
    SQL.ADD(req1);
    SQL.Add('where (v.RCV_POSTE starting with upper(:code)or v.RCV_POSTE starting with lower(:code))');
    SQL.Add('and v.RCV_pays=:pays');
    SQL.Add(req2);
  end;
  ModeIBQCP:=4;
  doRefreshControls;
end;

procedure TFListVilles.seCPChange(Sender:TObject);
begin
  if Length(seCP.Text)<=1 then
  begin
    IBQCP.Close;
    doRefreshControls;
    Exit;
  end;

  with IBQCP do
  begin
    DisableControls;
    Close;
    ParamByName('code').AsString:=seCP.Text;
    ParamByName('pays').AsInteger:=fNumPays;
    Open;
    EnableControls;
  end;
  doRefreshControls;
end;

procedure TFListVilles.seInseeEnter(Sender:TObject);
begin
  seVille.Text:='';
  seCP.Clear;

  with IBQCP do
  begin
    Close;
    SQL.Clear;
    SQL.ADD(req1);
    SQL.Add('where (v.rcv_insee starting with upper(:code)or v.rcv_insee starting with lower(:code))');
    SQL.Add('and v.rcv_pays=:pays');
    SQL.Add(req2);
  end;
  ModeIBQCP:=5;
  doRefreshControls;
end;

procedure TFListVilles.seInseeChange(Sender:TObject);
begin
  if Length(seInsee.Text)<=1 then
  begin
    IBQCP.Close;
    Exit;
  end;
  with IBQCP do
  begin
    DisableControls;
    Close;
    ParamByName('code').AsString:=seInsee.Text;
    ParamByName('pays').AsInteger:=fNumPays;
    Open;
    EnableControls;
  end;
  doRefreshControls;
end;

procedure TFListVilles.rbStartClick(Sender:TObject);
begin
  doRefreshVillesByName;
end;

procedure TFListVilles.rbContentClick(Sender:TObject);
begin
  doRefreshVillesByName;
end;

procedure TFListVilles.SuperFormKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:ModalResult:=mrCancel;
    _KEY_HELP:p_ShowHelp(_ID_VILLES);
  end;
end;

procedure TFListVilles.bsfbSelectionClick(Sender:TObject);
begin
  doSelectVille;
end;

procedure TFListVilles.doSelectVille;
begin
  if fCanSelect then
  begin
    if PageControlVilles.ActivePageIndex=PAGE_RECHERCHE Then
    begin
      if (IBQCP.Active)and(not IBQCP.IsEmpty) then
      begin
        fCode:=IBQCPCODE.AsString;
        fVille:=IBQCPVille.AsString;
        fDept:=IBQCPDepartement.AsString;
        fPays:=IBQCPPays.AsString;
        fRegion:=IBQCPRegion.AsString;
        fInsee:=IBQCPCP_INSEE.AsString;
        fLat:=dbLat.Text;
        fLong:=dbLong.Text;
        fSubd:='';

        ModalResult:=mrOk;
      end;
    end
    else if PageControlVilles.ActivePageIndex=PAGE_FAVORIS then
    begin
      if (IBQVillesFavoris.Active)and(not IBQVillesFavoris.IsEmpty) then
      begin
        fCode:=IBQVillesFavorisCP.AsString;
        fInsee:=IBQVillesFavorisINSEE.AsString;
        fVille:=IBQVillesFavorisVILLE.AsString;
        fDept:=IBQVillesFavorisDEPT.AsString;
        fRegion:=IBQVillesFavorisREGION.AsString;
        fPays:=IBQVillesFavorisPAYS.AsString;
        flat:=IBQVillesFavorisLATITUDE.AsString;
        flong:=IBQVillesFavorisLONGITUDE.AsString;
        fSubd:=IBQVillesFavorisSUBD.AsString;

        ModalResult:=mrOk;
      end;
    end;
  end;
end;

procedure TFListVilles.btnAddVilleClick(Sender:TObject);
var
  aFVilleAjout:TFVilleAjout;
begin
  aFVilleAjout:=TFVilleAjout.create(self);
  try
    aFVilleAjout.FormMode:=sfmNew;
    aFVilleAjout.CodePays:=IBQPaysRPA_CODE.AsInteger;
    if aFVilleAjout.Prepare then
      if aFVilleAjout.ShowModal=mrOk then
      begin
        IBQPays.Locate('RPA_CODE',aFVilleAjout.CodePays, [loPartialKey]);
        if seVille.Text=aFVilleAjout.Ville then
          doRefreshVillesByName
        else
          seVille.Text:=aFVilleAjout.Ville;//déclanche doRefreshVillesByName
      end;
  finally
    FreeAndNil(aFVilleAjout);
  end;
end;

procedure TFListVilles.btnDelVilleClick(Sender:TObject);
var
  q:TIBSQL;
begin
  if MyMessageDlg(rs_Confirm_deleting_selected_city,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
  begin
    q:=TIBSQL.Create(self);
    try
      q.DataBase:=dm.IBBaseParam;
      q.Transaction:=dm.IBTransParam;
      q.SQL.Add('delete from ref_cp_villes where rcv_code=:rcv_code');
      q.ParamByName('RCV_CODE').AsInteger:=IBQCPCLEF.AsInteger;
      q.ExecQuery;
    finally
      q.Free;
    end;
    dm.IBTransParam.CommitRetaining;
    seVille.Clear;
  end;
end;

procedure TFListVilles.btnImportVillesClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    aFImportTextFile2Table.TableName:='REF_CP_VILLES';
    //aFImportTextFile2Table.UsePrimaryIndex:=true;//pas utilisé
    aFImportTextFile2Table.NamePrimaryIndex:='CP_CODE';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex:='GEN_REF_CP_VILLES';
    aFImportTextFile2Table.NamePrimaryIndex:='RCV_CODE';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex:='GEN_REF_CP_VILLES';
    aFImportTextFile2Table.ParamsTable.Add('RCV_CODE');
    aFImportTextFile2Table.ParamsTable.Add('RCV_POSTE');
    aFImportTextFile2Table.ParamsTable.Add('RCV_VILLE');
    aFImportTextFile2Table.ParamsTable.Add('RCV_DEPT');
    aFImportTextFile2Table.ParamsTable.Add('RCV_REGION');
    aFImportTextFile2Table.ParamsTable.Add('RCV_PAYS');
    aFImportTextFile2Table.ParamsTable.Add('RCV_INSEE');
    aFImportTextFile2Table.ParamsTable.Add('RCV_LATITUDE');
    aFImportTextFile2Table.ParamsTable.Add('RCV_LONGITUDE');
    aFImportTextFile2Table.ParamsTable.Add('RCV_DIVERS');

    aFImportTextFile2Table.QueryAdd.Database:=dm.IBBaseParam;
    aFImportTextFile2Table.QueryAdd.Transaction:=dm.IBTransParam;

    aFImportTextFile2Table.ShowModal;

  finally
    FreeAndNil(aFImportTextFile2Table);
  end;
end;

procedure TFListVilles.btnExportVillesClick(Sender:TObject);
var
  abs,ord:integer;
begin
  abs:=BtnExportVilles.ClientOrigin.X;
  ord:=BtnExportVilles.ClientOrigin.Y;
  PopupMenuExport.Popup(abs,ord);
end;

procedure TFListVilles.SuperFormRefreshControls(Sender:TObject);
begin
  if PageControlVilles.ActivePageIndex=PAGE_PAR_REGION then
  begin
    btnAddPays.enabled:=IBQPays.Active;
    btnDelPays.enabled:=IBQPays.Active and not IBQPays.IsEmpty;
    btnImportPays.enabled:=IBQPays.Active;
    btnExportPays.enabled:=IBQPays.Active and not IBQPays.IsEmpty;

    btnAddRegion.enabled:=IBQRegion.Active and IBQPays.Active and not IBQPays.IsEmpty;
    btnDelRegion.enabled:=IBQRegion.Active and not IBQRegion.IsEmpty;
    btnImportRegion.enabled:=IBQRegion.Active and IBQPays.Active and not IBQPays.IsEmpty;
    btnExportRegion.enabled:=IBQRegion.Active and not IBQRegion.IsEmpty;

    btnAddDept.enabled:=IBQDept.Active and IBQRegion.Active and not IBQRegion.IsEmpty
      and IBQPays.Active and not IBQPays.IsEmpty;
    btnDelDept.enabled:=IBQDept.Active and not IBQDept.IsEmpty;
    btnImportDepart.enabled:=IBQDept.Active and IBQRegion.Active and not IBQRegion.IsEmpty
      and IBQPays.Active and not IBQPays.IsEmpty;
    btnExportDepart.enabled:=IBQDept.Active and not IBQDept.IsEmpty;

    btnVillesVoisines.Visible:=false;
    btnInternet.Visible:=false;
    bsfbSelection.visible:=false
  end
  else if PageControlVilles.ActivePageIndex=PAGE_RECHERCHE then
  begin
    btnDelVille.Enabled:=not IBQCP.IsEmpty;
    bsfbSelection.visible:=not IBQCP.IsEmpty and fCanSelect;
    btnInternet.Visible:=not IBQCP.IsEmpty;
    if not IBQCP.IsEmpty Then
     Begin
      btnVillesVoisines.Visible:=(length(IBQCPCP_LATITUDE.AsString)>0)and(length(IBQCPCP_LONGITUDE.AsString)>0);
      btnInternet.Visible:= not(IBQCPVILLE.IsNull
                and(not fCassiniDll or(UTF8UpperCase(IBQCPPAYS.AsString)<>'FRANCE'))
                and(not btnVillesVoisines.Visible));
     end;
  end
  else //PageControlVilles.ActivePageIndex =2
   if IBQVillesFavoris.active then
    begin
      btnVillesVoisines.Visible:=(length(IBQVillesFavorisLATITUDE.AsString)>0)and(length(IBQVillesFavorisLONGITUDE.AsString)>0);
      btnInternet.Visible:=not IBQVillesFavoris.IsEmpty;
      bsfbSelection.visible:=not IBQVillesFavoris.IsEmpty and fCanSelect;
      mModif.Default:=not fCanSelect;
      mSelectionner.Visible:=bsfbSelection.visible;
      if not IBQCP.IsEmpty Then
       Begin
        btnInternet.Visible:= not(IBQVillesFavorisVILLE.IsNull
                and(not fCassiniDll or(UTF8UpperCase(IBQVillesFavorisPAYS.AsString)<>'FRANCE'))
                and(not btnVillesVoisines.Visible));
       end;
    end;
end;

procedure TFListVilles.doActiveOnglet(onglet:integer);
begin
  PageControlVilles.ActivePageIndex:=onglet;
  if (onglet=PAGE_FAVORIS)and bPremiereFois then
  begin
    bPremiereFois:=false;
    IBQVillesFavoris.SQL.Text:='select ville,cp,dept,region'
      +',pays,insee,subd,latitude,longitude'
      +' from lieux_favoris';
    if NomPaysFavoris>'' then
    begin
      IBQVillesFavoris.SQL.Add('where pays=:pays');
      IBQVillesFavoris.Params[0].AsString:=NomPaysFavoris;
    end;
    IBQVillesFavoris.SQL.Add('order by ville nulls first,subd nulls first'
      +',cp nulls first,dept nulls first'
      +',region nulls first,pays nulls first');
    try
      IBQVillesFavoris.Open;
    except
      on E:Exception do
        MyMessageDlg(rs_Error_reading_favorite_sites+_CRLF+_CRLF
          +E.Message,mtError, [mbOK],FMain);
    end;
  end;

  DoRefreshControls;
end;

procedure TFListVilles.SuperFormDestroy(Sender:TObject);
begin
  FreeAndNil(fFill);
  FMain.Lieu_Proprietaire:=nil;
  IBQPays.Close;
  IBQRegion.Close;
  IBQDept.Close;
  IBQVillesFavoris.Close;

  IBQCP.Close;

  Application.ProcessMessages;
end;

procedure TFListVilles.btnAddPaysClick(Sender:TObject);
begin
  IBQPays.Append;
  dbPays.SetFocus;
  doRefreshControls;
end;

procedure TFListVilles.IBQPaysNewRecord(DataSet:TDataSet);
begin
  IBQPaysRPA_CODE.AsInteger:=CleUnique('REF_PAYS');
end;

procedure TFListVilles.btnDelPaysClick(Sender:TObject);
begin
  IBQPays.Delete;
  doRefreshControls;
end;

procedure TFListVilles.btnAddRegionClick(Sender:TObject);

begin
  IBQRegion.Append;
  doRefreshControls;
  dbRegion.SetFocus;
end;

procedure TFListVilles.IBQRegionNewRecord(DataSet:TDataSet);
begin
  IBQRegionRRG_CODE.AsInteger:=CleUnique('REF_REGIONS');
  IBQRegionRRG_Pays.AsInteger:=IBQPaysRPA_CODE.AsInteger;
end;

procedure TFListVilles.btnDelRegionClick(Sender:TObject);
begin
  IBQRegion.Delete;
end;

procedure TFListVilles.btnAddDeptClick(Sender:TObject);
begin
  IBQDept.Append;
  doRefreshControls;
  dbDept.SetFocus;
end;

procedure TFListVilles.IBQDeptNewRecord(DataSet:TDataSet);
begin
  IBQDeptRDP_CODE.AsInteger:=CleUnique('REF_DEPARTEMENTS');
  IBQDeptRDP_REGION.AsInteger:=IBQRegionRRG_CODE.AsInteger;
  IBQDeptRDP_PAYS.AsInteger:=IBQPaysRPA_CODE.AsInteger;
end;

procedure TFListVilles.IBQPaysAfterScroll(DataSet:TDataSet);
begin
  seVille.Text:='';
  seVilleEnter(Self);
  doRefreshControls;
end;

procedure TFListVilles.IBQRegionAfterScroll(DataSet:TDataSet);
begin
  doRefreshControls;
end;

procedure TFListVilles.btnDelDeptClick(Sender:TObject);
begin
  IBQDept.Delete;
  doRefreshControls;
end;

procedure TFListVilles.sbCloseClick(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFListVilles.PaintBox5Paint(Sender:TObject);
begin
  PaintPointille(Sender);
end;

procedure TFListVilles.SuperFormCloseQuery(Sender:TObject;var CanClose:Boolean);
begin
  doTryToSavePaysRegionDepartement;
end;

procedure TFListVilles.doTryToSavePaysRegionDepartement;
begin
  try
    if (IBQPays.State in [dsEdit,dsInsert]) then
      IBQPays.Post;
  except
  end;

  try
    if (IBQRegion.State in [dsEdit,dsInsert]) then
      IBQRegion.Post;
  except;
  end;

  try
    if (IBQDept.State in [dsEdit,dsInsert]) then
      IBQDept.Post;
  except
  end;

  dm.IBTrans_Secondaire.CommitRetaining;
end;

procedure TFListVilles.btnExportPaysClick(Sender:TObject);
var
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
  try
    CentreLaFiche(aFExportTable2TextFile,self);
    aFExportTable2TextFile.TableName:='REF_PAYS';
    aFExportTable2TextFile.PropositionFileNameExport:='Pays.txt';
    aFExportTable2TextFile.Query.Database:=dm.IBBaseParam;
    aFExportTable2TextFile.Query.Transaction:=dm.IBTransParam;
    aFExportTable2TextFile.ShowModal;
  finally
    FreeAndNil(aFExportTable2TextFile);
  end;
end;

procedure TFListVilles.btnExportRegionClick(Sender:TObject);
var
  rep:word;
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  rep:=MyMessageDlg(rs_Export_Only_regions_of_selected_country,mtConfirmation, [mbYes,mbNo,mbCancel],Self);
  if (rep=mrYes)or(rep=mrNo) then
  begin
    aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
    try
      CentreLaFiche(aFExportTable2TextFile,self);
      aFExportTable2TextFile.TableName:='REF_REGIONS';
      aFExportTable2TextFile.PropositionFileNameExport:='Regions.txt';
      if rep=mrYes then
        aFExportTable2TextFile.CondSelect:='RDP_PAYS='+Inttostr(IBQPaysRPA_CODE.AsInteger);
      aFExportTable2TextFile.Query.Database:=dm.IBBaseParam;
      aFExportTable2TextFile.Query.Transaction:=dm.IBTransParam;
      aFExportTable2TextFile.ShowModal;
    finally
      FreeAndNil(aFExportTable2TextFile);
    end;
  end;
end;

procedure TFListVilles.btnExportDepartClick(Sender:TObject);
var
  rep:word;
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  rep:=MyMessageDlg(rs_Export_Only_departments_of_selected_region
    ,mtConfirmation, [mbYes,mbNo,mbCancel],Self);
  if (rep=mrYes)or(rep=mrNo) then
  begin
    aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
    try
      CentreLaFiche(aFExportTable2TextFile,self);
      aFExportTable2TextFile.TableName:='REF_DEPARTEMENTS';
      aFExportTable2TextFile.PropositionFileNameExport:='Departements.txt';
      if rep=mrYes then
        aFExportTable2TextFile.CondSelect:='RDP_PAYS='+Inttostr(IBQPaysRPA_CODE.AsInteger)+
          ' and RRG_CODE='+Inttostr(IBQRegionRRG_CODE.AsInteger);
      aFExportTable2TextFile.Query.Database:=dm.IBBaseParam;
      aFExportTable2TextFile.Query.Transaction:=dm.IBTransParam;
      aFExportTable2TextFile.ShowModal;
    finally
      FreeAndNil(aFExportTable2TextFile);
    end;
  end;
end;

procedure TFListVilles.btnImportPaysClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  doTryToSavePaysRegionDepartement;

  IBQDept.Close;
  IBQRegion.Close;
  IBQPays.Close;

  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    CentreLaFiche(aFImportTextFile2Table,self);
    aFImportTextFile2Table.TableName:='REF_PAYS';
    aFImportTextFile2Table.NamePrimaryIndex:='RPA_CODE';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex:='GEN_REF_PAYS';
    aFImportTextFile2Table.ParamsTable.Add('RPA_CODE');
    aFImportTextFile2Table.ParamsTable.Add('RPA_LIBELLE');
    aFImportTextFile2Table.ParamsTable.Add('RPA_ABREVIATION');
    aFImportTextFile2Table.chbVider.Checked:=false;

    aFImportTextFile2Table.QueryAdd.Database:=dm.IBBaseParam;
    aFImportTextFile2Table.QueryAdd.Transaction:=dm.IBTransParam;

    aFImportTextFile2Table.ShowModal;

  finally
    FreeAndNil(aFImportTextFile2Table);
  end;
  IBQPays.Open;
  IBQRegion.Open;
  IBQDept.Open;
  DoRefreshControls;
end;

procedure TFListVilles.btnImportRegionClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  doTryToSavePaysRegionDepartement;

  IBQDept.Close;
  IBQRegion.Close;

  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    CentreLaFiche(aFImportTextFile2Table,self);
    aFImportTextFile2Table.TableName:='REF_REGIONS';
    aFImportTextFile2Table.NamePrimaryIndex:='RRG_CODE';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex:='GEN_REF_REGIONS';
    aFImportTextFile2Table.ParamsTable.Add('RRG_CODE');
    aFImportTextFile2Table.ParamsTable.Add('RRG_LIBELLE');
    aFImportTextFile2Table.ParamsTable.Add('RRG_PAYS');
    aFImportTextFile2Table.chbVider.Checked:=false;

    aFImportTextFile2Table.QueryAdd.Database:=dm.IBBaseParam;
    aFImportTextFile2Table.QueryAdd.Transaction:=dm.IBTransParam;

    aFImportTextFile2Table.ShowModal;

  finally
    FreeAndNil(aFImportTextFile2Table);
  end;

  IBQRegion.Open;
  IBQDept.Open;
  DoRefreshControls;
end;

procedure TFListVilles.btnImportDepartClick(Sender:TObject);
var
  aFImportTextFile2Table:TFImportTextFile2Table;
begin
  doTryToSavePaysRegionDepartement;

  IBQDept.Close;

  aFImportTextFile2Table:=TFImportTextFile2Table.create(self);
  try
    CentreLaFiche(aFImportTextFile2Table,self);
    aFImportTextFile2Table.TableName:='REF_DEPARTEMENTS';
    aFImportTextFile2Table.NamePrimaryIndex:='RDP_CODE';
    aFImportTextFile2Table.NameGeneratorPrimaryIndex:='GEN_REF_DEPARTEMENTS';

    aFImportTextFile2Table.ParamsTable.Add('RDP_CODE');
    aFImportTextFile2Table.ParamsTable.Add('RDP_LIBELLE');
    aFImportTextFile2Table.ParamsTable.Add('RDP_REGION');
    aFImportTextFile2Table.ParamsTable.Add('RDP_PAYS');
    aFImportTextFile2Table.chbVider.Checked:=false;

    aFImportTextFile2Table.QueryAdd.Database:=dm.IBBaseParam;
    aFImportTextFile2Table.QueryAdd.Transaction:=dm.IBTransParam;
 
     aFImportTextFile2Table.ShowModal;
 
   finally
     FreeAndNil(aFImportTextFile2Table);
   end;
  IBQDept.Open;
  DoRefreshControls;
end;

procedure TFListVilles.IBQDeptAfterScroll(DataSet:TDataSet);
begin
  doRefreshControls;
end;

procedure TFListVilles.pmVillesPopup(Sender:TObject);
begin
  mIndisSurSubd.Enabled:=not dxDBGrid2.DataSource.DataSet.IsEmpty;
  mIndisSurVille.Enabled:=mIndisSurSubd.Enabled and (IBQVillesFavorisVILLE.AsString>'');
  mModif.Enabled:=mIndisSurSubd.Enabled;
  ExporterenHTML1.Enabled:=mIndisSurSubd.Enabled;
  Supprimerlestris1.Enabled:=mIndisSurSubd.Enabled;
end;

procedure TFListVilles.mIndisSurVilleClick(Sender:TObject);
var
  aFIndividusSurFavoris:TFIndividusSurFavoris;
begin
  aFIndividusSurFavoris:=TFIndividusSurFavoris.create(self);
  try
    CentreLaFiche(aFIndividusSurFavoris,self);
    aFIndividusSurFavoris.DoInit(
      IBQVillesFavorisVILLE.AsString,
      IBQVillesFavorisCP.AsString,
      IBQVillesFavorisDEPT.AsString,
      IBQVillesFavorisINSEE.AsString,
      IBQVillesFavorisREGION.AsString,
      IBQVillesFavorisPAYS.AsString,
      '',
      0);
    aFIndividusSurFavoris.ShowModal;
  finally
    FreeAndNil(aFIndividusSurFavoris);
  end;
end;

procedure TFListVilles.mIndisSurSubdClick(Sender:TObject);
var
  aFIndividusSurFavoris:TFIndividusSurFavoris;
begin
  aFIndividusSurFavoris:=TFIndividusSurFavoris.create(self);
  try
    CentreLaFiche(aFIndividusSurFavoris,self);
    aFIndividusSurFavoris.DoInit(
      IBQVillesFavorisVILLE.AsString,
      IBQVillesFavorisCP.AsString,
      IBQVillesFavorisDEPT.AsString,
      IBQVillesFavorisINSEE.AsString,
      IBQVillesFavorisREGION.AsString,
      IBQVillesFavorisPAYS.AsString,
      IBQVillesFavorisSUBD.AsString,
      1);
    aFIndividusSurFavoris.ShowModal;
  finally
    FreeAndNil(aFIndividusSurFavoris);
  end;
end;

procedure TFListVilles.mModifClick(Sender:TObject);
var
  aFModifFavoris:TFModifFavoris;
begin
  application.ProcessMessages;
  aFModifFavoris:=TFModifFavoris.create(self);
  try
    CentreLaFiche(aFModifFavoris,self);
    aFModifFavoris.DoInit([
      IBQVillesFavorisCP.AsString,
      IBQVillesFavorisINSEE.AsString,
      IBQVillesFavorisVILLE.AsString,
      IBQVillesFavorisDEPT.AsString,
      IBQVillesFavorisREGION.AsString,
      IBQVillesFavorisPAYS.AsString,
      IBQVillesFavorisSUBD.AsString,
      IBQVillesFavorisLATITUDE.AsString,
      IBQVillesFavorisLONGITUDE.AsString
      ]);
    if aFModifFavoris.ShowModal=mrOk then
    begin
      IBQVillesFavoris.Close;
      IBQVillesFavoris.Open;
      LocateLieuFavoris(aFModifFavoris.dxViller.Text,aFModifFavoris.edSubd.Text);
    end;
  finally
    FreeAndNil(aFModifFavoris);
  end;
end;

procedure TFListVilles.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.InitialDir:=gci_context.PathDocs;
  SaveDialog.FileName:='Liste des lieux favoris.HTM';
  if SaveDialog.Execute then
  begin
    IBQVillesFavoris.DisableControls;
    try
      SavePlace:=IBQVillesFavoris.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGrid2,True,True);
    finally
      IBQVillesFavoris.GotoBookmark(SavePlace);
      IBQVillesFavoris.FreeBookmark(SavePlace);
      IBQVillesFavoris.EnableControls;
    end;
  end;
end;

procedure TFListVilles.dxDBGrid1DblClick(Sender:TObject);
begin
  doSelectVille
end;

procedure TFListVilles.dxDBPEPaysPropertiesCloseUp(Sender:TObject);
var
  iPays:integer;
begin
  // Matthieu
  if not VarIsNull(dxDBPEPays.Field.Value) then
    iPays:=dxDBPEPays.Field.Value
  else
    iPays:=1;

  if fnumPays<>iPays then
  begin
    seCP.Text:='';
    seVille.Text:='';
    seINSEE.Text:='';
  end;

  fnumPays:=iPays;
end;

procedure TFListVilles.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  // Matthieu
  Action:=caHide;
//  dxDBGrid1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_LISTE_VILLES');
//  dxDBGrid2DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_LISTE_VILLES');
end;

procedure TFListVilles.pmIndexPopup(Sender:TObject);
begin
  mModifVille.Enabled:=not IBQCP.IsEmpty;
end;

procedure TFListVilles.mModifVilleClick(Sender:TObject);
var
  aFVilleAjout:TFVilleAjout;
begin
  aFVilleAjout:=TFVilleAjout.create(self);
  try
    CentreLaFiche(aFVilleAjout,self);
    aFVilleAjout.Code:=IBQCPCLEF.AsInteger;

    if aFVilleAjout.Prepare then
    begin
      if aFVilleAjout.ShowModal=mrOk then
      begin
        seVilleEnter(Sender);
        if seVille.Text=aFVilleAjout.Ville then
          doRefreshVillesByName
        else
          seVille.Text:=aFVilleAjout.Ville;//déclanche doRefreshVillesByName
      end;
    end;
  finally
    FreeAndNil(aFVilleAjout);
  end;
end;

procedure TFListVilles.Supprimerlestris1Click(Sender:TObject);
var
  i:integer;
begin
  gb_reinitsort:=True;
  dxDBGrid2.Refresh;
  gb_reinitsort:=False;
  IBQVillesFavoris.Close;
  IBQVillesFavoris.Open;
end;

procedure TFListVilles.Image1Click(Sender:TObject);
begin
  if PageControlVilles.ActivePageIndex=PAGE_FAVORIS then
    Supprimerlestris1Click(sender);
end;

procedure TFListVilles.Image1MouseMove(Sender:TObject;Shift:TShiftState;
  X,Y:Integer);
begin
  if PageControlVilles.ActivePageIndex=PAGE_FAVORIS then
    Image1.ShowHint:=true
  else
    Image1.ShowHint:=false;
end;

procedure TFListVilles.ExporterVillesClick(Sender:TObject);
var
  aFExportTable2TextFile:TFExportTable2TextFile;
begin
  aFExportTable2TextFile:=TFExportTable2TextFile.create(self);
  try
    CentreLaFiche(aFExportTable2TextFile,self);
    aFExportTable2TextFile.TableName:='REF_CP_VILLES';
    aFExportTable2TextFile.PropositionFileNameExport:='Villes.txt';
    if Sender=exporterlepays then
      aFExportTable2TextFile.CondSelect:='CP_PAYS ='+IntToStr(fNumPays);
    aFExportTable2TextFile.Query.Database:=dm.IBBaseParam;
    aFExportTable2TextFile.Query.Transaction:=dm.IBTransParam;
    aFExportTable2TextFile.ShowModal;
  finally
    FreeAndNil(aFExportTable2TextFile);
  end;
end;

procedure TFListVilles.Imprimerlaliste1Click(Sender:TObject);
begin
  // Matthieu
//  dxComponentPrinter1.Preview(True,nil);
end;

procedure TFListVilles.SuperFormShowFirstTime(Sender:TObject);
begin
  caption:=rs_Caption_Searching_a_site;
end;

procedure TFListVilles.btnInternetPopupMenuPopup(Sender:TObject;
  var APopupMenu:TPopupMenu;var AHandled:Boolean);
begin
  if PageControlVilles.ActivePageIndex=PAGE_RECHERCHE then
  begin
    FMain.Lieu_Pays:=IBQCPPAYS.AsString;
    FMain.Lieu_Region:=IBQCPREGION.AsString;
//    FMain.Lieu_INSEE:=IBQCPCP_INSEE.AsString;
    FMain.Lieu_Departement:=IBQCPDEPARTEMENT.Text;
    FMain.Lieu_Ville:=IBQCPVILLE.AsString;
    FMain.Lieu_Latitude:=IBQCPCP_LATITUDE.AsString;
    FMain.Lieu_Longitude:=IBQCPCP_LONGITUDE.AsString;
    FMain.Lieu_Subdivision:='';
  end
  else if PageControlVilles.ActivePageIndex=PAGE_FAVORIS then
  begin
    FMain.Lieu_Pays:=IBQVillesFavorisPAYS.AsString;
    FMain.Lieu_Region:=IBQVillesFavorisREGION.AsString;
//    FMain.Lieu_INSEE:=IBQVillesFavorisINSEE.AsString;
    FMain.Lieu_Departement:=IBQVillesFavorisDEPT.AsString;
    FMain.Lieu_Ville:=IBQVillesFavorisVILLE.AsString;
    FMain.Lieu_Latitude:=IBQVillesFavorisLATITUDE.AsString;
    FMain.Lieu_Longitude:=IBQVillesFavorisLONGITUDE.AsString;
    FMain.Lieu_Subdivision:=IBQVillesFavorisSUBD.AsString;
  end;
end;

procedure TFListVilles.dxDBGrid2DBTableView1CellDblClick(
  Sender:TObject);
begin
  if fCanSelect then
    doSelectVille
  else
    mModifClick(sender);
end;

procedure TFListVilles.PageControlVillesDrawTabEx(
  AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  // Matthieu
  {
  if ATab.IsMainTab then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
    }
end;

procedure TFListVilles.PageControlVillesChange(Sender:TObject);
begin
  doActiveOnglet((sender as TPageControl).ActivePageIndex);
end;

procedure TFListVilles.LocateLieuFavoris(ville,subdivision:string);
var
  cherche:boolean;
begin
  cherche:=true;
  if (length(ville)>0)or(length(subdivision)>0) then
  begin
    IBQVillesFavoris.Last;
    IBQVillesFavoris.DisableControls;
    if (length(ville)>0)and(length(subdivision)>0) then
      if IBQVillesFavoris.Locate('VILLE;SUBD'
            ,VarArrayOf([ville,subdivision])
            ,[loCaseInsensitive,loPartialKey]) then
        cherche:=false;
    if cherche then
      if (length(ville)>0) then
        if IBQVillesFavoris.Locate('VILLE'
              ,ville
              ,[loCaseInsensitive,loPartialKey]) then
          cherche:=false;
    if cherche then
      if (length(subdivision)>0) then
        if IBQVillesFavoris.Locate('SUBD'
              ,subdivision
              ,[loCaseInsensitive,loPartialKey]) then
          cherche:=false;
    if cherche then
      IBQVillesFavoris.First;
    IBQVillesFavoris.EnableControls;
  end;
end;

procedure TFListVilles.dxDBGrid2MouseEnter(Sender: TObject);
begin
  // Matthieu
//  dm.cxHintStyleController1.HintStyle.Standard:=true;
end;

procedure TFListVilles.dxDBGrid2MouseLeave(Sender: TObject);
begin
//  dm.cxHintStyleController1.HintStyle.Standard:=false;
end;

procedure TFListVilles.dbPaysDBTableView1DrawColumnCell(
  Sender: TObject; ACanvas: TCanvas;
  AViewInfo: Longint; var ADone: Boolean);
begin
//  if AviewInfo.Selected then
//    acanvas.Brush.Color:=gci_context.ColorMedium;
end;

procedure TFListVilles.mReInitFavClick(Sender: TObject);
var
  ville,subdivision:string;
begin
  ville:='';
  subdivision:='';
  if not IBQVillesFavoris.IsEmpty then
  begin
    ville:=IBQVillesFavorisVILLE.AsString;
    subdivision:=IBQVillesFavorisSUBD.AsString;
  end;
  IBQVillesFavoris.DisableControls;
  try
    IBQVillesFavoris.Close;
    dm.doInitLieuxFavoris;
    IBQVillesFavoris.Open;
    LocateLieuFavoris(ville,subdivision);
  finally
    IBQVillesFavoris.EnableControls;
  end;
end;

procedure TFListVilles.seVilleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_DOWN then
    if IBQCP.Active and not IBQCP.IsEmpty then
      cxGrid1.SetFocus;
end;

procedure TFListVilles.dxDBGrid1FocusedRecordChanged(
  Sender: TObject; APrevFocusedRecord,
  AFocusedRecord: Longint;
  ANewItemRecordFocusingChanged: Boolean);
begin
  DoRefreshControls;
end;

procedure TFListVilles.dxDBGrid2DBTableView1FocusedRecordChanged(
  Sender: TObject; APrevFocusedRecord,
  AFocusedRecord: Longint;
  ANewItemRecordFocusingChanged: Boolean);
begin
  DoRefreshControls;
end;

procedure TFListVilles.IBQVillesFavorisCalcFields(DataSet: TDataSet);
var
  s:String;
begin
  if IBQVillesFavorisLATITUDE.IsNull then
    s:=''
  else
    s:='Latitude: '+IBQVillesFavorisLATITUDE.AsString;
  if not IBQVillesFavorisLONGITUDE.IsNull then
  begin
    if s>'' then
      s:=s+', ';
    s:=s+'Longitude: '+IBQVillesFavorisLONGITUDE.AsString;
  end;
  IBQVillesFavorisCOORDONNEES.AsString:=s;
end;

procedure TFListVilles.mAfficherCoordonnesClick(Sender: TObject);
begin
  mAfficherCoordonnes.Checked:=not mAfficherCoordonnes.Checked;
       { Matthieu ?
  if mAfficherCoordonnes.Checked then
    dxDBGrid2DBTableView1.Preview.Visible:=true
  else
    dxDBGrid2DBTableView1.Preview.Visible:=false;}
end;

function TFListVilles.CleUnique(NomTable:String):Integer;
var
  q:TIBSQL;
begin
  q:=TIBSQL.Create(self);
  q.Database:=dm.IBBaseParam;
  q.Transaction:=dm.IBTransParam;
  q.ParamCheck:=False;
  q.SQL.Text:='select gen_id(gen_'+NomTable+',1) from rdb$database';
  q.ExecQuery;
  Result:=q.Fields[0].AsInteger;
  q.Free;
end;

end.

