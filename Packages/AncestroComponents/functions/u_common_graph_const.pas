{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Andr? Langlet (Main), Matthieu Giroux (LAZARUS),            }
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

unit u_common_graph_const;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

const
  _ZOOM_MIN = 3;
  _ZOOM_MAX = 200;

  //Les curseurs
  _CURPOPUP = 5;
  _CURSOR_ZOOM_MOINS = 6;
  _CURSOR_ZOOM_PLUS = 7;
  _CURSOR_MAIN = 8;

implementation

end.
