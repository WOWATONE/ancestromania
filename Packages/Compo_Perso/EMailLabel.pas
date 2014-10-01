unit EMailLabel;

// Peric 16.01.2001

interface

{$IFDEF FPC}
{$Mode Delphi}
{$ELSE}
{$R EMailLabel.res}
{$ENDIF}

uses
     {$IFDEF FPC}
     LCLType, lmessages, Process,
     {$ELSE}
     Windows,Shellapi,
     {$ENDIF}
     Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls,EXtCtrls;

type
  TOnMouseOverEvent = procedure(Sender: TObject) of object;
  TOnMouseOutEvent = procedure(Sender: TObject) of object;
  TEMailLabel = class(TCustomLabel)
  private
    FEMailAddress:string;
    //FFontname:TFontName;
    FCop: string;
    FUnderline:Boolean;
    FMouseInPos : Boolean;
    //FFontSize:integer;
    FFColorIn: TColor;
    FFColorOut: TColor;
    FFColorAfter: TColor;
    FOnMouseOver: TOnMouseOverEvent;
    FOnMouseOut: TOnMouseOutEvent;
    procedure CMMouseEnter(var AMsg: {$IFDEF FPC}TLMessage{$ELSE}TMessage{$ENDIF}); message {$IFDEF FPC}LM_MouseEnter{$ELSE}CM_MouseEnter{$ENDIF};
    procedure CMMouseLeave(var AMsg: {$IFDEF FPC}TLMessage{$ELSE}TMessage{$ENDIF}); message {$IFDEF FPC}LM_MouseLeave{$ELSE}CM_MouseLeave{$ENDIF};
    procedure SetFontColorin(Value: TColor);
    procedure SetFontColorOut(Value: TColor);
    procedure SetFontColorAfter(Value: TColor);
    //procedure SetFontname(Value: TFontname);
    function GetCop: string;
    procedure SetCop(const Value: string);
    procedure SetEMailAddress(AEMailAddress: string);
    { Private declarations }
  protected
    {$IFDEF FPC}
    FProcess:TProcess;
    {$ENDIF}
    //procedure SetFontSize(AFontsize:integer);
    procedure setUnderline(aUnderline:boolean);
    procedure click;override;

      { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
      { Public declarations }
  published
    //property Fontsize:integer
    //read  FFontsize write SetFontsize default 8;
    property Copyright: string read GetCop write SetCop;
    property EMailAddress: string read FEMailAddress write SetEMailAddress;
    //property Fontname: TFontname read FFontname write SetFontname;
    property FontColorAfter: TColor read FFColorAfter write SetFontColorAfter;
    property FontColorin: TColor read FFColorin write SetFontColorin;
    property FontColorOut: TColor read FFColorOut write SetFontColorOut;
    property OnMouseOver: TOnMouseOverEvent read FOnMouseOver write FOnMouseOver;
    property OnMouseOut: TOnMouseOutEvent read FOnMouseOut write FOnMouseOut;
    property Underline: boolean
    read FUnderline write setUnderline default true;
      { Published declarations }
    property Parentfont;
    property Font;
    property Alignment;
    property AutoSize;
    property Color;
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property Transparent;
    property Layout;
    property Visible;

  end;

procedure Register;

implementation

constructor TEMailLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProcess := TProcess.Create(Self);
  //Parentfont:=false;
  //FFontsize:=8;
  //Font.size:=FFontsize;
  FFColorIn:=clBlue;
  FFColorOut:=clBlack;
  FFColorAfter:=clmaroon;
  FCop:='Copyright © 2001 by Peric';
  Cursor:=crHandPoint;
  FEMailAddress:='PericDDN@PTT.yu';
  Caption:=FEMailAddress;
  FUnderline:=true;
  //FFontName:=Font.name;
end;

{procedure TEMailLabel.SetFontName(Value: TFontname);
begin
  FFontname:=Value;
  font.name:=value;
end;       }

procedure TEMailLabel.click;

var
  AnUrl: array[0..255] of char;
begin
  StrPCopy(AnUrl, 'mailto:'+caption);
  {$IFDEF FPC}
  FProcess.CommandLine:=Anurl;
  FProcess.Execute;
  {$ELSe}
  ShellExecute(Application.Handle, 'open', AnUrl, nil, nil, SW_NORMAL);
  {$ENDIF}
  FFColorOut:=FFColorAfter;
end;


{procedure TEMailLabel.SetFontsize(AFontsize:integer);

begin
 FFontsize:=AFontsize;
 Font.size:=AFontsize;
end;    }

procedure TEMailLabel.CMMouseEnter(var AMsg: {$IFDEF FPC}TLMessage{$ELSE}TMessage{$ENDIF});
begin
  if Assigned(FOnMouseOver) then FOnMouseOver(Self);
  FMouseInPos := True;
  if enabled=false then exit;
  Font.Color := FFColorIn;
  if FUnderline =true then Font.Style := [fsUnderline] else  Font.Style := [];
end;

procedure TEMailLabel.CMMouseLeave(var AMsg: {$IFDEF FPC}TLMessage{$ELSE}TMessage{$ENDIF});
begin
  if Assigned(FOnMouseOut) then FOnMouseOut(Self);
  FMouseInPos := False;
  Font.Color := FFColorOut;
  Font.Style := [];
end;

procedure TEMailLabel.SetEMailAddress(AEMailAddress: string);
begin
  FEMailAddress:=AEMailAddress;
  Caption:=AEMailAddress;
end;

procedure TEMailLabel.SetCop(const Value: string);
begin
  FCop:=FCop;
end;

procedure TEMailLabel.setUnderline(AUnderline:boolean);
begin
 FUnderline:= AUnderline;
end;

procedure TEMailLabel.SetFontColorin(Value: TColor);
begin
  FFColorin:=Value;
end;

procedure TEMailLabel.SetFontColorAfter(Value: TColor);
begin
  FFColorAfter:=Value;
end;

procedure TEMailLabel.SetFontColorOut(Value: TColor);
begin
  FFColorOut:=Value;
  Font.color:=value;
end;

function TEMailLabel.GetCop: string;
begin
  Result:=FCop;
end;
procedure Register;
begin
  RegisterComponents('Perso', [TEMailLabel]);
end;

end.