{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania GPL                             }
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
{ Modifications logique et affichage utilisations par André Langlet 2010}
{                                                                       }
{-----------------------------------------------------------------------}

unit u_form_individu_photos_et_docs;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  ShellAPI, Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
  U_FormAdapt, u_comp_TYLanguage, Dialogs, graphics, U_ExtDBGrid,
  MaskEdit, U_ExtImage, u_buttons_appli, DB,
  U_ExtDBImage, ExtCtrls, Menus, IBCustomDataSet, IBUpdateSQL, IBQuery,
  u_framework_dbcomponents, StdCtrls, Controls, Classes, Forms, ExtDlgs, Grids, DBGrids;

type
  TModeUpdate=(ModeMedia,ModePointeur);

  { TFIndividuPhotosEtDocs }

  TFIndividuPhotosEtDocs=class(TF_FormAdapt)
    DSMultimedia:TDataSource;
    AEdit: TFWDBMemo;
    GridListe: TExtDBGrid;
    IBMultimedia:TIBQuery;
    IBMultimediaMULTI_NOM: TIBStringField;
    IBUMultimedia:TIBUpdateSQL;
    Panel10:TPanel;
    lNom:TLabel;
    IBMultimediaMULTI_CLEF:TLongintField;
    IBMultimediaMULTI_INFOS:TIBStringField;
    IBMultimediaMULTI_MEDIA:TBlobField;
    IBMultimediaMULTI_MEMO:TMemoField;
    IBMultimediaMULTI_REDUITE:TBlobField;
    IBMultimediaMULTI_IMAGE_RTF:TLongintField;
    IBMultimediaMULTI_PATH:TIBStringField;
    IBMultimediaMP_CLEF:TLongintField;
    IBMultimediaMP_IDENTITE:TLongintField;
    IBMultimediaMP_POSITION:TLongintField;
    PmListe:TPopupMenu;
    mListe_Charger:TMenuItem;
    N1:TMenuItem;
    mListe_Enlever:TMenuItem;
    N2:TMenuItem;
    mListe_SetIdentite:TMenuItem;
    Label8:TLabel;
    mListe_Enregistrer:TMenuItem;
    Language:TYLanguage;
    btnAjout:TFWAdd;
    N3:TMenuItem;
    mListe_Imprimer:TMenuItem;
    btnDel:TFWDelete;
    DBGraphic:TExtDBImage;
    Panel2:TPanel;
    Panel1:TPanel;
    pInfos:TPanel;
    Label1:TLabel;
    mListe_Visualiser:TMenuItem;
    Panel3:TPanel;
    dxDBPathMedia:TFWDBEdit;
    LabelPath:TLabel;
    PmImage:TPopupMenu;
    mImage_Charger:TMenuItem;
    MenuItem2:TMenuItem;
    mImage_SetIdentite:TMenuItem;
    MenuItem4:TMenuItem;
    mImage_Enregistrer:TMenuItem;
    MenuItem6:TMenuItem;
    mImage_Imprimer:TMenuItem;
    mImage_Visualiser:TMenuItem;
    mImage_Enlever:TMenuItem;
    N4:TMenuItem;
    mImage_MontrerRepere:TMenuItem;
    mImage_PoserRepere:TMenuItem;
    mImage_SupprimerPosition:TMenuItem;
    N5:TMenuItem;
    mImage_QuiUtilise:TMenuItem;
    N6:TMenuItem;
    mListe_MontrerRepere:TMenuItem;
    mListe_SupprimerPosition:TMenuItem;
    N7:TMenuItem;
    mListe_QuiUtilise:TMenuItem;
    pPhoto:TPanel;
    lPoint:TImage;
    Image2: TExtImage;
    SavePictureDialog1: TSavePictureDialog;
    Splitter1: TSplitter;
    procedure btnAjoutClick(Sender:TObject);
    procedure dxDBPathMediaChange(Sender: TObject);
    procedure GridListeDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TDBGridColumns; State: TGridDrawState);
    procedure GridListeGetCellProps(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor);
    procedure GridListeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure IBMultimediaAfterScroll(DataSet:TDataSet);
    procedure mListe_SetIdentiteClick(Sender:TObject);
    procedure btnDelClick(Sender:TObject);
    procedure DSMultimediaStateChange(Sender:TObject);
    procedure mListe_EnregistrerClick(Sender:TObject);
    procedure PmListePopup(Sender:TObject);
    procedure mListe_ImprimerClick(Sender:TObject);
    procedure IBMultimediaAfterOpen(DataSet:TDataSet);
    procedure GridListeDblClick(Sender:TObject);
    procedure mListe_VisualiserClick(Sender:TObject);
    procedure Image2DblClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure cxSplitter1Moved(Sender:TObject);
    procedure PmImagePopup(Sender:TObject);
    procedure mImage_PoserRepereClick(Sender:TObject);
    procedure mImage_SupprimerPositionClick(Sender:TObject);
    procedure MontrerRepere;
    procedure mImage_MontrerRepereClick(Sender:TObject);
    procedure pPhotoResize(Sender:TObject);
    procedure mImage_QuiUtiliseClick(Sender:TObject);
    procedure GridListeEditKeyPress(Sender: TObject;
      AItem: Longint; AEdit: TCustomMaskEdit; var Key: Char);
    procedure IBMultimediaBeforeClose(DataSet: TDataSet);
    procedure IBMultimediaBeforeScroll(DataSet: TDataSet);
    procedure GridListeMULTI_MEMOPropertiesEditValueChanged(
      Sender: TObject);
  private
    bOpen:boolean;
    PointSouris:TPoint;
    BloqueCar:boolean;
    procedure doTesteReseau;
    procedure SetModeUpdate(ModeUpdate:TModeUpdate);
  public

    procedure doInitialize;
    function doOpenQuerys:boolean;
    procedure doGoto(iNumLigne:integer);
  end;

implementation

uses u_dm,
     u_form_main,
     u_form_individu,
     fonctions_dialogs,
     u_common_functions,
     u_firebird_functions,
     u_common_ancestro,
     u_genealogy_context,
     u_common_ancestro_functions,
     u_common_const,Types,Math;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

var
      fFormIndividu:TFIndividu;

procedure TFIndividuPhotosEtDocs.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  Color:=gci_context.ColorLight;
  btnAjout.Color:=gci_context.ColorLight;
  btnDel.Color:=gci_context.ColorLight;
  dxDBPathMedia.Color:=gci_context.ColorLight;

  bOpen:=false;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  pPhoto.Align:=AlClient;

  fFormIndividu:=TFIndividu(Owner);
  GridListe.Width:=gci_context.PanelMediaWidth;
  SetModeUpdate(ModeMedia);
  lPoint.Visible:=gci_context.MontrerRepere;
  BloqueCar:=false;
  lNom.PopupMenu:=FFormIndividu.pmNom;
  lNom.OnMouseEnter:=FFormIndividu.lNomMouseEnter;
  lNom.OnMouseLeave:=FFormIndividu.lNomMouseLeave;
  lNom.OnMouseMove:=FFormIndividu.lNomMouseMove;
  lNom.OnClick:=FFormIndividu.lNomClick;
end;

procedure TFIndividuPhotosEtDocs.SuperFormRefreshControls(Sender:TObject);
begin
  Image2.visible:=IBMultimedia.Active and not IBMultimedia.IsEmpty;
  DSMultimedia.AutoEdit:=not FFormIndividu.DialogMode;
end;

procedure TFIndividuPhotosEtDocs.doInitialize;
begin
  IBMultimedia.Close;
end;

function TFIndividuPhotosEtDocs.doOpenQuerys:boolean;
begin
  doTesteReseau;

  IBMultimediaAfterScroll(nil);
  result:=true;
end;

procedure TFIndividuPhotosEtDocs.IBMultimediaAfterScroll(DataSet:TDataSet);
var
  bImage:boolean;
begin
  if bOpen then
  begin
    LabelPath.Visible:=length(IBMultimediaMULTI_PATH.AsString)>0;
    bImage:=fb_GetImageFromMultimediaTable(IBMultimedia,Image2,False,False);
   { if FichEstImage(IBMultimediaMULTI_PATH.AsString) then
      try
        if FileExistsUTF8(IBMultimediaMULTI_PATH.AsString) then // *Converted from FileExistsUTF8*
          begin
            Image2.Picture.LoadFromFile(IBMultimediaMULTI_PATH.AsString);
             bImage:=true;
          end;
      except
      //format non accepté
      end;
    if not bImage then
    begin
      if TBlobField(IBMultimediaMULTI_MEDIA).BlobSize>0 then
      begin
        DBGraphic.Datafield:='MULTI_MEDIA';
        Image2.Picture.Assign(DBGraphic.Picture);
      end
      else if TBlobField(IBMultimediaMULTI_REDUITE).BlobSize>0 then
      begin
        DBGraphic.Datafield:='MULTI_REDUITE';
        Image2.Picture.Assign(DBGraphic.Picture);
      end
      else
      begin
        DBGraphic.Datafield:='';
        Image2.Picture.Assign(nil);
      end;
    end;
}
    if gci_context.MontrerRepere then
      MontrerRepere
    else
      lPoint.Visible:=false;
  end;
end;

procedure TFIndividuPhotosEtDocs.btnAjoutClick(Sender:TObject);
var
  enr:integer;
begin
  if btnAjout.Visible and btnAjout.Enabled then
  begin
    enr:=0;
    if FMain.OuvreBiblioMedias(True,FFormIndividu.QueryIndividuCLE_FICHE.AsInteger,'I','I')>0 then
    begin
      FFormIndividu.doBouton(true);
      enr:=IBMultimedia.RecNo;
    end;
    GridListe.BeginUpdate;
    IBMultimedia.DisableControls;
    IBMultimedia.Close;
    IBMultimedia.Open;
    IBMultimedia.EnableControls;
    btnDel.Enabled:=IBMultimedia.RecNo>0;
    if IBMultimedia.RecNo=enr then
      IBMultimediaAfterScroll(nil);//pour afficher le média même si le pointeur n'a pas bougé
    GridListe.EndUpdate;
  end;
end;

procedure TFIndividuPhotosEtDocs.dxDBPathMediaChange(Sender: TObject);
begin

end;

procedure TFIndividuPhotosEtDocs.GridListeDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TDBGridColumns; State: TGridDrawState);
begin

end;


procedure TFIndividuPhotosEtDocs.GridListeGetCellProps(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor);
begin
  with GridListe do
    if SelectedField = Field then
      Background:=gci_context.ColorMedium;
end;

procedure TFIndividuPhotosEtDocs.GridListeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
{  with GridListe do
  if SelectedField=IBMultimediaMULTI_MEMO then
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
  end;     }
end;

procedure TFIndividuPhotosEtDocs.DSMultimediaStateChange(Sender:TObject);
begin
  if DSMultimedia.State in [dsEdit,dsInsert] then
    FFormIndividu.doBouton(true);
end;

procedure TFIndividuPhotosEtDocs.mListe_EnregistrerClick(
  Sender:TObject);
begin
  DBGraphic.SaveToFile;
end;

procedure TFIndividuPhotosEtDocs.PmListePopup(Sender:TObject);
begin
  mListe_Charger.enabled:=btnAjout.Visible and btnAjout.Enabled;
  mListe_Enregistrer.enabled:=IBMultimedia.Active
    and(TBlobField(IBMultimediaMULTI_MEDIA).BlobSize>0);
  mListe_SetIdentite.enabled:=mListe_Charger.enabled
    and(TBlobField(IBMultimediaMULTI_REDUITE).BlobSize>0)
    and(IBMultimediamp_identite.AsInteger=0);
  mListe_Imprimer.enabled:=mListe_Enregistrer.enabled and
    (IBMultimediaMULTI_IMAGE_RTF.AsInteger=0);
  mListe_Visualiser.enabled:=IBMultimedia.Active and not IBMultimedia.IsEmpty;
  mListe_Enlever.enabled:=btnDel.Visible and btnDel.Enabled;
  mListe_Charger.Visible:=(FFormIndividu.DialogMode=false);
  mListe_SetIdentite.Visible:=(FFormIndividu.DialogMode=false);
  mListe_Enlever.Visible:=(FFormIndividu.DialogMode=false);
  mListe_MontrerRepere.Checked:=gci_context.MontrerRepere;
  mListe_SupprimerPosition.Visible:=mListe_Enlever.enabled
    and(IBMultimediamp_position.AsInteger<>0)
    and(FFormIndividu.DialogMode=false);
  mListe_QuiUtilise.Visible:=mListe_Visualiser.enabled;
end;

procedure TFIndividuPhotosEtDocs.PmImagePopup(Sender:TObject);
begin
  PointSouris:=(sender as TPopupMenu).PopupPoint;
  PmListePopup(sender);
  mImage_Charger.enabled:=mListe_Charger.enabled;
  mImage_Enregistrer.enabled:=mListe_Enregistrer.enabled;
  mImage_SetIdentite.enabled:=mListe_SetIdentite.enabled;
  mImage_Imprimer.enabled:=mListe_Imprimer.enabled;
  mImage_Visualiser.enabled:=mListe_Visualiser.enabled;
  mImage_Enlever.enabled:=mListe_Enlever.enabled;
  mImage_Charger.Visible:=mListe_Charger.Visible;
  mImage_SetIdentite.Visible:=mListe_SetIdentite.Visible;
  mImage_Enlever.Visible:=mListe_Enlever.Visible;
  mImage_MontrerRepere.Checked:=mListe_MontrerRepere.Checked;
  mImage_SupprimerPosition.Visible:=mListe_SupprimerPosition.Visible;
  mImage_QuiUtilise.Visible:=mListe_Visualiser.enabled;

  mImage_PoserRepere.Visible:=mImage_Charger.enabled
    and(FFormIndividu.DialogMode=false)
    and FichEstImage(IBMultimediaMULTI_PATH.AsString)
    and(Image2.Picture.Height>0)and(Image2.Picture.Width>0);
end;

procedure TFIndividuPhotosEtDocs.mListe_SetIdentiteClick(Sender:TObject);
var
  RecIdent:integer;
begin
  RecIdent:=IBMultimedia.RecNo;
  SetModeUpdate(ModePointeur);
  bOpen:=false;//au cas où DisableControls ne bloque pas AfterScrool
  IBMultimedia.DisableControls;
  try
    IBMultimedia.First;
    while not IBMultimedia.Eof do
    begin
      if (IBMultimediaMP_IDENTITE.AsInteger=1)and(IBMultimedia.RecNo<>RecIdent) then
      begin
        if not(IBMultimedia.State in [dsEdit]) then
          IBMultimedia.Edit;
        IBMultimediaMP_IDENTITE.AsInteger:=0;
      end
      else if (IBMultimedia.RecNo=RecIdent) then
      begin
        if not(IBMultimedia.State in [dsEdit]) then
          IBMultimedia.Edit;
        IBMultimediaMP_IDENTITE.AsInteger:=1;
      end;
      IBMultimedia.Next;
    end;
  finally
    IBMultimedia.RecNo:=RecIdent;
    IBMultimedia.EnableControls;
    bOpen:=true;
    SetModeUpdate(ModeMedia);//fait le dernier post si nécessaire
  end;

  if gci_context.Photos then //AL
  begin
    FFormIndividu.aFIndividuIdentite.idPhoto:=IBMultimediaMP_CLEF.AsInteger;
    FFormIndividu.aFIndividuIdentite.PPhoto.Visible:=true;
    FFormIndividu.aFIndividuIdentite.bIdentiteVisible:=true;
    FFormIndividu.aFIndividuIdentite.Image2.Picture:=Image2.Picture;
  end;
  FFormIndividu.doBouton(true);
end;

procedure TFIndividuPhotosEtDocs.mListe_ImprimerClick(Sender:TObject);
begin
  if IBMultimediaMULTI_IMAGE_RTF.AsInteger=0 then
    ImprimeImage(IBMultimediaMULTI_CLEF.AsInteger,'Image attachée à '+FFormIndividu.NomIndiComplet);
end;

procedure TFIndividuPhotosEtDocs.btnDelClick(Sender:TObject);
begin
  if btnDel.Visible and btnDel.Enabled then
  begin
    if MyMessageDlg(rs_Confirm_deleting_document,mtConfirmation, [mbYes,mbNo],FMain)=mrYes then
    begin
      IBMultimedia.Delete;
      FFormIndividu.doBouton(true);
      btnDel.Enabled:=IBMultimedia.RecNo>0;
    end;
  end;
end;

procedure TFIndividuPhotosEtDocs.IBMultimediaAfterOpen(DataSet:TDataSet);
begin
  bOpen:=true;
end;

procedure TFIndividuPhotosEtDocs.IBMultimediaBeforeClose(
  DataSet: TDataSet);
begin
  if dataset.State in [dsInsert,dsEdit] then
    dataset.Post;
  bOpen:=False;
end;

procedure TFIndividuPhotosEtDocs.GridListeDblClick(Sender:TObject);
begin
  if IBMultimedia.Active and not IBMultimedia.IsEmpty then
    VisualiseMedia(IBMultimediaMULTI_CLEF.AsInteger,dm.ReqSansCheck);
end;

procedure TFIndividuPhotosEtDocs.doTesteReseau;
begin
  IBMultimedia.Close;
  if gci_context.OngletMultimediaReseau then
  begin
    GridListe.PopupMenu:=PmListe;
    Image2.PopupMenu:=PmImage;
    label1.Caption:='';
    pInfos.Visible:=false;
    Panel2.Visible:=true;
    btnAjout.enabled:=true;//invisible en mode dialog
    try
      IBMultimedia.Params[0].AsInteger:=FFormIndividu.CleFiche;//Cle de l'individu
      IBMultimedia.Open;
    except
        //
    end;
    btnDel.enabled:=IBMultimedia.Active and(IBMultimedia.RecNo>0);//invisible en mode dialog
  end
  else
  begin
    GridListe.PopupMenu:=nil;
    Image2.PopupMenu:=nil;
    label1.Caption:=rs_Caption_You_have_disabled_this_sheet_in_Preferences;
    pInfos.Visible:=true;
    Panel2.Visible:=false;
    btnAjout.enabled:=false;
    btnDel.enabled:=false;
  end;
end;

procedure TFIndividuPhotosEtDocs.mListe_VisualiserClick(Sender:TObject);
begin
  if IBMultimedia.Active and not IBMultimedia.IsEmpty then
    VisualiseMedia(IBMultimediaMULTI_CLEF.AsInteger,dm.ReqSansCheck);
end;

procedure TFIndividuPhotosEtDocs.Image2DblClick(Sender:TObject);
begin
  if IBMultimedia.Active and not IBMultimedia.IsEmpty then
    VisualiseMedia(IBMultimediaMULTI_CLEF.AsInteger,dm.ReqSansCheck);
end;

procedure TFIndividuPhotosEtDocs.doGoto(iNumLigne:integer);
begin
  IBMultimedia.DisableControls;
  IBMultimedia.Locate('MP_CLEF',iNumLigne, []);
  IBMultimedia.EnableControls;
  IBMultimediaAfterScroll(IBMultimedia);
end;

procedure TFIndividuPhotosEtDocs.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBMultimedia.Close;
end;


procedure TFIndividuPhotosEtDocs.cxSplitter1Moved(Sender:TObject);
begin
  gci_context.PanelMediaWidth:=GridListe.Width;
end;

procedure TFIndividuPhotosEtDocs.SetModeUpdate(ModeUpdate:TModeUpdate);//AL
begin
  if IBMultimedia.State in [dsInsert,dsEdit] then
    IBMultimedia.Post;
  IBUMultimedia.ModifySQL.Clear;
  case ModeUpdate of
    ModeMedia:
      IBUMultimedia.ModifySQL.Add('update multimedia set multi_memo=:multi_memo where multi_clef=:multi_clef');
    ModePointeur:
      IBUMultimedia.ModifySQL.Add('update media_pointeurs'
        +' set mp_identite=:mp_identite,mp_position=:mp_position where mp_clef=:mp_clef');
  end;
end;

procedure TFIndividuPhotosEtDocs.mImage_PoserRepereClick(Sender:TObject);
var
  p:TPoint;
  r,l,h,x,y:single;
begin
  if (Image2.Picture.Height>0)and(Image2.Picture.Width>0) then
  begin
    p:=Image2.ScreenToClient(PointSouris);
    l:=Image2.Picture.Width;
    h:=Image2.Picture.Height;
    if (l>Image2.Width)or(h>Image2.Height) then
    begin
      r:=min(Image2.Width/l,Image2.Height/h);
      l:=l*r;
      h:=h*r;
    end;
    x:=p.X-(Image2.Width-l)/2;
    y:=p.Y-(Image2.Height-h)/2;
    x:=max(0,x);
    y:=max(0,y);
    x:=min(x,l);
    y:=min(y,h);
    SetModeUpdate(ModePointeur);
    try
      IBMultimedia.Edit;
      IBMultimediaMP_POSITION.AsInteger:=XYZenINT(round(x*$FFF/l),round(y*$FFF/h),0);
      IBMultimedia.Post;
    finally
      SetModeUpdate(ModeMedia);
    end;
    MontrerRepere;
  end;
end;

procedure TFIndividuPhotosEtDocs.mImage_SupprimerPositionClick(Sender:TObject);
begin
  SetModeUpdate(ModePointeur);
  try
    IBMultimedia.Edit;
    IBMultimediaMP_POSITION.AsInteger:=0;
    IBMultimedia.Post;
  finally
    SetModeUpdate(ModeMedia);
  end;
  lPoint.Visible:=false;
end;

procedure TFIndividuPhotosEtDocs.MontrerRepere;
var
  x,y,z:integer;
  r,l,h:single;
begin
  with IBMultimedia, Image2 do
  if Active and (FieldByName('MP_POSITION').AsInteger>0)and(Picture.Height>0)and(Picture.Width>0) then
  begin
    IntenXYZ(FieldByName('MP_POSITION').AsInteger,x,y,z);
    l:=Picture.Width;
    h:=Picture.Height;
    if (l>Width)or(h>Height) then
    begin
      r:=min(Width/l,Height/h);
      l:=l*r;
      h:=h*r;
    end;
    lPoint.Left:=round(x*l/$FFF+(Width-l)/2-lPoint.Width/2)+Left;
    lPoint.Top:=round(y*h/$FFF+(Height-h)/2-lPoint.Height/2)+Top;
    lPoint.Visible:=true;
  end
  else
  begin
    lPoint.Visible:=false
  end;
end;

procedure TFIndividuPhotosEtDocs.mImage_MontrerRepereClick(Sender:TObject);
begin
  gci_context.MontrerRepere:=not gci_context.MontrerRepere;
  if gci_context.MontrerRepere then
    MontrerRepere
  else
    lPoint.Visible:=false;
  gci_context.ShouldSave:=true;
end;

procedure TFIndividuPhotosEtDocs.pPhotoResize(Sender:TObject);
begin
  if gci_context.MontrerRepere then
    MontrerRepere;
end;

procedure TFIndividuPhotosEtDocs.mImage_QuiUtiliseClick(Sender:TObject);
begin
  FMain.OuvreFUtilisationMedia(IBMultimediaMULTI_CLEF.asInteger);
end;

procedure TFIndividuPhotosEtDocs.GridListeEditKeyPress(
  Sender: TObject; AItem: Longint;
  AEdit: TCustomMaskEdit; var Key: Char);
begin
  if BloqueCar then
  begin
    BloqueCar:=false;
    Key:=#0;
  end;
end;

procedure TFIndividuPhotosEtDocs.IBMultimediaBeforeScroll(
  DataSet: TDataSet);
begin
  if dataset.State=dsEdit then
    dataset.Post;
end;

procedure TFIndividuPhotosEtDocs.GridListeMULTI_MEMOPropertiesEditValueChanged(
  Sender: TObject);
begin //le Post n'est pas automatique lors du changement d'enregistrement si seul le mémo a été effacé!
  if (DSMultimedia.State=dsEdit) and ((Sender as TExtDBGrid).Columns [ 1 ].Field.IsNull) then
    IBMultimedia.Post;
end;
end.

