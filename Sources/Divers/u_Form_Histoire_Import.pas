unit u_Form_Histoire_Import;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
{$ENDIF}
  SysUtils,Graphics,Forms,
  Dialogs,StdCtrls,u_buttons_appli,
  u_framework_components, U_ExtImage,
  ExtCtrls;

type

  { TFHistoireImport }

  TFHistoireImport=class(TForm)
    bsfbSelection: TFWOK;
    btnFermer: TFWClose;
    cxImage1: TExtImage;
    Label4: TLabel;
    lbLienDica: TLabel;
    Panel1:TPanel;
    Label3:TLabel;
    eNomFichier:TFWEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    rgDossier: TRadioGroup;
    SaveDialog:TOpenDialog;
    procedure bsfbSelectionClick(Sender:TObject);
    procedure cxButtonEdit1PropertiesButtonClick(Sender:TObject;
      AButtonIndex:Integer);
    procedure lbLienDicaMouseEnter(Sender:TObject);
    procedure lbLienDicaMouseLeave(Sender:TObject);
    procedure lbLienDicaClick(Sender:TObject);
    procedure FormCreate(Sender:TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    bImport:boolean;
    iNumDossier:Integer;
    sFichier:string;
  end;

var
  FHistoireImport:TFHistoireImport;

implementation

uses u_Dm,
     u_common_functions,
     u_genealogy_context,
     u_common_ancestro;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFHistoireImport.bsfbSelectionClick(Sender:TObject);
begin
  if rgDossier.ItemIndex=0 then
    iNumDossier:=0
  else
    iNumDossier:=dm.NumDossier;

  sFichier:=eNomFichier.Text;
  bImport:=true;
  Close;
end;

procedure TFHistoireImport.cxButtonEdit1PropertiesButtonClick(
  Sender:TObject;AButtonIndex:Integer);
begin
  SaveDialog.Title:=rs_Title_Have_a_look_into;
  SaveDialog.InitialDir:=ExtractFilePath(Application.EXEName)+'Tables de references';

  if SaveDialog.execute then
    eNomFichier.Text:=SaveDialog.FileName;
end;

procedure TFHistoireImport.lbLienDicaMouseEnter(Sender:TObject);
begin
  (Sender as TLabel).Font.Style:= [fsBold,fsUnderline];
end;

procedure TFHistoireImport.lbLienDicaMouseLeave(Sender:TObject);
begin
  (Sender as TLabel).Font.Style:= [];
end;

procedure TFHistoireImport.lbLienDicaClick(Sender:TObject);
begin
  GotoThisUrl(dm.GetUrlMajAuto+'DICA.zip');
end;

procedure TFHistoireImport.FormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
end;

end.

