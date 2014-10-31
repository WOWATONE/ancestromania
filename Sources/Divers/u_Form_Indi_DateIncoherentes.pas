{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Andr? Langlet (Main), Matthieu Giroux (LAZARUS),            }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                           }
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

unit u_Form_Indi_DateIncoherentes;

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
  U_FormAdapt,Forms,Variants,Graphics,Dialogs,Menus,DB,IBQuery,
  StdCtrls,Controls,ExtCtrls,
  Classes,u_buttons_appli,
  PrintersDlgs, u_ancestropictimages,
  U_ExtDBGrid, Grids, DBGrids;

type

  { TFIndiDateIncoherente }

  TFIndiDateIncoherente=class(TF_FormAdapt)
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    IBIncoherenreces:TIBQuery;
    DSIncoherenreces:TDataSource;
    pmUnions:TPopupMenu;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    ExporterenHTML1:TMenuItem;
    SaveDialog:TSaveDialog;
    Label1:TLabel;
    dxComponentPrinter1:TPrinterSetupDialog;
    N1:TMenuItem;
    mOuvreFiche:TMenuItem;
    mImprime:TMenuItem;
    dxDBGrid1:TExtDBGrid;
    fpBoutons: TPanel;
    GoodBtn7: TFWClose;
    btnPrint: TFWPrint;
    rbFormat: TRadioButton;
    rbValeur: TRadioButton;

    procedure dxDBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SuperFormCreate(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure pmUnionsPopup(Sender:TObject);
    procedure btnPrintClick(Sender:TObject);
    procedure mOuvreFicheClick(Sender:TObject);
    procedure mImprimeClick(Sender:TObject);
    procedure dxDBGrid1DBTableView1CellDblClick(
      Sender:TObject;
      ACellViewInfo:Longint;AButton:TMouseButton;
      AShift:TShiftState;var AHandled:Boolean);
    procedure rbFormatClick(Sender: TObject);

  private
    fCleFicheSelected:integer;
    bFirstOpen:boolean;
    procedure doOpen;

  public
    property CleFicheSelected:integer read fCleFicheSelected write fCleFicheSelected;
    procedure FirstOpen;

  end;

implementation

uses u_dm,u_common_const,u_common_ancestro,
     u_genealogy_context,
     fonctions_dialogs,
     u_common_ancestro_functions,
     fonctions_components;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFIndiDateIncoherente.SuperFormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  // Matthieu ?
  // dxDBGrid1DBTableView1.RestoreFromRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_INDIS_DATEINCOHERENTES');
  SaveDialog.InitialDir:=gci_context.PathDocs;
end;

procedure TFIndiDateIncoherente.dxDBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  value,valueSexe:Variant;
begin
  with dxDBGrid1,Datasource.Dataset do
    Begin
      // Matthieu : pas par colonne
      Value:=FieldByName('TITRE').Value;
      valueSexe:=FieldByName('Sexe').Value;

      if not VarIsNull(Value) then
      begin
        if (Value=1) then
          Canvas.Font.Style:= [fsBold]
        else
          Canvas.Font.Style:= [];
      end;

      if not VarIsNull(valueSexe) then
      begin
        if (valueSexe=1) then
          Canvas.Font.Color:=gci_context.ColorHomme
        else
          Canvas.Font.Color:=gci_context.ColorFemme;
      end;
      if Column.Field.Value='X' then
        Canvas.Font.Style:=[fsBold];
      if Column = SelectedColumn then
        if Canvas.Brush.Color=Color then
          Canvas.Brush.Color:=gci_context.ColorMedium;
    end;
end;

procedure TFIndiDateIncoherente.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBIncoherenreces.Close;
  // Matthieu ?
  //dxDBGrid1DBTableView1.StoreToRegistry(gci_context.KeyRegistry+DirectorySeparator+'W_INDIS_DATEINCOHERENTES');
  Action:=caFree;
  DoSendMessage(Owner,'FERME_INDIS_DATEINCOHERENTES');
end;

procedure TFIndiDateIncoherente.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Liste des dates incoherentes.HTM';
  if SaveDialog.Execute then
  begin
    IBIncoherenreces.DisableControls;
    try
      SavePlace:=IBIncoherenreces.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGrid1,True,True);
    finally
      IBIncoherenreces.GotoBookmark(SavePlace);
      IBIncoherenreces.FreeBookmark(SavePlace);
      IBIncoherenreces.EnableControls;
    end;
  end;
end;

procedure TFIndiDateIncoherente.pmUnionsPopup(Sender:TObject);
begin
  ExporterenHTML1.Enabled:=(IBIncoherenreces.Active)and(IBIncoherenreces.IsEmpty=false);
end;


procedure TFIndiDateIncoherente.doOpen;
var
  i:integer;
begin
  // Matthieu ?
//  dxDBGrid1.OptionsView.NoDataToDisplayInfoText:='Recherche en cours';
  dxDBGrid1.SetFocus;
  screen.Cursor:=crHourGlass;
  doShowWorking(rs_Wait+_CRLF+rs_Wait_Asking_to_database);
  application.ProcessMessages;
  try
    with IBIncoherenreces do
    begin
      Close;
      for i:=0 to Params.Count-1 do
        Params[i].AsInteger:=0;
      ParamByName('I_DOSSIER').AsInteger:=dm.NumDossier;
      if gci_context.CheckAgeMiniMariage then
      begin
        ParamByName('MIN_MAR_HOM').AsInteger:=gci_context.AgeMiniMariageHommes;
        ParamByName('MIN_MAR_FEM').AsInteger:=gci_context.AgeMiniMariageFemmes;
      end;
      if gci_context.CheckAgeMaxiMariage then
      begin
        ParamByName('MAX_MAR_HOM').AsInteger:=gci_context.AgeMaxiMariageHommes;
        ParamByName('MAX_MAR_FEM').AsInteger:=gci_context.AgeMaxiMariageFemmes;
      end;
      if gci_context.CheckAgeMiniNaissanceEnfant then
      begin
        ParamByName('MIN_ENF_HOM').AsInteger:=gci_context.AgeMiniNaissanceEnfantHommes;
        ParamByName('MIN_ENF_FEM').AsInteger:=gci_context.AgeMiniNaissanceEnfantFemmes;
      end;
      if gci_context.CheckAgeMaxiNaissanceEnfant then
      begin
        ParamByName('MAX_ENF_HOM').AsInteger:=gci_context.AgeMaxiNaissanceEnfantHommes;
        ParamByName('MAX_ENF_FEM').AsInteger:=gci_context.AgeMaxiNaissanceEnfantFemmes;
      end;
      if gci_context.CheckEsperanceVie then
      begin
        ParamByName('MAX_VIE_HOM').AsInteger:=gci_context.AgeMaxiAuDecesHommes;
        ParamByName('MAX_VIE_FEM').AsInteger:=gci_context.AgeMaxiAuDecesFemmes;
      end;
      if gci_context.CheckEcartAgeEpoux then
        ParamByName('MAX_ECART_EPOUX').AsInteger:=gci_context.EcartAgeEntreEpoux;
      if gci_context.CheckNbJourEntreNaissance then
      begin
        ParamByName('MIN_ENTRE_ENF').AsInteger:=gci_context.NbJourEntre2NaissancesNormales;
        ParamByName('MAX_ENTRE_JUMEAUX').AsInteger:=gci_context.NbJourEntre2NaissancesJumeaux;
      end;
      if rbFormat.Checked then
        ParamByName('MODE').AsInteger:=2
      else
        ParamByName('MODE').AsInteger:=1;

      Open;
    end;
  except
    ShowMessage('Erreur: Impossible de se connecter à la base ou format de dates incompatible.');
  end;
  doCloseWorking;
//  dxDBGrid1DBTableView1.OptionsView.NoDataToDisplayInfoText:='Pas de résultats';
  screen.Cursor:=crDefault;
end;

procedure TFIndiDateIncoherente.btnPrintClick(Sender:TObject);
begin
//  dxComponentPrinter1.Preview(True,nil);
end;

procedure TFIndiDateIncoherente.mOuvreFicheClick(Sender:TObject);
begin
  if (IBIncoherenreces.Active)and(not IBIncoherenreces.IsEmpty) then
  begin
    // Matthieu ?
    if dxDBGrid1.DataSource.DataSet.FieldByName('CLE_FICHE').AsString>'' then
    begin
      fCleFicheSelected:=IBIncoherenreces.FieldByName('clef_ind').AsInteger;
      if fCleFicheSelected>0 then
      begin
        dm.individu_clef:=fCleFicheSelected;
        DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
      end;
    end;
  end;
end;

procedure TFIndiDateIncoherente.mImprimeClick(Sender:TObject);
begin
  btnPrintClick(Sender);
end;

procedure TFIndiDateIncoherente.dxDBGrid1DBTableView1CellDblClick(
  Sender:TObject;
  ACellViewInfo:Longint;AButton:TMouseButton;
  AShift:TShiftState;var AHandled:Boolean);
begin
  mOuvreFicheClick(Sender)
end;

procedure TFIndiDateIncoherente.FirstOpen;
var
  reponse:word;
begin
  Enabled:=false;
  reponse:=MyMessageDlg(rs_Do_you_want_to_see_bad_formated_dates,mtConfirmation
    ,[mbYes,mbNo,mbCancel],Self);
  Enabled:=true;
  bFirstOpen:=true;
  if reponse=mrYes then
    rbFormat.Checked:=true
  else if reponse=mrNo then
    rbValeur.Checked:=true;
  Application.ProcessMessages;
  bFirstOpen:=false;
  if reponse<>mrCancel then
    doOpen
//  Matthieu ?
  //else
    //dxDBGrid1DBTableView1.OptionsView.NoDataToDisplayInfoText:='Pas de résultats';
end;

procedure TFIndiDateIncoherente.rbFormatClick(Sender: TObject);
begin
  if not bFirstOpen then
    doOpen;
end;

end.

