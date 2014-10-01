unit u_registercomponents;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils; 

procedure Register;

implementation

uses lresources, u_ancestroarc,u_ancestrotree,
     u_ancestroviewer,u_ancestrolink,u_buttons_flat,
     u_genealogy_context,u_extdateedit;

procedure Register;
Begin
  RegisterComponents('Ancestro',[TContextIni,TCSpeedButton,
                                 TExtDateEdit,
                                 TExtDBDateEdit,
                                 TGraphArcData,TGraphArc,
                                 TGraphLinkData,TGraphLink,
                                 TGraphTreeData,TGraphTree,
                                 TGraphViewer]);
end;

initialization

{$IFDEF FPC}
  {$i *.lrs}
{$ENDIF}
end.
