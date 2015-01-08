{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
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

unit u_form_Liste_Cousinage;

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
  U_FormAdapt,Forms,Graphics,
  u_comp_TYLanguage,Dialogs,DB,Menus,IBCustomDataSet,IBQuery,Controls,ExtCtrls,
  Classes,u_buttons_appli,
  U_ExtDBGrid,ExtJvXPCheckCtrls,lazutf8classes, ComCtrls, u_reports_components, U_OnFormInfoIni,
  SysUtils,IBSQL;

type

  { TFListeCousinage }

  TFListeCousinage=class(TF_FormAdapt)
    btnPrint: TFWPrintGrid;
    cxSplitter2: TSplitter;
    IBQListeNom:TIBQuery;
    dsListeNom:TDataSource;
    OnFormInfoIni: TOnFormInfoIni;
    pmGrid:TPopupMenu;
    mOuvrir:TMenuItem;
    N2:TMenuItem;
    ExporterenHTML1:TMenuItem;
    IBQListePreNom:TIBQuery;
    DSListePreNom:TDataSource;
    pBorder:TPanel;
    panBtn:TPanel;
    DSCousins:TDataSource;
    IBQCousins:TIBQuery;
    IBQListePreNomCLE_FICHE:TLongintField;
    IBQListeNomNOM:TIBStringField;
    IBQListePreNomPRENOM:TIBStringField;
    IBQListePreNomDATE_NAISSANCE:TIBStringField;
    IBQListePreNomSEXE:TLongintField;
    IBQCousinsCLE_FICHE:TLongintField;
    IBQCousinsNOM:TIBStringField;
    IBQCousinsPRENOM:TIBStringField;
    IBQCousinsDATE_NAISSANCE:TIBStringField;
    IBQCousinsSEXE:TLongintField;
    Panel2:TPanel;
    Panel4:TPanel;
    dxDBGCousins:TExtDBGrid;
    Panel8:TPanel;
    rbF:TJvXPCheckBox;
    rbH:TJvXPCheckBox;
    rbTous:TJvXPCheckBox;
    Panel14:TPanel;
    Panel15:TPanel;
    dxDBGrid1:TExtDBGrid;
    Panel17:TPanel;
    dxDBGrid2:TExtDBGrid;
    SaveDialog:TSaveDialog;
    Language:TYLanguage;
    cxSplitter1:TSplitter;
    pBottom:TPanel;
    bsfbSelection:TFWOK;
    btnFermer:TFWClose;
    TabControl:TTabControl;
    procedure btnPrintClick(Sender: TObject);
    procedure dxDBGCousinsDblClick(Sender: TObject);
    procedure IBQListeNomAfterScroll(DataSet: TDataSet);
    procedure IBQListePreNomAfterScroll(DataSet: TDataSet);
    procedure SuperFormCreate(Sender:TObject);
    procedure ExporterenHTML1Click(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure rbTousChange(Sender:TObject);
    procedure rbHChange(Sender:TObject);
    procedure rbFChange(Sender:TObject);
    procedure SpeedButton2Click(Sender:TObject);
    procedure bsfbSelectionClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure pmGridPopup(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure onTabControlDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
    procedure onTabControlChange(Sender:TObject);
    procedure dxDBGrid1DBTableView1DrawColumnCell(
      Sender:TObject;ACanvas:TCanvas;
      AViewInfo:Longint;var ADone:Boolean);
  private
    fFill:boolean;
    fNomPrenomIndividuSelected:string;
    fSexeIndividuSelected:integer;
    fNumOngletSelected:integer;
    fTextesOnglets:TStringlistUTF8;
    fClefIndividuSelected:integer;

    procedure doRefreshPrenoms;
    procedure doRefreshCousins;
    procedure doRefreshRepertoire;
    procedure InitOngletsActifs;
  public
    property ClefIndividuSelected:integer read fClefIndividuSelected write fClefIndividuSelected;
    property NomPrenomIndividuSelected:string read fNomPrenomIndividuSelected write fNomPrenomIndividuSelected;
    property SexeIndividuSelected:integer read fSexeIndividuSelected write fSexeIndividuSelected;
  end;

implementation

uses u_dm, fonctions_string, fonctions_components,
     u_common_functions,u_common_ancestro,u_common_const,u_genealogy_context;
{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFListeCousinage.doRefreshRepertoire;
begin
  IBQCousins.Close;
  IBQListePreNom.Close;
  with IBQListeNom do
  begin
    DisableControls;
    Close;
    SQL.Clear;
    if fNumOngletSelected>0 then
    begin
      SQL.Add('SELECT DISTINCT nom'
        +' FROM INDIVIDU'
        +' WHERE KLE_DOSSIER=:I_DOSSIER'
        +' and INDI_TRIE_NOM STARTING WITH :debut'
        +' order by nom');  // collate fr_fr
      ParamByName('debut').AsString:=copy(_AlphabetMaj,fNumOngletSelected,1);//nom commençant par
    end
    else
    begin
      SQL.Add('SELECT DISTINCT nom'
        +' FROM INDIVIDU'
        +' WHERE KLE_DOSSIER=:I_DOSSIER'
        +' and substring(indi_trie_nom from 1 for 1) not between ''A'' and ''Z'''
        +' order by nom');  // collate fr_fr
    end;

    ParamByName('I_DOSSIER').AsInteger:=dm.NumDossier;
    Open;
    EnableControls;
  end;
  doRefreshPrenoms;
end;

procedure TFListeCousinage.doRefreshPrenoms;
var
  i_sexe:smallint;
begin
  i_Sexe:=0;

  if rbTous.Checked then
    i_sexe:=0
  else if rbH.Checked then
    i_sexe:=1
  else if rbF.Checked then
    i_sexe:=2;

  IBQListePreNom.DisableControls;

  IBQListePreNom.Close;
  IBQListePreNom.Params[0].AsString:=IBQListeNomNOM.AsString;
  IBQListePreNom.Params[1].AsInteger:=dm.NumDossier;
  IBQListePreNom.Params[2].AsInteger:=i_Sexe;
  IBQListePreNom.Open;

  // Matthieu
  dxDBGrid2.Caption:=IBQListeNomNOM.AsString;
  IBQListePreNom.EnableControls;
  doRefreshCousins;
end;

procedure TFListeCousinage.ExporterenHTML1Click(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialog.FileName:='Cousins de '+AssembleString([IBQListeNomNOM.AsString,IBQListePrenomPRENOM.AsString])+'.HTM';

  if SaveDialog.Execute then
  begin
    IBQCousins.DisableControls;
    try
      SavePlace:=IBQCousins.GetBookmark;
      ExportGridToHTML(SaveDialog.FileName,dxDBGCousins,True,True);
    finally
      IBQCousins.GotoBookmark(SavePlace);
      IBQCousins.FreeBookmark(SavePlace);
    end;
    IBQCousins.EnableControls;
  end;
end;

procedure TFListeCousinage.SuperFormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  if Key=VK_ESCAPE then
  begin
    fClefIndividuSelected:=-1;
    ModalResult:=mrCancel;
  end;
end;

procedure TFListeCousinage.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  dxDBGCousins.Hint:=rs_Hint_You_can_Resize_the_columns_preview_resizing_your_grid_columns;
  Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  SaveDialog.InitialDir:=gci_context.PathDocs;
  InitOngletsActifs;
  fNumOngletSelected:=1;
  // Matthieu
  if TabControl.TabIndex=fNumOngletSelected then
    doRefreshRepertoire
  else
    TabControl.TabIndex:=fNumOngletSelected;
  fClefIndividuSelected:=-1;
  fNomPrenomIndividuSelected:='';
  SexeIndividuSelected:=-1;
  fFill:=true;
  try
    rbTous.checked:=true;
    rbH.checked:=false;
    rbF.checked:=false;
  finally
    fFill:=false;
  end;
  Height:=round(TControl(Owner).height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).width*gci_context.TailleFenetre/100);
end;

procedure TFListeCousinage.dxDBGCousinsDblClick(Sender: TObject);
begin
  bsfbSelectionClick(Sender);
end;

procedure TFListeCousinage.IBQListeNomAfterScroll(DataSet: TDataSet);
begin
  doRefreshPrenoms;
end;

procedure TFListeCousinage.btnPrintClick(Sender: TObject);
begin
  // Matthieu
  btnPrint.DBTitle:=fs_RemplaceMsg(rs_Print_list_of_cousins_of,
     [IBQListePreNomPRENOM.AsString+' '+
      IBQListeNomNOM.AsString+' ('+
      IBQListePreNomdate_naissance.AsString+')']);
end;

procedure TFListeCousinage.IBQListePreNomAfterScroll(DataSet: TDataSet);
begin
  doRefreshCousins;
  if IBQCousins.RecordCount > 1
   Then Caption := fs_RemplaceMsg(rs_Caption_Cousins_of,[IBQListePreNomPRENOM.AsString+ ' ' + IBQListeNomNOM.AsString+' (' +IBQListePreNomDATE_NAISSANCE.AsString+')'])
   Else Caption := fs_RemplaceMsg(rs_Caption_Cousin_of ,[IBQListePreNomPRENOM.AsString+ ' ' + IBQListeNomNOM.AsString+' (' +IBQListePreNomDATE_NAISSANCE.AsString+')']);
end;

procedure TFListeCousinage.rbTousChange(Sender:TObject);
begin
  if not fFill then
  begin
    fFill:=true;
    try
      rbTous.checked:=true;
      rbH.checked:=false;
      rbF.checked:=false;
    finally
      fFill:=false;
    end;
    doRefreshPrenoms;
  end;
end;

procedure TFListeCousinage.rbHChange(Sender:TObject);
begin
  if not fFill then
  begin
    fFill:=true;
    try
      rbTous.checked:=false;
      rbH.checked:=true;
      rbF.checked:=false;
    finally
      fFill:=false;
    end;
    doRefreshPrenoms;
  end;
end;

procedure TFListeCousinage.rbFChange(Sender:TObject);
begin
  if not fFill then
  begin
    fFill:=true;
    try
      rbH.checked:=false;
      rbTous.checked:=false;
      rbF.checked:=true;
    finally
      fFill:=false;
    end;
    doRefreshPrenoms;
  end;
end;

procedure TFListeCousinage.SpeedButton2Click(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFListeCousinage.bsfbSelectionClick(Sender:TObject);
begin
  fClefIndividuSelected:=IBQCousinsCLE_FICHE.AsInteger;

  fNomPrenomIndividuSelected:=AssembleString([IBQCousinsNOM.AsString,
    IBQCousinsPRENOM.AsString]);
  SexeIndividuSelected:=IBQCousinsSEXE.AsInteger;
  ModalResult:=mrOk;
end;

procedure TFListeCousinage.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQCousins.Close;
  fTextesOnglets.Free;
end;

procedure TFListeCousinage.pmGridPopup(Sender:TObject);
var
  ok:boolean;
begin
  ok:=(IBQCousins.Active)and(not IBQCousins.IsEmpty);
  mOuvrir.Enabled:=ok;
  ExporterenHTML1.Enabled:=Ok;
end;

procedure TFListeCousinage.SuperFormRefreshControls(Sender:TObject);
begin
  bsfbSelection.Enabled:=(IBQCousins.Active)and not IBQCousins.IsEmpty;
end;

procedure TFListeCousinage.SuperFormShow(Sender:TObject);
begin
  caption:=rs_Caption_List_of_cousins;
end;

procedure TFListeCousinage.doRefreshCousins;
begin
  IBQCousins.Close;
  IBQCousins.Params[0].AsInteger:=IBQListePreNomCLE_FICHE.AsInteger;
  IBQCousins.Open;
  DoRefreshControls;
end;


procedure TFListeCousinage.onTabControlDrawTabEx(
  AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  // Matthieu
  if ATab.TabIndex = 0 then
    ATab.Color:=gci_context.ColorLight
  else
     ATab.Color:=gci_context.ColorDark;
end;

procedure TFListeCousinage.onTabControlChange(Sender:TObject);
begin
  fNumOngletSelected:=TabControl.TabIndex;
  doRefreshRepertoire;
end;

procedure TFListeCousinage.InitOngletsActifs;
var
  i:integer;
  req:TIBSQL;
  actif:boolean;
begin
  req:=TIBSQL.Create(self);
  req.Database:=dm.ibd_BASE;
  req.Transaction:=dm.IBT_BASE;
  req.ParamCheck:=false;
  req.GoToFirstRecordOnExecute:=true;
  req.SQL.Text:='execute block returns (lettre char(1))as'
    +' declare variable i integer;'
    +' declare variable dossier integer;'
    +'begin dossier='+IntToStr(dm.NumDossier)+';'
    +'lettre=''0'';'
    +'select ''1'' from rdb$database'
    +' where exists (select 1 from individu where kle_dossier=:dossier'
    +'     and (indi_trie_nom<''A'' or indi_trie_nom>lpad(''Z'',110,''Z'')))'
    +'   or exists (select 1 from nom_attachement where kle_dossier=:dossier'
    +'     and (nom_lettre<''A'' or nom_lettre>''Z''))'
    +' into :lettre;'
    +'suspend;'
    +'lettre=''A'';'
    +'i=ascii_val(''A'');'
    +'while (lettre<=''Z'') do'
    +' begin'
    +' if (exists (select 1 from individu where kle_dossier=:dossier and indi_trie_nom starting with :lettre)) then'
    +' suspend;'
    +' else if (exists (select 1 from nom_attachement where kle_dossier=:dossier and nom_lettre=:lettre)) then'
    +' suspend;'
    +'i=i+1;'
    +'lettre=ascii_char(i);'
    +'end end';
  try
    req.ExecQuery;
    for i:=0 to 26 do
    begin
      if i=0 then
        actif:=req.Fields[0].AsString='1'
      else
        actif:=req.Fields[0].AsString=_AlphabetMaj[i];
      //Matthieu : Pas de possibilit? de d?sactiver
//      TabControl.Tabs[i].Enabled:=actif;
      if (actif or (i=0))and not req.Eof then
        req.Next;
    end;
    req.Close;
  finally
    req.Free;
  end;
end;

procedure TFListeCousinage.dxDBGrid1DBTableView1DrawColumnCell(
  Sender:TObject;ACanvas:TCanvas;
  AViewInfo:Longint;var ADone:Boolean);
begin
  if AViewInfo = dxDBGrid1.SelectedIndex then
    if ACanvas.Brush.Color=dxDBGrid1.FocusColor then
      ACanvas.Brush.Color:=gci_context.ColorMedium;
end;

end.

