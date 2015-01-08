unit u_Form_Histoire_Detail;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf, LCLType,
  SysUtils,Graphics,Controls,Forms,
  Dialogs,DB,IBCustomDataSet,IBQuery,ExtCtrls,
  u_framework_dbcomponents,
  StdCtrls,u_buttons_appli,IBUpdateSQL,DBCtrls,
  ExtDlgs,Menus,IB, U_ExtDBImage;

type

  { TFormHistoireDetail }

  TFormHistoireDetail=class(TForm)
    btnFermer: TFWClose;
    btnNouveau: TFWAdd;
    btnValider: TFWOK;
    cbCategories: TFWDBComboBox;
    cxDBCheckBox1: TDBCheckBox;
    cxDBTextEdit2: TFWDBEdit;
    cxDBTextEdit3: TFWDBLookupCombo;
    DBTextMemo: TFWDBMemo;
    edDateTexte: TFWDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel1:TPanel;
    dsHistoire:TDataSource;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    qHistoire:TIBQuery;
    uHistoire:TIBUpdateSQL;
    cxGroupBox1:TGroupBox;
    cxGroupBox2:TGroupBox;
    Label4:TLabel;
    qHistoireHI_ID:TLongintField;
    qHistoireHI_DOSSIER:TLongintField;
    qHistoireHI_DICORIGINE:TIBStringField;
    qHistoireHI_DATE_TEXTE:TIBStringField;
    qHistoireHI_CAT:TLongintField;
    qHistoireHI_TITRE:TIBStringField;
    qHistoireHI_TEXTE:TMemoField;
    qHistoireHI_IMAGE:TBlobField;
    qListeOrigineHI_DICORIGINE:TIBStringField;
    cxDBImage1:TExtDBImage;
    pmFamille:TPopupMenu;
    GrandsParents1:TMenuItem;
    Parents1:TMenuItem;
    N1:TMenuItem;
    Onclesettantes1:TMenuItem;
    Cousines1:TMenuItem;
    Frresetsoeurs1:TMenuItem;
    Neveuxetnices1:TMenuItem;
    Conjoints1:TMenuItem;
    Enfants1:TMenuItem;
    Petitsenfants1:TMenuItem;
    qListeOrigine:TIBQuery;
    dsListeOrigine:TDataSource;
    procedure btnValiderClick(Sender:TObject);
    procedure btnNouveauClick(Sender:TObject);
    procedure FormCloseQuery(Sender:TObject;var CanClose:Boolean);
    procedure FormDestroy(Sender:TObject);
    procedure cbCategoriesPropertiesChange(Sender:TObject);
    procedure cxDBImage1PropertiesCustomClick(Sender:TObject);
    procedure dsHistoireStateChange(Sender:TObject;Field:TField);
    procedure FormShow(Sender:TObject);
    procedure FormCreate(Sender:TObject);
    procedure edDateTextePropertiesChange(Sender: TObject);
  private
    { Déclarations privées }
    BloqueEdit:Boolean;

  public
    { Déclarations publiques }
    iID:integer;
    bModif:boolean;
  end;

implementation

uses  u_Dm,
      u_common_functions,
      u_Common_Const,
      u_Form_Histoire,
      u_common_ancestro,
      u_genealogy_context,
      u_common_ancestro_functions,
      fonctions_dialogs,
      fonctions_images;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFormHistoireDetail }

procedure TFormHistoireDetail.FormCreate(Sender:TObject);
var
  i:Integer;
begin
  BloqueEdit:=True;
  Color:=gci_context.ColorLight;
  cxDBCheckBox1.Color:=Color;
  cbCategories.Items.Clear;
  for i:=0 to (Owner as TFHistoire).pmCategories.Items.Count-1 do
    cbCategories.Items.Add((Owner as TFHistoire).pmCategories.Items[i].Caption);
  qListeOrigine.Transaction:=(Owner as TFHistoire).TransHistoire;
  qHistoire.Transaction:=(Owner as TFHistoire).TransHistoire;
  qListeOrigine.Params[0].AsInteger:=dm.NumDossier;
  qListeOrigine.Open;
  qHistoire.Params[0].AsInteger:=(Owner as TFHistoire).ibHistoireHI_ID.AsInteger;
  qHistoire.open;
  if qHistoireHI_CAT.AsInteger>=0 then
    cbCategories.ItemIndex:=qHistoireHI_CAT.AsInteger-1;
  BloqueEdit:=False;
end;

procedure TFormHistoireDetail.btnValiderClick(Sender:TObject);
begin
  if length(Trim(edDateTexte.Text))=0 then
  begin
    MyMessageDlg(rs_Error_Period_must_be_set,mtError,[mbCancel],Self);
    edDateTexte.SetFocus;
    Abort;
  end;
  bModif:=true;
  iID:=qHistoireHI_ID.AsInteger;
  try
    qHistoire.Post;
  except
    on E:EIBError do
      ShowMessage(rs_Error_Cannot_Validate_on_database+_CRLF+_CRLF+E.Message);
  end;
  (Owner as TFHistoire).TransHistoire.CommitRetaining;
  btnNouveau.Enabled:=True;
  btnValider.Enabled:=false;
end;

procedure TFormHistoireDetail.btnNouveauClick(Sender:TObject);
var
  sDico,sCombo:string;
begin
  sDico:=cxDBTextEdit3.Caption;
  sCombo:=cbCategories.Caption;
  qHistoire.Insert;
  if cxDBCheckBox1.Checked then
    qHistoireHI_DOSSIER.asInteger:=0
  else
    qHistoireHI_DOSSIER.asInteger:=dm.NumDossier;
  qHistoireHI_DICORIGINE.AsString:=sDico;
  cbCategories.Text:=sCombo;
  qHistoireHI_CAT.AsInteger:=cbCategories.ItemIndex+1;
  edDateTexte.SetFocus;
end;

procedure TFormHistoireDetail.FormCloseQuery(Sender:TObject;
  var CanClose:Boolean);
begin
  if btnValider.Enabled then
    if MyMessageDlg(rs_Do_you_validate_changed_data,mtWarning, [mbYes,mbNo],Self)=mrYes then
      btnValiderClick(Sender);
end;

procedure TFormHistoireDetail.FormDestroy(Sender:TObject);
begin
  qHistoire.Close;
  qListeOrigine.close;
end;

procedure TFormHistoireDetail.cbCategoriesPropertiesChange(Sender:TObject);
begin
  if not BloqueEdit then
  begin
    qHistoire.Edit;
    qHistoireHI_CAT.AsInteger:=cbCategories.ItemIndex+1;
  end;
end;

procedure TFormHistoireDetail.cxDBImage1PropertiesCustomClick(Sender:TObject);
begin
  with dm.OpenPictureDialog do
  if execute then
    p_FileToBitmap ( FileName, cxDBImage1.Picture.Bitmap, True);
end;

procedure TFormHistoireDetail.dsHistoireStateChange(Sender:TObject;
  Field:TField);
begin
  if dsHistoire.State in [dsInsert,dsEdit] then
  begin
    btnValider.Enabled:=True;
    btnNouveau.Enabled:=False;
  end;
end;

procedure TFormHistoireDetail.FormShow(Sender:TObject);
begin
  if qHistoire.IsEmpty then
    btnNouveauClick(Sender);
end;

procedure TFormHistoireDetail.edDateTextePropertiesChange(Sender: TObject);
var
  joursem,sDateTrans:string;
  ans,mois,jours:integer;
  Cal:TCalendrier;
begin
  btnValider.Enabled:=True;
  if doTesteDateEtJour(edDateTexte.Text,joursem,sDateTrans,ans,mois,jours,Cal) then
  begin
    edDateTexte.Font.Color:=clWindowText;
    edDateTexte.Font.Style:= [];
  end
  else
  begin
    edDateTexte.Font.Color:=clRed;
    edDateTexte.Font.Style:= [fsBold];
  end;
end;

end.

