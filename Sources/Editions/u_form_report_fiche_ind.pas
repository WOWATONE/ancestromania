unit u_form_report_fiche_ind;

{$mode delphi}

interface

uses
  Forms, RLReport, DB,
  u_reports_rlcomponents,u_dm;

type

  { TFReportFicheInd }

  TFReportFicheInd = class(TForm)
    RLHeader: TRLBand;
    RLBand2: TRLBand;
    RLColumnHeader: TRLBand;
    RLColumn: TRLBand;
    RLDBExtImage1: TRLDBExtImage;
    RLDBSexe: TRLDBExtImageList;
    RLDBText1: TRLDBText;
    RLDBText10: TRLDBText;
    RLDBText11: TRLDBText;
    RLDBText12: TRLDBText;
    RLDBText13: TRLDBText;
    RLDBText14: TRLDBText;
    RLDBText15: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText6: TRLDBText;
    RLDBText8: TRLDBText;
    RLLabel1: TRLLabel;
    RLLabel13: TRLLabel;
    RLLabel16: TRLLabel;
    RLLabel19: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel22: TRLLabel;
    RLLabel27: TRLLabel;
    RLLabel28: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel31: TRLLabel;
    RLLabel34: TRLLabel;
    RLLabel35: TRLLabel;
    RLLabel4: TRLLabel;
    RLTitle: TRLLabel;
    RLReport: TRLReport;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure SetDatasource ( const ADatasource : TDatasource );
  end;

var
  FReportFicheInd: TFReportFicheInd = nil;

implementation

uses fonctions_proprietes,
     fonctions_reports;

{ TFReportFicheInd }

procedure TFReportFicheInd.FormCreate(Sender: TObject);
begin
  RLDBSexe.Images := dm.ImageSexe;
  RLColumn      .Color :=  ExtColumnColorBack     ;
  RLColumnHeader.Color :=  ExtColumnHeaderColorBack ;
  RLHeader      .Color :=  ExtHeaderColorBack       ;
  RLHeader      .Font.Name  := ExtHeaderFont.Name       ;
  RLHeader      .Font.Color := ExtHeaderFont.Color      ;
  RLColumnHeader.Font.Name  := ExtColumnHeaderFont.Name ;
  RLColumnHeader.Font.Color := ExtColumnHeaderFont.Color;
  RLColumn      .Font.Name := ExtColumnFont.Name       ;
  RLColumn      .Font.Color  := ExtColumnFont.Color      ;
end;

procedure TFReportFicheInd.SetDatasource(const ADatasource: TDatasource);
var i : Integer;
begin
  for i := 0 to ComponentCount -1  do
    p_SetComponentObjectProperty(Components[i],CST_DBPROPERTY_DATASOURCE,ADatasource);
end;

{$R *.lfm}


end.

