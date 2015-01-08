//================================================================================
//Auteur	: Yann UHEL - MKO
//Date	: 19-Aout-1998
//================================================================================


unit u_objet_TCut;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
     LCLType, LCLIntf,
{$ELSE}
     Windows,dbtables,
{$ENDIF}
     Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, db;

type
     TCut = class(TObject)

     private
          FLine: String;
          FParamSeparator: String;
          FStringDelimitor: String;
          FParams: TParams;
          FNoProblem: Byte;

          procedure FillParam(idx: integer; s: string);


     protected

     public
          property Params: TParams read FParams write FParams;

          constructor Create;
          destructor destroy; override;

          function StrToParams: boolean;
          procedure ParamsToStr;
          function GetTotalParamInLine: integer;
          procedure SetTotalStringParams(TotParam: integer);
          procedure SetParamCountAsInLine;


     published
          property Line: String read FLine write FLine;
          property ParamSeparator: String read FParamSeparator write FParamSeparator;
          property StringDelimitor: String read FStringDelimitor write FStringDelimitor;
          property NoProblem: Byte read FNoProblem;

     end;



implementation

const
     _PB1 = 1;
     _PBS1 = 'Aucune chaîne à découper';

     _PB2 = 2;
     _PBS2 = 'Il manque un paramètre dans "Params"';

     _PB3 = 3;
     _PBS3 = 'Paramètre incompatible';



constructor TCut.Create;
begin
     inherited Create;

     FParams := TParams.Create;
     FParamSeparator := ';';
     FStringDelimitor := '';
     FNoProblem := 0;
     FLine := '';
end;


destructor TCut.destroy;
begin
     FParams.Free;

     inherited destroy;
end;


procedure TCut.SetTotalStringParams(TotParam: integer);
var
     n: integer;
begin
     FParams.Clear;
     for n := 1 to TotParam do
          FParams.CreateParam(ftString, 'Param' + inttostr(n - 1), ptInputOutput);
end;


function TCut.StrToParams: boolean;
var
     p: integer;
     idx: integer; //index du paramètre à traiter
     s: string;
begin
     result := true;
     idx := 0;
     FNoProblem := 0;
     s := FLine;

     if s <> '' then
     begin
          repeat

               p := pos(FParamSeparator, s);

               if p = 0 then
               begin
                    FillParam(Idx, s);
               end
               else
               begin
                    FillParam(Idx, copy(s, 1, p - 1));
                    delete(s, 1, p);
               end;

               idx := idx + 1;

               if FNoProblem <> 0 then p := 0;

          until p = 0;
     end
     else
     begin
          result := false;
          FNoProblem := _PB1;
     end;

end;


procedure TCut.ParamsToStr;
var
     n: integer;
begin
     FLine := '';
     for n := 1 to FParams.count do
     begin
          if n > 1 then FLine := FLine + FParamSeparator;
          if FParams[n - 1].DataType = ftString
               then FLine := FLine + FStringDelimitor + FParams[n - 1].text + FStringDelimitor
          else FLine := FLine + FParams[n - 1].text;
     end;
end;


procedure TCut.FillParam(idx: integer; s: string);
var
     p: integer;
begin
     if FParams.Count > 0 then
     begin
          if ((idx >= 0) and (idx < FParams.count)) then
          begin
               //on élimine les délimiteurs de chaine
               //si ils existent
               //et si on est en présence d'un paramètre de type string
               if FStringDelimitor <> '' then
                    if FParams.items[idx].DataType = ftString then
                    begin
                         p := length(FStringDelimitor);
                         if length(s) >= 2 * p then
                         begin
                              if ((copy(s, 1, p) = FStringDelimitor) and (copy(s, length(s) - p + 1, p) = FStringDelimitor)) then
                              begin
                                   delete(s, length(s) - p + 1, p);
                                   delete(s, 1, p);
                              end;
                         end;
                    end;

               try
                    FParams.items[idx].value := s;
               except
                    FNoProblem := _PB3;
               end;

          end
          else
               FNoProblem := _PB2;
     end
     else
          FNoProblem := _PB2;
end;


function TCut.GetTotalParamInLine: integer;
var
     tot, idx, p: integer;
     s: string;
begin
     s := FLine;

     if s <> '' then
     begin
          tot := 0;
          idx := 1;
          repeat
               p := pos(FParamSeparator, copy(s, idx, length(s) - idx + 1));
               tot := tot + 1;
               idx := idx + p;

          until p = 0;

          result := tot;
     end
     else
          result := 0;
end;


procedure TCut.SetParamCountAsInLine;
begin
     SetTotalStringParams(GetTotalParamInLine);
end;



end.
