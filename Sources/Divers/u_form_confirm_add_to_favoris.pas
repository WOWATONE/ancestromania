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

unit u_form_confirm_add_to_favoris;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,
  StdCtrls,ExtCtrls,Classes,
  u_ancestropictimages,
  u_buttons_appli;

type
  TFConfirmAddToFavoris=class(TF_FormAdapt)
    pBorder:TPanel;
    Panel2:TPanel;
    lAction: TLabel;
    Label2:TLabel;
    lTitre:TLabel;
    Panel9:TPanel;
    Image1:TIATitle;
    Label3:TLabel;
    fpBoutons:TPanel;
    btnFermer:TFWClose;
    btnAjouter: TFWAdd;
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
  private
    fNom:string;
    fSexe:Integer;
  public
    procedure doInit;
    property Nom:string read fNom write fNom;
    property Sexe:Integer read fSexe write fSexe;
  end;

implementation

uses  u_dm,u_common_functions,u_common_ancestro,
      u_genealogy_context,
      u_common_const,graphics;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFConfirmAddToFavoris.SuperFormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  fNom:='';
  fSexe:=-1;
end;

procedure TFConfirmAddToFavoris.SuperFormShow(Sender:TObject);
begin
  case fSexe of
    1:lTitre.Font.Color:=gci_context.ColorHomme;
    2:lTitre.Font.Color:=gci_context.ColorFemme;
    else
      lTitre.Font.Color:=clWindowText;
  end;
  lTitre.Caption:=coupechaine(fNom,lTitre);
  Caption:=rs_Caption_Add_to_favorites;
end;

procedure TFConfirmAddToFavoris.SuperFormKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  case Key of
    _KEY_HELP:p_ShowHelp(_HELP_FAVORIS);
  end;
end;

procedure TFConfirmAddToFavoris.doInit;
begin
  lAction.Caption:='Ancestromania va ajouter cet individu à vos Favoris.';
end;

end.

