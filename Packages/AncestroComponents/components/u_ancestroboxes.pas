{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_ancestroboxes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
  LCLType, LCLIntf, FPCanvas, lresources,
{$ELSE}
 Windows,
{$ENDIF}
  Classes,contnrs,
  SysUtils,
  extctrls,
  graphics,
  Controls,
  u_ancestroviewer,
  u_objects_components,
  u_objet_graph_TPlot,
  u_common_graph_type;
const
    GRAPH_BOXES_DEFAULT_COLOR_BOX      = clWindowText;
    GRAPH_BOXES_DEFAULT_COLOR_RECT_MAN   = 8388608;
    GRAPH_BOXES_DEFAULT_COLOR_RECT_WOMAN = 128;
    GRAPH_BOXES_DEFAULT_COLOR_TEXT_MAN   = 8388608;
    GRAPH_BOXES_DEFAULT_COLOR_TEXT_WOMAN = 128;
    GRAPH_BOXES_DEFAULT_COLOR_BACK_MAN   = $00FFCC99;
    GRAPH_BOXES_DEFAULT_COLOR_BACK_WOMAN = $0099CCFF;
    GRAPH_BOXES_DEFAULT_BOX_WIDTH        = 35;
    GRAPH_BOXES_DEFAULT_BOX_HEIGHT       = 26;
    GRAPH_BOXES_DEFAULT_SPACE_GENERATION = 5;
    GRAPH_BOXES_DEFAULT_SPACE_PERSON     = 5;
    GRAPH_BOXES_DEFAULT_LINE_HEIGHT      = 5;
    GRAPH_BOXES_PRINT_FONT_SIZE = 2;
    GRAPH_INI_BOXWIDTH = 'BoxWidth';
    GRAPH_INI_BOXHEIGHT = 'BoxHeight';
    GRAPH_INI_SPACEGENERATION = 'SpaceGeneration';
    GRAPH_INI_SPACEPERSON = 'SpacePerson' ;
    GRAPH_INI_COLORBOX = 'ColorBox';
    GRAPH_INI_COLORLINK = 'ColorLink';
    GRAPH_INI_COLORRECTMAN = 'ColorRectMan';
    GRAPH_INI_COLORRECTWOMAN = 'ColorRectWoman';
    GRAPH_INI_COLORTEXTWOMAN = 'ColorTextWoman';
    GRAPH_INI_COLORTEXTMAN = 'ColorTextMan';
    GRAPH_INI_COLORBACKWOMAN = 'ColorBackWoman';
    GRAPH_INI_COLORBACKMAN = 'ColorBackMan';
    GRAPH_INI_COLORSOSA = 'ColorSOSA';
    GRAPH_INI_SHOWBACK = 'ShowBack';
    GRAPH_INI_SHOWTEXT = 'ShowText';
    GRAPH_INI_LINE_HEIGHT = 'LineHeight';

type


  { TGraphBoxes }

  TGraphBoxes=class(TGraphComponent)

  private
    FSpaceBetween2Gen,FSpaceBetween2Person,
    FBoxWidth,FBoxHeight : Integer;

    EPrintTextRect : TPaintTextRect;
    EPrintText     : TPaintText;
    EPrintRect     : TPaintRect;
    EPrintRoundRect: TPaintRoundRect;
    EPrintBrushSet : TPaintBrushSet;
    EPrintPenSet   : TPaintPenSet;
    EPrintColor    : TPaintColor;
    EPrintFont     : TPaintFont;
    EPrintMoveTo   ,
    EPrintLineTo   : TPaintCoord;
    FArrowIndi:TImage;
    FTimerArrowIndi:TTimer;

    procedure p_setArrowIndi ( AValue : TImage );
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure TimerArrowIndiTimer(Sender:TObject);
    procedure GraphMoved; override;
    procedure PaintTextXY(const aleft, atop:Double;const s: string;const Angle: Integer=0); virtual;
    procedure PaintTextRect(var ARect : TFloatRect;const aleft, atop:Double;const s: string;const Angle: Integer=0);virtual;
    procedure PaintRect  (const AX1, AY1, AX2, AY2 : Extended ); virtual;
    procedure PaintRoundRect  (const AX1, AY1, AX2, AY2, W, H : Extended ); virtual;
    procedure PaintSetPen(const AColor:TColor;const PenStyle : {$IFDEF FPC}TFPPenStyle{$ENDIF}; const PenWidth : Single ; const PenMode : {$IFDEF FPC}TFPPenMode{$ENDIF}); virtual;
    procedure PaintSetBrush(const AColor:TColor;const BrushStyle : {$IFDEF FPC}TFPBrushStyle{$ENDIF}); virtual;
    procedure PaintFont (const AFont : TFont ; const AFontsize : Single ); virtual;
    procedure PaintMoveTo(const AX, AY : Extended ); virtual;
    procedure PaintLineTo(const AX, AY : Extended ); virtual;

  public
    constructor Create ( Aowner: TComponent ); override;
    procedure ReadSectionIni; override;
    procedure WriteSectionIni; override;
    property TimerArrowIndi : TTimer read FTimerArrowIndi;
    //disposition
   published
    property ArrowIndi : TImage read FArrowIndi write p_setArrowIndi;
    property BoxWidth  : Integer read FBoxWidth write FBoxWidth default GRAPH_BOXES_DEFAULT_BOX_WIDTH;
    property BoxHeight : Integer read FBoxHeight write FBoxHeight default GRAPH_BOXES_DEFAULT_BOX_HEIGHT;
    property SpaceGeneration : Integer read FSpaceBetween2Gen write FSpaceBetween2Gen default GRAPH_BOXES_DEFAULT_SPACE_GENERATION;
    property SpacePerson    : Integer read FSpaceBetween2Person write FSpaceBetween2Person default GRAPH_BOXES_DEFAULT_SPACE_PERSON;
    property PrintOutTextXY : TPaintText read EPrintText write EPrintText;
    property PrintSetRectXY : TPaintTextRect read EPrintTextRect write EPrintTextRect;
    property PrintRect     : TPaintRect read EPrintRect write EPrintRect;
    property PrintRoundRect: TPaintRoundRect read EPrintRoundRect write EPrintRoundRect;
    property PrintBrushSet : TPaintBrushSet read EPrintBrushSet write EPrintBrushSet;
    property PrintFont     : TPaintFont   read EPrintFont write EPrintFont;
    property PrintPenSet   : TPaintPenSet read EPrintPenSet write EPrintPenSet;
    property PrintColor    : TPaintColor read EPrintColor write EPrintColor;
    property PrintMoveTo   : TPaintCoord read EPrintMoveTo write EPrintMoveTo;
    property PrintLineTo   : TPaintCoord read EPrintLineTo write EPrintLineTo;
  end;

implementation

uses
  Forms,
  Math,
  Dialogs,
  u_objet_TGedcomDate,
  u_common_functions,
  u_common_const;


constructor TGraphBoxes.Create ( Aowner: TComponent );
begin
  inherited Create ( Aowner );

  // default font
  Font.Name:='Tahoma';
  Font.Size:=8;
  Font.Color:=clWindowText;

  // component init
  FBoxWidth            := GRAPH_BOXES_DEFAULT_BOX_WIDTH;
  FBoxHeight           := GRAPH_BOXES_DEFAULT_BOX_HEIGHT;
  FSpaceBetween2Gen    := GRAPH_BOXES_DEFAULT_SPACE_GENERATION;
  FSpaceBetween2Person := GRAPH_BOXES_DEFAULT_SPACE_PERSON;

  FArrowIndi:=nil;
  FTimerArrowIndi:=TTimer.Create(Self);
  FTimerArrowIndi.Interval:=600;
  FTimerArrowIndi.Enabled:=False;
  FTimerArrowIndi.OnTimer:=TimerArrowIndiTimer;
end;

procedure TGraphBoxes.ReadSectionIni;
begin
  inherited;
  ReadInteger(GRAPH_INI_BOXWIDTH);
  ReadInteger(GRAPH_INI_BOXHEIGHT);
  ReadInteger(GRAPH_INI_SPACEGENERATION);
  ReadInteger(GRAPH_INI_SPACEPERSON);
end;

procedure TGraphBoxes.WriteSectionIni;
begin
  inherited;
  WriteInteger(GRAPH_INI_BOXWIDTH);
  WriteInteger(GRAPH_INI_BOXHEIGHT);
  WriteInteger(GRAPH_INI_SPACEGENERATION);
  WriteInteger(GRAPH_INI_SPACEPERSON);
end;

procedure TGraphBoxes.PaintTextXY(const aleft, atop:Double;const s: string;const Angle: Integer=0);
Begin
  if assigned ( EPrintText ) Then
    EPrintText ( Self, s, aleft, atop, Angle )
  else
    AbortMessage('You have to set PrintOutTextXY Event.');
End;

procedure TGraphBoxes.PaintTextRect(var ARect : TFloatRect;const aleft, atop:Double;const s: string;const Angle: Integer=0);
Begin
  if assigned ( EPrintTextRect ) Then
    EPrintTextRect ( Self, ARect, s, aleft, atop,  Angle )
  else
    AbortMessage('You have to set PrintSetRectXY Event.');
End;


procedure TGraphBoxes.PaintSetPen(const AColor:TColor;const PenStyle : {$IFDEF FPC}TFPPenStyle{$ENDIF}; const PenWidth : Single ; const PenMode : {$IFDEF FPC}TFPPenMode{$ENDIF});
Begin
  if assigned ( EPrintPenSet ) Then
    EPrintPenSet ( Self, AColor, PenStyle, PenWidth, PenMode )
  else
    AbortMessage('You have to set PrintPenSet Event.');
End;

procedure TGraphBoxes.PaintSetBrush(const AColor:TColor;const BrushStyle : {$IFDEF FPC}TFPBrushStyle{$ENDIF});
Begin
  if assigned ( EPrintBrushSet ) Then
    EPrintBrushSet ( Self, AColor, BrushStyle )
  else
    AbortMessage('You have to set PrintBrushSet Event.');
End;

procedure TGraphBoxes.PaintMoveTo(const AX, AY : Extended );
Begin
  if assigned ( EPrintMoveTo ) Then
    EPrintMoveTo ( Self, AX, AY )
  else
    AbortMessage('You have to set PrintMoveTo Event.');
End;

procedure TGraphBoxes.p_setArrowIndi(AValue: TImage);
begin
  if AValue = nil Then
    FTimerArrowIndi.Enabled:=False;
  FArrowIndi:=AValue;
  if ([csLoading,csDesigning] * Owner.ComponentState = [csDesigning])
  and assigned (FArrowIndi) then
    With FArrowIndi do
     if assigned ( Parent )
     and ( Picture.Width = 0 ) then
      Begin
       Visible:=False;
       Width  := 18 ;
       Height := 18 ;
       Transparent:=true;
       Picture.LoadFromLazarusResource ( 'ArrowIndi' );
      end;

end;

procedure TGraphBoxes.Notification(AComponent: TComponent; Operation: TOperation
  );
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) Then Exit;
  if (FArrowIndi <> nil) and
    (FArrowIndi = AComponent) then ArrowIndi := nil;
end;

procedure TGraphBoxes.TimerArrowIndiTimer(Sender: TObject);
begin
  FArrowIndi.Visible:=not FArrowIndi.Visible;
end;

procedure TGraphBoxes.GraphMoved;
var
  IndiEnCours:integer;
  IndiPos:TPoint;
  actif : Boolean;
begin
  if assigned(FArrowIndi) Then
    Begin
      IndiEnCours:=IndiDansListe;
      if IndiEnCours>-1 then
        begin
          Indipos:=PositionIndi(IndiEnCours);
          FArrowIndi.Left:=IndiPos.X-FArrowIndi.Width div 2;
          with Viewer do
            FArrowIndi.Top:=IndiPos.Y+trunc(FBoxHeight/2*(Zoom*ScreenRatio));
          actif:=True;
        end
        else
          actif:=false;
      FArrowIndi.Visible:=actif;
    end
   Else actif := False;
  FTimerArrowIndi.Enabled:=actif;
end;


procedure TGraphBoxes.PaintLineTo(const AX, AY : Extended );
Begin
  if assigned ( EPrintLineTo ) Then
    EPrintLineTo ( Self, AX, AY )
  else
    AbortMessage('You have to set PrintLineTo Event.');
End;

procedure TGraphBoxes.PaintFont (const AFont : TFont ; const AFontsize : Single );
Begin
  if assigned ( EPrintFont ) Then
    EPrintFont ( Self, AFont, AFontsize )
  else
    AbortMessage('You have to set PrintFontStyles Event.');
End;
procedure TGraphBoxes.PaintRect  (const AX1, AY1, AX2, AY2 : Extended );
Begin
  if assigned ( EPrintRect ) Then
    EPrintRect ( Self, AX1, AY1, AX2, AY2 )
  else
    AbortMessage('You have to set PrintRect Event.');
End;
procedure TGraphBoxes.PaintRoundRect  (const AX1, AY1, AX2, AY2, W, H : Extended );
Begin
  if assigned ( EPrintRect ) Then
    EPrintRoundRect ( Self, AX1, AY1, AX2, AY2, W, H  )
  else
    AbortMessage('You have to set PrintRoundRect Event.');
End;

end.
