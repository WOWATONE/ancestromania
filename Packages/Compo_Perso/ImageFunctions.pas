unit ImageFunctions;

interface



uses DB, Graphics;

implementation


uses {$IFDEF FPC}
     LCLType,
     {$ELSE}
     Windows,
     {$ENDIF}
     bgrabitmap,
     Classes, SysUtils;

end.