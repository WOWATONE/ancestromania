{-----------------------------------------------------------------------}
{           Auteurs :André Langlet    le 13/12/2008                     }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_form_tv_ascendance;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf,
  U_FormAdapt,Forms,
  VirtualTrees,ExtCtrls,StdCtrls,u_buttons_appli,
  ExtJvXPButtons, ExtJvXPCheckCtrls,Dialogs,
  Controls,IBQuery,Menus,Classes,SysUtils,
  PrintersDlgs, u_ancestropictimages,
  u_reports_components,
  u_framework_components, U_OnFormInfoIni, u_common_tree, Graphics;

type

  { TFtvAscendance }

  TFtvAscendance=class(TF_FormAdapt)
    btFermeFiche: TFWClose;
    btFermer: TJvXPButton;
    btnPrint: TFWPrintVTree;
    btnReconstruire: TFWRefresh;
    btOuvrir: TJvXPButton;
    cb_PaperSize: TComboBox;
    ch_portrait: TJvXPCheckbox;
    cxSpinNiveaux: TFWSpinEdit;
    fpBoutons: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    pmArbre:TPopupMenu;
    OpenFiche:TMenuItem;
    IBQ_SQL:TIBQuery;
    N2:TMenuItem;
    mExport:TMenuItem;
    SaveDialog1:TSaveDialog;
    sp_Fonte: TFWSpinEdit;
    TreeView1:TVirtualStringTree;
    dxComponentPrinter1:TPrinterSetupDialog;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    Panel3:TPanel;
    Image1:TIATitle;
    Label1:TLabel;
    Panel1:TPanel;
    Imprimer1:TMenuItem;
    Datescompletes:TMenuItem;
    Avecvilles:TMenuItem;
    AvecSOSA:TMenuItem;
    Avecmariages:TMenuItem;
    mGeneRelative: TMenuItem;
    N1: TMenuItem;
    mIdentImplexes: TMenuItem;
    GenerationetSosarelatifs: TMenuItem;
    N3: TMenuItem;
    NbrAscendants: TMenuItem;
    Panel2: TPanel;
    procedure SuperFormCreate(Sender:TObject);
    procedure btnReconstruireClick(Sender:TObject);
    procedure mExportClick(Sender:TObject);
    procedure OpenFicheClick(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure btOuvrirClick(Sender:TObject);
    procedure btFermerClick(Sender:TObject);
    procedure pmArbrePopup(Sender:TObject);
    procedure TreeView1Collapsing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var Allowed: Boolean);
    procedure TreeView1DblClick(Sender:TObject);
    procedure ImprimerClick(Sender:TObject);
    procedure DatescompletesClick(Sender:TObject);
    procedure AvecvillesClick(Sender:TObject);
    procedure AvecSOSAClick(Sender:TObject);
    procedure cxSpinNiveauxPropertiesChange(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure AvecmariagesClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure mIdentImplexesClick(Sender: TObject);
    procedure TreeView1Expanding(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var Allowed: Boolean);
    procedure TreeView1GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TreeView1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure TreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TreeView1PaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);

  private
    fCleIndiDepart,fCleIndi,
    NoeudSelecte,
    OrdreImplexe,OrdreImplexeSelecte,Xmouse:integer;
    bBloque:boolean;
    procedure TreeAncetres(const cleAnc:Integer);

  public
    procedure Init_Arbre;
  end;

implementation

uses u_dm,u_genealogy_context,u_common_const,u_Form_Main,
     u_common_functions,u_common_ancestro,
     fonctions_string,
     fonctions_vtree,
     fonctions_init,
     fonctions_reports;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}


procedure TFtvAscendance.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  TreeView1.NodeDataSize := Sizeof(TIndivTree)+1;
  pGeneral.Color:=gci_context.ColorLight;
  fCleIndiDepart:=-1;
  TreeView1.Hint:=rs_Hint_Right_clic_for_Options_Double_clic_to_open;
  Position:=poScreenCenter;
  bBloque:=true;
  TreeView1.Images := dm.ImgCouple;
  p_ReadReportsViewFromIni(f_GetMemIniFile);
end;

procedure TFtvAscendance.Init_Arbre;
begin
  fCleIndiDepart:=dm.individu_clef;
  if WindowState<>wsNormal then
    WindowState:=wsNormal;
  if cxSpinNiveaux.Value>20 then
    cxSpinNiveaux.Value:=20;
  TreeAncetres(fCleIndiDepart);
end;

procedure TFtvAscendance.TreeAncetres(const cleAnc:Integer);
var
  i,NiveauMax,acounter:Integer;
  sTemp:string;
  unIndiv:PIndivTree;
  NoeudAjoute,
  indiParent:PVirtualNode;

  procedure p_FindNodeWithOrder ( const ATree : TBaseVirtualTree; const ANode : PVirtualNode; const aindex : Integer ; var FoundNode : PVirtualNode );
  var AData : PIndivTree;
  Begin
    with ATree,ANode^ do
     Begin
      if ANode <> RootNode Then
        Begin
         AData:=GetNodeData(ANode);
         if aindex = acounter Then
           FoundNode:=ANode;
         inc ( acounter );
        end;
      if FoundNode   <> nil Then Exit;
      if FirstChild  <> nil Then p_FindNodeWithOrder(ATree,FirstChild, aindex,FoundNode);
      if (NextSibling <> nil)
      and ( ANode <> RootNode )
       Then p_FindNodeWithOrder(ATree,NextSibling, aindex,FoundNode);
     end;
  End;
begin
  Screen.Cursor:=crHourglass;
  TreeView1.Visible:=false;
  label1.Caption:=fs_RemplaceMsg(rs_Ancestry_of,[_CRLF+FMain.NomIndi]);
  if length(FMain.PrenomIndi)>0 then
    label1.Caption:=label1.Caption+' '+FMain.PrenomIndi;
  Application.ProcessMessages;
  btnReconstruire.Enabled:=false;
  mIdentImplexes.Checked:=false;
  NiveauMax:=cxSpinNiveaux.Value;

  TreeView1.Clear;
  i:=-1;//initialisation compteur d'ascendants
  with IBQ_SQL do
  begin
    close;
    SQL.Clear;
    SQL.Add('select t.indi'
      +',i.nom'
      +',i.prenom'
      +',i.sexe'
      +',i.num_sosa'
      +',t.enfant'
      +',t.ordre'
      +',t.sosa'
      +',t.implexe'
      +',t.niveau');
    if Datescompletes.Checked then
    begin
      SQL.Add(',i.date_naissance'
        +',i.date_deces');
      if Avecmariages.Checked then
        SQL.Add(',(select first(1) ev_fam_date_writen from evenements_fam'
          +' where ev_fam_kle_famille=u.union_clef and ev_fam_type=''MARR'''
          +' order by ev_fam_datecode) as date_marr');
    end
    else
    begin
      SQL.Add(',cast(i.annee_naissance as varchar(6)) as date_naissance'
        +',cast(i.annee_deces as varchar(6)) as date_deces');
      if Avecmariages.Checked then
        SQL.Add(',(select first(1) cast(ev_fam_date_year as varchar(6)) from evenements_fam'
          +' where ev_fam_kle_famille=u.union_clef and ev_fam_type=''MARR'''
          +' order by ev_fam_datecode) as date_marr');
    end;
    if Avecvilles.Checked then
    begin
      SQL.Add(',n.ev_ind_ville as VILLE_NAISSANCE'
        +',d.ev_ind_ville as VILLE_DECES');
      if Avecmariages.Checked then
        SQL.Add(',(select first(1) ev_fam_ville from evenements_fam'
          +' where ev_fam_kle_famille=u.union_clef and ev_fam_type=''MARR'''
          +' order by ev_fam_datecode,ev_fam_heure) as ville_marr');
    end;
    SQL.Add('from (select * from proc_ascend_ordonnee(:indi,:max_niveau,:mode_implexe)) t'
      +' inner join individu i on i.cle_fiche=t.indi');
    if Avecvilles.Checked then
    begin
      SQL.Add('left join evenements_ind n on n.ev_ind_kle_fiche=i.cle_fiche and n.ev_ind_type=''BIRT'''
        +' left join evenements_ind d on d.ev_ind_kle_fiche=i.cle_fiche and d.ev_ind_type=''DEAT''');
    end;
    if Avecmariages.Checked then
      SQL.Add('left join t_union u on t.conjoint>0'
        +' and ((t.sexe=1 and u.union_mari=t.indi and u.union_femme=t.conjoint)'
        +' or (t.sexe=2 and u.union_mari=t.conjoint and u.union_femme=t.indi))');

    ParamByName('indi').AsInteger:=cleAnc;
    ParamByName('max_niveau').AsInteger:=NiveauMax;
    ParamByName('mode_implexe').AsInteger:=1;

    open;
    while not Eof do
    begin
      with TreeView1 do
      begin
        if FieldByName('enfant').IsNull then
          NoeudAjoute := AddChild(nil,nil)
        else
          Begin
            indiParent := nil;
            acounter:=0;
            p_FindNodeWithOrder ( TreeView1, RootNode, FieldByName('enfant').AsInteger, indiParent );
            NoeudAjoute := AddChild(indiParent,nil)
          end;
        ValidateNode ( NoeudAjoute, False );
        unIndiv := PIndivTree ( GetNodeData(NoeudAjoute));

        with unIndiv^ do
         Begin
          cle:=FieldByName('indi').AsInteger;
          Sosa:=FieldByName('sosa').AsInteger;
          Niveau:=FieldByName('niveau').AsInteger;
          Enfants:=FieldByName('enfant').AsInteger;
          Implexe:=FieldByName('implexe').AsInteger;
          Ordre:=FieldByName('ordre').AsInteger;
          sexe := FieldByName('SEXE').AsInteger;
          if FieldByName('implexe').IsNull then
            inc(i);
          libelle:='';
          if Avecmariages.Checked then
          begin
            if Avecvilles.Checked then
              sTemp:=FaitDateVille(FieldByName('date_marr').AsString,FieldByName('ville_marr').AsString)
            else
              sTemp:=FieldByName('date_marr').AsString;
            if length(sTemp)>0 then
              libelle:='{X '+sTemp+'} {';
          end;
          if (AvecSOSA.Checked)and(FieldByName('NUM_SOSA').AsFloat>0) then
            libelle:=libelle+'['+FloatToStr(FieldByName('NUM_SOSA').AsFloat)+'] ';
          libelle:=libelle+FieldByName('NOM').AsString;
          if length(FieldByName('PRENOM').AsString)>0 then
          begin
            libelle:=libelle+', '+FieldByName('PRENOM').AsString;
          end;
          if Avecvilles.Checked then
          begin
            libelle:=libelle+GetStringNaissanceDeces(FaitDateVille(FieldByName('DATE_NAISSANCE').AsString
              ,FieldByName('VILLE_NAISSANCE').AsString),FaitDateVille(FieldByName('DATE_DECES').AsString
              ,FieldByName('VILLE_DECES').AsString));
          end
          else
          begin
            libelle:=libelle+GetStringNaissanceDeces(FieldByName('DATE_NAISSANCE').AsString
              ,FieldByName('DATE_DECES').AsString);
          end;
         end;
      end;
      next;
    end;
    close;
  end;
  bBloque:=false;
  TreeView1.FullExpand;
  bBloque:=true;
  TreeView1.Selected[TreeView1.RootNode^.FirstChild]:=True;
  TreeView1.Visible:=true;

  if i>0 then
  begin
    NbrAscendants.Visible:=true;
    if i=1 then
      NbrAscendants.Caption:=rs_Caption_only_one_ancestry_shown
    else
      NbrAscendants.Caption:=IntToStr(i)+rs_Caption_ancestries_shown;
  end
  else
    NbrAscendants.Visible:=false;
  Screen.Cursor:=crDefault;
end;

procedure TFtvAscendance.btnReconstruireClick(Sender:TObject);
begin
  TreeAncetres(fCleIndiDepart);
end;

procedure TFtvAscendance.mExportClick(Sender:TObject);
begin
  SaveDialog1.Filter:=' Fichiers TXT|*.TXT';
  if SaveDialog1.Execute then
    TreeView1.SaveToFile(SaveDialog1.FileName);
end;

procedure TFtvAscendance.OpenFicheClick(Sender:TObject);
begin
  dm.individu_clef:=fCleIndi;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
end;

procedure TFtvAscendance.btnPrintClick(Sender:TObject);
begin
  // Matthieu
  ExtColumnFont.Size:=sp_Fonte.Value;
  p_SetBtnPrint ( btnPrint, Label1.Caption, cb_PaperSize.Text, ch_portrait.Checked );

end;

procedure TFtvAscendance.btOuvrirClick(Sender:TObject);
begin
  TreeView1.Visible:=false;
  bBloque:=false;
  TreeView1.FullExpand;
  bBloque:=true;
  TreeView1.FocusedNode := TreeView1.RootNode;
  TreeView1.Expanded[TreeView1.FocusedNode];
  TreeView1.Visible:=true;
  TreeView1.SetFocus;
end;

procedure TFtvAscendance.btFermerClick(Sender:TObject);
begin
  TreeView1.Visible:=false;
  bBloque:=false;
  TreeView1.FullCollapse;
  bBloque:=true;
  TreeView1.FocusedNode := TreeView1.RootNode;
  TreeView1.Expanded[TreeView1.FocusedNode];
  TreeView1.Visible:=true;
  TreeView1.SetFocus;
end;

procedure TFtvAscendance.pmArbrePopup(Sender:TObject);
var
  Level:smallint;
  asosa:int64;
Begin
  // Matthieu : ne sais pas quel colonne utiliser
  if assigned ( TreeView1.FocusedNode ) Then
  with PIndivTree(TreeView1.GetNodeData(TreeView1.FocusedNode))^ do
   begin
    fCleIndi:=cle;
    Level:=Niveau+1;
    asosa:=Sosa;
    mGeneRelative.Caption:=fs_RemplaceMsg(rs_Generation,[IntToStr(Level)])+' - '+rs_SOSA+' '+IntToStr(asosa);
    NoeudSelecte:=Ordre;
    if mIdentImplexes.Checked then
      mIdentImplexes.Enabled:=true
    else
    begin
      if Implexe>0 then
      begin
        OrdreImplexeSelecte:=Implexe;
        mIdentImplexes.Enabled:=true;
      end
      else
        mIdentImplexes.Enabled:=false;
    end;
  end;
end;

procedure TFtvAscendance.TreeView1Collapsing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
begin
  if (Xmouse>(GetNodeLevel(Node,TreeView1.RootNode)+1)*TreeView1.Indent)and bBloque then
    Allowed:=false;
end;


procedure TFtvAscendance.TreeView1DblClick(Sender:TObject);
Begin
  // Matthieu : ne sais pas quel colonne utiliser
  fCleIndi:=PIndivTree(TreeView1.GetNodeData(TreeView1.FocusedNode))^.cle;
  OpenFicheClick(Sender)
end;

procedure TFtvAscendance.ImprimerClick(Sender:TObject);
begin
  btnPrintClick(Sender);
end;

procedure TFtvAscendance.DatescompletesClick(Sender:TObject);
begin
  Datescompletes.Checked:=not Datescompletes.Checked;
  btnReconstruire.Enabled:=true;
end;

procedure TFtvAscendance.AvecvillesClick(Sender:TObject);
begin
  Avecvilles.Checked:=not Avecvilles.Checked;
  btnReconstruire.Enabled:=true;
end;

procedure TFtvAscendance.AvecSOSAClick(Sender:TObject);
begin
  AvecSOSA.Checked:=not AvecSOSA.Checked;
  btnReconstruire.Enabled:=true;
end;

procedure TFtvAscendance.cxSpinNiveauxPropertiesChange(
  Sender:TObject);
begin
  btnReconstruire.Enabled:=true;
end;

procedure TFtvAscendance.AvecmariagesClick(Sender:TObject);
begin
  Avecmariages.Checked:=not Avecmariages.Checked;
  btnReconstruire.Enabled:=true;
end;

procedure TFtvAscendance.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
var
  i:integer;
begin
{  for i:=TreeView1.Items.Count-1 downto 0 do
  begin
    Dispose(PIndivTree(TreeView1.Items.Item[i].Data));
  end;}
  TreeView1.Clear;
  Action:=caFree; //obligatoire si on veut qu'une SuperForm se libère seule (elle ignore AutoFreeOnClose)
  DoSendMessage(Owner,'FERME_ARBRE_HIER_ASC');
end;

procedure TFtvAscendance.SuperFormShowFirstTime(Sender:TObject);
begin
  height:=round(TControl(Owner).height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).width*gci_context.TailleFenetre/100);
  caption:=rs_Ancestry_s_tree;
end;

procedure TFtvAscendance.mIdentImplexesClick(Sender: TObject);
begin
  mIdentImplexes.Checked:=not mIdentImplexes.Checked;
  TreeView1.Visible:=false;
  if mIdentImplexes.Checked then
  begin
    OrdreImplexe:=OrdreImplexeSelecte;
    TreeView1.FullExpand;
  end;
  TreeView1.Selected[TreeView1.FocusedNode]:=true;
  // Matthieu : Pas sûr
  TreeView1.VisiblePath[TreeView1.FocusedNode]:=True;
  TreeView1.Visible:=true;
  TreeView1.SetFocus;
end;

procedure TFtvAscendance.TreeView1Expanding(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
begin
  if (Xmouse>(GetNodeLevel(Node,TreeView1.RootNode)+1)*TreeView1.Indent)and bBloque then
    Allowed:=false;
end;

procedure TFtvAscendance.TreeView1GetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var monIndiv : PIndivTree;
begin
  monIndiv := PIndivTree ( TreeView1.GetNodeData(node));
  case monIndiv^.sexe of
    1: ImageIndex:=1;
    2: ImageIndex:=2;
    -1: ImageIndex:=3;
    -2: ImageIndex:=4;
  else
     ImageIndex:=0;
  end;

end;

procedure TFtvAscendance.TreeView1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  CellText:=PIndivTree(TreeView1.GetNodeData(Node))^.libelle;
end;

procedure TFtvAscendance.TreeView1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Xmouse:=X;
end;

procedure TFtvAscendance.TreeView1PaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  with Sender,PIndivTree(GetNodeData(Node))^ do
   Begin
    if Implexe>0 then
      TargetCanvas.Font.Style:=[fsItalic];
    if mIdentImplexes.Checked then
      if (Implexe=OrdreImplexe) or (Ordre=OrdreImplexe) then
        Sender.Canvas.Font.Style:=TargetCanvas.Font.Style+[fsUnderline];
    if Selected[Node] then
    begin
      TargetCanvas.Brush.Color:=gci_context.ColorMedium;
      TargetCanvas.Font.Color:=clWindowText;
    end
   end;
end;

end.

