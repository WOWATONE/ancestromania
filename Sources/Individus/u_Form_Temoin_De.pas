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

unit u_Form_Temoin_De;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,
  PrintersDlgs,Controls,graphics,
  u_comp_TYLanguage,Menus,
  IBQuery,ExtCtrls,StdCtrls,Classes, u_ancestropictimages,
  u_buttons_appli,ExtJvXPButtons,
  VirtualTrees, IBSQL;

type
  { TFTemoinDe }

  TFTemoinDe=class(TF_FormAdapt)
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    fpBoutons:TPanel;
    pBottom:TPanel;
    pmTV:TPopupMenu;
    mFiche:TMenuItem;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    Language:TYLanguage;
    Label1:TLabel;
    tv:TVirtualStringTree;
    dxComponentPrinter1:TPrinterSetupDialog;
    GoodBtn7:TJvXPButton;
    btnPrint:TFWPrint;
    QTemoins:TIBQuery;
    IBDetail:TIBSQL;
    rbDate: TRadioButton;
    rbNom: TRadioButton;

    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mFicheClick(Sender:TObject);
    procedure tvBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure tvMouseMove(Sender:TObject;Shift:TShiftState;X,
      Y:Integer);
    procedure btnPrintClick(Sender:TObject);
    procedure rbNomClick(Sender: TObject);
  private
    fCleFicheSelected:integer;
    liClefRecu:integer;
    CurNodeC:PVirtualNode;
    psNom:string;
    procedure RemplirTV;
  public
    property CleFicheSelected:integer read fCleFicheSelected write fCleFicheSelected;
    procedure doInit(sNom:string;iClefRecu:integer);
  end;

implementation

uses u_common_const,u_common_functions,
     u_genealogy_context,u_common_treeind;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFTemoinDe.SuperFormCreate(Sender:TObject);
begin
  tv .NodeDataSize := Sizeof(TNodeIndividu)+1;
  Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  CurNodeC:=nil;
  Height:=round(TControl(Owner).height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).width*gci_context.TailleFenetre/100);
end;

procedure TFTemoinDe.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
var
  i:integer;
begin
  tv.Clear;
{  try
    for i:=tv.Nodes.Count-1 downto 0 do
    begin
      if tv.Nodes.Items[i].Data<>nil then
        Dispose(tv.Nodes.Items[i].Data);
    end;
    tv.Clear;
  finally
    tv.EndUpdate;
  end;    }
  ModalResult:=mrCancel;
end;

procedure TFTemoinDe.sbCloseClick(Sender:TObject);
begin
  Close;
end;


procedure TFTemoinDe.mFicheClick(Sender:TObject);
var
  aNodeIndividu:TNodeIndividu;
  aNode:PVirtualNode;
begin
  if (Tv.FocusedNode<>nil)and(Tv.FocusedNode.Parent<>nil) then
  begin
    aNode:=Tv.FocusedNode;
    if aNode.Parent<>nil then
      aNode:=Tv.FocusedNode.Parent;

    if (tv.GetNodeData(aNode)<>nil)and(aNode.Parent=nil) then
    begin
      //on récupère l'objet de stockage de l'individu
      aNodeIndividu:=PNodeIndividu(tv.GetNodeData(aNode))^;
      fCleFicheSelected:=aNodeIndividu.fCleFiche;
    end;
  end;
  ModalResult:=mrOk;
end;

procedure TFTemoinDe.tvBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  DBNodeData : PNodeIndividu;
begin
  if tv.FocusedNode = Node then
     TargetCanvas.Brush.color :=tv.Colors.FocusedSelectionColor
   else
     TargetCanvas.Brush.Color :=clWhite;

   if Node=CurNodeC then
     TargetCanvas.Font.Style:= [fsUnderline]
   else
     TargetCanvas.Font.Style:= [];
   DBNodeData:=PNodeIndividu(tv.GetNodeData(Node));
   if DBNodeData<>nil then
   with DBNodeData^ do
   begin
     // Matthieu
     if fSosa=1 then
       TargetCanvas.Font.Color:=_COLOR_SOSA
     else
     begin
       case fSexe of
         1:TargetCanvas.Font.Color:=gci_context.ColorHomme;
         2:TargetCanvas.Font.Color:=gci_context.ColorFemme;
       else
         TargetCanvas.Font.Color:=clWindowText;
       end;
     end;
   end
   else
     TargetCanvas.Font.Color:=clWindowText;
end;

procedure TFTemoinDe.doInit(sNom:string;iClefRecu:integer);
begin
  Caption:=sNom;
  psNom:=sNom;
  liClefRecu:=iClefRecu;
  RemplirTV;
end;

procedure TFTemoinDe.RemplirTV;
const
  TextReq='select cle_fiche,nom,prenom,sexe,sosa,periodevie,min(datecode)'
    +' from (select i.cle_fiche,i.nom,i.prenom,i.sexe,iif(i.num_sosa>0,1,0)as sosa'
    +',iif(i.annee_naissance is null and i.annee_deces is null,null,''('''
    +'  ||coalesce(''°''||cast(i.annee_naissance as varchar(5))||''†''||cast(i.annee_deces as varchar(5))'
    +'  ,coalesce(''°''||cast(i.annee_naissance as varchar(5)),''†''||cast(i.annee_deces as varchar(5))))||'')'') as periodevie'
    +',coalesce(e.ev_fam_datecode,0x7FFFFFFF) as datecode'
    +' from t_associations a'
    +' inner join evenements_fam e on e.ev_fam_clef=a.assoc_kle_ind'
    +' inner join t_union u on u.union_clef=e.ev_fam_kle_famille'
    +' inner join individu i on i.cle_fiche=u.union_mari'
    +' where a.assoc_kle_associe=:i_clef'
    +' and a.assoc_table=''U'''
    +' union select i.cle_fiche,i.nom,i.prenom,i.sexe,iif(i.num_sosa>0,1,0)'
    +',iif(i.annee_naissance is null and i.annee_deces is null,null,''('''
    +'  ||coalesce(''°''||cast(i.annee_naissance as varchar(5))||''†''||cast(i.annee_deces as varchar(5))'
    +'  ,coalesce(''°''||cast(i.annee_naissance as varchar(5)),''†''||cast(i.annee_deces as varchar(5))))||'')'')'
    +',coalesce(e.ev_fam_datecode,0x7FFFFFFF)'
    +' from t_associations a'
    +' inner join evenements_fam e on e.ev_fam_clef=a.assoc_kle_ind'
    +' inner join t_union u on u.union_clef=e.ev_fam_kle_famille'
    +' inner join individu i on i.cle_fiche=u.union_femme'
    +' where a.assoc_kle_associe=:i_clef'
    +' and a.assoc_table=''U'''
    +' union select i.cle_fiche,i.nom,i.prenom,i.sexe,iif(i.num_sosa>0,1,0)'
    +',iif(i.annee_naissance is null and i.annee_deces is null,null,''('''
    +'  ||coalesce(''°''||cast(i.annee_naissance as varchar(5))||''†''||cast(i.annee_deces as varchar(5))'
    +'  ,coalesce(''°''||cast(i.annee_naissance as varchar(5)),''†''||cast(i.annee_deces as varchar(5))))||'')'')'
    +',coalesce(e.ev_ind_datecode,0x7FFFFFFF)'
    +' from t_associations a'
    +' inner join evenements_ind e on e.ev_ind_clef=a.assoc_evenement'
    +' inner join individu i on i.cle_fiche=a.assoc_kle_ind'
    +' where a.assoc_kle_associe=:i_clef'
    +' and a.assoc_table=''I'')'
    +' group by cle_fiche,nom,prenom,sexe,sosa,periodevie';
var
  i:integer;
  s:string;
  NoeudIndi,NodeEv:PVirtualNode;
  DataIndi:TNodeIndividu;
begin
  QTemoins.Open;
  {
  try
    for i:=tv.Nodes.Count-1 downto 0 do
    begin
      if tv.Nodes.Items[i].Data<>nil then
        Dispose(tv.Nodes.Items[i].Data);
    end;
    tv.Clear;
    QTemoins.Close;
    QTemoins.SQL.Text:=TextReq;
    if rbNom.Checked then
      QTemoins.SQL.Add('order by 2,3,1')
    else
      QTemoins.SQL.Add('order by 7');
    QTemoins.ParamByName('i_clef').AsInteger:=liClefRecu;
    QTemoins.ExecQuery;
    while not QTemoins.Eof do
    begin
      s:=AssembleString([QTemoinsNOM.AsString
        ,QTemoinsPRENOM.AsString])+' '+QTemoinsperiodevie.AsString;

      DataIndi:=TNodeIndividu.create;
      DataIndi.CleFiche:=QTemoinsCLE_FICHE.AsInteger;
      DataIndi.Sexe:=QTemoinsSEXE.AsInteger;
      DataIndi.Sosa:=QTemoinsSOSA.AsInteger;

      NoeudIndi:=tv.Add;

      NoeudIndi.Values[0]:=s;
      NoeudIndi.Data:=DataIndi;

      case QTemoinsSEXE.AsInteger of
        1:NoeudIndi.ImageIndex:=15;
        2:NoeudIndi.ImageIndex:=16;
      else
        NoeudIndi.ImageIndex:=31;
      end;
      NoeudIndi.SelectedIndex:=NoeudIndi.ImageIndex;

      IBDetail.close;
      IBDetail.Params[0].AsInteger:=liClefRecu;
      IBDetail.Params[1].AsInteger:=QTemoinsCLE_FICHE.AsInteger;
      IBDetail.ExecQuery;
      while not IBDetail.Eof do
      begin
        s:=AssembleString([IBDetailREF_EVE_LIB_LONG.AsString,
          IBDetailDESCRIPTION.AsString,
          IBDetailEV_FAM_DATE_WRITEN.AsString,
          IBDetailCP.AsString,
          IBDetailVille.AsString]);

        if Length(IBDetailQUOI.AsString)>0 then
          s:=s+' - En tant que '+IBDetailQUOI.AsString;

        NodeEv:=NoeudIndi.AddChild;
        NodeEv.Values[0]:=s;
        NodeEv.ImageIndex:=IBDetailIMAGE.AsInteger;
        NodeEv.SelectedIndex:=NodeEv.ImageIndex;
        IBDetail.Next;
      end;
      IBDetail.Close;

      QTemoins.next;
    end;
    QTemoins.Close;
  finally
    tv.FullExpand;
    tv.EndUpdate;
  end;       }
end;

procedure TFTemoinDe.tvMouseMove(Sender:TObject;Shift:TShiftState;X,
  Y:Integer);
var
  ARect:TRect;
  AColumn:Integer;
  ANode:PVirtualNode;
begin
  ANode:=tv.GetNodeAt(X,Y);
  AColumn:=ANode^.Index;

  if (aNode<>nil) then
    if (aNode.Parent=nil) then
    begin
//      ARect:=tv.GetnodEditRect(ANode,AColumn);
//      if PtInRect(ARect,Point(X,Y)) then
      begin
        tv.Cursor:=5;//crHandPoint;
        CurNodeC:=ANode;
        tv.Invalidate;
  {    end
      else
      begin
        tv.Cursor:=crDefault;
        if CurNodeC<>nil then
        begin
          CurNodeC:=nil;
          tv.Invalidate;
        end;}
      end;
    end
    else
    begin
      tv.Cursor:=crDefault;
      if CurNodeC<>nil then
      begin
        CurNodeC:=nil;
        tv.Invalidate;
      end;
    end;
end;

procedure TFTemoinDe.btnPrintClick(Sender:TObject);
begin
 // Matthieu ?
  //dxTemoinDe.ReportTitle.Text:=psNom+' est témoin de...';
  ///dxComponentPrinter1.Preview(True,nil);
end;

procedure TFTemoinDe.rbNomClick(Sender: TObject);
begin
  RemplirTV;
end;

end.

