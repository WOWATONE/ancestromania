unit u_Form_DeleteBranche;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
{$ENDIF}
  Forms,StdCtrls,u_buttons_appli,ExtJvXPButtons,
  Controls,ExtCtrls, u_extradios,
  SysUtils,Dialogs,IBSQL,IB, MaskEdit, u_ancestropictimages;

type

  { TFDeleteBranche }

  TFDeleteBranche=class(TForm)
    IATitle1: TIATitle;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Panel14: TPanel;
    Panel2:TPanel;
    Panel3: TPanel;
    Panel4:TPanel;
    btnExecute:TFWDelete;
    btnClose:TFWClose;
    Panel1:TPanel;
    Panel5:TPanel;
    Label1:TLabel;
    rgInit: TExtRadioGroup;
    rgEffet:TExtRadioGroup;
    lSQL:TMaskEdit;
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
    Panel13:TPanel;
    req:TIBSQL;
    rgMode: TExtRadioGroup;
    rgStricte: TExtRadioGroup;
    rgTemoins: TExtRadioGroup;
    procedure btnCloseClick(Sender:TObject);
    procedure FormClose(Sender:TObject;var Action:TCloseAction);
    procedure doSql(Sender:TObject);
    procedure FormCreate(Sender:TObject);
    procedure btnExecuteClick(Sender:TObject);

  private
    { Déclarations privées }
    procedure ShowStats;
  public
    { Déclarations publiques }
  end;

var
  FDeleteBranche:TFDeleteBranche;

implementation

uses  u_common_const,
      u_Dm,
      fonctions_dialogs,
      u_common_ancestro_functions,
      u_genealogy_context,u_common_ancestro;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFDeleteBranche.btnCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFDeleteBranche.FormClose(Sender:TObject;var Action:TCloseAction);
begin
//  Application.HintHidePause:=2500;
  Action:=caFree;
end;

procedure TFDeleteBranche.doSql(Sender:TObject);
begin
  lSql.Text:='SELECT * FROM PROC_GROUPE(1,'
    +IntToStr(dm.individu_clef)
    +','''+rgmode.Values[rgmode.itemindex]
    +''','''+rgStricte.Values[rgStricte.itemindex]
    +''','''+rgTemoins.Values[rgTemoins.itemindex]
    +''','''+rgInit.Values[rgInit.itemindex]
    +''','''+rgEffet.Values[rgeffet.itemindex]
    +''',''N'')';
end;

procedure TFDeleteBranche.FormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  Panel13.Color:=gci_context.ColorDark;

  rgMode.Hint:=rs_Hint_for_ancestry_d_for_descent_A_c_every_persons;
  rgStricte.Hint:=rs_Hint_Y_Yes_N_No_Y_with_A_D_N_Do_not_refuse_selection;
  rgInit.Hint:=rs_Hint_Init_Y_Empty_table_N_Do_delete_nothing_P_Delete_records_of_same_group;
  rgEffet.Hint:=rs_Hint_Affect_A_Noone_is_deleted_E_Person_not_in_the_group_are_deleted_S_Supress_persons_of_group;
  rgTemoins.Hint:=rs_Hint_Witnesses_Y_Select_also_witness_N_Not;

  //  Application.HintHidePause:=10000;
  ShowStats;

  doSql(Sender);
end;

procedure TFDeleteBranche.btnExecuteClick(Sender:TObject);
begin
  if MyMessageDlg(rs_This_action_is_minutes_longer+_CRLF+_CRLF+
    rs_Do_you_continue,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    btnExecute.Enabled:=False;
    screen.Cursor:=crHourGlass;
    try
      req.Close;
      req.SQL.Clear;
      req.SQL.Add(lSQL.Text);
      req.ExecQuery;

//      ShowMessage(req.Fields[0].Asstring);
      req.Close;

      dm.IBT_base.CommitRetaining;
        // -- On met à jour le journal -------------------------------------------------------------------
      dm.doMAJTableJournal(rs_Log_deleting_a_branch);

      ShowStats;
    except
      on E:EIBError do
        showmessage(rs_Error_Cannot_Update_Database + ' : '+E.Message);
    end;

    btnExecute.Enabled:=True;
    screen.Cursor:=crDefault;
  end;
end;

procedure TFDeleteBranche.ShowStats;
begin
  with req do
  begin
    Close;
    SQL.Clear;
    SQL.ADD('SELECT * FROM PROC_COMPTAGE(:DOSSIER)');
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
    Close;
  end;
end;

end.

