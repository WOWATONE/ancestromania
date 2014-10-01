//Ver 1.0.0.1
//Yann UHEL

unit u_objet_TIniMem;

interface

uses
     Classes,
     SysUtils,lazutf8classes;


Type

     TIniMem = class(TObject)
     private
          FFileName: string;
          FSections: TStringlistUTF8;
          function AddSection(const Section: string): TStrings;

     public
          constructor Create;
          destructor Destroy; override;
          procedure Clear;
          function SectionExists(const Section: string): Boolean;
          function ReadString(const Section, Ident, Default: string): string; virtual;
          procedure WriteString(const Section, Ident, Value: String); virtual;
          function ReadInteger(const Section, Ident: string; Default: Longint): Longint; virtual;
          procedure WriteInteger(const Section, Ident: string; Value: Longint); virtual;
          function ReadBool(const Section, Ident: string; Default: Boolean): Boolean; virtual;
          procedure WriteBool(const Section, Ident: string; Value: Boolean); virtual;
		function ReadDate(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
          function ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
          function ReadFloat(const Section, Name: string; Default: Double): Double; virtual;
          function ReadTime(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
          procedure WriteDate(const Section, Name: string; Value: TDateTime); virtual;
          procedure WriteDateTime(const Section, Name: string; Value: TDateTime); virtual;
          procedure WriteFloat(const Section, Name: string; Value: Double); virtual;
          procedure WriteTime(const Section, Name: string; Value: TDateTime); virtual;
          procedure ReadSection(const Section: string; Strings: TStrings); virtual;
          procedure ReadSections(Strings: TStrings); virtual;
          procedure ReadSectionValues(const Section: string; Strings: TStrings); virtual;
          procedure EraseSection(const Section: string); virtual;
          procedure DeleteKey(const Section, Ident: String); virtual;
          procedure UpdateFile; virtual;
          function ValueExists(const Section, Ident: string): Boolean;
          procedure GetStrings(List: TStrings);
          procedure SetStrings(List: TStrings);

          procedure LoadFromFile(theFileName: string);
          procedure SaveToFile(theFileName: string);

		property FileName: string read FFileName;

     end;



implementation

uses FileUtil;

constructor TIniMem.Create;
begin
     FFileName := '';
     FSections := TStringlistUTF8.Create;
end;

function TIniMem.SectionExists(const Section: string): Boolean;
var
     S: TStrings;
begin
     S := TStringlistUTF8.Create;
     try
          ReadSection(Section, S);
          Result := S.Count > 0;
     finally
          S.Free;
     end;
end;

function TIniMem.ReadInteger(const Section, Ident: string;
     Default: Longint): Longint;
var
     IntStr: string;
begin
     IntStr := ReadString(Section, Ident, '');
     if (Length(IntStr) > 2) and (IntStr[1] = '0') and
          ((IntStr[2] = 'X') or (IntStr[2] = 'x')) then
          IntStr := '$' + Copy(IntStr, 3, Maxint);
     Result := StrToIntDef(IntStr, Default);
end;

procedure TIniMem.WriteInteger(const Section, Ident: string; Value: Longint);
begin
     WriteString(Section, Ident, IntToStr(Value));
end;

function TIniMem.ReadBool(const Section, Ident: string;
     Default: Boolean): Boolean;
begin
     Result := ReadInteger(Section, Ident, Ord(Default)) <> 0;
end;

function TIniMem.ReadDate(const Section, Name: string; Default: TDateTime): TDateTime;
var
     DateStr: string;
begin
     DateStr := ReadString(Section, Name, '');
     Result := Default;
     if DateStr <> '' then
     try
          Result := StrToDate(DateStr);
     except
          on EConvertError do
     else raise;
     end;
end;

function TIniMem.ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
     DateStr: string;
begin
     DateStr := ReadString(Section, Name, '');
     Result := Default;
     if DateStr <> '' then
     try
          Result := StrToDateTime(DateStr);
     except
          on EConvertError do
     else raise;
     end;
end;

function TIniMem.ReadFloat(const Section, Name: string; Default: Double): Double;
var
     FloatStr: string;
begin
     FloatStr := ReadString(Section, Name, '');
     Result := Default;
     if FloatStr <> '' then
     try
          Result := StrToFloat(FloatStr);
     except
          on EConvertError do
     else raise;
     end;
end;

function TIniMem.ReadTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
     TimeStr: string;
begin
     TimeStr := ReadString(Section, Name, '');
     Result := Default;
     if TimeStr <> '' then
     try
          Result := StrToTime(TimeStr);
     except
          on EConvertError do
     else raise;
     end;
end;

procedure TIniMem.WriteDate(const Section, Name: string; Value: TDateTime);
begin
     WriteString(Section, Name, DateToStr(Value));
end;

procedure TIniMem.WriteDateTime(const Section, Name: string; Value: TDateTime);
begin
     WriteString(Section, Name, DateTimeToStr(Value));
end;

procedure TIniMem.WriteFloat(const Section, Name: string; Value: Double);
begin
     WriteString(Section, Name, FloatToStr(Value));
end;

procedure TIniMem.WriteTime(const Section, Name: string; Value: TDateTime);
begin
     WriteString(Section, Name, TimeToStr(Value));
end;

procedure TIniMem.WriteBool(const Section, Ident: string; Value: Boolean);
const
     Values: array[Boolean] of string = ('0', '1');
begin
     WriteString(Section, Ident, Values[Value]);
end;

function TIniMem.ValueExists(const Section, Ident: string): Boolean;
var
     S: TStrings;
begin
     S := TStringlistUTF8.Create;
     try
          ReadSection(Section, S);
          Result := S.IndexOf(Ident) > -1;
     finally
          S.Free;
     end;
end;


destructor TIniMem.Destroy;
begin
     if FSections <> nil then Clear;
     FSections.Free;

     inherited;
end;

procedure TIniMem.Clear;
var
     I: Integer;
begin
     for I := 0 to FSections.Count - 1 do
          TStrings(FSections.Objects[I]).Free;
     FSections.Clear;
end;


function TIniMem.AddSection(const Section: string): TStrings;
begin
     Result := TStringlistUTF8.Create;
     try
          FSections.AddObject(Section, Result);
     except
          Result.Free;
     end;
end;


procedure TIniMem.DeleteKey(const Section, Ident: String);
var
     I, J: Integer;
     Strings: TStrings;
begin
     I := FSections.IndexOf(Section);
     if I >= 0 then
     begin
          Strings := TStrings(FSections.Objects[I]);
          J := Strings.IndexOfName(Ident);
          if J >= 0 then Strings.Delete(J);
     end;
end;

procedure TIniMem.EraseSection(const Section: string);
var
     I: Integer;
begin
     I := FSections.IndexOf(Section);
     if I >= 0 then
     begin
          TStrings(FSections.Objects[I]).Free;
          FSections.Delete(I);
     end;
end;

procedure TIniMem.GetStrings(List: TStrings);
var
     I, J: Integer;
     Strings: TStrings;
begin
     List.BeginUpdate;
     try
          for I := 0 to FSections.Count - 1 do
          begin
               List.Add('[' + FSections[I] + ']');
               Strings := TStrings(FSections.Objects[I]);
               for J := 0 to Strings.Count - 1 do List.Add(Strings[J]);
               List.Add('');
          end;
     finally
          List.EndUpdate;
     end;
end;


procedure TIniMem.ReadSection(const Section: string;
     Strings: TStrings);
var
     I, J: Integer;
     SectionStrings: TStrings;
begin
     Strings.BeginUpdate;
     try
          Strings.Clear;
          I := FSections.IndexOf(Section);
          if I >= 0 then
          begin
               SectionStrings := TStrings(FSections.Objects[I]);
               for J := 0 to SectionStrings.Count - 1 do
                    Strings.Add(SectionStrings.Names[J]);
          end;
     finally
          Strings.EndUpdate;
     end;
end;

procedure TIniMem.ReadSections(Strings: TStrings);
begin
     Strings.Assign(FSections);
end;

procedure TIniMem.ReadSectionValues(const Section: string;
     Strings: TStrings);
var
     I: Integer;
begin
     Strings.BeginUpdate;
     try
          Strings.Clear;
          I := FSections.IndexOf(Section);
          if I >= 0 then Strings.Assign(TStrings(FSections.Objects[I]));
     finally
          Strings.EndUpdate;
     end;
end;

function TIniMem.ReadString(const Section, Ident,
     Default: string): string;
var
     I: Integer;
     Strings: TStrings;
begin
     I := FSections.IndexOf(Section);
     if I >= 0 then
     begin
          Strings := TStrings(FSections.Objects[I]);
          I := Strings.IndexOfName(Ident);
          if I >= 0 then
          begin
               Result := Copy(Strings[I], Length(Ident) + 2, Maxint);
               Exit;
          end;
     end;
     Result := Default;
end;


procedure TIniMem.SetStrings(List: TStrings);
var
     I: Integer;
     S: string;
     Strings: TStrings;
begin
     Clear;
     Strings := nil;
     for I := 0 to List.Count - 1 do
     begin
          S := List[I];
          if (S <> '') and (S[1] <> ';') then
               if (S[1] = '[') and (S[Length(S)] = ']') then
                    Strings := AddSection(Copy(S, 2, Length(S) - 2))
               else
                    if Strings <> nil then Strings.Add(S);
     end;
end;

procedure TIniMem.UpdateFile;
var
     List: TStringlistUTF8;
begin
     List := TStringlistUTF8.Create;
     try
          GetStrings(List);
		List.SaveToFile(FFileName);
     finally
          List.Free;
     end;
end;

procedure TIniMem.WriteString(const Section, Ident, Value: String);
var
     I: Integer;
     S: string;
     Strings: TStrings;
begin
     I := FSections.IndexOf(Section);
     if I >= 0 then
          Strings := TStrings(FSections.Objects[I]) else
          Strings := AddSection(Section);
     S := Ident + '=' + Value;
     I := Strings.IndexOfName(Ident);
     if I >= 0 then Strings[I] := S else Strings.Add(S);
end;

procedure TIniMem.LoadFromFile(theFileName: string);
var
	List: TStringlistUTF8;
begin
	if (theFileName <> '') and FileExistsUTF8(theFileName) then
	begin
		List := TStringlistUTF8.Create;
		try
			List.LoadFromFile(theFileName);
			SetStrings(List);
		finally
			List.Free;
		end;
	end else Clear;
end;

procedure TIniMem.SaveToFile(theFileName: string);
var
	List: TStringlistUTF8;
begin
	FFileName:=theFileName;
	
	List := TStringlistUTF8.Create;
	try
		GetStrings(List);
		List.SaveToFile(theFileName);
	finally
		List.Free;
	end;
end;



end.

