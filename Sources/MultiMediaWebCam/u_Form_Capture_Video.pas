unit u_Form_Capture_Video;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, DSPack, DSUtil, DirectShow9, Windows,
{$ELSE}
{$ENDIF}
  Forms,
  Dialogs, StdCtrls, ExtCtrls,  u_buttons_appli,ExtJvXPButtons;

type

  { TFCapture_Video }

  TFCapture_Video = class(TForm)
//    CaptureGraph: TFilterGraph;
//    VideoSourceFilter: TFilter;
    SaveDialog: TSaveDialog;
    Timer: TTimer;
//    AudioSourceFilter: TFilter;
    FlatPanel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    VideoCapFilters: TListBox;
    AudioCapFilters: TListBox;
    VideoFormats: TListBox;
    AudioFormats: TListBox;
    InputLines: TComboBox;
    Panel3: TPanel;
    Image1: TImage;
    Label5: TLabel;
    fpBoutons: TPanel;
    CapFileButton: TJvXPButton;
    StartButton: TJvXPButton;
    StopButton: TJvXPButton;
    btnQuitter: TFWQuit;
    btnEnregistrer: TFWOK;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VideoCapFiltersClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure CapFileButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure AudioCapFiltersClick(Sender: TObject);
    procedure btnQuitterClick(Sender: TObject);
    procedure btnEnregistrerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fVideo: string;
  public
    { Public declarations }
    property sVideo: string read fVideo write fVideo;

  end;

var
  FCapture_Video: TFCapture_Video;
//  CapEnum: TSysDevEnum;
//  VideoMediaTypes, AudioMediaTypes: TEnumMediaType;
  CapFile: WideString;
implementation

uses
     u_genealogy_context;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TMainForm }

procedure TFCapture_Video.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Color:=gci_context.ColorLight;
  Capfile := gci_context.PathImages + 'Capture.Avi';
  //StatusPanel2.Caption := capfile;
                              {
  CapEnum := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  for i := 0 to CapEnum.CountFilters - 1 do
    VideoCapFilters.Items.Add(CapEnum.Filters[i].FriendlyName);

  CapEnum.SelectGUIDCategory(CLSID_AudioInputDeviceCategory);
  for i := 0 to CapEnum.CountFilters - 1 do
    AudioCapFilters.Items.Add(CapEnum.Filters[i].FriendlyName);

  VideoMediaTypes := TEnumMediaType.Create;
  AudioMediaTypes := TEnumMediaType.Create;

  VideoCapFilters.ItemIndex := 0;
  VideoCapFiltersClick(Sender);

  AudioCapFilters.ItemIndex := 0;
  AudioCapFiltersClick(Sender);}
end;

procedure TFCapture_Video.FormDestroy(Sender: TObject);
begin
{  CapEnum.Free;
  VideoMediaTypes.Free;
  AudioMediaTypes.Free;}
end;

// Select the video Source

procedure TFCapture_Video.VideoCapFiltersClick(Sender: TObject);
var
//  PinList: TPinList;
  i: integer;
begin
{  CapEnum.SelectGUIDCategory(CLSID_VideoInputDeviceCategory);
  if VideoCapFilters.ItemIndex <> -1 then
    begin
      VideoSourceFilter.BaseFilter.Moniker := CapEnum.GetMoniker(VideoCapFilters.ItemIndex);
      VideoSourceFilter.FilterGraph := CaptureGraph;
      CaptureGraph.Active := true;
      PinList := TPinList.Create(VideoSourceFilter as IBaseFilter);
      VideoFormats.Clear;
      VideoMediaTypes.Assign(PinList.First);
      for i := 0 to VideoMediaTypes.Count - 1 do
        VideoFormats.Items.Add(VideoMediaTypes.MediaDescription[i]);
      CaptureGraph.Active := false;
      PinList.Free;
      StartButton.Enabled := true;
    end;}
end;

// Select the audio Source

procedure TFCapture_Video.AudioCapFiltersClick(Sender: TObject);
var
//  PinList: TPinList;
  i, LineIndex: integer;
  ABool: LongBool;
begin
{  CapEnum.SelectGUIDCategory(CLSID_AudioInputDeviceCategory);
  if AudioCapFilters.ItemIndex <> -1 then
    begin
      AudioSourceFilter.BaseFilter.Moniker := CapEnum.GetMoniker(AudioCapFilters.ItemIndex);
      AudioSourceFilter.FilterGraph := CaptureGraph;
      CaptureGraph.Active := true;
      PinList := TPinList.Create(AudioSourceFilter as IBaseFilter);
      AudioFormats.Clear;
      i := 0;
      while i < PinList.Count do
        if PinList.PinInfo[i].dir = PINDIR_OUTPUT then
          begin
            AudioMediaTypes.Assign(PinList.Items[i]);
            PinList.Delete(i);
          end
        else
          inc(i);

      for i := 0 to AudioMediaTypes.Count - 1 do
        begin
          AudioFormats.Items.Add(AudioMediaTypes.MediaDescription[i]);
        end;

      CaptureGraph.Active := false;
      InputLines.Clear;
      LineIndex := -1;
      for i := 0 to PinList.Count - 1 do
        begin
          InputLines.Items.Add(PinList.PinInfo[i].achName);
          with (PinList.Items[i] as IAMAudioInputMixer) do
            get_Enable(ABool);
          if ABool then LineIndex := i;
        end;
      InputLines.ItemIndex := LineIndex;
      PinList.Free;
      StartButton.Enabled := true;
    end;}
end;

// Start Capture

procedure TFCapture_Video.StartButtonClick(Sender: TObject);
var
//  multiplexer: IBaseFilter;
//  Writer: IFileSinkFilter;
//  PinList: TPinList;
  i: integer;
begin
  // Activate the filter graph, at this stage the source filters are added to the graph
{  CaptureGraph.Active := true;

  // configure output Audio media type + source
  if AudioSourceFilter.FilterGraph <> nil then
    begin
      PinList := TPinList.Create(AudioSourceFilter as IBaseFilter);
      i := 0;
      while i < PinList.Count do
        if PinList.PinInfo[i].dir = PINDIR_OUTPUT then
          begin
            if AudioFormats.ItemIndex <> -1 then
              with (PinList.Items[i] as IAMStreamConfig) do
                SetFormat(AudioMediaTypes.Items[AudioFormats.ItemIndex].AMMediaType^);
            PinList.Delete(i);
          end
        else
          inc(i);
      if InputLines.ItemIndex <> -1 then
        with (PinList.Items[InputLines.ItemIndex] as IAMAudioInputMixer) do
          put_Enable(true);
      PinList.Free;
    end;

  // configure output Video media type
  if VideoSourceFilter.FilterGraph <> nil then
    begin
      PinList := TPinList.Create(VideoSourceFilter as IBaseFilter);
      if VideoFormats.ItemIndex <> -1 then
        with (PinList.First as IAMStreamConfig) do
          SetFormat(VideoMediaTypes.Items[VideoFormats.ItemIndex].AMMediaType^);
      PinList.Free;
    end;

  // now render streams
  with CaptureGraph as IcaptureGraphBuilder2 do
    begin
      // set the output filename
      SetOutputFileName(MEDIASUBTYPE_Avi, PWideChar(CapFile), multiplexer, Writer);

      // Connect Video preview (VideoWindow)
      if VideoSourceFilter.BaseFilter.DataLength > 0 then
        RenderStream(@PIN_CATEGORY_PREVIEW, nil, VideoSourceFilter as IBaseFilter,
          nil, VideoWindow as IBaseFilter);

      // Connect Video capture streams
      if VideoSourceFilter.FilterGraph <> nil then
        RenderStream(@PIN_CATEGORY_CAPTURE, nil, VideoSourceFilter as IBaseFilter,
          nil, multiplexer as IBaseFilter);

      // Connect Audio capture streams
      if AudioSourceFilter.FilterGraph <> nil then
        begin

          RenderStream(nil, nil, AudioSourceFilter as IBaseFilter,
            nil, multiplexer as IBaseFilter);
        end;
    end;
  CaptureGraph.Play;
  StopButton.Enabled := true;
  StartButton.Enabled := false;
  AudioFormats.Enabled := false;
  AudioCapFilters.Enabled := false;
  VideoFormats.Enabled := false;
  VideoCapFilters.Enabled := false;
  Timer.Enabled := true;}
end;

// Select the Ouput file

procedure TFCapture_Video.CapFileButtonClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    begin
      CapFile := SaveDialog.FileName + '.Avi';
      //StatusPanel2.Caption := SaveDialog.FileName + '.Avi';
    end;
end;

// Stop Capture

procedure TFCapture_Video.StopButtonClick(Sender: TObject);
begin
  Timer.Enabled := false;
  StopButton.Enabled := false;
  StartButton.Enabled := true;
{  CaptureGraph.Stop;
  CaptureGraph.Active := False;
  AudioFormats.Enabled := true;
  AudioCapFilters.Enabled := true;
  VideoFormats.Enabled := true;
  VideoCapFilters.Enabled := true;}
  btnEnregistrer.Enabled := True;
end;

// Timer

procedure TFCapture_Video.TimerTimer(Sender: TObject);
var
  position: int64;
  Hour, Min, Sec, MSec: Word;
const
  MiliSecInOneDay = 86400000;
begin
{  if CaptureGraph.Active then
    begin
      with CaptureGraph as IMediaSeeking do
        GetCurrentPosition(position);
      DecodeTime(position div 10000 / MiliSecInOneDay, Hour, Min, Sec, MSec);
      //StatusPanel1.Caption := Format('%d:%d:%d:%d', [Hour, Min, Sec, MSec]);
    end;
 }
end;

procedure TFCapture_Video.btnQuitterClick(Sender: TObject);
begin
  Close;
end;

procedure TFCapture_Video.btnEnregistrerClick(Sender: TObject);
begin
  fVideo := CapFile;
  Close;
end;

procedure TFCapture_Video.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //Action := caFree;
end;

end.
