unit u_objet_TCircleElement;

interface

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}


uses
     Classes,
     Graphics,
{$IFDEF FPC}
     LCLType,
{$ELSE}
     Windows,
{$ENDIF}
     u_objet_TEllipseElement;

type
     TCircleElement = class(TEllipseElement)
     private


     public

          constructor Create; override;


     end;


implementation




{ TCircleElement }


constructor TCircleElement.Create;
begin
	inherited Create;

	Pen.Color := clYellow;
	Pen.Width := 1;
	Brush.Style := bsClear;

end;



end.

