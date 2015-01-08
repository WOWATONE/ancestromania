unit u_objet_TTextElement;

interface

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
     Classes,
     Graphics,
     stdctrls,
{$IFDEF FPC}
     LCLType, LCLIntf,lazutf8classes,
{$ELSE}
     Windows,
{$ENDIF}
     u_objet_TIniMem,
     u_objet_TGraphicElement,
     u_objet_TRectangleElement;

type
     TTextElement = class(TRectangleElement)
     private
          fFont: TFont;
          fLines: TStringlistUTF8;



     protected


     public

          constructor Create; override;
          destructor Destroy; override;

		procedure DrawElement; override;
		function LoadFromIni(fIni: TIniMem; section: string; id: integer): boolean; override;
		function SaveToIni(fIni: TInimem; section: string; id: integer): boolean; override;


          property Font: TFont read fFont write fFont;
          property Lines: TStringlistUTF8 read fLines write fLines;
     end;

implementation

uses
     SysUtils;

{ TRectangleElement }

constructor TTextElement.Create;
begin
     inherited Create;

     fFont := TFont.create;
     fFont.Color := clRed;
     fLines := TStringlistUTF8.create;
end;

destructor TTextElement.Destroy;
begin
     fFont.free;
     fLines.free;

     inherited Destroy;
end;


procedure TTextElement.DrawElement;
var
     x1, y1, x2, y2: integer;
     R: TRect;
     s: string;
begin
     inherited;

     if (assigned(Canvas)) and (Visible) then
     begin
          Canvas.Font := fFont;
          GetHandPos(haTopLeft, x1, y1);
          GetHandPos(haBottomRight, x2, y2);

          R := Rect(x1, y1, x2, y2);
          InflateRect(R, -2, -2);
          s := fLines.Text;

          DrawText(Canvas.Handle, PChar(s), length(s), R, DT_WORDBREAK);
     end;
end;



function TTextElement.SaveToIni(fIni: TIniMem; section: string; id: integer): boolean;
var
     n: integer;
begin
     try
		result := inherited SaveToIni(fIni, section, id);

          if result then
          begin
               //Type d'élément
               fIni.WriteString(section, 'Type' + inttostr(id), 'texte');

               //La font
               fIni.WriteString(section, 'Font' + inttostr(id), FontToString(fFont));

               //le texte de l'élément
               fIni.WriteInteger(section, 'NbLines' + inttostr(id), fLines.Count);
               for n := 0 to fLines.Count - 1 do
               begin
                    fIni.WriteString(section, 'Lines' + inttostr(id) + '_' + inttostr(n), fLines[n]);
               end;

               result := true;
          end;

     except
          result := false;
     end;
end;

function TTextElement.LoadFromIni(fIni: TIniMem; section: string; id: integer): boolean;
var
     n, w: integer;
begin
     fLines.Clear;
     try
		result := inherited LoadFromIni(fIni, section, id);

          if result then
          begin
               //La font
               StringToFont(fIni.ReadString(section, 'Font' + inttostr(id), ''), fFont);

               //le texte de l'élément
               w := fIni.ReadInteger(section, 'NbLines' + inttostr(id), 0);
               for n := 0 to w - 1 do
               begin
                    fLines.Add(fIni.ReadString(section, 'Lines' + inttostr(id) + '_' + inttostr(n), ''));
			end;

			result:=true;
          end;

     except
          result := false;
     end;
end;




end.

