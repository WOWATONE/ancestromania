unit WizardTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

const
  DefaultHorizontalSpace  = 4;
  DefaultVerticalSpace    = 8;
  DefaultBoxHeight        = 17;
  DefaultBoxWidth         = 16;
  DefaultBoxColor         = clGray;
  DefaultSelectedBoxColor = clLime;
  DefaultLineColor        = clWhite;
  DefaultFontColor        = clWhite;
  DefaultColor            = clBlack;
  DefaultTopMargin        = 4;
  DefaultLeftMargin       = 4;
  DefaultHeight           = 140;
  DefaultWidth            = 133;

  VersionString           = '1.0';

type

  TOnChanging = procedure( Sender :TObject; NewItemIndex : Integer; var AllowChange : Boolean ) of object;
  TOnChange = procedure( Sender : TObject ) of object;

  TWizardTree = class(TPanel)
  private
    FItems : TStrings;
    procedure SetItems( NewItems : TStrings );
  private
    FItemIndex : Integer;
    procedure SetItemIndex( Value : Integer );
  private
    FLineColor        : TColor;
    FSelectedBoxColor : TColor;
    FBoxColor         : TColor;
    FBoxHeight        : Integer;
    FBoxWidth         : Integer;
    FHorizontalSpace  : Integer;
    FVerticalSpace    : Integer;
    FTopMargin        : Integer;
    FLeftMargin       : Integer;
    FVersion          : string;
    procedure SetLineColor( Value : TColor );
    procedure SetSelectedBoxColor( Value : TColor );
    procedure SetBoxColor( Value : TColor );
    procedure SetBoxHeight( Value : Integer );
    procedure SetBoxWidth( Value : Integer );
    procedure SetHorizontalSpace( Value : Integer );
    procedure SetVerticalSpace( Value : Integer );
    procedure SetLeftMargin( Value : Integer );
    procedure SetTopMargin( Value : Integer );
    procedure SetVersion( Value : string );
  private
    FOnChanging : TOnChanging;
    FOnChange   : TOnChange;
  private
    FRects : TList;
    procedure AllocateRects;
    procedure FillBox( Index : Integer; Live : Boolean );
  protected
    procedure Paint; override;
    procedure Click; override;
  public
    constructor Create( AOwner : TComponent ); override;
    destructor Destroy; override;
  published
    property Items : TStrings read FItems write SetItems;
    property ItemIndex : Integer read FItemIndex write SetItemIndex;
    property LineColor : TColor read FLineColor write SetLineColor;
    property SelectedBoxColor : TColor read FSelectedBoxColor write SetSelectedBoxColor;
    property BoxColor : TColor read FBoxColor write SetBoxColor;
    property HorizontalSpace : Integer read FHorizontalSpace write SetHorizontalSpace;
    property VerticalSpace : Integer read FVerticalSpace write SetVerticalSpace;
    property BoxHeight : Integer read FBoxHeight write SetBoxHeight;
    property BoxWidth : Integer read FBoxWidth write SetBoxWidth;
    property LeftMargin : Integer read FLeftMargin write SetLeftMargin;
    property TopMargin : Integer read FTopMargin write SetTopMargin;
    property OnChanging : TOnChanging read FOnChanging write FOnChanging;
    property OnChange : TOnChange read FOnChange write FOnChange;
    property Version : string read FVersion write SetVersion stored False; 
  end;

procedure Register;

implementation

constructor TWizardTree.Create( AOwner : TComponent );
begin
  inherited Create( AOwner );
  FItems := TStringList.Create;
  FRects := TList.Create;
  Caption := '';
  BevelOuter := bvNone;
  FItemIndex := 0;
  HorizontalSpace  := DefaultHorizontalSpace  ;
  VerticalSpace    := DefaultVerticalSpace    ;
  BoxHeight        := DefaultBoxHeight        ;
  BoxWidth         := DefaultBoxWidth         ;
  BoxColor         := DefaultBoxColor         ;
  SelectedBoxColor := DefaultSelectedBoxColor ;
  LineColor        := DefaultLineColor        ;
  Font.Color       := DefaultFontColor        ;
  Color            := DefaultColor            ;
  Width            := DefaultWidth;
  Height           := DefaultHeight;
  FTopMargin       := DefaultTopMargin;
  FLeftMargin      := DefaultLeftMargin;
  FVersion         := VersionString;
  FItems.Add( 'Start' );
  FItems.Add( 'First Page' );
  FItems.Add( 'Second Page' );
  FItems.Add( 'Finish' );
end;

destructor TWizardTree.Destroy;
begin
  FItems.Clear;
  AllocateRects;
  FItems.Free;
  FRects.Free;
  inherited Destroy;
end;

procedure TWizardTree.SetItems( NewItems : TStrings );
begin
  FItems.Assign( NewItems );
  Refresh;
end;

procedure TWizardTree.SetItemIndex( Value : Integer );
begin
  if ( Value >= -1 ) and ( Value < FItems.Count ) then
    if ( Value <> FItemIndex ) then
      begin
        FItemIndex := Value;
        Refresh;
      end;
end;

procedure TWizardTree.AllocateRects;
var
  Index : Integer;
  P     : Pointer;
begin
  if FRects.Count < FItems.Count then
    for Index := FRects.Count to Pred( FItems.Count ) do
      begin
        GetMem( P , SizeOf( TRect ) );
        FRects.Add( P );
      end
  else if FRects.Count > FItems.Count then
    for Index := Pred( FRects.Count ) downto FItems.Count do
      begin
        FreeMem( FRects[ Index ] );
        FRects.Delete( Index );
      end;
end;

procedure TWizardTree.Paint;
var
  Index : Integer;
  X , Y : Integer;
begin
  AllocateRects;
  Canvas.Brush.Color := Color;

  Canvas.FillRect( Rect( 0 , 0 , Width , Height ) );

  Y := TopMargin + VerticalSpace;
  for Index := 0 to Pred( FItems.Count ) do
    begin
      if ( Index > 0 ) and ( Index < Pred( FItems.Count ) ) then
        X := LeftMargin + HorizontalSpace + BoxWidth + HorizontalSpace
      else
        X := LeftMargin + HorizontalSpace;

      TRect( FRects[ Index ] ^ ) := Rect ( X , Y ,
        X + BoxWidth + HorizontalSpace + Canvas.TextWidth( FItems[ Index ] ) , Y + BoxHeight );
      FillBox( Index , ItemIndex = Index );

      Inc( Y  , BoxHeight + VerticalSpace * 2 );

      Canvas.Pen.Color := LineColor;
      if ( Index = 0 ) then
        begin
          Canvas.MoveTo( X + BoxWidth , Y - VerticalSpace - BoxHeight);
          Canvas.LineTo( X + HorizontalSpace + BoxWidth + BoxWidth div 2 , Y - VerticalSpace - BoxHeight );
          Canvas.LineTo( X + HorizontalSpace + BoxWidth + BoxWidth div 2 , Y + VerticalSpace );
        end
      else if ( Index = Pred( FItems.Count ) - 1 ) then
        begin
          Canvas.MoveTo( X + BoxWidth div 2 , Y - VerticalSpace * 2 );
          Canvas.LineTo( X + BoxWidth div 2 , Y + VerticalSpace );
          Canvas.LineTo( X - BoxWidth - 1 , Y + VerticalSpace );
        end
      else if ( Index < Pred( FItems.Count ) ) then
        begin
          Canvas.MoveTo( X + BoxWidth div 2 , Y - VerticalSpace * 2 );
          Canvas.LineTo( X + BoxWidth div 2 , Y );
        end;
    end;

  X := LeftMargin + HorizontalSpace + ( BoxWidth div 2 );
  Y := TopMargin + VerticalSpace + BoxHeight;
  Canvas.MoveTo( X , Y );
  Inc( Y , VerticalSpace * 4 + ( BoxHeight * (  FItems.Count - 2 ) ) + ( ( VerticalSpace * 2 ) * ( FItems.Count -3 ) ) );
  Canvas.Pen.Color := LineColor;
  Canvas.LineTo( X , Y );
end;

procedure TWizardTree.Click;
var
  Index : Integer;
  P : TPoint;
  AllowChange : Boolean;
begin
  inherited;
  GetCursorPos( P );
  P := ScreenToClient( P );
  for Index := 0 to Pred( FRects.Count ) do
    begin
      if PtInRect( TRect( FRects[ Index ] ^ ) , P ) then
        begin
          if ItemIndex <> Index then
            begin
              AllowChange := True;
              if Assigned( FOnChanging ) then
                FOnChanging( Self , Index , AllowChange );
              if AllowChange then
                begin
                  FillBox( ItemIndex , False );
                  FillBox( Index , True );
                  ItemIndex := Index;
                  if Assigned( FOnChange ) then
                    FOnChange( Self );
                end;
            end;
          Break;
        end;
    end;
end;

procedure TWizardTree.FillBox( Index : Integer; Live : Boolean );
var
  BoxRect : TRect;
  TextRect : TRect;
begin
  if ( Index < 0 ) or ( Index >= FItems.Count ) then
    Exit;  
  Canvas.Brush.Style := bsSolid;
  if Live then
    Canvas.Brush.Color := SelectedBoxColor
  else
    Canvas.Brush.Color := BoxColor;
  BoxRect := TRect( FRects[ Index ] ^ );
  TextRect := BoxRect;

  BoxRect.Right := BoxRect.Left + BoxWidth;
  TextRect.Left := BoxRect.Right + HorizontalSpace;
  if ( Index = 0 ) or ( Index = Pred( FItems.Count ) ) then
    Inc( TextRect.Left , HorizontalSpace + BoxWidth div 2 ); 
  Canvas.FillRect( BoxRect );

  Canvas.Font := Font;

  if Live then
    Canvas.Font.Style := Canvas.Font.Style + [ fsBold ];

  Canvas.Brush.Color := Color;
  Canvas.FillRect( TextRect );
  Canvas.Brush.Style := bsClear;
  Canvas.TextOut( TextRect.Left ,
    TextRect.Top + ( ( BoxHeight - Canvas.TextHeight( FItems[ Index ] ) ) div 2 )  , FItems[ Index ] );

  TRect( FRects[ Index ] ^ ) := Rect ( BoxRect.Left , BoxRect.Top ,
    BoxRect.Left + BoxWidth + HorizontalSpace + Canvas.TextWidth( FItems[ Index ] ) , BoxRect.Top + BoxHeight );
end;

procedure TWizardTree.SetLineColor( Value : TColor );
begin
  if FLineColor <> Value then
    begin
      FLineColor := Value;
      Refresh;
    end;
end;

procedure TWizardTree.SetSelectedBoxColor( Value : TColor );
begin
  if FSelectedBoxColor <> Value then
    begin
      FSelectedBoxColor := Value;
      Refresh;
    end;
end;

procedure TWizardTree.SetBoxColor( Value : TColor );
begin
  if FBoxColor <> Value then
    begin
      FBoxColor := Value;
      Refresh;
    end;
end;

procedure TWizardTree.SetBoxHeight( Value : Integer );
begin
  if FBoxHeight <> Value then
    begin
      FBoxHeight := Value;
      Refresh;
    end;
end;

procedure TWizardTree.SetBoxWidth( Value : Integer );
begin
  if FBoxWidth <> Value then
    begin
      FBoxWidth := Value;
      Refresh;
    end;
end;

procedure TWizardTree.SetHorizontalSpace( Value : Integer );
begin
  if FHorizontalSpace <> Value then
    begin
      FHorizontalSpace := Value;
      Refresh;
    end;
end;

procedure TWizardTree.SetVerticalSpace( Value : Integer );
begin
  if FVerticalSpace <> Value then
    begin
      FVerticalSpace := Value;
      Refresh;
    end;
end;

procedure TWizardTree.SetTopmargin( Value : Integer );
begin
  if Value <> FTopMargin then
    begin
      FTopMargin := Value;
      Refresh;
    end;
end;

procedure TWizardTree.SetLeftMargin( Value : Integer );
begin
  if Value <> FLeftMargin then
    begin
      FLeftMargin := Value;
      Refresh;
    end;
end;

procedure TWizardTree.SetVersion( Value : string );
begin
end;

procedure Register;
begin
  RegisterComponents('SympaPak', [TWizardTree]);
end;

end.
