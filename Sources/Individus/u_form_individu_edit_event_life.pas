{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania GPL                             }
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
unit u_form_individu_edit_event_life;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
{$IFNDEF FPC}
  jpeg, Mask, Windows,
{$ELSE}
  MaskEdit, LCLIntf, LCLType,
{$ENDIF}
  U_FormAdapt, Menus, Forms, u_comp_TYLanguage, IBUpdateSQL,
  DB, IBQuery, u_buttons_defs, StdCtrls,
  Graphics, SysUtils, U_ExtNumEdits,
  Controls, Classes, ExtCtrls, u_ancestropictimages,
  u_ancestropictbuttons, u_extdateedit,
  u_buttons_appli, u_extsearchedit,
  Dialogs, u_framework_components,
  u_framework_dbcomponents, CompSuperForm,
  variants, IBSQL, ComCtrls,
  U_ExtDBGrid, U_ExtDBImageList, types;
type

  { TFIndividuEditEventLife }

  TFIndividuEditEventLife=class(TF_FormAdapt)
    bsfbAjout: TFWAdd;
    bsfbRetirer: TFWDelete;
    btnDetail: TFWXPButton;
    btnInternet: TXAWeb;
    btnVillesFavoris: TXAFavorite;
    btnVillesVoisines: TXANeighbor;
    cxComboBoxActe: TFWDBComboBox;
    cxGridMedias: TExtDBGrid;
    cxGridTemoins: TExtDBGrid;
    DBTextAge: TLabel;
    DSCountries: TDatasource;
    DsJobs: TDatasource;
    DsCities: TDatasource;
    dxDBImageEdit1: TExtDBImageList;
    edCause: TFWDBEdit;
    edCommentaires: TFWDBMemo;
    edCP: TExtSearchDBEdit;
    edDate: TExtDBDateEdit;
    edDept: TFWDBEdit;
    edDesc: TExtSearchDBEdit;
    edHeure: TFWDBDateTimePicker;
    edInsee: TExtSearchDBEdit;
    edLatitude: TExtDBNumEdit;
    edLongitude: TExtDBNumEdit;
    edPays: TExtSearchDBEdit;
    edRegion: TFWDBEdit;
    edSources: TFWDBMemo;
    edVille: TExtSearchDBEdit;
    fbInfosVilles: TXAInfo;
    IBJobs: TIBQuery;
    DBTextJour: TLabel;
    Label1: TFWLabel;
    Label11: TFWLabel;
    Label13: TFWLabel;
    Label14: TFWLabel;
    Label15: TFWLabel;
    Label2: TFWLabel;
    Label3: TFWLabel;
    Label4: TFWLabel;
    Label5: TFWLabel;
    Label6: TFWLabel;
    Label7: TFWLabel;
    Label8: TFWLabel;
    Label9: TFWLabel;
    MenuItem1: TMenuItem;
    OngletMedias: TTabSheet;
    OngletNotes: TTabSheet;
    OngletSources: TTabSheet;
    OngletTemoins: TTabSheet;
    PageControl: TPageControl;
    PanButtons: TPanel;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    pGlobal:TPanel;
    panDock:TPanel;
    DataSourceEve:TDataSource;
    IBTemoins:TIBQuery;
    Panel2:TPanel;
    Panel3:TPanel;
    Panel5:TPanel;
    DBText1:TLabel;
    pmDate:TPopupMenu;
    Language:TYLanguage;
    btnPrecedent:TXAPrior;
    btnSuivant:TXANext;
    btnFermer:TFWClose;
    Label17:TFWLabel;
    PanelEdits:TGroupBox;
    dbcbDivers:TFWDBComboBox;
    dxStatusBar:TStatusBar;
    pmHeure:TPopupMenu;
    mSupprimerheure:TMenuItem;
    pmVideLieu:TPopupMenu;
    mEffacerlelieu:TMenuItem;
    PanLieu:TPanel;
    edSubdi:TFWDBEdit;
    DSTemoins:TDataSource;
    IBTemoinsASSOC_CLEF:TLongintField;
    IBTemoinsASSOC_KLE_IND:TLongintField;
    IBTemoinsASSOC_KLE_ASSOCIE:TLongintField;
    IBTemoinsASSOC_KLE_DOSSIER:TLongintField;
    IBTemoinsASSOC_EVENEMENT:TLongintField;
    IBTemoinsASSOC_TABLE:TStringField;
    IBTemoinsASSOC_LIBELLE:TStringField;
    IBTemoinsNOM:TStringField;
    IBTemoinsPRENOM:TStringField;
    IBTemoinsSEXE:TLongintField;
    IBTemoinsANNEE_NAISSANCE:TLongintField;
    IBTemoinsANNEE_DECES:TLongintField;
    IBTemoinsNOM_PRENOM:TStringField;
    IBUTemoins:TIBUpdateSQL;
    PmChangeFiche:TPopupMenu;
    Ouvrirlafiche1:TMenuItem;
    IBUMedias:TIBUpdateSQL;
    IBMedias:TIBQuery;
    DSMedias:TDataSource;
    pmImage:TPopupMenu;
    mVisualiseActe:TMenuItem;
    mImprimeActe:TMenuItem;
    mAjouterDocument:TMenuItem;
    mEnleverDocument:TMenuItem;
    mRemplacerDocument:TMenuItem;
    mAjouterTemoin:TMenuItem;
    mEnleverTemoin:TMenuItem;
    N1:TMenuItem;
    pmGoogle: TPopupMenu;
    mAcquerir: TMenuItem;
    procedure btnVillesVoisinesContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure dxDBImageEdit1PictureChanged(Sender: TObject);
    procedure edDateChanged(Sender: TObject);
    procedure edDateChangeLabel(const DateControl: TExtDBDateEdit;
      const IsBlank: Boolean);
    procedure edVilleExit(Sender: TObject);
    procedure edVilleLocate(Sender: TObject);
    procedure edVilleSet(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure edDateChange(Sender:TObject);
    procedure fbInfosVillesClick(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure bsfbAjoutClick(Sender:TObject);
    procedure DataSourceEveStateChange(Sender:TObject);
    procedure btnFermerClick(Sender:TObject);
    procedure btnVillesFavorisClick(Sender:TObject);
    procedure SuperFormHide(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure SuperFormShow(Sender:TObject);
    procedure fbChangeDate(Sender:TObject);
    procedure btnSuivantClick(Sender:TObject);
    procedure btnPrecedentClick(Sender:TObject);
    procedure btnDetailClick(Sender:TObject);
    procedure edDescEnter(Sender:TObject);
    procedure dbcbDiversEnter(Sender:TObject);
    procedure edDescChange(Sender:TObject);
    procedure edDescExit(Sender:TObject);
    procedure dbcbDiversExit(Sender:TObject);
    procedure dbcbDiversChange(Sender:TObject);
    procedure pmImagePopup(Sender:TObject);
    procedure DataSourceEveDataChange(Sender:TObject;Field:TField);
    procedure edCPEnter(Sender:TObject);
    procedure edCPExit(Sender:TObject);
    procedure edVilleEnter(Sender:TObject);
    procedure edInseeEnter(Sender:TObject);
    procedure edInseeExit(Sender:TObject);
    procedure mImprimeActeClick(Sender:TObject);
    procedure cxComboBoxActePropertiesEditValueChanged(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure edVilleMouseEnter(Sender:TObject);
    procedure edVilleMouseLeave(Sender: TObject);
    procedure mSupprimerheureClick(Sender:TObject);
    procedure btnInternetPopupMenuPopup(Sender:TObject;
      var APopupMenu:TPopupMenu;var AHandled:Boolean);
    procedure PageControlDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
    procedure PageControlChange(Sender:TObject);
    procedure edCommentairesKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure edSourcesKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure edCommentairesDblClick(Sender:TObject);
    procedure edSourcesDblClick(Sender:TObject);
    procedure PageControlClick(Sender:TObject);
    procedure dxDBImageEdit1Enter(Sender:TObject);
    procedure mEffacerlelieuClick(Sender:TObject);
    procedure IBTemoinsCalcFields(DataSet:TDataSet);
    procedure PmChangeFichePopup(Sender:TObject);
    procedure Ouvrirlafiche1Click(Sender:TObject);
    procedure cxGridTableTemoinsDblClick(Sender:TObject);
    procedure cxGridTableTemoinsColNomDrawColumnCell(
      Sender:TObject;ACanvas:TCanvas;
      AViewInfo:Longint;var ADone:Boolean);
    procedure cxGridTableTemoinsColRolePropertiesInitPopup(
      Sender:TObject);
    procedure DSTemoinsStateChange(Sender:TObject);
    procedure bsfbRetirerClick(Sender:TObject);
    procedure mVisualiseActeClick(Sender:TObject);
    procedure cxGridTableMediasCellDblClick(Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure SuperFormResize(Sender:TObject);
    procedure mRemplacerDocumentClick(Sender:TObject);
    procedure DSMediasStateChange(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure cxGridTemoinsExit(Sender:TObject);
    procedure edCommentairesKeyPress(Sender:TObject;var Key:Char);
    procedure cxGridTableMediasEditKeyDown(Sender:TObject;
      AItem:Longint;AEdit:TCustomMaskEdit;var Key:Word;
      Shift:TShiftState);
    procedure cxGridTableMediasEditKeyPress(Sender:TObject;
      AItem:Longint;AEdit:TCustomMaskEdit;var Key:Char);
    procedure edCommentairesMouseEnter(Sender:TObject);
    procedure cxGridTableTemoinsInitEdit(Sender:TObject;
      AItem:Longint;AEdit:TCustomMaskEdit);
    procedure IBTemoinsMediasBeforeClose(DataSet:TDataSet);
    procedure cxComboBoxActeExit(Sender:TObject);
    procedure SuperFormDeactivate(Sender:TObject);
    procedure cxGridTableTemoinsDragOver(Sender,Source:TObject;X,
      Y:Integer;State:TDragState;var Accept:Boolean);
    procedure cxGridTableTemoinsDragDrop(Sender,Source:TObject;X,
      Y:Integer);
   procedure edLatitudePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure edCommentairesPropertiesEditValueChanged(Sender: TObject);
    procedure colMemoPropertiesEditValueChanged(Sender: TObject);
    procedure mAcquerirClick(Sender: TObject);
    procedure pmGooglePopup(Sender: TObject);
    procedure InfoCopie(Sender: TObject);
    procedure EffaceBarreEtat(Sender: TObject);

  private
    bFinish:boolean;
    pNomConjoint:string;
    s_cp_entree,s_insee_entree:string;
    ev_cp_modifie:integer;
    cp_modifie,insee_modifie:boolean;
    OkEvent,OkModif:boolean;
    aFIndividuIdentite:TForm;
    BloqueCar:boolean;
    GFormIndividu : TSuperForm;
    bPremOuverture:boolean;
    clef_ev:integer;

    procedure InitCoordCity;
    procedure p_AfterDownloadCoord;
    procedure doTestCoherence;
    procedure AjouteTemoin(Temoin,Sexe:integer;NomPrenom,Naissance,Deces:string);
  public
    property NomConjoint:string read pNomConjoint write pNomConjoint;

  end;

implementation

uses  u_dm,
      u_form_individu,u_form_individu_repertoire,u_common_functions,u_common_ancestro,
      LazUTF8,
      u_common_const,
      u_form_biblio_Sources,
      u_form_main,
      u_genealogy_context,
      u_common_ancestro_functions,
      fonctions_dialogs,
      fonctions_string,
      u_form_individu_identite;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}
const
  _onglet_notes=0;
  _onglet_sources=1;
  _onglet_temoins=2;
  _onglet_medias=3;

procedure TFIndividuEditEventLife.SuperFormCreate(Sender:TObject);
begin
  aFIndividuIdentite:=TForm(Owner);
  GFormIndividu:=owner.owner as TSuperForm;
  DataSourceEve.DataSet:=TFIndividuIdentite(aFIndividuIdentite).IBQEve;
  TFIndividu(Owner.Owner).SetPaysVilles(DSCountries,DsCities);
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  btnVillesFavoris.Hint:=rs_Hint_Opens_favorite_sites_window_Ctrl_F_From_City_or_division_fields;

  Color:=gci_context.ColorLight;
  Panel3.Color:=gci_context.ColorDark;
  bsfbAjout.Color:=gci_context.ColorLight;
  bsfbRetirer.Color:=gci_context.ColorLight;
  fbInfosVilles.Color:=gci_context.ColorLight;
  btnVillesFavoris.Color:=gci_context.ColorLight;
  bsfbAjout.ColorFrameFocus:=gci_context.ColorLight;
  bsfbRetirer.ColorFrameFocus:=gci_context.ColorLight;
  fbInfosVilles.ColorFrameFocus:=gci_context.ColorLight;
  btnVillesFavoris.ColorFrameFocus:=gci_context.ColorLight;
  DBText1.Font.Color:=gci_context.ColorTexteOnglets;
  PanLieu.Cursor:=_CURPOPUP;
  PanLieu.Color:=gci_context.ColorLight;
//  btnSuivant.ColorBorder:=btnSuivant.Color;
//  btnPrecedent.ColorBorder:=btnPrecedent.Color;

  bFinish:=False;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  bFinish:=True;

  dbcbDivers.Items:=dm.ListeDiversInd;

  btnInternet.PopupMenu:=FMain.pmLieuInternet;
  btnVillesVoisines.PopupMenu:=FMain.pmVillesVoisines;
  bPremOuverture:=false;
  BloqueCar:=false;
  clef_ev:=0;
  cxGridTemoins.Hint:=rs_Hint_You_can_add_a_wittness_by_drag_drop;
end;

procedure TFIndividuEditEventLife.edVilleExit(Sender: TObject);
begin
  FMain.CtrlFbloqued:=false;
end;

procedure TFIndividuEditEventLife.edDateChanged(Sender: TObject);
var s : String ;
begin
  if edDate.Font.Style <> [fsBold] then
    begin
      if DataSourceEve.DataSet.FieldByName('EV_IND_TYPE').AsString='BIRT' then
        DBTextAge.Caption:=''
      else
      begin
        s:=Age_Texte(TFIndividu(GFormIndividu).sDateNaissance,edDate.Text);
        if s='' then
          DBTextAge.Caption:=''
        else if s[1]in ['a','e','i','o','u','y'] then
          DBTextAge.Caption:=fs_RemplaceMsg(rs_oldd,[s])
        else
          DBTextAge.Caption:=fs_RemplaceMsg(rs_olded,[s]);
      end;
    end
    else
    begin
      DBTextAge.Caption:='';
    end;
end;

procedure TFIndividuEditEventLife.dxDBImageEdit1PictureChanged(Sender: TObject);
begin
  with DBText1 do
  case dxDBImageEdit1.ImageIndex of
    0 : Text := rs_Cat_Event;
    1 : Text := rs_Cat_Death;
    2 : Text := rs_Cat_Birth;
    3 : Text := rs_Cat_Job;
    4 : Text := rs_Cat_DSCR;
    5 : Text := rs_Cat_EDUC;
    6 : Text := rs_Cat_EMIG;
    7 : Text := rs_Cat_GRAD;
    8 : Text := rs_Cat_IDNO;
    9 : Text := rs_Cat_IMMI;
    10: Text := rs_Cat_NATI;
    11: Text := rs_Cat_Naturalisation;
    12: Text := rs_Cat_PROP;
    13: Text := rs_Cat_Religion;
    14: Text := rs_Cat_SSN;
    15: Text := rs_Cat_Title;
  end;
end;

procedure TFIndividuEditEventLife.btnVillesVoisinesContextPopup(
  Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  InitCoordCity;
end;

procedure TFIndividuEditEventLife.edDateChangeLabel(const DateControl: TExtDBDateEdit;
  const IsBlank: Boolean);
var s : String ;
begin
  if IsBlank
   then
      DBTextAge.Caption:=''
   Else
    begin
      if DataSourceEve.DataSet.FieldByName('EV_IND_TYPE').AsString='BIRT' then
        DBTextAge.Caption:=''
      else
      begin
        s:=Age_Texte(TFIndividu(GFormIndividu).sDateNaissance,edDate.Text);
        if s='' then
          DBTextAge.Caption:=''
        else if s[1]in ['a','e','i','o','u','y'] then
          DBTextAge.Caption:=fs_RemplaceMsg(rs_oldd,[s])
        else
          DBTextAge.Caption:=fs_RemplaceMsg(rs_olded,[s]);
      end;
    end;

end;

procedure TFIndividuEditEventLife.edVilleLocate(Sender: TObject);
begin
  with DsCities.DataSet do
   Begin
    edCP.Text := FieldByName('CODE').AsString;
    edDept.Text := FieldByName('DEPARTEMENT').AsString;
    edPays.Text := FieldByName('PAYS').AsString;
    edRegion.Text := FieldByName('REGION').AsString;
    edInsee.Text := FieldByName('INSEE').AsString;
    edLatitude.Text := FieldByName('LATITUDE').AsString;
    edLongitude.Text := FieldByName('LONGITUDE').AsString;
   End;
end;

procedure TFIndividuEditEventLife.edVilleSet(Sender: TObject);
var
    t:string;
begin
    edVilleLocate(Sender);
    t:=DataSourceEve.DataSet.FieldByName('EV_IND_TYPE').AsString;
    if t='BIRT' then
    begin
      TFIndividu(GFormIndividu).sVilleNaissance:=edVille.Text;
      TFIndividuIdentite(aFIndividuIdentite).RefreshTitle;
    end
    else if t='DEAT' then
    begin
      TFIndividu(GFormIndividu).sVilleDeces:=edVille.Text;
      TFIndividuIdentite(aFIndividuIdentite).RefreshTitle;
    end;
end;


procedure TFIndividuEditEventLife.edDateChange(Sender:TObject);
begin
  if DataSourceEve.DataSet.FieldByName('EV_IND_TYPE').AsString='BIRT' then
    DBTextAge.Visible:=False;
end;


procedure TFIndividuEditEventLife.fbInfosVillesClick(Sender:TObject);
var
  Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string;
  t:string;
  Numpays:Integer;
begin
  with DSCountries do
    if Assigned(DataSet)
    and DataSet.Active
     Then Numpays:=DataSet.FieldByName('RPA_CODE').AsInteger
     Else Numpays:=-1;
  if FMain.ChercheVille(self,Numpays,edPays.Text,edVille.Text,
    Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long) then
  with DataSourceEve.DataSet do
  begin
    AutoCalcFields:=False;
    try
      if not(State in [dsEdit,dsInsert]) then
        Edit;
      FieldByName('EV_IND_PAYS').asString:=Pays;
      FieldByName('EV_IND_REGION').asString:=Region;
      FieldByName('EV_IND_DEPT').asString:=Dept;
      FieldByName('EV_IND_CP').asString:=Code;
      FieldByName('EV_IND_INSEE').asString:=Insee;
      FieldByName('EV_IND_VILLE').asString:=Ville;
      FieldByName('EV_IND_SUBD').asString:=Subd;
      FieldByName('EV_IND_LATITUDE').asString:=Lat;
    finally
      AutoCalcFields:=True;
    end;
    FieldByName('EV_IND_LONGITUDE').asString:=Long;
    t:=FieldByName('EV_IND_TYPE').AsString;
    if t='BIRT' then
    begin
      TFIndividu(GFormIndividu).sVilleNaissance:=Ville;
      TFIndividuIdentite(aFIndividuIdentite).RefreshTitle;
    end
    else if t='DEAT' then
    begin
      TFIndividu(GFormIndividu).sVilleDeces:=Ville;
      TFIndividuIdentite(aFIndividuIdentite).RefreshTitle;
    end;
    edSubdi.SetFocus;
  end;
end;

procedure TFIndividuEditEventLife.SuperFormRefreshControls(Sender:TObject);
var
  i:integer;
  q:TIBSQL;
  OkOCCU:boolean;
begin
  bFinish:=False;
  try
    if Visible and (DataSourceEve.DataSet<>nil) Then
    with DataSourceEve,DataSet do
    begin
      OkEvent:=(TFIndividu(GFormIndividu).CleFiche<>-1) and(Active)and(not IsEmpty);
    OkModif:=OkEvent and(TFIndividu(GFormIndividu).DialogMode=false);
    OkOCCU:=OkModif and(FieldByName('EV_IND_TYPE').AsString='OCCU');
    edDate.enabled:=OkEvent;
    pmDate.AutoPopup:=OkModif;
    edCP.enabled:=OkEvent;
    edVille.enabled:=OkEvent;
    fbInfosVilles.enabled:=OkModif;
    btnVillesFavoris.enabled:=OkModif;
    edDept.enabled:=OkEvent;
    edPays.enabled:=OkEvent;
    edRegion.enabled:=OkEvent;
    edInsee.enabled:=OkEvent;
    edSubdi.enabled:=OkEvent;
    edDesc.enabled:=OkEvent;
    edSources.enabled:=OkEvent;
    edCommentaires.enabled:=OkEvent;
    edLongitude.enabled:=OkEvent;
    edLatitude.enabled:=OkEvent;
    edHeure.enabled:=OkEvent;
    edCause.enabled:=OkEvent;
    dbcbDivers.Enabled:=OkEvent;
    AutoEdit:=OkModif;
    DSTemoins.AutoEdit:=OkModif;
    DSMedias.AutoEdit:=OkModif;
    pmVideLieu.AutoPopup:=OkModif;

    btnPrecedent.Enabled:=RecNo>1;
    btnSuivant.Enabled:=not(RecNo>RecordCount-1);
    dbcbDivers.Visible:=FieldByName('EV_IND_TYPE').AsString='EVEN';
    DBText1.Visible:=not dbcbDivers.Visible;

    IBTemoins.Close;
    IBMedias.Close;
    IBTemoins.Open;
    IBMedias.Open;
    PageControlChange(nil);//met à jour le PageControl

      if OkOCCU then
      with IBJobs do
      begin
        try
          Close;
          Params[0].AsInteger:=dm.NumDossier;
          Open;
        finally
        end;
      end
      else if OkModif and(FieldByName('EV_IND_TYPE').AsString='EVEN') then
      begin
        dbcbDivers.Items:=dm.ListeDiversInd;
      end;
      { Matthieu ?
      for i:=0 to edPays.Properties.Buttons.Count-1 do
        edPays.Properties.Buttons.Items[i].Visible:=OkModif;
      for i:=0 to edVille.Properties.Buttons.Count-1 do
        edVille.Properties.Buttons.Items[i].Visible:=OkModif;
      for i:=0 to cxComboBoxActe.Properties.Buttons.Count-1 do
        cxComboBoxActe.Properties.Buttons.Items[i].Visible:=OkModif;
      for i:=0 to dbcbDivers.Properties.Buttons.Count-1 do
        dbcbDivers.Properties.Buttons.Items[i].Visible:=OkModif;
      for i:=0 to edDesc.Properties.Buttons.Count-1 do
        edDesc.Properties.Buttons.Items[i].Visible:=OkOCCU;
                  }
      cxComboBoxActe.ReadOnly:=not OkModif;
      cxComboBoxActe.Visible:=OkEvent;
//      newlistevilles; //fait à l'entrée dans le champ Ville
      case FieldByName('EV_IND_ACTE').AsInteger of
        1:cxComboBoxActe.Text:='Acte trouvé';
        -1:cxComboBoxActe.Text:='Acte demandé';
        -2:cxComboBoxActe.Text:='Acte à chercher';
        -3:cxComboBoxActe.Text:='Acte à ignorer';
        else
          cxComboBoxActe.Text:='Acte absent';
      end;
      clef_ev:=FieldByName('ev_ind_clef').AsInteger;//pour éviter de rafraîchir 2 fois
    end;
  finally
    bFinish:=True;
  end;
end;

procedure TFIndividuEditEventLife.AjouteTemoin(Temoin,Sexe:integer;NomPrenom,Naissance,Deces:string);
var
  suite:boolean;
begin
  if IBTemoins.State in [dsInsert,dsEdit] then
    IBTemoins.Post;
  IBTemoins.DisableControls;
  try
    suite:=True;
    IBTemoins.First;
    while not IBTemoins.Eof do
    begin
      if IBTemoinsASSOC_KLE_ASSOCIE.AsInteger=Temoin then
      begin
        suite:=False;
        Break;
      end;
      IBTemoins.Next;
    end;
    if suite then
    begin
      IBTemoins.Append;
      IBTemoinsASSOC_CLEF.AsInteger:=dm.uf_GetClefUnique('T_ASSOCIATIONS');
      IBTemoinsASSOC_KLE_DOSSIER.AsInteger:=dm.NumDossier;
      IBTemoinsASSOC_TABLE.AsString:='I';
      IBTemoinsASSOC_EVENEMENT.AsInteger:=DataSourceEve.DataSet.FieldByName('EV_IND_CLEF').AsInteger;
      IBTemoinsASSOC_KLE_IND.AsInteger:=TFIndividu(GFormIndividu).CleFiche;
      IBTemoinsASSOC_KLE_ASSOCIE.AsInteger:=Temoin;
      IBTemoinsASSOC_LIBELLE.AsString:=dm.AssociationDefaut;
      IBTemoinsNOM.AsString:=NomPrenom;
      IBTemoinsSEXE.AsInteger:=Sexe;
      if _GDate.DecodeHumanDate(Naissance) then
        if _GDate.UseDate1 then
          IBTemoinsANNEE_NAISSANCE.AsInteger:=_GDate.Year1;
      if _GDate.DecodeHumanDate(Deces) then
        if _GDate.UseDate1 then
          IBTemoinsANNEE_DECES.AsInteger:=_GDate.Year1;

      IBTemoins.Post;
      TFIndividu(GFormIndividu).doBouton(true);
      PageControlChange(nil);
      cxGridTemoins.SetFocus;
    end;
  finally
    IBTemoins.EnableControls;
  end;
end;

procedure TFIndividuEditEventLife.bsfbAjoutClick(Sender:TObject);
var
  lettre,TypeEven:string;
  q:TIBSQL;
  aFIndividuRepertoire:TFIndividuRepertoire;
  i_clef:integer;

  procedure ValDefaut;
  begin
    i_clef:=TFIndividu(GFormIndividu).CleFiche;
    aFIndividuRepertoire.NomIndi:=TFIndividu(GFormIndividu).QueryIndividuNOM.AsString;
  end;
begin
  if bsfbAjout.Visible and bsfbAjout.Enabled then
  begin
    if PageControl.ActivePageIndex=_onglet_temoins then
    begin
      TFIndividu(GFormIndividu).PostIndividu;//mise à jour au cas où le nom aurait été modifié
      //Création de la boite de recherche d'un individu par le prénom
      aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
      try
        CentreLaFiche(aFIndividuRepertoire,FMain);
        if TFIndividu(GFormIndividu).QueryIndividuSEXE.AsInteger=2 then
        begin
          TypeEven:=DataSourceEve.DataSet.FieldByName('EV_IND_TYPE').AsString;
          if (TypeEven='DEAT')or(TypeEven='CREM')or(TypeEven='BURI') then
          begin
            q:=TIBSQL.Create(self);
            q.Database:=dm.ibd_BASE;
            q.Transaction:=dm.IBT_BASE;
            q.SQL.Add('select first(1) p.conjoint, c.nom'
              +' from proc_conjoints_ordonnes(:clef,0) p'
              +' inner join individu c on c.cle_fiche=p.conjoint order by p.ordre desc');
            q.Params[0].AsInteger:=TFIndividu(GFormIndividu).CleFiche;
            q.ExecQuery;
            if q.Eof then
              ValDefaut
            else
            begin
              i_clef:=q.Fields[0].AsInteger;
              aFIndividuRepertoire.NomIndi:=q.Fields[1].AsString;
            end;
            q.Close;
            q.Free;
          end
          else
            ValDefaut;
        end
        else
          ValDefaut;

        lettre:=copy(fs_FormatText(aFIndividuRepertoire.NomIndi,mftUpper,True),1,1);
        aFIndividuRepertoire.InitIndividuPrenom(lettre,'INDEX',0,i_clef,False,True);
        aFIndividuRepertoire.Caption:=rs_caption_Select_Witness;
        if aFIndividuRepertoire.ShowModal=mrOk then
        begin
          AjouteTemoin(aFIndividuRepertoire.ClefIndividuSelected,aFIndividuRepertoire.SexeIndividuSelected
            ,aFIndividuRepertoire.NomPrenomIndividuSelected,aFIndividuRepertoire.NaissanceIndividuSelected
            ,aFIndividuRepertoire.DecesIndividuSelected);
        end;
      finally
        FreeAndNil(aFIndividuRepertoire);
      end;
    end
    else //_onglet_medias
    begin
      i_clef:=FMain.OuvreBiblioMedias(True,DataSourceEve.DataSet.FieldByName('EV_IND_CLEF').AsInteger,'I','A');
      if i_clef>0 then
      begin
        IBMedias.Close;
        IBMedias.Open;
        TFIndividu(GFormIndividu).doBouton(true);
        if IBMedias.RecordCount=1 then //c'est le premier
        begin
          if not(DataSourceEve.State in [dsEdit,dsInsert]) then
            DataSourceEve.DataSet.edit;
          DataSourceEve.DataSet.FieldByName('ev_ind_media').AsInteger:=i_clef;
        end;
        PageControlChange(nil);
      end;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TFIndividuEditEventLife.DataSourceEveStateChange(Sender:TObject);
begin
  if (DataSourceEve.State in [dsEdit,dsInsert]) then
    TFIndividu(GFormIndividu).doBouton(true);
end;

procedure TFIndividuEditEventLife.btnFermerClick(Sender:TObject);
begin
  Close;
end;

procedure TFIndividuEditEventLife.btnVillesFavorisClick(Sender:TObject);
var
  Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string;
  t:string;
  Numpays:Integer;
begin
  with DSCountries do
    if Assigned(DataSet)
    and DataSet.Active
     Then Numpays:=DataSet.FieldByName('RPA_CODE').AsInteger
     Else Numpays:=-1;
  if FMain.ChercheLieuFavori(self,Numpays,edPays.Text,edVille.Text,edSubdi.Text,
    Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long) then
  with DataSourceEve.DataSet do
  begin
    AutoCalcFields:=False;
    try
      if not(State in [dsEdit,dsInsert]) then
        Edit;
      FieldByName('EV_IND_PAYS').asString:=Pays;
      FieldByName('EV_IND_REGION').asString:=Region;
      FieldByName('EV_IND_DEPT').asString:=Dept;
      FieldByName('EV_IND_CP').asString:=Code;
      FieldByName('EV_IND_INSEE').asString:=Insee;
      FieldByName('EV_IND_VILLE').asString:=Ville;
      FieldByName('EV_IND_SUBD').asString:=Subd;
      FieldByName('EV_IND_LATITUDE').asString:=Lat;
    finally
      AutoCalcFields:=True;
    end;
    FieldByName('EV_IND_LONGITUDE').asString:=Long;
    t:=FieldByName('EV_IND_TYPE').AsString;
    if t='BIRT' then
    begin
      TFIndividu(GFormIndividu).sVilleNaissance:=Ville;
      TFIndividuIdentite(aFIndividuIdentite).RefreshTitle;
    end
    else if t='DEAT' then
    begin
      TFIndividu(GFormIndividu).sVilleDeces:=Ville;
      TFIndividuIdentite(aFIndividuIdentite).RefreshTitle;
    end;
    edSubdi.SetFocus;
  end;
end;

procedure TFIndividuEditEventLife.doTestCoherence;
var
  s,t:string;
begin
  with DataSourceEve.DataSet,TFIndividu(GFormIndividu) do
   Begin
    if IsEmpty Then Exit;
    s:=FieldByName('EV_IND_DATE_WRITEN').AsString;
    t:=FieldByName('EV_IND_TYPE').AsString;
    if t='BIRT' then
      CoherenceDate.Naissance.SetDateWriten(s)
    else if t='DEAT' then
      CoherenceDate.Deces.SetDateWriten(s)
    else
      CoherenceDate.AddInfoDateWriten(
        s,
        t,
        FieldByName('EV_IND_CLEF').AsInteger,
        CoherenceDate.AutresEventInd
        );
    CoherenceDate.Test;
end;
end;

procedure TFIndividuEditEventLife.SuperFormHide(Sender:TObject);
begin
  doTestCoherence;
end;

procedure TFIndividuEditEventLife.SuperFormKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  if Key=_KEY_HELP then
    p_ShowHelp(_HELP_INDI_IDENTITE);
end;

procedure TFIndividuEditEventLife.SuperFormShow(Sender:TObject);
begin
  doRefreshControls;
end;

procedure TFIndividuEditEventLife.fbChangeDate(Sender:TObject);
var
  t:string;
begin
  t:=DataSourceEve.DataSet.FieldByName('EV_IND_TYPE').AsString;
  if t='BIRT' then
    begin
      TFIndividu(GFormIndividu).sDateNaissance:=DataSourceEve.DataSet.FieldByName('EV_IND_DATE_WRITEN').AsString;
      TFIndividuIdentite(aFIndividuIdentite).RefreshTitle;
    end
    else if t='DEAT' then
    begin
      TFIndividu(GFormIndividu).sDateDeces:=DataSourceEve.DataSet.FieldByName('EV_IND_DATE_WRITEN').AsString;
      TFIndividuIdentite(aFIndividuIdentite).RefreshTitle;
    end;
end;

procedure TFIndividuEditEventLife.mImprimeActeClick(Sender:TObject);
var
  iClef:Integer;
begin
  iClef:=IBMedias.FieldByName('mp_media').AsInteger;
  if iClef>0 then
    ImprimeImage(iClef,'')
  else
    MyMessageDlg(rs_Error_None_picture_for_this_document,mtError, [mbOK],Self);
end;

procedure TFIndividuEditEventLife.btnSuivantClick(Sender:TObject);
begin
  DataSourceEve.DataSet.Next;
end;

procedure TFIndividuEditEventLife.btnPrecedentClick(Sender:TObject);
begin
  DataSourceEve.DataSet.Prior;
end;

procedure TFIndividuEditEventLife.btnDetailClick(Sender:TObject);
var
  aFBiblio_Sources:TFBiblio_Sources;
  details:integer;
begin
  PageControl.ActivePageIndex:=_onglet_sources;
  if DataSourceEve.State in [dsEdit,dsInsert] then
    DataSourceEve.DataSet.Post;

  aFBiblio_Sources:=TFBiblio_Sources.create(self);
  with DataSourceEve.DataSet do
  try
    CentreLaFiche(aFBiblio_Sources,FMain);
    aFBiblio_Sources.FormIndividu:=TFIndividu(GFormIndividu);
    aFBiblio_Sources.Caption:=fs_RemplaceMsg(rs_Caption_Event_s_sources,[FieldByName('_LIBELLE').AsString]);
    aFBiblio_Sources.doOpenQuerys(FieldByName('EV_IND_CLEF').AsInteger,'I');
    if aFBiblio_Sources.ShowModal=mrOk then
    begin
      if dm.IBQSources_Record.State in [dsEdit,dsInsert] then
      begin
        Edit;
        FieldByName('EV_IND_SOURCE').AsString:=aFBiblio_Sources.sText;
        dm.IBQSources_Record.Post;
      end;
      if aFBiblio_Sources.IBMultimedia.State in [dsEdit,dsInsert] then
        aFBiblio_Sources.IBMultimedia.Post;
    end
    else
    begin
      if dm.IBQSources_Record.State in [dsEdit,dsInsert] then
        dm.IBQSources_Record.CancelUpdates;
      if aFBiblio_Sources.IBMultimedia.State in [dsEdit,dsInsert] then
        aFBiblio_Sources.IBMultimedia.CancelUpdates;
    end;
    if aFBiblio_Sources.Modif=True then
    begin
      TFIndividu(GFormIndividu).doBouton(true);
      if not aFBiblio_Sources.IBMultimedia.IsEmpty
        or(length(aFBiblio_Sources.dxDBMemo2.Text)>0)
        or(length(aFBiblio_Sources.dxDBMemo3.Text)>0)
        or(length(aFBiblio_Sources.dxDBMemo4.Text)>0)
        or(length(aFBiblio_Sources.dxDBMemo5.Text)>0)
        or(length(aFBiblio_Sources.dxDBEdit3.Text)>0) then
        details:=1
      else
        details:=0;
      if FieldByName('EV_IND_DETAILS').AsInteger<>details then
      begin
        Edit;
        FieldByName('EV_IND_DETAILS').AsInteger:=details;
        PageControlChange(nil);
      end;
    end;
  finally
    FreeAndNil(aFBiblio_Sources);
  end;
end;

procedure TFIndividuEditEventLife.dbcbDiversEnter(Sender:TObject);
begin
  dbcbDivers.MaxLength:=89-Length(edDesc.Text);
  if dbcbDivers.MaxLength>25 then
    dbcbDivers.MaxLength:=25;
  if dbcbDivers.MaxLength=0 then
  begin
    dbcbDivers.Enabled:=false;
    edDesc.SetFocus;
  end
  else
    dbcbDivers.Enabled:=true;
  Label17.Visible:=True;
end;

procedure TFIndividuEditEventLife.edDescEnter(Sender:TObject);
begin
  with DataSourceEve.DataSet do
  if (dbcbDivers.Text=FieldByName('REF_EVE_LIB_LONG').asString)or
    (length(dbcbDivers.text)=0)or
    (FieldByName('EV_IND_TYPE').asString<>'EVEN')
   then edDesc.MaxLength:=90
   else edDesc.MaxLength:=89-Length(dbcbDivers.Text);
  Label17.Visible:=edDesc.MaxLength<90;
end;

procedure TFIndividuEditEventLife.edDescChange(Sender:TObject);
begin
  if (edDesc.MaxLength=90) or not (DataSourceEve.DataSet.State in [dsInsert,dsEdit]) then
    exit;
  Label17.Caption:=fs_RemplaceMsg(rs_Caption_Describe_you_can_press_arg_chars,[IntTostr(edDesc.MaxLength-Length(edDesc.Text))]);
end;

procedure TFIndividuEditEventLife.edDescExit(Sender:TObject);
begin
  Label17.Visible:=False;
  Label17.Caption:='';
end;

procedure TFIndividuEditEventLife.dbcbDiversExit(Sender:TObject);
begin
  Label17.Caption:='';
  Label17.Visible:=False;
end;

procedure TFIndividuEditEventLife.dbcbDiversChange(Sender:TObject);
begin
  Label17.Caption:=fs_RemplaceMsg(rs_Caption_Describe_you_can_press_arg_chars,[IntTostr(dbcbDivers.MaxLength-Length(dbcbDivers.Text))]);
end;

procedure TFIndividuEditEventLife.pmImagePopup(Sender:TObject);
var
  iClef:integer;
begin
  iClef:=IBMedias.FieldByName('mp_media').AsInteger;
  mImprimeActe.Visible:=(iClef>0)and(IBMedias.FieldByName('multi_image_rtf').AsInteger=0);
  mVisualiseActe.Visible:=iClef>0;
end;

procedure TFIndividuEditEventLife.DataSourceEveDataChange(Sender:TObject;
  Field:TField);
begin
  ev_cp_modifie:=0;
  cp_modifie:=false;
  insee_modifie:=false;
  btnVillesVoisines.enabled:=(length(trim(edLatitude.Text))>0)and(length(trim(edLongitude.Text))>0);
  btnInternet.Enabled:=not((length(trim(edVille.Text))=0)
            and(not fCassiniDll or(UTF8UpperCase(edPays.Text)<>'FRANCE'))
            and(not btnVillesVoisines.enabled));
  if (DataSourceEve.DataSet.FieldByName('EV_IND_clef').AsInteger<>clef_ev) then
  begin
    DoRefreshControls;
  end;
end;

procedure TFIndividuEditEventLife.edCPEnter(Sender:TObject);
begin
  s_cp_entree:=edCP.Text;
end;

procedure TFIndividuEditEventLife.edCPExit(Sender:TObject);
begin
  if edCP.Text<>s_cp_entree then
  begin
    ev_cp_modifie:=DataSourceEve.DataSet.FieldByName('EV_IND_clef').AsInteger;
    cp_modifie:=true;
    edVille.SetFocus;
  end;
end;

procedure TFIndividuEditEventLife.edVilleEnter(Sender:TObject);
begin
  FMain.CtrlFbloqued:=true;
end;

procedure TFIndividuEditEventLife.edInseeEnter(Sender:TObject);
begin
  s_insee_entree:=edInsee.Text;
end;

procedure TFIndividuEditEventLife.edInseeExit(Sender:TObject);
begin
  if edInsee.Text<>s_insee_entree then
  begin
    ev_cp_modifie:=DataSourceEve.DataSet.FieldByName('EV_IND_clef').AsInteger;
    insee_modifie:=true;
    edVille.SetFocus;
  end;
end;

procedure TFIndividuEditEventLife.cxComboBoxActePropertiesEditValueChanged(
  Sender:TObject);
begin
  if not bFinish then exit;

  with DataSourceEve.DataSet do
   Begin
    if not(State in [dsEdit,dsInsert]) then
      Edit;

    if cxComboBoxActe.Text='Acte trouvé' then
      FieldByName('EV_IND_ACTE').AsInteger:=1
    else if cxComboBoxActe.Text='Acte demandé' then
      FieldByName('EV_IND_ACTE').AsInteger:=-1
    else if cxComboBoxActe.Text='Acte à chercher' then
      FieldByName('EV_IND_ACTE').AsInteger:=-2
    else if cxComboBoxActe.Text='Acte à ignorer' then
      FieldByName('EV_IND_ACTE').AsInteger:=-3
    else
      FieldByName('EV_IND_ACTE').AsInteger:=0;
  End;
end;

procedure TFIndividuEditEventLife.SuperFormShowFirstTime(Sender:TObject);
var
  DecalX,DecalY:integer;
  FormProp:TForm;
begin
  Height:=gci_context.HautEven;
  if TFIndividu(GFormIndividu).DialogMode then
    FormProp:=GFormIndividu
  else
    FormProp:=FMain;
  DecalX:=(FormProp.Width-Width)div 2;
  DecalY:=((FormProp.Height-Height)div 2)+25;
  CentreLaFiche(self,FormProp,DecalX,DecalY);
  Caption:=rs_Caption_Details_of_event;
  PageControl.ActivePageIndex:=_onglet_notes;
  bPremOuverture:=true;
end;

procedure TFIndividuEditEventLife.edVilleMouseEnter(Sender:TObject);
begin
  dxStatusBar.Panels[0].Text:='le raccourci Ctrl+F dans Ville ou Subdivision présélectionne un lieu favori';
end;

procedure TFIndividuEditEventLife.edVilleMouseLeave(Sender:TObject);
begin
  dxStatusBar.Panels[0].Text:='';
end;

procedure TFIndividuEditEventLife.mSupprimerheureClick(Sender:TObject);
begin
  DataSourceEve.DataSet.Edit;
  DataSourceEve.DataSet.FieldByName('EV_IND_heure').Clear;
end;
procedure TFIndividuEditEventLife.InitCoordCity;
Begin
  FMain.Lieu_Pays:=edPays.Text;
  FMain.Lieu_Region:=edRegion.Text;
  FMain.Lieu_CP:=edCP.Text;
  FMain.Lieu_Ville:=edVille.Text;
  FMain.Lieu_Latitude:=edLatitude.Text;
  FMain.Lieu_Longitude:=edLongitude.Text;
  FMain.Lieu_Subdivision:=edSubdi.Text;

end;

procedure TFIndividuEditEventLife.btnInternetPopupMenuPopup(
  Sender:TObject;var APopupMenu:TPopupMenu;var AHandled:Boolean);
begin
  InitCoordCity;
end;


procedure TFIndividuEditEventLife.PageControlDrawTabEx(
  AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  if TPageControl(AControl).ActivePageIndex=ATab.PageIndex then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
end;

procedure TFIndividuEditEventLife.PageControlChange(Sender:TObject);
var
  k:integer;
begin
  k:=PageControl.ActivePageIndex;
  btnDetail.Visible:=(k=_onglet_sources)
    and((TFIndividu(GFormIndividu).DialogMode=false)or(DataSourceEve.DataSet.FieldByName('EV_IND_DETAILS').AsInteger=1))
    and not DataSourceEve.DataSet.IsEmpty;//1
  bsfbAjout.Visible:=((k=_onglet_temoins)or(k=_onglet_medias))
    and(TFIndividu(GFormIndividu).DialogMode=false);
  bsfbRetirer.Visible:=bsfbAjout.Visible;
  bsfbAjout.Enabled:=not DataSourceEve.DataSet.IsEmpty;
  if k=_onglet_temoins then
  begin
    bsfbRetirer.Enabled:=not IBTemoins.IsEmpty;
    mAjouterTemoin.Visible:=bsfbAjout.Visible and bsfbAjout.Enabled;
    mEnleverTemoin.Visible:=bsfbRetirer.Visible and bsfbRetirer.Enabled;
    bsfbAjout.Hint:=rs_Hint_Add_a_witness_to_this_event;
    bsfbRetirer.Hint:=rs_Hint_Delete_the_witness_s_link;
  end
  else
  begin
    bsfbRetirer.Enabled:=not IBMedias.IsEmpty;
    mAjouterDocument.Visible:=bsfbAjout.Visible and bsfbAjout.Enabled;
    mEnleverDocument.Visible:=bsfbRetirer.Visible and bsfbRetirer.Enabled;
    mRemplacerDocument.Visible:=mEnleverDocument.Visible;
    cxGridMedias.ShowHint:=mEnleverDocument.Visible;
    bsfbAjout.Hint:=rs_Hint_Add_a_doc_to_this_event;
    bsfbRetirer.Hint:=rs_Hint_Delete_the_doc_s_link;
  end;
  PageControl.ShowHint:=(k=_onglet_temoins) and bsfbAjout.Visible and bsfbAjout.Enabled;

  if DataSourceEve.dataset<>nil then
  begin
    if DataSourceEve.DataSet.FieldByName('EV_IND_COMMENT').AsString>'' then
      PageControl.Pages[_onglet_notes].ImageIndex:=74
    else
      PageControl.Pages[_onglet_notes].ImageIndex:=66;
    if (DataSourceEve.DataSet.FieldByName('EV_IND_DETAILS').AsInteger=1)
      or(DataSourceEve.DataSet.FieldByName('EV_IND_SOURCE').AsString>'') then
      PageControl.Pages[_onglet_sources].ImageIndex:=74
    else
      PageControl.Pages[_onglet_sources].ImageIndex:=66;
    if not IBTemoins.IsEmpty then
      PageControl.Pages[_onglet_temoins].ImageIndex:=74
    else
      PageControl.Pages[_onglet_temoins].ImageIndex:=66;
    if not IBMedias.IsEmpty then
      PageControl.Pages[_onglet_medias].ImageIndex:=74
    else
      PageControl.Pages[_onglet_medias].ImageIndex:=66;
  end
  else
  begin
    PageControl.Pages[_onglet_notes].ImageIndex:=66;
    PageControl.Pages[_onglet_sources].ImageIndex:=66;
    PageControl.Pages[_onglet_temoins].ImageIndex:=66;
    PageControl.Pages[_onglet_medias].ImageIndex:=66;
  end;
end;

procedure TFIndividuEditEventLife.edCommentairesKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  if not TFIndividu(GFormIndividu).DialogMode then
  begin
    s:=edCommentaires.Text;
    k:=edCommentaires.SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      if not(DataSourceEve.DataSet.State in [dsEdit,dsInsert]) then
        DataSourceEve.DataSet.Edit;
      DataSourceEve.DataSet.FieldByName('EV_IND_COMMENT').AsString:=s;
      edCommentaires.SelStart:=k;
      BloqueCar:=true;
    end;
  end;
end;

procedure TFIndividuEditEventLife.edSourcesKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  if not TFIndividu(GFormIndividu).DialogMode then
  begin
    s:=edSources.Text;
    k:=edSources.SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      if not(DataSourceEve.DataSet.State in [dsEdit,dsInsert]) then
        DataSourceEve.DataSet.Edit;
      DataSourceEve.DataSet.FieldByName('EV_IND_SOURCE').AsString:=s;
      edSources.SelStart:=k;
      BloqueCar:=true;
    end;
  end;
end;

procedure TFIndividuEditEventLife.edCommentairesDblClick(Sender:TObject);
begin
  ExecuteChaineDansChaine(edCommentaires.Text,edCommentaires.SelStart,edCommentaires.SelLength);
end;

procedure TFIndividuEditEventLife.edSourcesDblClick(Sender:TObject);
begin
  ExecuteChaineDansChaine(edSources.Text,edSources.SelStart,edSources.SelLength);
end;

procedure TFIndividuEditEventLife.PageControlClick(Sender:TObject);
begin
  case PageControl.ActivePageIndex of
    _onglet_notes:SendFocus(edCommentaires);
    _onglet_sources:SendFocus(edSources);
    _onglet_temoins:SendFocus(cxGridTemoins);
    _onglet_medias:SendFocus(cxGridMedias);
  end;
end;

procedure TFIndividuEditEventLife.dxDBImageEdit1Enter(Sender:TObject);
begin
  if edDesc.CanFocus then
    edDesc.SetFocus
  else if edDate.CanFocus then
    edDate.SetFocus;
end;

procedure TFIndividuEditEventLife.mEffacerlelieuClick(Sender:TObject);
begin
  if not(DataSourceEve.DataSet.State in [dsEdit,dsInsert]) then
    DataSourceEve.DataSet.Edit;
  DataSourceEve.DataSet.FieldByName('EV_IND_CP').Clear;
  DataSourceEve.DataSet.FieldByName('EV_IND_VILLE').Clear;
  DataSourceEve.DataSet.FieldByName('EV_IND_PAYS').Clear;
  DataSourceEve.DataSet.FieldByName('EV_IND_DEPT').Clear;
  DataSourceEve.DataSet.FieldByName('EV_IND_REGION').Clear;
  DataSourceEve.DataSet.FieldByName('EV_IND_INSEE').Clear;
  DataSourceEve.DataSet.FieldByName('EV_IND_LATITUDE').Clear;
  DataSourceEve.DataSet.FieldByName('EV_IND_LONGITUDE').Clear;
  DataSourceEve.DataSet.FieldByName('EV_IND_SUBD').Clear;
end;

procedure TFIndividuEditEventLife.IBTemoinsCalcFields(DataSet:TDataSet);
begin
  IBTemoinsNOM_PRENOM.AsString:=
    AssembleString([IBTemoinsNOM.AsString,IBTemoinsPRENOM.AsString])
  +GetStringNaissanceDeces(IBTemoinsANNEE_NAISSANCE.AsString
    ,IBTemoinsANNEE_DECES.AsString);
end;

procedure TFIndividuEditEventLife.PmChangeFichePopup(Sender:TObject);
begin
  if IBTemoinsASSOC_KLE_ASSOCIE.AsInteger>0 then
    Ouvrirlafiche1.Visible:=true
  else
    Ouvrirlafiche1.Visible:=false;
end;

procedure TFIndividuEditEventLife.Ouvrirlafiche1Click(Sender:TObject);
begin
  if IBTemoinsASSOC_KLE_ASSOCIE.AsInteger>0 then
  begin
    dm.individu_clef:=IBTemoinsASSOC_KLE_ASSOCIE.AsInteger;
    DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
  end;
end;

procedure TFIndividuEditEventLife.cxGridTableTemoinsDblClick(
  Sender:TObject);
begin
  Ouvrirlafiche1Click(Sender);
end;

procedure TFIndividuEditEventLife.cxGridTableTemoinsColNomDrawColumnCell(
  Sender:TObject;ACanvas:TCanvas;
  AViewInfo:Longint;var ADone:Boolean);
var
  v:Variant;
begin
//  v:=field.Value;
  if not VarIsNull(v) then
    case v of
      1:ACanvas.Font.Color:=gci_context.ColorHomme;
      2:ACanvas.Font.Color:=gci_context.ColorFemme;
      else
        ACanvas.Font.Color:=clWindowText;
    end
  else
    ACanvas.Font.Color:=clWindowText;
end;

procedure TFIndividuEditEventLife.cxGridTableTemoinsColRolePropertiesInitPopup(
  Sender:TObject);
var
  i:integer;
  AText:string;
begin
  if DSTemoins.AutoEdit then
  begin
    Atext:=(sender as TWinControl).Caption;
    if (length(AText)=0)or(AText=dm.AssociationDefaut) then
      TFWDBComboBox(Sender).Items:=dm.ListeAssociations
    else
    begin
      TFWDBComboBox(Sender).Items.Clear;
      for i:=1 to dm.ListeAssociations.Count-1 do
        TFWDBComboBox(Sender).Items.Add(copy(AText+' '+dm.ListeAssociations[i],1,90));
    end;
  end
  else
    TFWDBComboBox(Sender).Items.Clear;
end;

procedure TFIndividuEditEventLife.DSTemoinsStateChange(Sender:TObject);
begin
  if DSTemoins.State in [dsEdit,dsInsert] then
    TFIndividu(GFormIndividu).doBouton(true);
end;

procedure TFIndividuEditEventLife.bsfbRetirerClick(Sender:TObject);
begin
  if bsfbRetirer.Visible and bsfbRetirer.Enabled then
  begin
    if PageControl.ActivePageIndex=_onglet_temoins then
    begin
      if MyMessageDlg(rs_Confirm_deleting_this_witness_associated_with+_CRLF+FMain.NomIndiComplet+' ?',
        mtConfirmation, [mbYes,mbNo],Self)=mrYes then
      begin
        IBTemoins.Delete;
        TFIndividu(GFormIndividu).doBouton(true);
        PageControlChange(nil);
      end;
    end
    else
    begin//_onglet_medias
      if MyMessageDlg(rs_Confirm_media_unlink_from_event,
        mtConfirmation, [mbYes,mbNo],Self)=mrYes then
      begin
        IBMedias.Delete;
        if IBMedias.IsEmpty then
        begin
          if not(DataSourceEve.State in [dsEdit,dsInsert]) then
            DataSourceEve.DataSet.edit;
          DataSourceEve.DataSet.FieldByName('EV_IND_media').AsInteger:=0;
          PageControlChange(nil);
        end;
        TFIndividu(GFormIndividu).doBouton(true);
      end;
    end;
  end;
end;

procedure TFIndividuEditEventLife.mVisualiseActeClick(Sender:TObject);
var
  iClef:integer;
begin
  with IBMedias do
  if Active and not IsEmpty then
  begin
    iClef:=FieldByName('mp_media').AsInteger;
    VisualiseMedia(iClef,dm.ReqSansCheck);
  end;
end;

procedure TFIndividuEditEventLife.cxGridTableMediasCellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  mVisualiseActeClick(sender);
end;

procedure TFIndividuEditEventLife.SuperFormResize(Sender:TObject);
begin
  if bPremOuverture then
  begin
    gci_context.ShouldSave:=true;
    gci_context.HautEven:=Height;
  end;
end;

procedure TFIndividuEditEventLife.mRemplacerDocumentClick(Sender:TObject);
var
  q:TIBSQL;
  mp_clef,mp_media:integer;
begin
  mp_media:=FMain.OuvreBiblioMedias(True,0,'','');
  if mp_media>0 then
  begin
    mp_clef:=IBMedias.FieldByName('mp_clef').AsInteger;
    if IBMedias.State in [dsInsert,dsEdit] then
      IBMedias.Post;
    IBMedias.Close;
    q:=TIBSQL.Create(self);
    with q do
    try
      Database:=dm.ibd_BASE;
      Transaction:=dm.IBT_BASE;
      SQL.Add('update media_pointeurs set mp_media=:mp_media where mp_clef=:mp_clef');
      ParamByName('mp_media').AsInteger:=mp_media;
      ParamByName('mp_clef').AsInteger:=mp_clef;
      ExecQuery;
      Close;
    finally
      Free;
    end;
    IBMedias.Open;
    TFIndividu(GFormIndividu).doBouton(true);
  end;
end;

procedure TFIndividuEditEventLife.DSMediasStateChange(Sender:TObject);
begin
  if DSMedias.State in [dsEdit,dsInsert] then
    TFIndividu(GFormIndividu).doBouton(true);
end;

procedure TFIndividuEditEventLife.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  if DataSourceEve.State in [dsInsert,dsEdit] then
    DataSourceEve.DataSet.Post;
  if IBTemoins.State in [dsInsert,dsEdit] then
    IBTemoins.Post;
  if IBMedias.State in [dsInsert,dsEdit] then
    IBMedias.Post;
  Action:=caHide;
end;

procedure TFIndividuEditEventLife.cxGridTemoinsExit(Sender:TObject);
begin//nécessaire si l'utilisateur n'a pas validé par Enter
  if DSTemoins.State in [dsInsert,dsEdit] then
    IBTemoins.Post;
end;

procedure TFIndividuEditEventLife.edCommentairesKeyPress(Sender:TObject;
  var Key:Char);
begin
  if BloqueCar then
  begin
    BloqueCar:=false;
    Key:=#0;
  end;
end;

procedure TFIndividuEditEventLife.cxGridTableMediasEditKeyDown(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit;var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
begin
{ Matthieu ?
if (AItem=colMemo)and(not TFIndividu(GFormIndividu).DialogMode) then
  begin
    s:=(aEdit as TMemo).Text;
    k:=(aEdit as TMemo).SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      if not(IBMedias.State in [dsEdit,dsInsert]) then
        IBMedias.Edit;
      IBMediasMULTI_MEMO.AsString:=s;
      (aEdit as TMemo).SelStart:=k;
      BloqueCar:=true;
    end;
  end;}
end;

procedure TFIndividuEditEventLife.cxGridTableMediasEditKeyPress(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit;var Key:Char);
begin
  if BloqueCar then
  begin
    BloqueCar:=false;
    Key:=#0;
  end;
end;

procedure TFIndividuEditEventLife.edCommentairesMouseEnter(
  Sender:TObject);
begin
  dxStatusBar.Panels[0].Text:='Les raccourcis de saisie sont utilisables dans les champs Notes, Sources et Ville';
end;

procedure TFIndividuEditEventLife.cxGridTableTemoinsInitEdit(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit);
var
  i:integer;
begin
{ Matthieu ?
  if AItem=cxGridTableTemoinsColRole then
  begin
    for i:=0 to(AEdit as TFWDBLookupCombo).Properties.Buttons.Count-1 do
      (AEdit as TFWDBLookupCombo).Properties.Buttons.Items[i].Visible:=DSTemoins.AutoEdit;

    if DSTemoins.AutoEdit then
    begin
      (AEdit as TFWDBLookupCombo).Style.ButtonStyle:=btsOffice11;
      (AEdit as TFWDBLookupCombo).Style.ButtonTransparency:=ebtHideUnselected;
    end;
  end;}
end;

procedure TFIndividuEditEventLife.IBTemoinsMediasBeforeClose(DataSet:TDataSet);
begin
  if dataset.State in [dsInsert,dsEdit] then
    dataset.Post;
end;

procedure TFIndividuEditEventLife.cxComboBoxActeExit(Sender: TObject);
begin
  if GetKeyState(VK_TAB)<0 then
  begin
    PageControl.ActivePage:=OngletNotes;
    SendFocus(edCommentaires);
  end;
end;

procedure TFIndividuEditEventLife.SuperFormDeactivate(Sender: TObject);
begin
  TFIndividu(GFormIndividu).Temporisation:=true;
end;

procedure TFIndividuEditEventLife.cxGridTableTemoinsDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if TFIndividu(GFormIndividu).DialogMode
    or not bsfbAjout.Visible
    or not bsfbAjout.Enabled then
    Accept:=False
  else
    Accept:=True;
end;

procedure TFIndividuEditEventLife.cxGridTableTemoinsDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  try
    AjouteTemoin(FMain.IndiDrag.cle,FMain.IndiDrag.sexe,FMain.IndiDrag.nomprenom
      ,FMain.IndiDrag.naissance,FMain.IndiDrag.deces);
  finally
    Abort;
  end;
end;


procedure TFIndividuEditEventLife.edLatitudePropertiesValidate(
  Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
  var Error: Boolean);
begin
  if not BcdIsValide(DisplayValue)then
  begin
    MyMessageDlg(rs_Error_value_or_format_error,mtError, [mbOk],Self);
    (Sender as TWinControl).SetFocus;
    Abort;
  end;
end;

procedure TFIndividuEditEventLife.edCommentairesPropertiesEditValueChanged(
  Sender: TObject);
begin //le Post n'est pas automatique lors du changement d'enregistrement si seul le mémo a été effacé!
  with Sender as TCustomMemo do
  if (DataSourceEve.State=dsEdit)
    and (Text='') then
      DataSourceEve.DataSet.Post;
end;

procedure TFIndividuEditEventLife.colMemoPropertiesEditValueChanged(
  Sender: TObject);
begin //le Post n'est pas automatique lors du changement d'enregistrement si seul le mémo a été effacé!
  if (DSMedias.State=dsEdit) and ((Sender as TcustomMemo).Text='') then
    IBMedias.Post;
end;
procedure TFIndividuEditEventLife.p_AfterDownloadCoord;
begin
  DataSourceEve.DataSet.AutoCalcFields:=False;
  try
    if not(DataSourceEve.DataSet.State in [dsEdit,dsInsert]) then
      DataSourceEve.DataSet.Edit;
    if dm.UneSubd>'' then
      DataSourceEve.DataSet.FieldByName('EV_IND_SUBD').asString:=dm.UneSubd;
   DataSourceEve.DataSet.FieldByName('EV_IND_LATITUDE').asString:=dm.UneLatitude;
  finally
    DataSourceEve.DataSet.AutoCalcFields:=True;
  end;
  DataSourceEve.DataSet.FieldByName('EV_IND_LONGITUDE').asString:=dm.UneLongitude;
end;

procedure TFIndividuEditEventLife.mAcquerirClick(Sender: TObject);
begin
  dm.UneLatitude:=edLatitude.Text;
  dm.UneLongitude:=edLongitude.Text;
  dm.UneSubd:=edSubdi.Text;
  DoCoordNext:=TProcedureOfObject(p_AfterDownloadCoord);
  dm.GetCoordonneesInternet(edVille.Text,edDept.Text,edRegion.Text,edPays.Text,self);
end;

procedure TFIndividuEditEventLife.pmGooglePopup(Sender: TObject);
begin
  dxStatusBar.Panels[0].Text:=mAcquerir.Hint;
end;

procedure TFIndividuEditEventLife.InfoCopie(Sender: TObject);
begin
  dxStatusBar.Panels[0].Text:='Ctrl+G demande les coordonnées sur Google Maps.';
end;

procedure TFIndividuEditEventLife.EffaceBarreEtat(Sender: TObject);
begin
  dxStatusBar.Panels[0].Text:='';
end;

end.


