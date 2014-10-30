{Auteur: André Langlet 2010}

unit u_Form_Utilisation_Media;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  U_FormAdapt, U_OnFormInfoIni,Forms,SysUtils,U_ExtDBGrid,
  Dialogs,Menus,DB,
  IBCustomDataSet,IBQuery,ExtCtrls,StdCtrls,u_buttons_appli,
  Controls,Classes,Graphics,IB,
  IBUpdateSQL,contnrs,
  IBDatabase,PrintersDlgs, Grids, DBGrids;

type

  { TFUtilisationMedia }

  TFUtilisationMedia=class(TF_FormAdapt)
    btnCopier: TFWCopy;
    btnFermer: TFWClose;
    btnReinit: TFWInit;
    IBQNom:TIBQuery;
    DSNom:TDataSource;
    MemoImage: TMemo;
    OnFormInfoIni1: TOnFormInfoIni;
    PButtons: TPanel;
    Panel2: TPanel;
    pmListe:TPopupMenu;
    mFiche:TMenuItem;
    dxDBGrid1:TExtDBGrid;
    N1:TMenuItem;
    IBQNomCLE_FICHE:TLongintField;
    IBQNomSEXE:TLongintField;
    IBQNomNOM:TIBStringField;
    IBQNomNOM_COMPLET:TStringField;
    IBQNomMP_CLEF:TLongintField;
    IBQNomMP_POSITION:TLongintField;
    IBQNomSOSA:TLongintField;
    IBQNomORDRE:TLongintField;
    IBQNomMP_TABLE:TStringField;
    IBQNomMP_TYPE_IMAGE:TStringField;
    ImageMedia:TImage;
    Splitter1: TSplitter;
    SplitterV:TSplitter;
    pImage:TPanel;
    SplitterV1: TSplitter;
    SplitterV2: TSplitter;
    TransactionPropre:TIBTransaction;
    pmImage:TPopupMenu;
    pmImage_VoirMedia:TMenuItem;
    mImage_MontrerRepere:TMenuItem;
    N2:TMenuItem;
    mImage_PoserRepere:TMenuItem;
    mImage_SupprimerRepere:TMenuItem;
    IBUNom:TIBUpdateSQL;
    mListe_MontrerRepere:TMenuItem;
    mListe_SupprimerRepere:TMenuItem;
    N4:TMenuItem;
    mListe_SupprimerAffectation:TMenuItem;
    dxComponentPrinter1:TPrinterSetupDialog;
    mImprimerFiche:TMenuItem;
    N3:TMenuItem;
    PanelHaut:TPanel;

    procedure dxDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TDBGridColumns; State: TGridDrawState);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mFicheClick(Sender:TObject);
    procedure pmListePopup(Sender:TObject);
    procedure btnCopierClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure IBQNomCalcFields(DataSet:TDataSet);
    procedure dxDBGrid1DBTableView1DblClick(Sender:TObject);
    procedure dxDBGrid1MouseEnter(Sender:TObject);
    procedure dxDBGrid1MouseLeave(Sender:TObject);
    procedure MemoImagePropertiesChange(Sender:TObject);
    procedure MemoImagePropertiesExit(Sender:TObject);
    procedure pImageResize(Sender:TObject);
    procedure ColonneOrdreDrawColumnCell(Sender:TObject;
      ACanvas:TCanvas;AViewInfo:Longint;
      var ADone:Boolean);
    procedure pmImage_VoirMediaClick(Sender:TObject);
    procedure mImage_MontrerRepereClick(Sender:TObject);
    procedure mImage_PoserRepereClick(Sender:TObject);
    procedure mImage_SupprimerRepereClick(Sender:TObject);
    procedure pmImagePopup(Sender:TObject);
    procedure ImageMediaDblClick(Sender:TObject);
    procedure mListe_SupprimerAffectationClick(Sender:TObject);
    procedure btnReinitClick(Sender:TObject);
    procedure aLabelDblClick(Sender:TObject);
    procedure aLabelMouseDown(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure aLabelMouseLeave(Sender:TObject);
    procedure aLabelMouseMove(Sender:TObject;Shift:TShiftState;X,
      Y:Integer);
    procedure aLabelMouseUp(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure IBQNomAfterScroll(DataSet:TDataSet);
    procedure mImprimerFicheClick(Sender:TObject);
  private
    liClef:integer;
    LesLabels:TObjectList;
    bMemoModified:boolean;
    PointSouris:TPoint;
    PointMemo:TPoint;
    bPremierclic:boolean;
    NomFichier:string;
    procedure PoseEtiquettes;
    procedure ChangerRepere(p:TPoint;ModeCreation:boolean);
    function MajMemoImage:boolean;
  public
    procedure doInit(iClef:Integer);
  end;

implementation

uses u_dm,
     u_common_const,
     u_common_functions,
     fonctions_dialogs,
     fonctions_string,
     u_common_ancestro,
     u_form_individu_repertoire,u_genealogy_context,IBSQL,
     u_common_ancestro_functions,variants,
     Math,Types, FileUtil;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFUtilisationMedia.dxDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TDBGridColumns; State: TGridDrawState);
var
  value:Variant;
begin
  with dxDBGrid1,DataSource.DataSet do
    Begin
      Value:=FieldByName('SEXE').Value;
      if not VarIsNull(Value) then
        if Value=1 then
          Canvas.Font.Color:=gci_context.ColorHomme
        else if Value=2 then
          Canvas.Font.Color:=gci_context.ColorFemme
        else
          Canvas.Font.Color:=clWindowText;

      Value:=FieldByName('SOSA').Value;
      //on met en vert tous ceux qui ont un num sosa
      if not VarIsNull(Value) then
        if (Value>0) then
        begin
          Canvas.Font.Style:= [fsBold];
          Canvas.Font.Color:=_COLOR_SOSA;
        end;
    end;

end;


procedure TFUtilisationMedia.SuperFormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  pImage.Color:=gci_context.ColorLight;
  PanelHaut.Color:=gci_context.ColorLight;

  LesLabels:=TObjectList.Create;
  btnCopier.Caption:=rs_Caption_Set_to_other_persons;
  bMemoModified:=false;
  bPremierclic:=false;
  PointMemo:=Point(0,0);
end;


procedure TFUtilisationMedia.SuperFormShowFirstTime(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  // Matthieu ?
//  dxDBGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_UTILISATION_MEDIA',true,false, []);
  Caption:=rs_Caption_Media_s_users;
end;

procedure TFUtilisationMedia.doInit(iClef:Integer);
var
  q:TIBQuery;
  nomtemp:string;
  i:integer;
  bImage:boolean;
  MS1,MS2:TMemoryStream;
begin
  if not MajMemoImage then
  begin
    MyMessageDlg(rs_Error_document_opened_in_other_form+_CRLF
      + rs_Error_validate_other_form,mtError, [mbOK],Self);
    exit;
  end;
  liClef:=iClef;
  IBQNom.close;
  Screen.Cursor:=crSQLWait;
  try
    LesLabels.Clear;
    q:=TIBQuery.Create(self);
    q.Database:=dm.ibd_BASE;
    q.Transaction:=TransactionPropre;
    q.SQL.Add('select multi_path,multi_memo from multimedia where multi_clef='+IntToStr(iclef));
    try
      q.Open;
      MemoImage.Text:=q.Fields[1].AsString;
      NomFichier:=q.Fields[0].AsString;
      bImage:=false;
      if FichEstImage(NomFichier) then
      begin
        if FileExistsUTF8(NomFichier) { *Converted from FileExistsUTF8*  } then
        try
          ImageMedia.Picture.LoadFromFile(NomFichier);
          bImage:=true;
        except
          //format non accepté
        end;
      end;
      if (not bImage) then
      begin
        q.Close;
        q.SQL.Clear;
        q.SQL.Add('select multi_reduite,multi_media from multimedia where multi_clef='+IntToStr(iclef));
        q.Open;
        if not q.Eof then
        begin
          nomtemp:=TimeToStr(now);
          for i:=length(nomtemp)downto 1 do
            if not(nomtemp[i]in ['0'..'9']) then
              Delete(nomtemp,i,1);
          nomtemp:=_TempPath+nomtemp+'.jpg';
          try
            if TBlobField(q.Fields[1]).BlobSize>0 then
            begin
              TBlobField(q.Fields[1]).SaveToFile(nomtemp);
              bImage:=true;
            end
            else if TBlobField(q.Fields[0]).BlobSize>0 then
            begin
              TBlobField(q.Fields[0]).SaveToFile(nomtemp);
              bImage:=true;
            end;
            if bImage then
            begin
              ImageMedia.Picture.LoadFromFile(nomtemp);
              DeleteFileUTF8(nomtemp); { *Converted from DeleteFileUTF8*  }
            end
            else
              ImageMedia.Picture.Graphic:=nil;
          except
          ImageMedia.Picture:=nil;
          MS1:=TMemoryStream.Create;
          MS2:=TMemoryStream.Create;
          try
            if ComprImageInMS(NomFichier,MS1,MS2,false,0,0,True,0,0,False) then
            begin
              if MSimage2FichTemp(MS2,NomTemp) then
              begin
                ImageMedia.Picture.LoadFromFile(NomTemp);
                bImage:=true;
                DeleteFileUTF8(NomTemp);
              end;
            end;
          finally
            MS1.Free;
            MS2.Free;
          end;
          end;
        end;
      end;
      q.Close;
    finally
      q.Free;
    end;

    IBQNom.Params[0].AsInteger:=iClef;
    IBQNom.Open;
    if gci_context.MontrerRepere then
      PoseEtiquettes;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFUtilisationMedia.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  MajMemoImage;
  LesLabels.Free;
  IBQNom.Close;
  // Matthieu ?
//  dxDBGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_UTILISATION_MEDIA',true, []);
  gci_context.ShouldSave:=true;
  Action:=caFree;
  DoSendMessage(Owner,'FERME_UTILISATION_MEDIA');
end;

procedure TFUtilisationMedia.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFUtilisationMedia.mFicheClick(Sender:TObject);
begin
  if IBQNomCLE_FICHE.AsInteger>0 then
  begin
    dm.individu_clef:=IBQNomCLE_FICHE.AsInteger;
    DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
  end;
end;

procedure TFUtilisationMedia.btnCopierClick(Sender:TObject);
var
  aFIndividuRepertoire:TFIndividuRepertoire;
  q:TIBSQL;
  aLettre:string;
  i:integer;
begin
  aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
  try
    aFIndividuRepertoire.Position:=poMainFormCenter;
    aFIndividuRepertoire.NomIndi:=IBQNomNOM.AsString;
    aLettre:=copy(fs_FormatText(IBQNomNOM.AsString,mftUpper,True),1,1);
    aFIndividuRepertoire.InitIndividuPrenom(aLettre,'INDEX',0,IBQNomCLE_FICHE.AsInteger,True,True);
    aFIndividuRepertoire.Caption:=rs_Caption_Select_Persons_whose_set_the_media;

    if aFIndividuRepertoire.ShowModal=mrOk then
    begin
      if MyMessageDlg(rs_confirm_copying_media,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
      begin
        q:=TIBSQL.Create(Self);
        try
          q.Database:=dm.ibd_BASE;
          q.Transaction:=TransactionPropre;
          q.SQL.Add('insert into media_pointeurs(mp_clef'
            +',mp_media'
            +',mp_cle_individu'
            +',mp_pointe_sur'
            +',mp_table'
            +',mp_identite'
            +',mp_kle_dossier'
            +',mp_type_image)'
            +'values(gen_id(BIBLIO_POINTEURS_ID_GEN,1)'
            +',:cle_media'
            +',:cle_indi'
            +',:cle_indi'
            +',''I'''
            +',0'
            +',:dossier'
            +',''I'')');
          try
            for i:=0 to Length(aFIndividuRepertoire.L)-1 do
            begin
              q.Params[0].AsInteger:=liClef;
              q.Params[1].AsInteger:=aFIndividuRepertoire.L[i];
              q.Params[2].AsInteger:=aFIndividuRepertoire.L[i];
              q.Params[3].AsInteger:=dm.NumDossier;
              q.ExecQuery;
              q.Close;
            end;
          except
            on E:EIBError do
              showmessage(rs_Error_Cannot_copy_Media+_CRLF+E.Message);
          end;
        finally
          q.Free;
        end;
      end;
    end;
  finally
    FreeAndNil(aFIndividuRepertoire);
  end;
  doInit(liClef);
end;

procedure TFUtilisationMedia.IBQNomCalcFields(DataSet:TDataSet);
begin
  if IBQNomMP_POSITION.AsInteger>0 then
    IBQNomORDRE.AsInteger:=IBQNom.RecNo
  else
    IBQNomORDRE.Clear;
end;

procedure TFUtilisationMedia.dxDBGrid1DBTableView1DblClick(
  Sender:TObject);
begin
  mFicheClick(sender);
end;

procedure TFUtilisationMedia.ColonneOrdreDrawColumnCell(
  Sender:TObject;ACanvas:TCanvas;
  AViewInfo:Longint;var ADone:Boolean);
begin
  ACanvas.Font.Style:= [fsBold];
  ACanvas.Font.Color:=clRed;
end;

procedure TFUtilisationMedia.dxDBGrid1MouseEnter(Sender:TObject);
begin
  // Matthieu ?
  // dm.ControleurHint.HintStyle.Standard:=true;
end;

procedure TFUtilisationMedia.dxDBGrid1MouseLeave(Sender:TObject);
begin
  // Matthieu ?
  //   dm.ControleurHint.HintStyle.Standard:=false;
end;

procedure TFUtilisationMedia.PoseEtiquettes;
var
  aLabel:TLabel;
  x,y,z,ordre:integer;
  r,dh,dv,h,l:Single;
begin
  LesLabels.Clear;
  if (ImageMedia.Picture.Height>0)and(ImageMedia.Picture.Width>0) and not IBQNom.IsEmpty then
  begin
  //calculer les paramètres généraux de correction des coordonnées en fonction de l'image
    l:=ImageMedia.Picture.Width;
    h:=ImageMedia.Picture.Height;
    if (l>ImageMedia.Width)or(h>ImageMedia.Height) then
    begin
      r:=Min(ImageMedia.Width/l,ImageMedia.Height/h);
      l:=l*r;
      h:=h*r;
    end;
    dh:=(ImageMedia.Width-l)/2+ImageMedia.Left;
    dv:=(ImageMedia.Height-h)/2+ImageMedia.Top;
    IBQNom.DisableControls;
    try
      ordre:=IBQNomORDRE.AsInteger;
      IBQNom.First;
      while not IBQNom.Eof do
      begin
        if IBQNomORDRE.AsInteger>0 then
        begin
          aLabel:=TLabel.Create(self);
          aLabel.Parent:=pImage;
          aLabel.Visible:=true;
          aLabel.Transparent:=false;
          aLabel.ParentColor:=false;
          aLabel.Color:=clWhite;
          aLabel.ParentShowHint:=false;
          aLabel.Hint:=IBQNomNOM_COMPLET.AsString+'.'+_CRLF+rs_Hint_Select_a_person_with_stick;
          aLabel.ShowHint:=true;
          aLabel.Caption:=IBQNomORDRE.AsString;
          IntenXYZ(IBQNomMP_POSITION.AsInteger,x,y,z);
          aLabel.Left:=round(x*l/$FFF+dh-aLabel.Width/2);
          aLabel.Top:=round(y*h/$FFF+dv-aLabel.Height/2);
          aLabel.Cursor:=crSize;
          aLabel.OnDblClick:=aLabelDblClick;
          aLabel.OnMouseDown:=aLabelMouseDown;
          aLabel.OnMouseLeave:=aLabelMouseLeave;
          aLabel.OnMouseMove:=aLabelMouseMove;
          alabel.OnMouseUp:=aLabelMouseUp;
          LesLabels.Add(aLabel);
        end;
        IBQNom.Next;
      end;
      IBQNom.RecNo:=ordre;
    finally
      IBQNom.EnableControls;
    end;
  end;
end;

procedure TFUtilisationMedia.pImageResize(Sender:TObject);
begin
  PoseEtiquettes;
end;

procedure TFUtilisationMedia.MemoImagePropertiesChange(Sender:TObject);
begin
  if MemoImage.Modified then
    bMemoModified:=true;
end;

function TFUtilisationMedia.MajMemoImage:boolean;
var
  q:TIBSQL;
begin
  Result:=true;
  if bMemoModified then
  begin
    q:=TIBSQL.Create(self);
    try
      q.Database:=dm.ibd_BASE;
      q.Transaction:=TransactionPropre;
      TransactionPropre.Active:=true;
      q.SQL.Add('update multimedia set multi_memo=:multi_memo where multi_clef='+IntToStr(liClef));
      q.ParamByName('multi_memo').AsString:=MemoImage.Text;
      try
        q.ExecQuery;
        TransactionPropre.CommitRetaining;
        bMemoModified:=false;
      except
        TransactionPropre.RollbackRetaining;
        Result:=false;
      end;
    finally
      q.Free;
    end;
  end;
end;

procedure TFUtilisationMedia.MemoImagePropertiesExit(Sender:TObject);
begin
  if not MajMemoImage then
  begin
    MyMessageDlg(rs_Error_document_opened_in_other_form+_CRLF
      +rs_Error_validate_other_form, mtError, [mbOK],Self);
    Abort;
    bMemoModified:=false;
    doInit(liClef);
  end;
end;

procedure TFUtilisationMedia.pmImage_VoirMediaClick(Sender:TObject);
begin
  VisualiseMedia(liClef,dm.ReqSansCheck);
end;

procedure TFUtilisationMedia.mImage_MontrerRepereClick(Sender:TObject);
begin
  gci_context.MontrerRepere:=not gci_context.MontrerRepere;
  if gci_context.MontrerRepere then
    PoseEtiquettes
  else
    LesLabels.Clear;
  gci_context.ShouldSave:=true;
end;

procedure TFUtilisationMedia.mImage_PoserRepereClick(Sender:TObject);
begin
  ChangerRepere(PointSouris,true);
end;

procedure TFUtilisationMedia.mImage_SupprimerRepereClick(Sender:TObject);
begin
  try
    IBQNom.Edit;
    IBQNomMP_POSITION.AsInteger:=XYZenINT(0,0,0);
    IBQNom.Post;
    TransactionPropre.CommitRetaining;
    if gci_context.MontrerRepere then
      PoseEtiquettes;
  except
    MyMessageDlg(rs_Error_person_opened_in_other_form+_CRLF
      +rs_Error_validate_other_form,mtError, [mbOK],Self);
    TransactionPropre.RollbackRetaining;
  end;
end;

procedure TFUtilisationMedia.pmImagePopup(Sender:TObject);
begin
  PointSouris:=(sender as TPopupMenu).PopupPoint;
  mImage_PoserRepere.Visible:=(IBQNom.RecNo>0) and (ImageMedia.Picture.Height>0) and (ImageMedia.Picture.Width>0);
  mImage_SupprimerRepere.Visible:=mImage_PoserRepere.Visible and(IBQNomMP_POSITION.AsInteger>0);
  mImage_MontrerRepere.Checked:=gci_context.MontrerRepere;
end;

procedure TFUtilisationMedia.pmListePopup(Sender:TObject);
begin
  mFiche.Enabled:=IBQNom.RecNo>0;
  mListe_SupprimerRepere.Visible:=(IBQNom.RecNo>0)and(IBQNomMP_POSITION.AsInteger>0);
  mListe_SupprimerAffectation.Visible:=(IBQNom.RecNo>0)and(IBQNomMP_TABLE.AsString='I')
    and(IBQNomMP_TYPE_IMAGE.AsString='I');
  mListe_MontrerRepere.Checked:=gci_context.MontrerRepere;
end;

procedure TFUtilisationMedia.ImageMediaDblClick(Sender:TObject);
begin
  VisualiseMedia(liClef,dm.ReqSansCheck);
end;

procedure TFUtilisationMedia.mListe_SupprimerAffectationClick(
  Sender:TObject);
begin
  if MyMessageDlg(rs_link_from_person_to_document_will_be_erased+_CRLF+_CRLF
    +rs_confirm_this_deleting,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
  begin
    try
      IBQNom.Delete;
      TransactionPropre.CommitRetaining;
      bMemoModified:=false;
      doInit(liClef);
    except
      MyMessageDlg(rs_Error_person_opened_in_other_form+_CRLF
        +rs_Error_validate_other_form,mtError, [mbOK],Self);
      TransactionPropre.RollbackRetaining;
    end;
  end;
end;

procedure TFUtilisationMedia.btnReinitClick(Sender:TObject);
begin
  bMemoModified:=false;
  doInit(liClef);
end;

procedure TFUtilisationMedia.aLabelDblClick(Sender:TObject);
begin
  mFicheClick(sender);
end;

procedure TFUtilisationMedia.aLabelMouseDown(Sender:TObject;
  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  if not bPremierclic then
    IBQNom.RecNo:=StrToInt((sender as Tlabel).Caption);
  bPremierclic:=true;
  PointMemo:=Mouse.CursorPos;
end;

procedure TFUtilisationMedia.aLabelMouseLeave(Sender:TObject);
begin
  bPremierclic:=false;
end;

procedure TFUtilisationMedia.aLabelMouseMove(Sender:TObject;
  Shift:TShiftState;X,Y:Integer);
begin
  if (PointMemo.X<>0)and(PointMemo.Y<>0) then
  begin
    PointSouris:=Mouse.CursorPos;
    (sender as TLabel).Left:=(sender as TLabel).Left+PointSouris.X-PointMemo.X;
    (sender as TLabel).Top:=(sender as TLabel).Top+PointSouris.Y-PointMemo.Y;
    PointMemo:=PointSouris;
  end;
end;

procedure TFUtilisationMedia.aLabelMouseUp(Sender:TObject;
  Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
var
  p:TPoint;
begin
  PointMemo:=Point(0,0);
  p:=pImage.ClientToScreen(Point((sender as TLabel).Left+(sender as TLabel).Width div 2
    ,(sender as TLabel).Top+(sender as TLabel).Height div 2));
  ChangerRepere(p,false);
end;

procedure TFUtilisationMedia.ChangerRepere(p:TPoint;ModeCreation:boolean);
var
  r,l,h,x,y:single;
  position:integer;
begin
  if (ImageMedia.Picture.Height>0)and(ImageMedia.Picture.Width>0) then
  begin
    p:=ImageMedia.ScreenToClient(p);
    l:=ImageMedia.Picture.Width;
    h:=ImageMedia.Picture.Height;
    if (l>ImageMedia.Width)or(h>ImageMedia.Height) then
    begin
      r:=min(ImageMedia.Width/l,ImageMedia.Height/h);
      l:=l*r;
      h:=h*r;
    end;
    x:=p.X-(ImageMedia.Width-l)/2;
    y:=p.Y-(ImageMedia.Height-h)/2;
    x:=max(0,x);
    y:=max(0,y);
    x:=min(x,l);
    y:=min(y,h);
    position:=XYZenINT(round(x*$FFF/l),round(y*$FFF/h),0);
    if IBQNomMP_POSITION.AsInteger<>position then
    begin
      try
        IBQNom.Edit;
        IBQNomMP_POSITION.AsInteger:=position;
        IBQNom.Post;
        TransactionPropre.CommitRetaining;
        if ModeCreation then
          PoseEtiquettes;
      except
        MyMessageDlg(rs_Error_person_opened_in_other_form+_CRLF
          +rs_Error_validate_other_form,mtError, [mbOK],Self);
        TransactionPropre.RollbackRetaining;
      end;
    end;
  end;
end;

procedure TFUtilisationMedia.IBQNomAfterScroll(DataSet:TDataSet);
var
  i:integer;
begin
  if gci_context.MontrerRepere then
  begin
    if (IBQNomMP_POSITION.AsInteger>0) then
    begin
      for i:=0 to LesLabels.Count-1 do
        if (LesLabels.Items[i]as TLabel).Caption=IBQNomORDRE.AsString then
          (LesLabels.Items[i]as TLabel).Color:=gci_context.ColorMedium
        else
          (LesLabels.Items[i]as TLabel).Color:=clWhite;
    end
    else
    begin
      for i:=0 to LesLabels.Count-1 do
        (LesLabels.Items[i]as TLabel).Color:=clWhite;
    end;
  end;
end;

procedure TFUtilisationMedia.mImprimerFicheClick(Sender:TObject);
var
  i,k,l:integer;
begin
  btnFermer.Visible:=false;
  btnCopier.Visible:=false;
  btnReinit.Visible:=false;
  l:=MemoImage.Width;
  k:=-1;
  for i:=0 to LesLabels.Count-1 do
  begin
    if (LesLabels[i]as TLabel).Color=gci_context.ColorMedium then
    begin
      k:=i;
      (LesLabels[i]as TLabel).Color:=clWhite;
      Break;
    end;
  end;
  {
  // Matthieu
  dxComponentPrinter1.CurrentLink:=dxComponentPrinter1Link1;
  dxComponentPrinter1Link1.PrinterPage.Orientation:=poLandscape;
  dxComponentPrinter1Link1.PrinterPage.PageHeader.CenterTitle.Clear;
  dxComponentPrinter1Link1.PrinterPage.PageHeader.CenterTitle.Add('Utilisation de '+NomFichier);
  dxComponentPrinter1.Preview;}
  MemoImage.Width:=l;
  btnFermer.Visible:=true;
  btnCopier.Visible:=true;
  btnReinit.Visible:=true;
  if k>-1 then
    (LesLabels[k]as TLabel).Color:=gci_context.ColorMedium;
end;


end.

