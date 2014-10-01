{-----------------------------------------------------------------------

  Advanced Status Bar

  Version 1.0, June 21, 1997
   - initial release
   - Advanced Status Bar accepts other controls

-----------------------------------------------------------------------}

unit AdvStatusBar;

interface

uses ComCtrls, Classes, Controls;

{$IFDEF FPC}
{$Mode Delphi}
{$ELSE}
{$ObjExportAll On}
{$R AdvStatusBar.res}
{$ENDIF}

type

  TAdvStatusBar = class(TStatusBar)
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure Register;

{---------------------------------------------------------------------------}
implementation

{$IFDEF FPC}
uses LCLType;
{$ELSE}
uses Consts;
{$ENDIF}


constructor TAdvStatusBar.Create( AOwner : TComponent );
begin
   inherited Create(AOwner);
   ControlStyle := ControlStyle + [csAcceptsControls];
end;

{---------------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents('Perso', [TAdvStatusBar]);
end;

{---------------------------------------------------------------------------}

end.