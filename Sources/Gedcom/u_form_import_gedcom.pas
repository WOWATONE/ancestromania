{-----------------------------------------------------------------------}

{           Subprogram Name:                                            }
{           Purpose:          Ancestromania GPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }

{-----------------------------------------------------------------------}

{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }

{-----------------------------------------------------------------------}
{           2008 refonte par André Langlet                              }
{           Revision History                                            }
{           Date 03/01/2009 par André Langlet                           }
{           Gestion des notes de l'auteur                               }
{           14/12/2010 par André Langlet                                }
{           Intégration Adresses dans les événements individuels        }
{-----------------------------------------------------------------------}
unit u_form_import_gedcom;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  ShellAPI, jpeg, TPanelUnit, Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
  U_FormAdapt, IBCustomDataSet, IBUpdateSQL, DB,
  u_comp_TYLanguage, Dialogs, IBQuery, IBSQL, IBDatabase, Menus,
  lazutf8classes,
  u_comp_TBlueFlatSpeedButton, StdCtrls,
  ExtCtrls, Controls, Classes,
  u_ancestropictimages, Grids, BGRASpriteAnimation,
  u_objet_TState, u_objet_TImportGedCom, u_objet_TCut,
  u_gedcom_type, u_gedcom_func, SysUtils, Forms, ExtJvXPCheckCtrls,
  u_framework_components, MaskEdit, URLLink, u_buttons_appli, U_OnFormInfoIni;

type

  { TFImportGedcom }

  TFImportGedcom = class(TF_FormAdapt)
    btnLieuxCol1: TBlueFlatSpeedButton;
    btnLieuxCol2: TBlueFlatSpeedButton;
    btnLieuxCol3: TBlueFlatSpeedButton;
    btnLieuxCol4: TBlueFlatSpeedButton;
    btnLieuxCol5: TBlueFlatSpeedButton;
    btnLieuxCol6: TBlueFlatSpeedButton;
    btnLieuxCol7: TBlueFlatSpeedButton;
    cb_WinCharset: TComboBox;
    ibd_BASE: TIBDatabase;
    IBT_BASE: TIBTransaction;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label31: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    LabelCharset: TLabel;
    lImportMedias: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel4: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Notebook: TNotebook;
    page1: TPage;
    page2: TPage;
    page3: TPage;
    page4: TPage;
    page5: TPage;
    page6: TPage;
    page7: TPage;
    FlatGroupBox1: TGroupBox;
    Labelaa: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel7: TPanel;
    Panel8: TPanel;
    rbJeuCarWindows: TRadioButton;
    rbJeuCarMacintosh: TRadioButton;
    rbJeuCarMSDOS: TRadioButton;
    rbJeuCarAnsel: TRadioButton;
    FlatPanel1: TPanel;
    memoJeuxCaractere: TMemo;
    popup_FormatLieux: TPopupMenu;
    popupLieuVille: TMenuItem;
    popup_LieuCode: TMenuItem;
    popup_LieuDept: TMenuItem;
    popup_LieuRegion: TMenuItem;
    popup_LieuPays: TMenuItem;
    popup_LieuSubdivision: TMenuItem;
    popup_LieuIgnorer: TMenuItem;
    N1: TMenuItem;
    Label9: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label8: TLabel;
    rbDontTouchParticule: TRadioButton;
    rbWorkWithParticule: TRadioButton;
    LabelExParticule: TLabel;
    Label17: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    lbHeaderSource: TLabel;
    Label30: TLabel;
    lbHeaderNom: TLabel;
    lbHeaderDestination: TLabel;
    lbHeaderCodage: TLabel;
    lbHeaderLangue: TLabel;
    lbHeaderVersion: TLabel;
    lbHeaderCompagnie: TLabel;
    lbHeaderAdresse: TLabel;
    Label29: TLabel;
    InfosElements: TLabel;
    Label32: TLabel;
    IBSQL: TIBSQL;
    rbClearBdd: TRadioButton;
    rbAddToBdd: TRadioButton;
    Animate: TBGRASpriteAnimation;
    cbSeparateurLieux: TFWComboBox;
    edPathFileNameGED: TMaskEdit;
    Pourcent: TLabel;
    Label33: TLabel;
    lbNdFam: TLabel;
    Label35: TLabel;
    lbNbIndi: TLabel;
    Label7: TLabel;
    theGridLieux: TStringGrid;
    URLLink1: TURLLink;
    Label15: TLabel;
    URLLink2: TURLLink;
    Label36: TLabel;
    URLLink3: TURLLink;
    cbIgnoreEventIndiVide: TJvXPCheckBox;
    Panel5: TPanel;
    Label37: TLabel;
    Panel6: TPanel;
    cbImportEvent: TJvXPCheckBox;
    cbImportNotes: TJvXPCheckBox;
    cbImportSources: TJvXPCheckBox;
    cbImportTemoins: TJvXPCheckBox;
    Panel3: TPanel;
    BFSBSelection: TFWOK;
    btnPrevious: TFWPrior;
    btnNext: TFWNext;
    OpenDialog: TOpenDialog;
    Language: TYLanguage;
    IBMultimedia: TIBQuery;
    IBMultimediaMULTI_CLEF: TLongintField;
    IBMultimediaMULTI_INFOS: TIBStringField;
    IBMultimediaMULTI_MEDIA: TBlobField;
    IBMultimediaMULTI_DOSSIER: TLongintField;
    IBMultimediaMULTI_DATE_MODIF: TDateTimeField;
    IBMultimediaMULTI_MEMO: TMemoField;
    IBMultimediaMULTI_REDUITE: TBlobField;
    IBMultimediaMULTI_IMAGE_RTF: TLongintField;
    IBMultimediaMULTI_PATH: TIBStringField;
    IBMultimediaMULTI_NOM: TIBStringField;
    IBMultimediaID_IMPORT_GEDCOM: TLongintField;
    IBUMedia: TIBUpdateSQL;
    iVideo: TImage;
    iSons: TImage;
    lbChemin: TLabel;
    Label34: TLabel;
    iAutre: TImage;
    rbFormatGedcom: TRadioGroup;
    IBNomAttachement: TIBSQL;
    cbImportPatronymes: TJvXPCheckBox;
    LabelDossierImport: TLabel;
    EtiquetteDossierEnCours: TLabel;
    rbJeuCarUtf8: TRadioButton;
    cbImportImages: TJvXPCheckBox;
    btInfosAuteur: TXAInfo;
    procedure cb_WinCharsetChange(Sender: TObject);
    procedure OnFormInfoIniFormShow(Sender: TObject);
    procedure rbJeuCarWindowsChange(Sender: TObject);
    procedure SuperFormCreate(Sender: TObject);
    procedure WizardTreeChanging(Sender: TObject; NewItemIndex: integer;
      var AllowChange: boolean);
    procedure SuperFormRefreshControls(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure BFSBSelectionClick(Sender: TObject);
    procedure SuperFormDestroy(Sender: TObject);
    procedure btnLieuxCol1Click(Sender: TObject);
    procedure popupLieuClick(Sender: TObject);
    procedure rbJeuCarWindowsClick(Sender: TObject);
    procedure rbJeuCarMacintoshClick(Sender: TObject);
    procedure rbJeuCarMSDOSClick(Sender: TObject);
    procedure rbJeuCarAnselClick(Sender: TObject);
    procedure cbSeparateurLieuxChange(Sender: TObject);
    procedure rbDontTouchParticuleClick(Sender: TObject);
    procedure WizardTreeChange(Sender: TObject);
    procedure URLLink2Click(Sender: TObject);
    procedure rbClearBddClick(Sender: TObject);
    procedure rbAddToBddClick(Sender: TObject);
    procedure SuperFormHide(Sender: TObject);
    procedure btInfosAuteurClick(Sender: TObject);
    procedure rbJeuCarUtf8Click(Sender: TObject);
  private
    FImported : Boolean;
    fFirstPerson :Boolean;
    fFill: TState;
    F: THandle;
    CleFamille, CleEvInd: integer;
    //objet de décryptage du fichier gedcom
    fImportGedCom: TImportGedCom;
    //numéro de la page max, dans laquelle peut aller le user
    fMaxNumEtapePossible: integer;
    //le Header est-il déjà chargé ?
    fIsHeaderLoaded: boolean;
    //les exemples de noms sont-ils déjà chargés ?
    fExemplesDeNomsCharges: boolean;
    fExempleJeuxCaractere: TStringlistUTF8;
    FJeuCaractere: TSetCodageCaracteres;
    //les exemples d'adresses sont-ils chargés
    fIsQuelquesAdressesLoaded: boolean;
    fNumColConfiguring: integer;
    fColumnsLieuxOrder: array[1..7] of byte;
    fExempleLieux: TStringlistUTF8;
    FontColorWhite: boolean;
    fHeaderSource: string;
    fHeaderNom: string;
    fHeaderDestination: string;
    fHeaderCodage: string;
    fHeaderLangue: string;
    fHeaderVersion: string;
    fHeaderCompagnie: string;
    fHeaderAdresse: string;
    fHeaderNote: string;//AL 2009
    fHeaderDateTime: TDateTime;//AL 2009
    //pour la décomposition des noms
    fCutName: TCut;
    CutIndi: TCut;
    FileIndi: TFileStreamUTF8;
    NameFileIndi: string;
    CutEventIndi: TCut;
    FileEventIndi: TFileStreamUTF8;
    NameFileEventIndi: string;
    CutMediaPointeurs: TCut;
    FileMediaPointeurs: TFileStreamUTF8;
    NameFileMediaPointeurs: string;
    CutSource: TCut;
    FileSource: TFileStreamUTF8;
    NameFileSource: string;
    CutUnion: TCut;
    FileUnion: TFileStreamUTF8;
    NameFileUnion: string;
    CutEventFam: TCut;
    FileEventFam: TFileStreamUTF8;
    NameFileEventFam: string;
    CutAsso: TCut;
    FileAsso: TFileStreamUTF8;
    NameFileAsso: string;
    // N° de l import
    NumImportation: integer;
    fNumDossierImport: integer;
    lsCheminImage: string;
    bCPenPLAC: boolean;
    procedure InitProcess;
    function LoadFileImport: boolean;
    procedure RefreshButtonsLieux;
    procedure DoFillBddWithGedcomFile;
    function CreateIndividu(const AIndi: TTag_INDIVIDUAL_RECORD): boolean;
    procedure CreateEventsIndividu(const AIndi: TTag_INDIVIDUAL_RECORD);
    procedure CreateDomicilesIndividu(const AIndi: TTag_INDIVIDUAL_RECORD);
    procedure CreateMediaBase(const ATagMedia: TTag_MEDIA; const Cle_indi, pointe_sur: integer;
      const table, type_image: string);
    function CreateFamille(const AFamily: TTag_FAM_RECORD): boolean;
    procedure CreateEventsFamille(const AFam: TTag_FAM_RECORD);
    procedure CreateAssociationsEventsIndividu(const Indi: TTag_INDIVIDUAL_RECORD);
    procedure DecodeNom(const aNAME: string; var aNom, aPrenom: string);
    procedure DecodeAdresse(const aLINE: string;
      var aVille, aCP, aDept, aRegion, aPays, aSubd: string);
    procedure doOnProgressEvent(Sender: TObject; Pourcent: integer);
    procedure LoadEventPossibles(const aList: TStringlistUTF8);
    procedure GoToPage(const aNumPage: integer);
    function doLoadHeader: boolean;
    procedure DoLoadQuelquesExemplesDeNoms;
    procedure RefreshExempleJeuCaracteres;
    procedure DoLoadQuelquesAdresses;
    procedure RefreshExempleLieux;
    function  doImportation:Boolean;
    procedure doRefreshHeader;
    procedure SaveAssosOfEventFamille(const aEvent: TTag_Event_Detail; const aFam: TTag_FAM_RECORD);
    procedure RechercheImage;
    procedure CreateSourceEvent(const aEvent: TTag_Event_Detail;
                                const sTable: string;const un_indi: integer);
    procedure ListeErreurs;
  protected
    procedure DoShow; override;
  public
    destructor Destroy; override;
  end;

implementation

uses
  {$IFNDEF FPC}
  cDateTime,
  {$ELSE}
  {$ENDIF}
  u_common_resources,
  u_dm,
  u_form_main, fonctions_system,
  u_common_const,
  u_common_functions, u_common_ancestro,
  u_common_ancestro_functions,
  FileUtil,
  LazUTF8,
  fonctions_file,
  fonctions_dialogs,
  u_genealogy_context,
  fonctions_string,
  Math;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}

{$ENDIF}
const
  _COL_LIEU_IGNORER = 0;
  _COL_LIEU_VILLE = 1;
  _COL_LIEU_CODE = 2;
  _COL_LIEU_DEPT = 3;
  _COL_LIEU_REGION = 4;
  _COL_LIEU_PAYS = 5;
  _COL_LIEU_SUBD = 6;

  // keep  this function : Will be needed later, when utf8 will be correctly read by ibbatch
function fs_copy ( const astring:String; const aposition, alength : Int64):  String;
Begin
  Result:=fs_copyutf8(astring,aposition,alength,True);
end;

procedure TFImportGedcom.SuperFormCreate(Sender: TObject);
begin
  FImported := False;
  gs_GedcomCharsetFrom:=rs_charset_gedcom;
  AddCharsetsToStrings ( cb_WinCharset.Items );
  OnRefreshControls := SuperFormRefreshControls;
  Animate.AnimatedGifToSprite(fs_getImagesSoftDir + PLEASE_WAIT);
  Color := gci_context.ColorLight;
  Panel6.Color := gci_context.ColorDark;
  btnNext.Color := gci_context.ColorDark;
  btnPrevious.Color := gci_context.ColorDark;
  btnNext.ColorFrameFocus := gci_context.ColorDark;
  btnPrevious.ColorFrameFocus := gci_context.ColorDark;
  {
  btnNext.NumGlyphs:=2;
  btnPrevious.NumGlyphs:=2;}
  Language.RessourcesFileName := _REL_PATH_TRADUCTIONS + _FileNameTraduction;
  Language.Translate;
  fNumDossierImport := dm.NumDossier;
  fFill := TState.Create(False);
  fImportGedCom := TImportGedCom.Create;
  fImportGedCom.OnProgress := doOnProgressEvent;
  //jeux de caractère
  fExempleJeuxCaractere := TStringlistUTF8.Create;
  FJeuCaractere := ccNone;
  //les lieux
  fExempleLieux := TStringlistUTF8.Create;
  fColumnsLieuxOrder[1] := 1;
  fColumnsLieuxOrder[2] := 2;
  fColumnsLieuxOrder[3] := 3;
  fColumnsLieuxOrder[4] := 4;
  fColumnsLieuxOrder[5] := 5;
  fColumnsLieuxOrder[6] := 6;
  fColumnsLieuxOrder[7] := 0;
  RefreshButtonsLieux;
  RefreshExempleLieux;
  //On se place sur la première page
  GoToPage(0);
  //on ne peut pas aller sur les pages suivantes, pour l'instant
  fMaxNumEtapePossible := 0;
  //divers
  fCutName := TCut.Create;
  CutIndi := TCut.Create;
  CutIndi.ParamSeparator := CST_SEPARATE_WORDS;
  CutIndi.SetTotalStringParams(16);
  CutEventIndi := TCut.Create;
  CutEventIndi.ParamSeparator := CST_SEPARATE_WORDS;
  CutEventIndi.SetTotalStringParams(40);
  CutMediaPointeurs := TCut.Create;
  CutMediaPointeurs.ParamSeparator := CST_SEPARATE_WORDS;
  CutMediaPointeurs.SetTotalStringParams(9);
  CutSource := TCut.Create;
  CutSource.ParamSeparator := CST_SEPARATE_WORDS;
  CutSource.SetTotalStringParams(11);
  CutUnion := TCut.Create;
  CutUnion.ParamSeparator := CST_SEPARATE_WORDS;
  CutUnion.SetTotalStringParams(7);
  CutEventFam := TCut.Create;
  CutEventFam.ParamSeparator := CST_SEPARATE_WORDS;
  CutEventFam.SetTotalStringParams(38);
  CutAsso := TCut.Create;
  CutAsso.ParamSeparator := CST_SEPARATE_WORDS;
  CutAsso.SetTotalStringParams(9);
  FontColorWhite := True;
  rbFormatGedcom.ItemIndex := 0;
  //  rbFormatGedcom.InternalEditValue:=0;

  InfosElements.Caption := rs_Caption_Default_config_makes_importing_everything;
end;

procedure TFImportGedcom.OnFormInfoIniFormShow(Sender: TObject);
begin
  if (Notebook.PageIndex = 0) and FileExistsUTF8(edPathFileNameGED.Text) then
    LoadFileImport;
  SuperFormRefreshControls(Self);

end;

procedure TFImportGedcom.cb_WinCharsetChange(Sender: TObject);
begin
  gs_GedcomCharsetFrom:=CST_CHARSET_TO_CONVERT[cb_WinCharset.ItemIndex,0];
  if cb_WinCharset.Visible Then
    RefreshExempleJeuCaracteres;
end;

procedure TFImportGedcom.rbJeuCarWindowsChange(Sender: TObject);
begin

end;

procedure TFImportGedcom.SuperFormDestroy(Sender: TObject);
begin
  fImportGedCom.Free;
  fExempleJeuxCaractere.Free;
  fExempleLieux.Free;
  fFill.Free;
  fCutName.Free;
  CutIndi.Free;
  CutEventIndi.Free;
  CutMediaPointeurs.Free;
  CutSource.Free;
  CutUnion.Free;
  CutEventFam.Free;
  CutAsso.Free;
end;

function fs_GetConvertedDate ( const as_date : String ) : String;
Begin
  Result:=as_date;
end;

procedure TFImportGedcom.WizardTreeChanging(Sender: TObject;
  NewItemIndex: integer; var AllowChange: boolean);
begin
  if fFill.Value = False then
    begin
    //peut-on changer de page ?
    if NewItemIndex <= fMaxNumEtapePossible then
      begin
      GoToPage(NewItemIndex);
      end
    else
      AllowChange := False;
    SuperFormRefreshControls(Self);
    end;
end;

procedure TFImportGedcom.SuperFormRefreshControls(Sender: TObject);
begin
  //choix du fichier
  if Notebook.PageIndex = 0 then
    begin
    btnPrevious.Visible := False;
    btnNext.Caption := rs_Next;
    end
  else if Notebook.PageIndex = 1 then
    begin
    btnPrevious.Visible := True;
    btnNext.Caption := rs_Next;
    end
  else if NoteBook.PageIndex = NoteBook.PageCount - 1 then
    begin
    btnPrevious.Visible := True;
    btnNext.Caption := rs_Caption_Import;
    end
  else
    begin
    btnPrevious.Visible := True;
    btnNext.Caption := rs_Next;
    end;
  btnNext.Enabled := (fMaxNumEtapePossible > 0) and (fNumDossierImport > 0);
  LabelExParticule.Enabled := rbWorkWithParticule.Checked;
  LabelDossierImport.Caption := EtiquetteDossierEnCours.Caption + fNomDossier;
end;

procedure TFImportGedcom.btnPreviousClick(Sender: TObject);
begin
  if NoteBook.PageIndex > 0 then
    begin
    GoToPage(NoteBook.PageIndex - 1);
    end;
  SuperFormRefreshControls(Self);
end;

procedure TFImportGedcom.btnNextClick(Sender: TObject);
begin
  if NoteBook.PageIndex < NoteBook.PageCount - 1 then
    begin
      GoToPage(NoteBook.PageIndex + 1);
    end
  else
    begin
    //c'est le lancement de l'import
      FImported := doImportation;
    end;
  SuperFormRefreshControls(Self);
end;

procedure TFImportGedcom.BFSBSelectionClick(Sender: TObject);
var
  L, E: TFileStreamUTF8;
  s, str: string;
  c: char;
  n: integer;
begin//AL ajouté contrôle, copie et ajout CRLF pour mettre le fichier au format Windows
  if (edPathFileNameGED.Text > '') and DirectoryExistsUTF8(
    ExtractFileDir(edPathFileNameGED.Text)) then
    OpenDialog.InitialDir := ExtractFileDir(edPathFileNameGED.Text)
  else
    OpenDialog.InitialDir := gci_context.PathImportExport;
  if OpenDialog.Execute then
    begin
    s := OpenDialog.FileName;
    str := '';
    L := TFileStreamUTF8.Create (s, fmOpenRead);
    n := 0;
    while (L.Position < L.Size) and (L.Position < 100) do
      begin  //sauter le n premiers caractères du BOM si UTF-8
      L.Read(c, 1);
      if c = '0' then
        begin
        str := '0';
        n := L.Position - 1;
        Break;
        end;
      end;
    while (L.Position < L.Size) and (L.Position < 100) do
      begin
      L.Read(c, 1);
      if c = #10 then
        Break
      else if c = #13 then
        begin
        if L.Position < L.Size then//pour éviter erreur
          L.Read(c, 1); //lire le suivant
        break;
        end
      else
        str := str + c;
      end;

    if (L.Position = 100) or (UTF8UpperCase(TrimRight(str)) <> '0 HEAD') then
      begin
      L.Free;
      MyShowMessage(fs_RemplaceMsg(rs_Caption_File_is_not_a_gedcom,[ s ]));
      exit;
      end;
    if (c <> #10) or (n > 0) then
      begin
      L.Seek(n, soFromBeginning);//saute les n caractères avant 0 HEAD
      s := ChangeFileExt(s, 'CRLF' + ExtractFileExt(s));
      MyMessageDlg(rs_Info_File_is_not_Windows_formated_Will_create_a_copy_named +
        ExtractFileName(s), mtInformation, [mbOK]);
      E := TFileStreamUTF8.Create(s, fmCreate);
//      if rbJeuCarUtf8.Checked then
  //      FileWrite(THandle(E),UTF8BOM[1],Length(UTF8BOM));
      Screen.Cursor := crHourGlass;
        try
          while L.Position < L.Size do
            begin
            L.Read(c, 1);
            if c <> #10 then
              begin
              E.Write(c, 1);
              if c = #13 then
                begin
                c := #10;
                E.Write(c, 1);
                end;
              end;
            end;
        finally
          E.Free;
          Screen.Cursor := crDefault;
        end;
      end;
    L.Free;
    edPathFileNameGED.Text := s;//affichage du nom du fichier à importer
    if LoadFileImport then // Si chargement
      GoToPage(1);//On passe à la page suivante
    end
  else if FileExistsUTF8(edPathFileNameGED.Text) then
    LoadFileImport;
  SuperFormRefreshControls(Self);
end;

function TFImportGedcom.LoadFileImport: boolean;
begin
  InitProcess;//initialisation de l'objet d'import Gedcom
  lsCheminImage := ExtractFilePath(edPathFileNameGED.Text);
  Result := DoLoadHeader;//chargement de l'entête
end;

procedure TFImportGedcom.btnLieuxCol1Click(Sender: TObject);
var
  p: tpoint;
begin
  fNumColConfiguring := TControl(Sender).tag;
  p.x := 0;
  p.y := 0;
  p := TControl(Sender).clienttoscreen(p);
  popup_FormatLieux.popup(p.x, p.y + TControl(Sender).Height);
end;

procedure TFImportGedcom.popupLieuClick(Sender: TObject);
var
  n: integer;
begin
  fColumnsLieuxOrder[fNumColConfiguring] := TControl(Sender).Tag;
  //si une autre colonne possède le même tag, alors on la bascule à ignorer
  for n := 0 to 7 do
    if n <> fNumColConfiguring then
      begin
      if fColumnsLieuxOrder[n] = fColumnsLieuxOrder[fNumColConfiguring] then
        fColumnsLieuxOrder[n] := _COL_LIEU_IGNORER;
      end;
  RefreshButtonsLieux;
  RefreshExempleLieux;
end;

procedure TFImportGedcom.RefreshButtonsLieux;
var
  k: integer;
  s: string;
  n: integer;
begin
  for n := 1 to 7 do
    begin
    case fColumnsLieuxOrder[n] of
      _COL_LIEU_VILLE: s := popupLieuVille.Caption;
      _COL_LIEU_CODE: s := popup_LieuCode.Caption;
      _COL_LIEU_DEPT: s := popup_LieuDept.Caption;
      _COL_LIEU_REGION: s := popup_LieuRegion.Caption;
      _COL_LIEU_PAYS: s := popup_LieuPays.Caption;
      _COL_LIEU_SUBD: s := popup_LieuSubdivision.Caption;
      else
        s := '';//popup_LieuIgnorer.caption;
      end;
    k := pos('&', s);
    if k <> 0 then
      Delete(s, k, 1);
    case n of
      1: btnLieuxCol1.Caption := s;
      2: btnLieuxCol2.Caption := s;
      3: btnLieuxCol3.Caption := s;
      4: btnLieuxCol4.Caption := s;
      5: btnLieuxCol5.Caption := s;
      6: btnLieuxCol6.Caption := s;
      7: btnLieuxCol7.Caption := s;
      end;
    end;
end;

procedure TFImportGedcom.RefreshExempleLieux;
var
  n, k: integer;
  cut: TCut;
  s: string;
begin
  with theGridLieux do
    begin
    RowCount := 10;
    ColCount := 8;
    for n := 0 to 9 do //on efface tout
      for k := 0 to 7 do
        Cells[k, n] := '';
    end;
  Cut := TCut.Create;
  with Cut do
    try
    if cbSeparateurLieux.Text = '<TAB>' then
      ParamSeparator := CST_SEPARATE_WORDS
    else
      ParamSeparator := cbSeparateurLieux.Text;
    for n := 0 to fExempleLieux.Count - 1 do
      begin
      if n < 10 then //curieux on en a chargé jusqu'à 20?
        begin //découpage de la ligne
        s := fExempleLieux[n];
        Line := s;
        SetParamCountAsInLine;
        StrToParams;
        for k := 0 to 6 do
          begin
          if k < Params.Count then
            theGridLieux.cells[k, n] := Params[k].AsString;
          end;
        theGridLieux.cells[7, n] := s;
        end;
      end;
    finally
     Destroy;
    end;
end;

procedure TFImportGedcom.rbJeuCarWindowsClick(Sender: TObject);
begin
  if fFill.Value = False then
    begin
      FJeuCaractere := ccWindows;
      RefreshExempleJeuCaracteres;
    end;
end;

procedure TFImportGedcom.RefreshExempleJeuCaracteres;
var
  n: integer;
begin
  fFill.Value := True;
    try
    case FJeuCaractere of
      ccWindows: rbJeuCarWindows.Checked := True;
      ccMacintosh: rbJeuCarMacintosh.Checked := True;
      ccDOS: rbJeuCarMSDOS.Checked := True;
      ccANSEL: rbJeuCarAnsel.Checked := True;
      ccUTF8: rbJeuCarUtf8.Checked := True;
      end;
    cb_WinCharset.Visible := FJeuCaractere in [ccWindows,ccDOS];
    LabelCharset.Visible:=cb_WinCharset.Visible;
    memoJeuxCaractere.Lines.beginUpdate;
      try
        memoJeuxCaractere.Clear;
        for n := 0 to fExempleJeuxCaractere.Count - 1 do
          memoJeuxCaractere.Lines.add(fExempleJeuxCaractere[n]);
      finally
        memoJeuxCaractere.Lines.EndUpdate;
      end;
    fIsQuelquesAdressesLoaded := False;
    //AL 09/2011 pour que l'affichage des exemples de lieux se mettent aussi à jour
    finally
    fFill.Value := False;
    end;
end;

procedure TFImportGedcom.rbJeuCarMacintoshClick(Sender: TObject);
begin
  if fFill.Value = False then
    begin
      FJeuCaractere := ccMacintosh;
      RefreshExempleJeuCaracteres;
    end;
end;

procedure TFImportGedcom.rbJeuCarMSDOSClick(Sender: TObject);
begin
  if fFill.Value = False then
    begin
      FJeuCaractere := ccDOS;
      RefreshExempleJeuCaracteres;
    end;
end;

procedure TFImportGedcom.rbJeuCarAnselClick(Sender: TObject);
begin
  if fFill.Value = False then
    begin
      FJeuCaractere := ccANSEL;
      RefreshExempleJeuCaracteres;
    end;
end;

procedure TFImportGedcom.rbJeuCarUtf8Click(Sender: TObject);
begin
  if fFill.Value = False then
    begin
      FJeuCaractere := ccUTF8;
      RefreshExempleJeuCaracteres;
    end;
end;

procedure TFImportGedcom.cbSeparateurLieuxChange(Sender: TObject);
begin
  if fFill.Value = False then
    RefreshExempleLieux;
end;

function TFImportGedcom.CreateFamille(const AFamily: TTag_FAM_RECORD): boolean;
var
  s: string;
  aSOUR: TTag_SOURCE_CITATION;
  aNOTE: TTag_NOTE_STRUCTURE;
begin
  with AFamily, CutUnion do
    Begin
      //UNION_CLEF
      Params[0].AsInteger := Cle;
      //UNION_MARI
      if CLEF_HUSB = -1 then
        Params[1].Clear
      else
        Params[1].AsInteger := CLEF_HUSB;
      //UNION_FEMME
      if CLEF_WIFE = -1 then
        Params[2].Clear
      else
        Params[2].AsInteger := CLEF_WIFE;
      //KLE_DOSSIER
      Params[3].AsInteger := fNumDossierImport;
      //UNION_TYPE
      Params[4].AsInteger := 0;
      if _TYPU <> nil then
        begin
        Params[4].AsInteger := StrToIntDef(_TYPU.Value, 0);
        end;
      //SOURCE
      Params[5].AsString := '';
      if cbImportSources.Checked then
        begin
        aSOUR := _SOUR;
        while (aSOUR <> nil) do
          begin
          s := aSOUR.AsLine;
          Params[5].AsString := s;
          aSOUR := TTag_SOURCE_CITATION(aSOUR.PtrNextSameTag);
          end;
        end;
      //COMMENT
      Params[6].AsString := '';
      if cbImportNotes.Checked then
        begin
        aNOTE := _NOTE;
        while (aNOTE <> nil) do
          begin
          s := aNOTE.AsLine;
          Params[6].AsString := s;
          aNOTE := TTag_NOTE_STRUCTURE(aNOTE.PtrNextSameTag);
          end;
        end;
      if (Params[1].AsString > '') or (Params[2].AsString > '') then
        begin
        ParamsToStr;
        FileWrite0(FileUnion, Line);
        //    Flush(FileUnion);
        Result := True;
        end
      else
        Result := False;
    end;
end;

function TFImportGedcom.CreateIndividu(const AIndi: TTag_INDIVIDUAL_RECORD): boolean;
const
  _F_CLE_FICHE = 0;
  _F_CLE_PERE = 1;
  _F_CLE_MERE = 2;
  _F_PREFIXE = 3;
  _F_NOM = 4;
  _F_PRENOM = 5;
  _F_SURNOM = 6;
  _F_SUFFIXE = 7;
  _F_SEXE = 8;
  _F_SOURCE = 9;
  _F_COMMENT = 10;
  _F_FILLIATION = 11;
  _F_DATE_CREATION = 12;//AL date CHAN figurant dans le gedcom
  _F_MODIF_PAR_QUI = 13;
  _F_NCHI = 14;
  _F_NMR = 15;
  //  _F_CLE_FIXE=27;//AL transfert abandonné car peut entrer en conflit avec clé existante
var
  sex: smallint;
  s: string;
  aNom, aPrenom: string;
  aSOUR: TTag_SOURCE_CITATION;
  tNom: TTag_Personal_Name_Structure;
  aNOTE: TTag_NOTE_STRUCTURE;
begin
  with CutIndi,Aindi do
   Begin
    if fFirstPerson Then
     Begin
      dm.individu_clef:=cle;
      fFirstPerson:=False;
     end;
    Params[_F_CLE_FICHE].AsInteger := cle;
    if CLE_PERE = -1 then
      Params[_F_CLE_PERE].Clear
    else
      Params[_F_CLE_PERE].AsInteger := CLE_PERE;
    if CLE_MERE = -1 then
      Params[_F_CLE_MERE].Clear
    else
      Params[_F_CLE_MERE].AsInteger := CLE_MERE;
    if _NAME <> nil then
      begin
      if _NAME._NPFX <> nil then
        Params[_F_PREFIXE].AsString := fs_copy(_NAME._NPFX.Value, 1, 30)
      else
        Params[_F_PREFIXE].Clear;
      DecodeNom(_NAME.Value, aNom, aPrenom);
      Params[_F_NOM].AsString := fs_copy(aNom, 1, 40);
      Params[_F_PRENOM].AsString := fs_copy(aPrenom, 1, 60);
      if _NAME._NICK <> nil then
        Params[_F_SURNOM].AsString := fs_copy(_NAME._NICK.Value, 1, 120)
      else
        Params[_F_SURNOM].Clear;
      if _NAME._NSFX <> nil then
        Params[_F_SUFFIXE].AsString := fs_copy(_NAME._NSFX.Value, 1, 30)
      else
        Params[_F_SUFFIXE].Clear;
      if cbImportPatronymes.Checked then
        begin
        tNom := TTag_Personal_Name_Structure(_NAME.PtrNextSameTag);
        while tNom <> nil do //AL gestion des patronymes
          begin
          IBNomAttachement.Params[0].AsInteger := cle;
          DecodeNom(tNom.Value, aNom, aPrenom);
          IBNomAttachement.Params[1].AsString := fs_copy(aNom, 1, 40);
          IBNomAttachement.Params[2].AsInteger := fNumDossierImport;
          IBNomAttachement.ExecQuery;
          IBNomAttachement.Close;
          tNom := TTag_Personal_Name_Structure(tNom.PtrNextSameTag);
          end;
        end;
      end
    else
      begin
      Params[_F_PREFIXE].Clear;
      Params[_F_NOM].Clear;
      Params[_F_PRENOM].Clear;
      Params[_F_SURNOM].Clear;
      Params[_F_SUFFIXE].Clear;
      end;
    sex := 0;
    if _SEX <> nil then
      begin
      s := AnsiUpperCase(_SEX.Value);
      if s = 'M' then
        sex := 1
      else if s = 'F' then
        sex := 2;
      end;
    Params[_F_SEXE].AsInteger := sex;

    if _NCHI <> nil then
      begin
      if (StrToInt(_NCHI.Value) >= 0) then
        Params[_F_NCHI].AsInteger := StrToInt(_NCHI.Value);
      end
    else
      Params[_F_NCHI].Clear;
    if _NMR <> nil then
      begin
      if (StrToInt(_NMR.Value) >= 0) then
        Params[_F_NMR].AsInteger := StrToInt(_NMR.Value);
      end
    else
      Params[_F_NMR].Clear;
    //  if __ANCES_CLE_FIXE<>nil then
    //  begin
    //    if (StrToInt(__ANCES_CLE_FIXE.Value)>=0) then
    //      Params[_F_CLE_FIXE].AsInteger:=StrToInt(__ANCES_CLE_FIXE.Value);
    //  end
    //  else
    //    Params[_F_CLE_FIXE].Clear;
    Params[_F_SOURCE].Clear;
    if cbImportSources.Checked then
      begin
      aSOUR := _SOUR;
      while (aSOUR <> nil) do
        begin
        s := aSOUR.AsLine;
        Params[_F_SOURCE].AsString := s;
        aSOUR := TTag_SOURCE_CITATION(aSOUR.PtrNextSameTag);
        end;
      end;
    Params[_F_COMMENT].Clear;
    if cbImportNotes.Checked then
      begin
      aNOTE := _NOTE;
      while (aNOTE <> nil) do
        begin
        s := aNOTE.AsLine;
        Params[_F_COMMENT].AsString := s;
        aNOTE := TTag_NOTE_STRUCTURE(aNOTE.PtrNextSameTag);
        end;
      end;
    Params[_F_FILLIATION].Clear;
    if _FILA <> nil then
      begin
      s := _FILA.Value;
      if s > '' then
        Params[_F_FILLIATION].AsString := s;
      end;
    if _FAMC <> nil then
      if _FAMC._NOTE <> nil then
        begin
        s := _FAMC._NOTE.Value;//donne la première ligne
        if pos('Filiation ', s) > 0 then
          Params[_F_FILLIATION].AsString :=
            trim(copy(s, pos('Filiation ', s) + 10, 30));
        end;
    //  Params[_F_NUM_SOSA].clear;
    //DATE_MODIF //MD ajouter la date de CHAN du GEDCOM
    //AL: convention:La date de modification enregistrée est la date de l'importation
    //La date de création est celle de modification de l'individu si elle figure dans le gedcom (INDI)
    //si non la date du gedcom (HEAD)
    Params[_F_DATE_CREATION].AsDateTime := fHeaderDateTime;//valeur par défaut
      try
      if _CHAN <> nil then
       with _CHAN do
        begin
        if _DATE <> nil then
         with _GDate do
          begin
          DecodeGedcomDate(_DATE.Value);
             if ValidDateTime1 then
            if _DATE._TIME <> nil then
              begin
              //s:=copy(_DATE._TIME.Value,1,length(_DATE._TIME.Value)); //MD
              s := _DATE._TIME.Value;//quel est l'intérêt du copy? AL
              Params[_F_DATE_CREATION].AsDateTime :=
                DateTime1 + fs_Str2DateTime(s);
              end;
          end;
        end;
      except
      end;
    //  Params[_F_DATE_MODIF].Clear;//AL donnée par la base
    Params[_F_MODIF_PAR_QUI].AsString :='Gedcom n° ' + IntToStr(NumImportation);
    // MD à la place de 'UnKnown'
    ParamsToStr;
    FileWrite0(FileIndi, Line);
  End;
  // Flush(FileIndi);
  Result := True;
end;

procedure TFImportGedcom.CreateEventsIndividu(const AIndi: TTag_INDIVIDUAL_RECORD);

  procedure SaveEvent( aEvent: TTag_Event_Detail);
  var
    s: string;
    i: integer;
    aVille, aCP, aDept, aRegion, aPays, aSubd, sActe: string;
    aSOUR: TTag_SOURCE_CITATION;
    TagMedia: TTag_MEDIA;
    aTag: TTag;
  begin
    with aEvent,CutEventIndi do
     while aEvent <> nil do
      begin
      //EV_IND_CLEF
      Params[0].AsInteger := CleEvInd;
      Cle := CleEvInd;//AL pour la création des sources
      //EV_IND_KLE_FICHE
      Params[1].AsInteger := AIndi.cle;
      //EV_IND_KLE_DOSSIER
      Params[2].AsInteger := fNumDossierImport;
      //EV_IND_TYPE
      Params[3].AsString := copy(Caption, 1, 7);
      for i := 4 to Params.Count - 1 do
        Params[i].Clear;
      //DESCRIPTION
      Params[15].AsString := fs_copy(Value, 1, 90);
      // Si c'est un événement divers on charge le titre et la description qui sont dans TYPE
      if _TYPE <> nil then //TITRE_EVENT et DESCRIPTION
        begin//importer TYPE dans description même si pas après EVEN (AL)
        s := _TYPE.Value;
        i := Pos(#194#160, s);
        if i > 0 then
          begin
            Params[22].AsString := fs_copy(Copy(s, 1, i - 1), 1, 25);
            Params[15].AsString := fs_Copy(s, i + 2, 90);
          end
        else
          Params[15].AsString := fs_copy(s, 1, 90);
        end;
      // -----------------------------------------------------------------------------------------------
      //DATE_WRITEN, DATE, DATE_YEAR, DATE_MOIS, DATE_FIN, DATE_YEAR_FIN, DATE_MOIS_FIN, HEURE
      if _DATE <> nil then
        //Params[4].AsString:=trim(copy(_DATE.Value,1,100)); //AL si décodage par la base
       with _GDate do
        begin
        DecodeGedcomDate(_Date.Value);
        Params[4].AsString := fs_copy(fs_GetConvertedDate(HumanDate), 1, 100);
        if UseDate1 then
          begin
          Params[5].AsInteger := Year1;
          //MD utilisation de ShortDateFormat pour eviter les problèmes de culture AL?
          if ValidDateTime1 then
            Params[6].AsString :=
              FormatDateTime(ShortDateFormat, DateTime1);
          if (Month1 > 0) then
            Params[25].AsInteger := Month1;
          Params[26].AsInteger := DateCodeTard;
          Params[32].AsInteger := DateCode1;
          Params[33].AsInteger := DateCodeTot;
          if Day1 > 0 then
            Params[34].AsInteger := Day1;
          if Type_Key1 > 0 then
            Params[36].AsInteger := Type_Key1;
          end;
        if UseDate2 then
          begin
          Params[27].AsInteger := Year2;
          if (Month2 > 0) then
            Params[28].AsInteger := Month2;
          if Day2 > 0 then
            Params[35].AsInteger := Day2;
          if Type_Key2 > 0 then
            Params[37].AsInteger := Type_Key2;
          end;
        end;
      if _TIME <> nil then
          try
          Params[21].AsString := copy(_TIME.Value, 1, 5);
          except
          end;
      if __ANCES_XINSEE <> nil then
        Params[19].AsString := copy(__ANCES_XINSEE.Value, 1, 6);

      //Latitude N quand positif, S si négatif
      //Longitude E quand positive et W quand négative
      if _LATI <> nil then //récupération anciens gedcom
        if Copy(_LATI.Value, 1, 1) = 'S'
         then Params[23].AsString := '-' + copy(_LATI.Value, 2, 20)
         else Params[23].AsString := copy(_LATI.Value, 2, 20);
      if _LONG <> nil then
        if Copy(_LONG.Value, 1, 1) = 'W'
         then Params[24].AsString := '-' + fs_copy(_LONG.Value, 2, 20)
         else Params[24].AsString := fs_copy(_LONG.Value, 2, 20);
      //CP, VILLE, DEPT, REGION, PAYS, SUBD
      if _PLAC <> nil then
        begin
        DecodeAdresse(_PLAC.Value, aVille, aCP, aDept, aRegion, aPays, aSubd);
        if bCPenPLAC then
          Params[8].AsString := trim(copy(aCP, 1, 10))
        else
          Params[19].AsString := trim(copy(aCP, 1, 6));
        Params[9].AsString := trim(fs_copy(aVille, 1, 50));//AL était 30
        Params[10].AsString := trim(fs_copy(aDept, 1, 30));
        Params[11].AsString := trim(fs_copy(aPays, 1, 30));
        Params[16].AsString := trim(fs_copy(aRegion, 1, 50));
        Params[17].AsString := trim(fs_copy(aSubd, 1, 50));
        if _PLAC._NOTE <> nil then
          begin
          s := _PLAC._NOTE.Value;//donne la première ligne
          if pos('Code INSEE ', s) > 0 then
            Params[19].AsString :=
              trim(copy(s, pos('Code INSEE ', s) + 11, 6))
          else if pos('Code postal ', s) > 0 then
            Params[8].AsString :=
              trim(copy(s, pos('Code postal ', s) + 12, 10))
          else if pos('Lieu ', s) > 0 then
            Params[7].AsString := trim(copy(s, pos('Lieu ', s) + 5, 248))
          else if pos('Latitude ', s) > 0 then
            begin
            if trim(copy(s, pos('Latitude ', s) + 9, 1)) = 'S' then
              Params[23].AsString :=
                '-' + trim(copy(s, pos('Latitude ', s) + 10, 20))
            else
              Params[23].AsString :=
                trim(copy(s, pos('Latitude ', s) + 10, 20));
            end
          else if pos('Longitude ', s) > 0 then
            begin
            if trim(copy(s, pos('Longitude ', s) + 10, 1)) = 'W' then
              Params[24].AsString :=
                '-' + trim(copy(s, pos('Longitude ', s) + 11, 20))
            else
              Params[24].AsString :=
                trim(copy(s, pos('Longitude ', s) + 11, 20));
            end;
          for i := 0 to Min(_PLAC._NOTE.Memo.Count - 1, 3) do
            begin
            s := trim(_PLAC._NOTE.Memo[i]);
            if pos('Code INSEE ', s) > 0 then
              Params[19].AsString :=
                trim(copy(s, pos('Code INSEE ', s) + 11, 6))
            else if pos('Code postal ', s) > 0 then
              Params[8].AsString :=
                trim(copy(s, pos('Code postal ', s) + 12, 10))
            else if pos('Lieu ', s) > 0 then
              begin
              if not Params[7].IsNull then
                Params[7].AsString :=
                  Params[7].AsString + _CRLF +
                  trim(copy(s, pos('Lieu ', s) + 5, 248))
              else
                Params[7].AsString :=
                  trim(copy(s, pos('Lieu ', s) + 5, 248));
              end
            else if pos('Latitude ', s) > 0 then
              begin
              if trim(copy(s, pos('Latitude ', s) + 9, 1)) = 'S' then
                Params[23].AsString :=
                  '-' + trim(copy(s, pos('Latitude ', s) + 10, 20))
              else
                Params[23].AsString :=
                  trim(copy(s, pos('Latitude ', s) + 10, 20));
              end
            else if pos('Longitude ', s) > 0 then
              begin
              if trim(copy(s, pos('Longitude ', s) + 10, 1)) = 'W' then
                Params[24].AsString :=
                  '-' + trim(copy(s, pos('Longitude ', s) + 11, 20))
              else
                Params[24].AsString :=
                  trim(copy(s, pos('Longitude ', s) + 11, 20));
              end;
            end;
          end;
        if _PLAC._MAP <> nil then
          //récupération des coordonnées si Tag MAP existe (GEDCOM 5.5.1) AL2011
          begin
          if _PLAC._MAP._LATI <> nil then
            if Copy(_PLAC._MAP._LATI.Value, 1, 1) = 'S' then
              Params[23].AsString :=
                '-' + copy(_PLAC._MAP._LATI.Value, 2, 20)
            else
              Params[23].AsString :=
                copy(_PLAC._MAP._LATI.Value, 2, 20);
          if _PLAC._MAP._LONG <> nil then
            if Copy(_PLAC._MAP._LONG.Value, 1, 1) = 'W' then
              Params[24].AsString :=
                '-' + copy(_PLAC._MAP._LONG.Value, 2, 20)
            else
              Params[24].AsString :=
                copy(_PLAC._MAP._LONG.Value, 2, 20);
          end;
        end;//fin de PLAC

      if Params[3].AsString = 'RESI' then //ev_ind_type
        begin
        //ADDR AL10/2011 lignes d'adresses des RESI transmisent avec ADDR au lieu des notes de PLAC
        if _ADDR <> nil then
          begin
          s := _ADDR.Value;//asLine comprend ADDR1,ADDR2, POST etc...
          aTag := _ADDR._CONT;
          while aTag <> nil do
            begin
            s := s + _CRLF + aTag.Value;
            aTag := aTag.PtrNextSameTag;
            end;
          Params[7].AsString := s; //ev_ind_lignes_adresse
          end;
        //ADR_TEL //AL 12/2010 intégration des adresses dans les événements
        if _PHON <> nil then
          begin
          s := _PHON.AsLine;
          Params[29].AsString := s;
          end;
        //ADR_MAIL
        if _EMAIL <> nil then
          begin
          s := _EMAIL.AsLine;
          Params[30].AsString := fs_copy(_EMAIL.Value, 1, 250);
          end;
        //ADR_WEB
        if _WWW <> nil then
          begin
          s := _WWW.AsLine;
          Params[31].AsString := fs_copy(_WWW.Value, 1, 120);
          end;
        end;

      //Cause
      if _CAUS <> nil then
        Params[12].AsString := fs_copy(_CAUS.Value, 1, 90);
      //Source
      if (cbImportSources.Checked) and (_SOUR <> nil) then
        begin
        if _SOUR.ID = '' then
          begin
          aSOUR := _SOUR;//AL permet de lire un fichier avec sources non pointées
          while (aSOUR <> nil) do
            begin
            s := aSOUR.AsLine;
            Params[13].AsString := s;
            aSOUR := TTag_SOURCE_CITATION(aSOUR.PtrNextSameTag);
            end;//Al fin
          end
        else
          begin
          //erreur/GEDCOM confusion des niveaux SOURCE_CITATION et SOURCE_RECORD
          //on devrait d'abord importer SOURCE_CITATION avant SOURCE_RECORD s'ils étaient correctement définis.
          s_ABBR := '';
          s_TEXT := '';
          s_TITL := '';
          s_REPO := '';
          s_AUTH := '';
          s_PUBL := '';
          s := _SOUR.AsLine;
          //initialise les variables pour lire la source pointée
          CreateSourceEvent(aEvent, 'I', AIndi.Cle);
          end;
        end;
      //Commentaires
      if cbImportNotes.Checked then
        begin
        if _NOTE <> nil then
          begin
          s := _NOTE.AsLine;
          Params[14].AsString := s;
          end;
        end;
      if Params[3].AsString <> 'RESI' then
        begin//récupération ancien Lieu dans subdivision ou en tête des notes AL11/2011
        if Params[7].AsString > '' then
          begin
          if Params[17].AsString = '' then
            Params[17].AsString := Params[7].AsString
          else if Params[14].AsString > '' then
            Params[14].AsString :=
              Params[7].AsString + _CRLF + Params[14].AsString
          else
            Params[14].AsString := Params[7].AsString;
          end;
        end;

      if __ANCES_ORDRE <> nil then
        Params[20].AsInteger := StrToInt(__ANCES_ORDRE.Value);
      if __ORDR <> nil then //AL
        Params[20].AsInteger := StrToInt(__ORDR.Value);
      sActe := '';
      if __ANCES_XACTE <> nil then
        begin
        sActe := Copy(__ANCES_XACTE.Value, 1, 1);
        if StrToInt(sActe) = 1 then
          Params[18].AsInteger := StrToInt(sActe);
        end;
      if __ACTE <> nil then //AL
        begin
        sActe := Copy(__ACTE.Value, 1, 2);
        if StrToInt(sActe) > -10 then
          Params[18].AsInteger := StrToInt(sActe);
        end;
      if cbImportImages.Checked then
        begin
        //          if _OBJE<>nil then
        //          begin
        //            CreateMediaBase(_OBJE,AIndi.Cle,CleEvInd,'I','A');
        //            Params[18].AsInteger:=1;
        //          end;
        TagMedia := _OBJE;//AL2010 pour médias multiples
        while TagMedia <> nil do
          begin
          CreateMediaBase(TagMedia, AIndi.Cle, CleEvInd, 'I', 'A');
          TagMedia := TTag_MEDIA(TagMedia.PtrNextSameTag);
          end;
        end;
      ParamsToStr;
      FileWrite0(FileEventIndi, Line);
      // Flush(FileEventIndi);

      //on cherche le suivant...
      aEvent := TTag_Event_Detail(PtrNextSameTag);
      Inc(CleEvInd);
      end;
  end;

begin
  if AIndi.Cle <> -1 then
    begin
    //INDIVIDUAL_EVENT_STRUCTURE
    SaveEvent(AIndi._BIRT);
    SaveEvent(AIndi._DIPL);
    SaveEvent(AIndi._CHR);
    SaveEvent(AIndi._DEAT);
    SaveEvent(AIndi._BURI);
    SaveEvent(AIndi._CREM);
    SaveEvent(AIndi._ADOP);
    SaveEvent(AIndi._BAPM);
    SaveEvent(AIndi._BARM);
    SaveEvent(AIndi._BASM);
    SaveEvent(AIndi._BLES);
    SaveEvent(AIndi._CHRA);
    SaveEvent(AIndi._CONF);
    SaveEvent(AIndi._FCOM);
    SaveEvent(AIndi._ORDN);
    SaveEvent(AIndi._NATU);
    SaveEvent(AIndi._EMIG);
    SaveEvent(AIndi._IMMI);
    SaveEvent(AIndi._CENS);
    SaveEvent(AIndi._PROB);
    SaveEvent(AIndi._WILL);
    SaveEvent(AIndi._GRAD);
    SaveEvent(AIndi._RETI);
    SaveEvent(AIndi._EVEN);//23
    //INDIVIDUAL_ATTRIBUTE_STRUCTURE
    SaveEvent(AIndi._CAST);
    SaveEvent(AIndi._DSCR);
    SaveEvent(AIndi._EDUC);
    SaveEvent(AIndi._IDNO);
    SaveEvent(AIndi._NATI);
    //SaveEvent(AIndi._NCHI);
    // SaveEvent(AIndi._NMR);
    SaveEvent(AIndi._OCCU);
    SaveEvent(AIndi._PROP);
    SaveEvent(AIndi._RELI);
    SaveEvent(AIndi._RESI);
    SaveEvent(AIndi._SSN);
    SaveEvent(AIndi._TITL);//13
    //LDS_INDIVIDUAL_ORDINANCE
    SaveEvent(AIndi._BAPL);
    SaveEvent(AIndi._CONL);
    SaveEvent(AIndi._ENDL);
    SaveEvent(AIndi._SLGC);//4
    //Autres Tag (de Heredis...)
    SaveEvent(AIndi._PURC);
    SaveEvent(AIndi._ALIV);
    SaveEvent(AIndi._MILI);
    SaveEvent(AIndi._SALE);
    SaveEvent(AIndi._TRIP);//5
    SaveEvent(AIndi._INHU);
    //Autres Tag proprietaire Ancestromania
    SaveEvent(AIndi._BRIT);
    SaveEvent(AIndi._XSPO);// Sports
    SaveEvent(AIndi._XLOI);// Loisirs
    SaveEvent(AIndi._X_MU1);// Musulman
    SaveEvent(AIndi._X_MU2);// Musulman
    SaveEvent(AIndi._X_MU3);// Musulman
    SaveEvent(AIndi._XHENN);// Juif
    SaveEvent(AIndi._XHOUP);// Juif
    SaveEvent(AIndi._LEGA);// AL mis là car prévu uniquement comme rôle dans une source
    end;
end;

procedure TFImportGedcom.CreateAssociationsEventsIndividu(const Indi: TTag_INDIVIDUAL_RECORD);

  procedure SaveAsso(aEvent: TTag_Event_Detail);
  var
    s: string;
    CleAsso: integer;
    aAsso: TTag_ASSOCIATION_STRUCTURE;
    indi_asso: TIndi;
  begin
    with aAsso, CutAsso do
    while aEvent <> nil do
      begin
      //on sauvegarde les associations en relation avec cet événement
      aAsso := aEvent._ASSO;
      while aAsso <> nil do
        begin
        indi_asso := fImportGedCom.GetIndividuByID(ID);
        if indi_asso <> nil then
          begin
          //récupération d'une clé pour le nouveau record
          CleAsso := dm.uf_GetClefUnique('T_ASSOCIATIONS');
          if CleAsso <> -1 then
            begin
            //ASSOC_CLEF
            Params[0].AsInteger := CleAsso;
            //ASSOC_KLE_IND
            Params[1].AsInteger := Indi.Cle;
            //ASSOC_KLE_ASSOCIE
            Params[2].AsInteger := indi_asso.Cle;
            //ASSOC_KLE_DOSSIER
            Params[3].AsInteger := fNumDossierImport;
            //ASSOC_NOTES
            Params[4].AsString := '';
            if cbImportNotes.Checked then
              begin
              if _NOTE <> nil then
                begin
                s := _NOTE.AsLine;
                Params[4].AsString := s;
                end;
              end;
            //ASSOC_SOURCES
            Params[5].AsString := '';
            if cbImportNotes.Checked then
              begin
              if _SOUR <> nil then
                begin
                s := _SOUR.AsLine;
                Params[5].AsString := s;
                end;
              end;
            //ASSOC_LIBELLE    AL2009
            Params[6].AsString := 'Other';
            if _RELA <> nil then
              begin
              s := _RELA.Value;
              Params[6].AsString := s;
              //Attention, pour le cas GODPARENT
              if AnsiUpperCase(s) = 'GODPARENT' then
                begin
                if gci_context.Langue = 'FRA' then
                  begin
                  if indi_asso.SEXE = 'F' then
                    Params[6].AsString := 'Marraine'
                  else
                    Params[6].AsString := 'Parrain';
                  end;
                end;
              end;
            //ASSOC_EVENEMENT
            Params[7].AsInteger := aEvent.Cle;//la cle de l'event
            //ASSOC_TABLE
            Params[8].AsString := 'I';
            ParamsToStr;
            FileWrite0(FileAsso, Line);
            // Flush(FileAsso);
            end;
          end;
        //le suivant
        aAsso := TTag_ASSOCIATION_STRUCTURE(PtrNextSameTag);
        end;
      //on cherche le suivant...
      aEvent := TTag_Event_Detail(aEvent.PtrNextSameTag);
      end;
  end;

begin
  if Indi.Cle <> -1 then
   with Indi do
    begin
    //INDIVIDUAL_EVENT_STRUCTURE
    SaveAsso(_BIRT);
    SaveAsso(_CHR);
    SaveAsso(_DEAT);
    SaveAsso(_BURI);
    SaveAsso(_CREM);
    SaveAsso(_ADOP);
    SaveAsso(_BAPM);
    SaveAsso(_BARM);
    SaveAsso(_BASM);
    SaveAsso(_BLES);
    SaveAsso(_CHRA);
    SaveAsso(_CONF);
    SaveAsso(_FCOM);
    SaveAsso(_ORDN);
    SaveAsso(_NATU);
    SaveAsso(_EMIG);
    SaveAsso(_IMMI);
    SaveAsso(_CENS);
    SaveAsso(_PROB);
    SaveAsso(_WILL);
    SaveAsso(_GRAD);
    SaveAsso(_RETI);
    SaveAsso(_EVEN);//23
    SaveAsso(_BRIT);
    //INDIVIDUAL_ATTRIBUTE_STRUCTURE
    SaveAsso(_CAST);
    SaveAsso(_DSCR);
    SaveAsso(_EDUC);
    SaveAsso(_IDNO);
    SaveAsso(_NATI);
    //SaveAsso(_NCHI);
    // SaveAsso(_NMR);
    SaveAsso(_OCCU);
    SaveAsso(_PROP);
    SaveAsso(_RELI);
    SaveAsso(_RESI);
    SaveAsso(_SSN);
    SaveAsso(_TITL);//13
    //LDS_INDIVIDUAL_ORDINANCE
    SaveAsso(_BAPL);
    SaveAsso(_CONL);
    SaveAsso(_ENDL);
    SaveAsso(_SLGC);//4
    //Autres Tag (de Heredis...)
    SaveAsso(_PURC);
    SaveAsso(_ALIV);
    SaveAsso(_MILI);
    SaveAsso(_SALE);
    SaveAsso(_TRIP);//5
    SaveAsso(_INHU);
    //Autres Tag proprietaire Ancestromania
    SaveAsso(_XSPO);// Sports
    SaveAsso(_XLOI);// Loisirs
    SaveAsso(_X_MU1);// Musulman
    SaveAsso(_X_MU2);// Musulman
    SaveAsso(_X_MU3);// Musulman
    SaveAsso(_XHENN);// Juif
    SaveAsso(_XHOUP);// Juif
    SaveAsso(_LEGA);// AL mis là car prévu uniquement comme rôle dans une source
    end;
end;

procedure TFImportGedcom.DecodeNom(const aNAME: string; var aNom, aPrenom: string);
var
  p: string;
  n, w: integer;
  c: char;
begin
  aNom := '';
  aPrenom := '';
  fCutName.ParamSeparator := '/';
  fCutName.Line := aName;
  fCutName.SetParamCountAsInLine;
  fCutName.StrToParams;
  if fCutName.Params.Count >= 1 then
    begin
    aPrenom := fCutName.Params[0].AsString;
    aPrenom := fs_FormatText(aPrenom, mftFirstIsMaj);//AL2009
    end;
  if fCutName.Params.Count >= 2 then
    begin
    aNom := fCutName.Params[1].AsString;
    aNom := fs_FormatText(aNom, mftUpper);
    end;
  if rbWorkWithParticule.Checked then //AL: limité à la particule en tête
    begin
    //on gère la particule
    aNom := trim(aNom);
    if aNom > '' then
      begin
      for n := 0 to dm.ListeParticules.Count - 1 do
        begin
        w := Length(dm.ListeParticules[n]);
        c := dm.ListeParticules[n][w];
        if ((c = '''') and (copy(aNom, 1, w) = dm.ListeParticules[n]))//AL2009
          or (copy(aNom, 1, w) + ' ' = dm.ListeParticules[n] + ' ') then
          begin
          //on a trouvé un nom à particule
          p := trim(copy(aNom, 1, w));
          Delete(aNom, 1, w);
          aNom := trim(aNom) + ' (' + p + ')';
          break;
          end;
        end;
      end;
    end;
end;

procedure TFImportGedcom.DecodeAdresse(const aLINE: string;
  var aVille, aCP, aDept, aRegion, aPays, aSubd: string);
var
  n: integer;
begin
  aCP := '';
  aVille := '';
  aDept := '';
  aRegion := '';
  aPays := '';
  aSubd := '';
  if cbSeparateurLieux.Text = '<TAB>' then
    fCutName.ParamSeparator := CST_SEPARATE_WORDS
  else
    fCutName.ParamSeparator := cbSeparateurLieux.Text;
  fCutName.Line := aLINE;
  fCutName.SetParamCountAsInLine;
  fCutName.StrToParams;
  for n := 1 to fCutName.Params.Count do
    begin
    case fColumnsLieuxOrder[n] of
      _COL_LIEU_VILLE: aVille := fCutName.Params[n - 1].AsString;
      _COL_LIEU_CODE: aCP := fCutName.Params[n - 1].AsString;
      _COL_LIEU_DEPT: aDept := fCutName.Params[n - 1].AsString;
      _COL_LIEU_REGION: aRegion := fCutName.Params[n - 1].AsString;
      _COL_LIEU_PAYS: aPays := fCutName.Params[n - 1].AsString;
      _COL_LIEU_SUBD: aSubd := fCutName.Params[n - 1].AsString;
      end;
    end;
end;

procedure TFImportGedcom.InitProcess;//Initialisation de l'objet d'importation
begin
  fImportGedCom.Clear;
  //Etape maximal possible
  fMaxNumEtapePossible := 0;
  //jeux de caractère
  fExempleJeuxCaractere.Clear;
  fIsHeaderLoaded := False;
  fExemplesDeNomsCharges := False;
  fIsQuelquesAdressesLoaded := False;
  fHeaderNom := '';
  fHeaderDestination := '';
  fHeaderCodage := '';
  fHeaderLangue := '';
  fHeaderVersion := '';
  fHeaderCompagnie := '';
  fHeaderAdresse := '';
end;

procedure TFImportGedcom.rbDontTouchParticuleClick(Sender: TObject);
begin
  SuperFormRefreshControls(Self);
end;

function TFImportGedcom.doLoadHeader: boolean;
var
  suite: boolean;
  s: string;
  n: integer;
  ok: boolean;
  Content: TStringlistUTF8;
  CutPlac: TCut;
  FOldCharset:TSetCodageCaracteres;
begin
  //on initialise la façon de lire les villes
  Result := False;
  for n := 1 to 7 do
    fColumnsLieuxOrder[n] := _COL_LIEU_IGNORER;
  Content := TStringlistUTF8.Create;
  try
    fIsHeaderLoaded := False;
    fHeaderSource := '';
    fHeaderNom := '';
    fHeaderDestination := '';
    fHeaderCodage := '';
    fHeaderLangue := '';
    fHeaderVersion := '';
    fHeaderCompagnie := '';
    fHeaderAdresse := '';
    fImportGedCom.LoadFromFileJustTheHeader(edPathFileNameGED.Text, Content,FJeuCaractere);
    suite := fImportGedCom.DecodageGedcom(fImportGedCom.GedcomStructureOfHeader,
      Content, FJeuCaractere);
    FOldCharset:=FJeuCaractere;
    if (suite) and (fImportGedCom.GedcomStructureOfHeader._HEAD <> nil) then
      begin
      fIsHeaderLoaded := True;
      //remplissage des infos du Header
      if fImportGedCom.GedcomStructureOfHeader._HEAD._SOUR <> nil then
        begin
        s := fImportGedCom.GedcomStructureOfHeader._HEAD._SOUR.Value;
        if fImportGedCom.GedcomStructureOfHeader._HEAD._SOUR._VERS <> nil then
          begin
          s := AssembleStringWithSep(
            [s, fImportGedCom.GedcomStructureOfHeader._HEAD._SOUR._VERS.Value], ' ');
          end;
        fHeaderSource := s;
        if fImportGedCom.GedcomStructureOfHeader._HEAD._SOUR._NAME <> nil then
          begin
          fHeaderNom := fImportGedCom.GedcomStructureOfHeader._HEAD._SOUR._NAME.Value;
          end;
        if fImportGedCom.GedcomStructureOfHeader._HEAD._SOUR._CORP <> nil then
          begin
          fHeaderCompagnie :=
            fImportGedCom.GedcomStructureOfHeader._HEAD._SOUR._CORP.Value;
          if fImportGedCom.GedcomStructureOfHeader._HEAD._SOUR._CORP._ADDR <> nil then
            begin
            fHeaderAdresse :=
              fImportGedCom.GedcomStructureOfHeader._HEAD._SOUR._CORP._ADDR.Value;
            end;
          end;
        end;
      if fImportGedCom.GedcomStructureOfHeader._HEAD._DEST <> nil then
        begin
        fHeaderDestination := fImportGedCom.GedcomStructureOfHeader._HEAD._DEST.Value;
        end;
      if fImportGedCom.GedcomStructureOfHeader._HEAD._CHAR <> nil then
        begin
        fHeaderCodage := fImportGedCom.GedcomStructureOfHeader._HEAD._CHAR.Value;
        fHeaderCodage := AnsiUpperCase(fHeaderCodage);
        if fHeaderCodage = 'ANSI' then
          begin
          FJeuCaractere := ccWindows;
          rbJeuCarWindows.Checked := True;
          end
        else if fHeaderCodage = 'MACINTOSH' then
          begin
          FJeuCaractere := ccMacintosh;
          rbJeuCarMacintosh.Checked := True;
          end
        else if fHeaderCodage = 'IBMPC' then
          begin
          FJeuCaractere := ccDOS;
          rbJeuCarMSDOS.Checked := True;
          end
        else if fHeaderCodage = 'ANSEL' then
          begin
          FJeuCaractere := ccANSEL;
          rbJeuCarAnsel.Checked := True;
          end
        else if (fHeaderCodage = 'UTF8') or (fHeaderCodage = 'UTF 8') or
          (fHeaderCodage = 'UTF-8') or (fHeaderCodage = 'UTF_8') or
          (fHeaderCodage = 'UTF.8') then
          begin
          FJeuCaractere := ccUTF8;
          rbJeuCarUtf8.Checked := True;
          end;
        if fImportGedCom.GedcomStructureOfHeader._HEAD._LANG <> nil then
          begin
          fHeaderLangue := fImportGedCom.GedcomStructureOfHeader._HEAD._LANG.Value;
          end;
        if fImportGedCom.GedcomStructureOfHeader._HEAD._GEDC <> nil then
          begin
          if fImportGedCom.GedcomStructureOfHeader._HEAD._GEDC._VERS <> nil then
            begin
            fHeaderVersion :=
              fImportGedCom.GedcomStructureOfHeader._HEAD._GEDC._VERS.Value;
            end;
          end;
        //ordre de PLAC
        if fImportGedCom.GedcomStructureOfHeader._HEAD._PLAC <> nil then
          begin
          if fImportGedCom.GedcomStructureOfHeader._HEAD._PLAC._FORM <> nil then
            begin
            s := trim(fImportGedCom.GedcomStructureOfHeader._HEAD._PLAC._FORM.Value);
            rbFormatGedcom.ItemIndex := 0;
            CutPlac := TCut.Create;
              try
              CutPlac.Line := s;
              CutPlac.ParamSeparator := ',';
              CutPlac.SetParamCountAsInLine;
              if CutPlac.StrToParams then
                begin
                for n := 0 to CutPlac.Params.Count - 1 do
                  begin
                  if n < 7 then
                    begin
                    s := fs_FormatText(trim(CutPlac.Params[n].AsString),mftUpper,true);
                    if (s = 'VILLE') or (s = 'TOWN') then
                      fColumnsLieuxOrder[n + 1] := _COL_LIEU_VILLE
                    else if (s = 'CODE LIEU') or (s = 'CODE POSTAL') or
                      (s = 'CODE INSEE') or (s = 'AREA CODE') then
                      fColumnsLieuxOrder[n + 1] := _COL_LIEU_CODE
                    else if (s = 'DEPARTEMENT') or (s = 'COUNTY') then
                      fColumnsLieuxOrder[n + 1] := _COL_LIEU_DEPT
                    else if (s = 'REGION') then
                      fColumnsLieuxOrder[n + 1] := _COL_LIEU_REGION
                    else if (s = 'PAYS') or (s = 'COUNTRY') then
                      fColumnsLieuxOrder[n + 1] := _COL_LIEU_PAYS
                    else if (s = 'SUBDIVISION') then
                      fColumnsLieuxOrder[n + 1] := _COL_LIEU_SUBD
                    else
                      fColumnsLieuxOrder[n + 1] := _COL_LIEU_IGNORER;
                    if s = 'CODE INSEE' then
                      rbFormatGedcom.ItemIndex := 1;
                    end;
                  end;
                end;
              finally
              CutPlac.Free;
              end;
            end;
          end;

        if fImportGedCom.GedcomStructureOfHeader._HEAD._NOTE <> nil then
          fHeaderNote := fImportGedCom.GedcomStructureOfHeader._HEAD._NOTE.AsLine
        else
          fHeaderNote := '';

        fHeaderDateTime := Now;//valeur par défaut AL
        try
          if fImportGedCom.GedcomStructureOfHeader._HEAD._DATE <> nil then
            begin
            s := fImportGedCom.GedcomStructureOfHeader._HEAD._DATE.Value;
            with _GDate do
            if DecodeGedcomDate(s) then
              begin
              if ValidDateTime1 then
                begin
                fHeaderDateTime := DateTime1;
                if fImportGedCom.GedcomStructureOfHeader._HEAD._DATE._TIME <> nil then
                  begin
                  s := fImportGedCom.GedcomStructureOfHeader._HEAD._DATE._TIME.Value;
                  fHeaderDateTime := fHeaderDateTime + StrToTimeDef(s, 0);
                  end;
                end;
              end;
            end;
        except
          //ShowMessage('Formats de DATE et/ou TIME de l''entête invalides');
        end;

        fMaxNumEtapePossible := 1000;
        Result := True;
        end
      else
        MyMessageDlg(rs_Error_Cannot_read_this_file, mtWarning, [mbOK]);
      DoRefreshHeader;
      SuperFormRefreshControls(Self);
      end;
  finally
    Content.Free;
  end;
  //on regarde si on a trouvé les villes
  ok := False;
  for n := 1 to 7 do
    if fColumnsLieuxOrder[n] <> _COL_LIEU_IGNORER then
      ok := True;
  if Ok = False then
    begin
    //on met un codage
    fColumnsLieuxOrder[1] := 1;
    fColumnsLieuxOrder[2] := 2;
    fColumnsLieuxOrder[3] := 3;
    fColumnsLieuxOrder[4] := 4;
    fColumnsLieuxOrder[5] := 5;
    fColumnsLieuxOrder[6] := 6;
    fColumnsLieuxOrder[7] := 0;
    end;
  RefreshButtonsLieux;
  RefreshExempleLieux;
end;

procedure TFImportGedcom.GoToPage(const aNumPage: integer);
begin
  fFill.Value := True;
    try
    Notebook.PageIndex := aNumPage;
    //    WizardTree.ItemIndex:=aNumPage;
    finally
    fFill.Value := False;
    end;
  case aNumPage of
    1: //entête
      begin
      if fIsHeaderLoaded = False then
        DoLoadHeader;
      DoRefreshHeader;
      end;
    2: //exemples de noms
      begin
      if fExemplesDeNomsCharges = False then
        DoLoadQuelquesExemplesDeNoms;
      end;
    3: //Eléments à importer
      begin
      if gci_context.ImagesDansBase then
        lImportMedias.Caption :=
          rs_Caption_Import_Medias_some_copy_of_pictures_will_be_set_in_database
      else
        lImportMedias.Caption :=
          rs_Caption_Import_Medias_only_address_and_icon_will_be_set_in_database;
      end;
    4: //configuration de PLAC
      begin
      if fIsQuelquesAdressesLoaded = False then
        DoLoadQuelquesAdresses;
      end;
    end;
  SuperFormRefreshControls(Self);
end;

procedure TFImportGedcom.WizardTreeChange(Sender: TObject);
begin
  //  WizardTree.Refresh;
end;

procedure TFImportGedcom.CreateEventsFamille(const AFam: TTag_FAM_RECORD);
// Import des evenements familles -------------------------------------
  procedure SaveEvent( aEvent: TTag_Event_Detail);
  var
    s: string;
    i: integer;
    aVille, aCP, aDept, aRegion, aPays, aSubd: string;
    //aLieuDit:string;
    aSour: TTag_SOURCE_CITATION;
    TagMedia: TTag_MEDIA;
  begin
    //CleFamille := dm.uf_GetClefUnique('EVENEMENTS_FAM');
    with aEvent, CutEventFam do
     while aEvent <> nil do
      begin
      //Cle := dm.uf_GetClefUnique('EVENEMENTS_FAM');
      if CleFamille <> -1 then
        begin
        Cle := CleFamille;
        //EV_FAM_CLEF
        Params[0].AsInteger := CleFamille;
        //EV_KLE_KLE_FICHE
        Params[1].AsInteger := AFam.cle;
        //EV_FAM_KLE_DOSSIER
        Params[2].AsInteger := fNumDossierImport;
        //EV_FAM_TYPE
        s := fs_copy(Caption, 1, 7);
        Params[3].AsString := s;

        for i := 4 to Params.Count - 1 do
          Params[i].Clear;

        if _DESC <> nil then //ancien tag
          Params[18].AsString := fs_copy(_DESC.Value, 1, 90);
        if _TYPE <> nil then
          //dans les ev_fam la description est toujours dans TYPE
          begin
          if s = 'EVEN' then
            begin
            s := _TYPE.Value;
            i := pos(#194#160, s);
            if i > 0 then
              begin //TITRE_EVENT et DESCRIPTION
              Params[29].AsString := fs_copy(copy(s, 1, i - 1), 1, 25);
              Params[18].AsString := fs_copy(copy(s, i + 2,length(s)),1, 90);
              end
            else
              Params[18].AsString := fs_copy(s, 1, 90);
            end
          else
            Params[18].AsString := fs_copy(_TYPE.Value, 1, 90);
          end;

        if _DATE <> nil then
          //Params[4].AsString:=trim(copy(_DATE.Value,1,100));//AL le 20/01/08 décodage par la base
         with _GDate do
          begin
            DecodeGedcomDate(_Date.Value);
            Params[4].AsString := fs_copy(fs_GetConvertedDate(HumanDate), 1, 100);
         {   if UseDate1 then
              begin
              if ValidDateTime1 then
                Params[23].AsString :=
                  FormatDateTime(ShortDateFormat, DateTime1);
              Params[22].AsInteger := Year1;
              if (Month1 > 0) then
                Params[24].AsInteger := Month1;
              Params[27].AsInteger := DateCodeTard;
              Params[30].AsInteger := DateCode1;
              Params[31].AsInteger := DateCodeTot;
              if Day1 > 0 then
                Params[32].AsInteger := Day1;
              if Type_Key1 > 0 then
                Params[34].AsInteger := Type_Key1;
              end;
            if UseDate2 then
              begin
              Params[26].AsInteger := Year2;
              if (Month2 > 0) then
                Params[25].AsInteger := Month2;
              if Day2 > 0 then
                Params[33].AsInteger := Day2;
              if Type_Key2 > 0 then
                Params[35].AsInteger := Type_Key2;
              end;}
          end;

        //récupération anciens gedcom Ancestromania
        //Latitude N quand positif, S si négatif
        //Longitude E quand positive et W quand négative
        if _LATI <> nil then
          if Copy(_LATI.Value, 1, 1) = 'S' then
            Params[19].AsString := '-' + copy(_LATI.Value, 2, 20)
          else
            Params[19].AsString := copy(_LATI.Value, 2, 20);
        if _LONG <> nil then
          if Copy(_LONG.Value, 1, 1) = 'W' then
            Params[20].AsString := '-' + copy(_LONG.Value, 2, 20)
          else
            Params[20].AsString := copy(_LONG.Value, 2, 20);

        if __ANCES_XINSEE <> nil then
          Params[15].AsString :=
            trim(copy(__ANCES_XINSEE.Value, 1, 6));

        //EV_FAM_SUBD, CP, VILLE, DEPT, PAYS
        if _PLAC <> nil then
          begin
          DecodeAdresse(_PLAC.Value, aVille, aCP, aDept, aRegion, aPays, aSubd);
          if bCPenPLAC then
            Params[6].AsString := trim(copy(aCP, 1, 10))
          else
            Params[15].AsString := trim(copy(aCP, 1, 6));
          Params[7].AsString := trim(fs_copy(aVille, 1, 50));//était 30
          Params[8].AsString := trim(fs_copy(aDept, 1, 30));
          Params[9].AsString := trim(fs_copy(aPays, 1, 30));
          Params[12].AsString := trim(fs_copy(aRegion, 1, 50));
          Params[13].AsString := trim(fs_copy(aSubd, 1, 50));
          if _PLAC._NOTE <> nil then
            begin
            s := _PLAC._NOTE.Value;//donne la première ligne
            if pos('Code INSEE ', s) > 0 then
              Params[15].AsString :=
                trim(copy(s, pos('Code INSEE ', s) + 11, 6))
            else if pos('Code postal ', s) > 0 then
              Params[6].AsString :=
                trim(copy(s, pos('Code postal ', s) + 12, 10))
            else if pos('Latitude ', s) > 0 then
              begin
              if trim(copy(s, pos('Latitude ', s) + 9, 1)) = 'S' then
                Params[19].AsString :=
                  '-' + trim(copy(s, pos('Latitude ', s) + 10, 20))
              else
                Params[19].AsString :=
                  trim(copy(s, pos('Latitude ', s) + 10, 20));
              end
            else if pos('Longitude ', s) > 0 then
              begin
              if trim(copy(s, pos('Longitude ', s) + 10, 1)) = 'W' then
                Params[20].AsString :=
                  '-' + trim(copy(s, pos('Longitude ', s) + 11, 20))
              else
                Params[20].AsString :=
                  trim(copy(s, pos('Longitude ', s) + 11, 20));
              end;

            for i := 0 to Min(_PLAC._NOTE.Memo.Count - 1, 3) do
              begin
              s := trim(_PLAC._NOTE.Memo[i]);
              if pos('Code INSEE ', s) > 0 then
                Params[15].AsString :=
                  trim(copy(s, pos('Code INSEE ', s) + 11, 6))
              else if pos('Code postal ', s) > 0 then
                Params[6].AsString :=
                  trim(copy(s, pos('Code postal ', s) + 12, 10))
              else if pos('Latitude ', s) > 0 then
                begin
                if trim(copy(s, pos('Latitude ', s) + 9, 1)) = 'S' then
                  Params[19].AsString :=
                    '-' + trim(copy(s, pos('Latitude ', s) + 10, 20))
                else
                  Params[19].AsString :=
                    trim(copy(s, pos('Latitude ', s) + 10, 20));
                end
              else if pos('Longitude ', s) > 0 then
                begin
                if trim(copy(s, pos('Longitude ', s) + 10, 1)) = 'W' then
                  Params[20].AsString :=
                    '-' + trim(copy(s, pos('Longitude ', s) + 11, 20))
                else
                  Params[20].AsString :=
                    trim(copy(s, pos('Longitude ', s) + 11, 20));
                end;
              end;
            end;
          if _PLAC._MAP <> nil then
            //récupération des coordonnées si Tag MAP existe (GEDCOM 5.5.1) AL2011
            begin
            if _PLAC._MAP._LATI <> nil then
              if Copy(_PLAC._MAP._LATI.Value, 1, 1) = 'S' then
                Params[19].AsString :=
                  '-' + copy(_PLAC._MAP._LATI.Value, 2, 20)
              else
                Params[19].AsString :=
                  copy(_PLAC._MAP._LATI.Value, 2, 20);
            if _PLAC._MAP._LONG <> nil then
              if Copy(_PLAC._MAP._LONG.Value, 1, 1) = 'W' then
                Params[20].AsString :=
                  '-' + copy(_PLAC._MAP._LONG.Value, 2, 20)
              else
                Params[20].AsString :=
                  copy(_PLAC._MAP._LONG.Value, 2, 20);
            end;
          end;

        if _CAUS <> nil then
          Params[21].AsString := fs_copy(_CAUS.Value, 1, 90);
        if __ANCES_XACTE <> nil then //ancien tag
          begin
          s := Copy(__ANCES_XACTE.Value, 1, 1);
          if StrToInt(s) = 1 then
            Params[14].AsInteger := 1;
          end;
        if __ACTE <> nil then //AL
          begin
          s := Copy(__ACTE.Value, 1, 2);
          if StrToInt(s) > -10 then
            Params[14].AsInteger := StrToInt(s);
          end;
        if __ORDR <> nil then //AL2011
          Params[28].AsInteger := StrToInt(__ORDR.Value);
        if cbImportImages.Checked then
          begin
          //          if _OBJE<>nil then
          //          begin
          //            CreateMediaBase(_OBJE,AFam.CLEF_HUSB,CleFamille,'F','A');
          //            Params[14].AsInteger:=1;
          //          end;
          TagMedia := _OBJE;//AL2010 pour médias multiples
          while TagMedia <> nil do
            begin
            CreateMediaBase(TagMedia, AFam.CLEF_HUSB, CleFamille, 'F', 'A');
            TagMedia := TTag_MEDIA(TagMedia.PtrNextSameTag);
            end;
          end;

        if _TIME <> nil then
            try
            Params[16].AsString := trim(copy(_TIME.Value, 1, 5));
            except
            end;
        // Le N° de l import Gedcom
        Params[17].AsInteger := NumImportation;
        //Source
        if (cbImportSources.Checked) and (_SOUR <> nil) then
          begin
          if _SOUR.ID = '' then
            begin
        {    aSOUR := _SOUR;
            //AL permet de lire un fichier avec sources non pointées
            while (aSOUR <> nil) do
              begin
              s := aSOUR.AsLine;
              Params[10].AsString := s;
              aSOUR := TTag_SOURCE_CITATION(aSOUR.PtrNextSameTag);
              end;//Al fin}
            end
          else
            begin
            s_ABBR := '';
            s_TEXT := '';
            s_TITL := '';
            s_REPO := '';
            s_AUTH := '';
            s_PUBL := '';
            //erreur/GEDCOM confusion des niveaux SOURCE_CITATION et SOURCE_RECORD
            //on devrait d'abord importer SOURCE_CITATION avant SOURCE_RECORD s'ils étaient correctement définis.
            s := _SOUR.AsLine;//initialise les variables pour source pointée
            CreateSourceEvent(aEvent, 'F', AFam.CLEF_HUSB);
            end;
          end;
        //Commentaires
        if cbImportNotes.Checked then
          begin
          if _NOTE <> nil then
            begin
            s := _NOTE.AsLine;
            Params[11].AsString := s;
            end;
          end;
        ParamsToStr;
        FileWrite0(FileEventFam, Line);
        // Flush(FileEventFam);
        if cbImportTemoins.Checked then
          begin
          SaveAssosOfEventFamille(aEvent, AFam);
          end;

        end;
      //on cherche le suivant dans la boucle...
      aEvent:=TTag_Event_Detail(PtrNextSameTag);
      Inc(CleFamille);
      end;
  end;

begin
  if AFam.Cle <> -1 then
    begin
      SaveEvent(AFam._ANUL);
      SaveEvent(AFam._CENS);
      SaveEvent(AFam._DIV);
      SaveEvent(AFam._DIVF);
      SaveEvent(AFam._ENGA);
      SaveEvent(AFam._MARR);
      SaveEvent(AFam._MARB);
      SaveEvent(AFam._MARC);
      SaveEvent(AFam._MARL);
      SaveEvent(AFam._MARS);
      SaveEvent(AFam._EVEN);
    end;
end;

procedure TFImportGedcom.SaveAssosOfEventFamille(const aEvent: TTag_Event_Detail;
  const aFam: TTag_FAM_RECORD);
var
  s: string;
  CleAsso, p: integer;
  aAsso: TTag_ASSOCIATION_STRUCTURE;
  indi_asso: TIndi;
begin
  //on sauvegarde les associations en relation avec cet événement
  aAsso := aEvent._ASSO;
  while aAsso <> nil do
    begin
    indi_asso := fImportGedCom.GetIndividuByID(aAsso.ID);
    if indi_asso <> nil then
     with CutAsso,aAsso do
      begin
      //récupération d'une clé pour le nouveau record
      CleAsso := dm.uf_GetClefUnique('T_ASSOCIATIONS');
      if CleAsso <> -1 then
        begin
        //ASSOC_CLEF
        Params[0].AsInteger := CleAsso;
        //ASSOC_KLE_IND
        Params[1].AsInteger := aEvent.Cle;//aFam.Cle;
        //ASSOC_KLE_ASSOCIE
        Params[2].AsInteger := indi_asso.Cle;
        //ASSOC_KLE_DOSSIER
        Params[3].AsInteger := fNumDossierImport;
        //ASSOC_NOTES
        Params[4].AsString := '';
        if cbImportNotes.Checked then
          begin
          if _NOTE <> nil then
            begin
            s := _NOTE.AsLine;
            Params[4].AsString := s;
            end;
          end;
        //ASSOC_SOURCES
        Params[5].AsString := '';
        if cbImportNotes.Checked then
          begin
          if _SOUR <> nil then
            begin
            s := _SOUR.Value;
            for p := 0 to _SOUR.Memo.Count - 1 do
              s := s + #13#10 + _SOUR.Memo[p];
            Params[5].AsString := s;
            end;
          end;
        //ASSOC_LIBELLE AL 2009
        Params[6].AsString := 'Other';
        if _RELA <> nil then
          begin
          Params[6].AsString := _RELA.Value;
          end;
        //ASSOC_EVENEMENT
        Params[7].AsInteger := aEvent.Cle;//la cle de l'event
        //ASSOC_TABLE
        Params[8].AsString := 'U';
        ParamsToStr;
        FileWrite0(FileAsso, Line);
        // Flush(FileAsso);
        end;
      end;
    //le suivant
    aAsso := TTag_ASSOCIATION_STRUCTURE(aAsso.PtrNextSameTag);
    end;
end;

procedure TFImportGedcom.LoadEventPossibles(const aList: TStringlistUTF8);
var
  q: TIBSQL;
begin
  aList.Clear;
  q := TIBSQL.Create(self);
    try
    q.Database := dm.ibd_BASE;
    q.SQL.Text := 'select REF_EVE_LIB_COURT from REF_EVENEMENTS where REF_EVE_A_TRAITER=1'
      + ' and ref_eve_langue=:langue';
    q.Params[0].AsString := gci_context.Langue;
    q.ExecQuery;
    while not q.EOF do
      begin
      aList.Add(q.Fields[0].AsString);
      q.Next;
      end;
    finally
    q.Close;
    q.Free;
    end;
end;

function TFImportGedcom.doImportation:Boolean;
var
  suite, bVideDossier, bErreurs: boolean;
  StartTime, Duree: TDateTime;
  heures, minutes, secondes, MSecondes: word;
  q: TIBSQL;
begin
  Result:=False;
  dm.doActiveTriggerMajDate(False);
  FMain.Enabled := False;
    try
    bVideDossier := False;
    btnNext.Enabled := False;
    Application.ProcessMessages;
    if rbClearBdd.Checked then
      begin
      suite := False;
      if MyMessageDlg(rs_Confirm_folder_replace, mtWarning, [mbYes, mbNo]) =
        mrYes then
        begin
        suite := True;
        bVideDossier := True;
        end;
      end
    else
      suite := True;
    if suite then
      begin
      if MyMessageDlg(rs_Importing_a_big_file_can_be_long + _CRLF +
        _CRLF + rs_Do_you_continue, mtConfirmation, [mbYes, mbNo]) <> mrYes then
        begin
        btnNext.Enabled := True;
        exit;
        end;
      bCPenPLAC := (rbFormatGedcom.ItemIndex = 0);
      doShowWorking(rs_Wait_Preparing_import + _CRLF + rs_Please_Wait);
      btnNext.Caption := rs_Wait;
      btnNext.Refresh;
      btnPrevious.Visible := False;
      Application.ProcessMessages;
      screen.cursor := crHourGlass;
      //      Animate.CommonAVI:=aviCopyFiles;
      Animate.Visible := True;
      Animate.AnimStatic := False;
      try
        //heure de début
        StartTime := Now;

        if bVideDossier then
          begin
          btnNext.Caption := rs_Wait;
          btnNext.Refresh;
          Application.ProcessMessages;
            try
              try
              dm.DoClearDossier(dm.NumDossier);
              dm.IBT_base.CommitRetaining;
              dm.IBTrans_Secondaire.CommitRetaining;
              finally
              end;
            except
            end;
          end;

        CleFamille := dm.uf_GetClefUnique('EVENEMENTS_FAM');//initialisation des clefs
        CleEvInd := dm.uf_GetClefUnique('EVENEMENTS_IND');
        NumImportation := dm.uf_GetClefUnique('T_IMPORT_GEDCOM');
        q := TIBSQL.Create(self);
          try
          q.DataBase := dm.ibd_BASE;
          q.Transaction := dm.ibt_Base;
          q.SQL.Clear;
          q.SQL.Add('INSERT INTO T_IMPORT_GEDCOM VALUES (:ID,:PATH,:DATE)');
          q.Params[0].AsInteger := NumImportation;
          q.Params[1].AsString :=
            edPathFileNameGED.Text + ' - Dossier : ' + IntToStr(fNumDossierImport);
          q.Params[2].AsDateTime := Now;
          q.ExecQuery;
          finally
          q.Free;
          end;
        IBMultimedia.Close;
        //préparation pour la recherche média existant déjà dans le dossier
        IBMultimedia.SQL.Text :=
          'select first(1)* from multimedia' //au lieu de l'import en cours uniquement
          + ' where MULTI_DOSSIER=' + IntToStr(fNumDossierImport) +
          ' and upper(multi_path)=upper(:multi_path)'
          //il faudra prévoir un index sur upper(multi_path)
          + ' and ( (0=char_length(cast(:memo as varchar(250))))' +
          ' or(char_length(multi_memo)=0)' +
          ' or(left(multi_memo,250)=cast(:memo as varchar(250))) )';

        //décodage du gedcom et chargement de la base de données
        DoFillBddWithGedcomFile;

        finally
        Animate.AnimStatic := True;
        Animate.Visible := False;
        screen.cursor := crDefault;
        end;
      // on met à jour les pointeurs, les événements familiaux importés avec TYPU
      // et des tags spécifiques
      q := TIBSQL.Create(self);
        try
        q.DataBase := dm.ibd_BASE;
        q.Transaction := dm.ibt_Base;
        q.SQL.Clear;
        q.SQL.Add('set GENERATOR GEN_EV_FAM_CLEF TO ' + IntToStr(CleFamille));
        q.ExecQuery;
        q.Close;
        q.SQL.Clear;
        q.SQL.Add('set GENERATOR GEN_EV_IND_CLEF TO ' + IntToStr(CleEvInd));
        q.ExecQuery;
        q.Close;
        q.SQL.Clear;
        q.SQL.Add('execute procedure PROC_MAJ_TAGS');
        q.ExecQuery;
        q.Close;
        if (cbImportTemoins.Checked) then
          begin
          q.SQL.Clear;
          q.SQL.Add('update t_associations t set t.assoc_libelle=');
          q.SQL.Add('(select first(1) r.ref_rela_libelle from ref_rela_temoins r');
          q.SQL.Add(
            'where r.langue=(select ds_langue from dossier where cle_dossier=t.assoc_kle_dossier)');
          q.SQL.Add('and upper(r.ref_rela_tag)=upper(t.assoc_libelle))');
          q.SQL.Add('where t.assoc_kle_dossier=' + IntToStr(fNumDossierImport));
          q.SQL.Add('and exists (select * from ref_rela_temoins r');
          q.SQL.Add(
            'where r.langue=(select ds_langue from dossier where cle_dossier=t.assoc_kle_dossier)');
          q.SQL.Add('and upper(r.ref_rela_tag)=upper(t.assoc_libelle))');
          q.ExecQuery;
          //compatibilité avec des logiciels (hérédis) qui utilisent des simili-tags anglais
          q.Close;
          end;
        q.SQL.Text := 'select * from traces';
        q.ExecQuery;
        if q.EOF then
          bErreurs := False
        else
          bErreurs := True;
        q.Close;
        finally
        q.Free;
        end;
      //on indique que tout s'est passé
      dm.doMAJTableJournal(fs_RemplaceMsg(rs_Log_GEDCOM_Import_from_file_with_folder,
        [OpenDialog.FileName]) + IntToStr(fNumDossierImport));
      //on rafraichit les favoris
      FMain.RefreshFavoris;
      FMain.SuperFormRefreshControls(Self);
      DefaultCloseAction := caFree;
      Application.ProcessMessages;
      doCloseWorking;
      Duree := Now - StartTime;
      DecodeTime(duree, heures, minutes, secondes, MSecondes);
      MyMessageDlg(fs_RemplaceMsg(rs_Info_Import_is_a_success_in_hour_minutes_seconds
                           ,
        [IntToStr(heures), IntToStr(minutes), IntToStr(secondes)])
        +_CRLF+rs_Info_It_is_necessary_to_optimise_your_database, mtInformation,
        [mbOK]);
      if bErreurs then
        ListeErreurs;
      DoSendMessage(Owner, 'OPEN_MODULE_INDIVIDU');
      Close;
      end
    else
        SuperFormRefreshControls(Self);
    finally
      dm.doActiveTriggerMajDate(True);
      FMain.Enabled := True;
    end;
  Result:=True;
end;

procedure TFImportGedcom.DoLoadQuelquesExemplesDeNoms;
begin
  fExemplesDeNomsCharges := False;
  if fImportGedCom.LoadFromFileQuelquesExemplesDeNoms(
    edPathFileNameGED.Text, fExempleJeuxCaractere,FJeuCaractere) then
    begin
    fExemplesDeNomsCharges := True;
    RefreshExempleJeuCaracteres;
    //On peut passer à toutes les étapes suivante
    fMaxNumEtapePossible := 1000;
    end;
end;

procedure TFImportGedcom.DoLoadQuelquesAdresses;
begin
  fIsQuelquesAdressesLoaded := False;
  if fImportGedCom.LoadFromFileQuelquesAdresses(
    edPathFileNameGED.Text, fExempleLieux,FJeuCaractere) then
    begin
    fIsQuelquesAdressesLoaded := True;
    RefreshExempleLieux;
    fMaxNumEtapePossible := 1000;
    end;
end;

procedure TFImportGedcom.doOnProgressEvent(Sender: TObject; Pourcent: integer);
begin
  lbNdFam.Caption := IntToStr(fImportGedCom.ListFam.Count);
  lbNbIndi.Caption := IntToStr(fImportGedCom.ListIndi.Count);
  Application.ProcessMessages;
end;

procedure TFImportGedcom.doRefreshHeader;
begin
  lbChemin.Caption := edPathFileNameGED.Text;
  lbHeaderSource.Caption := fHeaderSource;
  lbHeaderNom.Caption := fHeaderNom;
  lbHeaderDestination.Caption := fHeaderDestination;
  lbHeaderCodage.Caption := fHeaderCodage;
  lbHeaderLangue.Caption := fHeaderLangue;
  lbHeaderVersion.Caption := fHeaderVersion;
  lbHeaderCompagnie.Caption := fHeaderCompagnie;
  lbHeaderAdresse.Caption := fHeaderAdresse;
  btInfosAuteur.Visible := length(fHeaderNote) > 0;
end;

procedure TFImportGedcom.DoFillBddWithGedcomFile;
var
  indi, indi_husb, indi_wife: TIndi;
  fam: TFam;
  TagFam: TTag_FAM_RECORD;
  TagIndi: TTag_INDIVIDUAL_RECORD;
  TotRec: integer;
  NumRec: integer;
  s, TmpLine: string;
  Block: TStringlistUTF8;
  aGedcomBlock: TGedComStructure;
  TagMedia: TTag_MEDIA;
  OK: boolean;

  function BlockSuivant(const Tags: array of string): string;
  var
    s, tag: string;

    function OkTag(const s: string; var tag: string): boolean;
    var
      i, niveau: integer;
      infos, id: string;
    begin
      Result := False;
      if copy(s, 1, 2) = '0 ' then
        begin
        if fImportGedCom.DecodeLigne(s, niveau, tag, id, infos) then
          for i := 0 to High(Tags) do
            begin
            if tag = Tags[i] then
              begin
              Result := True;
              break;
              end;
            end;
        end;
    end;

  begin
    Result := '';
    Block.Clear;
    if (TmpLine > '') and OkTag(TmpLine, tag) then
      begin
      S := TmpLine;
      TmpLine := '';
      OK := True;
      end
    else
      begin
      repeat
        OK := OkTag(S, tag);
      until OK or (FileReadlnOriginal(f, s,FJeuCaractere) = 0);
      end;
    if OK then
      begin
      Result := tag;
      Block.Add(S);
      while FileReadlnOriginal(f, s,FJeuCaractere) > 0 do
        begin
        if copy(S, 1, 2) = '0 ' then
          begin
          TmpLine := S;
          Break;
          end
        else
          Block.Add(S);
        end;
      end;
  end;

  procedure p_BatchFile(const as_FileName: string);
  var
    DelimInput: TIBInputDelimitedFile;
  begin
    if not FileExistsUTF8(as_FileName) then
      Exit;
    DelimInput := TIBInputDelimitedFile.Create;
    try
      DelimInput.Filename := as_FileName;
      DelimInput.ColDelimiter := CST_SEPARATE_WORDS;
      DelimInput.RowDelimiter := CST_SEPARATE_LINES;
      DelimInput.ReadBlanksAsNull := True;
      DelimInput.SkipTitles := True;
      IBSQL.BatchInput(DelimInput);
    finally
      DelimInput.Destroy;
    end;

  end;
  procedure p_AddBlock ( const StringBlock : String );
  var AListBlock : TIdentifiedList;
      li_Block: integer;
  Begin
   if StringBlock > '' then
    begin
      if StringBlock = 'SOUR'
       then AListBlock := fImportGedCom.ListSour
       else if StringBlock = 'NOTE'
        then AListBlock := fImportGedCom.ListNote
       else if StringBlock = 'REPO'
        then AListBlock := fImportGedCom.ListRepo
       else
         Exit;

      //on cherche l'objet dans les sources
      for li_Block := 0 to AListBlock.Count - 1 do
        with TBlock(AListBlock[li_Block]) do
        if FirstLine = Block[0] then
          begin
            //On décode ce block
            GedcomBlock.InitStructure ( fImportGedCom );
            //on décode
            fImportGedCom.DecodageGedcom(GedcomBlock,
              Block, FJeuCaractere);
            Break;
          end;
    end;
  End;
begin
  doShowWorking(rs_Wait_Analysing_GEDCOM_file + _CRLF + rs_Please_Wait);
  application.ProcessMessages;
  NumRec := 0;
  fFirstPerson:=True;
  NameFileIndi := _TempPath + 'tmpindi.txt';
  NameFileEventIndi := _TempPath + 'tmpeventindi.txt';
  NameFileMediaPointeurs := _TempPath + 'tmpmediaPointeurs.txt';
  NameFileSource := _TempPath + 'tmpsourevent.txt';
  NameFileUnion := _TempPath + 'tmpunion.txt';
  NameFileEventFam := _TempPath + 'tmpeventfam.txt';
  NameFileAsso := _TempPath + 'tmpasso.txt';
  //on récupère les événements possibles
  LoadEventPossibles(fImportGedCom.EventsPossible);
  fImportGedCom.PathFileName := edPathFileNameGED.Text;
  fImportGedCom.PrepareIndividusAndFamilles(FJeuCaractere);
  Block := TStringlistUTF8.Create;
  //on connait le nombre d'individus et de familles
  TotRec := fImportGedCom.ListIndi.Count + fImportGedCom.ListFam.Count;//MD enlevé +12
  FileIndi := FileCreateDeleteFile0(NameFileIndi);
  FileEventIndi := FileCreateDeleteFile0(NameFileEventIndi);
  FileMediaPointeurs := FileCreateDeleteFile0(NameFileMediaPointeurs);
  FileSource := FileCreateDeleteFile0(NameFileSource);
  FileEventFam := FileCreateDeleteFile0(NameFileEventFam);
  FileUnion := FileCreateDeleteFile0(NameFileUnion);
  FileAsso := FileCreateDeleteFile0(NameFileAsso);
  try
    F := FileOpenUTF8(edPathFileNameGED.Text, fmOpenRead);
      try
      //ici, on lit et décode tous les blocs notes, source et repo
      TmpLine := '';
      repeat
        p_AddBlock ( BlockSuivant(['SOUR', 'NOTE', 'REPO']) );
      until Block.Count = 0;
      //on lit les familles une par une
      FileSeek(F, 0, 0);
      repeat
        if BlockSuivant(['FAM']) > '' then
          begin
           aGedcomBlock := TGedcomStructure.Create;
            try
            aGedcomBlock.InitStructure ( fImportGedCom );
            //on décode
            if fImportGedCom.DecodageGedcom(aGedcomBlock, Block, FJeuCaractere) then
              begin
              if aGedcomBlock._FAM <> nil then
                begin
                TagFam := TTag_FAM_RECORD(aGedcomBlock._FAM);

                Fam := fImportGedCom.GetFamilleByID(TagFam.ID);
                TagFam.CLE := Fam.CLE;

                if TagFam._HUSB <> nil then
                  begin //on recherche l'individu qui porte cet ID
                  indi_husb := fImportGedCom.GetIndividuByID(TagFam._HUSB.ID);
                  if indi_husb <> nil then
                    begin
                    fam.CLEF_HUSB := indi_husb.Cle;
                    TagFam.CLEF_HUSB := indi_husb.Cle;
                    end;
                  end;

                if TagFam._WIFE <> nil then
                  begin //on recherche l'individu qui porte cet ID
                  indi_wife := fImportGedCom.GetIndividuByID(TagFam._WIFE.ID);
                  if indi_wife <> nil then
                    begin
                    fam.CLEF_WIFE := indi_wife.Cle;
                    TagFam.CLEF_WIFE := indi_wife.Cle;
                    end;
                  end;
                //Création de l'enregistrement pour cette famille
                if CreateFamille(TagFam) then
                  CreateEventsFamille(TagFam);
                Inc(NumRec);
                Pourcent.Caption := IntToStr((NumRec * 100) div (TotRec)) + ' %';
                Application.ProcessMessages;
                end;
              end;
            finally
              aGedcomBlock.Destroy;
            end;
          end;
      until Block.Count = 0;
      //on lit les individus
      TmpLine := '';
      FileSeek(F, 0, 0);
      repeat
        if BlockSuivant(['INDI']) > '' then
          begin
          aGedcomBlock := TGedcomStructure.Create;
            try
            aGedcomBlock.InitStructure ( fImportGedCom );
            //on décode
            if fImportGedCom.DecodageGedcom(aGedcomBlock, Block, FJeuCaractere) then
              begin
              if aGedcomBlock._INDI <> nil then
                begin
                TagIndi := aGedcomBlock._INDI;
                Indi := fImportGedCom.GetIndividuByID(TagIndi.ID);
                TagIndi.Cle := Indi.Cle;
                if TagIndi._FAMC <> nil then
                  begin //on recherche la clé de cette famille dont l'individu est un enfant
                  fam := fImportGedCom.GetFamilleByID(TagIndi._FAMC.ID);
                  if fam <> nil then
                    begin
                    TagIndi.CLE_PERE := fam.CLEF_HUSB;
                    TagIndi.CLE_MERE := fam.CLEF_WIFE;
                    end;
                  end;
                CreateIndividu(TagIndi);
                CreateEventsIndividu(TagIndi);
                CreateDomicilesIndividu(TagIndi);
                if cbImportImages.Checked then
                  begin
                  TagMedia := TagIndi._OBJE;
                  while (TagMedia <> nil) and (TagIndi.Cle <> -1) do
                    begin
                    CreateMediaBase(TagMedia, TagIndi.Cle, TagIndi.Cle, 'I', 'I');
                    //on cherche le suivant...
                    TagMedia := TTag_MEDIA(TagMedia.PtrNextSameTag);
                    end;
                  end;
                if cbImportTemoins.Checked then
                  CreateAssociationsEventsIndividu(TagIndi);
                Inc(NumRec);
                Pourcent.Caption := IntToStr((NumRec * 100) div (TotRec)) + ' %';
                Application.ProcessMessages;
                end;
              end;
            finally
              aGedcomBlock.Destroy;
            end;
          end;
      until Block.Count = 0;
      finally
      FileClose(F);
      end;
    finally
    FreeAndNil(FileIndi);
    FreeAndNil(FileEventIndi);
    FreeAndNil(FileMediaPointeurs);
    FreeAndNil(FileSource);
    FreeAndNil(FileEventFam);
    FreeAndNil(FileUnion);
    FreeAndNil(FileAsso);
    end;
  Block.Free;
  NumRec:=1;
  doShowWorking(rs_Wait_Loading_Persons + _CRLF + rs_wait_step_number +
    IntToStr(numrec) + '/10');
  Application.ProcessMessages;
  try
    IBSQL.Database := dm.ibd_BASE;
    IBSQL.Transaction := dm.ibt_BASE;
{    if not ConnexionBase(ibd_BASE,gci_context.PathFileNameBdd,IBT_Base,''
      ,_user_name,_password,_role_name
      ,'T_VERSION_BASE',_utilEstAdmin,Self) then
        Exit;
    ibd_BASE.Open;
    IBT_BASE.Active:=True;
}
    IBSQL.Close;//AL pour assurer le décodage des dates par la base (modifié MD)
    IBSQL.SQL.Text := 'update ref_token_date set token=''DMY'' where type_token=23';
    IBSQL.SQL.Add('and token not in (''DMY'',''MDY'',''YMD'')');
    IBSQL.ExecQuery;
    IBSQL.Close;
    IBSQL.SQL.Text := 'update ref_token_date set token=''LIT'' where type_token=24';
    IBSQL.SQL.Add('and token not in (''LIT'',''NUM'')');
    IBSQL.ExecQuery;
    IBSQL.Close;
     //AL initialise la base pour le traçage des erreurs de dates
    dm.MetVarContextBase('USER_SESSION', 'TRACE_DATE', '1');
    IBSQL.SQL.Text := 'delete from TRACES';
    IBSQL.ExecQuery;
    IBSQL.Close;
    IBSQL.SQL.Text :=
      'INSERT INTO INDIVIDU ( ' + 'CLE_FICHE, ' + 'KLE_DOSSIER, ' +
      'CLE_PERE, ' + 'CLE_MERE, ' + 'PREFIXE, ' + 'NOM, ' + 'PRENOM, ' +
      'SURNOM, ' + 'SUFFIXE, ' + 'SEXE, ' + 'SOURCE, ' + 'COMMENT, ' +
      'FILLIATION, ' + 'DATE_CREATION, ' + 'MODIF_PAR_QUI, ' + 'NCHI, ' +
      'NMR, ' + 'ID_IMPORT_GEDCOM) ' + 'VALUES ( ' + ':CLE_FICHE, ' +
      IntToStr(fNumDossierImport) + ', ' + ':CLE_PERE, ' + ':CLE_MERE, ' +
      ':PREFIXE, ' + ':NOM, ' + ':PRENOM, ' + ':SURNOM, ' + ':SUFFIXE, ' +
      ':SEXE, ' + ':SOURCE, ' + ':COMMENT, ' + ':FILLIATION, ' +
      ':DATE_CREATION, ' + ':MODIF_PAR_QUI, ' + ':NCHI, ' + ':NMR, ' +
      IntToStr(NumImportation) + ')';
    //désactiver T_AI_INDIVIDU qui met à jour la liste des prénoms le temps d'importer les individus
    dm.ReqSansCheck.Close;
    dm.ReqSansCheck.SQL.Text := 'alter trigger T_AI_INDIVIDU inactive';
      try //au cas où l'utilisateur n'a pas des droits suffisants
      dm.ReqSansCheck.ExecQuery;
      except
      end;
      try
      p_BatchFile(NameFileIndi);
      finally
      dm.ReqSansCheck.SQL.Text := 'alter trigger T_AI_INDIVIDU active';
        try
        dm.ReqSansCheck.ExecQuery;
        except
        end;
      dm.doInitPrenoms;
      end;

    Inc(NumRec);
    doShowWorking(rs_Wait_Loading_Families + _CRLF + rs_wait_step_number +
      IntToStr(numrec) + '/10');
    Application.ProcessMessages;
    IBSQL.SQL.Text :=
      'insert into T_UNION (UNION_CLEF,UNION_MARI,UNION_FEMME,KLE_DOSSIER,UNION_TYPE,SOURCE,COMMENT)';
    IBSQL.SQL.Add(
      'values(:UNION_CLEF,:UNION_MARI,:UNION_FEMME,:KLE_DOSSIER,:UNION_TYPE,:SOURCE,:COMMENT)');
    p_BatchFile(NameFileUnion);

    {inc(NumRec);
    doShowWorking('Les médias...'+_CRLF+rs_Wait+' étape '+inttostr(numrec)+'/11');//+'Patientez SVP'
    Application.ProcessMessages;
    if cbImportImages.Checked then
    begin
        //Le medias
      IBSQL.SQL.Text:='INSERT INTO MULTIMEDIA ( '+
        'MULTI_CLEF, '+
        'MULTI_INFOS, '+
        'MULTI_DOSSIER, '+
        'MULTI_INDIVIDU, '+
        'MULTI_PATH, '+
        'MULTI_TYPE, '+
        'MULTI_IDENTITE, '+
        'MULTI_IMAGE_RTF, '+
        'MULTI_NUM_ACTE, '+
        'ID_IMPORT_GEDCOM, '+
        'MULTI_MEMO)'+
        'VALUES ( '+
        ':MULTI_CLEF, '+
        ':MULTI_INFOS, '+
        ':MULTI_DOSSIER, '+
        ':MULTI_INDIVIDU, '+
        ':MULTI_PATH, '+
        ':MULTI_TYPE, '+
        ':MULTI_IDENTITE, '+
        ':MULTI_IMAGE_RTF, '+
        ':MULTI_NUM_ACTE, '+
        ':IMPORT_GEDCOM, '+
        ':MULTI_MEMO)';
      DelimInput:=TIBInputDelimitedFile.Create;
      try
        DelimInput.Filename:=NameFileMediaIndi;
        DelimInput.ColDelimiter:=CST_SEPARATE_WORDS;
        DelimInput.RowDelimiter:=CST_SEPARATE_LINES;
        DelimInput.ReadBlanksAsNull:=true;
        IBSQL.BatchInput(DelimInput);
      finally
        DelimInput.Free;
        IBSQL.Close;
      end;
      inc(NumRec);
      //Pourcent.Caption:=inttostr((NumRec*100)div(TotRec))+' %';
      Application.ProcessMessages;
    end;}

    Inc(NumRec);
    if cbImportEvent.Checked and cbImportSources.Checked then
      begin
      doShowWorking(rs_Wait_Loading_sources + _CRLF + rs_wait_step_number +
        IntToStr(numrec) + '/10');
      Application.ProcessMessages;
      IBSQL.SQL.Text := 'INSERT INTO SOURCES_RECORD(' + 'ID,' +
        'DATA_ID,' + 'ABR,' + 'TEXTE,' + 'TITL,' + 'DATA_EVEN,' +
        'AUTH,' + 'CHANGE_DATE,' + 'PUBL,' + 'TYPE_TABLE,' + 'KLE_DOSSIER)' +
        'VALUES(' + ':ID,' + ':DATA_ID,' + ':ABR,' + ':THandleE,' +
        ':TITL,' + ':REPO,' + ':AUTH,' + ':CHANGE_DATE,' + ':PUBL,' +
        ':TYPE_TABLE,' + ':KLE_DOSSIER)';
      p_BatchFile(NameFileSource);
      end;

    if (cbImportEvent.Checked) then
      dm.InactiveTriggersLieuxFavoris(True);
      try
      Inc(NumRec);
      if (cbImportEvent.Checked) then
        begin
        doShowWorking(rs_Wait_Loading_families_events + _CRLF +
          rs_wait_step_number + IntToStr(numrec) + '/10');
        Application.ProcessMessages;
        IBSQL.SQL.Text := 'INSERT INTO EVENEMENTS_FAM(' + 'EV_FAM_CLEF,' +
          'EV_FAM_KLE_FAMILLE,' + 'EV_FAM_KLE_DOSSIER,' + 'EV_FAM_TYPE,' +
          'EV_FAM_DATE_WRITEN,' + 'EV_FAM_ADRESSE,' + 'EV_FAM_CP,' +
          'EV_FAM_VILLE,' + 'EV_FAM_DEPT,' + 'EV_FAM_PAYS,' + 'EV_FAM_SOURCE,' +
          'EV_FAM_COMMENT,' + 'EV_FAM_REGION,' + 'EV_FAM_SUBD,' +
          'EV_FAM_ACTE,' + 'EV_FAM_INSEE,' + 'EV_FAM_HEURE,' +
          'ID_IMPORT_GEDCOM,' + 'EV_FAM_DESCRIPTION,' + 'EV_FAM_LATITUDE,' +
          'EV_FAM_LONGITUDE,' + 'EV_FAM_CAUSE,' + 'EV_FAM_DATE_YEAR,' +
          'EV_FAM_DATE,' + 'EV_FAM_DATE_MOIS,' + 'EV_FAM_DATE_MOIS_FIN,' +
          'EV_FAM_DATE_YEAR_FIN,' + 'EV_FAM_DATECODE_TARD,' +
          'EV_FAM_ORDRE,' + 'EV_FAM_TITRE_EVENT,' + 'EV_FAM_DATECODE,' +
          'EV_FAM_DATECODE_TOT,' + 'EV_FAM_DATE_JOUR,' +
          'EV_FAM_DATE_JOUR_FIN,' + 'EV_FAM_TYPE_TOKEN1,' +
          'EV_FAM_TYPE_TOKEN2' + ')VALUES(' + ':EV_FAM_CLEF,' +//0
          ':EV_FAM_KLE_FAMILLE,' +//1
          ':EV_FAM_KLE_DOSSIER,' +//2
          ':EV_FAM_TYPE,' +//3
          ':EV_FAM_DATE_WRITEN,' +//4
          ':EV_FAM_ADRESSE,' +//5 EV_FAM_ADRESSE null
          ':EV_FAM_CP,' +//6
          ':EV_FAM_VILLE,' +//7
          ':EV_FAM_DEPT,' +//8
          ':EV_FAM_PAYS,' +//9
          ':EV_FAM_SOURCE,' +//10
          ':EV_FAM_COMMENT,' +//11
          ':EV_FAM_REGION,' +//12
          ':EV_FAM_SUBD,' +//13
          ':EV_FAM_ACTE,' +//14
          ':EV_FAM_INSEE,' +//15
          ':EV_FAM_HEURE,' +//16
          ':IMPORT_GEDCOM,' +//17
          ':EV_FAM_DESCRIPTION,' +//18
          ':EV_FAM_LATITUDE,' +//19
          ':EV_FAM_LONGITUDE,' +//20
          ':EV_FAM_CAUSE,' +//21
          ':EV_FAM_DATE_YEAR,' +//22
          ':EV_FAM_DATE,' +//23
          ':EV_FAM_DATE_MOIS,' +//24
          ':EV_FAM_DATE_MOIS_FIN,' +//25
          ':EV_FAM_DATE_YEAR_FIN,' +//26
          ':EV_FAM_DATECODE_TARD,' +//27
          ':EV_FAM_ORDRE,' +//28
          ':EV_FAM_TITRE_EVENT,' +//29
          ':EV_FAM_DATECODE,' +//30
          ':EV_FAM_DATECODE_TOT,' +//31
          ':EV_FAM_DATE_JOUR,' +//32
          ':EV_FAM_DATE_JOUR_FIN,' +//33
          ':EV_FAM_TYPE_TOKEN1,' +//34
          ':EV_FAM_TYPE_TOKEN2)';//35
        p_BatchFile(NameFileEventFam);

        end;

      Inc(NumRec);
      if cbImportImages.Checked then
        begin
        doShowWorking(rs_Wait_Adding_medias + _CRLF + rs_wait_step_number +
          IntToStr(numrec) + '/10');
        Application.ProcessMessages;
        IBSQL.SQL.Text := 'INSERT INTO MEDIA_POINTEURS( ' + 'MP_CLEF,' +
          'MP_MEDIA,' + 'MP_POINTE_SUR,' + 'MP_TABLE,' + 'MP_IDENTITE,' +
          'MP_KLE_DOSSIER,' + 'MP_CLE_INDIVIDU,' + 'MP_TYPE_IMAGE,' +
          'MP_POSITION)' + 'VALUES(' + ':MP_CLEF,' + ':MP_MEDIA,' +
          ':MP_POINTE_SUR,' + ':MP_TABLE,' + ':MP_IDENTITE,' +
          ':MP_KLE_DOSSIER,' + ':MP_KLE_INDIVIDU,' + ':MP_TYPE_IMAGE,' + ':MP_POSITION)';
        p_BatchFile(NameFileMediaPointeurs);
        end;
      // import ev_ind mis après media_pointeurs, sans celà possibilité de suppression du source_record par EVENEMENTS_IND_AIU
      Inc(NumRec);
      if (cbImportEvent.Checked) then
        begin
        doShowWorking(rs_Wait_Loading_persons_events + _CRLF +
          rs_wait_step_number + IntToStr(numrec) + '/10');
        Application.ProcessMessages;
         IBSQL.SQL.Text:='INSERT INTO EVENEMENTS_IND('+
          'EV_IND_CLEF,'+//0
          'EV_IND_KLE_FICHE,'+//1
          'EV_IND_KLE_DOSSIER,'+//2
          'EV_IND_TYPE,'+//3
          'EV_IND_DATE_WRITEN,'+ //4
          'EV_IND_DATE_YEAR,'+
          'EV_IND_DATE,'+
          'EV_IND_LIGNES_ADRESSE,'+
          'EV_IND_CP,'+
          'EV_IND_VILLE,'+
          'EV_IND_DEPT,'+
          'EV_IND_PAYS,'+
          'EV_IND_CAUSE,'+
          'EV_IND_SOURCE,'+
          'EV_IND_COMMENT,'+
          'EV_IND_DESCRIPTION,'+
          'EV_IND_REGION,'+
          'EV_IND_SUBD,'+
          'EV_IND_ACTE,'+
          'EV_IND_INSEE,'+
          'EV_IND_ORDRE,'+
          'EV_IND_HEURE,'+
          'EV_IND_TITRE_EVENT,'+
          'EV_IND_LATITUDE,'+
          'EV_IND_LONGITUDE,'+
          'EV_IND_DATE_MOIS,'+
          'EV_IND_DATECODE_TARD,'+
          'EV_IND_DATE_YEAR_FIN,'+
          'EV_IND_DATE_MOIS_FIN,'+
          'EV_IND_TEL,'+
          'EV_IND_MAIL,'+
          'EV_IND_WEB,'+
          'EV_IND_DATECODE,'+
          'EV_IND_DATECODE_TOT,'+
          'EV_IND_DATE_JOUR,'+
          'EV_IND_DATE_JOUR_FIN,'+
          'EV_IND_TYPE_TOKEN1,'+
          'EV_IND_TYPE_TOKEN2,'+
          'EV_IND_CALENDRIER1,'+
          'EV_IND_CALENDRIER2'+
          ')VALUES('+
          ':EV_IND_CLEF,'+//0
          ':EV_IND_KLE_FICHE,'+//1
          ':EV_IND_KLE_DOSSIER,'+//2
          ':EV_IND_TYPE,'+//3
          ':EV_IND_DATE_WRITEN,'+//4
          ':EV_IND_DATE_YEAR,'+//5
          ':EV_IND_DATE,'+//6
          ':EV_IND_LIGNES_ADRESSE,'+//7
          ':EV_IND_CP,'+//8
          ':EV_IND_VILLE,'+//9
          ':EV_IND_DEPT,'+//10
          ':EV_IND_PAYS,'+//11
          ':EV_IND_CAUSE,'+//12
          ':EV_IND_SOURCE,'+//13
          ':EV_IND_COMMENT,'+//14
          ':EV_IND_DESCRIPTION,'+//15
          ':EV_IND_REGION,'+//16
          ':EV_IND_SUBD,'+//17
          ':EV_IND_ACTE,'+//18
          ':EV_IND_INSEE,'+//19
          ':EV_IND_ORDRE,'+//20
          ':EV_IND_HEURE,'+//21
          ':EV_IND_TITRE_EVENT,'+//22
          ':EV_IND_LATITUDE,'+//23
          ':EV_IND_LONGITUDE,'+//24
          ':EV_IND_DATE_MOIS,'+//25
          ':EV_IND_DATECODE_TARD,'+//26
          ':EV_IND_YEAR_FIN,'+//27
          ':EV_IND_MOIS_FIN,'+//28
          ':EV_IND_TEL,'+//29
          ':EV_IND_MAIL,'+//30
          ':EV_IND_WEB,'+//31
          ':EV_IND_DATECODE,'+//32
          ':EV_IND_DATECODE_TOT,'+//33
          ':EV_IND_DATE_JOUR,'+//34
          ':EV_IND_DATE_JOUR_FIN,'+//35
          ':EV_IND_TYPE_TOKEN1,'+//36
          ':EV_IND_TYPE_TOKEN2,'+//37
          ':EV_IND_CALENDRIER1,'+//38
          ':EV_IND_CALENDRIER2)';//39
          p_BatchFile(NameFileEventIndi);
        end;
      finally
        if (cbImportEvent.Checked) then
          dm.InactiveTriggersLieuxFavoris(False);
      end;

    Inc(NumRec);
    if (cbImportTemoins.Checked) then
      begin
      doShowWorking(rs_Wait_Importing_witnesses + _CRLF + rs_wait_step_number +
        IntToStr(numrec) + '/10');
      Application.ProcessMessages;
      IBSQL.SQL.Text :=
        'insert into T_ASSOCIATIONS (ASSOC_CLEF,ASSOC_KLE_IND,ASSOC_KLE_ASSOCIE,ASSOC_KLE_DOSSIER,ASSOC_NOTES,ASSOC_SOURCES,ASSOC_LIBELLE,ASSOC_EVENEMENT,ASSOC_TABLE)';
      IBSQL.SQL.Add(
        'values(:ASSOC_CLEF,:ASSOC_KLE_IND,:ASSOC_KLE_ASSOCIE,:ASSOC_KLE_DOSSIER,:ASSOC_NOTES,:ASSOC_SOURCES,:ASSOC_LIBELLE,:ASSOC_EVENEMENT,:ASSOC_TABLE)');
      p_BatchFile(NameFileAsso);
      end;

    Inc(NumRec);
    if cbIgnoreEventIndiVide.Checked then
      begin
      doShowWorking(rs_Wait_Updating_Database + _CRLF + rs_wait_step_number +
        IntToStr(numrec) + '/10');
      Application.ProcessMessages;
        try
        IBSQL.SQL.Text := 'DELETE FROM EVENEMENTS_IND WHERE EV_IND_KLE_DOSSIER=' +
          IntToStr(fNumDossierImport) + ' AND (EV_IND_DATE_WRITEN IS NULL' +
          ' and EV_IND_ADRESSE IS NULL' + ' and EV_IND_CP IS NULL' +
          ' and EV_IND_VILLE IS NULL' + ' and EV_IND_PAYS IS NULL' +
          ' and EV_IND_CAUSE IS NULL' + ' and EV_IND_SOURCE IS NULL' +
          ' and EV_IND_COMMENT IS NULL' + ' and EV_IND_DESCRIPTION IS NULL' +
          ' and EV_IND_REGION IS NULL' + ' and EV_IND_SUBD IS NULL)';
        IBSQL.ExecQuery;
        finally
        IBSQL.Close;
        end;
      end;

    Inc(NumRec);
    if cbImportImages.Checked then
      begin
      doShowWorking(rs_Wait_Loading_medias + _CRLF + rs_Wait_step_number +
        IntToStr(numrec) + '/10');
      Application.ProcessMessages;
      RechercheImage;
      end;
    //AL fin du traçage des erreurs
    dm.MetVarContextBase('USER_SESSION', 'TRACE_DATE', 'null');
    Inc(NumRec);
    doShowWorking(rs_Wait_Validating_data + _CRLF + rs_Wait_step_number +
      IntToStr(numrec) + '/10');
    Application.ProcessMessages;
    dm.IBT_BASE.CommitRetaining;
  finally
    if (cbImportEvent.Checked) then
      begin
      dm.doInitLieuxFavoris;
      //mis après commit pour pouvoir l'exécuter dans la transaction secondaire
      end;
    //Suppression des fichiers temporaires
      try
      DeleteFileUTF8(NameFileIndi);
      except
      end;
      try
      DeleteFileUTF8(NameFileMediaPointeurs);
      except
      end;
      try
      DeleteFileUTF8(NameFileSource);
      except
      end;
      try
      DeleteFileUTF8(NameFileEventIndi);
      except
      end;
      try
      DeleteFileUTF8(NameFileUnion);
      except
      end;
      try
      DeleteFileUTF8(NameFileEventFam);
      except
      end;
      try
      DeleteFileUTF8(NameFileAsso);
      except
      end;
    //ibt_BASE.Active:=false;
    //ibd_BASE.Close;
    //IBSQL.Database := dm.ibd_BASE;
    //IBSQL.Transaction := dm.ibt_BASE;
  end;
end;

procedure TFImportGedcom.URLLink2Click(Sender: TObject);
begin
  GotoThisURL('www.gedx.com');
end;

procedure TFImportGedcom.rbClearBddClick(Sender: TObject);
begin
  SuperFormRefreshControls(Self);
end;

procedure TFImportGedcom.rbAddToBddClick(Sender: TObject);
begin
  SuperFormRefreshControls(Self);
end;

procedure TFImportGedcom.CreateDomicilesIndividu(const AIndi: TTag_INDIVIDUAL_RECORD);
var//modifié par AL pour import dans EVENEMENTS_IND
  s, add1: string;
  p, i: integer;
  TagDomi: TTag_DOMICILE;
  //tag obsolète conservé pour compatibilité avec anciens gedcom d'Ancestromania
begin
  if (AIndi._ADDR <> nil) and (AIndi.Cle <> -1) then
    begin
    TagDomi := AIndi._ADDR;
    with CutEventIndi,TagDomi do
    while TagDomi <> nil do
     begin
      for i := 0 to Params.Count - 1 do
        Params[i].AsString := '';

      Cle := CleEvInd;//pour quoi faire?
      //EV_IND_CLEF
      Params[0].AsInteger := CleEvInd;
      //EV_IND_KLE_FICHE
      Params[1].AsInteger := AIndi.cle;
      //EV_IND_KLE_DOSSIER
      Params[2].AsInteger := fNumDossierImport;
      //EV_IND_TYPE
      Params[3].AsString := 'RESI';
      //EV_IND_LIGNES_ADRESSE
      if _ADR1 <> nil then
        begin
        add1 := fs_copy(_ADR1.Value, 1, 160);
        Params[7].AsString := add1;
        end;
      if _ADR2 <> nil then
        Params[7].AsString :=
          add1 + _CRLF + fs_copy(_ADR2.Value, 1, 160);
      if _POST <> nil then
        Params[8].AsString := fs_copy(_POST.Value, 1, 10);
      //EV_IND_VILLE
      if _CITY <> nil then
        Params[9].AsString := fs_copy(_CITY.Value, 1, 50);
      //EV_IND_DEPT
      if _STAE <> nil then
        Params[10].AsString := fs_copy(_STAE.Value, 1, 30);
      //EV_IND_SUBD
      if _SUBD <> nil then
        Params[17].AsString := fs_copy(_SUBD.Value, 1, 50);
      //Latitude N quand positif, S si négatif
      //Longitude E quand positive et W quand négative
      if _LATI <> nil then
        if Copy(_LATI.Value, 1, 1) = 'S' then
          Params[23].AsString := '-' + copy(_LATI.Value, 2, 20)
        else
          Params[23].AsString := copy(_LATI.Value, 2, 20);
      if _LONG <> nil then
        if Copy(_LONG.Value, 1, 1) = 'W' then
          Params[24].AsString := '-' + copy(_LONG.Value, 2, 20)
        else
          Params[24].AsString := copy(_LONG.Value, 2, 20);
      //EV_IND_REGION
      if __ANCES_REG <> nil then
        Params[16].AsString := fs_copy(__ANCES_REG.Value, 1, 50);
      //EV_IND_PAYS
      if _CTRY <> nil then
        Params[11].AsString := fs_copy(_CTRY.Value, 1, 30);
      //ADR_PHOTO
      if cbImportImages.Checked then
        if _OBJE <> nil then
          CreateMediaBase(_OBJE, AIndi.Cle, CleEvInd, 'I', 'A');
      //EV_IND_TEL
      if _TEL <> nil then //_TEL  pour compatibilité
        begin
        s := _TEL.Value;
        for p := 0 to _TEL.Memo.Count - 1 do
          s := s + #13#10 + _TEL.Memo[p];
        Params[29].AsString := s;
        end
      else if _PHON <> nil then
        begin
        s := _PHON.Value;
        for p := 0 to _PHON.Memo.Count - 1 do
          s := s + _CRLF + _PHON.Memo[p];
        Params[29].AsString := s;
        end;
      //EV_IND_MAIL
      if _EMAIL <> nil then
        Params[30].AsString := fs_copy(_EMAIL.Value, 1, 120);
      //EV_IND_WEB
      if _WWW <> nil then
        Params[31].AsString := fs_copy(_WWW.Value, 1, 120);
      //DATE_WRITEN, DATE, DATE_YEAR, DATE_MOIS, DATE_FIN, DATE_YEAR_FIN, DATE_MOIS_FIN
      if _DATE <> nil then
       with _GDate do
        begin
        DecodeGedcomDate(_Date.Value);
         Params[4].AsString := fs_copy(fs_GetConvertedDate(HumanDate), 1, 100);
        if UseDate1 then
          begin
          Params[5].AsInteger := Year1;
          //MD utilisation de ShortDateFormat pour eviter les problèmes de culture AL?
          if ValidDateTime1 then
            Params[6].AsString :=
              FormatDateTime(ShortDateFormat, DateTime1);
          if (Month1 > 0) then
            Params[25].AsInteger := Month1;
          Params[26].AsInteger := DateCodeTard;
          Params[32].AsInteger := DateCode1;
          Params[33].AsInteger := DateCodeTot;
          if Day1 > 0 then
            Params[34].AsInteger := Day1;
          if Type_Key1 > 0 then
            Params[36].AsInteger := Type_Key1;
          end;
        if UseDate2 then
          begin
          Params[27].AsInteger := Year2;
          if (Month2 > 0) then
            Params[28].AsInteger := Month2;
          if Day2 > 0 then
            Params[35].AsInteger := Day2;
          if Type_Key2 > 0 then
            Params[37].AsInteger := Type_Key2;
          end;
        end;

      //EV_IND_INSEE
      if __ANCES_XINSEE <> nil then
        Params[19].AsString := fs_copy(__ANCES_XINSEE.Value, 1, 6);
      //Notes                             //AL
      if cbImportNotes.Checked then
        begin
        if _NOTE <> nil then
          begin
          s := _NOTE.AsLine;
          Params[14].AsString := s;
          end;
        end;

      ParamsToStr;
      FileWrite0(FileEventIndi, Line);
      // Flush(FileEventIndi);
      //on cherche le suivant...
      TagDomi := TTag_DOMICILE(PtrNextSameTag);
      Inc(CleEvInd);
     end;
    end;
end;

procedure TFImportGedcom.CreateMediaBase(const ATagMedia: TTag_MEDIA;
  const Cle_indi, pointe_sur: integer; const table, type_image: string);
var
  s, smemo: string;
  cleMedia, ClePointeur, lMemo,n: integer;
  MediaExiste: boolean;
begin
  with IBMultimedia do
   Begin
   with ATagMedia do
    Begin
      if _FILE <> nil then
        begin
        s := fs_copy(_FILE.Value, 1, 248);
        s := StringReplace(s, '/', DirectorySeparator, [rfReplaceAll]);
        //si le chemin est relatif on le complète avec la racine
        if (Pos(':', s) = 0) and (copy(s, 1, 2) <> DirectorySeparator +
          '' + DirectorySeparator) then
          //ajout DirectorySeparator+''+DirectorySeparator pour cas adresse absolue par réseau
          s := lsCheminImage + s;
        end
      else
        exit;

      ParamByName('MULTI_PATH').AsString := s;
      if _NOTE <> nil then
        begin
        smemo := _NOTE.AsLine;
        lMemo := length(smemo);
        end
      else
        lMemo := 0;
    end;
    ParamByName('MEMO').AsString := fs_copy(sMemo, 1, 250);

    Open;//sélection par MULTI_DOSSIER, MULTI_PATH et LENGTH_MEMO
    cleMedia := -1;//sert d'indicateur
    if not IBMultimediaMULTI_CLEF.IsNull then
      begin
      cleMedia := IBMultimediaMULTI_CLEF.AsInteger;
      if (length(IBMultimediaMULTI_MEMO.AsString) = 0) and (lMemo > 0) then
        begin
        Edit;
        TBlobField(IBMultimediaMULTI_MEMO).Value := smemo;
        Post;
        end;
      end
    else
      begin
        try //il semble que FileExistsUTF8 retourne une erreur si l'adresse est impossible (c:'+DirectorySeparator+'..'+DirectorySeparator+'fichier.jpg par exemple)
        MediaExiste := FileExistsUTF8(s); { *Converted from FileExistsUTF8*  }
        except
        MediaExiste := False;
        end;
      if MediaExiste then
        begin
        cleMedia := dm.uf_GetClefUnique('MULTIMEDIA');
        if cleMedia <> -1 then
          begin
          Insert;
          IBMultimediaMULTI_CLEF.AsInteger := cleMedia;
          IBMultimediaMULTI_DOSSIER.AsInteger := fNumDossierImport;
          IBMultimediaMULTI_PATH.AsString := s;
          n := pos ( fPathBaseMedias, s );
          if n = 1 Then
            IBMultimediaMULTI_NOM.AsString := copy(s,length(fPathBaseMedias)+1,length(s)-length(FPathBaseMedias));;
          IBMultimediaID_IMPORT_GEDCOM.AsInteger := NumImportation;
          IBMultimediaMULTI_DATE_MODIF.AsDateTime := Now;
          if FichEstImage(s) then
            begin
            IBMultimediaMULTI_IMAGE_RTF.AsInteger := 0;
            IBMultimediaMULTI_INFOS.AsString :=
              fs_RemplaceMsg(rs_Import_Image, [fs_Date2Str(Date), TimeToStr(Time)]);
            end
          else if FichEstSon(s) then
            begin
            IBMultimediaMULTI_IMAGE_RTF.AsInteger := 2;
            IBMultimediaMULTI_INFOS.AsString :=
              fs_RemplaceMsg(rs_Import_Sound, [fs_Date2Str(Date), TimeToStr(Time)]);
            end
          else if FichEstVideo(s) then
            begin
            IBMultimediaMULTI_IMAGE_RTF.AsInteger := 3;
            IBMultimediaMULTI_INFOS.AsString :=
              fs_RemplaceMsg(rs_Import_Video, [fs_Date2Str(Date), TimeToStr(Time)]);
            end
          else
            begin
            IBMultimediaMULTI_IMAGE_RTF.AsInteger := 1;
            IBMultimediaMULTI_INFOS.AsString :=
              fs_RemplaceMsg(rs_Import_Document, [fs_Date2Str(Date), TimeToStr(Time)]);
            end;

          IBMultimediaMULTI_DATE_MODIF.AsDateTime := Now;

          if (ATagMedia._NOTE <> nil) then
            TBlobField(IBMultimediaMULTI_MEMO).Value := smemo;

          Post;
          end;//de if cleMedia<>-1
        end;//de if MediaExiste
      end;//de if not IBMultimediaMULTI_CLEF.IsNull
    Close;
   end;
    if cleMedia <> -1 then
     with CutMediaPointeurs,ATagMedia do
      begin //création du MEDIA_POINTEUR
      ClePointeur := dm.uf_GetClefUnique('MEDIA_POINTEURS');
      Params[0].AsInteger := ClePointeur;
      Params[1].AsInteger := CleMedia;
      Params[2].AsInteger := pointe_sur;
      Params[3].AsString := table;//MP_TABLE
      s := '0';
      if _XIDEN <> nil then
        s := copy(_XIDEN.Value, 1, 1);
      if __IDEN <> nil then
        s := copy(__IDEN.Value, 1, 1);
      Params[4].AsInteger := StrToIntDef(s, 0);
      Params[5].AsInteger := fNumDossierImport;
      Params[6].AsInteger := cle_indi;
      Params[7].AsString := type_image;//MP_TYPE_IMAGE
      if __POI <> nil then
        s := __POI.Value
      else
        s := '0';
      Params[8].AsInteger := StrToIntDef(s, 0);//MP_POSITION AL 2010
      ParamsToStr;
      FileWrite0(FileMediaPointeurs, Line);
      end;
end;

procedure TFImportGedcom.RechercheImage;
var
  MS, MS2: TMemoryStream;
  traite: boolean;
begin
  IBMultimedia.Close;
  IBMultimedia.SQL.Text :=
    'select * from multimedia where ID_IMPORT_GEDCOM=:NumImportation';
  IBMultimedia.Params[0].AsInteger := NumImportation;
  MS := TMemoryStream.Create;
  MS2 := TMemoryStream.Create;
  IBMultimedia.Open;
    try
    while (not IBMultimedia.EOF) do
      begin
      traite := False;
      if FileExistsUTF8(IBMultimediaMULTI_PATH.AsString)
      { *Converted from FileExistsUTF8*  } then
        begin//le test a déjà été fait pour créer l'enregistrement...
        IBMultimedia.Edit;
        IBMultimediaMULTI_MEDIA.Clear;
        if IBMultimediaMULTI_IMAGE_RTF.AsInteger = 1 then  //fichier
          begin
          MS.Clear;
          iAutre.Picture.Graphic.SaveToStream(MS);
          TBlobField(IBMultimediaMULTI_REDUITE).LoadFromStream(MS);
          traite := True;
          end
        else if IBMultimediaMULTI_IMAGE_RTF.AsInteger = 2 then
          begin
          MS.Clear;
          iSons.Picture.Graphic.SaveToStream(MS);
          TBlobField(IBMultimediaMULTI_REDUITE).LoadFromStream(MS);
          traite := True;
          end
        else if IBMultimediaMULTI_IMAGE_RTF.AsInteger = 3 then
          begin
          MS.Clear;
          iVideo.Picture.Graphic.SaveToStream(MS);
          TBlobField(IBMultimediaMULTI_REDUITE).LoadFromStream(MS);
          traite := True;
          end
        else if IBMultimediaMULTI_IMAGE_RTF.AsInteger = 0 then
          begin
          if ComprImageInMS(IBMultimediaMULTI_PATH.AsString, MS, MS2,
            True, 140, 120, gci_context.ImagesDansBase) then
            begin
            TBlobField(IBMultimediaMULTI_REDUITE).LoadFromStream(MS);
            if MS2.Size > 0 then
              TBlobField(IBMultimediaMULTI_MEDIA).LoadFromStream(MS2)
            else
              IBMultimediaMULTI_IMAGE_RTF.AsInteger := 1;
            traite := True;
            end
          else
            begin
            IBMultimediaMULTI_IMAGE_RTF.AsInteger := 1; //reboucle sur le même média
            IBMultimediaMULTI_INFOS.AsString :=
              fs_RemplaceMsg(rs_Import_Document, [fs_Date2Str(Date), TimeToStr(Time)]);
            end;
          end
        else
          begin
          IBMultimediaMULTI_IMAGE_RTF.AsInteger := 1;
          IBMultimediaMULTI_INFOS.AsString :=
            fs_RemplaceMsg(rs_Import_Document, [fs_Date2Str(Date), TimeToStr(Time)]);
          end;
        end//de fichier existe
      else
        traite := True;
      if traite = True then
        IBMultimedia.Next;
      end;
    finally
    IBMultimedia.Close;
    MS.Free;
    MS2.Free;
    end;
end;

procedure TFImportGedcom.CreateSourceEvent(const aEvent: TTag_Event_Detail;
  const sTable: string; const un_indi: integer);
var
  cleSource: integer;
  TagMedia: TTag_MEDIA;
  dt: TDateTime;
  s: string;
begin
  //erreur/GEDCOM confusion des niveaux SOURCE_CITATION et SOURCE_RECORD
  //on devrait d'abord importer SOURCE_CITATION avant SOURCE_RECORD s'ils étaient correctement définis.
  if (Length(s_ABBR) > 0) or (Length(s_TEXT) > 0) or (Length(s_TITL) > 0) or
    (Length(s_REPO) > 0) or (Length(s_PUBL) > 0) or (Length(s_AUTH) > 0) or
    (M_OBJE <> nil) then
   with Cutsource do
    begin
    cleSource := dm.uf_GetClefUnique('SOURCES_RECORD');
    if cleSource <> -1 then
      begin
      Params[0].AsInteger := cleSource;
      Params[1].AsInteger := aEvent.cle;
      Params[2].AsString := fs_copy(s_ABBR, 1, 60);
      Params[3].AsString := s_TEXT;
      Params[4].AsString := s_TITL;
      Params[5].AsString := fs_copy(s_REPO, 1, 90);
      Params[6].AsString := s_AUTH;
      dt := now;
      if C_CHAN <> nil then
       with C_CHAN do
        begin
        if _DATE <> nil then
         with _GDate do
          begin
          s := _DATE.Value;
          DecodeGedcomDate(s);
          if ValidDateTime1 then
            begin
            dt := DateTime1;
            if _DATE._TIME <> nil then
              begin
              s := _DATE._TIME.Value;
              dt := dt + StrToTimeDef(s, 0);
              end;
            end;
          end;
        end;
      Params[7].AsDateTime := dt;
      Params[8].AsString := s_PUBL;
      Params[9].AsString := sTable;
      Params[10].AsInteger := fNumDossierImport;
      if sTable = 'I' then
        CutEventIndi.Params[13].AsString := s_TEXT
      else
        CutEventFam.Params[10].AsString := s_TEXT;
      ParamsToStr;
      FileWrite0(FileSource, Line);
      // Flush(FileSource);
      if cbImportImages.Checked and (M_OBJE <> nil) then //ne fonctionne pas
        begin
        TagMedia := M_OBJE;
        while TagMedia <> nil do
          begin
          CreateMediaBase(TagMedia, un_indi, cleSource, 'F', 'F');
          //on cherche le suivant...
          TagMedia := TTag_MEDIA(TagMedia.PtrNextSameTag);
          end;
        end;
      end;
    end;
end;

procedure TFImportGedcom.SuperFormHide(Sender: TObject);
begin
  OpenDialog.InitialDir := gci_context.PathImportExport;
end;

procedure TFImportGedcom.ListeErreurs;
var
  req: TIBSQL;
  FicErreurs: THandle;
  NomFic: string;
begin
  req := TIBSQL.Create(self);
  req.Database := dm.ibd_BASE;
  req.Transaction := dm.IBT_BASE;
  req.SQL.Add('select coalesce(i.nom,'''')||coalesce('', ''||i.prenom,'''')' +
    '||'', NIP ''||cast(i.cle_fiche as varchar(20))' +
    '||'' événement individuel ''' +
    '||r.ref_eve_lib_long||'' ''||t.texte_message' + ' from traces t' +
    ' inner join evenements_ind e on e.ev_ind_clef=t.enr_table' +
    ' inner join individu i on i.cle_fiche=e.ev_ind_kle_fiche' +
    ' inner join dossier ds on ds.cle_dossier=i.kle_dossier' +
    ' inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type and r.ref_eve_langue=ds.ds_langue'
    + ' where t.nom_table=''EVENEMENTS_IND''' + ' union' +
    ' select coalesce(i.nom,'''')||coalesce('', ''||i.prenom,'''')' +
    '||'', NIP ''||cast(i.cle_fiche as varchar(20))' + '||'' adresse ''' +
    '||t.texte_message' + ' from traces t' +
    ' inner join adresses_ind a on a.adr_clef=t.enr_table' +
    ' inner join individu i on i.cle_fiche=a.adr_kle_ind' +
    ' where t.nom_table=''ADRESSES_IND''' + ' union' +
    ' select coalesce(i.nom,'''')||coalesce('', ''||i.prenom,'''')' +
    '||'', NIP ''||cast(i.cle_fiche as varchar(20))' + '||'' événement familial ''' +
    '||r.ref_eve_lib_long||'' ''||t.texte_message' + ' from traces t' +
    ' inner join evenements_fam f on f.ev_fam_clef=t.enr_table' +
    ' inner join t_union u on u.union_clef=f.ev_fam_kle_famille' +
    ' inner join individu i on i.cle_fiche=u.union_mari' +
    ' inner join dossier ds on ds.cle_dossier=i.kle_dossier' +
    ' inner join ref_evenements r on r.ref_eve_lib_court=f.ev_fam_type and r.ref_eve_langue=ds.ds_langue'
    + ' where t.nom_table=''EVENEMENTS_FAM''' + ' order by 1');
  req.ExecQuery;
  NomFic := edPathFileNameGED.Text;
  NomFic := ChangeFileExt(NomFic, '_' + rs_Log_Errors_Filename + '.txt');
  FicErreurs := FileCreateDeleteUTF8File(NomFic);
  FileWriteLn(FicErreurs, fs_RemplaceMsg(rs_Log_Errors_File_import,
    [NomFic, fs_DateTime2Str(Now)]));
  FileWriteLn(FicErreurs);
  while not req.EOF do
    begin
    FileWriteLn(FicErreurs, req.fields[0].AsString);
    req.Next;
    end;
  FileClose(FicErreurs);
  req.Close;
  req.Free;
  p_OpenFileOrDirectory(NomFic);
  //  ShellExecute(0,nil,PChar(NomFic),nil,nil,SW_SHOWDEFAULT);
end;

procedure TFImportGedcom.DoShow;
begin
  inherited DoShow;
  with edPathFileNameGED do
    if ( Text > '' )
    and FileExistsUTF8(Text) Then
      SuperFormRefreshControls(Self);
end;

destructor TFImportGedcom.Destroy;
begin
  if ( FImported )
  and rbClearBdd.Checked Then
    FMain.option_RenumerotationSOSAClick(Self);
  inherited Destroy;
end;

procedure TFImportGedcom.btInfosAuteurClick(Sender: TObject);
begin
  MyMessageDlg(ConversionChaine(fHeaderNote,FJeuCaractere), mtInformation, [mbOK]);
end;

end.
