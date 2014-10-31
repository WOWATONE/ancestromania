unit U_AncestroWeb;

{$IFDEF FPC}
{$R *.lfm}
{$mode objfpc}{$H+}
{$ELSE}
{$R *.dfm}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
// AncestroWeb
// Plugin libre de création d'un site web généalogique statique en HTML et PHP
// Pour Freelogy et Ancestrologie
// Licence : LGPL
// LIBERLOG 2011
// Auteur : Matthieu GIROUX
// Descriptions
// Création d'un arbre complet, d'une page de contact en PHP, de fiches, etc.
// Historique
// 1.1.4.1 : Gestion de versions
// 1.1.4.0 : Plus de TIBSQL, copie de l'archive originale fonctionnel, moins de bugs
// 1.1.3.1 : Professions dans la fiche de l'individu, Possibilité de descendre son arbre familial
// 1.1.1.2 : Plus de tests
// 1.1.1.1 : Métiers et âges
// 1.0.0.0 : Intégration dans Freelogy
// 0.9.9.0 : première version publiée
////////////////////////////////////////////////////////////////////////////////

interface

uses
{$ifdef unix}
{$endif}

{$IFNDEF FPC}
  Mask,  rxToolEdit, JvExControls,  Windows,
{$ELSE}
  EditBtn,FileUtil,
{$ENDIF}
  fonctions_string,
{$ifdef windows}
  Windows,
{$endif}
{$IFDEF WIN32}
  Registry,
{$ENDIF}
{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
  U_DMWeb, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls, DB,
  IBQuery, ExtCtrls, ComCtrls, DBGrids,
  lazutf8classes,
  functions_html, ExtJvXPCheckCtrls, Spin, U_OnFormInfoIni,
  U_ExtImage, u_buttons_appli, IBSQL, U_ExtFileCopy,
  ExtJvXPButtons, IniFiles,
  u_common_ancestro,
  u_extabscopy, u_extsearchedit, U_FormAdapt;

{$IFDEF VERSIONS}
const
  gVer_AncestroWeb : T_Version = ( Component : 'Application Ancestroweb' ;
                                             FileUnit : 'U_AncestroWeb' ;
                                             Owner : 'Matthieu Giroux' ;
                                             Comment : 'Composant de copie multi-platformes.' ;
                                             BugsStory : '1.3.3.0 : No original media, updating leaflet.' +#13#10
                                                       + '1.3.2.0 : shadow box.' +#13#10
                                                       + '1.3.1.0 : No border on ie.' +#13#10
                                                       + '1.3.0.7 : Tree spaces.' +#13#10
                                                       + '1.3.0.6 : No union files bug.' +#13#10
                                                       + '1.3.0.5 : Correct special chars links.' +#13#10
                                                       + '1.3.0.4 : Correct jobs images.' +#13#10
                                                       + '1.3.0.3 : Restoring Ancestromania integration.' +#13#10
                                                       + '1.3.0.2 : Better splitted tree and better progress.' +#13#10
                                                       + '1.3.0.0 : Restructure, Finalizing files.' +#13#10
                                                       + '1.2.7.1 : Large database.' +#13#10
                                                       + '1.2.7.0 : Map in HTML only.' +#13#10
                                                       + '1.2.6.0 : Splitted map.' +#13#10
                                                       + '1.2.5.0 : Splitted tree.' +#13#10
                                                       + '1.2.4.0 : Adding searchedit' +#13#10
                                                       + '1.2.3.0 : Confidential persons' +#13#10
                                                       + '1.2.2.6 : No Flat Combo' +#13#10
                                                       + '1.2.2.5 : Delphi compatible' +#13#10
                                                       + '1.2.2.1 : Link to jobs'' base' +#13#10
                                                       + '1.2.2.0 : Link to cities, names, surnames base' +#13#10
                                                       + '1.2.1.1 : Hide dates lesser than 100 years' +#13#10
                                                       + '1.2.1.0 : Better look and interactivity' +#13#10
                                                       + '1.2.0.0 : Adding Map' +#13#10
                                                       + '1.1.5.0 : Adding versioning' +#13#10
                                                       + '1.1.4.0 : More of TIBSQL, copy original media, less bugs' +#13#10
                                                       + '1.1.3.1 : Jobs in Person''s file, Tree descending' +#13#10
                                                       + '1.1.1.2 : More tests' +#13#10
                                                       + '1.1.1.1 : Jobs and ages' +#13#10
                                                       + '1.0.0.0 : Integrating in Freelogy' +#13#10
                                                       + '0.9.9.0 : First published version' ;
                                             UnitType : CST_TYPE_UNITE_APPLI ;
                                             Major : 1 ; Minor : 3 ; Release : 3 ; Build : 0 );

{$ENDIF}

type

  { TF_AncestroWeb }

  TF_AncestroWeb = class(TF_FormAdapt)
    btnSelectBase: TFWLoad;
    bt_export: TFWSaveAs;
    bt_gen: TFWSaveAs;
    cb_CityAccents: TComboBox;
    cb_ContactSecurity: TComboBox;
    cb_ContactTool: TComboBox;
    cb_ImagesJobsAccents: TComboBox;
    cb_JobsAccents: TComboBox;
    cb_NamesAccents: TComboBox;
    cb_SurnamesAccents: TComboBox;
    cb_treeWithoutJavascript: TJvXPCheckbox;
    ch_ancestors: TJvXPCheckBox;
    ch_CitiesLink: TJvXPCheckbox;
    ch_HideLessThan100: TJvXPCheckbox;
    ch_JobsImages: TJvXPCheckbox;
    ch_JobsLink: TJvXPCheckbox;
    ch_NamesLink: TJvXPCheckbox;
    ch_nooriginalphoto: TJvXPCheckbox;
    ch_Comptage: TJvXPCheckBox;
    ch_ContactIdentify: TJvXPCheckBox;
    ch_Filtered: TJvXPCheckBox;
    ch_genages: TJvXPCheckBox;
    ch_genMap: TJvXPCheckBox;
    ch_genContact: TJvXPCheckBox;
    ch_genjobs: TJvXPCheckBox;
    ch_gensurnames: TJvXPCheckBox;
    cb_Themes: TComboBox;
    cbDossier: TComboBox;
    ch_genSearch: TJvXPCheckBox;
    ch_genTree: TJvXPCheckBox;
    ch_SplittedMap: TJvXPCheckbox;
    ch_SplittedTree: TJvXPCheckbox;
    ch_SmartTree: TJvXPCheckbox;
    ch_Images: TJvXPCheckBox;
    ch_ShowMainFile: TJvXPCheckBox;
    ch_SurnamesLink: TJvXPCheckbox;
    DBGrid1: TDBGrid;
    ds_Individu: TDatasource;
    cb_Base: TComboBox;
    ed_AgesName: TEdit;
    ed_Author: TEdit;
    ed_BaseCities: TEdit;
    ed_BaseJobs: TEdit;
    ed_BaseNames: TEdit;
    ed_BaseSurnames: TEdit;
    ed_ContactAuthor: TEdit;
    ed_ContactHost: TEdit;
    ed_ContactMail: TEdit;
    ed_ContactName: TEdit;
    ed_ContactPassword: TEdit;
    ed_ContactPassword2: TEdit;
    ed_ContactUser: TEdit;
    ed_FileBeginName: TEdit;
    ed_ImagesJobs: TEdit;
    ed_IndexName: TEdit;
    ed_JobsName: TEdit;
    ed_ListsBeginName: TEdit;
    ed_SurnamesFileName: TEdit;
    ed_MapFileName: TEdit;
    ed_SearchName: TEdit;
    ed_SearchQuery: TEdit;
    ed_SearchSite: TEdit;
    ed_SearchTool: TEdit;
    ed_TreeName: TEdit;
    ExtImage1: TExtImage;
    ExtImage2: TExtImage;
    ExtImage3: TExtImage;
    FileCopy: TExtFileCopy;
    fne_Export: TFileNameEdit;
    fne_import: TFileNameEdit;
    FWEraseGedcom: TFWErase;
    FWEraseImage: TFWErase;
    FWEraseImage2: TFWErase;
    FWEraseImage3: TFWErase;
    FWClose1: TFWClose;
    FWPreview1: TFWPreview;
    IBQ_Individu: TIBQuery;
    GedcomEdit: TFileNameEdit;
    ImageEdit1: TFileNameEdit;
    ImageEdit2: TFileNameEdit;
    ImageEdit3: TFileNameEdit;
    JvXPButton1: TJvXPButton;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    lb_Images: TLabel;
    L_themaHint: TLabel;
    Label56: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    LabelBase: TLabel;
    lb_Comments: TLabel;
    L_thema: TLabel;
    Label9: TLabel;
    lb_DescribeMap: TLabel;
    me_Bottom: TMemo;
    me_ContactHead: TMemo;
    me_MapHead: TMemo;
    me_Description: TMemo;
    me_FilesHead: TMemo;
    me_HeadAges: TMemo;
    me_HeadJobs: TMemo;
    me_HeadTree: TMemo;
    me_surnamesHead: TMemo;
    me_searchHead: TMemo;
    OnFormInfoIni: TOnFormInfoIni;
    PageControl1: TPageControl;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel2: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel3: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel37: TPanel;
    Panel38: TPanel;
    Panel39: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    Panel42: TPanel;
    Panel7: TPanel;
    Panel9: TPanel;
    pc_needed: TPageControl;
    Panel10: TPanel;
    Panel8: TPanel;
    PCPrincipal: TPageControl;
    Panel1: TPanel;
    pa_About: TScrollbox;
    pa_base: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Pa_filter: TPanel;
    pb_ProgressInd: TProgressBar;
    pb_ProgressAll: TProgressBar;
    se_ContactPort: TSpinEdit;
    se_Nom: TExtSearchEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    spSkinPanel1: TPanel;
    sp_gentree: TSpinEdit;
    sp_groupMap: TSpinEdit;
    ts_global: TTabSheet;
    ts_ages: TTabSheet;
    ts_jobs: TTabSheet;
    ts_contact: TTabSheet;
    ts_tree: TTabSheet;
    ts_search: TTabSheet;
    ts_surnames: TTabSheet;
    ts_options: TTabSheet;
    ts_Files: TTabSheet;
    ts_home: TTabSheet;
    ts_needed: TTabSheet;
    ts_about: TTabSheet;
    ts_Gen: TTabSheet;
    cb_Files: TComboBox;
    Label44: TLabel;
    de_ExportWeb: TDirectoryEdit;
    procedure btnSelectBaseClick(Sender: TObject);
    procedure bt_exportClick(Sender: TObject);
    procedure bt_genClick(Sender: TObject);
    procedure cbDossierChange(Sender: TObject);
    procedure ch_FilteredClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure de_ExportWebAcceptDirectory(Sender: TObject;{$IFDEF FPC} var Value: string{$ELSE} var Name: string;
    var Action: Boolean{$ENDIF});
    procedure cb_BaseChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure p_BaseOpen;
    procedure FileCopyDoEraseDir(Sender: TObject; var Continue: boolean);
    procedure FileCopyFailure(Sender: TObject; const ErrorCode: integer;
      var ErrorMessage: string; var ContinueCopy: boolean);
    procedure fne_ExportAcceptFileName(Sender: TObject; var Value: String);
    procedure fne_importAcceptFileName(Sender: TObject; var Value: String);
    procedure FWEraseImage3Click(Sender: TObject);
    procedure FWEraseImage2Click(Sender: TObject);
    procedure FWEraseImageClick(Sender: TObject);
    procedure FWPreview1Click(Sender: TObject);
    procedure ImageEdit2Change(Sender: TObject);
    procedure ImageEdit3Change(Sender: TObject);
    procedure ImageEdit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JvXPButton1Click(Sender: TObject);
    procedure OnFormInfoIniIniLoad(const AInifile: TCustomInifile;
      var Continue: Boolean);
    procedure OnFormInfoIniIniWrite(const AInifile: TCustomInifile;
      var Continue: Boolean);
    procedure se_NomSet(Sender: TObject);
    procedure TraduceImageFailure(Sender: TObject; const ErrorCode: integer;
      var ErrorMessage: string; var ContinueCopy: boolean);
  private
    { Déclarations privées }
    PremiereOuverture:boolean;
    procedure DoAfterInit( const ab_Ini : Boolean = True );
    function DoOpenBase(sBase: string):boolean;
    function fb_Showdate(const adt_Date: TDateTime; const ai_confidentiel : Integer ): Boolean;
    function fb_ShowYear(const ai_Year : Integer ; const ai_confidentiel : Integer): Boolean;
    function fs_getLinkedBase(const as_ShowedText, as_Texte: String;
      const as_Link: String; const ai_ComboIndex: Integer ; const ab_StopMore : Boolean = False): String;
    function fs_getLinkedBaseImage(const as_Texte: String;
      const as_Link: String; const ai_ComboIndex: Integer; const ab_StopMore : Boolean = False): String;
    function fs_getLinkedCity(const as_Texte: String ): String;
    function fs_getLinkedFormated( as_Label: String; const as_Texte, as_Link: String): String;
    function fs_getLinkedImage(const as_Texte: String; const as_Link: String;
      const ai_ComboIndex, ai_counter: Integer): String;
    function fs_getLinkedJob(const as_Texte: String; const ai_counter : Integer): String;
    function fs_getLinkedName(const as_Texte: String; var aa_listWords : TUArray ; const av_confidential : Integer): String;
    function fs_getLinkedSurName(const as_Texte: String ): String;
    function fs_GetNameLink( as_name : String ; const as_key, as_Showed : String ; const as_SubDir : String = ''):String ;
    function fs_GetSOSA(const IBQuery: TIBQuery): String;
    function OuvreDossier(NumDossier:integer):boolean;
    function fb_OpenMedias( const ai_CleFiche: Longint;
                            const ai_Type: integer;
                            const ab_Identite: Boolean = False;
                            const ach_table : Char = MEDIAS_TABLE_ARCHIV): Boolean;
    function fi_ImageEditCount(const as_FileName: string): integer;
    function fs_AddImage(const as_ImageFile: string): string;
    function fs_AddImageTable(const as_HtmlImage: string; const as_alt: string=''
      ): string;
    function fs_AddPhoto( const ai_cleFiche: longint;
                          const as_FileAltName, as_ImagesDir: string ;
                          const ai_ResizeWidth : Integer = 180 ): string;
    function fs_CreatePrevNext ( const ai_PreviousNext: Longint;
                                 const as_PreviousNext: String=CST_PAGE_PREVIOUS;
                                 const as_Subdir: String='';
                                       as_BeginLinkFiles: String=CST_SUBDIR_HTML_FILES_DIR): String;
    function fs_GetTitleTree(const as_NameOfTree: String;
                             const ai_generations: Longint): String;
    procedure p_CopyStructure;
    procedure p_CreateAHtmlFile(const astl_Destination: TStringlistUTF8;
      const as_BeginingFile, as_Describe, as_Title, as_SelectedTitle, as_LongTitle: string;
      as_BottomHTML: string;
      const as_Subdir: string = '';
      const as_ExtFile: string = CST_EXTENSION_HTML;
      const as_BeforeHTML: string = ''; const astl_Body : TStringlistUTF8 = nil );
    function fi_CreateHTMLTree(const IBQ_Tree: TIBQuery;
      const astl_HTMLTree: TStrings;
      const ai_Clefiche: longint;
      const ab_Div: boolean = True;
      const ab_Link: boolean = True;
      const ab_Progress: boolean = True;
      const ab_NotFirst: boolean = False;
      const as_IdSosa: string = IBQ_TQ_SOSA;
      const ab_Asc: boolean = True): longint;
    function fi_CreateSheets: integer;
    procedure p_createLettersSheets (var at_SheetsLetters : TAHTMLULTabSheet;
                                     const IBQ_FilesFiltered: TIBQuery;
                                     const ai_PerPage : Integer;
                                     const as_BeginFile : String);
    procedure p_genHtmlAges;
    procedure p_genHtmlFiles(const IBQ_FilesFiltered: TIBQuery);
    procedure p_genHtmlJobs;
    procedure p_genHtmlList(const IBQ_FilesFiltered: TIBQuery);
    procedure p_genHtmlsurnames(const IBS_FilesFiltered: TIBSQL;const IBQ_Names: TIBQuery);
    procedure p_genHtmlSearch;
    procedure p_genPhpContact;
    procedure p_genHtmlHome;
    procedure p_genHTMLTitle;
    procedure p_genHTMLTree ( const IBQ_tree : TIBQuery  ; const ab_Splitted : Boolean ; const ai_generationSplitted : Integer );
    procedure p_ImageEditChange(const aei_Image: TExtImage; const Sender: TObject);
    procedure p_ImageEditErase(const afne_EditImage: TFileNameEdit);
    procedure p_IncProgressBar;
    procedure p_IncProgressInd;
    procedure p_iniReadKey;
    procedure p_iniWriteKey;
    function fb_OpenTree(const AIBQ_Tree: TIBQuery; const ai_Cle: longint;
      const ai_Niveau: integer = 0;const ai_Sexe: integer = 0): boolean; overload; virtual;
    function fb_OpenTree(const AIBQ_Tree: TIBSQL; const ai_Cle: longint;
      const ai_Niveau: integer = 0;const ai_Sexe: integer = 0): boolean; overload; virtual;
    procedure p_setBaseToIniFile ( const as_Base : String );
    procedure p_Setcomments(const as_Comment: String);
    procedure ListerDossiers;
  public
    { Déclarations publiques }
    function DoInit(const sBase: string):Boolean;
    function DoInitBase(const AedNomBase: TCustomComboBox):Boolean;
  end;

var
  F_AncestroWeb: TF_AncestroWeb;
  gs_HTMLTitle: string = '';
  gb_EraseExport: boolean = True;
  gb_Generate : boolean = False;
  {$IFDEF WINDOWS}
  gb_Logie : Boolean ;
  gs_Ancestro : String;
  {$ENDIF}
  gi_PagesCount : Longint;
  gi_CleFiche: integer = 0;
  gs_LinkGedcom: string;
  gs_RootPathForExport: string;
  gt_SheetsMapGroup,
  gt_SheetsLetters: TAHTMLULTabSheet;
  gDat_Existing_Persons : TDataset = nil;
  // for map
  gt_Surnames : Array of Record
                          Name : String;
                          Minlatitude  ,
                          Minlongitude ,
                          Maxlatitude  ,
                          Maxlongitude : Double;
                          MaxCounter   : Int64;
                        end;

implementation

uses  fonctions_init,
  functions_html_tree,
  LazUTF8,
  u_firebird_functions,
  fonctions_dialogs,
  Variants,
  u_common_functions,
  u_dm,
{$IFNDEF FPC}
  AncestroWeb_strings_delphi,
  ShellApi, ShlObj,
  //windirs,
{$ELSE}
  AncestroWeb_strings,
{$ENDIF}
{$IFDEF WIN32}
//  windirs,
{$ENDIF}
  fonctions_system,
  fonctions_dbcomponents,
  fonctions_languages,
  fonctions_images,
  fonctions_components,
  u_common_ancestro_functions,
  fonctions_file;


var lw_CurrentYear  : Word = 0;
    ldt_100YearData : TDateTime = 0;

//  function fi_findName
// search a name in the array gt_Surnames
function fi_findName ( const as_Name : string ): Integer;
var li_i : LongInt;
Begin
  for li_i := 0 to high ( gt_Surnames ) do
   if gt_Surnames [ li_i ].Name = as_Name Then
    Begin
      Result := li_i;
      Exit;
    end;
  Result := -1;
End;


// function GetCurrentYear
// Get Current Year
function GetCurrentYear: word;
var
  d,m,y: word;
begin
  if lw_CurrentYear = 0 Then
    DecodeDate(Now, lw_CurrentYear, m, d);
  Result := lw_CurrentYear;
end;

// function Get100YearDated
// Get now - 100 Year
function Get100YearDated: TDateTime;
var
  d,m,y: word;
begin
  if ldt_100YearData = 0 Then
    ldt_100YearData := EncodeDate(GetCurrentYear-100,1,1);
  Result:=ldt_100YearData;
end;

// function TF_AncestroWeb.fb_ShowYear
// show date or not
function TF_AncestroWeb.fb_ShowYear ( const ai_Year : Integer ; const ai_confidentiel : Integer ): Boolean ;
Begin
  Result :=  (( ai_confidentiel < 1 ) or ( ai_confidentiel > 2 )) and ( not ch_HideLessThan100.Checked
    or ( ai_Year <  GetCurrentYear - 100 ));
//  ShowMessage ( IntToStr(GetCurrentYear) + ' ' + FormatDateTime( 'yyyy', Get100YearDated)  + ' ' + DateToStr( Get100YearDated)) ;
end;

// function TF_AncestroWeb.fb_Showdate
// show date or not
function TF_AncestroWeb.fb_Showdate ( const adt_Date : TDateTime; const ai_confidentiel : Integer ): Boolean ;
Begin
  Result := (( ai_confidentiel < 1 ) or ( ai_confidentiel > 2 )) and ( not ch_HideLessThan100.Checked
    or ( adt_Date < Get100YearDated ));
end;
// procedure TF_AncestroWeb.FormDestroy
// Freeing data objects on destroy event
procedure TF_AncestroWeb.FormDestroy(Sender: TObject);
begin
  if Assigned(FIniFile) Then
   Begin
    OnFormInfoIni.p_ExecuteEcriture(Self);
    FreeAndNil(FIniFile);
   end;
  DMWeb.Free;
  DMWeb := nil;
end;


// procedure TF_AncestroWeb.p_clonePersonVerify
// creating a HTML list of persons
procedure p_clonePersonVerify (const IBQ_FilesFiltered: TIBQuery );
Begin
  gDat_Existing_Persons := fdat_CloneDatasetWithSQL ( IBQ_FilesFiltered, DMWeb );
  //ShowMessage(TIBQuery(gDat_Existing_Persons).SQL.Text);
  try
    gDat_Existing_Persons.open;
  Except
    MyShowMessage ( gs_ANCESTROWEB_cantOpenData ) ;
  end;
end;

// function fb_IsCreatedPerson
// verify if person is in the list or in the files
function fb_IsCreatedPerson ( const ai_Key : Int64 ):Boolean;
var li_i : Longint;
Begin
  Result := not Assigned(gDat_Existing_Persons);
  if not Result Then
    with gDat_Existing_Persons do
      try
         Result := Locate(IBQ_CLE_FICHE,ai_Key,[]);
      Except
        MyShowMessage ( gs_ANCESTROWEB_cantOpenData ) ;
      end;
end;


// procedure TF_AncestroWeb.DBGrid1CellClick
// Writeng ini on dbgrid click
procedure TF_AncestroWeb.DBGrid1CellClick(Column: TColumn);
begin
  p_iniWriteKey;
end;

// procedure TF_AncestroWeb.p_iniWriteKey
// Writing the DBGrid ini key
procedure TF_AncestroWeb.p_iniWriteKey;
begin
  if IBQ_Individu.Active Then
    fCleFiche := IBQ_Individu.FieldByName(IBQ_CLE_FICHE).AsInteger;
  p_IniWriteSectionInt(CST_INI_ANCESTROWEB_SECTION, IBQ_CLE_FICHE, fCleFiche);
end;

// procedure TF_AncestroWeb.p_iniReadKey
// Reading the DBGrid ini key
procedure TF_AncestroWeb.p_iniReadKey;
begin
  fCleFiche := f_IniReadSectionInt(CST_INI_ANCESTROWEB_SECTION, IBQ_CLE_FICHE, fCleFiche);
  if IBQ_Individu.Active Then
    IBQ_Individu.Locate(IBQ_CLE_FICHE,fCleFiche,[]);
end;

// procedure TF_AncestroWeb.de_ExportWebAcceptDirectory
// Web site export : Simplifying user's interactivity
procedure TF_AncestroWeb.de_ExportWebAcceptDirectory(Sender: TObject;
 {$IFDEF FPC} var Value: string{$ELSE} var Name: string;
    var Action: Boolean{$ENDIF});
begin
  gb_EraseExport := False;
end;

procedure TF_AncestroWeb.p_setBaseToIniFile ( const as_Base : String );
Begin
  if ( as_Base > '' ) Then
   Begin
    fbddpath := as_Base;
   end;
end;

procedure TF_AncestroWeb.cb_BaseChange(Sender: TObject);
begin
  p_setBaseToIniFile ( cb_Base.Text );
  p_BaseOpen;
end;

procedure TF_AncestroWeb.FormActivate(Sender: TObject);
begin
  if PremiereOuverture Then
   Begin
    PremiereOuverture:=False;
    Exit;
   end;
  fb_iniWriteFile(FIniFile);
  FreeAndNil(FIniFile);
  f_GetMainMemIniFile(nil,nil,nil,False,CST_AncestroWeb);
end;

procedure TF_AncestroWeb.FormDeactivate(Sender: TObject);
begin
  OnFormInfoIni.p_ExecuteEcriture(Self);
  fb_iniWriteFile(FIniFile,False);
  FreeAndNil(FIniFile);
end;

procedure TF_AncestroWeb.FormShow(Sender: TObject);
begin
  OnFormInfoIni.p_ExecuteLecture(Self);
end;


// procedure TF_AncestroWeb.edNomBaseExit
// Database's folder opening on Nombaseedit's Exit
procedure TF_AncestroWeb.p_BaseOpen;
var
  NumDossier:Integer;
begin
  if  DoInitBase(cb_Base)
  and fb_AutoComboInit(cbDossier)
   then
    begin
      NumDossier:=StrToInt(trim(copy(cbDossier.Text,1,2)));
      if OuvreDossier(NumDossier) then
      begin
       fNom_Dossier:=fs_getCorrectString(copy(cbDossier.Text,5,250));
       DoAfterInit ( False );
      end;
    end;
end;

// procedure TF_AncestroWeb.FileCopyDoEraseDir
// Erasing directory : event
procedure TF_AncestroWeb.FileCopyDoEraseDir(Sender: TObject; var Continue: boolean);
begin
  Continue := gb_EraseExport or
    (MyMessageDlg({$IFDEF FPC}CST_AncestroWeb_WithLicense,{$ENDIF}
    fs_getCorrectString ( gs_AnceSTROWEB_DoEraseOldExport ) +
    dm.FileCopy.Destination + ' ?', mtWarning, [mbYes,mbNo], 0) = mrYes);
end;

// procedure TF_AncestroWeb.FileCopyFailure
// Failure on copy : Event
procedure TF_AncestroWeb.FileCopyFailure(Sender: TObject;
  const ErrorCode: integer; var ErrorMessage: string; var ContinueCopy: boolean);
begin
  MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_ExportErrorCreate ) + dm.FileCopy.Source + CST_ENDOFLINE + ErrorMessage);
  Abort;
end;

// procedure TF_AncestroWeb.fne_ExportAcceptFileName
// Exporting ini on filename's accept
procedure TF_AncestroWeb.fne_ExportAcceptFileName(Sender: TObject;
  var Value: String);
begin
  bt_exportClick(bt_export);
end;

// procedure TF_AncestroWeb.fne_importAcceptFileName
// Importing ini on filename's accept
procedure TF_AncestroWeb.fne_importAcceptFileName(Sender: TObject;
  var Value: String);
var ls_FileImport : String;
begin
  if not FormActivated Then Exit;
  ls_FileImport := {$IFDEF FPC}Value{$ELSE}fne_import.Text{$ENDIF};
  if not DirectoryExistsUTF8(ls_FileImport) { *Converted from DirectoryExistsUTF8*  }
    and FileExistsUTF8(ls_FileImport) { *Converted from FileExistsUTF8*  } Then
  Begin
   FreeAndNil(FIniFile);
    try
      FIniFile:=TIniFile.Create(ls_FileImport);
      DoAfterInit;
      FreeAndNil(FIniFile);
      f_GetMainMemIniFile(nil,nil,nil,False,CST_AncestroWeb);
      OnFormInfoIni.p_ExecuteEcriture(Self);
    Except
      On E:Exception do
        MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_cantOpenFile ) +CST_ENDOFLINE+e.Message);
    end;
  end;
end;

// procedure TF_AncestroWeb.FWEraseImage3Click
// filename's edit erase's button event
procedure TF_AncestroWeb.FWEraseImage3Click(Sender: TObject);
begin
  p_ImageEditErase(ImageEdit3);
end;

// procedure TF_AncestroWeb.FWEraseImage2Click
// filename's edit erase's button event
procedure TF_AncestroWeb.FWEraseImage2Click(Sender: TObject);
begin
  p_ImageEditErase(ImageEdit2);
end;

// procedure TF_AncestroWeb.FWEraseImageClick
// filename's edit erase's button event
procedure TF_AncestroWeb.FWEraseImageClick(Sender: TObject);
begin
  p_ImageEditErase(ImageEdit1);
end;

procedure TF_AncestroWeb.FWPreview1Click(Sender: TObject);
begin
  p_OpenFileOrDirectory(de_ExportWeb.Directory);
end;

// procedure TF_AncestroWeb.ImageEdit2Change
// filename's edit change event
procedure TF_AncestroWeb.ImageEdit2Change(Sender: TObject);
begin
  p_ImageEditChange(ExtImage2, Sender);

end;
// procedure TF_AncestroWeb.ImageEdit3Change
// filename's edit change event

procedure TF_AncestroWeb.ImageEdit3Change(Sender: TObject);
begin
  p_ImageEditChange(ExtImage3, Sender);

end;
// procedure TF_AncestroWeb.ImageEdit1Change
// filename's edit change event
procedure TF_AncestroWeb.ImageEdit1Change(Sender: TObject);
begin
  p_ImageEditChange(ExtImage1, Sender);
end;

// procedure TF_AncestroWeb.p_ImageEditChange
// setting image from Filename edit
procedure TF_AncestroWeb.p_ImageEditChange(const aei_Image: TExtImage;
  const Sender: TObject);
var
  ls_FileName: string;
begin
  ls_FileName := (Sender as TFileNameEdit).FileName;
  if not DirectoryExistsUTF8(ls_FileName) { *Converted from DirectoryExistsUTF8*  } and FileExistsUTF8(ls_FileName) { *Converted from FileExistsUTF8*  }
    then aei_Image.LoadFromFile(ls_FileName)
    else aei_Image.Picture.Assign(nil);
end;

// function TF_AncestroWeb.fi_ImageEditCount
// Progress bar counter increment
function TF_AncestroWeb.fi_ImageEditCount(const as_FileName: string): integer;
begin
  if not DirectoryExistsUTF8(as_FileName) { *Converted from DirectoryExistsUTF8*  } and FileExistsUTF8(as_FileName) { *Converted from FileExistsUTF8*  }
    then Result := 1
    else Result := 0;
end;

// procedure TF_AncestroWeb.p_ImageEditErase
// Generic Image's edit erasing
procedure TF_AncestroWeb.p_ImageEditErase(const afne_EditImage: TFileNameEdit);
begin
  afne_EditImage.FileName := '';
end;

// procedure TF_AncestroWeb.FormClose
// Freeing on close
procedure TF_AncestroWeb.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  p_FreeProperties;
  p_FreeKeyWords;
end;

// procedure TF_AncestroWeb.bt_genClick
// Main Web Site Generation
procedure TF_AncestroWeb.bt_genClick(Sender: TObject);
begin
  //  verifying
  if not IBQ_Individu.Active Then
  begin
    MyShowMessage(fs_getCorrectString ( gs_ANCESTROWEB_BaseNotOpened ));
    Exit;
  end;
  if length(de_ExportWeb.Directory) < 6 then
  begin
    MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_ExportMoreThan5Chars));
    Exit;
  end;
  if (cb_Files.Items.Count = 0) then
  begin
    MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_ErrorFiles ) + gs_Root + CST_SUBDIR_SOURCES);
    Exit;
  end;
  if gb_Generate then
   Exit;
  if (cb_Files.ItemIndex = -1) then
    cb_Files.ItemIndex := 0;
  gs_html_source_file := CST_SUBDIR_SOURCES+DirectorySeparator+cb_files.Items[cb_files.ItemIndex]+DirectorySeparator;
  if not fb_LoadProperties(gs_Root + gs_html_source_file,
    UTF8LowerCase(CST_AncestroWeb), gs_Lang, True)
  or IBQ_Individu.IsEmpty
   Then
    Exit;
  gb_Generate := True;
  try // starting work

    // going to work for a time : freezing options to protect work and options
    ts_needed .Enabled:=False;
    ts_options.Enabled:=False;
    Pa_filter .Enabled:=False;
    pa_base   .Enabled:=False;
    if not ch_Filtered.Checked Then
     ch_ancestors.Checked:=True;
    IBQ_Individu.DisableControls;
    p_CreateKeyWords;
    gs_RootPathForExport := de_ExportWeb.{$IFDEF FPC}Directory{$ELSE}Text{$ENDIF} + DirectorySeparator;
    pb_ProgressAll.Position := 0;
    pb_ProgressInd.Position := 0; // initing not needed user value
    pb_ProgressAll.Max := CST_PROGRESS_COUNTER_COPY + CST_PROGRESS_COUNTER_TITLE + fi_CreateSheets;
    p_CopyStructure;
    p_genHTMLTitle;
    p_genHtmlHome;
    if ch_Filtered.Checked then
    begin
      with DmWeb do
       if ch_ancestors.Checked Then
        Begin
          if fb_OpenTree(IBQ_TreeBysurnames, gi_CleFiche )
             then
               Begin
                p_createLettersSheets( gt_SheetsLetters, IBQ_TreeBysurnames, gi_FilesPerPage, ed_FileBeginName.Text);
                p_clonePersonVerify ( IBQ_TreeBysurnames );
               end;
        end
       Else
        Begin
         if fb_OpenTree(IBQ_TreeDescBysurnames, gi_CleFiche ) then
           Begin
             p_createLettersSheets( gt_SheetsLetters, IBQ_TreeDescBysurnames, gi_FilesPerPage, ed_FileBeginName.Text);
             p_clonePersonVerify ( IBQ_TreeDescBySurnames );
           end;
        end;
    end
    else
     Begin
      IBQ_Individu.First;
      p_createLettersSheets( gt_SheetsLetters, IBQ_Individu, gi_FilesPerPage, ed_FileBeginName.Text);
     end;

    if ch_genTree.Checked then
      if ch_ancestors.Checked
       Then p_genHTMLTree ( DMWeb.IBQ_TreeAsc , ch_SplittedTree.Checked, sp_gentree.Value )
       Else p_genHTMLTree ( DMWeb.IBQ_TreeDesc, ch_SplittedTree.Checked, sp_gentree.Value );
    if ch_genages.Checked then
      p_genHtmlAges;
    if ch_genjobs.Checked then
      p_genHtmlJobs;
    if ch_genSearch.Checked then
      p_genHtmlSearch;
    if ch_Filtered.Checked
    then
      begin
        if ch_ancestors.Checked
          Then p_genHtmlFiles(DmWeb.IBQ_TreeBySurnames)
          Else p_genHtmlFiles(DmWeb.IBQ_TreeDescBySurnames);
      end
    else p_genHtmlFiles(IBQ_Individu);

    if ch_genSurnames.Checked then
    with DmWeb do
     begin
      if ch_Filtered.Checked
      then
        Begin
         if ch_ancestors.Checked Then
           Begin
             if fb_OpenTree(IBS_TreeSurnames,gi_CleFiche) Then
               p_genHtmlSurnames(IBS_TreeSurnames,IBQ_TreeBysurnames);
           end
          else
           Begin
             if fb_OpenTree(IBS_TreeSurnamesDesc, gi_CleFiche) Then
               p_genHtmlSurnames(IBS_TreeSurnamesDesc, IBQ_TreedescBysurnames);
           end;
       end
      else
       try
         IBS_Surnames.Close;
         IBS_Surnames.ParamByName(I_DOSSIER).AsInteger:=CleDossier;
         IBS_Surnames.ExecQuery;
         p_genHtmlSurnames(IBS_Surnames,IBQ_Individu); // ibq_individu in this form
       Except
         on E : Exception do
           Begin
            MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Surnames + '(' + IntToStr ( CleDossier ) + ')' + #13#10 + #13#10 + fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData ) + sDataBaseName + CST_ENDOFLINE + E.Message);
            Exit;
           End;
       End;
     end;
    if ch_genContact.Checked then
      p_genPhpContact;
    if assigned ( gDat_Existing_Persons ) Then
      gDat_Existing_Persons.Close ;
    p_Setcomments ( gs_AnceSTROWEB_Finished ); // finished for user
  finally
    Pa_filter .Enabled:=True;
    pa_base   .Enabled:=True;
    ts_needed .Enabled:=True;
    ts_options.Enabled:=True;
    gDat_Existing_Persons.Free;
    gDat_Existing_Persons := nil;
    IBQ_Individu.Locate(IBQ_CLE_FICHE, fCleFiche, []);
    IBQ_Individu.EnableControls;
    Finalize(gt_SheetsMapGroup);
    Finalize(gt_SheetsLetters);
    Finalize(gt_TabSheets);
    Finalize(gt_Surnames);
    gb_Generate := False;
  end;
end;

// procedure TF_AncestroWeb.cbDossierChange
// database's folder change event
procedure TF_AncestroWeb.cbDossierChange(Sender: TObject);
var
  NumDossier:integer;
begin
  NumDossier:=StrToInt(trim(copy(cbDossier.Text,1,2)));
  if NumDossier<>DMWeb.CleDossier then
    if OuvreDossier(NumDossier) then
    begin
      fNom_Dossier:=fs_getCorrectString(copy(cbDossier.Text,5,250));
      DoAfterInit;
    end;
end;

// procedure TF_AncestroWeb.bt_exportClick
// Export ini click event
procedure TF_AncestroWeb.bt_exportClick(Sender: TObject);
begin
  f_GetMainMemIniFile(nil,nil,nil,False,CST_AncestroWeb);
  OnFormInfoIni.p_ExecuteEcriture(Self);
  if fb_iniWriteFile(FIniFile,True)
   Then
     try
       FileCopy.Destination:=fne_Export.FileName;
       FileCopy.Source:=FIniFile.FileName;
       FileCopy.CopySourceToDestination;
     Except
       On E:Exception do
         MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_cantSaveFile )+CST_ENDOFLINE+e.Message);
     end;
end;

// procedure TF_AncestroWeb.btnSelectBaseClick
// Database select on button's click event
procedure TF_AncestroWeb.btnSelectBaseClick(Sender: TObject);
begin
  with dm.OpenFirebird do
   Begin
    FileName:='';
    //préparation de la boite mOpenDialog
    if DirectoryExistsUTF8(cb_Base.Text) then
    begin
      InitialDir:=cb_Base.Text;
    end
    else
    begin
      if DirectoryExistsUTF8(ExtractFilePath(cb_Base.Text)) then
      begin
        InitialDir:=ExtractFilePath(cb_Base.Text);
        if FileExistsUTF8(cb_Base.Text) then
          FileName:=cb_Base.Text;
      end;
    end;

    if Execute then
    begin
      p_AddToCombo(cb_base,FileName);
      p_writeComboBoxItems(cb_Base,cb_Base.Items);
      p_BaseOpen;
      p_setBaseToIniFile(FileName);
    end;
   end;
end;

// procedure TF_AncestroWeb.ch_FilteredClick
// "Filter from name" checkbox click event
procedure TF_AncestroWeb.ch_FilteredClick(Sender: TObject);
begin
  p_iniWriteKey;
end;

// function TF_AncestroWeb.fi_CreateSheets
// creating sheets from external options
// setting the main Position bar total
function TF_AncestroWeb.fi_CreateSheets: integer;

  procedure p_setCorrectFileName(const aed_NameFile: TEdit;
  const as_NameFile: string);
  begin
    if aed_NameFile.Text = '' then
      aed_NameFile.Text := as_NameFile;
  end;

begin
  Result := CST_PROGRESS_COUNTER_HOME+fi_ImageEditCount(ImageEdit1.FileName)+fi_ImageEditCount(ImageEdit2.FileName)+fi_ImageEditCount(ImageEdit3.FileName);
  Finalize(gt_TabSheets);
  p_setCorrectFileName(ed_IndexName, CST_FILE_Home);
  p_AddTabSheet(gt_TabSheets, gs_AnceSTROWEB_Home, ed_IndexName.Text +
    CST_EXTENSION_HTML);
  if ch_genTree.Checked then
  begin
    p_setCorrectFileName(ed_TreeName, CST_FILE_TREE);
    if ch_SplittedTree.Checked
     then
      Begin
       p_AddTabSheet(gt_TabSheets, ( gs_AnceSTROWEB_FullTree ), CST_FILE_TREE +
           DirectorySeparator + ed_TreeName.Text + '0' + CST_EXTENSION_HTML);
       Inc ( Result, sp_gentree.Value );
      end
     else
      Begin
        p_AddTabSheet(gt_TabSheets, ( gs_AnceSTROWEB_FullTree ), CST_FILE_TREE +
           DirectorySeparator + ed_TreeName.Text + CST_EXTENSION_HTML);
        Inc(Result, CST_PROGRESS_COUNTER_TREE);
      end;
  end;
  if ch_genSurnames.Checked then
  begin
    Inc(Result, CST_PROGRESS_COUNTER_Surnames);
    p_setCorrectFileName(ed_SurnamesFileName, CST_FILE_Surnames);
    p_AddTabSheet(gt_TabSheets, ( gs_AnceSTROWEB_Surnames ), ed_SurnamesFileName.Text + CST_EXTENSION_HTML);
    if ch_genMap.Checked then
    begin
      p_setCorrectFileName(ed_MapFileName, CST_FILE_MAP);
      if ch_SplittedMap.Checked
       Then
        Begin
         p_AddTabSheet(gt_TabSheets, ( gs_ANCESTROWEB_Map ), ed_MapFileName.Text + '0' + CST_EXTENSION_HTML);
         inc ( Result, sp_groupMap.value );
        end
       Else
        Begin
          p_AddTabSheet(gt_TabSheets, ( gs_ANCESTROWEB_Map ), ed_MapFileName.Text +       CST_EXTENSION_HTML);
          Inc(Result, CST_PROGRESS_COUNTER_MAP);
        end;
    end;
  end;
  Inc(Result, CST_PROGRESS_COUNTER_FILES+CST_PROGRESS_COUNTER_LIST);
  p_setCorrectFileName(ed_FileBeginName, CST_FILE_FILES);
  p_setCorrectFileName(ed_ListsBeginName, CST_FILE_LIST);
  p_AddTabSheet(gt_TabSheets, ( gs_AnceSTROWEB_List ), CST_SUBDIR_HTML_LISTS + '/' + ed_ListsBeginName.Text + '0' + CST_EXTENSION_HTML);
  if ch_ShowMainFile.Checked Then
    p_AddTabSheet(gt_TabSheets, ( gs_AnceSTROWEB_Files ), ed_FileBeginName.Text +       CST_EXTENSION_HTML);
  if ch_genages.Checked then
  begin
    Inc(Result, CST_PROGRESS_COUNTER_AGES);
    p_setCorrectFileName(ed_AgesName, CST_FILE_AGES);
    p_AddTabSheet(gt_TabSheets, ( gs_ANCESTROWEB_Ages ), ed_AgesName.Text + CST_EXTENSION_HTML);
  end;
  if ch_genjobs.Checked then
  begin
    Inc(Result, CST_PROGRESS_COUNTER_JOBS);
    p_setCorrectFileName(ed_JobsName, CST_FILE_JOBS);
    p_AddTabSheet(gt_TabSheets, ( gs_ANCESTROWEB_Jobs ), ed_JobsName.Text + CST_EXTENSION_HTML);
  end;
  if ch_genSearch.Checked then
  begin
    Inc(Result, CST_PROGRESS_COUNTER_SEARCH);
    p_setCorrectFileName(ed_SearchName, CST_FILE_SEARCH);
    p_AddTabSheet(gt_TabSheets, ( gs_ANCESTROWEB_Search ), ed_SearchName.Text + CST_EXTENSION_HTML);
  end;
  if ch_genContact.Checked then
  begin
    Inc(Result, CST_PROGRESS_COUNTER_CONTACT);
    p_setCorrectFileName(ed_ContactName, CST_FILE_Contact);
    p_AddTabSheet(gt_TabSheets, ( gs_AnceSTROWEB_Contact ),
      ed_ContactName.Text + CST_EXTENSION_PHP);
  end;
end;

// procedure TF_AncestroWeb.p_CopyStructure
// Copy default structure from options
procedure TF_AncestroWeb.p_CopyStructure;
var
  ls_Destination: string;
  lt_arg : array [0..0] of string;
begin
  with dm.FileCopy do
   Begin
    Destination := gs_RootPathForExport;
    ls_Destination := Destination;
   end;
  if DirectoryExistsUTF8(ls_Destination ) { *Converted from DirectoryExistsUTF8*  } Then
   Begin
    lt_arg [0] := ls_Destination;
    if ( MyMessageDlg(fs_RemplaceMsg(gs_ANCESTROWEB_ExportDelete, lt_arg), mtWarning, mbYesNo) = mrYes ) then
      try
        DeleteDirUTF8(ls_Destination, ddoDeleteFirstFiles);
        DeleteDirUTF8(ls_Destination + CST_SUBDIR_HTML_CSS, ddoDeleteAll);
        DeleteDirUTF8(ls_Destination + CST_SUBDIR_HTML_IMAGES, ddoDeleteAll );
        DeleteDirUTF8(ls_Destination + CST_SUBDIR_HTML_LISTS , ddoDeleteAll );
        DeleteDirUTF8(ls_Destination + CST_SUBDIR_HTML_MAILER, ddoDeleteAll );
        DeleteDirUTF8(ls_Destination + CST_SUBDIR_HTML_SCRIPTS, ddoDeleteAll );
        DeleteDirUTF8(ls_Destination + CST_SUBDIR_HTML_ARCHIVE, ddoDeleteAll );
        DeleteDirUTF8(ls_Destination + CST_SUBDIR_HTML_FILES, ddoDeleteAll );
        DeleteDirUTF8(ls_Destination + CST_SUBDIR_HTML_MAPS, ddoDeleteAll );
        DeleteDirUTF8(ls_Destination+ CST_SUBDIR_HTML_TREE, ddoDeleteAll );
      except
        on E: Exception do
        begin
          MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_ExportErrorErase ) + ls_Destination + CST_ENDOFLINE + E.Message);
          Abort;
        end;
      end
    Else
     Abort;
    End;
  p_IncProgressBar;   // growing the counter
  if (cb_Themes.Items.Count = 0) then
  begin
    MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_ErrorThemes ) + gs_Root + CST_SUBDIR_THEMES);
    Abort;
  end;
  if (cb_Themes.ItemIndex = -1) then
    cb_Themes.ItemIndex := 0;
  with dm.FileCopy do
   try
    FileOptions:=FileOptions-[cpDestinationIsFile];
    if DirectoryExistsUTF8(fSoftUserPath + CST_SUBDIR_THEMES +DirectorySeparator+cb_Themes.Items[cb_Themes.ItemIndex])
     Then Source := fSoftUserPath + CST_SUBDIR_THEMES +DirectorySeparator+cb_Themes.Items[cb_Themes.ItemIndex]
     Else Source := gs_Root + CST_SUBDIR_THEMES +DirectorySeparator+cb_Themes.Items[cb_Themes.ItemIndex];
    Destination := gs_RootPathForExport;
    CopySourceToDestination;
    Source := gs_Root + CST_SUBDIR_CLASSES;
    CopySourceToDestination;
    if fi_ImageEditCount(GedcomEdit.FileName) > 0 then
    begin
      Source := GedcomEdit.FileName;
      CopySourceToDestination;
      gs_LinkGedcom := ExtractFileName(GedcomEdit.FileName);
    end
    else
      gs_LinkGedcom := '';
  finally
    FileOptions:=FileOptions+[cpDestinationIsFile];
   end;
end;

// procedure TF_AncestroWeb.p_IncProgressBar
// increments main Position bar
procedure TF_AncestroWeb.p_IncProgressBar;
begin
  pb_ProgressAll.Position := pb_ProgressAll.Position + 1; // growing
  Application.ProcessMessages;
end;

// procedure TF_AncestroWeb.p_IncProgressInd
// increments specialized Position bar
procedure TF_AncestroWeb.p_IncProgressInd;
begin
  pb_ProgressInd.Position := pb_ProgressInd.Position + 1; // growing
  Application.ProcessMessages;
end;

// function TF_AncestroWeb.fs_GetTitleTree
// Title of HTML trees
function TF_AncestroWeb.fs_GetTitleTree ( const as_NameOfTree : String ; const ai_generations : Longint ): String;
Begin
  Result := as_NameOfTree + ' (' + IntToStr(ai_generations) ;
  if ai_generations <= 1
    Then AppendStr(Result, ( gs_AnceSTROWEB_Generation  ) + ')')
    Else AppendStr(Result, ( gs_AnceSTROWEB_Generations ) + ')');
end;

// procedure TF_AncestroWeb.p_CreateHTMLTree
// Création de l'arbre dans une TStringlistUTF8 puis Sauvegarde
function TF_AncestroWeb.fi_CreateHTMLTree(const IBQ_Tree: TIBQuery;
  const astl_HTMLTree: TStrings;
  const ai_Clefiche: longint;
  const ab_Div: boolean = True;
  const ab_Link: boolean = True;
  const ab_Progress: boolean = True;
  const ab_NotFirst: boolean = False;
  const as_IdSosa: string = IBQ_TQ_SOSA;
  const ab_Asc: boolean = True): longint;
var
  li_LocalLevel, li_LevelOrigin, li_LocalPreLevel, li_Clefiche: integer;
  ls_Tempo, ls_Barres, ls_NodeLink, ls_NameSurname, ls_Image: string;
  lb_foundARecord : Boolean;

  function fs_getText: string;
  begin
    Result := '';
    with IBQ_Tree do
      Begin
        if not FieldByName(IBQ_DATE_NAISSANCE).IsNull
        and fb_ShowYear(FieldByName(IBQ_ANNEE_NAISSANCE).AsInteger,FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger)  then
          AppendStr(Result, ' ' + fs_Create_Image ( '..'+CST_HTML_DIR_SEPARATOR+CST_SUBDIR_HTML_IMAGES+CST_HTML_DIR_SEPARATOR+CST_FILE_BIRTH, gs_AnceSTROWEB_EXPORT_WEB_BORN ) +
          ' ' + FieldByName( IBQ_DATE_NAISSANCE).AsString);
        if not FieldByName(IBQ_DATE_DECES).IsNull
        and fb_ShowYear(FieldByName(IBQ_ANNEE_DECES).AsInteger,FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger)  then
          AppendStr(Result, ' ' + fs_Create_Image ( '..'+CST_HTML_DIR_SEPARATOR+CST_SUBDIR_HTML_IMAGES+CST_HTML_DIR_SEPARATOR+CST_FILE_DEATH, gs_AnceSTROWEB_EXPORT_WEB_DIED ) +
            ' ' + FieldByName(IBQ_DATE_DECES).AsString);
        if not FieldByName(IBQ_AGE_AU_DECES).IsNull then
          AppendStr(Result, fs_AddComma( FieldByName(IBQ_AGE_AU_DECES).AsString + gs_AnceSTROWEB_Years ));
        AppendStr(Result, fs_AddComma(FieldByName( as_idSosa   ).AsString ));
        p_addKeyWord(FieldByName(IBQ_NOM).AsString, '-'); // adding a head's meta keyword
        p_addKeyWord(FieldByName(IBQ_PRENOM).AsString); // adding a head's meta keyword
      end;
  end;


  procedure p_AddLine ( const ai_Key : Longint ; const ab_IsTheEnd, ab_OldNext, ab_IsFirst : boolean );
  Begin
    if not ch_Filtered.Checked
    or ( ab_IsFirst )
    or ( ab_Asc = ch_ancestors.Checked )
    or fb_IsCreatedPerson(ai_Key)
    Then
      Begin
        if ab_Link
         Then ls_Image := fs_GetNameLink ( fs_RemplaceEspace ( ls_NameSurname, '_' ),IntToStr(ai_key),ls_Image, '../' + CST_SUBDIR_HTML_FILES + CST_HTML_DIR_SEPARATOR )
         else ls_Image := fs_GetNameLink ( fs_RemplaceEspace ( ls_NameSurname, '_' ),IntToStr(ai_key),ls_Image );
      end;
    p_setEndLine(ls_Tempo, ls_Image, ls_NodeLink, ab_OldNext,
      ab_IsTheEnd, li_LocalPreLevel, li_LocalLevel, ab_Link, ab_div);

    astl_HTMLTree.Add(ls_Tempo);
  end;

  procedure p_CreateChilds(const af_Sosa: double; const as_Aboville: string; const ab_HasNext, ab_OldNext, ab_IsFirst, ab_IsSecond, ab_IsSisBrother: boolean );
  var
    li_Sexe : integer;
    lf_SosaPere, lf_SosaMere, lf_NewSosa: double;
    ls_newAboville: string;
  begin
   with IBQ_Tree do
    if (ab_Asc and Locate(as_IdSosa, af_Sosa, [])) or
      (not ab_Asc and Locate(as_IdSosa, as_Aboville, [])) then
    begin
      if not ab_NotFirst
      or not ab_IsFirst
      or ab_IsSecond
       Then
        Begin
          li_LocalPreLevel := li_LocalLevel;
          li_LocalLevel := abs(FieldByName(IBQ_NIVEAU).AsInteger)-li_levelOrigin;
          if ab_NotFirst then
            Dec(li_LocalLevel);
          if ( li_LocalLevel > Result )
           Then
            Result := li_LocalLevel;

          lb_foundARecord := True;
          if li_LocalPreLevel <> -1 then
            p_AddLine ( li_Clefiche, False, ab_OldNext, ab_IsFirst or ab_IsSecond );

          li_Clefiche := FieldByName(IBQ_CLE_FICHE).AsInteger;
          if ab_Progress then
            p_IncProgressInd; // growing the second counter
          // Nommage des noeuds
          if li_LocalPreLevel <> li_LocalLevel Then  // a div by level
            ls_NodeLink := fs_GetNodeLink(ls_NodeLink, li_LocalLevel);

          // Création du début de Division
          p_setLevel(astl_HTMLTree, ls_NodeLink, ab_IsFirst or ab_IsSecond and ab_NotFirst, li_LocalLevel, li_LocalPreLevel, ab_div);

          li_Sexe := FieldByName(IBQ_SEXE).AsInteger;

          ls_NameSurname:=fs_getNameAndSurName(IBQ_Tree);

          ls_Image := ls_NameSurname +  fs_getText;
          ls_Barres := fs_NewLineImages(ls_Barres, ab_HasNext, li_LocalLevel);
          ls_Tempo := fs_CreateLineImages(ls_Barres, li_LocalLevel);
          case li_sexe of
            IBQ_SEXE_MAN   : ls_Image := fs_Create_Tree_Image('g' + CST_TREE_GIF_EXT) + ls_Image;
            IBQ_SEXE_WOMAN : ls_Image := fs_Create_Tree_Image('f' + CST_TREE_GIF_EXT) + ls_Image;
          end;
        end;
      lf_NewSosa := 0;
      if ab_Asc then
      begin    // next parents
        lf_SosaPere := af_Sosa * 2;
        lf_SosaMere := af_Sosa * 2 + 1;
        p_CreateChilds(lf_SosaPere, as_aboville, Locate(
          as_IdSosa, lf_SosaMere, []), ab_HasNext, False, ab_IsFirst, False );
        p_CreateChilds(lf_SosaMere, as_aboville, False, ab_HasNext, False, False, False );
      end
      else
      begin
        Next;  // next record for next tests
        ls_newAboville :=
          copy(as_aboville, 1, Length(as_aboville) - 1) + chr(
          Ord(as_aboville[Length(as_aboville)]) + 1);
        if FieldByName(as_IdSosa).AsString = ls_newAboville then // next record of sister or brother
        begin
          p_CreateChilds(lf_NewSosa, ls_newAboville,
            Locate(as_IdSosa,copy(ls_newAboville, 1, Length(ls_newAboville) - 1) + chr(Ord(ls_newAboville[Length(ls_newAboville)]) + 1),[]),
            ab_HasNext, False, False, True );
        end
        else
        begin
          ls_newAboville := as_aboville + '1';
          if FieldByName(as_IdSosa).AsString = ls_newAboville then  // next record of childs
            begin
              p_CreateChilds(lf_NewSosa, ls_newAboville,
                 Locate(as_IdSosa,copy(ls_newAboville, 1, Length(ls_newAboville) - 1) + chr(Ord(ls_newAboville[Length(ls_newAboville)]) + 1),[]),
                 ab_HasNext, False, ab_IsFirst, False );
              // verify if there is another sister or brother
              ls_newAboville :=
                copy(as_aboville, 1, length ( as_Aboville ) - 1) + chr(
                Ord(as_aboville[length ( as_Aboville )]) + 1);
              if Locate(as_IdSosa,ls_newAboville,[]) then
              begin
                p_CreateChilds(lf_NewSosa, ls_newAboville,
                  Locate(as_IdSosa,copy(ls_newAboville, 1, Length(ls_newAboville) - 1) + chr(Ord(ls_newAboville[Length(ls_newAboville)]) + 1),[]),
                  ab_HasNext, False, False, True );
              end
           End;
        end;
      end;
    end;
  end;

begin
  li_LocalLevel := -1;
  Result := -1;
  ls_NodeLink := '';
  ls_Tempo := '';
  ls_NameSurname := '';
  ls_Image  := '';
  gs_HTMLTreeNodeLink := '';
  ls_Barres := '';
  With IBQ_Tree do
    try
     if ab_Progress Then
      Begin
        pb_ProgressInd.Position:=0;
        pb_ProgressInd.Max:=RecordCount;
      end;
      // first node
      Locate(IBQ_CLE_FICHE, ai_Clefiche, []);
      li_LevelOrigin := abs(FieldByName(IBQ_NIVEAU).AsInteger);
  //    if ( li_levelOrigin > 0 ) then
  //     dec ( li_levelOrigin );
      li_Clefiche:=ai_Clefiche;
      lb_foundARecord := False;
      // create the tree
      p_CreateChilds(FieldByName(as_IdSosa).AsFloat,
        FieldByName(as_IdSosa).AsString, False, False, True, False, False);
      if lb_foundARecord then
        p_AddLine ( li_Clefiche, True, False, False );
    except
      On E: Exception do
        MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_cantCreateATree ) + CST_ENDOFLINE + E.Message);
    end;
  Inc(Result);

end;

// procedure TF_AncestroWeb.p_genHTMLTitle
// HTML Main title
procedure TF_AncestroWeb.p_genHTMLTitle;
var
  li_ClePere, li_CleMere: integer;
  gf_Sosa: double;
begin
  p_IncProgressBar; // growing the counter
  if ch_Filtered.Checked then
    gi_CleFiche := fCleFiche
  else
  begin
    gf_Sosa := 1;
    if IBQ_Individu.Locate(IBQ_SOSA, gf_Sosa, []) then
      gi_CleFiche := IBQ_Individu.FieldByName(IBQ_CLE_FICHE).AsInteger
    else
    begin
      MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_ErrorCreateSOSA ));
      Abort;
    end;
  end;

  gs_HTMLTitle := '';
  if IBQ_Individu.Locate(IBQ_CLE_FICHE, gi_CleFiche, []) then
  begin //AL il serait préférable de laisser le titre à l'initiative de l'utilisateur! Ce n'est pas forcément les noms du père et de la mère de l'individu sélectionner, surtout s'il n'y a pas de filtrage
    li_ClePere := IBQ_Individu.FieldByName(IBQ_CLE_PERE).AsInteger;
    li_CleMere := IBQ_Individu.FieldByName(IBQ_CLE_MERE).AsInteger;
    if IBQ_Individu.Locate(IBQ_CLE_FICHE, li_ClePere, []) then
      AppendStr(gs_HTMLTitle, ' ' + IBQ_Individu.FieldByName(IBQ_NOM).AsString);
    if IBQ_Individu.Locate(IBQ_CLE_FICHE, li_CleMere, []) then
      AppendStr(gs_HTMLTitle, ' & ' + IBQ_Individu.FieldByName(IBQ_NOM).AsString);
  end;
  gs_HTMLTitle := StringReplace( ( gs_AnceSTROWEB_HTMLTitle ), '@ARG',
    gs_HTMLTitle, [rfReplaceAll]);
end;

// function TF_AncestroWeb.fb_OpenTree
// open a tree from parameters
function TF_AncestroWeb.fb_OpenTree(const AIBQ_Tree: TIBQuery;
  const ai_Cle: longint; const ai_Niveau: integer = 0;
  const ai_Sexe: integer = 0): boolean;
begin
  Result := False;
  with AIBQ_Tree.Params do
    try
      AIBQ_Tree.Close;
      ParamByName(I_CLEF).AsInteger := ai_Cle;
      ParamByName(I_NIVEAU).AsInteger := ai_Niveau;
      if (FindParam(I_PARQUI) <> nil) Then
        ParamByName(I_PARQUI).AsInteger := ai_Sexe;
      if (FindParam(I_DOSSIER) <> nil) Then
        ParamByName(I_DOSSIER).AsInteger := DMWeb.CleDossier;
      AIBQ_Tree.Open;
      Result := not AIBQ_Tree.IsEmpty;
    except
      On E: Exception do
        MyShowMessage( gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_FullTree + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData ) + sDataBaseName + CST_ENDOFLINE + E.Message);
    end;
end;

// function TF_AncestroWeb.fb_OpenTree
// open a tree from parameters
function TF_AncestroWeb.fb_OpenTree(const AIBQ_Tree: TIBSQL;
  const ai_Cle: longint; const ai_Niveau: integer = 0;
  const ai_Sexe: integer = 0): boolean;
begin
  Result := False;
  with AIBQ_Tree do
    try
      Close;
      ParamByName(I_CLEF).AsInteger := ai_Cle;
      ParamByName(I_NIVEAU).AsInteger := ai_Niveau;
      ParamByName(I_PARQUI).AsInteger := ai_Sexe;
      ExecQuery;
      Result := not Eof;
    except
      On E: Exception do
        MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_FullTree + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData ) + sDataBaseName + CST_ENDOFLINE + E.Message);
    end;
end;

// procedure TF_AncestroWeb.p_genHTMLTree
// creating the main interactive HTML Tree
procedure TF_AncestroWeb.p_genHTMLTree ( const IBQ_tree : TIBQuery ; const ab_Splitted : Boolean ; const ai_generationSplitted : Integer  );
var
  lstl_HTMLTree, lstl_HTMLTree2: TStringlistUTF8;
  ls_destination,ls_idSosa: string;
  li_counter   : longint;
  lt_SheetsGen : TAHTMLULTabSheet;
  procedure p_CreateSheets(const ai_generation : Integer ; const af_Sosa: double ; const as_aboville : String );
  var
    lf_SosaPere, lf_SosaMere: double;
    ls_newAboville: string;
    ls_ancestry: string;
    procedure p_CreateAscSheet;
    var
      li_i : integer;
    Begin
      with IBQ_tree do
        case ai_generation of
          1 : Begin
                if trunc(af_Sosa) mod 2 = 0
                 Then p_AddTabSheet(lt_SheetsGen, fs_RemplaceMsg(gs_ANCESTROWEB_Father, [FieldByName(IBQ_NOM).AsString]),
                        ed_TreeName.Text + IntToStr(li_counter) + CST_EXTENSION_HTML, FieldByName(IBQ_CLE_FICHE).AsString )
                 Else p_AddTabSheet(lt_SheetsGen, fs_RemplaceMsg(gs_ANCESTROWEB_Mother, [FieldByName(IBQ_NOM).AsString]),
                        ed_TreeName.Text + IntToStr(li_counter) + CST_EXTENSION_HTML, FieldByName(IBQ_CLE_FICHE).AsString );
              End;
          2 : Begin
                if trunc(af_Sosa) mod 2 = 0
                 Then p_AddTabSheet(lt_SheetsGen, fs_RemplaceMsg(gs_ANCESTROWEB_Old_Father, [FieldByName(IBQ_NOM).AsString,IntToStr(trunc(af_Sosa))]),
                        ed_TreeName.Text + IntToStr(li_counter) + CST_EXTENSION_HTML, FieldByName(IBQ_CLE_FICHE).AsString )
                 Else p_AddTabSheet(lt_SheetsGen, fs_RemplaceMsg(gs_ANCESTROWEB_Old_Mother, [FieldByName(IBQ_NOM).AsString,IntToStr(trunc(af_Sosa))]),
                        ed_TreeName.Text + IntToStr(li_counter) + CST_EXTENSION_HTML, FieldByName(IBQ_CLE_FICHE).AsString );
              End;
          3 : Begin
                if trunc(af_Sosa) mod 2 = 0
                 Then p_AddTabSheet(lt_SheetsGen, fs_RemplaceMsg ( gs_ANCESTROWEB_Ancestry_Man, [fs_RemplaceMsg( gs_ANCESTROWEB_old_father_minus , [FieldByName(IBQ_NOM).AsString,IntToStr(trunc(af_Sosa))])]),
                        ed_TreeName.Text + IntToStr(li_counter) + CST_EXTENSION_HTML, FieldByName(IBQ_CLE_FICHE).AsString )
                 Else p_AddTabSheet(lt_SheetsGen, fs_RemplaceMsg ( gs_ANCESTROWEB_Ancestry_Woman, [fs_RemplaceMsg(gs_ANCESTROWEB_old_mother_minus, [FieldByName(IBQ_NOM).AsString,IntToStr(trunc(af_Sosa))])]),
                        ed_TreeName.Text + IntToStr(li_counter) + CST_EXTENSION_HTML, FieldByName(IBQ_CLE_FICHE).AsString );
              End;
          else
            Begin
              if trunc(af_Sosa) mod 2 = 0
               Then ls_ancestry := fs_RemplaceMsg( gs_ANCESTROWEB_old_father_minus , [FieldByName(IBQ_NOM).AsString,IntToStr(trunc(af_Sosa))])
               Else ls_ancestry := fs_RemplaceMsg( gs_ANCESTROWEB_old_mother_minus , [FieldByName(IBQ_NOM).AsString,IntToStr(trunc(af_Sosa))]);
              for li_i := 4 to ai_generation do
                if trunc(af_Sosa) mod 2 = 0
                 Then ls_ancestry := fs_RemplaceMsg( gs_ANCESTROWEB_ancestry_man_minus   , [ls_ancestry])
                 Else ls_ancestry := fs_RemplaceMsg( gs_ANCESTROWEB_ancestry_woman_minus , [ls_ancestry]);
              if trunc(af_Sosa) mod 2 = 0
               Then p_AddTabSheet(lt_SheetsGen, fs_RemplaceMsg ( gs_ANCESTROWEB_Ancestry_Man, [ls_ancestry]),
                      ed_TreeName.Text + IntToStr(li_counter) + CST_EXTENSION_HTML, FieldByName(IBQ_CLE_FICHE).AsString )
               Else p_AddTabSheet(lt_SheetsGen, fs_RemplaceMsg ( gs_ANCESTROWEB_Ancestry_Woman, [ls_ancestry]),
                      ed_TreeName.Text + IntToStr(li_counter) + CST_EXTENSION_HTML, FieldByName(IBQ_CLE_FICHE).AsString );
            End;
        End;
    End;
  begin
    with IBQ_Tree do
    if (ch_ancestors.Checked and Locate(ls_IdSosa, af_Sosa, [])) or
      (not ch_ancestors.Checked and Locate(ls_IdSosa, as_Aboville, [])) then
        begin
          if ai_generation = ai_generationSplitted Then
           Begin
             if ch_ancestors.Checked then
              Begin
                p_CreateAscSheet;
              End
             Else
              Begin
                p_AddTabSheet(lt_SheetsGen, fs_RemplaceMsg ( gs_ANCESTROWEB_generation_child, [FieldByName(IBQ_NOM).AsString,IntToStr(trunc(af_Sosa)),FieldByName(IBQ_PRENOM).AsString]),
                                ed_TreeName.Text + IntToStr(li_counter) + CST_EXTENSION_HTML, FieldByName(IBQ_CLE_FICHE).AsString )
              End;
             inc (li_counter);
            End;
           if ch_ancestors.Checked then
            Begin
             if ai_generation < ai_generationSplitted Then
              begin    // next parents
                lf_SosaPere := af_Sosa * 2;
                lf_SosaMere := af_Sosa * 2 + 1;
                p_CreateSheets(ai_generation+1,lf_SosaPere, '' );
                p_CreateSheets(ai_generation+1,lf_SosaMere, '' );
              end;
            end
           else
            begin
              Next;  // next record for next tests
              ls_newAboville :=
                copy(as_aboville, 1, Length(as_aboville) - 1) + chr(
                Ord(as_aboville[Length(as_aboville)]) + 1);
              if FieldByName(ls_IdSosa).AsString = ls_newAboville then // next record of sister or brother
                p_CreateSheets(ai_generation,af_Sosa, ls_newAboville )
              else
                begin
                  ls_newAboville := as_aboville + '1';
                  if FieldByName(ls_IdSosa).AsString = ls_newAboville then  // next record of childs
                    begin
                     if ai_generation < ai_generationSplitted Then
                       p_CreateSheets(ai_generation+1,af_Sosa, ls_newAboville );
                      // verify if there is another sister or brother
                      ls_newAboville :=
                        copy(as_aboville, 1, length ( as_Aboville ) - 1) + chr(
                        Ord(as_aboville[length ( as_Aboville )]) + 1);
                      if Locate(ls_IdSosa,ls_newAboville,[]) then
                        p_CreateSheets(ai_generation,af_Sosa, ls_newAboville );
                   End;
                end;
            end;
       End;
  end;
  procedure p_prepareSplitted;
  var li_i : Integer;
  Begin
    if ab_Splitted Then
     Begin
       if ch_ancestors.Checked
        Then ls_idSosa := IBQ_TQ_SOSA
        Else ls_idSosa := IBQ_TQ_NUM_SOSA;
       lstl_HTMLTree2 := TStringlistUTF8.Create;
       li_counter := 0 ;
       if IBQ_Tree.Locate(IBQ_CLE_FICHE, gi_CleFiche, []) then
         p_CreateSheets ( 0, IBQ_tree.FieldByName(ls_IdSosa).AsFloat, IBQ_Tree.FieldByName(ls_IdSosa).AsString);
       lstl_HTMLTree.Text := fs_CreateULTabsheets(lt_SheetsGen,
         '', CST_HTML_SUBMENU)+CST_HTML_DIV_BEGIN;
       for li_i := 1 to sp_gentree.value - 1 do // why to do that ? do not know exactly
         lstl_HTMLTree.Add ( CST_HTML_BR + CST_HTML_BR );
       lstl_HTMLTree.Add ( CST_HTML_BR + CST_HTML_BR );
     end;

  end;
  var li_generation : Longint;
begin
  gs_TreeLetterBegin := chr(ord(CST_TREE_LETTER_BEGIN)-1);
  p_Setcomments ( gs_AnceSTROWEB_FamilyTree ); // advert for user
  lstl_HTMLTree := TStringlistUTF8.Create;
  lstl_HTMLTree2 := nil;
  p_ClearKeyWords;
  try
    if fb_OpenTree(IBQ_Tree, gi_CleFiche)
     then
      try
        p_prepareSplitted;
        pb_ProgressInd.Max := IBQ_Tree.RecordCount;
        if not ch_Filtered.Checked and not
          IBQ_Tree.Locate(IBQ_CLE_FICHE, gi_CleFiche, []) then
          Exit;
        if ab_Splitted Then
         Begin
           for li_counter := 0 to high ( lt_SheetsGen ) do
            Begin
              with lt_SheetsGen [ li_counter ] do
              if IBQ_Tree.Locate(IBQ_CLE_FICHE, StrToInt ( s_info ),[]) then
               if s_info > '' Then
               Begin
                 lstl_HTMLTree2.Text:='';
                 if ch_ancestors.Checked
                   Then li_generation := fi_CreateHTMLTree(IBQ_Tree, lstl_HTMLTree2, StrToInt ( s_info ),not cb_treeWithoutJavascript.Checked)
                   Else li_generation := fi_CreateHTMLTree(IBQ_Tree, lstl_HTMLTree2, StrToInt ( s_info ),not cb_treeWithoutJavascript.Checked,True,True,False,IBQ_TQ_NUM_SOSA,False);
                 lstl_HTMLTree2.Insert(0, fs_Format_Lines(me_HeadTree.Lines.Text));
                 lstl_HTMLTree2.Insert(0,lstl_HTMLTree.Text);
                 lstl_HTMLTree2.Add(CST_HTML_DIV_END);
                 p_CreateAHtmlFile(lstl_HTMLTree2, CST_SUBDIR_HTML_TREE, me_Description.Lines.Text,
                   ( gs_AnceSTROWEB_FamilyTree ), gs_AnceSTROWEB_FullTree, fs_GetTitleTree ( gs_AnceSTROWEB_Ancestry, li_generation), gs_LinkGedcom, '../');
                 ls_destination := gs_RootPathForExport +
                   CST_SUBDIR_HTML_TREE + DirectorySeparator + ed_TreeName.Text + IntToStr(li_counter) + CST_EXTENSION_HTML;
                 try
                   if fb_CreateDirectoryStructure(gs_RootPathForExport + CST_SUBDIR_HTML_TREE + DirectorySeparator) then
                     lstl_HTMLTree2.SaveToFile(ls_destination);
                 except
                   On E: Exception do
                   begin
                     MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_cantSaveTree ) + ls_destination + CST_ENDOFLINE + E.Message);
                     Abort;
                   end;
                 end;
               End;
              p_IncProgressBar;
            end;
         End
        else
         Begin
          if ch_ancestors.Checked
            Then li_generation := fi_CreateHTMLTree(IBQ_Tree, lstl_HTMLTree, gi_CleFiche,not cb_treeWithoutJavascript.Checked)
            Else li_generation := fi_CreateHTMLTree(IBQ_Tree, lstl_HTMLTree, gi_CleFiche,not cb_treeWithoutJavascript.Checked,True,True,False,IBQ_TQ_NUM_SOSA,False);
          lstl_HTMLTree.Insert(0, fs_Format_Lines(me_HeadTree.Lines.Text));
          p_CreateAHtmlFile(lstl_HTMLTree, CST_SUBDIR_HTML_TREE, me_Description.Lines.Text,
            ( gs_AnceSTROWEB_FamilyTree ), gs_AnceSTROWEB_FullTree, fs_GetTitleTree ( gs_AnceSTROWEB_Ancestry, li_generation), gs_LinkGedcom, '../');
          // saving the page
          ls_destination := gs_RootPathForExport +
            CST_SUBDIR_HTML_TREE + DirectorySeparator + ed_TreeName.Text + CST_EXTENSION_HTML;
          try
            if fb_CreateDirectoryStructure(gs_RootPathForExport + CST_SUBDIR_HTML_TREE + DirectorySeparator) then
              lstl_HTMLTree.SaveToFile(ls_destination);
          except
            On E: Exception do
            begin
              MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_cantSaveTree ) + ls_destination + CST_ENDOFLINE + E.Message);
              Abort;
            end;
          end;
          p_IncProgressBar;
         End;
      except
        On E: Exception do
          MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_FullTree + #13#10 + #13#10 + fs_getCorrectString ( gs_AnceSTROWEB_cantUseData ) + sDataBaseName + CST_ENDOFLINE + E.Message);
      end;
  finally
    lstl_HTMLTree.Free;
    lstl_HTMLTree2.Free;
  end;
end;

// function TF_AncestroWeb.fs_AddImage
// creating a HTML image from image's path
function TF_AncestroWeb.fs_AddImage(const as_ImageFile: string): string;
var
  ls_Destination, ls_HtmlFileName: string;
begin
  Result := '';
  p_IncProgressBar; // growing the counter
  if fi_ImageEditCount(as_ImageFile) = 0 then
    Exit;
  ls_HtmlFileName := ExtractFileName(as_ImageFile);
  ls_HtmlFileName := fs_TextToFileName(Copy(ls_HtmlFileName, 1, Length(ls_HtmlFileName) -
    Length(ExtractFileExt(ls_HtmlFileName)))) + CST_EXTENSION_JPEG;
  // saving the picture
  ls_destination := gs_RootPathForExport +
    CST_SUBDIR_HTML_IMAGES + DirectorySeparator + ls_HtmlFileName;
  with dm.TraduceImage do
   Begin
    FileSource := as_ImageFile;
    FileDestination := ls_Destination;
    CopySourceToDestination;
   end;
  AppendStr ( Result, ' ' + fs_AddImageTable(fs_Create_Image(CST_SUBDIR_HTML_IMAGES + CST_HTML_DIR_SEPARATOR + ls_HtmlFileName)));
end;

// function TF_AncestroWeb.fs_AddImageTable
// add an image in the current HTML TABLE
function TF_AncestroWeb.fs_AddImageTable(const as_HtmlImage : string ; const as_alt: string = ''): string;
begin
  if as_HtmlImage = ''
   Then Result := ''
   Else Result := CST_HTML_TD_BEGIN + '<' + CST_HTML_TABLE +
    CST_HTML_ID_EQUAL + '"image">' + CST_HTML_TR_BEGIN + CST_HTML_TD_BEGIN +
    as_HtmlImage + CST_HTML_TD_END + CST_HTML_TR_END +
    CST_HTML_TABLE_END + CST_HTML_TD_END + ' ';
end;

// procedure TF_AncestroWeb.p_genHtmlHome
// Default HTML page
procedure TF_AncestroWeb.p_genHtmlHome;
var
  lstl_HTMLHome: TStringlistUTF8;
  ls_destination: string;
  ls_Images: string;
  li_Count: integer;


  // stats
  procedure p_AddCounting ( const astl_HTML : TStringlistUTF8  );
  Begin
   if ch_Comptage.Checked then
    try
      // loading the request
      DMWeb.IBS_Compte.Close;
      DMWeb.IBS_Compte.ParamByName ( I_DOSSIER    ).AsInteger:=DMWeb.CleDossier;
      DMWeb.IBS_Compte.ExecQuery;
      if not DMWeb.IBS_Compte.Eof Then
        Begin
         // stats' title
         astl_HTML.Add ( CST_HTML_BR + fs_CreateElementWithId ( CST_HTML_H3    ,CST_FILE_COUNTING));
         astl_HTML.Add (( gs_AnceSTROWEB_Statistics   ));
         astl_HTML.Add ( CST_HTML_H3_END );
         // stats' table
         astl_HTML.Add ( fs_CreateElementWithId ( CST_HTML_TABLE, CST_FILE_COUNTING));
         while not DMWeb.IBS_Compte.EOF do
          Begin    // adding the stats
           astl_HTML.Add (CST_HTML_TR_BEGIN + CST_HTML_TD_BEGIN  + CST_HTML_H4_BEGIN +
                         fs_GetLabelCaption ( DMWeb.IBS_Compte.FieldByName(COUNTING_LABEL).AsString ) +
                         CST_HTML_H4_END  + CST_HTML_TD_END + CST_HTML_TD_BEGIN +
                         DMWeb.IBS_Compte.FieldByName(COUNTING_COUNTING).AsString +
                         CST_HTML_TD_END + CST_HTML_TR_END);
           DMWeb.IBS_Compte.Next;
          end;

         astl_HTML.Add ( CST_HTML_TABLE_END );
        end;
    Except
      MyShowMessage(gs_ANCESTROWEB_Unset_Stats);
    end;
  end;


  function fs_AddImages(const as_Image1, as_Image2, as_Image3: string): string;
  begin
    Result := '';
    li_Count := fi_ImageEditCount(as_Image1) + fi_ImageEditCount(
      as_Image2) + fi_ImageEditCount(as_Image3);
    if li_Count = 0 then
      Exit;
    dm.TraduceImage.ResizeWidth := 630 div li_Count;
    Result := fs_AddImage(ImageEdit1.FileName);
    AppendStr(Result, fs_AddImage(ImageEdit2.FileName));
    AppendStr(Result, fs_AddImage(ImageEdit3.FileName));

  end;

begin
  p_Setcomments ( gs_AnceSTROWEB_Home ); // advert for user
  lstl_HTMLHome := TStringlistUTF8.Create;
  try
    lstl_HTMLHome.Text := CST_HTML_CENTER_BEGIN + '<' + CST_HTML_Paragraph +
      CST_HTML_ID_EQUAL + '"head">' + fs_Format_Lines(
      me_Description.Text) + CST_HTML_Paragraph_END;

    ls_Images := fs_AddImages(ImageEdit1.FileName, ImageEdit2.FileName,
      ImageEdit3.FileName);
    if ls_Images > '' then
      lstl_HTMLHome.Add(' <' + CST_HTML_TABLE + CST_HTML_ID_EQUAL +
        '"images">' + CST_HTML_TR_BEGIN + ls_Images + CST_HTML_TR_END + CST_HTML_TABLE_END  + CST_HTML_BR);
    p_AddCounting ( lstl_HTMLHome );
    lstl_HTMLHome.Add(CST_HTML_CENTER_END);
    p_CreateKeyWords;
    pb_ProgressInd.Position := 0; // initing not needed user value
    p_CreateAHtmlFile(lstl_HTMLHome, CST_FILE_Home, me_Description.Lines.Text,
      ( gs_AnceSTROWEB_Home ), ( gs_AnceSTROWEB_Home ), gs_ANCESTROWEB_Welcome, gs_LinkGedcom);
    p_IncProgressBar; // growing the counter
    // saving the page
    ls_destination := gs_RootPathForExport + ed_IndexName.Text +
      CST_EXTENSION_HTML;
    try
      lstl_HTMLHome.SaveToFile(ls_destination);
    except
      On E: Exception do
      begin
        MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Home + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_ANCESTROWEB_cantCreateHere ) + ls_destination + CST_ENDOFLINE + E.Message);
        Abort;
      end;
    end;
  finally
    lstl_HTMLHome.Free;
  end;
end;

// procedure TF_AncestroWeb.p_Setcomments
// infos for user
procedure TF_AncestroWeb.p_Setcomments (const as_Comment : String);
Begin
  if as_Comment = ''
    Then lb_Comments.Caption:= ''
    Else lb_Comments.Caption:= fs_getCorrectString ( gs_AnceSTROWEB_Generating ) + as_Comment;

end;

// function TF_AncestroWeb.fb_OpenMedias
// Open a media data stream
function TF_AncestroWeb.fb_OpenMedias(const ai_CleFiche: Longint;
                                      const ai_Type: integer;
                                      const ab_Identite: Boolean = False;
                                      const ach_table : Char = MEDIAS_TABLE_ARCHIV):Boolean;
Begin
  Result := False;
  with DMWeb.IBQ_Medias do
  try
    Close;
    ParamByName(IBQ_CLE_FICHE     ).AsInteger := ai_CleFiche;
    ParamByName(MEDIAS_TYPE       ).AsInteger := ai_Type ;
    ParamByName(MEDIAS_TABLE      ).AsString  := ach_table ;
    ParamByName(MEDIAS_MP_IDENTITE).AsInteger := Integer ( ab_Identite ) ;
    Open;
    Result := not Eof;

  Except
    on E : Exception do
     Begin
       MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData + gs_AnceSTROWEB_The_Medias ) +CST_ENDOFLINE+e.Message);
     end;
  end;
end;



// function TF_AncestroWeb.fs_CreatePrevNext
// // creating previous or next image link
function TF_AncestroWeb.fs_CreatePrevNext ( const ai_PreviousNext : Longint ;
                                            const as_PreviousNext : String = CST_PAGE_PREVIOUS;
                                            const as_Subdir : String = '';
                                                  as_BeginLinkFiles : String = CST_SUBDIR_HTML_FILES + '/' ) : String;
Begin
  Result := CST_HTML_AHREF + as_BeginLinkFiles + IntToStr(ai_PreviousNext) + CST_EXTENSION_HTML + '">'
                + fs_Create_Image( as_Subdir + CST_SUBDIR_HTML_IMAGES + CST_HTML_DIR_SEPARATOR+as_PreviousNext + CST_EXTENSION_GIF, as_PreviousNext ) + CST_HTML_A_END
End;

// procedure TF_AncestroWeb.p_createLettersSheets
// creating a HTML list of letters
procedure TF_AncestroWeb.p_createLettersSheets ( var at_SheetsLetters : TAHTMLULTabSheet;
                                                 const IBQ_FilesFiltered: TIBQuery;
                                                 const ai_PerPage : Integer;
                                                 const as_BeginFile : String );
var li_Counter, li_OldCounterPages,  li_i: Longint;
    lch_i, lch_j : char;
Begin
  li_Counter := 0;
  li_OldCounterPages := 0;
  gi_PagesCount:=0;
  Finalize(at_SheetsLetters);
  lch_i := CST_HTML_BEGIN_LETTER;
  with IBQ_FilesFiltered do
   for lch_i := CST_HTML_BEGIN_LETTER to CST_HTML_END_LETTER do
     if Locate(IBQ_NOM, lch_i,[loPartialKey, loCaseInsensitive]) then
       begin
        if li_i > 0 Then
          li_OldCounterPages := RecNo div ai_PerPage;
        lch_j := chr ( ord ( lch_i ) + 1 );
        while not  Locate(IBQ_NOM, lch_j,
        [loPartialKey, loCaseInsensitive]) and ( UTF8UpperCase ( lch_j ) [ 1 ] <= CST_HTML_END_LETTER )
         do lch_j := chr ( ord ( lch_j ) + 1 );
        if UTF8UpperCase ( lch_j ) > 'Z'
          then Last;

        li_counter := RecNo div ai_PerPage;
        {
        if li_counter > li_OldCounterPages Then
          with FieldByName(IBQ_NOM) do
           if  ( AsString > '' )
           and ( AsString [1] = lch_j ) Then
            Begin
             IBQ_FilesFiltered.RecNo:= li_counter * ( ai_PerPage + 1 );
             if  ( AsString > '' )
             and ( AsString [1] < lch_j ) Then
              Begin
               p_AddTabSheetPage(at_SheetsLetters, high ( at_SheetsLetters ), as_BeginFile + IntToStr(li_Counter+1) + CST_EXTENSION_HTML, fs_RemplaceEspace (fs_getNameAndSurName(IBQ_FilesFiltered), '_' ));
              end
            End;
         }
        p_AddTabSheet(at_SheetsLetters, lch_i,
          as_BeginFile + IntToStr(li_OldCounterPages) + CST_EXTENSION_HTML );
        if li_OldCounterPages < li_Counter Then
          for li_i := li_OldCounterPages to li_Counter do
           Begin
            IBQ_FilesFiltered.RecNo:= li_i * ai_PerPage + 1 ;
            p_AddTabSheetPage(at_SheetsLetters, high ( at_SheetsLetters ), as_BeginFile + IntToStr(li_i) + CST_EXTENSION_HTML, fs_RemplaceEspace (fs_getNameAndSurName(IBQ_FilesFiltered), '_' ));
           end;
       end;
  gi_PagesCount := round ( IBQ_FilesFiltered.RecordCount / ai_PerPage+0.5);
end;

// function fs_GetNameLink
// Creates a link from a name and a showed info
function TF_AncestroWeb.fs_GetNameLink ( as_name : String ; const as_key, as_Showed : String ; const as_SubDir : String = ''):String ;
Begin
  as_name := StringReplace( StringReplace(as_name, '"', '\"',[rfReplaceAll]), '\', '\\',[rfReplaceAll]);
  if as_name > '' Then
   Begin
    Result := CST_HTML_AHREF + as_SubDir + fs_GetSheetLink ( gt_SheetsLetters, as_name[1], as_name ) + '#' + fs_exchange_special_chars(as_name) ;
    if as_key > '' Then
     AppendStr ( Result, '_' + as_key );
    AppendStr ( Result, '">' + as_Showed + CST_HTML_A_END );
   end;
End;

function TF_AncestroWeb.fs_GetSOSA(const IBQuery: TIBQuery): String;
begin
  with IBQuery do
   if ch_Filtered.Checked
    Then
     if ch_ancestors.Checked
       Then Result := fs_RemplaceMsgIfExists(gs_ANCESTROWEB_SOSA    ,FieldByName(IBQ_TQ_SOSA    ).AsString)
       Else Result := fs_RemplaceMsgIfExists(gs_ANCESTROWEB_Aboville,FieldByName(IBQ_TQ_NUM_SOSA).AsString)
    Else    Result := fs_RemplaceMsgIfExists(gs_ANCESTROWEB_SOSA    ,FieldByName(IBQ_SOSA       ).AsString);
end;

// procedure TF_AncestroWeb.p_genHtmlSurnames
// generating HTML Surnames' page
procedure TF_AncestroWeb.p_genHtmlSurnames (const IBS_FilesFiltered: TIBSQL;const IBQ_Names: TIBQuery);
var
  lstl_HTMLAFolder: TStringlistUTF8;
  ls_NewSurname, ls_ASurname, ls_destination: string;


const CST_DUMMY_COORD = 2000000;
      CST_NB_DOTS     = 5;
  procedure p_getCityInfos ( as_codepostal, as_Pays : String ; var as_City : String; var ad_latitude , ad_longitude : Double);
  Begin
    ad_latitude :=CST_DUMMY_COORD;
    ad_longitude:=CST_DUMMY_COORD;
    as_City := '' ;
    if ( as_codepostal = '' )
    or ( Length(as_codepostal)>8) Then
      Begin
        p_Setcomments(gs_ANCESTROWEB_MapProblemNoPostalCode);
        Exit;
      end;
    if ( as_pays = '' ) Then
     as_pays := gs_ANCESTROWEB_MapCountry;
    with DMWeb.IBS_City do
      Begin
        Close;
        ParamByName(I_CP  ).AsString:=as_codepostal;
        ParamByName(I_PAYS).AsString:=as_Pays;
        ExecQuery;
        if EOF and BOF Then
         if as_Pays = gs_ANCESTROWEB_MapCountry
          Then Exit
          Else p_getCityInfos ( as_codepostal, gs_ANCESTROWEB_MapCountry, as_City, ad_latitude, ad_longitude );
        if FieldByName(IBQ_CP_LATITUDE ).IsNull or FieldByName(IBQ_CP_LONGITUDE ).IsNull Then
         Exit;
        ad_latitude := FieldByName(IBQ_CP_LATITUDE ).AsFloat;
        ad_longitude:= FieldByName(IBQ_CP_LONGITUDE).AsFloat;
        as_City     := FieldByName(IBQ_CP_VILLE    ).AsString;
        Close;
      end;
  end;

  // procedure p_getGlobalMinMax
  // Min and max for global map
  procedure p_getGlobalMinMax (var ad_Minlatitude, ad_Maxlatitude, ad_Minlongitude , ad_Maxlongitude : Double ; var ai_MaxCounter  : Int64 );
  var li_i : LongInt;
  Begin
    for li_i := 0 to high ( gt_Surnames ) do
     with gt_Surnames [ li_i ] do
      Begin
        if Minlatitude < ad_Minlatitude Then
          ad_Minlatitude := Minlatitude;
        if Maxlatitude > ad_Maxlatitude Then
          ad_Maxlatitude := Maxlatitude;
        if Minlongitude < ad_Minlongitude Then
          ad_Minlongitude := Minlongitude;
        if Maxlongitude > ad_Maxlongitude Then
          ad_Maxlongitude := Maxlongitude;
        if MaxCounter > ai_MaxCounter Then
          ai_MaxCounter := MaxCounter;
      end;
  End;

    // procedure p_createMinMaxMap
    // creating min and max on Surnames
    procedure p_createMinMaxMap ( const IBS_MapFiltered :TIBSQL);
    var
        li_i : LongInt;
        ld_latitude  ,
        ld_longitude : Double;
        ld_counter   : Int64;
        ls_City ,
        ls_AName : String;
    Begin
      ld_longitude := 0;
      ld_latitude  := 0;
      ls_City      := '';
      with IBS_MapFiltered do
      while not Eof do
        Begin
          ls_AName := FieldByName(IBQ_NOM).AsString;
          ls_City:= Trim ( FieldByName(IBQ_EV_IND_VILLE).AsString );
          if  ( ls_AName > '' ) Then
           if ( FieldIndex [ IBQ_EV_IND_LATITUDE ] >= 0 )
           and not FieldByName(IBQ_EV_IND_LATITUDE ).IsNull and not FieldByName(IBQ_EV_IND_LONGITUDE ).IsNull Then
            Begin
              ld_latitude :=FieldByName(IBQ_EV_IND_LATITUDE ).AsDouble;
              ld_longitude:=FieldByName(IBQ_EV_IND_LONGITUDE).AsDouble;
              ld_counter :=  FieldByName(IBQ_COUNTER ).AsInt64;
              if  ( ld_latitude <> CST_DUMMY_COORD ) Then
                begin
                  li_i := fi_findName ( ls_AName );
                  if li_i > -1 Then
                   with gt_Surnames [ li_i ] do
                   // mise à jour des max
                    Begin
                      if ld_latitude  < Minlatitude then
                       Minlatitude:= ld_latitude;
                      if ld_latitude  > Maxlatitude then
                       Maxlatitude:= ld_latitude;
                      if ld_longitude  < Minlongitude then
                       Minlongitude:= ld_longitude;
                      if ld_longitude  > Maxlongitude then
                        Maxlongitude:= ld_longitude;
                      if ld_counter  > MaxCounter then
                        MaxCounter:=ld_counter;
                    end
                  else
                   Begin
                     SetLength(gt_Surnames, high ( gt_Surnames ) + 2);
                     with gt_Surnames [ high ( gt_Surnames )] do
                      Begin
                        Name := ls_AName;
                        Minlatitude :=ld_latitude;
                        Maxlatitude :=ld_latitude;
                        Minlongitude:=ld_longitude;
                        Maxlongitude:=ld_longitude;
                        MaxCounter := ld_counter;
                      end;
                   end;
                end;
             End
            Else
             Begin
               p_getCityInfos ( FieldByName(IBQ_EV_IND_CP).AsString, FieldByName(IBQ_EV_IND_PAYS).AsString, ls_City, ld_latitude, ld_longitude );
               ld_counter :=  FieldByName(IBQ_COUNTER ).AsInt64;
               if ls_City > '' Then
                 begin
                   li_i := fi_findName ( ls_AName );
                   if li_i <> -1 Then
                    with gt_Surnames [ li_i ] do
                    // mise à jour des max
                     Begin
                       if ld_latitude  < Minlatitude then
                        Minlatitude:= ld_latitude;
                       if ld_latitude  > Maxlatitude then
                        Maxlatitude:= ld_latitude;
                       if ld_longitude  < Minlongitude then
                        Minlongitude:= ld_longitude;
                       if ld_longitude  > Maxlongitude then
                         Maxlongitude:= ld_longitude;
                       if ld_counter  > MaxCounter then
                         MaxCounter:=ld_counter;
                     end
                   else
                    Begin
                      SetLength(gt_Surnames, high ( gt_Surnames ) + 2);
                      with gt_Surnames [ high ( gt_Surnames )] do
                       Begin
                         Name := ls_AName;
                         Minlatitude :=ld_latitude;
                         Maxlatitude :=ld_latitude;
                         Minlongitude:=ld_longitude;
                         Maxlongitude:=ld_longitude;
                         MaxCounter := ld_counter;
                       end;
                    end;
                 End;
            end;
          Next;
        end;
    end;

  // function fs_MapZoom
  // creating zoom for map
  function fs_MapZoom ( const ad_Minlatitude, ad_Maxlatitude, ad_Minlongitude , ad_Maxlongitude  : Double ): String;
  var ld_Longitude, ld_Zoom : Double;
  Begin
    ld_Zoom      := 90  + ad_Maxlatitude  - ad_Minlatitude  ;
    ld_Longitude := ( 180 + ad_Maxlongitude - ad_Minlongitude ) / 2 ;
    if ld_Longitude > ld_Zoom Then
     ld_Zoom:=ld_Longitude;
    ld_Zoom := 1.25 - ld_Zoom / 180;
    try
      // adapting initial zoom to max lattitud and longitud
      Result := IntToStr ( trunc ( StrToInt(gs_ANCESTROWEB_MapMaxZoom) * ld_Zoom ));
    except
    end;
  End;
  // procedure p_setACase
  // creating a now switching case
  procedure p_setACase ( const astl_ACaseFile : TStringlistUTF8; const ai_Name : Integer );
  Begin
    if ( ai_Name > -1 ) Then
     //set a surname line
      with gt_Surnames [ ai_Name ] do
        Begin
          p_ReplaceLanguageString ( astl_ACaseFile, CST_MAP_LATITUD , FloatToStr((Maxlatitude  + MinLatitude ) /2),[rfReplaceAll]);
          p_ReplaceLanguageString ( astl_ACaseFile, CST_MAP_LONGITUD, FloatToStr((MinLongitude + Maxlongitude) /2),[rfReplaceAll]);
          p_ReplaceLanguageString ( astl_ACaseFile, CST_MAP_MIN_LATITUD , FloatToStr(MinLatitude ),[rfReplaceAll]);
          p_ReplaceLanguageString ( astl_ACaseFile, CST_MAP_MIN_LONGITUD, FloatToStr(MinLongitude),[rfReplaceAll]);
          p_ReplaceLanguageString ( astl_ACaseFile, CST_MAP_MAX_LATITUD , FloatToStr(MaxLatitude ),[rfReplaceAll]);
          p_ReplaceLanguageString ( astl_ACaseFile, CST_MAP_MAX_LONGITUD, FloatToStr(MaxLongitude),[rfReplaceAll]);
          p_ReplaceLanguageString ( astl_ACaseFile, CST_MAP_ZOOM    , fs_MapZoom ( Minlatitude, Maxlatitude, Minlongitude , Maxlongitude ),[rfReplaceAll]);
        end;
    ls_ASurname := ls_NewSurname;

  end;

  // procedure p_setAline
  // creating a new case line
  procedure p_setAline ( const astl_FileLines, astl_Line : TStringlistUTF8; const IBS_MapFiltered :TIBSQL; const ai_MaxCounter : Int64 ; const ab_IsNamedMap : Boolean ; const ai_counter : Longint );
  var li_i, li_dot : Integer ;
      ld_latitude, ld_longitude : Double;
      li_counter : Int64;
      ls_City, ls_CitySurname, ls_Surname, ls_link : String;
      lvar_Search : variant;
  Begin
    with IBS_MapFiltered do
     Begin
       ls_City:=FieldByName(IBQ_EV_IND_VILLE).AsString;
       ls_CitySurname:=Trim(ls_City);
       if ( FieldIndex [ IBQ_EV_IND_LATITUDE ] > -1 )
       and ( not FieldByName(IBQ_EV_IND_LATITUDE ).IsNull ) then
        Begin
         ld_latitude :=FieldByName(IBQ_EV_IND_LATITUDE ).AsDouble;
         ld_longitude:=FieldByName(IBQ_EV_IND_LONGITUDE).AsDouble;
        End
        Else
         p_getCityInfos ( FieldByName(IBQ_EV_IND_CP).AsString,
                          FieldByName(IBQ_EV_IND_PAYS).AsString,
                          ls_CitySurname,
                          ld_latitude, ld_longitude );
       if ab_IsNamedMap
        Then // just set the link
         ls_CitySurname:=fs_getLinkedCity(ls_CitySurname)
        else // adding keywords and set the link
         Begin
           p_addKeyWord(ls_CitySurname); // adding a head's meta keywords
           p_addKeyWord(FieldByName(IBQ_NOM).AsString); // adding a head's meta keywords
           ls_CitySurname:=fs_getLinkedSurName(FieldByName(IBQ_NOM).AsString) + ' - ' + fs_getLinkedCity(ls_CitySurname);
         end;
       li_counter:= FieldByName(IBQ_COUNTER).AsInt64;
     end;
    if ( ld_latitude  = CST_DUMMY_COORD) Then
     Exit; // si mauvaises coordonnées on n'ajoute pas de ligne
    astl_FileLines.Append ( astl_Line.Text );
    astl_FileLines.BeginUpdate;
    ls_CitySurname:=StringReplace(ls_CitySurname, '''', '\''',[rfReplaceAll]);
    p_ReplaceLanguageString ( astl_FileLines, CST_MAP_N, IntToStr(ai_counter),[rfReplaceAll] );
    ls_CitySurname := ls_CitySurname + ' - ' ;
    ls_link := IntToStr(li_counter) + ' ' ;
    if li_counter > 1
     Then AppendStr ( ls_link, gs_ANCESTROWEB_FamilyPersons )
     Else AppendStr ( ls_link, gs_ANCESTROWEB_FamilyPerson  );
    lvar_Search := VarArrayCreate([ 0, 2 ],varvariant);
    lvar_Search[0]:=IBS_MapFiltered.FieldByName(IBQ_NOM).AsString;
    lvar_Search[1]:=ls_City;
    lvar_Search[2]:=IBS_MapFiltered.FieldByName(IBQ_EV_IND_PAYS).AsString;
    if IBQ_Names.Locate('NOM;VILLE_BIRTH;PAYS_BIRTH',lvar_Search,[])
     Then // if have found this name in person list
      with IBQ_Names do
        Begin
         // get precise anchor of page file
         ls_Surname:= fs_RemplaceChar(
                      fs_getNameAndSurName ( fb_ShowYear(FieldByName(IBQ_ANNEE_NAISSANCE ).AsInteger,
                                                         FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger),
                                            FieldByName(IBQ_NOM).AsString,
                                            FieldByName(IBQ_PRENOM).AsString), ' ', '_' );
         // ls_city available, use it for key of person
         ls_City:=FieldByName(IBQ_CLE_FICHE).AsString;
        end
     Else
      Begin
        // get anchor of page file
        ls_Surname:=IBS_MapFiltered.FieldByName(IBQ_NOM).AsString;
        ls_City:='';
      end;
    // créer l'infobulle pour un nom de la carte
    p_ReplaceLanguageString ( astl_FileLines, CST_MAP_NAME_CITY ,
                              StringReplace ( ls_CitySurname + StringReplace ( fs_GetNameLink ( ls_Surname
                              , ls_City, ls_link, CST_SUBDIR_HTML_FILES + CST_HTML_DIR_SEPARATOR), '''', '\''',[rfReplaceAll])
                              , '"', '\"',[rfReplaceAll]));
    p_ReplaceLanguageString ( astl_FileLines, CST_MAP_LATITUD   , FloatToStr(ld_latitude ),[rfReplaceAll]);
    p_ReplaceLanguageString ( astl_FileLines, CST_MAP_LONGITUD  , FloatToStr(ld_longitude),[rfReplaceAll]);
    li_dot := CST_NB_DOTS;
    for li_i := 1 to CST_NB_DOTS do
      if li_counter <= ai_MaxCounter / li_i Then
       li_dot := CST_NB_DOTS - li_i + 1;
    case li_dot of
     1 :  p_ReplaceLanguageString ( astl_FileLines, CST_MAP_ICON, CST_MAP_LITTLE_DOT  ,[rfReplaceAll]);
     2 :  p_ReplaceLanguageString ( astl_FileLines, CST_MAP_ICON, CST_MAP_LI_MID_DOT  ,[rfReplaceAll]);
     3 :  p_ReplaceLanguageString ( astl_FileLines, CST_MAP_ICON, CST_MAP_MIDDLE_DOT  ,[rfReplaceAll]);
     4 :  p_ReplaceLanguageString ( astl_FileLines, CST_MAP_ICON, CST_MAP_BIG_MID_DOT ,[rfReplaceAll]);
     else p_ReplaceLanguageString ( astl_FileLines, CST_MAP_ICON, CST_MAP_BIG_DOT     ,[rfReplaceAll]);
    end;
    astl_FileLines.EndUpdate;
  end;

  // procedure p_createAMap
  // creating a map with persons frpm IBS_MapFiltered
  procedure p_createAMap ( const IBS_MapFiltered :TIBSQL; IBQ_CountMap :TIBQuery);
  var ld_MinLatitude, ld_MaxLatitude, ld_MinLongitude, ld_MaxLongitude : Double;
    li_MaxCounter : Int64;
    lstl_AllSurnames ,
    lstl_ACase    ,
    lstl_EndCase    ,
    lstl_AFile    ,
    lstl_ALine    : TStringlistUTF8;
    li_Name       ,
    li_i, li_j, li_MapFileJS          : Integer ;
    li_recno, li_recordcount : Int64;
    lch_decimalSep : Char;
    // scroll on a dataset
    procedure p_scroll ( var ai_recno : Int64 ; const ai_recordtogo : Int64 );
    Begin
      while ai_recno < ai_recordtogo do
       Begin
        inc ( ai_recno );
        IBS_MapFiltered.Next;
       end;
    end;

    // create grouped surnames sheets
    procedure p_CreateSheets;
    var
      ls_from : string;
      li_counter : Integer;
    begin
      li_recno := 0;
      Finalize(gt_SheetsMapGroup);
      with IBS_MapFiltered do
       if not ( BOF and EOF ) Then
        for li_counter := sp_groupMap.Value - 1 downto 0 do
          begin
            if li_counter < sp_groupMap.Value Then
              Next;
            ls_from:= FieldByName(IBQ_nom).AsString;
            if li_counter = 0
             Then p_scroll( li_recno, li_recordcount - 1 )
             Else p_scroll( li_recno, li_recordcount div (li_counter*2));
            with FieldByName(IBQ_NOM) do
               p_AddTabSheet(gt_SheetsMapGroup, fs_RemplaceMsg ( gs_ANCESTROWEB_From_to_persons, [ls_from,AsString]),
                             ed_MapFileName.Text + IntToStr(sp_groupMap.Value - 1-li_counter) + CST_EXTENSION_HTML, AsString );
          End;
    end;

    //creating a map js file
    procedure p_createFileCaseMap ( const astl_AFile : TStringlistUTF8; const ai_counter : Integer);
    Begin

      // saving the page
      ls_destination := gs_RootPathForExport + CST_SUBDIR_HTML_MAPS + DirectorySeparator + ed_MapFileName.Text + CST_FILE_FILE + IntToStr(ai_counter) + CST_EXTENSION_JS;
      try
        astl_AFile.SaveToFile(ls_destination);
      except
        On E: Exception do
        begin
          MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Map + #13#10 + #13#10 + fs_getCorrectString ( gs_ANCESTROWEB_cantCreateHere ) + ls_destination + CST_ENDOFLINE + E.Message);
          Abort;
        end;
      end;
     End;

    //creating and initing a map js file
    procedure p_createACase ( const astl_Case : TStringlistUTF8; const as_Name : String );
    Begin
      p_ReplaceLanguageString ( lstl_EndCase, CST_MAP_N, IntToStr(li_i) );
      p_ReplaceLanguageString ( lstl_HTMLAFolder, CST_MAP_CASE, lstl_ACase.Text );
      p_ReplaceLanguageString ( lstl_HTMLAFolder, CST_MAP_FILE, StringReplace( CST_SUBDIR_HTML_MAPS +'/'+ ed_MapFileName.Text + CST_FILE_FILE + IntToStr(li_MapFileJS)+CST_EXTENSION_JS, '''', '\''',[rfReplaceAll]));
      p_ReplaceLanguageString ( lstl_HTMLAFolder, CST_MAP_NAME    , StringReplace ( StringReplace ( as_Name, '"', '\"', [rfReplaceAll] ), '''', '\''', [rfReplaceAll] ) ,[rfReplaceAll]);
      if as_Name > '' Then
        p_setACase(astl_Case, li_Name); //  load case file and set html var files
      astl_Case.AddStrings(lstl_EndCase);
      p_createFileCaseMap ( astl_Case, li_MapFileJS );
      p_LoadStringList(astl_Case      , CST_MAP_FILE     + CST_EXTENSION_JS);
      p_LoadStringList(lstl_EndCase   , CST_MAP_CASE_END + CST_EXTENSION_JS);
      inc ( li_MapFileJS );
      if as_Name = ''
       Then p_ReplaceLanguageString ( lstl_HTMLAFolder, CST_MAP_CASE, '' );
    end;

    // creating a map htm file
    procedure p_createFileMap(const li_page : Integer);
    Begin
      // create map file
      p_createACase ( lstl_AllSurnames, '' );
      // creating PHP file
      if ch_SplittedMap.Checked Then
       Begin
        lstl_HTMLAFolder.Insert(0,fs_CreateULTabsheets(gt_SheetsMapGroup, '', CST_HTML_SUBMENU)+CST_HTML_DIV_BEGIN);
        lstl_HTMLAFolder.Add(CST_HTML_DIV_END);
       end;
      p_CreateAHtmlFile(lstl_HTMLAFolder, CST_FILE_MAP, me_MapHead.Lines.Text,
         gs_ANCESTROWEB_Map, '', gs_ANCESTROWEB_Map_Long, gs_LinkGedcom,'',CST_EXTENSION_HTML);
      // saving the page
      if li_page > -1
       Then ls_destination := gs_RootPathForExport + ed_MapFileName.Text + IntToStr(li_page) + CST_EXTENSION_HTML
       Else ls_destination := gs_RootPathForExport + ed_MapFileName.Text + CST_EXTENSION_HTML;
      try
        lstl_HTMLAFolder.SaveToFile(ls_destination);
      except
        On E: Exception do
        begin
          MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Map + #13#10 + #13#10 + fs_getCorrectString ( gs_ANCESTROWEB_cantCreateHere ) + ls_destination + CST_ENDOFLINE + E.Message);
          Abort;
        end;
      end;
      lstl_HTMLAFolder.Clear;
      p_IncProgressBar;
     End;
    // initing a map
    procedure p_initFileCase( const astl_strings : TStrings );
     Begin
      p_ReplaceLanguageString ( astl_strings, CST_MAP_LATITUD , FloatToStr(ld_MinLatitude ),[rfReplaceAll]);
      p_ReplaceLanguageString ( astl_strings, CST_MAP_LONGITUD, FloatToStr(ld_MinLongitude),[rfReplaceAll]);
      p_ReplaceLanguageString ( astl_strings, CST_MAP_MAX_ZOOM, gs_ANCESTROWEB_MapMaxZoom,[rfReplaceAll]);
      p_ReplaceLanguageString ( astl_strings, CST_MAP_ZOOM    , fs_MapZoom ( ld_Minlatitude, ld_Maxlatitude, ld_Minlongitude , ld_Maxlongitude ),[rfReplaceAll]);
     End;
    procedure p_initFileMap;
     Begin
      ls_NewSurname := '';
      li_i := 0;
      ls_ASurname := IBS_MapFiltered.FieldByName(IBQ_NOM).AsString;
      p_LoadStringList(lstl_HTMLAFolder, CST_FILE_MAP     + CST_EXTENSION_HTML);
      p_LoadStringList(lstl_AllSurnames, CST_MAP_FILE     + CST_EXTENSION_JS);
      p_LoadStringList(lstl_ACase      , CST_FILE_MapCase + CST_EXTENSION_JS);
      p_LoadStringList(lstl_EndCase    , CST_MAP_CASE_END + CST_EXTENSION_JS);
      p_LoadStringList(lstl_AFile      , CST_MAP_FILE     + CST_EXTENSION_JS);
      p_LoadStringList(lstl_ALine      , CST_FILE_MapLine + CST_EXTENSION_JS);
      p_ReplaceLanguageString ( lstl_HTMLAFolder, CST_HTML_CAPTION, gs_ANCESTROWEB_Map_Long,[rfReplaceAll] );
      p_ReplaceLanguageString ( lstl_HTMLAFolder, CST_MAP_CAPTIONS, gs_ANCESTROWEB_MapCaptions ,[rfReplaceAll]);
      p_ReplaceLanguageString ( lstl_HTMLAFolder, CST_MAP_TO      , gs_ANCESTROWEB_Map_To      ,[rfReplaceAll]);
      p_initFileCase(lstl_AllSurnames);
     End;
  Begin
    if not IBQ_CountMap.EOF then
      IBQ_CountMap.Last;
    li_recordcount := IBQ_CountMap.RecordCount;
    fb_CreateDirectoryStructure(gs_RootPathForExport + CST_SUBDIR_HTML_MAPS);
    Finalize ( gt_Surnames );
    p_createMinMaxMap ( IBS_MapFiltered );
    with IBS_MapFiltered do
      try
        Close;
        ExecQuery;
      Except
         on E : Exception do
           Begin
            MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Map  + #13#10 + #13#10 + fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData ) + sDataBaseName + CST_ENDOFLINE + E.Message);
            Exit;
           End;
       End;
    if ch_SplittedMap.Checked Then
     with IBS_MapFiltered do
       Begin
         p_CreateSheets;
         Close;
         ExecQuery;
       end;
    // initing global values
    ld_Minlatitude := CST_DUMMY_COORD;
    ld_Maxlatitude := -CST_DUMMY_COORD;
    ld_Minlongitude  := CST_DUMMY_COORD;
    ld_Maxlongitude  := -CST_DUMMY_COORD;
    li_MaxCounter  := 0;
    p_getGlobalMinMax ( ld_Minlatitude, ld_Maxlatitude, ld_Minlongitude , ld_Maxlongitude, li_MaxCounter );
    p_ClearKeyWords;
    li_Name := -1;
    pb_ProgressInd.Position:=0;  // initing user value
    pb_ProgressInd.Max:=li_recordcount;
    lstl_AllSurnames := TStringlistUTF8.Create;
    lstl_ACase    := TStringlistUTF8.Create;
    lstl_EndCase  := TStringlistUTF8.Create;
    lstl_AFile    := TStringlistUTF8.Create;
    lstl_ALine    := TStringlistUTF8.Create;
    // loading files
    // Full Map
    with IBS_MapFiltered do
     try
      lch_decimalSep:={$IFDEF FPC}DefaultFormatSettings.{$ENDIF}DecimalSeparator;
      {$IFDEF FPC}DefaultFormatSettings.{$ENDIF}DecimalSeparator:='.';
      p_initFileMap;
      li_recno := 0;
      li_j := sp_groupMap.Value;
      li_MapFileJS := 0;
      while not EOF do
        begin
          inc ( li_recno );
          ls_NewSurname := FieldByName(IBQ_NOM).AsString;
          li_Name := fi_findName(ls_NewSurname);
          if  ( li_Name > -1 )
          and ( ls_NewSurname > '' ) Then
           Begin  // adding lines in the full and named map
             inc (li_i);
             p_setAline(lstl_AllSurnames, lstl_ALine,IBS_MapFiltered,li_MaxCounter,False, li_i);
             p_setAline(lstl_AFile, lstl_ALine,IBS_MapFiltered,gt_Surnames [ li_Name ].MaxCounter,True, li_i);
             p_addKeyWord(ls_ASurname, '-'); // adding a head's meta keywords
           end;
          if  ( ls_NewSurname <> ls_ASurname )
           Then // Setting new case for a new named map
            Begin
             p_createACase (lstl_AFile, ls_NewSurname);
             p_initFileCase(lstl_AFile);
            end;
          if ch_SplittedMap.Checked
          and ( li_j > 1) and ( li_recno = li_recordcount div ( li_j * 2 )) Then
           Begin
            p_createFileMap ( sp_groupMap.Value-li_j );
            dec ( li_j );
            p_ClearKeyWords;
            p_initFileMap;
           End;
          Next;

        end;
      if ch_SplittedMap.Checked
       Then p_createFileMap ( sp_groupMap.Value-1 )
       Else p_createFileMap (-1);
     finally
     {$IFDEF FPC}DefaultFormatSettings.{$ENDIF}DecimalSeparator:=lch_decimalSep;
      lstl_AllSurnames.Destroy;
      lstl_ACase      .Destroy;
      lstl_EndCase    .Destroy;
      lstl_AFile      .Destroy;
      lstl_ALine      .Destroy;
     end;
  end;

  // procedure p_createMap
  // create filtered map ?
  procedure p_createMap;
  Begin
    if ch_genMap.Checked Then
    begin
      if ch_Filtered.Checked
      then
       Begin
         if ch_ancestors.Checked Then
           Begin
             if  fb_OpenTree(DmWeb.IBS_TreeMap,gi_CleFiche)
             and fb_OpenTree(DmWeb.IBQ_TreeMapCount,gi_CleFiche)
              Then
               p_createAMap (DmWeb.IBS_TreeMap,DmWeb.IBQ_TreeMapCount);
           end
          else
           Begin
             if  fb_OpenTree(DmWeb.IBS_TreeMapDes, gi_CleFiche)
             and fb_OpenTree(DmWeb.IBQ_TreeDescCount, gi_CleFiche) Then
               p_createAMap (DmWeb.IBS_TreeMapDes,DmWeb.IBQ_TreeDescCount);
           end;
       end
      else
       Begin
         try
           with DmWeb.IBS_MapAll do
            Begin
             Close;
             ParamByName(I_DOSSIER).AsInteger:=DMWeb.CleDossier;
             ExecQuery;
            End;
           with DmWeb.IBQ_CountMapAll do
            Begin
             Close;
             ParamByName(I_DOSSIER).AsInteger:=DMWeb.CleDossier;
             Open;
            End;
         Except
           on E : Exception do
             Begin
              MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Map + '(' + IntToStr ( DMWeb.CleDossier ) + ')' + #13#10 + #13#10 + fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData ) + sDataBaseName + CST_ENDOFLINE + E.Message);
              Exit;
             End;
         End;
         p_createAMap (DmWeb.IBS_MapAll,DmWeb.IBQ_CountMapAll);

       end;
    end;
  end;
  var li_i : Integer;
begin
  lstl_HTMLAFolder := TStringlistUTF8.Create;
  try
    p_createMap;
    p_ClearKeyWords;
    ls_ASurname := '';
    pb_ProgressInd.Position:=0;  // initing user value
    pb_ProgressInd.Max:=IBS_FilesFiltered.RecordCount;
    lstl_HTMLAFolder.Add ( fs_CreateULTabsheets ( gt_SheetsLetters, '', CST_HTML_SUBMENU, False, True )+CST_HTML_DIV_BEGIN);
    lstl_HTMLAFolder.Add ( fs_CreateElementWithId(CST_HTML_TABLE, 'Surnames') + CST_HTML_TR_BEGIN + CST_HTML_TD_BEGIN  );
    while not IBS_FilesFiltered.EOF do
     begin
      p_IncProgressInd; // growing the second counter
      ls_NewSurname := IBS_FilesFiltered.FieldByName(IBQ_NOM).AsString;
      if (ls_NewSurname <> ls_ASurname) Then
       Begin
        if (length(ls_NewSurname) = 0) Then
          ls_NewSurname:=' ';
        if ((length(ls_ASurname) = 0) or
          (ls_NewSurname[1] <> ls_ASurname[1])) then // Anchor
          lstl_HTMLAFolder.Add ( CST_HTML_TD_END +CST_HTML_TR_END + CST_HTML_TR_BEGIN + CST_HTML_TD_BEGIN +
                                 CST_HTML_A_BEGIN + CST_HTML_NAME_EQUAL + '"' + ls_NewSurname[1] + '" />'+
                                 CST_HTML_H4_BEGIN + ls_NewSurname[1] + CST_HTML_H4_END + CST_HTML_TD_END +CST_HTML_TD_BEGIN)
          Else lstl_HTMLAFolder.Add ( ' - ' );
        // Name and its link
        lstl_HTMLAFolder.Add ( fs_GetNameLink ( ls_NewSurname,'', ls_NewSurname, CST_SUBDIR_HTML_FILES + CST_HTML_DIR_SEPARATOR ) +' ( '+ IBS_FilesFiltered.FieldByName( IBQ_COUNTER ).AsString );
        if  ch_genMap.Checked // Creating optionnal map button
        and ( fi_findName(ls_NewSurname)>-1)
        Then if ch_SplittedMap.Checked Then
         Begin
          for li_i := 0 to high ( gt_SheetsMapGroup ) do
           if ls_NewSurname <= gt_SheetsMapGroup [ li_i ].s_info Then
            Begin
             lstl_HTMLAFolder.Add ( ' - ' + fs_Create_Link(ed_MapFileName.Text+IntToStr(li_i)+ CST_EXTENSION_HTML + '?name=' +ls_NewSurname,
                                    fs_Create_Image(CST_SUBDIR_HTML_IMAGES+CST_HTML_DIR_SEPARATOR+CST_FILE_MAP
                                    +CST_HTML_DIR_SEPARATOR+CST_FILE_MAP+CST_FILE_Button+CST_EXTENSION_GIF,gs_ANCESTROWEB_Map)));
             Break;
            End;
          End
         Else
           lstl_HTMLAFolder.Add ( ' - ' + fs_Create_Link(ed_MapFileName.Text+CST_EXTENSION_HTML + '?name=' +ls_NewSurname,
                                  fs_Create_Image(CST_SUBDIR_HTML_IMAGES+CST_HTML_DIR_SEPARATOR+CST_FILE_MAP
                                  +CST_HTML_DIR_SEPARATOR+CST_FILE_MAP+CST_FILE_Button+CST_EXTENSION_GIF,gs_ANCESTROWEB_Map)));
        lstl_HTMLAFolder.Add ( ')' );
       end;
      ls_ASurname := IBS_FilesFiltered.FieldByName(IBQ_NOM).AsString;
      p_addKeyWord(ls_ASurname, '-'); // adding a head's meta keyword
      IBS_FilesFiltered.Next;

     end;
    lstl_HTMLAFolder.Add ( CST_HTML_TD_END +CST_HTML_TR_END + CST_HTML_TABLE_END );
    lstl_HTMLAFolder.Add(CST_HTML_DIV_END);
    p_CreateAHtmlFile(lstl_HTMLAFolder, CST_FILE_Surnames, me_SurnamesHead.Lines.Text,
       ( gs_AnceSTROWEB_Surnames ), gs_AnceSTROWEB_Surnames, gs_ANCESTROWEB_Surnames_Long, gs_LinkGedcom);
    // saving the page
    ls_destination := gs_RootPathForExport + ed_SurnamesFileName.Text + CST_EXTENSION_HTML;
    try
      lstl_HTMLAFolder.SaveToFile(ls_destination);
    except
      On E: Exception do
      begin
        MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Surnames + #13#10 + #13#10 + fs_getCorrectString ( gs_ANCESTROWEB_cantCreateHere ) + ls_destination + CST_ENDOFLINE + E.Message);
        Abort;
      end;
    end;
  finally
    lstl_HTMLAFolder.Destroy;
  end;
end;


// procedure TF_AncestroWeb.p_genHtmlList
// creating persons' list
procedure TF_AncestroWeb.p_genHtmlList(const IBQ_FilesFiltered: TIBQuery);
var
  ls_ASurnameOrName, ls_destination: string;
  lt_SheetsLists : TAHTMLULTabSheet;
  ls_ImagesDir: string;
  li_CounterPages : Longint;

  function fs_addYear ( const as_yearField, as_CityField : String ) : String;
  Begin
    with IBQ_FilesFiltered do
      if fb_ShowYear(FieldByName(as_yearField).AsInteger,FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger)
       then
        Begin
          Result := FieldByName(as_yearField).AsString+fs_AddComma ( fs_getLinkedCity ( Trim (  FieldByName(as_CityField).AsString )));
        end
       Else Result := '';
  end;

  procedure p_AddAList;
  var
    lstl_HTMLAList: TStringlistUTF8;
    ls_NewSurname, ls_Sexe, ls_ASurnameBegin, ls_ASurnameEnd: string;
    li_i, li_CleFiche: longint;
    lb_next, lb_show : Boolean ;
  begin
    p_CreateKeyWords;
    lstl_HTMLAList := TStringlistUTF8.Create;
    ls_ASurnameBegin := IBQ_FilesFiltered.FieldByName(IBQ_NOM).AsString;
    if (ls_ASurnameBegin > '') then
      p_SelectTabSheet(lt_SheetsLists,ls_ASurnameBegin[1],ls_ASurnameBegin); // current letter sheet
    lstl_HTMLAList.Text :=
      fs_CreateULTabsheets(lt_SheetsLists, '', CST_HTML_SUBMENU)+CST_HTML_DIV_BEGIN;
    if (ls_ASurnameBegin > '') then
      p_SelectTabSheet(lt_SheetsLists,ls_ASurnameBegin[1],ls_ASurnameBegin, False);  // reiniting for next page
    lb_next := True;
    lstl_HTMLAList.Add( CST_HTML_CENTER_BEGIN + fs_CreateElementWithId ( CST_HTML_TABLE , 'list' ));
    lstl_HTMLAList.Add( fs_CreateElementWithId ( CST_HTML_TR , CST_TABLE_TITLE )+
                         fs_Create_TD ( CST_FILE_PERSON, CST_HTML_ID_EQUAL, 2 )+CST_HTML_TD_END+
                         fs_Create_TD ( CST_FILE_PERSON, CST_HTML_ID_EQUAL )+CST_HTML_H2_BEGIN+ ( gs_AnceSTROWEB_Person ) +CST_HTML_H2_END+CST_HTML_TD_END+
                        CST_HTML_TD_BEGIN+CST_HTML_H2_BEGIN+ ( gs_AnceSTROWEB_Born ) +CST_HTML_H2_END+CST_HTML_TD_END+
                        CST_HTML_TD_BEGIN+CST_HTML_H2_BEGIN+ ( gs_AnceSTROWEB_Died ) +CST_HTML_H2_END+CST_HTML_TD_END+
                        CST_HTML_TR_END);
    for li_i := 1 to gi_FilesPerList do
    with IBQ_FilesFiltered do
      begin
        p_IncProgressInd; // growing the second counter
        p_addKeyWord( FieldByName(IBQ_NOM).AsString, '-'); // adding a head's meta keyword
        lb_show := fb_ShowYear( FieldByName(IBQ_ANNEE_NAISSANCE).AsInteger, FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger );
        if lb_show then
          p_addKeyWord( FieldByName(IBQ_PRENOM).AsString); // adding a head's meta keyword
        li_CleFiche :=  FieldByName(IBQ_CLE_FICHE).AsInteger;
        ls_NewSurname :=  FieldByName(IBQ_NOM).AsString;
        case  FieldByName(IBQ_SEXE).AsInteger of
         IBQ_SEXE_MAN   : ls_Sexe := CST_FILE_MAN;
         IBQ_SEXE_WOMAN : ls_Sexe := CST_FILE_WOMAN;
         else
           ls_Sexe := 'file';
        end;

        lstl_HTMLAList.Add( fs_CreateElementWithId ( CST_HTML_TR, ls_Sexe + CST_FILE_Number + IntToStr(li_i), CST_HTML_CLASS_EQUAL ) + CST_HTML_TD_BEGIN );
        if (ls_NewSurname <> ls_ASurnameOrName) Then
         Begin
          if (ls_ASurnameOrName = '') or ((length(ls_NewSurname) > 0) and
            (ls_NewSurname[1] <> ls_ASurnameOrName[1])) then
            lstl_HTMLAList.Add(CST_HTML_A_BEGIN + CST_HTML_NAME_EQUAL + '"' + ls_NewSurname[1] + '" />');
         end;
        ls_ASurnameOrName:= fs_getNameAndSurName( lb_show, ls_NewSurname, FieldByName(IBQ_PRENOM).AsString ); // showed name
        if lb_show then
          lstl_HTMLAList.Add( fs_AddPhoto(li_CleFiche, fs_getaltPhoto(IBQ_FilesFiltered), ls_ImagesDir, 24));   // mini photo
        lstl_HTMLAList.Add(   CST_HTML_TD_END + CST_HTML_TD_BEGIN +
                              CST_HTML_IMAGE_SRC + '../' + CST_SUBDIR_HTML_IMAGES + '/' + ls_Sexe + CST_EXTENSION_GIF + '" />' +
                              CST_HTML_TD_END + CST_HTML_TD_BEGIN +
                              fs_GetNameLink ( fs_RemplaceChar ( ls_ASurnameOrName, ' ', '_' ),IntToStr(li_CleFiche), ls_ASurnameOrName, '../' + CST_SUBDIR_HTML_FILES + '/' ) +
                              CST_HTML_TD_END + fs_Create_TD(CST_TABLE_CENTER) +  fs_addYear (IBQ_ANNEE_NAISSANCE,IBQ_VILLE_NAISSANCE) + // birth
                              CST_HTML_TD_END + fs_Create_TD(CST_TABLE_CENTER) +  fs_addYear (IBQ_ANNEE_DECES,IBQ_VILLE_DECES)+   // death
                              CST_HTML_TR_END); // city of death
        ls_ASurnameEnd :=  FieldByName(IBQ_NOM).AsString;
         Next;
        if  EOF then
         Begin
          lb_next:=False;
          Break;
         end ;
      end;
    lstl_HTMLAList.Add( CST_HTML_TABLE_END + CST_HTML_BR);
    if li_CounterPages - 1 > 0 Then
      lstl_HTMLAList.Add ( fs_CreatePrevNext ( li_CounterPages - 1, CST_PAGE_PREVIOUS, '../', ed_ListsBeginName.Text ));
    if lb_next Then
      lstl_HTMLAList.Add ( fs_CreatePrevNext ( li_CounterPages + 1, CST_PAGE_NEXT, '../', ed_ListsBeginName.Text ));
    lstl_HTMLAList.Add ( CST_HTML_CENTER_END );
    lstl_HTMLAList.Add(CST_HTML_DIV_END);
    p_CreateAHtmlFile(lstl_HTMLAList, CST_FILE_SUBFILES, me_Description.Lines.Text,
      ( gs_AnceSTROWEB_List ) + ' - ' + ls_ASurnameBegin +
      ( gs_AnceSTROWEB_At ) + ls_ASurnameEnd, '', '', gs_LinkGedcom, '..' + CST_HTML_DIR_SEPARATOR);
    // saving the page
    ls_destination := gs_RootPathForExport +
      CST_SUBDIR_HTML_LISTS + DirectorySeparator + ed_ListsBeginName.Text + IntToStr(
      li_CounterPages) + CST_EXTENSION_HTML;
    try
      lstl_HTMLAList.SaveToFile(ls_destination);
    except
      On E: Exception do
      begin
        MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_List + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_ANCESTROWEB_cantCreateHere ) + ls_destination + CST_ENDOFLINE + E.Message);
        Abort;
      end;
    end;
    lstl_HTMLAList.Free;
    Inc(li_CounterPages);
  end;

begin
  if IBQ_FilesFiltered.IsEmpty then
   Begin
    MyMessageDlg({$IFDEF FPC}CST_AncestroWeb_WithLicense,{$ENDIF}
    gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_List + CST_ENDOFLINE + CST_ENDOFLINE +  gs_ANCESTROWEB_Noone_to_show, mtError, [mbOK], 0);
    Abort;
   end;
  p_Setcomments ( gs_AnceSTROWEB_List ); // advert for user
  Finalize ( lt_SheetsLists );
  p_createLettersSheets ( lt_SheetsLists, IBQ_FilesFiltered, gi_FilesPerList, ed_ListsBeginName.Text );
  li_CounterPages := 0;
  pb_ProgressInd.Position := 0; // initing user value
  ls_ImagesDir := gs_RootPathForExport + CST_SUBDIR_HTML_LISTS + DirectorySeparator + CST_SUBDIR_HTML_IMAGES + DirectorySeparator ;
  fb_CreateDirectoryStructure(ls_ImagesDir);
  fb_CreateDirectoryStructure(gs_RootPathForExport + CST_SUBDIR_HTML_LISTS);
  try
    pb_ProgressInd.Max := IBQ_FilesFiltered.RecordCount;
    IBQ_FilesFiltered.First;
  Except
    MyMessageDlg({$IFDEF FPC}CST_AncestroWeb_WithLicense,{$ENDIF}
    gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_List + CST_ENDOFLINE + CST_ENDOFLINE +  gs_ANCESTROWEB_cantOpenData, mtError, [mbOK], 0);
    Exit;
  end;
  p_SelectTabSheet(gt_TabSheets, ( gs_AnceSTROWEB_List ), ''); // current page sheet
  ls_ASurnameOrName := '';
  p_IncProgressBar; // growing the counter
  while not IBQ_FilesFiltered.EOF do
    p_AddAList;
  p_SelectTabSheet(gt_TabSheets, ( gs_AnceSTROWEB_List ), '', False);  // reiniting for next page
end;
function TF_AncestroWeb.fs_AddPhoto( const ai_cleFiche: longint;
const as_FileAltName, as_ImagesDir: string; const ai_ResizeWidth : Integer = 180 ): string;
var li_i : Integer;
begin
  Result := '';

  if not fb_OpenMedias(ai_cleFiche, MEDIAS_TYPE_IMAGE, True, MEDIAS_TABLE_PERSON )
  or DMWeb.IBQ_Medias.FieldByName(MEDIAS_MULTI_MEDIA).IsNull
   then
    Exit;

  Result := fs_getBackupFileName ( as_ImagesDir+ fs_TextToFileName(as_FileAltName+ '-' + IntToStr ( ai_cleFiche )), CST_EXTENSION_JPEG );
  {$IFDEF WINDOWS}
  if ( pos ( ':', Result ) <> 2 )
  {$ELSE}
  if ( pos ( '/', Result ) > 1 )
  {$ENDIF}
   Then
    Result :=  as_ImagesDir + Result;

  if not fb_ImageFieldToFile(DMWeb.IBQ_Medias.FieldByName(MEDIAS_MULTI_MEDIA),
     Result, ai_ResizeWidth)
   then
    Exit;

  Result := fs_Create_Image ( CST_SUBDIR_HTML_IMAGES + CST_HTML_DIR_SEPARATOR + Result, as_FileAltName);
end;

// procedure TF_AncestroWeb.p_genHtmlFiles
// HTML persons' Files generation
procedure TF_AncestroWeb.p_genHtmlFiles(const IBQ_FilesFiltered: TIBQuery);
var
  lstl_HTMLPersons: TStringlistUTF8;
  ls_ASurname, ls_destination: string;
  ls_ImagesDir, ls_ArchivesDir: string;
  li_CounterPages : Longint;
  lstl_listWords, lstl_listSeparat : TUArray;

  // Marriages with source
  function fs_CreateMarried ( const ab_showdate : Boolean; const as_Date, as_dateWriten : String ; const ai_ClefUnion : Longint ): String;
  var ls_FileName, ls_FileNameBegin : String ;
      li_i : Integer ;
  Begin
    if not ( ab_showdate ) Then
      Begin
        Result := '';
        Exit;
      end;
    // getting source
    with DMWeb,IBQ_ConjointSources do
     Begin
      try
        Close;
        ParamByName ( I_CLEF_UNION  ).AsInteger:=ai_ClefUnion;
        Open;
      except
        On E: Exception do
         Begin
          MyShowMessage( gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Union + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData ) + sDataBaseName + CST_ENDOFLINE + E.Message);
          Exit;
         end;
      end;
      Result := ' (' ;
      AppendStr ( Result, gs_ANCESTROWEB_Family_On + as_dateWriten );
      if ch_Images.Checked
      and not EOF Then
        Begin
           // adding source
          if IBS_Conjoint.FieldByName(IBQ_SEXE).AsInteger = IBQ_SEXE_WOMAN
          Then ls_FileNameBegin := fs_getNameAndSurName (IBQ_FilesFiltered )+'&'+fs_getNameAndSurName (IBS_Conjoint)
          Else ls_FileNameBegin := fs_getNameAndSurName (IBS_Conjoint)+'&'+fs_getNameAndSurName (IBQ_FilesFiltered);
          ls_FileNameBegin := as_Date + '_ID'+fs_TextToFileName(IBS_Conjoint.FieldByName(IBQ_CLE_FICHE).AsString + '_' + ls_FileNameBegin+'_'+
                              IBS_Conjoint.FieldByName(UNION_CP).AsString+'_'+IBS_Conjoint.FieldByName(UNION_CITY).AsString )+ '_';
          li_i := 1 ;

          // medias
          while not EOF do
            Begin
              ls_FileName := ls_FileNameBegin + IntToStr(li_i);
              if fb_getMediaFile ( IBQ_ConjointSources, dm.FileCopy, gs_RootPathForExport + CST_SUBDIR_HTML_ARCHIVE + DirectorySeparator,fFolderBasePath, ls_FileName, ch_nooriginalphoto.Checked ) Then
                Begin
                  AppendStr( Result, ' - ' +fs_Create_Link ( CST_HTML_OUTDIR_SEPARATOR + CST_SUBDIR_HTML_ARCHIVE + CST_HTML_DIR_SEPARATOR + ls_FileName +CST_EXTENSION_JPEG,
                                                             gs_ANCESTROWEB_ArchiveLinkBegin + IntToStr(li_i), CST_HTML_TARGET_BLANK, CST_HTML_SHADOWBOX ));
                  inc ( li_i );
                End;

              Next;
            End
        end;
     end;
    AppendStr( Result, ')' );
  end;

  // add an event date with city
  function fs_addDateAndCity ( const IBQ_FicheInfos : TIBSQL ; const as_date,as_year, as_City, as_manon, as_womanon : String ):String ;
  begin

    // is there an info
    with IBQ_FicheInfos do
    if not FieldByName(as_date).IsNull and fb_ShowYear(FieldByName(as_year).AsInteger,FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger) Then
      Begin
        if FieldByName(IBQ_SEXE).AsInteger = IBQ_SEXE_WOMAN
         Then Result := as_womanon
         Else Result := as_manon   ;
        AppendStr ( Result, FieldByName(as_date).AsString ) ;
        if FieldByName(as_City).AsString > '' Then
          AppendStr ( Result, ( gs_AnceSTROWEB_At ) + fs_getLinkedCity(FieldByName(as_City).AsString));
        AppendStr ( Result, CST_HTML_BR );
        End
       Else Result := '';
  end;

  // person's infos
  procedure p_AddJobs ( const astl_HTMLAFolder : TStringlistUTF8 ; const ai_CleFiche, ai_NoInPage : LongInt  );
  var ls_Line : String ;
  Begin
    with DMWeb.IBS_JobsInd do
     Begin
      try
        Close;
        ParamByName ( IBQ_CLE_FICHE ).AsInteger:=ai_CleFiche;
        ExecQuery;
      except
        On E: Exception do
         Begin
          MyShowMessage( gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Job + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData ) + sDataBaseName + CST_ENDOFLINE + E.Message);
          Exit;
         end;
      end;
      if not Eof Then  // Job(s) ?
        Begin
          // title
         astl_HTMLAFolder.Add ( fs_CreateElementWithId ( CST_HTML_H3    , CST_FILE_JOBS
                                                            + CST_FILE_Number + IntToStr( ai_NoInPage ),CST_HTML_CLASS_EQUAL));
         if RecordCount = 1  // 1 or more jobs ?
          Then astl_HTMLAFolder.Add (( gs_ANCESTROWEB_Job   ))
          else astl_HTMLAFolder.Add (( gs_ANCESTROWEB_Jobs  ));
         astl_HTMLAFolder.Add ( CST_HTML_H3_END );  // title end
         astl_HTMLAFolder.Add ( fs_CreateElementWithId ( CST_HTML_UL, CST_FILE_JOBS
                                                            + CST_FILE_Number + IntToStr( ai_NoInPage ),CST_HTML_CLASS_EQUAL));
         while not EOF do  // adding all jobs
          Begin
           astl_HTMLAFolder.Add ( fs_CreateElementWithId ( CST_HTML_LI, CST_FILE_JOB + CST_FILE_Number + IntToStr( ai_NoInPage ),CST_HTML_CLASS_EQUAL)
                                + fs_getLinkedJob( FieldByName(IBQ_EV_IND_DESCRIPTION).AsString, ai_CleFiche ));
           if FieldByName(IBQ_EV_IND_VILLE).AsString > '' Then
           astl_HTMLAFolder.Add ( ' ' + gs_ANCESTROWEB_At + ' '
                                + fs_getLinkedCity(FieldByName(IBQ_EV_IND_VILLE).AsString));
           if ( FieldByName(IBQ_EV_IND_PAYS).AsString > '' )
           or (( FieldByName(IBQ_EV_IND_DATE).AsString > '' ) and fb_Showdate(FieldByName(IBQ_EV_IND_DATE).AsDateTime,FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger))
             Then
              Begin
               ls_Line := '(' ;
               if FieldByName(IBQ_EV_IND_PAYS).AsString > '' Then
                AppendStr ( ls_line, FieldByName(IBQ_EV_IND_PAYS).AsString );
               if  ( FieldByName(IBQ_EV_IND_PAYS).AsString > '' )
               and (( FieldByName(IBQ_EV_IND_DATE).AsString > '' ) and fb_Showdate(FieldByName(IBQ_EV_IND_DATE).AsDateTime,FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger)) Then
                 AppendStr ( ls_line,  ' - ' );
               if not FieldByName(IBQ_EV_IND_DATE).IsNull and fb_Showdate(FieldByName(IBQ_EV_IND_DATE).AsDateTime,FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger) Then
                AppendStr ( ls_line, FormatDateTime(gs_ANCESTROWEB_LittleDateFormat,FieldByName(IBQ_EV_IND_DATE).AsDateTime));
               astl_HTMLAFolder.Add ( ls_line + ')' );
              end;
           astl_HTMLAFolder.Add ( CST_HTML_LI_END);
           Next;
          end;

         astl_HTMLAFolder.Add ( CST_HTML_UL_END );  // list end
        end;
     end;
  End;
  procedure p_AddInfos ( const astl_HTMLAFolder : TStringlistUTF8 ; const ai_CleFiche, ai_NoInPage : LongInt  );
  var ls_NameSurname : String ;
  Begin
   with DMWeb,IBS_Conjoint do
    try
      // Married ?
      Close;
      ParamByName ( I_CLEF    ).AsInteger:=ai_CleFiche;
      ExecQuery;
      // getting file
      IBS_Fiche.Close;
      IBS_Fiche.ParamByName(I_CLEF).AsInteger := ai_CleFiche;
      IBS_Fiche.ExecQuery;
      // birthday
      astl_HTMLAFolder.Add ( fs_addDateAndCity ( IBS_Fiche, IBQ_DATE_NAISSANCE, IBQ_ANNEE_NAISSANCE, IBQ_LIEU_NAISSANCE, ( gs_ANCESTROWEB_ManBornOn ), ( gs_ANCESTROWEB_WomanBornOn )));
      // deathday
      astl_HTMLAFolder.Add ( fs_addDateAndCity ( IBS_Fiche, IBQ_DATE_DECES, IBQ_ANNEE_DECES, IBQ_LIEU_DECES, ( gs_ANCESTROWEB_ManDiedOn ), ( gs_ANCESTROWEB_WomanDiedOn )) + CST_HTML_BR);
      // Jobs ?
      p_AddJobs ( astl_HTMLAFolder, ai_CleFiche, ai_NoInPage );
      if not Eof Then  // Husband
        Begin
          // title
         astl_HTMLAFolder.Add ( fs_CreateElementWithId ( CST_HTML_H3    , CST_FILE_UNION + 's'
                                                            + CST_FILE_Number + IntToStr( ai_NoInPage ),CST_HTML_CLASS_EQUAL));
         if DMWeb.IBS_Conjoint.RecordCount = 1  // 1 or more husbands and ex ?
          Then astl_HTMLAFolder.Add (( gs_AnceSTROWEB_Union   ))
          else astl_HTMLAFolder.Add (( gs_AnceSTROWEB_Unions  ));
         astl_HTMLAFolder.Add ( CST_HTML_H3_END );  // title end
         astl_HTMLAFolder.Add ( fs_CreateElementWithId ( CST_HTML_UL, CST_FILE_UNION + 's'
                                                            + CST_FILE_Number + IntToStr( ai_NoInPage ),CST_HTML_CLASS_EQUAL));
         while not EOF do  // adding all husbands
          Begin
           ls_NameSurname := fs_getNameAndSurName ( IBS_Conjoint );
           astl_HTMLAFolder.Add ( fs_CreateElementWithId ( CST_HTML_LI, CST_FILE_UNION + CST_FILE_Number + IntToStr( ai_NoInPage ),CST_HTML_CLASS_EQUAL));
           if not ch_Filtered.Checked
           or fb_IsCreatedPerson(FieldByName(IBQ_CLE_FICHE).AsInt64)
            Then astl_HTMLAFolder.Add ( fs_GetNameLink ( fs_RemplaceChar(ls_NameSurname,' ', '_'), FieldByName(IBQ_CLE_FICHE).AsString, ls_NameSurname))
            Else astl_HTMLAFolder.Add ( ls_NameSurname );
           astl_HTMLAFolder.Add ( fs_CreateMarried ( not FieldByName(UNION_DATE_MARIAGE).IsNull ,
                                                     fs_RemplaceChar ( FieldByName(UNION_DATE_MARIAGE).AsString, '/', '-' ) ,
                                                     FieldByName(UNION_MARIAGE_WRITEN).AsString ,
                                                     FieldByName(UNION_CLEF).AsInteger));
           astl_HTMLAFolder.Add ( CST_HTML_LI_END);
           Next;
          end;

         astl_HTMLAFolder.Add ( CST_HTML_UL_END );  // list end
        end;
    except
      On E: Exception do
       Begin
        MyShowMessage( gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Jobs + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData ) + sDataBaseName + CST_ENDOFLINE + E.Message);
        Exit;
       end;
    end;
  end;
  // ancestry and descent trees
  procedure p_AddTrees ( const astl_HTMLAFolder : TStringlistUTF8 ; const ai_CleFiche, ai_NoInPage : LongInt ; const ab_show : Boolean );
  var
    lstl_Tree: TStringlistUTF8;
    li_generations: longint;
    lb_AddAncestry : Boolean ;
  begin
   // adding a line and cell in the table
    astl_HTMLAFolder.Add(CST_HTML_TR_BEGIN + CST_HTML_TD_BEGIN );
    lstl_Tree := TStringlistUTF8.Create;
    if fb_OpenTree(DMWeb.IBQ_TreeAsc, ai_CleFiche, 3)
     Then lb_AddAncestry := not DMWeb.IBQ_TreeAsc.EOF
     Else lb_AddAncestry := False;
     // descent
    if ab_show
    and fb_OpenTree(DMWeb.IBQ_TreeDesc, ai_CleFiche, 3)
    and ( not DMWeb.IBQ_TreeDesc.EOF ) then
    begin
      li_generations :=
        fi_CreateHTMLTree(DMWeb.IBQ_TreeDesc, lstl_Tree, ai_CleFiche,
        False, False, False, True, IBQ_TQ_NUM_SOSA, False);
      lstl_Tree.Insert(0, fs_Create_DIV('descent' + CST_FILE_Number + IntToStr(ai_NoInPage), CST_HTML_CLASS_EQUAL) + fs_GetTitleTree (( gs_AnceSTROWEB_Descent ), li_generations ));
      astl_HTMLAFolder.AddStrings(lstl_Tree);
      astl_HTMLAFolder.Add(CST_HTML_DIV_End);
      if lb_AddAncestry then
        astl_HTMLAFolder.Add(CST_HTML_BR);
    end;
    // ancestry
    if lb_AddAncestry then
    begin
      lstl_Tree.Clear;
      li_generations :=
        fi_CreateHTMLTree(DMWeb.IBQ_TreeAsc, lstl_Tree, ai_CleFiche, False, False, False);
      lstl_Tree.Insert(0, fs_Create_DIV('ancestry' + CST_FILE_Number + IntToStr(ai_NoInPage),CST_HTML_CLASS_EQUAL) + fs_GetTitleTree (( gs_AnceSTROWEB_Ancestry ), li_generations ));
      astl_HTMLAFolder.AddStrings(lstl_Tree);
      astl_HTMLAFolder.Add(CST_HTML_DIV_End);
    end;
    // line end
    astl_HTMLAFolder.Add(CST_HTML_TD_END + CST_HTML_TR_END);
    lstl_Tree.Free;
  end;

  // procedure p_AddAFolder
  // adding persons' folder page
  procedure p_AddAFolder;
  var
    lstl_HTMLAFolder: TStringlistUTF8;
    ls_NewSurname, ls_ASurnameBegin, ls_ASurnameSurname, ls_ASurnameEnd: string;
    li_CleFiche: longint;
    lb_next, lb_show : Boolean ;
    procedure p_ScrollAPage;
    var li_i : integer;
    Begin
      with IBQ_FilesFiltered do
      for li_i := 1 to gi_FilesPerPage do
      begin
        p_IncProgressInd; // growing the second counter
        li_CleFiche := FieldByName(IBQ_CLE_FICHE).AsInteger;
        ls_ASurnameSurname := fs_RemplaceEspace ( fs_getNameAndSurName(IBQ_FilesFiltered) + '_' + IntToStr(li_CleFiche), '_' );
        // adding html head's meta-keywords
        p_addKeyWord(FieldByName(IBQ_NOM).AsString, '-'); // adding a head's meta keyword
        lb_show := fb_ShowYear( FieldByName(IBQ_ANNEE_NAISSANCE).asinteger,FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger );
        if lb_show then
          p_addKeyWord(FieldByName(IBQ_PRENOM).AsString); // adding a head's meta keyword
        ls_NewSurname := FieldByName(IBQ_NOM).AsString;
        if (ls_NewSurname <> ls_ASurname) Then
         Begin
          if (ls_ASurname = '') or ((length(ls_NewSurname) > 0) and
            (ls_NewSurname[1] <> ls_ASurname[1])) then
            lstl_HTMLAFolder.Add(fs_create_anchor ( ls_NewSurname[1] ))
          else if (ls_ASurname = '') then
            lstl_HTMLAFolder.Add(CST_HTML_A_BEGIN + CST_HTML_NAME_EQUAL + '"A" />');
          if length ( ls_NewSurname ) > 1 Then
            lstl_HTMLAFolder.Add(fs_create_anchor ( ls_NewSurname ));
         end;
        ls_ASurname := ls_NewSurname;
        case FieldByName(IBQ_SEXE).AsInteger of
         IBQ_SEXE_MAN   : ls_NewSurname := CST_FILE_MAN;
         IBQ_SEXE_WOMAN : ls_NewSurname := CST_FILE_WOMAN;
         else
           ls_NewSurname := 'file';
        end;
        lstl_HTMLAFolder.Add(fs_create_anchor ( ls_ASurnameSurname ));
        lstl_HTMLAFolder.Add(CST_HTML_BR + fs_CreateElementWithId ( CST_HTML_TABLE , ls_NewSurname + CST_FILE_Number + IntToStr(li_i) , CST_HTML_CLASS_EQUAL ) +
          CST_HTML_TR_BEGIN + fs_Create_TD ( ls_NewSurname + CST_FILE_Number + IntToStr(li_i), CST_HTML_CLASS_EQUAL, 2 ));
        lstl_HTMLAFolder.Add( CST_HTML_DIV_BEGIN + '<' + CST_HTML_H2 + CST_HTML_ID_EQUAL +'"subtitle">' + CST_HTML_IMAGE_SRC + '../'
                             + CST_SUBDIR_HTML_IMAGES + '/' + ls_NewSurname + CST_EXTENSION_GIF + '" />' + fs_getLinkedSurName ( ls_ASurname ) +
          ' ' + fs_getLinkedName ( FieldByName(IBQ_PRENOM).AsString, lstl_listWords,FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger ) + fs_AddComma(fs_GetSOSA(IBQ_FilesFiltered)) + CST_HTML_H2_BEGIN + CST_HTML_DIV_END);
        lstl_HTMLAFolder.Add(CST_HTML_TD_END + CST_HTML_TR_END  + CST_HTML_TR_BEGIN  + CST_HTML_TD_BEGIN);
        if lb_show then
         Begin
          p_AddInfos ( lstl_HTMLAFolder, li_CleFiche, li_i );
          lstl_HTMLAFolder.Add(CST_HTML_TD_END);
          lstl_HTMLAFolder.Add( fs_AddImageTable(fs_AddPhoto( li_CleFiche, fs_getaltPhoto(IBQ_FilesFiltered), ls_ImagesDir)));
         end
        Else
          lstl_HTMLAFolder.Add(CST_HTML_TD_END);
        lstl_HTMLAFolder.Add( CST_HTML_TR_END );
        p_AddTrees ( lstl_HTMLAFolder, li_CleFiche, li_i, lb_show );
        lstl_HTMLAFolder.Add( CST_HTML_TABLE_END + CST_HTML_BR);
        ls_ASurnameEnd := FieldByName(IBQ_NOM).AsString;
        Next;
        if EOF then
         Begin
          lb_next:=False;
          Break;
         end ;
      end;
    end;

  begin
    p_CreateKeyWords;
    lstl_HTMLAFolder := TStringlistUTF8.Create;
    try
      ls_ASurnameBegin := IBQ_FilesFiltered.FieldByName(IBQ_NOM).AsString;
      ls_ASurnameSurname := fs_RemplaceEspace ( fs_getNameAndSurName(IBQ_FilesFiltered), '_' );
      if (ls_ASurnameBegin > '') and ( ls_ASurnameSurname > '' ) then
        p_SelectTabSheet(gt_SheetsLetters,ls_ASurnameSurname[1],ls_ASurnameSurname); // current letter sheet
      lstl_HTMLAFolder.Text := fs_CreateULTabsheets(gt_SheetsLetters, '', CST_HTML_SUBMENU)+CST_HTML_DIV_BEGIN; // Creating the letters' sheets
      if (ls_ASurnameBegin > '') and ( ls_ASurnameSurname > '' ) then
        p_SelectTabSheet(gt_SheetsLetters,ls_ASurnameSurname[1],ls_ASurnameSurname, False);  // reiniting for next page
      lb_next := True;
      lstl_HTMLAFolder.Add( CST_HTML_CENTER_BEGIN );
      lstl_HTMLAFolder.Add(CST_HTML_CENTER_BEGIN + fs_RemplaceMsg(gs_ANCESTROWEB_Page_of,[IntToStr(li_CounterPages+1),IntToStr(gi_PagesCount)])+ CST_HTML_CENTER_END );
      p_ScrollAPage;
      if li_CounterPages > 0 Then
        lstl_HTMLAFolder.Add ( fs_CreatePrevNext ( li_CounterPages - 1, CST_PAGE_PREVIOUS, '../', ed_FileBeginName.Text ));
      if lb_next Then
        lstl_HTMLAFolder.Add ( fs_CreatePrevNext ( li_CounterPages + 1, CST_PAGE_NEXT, '../', ed_FileBeginName.Text ));
      lstl_HTMLAFolder.Add ( CST_HTML_CENTER_END );
      lstl_HTMLAFolder.Add(CST_HTML_DIV_END);
      p_CreateAHtmlFile(lstl_HTMLAFolder, CST_FILE_SUBFILES, me_Description.Lines.Text,
        ( gs_AnceSTROWEB_Files ) + ' - ' + ls_ASurnameBegin +
        ( gs_AnceSTROWEB_At ) + ls_ASurnameEnd, '', '', gs_LinkGedcom, '..' + CST_HTML_DIR_SEPARATOR);

      // saving the page
      ls_destination := gs_RootPathForExport +
        CST_SUBDIR_HTML_FILES + DirectorySeparator + ed_FileBeginName.Text + IntToStr(
        li_CounterPages) + CST_EXTENSION_HTML;
      try
        lstl_HTMLAFolder.SaveToFile(ls_destination);
      except
        On E: Exception do
        begin
          MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Files + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_ANCESTROWEB_cantCreateHere ) + ls_destination + CST_ENDOFLINE + E.Message);
          Abort;
        end;
      end;
    finally
      lstl_HTMLAFolder.Free;
      Inc(li_CounterPages);
    end;
  end;

begin
  p_Setcomments ( gs_AnceSTROWEB_Files ); // advert for user
  li_CounterPages := 0;
  pb_ProgressInd.Position := 0; // initing not needed user value
  ls_ImagesDir := gs_RootPathForExport + CST_SUBDIR_HTML_FILES +
    DirectorySeparator + CST_SUBDIR_HTML_IMAGES + DirectorySeparator;
  ls_ArchivesDir := gs_RootPathForExport + CST_SUBDIR_HTML_ARCHIVE +
    DirectorySeparator ;
  fb_CreateDirectoryStructure(ls_ImagesDir);
  fb_CreateDirectoryStructure(ls_ArchivesDir);
  pb_ProgressInd.Max := IBQ_FilesFiltered.RecordCount;
  IBQ_FilesFiltered.First;
  p_SelectTabSheet(gt_TabSheets, ( gs_AnceSTROWEB_Files ), '', False); // current page sheet
  ls_ASurname := '';
  with FileCopy do
    Begin
      FileOptions:=FileOptions+[cpDestinationIsFile];
      while not IBQ_FilesFiltered.EOF do
        p_AddAFolder;
      FileOptions:=FileOptions-[cpDestinationIsFile];
    end;
  lstl_HTMLPersons := TStringlistUTF8.Create;
  lstl_HTMLPersons.Text := fs_CreateULTabsheets(gt_SheetsLetters,
    CST_SUBDIR_HTML_FILES + CST_HTML_DIR_SEPARATOR, CST_HTML_SUBMENU)
    +CST_HTML_DIV_BEGIN+
    CST_HTML_CENTER_BEGIN + '<' + CST_HTML_Paragraph +
    CST_HTML_ID_EQUAL + '"head">' + fs_Format_Lines(
    me_FilesHead.Text) + CST_HTML_Paragraph_END;
  lstl_HTMLPersons.Add(CST_HTML_CENTER_END);
  p_CreateKeyWords;
  pb_ProgressInd.Position := 0; // initing not needed user value
  lstl_HTMLPersons.Add(CST_HTML_DIV_END);
  p_CreateAHtmlFile(lstl_HTMLPersons, CST_FILE_FILES, me_FilesHead.Lines.Text,
    ( gs_AnceSTROWEB_Files ), gs_AnceSTROWEB_Files, gs_ANCESTROWEB_Files_Long, gs_LinkGedcom);
  p_IncProgressBar; // growing the counter

  // saving the page
  ls_destination := gs_RootPathForExport +
    ed_FileBeginName.Text + CST_EXTENSION_HTML;
  try
    lstl_HTMLPersons.SaveToFile(ls_destination);
  except
    On E: Exception do
    begin
      MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Files + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_ANCESTROWEB_cantCreateHere ) + ls_destination + CST_ENDOFLINE + E.Message);
      Abort;
    end;
  end;
  lstl_HTMLPersons.Free;
  p_genHtmlList(IBQ_FilesFiltered);
end;

// procedure TF_AncestroWeb.p_genPhpContact
// HTML page form sending mail
procedure TF_AncestroWeb.p_genPhpContact;
var
  lstl_HTMLContact: TStringlistUTF8;
  lstl_HTMLContactBeforeHTML: TStringlistUTF8;
  ls_destination: string;
begin
  p_Setcomments ( gs_AnceSTROWEB_Contact ); // advert for user
  lstl_HTMLContact := TStringlistUTF8.Create;
  lstl_HTMLContactBeforeHTML := TStringlistUTF8.Create;
  p_LoadStringList(lstl_HTMLContact, CST_FILE_ContactInBody + CST_EXTENSION_PHP);

  // setting begining HTML page values
  p_ReplaceLanguageString(lstl_HTMLContact,CST_HTML_CAPTION,gs_ANCESTROWEB_MailCaption);
  p_ReplaceLanguageString(lstl_HTMLContact,CST_HTML_HEAD_DESCRIBE,StringReplace (me_ContactHead.Lines.Text, CST_ENDOFLINE, CST_HTML_BR, [rfReplaceAll]));
  p_ReplaceLanguagesStrings ( lstl_HTMLContact, CST_HTML_CONTACT_IN_LANG );
  // loading PHP page
  p_LoadStringList(lstl_HTMLContactBeforeHTML, CST_FILE_ContactBefore + CST_EXTENSION_PHP);

  // setting PHP page
  if cb_ContactSecurity.ItemIndex >= 0 Then
    p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_SECURITY,cb_ContactSecurity.Items[cb_ContactSecurity.ItemIndex]);
  if cb_ContactTool.ItemIndex >= 0 Then
    p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_MAILER,cb_ContactTool.Items[cb_ContactTool.ItemIndex]);
  p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_HOST,ed_ContactHost.Text);
  p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_FILE,ed_ContactName.Text+CST_EXTENSION_PHP);
  p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_LANG,gs_Lang);
  p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_PASSWORD,ed_ContactPassword.Text);
  p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_AUTHOR,ed_ContactAuthor.Text);
  p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_IDENTIFY,UTF8LowerCase(BoolToStr(ch_ContactIdentify.Checked)));
  p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_MAIL,ed_ContactMail.Text);
  p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_USERNAME,ed_ContactUser.Text);
  p_ReplaceLanguageString(lstl_HTMLContactBeforeHTML,CST_CONTACT_PORT,se_ContactPort.Text);

  // Head key words
  p_CreateKeyWords;
  pb_ProgressInd.Position := 0; // initing not needed user value

  // finishing creating the page
  p_CreateAHtmlFile(lstl_HTMLContact, CST_FILE_Contact, me_ContactHead.Lines.Text,
    ( gs_AnceSTROWEB_Contact ), gs_AnceSTROWEB_Contact, gs_ANCESTROWEB_MailCaption, gs_LinkGedcom,
    '', CST_EXTENSION_PHP, lstl_HTMLContactBeforeHTML.Text);

  // growing the counter
  p_IncProgressBar; // growing the counter

  // saving the page
  ls_destination := gs_RootPathForExport + ed_ContactName.Text + CST_EXTENSION_PHP;
  try
    lstl_HTMLContact.SaveToFile(ls_destination);
  except
    On E: Exception do
    begin
      MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Contact + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_AnceSTROWEB_cantCreateContact ) + ls_destination + CST_ENDOFLINE + E.Message);
      Abort;
    end;
  end;
  lstl_HTMLContact.Free;
  lstl_HTMLContactBeforeHTML.Free;
end;

// procedure TF_AncestroWeb.p_genHtmlSearch
// Search engine HTML page request
procedure TF_AncestroWeb.p_genHtmlSearch;
var
  lstl_HTMLSearch: TStringlistUTF8;
  ls_destination: string;
begin
  p_Setcomments ( gs_AnceSTROWEB_Search ); // advert for user
  pb_ProgressInd.Position := 0; // initing not needed user value
  lstl_HTMLSearch := TStringlistUTF8.Create;
  p_CreateAHtmlFile(lstl_HTMLSearch, CST_FILE_SEARCH, me_searchHead.Lines.Text,
        ( gs_AnceSTROWEB_Search ), gs_AnceSTROWEB_Search, gs_ANCESTROWEB_SearchLong, gs_LinkGedcom, '');

  // setting page values from Tabsheet
  p_ReplaceLanguageString(lstl_HTMLSearch,CST_HTML_HEAD_DESCRIBE, StringReplace(me_searchHead.Text,CST_ENDOFLINE,'<BR />',[]));
  p_ReplaceLanguageString(lstl_HTMLSearch,CST_HTML_SEND      , ( gs_AnceSTROWEB_Send  ));
  p_ReplaceLanguageString(lstl_HTMLSearch,CST_HTML_RESET     , ( gs_AnceSTROWEB_Reset ));
  p_ReplaceLanguageString(lstl_HTMLSearch,CST_SEARCH_DOMAIN  ,Trim(ed_SearchSite.Text));
  p_ReplaceLanguageString(lstl_HTMLSearch,CST_SEARCH_SEARCH  , ( gs_AnceSTROWEB_Search ));
  p_ReplaceLanguageString(lstl_HTMLSearch,CST_SEARCH_SEARCH  , ( gs_AnceSTROWEB_Search ));
  p_ReplaceLanguageString(lstl_HTMLSearch,CST_SEARCH_SEARCH_QUER  ,ed_SearchQuery.Text);
  p_ReplaceLanguageString(lstl_HTMLSearch,CST_SEARCH_SEARCH_TOOL  ,ed_SearchTool.Text);

  // saving the page
  ls_destination := gs_RootPathForExport + ed_SearchName.Text  + CST_EXTENSION_HTML;
  try
    lstl_HTMLSearch.SaveToFile(ls_destination);
  except
    On E: Exception do
    begin
      MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_cantCreateContact ) + ls_destination + CST_ENDOFLINE + E.Message);
      Abort;
    end;
  end;
  lstl_HTMLSearch.Free;
end;

// function TF_AncestroWeb.fs_getLinkedBase
// Optional link to external site
function TF_AncestroWeb.fs_getLinkedFormated ( as_Label : String; const as_Texte, as_Link : String ) : String;
const CST_FIRST_LETTER = '[first_letter]';
      CST_LABEL        = '[label]';
Begin
  Result := as_Link;
  if as_Label = '' Then as_Label := '_';
  Result := StringReplace(Result,CST_FIRST_LETTER,as_Label[1],[rfReplaceAll,rfIgnoreCase]);
  Result := StringReplace(Result,CST_LABEL       ,as_Label   ,[rfReplaceAll,rfIgnoreCase]);
end;

procedure p_getBeginingOfString ( var as_chaine : String ; const achar : Char );
var li_pos : Integer;
Begin
  li_pos:=pos(achar,as_chaine); // stopping at comma
  if li_pos > 1 Then
   as_chaine := trim ( copy ( as_chaine, 1, li_pos - 1 ));
end;

// function TF_AncestroWeb.fs_getLinkedBase
// Optional link to external site
function TF_AncestroWeb.fs_getLinkedBaseImage ( const as_Texte : String; const as_Link : String; const ai_ComboIndex : Integer ; const ab_StopMore : Boolean = False) : String;
var li_pos : Integer;
Begin
  Result := StringReplace ( as_Texte, '"', '\"',[rfReplaceAll]);
//  if pos ( 'Fran', as_Texte ) > 0 Then
//         MyShowMessage(as_Texte );
  case ai_ComboIndex of
   0, 3 : Result:=fs_FormatText(Result,mftFirstIsMaj,ai_ComboIndex<3); // Sans accent ou avec accents avec une majuscule
   1, 4 : Result:=fs_FormatText(Result,mftLower,ai_ComboIndex<3); // Sans accent ou avec accents sans majuscule
   2, 5 : Result:=fs_FormatText(Result,mftUpper,ai_ComboIndex<3); // Sans accent ou avec accents en majuscules
  end;

  p_getBeginingOfString ( Result, ',' ); // stopping at comma
  p_getBeginingOfString ( Result, '('); // stopping at (
  if not ab_StopMore Then
    p_getBeginingOfString ( Result, '-'); // stopping at -

  Result := StringReplace ( Result,' ','-',[rfReplaceAll]);

  li_pos := pos ( '[', as_Link );  // searching replacing strings for text
  if  ( li_pos > 0 )
  and ( pos ( ']', as_Link ) > li_pos )
    Then Result := fs_getLinkedFormated ( Result, as_Texte, as_Link )
    Else Result := as_Link+Result;
End;


// function TF_AncestroWeb.fs_getLinkedBase
// Optional link to external site
function TF_AncestroWeb.fs_getLinkedBase ( const as_ShowedText, as_Texte : String; const as_Link : String; const ai_ComboIndex : Integer ; const ab_StopMore : Boolean = False) : String;
var li_pos : Integer;
Begin
 Result:=fs_Create_Link(fs_getLinkedBaseImage ( as_Texte, as_Link, ai_ComboIndex, ab_StopMore ), as_ShowedText, CST_HTML_TARGET_BLANK, CST_HTML_SHADOWBOX );
End;


// function TF_AncestroWeb.fs_getLinkedBase
// Optional link to external site
function TF_AncestroWeb.fs_getLinkedImage ( const as_Texte : String; const as_Link : String; const ai_ComboIndex, ai_counter : Integer ) : String;
var li_pos : Integer;
Begin
 Result:='<DIV ID="IMAGE_N'+IntToStr(ai_counter)+'"></DIV><script>writeImage('''+ StringReplace( StringReplace(fs_getLinkedBaseImage ( as_Texte, as_Link, ai_ComboIndex ),'''','\''',[rfReplaceAll]),'"','\"',[rfReplaceAll])+''','''+
                                  StringReplace( StringReplace(as_Texte,'''','\''',[rfReplaceAll]),'"','\"',[rfReplaceAll])+''',32, ''IMAGE_N'+IntToStr(ai_counter)+''');</script> ';
End;

// function TF_AncestroWeb.fs_getLinkedName
// Optional link to Name site
function TF_AncestroWeb.fs_getLinkedName ( const as_Texte : String ; var aa_listWords : TUArray ; const av_confidential : Integer ) :  String;
var
    li_i : Integer;
    ls_Text : String;
Begin
  if  ( av_confidential > 0 )
  and ( as_Texte > '' ) Then
   Begin
    Result := as_Texte [1] + '.';
    Exit;
   end;
  if not ch_NamesLink.Checked
  or ( Trim ( as_Texte ) = '' ) Then
   Begin
    Result := as_Texte;
    Exit;
   end;
  Result := '';
  Finalize ( aa_listWords );
  fb_stringConstruitListe(as_texte,aa_listWords);
  for li_i := 0 to high ( aa_listWords ) do
   Begin
     ls_Text := Trim ( copy ( as_Texte, aa_listWords [ li_i ][0], aa_listWords [ li_i ][1] ));
     AppendStr ( Result, fs_getLinkedBase ( ls_Text, ls_Text, ed_BaseNames.Text, cb_NamesAccents.ItemIndex ));
//       if pos ( 'Fran', copy ( as_Texte, aa_listWords [ li_i ][0], aa_listWords [ li_i ][1] ) ) > 0 Then
//       MyShowMessage( copy ( as_Texte, aa_listWords [ li_i ][0], aa_listWords [ li_i ][1] ));
     if  ( aa_listWords [ li_i ][2] <> 0 )
      Then AppendStr(Result, '-' )
      Else AppendStr(Result, ' ' );
   end;
End;

// function TF_AncestroWeb.fs_getLinkedSurName
// Optional link to SurName site
function TF_AncestroWeb.fs_getLinkedSurName ( const as_Texte : String ) : String;
var ls_Text : String ;
Begin
  ls_Text := Trim ( as_Texte );
  if not ch_SurNamesLink.Checked
  or ( ls_Text = '' ) Then
   Begin
    Result := ls_Text;
    Exit;
   end;
  Result := fs_getLinkedBase ( ls_Text, ls_Text, ed_BaseSurnames.Text, cb_SurnamesAccents.ItemIndex );
End;

// function TF_AncestroWeb.fs_getLinkedCity
// Optional link to City site
function TF_AncestroWeb.fs_getLinkedCity ( const as_Texte : String ) : String;
var ls_Text : String ;
Begin
  ls_Text := Trim ( as_Texte );
  if not ch_CitiesLink.Checked
  or ( ls_Text = '' ) Then
   Begin
    Result := ls_Text;
    Exit;
   end;
  Result := fs_getLinkedBase ( ls_Text , ls_Text , ed_BaseCities.Text, cb_CityAccents.ItemIndex, True );
End;

// function TF_AncestroWeb.fs_getLinkedJob
// Optional link to job site
function TF_AncestroWeb.fs_getLinkedJob ( const as_Texte : String; const ai_counter : Integer ) : String;
var ls_Text : String ;
Begin
  ls_Text := Trim ( as_Texte );
  Result := '' ;
  if ls_Text = ''
   Then Exit; // rien donc rien en retour

  if ch_JobsImages.Checked // image
   Then Result := fs_getLinkedImage( ls_Text, ed_ImagesJobs.Text, cb_ImagesJobsAccents.ItemIndex, ai_counter ) + ' ' ;

  if ch_JobsLink.Checked // lien
   Then Result := fs_getLinkedBase ( Result + ls_Text, ls_Text, ed_BaseJobs.Text, cb_JobsAccents.ItemIndex, True )
   Else Result := as_Texte;

End;

// procedure TF_AncestroWeb.p_genHtmlAges
// Ages : HTML page creating
procedure TF_AncestroWeb.p_genHtmlAges;
var
  lstl_HTMLAges ,
  lstl_HTMLAges2,
  lstl_HTMLLines: TStringlistUTF8;
  ls_destination: string;

  procedure p_addLines;
    var
      li_Age, li_Linecounter, li_countTotal, li_MenTotal, li_WomenTotal : Longint;

      // Setting not replaced values
      procedure p_setHtmlReplaceValues;
      Begin
        p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_COUNT      , IntToStr(li_Linecounter),[]);
        p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_MEN_COUNT  , CST_ZERO          ,[]);
        p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_WOMEN_COUNT, CST_ZERO          ,[]);
      end;
      procedure p_setLine;
      begin
        with DMWeb.IBS_Ages do
          Begin
          // first and next line
          if li_Age <> FieldByName(IBQ_AGE_AU_DECES).AsInteger Then
            Begin
              p_setHtmlReplaceValues ;
              p_ReplaceLanguageString(lstl_HTMLAges,CST_AGES_LINES  ,lstl_HTMLLines.Text+'['+CST_AGES_LINES+']');
              li_Age:= FieldByName(IBQ_AGE_AU_DECES).AsInteger ;
              p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_AN_AGE, IntToStr(li_Age)  ,[]);
              li_Linecounter := 0;
            end;
          // growing
          inc ( li_Linecounter, FieldByName ( IBQ_COUNTER ).AsInteger );
          inc ( li_countTotal, li_Linecounter );
          // men or women
          if FieldByName(IBQ_SEXE).AsInteger = IBQ_SEXE_MAN Then
           Begin
             p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_MEN_COUNT  , FieldByName ( IBQ_COUNTER ).AsString,[]);
             inc ( li_MenTotal, FieldByName ( IBQ_COUNTER ).AsInteger );
           end
          Else
           if FieldByName(IBQ_SEXE).AsInteger = IBQ_SEXE_WOMAN Then
             Begin
               p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_WOMEN_COUNT  , FieldByName ( IBQ_COUNTER ).AsString,[]);
               inc ( li_WomenTotal, FieldByName ( IBQ_COUNTER ).AsInteger );
             end;
          end;
      end;

  Begin
    li_Age := -1;
    li_countTotal :=0;
    li_MenTotal   :=0;
    li_WomenTotal :=0;

    // setting data
    with DMWeb.IBS_Ages do
      try
        Close;
        ParamByName(I_DOSSIER).Value:=DMWeb.CleDossier;
        ExecQuery;
        while not Eof do
          Begin
            if FieldByName(IBQ_AGE_AU_DECES).IsNull Then
              Begin
               Next;
               Continue;
              end;

            p_setLine;

            Next;
          end;
      except
        On E: Exception do
        begin
          MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Ages + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_ANCESTROWEB_cantOpenData ) + DMWeb.IBS_Ages.Database.DatabaseName + CST_ENDOFLINE + E.Message);
          Abort;
        end;
      end;
    p_setHtmlReplaceValues;

    // adding last line
    p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_LINES      ,lstl_HTMLLines.Text);
    // last total line
    p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_AN_AGE     , gs_ANCESTROWEB_TotalAgeDead,[]);
    p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_COUNT      , IntToStr(li_countTotal),[]);
    p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_MEN_COUNT  , IntToStr(li_MenTotal)  ,[]);
    p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_WOMEN_COUNT, IntToStr(li_WomenTotal),[]);
    DMWeb.IBS_Ages.Close;
  end;

begin
  p_Setcomments ( gs_ANCESTROWEB_Ages ); // advert for user
  pb_ProgressInd.Position := 0; // initing not needed user value
  // strings from files
  lstl_HTMLAges  := TStringlistUTF8.Create;
  lstl_HTMLAges2 := TStringlistUTF8.Create;
  lstl_HTMLLines := TStringlistUTF8.Create;
  p_CreateKeyWords;
  // loading a simple not inited line
  p_LoadStringList ( lstl_HTMLLines, CST_FILE_AGES_LINE + CST_EXTENSION_HTML );
  p_LoadStringList ( lstl_HTMLAges , CST_FILE_AGES + '3' + CST_EXTENSION_HTML );
  // Customizing the page
  p_ReplaceLanguageString(lstl_HTMLAges,CST_HTML_HEAD_DESCRIBE, StringReplace(me_HeadAges.Text,CST_ENDOFLINE,'<BR />',[]));

  p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_AN_AGE     , gs_ANCESTROWEB_AnAge         ,[]);
  p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_COUNT      , gs_ANCESTROWEB_Persons_Count ,[]);
  p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_MEN_COUNT  , gs_ANCESTROWEB_Men_Count     ,[]);
  p_ReplaceLanguageString ( lstl_HTMLAges, CST_AGES_WOMEN_COUNT, gs_ANCESTROWEB_Women_Count   ,[]);

  p_addLines;

  // creating and initing the ages page
  p_CreateAHtmlFile(lstl_HTMLAges2, CST_FILE_AGES, me_HeadAges.Lines.Text,
        ( gs_ANCESTROWEB_Ages ), gs_ANCESTROWEB_Ages, gs_ANCESTROWEB_Ages_Long, gs_LinkGedcom, '', CST_EXTENSION_HTML, '', lstl_HTMLAges);


  // saving the page
  ls_destination := gs_RootPathForExport + ed_AgesName.Text  + CST_EXTENSION_HTML;
  try
    lstl_HTMLAges2.SaveToFile(ls_destination);
  except
    On E: Exception do
    begin
      MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Ages + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_ANCESTROWEB_cantSaveFile ) + ls_destination + CST_ENDOFLINE + E.Message);
      Abort;
    end;
  end;
  // freeing
  lstl_HTMLAges .Free;
  lstl_HTMLAges2.Free;
  lstl_HTMLLines.Free;
  p_IncProgressBar;// ages growing
end;
// procedure TF_AncestroWeb.p_genHtmlJobs
// Jobs : HTML page creating
procedure TF_AncestroWeb.p_genHtmlJobs;
var
  lstl_HTMLJobs ,
  lstl_HTMLJobs2,
  lstl_HTMLLines: TStringlistUTF8;
  ls_destination: string;
  // Setting not replaced values
  procedure p_setHtmlReplaceValues;
  Begin
    p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_CITY      , '',[]);
    p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_COUNT  , CST_ZERO          ,[]);
  end;

  // procedure p_CreateLines
  // setting a job line
  procedure p_CreateLines ;
  var
    ls_City,ls_Job: string;
    li_Linecounter, li_countTotal, li_CitiesTotal : Longint;
    procedure p_setline;
    Begin
      with DMWeb.IBS_Jobs do
        Begin
          p_setHtmlReplaceValues;
          p_ReplaceLanguageString(lstl_HTMLJobs,CST_JOBS_LINES  ,lstl_HTMLLines.Text+'['+CST_JOBS_LINES+']');
          if FieldByName(IBQ_EV_IND_DESCRIPTION).AsString <> ls_Job Then
             Begin
              ls_Job := FieldByName(IBQ_EV_IND_DESCRIPTION).AsString ;
              p_addKeyWord(ls_Job); // adding a head's meta keyword
             end;
          ls_City:= FieldByName(IBQ_EV_IND_VILLE      ).AsString ;
          if ls_City > '' Then
            Begin
              p_addKeyWord(ls_City); // adding a head's meta keyword
              ls_City:=fs_getLinkedCity(ls_city);
            end;
          // growing
          li_Linecounter := FieldByName ( IBQ_COUNTER ).AsInteger ;
          ls_Job:=fs_getLinkedJob(ls_Job,li_countTotal);
          // showing job ant city
          p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_A_JOB, ls_Job ,[]);
          p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_CITY , ls_City ,[]);
          // showing jobs'count
          p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_COUNT , IntToStr(li_Linecounter),[]);
          inc ( li_countTotal, li_Linecounter );
          if ( ls_City > '' ) Then
            inc ( li_CitiesTotal, li_Linecounter );
        end;
    end;

  Begin
    ls_City := '';
    ls_Job  := '';
    li_countTotal :=0;
    li_CitiesTotal:=0;

    // setting data
    with DMWeb.IBS_Jobs do
      try
        Close;
        ParamByName(I_DOSSIER).Value:=DMWeb.CleDossier;
        ExecQuery;
        while not Eof do
          Begin
            if FieldByName(IBQ_EV_IND_DESCRIPTION).AsString = '' Then
              Begin
               Next;
               Continue;
              end;
            // setting a line
            p_setline;
            Next;
          end;
      except
        On E: Exception do
        begin
          MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Jobs + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_ANCESTROWEB_cantOpenData ) + DMWeb.IBS_Ages.Database.DatabaseName + CST_ENDOFLINE + E.Message);
          Abort;
        end;
      end;
    p_setHtmlReplaceValues;

    // adding last line
    p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_LINES      ,lstl_HTMLLines.Text);
    // last total line
    p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_A_JOB      , gs_ANCESTROWEB_Jobs_Total,[]);
    p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_COUNT      , IntToStr(li_countTotal),[]);
    p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_CITY       , IntToStr(li_CitiesTotal)  ,[]);
    DMWeb.IBS_Ages.Close;
  end;

begin
  p_Setcomments ( gs_ANCESTROWEB_Jobs ); // advert for user
  pb_ProgressInd.Position := 0; // initing not needed user value
  // strings from files
  lstl_HTMLJobs  := TStringlistUTF8.Create;
  lstl_HTMLJobs2 := TStringlistUTF8.Create;
  lstl_HTMLLines := TStringlistUTF8.Create;
  try
    p_CreateKeyWords;
    // loading a simple not inited line
    p_LoadStringList ( lstl_HTMLLines, CST_FILE_JOBS_LINE + CST_EXTENSION_HTML );
    p_LoadStringList ( lstl_HTMLJobs , CST_FILE_JOBS + '3' + CST_EXTENSION_HTML );

    // Customizing the page
    p_ReplaceLanguageString(lstl_HTMLJobs,CST_HTML_HEAD_DESCRIBE, StringReplace(me_HeadJobs.Text,CST_ENDOFLINE,'<BR />',[]));

    p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_A_JOB  , gs_ANCESTROWEB_A_Job        ,[]);
    p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_COUNT  , gs_ANCESTROWEB_Jobs_Count   ,[]);
    p_ReplaceLanguageString ( lstl_HTMLJobs, CST_JOBS_CITY   , gs_ANCESTROWEB_Jobs_Cities  ,[]);

    p_CreateLines;

    // creating and initing the ages page
    p_CreateAHtmlFile(lstl_HTMLJobs2, CST_FILE_JOBS, me_HeadJobs.Lines.Text,
          gs_ANCESTROWEB_Jobs, gs_ANCESTROWEB_Jobs, gs_ANCESTROWEB_Jobs_Long, gs_LinkGedcom, '',CST_EXTENSION_HTML,'',lstl_HTMLJobs);

    // saving the page
    ls_destination := gs_RootPathForExport + ed_JobsName.Text  + CST_EXTENSION_HTML;
    try
      lstl_HTMLJobs2.SaveToFile(ls_destination);
    except
      On E: Exception do
      begin
        MyShowMessage(gs_ANCESTROWEB_Phase + gs_ANCESTROWEB_Jobs + CST_ENDOFLINE + CST_ENDOFLINE + fs_getCorrectString ( gs_ANCESTROWEB_cantSaveFile ) + ls_destination + CST_ENDOFLINE + E.Message);
        Abort;
      end;
    end;
  finally
   // Destroying
   lstl_HTMLJobs .Destroy;
   lstl_HTMLJobs2.Destroy;
   lstl_HTMLLines.Destroy;
  End;
  p_IncProgressBar;// jobs growing
end;

// procedure TF_AncestroWeb.p_CreateAHtmlFile
// Creating a HTML page from parameters
procedure TF_AncestroWeb.p_CreateAHtmlFile(const astl_Destination: TStringlistUTF8;
  const as_BeginingFile,
  as_Describe, as_Title, as_SelectedTitle, as_LongTitle: string;
  as_BottomHTML: string;
  const as_Subdir: string = '';
  const as_ExtFile: string =
  CST_EXTENSION_HTML;
  const as_BeforeHTML: string = ''; const astl_Body : TStringlistUTF8 = nil );
begin
  if not assigned ( gstl_HeadKeyWords ) Then
    Abort;       // can quit while creating
  if as_BottomHTML > '' then
    as_BottomHTML := '<' + CST_HTML_Paragraph + CST_HTML_ID_EQUAL + '"gedcom">' +
      CST_HTML_AHREF + as_Subdir + as_BottomHTML + '">' + ( gs_AnceSTROWEB_DownloadGedcom ) +
      CST_HTML_A_END + CST_HTML_Paragraph_END;
  as_BottomHTML := '<' + CST_HTML_DIV + CST_HTML_ID_EQUAL + '"bottomDIV">' +
    '<' + CST_HTML_Paragraph + CST_HTML_ID_EQUAL + '"bottom">' +
    me_Bottom.Lines.Text + CST_HTML_Paragraph_END +
    as_BottomHTML + '<' + CST_HTML_Paragraph + CST_HTML_ID_EQUAL + '"bottom">' +
    ( gs_AnceSTROWEB_CreatedBy ) + ' ' + CST_HTML_STRONG_BEGIN +
    CST_AncestroWeb_WithLicense + ' - ' + CST_HTML_AHREF +
    'http://www.liberlog.fr">' + CST_AUTHOR +
    CST_HTML_A_END + CST_HTML_STRONG_END + CST_HTML_Paragraph_END + CST_HTML_DIV_End;
  if as_SelectedTitle > '' then
    p_SelectTabSheet(gt_TabSheets, as_SelectedTitle); // current page sheet
  p_CreateHTMLFile(gt_TabSheets, astl_Destination, as_BottomHTML,
    as_Describe, gstl_HeadKeyWords.Text, gs_HTMLTitle + ' - ' +
    as_Title, as_LongTitle, as_BeginingFile + '1' + as_ExtFile, as_BeginingFile + '2' +
    as_ExtFile, as_BeginingFile + '3' + as_ExtFile, as_BeginingFile +
    '4' + as_ExtFile, as_Subdir, as_BeforeHTML, gs_ANCESTROWEB_Language, astl_Body );
  if as_SelectedTitle > '' then
    p_SelectTabSheet(gt_TabSheets, as_SelectedTitle, '', False);  // reiniting for next page
end;

// procedure TF_AncestroWeb.DoInit
// creating database objects and initing
function TF_AncestroWeb.DoInit(const sBase: string):Boolean;
var
  Save_Cursor: TCursor;
begin
  Result := False;
  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crHourGlass; { Affiche le curseur en forme de sablier }
  try
    if not Assigned(DMWeb) then
    begin
      DMWeb := TDMWeb.Create(self);
      IBQ_Individu.Database:=DMWeb.ibd_BASE;
    end;
    Result:=True;
    Result:=DoOpenBase(sBase);
    if Result then
      Result:=OuvreDossier(DMWeb.CleDossier);
    if Result then
      DoAfterInit;
  finally
    Screen.Cursor := Save_Cursor; { Revient toujours à normal }
  end;
end;

function TF_AncestroWeb.DoInitBase(const AedNomBase: TCustomComboBox): Boolean;
var li_i : Integer;
    ls_bddpath : String ;
begin
  Result := False;
  if fb_AutoComboInit(AedNomBase)
  and (   (DMWeb=nil)
       or ((aedNomBase.ItemIndex > 0 ) and (aedNomBase.ItemIndex < aedNomBase.items.Count ) and (aedNomBase.Items [ aedNomBase.ItemIndex ]<>DMWeb.ibd_BASE.DatabaseName))
       or (DMWeb.ibd_BASE.Connected=false)) Then
   try
    ls_bddpath := aedNomBase.Items [ aedNomBase.ItemIndex ];
    if FileExistsUTF8(ls_bddpath)
     Then Result := DoInit(ls_bddpath)
     Else for li_i := 0 to AedNomBase.Items.Count - 1 do
      if AedNomBase.Items [ li_i ] = ls_bddpath Then
       AedNomBase.Items.Delete(li_i);
   except
   end;
end;

// function TF_AncestroWeb.DoOpenBase
// database opening
function TF_AncestroWeb.DoOpenBase(sBase: string):boolean;
var //ouvre la base, liste les dossiers et sélectionne le premier ou celui de la table dll à la première ouverture
  s:string;
begin
  Result:=DMWeb.doOpenDatabase(sBase);
  if Result then
  begin
    ListerDossiers;
    if PremiereOuverture then
    begin
      Result:=DMWeb.LitDllDossier;
      if Result then
      begin
        s:=IntToStr(DMWeb.CleDossier);
        if Length(s)<2 then
          s:=s+' ';
        cbDossier.Text:=s+', '+fNom_Dossier;
      end;
    end;
  end;
end;

// function TF_AncestroWeb.OuvreDossier
// database folder opening
function TF_AncestroWeb.OuvreDossier(NumDossier:integer):boolean;
begin
  Result:=True;
  try
    IBQ_Individu.Close;
    IBQ_Individu.ParamByName(KLE_DOSSIER).AsInteger:=NumDossier;
    IBQ_Individu.Open;
    if PremiereOuverture then
      IBQ_Individu.Locate(IBQ_CLE_FICHE,fCleFiche,[])
    else
    begin
      fCleFiche:=IBQ_Individu.FieldByName(IBQ_CLE_FICHE).AsInteger;
      fNomIndi:=IBQ_Individu.FieldByName(IBQ_NOM).AsString;
      fPrenomIndi:=IBQ_Individu.FieldByName(IBQ_PRENOM).AsString;
      if not IBQ_Individu.FieldByName(IBQ_IND_CONFIDENTIEL).IsNull
      and  ( IBQ_Individu.FieldByName(IBQ_IND_CONFIDENTIEL).AsInteger <> 0 )
      and  ( fPrenomIndi > '' ) Then
       fPrenomIndi:=fPrenomIndi[1]+'.';
    end;
    DMWeb.CleDossier:=NumDossier;
  except
    On E: Exception do
    begin
      MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData ) +
        sDataBaseName + CST_ENDOFLINE + E.Message);
      Result:=False;
    end;
  end;
end;

// procedure TF_AncestroWeb.DoAfterInit
// initing components and ini
procedure TF_AncestroWeb.DoAfterInit( const ab_Ini : Boolean = True );
begin
  fNom_Dossier:=fs_TextToFileName(fNom_Dossier);
  {$IFNDEF FPC}
  de_ExportWeb.InitialDir:=GetWindir(CSIDL_DESKTOPDIRECTORY);
  {$ENDIF}
  with dm.FileCopy do
   Begin
    Destination := fSoftUserPath+ fNom_Dossier + DirectorySeparator + CST_SUBDIR_EXPORT ;
    fb_CreateDirectoryStructure( Destination );
   end;
  fb_CreateDirectoryStructure( fSoftUserPath+ fNom_Dossier + DirectorySeparator + CST_SUBDIR_SAVE );
  de_ExportWeb.{$IFDEF FPC}Directory{$ELSE}Text{$ENDIF}:= fSoftUserPath+ fNom_Dossier+DirectorySeparator+CST_SUBDIR_EXPORT;
  fne_import.FileName := fSoftUserPath+ fNom_Dossier + DirectorySeparator + CST_SUBDIR_SAVE ;
  fne_Export.FileName := fSoftUserPath+ fNom_Dossier + DirectorySeparator + CST_SUBDIR_SAVE ;

  // Reading ini
  if not ab_Ini Then
    Exit;
  f_GetMainMemIniFile(nil,nil,nil,False,CST_AncestroWeb);
  if FormActivated Then
    OnFormInfoIni.p_ExecuteLecture(Self);
end;

// procedure TF_AncestroWeb.FormCreate
// initializing software and form
procedure TF_AncestroWeb.FormCreate(Sender: TObject);
var ls_Path : String ;
begin
  FreeAndNil(FIniFile);
  f_GetMainMemIniFile(nil,nil,nil,False,CST_AncestroWeb);
  OnFormInfoIni.PlaceForm;
  ImageEdit1.Filter:=rs_Filter_images_web;
  ImageEdit2.Filter:=rs_Filter_images_web;
  ImageEdit3.Filter:=rs_Filter_images_web;
  f_GetMainMemIniFile(nil,nil,nil,False,CST_AncestroWeb);
  fSoftUserPath := GetUserDir;
  fSoftUserPath:=fSoftUserPath+CST_AncestroWeb+DirectorySeparator;
{  {$IFDEF FPC}//à faire une version Delphi
  if InstanceRunning(CST_AncestroWeb) then
  begin
    MyShowMessage('Vous ne devez exécuter qu''une seule session d''AncestroWeb');
    {$ifdef unix}
    FpKill(FpGetpid, 9);
    {$endif}
    {$ifdef windows}
    TerminateProcess(GetCurrentProcess, 0);
    {$endif}
  end;
{$ENDIF}}
  PremiereOuverture:=True;
  ls_Path:=fSoftUserPath + CST_SUBDIR_THEMES;
  L_themaHint.Caption:=fs_RemplaceMsg(rs_Caption_Create_your_thema_in,[ls_Path]);
  L_themaHint.Hint:=L_themaHint.Caption;
  L_Thema    .Hint:=L_themaHint.Caption;
  cb_Themes  .Hint:=L_themaHint.Caption;
  gs_Root:=f_IniReadSectionStr(CST_INI_PATH,'PathAppli','')+DirectorySeparator;
  if Length(gs_Root)<=1 then
    gs_Root:=ExtractFilePath(Application.ExeName);
  fbddpath := f_IniReadSectionStr(CST_INI_PATH,CST_INI_PATH_BDD, ''); // on linux
  gs_Root:=gs_Root+CST_AncestroWeb+DirectorySeparator;//pas dans plugins pour l'exe

  try
    cb_Themes.Items.Clear;
    fb_FindFiles(cb_Themes.Items, gs_Root + CST_SUBDIR_THEMES, False);
    if not DirectoryExistsUTF8(ls_Path)
     Then
      fb_CreateDirectoryStructure(ls_Path);
    fb_FindFiles(cb_Themes.Items, ls_Path, False);

  except

  end;
  try
    cb_Files.Items.Clear;
    fb_FindFiles(cb_Files.Items, gs_Root + CST_SUBDIR_SOURCES, False);
  except

  end;

  // ici mettre la taille initiale car avec les skins, les fenetres se resize
  Width := 640;
  Height := 400;
  PCPrincipal.ActivePage:=ts_Gen;
  Caption := fs_getCorrectString(CST_AncestroWeb_WithLicense+' : '+gs_AnceSTROWEB_FORM_CAPTION);
  if fbddpath > '' Then
    Begin
      p_AddToCombo(cb_Base,fbddpath);
      DoInitBase(cb_Base);
      p_AddToCombo(cb_Base,fbddpath, False);
    end
   else
end;

procedure TF_AncestroWeb.JvXPButton1Click(Sender: TObject);
begin
  {$IFDEF VERSIONS}
  fb_AfficheApropos ( True, CST_AncestroWeb, '' );
  {$ENDIF}
end;

procedure TF_AncestroWeb.OnFormInfoIniIniLoad(const AInifile: TCustomInifile;
  var Continue: Boolean);
begin
  {$IFDEF WINDOWS}
  if gb_logie Then
  {$ENDIF}
  p_ReadComboBoxItems(cb_Base,cb_Base.Items);
  p_iniReadKey;
  {$IFNDEF WINDOWS}
  if fbddpath <> f_IniReadSectionStr(CST_INI_PATH,CST_INI_PATH_BDD, fbddpath) Then
    Begin
      fbddpath := f_IniReadSectionStr(CST_INI_PATH,CST_INI_PATH_BDD, fbddpath); // on linux
      p_AddToCombo(cb_Base,fbddpath);
      DoInitBase(cb_Base);
    end;
  {$ENDIF}
end;

procedure TF_AncestroWeb.OnFormInfoIniIniWrite(const AInifile: TCustomInifile;
  var Continue: Boolean);
begin
  p_writeComboBoxItems(cb_Base,cb_Base.Items);
  p_iniWriteKey;
  p_IniWriteSectionStr(CST_INI_PATH,CST_INI_PATH_BDD,fbddpath);
end;

procedure TF_AncestroWeb.se_NomSet(Sender: TObject);
begin
  p_iniWriteKey;
end;

// procedure TF_AncestroWeb.TraduceImageFailure
// Failure on picture's convert
procedure TF_AncestroWeb.TraduceImageFailure(Sender: TObject;
  const ErrorCode: integer; var ErrorMessage: string; var ContinueCopy: boolean);
begin
  MyShowMessage(fs_getCorrectString ( gs_AnceSTROWEB_cantCreateImage ) + ErrorMessage);
end;

//  Procedure TF_AncestroWeb.ListerDossiers
// Database Folder list
Procedure TF_AncestroWeb.ListerDossiers;
var
  s:string;
begin
  with DMWeb.IBQ_Dossier do
  begin
    try
      Open;
      First;
      cbDossier.Items.Clear;
      while not EOF do
      begin
        s:=Fields[0].AsString;
        if Length(s)<2 then
          s:=s+' ';
        cbDossier.Items.Add(s+', '+fs_getCorrectString(Fields[1].AsString));
        if cbDossier.Items.Count=1 then
        begin
          DMWeb.CleDossier:=Fields[0].AsInteger;
          with cbDossier do
            Caption:=Items[0];
        end;
        Next;
      end;
      Close;
    except
      On E: Exception do
        MyShowMessage( fs_getCorrectString ( gs_AnceSTROWEB_cantOpenData ) + sDataBaseName + CST_ENDOFLINE + E.Message);
    end;
  end;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_AncestroWeb );
{$ENDIF}
end.

