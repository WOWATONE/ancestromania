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

unit u_form_individu_repertoire;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  U_FormAdapt, u_comp_TYLanguage,
  Dialogs, DB, Menus,
  IBCustomDataSet, IBQuery, StdCtrls,
  Controls, ExtCtrls, Classes, Contnrs,
  Graphics, SysUtils, Forms,
  u_buttons_appli, U_ExtDBGrid,
  Variants, VirtualTrees, ComCtrls,
  IBSQL, u_ancestropictbuttons,
  U_OnFormInfoIni, DBGrids, rxdbgrid;

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
    Lettre:string;
    DateMarr:string;
  end;

  TFicheInfo=class
  private
    CleFiche:integer;
    Sexe:integer;
    Titre:string;
    Lettre:string;
    Nom:string;
  public
    constructor Create;
  end;

  { TFIndividuRepertoire }

  TFIndividuRepertoire=class(TF_FormAdapt)
    cxSplitterH: TSplitter;
    IBQListeNom:TIBQuery;
    dsListeNom:TDataSource;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    OnFormInfoIni: TOnFormInfoIni;
    Panel2: TPanel;
    pmGrid:TPopupMenu;
    mOuvrir:TMenuItem;
    N2:TMenuItem;
    ExporterenHTML1:TMenuItem;
    IBQListePreNom:TIBQuery;
    DSListePreNom:TDataSource;
    panBtn:TPanel;
    SaveDialog:TSaveDialog;
    Language:TYLanguage;
    bsfbSelection:TFWOK;
    btnFermer:TFWCancel;
    bfsbCreation:TFWAdd;
    Panel1:TPanel;
    cxTabOnglet:TTabControl;
    panDock:TPanel;
    Panel8:TPanel;
    lbParPrenom:TLabel;
    rbF:TRadioButton;
    rbH:TRadioButton;
    rbTous:TRadioButton;
    Panel9:TPanel;
    Panel12:TPanel;
    dxDBGrid1:TExtDBGrid;
    cxSplitter1:TSplitter;
    dxDBGrid2:TExtDBGrid;
    IBQListeNomNOM:TIBStringField;
    IBQListePreNomCLE_FICHE:TLongintField;
    IBQListePreNomSEXE:TLongintField;
    IBQListePreNomSURNOM:TStringField;
    IBQListePreNomNUM_SOSA:TFloatField;
    IBQListePreNomANNEE_NAISSANCE:TLongintField;
    IBQListePreNomVILLE:TStringField;
    IBQListePreNomCP:TStringField;
    IBQListePreNomsubd_naissance:TStringField;
    IBQListePreNomANNEE_DECES:TLongintField;
    IBQListePreNomVILLE_DECES:TStringField;
    IBQListePreNomCP_DECES:TStringField;
    IBQListePreNomsubd_deces:TStringField;
    IBQListePreNomMERE_CLE_FICHE:TLongintField;
    IBQListePreNomPERE_CLE_FICHE:TLongintField;
    IBQListePreNomNOM:TStringField;
    IBQListePreNomregion_naissance:TStringField;
    IBQListePreNompays_naissance:TStringField;
    IBQListePreNomregion_deces:TStringField;
    IBQListePreNompays_deces:TStringField;
    IBQListePreNomdept_naissance:TStringField;
    IBQListePreNomdept_deces:TStringField;
    IBQListePreNomPRENOM: TStringField;
    IBQListePreNomDATE_NAISSANCE: TStringField;
    IBQListePreNomDATE_DECES: TStringField;
    N1:TMenuItem;
    Supprimerlestris:TMenuItem;
    TVdesc:TVirtualStringTree;
    cxSplitter3:TSplitter;
    TVasc:TVirtualStringTree;
    NomIndiSelectionne:TMenuItem;
    mReajustementdescolonnes:TMenuItem;
    mAvecpat:TMenuItem;
    mParente:TMenuItem;
    IBQListePreNomIND_CONFIDENTIEL:TSmallintField;
    mConsulterlafiche:TMenuItem;
    mLiens:TMenuItem;
    qAsc:TIBSQL;
    qDesc:TIBSQL;
    mOuvrirArbre:TMenuItem;
    Ascendance1:TMenuItem;
    Descendance1:TMenuItem;
    BarEtat:TStatusBar;
    mEnvFam:TMenuItem;
    N3:TMenuItem;
    btnPrecedent: TXAPrior;
    btnSuivant: TXANext;
    popup_Suivant: TPopupMenu;
    popup_Precedent: TPopupMenu;
    procedure dxDBGrid2GetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
    procedure IBQListeNomAfterScroll(DataSet: TDataSet);
    procedure IBQListePreNomAfterScroll(DataSet: TDataSet);
    procedure pmGridPopup(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure rbTousChange(Sender:TObject);
    procedure SpeedButton2Click(Sender:TObject);
    procedure bsfbSelectionClick(Sender:TObject);
    procedure bfsbCreationClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure cxTabOngletChange(Sender:TObject);
    procedure SuperFormDestroy(Sender:TObject);
    procedure SupprimerlestrisClick(Sender:TObject);
    procedure TVascCustomDrawItem(Sender:TCustomTreeView;Node:TTreeNode;
      State:TCustomDrawState;var DefaultDraw:Boolean);
    procedure TVascGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure TVascGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure btnFermerClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mReajustementdescolonnesClick(Sender:TObject);
    procedure mAvecpatClick(Sender:TObject);
    procedure mParenteClick(Sender:TObject);
    procedure mConsulterlaficheClick(Sender:TObject);
    procedure dxDBGrid1DBTableView1FocusedRecordChanged(
      Sender:TObject;APrevFocusedRecord,
      AFocusedRecord:Longint;
      ANewItemRecordFocusingChanged:Boolean);
    procedure cxTabOngletDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
    procedure dxDBGrid2DBTableView1CellDblClick(
      Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure SuperFormShow(Sender:TObject);
    procedure mLiensClick(Sender:TObject);
    procedure TVascClick(Sender:TObject);
    procedure TVascMouseDown(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure TVascMouseMove(Sender:TObject;Shift:TShiftState;X,
      Y:Integer);
    procedure Ascendance1Click(Sender:TObject);
    procedure Descendance1Click(Sender:TObject);
    procedure mEnvFamClick(Sender:TObject);
    procedure dxDBGrid2MouseEnter(Sender: TObject);
    procedure dxDBGrid2MouseLeave(Sender: TObject);
    procedure popup_PrecedentPopup(Sender: TObject);
    procedure popup_SuivantPopup(Sender: TObject);
    procedure btnPrecedentClick(Sender: TObject);
    procedure btnSuivantClick(Sender: TObject);
    procedure dxDBGrid2DBTableView1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure cxTabOngletClick(Sender: TObject);
    procedure dxDBGrid1DBTableView1KeyPress(Sender: TObject;
      var Key: Char);
  private
    fNumOngletSelected:integer;
    fClefIndividuSelected:integer;
    fNomPrenomIndividuSelected:string;
    fSexeIndividuSelected:integer;
    fSexe:integer;
    fNom:string;
    fCreation:boolean;
    bDejaPasse:boolean;
    bFin,bSelect,bInitFenetre:boolean;

    fCanScrollPrenom,fCanScrollNom:boolean;
    fDecesIndividuSelected:string;
    fNaissanceIndividuSelected:string;
    bModal:boolean;
    ListeFiches:TObjectList;
    IndexListeFiches:integer;
    bSelectDepuisListe:boolean;
    bClicOnglet:boolean;

    procedure doFillBottomInfos;//ajoute aussi à la liste des individus consultés
    procedure doSelect;
    procedure doRefreshPrenoms;
    procedure AddFicheDansListe(CleFiche,Sexe:integer;Titre,Lettre,Nom:string);
    procedure SuppFicheDansListe(CleFiche:integer);
    procedure ModifFicheDansListe(CleFiche,Sexe:integer;Titre,Lettre,Nom:string);
    procedure mItemListeClick(Sender: TObject);
    function ItemMenuListe(n:integer):TMenuItem;
    procedure SelectDepuisListe(Index:integer);

  public
    L:array of Integer;

    property ClefIndividuSelected:integer read fClefIndividuSelected write fClefIndividuSelected;
    property NomPrenomIndividuSelected:string read fNomPrenomIndividuSelected write fNomPrenomIndividuSelected;
    property SexeIndividuSelected:integer read fSexeIndividuSelected write fSexeIndividuSelected;
    property NaissanceIndividuSelected:string read fNaissanceIndividuSelected write fNaissanceIndividuSelected;
    property DecesIndividuSelected:string read fDecesIndividuSelected write fDecesIndividuSelected;
    property Sexe:integer read fSexe write fSexe;
    property NomIndi:string read fNom write fNom;
    property Creation:boolean read fCreation write fCreation;

    procedure InitIndividuPrenom(a_Lettre,a_Type:string;a_Sexe,i_Cle:integer;b_Select,b_Modal:boolean);
    //a_Lettre= lettre de l'onglet à sélectionner
    //a_Type= "INDEX" retrouve l'individu i_Cle dans la liste
    //b_Select autorise la sélection multiple
    procedure doRefreshRepertoire;

    procedure InitOngletsActifs;
  end;

implementation

uses u_dm,
     u_form_main,
     u_form_individu_Saisie_Rapide,
     u_common_functions,
     u_common_ancestro,
     u_common_const,
     u_genealogy_context,
     LCLStrConsts,
     LazUTF8,
     u_common_ancestro_functions,
     fonctions_components,fonctions_string;
{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}
const CST_Surnom = 21;
      CST_SEXE = 1;
      CST_Nom = 2;
      CST_Prenom = 3;
      CST_NE = 4;
      CST_AnneeNaissance = 5;
      CST_VilleNaissance = 6;
      CST_CP = 7;
      CST_SubNaissance = 8;
      CST_DeptNaissance = 9;
      CST_RegionNaissance = 10;
      CST_PaysNaissance = 11;
      CST_Deces = 12;
      CST_AnneeDeces = 13;
      CST_VilleDeces = 14;
      CST_CPDeces = 15;
      CST_SubDeces = 16;
      CST_DeptDeces = 17;
      CST_RegionDeces = 18;
      CST_PaysDeces = 19;
      CST_SOSA = 20;

procedure TFIndividuRepertoire.InitIndividuPrenom(a_Lettre,a_Type:string;a_Sexe,i_Cle:integer;b_Select,b_Modal:boolean);
var
  i_Tab:smallInt;
begin
  if not bInitFenetre then
  begin
    bInitFenetre:=true;

    bSelect:=b_Select;
    dxDBGrid2.Options := dxDBGrid2.Options + [ dgMultiSelect];
    dxDBGrid2.Options := dxDBGrid2.Options + [ dgEditing ];//la sélection n'est plus visible si MultiSelect=true!

    bModal:=b_Modal;
    if bModal then
    begin
      // Matthieu : Plus tard
      //dxDBGrid2DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_INDEX_NOMS_E',False,False, [gsoUseFilter],'GrillePrenoms');
      //dxDBGrid2.DragMode:=dmManual;
    end
    else
    begin
      // Matthieu : Plus tard
      // dxDBGrid2DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_INDEX_NOMS_F',False,False, [gsoUseFilter],'GrillePrenoms');
      //dxDBGrid2.DragMode:=dmAutomatic;
    end;

    if a_Type='NUM_SOSA' then
    begin
      bfsbCreation.visible:=false;
      bsfbSelection.Caption:=rs_Caption_Renumber;
      ExporterenHTML1.Visible:=false;
      mOuvrir.Visible:=false;
      N2.Visible:=false;
      fClefIndividuSelected:=i_Cle;
    end;
  end;

  fSexe:=a_Sexe;
  case a_Sexe of
    1: rbH.checked:=true;
    2: rbF.checked:=true;
    else rbTous.checked:=true;
  end;

  if a_Type='INDEX' then
    fClefIndividuSelected:=i_Cle;

  i_Tab:=POS(a_Lettre,_AlphabetMaj);

  bFin:=false;
  cxTabOnglet.TabIndex:=i_Tab;
  fNumOngletSelected:=i_Tab;
  bFin:=true;
  doRefreshRepertoire;
end;

procedure TFIndividuRepertoire.doRefreshRepertoire;
begin
  fCanScrollNom:=false;

  with IBQListeNom do
  begin
    DisableControls;
    try
      Close;
      SQL.Clear;
      if fNumOngletSelected>0 then
      begin
        SQL.Add('select distinct nom'
          +' from'
          +' (SELECT DISTINCT i.nom'
          +' FROM INDIVIDU i'
          +' WHERE i.KLE_DOSSIER = :I_DOSSIER'
          +' and i.INDI_TRIE_NOM STARTING WITH :debut');
        if gci_context.IndexFavecPat then
          SQL.Add('union'
            +' SELECT DISTINCT p.nom'
            +' FROM nom_attachement p'
            +' inner join INDIVIDU i on i.cle_fiche=p.id_indi'
            +' WHERE p.nom_lettre=:debut and p.KLE_DOSSIER=:I_DOSSIER');
        SQL.Add(') order by nom');  // collate fr_fr
        ParamByName('debut').AsString:=copy(_AlphabetMaj,fNumOngletSelected,1);//nom commençant par
      end
      else
      begin
        SQL.Add('select distinct nom'
          +' from'
          +' (SELECT DISTINCT i.nom'
          +' FROM INDIVIDU i'
          +' WHERE i.KLE_DOSSIER = :I_DOSSIER'
          +' and substring(indi_trie_nom from 1 for 1) not between ''A'' and ''Z''');
        if gci_context.IndexFavecPat then
          SQL.Add('union'
            +' SELECT DISTINCT p.nom'
            +' FROM nom_attachement p'
            +' inner join INDIVIDU i on i.cle_fiche=p.id_indi'
            +' where p.nom_lettre not between ''A'' and ''Z'' and p.KLE_DOSSIER=:I_DOSSIER');
        SQL.Add(') order by nom');        // collate fr_fr
      end;

      ParamByName('I_DOSSIER').AsInteger:=dm.NumDossier;
      Open;
      if not IBQListeNom.IsEmpty Then
        IBQListeNom.Locate('NOM',fNom, []);
    finally
      EnableControls;
      fCanScrollNom:=not IBQListeNom.IsEmpty;
    end;
    doRefreshPrenoms;
  end;
  if Visible then
    if (fClefIndividuSelected>0)and not bClicOnglet then
      dxDBGrid2.SetFocus
    else
      dxDBGrid1.SetFocus;
  bClicOnglet:=false;
end;

procedure TFIndividuRepertoire.doRefreshPrenoms;
var
  nom,sql1,sql2:string;
  sexe,naissance,deces:integer;
  function ActiveDansFiltre(const agrid:TExtDBGrid; const ai_column : Integer ):boolean;
  begin
    // Matthieu ?
//    if dxDBGrid2.DataSource.Filter := .FindItemByItemLink(col)=nil then
      Result:=false
  //  else
    //  Result:=True;
  end;
  function fb_columnVisible ( const adg_Grid : TExtDBGrid ; const ai_column : Integer ) : Boolean;
  Begin
    Result := False;
    with adg_Grid do
     if ( ai_column < Columns.Count ) Then
      Result := Columns [ ai_column ].Visible;
  end;

begin
  if fCanScrollNom then
  begin
    with IBQListePreNom do
    Begin
      nom:=IBQListeNomNOM.AsString;
      if rbTous.checked then
        sexe:=0
      else if rbH.checked then
        sexe:=1
      else if rbF.checked then
        sexe:=2;
      {$IFDEF FNPC}
      naissance:=0;
      deces:=0;
      if fb_columnVisible ( dxDBGrid2, CST_CP ) or ActiveDansFiltre ( dxDBGrid2, CST_CP )
        or fb_columnVisible ( dxDBGrid2, CST_Ne ) or ActiveDansFiltre ( dxDBGrid2, CST_Ne )
        or fb_columnVisible ( dxDBGrid2, CST_SubNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_SubNaissance )
        or fb_columnVisible ( dxDBGrid2, CST_DeptNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_DeptNaissance )
        or fb_columnVisible ( dxDBGrid2, CST_RegionNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_RegionNaissance )
        or fb_columnVisible ( dxDBGrid2, CST_PaysNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_PaysNaissance )
        then naissance:=1;
      if  fb_columnVisible ( dxDBGrid2, CST_CPDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_CPDeces )
       or fb_columnVisible ( dxDBGrid2, CST_VilleDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_VilleDeces )
       or fb_columnVisible ( dxDBGrid2, CST_SubDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_SubDeces )
       or fb_columnVisible ( dxDBGrid2, CST_DeptDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_DeptDeces )
       or fb_columnVisible ( dxDBGrid2, CST_RegionDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_RegionDeces )
       or fb_columnVisible ( dxDBGrid2, CST_PaysDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_PaysDeces )
        then deces:=1;
       if Active and ( sexe = ParamByName('sexe').AsInteger)
         and ( naissance = ParamByName('naissance').AsInteger)
         and ( deces = ParamByName('deces').AsInteger)
         and ( nom = ParamByName('nom').AsString)
         and ( dm.NumDossier = ParamByName('DOSSIER').AsInteger) Then
        Exit;
      {$ENDIF}
      fCanScrollPrenom:=false;
      DisableControls;
      try
        Close;
        {$IFDEF FPC}
        SQL.Clear;
        SQL.BeginUpdate;

        sql2:='';
        sql1:='select i.prenom'
          +',i.nom'
          +',i.sexe'
          +',i.cle_fiche'
          +',i.num_sosa'
          +',bin_and(i.ind_confidentiel,'+_s_IndiConf+') as ind_confidentiel'
          +',i.cle_pere as pere_cle_fiche'
          +',i.cle_mere as mere_cle_fiche'
          +',i.date_naissance'//toujours nécessaire figure en sortie
          +',i.date_deces'+_CRLF;//toujours nécessaire figure en sortie

        if fb_columnVisible ( dxDBGrid2, CST_Surnom ) or ActiveDansFiltre ( dxDBGrid2, CST_Surnom ) then
          sql1:=sql1+',i.surnom'
        else
          sql1:=sql1+',cast(null as varchar(120)) as SURNOM';

        if fb_columnVisible ( dxDBGrid2, CST_AnneeNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_AnneeNaissance ) then
          sql1:=sql1+',i.annee_naissance'
        else
          sql1:=sql1+',cast(null as integer) as annee_naissance';

        if fb_columnVisible ( dxDBGrid2, CST_Deces ) or ActiveDansFiltre ( dxDBGrid2, CST_Deces ) then
          sql1:=sql1+',i.annee_deces'
        else
          sql1:=sql1+',cast(null as integer) as ANNEE_DECES'+_CRLF;

        if fb_columnVisible ( dxDBGrid2, CST_CP ) or ActiveDansFiltre ( dxDBGrid2, CST_CP )
          or fb_columnVisible ( dxDBGrid2, CST_Ne ) or ActiveDansFiltre ( dxDBGrid2, CST_Ne )
          or fb_columnVisible ( dxDBGrid2, CST_SubNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_SubNaissance )
          or fb_columnVisible ( dxDBGrid2, CST_DeptNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_DeptNaissance )
          or fb_columnVisible ( dxDBGrid2, CST_RegionNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_RegionNaissance )
          or fb_columnVisible ( dxDBGrid2, CST_PaysNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_PaysNaissance ) then
        begin
          sql2:='left join evenements_ind n on n.ev_ind_type=''BIRT'''
            +' and n.ev_ind_kle_fiche=i.cle_fiche';

          if fb_columnVisible ( dxDBGrid2, CST_CP ) or ActiveDansFiltre ( dxDBGrid2, CST_CP ) then
            sql1:=sql1+',n.ev_ind_cp as CP'
          else
            sql1:=sql1+',cast(null as varchar(10)) as CP';

          if fb_columnVisible ( dxDBGrid2, CST_VilleNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_VilleNaissance ) then
            sql1:=sql1+',n.ev_ind_ville as ville'
          else
            sql1:=sql1+',cast(null as varchar(50)) as ville';

          if fb_columnVisible ( dxDBGrid2, CST_SubNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_SubNaissance ) then
            sql1:=sql1+',n.ev_ind_subd as subd_naissance'
          else
            sql1:=sql1+',cast(null as varchar(50)) as subd_naissance';

          if fb_columnVisible ( dxDBGrid2, CST_DeptNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_DeptNaissance ) then
            sql1:=sql1+',n.ev_ind_dept as dept_naissance'
          else
            sql1:=sql1+',cast(null as varchar(30)) as dept_naissance';

          if fb_columnVisible ( dxDBGrid2, CST_RegionNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_RegionNaissance ) then
            sql1:=sql1+',n.ev_ind_region as region_naissance'
          else
            sql1:=sql1+',cast(null as varchar(50)) as region_naissance';

          if fb_columnVisible ( dxDBGrid2, CST_PaysNaissance ) or ActiveDansFiltre ( dxDBGrid2, CST_PaysNaissance ) then
            sql1:=sql1+',n.ev_ind_pays as pays_naissance'
          else
            sql1:=sql1+',cast(null as varchar(30)) as pays_naissance'+_CRLF;
        end
        else
        begin
          sql1:=sql1+',cast(null as varchar(10)) as CP'
            +',cast(null as varchar(50)) as ville'
            +',cast(null as varchar(50)) as subd_naissance'
            +',cast(null as varchar(30)) as dept_naissance'
            +',cast(null as varchar(50)) as region_naissance'
            +',cast(null as varchar(30)) as pays_naissance'+_CRLF;
        end;

        if fb_columnVisible ( dxDBGrid2, CST_CPDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_CPDeces )
          or fb_columnVisible ( dxDBGrid2, CST_VilleDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_VilleDeces )
          or fb_columnVisible ( dxDBGrid2, CST_SubDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_SubDeces )
          or fb_columnVisible ( dxDBGrid2, CST_DeptDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_DeptDeces )
          or fb_columnVisible ( dxDBGrid2, CST_RegionDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_RegionDeces )
          or fb_columnVisible ( dxDBGrid2, CST_PaysDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_PaysDeces ) then
        begin
          sql2:=sql2+' left join evenements_ind d on d.ev_ind_type=''DEAT'''
            +' and d.ev_ind_kle_fiche=i.cle_fiche';

          if fb_columnVisible ( dxDBGrid2, CST_CPDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_CPDeces ) then
            sql1:=sql1+',d.ev_ind_cp as cp_deces'
          else
            sql1:=sql1+',cast(null as varchar(10)) as cp_deces';

          if fb_columnVisible ( dxDBGrid2, CST_VilleDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_VilleDeces ) then
            sql1:=sql1+',d.ev_ind_ville as ville_deces'
          else
            sql1:=sql1+',cast(null as varchar(50)) as ville_deces';

          if fb_columnVisible ( dxDBGrid2, CST_SubDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_SubDeces ) then
            sql1:=sql1+',d.ev_ind_subd as subd_deces'
          else
            sql1:=sql1+',cast(null as varchar(50)) as subd_deces';

          if fb_columnVisible ( dxDBGrid2, CST_DeptDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_DeptDeces ) then
            sql1:=sql1+',d.ev_ind_dept as dept_deces'
          else
            sql1:=sql1+',cast(null as varchar(30)) as dept_deces';

          if fb_columnVisible ( dxDBGrid2, CST_RegionDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_RegionDeces ) then
            sql1:=sql1+',d.ev_ind_region as region_deces'
          else
            sql1:=sql1+',cast(null as varchar(50)) as region_deces';

          if fb_columnVisible ( dxDBGrid2, CST_PaysDeces ) or ActiveDansFiltre ( dxDBGrid2, CST_PaysDeces ) then
            sql1:=sql1+',d.ev_ind_pays as pays_deces'
          else
            sql1:=sql1+',cast(null as varchar(30)) as pays_deces'+_CRLF;
        end
        else
        begin
          sql1:=sql1+',cast(null as varchar(10)) as cp_deces'
            +',cast(null as varchar(50)) as ville_deces'
            +',cast(null as varchar(50)) as subd_deces'
            +',cast(null as varchar(30)) as dept_deces'
            +',cast(null as varchar(50)) as region_deces'
            +',cast(null as varchar(30)) as pays_deces'+_CRLF;
        end;

        SQL.ADD('select distinct * from ('+sql1);
        SQL.ADD('from individu i');
        SQL.ADD(sql2);
        SQL.Add('where i.kle_dossier=:DOSSIER'
          +' and i.nom=:NOM'
          +' and (0=:sexe or i.sexe=:sexe)');

        if gci_context.IndexFavecPat then
        begin
          SQL.ADD('union '+sql1);
          SQL.ADD('from nom_attachement p'
            +' inner join individu i on i.cle_fiche=p.id_indi');
          SQL.ADD(sql2);
          SQL.Add('where p.kle_dossier=:DOSSIER'
            +' and p.nom=:NOM'
            +' and (0=:sexe or i.sexe=:sexe)'+_CRLF);

          SQL.ADD('union '+sql1);
          SQL.ADD('from nom_attachement f'
            +' inner join individu i on i.nom=f.nom_indi and i.kle_dossier=f.kle_dossier');
          SQL.ADD(sql2);
          SQL.Add('where f.kle_dossier=:DOSSIER'
            +' and f.nom=:NOM'
            +' and (0=:sexe or i.sexe=:sexe)'+_CRLF);
      //    ParamByName('NOMP').AsString:=IBQListeNomNOM.AsString;
        end;

        SQL.Add(') order by prenom,annee_naissance');
        SQL.EndUpdate;
        //sql.SaveToFile(ExtractFileDir(Application.ExeName)+DirectorySeparator);
        {$ELSE}
        ParamByName('naissance').AsInteger:=naissance;
        ParamByName('deces'    ).AsInteger:=deces;
        {$ENDIF}
        ParamByName('dossier').AsInteger:=dm.NumDossier;
        ParamByName('NOM').AsString:=nom;
        ParamByName('sexe').AsInteger:=sexe;

        Open;

        dxDBGrid2.Columns [ CST_Prenom ].Title.Caption:=IBQListeNomNOM.AsString;
      finally
        EnableControls;
      end;
    //  with FieldDefs do
    //  for sexe := 0 to Count -1  do
     //   ShowMessage(FieldDefs.Items[sexe].Name);
      if (fClefIndividuSelected>0)
      and not IsEmpty then
        //pour tenir compte des filtres appliqués à la grille, pouvait sélectionner un individu non visible
        Locate('CLE_FICHE',fClefIndividuSelected,[]);
      fCanScrollPrenom:=true;
    end;
    doFillBottomInfos;
    DoRefreshControls;
  end;
end;

procedure TFIndividuRepertoire.ExporterenHTML1Click(Sender:TObject);
var
  b:boolean;
  SavePlace:TBookmark;
begin
  SavePlace:=nil;

  if SaveDialog.Execute then
  begin
    b:=fCanScrollPrenom;
    fCanScrollPrenom:=false;
    with IBQListePreNom do
    try
      DisableControls;
      try
        SavePlace:=GetBookmark;
        ExportGridToHTML(SaveDialog.FileName,dxDBGrid2,True,True);
      finally
        GotoBookmark(SavePlace);
        FreeBookmark(SavePlace);
        EnableControls;
      end;
    finally
      fCanScrollPrenom:=b;
    end;
  end;
end;

procedure TFIndividuRepertoire.pmGridPopup(Sender:TObject);
begin
  if (IBQListePreNom.active)and(IBQListePreNom.IsEmpty=false) then
  begin
    ExporterenHTML1.enabled:=true;
    mOuvrir.enabled:=true;
    mConsulterlafiche.Enabled:=true;
    mOuvrirArbre.Enabled:=true;
    mEnvFam.enabled:=true;
    if IBQListeNomNOM.AsString=IBQListePreNomNOM.AsString then
      NomIndiSelectionne.Visible:=false
    else
    begin
      NomIndiSelectionne.Caption:='Nom individu: '+IBQListePreNomNOM.AsString;
      NomIndiSelectionne.Visible:=true
    end;
  end
  else
  begin
    ExporterenHTML1.enabled:=false;
    mOuvrir.enabled:=false;
    mConsulterlafiche.Enabled:=false;
    mOuvrirArbre.Enabled:=false;
    mEnvFam.enabled:=false;
    NomIndiSelectionne.Visible:=false;
  end;
end;

procedure TFIndividuRepertoire.dxDBGrid2GetBtnParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor;
  var SortMarker: TSortMarker; IsDown: Boolean);
var
  value:Variant;
begin
  Value:=IBQListePreNomNOM.Value;
  // on met en Fuschia le fond de ceux dont le nom est différent (mis dans la grille par les patronymes)
  with dxDBGrid2 do
   Begin
    if not VarIsNull(Value) then
      if (Value<>IBQListeNomNOM.AsString) then
        Background:=$00C0C0FF;

    Value:=IBQListePreNomNUM_SOSA.Value;
    //on met en vert tous ceux qui ont un num sosa
    if not VarIsNull(Value) then
    begin
      if (Value>0) then
      begin
        AFont.Style:= [fsBold];
        AFont.Color:=_COLOR_SOSA;
      end;
    end;
    if (IBQListePrenomIND_CONFIDENTIEL.AsInteger=1) then
      AFont.Style:=AFont.Style+ [fsStrikeOut]
    else
      AFont.Style:=AFont.Style- [fsStrikeOut];
    if Field = SelectedColumn.Field then
      if Background=Color then
        Background:=gci_context.ColorMedium;
   end;
end;

procedure TFIndividuRepertoire.IBQListeNomAfterScroll(DataSet: TDataSet);
begin
  doRefreshPrenoms;
end;

procedure TFIndividuRepertoire.IBQListePreNomAfterScroll(DataSet: TDataSet);
begin
  doFillBottomInfos;
end;

procedure TFIndividuRepertoire.SuperFormCreate(Sender:TObject);
var
  DeltaH:integer;
begin
  OnRefreshControls := SuperFormRefreshControls;
  TVasc .NodeDataSize := Sizeof(TIndivTree)+1;
  TVdesc.NodeDataSize := Sizeof(TIndivTree)+1;
  Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  SaveDialog.InitialDir:=gci_context.PathImportExport;

  fClefIndividuSelected:=-1;
  fNomPrenomIndividuSelected:='';
  fSexeIndividuSelected:=-1;
  fDecesIndividuSelected:='';
  fNaissanceIndividuSelected:='';

  ListeFiches:=TObjectList.Create;
  IndexListeFiches:=-1;
  bSelectDepuisListe:=False;

  mReajustementdescolonnes.Checked:=gci_context.IndexFcolAuto;
  if mReajustementdescolonnes.Checked then
    dxDBGrid2.AutoSizeColumns;


  mAvecPat.Checked:=gci_context.IndexFavecPat;
{  DeltaH:=gci_context.IndexFHauteur-Height+Panel9.Height-gci_context.IndexFHautInfos;
  Height:=gci_context.IndexFHauteur;
  Width:=gci_context.IndexFLargeur;
  dxDBGrid1.Width:=gci_context.IndexFLargGrid;
  Panel9.Height:=gci_context.IndexFHautInfos;
  TvAsc.Width:=gci_context.IndexFPosSplit;
  dxDBGrid1.Height:=dxDBGrid1.Height+DeltaH;//permet des locates restant visibles dans les grilles
  dxDBGrid2.Height:=dxDBGrid2.Height+DeltaH;}
  InitOngletsActifs;

  bFin:=true;
  bInitFenetre:=false;
  bsfbSelection.Hint:=rs_Hint_Generic_action_Maj_with_select_open_a_consult_form;
  fCreation:=false;
  bClicOnglet:=false;
  bDejaPasse:=False;
end;

procedure TFIndividuRepertoire.rbTousChange(Sender:TObject);
begin
  doRefreshPrenoms;
end;

procedure TFIndividuRepertoire.SpeedButton2Click(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFIndividuRepertoire.bsfbSelectionClick(Sender:TObject);
begin
  doSelect;
end;

procedure TFIndividuRepertoire.doSelect;
var
  i:integer;
begin
  IBQListePrenom.DisableControls;
  try
      if bSelect then
      begin
        if dxDBGrid2.SelectedRows.Count=0 then
        begin
          SetLength(L,1);
          L[0]:=IBQListePreNomCLE_FICHE.AsInteger;
        end
        else
        begin
          SetLength(L,dxDBGrid2.SelectedRows.Count);
          for i:=0 to Length(L)-1 do
           Begin
            IBQListePrenom.GotoBookMark(dxDBGrid2.SelectedRows[i]);
            L[i]:=IBQListePrenomCle_Fiche.AsInteger;
           end;
        end;
      end;
      fClefIndividuSelected:=IBQListePreNomCLE_FICHE.AsInteger;
      fNomPrenomIndividuSelected:=AssembleString([IBQListePreNomNOM.AsString,
        IBQListePreNomPRENOM.AsString]);
      fNom:='';//AL
      fSexeIndividuSelected:=IBQListePreNomSEXE.AsInteger;
      fNaissanceIndividuSelected:=IBQListePreNomDATE_NAISSANCE.AsString;
      fDecesIndividuSelected:=IBQListePreNomDATE_DECES.AsString;

      if fsModal in Self.FormState then
       Begin
         gci_context.ShouldSave:=true;
         ModalResult:=mrOk;
       end
      else
      begin
        DefaultCloseAction:=caNone;
        dm.individu_clef:=IBQListePreNomCLE_FICHE.AsInteger;
        DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
      end;

  finally
    IBQListePrenom.EnableControls;
  end;
end;

procedure TFIndividuRepertoire.doFillBottomInfos; //ajoute aussi à la liste des individus consultés
var
  j:Integer;
  AParent,Anode:PVirtualNode;
  s,lettre:string;
begin
  if fCanScrollPrenom then
  begin
    TVdesc.Clear;
    TVasc.Clear;
    BarEtat.Panels[0].Text:='';
    if IBQListePreNom.IsEmpty Then
     Exit;
    if IBQListePreNomCLE_FICHE.IsNull then
    begin
      //le supprimer de la liste des individus consultés
      SuppFicheDansListe(fClefIndividuSelected);
      Exit;
    end;
    if IBQListePreNom.IsEmpty then
      exit;

    s:=AssembleString([IBQListePreNomNOM.AsString,IBQListePreNomPRENOM.AsString])
      +GetStringNaissanceDeces(IBQListePreNomANNEE_NAISSANCE.AsString,IBQListePreNomANNEE_DECES.AsString);
    if cxTabOnglet.TabIndex>0 then
      lettre:=_AlphabetMaj[cxTabOnglet.TabIndex]
    else
      lettre:='?';
    if bSelectDepuisListe then
    begin
      //mettre éventuellement à jour la liste des individus consultés
      ModifFicheDansListe(IBQListePreNomCLE_FICHE.AsInteger,IBQListePreNomSEXE.AsInteger
          ,s,lettre,IBQListeNomNOM.AsString);
    end
    else
    begin //ajout à la liste des individus consultés
      AddFicheDansListe(IBQListePreNomCLE_FICHE.AsInteger,IBQListePreNomSEXE.AsInteger
        ,s,lettre,IBQListeNomNOM.AsString);
    end;
    btnPrecedent.Enabled:=IndexListeFiches>0;
    btnSuivant.Enabled:=(IndexListeFiches>=0) and (IndexListeFiches<(ListeFiches.Count-1));

    BarEtat.Panels[0].Text:=dm.ChaineHintIndi(IBQListePreNomCLE_FICHE.AsInteger,' - ');
    Anode := TreeAjouterEnfant(TVdesc,nil);
    with TVdesc,PIndivTree ( GetNodeData(Anode))^ do
     Begin
      cle:=IBQListePreNomCLE_FICHE.AsInteger;
      s:=fs_RemplaceMsg(rs_Joint_s_Child_ren_of,[IBQListePreNomNOM.AsString]);
      if length(IBQListePreNomPRENOM.AsString)>0 then
        Nom:=s+' '+IBQListePreNomPRENOM.AsString
      else
        Nom:=s;
      sexe:=-4;
      if IBQListePreNomNUM_SOSA.AsFloat>0 then
        sosa:=1
      else
        sosa:=0;
     end;

    qDesc.close;
    qDesc.ParamByName('cle_fiche').AsInteger:=IBQListePreNomCLE_FICHE.AsInteger;
    qDesc.ExecQuery;
    j:=-10;
    AParent:=nil;
    while not qDesc.Eof do //on remplit TVdesc
    with qDesc, TVdesc do
    begin
      if (FieldByName('CLE_CONJOINT').AsInteger<>j) then //on ajoute un conjoint
      begin
        j:=FieldByName('CLE_CONJOINT').AsInteger;
        AParent := TreeAjouterEnfant(TVdesc,nil);
        with TVdesc,PIndivTree ( GetNodeData(AParent))^ do
         Begin
          if j=0 then
            cle:=IBQListePreNomCLE_FICHE.AsInteger
          else
            cle:=j;
          sexe:=FieldByName('SEXE_CONJOINT').AsInteger;
          if sexe=0 then
            sexe:=IBQListePreNomSEXE.AsInteger-3;
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
          DateMarr:=FieldByName('date_marr').AsString;
          Prenom:=FieldByName('PRENOM_CONJOINT').AsString;
          DateNaiss:=FieldByName('DATE_NAISSANCE_CONJOINT').AsString;
          DateDeces:=FieldByName('DATE_DECES_CONJOINT').AsString;
          sosa:=FieldByName('SOSA_CONJOINT').AsInteger;
          lettre:=FieldByName('LETTRE_CONJOINT').AsString;
         End;
        end;
        if FieldByName('CLE_FICHE').AsInteger>0 then
        begin
          Anode := TreeAjouterEnfant(TVdesc,AParent);
          with TVdesc,PIndivTree ( GetNodeData(Anode))^ do
           Begin
            cle:=FieldByName('CLE_FICHE').AsInteger;
            Nom:=FieldByName('NOM').AsString;
            DateMarr:='';
            Prenom:=FieldByName('PRENOM').AsString;
            sexe:=FieldByName('SEXE').AsInteger;
            sosa:=FieldByName('SOSA').AsInteger;
            DateNaiss:=FieldByName('DATE_NAISSANCE').AsString;
            DateDeces:=FieldByName('DATE_DECES').AsString;
            lettre:=FieldByName('LETTRE').AsString;
           End;
        end;
      Next;
    end;
    qDesc.close;
    TVdesc.FullExpand;
    TVdesc.VisiblePath[TVdesc.RootNode^.FirstChild]:=True;

    Anode := TreeAjouterEnfant(TVasc,nil);
    AParent:=Anode;

    with TVasc, PIndivTree ( GetNodeData(Anode))^, IBQListePreNom do
     Begin
      cle:=FieldByName('CLE_FICHE').AsInteger;
      s:=fs_RemplaceMsg(rs_Parents_of,[FieldByName('NOM').AsString]);
      if length(FieldByName('PRENOM').AsString)>0 then
        s:=s+' '+FieldByName('PRENOM').AsString;
      Nom:=s+' (NIP '+FieldByName('CLE_FICHE').AsString+')';
      sexe:=-3;
      if FieldByName('NUM_SOSA').AsFloat>0 then
        sosa:=1
      else
        sosa:=0;
     end;
    qAsc.close;
    qAsc.ParamByName('cle_fiche').AsInteger:=IBQListePreNomCLE_FICHE.AsInteger;
    qAsc.ExecQuery;
    while not qAsc.Eof do //on remplit TVasc
    with qAsc, TVasc do
    begin
     if (FieldByName('ordre').AsInteger=1)or(FieldByName('ordre').AsInteger=4) then
       Begin
         AParent:=TreeAjouterEnfant(TVasc,nil);
         Anode:=AParent;
       end
     else
       Anode:=TreeAjouterEnfant(TVasc,AParent);
     with PIndivTree ( GetNodeData(Anode))^ do
       Begin
        DateMarr:='';
        cle:=FieldByName('CLE_FICHE').AsInteger;
        Nom:=FieldByName('NOM').AsString;
        Prenom:=FieldByName('PRENOM').AsString;
        sexe:=FieldByName('SEXE').AsInteger;
        sosa:=FieldByName('SOSA').AsInteger;
        DateNaiss:=FieldByName('DATE_NAISSANCE').AsString;
        DateDeces:=FieldByName('DATE_DECES').AsString;
        lettre:=FieldByName('LETTRE').AsString;
       end;
      Next;
    end;
    qAsc.Close;
    TVasc.FullExpand;
    TVasc.VisiblePath[TVasc.RootNode^.FirstChild]:=True;
  end;
end;

procedure TFIndividuRepertoire.bfsbCreationClick(Sender:TObject);
var
  aFIndividuSaisieRapide:TFIndividuSaisieRapide;
begin
  aFIndividuSaisieRapide:=TFIndividuSaisieRapide.create(self);
  try
    aFIndividuSaisieRapide.Sexe:=fSexe;
    if not IBQListeNom.IsEmpty and(IBQListeNomNOM.AsString>'')
     then aFIndividuSaisieRapide.sDBENom.Text:=IBQListeNomNOM.AsString
     else aFIndividuSaisieRapide.sDBENom.Text:='';

    if self.Caption=rs_caption_Select_Child then
    begin
      aFIndividuSaisieRapide.Caption:=rs_caption_Create_child;
      aFIndividuSaisieRapide.cxSexe.Enabled:=True;
    end
    else if self.Caption=rs_caption_Select_Joint then
    begin
      aFIndividuSaisieRapide.Caption:=rs_caption_Create_Joint;
      aFIndividuSaisieRapide.cxSexe.Enabled:=False;
    end
    else if self.Caption=rs_caption_Select_Father then
    begin
      aFIndividuSaisieRapide.Caption:=rs_caption_Create_Father;
      aFIndividuSaisieRapide.cxSexe.Enabled:=False;
    end
    else if self.Caption=rs_caption_Select_Mother then
    begin
      aFIndividuSaisieRapide.Caption:=rs_caption_Create_Mother;
      aFIndividuSaisieRapide.cxSexe.Enabled:=False;
    end
    else if self.Caption=rs_caption_Select_Person then
    begin
      aFIndividuSaisieRapide.Caption:=rs_caption_Create_Person;
      aFIndividuSaisieRapide.cxSexe.Enabled:=true;
    end
    else if self.Caption=rs_caption_Select_Witness then
    begin
      aFIndividuSaisieRapide.Caption:=rs_caption_Create_Witness;
      aFIndividuSaisieRapide.cxSexe.Enabled:=true;
    end
    else
      aFIndividuSaisieRapide.cxSexe.Enabled:=True;

    aFIndividuSaisieRapide.Position:=poDesigned;
    aFIndividuSaisieRapide.Left:=self.Left+(self.Width-aFIndividuSaisieRapide.Width)div 2;
    aFIndividuSaisieRapide.Top:=self.Top+(self.Height-aFIndividuSaisieRapide.Height)div 2;

    aFIndividuSaisieRapide.ShowModal;
    if aFIndividuSaisieRapide.NomFiche>'' then
    begin
      fClefIndividuSelected:=aFIndividuSaisieRapide.CleFiche;
      fNomPrenomIndividuSelected:=aFIndividuSaisieRapide.NomPrenomFiche;
      fNom:=aFIndividuSaisieRapide.NomFiche;//AL
      fSexeIndividuSelected:=aFIndividuSaisieRapide.Sexe;

      fNaissanceIndividuSelected:=aFIndividuSaisieRapide.DateNaiss;
      if Length(fNaissanceIndividuSelected)>0 then
      begin
        if fSexeIndividuSelected=2
         then fNaissanceIndividuSelected:=fs_RemplaceMsg(rs_Born_on_female,[fNaissanceIndividuSelected])
         else fNaissanceIndividuSelected:=fs_RemplaceMsg(rs_Born_on_male  ,[fNaissanceIndividuSelected]);
      end;

      fDecesIndividuSelected:=aFIndividuSaisieRapide.DateDeces;
      if Length(fDecesIndividuSelected)>0 then
      begin
        if fSexeIndividuSelected=2 then
          fDecesIndividuSelected:='décédée le : '+fDecesIndividuSelected
        else
          fDecesIndividuSelected:='décédé le : '+fDecesIndividuSelected;
      end;

      fCreation:=True;
      ModalResult:=mrOk;
    end
    else
      Self.WindowState:=wsNormal;
  finally
    FreeAndNil(aFIndividuSaisieRapide);
  end;
end;

procedure TFIndividuRepertoire.SuperFormKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:ModalResult:=mrCancel;
    _KEY_HELP:p_ShowHelp(_ID_RECHERCHER);
  end;
end;

procedure TFIndividuRepertoire.SuperFormRefreshControls(Sender:TObject);
begin
  bsfbSelection.enabled:=(IBQListeNom.Active)and(IBQListeNom.IsEmpty=false);
  case IBQListePrenom.RecordCount of
    0:lbParPrenom.Caption:=rs_Caption_Noone_with_this_surname_in_selection;
    1:lbParPrenom.Caption:=rs_Caption_One_person_with_this_surname_in_selection;
    else
      lbParPrenom.Caption:=fs_RemplaceMsg(rs_Caption_persons_with_this_surname_in_selection,[Inttostr(IBQListePrenom.RecordCount)]);
  end;
end;

procedure TFIndividuRepertoire.cxTabOngletChange(Sender:TObject);
begin
  if bFin then
  begin
    fNumOngletSelected:=cxTabOnglet.TabIndex;
    doRefreshRepertoire;
  end;
end;

procedure TFIndividuRepertoire.InitOngletsActifs;
var
  i:integer;
  req:TIBSQL;
  actif:boolean;
begin
  req:=TIBSQL.Create(self);
  req.Database:=dm.ibd_BASE;
  req.Transaction:=dm.IBT_BASE;
  req.ParamCheck:=false;
  req.GoToFirstRecordOnExecute:=true;
  req.SQL.Text:='execute block returns (lettre char(1))as'
    +' declare variable i integer;'
    +' declare variable dossier integer;'
    +'begin dossier='+IntToStr(dm.NumDossier)+';'
    +'lettre=''0'';'
    +'select ''1'' from rdb$database'
    +' where exists (select 1 from individu where kle_dossier=:dossier'
    +'     and (indi_trie_nom<''A'' or indi_trie_nom>lpad(''Z'',110,''Z'')))'
    +'   or exists (select 1 from nom_attachement where kle_dossier=:dossier'
    +'     and (nom_lettre<''A'' or nom_lettre>''Z''))'
    +' into :lettre;'
    +'suspend;'
    +'lettre=''A'';'
    +'i=ascii_val(''A'');'
    +'while (lettre<=''Z'') do'
    +' begin'
    +' if (exists (select 1 from individu where kle_dossier=:dossier and indi_trie_nom starting with :lettre)) then'
    +' suspend;'
    +' else if (exists (select 1 from nom_attachement where kle_dossier=:dossier and nom_lettre=:lettre)) then'
    +' suspend;'
    +'i=i+1;'
    +'lettre=ascii_char(i);'
    +'end end';
  try
    req.ExecQuery;
    for i:=0 to 26 do
    begin
      if i=0 then
        actif:=req.Fields[0].AsString='1'
      else
        actif:=req.Fields[0].AsString=_AlphabetMaj[i];
//      cxTabOnglet.Tabs[i].Enabled:=actif;
      if (actif or (i=0))and not req.Eof then
        req.Next;
    end;
    req.Close;
  finally
    req.Free;
  end;
end;

procedure TFIndividuRepertoire.SuperFormDestroy(Sender:TObject);
begin
  IBQListePreNom.Close;
  ListeFiches.Free;
end;

procedure TFIndividuRepertoire.SupprimerlestrisClick(Sender:TObject);
var
  i:integer;
begin
  for i:=0 to dxDBGrid2.Columns.Count-1 do
    dxDBGrid2.Columns[i].SortOrder:=smNone;
  dxDBGrid2.Refresh;
end;

procedure TFIndividuRepertoire.TVascCustomDrawItem(Sender:TCustomTreeView;
  Node:TTreeNode;State:TCustomDrawState;var DefaultDraw:Boolean);
begin
  if (PIndivTree(Node.Data)^.sosa=1)and(Node.ImageIndex<5) then
    Sender.Canvas.Font.Color:=_COLOR_SOSA
  else
    case Node.ImageIndex of
      2,4:Sender.Canvas.Font.Color:=gci_context.ColorFemme;
      1,3:Sender.Canvas.Font.Color:=gci_context.ColorHomme;
      else
        Sender.Canvas.Font.Color:=clWindowText;
    end;

  if Node.AbsoluteIndex=0 then
    Sender.Canvas.Font.Style:= [fsBold];
  if Node.Selected then
    Sender.Canvas.Brush.Color:=gci_context.ColorMedium;
end;

procedure TFIndividuRepertoire.TVascGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var monIndiv : PIndivTree;
begin
  monIndiv := Sender.GetNodeData(Node);

  case monIndiv^.sexe of
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

procedure TFIndividuRepertoire.TVascGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var monIndiv : PIndivTree;
begin
  monIndiv := Sender.GetNodeData(Node);
  with monIndiv^ do
    Begin
      CellText:=DateMarr+nom;
      if length(prenom)>0 then
        CellText:=CellText+' '+prenom;
      CellText:=CellText+GetStringNaissanceDeces(trim(DateNaiss),trim(DateDeces));
    end;

end;



procedure TFIndividuRepertoire.dxDBGrid1DBTableView1FocusedRecordChanged(
  Sender:TObject;APrevFocusedRecord,
  AFocusedRecord:Longint;ANewItemRecordFocusingChanged:Boolean);
begin
  if fCanScrollPrenom then
    doRefreshPrenoms;
end;

procedure TFIndividuRepertoire.btnFermerClick(Sender:TObject);
begin
  Close;
end;

procedure TFIndividuRepertoire.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  fCanScrollNom:=False;
  fCanScrollPrenom:=False;

//  TVdesc.Items.Clear;
//  TVasc.Items.Clear;
  IBQListeNom.Close;
{  if fsModal in FormState then
    dxDBGrid2DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_INDEX_NOMS_E',true, [gsoUseFilter],'GrillePrenoms')
  else
  begin
    dxDBGrid2DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_INDEX_NOMS_F',true, [gsoUseFilter],'GrillePrenoms');}
    DoSendMessage(Owner,'FERME_form_individu_repertoire_R');
//  end;
end;

procedure TFIndividuRepertoire.mReajustementdescolonnesClick(Sender:TObject);
begin
  mReajustementdescolonnes.Checked:=not mReajustementdescolonnes.Checked;
  // Matthieu ?
  if mReajustementdescolonnes.Checked then
    dxDBGrid2.AutoSizeColumns;
//  else
//    dxDBGrid2DBTableView1.OptionsView.ColumnAutoWidth:=False;
  gci_context.IndexFcolAuto:=mReajustementdescolonnes.Checked;
end;

procedure TFIndividuRepertoire.mAvecpatClick(Sender:TObject);
begin
  mAvecPat.Checked:=not mAvecPat.Checked;
  gci_context.IndexFavecPat:=mAvecPat.Checked;
end;

procedure TFIndividuRepertoire.mParenteClick(Sender:TObject);
var
  s:string;
begin
  s:='['+IntToStr(IBQListePreNomCLE_FICHE.AsInteger)+'] '
    +AssembleString([IBQListePreNomNOM.AsString,IBQListePreNomPRENOM.AsString])
    +GetStringNaissanceDeces(IBQListePreNomANNEE_NAISSANCE.AsString,IBQListePreNomANNEE_DECES.AsString);
  FMain.OuvreLienGene(IBQListePreNomCLE_FICHE.AsInteger,dm.individu_clef,
    s,'['+IntToStr(dm.individu_clef)+'] '+FMain.NomIndiComplet);
end;

procedure TFIndividuRepertoire.mConsulterlaficheClick(Sender:TObject);
begin
  OpenFicheIndividuInBox(IBQListePreNomCLE_FICHE.AsInteger);
end;

procedure TFIndividuRepertoire.cxTabOngletDrawTabEx(
  AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  if ATab = ATab.PageControl.ActivePage then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
end;

procedure TFIndividuRepertoire.dxDBGrid2DBTableView1CellDblClick(
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

procedure TFIndividuRepertoire.SuperFormShow(Sender:TObject);
begin
  if Application.ModalLevel > 0
  Then DefaultCloseAction:=caHide
  Else DefaultCloseAction:=caFree;
  if fClefIndividuSelected>0
   then dxDBGrid2.SetFocus
   else dxDBGrid1.SetFocus;
  if fsModal in FormState
   Then btnFermer.Caption:=rsMbCancel;
end;

procedure TFIndividuRepertoire.mLiensClick(Sender:TObject);
begin
  FMain.OuvreLienIndividus(dm.individu_clef,IBQListePreNomCLE_FICHE.AsInteger);
end;

procedure TFIndividuRepertoire.TVascClick(Sender:TObject);
var
//  p:TPoint;
  lettre:string;
  Tree:TVirtualStringTree;
begin
  Tree:=(sender as TVirtualStringTree);
  if Tree.FocusedNode<>nil then
  begin
    // Matthieu ?
{    p:=Tree.MouseDownPos;
    if p.X>20 then
    begin         }
{    if PIndivTree(Tree.FocusedNode.Data)^.cle<>IBQListePreNomCLE_FICHE.AsInteger then
      begin
        fNom:=PIndivTree(Tree.Selected.Data)^.Nom;
        lettre:=PIndivTree(Tree.Selected.Data)^.lettre;
        fClefIndividuSelected:=PIndivTree(Tree.Selected.Data)^.cle;
        InitIndividuPrenom(lettre,'INDEX',0,fClefIndividuSelected,bSelect,bModal);
      end;}
 //   end;
  end;
end;

procedure TFIndividuRepertoire.TVascMouseDown(Sender:TObject;
  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
var
  Noeud:PVirtualNode;
  Tree:TVirtualStringTree;
begin
{  Matthieu : Inutile
Tree:=(sender as TVirtualStringTree);
  Noeud:=Tree.GetNodeAt(X,Y);
  if Noeud<>nil then
  begin
    Tree.FocusedNode := Noeud;
  end;    }
end;

procedure TFIndividuRepertoire.TVascMouseMove(Sender:TObject;
  Shift:TShiftState;X,Y:Integer);
var
  Noeud:PVirtualNode;
  Tree:TVirtualStringTree;
begin
  Tree:=(sender as TVirtualStringTree);
  Noeud:=Tree.GetNodeAt(X,Y);
  if (Noeud<>nil)and(Noeud <> Tree.RootNode) then
    if X>20 then
      Tree.Cursor:=crHandPoint
    else
      Tree.Cursor:=crDefault
  else
    Tree.Cursor:=crDefault;
end;

procedure TFIndividuRepertoire.Ascendance1Click(Sender:TObject);
begin
  FMain.OuvreArbredascendance(IBQListePreNomCLE_FICHE.AsInteger,'A');
end;

procedure TFIndividuRepertoire.Descendance1Click(Sender:TObject);
begin
  FMain.OuvreArbredascendance(IBQListePreNomCLE_FICHE.AsInteger,'D');
end;

procedure TFIndividuRepertoire.mEnvFamClick(Sender:TObject);
var
  s:string;
begin
  s:=AssembleString([IBQListePreNomNOM.AsString,IBQListePreNomPRENOM.AsString])
    +GetStringNaissanceDeces(IBQListePreNomANNEE_NAISSANCE.AsString,IBQListePreNomANNEE_DECES.AsString);
  FMain.OuvreEnvFam(IBQListePreNomCLE_FICHE.AsInteger,s);
end;

procedure TFIndividuRepertoire.dxDBGrid2MouseEnter(Sender: TObject);
begin
   // Matthieu Aucun style
//  dm.cxHintStyleController1.HintStyle.Standard:=true;
end;

procedure TFIndividuRepertoire.dxDBGrid2MouseLeave(Sender: TObject);
begin
//  dm.cxHintStyleController1.HintStyle.Standard:=false;
end;

//gestion des fiches précédentes et suivantes
constructor TFicheInfo.Create;
begin
  CleFiche:=-1;
  Sexe:=-1;
  Titre:='';
  Lettre:='';
  Nom:='';
end;

procedure TFIndividuRepertoire.AddFicheDansListe(CleFiche,Sexe:integer;Titre,Lettre,Nom:string);
var
  suite:boolean;
  aFicheInfo:TFicheInfo;
begin
    suite:=true;
    if (IndexListeFiches>=0)and(IndexListeFiches<ListeFiches.Count) then
      suite:=TFicheInfo(ListeFiches[IndexListeFiches]).CleFiche<>CleFiche;
    if suite then
    begin
      aFicheInfo:=TFicheInfo.create;
      aFicheInfo.CleFiche:=CleFiche;
      aFicheInfo.Sexe:=Sexe;
      aFicheInfo.Titre:=Titre;
      aFicheInfo.Lettre:=Lettre;
      aFicheInfo.Nom:=Nom;
      //Où insérer ?
      if (ListeFiches.Count=0)or(IndexListeFiches<0)
        or(IndexListeFiches>ListeFiches.Count-1) then // ce dernier cas ne devrait pas se produire!
      begin
        if ListeFiches.Count>20 then
          ListeFiches.Delete(0);
        IndexListeFiches:=ListeFiches.Add(aFicheInfo);
      end
      else
      begin
        SuppFicheDansListe(CleFiche);//la supprime si elle y est avant de l'ajouter à la position de l'index
        if ListeFiches.Count>20 then
        begin
          if IndexListeFiches>=10 then //soit on enlève au début
          begin
            ListeFiches.Delete(0);
            dec(IndexListeFiches);
          end
          else //soit on enlève à la fin
          begin
            ListeFiches.Delete(ListeFiches.count-1);
          end;
        end;
        inc(IndexListeFiches);
        ListeFiches.Insert(IndexListeFiches,aFicheInfo);
      end;
    end;
end;

procedure TFIndividuRepertoire.SuppFicheDansListe(CleFiche:integer);
var
  i:integer;
begin
  for i:=0 to ListeFiches.Count-1 do
  begin //supprime la fiche de la liste si elle y est déjà
   if TFicheInfo(ListeFiches[i]).CleFiche=CleFiche then
   begin
    ListeFiches.Delete(i);
    if i<=IndexListeFiches then
      dec(IndexListeFiches);
    Break;
   end;
  end;
end;

procedure TFIndividuRepertoire.ModifFicheDansListe(CleFiche,Sexe:integer;Titre,Lettre,Nom:string);
var
  i:integer;
  aFicheInfo:TFicheInfo;
begin
  for i:=0 to ListeFiches.Count-1 do
  begin //supprime la fiche de la liste si elle y est déjà
   aFicheInfo:=TFicheInfo(ListeFiches[i]);
   if aFicheInfo.CleFiche=CleFiche then
   begin
    aFicheInfo.Sexe:=Sexe;
    aFicheInfo.Titre:=Titre;
    aFicheInfo.Lettre:=Lettre;
    aFicheInfo.Nom:=Nom;
    Break;
   end;
  end;
end;

function TFIndividuRepertoire.ItemMenuListe(n:integer):TMenuItem;
var
  aFicheInfo:TFicheInfo;
begin
  aFicheInfo:=TFicheInfo(ListeFiches[n]);
  Result:=TMenuItem.create(self);
  Result.Caption:=aFicheInfo.Titre;
  case aFicheInfo.Sexe of
    1:Result.ImageIndex:=1;
    2:Result.ImageIndex:=0;
    else
      Result.ImageIndex:=2;
  end;
  Result.Tag:=n;
  Result.OnClick:=mItemListeClick;
end;

procedure TFIndividuRepertoire.popup_PrecedentPopup(Sender: TObject);
var
  n:integer;
begin
  for n:=popup_Precedent.items.count-1 downto 0 do
    popup_Precedent.items.delete(n);
  if (IndexListeFiches>=0)and(IndexListeFiches<ListeFiches.Count) then
  begin
    for n:=IndexListeFiches-1 downto 0 do
      popup_Precedent.items.add(ItemMenuListe(n));
  end;
end;

procedure TFIndividuRepertoire.popup_SuivantPopup(Sender: TObject);
var
  n:integer;
begin
  for n:=popup_Suivant.items.count-1 downto 0 do
    popup_Suivant.items.delete(n);
  if (IndexListeFiches>=0)and(IndexListeFiches<ListeFiches.Count) then
  begin
    for n:=IndexListeFiches+1 to ListeFiches.Count-1 do
      popup_Suivant.items.add(ItemMenuListe(n));
  end;
end;

procedure TFIndividuRepertoire.mItemListeClick(Sender: TObject);
begin
  SelectDepuisListe(TMenuItem(Sender).Tag);
end;

procedure TFIndividuRepertoire.SelectDepuisListe(Index:integer);
var
  lettre:string;
  aFicheInfo:TFicheInfo;
begin
  aFicheInfo:=TFicheInfo(ListeFiches[Index]);
  fNom:=aFicheInfo.Nom;
  lettre:=aFicheInfo.Lettre;
  fClefIndividuSelected:=aFicheInfo.CleFiche;
  bSelectDepuisListe:=true; //quand on sélectionne depuis les boutons on ne change pas la liste
  IndexListeFiches:=Index;  //on y circule uniquement
  InitIndividuPrenom(lettre,'INDEX',0
    ,fClefIndividuSelected,bSelect,bModal);
  bSelectDepuisListe:=false;
end;

procedure TFIndividuRepertoire.btnPrecedentClick(Sender: TObject);
var
  k:integer;
begin
  k:=IndexListeFiches-1;
  if (k>=0)and(k<ListeFiches.Count) then
    SelectDepuisListe(k);
end;

procedure TFIndividuRepertoire.btnSuivantClick(Sender: TObject);
var
  k:integer;
begin
  k:=IndexListeFiches+1;
  if (k>=0)and(k<ListeFiches.Count) then
    SelectDepuisListe(k);
end;

procedure TFIndividuRepertoire.dxDBGrid2DBTableView1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FMain.IndiDrag.cle:=IBQListePreNomCLE_FICHE.AsInteger;
  FMain.IndiDrag.sexe:=IBQListePreNomSEXE.AsInteger;
  FMain.IndiDrag.nomprenom:=AssembleString([IBQListePreNomNOM.AsString,IBQListePreNomPRENOM.AsString]);
  FMain.IndiDrag.naissance:= IBQListePreNomDATE_NAISSANCE.AsString;
  FMain.IndiDrag.deces:= IBQListePreNomDATE_DECES.AsString;
end;

procedure TFIndividuRepertoire.cxTabOngletClick(Sender: TObject);
begin
  bClicOnglet:=true;
  if Visible then
    dxDBGrid1.SetFocus;
end;

procedure TFIndividuRepertoire.dxDBGrid1DBTableView1KeyPress(Sender: TObject;
  var Key: Char);
var
  s:string;
  i:Integer;
begin //sélectionner le bon onglet lors de la frappe du premier caractère
  if dxDBGrid1.DataSource.DataSet.Modified then
  begin
    if Key in ['A'..'Z','a'..'z'] then
    begin
      s:=UTF8UpperCase(Key);
      if s<>_AlphabetMaj[cxTabOnglet.TabIndex] then
      begin
        i:=Pos(s,_AlphabetMaj);
{        if cxTabOnglet.Tabs[i].Enabled then
        begin
          cxTabOnglet.TabIndex:=i;
          dxDBGrid1.SetFocus;
        end;}
      end;
    end;
  end;
end;


end.
