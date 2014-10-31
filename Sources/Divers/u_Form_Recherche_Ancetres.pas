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

unit u_Form_Recherche_Ancetres;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,SysUtils,graphics,Dialogs,Menus,DB,IBQuery,
  StdCtrls,Controls,ExtCtrls,Classes,
  u_buttons_appli,PrintersDlgs,
  U_ExtDBGrid, u_ancestropictimages,
  IBDatabase, u_reports_components, U_OnFormInfoIni, Grids, DBGrids;

type

  { TFRechercheAncetres }

  TFRechercheAncetres=class(TF_FormAdapt)
    OnFormInfoIni: TOnFormInfoIni;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    IBQAncetres:TIBQuery;
    DSAncetres:TDataSource;
    pmExporter:TPopupMenu;
    mImprimer:TMenuItem;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    ExporterenHTML1:TMenuItem;
    SaveDialog:TSaveDialog;
    Title:TLabel;
    dxComponentPrinter:TPrinterSetupDialog;
    Supprimerlestris1:TMenuItem;
    N2:TMenuItem;
    N1:TMenuItem;
    NombreIndividus:TMenuItem;
    IBTransactionPropre:TIBTransaction;
    Ouvrirlafiche:TMenuItem;
    IBQAncetresGENERATION:TLongintField;
    IBQAncetresCLE_INDI:TLongintField;
    IBQAncetresINDIVIDU:TStringField;
    IBQAncetresSEXE:TLongintField;
    IBQAncetresPREM_DATE_CONNUE:TLongintField;
    IBQAncetresPREM_VILLE_CONNUE:TStringField;
    IBQAncetresPREM_DEPT_CONNU:TStringField;
    IBQAncetresPARENT_CONNU:TStringField;
    IBQAncetresSEXE_PARENT:TLongintField;
    IBQAncetresCONJOINT:TStringField;
    IBQAncetresSOSA:TLongintField;
    IBQAncetresPREM_SUBD_CONNU: TStringField;
    IBQAncetresCOMMENT:TMemoField;
    N3:TMenuItem;
    AjouterlesNotes:TMenuItem;
    fpBoutons:TPanel;
    GoodBtn7:TFWClose;
    btnPrint:TFWPrintGrid;
    procedure dxDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mImprimerClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure Image1Click(Sender:TObject);
    procedure pmExporterPopup(Sender:TObject);
    procedure Supprimerlestris1Click(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure OuvrirlaficheClick(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure AjouterlesNotesClick(Sender:TObject);
    procedure dxDBGrid1DBTableView1CellDblClick(
      Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure dxDBGrid1MouseEnter(Sender: TObject);
    procedure dxDBGrid1MouseLeave(Sender: TObject);
  private
    iHeight,iWidth:integer;
  public
  end;

implementation

uses u_dm,
     u_common_ancestro,
     u_genealogy_context,
     fonctions_string,
     fonctions_components,
     u_common_functions,
     rxdbgrid;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFRechercheAncetres.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  dxDBGrid1.Hint:=rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns;
  Title.Caption:=fs_RemplaceMsg(rs_Caption_ancestries_without_parents,[dm.fs_GetCurrentNameSurname]);
  pGeneral.Color:=gci_context.ColorLight;
  iheight:=Height;
  iwidth:=Width;
  // Matthieu ?
//  dxDBGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_LISTE_ANCETRES');

  SaveDialog.InitialDir:=gci_context.PathDocs;

  application.ProcessMessages;
end;

procedure TFRechercheAncetres.dxDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var i : Integer;
begin
  with dxDBGrid1 do
   Begin
    i:=DataSource.DataSet.FieldByName('SEXE').AsInteger;
    case i of
      1:Canvas.Font.Color:=gci_context.ColorHomme;
      2:Canvas.Font.Color:=gci_context.ColorFemme;
      else
        CAnvas.Font.Color:=clWindowText;
    end;
   if column = SelectedColumn then
    if Canvas.Brush.Color=Color then
      Canvas.Brush.Color:=gci_context.ColorMedium;
   end;
end;

procedure TFRechercheAncetres.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQAncetres.Close;
 // Matthieu ?
// dxDBGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_LISTE_ANCETRES',true, [gsoUseFilter]);
  Action:=caFree;
  DoSendMessage(Owner,'FERME_RECHERCHE_ANCETRES');
end;

procedure TFRechercheAncetres.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFRechercheAncetres.mImprimerClick(Sender:TObject);
begin
  btnPrintClick(Sender)
end;

procedure TFRechercheAncetres.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Ancetres_sans_parents.HTM';
  if SaveDialog.Execute then
  begin
    IBQAncetres.DisableControls;
    try
      SavePlace:=IBQAncetres.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGrid1,True,True);
    finally
      IBQAncetres.GotoBookmark(SavePlace);
      IBQAncetres.FreeBookmark(SavePlace);
      IBQAncetres.EnableControls;
    end;
  end;
end;

procedure TFRechercheAncetres.btnPrintClick(Sender:TObject);
begin
  // Matthieu
  btnPrint.DBTitle:=Title.Caption;
end;

procedure TFRechercheAncetres.Image1Click(Sender:TObject);
var
  i:integer;
begin
  for i:=0 to dxDBGrid1.Columns.Count-1 do
    dxDBGrid1.Columns[i].SortOrder:=smNone;
  if (IBQAncetres.Active)and(not IBQAncetres.IsEmpty) then
  begin
    IBQAncetres.Close;
    screen.cursor:=crSQLWait;
    IBQAncetres.Open;
    screen.cursor:=crDefault;
  end;
end;

procedure TFRechercheAncetres.pmExporterPopup(Sender:TObject);
var
  ok:boolean;
  i:integer;
begin
  ok:=(IBQAncetres.Active)and(not IBQAncetres.IsEmpty);
  mImprimer.enabled:=ok;
  ExporterenHTML1.enabled:=ok;
  Ouvrirlafiche.Enabled:=ok;

  // Matthieu ?
  {if dxDBGrid1DBTableView1.DataController.Filter.IsEmpty then
    i:=dxDBGrid1DBTableView1.DataController.DataSetRecordCount
  else}
    i:=dxDBGrid1.DataSource.DataSet.RecordCount;

  case i of
    0:NombreIndividus.Visible:=false;
    1:
      begin
        NombreIndividus.Caption:=rs_Caption_One_andperson_on_the_list;
        NombreIndividus.Visible:=true;
      end;
    else
      begin
        NombreIndividus.Caption:=inttostr(i)+rs_Caption_andPersons_on_the_list;
        NombreIndividus.Visible:=true;
      end;
  end;
end;

procedure TFRechercheAncetres.Supprimerlestris1Click(Sender:TObject);
begin
  Image1Click(Sender);
end;

procedure TFRechercheAncetres.SuperFormShow(Sender:TObject);
begin
  height:=iHeight;
  width:=iWidth;
  DoRefreshControls;
end;

procedure TFRechercheAncetres.OuvrirlaficheClick(Sender:TObject);
begin
  dm.individu_clef:=IBQAncetresCLE_INDI.AsInteger;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
end;

procedure TFRechercheAncetres.SuperFormRefreshControls(Sender:TObject);
begin
  { Matthieu : Plus tard
  dxComponentPrinter1Link1.OptionsPreview.Visible:=dxDBGrid1DBTableView1.Preview.Visible;
  Title.Caption:=rs_Ancestries_of+FMain.NomIndi+', '+FMain.PrenomIndi+_CRLF
    +rs_where_one_parent_is_unknown;}
  IBQAncetres.Close;
  IBQAncetres.ParamByName('ICLEF').AsInteger:=dm.individu_clef;
  screen.cursor:=crSQLWait;
  IBQAncetres.Open;
  screen.cursor:=crDefault;
end;

procedure TFRechercheAncetres.AjouterlesNotesClick(Sender:TObject);
begin
  Ajouterlesnotes.Checked:=not Ajouterlesnotes.Checked;
           { Matthieu : Plus tard
  if Ajouterlesnotes.Checked then
    dxDBGrid1DBTableView1.Preview.Visible:=True
  else
    dxDBGrid1DBTableView1.Preview.Visible:=False;
  dxComponentPrinter1Link1.OptionsPreview.Visible:=dxDBGrid1DBTableView1.Preview.Visible;}
end;


procedure TFRechercheAncetres.dxDBGrid1DBTableView1CellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  OuvrirlaficheClick(Sender);
end;

procedure TFRechercheAncetres.dxDBGrid1MouseEnter(Sender: TObject);
begin
  // Matthieu : Plus tard
  //dm.ControleurHint.HintStyle.Standard:=true;
end;

procedure TFRechercheAncetres.dxDBGrid1MouseLeave(Sender: TObject);
begin
  // Matthieu : Plus tard
  //  dm.ControleurHint.HintStyle.Standard:=false;
end;

end.

