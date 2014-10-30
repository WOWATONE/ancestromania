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

unit u_Form_Posthumes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,Dialogs,Menus,DB,
  IBCustomDataSet,IBQuery,StdCtrls,Controls,ExtCtrls,
  Classes,u_buttons_appli, u_ancestropictimages,
  u_reports_components,
  U_ExtDBGrid, U_OnFormInfoIni,
   PrintersDlgs;    

type

  { TFPosthumes }

  TFPosthumes=class(TF_FormAdapt)
    OnFormInfoIni: TOnFormInfoIni;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    fpBoutons:TPanel;
    pBottom:TPanel;
    IBQPosthume: TIBQuery;
    DSNaissance:TDataSource;
    pmPosthumes: TPopupMenu;
    mFiche:TMenuItem;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    mImprimer: TMenuItem;
    ExporterenHTML1:TMenuItem;
    SaveDialog:TSaveDialog;
    Label1:TLabel;
    IBQPosthumeCLE_FICHE: TLongintField;
    IBQPosthumeNOM: TIBStringField;
    IBQPosthumeDATE_NAISSANCE: TIBStringField;
    IBQPosthumeDECES_PERE: TIBStringField;
    IBQPosthumeSEXE: TLongintField;
    GoodBtn7:TFWClose;
    dxComponentPrinter1: TPrinterSetupDialog;
    btnPrint: TFWPrintGrid;

    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mFicheClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure pmPosthumesPopup(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure dxDBGrid1DBTableView1CellDblClick(
      Sender: TObject;
      ACellViewInfo: Longint; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure dxDBGrid1MouseEnter(Sender: TObject);
    procedure dxDBGrid1MouseLeave(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure mImprimerClick(Sender: TObject);
    procedure SuperFormShow(Sender: TObject);
  private

  public

  end;

implementation

uses u_dm,u_common_ancestro,
     u_genealogy_context,fonctions_components;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFPosthumes.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  dxDBGrid1.Hint:=rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns;
  Color:=gci_context.ColorLight;
  SaveDialog.InitialDir:=gci_context.PathDocs;
  Height:=round(TControl(Owner).height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).width*gci_context.TailleFenetre/100);
  // Matthieu ?
//  dxDBGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_POSTHUMES');
end;

procedure TFPosthumes.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQPosthume.Close;
  // Matthieu ?
//dxDBGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_POSTHUMES');
  Action:=caFree;
  DoSendMessage(Owner,'FERME_POSTHUMES');
end;

procedure TFPosthumes.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFPosthumes.mFicheClick(Sender:TObject);
begin
  dm.individu_clef:=IBQPosthumeCLE_FICHE.AsInteger;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
end;

procedure TFPosthumes.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Individus nés posthume.HTM';
  if SaveDialog.Execute then
  begin
    IBQPosthume.DisableControls;
    try
      SavePlace:=IBQPosthume.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGrid1,True,True);
    finally
      IBQPosthume.GotoBookmark(SavePlace);
      IBQPosthume.FreeBookmark(SavePlace);
      IBQPosthume.EnableControls;
    end;
  end;
end;

procedure TFPosthumes.pmPosthumesPopup(Sender:TObject);
begin
  mFiche.Enabled:=not dxDBGrid1.DataSource.DataSet.IsEmpty;
  ExporterenHTML1.Enabled:=mFiche.Enabled;
  mImprimer.Enabled:=mFiche.Enabled;
end;

procedure TFPosthumes.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_persons_born_after_father_s_death;
end;

procedure TFPosthumes.dxDBGrid1DBTableView1CellDblClick(
  Sender: TObject;
  ACellViewInfo: Longint; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  mFicheClick(sender);
end;

procedure TFPosthumes.dxDBGrid1MouseEnter(Sender: TObject);
begin
  // Matthieu ?
//  dm.cxHintStyleController1.HintStyle.Standard:=true;
end;

procedure TFPosthumes.dxDBGrid1MouseLeave(Sender: TObject);
begin
//  dm.cxHintStyleController1.HintStyle.Standard:=false;
end;

procedure TFPosthumes.btnPrintClick(Sender: TObject);
begin
  // Matthieu
  btnPrint.DBTitle := Caption;
end;

procedure TFPosthumes.mImprimerClick(Sender: TObject);
begin
  btnPrintClick(sender);
end;

procedure TFPosthumes.SuperFormShow(Sender: TObject);
begin
  IBQPosthume.DisableControls;
  try
    IBQPosthume.Close;
    IBQPosthume.Params[0].AsInteger:=dm.NumDossier;
    IBQPosthume.Open;
  finally
    IBQPosthume.EnableControls;
  end;
end;

end.

