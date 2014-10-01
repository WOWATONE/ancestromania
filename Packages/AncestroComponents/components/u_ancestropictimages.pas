unit u_ancestropictimages;

{$IFDEF FPC}
{$mode Delphi}
{$ELSE}
{$R *.DCR}
{$ENDIF}
{$I ..\extends.inc}

interface

uses
{$IFDEF FPC}
  lresources, ExtJvXPButtons,
{$ELSE}
  JvXPButtons, Windows, Messages,
{$ENDIF}
  Classes,
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  ExtCtrls, u_buttons_defs,
  Graphics,
  Menus, Controls;

const
{$IFDEF VERSIONS}
  gVer_ancestropictimages: T_Version = (Component: 'Customized Ancestro Images';
    FileUnit: 'u_ancestropictimages';
    Owner: 'Matthieu Giroux';
    Comment: 'Customized images components.';
    BugsStory: '0.8.0.0 : To test.';
    UnitType: 3;
    Major: 0; Minor: 8; Release: 0; Build: 0);
{$ENDIF}
  CST_IAFRANCE = 'txafrance';
  CST_IAWORLD  = 'tiaworld';

  CST_IAMAN    = 'tiaman';
  CST_IAWOMAN  = 'tiawoman';

  CST_IAABSTRACT = 'tiatitle';
  CST_IAANCESTRO = 'txaancestromania';
  CST_IADATABASE = 'tiadatabase';
  CST_IAEMAIL = 'txaemail';
  CST_IAFAVORITE = 'txafavorite';
  CST_IAINFO  = 'txainfo';
  CST_IAHUMAN  = 'txahuman';
  CST_IAMOUSE = 'tiamouse';
  CST_IANOTES = 'tianotes';
  CST_IAPEOPLE = 'txapeople';
  CST_IAPOSTCARD = 'txapostcard';
  CST_IAQUESTION = 'txaquestion';
  CST_IAWHO = 'txawho';
  CST_IAPRINTER = 'tiaprinter';
  CST_IASEARCH = 'tiasearch';
  CST_IATREE = 'tiatree';


type
  TImageAncestro = (iaNone, iaAncestromania, iaPostCard, iaDatabase, iaEmail, iaFavorite,
    iaFrance, iaGlobe, iaHuman, iaInfo, iaMouse, iaNotes, iaPeople, iaPrinter, iaQuestion,
    iaTree, iaWho);

  TCountryAncestro = ( caWorld, caFrance );

  TGenderAncestro = ( gaUnknown, gaMan, gaWoman );

  IIAImage = interface
    ['{620AE27F-9891-8A3D-E54F-FE57D16207E5}']
    procedure Paint;
  end;

  { TXAXButton }

  { TXAXPButton }

  TXAXPButton = class ( TFWButton )
    public
      constructor Create ( AOwner : TComponent ) ; override;
    published
      property GlyphSize default 24;
    End;

  { TIAImage }

  TIAImage = class(TImage, IIAImage)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Picture stored False;
    property Transparent default True;
  end;

  { TIAImageOn }

  { TIAImageTitle }

  TIAImageTitle = class(TIAImage)
  protected
    procedure Click; override;
    procedure DblClick; override;
    procedure TripleClick; override;
    procedure QuadClick; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Height default 55;
    property Width default 123;
  end;

  TIAImageOn = class(TIAImageTitle)
  protected
    procedure Click; override;
    procedure DblClick; override;
    procedure TripleClick; override;
    procedure QuadClick; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;

  public
    constructor Create(AOwner: TComponent); override;
  published
    property Height default 55;
    property Width default 123;
  end;

  { TIATITLE }

  TIATitle = class(TIAImageTitle)
  private
    FTitle: TIAImageOn;
    FImageOn: TImageAncestro;
  protected
    procedure PutImageOn(const AValue: TImageAncestro); virtual;
    procedure AutoSizeTitle; virtual;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
  published
    property ImageOn: TImageAncestro read FImageOn write PutImageOn default iaNone;
  end;

  { TIAImage44 }

  TIAImage44 = class(TIAImage)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Stretch default True;
    property Proportional default True;
    property Height default 44;
    property Width default 44;
  end;
  { TIAMouse }

  TIAMouse = class(TIAImage)
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
  published
    property Height default 33;
    property Width default 49;
  end;

  { TIASearch }

  TIASearch = class(TIAImage)
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
  published
    property Height default 152;
    property Width default 122;
  end;

  { TIAHuman }
  TIAHuman = class(TIAImage)
  public
    procedure Loaded; override;
  end;

  { TIAWorld }
  TIAWorld = class(TIAImage44)
  private
    FImageOn: TCountryAncestro;
    procedure PutImageOn(const AValue: TCountryAncestro);
  public
   constructor Create(AOwner: TComponent); override;
  published
    property ImageOn: TCountryAncestro read FImageOn write PutImageOn default caWorld;
  end;

  { TIAGender }
  TIAGender = class(TIAImage44)
  private
    FImageOn: TGenderAncestro;
    procedure PutImageOn(const AValue: TGenderAncestro);
  public
   constructor Create(AOwner: TComponent); override;
  published
    property ImageOn: TGenderAncestro read FImageOn write PutImageOn default gaUnknown;
  end;

  { TIAFavorite }

  TIAFavorite = class(TIAImage44)
  public
    procedure Loaded; override;
  end;

  { TIAInfo }

  TIAInfo = class ( TIAImage )
     public
      procedure Loaded; override;
    End;

  { TXAInfo }

  TXAInfo = class ( TXAXPButton )
     public
      procedure LoadBitmap; override;
    End;
  { TIAQuestion }

  TIAQuestion = class(TIAImage44)
  public
    procedure Loaded; override;
  end;
  { TXAQuestion }

  TXAQuestion = class ( TXAXPButton )
   public
    procedure LoadBitmap; override;
  End;

  { TXAMQuestion }

  TXAMQuestion = class ( TXAXPButton )
   public
    procedure LoadBitmap; override;
  End;

  { TXAWho }

  TXAWho = class ( TXAXPButton )
     public
      procedure LoadBitmap; override;
    End;

  { TXAPeople }

  TXAPeople = class ( TXAXPButton )
     public
      procedure LoadBitmap; override;
    End;

  { TXAEMail }

  TXAEMail = class ( TXAXPButton )
     public
      procedure LoadBitmap; override;
    End;

  { TXAPostCard }

  TXAPostCard = class ( TXAXPButton )
     public
      procedure LoadBitmap; override;
    End;

implementation

uses fonctions_images;

{ TXAXPButton }

constructor TXAXPButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GlyphSize:=24;
end;

{ TIAGender }

procedure TIAGender.PutImageOn(const AValue: TGenderAncestro);
begin
  if AValue <> FImageOn then
  begin
    FImageOn := Avalue;
    case FImageOn of
      gaMan: p_Load_Buttons_Appli(Picture, CST_IAMAN, Self);
      gaWoman: p_Load_Buttons_Appli(Picture, CST_IAWOMAN, Self);
      else
        p_Load_Buttons_Appli(Picture, CST_IAWHO, Self);
    end;
  end;
end;

constructor TIAGender.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ImageOn := gaUnknown;
end;

{ TIAQuestion }

procedure TIAQuestion.Loaded;
begin
  p_Load_Buttons_Appli(Picture, CST_IAQUESTION, Self);
  inherited Loaded;
end;

{ TXAQuestion }

procedure TXAQuestion.LoadBitmap;
begin
  p_Load_Buttons_Appli(Glyph, CST_IAQUESTION, Self);
end;

{ TXAMQuestion }

procedure TXAMQuestion.LoadBitmap;
begin
  p_Load_Buttons_Appli(Glyph, CST_IAQUESTION, Self);
end;

{ TXAPeople }

procedure TXAPeople.LoadBitmap;
begin
  p_Load_Buttons_Appli(Glyph, CST_IAPEOPLE, Self);
end;

{ TXAWho }

procedure TXAWho.LoadBitmap;
begin
  p_Load_Buttons_Appli(Glyph, CST_IAWHO, Self);
end;

{ TIAHuman }

procedure TIAHuman.Loaded;
begin
  p_Load_Buttons_Appli(Picture, CST_IAHUMAN, Self);
  Width  := Picture.Width;
  Height := Picture.Height;
  inherited Loaded;
end;

{ TIAFavorite }

procedure TIAFavorite.Loaded;
begin
  p_Load_Buttons_Appli(Picture, CST_IAFAVORITE, Self);
  inherited Loaded;
end;

{ TIAImage44 }

constructor TIAImage44.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Stretch:=True;
  Proportional:=True;
  Height := 44;
  Width := 44;
end;

{ TIAImageTitle }

constructor TIAImageTitle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 55;
  Width := 123;
end;

procedure TIAImageTitle.Click;
begin
  inherited Click;
end;

procedure TIAImageTitle.DblClick;
begin
  inherited DblClick;
end;

procedure TIAImageTitle.TripleClick;
begin
  inherited TripleClick;
end;

procedure TIAImageTitle.QuadClick;
begin
  inherited QuadClick;
end;

procedure TIAImageTitle.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TIAImageTitle.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited MouseMove(Shift, X, Y);
end;

procedure TIAImageTitle.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TIAImageTitle.MouseEnter;
begin
  inherited MouseEnter;
end;

procedure TIAImageTitle.MouseLeave;
begin
  inherited MouseLeave;
end;

{ TIAContry }

procedure TIAWorld.PutImageOn(const AValue: TCountryAncestro);
begin
  if AValue <> FImageOn then
  begin
    FImageOn := Avalue;
    case FImageOn of
      caFrance: p_Load_Buttons_Appli(Picture, CST_IAFRANCE, Self);
      else
        p_Load_Buttons_Appli(Picture, CST_IAWORLD, Self);
    end;
  end;
end;

constructor TIAWorld.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ImageOn:=caWorld;
end;

{ TIAMouse }

constructor TIAMouse.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 49;
  Width := 33;
end;

procedure TIAMouse.Loaded;
begin
  p_Load_Buttons_Appli(Picture, CST_IAMOUSE, Self);
  inherited Loaded;
end;

{ TIASearch }

constructor TIASearch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 152;
  Width := 122;
end;

procedure TIASearch.Loaded;
begin
  p_Load_Buttons_Appli(Picture, CST_IASEARCH, Self);
  inherited Loaded;
end;

{ TIAImage }

constructor TIAImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Transparent := True;
end;

{ TIAImageOn }

procedure TIAImageOn.Click;
begin
  Inherited;
  (Owner as TIAImageTitle).Click;
end;

procedure TIAImageOn.DblClick;
begin
  inherited;
  (Owner as TIAImageTitle).DblClick;
end;

procedure TIAImageOn.TripleClick;
begin
  inherited;
  (Owner as TIAImageTitle).TripleClick;
end;

procedure TIAImageOn.QuadClick;
begin
  inherited;
  (Owner as TIAImageTitle).QuadClick;
end;

procedure TIAImageOn.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited;
  (Owner as TIAImageTitle).MouseDown( Button, Shift, X, Y);
end;

procedure TIAImageOn.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited;
  (Owner as TIAImageTitle).MouseMove(Shift, X, Y);
end;

procedure TIAImageOn.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited;
  (Owner as TIAImageTitle).MouseUp(Button, Shift, X, Y);
end;

procedure TIAImageOn.MouseEnter;
begin
  inherited;
  (Owner as TIAImageTitle).MouseEnter;
end;

procedure TIAImageOn.MouseLeave;
begin
  inherited;
  (Owner as TIAImageTitle).MouseLeave;
end;

constructor TIAImageOn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 55;
  Width := 123;
end;

{ TIATITLE }

procedure TIATitle.PutImageOn(const AValue: TImageAncestro);
begin
  if AValue <> FImageOn then
  begin
    FImageOn := Avalue;
    with FTitle do
      case FImageOn of
        iaWho: p_Load_Buttons_Appli(Picture, CST_IAWHO, FTitle);
        iaDataBase: p_Load_Buttons_Appli(Picture, CST_IADATABASE, FTitle);
        iaEmail: p_Load_Buttons_Appli(Picture, CST_IAEMAIL, FTitle);
        iaFavorite: p_Load_Buttons_Appli(Picture, CST_IAFAVORITE, FTitle);
        iaFrance: p_Load_Buttons_Appli(Picture, CST_IAFRANCE, FTitle);
        iaGlobe: p_Load_Buttons_Appli(Picture, CST_IAWORLD, FTitle);
        iaHuman: begin p_Load_Buttons_Appli(Picture, CST_IAHUMAN, FTitle); p_ChangeTailleBitmap(Picture.Bitmap,0,44,True); end;
        iaInfo: p_Load_Buttons_Appli(Picture, CST_IAINFO, FTitle);
        iaMouse: p_Load_Buttons_Appli(Picture, CST_IAMOUSE, FTitle);
        iaNotes: p_Load_Buttons_Appli(Picture, CST_IANOTES, FTitle);
        iaPostCard: p_Load_Buttons_Appli(Picture, CST_IAPOSTCARD, FTitle);
        iaPrinter: p_Load_Buttons_Appli(Picture, CST_IAPRINTER, FTitle);
        iaPeople: p_Load_Buttons_Appli(Picture, CST_IAPEOPLE, FTitle);
        iaQuestion: p_Load_Buttons_Appli(Picture, CST_IAQUESTION, FTitle);
        iaAncestromania: p_Load_Buttons_Appli(Picture, CST_IAANCESTRO, FTitle);
        iaTree: p_Load_Buttons_Appli(Picture, CST_IATREE, FTitle);
        else
          Picture.Clear;
      end;
  end;
end;

constructor TIATitle.Create(AOwner: TComponent);
begin
  FTitle := TIAImageOn.Create(Self);
  FTitle.Parent := Parent;
  inherited Create(AOwner);
  FTitle.Center := True;
  ImageOn := iaNone;
end;

procedure TIATitle.AutoSizeTitle;
begin
  if csLoading in ComponentState then
    Exit;
  FTitle.Parent := Parent;
  FTitle.Top := Top;
  FTitle.Left := Left;
  FTitle.Width := Width;
  FTitle.Height := Height;
end;

procedure TIATitle.Resize;
begin
  inherited Resize;
  AutoSizeTitle;
end;

procedure TIATitle.Loaded;
begin
  p_Load_Buttons_Appli(Picture, CST_IAABSTRACT, Self);
  inherited Loaded;
end;


{ TIAInfo }

procedure TIAInfo.Loaded;
begin
  p_Load_Buttons_Appli ( Picture, CST_IAINFO, Self );
  inherited Loaded;
end;


{ TXAInfo }

procedure TXAInfo.LoadBitmap;
begin
  p_Load_Buttons_Appli ( Glyph, CST_IAINFO, Self );
end;


{ TXAEMail }

procedure TXAEMail.LoadBitmap;
begin
  p_Load_Buttons_Appli ( Glyph, CST_IAEMail, Self );
end;

{ TXAPostCard }

procedure TXAPostCard.LoadBitmap;
begin
  p_Load_Buttons_Appli ( Glyph, CST_IAPostCard, Self );
end;



initialization
{$IFDEF VERSIONS}
  p_ConcatVersion(gVer_ancestropictimages);
{$ENDIF}
{$IFDEF MEMBUTTONS}
  {$I u_ancestropictimages.lrs}
{$ENDIF}
end.
