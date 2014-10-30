{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
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

unit u_Form_Groupe_Indis;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
  U_FormAdapt,Forms,SysUtils,Dialogs,Menus,DB,IBQuery,
  StdCtrls,Controls,ExtCtrls,Classes,
  u_buttons_appli,PrintersDlgs,
  U_ExtDBGrid, u_ancestropictimages,IBSQL, u_reports_components, U_OnFormInfoIni, Grids, DBGrids;

type

  { TFGroupeIndis }

  TFGroupeIndis=class(TF_FormAdapt)
    OnFormInfoIni: TOnFormInfoIni;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    DSIndis:TDataSource;
    pmExporter:TPopupMenu;
    mImprimer:TMenuItem;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    ExporterenHTML1:TMenuItem;
    SaveDialog:TSaveDialog;
    Label1:TLabel;
    dxComponentPrinter1:TPrinterSetupDialog;
    Supprimerlestris1:TMenuItem;
    N2:TMenuItem;
    N1:TMenuItem;
    NombreIndividus:TMenuItem;
    Ouvrirlafiche:TMenuItem;
    IBQIndis:TIBQuery;
    IBQIndisCLE_FICHE:TLongintField;
    IBQIndisNOM:TStringField;
    IBQIndisNAISSANCE:TStringField;
    IBQIndisDECES:TStringField;
    IBQIndisSEXE:TLongintField;
    N3:TMenuItem;
    Supprimerlafiche:TMenuItem;
    req:TIBSQL;
    fpBoutons:TPanel;
    lNomIndi:TLabel;
    GoodBtn7:TFWClose;
    btnPrint:TFWPrintGrid;
    TypeGroupe:TRadioGroup;

    procedure dxDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mImprimerClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure Image1Click(Sender:TObject);
    procedure pmExporterPopup(Sender:TObject);
    procedure Supprimerlestris1Click(Sender:TObject);
    procedure DoInit;
    procedure OuvrirlaficheClick(Sender:TObject);
    procedure TypeGroupePropertiesChange(Sender:TObject);
    procedure SupprimerlaficheClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure dxDBGrid1DBTableView1CellDblClick(
      Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure dxDBGrid1MouseEnter(Sender:TObject);
    procedure dxDBGrid1MouseLeave(Sender:TObject);
  private
    CleIndi:integer;
    NomIndi,PrenomIndi:string;
  public

  end;

implementation

uses u_dm,
     u_common_const,
     u_common_ancestro,
     u_Form_Main,
     u_common_ancestro_functions,
     u_genealogy_context,
     fonctions_components,
     fonctions_dialogs,
     rxdbgrid,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFGroupeIndis.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  dxDBGrid1.Hint:=rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns;
  Color:=gci_context.ColorLight;
  Height:=round(TControl(Owner).height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).width*gci_context.TailleFenetre/100);
  // Matthieu ?
  //   dxDBGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_GROUPE_INDIS');
  SaveDialog.InitialDir:=gci_context.PathDocs;
end;

procedure TFGroupeIndis.dxDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with dxDBGrid1 do
  if Column = SelectedColumn then
    if Canvas.Brush.Color=Color then
      Canvas.Brush.Color:=gci_context.ColorMedium;
end;

procedure TFGroupeIndis.SuperFormClose(Sender:TObject;var Action:TCloseAction);
begin
  IBQIndis.Close;
  // Matthieu ?
    //  dxDBGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_GROUPE_INDIS');
  Action:=caFree;
  DoSendMessage(Owner,'FERME_GROUPE_INDIS');
end;

procedure TFGroupeIndis.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFGroupeIndis.mImprimerClick(Sender:TObject);
begin
  btnPrintClick(Sender)
end;

procedure TFGroupeIndis.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='IndisDuGroupe.HTM';
  if SaveDialog.Execute then
  begin
    IBQIndis.DisableControls;
    try
      SavePlace:=IBQIndis.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGrid1,True,True);
    finally
      IBQIndis.GotoBookmark(SavePlace);
      IBQIndis.FreeBookmark(SavePlace);
      IBQIndis.EnableControls;
    end;
  end;
end;

procedure TFGroupeIndis.btnPrintClick(Sender:TObject);
begin
  // Matthieu
  btnPrint.DBTitle:=StringReplace(Label1.Caption,_CRLF,' ',[]);
end;

procedure TFGroupeIndis.Image1Click(Sender:TObject);
var
  i:integer;
begin
  for i:=0 to dxDBGrid1.Columns.Count-1 do
    dxDBGrid1.Columns[i].SortOrder:=smNone;
  if (IBQIndis.Active)and(not IBQIndis.IsEmpty) then
  begin
    IBQIndis.Close;
    IBQIndis.Open;
  end;
end;

procedure TFGroupeIndis.pmExporterPopup(Sender:TObject);
var
  ok:boolean;
  i:integer;
begin
  ok:=(IBQIndis.Active)and(not IBQIndis.IsEmpty);
  mImprimer.enabled:=ok;
  ExporterenHTML1.enabled:=ok;
  Ouvrirlafiche.Enabled:=ok;
  Supprimerlafiche.Enabled:=ok;
  if dxDBGrid1.SelectedRows.Count>1 then
    Supprimerlafiche.Caption:=fs_RemplaceMsg(rs_Caption_Delete_selected_person_s_files,[intToStr(dxDBGrid1.SelectedRows.Count)])
  else
    Supprimerlafiche.Caption:=rs_Caption_Delete_selected_person_s_file;

  i:=dxDBGrid1.DataSource.DataSet.RecordCount;
  case i of
    0:NombreIndividus.Visible:=false;
    1:
      begin
        NombreIndividus.Caption := rs_Caption_One_person_on_the_list;
        NombreIndividus.Visible := true;
      end;
    else
      begin
        NombreIndividus.Caption := inttostr(i)+rs_Caption_Persons_on_the_list;
        NombreIndividus.Visible := true;
      end;
  end;
end;

procedure TFGroupeIndis.Supprimerlestris1Click(Sender:TObject);
begin
  Image1Click(Sender);
end;

procedure TFGroupeIndis.DoInit;
begin
  TypeGroupe.ItemIndex:=-1;
  lNomIndi.Caption:=rs_with+' '+FMain.NomIndi+', '+FMain.PrenomIndi;
  CleIndi:=dm.individu_clef;
  NomIndi:=FMain.NomIndi;
  PrenomIndi:=FMain.PrenomIndi;
  Label1.Caption:=rs_Caption_Central_person+_CRLF+NomIndi+', '+PrenomIndi;
  IBQIndis.Close;
end;

procedure TFGroupeIndis.OuvrirlaficheClick(Sender:TObject);
begin
  dm.individu_clef:=IBQIndisCLE_FICHE.AsInteger;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
end;

procedure TFGroupeIndis.TypeGroupePropertiesChange(Sender:TObject);
const
  ReqLies='select i.cle_fiche'
    +',i.sexe'
    +',i.nom||coalesce('', ''||i.prenom,'''') as nom'
    +',coalesce(i.date_naissance||'' '','''')||coalesce(''à ''||n.ev_ind_ville,'''') as naissance'
    +',coalesce(i.date_deces||'' '','''')||coalesce(''à ''||d.ev_ind_ville,'''') as deces'
    +' from individu i'
    +' inner join ta_groupes g on g.ta_cle_fiche=i.cle_fiche and g.ta_groupe=1'
    +' left join evenements_ind n on n.ev_ind_type=''BIRT'' and n.ev_ind_kle_fiche=i.cle_fiche'
    +' left join evenements_ind d on d.ev_ind_type=''DEAT'' and d.ev_ind_kle_fiche=i.cle_fiche'
    +' order by i.nom,i.prenom';
  ReqDelies='select i.cle_fiche'
    +',i.sexe'
    +',i.nom||coalesce('', ''||i.prenom,'''') as nom'
    +',coalesce(i.date_naissance||'' '','''')||coalesce(''à ''||n.ev_ind_ville,'''') as naissance'
    +',coalesce(i.date_deces||'' '','''')||coalesce(''à ''||d.ev_ind_ville,'''') as deces'
    +' from individu i'
    +' left join evenements_ind n on n.ev_ind_type=''BIRT'' and n.ev_ind_kle_fiche=i.cle_fiche'
    +' left join evenements_ind d on d.ev_ind_type=''DEAT'' and d.ev_ind_kle_fiche=i.cle_fiche'
    +' where i.kle_dossier=:dossier'
    +' and not exists (select 1 from ta_groupes where ta_cle_fiche=i.cle_fiche and ta_groupe=1)'
    +' order by i.nom,i.prenom';
begin
  if (TypeGroupe.ItemIndex>=0)and(dm.individu_clef>0) then
  begin
    Screen.Cursor:=crSQLWait;
    Label1.Caption:=rs_Caption_Central_person+_CRLF+NomIndi+', '+PrenomIndi;
    IBQIndis.Close;
    Application.ProcessMessages;
    IBQIndis.DisableControls;
    try
      //on remplit la table TA_GROUPES
      req.Close;
      req.SQL.Clear;
      req.SQL.Add('SELECT * FROM PROC_GROUPE(1,:indi,''B'',''N'',''Y'',''Y'',''A'',''N'')');
      req.Params[0].AsInteger:=CleIndi;
      req.ExecQuery;
      req.Close;
      //on crée la liste
      if TypeGroupe.ItemIndex=0 then
      begin
        IBQIndis.SQL.Text:=ReqLies;
        Label1.Caption:=rs_Caption_Persons_linked_to+_CRLF+NomIndi+', '+PrenomIndi;
      end
      else
      begin
        IBQIndis.SQL.Text:=ReqDelies;
        IBQIndis.Params[0].AsInteger:=dm.NumDossier;
        Label1.Caption:=rs_Caption_Persons_unlinked_to+_CRLF+NomIndi+', '+PrenomIndi;
      end;
      Application.ProcessMessages;
      IBQIndis.Open;
    finally
      IBQIndis.EnableControls;
      Screen.Cursor:=crDefault;
    end;
    dxDBGrid1.SetFocus;
  end;
end;

procedure TFGroupeIndis.SupprimerlaficheClick(Sender:TObject);
var
  sMessage:string;
  i:integer;
  L:array of Integer;
  Fermer:boolean;
begin
  if FMain.IDModuleActif=_ID_INDIVIDU then
  begin
    if FMain.aFIndividu.TestFicheIsModified then
    begin
      MyMessageDlg(rs_Error_Must_record_file_before_deleting,mtWarning, [mbOk],Self);
      exit;
    end;
  end;

  SetLength(L,dxDBGrid1.SelectedRows.Count);
  if Length(L)>1 then
    sMessage:=fs_RemplaceMsg(rs_Confirm_deleting_selected_files,[intToStr(Length(L))])
  else
    sMessage:=rs_Confirm_deleting_selected_file;
  if MyMessageDlg(sMessage,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    dxDBGrid1.DataSource.DataSet.DisableControls;
    Fermer:=False;
    screen.Cursor:=crSQLWait;
    Application.ProcessMessages;
    try
      for i:=0 to Length(L)-1 do
        Begin
          dxDBGrid1.DataSource.DataSet.GotoBookMark(dxDBGrid1.SelectedRows[i]);
          L[i]:=dxDBGrid1.DataSource.DataSet.FieldByName('CLE_FICHE').AsInteger;
        end;
      IBQIndis.Close;
      req.Close;
      req.SQL.Text:='delete from individu where CLE_FICHE=:CLE_FICHE';
      for i:=0 to Length(L)-1 do
      begin
        if L[i]=CleIndi then
          Fermer:=True;
        req.Params[0].AsInteger:=L[i];
        req.ExecQuery;
      end;
      req.Close;
      dm.IBT_base.CommitRetaining;
      fMain.RefreshFavoris;
    finally
      dxDBGrid1.DataSource.DataSet.EnableControls;
      screen.Cursor:=crDefault;
    end;
    if FMain.IDModuleActif=_ID_INDIVIDU then
    begin //réinitialiser la fiche principale, un de ses liens de l'individu en cours peut être supprimé
      DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
    end;
    if Fermer then
    begin
      Close //si l'individu de départ disparait on ne peut plus constituer de groupe à partir de lui.
    end
    else
    begin
      TypeGroupe.ItemIndex:=-1;//réinitialise
      Label1.Caption:=rs_Caption_Central_person+_CRLF+NomIndi+', '+PrenomIndi;
      Show;//ramene le focus
    end;
  end;
end;

procedure TFGroupeIndis.SuperFormShowFirstTime(Sender:TObject);
begin
  caption:=rs_Caption_Persons_linked_or_linked_with_central_person;
end;

procedure TFGroupeIndis.dxDBGrid1DBTableView1CellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  OuvrirlaficheClick(Sender);
end;

procedure TFGroupeIndis.dxDBGrid1MouseEnter(Sender:TObject);
begin
  // Matthieu : Pas de style
//  dm.ControleurHint.HintStyle.Standard:=true;
end;

procedure TFGroupeIndis.dxDBGrid1MouseLeave(Sender:TObject);
begin
//  dm.ControleurHint.HintStyle.Standard:=false;
end;

end.

