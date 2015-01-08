//Unité permettant de s'affranchir de la limitation des 64k
//Yann UHEL

unit u_objet_TBigIniFile;

{$B-}

interface

uses Classes,lazutf8classes;

type


     TBigIniFile = class(TObject)
     private
          FFileName: string;
          FFileBuffer: TStringlistUTF8;
          function GetName(const Line: string): string;
          function GetValue(const Line, Name: string): string;
          function IsSection(const Line: string): Boolean;
          function GetSectionIndex(const Section: string): Integer;
     protected
          procedure LoadFromFile;
          procedure SaveToFile;
     public
          constructor Create(const FileName: string);
          destructor Destroy; override;
          procedure DeleteKey(const Section, Ident: string);
          procedure EraseSection(const Section: string);
          function ReadBool(const Section, Ident: string; Default: Boolean): Boolean;
          function ReadInteger(const Section, Ident: string; Default: Longint): Longint;
          procedure ReadSection(const Section: string; Strings: TStrings);
          procedure ReadSections(Strings: TStrings);
          procedure ReadSectionValues(const Section: string; Strings: TStrings);
          function ReadString(const Section, Ident: string; Default: string): string;
          procedure WriteBool(const Section, Ident: string; Value: Boolean);
          procedure WriteInteger(const Section, Ident: string; Value: Longint);
          procedure WriteString(const Section, Ident: string; Value: string);
          property FileName: string read FFileName;
     end;

implementation

uses SysUtils,FileUtil;

resourcestring



     SStringsUnassignedError = 'Param Strings must be assigned';

const
     Brackets: array[0..1] of Char = ('[', ']');
     Separator: Char = '=';

function AnsiPos(const Substr, S: string): Integer;
begin
     Result := System.Pos(Substr, S);
end;


constructor TBigIniFile.Create(const FileName: string);
begin
     FFileName := FileName;
     FFileBuffer := TStringlistUTF8.Create;
     if FileExistsUTF8(FileName) then LoadFromFile;
end;

destructor TBigIniFile.Destroy;
begin
     FFileBuffer.Free;
     Finalize(FFileName);
end;

function TBigIniFile.GetName(const Line: string): string;
var
     I: Integer;
begin
     I := AnsiPos(Separator, Line);
     if I <> 0 then Result := Trim(System.Copy(Line, 1, I - 1))
     else Result := EmptyStr;
end;

function TBigIniFile.GetValue(const Line, Name: string): string;
var
     I, J: Integer;
begin
     Result := EmptyStr;
     if (Line <> EmptyStr) and (Name <> EmptyStr) then
     begin
          I := AnsiPos(Name, Line);
          J := AnsiPos(Separator, Line);
          if (I <> 0) and (J <> 0) and (J > I) then
               Result := Trim(System.Copy(Line, J + 1, Maxint));
     end;
end;

function TBigIniFile.IsSection(const Line: string): Boolean;
var
     S: string;
begin
     Result := False;
     if Line <> EmptyStr then
     begin
          S := Trim(Line);
          if (S[1] = Brackets[0]) and (S[System.Length(S)] = Brackets[1]) then
               Result := True;
     end;
end;

function TBigIniFile.GetSectionIndex(const Section: string): Integer;
begin
     Result := FFileBuffer.IndexOf(Brackets[0] + Section + Brackets[1]);
end;

procedure TBigIniFile.LoadFromFile;
begin
     FFileBuffer.LoadFromFile(FFileName);
end;

procedure TBigIniFile.SaveToFile;
begin
     FFileBuffer.SaveToFile(FFileName);
end;



procedure TBigIniFile.ReadSection(const Section: string; Strings: TStrings);
var
     I: Integer;
     N: string;
begin
     Assert(Assigned(Strings), SStringsUnassignedError);
     Strings.BeginUpdate;
     try
          Strings.Clear;
          if FFileBuffer.Count > 0 then
          begin
               I := GetSectionIndex(Section);
               if I <> -1 then
               begin
                    Inc(I);
                    while (I < FFileBuffer.Count) and not IsSection(FFileBuffer[I]) do
                    begin
                         N := GetName(FFileBuffer[I]);
                         if N <> EmptyStr then Strings.Add(N);
                         Inc(I);
                    end;
               end;
          end;
     finally
          Strings.EndUpdate;
     end;
end;



procedure TBigIniFile.ReadSections(Strings: TStrings);
var
     I: Integer;
     Section: string;
begin
     Assert(Assigned(Strings), SStringsUnassignedError);
     Strings.BeginUpdate;
     try
          Strings.Clear;
          if FFileBuffer.Count > 0 then
          begin
               I := 0;
               while (I < FFileBuffer.Count) do
               begin
                    if IsSection(FFileBuffer[I]) then
                    begin
                         Section := Trim(FFileBuffer[I]);
                         System.Delete(Section, 1, 1);
                         System.Delete(Section, System.Length(Section), 1);
                         Strings.Add(Trim(Section));
                    end;
                    Inc(I);
               end;
          end;
     finally
          Strings.EndUpdate;
     end;
end;



function TBigIniFile.ReadString(const Section, Ident: string; Default: string): string;
var
     I: Integer;
     V: string;
begin
     Result := Default;
     if FFileBuffer.Count > 0 then
     begin
          I := GetSectionIndex(Section);
          if I <> -1 then
          begin
               Inc(I);
               while (I < FFileBuffer.Count) and not IsSection(FFileBuffer[I]) do
               begin
                    if GetName(FFileBuffer[I]) = Ident then
                    begin
                         V := GetValue(FFileBuffer[I], Ident);
                         if V <> EmptyStr then Result := V;
                         Exit;
                    end;
                    Inc(I);
               end;
          end;
     end;
end;



function TBigIniFile.ReadInteger(const Section, Ident: string; Default: Longint): Longint;
var
     IntStr: string;
begin
     IntStr := ReadString(Section, Ident, '');
     if (Length(IntStr) > 2) and (IntStr[1] = '0') and ((IntStr[2] = 'X') or (IntStr[2] = 'x')) then
          IntStr := '$' + System.Copy(IntStr, 3, Maxint);
     Result := StrToIntDef(IntStr, Default);
end;


function TBigIniFile.ReadBool(const Section, Ident: string; Default: Boolean): Boolean;
begin
     Result := ReadInteger(Section, Ident, Ord(Default)) <> 0;
end;



procedure TBigIniFile.ReadSectionValues(const Section: string; Strings: TStrings);
var
     N, V: string;
     I: Integer;
begin
     Assert(Assigned(Strings), SStringsUnassignedError);
     Strings.BeginUpdate;
     try
          Strings.Clear;
          if FFileBuffer.Count > 0 then
          begin
               I := GetSectionIndex(Section);
               if I <> -1 then
               begin
                    Inc(I);
                    while (I < FFileBuffer.Count) and not IsSection(FFileBuffer[I]) do
                    begin
                         N := GetName(FFileBuffer[I]);
                         if N <> EmptyStr then
                         begin
                              V := GetValue(FFileBuffer[I], N);
                              Strings.Add(N + Separator + V);
                         end;
                         Inc(I);
                    end;
               end;
          end;
     finally
          Strings.EndUpdate;
     end;
end;



procedure TBigIniFile.WriteString(const Section, Ident: string; Value: string);
var
     I: Integer;
begin
     I := GetSectionIndex(Section);
     if I <> -1 then
     begin
          Inc(I);
          while (I < FFileBuffer.Count) and not IsSection(FFileBuffer[I]) and
               (GetName(FFileBuffer[I]) <> Ident) do Inc(I);

          if (I >= FFileBuffer.Count) or IsSection(FFileBuffer[I]) then
          begin
               if Ident <> EmptyStr then FFileBuffer.Insert(I, Ident + Separator + Value);
          end

          else if Ident <> EmptyStr then FFileBuffer[I] := Ident + Separator + Value;
     end

     else
     begin
          FFileBuffer.Add(EmptyStr);
          FFileBuffer.Add(Brackets[0] + Section + Brackets[1]);
          if Ident <> EmptyStr then FFileBuffer.Add(Ident + Separator + Value);
     end;
     SaveToFile;
end;


procedure TBigIniFile.WriteInteger(const Section, Ident: string; Value: Longint);
begin
     WriteString(Section, Ident, IntToStr(Value));
end;



procedure TBigIniFile.WriteBool(const Section, Ident: string; Value: Boolean);
const
     Values: array[Boolean] of string = ('0', '1');
begin
     WriteString(Section, Ident, Values[Value]);
end;



procedure TBigIniFile.DeleteKey(const Section, Ident: string);
var
     I: Integer;
begin
     I := GetSectionIndex(Section);
     if I <> -1 then
     begin
          Inc(I);
          while (I < FFileBuffer.Count) and not IsSection(FFileBuffer[I]) and
               (GetName(FFileBuffer[I]) <> Ident) do Inc(I);

          if not (I >= FFileBuffer.Count) and not IsSection(FFileBuffer[I]) then
          begin
               FFileBuffer.Delete(I);
               SaveToFile;
          end;
     end;
end;



procedure TBigIniFile.EraseSection(const Section: string);
var
     I: Integer;
begin
     I := GetSectionIndex(Section);
     if I <> -1 then
     begin
          FFileBuffer.Delete(I);
          while (I < FFileBuffer.Count) and not IsSection(FFileBuffer[I]) do
               FFileBuffer.Delete(I);
          if I > 0 then FFileBuffer.Insert(I, EmptyStr);
          SaveToFile;
     end;
end;

end.

