unit u_regbfsbuttons;

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

uses u_buttons_blue;

procedure Register;
begin
  RegisterComponents('BFSButtons', [TBFSClose,TBFSNext,TBFSPrior,TBFSLoad,TBFSTrash,
                                   {$IFDEF GROUPVIEW} TBFSBasket,TBFSInSelect,TBFSInAll,TBFSOutSelect,TBFSOutAll,{$ENDIF}
                                   TBFSOK,TBFSInsert,TBFSInit,TBFSDelete,TBFSDocument,TBFSCancel,TBFSQuit,TBFSErase,TBFSSaveAs,TBFSAdd,TBFSImport,TBFSExport,TBFSPrint,TBFSPreview,TBFSCopy]);
End ;



{$IFDEF FPC}
initialization
  {$I u_regbfsbuttons.lrs}
{$ENDIF}

end.

