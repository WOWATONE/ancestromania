unit u_comp_TBlueFlatSpeedButton;

interface


{$IFDEF FPC}
{$Mode delphi}
{$ENDIF}

uses
     {$IFDEF FPC}
     LCLType,
     {$ELSE}
     Windows,
     {$ENDIF}
     u_buttons_defs, Graphics,
     Classes, Controls;

type

     { TBlueFlatSpeedButton }

     TBlueFlatSpeedButton = class(TFWXPButton)
     public
       constructor Create(AOwner: TComponent); override;
     published
       property Color default clWindow;
       property ColorFrameFocus default $00BFA082;
     end;

procedure Register;


implementation
procedure Register;
begin
  RegisterComponents('Ancestro', [TBlueFlatSpeedButton]);
end;


constructor TBlueFlatSpeedButton.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Font.Color := clWindowText;
     ColorFrameFocus := $00BFA082;
     Color := clWindow;
end;


end.

