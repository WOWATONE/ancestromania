unit MaxInstance;

// TMaxInstance Component
//
// Copyright © 2001 Small Software Systems LLC
// Author:  Michael Kelly
//
// Version:  1.1
//
// Purpose:  Allows the Delphi programmer to set a limit on the
//           number of open instances of a Win32 application.
//
// Compatibility:  Should work on any 32 bit version of Delphi
//                 since it relies on Win32API calls.
//                 Should also work with C++ Builder but not tested.
//
// Uses:  Win32API Semaphore calls.
//
//  Freeware:  No warranties express or implied. Use At Your Own Risk.
//
//  Platforms:  32 bit Windows9x/NT/2000.
//
//  Installation:  Unpack files to a folder in your Delphi library path.
//                 In Delphi 5 IDE Select Component=>Install Component,
//                 then select the file MaxInstance.pas. For other
//                 versions of Delphi or C++ Builder see the online
//                 help for component installation.
//
//  Usage:  Drop on the main form of your application to limit
//          the number of instances of your app that can be run
//          concurrently.  This maximum number can be set at
//          design time using the Object Inspector.  In the main
//          form OnCreate Handler call the method GetSem.
//
// Example:
//         procedure TForm1.FormCreate(Sender: TObject);
//         begin
//           MaxInstance1.GetSem;
//         end;
//
// Properties:
//
//  MaxInstances - Longint:  Max number of open App instances.
//
//  TimeOut - DWORD: milliseconds to wait for the Semaphore.
//            This number has 2 "magic cookie" values, 0,
//            meaning do not wait at all but just test if the
//            Semaphore is signalled, and -1L, meaning to wait
//            for the Semaphore forever.  Use this last with
//            caution as it can easily hang your app!  The
//            default is set to 250 or 1/4 second.
//
//  AutoKill - Boolean: If true(the default) TMaxInstance calls
//             Application.Terminate if too many apps are open.
//
//  SemName - String:  The name of the global Semaphore.  See
//            the Win32API Help for specifics but basically
//            it doesn't like a '\' directory separator char
//            in the name.  The Kernel Object namespace is all
//            one so try to use a unique name so that the first
//            instance of your App can create the Semaphore.
//            (If you drop the component on the form a GUID
//             string is created automatically to guarantee
//             the kernel object name for the semaphore will
//             be unique.  See Win32API help for more info
//             on GUIDs.)
//
// Events:
//
//  OnSemFailure - Triggered if API Semaphore calls fail outright.
//
//  OnTooMany - Triggered if the current App is over the limit
//              of allowed instances.
//
//  Note that by setting AutoKill to False and assigning handlers
//  to the events above you can do something besides quit if too
//  many App instances are open(like chide the user or something,
//  who knows? :) or if the Semaphore cannot be created.
//  For this reason I included the method FreeSem so that you can
//  free open Semaphore resources in your handlers if desired.
//
//  History
//
//  Update: June 13, 2001
//
//  Modified GetSem method by removing call to OpenSemaphore.
//  This removed the bug where killing the initial instance of
//  the app when serveral were running would then allow more than
//  the Max number of instances to run concurrently.
//
//  Update: November 6, 1999
//
//  Tried component in Delphi 5 Pro and C++ Builder 3 Pro
//  with Windows98 2nd. ed.
//
//  Deleted some dead debug code as it doesn't seem helpful.
//
//  Added a 24x24 256 color public domain "temple" bitmap
//  for the component palette.
//
//  Update: December 4, 1999  MaxInstance V. 1.008
//
//  Added code derived with permission from a similar component
//  by Jeff Overcash to automatically create a GUID string for
//  the name of the Semaphore when the component is dropped on
//  a form.  This guarantees the Semaphore name will be unique.
//  When creating the component dynamically, you can use the
//  IDE key combination cntrl-shift-g to create a GUID string
//  and assign it in the main form's OnCreate handler.
//
//
interface

// If doing size optimization you might be able to trim some of these
// but right now I'm more concerned on debugging the logic than experimenting
// to find out how many I can delete and still run the component.
uses
  {$IFDEF FPC}
     LCLType,
     {$ELSE}
     Windows,
     {$ENDIF} Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TMaxInstance = class(TComponent)
  private
    FMaxInstances: Longint;
    FAutoKill: Boolean;
    FSemName: string;
    FTimeOut: DWORD;
    FTooMany: TNotifyEvent;
    FSemFailure: TNotifyEvent;
  protected
    SemHandle: THandle;
    SemHeld: Boolean;
    ErrorCode: DWORD;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsSemHeld: Boolean;
    function GetErrorCode: DWORD;
    procedure GetSem;
    procedure FreeSem;
  published
    property MaxInstances: Longint read FMaxInstances write FMaxInstances default 1;
    property AutoKill: Boolean read FAutoKill write FAutoKill default true;
    property SemName: string read FSemName write FSemName;
    property TimeOut: DWORD read FTimeOut write FTimeOut default 250;
    property OnTooMany: TNotifyEvent read FTooMany write FTooMany;
    property OnSemFailure: TNotifyEvent read FSemFailure write FSemFailure;
  end;

procedure Register;

implementation

uses ActiveX, ComObj;

procedure Register;
begin
  RegisterComponents('Freeware', [TMaxInstance]);
end;

constructor TMaxInstance.Create(AOwner: TComponent);
var
 MyGuid: TGUID;

begin
  inherited Create(AOwner);
  FMaxInstances := 1;
  FAutoKill := true;
  FTimeOut := 250;
  if (csDesigning in ComponentState) and (FSemName = '') then
    if CoCreateGuid(MyGuid) = S_OK then
      FSemName := GuidToString(MyGuid);
end; // constructor

destructor TMaxInstance.Destroy;
begin
  if SemHeld then
    ReleaseSemaphore(SemHandle, 1, nil);
  if SemHandle <> 0 then
    CloseHandle(SemHandle);
  inherited Destroy;
end; // destructor

function TMaxInstance.IsSemHeld: Boolean;
begin
  Result := SemHeld;
end; // IsSemHeld

function TMaxInstance.GetErrorCode: DWORD;
begin
  Result := ErrorCode;
end; // GetErrorCode

// GetSem - The heart of the Component
//
procedure TMaxInstance.GetSem;
var
  WaitVal: DWORD;

begin
  SemHeld := false;
  ErrorCode := 0;
  SemHandle := CreateSemaphore(nil, MaxInstances, MaxInstances, PChar(SemName));
  if SemHandle = 0 then
  begin
    ErrorCode := GetLastError;
    if Assigned(FSemFailure) then
      OnSemFailure(Self);
    if AutoKill then
      Application.Terminate;
  end;
  WaitVal := WaitForSingleObject(SemHandle, TimeOut);
  case WaitVal of
    WAIT_OBJECT_0: SemHeld := True;
    WAIT_TIMEOUT:
      begin
        if Assigned(FTooMany) then
          OnTooMany(Self);
        if AutoKill then
          Application.Terminate;
      end;
    WAIT_FAILED:
      begin
        ErrorCode := GetLastError;
        if Assigned(FSemFailure) then
          OnSemFailure(Self);
        if AutoKill then
          Application.Terminate;
      end;
  end; // case
end; // GetSem

procedure TMaxInstance.FreeSem;
begin
  ErrorCode := 0;
  if SemHeld then
    if not ReleaseSemaphore(SemHandle, 1, nil) then
    begin
      ErrorCode := GetLastError;
      exit;
    end
    else
      SemHeld := false;

  if SemHandle <> 0 then
    if not CloseHandle(SemHandle) then
      ErrorCode := GetLastError
    else
      SemHandle := 0;
end; // FreeSem

end.
