unit u_form_report_media;

{$mode delphi}

interface

uses
  Forms, RLReport,
  u_reports_rlcomponents;

type

  { TFReportMedia }

  TFReportMedia = class(TForm)
    RLHeader: TRLBand;
    RLBand2: TRLBand;
    RLColumn: TRLBand;
    RLDBExtImage1: TRLDBExtImage;
    RLDBText1: TRLDBText;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLTitle: TRLLabel;
    RLReport: TRLReport;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FReportMedia: TFReportMedia = nil;

implementation

uses
     fonctions_reports;


{ TFReportMedia }

procedure TFReportMedia.FormCreate(Sender: TObject);
begin
  RLColumn.Color :=  ExtColumnColorBack     ;
  RLHeader.Color :=  ExtHeaderColorBack       ;
  RLHeader.Font.Name  := ExtHeaderFont.Name       ;
  RLHeader.Font.Color := ExtHeaderFont.Color      ;
  RLColumn.Font.Name  := ExtColumnFont.Name       ;
  RLColumn.Font.Color := ExtColumnFont.Color      ;

end;

{$R *.lfm}


end.

