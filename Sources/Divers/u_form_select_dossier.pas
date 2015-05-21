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
unit u_form_select_dossier;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  U_FormAdapt, U_OnFormInfoIni, u_comp_TYLanguage, IBSQL, IBUpdateSQL, DB,
  IBQuery, dialogs, Controls, ExtCtrls, U_ExtDBGrid, Classes, Forms, Sysutils,
  u_buttons_appli, ExtJvXPButtons, Menus, ExtJvXPCheckCtrls, Graphics,
  u_ancestropictimages;
type

  { TFSelectDossier }

  TFSelectDossier=class(TF_FormAdapt)
    bfsbAjout: TFWAdd;
    bfsbDelete: TFWDelete;
    bfsbVideBase: TJvXPButton;
    btnCopier: TFWCopy;
    btnEdit: TJvXPButton;
    btVideDossier: TJvXPButton;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    panDock:TPanel;
    DSDossier:TDataSource;
    IBQDossier:TIBQuery;
    IBUDossier:TIBUpdateSQL;
    dxDBGListe:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    Language:TYLanguage;
    pmDossier:TPopupMenu;
    N0Nouveaudossier1:TMenuItem;
    ilDossier:TImageList;
    fpBoutons:TPanel;
    fsbSelection:TFWOK;
    bFermer:TFWClose;
    cbForcedWrites: TJvXPCheckBox;
    IBQDossier_NOMDOSSIER: TStringField;
    IBQDossierDS_LAST:TLongintField;
    IBQDossierCLE_DOSSIER:TLongintField;
    IBQDossierDS_VERROU:TLongintField;
    IBQDossierDS_FERMETURE:TDateTimeField;
    IBQDossierNOM_DOSSIER: TStringField;
    IBQDossierDS_LANGUE: TStringField;
    IBQDossierDS_INFOS: TStringField;
    IBQDossierDS_BASE_PATH: TStringField;
    IBQDossierDS_FIC_NOTES: TStringField;
    IBQDossierDS_INDICATEURS: TLongintField;
    procedure bfsbVideBaseMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SuperFormCreate(Sender:TObject);
    procedure bfsbAjoutClick(Sender:TObject);
    procedure bfsbDeleteClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure IBQDossierNewRecord(DataSet:TDataSet);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
    procedure fsbSelectionClick(Sender:TObject);
    procedure btnEditClick(Sender:TObject);
    procedure dxDBGListeDblClick(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure IBQDossierAfterScroll(DataSet:TDataSet);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure pmDossierPopup(Sender:TObject);
    procedure bFermerClick(Sender:TObject);
    procedure dxDBGListeDSInfosDrawColumnCell(
      Sender:TObject;ACanvas:TCanvas;
      AViewInfo:Longint;var ADone:Boolean);
    procedure IBQDossierCalcFields(DataSet: TDataSet);
    procedure btVideDossierClick(Sender: TObject);
    procedure cbForcedWritesClick(Sender: TObject);
  private
    fCleDossier:integer;
    fNomDossier:string;
    bDemarre:boolean;
    procedure doSelectDossier ( const ai_dossier : Integer );
    procedure doEditDossier;
    procedure up_SubMenu(Sender:TObject);
    procedure doVideSupprimeDossier(mode:integer);
  public
    //en entrée
    //en sortie
  end;
implementation
uses u_dm,
     u_form_main,
     IBServices,
     fonctions_dialogs,
     u_form_edit_dossier,u_common_const,u_common_functions,
     u_common_ancestro_functions,
     u_common_ancestro, u_genealogy_context;
{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFSelectDossier.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  pGeneral.Color:=gci_context.ColorLight;
  btnEdit.Hint:=rs_Hint_Modify_a_surname_infos_base_dir_language_of_data_notes_file;
  cbForcedWrites.Hint:=rs_Hint_Forced_writing_Modify_is_quickly_saved_but_it_slows_software;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  with dm.ReqSansCheck do
  begin
    Close;
    Transaction:=dm.IBTrans_Courte;
    dm.IBTrans_Courte.StartTransaction;
    try
      SQL.Text:='select mon$forced_writes from mon$database';
      ExecQuery;
      bDemarre:=true;
      cbForcedWrites.Checked:=Fields[0].AsInteger=1;
      bDemarre:=false;
      Close;
      dm.IBTrans_Courte.Commit;
    finally
      Transaction:=dm.IBT_BASE;
    end;
  end;
//  cbOuvrir.Checked:=gci_context.DossierOuvrir;
  fCleDossier:=-1;
  fNomDossier:='';
  IBQDossier.Open;
  IBQDossier.Locate('CLE_DOSSIER',dm.NumDossier, []);
end;

procedure TFSelectDossier.bfsbVideBaseMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  bTempo:boolean;
begin
  if MyMessageDlg(rs_Confirm_deleting_database,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    bTempo:=dm.bMajSosaActive;
    try
      doShowWorking(rs_Please_Wait);
      if IBQDossierCLE_DOSSIER.AsInteger=dm.NumDossier then
      begin
        //si le module en cours est la fenêtre individu
        if FMain.IDModuleActif=_ID_INDIVIDU then
        begin
          //On ferme les query de la fiche, sans rien demander
          FMain.aFIndividu.ForceCloseAllQuerys;
        end;
        //On ferme le module actif
        FMain.CloseModuleActif;
        if FMain.aFPostit<>nil then
          FMain.aFPostit.Close;
        dm.NumDossier:=-1;
        fNomDossier:='';
      end;
      Application.ProcessMessages;

      dm.IBT_BASE.CommitRetaining;
      dm.doActiveTriggerMajSosa(false);
      dm.DoClearDatabase;
      dm.IBT_BASE.CommitRetaining;
      doRefreshControls;
    finally
      if bTempo then
        dm.doActiveTriggerMajSosa(true);
      doCloseWorking;
    end;
    doSelectDossier(0);
  end;

end;


procedure TFSelectDossier.bfsbAjoutClick(Sender:TObject);
var
  aFEditDossier:TFEditDossier;
  i:integer;
begin
  IBQDossier.DisableControls;
  IBQDossier.Insert;
  aFEditDossier:=TFEditDossier.create(self);
  try
    i:=IBQDossierDS_INDICATEURS.AsInteger;
    aFEditDossier.DataSource.DataSet:=IBQDossier;
    aFEditDossier.cbImages.Checked:=(i and 1)=1;
    if aFEditDossier.ShowModal=mrOk then
    begin
      Application.ProcessMessages;
      if aFEditDossier.cbImages.Checked
        then IBQDossierDS_INDICATEURS.AsInteger:=i or 1
        else IBQDossierDS_INDICATEURS.AsInteger:=i and $FFFFFFFE;
      IBQDossier.Post;
    end
    else
    begin
      IBQDossier.Cancel;
    end;
  finally
    FreeAndNil(aFEditDossier);
    IBQDossier.EnableControls;
  end;
  doRefreshControls;
end;

procedure TFSelectDossier.bfsbDeleteClick(Sender:TObject);
begin
  doVideSupprimeDossier(1);
end;

procedure TFSelectDossier.SuperFormClose(Sender:TObject;var Action:TCloseAction);
begin
//  gci_context.DossierOuvrir:=cbOuvrir.Checked;
//  gci_context.ShouldSave:=true;
  
  IBQDossier.Close;
end;

procedure TFSelectDossier.IBQDossierNewRecord(DataSet:TDataSet);
begin
  IBQDossierDS_VERROU.AsInteger:=0;
  IBQDossierDS_LAST.AsInteger:=-1;
  DefContextLangue;
  IBQDossierDS_LANGUE.AsString:=gci_context.Langue;
  IBQDossierCLE_DOSSIER.AsInteger:=dm.uf_GetClefUnique('DOSSIER');
  IBQDossierDS_INDICATEURS.AsInteger:=0;
end;

procedure TFSelectDossier.SuperFormKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:ModalResult:=mrCancel;
    _KEY_HELP:p_ShowHelp(_ID_DOSSIER);
  end;
end;

procedure TFSelectDossier.fsbSelectionClick(Sender:TObject);
begin
  doSelectDossier(IBQDossierCLE_DOSSIER.AsInteger);
end;

procedure TFSelectDossier.doSelectDossier ( const ai_dossier : Integer );
begin
  //on s'assure que les modules sont fermés
  if FMain.CloseModuleActif then
  begin
    dm.IBT_BASE.CommitRetaining;
    dm.doOpenDossier(ai_dossier);
    fCleDossier:=dm.NumDossier;
    gci_context.LastNumDossier:=dm.NumDossier;
    gci_context.ShouldSave:=True;
    //on rafraichi les favoris
    FMain.RefreshFavoris;
    FMain.SuperFormRefreshControls ( FMain );
    ModalResult:=mrOk;
  end;
end;

procedure TFSelectDossier.btnEditClick(Sender:TObject);
begin
  doEditDossier;
end;

procedure TFSelectDossier.doEditDossier;
var
  aFEditDossier:TFEditDossier;
  i:integer;
begin
  IBQDossier.Edit;
  aFEditDossier:=TFEditDossier.create(self);
  try
    CentreLaFiche(aFEditDossier,self);
    i:=IBQDossierDS_INDICATEURS.AsInteger;
    aFEditDossier.DataSource.DataSet:=IBQDossier;
    aFEditDossier.cbImages.Checked:=(i and 1)=1;
    if aFEditDossier.ShowModal=mrOk then
    begin
      if aFEditDossier.cbImages.Checked then
        IBQDossierDS_INDICATEURS.AsInteger:=i or 1
      else
        IBQDossierDS_INDICATEURS.AsInteger:=i and $FFFFFFFE;
      IBQDossier.Post;
        //si c'est le dossier en cours, alors on rafraichit les infos dans FMain
      if IBQDossierCLE_DOSSIER.AsInteger=dm.NumDossier then
      begin
        fNomDossier:=IBQDossierNOM_DOSSIER.AsString;
        fPathBaseMedias:=IBQDossierDS_BASE_PATH.AsString;
        dm.FicNotes:=IBQDossierDS_FIC_NOTES.AsString;
        gci_context.Langue:=IBQDossierDS_LANGUE.AsString;
        DefContextLangue;
        gci_context.ImagesDansBase:=(IBQDossierDS_INDICATEURS.AsInteger and 1)=1;
        dm.doChargeVarSession;
        dm.InitListeAssociations;
        dm.IBQueryRefEvInd.Close;
        dm.IBQueryRefEvInd.Params[0].ASstring:=gci_context.Langue;
        dm.IBQueryRefEvInd.Open;
        _MotsClesDate.LoadMotClefDate(dm.IBQSources_Record,gci_context.Langue);
      end;
    end
    else
    begin
      IBQDossier.Cancel;
    end;
  finally
    FreeAndNil(aFEditDossier);
  end;
  doRefreshControls;
end;

procedure TFSelectDossier.dxDBGListeDblClick(Sender:TObject);
begin
    if (IBQDossier.Active)and(not IBQDossier.IsEmpty)
        and(IBQDossierCLE_DOSSIER.AsInteger<>dm.NumDossier) then
      doSelectDossier(IBQDossierCLE_DOSSIER.AsInteger);
end;

procedure TFSelectDossier.SuperFormRefreshControls(Sender:TObject);
begin
  bfsbAjout.enabled:=(IBQDossier.Active);
  bfsbDelete.enabled:=(IBQDossier.Active)and(not IBQDossier.IsEmpty);
  btnEdit.enabled:=bfsbDelete.Enabled;
end;

procedure TFSelectDossier.IBQDossierAfterScroll(DataSet:TDataSet);
begin
  doRefreshControls;
end;

procedure TFSelectDossier.SuperFormShowFirstTime(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  caption:=rs_Caption_Select_a_folder;
  doRefreshControls;
end;

procedure TFSelectDossier.pmDossierPopup(Sender:TObject);
var
  NewItem:TMenuItem;
  I,iClef:integer;
  SavePlace:TBookmark;
begin
  pmDossier.Items.Clear;
  iClef:=IBQDossierCLE_DOSSIER.AsInteger;
  i:=0;
  SavePlace:=IBQDossier.GetBookmark;
  IBQDossier.DisableControls;
  IBQDossier.First;
  NewItem:=TMenuItem.Create(Self);
  NewItem.Caption:=rs_Caption_New_folder;
  NewItem.Tag:=0;
  pmDossier.Items.Add(NewItem);
  pmDossier.Items[i].OnClick:=up_SubMenu;
  pmDossier.Items[i].ImageIndex:=5;
  inc(i);
  while not IBQDossier.Eof do
  begin
    if iClef<>IBQDossierCLE_DOSSIER.AsInteger then
    begin
      NewItem:=TMenuItem.Create(Self);
      NewItem.Caption:=IntTostr(IBQDossierCLE_DOSSIER.AsInteger)+' - '+IBQDossierNOM_DOSSIER.AsString;
      NewItem.Tag:=IBQDossierCLE_DOSSIER.AsInteger;
      pmDossier.Items.Add(NewItem);
      pmDossier.Items[i].OnClick:=up_SubMenu;
      pmDossier.Items[i].ImageIndex:=5;
      inc(i);
    end;
    IBQDossier.next;
  end;
  IBQDossier.GotoBookmark(SavePlace);
  IBQDossier.FreeBookmark(SavePlace);
  IBQDossier.EnableControls;
end;

procedure TFSelectDossier.up_SubMenu(Sender:TObject);
var
  IBCopy:TIBSQL;
begin
  if MyMessageDlg(rs_Confirm_folder_copy_in
                  +_CRLF+(sender as TMenuItem).Caption+'?',mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    screen.Cursor:=crHourglass;
    Application.ProcessMessages;
    IBCopy:=TIBSQL.Create(Self);
    try
      with IBCopy do
      begin
        DataBase:=dm.ibd_BASE;
        Transaction:=dm.IBT_BASE;
        SQL.Add('select languedifferente from proc_copie_dossier(:i_dossiers,:i_dossierc)');
        Params[0].AsInteger:=IBQDossierCLE_DOSSIER.AsInteger;
        Params[1].AsInteger:=(sender as TMenuItem).Tag;
        ExecQuery;
        if Fields[0].AsInteger=1 then
          MyMessageDlg(rs_Error_Cannot_copy_Database_Folder,mtError, [mbOK],Self);
        Close;
      end;
    Finally
      IBCopy.Free;
    end;
    dm.IBT_BASE.CommitRetaining;
    IBQDossier.Close;
    IBQDossier.open;
    IBQDossier.Last;
    screen.Cursor:=crDefault;
  end;
end;

procedure TFSelectDossier.bFermerClick(Sender:TObject);
begin
  Close;
end;

procedure TFSelectDossier.dxDBGListeDSInfosDrawColumnCell(
  Sender:TObject;ACanvas:TCanvas;
  AViewInfo:Longint;var ADone:Boolean);
begin
  ACanvas.Font.Style:=[];
end;

procedure TFSelectDossier.IBQDossierCalcFields(DataSet: TDataSet);
begin
  IBQDossier_NOMDOSSIER.AsString:=IntTostr(IBQDossierCLE_DOSSIER.AsInteger)+' - '
                                  +IBQDossierNOM_DOSSIER.AsString;
end;

procedure TFSelectDossier.doVideSupprimeDossier(mode:integer); //0 pour vider, 1 pour supprimer
var
  bTempo:boolean;
begin
  //quel est le dossier actif ?
  if MyMessageDlg(rs_Confirm_deleting_folder,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    doShowWorking(rs_Please_Wait);
    bTempo:=dm.bMajSosaActive;
    dm.doActiveTriggerMajSosa(false);
    try
      //si le module en cours est la fenêtre individu
      if FMain.IDModuleActif=_ID_INDIVIDU then
      begin
          //On ferme les query de la fiche, sans rien demander
        FMain.aFIndividu.ForceCloseAllQuerys;
      end;
      //On ferme le module actif
      FMain.CloseModuleActif;
      Application.ProcessMessages;
      dm.DoClearDossier(IBQDossierCLE_DOSSIER.AsInteger);
      if IBQDossierCLE_DOSSIER.AsInteger=dm.NumDossier then
      begin
        bFermer.Enabled:=false;
      end;
      if mode=1 then //On supprime le dossier
      begin
        //si ce dossier est le dossier en cours
        if IBQDossierCLE_DOSSIER.AsInteger=dm.NumDossier then
        begin
          if FMain.aFPostit<>nil then
            FMain.aFPostit.Close;
          dm.NumDossier:=-1;
          fNomDossier:='';
        end;
        IBQDossier.Delete;
      end;
      //On commit tout ça
      dm.IBT_BASE.CommitRetaining;
    finally
      if bTempo then
        dm.doActiveTriggerMajSosa(true);

      doCloseWorking;
    end;
  end;
  doRefreshControls;
  FMain.SuperFormRefreshControls ( FMain );
end;

procedure TFSelectDossier.btVideDossierClick(Sender: TObject);
begin
  doVideSupprimeDossier(0);
end;

procedure TFSelectDossier.cbForcedWritesClick(Sender: TObject);
var
  IBService:TIBConfigService;
  Pos:integer;
begin
  if not bDemarre then
  begin
    IBService:=TIBConfigService.Create(self);
    try
      Pos:=AnsiPos(':',gci_context.PathFileNameBdd);
      if Pos>2 then
      begin
        IBService.Protocol:=TCP;
        IBService.ServerName:=copy(gci_context.PathFileNameBdd,1,Pos-1);
        IBService.DatabaseName:=copy(gci_context.PathFileNameBdd,Pos+1,250);
      end
      else
      begin
        IBService.Protocol:=Local;
        IBService.ServerName:='';
        IBService.DatabaseName:=gci_context.PathFileNameBdd;
      end;
      IBService.LoginPrompt:=False;
      IBService.Params.Add('user_name='+_user_name);
      IBService.Params.Add('password='+_password);
      IBService.Active:=true;
      try
        IBService.SetAsyncMode(not cbForcedWrites.Checked);
        while IBService.IsServiceRunning do
          Sleep(5);
      finally
        IBService.Active:=false;
      end;
    finally
      IBService.Free;
    end;
  end;
end;

end.

