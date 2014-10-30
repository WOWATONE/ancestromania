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

unit u_Form_Compte_Villes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, TeEngine, Series, TeeProcs, DBChart, Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  DB, Forms,
  IBCustomDataSet, IBQuery, Controls, Classes, ExtCtrls,
   u_buttons_appli,
     U_ExtDBGrid;

type
  TFCompteVilles = class(TForm)
    Query: TIBQuery;
    DataSource: TDataSource;
    QueryCOMBIEN: TLongintField;
    QueryRPA_LIBELLE: TIBStringField;
    Panel7: TPanel;
    Panel5: TPanel;
    btnFermer: TFWClose;
    Panel6: TPanel;
    cxGrid1: TExtDBGrid;
    procedure SpeedButton1Click(Sender: TObject);

    procedure SuperFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SuperFormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure OpenQuery;
  public

  end;

implementation

uses  u_dm,
      u_genealogy_context, u_common_ancestro;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}


procedure TFCompteVilles.OpenQuery;
begin
  Query.DisableControls;
  try
    Query.Close;
    Query.ParamByName('dossier').asInteger:=dm.NumDossier;
    Query.Open;
  finally
    Query.EnableControls;
  end;
end;

procedure TFCompteVilles.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TFCompteVilles.SuperFormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then ModalResult := mrCancel;
end;

procedure TFCompteVilles.SuperFormCreate(Sender: TObject);
begin
  Color:=gci_context.ColorLight;
  Height := ClientHeight;
  OpenQuery;
end;

procedure TFCompteVilles.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Query.Close;
  Action := caFree;
end;

procedure TFCompteVilles.FormShow(Sender: TObject);
begin
  caption:=rs_Caption_Number_of_cities_by_country;
end;

end.
