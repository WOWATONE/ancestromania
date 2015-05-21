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
{           Date 03/01/2009       ,Author Name André Langlet            }
{           Description      }
{           Correction erreur importation sur première ligne des memos  }                                                           
{-----------------------------------------------------------------------}

unit u_objet_TImportGedCom;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes,
  contnrs,
  typinfo,
  lazutf8classes,
  u_gedcom_func,
  u_gedcom_type;
type
  TNotifyProgressEvent=procedure(Sender:TObject;Pourcent:integer) of object;
    TGedComStructure=class;

  TTagList = class;
  { TTag }

  TTag=class(TPersistent)
  private
    fID:string;
    fSimple:boolean;
    fClassSubTags:TClassList;
    fObjectSubTags:TTagList; // destroy all on clear
    fPropInfoSubTags:TList;
    fCaptionSubTags:TStringlistUTF8;
    fValue:string;
    fCaption:string;
    fPtrGedComStructure:TGedComStructure;
    fLevel:integer;
    fPtrNextSameTag:TTag;

  protected
    procedure DoIntrospection; virtual;
    procedure DoAttachInList; virtual;

  public
    procedure InsertLast ( const TagIndex : Integer; const ATag : TTag );
    function GetLastNextSameTag:TTag; virtual;
    //est-ce un SimpleTag ? (ou Tag terminal)
    property ID:string read fID write fID;
    property Simple:boolean read fSimple write fSimple;

    //contenue de ce tag
    property Level:integer read fLevel write fLevel;
    property Caption:string read fCaption write fCaption;
    property Value:string read fValue write fValue;
    property PtrNextSameTag:TTag read fPtrNextSameTag write fPtrNextSameTag;

    //pointeurs sur les tags de ce Tag, si ils existent
    property CaptionSubTags:TStringlistUTF8 read fCaptionSubTags;
    property ClassSubTags:TClassList read fClassSubTags;
    property ObjectSubTags:TTagList read fObjectSubTags;
    property PropInfoSubTags:TList read fPropInfoSubTags;

    constructor Create; virtual; // just to be inherited
    procedure AfterCreate(const aGedComStructure:TGedComStructure); virtual;
    destructor Destroy; override;
    procedure Clear; virtual;
    function ExistSubTag(TagName:string;var index:integer):boolean;

  end;

  { TTagList }

  TTagList = class(TObjectList)
  private
    function GetItem(const Index: Integer): TTag;
    Procedure SetItem(const Index: Integer; const AObject: TTag);
  public
    function GetTagById(const AnId:String): TTag;
    property Items[Index: Integer]: TTag read GetItem write SetItem; default;

  end;

  TImportGedCom=class;

  TTag_NOTE_STRUCTURE=class;
  TTag_INDIVIDUAL_RECORD=class;

    //Définition des class utilisés
    TTag_HEADER_RECORD=class;
    TTag_APPROVED_SYSTEM_ID=class;
    TTag_NAME_OF_BUSINESS=class;
    TTag_ADDRESS_STRUCTURE=class;
    TTag_SOURCE_RECORD=class;
    TTag_NOTE_RECORD=class;
    TTag_REPO_RECORD=class;
    TTag_FAM_RECORD=class;
    TTag_NAME_OF_SOURCE_DATA=class;
    TTag_DATE_CHANGE_DATE=class;
    TTag_TRANSMISSION_DATE=class;
    TTag_GEDC=class;
    TTag_CHAR=class;
    TTag_PLAC=class;
    TTag_MEMO=class;//AL déclaré ici pour pouvoir l'utiliser dans l'entête

    TTag_SOURCE_CITATION=class;

    // Header *************************************************************************************

    { TTag_HEADER_RECORD }

    TTag_HEADER_RECORD=class(TTag)
    private
      f_SOUR:TTag_APPROVED_SYSTEM_ID;
      f_DEST,
      f_LANG:TTag;
      f_DATE:TTag_TRANSMISSION_DATE;
      f_SUBN,
      f_SUBM,
      f_FILE,
      f_COPR:TTag;
      f_CHAR:TTag_CHAR;
      f_GEDC:TTag_GEDC;
      f_PLAC:TTag_PLAC;
      f_NOTE:TTag_MEMO;//AL 2009
    protected
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _SOUR:TTag_APPROVED_SYSTEM_ID read f_SOUR write f_SOUR;
      property _DEST:TTag read f_DEST write f_DEST;
      property _DATE:TTag_TRANSMISSION_DATE read f_DATE write f_DATE;
      property _SUBM:TTag read f_SUBM write f_SUBM;
      property _SUBN:TTag read f_SUBN write f_SUBN;
      property _FILE:TTag read f_FILE write f_FILE;
      property _COPR:TTag read f_COPR write f_COPR;
      property _GEDC:TTag_GEDC read f_GEDC write f_GEDC;
      property _CHAR:TTag_CHAR read f_CHAR write f_CHAR;
      property _LANG:TTag read f_LANG write f_LANG;
      property _PLAC:TTag_PLAC read f_PLAC write f_PLAC;
      property _NOTE:TTag_MEMO read f_NOTE write f_NOTE;
    end;

    { TTag_APPROVED_SYSTEM_ID }

    TTag_APPROVED_SYSTEM_ID=class(TTag)
    private
      f_NAME,
      f_VERS:TTag;
      f_CORP:TTag_NAME_OF_BUSINESS;
      f_DATA:TTag_NAME_OF_SOURCE_DATA;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _VERS:TTag read f_VERS write f_VERS;
      property _NAME:TTag read f_NAME write f_NAME;
      property _CORP:TTag_NAME_OF_BUSINESS read f_CORP write f_CORP;
      property _DATA:TTag_NAME_OF_SOURCE_DATA read f_DATA write f_DATA;
    end;

    { TTag_NAME_OF_BUSINESS }

    TTag_NAME_OF_BUSINESS=class(TTag)
    private
      f_ADDR:TTag_ADDRESS_STRUCTURE;
      f_PHON:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _ADDR:TTag_ADDRESS_STRUCTURE read f_ADDR write f_ADDR;
      property _PHON:TTag read f_PHON write f_PHON;
    end;

    { TTag_ADDRESS_STRUCTURE }

    TTag_ADDRESS_STRUCTURE=class(TTag)
    private
      f_CONT,
      f_ADR1,
      f_ADR2,
      f_POST,
      f_CITY,
      f_STAE,
      f_CTRY:TTag;
    public
      function AsLine:string;
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;

    published
      property _CONT:TTag read f_CONT write f_CONT;
      property _ADR1:TTag read f_ADR1 write f_ADR1;
      property _ADR2:TTag read f_ADR2 write f_ADR2;
      property _POST:TTag read f_POST write f_POST;
      property _CITY:TTag read f_CITY write f_CITY;
      property _STAE:TTag read f_STAE write f_STAE;
      property _CTRY:TTag read f_CTRY write f_CTRY;
    end;

    { TTag_NAME_OF_SOURCE_DATA }

    TTag_NAME_OF_SOURCE_DATA=class(TTag)
    private
      f_DATE,
      f_COPR:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _DATE:TTag read f_DATE write f_DATE;
      property _COPR:TTag read f_COPR write f_COPR;
    end;

    { TTag_GEDC }

    TTag_GEDC=class(TTag)
    private
      f_VERS,
      f_FORM:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _VERS:TTag read f_VERS write f_VERS;
      property _FORM:TTag read f_FORM write f_FORM;
    end;

    { TTag_CHAR }

    TTag_CHAR=class(TTag)
    private
      f_VERS:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _VERS:TTag read f_VERS write f_VERS;
    end;


    { TTag_MAP }

    TTag_MAP=class(TTag) //AL2011
    private
      f_LATI,
      f_LONG:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _LATI:TTag read f_LATI write f_LATI;
      property _LONG:TTag read f_LONG write f_LONG;
    end;

    { TCustomTagMemo }

    TCustomTagMemo=class(TTag)
    private
      //le memo
      AMemo:TStrings;
    public
      function AsLine:string; virtual;
      constructor Create; override;
      destructor Destroy; override;
      procedure Clear; override;
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
      property Memo:TStrings read AMemo;
    End;
    { TTag_MEMO }

    TTag_MEMO=class(TCustomTagMemo)
    private
      f_CONC,
      f_CONT:TTag;

    public

      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;

    published
      property _CONC:TTag read f_CONC write f_CONC;
      property _CONT:TTag read f_CONT write f_CONT;
    end;

    { TTag_EVENT_TYPE_CITED_FROM }

    TTag_EVENT_TYPE_CITED_FROM=class(TTag)
    private
      f_ROLE:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _ROLE:TTag read f_ROLE write f_ROLE;
    end;

    { TTag_DATA1 }

    TTag_DATA1=class(TCustomTagMemo)
    private
      f_DATE:TTag;
      f_TEXT:TTag_MEMO;
      f_CONC,
      f_CONT:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;

      function AsLine:string; override;

    published
      property _DATE:TTag read f_DATE write f_DATE;
      property _TEXT:TTag_MEMO read f_TEXT write f_TEXT;
      property _CONC:TTag read f_CONC write f_CONC;
      property _CONT:TTag read f_CONT write f_CONT;
    end;

    { TTag_DATE_CHANGE_DATE }

    TTag_DATE_CHANGE_DATE=class(TTag)
    private
      f_TIME:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _TIME:TTag read f_TIME write f_TIME;
    end;

    { TTag_TRANSMISSION_DATE }

    TTag_TRANSMISSION_DATE=class(TTag)
    private
      f_TIME:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _TIME:TTag read f_TIME write f_TIME;//AL2009
    end;


    { TTag_USER_REFERENCE_NUMBER }

    TTag_USER_REFERENCE_NUMBER=class(TTag)
    private
      f_TYPE:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _TYPE:TTag read f_TYPE write f_TYPE;
    end;

    // Famille ***********************************************************************************

    TTag_LDS_SPOUSE_SEALING=class;
    TTag_AGE_AT_EVENT=class;


    { TTag_AGE_AT_EVENT }

    TTag_AGE_AT_EVENT=class(TTag)
    private
      f_AGE:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _AGE:TTag read f_AGE write f_AGE;
    end;


    { TTag_EVENT_RECORD }

    TTag_EVENT_RECORD=class(TTag)
    private
      f_DATE,
      f_PLAC:TTag;
    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    published
      property _DATE:TTag read f_DATE write f_DATE;
      property _PLAC:TTag read f_PLAC write f_PLAC;
    end;


  { TGedComStructure }

  TGedComStructure=class(TTag)
  private
    // TObjectList destroys all on clear
    fIndividuList:TTagList;
    fFamilleList:TTagList;
    fOtherList:TTagList;
    fAllList:TTagList;
    fNoteList:TTagList;
    fSourceList:TTagList;
    fRepoList:TTagList;

    f_TRLR:TTag;
    f_HEAD:TTag_Header_Record;
    f_INDI:TTag_Individual_Record;
    f_FAM:TTag_FAM_RECORD;
    f_SOUR:TTag_SOURCE_RECORD;
    f_NOTE:TTag_NOTE_RECORD;
    f_REPO:TTag_REPO_RECORD;
    fPtrObjetImportGedcom:TImportGedCom;

  public
    function GetRepoAsString:String;
    function GetSourAsString:String;
    function GetNoteAsString:String;
    property AllList:TTagList read fAllList;
    property IndividuList:TTagList read fIndividuList;
    property FamilleList:TTagList read fFamilleList;
    property SourceList:TTagList read fSourceList;
    property NoteList:TTagList read fNoteList;
    property RepoList:TTagList read fRepoList;

    //#########  pointeur vers la liste des autres structures [références] : notes, sources, repo, etc...
    property PtrObjetImportGedcom:TImportGedCom read fPtrObjetImportGedcom write fPtrObjetImportGedcom;

    constructor Create;
    destructor Destroy; override;

    function GetIndividuByID(const ID:string):TTag_INDIVIDUAL_RECORD;
    function GetFamilleByID(const ID:string):TTag_FAM_RECORD;
    function GetSourceRecordByID(const ID:string):TTag_SOURCE_RECORD;
    function GetNoteRecordByID(const ID:string):TTag_NOTE_RECORD;
    function GetRepoRecordByID(const ID:string):TTag_REPO_RECORD;

    procedure Clear; override;

    procedure InitStructure(const APtrImport : TImportGedcom);

  published
    property _HEAD:TTag_HEADER_RECORD read f_HEAD write f_HEAD;
    //SUBMISSION_RECORD
    property _FAM:TTag_FAM_RECORD read f_FAM write f_FAM;
    property _INDI:TTag_INDIVIDUAL_RECORD read f_INDI write f_INDI;
    property _SOUR:TTag_SOURCE_RECORD read f_SOUR write f_SOUR;
    property _NOTE:TTag_NOTE_RECORD read f_NOTE write f_NOTE;
    property _REPO:TTag_REPO_RECORD read f_REPO write f_REPO;
    //SUBMITTER_RECORD
    property _TRLR:TTag read f_TRLR write f_TRLR;
  end;

  { TObjectIndentifed }

  TObjectIdentified=class
  private
    fID:string;
  public
    constructor Create; virtual;
    property ID:string read fID write fID;
  End;
  { TTagList }

  TIdentifiedList = class(TObjectList)
  private
    function GetItem(const Index: Integer): TObjectIdentified;
    Procedure SetItem(const Index: Integer; const AObject: TObjectIdentified);
  public
    function GetObjectIdentifiedById(const AnId:String): TObjectIdentified;
    property Items[Index: Integer]: TObjectIdentified read GetItem write SetItem; default;

  end;

  TIndi=class(TObjectIdentified)
  private
//    fCLE_PERE:integer;
    fCle:integer;
//    fCLE_MERE:integer;
//    fCLE_PARENTS:integer;
    fSEXE:string;

    // modif du 20/09/2004 pour le NCHI et NMR pour l individu --------------------------
//    fNCHI:string;
//    fNMR:string;

  public
    property Cle:integer read fCle write fCle;
//    property CLE_PARENTS:integer read fCLE_PARENTS write fCLE_PARENTS;
//    property CLE_PERE:integer read fCLE_PERE write fCLE_PERE;
//    property CLE_MERE:integer read fCLE_MERE write fCLE_MERE;
    property SEXE:string read fSEXE write fSEXE;

    // modif du 20/09/2004 pour le NCHI et NMR pour l individu --------------------------
//    property NCHI:string read fNCHI write fNCHI;
//    property NMR:string read fNMR write fNMR;

    constructor Create; override;
  end;

  TFam=class(TObjectIdentified)
  private
    fCLE:integer;
    fCLEF_HUSB:integer;
    fCLEF_WIFE:integer;
//    fAlreadySaveThisUnion:boolean;

  public
    property CLE:integer read fCLE write fCLE;//clé du record dans la table
    property CLEF_HUSB:integer read fCLEF_HUSB write fCLEF_HUSB;
    property CLEF_WIFE:integer read fCLEF_WIFE write fCLEF_WIFE;
//    property AlreadySaveThisUnion:boolean read fAlreadySaveThisUnion write fAlreadySaveThisUnion;
    constructor Create; override;

  end;

  TBlock=class(TObjectIdentified)
  private
    fFirstLine:string;
    fGedcomBlock:TGedcomStructure;
  public
    property FirstLine:string read fFirstLine write fFirstLine;
    property GedcomBlock:TGedcomStructure read fGedcomBlock;
    constructor Create; override;
    destructor destroy; override;

  end;

  { TImportGedCom }

  TImportGedCom=class

  private
    fOnProgress:TNotifyProgressEvent;
    fPathFileName:string;

    //	fGedcomStructureOfAllFile: TGedComStructure;
    fGedcomStructureOfHeader:TGedComStructure;
    fEventsPossible:TStringlistUTF8;

    //Liste des individus
    // TObjectList destroys all on clear
    fListIndi:TIdentifiedList;
    fListFam:TIdentifiedList;
    fListNote:TIdentifiedList;
    fListSour:TIdentifiedList;
    fListRepo:TIdentifiedList;

    procedure DestroyProperties;
    function GetBlockByID(const AList: TIdentifiedList; const aID: string
      ): TBlock;
    procedure PrepareProperties;

  public
    procedure ClearAll;
    procedure CreateHeaderStructure;
    function DecodeLigne(ligne:string;var niveau:integer;var tag:string;var ID:string;var infos:string):boolean;
    property GedcomStructureOfHeader:TGedComStructure read fGedcomStructureOfHeader write fGedcomStructureOfHeader;
    property EventsPossible:TStringlistUTF8 read fEventsPossible write fEventsPossible;
    property PathFileName:string read fPathFileName write fPathFileName;
    property OnProgress:TNotifyProgressEvent read fOnProgress write fOnProgress;

    property ListIndi:TIdentifiedList read fListIndi;
    property ListFam:TIdentifiedList read fListFam;
    property ListSour:TIdentifiedList read fListSour;
    property ListNote:TIdentifiedList read fListNote;
    property ListRepo:TIdentifiedList read fListRepo;

    constructor Create;
    destructor Destroy; override;

    //lecture de tous les individus
    procedure PrepareIndividusAndFamilles(const JeuCaractere:TSetCodageCaracteres);

    //lit seulement l'entête, et le place dans 'fContent'
    function LoadFromFileJustTheHeader(const aPathFileName:string;const aContent:TStringlistUTF8;const JeuCaractere:TSetCodageCaracteres):boolean;

    //lit quelques exemples de noms
    function LoadFromFileQuelquesExemplesDeNoms(const aPathFileName:string;const aContent:TStringlistUTF8;const JeuCaractere:TSetCodageCaracteres):boolean;

    //lit quelques adresses
    function LoadFromFileQuelquesAdresses(const aPathFileName:string;const aContent:TStringlistUTF8;const JeuCaractere:TSetCodageCaracteres):boolean;

    //Décode le contenue de 'fContent', et le place dans la structure 'aGedComStructure'
    function DecodageGedcom(const aGedComStructure:TGedComStructure;const Content:TStringlistUTF8;const JeuCaractere:TSetCodageCaracteres):boolean;

    //réinitialise cet objet
    procedure Clear; virtual;

    function GetIndividuByID(const aID:string):TIndi;
    function GetIndividuByCle(const aCLE:integer):TIndi;
    function GetFamilleByID(const aID:string):TFam;
    function GetSourceByID(const aID:string):TBlock;
    function GetNoteByID(const aID:string):TBlock;
    function GetRepoByID(const aID:string):TBlock;
  end;

  { TTag_NOTE_STRUCTURE }

  TTag_NOTE_STRUCTURE=class(TCustomTagMemo)
  private
    f_CONC,
    f_CONT:TTag;
    f_SOUR:TTag_SOURCE_RECORD;
  public
    //le memo
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    function AsLine:string; override;
  published
    property _CONC:TTag read f_CONC write f_CONC;
    property _CONT:TTag read f_CONT write f_CONT;
    property _SOUR:TTag_SOURCE_RECORD read f_SOUR write f_SOUR;
  end;

  { TTag_MEDIA }

  TTag_MEDIA=class(TTag)

  private
    f_OBJE,
    f_FORM,
    f_FILE,
    f_XIDEN,
    f__IDEN,//AL
    f__POI,//AL 2010
    f_XTYPE,
    f_XMODE,
    f_XACTE:TTag;
    fCle:integer;
    f_NOTE:TTag_NOTE_STRUCTURE;//AL
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    property Cle:integer read fCle write fCle;
  published
    property _OBJE:TTag read f_OBJE write f_OBJE;
    property _FORM:TTag read f_FORM write f_FORM;
    property _FILE:TTag read f_FILE write f_FILE;
    property _XIDEN:TTag read f_XIDEN write f_XIDEN;
    property __IDEN:TTag read f__IDEN write f__IDEN;//AL
    property __POI:TTag read f__POI write f__POI;//AL 2010
    property _XTYPE:TTag read f_XTYPE write f_XTYPE;
    property _XMODE:TTag read f_XMODE write f_XMODE;
    property _XACTE:TTag read f_XACTE write f_XACTE;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
  end;

    { TTag_DOMICILE }

    TTag_DOMICILE=class(TTag)
    private
      fCle:integer;

      f_ADDR,

      f_CITY,
      f_EMAIL,
      f_POST,
      f_STAE,
      f_CTRY,
      f_ANCES_REG,
      f_DEPT:TTag;
      f_ADR1:TTag_MEMO;
      f_ADR2:TTag_MEMO;
      f_TEL:TTag_MEMO;
      f_PHON:TTag_MEMO;
      f_DATE,
      f_WWW:TTag;
      f_OBJE:TTag_MEDIA;

      f_ANCES_XINSEE,
      f_FILE,
      f_SUBD,
      f_LATI,
      f_LONG:TTag;
      f_NOTE:TTag_NOTE_STRUCTURE;//AL

    public
      procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
      property Cle:integer read fCle write fCle;
    published
      property _ADDR:TTag read f_ADDR write f_ADDR;
      property _SUBD:TTag read f_SUBD write f_SUBD;
      property _LATI:TTag read f_LATI write f_LATI;
      property _LONG:TTag read f_LONG write f_LONG;

      property _ADR1:TTag_MEMO read f_ADR1 write f_ADR1;
      property _ADR2:TTag_MEMO read f_ADR2 write f_ADR2;
      property _POST:TTag read f_POST write f_POST;
      property _CITY:TTag read f_CITY write f_CITY;
      property _DEPT:TTag read f_DEPT write f_DEPT;
      property __ANCES_REG:TTag read f_ANCES_REG write f_ANCES_REG;
      property _STAE:TTag read f_STAE write f_STAE;
      property _CTRY:TTag read f_CTRY write f_CTRY;
      property _EMAIL:TTag read f_EMAIL write f_EMAIL;
      property _TEL:TTag_MEMO read f_TEL write f_TEL;
      property _PHON:TTag_MEMO read f_PHON write f_PHON;
      property _DATE:TTag read f_DATE write f_DATE;
      property _WWW:TTag read f_WWW write f_WWW;
      property _OBJE:TTag_MEDIA read f_OBJE write f_OBJE;

      property __ANCES_XINSEE:TTag read f_ANCES_XINSEE write f_ANCES_XINSEE;
      property _FILE:TTag read f_FILE write f_FILE;
      property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;

    end;

  { TTag_PLAC }

  TTag_PLAC=class(TTag)
  private
    f_FORM:TTag;
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
  published
    property _FORM:TTag read f_FORM write f_FORM;
  end;

  // Individu *********************************************************************************
  TTag_Personal_Name_Structure=class;
  TTag_Event_Detail=class;
  TTag_ASSOCIATION_STRUCTURE=class;
  TTag_CHANGE_DATE=class;
  TTag_CHILD_TO_FAMILY_LINK=class;
  TTag_SPOUSE_TO_FAMILY_LINK=class;
  TTag_PLACE_STRUCTURE=class;

//  TTag_MEMO = class;  //AL déclaré précédemment pour l'utiliser dans l'entête


  { TTag_INDIVIDUAL_RECORD }

  TTag_INDIVIDUAL_RECORD=class(TTag)
  private
    f_SEX,

    f_NCHI,
    f_NMR:TTAG;
//    f_ANCES_CLE_FIXE:TTAG;
//    f_IMPORT_GEDCOM:TTAG;
    f_LEGA:TTag_Event_Detail;//AL

    f_RESN:TTag;
    f_EMIG,
    f_DIPL,
    f_PROB,
    f_FCOM,
    f_BURI,
    f_NATU,
    f_CHRA,
    f_ORDN,
    f_DEAT,
    f_RETI,
    f_WILL,
    f_CENS,
    f_BLES,
    f_CREM,
    f_BASM,
    f_IMMI,
    f_BAPM,
    f_BARM,
    f_GRAD,
    f_CONF,
    f_EVEN,
    f_CHR,
    f_BIRT,
    f_ADOP:TTag_Event_Detail;
    f_NAME:TTag_Personal_Name_Structure;
    f_TITL,
    f_RESI,
    f_CAST,
    f_DSCR,
    f_EDUC,
    f_IDNO,
    f_PROP,
    f_NATI,
    f_RELI,
    f_SSN,
    f_OCCU,
    f_CONL,
    f_ENDL,
    f_BAPL,
    f_SLGC:TTag_Event_Detail;
    f_ALIA,
    f_AFN,
    f_ANCI,
    f_RFN,
    f_SUBM,
    f_RIN,
    f_DESI:TTag;
    //f_ASSO: TTag_ASSOCIATION_STRUCTURE;
    f_CHAN:TTag_CHANGE_DATE;
    f_FAMC:TTag_CHILD_TO_FAMILY_LINK;
    f_NOTE:TTag_NOTE_STRUCTURE;//TTag_NOTE_STRUCTURE;
    f_SOUR:TTag_SOURCE_CITATION;//SOURCE_CITATION;
    f_FAMS:TTag_SPOUSE_TO_FAMILY_LINK;
    f_REFN:TTag_USER_REFERENCE_NUMBER;

    fCle:integer;
    //fCLE_PARENTS:integer; pas utilisée dans cette version
    fCLE_PERE:integer;
    fCLE_MERE:integer;

    f_SALE,
    f_PURC,
    f_MILI,
    f_ALIV,
    f_TRIP,
    f_BRIT:TTag_Event_Detail;
    f_FILA:TTag; //pas standard
    f_INHU:TTag_Event_Detail;
    //f_DOMI: TTag_DOMICILE;
    f_ADDR:TTag_DOMICILE;
    f_OBJE:TTag_MEDIA;

    // -- Ici les tags proprietaire d Ancestromania --------------------------------------------------------------------
    f_XSPO,// Sport
    f_XLOI,// Loisirs
    f_X_MU1,// Musulman
    f_X_MU2,// Musulman
    f_X_MU3,// Musulman
    f_XHENN,// Juif
    f_XHOUP:TTag_Event_Detail;// Juif
    // -----------------------------------------------------------------------------------------------------------------
  protected
    procedure DoAttachInList; override;

  public
    property Cle:integer read fCle write fCle;
    //property CLE_PARENTS:integer read fCLE_PARENTS write fCLE_PARENTS; pas utilisée dans cette version
    property CLE_PERE:integer read fCLE_PERE write fCLE_PERE;
    property CLE_MERE:integer read fCLE_MERE write fCLE_MERE;

    procedure AfterCreate(const aGedComStructure:TGedComStructure); override;

  published
    property _RESN:TTag read f_RESN write f_RESN;
    property _NAME:TTag_Personal_Name_Structure read f_NAME write f_NAME;
    property _SEX:TTag read f_SEX write f_SEX;

    // modif du 20/09/2004 pour le NCHI et NMR pour l individu --------------------------
    property _NCHI:TTag read f_NCHI write f_NCHI;
    property _NMR:TTag read f_NMR write f_NMR;
//    property __ANCES_CLE_FIXE:TTag read f_ANCES_CLE_FIXE write f_ANCES_CLE_FIXE;
//    property _IMPORT_GEDCOM:TTag read f_IMPORT_GEDCOM write f_IMPORT_GEDCOM;

    //INDIVIDUAL_EVENT_STRUCTURE
    property _BIRT:TTag_Event_Detail read f_BIRT write f_BIRT;
    property _CHR:TTag_Event_Detail read f_CHR write f_CHR;
    property _DEAT:TTag_Event_Detail read f_DEAT write f_DEAT;
    property _BURI:TTag_Event_Detail read f_BURI write f_BURI;
    property _CREM:TTag_Event_Detail read f_CREM write f_CREM;
    property _ADOP:TTag_Event_Detail read f_ADOP write f_ADOP;
    property _BAPM:TTag_Event_Detail read f_BAPM write f_BAPM;
    property _BARM:TTag_Event_Detail read f_BARM write f_BARM;
    property _BASM:TTag_Event_Detail read f_BASM write f_BASM;
    property _BLES:TTag_Event_Detail read f_BLES write f_BLES;
    property _CHRA:TTag_Event_Detail read f_CHRA write f_CHRA;
    property _CONF:TTag_Event_Detail read f_CONF write f_CONF;
    property _FCOM:TTag_Event_Detail read f_FCOM write f_FCOM;
    property _ORDN:TTag_Event_Detail read f_ORDN write f_ORDN;
    property _NATU:TTag_Event_Detail read f_NATU write f_NATU;
    property _EMIG:TTag_Event_Detail read f_EMIG write f_EMIG;

    property _DIPL:TTag_Event_Detail read f_DIPL write f_DIPL;

    property _IMMI:TTag_Event_Detail read f_IMMI write f_IMMI;
    property _CENS:TTag_Event_Detail read f_CENS write f_CENS;
    property _PROB:TTag_Event_Detail read f_PROB write f_PROB;
    property _WILL:TTag_Event_Detail read f_WILL write f_WILL;
    property _GRAD:TTag_Event_Detail read f_GRAD write f_GRAD;
    property _RETI:TTag_Event_Detail read f_RETI write f_RETI;
    property _EVEN:TTag_Event_Detail read f_EVEN write f_EVEN;
    property _BRIT:TTag_Event_Detail read f_BRIT write f_BRIT;

    // -- Ici les tags proprietaire d Ancestromania --------------------------------------------------------------------
    property _XSPO:TTag_Event_Detail read f_XSPO write f_XSPO;
    property _XLOI:TTag_Event_Detail read f_XLOI write f_XLOI;
    property _X_MU1:TTag_Event_Detail read f_X_MU1 write f_X_MU1;
    property _X_MU2:TTag_Event_Detail read f_X_MU2 write f_X_MU2;
    property _X_MU3:TTag_Event_Detail read f_X_MU3 write f_X_MU3;
    property _XHENN:TTag_Event_Detail read f_XHENN write f_XHENN;
    property _XHOUP:TTag_Event_Detail read f_XHOUP write f_XHOUP;
    property _LEGA:TTag_Event_Detail read f_LEGA write f_LEGA;
    // -----------------------------------------------------------------------------------------------------------------

    //INDIVIDUAL_ATTRIBUTE_STRUCTURE
    property _CAST:TTag_Event_Detail read f_CAST write f_CAST;
    property _DSCR:TTag_Event_Detail read f_DSCR write f_DSCR;
    property _EDUC:TTag_Event_Detail read f_EDUC write f_EDUC;
    property _IDNO:TTag_Event_Detail read f_IDNO write f_IDNO;
    property _NATI:TTag_Event_Detail read f_NATI write f_NATI;
    property _OCCU:TTag_Event_Detail read f_OCCU write f_OCCU;
    property _PROP:TTag_Event_Detail read f_PROP write f_PROP;
    property _RELI:TTag_Event_Detail read f_RELI write f_RELI;
    property _RESI:TTag_Event_Detail read f_RESI write f_RESI;
    property _SSN:TTag_Event_Detail read f_SSN write f_SSN;
    property _TITL:TTag_Event_Detail read f_TITL write f_TITL;

    //LDS_INDIVIDUAL_ORDINANCE
    property _BAPL:TTag_Event_Detail read f_BAPL write f_BAPL;
    property _CONL:TTag_Event_Detail read f_CONL write f_CONL;
    property _ENDL:TTag_Event_Detail read f_ENDL write f_ENDL;
    property _SLGC:TTag_Event_Detail read f_SLGC write f_SLGC;

    //Autres Tag (de Heredis...)
    property _PURC:TTag_Event_Detail read f_PURC write f_PURC;//Acquisition
    property _ALIV:TTag_Event_Detail read f_ALIV write f_ALIV;//En vie
    property _MILI:TTag_Event_Detail read f_MILI write f_MILI;//Service militaire
    property _SALE:TTag_Event_Detail read f_SALE write f_SALE;//Vente d'un bien
    property _TRIP:TTag_Event_Detail read f_TRIP write f_TRIP;//Voyage
    property _INHU:TTag_Event_Detail read f_INHU write f_INHU;//Inhumation

    property _FAMC:TTag_CHILD_TO_FAMILY_LINK read f_FAMC write f_FAMC;
    property _FAMS:TTag_SPOUSE_TO_FAMILY_LINK read f_FAMS write f_FAMS;

    property _SUBM:TTag read f_SUBM write f_SUBM;
    property _ALIA:TTag read f_ALIA write f_ALIA;
    property _ANCI:TTag read f_ANCI write f_ANCI;
    property _DESI:TTag read f_DESI write f_DESI;

    property _SOUR:TTag_SOURCE_CITATION read f_SOUR write f_SOUR;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;

    property _RFN:TTag read f_RFN write f_RFN;
    property _AFN:TTag read f_AFN write f_AFN;
    property _REFN:TTag_USER_REFERENCE_NUMBER read f_REFN write f_REFN;
    property _RIN:TTag read f_RIN write f_RIN;
    property _CHAN:TTag_CHANGE_DATE read f_CHAN write f_CHAN;

    //Filliation
    property _FILA:TTag read f_FILA write f_FILA;

    //Domiciles
    property _ADDR:TTag_DOMICILE read f_ADDR write f_ADDR;
    property _OBJE:TTag_MEDIA read f_OBJE write f_OBJE;

  end;

  { TTag_Personal_Name_Structure }

  TTag_Personal_Name_Structure=class(TTag)
  private
    // TTag //
    f_SURN,
    f_NSFX,
    f_NPFX,

    f_NCHI,
    f_NMR,

    f_GIVN,
    f_SPFX,
    f_NICK:TTag;
    // TTag //

    f_NOTE:TTag_NOTE_STRUCTURE;
    f_SOUR:TTag_SOURCE_CITATION;
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;

  published
    property _NCHI:TTag read f_NCHI write f_NCHI;
    property _NMR:TTag read f_NMR write f_NMR;

    property _NPFX:TTag read f_NPFX write f_NPFX;
    property _GIVN:TTag read f_GIVN write f_GIVN;
    property _NICK:TTag read f_NICK write f_NICK;
    property _SPFX:TTag read f_SPFX write f_SPFX;
    property _SURN:TTag read f_SURN write f_SURN;
    property _NSFX:TTag read f_NSFX write f_NSFX;
    property _SOUR:TTag_SOURCE_CITATION read f_SOUR write f_SOUR;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
  end;

  { TTag_Event_Detail }

  TTag_Event_Detail=class(TTag)
  private
    f_AGE,
    f_CAUS,
    f_DATE,
    f_TIME,
    f_TYPE,
    f_AGNC:TTag;
    f_SOUR:TTag_SOURCE_CITATION;
    f_NOTE:TTag_NOTE_STRUCTURE;
    f_PLAC:TTag_PLACE_STRUCTURE;
    f_ADDR:TTag_ADDRESS_STRUCTURE;
    f_PHON:TTag_MEMO;
    f_EMAIL:TTag_MEMO;//AL
    f_FAX:TTag_MEMO;//AL
    f_WWW:TTag_MEMO;//AL
    f_ASSO:TTag_ASSOCIATION_STRUCTURE;

    fCle:integer;
    f_LIEU,
    f_ANCES_XINSEE,
    f_ANCES_ORDRE,
    f__ORDR,//AL
    f_ANCES_XACTE,
    f__ACTE,//AL

    f_LATI,
    f_LONG,
    f_DESC:TTag;//PCM ancien tag à supprimer, utilisé dans soumission
    f_OBJE:TTag_MEDIA;//AL

  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    property Cle:integer read fCle write fCle;
  published
    property _LATI:TTag read f_LATI write f_LATI;
    property _LONG:TTag read f_LONG write f_LONG;
    property _TYPE:TTag read f_TYPE write f_TYPE;
    property _DATE:TTag read f_DATE write f_DATE;
    property _TIME:TTag read f_TIME write f_TIME;
    property _PLAC:TTag_PLACE_STRUCTURE read f_PLAC write f_PLAC;
    property _LIEU:TTag read f_LIEU write f_LIEU;
    property __ANCES_XINSEE:TTag read f_ANCES_XINSEE write f_ANCES_XINSEE;
    property __ANCES_ORDRE:TTag read f_ANCES_ORDRE write f_ANCES_ORDRE;
    property __ORDR:TTag read f__ORDR write f__ORDR;//AL
    property __ANCES_XACTE:TTag read f_ANCES_XACTE write f_ANCES_XACTE;
    property __ACTE:TTag read f__ACTE write f__ACTE;
    property _ADDR:TTag_ADDRESS_STRUCTURE read f_ADDR write f_ADDR;
    property _PHON:TTag_MEMO read f_PHON write f_PHON;
    property _EMAIL:TTag_MEMO read f_EMAIL write f_EMAIL;
    property _FAX:TTag_MEMO read f_FAX write f_FAX;
    property _WWW:TTag_MEMO read f_WWW write f_WWW;
    property _AGE:TTag read f_AGE write f_AGE;
    property _AGNC:TTag read f_AGNC write f_AGNC;
    property _CAUS:TTag read f_CAUS write f_CAUS;
    property _SOUR:TTag_SOURCE_CITATION read f_SOUR write f_SOUR;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
    property _ASSO:TTag_ASSOCIATION_STRUCTURE read f_ASSO write f_ASSO;
    property _DESC:TTag read f_DESC write f_DESC; //ancien tag à supprimer
    property _OBJE:TTag_MEDIA read f_OBJE write f_OBJE;
  end;

  { TTag_PLACE_STRUCTURE }

  TTag_PLACE_STRUCTURE=class(TTag)
  private
    f_FORM:TTag;
    f_NOTE:TTag_NOTE_STRUCTURE;
    //f_SOUR:TTag_SOURCE_CITATION; //pas utilisé par Ancestro
    f_MAP:TTag_MAP; //AL2011
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;

  published
    property _FORM:TTag read f_FORM write f_FORM;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
    //property _SOUR:TTag_SOURCE_CITATION read f_SOUR write f_SOUR;
    property _MAP:TTag_MAP read f_MAP write f_MAP;
  end;

  { TTag_SOURCE_CITATION }

  TTag_SOURCE_CITATION=class(TCustomTagMemo)
  //erreur/GEDCOM confusion des niveaux SOURCE_CITATION et SOURCE_RECORD
  //on devrait d'abord importer SOURCE_CITATION avant SOURCE_RECORD s'ils étaient correctement définis.
  //mais Ancestro ramène tout dans SOURCE_CITATION
  private
    //f_SOUR:TTag_SOURCE_RECORD;//AL2010 devrait être là
    f_CONC,
    f_CONT,
    f_PAGE:TTag;//pas utilisé
    f_EVEN:TTag_EVENT_TYPE_CITED_FROM;
    f_DATA:TTag_DATA1; //gênant: existe dans SOURCE_CITATION et SOURCE_RECORD avec une structure différente
    f_QUAY:TTag;//pas utilisé
    f_NOTE:TTag_NOTE_STRUCTURE;
    f_TEXT:TTag_MEMO;
    f_ABBR, //erreur GEDCOM AL2010
    f_REPO:TTag; //erreur GEDCOM AL2010
    f_AUTH:TTag_MEMO; //erreur GEDCOM AL2010
    f_TITL:TTag_MEMO; //erreur GEDCOM AL2010
    f_PUBL:TTag_MEMO; //erreur GEDCOM AL2010
    f_OBJE:TTag_MEDIA; //erreur GEDCOM AL2010
    f_CHAN:TTag_CHANGE_DATE; //erreur GEDCOM AL2010
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    function AsLine:string; override;

  published
    //soit
    //property _SOUR:TTag_SOURCE_RECORD read f_SOUR write f_SOUR;
    property _PAGE:TTag read f_PAGE write f_PAGE;
    property _EVEN:TTag_EVENT_TYPE_CITED_FROM read f_EVEN write f_EVEN;
    property _DATA:TTag_DATA1 read f_DATA write f_DATA;
    property _QUAY:TTag read f_QUAY write f_QUAY;

    //soit
    property _CONC:TTag read f_CONC write f_CONC;
    property _CONT:TTag read f_CONT write f_CONT;
    property _TEXT:TTag_MEMO read f_TEXT write f_TEXT;
    property _ABBR: TTag read f_ABBR write f_ABBR;
    property _REPO: TTag read f_REPO write f_REPO;

    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
    property _AUTH: TTag_MEMO read f_AUTH write f_AUTH;
    property _TITL: TTag_MEMO read f_TITL write f_TITL;
    property _PUBL: TTag_MEMO read f_PUBL write f_PUBL;
    property _OBJE:TTag_MEDIA read f_OBJE write f_OBJE;
    property _CHAN:TTag_CHANGE_DATE read f_CHAN write f_CHAN;
  end;

  { TTag_ASSOCIATION_STRUCTURE }

  TTag_ASSOCIATION_STRUCTURE=class(TTag)
  private
    f_RELA:TTag;
    f_NOTE:TTag_NOTE_STRUCTURE;
    f_SOUR:TTag_SOURCE_CITATION;
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
  published
    property _RELA:TTag read f_RELA write f_RELA;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
    property _SOUR:TTag_SOURCE_CITATION read f_SOUR write f_SOUR;
  end;

  { TTag_CHANGE_DATE }

  TTag_CHANGE_DATE=class(TTag)
  private
    f_DATE:TTag_DATE_CHANGE_DATE;
    f_NOTE:TTag_NOTE_STRUCTURE;
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    function AsLine:string;
  published
    property _DATE:TTag_DATE_CHANGE_DATE read f_DATE write f_DATE;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;

  end;

  { TTag_CHILD_TO_FAMILY_LINK }

  TTag_CHILD_TO_FAMILY_LINK=class(TTag)
  private
    f_PEDI:TTag;
    f_NOTE:TTag_NOTE_STRUCTURE;
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
  published
    property _PEDI:TTag read f_PEDI write f_PEDI;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
  end;

  { TTag_SPOUSE_TO_FAMILY_LINK }

  TTag_SPOUSE_TO_FAMILY_LINK=class(TTag)
  private
    f_NOTE:TTag_NOTE_STRUCTURE;
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
  published
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
  end;

  { TTag_FAM_RECORD }

  TTag_FAM_RECORD=class(TTag)
  private
    f_CHIL,
    f_RIN,
    f_HUSB,
    f_SUBM,
    f_NCHI,
    f_WIFE:TTag;
    f_CHAN:TTag_CHANGE_DATE;
    f_EVEN,
    f_ENGA,
    f_DIV,
    f_MARR,
    f_MARS,
    f_MARB,
    f_ANUL,
    f_MARC,
    f_CENS,
    f_DIVF,
    f_MARL:TTag_Event_Detail;
    f_SLGS:TTag_LDS_SPOUSE_SEALING;
    f_NOTE:TTag_NOTE_STRUCTURE;
    f_SOUR:TTag_SOURCE_CITATION;
    f_REFN:TTag_USER_REFERENCE_NUMBER;

    fCLEF_HUSB:integer;
    fCLEF_WIFE:integer;
    fCLE:integer;
//    fAlreadySaveThisUnion:boolean;
    f_TYPU:TTag;
//    f_LATI: TTag;
//    f_LONG: TTag;

  protected
    procedure DoAttachInList; override;

  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    property CLE:integer read fCLE write fCLE;//clé du record dans la table
    property CLEF_HUSB:integer read fCLEF_HUSB write fCLEF_HUSB;
    property CLEF_WIFE:integer read fCLEF_WIFE write fCLEF_WIFE;

//    property AlreadySaveThisUnion:boolean read fAlreadySaveThisUnion write fAlreadySaveThisUnion;

  published
    //FAMILY_EVENT_STRUCTURE        //revoir, peut-être
    property _ANUL:TTag_EVENT_DETAIL read f_ANUL write f_ANUL;
    property _CENS:TTag_EVENT_DETAIL read f_CENS write f_CENS;
    property _DIV:TTag_EVENT_DETAIL read f_DIV write f_DIV;
    property _DIVF:TTag_EVENT_DETAIL read f_DIVF write f_DIVF;
    property _ENGA:TTag_EVENT_DETAIL read f_ENGA write f_ENGA;
    property _MARR:TTag_EVENT_DETAIL read f_MARR write f_MARR;
    property _MARB:TTag_EVENT_DETAIL read f_MARB write f_MARB;
    property _MARC:TTag_EVENT_DETAIL read f_MARC write f_MARC;
    property _MARL:TTag_EVENT_DETAIL read f_MARL write f_MARL;
    property _MARS:TTag_EVENT_DETAIL read f_MARS write f_MARS;
    property _EVEN:TTag_EVENT_DETAIL read f_EVEN write f_EVEN;

    property _HUSB:TTag read f_HUSB write f_HUSB;
    property _WIFE:TTag read f_WIFE write f_WIFE;
    property _CHIL:TTag read f_CHIL write f_CHIL;
    property _NCHI:TTag read f_NCHI write f_NCHI;
    property _SUBM:TTag read f_SUBM write f_SUBM;

    property _SLGS:TTag_LDS_SPOUSE_SEALING read f_SLGS write f_SLGS;
    property _SOUR:TTag_SOURCE_CITATION read f_SOUR write f_SOUR;

    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
    property _REFN:TTag_USER_REFERENCE_NUMBER read f_REFN write f_REFN;
    property _RIN:TTag read f_RIN write f_RIN;
    property _CHAN:TTag_CHANGE_DATE read f_CHAN write f_CHAN;

    //type d'union (à nous)
    property _TYPU:TTag read f_TYPU write f_TYPU;

//    property _LATI: TTag read f_LATI write f_LATI;
//    property _LONG: TTag read f_LONG write f_LONG;

  end;

  { TTag_LDS_SPOUSE_SEALING }

  TTag_LDS_SPOUSE_SEALING=class(TTag)
  private
    f_DATE,
    f_STAT,
    f_PLAC,
    f_TEMP:TTag;
    f_NOTE:TTag_NOTE_STRUCTURE;
    f_SOUR:TTag_SOURCE_CITATION;
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
  published
    property _STAT:TTag read f_STAT write f_STAT;
    property _DATE:TTag read f_DATE write f_DATE;
    property _TEMP:TTag read f_TEMP write f_TEMP;
    property _PLAC:TTag read f_PLAC write f_PLAC;
    property _SOUR:TTag_SOURCE_CITATION read f_SOUR write f_SOUR;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;

  end;

  { TTag_DATA_SOURCE_RECORD }

  TTag_DATA_SOURCE_RECORD=class(TTag)
  private
    f_EVEN:TTag_EVENT_RECORD;
    f_AGNC:TTag;
    f_NOTE:TTag_NOTE_STRUCTURE;

  public
    function AsLine:string;
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;

  published
    property _EVEN:TTag_EVENT_RECORD read f_EVEN write f_EVEN;
    property _AGNC:TTag read f_AGNC write f_AGNC;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;

  end;

  { TTag_SOURCE_RECORD }

  TTag_SOURCE_RECORD=class(TTag)
  private
    f_DATA:TTag_DATA_SOURCE_RECORD;
    f_AUTH:TTag_MEMO;
    f_TITL:TTag_MEMO;
    f_ABBR:TTag;
    f_PUBL:TTag_MEMO;
    f_TEXT:TTag_MEMO;
    f_REPO:TTag_REPO_RECORD;
    f_OBJE:TTag_MEDIA;//AL
    f_NOTE:TTag_NOTE_STRUCTURE;
    f_REFN:TTag;
    f_CHAN:TTag_CHANGE_DATE;

  protected
    procedure DoAttachInList; override;
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    function AsLine:string;

  published
    property _DATA:TTag_DATA_SOURCE_RECORD read f_DATA write f_DATA;
    property _AUTH:TTag_MEMO read f_AUTH write f_AUTH;
    property _TITL:TTag_MEMO read f_TITL write f_TITL;
    property _ABBR:TTag read f_ABBR write f_ABBR;
    //property _EVEN: TTag read f_EVEN write f_EVEN;
    property _PUBL:TTag_MEMO read f_PUBL write f_PUBL;
    property _TEXT:TTag_MEMO read f_TEXT write f_TEXT;
    property _REPO:TTag_REPO_RECORD read f_REPO write f_REPO;
    property _OBJE:TTag_MEDIA read f_OBJE write f_OBJE;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
    property _REFN:TTag read f_REFN write f_REFN;//0:M
    property _CHAN:TTag_CHANGE_DATE read f_CHAN write f_CHAN;
  end;

  { TTag_NOTE_RECORD }

  TTag_NOTE_RECORD=class(TCustomTagMemo)

  private

    f_CONC,
    f_CONT:TTag;
    f_SOUR:TTag_SOURCE_CITATION;
    f_REFN:TTag;
    f_CHAN:TTag_CHANGE_DATE;

  protected
    procedure DoAttachInList; override;
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    function AsLine:string; override;

  published
    property _CONC:TTag read f_CONC write f_CONC;
    property _CONT:TTag read f_CONT write f_CONT;

    property _SOUR:TTag_SOURCE_CITATION read f_SOUR write f_SOUR;
    property _REFN:TTag read f_REFN write f_REFN;//0:M
    property _CHAN:TTag_CHANGE_DATE read f_CHAN write f_CHAN;
  end;

  { TTag_REPO_RECORD }

  TTag_REPO_RECORD=class(TTag)

  private
    f_REFN,
    f_NAME:TTag;
    f_ADDR:TTag_ADDRESS_STRUCTURE;
    f_CHAN:TTag_CHANGE_DATE;
    f_NOTE:TTag_NOTE_STRUCTURE;
  protected
    procedure DoAttachInList; override;
  public
    procedure AfterCreate(const aGedComStructure: TGedComStructure); override;
    function AsLine:string;

  published
    property _NAME:TTag read f_NAME write f_NAME;
    property _ADDR:TTag_ADDRESS_STRUCTURE read f_ADDR write f_ADDR;
    property _NOTE:TTag_NOTE_STRUCTURE read f_NOTE write f_NOTE;
    property _REFN:TTag read f_REFN write f_REFN;//0:M
    property _CHAN:TTag_CHANGE_DATE read f_CHAN write f_CHAN;
  end;


var
  M_OBJE:TTag_MEDIA;
  C_CHAN:TTag_CHANGE_DATE;

implementation

uses
  u_dm,
  FileUtil,
  LazUTF8,
  LConvEncoding,
  SysUtils;

{ TCustomTagMemo }

function TCustomTagMemo.AsLine: string;
var
  n:integer;
begin
  result:=Value;
  for n:=0 to AMemo.Count-1 do
    result:=result+#13#10+AMemo[n];
 end;

constructor TCustomTagMemo.Create;
begin
  inherited Create;
  amemo:=nil;
end;

destructor TCustomTagMemo.Destroy;
begin
  inherited Destroy;
  AMemo.Free;
end;

procedure TCustomTagMemo.Clear;
begin
  AMemo.Clear;
  inherited Clear;
end;

procedure TCustomTagMemo.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  if amemo = nil Then
    AMemo:=TStringlistUTF8.Create;
  inherited AfterCreate(aGedComStructure);
end;

{ TObjectIndentifed }

constructor TObjectIdentified.Create;
begin
  FId:='';
end;

{ TIdentifiedList }

function TIdentifiedList.GetItem(const Index: Integer): TObjectIdentified;
begin
  Result := TObjectIdentified ( inherited GetItem ( Index ));
end;

procedure TIdentifiedList.SetItem(const Index: Integer; const AObject: TObjectIdentified);
begin
  inherited SetItem ( Index, Aobject );
end;

function TIdentifiedList.GetObjectIdentifiedById(const AnId: String): TObjectIdentified;
var
  n:integer;
begin
  result:=nil;
  for n:=0 to Count-1 do
  begin
    if Items[n].ID=anID then
    begin
      result:=Items[n];
      break;
    end;
  end;
end;

{ TTagList }

function TTagList.GetItem(const Index: Integer): TTag;
begin
  Result := TTag ( inherited GetItem ( Index ));
end;

procedure TTagList.SetItem(const Index: Integer; const AObject: TTag);
begin
  inherited SetItem ( Index, Aobject );
end;

function TTagList.GetTagById(const AnId: String): TTag;
var
  n:integer;
begin
  result:=nil;
  for n:=0 to Count-1 do
  begin
    if Items[n].ID=anID then
    begin
      result:=Items[n];
      break;
    end;
  end;
end;

{ TTag_SPOUSE_TO_FAMILY_LINK }

procedure TTag_SPOUSE_TO_FAMILY_LINK.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_NOTE:=nil;
end;

{ TTag_CHILD_TO_FAMILY_LINK }

procedure TTag_CHILD_TO_FAMILY_LINK.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_PEDI:=nil;
  f_NOTE:=nil;
end;

{ TTag_ASSOCIATION_STRUCTURE }

procedure TTag_ASSOCIATION_STRUCTURE.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_RELA:=nil;
  f_NOTE:=nil;
  f_SOUR:=nil;
end;

{ TTag_LDS_SPOUSE_SEALING }

procedure TTag_LDS_SPOUSE_SEALING.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_DATE:=nil;
  f_STAT:=nil;
  f_PLAC:=nil;
  f_TEMP:=nil;
  f_NOTE:=nil;
  f_SOUR:=nil;
end;

{ TTag_PLACE_STRUCTURE }

procedure TTag_PLACE_STRUCTURE.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_FORM:=nil;
  f_NOTE:=nil;
  //f_SOUR:=nil; //pas utilisé par Ancestro
  f_MAP:=nil; //AL2011
end;

{ TTag_Personal_Name_Structure }

procedure TTag_Personal_Name_Structure.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_SURN:=nil;
  f_NSFX:=nil;
  f_NPFX:=nil;

  f_NCHI:=nil;
  f_NMR:=nil;

  f_GIVN:=nil;
  f_SPFX:=nil;
  f_NICK:=nil;

  f_NOTE:=nil;
  f_SOUR:=nil;
end;

{ TTag_PLAC }

procedure TTag_PLAC.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_FORM:=nil;
end;

{ TTag_DOMICILE }

procedure TTag_DOMICILE.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  fCle:=-1;

  f_ADDR:=nil;

  f_CITY:=nil;
  f_EMAIL:=nil;
  f_POST:=nil;
  f_STAE:=nil;
  f_CTRY:=nil;
  f_ANCES_REG:=nil;
  f_DEPT:=nil;
  f_ADR1:=nil;
  f_ADR2:=nil;
  f_TEL:=nil;
  f_PHON:=nil;
  f_DATE:=nil;
  f_WWW:=nil;
  f_OBJE:=nil;

  f_ANCES_XINSEE:=nil;
  f_FILE:=nil;
  f_SUBD:=nil;
  f_LATI:=nil;
  f_LONG:=nil;
  f_NOTE:=nil;//AL
end;

{ TTag_MEDIA }

procedure TTag_MEDIA.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  fCle:=-1;
  f_OBJE:=nil;
  f_FORM:=nil;
  f_FILE:=nil;
  f_XIDEN:=nil;
  f__IDEN:=nil;//AL
  f__POI:=nil;//AL 2010
  f_XTYPE:=nil;
  f_XMODE:=nil;
  f_XACTE:=nil;
  f_NOTE:=nil;//AL
end;

{ TTag_EVENT_RECORD }

procedure TTag_EVENT_RECORD.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_DATE:=nil;
  f_PLAC:=nil;
end;

{ TTag_AGE_AT_EVENT }

procedure TTag_AGE_AT_EVENT.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_AGE:=nil;
end;

{ TTag_USER_REFERENCE_NUMBER }

procedure TTag_USER_REFERENCE_NUMBER.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_TYPE:=nil;
end;

{ TTag_TRANSMISSION_DATE }

procedure TTag_TRANSMISSION_DATE.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_TIME:=nil;
end;

{ TTag_DATE_CHANGE_DATE }

procedure TTag_DATE_CHANGE_DATE.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_TIME:=nil;
end;

{ TTag_EVENT_TYPE_CITED_FROM }

procedure TTag_EVENT_TYPE_CITED_FROM.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_ROLE:=nil;

end;

{ TTag_MAP }

procedure TTag_MAP.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_LATI:=nil;
  f_LONG:=nil;
end;

{ TTag_CHAR }

procedure TTag_CHAR.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_VERS:=nil;

end;

{ TTag_GEDC }

procedure TTag_GEDC.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_VERS:=nil;
  f_FORM:=nil;

end;

{ TTag_NAME_OF_SOURCE_DATA }

procedure TTag_NAME_OF_SOURCE_DATA.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_DATE:=nil;
  f_COPR:=nil;
end;

{ TTag_NAME_OF_BUSINESS }

procedure TTag_NAME_OF_BUSINESS.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_ADDR:=nil;
  f_PHON:=nil;

end;
{ TTag_APPROVED_SYSTEM_ID }

procedure TTag_APPROVED_SYSTEM_ID.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_NAME:=nil;
  f_VERS:=nil;
  f_CORP:=nil;
  f_DATA:=nil;

end;

{ TTag_HEADER_RECORD }

procedure TTag_HEADER_RECORD.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_SOUR:=nil;
  f_DEST:=nil;
  f_LANG:=nil;
  f_DATE:=nil;
  f_SUBN:=nil;
  f_SUBM:=nil;
  f_FILE:=nil;
  f_COPR:=nil;
  f_CHAR:=nil;
  f_GEDC:=nil;
  f_PLAC:=nil;
  f_NOTE:=nil;//AL 2009

end;

{ TTag_Event_Detail }

procedure TTag_Event_Detail.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_AGE:=nil;
  f_CAUS:=nil;
  f_DATE:=nil;
  f_TIME:=nil;
  f_TYPE:=nil;
  f_AGNC:=nil;
  f_SOUR:=nil;
  f_NOTE:=nil;
  f_PLAC:=nil;
  f_ADDR:=nil;
  f_PHON:=nil;
  f_EMAIL:=nil;
  f_FAX:=nil;
  f_WWW:=nil;//AL
  f_ASSO:=nil;

  f_LIEU:=nil;
  f_ANCES_XINSEE:=nil;
  f_ANCES_ORDRE:=nil;
  f__ORDR:=nil;//AL
  f_ANCES_XACTE:=nil;
  f__ACTE:=nil;//AL

  f_LATI:=nil;
  f_LONG:=nil;
  f_DESC:=nil;//PCM ancien tag à supprimer, utilisé dans soumission
  f_OBJE:=nil;//AL
  fCle:=-1;

end;


function TTag_SOURCE_CITATION.AsLine:string;
var
  aTEXT:TTag_MEMO;
  aNOTE:TTag_NOTE_STRUCTURE;
  aImportGedcom:TImportGedCom;
  aSour:TBlock;
begin
  result:='';
  //Soit une source normale
  if ID='' then
  begin
    result:=inherited;

    aTEXT:=f_TEXT;
    while (aTEXT<>nil) do
    begin
      result:=result+#13#10;
      result:=result+aTEXT.AsLine;

      aTEXT:=TTag_MEMO(aTEXT.PtrNextSameTag);
    end;

    aNOTE:=f_NOTE;
    while (aNOTE<>nil) do
    begin
      result:=result+#13#10;
      result:=result+f_NOTE.AsLine;

      aNOTE:=TTag_NOTE_STRUCTURE(aNOTE.PtrNextSameTag);
    end;
  end
  else//soit une source qui pointe ailleurs + d'autres infos
  //erreur/GEDCOM confusion des niveaux SOURCE_CITATION et SOURCE_RECORD
  //on devrait d'abord importer SOURCE_CITATION avant SOURCE_RECORD s'ils étaient correctement définis.
  begin
      //On cherche la source qui porte l'ID
    if Assigned(fPtrGedComStructure) then
    begin
      aImportGedcom:=TImportGedCom(fPtrGedComStructure.PtrObjetImportGedcom);
      aSour:=aImportGedcom.GetSourceByID(ID);
      if assigned(aSour) then
        result:=result+asour.GedcomBlock.GetSourAsString;
    end;

    if f_PAGE<>nil then
    begin
      result:=result+#13#10;
      result:=result+'PAGE: '+f_PAGE.Value;
    end;

    if f_EVEN<>nil then
    begin
      result:=result+#13#10;
      result:=result+'EVENT:'+f_EVEN.Value;
      if f_EVEN._ROLE<>nil then
      begin
        result:=result+#13#10;
        result:=result+'ROLE: '+f_EVEN._ROLE.Value;
      end;
    end;

    if f_DATA<>nil then
    begin
      result:=result+#13#10;
      result:=result+_DATA.AsLine;
    end;

    if f_QUAY<>nil then
    begin
      result:=result+#13#10;
      result:=result+'QUAY:'+f_QUAY.Value;
    end;

    aNOTE:=f_NOTE;
    while (aNOTE<>nil) do
    begin
      result:=result+#13#10;
      result:=result+f_NOTE.AsLine;

      aNOTE:=TTag_NOTE_STRUCTURE(aNOTE.PtrNextSameTag);
    end;

  end;
end;

{ TTag_SOURCE_RECORD }

function TTag_SOURCE_RECORD.AsLine:string;
var
  aNOTE_STRUCTURE:TTag_NOTE_STRUCTURE;
  aREFN:TTag;
  //     aTagRepoRecord: TTag_REPO_RECORD;
  aImportGedcom:TImportGedCom;
  obRepo:TBlock;
begin
  result:='';

//  if f_EVEN <> nil then  // est dans SOURCE_CITATION
//    begin
//      result := result + #13#10;
//      result := result + #13#10;
//      result := result + 'EVEN: ' + f_EVEN.Value;
//      s_EVEN := f_EVEN.Value;
//    end;

  if f_DATA<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'DATA: '+f_DATA.AsLine;
  end;

  if f_AUTH<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'AUTH: '+f_AUTH.AsLine;
    s_AUTH:=f_AUTH.AsLine;
  end;

  if f_TITL<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'TITL: '+f_TITL.AsLine;
    s_TITL:=f_TITL.AsLine;
  end;

  if f_ABBR<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'ABBR: '+f_ABBR.Value;
    s_ABBR:=f_ABBR.Value;
  end;

  if f_PUBL<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'PUBL: '+f_PUBL.AsLine;
    s_PUBL:=f_PUBL.AsLine;
  end;

  if f_TEXT<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'TEXT: '+f_TEXT.AsLine;
    s_TEXT:=f_TEXT.AsLine;
  end;

  if f_REPO<>nil then
  begin
    if f_REPO.ID>'' then
    begin
          //On cherche le repo qui porte l'ID
      if Assigned(fPtrGedComStructure) then
      begin
        aImportGedcom:=TImportGedCom(fPtrGedComStructure.FPtrObjetImportGedcom);
        obRepo:=aImportGedcom.GetRepoByID(f_REPO.ID);
        if obRepo<>nil then
         Begin
            s_REPO:=obRepo.GedcomBlock.GetREPOAsString;
            result:=result+s_REPO;

          end;
      end;
    end;
  end;

  aNOTE_STRUCTURE:=_NOTE;
  while (aNOTE_STRUCTURE<>nil) do
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'NOTE: '+aNOTE_STRUCTURE.AsLine;

    aNOTE_STRUCTURE:=TTag_NOTE_STRUCTURE(aNOTE_STRUCTURE.PtrNextSameTag);
  end;

  aREFN:=_REFN;
  while (aREFN<>nil) do
  begin
    result:=result+#13#10;
    result:=result+'REFN: '+aREFN.Value;

    aREFN:=aREFN.PtrNextSameTag;
  end;

  if f_CHAN<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+f_CHAN.AsLine;
  end;
  C_CHAN:=f_CHAN;

  M_OBJE:=f_OBJE;
end;

constructor TImportGedCom.Create;
begin
  Inherited;
  fOnProgress:=nil;
  PrepareProperties;
end;

destructor TImportGedCom.Destroy;
begin
  DestroyProperties;
  inherited;
end;

procedure TImportGedCom.Clear;
begin
  fEventsPossible.Clear;

  //Liste des individus
  fListIndi.Clear;
  fListFam.Clear;
  fListNote.Clear;
  fListSour.Clear;
  fListRepo.Clear;
end;

procedure TImportGedCom.ClearAll;
begin
  fGedcomStructureOfHeader.Clear;
  Clear;
end;

procedure TImportGedCom.DestroyProperties;
begin
  fGedcomStructureOfHeader.free;
  fEventsPossible.free;
  fListIndi.Free;
  fListFam.Free;
  fListSour.Free;
  fListNote.Free;
  fListRepo.Free;
end;

procedure TImportGedCom.CreateHeaderStructure;
begin
  fGedcomStructureOfHeader:=TGedComStructure.Create;
  fGedcomStructureOfHeader.InitStructure (self);
end;

procedure TImportGedCom.PrepareProperties;
begin

  CreateHeaderStructure;

  fEventsPossible:=TStringlistUTF8.Create;
  fListIndi:=TIdentifiedList.Create;
  fListFam:=TIdentifiedList.Create;
  fListSour:=TIdentifiedList.Create;
  fListNote:=TIdentifiedList.Create;
  fListRepo:=TIdentifiedList.Create;
end;

function TImportGedCom.DecodeLigne(ligne:string;var niveau:integer;var tag:string;var ID:string;var infos:string):boolean;
var
  p:integer;
begin
  result:=false;
  tag:='';
  ID:='';
  infos:='';
  repeat
    p:=pos(#9,ligne);
    if p>0 then
      delete(ligne,p,1);
  until p=0;
  ligne:=trim(ligne);
   //Level
  p:=pos(' ',ligne);
  if p>0 then
  begin
    niveau:=StrToIntDef(copy(ligne,1,p-1),-1);
    delete(ligne,1,p);
    if length(ligne)>0 then
    begin
      if ligne[1]<>'@' then //Soit le tag
      begin
        p:=pos(' ',ligne);
        if p=0 then
        begin
          tag:=ligne;
        end
        else
        begin
          tag:=copy(ligne,1,p-1);
          delete(ligne,1,p);
          if length(ligne)>0 then
          begin
            if ligne[1]<>'@' then
              infos:=ligne
            else
            begin
              delete(ligne,1,1);
              p:=pos('@',ligne);
              if p<>0 then
              begin
                ID:=copy(ligne,1,p-1);
              end;
            end;
          end;
        end;
        result:=true;
      end
      else //Soit la référence
      begin
        delete(ligne,1,1);
        p:=pos('@',ligne);
        if p>0 then
        begin
          ID:=copy(ligne,1,p-1);
          delete(ligne,1,p+1);
          tag:=ligne;
          result:=true;
        end;
      end;
    end;
  end;
end;

function TImportGedCom.DecodageGedcom(const aGedComStructure:TGedComStructure;const Content:TStringlistUTF8;const JeuCaractere:TSetCodageCaracteres):boolean;
var
  p:integer;
  numLigne,PaquetLigne:integer;
  fStack:TObjectStack;
  ExclureLevelUpperThan:integer;
  TagLevel:integer;
  TagCaption:string;
  TagID:string;
  TagValue:string;
  canAnalyseTag:boolean;
  CanCreateTag:boolean;
  TagIndex:integer;
  NewSubTag:TTag;
  TagPere:TTag;
  F:THandle;
  line:string;

  procedure DecodageLigne(const aLine:string);
  var
    n:integer;
  begin
    //Décodage de la ligne
    if DecodeLigne(aLine,TagLevel,TagCaption,TagID,TagValue) then
    begin
      if TagLevel<ExclureLevelUpperThan then
      begin
        canAnalyseTag:=false;
        ExclureLevelUpperThan:=maxInt;
        //soit on est dans un sous-niveau du pere actuel
        if TagLevel=TagPere.Level+1 then
          canAnalyseTag:=true
          //soit on saute plusieurs sous-niveaux du pere actuel (impossible)
        else if TagLevel>TagPere.Level+1 then
          canAnalyseTag:=false
          //soit on remonte le(s) pere(s) sur un ou plusieurs niveaux
        else if TagLevel<=TagPere.Level then
        begin //On désempile le(s) pere(s)
          for n:=TagLevel to TagPere.Level do
            TagPere:=TTag(fStack.Pop);
          canAnalyseTag:=true;
        end;
        if canAnalyseTag then
        begin //si c'est un mémo, traitement spécial
          if  (TagPere is TCustomTagMemo)
          and((TagCaption='CONT')or(TagCaption='CONC')) then
           with TCustomTagMemo(TagPere) do
            begin
              if TagCaption='CONT' then
                Memo.Add(TagValue)
              else //TagCaption = 'CONC'
              begin
                n:=Memo.Count;
                if n>0
                  then Memo[n-1]:=Memo[n-1]+TagValue
                  else Value:=Value+TagValue; //AL 2009
              end;
            end
          else if TagPere.Simple=false then
            begin //on regarde si le tag est dans la liste des tags possible du Tag en cours.
              if TagPere.ExistSubTag(TagCaption,TagIndex) then
              begin //si ce Tag est un Tag_MEMO, création d'une instance, pour ce record
                CanCreateTag:=true;
                //si ce futur Tag est un event, alors
                if (TagPere.ClassSubTags[TagIndex]=TTag_EVENT_DETAIL) then
                begin //ce tag est-il autorisé ?
                  CanCreateTag:=fEventsPossible.IndexOf(TagCaption)<>-1;
                end;
                if CanCreateTag then
                begin
                  NewSubTag:=TTag(TagPere.ClassSubTags[TagIndex].Create);
                  //Initialisation de l'objet
                  NewSubTag.AfterCreate(aGedComStructure);
                  //si ce Tag est en multi-instance
                  TagPere.InsertLast(TagIndex,NewSubTag);
                  //remplissage du nouveau Tag
                  with NewSubTag do
                   Begin
                    Caption:=TagCaption;
                    ID:=TagID;
                    Value:=TagValue;
                    Level:=TagLevel;
                   end;
                  //Si ce n'est pas un tag terminal, alors on entre dedans
                  if NewSubTag.Simple=false then
                  begin //On mémorise le pere de ce Tag
                    fStack.Push(TagPere);
                    //Le TagPere devient ce nouveau Tag, puisqu'il n'est pas Simple
                    TagPere:=NewSubTag;
                  end;
                end;
              end
            else
              begin
                //fMemoLoadResult.Add('UNK  ->  ' + fContent[numLigne]);
              end;
          end
          else
          begin
            //fMemoLoadResult.Add('TGS  ->  ' + fContent[numLigne]);
          end;
        end
        else
        begin //On ne connait pas ce tag, donc, pour les prochaines lignes, on ignore les tags de niveau suppérieur
          ExclureLevelUpperThan:=TagLevel;
          //fMemoLoadResult.Add('CNA  ->  ' + fContent[numLigne]);
        end;
      end
      else
      begin
        //fMemoLoadResult.Add('EXC  ->  ' + fContent[numLigne]);
      end;
    end
    else
    begin
      //fMemoLoadResult.Add('DEC  ->  ' + fContent[numLigne]);
    end;
    inc(numLigne);
    if PaquetLigne<50 then
      inc(PaquetLigne)
    else
    begin
      PaquetLigne:=0;
    end;
  end;

begin
  result:=true;
  try
    numLigne:=0;
    PaquetLigne:=0;
    ExclureLevelUpperThan:=MaxInt;
    fStack:=TObjectStack.Create;
    try
      //Le pere de tous
      TagPere:=aGedComStructure;
      if Content=nil then
      begin
        //On boucle sur les lignes du fichier GedCom
        F:=FileOpenUTF8(fPathFileName,fmOpenRead);
        try
          try
            while FileReadlnOriginal(f,line,JeuCaractere)>0 do
            begin //on lit une ligne
              line:=trim(line);
              //Décodage de la ligne
              DecodageLigne(line);
            end;
          finally
            FileClose(F);
          end;
        except
          result:=false;
        end;
      end
      else
       for p:=0 to content.count-1 do
         DecodageLigne(Content[p]);
    finally
      fStack.Free;
    end;
  except
    result:=false;
  end;
end;

function TImportGedCom.LoadFromFileJustTheHeader(const aPathFileName:string;const aContent:TStringlistUTF8;const JeuCaractere:TSetCodageCaracteres):boolean;
var
  s:string;
  li_Handle:THandle;
begin
  aContent.Clear;
  li_Handle := FileOpenUTF8(aPathFileName, fmOpenRead );
  try
    try
      // no charset when reading first time
      while FileReadlnUTF8(li_Handle,s,JeuCaractere) > 0 do
      begin
        s:=trim(s);
        if copy(s,1,2)='0 ' then
        begin
          if s<>'0 HEAD' then
              Break;
        end;
        aContent.Add(s);
      end;
      result:=true;
    finally
      FileClose(li_Handle);
    end;
  except
    result:=false;
  end;
end;

function TImportGedCom.LoadFromFileQuelquesExemplesDeNoms(const aPathFileName:string;const aContent:TStringListUTF8; const JeuCaractere:TSetCodageCaracteres):boolean;
var
  s:string;
  li_Handle : THandle;
begin
  aContent.Clear;
  li_Handle := FileOpenUTF8(aPathFileName, fmOpenRead );
  try
    try
      while FileReadlnUTF8(li_Handle,s,JeuCaractere) > 0 do
      begin
        s:=trim(s);
        if copy(s,1,7)='1 NAME ' then
        begin
          delete(s,1,7);
          aContent.Add(s);
          if aContent.count>=20 then
            Break;
        end;
      end;
      result:=true;
    finally
      FileClose(li_Handle);
    end;
  except
    result:=false;
  end;
end;

function TImportGedCom.LoadFromFileQuelquesAdresses(const aPathFileName:string;const aContent:TStringlistUTF8;const JeuCaractere:TSetCodageCaracteres):boolean;
var
  s:string;
  li_Handle : THandle;
begin
  aContent.Clear;
  li_Handle := FileOpenUTF8(aPathFileName, fmOpenRead );
  try
    try
      while FileReadlnUTF8(li_Handle,S,JeuCaractere)>0 do
      begin
        s:=trim(s);
        if copy(s,1,7)='2 PLAC ' then
        begin
          delete(s,1,7);
          aContent.Add(s);
          if aContent.count>=10 then //AL était 20 alors qu'ensuite on n'en utilise que 10
            Break;
        end;
      end;
      result:=true;
    finally
      FileClose(li_Handle);
    end;
  except
    result:=false;
  end;
end;

procedure TImportGedCom.PrepareIndividusAndFamilles(const JeuCaractere:TSetCodageCaracteres);
var
  s:string;
  li_Handle : THandle;
  TagLevel:integer;
  TagCaption:string;
  TagID:string;
  TagValue:string;
  indi:TIndi;
  fam:TFam;
  sour:TBlock;
  note:TBlock;
  repo:TBlock;

begin
  indi:=nil;
  try
    li_Handle := FileOpenUTF8(FPathFileName, fmOpenRead );
    try
      while FileReadlnOriginal(li_Handle,s,JeuCaractere)>0 do
      begin
          //on lit une ligne
        if copy(S,1,2)='0 ' then
        begin
          if DecodeLigne(s,TagLevel,TagCaption,TagID,TagValue) then
          begin
            if TagCaption='INDI' then
            begin
              indi:=TIndi.Create;
              indi.Cle:=dm.uf_GetClefUnique('INDIVIDU');
              indi.ID:=TagID;
              fListIndi.Add(indi);

              if assigned(fOnProgress) then fOnProgress(self,0);
            end
            else if TagCaption='FAM' then
            begin
              fam:=TFam.Create;
              fam.Cle:=dm.uf_GetClefUnique('T_UNION');
              fam.ID:=TagID;
              fListFam.Add(fam);

              if assigned(fOnProgress) then fOnProgress(self,0);
            end
            else if TagCaption='SOUR' then
            begin
              sour:=TBlock.Create;
              sour.FirstLine:=s;
              sour.ID:=TagID;
              fListSour.Add(sour);
            end
            else if TagCaption='NOTE' then
            begin
              note:=TBlock.Create;
              note.FirstLine:=s;
              note.ID:=TagID;
              fListNote.Add(note);
            end
            else if TagCaption='REPO' then
            begin
              repo:=TBlock.Create;
              repo.FirstLine:=s;
              repo.ID:=TagID;
              fListRepo.Add(repo);
            end
          end;
        end
        else
        begin
          if copy(S,1,6)='1 SEX ' then //utilisé uniquement pour distinguer "GODPARENT" Parrain de Marraine
          begin  //dans le décodage de l'associé
            if DecodeLigne(s,TagLevel,TagCaption,TagID,TagValue) then
            begin
              if (indi<>nil)and(indi.SEXE='') then
              begin
                indi.SEXE:=TagValue;
              end;
            end;
          end;
              //pourquoi décoder ici ces tags alors que c'est fait ensuite? AL2011
          {    // modif du 20/09/2004 pour le NCHI et NMR pour l individu --------------------------
          if copy(S,1,7)='1 NCHI ' then
          begin
            if DecodeLigne(s,TagLevel,TagCaption,TagID,TagValue) then
            begin
              if (TagCaption='NCHI')and(TagLevel=1)and(indi<>nil)and(indi.NCHI='') then
              begin
                indi.NCHI:=TagValue;
              end;
            end;
          end;

          if copy(S,1,6)='1 NMR ' then
          begin
            if DecodeLigne(s,TagLevel,TagCaption,TagID,TagValue) then
            begin
              if (TagCaption='NMR')and(TagLevel=1)and(indi<>nil)and(indi.NMR='') then
              begin
                indi.NMR:=TagValue;
              end;
            end;
          end;}
        end;
      end;
    finally
      FileClose(li_Handle);
    end;
  except
  end;
end;

{ TIndi }

constructor TIndi.Create;
begin
  Inherited;
  fCle:=-1;
//  fCLE_PARENTS:=-1;
//  fCLE_PERE:=-1;
//  fCLE_MERE:=-1;
  fSexe:='';
end;

{ TFam }

constructor TFam.Create;
begin
  Inherited;
  fCLE:=-1;
  fCLEF_HUSB:=-1;
  fCLEF_WIFE:=-1;
//  fAlreadySaveThisUnion:=false;
end;

function TImportGedCom.GetIndividuByID(const aID:string):TIndi;
begin
  result:=TIndi(fListIndi.GetObjectIdentifiedById(aID));
end;

function TImportGedCom.GetFamilleByID(const aID:string):TFam;
begin
  result:=TFam(fListFam.GetObjectIdentifiedById(aID));
end;

function TImportGedCom.GetIndividuByCle(const aCLE:integer):TIndi;
var
  n:integer;
begin
  result:=nil;
  for n:=0 to fListIndi.Count-1 do
  begin
    if TIndi(fListIndi[n]).CLE=aCLE then
    begin
      result:=TIndi(fListIndi[n]);
      break;
    end;
  end;
end;


{ TComment }

function TImportGedCom.GetSourceByID(const aID:string):TBlock;
begin
  result:=GetBlockByID(fListSour,aID);
end;


function TImportGedCom.GetBlockByID(const AList:TIdentifiedList;const aID:string):TBlock;
begin
  result:=TBlock(AList.GetObjectIdentifiedById(aID));
end;


{ TBlock }

constructor TBlock.Create;
begin
  Inherited;
  fGedcomBlock:=TGedComStructure.Create;
end;

destructor TBlock.destroy;
begin
  inherited;
  fGedcomBlock.Destroy;
end;

function TImportGedCom.GetNoteByID(const aID:string):TBlock;
begin
  result:=GetBlockByID(fListNote,aID);
end;

function TImportGedCom.GetRepoByID(const aID:string):TBlock;
begin
  result:=GetBlockByID(fListRepo,aID);
end;



{ TTag }

procedure TTag.AfterCreate(const aGedComStructure:TGedComStructure);
begin
  //     fMultiple := false;
  fSimple:=true;
  //Création des listes d'accueil des tags
  fCaptionSubTags:=nil;
  fClassSubTags:=nil;
  fObjectSubTags:=nil;
  fPropInfoSubTags:=nil;

  fPtrNextSameTag:=nil;
  fPtrGedComStructure:=aGedComStructure;

  DoAttachInList;
  DoIntrospection;
end;

destructor TTag.Destroy;
begin
  // these objects can be nil
  FreeAndNil(fClassSubTags);
  FreeAndNil(fObjectSubTags);
  FreeAndNil(fCaptionSubTags);
  FreeAndNil(fPropInfoSubTags);

  inherited;

end;

procedure TTag.Clear;
begin
  fValue:='';
  fID:='';
  fCaption:='';
  fSimple:=False;
  if fClassSubTags = nil
   Then Exit;
  fClassSubTags.Clear;
  fObjectSubTags.Clear;
  fPropInfoSubTags.Clear;
  fCaptionSubTags.Clear;
end;

procedure TTag.DoAttachInList;
begin
  //par défaut, l'objet est attaché dans la liste des 'OtherList'
  if Assigned(fPtrGedComStructure) then
  with fPtrGedComStructure do
   Begin
    fOtherList.Add(self);
    fAllList.Add(self);
   end;
end;

procedure TTag.InsertLast(const TagIndex : Integer;  const ATag: TTag);
begin
  if (FObjectSubTags[TagIndex]=nil) then
  begin //Affectation de l'instance à la propriété du Record père
    SetObjectProp(Self,FPropInfoSubTags[TagIndex],ATag);
    FObjectSubTags[TagIndex]:=ATag;
  end
  else
   //on fait un lien vers le nouveau tag créé - on cherche le dernier
    FObjectSubTags[TagIndex].GetLastNextSameTag.PtrNextSameTag:=ATag;

end;

function TTag.GetLastNextSameTag: TTag;
begin
  Result := Self;
  while Assigned (Result.fPtrNextSameTag) do
   Result := Result.fPtrNextSameTag;
end;

constructor TTag.Create;
begin
  Inherited;
  //     fMultiple := false;
  fSimple:=true;
  //Création des listes d'accueil des tags
  fCaptionSubTags:=nil;
  fClassSubTags:=nil;
  fObjectSubTags:=nil;
  fPropInfoSubTags:=nil;

  fPtrNextSameTag:=nil;
  fPtrGedComStructure:=nil;

  //     fLinkLastInstance := nil;
end;

procedure TTag.DoIntrospection;
var
  k,w:integer;
  fList:PPropList;
  FSize:Integer;
  FCount:Integer;
  PropInfo:PPropInfo;
  aClass:TClass;
  //    aObject: TObject;
  s:string;
begin
  FCount:=GetTypeData(ClassInfo)^.PropCount;

  //Ce Tag possède t'il d'autres Tags ?
  if FCount>0 then
  begin
    fSimple:=false;

    FSize:=FCount*SizeOf(PPropInfo);
    GetMem(FList,FSize);
    try
      if not assigned ( fCaptionSubTags ) Then
       Begin
        fCaptionSubTags:=TStringListUTF8.create;
        fClassSubTags:=TClassList.create;
        fObjectSubTags:=TTagList.create(false);
        fPropInfoSubTags:=TList.create;
       end;

      k:=GetPropList(self.ClassInfo, [tkClass],FList);
      for w:=1 to k do
      begin
        s:=FList^[w-1].Name;
        PropInfo:=GetPropInfo(self.ClassInfo,s);
        if PropInfo<>nil then
        begin
          SetObjectProp(self,PropInfo,nil);

          aClass:=GetObjectPropClass(self,s);
          delete(s,1,1);

          fCaptionSubTags.Add(s);
          fClassSubTags.Add(aClass);
          fObjectSubTags.Add(nil);
          fPropInfoSubTags.Add(PropInfo);

        end;
      end;
    finally
      FreeMem(FList,FSize);
    end;
  end;
end;

function TTag.ExistSubTag(TagName:string;var index:integer):boolean;
begin
  if fSimple=false then
  begin
    index:=fcaptionSubTags.IndexOf(TagName);
    result:=index<>-1;
  end
  else
    result:=false;
end;

function TGedComStructure.GetRepoAsString: String;
begin
  if Assigned(f_repo)
   Then Result := f_Repo.AsLine
   Else Result := '';
end;

function TGedComStructure.GetSourAsString: String;
begin
  if Assigned(f_Sour)
   Then Result := f_Sour.AsLine
   Else Result := '';

end;

function TGedComStructure.GetNoteAsString: String;
begin
  if Assigned(f_Note)
   Then Result := f_Note.AsLine
   Else Result := '';
end;

constructor TGedComStructure.Create;
begin
  inherited;

  fIndividuList:=TTagList.Create(true);
  fFamilleList:=TTagList.Create(true);
  fOtherList:=TTagList.Create(true);
  fNoteList:=TTagList.Create(true);
  fSourceList:=TTagList.Create(true);
  fRepoList:=TTagList.Create(true);

  fAllList:=TTagList.Create(false);

  fPtrObjetImportGedcom:=nil;
  f_TRLR:=nil;
  f_HEAD:=nil;
  f_INDI:=nil;
  f_FAM:=nil;
  f_SOUR:=nil;
  f_NOTE:=nil;
  f_REPO:=nil;
end;

destructor TGedComStructure.Destroy;
begin
  inherited;

  FreeAndNil(fIndividuList);
  FreeAndNil(fFamilleList);
  FreeAndNil(fOtherList);
  FreeAndNil(fNoteList);
  FreeAndNil(fSourceList);
  FreeAndNil(fRepoList);
  FreeAndNil(fAllList);

end;

procedure TTag_INDIVIDUAL_RECORD.DoAttachInList;
begin
  if Assigned(fPtrGedComStructure) then
  with fPtrGedComStructure do
   Begin
     fIndividuList.Add(self);
     fAllList.Add(self);
   End;
end;

procedure TTag_INDIVIDUAL_RECORD.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  fCle:=-1;
//  fCLE_PARENTS:=-1;
  fCLE_PERE:=-1;
  fCLE_MERE:=-1;
  inherited;
  f_SEX:=nil;

  f_NCHI:=nil;
  f_NMR:=nil;
  f_LEGA:=nil;//AL

  f_RESN:=nil;
  f_EMIG:=nil;
  f_DIPL:=nil;
  f_PROB:=nil;
  f_FCOM:=nil;
  f_BURI:=nil;
  f_NATU:=nil;
  f_CHRA:=nil;
  f_ORDN:=nil;
  f_DEAT:=nil;
  f_RETI:=nil;
  f_WILL:=nil;
  f_CENS:=nil;
  f_BLES:=nil;
  f_CREM:=nil;
  f_BASM:=nil;
  f_IMMI:=nil;
  f_BAPM:=nil;
  f_BARM:=nil;
  f_GRAD:=nil;
  f_CONF:=nil;
  f_EVEN:=nil;
  f_CHR:=nil;
  f_BIRT:=nil;
  f_ADOP:=nil;
  f_NAME:=nil;
  f_TITL:=nil;
  f_RESI:=nil;
  f_CAST:=nil;
  f_DSCR:=nil;
  f_EDUC:=nil;
  f_IDNO:=nil;
  f_PROP:=nil;
  f_NATI:=nil;
  f_RELI:=nil;
  f_SSN:=nil;
  f_OCCU:=nil;
  f_CONL:=nil;
  f_ENDL:=nil;
  f_BAPL:=nil;
  f_SLGC:=nil;
  f_ALIA:=nil;
  f_AFN:=nil;
  f_ANCI:=nil;
  f_RFN:=nil;
  f_SUBM:=nil;
  f_RIN:=nil;
  f_DESI:=nil;
  //f_ASSO: =nil_ASSOCIATION_STRUCTURE;
  f_CHAN:=nil;
  f_FAMC:=nil;
  f_NOTE:=nil;//=nil_NOTE_STRUCTURE;
  f_SOUR:=nil;//SOURCE_CITATION;
  f_FAMS:=nil;
  f_REFN:=nil;

  f_SALE:=nil;
  f_PURC:=nil;
  f_MILI:=nil;
  f_ALIV:=nil;
  f_TRIP:=nil;
  f_BRIT:=nil;
  f_FILA:=nil; //pas standard
  f_INHU:=nil;

  f_ADDR:=nil;
  f_OBJE:=nil;

  // -- Ici les tags proprietaire d Ancestromania --------------------------------------------------------------------
  f_XSPO:=nil;// Sport
  f_XLOI:=nil;// Loisirs
  f_X_MU1:=nil;// Musulman
  f_X_MU2:=nil;// Musulman
  f_X_MU3:=nil;// Musulman
  f_XHENN:=nil;// Juif
  f_XHOUP:=nil;// Juif
end;

{ TTag_FAM_RECORD }

procedure TTag_FAM_RECORD.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_CHIL:=nil;
  f_RIN:=nil;
  f_HUSB:=nil;
  f_SUBM:=nil;
  f_NCHI:=nil;
  f_WIFE:=nil;
  f_CHAN:=nil;
  f_EVEN:=nil;
  f_ENGA:=nil;
  f_DIV:=nil;
  f_MARR:=nil;
  f_MARS:=nil;
  f_MARB:=nil;
  f_ANUL:=nil;
  f_MARC:=nil;
  f_CENS:=nil;
  f_DIVF:=nil;
  f_MARL:=nil;
  f_SLGS:=nil;
  f_NOTE:=nil;
  f_SOUR:=nil;
  f_REFN:=nil;

  fCLEF_HUSB:=-1;
  fCLEF_WIFE:=-1;
  fCLE:=-1;
//    fAlreadySaveThisUnion:boolean;
  f_TYPU:=nil;
end;
procedure TTag_FAM_RECORD.DoAttachInList;
begin
  if Assigned(fPtrGedComStructure) then
  with fPtrGedComStructure do
   Begin
     fFamilleList.Add(self);
     fAllList.Add(self);
   End;
end;

{ TTag_MEMO }
procedure TTag_MEMO.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_CONC:=nil;
  f_CONT:=nil;
end;

procedure TGedComStructure.Clear;
begin
  Inherited Clear;
  if fAllList = nil
   Then
    Exit;
  fAllList.Clear;
  fIndividuList.Clear;
  fFamilleList.Clear;
  fSourceList.Clear;
  fNoteList.Clear;
  fRepoList.Clear;

  DoIntrospection;
end;

procedure TGedComStructure.InitStructure(const APtrImport: TImportGedcom);
begin
  FPtrObjetImportGedcom := APtrImport;
  AfterCreate(nil);
  Level := -1;

end;

{ TTag_SOURCE_CITATION }

procedure TTag_SOURCE_CITATION.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  //f_SOUR:=nil;//AL2010 devrait être là
  f_CONC:=nil;
  f_CONT:=nil;
  f_PAGE:=nil;//pas utilisé
  f_EVEN:=nil;
  f_DATA:=nil; //gênant: existe dans SOURCE_CITATION et SOURCE_RECORD avec une structure différente
  f_QUAY:=nil;//pas utilisé
  f_NOTE:=nil;
  f_TEXT:=nil;
  f_ABBR:=nil; //erreur GEDCOM AL2010
  f_REPO:=nil; //erreur GEDCOM AL2010
  f_AUTH:=nil; //erreur GEDCOM AL2010
  f_TITL:=nil; //erreur GEDCOM AL2010
  f_PUBL:=nil; //erreur GEDCOM AL2010
  f_OBJE:=nil; //erreur GEDCOM AL2010
  f_CHAN:=nil; //erreur GEDCOM AL2010
end;

procedure TTag_SOURCE_RECORD.DoAttachInList;
begin
  if Assigned(fPtrGedComStructure) then fPtrGedComStructure.fSourceList.Add(self);
end;

procedure TTag_SOURCE_RECORD.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_DATA:=nil;
  f_AUTH:=nil;
  f_TITL:=nil;
  f_ABBR:=nil;
  f_PUBL:=nil;
  f_TEXT:=nil;
  f_REPO:=nil;
  f_OBJE:=nil;//AL
  f_NOTE:=nil;
  f_REFN:=nil;
  f_CHAN:=nil;
end;

{ TTag_NOTE_RECORD }

function TTag_NOTE_RECORD.AsLine:string;
var
  n:integer;
  aSOUR:TTag_SOURCE_CITATION;
  aREFN:TTag;
begin
  result:=inherited;

  aSOUR:=f_SOUR;
  while assigned(aSOUR) do
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+aSOUR.AsLine;

    aSOUR:=TTag_SOURCE_CITATION(aSOUR.PtrNextSameTag);
  end;

  aREFN:=f_REFN;
  while (aREFN<>nil) do
  begin
    result:=result+#13#10;
    result:=result+aSOUR.Value;
    aREFN:=TTag(aREFN.PtrNextSameTag);
  end;

  if f_CHAN<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+f_CHAN.AsLine;
  end;
end;

procedure TTag_NOTE_RECORD.DoAttachInList;
begin
  if Assigned(fPtrGedComStructure) then fPtrGedComStructure.fNoteList.Add(self);
end;

procedure TTag_NOTE_RECORD.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_CONC:=nil;
  f_CONT:=nil;
  f_SOUR:=nil;
  f_REFN:=nil;
  f_CHAN:=nil;
end;

{ TTag_REPO_RECORD }

procedure TTag_REPO_RECORD.DoAttachInList;
begin
  if Assigned(fPtrGedComStructure) then fPtrGedComStructure.fRepoList.Add(self);
end;

procedure TTag_REPO_RECORD.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_REFN:=nil;
  f_NAME:=nil;
  f_ADDR:=nil;
  f_CHAN:=nil;
  f_NOTE:=nil;
end;

{ TTag_NOTE_STRUCTURE }

procedure TTag_NOTE_STRUCTURE.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_CONC:=nil;
  f_CONT:=nil;
  f_SOUR:=nil;
end;

function TTag_NOTE_STRUCTURE.AsLine:string;
var
  n:integer;
  aSOUR:TTag_SOURCE_RECORD;
  obSour:TBlock;
  obNote:TBlock;
  aTagSourceRecord:TTag_SOURCE_RECORD;
  aImportGedcom:TImportGedCom;
begin
  result:='';

  //soit une note simple + des sources qui pointe ailleurs
  if ID='' then
  begin
    result:=inherited;

    aSOUR:=f_SOUR;
    while assigned(aSOUR) do
    begin
          //On cherche la source qui porte l'ID
      if Assigned(fPtrGedComStructure) then
      begin
        aImportGedcom:=TImportGedCom(fPtrGedComStructure.PtrObjetImportGedcom);
        obSour:=aImportGedcom.GetSourceByID(ID);
        if obSour<>nil then
          result:=result+obSour.GedcomBlock.GetSOURAsString;
      end;

      aSOUR:=TTag_SOURCE_RECORD(aSOUR.PtrNextSameTag);
    end;
  end
  else
    //soit une note qui pointe ailleurs, et des sources qui pointent ailleurs
  begin
      //On cherche la note qui porte l'ID
    if Assigned(fPtrGedComStructure) then
    begin
      aImportGedcom:=TImportGedCom(fPtrGedComStructure.PtrObjetImportGedcom);
      obNote:=aImportGedcom.GetNoteByID(ID);
      if obNote<>nil then
        result:=result+obNote.GedcomBlock.GetNOTEAsString;
    end;

    aSOUR:=f_SOUR;
    while assigned(aSOUR) do
    begin
          //On cherche la source qui porte l'ID
      if Assigned(fPtrGedComStructure) then
      begin
        aTagSourceRecord:=fPtrGedComStructure.GetSourceRecordByID(aSOUR.ID);
        if aTagSourceRecord<>nil then
        begin
          result:=result+aTagSourceRecord.AsLine;
        end;
      end;

      aSOUR:=TTag_SOURCE_RECORD(aSOUR.PtrNextSameTag);
    end;
  end;
end;

function TGedComStructure.GetIndividuByID(const ID:string):TTag_INDIVIDUAL_RECORD;
begin
  result:=TTag_INDIVIDUAL_RECORD(FIndividuList.getTagById(ID));
end;

function TGedComStructure.GetFamilleByID(const ID:string):TTag_FAM_RECORD;
begin
  result:=TTag_FAM_RECORD(FFamilleList.getTagById(ID));
end;

function TGedComStructure.GetSourceRecordByID(const ID:string):TTag_SOURCE_RECORD;
begin
  result:=TTag_SOURCE_RECORD(FSourceList.getTagById(ID));
end;

function TGedComStructure.GetNoteRecordByID(const ID:string):TTag_NOTE_RECORD;
begin
  result:=TTag_NOTE_RECORD(FNoteList.getTagById(ID));
end;

function TGedComStructure.GetRepoRecordByID(const ID:string):TTag_REPO_RECORD;
begin
  result:=TTag_REPO_RECORD(FRepoList.getTagById(ID));
end;

{ TTag_DATA1 }

procedure TTag_DATA1.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_DATE:=nil;
  f_TEXT:=nil;
  f_CONC:=nil;
  f_CONT:=nil;
end;

function TTag_DATA1.AsLine:string;
var
  n:integer;
  aTEXT:TTag_MEMO;
begin
  result:='';
  if f_DATE<>nil then
  begin
    result:=result+#13#10;
    result:=result+'DATE: '+f_DATE.Value;
  end;

  aTEXT:=_TEXT;
  while (aTEXT<>nil) do
  begin
    result:=result+aText.AsLine;

    aTEXT:=TTag_MEMO(aTEXT.PtrNextSameTag);
  end;

  if Memo.Count>0 then
  begin
    result:=result+#13#10;
    for n:=0 to Memo.Count-1 do
      result:=result+#13#10+Memo[n];
  end;

end;

{ TTag_CHANGE_DATE }

procedure TTag_CHANGE_DATE.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_DATE:=nil;
  f_NOTE:=nil;
end;


function TTag_CHANGE_DATE.AsLine:string;
var
  aNOTE_STRUCTURE:TTag_NOTE_STRUCTURE;
begin
  result:='';
  if f_DATE<>nil then
  begin
    result:=result+#13#10+'DATE: '+f_DATE.Value;
    if f_DATE.f_TIME<>nil then
    begin
      result:=result+#13#10+'TIME: '+f_DATE.f_TIME.Value;
    end;
  end;

  aNOTE_STRUCTURE:=_NOTE;
  while (aNOTE_STRUCTURE<>nil) do
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'NOTE: '+aNOTE_STRUCTURE.AsLine;

    aNOTE_STRUCTURE:=TTag_NOTE_STRUCTURE(aNOTE_STRUCTURE.PtrNextSameTag);
  end;
end;

{ TTag_DATA_SOURCE_RECORD }

function TTag_DATA_SOURCE_RECORD.AsLine:string;
var
  aEVEN:TTag_EVENT_RECORD;
  aNOTE_STRUCTURE:TTag_NOTE_STRUCTURE;
begin
  result:='';

  aEVEN:=f_EVEN;
  while (aEVEN<>nil) do
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'EVENTS: '+aEVEN.Value;

    if aEVEN.f_DATE<>nil then
    begin
      result:=result+#13#10;
      result:=result+'   DATE: '+aEVEN.f_DATE.Value;
    end;

    if aEVEN.f_PLAC<>nil then
    begin
      result:=result+#13#10;
      result:=result+'   PLACE: '+aEVEN.f_PLAC.Value;
    end;

    aEVEN:=TTag_EVENT_RECORD(aEVEN.PtrNextSameTag);
  end;

  if f_AGNC<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'AGNC: '+f_AGNC.Value;
  end;

  aNOTE_STRUCTURE:=_NOTE;
  while (aNOTE_STRUCTURE<>nil) do
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'NOTE: '+aNOTE_STRUCTURE.AsLine;

    aNOTE_STRUCTURE:=TTag_NOTE_STRUCTURE(aNOTE_STRUCTURE.PtrNextSameTag);
  end;
end;

procedure TTag_DATA_SOURCE_RECORD.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  inherited;
  f_EVEN:=nil;
  f_AGNC:=nil;
  f_NOTE:=nil;
end;

function TTag_REPO_RECORD.AsLine:string;
var
  aNOTE_STRUCTURE:TTag_NOTE_STRUCTURE;
  aREFN:TTag;
begin
  result:='';

  if f_NAME<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'NAME: '+f_NAME.Value;
  end;

  if f_ADDR<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'ADDR: '+f_ADDR.AsLine;
  end;

  aNOTE_STRUCTURE:=_NOTE;
  while (aNOTE_STRUCTURE<>nil) do
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+'NOTE: '+aNOTE_STRUCTURE.AsLine;

    aNOTE_STRUCTURE:=TTag_NOTE_STRUCTURE(aNOTE_STRUCTURE.PtrNextSameTag);
  end;

  aREFN:=_REFN;
  while (aREFN<>nil) do
  begin
    result:=result+#13#10;
    result:=result+'REFN: '+aREFN.Value;

    aREFN:=aREFN.PtrNextSameTag;
  end;

  if f_CHAN<>nil then
  begin
    result:=result+#13#10;
    result:=result+#13#10;
    result:=result+f_CHAN.AsLine;
  end;
end;

{ TTag_ADDRESS_STRUCTURE }

function TTag_ADDRESS_STRUCTURE.AsLine:string;
var
  aCONT:TTag;
begin
  result:=Value;

  aCONT:=f_CONT;
  while (aCONT<>nil) do
  begin
    result:=result+#13#10+aCONT.Value;
    aCONT:=aCONT.PtrNextSameTag;
  end;

  if f_ADR1<>nil then result:=result+#13#10+f_ADR1.Value;
  if f_ADR2<>nil then result:=result+#13#10+f_ADR2.Value;
  if f_CITY<>nil then result:=result+#13#10+f_CITY.Value;
  if f_STAE<>nil then result:=result+#13#10+f_STAE.Value;
  if f_POST<>nil then result:=result+#13#10+f_POST.Value;
  if f_CTRY<>nil then result:=result+#13#10+f_CTRY.Value;

end;

procedure TTag_ADDRESS_STRUCTURE.AfterCreate(const aGedComStructure: TGedComStructure);
begin
  Inherited;
  f_CONT:=nil;
  f_ADR1:=nil;
  f_ADR2:=nil;
  f_POST:=nil;
  f_CITY:=nil;
  f_STAE:=nil;
  f_CTRY:=nil;
end;

end.

