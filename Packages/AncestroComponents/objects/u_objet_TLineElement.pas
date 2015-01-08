unit u_objet_TLineElement;

interface

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
     Classes,
     Graphics,
{$IFDEF FPC}
     LCLType, LCLIntf,
{$ELSE}
     Windows,
{$ENDIF}
	u_objet_TIniMem,
     u_objet_TGraphicElement;

type
     TLineElement = class(TGraphicElement)
     private
          fPen: TPen;
          procedure SetPen(const Value: TPen);
     public

          constructor Create; override;
          destructor Destroy; override;
          procedure DrawGhost; override;
          procedure DrawElement; override;
          procedure StopGrowGhost; override;
          function PointBelongToElement(X, Y: integer): boolean; override;

		function SaveToIni(fIni: TIniMem; section: string; id: integer): boolean; override;
		function LoadFromIni(fIni: TIniMem; section: string; id: integer): boolean; override;


          property Pen: TPen read fPen write SetPen;
     end;

implementation

uses
     SysUtils;



constructor TLineElement.Create;
begin
     inherited Create;
     fPen := TPen.create;

     Hands := [haTopLeft, haBottomRight];

end;

destructor TLineElement.Destroy;
begin
     fPen.free;

     inherited Destroy;
end;

procedure TLineElement.DrawElement;
var
     x1, y1, x2, y2: integer;
begin
     if (assigned(Canvas)) and (Visible) then
     begin
          Canvas.Pen.assign(fPen);

          GetHandPos(haTopLeft, x1, y1);
          GetHandPos(haBottomRight, x2, y2);

          Canvas.MoveTo(x1, y1);
          Canvas.LineTo(x2, y2);
     end;
end;

procedure TLineElement.DrawGhost;
begin
     Canvas.Pen.Color := clWhite;
     Canvas.Pen.Mode := pmXor;
     Canvas.Pen.Style := psDot;
     Canvas.Pen.Width := 1;
     Canvas.Brush.Style := bsClear;
     Canvas.MoveTo(fGhostPointMove.x, fGhostPointMove.y);
     Canvas.LineTo(fGhostPointFixed.x, fGhostPointFixed.y);
end;

function TLineElement.PointBelongToElement(X, Y: integer): boolean;
var
     a, b, e1, e2, Tolerance: single;
     p1, p2: TPoint;


     function InTheRect: boolean;
     begin
          if p1.x <= p2.x then
          begin
               if p1.y <= p2.y then
               begin
                    result := ((x >= p1.x - 2) and (x <= p2.x + 2) and (y >= p1.y - 2) and (y <= p2.y + 2));
               end
               else
               begin
                    result := ((x >= p1.x - 2) and (x <= p2.x + 2) and (y >= p2.y - 2) and (y <= p1.y + 2));
               end;
          end
          else
          begin
               if p1.y <= p2.y then
               begin
                    result := ((x >= p2.x - 2) and (x <= p1.x + 2) and (y >= p1.y - 2) and (y <= p2.y + 2));
               end
               else
               begin
                    result := ((x >= p2.x - 2) and (x <= p1.x + 2) and (y >= p2.y - 2) and (y <= p1.y + 2));
               end;
          end;
     end;


begin
     result := false;

     p1 := fHandsPos[_HAND_TOPLEFT];
     p2 := fHandsPos[_HAND_BOTTOMRIGHT];

     //Tout d'abord, il faut que le point soit dans le rectangle formé par les deux points de la ligne
     if InTheRect then
     begin
          //on cherche l'équation de la droite :
          if p1.x <> p2.x then
          begin
               a := (p1.y - p2.y) / (p1.x - p2.x);
               b := p1.y - (a * p1.x);

               e1 := y;
               e2 := a * x + b;
               Tolerance := 5;

               //Le point est-il sut la droite ?
               result := ((e1 <= e2 + Tolerance) and (e1 >= e2 - Tolerance));
          end
          else
          begin
               result := true;

          end;
     end;
end;


procedure TLineElement.SetPen(const Value: TPen);
begin
     fPen.assign(Value);
end;

procedure TLineElement.StopGrowGhost;
begin
     if fGhostHandMove = haTopLeft then
     begin
          fHandsPos[_HAND_TOPLEFT] := fGhostPointMove;
          fHandsPos[_HAND_BOTTOMRIGHT] := fGhostPointFixed;
     end
     else
     begin
          fHandsPos[_HAND_TOPLEFT] := fGhostPointFixed;
          fHandsPos[_HAND_BOTTOMRIGHT] := fGhostPointMove;
	end;

	CalcHandsRect;
end;



function TLineElement.SaveToIni(fIni: TIniMem; section: string; id: integer): boolean;
var
	w: integer;
begin
	try
		result := inherited SaveToIni(fIni, section, id);

          if result then
          begin
               //Type d'élément
               fIni.WriteString(section, 'Type' + inttostr(id), 'line');

               //Le pen
               fIni.WriteInteger(section, 'PenColor' + inttostr(id), fPen.Color);
               fIni.WriteInteger(section, 'PenWidth' + inttostr(id), fPen.Width);
               case fPen.Style of
                    psDash: w := 1;
                    psDot: w := 2;
                    psDashDot: w := 3;
                    psDashDotDot: w := 4;
               else
                    w := 0; //psSolid:
               end;
               fIni.WriteInteger(section, 'PenStyle' + inttostr(id), w);


               result := true;
          end;

     except
          result := false;
     end;
end;

function TLineElement.LoadFromIni(fIni: TIniMem; section: string; id: integer): boolean;
var
	w: integer;
begin
	try
		result := inherited LoadFromIni(fIni, section, id);

          if result then
          begin
               //Le pen
               fPen.Color := fIni.ReadInteger(section, 'PenColor' + inttostr(id), clRed);
               fPen.Width := fIni.ReadInteger(section, 'PenWidth' + inttostr(id), 1);
               w := fIni.ReadInteger(section, 'PenStyle' + inttostr(id), 0);
               case w of
                    1: fPen.Style := psDash;
                    2: fPen.Style := psDot;
                    3: fPen.Style := psDashDot;
                    4: fPen.Style := psDashDotDot;
               else
                    fPen.Style := psSolid;
               end;

               result := true;
          end;

     except
          result := false;
     end;
end;



end.

