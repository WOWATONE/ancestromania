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

unit u_Form_Voir_Point;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
{$ENDIF}
  Forms,  StdCtrls, u_buttons_appli,ExtJvXPButtons, ExtCtrls, MaskEdit, u_ancestropictimages, Menus;

type
  TFVoirPoint = class(TForm)
    Panel9: TPanel;
    Panel10: TPanel;
    btnClose: TFWClose;
    Label1: TLabel;
    Label2: TLabel;
    btnSat: TJvXPButton;
    edLatitude: TMaskEdit;
    edLongitude: TMaskEdit;
    Image1: TIAWorld;
    Label3: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnSatPopupMenuPopup(Sender: TObject;
      var APopupMenu: TPopupMenu; var AHandled: Boolean);
  private

  public

  end;

implementation

uses
      u_genealogy_context,u_form_main;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFVoirPoint.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFVoirPoint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFVoirPoint.FormCreate(Sender: TObject);
begin
  Color:=gci_context.ColorLight;
end;

procedure TFVoirPoint.btnSatPopupMenuPopup(Sender: TObject;
  var APopupMenu: TPopupMenu; var AHandled: Boolean);
begin
  FMain.Lieu_Pays:='';
  FMain.Lieu_Region:='';
  FMain.Lieu_Departement:='';
  FMain.Lieu_Ville:='';
  FMain.Lieu_Latitude:=edLatitude.Text;
  FMain.Lieu_Longitude:=edLongitude.Text;
end;

end.
