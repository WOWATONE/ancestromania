{-----------------------------------------------------------------------}

{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }

{-----------------------------------------------------------------------}

{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }

{-----------------------------------------------------------------------}

{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{2009 nettoyage, 2011 refonte liens Pays, Région, Département par André }
{-----------------------------------------------------------------------}

unit u_form_Ville_Ajout;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  U_FormAdapt, u_ancestropictimages, Forms,
  U_ExtDBGrid, u_comp_TYLanguage, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, ExtCtrls, StdCtrls, Classes, u_buttons_appli,
  u_framework_dbcomponents,
  CompSuperForm;

type

  { TFVilleAjout }

  TFVilleAjout = class(TF_FormAdapt)
    IAWorld: TIAWorld;
    pBorder: TPanel;
    pGeneral: TPanel;
    pGlobal: TPanel;
    panDock: TPanel;
    IBQCP: TIBQuery;
    DSCP: TDataSource;
    IBUCP: TIBUpdateSQL;
    dxDBEdit1: TFWDBEdit;
    edVille: TFWDBEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DSDept: TDataSource;
    DSRegion: TDataSource;
    DSPays: TDataSource;
    IBQDept: TIBQuery;
    IBQRegion: TIBQuery;
    IBQPays: TIBQuery;
    dxDBEdit3: TFWDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    pDept: TPanel;
    Panel22: TPanel;
    Label9: TLabel;
    dxDBPanel: TExtDBGrid;
    dxDBPERegion: TFWDBEdit;
    dxDBPEPays: TFWDBEdit;
    dxDBPEDept: TFWDBEdit;
    Label11: TLabel;
    IBQDeptRDP_CODE: TLongintField;
    IBQDeptRDP_LIBELLE: TIBStringField;
    IBQCP_PAYS: TStringField;
    IBQCP_REGION: TStringField;
    IBQCP_DEPT: TStringField;
    IBQRegionRRG_CODE: TLongintField;
    IBQRegionRRG_LIBELLE: TIBStringField;
    IBQPaysRPA_CODE: TLongintField;
    IBQPaysRPA_LIBELLE: TIBStringField;
    IBQCPCP_CODE: TLongintField;
    IBQCPCP_CP: TIBStringField;
    IBQCPCP_VILLE: TIBStringField;
    IBQCPCP_DEPT: TLongintField;
    IBQCPCP_REGION: TLongintField;
    IBQCPCP_PAYS: TLongintField;
    IBQCPCP_INSEE: TIBStringField;
    IBQCPCP_HABITANTS: TFloatField;
    IBQCPCP_DENSITE: TFloatField;
    IBQCPCP_DIVERS: TIBStringField;
    IBQCPCP_LATITUDE: TFMTBCDField;
    IBQCPRCV_LONGITUDE: TFMTBCDField;
    IBQRegionRRG_PAYS: TLongintField;
    Language: TYLanguage;
    Label17: TLabel;
    Label18: TLabel;
    dbLong: TFWDBEdit;
    dbLat: TFWDBEdit;
    dxDBEdit8: TFWDBEdit;
    fpBoutons: TPanel;
    bsfbSelection: TFWOK;
    BtnAnnuler: TFWCancel;
    procedure SuperFormCreate(Sender: TObject);
    procedure sbCloseClick(Sender: TObject);
    procedure SuperFormClose(Sender: TObject; var Action: TCloseAction);
    procedure bsfbSelectionClick(Sender: TObject);
    procedure IBQCPNewRecord(DataSet: TDataSet);
    procedure dxDBPEDeptInitPopup(Sender: TObject);
    procedure dxDBPERegionInitPopup(Sender: TObject);
    procedure dxDBPEPaysInitPopup(Sender: TObject);
    procedure dxDBPanelDblClick(Sender: TObject);
    procedure dxDBPanelKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DSCPDataChange(Sender: TObject; Field: TField);
    procedure SuperFormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure SuperFormShowFirstTime(Sender: TObject);
  private
    fVille: string;
    fCode: integer;
    fCodePays: integer;
  public
    property Code: integer read fCode write fCode;
    property Ville: string read fVille write fVille;
    property CodePays: integer read fCodePays write fCodePays;
    function Prepare: boolean;
  end;

implementation

uses u_dm, u_common_const, u_common_functions, u_common_ancestro,
     u_genealogy_context,
     IBSQL,u_form_list_villes;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFVilleAjout.SuperFormCreate(Sender: TObject);
begin
  OnShowFirstTime := SuperFormShowFirstTime;
  pGeneral.Color := gci_context.ColorLight;
  Panel22.Color := gci_context.ColorDark;
  Language.RessourcesFileName := _REL_PATH_TRADUCTIONS + _FileNameTraduction;
  Language.Translate;
  fCode := -1;
  fVille := '';
  pDept.Width := 400;
  pDept.Height := 250;
  IBQRegion.Open;
  IBQPays.Open;
  IBQDept.Open;
end;

procedure TFVilleAjout.SuperFormClose(Sender: TObject; var Action: TCloseAction);
begin
  IBQDept.Close;
  IBQRegion.Close;
  IBQPays.Close;
  IBQCP.Close;
end;

procedure TFVilleAjout.sbCloseClick(Sender: TObject);
begin
  IBQCP.Cancel;
  Close;
end;

procedure TFVilleAjout.bsfbSelectionClick(Sender: TObject);
var
  q: TIBSQL;
begin
  if (IBQCP.State in [dsEdit, dsInsert]) then
  begin
    IBQCPCP_PAYS.AsInteger := IBQPaysRPA_CODE.AsInteger;
    IBQCPCP_REGION.AsInteger :=
      IBQRegionRRG_CODE.AsInteger;
    IBQCPCP_DEPT.AsInteger := IBQDeptRDP_CODE.AsInteger;
    IBQCP.Post;
    fVille := IBQCPCP_VILLE.AsString;
    fCodePays := IBQPaysRPA_CODE.AsInteger;
    IBQCP.Close;
    dm.IBTransParam.CommitRetaining;
  end;
end;

procedure TFVilleAjout.IBQCPNewRecord(DataSet: TDataSet);
begin
  fCode := TFListVilles(Owner).CleUnique('REF_CP_VILLES');
  IBQCPCP_CODE.AsInteger := fCode;
end;

procedure TFVilleAjout.dxDBPEDeptInitPopup(Sender: TObject);
begin
  Label9.Caption := rs_Caption_Departments;
  dxDBPanel.DataSource := DSDept;
  // Matthieu : pas sûr du grid
  //  dxDBPanel.DataSource.DataSet.LookupFieldNames:='RDP_CODE';
  //dxDBGCLibelle.FieldName:='RDP_LIBELLE';
  dxDBPanel.Columns[0].FieldName := 'RDP_LIBELLE';
end;

procedure TFVilleAjout.dxDBPERegionInitPopup(Sender: TObject);
begin
  Label9.Caption := rs_Caption_Regions;
  dxDBPanel.DataSource := DSRegion;
  // Matthieu : pas sûr du grid
  //dxDBPanelDBTableView1.DataController.LookupFieldNames:='RRG_CODE';
  //dxDBGCLibelle.FieldName:='RRG_LIBELLE';
  dxDBPanel.Columns[0].FieldName := 'RRG_LIBELLE';
end;

procedure TFVilleAjout.dxDBPEPaysInitPopup(Sender: TObject);
begin
  Label9.Caption := rs_Caption_Countries;
  dxDBPanel.DataSource := DSPays;
  // Matthieu : pas sûr du grid
  //  dxDBPanelDBTableView1.DataController.LookupFieldNames:='RPA_CODE';
  //  dxDBGCLibelle.FieldName:='RPA_LIBELLE';
  dxDBPanel.Columns[0].FieldName := 'RPA_LIBELLE';
end;

function TFVilleAjout.Prepare: boolean;
begin
  Result := False;
  case FormMode of
    sfmNew:
    begin
      IBQCP.Close;
      IBQCP.ParamByName('CODE').AsInteger := -1;
      IBQCP.Open;
      IBQCP.Insert;
      IBQPays.Locate('RPA_CODE', fCodePays, []);
      Result := True;
    end;
    sfmEdit:
    begin
      IBQCP.Close;
      IBQCP.ParamByName('CODE').AsInteger := fCode;
      IBQCP.Open;
      IBQPays.Locate('RPA_CODE', IBQCPCP_PAYS.AsInteger, []);
      IBQRegion.Locate('RRG_CODE', IBQCPCP_REGION.AsInteger, []);
      IBQDept.Locate('RDP_CODE', IBQCPCP_DEPT.AsInteger, []);
      if not IBQCP.EOF then
        Result := True;
      case IBQCPCP_PAYS.AsInteger of
        1: IAWorld.ImageOn := caFrance;
        else
          IAWorld.ImageOn := caWorld;
      end;
    end;
  end;
  bsfbSelection.Enabled := False;
end;

procedure TFVilleAjout.dxDBPanelDblClick(Sender: TObject);
begin
  if not (IBQCP.State in [dsEdit, dsInsert]) then
    IBQCP.Edit;
  GetParentForm(dxDBPanel).Close;
end;

procedure TFVilleAjout.dxDBPanelKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
  begin
    GetParentForm(dxDBPanel).Close;
  end
  else if (Key = VK_RETURN) then
    dxDBPanelDblClick(Sender);
end;

procedure TFVilleAjout.DSCPDataChange(Sender: TObject; Field: TField);
begin
  bsfbSelection.Enabled := True;
end;

procedure TFVilleAjout.SuperFormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  case Key of
    _KEY_HELP: p_ShowHelp(_ID_VILLES);
  end;
end;

procedure TFVilleAjout.SuperFormShowFirstTime(Sender: TObject);
begin
  if FormMode = sfmEdit then
    Caption := rs_Caption_Modify_a_city
  else
    Caption := rs_Caption_Add_a_city;
end;

end.




