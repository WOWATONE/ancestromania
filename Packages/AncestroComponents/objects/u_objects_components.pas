{-----------------------------------------------------------------------}
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Andr? Langlet (Main), Matthieu Giroux (LAZARUS),            }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{-----------------------------------------------------------------------}
{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }
{-----------------------------------------------------------------------}
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{-----------------------------------------------------------------------}

unit u_objects_components;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, contnrs, Graphics, ExtCtrls, u_common_graph_type,
{$IFDEF FPC}
  LCLType, FPCanvas,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils;


type
  TPaintText = procedure(const AObject: TObject;
    const AString: string; const ALeft, ATop :Double;
    const AAngle : Integer = 0) of object;
  TPaintTextRect = procedure(const AObject: TObject;
    const ARect : TFloatRect;
    const AString: string; const ALeft, ATop :Double;
    const AAngle : Integer ) of object;
  TPaintPenSet = procedure(const AObject: TObject; const AColor:TColor;
    const PenStyle : {$IFDEF FPC}TFPPenStyle{$ENDIF};
    const PenWidth : Single ; const PenMode : {$IFDEF FPC}TFPPenMode{$ENDIF}) of object;
  TPaintBrushSet = procedure(const AObject: TObject;
    const AColor:TColor;const BrushStyle : {$IFDEF FPC}TFPBrushStyle{$ENDIF}) of object;
  TPaintColor = procedure(const AObject: TObject; const AColor : TColor ) of object;
//  TPaintFont  = procedure(const AObject: TObject; const FontName : String ; const FontSize : Integer ; const AColor : TColor ) of object;
  TPaintFont  = procedure(const AObject: TObject; const AFont : TFont ; const AFontSize : Single ) of object;
  TPaintCoord = procedure(const AObject: TObject; const AX, AY : Extended ) of object;
  TPaintRect = procedure(const AObject: TObject; const AX1, AY1, AX2, AY2 : Extended ) of object;
  TPaintRoundRect = procedure(const AObject: TObject; const AX1, AY1, AX2, AY2, W, H : Extended ) of object;
  TPaintArc = procedure(const AObject: TObject;
    const ARect : TFloatRect ; const ABeginArcXC, ABeginArcYC, AEndArcXC, AEndArcYC : Extended ) of object;
  TPerson = class
   private
    fLevel: integer;
    fCleFiche: integer;
    fChilds: TObjectList;
    fCleMere: integer;
    fClePere: integer;

    fSexe: integer;

   protected

    fOrderTete: integer;
   public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear; virtual;
   published
    property KeyPerson: integer read fCleFiche write fCleFiche;
    property KeyFather: integer read fClePere write fClePere;
    property KeyMother: integer read fCleMere write fCleMere;
    property Sexe: integer read fSexe write fSexe;
    property Childs: TObjectList read fChilds write fChilds;

    property Level: integer read fLevel write fLevel;
   end;

procedure AbortMessage ( const AText : String );

implementation

uses
  Controls,
  u_common_functions, Dialogs;

procedure AbortMessage ( const AText : String );
Begin
  ShowMessage(AText);
  Abort;
end;



{ TPerson }

procedure TPerson.Clear;
begin
  fSexe := -1;
  fCleFiche := -1;
  fLevel := 0;

  fCleMere := -1;
  fClePere := -1;

  fChilds.Clear;
end;

constructor TPerson.Create;
begin
  fChilds := TObjectList.Create(True);
  Clear;
end;

destructor TPerson.Destroy;
begin
  fChilds.Free;

  inherited Destroy;
end;

end.

