unit u_Form_DeleteImportGedcom;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf,
  Forms, Controls, ExtCtrls, Dialogs, IB, SysUtils, StdCtrls,
  u_buttons_appli, Classes, DB, IBCustomDataSet, IBQuery,
  IBSQL, u_ancestropictimages, Grids, DBGrids;

type

  { TFDeleteImportGedcom }

  TFDeleteImportGedcom=class(TForm)
    IATitle1: TIATitle;
    Label1: TLabel;
    Label17: TLabel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel2:TPanel;
    Panel3:TPanel;
    Panel4:TPanel;
    btnExecute:TFWErase;
    btnClose:TFWClose;
    ibQImport:TIBQuery;
    dsImport:TDataSource;
    ibQImportIG_ID:TLongintField;
    ibQImportIG_PATH:TIBStringField;
    ibQImportIG_DATE:TDateTimeField;
    Panel1:TPanel;
    Panel11:TPanel;
    Label3:TLabel;
    Label4:TLabel;
    Label5:TLabel;
    Label6:TLabel;
    Label7:TLabel;
    Label8:TLabel;
    Label9:TLabel;
    Label10:TLabel;
    Label11:TLabel;
    Label12:TLabel;
    Label13:TLabel;
    Label14:TLabel;
    Label15:TLabel;
    Label16:TLabel;
    lHommes:TLabel;
    lFemmes:TLabel;
    lIndeter:TLabel;
    lUnions:TLabel;
    lEveInd:TLabel;
    lEveFam:TLabel;
    lAdresses:TLabel;
    lPatronymes:TLabel;
    lImages:TLabel;
    lPays:TLabel;
    lRegions:TLabel;
    lDepts:TLabel;
    lVilles:TLabel;
    lIndividus:TLabel;
    Panel8:TPanel;
    Panel6:TPanel;
    Panel7:TPanel;
    Panel9:TPanel;
    Panel10:TPanel;
    Panel12:TPanel;
    Panel5:TPanel;
    Panel13:TPanel;
    cxRadioGroup1:TRadioGroup;
    cxGrid1:TDBGrid;
    IBQPurgeImport:TIBSQL;
    procedure btnCloseClick(Sender:TObject);
    procedure cxGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TDBGridColumns; State: TGridDrawState);
    procedure FormClose(Sender:TObject;var Action:TCloseAction);
    procedure FormCreate(Sender:TObject);
    procedure btnExecuteClick(Sender:TObject);
    procedure FormActivate(Sender:TObject);
    procedure ShowStats;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    bModif:boolean;
  end;

var
  FDeleteImportGedcom:TFDeleteImportGedcom;

implementation

uses  u_Common_Const,
      u_Dm,
      fonctions_dialogs,
      u_common_ancestro_functions,
      u_genealogy_context,u_common_ancestro;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFDeleteImportGedcom.FormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  cxRadioGroup1.Color:=gci_context.ColorLight;
  bModif:=False;
  ibQImport.ParamByName('dossier').AsInteger:=dm.NumDossier;
  ibQImport.Open;
  btnExecute.Enabled:=not ibQImport.IsEmpty;
  cxRadioGroup1.itemindex:=0;
  ShowStats;
end;

procedure TFDeleteImportGedcom.FormClose(Sender:TObject;var Action:TCloseAction);
begin
  ibQImport.Close;
end;

procedure TFDeleteImportGedcom.btnCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFDeleteImportGedcom.cxGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TDBGridColumns; State: TGridDrawState);
begin
  if cxGrid1.Columns [ DataCol ] = cxGrid1.SelectedColumn then
    if cxGrid1.Canvas.Brush.Color=cxGrid1.Color then
      cxGrid1.Canvas.Brush.Color:=gci_context.ColorMedium;
end;

procedure TFDeleteImportGedcom.btnExecuteClick(Sender:TObject);
  function SupprimeImport:boolean;
  var
    infos:string;
  begin
    result:=true;
    try
      IBQPurgeImport.ExecQuery;
      infos:=IBQPurgeImport.FieldByName('INFO').AsString;
      IBQPurgeImport.Close;
      Screen.cursor:=crDefault;
      MyMessageDlg(infos,mtInformation, [mbOK],self);
    except
      on E:EIBError do
      begin
        Screen.cursor:=crDefault;
        MyMessageDlg(rs_Error+_CRLF+E.Message,mtError, [mbCancel],Self);
        dm.IBT_base.rollbackRetaining;
        result:=false;
      end;
    end;
  end;
begin
  if MyMessageDlg(rs_This_action_is_minutes_longer+_CRLF+_CRLF+
    rs_Do_you_continue,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    Screen.cursor:=crSQLWait;
    Application.ProcessMessages;
    IBQPurgeImport.Close;
    IBQPurgeImport.SQL.Text:='select info from proc_purge_import_gedcom(:i_clef,:i_mode)';
    try
      dm.doMAJTableJournal(rs_Log_deleting_the_importation+ibQImportIG_PATH.AsString);

      IBQPurgeImport.Params[0].AsInteger:=ibQImportIG_ID.AsInteger;
      IBQPurgeImport.Params[1].AsInteger:=cxRadioGroup1.itemindex+1;
      ibQImport.DisableControls;
      ibQImport.Close;
      if SupprimeImport then
      begin
        Screen.cursor:=crSQLWait;
        Application.ProcessMessages;
      end
      else
        exit;

      if cxRadioGroup1.itemindex<2 then
      begin
        IBQPurgeImport.Params[1].AsInteger:=3;
        if SupprimeImport then
        begin
          Screen.cursor:=crSQLWait;
          Application.ProcessMessages;
        end
        else
          exit;
      end;

      dm.IBT_base.CommitRetaining;
      dm.doCloseDatabase;
      dm.doOpenDatabase;
      ibQImport.Open;
      ibQImport.EnableControls;

      cxGrid1.SetFocus;
      ShowStats;
      btnExecute.Enabled:= not ibQImport.IsEmpty;
      bModif:=True;
    finally
      Screen.cursor:=crDefault;
    end;
  end;
end;

procedure TFDeleteImportGedcom.FormActivate(Sender:TObject);
begin
  cxGrid1.SetFocus;
end;

procedure TFDeleteImportGedcom.ShowStats;
begin
  doShowWorking(rs_Please_Wait);
  try
    with IBQPurgeImport do
    begin
      Close;
      SQL.Text:='SELECT * FROM PROC_COMPTAGE(:DOSSIER)';
      Params[0].AsInteger:=dm.NumDossier;
      ExecQuery;
      while not Eof do
      begin
        if FieldByName('LIBELLE').AsString='INDIVID' then
          lIndividus.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='TUNIONS' then
          lUnions.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='_HOMMES' then
          lHommes.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='_FEMMES' then
          lFemmes.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='INDETER' then
          lIndeter.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='EVE_IND' then
          lEveInd.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='EVE_FAM' then
          lEveFam.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='_VILLES' then
          lVilles.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='PATRONY' then
          lPatronymes.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='___PAYS' then
          lPays.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='REGIONS' then
          lRegions.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='DEPARTE' then
          lDepts.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='MULTIME' then
          lImages.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='ADRESSE' then
          lAdresses.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger);
        next;
      end;
    end;
  finally
    IBQPurgeImport.Close;
    doCloseWorking;
  end;
end;


end.

