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

unit u_objet_TState;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes;

type
  TState=class
  private
    fCount:integer;
    fStartValue:boolean;

    function GetValue:boolean;
    procedure SetValue(const Value:boolean);

  public
    constructor Create(StartValue:boolean); virtual;
    property Value:boolean read GetValue write SetValue;

  end;

implementation

{ TState }

constructor TState.Create(StartValue:boolean);
begin
  fCount:=0;
  fStartValue:=StartValue;
end;

function TState.GetValue:boolean;
begin
  if fCount=0 then
    result:=fStartValue
  else
    result:=not fStartValue;
end;

procedure TState.SetValue(const Value:boolean);
begin
  if Value=fStartValue then
  begin
    if fCount>0 then dec(fCount);
  end
  else
  begin
    inc(fCount);
  end;
end;

end.

