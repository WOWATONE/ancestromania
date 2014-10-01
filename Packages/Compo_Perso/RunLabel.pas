unit RunLabel;

//28.01.2001 by Peric

interface

uses
  {$IFDEF FPC}
  LCLType,
  {$ELSE}
  Windows,
  {$ENDIF} Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,EXtCtrls;

{$IFNDEF FPC}
{$R RunLabel.res}
{$ENDIF}

type
  TRunLabel = class(TCustomLabel)
   private


    FRunenabled:boolean;
    FRunspeed:integer;
    Timer:TTimer;
    FCop,FCaptionRun,FCaptionRRun: string;
    function GetCop: string;
    procedure SetCop(const Value: string);
    procedure SetCaptionRun(ACaptionRun: string);
    procedure Run;
    
  protected


    procedure SetRunenabled(ARunenabled:boolean);
    procedure SetRunspeed(ARunspeed:integer);
    procedure OnTimer(Sedner:Tobject);virtual;

  public


    constructor Create(Aowner:Tcomponent);override;

  published


    property RunEnabled:boolean
    read Frunenabled write Setrunenabled default True;
    property RunSpeed:integer
    read  FRunspeed write SetRunspeed default 20;
    property Copyright: string read GetCop write SetCop;
    property CaptionRun: string read FCaptionRun write SetCaptionRun ;
    property Align;
    property Alignment;
    property AutoSize;
    property Color;
    property Enabled;
    property DragCursor;
    property DragMode;
    property FocusControl;
    property Font;
    property ParentColor;
    property ParentShowHint;
    property ParentFont;
    property Transparent;
    property Layout;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;


  end;

procedure Register;

implementation
 var x:integer;

procedure Register;
begin
  RegisterComponents('Perso', [TRunLabel]);
end;


constructor TRunLabel.Create(AOwner:TComponent);

begin
inherited;
Frunenabled:=True;
FRunspeed:=20;
Timer:=TTimer.Create(Self);
Timer.Interval:= FRunspeed;
Timer.OnTimer:=OnTimer;
FCop:='Copyright © 2001 by Peric';
FCaptionRun:='RunLabel';
Caption:= FCaptionRun;
 end;

 function TRunLabel.GetCop: string;
begin
  Result:=FCop;
end;

procedure TRunLabel.SetCop(const Value: string);
begin
  FCop:=FCop;
end;


procedure TRunLabel.SetCaptionRun(ACaptionRun: string);
begin
  FCaptionRun:=ACaptionRun;
  Caption:=FcaptionRun;
 FCaptionRRun:='                        '+FCaptionRun;

end;
                          

 procedure TRunLabel.Setrunenabled(Arunenabled:boolean);

 begin
 Frunenabled:=Arunenabled;
 if csDesigning in ComponentState then
 Exit;
 Timer.Enabled:=Frunenabled;

 end;

 procedure TRunLabel.SetRunspeed(ARunspeed:integer);

 begin
 FRunspeed:=ARunspeed;
 Timer.interval:=ARunspeed;
 end;

 procedure TRunLabel.OnTimer(Sedner:Tobject);

 begin
 if csDesigning in ComponentState then begin
 Timer.Enabled:=False;
 Exit;
 end;
 Run;
 end;

 procedure TRunLabel.Run;
begin
X:=X+1;
Caption := Copy(FCaptionRRun,X, 30);
if x >= Length(FCaptionRRun) then
x := 0;
end;


end.