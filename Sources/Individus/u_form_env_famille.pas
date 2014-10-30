{auteur: André Langlet 2009}
unit u_form_env_famille;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  U_FormAdapt,DB,Dialogs,Menus,IBCustomDataSet,
  IBQuery,StdCtrls,Graphics,ExtCtrls,Controls,Classes,
  Forms,SysUtils,u_buttons_appli,ExtJvXPButtons,IBSQL,
  U_ExtDBGrid,ExtJvXPCheckCtrls, u_reports_components, U_OnFormInfoIni,
  ComCtrls, VirtualTrees,
  PrintersDlgs, Grids, DBGrids;

type
  PIndivTree=^TIndivTree;
  TIndivTree=record
    cle:integer;
    Nom:string;
    Prenom:string;
    sexe:integer;
    sosa:integer;
    DateNaiss:string;
    DateDeces:string;
  end;
  { TFEnvFamille }

  TFEnvFamille=class(TF_FormAdapt)
    chLui: TJvXPCheckbox;
    cxSplitter3: TSplitter;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    sbClear: TJvXPButton;
    sbRechercher: TJvXPButton;
    SourceTree: TDatasource;
    dsRecherche:TDataSource;
    PopupMenuGrid:TPopupMenu;
    option_ExporterHTML:TMenuItem;
    Panel2:TPanel;
    PanelTV:TPanel;
    Panel9:TPanel;
    dbgStd:TExtDBGrid;
    SaveDialog:TSaveDialog;
    Panel11:TPanel;
    LabelListe:TLabel;
    PanelChoix:TPanel;
    LabelChoix:TLabel;
    IBQRecherche:TIBQuery;
    Splitter1: TSplitter;
    Supprimerlestris:TMenuItem;
    cxSplitter1:TSplitter;
    N1:TMenuItem;
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
    IBQRechercheSUBD_NAISSANCE:TIBStringField;
    IBQRechercheSUBD_DECES:TIBStringField;
    IBQRechercheANNEE_NAISSANCE:TLongintField;
    IBQRechercheANNEE_DECES:TLongintField;
    IBQRechercheTYPE_LIEN:TIBStringField;
    IBQRechercheSURNOM: TIBStringField;
    mOuvrirlafiche:TMenuItem;
    chParents:TJvXPCheckBox;
    chConjointsParents:TJvXPCheckBox;
    chGrandsParents:TJvXPCheckBox;
    chConjointsGP:TJvXPCheckBox;
    chFreresSoeurs:TJvXPCheckBox;
    chOnclesTantes:TJvXPCheckBox;
    chCOnclesTantes:TJvXPCheckBox;
    chCFreresSoeurs:TJvXPCheckBox;
    chCousins:TJvXPCheckBox;
    chCCousins:TJvXPCheckBox;
    chConjoints:TJvXPCheckBox;
    chFSConjoints:TJvXPCheckBox;
    chConjFSC:TJvXPCheckBox;
    chNeveux:TJvXPCheckBox;
    chNeveuxConjoints:TJvXPCheckBox;
    chEnfants:TJvXPCheckBox;
    chConjointsEnfants:TJvXPCheckBox;
    chEnfantsConjoints:TJvXPCheckBox;
    chPetitsEnfants:TJvXPCheckBox;
    chCpetitsEnfants:TJvXPCheckBox;
    chPetitsEnfantsConjoints:TJvXPCheckBox;
    chCpetitsEnfantsConjoints:TJvXPCheckBox;
    TVasc: TVirtualStringTree;
    TVdesc: TVirtualStringTree;
    PMasc: TPopupMenu;
    OuvreDepuisAsc: TMenuItem;
    PMdesc: TPopupMenu;
    OuvreDepuisDesc: TMenuItem;
    qAsc: TIBSQL;
    qDesc: TIBSQL;
    BarEtat: TStatusBar;
    fpBoutons: TPanel;
    bsfbSelection: TFWOK;
    btnFermer: TFWClose;
    chParentsConjoints: TJvXPCheckBox;
    chBParentsConjoints: TJvXPCheckBox;
    mLiens: TMenuItem;
    ComponentPrinter: TPrinterSetupDialog;
    btnPrint: TFWPrintGrid;
    procedure dbgStdDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure sbRechercherClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure sbClearClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
    procedure option_ExporterHTMLClick(Sender:TObject);
    procedure PopupMenuGridPopup(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure bsfbSelectionClick(Sender:TObject);
    procedure btnFermerClick(Sender:TObject);
    procedure SupprimerlestrisClick(Sender:TObject);
    procedure mOuvrirlaficheClick(Sender:TObject);
    procedure dxDBNomDrawColumnCell(Sender:TObject;
      ACanvas:TCanvas;AViewInfo:Longint;
      var ADone:Boolean);
    procedure dbgStdDBTableView1CellDblClick(
      Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure TVascBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure TVascGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure dbgStdDBTableView1FocusedRecordChanged(
      Sender: TObject; APrevFocusedRecord,
      AFocusedRecord: Longint;
      ANewItemRecordFocusingChanged: Boolean);
    procedure TVascCustomDrawItem(Sender: TBaseVirtualTree; Node: PVirtualNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TVascDblClick(Sender: TObject);
    procedure TVascClick(Sender: TObject);
    procedure PMdescPopup(Sender: TObject);
    procedure PMascPopup(Sender: TObject);
    procedure OuvreDepuisAscClick(Sender: TObject);
    procedure TVascGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure TVascInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure TVascMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TVascMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TVascExpanding(Sender: TObject; Node: PVirtualNode;
      var AllowExpansion: Boolean);
    procedure TVascCollapsing(Sender: TObject; Node: PVirtualNode;
      var AllowCollapse: Boolean);
    procedure TVdescExpanding(Sender: TObject; Node: PVirtualNode;
      var AllowExpansion: Boolean);
    procedure TVdescCollapsing(Sender: TObject; Node: PVirtualNode;
      var AllowCollapse: Boolean);
    procedure mLiensClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgStdMouseEnter(Sender: TObject);
    procedure dbgStdMouseLeave(Sender: TObject);
    procedure dbgStdDBTableView1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure SuperFormResize(Sender: TObject);
  private
    bDejaPasse,bOkMajTV:boolean;
    Indiv:TIndivTree;
    fCleFicheSelected:integer;
    IndiEnCours:integer;
    NomIndiEnCours:string;
    IndiTV:TIndivTree;
    XMouse:integer;
    bBloquExpand:boolean;
    procedure doSelect;
    procedure RempliTV;
    procedure IdentifieTypeLien;

  public
    //en retour (sinon -1)
    property CleFicheSelected:integer read fCleFicheSelected write fCleFicheSelected;
    procedure DoRechercher(const Lindi:integer;const SonNom:string);

  end;

implementation

uses u_dm,u_form_main,u_common_functions,u_common_ancestro,
     u_common_const, u_genealogy_context, fonctions_components, rxdbgrid,
     u_common_ancestro_functions,
     fonctions_vtree,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFEnvFamille.sbRechercherClick(Sender:TObject);
begin
  DoRechercher(-1,'');
end;

procedure TFEnvFamille.dbgStdDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with dbgStd do
  if Column = dbgStd.SelectedColumn then
    if dbgStd.Canvas.Brush.Color=Color then
      dbgStd.Canvas.Brush.Color:=gci_context.ColorMedium;

end;

procedure TFEnvFamille.DoRechercher(const Lindi:integer;const SonNom:string);
const
  ReqPart1='select i.Cle_fiche'
    +',i.Nom'
    +',i.Prenom'
    +',i.Sexe'
    +',i.num_sosa'
    +',i.annee_naissance'
    +',i.date_naissance'
    +',i.annee_deces'
    +',i.date_deces'
    +',i.surnom';
var
  Save_Cursor:TCursor;
  Req:string;
  i:integer;
  RienChecked:boolean;
begin
  Save_Cursor:=Screen.Cursor;
  Screen.Cursor:=crHourglass;
  if Lindi<>-1 then
  begin
    IndiEnCours:=Lindi;
    NomIndiEnCours:=SonNom;
  end;
  Caption:=rs_Caption_Environment_Family_of+NomIndiEnCours;
  RienChecked:=true;
  for i:=0 to PanelChoix.ControlCount-1 do
    if PanelChoix.Controls[i] is TJvXPCheckBox then
      if (PanelChoix.Controls[i] as TJvXPCheckBox).Checked then
      begin
        RienChecked:=false;
        Break;
      end;
  if RienChecked then
    chParents.Checked:=true;//au moins les parents
  bOkMajTV:=false;
  try
    IBQRecherche.Close;
    IBQRecherche.SQL.Text := 'select distinct s.Cle_fiche'
      +',s.Nom'
      +',s.Prenom'
      +',s.Sexe'
      +',s.num_sosa'
      +',s.surnom'
      +',s.annee_naissance'
      +',s.date_naissance'
      +',n.ev_ind_cp as cp_naissance'
      +',n.ev_ind_ville as lieu_naissance'
      +',n.ev_ind_subd as subd_naissance'
      +',n.ev_ind_pays as pays_naissance'
      +',s.annee_deces'
      +',s.date_deces'
      +',d.ev_ind_cp as cp_deces'
      +',d.ev_ind_ville as lieu_deces'
      +',d.ev_ind_subd as subd_deces'
      +',d.ev_ind_pays as pays_deces'
      +',s.type_lien from (' + #13#10;
    Req:='';
    if chParents.Checked then
    begin
      Req:=ReqPart1+',''PAR'' as type_lien from individu i where '
        +'i.cle_fiche=(select cle_pere from individu where cle_fiche=:indi)'
        +' or i.cle_fiche=(select cle_mere from individu where cle_fiche=:indi)' + #13#10
    end;

    if chConjointsParents.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CPAR'' as type_lien from (select union_mari from t_union'
        +' where union_femme=(select cle_mere from individu where cle_fiche=:indi and cle_mere is not null)'
        +' and union_mari is not null and union_mari is distinct from (select cle_pere from individu where cle_fiche=:indi))as c'
        +' inner join individu i on i.cle_fiche=c.union_mari';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CPAR'' as type_lien from (select union_femme from t_union'
        +' where union_mari=(select cle_pere from individu where cle_fiche=:indi and cle_pere is not null)'
        +' and union_femme is not null and union_femme is distinct from (select cle_mere from individu where cle_fiche=:indi))as c'
        +' inner join individu i on i.cle_fiche=c.union_femme';
    end;

    if chGrandsParents.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''GP'' as type_lien from (select cle_fiche from proc_trouve_grands_parent(:indi)) as gp'
        +' inner join individu i on i.cle_fiche=gp.cle_fiche';
    end;

    if chConjointsGP.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CGP'' as type_lien from (select cle_fiche from proc_trouve_grands_parent(:indi)where sexe=1) as gp'
        +' inner join t_union u on u.union_mari=gp.cle_fiche'
        +' and u.union_femme not in (select cle_fiche from proc_trouve_grands_parent(:indi)where sexe=2)'
        +' inner join individu i on i.cle_fiche=u.union_femme';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CGP'' as type_lien from (select cle_fiche from proc_trouve_grands_parent(:indi)where sexe=2) as gp'
        +' inner join t_union u on u.union_femme=gp.cle_fiche'
        +' and u.union_mari not in (select cle_fiche from proc_trouve_grands_parent(:indi)where sexe=1)'
        +' inner join individu i on i.cle_fiche=u.union_mari';
    end;

    if chOnclesTantes.Checked then //mêmes grands père ou mêmes grands mères
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''OT'' as type_lien from individu o'
        +' inner join individu p on p.cle_fiche=o.cle_pere '
        +' inner join individu i on ((p.cle_pere is not null and i.cle_pere=p.cle_pere)'
        +' or (p.cle_mere is not null and i.cle_mere=p.cle_mere))'
        +' and i.cle_fiche<>p.cle_fiche'
        +' where o.cle_fiche=:indi and o.cle_pere is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''OT'' as type_lien from individu o'
        +' inner join individu p on p.cle_fiche=o.cle_mere '
        +' inner join individu i on ((p.cle_pere is not null and i.cle_pere=p.cle_pere)'
        +' or (p.cle_mere is not null and i.cle_mere=p.cle_mere))'
        +' and i.cle_fiche<>p.cle_fiche'
        +' where o.cle_fiche=:indi and o.cle_mere is not null';
    end;

    if chCOnclesTantes.Checked then //conjoints des oncles et tantes
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''COT'' as type_lien from individu o'
        +' inner join individu p on p.cle_fiche=o.cle_pere'
        +' inner join individu t on ((p.cle_pere is not null and t.cle_pere=p.cle_pere)'
        +' or (p.cle_mere is not null and t.cle_mere=p.cle_mere))'
        +' and t.cle_fiche<>p.cle_fiche'
        +' inner join t_union u on t.cle_fiche in (u.union_mari,u.union_femme)'
        +' inner join individu i on i.cle_fiche<>t.cle_fiche and i.cle_fiche in (u.union_mari,u.union_femme)'
        +' where o.cle_fiche=:indi and o.cle_pere is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''COT'' as type_lien from individu o'
        +' inner join individu p on p.cle_fiche=o.cle_mere'
        +' inner join individu t on ((p.cle_pere is not null and t.cle_pere=p.cle_pere)'
        +' or (p.cle_mere is not null and t.cle_mere=p.cle_mere))'
        +' and t.cle_fiche<>p.cle_fiche'
        +' inner join t_union u on t.cle_fiche in (u.union_mari,u.union_femme)'
        +' inner join individu i on i.cle_fiche<>t.cle_fiche and i.cle_fiche in (u.union_mari,u.union_femme)'
        +' where o.cle_fiche=:indi and o.cle_mere is not null';
    end;

    if chFreresSoeurs.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''FS'' as type_lien from individu m'
        +' inner join individu i on ((m.cle_pere is not null and i.cle_pere=m.cle_pere)'
        +' or (m.cle_mere is not null and i.cle_mere=m.cle_mere))'
        +' and i.cle_fiche<>m.cle_fiche'
        +' where m.cle_fiche=:indi';
    end;

    if chCFreresSoeurs.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CFS'' as type_lien from individu m'
        +' inner join individu f on ((m.cle_pere is not null and f.cle_pere=m.cle_pere)'
        +' or (m.cle_mere is not null and f.cle_mere=m.cle_mere))'
        +' and f.cle_fiche<>m.cle_fiche'
        +' inner join t_union u on u.union_mari=f.cle_fiche and u.union_femme is not null'
        +' inner join individu i on i.cle_fiche=u.union_femme'
        +' where m.cle_fiche=:indi';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CFS'' as type_lien from individu m'
        +' inner join individu f on ((m.cle_pere is not null and f.cle_pere=m.cle_pere)'
        +' or (m.cle_mere is not null and f.cle_mere=m.cle_mere))'
        +' and f.cle_fiche<>m.cle_fiche'
        +' inner join t_union u on u.union_femme=f.cle_fiche and u.union_mari is not null'
        +' inner join individu i on i.cle_fiche=u.union_mari'
        +' where m.cle_fiche=:indi';
    end;

    if chCousins.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''COU'' as type_lien from individu o'
        +' inner join individu p on p.cle_fiche=o.cle_pere'
        +' inner join individu t on ((p.cle_pere is not null and t.cle_pere=p.cle_pere)'
        +' or (p.cle_mere is not null and t.cle_mere=p.cle_mere))'
        +' and t.cle_fiche<>p.cle_fiche'
        +' inner join individu i on t.cle_fiche in (i.cle_pere,i.cle_mere)'
        +' where o.cle_fiche=:indi and o.cle_pere is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''COU'' as type_lien from individu o'
        +' inner join individu p on p.cle_fiche=o.cle_mere'
        +' inner join individu t on ((p.cle_pere is not null and t.cle_pere=p.cle_pere)'
        +' or (p.cle_mere is not null and t.cle_mere=p.cle_mere))'
        +' and t.cle_fiche<>p.cle_fiche'
        +' inner join individu i on t.cle_fiche in (i.cle_pere,i.cle_mere)'
        +' where o.cle_fiche=:indi and o.cle_mere is not null';
    end;

    if chCCousins.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CCOU'' as type_lien from individu o'
        +' inner join individu p on p.cle_fiche=o.cle_pere'
        +' inner join individu t on ((p.cle_pere is not null and t.cle_pere=p.cle_pere)'
        +' or (p.cle_mere is not null and t.cle_mere=p.cle_mere))'
        +' and t.cle_fiche<>p.cle_fiche'
        +' inner join individu c on t.cle_fiche in (c.cle_pere,c.cle_mere)'
        +' inner join t_union u on (u.union_mari=c.cle_fiche and u.union_femme is not null)'
        +' or (u.union_femme=c.cle_fiche and u.union_mari is not null)'
        +' inner join individu i on i.cle_fiche<>c.cle_fiche'
        +' and i.cle_fiche in (u.union_mari,union_femme)'
        +' where o.cle_fiche=:indi and o.cle_pere is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CCOU'' as type_lien from individu o'
        +' inner join individu p on p.cle_fiche=o.cle_mere'
        +' inner join individu t on ((p.cle_pere is not null and t.cle_pere=p.cle_pere)'
        +' or (p.cle_mere is not null and t.cle_mere=p.cle_mere))'
        +' and t.cle_fiche<>p.cle_fiche'
        +' inner join individu c on t.cle_fiche in (c.cle_pere,c.cle_mere)'
        +' inner join t_union u on (u.union_mari=c.cle_fiche and u.union_femme is not null)'
        +' or (u.union_femme=c.cle_fiche and u.union_mari is not null)'
        +' inner join individu i on i.cle_fiche<>c.cle_fiche'
        +' and i.cle_fiche in (u.union_mari,union_femme)'
        +' where o.cle_fiche=:indi and o.cle_mere is not null';
    end;

    if chConjoints.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CONJ'' as type_lien from t_union u'
        +' inner join individu i on i.cle_fiche=u.union_femme'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CONJ'' as type_lien from t_union u'
        +' inner join individu i on i.cle_fiche=u.union_mari'
        +' where u.union_femme=:indi and u.union_mari is not null';
    end;

    if chParentsConjoints.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''PARC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_femme'
        +' inner join individu i on (i.cle_fiche=e.cle_pere or i.cle_fiche=e.cle_mere)'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''PARC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_mari'
        +' inner join individu i on (i.cle_fiche=e.cle_pere or i.cle_fiche=e.cle_mere)'
        +' where u.union_femme=:indi and u.union_mari is not null';
    end;

    if chBParentsConjoints.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''BPARC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_femme'
        +' inner join t_union p on p.union_mari=e.cle_pere and p.union_femme is not null'
        +' and p.union_femme<>e.cle_mere'
        +' inner join individu i on (i.cle_fiche=p.union_femme)'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''BPARC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_femme'
        +' inner join t_union p on p.union_femme=e.cle_mere and p.union_mari is not null'
        +' and p.union_mari<>e.cle_pere'
        +' inner join individu i on (i.cle_fiche=p.union_mari)'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''BPARC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_mari'
        +' inner join t_union p on p.union_mari=e.cle_pere and p.union_femme is not null'
        +' and p.union_femme<>e.cle_mere'
        +' inner join individu i on (i.cle_fiche=p.union_femme)'
        +' where u.union_femme=:indi and u.union_mari is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''BPARC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_mari'
        +' inner join t_union p on p.union_femme=e.cle_mere and p.union_mari is not null'
        +' and p.union_mari<>e.cle_pere'
        +' inner join individu i on (i.cle_fiche=p.union_mari)'
        +' where u.union_femme=:indi and u.union_mari is not null';
    end;

    if chFSConjoints.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''FSC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_femme'
        +' inner join individu i on (i.cle_pere=e.cle_pere or i.cle_mere=e.cle_mere)'
        +' and i.cle_fiche<>e.cle_fiche'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''FSC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_mari'
        +' inner join individu i on (i.cle_pere=e.cle_pere or i.cle_mere=e.cle_mere)'
        +' and i.cle_fiche<>e.cle_fiche'
        +' where u.union_femme=:indi and u.union_mari is not null';
    end;

    if chConjFSC.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CFSC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_femme'
        +' inner join individu f on (f.cle_pere=e.cle_pere or f.cle_mere=e.cle_mere)'
        +' and f.cle_fiche<>e.cle_fiche'
        +' inner join t_union t on t.union_mari=f.cle_fiche and t.union_femme is not null'
        +' inner join individu i on i.cle_fiche=t.union_femme'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CFSC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_femme'
        +' inner join individu f on (f.cle_pere=e.cle_pere or f.cle_mere=e.cle_mere)'
        +' and f.cle_fiche<>e.cle_fiche'
        +' inner join t_union t on t.union_femme=f.cle_fiche and t.union_mari is not null'
        +' inner join individu i on i.cle_fiche=t.union_mari'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CFSC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_mari'
        +' inner join individu f on (f.cle_pere=e.cle_pere or f.cle_mere=e.cle_mere)'
        +' and f.cle_fiche<>e.cle_fiche'
        +' inner join t_union t on t.union_mari=f.cle_fiche and t.union_femme is not null'
        +' inner join individu i on i.cle_fiche=t.union_femme'
        +' where u.union_femme=:indi and u.union_mari is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CFSC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_mari'
        +' inner join individu f on (f.cle_pere=e.cle_pere or f.cle_mere=e.cle_mere)'
        +' and f.cle_fiche<>e.cle_fiche'
        +' inner join t_union t on t.union_femme=f.cle_fiche and t.union_mari is not null'
        +' inner join individu i on i.cle_fiche=t.union_mari'
        +' where u.union_femme=:indi and u.union_mari is not null';
    end;

    if chNeveux.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''NEV'' as type_lien from individu m'
        +' inner join individu f on ((m.cle_pere is not null and f.cle_pere=m.cle_pere)'
        +' or (m.cle_mere is not null and f.cle_mere=m.cle_mere))'
        +' and f.cle_fiche<>m.cle_fiche'
        +' inner join individu i on i.cle_pere=f.cle_fiche or i.cle_mere=f.cle_fiche'
        +' where m.cle_fiche=:indi';
    end;

    if chNeveuxConjoints.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''NEVC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_femme'
        +' inner join individu f on (f.cle_pere=e.cle_pere or f.cle_mere=e.cle_mere)'
        +' and f.cle_fiche<>e.cle_fiche'
        +' inner join individu i on i.cle_pere=f.cle_fiche or i.cle_mere=f.cle_fiche'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''NEVC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_fiche=u.union_mari'
        +' inner join individu f on (f.cle_pere=e.cle_pere or f.cle_mere=e.cle_mere)'
        +' and f.cle_fiche<>e.cle_fiche'
        +' inner join individu i on i.cle_pere=f.cle_fiche or i.cle_mere=f.cle_fiche'
        +' where u.union_femme=:indi and u.union_mari is not null';
    end;

    if chEnfants.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''ENF'' as type_lien from individu i'
        +' where i.cle_pere=:indi or i.cle_mere=:indi';
    end;

    if chConjointsEnfants.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CENF'' as type_lien from individu e'
        +' inner join t_union u on u.union_mari=e.cle_fiche and u.union_femme is not null'
        +' inner join individu i on i.cle_fiche=u.union_femme'
        +' where e.cle_pere=:indi or e.cle_mere=:indi';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CENF'' as type_lien from individu e'
        +' inner join t_union u on u.union_femme=e.cle_fiche and u.union_mari is not null'
        +' inner join individu i on i.cle_fiche=u.union_mari'
        +' where e.cle_pere=:indi or e.cle_mere=:indi';
    end;

    if chEnfantsConjoints.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''ENFC'' as type_lien from t_union u'
        +' inner join individu i on i.cle_mere=u.union_femme and i.cle_pere is distinct from u.union_mari'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''ENFC'' as type_lien from t_union u'
        +' inner join individu i on i.cle_pere=u.union_mari and i.cle_mere is distinct from u.union_femme'
        +' where u.union_femme=:indi and u.union_mari is not null';
    end;

    if chPetitsEnfants.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''PENF'' as type_lien from individu e'
        +' inner join individu i on i.cle_pere=e.cle_fiche or i.cle_mere=e.cle_fiche'
        +' where e.cle_pere=:indi or e.cle_mere=:indi';
    end;

    if chCpetitsEnfants.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CPENF'' as type_lien from individu e'
        +' inner join individu p on p.cle_pere=e.cle_fiche or p.cle_mere=e.cle_fiche'
        +' inner join t_union u on u.union_mari=p.cle_fiche and u.union_femme is not null'
        +' inner join individu i on i.cle_fiche=u.union_femme'
        +' where e.cle_pere=:indi or e.cle_mere=:indi';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CPENF'' as type_lien from individu e'
        +' inner join individu p on p.cle_pere=e.cle_fiche or p.cle_mere=e.cle_fiche'
        +' inner join t_union u on u.union_femme=p.cle_fiche and u.union_mari is not null'
        +' inner join individu i on i.cle_fiche=u.union_mari'
        +' where e.cle_pere=:indi or e.cle_mere=:indi';
    end;

    if chPetitsEnfantsConjoints.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''PENFC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_mere=u.union_femme and e.cle_pere is distinct from u.union_mari'
        +' inner join individu i on i.cle_pere=e.cle_fiche or i.cle_mere=e.cle_fiche'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''PENFC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_pere=u.union_mari and e.cle_mere is distinct from u.union_femme'
        +' inner join individu i on i.cle_pere=e.cle_fiche or i.cle_mere=e.cle_fiche'
        +' where u.union_femme=:indi and u.union_mari is not null';
    end;

    if chCpetitsEnfantsConjoints.Checked then
    begin
      if Req>'' then
        Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CPENFC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_mere=u.union_femme and e.cle_pere is distinct from u.union_mari'
        +' inner join individu p on p.cle_pere=e.cle_fiche or p.cle_mere=e.cle_fiche'
        +' inner join t_union t on t.union_mari=p.cle_fiche and t.union_femme is not null'
        +' inner join individu i on i.cle_fiche=t.union_femme'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CPENFC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_mere=u.union_femme and e.cle_pere is distinct from u.union_mari'
        +' inner join individu p on p.cle_pere=e.cle_fiche or p.cle_mere=e.cle_fiche'
        +' inner join t_union t on t.union_femme=p.cle_fiche and t.union_mari is not null'
        +' inner join individu i on i.cle_fiche=t.union_mari'
        +' where u.union_mari=:indi and u.union_femme is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CPENFC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_pere=u.union_mari and e.cle_mere is distinct from u.union_femme'
        +' inner join individu p on p.cle_pere=e.cle_fiche or p.cle_mere=e.cle_fiche'
        +' inner join t_union t on t.union_mari=p.cle_fiche and t.union_femme is not null'
        +' inner join individu i on i.cle_fiche=t.union_femme'
        +' where u.union_femme=:indi and u.union_mari is not null';
      Req:=Req+' union ';
      Req:=Req+ReqPart1+',''CPENFC'' as type_lien from t_union u'
        +' inner join individu e on e.cle_pere=u.union_mari and e.cle_mere is distinct from u.union_femme'
        +' inner join individu p on p.cle_pere=e.cle_fiche or p.cle_mere=e.cle_fiche'
        +' inner join t_union t on t.union_femme=p.cle_fiche and t.union_mari is not null'
        +' inner join individu i on i.cle_fiche=t.union_mari'
        +' where u.union_femme=:indi and u.union_mari is not null';
    end;

    IBQRecherche.SQL.Add(Req);
    IBQRecherche.SQL.Add(') as s'
      +' left join evenements_ind n on n.ev_ind_kle_fiche=s.cle_fiche and n.ev_ind_type=''BIRT'''
      +' left join evenements_ind d on d.ev_ind_kle_fiche=s.cle_fiche and d.ev_ind_type=''DEAT'''
      +' order by n.ev_ind_datecode nulls last,s.nom,s.prenom');
    IBQRecherche.DisableControls;
    IBQRecherche.ParamByName('indi').AsInteger:=IndiEnCours;
    IBQRechercheTYPE_LIEN.Size:=24;
    IBQRecherche.Open;
    IBQRecherche.EnableControls;
  finally
    bOkMajTV:=true;
  end;
  RempliTV;
  bsfbSelection.Enabled:=not IBQRecherche.IsEmpty;
  btnPrint.Enabled:=bsfbSelection.Enabled;
  Screen.Cursor:=Save_Cursor;
end;

procedure TFEnvFamille.sbClearClick(Sender:TObject);
var
  etat:boolean;
begin
  if sbClear.Caption=rs_Caption_Uncheck_all then
  begin
    sbClear.Caption:= rs_Caption_Check_all;
    etat:=false;
  end
  else
  begin
    sbClear.Caption:=rs_Caption_Uncheck_all;
    etat:=true
  end;
  chParents.Checked:=etat;
  chConjointsParents.Checked:=etat;
  chGrandsParents.Checked:=etat;
  chConjointsGP.Checked:=etat;
  chOnclesTantes.Checked:=etat;
  chCOnclesTantes.Checked:=etat;
  chFreresSoeurs.Checked:=etat;
  chCFreresSoeurs.Checked:=etat;
  chCousins.Checked:=etat;
  chCCousins.Checked:=etat;
  chConjoints.Checked:=etat;
  chParentsConjoints.Checked:=etat;
  chBParentsConjoints.Checked:=etat;
  chFSConjoints.Checked:=etat;
  chConjFSC.Checked:=etat;
  chNeveux.Checked:=etat;
  chNeveuxConjoints.Checked:=etat;
  chEnfants.Checked:=etat;
  chConjointsEnfants.Checked:=etat;
  chEnfantsConjoints.Checked:=etat;
  chPetitsEnfants.Checked:=etat;
  chCpetitsEnfants.Checked:=etat;
  chPetitsEnfantsConjoints.Checked:=etat;
  chCpetitsEnfantsConjoints.Checked:=etat;
end;

procedure TFEnvFamille.SuperFormCreate(Sender:TObject);
//var
//  fIni:TIniFile;
begin
  Color:=gci_context.ColorLight;
  dbgStd.Hint:=rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns;
  TVasc .NodeDataSize := Sizeof(TIndivTree)+1;
  TVdesc.NodeDataSize := Sizeof(TIndivTree)+1;
  PanelChoix.Color:=gci_context.ColorMedium;
  LabelChoix.Font.Color:=gci_context.ColorTexteOnglets;
  LabelListe.Font.Color:=gci_context.ColorTexteOnglets;
  // Matthieu dans onforminfoini
//  dbgStdDBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_ENV_FAMILLE');
// Matthieu : Dans OnFormInfoIni sur la fiche
{  fIni:=f_GetMemIniFile;
  try
    fIni.RootKey:=HKEY_CURRENT_USER;
    if fIni.OpenKey(gci_context.Keyfonctions_init,True) then
    begin
      Height:=fIni.ReadInteger('W_ENV_FAMILLE','HauteurForme',400);
      Width:=fIni.ReadInteger('W_ENV_FAMILLE','LargeurForme',600);
      PanelChoix.Width:=fIni.ReadInteger('W_ENV_FAMILLE','PanelChoix',210);
      PanelTV.Height:=fIni.ReadInteger('W_ENV_FAMILLE','PanelTV',110);
      TVdesc.Width:=fIni.ReadInteger('W_ENV_FAMILLE','TVdesc',250);
      chParents.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chParents',true);
      chConjointsParents.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chConjointsParents',false);
      chGrandsParents.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chGrandsParents',false);
      chConjointsGP.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chConjointsGP',false);
      chOnclesTantes.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chOnclesTantes',false);
      chCOnclesTantes.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chCOnclesTantes',false);
      chFreresSoeurs.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chFreresSoeurs',false);
      chCFreresSoeurs.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chCFreresSoeurs',false);
      chCousins.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chCousins',false);
      chCCousins.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chCCousins',false);
      chConjoints.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chConjoints',false);
      chParentsConjoints.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chParentsConjoints',false);
      chBParentsConjoints.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chBParentsConjoints',false);
      chFSConjoints.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chFSConjoints',false);
      chConjFSC.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chConjFSC',false);
      chNeveux.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chNeveux',false);
      chNeveuxConjoints.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chNeveuxConjoints',false);
      chEnfants.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chEnfants',false);
      chConjointsEnfants.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chConjointsEnfants',false);
      chEnfantsConjoints.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chEnfantsConjoints',false);
      chPetitsEnfants.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chPetitsEnfants',false);
      chCpetitsEnfants.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chCpetitsEnfants',false);
      chPetitsEnfantsConjoints.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chPetitsEnfantsConjoints',false);
      chCpetitsEnfantsConjoints.Checked:=fIni.ReadBool('W_ENV_FAMILLE','chCpetitsEnfantsConjoints',false);
    end;
  finally
    fIni.Free;
  end;
           }
  fCleFicheSelected:=-1;
  bDejaPasse:=false;
  SaveDialog.InitialDir:=gci_context.PathDocs;
end;

procedure TFEnvFamille.SuperFormResize(Sender: TObject);
begin
  if WindowState=wsMinimized then
  begin //PanelChoix.MinHeight aumente la hauteur de la fiche quand elle est minimisée!
    ClientHeight:=565;//pour rétablir une hauteur normale au retour de la minimisation
    Refresh;
  end;
end;

procedure TFEnvFamille.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQRecherche.Close;
  // Matthieu ?
//  dbgStdDBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_ENV_FAMILLE');
  // Matthieu : Dans OnFormInfoIni sur la fiche
  {
  fIni:=f_GetMemIniFile;
  try
    fIni.RootKey:=HKEY_CURRENT_USER;
    if fIni.OpenKey(gci_context.Keyfonctions_init,True) then
    begin
      fIni.WriteInteger('W_ENV_FAMILLE','HauteurForme',Height);
      fIni.WriteInteger('W_ENV_FAMILLE','LargeurForme',Width);
      fIni.WriteInteger('W_ENV_FAMILLE','PanelChoix',PanelChoix.Width);
      fIni.WriteInteger('W_ENV_FAMILLE','PanelTV',PanelTV.Height);
      fIni.WriteInteger('W_ENV_FAMILLE','TVdesc',TVdesc.Width);
      fIni.WriteBool('W_ENV_FAMILLE','chParents',chParents.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chConjointsParents',chConjointsParents.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chGrandsParents',chGrandsParents.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chConjointsGP',chConjointsGP.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chOnclesTantes',chOnclesTantes.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chCOnclesTantes',chCOnclesTantes.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chFreresSoeurs',chFreresSoeurs.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chCFreresSoeurs',chCFreresSoeurs.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chCousins',chCousins.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chCCousins',chCCousins.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chConjoints',chConjoints.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chParentsConjoints',chParentsConjoints.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chBParentsConjoints',chBParentsConjoints.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chFSConjoints',chFSConjoints.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chConjFSC',chConjFSC.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chNeveux',chNeveux.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chNeveuxConjoints',chNeveuxConjoints.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chEnfants',chEnfants.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chConjointsEnfants',chConjointsEnfants.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chEnfantsConjoints',chEnfantsConjoints.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chPetitsEnfants',chPetitsEnfants.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chCpetitsEnfants',chCpetitsEnfants.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chPetitsEnfantsConjoints',chPetitsEnfantsConjoints.Checked);
      fIni.WriteBool('W_ENV_FAMILLE','chCpetitsEnfantsConjoints',chCpetitsEnfantsConjoints.Checked);
    end;
  finally
  end;    }
  Action:=caFree;
  DoSendMessage(Owner,'FERME_FORM_ENV_FAMILLE');
end;

procedure TFEnvFamille.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  if Key=VK_RETURN then
    DoRechercher(-1,'');
end;

procedure TFEnvFamille.option_ExporterHTMLClick(Sender:TObject);
var
  SavePlace:TBookmark;
  b:boolean;
begin
  SaveDialog.FileName:='Environnement familial.htm';
  if SaveDialog.Execute then
  begin
    b:=bOkMajTV;
    bOkMajTV:=false;
    IBQRecherche.DisableControls;
    SavePlace:=IBQRecherche.GetBookmark;
    ExportGridToHTML(SaveDialog.FileName,dbgSTD,True,True);

    IBQRecherche.GotoBookmark(SavePlace);
    IBQRecherche.FreeBookmark(SavePlace);
    IBQRecherche.EnableControls;
    bOkMajTV:=b;
  end;
end;

procedure TFEnvFamille.PopupMenuGridPopup(Sender:TObject);
var
  i:integer;
begin
  for i:=PopupMenuGrid.Items.Count-1 downto 5 do
    PopupMenuGrid.Items[i].Free;
  if IBQRecherche.Active and not IBQRecherche.IsEmpty then
  begin
    option_ExporterHTML.enabled:=true;
    mOuvrirlafiche.Enabled:=true;
    FMain.RempliPopMenuParentsConjointsEnfants(PopupMenuGrid,IBQRechercheCLE_FICHE.AsInteger
      ,IBQRechercheSEXE.AsInteger,false);
  end
  else
  begin
    option_ExporterHTML.enabled:=false;
    mOuvrirlafiche.Enabled:=false;
  end;
end;

procedure TFEnvFamille.doSelect;
begin
  if fCleFicheSelected>0 then
  begin
    // Matthieu ?
    DefaultCloseAction:=caNone;
    dm.individu_clef:=fCleFicheSelected;
    DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
  end;
end;

procedure TFEnvFamille.bsfbSelectionClick(Sender:TObject);
begin
  doSelect;
end;

procedure TFEnvFamille.btnFermerClick(Sender:TObject);
begin
  close;
end;

procedure TFEnvFamille.SupprimerlestrisClick(Sender:TObject);
var
  i:integer;
begin
  for i:=0 to dbgStd.Columns.Count-1 do
    dbgStd.Columns[i].SortOrder:=smNone;
  if IBQRecherche.Active then
  begin
    IBQRecherche.Close;
    IBQRecherche.Open;
  end;
end;

procedure TFEnvFamille.dxDBNomDrawColumnCell(Sender:TObject;
  ACanvas:TCanvas;AViewInfo:Longint;
  var ADone:Boolean);
begin
  // Matthieu il manque dxDBNom
  {
  if (AViewInfo.GridRecord.Values[dxDBNumSosa.Index]>0) then
  begin
    ACanvas.Font.Style:=ACanvas.Font.Style+ [fsBold];
    ACanvas.Font.Color:=_COLOR_SOSA;
  end
  else
  begin
    ACanvas.Font.Style:=ACanvas.Font.Style- [fsBold];
    ACanvas.Font.Color:=clWindowText;
  end;}
end;

procedure TFEnvFamille.mOuvrirlaficheClick(Sender:TObject);
begin
  doSelect;
end;

procedure TFEnvFamille.dbgStdDBTableView1CellDblClick(
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

procedure TFEnvFamille.TVascBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  with PIndivTree(Sender.GetNodeData(Node))^ do
   begin
    if (sosa=1)and(sexe<>-4) then
      Sender.Canvas.Font.Color:=_COLOR_SOSA
    else
      case sexe of
        2,-2:Sender.Canvas.Font.Color:=gci_context.ColorFemme;
        1,-1:Sender.Canvas.Font.Color:=gci_context.ColorHomme;
      else
        Sender.Canvas.Font.Color:=clWindowText;
      end;

    if Node = sender.RootNode then
      Sender.Canvas.Font.Style:= [fsBold];
    if Sender.Selected[Node] then
      Sender.Canvas.Brush.Color:=gci_context.ColorMedium;
   end;
end;



procedure TFEnvFamille.TVascGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  case PIndivTree(sender.GetNodeData(Node))^.sexe of
    1:ImageIndex:=1;
    2:ImageIndex:=2;
    -1:ImageIndex:=3;
    -2:ImageIndex:=4;
    -3:ImageIndex:=5;
    -4:ImageIndex:=6;
  else
    ImageIndex:=0;
  end;

end;

procedure TFEnvFamille.RempliTV;
var
  j:Integer;
  aparent : PVirtualNode;
  s:string;
begin
  Screen.Cursor:=crHourglass;
  IdentifieTypeLien;
  TVdesc.BeginUpdate;
  TVasc .BeginUpdate;
  TVdesc.Clear;
  TVasc.Clear;
  BarEtat.Panels[0].Text:=dm.ChaineHintIndi(fCleFicheSelected,' - ');
  if IBQRechercheCLE_FICHE.IsNull then
  begin
    OuvreDepuisAsc.Enabled:=false;
    OuvreDepuisDesc.Enabled:=false;
    Screen.Cursor:=crDefault;
    Exit
  end
  else
  begin
    OuvreDepuisAsc.Enabled:=true;
    OuvreDepuisDesc.Enabled:=true;
  end;
  indiv.cle:=IBQRechercheCLE_FICHE.AsInteger;
  s:=fs_RemplaceMsg(rs_Joint_s_Child_ren_of,[IBQRechercheNOM.AsString]);
  if length(IBQRecherchePRENOM.AsString)>0 then
    indiv.Nom:=s+' '+IBQRecherchePRENOM.AsString
  else
    indiv.Nom:=s;
  indiv.sexe:=-4;
  if IBQRechercheNUM_SOSA.AsFloat>0 then
    indiv.sosa:=1
  else
    indiv.sosa:=0;
  TreeAjouterEnfant(TVdesc,nil);

  qDesc.close;
  qDesc.ParamByName('cle_fiche').AsInteger:=IBQRechercheCLE_FICHE.AsInteger;
  qDesc.ExecQuery;
  j:=-10;
  aparent:=0;
  while not qDesc.Eof do //on remplit TVdesc
  with qdesc do
  begin
    if (FieldByName('CLE_CONJOINT').AsInteger<>j) then //on ajoute un conjoint
    begin
      j:=FieldByName('CLE_CONJOINT').AsInteger;
      if j=0 then
        indiv.cle:=IBQRechercheCLE_FICHE.AsInteger
      else
        indiv.cle:=j;
      indiv.sexe:=FieldByName('SEXE_CONJOINT').AsInteger;
      if indiv.sexe=0 then
        indiv.sexe:=IBQRechercheSEXE.AsInteger-3;
      if FieldByName('NOM_CONJOINT').AsString='?' then
      begin
        case indiv.sexe of
          1,-1:indiv.Nom:='Inconnu';
          2,-2:indiv.Nom:='Inconnue';
        else
          indiv.Nom:='Inconnu';
        end;
      end
      else
        indiv.Nom:=FieldByName('NOM_CONJOINT').AsString;
      indiv.Prenom:=FieldByName('PRENOM_CONJOINT').AsString;
      indiv.DateNaiss:=FieldByName('DATE_NAISSANCE_CONJOINT').AsString;
      indiv.DateDeces:=FieldByName('DATE_DECES_CONJOINT').AsString;
      indiv.sosa:=FieldByName('SOSA_CONJOINT').AsInteger;
      aparent:=TreeAjouterEnfant(TVdesc,nil);
    end;
    if FieldByName('CLE_FICHE').AsInteger>0 then
    begin
      indiv.cle:=FieldByName('CLE_FICHE').AsInteger;
      indiv.Nom:=FieldByName('NOM').AsString;
      indiv.Prenom:=FieldByName('PRENOM').AsString;
      indiv.sexe:=FieldByName('SEXE').AsInteger;
      indiv.sosa:=FieldByName('SOSA').AsInteger;
      indiv.DateNaiss:=FieldByName('DATE_NAISSANCE').AsString;
      indiv.DateDeces:=FieldByName('DATE_DECES').AsString;
      TreeAjouterEnfant(TVdesc,aparent);
    end;
    qDesc.Next;
  end;
  qDesc.close;
  bBloquExpand:=false;
  TVdesc.FullExpand;
  bBloquExpand:=true;
  TVdesc.EndUpdate;
//  TVdesc.Items.GetFirstNode.MakeVisible;

  indiv.cle:=IBQRechercheCLE_FICHE.AsInteger;
  s:=fs_RemplaceMsg(rs_Parents_of,[IBQRechercheNOM.AsString]);
  if length(IBQRecherchePRENOM.AsString)>0 then
    s:=s+' '+IBQRecherchePRENOM.AsString;
  indiv.Nom:=s+' (NIP '+IBQRechercheCLE_FICHE.AsString+')';
  indiv.sexe:=-3;
  if IBQRechercheNUM_SOSA.AsFloat>0 then
    indiv.sosa:=1
  else
    indiv.sosa:=0;
  TreeAjouterEnfant(TVasc,nil);

  qAsc.close;
  qAsc.ParamByName('cle_fiche').AsInteger:=IBQRechercheCLE_FICHE.AsInteger;
  qAsc.ExecQuery;
  while not qAsc.Eof do //on remplit TVasc
  with qAsc do
  begin
    indiv.cle:=FieldByName('CLE_FICHE').AsInteger;
    indiv.Nom:=FieldByName('NOM').AsString;
    indiv.Prenom:=FieldByName('PRENOM').AsString;
    indiv.sexe:=FieldByName('SEXE').AsInteger;
    indiv.sosa:=FieldByName('SOSA').AsInteger;
    indiv.DateNaiss:=FieldByName('DATE_NAISSANCE').AsString;
    indiv.DateDeces:=FieldByName('DATE_DECES').AsString;
    if (FieldByName('ordre').AsInteger=1)or(FieldByName('ordre').AsInteger=4) then
      aparent:=TreeAjouterEnfant(TVasc,nil)
    else
      TreeAjouterEnfant(TVasc,aparent);
    qAsc.Next;
  end;
  qAsc.Close;
  bBloquExpand:=false;
  TVasc.FullExpand;
  bBloquExpand:=true;
//  TVasc.Items.GetFirstNode.MakeVisible;
  TVasc.EndUpdate;

  Screen.Cursor:=crDefault;
end;

procedure TFEnvFamille.dbgStdDBTableView1FocusedRecordChanged(
  Sender: TObject; APrevFocusedRecord,
  AFocusedRecord: Longint;
  ANewItemRecordFocusingChanged: Boolean);
begin
  fCleFicheSelected:=IBQRechercheCLE_FICHE.AsInteger;
  if bOkMajTV then
    RempliTV;
end;

procedure TFEnvFamille.TVascCustomDrawItem(Sender: TBaseVirtualTree;
  Node: PVirtualNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
end;

procedure TFEnvFamille.TVascDblClick(Sender: TObject);
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

procedure TFEnvFamille.TVascClick(Sender: TObject);
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

procedure TFEnvFamille.PMdescPopup(Sender: TObject);
begin
  if TVdesc.FocusedNode<>nil then
  begin
    IndiTV:=PIndivTree(TVdesc.GetNodeData(TVdesc.FocusedNode))^;
    OuvreDepuisDesc.Enabled:=true;
  end
  else
    OuvreDepuisDesc.Enabled:=false;
end;

procedure TFEnvFamille.PMascPopup(Sender: TObject);
begin
  if TVasc.FocusedNode<>nil then
  begin
    IndiTV:=PIndivTree(TVasc.GetNodeData(TVasc.FocusedNode))^;
    OuvreDepuisAsc.Enabled:=true;
  end
  else
    OuvreDepuisAsc.Enabled:=false;
end;

procedure TFEnvFamille.OuvreDepuisAscClick(Sender: TObject);
begin
  fCleFicheSelected:=IndiTV.cle;
  BarEtat.Panels[0].Text:=dm.ChaineHintIndi(fCleFicheSelected,' - ');
  doSelect;
end;

procedure TFEnvFamille.TVascGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  with PIndivTree ( sender.GetNodeData(Node))^ do
   Begin
    CellText:=nom;
    if length(prenom)>0 then
      CellText:=CellText+' '+prenom;
    CellText:=CellText+GetStringNaissanceDeces(trim(DateNaiss),trim(DateDeces));
   end;

end;

procedure TFEnvFamille.TVascInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  with PIndivTree ( sender.GetNodeData(Node))^ do
    begin
      cle:=Indiv.cle;
      DateDeces:=Indiv.DateDeces;
      DateNaiss:=Indiv.DateNaiss;
      Nom:=Indiv.Nom;
      Prenom:=Indiv.Prenom;
      sexe:=Indiv.sexe;
      sosa:=Indiv.sosa;
    end;
end;

procedure TFEnvFamille.TVascMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Noeud:PVirtualNode;
  Tree:TVirtualStringTree;
begin
  Tree:=(sender as TVirtualStringTree);
  XMouse:=X;
  Noeud:=Tree.GetNodeAt(X,Y);
  if (Noeud<>nil) and (Noeud<>Tree.RootNode) then
    Tree.Cursor:=_CURPOPUP
  else
    Tree.Cursor:=crDefault;
end;

procedure TFEnvFamille.TVascMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Noeud:PVirtualNode;
  Tree:TVirtualStringTree;
begin
  Tree:=(sender as TVirtualStringTree);
  Noeud:=Tree.GetNodeAt(X,Y);
  if Noeud<>nil then
  begin
    Tree.Selected[Noeud] := Shift <> [];
  end;
end;

procedure TFEnvFamille.TVascExpanding(Sender: TObject; Node: PVirtualNode;
  var AllowExpansion: Boolean);
begin
  if (Xmouse>(GetNodeLevel(node,TVasc.RootNode)+1)*TVasc.Indent)and bBloquExpand then
    AllowExpansion:=false;
end;

procedure TFEnvFamille.TVascCollapsing(Sender: TObject; Node: PVirtualNode;
  var AllowCollapse: Boolean);
begin
  if (Xmouse>(GetNodeLevel(node,TVasc.RootNode)+1)*TVasc.Indent)and bBloquExpand then
    AllowCollapse:=false;
end;

procedure TFEnvFamille.TVdescExpanding(Sender: TObject; Node: PVirtualNode;
  var AllowExpansion: Boolean);
begin
  if (Xmouse>(GetNodeLevel(node,TVdesc.RootNode)+1)*TVdesc.Indent)and bBloquExpand then
    AllowExpansion:=false;
end;

procedure TFEnvFamille.TVdescCollapsing(Sender: TObject; Node: PVirtualNode;
  var AllowCollapse: Boolean);
begin
  if (Xmouse>(GetNodeLevel(node,TVdesc.RootNode)+1)*TVdesc.Indent)and bBloquExpand then
    AllowCollapse:=false;
end;

procedure TFEnvFamille.IdentifieTypeLien;
var
  LienCherche:string;
  i:integer;
begin
  if IBQRecherche.IsEmpty then
    LienCherche:='()'
  else
    LienCherche:='('+IBQRechercheTYPE_LIEN.AsString+')';
  for i:=0 to PanelChoix.ControlCount-1 do
  begin
    if PanelChoix.Controls[i] is TJvXPCheckBox then
    begin
      if Pos(LienCherche,(PanelChoix.Controls[i] as TJvXPCheckBox).Caption)>0 then
        (PanelChoix.Controls[i] as TJvXPCheckBox).Font.Style:=[fsUnderline]
      else
        (PanelChoix.Controls[i] as TJvXPCheckBox).Font.Style:=[];
    end;
  end;
end;

procedure TFEnvFamille.mLiensClick(Sender: TObject);
begin
  FMain.OuvreLienIndividus(IndiEnCours,IBQRechercheCLE_FICHE.AsInteger);
end;

procedure TFEnvFamille.btnPrintClick(Sender: TObject);
begin
  // Matthieu
  btnPrint.DBTitle:=Caption;
end;


procedure TFEnvFamille.dbgStdMouseEnter(Sender: TObject);
begin
  // Matthieu : pas de style
//  dm.cxHintStyleController1.HintStyle.Standard:=true;
end;

procedure TFEnvFamille.dbgStdMouseLeave(Sender: TObject);
begin
//  dm.cxHintStyleController1.HintStyle.Standard:=false;
end;

procedure TFEnvFamille.dbgStdDBTableView1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FMain.IndiDrag.cle:=IBQRechercheCLE_FICHE.AsInteger;
  FMain.IndiDrag.sexe:=IBQRechercheSEXE.AsInteger;
  FMain.IndiDrag.nomprenom:=AssembleString([IBQRechercheNOM.AsString,IBQRecherchePRENOM.AsString]);
  FMain.IndiDrag.naissance:= IBQRechercheDATE_NAISSANCE.AsString;
  FMain.IndiDrag.deces:= IBQRechercheDATE_DECES.AsString;
end;

end.
