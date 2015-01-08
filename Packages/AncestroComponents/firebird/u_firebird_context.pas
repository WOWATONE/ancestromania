{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                           }
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

unit u_firebird_context;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  windows,
{$ELSE}
  LCLType, FileUtil,
{$ENDIF}
  lazutf8classes,
  Classes,Graphics,Forms,
  u_common_const,
  fonctions_string,
  fonctions_net,
  IniFiles, u_common_functions;

procedure p_setLibrary (var libname: string);


implementation

uses
  fonctions_init,sysutils,
  process,
   fonctions_system;


end.

