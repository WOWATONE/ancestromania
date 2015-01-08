{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
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

unit u_Form_Qui_Porte_ce_Titre;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt, u_ancestropictimages,Forms,SysUtils,Dialogs,Menus,DB,
  IBCustomDataSet,IBQuery,ExtCtrls,
  U_ExtDBGrid, u_framework_components,StdCtrls,u_buttons_appli,
  Controls,Classes, u_reports_components, RichView, RVStyle,
  PrintersDlgs, Grids, DBGrids;

type

  { TFQuiPorteCeTitre }

  TFQuiPorteCeTitre=class(TF_FormAdapt)
    IATitle1: TIATitle;
    Label8: TLabel;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    IBQNom:TIBQuery;
    DSNom:TDataSource;
    pmTitres: TPopupMenu;
    mFiche:TMenuItem;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Panel2:TPanel;
    mImprimer: TMenuItem;
    ExporterenHTML1:TMenuItem;
    RVStyle: TRVStyle;
    SaveDialog:TSaveDialog;
    Panel9:TPanel;
    rv:TRichView;
    IBQConjoint:TIBQuery;
    lVille:TLabel;
    IBQNomCLE_FICHE:TLongintField;
    IBQNomNOM:TIBStringField;
    IBQNomNAISSANCE: TIBStringField;
    IBQNomCLE_PERE:TLongintField;
    IBQNomCLE_MERE:TLongintField;
    IBQNomDECES: TStringField;
    IBQNomSEXE:TLongintField;
    IBQNomPERE_NOM: TStringField;
    IBQNomPERE_NAISSANCE: TStringField;
    IBQNomMERE_NOM: TStringField;
    IBQNomMERE_NAISSANCE: TStringField;
    fpBoutons:TPanel;
    Label1:TLabel;
    GoodBtn7:TFWClose;
    cbTitre: TFWComboBox;
    dxComponentPrinter1: TPrinterSetupDialog;
    btnPrint: TFWPrintGrid;
    procedure cbTitreChange(Sender: TObject);
    procedure dxDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mFicheClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure pmTitresPopup(Sender:TObject);
    procedure doFillBottomInfos;
    procedure cbTitrePropertiesCloseUp(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure Image1Click(Sender:TObject);
    procedure dxDBGrid1DBTableView1FocusedRecordChanged(
      Sender:TObject;APrevFocusedRecord,
      AFocusedRecord:Longint;
      ANewItemRecordFocusingChanged:Boolean);
    procedure dxDBGrid1DBTableView1DblClick(Sender: TObject);
    procedure SuperFormShowFirstTime(Sender: TObject);
    procedure dxDBGrid1MouseEnter(Sender: TObject);
    procedure dxDBGrid1MouseLeave(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure mImprimerClick(Sender: TObject);
  private
    procedure doInit;
  public

  end;

implementation

uses u_dm,u_common_ancestro,u_form_main,u_genealogy_context,IBSQL, fonctions_components,fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFQuiPorteCeTitre.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  dxDBGrid1.Hint:=rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns;
  pGeneral.Color:=gci_context.ColorLight;
  SaveDialog.InitialDir:=gci_context.PathDocs;
  Height:=round(FMain.height*gci_context.TailleFenetre/100);
  width:=round(FMain.width*gci_context.TailleFenetre/100);
  // Matthieu ?
//  dxDBGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_TITRES');
  IBQConjoint.Open;
end;

procedure TFQuiPorteCeTitre.dxDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
Begin
  if Column = dxDBGrid1.SelectedColumn then
    if dxDBGrid1.Canvas.Brush.Color=dxDBGrid1.Color then
      dxDBGrid1.Canvas.Brush.Color:=gci_context.ColorMedium;

end;

procedure TFQuiPorteCeTitre.cbTitreChange(Sender: TObject);
begin
  doInit;
end;

procedure TFQuiPorteCeTitre.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQNom.Close;
  IBQConjoint.Close;
  // Matthieu ?
  //  dxDBGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_TITRES');
  Action:=caFree;
  DoSendMessage(Owner,'FERME_TITRES');
end;

procedure TFQuiPorteCeTitre.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFQuiPorteCeTitre.mFicheClick(Sender:TObject);
begin
  dm.individu_clef:=IBQNomCLE_FICHE.AsInteger;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
end;

procedure TFQuiPorteCeTitre.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Individus du titre.HTM';
  if SaveDialog.Execute then
  begin
    IBQNom.DisableControls;
    try
      SavePlace:=IBQNom.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGrid1,True,True);
    finally
      IBQNom.GotoBookmark(SavePlace);
      IBQNom.FreeBookmark(SavePlace);
      IBQNom.EnableControls;
    end;
  end;
end;

procedure TFQuiPorteCeTitre.pmTitresPopup(Sender:TObject);
begin
  mFiche.Enabled:=not IBQNom.IsEmpty;
  ExporterenHTML1.Enabled:=mFiche.Enabled;
  mImprimer.Enabled:=mFiche.Enabled;
end;

procedure TFQuiPorteCeTitre.doFillBottomInfos;
var
  s,s2:string;
  sexe:integer;
begin
  rv.Clear;
  rv.FirstJumpNo:=0;
  sexe:=IBQNomSexe.AsInteger;
  //le nom
  s:=IBQNomNOM.AsString;
  s:=s+'    ---    NIP : '+IBQNomCLE_FICHE.AsString;
  {
  case sexe of
    1:RVStyle.TextStyles.Items[2].Color:=gci_context.ColorHomme;
    2:RVStyle.TextStyles.Items[2].Color:=gci_context.ColorFemme;
  else
    RVStyle.TextStyles.Items[2].Color:=clWindowText;
  end;}
  rv.Add(s,rvsSubheading);
  rv.AddTextFromNewLine(' ',rvsNormal);

  s:=IBQNomNAISSANCE.AsString;
  if s>'' then
  begin
    if sexe=2 then
      s2:='Née: '
    else
      s2:='Né: ';
    s:='                 '+s2+s;
    rv.Add(s,rvsNormal);
    rv.AddTextFromNewLine(' ',rvsNormal);
  end;
  rv.AddTextFromNewLine(' ',rvsNormal);
  //le père
  s:=IBQNomPERE_NOM.AsString;
  if (Length(s)>0) then
  begin
    s:=s+'    ---    NIP : '+IBQNomCLE_PERE.AsString;
    //RVStyle.TextStyles.Items[4].Color:=gci_context.ColorHomme;
    rv.Add('Son père: ',rvsNormal);
    rv.Add(s,rvsJump1);
    rv.AddTextFromNewLine(' ',rvsNormal);

    s:=IBQNomPERE_NAISSANCE.AsString;
    if s>'' then
    begin
      s:='Né: '+s;
      rv.Add('                 '+s,rvsNormal);
    end;
    rv.AddTextFromNewLine(' ',rvsNormal);
  end;
  //la mère
  s:=IBQNomMERE_NOM.AsString;
  if (Length(s)>0) then
  begin
    s:=s+'    ---    NIP : '+IBQNomCLE_MERE.AsString;
//    RVStyle.TextStyles.Items[5].Color:=gci_context.ColorFemme;
    rv.Add('Sa mère: ',rvsNormal);
    rv.Add(s,rvsJump2);
    rv.AddTextFromNewLine(' ',rvsNormal);

    s:=IBQNomMERE_NAISSANCE.AsString;
    if s>'' then
    begin
      s:='Née: '+s;
      rv.Add('                 '+s,rvsNormal);
    end;
    rv.AddTextFromNewLine(' ',rvsNormal);
  end;
  //conjoint
  s:=IBQConjoint.FieldByName('NOM').AsString;
  if (Length(s)>0) then
  begin
    s:=s+'    ---    NIP : '+IBQConjoint.FieldByName('CLE_FICHE').AsString;
    rv.Add('Son dernier conjoint: ',rvsNormal);
    case IBQConjoint.FieldByName('SEXE').AsInteger of
      1:rv.Add(s,rvsJump1);
      2:rv.Add(s,rvsJump2);
    end;
  end;
  rv.Cursor:=crHandPoint;
  rv.format;
  rv.Paint;
end;

procedure TFQuiPorteCeTitre.doInit;
begin
  IBQNom.DisableControls;
  try
    IBQNom.close;
    IBQNom.Params[0].AsInteger:=dm.NumDossier;
    IBQNom.Params[1].AsString:=cbTitre.Text;
    Screen.Cursor:=crSQLWait;
    IBQNom.Open;
    Screen.Cursor:=crDefault;
    if not IBQNom.IsEmpty then
      doFillBottomInfos;
  finally
    IBQNom.EnableControls;
  end;
end;

procedure TFQuiPorteCeTitre.cbTitrePropertiesCloseUp(Sender:TObject);
begin
  doInit;
end;

procedure TFQuiPorteCeTitre.SuperFormShow(Sender:TObject);
var
  q:TIBSQL;
begin
  cbTitre.Items.Clear;
  q:=TIBSQL.Create(self);
  try
    q.Database:=dm.ibd_BASE;
    q.Transaction:=dm.IBT_BASE;
    q.SQL.Text:='select DISTINCT EV_IND_DESCRIPTION FROM evenements_ind'
      +' WHERE EV_IND_TYPE=''TITL'' and EV_IND_KLE_DOSSIER=:DOSSIER order by EV_IND_DESCRIPTION';
    q.Params[0].AsInteger:=dm.NumDossier;
    q.ExecQuery;
    while not q.Eof do
    begin
      cbTitre.Items.Add(q.Fields[0].AsString);
      q.Next;
    end;
    q.Close;
  finally
    q.Free;
  end;
end;

procedure TFQuiPorteCeTitre.Image1Click(Sender:TObject);
var
  i:integer;
begin
  // Matthieu : À refaire avec du code déjà mis en place
//  for i:=0 to dxDBGrid1DBTableView1.ColumnCount-1 do
//    dxDBGrid1DBTableView1.Columns[i].SortOrder:=soNone;
  IBQNom.Close;
  Screen.Cursor:=crSQLWait;
  IBQNom.Open;
  Screen.Cursor:=crDefault;
end;

procedure TFQuiPorteCeTitre.dxDBGrid1DBTableView1FocusedRecordChanged(
  Sender:TObject;APrevFocusedRecord,
  AFocusedRecord:Longint;
  ANewItemRecordFocusingChanged:Boolean);
begin
  doFillBottomInfos;
end;


procedure TFQuiPorteCeTitre.dxDBGrid1DBTableView1DblClick(Sender: TObject);
begin
  mFicheClick(sender);
end;

procedure TFQuiPorteCeTitre.SuperFormShowFirstTime(Sender: TObject);
begin
  Caption:=rs_Caption_Who_has_this_job;
end;

procedure TFQuiPorteCeTitre.dxDBGrid1MouseEnter(Sender: TObject);
begin
  // Matthieu ?
//  dm.ControleurHint.HintStyle.Standard:=true;
end;

procedure TFQuiPorteCeTitre.dxDBGrid1MouseLeave(Sender: TObject);
begin
//  dm.ControleurHint.HintStyle.Standard:=false;
end;

procedure TFQuiPorteCeTitre.btnPrintClick(Sender: TObject);
begin
  // Matthieu
  with btnPrint do
  if IBQNom.RecordCount>1 then
    DBTitle:=fs_RemplaceMsg(rs_Caption_Title_s_owners, [cbTitre.Text])
  else
    DBTitle:=fs_RemplaceMsg(rs_Caption_Title_s_owner, [cbTitre.Text]);

end;

procedure TFQuiPorteCeTitre.mImprimerClick(Sender: TObject);
begin
  btnPrintClick(sender);
end;

end.

