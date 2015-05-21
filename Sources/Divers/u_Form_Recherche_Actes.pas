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

unit u_Form_Recherche_Actes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,SysUtils,graphics,Dialogs,Menus,DB,IBQuery,
  StdCtrls,Controls,ExtCtrls,U_ExtDBGrid,Classes,ExtJvXPCheckCtrls,
  IBDatabase, u_reports_components, MaskEdit,
  PrintersDlgs, u_ancestropictimages,
  u_buttons_appli, U_OnFormInfoIni, Grids, DBGrids;

type

  { TFRechercheActes }

  TFRechercheActes=class(TF_FormAdapt)
    btnActualiser: TFWRefresh;
    btnFermer: TFWClose;
    btnPrint: TFWPrintGrid;
    cbAbsents: TJvXPCheckbox;
    cbChercher: TJvXPCheckbox;
    cbDemandes: TJvXPCheckbox;
    cbIgnorer: TJvXPCheckbox;
    cbSosa: TJvXPCheckbox;
    cbTrouves: TJvXPCheckbox;
    edDepuis: TMaskEdit;
    edJusque: TMaskEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    IBQActes:TIBQuery;
    DSActes:TDataSource;
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
    IBQActesEVENEMENT:TStringField;
    IBQActesNOMS:TStringField;
    IBQActesPARENT_H:TStringField;
    IBQActesPARENT_F:TStringField;
    IBQActesDATE:TStringField;
    IBQActesANNEE:TLongintField;
    IBQActesVILLE:TStringField;
    IBQActesSUBDIVISION:TStringField;
    IBQActesDEPARTEMENT:TStringField;
    IBQActesREGION:TStringField;
    IBQActesPAYS:TStringField;
    IBQActesTYPE_TABLE:TStringField;
    IBQActesNOTES:TMemoField;
    IBQActesNIP:TLongintField;
    IBQActesCODE_EV:TLongintField;
    IBQActesACTE:TStringField;
    Supprimerlestris1:TMenuItem;
    N2:TMenuItem;
    N1:TMenuItem;
    Ajouterlesnotes:TMenuItem;
    N4:TMenuItem;
    NombreEvenements:TMenuItem;
    Ouvrirlafiche:TMenuItem;
    IBTransactionPropre:TIBTransaction;
    fpBoutons:TPanel;
    cxGroupBox1:TGroupBox;
    procedure dxDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure pGlobalClick(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mImprimerClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure Image1Click(Sender:TObject);
    procedure pmExporterPopup(Sender:TObject);
    procedure Supprimerlestris1Click(Sender:TObject);
    procedure AjouterlesnotesClick(Sender:TObject);
    procedure OuvrirlaficheClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure dxDBGrid1DBTableView1CellDblClick(
      Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure dxDBGrid1MouseEnter(Sender:TObject);
    procedure dxDBGrid1MouseLeave(Sender:TObject);
    procedure cbAbsentsPropertiesEditValueChanged(Sender:TObject);
    procedure btnActualiserClick(Sender:TObject);
  private
    procedure ActualiserBtn(Valeur:boolean);
  public

  end;

implementation

uses u_dm,u_common_const,u_common_ancestro,
     u_common_ancestro_functions,
     fonctions_dialogs,
     u_genealogy_context,IB,IniFiles,fonctions_init,fonctions_components,rxdbgrid;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFRechercheActes.SuperFormCreate(Sender:TObject);
var
  fIni:TIniFile;
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  dxDBGrid1.Hint:=rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns;
  pGeneral.Color:=gci_context.ColorLight;
  SaveDialog.InitialDir:=gci_context.PathDocs;
  cbAbsents.Checked:=false;
  cbDemandes.Checked:=false;
  cbChercher.Checked:=false;
  cbTrouves.Checked:=false;
  cbIgnorer.Checked:=false;
  fIni:=f_GetMemIniFile;
  { Matthieu : Dans le OnFormInfoIni
  try
    fIni.RootKey:=HKEY_CURRENT_USER;
    if fIni.OpenKey(gci_context.Keyfonctions_init,true) then
    begin
      Height:=fIni.ReadInteger('W_LISTE_ACTES','Hauteur',600);
      Width:=fIni.ReadInteger('W_LISTE_ACTES','Largeur',800);
      Top:=fIni.ReadInteger('W_LISTE_ACTES','Haut',0);
      Left:=fIni.ReadInteger('W_LISTE_ACTES','Gauche',0);
      edDepuis.Text:=fIni.ReadString('W_LISTE_ACTES','Depuis','');
      edJusque.Text:=fIni.ReadString('W_LISTE_ACTES','Jusque','');
      cbSosa.Checked:=fIni.ReadBool('W_LISTE_ACTES','Sosas',False);
    end;
  finally
    fIni.CloseKey;
  end;
  dxDBGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_LISTE_ACTES');
  dxComponentPrinter1Link1.OptionsPreview.Visible:=dxDBGrid1DBTableView1.Preview.Visible;}
  //FMain.MemeMoniteur(self);
end;

procedure TFRechercheActes.dxDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with dxDBGrid1 do
  if Column = SelectedColumn then
    if Canvas.Brush.Color=Color then
      Canvas.Brush.Color:=gci_context.ColorMedium;

end;

procedure TFRechercheActes.pGlobalClick(Sender: TObject);
begin

end;

procedure TFRechercheActes.SuperFormShowFirstTime(Sender:TObject);
begin
  caption:=rs_List_of_acts_by_type;
end;

procedure TFRechercheActes.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFRechercheActes.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
var
  fIni:TIniFile;
begin
  btnFermer.Enabled:=false;
  try
    IBQActes.Close;
    if IBTransactionPropre.Active then
      IBTransactionPropre.Commit;
  except
    if IBTransactionPropre.Active then
      IBTransactionPropre.Rollback;
    //évite la propagation de l'erreur
  end;
// Matthieu : ?
// dxDBGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_LISTE_ACTES',true, [gsoUseFilter]);
  fIni:=f_GetMemIniFile;
 { try
    fIni.RootKey:=HKEY_CURRENT_USER;
    if fIni.OpenKey(gci_context.Keyfonctions_init,true) then
    begin
      fIni.WriteInteger('W_LISTE_ACTES','Hauteur',Height);
      fIni.WriteInteger('W_LISTE_ACTES','Largeur',Width);
      fIni.WriteInteger('W_LISTE_ACTES','Haut',Top);
      fIni.WriteInteger('W_LISTE_ACTES','Gauche',Left);
      fIni.WriteString('W_LISTE_ACTES','Depuis',edDepuis.Text);
      fIni.WriteString('W_LISTE_ACTES','Jusque',edJusque.Text);
      fIni.WriteBool('W_LISTE_ACTES','Sosas',cbSosa.Checked);
    end;
  finally
    fIni.CloseKey;
  end;}
  Action:=caFree;
  DoSendMessage(Owner,'FERME_RECHERCHE_ACTES');
end;

procedure TFRechercheActes.mImprimerClick(Sender:TObject);
begin
  btnPrintClick(Sender)
end;

procedure TFRechercheActes.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Liste_des_Actes_par_type.HTM';
  if SaveDialog.Execute then
  begin
    IBQActes.DisableControls;
    try
      SavePlace:=IBQActes.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGrid1,True,True);
    finally
      IBQActes.GotoBookmark(SavePlace);
      IBQActes.FreeBookmark(SavePlace);
      IBQActes.EnableControls;
    end;
  end;
end;

procedure TFRechercheActes.btnPrintClick(Sender:TObject);
begin
  // Matthieu
  btnPrint.DBTitle:=Caption;
end;

procedure TFRechercheActes.Image1Click(Sender:TObject);
var
  i:integer;
begin
  for i:=0 to dxDBGrid1.Columns.Count-1 do
    dxDBGrid1.Columns[i].SortOrder:=smNone;
  if (IBQActes.Active)and(not IBQActes.IsEmpty) then
  begin
    IBQActes.Close;
    IBQActes.Open;
  end;
end;

procedure TFRechercheActes.pmExporterPopup(Sender:TObject);
var
  ok:boolean;
  i:integer;
begin
  ok:=(IBQActes.Active)and(not IBQActes.IsEmpty);
  mImprimer.enabled:=ok;
  ExporterenHTML1.enabled:=ok;
  Ouvrirlafiche.Enabled:=ok;

{  if dxDBGrid1DBTableView1.DataController.Filter.IsEmpty then
    i:=dxDBGrid1DBTableView1.DataController.DataSetRecordCount
  else}
    i:=dxDBGrid1.DataSource.DataSet.RecordCount;

  case i of
    0:NombreEvenements.Visible:=false;
    1:
      begin
        NombreEvenements.Caption:=rs_Caption_One_eandvent_on_the_list;
        NombreEvenements.Visible:=true;
      end;
    else
      begin
        NombreEvenements.Caption:=inttostr(i)+rs_Caption_eandvents_on_the_list;
        NombreEvenements.Visible:=true;
      end;
  end;
end;

procedure TFRechercheActes.Supprimerlestris1Click(Sender:TObject);
begin
  Image1Click(Sender);
end;

procedure TFRechercheActes.AjouterlesnotesClick(Sender:TObject);
begin
  Ajouterlesnotes.Checked:=not Ajouterlesnotes.Checked;

  { Matthieu ?
  if Ajouterlesnotes.Checked then
    dxDBGrid1DBTableView1.Preview.Visible:=True
  else
    dxDBGrid1DBTableView1.Preview.Visible:=False;
  dxComponentPrinter1Link1.OptionsPreview.Visible:=dxDBGrid1DBTableView1.Preview.Visible;}
end;

procedure TFRechercheActes.OuvrirlaficheClick(Sender:TObject);
begin
  dm.individu_clef:=IBQActesNIP.AsInteger;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
end;

procedure TFRechercheActes.dxDBGrid1DBTableView1CellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  OuvrirlaficheClick(sender);
end;


procedure TFRechercheActes.dxDBGrid1MouseEnter(Sender:TObject);
begin
  // Matthieu Plus tard
  //dm.ControleurHint.HintStyle.Standard:=true;
end;

procedure TFRechercheActes.dxDBGrid1MouseLeave(Sender:TObject);
begin
  //dm.ControleurHint.HintStyle.Standard:=false;
end;

procedure TFRechercheActes.ActualiserBtn(Valeur:boolean);
var
  couleur:TColor;
begin
  if valeur and(cbAbsents.Checked or cbDemandes.Checked or cbChercher.Checked
    or cbTrouves.Checked or cbIgnorer.Checked) then
  begin
    couleur:=clRed;
    btnActualiser.Font.Style:= [fsBold];
  end
  else
  begin
    couleur:=clDefault;
    btnActualiser.Font.Style:= [];
  end;
  btnActualiser.Font.Color:=couleur;
end;

procedure TFRechercheActes.cbAbsentsPropertiesEditValueChanged(
  Sender:TObject);
begin
  ActualiserBtn(True);
end;

procedure TFRechercheActes.btnActualiserClick(Sender:TObject);
  procedure NettoieTout;
  begin
    if IBQActes.Active then
      IBQActes.Close;
    if IBTransactionPropre.Active then
      IBTransactionPropre.RollbackRetaining;
  end;

const
  conseil=_CRLF+'Réessayez en limitant la période et/ou les types d''actes à lister.';

  req_part1='select * from (select case e.ev_ind_type'
    +'   when ''EVEN'' then e.ev_ind_titre_event'
    +'   else r.ref_eve_lib_long end as EVENEMENT'
    +' ,i.nom||coalesce('', ''||i.prenom,'''') as NOMS'
    +' ,p.nom||coalesce('', ''||p.prenom,'''') as PARENT_H'
    +' ,m.nom||coalesce('', ''||m.prenom,'''') as PARENT_F'
    +' ,e.ev_ind_date_writen as "DATE"'
    +' ,e.ev_ind_date_year as ANNEE'
    +' ,e.ev_ind_ville as VILLE'
    +' ,e.ev_ind_dept as DEPARTEMENT'
    +' ,e.ev_ind_subd as SUBDIVISION'
    +' ,e.ev_ind_region as REGION'
    +' ,e.ev_ind_pays as PAYS'
    +' ,e.ev_ind_comment as NOTES'
    +' ,i.cle_fiche as NIP'
    +' ,e.ev_ind_clef as CODE_EV'
    +' ,''I'' as TYPE_TABLE'
    +' ,case e.ev_ind_acte when 1 then ''T'' when -1 then ''D'' when -2 then ''C'' '
    +'    when -3 then ''I'' else ''A'' end as ACTE'
    +' from dossier ds'
    +' inner join individu i on i.kle_dossier=ds.cle_dossier'
    +' left join individu p on p.cle_fiche=i.cle_pere'
    +' left join individu m on m.cle_fiche=i.cle_mere'
    +' inner join evenements_ind e on e.ev_ind_kle_fiche=i.cle_fiche';

  req_part3=' inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type and r.ref_eve_langue=ds.ds_langue'
    +' Where ds.cle_dossier=:dossier';

  req_part5=' union'
    +' select case ef.ev_fam_type'
    +'   when ''EVEN'' then ef.ev_fam_description'
    +'   else r.ref_eve_lib_long end'
    +' ,i.nom||coalesce('', ''||i.prenom,'''')||'' X ''||f.nom||coalesce('', ''||f.prenom,'''')'
    +' ,case when pm.nom is null and pm.prenom is null and mm.nom is null and mm.prenom is null then null'
    +' else coalesce(pm.nom||coalesce('', ''||pm.prenom,''''),''?'')'
    +'||'' X ''||coalesce(mm.nom||coalesce('', ''||mm.prenom,''''),''?'')end'
    +' ,case when pf.nom is null and pf.prenom is null and mf.nom is null and mf.prenom is null then null'
    +' else coalesce(pf.nom||coalesce('', ''||pf.prenom,''''),''?'')'
    +'||'' X ''||coalesce(mf.nom||coalesce('', ''||mf.prenom,''''),''?'')end'
    +' ,ef.ev_fam_date_writen'
    +' ,ef.ev_fam_date_year'
    +' ,ef.ev_fam_ville'
    +' ,ef.ev_fam_dept'
    +' ,ef.ev_fam_subd'
    +' ,ef.ev_fam_region'
    +' ,ef.ev_fam_pays'
    +' ,ef.ev_fam_comment'
    +' ,i.cle_fiche'
    +' ,ef.ev_fam_clef'
    +' ,''F'''
    +' ,case ef.ev_fam_acte when 1 then ''T'' when -1 then ''D'' when -2 then ''C'' '
    +'    when -3 then ''I'' else ''A'' end'
    +' from dossier ds'
    +',t_union u'
    +' inner join individu i on i.cle_fiche=u.union_mari and i.kle_dossier=ds.cle_dossier'
    +' inner join individu f on f.cle_fiche=u.union_femme and f.kle_dossier=ds.cle_dossier'
    +' left join individu pm on pm.cle_fiche=i.cle_pere'
    +' left join individu mm on mm.cle_fiche=i.cle_mere'
    +' left join individu pf on pf.cle_fiche=f.cle_pere'
    +' left join individu mf on mf.cle_fiche=f.cle_mere'
    +' inner join evenements_fam ef on ef.ev_fam_kle_famille=u.union_clef';

  req_part7=' inner join ref_evenements r on r.ref_eve_lib_court=ef.ev_fam_type and r.ref_eve_langue=ds.ds_langue'
    +' Where ds.cle_dossier=:dossier';

  req_fin=') order by 8,7,6,2';

var
  s,req_part2,req_part4,req_part6,req_part8:string;
  l:integer;
begin
  if not(cbAbsents.Checked or cbDemandes.Checked or cbChercher.Checked
    or cbTrouves.Checked or cbIgnorer.Checked) then
  begin
    MyMessageDlg(rs_Error_Must_Select_one_record_s_type_to_list,mtError, [mbOK],Self);
    exit;
  end;
  IBQActes.Close;
  Screen.Cursor:=crSQLWait;
  Label1.Caption:=rs_Searching_in_progress;
  Application.ProcessMessages;
  with IBQActes do
   try
    DisableControls;
    try
      try
        req_part2:=' and (';
        l:=Length(req_part2);
        s:=rs_Records + ' ';
        if cbAbsents.Checked then
        begin
          req_part2:=req_part2+'?=0 or ? is null';
          s:=s+rs_missing;
        end;
        if cbDemandes.Checked then
        begin
          if Length(req_part2)=l then
          begin
            req_part2:=req_part2+'?=-1';
            s:=s+rs_asked;
          end
          else
          begin
            req_part2:=req_part2+' or ?=-1';
            s:=s+', '+ rs_asked;
          end;
        end;
        if cbChercher.Checked then
        begin
          if Length(req_part2)=l then
          begin
            req_part2:=req_part2+'?=-2';
            s:=s+rs_to_search;
          end
          else
          begin
            req_part2:=req_part2+' or ?=-2';
            s:=s+', '+rs_to_search;
          end;
        end;
        if cbTrouves.Checked then
        begin
          if Length(req_part2)=l then
          begin
            req_part2:=req_part2+'?=1';
            s:=s+rs_found;
          end
          else
          begin
            req_part2:=req_part2+' or ?=1';
            s:=s+', '+rs_found;
          end;
        end;
        if cbIgnorer.Checked then
        begin
          if Length(req_part2)=l then
          begin
            req_part2:=req_part2+'?=-3';
            s:=s+rs_to_ignore;
          end
          else
          begin
            req_part2:=req_part2+' or ?=-3';
            s:=s+', '+rs_to_ignore;
          end;
        end;
        s:=s+'.';
        req_part2:=req_part2+')';
        req_part6:=req_part2;
        req_part2:=StringReplace(req_part2,'?','e.ev_ind_acte', [rfReplaceAll]);
        req_part6:=StringReplace(req_part6,'?','ef.ev_fam_acte', [rfReplaceAll]);
        if cbSosa.Checked then
        begin
          req_part4:=' and  i.num_sosa>0';
          req_part8:=' and (i.num_sosa>0 or f.num_sosa>0)';
        end
        else
        begin
          req_part4:='';
          req_part8:='';
        end;
        if length(edDepuis.Text)>0 then
        begin
          req_part4:=req_part4+' and e.ev_ind_date_year>='+edDepuis.Text;
          req_part8:=req_part8+' and ef.ev_fam_date_year>='+edDepuis.Text;
        end;
        if length(edJusque.Text)>0 then
        begin
          req_part4:=req_part4+' and e.ev_ind_date_year<='+edJusque.Text;
          req_part8:=req_part8+' and ef.ev_fam_date_year<='+edJusque.Text;
        end;
        SQL.Text:=req_part1+req_part2+req_part3+req_part4
          +req_part5+req_part6+req_part7+req_part8+req_fin;
        ParamByName('dossier').AsInteger:=dm.NumDossier;
        try
          Open;
          ActualiserBtn(False);
          Last;
          First;
        except
          on E:EIBError do begin
            NettoieTout;
            MyMessageDlg(rs_Error_Firebird + rs_while_Executing_request +_CRLF
              +E.Message+conseil
              ,mtError, [mbOK],Self);
            end;
          on E:EOutOfMemory do begin
            NettoieTout;
            MyMessageDlg(rs_Error_memory + rs_while_Executing_request +_CRLF
              +E.Message+conseil
              ,mtError, [mbOK],Self);
            end;
          on E:EOutOfResources do begin
            NettoieTout;
            MyMessageDlg(rs_Error_overflow_capacity + rs_while_Executing_request +_CRLF
              +E.Message+conseil
              ,mtError, [mbOK],Self);
            end;
          else begin
            NettoieTout;
            MyMessageDlg(rs_Error_unknown + rs_while_Executing_request +_CRLF+conseil
              ,mtError, [mbOK],Self);
            end;
        end;
      finally
        EnableControls;
      end;
      Label1.Caption:=s;
      dxDBGrid1.DataSource.DataSet.First;
    except
      on E:EIBError do begin
        NettoieTout;
        MyMessageDlg(rs_Error_Firebird + rs_while_showing+_CRLF
          +E.Message+conseil
          ,mtError, [mbOK],Self);
        end;
      on E:EOutOfMemory do begin
      NettoieTout;
        MyMessageDlg(rs_Error_memory + rs_while_showing+_CRLF
          +E.Message+conseil
          ,mtError, [mbOK],Self);
        end;
      on E:EOutOfResources do begin
        NettoieTout;
        MyMessageDlg(rs_Error_overflow_capacity + rs_while_showing+_CRLF
          +E.Message+conseil
          ,mtError, [mbOK],Self);
        end;
      else begin
        NettoieTout;
        MyMessageDlg(rs_Error_unknown + rs_while_showing+_CRLF+conseil
          ,mtError, [mbOK],Self);
        end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
end;

end.

