unit u_objet_TEllipseElement;

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
     u_objet_TIniMem,
     u_objet_TGraphicElement;

type
     TEllipseElement = class(TGraphicElement)
     private
          fDelta: integer;
          fBrush: TBrush;
          fPen: TPen;
		procedure SetBrush(const Value: TBrush);
          procedure SetPen(const Value: TPen);

     protected


     public

          constructor Create; override;
          destructor Destroy; override;

          procedure DrawElement; override;
          procedure DrawGhost; override;
          function PointBelongToElement(X, Y: integer): boolean; override;

          function CanGrowElementJustAfterCreation(var HandCanMove: THand): boolean; override;
          procedure SetInitialPos(X, Y: integer); override;

		function SaveToIni(fIni: TIniMem; section: string; id: integer): boolean; override;
		function LoadFromIni(fIni: TIniMem; section: string; id: integer): boolean; override;



          property Pen: TPen read fPen write SetPen;
          property Brush: TBrush read fBrush write SetBrush;
     end;

implementation

uses
     SysUtils;

{ TEllipseElement }

constructor TEllipseElement.Create;
begin
     inherited Create;

     fBrush := TBrush.create;
     fPen := TPen.create;

     fBrush.Color := clRed;
     fDelta := 20;

     Hands := [haTopLeft, haBottomLeft, haTopRight, haBottomRight];
     //	Hands := [haMiddleLeft, haMiddleRight, haMiddleTop, haMiddleBottom];
end;

destructor TEllipseElement.Destroy;
begin
     fBrush.free;
     fPen.free;

     inherited Destroy;
end;


procedure TEllipseElement.DrawElement;
var
     x1, y1, x2, y2: integer;
begin
     if (assigned(Canvas)) and (Visible) then
     begin
          Canvas.Pen.assign(fPen);
          Canvas.Brush.assign(fBrush);

          GetHandPos(haTopLeft, x1, y1);
          GetHandPos(haBottomRight, x2, y2);

          Canvas.Ellipse(x1, y1, x2, y2);
     end;
end;


procedure TEllipseElement.DrawGhost;
var
     R: TRect;
begin
     R := RectInOrder(fGhostRect);

     Canvas.Pen.Color := clWhite;
     Canvas.Pen.Mode := pmXor;
     Canvas.Pen.Style := psDot;
     Canvas.Pen.Width := 1;
     Canvas.Brush.Style := bsClear;

     Canvas.Ellipse(R.Left, R.Top, R.Right, R.Bottom);
end;



function TEllipseElement.PointBelongToElement(X, Y: integer): boolean;
begin
     //	result:=false;

   //	a:=



     result := ((x >= fHandsPos[_HAND_TOPLEFT].x)
          and
          (x <= fHandsPos[_HAND_TOPRIGHT].x)
          and
          (y >= fHandsPos[_HAND_TOPLEFT].y)
          and
          (y <= fHandsPos[_HAND_BOTTOMRIGHT].y));
end;


procedure TEllipseElement.SetBrush(const Value: TBrush);
begin
     fBrush.assign(Value);
end;

procedure TEllipseElement.SetPen(const Value: TPen);
begin
     fPen.assign(Value);
end;

procedure TEllipseElement.SetInitialPos(X, Y: integer);
begin
     fHandsPos[_HAND_TOPLEFT] := point(x - fDelta, y - fDelta);
     fHandsPos[_HAND_MIDDLELEFT] := point(x - fDelta, y);
     fHandsPos[_HAND_BOTTOMLEFT] := point(x - fDelta, y + fDelta);
     fHandsPos[_HAND_TOPRIGHT] := point(x + fDelta, y - fDelta);
     fHandsPos[_HAND_MIDDLERIGHT] := point(x + fDelta, y);
     fHandsPos[_HAND_BOTTOMRIGHT] := point(x + fDelta, y + fDelta);
     fHandsPos[_HAND_MIDDLETOP] := point(x, y - fDelta);
     fHandsPos[_HAND_MIDDLEBOTTOM] := point(x, y + fDelta);

     CalcHandsRect;
end;

function TEllipseElement.CanGrowElementJustAfterCreation(var HandCanMove: THand): boolean;
begin
     result := false;
end;

function TEllipseElement.SaveToIni(fIni: TIniMem; section: string; id: integer): boolean;
var
	w: integer;
begin
	try
		result := inherited SaveToIni(fIni, section, id);

          if result then
          begin
               //Type d'élément
               fIni.WriteString(section, 'Type' + inttostr(id), 'ellipse');

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

               //Le Brush
               fIni.WriteInteger(section, 'BrushColor' + inttostr(id), fBrush.Color);
               fIni.WriteBool(section, 'BrushStyleSolid' + inttostr(id), fBrush.Style = bsSolid);

               result := true;
          end;

     except
          result := false;
     end;
end;

function TEllipseElement.LoadFromIni(fIni: TIniMem; section: string; id: integer): boolean;
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

               //Le Brush
               fBrush.Color := fIni.ReadInteger(section, 'BrushColor' + inttostr(id), clRed);
               if fIni.ReadBool(section, 'BrushStyleSolid' + inttostr(id), true)
                    then fBrush.Style := bsSolid
               else fBrush.Style := bsClear;

               result := true;
          end;

     except
          result := false;
     end;
end;



end.

