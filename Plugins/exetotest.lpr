program exetotest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, u_dm_plugin, DefObjet, u_form_main, lazancestrobuttons;

{$IFDEF WIN32}
{$R *.res}
{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TF_PluginAncestro,F_PluginAncestro);
  Application.Run;
  //SetHeapTraceOutput (ExtractFilePath (Application.ExeName) + 'heaptrclog.trc');
End.

