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
unit u_form_individu_Domiciles;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
{$IFNDEF FPC}
  ShellAPI, TPanelUnit, u_comp_TFlatTabControl2, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  Forms, U_FormAdapt, Menus, u_comp_TYLanguage, IBCustomDataSet, IBUpdateSQL,
  DB, IBQuery, StdCtrls, Controls, Classes, ExtCtrls, dialogs, Graphics,
  MaskEdit, u_extsearchedit, u_framework_dbcomponents, u_buttons_appli,
  u_ancestropictbuttons, U_ExtDBImage, u_ancestropictimages, u_extdateedit,
  U_ExtDBGrid, u_buttons_defs, U_OnFormInfoIni, ExtJvXPButtons, PrintersDlgs,
  U_ExtNumEdits, VirtualTrees, ComCtrls, types;

type
  TADRTree=record
    ImageIdx,
    cleAdr:integer;
    Libelle : String;
  end;
  PADRTree=^TADRTree;

  TModeUpdate=(ModeMedia,ModePointeur);

  { TFIndividuDomiciles }

  TFIndividuDomiciles=class(TF_FormAdapt)
    bsfbAjout: TFWAdd;
    bsfbRetirer: TFWDelete;
    btnDetail: TFWXPButton;
    btnEMail: TXAEMail;
    btnInternet: TXAWeb;
    btnQuiHabite: TJvXPButton;
    btnVillesFavoris: TXAFavorite;
    btnVillesVoisines: TXANeighbor;
    cxBtTrouveAdresse: TXAPostCard;
    cxGridMedias: TExtDBGrid;
    dsAdresses:TDataSource;
    DSCountries: TDatasource;
    DSMedias: TDatasource;
    DSVilles: TDatasource;
    edCommentaires: TFWDBMemo;
    edDept: TFWDBEdit;
    edINSEE: TExtSearchDBEdit;
    edSources: TFWDBMemo;
    edSubd: TFWDBEdit;
    edVille: TExtSearchDBEdit;
    fbInfosVilles: TXAInfo;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LabelCP: TLabel;
    LabelDate: TLabel;
    LabelDept: TLabel;
    LabelINSEE: TLabel;
    LabelLatitude: TLabel;
    LabelLongitude: TLabel;
    LabelPays: TLabel;
    LabelRegion: TLabel;
    LabelSubd: TLabel;
    LabelVille: TLabel;
    LabelWEB: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    PanButtons: TPanel;
    Panel11: TPanel;
    Panel13: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel31: TPanel;
    Panel5: TPanel;
    fpAdresses: TPanel;
    lbDay: TLabel;
    MemoMedia: TFWDBMemo;
    OngletMedias: TTabSheet;
    OngletNotes: TTabSheet;
    OngletSources: TTabSheet;
    PageControl: TPageControl;
    Panel10:TPanel;
    lNom:TLabel;
    Label8:TLabel;
    Language:TYLanguage;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    PanLieu: TPanel;
    pmDate:TPopupMenu;
    ImgCat:TImageList;
    Panel1:TPanel;
    Panel2:TPanel;
    ImageList1:TImageList;
    dxComponentPrinter1:TPrinterSetupDialog;
    bfsbDeleteAdresse:TFWDelete;
    bfsbAjoutAdresse:TFWAdd;
    sDBECP: TExtSearchDBEdit;
    sDBEMail: TFWDBEdit;
    sDBEPays: TExtSearchDBEdit;
    sDBERegion: TFWDBEdit;
    sdbLatitude: TExtDBNumEdit;
    sdbLongitude: TExtDBNumEdit;
    sDBMAdresse: TFWDBMemo;
    sDBMDate: TExtDBDateEdit;
    sDBTel: TFWDBMemo;
    sdbWWW: TFWDBEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    tvAdr:TVirtualStringTree;
    pmAdresses:TPopupMenu;
    mAjouterAdresse:TMenuItem;
    mSupprimerAdresse:TMenuItem;
    mQuiHabite:TMenuItem;
    IBQEve:TIBQuery;
    IBQEveEV_IND_CLEF:TLongintField;
    IBQEveEV_IND_KLE_FICHE:TLongintField;
    IBQEveEV_IND_KLE_DOSSIER:TLongintField;
    IBQEveEV_IND_TYPE:TIBStringField;
    IBQEveEV_IND_DATE_WRITEN:TIBStringField;
    IBQEveEV_IND_DATE_YEAR:TLongintField;
    IBQEveEV_IND_DATE:TDateField;
    IBQEveEV_IND_CP:TIBStringField;
    IBQEveEV_IND_VILLE:TIBStringField;
    IBQEveEV_IND_DEPT:TIBStringField;
    IBQEveEV_IND_PAYS:TIBStringField;
    IBQEveEV_IND_REGION:TIBStringField;
    IBQEveEV_IND_SUBD:TIBStringField;
    IBQEveEV_IND_ACTE:TLongintField;
    IBQEveEV_IND_INSEE:TIBStringField;
    IBQEveEV_IND_LATITUDE:TFloatField;
    IBQEveEV_IND_LONGITUDE:TFloatField;
    IBQEveEV_IND_DETAILS:TLongintField;
    IBQEveEV_IND_DATE_MOIS:TLongintField;
    IBQEveEV_IND_DATE_YEAR_FIN:TLongintField;
    IBQEveEV_IND_DATE_MOIS_FIN:TLongintField;
    IBQEveEV_IND_LIGNES_ADRESSE:TMemoField;
    IBQEveEV_IND_SOURCE:TMemoField;
    IBQEveEV_IND_COMMENT:TMemoField;
    IBQEveEV_IND_TEL:TMemoField;
    IBQEveEV_IND_WEB:TStringField;
    IBQEveEV_IND_MAIL:TStringField;
    IBQEveEV_IND_DATE_JOUR: TSmallintField;
    IBQEveEV_IND_DATE_JOUR_FIN: TSmallintField;
    IBQEveEV_IND_TYPE_TOKEN1: TSmallintField;
    IBQEveEV_IND_TYPE_TOKEN2: TSmallintField;
    IBQEveEV_IND_DATECODE: TLongintField;
    IBQEveEV_IND_DATECODE_TOT: TLongintField;
    IBQEveEV_IND_DATECODE_TARD: TLongintField;
    IBQEveEV_IND_CALENDRIER1: TIntegerField;
    IBQEveEV_IND_CALENDRIER2: TSmallintField;
    IBUEve:TIBUpdateSQL;
    IBMedias:TIBQuery;
    IBMediasMP_POSITION:TLongintField;
    IBMediasMULTI_REDUITE:TBlobField;
    IBMediasMULTI_MEDIA:TBlobField;
    IBMediasMP_CLEF:TLongintField;
    IBMediasMP_MEDIA:TLongintField;
    IBMediasMULTI_MEMO:TMemoField;
    IBMediasMULTI_PATH:TStringField;
    PmImage:TPopupMenu;
    mVisualiseActe:TMenuItem;
    mImprimeActe:TMenuItem;
    mAjouterDocument:TMenuItem;
    mEnleverDocument:TMenuItem;
    mRemplacerDocument:TMenuItem;
    IBUMedias:TIBUpdateSQL;
    Panel3:TPanel;
    cxPhoto:TImage;
    cxDBImage:TExtDBImage;
    N1:TMenuItem;
    mMontrerRepere:TMenuItem;
    mSupprimerRepere:TMenuItem;
    mPoserRepere:TMenuItem;
    lPoint:TImage;
    N2:TMenuItem;
    pmVideLieu: TPopupMenu;
    mEffacerlelieu: TMenuItem;
    pmGoogle: TPopupMenu;
    mAcquerir: TMenuItem;
    procedure btnVillesVoisinesContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure cxGridMediasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edVilleLocate(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure bfsbAjoutAdresseClick(Sender:TObject);
    procedure bfsbDeleteAdresseClick(Sender:TObject);
    procedure dsAdressesStateChange(Sender:TObject);
    procedure fbInfosVillesClick(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure btnVillesFavorisClick(Sender:TObject);
    procedure btnEMailClick(Sender:TObject);
    procedure sDBMDateChange(Sender:TObject);
    procedure fbCalendClick(Sender:TObject);
    procedure btnInternetClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure btnQuiHabiteClick(Sender:TObject);
    procedure dxDBGrid1ADR_VILLEDrawColumnCell(
      Sender:TObject;ACanvas:TCanvas;
      AViewInfo:Longint;var ADone:Boolean);
    procedure sDBECPEnter(Sender:TObject);
    procedure sDBECPExit(Sender:TObject);
    procedure dsAdressesDataChange(Sender:TObject;Field:TField);
    procedure edVilleEnter(Sender:TObject);
    procedure edINSEEEnter(Sender:TObject);
    procedure edINSEEExit(Sender:TObject);
    procedure cxBtTrouveAdresseClick(Sender:TObject);
    procedure doChangeNode(Sender:TObject);
    procedure pmImagePopup(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure pmDatePopup(Sender:TObject);
    procedure edVilleMouseEnter(Sender:TObject);
    procedure btnInternetPopupMenuPopup(Sender:TObject;
      var APopupMenu:TPopupMenu;var AHandled:Boolean);
    procedure tvAdrBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure tvAdrClick(Sender: TObject);
    procedure tvAdrCustomDrawItem(Sender:TCustomTreeView;Node:TTreeNode;
      State:TCustomDrawState;var DefaultDraw:Boolean);
    procedure sDBMDatePropertiesExit(Sender:TObject);
    procedure pmAdressesPopup(Sender:TObject);
    procedure edVilleExit(Sender:TObject);
    procedure edSubdEnter(Sender:TObject);
    procedure IBQEveNewRecord(DataSet:TDataSet);
    procedure edVilleKeyPress(Sender:TObject;var Key:Char);
    procedure PageControlChange(Sender:TObject);
    procedure edCommentairesMouseEnter(Sender:TObject);
    procedure edCommentairesKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure edSourcesKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure edCommentairesDblClick(Sender:TObject);
    procedure edSourcesDblClick(Sender:TObject);
    procedure PageControlClick(Sender:TObject);
    procedure PageControlDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
    procedure cxGridTableMediasEditKeyPress(Sender:TObject;
      AItem:Longint;AEdit:TCustomMaskEdit;var Key:Char);
    procedure cxGridTableMediasCellDblClick(Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure mVisualiseActeClick(Sender:TObject);
    procedure mImprimeActeClick(Sender:TObject);
    procedure bsfbAjoutClick(Sender:TObject);
    procedure bsfbRetirerClick(Sender:TObject);
    procedure mRemplacerDocumentClick(Sender:TObject);
    procedure DSMediasStateChange(Sender:TObject);
    procedure IBMediasAfterOpen(DataSet:TDataSet);
    procedure IBMediasAfterScroll(DataSet:TDataSet);
    procedure IBMediasBeforeClose(DataSet:TDataSet);
    procedure btnDetailClick(Sender:TObject);
    procedure DatasetBeforeScrollOrClose(DataSet:TDataSet);
    procedure mMontrerRepereClick(Sender:TObject);
    procedure mSupprimerRepereClick(Sender:TObject);
    procedure mPoserRepereClick(Sender:TObject);
    procedure Panel3Resize(Sender:TObject);
    procedure mEffacerlelieuClick(Sender: TObject);
    procedure sdbWWWExit(Sender: TObject);
    procedure PageControlEnter(Sender: TObject);
    procedure PageControlExit(Sender: TObject);
    procedure tvAdrGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure tvAdrGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure tvAdrInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure sdbLatitudePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure colMemoPropertiesEditValueChanged(Sender: TObject);
    procedure mAcquerirClick(Sender: TObject);
    procedure pmGooglePopup(Sender: TObject);
    procedure EffaceBarreEtat(Sender: TObject);
    procedure InfoCopie(Sender: TObject);
  private
    iCleAdr:Integer;
    Adresse:TADRTree;
//    l_Cp,l_Dept,l_Pays,l_Villes,l_Region,l_INSEE,l_Lat,l_Long:TStringlistUTF8;
    s_cp_entree,s_insee_entree:string;
    ev_cp_modifie:integer;
    cp_modifie,insee_modifie:boolean;
    okModif:boolean;
    BloqueCar:boolean;
    OkRefresh,OpenMedia:boolean;
    PathImage:string;
    PointSouris:TPoint;

    function doSrcutetvAdr(const iNumLigne: integer; const Anode: PVirtualNode
      ): Boolean;
    procedure p_AfterDownloadCoord;
    procedure up_SubMenu(Sender:TObject);
    procedure doShowDay;
    procedure doChargePhoto;
    procedure doTestCoherence;
    procedure MontrerRepere;
    procedure SetModeUpdate(ModeUpdate:TModeUpdate);//AL
    function TexteLigneTV:string;

  public
    //pour désactiver le TPageControl principal au profit des secondaires
    bPageControl:boolean;
    procedure doRempliTV;
    procedure doInitialize;
    function doOpenQuerys:boolean;
    procedure doGoto(const iNumLigne:integer);
  end;

implementation
uses u_dm,
     u_form_individu,
     LazUTF8,
     u_common_functions,
     u_common_ancestro,
     SysUtils,
     fonctions_system,
     fonctions_string,
     fonctions_dialogs,
     u_common_const,
     u_form_calendriers,
     u_Form_Main,
     u_Form_Qui_Habite_La,
     u_form_biblio_Sources,
     u_gedcom_const,
     u_genealogy_context,
     u_common_ancestro_functions,
     IBSQL,Math,
     FileUtil;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

const
  _onglet_notes=0;
  _onglet_sources=1;
  _onglet_medias=2;
var  fFormIndividu:TFIndividu=nil;

function TFIndividuDomiciles.doOpenQuerys:boolean;
begin
  doRempliTV;
  Result:=True;
end;

function TFIndividuDomiciles.TexteLigneTV:string;
var
  sChaine,chDate:string;
begin
  if not IBQEveEV_IND_DATE_YEAR.IsNull then
    chDate:=IBQEveEV_IND_DATE_YEAR.AsString
  else
    chDate:='';

  if not IBQEveEV_IND_DATE_YEAR_FIN.IsNull then
    if chDate='' then
      chDate:=IBQEveEV_IND_DATE_YEAR_FIN.AsString
    else
      if IBQEveEV_IND_DATE_YEAR_FIN.AsInteger<>IBQEveEV_IND_DATE_YEAR.AsInteger then
        chDate:=chDate+'-'+IBQEveEV_IND_DATE_YEAR_FIN.AsString;

  if Trim(IBQEveEV_IND_SUBD.AsString)>'' then
    sChaine:=Trim(IBQEveEV_IND_SUBD.AsString)
  else
    sChaine:='';

  if gci_context.AfficheCPdansListeEV and(Trim(IBQEveEV_IND_CP.AsString)>'') then
    if sChaine='' then
      sChaine:=Trim(IBQEveEV_IND_CP.AsString)
    else
      sChaine:=sChaine+', '+Trim(IBQEveEV_IND_CP.AsString);

  if Trim(IBQEveEV_IND_VILLE.AsString)>'' then
    if sChaine='' then
      sChaine:=Trim(IBQEveEV_IND_VILLE.AsString)
    else
      sChaine:=sChaine+', '+Trim(IBQEveEV_IND_VILLE.AsString);

  if Trim(IBQEveEV_IND_DEPT.AsString)>'' then
    if sChaine='' then
      sChaine:=Trim(IBQEveEV_IND_DEPT.AsString)
    else
      sChaine:=sChaine+', '+Trim(IBQEveEV_IND_DEPT.AsString);

  if gci_context.AfficheRegiondansListeEV and(Trim(IBQEveEV_IND_REGION.AsString)>'') then
    if sChaine='' then
      sChaine:=Trim(IBQEveEV_IND_REGION.AsString)
    else
      sChaine:=sChaine+', '+Trim(IBQEveEV_IND_REGION.AsString);

  if Trim(IBQEveEV_IND_PAYS.AsString)>'' then
    if sChaine='' then
      sChaine:=Trim(IBQEveEV_IND_PAYS.AsString)
    else
      sChaine:=sChaine+', '+Trim(IBQEveEV_IND_PAYS.AsString);

  if chDate>'' then
    if sChaine='' then
      sChaine:=chDate
    else
      sChaine:=chDate+': '+sChaine;
  result:=sChaine;
end;

procedure TFIndividuDomiciles.doRempliTV;
var
  NoeudAjoute,NoeudParent,NodeSelecte:PVirtualNode;
  DomSelecte:integer;
begin
  PathImage:='';
  tvAdr.Clear;
  tvAdr.NodeDataSize:=SizeOf(TADRTree)+1;
  lPoint.Visible:=false;
  OkRefresh:=false;
  with IBQEve, tvAdr do
  try
    DisableControls;
    IBMedias.Close;
    cxPhoto.Picture:=nil;
    DomSelecte:=0;
    NodeSelecte:=nil;
    Close;
    Params[0].AsString:=gci_context.Langue;
    Params[1].AsInteger:=FFormIndividu.CleFiche;
    try
      Open;
    except
      on E:Exception do
        MyMessageDlg(rs_Error_while_reading_sites_list+_CRLF
          +E.Message,mtError, [mbOK],FMain);
    end;

    if FocusedNode<>nil then //pour pouvoir y revenir si rafraîchissement
      if GetNodeData(FocusedNode)<>nil then
        DomSelecte:=PAdrTree(GetNodeData(FocusedNode))^.cleAdr;
    BeginUpdate;
    Clear;

    if IsEmpty then
    begin
      Enabled:=false;
      EndUpdate;
    end
    else
    with Adresse do
    begin
      Enabled:=true;
      cleAdr:=0;
      Libelle:='Liste chronologique des domiciles';
      ImageIdx:=2;
      NoeudParent:=AddChild(nil,nil);
      ValidateNode(NoeudParent,False);

//      NoeudParent.SelectedIndex:=2;

      while not Eof do
      begin
        cleAdr:=FieldByName('EV_IND_CLEF').AsInteger;
        Libelle:=TexteLigneTV;
        if UpperCase(trim(FieldByName('EV_IND_PAYS').asString))='FRANCE'
          then ImageIdx:=0
          else ImageIdx:=3;

        NoeudAjoute:=AddChild(NoeudParent,nil);
        ValidateNode(NoeudAjoute,False);
        if DomSelecte>0 then
          if DomSelecte=FieldByName('EV_IND_CLEF').AsInteger then
            NodeSelecte:=NoeudAjoute;

        Next;
      end;

      FullExpand;
      EndUpdate;

      IBQEve.First;

      if CanFocus then
        SetFocus;

      if NodeSelecte<>nil then
      begin
        Selected[NodeSelecte]:=true;
        FocusedNode:=NodeSelecte;
      end
      else
      begin
       Selected[RootNode.FirstChild]:=true;
       FocusedNode:=RootNode.FirstChild;
      end;
    end;
  finally
    OkRefresh:=true;
    EnableControls;
  end;
  doChangeNode(nil);
end;

procedure TFIndividuDomiciles.doChangeNode(Sender:TObject);
var
  i:integer;
begin
  if OkRefresh then
  begin
    IBMedias.Close;
    if tvAdr.FocusedNode<>nil then
    begin
      if (PAdrTree(tvAdr.GetNodeData(tvAdr.FocusedNode))<>nil) then
      begin
        iCleAdr:=PAdrTree(tvAdr.GetNodeData(tvAdr.FocusedNode))^.cleAdr;
        if dsAdresses.State in [dsInsert,dsEdit] then
        begin
          IBQEve.Post;
          doRempliTV;
        end;
        IBQEve.DisableControls;
        IBQEve.locate('ev_ind_clef',iCleAdr, []);
        IBQEve.EnableControls;

        doShowDay;
        IBMedias.Open;
        doChargePhoto;
      end
      else
      begin
        cxPhoto.Picture:=nil;
        lPoint.Visible:=false;
      end;
    end
    else
    begin
      cxPhoto.Picture:=nil;
      lPoint.Visible:=false;
    end;

    if IBQEve.Active Then
     Begin
      PageControlChange(nil);
      if Assigned(_FormHistoire) then
        _FormHistoire.doPosition(IBQEveEV_IND_CLEF.AsInteger,0);
     end;

  end;
end;

procedure TFIndividuDomiciles.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls:=SuperFormRefreshControls;
  fFormIndividu:=TFIndividu(Owner);
  fFormIndividu.SetPaysVilles(DSCountries,DSVilles);
  tvAdr .NodeDataSize := Sizeof(TADRTree)+1;
  btnVillesFavoris.Hint:=rs_Hint_Opens_favorite_sites_window_Ctrl_F_From_City_or_division_fields;

  Color:=gci_context.ColorLight;
  PanLieu.Color:=gci_context.ColorLight;
  PanLieu.Cursor:=_CURPOPUP;
  bfsbAjoutAdresse.Color:=gci_context.ColorLight;
  bfsbDeleteAdresse.Color:=gci_context.ColorLight;
  fbInfosVilles.Color:=gci_context.ColorLight;
  btnVillesFavoris.Color:=gci_context.ColorLight;
  bfsbAjoutAdresse.ColorFrameFocus:=gci_context.ColorLight;
  bfsbDeleteAdresse.ColorFrameFocus:=gci_context.ColorLight;
  fbInfosVilles.ColorFrameFocus:=gci_context.ColorLight;
  btnVillesFavoris.ColorFrameFocus:=gci_context.ColorLight;
  bsfbAjout.Color:=gci_context.ColorLight;
  bsfbRetirer.Color:=gci_context.ColorLight;
  bsfbAjout.ColorFrameFocus:=gci_context.ColorLight;
  bsfbRetirer.ColorFrameFocus:=gci_context.ColorLight;

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  lbDay.caption:='';
  btnInternet.PopupMenu:=FMain.pmLieuInternet;
  btnVillesVoisines.PopupMenu:=FMain.pmVillesVoisines;
  BloqueCar:=false;
  OpenMedia:=false;
  PathImage:='';
  SetModeUpdate(ModeMedia);
  lPoint.Visible:=gci_context.MontrerRepere;
  PageControl.ActivePageIndex:=_onglet_notes;
  bPageControl:=false;
  lNom.PopupMenu:=FFormIndividu.pmNom;
  lNom.OnMouseEnter:=FFormIndividu.lNomMouseEnter;
  lNom.OnMouseLeave:=FFormIndividu.lNomMouseLeave;
  lNom.OnMouseMove:=FFormIndividu.lNomMouseMove;
  lNom.OnClick:=FFormIndividu.lNomClick;
end;

procedure TFIndividuDomiciles.cxGridMediasKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
{  with cxGridMedias do
  if (SelectedColumn=colMemo)and(not FFormIndividu.DialogMode) then
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
  end;
      }
end;

procedure TFIndividuDomiciles.btnVillesVoisinesContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  FMain.Lieu_Pays:=sDBEPays.Text;
  FMain.Lieu_Region:=sDBERegion.Text;
  FMain.Lieu_CP:=sDBECP.Text;
  FMain.Lieu_Ville:=edVille.Text;
  FMain.Lieu_Latitude:=sdbLatitude.Text;
  FMain.Lieu_Longitude:=sdbLongitude.Text;
  FMain.Lieu_Subdivision:=edSubd.Text;
end;

procedure TFIndividuDomiciles.edVilleLocate(Sender: TObject);
begin
  with FFormIndividu.IBCities do
  begin
    IBQEveEV_IND_CP       .asString := FieldByName('code').AsString;
    IBQEveEV_IND_DEPT     .asString := FieldByName('departement').AsString;
    IBQEveEV_IND_PAYS     .asString := FieldByName('pays').AsString;
    IBQEveEV_IND_REGION   .asString := FieldByName('region').AsString;
    IBQEveEV_IND_INSEE    .asString := FieldByName('insee').AsString;
    IBQEveEV_IND_LATITUDE .asString := FieldByName('latitude').AsString;
    IBQEveEV_IND_LONGITUDE.asString := FieldByName('longitude').AsString;
  end;

end;

procedure TFIndividuDomiciles.bfsbAjoutAdresseClick(Sender:TObject);
var
  NouvClef:integer;
begin
  if bfsbAjoutAdresse.Visible and bfsbAjoutAdresse.Enabled then
  begin
    if dsAdresses.State in [dsEdit,dsInsert] then
      IBQEve.Post;
    IBQEve.Append;
    NouvClef:=IBQEveEV_IND_CLEF.AsInteger;
    IBQEve.Post;
    dorempliTV;
    doGoto(NouvClef);
    DoRefreshControls;
    sDBMDate.SetFocus;
  end;
end;

procedure TFIndividuDomiciles.bfsbDeleteAdresseClick(Sender:TObject);
begin
  if bfsbDeleteAdresse.Visible and bfsbDeleteAdresse.Enabled then
  begin
    if MyMessageDlg(rs_Do_you_delete_this_address,mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
    begin
      IBQEve.Delete;

      FFormIndividu.doBouton(True);
      dorempliTV;
      DoRefreshControls;
      FFormIndividu.TestCoherenceDates;
    end;
  end;
end;

procedure TFIndividuDomiciles.doInitialize;
begin
  IBQEve.Close;
end;

procedure TFIndividuDomiciles.dsAdressesStateChange(Sender:TObject);
begin
  if dsAdresses.State in [dsEdit,dsInsert] then
    FFormIndividu.doBouton(True);
end;

procedure TFIndividuDomiciles.fbInfosVillesClick(Sender:TObject);
var
  Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string;
  Numpays:Integer;
begin
  with DSCountries do
    if Assigned(DataSet)
    and DataSet.Active
     Then Numpays:=DataSet.FieldByName('RPA_CODE').AsInteger
     Else Numpays:=-1;
  if FMain.ChercheVille(FMain,Numpays,sDBEPays.Text,edVille.Text,
    Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long) then
  begin
    if not(IBQEve.State in [dsEdit,dsInsert]) then
      IBQEve.Edit;
    IBQEveEV_IND_PAYS.asString:=Pays;
    IBQEveEV_IND_REGION.asString:=Region;
    IBQEveEV_IND_DEPT.asString:=Dept;
    IBQEveEV_IND_CP.asString:=Code;
    IBQEveEV_IND_INSEE.asString:=Insee;
    IBQEveEV_IND_VILLE.asString:=Ville;
    IBQEveEV_IND_SUBD.asString:=Subd;
    IBQEveEV_IND_LATITUDE.asString:=Lat;
    IBQEveEV_IND_LONGITUDE.asString:=Long;
    edSubd.SetFocus;
  end;
end;

procedure TFIndividuDomiciles.SuperFormRefreshControls(Sender:TObject);
var
  okActif,okAjout,okAdresse:boolean;
  i:integer;
begin
  okActif:=(FFormIndividu.CleFiche<>-1)and IBQEve.active;
  okAdresse:=okActif and(IBQEve.IsEmpty=False);
  okAjout:=okActif and not FFormIndividu.DialogMode;
  okModif:=okAdresse and not FFormIndividu.DialogMode;
  bfsbAjoutAdresse.enabled:=okAjout;
  bfsbDeleteAdresse.enabled:=okModif;
  if FFormIndividu.OngletFormIncrusted=_ONGLET_DOMICILES then
    FFormIndividu.btnPrint.enabled:=okAdresse;
  btnVillesFavoris.enabled:=okModif;
  fbInfosVilles.enabled:=okModif;
  cxBtTrouveAdresse.enabled:=okAdresse;
//  fbCalend.enabled:=okModif;
  btnQuiHabite.enabled:=okAdresse;
  btnQuiHabite.Visible:=not FFormIndividu.DialogMode;//'Qui habite là' pas prévu en mode dialog
  edSubd.enabled:=okAdresse;
  sdbLatitude.enabled:=okAdresse;
  sdbLongitude.enabled:=okAdresse;
  sDBMDate.enabled:=okAdresse;
  sDBMAdresse.enabled:=okAdresse;
  sDBECP.enabled:=okAdresse;
  edDept.enabled:=okAdresse;
  edVille.enabled:=okAdresse;
  sDBERegion.enabled:=okAdresse;
  sDBEPays.enabled:=okAdresse;
  sDBEMail.enabled:=okAdresse;
  sdbWWW.enabled:=okAdresse;
  sDBTel.enabled:=okAdresse;
  edINSEE.enabled:=okAdresse;
  PageControl.enabled:=okAdresse;
  pmVideLieu.AutoPopup:=okModif;
  { Matthieu ?
  for i:=0 to edVille.Properties.Buttons.Count-1 do
    edVille.Properties.Buttons.Items[i].Visible:=okModif;
  for i:=0 to sDBEPays.Properties.Buttons.Count-1 do
    sDBEPays.Properties.Buttons.Items[i].Visible:=okModif;
              }
  dsAdresses.AutoEdit:=not FFormIndividu.DialogMode;
  edVille.SearchSource.DataSet.Close;
  PageControlChange(nil);//met à jour le PageControl
end;

procedure TFIndividuDomiciles.btnVillesFavorisClick(Sender:TObject);
var
  Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string;
  Numpays:Integer;
begin
  with DSCountries do
    if Assigned(DataSet)
    and DataSet.Active
     Then Numpays:=DataSet.FieldByName('RPA_CODE').AsInteger
     Else Numpays:=-1;
  if FMain.ChercheLieuFavori(FMain,Numpays,sDBEPays.Text,edVille.Text,edSubd.Text,
    Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long) then
  begin
    if not(IBQEve.State in [dsEdit,dsInsert]) then
      IBQEve.Edit;
    IBQEveEV_IND_PAYS.asString:=Pays;
    IBQEveEV_IND_REGION.asString:=Region;
    IBQEveEV_IND_DEPT.asString:=Dept;
    IBQEveEV_IND_CP.asString:=Code;
    IBQEveEV_IND_INSEE.asString:=Insee;
    IBQEveEV_IND_VILLE.asString:=Ville;
    IBQEveEV_IND_SUBD.asString:=Subd;
    IBQEveEV_IND_LATITUDE.asString:=Lat;
    IBQEveEV_IND_LONGITUDE.asString:=Long;
    edSubd.SetFocus;
  end;
end;

procedure TFIndividuDomiciles.btnEMailClick(Sender:TObject);
var
  x:string;
begin
  x:='mailto:'+trim(sDBEMail.Text);//+ '?Subject=Message de ' + lNom.Caption;
  p_OpenFileOrDirectory(x);
//  ShellExecute(0,nil,PChar(x),nil,nil,SW_SHOWDEFAULT);
end;

procedure TFIndividuDomiciles.sDBMDateChange(Sender:TObject);
begin
  doShowDay;
end;

procedure TFIndividuDomiciles.doShowDay;
var
  sDateTrans,joursem:string;
  ans,mois,jours:integer;
  Cal:TCalendrier;
begin
  if doTesteDateEtJour(sDBMDate.Text,joursem,sDateTrans,ans,mois,jours,Cal) then
  begin
    sDBMDate.Font.Color:=clWindowText;
    sDBMDate.Font.Style:= [];
    lbDay.Caption:=joursem;
    lbDay.Visible:=True;
  end
  else
  begin
    sDBMDate.Font.Color:=clRed;
    sDBMDate.Font.Style:= [fsBold];
    lbDay.Visible:=False;
  end;
end;

procedure TFIndividuDomiciles.fbCalendClick(Sender:TObject);
var
  aFCalendriers:TFCalendriers;
  sDateTrans,joursem:string;
  ans,mois,jours:integer;
  Cal:TCalendrier;
begin
  sDBMDate.SetFocus;
  aFCalendriers:=TFCalendriers.create(self);
  try
    CentreLaFiche(aFCalendriers,FMain);
    doTesteDateEtJour(sDBMDate.Text,joursem,sDateTrans,ans,mois,jours,Cal);
    aFCalendriers.doInit(ans,mois,jours,Cal);
    if aFCalendriers.ShowModal=mrOk then
    begin
      sDBMDate.Text:=aFCalendriers.laDate
    end;
  finally
    FreeAndNil(aFCalendriers);
  end;
end;

procedure TFIndividuDomiciles.btnInternetClick(Sender:TObject);
begin
  GotoThisURL(sdbWWW.Text);
end;

procedure TFIndividuDomiciles.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBMedias.Close;
  IBQEve.Close;
end;

procedure TFIndividuDomiciles.sDBMDatePropertiesExit(Sender:TObject);
begin
  if sDBMDate.Modified then
  with sDBMDate do
  begin
    // matthieu ?
  //  Text:=CalcChampsDateInd(IBQEve,Text);
    doTestCoherence;
  end;
end;

procedure TFIndividuDomiciles.btnQuiHabiteClick(Sender:TObject);
var
  aFQuiHabiteLa:TFQuiHabiteLa;
  bModified:boolean;
  iClef:integer;
begin
  if btnQuiHabite.Enabled then
  begin
    if FFormIndividu.bsfbAppliquer.Enabled then
    begin
      FFormIndividu.DoAppliquer(false);//post toutes les modifications sans commiter
    end;
    iClef:=iCleAdr;
    if iClef>0 then
    begin
      aFQuiHabiteLa:=TFQuiHabiteLa.create(self);
      try
        if FFormIndividu.DialogMode then
          CentreLaFiche(aFQuiHabiteLa,fFormindividu)
        else
          CentreLaFiche(aFQuiHabiteLa,FMain);
        aFQuiHabiteLa.doInit(iclef,
          FFormIndividu.QueryIndividuNOM.AsString,
          FFormIndividu.QueryIndividuPRENOM.AsString,
          sDBECP.text+' - '+edVille.text);
        aFQuiHabiteLa.ShowModal;
        bModified:=aFQuiHabiteLa.bModifier;
        iClef:=aFQuiHabiteLa.CleFicheSelected;
      finally
        FreeAndNil(aFQuiHabiteLa);
      end;
      if bModified then
      begin
        FFormIndividu.doBouton(true);
        doRempliTV;//pour rafraîchir
      end;
      if iClef<>0 then
      begin
        dm.individu_clef:=iClef;
        DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
      end;
    end;
  end;
end;

procedure TFIndividuDomiciles.doChargePhoto;
var
  bImage:boolean;
begin
  if not OkRefresh or not OpenMedia then
    exit;
  if IBMediasmulti_path.AsString<>PathImage then
  begin
    bImage:=false;
    PathImage:=IBMediasmulti_path.AsString;
    if FichEstImage(PathImage) then
    begin
      if FileExistsUTF8(PathImage) { *Converted from FileExistsUTF8*  } then
      begin
        try
          cxPhoto.Picture.LoadFromFile(PathImage);
          bImage:=true;
        except
        //format non accepté
        end;
      end;
    end;
    if not bImage then
    begin
      if TBlobField(IBMediasmulti_media).BlobSize>0 then
      begin
        cxDBImage.Datafield:='multi_media';
        cxPhoto.Picture:=cxDBImage.Picture;
      end
      else if TBlobField(IBMediasmulti_reduite).BlobSize>0 then
      begin
        cxDBImage.Datafield:='multi_reduite';
        cxPhoto.Picture:=cxDBImage.Picture;
      end
      else
      begin
        cxPhoto.Picture:=nil;
      end;
    end;
    if gci_context.MontrerRepere then
      MontrerRepere
    else
      lPoint.Visible:=false;
  end;
end;

procedure TFIndividuDomiciles.dxDBGrid1ADR_VILLEDrawColumnCell(
  Sender:TObject;ACanvas:TCanvas;
  AViewInfo:Longint;var ADone:Boolean);
begin
  Acanvas.Font.Style:= [fsbold];
end;

procedure TFIndividuDomiciles.sDBECPEnter(Sender:TObject);
begin
  s_cp_entree:=sDBECP.Text;
end;

procedure TFIndividuDomiciles.sDBECPExit(Sender:TObject);
begin
  if sDBECP.Text<>s_cp_entree then
  begin
    ev_cp_modifie:=IBQEveEV_IND_CLEF.AsInteger;
    cp_modifie:=true;
    edVille.SetFocus;
  end;
end;

procedure TFIndividuDomiciles.dsAdressesDataChange(Sender:TObject;
  Field:TField);
var
  curseur:TCursor;
  i:Integer;
begin
  ev_cp_modifie:=0;
  cp_modifie:=false;
  insee_modifie:=false;
  btnEMail.enabled:=(length(trim(sDBEMail.Text))>0);
  btnInternet.enabled:=(length(trim(sdbWWW.Text))>0);
  with IBQEve do
   if not IsEmpty Then
    Begin
      btnVillesVoisines.Enabled:=(Length(FieldByName('EV_IND_LATITUDE').AsString)>0)
        and(Length(FieldByName('EV_IND_LONGITUDE').AsString)>0);
      btnInternet.Enabled:=not IBQEve.IsEmpty
        and not(FieldByName('EV_IND_VILLE').IsNull
                and(not fCassiniDll or(UTF8UpperCase(FieldByName('EV_IND_PAYS').AsString)<>'FRANCE'))
                and(not btnVillesVoisines.enabled));
    end;
  pmGoogle.AutoPopup:=(Trim(edVille.Text)>'')and(not FFormIndividu.DialogMode);
  if pmGoogle.AutoPopup then
    curseur:=_CURPOPUP
  else
    curseur:=crDefault;
  for i:=0 to PanLieu.ControlCount-1 do
    if (PanLieu.Controls[i] is TCustomMaskEdit)or(PanLieu.Controls[i] is TCustomComboBox) then
      TControl(PanLieu.Controls[i]).Cursor:=curseur;
end;

procedure TFIndividuDomiciles.edVilleEnter(Sender:TObject);
begin
  FMain.CtrlFbloqued:=true;
{  if (edVille.Items.Count>0)
    and(ev_cp_modifie=IBQEveEV_IND_CLEF.AsInteger) then
    edVille.DroppedDown:=true;}
end;

procedure TFIndividuDomiciles.edINSEEEnter(Sender:TObject);
begin
  s_Insee_entree:=edINSEE.Text;
end;

procedure TFIndividuDomiciles.edINSEEExit(Sender:TObject);
begin
  if edINSEE.Text<>s_insee_entree then
  begin
    ev_cp_modifie:=IBQEveEV_IND_CLEF.AsInteger;
    insee_modifie:=true;
    edVille.SetFocus;
  end;
end;

procedure TFIndividuDomiciles.cxBtTrouveAdresseClick(Sender:TObject);
var
  sUrl,sNom,sPrenom,sCP:string;
begin
  sNom:=FFormIndividu.QueryIndividuNOM.AsString;
  sCP:=sDBECP.Text;

  sUrl:='http://www.orange.fr/bin/frame.cgi?u=http://local.search.ke.voila.fr/S/searchproxi%3Fnom%3D'+sNom+
    '%26pre%3D'+sPrenom+'%26loc%3D'+sCp+'%26profil%3D118712wdg%26bhv%3Dsearchpar%26rtype%3Dkw';

  gotoThisUrl(sUrl);
end;

function TFIndividuDomiciles.doSrcutetvAdr(const iNumLigne:integer; const Anode : PVirtualNode ):Boolean;
var
  SomeNode:PVirtualNode;
begin
  if  ( PAdrTree(tvAdr.GetNodeData(Anode)) <> nil )
  and ( PAdrTree(tvAdr.GetNodeData(Anode))^.cleAdr=iNumLigne ) then
  begin
    tvAdr.Selected[Anode]:=true;
    tvAdr.FocusedNode:=Anode;
    Result := True;
    Exit;
  end
  Else Result:=False;
  SomeNode:=Anode.FirstChild;
  while SomeNode <> nil do
    begin
      if doSrcutetvAdr ( iNumLigne, SomeNode ) Then
       Exit;
      SomeNode:=SomeNode.NextSibling;
    end;
end;

procedure TFIndividuDomiciles.doGoto(const iNumLigne:integer);
var
  i:integer;
begin
  doSrcutetvAdr(iNumLigne,tvAdr.RootNode);
end;
{
procedure TFIndividuDomiciles.edVilleKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
var
  s:string;
  k,l:integer;
begin
  if (Shift= [ssCtrl])and not FFormIndividu.DialogMode then
  begin
    if Key=ord('F') then
    begin
      Key:=VK_SHIFT;
      btnVillesFavorisClick(sender);
    end
    else if (Sender=edVille)and(Key=VK_SPACE) then
    begin
      s:=edVille.Text;
      k:=edVille.SelStart;
      s:=LeftStr(s,k);
      if dm.RemplaceRaccourcis(Key,Shift,s,k) then
      begin
        if not(IBQEve.State in [dsEdit,dsInsert]) then
          IBQEve.Edit;
        l:=IBQEveEV_IND_VILLE.Size;
        s:=LeftStr(s,l);
        k:=Min(k,l);
        IBQEveEV_IND_VILLE.AsString:=s;
        edVille.SelStart:=k;
        BloqueCar:=true;
      end;
    end;
  end;
end;
}
procedure TFIndividuDomiciles.pmImagePopup(Sender:TObject);
var
  iClef:integer;
  p:TPoint;
  SurPhoto:boolean;
begin
  if sender is TPopupMenu then
  begin
    PointSouris:=(sender as TPopupMenu).PopupPoint;
    p:=cxPhoto.ScreenToClient(PointSouris);
    SurPhoto:=(p.X>=0)and(p.Y>=0)and(p.X<=cxPhoto.Width)and(p.Y<=cxPhoto.Height);
  end
  else
    SurPhoto:=False;
  iClef:=IBMediasmp_media.AsInteger;
  mVisualiseActe.Visible:=iClef>0;
  mImprimeActe.Visible:=(iClef>0)and FichEstImage(IBMediasmulti_path.AsString);
  mAjouterDocument.Visible:=(FFormIndividu.DialogMode=false)and not IBQEve.IsEmpty;
  mEnleverDocument.Visible:=(FFormIndividu.DialogMode=false)and not IBMedias.IsEmpty;
  mRemplacerDocument.Visible:=mEnleverDocument.Visible;
  mMontrerRepere.Checked:=gci_context.MontrerRepere;
  with IBMedias do
    mSupprimerRepere.Visible:=Active and mEnleverDocument.Visible and(FieldByName('mp_position').AsInteger>0);
  mPoserRepere.Visible:=SurPhoto and mEnleverDocument.Visible;
end;

procedure TFIndividuDomiciles.SuperFormShow(Sender:TObject);
begin
  if tvadr.CanFocus then
    tvadr.SetFocus;
end;

procedure TFIndividuDomiciles.pmDatePopup(Sender:TObject);
var
  s,sq:string;
  NewItem:TMenuItem;
  i:integer;
  q:TIBSQL;
begin
  pmDate.Items.Clear;
  s:=trim(sDBMDate.Text);
  if s='' then
    sq:=' in(13,14,15,16,17,19,20,21)'
  else
  begin
    i:=Pos(' ',s);
    if i>0 then
    begin
      s:=fs_FormatText(Copy(s,1,i-1),mftUpper,True);
      if _MotsClesDate.Token_mots_maj[_TYPE_TOKEN_ENTRE].IndexOf(s)>-1 then
        sq:='=18'
      else if _MotsClesDate.Token_mots_maj[_TYPE_TOKEN_DU].IndexOf(s)>-1 then
        sq:='=14'
      else
        exit;
    end
    else
      exit;
  end;
  q:=TIBSQL.Create(Self);
  with q do
  try
    DataBase:=dm.ibd_BASE;
    SQL.Add('select token from ref_token_date'
      +' where langue='''+gci_context.Langue
      +''' and sous_type=''Y'' and type_token'
      +sq
      +' order by type_token');
    ExecQuery;
    i:=0;
    while not Eof do
    begin
      NewItem:=TMenuItem.Create(Self);
      NewItem.Caption:=FieldByName('TOKEN').AsString;
      pmDate.Items.Add(NewItem);
      pmDate.Items[i].OnClick:=up_SubMenu;
      next;
      inc(i);
    end;
    Close;
  finally
    Free;
  end;
end;

procedure TFIndividuDomiciles.up_SubMenu(Sender:TObject);
var
  sToken:string;
begin
  sToken:=(sender as TMenuItem).Caption;
  if not(IBQEve.State in [dsEdit,dsInsert]) then
    IBQEve.Edit;
  if trim(sDBMDate.text)='' then
    IBQEveEV_IND_DATE_WRITEN.AsString:=sToken+' '
  else
    IBQEveEV_IND_DATE_WRITEN.AsString:=trim(sDBMDate.text)+' '+sToken+' ';
  sDBMDate.SelStart:=Length(sDBMDate.text)+1
end;

procedure TFIndividuDomiciles.edVilleMouseEnter(Sender:TObject);
begin
  FMain.MsgBarreEtat(2);
end;

procedure TFIndividuDomiciles.btnInternetPopupMenuPopup(Sender:TObject;
  var APopupMenu:TPopupMenu;var AHandled:Boolean);
begin
  FMain.Lieu_Pays:=sDBEPays.Text;
  FMain.Lieu_Region:=sDBERegion.Text;
  FMain.Lieu_INSEE:=edINSEE.Text;
  FMain.Lieu_Departement:=edDept.Text;
  FMain.Lieu_Ville:=edVille.Text;
  FMain.Lieu_Latitude:=sdbLatitude.Text;
  FMain.Lieu_Longitude:=sdbLongitude.Text;
  FMain.Lieu_Subdivision:=edSubd.Text;
end;

procedure TFIndividuDomiciles.tvAdrBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  if tvAdr.Selected[Node] then
  begin
    TargetCanvas.Brush.Color:=gci_context.ColorMedium;
    TargetCanvas.Font.Color:=clWindowText;
  end;

end;

procedure TFIndividuDomiciles.tvAdrClick(Sender: TObject);
begin
  doChangeNode(sender);
end;

procedure TFIndividuDomiciles.tvAdrCustomDrawItem(Sender:TCustomTreeView;
  Node:TTreeNode;State:TCustomDrawState;var DefaultDraw:Boolean);
begin
  if node.Selected then
  begin
    Sender.Canvas.Brush.Color:=gci_context.ColorMedium;
    Sender.Canvas.Font.Color:=clWindowText;
  end;
end;


procedure TFIndividuDomiciles.pmAdressesPopup(Sender:TObject);
begin
  mAjouterAdresse.Visible:=bfsbAjoutAdresse.Visible and bfsbAjoutAdresse.Enabled;
  mSupprimerAdresse.Visible:=bfsbDeleteAdresse.Visible and bfsbDeleteAdresse.Enabled;
  mQuiHabite.Visible:=btnQuiHabite.Enabled;
end;

procedure TFIndividuDomiciles.edVilleExit(Sender:TObject);
begin
  FMain.CtrlFbloqued:=false;
end;

procedure TFIndividuDomiciles.edSubdEnter(Sender:TObject);
begin
  FMain.CtrlFbloqued:=true;
end;

procedure TFIndividuDomiciles.IBQEveNewRecord(DataSet:TDataSet);
begin
  IBQEveEV_IND_CLEF.AsInteger:=dm.uf_GetClefUnique('EVENEMENTS_IND');
  IBQEveEV_IND_KLE_FICHE.AsInteger:=FFormIndividu.CleFiche;
  IBQEveEV_IND_KLE_DOSSIER.AsInteger:=dm.NumDossier;
  FFormIndividu.doBouton(true);
end;

procedure TFIndividuDomiciles.edVilleKeyPress(Sender:TObject;
  var Key:Char);
begin
  if BloqueCar then
  begin
    BloqueCar:=false;
    Key:=#0;
  end;
end;

procedure TFIndividuDomiciles.PageControlChange(Sender:TObject);
var
  k:integer;
begin
  k:=PageControl.ActivePageIndex;
  btnDetail.Visible:=(k=_onglet_sources)
    and((FFormIndividu.DialogMode=false)or(IBQEveEV_IND_DETAILS.AsInteger=1))
    and not IBQEve.IsEmpty;
  bsfbAjout.Visible:=(k=_onglet_medias)and(FFormIndividu.DialogMode=false);
  bsfbRetirer.Visible:=bsfbAjout.Visible;
  bsfbAjout.Enabled:=not IBQEve.IsEmpty;
  bsfbRetirer.Enabled:=not IBMedias.IsEmpty;
  cxGridMedias.ShowHint:=not IBMedias.IsEmpty;

  with IBQEve do
   Begin
    if FieldByName('EV_IND_COMMENT').AsString>'' then
      PageControl.Pages[_onglet_notes].ImageIndex:=74
    else
      PageControl.Pages[_onglet_notes].ImageIndex:=66;
    if (FieldByName('EV_IND_DETAILS').AsInteger=1)
      or(FieldByName('EV_IND_SOURCE').AsString>'') then
      PageControl.Pages[_onglet_sources].ImageIndex:=74
    else
      PageControl.Pages[_onglet_sources].ImageIndex:=66;
   end;
  if not IBMedias.IsEmpty then
    PageControl.Pages[_onglet_medias].ImageIndex:=74
  else
    PageControl.Pages[_onglet_medias].ImageIndex:=66;
end;

procedure TFIndividuDomiciles.edCommentairesMouseEnter(Sender:TObject);
begin
  FMain.MsgBarreEtat(0,'Les raccourcis de saisie sont utilisables dans les champs Notes, Sources et Ville');
end;

procedure TFIndividuDomiciles.edCommentairesKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  if not FFormIndividu.DialogMode then
  begin
    s:=edCommentaires.Text;
    k:=edCommentaires.SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      if not(IBQEve.state in [dsEdit,dsInsert]) then
        IBQEve.Edit;
      IBQEveEV_IND_COMMENT.AsString:=s;
      edCommentaires.SelStart:=k;
      BloqueCar:=true;
    end;
  end;
end;

procedure TFIndividuDomiciles.edSourcesKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  if not FFormIndividu.DialogMode then
  begin
    s:=edSources.Text;
    k:=edSources.SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      if not(IBQEve.state in [dsEdit,dsInsert]) then
        IBQEve.Edit;
      IBQEveEV_IND_SOURCE.AsString:=s;
      edSources.SelStart:=k;
      BloqueCar:=true;
    end;
  end;
end;

procedure TFIndividuDomiciles.edCommentairesDblClick(Sender:TObject);
begin
  ExecuteChaineDansChaine(edCommentaires.Text,edCommentaires.SelStart,edCommentaires.SelLength);
end;

procedure TFIndividuDomiciles.edSourcesDblClick(Sender:TObject);
begin
  ExecuteChaineDansChaine(edSources.Text,edSources.SelStart,edSources.SelLength);
end;

procedure TFIndividuDomiciles.PageControlClick(Sender:TObject);
begin
  case PageControl.ActivePageIndex of
    _onglet_notes:SendFocus(edCommentaires);
    _onglet_sources:SendFocus(edSources);
    _onglet_medias:SendFocus(cxGridMedias);
  end;
end;

procedure TFIndividuDomiciles.PageControlDrawTabEx(
  AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  if TPageControl(AControl).ActivePageIndex=ATab.TabIndex then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
end;

procedure TFIndividuDomiciles.cxGridTableMediasEditKeyPress(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit;var Key:Char);
begin
  if BloqueCar then
  begin
    BloqueCar:=false;
    Key:=#0;
  end;
end;

procedure TFIndividuDomiciles.cxGridTableMediasCellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  mVisualiseActeClick(sender);
end;

procedure TFIndividuDomiciles.mVisualiseActeClick(Sender:TObject);
var
  iClef:integer;
begin
  if IBMedias.Active and not IBMedias.IsEmpty then
  begin
    iClef:=IBMediasmp_media.AsInteger;
    VisualiseMedia(iClef,dm.ReqSansCheck);
  end;
end;

procedure TFIndividuDomiciles.mImprimeActeClick(Sender:TObject);
var
  iClef:Integer;
begin
  iClef:=IBMediasmp_media.AsInteger;
  if iClef>0 then
    ImprimeImage(iClef,'')
  else
    MyMessageDlg(rs_Error_None_picture_for_this_document,mtError, [mbOK],FMain);
end;

procedure TFIndividuDomiciles.bsfbAjoutClick(Sender:TObject);
var
  i_clef:integer;
begin
  i_clef:=FMain.OuvreBiblioMedias(True,IBQEveEV_IND_CLEF.AsInteger,'I','A');
  if i_clef>0 then
  begin
    IBMedias.Close;
    IBMedias.Open;
    FFormIndividu.doBouton(true);
    PageControlChange(nil);
  end;
end;

procedure TFIndividuDomiciles.bsfbRetirerClick(Sender:TObject);
begin
  if bsfbRetirer.Enabled then//peut être activé directement par Ctrl+Suppr
    if MyMessageDlg(rs_Confirm_unlinking_this_actual_home_media,
      mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
    begin
      IBMedias.Delete;
      TFIndividu(fFormindividu).doBouton(true);
      PageControlChange(nil);
    end;
end;

procedure TFIndividuDomiciles.mRemplacerDocumentClick(Sender:TObject);
var
  q:TIBSQL;
  mp_clef,mp_media:integer;
begin
  mp_media:=FMain.OuvreBiblioMedias(True,0,'','');
  if mp_media>0 then
  begin
    mp_clef:=IBMediasmp_clef.AsInteger;
    if IBMedias.State in [dsInsert,dsEdit] then
      IBMedias.Post;
    IBMedias.Close;
    q:=TIBSQL.Create(self);
    try
      q.Database:=dm.ibd_BASE;
      q.Transaction:=dm.IBT_BASE;
      q.SQL.Add('update media_pointeurs set mp_media=:mp_media where mp_clef=:mp_clef');
      q.ParamByName('mp_media').AsInteger:=mp_media;
      q.ParamByName('mp_clef').AsInteger:=mp_clef;
      q.ExecQuery;
      q.Close;
    finally
      q.Free;
    end;
    IBMedias.Open;
    FFormIndividu.doBouton(true);
  end;
end;

procedure TFIndividuDomiciles.DSMediasStateChange(Sender:TObject);
begin
  if DSMedias.State in [dsEdit,dsInsert] then
    FFormIndividu.doBouton(true);
end;

procedure TFIndividuDomiciles.IBMediasAfterOpen(DataSet:TDataSet);
begin
  OpenMedia:=true;
end;

procedure TFIndividuDomiciles.IBMediasBeforeClose(DataSet:TDataSet);
begin
  OpenMedia:=false;
  if DataSet.State in [dsInsert,dsEdit] then
    DataSet.Post;
end;

procedure TFIndividuDomiciles.IBMediasAfterScroll(DataSet:TDataSet);
begin
  doChargePhoto;
end;

procedure TFIndividuDomiciles.doTestCoherence;
begin//mise à jour seulement de CoherenceDate créé à la sélection de l'individu
  FFormIndividu.CoherenceDate.AddInfoDateWriten(
    IBQEveEV_IND_DATE_WRITEN.AsString,
    'RESI',
    IBQEveEV_IND_CLEF.AsInteger,
    FFormIndividu.CoherenceDate.AutresEventInd );
  FFormIndividu.CoherenceDate.Test;
end;

procedure TFIndividuDomiciles.btnDetailClick(Sender:TObject);
var
  aFBiblio_Sources:TFBiblio_Sources;
  details:integer;
begin
  if dsAdresses.State in [dsEdit,dsInsert] then
    dsAdresses.DataSet.Post;
  PageControl.ActivePageIndex:=_onglet_sources;//1
  aFBiblio_Sources:=TFBiblio_Sources.create(self);
  try
    CentreLaFiche(aFBiblio_Sources,FMain);
    aFBiblio_Sources.FormIndividu:=fFormIndividu;
    aFBiblio_Sources.Caption:=rs_Caption_Sources_of_home_event;
    aFBiblio_Sources.doOpenQuerys(IBQEveEV_IND_CLEF.AsInteger,'I');
    if aFBiblio_Sources.ShowModal=mrOk then
    begin
      if dm.IBQSources_Record.State in [dsEdit,dsInsert] then
      begin
        dsAdresses.Edit;
        IBQEveEV_IND_SOURCE.asString:=aFBiblio_Sources.sText;
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
      FFormIndividu.doBouton(true);
      if not aFBiblio_Sources.IBMultimedia.IsEmpty
        or(length(aFBiblio_Sources.dxDBMemo2.Text)>0)
        or(length(aFBiblio_Sources.dxDBMemo3.Text)>0)
        or(length(aFBiblio_Sources.dxDBMemo4.Text)>0)
        or(length(aFBiblio_Sources.dxDBMemo5.Text)>0)
        or(length(aFBiblio_Sources.dxDBEdit3.Text)>0) then
        details:=1
      else
        details:=0;
      if IBQEveEV_IND_DETAILS.AsInteger<>details then
      begin
        dsAdresses.Edit;
        IBQEveEV_IND_DETAILS.AsInteger:=details;
        PageControlChange(nil);
      end;
    end;
  finally
    FreeAndNil(aFBiblio_Sources);
  end;
end;

procedure TFIndividuDomiciles.DatasetBeforeScrollOrClose(DataSet:TDataSet);
begin
  if DataSet.State in [dsInsert,dsEdit] then
    DataSet.Post;
end;

procedure TFIndividuDomiciles.mMontrerRepereClick(Sender:TObject);
begin
  gci_context.MontrerRepere:=not gci_context.MontrerRepere;
  if gci_context.MontrerRepere then
    MontrerRepere
  else
    lPoint.Visible:=false;
  gci_context.ShouldSave:=true;
end;

procedure TFIndividuDomiciles.MontrerRepere;
var
  x,y,z:integer;
  r,l,h:single;
begin
  with IBMedias do
  if Active and (FieldByName('MP_POSITION').AsInteger>0)and(cxPhoto.Picture.Height>0)and(cxPhoto.Picture.Width>0) then
  begin
    IntenXYZ(FieldByName('MP_POSITION').AsInteger,x,y,z);
    l:=cxPhoto.Picture.Width;
    h:=cxPhoto.Picture.Height;
    if (l>cxPhoto.Width)or(h>cxPhoto.Height) then
    begin
      r:=min(cxPhoto.Width/l,cxPhoto.Height/h);
      l:=l*r;
      h:=h*r;
    end;
    lPoint.Left:=round(x*l/$FFF+(cxPhoto.Width-l)/2-lPoint.Width/2)+cxPhoto.Left;
    lPoint.Top:=round(y*h/$FFF+(cxPhoto.Height-h)/2-lPoint.Height/2)+cxPhoto.Top;
    lPoint.Visible:=true;
  end
  else
  begin
    lPoint.Visible:=false
  end;
end;

procedure TFIndividuDomiciles.SetModeUpdate(ModeUpdate:TModeUpdate);//AL
begin
  if IBMedias.State in [dsInsert,dsEdit] then
    IBMedias.Post;
  IBUMedias.ModifySQL.Clear;
  case ModeUpdate of
    ModeMedia:
      IBUMedias.ModifySQL.Add('update multimedia set multi_memo=:multi_memo where multi_clef=:mp_media');
    ModePointeur:
      IBUMedias.ModifySQL.Add('update media_pointeurs'
        +' set mp_position=:mp_position where mp_clef=:mp_clef');
  end;
end;

procedure TFIndividuDomiciles.mSupprimerRepereClick(Sender:TObject);
begin
  SetModeUpdate(ModePointeur);
  with IBMedias do
  try
    Edit;
    FieldByName('MP_POSITION').AsInteger:=0;
  finally
    SetModeUpdate(ModeMedia);//fait le post
  end;
  lPoint.Visible:=false;
end;

procedure TFIndividuDomiciles.mPoserRepereClick(Sender:TObject);
var
  p:TPoint;
  r,l,h,x,y:single;
begin
  if (cxPhoto.Picture.Height>0)and(cxPhoto.Picture.Width>0) then
  begin
    p:=cxPhoto.ScreenToClient(PointSouris);
    l:=cxPhoto.Picture.Width;
    h:=cxPhoto.Picture.Height;
    if (l>cxPhoto.Width)or(h>cxPhoto.Height) then
    begin
      r:=min(cxPhoto.Width/l,cxPhoto.Height/h);
      l:=l*r;
      h:=h*r;
    end;
    x:=p.X-(cxPhoto.Width-l)/2;
    y:=p.Y-(cxPhoto.Height-h)/2;
    x:=max(0,x);
    y:=max(0,y);
    x:=min(x,l);
    y:=min(y,h);
    SetModeUpdate(ModePointeur);
    with IBMedias do
    try
      Edit;
      FieldByName('MP_POSITION').AsInteger:=XYZenINT(round(x*$FFF/l),round(y*$FFF/h),0);
    finally
      SetModeUpdate(ModeMedia);//fait le post
    end;
    MontrerRepere;
  end;
end;

procedure TFIndividuDomiciles.Panel3Resize(Sender:TObject);
begin
  if gci_context.MontrerRepere
    then MontrerRepere
    else lPoint.Visible:=false;
end;

procedure TFIndividuDomiciles.mEffacerlelieuClick(Sender: TObject);
begin
  if not(ibqEve.State in [dsEdit,dsInsert]) then
    ibqEve.Edit;
  ibqEveEV_IND_CP.Clear;
  ibqEveEV_IND_VILLE.Clear;
  ibqEveEV_IND_PAYS.Clear;
  ibqEveEV_IND_DEPT.Clear;
  IBQEveEV_IND_REGION.Clear;
  IBQEveEV_IND_INSEE.Clear;
  IBQEveEV_IND_LATITUDE.Clear;
  IBQEveEV_IND_LONGITUDE.Clear;
  IBQEveEV_IND_SUBD.Clear;
end;

procedure TFIndividuDomiciles.sdbWWWExit(Sender: TObject);
begin
  if GetKeyState(VK_TAB)<0 then
  begin
    PageControl.ActivePage:=OngletNotes;
    SendFocus(edCommentaires);
  end;
end;

procedure TFIndividuDomiciles.PageControlEnter(Sender: TObject);
begin
  bPageControl:=true;
end;

procedure TFIndividuDomiciles.PageControlExit(Sender: TObject);
begin
  bPageControl:=false;
end;

procedure TFIndividuDomiciles.tvAdrGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex:=PADRTree(Sender.GetNodeData(Node))^.ImageIdx;
end;

procedure TFIndividuDomiciles.tvAdrGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  CellText:=PADRTree ( Sender.GetNodeData(Node))^.Libelle;
end;

procedure TFIndividuDomiciles.tvAdrInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  with PADRTree ( Sender.GetNodeData(Node))^ do
   Begin
     cleAdr  :=Adresse.cleAdr;
     ImageIdx:=Adresse.ImageIdx;
     Libelle :=Adresse.Libelle;
   end;
end;

procedure TFIndividuDomiciles.sdbLatitudePropertiesValidate(
  Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
  var Error: Boolean);
begin
  if not BcdIsValide(DisplayValue)then
  begin
    MyMessageDlg(rs_Error_value_or_format_error,mtError, [mbOk],FMain);
    (Sender as TMaskEdit).SetFocus;
    Abort;
  end;
end;
procedure TFIndividuDomiciles.p_AfterDownloadCoord;
begin
 if not(IBQEve.State in [dsEdit,dsInsert]) then
    IBQEve.Edit;
  if dm.UneSubd>'' then
    IBQEveEV_IND_SUBD.asString:=dm.UneSubd;
  IBQEveEV_IND_LATITUDE.asString:=dm.UneLatitude;
  IBQEveEV_IND_LONGITUDE.asString:=dm.UneLongitude;
end;

procedure TFIndividuDomiciles.colMemoPropertiesEditValueChanged(
  Sender: TObject);
begin
  if (DSMedias.State=dsEdit) and ((Sender as TExtDBGrid).Columns [ 1 ].Field.IsNull) then
    IBMedias.Post;
end;
procedure TFIndividuDomiciles.mAcquerirClick(Sender: TObject);
begin
  dm.UneLatitude:=sdbLatitude.Text;
  dm.UneLongitude:=sdbLongitude.Text;
  dm.UneSubd:=edSubd.Text;
  DoCoordNext:=TProcedureOfObject(p_AfterDownloadCoord);
  dm.GetCoordonneesInternet(edVille.Text,edDept.Text,sDBERegion.Text,sDBEPays.Text,FMain);
end;

procedure TFIndividuDomiciles.pmGooglePopup(Sender: TObject);
begin
  FMain.MsgBarreEtat(0,mAcquerir.Hint);
end;

procedure TFIndividuDomiciles.EffaceBarreEtat(Sender: TObject);
begin
  FMain.MsgBarreEtat(0);
end;

procedure TFIndividuDomiciles.InfoCopie(Sender: TObject);
begin
  FMain.MsgBarreEtat(0,'Ctrl+G demande les coordonnées sur Google Maps.');
end;
end.

