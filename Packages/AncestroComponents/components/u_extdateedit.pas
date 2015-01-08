unit u_extdateedit;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  u_framework_components,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  {$IFDEF FPC}
  LMessages,
  {$ENDIF}
  u_buttons_appli,
  Graphics,
  Messages,
  Controls,
  DB, DbCtrls,
  u_common_const,
  u_form_calendriers, StdCtrls;

{$IFDEF VERSIONS}
const
  gVer_extdbdateedit: T_Version = (Component: 'Customized Text Date';
    FileUnit: 'u_exttextdate';
    Owner: 'Matthieu Giroux';
    Comment: 'Customized Text Date component.';
    BugsStory: '1.0.1.0 : Testing TExtDateEdit.'+#13#10 +
               '1.0.0.0 : Error Font.'+#13#10 +
               '0.9.9.0 : Testing.'+#13#10 +
               '0.9.0.0 : To test.';
    UnitType: 3;
    Major: 1; Minor: 0; Release: 1; Build: 0);
{$ENDIF}

type
   TExtDateEdit = class;
   TChangeLabelEvent = procedure ( const DateControl : TExtDateEdit ; const IsBlank : Boolean ) of object;
   { TExtDateButton }

   TExtDateButton = class ( TFWDate )
     procedure SetFocus; override;

   end;

   { TExtDBDateEdit }

   { TExtDateEdit }

   TExtDateEdit = class ( TFWEdit )
     private
       FLabelDay : TLabel;
       FOnChangeLabel : TChangeLabelEvent;
       FOnSetDate : TNotifyEvent;
       FDateButton : TExtDateButton;
       FWidthAll : Integer;
       sDateTrans:string;
       joursem:string;
       ans,mois,jours:integer;
       FFontError  ,
       FFontOrigin : TFont;
       FCalendar : TCalendrier;
     protected
       procedure p_setFontError ( const AValue : TFont );
       procedure p_DateButtonClick(Sender: TObject); virtual;
       procedure Notification(AComponent: TComponent; Operation: TOperation); override;
       function IsActive: Boolean; virtual;
       procedure SetDate(const AdateString:String); virtual;
     public
       constructor Create ( AOwner : TComponent ); override;
       procedure BoundButton; virtual;
       procedure Loaded; override;
       procedure Resize; override;
       procedure Change; override;
       property WidthAll : Integer read FWidthAll;
       property DayOfWeek : String read joursem;
       property Year : Integer read ans;
       property Month  : Integer read mois;
       property Day : Integer read jours;
       property RealDate : String read sDateTrans;
     published
       property OnSetDate : TNotifyEvent read FOnSetDate write FOnSetDate;
       property OnChangeLabel : TChangeLabelEvent read FOnChangeLabel write FOnChangeLabel;
       property LabelDay : TLabel read FLabelDay write FLabelDay;
       property FontError : TFont read FFontError write p_setFontError;
       property Calendar : TCalendrier read FCalendar write FCalendar default cGRE;
     End;

   TExtDBDateEdit = class ( TExtDateEdit )
   private
      FReadOnly : Boolean;
      FDataLink: TFieldDataLink;
      function GetDataField: string;
      function GetDataSource: TDataSource;
      function GetField: TField;
      procedure WMCut(var Message: TMessage); message {$IFDEF FPC} LM_CUT {$ELSE} WM_CUT {$ENDIF};
      procedure WMPaste(var Message: TMessage); message {$IFDEF FPC} LM_PASTE {$ELSE} WM_PASTE {$ENDIF};
      procedure CMExit(var Message: {$IFDEF FPC} TLMExit {$ELSE} TCMExit {$ENDIF}); message CM_EXIT;
      procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
   protected
      procedure SetDate(const AdateString:String); override;
      function IsActive: Boolean; override;
      procedure Change; override;
      procedure Refresh; virtual;
      procedure SetDataSource(AValue: TDataSource); virtual;
      procedure SetDataField(const AValue: string); virtual;
      procedure ActiveChange(Sender: TObject); virtual;
      procedure DataChange(Sender: TObject); virtual;
      procedure UpdateData(Sender: TObject); virtual;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      function GetReadOnly: Boolean; virtual;
      procedure SetReadOnly(AValue: Boolean); virtual;
    public
      procedure Loaded; override;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function ExecuteAction(AAction: TBasicAction): Boolean; override;
      function UpdateAction(AAction: TBasicAction): Boolean; override;
      property Field: TField read GetField;
    published
      property DataField: string read GetDataField write SetDataField stored True;
      property DataSource: TDataSource read GetDataSource write SetDataSource stored True;
      property ReadOnly: Boolean read GetReadOnly write SetReadOnly default false;
     End;

implementation

uses u_common_functions,
     Forms,
     U_OnFormInfoIni,
     fonctions_erreurs;

{ TExtDateButton }

procedure TExtDateButton.SetFocus;
begin
  if not ( csDesigning in ComponentState ) Then
    inherited SetFocus;
end;

{ TExtDateEdit }

procedure TExtDateEdit.p_setFontError(const AValue: TFont);
begin
  FFontError.Assign(AValue);
end;

procedure TExtDateEdit.p_DateButtonClick(Sender:TObject);
var
  aFCalendriers:TFCalendriers;
begin
  SetFocus;
  aFCalendriers:=TFCalendriers.create(self);
  try
    CentreLaFiche(aFCalendriers,Owner as TCustomForm);
    doTesteDateEtJour(Text,joursem,sDateTrans,ans,mois,jours,FCalendar);
    with aFCalendriers.OnFormInfoIni do
        Options:=Options-[loAutoLoad];
    aFCalendriers.doInit(ans,mois,jours,FCalendar);
    if aFCalendriers.ShowModal=mrOk then
    begin
      SetDate(aFCalendriers.laDate);
      if Assigned(FOnSetDate) then
        FOnSetDate ( Self );
    end;
  finally
    FreeAndNil(aFCalendriers);
  end;
end;

procedure TExtDateEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FLabelDay) then FLabelDay := nil;
end;



constructor TExtDateEdit.Create(AOwner: TComponent);
begin
  FDateButton:=TExtDateButton.Create(Self);
  inherited Create(AOwner);
  FDateButton.OnClick:=p_DateButtonClick;
  FDateButton.Visible := True;
  FLabelDay      := nil;
  FOnSetDate     := nil;
  FOnChangeLabel := nil;
  FFontError     :=TFont.Create;
  FFontOrigin    :=TFont.Create;
  FFontError     .Color:=clRed;
  FFontError     .Style:=[fsBold];
  FCalendar      := cGRE;
end;

procedure TExtDateEdit.Loaded;
begin
  FDateButton.Parent:=Parent;
  FFontOrigin.Assign(Font);
  inherited Loaded;
  BoundButton;
  FDateButton.Loaded;
end;

procedure TExtDateEdit.Resize;
begin
  inherited Resize;
  BoundButton;
end;

procedure TExtDateEdit.BoundButton;
begin
  FWidthAll:=Width+Height;
  FDateButton.GlyphSize:=Height-3;
  FDateButton.SetBounds( Left + Width+1, Top, Height-1, Height-1 );
end;

function TExtDateEdit.IsActive:Boolean;
Begin
  Result := not ( csDesigning in ComponentState );
end;

procedure TExtDateEdit.SetDate(const AdateString:String);
begin
  Text:=AdateString;
end;

procedure TExtDateEdit.Change;
  procedure p_event ( const ab_blank : Boolean );
  Begin
    if assigned ( FOnChangeLabel ) Then
      FOnChangeLabel ( Self, ab_blank );
  end;

begin
 Inherited;
 with FDateButton do
   Begin
    Enabled := IsActive;
   end;
  if not Enabled Then
    Exit;
  if doTesteDateEtJour(Text,joursem,sDateTrans,ans,mois,jours,FCalendar) then
    begin
      if assigned ( FLabelDay ) Then
        Begin
          if joursem>'' Then
            Begin
             joursem:='('+joursem+')';
             FLabelDay.Caption:=joursem;
             FLabelDay.Visible:=true;
            end
           Else
            FLabelDay.Visible:=False;
        end;
      Font.Assign(FFontOrigin);
      p_event ( False );
    end
    else
    begin
      if assigned ( FLabelDay ) Then
        FLabelDay.Visible:=False;
      Font.Assign(FFontError);
      p_event ( True );
    end;
 end;

{ TExtDBDateEdit }

constructor TExtDBDateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create ;
  FDataLink.DataSource := nil ;
  FDataLink.FieldName  := '' ;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
  ControlStyle := ControlStyle + [csReplicatable];
end;

destructor TExtDBDateEdit.Destroy;
begin
  inherited Destroy;
  FDataLink.Free ;
end;

procedure TExtDBDateEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then
    Begin
      DataChange(Self);
    End ;
end;

procedure TExtDBDateEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) Then Exit;
  if (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TExtDBDateEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TExtDBDateEdit.SetDataSource(AValue: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := AValue;
  if AValue <> nil then AValue.FreeNotification(Self);
end;

function TExtDBDateEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TExtDBDateEdit.SetDataField(const AValue: string);
begin
  if  assigned ( FDataLink.DataSet )
  and FDataLink.DataSet.Active Then
    Begin
      if assigned ( FDataLink.DataSet.FindField ( AValue ))
      and ( FDataLink.DataSet.FindField ( AValue ) is TNumericField ) Then
        FDataLink.FieldName := AValue;
    End
  Else
    FDataLink.FieldName := AValue;
end;

function TExtDBDateEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly or FReadOnly;
end;

procedure TExtDBDateEdit.SetReadOnly(AValue: Boolean);
begin
  FReadOnly := AValue;
end;

function TExtDBDateEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TExtDBDateEdit.Refresh;
begin
  if FDataLink.Field <> nil then
    Text := FDataLink.Field.AsString;
end;

procedure TExtDBDateEdit.ActiveChange(Sender: TObject);
begin
  Refresh;
end;

procedure TExtDBDateEdit.DataChange(Sender: TObject);
begin
  Refresh;
end;


procedure TExtDBDateEdit.UpdateData(Sender: TObject);
begin
  if Text > '' Then
    Begin
      FDataLink.Edit ;
      FDataLink.Field.Value := Text;
    End ;
end;

procedure TExtDBDateEdit.WMPaste(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TExtDBDateEdit.WMCut(var Message: TMessage);
begin
  FDataLink.Edit;
  inherited;
end;

procedure TExtDBDateEdit.CMExit(var Message: {$IFDEF FPC} TLMExit {$ELSE} TCMExit {$ENDIF});
begin
  try
    FDataLink.UpdateRecord;
  except
    on e: Exception do
      Begin
        SetFocus;
        f_GereException ( e, FDataLink.DataSet, nil , False )
      End ;
  end;
  DoExit;
end;

procedure TExtDBDateEdit.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

procedure TExtDBDateEdit.SetDate ( const AdateString:String);
begin
  if    FDataLink.Active
  and ( FDataLink.Field.AsString <> AdateString ) Then
    Begin
      FDataLink.Edit;
      FDataLink.Field.Value:=AdateString;
    end;
end;

function TExtDBDateEdit.IsActive: Boolean;
begin
  Result:=inherited IsActive and Assigned ( field );
end;

procedure TExtDBDateEdit.Change;
begin
  inherited;
  SetDate (Text);
end;

function TExtDBDateEdit.ExecuteAction(AAction: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(AAction){$IFDEF DELPHI}  or (FDataLink <> nil) and
    FDataLink.ExecuteAction(AAction){$ENDIF};
end;

function TExtDBDateEdit.UpdateAction(AAction: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(AAction) {$IFDEF DELPHI}  or (FDataLink <> nil) and
    FDataLink.UpdateAction(AAction){$ENDIF};
end;
{$IFDEF VERSIONS}
initialization
p_ConcatVersion(gVer_extdbdateedit);
{$ENDIF}
end.

