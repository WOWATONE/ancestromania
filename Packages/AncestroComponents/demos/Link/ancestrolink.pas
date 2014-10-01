program ancestrolink;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, u_formlink, lazancestrocomponents
  { you can add units after this };

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormLink, FormLink);
  Application.Run;
end.

