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

unit u_form_arbre;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows, ExtJvXPCheckCtrls,
{$ELSE}
  ExtJvXPCheckCtrls,
{$ENDIF}
  PrintersDlgs,U_FormAdapt, VirtualTrees,
  u_comp_TYLanguage,Menus,
  CompSuperForm,
  StdCtrls,Classes,ExtCtrls,Graphics,
  u_framework_components, U_OnFormInfoIni,IBSQL;

type
  TMyPopupMenu=class(TPopupMenu)

  public
    property PopupPoint;
  end;

  TIndividu=record
    Nom,
    Prenom,
    Deces,
    Naissance,
    SOSA,
    Implexe:string;
    ImageIndex,
    Sexe,
    CleFiche,
    Level:integer;
  End;
  PIndividu=^TIndividu;

  { TFArbre }

  TFArbre=class(TF_FormAdapt)
    cbDescendance: TJvXPCheckbox;
    dxsGenerations: TFWSpinEdit;
    frbHorizontal: TRadioButton;
    frbVertical: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    lHint: TLabel;
    lNom: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    IBSTree: TIBSQL;
    oc:TVirtualStringTree;
    OnFormInfoIni: TOnFormInfoIni;
    Panel6: TPanel;
    pmArbre:TPopupMenu;
    Panel10:TPanel;
    Language:TYLanguage;
    Panel1:TPanel;
    dxComponentPrinter1:TPrinterSetupDialog;
    option_OpenFiche:TMenuItem;
    option_OpenFicheInBox:TMenuItem;
    IBQEnfants:TIBSQL;
    sp_fontsize: TFWSpinEdit;
    procedure ocGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure sp_fontsizeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure ocGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; const P: TPoint; var AskParent: Boolean;
      var PopupMenu: TPopupMenu);
    procedure ocGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure ocPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure SuperFormDestroy(Sender:TObject);
    procedure frbHorizontalClick(Sender:TObject);
    procedure cbZoomClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure dxsGenerationsChange(Sender:TObject);
    procedure frbVerticalClick(Sender:TObject);
    procedure option_OpenFicheClick(Sender:TObject);
    procedure option_OpenFicheInBoxClick(Sender:TObject);
    procedure option_PrintClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure cbDescendanceClick(Sender:TObject);
    procedure ocMouseMove(Sender:TObject;Shift:TShiftState;X,
      Y:Integer);

  private
    fStartIndividu:PIndividu;
    FGenerations : Integer;
    FDescendance : Boolean;
    fAll:TList;
    fCleIndiDepart:integer;
    GFormIndividu : TSuperForm;

    procedure GetPere(const Clef:integer; Anode : PVirtualNode; var AnodeFound : PVirtualNode);

    procedure doAscendance;
    procedure doDescendance;
    procedure Show_Arbre;

  public
    property CleIndiDepart:integer read fCleIndiDepart write fCleIndiDepart;
    procedure Init_Arbre;
    procedure Refresh_Arbre;

  end;

implementation

uses u_dm,u_form_individu,u_common_functions,u_common_ancestro,u_common_const,
{$IFDEF FPC}
     LCLProc,
{$ENDIF}
     u_genealogy_context,u_Form_Main,
     u_common_ancestro_functions,
     u_common_resources;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFArbre.Init_Arbre;
begin
  oc.NodeDataSize := Sizeof(TIndividu)+1;
  if GFormIndividu=nil then
  begin
    fCleIndiDepart:=dm.individu_clef;
  end
  else
  begin
    fCleIndiDepart:=TFIndividu(GFormIndividu).CleFiche;
  end;

  dxsGenerations.Value:=gci_context.ArbreReduit;//AL mis là et une seule fois pour remplacer les 4 autres
End;

procedure TFArbre.Refresh_Arbre;
begin
  if     ( cbDescendance  .Checked  = FDescendance )
      and assigned ( fStartIndividu )
      and ( fStartIndividu^.CleFiche = fCleIndiDepart )
      and ( FGenerations=dxsGenerations.Value)
   Then
    Begin
      Exit;
    end;

  Show_Arbre;

end;
procedure TFArbre.Show_Arbre;
begin
  if not Visible
   Then Exit;

  FGenerations := dxsGenerations.Value;
  FDescendance := cbDescendance.Checked;

  oc.Clear;
  fAll.Clear;

  //On charge les individus
  dm.IBTrans_Courte.StartTransaction;

  try
    if cbDescendance.Checked then
      doDescendance
    else
      doAscendance;
  finally
    IBSTree.Close;
    dm.IBTrans_Courte.Commit;
  end;
  if GFormIndividu=nil then
    lNom.Caption:=CoupeChaine(AssembleString([fStartIndividu.Nom,fStartIndividu.Prenom]),lNom);

  oc.FullExpand;

end;

procedure TFArbre.doAscendance;
var
  Alevel,ACleFiche:integer;
  descendant:integer;
  indi,
  indiParent:PVirtualNode;
begin
  //On charge les individus
  with IBSTree do
  Begin
    SQL.Text :='SELECT t.tq_niveau'
      +',t.tq_cle_fiche'
      +',i.NOM'
      +',i.PRENOM'
      +',i.SEXE'
      +',i.DATE_NAISSANCE'
      +',i.DATE_DECES'
      +',t.IMPLEXE'
      +',t.tq_descendant'
      +',t.tq_sosa'
      +' FROM PROC_TQ_ASCENDANCE(:I_CLEF,:I_NIVEAU,0,1) t'
      +' inner join individu i on i.cle_fiche=t.tq_cle_fiche'
      +' ORDER BY t.tq_niveau,t.tq_sosa';
    ParamByName('I_CLEF').asInteger:=fCleIndiDepart;
    ParamByName('I_NIVEAU').asInteger:=FGenerations-1;
    ExecQuery;

    with oc do
    while not Eof do
    begin
      ALevel:=FieldByName('tq_niveau').AsInteger;
      ACleFiche:=FieldByName('tq_cle_fiche').AsInteger;
      descendant:=FieldByName('tq_descendant').AsInteger;
      if Alevel=0 then
      begin
        //celui de départ
        indi := AddChild(nil,nil);
        ValidateNode ( indi, False );
        fStartIndividu:=PIndividu ( GetNodeData(indi));
        indiParent:=nil;
      end
      else
      begin
        indiParent:=nil;
        GetPere(descendant,RootNode,indiParent);//AL2009
        indi := AddChild(indiParent,nil);
        ValidateNode ( indi, False );
      end;
      fAll.Add(GetNodeData(indi));

      with PIndividu ( GetNodeData(indi))^ do
       Begin
        Sexe:=FieldByName('SEXE').AsInteger;
        CleFiche:=ACleFiche;
        level:=Alevel;
        Nom:=FieldByName('NOM').AsString;
        Prenom:=FieldByName('PRENOM').AsString;
        Naissance:=FieldByName('DATE_NAISSANCE').AsString;
        Deces:=FieldByName('DATE_DECES').AsString;
        SOSA:=FieldByName('TQ_SOSA').AsString;
        Implexe:=FieldByName('IMPLEXE').AsString;
       end;


      next;
    end;

  end;

  //on s'assure que les hommes sont à droite, et les femmes à gauche
  //fStartIndividu.OrdreHommeFemme;//pas nécessaire fait par order by sosa

end;

{
procedure TFArbre.ocBeforeCellPaint(Sender: TBaseVirtualTree;
  ACanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  y:integer;
  s:String;
begin
  if oc.GetNodeData(Node)<>nil then
  with PIndividu(oc.GetNodeData(Node))^, Sender.Font do
  begin
    if Implexe>''
     then Style:=Style+ [fsItalic,fsBold];
    //Brush.Style:=bsClear;

    //Brush.Color:=Color;
   // if Implexe='' then
    // Begin
    //   ACanvas.FillRect(CellRect);
    // end;

    if Sexe=1 then
      Color:=gci_context.ColorHomme //$00F6CA92//
    else
      Color:=gci_context.ColorFemme; // $00B5A7F2

    if Implexe>'' then
     Begin
      ACanvas.Pen.Color := Color;
      ACanvas.FillRect(CellRect);
     End;
  end;
end;
   }


procedure TFArbre.FormShow(Sender: TObject);
begin
  Init_Arbre;
  Show_Arbre;
  sp_fontsize.Value := oc.Font.Size;
end;

procedure TFArbre.Label2Click(Sender: TObject);
begin

end;


procedure TFArbre.FormCreate(Sender: TObject);
begin

  GFormIndividu:=owner as TSuperForm;

  fStartIndividu := nil ;

  fCleIndiDepart:=-1;
  FGenerations := 0;
  FDescendance := False;

{ Matthieu ?
  if gci_context.ArbreHorizontal then
  begin
    frbHorizontal.Checked:=true;
    oc.TreeOptions:=True;
  end
  else
  begin
    frbVertical.Checked:=true;
    oc.Rotated:=False;
  end;}
  lNom.PopupMenu:=TFIndividu(GFormIndividu).pmNom;
  lNom.OnMouseEnter:=TFIndividu(GFormIndividu).lNomMouseEnter;
  lNom.OnMouseLeave:=TFIndividu(GFormIndividu).lNomMouseLeave;
  lNom.OnMouseMove:=TFIndividu(GFormIndividu).lNomMouseMove;
  lNom.OnClick:=TFIndividu(GFormIndividu).lNomClick;
  fAll:=TList.create;
  Panel10.Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  OnShowFirstTime:=SuperFormShowFirstTime;
  OnRefreshControls:=SuperFormRefreshControls;
end;

procedure TFArbre.sp_fontsizeChange(Sender: TObject);
begin
  if oc.Font.Size <> sp_fontsize.Value Then
   Begin
    oc.Font.Size := sp_fontsize.Value;
    oc.DefaultNodeHeight:=oc.Canvas.TextHeight('W')+2;
    Refresh_Arbre;
   end;
end;

procedure TFArbre.ocGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
  var ImageIndex: Integer);
begin
  ImageIndex:=PIndividu(oc.GetNodeData(Node))^.ImageIndex;
end;

procedure TFArbre.ocGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; const P: TPoint; var AskParent: Boolean;
  var PopupMenu: TPopupMenu);
var
  indi:TIndividu;
  NewItem:TMenuItem;

begin
  pmArbre.Items.Clear;

  NewItem:=TMenuItem.create(self);
  pmArbre.Items.Add(NewItem);
  NewItem.Name:='option_Print';
  NewItem.Caption:=rs_Caption_Print_this_tree;
  NewItem.ImageIndex:=6;
  NewItem.Onclick:=option_PrintClick;

  NewItem:=TMenuItem.create(self);
  pmArbre.Items.Add(NewItem);
  NewItem.Name:='option_OpenFicheInBox';
  NewItem.Caption:=rs_Caption_Look_at_person_s_file;
  NewItem.ImageIndex:=1;
  NewItem.Onclick:=option_OpenFicheInBoxClick;

  NewItem:=TMenuItem.create(self);
  pmArbre.Items.Add(NewItem);
  NewItem.Caption:='-';

  NewItem:=TMenuItem.create(self);
  pmArbre.Items.Add(NewItem);
  NewItem.Name:='option_OpenFiche';
  NewItem.Caption:=rs_Caption_Open_the_person_s_file;
  NewItem.ImageIndex:=86;
  NewItem.Onclick:=option_OpenFicheClick;

  NewItem:=TMenuItem.create(self);
  pmArbre.Items.Add(NewItem);
  NewItem.Caption:='-';

  option_OpenFiche.visible:=false;
  option_OpenFicheInBox.visible:=false;

  if Node<>nil then
    begin
      indi:=PIndividu(oc.GetNodeData(Node))^;

      option_OpenFiche.Tag:=indi.CleFiche;
      option_OpenFicheInBox.Tag:=indi.CleFiche;
      option_OpenFiche.visible:=indi.CleFiche<>fCleIndiDepart;
      option_OpenFicheInBox.visible:=true;

      dm.IBTrans_Courte.StartTransaction;
      try
        with IBQEnfants do
        begin
          SQL.Clear;
          SQL.Add('select i.cle_fiche,i.nom,i.prenom,i.sexe from individu i'
            +' left join evenements_ind n on n.ev_ind_kle_fiche=i.cle_fiche and n.ev_ind_type=''BIRT''');
          if indi.Sexe=1 then
          begin
            SQL.Add('where i.cle_pere=:clef');
          end
          else
          begin
            SQL.Add('where i.cle_mere=:clef');
          end;
          SQL.Add('order by i.annee_naissance,n.ev_ind_date_mois,n.ev_ind_date');
          Params[0].AsInteger:=indi.CleFiche;
          ExecQuery;
          if not Eof then
          begin
            NewItem:=TMenuItem.create(self);
            pmArbre.Items.Add(NewItem);
            NewItem.Caption:='-';
            while not Eof do
            begin
              NewItem:=TMenuItem.create(self);
              pmArbre.Items.Add(NewItem);
              NewItem.Tag:=FieldByName('CLE_FICHE').AsInteger;
              NewItem.Caption:=AssembleString([FieldByName('NOM').AsString,FieldByName('PRENOM').AsString]);
              NewItem.Onclick:=option_OpenFicheClick;
              if FieldByName('SEXE').AsInteger=1 then
                NewItem.ImageIndex:=39
              else if FieldByName('SEXE').AsInteger=2 then
                NewItem.ImageIndex:=38
              else
                NewItem.ImageIndex:=36;
              next;
            end;
          end;
        end;
      finally
        IBQEnfants.Close;
        dm.IBTrans_Courte.Commit;
      end;
    end;

end;


procedure TFArbre.ocGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
begin
  with Sender, PIndividu ( GetNodeData(Node))^ do
    Begin
      if SOSA>''
       then CellText:='['+SOSA+'] '
       Else CellText:='';
      CellText := CellText+Nom;
      CellText := CellText + ' ' + Prenom;
      if Length(CellText)>0 then
      begin
        if UTF8Length(CellText)>30 then
          CellText:=UTF8Copy(CellText,1,30)+CST_THREE_POINTS;
      end;
      if Naissance>'' then
        CellText:=CellText+'°'+Naissance;

      if Deces>'' then
        CellText:=CellText+'†'+Deces;
    end;
end;

procedure TFArbre.ocPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  y:integer;
  s:String;
begin
  if oc.GetNodeData(Node)<>nil then
  with PIndividu(oc.GetNodeData(Node))^,TargetCanvas, Font do
  begin
    if Implexe>''
     then Style:=[fsItalic,fsBold]
     else Style:=[fsBold];

   // Brush.Style:=bsClear;

   // Brush.Color:=Color;
   // if Implexe='' then
   //    TargetCanvas.FillRect(ItemRect);

    if Sexe=1 then
      Color:=gci_context.ColorHomme //$00F6CA92//
    else
      Color:=gci_context.ColorFemme; // $00B5A7F2

  end;

end;

procedure TFArbre.SuperFormDestroy(Sender:TObject);
begin
  fAll.free;
end;

{procedure TIndividu.OrdreHommeFemme;
var
  n:integer;
begin
  case Childs.count of
    2:
      begin
        if TIndividu(Childs[0]).Sexe=2 then //homme
        begin
            //invertion
          Childs.Exchange(0,1);
        end;
      end;
  end;

  //on ordonne les suivants
  for n:=0 to Childs.count-1 do
    TIndividu(Childs[n]).OrdreHommeFemme;
end;}

procedure TFArbre.GetPere(const Clef:integer; Anode : PVirtualNode; var AnodeFound : PVirtualNode);
var
  n:integer;
begin
  Anode:=Anode.FirstChild;
  while Assigned(Anode) do
  begin
    if PIndividu(oc.GetNodeData(Anode))^.CleFiche=Clef then
    begin
      AnodeFound:=anode;
      break;
    end
    else
     GetPere(Clef,Anode,AnodeFound);

    if AnodeFound <> nil Then Exit;

    Anode:=Anode.NextSibling;
  end;
end;
procedure TFArbre.frbHorizontalClick(Sender:TObject);
begin
{  oc.Rotated:=True;
  gci_context.ShouldSave:=true;
  gci_context.ArbreHorizontal:=true;}
end;

procedure TFArbre.cbZoomClick(Sender:TObject);
begin
//  Oc.Zoom:=not cbZoom.Checked;
end;

procedure TFArbre.SuperFormShowFirstTime(Sender:TObject);
begin
  if GFormIndividu=nil then
    oc.TreeOptions.SelectionOptions:=oc.TreeOptions.SelectionOptions- [toExtendedFocus]
  else
    oc.TreeOptions.SelectionOptions:=oc.TreeOptions.SelectionOptions+ [toExtendedFocus];

  doRefreshControls;
end;

procedure TFArbre.dxsGenerationsChange(Sender:TObject);
begin
  Refresh_Arbre;
  gci_context.ArbreReduit:=dxsGenerations.Value;
  gci_context.ShouldSave:=true;
end;

procedure TFArbre.frbVerticalClick(Sender:TObject);
begin
{  oc.Rotated:=False;
  gci_context.ShouldSave:=true;
  gci_context.ArbreHorizontal:=false;}
end;


procedure TFArbre.option_OpenFicheClick(Sender:TObject);
begin
  with oc do
  if assigned ( FocusedNode ) Then
   Begin
    dm.individu_clef:=PIndividu ( GetNodeData( FocusedNode))^.CleFiche;
    DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
    fCleIndiDepart:=dm.individu_clef;
    if GFormIndividu<>nil then
      TFIndividu(GFormIndividu).doOpenFiche(fCleIndiDepart);

    Refresh_Arbre;
   end;
end;

procedure TFArbre.option_OpenFicheInBoxClick(Sender:TObject);
begin
  with oc do
  if assigned ( FocusedNode ) Then
    OpenFicheIndividuInBox(PIndividu ( GetNodeData(FocusedNode))^.CleFiche);
end;

procedure TFArbre.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  case Key of
    _KEY_HELP:p_ShowHelp(_ID_ARBRE);
  end;
end;

procedure TFArbre.SuperFormRefreshControls(Sender:TObject);
begin
//  oc.TreeOptions.PaintOptions:= [toocu_buttons_flat,ocDblClick,ocRect3D];
//  oc.TreeOptions.PaintOptions:= [ocButtons,ocDblClick,ocRect3D];
end;

procedure TFArbre.doDescendance;
var
  level,ACleFiche:integer;
  ascendant:integer;
  indi,indiParent:PVirtualNode;
begin

  with IBSTree do
  Begin
    SQL.Text :='select t.tq_niveau,t.tq_cle_fiche,t.tq_ascendant'
      +',i.sexe,i.nom,i.prenom,i.date_naissance,i.date_deces,t.tq_num_sosa'
      +' from PROC_TQ_DESCENDANCE(:I_CLEF,:I_NIVEAU,0,1) t'
      +' inner join individu i on i.cle_fiche=t.tq_cle_fiche'
      +' ORDER BY t.TQ_NIVEAU,t.tq_num_sosa';//AL2009

    Params[0].AsInteger:=fCleIndiDepart;
    Params[1].AsInteger:=dxsGenerations.Value;

    ExecQuery;

    with oc do
    while not Eof do
    begin
      Level:=FieldByName('tq_niveau').AsInteger;
      ACleFiche:=FieldByName('tq_cle_fiche').AsInteger;
      ascendant:=FieldByName('tq_ascendant').AsInteger;
      if level=1 then
      //celui de départ
      begin
        //celui de départ
        indi := AddChild(nil,nil);
        ValidateNode ( indi, False );
        fStartIndividu:=PIndividu ( GetNodeData(indi));
      end
      else
      begin
        indiParent:=nil;
        GetPere(ascendant,RootNode,indiParent);//AL2009
        indi := AddChild(indiParent,nil);
        ValidateNode ( indi, False );
      end;
      fAll.Add(GetNodeData(indi));

      with PIndividu ( GetNodeData(indi))^ do
       Begin
        Sexe:=FieldByName('SEXE').AsInteger;

        CleFiche:=ACleFiche;
        level:=level;
        Nom:=FieldByName('NOM').AsString;
        Prenom:=FieldByName('PRENOM').AsString;
        Naissance:=FieldByName('DATE_NAISSANCE').AsString;
        Deces:=FieldByName('DATE_DECES').AsString;
        SOSA:=FieldByName('tq_num_sosa').AsString;
       end;

      next;
    end;

  end;

  //on s'assure que les hommes sont à droite, et les femmes à gauche
  //fStartIndividu.OrdreHommeFemme; //pas pour la descendance!

  //Create
end;

procedure TFArbre.cbDescendanceClick(Sender:TObject);
begin
  Refresh_Arbre;
end;

procedure TFArbre.ocMouseMove(Sender:TObject;Shift:TShiftState;X,
  Y:Integer);
var
  indi:TIndividu;
  LHitinfo : THitInfo;
begin
  oc.GetHitTestInfoAt(X,Y,False,LHitinfo);
  with LHitinfo do
  if ( HitNode <> nil ) then
    begin
      indi:=PIndividu(oc.GetNodeData(HitNode))^;
      if lHint.Caption<>indi.Nom+', '+indi.Prenom then
      begin
        if indi.Sexe=1 then
          lHint.Font.Color:=gci_context.ColorHomme
        else
          lHint.Font.Color:=gci_context.ColorFemme;

        lHint.Caption:=indi.Nom+', '+indi.Prenom;
      end;
    end
  else
    lHint.Caption:='';
end;

procedure TFArbre.option_PrintClick(Sender:TObject);
var
  bZoom:Boolean;
begin
  // Matthieu ?
//  bZoom:=oc.Zoom;
//  oc.Options:= [];
//  oc.Zoom:=False;
//  dxComponentPrinter1.Preview(True,nil);
  DoRefreshControls;
//  oc.Zoom:=bZoom;
end;

end.

