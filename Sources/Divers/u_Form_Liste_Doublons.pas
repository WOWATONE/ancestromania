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

unit u_Form_Liste_Doublons;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt, U_OnFormInfoIni, Forms, Dialogs, IB, Menus, u_comp_TYLanguage,
  DB, IBQuery, StdCtrls, Controls, ExtCtrls, U_ExtDBGrid, Classes,
  u_buttons_appli, ExtJvXPCheckCtrls, PrintersDlgs, u_ancestropictimages, IBSQL,
  Grids, DBGrids;

type

  { TFListeDoublons }

  TFListeDoublons=class(TF_FormAdapt)
    OnFormInfoIni: TOnFormInfoIni;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    IBQDoublons:TIBQuery;
    DSDoublons:TDataSource;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
{$IFNDEF FPC}
    IBQDoublonsCLE_FICHE:TLongintField;
    IBQDoublonsNOM:TIBStringField;
    IBQDoublonsPRENOM:TIBStringField;
    IBQDoublonsDATE_NAISS:TIBStringField;
    IBQDoublonsLIEU_NAISS:TIBStringField;
    IBQDoublonsDATE_DECES:TIBStringField;
    IBQDoublonsLIEU_DECES:TIBStringField;
{$ENDIF}
    pBravo:TPanel;
    Image2:TImage;
    Label1:TLabel;
    Label2:TLabel;
    Language:TYLanguage;
    pmGrid:TPopupMenu;
    mOuvrirlafiche:TMenuItem;
    mSupprimerlafiche:TMenuItem;
    N1:TMenuItem;
    dxComponentPrinter1:TPrinterSetupDialog;
    SaveDialog:TSaveDialog;
    IBSQLDeleteIndi:TIBSQL;
    fpBoutons:TPanel;
    btnFermer:TFWClose;
    cxButton1:TFWSearch;
    cbElargir:TJvXPCheckBox;
    btnPrint:TFWPrint;
    btnExport:TFWExport;
    mConsulterlafiche:TMenuItem;
    cbIndiEnCours: TJvXPCheckBox;

    procedure dxDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure pmGridPopup(Sender:TObject);
    procedure mOuvrirlaficheClick(Sender:TObject);
    procedure mSupprimerlaficheClick(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure cxButton1Click(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure btnExportClick(Sender:TObject);
    procedure dxDBGrid1DBTableView1CellDblClick(
      Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure mConsulterlaficheClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender: TObject);
  private
    fDialogMode:boolean;

    procedure SetDialogMode(const Value:boolean);
    procedure doShowDoublons;
  public
    property DialogMode:boolean read fDialogMode write SetDialogMode;
  end;

implementation

uses u_dm,
     u_common_const,
     fonctions_dialogs,
     u_common_functions,
     u_common_ancestro,math,
     u_genealogy_context,
     u_common_ancestro_functions,
     fonctions_components;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFListeDoublons.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  pBravo.Color:=gci_context.ColorLight;
  Height:=round(TControl(Owner).height*gci_context.TailleFenetre/100);
  width:=max(round(TControl(Owner).width*gci_context.TailleFenetre/100),729);

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  cbElargir.Hint:=rs_Hint_Unless_identity_of_names_Duplicates_will_be_searched;
  cbIndiEnCours.Hint:=rs_Hint_Duplicates_will_be_searched_in_persons_with_a_same_or_similar_surname;
end;

procedure TFListeDoublons.dxDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with dxDBGrid1 do
  if  Column = SelectedColumn then
    if Canvas.Brush.Color=Color then
      Canvas.Brush.Color:=gci_context.ColorMedium;
end;

procedure TFListeDoublons.doShowDoublons;
var
  fTryToSelectCleFiche:integer;
begin
  screen.Cursor:=crHourglass;
  Application.ProcessMessages;
  fTryToSelectCleFiche:=-1;
  if IBQDoublons.Active then
    if not IBQDoublons.IsEmpty then
      fTryToSelectCleFiche:=IBQDoublons.FieldByName('CLE_FICHE').AsInteger;

  with IBQDoublons do
  try
    Close;
    Params[0].AsInteger:=dm.NumDossier;
    if cbIndiEnCours.Checked then
      Params[1].AsInteger:=dm.individu_clef
    else
      Params[1].AsInteger:=0;

    if cbElargir.Checked then
      Params[2].AsInteger:=1
    else
      Params[2].AsInteger:=0;

    Open;

    btnPrint.Enabled:=not dxDBGrid1.DataSource.Dataset.IsEmpty;
    btnExport.Enabled:=btnPrint.Enabled;
  except
    on E:EIBError do
    begin
      ShowMessage('Erreur Doublons : Probleme de requete..'+_CRLF+_CRLF+
        E.Message);
    end;
  end;

  if fTryToSelectCleFiche<>-1 then
    IBQDoublons.Locate('CLE_FICHE',fTryToSelectCleFiche, []);

  doRefreshControls;
  screen.Cursor:=crDefault;
end;

procedure TFListeDoublons.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQDoublons.Close;
  dm.IBT_base.CommitRetaining;
  Action:=caFree;//obligatoire si on veut qu'une SuperForm se libère seule (elle ignore AutoFreeOnClose)
  DoSendMessage(Owner,'FERME_FORM_LISTE_DOUBLONS');
end;

procedure TFListeDoublons.SetDialogMode(const Value:boolean);
begin
  fDialogMode:=Value;
end;

procedure TFListeDoublons.sbCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFListeDoublons.pmGridPopup(Sender:TObject);
var
  ok:boolean;
begin
  ok:=(IBQDoublons.Active)and(not IBQDoublons.IsEmpty)and(dm.individu_clef<>IBQDoublons.FieldByName('CLE_FICHE').AsInteger);
  mOuvrirlafiche.enabled:=ok;
  mConsulterlafiche.enabled:=ok;
  mSupprimerlafiche.enabled:=ok;
end;

procedure TFListeDoublons.mOuvrirlaficheClick(Sender:TObject);
begin
  if (IBQDoublons.Active)and(not IBQDoublons.IsEmpty)
    and(dm.individu_clef<>IBQDoublons.FieldByName('CLE_FICHE').AsInteger) then
  begin
    dm.individu_clef:=IBQDoublons.FieldByName('CLE_FICHE').AsInteger;
    DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
  end;
end;

procedure TFListeDoublons.mSupprimerlaficheClick(Sender:TObject);
begin
  if MyMessageDlg(rs_Confirm_deleting_selected_person_file,mtWarning, [mbYes,mbNo],Self)=mrYes then
  begin
    try
      IBSQLDeleteIndi.Params[0].AsInteger:=IBQDoublons.FieldByName('CLE_FICHE').AsInteger;
      IBSQLDeleteIndi.ExecQuery;
      IBSQLDeleteIndi.Close;

      dm.IBT_base.CommitRetaining;

      doShowDoublons;
    except
    end;
  end;

end;

procedure TFListeDoublons.SuperFormRefreshControls(Sender:TObject);
begin
  dxDBGrid1.Enabled:=(IBQDoublons.Active)and(IBQDoublons.IsEmpty=false);
  pBravo.Visible:=(IBQDoublons.Active)and(IBQDoublons.IsEmpty);
end;

procedure TFListeDoublons.cxButton1Click(Sender:TObject);
begin
  doShowDoublons;
end;

procedure TFListeDoublons.btnPrintClick(Sender:TObject);
begin
// Matthieu Après
  //dxComponentPrinter1.Preview(True,nil);
end;

procedure TFListeDoublons.btnExportClick(Sender:TObject);
var
  SavePlace:TBookmark;
  s_Fichier:string;
begin
  SavePlace:=nil;
  s_Fichier:='Liste des doublons.HTM';
  SaveDialog.FileName:=s_Fichier;
  SaveDialog.InitialDir:=gci_context.PathDocs;

  if SaveDialog.Execute then
  begin
    IBQDoublons.DisableControls;
    try
      SavePlace:=IBQDoublons.GetBookmark;

      ExportGridToHTML(SaveDialog.FileName,dxDBGrid1,True,True);
    finally
      IBQDoublons.GotoBookmark(SavePlace);
      IBQDoublons.FreeBookmark(SavePlace);

      IBQDoublons.EnableControls;

    end;
  end;
end;

procedure TFListeDoublons.dxDBGrid1DBTableView1CellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  mOuvrirlaficheClick(Sender);
end;

procedure TFListeDoublons.mConsulterlaficheClick(Sender:TObject);
begin
  OpenFicheIndividuInBox(IBQDoublons.FieldByName('CLE_FICHE').AsInteger);
end;

procedure TFListeDoublons.SuperFormShowFirstTime(Sender: TObject);
begin
  Caption:=rs_Caption_List_of_probably_cloned_persons;
end;

end.

