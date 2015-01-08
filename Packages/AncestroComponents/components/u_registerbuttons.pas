unit u_registerbuttons;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}
{$I ..\extends.inc}

interface

uses
  Classes, SysUtils;

procedure Register;

implementation

uses
  {$IFDEF FPC}
  lresources,
  {$ENDIF}
  u_ancestropictbuttons,u_ancestropictimages;

procedure Register;
begin
  RegisterComponents('Ancestro Buttons',
  [TIATitle,TXAAncestromania, TXAEMail,
   TXAFavorite,TXAHistory,TXAHuman,
   TIAHuman, TXAInfo, TIAInfo,TIAMouse,
   TXANeighbor, TXAPriorPage,TXAPrior,TXANext,TXANextPage,
   TXAPeople,TXAPostCard, TXAQuestion,
   TIAQuestion,TIASearch,
   TXAWeb, TXAWho, TIAGender,TXAWorld,TIAWorld]);
End ;


{$IFNDEF MEMBUTTONS}
{$IFDEF FPC}
initialization
  {$I u_ancestropictimages.lrs}
  {$I u_ancestropictbuttons.lrs}
  {$ENDIF}
{$ENDIF}
end.

