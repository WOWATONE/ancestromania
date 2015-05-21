{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania GPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_Form_Patronymes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,DB,IBCustomDataSet,IBQuery,IBUpdateSQL,
  u_comp_TYLanguage,Forms,StdCtrls,Controls,Classes,
  ExtCtrls,u_buttons_appli,U_ExtDBGrid,Menus, IBSQL, u_framework_dbcomponents;

type

  { TFPatronymes }

  TFPatronymes=class(TF_FormAdapt)
    btnAdd: TFWAdd;
    btnAnnuler: TFWCancel;
    btnDel: TFWDelete;
    btnFermer: TFWClose;
    cb_patronymes: TFWDBLookupCombo;
    DataSource2: TDatasource;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    pBorder:TPanel;
    Panel7:TPanel;
    Panel5:TPanel;
    Panel6:TPanel;
    Language:TYLanguage;
    DataSource1:TDataSource;
    IBUpdateSQL:TIBUpdateSQL;
    QueryKLE_DOSSIER:TLongintField;
    Query:TIBQuery;
    QueryID:TLongintField;
    QueryID_INDI:TLongintField;
    QueryNOM:TIBStringField;
    QueryNOM_INDI:TIBStringField;
    dxDBGrid1:TExtDBGrid;
    Panel2:TPanel;
    lbTitle:TLabel;
    pmValiderTelQuel:TPopupMenu;
    mTelQuel:TMenuItem;
    QueryETENDU: TBooleanField;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    ReqDir: TIBSQL;
    ReqNames: TIBQuery;
    procedure dxDBGrid1ColExit(Sender: TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure btnDelClick(Sender:TObject);
    procedure RadioButton1Click(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure dxDBTousPropertiesButtonClick(Sender:TObject;
      AButtonIndex:Integer);
    procedure mTelQuelClick(Sender:TObject);
    procedure QueryBeforeInsert(DataSet:TDataSet);
    procedure QueryBeforePost(DataSet:TDataSet);
    procedure QueryBeforeDelete(DataSet:TDataSet);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure dxDBPatronymesHeaderClick(Sender:TObject);
    procedure QueryCalcFields(DataSet: TDataSet);
    procedure DataSource1StateChange(Sender: TObject);
    procedure QueryAfterInsert(DataSet: TDataSet);
    procedure QueryAfterDelete(DataSet: TDataSet);
    procedure QueryNewRecord(DataSet: TDataSet);
    procedure QueryAfterPost(DataSet: TDataSet);
    procedure btnAddClick(Sender:TObject;
      var Key:Word;Shift:TShiftState);
  private
    sNom:string;
    ListeComplete,bRefresh:boolean;

    procedure pmValiderTelQuelPopup(Sender: TObject);
    procedure OpenQuery;
    procedure QueryBeforeInsert(Sender: TObject);

  public
    procedure doInit(sNomPrenom,NomIndi:string);

  end;

implementation

uses  u_dm,
      u_Common_Const,
      u_common_ancestro_functions,
      u_common_functions,
      u_common_ancestro,
      Dialogs,
      fonctions_dialogs,
      fonctions_string,
      u_genealogy_context,
      SysUtils;

const CST_PATRONYMES = 1;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFPatronymes.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  OnRefreshControls:=SuperFormRefreshControls;
  Color:=gci_context.ColorLight;
  Panel2.Color:=gci_context.ColorDark;
  btnAdd.Color:=gci_context.ColorLight;
  btnDel.Color:=gci_context.ColorLight;
  btnAdd.ColorFrameFocus:=gci_context.ColorLight;
  btnDel.ColorFrameFocus:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  ReqNames.Close;
  ReqNames.Params[0].AsInteger:=dm.individu_clef;
  ReqNames.Open;
//  Application.HintHidePause:=15000;
  ListeComplete:=false;
end;

procedure TFPatronymes.doInit(sNomPrenom,NomIndi:string);
begin
  lbTitle.Caption:=rs_Caption_Surnames_associated_with+sNomPrenom;
  sNom:=NomIndi;
  RadioButton2.Caption:=rs_to_every+' "'+sNom+'"';
  Panel5.Hint:=fs_RemplaceMsg(rs_Hint_Associate_a_surname_with_a_person_permits_to_see_it_in_the_surnames_index_for,sNom);
  OpenQuery;
end;

procedure TFPatronymes.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_Associating_surnames;
end;

procedure TFPatronymes.dxDBGrid1ColExit(Sender: TObject);
begin
  if dxDBGrid1.SelectedColumn = dxDBGrid1.Columns [ CST_PATRONYMES ] Then
   with dxDBGrid1.Columns [ CST_PATRONYMES ] do
    Begin
      if not ListeComplete then
        Query.FieldByName('NOM').AsString:=fs_FormatText(Text,mftUpper);
      ListeComplete:=false;
      mTelQuel.Checked:=not mTelQuel.Checked;
    end;
end;


procedure TFPatronymes.OpenQuery;
begin
  if Query.State in [dsEdit,dsInsert] then
    if not QueryNOM.IsNull then
      Query.Post;
  Query.DisableControls;
  Query.Close;

  if RadioButton1.Checked then
  begin
    Query.SQL.Text:='select * from nom_attachement where id_indi='+IntToStr(dm.individu_clef)
       +' order by nom,nom_indi';
  end
  else //utilisation de sNom au lieu de i.NOM car le nom a pu être modifié mais non commité dans dm.IBT_BASE
  begin
    Query.SQL.Text:='select s.*'
      +',(select first(1)id from nom_attachement'
      +' where nom=s.nom and kle_dossier=s.kle_dossier and (nom_indi is null or nom_indi='+AnsiQuotedStr(sNom,'''')+')'
      +' order by nom_indi nulls last)'
      +',(select first(1)id_indi from nom_attachement'
      +' where nom=s.nom and kle_dossier=s.kle_dossier and (nom_indi is null or nom_indi='+AnsiQuotedStr(sNom,'''')+')'
      +' order by nom_indi nulls last)'
      +',(select first(1)nom_indi from nom_attachement'
      +' where nom=s.nom and kle_dossier=s.kle_dossier and (nom_indi is null or nom_indi='+AnsiQuotedStr(sNom,'''')+')'
      +' order by nom_indi nulls last)'
      +' from (select distinct a.nom,i.kle_dossier from individu i'
      +' inner join individu p on p.kle_dossier=i.kle_dossier'
      +' and p.nom='+AnsiQuotedStr(sNom,'''')
      +' inner join nom_attachement a on a.id_indi=p.cle_fiche'
      +' where i.cle_fiche='+IntToStr(dm.individu_clef)
      +') s'
      +' order by s.nom';
  end;
  Query.Open;
  Query.EnableControls;
  DoRefreshControls;
end;

procedure TFPatronymes.SuperFormRefreshControls(Sender: TObject);
begin
  btnDel.Enabled:=RadioButton1.Checked and (not Query.Eof or (Query.State in [dsInsert,dsEdit]));
  pmValiderTelQuel.AutoPopup:=btnDel.Enabled;
  btnAdd.Enabled:=RadioButton1.Checked;
  dxDBGrid1.Columns [ CST_PATRONYMES ].ReadOnly:=not btnDel.Enabled;
  if Visible then
    SendFocus(dxDBGrid1);
end;

procedure TFPatronymes.btnAddClick(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  Query.Insert;
end;

procedure TFPatronymes.QueryBeforeInsert(Sender:TObject);
begin
  if RadioButton2.Checked then//empêche l'insertion par la touche Insert
    Abort;
end;

procedure TFPatronymes.QueryBeforeInsert(DataSet: TDataSet);
begin
  if RadioButton2.Checked then
    abort
  else
    btnDel.Enabled:=true;
end;

procedure TFPatronymes.QueryNewRecord(DataSet: TDataSet);
begin
  Query.FieldByName('ID_INDI').AsInteger:=dm.individu_clef;
  Query.FieldByName('KLE_DOSSIER').AsInteger:=dm.NumDossier;
end;

procedure TFPatronymes.btnDelClick(Sender:TObject);
begin
  bRefresh:=false;
  Query.Delete;
  if not bRefresh then
    DoRefreshControls;//ajouté car before et after delete non déclenchés si enregistrement non créé physiquement
end;

procedure TFPatronymes.QueryBeforeDelete(DataSet: TDataSet);
begin
  if RadioButton2.Checked then
    Abort
  else
  begin
    if MyMessageDlg(rs_Do_you_delete_this_name
      ,mtConfirmation,[mbYes,mbNo],Self)<>mrYes then
      Abort;
  end;
end;

procedure TFPatronymes.QueryAfterInsert(DataSet: TDataSet);
 begin
  DoRefreshControls;
end;

procedure TFPatronymes.QueryBeforePost(DataSet:TDataSet);
begin
   if Trim(DataSet.FieldByName('NOM').AsString)='' then
   begin
     MyMessageDlg(rs_Error_the_name_mustnt_be_empty_or_spaces_filled
      ,mtError, [mbOk],Self);
     SendFocus(dxDBGrid1);
     Abort;
  end;

  if mTelQuel.Checked then
    mTelQuel.Checked:=false
   else
    Query.FieldByName('NOM').AsString:=fs_FormatText(QueryNOM.AsString,mftUpper,False);

  if Query.FieldByName('ID_INDI').AsInteger=dm.individu_clef then
  begin //supprimer les doublons
   with ReqDir do
    begin
      try
        SQL.Text:='delete from nom_attachement'
          +' where nom='+AnsiQuotedStr(Query.FieldByName('NOM').AsString,'''')
          +' and id<>'+Query.FieldByName('ID').AsString
          +' and id_indi='+IntToStr(dm.individu_clef);
        ExecQuery;
      finally
        Close;
      end;
    end;
   end;

  if not Query.FieldByName('NOM_INDI').IsNull then
  begin //ne garder que celui-ci pour affecter le patronyme à tous
    with ReqDir do
    begin
      try
        SQL.Text:='update nom_attachement set nom_indi=null'
          +' where nom='+AnsiQuotedStr(Query.FieldByName('NOM').AsString,'''')
          +' and id<>'+Query.FieldByName('ID').AsString
          +' and id_indi in (select cle_fiche from individu'
          +' where kle_dossier='+IntToStr(dm.NumDossier)
          +' and nom='+AnsiQuotedStr(sNom,'''')+')';
        ExecQuery;
      finally
        Close;
      end;
    end;
  end;
 end;
 
procedure TFPatronymes.QueryAfterPost(DataSet: TDataSet);
begin
  OpenQuery;
end;

procedure TFPatronymes.QueryAfterDelete(DataSet: TDataSet);
begin
  DoRefreshControls;
  bRefresh:=True;
end;

procedure TFPatronymes.RadioButton1Click(Sender:TObject);
begin
  OpenQuery;
end;

procedure TFPatronymes.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  if ModalResult=mrOK then
  begin
    if Query.State in [dsEdit,dsInsert] then
      Query.Post;
    Query.close;
    dm.IBTrans_Secondaire.CommitRetaining;
  end
  else
  begin
    Query.Close;
    dm.IBTrans_Secondaire.RollbackRetaining;
  end;
end;

procedure TFPatronymes.dxDBTousPropertiesButtonClick(Sender:TObject;
  AButtonIndex:Integer);
var
  PasTous:Boolean;
begin
  if QueryNOM_INDI.AsString=sNom then
  begin
    if not(Query.State in [dsEdit,dsInsert]) then
      Query.Edit;
    Query.FieldByName('NOM_INDI').Clear;
  end
  else
  begin
    with ReqDir do
    try
      SQL.Text:='select 1 from individu i'
        +' inner join individu p on p.nom='+AnsiQuotedStr(sNom,'''')
        +' and p.kle_dossier=i.kle_dossier'
        +' inner join nom_attachement a on a.id_indi=p.cle_fiche and a.nom_indi=i.nom'
        +' and a.nom='+AnsiQuotedStr(Query.FieldByName('NOM').AsString,'''')
        +' and a.id_indi<>'+Query.FieldByName('ID_INDI').AsString
        +' where i.cle_fiche='+IntToStr(dm.individu_clef);
      ExecQuery;
      PasTous:=Eof;
    finally
      Close;
    end;

    if PasTous then
    begin
      if not(Query.State in [dsEdit,dsInsert]) then
        Query.Edit;
      Query.FieldByName('NOM_INDI').AsString:=sNom;
    end
    else
      MyMessageDlg(rs_error_this_name_is_set_to_everybody,mtError,[mbCancel],Self);
  end;
end;

procedure TFPatronymes.mTelQuelClick(Sender: TObject);
begin
  if ListeComplete then
    ListeComplete:=false
  else
    ListeComplete:=true;
end;

procedure TFPatronymes.pmValiderTelQuelPopup(Sender: TObject);
begin
  if ListeComplete then
    mTelQuel.Checked:=true
  else
    mTelQuel.Checked:=false;
end;
{
procedure TFPatronymes.dxDBGrid1DBTableView1InitEdit(
  Sender:TObject;AItem:Longint;
  AEdit:TCustomMaskEdit);
var
  i:integer;
begin
  if (RadioButton1.Checked)and(AItem=CST_PATRONYMES) then
  begin
    TFWDBLookupCombo(AEdit).Style.ButtonStyle:=btsOffice11;
    TFWDBLookupCombo(AEdit).Style.ButtonTransparency:=ebtHideUnselected;
    if ListeComplete then
      TFWDBLookupCombo(AEdit).Items:=TFIndividu(Owner).aFIndividuIdentite.sDBENom.Items
    else
    begin
      TFWDBLookupCombo(AEdit).Items.Clear;
      with ReqDir do
      try
        SQL.Text:='select distinct a.NOM from individu i'
          +' inner join individu p on p.kle_dossier=i.kle_dossier and p.nom=i.nom'
          +' inner join nom_attachement a on a.id_indi=p.cle_fiche'
          +' where i.cle_fiche='+IntToStr(dm.FicheActive);
        ExecQuery;
        while not EOF do
        begin
          TFWDBLookupCombo(AEdit).Items.Add(Fields[0].AsString);
          next;
        end;
      finally
        Close;
      end;
    end;
    for i:=0 to TFWDBLookupCombo(AEdit).Properties.Buttons.Count-1 do
      TFWDBLookupCombo(AEdit).Properties.Buttons.Items[i].Visible:=TFWDBLookupCombo(AEdit).Items.Count>0;
  end;
end;
}
procedure TFPatronymes.dxDBPatronymesHeaderClick(Sender:TObject);
begin
  ListeComplete:=not ListeComplete;
end;

procedure TFPatronymes.QueryCalcFields(DataSet: TDataSet);
begin
  Query.FieldByName('ETENDU').AsBoolean:=QueryNOM_INDI.AsString=sNom;
end;

procedure TFPatronymes.DataSource1StateChange(Sender: TObject);
begin
  if DataSource1.State in [dsInsert,dsEdit] then
    btnAnnuler.Enabled:=True;
end;

end.

