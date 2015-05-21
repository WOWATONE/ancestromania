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

unit u_form_Evements_Ajout;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt, u_comp_TYLanguage, DB,U_ExtDBGrid,
  IBCustomDataSet, IBQuery, StdCtrls, Controls, ExtCtrls, forms, Classes,  u_buttons_appli,
  u_ancestropictimages;

type
  TFEvenement_Ajout = class(TF_FormAdapt)
    pBorder: TPanel;
    pGeneral: TPanel;
    pGlobal: TPanel;
    pBottom: TPanel;
    DSAjoutEve: TDataSource;
    IBQAjoutEve: TIBQuery;
    IBQAjoutEveREF_EVE_LIB_COURT: TIBStringField;
    IBQAjoutEveREF_EVE_LIB_LONG: TIBStringField;
    IBQAjoutEveREF_EVE_CAT: TLongintField;
    Panel1: TPanel;
    Image1: TIATitle;
    dxDBGrid1: TExtDBGrid;
    Language: TYLanguage;
    Label8: TLabel;
    fpBoutons: TPanel;
    bsfbSelection: TFWOK;
    btnFermer: TFWClose;

    procedure SuperFormCreate(Sender: TObject);
    procedure SuperFormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
    procedure SuperFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dxDBGrid1DBTableView1CellDblClick(Sender: TObject;
      ACellViewInfo: Longint; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    fRef_Eve_Lib_Court: string;
    fRef_Eve_Lib_Long: string;

    procedure doSelect;
  public
    property Ref_Eve_Lib_Court: string read fRef_Eve_Lib_Court write fRef_Eve_Lib_Court;
    property Ref_Eve_Lib_Long: string read fRef_Eve_Lib_Long write fRef_Eve_Lib_Long;

    procedure up_Init(I_CLEF: Integer; A_MODE: string);
  end;

implementation

uses u_dm,
     u_common_const,
     u_common_functions,
     u_genealogy_context;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFEvenement_Ajout.SuperFormCreate(Sender: TObject);
begin
  Color:=gci_context.ColorLight;
  DefaultCloseAction:=caHide;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
end;

procedure TFEvenement_Ajout.up_Init(I_CLEF:Integer;A_MODE:string);
begin
  Screen.Cursor := crHourglass;

  IBQAjoutEve.DisableControls;
  IBQAjoutEve.Close;
  IBQAjoutEve.SQL.Clear;
  IBQAjoutEve.SQL.Add('select ref_eve_lib_court,ref_eve_lib_long,ref_eve_cat from ref_evenements'
                     +' where ref_eve_visible=1 and ref_eve_langue=:langue');

  if a_Mode='U' then
  begin
    Height:=365;
    IBQAjoutEve.SQL.Add('and ref_eve_type in(''U'',''D'')');
  end
  else
  begin
    Height:=600;
    IBQAjoutEve.SQL.Add('and ref_eve_type in(''A'',''E'',''D'')'
                       +' and ref_eve_lib_court not in'
                       +' (select e.ev_ind_type'
                       +' from evenements_ind e'
                       +' inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type'
                                            +' and r.ref_eve_une_fois=1'
                       +' where e.ev_ind_kle_fiche=:i_clef)');
    IBQAjoutEve.Params[1].AsInteger:=I_CLEF;
  end;
  IBQAjoutEve.Params[0].AsString:=gci_context.Langue;
  IBQAjoutEve.SQL.Add('order by ref_eve_cat, ref_eve_lib_long');
  IBQAjoutEve.Open;
  IBQAjoutEve.EnableControls;

  Screen.Cursor := crDefault;
end;

procedure TFEvenement_Ajout.SuperFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  IBQAjoutEve.Close;
end;

procedure TFEvenement_Ajout.btnOkClick(Sender: TObject);
begin
  doSelect;
end;

procedure TFEvenement_Ajout.doSelect;
begin
  if (IBQAjoutEve.Active) and (length(IBQAjoutEveREF_EVE_LIB_COURT.AsString)>0) then
  begin
    fRef_Eve_Lib_Court := IBQAjoutEveREF_EVE_LIB_COURT.AsString;
    fRef_Eve_Lib_Long := IBQAjoutEveREF_EVE_LIB_LONG.AsString;
    ModalResult := mrOk;
  end;
end;

procedure TFEvenement_Ajout.dxDBGrid1DBTableView1CellDblClick(
  Sender: TObject; ACellViewInfo: Longint;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  doSelect;
end;

procedure TFEvenement_Ajout.SuperFormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  c:Char;
begin
  if Key=_KEY_HELP then
    p_ShowHelp(_HELP_INDI_IDENTITE)
  else
    if Key in [ord('A')..ord('Z')] then
    begin
      c:=ansichar(Key);
      IBQAjoutEve.LocateNext('ref_eve_lib_long',c,[loCaseInsensitive,loPartialKey]);
    end;
end;

end.
