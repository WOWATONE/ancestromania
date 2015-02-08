unit CompSuperForm;

interface

{$IFDEF FPC}
{$Mode Delphi}
{$ENDIF}

uses
  Classes,
  Controls,
{$IFNDEF FPC}
  Windows,
{$ENDIF}
  extctrls,
  buttons,
  Forms;


type
  TFormMode = (sfmEdit, sfmConsult, sfmNew, sfmUnknown);

  TIncrustMode = (aicCenter, aicTopLeft, aicAllClient, aicAllHeight, aicCenterTop, aicAllWidth);

  TNotifyReceiveMessageEvent = procedure(sender: TObject; theMessage: string) of object;

  { TSuperBox }

  TSuperBox = class(TScrollBox)
  public
    procedure Resize ; override;
  End;

  { TSuperPanel }

  TSuperPanel = class(TPanel)
  public
    procedure Resize ; override;
  End;

  { TSuperForm }

  TSuperForm = class(TForm)

  private
    fFormMode: TFormMode;
    FDefaultCloseAction: TCloseAction;
    fOnFillFields: TNotifyEvent;
    fOnFillProperties: TNotifyEvent;
    fOnRefreshControls: TNotifyEvent;
    fAutoFillFieldsWhenShow: boolean;
    fIncrustMode: TIncrustMode;
    fAdaptParentSize: boolean;
    fOnReceiveMessage: TNotifyReceiveMessageEvent;
    fPanelParent: TWinControl;
    fFixedClientHeight: integer;
    fFixedClientWidth: integer;
    //		fCloseAction: TCloseAction;
    fOnFirstActivate: TNotifyEvent;
    fAlreadyPassedInFirstActivate: boolean;
    fAlreadyPassedInFirstShow: boolean;
    fOnShowFirstTime: TNotifyEvent;
    fOnPrepare: TNotifyEvent;
    fDescription: string;
{$IFNDEF FPC}
    fShowBevel: boolean;

    procedure SetShowBevel(value: boolean);
{$ENDIF}
    procedure Incrust(ParentControl: TWinControl);
    procedure SetcsDisplayDragImage;

  protected
    procedure DoSetBounds(ALeft, ATop, AWidth, AHeight: integer); override;
    procedure CallEventFirstActivate; dynamic;
    procedure CallEventReceiveMessage(theMessage: string); dynamic;
    procedure CallEventShowFirstTime; dynamic;
    procedure DoShow; override;
    procedure Resize ; override;
    procedure DoClose(var CloseAction: TCloseAction); override;

{$IFNDEF FPC}
    procedure Paint; override;
{$ENDIF}
    procedure Activate; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure InitSuperForm; virtual;
    procedure DoFillFields;virtual;
    procedure DoFillProperties;virtual;
    procedure ShowIncrust(ParentControl: TWinControl);virtual;
    //		function  ShowIncrustModal(ParentControl: TPanel): integer;virtual;
    procedure HideIncrust;virtual;
    procedure AlignFormInParent(sender: TObject);virtual;
    procedure DoRefreshControls;virtual;
    procedure DoSendMessage(theComponent: TObject; theMessage: string); virtual;
    function ShowModal: Integer; override;
    procedure DoPrepare;
    property FormActivated: boolean read fAlreadyPassedInFirstActivate;

  published
    property FormMode: TFormMode read fFormMode write fFormMode default sfmUnknown;
    property OnFirstActivate: TNotifyEvent read fOnFirstActivate write fOnFirstActivate;
    property OnFillFields: TNotifyEvent read fOnFillFields write fOnFillFields;
    property OnFillProperties: TNotifyEvent read fOnFillProperties write fOnFillProperties;
    property OnRefreshControls: TNotifyEvent read fOnRefreshControls write fOnRefreshControls;
    property AutoFillFieldsWhenShow: boolean read fAutoFillFieldsWhenShow write fAutoFillFieldsWhenShow;
    property IncrustMode: TIncrustMode read fIncrustMode write fIncrustMode default aicAllClient;
    property AdaptParentSize: boolean read fAdaptParentSize write fAdaptParentSize;
    property OnReceiveMessage: TNotifyReceiveMessageEvent read fOnReceiveMessage write fOnReceiveMessage;
    property PanelParent: TWinControl read fPanelParent;
{$IFNDEF FPC}
    property ShowBevel: boolean read fShowBevel write SetShowBevel;
{$ENDIF}
    property OnShowFirstTime: TNotifyEvent read fOnShowFirstTime write fOnShowFirstTime;
    property OnPrepare: TNotifyEvent read fOnPrepare write fOnPrepare;
    property Description: string read fDescription write fDescription;
    property DefaultCloseAction: TCloseAction read FDefaultCloseAction write FDefaultCloseAction default caFree;


  end;


implementation

constructor TSuperForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitSuperForm;
  FDefaultCloseAction:=caFree;
  fIncrustMode:=aicAllClient;
  fFormMode:=sfmUnknown;
end;

procedure TSuperForm.InitSuperForm;
begin
  fFormMode := sfmEdit;
  fAdaptParentSize := true;
  fPanelParent := nil;
  fFixedClientHeight := ClientHeight;
  fFixedClientWidth := ClientWidth;
  fAlreadyPassedInFirstActivate := false;
  fAlreadyPassedInFirstShow := false;
end;


procedure TSuperForm.DoFillFields;
begin
  if assigned(fOnFillFields) then fOnFillFields(self);
end;


procedure TSuperForm.DoFillProperties;
begin
  if assigned(fOnFillProperties) then fOnFillProperties(self);
end;

procedure TSuperForm.CallEventReceiveMessage(theMessage: string);
begin
  if assigned(fOnReceiveMessage) then fOnReceiveMessage(self, theMessage);
end;


procedure TSuperForm.DoRefreshControls;
begin
   if assigned(fOnRefreshControls) then fOnRefreshControls(self);
end;




procedure TSuperForm.DoShow;
begin
  SetcsDisplayDragImage;

  if (not fAlreadyPassedInFirstShow) then
    begin
      CallEventShowFirstTime; ;
      fAlreadyPassedInFirstShow := true;
    end;

  inherited;

  if fAutoFillFieldsWhenShow then DoFillFields;
end;

procedure TSuperForm.Resize;
begin
  if not Assigned ( fPanelParent ) Then
    inherited Resize;
end;

procedure TSuperForm.DoClose(var CloseAction: TCloseAction);
begin
  CloseAction:=FDefaultCloseAction;
  inherited DoClose(CloseAction);
  fAlreadyPassedInFirstActivate := False;
end;


procedure TSuperForm.Incrust(ParentControl: TWinControl);
begin
  case fIncrustMode of
    aicAllClient : Align := alClient;
    aicAllHeight : Align := alLeft;
    aicAllWidth : Align := alTop;
     aicCenter :
       Begin
        Align:=alNone;
        Top := (ParentControl.ClientHeight - Height) div 2;
        if Top  < 0 then Top  := 0;
       end;

  end;
  if fIncrustMode in [ aicCenter, aicCenterTop] Then
   Begin
    Align:=alNone;
    Left := (ParentControl.ClientWidth-Width) div 2;
    if Left < 0 then Left := 0;
   end;

  BorderStyle := bsNone;


  parent := ParentControl;
  fPanelParent := ParentControl;


  ClientHeight := fFixedClientHeight;
  ClientWidth := fFixedClientWidth;

end;

procedure TSuperForm.ShowIncrust(ParentControl: TWinControl);
begin
  Updating;
  Incrust(ParentControl);
  Updated;
  Show;
end;

{
function  TSuperForm.ShowIncrustModal(ParentControl: TPanel): integer;
begin
 Incrust(ParentControl);
//	fCloseAction:=caFree;
 Show;
end;
}

procedure TSuperForm.HideIncrust;
begin
  Hide;
end;

procedure TSuperForm.AlignFormInParent(sender: TObject);
var Rect : TRect ;
  procedure p_SetToZero;
  Begin
    if Rect.Left < 0 Then Rect.Left := 0;
    if Rect.Top  < 0 Then Rect.Top  := 0;
  end;

begin
  if not assigned ( fPanelParent )
   Then
     Exit;
  case fIncrustMode of
    aicCenter:
      begin
        Rect.Right := Width ;
        Rect.Bottom := Height ;
        Rect.Left := (fPanelParent.ClientWidth - ClientWidth) div 2;
        Rect.Top :=  (fPanelParent.ClientHeight - ClientHeight) div 2;
        p_SetToZero;
        SetBounds(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
      end;

    aicCenterTop:
      begin
        Rect.Right := Width ;
        Rect.Bottom := Height ;
        Rect.Top :=  (fPanelParent.ClientHeight - ClientHeight) div 2;
        p_SetToZero;
        SetBounds(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
      end;

  end;
end;


procedure TSuperForm.DoSendMessage(theComponent: TObject; theMessage: string);
begin
  if (theComponent is TSuperForm) then
    begin
      (theComponent as TSuperForm).CallEventReceiveMessage(theMessage);
    end;
end;


{$IFNDEF FPC}
procedure TSuperForm.SetShowBevel(value: boolean);
begin
  fShowBevel := value;
  repaint;
end;
{$ENDIF}

{$IFNDEF FPC}
procedure TSuperForm.Paint;
begin
  inherited paint;
  if fShowBevel then DrawButtonFace(Canvas, ClientRect, 1, bsNew, True, False, False);
end;
{$ENDIF}


procedure TSuperForm.Activate;
begin
  inherited Activate;

  if (not fAlreadyPassedInFirstActivate) then
    begin
      CallEventFirstActivate;
      fAlreadyPassedInFirstActivate := true;
    end;
end;

procedure TSuperForm.CallEventFirstActivate;
begin
  if assigned(fOnFirstActivate) then fOnFirstActivate(self);
end;

procedure TSuperForm.CallEventShowFirstTime;
begin
  if assigned(fOnShowFirstTime) then fOnShowFirstTime(self);
end;

function TSuperForm.ShowModal: Integer;
begin
  if (not fAlreadyPassedInFirstShow) then
    begin
      CallEventShowFirstTime; ;
      fAlreadyPassedInFirstShow := true;
    end;

  if fAutoFillFieldsWhenShow then DoFillFields;

  result := inherited ShowModal;
end;

procedure TSuperForm.DoPrepare;
begin
  if assigned(fOnPrepare) then fOnPrepare(self);
end;


procedure TSuperForm.SetcsDisplayDragImage;
var
  n: integer;
begin
  ControlStyle := ControlStyle + [csDisplayDragImage];
  for n := 0 to ComponentCount - 1 do
    if (Components[n] is TControl)
      then TControl(Components[n]).ControlStyle := TControl(Components[n]).ControlStyle + [csDisplayDragImage];
end;

procedure TSuperForm.DoSetBounds(ALeft, ATop, AWidth, AHeight: integer);
begin
  if ( AWidth  < Width  ) Then HorzScrollBar.Position:=0;
  if ( AHeight < Height ) Then VertScrollBar.Position:=0;
  inherited DoSetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure AlignSuperForm ( const Control : TWinControl );
var li_i : Integer;
Begin
  with Control do
    Begin
      for li_i := 0 to ControlCount - 1 do
        if Controls [ li_i ] is TSuperForm Then
          ( Controls [ li_i ] as TSuperForm ).AlignFormInParent( Controls [ li_i ]);
    end;

end;

{ TSuperBox }

procedure TSuperBox.Resize;
begin
  inherited Resize;
  AlignSuperForm ( Self );
end;

{ TSuperPanel }

procedure TSuperPanel.Resize;
begin
  inherited Resize;
  AlignSuperForm ( Self );
end;

end.


