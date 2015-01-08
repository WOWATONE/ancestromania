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

unit u_common_graph_type;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

type

  TFloatRect = record
    Left: single;
    Top: single;
    Right: single;
    Bottom: single;
  end;

//  TMouseMode = (mmMoveOrSelect, mmZoomMore, mmZoomLess);

implementation

end.
