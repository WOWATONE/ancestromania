{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{           source originale Laurent Robbe                              }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           Entièrement refait par André Langlet  en 2008               }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_form_arbre_Hierarchique;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf,
  Forms,U_FormAdapt, u_ancestropictimages,
  VirtualTrees,ExtCtrls,StdCtrls,u_buttons_appli,
  ExtJvXPButtons, ExtJvXPCheckCtrls,Dialogs,
  Controls,IBQuery,Menus,ComCtrls,Classes,SysUtils,
  PrintersDlgs, u_common_tree,
  u_reports_components,
  u_framework_components, U_OnFormInfoIni;

type

  { TFArbreHierarchique }

  TFArbreHierarchique=class(TF_FormAdapt)
    btFermeFiche: TFWClose;
    btFermer: TJvXPButton;
    btnPrint: TFWPrintVTree;
    btnReconstruire: TFWRefresh;
    btOuvrir: TJvXPButton;
    cb_PaperSize: TComboBox;
    ch_portrait: TJvXPCheckbox;
    ch_pdf: TJvXPCheckbox;
    cxSpinNiveaux: TFWSpinEdit;
    IATitle: TIATitle;
    Label2: TLabel;
    Label3: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    pmArbre:TPopupMenu;
    OpenFiche:TMenuItem;
    ibq_SQL:TIBQuery;
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
    Label1:TLabel;
    Panel1:TPanel;
    Imprimer1:TMenuItem;
    parleshommes:TMenuItem;
    parleshommesavecfilles:TMenuItem;
    parlesfemmes:TMenuItem;
    parlesfemmesavecfils:TMenuItem;
    Arbrecomplet:TMenuItem;
    N1:TMenuItem;
    Datescompletes:TMenuItem;
    Avecvilles:TMenuItem;
    AvecSOSA:TMenuItem;
    Sansdecalageenfants:TMenuItem;
    Sansconjoints:TMenuItem;
    fpBoutons: TPanel;
    Panel2: TPanel;
    procedure SuperFormCreate(Sender:TObject);
    procedure btnReconstruireClick(Sender:TObject);
    procedure mExportClick(Sender:TObject);
    procedure OpenFicheClick(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure btOuvrirClick(Sender:TObject);
    procedure btFermerClick(Sender:TObject);
    procedure pmArbrePopup(Sender:TObject);
    procedure TreeView1DblClick(Sender:TObject);
    procedure ImprimerClick(Sender:TObject);
    procedure parleshommesClick(Sender:TObject);
    procedure parleshommesavecfillesClick(Sender:TObject);
    procedure parlesfemmesClick(Sender:TObject);
    procedure parlesfemmesavecfilsClick(Sender:TObject);
    procedure ArbrecompletClick(Sender:TObject);
    procedure DatescompletesClick(Sender:TObject);
    procedure AvecvillesClick(Sender:TObject);
    procedure AvecSOSAClick(Sender:TObject);
    procedure cxSpinNiveauxPropertiesChange(Sender:TObject);
    procedure SansdecalageenfantsClick(Sender:TObject);
    procedure SansconjointsClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure TreeView1CustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TreeView1GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure TreeView1GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure TreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TreeView1Expanding(Sender: TObject; Node: PVirtualNode;
      var AllowExpansion: Boolean);
    procedure TreeView1Collapsing(Sender: TObject; Node: PVirtualNode;
      var AllowCollapse: Boolean);
    procedure SuperFormShowFirstTime(Sender: TObject);

  private
    fCleIndiDepart,fCleIndi,Xmouse:integer;
    bBloque:boolean;
    procedure TreeAjouter(const AQuery: TIBQuery; const ANode: PVirtualNode;
      const monindiv: TIndivTree; const NiveauMax, ALevel: Integer);
    procedure TreeAncetres(const cleAnc:Integer);
    function TreeAjouterEnfant(const aparent:PVirtualNode;var Createdindi : PIndivTree ): PVirtualNode;

  public
    property CleIndiDepart:integer read fCleIndiDepart write fCleIndiDepart;
    procedure Init_Arbre;
  end;

implementation

uses u_dm,u_genealogy_context,u_common_const,u_Form_Main,
     u_common_functions,u_common_ancestro,
     u_common_ancestro_functions,
     fonctions_reports,
     fonctions_string,
     fonctions_vtree,
     fonctions_init,Graphics;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFArbreHierarchique.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  TreeView1.NodeDataSize := Sizeof(TIndivTree)+1;
  pGeneral.Color:=gci_context.ColorLight;
  fCleIndiDepart:=-1;
  TreeView1.Hint:=rs_Hint_Right_clic_for_Options_Double_clic_to_open;
  bBloque:=true;
  TreeView1.Images := dm.ImgCouple;
  p_ReadReportsViewFromIni(f_GetMemIniFile);
end;

procedure TFArbreHierarchique.Init_Arbre;
begin
  fCleIndiDepart:=dm.individu_clef;
  if WindowState<>wsNormal then
    WindowState:=wsNormal;
  if cxSpinNiveaux.Value>20 then
    cxSpinNiveaux.Value:=20;
  TreeAncetres(fCleIndiDepart);
end;

procedure TFArbreHierarchique.TreeAncetres(const cleAnc: Integer);
var
  sexe,i,j,k,NiveauMax:Integer;
  flag_enfant,continuerBoucle:Boolean;
  unIndiv:PIndivTree;
begin
  Screen.Cursor:=crHourglass;
  btnReconstruire.Enabled:=false;
  label1.Caption:=rs_Caption_Descent_from_the;
  TreeView1.Visible:=false;
  if parleshommes.Checked then
  begin
    sexe:=1;
    flag_enfant:=false;
    label1.Caption:=label1.Caption+rs_Caption_men_of;
  end
  else if parleshommesavecfilles.Checked then
  begin
    sexe:=1;
    flag_enfant:=true;
    label1.Caption:=label1.Caption+rs_Caption_men_with_daughters_of;
  end
  else if parlesfemmes.Checked then
  begin
    sexe:=2;
    flag_enfant:=false;
    label1.Caption:=label1.Caption+rs_Caption_women_of;
  end
  else if parlesfemmesavecfils.Checked then
  begin
    sexe:=2;
    flag_enfant:=true;
    label1.Caption:=label1.Caption+rs_Caption_women_with_sons_of;
  end
  else //Arbrecomplet.Checked
  begin
    sexe:=0;
    flag_enfant:=true;
    label1.Caption:=rs_Caption_Complete_descent_of;
  end;
  label1.Caption:=label1.Caption+_CRLF+FMain.NomIndi;
  if length(FMain.PrenomIndi)>0 then
    label1.Caption:=label1.Caption+' '+FMain.PrenomIndi;

  Application.ProcessMessages;
  NiveauMax:=cxSpinNiveaux.Value;

  TreeView1.Clear;
  TreeView1.DisableAlign;

  with ibq_SQL do
  begin
    close;
    SQL.Clear;
    SQL.Add('select i.cle_fiche'
      +',i.nom'
      +',i.prenom'
      +',i.sexe'
      +',i.num_sosa');
    if Datescompletes.Checked then
    begin
      SQL.Add(',i.date_naissance'
        +',i.date_deces');
    end
    else
    begin
//      SQL.Add(',cast(i.annee_naissance as varchar(6)) as date_naissance'
//        +',cast(i.annee_deces as varchar(6)) as date_deces');
       SQL.Add(',case when n.ev_ind_type_token2 in (14,18) then n.ev_ind_date_year||''.''||n.ev_ind_date_year_fin'
        +' else case when n.ev_ind_type_token1=16 then ''>'''
        +' when n.ev_ind_type_token1=15 then ''<'''
        +' when n.ev_ind_type_token1 in (19,20,21) then ''~'''
        +' else '''' end ||n.ev_ind_date_year||'
        +' case when n.ev_ind_type_token1=14 then ''<'''
        +' when n.ev_ind_type_token1 in (13,17) then ''>'''
        +' else '''' end end as date_naissance'
        +',case when d.ev_ind_type_token2 in (14,18) then d.ev_ind_date_year||''''||d.ev_ind_date_year_fin'
        +' else case when d.ev_ind_type_token1=16 then ''>'''
        +' when d.ev_ind_type_token1=15 then ''<'''
        +' when d.ev_ind_type_token1 in (19,20,21) then ''~'''
        +' else '''' end ||d.ev_ind_date_year||'
        +' case when d.ev_ind_type_token1=14 then ''<'''
        +' when d.ev_ind_type_token1 in (13,17) then ''>'''
        +' else '''' end end as date_deces');
    end;
    if Avecvilles.Checked then
      SQL.Add(',n.ev_ind_ville as VILLE_NAISSANCE'
         +',d.ev_ind_ville as VILLE_DECES');
     SQL.Add('from individu i');
     if Avecvilles.Checked or not Datescompletes.Checked then
       SQL.Add('left join evenements_ind n on n.ev_ind_kle_fiche=i.cle_fiche and n.ev_ind_type=''BIRT'''
         +' left join evenements_ind d on d.ev_ind_kle_fiche=i.cle_fiche and d.ev_ind_type=''DEAT''')
    else
      SQL.Add('from individu i');
    SQL.Add('where i.cle_fiche='+IntToStr(cleAnc));
    open;
    if not Eof then
    begin
      with TreeView1 do
      begin
        TreeAjouterEnfant(nil,unIndiv);
        with unIndiv^ do
         Begin
          cle:=FieldByName('CLE_FICHE').AsInteger;
          if (AvecSOSA.Checked)and(FieldByName('NUM_SOSA').AsFloat>0) then
            libelle:='['+FieldByName('NUM_SOSA').AsString+'] '+FieldByName('NOM').AsString
          else
            libelle:=FieldByName('NOM').AsString;
          if length(FieldByName('PRENOM').AsString)>0 then
            libelle:=libelle+', '+FieldByName('PRENOM').AsString;
          sexe:=FieldByName('SEXE').AsInteger;
          if Avecvilles.Checked then
          begin
            libelle:=libelle+GetStringNaissanceDeces(trim(FaitDateVille(FieldByName('DATE_NAISSANCE').AsString
              ,FieldByName('VILLE_NAISSANCE').AsString)),trim(FaitDateVille(FieldByName('DATE_DECES').AsString
              ,FieldByName('VILLE_DECES').AsString)));
          end
          else
          begin
           libelle:=libelle+GetStringNaissanceDeces(trim(FieldByName('DATE_NAISSANCE').AsString)
             ,trim(FieldByName('DATE_DECES').AsString));
          end;

          Enfants:=-1;
         End;
      end;

      i:=0;
      close;
      SQL.Clear;
      SQL.Add('SELECT c.CLE_FICHE'
        +',c.NOM'
        +',c.PRENOM'
        +',c.SEXE'
        +',c.NUM_SOSA');
      if not Sansconjoints.Checked then
        SQL.Add(',c.CLE_CONJOINT'
          +',c.NOM_CONJOINT'
          +',c.PRENOM_CONJOINT'
          +',c.SEXE_CONJOINT'
          +',c.NUM_SOSA_CONJOINT');
      if Avecvilles.Checked then
      begin
        SQL.Add(',iif(c.date_naissance is null and c.VILLE_NAISSANCE is null,null'
          +',iif(c.date_naissance is null,c.VILLE_NAISSANCE'
          +',c.date_naissance||coalesce(''-''||c.VILLE_NAISSANCE,''''))) as date_naissance'
          +',iif(c.date_deces is null and c.VILLE_DECES is null,null'
          +',iif(c.date_deces is null,c.VILLE_DECES'
          +',c.date_deces||coalesce(''-''||c.VILLE_DECES,''''))) as date_deces');
        if not Sansconjoints.Checked then
          SQL.Add(',iif(c.date_naissance_CONJOINT is null and c.VILLE_NAISSANCE_CONJOINT is null,null'
            +',iif(c.date_naissance_CONJOINT is null,c.VILLE_NAISSANCE_CONJOINT'
            +',c.date_naissance_CONJOINT||coalesce(''-''||c.VILLE_NAISSANCE_CONJOINT,''''))) as date_naissance_CONJOINT'
            +',iif(c.date_deces_CONJOINT is null and c.VILLE_DECES_CONJOINT is null,null'
            +',iif(c.date_deces_CONJOINT is null,c.VILLE_DECES_CONJOINT'
            +',c.date_deces_CONJOINT||coalesce(''-''||c.VILLE_DECES_CONJOINT,''''))) as date_deces_CONJOINT'
            +',iif(c.date_mar is null and c.VILLE_mar is null,null'
            +',iif(c.date_mar is null,c.VILLE_mar'
            +',c.date_mar||coalesce(''-''||c.VILLE_mar,''''))) as date_mar')
      end
      else
      begin
        SQL.Add(',c.date_naissance'
          +',c.date_deces');
        if not Sansconjoints.Checked then
          SQL.Add(',c.date_naissance_CONJOINT'
            +',c.date_deces_CONJOINT'
            +',c.date_mar');
      end;
      SQL.Add('from (SELECT coalesce(e.CLE_FICHE,0) as CLE_FICHE'
        +',e.NOM'
        +',e.PRENOM'
        +',e.SEXE'
        +',e.cle_parents'
        +',e.NUM_SOSA');
      if not Sansconjoints.Checked then
        SQL.Add(',coalesce(i.CLE_FICHE,0) as CLE_CONJOINT'
          +',coalesce(i.NOM,''?'') as NOM_CONJOINT'
          +',i.PRENOM as PRENOM_CONJOINT'
          +',-coalesce(i.SEXE,0) as SEXE_CONJOINT'
          +',i.NUM_SOSA as NUM_SOSA_CONJOINT');
      if Datescompletes.Checked then
      begin
        SQL.Add(',e.date_naissance'
          +',e.date_deces');
        if not Sansconjoints.Checked then
          SQL.Add(',i.date_naissance as date_naissance_CONJOINT'
            +',i.date_deces as date_deces_CONJOINT'
            +',(select first(1) ev_fam_date_writen from evenements_fam'
            +' where ev_fam_kle_famille=u.union_clef and ev_fam_type=''MARR'''
            +' order by ev_fam_datecode) as date_mar');
      end
      else
      begin
        SQL.Add(',cast(e.annee_naissance as varchar(6)) as date_naissance'
          +',cast(e.annee_deces as varchar(6)) as date_deces');
        if not Sansconjoints.Checked then
          SQL.Add(',cast(i.annee_naissance as varchar(6)) as date_naissance_CONJOINT'
            +',cast(i.annee_deces as varchar(6)) as date_deces_CONJOINT'
            +',(select first(1) cast(ev_fam_date_year as varchar(6)) from evenements_fam'
            +' where ev_fam_kle_famille=u.union_clef and ev_fam_type=''MARR'''
            +' order by ev_fam_datecode) as date_mar');
      end;

      if Avecvilles.Checked then
      begin
        SQL.Add(',n.ev_ind_ville as VILLE_NAISSANCE'
          +',d.ev_ind_ville as VILLE_DECES');
        if not Sansconjoints.Checked then
          SQL.Add(',nc.ev_ind_ville as VILLE_NAISSANCE_CONJOINT'
            +',dc.ev_ind_ville as VILLE_DECES_CONJOINT'
            +',(select first(1) ev_fam_ville from evenements_fam'
            +' where ev_fam_kle_famille=u.union_clef and ev_fam_type=''MARR'''
            +' order by ev_fam_datecode) as ville_mar');
      end;
      SQL.Add(',(select first(1) ev_fam_datecode'
        +'  from evenements_fam'
        +'  where ev_fam_kle_famille=u.union_clef'
        +'    and ev_fam_date_year is not null'
        +'  order by ev_fam_date_year,ev_fam_date_mois,ev_fam_date) as date_prem_fam'
        +',(select first(1) n.ev_ind_datecode'
        +'  from individu e'
        +'  inner join evenements_ind n on n.ev_ind_kle_fiche=e.cle_fiche'
        +'  where e.cle_pere is not distinct from u.union_mari'
        +'    and e.cle_mere is not distinct from u.union_femme'
        +'    and n.ev_ind_date_year is not null'
        +'  order by n.ev_ind_datecode) as date_prem_enf'
        +',(select first(1) ev_ind_datecode'
        +'  from evenements_ind'
        +'  where ev_ind_kle_fiche=i.cle_fiche'
        +'    and ev_ind_date_year is not null'
        +'  order by ev_ind_datecode desc) as date_dern_eve'
        +',(select first(1) ev_ind_datecode*1440'
        +'  +coalesce(extract(hour from ev_ind_heure)*60+extract(minute from ev_ind_heure),0)'
        +'  from evenements_ind'
        +'  where ev_ind_kle_fiche=e.cle_fiche and ev_ind_date_year is not null'
        +'  order by ev_ind_datecode,ev_ind_heure) as date_enfant'
        +' FROM t_union u'
        +' left join individu i on i.cle_fiche in (u.union_femme,u.union_mari)'
        +'  and i.cle_fiche<>:CLE'
        +' left join individu e on e.cle_pere is not distinct from u.union_mari'
        +' and e.cle_mere is not distinct from u.union_femme');
      if Avecvilles.Checked then
      begin
        SQL.Add('left join evenements_ind n on n.ev_ind_kle_fiche=e.cle_fiche and n.ev_ind_type=''BIRT'''
          +' left join evenements_ind d on d.ev_ind_kle_fiche=e.cle_fiche and d.ev_ind_type=''DEAT''');
        if not Sansconjoints.Checked then
          SQL.Add('left join evenements_ind nc on nc.ev_ind_kle_fiche=i.cle_fiche and nc.ev_ind_type=''BIRT'''
            +' left join evenements_ind dc on dc.ev_ind_kle_fiche=i.cle_fiche and dc.ev_ind_type=''DEAT''');
      end;
      SQL.Add('Where u.union_mari=:CLE or u.union_femme=:CLE');
      if not flag_enfant then
        SQL.Add(' and e.sexe='+IntToStr(sexe));
      SQL.Add(') as c'
        +' ORDER BY case'
        +'  when (c.date_prem_enf is null) and (c.date_prem_fam is null) then c.date_dern_eve'
        +'  when (c.date_prem_enf is null) then c.date_prem_fam'
        +'  when (c.date_prem_fam is null) then c.date_prem_enf'
        +'  when (c.date_prem_fam<=date_prem_enf) then c.date_prem_fam'
        +'  else c.date_prem_enf'
        +'  end'
        +',c.cle_parents'
        +',c.date_enfant');

      TreeAjouter( ibq_SQL, TreeView1.RootNode, unIndiv^, NiveauMax, 0 );
    End;
  end;
  TreeView1.EnableAlign;
  bBloque:=false;
  TreeView1.Visible:=true;
  TreeView1.FullExpand;
  bBloque:=true;
  TreeView1.Selected[TreeView1.RootNode.FirstChild]:=true;
  TreeView1.VisiblePath[TreeView1.RootNode.FirstChild]:=true;
  TreeView1.Visible:=true;
  Screen.Cursor:=crDefault;
end;

procedure TFArbreHierarchique.TreeAjouter(const AQuery:TIBQuery;
  const ANode: PVirtualNode; const monindiv : TIndivTree ; const NiveauMax, ALevel : Integer );
var unIndiv : PIndivTree;
    aindiv : TIndivTree;
    AChild : PVirtualNode;
    j : Integer;
Begin
  with TreeView1,AQuery, ANode^ do
  if ANode <> RootNode Then
   Begin
     AChild := nil;
     aindiv := PIndivTree ( TreeView1.GetNodeData(ANode))^;
     with aindiv do
      if ((sexe=0)or(monindiv.sexe=sexe))
      and(Enfants<0)
      and(ALevel<NiveauMax) then
        begin
          paramByName('CLE').AsInteger:=cle;
          open;
          j:=-10;
          while not Eof do
          begin
            if (not Sansconjoints.Checked) then
              if (FieldByName('CLE_CONJOINT').AsInteger<>j) then
              begin
                TreeAjouterEnfant(ANode,unIndiv);
                with unIndiv^ do
                 Begin
                  j:=FieldByName('CLE_CONJOINT').AsInteger;
                  if j=0 then
                    cle:=aindiv.cle
                  else
                    cle:=j;
                  sexe:=FieldByName('SEXE_CONJOINT').AsInteger;
                  if sexe=0 then
                    sexe:=aindiv.sexe-3;
                  if FieldByName('NOM_CONJOINT').AsString='?' then
                  begin
                    case sexe of
                      1:libelle:=fs_FormatText(rs_unknown_male,mftFirstIsMaj);
                      2:libelle:=fs_FormatText(rs_unknown_female,mftFirstIsMaj);
                      -1:libelle:=fs_FormatText(rs_unknown_male,mftFirstIsMaj);
                      -2:libelle:=fs_FormatText(rs_unknown_female,mftFirstIsMaj);
                    else
                      libelle:=fs_FormatText(rs_unknown_male,mftFirstIsMaj);
                    end;
                  end
                  else
                  begin
                    if (AvecSOSA.Checked)and(FieldByName('NUM_SOSA_CONJOINT').AsFloat>0) then
                      libelle:='['+FieldByName('NUM_SOSA_CONJOINT').AsString+'] '+FieldByName('NOM_CONJOINT').AsString
                    else
                      libelle:=FieldByName('NOM_CONJOINT').AsString;
                    if length(FieldByName('date_mar').AsString)>0 then
                      libelle:='{X '+FieldByName('date_mar').AsString+'} '+libelle;
                  end;
                   if length(FieldByName('PRENOM_CONJOINT').AsString)>0 then
                     libelle:=libelle+', '+FieldByName('PRENOM_CONJOINT').AsString;
                   libelle:=libelle+GetStringNaissanceDeces(trim(FieldByName('DATE_NAISSANCE_CONJOINT').AsString)
                     ,trim(FieldByName('DATE_DECES_CONJOINT').AsString));
                  Enfants:=1;
                end;
               End;

              if Sansdecalageenfants.Checked or Sansconjoints.Checked then
                Exit;
              if FieldByName('CLE_FICHE').AsInteger>0 then
              begin
                AChild := TreeAjouterEnfant(ANode,unIndiv);
                with unIndiv^ do
                 Begin
                  cle:=FieldByName('CLE_FICHE').AsInteger;
                  if (AvecSOSA.Checked)and(FieldByName('NUM_SOSA').AsFloat>0) then
                    libelle:='['+FieldByName('NUM_SOSA').AsString+'] '+FieldByName('NOM').AsString
                  else
                    libelle:=FieldByName('NOM').AsString;
                  if length(FieldByName('PRENOM').AsString)>0 then
                    libelle:=libelle+', '+FieldByName('PRENOM').AsString;
                  sexe:=FieldByName('SEXE').AsInteger;
                  libelle:=libelle+GetStringNaissanceDeces(trim(FieldByName('DATE_NAISSANCE').AsString)
                    ,trim(FieldByName('DATE_DECES').AsString));
                  Enfants:=-1;
                 end;
              end;
            Enfants:=1;
            Next;
          end;
          close;
          if Assigned(AChild) Then
             TreeAjouter( ibq_SQL, AChild, unindiv^, NiveauMax, ALevel + 1 );

     end;
     if NextSibling <> nil Then
       TreeAjouter( ibq_SQL, NextSibling, unindiv^, NiveauMax, ALevel );
   end
   Else
    Begin
     if ANode.FirstChild <> nil Then TreeAjouter( ibq_SQL, ANode.FirstChild, monindiv, NiveauMax, ALevel );
     Exit;
    end;
End;

function TFArbreHierarchique.TreeAjouterEnfant(const aparent: PVirtualNode;var CreatedIndi : PIndivTree ): PVirtualNode;
var
  libelle:string;
begin

  with TreeView1 do
   Begin
    Result := AddChild(aparent,nil);
    ValidateNode ( Result, False );

    CreatedIndi:=( GetNodeData(Result));
   end;
end;

procedure TFArbreHierarchique.btnReconstruireClick(Sender:TObject);
begin
  TreeAncetres(fCleIndiDepart);
end;

procedure TFArbreHierarchique.mExportClick(Sender:TObject);
begin
  SaveDialog1.Filter:=' Fichiers TXT|*.TXT';
  if SaveDialog1.Execute then
    TreeView1.SaveToFile(SaveDialog1.FileName);
end;

procedure TFArbreHierarchique.OpenFicheClick(Sender:TObject);
begin
  dm.individu_clef:=fCleIndi;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
end;

procedure TFArbreHierarchique.btnPrintClick(Sender:TObject);
begin
  // Matthieu
  ExtColumnFont.Size:=sp_Fonte.Value;
  p_SetBtnPrint ( btnPrint, Label1.Caption, cb_PaperSize.Text, ch_portrait.Checked, Integer(ch_pdf.Checked), fPathBaseMedias );
end;

procedure TFArbreHierarchique.btOuvrirClick(Sender:TObject);
begin
  TreeView1.Visible:=false;
  bBloque:=false;
  TreeView1.FullExpand;
  bBloque:=true;
  TreeView1.FocusedNode:=TreeView1.RootNode;
  TreeView1.VisiblePath[TreeView1.RootNode];
  TreeView1.Visible:=true;
  TreeView1.SetFocus;
end;

procedure TFArbreHierarchique.btFermerClick(Sender:TObject);
begin
  TreeView1.Visible:=false;
  bBloque:=false;
  TreeView1.FullCollapse;
  bBloque:=true;
  TreeView1.FocusedNode:=TreeView1.RootNode;
  TreeView1.VisiblePath[TreeView1.RootNode];
  TreeView1.Visible:=true;
  TreeView1.SetFocus;
end;

procedure TFArbreHierarchique.pmArbrePopup(Sender:TObject);
begin
  if Assigned(TreeView1.FocusedNode) Then
    fCleIndi:=PIndivTree(TreeView1.GetNodeData(TreeView1.FocusedNode))^.cle;
end;

procedure TFArbreHierarchique.TreeView1DblClick(Sender:TObject);
begin
  fCleIndi:=PIndivTree(TreeView1.GetNodeData(TreeView1.FocusedNode))^.cle;
  OpenFicheClick(Sender)
end;

procedure TFArbreHierarchique.ImprimerClick(Sender:TObject);
begin
  btnPrintClick(Sender);
end;

procedure TFArbreHierarchique.parleshommesClick(Sender:TObject);
begin
  if parleshommes.Checked=false then
    btnReconstruire.Enabled:=true;
  parleshommes.Checked:=true;
  parleshommesavecfilles.Checked:=false;
  parlesfemmes.Checked:=false;
  parlesfemmesavecfils.Checked:=false;
  Arbrecomplet.Checked:=false;
end;

procedure TFArbreHierarchique.parleshommesavecfillesClick(Sender:TObject);
begin
  if parleshommesavecfilles.Checked=false then
    btnReconstruire.Enabled:=true;
  parleshommes.Checked:=false;
  parleshommesavecfilles.Checked:=true;
  parlesfemmes.Checked:=false;
  parlesfemmesavecfils.Checked:=false;
  Arbrecomplet.Checked:=false;
end;

procedure TFArbreHierarchique.parlesfemmesClick(Sender:TObject);
begin
  if parlesfemmes.Checked=false then
    btnReconstruire.Enabled:=true;
  parleshommes.Checked:=false;
  parleshommesavecfilles.Checked:=false;
  parlesfemmes.Checked:=true;
  parlesfemmesavecfils.Checked:=false;
  Arbrecomplet.Checked:=false;
end;

procedure TFArbreHierarchique.parlesfemmesavecfilsClick(Sender:TObject);
begin
  if parlesfemmesavecfils.Checked=false then
    btnReconstruire.Enabled:=true;
  parleshommes.Checked:=false;
  parleshommesavecfilles.Checked:=false;
  parlesfemmes.Checked:=false;
  parlesfemmesavecfils.Checked:=true;
  Arbrecomplet.Checked:=false;
end;

procedure TFArbreHierarchique.ArbrecompletClick(Sender:TObject);
begin
  if Arbrecomplet.Checked=false then
    btnReconstruire.Enabled:=true;
  parleshommes.Checked:=false;
  parleshommesavecfilles.Checked:=false;
  parlesfemmes.Checked:=false;
  parlesfemmesavecfils.Checked:=false;
  Arbrecomplet.Checked:=true;
end;

procedure TFArbreHierarchique.DatescompletesClick(Sender:TObject);
begin
  Datescompletes.Checked:=not Datescompletes.Checked;
  btnReconstruire.Enabled:=true;
end;

procedure TFArbreHierarchique.AvecvillesClick(Sender:TObject);
begin
  Avecvilles.Checked:=not Avecvilles.Checked;
  btnReconstruire.Enabled:=true;
end;

procedure TFArbreHierarchique.AvecSOSAClick(Sender:TObject);
begin
  AvecSOSA.Checked:=not AvecSOSA.Checked;
  btnReconstruire.Enabled:=true;
end;

procedure TFArbreHierarchique.cxSpinNiveauxPropertiesChange(
  Sender:TObject);
begin
  btnReconstruire.Enabled:=true;
end;

procedure TFArbreHierarchique.SansdecalageenfantsClick(Sender:TObject);
begin
  Sansdecalageenfants.Checked:=not Sansdecalageenfants.Checked;
  btnReconstruire.Enabled:=true;
end;

procedure TFArbreHierarchique.SansconjointsClick(Sender:TObject);
begin
  Sansconjoints.Checked:=not Sansconjoints.Checked;
  btnReconstruire.Enabled:=true;
end;

procedure TFArbreHierarchique.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
var
  i:integer;
begin
{  for i:=TreeView1.Items.Count-1 downto 0 do
  begin
    Dispose(PIndivTree(TreeView1.Items.Item[i].Data));
  end;                  }
  TreeView1.Clear;
  Action:=caFree; //obligatoire si on veut qu'une SuperForm se libère seule (elle ignore AutoFreeOnClose)
  DoSendMessage(Owner,'FERME_ARBRE_HIER_DESC');
end;

procedure TFArbreHierarchique.TreeView1CustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Node.Selected then
  begin
    Sender.Canvas.Brush.Color:=gci_context.ColorMedium;
    Sender.Canvas.Font.Color:=clWindowText;
  end;
end;

procedure TFArbreHierarchique.TreeView1GetImageIndex(Sender: TBaseVirtualTree;
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

procedure TFArbreHierarchique.TreeView1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);

begin
  CellText:=PIndivTree(TreeView1.GetNodeData(Node))^.libelle;
end;

procedure TFArbreHierarchique.TreeView1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Xmouse:=X;
end;

procedure TFArbreHierarchique.TreeView1Expanding(Sender: TObject;
  Node: PVirtualNode; var AllowExpansion: Boolean);
begin
  if (Xmouse>(GetNodeLevel(Node,TreeView1.RootNode)+1)*TreeView1.Indent)and bBloque then
    AllowExpansion:=false;
end;

procedure TFArbreHierarchique.TreeView1Collapsing(Sender: TObject;
  Node: PVirtualNode; var AllowCollapse: Boolean);
begin
  if (Xmouse>(GetNodeLevel(Node,TreeView1.RootNode)+1)*TreeView1.Indent)and bBloque then
    AllowCollapse:=false;
end;

procedure TFArbreHierarchique.SuperFormShowFirstTime(Sender: TObject);
begin
  height:=round(TControl(Owner).height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).width*gci_context.TailleFenetre/100);
  caption:=rs_Caption_Descending_tree;
end;

end.

