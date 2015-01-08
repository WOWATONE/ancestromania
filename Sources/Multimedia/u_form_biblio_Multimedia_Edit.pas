unit u_form_biblio_Multimedia_Edit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  ShellApi, jpeg, TXRB, ppParameter, ppTypes, ppProd,
  ppRelatv, ppComm, ppCache, ppClass, ppPrnabl, ppCtrls, ppBands, ppVar,
  raCodMod, ppModule, ppDBPipe, ppDBJIT, TXComp, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Dialogs,DB,IBQuery,RLPreview,
  RLReport,u_comp_TYLanguage,StdCtrls,ExtJvXPCheckCtrls,
  u_buttons_flat,ExtCtrls,Controls,Forms,
  Classes,u_objet_TState,u_buttons_appli;

type

  TFBiblio_Multimedia_Edit=class(TF_FormAdapt)
    Language:TYLanguage;
    panDock:TPanel;
    ScrollBox:TScrollBox;
    Panel6:TPanel;
    Panel7:TPanel;
    Panel5:TPanel;
    Label2:TLabel;
    Bevel2:TBevel;
    Label3:TLabel;
    btnPrint:TFWPrint;
    rvPrinter:TJvXPCheckBox;
    rbPDF:TJvXPCheckBox;
    rbRTF:TJvXPCheckBox;
    rbHtml:TJvXPCheckBox;
    spbPreviewWhole:TCSpeedButton;
    spbPreviewWidth:TCSpeedButton;
    spbPreview100Percent:TCSpeedButton;
    ppReport:TRLReport;
//    ppDBImage:TppDBPipeline;
    DSImage:TDataSource;
    QImage:TIBQuery;
    ppViewer:TRLPreview;
//    ppJITPVariable:TppJITPipeline;
//    S_TITRE:TppField;
//    B_STRETCH:TppField;
    cbStretch:TCheckBox;
    Bevel1:TBevel;
    SaveDialogRTF:TSaveDialog;
    SaveDialogPDF:TSaveDialog;
    SaveDialogHTML:TSaveDialog;
//    I_HEIGHT:TppField;
//    I_WIDTH:TppField;
    cbLandScape:TCheckBox;
//    I_MODE:TppField;
//    ppParameterList1:TppParameterList;
    ppHeaderBand1:TRLBand;
    ppLabel1:TRLLabel;
//    ppLine1:TppLine;          h//
    ppDetailBand1:TRLSubDetail;
    dbImage:TRLDBImage;
    ppFooterBand1:TRLBand;
//    ppLine2:TppLine;
    ppLabel2:TRLLabel;
//    ppVariable1:TppVariable;
//    raCodeModule1:TraCodeModule;
{$IFNDEF FPC}
    QImageMULTI_MEDIA:TBlobField;
    QImageMULTI_PATH:TStringField;
{$ENDIF}

    procedure SuperFormCreate(Sender:TObject);
    procedure bfsbFermerClick(Sender:TObject);
    function ppJITPVariableGetFieldValue(aFieldName:string):Variant;
    procedure cbStretchClick(Sender:TObject);
    procedure spbPreviewWholeClick(Sender:TObject);
    procedure spbPreviewWidthClick(Sender:TObject);
    procedure spbPreview100PercentClick(Sender:TObject);
    procedure rvPrinterChange(Sender:TObject);
    procedure SuperFormDestroy(Sender:TObject);
    procedure rbPDFChange(Sender:TObject);
    procedure rbRTFChange(Sender:TObject);
    procedure rbHtmlChange(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure cbLandScapeClick(Sender:TObject);
    procedure MajImpression;

  private
    FirstActivation:Boolean;
    fFill:TState;
    s_Nom:string;
    i_Clef:Integer;
  public
    procedure doInitialise(IClef:Integer;Titre:string);
  end;

implementation

uses u_common_functions,u_common_const,
     u_genealogy_context,
     fonctions_images,
     {$IFNDEF IMAGING}
       bgrabitmap,
     {$ELSE}
       ImagingTypes,
       Imaging,
     {$ENDIF}
     FileUtil;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFBiblio_Multimedia_Edit.SuperFormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  fFill:=TState.create(false);
  FirstActivation:=True;
end;

procedure TFBiblio_Multimedia_Edit.bfsbFermerClick(Sender:TObject);
begin
  Close
end;

procedure TFBiblio_Multimedia_Edit.doInitialise(IClef:Integer;Titre:string);
var
  MS:TMemoryStream;
  J1:{$IFNDEF IMAGING}TBGRABitmap{$ELSE}TImageData{$ENDIF};
  bImage:boolean;
  PathImage:string;
begin
  Screen.Cursor:=crHourGlass;
  with QImage do
  try
    i_Clef:=iClef;
    s_Nom:=Titre;
    Caption:=s_Nom;
    Close;
    Params[0].AsInteger:=IClef;
    Open;
    PathImage:=FieldByName('MULTI_PATH').AsString;
    if not FichEstImage(PathImage) then
      exit;

    ppViewer.ZoomFullPage;
  {$IFNDEF IMAGING}
  J1:=nil;
  {$ELSE}
  Finalize(J1);
  {$ENDIF}
          {
    J1:=TJPEGImage.Create;}
    try
     { with J1 do
      begin
        PixelFormat:=jf24Bit;
        Scale:=jsFullSize;
        Grayscale:=False;
        Performance:=jpBestQuality;
        ProgressiveDisplay:=False;
        ProgressiveEncoding:=True;
      end;
            }
      bImage:=false;
      if FileExistsUTF8(PathImage) { *Converted from FileExistsUTF8*  } then
      begin
        try
          J1:=fci_FileToCustomImage(PathImage);
          bImage:=true;
        except
          //format non accepté
        end;
      end;
      if not assigned(J1)and not bImage and(TBlobField(FieldByName('MULTI_MEDIA')).BlobSize>0) then
      begin
        MS:=TMemoryStream.Create;
        try
          TBlobField(FieldByName('MULTI_MEDIA')).SaveToStream(MS);
          MS.Seek(soFromBeginning,0);
          J1:=fci_StreamToCustomImage(MS);
          bImage:=true;
        finally
          MS.Free;
        end;
      end;
      if not bImage then
        exit;

      FirstActivation:=true;
      if J1.Width>J1.Height then
      begin
//        ppReport.PrinterSetup.Orientation:=poLandScape;
        cbLandScape.Checked:=true;
      end
      else
      begin
        // Matthieu Après
//        ppReport.PrinterSetup.Orientation:=poPortrait;
        cbLandScape.Checked:=false;
      end;
      FirstActivation:=false;
    finally
      {$IFDEF IMAGING}FreeImage(J1){$ELSE}J1.Free{$ENDIF};
    end;
    MajImpression;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

function TFBiblio_Multimedia_Edit.ppJITPVariableGetFieldValue(
  aFieldName:string):Variant;
var
  MS:TMemoryStream;
  J1:{$IFNDEF IMAGING}TBGRABitmap{$ELSE}TImageData{$ENDIF};
begin
  if aFieldName='I_MODE' then
  begin
    if (cbLandScape.Checked) then
      result:=1
    else
      result:=0;
    exit;
  end;

  if aFieldName='S_TITRE' then
  begin
    Result:=s_Nom;
    exit;
  end;

  if aFieldName='B_STRETCH' then
  begin
    if (cbStretch.Checked) then
      result:=1
    else
      result:=0;
    exit;
  end;

{  with J1 do
  begin
    PixelFormat:=jf24Bit;
    Scale:=jsFullSize;
    Grayscale:=False;
    Performance:=jpBestQuality;
    ProgressiveDisplay:=False;
    ProgressiveEncoding:=True;
  end;
 }
  MS:=TMemoryStream.Create;
  TBlobField(QImage.FieldByName('MULTI_MEDIA')).SaveToStream(MS);
  MS.Seek(soFromBeginning,0);
  J1:=fci_StreamToCustomImage(MS);
  MS.Free;

  if aFieldName='I_HEIGHT' then
    Result:=J1.Height;
  if aFieldName='I_WIDTH' then
    Result:=J1.Width;

  {$IFDEF IMAGING}FreeImage(J1){$ELSE}J1.Free{$ENDIF};
end;

procedure TFBiblio_Multimedia_Edit.cbStretchClick(Sender:TObject);
begin
  MajImpression;
end;

procedure TFBiblio_Multimedia_Edit.spbPreviewWholeClick(Sender:TObject);
begin
  ppViewer.ZoomFullPage;
end;

procedure TFBiblio_Multimedia_Edit.spbPreviewWidthClick(Sender:TObject);
begin
  ppViewer.ZoomFullWidth;
end;

procedure TFBiblio_Multimedia_Edit.spbPreview100PercentClick(
  Sender:TObject);
begin
  ppViewer.ZoomMultiplePages;
end;

procedure TFBiblio_Multimedia_Edit.SuperFormDestroy(Sender:TObject);
begin
  fFill.Free;
end;

procedure TFBiblio_Multimedia_Edit.rvPrinterChange(Sender:TObject);
begin
  if not fFill.Value then
  begin
    fFill.Value:=true;
    try
      rvPrinter.checked:=true;
      rbPDF.checked:=false;
      rbRTF.checked:=false;
      rbHtml.checked:=false;
    finally
      fFill.Value:=false;
    end;
  end;
end;

procedure TFBiblio_Multimedia_Edit.rbPDFChange(Sender:TObject);
begin
  if not fFill.Value then
  begin
    fFill.Value:=true;
    try
      rvPrinter.checked:=false;
      rbPDF.checked:=true;
      rbRTF.checked:=false;
      rbHtml.checked:=false;
    finally
      fFill.Value:=false;
    end;
  end;
end;

procedure TFBiblio_Multimedia_Edit.rbRTFChange(Sender:TObject);
begin
  if not fFill.Value then
  begin
    fFill.Value:=true;
    try
      rvPrinter.checked:=false;
      rbPDF.checked:=false;
      rbHtml.checked:=false;
      rbRTF.checked:=true;
    finally
      fFill.Value:=false;
    end;
  end;
end;

procedure TFBiblio_Multimedia_Edit.rbHtmlChange(Sender:TObject);
begin
  if not fFill.Value then
  begin
    fFill.Value:=true;
    try
      rvPrinter.checked:=false;
      rbPDF.checked:=false;
      rbRTF.checked:=false;
      rbHtml.checked:=True;
    finally
      fFill.Value:=false;
    end;
  end;
end;

procedure TFBiblio_Multimedia_Edit.btnPrintClick(Sender:TObject);
var
  suite:boolean;
begin
  if rbRTF.checked then
  begin
    SaveDialogRTF.FileName:=s_Nom+'.RTF';
    suite:=SaveDialogRTF.Execute;
  end
  else if rbPDF.checked then
  begin
    SaveDialogPDF.FileName:=s_Nom+'.PDF';
    suite:=SaveDialogPDF.Execute;
  end
  else if rbHTML.checked then
  begin
    SaveDialogHTML.FileName:=s_Nom+'.HTM';
    suite:=SaveDialogHTML.Execute;
  end
  else
    suite:=true;

  if suite then
  begin
    if rbRTF.checked then
    begin
//      ppViewer.Report:=nil;
//      ppReport.DeviceType:='RTFFile';
//      ppReport.TextFileName:=SaveDialogRTF.FileName;
      try
        ppReport.Print;
        Application.ProcessMessages;
//        p_OpenFileOrDirectory();
//        ShellExecute(application.Handle,nil,PChar(SaveDialogRTF.FileName),'','',SW_SHOWNORMAL);
      finally
//        ppReport.DeviceType:='Screen';
//        ppViewer.Report:=ppReport;
      end;
    end
    else if rbPDF.checked then
    begin
{      ppViewer.Report:=nil;
      ppReport.DeviceType:='PDFFile';
      ppReport.TextFileName:=SaveDialogPDF.FileName;
      try
        ppReport.Print;
        Application.ProcessMessages;
        ShellExecute(application.Handle,nil,PChar(SaveDialogPDF.FileName),'','',SW_SHOWNORMAL);
      finally
        ppReport.DeviceType:='Screen';
        ppViewer.Report:=ppReport;
      end;}
    end
    else if rbHTML.checked then
    begin
{      ppViewer.Report:=nil;
      //ExtraOptions.HTML.PixelFormat    := pf8Bit;
      ppReport.DeviceType:='HTMLFile';
      ppReport.TextFileName:=SaveDialogHTML.FileName;
      try
        ppReport.Print;
        Application.ProcessMessages;
      finally
        ppReport.DeviceType:='Screen';
        ppViewer.Report:=ppReport;
      end;}
    end
    else if rvPrinter.checked then
    begin
{      ppViewer.Report:=nil;
      ppReport.DeviceType:='Printer';
      try
        ppReport.Print;
      finally
        ppReport.DeviceType:='Screen';
        ppViewer.Report:=ppReport;
      end;}
    end;
  end;
end;

procedure TFBiblio_Multimedia_Edit.cbLandScapeClick(Sender:TObject);
begin
  if not FirstActivation then
  begin
{    if cbLandScape.Checked then
      ppReport.PrinterMetrics.Orientation:=poLandScape
    else
      ppReport.PrinterSetup.Orientation:=poPortrait;}
    MajImpression;
  end;
end;

procedure TFBiblio_Multimedia_Edit.MajImpression;
begin
  Screen.Cursor:=crHourGlass;
{  ppReport.BeginUpdate;
  ppReport.Reset;
  ppReport.PrintToDevices;
  ppReport.EndUpdate;}
  Screen.Cursor:=crDefault;
end;

end.

