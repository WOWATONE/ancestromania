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

unit u_objet_graph_TPlot;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

type
  TPlot=class
  private
    fYV:integer;
    fXV:integer;
    fYC:single;
    fXC:single;
    fYM:integer;
    fXM:integer;
    fYI:single;
    fXI:single;

  public
    //coordonnées dans le chantier
    property XC:single read fXC write fXC;
    property YC:single read fYC write fYC;

    //coordonnées dans le viewer
    property XV:integer read fXV write fXV;
    property YV:integer read fYV write fYV;

    //coordonnées dans la miniature
    property XM:integer read fXM write fXM;
    property YM:integer read fYM write fYM;

    //coordonnées pour l'impression (pour la roue)
    property XI:single read fXI write fXI;
    property YI:single read fYI write fYI;

    procedure CoordChantier_2_CoordViewer(coef:single);
    procedure CoordChantier_2_CoordMiniature(coef:single);
  end;

implementation

{ TPlot }

procedure TPlot.CoordChantier_2_CoordMiniature(coef:single);
begin
  fXM:=round(coef*fXC);
  fYM:=round(coef*fYC);
end;

procedure TPlot.CoordChantier_2_CoordViewer(coef:single);
begin
  fXV:=round(coef*fXC);
  fYV:=round(coef*fYC);
end;

end.

