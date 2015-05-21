{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania GPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           André Langlet (Main), Matthieu Giroux (LAZARUS),            }
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

unit u_form_ask_name_files_to_export_report;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt, u_comp_TYLanguage, Dialogs,
  u_buttons_flat, StdCtrls, Classes, MaskEdit,
  ExtCtrls,  u_buttons_appli, U_OnFormInfoIni;

type

  { TFAskNameFilesToExportReport }

  TFAskNameFilesToExportReport = class(TF_FormAdapt)
    btn1: TCSpeedButton;
    btn2: TCSpeedButton;
    btn3: TCSpeedButton;
    edAutreSep: TMaskEdit;
    edNameFile1: TMaskEdit;
    edNameFile2: TMaskEdit;
    edNameFile3: TMaskEdit;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    pBorder: TPanel;
    Panel2: TPanel;
    Panel8: TPanel;
    Panel3: TPanel;
    lbFile1: TLabel;
    lbFile2: TLabel;
    lbFile3: TLabel;
    FlatGroupBox1: TGroupBox;
    Panel6: TPanel;
    rbAutre: TRadioButton;
    rbPV: TRadioButton;
    rbV: TRadioButton;
    rbTab: TRadioButton;
    FlatGroupBox2: TGroupBox;
    cbIncludeEntete: TCheckBox;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    SaveDialog3: TSaveDialog;
    Language: TYLanguage;
    btnOk: TFWOK;
    btnCancel: TFWCancel;
    procedure SuperFormCreate(Sender: TObject);
    procedure SuperFormRefreshControls(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);

    procedure SuperFormShowFirstTime(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure SuperFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    fNbFileToAsk: integer;

  public
    property NbFileToAsk: integer read fNbFileToAsk write fNbFileToAsk;

  end;

implementation

uses u_dm,  u_common_functions,
     u_common_ancestro,
     u_genealogy_context,
     u_common_const;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFAskNameFilesToExportReport.SuperFormCreate(Sender: TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  Language.RessourcesFileName := _REL_PATH_TRADUCTIONS + _FileNameTraduction;
  Language.Translate;

  fNbFileToAsk := 1;
  SaveDialog1.InitialDir := gci_context.PathDocs;
  SaveDialog2.InitialDir := gci_context.PathDocs;
  SaveDialog3.InitialDir := gci_context.PathDocs;
end;

procedure TFAskNameFilesToExportReport.SuperFormRefreshControls(Sender: TObject);
var
  Ok: boolean;
begin
  case fNbFileToAsk of
    1: Ok := (edNameFile1.Text > '');
    2: Ok := (edNameFile1.Text > '') and (edNameFile2.Text > '');
    3: Ok := (edNameFile1.Text > '') and (edNameFile2.Text > '') and (edNameFile3.Text > '');
    else
      Ok := false;
  end;
  btnOk.Enabled := Ok;
end;

procedure TFAskNameFilesToExportReport.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TFAskNameFilesToExportReport.SuperFormShowFirstTime(Sender: TObject);
begin
  //Hauteur de la fenêtre
  case fNbFileToAsk of
    1: ClientHeight := 210;
    2: ClientHeight := 260;
    3:ClientHeight:=310;
  end;
  if fNbFileToAsk=1 then
    Caption:=rs_Caption_Name_of_file_to_export
  else
    Caption:=rs_Caption_Names_of_files_to_export;
  doRefreshControls;
end;

procedure TFAskNameFilesToExportReport.btn1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then edNameFile1.Text := SaveDialog1.FileName;
  doRefreshControls;
end;

procedure TFAskNameFilesToExportReport.btn2Click(Sender: TObject);
begin
  if SaveDialog2.Execute then edNameFile2.Text := SaveDialog2.FileName;
  doRefreshControls;
end;

procedure TFAskNameFilesToExportReport.btn3Click(Sender: TObject);
begin
  if SaveDialog3.Execute then edNameFile3.Text := SaveDialog3.FileName;
  doRefreshControls;
end;

procedure TFAskNameFilesToExportReport.SuperFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    _KEY_HELP: p_ShowHelp(_ID_PRINT);
  end;
end;

end.
