unit IdentFB;

interface

uses SysUtils,Classes,Controls,
  Forms,StdCtrls,ExtCtrls;

type
  TFBLoginDlg=class(TForm)
    Panel:TPanel;
    Bevel:TBevel;
    DatabaseName:TLabel;
    OKButton:TButton;
    CancelButton:TButton;
    Panel1:TPanel;
    LabelUtilisateur: TLabel;
    LabelMdp: TLabel;
    LabelBase: TLabel;
    LabelRole: TLabel;
    Password:TEdit;
    UserName:TEdit;
    RoleName:TEdit;
  end;

function LoginDialogFB(const ADatabaseName:string;
  var AUserName,APassword,ARoleName:string;Proprio:TForm=nil):Boolean;

implementation

uses
  {$IFNDEF FPC}
   Windows,
  {$ELSE}
    LCLIntf, LCLType,
  {$ENDIF}
  u_common_functions,
  Types;
{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

function LoginDialogFB(const ADatabaseName:string;
  var AUserName,APassword,ARoleName:string;Proprio:TForm=nil):Boolean;
var
  RectMonitor:TRect;
  Marge:Integer;
  TopLeft:TPoint;
begin
  with TFBLoginDlg.Create(Application) do
  try
    DatabaseName.Caption:=ADatabaseName;
    UserName.Text:=UpperCase(AUserName);
    Password.Text:=APassword;
    RoleName.Text:=UpperCase(ARoleName);
    Result:=False;
    if AUserName='' then
      ActiveControl:=UserName;
    Marge:=Panel.ClientWidth-(DatabaseName.Left+DatabaseName.Width+2);
    if Marge<0 then
      Width:=Width-Marge;
    if Proprio=nil then
      if Screen.ActiveForm<>nil then
        Proprio:=Screen.ActiveForm
      else if Assigned(Application.MainForm) then
        Proprio:=Application.MainForm;
    if Proprio<>nil then
    begin//centrage sur la fiche propriétaire
      Position:=poDesigned;
      TopLeft:=Proprio.ClientToScreen(Point(0,0));
      Left:=TopLeft.X+(Proprio.Width-Width)div 2;
      Top:=TopLeft.Y+(Proprio.Height-Height)div 2;
      RectMonitor:=Monitor.WorkareaRect;

      if (Top+Height)>RectMonitor.Bottom then
        Top:=RectMonitor.Bottom-Height;
      if Top<RectMonitor.Top then
        Top:=RectMonitor.Top;

      if (Left+Width)>RectMonitor.Right then
        Left:=RectMonitor.Right-Width;
      if Left<RectMonitor.Left then
        Left:=RectMonitor.Left;
    end;
    if ShowModal=mrOk then
    begin
      AUserName:=trim(UserName.Text);
      APassword:=trim(Password.Text);
      ARoleName:=trim(RoleName.Text);
      Result:=True;
    end;
  finally
    Free;
  end;
end;

end.
