unit u_Form_Capture_Photos;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, DirectShow9, DSPack, DSUtil, Windows,
{$ELSE}
{$ENDIF}
  Forms,StdCtrls,ExtCtrls,u_buttons_appli,ExtJvXPButtons;

type
  TFCapture_Photo=class(TForm)
//    FilterGraph:TFilterGraph;
//    Filter:TFilter;
//    SampleGrabber:TSampleGrabber;
    Panel3:TPanel;
    Image1:TImage;
    Label2:TLabel;
    Label1:TLabel;
//    VideoWindow:TVideoWindow;
    VideoCapFilters:TListBox;
    Panel1:TPanel;
    btnCancel:TFWCancel;
    btnEnregistrer:TFWOK;
    SnapShot:TJvXPButton;
    Image:TImage;
    FlatPanel1:TPanel;
    FlatPanel2:TPanel;
    procedure FormCloseQuery(Sender:TObject;var CanClose:Boolean);
    procedure SnapShotClick(Sender:TObject);
    procedure VideoCapFiltersClick(Sender:TObject);
    procedure FormCreate(Sender:TObject);
    procedure btnEnregistrerClick(Sender:TObject);
    procedure btnCancelClick(Sender:TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    fImage:string;
  public
    { Déclarations publiques }
    property sImage:string read fImage write fImage;
  end;

var
  FCapture_Photo:TFCapture_Photo;
//  SysDev:TSysDevEnum;
implementation

uses
     u_common_ancestro,
     u_common_ancestro_functions,
     u_genealogy_context;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFCapture_Photo.FormCloseQuery(Sender:TObject;var CanClose:Boolean);
begin
  {
  SysDev.Free;
  FilterGraph.ClearGraph;
  FilterGraph.Active:=false;}
end;

procedure TFCapture_Photo.SnapShotClick(Sender:TObject);
begin
//  SampleGrabber.GetBitmap(Image.Picture.Bitmap);
  btnEnregistrer.Enabled:=True;
end;

procedure TFCapture_Photo.VideoCapFiltersClick(Sender:TObject);
begin
{  SysDev.SelectGUIDCategory(CLSID_VideoInputDeviceCategory);

  if VideoCapFilters.ItemIndex<>-1 then
  begin
    FilterGraph.ClearGraph;
    FilterGraph.Active:=false;
    Filter.BaseFilter.Moniker:=SysDev.GetMoniker(VideoCapFilters.ItemIndex);
    FilterGraph.Active:=true;

    with FilterGraph as ICaptureGraphBuilder2 do
      RenderStream(@PIN_CATEGORY_PREVIEW,
        nil,Filter as IBaseFilter,SampleGrabber as IBaseFilter,VideoWindow as IbaseFilter);
    FilterGraph.Play;

    SnapShot.Enabled:=True;
  end;}
end;

procedure TFCapture_Photo.FormCreate(Sender:TObject);

var
  i:integer;
begin
  Color:=gci_context.ColorLight;
{  SysDev:=TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);

  for i:=0 to SysDev.CountFilters-1 do
    VideoCapFilters.Items.Add(SysDev.Filters[i].FriendlyName);

  VideoCapFilters.ItemIndex:=0;
  VideoCapFiltersClick(Sender);}
end;

procedure TFCapture_Photo.btnEnregistrerClick(Sender:TObject);
begin
  if Image.Picture<>nil then
  begin
    fImage:=_TempPath+'Temp.BMP';
    Image.Picture.SaveToFile(fImage);
  end;
  Close;
end;

procedure TFCapture_Photo.btnCancelClick(Sender:TObject);
begin
  fImage:='';
  Close;
end;

procedure TFCapture_Photo.FormShow(Sender: TObject);
begin
  Caption:=rs_Caption_Capture_a_picture;
end;

end.

