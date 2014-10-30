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

unit u_form_list_villes_Voisines;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,
  u_comp_TYLanguage,Dialogs,Menus,DB,IBCustomDataSet,IBQuery,
  StdCtrls,Controls,ExtCtrls,U_ExtDBGrid,Classes,
  u_buttons_appli,u_framework_components, u_ancestropictimages,
  u_ancestropictbuttons, Grids, DBGrids;

type

  { TFVillesVoisines }

  TFVillesVoisines=class(TF_FormAdapt)
    fpBoutons:TPanel;
    IBQVillesVoisines:TIBQuery;
    DSVillesVoisines:TDataSource;
    pmGrille: TPopupMenu;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    ExporterenHTML1:TMenuItem;
    SaveDialog:TSaveDialog;
    Language:TYLanguage;
    Label1:TLabel;
    bt_Close:TFWClose;
    cxSEDistance:TFWSpinEdit;
    Distance:TLabel;
    Autour:TLabel;
    lVille:TLabel;
    btnVillesVoisines:TXAWorld;
    IBQVillesVoisinesCP_CP:TIBStringField;
    IBQVillesVoisinesCP_VILLE:TIBStringField;
    IBQVillesVoisinesCP_INSEE:TIBStringField;
    IBQVillesVoisinesCP_LONGITUDE:TFloatField;
    IBQVillesVoisinesCP_LATITUDE:TFloatField;
    IBQVillesVoisinesDISTANCE:TFloatField;
    IBQVillesVoisinesDEPARTEMENT: TStringField;
    IBQVillesVoisinesREGION: TStringField;
    IBQVillesVoisinesPAYS: TStringField;
    IBQVillesVoisinesDIRECTION: TStringField;
    procedure dxDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dxDBGrid1FWBeforeEnter(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure btnVillesVoisinesClick(Sender:TObject);
    procedure pmGrillePopup(Sender:TObject);
    procedure IBQVillesVoisinesCalcFields(DataSet: TDataSet);
    procedure dxDBGrid1MouseEnter(Sender: TObject);
    procedure dxDBGrid1MouseLeave(Sender: TObject);
  private
    iDossier:integer;
    lLat,lLong:double;
    procedure doOpen;
  public
    procedure doInit(ville,Subd:string;lat,long:double;iMode:integer);
  end;

implementation

uses u_dm,
     u_common_const,
     u_common_functions,
     fonctions_dialogs,
     u_common_ancestro,
     u_form_main,IBSQL,Math,
     fonctions_components,
     u_genealogy_context,
     u_common_ancestro_functions,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFVillesVoisines.SuperFormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  // Matthieu ?
  //  dxDBGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_VILLES_VOISINES');

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  cxSEDistance.Value:=gci_context.DistanceVillesVoisines;

  SaveDialog.InitialDir:=gci_context.PathImportExport;
end;

procedure TFVillesVoisines.dxDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column = dxDBGrid1.SelectedColumn then
    if dxDBGrid1.Canvas.Brush.Color=dxDBGrid1.Color then
      dxDBGrid1.Canvas.Brush.Color:=gci_context.ColorMedium;
end;

procedure TFVillesVoisines.dxDBGrid1FWBeforeEnter(Sender: TObject);
begin

end;

procedure TFVillesVoisines.DoInit(ville,Subd:string;lat,long:double;iMode:integer);
var
  q:TIBSQL;
begin
  iDossier:=iMode;
  lVille.Caption:=Ville;
  if Subd>'' then
    lVille.Caption:=lVille.Caption+' - '+Subd;
  if iDossier=0 then
  begin
    Caption:=rs_Caption_Neighbor_cities_in_cities_index;
    Label1.Caption:=fs_RemplaceMsg(rs_Caption_Neighbor_cities_of_in_cities_index,[lVille.Caption]);
    IBQVillesVoisines.Database:=dm.IBBaseParam;
    IBQVillesVoisines.Transaction:=dm.IBTransParam;
    IBQVillesVoisines.SQL.Text:='SELECT cp_cp'
      +',cp_ville'
      +',cp_insee'
      +',distance'
      +',cp_latitude'
      +',cp_longitude'
      +',departement'
      +',region'
      +',pays'
      +' FROM PROC_PREP_VILLES_RAYON(:RAYON,:LATITUDE,:LONGITUDE)'
      +'order by DISTANCE,CP_VILLE';
  end
  else
  begin
    Caption:=rs_Caption_Neighbor_sites_recorded_in_folder;
    Label1.Caption:=fs_RemplaceMsg(rs_Caption_Recorded_sites_on_this_folder_neighbor_of,[lVille.Caption]);
    IBQVillesVoisines.Database:=dm.ibd_BASE;
    IBQVillesVoisines.Transaction:=dm.IBT_BASE;
    IBQVillesVoisines.SQL.Text:='SELECT cp_cp'
      +',cp_ville'
      +',cp_insee'
      +',distance'
      +',cp_latitude'
      +',cp_longitude'
      +',departement'
      +',region'
      +',pays'
      +' FROM PROC_PREP_VILLES_RAYON(:RAYON,:LATITUDE,:LONGITUDE,:DOSSIER)'
      +'order by DISTANCE,CP_VILLE';
  end;
  lLat:=lat;
  lLong:=long;
  doOpen;
end;

procedure TFVillesVoisines.doOpen;
begin
  if (lLat<>0)and(lLong<>0) then
  begin
    IBQVillesVoisines.Close;
    IBQVillesVoisines.Params[0].AsFloat:=cxSEDistance.Value;
    IBQVillesVoisines.Params[1].AsFloat:=lLat;
    IBQVillesVoisines.Params[2].AsFloat:=lLong;
    if iDossier>0 then
      IBQVillesVoisines.Params[3].AsInteger:=iDossier;
    IBQVillesVoisines.Open;
  end
  else
  begin
    MyMessageDlg(fs_RemplaceMsg(rs_Error_None_Coord_of,[lVille.Caption])
      ,mtInformation,[mbCancel],Self);
  end;
end;

procedure TFVillesVoisines.sbCloseClick(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFVillesVoisines.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  gci_context.DistanceVillesVoisines:=cxSEDistance.Value;
  IBQVillesVoisines.Close;
  // Matthieu ?
  //  dxDBGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry +DirectorySeparator+'W_VILLES_VOISINES');
  if FMain.Lieu_Proprietaire=nil then //sinon la propriétaire s'en charge
  begin
    Action:=caFree;
    DoSendMessage(Owner,'FERME_FORM_VILLES_VOISINES');
  end;
end;

procedure TFVillesVoisines.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
  s_Fichier:string;
begin
  SavePlace:=nil;
  s_Fichier:='Liste des Villes voisines.HTM';
  SaveDialog.FileName:=s_Fichier;
  if SaveDialog.Execute then
  begin
    IBQVillesVoisines.DisableControls;
    try
      SavePlace:=IBQVillesVoisines.GetBookmark;
      ExportGridToHTML(s_fichier,dxDBGrid1,True,True);
    finally
      IBQVillesVoisines.GotoBookmark(SavePlace);
      IBQVillesVoisines.FreeBookmark(SavePlace);
      IBQVillesVoisines.EnableControls;
    end;
  end;
end;

procedure TFVillesVoisines.btnVillesVoisinesClick(Sender:TObject);
begin
  doOpen;
end;

procedure TFVillesVoisines.pmGrillePopup(Sender:TObject);
begin
  ExporterenHTML1.enabled:=not dxDBGrid1.DataSource.DataSet.IsEmpty;
end;


procedure TFVillesVoisines.IBQVillesVoisinesCalcFields(DataSet: TDataSet);
var
  vLat,vLong,dLat,dLong,AngleRad:Double;
begin
  vLat:=IBQVillesVoisinesCP_LATITUDE.AsFloat;
  vLong:=IBQVillesVoisinesCP_LONGITUDE.AsFloat;
  if (lLat=0)or(vLat=0)or(lLong=0)or(vLong=0)or((lLat=vLat)and(lLong=vLong)) then
    IBQVillesVoisinesDIRECTION.AsString:='-'
  else
  begin
    try
      dLat:=vLat-lLat;
      dLong:=(vLong-lLong)*sin(lLat*Pi/180);
      AngleRad:=ArcTan2(dLat,dLong);

      case Round(AngleRad*4/Pi) of
        0:IBQVillesVoisinesDIRECTION.AsString:='E';
        1:IBQVillesVoisinesDIRECTION.AsString:='NE';
        2:IBQVillesVoisinesDIRECTION.AsString:='N';
        3:IBQVillesVoisinesDIRECTION.AsString:='NW';
        4:IBQVillesVoisinesDIRECTION.AsString:='W';
        -1:IBQVillesVoisinesDIRECTION.AsString:='SE';
        -2:IBQVillesVoisinesDIRECTION.AsString:='S';
        -3:IBQVillesVoisinesDIRECTION.AsString:='SW';
        -4:IBQVillesVoisinesDIRECTION.AsString:='W';
      else
        IBQVillesVoisinesDIRECTION.AsString:='-';
      end;
    except
      IBQVillesVoisinesDIRECTION.AsString:='-';
    end;
  end;
end;

procedure TFVillesVoisines.dxDBGrid1MouseEnter(Sender: TObject);
begin
  // Matthieu ?
//  dm.cxHintStyleController1.HintStyle.Standard:=true;
end;

procedure TFVillesVoisines.dxDBGrid1MouseLeave(Sender: TObject);
begin
  // Matthieu ?
//  dm.cxHintStyleController1.HintStyle.Standard:=false;
end;

end.

