unit u_Form_Bibliotheque_Multimedia;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  ShellApi, Jpeg, TPanelUnit, MPlayer, DelphiTwain, Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
  Graphics,ExtDlgs,Variants,
  DB,IBQuery,forms,IBUpdateSQL,Dialogs,StdCtrls,
  Controls,ExtCtrls,Classes,SysUtils,
  u_buttons_appli,ExtJvXPButtons,IBCustomDataSet,
  Menus, ExtJvXPCheckCtrls,
  PrintersDlgs, MaskEdit,
  u_ancestropictbuttons,
  u_ancestropictimages, rxdbgrid,
  IBSQL,fonctions_init, u_extdbgrid,
  U_OnFormInfoIni;

type

  { TFBiblioMultimedia }

  TFBiblioMultimedia=class(TForm)
    btnAnnuler: TFWCancel;
    btnAppliquer: TFWOK;
    btnFermer: TFWClose;
    btnSelection: TFWOK;
    btnToutAdapter: TJvXPButton;
    cbMiniatures: TJvXPCheckbox;
    cbToutCharger: TJvXPCheckbox;
    IBmedias: TIBQuery;
    IBMediasMULTI_CLEF: TLongintField;
    IBMediasMULTI_NOM: TIBStringField;
    IBMediasMULTI_PATH: TIBStringField;
    Label18: TIAInfo;
    mem_full_renaming: TMemo;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PopupMenu1:TPopupMenu;
    mQuiUtiliseMedia:TMenuItem;
    N21:TMenuItem;
    Panel5:TPanel;
    FlatPanel1:TPanel;
    FlatTabControl:TPanel;
    Panel4:TPanel;
    FlatPanel2:TPanel;
    btnScanner:TJvXPButton;
    btnWebCam:TXAWeb;
    btnPhoto:TJvXPButton;
    btnAddImage:TFWAdd;
    btnAddSon:TFWAdd;
    btnDel:TFWDelete;
    iVideo:TImage;
    iSons:TImage;
    ilOnglet:TImageList;
    rgTri:TRadioGroup;
    IBMultimedia:TIBQuery;
    IBMultimediaMULTI_CLEF:TLongintField;
    IBMultimediaMULTI_INFOS:TIBStringField;
    IBMultimediaMULTI_DOSSIER:TLongintField;
    IBMultimediaMULTI_DATE_MODIF:TDateTimeField;
    IBMultimediaMULTI_MEMO:TMemoField;
    IBMultimediaMULTI_REDUITE:TBlobField;
    IBMultimediaMULTI_PATH:TIBStringField;
    IBMultimediaMULTI_NOM:TIBStringField;
    IBMultimediaMULTI_IMAGE_RTF:TLongintField;
    IBMultimediaMULTI_AFFECTE:TLongintField;
    IBMultimediaMULTI_EVENEMENTS:TLongintField;
    IBMultimediaMULTI_UNIONS:TLongintField;
    IBMultimediaMULTI_MEDIA:TBlobField;
    IBMultimediaMULTI_AUTRE:TLongintField;
    IBUMultimedia:TIBUpdateSQL;
    btnPrint:TFWPrint;
    dxComponentPrinter1:TPrinterSetupDialog;
    OpenDialogSons:TOpenDialog;
    dsGrid:TDataSource;
    mDeleteMedia:TMenuItem;
    ilMenu:TImageList;
    GridListe:TExtDBGrid;
    mAjoutImage:TMenuItem;
    mAjoutSon:TMenuItem;
    mScanner:TMenuItem;
    mWebCam:TMenuItem;
    mPhoto:TMenuItem;
    mPrint:TMenuItem;
    N1:TMenuItem;
    N2:TMenuItem;
    N3:TMenuItem;
    mEditImage:TMenuItem;
    SavePictureDialog1:TSavePictureDialog;
    mChangeImage:TMenuItem;
    N4:TMenuItem;
    N5:TMenuItem;
    mExportImage:TMenuItem;
    SaveDialog:TSaveDialog;
    Visualiserlemdiaslectionn1:TMenuItem;
    iAutre:TImage;
    {$IFNDEF FPC}
    DelphiTwain1:TDelphiTwain;
    {$ENDIF}
    IBSQLPointeur:TIBSQL;
    PopupMenuMemoire:TPopupMenu;
    Garderenmmoire:TMenuItem;
    btnChemin:TJvXPButton;
    mToutRecharger:TMenuItem;
    mRechargerFichier:TMenuItem;
    mRechargerImage:TMenuItem;
    lImagesDansBase:TLabel;
    gbAjouter:TGroupBox;
    mRafraichir:TMenuItem;
    qMediaCharge:TIBSQL;
    procedure btnToutAdapterClick(Sender: TObject);
    procedure cxGridListeGetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
    procedure FormCreate(Sender:TObject);
    procedure mQuiUtiliseMediaClick(Sender:TObject);

    procedure cxGridListeNomDblClick(Sender:TObject);
    procedure FlatTabControlChange(Sender:TObject);
    procedure btnSelectionClick(Sender:TObject);
    procedure FormShow(Sender:TObject);
    procedure btnAddImageClick(Sender:TObject);
    procedure IBMultimediaNewRecord(DataSet:TDataSet);
    procedure btnDelClick(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure btnAddSonClick(Sender:TObject);
    procedure btnScannerClick(Sender:TObject);
    procedure btnWebCamClick(Sender:TObject);
    procedure btnPhotoClick(Sender:TObject);
    procedure rgTriClick(Sender:TObject);
    procedure btnAppliquerClick(Sender:TObject);
    procedure btnAnnulerClick(Sender:TObject);
    procedure dsGridStateChange(Sender:TObject);
    procedure gridListeDblClick(Sender:TObject);
    procedure gridListeMULTI_PATHDrawColumnCell(
      Sender:TObject;ACanvas:TCanvas;
      AViewInfo:Longint;var ADone:Boolean);
    procedure gridListeEditKeyDown(Sender:TObject;
      AItem:Longint;AEdit:TCustomMaskEdit;var Key:Word;
      Shift:TShiftState);
    procedure gridListeMULTI_INFOSDrawColumnCell(
      Sender:TObject;ACanvas:TCanvas;
      AViewInfo:Longint;var ADone:Boolean);
    procedure DelphiTwain1TwainAcquire(Sender:TObject;
      const Index:Integer;Image:TBitmap;var Cancel:Boolean);
    procedure DelphiTwain1AcquireCancel(Sender:TObject;
      const Index:Integer);
    procedure DelphiTwain1AcquireError(Sender:TObject;
      const Index:Integer;ErrorCode,Additional:Integer);
    procedure DelphiTwain1SourceDisable(Sender:TObject;
      const Index:Integer);
    procedure mChangeImageClick(Sender:TObject);
    procedure mExportImageClick(Sender:TObject);
    procedure mEditImageClick(Sender:TObject);
    procedure PopupMenu1Popup(Sender:TObject);
    procedure GarderenmmoireClick(Sender:TObject);
    procedure PopupMenuMemoirePopup(Sender:TObject);
    procedure btnCheminClick(Sender:TObject);
    procedure mRechargerImageClick(Sender:TObject);
    procedure mRechargerFichierClick(Sender:TObject);
    procedure gridListeMULTI_REDUITEDrawColumnCell(
      Sender:TObject;ACanvas:TCanvas;
      AViewInfo:Longint;var ADone:Boolean);
    procedure gridListeMouseEnter(Sender:TObject);
    procedure gridListeMouseLeave(Sender:TObject);
    procedure FormClose(Sender:TObject;var Action:TCloseAction);
    procedure gridListeEditKeyPress(Sender:TObject;
      AItem:Longint;AEdit:TCustomMaskEdit;var Key:Char);
    procedure IBMultimediaCalcFields(DataSet:TDataSet);
    procedure Label18Click(Sender:TObject);
    procedure cbToutChargerClick(Sender:TObject);
    procedure mRafraichirClick(Sender:TObject);
    procedure FormActivate(Sender:TObject);
    procedure cbMiniaturesClick(Sender: TObject);
  private
    {$IFNDEF FPC}
    SourceT:TTwainSource;
    {$ENDIF}
    fCleFicheSelected:integer;
    iType,fID:Integer;
    fTable,fType:string;
    bChangeImage:boolean;
    BloqueBtn:boolean;
    BloqueCar:boolean;

    procedure doOuvreGrilles;
    procedure SauveImage(sImage:string);
    procedure MajBoutons;
    procedure RechargeTout(ModeImage:boolean);
    procedure ChangeRequete;
    function MediaCharge(var Fichier:string):Integer;

  public
    property CleFicheSelected:integer read fCleFicheSelected write fCleFicheSelected;
    procedure doInit(bSelection:boolean;ID:integer;sTable,sType:string);

  end;

implementation

uses  u_Dm,
      u_common_functions,
      u_common_ancestro,u_Form_Main,u_Common_Const,
      u_Form_Capture_Video,u_Form_Capture_Photos,fonctions_dialogs,
      u_genealogy_context,
      fonctions_file,
      fonctions_string,
      u_form_working,
      u_common_ancestro_functions,lazutf8classes,
      u_Form_Path_Medias,IBTable,IniFiles,FileUtil, fonctions_system;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}
var
  PremiereFois:boolean;

procedure TFBiblioMultimedia.doInit(bSelection:boolean;ID:integer;sTable,sType:string);
begin
  btnSelection.Visible:=bSelection;
  fTable:=sTable;
  fType:=sType;
  fID:=ID;
end;

procedure TFBiblioMultimedia.FormCreate(Sender:TObject);
var
  bdr:TIniFile;
begin
  screen.Cursor:=crSQLWait;
  GridListe.Align:=alClient;
  Color:=gci_context.ColorLight;
  Application.ProcessMessages;

  BloqueBtn:=false;
  BloqueCar:=false;
  iType:=-1;
  PremiereFois:=true;
  bdr:=f_GetMemIniFile();
//    bdr.RootKey:=HKEY_CURRENT_USER;
  if bdr.ReadBool('MAin','W_BIBLIO_MULTIMEDIA', False) then
     Begin
      try
        cbToutCharger.Checked:=bdr.ReadBool('Appli','ToutCharger',False);
      except
        cbToutCharger.Checked:=false;
      end;  
      try
        cbMiniatures.Checked:=not bdr.ReadBool('Main','SansImages',False);
      except
        cbMiniatures.Checked:=True;
      end;  
     end;
  ChangeRequete;
  screen.Cursor:=crDefault;
  cbMiniatures.Hint:=rs_Hint_Library_loading_can_be_strongly_accelerated_removing_the_display_thumbnail_images;
end;

procedure TFBiblioMultimedia.cxGridListeGetBtnParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor;
  var SortMarker: TSortMarker; IsDown: Boolean);
var
  aValue:Integer;
begin
  aValue:=IBMultimediaMULTI_IMAGE_RTF.AsInteger;
  if aValue=0 then
    Background:=clBtnFace
  else
    Background:=clWindow;
end;

procedure TFBiblioMultimedia.btnToutAdapterClick(Sender: TObject);
begin
  IBmedias.Close;
  IBmedias.Params [ 0 ].Value:=dm.NumDossier;
  IBmedias.Open;
  p_RenameMediasPaths ( IBmedias, IBMediasMULTI_NOM, IBMediasMULTI_PATH, mem_full_renaming, GridListe );
  IBmedias.Close;
end;

procedure TFBiblioMultimedia.mQuiUtiliseMediaClick(Sender:TObject);
begin
  if btnAppliquer.Enabled then
    btnAppliquerClick(sender);
  FMain.OuvreFUtilisationMedia(IBMultimediaMULTI_CLEF.asInteger);
end;

procedure TFBiblioMultimedia.cxGridListeNomDblClick(Sender:TObject);
begin
  btnSelectionClick(Sender);
end;

procedure TFBiblioMultimedia.FlatTabControlChange(Sender:TObject);
begin
  // Matthieu ?
//  cxGridListeLevel1.GridView:=gridListe;
 // GridListe.BeginUpdate;

  {requête unique
  onglet Tous: aucun filtre
  filtre Evénements: multi_evenement=1
  filtre Unions: multi_unions=1
  filtre Sons/Vidéos: multi_image_rtf>=2
  filtre Fichiers: multi_image_rtf=1
  filtre Non utilisés: multi_affecte=null }
  {
  with gridListe.DataController.Filter do
  begin
    Root.Clear;
    Root.BoolOperatorKind:=fboAnd;
    case FlatTabControl.TabIndex of
      0:
        begin
          Active:=False;
        end;
      1://Evénements
        begin
          Root.AddItem(gridListeMULTI_EVENEMENT,foEqual,'1','Evénements');
          Active:=true;
        end;
      2://Unions
        begin
          Root.AddItem(gridListeMULTI_UNIONS,foEqual,'1','Unions');
          Active:=true;
        end;
      3://Sons et Vidéos
        begin
          Root.AddItem(gridListeMULTI_IMAGE_RTF,foGreaterEqual,'2','Sons/Vidéos');
          Active:=true;
        end;
      4://Autres
        begin
          Root.AddItem(gridListeMULTI_AUTRE,foEqual,'1','Autres');
          Active:=true;
        end;
      5://Non utilises
        begin
          Root.AddItem(gridListeMULTI_AFFECTE,foEqual,Null,'Non utilisés');
          Active:=true;
        end;
    end;
  end;

  GridListe.EndUpdate;
           }
  MajBoutons;
  rgTriClick(Sender);

  GridListe.SetFocus;
end;

procedure TFBiblioMultimedia.btnSelectionClick(Sender:TObject);
begin
  fCleFicheSelected:=IBMultimediaMULTI_CLEF.AsInteger;
  if btnAppliquer.Enabled then
    btnAppliquerClick(Sender);
  if (fType>'')and(fTable>'') then
    with IBSQLPointeur do
    begin
      ParamByName('MP_CLEF').AsInteger:=dm.uf_GetClefUnique('MEDIA_POINTEURS');
      ParamByName('MP_MEDIA').AsInteger:=fCleFicheSelected;
      ParamByName('MP_POINTE_SUR').AsInteger:=fID;
      ParamByName('MP_TABLE').AsString:=fTable;
      ParamByName('MP_TYPE_IMAGE').AsString:=fType;
      ParamByName('MP_KLE_DOSSIER').AsInteger:=dm.NumDossier;
      ParamByName('MP_CLE_INDIVIDU').AsInteger:=dm.individu_clef;
      ExecQuery;
      Close;
    end;
  ModalResult:=mrOk;
end;

procedure TFBiblioMultimedia.FormShow(Sender:TObject);
begin
  if PremiereFois then
  begin
    FlatTabControl.TabOrder:=0;
    FlatTabControlChange(Sender);
    PremiereFois:=false;
    Caption:=rs_Caption_Medias_library;
  end
  else
    MajBoutons;
end;

procedure TFBiblioMultimedia.btnAddSonClick(Sender:TObject);
var
  MS,MS2:TMemoryStream;
  Cle:Integer;
  fName:string;
  bCharger:boolean;
begin
  if not dm.ControleRepBase then exit;
  if bChangeImage then
  begin
    try
      OpenDialogSons.FileName:=IBMultimediaMULTI_PATH.AsString;
      OpenDialogSons.FilterIndex:=IBMultimediaMULTI_IMAGE_RTF.AsInteger;
      OpenDialogSons.InitialDir:=ExtractFileDir(IBMultimediaMULTI_PATH.AsString);
    except
    end
  end
  else
  begin
    try
      OpenDialogSons.FileName:='';
      OpenDialogSons.FilterIndex:=1;
      OpenDialogSons.InitialDir:=gci_context.PathImages;
    except
    end;
  end;
  if OpenDialogSons.Execute then
  begin
    fName:=OpenDialogSons.FileName;
    bCharger:=true;
    cle:=MediaCharge(fName);
    if cle<>-1 then
    begin
      bCharger:=false;
      if bChangeImage then
        if cle=IBMultimediaMULTI_CLEF.AsInteger then
          bCharger:=true;
      if not bCharger then
        bCharger:=MyMessageDlg(fs_RemplaceMsg(rs_Do_you_replace_media_by_other_media_file_with_name,
                              [fName]),mtConfirmation, [mbYes,mbNo],self)=mrYes;
    end;
    if bCharger then
    begin
      MS:=TMemoryStream.Create;
      MS2:=TMemoryStream.Create;
      IBMultimedia.DisableControls;
      try
        if FichEstImage(fName) then
        begin
          iType:=1;
          if not ComprImageInMS(fName,MS,MS2) then
          begin
            MS.Clear;
            iAutre.Picture.Graphic.SaveToStream(MS);
          end;
        end
        else if FichEstSon(fName) then
        begin
          iType:=2;
          iSons.Picture.Graphic.SaveToStream(MS);
        end
        else if FichEstVideo(fName) then
        begin
          iType:=3;
          iVideo.Picture.Graphic.SaveToStream(MS);
        end
        else
        begin
          iType:=1;
          iAutre.Picture.Graphic.SaveToStream(MS);
        end;

        if bChangeImage then
        begin
          IBUMultimedia.ModifySQL[2]:=',MULTI_MEDIA=:MULTI_MEDIA';
          IBUMultimedia.ModifySQL[3]:=',MULTI_REDUITE=:MULTI_REDUITE';
          IBMultimedia.edit;
        end
        else
          IBMultimedia.Insert;

        IBMultimediaMULTI_PATH.AsString:=fName;
        ( IBMultimediaMULTI_REDUITE as TBlobField ).LoadFromStream(MS);
        IBMultimediaMULTI_MEDIA.Clear;//AL v2010.4
        IBMultimedia.Post;
        if bChangeImage then
        begin
           IBUMultimedia.ModifySQL[2]:='';
           IBUMultimedia.ModifySQL[3]:='';
        end;
        btnAnnuler.Enabled:=true;
        btnAppliquer.Enabled:=true;
        gci_context.PathImages:=ExtractFileDir(fName);
      finally
        IBMultimedia.EnableControls;
        MS.Free;
        MS2.Free;
      end;
    end;//de if bCharger
  end;//de if OpenDialogSons.Execute
  bChangeImage:=false;
end;

procedure TFBiblioMultimedia.btnAddImageClick(Sender:TObject);
var
  MS1,MS2:TMemoryStream;
  fName:string;
  n,cle:integer;
  sList:TStringlistUTF8;
  bCharger:boolean;
begin
  application.ProcessMessages;
  if not dm.ControleRepBase then
    exit;
  with dm.OpenPictureDialog do
   Begin
    if bChangeImage then
    begin
      try
        FileName  :=IBMultimediaMULTI_PATH.AsString;
        Options   :=Options- [ofAllowMultiSelect];
        InitialDir:=ExtractFileDir(IBMultimediaMULTI_PATH.AsString);
      except
      end
    end
    else
    begin
      try
        FileName  :=NullAsStringValue;
        Options   :=Options+ [ofAllowMultiSelect];
        InitialDir:=gci_context.PathImages;
      except
      end;
    end;
    if Execute then
    begin
      sList:=TStringlistUTF8.Create;
      MS1:=TMemoryStream.Create;
      MS2:=TMemoryStream.Create;
      try
        sList.AddStrings(Files);
        sList.CaseSensitive:=false;
        sList.Sort;
        iType:=0;
        for n:=0 to sList.Count-1 do
        begin
          fName:=sList[n];
          bCharger:=true;
          cle:=MediaCharge(fName);
          if cle<>-1 then
          begin
            bCharger:=false;
            if bChangeImage then
              if cle=IBMultimediaMULTI_CLEF.AsInteger then
                bCharger:=true;
            if not bCharger then
              bCharger:=MyMessageDlg(fs_RemplaceMsg(rs_Do_you_replace_media_by_other_media_file_with_name,
                                [fName]),mtConfirmation, [mbYes,mbNo],self)=mrYes;
          end;
          if bCharger then
          begin
            if ComprImageInMS(fName,MS1,MS2,true,140,120,gci_context.ImagesDansBase,1024,1024) then
            begin
              IBMultimedia.DisableControls;
              //Création ou édition d'un enregistrement
              if bChangeImage then
              begin
                IBUMultimedia.ModifySQL[2]:=',MULTI_MEDIA=:MULTI_MEDIA';
                IBUMultimedia.ModifySQL[3]:=',MULTI_REDUITE=:MULTI_REDUITE';
                IBMultimedia.edit;
              end
              else
                IBMultimedia.Insert;

              IBMultimediaMULTI_PATH.AsString:=fname;
              //On ajoute l'image dans la base
              ( IBMultimediaMULTI_REDUITE as TBlobField).LoadFromStream(MS1);
              if MS2.Size>0 then
              begin
                (IBMultimediaMULTI_MEDIA as TBlobField).LoadFromStream(MS2);
                IBMultimediaMULTI_IMAGE_RTF.AsInteger:=0;
              end
              else
              begin
                IBMultimediaMULTI_MEDIA.Clear;
                IBMultimediaMULTI_IMAGE_RTF.AsInteger:=1;
              end;

              IBMultimedia.Post;
              if bChangeImage then
              begin
                 IBUMultimedia.ModifySQL[2]:='';
                 IBUMultimedia.ModifySQL[3]:='';
              end;
              IBMultimedia.EnableControls;
              btnAnnuler.Enabled:=true;
              btnAppliquer.Enabled:=true;
              MajBoutons;
            end
            else
              MyMessageDlg(rs_Error_File_format+_CRLF
                +fname,mtError, [mbOK],Self);
          end;//de if bCharger
        end;//for
      finally
        MS1.Free;
        MS2.Free;
        sList.Free;
      end;
      gci_context.PathImages:=ExtractFileDir(fName);
    end;{if opendialogueexecute}
   end;
  bChangeImage:=false;
end;

procedure TFBiblioMultimedia.IBMultimediaNewRecord(DataSet:TDataSet);
begin
  IBMultimediaMULTI_CLEF.AsInteger:=dm.uf_GetClefUnique('MULTIMEDIA');
  IBMultimediaMULTI_DOSSIER.AsInteger:=dm.NumDossier;
  IBMultimediaMULTI_IMAGE_RTF.AsInteger:=iType;
  IBMultimediaMULTI_DATE_MODIF.AsDateTime:=now;
  case iType of
    0:IBMultimediaMULTI_INFOS.AsString:=fs_RemplaceMsg(rs_Image_Recorded_on_date,[fs_Date2Str(Date)+' '+rs_on_when+' '+TimeToStr(Time)]);
    2:IBMultimediaMULTI_INFOS.AsString:=fs_RemplaceMsg(rs_Sound_Recorded_on_date,[fs_Date2Str(Date)+' '+rs_on_when+' '+TimeToStr(Time)]);
    3:IBMultimediaMULTI_INFOS.AsString:=fs_RemplaceMsg(rs_Video_Recorded_on_date,[fs_Date2Str(Date)+' '+rs_on_when+' '+TimeToStr(Time)]);
    else
      IBMultimediaMULTI_INFOS.AsString:=fs_RemplaceMsg(rs_Document_Recorded_on_date,[fs_Date2Str(Date)+' '+rs_on_when+' '+TimeToStr(Time)]);
  end;
end;

procedure TFBiblioMultimedia.btnDelClick(Sender:TObject);
begin
  application.ProcessMessages;

  if MyMessageDlg( fs_RemplaceMsg(rs_Confirm_deleting_this_media_with_links_deleting,
   [IBMultimediaMULTI_PATH.AsString]),mtConfirmation, [mbYes,mbNo],Self)=mrYes then
  begin
    IBMultimedia.Delete;

    btnAnnuler.Enabled:=true;
    btnAppliquer.Enabled:=true;
    MajBoutons;
  end;
end;

procedure TFBiblioMultimedia.btnPrintClick(Sender:TObject);
begin
  // Matthieu ?
//  plGrille.ReportTitle.Text:='Liste des médias du dossier : '+dm.NomDossier;
//  dxComponentPrinter1.Preview(True,nil);
end;

procedure TFBiblioMultimedia.btnWebCamClick(Sender:TObject);
var
  aFCapture_Video:TFCapture_Video;
  MS:TMemoryStream;
begin
  if not dm.ControleRepBase then
    exit;

  aFCapture_Video:=TFCapture_Video.create(self);
  try
    aFCapture_Video.ShowModal;
    if length(aFCapture_Video.sVideo)>0 then
    begin
      IBMultimedia.DisableControls;
      iType:=3;
      IBMultimedia.Insert;
      IBMultimediaMULTI_PATH.AsString:=aFCapture_Video.sVideo;
      MS:=TMemoryStream.Create;
      try
        iVideo.Picture.Graphic.SaveToStream(MS);
        MS.Position:=0;
        TBlobField(IBMultimediaMULTI_REDUITE).LoadFromStream(MS);
        TBlobField(IBMultimediaMULTI_MEDIA).Clear;
      finally
        FreeAndNil(MS);
      end;
      IBMultimedia.Post;
      IBMultimedia.EnableControls;

      btnAnnuler.Enabled:=true;
      btnAppliquer.Enabled:=true;
      MajBoutons;
    end;
  finally
    FreeAndNil(aFCapture_Video);
  end;
end;

procedure TFBiblioMultimedia.btnPhotoClick(Sender:TObject);
var
  aFCapture_Photo:TFCapture_Photo;
  sImage:string;
begin
  if not dm.ControleRepBase then
    exit;
  aFCapture_Photo:=TFCapture_Photo.create(self);
  try
    aFCapture_Photo.ShowModal;
    sImage:=aFCapture_Photo.sImage;//_TempPath+'Temp.BMP'
  finally
    FreeAndNil(aFCapture_Photo);
  end;
  if Length(sImage)>0 then
    SauveImage(sImage);
end;

procedure TFBiblioMultimedia.rgTriClick(Sender:TObject);
begin
  {
  gridListe.BeginUpdate;
  gridListe.DataController.ClearSorting(True);

  case rgTri.ItemIndex of
    0:gridListeMULTI_PATH.SortOrder:=soAscending;
    1:gridListeMULTI_DATE_MODIF.SortOrder:=soAscending;
    2:gridListeMULTI_MEMO.SortOrder:=soAscending;
  end;
  gridListe.EndUpdate;

  if rgTri.ItemIndex=1 then
    gridListe.DataController.GotoLast;}
end;

procedure TFBiblioMultimedia.btnAppliquerClick(Sender:TObject);
begin
  btnAnnuler.Enabled:=false;
  btnAppliquer.Enabled:=false;

  if IBMultimedia.State in [dsEdit,dsInsert] then
    IBMultimedia.Post;

  dm.IBTrans_Secondaire.CommitRetaining;

  Caption:=rs_Caption_Medias_library_consult;
end;

procedure TFBiblioMultimedia.btnAnnulerClick(Sender:TObject);
begin
  btnAnnuler.Enabled:=false;
  btnAppliquer.Enabled:=false;

  dm.IBTrans_Secondaire.RollbackRetaining;

  doOuvreGrilles;

  Caption:=rs_Caption_Medias_library_consult;
end;

procedure TFBiblioMultimedia.dsGridStateChange(Sender:TObject);
begin
  if IBMultimedia.State in [dsEdit,dsInsert] then
  begin
    btnAnnuler.Enabled:=true;
    btnAppliquer.Enabled:=true;
    Caption:=rs_Caption_Medias_library_has_gone_modified_waiting_validate;
  end;
end;

procedure TFBiblioMultimedia.gridListeDblClick(Sender:TObject);
begin
  if IBMultimedia.Active and not IBMultimedia.IsEmpty then
    VisualiseMedia(IBMultimediaMULTI_CLEF.AsInteger,dm.ReqSansCheck);
end;

procedure TFBiblioMultimedia.gridListeMULTI_PATHDrawColumnCell(Sender: TObject;
  ACanvas: TCanvas; AViewInfo: Longint; var ADone: Boolean);
begin

end;

procedure TFBiblioMultimedia.btnScannerClick(Sender:TObject);
var
  SourceIndex:Integer;
begin
  if BloqueBtn then exit;
  if not dm.ControleRepBase then exit;
  BloqueBtn:=true;
  { Matthieu : Plus tard
  if DelphiTwain1.LibraryLoaded then
    DelphiTwain1.UnloadLibrary;
  if DelphiTwain1.LoadLibrary then
  begin
    DelphiTwain1.LoadSourceManager;
    Hide;//pour éviter que la fiche de sélection ne passe derrière
    SourceIndex:=DelphiTwain1.SelectSource;
    Show;
    if SourceIndex<>-1 then
    begin
      SourceT:=DelphiTwain1.Source[SourceIndex];
      SourceT.Modal:=true;
      SourceT.TransferMode:=ttmNative;
      SourceT.Loaded:=True;
      SourceT.Enabled:=true;
    end
    else
    begin
      DelphiTwain1.UnloadLibrary;
      MyMessageDlg(rs_Info_Scan_Cancelled,mtInformation, [mbOK],Self);
    end;
  end
  else
    MyMessageDlg(rs_Error_Cannot_scan_No_source,mtInformation, [mbOK],Self);}
  BloqueBtn:=false;
end;

procedure TFBiblioMultimedia.DelphiTwain1TwainAcquire(Sender:TObject;
  const Index:Integer;Image:TBitmap;var Cancel:Boolean);
begin
  Image.SaveToFile(_TempPath+'TEMP.bmp');//Ecris l'image sur disque

  Image.Assign(nil);
  {
  if SourceT.PendingXfers>1 then
    Cancel:=True;//On veut uniquement une image}
  Application.ProcessMessages;//Permet l'affichage au 1er plan de la suite
end;

procedure TFBiblioMultimedia.DelphiTwain1SourceDisable(Sender:TObject;
  const Index:Integer);
begin
 {
  if DelphiTwain1.LibraryLoaded then
    DelphiTwain1.UnloadLibrary;//forçage de déchargement de la librairie}
  if FileExistsUTF8(_TempPath+'TEMP.bmp') { *Converted from FileExistsUTF8*  } then
    SauveImage(_TempPath+'TEMP.bmp')
  else
    MyMessageDlg(rs_Info_Scan_Cancelled_from_source,mtInformation, [mbOK],Self);
end;

procedure TFBiblioMultimedia.DelphiTwain1AcquireCancel(Sender:TObject;
  const Index:Integer);
begin
//  SourceT.DisableSource;
end;

procedure TFBiblioMultimedia.DelphiTwain1AcquireError(Sender:TObject;
  const Index:Integer;ErrorCode,Additional:Integer);
begin
///  SourceT.DisableSource;
end;

procedure TFBiblioMultimedia.SauveImage(sImage:string);
var
  s:string;
  MS,MS2:TMemoryStream;

  function SauveStream:string;
  var
    NomFich:string;
    FS:TFileStreamUTF8;
  begin
    SavePictureDialog1.InitialDir:=gci_context.PathImages;
    if SavePictureDialog1.Execute then
    begin
      NomFich:=SavePictureDialog1.Filename;
      try
        MS.Seek(0,soFromBeginning);
        FS:=TFileStreamUTF8.Create(NomFich,fmCreate);
        FS.Seek(0,soFromBeginning);
        FS.CopyFrom(MS,MS.Size);
        FS.Free;
        Result:=NomFich;
      except
        Result:='';
      end;
    end
    else
      Result:='';
  end;

begin
  MS:=TMemoryStream.Create;
  MS2:=TMemoryStream.Create;
  try
    if ComprImageInMS(sImage,MS,MS2,true,8192,8192) then
    begin
      s:=SauveStream;//pour conserver une copie en jpeg originale
      if s>'' then
      begin
        IBMultimedia.DisableControls;
        iType:=0;
        IBMultimedia.Insert;
        IBMultimediaMULTI_PATH.AsString:=s;
        if ComprImageInMS(sImage,MS,MS2,true,140,120,gci_context.ImagesDansBase) then
        begin
          TBlobField(IBMultimediaMULTI_REDUITE).LoadFromStream(MS);
          if MS2.Size>0 then
          begin
            TBlobField(IBMultimediaMULTI_MEDIA).LoadFromStream(MS2);
            IBMultimediaMULTI_IMAGE_RTF.AsInteger:=0;
          end
          else
            IBMultimediaMULTI_IMAGE_RTF.AsInteger:=1;
        end;
        IBMultimedia.Post;
        IBMultimedia.EnableControls;
        btnAnnuler.Enabled:=true;
        btnAppliquer.Enabled:=true;
        MajBoutons;
      end;
    end;
  finally
    MS.Free;
    MS2.Free;
  end;
  DeleteFileUTF8(sImage); { *Converted from DeleteFileUTF8*  }
end;

procedure TFBiblioMultimedia.gridListeEditKeyDown(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit;var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  {
  if AItem=gridListeMULTI_MEMO then
  begin
    s:=(aEdit as TMemo).Text;
    k:=(aEdit as TMemo).SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      if not(IBMultimedia.State in [dsEdit,dsInsert]) then
        IBMultimedia.Edit;
      IBMultimediaMULTI_MEMO.AsString:=s;
      (aEdit as TMemo).SelStart:=k;
      BloqueCar:=true;
    end;
  end;
  if (Key=VK_DELETE)and(Shift= [ssCtrl]) then
  begin
    Key:=VK_SHIFT;
    btnDelClick(Sender);
  end;}
end;

procedure TFBiblioMultimedia.gridListeMULTI_INFOSDrawColumnCell(
  Sender: TObject; ACanvas: TCanvas; AViewInfo: Longint; var ADone: Boolean);
begin

end;

procedure TFBiblioMultimedia.doOuvreGrilles;
begin
  IBMultimedia.DisableControls;
  IBMultimedia.Close;
  IBMultimedia.Open;
//  IBMultimedia.Last;
  IBMultimedia.EnableControls;
  MajBoutons;
  rgTriClick(Self);
  GridListe.SetFocus;
end;

procedure TFBiblioMultimedia.mChangeImageClick(Sender:TObject);
begin
  if not dm.ControleRepBase then exit;
  bChangeImage:=true;
  if FichEstImage(IBMultimediaMULTI_PATH.AsString) then
    btnAddImageClick(Sender)
  else
    btnAddSonClick(Sender);
end;

procedure TFBiblioMultimedia.mExportImageClick(Sender:TObject);
begin
  SaveDialog.InitialDir:=gci_context.PathImages;
  SaveDialog.FileName:=ExtractFileName(IBMultimediaMULTI_PATH.AsString);

  if SaveDialog.Execute then
  begin
    TBlobField(IBMultimediaMULTI_MEDIA).SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TFBiblioMultimedia.mEditImageClick(Sender:TObject);
begin
  ImprimeImage(IBMultimediaMULTI_CLEF.AsInteger,'');
end;

procedure TFBiblioMultimedia.PopupMenu1Popup(Sender:TObject);
begin
  mEditImage.Enabled:=TBlobField(IBMultimediaMULTI_MEDIA).BlobSize>0;
  mExportImage.Enabled:=TBlobField(IBMultimediaMULTI_MEDIA).BlobSize>0;
  mToutRecharger.Visible:=not btnSelection.Visible;
end;

procedure TFBiblioMultimedia.GarderenmmoireClick(Sender:TObject);
var
  bdr:TIniFile;
begin
  Garderenmmoire.Checked:=not Garderenmmoire.Checked;
  bdr:=f_GetMemIniFile();
  try
   bdr.WriteBool('Appli','GardeEnMemoire',Garderenmmoire.Checked);
  finally
  end;
end;

procedure TFBiblioMultimedia.PopupMenuMemoirePopup(Sender:TObject);
var
  bdr:TIniFile;
begin
  bdr:=f_GetMemIniFile();
  try
    Garderenmmoire.Checked:=bdr.ReadBool('Appli','GardeEnMemoire',False);
  finally
  end;
end;

procedure TFBiblioMultimedia.MajBoutons;
begin
  btnSelection.Enabled:=not IBMultimedia.IsEmpty;
  btnDel.Enabled:=btnSelection.Enabled;
  btnPrint.Visible:=btnSelection.Enabled;
  if gci_context.ImagesDansBase then
    lImagesDansBase.Caption:=rs_Caption_One_copy_will_be_added_into_database_loading_itself
  else
    lImagesDansBase.Caption:=rs_Caption_None_copy_will_be_added_into_database;
end;

procedure TFBiblioMultimedia.btnCheminClick(Sender:TObject);
var
  aFPathMedias:TFPathMedias;
begin
  if not dm.ControleRepBase then exit;
  aFPathMedias:=TFPathMedias.Create(self);
  try
    CentreLaFiche(afPathMedias,self,0,0);
    aFPathMedias.ShowModal;
  finally
    FreeAndNil(aFPathMedias);
  end;
  screen.Cursor:=crSQLWait;
  IBMultimedia.DisableControls;
  IBMultimedia.close;
  IBMultimedia.Open;
  IBMultimedia.EnableControls;
  screen.Cursor:=crDefault;
end;

procedure TFBiblioMultimedia.mRechargerImageClick(Sender:TObject);
begin
  if MyMessageDlg(rs_Confirm_Pictures_reload_option_do_you_reload_with_this_mode
    ,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
  begin
    RechargeTout(true);
  end;
end;

procedure TFBiblioMultimedia.mRechargerFichierClick(Sender:TObject);
begin
  if MyMessageDlg(rs_Confirm_Documents_reload_option_do_you_reload_with_this_mode
    ,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
  begin
    RechargeTout(false);
  end;
end;

procedure TFBiblioMultimedia.gridListeMULTI_REDUITEDrawColumnCell(
  Sender: TObject; ACanvas: TCanvas; AViewInfo: Longint; var ADone: Boolean);
begin

end;

procedure TFBiblioMultimedia.RechargeTout(ModeImage:boolean);
var
  t:TIBTable;
  NomFich,NomFichErreurs:string;
  MS,MS2:TMemoryStream;
  fOccupe:TFWorking;
  FichErreurs:THandle;
  bErreur:boolean;
  q:TIBSQL;
begin
  if Assigned(FMain.aFIndividu) then
    if not FMain.aFIndividu.VerifyCanCloseFiche then
      exit;
  if Assigned(FMain.aFUtilisationMedia) then
    FMain.aFUtilisationMedia.Close;
  if IBMultimedia.State in [dsInsert,dsEdit] then
    IBMultimedia.Post;
  dm.IBTrans_Secondaire.CommitRetaining;//si modifications en cours
  btnAnnuler.Enabled:=false;
  btnAppliquer.Enabled:=false;
  fOccupe:=TFWorking.create(self);
  CentreLaFiche(fOccupe,Self);
  fOccupe.doInit(rs_Wait_Updating_medias);
  Cursor:=crSQLWait;
  NomFichErreurs:=_TempPath+rs_Log_Errors_Filename+'Medias.txt';
  FichErreurs:=FileCreateUTF8(NomFichErreurs);
  FileWriteln(FichErreurs,fs_RemplaceMsg(rs_Log_Medias_Errors_File_import,[NomFichErreurs,fs_DateTime2Str(Now)]));
  FileWriteln(FichErreurs,rs_Log_Medias_Errors_File_Infos);
  FileWriteln(FichErreurs);
  bErreur:=false;

  q:=TIBSQL.Create(self);
  try
    q.Database:=dm.ibd_BASE;
    q.Transaction:=dm.IBTrans_Courte;
    if ModeImage then
    begin
      gci_context.ImagesDansBase:=true;
      q.SQL.Add('update dossier set ds_indicateurs=bin_or(ds_indicateurs,1)');
    end
    else
    begin
      gci_context.ImagesDansBase:=false;
      q.SQL.Add('update dossier set ds_indicateurs=bin_and(ds_indicateurs,65536*65536-2)');
    end;
    q.SQL.Add('where cle_dossier='+IntToStr(dm.NumDossier));
    dm.IBTrans_Courte.StartTransaction;
    q.ExecQuery;
  finally
    q.Free;
    dm.IBTrans_Courte.Commit;
  end;
  MajBoutons;//met à jour lImagesDansBase

  t:=TIBTable.Create(self);
  MS:=TMemoryStream.Create;
  MS2:=TMemoryStream.Create;
  try
    t.Database:=dm.ibd_BASE;
    t.Transaction:=dm.IBTrans_Secondaire;
    t.TableName:='MULTIMEDIA';
    t.Filter:='MULTI_DOSSIER='+IntToStr(dm.NumDossier);
    t.Filtered:=true;
    t.Open;
    t.First;
    while not t.Eof do
    with t do
    begin
      NomFich:=FieldByName('multi_path').AsString;
      if FileExistsUTF8(NomFich) { *Converted from FileExistsUTF8*  } then
      begin
        try
          t.Edit;
          MS.Clear;
          if FichEstSon(NomFich) then
            iSons.Picture.Graphic.SaveToStream(MS)
          else if FichEstVideo(NomFich) then
            iVideo.Picture.Graphic.SaveToStream(MS)
          else if FichEstImage(NomFich) then
          begin
            if ComprImageInMS(NomFich,MS,MS2,true,140,120,ModeImage,1024,1024) then
            begin
              if ModeImage then
              begin
                TBlobField(FieldByName('multi_media')).LoadFromStream(MS2);
                FieldByName('multi_image_rtf').AsInteger:=0;
              end
              else
              begin
                TBlobField(FieldByName('multi_media')).Clear;
                FieldByName('multi_image_rtf').AsInteger:=1;
              end;
            end
            else
            begin
              bErreur:=true;
              FileWriteln(FichErreurs,fs_RemplaceMsg(rs_Log_File_Bad_picture_format,[NomFich]));
            end;
          end
          else
            iAutre.Picture.Graphic.SaveToStream(MS);
          if MS.Size>0 then
            TBlobField(FieldByName('multi_reduite')).LoadFromStream(MS);
        except
            //erreur enregistrement bloqué
          bErreur:=true;
          FileWriteln(FichErreurs,fs_RemplaceMsg(rs_Log_File_cannot_read,[NomFich]));
        end;
      end//de FileExistsUTF8(NomFich)
      else
      begin
        bErreur:=true;
        FileWriteln(FichErreurs,fs_RemplaceMsg(rs_Log_File_not_modified_record,[NomFich]));
      end;
      t.Next;
    end;
    dm.IBTrans_Secondaire.CommitRetaining;
    doOuvreGrilles;
  finally
    MS.Free;
    MS2.Free;
    t.Free;
    FileClose(FichErreurs);
    FreeAndNil(fOccupe);
    Cursor:=crDefault;
  end;
  if bErreur then
    p_OpenFileOrDirectory(NomFichErreurs)
//    ShellExecute(0,nil,PChar(NomFichErreurs),nil,nil,SW_SHOWDEFAULT)
  else
    DeleteFileUTF8(NomFichErreurs); { *Converted from DeleteFileUTF8*  }
end;

procedure TFBiblioMultimedia.gridListeMouseEnter(Sender:TObject);
begin
//  dm.ControleurHint.HintStyle.Standard:=true;
end;

procedure TFBiblioMultimedia.gridListeMouseLeave(Sender:TObject);
begin
//  dm.ControleurHint.HintStyle.Standard:=false;
end;

procedure TFBiblioMultimedia.FormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  {
  if DelphiTwain1.LibraryLoaded then
    DelphiTwain1.UnloadLibrary;}
  if btnAppliquer.Enabled then
    btnAppliquerClick(Sender);
end;

procedure TFBiblioMultimedia.gridListeEditKeyPress(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit;var Key:Char);
begin
  if BloqueCar then
  begin
    BloqueCar:=false;
    Key:=#0;
  end;
end;

procedure TFBiblioMultimedia.IBMultimediaCalcFields(DataSet:TDataSet);
begin
  if (IBMultimediaMULTI_IMAGE_RTF.AsInteger=1)
    and not FichEstImage(IBMultimediaMULTI_PATH.AsString) then
    IBMultimediaMULTI_AUTRE.AsInteger:=1
  else
    IBMultimediaMULTI_AUTRE.AsInteger:=0;
end;

procedure TFBiblioMultimedia.Label18Click(Sender:TObject);
begin
  MyMessageDlg(rs_Info_Medias_library
    ,mtInformation, [mbOK],self);
end;

procedure TFBiblioMultimedia.cbToutChargerClick(Sender:TObject);
var
  bdr:TIniFile;
begin
  if not PremiereFois then
  begin
    bdr:=f_GetMemIniFile;
    try
      bdr.WriteBool('Appli','ToutCharger',cbToutCharger.Checked);
    finally
    end;
    ChangeRequete;
  end;
end;

procedure TFBiblioMultimedia.ChangeRequete;
var
  SQLSuite:string;
begin
  screen.Cursor:=crSQLWait;
  IBMultimedia.DisableControls;
  IBMultimedia.close;
  SQLSuite:='m.multi_clef'
    +',m.multi_infos'
    +',cast(null as blob) as multi_media'
    +',m.multi_dossier'
    +',m.multi_date_modif'
    +',m.multi_memo';
  if gci_context.OngletMultimediaReseau or not cbToutCharger.Checked then
  if (gci_context.OngletMultimediaReseau or not cbToutCharger.Checked)and cbMiniatures.Checked then
  begin
    SQLSuite:=SQLSuite+',m.multi_reduite';
//    gridListe.Bands[0].Visible:=True;
  end
  else
  begin
     SQLSuite:=SQLSuite+',cast(null as blob) as multi_reduite';
//    gridListe.Bands[0].Visible:=False;
  end;
  SQLSuite:=SQLSuite+',m.multi_image_rtf'
    +',m.multi_path '
    +',m.multi_nom '
    +',(select first(1) 1 from media_pointeurs where mp_media=m.multi_clef) as multi_affecte'
    +',(select 1 from rdb$database where exists(select 0 from media_pointeurs'
    +' where mp_media=m.multi_clef and mp_table=''I'' and mp_type_image=''A'')'
    +' or exists (select 0 from media_pointeurs p'
    +' inner join sources_record s on s.id=p.mp_pointe_sur and s.type_table=''I'''
    +' where p.mp_media=m.multi_clef and p.mp_table=''F'' and p.mp_type_image=''F'')) as multi_evenements'
    +',(select 1 from rdb$database where exists(select 0 from media_pointeurs'
    +' where mp_media=m.multi_clef and mp_table=''F'' and mp_type_image=''A'')'
    +'or exists(select 0 from media_pointeurs p'
    +' inner join sources_record s on s.id=p.mp_pointe_sur and s.type_table=''F'''
    +' where p.mp_media=m.multi_clef and p.mp_table=''F'' and p.mp_type_image=''F'')) as multi_unions '
    +'from multimedia m where m.multi_dossier=:dossier';
  if cbToutCharger.Checked then
  begin
    IBMultimedia.SQL.Text:='select '+SQLSuite;
    cbToutCharger.Hint:=rs_Hint_Every_recorded_medias_are_loaded_in_library;
  end
  else
  begin
    IBMultimedia.SQL.Text:='select skip(maxvalue(0,(select count(*)-20 from multimedia where multi_dossier=:dossier))) '
      +SQLSuite+' order by m.multi_date_modif';
    cbToutCharger.Hint:=rs_Hint_Only_50_first_recorded_medias_are_loaded_in_library;
  end;
  IBMultimedia.Params[0].AsInteger:=dm.NumDossier;
  IBMultimedia.Open;
  IBMultimedia.EnableControls;
  if not PremiereFois then //fait par FormShow
  begin
    MajBoutons;
    rgTriClick(Self);
    GridListe.SetFocus;
  end;
  screen.Cursor:=crDefault;
end;

procedure TFBiblioMultimedia.mRafraichirClick(Sender:TObject);
begin
  ChangeRequete;
end;

procedure TFBiblioMultimedia.FormActivate(Sender:TObject);
begin
  BringToFront;//pour toujours ramener la fenêtre au premier plan
end;

function TFBiblioMultimedia.MediaCharge(var Fichier:string):Integer;
var
  Curseur:TCursor;
begin
  Curseur:=Screen.Cursor;
  Screen.Cursor:=crSQLWait;
  with qMediaCharge do
  begin
    Close;
    ParamByName('dossier').AsInteger:=dm.NumDossier;
    ParamByName('fichier').AsString:=Fichier;
    ExecQuery;
    if EOF then
      result:=-1
    else
    begin
      result:=Fields[0].AsInteger;
      Fichier:=Fields[1].AsString;
    end;
    Close;
  end;
  Screen.Cursor:=Curseur;
end;

procedure TFBiblioMultimedia.cbMiniaturesClick(Sender: TObject);
var
  bdr:TIniFile;
begin
  if not PremiereFois then
  begin
    bdr:=f_getMemIniFile;
    try
      if bdr.ReadBool('Main','W_BIBLIO_MULTIMEDIA',true) then
      begin
        bdr.WriteBool('Main','SansImages',not cbMiniatures.Checked);
      end;
    finally
    end;
  end;
end;

end.

