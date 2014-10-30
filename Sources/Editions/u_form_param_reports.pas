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

unit u_form_param_reports;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,u_comp_TYLanguage,DB,IBCustomDataSet,IBQuery,
  StdCtrls,ExtCtrls,Classes,Forms,SysUtils,ExtJvXPCheckCtrls,u_buttons_appli,
  MaskEdit, DBGrids, Spin, U_OnFormInfoIni;

type

  { TFParamReports }

  TFParamReports=class(TF_FormAdapt)
    cbFFEvAexporter: TJvXPCheckbox;
    cbFIEvAexporter: TJvXPCheckbox;
    OnFormInfoIni: TOnFormInfoIni;
    pBorder:TPanel;
    Panel2:TPanel;
    Notebook:TNotebook;
    page1:TPage;
    page2:TPage;
    page3:TPage;
    page4:TPage;
    page5:TPage;
    page6:TPage;
    page7:TPage;
    cbAnniv_Naissance:TJvXPCheckBox;
    Label1:TLabel;
    cbAnniv_Deces:TJvXPCheckBox;
    cbAnniv_Mariage:TJvXPCheckBox;
    PickMonth:TComboBox;
    Panel3:TPanel;
    Label2:TLabel;
    gridCouples:TDBGrid;
    IBConjoints:TIBQuery;
    IBConjointsCLE_FICHE:TLongintField;
    IBConjointsNOM:TIBStringField;
    IBConjointsPRENOM:TIBStringField;
    IBConjointsUNION_CLEF:TLongintField;
    IBConjointsNOM_PRENOM:TStringField;
    DSConjoints:TDataSource;
    cbLimitOnYear:TJvXPCheckBox;
    Label3:TLabel;
    edYearFrom:TSpinEdit;
    edYearTo:TSpinEdit;
    cbLimitOnSosa:TJvXPCheckBox;
    edInterval:TComboBox;
    Label4:TLabel;
    Label5:TLabel;
    rbTrieParPatronyme:TRadioButton;
    RadioButton1:TRadioButton;
    cbOnlySosaEclair:TJvXPCheckBox;
    Label6:TLabel;
    Label7:TLabel;
    edVilleEclair:TMaskEdit;
    Label8:TLabel;
    Label9:TLabel;
    cbTous:TJvXPCheckBox;
    cbPhotos:TJvXPCheckBox;
    Label11:TLabel;
    cbPhotosIndi:TJvXPCheckBox;
    Language:TYLanguage;
    rgListeEvenements: TRadioGroup;
    rgStats:TRadioGroup;
    chDept:TJvXPCheckBox;
    btnRefresh:TFWConfig;
    rbChoixUser:TRadioButton;
    cbSosaIndi:TJvXPCheckBox;
    cbSosaFam:TJvXPCheckBox;
    cbAvecMariages: TJvXPCheckBox;
    cbAvecEnfants: TJvXPCheckBox;
    procedure SuperFormCreate(Sender:TObject);
    procedure Button1Click(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
  private
    year,month,day:word;
    fPtrListReport:TForm;
  public
    property PtrListReport:TForm read fPtrListReport write fPtrListReport;
  end;

implementation

uses u_dm,u_form_list_report,u_common_const,u_common_functions,u_common_ancestro,u_genealogy_context,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFParamReports.SuperFormCreate(Sender:TObject);
var
  n:integer;
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  DefaultCloseAction:=caHide;

  fPtrListReport:=nil;
  for n:=1 to 12 do
    PickMonth.Items.Add(fs_FormatText(LongMonthNames[n],mftFirstIsMaj));
  DecodeDate(Now,year,month,day);
  PickMonth.ItemIndex:=month-1;
end;

procedure TFParamReports.Button1Click(Sender:TObject);
begin
  if fPtrListReport<>nil then
    TFListReport(fPtrListReport).doRefreshReport;
end;

procedure TFParamReports.SuperFormShowFirstTime(Sender:TObject);
var
  RectMonitor:TRect;
begin
  //Positionnement de la fenêtre en bas à droite du moniteur de listreport
  RectMonitor:=fPtrListReport.Monitor.WorkareaRect;
  Top:=RectMonitor.Bottom-Height;
  Left:=RectMonitor.Right-Width;

  Caption:=rs_Caption_Printed_documents_options;
end;

procedure TFParamReports.SuperFormKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  case Key of
    _KEY_HELP:p_ShowHelp(_ID_PRINT);
  end;
end;

end.

