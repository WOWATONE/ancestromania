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

unit u_Form_Individu_Sur_Favoris;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt, U_OnFormInfoIni,u_comp_TYLanguage,
  Dialogs,Menus,DB,IBCustomDataSet,IBQuery,StdCtrls,Controls,
  ExtCtrls,Classes,Forms,
  u_ancestropictimages,
  U_ExtDBGrid,u_buttons_appli,ExtJvXPButtons, 
    PrintersDlgs, Grids, DBGrids;

type

  { TFIndividusSurFavoris }

  TFIndividusSurFavoris=class(TF_FormAdapt)
    OnFormInfoIni1: TOnFormInfoIni;
    pGeneral:TPanel;
    pGlobal:TPanel;
    fpBoutons:TPanel;
    pBottom:TPanel;
    IBQIndiSurVille:TIBQuery;
    DSIndiSurVille:TDataSource;
    pmGrille: TPopupMenu;
    mFiche:TMenuItem;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    N1:TMenuItem;
    ExporterenHTML1:TMenuItem;
    SaveDialog:TSaveDialog;
    Language:TYLanguage;
    Label1:TLabel;
    IBQIndiSurVilleCLE_FICHE:TLongintField;
    IBQIndiSurVilleNOM:TIBStringField;
    IBQIndiSurVillePRENOM:TIBStringField;
    IBQIndiSurVilleDATE_NAISSANCE:TIBStringField;
    IBQIndiSurVilleCP: TIBStringField;
    IBQIndiSurVilleVILLE: TIBStringField;
    IBQIndiSurVillePAYS: TIBStringField;
    IBQIndiSurVilleSEXE:TLongintField;
    IBQIndiSurVilleDATE_EVENEMENT: TIBStringField;
    IBQIndiSurVilleSUBDIVISION: TIBStringField;
    IBQIndiSurVilleEVENEMENT: TIBStringField;
    IBQIndiSurVilleANNEE_EVENEMENT: TLongintField;
    IBQIndiSurVilleCLE_EV: TLongintField;
    IBQIndiSurVilleNUM_SOSA: TFloatField;
    lVille:TLabel;
    cxGrid1:TExtDBGrid;
    GoodBtn7:TFWClose;
    btnFiche:TFWSearch;
    dxComponentPrinter1: TPrinterSetupDialog;
//    dxComponentPrinter1Link1: TRLDetailGrid;
    btnPrint: TFWPrint;
    procedure cxGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TDBGridColumns; State: TGridDrawState);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mFicheClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure pmGrillePopup(Sender:TObject);
    procedure btnFicheClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure cxGrid1DBTableView1DblClick(Sender: TObject);
  private

  public
    procedure DoInit(sVille,sCP,sDept,sINSEE,sRegion,sPays,sSUBD:string;iMode:Integer);
  end;

implementation

uses u_dm,u_common_const,u_common_functions,u_common_ancestro,Variants,
     fonctions_components,
     u_genealogy_context,
     u_common_ancestro_functions,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFIndividusSurFavoris.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  SaveDialog.InitialDir:=gci_context.PathImportExport;
  // Matthieu : Après
   // cxGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_INDI_SUR_LIEUX');
end;

procedure TFIndividusSurFavoris.cxGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TDBGridColumns; State: TGridDrawState);
var
  valeur:Variant;
begin
  // Matthieu : tous les évènements DrawColumnCel sont à réviser
  with cxGrid1 do
    valeur:= DataSource.DataSet.FieldByName ( Columns [ DataCol ].FieldName ).Value;
  //on met en vert tous ceux qui ont un num sosa
  if not VarIsNull(valeur) then
  begin
    if (valeur>0) then
    begin
      cxGrid1.Canvas.Font.Color:=_COLOR_SOSA;
    end;
  end;
end;

procedure TFIndividusSurFavoris.DoInit(sVille,sCP,sDept,sINSEE,sRegion,sPays,sSUBD:string;iMode:Integer);
const
  SQL1='select sr.* from'
      +'(select i.cle_fiche'
      +',i.nom'
      +',i.prenom'
      +',i.sexe'
      +',i.date_naissance'
      +',i.num_sosa'
      +',ei.ev_ind_clef as cle_ev'
      +',ei.ev_ind_cp as cp'
      +',ei.ev_ind_ville as ville'
      +',ei.ev_ind_pays as pays'
      +',ei.ev_ind_subd as subdivision'
      +',ei.ev_ind_date_writen as date_evenement'
      +',ei.ev_ind_date_year as annee_evenement'
      +',case ei.ev_ind_type'
      +'  when ''EVEN'' then'
      +'    case when char_length(ei.ev_ind_titre_event)>0 then ei.ev_ind_titre_event'
      +'    else r.ref_eve_lib_long'
      +'    end'
      +'  when ''OCCU'' then'
      +'    case when char_length(ei.ev_ind_description)>0 then substring(ei.ev_ind_description from 1 for 30)'
      +'    else r.ref_eve_lib_long'
      +'    end'
      +'  else r.ref_eve_lib_long'
      +'  end as evenement'
      +' from evenements_ind ei'
      +' inner join individu i on i.cle_fiche=ei.ev_ind_kle_fiche and i.kle_dossier=:dossier'
      +' inner join dossier d on d.cle_dossier=i.kle_dossier'
      +' inner join ref_evenements r on r.ref_eve_lib_court=ei.ev_ind_type and r.ref_eve_langue=d.ds_langue'
      +' where coalesce(ei.ev_ind_ville,'''')=:ville'
      +' and coalesce(ei.ev_ind_cp,'''')=:cp'
      +' and coalesce(ei.ev_ind_dept,'''')=:dept'
      +' and coalesce(ei.ev_ind_insee,'''')=:insee'
      +' and coalesce(ei.ev_ind_region,'''')=:region'
      +' and coalesce(ei.ev_ind_pays,'''')=:pays';
  SQL2='union select i.cle_fiche'
      +',i.nom'
      +',i.prenom'
      +',i.sexe'
      +',i.date_naissance'
      +',i.num_sosa'
      +',ef.ev_fam_clef'
      +',ef.ev_fam_cp'
      +',ef.ev_fam_ville'
      +',ef.ev_fam_pays'
      +',ef.ev_fam_subd'
      +',ef.ev_fam_date_writen'
      +',ef.ev_fam_date_year'
      +',case ef.ev_fam_type'
      +'  when ''EVEN'' then'
      +'    case when char_length(ef.ev_fam_titre_event)>0 then ef.ev_fam_titre_event'
      +'    else r.ref_eve_lib_long'
      +'    end'
      +'  else r.ref_eve_lib_long'
      +'  end'
      +' from evenements_fam ef'
      +' inner join t_union u on u.union_clef=ef.ev_fam_kle_famille'
      +' inner join individu i on i.cle_fiche in (u.union_mari,u.union_femme) and i.kle_dossier=:dossier'
      +' inner join dossier d on d.cle_dossier=i.kle_dossier'
      +' inner join ref_evenements r on r.ref_eve_lib_court=ef.ev_fam_type and r.ref_eve_langue=d.ds_langue'
      +' where coalesce(ef.ev_fam_ville,'''')=:ville'
      +' and coalesce(ef.ev_fam_cp,'''')=:cp'
      +' and coalesce(ef.ev_fam_dept,'''')=:dept'
      +' and coalesce(ef.ev_fam_insee,'''')=:insee'
      +' and coalesce(ef.ev_fam_region,'''')=:region'
      +' and coalesce(ef.ev_fam_pays,'''')=:pays';

begin
  IBQIndiSurVille.SQL.Clear;
  lVille.Caption:='';
  if iMode=0 then
  begin
    IBQIndiSurVille.SQL.Add(SQL1);
    IBQIndiSurVille.SQL.Add(SQL2);
    IBQIndiSurVille.SQL.Add(')sr order by sr.nom,sr.prenom');
    lVille.Caption:=sVille;
  end
  else
  begin
    IBQIndiSurVille.SQL.Add(SQL1);
    IBQIndiSurVille.SQL.Add('and coalesce(ei.ev_ind_subd,'''')=:subd');
    IBQIndiSurVille.SQL.Add(SQL2);
    IBQIndiSurVille.SQL.Add('and coalesce(ef.ev_fam_subd,'''')=:subd');
    IBQIndiSurVille.SQL.Add(')sr order by sr.nom,sr.prenom');
    if Length(sSubd)>0 then
    begin
      IBQIndiSurVille.ParamByName('subd').AsString:=sSubd ;
      lVille.Caption:=sSubd;
      if sVille>'' then
        lVille.Caption:=lVille.Caption+' - '+sVille;
    end
    else
    begin
      IBQIndiSurVille.ParamByName('subd').AsString:='';
      lVille.Caption:=sVille;
    end;
    if Length(sDept)>0 then
      lVille.Caption:=lVille.Caption+' ('+sDept+')';
  end;
  if lVille.Caption='' then
  begin
    if sdept>'' then
      lVille.Caption:=sdept;
    if sRegion>'' then
      if lVille.Caption='' then
        lVille.Caption:=sRegion
      else
        lVille.Caption:=lVille.Caption+' - '+sRegion;
    if sPays>'' then
      if lVille.Caption='' then
        lVille.Caption:=sPays
      else
        lVille.Caption:=lVille.Caption+' - '+sPays;
  end;
  IBQIndiSurVille.ParamByName('dossier').AsInteger:=dm.NumDossier;
  IBQIndiSurVille.ParamByName('ville').AsString:=sVille;
  IBQIndiSurVille.ParamByName('cp').AsString:=sCP;
  IBQIndiSurVille.ParamByName('dept').AsString:=sDept;
  IBQIndiSurVille.ParamByName('insee').AsString:=sINSEE;
  IBQIndiSurVille.ParamByName('region').AsString:=sRegion;
  IBQIndiSurVille.ParamByName('pays').AsString:=sPays;

  IBQIndiSurVille.Open;
end;

procedure TFIndividusSurFavoris.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQIndiSurVille.Close;
  // Matthieu : Après
//  cxGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_INDI_SUR_LIEUX');
end;

procedure TFIndividusSurFavoris.sbCloseClick(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFIndividusSurFavoris.mFicheClick(Sender:TObject);
begin
  btnFicheClick(Sender);
end;

procedure TFIndividusSurFavoris.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
  s_Fichier:string;
begin
  SavePlace:=nil;
  s_Fichier:='Liste des Individus sur favoris.HTM';
  SaveDialog.FileName:=s_Fichier;
  if SaveDialog.Execute then
  begin
    IBQIndiSurVille.DisableControls;
    try
      SavePlace:=IBQIndiSurVille.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,cxGrid1,true,True,'html');
    finally
      IBQIndiSurVille.GotoBookmark(SavePlace);
      IBQIndiSurVille.FreeBookmark(SavePlace);
      IBQIndiSurVille.EnableControls;
    end;
  end;
end;

procedure TFIndividusSurFavoris.pmGrillePopup(Sender:TObject);
begin
  mFiche.Caption:=fs_RemplaceMsg(rs_Caption_Have_a_look_at_person,[IBQIndiSurVilleNOM.AsString]);

  if Length(IBQIndiSurVillePRENOM.AsString)>0 then
    mFiche.Caption:=mFiche.Caption+', '+IBQIndiSurVillePRENOM.AsString;
  mFiche.Enabled:=IBQIndiSurVille.RecNo>0;
  ExporterenHTML1.Enabled:=mFiche.Enabled;
end;

procedure TFIndividusSurFavoris.btnFicheClick(Sender:TObject);
begin
  if not IBQIndiSurVille.IsEmpty then
    OuvreFicheIndividuModale(IBQIndiSurVilleCLE_FICHE.AsInteger);
end;

procedure TFIndividusSurFavoris.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_Persons_with_an_event_in_the_site;
end;

procedure TFIndividusSurFavoris.btnPrintClick(Sender: TObject);
begin
  // Matthieu
  {
  dxComponentPrinter1Link1.PrinterPage.PageHeader.CenterTitle.Text:=
    'Individus ayant vécu à '+lVille.Caption;
  dxComponentPrinter1.Preview(True,nil);
  }
end;


procedure TFIndividusSurFavoris.cxGrid1DBTableView1DblClick(
  Sender: TObject);
begin
  btnFicheClick(Sender);
end;

end.

