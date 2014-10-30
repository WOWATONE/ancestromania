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

{ -- Requete d origine -----------------------------------------------
select  distinct A.cp_code,
             a.cp_cp,
              A.cp_ville,
              a.cp_insee,
             a.cp_longitude
        from ref_cp_ville A,
             ref_cp_ville B

             where a.cp_insee = b.cp_insee and
             a.cp_code <> b.cp_code  and
             a.cp_pays IN (SELECT RPA_CODE
                             FROM REF_PAYS
                             WHERE RPA_LIBELLE = 'FRANCE' OR
                                   RPA_LIBELLE = 'DEPARTEMENT OUTREMER')
Order by a.cp_ville
}

unit u_form_list_villes_Doublons;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,IBCustomDataSet,SysUtils,U_ExtDBGrid,Menus,u_comp_TYLanguage,DB,IBQuery,StdCtrls,
  Controls,ExtCtrls,forms,Dialogs,u_buttons_appli, u_ancestropictimages,
   IBSQL, Classes;

type

  { TFListeVillesDoublons }

  TFListeVillesDoublons=class(TF_FormAdapt)
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    fpBoutons:TPanel;
    pBottom:TPanel;
    IBQDoublons:TIBQuery;
    DSDoublons:TDataSource;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    pBravo:TPanel;
    Image2:TIASearch;
    Label1:TLabel;
    Language:TYLanguage;
    pmGrid:TPopupMenu;
    Supprimerlafiche1:TMenuItem;
    IBQDoublonsCP_CODE:TLongintField;
    IBQDoublonsCP_VILLE:TIBStringField;
    IBQDoublonsCP_INSEE:TIBStringField;
    IBQDoublonsCP_CP:TIBStringField;
    IBQDoublonsCP_LONGITUDE:TFloatField;
    IBQDoublonsCP_LATITUDE:TFloatField;
    IBQDoublonsRPA_LIBELLE:TIBStringField;
    btnFermer:TFWClose;
    GoodBtn1:TFWDelete;
    IBQDelVille: TIBSQL;

    procedure Image2Click(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure pmGridPopup(Sender:TObject);
    procedure Supprimerlafiche1Click(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
  private
    procedure doShowDoublons;
  public

  end;

implementation

uses u_dm,
     u_common_const,
     u_common_ancestro,
     u_common_functions,
     u_common_ancestro_functions,
     fonctions_dialogs,
     u_genealogy_context,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFListeVillesDoublons.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  Application.ProcessMessages;
  doRefreshControls;
end;

procedure TFListeVillesDoublons.Image2Click(Sender: TObject);
begin

end;

procedure TFListeVillesDoublons.doShowDoublons;
begin
  IBQDoublons.Close;
  IBQDoublons.Open;
  doRefreshControls;
end;

procedure TFListeVillesDoublons.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQDoublons.Close;
end;

procedure TFListeVillesDoublons.sbCloseClick(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFListeVillesDoublons.pmGridPopup(Sender:TObject);
var
  ok:boolean;
begin
  ok:=(IBQDoublons.Active)and(IBQDoublons.IsEmpty=false)
    and(dm.individu_clef<>IBQDoublonsCP_CODE.AsInteger);
  Supprimerlafiche1.enabled:=ok;
end;

procedure TFListeVillesDoublons.Supprimerlafiche1Click(Sender:TObject);
var
  L:array of integer;
  sMessage:string;
  i:integer;
begin
  SetLength(L,dxDBGrid1.SelectedRows.Count);
  if Length(L)>1 then
    sMessage:= fs_RemplaceMsg(rs_Confirm_deleting_selected_cities,[intToStr(Length(L))])
  else
    sMessage:=rs_Confirm_deleting_selected_city;

  if MyMessageDlg(sMessage,mtWarning,[mbYes,mbNo],Self)=mrYes then
  with dxDBGrid1.DataSource.DataSet do
  begin
    DisableControls;
    screen.Cursor:=crSQLWait;
    Application.ProcessMessages;
    try
      dm.IBTrans_Secondaire.Active:=true;
      for i:=0 to Length(L)-1 do
       Begin
         GotoBookMark(dxDBGrid1.SelectedRows[i]);
         L[i]:=FieldByName('CP_CODE').AsInteger;
       end;
      IBQDoublons.Close;
      for i:=0 to Length(L)-1 do
      begin
        IBQDelVille.params[0].asInteger:=L[i];
        IBQDelVille.ExecQuery;
      end;
      IBQDelVille.Close;
      dm.IBTrans_Secondaire.CommitRetaining;
      doShowDoublons;
    finally
      screen.Cursor:=crDefault;
      EnableControls;
    end;
  end;
end;

procedure TFListeVillesDoublons.SuperFormRefreshControls(Sender:TObject);
begin
  dxDBGrid1.Enabled:=(IBQDoublons.Active)and(IBQDoublons.IsEmpty=false);
  pBravo.Visible:=(IBQDoublons.Active)and(IBQDoublons.IsEmpty);
end;

procedure TFListeVillesDoublons.SuperFormShowFirstTime(Sender:TObject);
begin
  Height:=round(TControl(Owner).height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).width*gci_context.TailleFenetre/100);
  Caption:=rs_Caption_Duplicated_cities;
  doShowDoublons;
end;

end.

