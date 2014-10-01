unit u_objet_TGraphicElement;

interface


{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
	Classes,
{$IFDEF FPC}
     LCLType, LCLIntf,
{$ELSE}
     Windows,
{$ENDIF}
	Graphics,
	u_objet_TIniMem;


const

	_HAND_TOPLEFT = 1;
	_HAND_MIDDLELEFT = 2;
	_HAND_BOTTOMLEFT = 3;
	_HAND_TOPRIGHT = 4;
	_HAND_MIDDLERIGHT = 5;
	_HAND_BOTTOMRIGHT = 6;
	_HAND_MIDDLETOP = 7;
	_HAND_MIDDLEBOTTOM = 8;


type
	THand = (haTopLeft, haMiddleLeft, haBottomLeft, haTopRight, haMiddleRight, haBottomRight, haMiddleTop, haMiddleBottom);
	THands = set of THand;

     TGraphicElement = class

     private

          fVisible: boolean;
          fHands: THands;
          fBrushHands: TBrush;
          fCanvas: TCanvas;
          fPenHands: TPen;



		procedure SetBrushHands(const Value: TBrush);
          procedure SetPenHands(const Value: TPen);
          procedure CalcHandsMiddlePos;
          function CalcHandRect(p: TPoint): TRect;

     protected
          fHandsRect: array[1..8] of TRect;
          fHandsPos: array[1..8] of TPoint;
          fGhostHandMove: THand;
          fGhostRect: TRect;
          fGhostPointMove: TPoint;
          fGhostPointFixed: TPoint;


          procedure DrawAHand(aHand: THand); virtual;
          procedure SetHandPos(aHand: THand; X, Y: integer);
          procedure GetHandPos(aHand: THand; var X, Y: integer);
		procedure ExchangeHandPos(Hand1, Hand2: THand);
          procedure GetHandRect(aHand: THand; var R: TRect);

     public
          constructor Create; virtual;
          destructor Destroy; override;
          //	    procedure SetPos(x,y

          procedure DrawElement; virtual; abstract;
          procedure DrawGhost; virtual;
          procedure DrawHands; virtual;
          function PointBelongToElement(X, Y: integer): boolean; virtual; abstract;
          function PointBelongToHand(X, Y: integer; var Hand: THand): boolean; virtual;
          procedure SetInitialPos(X, Y: integer); virtual;
		function CanMoveHand(aHand: THand): boolean; virtual;
		procedure SetNewHandPos(aHand: THand; X, Y: integer; var NewHand: THand); virtual;
		function CanGrowElementJustAfterCreation(var HandCanMove: THand): boolean; virtual;

		procedure StartGrowGhost(GhostHandMove: THand; X, Y: integer); virtual;
		procedure StopGrowGhost; virtual;
		procedure SetGhostHandMovePos(X, Y: integer); virtual;

		procedure StartMoveGhost(X, Y: integer); virtual;
		procedure SetGhostPos(X, Y: integer); virtual;
		procedure StopMoveGhost; virtual;

		function RectInOrder(aRect: TRect): TRect;
		procedure CalcHandsRect; virtual;


		function SaveToIni(fIni: TIniMem; section: string; id: integer): boolean; virtual;
		function LoadFromIni(fIni: TIniMem; section: string; id: integer): boolean; virtual;

          function FontToString(Font: TFont): string;
          procedure StringToFont(Str: string; Font: TFont);


          property Visible: boolean read fVisible write fVisible;
          property Hands: THands read fHands write fHands;
          property Canvas: TCanvas read fCanvas write fCanvas;
          property PenHands: TPen read fPenHands write SetPenHands;
          property BrushHands: TBrush read fBrushHands write SetBrushHands;


     end;


     //procedure DrawOneHand

implementation

uses
     SysUtils;

{ TGraphicElement }

constructor TGraphicElement.Create;
var
     n: integer;
begin
     fCanvas := nil;
     fVisible := true;
     fBrushHands := TBrush.create;
     fBrushHands.Color := clRed;
     fBrushHands.Style := bsSolid;


     fPenHands := TPen.create;


     fHands := [haTopLeft, haMiddleLeft, haBottomLeft, haTopRight, haMiddleRight, haBottomRight, haMiddleTop, haMiddleBottom];

     for n := 1 to 8 do fHandsPos[n] := point(0, 0);
     CalcHandsRect;
end;


destructor TGraphicElement.Destroy;
begin
     fBrushHands.free;
     fPenHands.free;


     inherited Destroy;
end;


procedure TGraphicElement.DrawAHand(aHand: THand);
var
     R: TRect;
begin
     GetHandRect(aHand, R);
     fCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
end;


procedure TGraphicElement.DrawHands;
begin
     if (fHands <> []) and (assigned(fCanvas)) and (fVisible) then
     begin
          fCanvas.Pen := fPenHands;
          fCanvas.Brush := fBrushHands;

          if (haTopLeft in fHands) then DrawAHand(haTopLeft);
          if (haMiddleLeft in fHands) then DrawAHand(haMiddleLeft);
          if (haBottomLeft in fHands) then DrawAHand(haBottomLeft);
          if (haTopRight in fHands) then DrawAHand(haTopRight);
          if (haMiddleRight in fHands) then DrawAHand(haMiddleRight);
          if (haBottomRight in fHands) then DrawAHand(haBottomRight);
          if (haMiddleTop in fHands) then DrawAHand(haMiddleTop);
          if (haMiddleBottom in fHands) then DrawAHand(haMiddleBottom);
     end;
end;


procedure TGraphicElement.GetHandRect(aHand: THand; var R: TRect);
begin
     case aHand of
          haTopLeft: R := fHandsRect[1];
          haMiddleLeft: R := fHandsRect[2];
          haBottomLeft: R := fHandsRect[3];
          haTopRight: R := fHandsRect[4];
          haMiddleRight: R := fHandsRect[5];
          haBottomRight: R := fHandsRect[6];
          haMiddleTop: R := fHandsRect[7];
     else
          R := fHandsRect[8]; //haMiddleBottom
     end;
end;



procedure TGraphicElement.GetHandPos(aHand: THand; var X, Y: integer);
var
     P: TPoint;
begin
     case aHand of
          haTopLeft: P := fHandsPos[_HAND_TOPLEFT];
          haMiddleLeft: P := fHandsPos[_HAND_MIDDLELEFT];
          haBottomLeft: P := fHandsPos[_HAND_BOTTOMLEFT];
          haTopRight: P := fHandsPos[_HAND_TOPRIGHT];
          haMiddleRight: P := fHandsPos[_HAND_MIDDLERIGHT];
          haBottomRight: P := fHandsPos[_HAND_BOTTOMRIGHT];
          haMiddleTop: P := fHandsPos[_HAND_MIDDLETOP];
     else
          P := fHandsPos[_HAND_MIDDLEBOTTOM];
     end;


     X := P.X;
     Y := P.Y;
end;



function TGraphicElement.PointBelongToHand(X, Y: integer; var Hand: THand): boolean;
var
     R: TRect;
     P: TPoint;
begin
     result := false;
     if fVisible then
     begin
          P := point(X, Y);
          GetHandRect(Hand, R);


          if (haTopLeft in fHands) then
          begin
               GetHandRect(haTopLeft, R);
               if PtInRect(R, P) then begin Hand := haTopLeft; result := true; end;
          end;
          if (haMiddleLeft in fHands) then
          begin
               GetHandRect(haMiddleLeft, R);
               if PtInRect(R, P) then begin Hand := haMiddleLeft; result := true; end;
          end;
          if (haBottomLeft in fHands) then
          begin
               GetHandRect(haBottomLeft, R);
               if PtInRect(R, P) then begin Hand := haBottomLeft; result := true; end;
          end;
          if (haTopRight in fHands) then
          begin
               GetHandRect(haTopRight, R);
               if PtInRect(R, P) then begin Hand := haTopRight; result := true; end;
          end;
          if (haMiddleRight in fHands) then
          begin
               GetHandRect(haMiddleRight, R);
               if PtInRect(R, P) then begin Hand := haMiddleRight; result := true; end;
          end;
          if (haBottomRight in fHands) then
          begin
               GetHandRect(haBottomRight, R);
               if PtInRect(R, P) then begin Hand := haBottomRight; result := true; end;
          end;
          if (haMiddleTop in fHands) then
          begin
               GetHandRect(haMiddleTop, R);
               if PtInRect(R, P) then begin Hand := haMiddleTop; result := true; end;
          end;
          if (haMiddleBottom in fHands) then
          begin
               GetHandRect(haMiddleBottom, R);
               if PtInRect(R, P) then begin Hand := haMiddleBottom; result := true; end;
          end;
     end;
end;

procedure TGraphicElement.SetBrushHands(const Value: TBrush);
begin
     fBrushHands.assign(Value);
end;

procedure TGraphicElement.SetHandPos(aHand: THand; X, Y: integer);
var
     R: TRect;
begin
     R := rect(X - 2, Y - 2, X + 2, Y + 2);

     case aHand of
          haTopLeft: fHandsRect[1] := R;
          haMiddleLeft: fHandsRect[2] := R;
          haBottomLeft: fHandsRect[3] := R;
          haTopRight: fHandsRect[4] := R;
          haMiddleRight: fHandsRect[5] := R;
          haBottomRight: fHandsRect[6] := R;
          haMiddleTop: fHandsRect[7] := R;
          haMiddleBottom: fHandsRect[8] := R;
     end;
end;

procedure TGraphicElement.SetPenHands(const Value: TPen);
begin
     fPenHands.assign(Value);
end;

procedure TGraphicElement.SetInitialPos(X, Y: integer);
var
     n: integer;
begin
     for n := 1 to 8 do fHandsPos[n] := point(x, y);
     CalcHandsRect;
end;

function TGraphicElement.CanMoveHand(aHand: THand): boolean;
begin
     result := (aHand in Hands);
end;

procedure TGraphicElement.SetNewHandPos(aHand: THand; X, Y: integer; var NewHand: THand);
begin
end;

procedure TGraphicElement.ExchangeHandPos(Hand1, Hand2: THand);
var
     x1, y1, x2, y2: integer;
begin
     GetHandPos(Hand1, x1, y1);
     GetHandPos(Hand2, x2, y2);
     SetHandPos(Hand1, x2, y2);
     SetHandPos(Hand2, x1, y2);
end;

function TGraphicElement.CanGrowElementJustAfterCreation(var HandCanMove: THand): boolean;
begin
     result := true;
     HandCanMove := haBottomRight;
end;



procedure TGraphicElement.StartGrowGhost(GhostHandMove: THand; X, Y: integer);
begin
     fGhostHandMove := GhostHandMove;

     fGhostPointMove.X := X;
     fGhostPointMove.Y := Y;

     case GhostHandMove of
          haTopLeft: fGhostPointFixed := fHandsPos[_HAND_BOTTOMRIGHT];
          haTopRight: fGhostPointFixed := fHandsPos[_HAND_BOTTOMLEFT];
          haBottomLeft: fGhostPointFixed := fHandsPos[_HAND_TOPRIGHT];
          haBottomRight: fGhostPointFixed := fHandsPos[_HAND_TOPLEFT];
     end;

     fGhostRect := rect(fGhostPointFixed.X, fGhostPointFixed.y, fGhostPointMove.X, fGhostPointMove.Y);
end;


procedure TGraphicElement.CalcHandsMiddlePos;
var
     xm, ym: integer;
begin
     xm := fHandsPos[_HAND_TOPLEFT].x + ((fHandsPos[_HAND_TOPRIGHT].x - fHandsPos[_HAND_TOPLEFT].x) div 2);
     ym := fHandsPos[_HAND_TOPLEFT].y + ((fHandsPos[_HAND_BOTTOMLEFT].y - fHandsPos[_HAND_TOPLEFT].y) div 2);


     fHandsPos[_HAND_MIDDLETOP].x := xm;
     fHandsPos[_HAND_MIDDLETOP].y := fHandsPos[_HAND_TOPLEFT].y;

     fHandsPos[_HAND_MIDDLEBOTTOM].x := xm;
     fHandsPos[_HAND_MIDDLEBOTTOM].y := fHandsPos[_HAND_BOTTOMLEFT].y;

     fHandsPos[_HAND_MIDDLELEFT].x := fHandsPos[_HAND_TOPLEFT].x;
     fHandsPos[_HAND_MIDDLELEFT].y := ym;

     fHandsPos[_HAND_MIDDLERIGHT].x := fHandsPos[_HAND_TOPRIGHT].x;
     fHandsPos[_HAND_MIDDLERIGHT].y := ym;
end;


procedure TGraphicElement.StopGrowGhost;
var
     R: TRect;
begin
     R := RectInOrder(Rect(fGhostPointFixed.x, fGhostPointFixed.y, fGhostPointMove.x, fGhostPointMove.y));

     fHandsPos[_HAND_TOPLEFT] := R.TopLeft;
     fHandsPos[_HAND_BOTTOMRIGHT] := R.BottomRight;
     fHandsPos[_HAND_TOPRIGHT] := point(R.Right, R.Top);
     fHandsPos[_HAND_BOTTOMLEFT] := point(R.Left, R.Bottom);

     CalcHandsMiddlePos;

     CalcHandsRect;
end;


procedure TGraphicElement.DrawGhost;
var
     R: TRect;
begin
     //	DrawFocusRect(fCanvas.Handle, RectInOrder(fGhostRect));

     Canvas.Pen.Color := clWhite;
     Canvas.Pen.Mode := pmXor;
     Canvas.Pen.Style := psDot;
     Canvas.Pen.Width := 1;
     Canvas.Brush.Style := bsClear;
     R := RectInOrder(fGhostRect);

     Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
end;


function TGraphicElement.RectInOrder(aRect: TRect): TRect;
begin
     result := aRect;
     if aRect.Left > aRect.Right then
     begin
          result.Left := aRect.Right;
          result.Right := aRect.Left;
     end;

     if aRect.Top > aRect.Bottom then
     begin
          result.Top := aRect.Bottom;
          result.Bottom := aRect.Top;
     end;
end;


function TGraphicElement.CalcHandRect(p: TPoint): TRect;
begin
     result := Rect(p.x - 3, p.y - 3, p.x + 3, p.y + 3);
end;


procedure TGraphicElement.CalcHandsRect;
var
     n: integer;
begin
     for n := 1 to 8 do fHandsRect[n] := CalcHandRect(fHandsPos[n]);
end;



procedure TGraphicElement.StartMoveGhost(X, Y: integer);
begin
     fGhostPointFixed.X := X;
     fGhostPointFixed.Y := Y;
     fGhostPointMove.X := X;
     fGhostPointMove.Y := Y;
     fGhostRect := Rect(fHandsPos[_HAND_TOPLEFT].X, fHandsPos[_HAND_TOPLEFT].Y, fHandsPos[_HAND_BOTTOMRIGHT].X, fHandsPos[_HAND_BOTTOMRIGHT].Y);
end;



procedure TGraphicElement.SetGhostPos(X, Y: integer);
var
     decalX: integer;
     decalY: integer;
begin
     if ((X <> fGhostPointMove.X) or (Y <> fGhostPointMove.Y)) then
     begin
          decalX := X - fGhostPointFixed.x;
          decalY := Y - fGhostPointFixed.y;

          fGhostRect := Rect(fHandsPos[_HAND_TOPLEFT].X + decalX, fHandsPos[_HAND_TOPLEFT].Y + decalY, fHandsPos[_HAND_BOTTOMRIGHT].X + decalX, fHandsPos[_HAND_BOTTOMRIGHT].Y + decalY);
          fGhostPointMove.X := X;
          fGhostPointMove.Y := Y;
     end;
end;


procedure TGraphicElement.SetGhostHandMovePos(X, Y: integer);
var
     decalX: integer;
     decalY: integer;
begin
     //     if ((X <> fGhostPointMove.X) or (Y <> fGhostPointMove.Y)) then
     begin
          //          decalX := X - fGhostPointFixed.x;
           //		decalY := Y - fGhostPointFixed.y;
          decalX := 0;
          decalY := 0;
          case fGhostHandMove of

               haMiddleLeft, haMiddleRight:
                    begin
                         fGhostRect := rect(fGhostPointFixed.X, fGhostPointFixed.y, X + decalX, fGhostPointMove.Y + decalY);
                         fGhostPointMove.X := X;
                    end;

               haMiddleTop, haMiddleBottom:
                    begin
                         fGhostRect := rect(fGhostPointFixed.X, fGhostPointFixed.y, fGhostPointMove.X + decalX, Y + decalY);
                         fGhostPointMove.Y := Y;
                    end;

          else
               begin
                    fGhostRect := rect(fGhostPointFixed.X, fGhostPointFixed.y, X + decalX, Y + decalY);
                    fGhostPointMove.X := X;
                    fGhostPointMove.Y := Y;
               end;
          end;


          fGhostRect := rect(fGhostPointFixed.X, fGhostPointFixed.y, X + decalX, Y + decalY);
          fGhostPointMove.X := X;
          fGhostPointMove.Y := Y;
     end;
end;



procedure TGraphicElement.StopMoveGhost;
begin
     fHandsPos[_HAND_TOPLEFT] := fGhostRect.TopLeft;
     fHandsPos[_HAND_BOTTOMRIGHT] := fGhostRect.BottomRight;
     fHandsPos[_HAND_TOPRIGHT] := point(fGhostRect.Right, fGhostRect.Top);
	fHandsPos[_HAND_BOTTOMLEFT] := point(fGhostRect.Left, fGhostRect.Bottom);

	CalcHandsMiddlePos;

	CalcHandsRect;
end;

function TGraphicElement.SaveToIni(fIni: TIniMem; section: string; id: integer): boolean;
var
	n: integer;
begin
	try
		for n := 1 to 8 do
		begin
			fIni.WriteInteger(section, 'Hand' + inttostr(id) + '_x' + inttostr(n), fHandsPos[n].x);
			fIni.WriteInteger(section, 'Hand' + inttostr(id) + '_y' + inttostr(n), fHandsPos[n].y);
		end;

		result := true;
	except
		result := false;
	end;
end;

function TGraphicElement.LoadFromIni(fIni: TIniMem; section: string; id: integer): boolean;
var
	n: integer;
begin
	try
          for n := 1 to 8 do
		begin
			fHandsPos[n].x := fIni.ReadInteger(section, 'Hand' + inttostr(id) + '_x' + inttostr(n), 0);
			fHandsPos[n].y := fIni.ReadInteger(section, 'Hand' + inttostr(id) + '_y' + inttostr(n), 0);
		end;

		result := true;
     except
		result := false;
	end;
end;



function TGraphicElement.FontToString(Font: TFont): string;
begin
     Result := Format('%s,%d,%d%d%d%d,%s', [Font.Name, Font.Size,
          Integer(fsBold in Font.Style), Integer(fsItalic in Font.Style),
               Integer(fsUnderline in Font.Style), Integer(fsStrikeOut in Font.Style),
               ColorToString(Font.Color)]);
end;

procedure TGraphicElement.StringToFont(Str: string; Font: TFont);
const
     SEP = ',';
     EXCEPT_MSG = 'Invalid string to font conversion.';
var
     i: Integer;
begin
     // name
     i := Pos(SEP, Str);
     if i = 0 then raise EConvertError.Create(EXCEPT_MSG);
     Font.Name := Copy(Str, 1, i - 1);
     Delete(Str, 1, i);

     // size
     i := Pos(SEP, Str);
     if i = 0 then raise EConvertError.Create(EXCEPT_MSG);
     Font.Size := StrToInt(Copy(Str, 1, i - 1));
     Delete(Str, 1, i);

     // bold, italic, underline, strikethrough
     if Pos(SEP, Str) <> 5 then raise EConvertError.Create(EXCEPT_MSG);
     Font.Style := [];
     if Boolean(StrToInt(Copy(Str, 1, 1))) then Font.Style := Font.Style + [fsBold];
     if Boolean(StrToInt(Copy(Str, 2, 1))) then Font.Style := Font.Style + [fsItalic];
     if Boolean(StrToInt(Copy(Str, 3, 1))) then Font.Style := Font.Style + [fsUnderline];
     if Boolean(StrToInt(Copy(Str, 4, 1))) then Font.Style := Font.Style + [fsStrikeOut];

     Delete(Str, 1, 5);

     // colour
     Font.Color := StringToColor(Str);
end;


end.

