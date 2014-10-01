{*************************************************************}
{            URLLink Components for Delphi 16/32              }
{ Version:   1.00                                             }
{ E-Mail:    info@utilmind.com                                }
{ Home Page: http://www.utilmind.com                          }
{ Created:   July, 16, 1998                                   }
{ Modified:  July, 16, 1998                                   }
{ Legal:     Copyright (c) 1999, UtilMind Solutions           }
{*************************************************************}

unit URLLink;

interface
{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  {$IFDEF FPC}
  LCLType, LMessages,
  {$ELSE}
  {$IFDEF WIN32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF} ShellAPI,
  {$ENDIF}
  Messages, Classes, Graphics, Controls, Forms, StdCtrls, SysUtils;

type
  TURLLink = class(TLabel)
  private
    FFocusFont, FSaveFont: TFont;
 //   FLink: String;
    FOnMouseEnter, FOnMouseLeave:TNotifyEvent;
 //   OldOnClick: TNotifyEvent;

    procedure SetFocusFont(Value: TFont);
 //   procedure ClickThroughLink(Sender: TObject);
  protected
    procedure CMMouseEnter(var Msg: {$IFDEF FPC}TLMessage{$ELSE}TMessage{$ENDIF}); message {$IFDEF FPC}LM_MouseEnter{$ELSE}CM_MouseEnter{$ENDIF};
    procedure CMMouseLeave(var Msg: {$IFDEF FPC}TLMessage{$ELSE}TMessage{$ENDIF}); message {$IFDEF FPC}LM_MouseLeave{$ELSE}CM_MouseLeave{$ENDIF};
  public
    constructor Create(aOwner : TComponent); override;
    destructor Destroy; override;
  published
    property FocusFont: TFont read FFocusFont write SetFocusFont;
 //   property Link: String read FLink write FLink;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

procedure Register;

implementation

constructor TURLLink.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FFocusFont := TFont.Create;
  FSaveFont := TFont.Create;
  FSaveFont.Assign(Font);
//  OldOnClick := OnClick;
//  OnClick := ClickThroughLink;
end;

destructor TURLLink.Destroy;
begin
  FSaveFont.Free;
  FFocusFont.Free;
  inherited Destroy;
end;

procedure TURLLink.CMMouseEnter(var Msg: TMessage);
begin
  if FSaveFont <> Font then FSaveFont.Assign(Font);
  Font.Assign(FFocusFont);
  if Assigned(FOnMouseEnter) then OnMouseEnter(Self);
end;

procedure TURLLink.CMMouseLeave(var Msg: TMessage);
begin
  Font.Assign(FSaveFont);
  if Assigned(FOnMouseLeave) then OnMouseLeave(Self);
end;

procedure TURLLink.SetFocusFont(Value: TFont);
begin
  FFocusFont.Assign(Value);
end;

{
procedure TURLLink.ClickThroughLink(Sender: TObject);
var
  PC: Array[0..$FF] of Char;
begin
  StrPCopy(PC, FLink);
  if FLink <> '' then
   ShellExecute(GetDesktopWindow, 'open', PC, nil, nil, sw_ShowNormal);
  if Assigned(OldOnClick) then OnClick(Sender);
end;
 }

procedure Register;
begin
  RegisterComponents('Perso', [TURLLink]);
end;

end.