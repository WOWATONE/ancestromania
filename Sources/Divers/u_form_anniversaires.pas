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

unit u_form_anniversaires;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  U_FormAdapt, u_ancestropictimages,Forms,Dialogs,Classes,
  Sysutils,u_comp_TYLanguage,Menus,DB,IBCustomDataSet,IBQuery,
  StdCtrls,
  PrintersDlgs, ExtCtrls, u_buttons_appli,
  Controls, u_buttons_flat,
  u_reports_components,
  U_ExtDBGrid, U_OnFormInfoIni, Grids, DBGrids;

type

  { TFAnniversaires }

  TFAnniversaires=class(TF_FormAdapt)
    BlueFlaTCSpeedButton8: TCSpeedButton;
    cxGrid1: TExtDBGrid;
    IATitle1: TIATitle;
    OnFormInfoIni: TOnFormInfoIni;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    panDock:TPanel;
    DSAnni:TDataSource;
    IBQAnni:TIBQuery;
    IBQAnniCLE_FICHE:TLongintField;
    IBQAnniNOM:TIBStringField;
    IBQAnniPRENOM:TIBStringField;
    IBQAnniDATE_DECES:TIBStringField;
    IBQAnniSEXE:TLongintField;
    IBQAnniAGE:TLongintField;
    IBQAnniSTR_NAISSANCE: TStringField;
    IBQAnniANNEE: TLongintField;
    IBQAnniJOUR: TSmallintField;
    IBQAnniev_ind_calendrier1: TSmallintField;
    Panel2:TPanel;
    Panel3:TPanel;
    pmGrid:TPopupMenu;
    ExporterenHTML1:TMenuItem;
    SaveDialog:TSaveDialog;
    Language:TYLanguage;
    Label1:TLabel;
    dxComponentPrinter1:TPrinterSetupDialog;
    fpBoutons: TPanel;
    rbTous: TRadioButton;
    rbVivant: TRadioButton;
    btnFermer: TFWClose;
    bsfbSelection: TFWOK;
    btnPrint: TFWPrintGrid;
    Panel5: TPanel;
    BlueFlaTCSpeedButton1: TCSpeedButton;
    BlueFlaTCSpeedButton2: TCSpeedButton;
    BlueFlaTCSpeedButton3: TCSpeedButton;
    BlueFlaTCSpeedButton4: TCSpeedButton;
    BlueFlaTCSpeedButton5: TCSpeedButton;
    BlueFlaTCSpeedButton6: TCSpeedButton;
    BlueFlaTCSpeedButton7: TCSpeedButton;
    BlueFlaTCSpeedButton9: TCSpeedButton;
    BlueFlaTCSpeedButton10: TCSpeedButton;
    BlueFlaTCSpeedButton11: TCSpeedButton;
    BlueFlaTCSpeedButton12: TCSpeedButton;
    Splitter3: TSplitter;
    procedure cxGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Panel5Click(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure init(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure btnOkClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure dxDBGrid1DblClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure pmGridPopup(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure IBQAnniCalcFields(DataSet: TDataSet);
  private
    i_Mois:SmallInt;
    s_Mois:string;
    procedure uf_ChargeNom;
    procedure doSelect;
  public

  end;

implementation

uses u_dm,
  u_common_functions,u_common_const, DateUtils,
  u_common_ancestro,
  fonctions_string, fonctions_components,
  u_genealogy_context;
{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFAnniversaires.SuperFormCreate(Sender:TObject);
var
  n,i:integer;
begin
  OnRefreshControls := SuperFormRefreshControls;
  Color:=gci_context.ColorLight;
  cxGrid1.Hint:=rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns;

  SaveDialog.InitialDir:=gci_context.PathDocs;
  Height:=round(TControl(Owner).Height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).Width*gci_context.TailleFenetre/100);

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  i_mois:=MonthOf(now);

  for n:=0 to ComponentCount-1 do
    if (Components[n].GetParentComponent=Panel5) and (Components[n]is TCSpeedButton) then
     with TCSpeedButton(Components[n]) do
      begin
//        ColorDown:=gci_context.ColorMedium; MG not in component
        i:=Tag;
        if i <= high (LongMonthNames) Then
          Caption:=fs_FormatText({$IFDEF WINDOWS}AnsiToUtf8{$ENDIF}(LongMonthNames[i]),mftFirstIsMaj);
        if i=i_mois then
        begin
          Font.Color :=gci_context.ColorTexteOnglets;
          down:=true;
          s_Mois:=Caption;
        end;
      end;
  uf_ChargeNom;
end;

procedure TFAnniversaires.cxGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with cxGrid1 do
  if Column = SelectedColumn then
    if Canvas.Brush.Color=Color then
      Canvas.Brush.Color:=gci_context.ColorMedium;
end;

procedure TFAnniversaires.Panel5Click(Sender: TObject);
begin

end;

procedure TFAnniversaires.init(Sender:TObject);
begin
  if sender is TCSpeedButton then
  begin
    i_Mois:=(Sender as TCSpeedButton).Tag;
    s_Mois:=(Sender as TCSpeedButton).Caption;
  end;
  uf_ChargeNom;
end;

procedure TFAnniversaires.uf_ChargeNom;
var
  i_Mode:smallint;
begin
  if rbTous.Checked then
    i_Mode:=1
  else
    i_Mode:=0;

  IBQAnni.DisableControls;
  try
    IBQAnni.Close;
    IBQAnni.ParamByName('mois').AsInteger:=i_Mois;
    IBQAnni.ParamByName('mode').AsInteger:=i_Mode;
    IBQAnni.ParamByName('dossier').AsInteger:=dm.NumDossier;
    IBQAnni.Open;
  finally
    IBQAnni.EnableControls;
  end;
  doRefreshControls;
end;

procedure TFAnniversaires.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFAnniversaires.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQAnni.Close;
  Action:=caFree;
  DoSendMessage(Owner,'FERME_FORM_ANNIVERSAIRES');
end;

procedure TFAnniversaires.btnOkClick(Sender:TObject);
begin
  doSelect;
end;

procedure TFAnniversaires.IBQAnniCalcFields(DataSet: TDataSet);
begin
 IBQAnni.FieldByName('STR_NAISSANCE').AsString:=LongueDate(IBQAnniANNEE.AsInteger,i_mois,
   IBQAnni.FieldByName('JOUR').AsInteger,TCalendrier(IBQAnniev_ind_calendrier1.AsInteger));
end;

procedure TFAnniversaires.doSelect;
begin
  dm.individu_clef:=IBQAnniCLE_FICHE.AsInteger;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
end;

procedure TFAnniversaires.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:Close;
    _KEY_HELP:p_ShowHelp(_ID_ANNIVERSAIRE);
  end;
end;

procedure TFAnniversaires.SuperFormRefreshControls(Sender:TObject);
begin
  bsfbSelection.enabled:=IBQAnni.Active and not IBQAnni.IsEmpty;
end;

procedure TFAnniversaires.dxDBGrid1DblClick(Sender:TObject);
begin
  doSelect;
end;

procedure TFAnniversaires.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Anniversaire du  mois en cours.HTM';
  if SaveDialog.Execute then
  begin
    IBQAnni.DisableControls;
    try
      SavePlace:=IBQAnni.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,cxGrid1,true,True,'html');
    finally
      IBQAnni.GotoBookmark(SavePlace);
      IBQAnni.FreeBookmark(SavePlace);
      IBQAnni.EnableControls;
    end;
  end;
end;

procedure TFAnniversaires.pmGridPopup(Sender:TObject);
begin
  ExporterenHTML1.enabled:=not IBQAnni.IsEmpty;
end;

procedure TFAnniversaires.SuperFormShow(Sender:TObject);
begin
  Caption:=rs_Caption_Birthdays + ','+ rs_on_date+' ' + _GDate.MonthNum2MonthGedcom(i_Mois) + ',' + IntToStr(YearOf(now)) ;
end;

procedure TFAnniversaires.btnPrintClick(Sender:TObject);
begin
  // Matthieu
  btnPrint.DBTitle:=Caption;
end;

end.

