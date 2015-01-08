{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Mutancestre                               }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           André Langlet                                               }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{           Mutancestre est un Logiciel Libre                           }
{  refonte complète le 27/05/2011                                       }
{-----------------------------------------------------------------------}

unit u_Form_Mutation_Base;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, ShlObj, Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
  Forms,IB,
  StdCtrls,Controls,ExtCtrls,u_buttons_appli,ExtJvXPButtons,Classes,
  u_framework_components, u_ancestropictimages,DB,
  U_ExtDBGrid,IBCustomDataSet,SysUtils,
  Dialogs, u_framework_dbcomponents,
  IBQuery, BGRASpriteAnimation,
  IBDatabase,StrUtils,
  IBSQL,u_objet_TMotsClesDate,u_objet_TGedcomDate;

type

  { TFMutationBase }

  TFMutationBase=class(TForm)
    Panel3:TPanel;
    Image1:TIATitle;
    Label1:TLabel;
    gbDestination:TGroupBox;
    gbOrigine:TGroupBox;
    gDestination:TExtDBGrid;
    cbDossierDestination:TFWDBLookupCombo;
    dsDossierOrigine:TDataSource;
    cbDossierOrigine:TFWDBLookupCombo;
    dsIndiOrigine:TDataSource;
    QueryToClone: TIBQuery;
    qIndiDestinationCLE_FICHE1: TLongintField;
    qIndiDestinationNOM1: TIBStringField;
    qIndiDestinationPRENOM1: TIBStringField;
    qIndiOrigine:TIBQuery;
    qIndiOrigineCLE_FICHE:TLongintField;
    qIndiOrigineNOM:TIBStringField;
    qIndiOriginePRENOM:TIBStringField;
    Panel1:TPanel;
    btnImport:TFWImport;
    btnClose:TFWClose;
    btnConnectOrigine:TJvXPButton;
    IBBaseOrigine:TIBDatabase;
    IBTrans_Origine:TIBTransaction;
    dsIndiDestination:TDataSource;
    qIndiDestination:TIBQuery;
    dsDossierDestination:TDataSource;
    gOrigine:TExtDBGrid;
    qIndiDestinationCLE_FICHE:TLongintField;
    qIndiDestinationNOM:TIBStringField;
    qIndiDestinationPRENOM:TIBStringField;
    lImport:TLabel;
    pAnime:TPanel;
    Animate:TBGRASpriteAnimation;
    cbBaseOrigine:TFWEdit;
    SelectFichier:TOpenDialog;
    QTestTableChamp:TIBSQL;
    qPhoto:TIBSQL;
    QmajMedia:TIBSQL;
    TDossierDestination:TIBQuery;
    TDossierDestinationCLE_DOSSIER:TLongintField;
    TDossierDestinationNOM_DOSSIER:TIBStringField;
    tDossierOrigine:TIBQuery;
    tDossierOrigineCLE_DOSSIER:TLongintField;
    tDossierOrigineNOM_DOSSIER:TIBStringField;
    qTestLangue: TIBSQL;

    procedure btnCloseClick(Sender:TObject);
    procedure btnConnectOrigineClick(Sender:TObject);
    procedure btnImportClick(Sender:TObject);
    procedure FormClose(Sender:TObject;var Action:TCloseAction);
    procedure FormCreate(Sender:TObject);
    procedure cbDossierOriginePropertiesCloseUp(Sender:TObject);
    procedure cbDossierDestinationPropertiesCloseUp(Sender:TObject);
    procedure cbBaseOriginePropertiesButtonClick(Sender:TObject;
      AButtonIndex:Integer);
    procedure cbBaseOriginePropertiesChange(Sender:TObject);
  private
    bOrigAvecDateCode:Boolean;
    MotsClesDecode:TMotsClesDate;
    MaDate:TGedcomDate;
    procedure doImport;
    function NbrIndiDossier(Req:TIBQuery):string;
    function TestTableChamp(Table,Champ:string):boolean;
    procedure FormDestroy(Sender: TObject);
  public

  end;

implementation

uses  u_dm,
      u_common_ancestro,
      LazUTF8,
      fonctions_dialogs,
      u_common_const,
      u_common_functions,
      IBDatabaseInfo,
      fonctions_string,
      u_common_ancestro_functions,
      fonctions_images,
      {$IFNDEF IMAGING}
       bgrabitmap,
      {$ELSE}
      ImagingTypes,
      {$ENDIF}
      u_genealogy_context,
      FileUtil,
      u_connexion;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFMutationBase.FormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  // -- création et initialisation de la fenetre --------------------
  tDossierDestination.Open;
  cbDossierDestination.Caption:=fNomDossier;

  qIndiDestination.Params[0].AsInteger:=tDossierDestination.FieldByName('CLE_DOSSIER').AsInteger;
  qIndiDestination.Open;

  gbDestination.Caption:=fs_RemplaceMsg(rs_Caption_Destination_Persons,[NbrIndiDossier(qIndiDestination)]);
  sOrdreLIT:='';
  sOrdreNUM:='';
  btnConnectOrigine.Hint:=rs_Hint_if_server_version_is_used_maj_will_open_connexion_dialog;
  MotsClesDecode:=TMotsClesDate.create;
  MaDate:=TGedcomDate.Create;
  MaDate.InitTGedcomDate(_MotsClesDate,_MotsClesDate);
end;

procedure TFMutationBase.FormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  //Fermeture des tables, bases et fenetre
  tDossierOrigine.Close;
  qIndiDestination.Close;
  qIndiOrigine.close;
  tDossierDestination.Close;
  IBTrans_Origine.Active:=False;
  IBBaseOrigine.Close;
  sOrdreLIT:='';
  sOrdreNUM:='';

  Action:=caFree;
end;

procedure TFMutationBase.btnCloseClick(Sender:TObject);
begin
  Animate.AnimSpeed:=0;
  Animate.Visible:=False;
  Close;
end;

procedure TFMutationBase.btnConnectOrigineClick(Sender:TObject);
var
  s,Id,Pw,Rl:string;
  q:TIBSQL;
  n:Single;
  b:boolean;
  sChaineConnect:string;

begin
  tDossierOrigine.Close;
  qIndiOrigine.Close;
  if IBTrans_Origine.Active then
    IBTrans_Origine.Commit;
  IBBaseOrigine.Close;
  btnImport.Enabled:=false;
  gbOrigine.Caption:=' Origine ';
  if btnConnectOrigine.Caption='Déconnecter' then
  begin
    btnConnectOrigine.Caption:='Connecter';
  end
  else
  begin
    sChaineConnect:=cbBaseOrigine.Text;
    Id:=_user_name;
    Pw:=_password;
    Rl:=_role_name;
    if not ConnexionBase(IBBaseOrigine,sChaineConnect,IBTrans_Origine,_lc_ctype
      ,Id,Pw,Rl,'INDIVIDU',b) then
      exit;

    btnConnectOrigine.Caption:='Déconnecter';
    q:=TIBSQL.Create(self);
    try
      q.Database:=IBBaseOrigine;
      q.Transaction:=IBTrans_Origine;
      q.SQL.Text:='select FIRST(1) VER_VERSION FROM T_VERSION_BASE';
      try
        q.ExecQuery;
        s:=q.Fields[0].AsString;
        q.Close;
        lImport.Caption:='Base origine version '+s;
        Application.ProcessMessages;
        n:=StrToFloat(AnsiReplaceStr(s,'.',DecimalSeparator));
      except
        s:='inconnue car table T_VERSION_BASE absente,';
        n:=0;
      end;
      if n<=1.0429 then
      begin
        MyMessageDlg(fs_RemplaceMsg(rs_Error_this_Database_version_is_too_old,[s])
          ,mtError, [mbCancel],Self);
        IBTrans_Origine.Commit;
        IBBaseOrigine.Close;
        cbBaseOrigine.SetFocus;
        btnConnectOrigine.Caption:='Connecter';
        Exit;
      end;
      if n<=3.569 then
      begin
        MyMessageDlg(fs_RemplaceMsg(rs_Warning_this_Database_version_is_old,[s])
          ,mtWarning, [mbOK],Self);
      end;
    finally
      q.Free;
    end;

    tDossierOrigine.Open;
    cbDossierOrigine.Enabled:=true;
    //cbDossierOrigine.DroppedDown:=true; MG ?
  end;
end;

function TFMutationBase.TestTableChamp(Table,Champ:string):boolean;
begin
  with QTestTableChamp do
  begin
    Close;
    Params[0].AsString:=UTF8UpperCase(Table);
    Params[1].AsString:=UTF8UpperCase(Champ);
    ExecQuery;
    Result:=not Eof;
    Close;
  end;
end;

procedure TFMutationBase.btnImportClick(Sender:TObject);
var
  DBInfos:TIBDatabaseInfo;
  PCOrigine,PCDestination,BaseOrigine,BaseDestination,langue:string;
begin
  //contrôle des connections
  if (qIndiOrigine.Active=False)or(qIndiDestination.Active=False) then
  begin
    MyMessageDlg(rs_Error_import_forbidden+_CRLF+rs_Error_Folders_not_defined
      ,mtError, [mbCancel],Self);
    Exit;
  end;

  //contrôle pour éviter bouclage
  DBInfos:=TIBDatabaseInfo.Create(self);
  try
    DBInfos.Database:=IBBaseOrigine;
    PCOrigine:=DBInfos.DBSiteName;
    BaseOrigine:=DBInfos.DBFileName;
    DBInfos.Database:=dm.ibd_BASE;
    PCDestination:=DBInfos.DBSiteName;
    BaseDestination:=DBInfos.DBFileName;
  finally
    DBInfos.Free;
  end;
  if (PCDestination=PCOrigine)and(BaseDestination=BaseOrigine)
    and(tDossierDestination.FieldByName('CLE_DOSSIER').AsInteger=tDossierOrigine.FieldByName('CLE_DOSSIER').AsInteger) then
  begin
    MyMessageDlg(rs_Error_import_forbidden+_CRLF+rs_Error_Same_folders
      ,mtError, [mbCancel],Self);
    exit;
  end;
  bOrigAvecDateCode:=TestTableChamp('EVENEMENTS_IND','EV_IND_CALENDRIER');
  langue:='FRA';
  if TestTableChamp('DOSSIER','DS_LANGUE') then
  begin
    qTestLangue.Close;
    qTestLangue.Params[0].AsInteger:=tDossierOrigineCLE_DOSSIER.AsInteger;
    qTestLangue.ExecQuery;
    langue:=qTestLangue.Fields[0].AsString;
    qTestLangue.Close;
   end;
  MotsClesDecode.LoadMotClefDate(QueryToClone,langue);
  MaDate.InitTGedcomDate(MotsClesDecode,_MotsClesDate);
  doImport;
end;

procedure TFMutationBase.cbDossierOriginePropertiesCloseUp(
  Sender:TObject);
begin
  screen.Cursor:=crHourglass;
  Application.ProcessMessages;
  qIndiOrigine.Close;
  qIndiOrigine.DisableControls;
  qIndiOrigine.Params[0].AsInteger:=tDossierOrigine.FieldByName('CLE_DOSSIER').AsInteger;
  qIndiOrigine.Open;
  qIndiOrigine.EnableControls;
  btnImport.Enabled:=(not qIndiOrigine.Eof);
  gbOrigine.Caption:=fs_RemplaceMsg(rs_Caption_Source_Persons,[NbrIndiDossier(qIndiOrigine)]);
  Application.ProcessMessages;
  screen.Cursor:=crDefault;
end;

procedure TFMutationBase.cbDossierDestinationPropertiesCloseUp(
  Sender:TObject);
begin
  qIndiDestination.Close;
  qIndiDestination.DisableControls;
  qIndiDestination.Params[0].AsInteger:=tDossierDestination.FieldByName('CLE_DOSSIER').AsInteger;
  qIndiDestination.Open;
  qIndiDestination.EnableControls;
  gbDestination.Caption:=fs_RemplaceMsg(rs_Caption_Destination_Persons,[NbrIndiDossier(qIndiOrigine)]);
end;

procedure TFMutationBase.cbBaseOriginePropertiesButtonClick(Sender:TObject;
  AButtonIndex:Integer);
begin
  SelectFichier.InitialDir:=ExtractFileDir(gci_context.PathFileNameBdd);
  SelectFichier.Title:=rs_Title_Original_database;
  if SelectFichier.Execute then
    cbBaseOrigine.Text:=SelectFichier.FileName;
end;

procedure TFMutationBase.cbBaseOriginePropertiesChange(Sender:TObject);
begin
  btnConnectOrigine.Enabled:=Length(cbBaseOrigine.Text)>5;
  tDossierOrigine.Close;
  qIndiOrigine.Close;
  if IBTrans_Origine.Active then
    IBTrans_Origine.Commit;
  IBBaseOrigine.Close;
  btnImport.Enabled:=false;
  gbOrigine.Caption:=rs_Caption_Original_source;
  cbDossierOrigine.Enabled:=False;
  btnConnectOrigine.Caption:=rs_Caption_Connect;
end;

procedure TFMutationBase.doImport;
var
  SQLQSource,SQLQCible:TIBSQL;
  IG_ID,i,p,id,NbrEnr,annee1,annee2:Integer;
  tampon,tampon2:TMemoryStream;
  ImageData : {$IFNDEF IMAGING}TBGRABitmap{$ELSE}TImageData{$ENDIF};
  dossiers,dossierc,s:string;
  bNouvVersion,EVavecLIGNES_ADRESSES,bContinuer:boolean;

//Corps de la procédure ButtonImporterClick
//La table temporaire TQ_CONSANG de la base cible est utilisée pour mémoriser la
//correspondance entre les anciennes (INDI) et les nouvelles clefs (DECUJUS).
//ID est l'identifiant de la table
// 1 INDIVIDU
// 2 MULTIMEDIA
// 3 EVENEMENTS_IND
// 4 T_UNION
// 5 EVENEMENTS_FAM
// 6 SOURCES_RECORD
begin
  Dossiers:=tDossierOrigine.FieldByName('CLE_DOSSIER').AsString;
  Dossierc:=tDossierDestination.FieldByName('CLE_DOSSIER').AsString;

  btnImport.Enabled:=false;
  btnClose.Enabled:=false;
  pAnime.Visible:=True;

  Animate.Visible:=True;
  Animate.AnimSpeed:=0;

  screen.Cursor:=crHourglass;
  Application.ProcessMessages;

  //initialisation
  qIndiDestination.Close;

  SQLQSource:=TIBSQL.Create(self);
  SQLQSource.Database:=IBBaseOrigine;

  SQLQCible:=TIBSQL.Create(self);
  SQLQCible.Database:=dm.ibd_BASE;// Base de destination

  try//du finally de cloture

  //insertion de l'import
    IG_ID:=dm.uf_GetClefUnique('T_IMPORT_GEDCOM');
    SQLQCible.SQL.Text:='insert into T_IMPORT_GEDCOM (IG_ID,IG_PATH) values('
      +IntToStr(IG_ID)+','''+IBBaseOrigine.DatabaseName+' dossier '+dossiers
      +' dans dossier '+dossierc+''')';

    try
      SQLQCible.ExecQuery;
    except
      on E:EIBError do
      begin
        MyMessageDlg(rs_Error_T_IMPORT_GEDCOM_update+_CRLF+_CRLF+E.Message
          ,mtError, [mbCancel],Self);
        dm.IBT_base.RollbackRetaining;
        exit;
      end;
    end;

  //effacement de TQ_CONSANG
    SQLQCible.Close;
    SQLQCible.SQL.Text:='DELETE FROM TQ_CONSANG';

    try
      SQLQCible.ExecQuery;
    except
      on E:EIBError do
      begin
        MyMessageDlg(rs_Error_TQ_CONSANG_deleting+_CRLF+_CRLF+E.Message
          ,mtError, [mbCancel],Self);
        dm.IBT_base.RollbackRetaining;
        exit;
      end;
    end;

    SQLQCible.Close;

  //recherche de l'ordre des éléments de la date (jour, mois, année) dans la base source.
    SQLQSource.SQL.Clear;
    SQLQSource.SQL.Add('select first(2) r.token from dossier d');
    SQLQSource.SQL.Add('inner join ref_token_date r on r.langue=d.ds_langue and r.type_token=23');
    SQLQSource.SQL.Add('where d.cle_dossier='+dossiers);
    SQLQSource.SQL.Add('order by r.ID');
    try
      SQLQSource.ExecQuery;
      if not SQLQSource.Eof then
      begin
        s:=UTF8UpperCase(SQLQSource.Fields[0].AsString);
        if (s='DMY')or(s='MDY')or(s='YMD') then
        begin
          sOrdreLIT:=s;
          sOrdreNUM:=s;
          SQLQSource.Next;
          if not SQLQSource.Eof then
          begin
            s:=UTF8UpperCase(SQLQSource.Fields[0].AsString);
            if (s='DMY')or(s='MDY')or(s='YMD') then
              sOrdreNUM:=s;
          end;
        end;
      end;
      SQLQSource.Close;
    except
    // table ref_token_date absente de la base source. On espère que les formats sont les mêmes..
    end;

  // -- table INDIVIDU---------------------------------------------------------------------------------------
    lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['INDIVIDU']);
    Application.ProcessMessages;

    SQLQSource.SQL.Text:='select count(*) from INDIVIDU where KLE_DOSSIER='+dossiers;
    SQLQSource.ExecQuery;
    NbrEnr:=SQLQSource.Fields[0].AsInteger;
    SQLQSource.Close;
    SQLQSource.SQL.Text:='select * from INDIVIDU where KLE_DOSSIER='+dossiers;
    SQLQSource.ExecQuery;

    if not SQLQSource.Eof then
    begin
      I:=0;
      SQLQCible.SQL.Text:='execute block ('
        +'cle_fiche integer=:cle_fiche'
        +',SEXE integer=:SEXE'
        +',CLE_PARENTS integer=:CLE_PARENTS'
        +',CLE_PERE integer=:CLE_PERE'
        +',CLE_MERE integer=:CLE_MERE'
        +',PREFIXE varchar(30)=:PREFIXE'
        +',NOM varchar(40)=:NOM'
        +',PRENOM varchar(60)=:PRENOM'
        +',SURNOM varchar(120)=:SURNOM'
        +',SUFFIXE varchar(30)=:SUFFIXE'
        +',SOURCE blob=:SOURCE'
        +',COMMENT blob=:COMMENT'
        +',FILLIATION varchar(30)=:FILLIATION'
        +',MODIF_PAR_QUI varchar(30)=:MODIF_PAR_QUI'
        +',NCHI smallint=:NCHI'
        +',NMR smallint=:NMR'
        +',IND_CONFIDENTIEL smallint=:IND_CONFIDENTIEL'
        +')as'
        +' declare variable decujus integer;'
        +' begin'
        +' insert into INDIVIDU ('
        +'CLE_FICHE'
        +',KLE_DOSSIER'
        +',SEXE'
        +',CLE_PARENTS'
        +',CLE_PERE'
        +',CLE_MERE'
        +',PREFIXE'
        +',NOM'
        +',PRENOM'
        +',SURNOM'
        +',SUFFIXE'
        +',SOURCE'
        +',COMMENT'
        +',FILLIATION'
        +',MODIF_PAR_QUI'
        +',NCHI'
        +',NMR'
        +',ID_IMPORT_GEDCOM'
        +',IND_CONFIDENTIEL'
        +')'
        +' values('
        +'gen_id(gen_individu,1)'
        +','+dossierc
        +',:SEXE'
        +',:CLE_PARENTS'
        +',:CLE_PERE'
        +',:CLE_MERE'
        +',:PREFIXE'
        +',:NOM'
        +',:PRENOM'
        +',:SURNOM'
        +',:SUFFIXE'
        +',:SOURCE'
        +',:COMMENT'
        +',:FILLIATION'
        +',:MODIF_PAR_QUI'
        +',:NCHI'
        +',:NMR'
        +','+IntToStr(IG_ID)
        +',:IND_CONFIDENTIEL'
        +')returning cle_fiche into :decujus;'
        +'insert into TQ_CONSANG (ID,INDI,DECUJUS) values(1,:cle_fiche,:decujus);'
        +' end';
      tampon:=TMemoryStream.Create;
      try
        while not SQLQSource.Eof do
        begin
          inc(i);
          if (i=NbrEnr)or(i mod 10=0) then
          begin
            lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['INDIVIDU',IntToStr(I),IntToStr(NbrEnr)]);
            Application.ProcessMessages;
          end;
          SQLQCible.ParamByName('CLE_FICHE').AsInteger:=SQLQSource.FieldByName('CLE_FICHE').AsInteger;//NouvCle;
          SQLQCible.ParamByName('SEXE').AsInteger:=SQLQSource.FieldByName('SEXE').AsInteger;
          for p:=2 to SQLQCible.Params.Count-1 do //initialisation des paramètres qui peuvent être nuls
            SQLQCible.Params[p].Clear;
          if not SQLQSource.FieldByName('CLE_PARENTS').IsNull then
            SQLQCible.ParamByName('CLE_PARENTS').AsInteger:=SQLQSource.FieldByName('CLE_PARENTS').AsInteger;
          if SQLQSource.FieldByName('CLE_PERE').AsInteger>0 then
            SQLQCible.ParamByName('CLE_PERE').AsInteger:=SQLQSource.FieldByName('CLE_PERE').AsInteger;
          if SQLQSource.FieldByName('CLE_MERE').AsInteger>0 then
            SQLQCible.ParamByName('CLE_MERE').AsInteger:=SQLQSource.FieldByName('CLE_MERE').AsInteger;
          if SQLQSource.FieldByName('PREFIXE').AsString>'' then
            SQLQCible.ParamByName('PREFIXE').AsString:=SQLQSource.FieldByName('PREFIXE').AsString;
          if SQLQSource.FieldByName('NOM').AsString>'' then
            SQLQCible.ParamByName('NOM').AsString:=fs_FormatText(SQLQSource.FieldByName('NOM').AsString,mftUpper);//AL2011
          if SQLQSource.FieldByName('PRENOM').AsString>'' then
            SQLQCible.ParamByName('PRENOM').AsString:=fs_FormatText(SQLQSource.FieldByName('PRENOM').AsString,mftFirstIsMaj);
          if SQLQSource.FieldByName('SURNOM').AsString>'' then
            SQLQCible.ParamByName('SURNOM').AsString:=SQLQSource.FieldByName('SURNOM').AsString;
          if SQLQSource.FieldByName('SUFFIXE').AsString>'' then
            SQLQCible.ParamByName('SUFFIXE').AsString:=SQLQSource.FieldByName('SUFFIXE').AsString;

          if not SQLQSource.FieldByName('SOURCE').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('SOURCE').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('SOURCE').LoadFromStream(tampon);
          end;

          if not SQLQSource.FieldByName('COMMENT').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('COMMENT').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('COMMENT').LoadFromStream(tampon);
          end;

          if SQLQSource.FieldByName('FILLIATION').AsString>'' then
            SQLQCible.ParamByName('FILLIATION').AsString:=SQLQSource.FieldByName('FILLIATION').AsString;

          if SQLQSource.FieldByName('MODIF_PAR_QUI').AsString>'' then
            SQLQCible.ParamByName('MODIF_PAR_QUI').AsString:=SQLQSource.FieldByName('MODIF_PAR_QUI').AsString;

          try//champs inexistants sur anciennes bases
            if not SQLQSource.FieldByName('NCHI').IsNull then
              SQLQCible.ParamByName('NCHI').AsInteger:=SQLQSource.FieldByName('NCHI').AsInteger;
            if not SQLQSource.FieldByName('NMR').IsNull then
              SQLQCible.ParamByName('NMR').AsInteger:=SQLQSource.FieldByName('NMR').AsInteger;
          except
          end;

          try//champ inexistant sur anciennes bases
            if not SQLQSource.FieldByName('IND_CONFIDENTIEL').IsNull then
              SQLQCible.ParamByName('IND_CONFIDENTIEL').AsInteger:=SQLQSource.FieldByName('IND_CONFIDENTIEL').AsInteger;
          except
          end;

          try
            SQLQCible.ExecQuery;//transfert individu
          except
            on E:EIBError do
            begin
              MyMessageDlg(rs_Error_person_transfer_with_NIP+SQLQSource.FieldByName('CLE_FICHE').AsString
                +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
              dm.IBT_base.RollbackRetaining;
              exit;
            end;
          end;
          SQLQSource.Next;
        end;
      finally
        tampon.Free;
      end;
      SQLQCible.Close;
      SQLQCible.SQL.Clear;
      SQLQCible.SQL.Add('update INDIVIDU i set i.CLE_PERE=(select DECUJUS from TQ_CONSANG');
      SQLQCible.SQL.Add(' where ID=1 and INDI=i.CLE_PERE)');
      SQLQCible.SQL.Add(' where i.ID_IMPORT_GEDCOM='+IntToStr(IG_ID));
      SQLQCible.SQL.Add(' and i.CLE_PERE is not null');
      lImport.Caption:=rs_Caption_Updating_father_key_of_PERSON;
      Application.ProcessMessages;
      try
        SQLQCible.ExecQuery;//mise à jour cle_pere
      except
        on E:EIBError do
        begin
          MyMessageDlg(rs_Error_person_cle_pere_father_key
            +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
          dm.IBT_base.RollbackRetaining;
          exit;
        end;
      end;
      SQLQCible.Close;
      SQLQCible.SQL.Clear;
      SQLQCible.SQL.Add('update INDIVIDU i set i.CLE_MERE=(select DECUJUS from TQ_CONSANG');
      SQLQCible.SQL.Add(' where ID=1 and INDI=i.CLE_MERE)');
      SQLQCible.SQL.Add(' where i.ID_IMPORT_GEDCOM='+IntToStr(IG_ID));
      SQLQCible.SQL.Add(' and i.CLE_MERE is not null');
      lImport.Caption:=rs_Caption_Updating_Mother_key_of_PERSON;
      Application.ProcessMessages;
      try
        SQLQCible.ExecQuery;//mise à jour cle_mere
      except
        on E:EIBError do
        begin
          MyMessageDlg(rs_Error_person_cle_mere_mother_key
            +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
          dm.IBT_base.RollbackRetaining;
          exit;
        end;
      end;
      SQLQCible.Close;
    end;// fin de If not SQLQSource.Eof

    SQLQSource.Close;

    // -- Table MULTIMEDIA-------------------------------------------------------------------------------------
    lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['MULTIMEDIA']);
    Application.ProcessMessages;
    SQLQSource.SQL.Text:='select count(*) from MULTIMEDIA where MULTI_DOSSIER='+dossiers;
    SQLQSource.ExecQuery;
    NbrEnr:=SQLQSource.Fields[0].AsInteger;
    SQLQSource.Close;
    SQLQSource.SQL.Text:='select * from MULTIMEDIA where MULTI_DOSSIER='+dossiers;
    SQLQSource.ExecQuery;

    if not SQLQSource.Eof then
    begin
      i:=0;
      SQLQCible.SQL.Text:='execute block('
        +'MULTI_CLEF integer=:MULTI_CLEF'
        +',MULTI_INFOS varchar(53)=:MULTI_INFOS'
        +',MULTI_MEDIA blob=:MULTI_MEDIA'
        +',MULTI_DATE_MODIF timestamp=:MULTI_DATE_MODIF'
        +',MULTI_MEMO blob=:MULTI_MEMO'
        +',MULTI_REDUITE blob=:MULTI_REDUITE'
        +',MULTI_IMAGE_RTF integer=:MULTI_IMAGE_RTF'
        +',MULTI_PATH varchar(255)=:MULTI_PATH'
        +')as'
        +' declare variable decujus integer;'
        +' begin'
        +' insert into MULTIMEDIA ('
        +'MULTI_CLEF'
        +',MULTI_DOSSIER'
        +',ID_IMPORT_GEDCOM'
        +',MULTI_INFOS'
        +',MULTI_MEDIA'
        +',MULTI_DATE_MODIF'
        +',MULTI_MEMO'
        +',MULTI_REDUITE'
        +',MULTI_IMAGE_RTF'
        +',MULTI_PATH'
        +')'
        +' values('
        +'gen_id(gen_multimedia,1)'
        +','+dossierc
        +','+IntToStr(IG_ID)
        +',:MULTI_INFOS'
        +',:MULTI_MEDIA'
        +',:MULTI_DATE_MODIF'
        +',:MULTI_MEMO'
        +',:MULTI_REDUITE'
        +',:MULTI_IMAGE_RTF'
        +',:MULTI_PATH'
        +')returning multi_clef into :decujus;'
        +'insert into TQ_CONSANG (ID,INDI,DECUJUS) values(2,:MULTI_CLEF,:decujus);'
        +' end';

      tampon:=TMemoryStream.Create;
      try
        while not SQLQSource.eof do
        begin
          inc(i);
          if (i=NbrEnr)or(i mod 10=0) then
          begin
            lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['MULTIMEDIA',IntToStr(I),IntToStr(NbrEnr)]);
            Application.ProcessMessages;
          end;
          SQLQCible.ParamByName('MULTI_CLEF').AsInteger:=SQLQSource.FieldByName('MULTI_CLEF').AsInteger;//NouvCle;
          for p:=1 to SQLQCible.Params.Count-1 do //initialisation des paramètres qui peuvent être nuls
            SQLQCible.Params[p].Clear;

          if SQLQSource.FieldByName('MULTI_INFOS').AsString>'' then
            SQLQCible.ParamByName('MULTI_INFOS').AsString:=SQLQSource.FieldByName('MULTI_INFOS').AsString;

          if not SQLQSource.FieldByName('MULTI_MEDIA').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('MULTI_MEDIA').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('MULTI_MEDIA').LoadFromStream(tampon);
          end;

          if not SQLQSource.FieldByName('MULTI_DATE_MODIF').IsNull then
            SQLQCible.ParamByName('MULTI_DATE_MODIF').AsDateTime:=SQLQSource.FieldByName('MULTI_DATE_MODIF').AsDateTime;

          if not SQLQSource.FieldByName('MULTI_MEMO').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('MULTI_MEMO').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('MULTI_MEMO').LoadFromStream(tampon);
          end;

          if not SQLQSource.FieldByName('MULTI_REDUITE').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('MULTI_REDUITE').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('MULTI_REDUITE').LoadFromStream(tampon);
          end;

          if not SQLQSource.FieldByName('MULTI_IMAGE_RTF').IsNull then
            SQLQCible.ParamByName('MULTI_IMAGE_RTF').AsInteger:=SQLQSource.FieldByName('MULTI_IMAGE_RTF').AsInteger;

          if SQLQSource.FieldByName('MULTI_PATH').AsString>'' then
            SQLQCible.ParamByName('MULTI_PATH').AsString:=SQLQSource.FieldByName('MULTI_PATH').AsString;

          try
            SQLQCible.ExecQuery;
          except
            on E:EIBError do
            begin
              MyMessageDlg(rs_Error_media_number_transfer+SQLQSource.FieldByName('MULTI_CLEF').AsString
                +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
              dm.IBT_base.RollbackRetaining;
              exit;
            end;
          end;

          SQLQSource.Next;
        end;
      finally
        tampon.Free;
      end;

      SQLQCible.Close;
    end;// fin de If not SQLQSource.Eof
    SQLQSource.Close;

    dm.InactiveTriggersLieuxFavoris(true);
    tampon:=TMemoryStream.Create;
    tampon2:=TMemoryStream.Create;
    try
    // -- Table EVENEMENTS_IND---------------------------------------------------------------------------------
      lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['EVENEMENTS_IND']);
      Application.ProcessMessages;
      SQLQSource.SQL.Text:='select count(*) from individu i';
      SQLQSource.SQL.Add('inner join evenements_ind e on e.ev_ind_kle_fiche=i.cle_fiche');
      SQLQSource.SQL.Add('where i.kle_dossier='+dossiers);
      SQLQSource.ExecQuery;
      NbrEnr:=SQLQSource.Fields[0].AsInteger;
      SQLQSource.Close;
      SQLQSource.SQL.Text:='select e.* from individu i';
      SQLQSource.SQL.Add('inner join evenements_ind e on e.ev_ind_kle_fiche=i.cle_fiche');
      SQLQSource.SQL.Add('where i.kle_dossier='+dossiers);
      SQLQSource.ExecQuery;

      SQLQCible.SQL.Text:='execute block('
        +'ev_ind_clef integer=:ev_ind_clef'
        +',EV_IND_KLE_FICHE integer=:EV_IND_KLE_FICHE'
        +',EV_IND_TYPE varchar(7)=:EV_IND_TYPE'
        +',EV_IND_DATE_WRITEN varchar(100)=:EV_IND_DATE_WRITEN'
        +',EV_IND_DATE_YEAR integer=:EV_IND_DATE_YEAR'
        +',EV_IND_DATE_MOIS integer=:EV_IND_DATE_MOIS'
        +',EV_IND_CALENDRIER1 integer=:EV_IND_CALENDRIER1'
        +',EV_IND_CALENDRIER2 integer=:EV_IND_CALENDRIER2'
        +',EV_IND_DATE date=:EV_IND_DATE'
        +',EV_IND_DATE_YEAR_FIN integer=:EV_IND_DATE_YEAR_FIN'
        +',EV_IND_DATE_MOIS_FIN integer=:EV_IND_DATE_MOIS_FIN'
        +',EV_IND_DATECODE Integer=:EV_IND_DATECODE'
        +',EV_IND_DATECODE_TOT Integer=:EV_IND_DATECODE_TOT'
        +',EV_IND_DATECODE_TARD Integer=:EV_IND_DATECODE_TARD'
        +',EV_IND_DATE_JOUR SmallInt=:EV_IND_DATE_JOUR'
        +',EV_IND_DATE_JOUR_FIN SmallInt=:EV_IND_DATE_JOUR_FIN'
        +',EV_IND_TYPE_TOKEN1 SmallInt=:EV_IND_TYPE_TOKEN1'
        +',EV_IND_TYPE_TOKEN2 SmallInt=:EV_IND_TYPE_TOKEN2'
        +',EV_IND_CP varchar(10)=:EV_IND_CP'
        +',EV_IND_VILLE varchar(50)=:EV_IND_VILLE'
        +',EV_IND_DEPT varchar(30)=:EV_IND_DEPT'
        +',EV_IND_PAYS varchar(30)=:EV_IND_PAYS'
        +',EV_IND_CAUSE varchar(90)=:EV_IND_CAUSE'
        +',EV_IND_SOURCE blob=:EV_IND_SOURCE'
        +',EV_IND_COMMENT blob=:EV_IND_COMMENT'
        +',EV_IND_DESCRIPTION varchar(90)=:EV_IND_DESCRIPTION'
        +',EV_IND_REGION varchar(50)=:EV_IND_REGION'
        +',EV_IND_SUBD varchar(50)=:EV_IND_SUBD'
        +',EV_IND_ACTE integer=:EV_IND_ACTE'
        +',EV_IND_INSEE varchar(6)=:EV_IND_INSEE'
        +',EV_IND_ORDRE integer=:EV_IND_ORDRE'
        +',EV_IND_HEURE time=:EV_IND_HEURE'
        +',EV_IND_TITRE_EVENT varchar(25)=:EV_IND_TITRE_EVENT'
        +',EV_IND_LATITUDE decimal(15,8)=:EV_IND_LATITUDE'
        +',EV_IND_LONGITUDE numeric(15,8)=:EV_IND_LONGITUDE'
        +',EV_IND_LIGNES_ADRESSE blob=:EV_IND_LIGNES_ADRESSE'
        +',EV_IND_TEL blob=:EV_IND_TEL'
        +',EV_IND_MAIL varchar(120)=:EV_IND_MAIL'
        +',EV_IND_WEB varchar(120)=:EV_IND_WEB'
        +')as'
        +' declare variable decujus integer;'
        +' begin'
        +' insert into EVENEMENTS_IND ('
        +'EV_IND_CLEF'
        +',EV_IND_KLE_FICHE'
        +',EV_IND_KLE_DOSSIER'
        +',EV_IND_TYPE'
        +',EV_IND_DATE_WRITEN'
        +',EV_IND_DATE_YEAR'
        +',EV_IND_DATE_MOIS'
        +',EV_IND_CALENDRIER1'
        +',EV_IND_CALENDRIER2'
        +',EV_IND_DATE'
        +',EV_IND_DATE_YEAR_FIN'
        +',EV_IND_DATE_MOIS_FIN'
        +',EV_IND_DATECODE'
        +',EV_IND_DATECODE_TOT'
        +',EV_IND_DATECODE_TARD'
        +',EV_IND_DATE_JOUR'
        +',EV_IND_DATE_JOUR_FIN'
        +',EV_IND_TYPE_TOKEN1'
        +',EV_IND_TYPE_TOKEN2'
        +',EV_IND_CP'
        +',EV_IND_VILLE'
        +',EV_IND_DEPT'
        +',EV_IND_PAYS'
        +',EV_IND_CAUSE'
        +',EV_IND_SOURCE'
        +',EV_IND_COMMENT'
        +',EV_IND_DESCRIPTION'
        +',EV_IND_REGION'
        +',EV_IND_SUBD'
        +',EV_IND_ACTE'
        +',EV_IND_INSEE'
        +',EV_IND_ORDRE'
        +',EV_IND_HEURE'
        +',EV_IND_TITRE_EVENT'
        +',EV_IND_LATITUDE'
        +',EV_IND_LONGITUDE'
        +',EV_IND_LIGNES_ADRESSE'
        +',EV_IND_TEL'
        +',EV_IND_MAIL'
        +',EV_IND_WEB'
        +')'
        +' values('
        +'gen_id(gen_ev_ind_clef,1)'
        +',(select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:EV_IND_KLE_FICHE)'
        +','+dossierc
        +',:EV_IND_TYPE'
        +',:EV_IND_DATE_WRITEN'
        +',:EV_IND_DATE_YEAR'
        +',:EV_IND_DATE_MOIS'
        +',:EV_IND_CALENDRIER1'
        +',:EV_IND_CALENDRIER2'
        +',:EV_IND_DATE'
        +',:EV_IND_DATE_YEAR_FIN'
        +',:EV_IND_DATE_MOIS_FIN'
        +',:EV_IND_DATECODE'
        +',:EV_IND_DATECODE_TOT'
        +',:EV_IND_DATECODE_TARD'
        +',:EV_IND_DATE_JOUR'
        +',:EV_IND_DATE_JOUR_FIN'
        +',:EV_IND_TYPE_TOKEN1'
        +',:EV_IND_TYPE_TOKEN2'
        +',:EV_IND_CP'
        +',:EV_IND_VILLE'
        +',:EV_IND_DEPT'
        +',:EV_IND_PAYS'
        +',:EV_IND_CAUSE'
        +',:EV_IND_SOURCE'
        +',:EV_IND_COMMENT'
        +',:EV_IND_DESCRIPTION'
        +',:EV_IND_REGION'
        +',:EV_IND_SUBD'
        +',:EV_IND_ACTE'
        +',:EV_IND_INSEE'
        +',:EV_IND_ORDRE'
        +',:EV_IND_HEURE'
        +',:EV_IND_TITRE_EVENT'
        +',:EV_IND_LATITUDE'
        +',:EV_IND_LONGITUDE'
        +',:EV_IND_LIGNES_ADRESSE'
        +',:EV_IND_TEL'
        +',:EV_IND_MAIL'
        +',:EV_IND_WEB'
        +')returning EV_IND_CLEF into :decujus;'
        +'insert into TQ_CONSANG (ID,INDI,DECUJUS) values(3,:EV_IND_CLEF,:decujus);'
        +'end';
      EVavecLIGNES_ADRESSES:=TestTableChamp('EVENEMENTS_IND','EV_IND_LIGNES_ADRESSE');

      if not SQLQSource.Eof then
      begin
        I:=0;
        while (not SQLQSource.eof) do
        begin
          inc(i);
          if (i=NbrEnr)or(i mod 10=0) then
          begin
            lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['EVENEMENTS_IND',IntToStr(I),IntToStr(NbrEnr)]);
            Application.ProcessMessages;
          end;
          SQLQCible.ParamByName('EV_IND_CLEF').AsInteger:=SQLQSource.FieldByName('EV_IND_CLEF').AsInteger;
          SQLQCible.ParamByName('EV_IND_KLE_FICHE').AsInteger:=SQLQSource.FieldByName('EV_IND_KLE_FICHE').AsInteger;
          for p:=2 to SQLQCible.Params.Count-1 do
            SQLQCible.Params[p].Clear;
          if SQLQSource.FieldByName('EV_IND_TYPE').AsString>'' then
            if SQLQSource.FieldByName('EV_IND_TYPE').AsString='TITR' then
              SQLQCible.ParamByName('EV_IND_TYPE').AsString:='TITL'
            else if SQLQSource.FieldByName('EV_IND_TYPE').AsString='INHU' then
              SQLQCible.ParamByName('EV_IND_TYPE').AsString:='BURI'
            else if SQLQSource.FieldByName('EV_IND_TYPE').AsString='BENE' then
              SQLQCible.ParamByName('EV_IND_TYPE').AsString:='BLES'
            else if SQLQSource.FieldByName('EV_IND_TYPE').AsString='DIPL' then
              SQLQCible.ParamByName('EV_IND_TYPE').AsString:='GRAD'
            else
              SQLQCible.ParamByName('EV_IND_TYPE').AsString:=SQLQSource.FieldByName('EV_IND_TYPE').AsString;

          if bOrigAvecDateCode then
          begin
            if SQLQSource.FieldByName('EV_IND_DATE_YEAR').IsNull then
              annee1:=_AnMini
            else
              annee1:=SQLQSource.FieldByName('EV_IND_DATE_YEAR').AsInteger;
            if SQLQSource.FieldByName('EV_IND_DATE_YEAR_FIN').IsNull then
              annee2:=_AnMini
            else
              annee2:=SQLQSource.FieldByName('EV_IND_DATE_YEAR_FIN').AsInteger;
            bContinuer:=MaDate.DecodeHumanDate(annee1,
              SQLQSource.FieldByName('EV_IND_DATE_MOIS').AsInteger,
              SQLQSource.FieldByName('EV_IND_DATE_JOUR').AsInteger,
              SQLQSource.FieldByName('EV_IND_TYPE_TOKEN1').AsInteger,
              TCalendrier(SQLQSource.FieldByName('EV_IND_CALENDRIER1').AsInteger),
              annee2,
              SQLQSource.FieldByName('EV_IND_DATE_MOIS_FIN').AsInteger,
              SQLQSource.FieldByName('EV_IND_DATE_JOUR_FIN').AsInteger,
              SQLQSource.FieldByName('EV_IND_TYPE_TOKEN2').AsInteger,
              TCalendrier(SQLQSource.FieldByName('EV_IND_CALENDRIER2').AsInteger));
          end
          else
            bContinuer:=(Length(SQLQSource.FieldByName('EV_IND_DATE_WRITEN').AsString)>0)
              and MaDate.DecodeHumanDate(SQLQSource.FieldByName('EV_IND_DATE_WRITEN').AsString);

          if Length(SQLQSource.FieldByName('EV_IND_DATE_WRITEN').AsString)>0 then
          begin
            s:=Trim(Copy(MaDate.HumanDate,1,100));
            if Length(s)>0 then
              SQLQCible.ParamByName('EV_IND_DATE_WRITEN').AsString:=s;
          end;

          if bContinuer then //AL2009 modif 2012
          begin
            if MaDate.ValidDateTime1 then
              SQLQCible.ParamByName('EV_IND_DATE').AsDateTime:=MaDate.DateTime1;
            SQLQCible.ParamByName('EV_IND_DATECODE').AsInteger:=MaDate.DateCode1;
            SQLQCible.ParamByName('EV_IND_DATECODE_TOT').AsInteger:=MaDate.DateCodeTot;
            SQLQCible.ParamByName('EV_IND_DATECODE_TARD').AsInteger:=MaDate.DateCodeTard;
            SQLQCible.ParamByName('EV_IND_DATE_YEAR').AsInteger:=MaDate.Year1;
            SQLQCible.ParamByName('EV_IND_CALENDRIER1').AsInteger:=ord(MaDate.Calendrier1);
            if MaDate.Month1>0 then
              SQLQCible.ParamByName('EV_IND_DATE_MOIS').AsInteger:=MaDate.Month1;
            if MaDate.Day1>0 then
              SQLQCible.ParamByName('EV_IND_DATE_JOUR').AsInteger:=MaDate.Day1;
            if MaDate.Type_Key1>0 then
              SQLQCible.ParamByName('EV_IND_TYPE_TOKEN1').AsInteger:=MaDate.Type_Key1;
            if MaDate.UseDate2 then
            begin
              SQLQCible.ParamByName('EV_IND_DATE_YEAR_FIN').AsInteger:=MaDate.Year2;
              if MaDate.Month2>0 then
                SQLQCible.ParamByName('EV_IND_DATE_MOIS_FIN').AsInteger:=MaDate.Month2;
              if MaDate.Day2>0 then
                SQLQCible.ParamByName('EV_IND_DATE_JOUR_FIN').AsInteger:=MaDate.Day2;
              if MaDate.Type_Key2>0 then
                SQLQCible.ParamByName('EV_IND_TYPE_TOKEN2').AsInteger:=MaDate.Type_Key2;
              SQLQCible.ParamByName('EV_IND_CALENDRIER2').AsInteger:=ord(MaDate.Calendrier2);
            end;
          end;

          if EVavecLIGNES_ADRESSES then //à partir b5.148 Intégration des adresses dans EVENEMENTS_IND
          begin
            if not SQLQSource.FieldByName('EV_IND_LIGNES_ADRESSE').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('EV_IND_LIGNES_ADRESSE').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('EV_IND_LIGNES_ADRESSE').LoadFromStream(tampon);
            end;
            if not SQLQSource.FieldByName('EV_IND_TEL').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('EV_IND_TEL').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('EV_IND_TEL').LoadFromStream(tampon);
            end;
            if SQLQSource.FieldByName('EV_IND_MAIL').AsString>'' then
              SQLQCible.ParamByName('EV_IND_MAIL').AsString:=SQLQSource.FieldByName('EV_IND_MAIL').AsString;
            if SQLQSource.FieldByName('EV_IND_WEB').AsString>'' then
              SQLQCible.ParamByName('EV_IND_WEB').AsString:=SQLQSource.FieldByName('EV_IND_WEB').AsString;
          end;

          if SQLQSource.FieldByName('EV_IND_CP').AsString>'' then
            SQLQCible.ParamByName('EV_IND_CP').AsString:=SQLQSource.FieldByName('EV_IND_CP').AsString;
          if SQLQSource.FieldByName('EV_IND_VILLE').AsString>'' then
            SQLQCible.ParamByName('EV_IND_VILLE').AsString:=SQLQSource.FieldByName('EV_IND_VILLE').AsString;
          if SQLQSource.FieldByName('EV_IND_DEPT').AsString>'' then
            SQLQCible.ParamByName('EV_IND_DEPT').AsString:=SQLQSource.FieldByName('EV_IND_DEPT').AsString;
          if SQLQSource.FieldByName('EV_IND_PAYS').AsString>'' then
            SQLQCible.ParamByName('EV_IND_PAYS').AsString:=SQLQSource.FieldByName('EV_IND_PAYS').AsString;
          if SQLQSource.FieldByName('EV_IND_CAUSE').AsString>'' then
            SQLQCible.ParamByName('EV_IND_CAUSE').AsString:=SQLQSource.FieldByName('EV_IND_CAUSE').AsString;

          if not SQLQSource.FieldByName('EV_IND_SOURCE').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('EV_IND_SOURCE').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('EV_IND_SOURCE').LoadFromStream(tampon);
          end;

          if not SQLQSource.FieldByName('EV_IND_COMMENT').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('EV_IND_COMMENT').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('EV_IND_COMMENT').LoadFromStream(tampon);
          end;

          if SQLQSource.FieldByName('EV_IND_DESCRIPTION').AsString>'' then
            SQLQCible.ParamByName('EV_IND_DESCRIPTION').AsString:=SQLQSource.FieldByName('EV_IND_DESCRIPTION').AsString;
          if SQLQSource.FieldByName('EV_IND_REGION').AsString>'' then
            SQLQCible.ParamByName('EV_IND_REGION').AsString:=SQLQSource.FieldByName('EV_IND_REGION').AsString;
         if SQLQSource.FieldByName('EV_IND_SUBD').AsString>'' then
            SQLQCible.ParamByName('EV_IND_SUBD').AsString:=SQLQSource.FieldByName('EV_IND_SUBD').AsString
          else //récupération de l'ex champ Lieu si subdivision est vide
            try //évitera l'erreur le jour où EV_IND_ADRESSE sera supprimé
              if SQLQSource.FieldByName('EV_IND_ADRESSE').AsString>'' then
                SQLQCible.ParamByName('EV_IND_SUBD').AsString:=SQLQSource.FieldByName('EV_IND_ADRESSE').AsString;
            except
            end;
          if SQLQSource.FieldByName('EV_IND_ADRESSE').AsString>'' then
            SQLQCible.ParamByName('EV_IND_ADRESSE').AsString:=SQLQSource.FieldByName('EV_IND_ADRESSE').AsString;
          if not SQLQSource.FieldByName('EV_IND_ACTE').IsNull then
            SQLQCible.ParamByName('EV_IND_ACTE').AsInteger:=SQLQSource.FieldByName('EV_IND_ACTE').AsInteger;
          if SQLQSource.FieldByName('EV_IND_INSEE').AsString>'' then
            SQLQCible.ParamByName('EV_IND_INSEE').AsString:=SQLQSource.FieldByName('EV_IND_INSEE').AsString;

          try
            if not SQLQSource.FieldByName('EV_IND_ORDRE').IsNull then
              SQLQCible.ParamByName('EV_IND_ORDRE').AsInteger:=SQLQSource.FieldByName('EV_IND_ORDRE').AsInteger;
          except
          end;

          try
            if not SQLQSource.FieldByName('EV_IND_HEURE').IsNull then
              SQLQCible.ParamByName('EV_IND_HEURE').AsDateTime:=SQLQSource.FieldByName('EV_IND_HEURE').AsDateTime;
          except
          end;

          try
            if SQLQSource.FieldByName('EV_IND_TITRE_EVENT').AsString>'' then
            begin
              s:=SQLQSource.FieldByName('EV_IND_TITRE_EVENT').AsString;
              if Length(s)>25 then
                s:=AnsiLeftStr(s,25);
              SQLQCible.ParamByName('EV_IND_TITRE_EVENT').AsString:=s;
            end;
          except
          end;

          try
            if not SQLQSource.FieldByName('EV_IND_LATITUDE').IsNull then
              SQLQCible.ParamByName('EV_IND_LATITUDE').AsDouble:=SQLQSource.FieldByName('EV_IND_LATITUDE').AsDouble;
          except
          end;

          try
            if not SQLQSource.FieldByName('EV_IND_LONGITUDE').IsNull then
              SQLQCible.ParamByName('EV_IND_LONGITUDE').AsDouble:=SQLQSource.FieldByName('EV_IND_LONGITUDE').AsDouble;
          except
          end;

          try
            SQLQCible.ExecQuery;
          except
            on E:EIBError do
            begin
              MyMessageDlg(rs_Error_person_event_transfer
                +SQLQSource.FieldByName('EV_IND_CLEF').AsString
                +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
              dm.IBT_base.RollbackRetaining;
              exit;
            end;
          end;

          SQLQSource.Next;
        end;
        SQLQCible.Close;
      end;// fin de If not SQLQSource.Eof

      SQLQSource.Close;

    //Table ADRESSES_IND si elle existe
      if TestTableChamp('ADRESSES_IND','ADR_CLEF') then
      begin
        lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['ADRESSES_IND']);
        Application.ProcessMessages;
        SQLQSource.SQL.Text:='select count(*) from individu i';
        SQLQSource.SQL.Add('inner join adresses_ind a on a.adr_kle_ind=i.cle_fiche');
        SQLQSource.SQL.Add('where i.kle_dossier='+dossiers);
        SQLQSource.ExecQuery;
        NbrEnr:=SQLQSource.Fields[0].AsInteger;
        SQLQSource.Close;
        SQLQSource.SQL.Text:='select a.* from individu i';
        SQLQSource.SQL.Add('inner join adresses_ind a on a.adr_kle_ind=i.cle_fiche');
        SQLQSource.SQL.Add('where i.kle_dossier='+dossiers);
        SQLQSource.ExecQuery;

        if not SQLQSource.Eof then
        begin
          i:=0;
          SQLQCible.SQL.Text:='execute block('
            +'EV_IND_KLE_FICHE integer=:EV_IND_KLE_FICHE'
            +',EV_IND_TYPE varchar(7)=:EV_IND_TYPE'
            +',EV_IND_DATE_WRITEN varchar(100)=:EV_IND_DATE_WRITEN'
            +',EV_IND_DATE_YEAR integer=:EV_IND_DATE_YEAR'
            +',EV_IND_DATE_MOIS integer=:EV_IND_DATE_MOIS'
            +',EV_IND_CALENDRIER1'
            +',EV_IND_CALENDRIER2'
            +',EV_IND_DATE date=:EV_IND_DATE'
            +',EV_IND_DATE_YEAR_FIN integer=:EV_IND_DATE_YEAR_FIN'
            +',EV_IND_DATE_MOIS_FIN integer=:EV_IND_DATE_MOIS_FIN'
            +',EV_IND_DATECODE Integer=:EV_IND_DATECODE'
            +',EV_IND_DATECODE_TOT Integer=:EV_IND_DATECODE_TOT'
            +',EV_IND_DATECODE_TARD Integer=:EV_IND_DATECODE_TARD'
            +',EV_IND_DATE_JOUR SmallInt=:EV_IND_DATE_JOUR'
            +',EV_IND_DATE_JOUR_FIN SmallInt=:EV_IND_DATE_JOUR_FIN'
            +',EV_IND_TYPE_TOKEN1 SmallInt=:EV_IND_TYPE_TOKEN1'
            +',EV_IND_TYPE_TOKEN2 SmallInt=:EV_IND_TYPE_TOKEN2'
            +',EV_IND_CP varchar(10)=:EV_IND_CP'
            +',EV_IND_VILLE varchar(50)=:EV_IND_VILLE'
            +',EV_IND_DEPT varchar(30)=:EV_IND_DEPT'
            +',EV_IND_PAYS varchar(30)=:EV_IND_PAYS'
            +',EV_IND_COMMENT blob=:EV_IND_COMMENT'
            +',EV_IND_REGION varchar(50)=:EV_IND_REGION'
            +',EV_IND_SUBD varchar(50)=:EV_IND_SUBD'
            +',EV_IND_INSEE varchar(6)=:EV_IND_INSEE'
            +',EV_IND_LATITUDE decimal(15,8)=:EV_IND_LATITUDE'
            +',EV_IND_LONGITUDE numeric(15,8)=:EV_IND_LONGITUDE'
            +',EV_IND_LIGNES_ADRESSE blob=:EV_IND_LIGNES_ADRESSE'
            +',EV_IND_TEL blob=:EV_IND_TEL'
            +',EV_IND_MAIL varchar(120)=:EV_IND_MAIL'
            +',EV_IND_WEB varchar(120)=:EV_IND_WEB'
            +')returns(clef integer)as'
            +' begin'
            +' insert into EVENEMENTS_IND('
            +'EV_IND_CLEF'
            +',EV_IND_KLE_FICHE'
            +',EV_IND_KLE_DOSSIER'
            +',EV_IND_TYPE'
            +',EV_IND_DATE_WRITEN'
            +',EV_IND_DATE_YEAR'
            +',EV_IND_DATE_MOIS'
            +',0'//la table ADRESSES_IND n'a été qu'en grégorien
            +',0'
            +',EV_IND_DATE'
            +',EV_IND_DATE_YEAR_FIN'
            +',EV_IND_DATE_MOIS_FIN'
            +',EV_IND_DATECODE'
            +',EV_IND_DATECODE_TOT'
            +',EV_IND_DATECODE_TARD'
            +',EV_IND_DATE_JOUR'
            +',EV_IND_DATE_JOUR_FIN'
            +',EV_IND_TYPE_TOKEN1'
            +',EV_IND_TYPE_TOKEN2'
            +',EV_IND_CP'
            +',EV_IND_VILLE'
            +',EV_IND_DEPT'
            +',EV_IND_PAYS'
            +',EV_IND_COMMENT'
            +',EV_IND_REGION'
            +',EV_IND_SUBD'
            +',EV_IND_INSEE'
            +',EV_IND_LATITUDE'
            +',EV_IND_LONGITUDE'
            +',EV_IND_LIGNES_ADRESSE'
            +',EV_IND_TEL'
            +',EV_IND_MAIL'
            +',EV_IND_WEB'
            +')'
            +' values('
            +'gen_id(gen_ev_ind_clef,1)'
            +',(select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:EV_IND_KLE_FICHE)'
            +','+dossierc
            +',:EV_IND_TYPE'
            +',:EV_IND_DATE_WRITEN'
            +',:EV_IND_DATE_YEAR'
            +',:EV_IND_DATE_MOIS'
            +',:EV_IND_DATE'
            +',:EV_IND_DATE_YEAR_FIN'
            +',:EV_IND_DATE_MOIS_FIN'
            +',:EV_IND_DATECODE'
            +',:EV_IND_DATECODE_TOT'
            +',:EV_IND_DATECODE_TARD'
            +',:EV_IND_DATE_JOUR'
            +',:EV_IND_DATE_JOUR_FIN'
            +',:EV_IND_TYPE_TOKEN1'
            +',:EV_IND_TYPE_TOKEN2'
            +',:EV_IND_CP'
            +',:EV_IND_VILLE'
            +',:EV_IND_DEPT'
            +',:EV_IND_PAYS'
            +',:EV_IND_COMMENT'
            +',:EV_IND_REGION'
            +',:EV_IND_SUBD'
            +',:EV_IND_INSEE'
            +',:EV_IND_LATITUDE'
            +',:EV_IND_LONGITUDE'
            +',:EV_IND_LIGNES_ADRESSE'
            +',:EV_IND_TEL'
            +',:EV_IND_MAIL'
            +',:EV_IND_WEB'
            +')returning EV_IND_CLEF into :clef;'
            +'suspend;'
            +'end';

          qPhoto.SQL.Text:='execute block('
            +'photo varchar(255)=:photo'
            +',dossier integer=:dossier'
            +',indi integer=:indi'
            +',clef_ev integer=:clef_ev)returns(nouveau integer,clef_media integer)as'
            +' begin '
            +' clef_media=null;'
            +' select first(1) multi_clef from multimedia'
            +' where multi_dossier=:dossier and multi_path=:photo'
            +' into :clef_media;'
            +' if (clef_media is null) then'
            +' begin'
            +' nouveau=1;'
            +'clef_media=gen_id(gen_multimedia,1);'
            +'insert into multimedia'
            +'(multi_clef'
            +',multi_infos'
            +',multi_dossier'
            +',multi_date_modif'
            +',multi_memo'
            +',multi_image_rtf'
            +',id_import_gedcom'
            +',multi_path)'
            +' values('
            +':clef_media'
            +',''Image domicile transférée le '+fs_DateTime2Str(now)+''''
            +',:dossier'
            +',current_timestamp'
            +',''Image domicile transférée, import n°'+IntToStr(IG_ID)+''''
            +',1'
            +','+IntToStr(IG_ID)
            +',:photo);'
            +'end else nouveau=0;'
            +'insert into media_pointeurs ('
            +'mp_clef'
            +',mp_media'
            +',mp_cle_individu'
            +',mp_pointe_sur'
            +',mp_table'
            +',mp_identite'
            +',mp_kle_dossier'
            +',mp_type_image'
            +',mp_position)'
            +'values('
            +'gen_id(biblio_pointeurs_id_gen,1)'
            +',:clef_media'
            +',(select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:indi)'
            +',:clef_ev'
            +',''I'''
            +',0'
            +',:dossier'
            +',''A'''
            +',0);'
            +'suspend;'
            +'end';

          while not SQLQSource.eof do
          begin
            inc(i);
            if (i=NbrEnr)or(i mod 10=0) then
            begin
              lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['ADRESSES_IND',IntToStr(I),IntToStr(NbrEnr)]);
              Application.ProcessMessages;
            end;
            SQLQCible.ParamByName('EV_IND_KLE_FICHE').AsInteger:=SQLQSource.FieldByName('ADR_KLE_IND').AsInteger;
            SQLQCible.ParamByName('EV_IND_TYPE').AsString:='RESI';
            for p:=2 to SQLQCible.Params.Count-1 do
              SQLQCible.Params[p].Clear;

            if not SQLQSource.FieldByName('ADR_ADRESSE').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('ADR_ADRESSE').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('EV_IND_LIGNES_ADRESSE').LoadFromStream(tampon);
            end;

            if SQLQSource.FieldByName('ADR_CP').AsString>'' then
              SQLQCible.ParamByName('EV_IND_CP').AsString:=SQLQSource.FieldByName('ADR_CP').AsString;
            if SQLQSource.FieldByName('ADR_VILLE').AsString>'' then
              SQLQCible.ParamByName('EV_IND_VILLE').AsString:=SQLQSource.FieldByName('ADR_VILLE').AsString;
            if SQLQSource.FieldByName('ADR_DEPT').AsString>'' then
              SQLQCible.ParamByName('EV_IND_DEPT').AsString:=SQLQSource.FieldByName('ADR_DEPT').AsString;
            if SQLQSource.FieldByName('ADR_REGION').AsString>'' then
              SQLQCible.ParamByName('EV_IND_REGION').AsString:=SQLQSource.FieldByName('ADR_REGION').AsString;
            if SQLQSource.FieldByName('ADR_PAYS').AsString>'' then
              SQLQCible.ParamByName('EV_IND_PAYS').AsString:=SQLQSource.FieldByName('ADR_PAYS').AsString;
            if SQLQSource.FieldByName('ADR_INSEE').AsString>'' then
              SQLQCible.ParamByName('EV_IND_INSEE').AsString:=SQLQSource.FieldByName('ADR_INSEE').AsString;

            if not SQLQSource.FieldByName('ADR_TEL').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('ADR_TEL').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('EV_IND_TEL').LoadFromStream(tampon);
            end;

            if SQLQSource.FieldByName('ADR_MAIL').AsString>'' then
              SQLQCible.ParamByName('EV_IND_MAIL').AsString:=SQLQSource.FieldByName('ADR_MAIL').AsString;
            try
              if SQLQSource.FieldByName('ADR_WEB').AsString>'' then
                SQLQCible.ParamByName('EV_IND_WEB').AsString:=SQLQSource.FieldByName('ADR_WEB').AsString;
            except//n'existe pas dans vielles bases
            end;

            if SQLQSource.FieldByName('ADR_DATE_WRITEN').AsString>'' then //AL2009 modif 2012
            begin
              if MaDate.DecodeHumanDate(SQLQSource.FieldByName('ADR_DATE_WRITEN').AsString) then
              begin
                if MaDate.ValidDateTime1 then
                  SQLQCible.ParamByName('EV_IND_DATE').AsDateTime:=MaDate.DateTime1;
                SQLQCible.ParamByName('EV_IND_DATECODE').AsInteger:=MaDate.DateCode1;
                SQLQCible.ParamByName('EV_IND_DATECODE_TOT').AsInteger:=MaDate.DateCodeTot;
                SQLQCible.ParamByName('EV_IND_DATECODE_TARD').AsInteger:=MaDate.DateCodeTard;
                SQLQCible.ParamByName('EV_IND_DATE_YEAR').AsInteger:=MaDate.Year1;
                if MaDate.Month1>0 then
                  SQLQCible.ParamByName('EV_IND_DATE_MOIS').AsInteger:=MaDate.Month1;
                if MaDate.Day1>0 then
                  SQLQCible.ParamByName('EV_IND_DATE_JOUR').AsInteger:=MaDate.Day1;
                if MaDate.Type_Key1>0 then
                  SQLQCible.ParamByName('EV_IND_TYPE_TOKEN1').AsInteger:=MaDate.Type_Key1;
                if MaDate.UseDate2 then
                begin
                  SQLQCible.ParamByName('EV_IND_DATE_YEAR_FIN').AsInteger:=MaDate.Year2;
                  if MaDate.Month2>0 then
                    SQLQCible.ParamByName('EV_IND_DATE_MOIS_FIN').AsInteger:=MaDate.Month2;
                  if MaDate.Day2>0 then
                    SQLQCible.ParamByName('EV_IND_DATE_JOUR_FIN').AsInteger:=MaDate.Day2;
                  if MaDate.Type_Key2>0 then
                    SQLQCible.ParamByName('EV_IND_TYPE_TOKEN2').AsInteger:=MaDate.Type_Key2;
                end;
              end;
              s:=Trim(Copy(MaDate.HumanDate,1,100));
              if Length(s)>0 then
                SQLQCible.ParamByName('EV_IND_DATE_WRITEN').AsString:=s;
            end;

            try
              if not SQLQSource.FieldByName('ADR_MEMO').IsNull then
              begin
                tampon.Clear;
                SQLQSource.FieldByName('ADR_MEMO').SaveToStream(tampon);
                if tampon.Size>0 then
                  SQLQCible.ParamByName('EV_IND_COMMENT').LoadFromStream(tampon);
              end;
            except
            end;

            try
              if SQLQSource.FieldByName('ADR_SUBD').AsString>'' then
                SQLQCible.ParamByName('EV_IND_SUBD').AsString:=SQLQSource.FieldByName('ADR_SUBD').AsString;
            except
            end;
            try
              if not SQLQSource.FieldByName('ADR_LATITUDE').IsNull then
                SQLQCible.ParamByName('EV_IND_LATITUDE').AsDouble:=SQLQSource.FieldByName('ADR_LATITUDE').AsDouble;
            except
            end;
            try
              if not SQLQSource.FieldByName('ADR_LONGITUDE').IsNull then
                SQLQCible.ParamByName('EV_IND_LONGITUDE').AsDouble:=SQLQSource.FieldByName('ADR_LONGITUDE').AsDouble;
            except
            end;

            try
              SQLQCible.ExecQuery;
            except
              on E:EIBError do
              begin
                MyMessageDlg(rs_Error_address_transfer
                  +SQLQSource.FieldByName('ADR_CLEF').AsString
                  +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
                dm.IBT_base.RollbackRetaining;
                exit;
              end;
            end;

            try//n'existe pas dans anciennes bases
              s:=SQLQSource.FieldByName('ADR_PHOTO').AsString;
              if s>'' then
              begin
                with qPhoto do
                begin
                  close;
                  ParamByName('photo').AsString:=s;
                  ParamByName('dossier').AsInteger:=StrToInt(dossierc);
                  ParamByName('indi').AsInteger:=SQLQSource.FieldByName('ADR_KLE_IND').AsInteger;
                  ParamByName('clef_ev').AsInteger:=SQLQCible.Fields[0].AsInteger;
                  ExecQuery;
                  if Fields[0].AsInteger=1 then
                  begin
                    if FileExistsUTF8(s) { *Converted from FileExistsUTF8*  } then
                    begin
                      QmajMedia.ParamByName('multi_clef').AsInteger:=Fields[1].AsInteger;
                      QmajMedia.ParamByName('multi_image_rtf').AsInteger:=1;
                      QmajMedia.ParamByName('multi_reduite').Clear;
                      QmajMedia.ParamByName('multi_media').Clear;
                      tampon.Clear;
                      tampon2.Clear;
                      p_FileToStream (s,tampon);
                      p_FileToStream (s,tampon2);
                      ImageData := fci_StreamToCustomImage( tampon, 140,120,True );
                      if tampon.Size > 0 then
                      begin

                        QmajMedia.ParamByName('multi_reduite').LoadFromStream(tampon);
                        if tampon2.Size>0 then
                        begin
                          QmajMedia.ParamByName('multi_media').LoadFromStream(tampon2);
                          QmajMedia.ParamByName('multi_image_rtf').AsInteger:=0;
                        end;
                        QmajMedia.ExecQuery;
                        QmajMedia.Close;
                      end;
                    end;//de FileExistsUTF8(s)
                  end;//de Fields[0].AsInteger=1
                  close;
                end;//de with qPhoto do
              end;//de not SQLQSource.FieldByName('ADR_PHOTO').IsNull
            except
            end;
            SQLQCible.Close;
            SQLQSource.Next;
          end;//de while not SQLQSource.eof do
        end;// fin de If not SQLQSource.Eof

        SQLQSource.Close;
      end;//de si la table ADRESSES_IND existe

    //-- Table T_UNION-----------------------------------------------------------------------------------------
      lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['T_UNION']);
      Application.ProcessMessages;
      SQLQSource.SQL.Text:='select count(*)';
      SQLQSource.SQL.Add('from t_union u where (u.union_mari>0 and u.union_femme>0');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_mari');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+')');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_femme');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+'))');
      SQLQSource.SQL.Add('or (u.union_mari>0 and (u.union_femme is null or u.union_femme=0)');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_mari');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+'))');
      SQLQSource.SQL.Add('or ((u.union_mari is null or u.union_mari=0) and u.union_femme>0');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_femme');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+'))');
      SQLQSource.ExecQuery;
      NbrEnr:=SQLQSource.Fields[0].AsInteger;
      SQLQSource.Close;
      SQLQSource.SQL.Text:='select *';
      SQLQSource.SQL.Add('from t_union u where (u.union_mari>0 and u.union_femme>0');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_mari');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+')');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_femme');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+'))');
      SQLQSource.SQL.Add('or (u.union_mari>0 and (u.union_femme is null or u.union_femme=0)');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_mari');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+'))');
      SQLQSource.SQL.Add('or ((u.union_mari is null or u.union_mari=0) and u.union_femme>0');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_femme');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+'))');
      SQLQSource.ExecQuery;

      if not SQLQSource.Eof then
      begin
        I:=0;
        SQLQCible.SQL.Text:='execute block('
          +'UNION_CLEF integer=:UNION_CLEF'
          +',UNION_MARI integer=:UNION_MARI'
          +',UNION_FEMME integer=:UNION_FEMME'
          +',union_type integer=:union_type'
          +',SOURCE blob=:SOURCE'
          +',COMMENT blob=:COMMENT'
          +')as'
          +' declare variable decujus integer;'
          +'begin'
          +' insert into T_UNION('
          +'UNION_CLEF'
          +',UNION_MARI'
          +',UNION_FEMME'
          +',KLE_DOSSIER'
          +',union_type'//conservé pour récupération par PROC_MAJ_TAGS
          +',SOURCE'
          +',COMMENT'
          +')'
          +'values('
          +'gen_id(gen_t_union,1)'
          +',(select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:UNION_MARI)'
          +',(select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:UNION_FEMME)'
          +','+dossierc
          +',:union_type'
          +',:SOURCE'
          +',:COMMENT'
          +')returning UNION_CLEF into :decujus;'
          +'insert into tq_consang(id,indi,decujus)values(4,:UNION_CLEF,:decujus);'
          +'end';

        while not SQLQSource.eof do
        begin
          inc(i);
          if (i=NbrEnr)or(i mod 10=0) then
          begin
            lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['T_UNION',IntToStr(I),IntToStr(NbrEnr)]);
            Application.ProcessMessages;
          end;
          SQLQCible.ParamByName('UNION_CLEF').AsInteger:=SQLQSource.FieldByName('UNION_CLEF').AsInteger;
          for p:=1 to SQLQCible.Params.Count-1 do
            SQLQCible.Params[p].Clear;
          if SQLQSource.FieldByName('UNION_MARI').AsInteger>0 then
            SQLQCible.ParamByName('UNION_MARI').AsInteger:=SQLQSource.FieldByName('UNION_MARI').AsInteger;
          if SQLQSource.FieldByName('UNION_FEMME').AsInteger>0 then
            SQLQCible.ParamByName('UNION_FEMME').AsInteger:=SQLQSource.FieldByName('UNION_FEMME').AsInteger;
          SQLQCible.ParamByName('union_type').AsInteger:=SQLQSource.FieldByName('union_type').AsInteger;

          if not SQLQSource.FieldByName('SOURCE').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('SOURCE').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('SOURCE').LoadFromStream(tampon);
          end;

          if not SQLQSource.FieldByName('COMMENT').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('COMMENT').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('COMMENT').LoadFromStream(tampon);
          end;

          try
            SQLQCible.ExecQuery;
          except
            on E:EIBError do
            begin
              MyMessageDlg(rs_Error_union_transfer
                +SQLQSource.FieldByName('UNION_CLEF').AsString
                +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
              dm.IBT_base.RollbackRetaining;
              exit;
            end;
          end;

          SQLQSource.Next;
        end;

        SQLQCible.Close;
      end;// fin de If not SQLQSource.Eof

      SQLQSource.Close;

    //-- Table EVENEMENTS_FAM----------------------------------------------------------------------------------
      lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['EVENEMENTS_FAM']);
      Application.ProcessMessages;
      SQLQSource.SQL.Text:='select count(*)';
      SQLQSource.SQL.Add(' from evenements_fam f');
      SQLQSource.SQL.Add('inner join t_union u on u.union_clef=f.ev_fam_kle_famille');
      SQLQSource.SQL.Add('and ((u.union_mari>0 and u.union_femme>0');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_mari');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+')');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_femme');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+'))');
      SQLQSource.SQL.Add('or(u.union_mari>0 and (u.union_femme is null or u.union_femme=0)');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_mari');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+'))');
      SQLQSource.SQL.Add('or(u.union_femme>0 and (u.union_mari is null or u.union_mari=0)');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_femme');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+')))');
      SQLQSource.ExecQuery;
      NbrEnr:=SQLQSource.Fields[0].AsInteger;
      SQLQSource.Close;
      SQLQSource.SQL.Text:='select f.*';
      SQLQSource.SQL.Add(' from evenements_fam f');
      SQLQSource.SQL.Add('inner join t_union u on u.union_clef=f.ev_fam_kle_famille');
      SQLQSource.SQL.Add('and ((u.union_mari>0 and u.union_femme>0');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_mari');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+')');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_femme');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+'))');
      SQLQSource.SQL.Add('or(u.union_mari>0 and (u.union_femme is null or u.union_femme=0)');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_mari');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+'))');
      SQLQSource.SQL.Add('or(u.union_femme>0 and (u.union_mari is null or u.union_mari=0)');
      SQLQSource.SQL.Add('and exists (select * from individu where cle_fiche=u.union_femme');
      SQLQSource.SQL.Add('and kle_dossier='+dossiers+')))');
      SQLQSource.ExecQuery;

      if not SQLQSource.Eof then
      begin
        I:=0;
        SQLQCible.SQL.text:='execute block('
          +'EV_FAM_CLEF integer=:EV_FAM_CLEF'
          +',EV_FAM_KLE_FAMILLE integer=:EV_FAM_KLE_FAMILLE'
          +',EV_FAM_TYPE varchar(7)=:EV_FAM_TYPE'
          +',EV_FAM_DATE_WRITEN varchar(100)=:EV_FAM_DATE_WRITEN'
          +',EV_FAM_DATE_YEAR integer=:EV_FAM_DATE_YEAR'
          +',EV_FAM_DATE_MOIS integer=:EV_FAM_DATE_MOIS'
          +',EV_FAM_CALENDRIER1 integer=:EV_FAM_CALENDRIER1'
          +',EV_FAM_CALENDRIER2 integer=:EV_FAM_CALENDRIER2'
          +',EV_FAM_DATE date=:EV_FAM_DATE'
          +',EV_FAM_DATE_YEAR_FIN integer=:EV_FAM_DATE_YEAR_FIN'
          +',EV_FAM_DATE_MOIS_FIN integer=:EV_FAM_DATE_MOIS_FIN'
          +',EV_FAM_DATECODE Integer=:EV_FAM_DATECODE'
          +',EV_FAM_DATECODE_TOT Integer=:EV_FAM_DATECODE_TOT'
          +',EV_FAM_DATECODE_TARD Integer=:EV_FAM_DATECODE_TARD'
          +',EV_FAM_DATE_JOUR SmallInt=:EV_FAM_DATE_JOUR'
          +',EV_FAM_DATE_JOUR_FIN SmallInt=:EV_FAM_DATE_JOUR_FIN'
          +',EV_FAM_TYPE_TOKEN1 SmallInt=:EV_FAM_TYPE_TOKEN1'
          +',EV_FAM_TYPE_TOKEN2 SmallInt=:EV_FAM_TYPE_TOKEN2'
          +',EV_FAM_CP varchar(10)=:EV_FAM_CP'
          +',EV_FAM_VILLE varchar(50)=:EV_FAM_VILLE'
          +',EV_FAM_DEPT varchar(30)=:EV_FAM_DEPT'
          +',EV_FAM_PAYS varchar(30)=:EV_FAM_PAYS'
          +',EV_FAM_SOURCE blob=:EV_FAM_SOURCE'
          +',EV_FAM_COMMENT blob=:EV_FAM_COMMENT'
          +',EV_FAM_REGION varchar(50)=:EV_FAM_REGION'
          +',EV_FAM_SUBD varchar(50)=:EV_FAM_SUBD'
          +',EV_FAM_ACTE integer=:EV_FAM_ACTE'
          +',EV_FAM_INSEE varchar(6)=:EV_FAM_INSEE'
          +',EV_FAM_ORDRE integer=:EV_FAM_ORDRE'
          +',EV_FAM_HEURE time=:EV_FAM_HEURE'
          +',EV_FAM_TITRE_EVENT varchar(25)=:EV_FAM_TITRE_EVENT'
          +',EV_FAM_LATITUDE decimal(15,8)=:EV_FAM_LATITUDE'
          +',EV_FAM_LONGITUDE numeric(15,8)=:EV_FAM_LONGITUDE'
          +',EV_FAM_DESCRIPTION varchar(90)=:EV_FAM_DESCRIPTION'
          +',EV_FAM_CAUSE varchar(90)=:EV_FAM_CAUSE'
          +')as'
          +' declare variable decujus integer;'
          +'begin'
          +' select DECUJUS from TQ_CONSANG where ID=4 AND INDI=:EV_FAM_KLE_FAMILLE into :decujus;'
          +'if (decujus>0)then begin'
          +' insert into EVENEMENTS_FAM('
          +'EV_FAM_CLEF'
          +',EV_FAM_KLE_FAMILLE'
          +',EV_FAM_KLE_DOSSIER'
          +',EV_FAM_TYPE'
          +',EV_FAM_DATE_WRITEN'
          +',EV_FAM_DATE_YEAR'
          +',EV_FAM_DATE_MOIS'
          +',EV_FAM_CALENDRIER1'
          +',EV_FAM_CALENDRIER2'
          +',EV_FAM_DATE'
          +',EV_FAM_DATE_YEAR_FIN'
          +',EV_FAM_DATE_MOIS_FIN'
          +',EV_FAM_DATECODE'
          +',EV_FAM_DATECODE_TOT'
          +',EV_FAM_DATECODE_TARD'
          +',EV_FAM_DATE_JOUR'
          +',EV_FAM_DATE_JOUR_FIN'
          +',EV_FAM_TYPE_TOKEN1'
          +',EV_FAM_TYPE_TOKEN2'
          +',EV_FAM_CP'
          +',EV_FAM_VILLE'
          +',EV_FAM_DEPT'
          +',EV_FAM_PAYS'
          +',EV_FAM_SOURCE'
          +',EV_FAM_COMMENT'
          +',EV_FAM_REGION'
          +',EV_FAM_SUBD'
          +',EV_FAM_ACTE'
          +',EV_FAM_INSEE'
          +',EV_FAM_ORDRE'
          +',EV_FAM_HEURE'
          +',EV_FAM_TITRE_EVENT'
          +',EV_FAM_LATITUDE'
          +',EV_FAM_LONGITUDE'
          +',EV_FAM_DESCRIPTION'
          +',EV_FAM_CAUSE'
          +')'
          +' values('
          +'gen_id(gen_ev_fam_clef,1)'
          +',:decujus'
          +','+dossierc
          +',:EV_FAM_TYPE'
          +',:EV_FAM_DATE_WRITEN'
          +',:EV_FAM_DATE_YEAR'
          +',:EV_FAM_DATE_MOIS'
          +',:EV_FAM_CALENDRIER1'
          +',:EV_FAM_CALENDRIER2'
          +',:EV_FAM_DATE'
          +',:EV_FAM_DATE_YEAR_FIN'
          +',:EV_FAM_DATE_MOIS_FIN'
          +',:EV_FAM_DATECODE'
          +',:EV_FAM_DATECODE_TOT'
          +',:EV_FAM_DATECODE_TARD'
          +',:EV_FAM_DATE_JOUR'
          +',:EV_FAM_DATE_JOUR_FIN'
          +',:EV_FAM_TYPE_TOKEN1'
          +',:EV_FAM_TYPE_TOKEN2'
          +',:EV_FAM_CP'
          +',:EV_FAM_VILLE'
          +',:EV_FAM_DEPT'
          +',:EV_FAM_PAYS'
          +',:EV_FAM_SOURCE'
          +',:EV_FAM_COMMENT'
          +',:EV_FAM_REGION'
          +',:EV_FAM_SUBD'
          +',:EV_FAM_ACTE'
          +',:EV_FAM_INSEE'
          +',:EV_FAM_ORDRE'
          +',:EV_FAM_HEURE'
          +',:EV_FAM_TITRE_EVENT'
          +',:EV_FAM_LATITUDE'
          +',:EV_FAM_LONGITUDE'
          +',:EV_FAM_DESCRIPTION'
          +',:EV_FAM_CAUSE'
          +')returning EV_FAM_CLEF into :decujus;'
          +'insert into tq_consang(id,indi,decujus)values(5,:EV_FAM_CLEF,:decujus);'
          +'end'
          +' end';

        while not SQLQSource.eof do
        begin
          inc(i);
          if (i=NbrEnr)or(i mod 10=0) then
          begin
            lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['EVENEMENTS_FAM',IntToStr(I),IntToStr(NbrEnr)]);
            Application.ProcessMessages;
          end;
          SQLQCible.ParamByName('EV_FAM_CLEF').AsInteger:=SQLQSource.FieldByName('EV_FAM_CLEF').AsInteger;//NouvCle;
          SQLQCible.ParamByName('EV_FAM_KLE_FAMILLE').AsInteger:=SQLQSource.FieldByName('EV_FAM_KLE_FAMILLE').AsInteger;
          for p:=2 to SQLQCible.Params.Count-1 do
            SQLQCible.Params[p].Clear;
          if SQLQSource.FieldByName('EV_FAM_TYPE').AsString>'' then
            SQLQCible.ParamByName('EV_FAM_TYPE').AsString:=SQLQSource.FieldByName('EV_FAM_TYPE').AsString;

          if bOrigAvecDateCode then
          begin
            if SQLQSource.FieldByName('EV_FAM_DATE_YEAR').IsNull then
              annee1:=_AnMini
            else
              annee1:=SQLQSource.FieldByName('EV_FAM_DATE_YEAR').AsInteger;
            if SQLQSource.FieldByName('EV_FAM_DATE_YEAR_FIN').IsNull then
              annee2:=_AnMini
            else
              annee2:=SQLQSource.FieldByName('EV_FAM_DATE_YEAR_FIN').AsInteger;
            bContinuer:=MaDate.DecodeHumanDate(annee1,
              SQLQSource.FieldByName('EV_FAM_DATE_MOIS').AsInteger,
              SQLQSource.FieldByName('EV_FAM_DATE_JOUR').AsInteger,
              SQLQSource.FieldByName('EV_FAM_TYPE_TOKEN1').AsInteger,
              TCalendrier(SQLQSource.FieldByName('EV_FAM_CALENDRIER1').AsInteger),
              annee2,
              SQLQSource.FieldByName('EV_FAM_DATE_MOIS_FIN').AsInteger,
              SQLQSource.FieldByName('EV_FAM_DATE_JOUR_FIN').AsInteger,
              SQLQSource.FieldByName('EV_FAM_TYPE_TOKEN2').AsInteger,
              TCalendrier(SQLQSource.FieldByName('EV_FAM_CALENDRIER2').AsInteger));
          end
           else
            bContinuer:=(Length(SQLQSource.FieldByName('EV_FAM_DATE_WRITEN').AsString)>0)
              and MaDate.DecodeHumanDate(SQLQSource.FieldByName('EV_FAM_DATE_WRITEN').AsString);

          if Length(SQLQSource.FieldByName('EV_FAM_DATE_WRITEN').AsString)>0 then
          begin
            s:=Trim(Copy(MaDate.HumanDate,1,100));
            if Length(s)>0 then
              SQLQCible.ParamByName('EV_FAM_DATE_WRITEN').AsString:=s;
          end;

          if bContinuer then //AL2009 modif 2012
          begin
            if MaDate.ValidDateTime1 then
              SQLQCible.ParamByName('EV_FAM_DATE').AsDateTime:=MaDate.DateTime1;
            SQLQCible.ParamByName('EV_FAM_DATECODE').AsInteger:=MaDate.DateCode1;
            SQLQCible.ParamByName('EV_FAM_DATECODE_TOT').AsInteger:=MaDate.DateCodeTot;
            SQLQCible.ParamByName('EV_FAM_DATECODE_TARD').AsInteger:=MaDate.DateCodeTard;
            SQLQCible.ParamByName('EV_FAM_DATE_YEAR').AsInteger:=MaDate.Year1;
            SQLQCible.ParamByName('EV_FAM_CALENDRIER1').AsInteger:=ord(MaDate.Calendrier1);
            if MaDate.Month1>0 then
              SQLQCible.ParamByName('EV_FAM_DATE_MOIS').AsInteger:=MaDate.Month1;
            if MaDate.Day1>0 then
              SQLQCible.ParamByName('EV_FAM_DATE_JOUR').AsInteger:=MaDate.Day1;
            if MaDate.Type_Key1>0 then
              SQLQCible.ParamByName('EV_FAM_TYPE_TOKEN1').AsInteger:=MaDate.Type_Key1;
            if MaDate.UseDate2 then
            begin
              SQLQCible.ParamByName('EV_FAM_DATE_YEAR_FIN').AsInteger:=MaDate.Year2;
              if MaDate.Month2>0 then
                SQLQCible.ParamByName('EV_FAM_DATE_MOIS_FIN').AsInteger:=MaDate.Month2;
              if MaDate.Day2>0 then
                SQLQCible.ParamByName('EV_FAM_DATE_JOUR_FIN').AsInteger:=MaDate.Day2;
              if MaDate.Type_Key2>0 then
                SQLQCible.ParamByName('EV_FAM_TYPE_TOKEN2').AsInteger:=MaDate.Type_Key2;
              SQLQCible.ParamByName('EV_FAM_CALENDRIER2').AsInteger:=ord(MaDate.Calendrier2);
            end;
          end;

          if SQLQSource.FieldByName('EV_FAM_CP').AsString>'' then
            SQLQCible.ParamByName('EV_FAM_CP').AsString:=SQLQSource.FieldByName('EV_FAM_CP').AsString;
          if SQLQSource.FieldByName('EV_FAM_VILLE').AsString>'' then
            SQLQCible.ParamByName('EV_FAM_VILLE').AsString:=SQLQSource.FieldByName('EV_FAM_VILLE').AsString;
          if SQLQSource.FieldByName('EV_FAM_DEPT').AsString>'' then
            SQLQCible.ParamByName('EV_FAM_DEPT').AsString:=SQLQSource.FieldByName('EV_FAM_DEPT').AsString;
          if SQLQSource.FieldByName('EV_FAM_PAYS').AsString>'' then
            SQLQCible.ParamByName('EV_FAM_PAYS').AsString:=SQLQSource.FieldByName('EV_FAM_PAYS').AsString;
          if SQLQSource.FieldByName('EV_FAM_REGION').AsString>'' then
            SQLQCible.ParamByName('EV_FAM_REGION').AsString:=SQLQSource.FieldByName('EV_FAM_REGION').AsString;
          if SQLQSource.FieldByName('EV_FAM_SUBD').AsString>'' then
            SQLQCible.ParamByName('EV_FAM_SUBD').AsString:=SQLQSource.FieldByName('EV_FAM_SUBD').AsString;
          SQLQCible.ParamByName('EV_FAM_ACTE').AsInteger:=SQLQSource.FieldByName('EV_FAM_ACTE').AsInteger;
          if SQLQSource.FieldByName('EV_FAM_INSEE').AsString>'' then
            SQLQCible.ParamByName('EV_FAM_INSEE').AsString:=SQLQSource.FieldByName('EV_FAM_INSEE').AsString;

          if not SQLQSource.FieldByName('EV_FAM_SOURCE').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('EV_FAM_SOURCE').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('EV_FAM_SOURCE').LoadFromStream(tampon);
          end;

          if not SQLQSource.FieldByName('EV_FAM_COMMENT').IsNull then
          begin
            tampon.Clear;
            SQLQSource.FieldByName('EV_FAM_COMMENT').SaveToStream(tampon);
            if tampon.Size>0 then
              SQLQCible.ParamByName('EV_FAM_COMMENT').LoadFromStream(tampon);
          end;

          try
            if not SQLQSource.FieldByName('EV_FAM_ORDRE').IsNull then
              SQLQCible.ParamByName('EV_FAM_ORDRE').AsInteger:=SQLQSource.FieldByName('EV_FAM_ORDRE').AsInteger;
          except
          end;
          try
            if not SQLQSource.FieldByName('EV_FAM_HEURE').IsNull then
              SQLQCible.ParamByName('EV_FAM_HEURE').AsDateTime:=SQLQSource.FieldByName('EV_FAM_HEURE').AsDateTime;
          except
          end;

          try
            if SQLQSource.FieldByName('EV_FAM_TITRE_EVENT').AsString>'' then
              SQLQCible.ParamByName('EV_FAM_TITRE_EVENT').AsString:=SQLQSource.FieldByName('EV_FAM_TITRE_EVENT').AsString;
          except
          end;

          try
            if not SQLQSource.FieldByName('EV_FAM_LATITUDE').IsNull then
              SQLQCible.ParamByName('EV_FAM_LATITUDE').AsDouble:=SQLQSource.FieldByName('EV_FAM_LATITUDE').AsDouble;
          except
          end;

          try
            if not SQLQSource.FieldByName('EV_FAM_LONGITUDE').IsNull then
              SQLQCible.ParamByName('EV_FAM_LONGITUDE').AsDouble:=SQLQSource.FieldByName('EV_FAM_LONGITUDE').AsDouble;
          except
          end;

          try
            if SQLQSource.FieldByName('EV_FAM_DESCRIPTION').AsString>'' then
              SQLQCible.ParamByName('EV_FAM_DESCRIPTION').AsString:=SQLQSource.FieldByName('EV_FAM_DESCRIPTION').AsString;
          except
          end;

          try
            if SQLQSource.FieldByName('EV_FAM_CAUSE').AsString>'' then
              SQLQCible.ParamByName('EV_FAM_CAUSE').AsString:=SQLQSource.FieldByName('EV_FAM_CAUSE').AsString;
          except
          end;

          try
            SQLQCible.ExecQuery;
          except
            on E:EIBError do
            begin
              MyMessageDlg(rs_Error_family_event_transfer
                +SQLQSource.FieldByName('EV_FAM_CLEF').AsString
                +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
              dm.IBT_base.RollbackRetaining;
              exit;
            end;
          end;

          SQLQSource.Next;
        end;

        SQLQCible.Close;
      end;// fin de If not SQLQSource.Eof

      SQLQSource.Close;

    //désactivation des paramètres spécifiques au décodage des dates.
    //inutiles après le transfert des événements familiaux
      sOrdreLIT:='';
      sOrdreNUM:='';
    finally
      tampon.Free;
      tampon2.Free;
      dm.InactiveTriggersLieuxFavoris(false);
    end;

  //-- Table T_ASSOCIATIONS 1-à événements individuels
    lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['T_ASSOCIATIONS '+rs_Caption_On_persons_events]);
    Application.ProcessMessages;
    bNouvVersion:=TestTableChamp('T_ASSOCIATIONS','ASSOC_LIBELLE');
    if bNouvVersion then
      SQLQSource.SQL.Text:='select count(*) FROM T_ASSOCIATIONS a'
    else
    begin
      SQLQSource.SQL.Text:='select count(*) FROM T_ASSOCIATIONS a';
      SQLQSource.SQL.Add('inner join ref_rela_temoins r on r.ref_rela_code=a.assoc_type');
    end;
    SQLQSource.SQL.Add('WHERE a.ASSOC_TABLE=''I''');
    SQLQSource.SQL.Add('and exists(select * from individu');
    SQLQSource.SQL.Add('where cle_fiche=a.assoc_kle_ind and kle_dossier='+dossiers+')');
    SQLQSource.SQL.Add('and exists( select * from individu');
    SQLQSource.SQL.Add('where cle_fiche=a.assoc_kle_associe and kle_dossier='+dossiers+')');
    SQLQSource.SQL.Add('and exists(select * from evenements_ind e');
    SQLQSource.SQL.Add('inner join individu i on i.cle_fiche=e.ev_ind_kle_fiche and i.kle_dossier='+dossiers);
    SQLQSource.SQL.Add('where e.ev_ind_clef=a.assoc_evenement)');
    SQLQSource.ExecQuery;
    NbrEnr:=SQLQSource.Fields[0].AsInteger;
    SQLQSource.Close;

    if bNouvVersion then
      SQLQSource.SQL.Strings[0]:='select a.* FROM T_ASSOCIATIONS a'
    else
      SQLQSource.SQL.Strings[0]:='select a.*,r.ref_rela_libelle as ASSOC_LIBELLE FROM T_ASSOCIATIONS a';
    SQLQSource.ExecQuery;

    I:=0;
    if not SQLQSource.Eof then
    begin
      SQLQCible.SQL.Text:='insert into T_ASSOCIATIONS ('
        +'ASSOC_CLEF'
        +',ASSOC_KLE_IND'
        +',ASSOC_KLE_ASSOCIE'
        +',ASSOC_KLE_DOSSIER'
        +',ASSOC_LIBELLE'
        +',ASSOC_EVENEMENT'
        +',ASSOC_TABLE'
        +')'
        +' values('
        +'gen_id(gen_assoc_clef,1)'
        +',(select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:ASSOC_KLE_IND)'
        +',(select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:ASSOC_KLE_ASSOCIE)'
        +','+dossierc
        +',:ASSOC_LIBELLE'
        +',(select DECUJUS from TQ_CONSANG where ID=3 AND INDI=:ASSOC_EVENEMENT)'
        +',''I'''
        +')';

      while not SQLQSource.eof do
      begin
        inc(i);
        if (i=NbrEnr)or(i mod 10=0) then
        begin
          lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['T_ASSOCIATIONS '+rs_Caption_On_persons_events,IntToStr(I),IntToStr(NbrEnr)]);
          Application.ProcessMessages;
        end;
        SQLQCible.ParamByName('ASSOC_KLE_IND').AsInteger:=SQLQSource.FieldByName('ASSOC_KLE_IND').AsInteger;
        SQLQCible.ParamByName('ASSOC_KLE_ASSOCIE').AsInteger:=SQLQSource.FieldByName('ASSOC_KLE_ASSOCIE').AsInteger;
        if SQLQSource.FieldByName('ASSOC_LIBELLE').AsString>'' then
          SQLQCible.ParamByName('ASSOC_LIBELLE').AsString:=SQLQSource.FieldByName('ASSOC_LIBELLE').AsString
        else
          SQLQCible.ParamByName('ASSOC_LIBELLE').AsString:='(inconnu)';
        SQLQCible.ParamByName('ASSOC_EVENEMENT').AsInteger:=SQLQSource.FieldByName('ASSOC_EVENEMENT').AsInteger;

        try
          SQLQCible.ExecQuery;
        except
          on E:EIBError do
          begin
            MyMessageDlg(rs_Error_link_transfer
              +SQLQSource.FieldByName('ASSOC_CLEF').AsString
              +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
            dm.IBT_base.RollbackRetaining;
            exit;
          end;
        end;

        SQLQSource.Next;
      end;

      SQLQCible.Close;
    end;// fin de If not SQLQSource.Eof

    SQLQSource.Close;

    //-- Table T_ASSOCIATIONS 2-à évènements familiaux---------------------------------------------------------
    lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['T_ASSOCIATIONS '+rs_Caption_On_family_events]);
    Application.ProcessMessages;
    if bNouvVersion then
      SQLQSource.SQL.Text:='select count(*) from t_associations a'
    else
    begin
      SQLQSource.SQL.Text:='select count(*) from t_associations a';
      SQLQSource.SQL.Add('inner join ref_rela_temoins r on r.ref_rela_code=a.assoc_type');
    end;
    SQLQSource.SQL.Add('where a.assoc_table=''U''');
    SQLQSource.SQL.Add('and exists(select * from individu');
    SQLQSource.SQL.Add('where cle_fiche=a.assoc_kle_associe and kle_dossier='+dossiers+')');
    SQLQSource.ExecQuery;
    NbrEnr:=SQLQSource.Fields[0].AsInteger;
    SQLQSource.Close;
    if bNouvVersion then
      SQLQSource.SQL.Strings[0]:='select a.* from t_associations a'
    else
      SQLQSource.SQL.Strings[0]:='select a.*,r.ref_rela_libelle as ASSOC_LIBELLE from t_associations a';
    SQLQSource.ExecQuery;
    i:=0;
    if not SQLQSource.Eof then
    begin
      SQLQCible.Close;
      SQLQCible.SQL.Text:='execute block('
        +'ASSOC_KLE_ASSOCIE integer=:ASSOC_KLE_ASSOCIE'
        +',ASSOC_EVENEMENT integer=:ASSOC_EVENEMENT'
        +',ASSOC_LIBELLE varchar(90)=:ASSOC_LIBELLE'
        +')as'
        +' begin'
        +' select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:ASSOC_KLE_ASSOCIE into :ASSOC_KLE_ASSOCIE;'
        +'select DECUJUS from TQ_CONSANG where ID=5 AND INDI=:ASSOC_EVENEMENT into :ASSOC_EVENEMENT;'
        +'if((ASSOC_KLE_ASSOCIE>0)and(ASSOC_EVENEMENT>0))then'
        +' insert into T_ASSOCIATIONS('
        +'ASSOC_CLEF'
        +',ASSOC_KLE_IND'
        +',ASSOC_KLE_ASSOCIE'
        +',ASSOC_KLE_DOSSIER'
        +',ASSOC_LIBELLE'
        +',ASSOC_EVENEMENT'
        +',ASSOC_TABLE'
        +')'
        +'values('
        +'gen_id(gen_assoc_clef,1)'
        +',:ASSOC_EVENEMENT'
        +',:ASSOC_KLE_ASSOCIE'
        +','+dossierc
        +',:ASSOC_LIBELLE'
        +',:ASSOC_EVENEMENT'
        +',''U'''
        +');'
        +'end';

      while not SQLQSource.eof do
      begin
        inc(i);
        if (i=NbrEnr)or(i mod 10=0) then
        begin
          lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['T_ASSOCIATIONS '+rs_Caption_On_family_events,IntToStr(I),IntToStr(NbrEnr)]);
          Application.ProcessMessages;
        end;
        SQLQCible.ParamByName('ASSOC_KLE_ASSOCIE').AsInteger:=SQLQSource.FieldByName('ASSOC_KLE_ASSOCIE').AsInteger;
        SQLQCible.ParamByName('ASSOC_EVENEMENT').AsInteger:=SQLQSource.FieldByName('ASSOC_EVENEMENT').AsInteger;

        if SQLQSource.FieldByName('ASSOC_LIBELLE').AsString>'' then
          SQLQCible.ParamByName('ASSOC_LIBELLE').AsString:=SQLQSource.FieldByName('ASSOC_LIBELLE').AsString
        else
          SQLQCible.ParamByName('ASSOC_LIBELLE').AsString:='(inconnu)';

        try
          SQLQCible.ExecQuery;
        except
          on E:EIBError do
          begin
            MyMessageDlg(rs_Error_link_transfer
              +SQLQSource.FieldByName('ASSOC_CLEF').AsString
              +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
            dm.IBT_base.RollbackRetaining;
            exit;
          end;
        end;
        SQLQSource.Next;
      end;//de while not SQLQSource.eof
      SQLQCible.Close;
    end;// fin de If not SQLQSource.Eof

    SQLQSource.Close;

    if TestTableChamp('SOURCES_RECORD','TYPE_TABLE') then
    begin//récupération impossible dans la structure actuelle des anciens SOURCES_RECORD sans TYPE_TABLE
      tampon:=TMemoryStream.Create;
      try
    // -- Table SOURCES_RECORD 1-d'évènements familiaux----
        lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['SOURCES_RECORD '+rs_Caption_On_families]);
        Application.ProcessMessages;
        SQLQSource.SQL.Text:='select count(*)';
        SQLQSource.SQL.Add('FROM SOURCES_RECORD WHERE TYPE_TABLE=''F''');
        SQLQSource.SQL.Add('AND KLE_DOSSIER='+dossiers);
        SQLQSource.ExecQuery;
        NbrEnr:=SQLQSource.Fields[0].AsInteger;
        SQLQSource.Close;
        SQLQSource.SQL.Strings[0]:='select *';
        SQLQSource.ExecQuery;
        I:=0;

        if not SQLQSource.Eof then
        begin
          SQLQCible.close;
          SQLQCible.SQL.Text:='execute block(';
          SQLQCible.SQL.Add('id integer=:id');//id du source_record d'origine
          SQLQCible.SQL.Add(',data_id integer=:data_id');//ev fam d'origine (puis cible)
          SQLQCible.SQL.Add(',SOURCE_PAGE varchar(248)=:SOURCE_PAGE');
          SQLQCible.SQL.Add(',EVEN varchar(15)=:EVEN');
          SQLQCible.SQL.Add(',EVEN_ROLE varchar(25)=:EVEN_ROLE');
          SQLQCible.SQL.Add(',DATA_EVEN varchar(90)=:DATA_EVEN');
          SQLQCible.SQL.Add(',DATA_EVEN_PERIOD varchar(35)=:DATA_EVEN_PERIOD');
          SQLQCible.SQL.Add(',DATA_EVEN_PLAC varchar(120)=:DATA_EVEN_PLAC');
          SQLQCible.SQL.Add(',DATA_AGNC varchar(120)=:DATA_AGNC');
          SQLQCible.SQL.Add(',QUAY integer=:QUAY');
          SQLQCible.SQL.Add(',AUTH blob=:AUTH');
          SQLQCible.SQL.Add(',TITL blob=:TITL');
          SQLQCible.SQL.Add(',ABR varchar(60)=:ABR');
          SQLQCible.SQL.Add(',PUBL blob=:PUBL');
          SQLQCible.SQL.Add(',TEXTE blob=:TEXTE');
          SQLQCible.SQL.Add(',USER_REF blob=:USER_REF');
          SQLQCible.SQL.Add(',RIN varchar(12)=:RIN');
          SQLQCible.SQL.Add(',CHANGE_NOTE blob=:CHANGE_NOTE');
          SQLQCible.SQL.Add(')as');
          SQLQCible.SQL.Add('declare variable decujus integer;');
          SQLQCible.SQL.Add('begin');
          SQLQCible.SQL.Add('select DECUJUS from TQ_CONSANG where ID=5 AND INDI=:DATA_ID into :data_id;');
          SQLQCible.SQL.Add('if(data_id>0)then begin');
          SQLQCible.SQL.Add('select ID from SOURCES_RECORD');
          SQLQCible.SQL.Add('where DATA_ID=:data_id AND TYPE_TABLE=''F''');
          SQLQCible.SQL.Add('into :decujus;');
          SQLQCible.SQL.Add('insert into tq_consang(id,indi,decujus)values(6,:id,:decujus);');
          SQLQCible.SQL.Add('update SOURCES_RECORD set');
          SQLQCible.SQL.Add('SOURCE_PAGE=:SOURCE_PAGE');
          SQLQCible.SQL.Add(',EVEN=:EVEN');
          SQLQCible.SQL.Add(',EVEN_ROLE=:EVEN_ROLE');
          SQLQCible.SQL.Add(',DATA_EVEN=:DATA_EVEN');
          SQLQCible.SQL.Add(',DATA_EVEN_PERIOD=:DATA_EVEN_PERIOD');
          SQLQCible.SQL.Add(',DATA_EVEN_PLAC=:DATA_EVEN_PLAC');
          SQLQCible.SQL.Add(',DATA_AGNC=:DATA_AGNC');
          SQLQCible.SQL.Add(',QUAY=:QUAY');
          SQLQCible.SQL.Add(',AUTH=:AUTH');
          SQLQCible.SQL.Add(',TITL=:TITL');
          SQLQCible.SQL.Add(',ABR=:ABR');
          SQLQCible.SQL.Add(',PUBL=:PUBL');
          SQLQCible.SQL.Add(',TEXTE=:TEXTE');
          SQLQCible.SQL.Add(',USER_REF=:USER_REF');
          SQLQCible.SQL.Add(',RIN=:RIN');
          SQLQCible.SQL.Add(',CHANGE_NOTE=:CHANGE_NOTE');
          SQLQCible.SQL.Add('where ID=:decujus AND TYPE_TABLE=''F'';');
          SQLQCible.SQL.Add('end');
          SQLQCible.SQL.Add('end');

          while not SQLQSource.Eof do
          begin
            inc(i);
            if (i=NbrEnr)or(i mod 10=0) then
            begin
              lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['SOURCES_RECORD '+rs_Caption_On_families,IntToStr(I),IntToStr(NbrEnr)]);
              Application.ProcessMessages;
            end;
            SQLQCible.ParamByName('id').AsInteger:=SQLQSource.FieldByName('id').AsInteger;
            SQLQCible.ParamByName('data_id').AsInteger:=SQLQSource.FieldByName('data_id').AsInteger;

            for p:=2 to SQLQCible.Params.Count-1 do
              SQLQCible.Params[p].Clear;

            if SQLQSource.FieldByName('SOURCE_PAGE').AsString>'' then
              SQLQCible.ParamByName('SOURCE_PAGE').AsString:=SQLQSource.FieldByName('SOURCE_PAGE').AsString;
            if SQLQSource.FieldByName('EVEN').AsString>'' then
              SQLQCible.ParamByName('EVEN').AsString:=SQLQSource.FieldByName('EVEN').AsString;
            if SQLQSource.FieldByName('EVEN_ROLE').AsString>'' then
              SQLQCible.ParamByName('EVEN_ROLE').AsString:=SQLQSource.FieldByName('EVEN_ROLE').AsString;
            if SQLQSource.FieldByName('DATA_EVEN').AsString>'' then
              SQLQCible.ParamByName('DATA_EVEN').AsString:=SQLQSource.FieldByName('DATA_EVEN').AsString;
            if SQLQSource.FieldByName('DATA_EVEN_PERIOD').AsString>'' then
              SQLQCible.ParamByName('DATA_EVEN_PERIOD').AsString:=SQLQSource.FieldByName('DATA_EVEN_PERIOD').AsString;
            if SQLQSource.FieldByName('DATA_EVEN_PLAC').AsString>'' then
              SQLQCible.ParamByName('DATA_EVEN_PLAC').AsString:=SQLQSource.FieldByName('DATA_EVEN_PLAC').AsString;
            if SQLQSource.FieldByName('DATA_AGNC').AsString>'' then
              SQLQCible.ParamByName('DATA_AGNC').AsString:=SQLQSource.FieldByName('DATA_AGNC').AsString;
            if not SQLQSource.FieldByName('QUAY').IsNull then
              SQLQCible.ParamByName('QUAY').AsInteger:=SQLQSource.FieldByName('QUAY').AsInteger;

            if not SQLQSource.FieldByName('AUTH').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('AUTH').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('AUTH').LoadFromStream(tampon);
            end;

            if not SQLQSource.FieldByName('TITL').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('TITL').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('TITL').LoadFromStream(tampon);
            end;

            if SQLQSource.FieldByName('ABR').AsString>'' then
              SQLQCible.ParamByName('ABR').AsString:=SQLQSource.FieldByName('ABR').AsString;

            if not SQLQSource.FieldByName('PUBL').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('PUBL').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('PUBL').LoadFromStream(tampon);
            end;

            if not SQLQSource.FieldByName('TEXTE').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('TEXTE').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('TEXTE').LoadFromStream(tampon);
            end;

            if not SQLQSource.FieldByName('USER_REF').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('USER_REF').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('USER_REF').LoadFromStream(tampon);
            end;

            if SQLQSource.FieldByName('RIN').AsString>'' then
              SQLQCible.ParamByName('RIN').AsString:=SQLQSource.FieldByName('RIN').AsString;

            if not SQLQSource.FieldByName('CHANGE_NOTE').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('CHANGE_NOTE').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('CHANGE_NOTE').LoadFromStream(tampon);
            end;

            try
              SQLQCible.ExecQuery;
            except
              on E:EIBError do
              begin
                MyMessageDlg(rs_Error_source_transfer
                  +SQLQSource.FieldByName('ID').AsString
                  +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
                dm.IBT_base.RollbackRetaining;
                exit;
              end;
            end;

            SQLQSource.Next;
          end;//de while not SQLQSource.Eof
          SQLQCible.Close;
        end;// fin de If not SQLQSource.Eof
        SQLQSource.Close;

    //-- Table SOURCES_RECORD 2-d'événements individuels
        lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['SOURCES_RECORD '+rs_Caption_On_persons]);
        Application.ProcessMessages;
        SQLQSource.SQL.Text:='select count(*)';
        SQLQSource.SQL.Add('from sources_record s where s.type_table=''I''');
        SQLQSource.SQL.Add('and exists(select * from evenements_ind e');
        SQLQSource.SQL.Add('inner join individu i on i.cle_fiche=e.ev_ind_kle_fiche');
        SQLQSource.SQL.Add('and i.kle_dossier='+dossiers);
        SQLQSource.SQL.Add('where e.ev_ind_clef=s.data_id)');
        SQLQSource.ExecQuery;
        NbrEnr:=SQLQSource.Fields[0].AsInteger;
        SQLQSource.Close;
        SQLQSource.SQL.Strings[0]:='select s.*';
        SQLQSource.ExecQuery;
        i:=0;
        if not SQLQSource.Eof then
        begin
          SQLQCible.SQL.Text:='execute block('
            +'id integer=:id'//id du source_record d'origine
            +',data_id integer=:data_id'//ev ind d'origine (puis cible)
            +',SOURCE_PAGE varchar(248)=:SOURCE_PAGE'
            +',EVEN varchar(15)=:EVEN'
            +',EVEN_ROLE varchar(25)=:EVEN_ROLE'
            +',DATA_EVEN varchar(90)=:DATA_EVEN'
            +',DATA_EVEN_PERIOD varchar(35)=:DATA_EVEN_PERIOD'
            +',DATA_EVEN_PLAC varchar(120)=:DATA_EVEN_PLAC'
            +',DATA_AGNC varchar(120)=:DATA_AGNC'
            +',QUAY integer=:QUAY'
            +',AUTH blob=:AUTH'
            +',TITL blob=:TITL'
            +',ABR varchar(60)=:ABR'
            +',PUBL blob=:PUBL'
            +',TEXTE blob=:TEXTE'
            +',USER_REF blob=:USER_REF'
            +',RIN varchar(12)=:RIN'
            +',CHANGE_NOTE blob=:CHANGE_NOTE'
            +')as'
            +' declare variable decujus integer;'
            +'begin'
            +' select DECUJUS from TQ_CONSANG where ID=3 AND INDI=:DATA_ID into :data_id;'
            +'if(data_id>0)then begin'
            +' insert into SOURCES_RECORD ('
            +'ID'
            +',DATA_ID'
            +',SOURCE_PAGE'
            +',EVEN'
            +',EVEN_ROLE'
            +',DATA_EVEN'
            +',DATA_EVEN_PERIOD'
            +',DATA_EVEN_PLAC'
            +',DATA_AGNC'
            +',QUAY'
            +',AUTH'
            +',TITL'
            +',ABR'
            +',PUBL'
            +',TEXTE'
            +',USER_REF'
            +',RIN'
            +',CHANGE_DATE'
            +',CHANGE_NOTE'
            +',KLE_DOSSIER'
            +',TYPE_TABLE'
            +')'
            +' values('
            +'gen_id(sources_record_id_gen,1)'
            +',:DATA_ID'
            +',:SOURCE_PAGE'
            +',:EVEN'
            +',:EVEN_ROLE'
            +',:DATA_EVEN'
            +',:DATA_EVEN_PERIOD'
            +',:DATA_EVEN_PLAC'
            +',:DATA_AGNC'
            +',:QUAY'
            +',:AUTH'
            +',:TITL'
            +',:ABR'
            +',:PUBL'
            +',:TEXTE'
            +',:USER_REF'
            +',:RIN'
            +',''now'''
            +',:CHANGE_NOTE'
            +','+dossierc
            +',''I'''
            +')returning id into :decujus;'
            +'insert into tq_consang(id,indi,decujus)values(6,:id,:decujus);'
            +'end'
            +' end';

          while (not SQLQSource.eof) do
          begin
            inc(i);
            if (i=NbrEnr)or(i mod 10=0) then
            begin
              lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['SOURCES_RECORD '+rs_Caption_On_persons,IntToStr(I),IntToStr(NbrEnr)]);
              Application.ProcessMessages;
            end;

            SQLQCible.ParamByName('ID').AsInteger:=SQLQSource.FieldByName('ID').AsInteger;
            SQLQCible.ParamByName('DATA_ID').AsInteger:=SQLQSource.FieldByName('DATA_ID').AsInteger;
            for p:=2 to SQLQCible.Params.Count-1 do
              SQLQCible.Params[p].Clear;
            if SQLQSource.FieldByName('SOURCE_PAGE').AsString>'' then
              SQLQCible.ParamByName('SOURCE_PAGE').AsString:=SQLQSource.FieldByName('SOURCE_PAGE').AsString;
            if SQLQSource.FieldByName('EVEN').AsString>'' then
              SQLQCible.ParamByName('EVEN').AsString:=SQLQSource.FieldByName('EVEN').AsString;
            if SQLQSource.FieldByName('EVEN_ROLE').AsString>'' then
              SQLQCible.ParamByName('EVEN_ROLE').AsString:=SQLQSource.FieldByName('EVEN_ROLE').AsString;
            if SQLQSource.FieldByName('DATA_EVEN').AsString>'' then
              SQLQCible.ParamByName('DATA_EVEN').AsString:=SQLQSource.FieldByName('DATA_EVEN').AsString;
            if SQLQSource.FieldByName('DATA_EVEN_PERIOD').AsString>'' then
              SQLQCible.ParamByName('DATA_EVEN_PERIOD').AsString:=SQLQSource.FieldByName('DATA_EVEN_PERIOD').AsString;
            if SQLQSource.FieldByName('DATA_EVEN_PLAC').AsString>'' then
              SQLQCible.ParamByName('DATA_EVEN_PLAC').AsString:=SQLQSource.FieldByName('DATA_EVEN_PLAC').AsString;
            if SQLQSource.FieldByName('DATA_AGNC').AsString>'' then
              SQLQCible.ParamByName('DATA_AGNC').AsString:=SQLQSource.FieldByName('DATA_AGNC').AsString;
            if not SQLQSource.FieldByName('QUAY').IsNull then
              SQLQCible.ParamByName('QUAY').AsInteger:=SQLQSource.FieldByName('QUAY').AsInteger;

            if not SQLQSource.FieldByName('AUTH').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('AUTH').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('AUTH').LoadFromStream(tampon);
            end;

            if not SQLQSource.FieldByName('TITL').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('TITL').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('TITL').LoadFromStream(tampon);
            end;

            if SQLQSource.FieldByName('ABR').AsString>'' then
              SQLQCible.ParamByName('ABR').AsString:=SQLQSource.FieldByName('ABR').AsString;
            if not SQLQSource.FieldByName('PUBL').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('PUBL').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('PUBL').LoadFromStream(tampon);
            end;

            if not SQLQSource.FieldByName('TEXTE').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('TEXTE').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('TEXTE').LoadFromStream(tampon);
            end;

            if not SQLQSource.FieldByName('USER_REF').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('USER_REF').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('USER_REF').LoadFromStream(tampon);
            end;

            if SQLQSource.FieldByName('RIN').AsString>'' then
              SQLQCible.ParamByName('RIN').AsString:=SQLQSource.FieldByName('RIN').AsString;

            if not SQLQSource.FieldByName('CHANGE_NOTE').IsNull then
            begin
              tampon.Clear;
              SQLQSource.FieldByName('CHANGE_NOTE').SaveToStream(tampon);
              if tampon.Size>0 then
                SQLQCible.ParamByName('CHANGE_NOTE').LoadFromStream(tampon);
            end;

            try
              SQLQCible.ExecQuery;
            except
              on E:EIBError do
              begin
                MyMessageDlg(rs_Error_source_transfer
                  +SQLQSource.FieldByName('ID').AsString
                  +_CRLF+_CRLF+E.Message,mtError, [mbCancel],Self);
                dm.IBT_base.RollbackRetaining;
                exit;
              end;
            end;

            SQLQSource.Next;
          end;

          SQLQCible.Close;
        end;// fin de If not SQLQSource.Eof

        SQLQSource.Close;
      finally
        tampon.Free;
      end;
    end
    else
    begin
      MyMessageDlg(rs_Error_sources_transfer,mtError, [mbCancel],Self);
    end;

  //test pour erreurs dues à table MEDIA_POINTEURS absente
    if TestTableChamp('MEDIA_POINTEURS','MP_CLEF') then
    begin
      bNouvVersion:=TestTableChamp('MEDIA_POINTEURS','MP_POSITION');
    //-- Table MEDIA_POINTEURS 1-sur individus
      lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['MEDIA_POINTEURS '+rs_Caption_On_persons]);
      Application.ProcessMessages;
      SQLQSource.SQL.Clear;
      SQLQSource.SQL.Text:='select count(*)';
      SQLQSource.SQL.Add('FROM MEDIA_POINTEURS p WHERE p.MP_TYPE_IMAGE=''I''');
      SQLQSource.SQL.Add('OR p.MP_TYPE_IMAGE IS NULL');
      SQLQSource.SQL.Add('and exists(SELECT * FROM INDIVIDU where cle_fiche=p.mp_cle_individu');
      SQLQSource.SQL.Add('and KLE_DOSSIER='+dossiers+')');
      SQLQSource.SQL.Add('and exists(select * from multimedia where multi_clef=p.mp_media');
      SQLQSource.SQL.Add('and MULTI_DOSSIER='+dossiers+')');
      SQLQSource.ExecQuery;
      NbrEnr:=SQLQSource.Fields[0].AsInteger;
      SQLQSource.Close;
      SQLQSource.SQL.Strings[0]:='select p.*';
      SQLQSource.ExecQuery;

      if not SQLQSource.Eof then
      begin
        I:=0;
        SQLQCible.SQL.Text:='execute block('
          +'MP_MEDIA integer=:MP_MEDIA'
          +',MP_CLE_INDIVIDU integer=:MP_CLE_INDIVIDU'
          +',MP_IDENTITE integer=:MP_IDENTITE'
          +',MP_POSITION integer=:MP_POSITION'
          +') as'
          +' begin'
          +' select DECUJUS from TQ_CONSANG where ID=2 AND INDI=:MP_MEDIA into :mp_media;'
          +' select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:MP_CLE_INDIVIDU into :MP_CLE_INDIVIDU;'
          +'if ((mp_media>0)and(mp_cle_individu>0))then begin'
          +' insert into MEDIA_POINTEURS ('
          +'MP_CLEF'
          +',MP_MEDIA'
          +',MP_CLE_INDIVIDU'
          +',MP_POINTE_SUR'
          +',MP_TABLE'
          +',MP_IDENTITE'
          +',MP_KLE_DOSSIER'
          +',MP_TYPE_IMAGE'
          +',MP_POSITION'
          +')'
          +'values('
          +'gen_id(biblio_pointeurs_id_gen,1)'
          +',:MP_MEDIA'
          +',:MP_CLE_INDIVIDU'
          +',:MP_CLE_INDIVIDU'
          +',''I'''
          +',:MP_IDENTITE'
          +','+dossierc
          +',''I'''
          +',:MP_POSITION'
          +');'
          +'end'
          +' end';

        while not SQLQSource.eof do
        begin
          inc(i);
          if (i=NbrEnr)or(i mod 10=0) then
          begin
            lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['MEDIA_POINTEURS '+rs_Caption_On_persons,IntToStr(I),IntToStr(NbrEnr)]);
            Application.ProcessMessages;
          end;
          SQLQCible.ParamByName('MP_MEDIA').AsInteger:=SQLQSource.FieldByName('MP_MEDIA').AsInteger;
          SQLQCible.ParamByName('MP_CLE_INDIVIDU').AsInteger:=SQLQSource.FieldByName('MP_CLE_INDIVIDU').AsInteger;

          if SQLQSource.FieldByName('MP_IDENTITE').AsInteger=0 then
            SQLQCible.ParamByName('MP_IDENTITE').Clear
          else
            SQLQCible.ParamByName('MP_IDENTITE').AsInteger:=SQLQSource.FieldByName('MP_IDENTITE').AsInteger;

          if bNouvVersion then
            SQLQCible.ParamByName('MP_POSITION').AsInteger:=SQLQSource.FieldByName('MP_POSITION').AsInteger
          else
            SQLQCible.ParamByName('MP_POSITION').AsInteger:=0;

          SQLQCible.ExecQuery;
          SQLQSource.Next;
        end;//de while not SQLQSource.eof
        SQLQCible.Close;
      end;//de If not SQLQSource.Eof

      SQLQSource.Close;

    //-- Table MEDIA_POINTEURS 2-sur actes d'événements individuels
      lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['MEDIA_POINTEURS '+rs_Caption_On_persons_events]);
      Application.ProcessMessages;
      SQLQSource.SQL.Clear;
      SQLQSource.SQL.Add('select count(*)');
      SQLQSource.SQL.Add('FROM MEDIA_POINTEURS p WHERE p.MP_TYPE_IMAGE=''A''');
      SQLQSource.SQL.Add('AND p.MP_TABLE=''I''');
      SQLQSource.SQL.Add('and exists(SELECT * FROM INDIVIDU where cle_fiche=p.mp_cle_individu');
      SQLQSource.SQL.Add('and KLE_DOSSIER='+dossiers+')');
      SQLQSource.SQL.Add('and exists(select * from multimedia where multi_clef=p.mp_media');
      SQLQSource.SQL.Add('and MULTI_DOSSIER='+dossiers+')');
      SQLQSource.SQL.Add('and exists(select * from evenements_ind e');
      SQLQSource.SQL.Add('inner join individu i on i.cle_fiche=e.ev_ind_kle_fiche');
      SQLQSource.SQL.Add('and i.kle_dossier='+dossiers);
      SQLQSource.SQL.Add('where e.ev_ind_clef=p.MP_POINTE_SUR)');
      SQLQSource.ExecQuery;
      NbrEnr:=SQLQSource.Fields[0].AsInteger;
      SQLQSource.Close;
      SQLQSource.SQL.Strings[0]:='select p.*';
      SQLQSource.ExecQuery;

      if not SQLQSource.Eof then
      begin
        SQLQCible.SQL.Text:='execute block('
          +'MP_MEDIA integer=:MP_MEDIA'
          +',MP_CLE_INDIVIDU integer=:MP_CLE_INDIVIDU'
          +',MP_POINTE_SUR integer=:MP_POINTE_SUR'
          +',MP_IDENTITE integer=:MP_IDENTITE'
          +',MP_POSITION integer=:MP_POSITION'
          +') as'
          +' begin'
          +' select DECUJUS from TQ_CONSANG where ID=2 AND INDI=:MP_MEDIA into :mp_media;'
          +' select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:MP_CLE_INDIVIDU into :MP_CLE_INDIVIDU;'
          +' select DECUJUS from TQ_CONSANG where ID=3 AND INDI=:MP_POINTE_SUR into :MP_POINTE_SUR;'
          +'if ((mp_media>0)and(mp_cle_individu>0)and(MP_POINTE_SUR>0))then begin'
          +' insert into MEDIA_POINTEURS ('
          +'MP_CLEF'
          +',MP_MEDIA'
          +',MP_CLE_INDIVIDU'
          +',MP_POINTE_SUR'
          +',MP_TABLE'
          +',MP_IDENTITE'
          +',MP_KLE_DOSSIER'
          +',MP_TYPE_IMAGE'
          +',MP_POSITION'
          +')'
          +' values('
          +'gen_id(biblio_pointeurs_id_gen,1)'
          +',:MP_MEDIA'
          +',:MP_CLE_INDIVIDU'
          +',:MP_POINTE_SUR'
          +',''I'''
          +',:MP_IDENTITE'
          +','+dossierc
          +',''A'''
          +',:MP_POSITION'
          +');'
          +'end'
          +' end';
        i:=0;

        while not SQLQSource.eof do
        begin
          inc(i);
          if (i=NbrEnr)or(i mod 10=0) then
          begin
            lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['MEDIA_POINTEURS '+rs_Caption_On_persons_events,IntToStr(I),IntToStr(NbrEnr)]);
            Application.ProcessMessages;
          end;

          SQLQCible.ParamByName('MP_MEDIA').AsInteger:=SQLQSource.FieldByName('MP_MEDIA').AsInteger;
          SQLQCible.ParamByName('MP_CLE_INDIVIDU').AsInteger:=SQLQSource.FieldByName('MP_CLE_INDIVIDU').AsInteger;
          SQLQCible.ParamByName('MP_POINTE_SUR').AsInteger:=SQLQSource.FieldByName('MP_POINTE_SUR').AsInteger;

          if SQLQSource.FieldByName('MP_IDENTITE').AsInteger=0 then
            SQLQCible.ParamByName('MP_IDENTITE').Clear
          else
            SQLQCible.ParamByName('MP_IDENTITE').AsInteger:=SQLQSource.FieldByName('MP_IDENTITE').AsInteger;

          if bNouvVersion then
            SQLQCible.ParamByName('MP_POSITION').AsInteger:=SQLQSource.FieldByName('MP_POSITION').AsInteger
          else
            SQLQCible.ParamByName('MP_POSITION').AsInteger:=0;

          SQLQCible.ExecQuery;
          SQLQSource.Next;
        end;//de while not SQLQSource.eof
        SQLQCible.Close;
      end;// fin de If not SQLQSource.Eof
      SQLQSource.Close;

    //-- Table MEDIA_POINTEURS 3-sur actes d'événements familiaux
      lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['MEDIA_POINTEURS '+rs_Caption_On_family_events]);
      Application.ProcessMessages;
      SQLQSource.SQL.Clear;
      SQLQSource.SQL.Add('select count(*)');
      SQLQSource.SQL.Add('FROM MEDIA_POINTEURS p WHERE p.MP_TYPE_IMAGE=''A''');
      SQLQSource.SQL.Add('AND p.MP_TABLE=''F''');
      SQLQSource.SQL.Add('and exists(SELECT * FROM INDIVIDU where cle_fiche=p.mp_cle_individu');
      SQLQSource.SQL.Add('and KLE_DOSSIER='+dossiers+')');
      SQLQSource.SQL.Add('and exists(select * from multimedia where multi_clef=p.mp_media');
      SQLQSource.SQL.Add('and MULTI_DOSSIER='+dossiers+')');
      SQLQSource.ExecQuery;
      NbrEnr:=SQLQSource.Fields[0].AsInteger;
      SQLQSource.Close;
      SQLQSource.SQL.Strings[0]:='select p.*';
      SQLQSource.ExecQuery;

      if not SQLQSource.Eof then
      begin
        SQLQCible.SQL.Text:='execute block('
          +'MP_MEDIA integer=:MP_MEDIA'
          +',MP_CLE_INDIVIDU integer=:MP_CLE_INDIVIDU'
          +',MP_POINTE_SUR integer=:MP_POINTE_SUR'
          +',MP_IDENTITE integer=:MP_IDENTITE'
          +',MP_POSITION integer=:MP_POSITION'
          +') as'
          +' begin'
          +' select DECUJUS from TQ_CONSANG where ID=2 AND INDI=:MP_MEDIA into :mp_media;'
          +' select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:MP_CLE_INDIVIDU into :MP_CLE_INDIVIDU;'
          +' select DECUJUS from TQ_CONSANG where ID=5 AND INDI=:MP_POINTE_SUR into :MP_POINTE_SUR;'
          +'if ((mp_media>0)and(mp_cle_individu>0)and(MP_POINTE_SUR>0))then begin'
          +' insert into MEDIA_POINTEURS ('
          +'MP_CLEF'
          +',MP_MEDIA'
          +',MP_CLE_INDIVIDU'
          +',MP_POINTE_SUR'
          +',MP_TABLE'
          +',MP_IDENTITE'
          +',MP_KLE_DOSSIER'
          +',MP_TYPE_IMAGE'
          +',MP_POSITION'
          +')'
          +' values('
          +'gen_id(biblio_pointeurs_id_gen,1)'
          +',:MP_MEDIA'
          +',:MP_CLE_INDIVIDU'
          +',:MP_POINTE_SUR'
          +',''F'''
          +',:MP_IDENTITE'
          +','+dossierc
          +',''A'''
          +',:MP_POSITION'
          +');'
          +'end'
          +' end';
        i:=0;

        while not SQLQSource.eof do
        begin
          inc(i);
          if (i=NbrEnr)or(i mod 10=0) then
          begin
            lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['MEDIA_POINTEURS '+rs_Caption_On_family_events,IntToStr(I),IntToStr(NbrEnr)]);
            Application.ProcessMessages;
          end;

          SQLQCible.ParamByName('MP_MEDIA').AsInteger:=SQLQSource.FieldByName('MP_MEDIA').AsInteger;
          SQLQCible.ParamByName('MP_CLE_INDIVIDU').AsInteger:=SQLQSource.FieldByName('MP_CLE_INDIVIDU').AsInteger;
          SQLQCible.ParamByName('MP_POINTE_SUR').AsInteger:=SQLQSource.FieldByName('MP_POINTE_SUR').AsInteger;

          if SQLQSource.FieldByName('MP_IDENTITE').AsInteger=0 then
            SQLQCible.ParamByName('MP_IDENTITE').Clear
          else
            SQLQCible.ParamByName('MP_IDENTITE').AsInteger:=SQLQSource.FieldByName('MP_IDENTITE').AsInteger;

          if bNouvVersion then
            SQLQCible.ParamByName('MP_POSITION').AsInteger:=SQLQSource.FieldByName('MP_POSITION').AsInteger
          else
            SQLQCible.ParamByName('MP_POSITION').AsInteger:=0;

          SQLQCible.ExecQuery;
          SQLQSource.Next;
        end;//de while not SQLQSource.eof
        SQLQCible.Close;
      end;// fin de If not SQLQSource.Eof
      SQLQSource.Close;

    //-- Table MEDIA_POINTEURS 4-sur sources
      lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['MEDIA_POINTEURS '+rs_Caption_On_sources]);
      Application.ProcessMessages;
      SQLQSource.SQL.Clear;
      SQLQSource.SQL.Add('select count(*)');
      SQLQSource.SQL.Add(' FROM MEDIA_POINTEURS p WHERE p.MP_TYPE_IMAGE=''F''');
      SQLQSource.SQL.Add('and exists(SELECT * FROM INDIVIDU where cle_fiche=p.mp_cle_individu');
      SQLQSource.SQL.Add('and KLE_DOSSIER='+dossiers+')');
      SQLQSource.SQL.Add('and exists(select * from multimedia where multi_clef=p.mp_media');
      SQLQSource.SQL.Add('and MULTI_DOSSIER='+dossiers+')');
      SQLQSource.ExecQuery;
      NbrEnr:=SQLQSource.Fields[0].AsInteger;
      SQLQSource.Close;
      SQLQSource.SQL.Strings[0]:='select p.*';
      SQLQSource.ExecQuery;

      if not SQLQSource.Eof then
      begin
        SQLQCible.SQL.Text:='execute block('
          +'MP_MEDIA integer=:MP_MEDIA'
          +',MP_CLE_INDIVIDU integer=:MP_CLE_INDIVIDU'
          +',MP_POINTE_SUR integer=:MP_POINTE_SUR'
          +',MP_IDENTITE integer=:MP_IDENTITE'
          +',MP_POSITION integer=:MP_POSITION'
          +') as'
          +' begin'
          +' select DECUJUS from TQ_CONSANG where ID=2 AND INDI=:MP_MEDIA into :mp_media;'
          +' select DECUJUS from TQ_CONSANG where ID=1 AND INDI=:MP_CLE_INDIVIDU into :MP_CLE_INDIVIDU;'
          +' select DECUJUS from TQ_CONSANG where ID=6 AND INDI=:MP_POINTE_SUR into :MP_POINTE_SUR;'
          +'if ((mp_media>0)and(mp_cle_individu>0)and(MP_POINTE_SUR>0))then begin'
          +' insert into MEDIA_POINTEURS ('
          +'MP_CLEF'
          +',MP_MEDIA'
          +',MP_CLE_INDIVIDU'
          +',MP_POINTE_SUR'
          +',MP_TABLE'
          +',MP_IDENTITE'
          +',MP_KLE_DOSSIER'
          +',MP_TYPE_IMAGE'
          +',MP_POSITION'
          +')'
          +' values('
          +'gen_id(biblio_pointeurs_id_gen,1)'
          +',:MP_MEDIA'
          +',:MP_CLE_INDIVIDU'
          +',:MP_POINTE_SUR'
          +',''F'''
          +',:MP_IDENTITE'
          +','+dossierc
          +',''F'''
          +',:MP_POSITION'
          +');'
          +'end'
          +' end';
        i:=0;

        while not SQLQSource.eof do
        begin
          inc(i);
          if (i=NbrEnr)or(i mod 10=0) then
          begin
            lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['MEDIA_POINTEURS '+rs_Caption_On_sources,IntToStr(I),IntToStr(NbrEnr)]);
            Application.ProcessMessages;
          end;
          SQLQCible.ParamByName('MP_MEDIA').AsInteger:=SQLQSource.FieldByName('MP_MEDIA').AsInteger;
          SQLQCible.ParamByName('MP_CLE_INDIVIDU').AsInteger:=SQLQSource.FieldByName('MP_CLE_INDIVIDU').AsInteger;
          SQLQCible.ParamByName('MP_POINTE_SUR').AsInteger:=SQLQSource.FieldByName('MP_POINTE_SUR').AsInteger;

          if SQLQSource.FieldByName('MP_IDENTITE').AsInteger=0 then
            SQLQCible.ParamByName('MP_IDENTITE').Clear
          else
            SQLQCible.ParamByName('MP_IDENTITE').AsInteger:=SQLQSource.FieldByName('MP_IDENTITE').AsInteger;

          if bNouvVersion then
            SQLQCible.ParamByName('MP_POSITION').AsInteger:=SQLQSource.FieldByName('MP_POSITION').AsInteger
          else
            SQLQCible.ParamByName('MP_POSITION').AsInteger:=0;

          SQLQCible.ExecQuery;
          SQLQSource.Next;
        end;//de while not SQLQSource.eof
        SQLQCible.Close;
      end;// fin de If not SQLQSource.Eof
      SQLQSource.Close;
    end
    else
    begin
      MyMessageDlg(rs_Error_Table_MEDIA_POINTEURS,mtWarning, [mbOK],Self);
    end;

  //mise en test pour erreurs dues à table NOM_ATTACHEMENT absente
    if TestTableChamp('NOM_ATTACHEMENT','ID') then
    begin
    //Table NOM_ATTACHEMENT
      lImport.Caption:=fs_RemplaceMsg(rs_Caption_Preparing_to_import_on_table,['NOM_ATTACHEMENT']);
      Application.ProcessMessages;
      SQLQSource.SQL.Text:='select count(*)';
      SQLQSource.SQL.Add('from nom_attachement t');
      SQLQSource.SQL.Add('inner join individu i on i.cle_fiche=t.id_indi');
      SQLQSource.SQL.Add('and i.kle_dossier='+dossiers);
      SQLQSource.ExecQuery;
      NbrEnr:=SQLQSource.Fields[0].AsInteger;
      SQLQSource.Close;
      SQLQSource.SQL.Strings[0]:='select t.id_indi,t.nom,t.nom_indi';
      SQLQSource.ExecQuery;
      if not SQLQSource.Eof then
      begin
        I:=0;
        SQLQCible.Close;
        SQLQCible.SQL.Text:='execute block('
          +'id_indi integer=:id_indi'
          +',nom varchar(40)=:nom'
          +',nom_indi varchar(40)=:nom_indi'
          +')as begin'
          +' select decujus from tq_consang where id=1 and indi=:id_indi into :id_indi;'
          +'if (id_indi>0) then begin'
          +' if (nom_indi>'''') then'
          +' select nom from individu where cle_fiche=:id_indi into :nom_indi;'
          +'insert into NOM_ATTACHEMENT ('
          +'id_indi'
          +',nom'
          +',nom_indi'
          +',kle_dossier'
          +')'
          +' values('
          +':id_indi'
          +',:nom'
          +',:nom_indi'
          +','+dossierc
          +');'
          +'end'
          +' end';

        while not SQLQSource.eof do
        begin
          inc(i);
          if (i=NbrEnr)or(i mod 10=0) then
          begin
            lImport.Caption:=fs_RemplaceMsg(rs_Caption_Importing_table_of_records_in_progress,['NOM_ATTACHEMENT',IntToStr(I),IntToStr(NbrEnr)]);
            Application.ProcessMessages;
          end;
          with SQLQCible do
          begin
            ParamByName('ID_INDI').AsInteger:=SQLQSource.FieldByName('ID_INDI').AsInteger;
            if SQLQSource.FieldByName('NOM').AsString>'' then
              ParamByName('NOM').AsString:=fs_FormatText(SQLQSource.FieldByName('NOM').AsString,mftUpper)
            else
              ParamByName('NOM').Clear;
            if SQLQSource.FieldByName('nom_indi').AsString>'' then
              ParamByName('nom_indi').AsString:=SQLQSource.FieldByName('nom_indi').AsString
            else
              ParamByName('nom_indi').Clear;
            ExecQuery;
          end;//de SQLQCible
          SQLQSource.Next;
        end;//de while not SQLQSource.eof
        SQLQCible.Close;
      end;//de If not SQLQSource.Eof
      SQLQSource.Close;
    end;

  //effacement de TQ_CONSANG
    lImport.Caption:=rs_Suppressing_temp_table;
    Application.ProcessMessages;
    SQLQCible.Close;
    SQLQCible.SQL.Text:='DELETE FROM TQ_CONSANG';
    try
      SQLQCible.ExecQuery;
    except
      on E:EIBError do
      begin
        ShowMessage(rs_Error_TQ_CONSANG_deleting+_CRLF+_CRLF+E.Message);
      end;
    end;
    SQLQCible.Close;

  //Mise à jour des étiquettes d'événements
    lImport.Caption:=rs_Updating_deprecated_events_sticks;
    Application.ProcessMessages;
    SQLQCible.SQL.Text:='execute procedure PROC_MAJ_TAGS';
    try
      SQLQCible.ExecQuery;
    except
      on E:EIBError do
      begin
        ShowMessage(rs_Error_updating_old_tags+_CRLF+_CRLF+E.Message);
      end;
    end;
    SQLQCible.Close;

  //clôture des dataset et mise à jour de l'affichage des Individus

    dm.doMAJTableJournal(rs_Log_Import_from_a_folder_from_base+cbBaseOrigine.Text);

    lImport.Caption:=rs_Confirm_update;
    Application.ProcessMessages;
    dm.IBT_base.CommitRetaining;
    if dm.NumDossier=StrToInt(dossierc) then
      dm.doInitLieuxFavoris;
    qIndiDestination.close;
    qIndiDestination.Open;
    gbDestination.Caption:=fs_RemplaceMsg(rs_Destination_Persons_count,[NbrIndiDossier(qIndiDestination)]);

    lImport.Caption:=rs_Import_finished;

  finally
    SQLQSource.free;
    SQLQCible.free;
    pAnime.Visible:=False;
    Animate.AnimSpeed:=0;
    Animate.Visible:=False;
    btnClose.Enabled:=True;
    screen.Cursor:=crDefault;
  end;
end;

function TFMutationBase.NbrIndiDossier(Req:TIBQuery):string;
var
  q:TIBSQL;
begin
  q:=TIBSQL.Create(self);
  try
    q.Database:=Req.Database;
    q.Transaction:=Req.Transaction;
    q.SQL.Text:='select count(*) from individu where kle_dossier=:dossier';
    q.Params[0].AsInteger:=Req.Params[0].AsInteger;
    q.ExecQuery;
    Result:=q.Fields[0].AsString;
    q.Close;
  finally
    q.Free;
  end;
end;

procedure TFMutationBase.FormDestroy(Sender: TObject);
begin
  MaDate.Free;
  MotsClesDecode.Free;
end;

end.

