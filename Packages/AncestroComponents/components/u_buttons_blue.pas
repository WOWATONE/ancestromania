unit u_buttons_blue;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

interface

uses
 {$IFNDEF FPC}
    Windows,
 {$ENDIF}
  Classes, SysUtils,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  u_buttons_defs,
  Graphics, u_comp_TBlueFlatSpeedButton;

{$IFDEF VERSIONS}
const
    gVer_buttons_blue : T_Version = ( Component : 'Blue Buttons extension' ;
                                       FileUnit : 'u_buttons_blue' ;
                                       Owner : 'Matthieu Giroux' ;
                                       Comment : 'Specialised buttons components' ;
                                       BugsStory : '0.8.0.0 : Not tested.';
                                       UnitType : 3 ;
                                       Major : 0 ; Minor : 8 ; Release : 0 ; Build : 0 );
{$ENDIF}

type

    { TBFSSpeedButton }

    TBFSSpeedButton = class ( TBlueFlatSpeedButton, IFWButton )
      published
       property Glyph stored False;
     End;

    TBFSClose = class ( TBFSSpeedButton )
      private
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
       procedure Click; override;
      published
       property Width default CST_FWWIDTH_CLOSE_BUTTON ;
     End;

{ TBFSOK }
   TBFSOK = class ( TBFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TBFSInsert }
   TBFSInsert = class ( TBFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;
{ TBFSAdd }
   TBFSAdd = class ( TBFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TBFSDelete }
  TBFSDelete = class ( TBFSSpeedButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
      procedure Loaded; override;
    End;

{ TBFSDocument }
   TBFSDocument = class ( TBFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TBFSQuit }
   TBFSQuit = class ( TBFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

{ TBFSErase }
   TBFSErase = class ( TBFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

{ TBFSSaveAs }
   TBFSSaveAs = class ( TBFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

   { TBFSLoad }
      TBFSLoad = class ( TBFSSpeedButton )
         public
          constructor Create ( AOwner : TComponent ) ; override;
          procedure Loaded; override;
        End;

{ TBFSPrint }
   TBFSPrint = class ( TBFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
     End;

{ TBFSCancel }
   TBFSCancel = class ( TBFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;


{ TBFSPreview }
   TBFSPreview = class ( TBFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TBFSNext }
   TBFSNext = class ( TBFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TBFSPrior }
   TBFSPrior= class ( TBFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TBFSCopy }
   TBFSCopy = class ( TBFSSpeedButton )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

{ TBFSInit }
   TBFSInit = class ( TBFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TBFSConfig }
   TBFSConfig = class ( TBFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TBFSImport }
   TBFSImport = class ( TBFSSpeedButton )
      public
       procedure Loaded; override;
     End;
{ TBFSTrash }
   TBFSTrash = class ( TBFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{ TBFSExport }
   TBFSExport = class ( TBFSSpeedButton )
      public
       procedure Loaded; override;
     End;

{$IFDEF GROUPVIEW}

{ TBFSGroupButton }

    { TBFSGroupButtonActions }

    TBFSGroupButtonActions = class ( TBFSSpeedButton )
     public
      constructor Create ( AOwner : TComponent ) ; override;
      procedure Loaded; override;
     published
      property Width  default CST_WIDTH_BUTTONS_ACTIONS;
      property Height default CST_HEIGHT_BUTTONS_ACTIONS;
    end;


   { TBFSBasket }

   TBFSBasket = class ( TBFSGroupButtonActions )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

   { TBFSRecord }

   TBFSRecord = class ( TBFSGroupButtonActions )
      public
       constructor Create ( AOwner : TComponent ) ; override;
       procedure Loaded; override;
     End;

   { TBFSGroupButtonMoving }

   TBFSGroupButtonMoving = class ( TBFSSpeedButton )
   public
    constructor Create ( AOwner : TComponent ) ; override;
    procedure Loaded; override;
   published
    property Width  default CST_WIDTH_BUTTONS_MOVING;
    property Height default CST_HEIGHT_BUTTONS_MOVING;
   end;
   { TBFSOutSelect }
    TBFSOutSelect = class ( TBFSGroupButtonMoving )
       public
        procedure Loaded; override;
      End;

   { TBFSOutAll }


   TBFSOutAll = class ( TBFSGroupButtonMoving )
      public
       procedure Loaded; override;
     End;

{ TBFSInSelect }
   TBFSInSelect = class ( TBFSGroupButtonMoving )
      public
       procedure Loaded; override;
     End;

{ TBFSInAll }
   TBFSInAll = class ( TBFSGroupButtonMoving )
      public
       procedure Loaded; override;
     End;

{$ENDIF}

implementation

uses {$IFDEF FPC}ObjInspStrConsts, LCLStrConsts,
     {$ELSE}Consts, VDBConsts, {$ENDIF}
  {$IFDEF FPC}
  unite_messages,
  {$ELSE}
  unite_messages_delphi,
  {$ENDIF}
     Dialogs,
     Forms, u_buttons_appli ;


{$IFNDEF FPC}
var Buttons_Appli_ResInstance             : THandle      = 0 ;
{$ENDIF}

{ TBFSSpeedButton }


{ TBFSTrash }

procedure TBFSTrash.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWTRASH, self );

end;

{ TBFSLoad }

constructor TBFSLoad.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWLOAD, self );
end;

procedure TBFSLoad.Loaded;
begin
  inherited Loaded;
  {$IFDEF FPC}
  p_setControlCaption ( Self, oiStdActFileOpenHint );
  {$ENDIF}

end;

{ TBFSDocument }

procedure TBFSDocument.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWDOCUMENT, self );
end;

{ TBFSDelete }

constructor TBFSDelete.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWDELETE, self );
end;

procedure TBFSDelete.Loaded;
begin
  inherited Loaded;
end;

{ TBFSClose }


procedure TBFSClose.Click;
begin
  if not assigned ( OnClick )
  and ( Owner is TCustomForm ) then
    with Owner as TCustomForm do
     Begin
      Close;
      Exit;
     End;
  inherited;

end;

constructor TBFSClose.Create(AOwner: TComponent);
begin
  inherited;
  Width := CST_FWWIDTH_CLOSE_BUTTON;
end;

procedure TBFSClose.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWCLOSE, self );
  p_setControlCaption ( Self, SCloseButton );
end;

{ TBFSCancel }

constructor TBFSCancel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWCANCEL, self );
end;

procedure TBFSCancel.Loaded;
begin
  inherited Loaded;
  {$IFDEF FPC}
  p_setControlCaption ( Self, oiStdActDataSetCancel1Hint );
  {$ELSE}
  p_setControlCaption ( Self, SMsgDlgCancel );
  {$ENDIF}

end;

{ TBFSOK }

procedure TBFSOK.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWOK, self );
  {$IFDEF FPC}
  p_setControlCaption ( Self, oisOk2 );
  {$ELSE}
  p_setControlCaption ( Self, SMsgDlgok );
  {$ENDIF}
end;

{ TBFSInsert }

constructor TBFSInsert.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT, self );
end;

procedure TBFSInsert.Loaded;
begin
  inherited Loaded;
  {$IFDEF FPC}
  p_setControlCaption ( Self, ifsVK_INSERT );
  {$ELSE}
  p_setControlCaption ( Self, SInsertRecord );
  {$ENDIF}
end;

{ TBFSAdd }

constructor TBFSAdd.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWINSERT, self );
end;

{ TBFSSaveAs }

constructor TBFSSaveAs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWSAVEAS, self );
end;

procedure TBFSSaveAs.Loaded;
begin
  inherited Loaded;
  {$IFDEF FPC}
  p_setControlCaption ( Self, oiStdActFileSaveAsHint );
  {$ENDIF}

end;

{ TBFSQuit }

constructor TBFSQuit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWQUIT, self );
end;

procedure TBFSQuit.Loaded;
begin
  inherited Loaded;
  p_setControlCaption ( Self, SCloseButton );

end;

{ TBFSerase }

constructor TBFSErase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWERASE, self );
end;

procedure TBFSErase.Loaded;
begin
  inherited Loaded;
  {$IFDEF FPC}
  p_setControlCaption ( Self, oisDelete );
  {$ENDIF}
end;

{ TBFSPrint }

constructor TBFSPrint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWPRINT, self );
end;

{ TBFSNext }

procedure TBFSNext.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWNEXT, self );
end;
{ TBFSPrior }

procedure TBFSPrior.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWPRIOR, self );
end;

{ TBFSPreview }

procedure TBFSPreview.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWPREVIEW, self );
end;

{ TBFSInit }

procedure TBFSInit.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWINIT, self );
end;

{ TBFSConfig }

procedure TBFSConfig.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWCONFIG, self );
end;

{ TBFSImport }

procedure TBFSImport.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWIMPORT, self );
end;

{ TBFSExport }

procedure TBFSExport.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWEXPORT, self );
end;

{ TBFSCopy }

constructor TBFSCopy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWCOPY, self );
end;

procedure TBFSCopy.Loaded;
begin
  inherited Loaded;
  {$IFDEF FPC}
  p_setControlCaption ( Self, oiStdActEditCopyShortHint );
  {$ENDIF}

end;

{$IFDEF GROUPVIEW}

{ TBFSOutSelect }

procedure TBFSOutSelect.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTSELECT, self );

end;

{ TBFSBasket }

constructor TBFSBasket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWBASKET, self );
end;

procedure TBFSBasket.Loaded;
begin
  inherited Loaded;
  {$IFDEF FPC}
  p_setControlCaption ( Self, oisUndo );
  {$ELSE}
  p_setControlCaption ( Self, Gs_GROUPVIEW_Basket );
  {$ENDIF}

end;

{ TBFSRecord }

constructor TBFSRecord.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  p_Load_Buttons_Appli ( Glyph, CST_FWOK, self );
end;

procedure TBFSRecord.Loaded;
begin
  inherited Loaded;
  {$IFDEF FPC}
  p_setControlCaption ( Self, oisRecord );
  {$ELSE}
  p_setControlCaption ( Self, Gs_GROUPVIEW_Record );
  {$ENDIF}

end;

{ TBFSOutAll }

procedure TBFSOutAll.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWOUTALL, self );

end;

{ TBFSInSelect }

procedure TBFSInSelect.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWINSELECT, self );

end;

{ TBFSInAll }

procedure TBFSInAll.Loaded;
begin
  inherited Loaded;
  p_Load_Buttons_Appli ( Glyph, CST_FWINALL, self );

end;



{ TBFSGroupButtonActions }

constructor TBFSGroupButtonActions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width  := CST_WIDTH_BUTTONS_ACTIONS;
  Height := CST_HEIGHT_BUTTONS_ACTIONS;
end;

procedure TBFSGroupButtonActions.Loaded;
begin
  inherited Loaded;
end;

{ TBFSGroupButtonMoving }

constructor TBFSGroupButtonMoving.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width  := CST_WIDTH_BUTTONS_MOVING;
  Height := CST_HEIGHT_BUTTONS_MOVING;
end;

procedure TBFSGroupButtonMoving.Loaded;
begin
  inherited Loaded;
  p_setControlCaption ( Self, '' );

end;

{$ENDIF}


{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_buttons_blue  );
{$ENDIF}

end.

