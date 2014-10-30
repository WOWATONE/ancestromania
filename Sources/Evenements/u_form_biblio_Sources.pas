unit u_form_biblio_Sources;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, MPlayer, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,SysUtils,DB,IBQuery,u_comp_TYLanguage,StdCtrls,Dialogs,Graphics,U_ExtDBGrid,Controls,ExtCtrls,Classes,
  u_buttons_appli,
  u_framework_dbcomponents,IBUpdateSQL, ComCtrls, MaskEdit;

type

  { TFBiblio_Sources }

  TFBiblio_Sources=class(TF_FormAdapt)
    AEdit: TFWDBMemo;
    btnAjout: TFWAdd;
    btnDel: TFWDelete;
    dxDBEdit3: TFWDBEdit;
    dxDBMemo2: TFWDBMemo;
    dxDBMemo3: TFWDBMemo;
    dxDBMemo4: TFWDBMemo;
    dxDBMemo5: TFWDBMemo;
    fpBoutons: TPanel;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Language:TYLanguage;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pBorder:TPanel;
    pBoutons: TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    panDock:TPanel;
    DataSource1:TDataSource;
    pSource:TPanel;
    pMedia:TPanel;
    dxDBGrid:TExtDBGrid;
    DSMultimedia:TDataSource;
    IBMultimedia:TIBQuery;
    btnFermer:TFWClose;
    btnAppliquer:TFWOK;
    IBUMultimedia:TIBUpdateSQL;
    TabControlBiblio:TTabControl;
    procedure dxDBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure SuperFormCreate(Sender:TObject);
    procedure btnAppliquerClick(Sender:TObject);
    procedure btnAjoutClick(Sender:TObject);
    procedure btnDelClick(Sender:TObject);
    procedure dxDBGridDblClick(Sender:TObject);
    procedure DSMultimediaStateChange(Sender:TObject);
    procedure colImagePropertiesGetGraphicClass(AItem:TObject;
      ARecordIndex:Integer;APastingFromClipboard:Boolean;
      var AGraphicClass:TGraphicClass);
    procedure onTabContolBiblioDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
    procedure onTabControlBiblioChange(Sender:TObject);
    procedure dxDBMemo2KeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure dxDBMemo3KeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure dxDBMemo4KeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure dxDBMemo5KeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure dxDBMemo2DblClick(Sender: TObject);
    procedure dxDBMemo3DblClick(Sender: TObject);
    procedure dxDBMemo4DblClick(Sender: TObject);
    procedure dxDBMemo5DblClick(Sender: TObject);
    procedure DataSource1StateChange(Sender: TObject);
    procedure dxDBMemo2KeyPress(Sender: TObject; var Key: Char);
    procedure dxDBGridDBBandedTableView1EditKeyPress(
      Sender: TObject; AItem: Longint;
      AEdit: TCustomMaskEdit; var Key: Char);
  private
    fID,fIdEvent:integer;
    fTable:string;
    fFinInitialisation:boolean;
    fText:string;
    fModif:Boolean;
    bFirst:Boolean;
    fFormIndividu:TForm;
    BloqueCar:boolean;

    procedure doNewRecord(DataSet:TDataSet);

  public
    property sText:string read fText write fText;
    property Modif:boolean read fModif write fModif;
    function doOpenQuerys(iRecord_Key:Integer;sTable:string):boolean;
    property FormIndividu:TForm read fFormIndividu write fFormIndividu;
  end;

implementation

uses u_dm,
     u_common_functions,
     u_common_ancestro,
     u_common_const,
     u_form_individu,
     u_common_ancestro_functions,
     u_genealogy_context,
     fonctions_dialogs,
     u_form_main;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFBiblio_Sources.SuperFormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;

  pSource.Color:=gci_context.ColorLight;
  // Matthieu ?
//  pSource.ColorHighLight:=gci_context.ColorLight;
//   pSource.ColorShadow:=gci_context.ColorLight;
{
TabControlBiblio.tabs[0].ImageIndex:=66;
TabControlBiblio.tabs[1].ImageIndex:=66;
 }

  pSource.Align:=alClient;
  pMedia.Align:=alClient;
  bFirst:=True;

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  BloqueCar:=false;
end;

procedure TFBiblio_Sources.dxDBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s:string;
  k:integer;
begin
  with dxDBGrid do
  if SelectedColumn=Columns[1] then
  begin         { Matthieu ?
    s:=(aEdit as TMemo).Text;
    k:=(aEdit as TMemo).SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      if not(IBMultimedia.State in [dsEdit,dsInsert]) then
        IBMultimedia.Edit;
      IBMultimediaMULTI_MEMO.AsString:=s;
      (aEdit as TMemo).SelStart:=k;
      BloqueCar:=true;
    end;           }
  end;
end;

function TFBiblio_Sources.doOpenQuerys(iRecord_Key:Integer;sTable:string):boolean;
begin
  fIdEvent:=iRecord_Key;
  fTable:=sTable;
  if TFIndividu(fFormIndividu).DialogMode then
  begin
    DataSource1.AutoEdit:=false;
    DSMultimedia.AutoEdit:=false;
    pBoutons.Hide;
  end
  else
  begin
    DataSource1.AutoEdit:=true;
    DSMultimedia.AutoEdit:=true;
  end;

  with dm.IBQSources_Record do
   Begin
    Close;
    Params[0].AsInteger:=iRecord_Key;
    Params[1].AsString:=fTable;
    Open;

    if Eof then
    begin
      Insert;
      doNewRecord(dm.IBQSources_Record);
      Post;
    end;
   end;

  IBMultimedia.DisableControls;
  with IBMultimedia do
  try
    Close;
    Params[0].AsInteger:=TFIndividu(fFormIndividu).CleFiche;{Cle de l'individu}
    Params[1].AsInteger:=dm.IBQSources_Record.FieldByName ( 'ID' ).AsInteger;
    Params[2].AsString:='F';
    Open;
    btnDel.Enabled:=not IsEmpty;
  finally
    EnableControls;
  end;

  TabControlBiblio.TabIndex:=0;
  fFinInitialisation:=True;
  result:=true;

  bFirst:=False;
end;

procedure TFBiblio_Sources.doNewRecord(DataSet:TDataSet);
begin
  fID:=dm.uf_GetClefUnique('SOURCES_RECORD');
  with Dataset do
   Begin
    FieldByName('ID').AsInteger:=fID;
    FieldByName('CHANGE_DATE').AsDateTime:=Now;
    FieldByName('KLE_DOSSIER').AsInteger:=dm.NumDossier;
    FieldByName('DATA_ID').AsInteger:=fIdEvent;
    FieldByName('TYPE_TABLE').AsString:=fTable;
   end;
end;

procedure TFBiblio_Sources.btnAppliquerClick(Sender:TObject);
begin
  sText:=dxDBMemo5.Text;
  ModalResult:=mrOk;
end;

procedure TFBiblio_Sources.btnAjoutClick(Sender:TObject);
begin
  if FMain.OuvreBiblioMedias(True,dm.IBQSources_Record.FieldByName ( 'ID' ).AsInteger,'F','F')>0 then
  begin
    btnAppliquer.Enabled:=True;
    IBMultimedia.DisableControls;
    IBMultimedia.Close;
    IBMultimedia.Open;
    btnDel.Enabled:=true;
    IBMultimedia.EnableControls;
    fModif:=True;
  end;
end;

procedure TFBiblio_Sources.colImagePropertiesGetGraphicClass(AItem:TObject;
  ARecordIndex:Integer;APastingFromClipboard:Boolean;
  var AGraphicClass:TGraphicClass);
begin
  AGraphicClass:=TJPEGImage;
end;

procedure TFBiblio_Sources.btnDelClick(Sender:TObject);
begin
  if MyMessageDlg(rs_Confirm_deleting_document,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
  with IBMultimedia do
  begin
    Delete;
    btnDel.Enabled:=not IsEmpty;
    btnAppliquer.Enabled:=true;
    fModif:=true;
  end;
end;

procedure TFBiblio_Sources.dxDBGridDblClick(Sender:TObject);
begin
  with IBMultimedia do
  if Active and not IsEmpty then
    VisualiseMedia(FieldByName('multi_clef').AsInteger,dm.ReqSansCheck);
end;

procedure TFBiblio_Sources.DSMultimediaStateChange(Sender:TObject);
begin
  if DSMultimedia.State in [dsEdit,dsInsert] then
  begin
    btnAppliquer.Enabled:=true;
    fModif:=true;
  end;
end;

procedure TFBiblio_Sources.onTabContolBiblioDrawTabEx(
  AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  if ATab=ATab.PageControl.ActivePage then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
  if ATab.TabIndex=1 then
    if btnDel.Enabled then
      ATab.ImageIndex:=74
    else
      ATab.ImageIndex:=66;
end;

procedure TFBiblio_Sources.onTabControlBiblioChange(Sender:TObject);
begin
  case TabControlBiblio.TabIndex of
    0:
      begin
        pSource.Show;
        pMedia.Hide;
        pBoutons.Hide;
      end;
    1:
      begin
        pSource.Hide;
        pMedia.Show;
        pBoutons.Show;
      end;
  end;
  if TFIndividu(fFormIndividu).DialogMode then
    pBoutons.Hide;
end;

procedure TFBiblio_Sources.dxDBMemo2KeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  s:=dxDBMemo2.Text;
  k:=dxDBMemo2.SelStart;
  if dm.RemplaceRaccourcis(Key,Shift,s,k) then
  with dm.IBQSources_Record do
   begin
    if not(state in [dsEdit,dsInsert]) then
      Edit;
    FieldByName ( 'AUTH' ).AsString:=s;
    dxDBMemo2.SelStart:=k;
    BloqueCar:=true;
   end;
end;

procedure TFBiblio_Sources.dxDBMemo3KeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  s:=dxDBMemo3.Text;
  k:=dxDBMemo3.SelStart;
  if dm.RemplaceRaccourcis(Key,Shift,s,k) then
  with dm.IBQSources_Record do
   begin
    if not(state in [dsEdit,dsInsert]) then
      Edit;
    FieldByName ( 'TITL' ).AsString:=s;
    dxDBMemo3.SelStart:=k;
    BloqueCar:=true;
   end;
end;

procedure TFBiblio_Sources.dxDBMemo4KeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  s:=dxDBMemo4.Text;
  k:=dxDBMemo4.SelStart;
  if dm.RemplaceRaccourcis(Key,Shift,s,k) then
  with dm.IBQSources_Record do
   begin
    if not(state in [dsEdit,dsInsert]) then
      Edit;
    FieldByName ( 'PUBL' ).AsString:=s;
    dxDBMemo4.SelStart:=k;
    BloqueCar:=true;
   end;
end;

procedure TFBiblio_Sources.dxDBMemo5KeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
var
  s:string;
  k:integer;
begin
  s:=dxDBMemo5.Text;
  k:=dxDBMemo5.SelStart;
  if dm.RemplaceRaccourcis(Key,Shift,s,k) then
  with dm.IBQSources_Record do
   begin
    if not(state in [dsEdit,dsInsert]) then
      Edit;
    FieldByName ( 'TEXTE' ).AsString:=s;
    dxDBMemo5.SelStart:=k;
    BloqueCar:=true;
   end;
end;

procedure TFBiblio_Sources.dxDBMemo2DblClick(Sender: TObject);
begin
  ExecuteChaineDansChaine(dxDBMemo2.Text,dxDBMemo2.SelStart,dxDBMemo2.SelLength);
end;

procedure TFBiblio_Sources.dxDBMemo3DblClick(Sender: TObject);
begin
  ExecuteChaineDansChaine(dxDBMemo3.Text,dxDBMemo3.SelStart,dxDBMemo3.SelLength);
end;

procedure TFBiblio_Sources.dxDBMemo4DblClick(Sender: TObject);
begin
  ExecuteChaineDansChaine(dxDBMemo4.Text,dxDBMemo4.SelStart,dxDBMemo4.SelLength);
end;

procedure TFBiblio_Sources.dxDBMemo5DblClick(Sender: TObject);
begin
  ExecuteChaineDansChaine(dxDBMemo5.Text,dxDBMemo5.SelStart,dxDBMemo5.SelLength);
end;

procedure TFBiblio_Sources.DataSource1StateChange(Sender: TObject);
begin
  if DataSource1.State in [dsEdit,dsInsert] then
  begin
    fModif:=true;
    btnAppliquer.Enabled:=true;
  end;
end;

procedure TFBiblio_Sources.dxDBMemo2KeyPress(Sender: TObject;
  var Key: Char);
begin
  if BloqueCar then
  begin
    BloqueCar:=false;
    Key:=#0;
  end;
end;

procedure TFBiblio_Sources.dxDBGridDBBandedTableView1EditKeyPress(
  Sender: TObject; AItem: Longint;
  AEdit: TCustomMaskEdit; var Key: Char);
begin
  if BloqueCar then
  begin
    BloqueCar:=false;
    Key:=#0;
  end;
end;

end.

