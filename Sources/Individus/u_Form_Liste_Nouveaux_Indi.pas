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

unit u_Form_Liste_Nouveaux_Indi;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  U_FormAdapt,Forms,SysUtils,U_ExtDBGrid,ExtJvXPCheckCtrls,
  u_comp_TYLanguage,Dialogs,Menus,DB,IBQuery, IBUpdateSQL,
  StdCtrls,Controls,ExtCtrls, ZVDateTimePicker,
  Classes,u_buttons_appli,
  u_ancestropictimages, U_OnFormInfoIni;

type

  { TFListeNouveauxIndi }

  TFListeNouveauxIndi=class(TF_FormAdapt)
    Fermer: TFWClose;
    IBUNouveaux: TIBUpdateSQL;
    OnFormInfoIni: TOnFormInfoIni;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    fpBoutons:TPanel;
    pBottom:TPanel;
    IBQNouveaux:TIBQuery;
    DSNouveaux:TDataSource;
    pmNouveaux: TPopupMenu;
    mOuvreFiche: TMenuItem;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    N1:TMenuItem;
    ExporterenHTML1:TMenuItem;
    SaveDialog:TSaveDialog;
    rbNew:TRadioButton;
    rbModify:TRadioButton;
    cbNew:TJvXPCheckBox;
    DateTimePicker:TZVDateTimePicker;
    Language:TYLanguage;
    Label1:TLabel;
    GoodBtn7:TFWCLose;

    procedure FormShow(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mOuvreFicheClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure pmNouveauxPopup(Sender:TObject);
    procedure DateTimePickerCloseUp(Sender:TObject);
    procedure cbNewClick(Sender:TObject);
    procedure rbModifyClick(Sender:TObject);
    procedure rbNewClick(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure dxDBGrid1DBTableView1CellDblClick(
      Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure SuperFormShowFirstTime(Sender: TObject);
  private

    fDialogMode:boolean;
    fCleFicheSelected:integer;

    procedure SetDialogMode(const Value:boolean);
    procedure doOpen;
  public
    property DialogMode:boolean read fDialogMode write SetDialogMode;
    property CleFicheSelected:integer read fCleFicheSelected write fCleFicheSelected;

  end;

implementation

uses u_dm,u_common_const,u_common_functions,u_common_ancestro,
     u_genealogy_context,
     fonctions_components;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFListeNouveauxIndi.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;

  // Matthieu :?Utiliser le OnFormInfoIni
//  dxDBGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_NOUVEAUX_INDIS');

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  cbNew.checked:=gci_context.ShowNew;

  DateTimePicker.Date:=date-7;
  SaveDialog.InitialDir:=gci_context.PathDocs;
  doOpen;
end;

procedure TFListeNouveauxIndi.FormShow(Sender: TObject);
begin
  Height:=round(TControl(Owner).height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).width*gci_context.TailleFenetre/100);
end;

procedure TFListeNouveauxIndi.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQNouveaux.Close;
  // Matthieu :?Utiliser le OnFormInfoIni
//  dxDBGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_NOUVEAUX_INDIS');
end;

procedure TFListeNouveauxIndi.SetDialogMode(const Value:boolean);
begin
  fDialogMode:=Value;
end;

procedure TFListeNouveauxIndi.sbCloseClick(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFListeNouveauxIndi.mOuvreFicheClick(Sender:TObject);
begin
  if (IBQNouveaux.Active)and(not IBQNouveaux.IsEmpty) then
  begin
    fCleFicheSelected:=IBQNouveaux.FieldByName('CLE_FICHE').AsInteger;
    ModalResult:=mrOk;
  end;
end;

procedure TFListeNouveauxIndi.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Liste des derniers individus saisis.HTM';
  if SaveDialog.Execute then
  begin
    IBQNouveaux.DisableControls;
    try
      SavePlace:=IBQNouveaux.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGrid1,True,True);
    finally
      IBQNouveaux.GotoBookmark(SavePlace);
      IBQNouveaux.FreeBookmark(SavePlace);
      IBQNouveaux.EnableControls;
    end;
  end;
end;

procedure TFListeNouveauxIndi.pmNouveauxPopup(Sender:TObject);
begin
  mOuvreFiche.Enabled:=(IBQNouveaux.Active)and(not IBQNouveaux.IsEmpty);
  ExporterenHTML1.Enabled:=mOuvreFiche.Enabled;
end;

procedure TFListeNouveauxIndi.doOpen;
begin
  IBQNouveaux.Close;
  IBQNouveaux.ParamByName('d_date').AsDate:=DateTimePicker.Date;
  IBQNouveaux.ParamByName('i_dossier').AsInteger:=dm.NumDossier;
  if rbNew.Checked then
    IBQNouveaux.ParamByName('mode').AsInteger:=1
  else
    IBQNouveaux.ParamByName('mode').AsInteger:=0;
  IBQNouveaux.Open;
end;

procedure TFListeNouveauxIndi.DateTimePickerCloseUp(Sender:TObject);
begin
  doOpen;
end;

procedure TFListeNouveauxIndi.cbNewClick(Sender:TObject);
begin
  gci_context.ShowNew:=cbNew.Checked;
  gci_context.ShouldSave:=true;
end;

procedure TFListeNouveauxIndi.rbModifyClick(Sender:TObject);
begin
  doOpen;
end;

procedure TFListeNouveauxIndi.rbNewClick(Sender:TObject);
begin
  doOpen;
end;

procedure TFListeNouveauxIndi.SuperFormKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:ModalResult:=mrOk;
    _KEY_HELP:p_ShowHelp(_ID_NOUVEAUX_INDI);
  end;
end;

procedure TFListeNouveauxIndi.dxDBGrid1DBTableView1CellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  mOuvreFicheClick(Sender);
end;

procedure TFListeNouveauxIndi.SuperFormShowFirstTime(Sender: TObject);
begin
  Caption:= rs_Caption_Last_persons_files;
end;

end.

