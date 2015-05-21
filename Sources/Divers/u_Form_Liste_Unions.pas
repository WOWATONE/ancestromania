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

unit u_Form_Liste_Unions;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,SysUtils,
  u_comp_TYLanguage,Dialogs,Menus,DB,IBCustomDataSet,IBQuery,
  StdCtrls,Controls,ExtCtrls,U_ExtDBGrid,Classes,
  u_buttons_appli,PrintersDlgs,
  Variants, u_reports_components, u_ancestropictimages, U_OnFormInfoIni, Grids, DBGrids;

type

  { TFListeUnions }

  TFListeUnions=class(TF_FormAdapt)
    OnFormInfoIni: TOnFormInfoIni;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    IBQUnions:TIBQuery;
    DSUnions:TDataSource;
    IBQUnionsUNION_CLE:TLongintField;
    IBQUnionsMARI_CLE:TLongintField;
    IBQUnionsMARI_NOM:TIBStringField;
    IBQUnionsMARI_PRENOM:TIBStringField;
    IBQUnionsFEMME_CLE:TLongintField;
    IBQUnionsFEMME_NOM:TIBStringField;
    IBQUnionsFEMME_PRENOM:TIBStringField;
    IBQUnionsVILLE:TIBStringField;
    IBQUnionsMARI_NUM_SOSA:TFloatField;
    IBQUnionsFEMME_NUM_SOSA:TFloatField;
    IBQUnionsAN_MARR:TLongintField;
    IBQUnionsMOIS_MARR:TLongintField;
    IBQUnionsAGE_MARI:TLongintField;
    IBQUnionsAGE_FEMME:TLongintField;
    IBQUnionsPAYS:TStringField;
    IBQUnionsDATE_MARR:TStringField;
    IBQUnionsDEPT: TStringField;
    IBQUnionsSUBD: TStringField;
    IBQUnionsREGION: TStringField;
    pmUnions:TPopupMenu;
    mMari:TMenuItem;
    mFemme:TMenuItem;
    dxDBGridUnions:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    N1:TMenuItem;
    ExporterenHTML1:TMenuItem;
    SaveDialog:TSaveDialog;
    Language:TYLanguage;
    Label1:TLabel;
    dxComponentPrinter1:TPrinterSetupDialog;
    N2:TMenuItem;
    mSupprimerTris:TMenuItem;
    fpBoutons:TPanel;
    GoodBtn7:TFWClose;
    btnPrint:TFWPrintGrid;
    procedure dxDBGridUnionsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure mMariClick(Sender:TObject);
    procedure mFemmeClick(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure pmUnionsPopup(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure DoSelect;
    procedure mSupprimerTrisClick(Sender:TObject);
    procedure dxDBGridUnionsDBTableView1DataControllerFilterChanged(
      Sender:TObject);
    procedure dxDBGridUnionsDBTableView1CellDblClick(
      Sender: TObject;
      ACellViewInfo: Longint; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure dxDBGridUnionsMouseEnter(Sender: TObject);
    procedure dxDBGridUnionsMouseLeave(Sender: TObject);
  private
    fCleFicheSelected:integer;

    procedure MajTitre;
  public
    property CleFicheSelected:integer read fCleFicheSelected write fCleFicheSelected;

  end;

implementation

uses u_dm,u_common_const,u_common_functions,u_common_ancestro,u_genealogy_context, fonctions_components,rxdbgrid,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFListeUnions.SuperFormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  dxDBGridUnions.Hint:=rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns;
  Language.Translate;

  SaveDialog.InitialDir:=gci_context.PathDocs;

  // Matthieu ?
//  dxDBGridUnionsDBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_LISTE_UNIONS');

end;

procedure TFListeUnions.dxDBGridUnionsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Value:Variant;
  DBGrid : TExtDBGrid;
begin
  DBGrid:=sender as TExtDBGrid;
  with DBGrid do
    Begin
      Value:=DataSource.DataSet.FieldByName('SOSA').Value;
      if not VarIsNull(Value) then
      begin
        if (Value>0) then
        begin
          Canvas.Font.Color:=_COLOR_SOSA;
        end
        else
        begin
          Canvas.Font.Color:=gci_context.ColorHomme;
        end;
      end;
    if column = SelectedColumn then
     if Canvas.Brush.Color=Color then
       Canvas.Brush.Color:=gci_context.ColorMedium;
    end;
end;

procedure TFListeUnions.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQUnions.Close;
  // Matthieu ?
//dxDBGridUnionsDBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_LISTE_UNIONS');

  Action:=caFree;
  DoSendMessage(Owner,'FERME_LISTE_UNIONS');
end;

procedure TFListeUnions.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFListeUnions.mMariClick(Sender:TObject);
begin
  fCleFicheSelected:=IBQUnionsMARI_CLE.AsInteger;
  DoSelect;
end;

procedure TFListeUnions.mFemmeClick(Sender:TObject);
begin
  fCleFicheSelected:=IBQUnionsFEMME_CLE.AsInteger;
  DoSelect;
end;

procedure TFListeUnions.DoSelect;
begin
  DefaultCloseAction:=caNone;
  dm.individu_clef:=fCleFicheSelected;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
end;

procedure TFListeUnions.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Liste des Unions.HTM';
  if SaveDialog.Execute then
  begin
    IBQUnions.DisableControls;
    try
      SavePlace:=IBQUnions.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGridUnions,True,True);
    finally
      IBQUnions.GotoBookmark(SavePlace);
      IBQUnions.FreeBookmark(SavePlace);
      IBQUnions.EnableControls;
    end;
  end;
end;

procedure TFListeUnions.pmUnionsPopup(Sender:TObject);
begin
  mMari.Enabled:=not dxDBGridUnions.DataSource.Dataset.IsEmpty;
  mFemme.Enabled:=mMari.Enabled;
  ExporterenHTML1.Enabled:=mMari.Enabled;
end;

procedure TFListeUnions.btnPrintClick(Sender:TObject);
begin
  // Matthieu
  btnPrint.DBTitle:=Caption;
end;

procedure TFListeUnions.SuperFormShow(Sender:TObject);
begin
  Caption:=rs_Caption_List_of_unions;
  IBQUnions.Params[0].AsInteger:=dm.NumDossier;
  IBQUnions.Open;
  MajTitre;
  application.ProcessMessages;
end;

procedure TFListeUnions.mSupprimerTrisClick(Sender:TObject);
var
  i:integer;
begin
  for i:=0 to dxDBGridUnions.Columns.Count-1 do
    dxDBGridUnions.Columns[i].SortOrder:=smNone;
  if IBQUnions.Active then
  begin
    IBQUnions.Close;
    IBQUnions.Open;
  end;
end;



procedure TFListeUnions.MajTitre;
begin
  with dxDBGridUnions.DataSource.DataSet do
  if IsEmpty then
    case RecordCount of
      0:Label1.Caption:=rs_Caption_None_union_in_this_folder;
      1:Label1.Caption:=rs_Caption_One_person_in_this_folder;
      else
        Label1.Caption:=fs_RemplaceMsg(rs_Caption_List_of_folder_unions,[IntToStr(RecordCount)])
    end
  else
    case RecordCount of
      0:Label1.Caption:=rs_Caption_None_union_found ;
      1:Label1.Caption:=rs_Caption_One_union_found;
      else
        Label1.Caption:= fs_RemplaceMsg(rs_Caption_unions_found,[IntToStr(RecordCount)]);
    end;
end;

procedure TFListeUnions.dxDBGridUnionsDBTableView1DataControllerFilterChanged(
  Sender:TObject);
begin
  majTitre;
end;

procedure TFListeUnions.dxDBGridUnionsDBTableView1CellDblClick(
  Sender: TObject;
  ACellViewInfo: Longint; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  mMariClick(sender);
end;

procedure TFListeUnions.dxDBGridUnionsMouseEnter(Sender: TObject);
begin
   // Matthieu : Pas de style
//  dm.ControleurHint.HintStyle.Standard:=true;
end;

procedure TFListeUnions.dxDBGridUnionsMouseLeave(Sender: TObject);
begin
  // Matthieu : Pas de style
// dm.ControleurHint.HintStyle.Standard:=false;
end;

end.

