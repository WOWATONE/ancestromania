unit u_form_Actes_Liste;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{forme refaite par AL 2010}
interface

uses
{$IFNDEF FPC}
  jpeg, CommCtrl, Windows,
  ExtJvXPCheckCtrls,
{$ELSE}
  ExtJvXPCheckCtrls,
{$ENDIF}
  U_FormAdapt, StdCtrls,
  ExtCtrls,Controls,Classes,Graphics,ComCtrls,
  Menus,VirtualTrees,IBSQL,
  u_reports_components,
  u_buttons_appli, U_OnFormInfoIni, u_framework_components, PrintersDlgs;

type
  TActe=record
    ActText,
    TypeTable:string;
    cleImage,
    ImageIndex,
    cleEvent,
    TypeActe:integer;
  end;
  PActe=^TActe;

  { TFActesListe }
  TFActesListe=class(TF_FormAdapt)
    cb_PaperSize: TComboBox;
    ch_portrait: TJvXPCheckbox;
    ch_pdf: TJvXPCheckbox;
    Label3: TLabel;
    OnFormInfoIni1: TOnFormInfoIni;
    Panel3:TPanel;
    Panel1:TPanel;
    dxComponentPrinter1:TPrinterSetupDialog;
    btnPrint:TFWPrintVTree;
    lNom:TLabel;
    Label8:TLabel;
    pmActes:TPopupMenu;
    mOuvreDocument:TMenuItem;
    sp_Fonte: TFWSpinEdit;
    tvActe:TVirtualStringTree;
    Visualiser1:TMenuItem;
    ibActes:TIBSQL;
    BtnFermer:TFWClose;
    procedure btnPrintClick(Sender:TObject);
    procedure mOuvreDocumentClick(Sender:TObject);
    procedure tvActeBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure tvActeContextPopup(Sender:TObject;MousePos:TPoint;
      var Handled:Boolean);
    procedure tvActeDragDrop(Sender,Source:TObject;X,Y:Integer);
    procedure tvActeDragOver(Sender,Source:TObject;X,Y:Integer;
      State:TDragState;var Accept:Boolean);
    procedure pmActesPopup(Sender:TObject);
    procedure tvActeCustomDrawItem(Sender:TCustomTreeView;
      Node:TTreeNode;State:TCustomDrawState;var DefaultDraw:Boolean);
    procedure tvActeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure tvActeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure tvActeInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure Visualiser1Click(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure tvActeMouseDown(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure BtnFermerClick(Sender:TObject);
    procedure tvActeMouseMove(Sender:TObject;Shift:TShiftState;X,
      Y:Integer);

  private
    { Déclarations privées }
    iClePhoto:integer;
    fCanDeletionTV:boolean;
    sTitre:array[-3..1] of string;
    ModeDialog:boolean;
    unActe : TActe;
  public
    { Déclarations publiques }
    bModified:boolean;

    function doOpenQuerys:boolean;
    procedure doInit(iClef:integer;sNom:string;sexe:integer);

  end;

implementation

uses u_common_functions,u_common_ancestro,
     u_Common_const,u_Dm,
     u_common_ancestro_functions,
     fonctions_string,
     u_genealogy_context,
     fonctions_reports,
     u_form_individu;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}
var    fFormIndividu:TFIndividu;

procedure TFActesListe.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  tvActe .NodeDataSize := Sizeof(TActe)+1;
  fCanDeletionTV:=false;
  sTitre[-3]:='Acte(s) à ignorer';
  sTitre[-2]:='Acte(s) à chercher';
  sTitre[-1]:='Acte(s) demandé(s)';
  sTitre[0]:='Acte(s) absent(s)';
  sTitre[1]:='Acte(s) trouvé(s)';
  ModeDialog:=true;
  tvActe.Hint:=rs_Hint_Modifying_Act_s_type_with_drag_drop;
  align:=AlClient;
  fFormIndividu:=TFIndividu(Owner);
  lNom.PopupMenu:=FFormIndividu.pmNom;
  lNom.OnMouseEnter:=FFormIndividu.lNomMouseEnter;
  lNom.OnMouseLeave:=FFormIndividu.lNomMouseLeave;
  lNom.OnMouseMove:=FFormIndividu.lNomMouseMove;
  lNom.OnClick:=FFormIndividu.lNomClick;
  lNom.Cursor:=5;
end;

procedure TFActesListe.SuperFormShowFirstTime(Sender:TObject);
begin
  fCanDeletionTV:=true;
end;

function TFActesListe.doOpenQuerys:boolean;
begin
  ModeDialog:=FFormIndividu.DialogMode;
  tvActe.ShowHint:=not ModeDialog;
  with FFormIndividu do
     doInit(CleFiche,coupechaine(NomIndiComplet,lNom)
     ,QueryIndividu.FieldByName('SEXE').AsInteger);
  result:=True;
end;

procedure TFActesListe.doInit(iClef:integer;sNom:string;sexe:integer);
var
  NoeudAjoute,NoeudConjoint:PVirtualNode;
  NoeudParent:array[-3..1] of PVirtualNode;
  sChaine:string;

  procedure CreeunActe;
  begin
    with unActe do
     Begin
       ActText := sChaine;
       cleImage:=0;
       cleEvent:=0;
       TypeActe:=0;
       TypeTable:='';
     end;
  end;

  procedure AjouteNoeudParent(index:integer);
  begin
    sChaine:=sTitre[index];
    CreeunActe;
    unActe.TypeActe:=index;
    with unActe do
      case index of
        -3:ImageIndex:=19;
        -2:ImageIndex:=10;
        -1:ImageIndex:=4;
        1:ImageIndex:=2;
        else
          ImageIndex:=18;
      end;

    NoeudParent[index]:=tvActe.AddChild(nil,@unActe);
    tvActe.ValidateNode(NoeudParent[index],False);

//      SelectedIndex:=NoeudParent[index].ImageIndex;
  end;
begin
  with tvActe do
   Begin
    DisableAlign;
    bModified:=false;
    Clear;
    case sexe of
      1:lNom.Font.Color:=gci_context.ColorHomme;
      2:lNom.Font.Color:=gci_context.ColorFemme;
      else
        lNom.Font.Color:=clWindowText;
    end;
    NodeDataSize := Sizeof(TActe)+1;
    lNom.Caption:=sNom;
    ibActes.Close;
    ibActes.ParamByName('i_indi').AsInteger:=iClef;
    ibActes.ExecQuery;
    AjouteNoeudParent(1);
    AjouteNoeudParent(-3);
    AjouteNoeudParent(-1);
    AjouteNoeudParent(-2);
    AjouteNoeudParent(0);

    while not ibActes.Eof do
    with ibActes do
      begin
        sChaine:=FieldByName('TITRE_EVENT').AsString;
        if Length(FieldByName('DESCRIPTION_EVENT').AsString)>0 then
          sChaine:=sChaine+' - '+FieldByName('DESCRIPTION_EVENT').AsString;
        if Length(FieldByName('DATE_WRITEN_EVENT').AsString)>0 then
          sChaine:=sChaine+' - '+FieldByName('DATE_WRITEN_EVENT').AsString;
        if Length(FieldByName('CP_EVENT').AsString)>0 then
          sChaine:=sChaine+' - '+FieldByName('CP_EVENT').AsString;
        if Length(FieldByName('VILLE_EVENT').AsString)>0 then
          sChaine:=sChaine+' - '+FieldByName('VILLE_EVENT').AsString;

        CreeunActe;

        with unActe do
         Begin
          cleEvent:=FieldByName('CLEF_EVENT').AsInteger;
          TypeTable:=FieldByName('TYPE_TABLE').AsString;
          cleImage:=FieldByName('MEDIA_EVENT').AsInteger;
          TypeActe:=FieldByName('ACTE_EVENT').AsInteger;
           if cleImage>0 then
             ImageIndex:=17
           else
             ImageIndex:=FieldByName('CAT_EVENT').AsInteger;
           with NoeudAjoute^ do
            Begin
       //      SelectedIndex:=ImageIndex;
            end;
         end;

        NoeudAjoute:=AddChild(NoeudParent[unActe.TypeActe],@unActe);
        ValidateNode(NoeudParent[unActe.TypeActe],False);

        if not FieldByName('NOM_CONJOINT').IsNull then
        begin
          sChaine:=FieldByName('NOM_CONJOINT').AsString;
          if Length(FieldByName('PRENOM_CONJOINT').AsString)>0 then
            sChaine:=sChaine+', '+FieldByName('PRENOM_CONJOINT').AsString;

          if FieldByName('SEXE_CONJOINT').AsInteger=2 then
          begin
            if length(FieldByName('NAISSANCE_CONJOINT').AsString)>0 then
              sChaine:=sChaine+' née '+FieldByName('NAISSANCE_CONJOINT').AsString;
            if length(FieldByName('DECES_CONJOINT').AsString)>0 then
              sChaine:=sChaine+' décédée '+FieldByName('DECES_CONJOINT').AsString;
          end
          else
          begin
            if length(FieldByName('NAISSANCE_CONJOINT').AsString)>0 then
              sChaine:=sChaine+' né '+FieldByName('NAISSANCE_CONJOINT').AsString;
            if length(FieldByName('DECES_CONJOINT').AsString)>0 then
              sChaine:=sChaine+' décédé '+FieldByName('DECES_CONJOINT').AsString;
          end;
          CreeunActe;
          with unActe do
           Begin
            TypeActe:=FieldByName('ACTE_EVENT').AsInteger;
            if FieldByName('SEXE_CONJOINT').AsInteger=2 then
              ImageIndex:=16
            else
              ImageIndex:=15;
           end;
          NoeudConjoint:=AddChild(NoeudAjoute,@unActe);
          ValidateNode(NoeudAjoute,False);

    //      NoeudConjoint.SelectedIndex:=NoeudConjoint.ImageIndex;
        end;
        Next
      end;
    ibActes.Close;
    FullExpand;
    EnableAlign;
    FocusedNode :=RootNode.FirstChild;
    VisiblePath[RootNode.FirstChild]:=true;
   end;
end;

procedure TFActesListe.btnPrintClick(Sender:TObject);
begin
// Matthieu
  ExtColumnFont.Size:=sp_Fonte.Value;
  p_SetBtnPrint ( btnPrint, fs_RemplaceMsg(rs_List_of_acts_by_type_of,[lNom.Caption]),cb_PaperSize.Text,ch_portrait.Checked, Integer(ch_pdf.Checked), fPathBaseMedias);
end;

procedure TFActesListe.pmActesPopup(Sender:TObject);
begin
  iClePhoto:=PActe(tvActe.GetNodeData(tvActe.FocusedNode))^.cleImage;
  mOuvreDocument.Enabled:=iClePhoto>0;
  Visualiser1.Enabled:=iClePhoto>0;
end;

procedure TFActesListe.mOuvreDocumentClick(Sender:TObject);
begin
  if iClePhoto>0 then
    ImprimeImage(iClePhoto,lNom.Caption);
end;

procedure TFActesListe.tvActeBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  with Sender,Font do
  begin
    if Node^.Parent = nil then
    begin
      case PActe(GetNodeData(Node))^.TypeActe of
        -3:
          begin
            Color:=clGreen;
            Style:= [fsBold];
          end;
        -2:
          begin
            Color:=clRed;
            Style:= [fsBold];
          end;
        -1:
          begin
            Color:=clFuchsia;
            Style:= [fsBold];
          end;
        1:
          begin
            Color:=clGreen;
            Style:= [fsBold];
          end;
        else
          begin
            Color:=clGrayText;
            Style:= [fsBold];
          end;
      end;
    end
    else
    begin
      Color:=clWindowText;
      Style:= [];
    end;
    if Selected[Node] then
      Sender.Color:=gci_context.ColorMedium;
  end;
end;

procedure TFActesListe.tvActeContextPopup(Sender:TObject;
  MousePos:TPoint;var Handled:Boolean);
begin
  with tvActe,FocusedNode^ do
  if ( Parent <> nil ) and ( Parent^.Parent = RootNode ) then
    PopupMenu:=pmActes
  else
    PopupMenu:=nil;
end;

procedure TFActesListe.tvActeMouseMove(Sender:TObject;Shift:TShiftState;
  X,Y:Integer);
var
  Noeud:PVirtualNode;
begin
  with tvActe do
   Begin
    Noeud:=GetNodeAt(X,Y);
    if (Noeud<>nil) and (Noeud^.Parent<>nil) and (Noeud^.Parent^.Parent=RootNode) then
    begin
      pmActes.AutoPopup:=true;
      Cursor:=_CURPOPUP;
    end
    else
    begin
      pmActes.AutoPopup:=false;
      Cursor:=crDefault;
    end;
    if ModeDialog then
      DragMode:=dmManual
    else
      if (Noeud<>nil) and (Noeud^.Parent<>nil) and (Noeud^.Parent^.Parent=RootNode) then
        DragMode:=dmAutomatic
      else
        DragMode:=dmManual;
   end;
end;

procedure TFActesListe.tvActeDragOver(Sender,Source:TObject;X,
  Y:Integer;State:TDragState;var Accept:Boolean);
var
  NoeudSurvole,NoeudDrag:PVirtualNode;
begin
  with tvActe do
  try
    NoeudDrag:=FocusedNode;
    NoeudSurvole:=GetNodeAt(X,Y);
    Accept:=(NoeudSurvole<>nil) and (NoeudDrag^.Parent<>nil) and (NoeudDrag^.Parent.Parent=nil)
      and(PActe(GetNodeData(NoeudSurvole))^.TypeActe<>PActe(GetNodeData(NoeudDrag))^.TypeActe);
  except
    Accept:=false;
  end;
end;

procedure TFActesListe.tvActeDragDrop(Sender,Source:TObject;X,
  Y:Integer);
var
  NoeudSurvole,NoeudDrag:PVirtualNode;
  q:TIBSQL;
begin
  with tvActe do
   Begin
    NoeudDrag:=FocusedNode;
    NoeudSurvole:=GetNodeAt(X,Y);
    if (NoeudSurvole=nil)
      or (NoeudDrag=nil)
      or ((NoeudDrag^.Parent=nil) or ((NoeudDrag^.Parent<>RootNode) and (NoeudDrag^.Parent^.Parent=RootNode)))
      or (PActe(GetNodeData(NoeudSurvole))^.TypeActe=PActe(GetNodeData(NoeudDrag))^.TypeActe) then
      exit;
    while NoeudSurvole^.Parent <> nil do
      NoeudSurvole:=NoeudSurvole^.Parent;
    MoveTo(NoeudDrag,NoeudSurvole,amAddChildLast,True);
    PActe(GetNodeData(NoeudDrag))^.TypeActe:=PActe(GetNodeData(NoeudSurvole))^.TypeActe;
    Expanded[NoeudDrag]:=true;
    q:=TIBSQL.Create(self);
    with q do
    try
      Database:=dm.ibd_BASE;
      Transaction:=dm.IBT_BASE;
      if PActe(GetNodeData(NoeudDrag))^.TypeTable='I' then
        SQL.Text:='update evenements_ind set ev_ind_acte=:TypeActe where ev_ind_clef=:CleEve'
      else
        SQL.Text:='update evenements_fam set ev_fam_acte=:TypeActe where ev_fam_clef=:CleEve';
      ParamByName('TypeActe').AsInteger:=PActe(GetNodeData(NoeudSurvole))^.TypeActe;
      ParamByName('CleEve').AsInteger:=PActe(GetNodeData(NoeudDrag))^.cleEvent;
      ExecQuery;
    finally
      Free;
    end;
    if fFormIndividu<>nil then
    with FFormIndividu do
    begin
      Modified:=true;
      DoRefreshControls;
    end;
   end;
  bModified:=True;
end;

procedure TFActesListe.tvActeCustomDrawItem(Sender:TCustomTreeView;
  Node:TTreeNode;State:TCustomDrawState;var DefaultDraw:Boolean);
begin
end;

procedure TFActesListe.tvActeGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex:=PActe(Sender.GetNodeData(Node))^.ImageIndex;
end;

procedure TFActesListe.tvActeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  CellText:=PActe(Sender.GetNodeData(Node))^.ActText;
end;

procedure TFActesListe.tvActeInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  with PActe(Sender.GetNodeData(Node))^ do
   Begin
    ActText    :=unActe.ActText;
    cleEvent   :=unActe.cleEvent;
    cleImage   :=unActe.cleImage;
    ImageIndex :=unActe.ImageIndex;
    TypeActe   :=unActe.TypeActe;
    TypeTable  :=unActe.TypeTable;
   end;
end;

procedure TFActesListe.Visualiser1Click(Sender:TObject);
begin
  if iClePhoto>0 then
    VisualiseMedia(iClePhoto,dm.ReqSansCheck);
end;

procedure TFActesListe.tvActeMouseDown(Sender:TObject;
  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
var
  Noeud:PVirtualNode;
begin
  Noeud:=tvActe.GetNodeAt(X,Y);
  if Noeud<>nil then
    tvActe.Selected[Noeud]:=ssShift in Shift;
end;

procedure TFActesListe.BtnFermerClick(Sender:TObject);
begin
  close;
end;

end.
