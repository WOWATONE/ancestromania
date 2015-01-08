unit u_comp_TScanner;

interface

uses
     Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     u_common_TWAIN, extctrls, graphicEx;

type
     TScanner = class(TComponent)
     private
          fTempPathName: string;
          hdib, testdib: hbitmap;
          w, h: integer;
          n: Integer;
          fImage: TImage;
          fResultImageFileName: string;

     public
          property ResultImageFileName: string read fResultImageFileName write fResultImageFileName;

          constructor Create(AOwner: TComponent); override;
          function Execute: boolean;

     published
          property TempPathName: string read fTempPathName write fTempPathName;

     end;

procedure Register;
procedure CallbackFxn(CurDib: THandle; index: Integer); stdcall; forward;

implementation

uses
     ComObj;

procedure Register;
begin
     RegisterComponents('EvaluatePak', [TScanner]);
end;

{ TScanner }

constructor TScanner.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     hDib := 0;
     w := 0; h := 0;
     testDib := 0;

     fImage := nil;

     TWAIN_RegisterCallback(CallbackFxn);
end;

function TScanner.Execute: boolean;
var
     tempImageFileName: string;
     tempImage: TImage;
begin
     result := false;


     if TWAIN_SelectImageSource(0) <> 0 then
     begin
          tempImageFileName := CreateClassID + '.bmp';
          tempImage := TImage.create(self);
          try
               //showMessage(inttostr(k));
               hdib := TWAIN_AcquireNative(0, 0);
               n := TWAIN_GetNumDibs;
               if n >= 1 then
               begin
                    TestDib := TWAIN_GetDib(0);
                    CopyDibIntoImage(TestDib, tempImage);
                    TWAIN_FreeNative(TestDib);
                    TestDib := 0;

                    //Sauvegarde de l'image
                    try
                         tempImage.Picture.SaveToFile(fTempPathName + tempImageFileName);
                         result := true;
                         fResultImageFileName := fTempPathName + tempImageFileName;
                    except
                    end;
               end;
          finally
               tempImage.free;
          end;
     end;
end;


procedure CallbackFxn(CurDib: THandle; index: Integer); stdcall;
begin
     //   MessageBox(0, 'Called back!', 'CallbackFxn', mb_ok);
end;


end.

