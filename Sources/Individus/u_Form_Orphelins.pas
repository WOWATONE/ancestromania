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

unit u_Form_Orphelins;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,SysUtils,Dialogs,Menus,
  DB,IBCustomDataSet,IBQuery,
  StdCtrls,Controls,ExtCtrls,Classes,
  u_buttons_appli,
  U_ExtDBGrid, U_OnFormInfoIni,PrintersDlgs,
  Grids, DBGrids, u_reports_components,
  u_ancestropictimages;
type

  { TFOrphelins }

  TFOrphelins=class(TF_FormAdapt)
    OnFormInfoIni: TOnFormInfoIni;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    fpBoutons:TPanel;
    pBottom:TPanel;
    IBQOrphelins:TIBQuery;
    DSNaissance:TDataSource;
    pmOrphelins:TPopupMenu;
    mFiche:TMenuItem;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    mImprimer:TMenuItem;
    ExporterenHTML1:TMenuItem;
    SaveDialog:TSaveDialog;
    IBQOrphelinsCLE_FICHE:TLongintField;
    IBQOrphelinsNOM:TIBStringField;
    IBQOrphelinsDATE_NAISSANCE:TIBStringField;
    IBQOrphelinsDATE_DECES:TIBStringField;
    IBQOrphelinsSEXE:TLongintField;
    Label1:TLabel;
    GoodBtn7:TFWClose;
    N2:TMenuItem;
    mSupprimer:TMenuItem;
    Label2:TLabel;
    dxComponentPrinter1:TPrinterSetupDialog;
    btnPrint:TFWPrintGrid;

    procedure dxDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mFicheClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure pmOrphelinsPopup(Sender:TObject);
    procedure mSupprimerClick(Sender:TObject);
    procedure dxDBGrid1DBTableView1CellDblClick(
      Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure SuperFormShow(Sender:TObject);
    procedure dxDBGrid1MouseEnter(Sender:TObject);
    procedure dxDBGrid1MouseLeave(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure mImprimerClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
  private
    procedure Rafraichir;
  public

  end;

implementation

uses u_dm,
     u_common_const,
     u_common_ancestro,
     fonctions_dialogs,
     u_form_main,
     u_genealogy_context,IBSQL,
     u_common_ancestro_functions,
     fonctions_components, fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFOrphelins.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  dxDBGrid1.Hint:=rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns;
  Color:=gci_context.ColorLight;
  Height:=round(TControl(Owner).Height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).Width*gci_context.TailleFenetre/100);
  // Matthieu ?
  //  dxDBGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_INDIS_ISOLES');
  SaveDialog.InitialDir:=gci_context.PathDocs;
end;

procedure TFOrphelins.dxDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column = dxDBGrid1.SelectedColumn then
    if dxDBGrid1.Canvas.Brush.Color=dxDBGrid1.Color then
      dxDBGrid1.Canvas.Brush.Color:=gci_context.ColorMedium;
end;

procedure TFOrphelins.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQOrphelins.Close;
  // Matthieu ?
  //  dxDBGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_INDIS_ISOLES');
  Action:=caFree;
  DoSendMessage(Owner,'FERME_INDIS_ISOLES');
end;

procedure TFOrphelins.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFOrphelins.mFicheClick(Sender:TObject);
begin
  dm.individu_clef:=IBQOrphelinsCLE_FICHE.AsInteger;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
end;

procedure TFOrphelins.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Liste des Individus orphelins.HTM';
  if SaveDialog.Execute then
  begin
    IBQOrphelins.DisableControls;
    try
      SavePlace:=IBQOrphelins.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGrid1,True,True);
    finally
      IBQOrphelins.GotoBookmark(SavePlace);
      IBQOrphelins.FreeBookmark(SavePlace);
      IBQOrphelins.EnableControls;
    end;
  end;
end;

procedure TFOrphelins.pmOrphelinsPopup(Sender:TObject);
begin
  if dxDBGrid1.SelectedRows.Count>1 then
    mSupprimer.Caption:=fs_RemplaceMsg(rs_Caption_Delete_selected_person_s_files,
    [intToStr(dxDBGrid1.SelectedRows.Count)])
  else
    mSupprimer.Caption:=rs_Caption_Delete_selected_person_s_file;

  mFiche.Enabled:=dxDBGrid1.SelectedRows.Count>0;
  mSupprimer.enabled:=mFiche.Enabled;
  ExporterenHTML1.Enabled:=not IBQOrphelins.IsEmpty;
  mImprimer.Enabled:=ExporterenHTML1.Enabled;
end;

procedure TFOrphelins.mSupprimerClick(Sender:TObject);
var
  q:TIBSQL;
  sMessage:string;
  i:integer;
  L:array of Integer;
begin
  setLength(L,dxDBGrid1.SelectedRows.Count);

  if Length(L)>1 then
    sMessage:=fs_RemplaceMsg(rs_Confirm_deleting_selected_persons_files,[intToStr(Length(L))])
  else
    sMessage:=rs_Confirm_deleting_selected_person_file;

  if MyMessageDlg(sMessage,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    dxDBGrid1.DataSource.DataSet.DisableControls;
    screen.Cursor:=crSQLWait;
    Application.ProcessMessages;
    try
      for i:=0 to dxDBGrid1.SelectedRows.Count-1 do
      with dxDBGrid1.DataSource.DataSet do
        Begin
          GotoBookMark(dxDBGrid1.SelectedRows.Items[i]);
          L[i]:=FieldByName(dxDBGrid1.Columns [ 7 ].FieldName).Value;

        end;
      IBQOrphelins.Close;
      q:=TIBSQL.Create(Self);
      q.DataBase:=dm.ibd_BASE;
      q.Transaction:=dm.IBT_BASE;
      try
        q.SQL.Text:='delete from individu where CLE_FICHE=:CLE_FICHE';
        for i:=0 to Length(L)-1 do
        begin
          q.ParamByName('CLE_FICHE').AsInteger:=L[i];
          q.ExecQuery;
        end;
        q.Close;
      finally
        q.Free;
      end;
      dm.IBT_base.CommitRetaining;
      fMain.RefreshFavoris;
//      dxDBGrid1DBTableView1.DataController.Filter.Clear;
      Rafraichir;
      if FMain.IDModuleActif=_ID_INDIVIDU then
      begin //réinitialiser la fiche principale, l'individu en cours ou un de ses liens peut être supprimé
        DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
        Show;//ramene le focus
      end;
    finally
      screen.Cursor:=crDefault;
      dxDBGrid1.DataSource.DataSet.EnableControls;
    end;
  end;
end;

procedure TFOrphelins.dxDBGrid1DBTableView1CellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  mFicheClick(sender);
end;

procedure TFOrphelins.SuperFormShow(Sender:TObject);
begin
  Rafraichir;
end;

procedure TFOrphelins.Rafraichir;
begin
  IBQOrphelins.DisableControls;
  try
    IBQOrphelins.Close;
    IBQOrphelins.Params[0].AsInteger:=dm.NumDossier;
    IBQOrphelins.Open;
    IBQOrphelins.Last;
    IBQOrphelins.First;
    case IBQOrphelins.RecordCount of
      0:Label2.caption:=rs_Caption_Noone_in_this_folder;
      1:Label2.caption:=rs_Caption_One_person_in_this_folder;
      else
        Label2.caption:=fs_RemplaceMsg(rs_Caption_persons_in_this_folder ,
                          [IntToStr(IBQOrphelins.RecordCount)]);
    end;
  finally
    IBQOrphelins.EnableControls;
  end;
end;


procedure TFOrphelins.dxDBGrid1MouseEnter(Sender:TObject);
begin
  // Matthieu ?
//  dm.cxHintStyleController1.HintStyle.Standard:=true;
end;

procedure TFOrphelins.dxDBGrid1MouseLeave(Sender:TObject);
begin
  // Matthieu ?
//dm.cxHintStyleController1.HintStyle.Standard:=false;
end;

procedure TFOrphelins.btnPrintClick(Sender:TObject);
begin
  // Matthieu
  btnPrint.DBTitle:=Caption;
end;

procedure TFOrphelins.mImprimerClick(Sender:TObject);
begin
  btnPrintClick(sender);
end;

procedure TFOrphelins.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_List_of_isolated_persons;
end;

end.

