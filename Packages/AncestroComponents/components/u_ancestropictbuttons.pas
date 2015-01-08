unit u_ancestropictbuttons;

{$IFDEF FPC}
{$mode Delphi}
{$ELSE}
{$R *.DCR}
{$ENDIF}

interface

uses
{$IFDEF FPC}
   lresources,ExtJvXPButtons,
{$ELSE}
   Windows, Messages,JvXPButtons,
{$ENDIF}
  Classes,
{$IFDEF VERSIONS}
   fonctions_version,
{$ENDIF}
  Controls, u_buttons_defs,
  u_buttons_flat,
  Graphics,
  Menus, u_ancestropictimages;

const
{$IFDEF VERSIONS}
    gVer_ancestropictbuttons : T_Version = ( Component : 'Customized Ancestro Buttons' ;
                                       FileUnit : 'u_ancestropictbuttons' ;
                                       Owner : 'Matthieu Giroux' ;
                                       Comment : 'Customized Buttons components.' ;
                                       BugsStory : '1.0.0.0 : Tested.'+#10
                                                 + '0.8.0.0 : To test.';
                                       UnitType : 3 ;
                                       Major : 1 ; Minor : 0 ; Release : 0 ; Build : 0 );
{$ENDIF}
  CST_XAHISTORY='txahistory';
  CST_XAPRIOR='txaprior';
  CST_XANEXT='txanext';
  CST_XANEXTPAGE='txanextpage';
  CST_XAPRIORPAGE='txapriorpage';
  CST_XAFAVORITE='txafavorite';
  CST_XANEIGHBOR='txaneighbor';
  CST_XAWEB    ='txaweb';



type

  { TXAAncestromania }

  TXAAncestromania = class ( TFWButton )
     public
      procedure LoadBitmap; override;
    End;

  { TXASpeedButton }

  TXASpeedButton = class ( TFBSpeedButton )
    public
     constructor Create(AOwner: TComponent); override;
    published
      property NumGlyphs default 2;
    End;
  { TXAPrior }

  TXAPrior = class ( TXASpeedButton )
     public
      procedure Loaded; override;
    End;
  { TXAPrior }

  { TXAPriorPage }

  TXAPriorPage = class ( TXASpeedButton )
     public
      procedure Loaded; override;
    End;
  { TXANext }

  TXANext = class ( TXASpeedButton )
     public
      procedure Loaded; override;
    End;
  { TXANextPage }

  TXANextPage = class ( TXASpeedButton )
     public
      procedure Loaded; override;
    End;
  { TXAHistory }

  TXAHistory = class ( TFWButton )
     public
      procedure LoadBitmap; override;
    End;
  { TXAHuman }

  TXAHuman = class ( TFWButton )
     public
      procedure LoadBitmap; override;
    End;

  { TXAWeb }

  TXAWeb = class ( TFWButton )
     public
      procedure LoadBitmap; override;
    End;

  { TXAWorld }

  TXAWorld = class ( TFWButton )
     public
      procedure LoadBitmap; override;
    End;

  { TXAFavorite }

  TXAFavorite = class ( TFWButton )
     public
      procedure LoadBitmap; override;
    End;

  { TXANeighbor }

  TXANeighbor = class ( TFWButton )
     public
      procedure LoadBitmap; override;
    End;


implementation

uses fonctions_images;

{ TXAHuman }

procedure TXAHuman.LoadBitmap;
begin
  p_Load_Buttons_Appli ( Glyph, CST_IAHUMAN, Self );
end;

procedure TXANext.Loaded;
begin
  p_Load_Bitmap_Appli ( Glyph, CST_XANEXT, Self );
  inherited;
end;

{ TXANextPage }

procedure TXANextPage.Loaded;
begin
  p_Load_Bitmap_Appli ( Glyph, CST_XANEXTPAGE, Self );
  inherited;
end;

{ TXAPriorPage }

procedure TXAPriorPage.Loaded;
begin
  p_Load_Bitmap_Appli ( Glyph, CST_XAPRIORPAGE, Self );
  inherited;
end;

{ TXAPrior }

procedure TXAPrior.Loaded;
begin
  p_Load_Bitmap_Appli ( Glyph, CST_XAPRIOR, Self );
  inherited;
end;

{ TXASpeedButton }

constructor TXASpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  NumGlyphs:=2;
end;

{ TXANeighbor }

procedure TXANeighbor.LoadBitmap;
begin
  p_Load_Buttons_Appli ( Glyph, CST_XANEIGHBOR, Self );
end;

{ TXAFavorite }

procedure TXAFavorite.LoadBitmap;
begin
  p_Load_Buttons_Appli ( Glyph, CST_XAFAVORITE, Self );
end;

{ TXAAncestromania }

procedure TXAAncestromania.LoadBitmap;
begin
  p_Load_Buttons_Appli ( Glyph, CST_IAANCESTRO, Self );
end;

{ TXAWeb }

procedure TXAWeb.LoadBitmap;
begin
  p_Load_Buttons_Appli ( Glyph, CST_XAWEB, Self );

end;

{ TXAWorld }

procedure TXAWorld.LoadBitmap;
begin
  p_Load_Buttons_Appli ( Glyph, CST_XAHISTORY, Self );
end;

{ TXAHISTORY }

procedure TXAHistory.LoadBitmap;
begin
  p_Load_Buttons_Appli ( Glyph, CST_XAHISTORY, Self );

end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_ancestropictbuttons );
{$ENDIF}
end.
