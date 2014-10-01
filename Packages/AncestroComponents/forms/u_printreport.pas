unit u_printreport;

{$mode delphi}

interface

uses
  Forms, RLReport,
  RLPreviewForm, RLPDFFilter, RLRichFilter,
  u_ancestroviewer;

type

  { TPrintGraph }

  TPrintGraph = class(TForm)
    ps: TRLPreviewSetup;
    RLPDFFilter: TRLPDFFilter;
    RLRichFilter: TRLRichFilter;
    rp: TRLReport;
    procedure rpBeforePrint(Sender: TObject; var PrintIt: boolean);
    procedure DataModuleCreate(Sender: TObject);
  private
    FGraph: TGraphComponent;
    FGraphForm: TCustomForm;
    //les pages
    fDecalagePapierY: extended;
    fDecalagePapierX: extended;
    procedure PreparePages(const aGraphForm: TCustomForm;const aGraphComponent: TGraphComponent; const OnePage :boolean = False);
    procedure PrintAPage(const nx,ny: integer; const OnePage : Boolean = False );
    procedure PrintSave(const APrintOut: integer; const ASFilename: String='');

  public
    fpriorreport : TRLReport;
    { public declarations }
    property DecalagePapierX: extended read fDecalagePapierX write fDecalagePapierX;
    property DecalagePapierY: extended read fDecalagePapierY write fDecalagePapierY;

    procedure Print(const aGraphForm: TCustomForm;const aGraphComponent: TGraphComponent; const APrintOut: integer; const ASFilename : String = '');
    procedure PrintPage(const aGraphForm: TCustomForm; const aGraphComponent: TGraphComponent; const px, py: integer; const APrintOut: integer; const ASFilename : String = '');
    procedure PrinterSetup;
  end;

var
  PrintGraph: TPrintGraph=nil;
  ScaleHeight,ScaleWidth : double;

implementation

{$R *.lfm}

uses fonctions_reports, RLConsts;

{ TPrintGraph }


procedure TPrintGraph.rpBeforePrint(Sender: TObject; var PrintIt: boolean);
begin
  rp.Margins.LeftMargin := rp.left;
  rp.Margins.TopMargin := rp.Top;
  rp.Margins.RightMargin := Graph_RecouvrementImpression;
  rp.Margins.BottomMargin := Graph_RecouvrementImpression;

  fGraph.Data.PreparePrint;
  with rp.Margins do
    fGraph.Print(LeftMargin + fDecalagePapierX, RightMargin + fDecalagePapierY);
end;

procedure TPrintGraph.DataModuleCreate(Sender: TObject);
begin
  fGraph := nil;
end;
procedure TPrintGraph.PreparePages(const aGraphForm: TCustomForm;const aGraphComponent: TGraphComponent; const OnePage :boolean = False);
var nx: integer;
Begin
  FGraphForm := aGraphForm;
  FGraph    := aGraphComponent;
  for nx := 0 to rp.ComponentCount - 1 do
    if rp.Components[nx] is TRLReport Then rp.Components[nx].destroy;
  fpriorreport :=nil;
  rp.NextReport:=nil;
  with rp do
    begin
    //  pages.PrepareUpdate;
   //   pages.BeginUpdate;
      Title := FGraphForm.Caption;
      FirstPageNumber:=1;
      with FGraph.Viewer,PageSetup do
        Begin
          if PageHeight>=PageWidth
           Then Begin ScaleHeight := PaperHeight/PageHeight; ScaleWidth := PaperWidth /PageWidth; End
           Else Begin ScaleHeight := PrinterMetrics.ClientWidth / PageHeight / MMAsPixels; ScaleWidth := PrinterMetrics.ClientHeight / PageWidth / MMAsPixels; End;
         ScaleHeight := MMAsPixels;
         ScaleWidth  := MMAsPixels;
        end;
      with aGraphComponent.Viewer do
       Begin
        if OnePage
         Then pages.LastPageNumber:= 1
         Else pages.LastPageNumber:= ( ViewYC.Count - 1 ) * ( ViewXC.Count - 1 );
       end;
    end;
end;

procedure TPrintGraph.Print(const aGraphForm: TCustomForm;const aGraphComponent: TGraphComponent; const APrintOut: integer; const ASFilename : String = '');
var
  areport  : TRLReport;
  nx, ny: integer;
begin
  PreparePages(aGraphForm,aGraphComponent);
  rp.BeginDoc;
  try
    //les pages
    with aGraphComponent.Viewer do
      Begin
       for ny := 0 to ViewYC.Count - 2 do
          for nx := 0 to ViewXC.Count - 2 do
            PrintAPage(nx,ny);
      end;
  finally
    rp.EndDoc;
  end;

  PrintSave( APrintOut, ASFilename );
end;
procedure TPrintGraph.PrintSave(const APrintOut: integer; const ASFilename : String = '');
var
  areport  : TRLReport;
  nx, ny: integer;
begin
  if APrintOut > 0
   Then rp.SaveToFile( ASFilename )
   Else rp.Print;
End;
procedure TPrintGraph.PrintAPage(const nx, ny: integer; const OnePage : Boolean = False );
var
  areport  : TRLReport;
begin
  //les pages
  with FGraph.Viewer do
   Begin
      //le décalage
      if  OnePage
      or (   ( ny = 0 )
         and ( nx = 0 ))
       then
         Begin
           areport := rp;
           areport.Surface.Clear;
           fpriorreport := areport;
         end
       Else
        Begin
          areport := frlr_CreateNewReport (rp);
          areport.PriorReport:=fpriorreport;
        end;
      fDecalagePapierX := -ViewXC[nx];
      fDecalagePapierY := -ViewYC[ny];
      PrintCanvas := areport.Surface;
      areport.BeforePrint:=rpBeforePrint;
      areport.Prepare;
    end;
end;

procedure TPrintGraph.PrintPage(const aGraphForm: TCustomForm; const aGraphComponent: TGraphComponent;
  const px, py: integer; const APrintOut: integer; const ASFilename : String = '');
begin
  // avoir le bon numéro de page.
  PreparePages(aGraphForm,aGraphComponent,True);
  fGraph := aGraphComponent;
    //le décalage
  rp.BeginDoc;
  try
    //la page
    PrintAPage(px,py,True);
  finally
    rp.EndDoc;
  end;
  PrintSave(APrintOut,ASFilename);
end;

procedure TPrintGraph.PrinterSetup;
begin
  rp.ShowPrintDialog;
end;
end.