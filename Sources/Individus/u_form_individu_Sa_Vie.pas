unit u_form_individu_Sa_Vie;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, CommCtrl, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,StdCtrls,
  ExtCtrls,Controls,Classes,SysUtils,Graphics,ComCtrls,
  Menus,PrintersDlgs,
  VirtualTrees,IBSQL;

type
  TVieTree=record
    Libelle,
    TypeTable:string;
    ImageIdx,
    cleID,
    Sexe,
    Sosa,
    Onglet,
    Ligne:integer;
  end;
  PVieTree=^TVieTree;

type

  { TFSaVie }

  TFSaVie=class(TF_FormAdapt)
    Panel3:TPanel;
    dxComponentPrinter1:TPrinterSetupDialog;
    lNom:TLabel;
    Label8:TLabel;
    pmVie:TPopupMenu;
    mOuvreDocument:TMenuItem;
    tvSaVie:TVirtualStringTree;
    N1:TMenuItem;
    mOuvre:TMenuItem;
    ImageList1:TImageList;
    reqConjoints:TIBSQL;
    reqEnfants:TIBSQL;
    reqEvFam:TIBSQL;
    reqMedias:TIBSQL;
    reqTemoins:TIBSQL;
    reqEvInd:TIBSQL;
    reqDom:TIBSQL;
    reqMediasInd:TIBSQL;
    mVisualiseMedia:TMenuItem;
    mOuvrirFiche:TMenuItem;
    procedure FormClose(Sender:TObject;var Action:TCloseAction);
    procedure FormCreate(Sender:TObject);
    procedure mOuvreDocumentClick(Sender:TObject);
    procedure pmViePopup(Sender:TObject);
    procedure mOuvreClick(Sender:TObject);
    procedure tvSaVieBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure tvSaVieDblClick(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure tvSaVieCustomDrawItem(Sender:TCustomTreeView;
      Node:TTreeNode;State:TCustomDrawState;var DefaultDraw:Boolean);
    procedure mVisualiseMediaClick(Sender:TObject);
    procedure mOuvrirFicheClick(Sender:TObject);
    procedure tvSaVieExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var Allowed: Boolean);
    procedure tvSaVieGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure tvSaVieGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure tvSaVieMouseMove(Sender:TObject;Shift:TShiftState;X,
      Y:Integer);
    procedure tvSaVieMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    { Déclarations privées }
    iCleIndi:integer;
    fCanDeletionTV,bBloque:boolean;
    Xmouse:integer;
    Acte:TVieTree;
    procedure OuvreObjetPointe;
  public
    { Déclarations publiques }
    bModified:boolean;
    function doOpenQuerys:boolean;
    procedure doInit(iClef:integer;sNom:string);
  end;


implementation

uses u_common_functions,u_common_ancestro,u_Common_const,u_Dm,u_form_individu,
     fonctions_string,
     fonctions_vtree,
     fonctions_reports,
     u_common_ancestro_functions,
     u_Form_Main,u_genealogy_context,Types;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}
var    fFormIndividu:TFIndividu;

procedure TFSaVie.doInit(iClef:integer;sNom:string);
var
  iNoeudparent,iNoeud,iNoeudConjoint,iNoeudEve,iAjoute,iNoeudTitre:PVirtualNode;
  lsNom,naissance,deces:string;
  NumOrdre:integer;
begin
  tvSaVie.DisableAlign;
  tvSaVie.NodeDataSize:=SizeOf(TVieTree)+1;
  iCleIndi:=iClef;
  bModified:=false;
  tvSaVie.Clear;
  reqConjoints.Close;
  reqEnfants.Close;
  reqEvFam.Close;
  reqMedias.Close;
  reqTemoins.Close;
  reqEvInd.Close;
  reqMediasInd.Close;

  lsNom:=FFormIndividu.GetNomIndividu;
  if length(FFormIndividu.sDateNaissance)>0 then
  begin
    naissance:=FFormIndividu.sDateNaissance;
    if length(FFormIndividu.sVilleNaissance)>0 then
      naissance:=naissance+'-'+FFormIndividu.sVilleNaissance;
  end
  else if length(FFormIndividu.sVilleNaissance)>0 then
    naissance:=FFormIndividu.sVilleNaissance
  else
    naissance:='';
  if length(FFormIndividu.sDateDeces)>0 then
  begin
    deces:=FFormIndividu.sDateDeces;
    if length(FFormIndividu.sVilleDeces)>0 then
      deces:=deces+'-'+FFormIndividu.sVilleDeces;
  end
  else if length(FFormIndividu.sVilleDeces)>0 then
    deces:=FFormIndividu.sVilleDeces
  else
    deces:='';
  lsNom:=lsNom+GetStringNaissanceDeces(naissance,deces);

  iNoeudparent:=tvSaVie.AddChild(nil,nil);
  tvSaVie.ValidateNode(iNoeudparent,False);

  with PVieTree(tvSaVie.GetNodeData(iNoeudparent))^,FFormIndividu.QueryIndividu do
   Begin
    cleID:=1;
    Sexe:=FieldByName('SEXE').AsInteger;
    TypeTable:='INDIVIDU';
    Onglet:=_ONGLET_IDENTITE;
    if FieldByName('NUM_SOSA').AsFloat>0 then
      Sosa:=1
    else
      Sosa:=0;

    Libelle:=lsNom;
    ImageIdx:=19;
//    iNoeudparent.SelectedIndex:=19;
//    iNoeudparent.StateIndex:=-1;
   end;

  with FFormIndividu.aFIndividuIdentite.IBQmariageParents do
  begin
    Params[0].AsInteger:=FFormIndividu.QueryIndividuCLE_FICHE.AsInteger;
    ExecQuery;
    if not Eof then
    begin
      iNoeud:=tvSaVie.AddChild(iNoeudparent,nil);
      tvSaVie.ValidateNode(iNoeud,False);
      if length(FieldByName('NOM_PERE').AsString)>0 then
      with PVieTree(tvSaVie.GetNodeData(iNoeud))^ do
      begin
        cleID:=FFormIndividu.QueryIndividuCLE_PERE.AsInteger;
        Sexe:=1;
        TypeTable:='INDIVIDU';
        Onglet:=_ONGLET_IDENTITE;
        if FieldByName('PERE_SOSA').AsFloat>0 then
          Sosa:=1
        else
          Sosa:=0;
        lsNom:=fs_RemplaceMsg(rs_Father,[FieldByName('NOM_PERE').AsString]);
        if length(FieldByName('PRENOM_PERE').AsString)>0 then
          lsNom:=lsNom+', '+FieldByName('PRENOM_PERE').AsString;
        if length(FieldByName('PERE_NAISSANCE').AsString)>0 then
        begin
          naissance:=FieldByName('PERE_NAISSANCE').AsString;
          if length(FieldByName('PERE_VILLE_NAISSANCE').AsString)>0 then
            naissance:=naissance+'-'+FieldByName('PERE_VILLE_NAISSANCE').AsString;
        end
        else if length(FieldByName('PERE_VILLE_NAISSANCE').AsString)>0 then
          naissance:=FieldByName('PERE_VILLE_NAISSANCE').AsString
        else
          naissance:='';
        if length(FieldByName('PERE_DECES').AsString)>0 then
        begin
          deces:=FieldByName('PERE_DECES').AsString;
          if length(FieldByName('PERE_VILLE_DECES').AsString)>0 then
            deces:=deces+'-'+FieldByName('PERE_VILLE_DECES').AsString;
        end
        else if length(FieldByName('PERE_VILLE_DECES').AsString)>0 then
          deces:=FieldByName('PERE_VILLE_DECES').AsString
        else
          deces:='';
        lsNom:=lsNom+GetStringNaissanceDeces(naissance,deces);
        Libelle := lsNom;
        ImageIdx:=29;
//        iNoeud.SelectedIndex:=29;
//        iNoeud.StateIndex:=-1;
      end;

      iNoeud:=tvSaVie.AddChild(iNoeudparent,nil);
      tvSaVie.ValidateNode(iNoeud,False);
      if length(FieldByName('NOM_MERE').AsString)>0 then
      with PVieTree(tvSaVie.GetNodeData(iNoeud))^ do
      begin
        cleID:=FFormIndividu.QueryIndividuCLE_MERE.AsInteger;
        Sexe:=2;
        TypeTable:='INDIVIDU';
        Onglet:=_ONGLET_IDENTITE;
        if FieldByName('MERE_SOSA').AsFloat>0 then
          Sosa:=1
        else
          Sosa:=0;
        lsNom:=fs_RemplaceMsg(rs_Mother,[FieldByName('NOM_MERE').AsString]);
        if length(FieldByName('PRENOM_MERE').AsString)>0 then
          lsNom:=lsNom+', '+FieldByName('PRENOM_MERE').AsString;
        if length(FieldByName('MERE_NAISSANCE').AsString)>0 then
        begin
          naissance:=FieldByName('MERE_NAISSANCE').AsString;
          if length(FieldByName('MERE_VILLE_NAISSANCE').AsString)>0 then
            naissance:=naissance+'-'+FieldByName('MERE_VILLE_NAISSANCE').AsString;
        end
        else if length(FieldByName('MERE_VILLE_NAISSANCE').AsString)>0 then
          naissance:=FieldByName('MERE_VILLE_NAISSANCE').AsString
        else
          naissance:='';
        if length(FieldByName('MERE_DECES').AsString)>0 then
        begin
          deces:=FieldByName('MERE_DECES').AsString;
          if length(FieldByName('MERE_VILLE_DECES').AsString)>0 then
            deces:=deces+'-'+FieldByName('MERE_VILLE_DECES').AsString;
        end
        else if length(FieldByName('MERE_VILLE_DECES').AsString)>0 then
          deces:=FieldByName('MERE_VILLE_DECES').AsString
        else
          deces:='';
        lsNom:=lsNom+GetStringNaissanceDeces(naissance,deces);
        Libelle := lsNom;
        ImageIdx:=30;
//        iNoeud.SelectedIndex:=30;
  //      iNoeud.StateIndex:=-1;
      end;
    end;
    Close;
  end;

  reqConjoints.ParamByName('INDI').AsInteger:=FFormIndividu.QueryIndividuCLE_FICHE.AsInteger;
  reqConjoints.ExecQuery;
  NumOrdre:=-1;
  if not reqConjoints.Eof then
  begin
    lsNom:=rs_Joint;
    iNoeudTitre:=tvSaVie.AddChild(iNoeudparent,nil);
    tvSaVie.ValidateNode(iNoeudTitre,False);
    with PVieTree(tvSaVie.GetNodeData(iNoeudTitre))^ do
      Begin
        Libelle := lsNom;
        ImageIdx:=23;
        cleID:=1;
        Sexe:=0;
        TypeTable:='T_UNION';
        Onglet:=_ONGLET_SES_CONJOINTS;
        Sosa:=0;
        Ligne:=-1;
      End;
//    iNoeudTitre.SelectedIndex:=iNoeudTitre.ImageIndex;
  //  iNoeudTitre.StateIndex:=-1;
    repeat
      iNoeudConjoint:=tvSaVie.AddChild(iNoeudTitre,nil);
      tvSaVie.ValidateNode(iNoeudConjoint,False);
      with PVieTree(tvSaVie.GetNodeData(iNoeudConjoint))^ do
        Begin
          cleID:=reqConjoints.FieldByName('CLE_FICHE').AsInteger;
          Sexe:=reqConjoints.FieldByName('SEXE').AsInteger;
          TypeTable:='T_UNION';
          Sosa:=reqConjoints.FieldByName('SOSA').AsInteger;
          if reqConjoints.FieldByName('CLE_FICHE').AsInteger>0 then
          begin
            NumOrdre:=reqConjoints.FieldByName('CLE_FICHE').AsInteger;
            Ligne:=NumOrdre;
            Onglet:=_ONGLET_SES_CONJOINTS;
          end
          else
          begin
            Ligne:=-1;
            Onglet:=_ONGLET_IDENTITE;
          end;
          lsNom:=reqConjoints.FieldByName('NOM').AsString;
          if length(reqConjoints.FieldByName('PRENOM').AsString)>0 then
            lsNom:=lsNom+', '+reqConjoints.FieldByName('PRENOM').AsString;
          naissance:=reqConjoints.FieldByName('NAISSANCE').AsString;
          deces:=reqConjoints.FieldByName('DECES').AsString;
          Libelle:=lsNom+GetStringNaissanceDeces(naissance,deces);
          case reqConjoints.FieldByName('SEXE').AsInteger of
            1: ImageIdx:=29;
            2: ImageIdx:=30;
          end;
         End;

//      iNoeudConjoint.SelectedIndex:=iNoeudConjoint.ImageIndex;
//      iNoeudConjoint.StateIndex:=-1;

      reqEnfants.ParamByName('INDI').AsInteger:=FFormIndividu.QueryIndividuCLE_FICHE.AsInteger;
      reqEnfants.ParamByName('CONJOINT').Value:=reqConjoints.FieldByName('CLE_FICHE').Value;
      reqEnfants.ExecQuery;
      with reqEnfants do
      while not Eof do
      begin
       iNoeud:=tvSaVie.AddChild(iNoeudConjoint,nil);
       tvSaVie.ValidateNode(iNoeud,False);
        with PVieTree(tvSaVie.GetNodeData(iNoeud))^ do
          Begin
            cleID:=FieldByName('CLE_FICHE').AsInteger;
            Sexe:=FieldByName('SEXE').AsInteger;
            TypeTable:='INDIVIDU';
            Onglet:=_ONGLET_IDENTITE;
            Sosa:=FieldByName('SOSA').AsInteger;
            lsNom:=FieldByName('NOM').AsString;
            if length(FieldByName('PRENOM').AsString)>0 then
              lsNom:=lsNom+', '+FieldByName('PRENOM').AsString;
            naissance:=FieldByName('NAISSANCE').AsString;
            deces:=FieldByName('DECES').AsString;
            Libelle:=lsNom+GetStringNaissanceDeces(naissance,deces);
            case FieldByName('SEXE').AsInteger of
              1: ImageIdx:=24;
              2: ImageIdx:=25;
              else
                ImageIdx:=31;
            end;
          End;
//        iNoeud.SelectedIndex:=iNoeud.ImageIndex;
//        iNoeud.StateIndex:=-1;
        Next;
      end;
      reqEnfants.Close;

      reqEvFam.ParamByName('INDI').AsInteger:=FFormIndividu.QueryIndividuCLE_FICHE.AsInteger;
      reqEvFam.ParamByName('CONJOINT').Value:=reqConjoints.FieldByName('CLE_FICHE').Value;
      reqEvFam.ExecQuery;
      while not reqEvFam.Eof do
       Begin
        iNoeudEve:=tvSaVie.AddChild(iNoeudConjoint,nil);
        tvSaVie.ValidateNode(iNoeudEve,False);

        with PVieTree(tvSaVie.GetNodeData(iNoeudEve))^ do
        begin
          cleID:=reqEvFam.FieldByName('CLEF').AsInteger;
          Sexe:=0;
          TypeTable:='T_UNION';
          Onglet:=_ONGLET_SES_CONJOINTS;
          Sosa:=0;
          Ligne:=NumOrdre;
          Libelle:=reqEvFam.FieldByName('libelle').AsString;
          ImageIdx:=reqEvFam.FieldByName('categorie').AsInteger;

//        iNoeudEve.SelectedIndex:=iNoeudEve.ImageIndex;
    //    iNoeudEve.StateIndex:=reqEvFamstatus.AsInteger+7;
        end;

        reqMedias.ParamByName('table').AsString:='F';
        reqMedias.ParamByName('eve').AsInteger:=reqEvFam.FieldByName('CLEF').AsInteger;
        reqMedias.ExecQuery;
        with reqMedias do
        while not Eof do
        begin
          iNoeud:=tvSaVie.AddChild(iNoeudEve,nil);
          tvSaVie.ValidateNode(iNoeud,False);
          with PVieTree(tvSaVie.GetNodeData(iNoeud))^ do
           Begin
            cleID:=FieldByName('CLEF').AsInteger;
            Sexe:=0;
            TypeTable:='T_UNION';
            Onglet:=_ONGLET_SES_CONJOINTS;
            Sosa:=0;
            Ligne:=NumOrdre;
            Libelle:=StringReplace(FieldByName('libelle').AsString,_CRLF,' ',[rfReplaceAll]);
            ImageIdx:=FieldByName('type').AsInteger;
           End;
    //          iNoeud.SelectedIndex:=iNoeud.ImageIndex;
        //    iNoeud.StateIndex:=-1;
          Next;
        end;
        reqMedias.Close;

        reqTemoins.ParamByName('table').AsString:='U';
        reqTemoins.ParamByName('eve').AsInteger:=reqEvFam.FieldByName('CLEF').AsInteger;
        reqTemoins.ExecQuery;
        with reqTemoins do
        if not Eof then
        begin
          iAjoute:=tvSaVie.AddChild(iNoeudEve,nil);
          tvSaVie.ValidateNode(iAjoute,False);
          with PVieTree(tvSaVie.GetNodeData(iAjoute))^ do
           Begin
            lsNom:=rs_Witness;
            cleID:=1;
            Sexe:=0;
            TypeTable:='T_UNION';
            Onglet:=_ONGLET_SES_CONJOINTS;
            Sosa:=0;
            Ligne:=NumOrdre;
            ImageIdx:=5;
            Libelle:=lsNom;
           end;
//          iAjoute.SelectedIndex:=iAjoute.ImageIndex;
      //    iAjoute.StateIndex:=-1;
          repeat
            iNoeud:=tvSaVie.AddChild(iAjoute,nil);
            tvSaVie.ValidateNode(iNoeud,False);
            with PVieTree(tvSaVie.GetNodeData(iNoeud))^ do
             Begin
              cleID:=FieldByName('CLE_FICHE').AsInteger;
              Sexe:=FieldByName('SEXE').AsInteger;
              TypeTable:='T_UNION';
              Onglet:=_ONGLET_SES_CONJOINTS;
              Sosa:=FieldByName('SOSA').AsInteger;
              Ligne:=NumOrdre;
              naissance:=FieldByName('NAISSANCE').AsString;
              deces:=FieldByName('DECES').AsString;
              Libelle:=FieldByName('NomPrenom').AsString
               +GetStringNaissanceDeces(naissance,deces)
               +', '+FieldByName('libelle').AsString;
              case FieldByName('SEXE').AsInteger of
                1:ImageIdx:=29;
                2:ImageIdx:=30;
                else
                  ImageIdx:=31;

              end;
             end;
//            iNoeud.SelectedIndex:=iNoeud.ImageIndex;
  //          iNoeud.StateIndex:=-1;
            Next;
          until Eof;
          if RecordCount>1 then
            PVieTree(tvSaVie.GetNodeData(iAjoute))^.Libelle:=rs_Witness;
        end;
        reqTemoins.Close;
        reqEvFam.Next;
      end;
      reqEvFam.Close;
      reqConjoints.Next;
    until reqConjoints.Eof;
    if reqConjoints.RecordCount>1 then
      PVieTree(tvSaVie.GetNodeData(iNoeudTitre))^.Libelle:=rs_Joints;
  end;
  reqConjoints.Close;

  reqEvInd.ParamByName('indi').AsInteger:=FFormIndividu.QueryIndividuCLE_FICHE.AsInteger;
  reqEvInd.ExecQuery;
  if not reqEvInd.Eof then
   Begin
    iNoeudTitre:=tvSaVie.AddChild(iNoeudparent,nil);
    tvSaVie.ValidateNode(iNoeudTitre,False);
    with PVieTree(tvSaVie.GetNodeData(iNoeudTitre))^ do
     begin
      lsNom:=rs_Individual_event;
      cleID:=reqEvInd.FieldByName('clef').AsInteger;
      Sexe:=0;
      TypeTable:='EVENEMENTS_IND';
      Onglet:=_ONGLET_IDENTITE;
      Sosa:=0;
      Ligne:=reqEvInd.FieldByName('clef').AsInteger;
      Libelle:=lsNom;
      ImageIdx:=7;
     end;
//    iNoeudTitre.SelectedIndex:=iNoeudTitre.ImageIndex;
//    iNoeudTitre.StateIndex:=-1;
    repeat
      iNoeudEve:=tvSaVie.AddChild(iNoeudTitre,nil);
      tvSaVie.ValidateNode(iNoeudEve,False);
      with PVieTree(tvSaVie.GetNodeData(iNoeudEve))^ do
       begin
        cleID:=reqEvInd.FieldByName('clef').AsInteger;
        Sexe:=0;
        TypeTable:='EVENEMENTS_IND';
        Onglet:=_ONGLET_IDENTITE;
        Sosa:=0;
        Ligne:=reqEvInd.FieldByName('clef').AsInteger;
        Libelle:=reqEvInd.FieldByName('libelle').AsString;
        ImageIdx:=reqEvInd.FieldByName('categorie').AsInteger;

//      iNoeudEve.SelectedIndex:=iNoeudEve.ImageIndex;
  //    iNoeudEve.StateIndex:=reqEvIndstatus.AsInteger+7;
       end;

      reqMedias.ParamByName('table').AsString:='I';
      reqMedias.ParamByName('eve').AsInteger:=reqEvInd.FieldByName('CLEF').AsInteger;
      reqMedias.ExecQuery;
      with reqMedias do
      while not Eof do
       begin
        iNoeud:=tvSaVie.AddChild(iNoeudEve,nil);
        tvSaVie.ValidateNode(iNoeud,False);
        with PVieTree(tvSaVie.GetNodeData(iNoeud))^ do
         begin
          cleID:=FieldByName('clef').AsInteger;
          Sexe:=0;
          TypeTable:='EVENEMENTS_IND';
          Onglet:=_ONGLET_IDENTITE;
          Sosa:=0;
          Ligne:=reqEvInd.FieldByName('clef').AsInteger;
          Libelle:=StringReplace(FieldByName('libelle').AsString,_CRLF,' ',[rfReplaceAll]);
          ImageIdx:=FieldByName('type').AsInteger;
         end;
//        iNoeud.SelectedIndex:=iNoeud.ImageIndex;
   //     iNoeud.StateIndex:=-1;
        reqMedias.Next;
       end;
      reqMedias.Close;

      reqTemoins.ParamByName('table').AsString:='I';
      reqTemoins.ParamByName('eve').AsInteger:=reqEvInd.FieldByName('CLEF').AsInteger;
      reqTemoins.ExecQuery;
      with reqTemoins do
      if not Eof then
      begin
        iAjoute:=tvSaVie.AddChild(iNoeudEve,nil);
        tvSaVie.ValidateNode(iAjoute,False);
        with PVieTree(tvSaVie.GetNodeData(iAjoute))^ do
         begin
          lsNom:=rs_Witness;
          cleID:=reqEvInd.FieldByName('clef').AsInteger;
          Sexe:=0;
          TypeTable:='EVENEMENTS_IND';
          Onglet:=_ONGLET_IDENTITE;
          Sosa:=0;
          Ligne:=reqEvInd.FieldByName('clef').AsInteger;
          Libelle:=lsNom;
          ImageIdx:=5;
         end;
//        iAjoute.SelectedIndex:=iAjoute.ImageIndex;
 //       iAjoute.StateIndex:=-1;
        repeat
          iNoeud:=tvSaVie.AddChild(iAjoute,nil);
          tvSaVie.ValidateNode(iNoeud,False);
          with PVieTree(tvSaVie.GetNodeData(iNoeud))^ do
           begin
            cleID:=FieldByName('cle_fiche').AsInteger;
            Sexe:=FieldByName('SEXE').AsInteger;
            TypeTable:='EVENEMENTS_IND';
            Onglet:=_ONGLET_IDENTITE;
            Sosa:=FieldByName('SOSA').AsInteger;
            Ligne:=reqEvInd.FieldByName('clef').AsInteger;
            naissance:=FieldByName('NAISSANCE').AsString;
            deces:=FieldByName('DECES').AsString;
            Libelle:=FieldByName('NomPrenom').AsString
             +GetStringNaissanceDeces(naissance,deces)
              +', '+FieldByName('libelle').AsString;
            case FieldByName('SEXE').AsInteger of
              1:ImageIdx:=29;
              2:ImageIdx:=30;
              else
                ImageIdx:=31;
            end;
           end;
//         iNoeud.SelectedIndex:=iNoeud.ImageIndex;
//          iNoeud.StateIndex:=-1;
          Next;
        until Eof;
        if RecordCount>1 then
          PVieTree(tvSaVie.GetNodeData(iAjoute))^.Libelle:=rs_Witnesses;
      end;
      reqTemoins.Close;
      reqEvInd.Next;
    until reqEvInd.Eof;
    if reqEvInd.RecordCount>1 then
      PVieTree(tvSaVie.GetNodeData(iNoeudTitre))^.Libelle:=rs_Individual_events;
  end;
  reqEvInd.Close;

  reqDom.ParamByName('indi').AsInteger:=FFormIndividu.QueryIndividuCLE_FICHE.AsInteger;
  reqDom.ExecQuery;
  if not reqDom.Eof then
   begin
    iNoeudTitre:=tvSaVie.AddChild(iNoeudparent,nil);
    tvSaVie.ValidateNode(iNoeudTitre,False);
    with PVieTree(tvSaVie.GetNodeData(iNoeudTitre))^ do
     begin
      lsNom:='Domicile';
      cleID:=reqDom.FieldByName('clef').AsInteger;
      Sexe:=0;
      TypeTable:='ADRESSES_IND';
      Onglet:=_ONGLET_DOMICILES;
      Sosa:=0;
      Ligne:=0;
      Libelle:=lsNom;
      ImageIdx:=28;
     end;
//    iNoeudTitre.SelectedIndex:=iNoeudTitre.ImageIndex;
 //   iNoeudTitre.StateIndex:=-1;
    repeat
      iNoeudEve:=tvSaVie.AddChild(iNoeudTitre,nil);
      tvSaVie.ValidateNode(iNoeudEve,False);
      with PVieTree(tvSaVie.GetNodeData(iNoeudEve))^ do
       begin
        cleID:=reqDom.FieldByName('clef').AsInteger;
        Sexe:=0;
        TypeTable:='ADRESSES_IND';
        Onglet:=_ONGLET_DOMICILES;
        Sosa:=0;
        Ligne:=reqDom.FieldByName('clef').AsInteger;
        Libelle:=reqDom.FieldByName('libelle').AsString;
        ImageIdx:=26;
//      iNoeudEve.SelectedIndex:=iNoeudEve.ImageIndex;
     // iNoeudEve.StateIndex:=-1;
       end;

      reqMedias.ParamByName('table').AsString:='I';
      reqMedias.ParamByName('eve').AsInteger:=reqDom.FieldByName('CLEF').AsInteger;
      reqMedias.ExecQuery;
      with reqMedias do
      while not Eof do
      begin
        iNoeud:=tvSaVie.AddChild(iNoeudEve,nil);
        tvSaVie.ValidateNode(iNoeud,False);
        with PVieTree(tvSaVie.GetNodeData(iNoeud))^ do
         begin
          cleID:=FieldByName('clef').AsInteger;
          Sexe:=0;
          TypeTable:='ADRESSES_IND';
          Onglet:=_ONGLET_DOMICILES;
          Sosa:=0;
          Ligne:=reqDom.FieldByName('clef').AsInteger;
          Libelle:=StringReplace(FieldByName('libelle').AsString,_CRLF,' ',[rfReplaceAll]);
          ImageIdx:=FieldByName('type').AsInteger;
//        iNoeud.SelectedIndex:=iNoeud.ImageIndex;
   //     iNoeud.StateIndex:=-1;
         End;
        Next;
      end;
      reqMedias.Close;

      reqDom.Next;
    until reqDom.Eof;
    if reqDom.RecordCount>1 then
      PVieTree(tvSaVie.GetNodeData(iNoeudTitre))^.Libelle:='Domiciles';
  end;
  reqDom.Close;

  reqMediasInd.ParamByName('indi').AsInteger:=FFormIndividu.QueryIndividuCLE_FICHE.AsInteger;
  reqMediasInd.ExecQuery;
  with reqMediasInd do
  if not Eof then
   begin
    iNoeudTitre:=tvSaVie.AddChild(iNoeudparent,nil);
    tvSaVie.ValidateNode(iNoeudTitre,False);
    with PVieTree(tvSaVie.GetNodeData(iNoeudTitre))^ do
     begin
      lsNom:=rs_Individual_Media;
      cleID:=FieldByName('clef').AsInteger;
      Sexe:=0;
      TypeTable:='MEDIA_POINTEURS';
      Onglet:=_ONGLET_PHOTOS_DOCS;
      Sosa:=0;
      Ligne:=FieldByName('mp_clef').AsInteger;
      Libelle:=lsNom;
      ImageIdx:=27;
     end;
//    iNoeudTitre.SelectedIndex:=iNoeudTitre.ImageIndex;
//    iNoeudTitre.StateIndex:=-1;
    repeat
      iNoeud:=tvSaVie.AddChild(iNoeudTitre,nil);
      tvSaVie.ValidateNode(iNoeud,False);
      with PVieTree(tvSaVie.GetNodeData(iNoeud))^ do
       begin
        cleID:=FieldByName('clef').AsInteger;
        Sexe:=0;
        TypeTable:='MEDIA_POINTEURS';
        Onglet:=_ONGLET_PHOTOS_DOCS;
        Sosa:=0;
        Ligne:=FieldByName('mp_clef').AsInteger;
        Libelle:=StringReplace(FieldByName('libelle').AsString,_CRLF,' ',[rfReplaceAll]);
        ImageIdx:=FieldByName('type').AsInteger;
       end;
//      iNoeud.SelectedIndex:=iNoeud.ImageIndex;
  //    iNoeud.StateIndex:=-1;
      Next;
    until Eof;
    if RecordCount>1 then
      PVieTree(tvSaVie.GetNodeData(iNoeudTitre))^.Libelle:=rs_Individual_Medias;
  end;
  reqMediasInd.Close;

  bBloque:=false;
  tvSaVie.FullExpand;
  bBloque:=true;
  tvSaVie.FocusedNode := tvSaVie.RootNode;
  //tvSaVie.VisiblePath[tvSaVie.RootNode]:=true;
  tvSaVie.EnableAlign;
end;

procedure TFSaVie.FormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  Action:=caFree;
end;

procedure TFSaVie.FormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  tvSaVie .NodeDataSize := Sizeof(TVieTree)+1;
  fCanDeletionTV:=false;
  bBloque:=true;
  fFormIndividu:=TFIndividu(Owner);
  lNom.PopupMenu:=FFormIndividu.pmNom;
  lNom.OnMouseEnter:=FFormIndividu.lNomMouseEnter;
  lNom.OnMouseLeave:=FFormIndividu.lNomMouseLeave;
  lNom.OnMouseMove:=FFormIndividu.lNomMouseMove;
  lNom.OnClick:=FFormIndividu.lNomClick;
end;

function TFSaVie.doOpenQuerys:boolean;
begin
  doInit(FFormIndividu.CleFiche,FFormIndividu.aFIndividuIdentite.lTitre.Caption);
  result:=True;
end;

procedure TFSaVie.mOuvreDocumentClick(Sender:TObject);
begin
  // Matthieu
  p_CreateAndPreviewReport(tvSaVie, fs_RemplaceMsg(rs_Report_EveryThing_About,[lNom.Caption]));
end;

procedure TFSaVie.pmViePopup(Sender:TObject);
var
  cleID:integer;
begin
  Acte:=PVieTree(tvSaVie.GetNodeData(tvSaVie.FocusedNode))^;
  cleID:=Acte.cleID;
//  mOuvreDocument.Visible:=cleID>0;
  mVisualiseMedia.Visible:=Acte.ImageIdx in [4,14,17,18];
  mOuvrirFiche.Visible:=Acte.ImageIdx in [24,25,29,30,31];
  mOuvrirFiche.Enabled:=cleID>0;
end;

procedure TFSaVie.mOuvreClick(Sender:TObject);
begin
  OuvreObjetPointe;
end;

procedure TFSaVie.tvSaVieBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  with Sender,PVieTree(GetNodeData(Node))^, Sender.Canvas.Font do
   Begin
    if sosa=1 then
      Color:=clGreen
    else
      case  Sexe of
        1: Color:=gci_context.ColorHomme;
        2: Color:=gci_context.ColorFemme;
        else
          Color:=clWindowText;
      end;
    if Node = RootNode then
      Style:= [fsBold];
   end;
  if Sender.Selected[Node] then
    Sender.Canvas.Brush.Color:=gci_context.ColorMedium;
end;

procedure TFSaVie.tvSaVieDblClick(Sender:TObject);
begin
  if assigned ( tvSaVie.FocusedNode ) Then
   Begin
    Acte:=PVieTree(tvSaVie.GetNodeData(tvSaVie.FocusedNode))^;
    OuvreObjetPointe;
   end;
end;

procedure TFSaVie.OuvreObjetPointe;
var
  cleID,Onglet
  ,ligne:integer;
  TypeTable:string;
begin
  cleID:=Acte.cleID;
  TypeTable:=Acte.TypeTable;
  Onglet:=Acte.Onglet;
  ligne:=Acte.Ligne;

  FFormIndividu.doActiveOnglet(Onglet);

  if cleID>0 then
  begin
    if (TypeTable='T_UNION')and(ligne>=0) then //sélectionner l'union dans l'onglet Unions
      FFormIndividu.aFIndividuUnion.doGoto(ligne)
    else if TypeTable='EVENEMENTS_IND' then //sélectionner l'événement dans l'onglet Identité
      FFormIndividu.aFIndividuIdentite.doGoto(ligne)
    else if TypeTable='MEDIA_POINTEURS' then //sélectionner le média dans l'onglet Médias
      FFormIndividu.aFIndividuPhotosEtDocs.doGoto(ligne)
    else if TypeTable='ADRESSES_IND' then //sélectionner l'adresse dans l'onglet Domiciles
      FFormIndividu.aFIndividuDomiciles.doGoto(ligne);
  end;
end;

procedure TFSaVie.SuperFormShow(Sender:TObject);
begin
  if tvSaVie.ChildCount[tvSaVie.RootNode]>0 then
    tvSaVie.Selected[tvSaVie.RootNode.FirstChild]:=true;
end;

procedure TFSaVie.SuperFormShowFirstTime(Sender:TObject);
begin
  fCanDeletionTV:=true;
end;

procedure TFSaVie.tvSaVieCustomDrawItem(Sender:TCustomTreeView;
  Node:TTreeNode;State:TCustomDrawState;var DefaultDraw:Boolean);
begin
end;

procedure TFSaVie.mVisualiseMediaClick(Sender:TObject);
begin
  VisualiseMedia(Acte.cleID,dm.ReqSansCheck);
end;

procedure TFSaVie.mOuvrirFicheClick(Sender:TObject);
begin
  dm.individu_clef:=Acte.cleID;
  DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
end;

procedure TFSaVie.tvSaVieExpanding(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
begin
  if (Xmouse>(GetNodeLevel(Node,tvSaVie.RootNode)+1)*tvSaVie.Indent)and bBloque then
    Allowed:=false;
end;

procedure TFSaVie.tvSaVieMouseMove(Sender:TObject;Shift:TShiftState;X,
  Y:Integer);
var
  Noeud:PVirtualNode;
begin
  Noeud:=tvSaVie.GetNodeAt(X,Y);
  pmVie.AutoPopup:=Noeud<>nil;
  if Noeud<>nil then
    tvSaVie.Cursor:=_CURPOPUP
  else
    tvSaVie.Cursor:=crDefault;
  Xmouse:=X;
end;

procedure TFSaVie.tvSaVieGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex:=PVieTree(Sender.GetNodeData(Node))^.ImageIdx;
end;

procedure TFSaVie.tvSaVieGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
begin
  CellText:=PVieTree(sender.GetNodeData(Node))^.Libelle;
end;


procedure TFSaVie.tvSaVieMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Noeud:PVirtualNode;
begin
  Noeud:=tvSaVie.GetNodeAt(X,Y);
  if Noeud<>nil then
    tvSaVie.Selected[Noeud]:=True;
end;

end.

