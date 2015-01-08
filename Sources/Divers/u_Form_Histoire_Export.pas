unit u_Form_Histoire_Export;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
{$ENDIF}
  SysUtils,Controls,Forms,
  Dialogs,StdCtrls,u_buttons_appli,
  u_framework_components, U_ExtImage,
  IBSQL, u_framework_dbcomponents,
  ExtCtrls;

type

  { TFHistoireExport }

  TFHistoireExport=class(TForm)
    bsfbSelection: TFWOK;
    btnFermer: TFWClose;
    ComboBoxDico: TFWDBComboBox;
    ComboBoxDossier: TFWDBComboBox;
    cxImage1: TExtImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Panel1:TPanel;
    Label3:TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SaveDialog:TSaveDialog;
    eNomFichier:TFWEdit;
    procedure FormCreate(Sender:TObject);
    procedure bsfbSelectionClick(Sender:TObject);
    procedure cxButtonEdit1PropertiesButtonClick(Sender:TObject;
      AButtonIndex:Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    bImport:boolean;
    iNumDossier:Integer;
    sDico,sFichier:string;
  end;

var
  FHistoireExport:TFHistoireExport;

implementation

uses u_Dm,
     u_common_ancestro,
     u_genealogy_context,
     fonctions_dialogs,
     u_common_ancestro_functions,
     u_common_const, FileUtil;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFHistoireExport.FormCreate(Sender:TObject);
var
  QueryRead:TIBSQL;
  chaine:string;
begin
  Color:=gci_context.ColorLight;
  eNomFichier.Text:=ExtractFilePath(Application.EXEName)+'Tables de references'+DirectorySeparator+'Histoire.dica';

  QueryRead:=TIBSQL.Create(Application);
  QueryRead.database:=dm.ibd_BASE;
  QueryRead.SQL.Add('select distinct h.hi_dossier,d.nom_dossier from ref_histoire h'
    +' inner join dossier d on d.cle_dossier=h.hi_dossier'
    +' order by h.hi_dossier');
  QueryRead.ExecQuery;
  ComboBoxDossier.Items.Clear;
  ComboBoxDossier.Items.Add('0 ,Dictionnaire de référence');

  with QueryRead do
  while not eof do
  begin
    chaine:=FieldByName('HI_DOSSIER').AsString;
    while Length(chaine)<2 do
      chaine:=chaine+' ';
    ComboBoxDossier.Items.Add(chaine+', '+FieldByName('NOM_DOSSIER').AsString);
    Next;
  end;

  QueryRead.Close;
  ComboBoxDossier.ItemIndex:=0;
  QueryRead.SQL.Clear;
  QueryRead.SQL.Add('select distinct hi_dicorigine from ref_histoire'
    +' order by hi_dicorigine');
  QueryRead.ExecQuery;
  ComboBoxDico.Items.Clear;

  with QueryRead do
  while not eof do
  begin
    ComboBoxDico.Items.Add(FieldByName('hi_dicorigine').AsString);
    Next;
  end;

  QueryRead.Close;
  QueryRead.Free;
  ComboBoxDico.ItemIndex:=0;
end;

procedure TFHistoireExport.bsfbSelectionClick(Sender:TObject);
begin
  iNumDossier:=StrToInt(trim(Copy(ComboBoxDossier.Text,1,2)));
  sDico:=ComboBoxDico.Text;
  sFichier:=eNomFichier.Text;
  bImport:=true;

  Close;
end;

procedure TFHistoireExport.cxButtonEdit1PropertiesButtonClick(
  Sender:TObject;AButtonIndex:Integer);
var
  ok:boolean;
begin
  //SaveDialog.Title := 'Regarder dans...';
  SaveDialog.InitialDir:=ExtractFilePath(Application.EXEName)+'Tables de references';

  if SaveDialog.execute then
  begin
    if FileExistsUTF8(SaveDialog.FileName) { *Converted from FileExistsUTF8*  } then
    begin
      Ok:=MyMessageDlg(rs_Selected_file_exists+_CRLF+_CRLF+
        rs_Do_you_overwrite_it,mtWarning,[mbYes,mbNo],Self)=mrYes;
    end
    else
      ok:=true;

    if ok then
      eNomFichier.Text:=SaveDialog.FileName;
  end;
end;

end.

