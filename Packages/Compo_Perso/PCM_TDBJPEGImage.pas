unit PCM_TDBJPEGImage;
{--------------------------------------------------------------------------------------
Composant : PCM_TDBJPEGImage

Date de création : 10/08/2000
Développé par    : Philippe Cazaux-Moutou
email            : philippe.cazaux-moutou@wanadoo.Fr
Date révision    : 23/08/2000

Remerciements à :  Alphomega
                   Olivier Cheminot

----------------------------------------------------------------------
Ce composant permet de stocker en base, en format JPG, des images quelque soit le format

Attention : Une image est automatiquement transformée en JPG

----------------------------------------------------------------------
Vous pouvez utiliser et modifier ce composant
Toutefois, si vous l'améliorez ou optimiser, faites m'en parvenir
une copie

philippe.cazaux-moutou@wanadoo.Fr

----------------------------------------------------------------------

Ce composant dérivé de TabcEffectsImage de la suite ABC permet d'afficher et
d'enregistrer des images au format JPEG dans un champ d'une table

OpenPictureDilaog Intégré
-------------------------

Popup Menu Intégré
------------------
    Charger
    Copier
    Coller
    Effacer
    Vider
    Image ajustée

    Les options du menus peuvent etre renduer invisible

Propriétés du composant
-----------------------

    ------------------------------------------------------------------------------
    PCM_Data_Clef_Primaire   : Champ clef primaire de la table ou est l image
    PCM_Data_Clef_Etrangere  : Champ clef de la table maitre
    PCM_Data_Clef_Liaison    : Champ pour lier cette table a une table maitre

    ex : Les tables CLIENTS, et PHOTOS
         Clients
           CL_CLEF
           CL_NOM
           CL_PRENOM

         Photos
           PH_CLEF
           PH_IMAGE
           LIAISON_CL_CLEF

         PCM_Data_Clef_Primaire  = PH_CLEF
         PCM_Data_Clef_Etrangere = CL_CLEF
         PCM_Data_Clef_Liaison   = LIAISON_CL_CLEF

    ------------------------------------------------------------------------------

    property PCM_TauxCompression    : Taux de compression pour les images
    property PCM_Menu               : Options diverses pour le popupmenu
    property PCM_RepertoireImage    : Répertoire par défaut des images
    property PCM_NomImage           : Nom du fichier image
    property PCM_Titre              : Titre qui s'affiche dans la boite de chargement
    property PCM_ClipBoard          : Si l'image viens du presse papier ou non
    property PCM_InsertAuto         : Permet de gerer l insertion de lignes en automatique
    property Caption_Charger        : Permet de changer le caption du menu charger
    property Caption_Effacer        : Permet de changer le caption du menu effacer
    property PCM_AutoStretch        : L'image s'ajuste automatiquement ou non

Fonctions publiques du composant
--------------------------------
     up_DBEcritJPEG  : Doit etre appelé pour enregistrer les données
     up_DeleteImage  : Doit etre appelée depuis un bouton ou autre evenement
     up_AjouteImage  : Doit etre appelée depuis un bouton ou autre evenement
     up_GetMemo      : Renvoie des infos sur le fichier
     up_GetInfos     : Renvoie la date et l heure de stockage
--------------------------------------------------------------------------------------}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, dbctrls,
  ExtCtrls, DB, JPEG, Clipbrd, menus, extdlgs, GraphicEx;


const
  SousMenuCaptions: array[0..10] of string = ('Charger une image...',
    '-',
    'Copier',
    'Coller',
    '-',
    'Effacer l''image affichée',
    '-',
    'Vider le presse papier',
    '-',
    'Ajustement automatique de l''image',
    'Image ajustée');

type
  TMenuOptions = (mCharger, mCopier, mColler, mEffacer, mVider, mAjuster, mStretch);
  TMenuOption = set of TMenuOptions;

  TPanelProperties = class(TPersistent)
  private
    FPanel: TPanel;
    function GetBevelInnerOuter(Indice: integer): TBevelCut;
    procedure SetBevelInnerOuter(Indice: integer; Value: TBevelCut);
    function GetBevelBorderWidth(Indice: integer): TBevelWidth;
    procedure SetBevelBorderWidth(Indice: integer; Value: TBevelWidth);
    function GetPanelColor: TColor;
    procedure SetPanelColor(Value: TColor);
  published
    property Color: TColor read GetPanelColor write SetPanelColor default clWhite;
    property BevelInner: TBevelCut index 0 read GetBevelInnerOuter write SetBevelInnerOuter;
    property BevelOuter: TBevelCut index 1 read GetBevelInnerOuter write SetBevelInnerOuter;
    property BevelWidth: TBevelWidth index 0 read GetBevelBorderWidth write SetBevelBorderWidth;
    property BorderWidth: TBevelWidth index 1 read GetBevelBorderWidth write SetBevelBorderWidth;
  end;

  TPCM_MenuProperties = class(TPersistent)
  private
    FMenuOption: TMenuOption;
    procedure SetMenuChargerEffacerCaption(Indice: integer; Value: string);
    function GetMenuChargerEffacerCaption(Indice: integer): string;
  published
    property PCM_MenuOption: TMenuOption read FMenuOption write FMenuOption default [];
    property Caption_Charger: string index 0 read GetMenuChargerEffacerCaption write SetMenuChargerEffacerCaption;
    property Caption_Effacer: string index 5 read GetMenuChargerEffacerCaption write SetMenuChargerEffacerCaption;
  end;

  TPCM_Options = class(TPersistent)
  private
    FPCM_MenuProperties: TPCM_MenuProperties;
    SNomImage: string;
    SImagesDir: string;
    STitre: string;
    SMemo, SInfos: string;
    BClipBoard: boolean;
    BInsertAuto: boolean;

    ITauxCompression: smallint;

    procedure SetImagesDir(Value: string);
    procedure SetNomImage(Value: string);
    procedure SetTitre(Value: string);
    procedure SetClipBoard(Value: boolean);
    procedure SetInsertAuto(Value: boolean);

    procedure SetTauxCompression(Value: smallint);
  published
    property PCM_Menu: TPCM_MenuProperties read FPCM_MenuProperties write FPCM_MenuProperties;
    property PCM_RepertoireImage: string read SImagesDir write SetImagesDir;
    property PCM_NomImage: string read SNomImage write SetNomImage;
    property PCM_Titre: string read STitre write SetTitre;
    property PCM_ClipBoard: Boolean read BClipBoard write SetClipBoard;
    property PCM_InsertAuto: Boolean read BInsertAuto write SetInsertAuto;
    property PCM_TauxCompression: smallint read ITauxCompression write SetTauxCompression;

  end;

  TPCM_TDBJPEGImage = class(TCustomPanel)
  private
    {Options générales ----------------------------------------------------------------------------}
    MS: TMemoryStream;
    Image: TImage;
    J1: TJPEGImage;

    FPCM_Options: TPCM_Options;
    FPanelProperties: TPanelProperties;

    BClipBoard: Boolean;
    bStretch: boolean;

    {Options pour les données ---------------------------------------------------------------------}
    FClefPrimaire: TField;
    FClefEtrangere: TField;
    FClefLiaison: TField;
    FDatalink: TFieldDatalink;

    {Méthodes pour le popup menu ------------------------------------------------------------------}
    procedure up_PopUp(Sender: TObject);
    procedure up_Charger(Sender: TObject);
    procedure up_Copier(Sender: TObject);
    procedure up_Coller(Sender: TObject);
    procedure up_Effacer(Sender: TObject);
    procedure up_Vider(Sender: TObject);
    procedure up_Stretch(Sender: TObject);
    procedure up_StretchAuto(Sender: TObject);

    {Méthodes pour les données --------------------------------------------------------------------}
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);

    procedure SetClefPrimaire(Value: TField);
    procedure SetClefEtrangere(Value: TField);
    procedure SetClefLiaison(Value: TField);
    procedure SetStretch(Value: boolean);

    procedure Change(Sender: TObject);
    function up_Error: boolean;
  protected
    { Déclarations protégées }
    // procedure Paint; override;
  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure up_DBEcritJPEG(Sender: TObject);
    procedure up_DeleteImage;
    procedure up_AjouteImage;
    function up_GetMemo: string;
    function up_GetInfos: string;
  published
    property Align;
    property Anchors;

    {Propriétés générales -------------------------------------------------------------------------}
    property PCM_Options: TPCM_Options read FPCM_Options write FPCM_Options;
    {Propriétés pour les données ------------------------------------------------------------------}
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;

    property PCM_Data_ClefPrimaire: TField read FClefPrimaire write SetClefPrimaire;
    property PCM_Data_Clef_Etrangere: TField read FClefEtrangere write SetClefEtrangere;
    property PCM_Data_Clef_Liaison: TField read FClefLiaison write SetClefLiaison;

    property PCM_Auto_Stretch: boolean read bStretch write SetStretch;
    property Bordure: TPanelProperties read FPanelProperties write FPanelProperties;
  end;

procedure Register;

implementation

var
  Menu: TPopupmenu;

constructor TPCM_TDBJPEGImage.Create(AOwner: TComponent);
var
  SousMenu: TMenuItem;
  i: integer;
begin
  inherited create(AOwner);
  Caption := #32;

  // --- Création et init du DataLink
  FDatalink := TFieldDataLink.Create;
  FDatalink.OnDataChange := DataChange;
  FDatalink.OnUpdateData := UpdateData;

  // --- Création et init de l'image
  Image := TImage.Create(Self);
  with Image do begin
      Parent := Self;
      Align := alClient;
      Stretch := True;
      Center := True;
    end;

  // ---
  FPanelProperties := TPanelProperties.Create;
  FPanelProperties.FPanel := TPanel(Self);

  with FPanelProperties do begin
      FPanel := TPanel(Self);
      BevelOuter := bvLowered;
      Color := clBackground;
    end;

  FPCM_Options := TPCM_Options.Create;
  FPCM_Options.FPCM_MenuProperties := TPCM_MenuProperties.Create;

  // ---
  J1 := TJPEGImage.Create;
  // ---
  with J1 do begin
      PixelFormat := jf24Bit;
      Scale := jsFullSize;
      Grayscale := False;
      Performance := jpBestQuality;
      ProgressiveDisplay := False;
      ProgressiveEncoding := True;
    end;

  {Gestion du menu popup ---------------------------------------------------------------------------}
  Menu := TPopupMenu.Create(Self);
  // --- Init des sous items
  for i := 0 to High(SousMenuCaptions) do begin
      SousMenu := TMenuItem.Create(Self);
      SousMenu.Caption := SousMenuCaptions[i];
      Menu.Items.Add(SousMenu);
      SousMenu.Visible := False;
    end;

  // ---
  with Menu do begin
      OnPopup := up_PoPup;
      Items[0].OnClick := up_Charger;
      Items[2].OnClick := up_Copier;
      Items[3].OnClick := up_Coller;
      Items[5].OnClick := up_Effacer;
      Items[7].OnClick := up_Vider;
      Items[9].OnClick := up_StretchAuto;
      Items[10].OnClick := up_Stretch;

    end;
  // ---
  Popupmenu := Menu;
  PCM_Options.PCM_Menu.PCM_MenuOption := [mCharger, mCopier, mColler, mEffacer, mVider, mAjuster, mStretch];
  // ---

  {Initialisation des valeurs par défaut ------------------------------------------------------}
  PCM_Options.BClipBoard := True;
  PCM_Options.BInsertAuto := True;
  PCM_Options.ITauxCompression := 70;
  PCM_Options.STitre := 'Quelle image voulez-vous charger ?';
  PCM_Options.sMemo := '';
  PCM_Options.sInfos := 'Photo/Document enregistré le : ' + DateToStr(Date) + ' à ' + TimeToStr(Time);
end;

destructor TPCM_TDBJPEGImage.Destroy;
begin
  FDataLink.free;
  Image.Picture := nil;
  Image.Free;
  J1.Free;
  FPanelProperties.Free;
  FPCM_Options.FPCM_MenuProperties.Free;
  FPCM_Options.Free;
  inherited destroy;
end;

{ Méthodes pour les données -----------------------------------------------------------------------}

procedure TPCM_TDBJPEGImage.Change(Sender: TObject);
begin
  FDataLink.Modified;
end;

procedure TPCM_TDBJPEGImage.SetClefPrimaire(Value: TField);
begin
  if Value <> FClefPrimaire then FClefPrimaire := Value;
end;

procedure TPCM_TDBJPEGImage.SetClefEtrangere(Value: TField);
begin
  if Value <> FClefEtrangere then FClefEtrangere := Value;
end;

procedure TPCM_TDBJPEGImage.SetClefLiaison(Value: TField);
begin
  if Value <> FClefLiaison then FClefLiaison := Value;
end;

function TPCM_TDBJPEGImage.GetDataField: string;
begin
  result := FDataLink.FieldName;
end;

function TPCM_TDBJPEGImage.GetDataSource: TDataSource;
begin
  result := FDataLink.DataSource;
end;

procedure TPCM_TDBJPEGImage.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

procedure TPCM_TDBJPEGImage.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
end;

procedure TPCM_TDBJPEGImage.DataChange(Sender: TObject);
begin

  if FDataLink.Field = nil then
    Image.Picture := nil
  else
    begin
      MS := TMemoryStream.Create;

      try
        TBlobField(FDataLink.Field).SaveToStream(MS);
        MS.Seek(soFromBeginning, 0);

        J1.LoadFromStream(MS);

        if MS.Size > 0 then
          begin
            if bStretch then
              if (J1.Height > Image.Height) or (J1.Width > Image.Width) then
                Image.Stretch := True
              else
                Image.Stretch := False;

            Image.Picture.Assign(J1);
          end
        else
          Image.Picture := nil;

      finally
        MS.Free;
      end;
    end;
end;

procedure TPCM_TDBJPEGImage.UpdateData(Sender: TObject);
{-----------------------------------------------------------------------------------------
Permet de creer un fichier JPEG depuis n'importe quel type d image et de le
stocker dans une table
------------------------------------------------------------------------------------------}
var
  t_Image: TPicture;
  ms_ImageTempo: TMemoryStream;
begin
  inherited;

  if up_Error then Exit;

  {Creation de l'image temporaire ---------------------------------------------------------}
  ms_ImageTempo := TMemoryStream.Create;
  t_Image := TPicture.Create;

  PCM_Options.sMemo := '';
  PCM_Options.sInfos := 'Photo/Document enregistré le : ' + DateToStr(Date) + ' à ' + TimeToStr(Time);

  if PCM_Options.BInsertAuto then FDataLink.DataSource.DataSet.Insert;

  if not BClipBoard then begin
      t_Image.LoadFromFile(PCM_Options.SNomImage);
      ClipBoard.Assign(t_Image);
      Image.Picture.LoadFromClipboardFormat(CF_BITMAP, Clipboard.GetAsHandle(CF_BITMAP), 0);

      PCM_Options.SMemo := 'Nom du fichier : ' + PCM_Options.SNomImage + #10#13 +
        'Largeur : ' + inttostr(t_image.Width) + #10#13 +
        'Hauteur : ' + inttostr(t_image.Height) + #10#13 +
        StringOfChar('-', 140);

      {Creation du format JPEG ----------------------------------------------------------------}
      with TJPEGImage.Create do begin
          try
            Assign(t_Image.Graphic);
            if UpperCase(ExtractFileExt(ExtractFileName(PCM_Options.SNomImage))) <> '.JPG' then
              begin
                CompressionQuality := PCM_Options.ITauxCompression;
                Compress;
                SaveToStream(ms_ImageTempo);

                {On stocke l'image convertie en JPEG dans le champ de la table---------------}
                TBlobField(FDataLink.Field as TBlobField).LoadFromStream(ms_ImageTempo);
              end
            else
              {On stocke l'image JPEG dans le champ de la table-------------------------------}
              TBlobField(FDataLink.Field as TBlobField).LoadFromFile(PCM_Options.SNomImage);

          finally
            Free;
          end
        end;

    end
  else
    begin
      t_Image.LoadFromClipboardFormat(CF_BITMAP, Clipboard.GetAsHandle(CF_BITMAP), 0);
      Image.Picture.LoadFromClipboardFormat(CF_BITMAP, Clipboard.GetAsHandle(CF_BITMAP), 0);

      with TJPEGImage.Create do begin
          Assign(t_Image.Graphic);
          CompressionQuality := PCM_Options.ITauxCompression;
          Compress;
          SaveToStream(ms_ImageTempo);

          {On stocke l'image convertie en JPEG dans le champ de la table---------------}
          TBlobField(FDataLink.Field as TBlobField).LoadFromStream(ms_ImageTempo);
        end;

      PCM_Options.sMemo := 'Image copiée depuis le presse papier...';
    end;

  if FClefPrimaire <> nil then FClefPrimaire.AsInteger := 1;
  if FClefEtrangere <> nil then FClefLiaison.AsInteger := FClefEtrangere.AsInteger;

  {On détruit l'image tempo--------------------------------------------------------------}
  t_Image.free;
  ms_ImageTempo.free;

end;

{ Méthodes du popup menu --------------------------------------------------------------------------}

procedure TPCM_TDBJPEGImage.up_PopUp(Sender: TObject);
begin

  with Menu, PCM_Options.PCM_Menu do begin

      Items[0].Visible := mCharger in PCM_MenuOption;
      Items[2].Visible := mCopier in PCM_MenuOption;
      Items[3].Visible := mColler in PCM_MenuOption;
      Items[5].Visible := mEffacer in PCM_MenuOption;
      Items[7].Visible := mVider in PCM_MenuOption;
      Items[9].Visible := mAjuster in PCM_MenuOption;

      Items[2].Enabled := Image.Picture <> nil;
      Items[3].Enabled := Clipboard.HasFormat(CF_BITMAP);
      Items[5].Enabled := Image.Picture <> nil;
      Items[7].Enabled := Clipboard.HasFormat(CF_BITMAP);

      Items[9].Checked := bStretch;

      if Image.Stretch then
        Items[10].Caption := 'Image taille d''origine'
      else
        Items[10].Caption := 'Image ajustée';
    end;
end;

procedure TPCM_TDBJPEGImage.up_Charger(Sender: TObject);
var OpenPictureDialog: TOpenDialog;
begin
  if up_Error then Exit;

  OpenPictureDialog := TOpenDialog.Create(Self);

  with OpenPictureDialog, PCM_Options do begin
      InitialDir := PCM_RepertoireImage;
      Title := PCM_Titre;
      // --------------------------------------------
      if Execute then begin
          if FileName <> '' then begin
              BClipBoard := False;
              SNomImage := Filename;
              UpdateData(Sender);
            end;
        end;
    end;

  OpenPictureDialog.free;

end;

procedure TPCM_TDBJPEGImage.up_Copier(Sender: TObject);
begin
  if up_Error then Exit;
  if Image.Picture <> nil then Clipboard.Assign(Image.Picture)
end;

procedure TPCM_TDBJPEGImage.up_Coller(Sender: TObject);
begin
  if up_Error then Exit;

  if Clipboard.HasFormat(CF_BITMAP) then begin
      BClipBoard := True;
      PCM_Options.PCM_NomImage := '';
      UpdateData(Sender);
    end;

end;

procedure TPCM_TDBJPEGImage.up_Effacer(Sender: TObject);
var s_Message: string;
begin
  if up_Error then Exit;

  s_Message := 'Voulez-vous supprimer cette image ?';

  if MessageDlg(s_Message, mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      FDataLink.DataSource.DataSet.Delete;
      Change(Sender);
      DataChange(Sender);
    end;

end;

procedure TPCM_TDBJPEGImage.up_Vider(Sender: TObject);
begin
  if up_Error then Exit;
  if Clipboard.HasFormat(CF_BITMAP) then ClipBoard.Clear;
end;

procedure TPCM_TDBJPEGImage.up_Stretch(Sender: TObject);
begin
  if up_Error then Exit;
  Image.Stretch := not Image.Stretch;
end;


procedure TPCM_TDBJPEGImage.up_StretchAuto(Sender: TObject);
begin
  if up_Error then Exit;
  bStretch := not bStretch;
  Image.Stretch := bStretch;
end;

// ========================================================================================================

{Méthodes générales -------------------------------------------------------------------------------}

function TPCM_MenuProperties.GetMenuChargerEffacerCaption(Indice: integer): string;
begin
  Result := Menu.Items[Indice].Caption;
end;

procedure TPCM_MenuProperties.SetMenuChargerEffacerCaption(Indice: integer; Value: string);
begin
  if Length(Value) < 5 then begin
      Showmessage('Le texte doit faire au moins 5 caractères...');
      Exit;
    end;
  with Menu.Items[Indice] do
    if Value <> Caption then
      Caption := Value;
end;

procedure TPCM_Options.SetImagesDir(Value: string);
begin
  if Value <> SImagesDir then SImagesDir := Value;
end;

procedure TPCM_Options.SetNomImage(Value: string);
begin
  if Value <> SNomImage then SNomImage := Value;
end;

procedure TPCM_Options.SetTitre(Value: string);
begin
  if Value <> STitre then STitre := Value;
end;

procedure TPCM_Options.SetClipBoard(Value: Boolean);
begin
  if Value <> BClipBoard then BClipBoard := Value;
end;

procedure TPCM_TDBJPEGImage.SetStretch(Value: Boolean);
begin
  if Value <> BStretch then BStretch := Value;
  Image.Stretch := bStretch;
end;


procedure TPCM_Options.SetInsertAuto(Value: Boolean);
begin
  if Value <> BInsertAuto then BInsertAuto := Value;
end;

procedure TPCM_Options.SetTauxCompression(Value: smallint);
begin
  if Value <> ITauxCompression then ITauxCompression := Value;
end;
// ========================================================================================================


function TPCM_TDBJPEGImage.up_Error: Boolean;
var b_Retour: boolean;
begin
  b_Retour := False;

  if FDataLink.DataSource = nil then begin
      ShowMessage('C''est un composant orienté donnée. Vous n''avez pas renseigné' +
        ' la propiété DataSource');
      b_Retour := True;
    end;

  if b_retour = False then
    if FDataLink.Field = nil then begin
        ShowMessage('C''est un composant orienté donnée. Vous n''avez pas renseigné' +
          ' la propiété DataField');
        b_Retour := True;
      end;

  Result := b_Retour;
end;

{Méthodes publiques  ------------------------------------------------------------------------------}

procedure TPCM_TDBJPEGImage.up_DeleteImage;
begin
  if up_Error then exit;
  up_Effacer(Self);
end;

procedure TPCM_TDBJPEGImage.up_AjouteImage;
begin
  if up_Error then exit;
  up_Charger(Self);
end;

procedure TPCM_TDBJPEGImage.up_DBEcritJPEG(Sender: TObject);
begin
  if up_Error then exit;
  UpdateData(Sender);
end;

function TPCM_TDBJPEGImage.up_GetMemo: string;
begin
  result := PCM_Options.SMemo;
end;

function TPCM_TDBJPEGImage.up_GetInfos: string;
begin
  result := PCM_Options.SInfos;
end;

{$WARNINGS OFF}
{--------------- Implémentation de TPanelProperties -----------------------------------------------------------}

function TPanelProperties.GetBevelInnerOuter(Indice: integer): TBevelCut;
begin
  case Indice of
    0: Result := FPanel.BevelInner;
    1: Result := FPanel.BevelOuter;
  end;
end;

procedure TPanelProperties.SetBevelInnerOuter(Indice: integer; Value: TBevelCut);
begin
  case Indice of
    0: if Value <> FPanel.BevelInner then FPanel.BevelInner := Value;
    1: if Value <> FPanel.BevelOuter then FPanel.BevelOuter := Value;
  end;
end;

function TPanelProperties.GetBevelBorderWidth(Indice: integer): TBevelWidth;
begin
  case Indice of
    0: Result := FPanel.BevelWidth;
    1: Result := FPanel.BorderWidth;
  end;
end;

procedure TPanelProperties.SetBevelBorderWidth(Indice: integer; Value: TBevelWidth);
begin
  case Indice of
    0: if Value <> FPanel.BevelWidth then FPanel.BevelWidth := Value;
    1: if Value <> FPanel.BorderWidth then FPanel.BorderWidth := Value;
  end;
end;

function TPanelProperties.GetPanelColor: TColor;
begin
  Result := FPanel.Color;
end;

procedure TPanelProperties.SetPanelColor(Value: TColor);
begin
  if Value <> FPanel.Color then
    FPanel.Color := Value;
end;
{$WARNINGS ON}


procedure Register;
begin
  RegisterComponents('Perso', [TPCM_TDBJPEGImage]);
end;

end.

