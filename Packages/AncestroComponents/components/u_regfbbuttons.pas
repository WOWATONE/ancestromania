unit u_regfbbuttons;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface

uses
{$IFDEF FPC}
  lresources,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils, Classes;

procedure Register;

implementation

uses u_buttons_flat;

procedure Register;
begin
  RegisterComponents('FBButtons', [TFBClose,TFBNext,TFBPrior,TFBLoad,TFBTrash,TFBConfig,
                                   {$IFDEF GROUPVIEW} TFBBasket,TFBInSelect,TFBInAll,TFBOutSelect,TFBOutAll,{$ENDIF}
                                   TFBOK,TFBInsert,TFBInit,TFBDelete,TFBDocument,TFBCancel,TFBQuit,TFBErase,TFBSaveAs,TFBAdd,TFBImport,TFBExport,TFBPrint,TFBPreview,TFBCopy]);
End ;



{$IFDEF FPC}
initialization
  {$I u_regfbbuttons.lrs}
{$ENDIF}

end.

