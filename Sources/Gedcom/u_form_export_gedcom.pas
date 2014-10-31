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
{           2008: refonte complète par André Langlet                    }
{           Revision History                                            }
{           Date 03/01/2009      ,Author Name  André Langlet            }
{           Description                                                 }
{           Ajout des notes de l'auteur                                 }
{-----------------------------------------------------------------------}
unit u_form_export_gedcom;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt, Dialogs,DB,IBQuery,ComCtrls,ExtCtrls,
  StdCtrls,Controls,u_objet_TState, MaskEdit,u_gedcom_func,forms,
  ExtJvXPCheckCtrls, BGRASpriteAnimation,u_framework_components,
  lazutf8classes,
  u_buttons_appli, U_OnFormInfoIni,
  IBSQL,u_comp_TYLanguage, Classes;
type

  { TFExportGedcom }

  TFExportGedcom=class(TF_FormAdapt)
    cbAvecConjoints: TJvXPCheckbox;
    FWFSee: TFWFolder;
    ch_CreateSubDir: TJvXPCheckbox;
    NbNiveauxAsc: TFWSpinEdit;
    NbNiveauxDesc: TFWSpinEdit;
    Panel10: TPanel;
    Panel5: TPanel;
    PleaseWait: TBGRASpriteAnimation;
    InfosBranche1: TLabel;
    Label16: TLabel;
    Label21: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel4:TPanel;
    Panel1:TPanel;
    Panel2:TPanel;
    Notebook:TNotebook;
    page1:TPage;
    page2:TPage;
    page3:TPage;
    page4:TPage;
    page5:TPage;
    Labelaa:TLabel;
    Label17:TLabel;
    Label23:TLabel;
    Label24:TLabel;
    Label28:TLabel;
    Label30:TLabel;
    Label3:TLabel;
    Label11:TLabel;
    Label13:TLabel;
    rbJeuCarWindows:TRadioButton;
    rbJeuCarMacintosh:TRadioButton;
    rbJeuCarMSDOS:TRadioButton;
    rbJeuCarAnsel:TRadioButton;
    Label29:TLabel;
    Label5:TLabel;
    lbEportEnCours:TLabel;
    cbAscendance: TJvXPCheckbox;
    cbDescendance: TJvXPCheckbox;
    rbTout:TRadioButton;
    rbExportBranche:TRadioButton;
    panExportBranche:TPanel;
    InfosElements: TLabel;
    Label4:TLabel;
    Label9:TLabel;
    Label12:TLabel;
    Label14:TLabel;
    QIndi:TIBSQL;
    lbHeaderNom:TMaskEdit;
    lbHeaderAddr1:TMaskEdit;
    lbHeaderAddr2:TMaskEdit;
    lbHeaderAddr3:TMaskEdit;
    QChild:TIBQuery;
    QAssoEvent:TIBQuery;
    Panel7:TPanel;
    edPathFileNameGED:TMaskEdit;
    panFin:TPanel;
    Label10:TLabel;
    Panel8:TPanel;
    Panel9:TPanel;
    Image1:TImage;
    Label1:TLabel;
    lbExportOk:TLabel;
    lbHeaderTel:TMaskEdit;
    lbHeaderEMail:TMaskEdit;
    lbHeaderSiteWeb:TMaskEdit;
    Label6:TLabel;
    cbIndiquerCoord:TJvXPCheckBox;
    Label7:TLabel;
    Label8:TLabel;
    Label15:TLabel;
    Label19:TLabel;
    Label20:TLabel;
    Panel6:TPanel;
    Label18:TLabel;
    Panel3:TPanel;
    btnSelectIndiDepart:TFWOK;
    btnSelectFile:TFWLoad;
    btnPrevious:TFWPrior;
    btnNext:TFWNext;
    btnNewExport:TFWExport;
    InfosBranche: TLabel;
    SaveDialog:TSaveDialog;
    Language:TYLanguage;
    QMedia:TIBQuery;
    qSources:TIBQuery;
    chGarder:TJvXPCheckBox;
    rbCheminImages:TRadioGroup;
    IBSQLIndi:TIBSQL;
    Qsec:TIBQuery;
    QMediaIndi:TIBQuery;
    rbFormatGedcom:TRadioGroup;
    Label22:TLabel;
    LabelMedias:TLabel;
    ShapeMedias:TShape;
    Label26:TLabel;
    Label27:TLabel;
    Label25:TLabel;
    NotesAuteur:TMemo;
    cbAjouterDate:TJvXPCheckBox;
    cbImportEvent:TJvXPCheckBox;
    cbImportNotes:TJvXPCheckBox;
    cbImportSources:TJvXPCheckBox;
    cbIndisConfidentiels:TJvXPCheckBox;
    cbImportTemoins:TJvXPCheckBox;
    cbExportDomiciles:TJvXPCheckBox;
    cbExportPatronymes:TJvXPCheckBox;
    cbIdentConfidentiels:TJvXPCheckBox;
    cbPlacNotes: TJvXPCheckBox;
    rbJeuCarUtf8: TRadioButton;
    TabMedias: TTabSheet;
    procedure btnNextClick(Sender:TObject);
    procedure btnPreviousClick(Sender:TObject);
    procedure FWFSeeClick(Sender: TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormDestroy(Sender:TObject);
    procedure WizardTreeChange(Sender:TObject);
    procedure WizardTreeChanging(Sender:TObject;NewItemIndex:Integer;var AllowChange:Boolean);
    procedure rbJeuCarWindowsClick(Sender:TObject);
    procedure rbJeuCarMacintoshClick(Sender:TObject);
    procedure rbJeuCarMSDOSClick(Sender:TObject);
    procedure rbJeuCarAnselClick(Sender:TObject);
    procedure btnSelectFileClick(Sender:TObject);
    procedure btnSelectIndiDepartClick(Sender:TObject);
    procedure btnNewExportClick(Sender:TObject);
    procedure LabelMediasClick(Sender:TObject);
    procedure cbIndisConfidentielsClick(Sender:TObject);
    procedure cbImportEventClick(Sender: TObject);
    procedure rbJeuCarUtf8Click(Sender: TObject);
  private
    fTempLines,lignes:TStringlistUTF8;
    fFill:TState;
    FontColorWhite:boolean;
    fMaxNumEtapePossible:integer;
    fCleIndiDepart:integer;
    RepBaseMedia,
    FDirectoryImages,
    fNameIndiDepart:string;
    fCharSet:TSetCodageCaracteres;

    F:THandle;
    lsNomDossierImages:string;
    procedure GoToPage(aNumPage:integer);
    procedure doExportHeader;
    procedure PrepareTexte(Blob:TMemoField;List:TStringlistUTF8;TagName:string;LevelTag:integer);
    procedure PrepareMemo(Texte:string;List:TStringlistUTF8;TagName:string;LevelTag:integer);
    procedure doExportation;
  public
    property CleIndiDepart:integer read fCleIndiDepart write fCleIndiDepart;
    property NameIndiDepart:string read fNameIndiDepart write fNameIndiDepart;
    function CanSetCleFicheFromFavoris:boolean;
  end;
implementation
uses
  {$IFNDEF FPC}
  cDateTime,
  {$ELSE}
  {$ENDIF}
  u_dm,
  LazUTF8,
  u_common_resources,
  LConvEncoding,
  u_form_individu_repertoire,
  u_common_functions,
  u_common_ancestro,
  u_genealogy_context,
  fonctions_dialogs,
  fonctions_file,
  u_form_main,SysUtils,u_common_const,
  u_common_ancestro_functions, FileUtil, fonctions_string,
  Variants,fonctions_system;
{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFExportGedcom.btnNextClick(Sender:TObject);
begin
  if NoteBook.PageIndex<NoteBook.PageCount-2 then
    GoToPage(NoteBook.PageIndex+1)
  else
    doExportation;
  DoRefreshControls;
end;

procedure TFExportGedcom.btnPreviousClick(Sender:TObject);
begin
  if NoteBook.PageIndex>0 then
  begin
    GoToPage(NoteBook.PageIndex-1);
  end;
  DoRefreshControls;
end;

procedure TFExportGedcom.FWFSeeClick(Sender: TObject);
begin
  p_OpenFileOrDirectory(ExtractFileDir(edPathFileNameGED.text));
end;



procedure TFExportGedcom.GoToPage(aNumPage:integer);
begin
  fFill.Value:=true;
  try
    Notebook.PageIndex:=aNumPage;
    // Matthieu : Aucun wizard
//    WizardTree.ItemIndex:=aNumPage;
  finally
    fFill.Value:=false;
  end;
  DoRefreshControls;
end;

procedure TFExportGedcom.SuperFormRefreshControls(Sender:TObject);
begin
  if Notebook.PageIndex=0 then
  begin
    btnPrevious.visible:=false;
    btnNext.visible:=true;
    btnNext.Caption:=rs_Next;
  end
  else if Notebook.PageIndex=1 then
  begin
    btnPrevious.visible:=true;
    btnNext.visible:=true;
    btnNext.Caption:=rs_Next;
  end
  else if NoteBook.PageIndex=NoteBook.PageCount-2 then
  begin
    btnPrevious.visible:=true;
    btnNext.visible:=true;
    btnNext.Caption:=rs_Caption_Export;
  end
  else if NoteBook.PageIndex=NoteBook.PageCount-1 then
  begin
    btnPrevious.visible:=false;
    btnNext.visible:=false;
  end
  else
  begin
    btnPrevious.visible:=true;
    btnNext.visible:=true;
    btnNext.Caption:=rs_Next;
  end;
  btnNext.enabled:=fMaxNumEtapePossible>Notebook.PageIndex;
  if (rbExportBranche.checked)and(fCleIndiDepart=-1) then
    btnNext.enabled:=false;
  panFin.visible:=trim(edPathFileNameGED.text)>'';

  cbAscendance.Enabled:=rbExportBranche.checked;
  cbDescendance.Enabled:=rbExportBranche.checked;
  InfosBranche.Enabled:=rbExportBranche.checked;
  panExportBranche.enabled:=rbExportBranche.checked;
  btnSelectIndiDepart.enabled:=rbExportBranche.checked;
  btnSelectIndiDepart.Caption:=fs_RemplaceMsg(rs_Caption_Export_from_arg,[fNameIndiDepart]);
  NbNiveauxAsc.Enabled:=rbExportBranche.checked and cbAscendance.Checked;
  NbNiveauxDesc.Enabled:=rbExportBranche.checked and cbDescendance.Checked;
  cbAvecConjoints.Enabled:=NbNiveauxDesc.Enabled;
end;

procedure TFExportGedcom.SuperFormCreate(Sender:TObject);
var
  req:TIBSQL;
begin
  OnRefreshControls := SuperFormRefreshControls;
  gs_GedcomCharsetTo:=rs_charset_gedcom;
  PleaseWait.AnimatedGifToSprite(fs_getSoftImages+PLEASE_WAIT);
  Color:=gci_context.ColorLight;
  Panel3.Color:=gci_context.ColorDark;
  btnNewExport.Color:=gci_context.ColorDark;
  btnNewExport.ColorFrameFocus:=gci_context.ColorDark;
  btnNext.Color:=gci_context.ColorDark;
  btnNext.ColorFrameFocus:=gci_context.ColorDark;
  btnPrevious.Color:=gci_context.ColorDark;
  btnPrevious.ColorFrameFocus:=gci_context.ColorDark;
{  btnNewExport.NumGlyphs:=2;
  btnNext.NumGlyphs:=2;
  btnPrevious.NumGlyphs:=2;
}
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
  ShapeMedias.Hint:=rs_Hint_Full_path;
  rbCheminImages.Hint:=ShapeMedias.Hint;
  rbCheminImages.ItemIndex:=0;
  rbFormatGedcom.Hint:=rs_Hint_PLAC_stick;
  rbFormatGedcom.ItemIndex:=0;
  NotesAuteur.Text:='';
  lbHeaderNom.Text:=gci_context.Gedcom_Nom;
  lbHeaderAddr1.Text:=gci_context.Gedcom_Adr1;
  lbHeaderAddr2.Text:=gci_context.Gedcom_Adr2;
  lbHeaderAddr3.Text:=gci_context.Gedcom_Adr3;
  lbHeaderTel.Text:=gci_context.Gedcom_Tel;
  lbHeaderEMail.Text:=gci_context.Gedcom_Mail;
  lbHeaderSiteWeb.Text:=gci_context.Gedcom_Web;
  fFill:=TState.create(false);
  FontColorWhite:=true;
  fMaxNumEtapePossible:=4;
  fTempLines:=TStringlistUTF8.create;
  lignes:=TStringlistUTF8.create;
  fCharSet:=ccWindows;
  btnNewExport.visible:=false;
  InfosElements.Caption:=rs_Caption_Default_config_makes_exporting_everything;
  //personne ouverte dans la fiche détail
  fCleIndiDepart:=-1;
  fNameIndiDepart:='?';
  if dm.individu_clef<>-1 then
  begin
    req:=TIBSQL.Create(self);
    with req do
    begin
      try
        Database:=dm.ibd_BASE;
        Transaction:=dm.IBT_BASE;
        ParamCheck:=false;
        SQL.Text:='select nom||coalesce('', ''||prenom,'''') as NOM'
          +' from individu where cle_fiche='+IntToStr(dm.individu_clef);
        ExecQuery;
        if not Eof then
        begin
          fNameIndiDepart:=Fields[0].AsString;
          fCleIndiDepart:=dm.individu_clef;
        end;
      finally
        Free;
      end;
    end;
  end;
  GoToPage(0);
  DoRefreshControls;
end;

procedure TFExportGedcom.SuperFormDestroy(Sender:TObject);
begin
  if chGarder.Checked then
  begin
    gci_context.Gedcom_Nom:=lbHeaderNom.Text;
    gci_context.Gedcom_Adr1:=lbHeaderAddr1.Text;
    gci_context.Gedcom_Adr2:=lbHeaderAddr2.Text;
    gci_context.Gedcom_Adr3:=lbHeaderAddr3.Text;
    gci_context.Gedcom_Tel:=lbHeaderTel.Text;
    gci_context.Gedcom_Mail:=lbHeaderEMail.Text;
    gci_context.Gedcom_Web:=lbHeaderSiteWeb.Text;
    gci_context.ShouldSave:=true;
  end;

  fFill.free;
  fTempLines.Free;
  lignes.free;
end;

procedure TFExportGedcom.WizardTreeChange(Sender:TObject);
begin
//  WizardTree.Refresh;
end;

procedure TFExportGedcom.WizardTreeChanging(Sender:TObject;
  NewItemIndex:Integer;var AllowChange:Boolean);
begin
  if fFill.value=false then
  begin
      //peut-on changer de page ?
    if NewItemIndex<=fMaxNumEtapePossible then
    begin
      if fMaxNumEtapePossible<>1000 then
        GoToPage(NewItemIndex)
      else
        AllowChange:=false;
    end
    else
      AllowChange:=false;
    DoRefreshControls;
  end;
end;

procedure TFExportGedcom.doExportation;
var
  n:integer;
  StartTime,UnInstant:TDateTime;
  annees,mois,jours,
  heures,minutes,secondes,MSecondes:Word;
  s,sLieu,SubDir:string;
  bCPenPLAC:boolean;

  procedure cloture;
  begin
    QIndi.Close;
    QIndi.SQL.Text:='delete from tq_id';
    QIndi.ExecQuery;
    QIndi.Close;
    Qsec.Close;
    QChild.Close;
    QAssoEvent.Close;
    QMedia.Close;
    qSources.Close;
    QMediaIndi.Close;
    IBSQLIndi.Close;
    doCloseWorking;
    PleaseWait.AnimStatic:=True;
    PleaseWait.Visible:=false;
    lbExportOk.Visible:=True;
    FWFSee.Visible:=True;
    screen.cursor:=crDefault;
    lbEportEnCours.visible:=false;
    btnNewExport.visible:=true;
    btnPrevious.Visible:=false;
    btnNext.Visible:=false;
    dm.IBT_base.CommitRetaining;
    FMain.Enabled:=true;
    Application.ProcessMessages;
  end;

  procedure ExportNotePLAC(niveau:Integer;scode,code,slatitude,slongitude:string);
  begin
    if length(slatitude)>0 then
    begin
      slatitude:=StringReplace(slatitude,',','.', [rfReplaceAll,rfIgnoreCase]);
      if Copy(slatitude,1,1)='-' then
        slatitude:='S'+Copy(slatitude,2,length(slatitude))
      else
        slatitude:='N'+Copy(slatitude,1,length(slatitude));
    end;
    if length(slongitude)>0 then
    begin
      slongitude:=StringReplace(slongitude,',','.', [rfReplaceAll,rfIgnoreCase]);
      if Copy(slongitude,1,1)='-' then
        slongitude:='W'+Copy(slongitude,2,length(slongitude))
      else
        slongitude:='E'+Copy(slongitude,1,length(slongitude));
    end;
    if cbPlacNotes.Checked then
    begin
      if length(code)>0 then
       Begin
         FileWriteLn(F,ConversionToChaine(IntToStr(niveau)+' NOTE '+scode+' '+code,fCharSet));
       end;
    end;
    if (length(slatitude)>0)and(length(slongitude)>0) then
    begin //ajout des latitudes et longitudes au format version 5.5.1
      FileWriteLn(F,ConversionToChaine(IntToStr(niveau)+' MAP',fCharSet));
      FileWriteLn(F,ConversionToChaine(IntToStr(niveau+1)+' LATI '+slatitude,fCharSet));
      FileWriteLn(F,ConversionToChaine(IntToStr(niveau+1)+' LONG '+slongitude,fCharSet));
    end;
  end;

  // Exporte Medias of indivdual or family
  // need an TIBQuery for BlobField
  procedure ExporteMedias(const niveau:integer;const QMedia:TIBQuery;const QIndisInfos:TIBSQL;const IsFamily:Boolean);
  var
    n:integer;
    Extension,
    s,s1,AFile:string;
  begin
    if rbCheminImages.ItemIndex<3 then
    begin
      with QMedia do
      begin
        while not EOF do
        begin
          if rbCheminImages.ItemIndex=0
            then s1:=FieldByName('MULTI_PATH').AsString
            else s1:=lsNomDossierImages+'\'+FieldByName('MULTI_NOM').AsString;
          Extension:=LowerCase(ExtractFileExt(s1));
          if IsFamily
            Then
             begin
               AFile:=fs_TextToFileName(fs_RemplaceMsg(rs_and,[fs_getNameAndSurName(True,QIndisInfos.FieldByName('NOM_MARI').AsString, QIndisInfos.FieldByName('PRENOM_MARI').AsString),
                                                               fs_getNameAndSurName(True,QIndisInfos.FieldByName('NOM_FEMME').AsString, QIndisInfos.FieldByName('PRENOM_FEMME').AsString)]));
               if ch_createsubdir.Checked Then
                Afile:=fs_TextToFileName(QIndisInfos.FieldByName('NOM_MARI').AsString)+DirectorySeparator+Afile;
               AFile:=Afile +'-'+QIndisInfos.FieldByName('union_clef').AsString;

             end
            Else
             Begin
               AFile:=fs_TextToFileName(fs_getNameAndSurName(True,QIndisInfos.FieldByName(IBQ_NOM).AsString, QIndisInfos.FieldByName(IBQ_PRENOM).AsString));
               if ch_createsubdir.Checked Then
                 Afile:=fs_TextToFileName(QIndisInfos.FieldByName(IBQ_NOM).AsString)+DirectorySeparator+Afile;
               AFile:=Afile +'-'+QIndisInfos.FieldByName('CLE_FICHE').AsString;
             end;
          if dm.doExportImage ( QMedia, RepBaseMedia,FDirectoryImages,Extension,AFile,Integer(rbCheminImages.ItemIndex<>1), False, True, True )
            and ((rbCheminImages.ItemIndex=0)
            and(Length(FieldByName('MULTI_PATH').AsString)>0))
            or((rbCheminImages.ItemIndex>0)
            and(length(FieldByName('MULTI_NOM').AsString)>0)) then
          begin
            FileWriteLn(F,ConversionToChaine(IntToStr(niveau)+' OBJE',fCharSet));
            if Length(Extension)>0 then
              FileWriteLn(F,ConversionToChaine(IntToStr(niveau+1)+' FORM '+RightStr(Extension,2),fCharSet));
            s:=trim(FieldByName('MULTI_INFOS').AsString);
            if Length(s)>0 then
              FileWriteLn(F,ConversionToChaine(IntToStr(niveau+1)+' TITL '+s,fCharSet));
            FileWriteLn(F,ConversionToChaine(IntToStr(niveau+1)+' FILE '+Subdir+AFile,fCharSet));
            s:=trim(FieldByName('MULTI_MEMO').AsString);
            if Length(s)>0 then
            begin
              PrepareTexte(TMemoField(FieldByName('MULTI_MEMO')),lignes,'NOTE',niveau+1);
              if lignes.count>0 then
                for n:=0 to lignes.count-1 do
                  FileWriteLn(F,ConversionToChaine(Lignes[n],fCharSet));
            end;
            if QMedia.FieldByName('MP_IDENTITE').AsInteger=1 then
              FileWriteLn(F,ConversionToChaine(IntToStr(niveau+1)+' _IDEN 1',fCharSet));
            if QMedia.FieldByName('MP_POSITION').AsInteger>0 then
              FileWriteLn(F,ConversionToChaine(IntToStr(niveau+1)+' _POI '
                +QMedia.FieldByName('MP_POSITION').AsString,fCharSet));
          end;
          Next;
        end;//de while not eof
        Close;
      end;//de with QMedia do
    end;
  end;
  procedure p_Finished;
  var Duree: TDateTime;
  Begin
    Duree:=now-StartTime;
    DecodeTime(duree, heures, minutes, secondes, MSecondes);
    Application.ProcessMessages;
    MyMessageDlg(fs_RemplaceMsg(rs_Info_Export_is_a_success_in_hour_minutes_seconds,
      [inttostr(heures),inttostr(minutes),inttostr(secondes)])
      ,mtInformation, [mbOK]);
  end;
begin
  n:=Lastdelimiter(DirectorySeparator,FDirectoryImages);
  Subdir:=copy(FDirectoryImages,n+1,length(FDirectoryImages)-n)+'/';
  if ( rbCheminImages.ItemIndex > 0 )
  and DirectoryExistsUTF8(FDirectoryImages)
    Then
     fb_EraseDir(FDirectoryImages,True);
  //initialisations
  StartTime:=Now;
  GoToPage(5);//On change de page
  DoRefreshControls;
  screen.cursor:=crHourGlass;
  FMain.Enabled:=false;
  doShowWorking(rs_Wait_Preparing_export+_CRLF+rs_Please_Wait,true);
  lbExportOk.Visible:=False;
  FWFSee.Visible:=False;
  PleaseWait.Visible:=true;
  PleaseWait.AnimStatic:=True;
  bCPenPLAC:=(rbFormatGedcom.ItemIndex=0);
  //-----------------------------------------------------------------
  //mise à jour des tags spéciaux
  try
    IBSQLIndi.Close;
    IBSQLIndi.SQL.Clear;
    IBSQLIndi.ParamCheck:=false;
    IBSQLIndi.SQL.Add('execute procedure proc_maj_tags');
    IBSQLIndi.ExecQuery;
  except
    cloture;
    IBSQLIndi.Close;
    IBSQLIndi.SQL.Clear;
    MyMessageDlg(rs_Info_Export_has_fallen_before_updating_database
      ,mtInformation, [mbOK]);
    exit;
  end;
  //sélection des éléments à exporter
  try
    //mise dans la table temporaire TQ_ID des objets à exporter
    //l'identifiant est dans id2
    //id1=1 pour les individus
    //id1=2 pour les conjoints
    //id1=3 pour les témoins
    //id1=4 pour les sources
    //id1=5 pour les médias
    //id1=6 pour les familles avec événements familiaux, le mari et la femme sont présents
    //id1=7 pour les familles sans événements familiaux, seul le père d'un individu sélectionné est présent
    //id1=8 pour les familles sans événements familiaux, seule la mère d'un individu sélectionné est présente
    IBSQLIndi.Close;
    IBSQLIndi.SQL.Clear;
    IBSQLIndi.SQL.Add('execute block as'
      +' declare variable id integer;'
      +' begin');
    IBSQLIndi.SQL.Add('delete from tq_id;');//vide la table temporaire
    if rbTout.checked then
    begin// mettre tous les individus dans la table temporaire
      IBSQLIndi.SQL.Add('insert into tq_id (id1,id2)'
        +' select 1,cle_fiche'
        +' from individu'
        +' where kle_dossier='+IntToStr(dm.NumDossier));
      if not cbIndisConfidentiels.Checked then
        IBSQLIndi.SQL.Add('and bin_and(ind_confidentiel,'+_s_IndiConf+') is distinct from 1');
      IBSQLIndi.SQL.Add(';');
    end
    else
    begin
      if cbDescendance.checked then
      begin// mettre les descendants dans la table temporaire
        IBSQLIndi.SQL.Add('insert into tq_id (id1,id2)'
          +' select 1,t.tq_cle_fiche'
          +' from proc_tq_descendance('
          +IntToStr(fCleIndiDepart)
          +','+IntToStr(NbNiveauxDesc.Value)+',0,0) t');
        if not cbIndisConfidentiels.Checked then
          IBSQLIndi.SQL.Add('where (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=t.tq_cle_fiche)'
            +' is distinct from 1');
        IBSQLIndi.SQL.Add(';');
        if cbAvecConjoints.Checked then
        begin
          //ajouter les femmes
          IBSQLIndi.SQL.Add('for select u.union_femme'
            +' from tq_id t'
            +' inner join t_union u'
            +' on (u.union_mari=t.id2 and u.union_femme is not null)');
          if not cbIndisConfidentiels.Checked then
            IBSQLIndi.SQL.Add('where (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=u.union_femme)'
              +' is distinct from 1');
          IBSQLIndi.SQL.Add('into :id'
            +' do'
            +' insert into tq_id (id1,id2)'
            +' select 2,:id from rdb$database'
            +' where not exists (select 1 from tq_id where id2=:id);');
          // puis les maris
          IBSQLIndi.SQL.Add('for select u.union_mari'
            +' from tq_id t'
            +' inner join t_union u'
            +' on (u.union_femme=t.id2 and u.union_mari is not null)'
            +' where t.id1=1');
          if not cbIndisConfidentiels.Checked then
            IBSQLIndi.SQL.Add('and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=u.union_mari)'
              +' is distinct from 1');
          IBSQLIndi.SQL.Add('into :id'
            +' do'
            +' insert into tq_id (id1,id2)'
            +' select 2,:id from rdb$database'
            +' where not exists (select * from tq_id where id2=:id);');
        end;
      end;
      if cbAscendance.checked then
      begin// ajouter les ascendants
        IBSQLIndi.SQL.Add('for select t.tq_cle_fiche'
          +' from proc_tq_Ascendance('
          +IntToStr(fCleIndiDepart)
          +','+IntToStr(NbNiveauxAsc.Value)
          +',0,0) t');
        if not cbIndisConfidentiels.Checked then
          IBSQLIndi.SQL.Add('where (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=t.tq_cle_fiche)'
            +' is distinct from 1');
        IBSQLIndi.SQL.Add('into :id'
          +' do'
          +' insert into tq_id (id1,id2)'
          +' select 1,:id from rdb$database'
          +' where not exists (select 1 from tq_id where id2=:id);');
      end;
      if cbImportEvent.Checked and cbImportTemoins.Checked then
      begin// ajouter les témoins d'événements individuels
        IBSQLIndi.SQL.Add('for select a.assoc_kle_associe'
          +' from t_associations a'
          +' inner join evenements_ind e on e.ev_ind_clef=a.assoc_evenement'
          +' inner join ref_evenements on ref_eve_lib_court=e.ev_ind_type and ref_eve_obligatoire=1'
          +'   and ref_eve_langue='''+gci_context.Langue+''''
          +' inner join tq_id t on t.id1<3'
          +'                   and t.id2=a.assoc_kle_ind'
          +' where a.assoc_table=''I''');
        if (not cbIndisConfidentiels.Checked)or(not cbIdentConfidentiels.Checked) then
          IBSQLIndi.SQL.Add('and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=a.assoc_kle_associe)'
            +' is distinct from 1');
        IBSQLIndi.SQL.Add('into :id'
          +' do'
          +' insert into tq_id (id1,id2)'
          +' select 3,:id from rdb$database'
          +' where not exists (select 1 from tq_id where id2=:id);');
            // puis ceux d'événements familiaux
        IBSQLIndi.SQL.Add('for select a.assoc_kle_associe'
          +' from t_associations a'
          +' inner join evenements_fam f on f.ev_fam_clef=a.assoc_evenement'
          +' inner join ref_evenements on ref_eve_lib_court=f.ev_fam_type and ref_eve_obligatoire=1'
          +'   and ref_eve_langue='''+gci_context.Langue+''''
          +' inner join t_union u on u.union_clef=f.ev_fam_kle_famille'
          +' inner join tq_id t1 on t1.id1<3 and t1.id2=u.union_mari'
          +' inner join tq_id t2 on t2.id1<3 and t2.id2=u.union_femme'
          +' where a.assoc_table=''U''');
        if (not cbIndisConfidentiels.Checked)or(not cbIdentConfidentiels.Checked) then
          IBSQLIndi.SQL.Add('and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=a.assoc_kle_associe)'
            +' is distinct from 1');
        IBSQLIndi.SQL.Add('into :id'
          +' do'
          +' insert into tq_id (id1,id2)'
          +' select 3,:id from rdb$database'
          +' where not exists (select 1 from tq_id where id2=:id);');
      end
    end;
    if cbImportSources.Checked then
    begin//les sources d'événements individuels
      IBSQLIndi.SQL.Add('insert into tq_id (id1,id2)'
        +' select distinct 4,s.id'
        +' from sources_record s'
        +' inner join evenements_ind e on e.ev_ind_clef=s.data_id'
        +' inner join ref_evenements on ref_eve_lib_court=e.ev_ind_type and ref_eve_obligatoire=1'
        +'   and ref_eve_langue='''+gci_context.Langue+''''
        +' inner join tq_id t on t.id1<4 and t.id2=e.ev_ind_kle_fiche'
        +' where s.type_table=''I''');
      if (not cbIdentConfidentiels.Checked) then
        IBSQLIndi.SQL.Add('and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=e.ev_ind_kle_fiche)'
          +' is distinct from 1');
      IBSQLIndi.SQL.Add('and(char_length(s.auth)>0'
        +' or char_length(s.titl)>0'
        +' or char_length(s.abr)>0'
        +' or char_length(s.publ)>0'
        +' or char_length(s.texte)>0');
      if rbCheminImages.ItemIndex<3 then
        IBSQLIndi.SQL.Add('or exists (select 1'
          +' from media_pointeurs p'
          +' inner join multimedia m on m.multi_clef=p.mp_media'
          +' where p.mp_table=''F'''
          +' and p.mp_type_image=''F'''
          +' and p.mp_pointe_sur=s.id)');
      IBSQLIndi.SQL.Add(');');
          //les sources d'événements familiaux
      IBSQLIndi.SQL.Add('for select distinct s.id'
        +' from sources_record s'
        +' inner join evenements_fam f on f.ev_fam_clef=s.data_id'
        +' inner join ref_evenements on ref_eve_lib_court=f.ev_fam_type and ref_eve_obligatoire=1'
        +'   and ref_eve_langue='''+gci_context.Langue+''''
        +' inner join t_union u on u.union_clef=f.ev_fam_kle_famille'
        +' inner join tq_id t1 on t1.id1<4 and t1.id2=u.union_mari'
        +' inner join tq_id t2 on t2.id1<4 and t2.id2=u.union_femme'
        +' where s.type_table=''F''');
      if (not cbIdentConfidentiels.Checked) then
        IBSQLIndi.SQL.Add('and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=u.union_mari)'
          +' is distinct from 1'
          +' and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=u.union_femme)'
          +' is distinct from 1');
      IBSQLIndi.SQL.Add('and(char_length(s.auth)>0'
        +' or char_length(s.titl)>0'
        +' or char_length(s.abr)>0'
        +' or char_length(s.publ)>0'
        +' or char_length(s.texte)>0');
      if rbCheminImages.ItemIndex<3 then
        IBSQLIndi.SQL.Add('or exists (select 1'
          +' from media_pointeurs p'
          +' inner join multimedia m on m.multi_clef=p.mp_media'
          +' where p.mp_table=''F'''
          +' and p.mp_type_image=''F'''
          +' and p.mp_pointe_sur=s.id)');
      IBSQLIndi.SQL.Add(') into :id'
        +' do'
        +' insert into tq_id (id1,id2)'
        +' select 4,:id from rdb$database'
        +' where not exists (select 1 from tq_id where id1=4 and id2=:id);');
    end;
    if rbCheminImages.ItemIndex<3 then
    begin//les médias individuels
      IBSQLIndi.SQL.Add('insert into tq_id (id1,id2)'
        +' select distinct 5,p.mp_media'
        +' from media_pointeurs p'
        +' inner join multimedia m on m.multi_clef=p.mp_media'
        +' inner join tq_id t on t.id1<4 and t.id2=p.mp_pointe_sur'
        +' where (p.mp_type_image=''I'' or p.mp_type_image is null)');
      if (not cbIndisConfidentiels.Checked)or(not cbIdentConfidentiels.Checked) then
        IBSQLIndi.SQL.Add('and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=p.mp_pointe_sur)'
          +' is distinct from 1');
      IBSQLIndi.SQL.Add(';');
          //les médias d'événements individuels (actes)
      IBSQLIndi.SQL.Add('for select distinct p.mp_media'
        +' from media_pointeurs p'
        +' inner join multimedia m on m.multi_clef=p.mp_media'
        +' inner join evenements_ind e on e.ev_ind_clef=p.mp_pointe_sur'
        +' inner join ref_evenements on ref_eve_lib_court=e.ev_ind_type and ref_eve_obligatoire=1'
        +'   and ref_eve_langue='''+gci_context.Langue+''''
        +' inner join tq_id t on t.id1<4 and t.id2=e.ev_ind_kle_fiche'
        +' where p.mp_type_image=''A'' and p.mp_table=''I''');
      if (not cbIndisConfidentiels.Checked)or(not cbIdentConfidentiels.Checked) then
        IBSQLIndi.SQL.Add('and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=e.ev_ind_kle_fiche)'
          +' is distinct from 1');
      IBSQLIndi.SQL.Add('into :id'
        +' do'
        +' insert into tq_id (id1,id2)'
        +' select 5,:id from rdb$database'
        +' where not exists (select 1 from tq_id where id1=5 and id2=:id);');
          //les médias d'événements familiaux (actes)
      IBSQLIndi.SQL.Add('for select distinct p.mp_media'
        +' from media_pointeurs p'
        +' inner join multimedia m on m.multi_clef=p.mp_media'
        +' inner join evenements_fam f on f.ev_fam_clef=p.mp_pointe_sur'
        +' inner join ref_evenements on ref_eve_lib_court=f.ev_fam_type and ref_eve_obligatoire=1'
        +'   and ref_eve_langue='''+gci_context.Langue+''''
        +' inner join t_union u on u.union_clef=f.ev_fam_kle_famille'
        +' inner join tq_id t1 on t1.id1<4 and t1.id2=u.union_mari'
        +' inner join tq_id t2 on t2.id1<4 and t2.id2=u.union_femme'
        +' where p.mp_type_image=''A'' and p.mp_table=''F''');
      if (not cbIndisConfidentiels.Checked)or(not cbIdentConfidentiels.Checked) then
        IBSQLIndi.SQL.Add('and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=u.union_mari)'
          +' is distinct from 1'
          +' and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=u.union_femme)'
          +' is distinct from 1');
      IBSQLIndi.SQL.Add('into :id'
        +' do'
        +' insert into tq_id (id1,id2)'
        +' select 5,:id from rdb$database'
        +' where not exists (select 1 from tq_id where id1=5 and id2=:id);');
           //les médias attachés à des sources
      IBSQLIndi.SQL.Add('for select distinct p.mp_media'
        +' from media_pointeurs p'
        +' inner join multimedia m on m.multi_clef=p.mp_media'
        +' inner join tq_id t on t.id1=4 and t.id2=p.mp_pointe_sur'
        +' where p.mp_type_image=''F'' and p.mp_table=''F'''
        +' into :id'
        +' do'
        +' insert into tq_id (id1,id2)'
        +' select 5,:id from rdb$database'
        +' where not exists (select 1 from tq_id where id1=5 and id2=:id);');
    end;
    if rbTout.checked and cbIndisConfidentiels.Checked then
    begin// mettre toutes les familles dans la table temporaire
      IBSQLIndi.SQL.Add('insert into tq_id (id1,id2)'
        +' select distinct 6,union_clef'
        +' from t_union'
        +' where kle_dossier='+IntToStr(dm.NumDossier)+';');
    end
    else
    begin
      //les familles avec événements familiaux, le mari et la femme sont présents
      IBSQLIndi.SQL.Add('insert into tq_id (id1,id2)'
        +' select distinct 6,u.union_clef'
        +' from t_union u'
        +' inner join tq_id t1 on t1.id1<4 and t1.id2=u.union_mari'
        +' inner join tq_id t2 on t2.id1<4 and t2.id2=u.union_femme;');
           //les familles sans événements familiaux
      IBSQLIndi.SQL.Add('for select distinct u.union_clef'
        +' from tq_id t'//seul le père est présent
        +' inner join individu i on i.cle_fiche=t.id2'
        +' inner join t_union u on u.union_mari=i.cle_pere'
        +' where t.id1<4'
        +' and exists (select * from tq_id where id1<4 and id2=u.union_mari)'
        +' into :id'
        +' do'
        +' insert into tq_id (id1,id2)'
        +' select 7,:id from rdb$database'
        +' where not exists (select 1 from tq_id where id1>5 and id2=:id);');
      IBSQLIndi.SQL.Add('for select distinct u.union_clef'
        +' from tq_id t'//seule la mère est présente
        +' inner join individu i on i.cle_fiche=t.id2'
        +' inner join t_union u on u.union_femme=i.cle_mere'
        +' where t.id1<4'
        +' and exists (select 1 from tq_id where id1<4 and id2=u.union_femme)'
        +' into :id'
        +' do'
        +' insert into tq_id (id1,id2)'
        +' select 8,:id from rdb$database'
        +' where not exists (select 1 from tq_id where id1>5 and id2=:id);');
    end;
    IBSQLIndi.SQL.Add('end');
    IBSQLIndi.ExecQuery;
    IBSQLIndi.Close;
    IBSQLIndi.SQL.Clear;
  except
    cloture;
    IBSQLIndi.Close;
    IBSQLIndi.SQL.Clear;
    MyMessageDlg(rs_Info_Export_has_fallen_while_selecting_objects
      ,mtInformation, [mbOK]);
    exit;
  end;

  if gb_btnCancel then
  begin
    cloture;
    MyMessageDlg(rs_Info_Export_stopped_by_user
      ,mtInformation, [mbOK]);
    exit;
  end;
      {
      Gestion problématique des images : Tout est exporté
  // On exporte les fichiers des médias
  if (rbCheminImages.ItemIndex>0) then
  begin
    doCloseWorking;
    doShowWorking(rs_Wait_Exporting_medias_files+rs_Please_Wait,true);
    if rbCheminImages.ItemIndex=1
      //copier l'image stockée si MULTI_IMAGE_RTF=0 //le média original autrement
      then lsNomDossierImages:=dm.doExportImages(SaveDialog.FileName,0,cbRecreateFilename.Checked)
      //copier le média original
      else lsNomDossierImages:=dm.doExportImages(SaveDialog.FileName,1,cbRecreateFilename.Checked);
    if Length(lsNomDossierImages)=0 then
    begin
      cloture;
      MyMessageDlg(rs_Info_Export_has_fallen_medias_could_not_be_exported
        ,mtInformation, [mbOK]);
      exit;
    end;
    if gb_btnCancel then
    begin
      cloture;
      MyMessageDlg( rs_Info_Export_stopped_by_user
        ,mtInformation, [mbOK]);
      exit;
    end;

  end//le nom du dossier où sont copiés les médias est dans lsNomDossierImages
      //le nom du fichier (sans extension) est dans MULTI_NOM
  else
    lsNomDossierImages:='';
           {
    Gestion problématique des images : Les originaux peuvent être remplacés par mégarde
  if rbCheminImages.ItemIndex=0 then //On vérifie la présence des fichiers des images
  begin
    doCloseWorking;
    doShowWorking(rs_Wait_Verifying_media_files_presence +_CRLF + rs_Wait,true);
    application.ProcessMessages;
    QIndi.Close;
    QIndi.SQL.Text:='select m.multi_clef,m.multi_path from tq_id t'
      +' inner join multimedia m on m.multi_clef=t.id2'
      +' where t.id1=5 and m.multi_image_rtf<2';
    QMedia.Close;
    QMedia.SQL.Text:='select multi_media from multimedia where multi_clef=:multi_clef';
    QMedia.Prepare;
    QIndi.Open;
    while not (QIndi.Eof or gb_btnCancel) do
    begin
      s:=QIndi.FieldByName('MULTI_PATH').AsString;
      if not FileExistsUTF8(s) then //on essaie de le réécrire
      begin
        QMedia.ParamByName('MULTI_CLEF').AsInteger:=QIndi.FieldByName('MULTI_CLEF').AsInteger;
        QMedia.Open;
        try
          n:=LastDelimiter('\',s);
          sDossier:=Copy(s,1,n-1);
          if ForceDirectories(sDossier) then
            if TBlobField(QMedia.FieldByName('MULTI_MEDIA')).BlobSize>0 then
              TBlobField(QMedia.FieldByName('MULTI_MEDIA')).SaveToFile(s);
        except
        end;
        QMedia.Close;
      end;
      QIndi.Next;
      application.ProcessMessages;
    end;
    if gb_btnCancel then
    begin
      cloture;
      MyMessageDlg(rs_Info_Export_stopped_by_user
        ,mtInformation, [mbOK]);
      exit;
    end;
  end;
          }
  try//création du fichier .ged
    DeleteFileUTF8(SaveDialog.FileName);
    F:=FileCreateUTF8(SaveDialog.FileName);
//    if fCharSet=ccUTF8 Then // UTF8 Files need begining BOM
//      FileWrite(F,UTF8BOM[1],Length(UTF8BOM));
    doExportHeader;//l'entête
  except
    cloture;
    MyMessageDlg(rs_Info_Export_has_fallen_ged_can_not_be_written
      ,mtInformation, [mbOK]);
    exit;
  end;

  //les individus
  doCloseWorking;
  doShowWorking(rs_Wait_Exporting_persons+_CRLF+rs_Wait,true);
  QIndi.Close;
  QIndi.SQL.Clear;
  QIndi.SQL.Add('select i.*'
    +',(select first(1) u.union_clef from t_union u');
  if (not rbTout.checked)or(not cbIndisConfidentiels.Checked) then
    QIndi.SQL.Add('inner join tq_id on id1>5 and id2=u.union_clef');
  QIndi.SQL.Add('where u.union_mari is not distinct from i.cle_pere'
    +' and u.union_femme is not distinct from i.cle_mere) as FAMC'
    +' from tq_id t'
    +' inner join individu i on i.cle_fiche=t.id2'
    +' where t.id1<4 order by t.id2');
  Qsec.Close;
  //les événements individuels de l'individu
  Qsec.SQL.Text:='select e.*,r.ref_eve_type from evenements_ind e'
    +' inner join tq_id t on t.id2=e.ev_ind_kle_fiche and t.id1<4'
    +' inner join ref_evenements r on r.ref_eve_lib_court=e.ev_ind_type and r.ref_eve_langue=:langue'
    +'   and r.ref_eve_obligatoire=1'
    +' where e.ev_ind_kle_fiche=:cle_fiche'
    +' order by e.ev_ind_ordre nulls last,e.ev_ind_datecode nulls last,r.ref_eve_ecran,e.ev_ind_clef';
  qSources.Close;
  qSources.SQL.Clear;//les (la actuellement) sources liées aux événements individuels
  qSources.SQL.Add('select distinct s.id from sources_record s'
    +' inner join tq_id t on t.id1=4 and t.id2=s.id'
    +' where s.type_table=''I'' and s.data_id=:ev_ind_clef');
  QMedia.Close;
  QMedia.SQL.Clear;//les médias liés aux événements individuels AL2010 modif pour plusieurs média
  QMedia.SQL.Add('select p.mp_identite'
    +',m.MULTI_INFOS'
    +',m.MULTI_PATH'
    +',m.MULTI_IMAGE_RTF'
    +',m.MULTI_NOM'
    +',m.MULTI_CLEF'
    +',m.MULTI_MEDIA'
    +',m.MULTI_MEMO'
    +',p.mp_position'
    +' from media_pointeurs p'
    +' inner join tq_id t on t.id1=5 and t.id2=p.mp_media'
    +' inner join multimedia m on m.multi_clef=p.mp_media'
    +' where p.mp_type_image=''A'' and p.mp_table=''I'''
    +' and p.mp_pointe_sur=:ev_ind_clef order by p.mp_clef');

  QAssoEvent.Close;
  QAssoEvent.SQL.Clear;//les témoins des événements individuels
  QAssoEvent.SQL.Add('select a.assoc_kle_associe,a.assoc_libelle'
    +' from t_associations a');
  if (not rbTout.checked)or(not cbIndisConfidentiels.Checked) then
    QAssoEvent.SQL.Add('inner join tq_id t on t.id1<4 and t.id2=a.assoc_kle_associe');
  QAssoEvent.SQL.Add('where a.assoc_table=''I'' and a.assoc_evenement=:ev_ind_clef');
  QChild.Close;
  QChild.SQL.Clear;//les familles dont l'individu est l'un des conjoints
  //classées dans l'ordre des conjoints
  //modif 23/02/2011 AL: utilisation proc_conjoints_ordonnes
  QChild.SQL.Add('select clef_union from proc_conjoints_ordonnes(:cle_fiche,1)');
  QMediaIndi.Close;
  QMediaIndi.SQL.Clear;//médias liés directement à l'individu
  QMediaIndi.SQL.Add('select p.mp_identite'
    +',m.MULTI_INFOS'
    +',m.MULTI_PATH'
    +',m.MULTI_IMAGE_RTF'
    +',m.MULTI_NOM'
    +',m.MULTI_CLEF'
    +',m.MULTI_MEDIA'
    +',m.MULTI_MEMO'
    +',p.mp_position'
    +' from media_pointeurs p'
    +' inner join multimedia m on m.multi_clef=p.mp_media'
    +' where p.mp_type_image=''I'' and p.mp_table=''I'''
    +' and p.mp_pointe_sur=:cle_fiche'
    +' and exists(select 1 from tq_id where id1=5 and id2=p.mp_media)'
    +' order by p.mp_identite desc nulls last,p.mp_clef');

  if cbExportPatronymes.Checked then
  begin
    IBSQLIndi.Close;
    IBSQLIndi.ParamCheck:=true;
    IBSQLIndi.SQL.Add('select distinct nom from nom_attachement'
      +' where id_indi=:id_indi'
      +' or (nom_indi=:nom_indi and KLE_DOSSIER='+IntToStr(dm.NumDossier)+')');
  end;
  try
    with QIndi do
    begin
      ExecQuery;
      while not EOF do
      begin
        if gb_btnCancel then
        begin
          cloture;
          FileClose(F);
          MyMessageDlg( rs_Info_Export_stopped_by_user
            ,mtInformation, [mbOK]);
          exit;
        end;
        FileWriteLn(F,ConversionToChaine('0 @I'+FieldByName('CLE_FICHE').AsString
          +'@ INDI',fCharSet));
        //prénom, nom
        if ((FieldByName('IND_CONFIDENTIEL').AsInteger and _i_IndiConf)<>1)or(cbIdentConfidentiels.Checked) then
        begin
          FileWriteLn(F,ConversionToChaine('1 NAME '+trim(fieldByName('PRENOM').AsString)+'/'
            +trim(fieldByName('NOM').AsString)+'/',fCharSet));
          //Prefixe GED 5.5
          s:=fieldByName('PREFIXE').AsString;
          if Length(s)>0 then
            FileWriteLn(F,ConversionToChaine('2 NPFX '+s,fCharSet));
          //Surnom
          s:=fieldByName('SURNOM').AsString;
          if Length(s)>0 then
            FileWriteLn(F,ConversionToChaine('2 NICK '+s,fCharSet));
          //suffixe
          s:=fieldByName('SUFFIXE').AsString;
          if Length(s)>0 then
            FileWriteLn(F,ConversionToChaine('2 NSFX '+s,fCharSet));
          //les patronymes associés
          if cbExportPatronymes.Checked then
          begin
            IBSQLIndi.Params[0].AsInteger:=FieldByName('CLE_FICHE').AsInteger;
            IBSQLIndi.Params[1].AsString:=FieldByName('NOM').AsString;
            IBSQLIndi.ExecQuery;
            while not IBSQLIndi.Eof do
            begin
              FileWriteLn(F,ConversionToChaine('1 NAME /'+IBSQLIndi.fieldByName('NOM').AsString+'/'
                ,fCharSet));
              IBSQLIndi.Next;
            end;
            IBSQLIndi.Close;
          end;
        end
        else
          FileWriteLn(F,ConversionToChaine('1 NAME --X--/--X--/',fCharSet));

        //NCHI
        s:=fieldByName('NCHI').AsString;
        if fieldByName('NCHI').AsInteger>0 then
          FileWriteLn(F,ConversionToChaine('1 NCHI '+s,fCharSet));
        //NMR
        s:=fieldByName('NMR').AsString;
        if fieldByName('NMR').AsInteger>0 then
          FileWriteLn(F,ConversionToChaine('1 NMR '+s,fCharSet));
        //CLE_FIXE
//        s:=fieldByName('CLE_FIXE').AsString;
//        if fieldByName('CLE_FIXE').AsInteger>0 then
//          FileWriteLn(F,ConversionToChaine('1 _ANCES_CLE_FIXE '+s,fCharSet));
        //sexe
        n:=FieldByName('SEXE').AsInteger;
        if n=1 then
          FileWriteLn(F,ConversionToChaine('1 SEX M',fCharSet))
        else if n=2 then
          FileWriteLn(F,ConversionToChaine('1 SEX F',fCharSet));
        //enfant de la famille:
        s:=fieldByName('FAMC').AsString;
        if Length(s)>0 then
        begin
          FileWriteLn(F,ConversionToChaine('1 FAMC @F'+s+'@',fCharSet));
          s:=fieldByName('FILLIATION').AsString;
          if (Length(s)>0) then // forme plus proche de la norme
            FileWriteLn(F,ConversionToChaine('2 NOTE Filiation '+s,fCharSet));
        end;
        //la date de dernière modification
        FileWriteLn(F,ConversionToChaine('1 CHAN',fCharSet));
        UnInstant:=Now;
        if not FieldByName('DATE_MODIF').IsNull then
        try
          UnInstant:=FieldByName('DATE_MODIF').AsDateTime;
        except
        end;
        DecodeDate(UnInstant,annees,mois,jours);
        s:=IntToStr(jours)+' '+_GDate.MonthNum2MonthGedcom(mois)+' '+IntToStr(annees);
        FileWriteLn(F,ConversionToChaine('2 DATE '+s,fCharSet));
        DecodeTime(UnInstant,heures,minutes,secondes,MSecondes);
        s:=RightStr('0'+IntToStr(heures),2)+':'
          +RightStr('0'+IntToStr(minutes),2)+':'
          +RightStr('0'+IntToStr(secondes),2);
        FileWriteLn(F,ConversionToChaine('3 TIME '+s,fCharSet));
        //époux dans les familles
        QChild.ParamByName('CLE_FICHE').AsInteger:=FieldByName('CLE_FICHE').AsInteger;
        QChild.Open;
        while not QChild.Eof do
        begin
          FileWriteLn(F,ConversionToChaine('1 FAMS @F'+QChild.FieldByName('CLEF_UNION').AsString
            +'@',fCharSet));
          QChild.Next;
        end;
        QChild.Close;
        //le champ Sources
        if cbImportSources.checked
          and(((FieldByName('IND_CONFIDENTIEL').AsInteger and _i_IndiConf)<>1)or(cbIdentConfidentiels.Checked)) then
        begin
          PrepareTexte(TMemoField(fieldByName('SOURCE')),lignes,'SOUR',1);
          if lignes.count>0 then
            for n:=0 to lignes.count-1 do
              FileWriteLn(F,ConversionToChaine(lignes[n],fCharSet));
        end;
        //le champ notes
        if cbImportNotes.checked
          and(((FieldByName('IND_CONFIDENTIEL').AsInteger and _i_IndiConf)<>1)or(cbIdentConfidentiels.Checked)) then
        begin
          PrepareTexte(TMemoField(fieldByName('COMMENT')),lignes,'NOTE',1);
          if lignes.count>0 then
            for n:=0 to lignes.count-1 do
              FileWriteLn(F,ConversionToChaine(lignes[n],fCharSet));
        end;
        //Médias liés directement à l'individu
        if rbCheminImages.ItemIndex<3 then
        begin
          QMediaIndi.ParamByName('CLE_FICHE').AsInteger:=FieldByName('CLE_FICHE').AsInteger;
          QMediaIndi.Open;
          ExporteMedias(1,QMediaIndi,QIndi,False);
        end;
        if cbImportEvent.Checked
          and(((FieldByName('IND_CONFIDENTIEL').AsInteger and _i_IndiConf)<>1)or(cbIdentConfidentiels.Checked)) then
        begin//les événements individuels
          Qsec.ParamByName('LANGUE').AsString:=gci_context.Langue;
          Qsec.ParamByName('CLE_FICHE').AsInteger:=FieldByName('CLE_FICHE').AsInteger;
          Qsec.Open;
          while not Qsec.EOF do
          begin
            s:=Qsec.fieldbyname('EV_IND_TYPE').AsString;
            if (s<>'RESI')or cbExportDomiciles.Checked then
            begin
              sLieu:=StringReplace(trim(QSec.fieldByName('EV_IND_VILLE').AsString),',',' ',[rfReplaceAll]);
              if bCPenPLAC then
                sLieu:=sLieu+','+StringReplace(trim(QSec.fieldByName('EV_IND_CP').AsString),',',' ',[rfReplaceAll])
              else
                sLieu:=sLieu+','+StringReplace(trim(QSec.fieldByName('EV_IND_INSEE').AsString),',',' ',[rfReplaceAll]);
              sLieu:=sLieu+','+StringReplace(trim(QSec.fieldByName('EV_IND_DEPT').AsString),',',' ',[rfReplaceAll])
                +','+StringReplace(trim(QSec.fieldByName('EV_IND_REGION').AsString),',',' ',[rfReplaceAll])
                +','+StringReplace(trim(QSec.fieldByName('EV_IND_PAYS').AsString),',',' ',[rfReplaceAll])
                +','+StringReplace(trim(QSec.fieldByName('EV_IND_SUBD').AsString),',',' ',[rfReplaceAll]);

              if cbImportSources.checked then
              begin
                qSources.ParamByName('EV_IND_CLEF').AsInteger:=Qsec.FieldByName('EV_IND_CLEF').AsInteger;
                qSources.Open;
                if qSources.Eof then
                  qSources.Close;
              end;

              if (rbCheminImages.ItemIndex<3) then
              begin//médias liés à l'événement individuel
                QMedia.ParamByName('EV_IND_CLEF').AsInteger:=Qsec.FieldByName('EV_IND_CLEF').AsInteger;
                QMedia.Open;
                if QMedia.IsEmpty then
                  QMedia.Close;
              end;

              if cbImportTemoins.checked then
              begin//pas conforme gedcom tout çà...
                QAssoEvent.ParamByName('EV_IND_CLEF').AsInteger:=Qsec.FieldByName('EV_IND_CLEF').AsInteger;
                QAssoEvent.Open;
                if QAssoEvent.Eof then
                  QAssoEvent.Close;
              end;

              if (s='EVEN')or(Qsec.fieldbyname('REF_EVE_TYPE').AsString='D')
                or(Qsec.fieldbyname('REF_EVE_TYPE').AsString='E')then //les événements
              begin
                if (s<>'EVEN')
                  and(Length(trim(Qsec.fieldbyname('EV_IND_DATE_WRITEN').AsString))=0)
                  and(sLieu<>',,,,,')
                  and(Length(trim(Qsec.fieldByName('EV_IND_CP').AsString))=0)
                  and(Length(trim(Qsec.fieldByName('EV_IND_INSEE').AsString))=0)then
                  FileWriteLn(F,ConversionToChaine('1 '+s+' Y',fCharSet))
                else
                  FileWriteLn(F,ConversionToChaine('1 '+s,fCharSet));
                if s='EVEN' then
                begin
                  s:=trim(Qsec.fieldbyname('EV_IND_TITRE_EVENT').AsString);
                  if length(s)>0 then
                    s:=s+#160;
                end
                else
                  s:='';
                s:=s+trim(Qsec.fieldbyname('EV_IND_DESCRIPTION').AsString);
                if length(s)>0 then
                  FileWriteLn(F,ConversionToChaine('2 TYPE '+s,fCharSet));
              end
              else
              begin
                if Length(trim(Qsec.fieldbyname('EV_IND_DESCRIPTION').AsString))>0 then
                  FileWriteLn(F,ConversionToChaine('1 '+s+' '
                    +trim(Qsec.fieldbyname('EV_IND_DESCRIPTION').AsString),fCharSet))
                else
                  FileWriteLn(F,ConversionToChaine('1 '+s,fCharSet));
              end;

              s:=trim(QSec.fieldbyname('EV_IND_DATE_WRITEN').AsString);
              if Length(s)>0 then
              begin
                if _GDate.DecodeHumanDate(s) then
                begin
                  s:=_GDate.GedcomDate;
                  if Length(s)>0 then
                    FileWriteLn(F,ConversionToChaine('2 DATE '+s,fCharSet));
                end
                else
                  FileWriteLn(F,ConversionToChaine('2 DATE ('+s+')',fCharSet));
              end;
              s:=Copy(QSec.fieldbyname('EV_IND_HEURE').AsString,1,5);
              if copy(s,2,1)=':' then
                s:='0'+copy(s,1,4);
              if (s<>'00:00')and(Length(s)>0) then
                FileWriteLn(F,ConversionToChaine('2 TIME '+s,fCharSet));

              if sLieu<>',,,,,' then
              begin
                FileWriteLn(F,ConversionToChaine('2 PLAC '+sLieu,fCharSet));
                if bCPenPLAC then
                  ExportNotePLAC(3,'Code INSEE',trim(Qsec.FieldByName('EV_IND_INSEE').AsString)
                    ,trim(Qsec.fieldByName('EV_IND_LATITUDE').AsString)
                    ,trim(Qsec.fieldByName('EV_IND_LONGITUDE').AsString))
                else
                  ExportNotePLAC(3,'Code postal',trim(Qsec.FieldByName('EV_IND_CP').AsString)
                    ,trim(Qsec.fieldByName('EV_IND_LATITUDE').AsString)
                    ,trim(Qsec.fieldByName('EV_IND_LONGITUDE').AsString));
              end;
              if Qsec.fieldbyname('EV_IND_TYPE').AsString='RESI' then
              begin
                //lignes de l'adresse ici depuis la suppression de la table ADRESSES_IND
                PrepareTexte(TMemoField(Qsec.fieldByName('EV_IND_LIGNES_ADRESSE')),Lignes,'ADDR',2);
                //s:=trim(Qsec.fieldByName('EV_IND_CP').AsString);
                if Lignes.count>0 then //AL10/2011 test de transmission par POST, transmission par NOTE de PLAC conservée
                begin
                  for n:=0 to Lignes.count-1 do
                    FileWriteLn(F,ConversionToChaine(Lignes[n],fCharSet));
                  //if s>'' then
                  //  FileWriteLn(F,ConversionToChaine('3 POST '+s,fCharSet));
                end;
                {else
                begin
                  if s>'' then
                  begin
                    FileWriteLn(F,ConversionToChaine('2 ADDR',fCharSet));
                    FileWriteLn(F,ConversionToChaine('3 POST '+s,fCharSet));
                  end;
                end;}
                //EMAIL ici depuis la suppression de la table ADRESSES_IND
                s:=trim(Qsec.fieldbyname('EV_IND_MAIL').AsString);
                if Length(s)>0 then
                  FileWriteLn(F,ConversionToChaine('2 EMAIL '+s,fCharSet));
                //WEB ici depuis la suppression de la table ADRESSES_IND
                s:=trim(Qsec.fieldbyname('EV_IND_WEB').AsString);
                if Length(s)>0 then
                  FileWriteLn(F,ConversionToChaine('2 WWW '+s,fCharSet));
                //PHON ici depuis la suppression de la table ADRESSES_IND
                PrepareTexte(TMemoField(Qsec.fieldByName('EV_IND_TEL')),Lignes,'PHON',2);
                if Lignes.count>0 then
                  for n:=0 to Lignes.count-1 do
                    FileWriteLn(F,ConversionToChaine(Lignes[n],fCharSet));
              {end
              else
              begin
                s:='';//trim(Qsec.fieldbyname('EV_IND_ADRESSE').AsString); //si on réactive le champ Lieu
                if s>'' then
                begin
                  FileWriteLn(F,ConversionToChaine('2 ADDR '+s,fCharSet));
                  s:=trim(Qsec.fieldByName('EV_IND_CP').AsString);
                  if s>'' then
                    FileWriteLn(F,ConversionToChaine('3 POST '+s,fCharSet));
                end
                else
                begin
                  s:=trim(Qsec.fieldByName('EV_IND_CP').AsString);
                  if s>'' then
                  begin
                    FileWriteLn(F,ConversionToChaine('2 ADDR',fCharSet));
                    FileWriteLn(F,ConversionToChaine('3 POST '+s,fCharSet));
                  end;
                end;}
              end;

              s:=trim(Qsec.FieldByName('EV_IND_CAUSE').AsString);
              if Length(s)>0 then
                FileWriteLn(F,ConversionToChaine('2 CAUS '+s,fCharSet));
              s:=trim(QSec.FieldByName('EV_IND_ORDRE').AsString);
              if (Length(s)>0) then
                FileWriteLn(F,ConversionToChaine('2 _ORDR '+s,fCharSet));
              if (QSec.FieldByName('EV_IND_ACTE').AsInteger<>0) then
                FileWriteLn(F,ConversionToChaine('2 _ACTE '+QSec.FieldByName('EV_IND_ACTE').AsString,fCharSet));

              if cbImportNotes.checked then
              begin
                PrepareTexte(TMemoField(Qsec.fieldByName('EV_IND_COMMENT')),Lignes,'NOTE',2);
                if Lignes.count>0 then
                  for n:=0 to Lignes.count-1 do
                    FileWriteLn(F,ConversionToChaine(Lignes[n],fCharSet));
              end;

              if qSources.Active then
              begin
                while not qSources.Eof do
                begin
                  FileWriteLn(F,ConversionToChaine('2 SOUR @S'+qSources.FieldByName('ID').AsString
                    +'@',fCharSet));
                  qSources.Next;
                end;
                qSources.Close;
              end;
              if not (QMedia.EOF and QMedia.BOF) then
              begin//médias liés à l'événement individuel
                ExporteMedias(2,QMedia,QIndi,False);
//              while not QMedia.Eof do
//              begin
//                FileWriteLn(F,ConversionToChaine('2 OBJE @M'+QMedia.FieldByName('MP_MEDIA').AsString
//                        +'@',fCharSet));
//                if QMedia.FieldByName('MP_IDENTITE').AsInteger=1 then
//                  FileWriteLn(F,ConversionToChaine('3 _IDEN 1',fCharSet));
//                QMedia.Next;
//              end;
//              QMedia.Close;
              end;
              if QAssoEvent.Active then
              begin//pas conforme gedcom tout çà...
                while not QAssoEvent.Eof do
                begin
                  FileWriteLn(F,ConversionToChaine('2 ASSO @I'+QAssoEvent.FieldByName('ASSOC_KLE_ASSOCIE').AsString
                    +'@',fCharSet));
                  FileWriteLn(F,ConversionToChaine('3 TYPE IND',fCharSet));
                  FileWriteLn(F,ConversionToChaine('3 RELA '+QAssoEvent.FieldByName('ASSOC_LIBELLE').AsString
                    ,fCharSet));
                  QAssoEvent.Next;
                end;
                QAssoEvent.Close;
              end;
            end; //de if (s<>'RESI')or cbExportDomiciles.Checked
            Qsec.Next;
          end;//de while not Qsec.EOF do
          Qsec.Close;
        end;//fin des événements individuels
        //ici on exportait les domiciles avant qu'ils ne soient gérés dans les événements
        Next;
        application.ProcessMessages;
      end;//de while not EOF do
      Close;
    end;//de with QIndi do
    IBSQLIndi.ParamCheck:=false;
  except
    cloture;
    FileClose(F);
    MyMessageDlg(rs_Info_Export_has_fallen_while_persons_export
      ,mtInformation, [mbOK]);
    exit;
  end;

  if gb_btnCancel then
  begin
    cloture;
    FileClose(F);
    MyMessageDlg(rs_Info_Export_stopped_by_user
      ,mtInformation, [mbOK]);
    exit;
  end;

  //écriture des familles dans le .ged
  doCloseWorking;
  doShowWorking(rs_Wait_Exporting_families+_CRLF+rs_Wait,true);
  QIndi.Close;
  QIndi.SQL.Clear;//sélection des familles
  if rbTout.checked and cbIndisConfidentiels.Checked then
    QIndi.SQL.Add('select u.union_clef,'+_CRLF
      +'u.union_type,'+_CRLF
      +'u.union_mari as MARI,'+_CRLF
      +'u.union_femme as FEMME,'+_CRLF
      +'t.id1,tm.id2 as MARI,tf.id2 as FEMME,'+_CRLF
      +'im.NOM AS NOM_MARI,'+_CRLF
      +'im.PRENOM AS PRENOM_MARI,'+_CRLF
      +'if.NOM AS NOM_FEMME,'+_CRLF
      +'if.PRENOM AS PRENOM_FEMME,'+_CRLF
      +'u.source,'+_CRLF
      +'u.comment,'+_CRLF
      +'t.id1'
      +' from tq_id t'
      +' inner join t_union u on u.union_clef=t.id2'
      +' left join tq_id tm on tm.id1<4 and tm.id2=u.union_mari'
      +' left join tq_id tf on tf.id1<4 and tf.id2=u.union_femme'
      +' left join individu if on if.cle_fiche=u.union_femme'
      +' left join individu im on im.cle_fiche=u.union_mari'
      +' where t.id1>5 order by u.union_clef')
  else
    QIndi.SQL.Add('select u.*,t.id1,tm.id2 as MARI,tf.id2 as FEMME,'+_CRLF
      +'im.NOM AS NOM_MARI,'+_CRLF
      +'im.PRENOM AS PRENOM_MARI,'+_CRLF
      +'if.NOM AS NOM_FEMME,'+_CRLF
      +'if.PRENOM AS PRENOM_FEMME'
      +' from tq_id t'
      +' inner join t_union u on u.union_clef=t.id2'
      +' left join tq_id tm on tm.id1<4 and tm.id2=u.union_mari'
      +' left join tq_id tf on tf.id1<4 and tf.id2=u.union_femme'
      +' left join individu if on if.cle_fiche=u.union_femme'
      +' left join individu im on im.cle_fiche=u.union_mari'
      +' where t.id1>5 order by u.union_clef');
  Qsec.Close;
  Qsec.SQL.Clear;//sélection des événements familiaux
  Qsec.SQL.Add('select f.* from tq_id t'
    +' inner join evenements_fam f on f.ev_fam_kle_famille=t.id2'
    +' inner join ref_evenements on ref_eve_lib_court=f.ev_fam_type and ref_eve_obligatoire=1'
    +'   and ref_eve_langue='''+gci_context.Langue+''''
    +' inner join t_union u on u.union_clef=t.id2'
    +' where t.id1=6 and t.id2=:union_clef');
  if (cbIndisConfidentiels.Checked)and(not cbIdentConfidentiels.Checked) then
    Qsec.SQL.Add('and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=u.union_mari)'
      +' is distinct from 1'
      +' and (select bin_and(ind_confidentiel,'+_s_IndiConf+') from individu where cle_fiche=u.union_femme)'
      +' is distinct from 1');
  Qsec.SQL.Add('order by f.ev_fam_ordre nulls last'
      +',f.ev_fam_datecode nulls last'
      +',f.ev_fam_heure nulls last'
      +',f.ev_fam_clef');
  qSources.Close;
  qSources.SQL.Clear;//sélection des sources liées à l'événement familial
  qSources.SQL.Add('select distinct s.id from sources_record s'
    +' inner join tq_id t on t.id1=4 and t.id2=s.id'
    +' where s.type_table=''F'' and s.data_id=:ev_fam_clef');
  QMedia.Close;
  QMedia.SQL.Clear;//sélection des médias liés à l'événement familial
  QMedia.SQL.Add('select 0 as MP_IDENTITE'
    +',m.MULTI_INFOS'
    +',m.MULTI_PATH'
    +',m.MULTI_IMAGE_RTF'
    +',m.MULTI_NOM'
    +',m.MULTI_CLEF'
    +',m.MULTI_MEDIA'
    +',m.MULTI_MEMO'
    +',0 as mp_position'
    +' from media_pointeurs p'
    +' inner join multimedia m on m.multi_clef=p.mp_media'
    +' where p.mp_type_image=''A'' and p.mp_table=''F'''
    +' and exists(select 1 from tq_id where id1=5 and id2=p.mp_media)'
    +' and p.mp_pointe_sur=:ev_fam_clef'
    +' and p.mp_cle_individu=:epoux order by p.mp_clef');

  QAssoEvent.Close;
  QAssoEvent.SQL.Clear;//sélection des témoins d'un événement familial
  QAssoEvent.SQL.Add('select a.assoc_kle_associe,a.assoc_libelle'
    +' from t_associations a');
  if not rbTout.checked and cbIndisConfidentiels.Checked then
    QAssoEvent.SQL.Add('inner join tq_id t on t.id1<4 and t.id2=a.assoc_kle_associe');
  QAssoEvent.SQL.Add('where a.assoc_table=''U'' and a.assoc_evenement=:ev_fam_clef');
  QChild.Close;
  QChild.SQL.Clear;//sélection des enfants de la famille
  //modif AL 23/02/2011 pour ordre enfants avec heure et cle_parents
  QChild.SQL.Add('select distinct t.id2'
    +',(select first (1)'
    +' ev_ind_datecode*1440'
    +'+coalesce(extract(hour from ev_ind_heure)*60+extract(minute from ev_ind_heure),0)'
    +' from evenements_ind'
    +' where ev_ind_kle_fiche=t.id2 and ev_ind_date_year is not null'
    +' order by ev_ind_datecode,ev_ind_heure)'
    +' from tq_id t'
    +' inner join individu i on i.cle_fiche=t.id2'
    +' where t.id1<4');
  if rbTout.checked and cbIndisConfidentiels.Checked then
    QChild.SQL.Add('and i.cle_pere is not distinct from :mari'
      +' and i.cle_mere is not distinct from :femme')
  else
    QChild.SQL.Add('and ((6=:id1 and i.cle_pere=:mari and i.cle_mere=:femme)'
      +' or (7=:id1 and i.cle_pere=:mari'
      +' and not exists (select * from tq_id where id1<4 and id2=i.cle_mere))'
      +' or (8=:id1 and i.cle_mere=:femme'
      +' and not exists (select * from tq_id where id1<4 and id2=i.cle_pere)))');
  QChild.SQL.Add('order by i.cle_parents,2');
  try
    with QIndi do
    begin
      ExecQuery;
      while not EOF do
      begin
        if gb_btnCancel then
        begin
          cloture;
          FileClose(F);
          MyMessageDlg( rs_Info_Export_stopped_by_user
            ,mtInformation, [mbOK]);
          exit;
        end;

        FileWriteLn(F,ConversionToChaine('0 @F'+FieldByName('UNION_CLEF').AsString
          +'@ FAM',fCharSet));
        if not FieldByName('MARI').IsNull then
          FileWriteLn(F,ConversionToChaine('1 HUSB @I'+FieldByName('MARI').AsString+'@'
            ,fCharSet));
        if not FieldByName('FEMME').IsNull then
          FileWriteLn(F,ConversionToChaine('1 WIFE @I'+FieldByName('FEMME').AsString+'@'
            ,fCharSet));
        if (not rbTout.checked)or(not cbIndisConfidentiels.Checked) then
          QChild.ParamByName('ID1').AsInteger:=FieldByName('ID1').AsInteger;
        if FieldByName('MARI').AsInteger>0 then
          QChild.ParamByName('MARI').AsInteger:=FieldByName('MARI').AsInteger
        else
          QChild.ParamByName('MARI').Value:=Null;
        if FieldByName('FEMME').AsInteger>0 then
          QChild.ParamByName('FEMME').AsInteger:=FieldByName('FEMME').AsInteger
        else
          QChild.ParamByName('FEMME').Value:=Null;
        QChild.Open;
        while not QChild.Eof do
        begin
          FileWriteLn(F,ConversionToChaine('1 CHIL @I'+QChild.FieldByName('ID2').AsString
            +'@',fCharSet));
          QChild.Next;
        end;
        QChild.Close;
        if cbImportSources.checked then
        begin
          PrepareTexte(TMemoField(FieldByName('SOURCE')),lignes,'SOUR',1);
          if lignes.count>0 then
            for n:=0 to lignes.count-1 do
              FileWriteLn(F,ConversionToChaine(lignes[n],fCharSet));
        end;
        if cbImportNotes.checked then
        begin
          PrepareTexte(TMemoField(FieldByName('COMMENT')),lignes,'NOTE',1);
          if lignes.count>0 then
            for n:=0 to lignes.count-1 do
              FileWriteLn(F,ConversionToChaine(lignes[n],fCharSet));
        end;

        if cbImportEvent.Checked and(FieldByName('ID1').AsInteger=6) then
        begin//les événements familiaux
          Qsec.ParamByName('UNION_CLEF').AsInteger:=FieldByName('UNION_CLEF').AsInteger;
          Qsec.Open;
          while not Qsec.EOF do
          begin
            sLieu:=StringReplace(trim(Qsec.fieldByName('EV_FAM_VILLE').AsString),',',' ',[rfReplaceAll]);
            if bCPenPLAC
              then sLieu:=sLieu+','+StringReplace(trim(Qsec.fieldByName('EV_FAM_CP').AsString),',',' ',[rfReplaceAll])
              else sLieu:=sLieu+','+StringReplace(trim(Qsec.fieldByName('EV_FAM_INSEE').AsString),',',' ',[rfReplaceAll]);

            sLieu:=sLieu+','+StringReplace(trim(Qsec.fieldByName('EV_FAM_DEPT').AsString),',',' ',[rfReplaceAll])
              +','+StringReplace(trim(Qsec.fieldByName('EV_FAM_REGION').AsString),',',' ',[rfReplaceAll])
              +','+StringReplace(trim(Qsec.fieldByName('EV_FAM_PAYS').AsString),',',' ',[rfReplaceAll])
              +','+StringReplace(trim(Qsec.fieldByName('EV_FAM_SUBD').AsString),',',' ',[rfReplaceAll]);

            if cbImportSources.checked then
            begin
              qSources.ParamByName('EV_FAM_CLEF').AsInteger:=Qsec.FieldByName('EV_FAM_CLEF').AsInteger;
              qSources.Open;
              if qSources.Eof then
                qSources.Close;
            end;

            if cbImportTemoins.checked then
            begin//pas conforme gedcom tout çà...
              QAssoEvent.ParamByName('EV_FAM_CLEF').AsInteger:=Qsec.FieldByName('EV_FAM_CLEF').AsInteger;
              QAssoEvent.Open;
              if QAssoEvent.Eof then
                QAssoEvent.Close;
            end;

            if (rbCheminImages.ItemIndex<3) then
            begin
              QMedia.ParamByName('EV_FAM_CLEF').AsInteger:=Qsec.FieldByName('EV_FAM_CLEF').AsInteger;
              QMedia.ParamByName('epoux').AsInteger:=QIndi.FieldByName('MARI').AsInteger;
              QMedia.Open;
              if QMedia.IsEmpty then
                QMedia.Close;
            end;

            s:=Qsec.FieldByName('EV_FAM_TYPE').AsString;
            if (Length(trim(Qsec.fieldbyname('EV_FAM_DATE_WRITEN').AsString))=0)
              and(sLieu=',,,,,')
              and(Length(trim(Qsec.fieldByName('EV_FAM_CP').AsString))=0)
              and(Length(trim(Qsec.fieldByName('EV_FAM_INSEE').AsString))=0)
              and(s<>'EVEN') then
              FileWriteLn(F,ConversionToChaine('1 '+s+' Y',fCharSet))
            else
              FileWriteLn(F,ConversionToChaine('1 '+s,fCharSet));

            if s='EVEN' then
            begin
              s:=trim(Qsec.fieldbyname('EV_FAM_TITRE_EVENT').AsString);
              if length(s)>0 then
                s:=s+#160;
            end
            else
              s:='';
            s:=s+trim(Qsec.fieldbyname('EV_FAM_DESCRIPTION').AsString);
            if Length(s)>0 then
              FileWriteLn(F,ConversionToChaine('2 TYPE '+s,fCharSet));

            s:=trim(Qsec.FieldByName('EV_FAM_DATE_WRITEN').AsString);
            if Length(s)>0 then
            begin
              if _GDate.DecodeHumanDate(s) then
              begin
                s:=_GDate.GedcomDate;
                if Length(s)>0 then
                  FileWriteLn(F,ConversionToChaine('2 DATE '+s,fCharSet))
              end
              else
                FileWriteLn(F,ConversionToChaine('2 DATE ('+s+')',fCharSet));
            end;
            s:=Copy(Qsec.FieldByName('EV_FAM_HEURE').AsString,1,5);
            if copy(s,2,1)=':' then
              s:='0'+copy(s,1,4);
            if (s<>'00:00')and(Length(s)>0) then //TIME pas prévu dans ce contexte
              FileWriteLn(F,ConversionToChaine('2 TIME '+s,fCharSet));

            if sLieu<>',,,,,' then
            begin
              FileWriteLn(F,ConversionToChaine('2 PLAC '+sLieu,fCharSet));
              if bCPenPLAC then
                ExportNotePLAC(3,'Code INSEE',trim(Qsec.FieldByName('EV_FAM_INSEE').AsString)
                  ,trim(Qsec.fieldByName('EV_FAM_LATITUDE').AsString)
                  ,trim(Qsec.fieldByName('EV_FAM_LONGITUDE').AsString))
              else
                ExportNotePLAC(3,'Code postal',trim(Qsec.FieldByName('EV_FAM_CP').AsString)
                  ,trim(Qsec.fieldByName('EV_FAM_LATITUDE').AsString)
                  ,trim(Qsec.fieldByName('EV_FAM_LONGITUDE').AsString));
            end;

            {s:=trim(Qsec.fieldByName('EV_FAM_CP').AsString);
            if s>'' then //AL10/2011 test de transmission par POST, transmission par NOTE de PLAC conservée
            begin
              FileWriteLn(F,ConversionToChaine('2 ADDR',fCharSet));
              FileWriteLn(F,ConversionToChaine('3 POST '+s,fCharSet));
            end;}

            s:=trim(Qsec.FieldByName('EV_FAM_CAUSE').AsString);
            if Length(s)>0 then
              FileWriteLn(F,ConversionToChaine('2 CAUS '+s,fCharSet));
            if (not QSec.FieldByName('EV_FAM_ORDRE').IsNull) then //AL2011
              FileWriteLn(F,ConversionToChaine('2 _ORDR '+QSec.FieldByName('EV_FAM_ORDRE').AsString,fCharSet));
            if (QSec.FieldByName('EV_FAM_ACTE').AsInteger<>0) then
              FileWriteLn(F,ConversionToChaine('2 _ACTE '+QSec.FieldByName('EV_FAM_ACTE').AsString,fCharSet));

            if cbImportNotes.checked then
            begin
              PrepareTexte(TMemoField(Qsec.fieldByName('EV_FAM_COMMENT')),Lignes,'NOTE',2);
              if Lignes.count>0 then
                for n:=0 to Lignes.count-1 do
                  FileWriteLn(F,ConversionToChaine(Lignes[n],fCharSet));
            end;

            if qSources.Active then
            begin
              while not qSources.Eof do
              begin
                FileWriteLn(F,ConversionToChaine('2 SOUR @S'+qSources.FieldByName('ID').AsString
                  +'@',fCharSet));
                qSources.Next;
              end;
              qSources.Close;
            end;

            if not QMedia.IsEmpty then
            begin
              ExporteMedias(2,QMedia,QIndi,True);
//                while not QMedia.Eof do
//                begin
//                  FileWriteLn(F,ConversionToChaine('2 OBJE @M'+QMedia.FieldByName('MP_MEDIA').AsString
//                          +'@',fCharSet));
//                  QMedia.Next;
//                end;
//                QMedia.Close;
            end;

            if QAssoEvent.Active then
            begin//pas conforme gedcom tout çà...
              while not QAssoEvent.Eof do
              begin
                FileWriteLn(F,ConversionToChaine('2 ASSO @I'+QAssoEvent.FieldByName('ASSOC_KLE_ASSOCIE').AsString
                  +'@',fCharSet));
                FileWriteLn(F,ConversionToChaine('3 TYPE FAM',fCharSet));
                FileWriteLn(F,ConversionToChaine('3 RELA '+QAssoEvent.FieldByName('ASSOC_LIBELLE').AsString
                  ,fCharSet));
                QAssoEvent.Next;
              end;
              QAssoEvent.Close;
            end;
            Qsec.Next;
          end;
          Qsec.Close;
        end;// fin des événements familiaux

        Next;
        application.ProcessMessages;
      end;
      Close;
    end;//de with QIndi do
  except
    cloture;
    FileClose(F);
    MyMessageDlg(rs_Info_Export_has_fallen_while_sources_export
      ,mtInformation, [mbOK]);
    exit;
  end;

  if gb_btnCancel then
  begin
    cloture;
    FileClose(F);
    MyMessageDlg(rs_Info_Export_stopped_by_user
      ,mtInformation, [mbOK]);
    exit;
  end;

  //écriture des sources
  if cbImportSources.Checked then
  begin
    doCloseWorking;
    doShowWorking(rs_Wait_Exporting_sources+_CRLF+rs_Wait,true);
    QIndi.Close;
    QIndi.SQL.Clear;
    QIndi.SQL.Add('select s.* from tq_id t inner join sources_record s'
      +' on s.id=t.id2 where t.id1=4 order by s.id');
    Qsec.Close;
    Qsec.SQL.Text:='select distinct 0 as MP_IDENTITE'
      +',m.MULTI_INFOS'
      +',m.MULTI_PATH'
      +',m.MULTI_IMAGE_RTF'
      +',m.MULTI_NOM'
      +',m.MULTI_CLEF'
      +',m.MULTI_MEDIA'
      +',m.MULTI_MEMO'
      +',0 as mp_position'
      +',(select first(1) mp_clef from media_pointeurs'
      +' where mp_type_image=''F'' and mp_table=''F'''
      +' and mp_media=m.multi_clef'
      +' and mp_pointe_sur=p.mp_pointe_sur)'
      +' from media_pointeurs p'
      +' inner join multimedia m on m.multi_clef=p.mp_media'
      +' where p.mp_type_image=''F'' and p.mp_table=''F'''
      +' and p.mp_pointe_sur=:id_source'
      +' and exists(select 1 from tq_id where id1=5 and id2=p.mp_media)'
      +' order by 7';
    try
      QIndi.ExecQuery;
      Qsec.Prepare;
      with QIndi do
      begin
        while not EOF do
        begin
          if gb_btnCancel then
          begin
            cloture;
            FileClose(F);
            MyMessageDlg( rs_Info_Export_stopped_by_user
              ,mtInformation, [mbOK]);
            exit;
          end;

          FileWriteLn(F,ConversionToChaine('0 @S'+FieldByName('ID').AsString
            +'@ SOUR',fCharSet));
          s:=trim(FieldByName('AUTH').AsString);
          if Length(s)>0 then
          begin
            PrepareTexte(TMemoField(FieldByName('AUTH')),lignes,'AUTH',1);
            if lignes.count>0 then
              for n:=0 to lignes.count-1 do
                FileWriteLn(F,ConversionToChaine(Lignes[n],fCharSet));
          end;
          s:=trim(FieldByName('TITL').AsString);
          if Length(s)>0 then
          begin
            PrepareTexte(TMemoField(FieldByName('TITL')),lignes,'TITL',1);
            if lignes.count>0 then
              for n:=0 to lignes.count-1 do
                FileWriteLn(F,ConversionToChaine(Lignes[n],fCharSet));
          end;
          s:=trim(FieldByName('ABR').AsString);
          if Length(s)>0 then
            FileWriteLn(F,ConversionToChaine('1 ABBR '+s,fCharSet));
          s:=trim(FieldByName('PUBL').AsString);
          if Length(s)>0 then
          begin
            PrepareTexte(TMemoField(FieldByName('PUBL')),lignes,'PUBL',1);
            if lignes.count>0 then
              for n:=0 to lignes.count-1 do
                FileWriteLn(F,ConversionToChaine(Lignes[n],fCharSet));
          end;
          s:=trim(FieldByName('TEXTE').AsString);
          if Length(s)>0 then
          begin
            PrepareTexte(TMemoField(FieldByName('TEXTE')),lignes,'TEXT',1);
            if lignes.count>0 then
              for n:=0 to lignes.count-1 do
                FileWriteLn(F,ConversionToChaine(Lignes[n],fCharSet));
          end;
          FileWriteLn(F,ConversionToChaine('1 CHAN',fCharSet));
          if FieldByName('CHANGE_DATE').IsNull then
            UnInstant:=Now
          else
            UnInstant:=FieldByName('CHANGE_DATE').AsDateTime;
          DecodeDate(UnInstant,annees,mois,jours);
          s:=IntToStr(jours)+' '+_GDate.MonthNum2MonthGedcom(mois)+' '+IntToStr(annees);
          FileWriteLn(F,ConversionToChaine('2 DATE '+s,fCharSet));
          DecodeTime(UnInstant,heures,minutes,secondes,MSecondes);
          s:=RightStr('0'+IntToStr(heures),2)+':'
            +RightStr('0'+IntToStr(minutes),2)+':'
            +RightStr('0'+IntToStr(secondes),2);
          FileWriteLn(F,ConversionToChaine('3 TIME '+s,fCharSet));

          if not(rbCheminImages.ItemIndex=3) then
           begin
            Qsec.ParamByName('ID_SOURCE').AsInteger:=FieldByName('ID').AsInteger;
            Qsec.Open;
            ExporteMedias(1,Qsec,QIndi,True);
           end;
          Next;
          application.ProcessMessages;
        end;
      end;//de with QIndi do
      QIndi.Close;
    except
      cloture;
      FileClose(F);
      MyMessageDlg(rs_Info_Export_has_fallen_while_sources_export
        ,mtInformation, [mbOK]);
      exit;
    end;
    if gb_btnCancel then
    begin
      cloture;
      FileClose(F);
      MyMessageDlg(rs_Info_Export_stopped_by_user
        ,mtInformation, [mbOK]);
      exit;
    end;
  end;

  {//écriture des médias dans le .ged version 5.5.1
  if rbCheminImages.ItemIndex<3 then
  begin
    doCloseWorking;
    doShowWorking('Exportation des médias'+ _CRLF+'Patientez SVP');
    QIndi.Close;
    QIndi.SQL.Clear;
    QIndi.SQL.Add('select m.MULTI_CLEF'
                 +',m.MULTI_TYPE'
                 +',m.MULTI_IMAGE_RTF'
                 +',m.MULTI_INFOS'
                 +',m.MULTI_PATH'
                 +',m.MULTI_NOM'
                 +',m.MULTI_MEMO'
                 +' from tq_id t'
                 +' inner join multimedia m'
                 +' on m.multi_clef=t.id2 where t.id1=5 order by m.multi_clef');
    try
      QIndi.Open;
      with QIndi do
      begin
        while not EOF do
        begin
          if ((rbCheminImages.ItemIndex=0)
              and (Length(FieldByName('MULTI_PATH').AsString)>0))
             or ((rbCheminImages.ItemIndex>0)
              and (length(FieldByName('MULTI_NOM').AsString)>0)) then
          begin
            FileWriteLn(F,ConversionToChaine('0 @M'+FieldByName('MULTI_CLEF').AsString
                    +'@ OBJE',fCharSet));
            if rbCheminImages.ItemIndex=0 then
              s:=FieldByName('MULTI_PATH').AsString
            else
              s:=lsNomDossierImages+'\'+FieldByName('MULTI_NOM').AsString;
            if rbJeuCarMacintosh.Checked then
              s:=StringReplace(s,'\','/',[rfReplaceAll]);
            FileWriteLn(F,ConversionToChaine('1 FILE '+s,fCharSet));
            n:=LastDelimiter('.',s);
            s:=Copy(s,n+1,4);
            if Length(s)>0 then
              FileWriteLn(F,ConversionToChaine('2 FORM '+s,fCharSet));
            s:=trim(FieldByName('MULTI_INFOS').AsString);
            if Length(s)>0 then
              FileWriteLn(F,ConversionToChaine('2 TITL '+s,fCharSet));
            s:=trim(FieldByName('MULTI_MEMO').AsString);
            if Length(s)>0 then
            begin
              PrepareTexte(TMemoField(FieldByName('MULTI_MEMO')),lignes,'NOTE',1);
              if lignes.count>0 then
                for n:=0 to lignes.count-1 do
                  FileWriteLn(F,ConversionToChaine(Lignes[n],fCharSet));
            end;
          end;
          Next;
          application.ProcessMessages;
        end;
      end;//de with QIndi do
      QIndi.Close;
    except
      cloture;
      FileClose(F);
      MyMessageDlg('L''exportation a échoué lors de l''exportation des médias'
                 , mtInformation, [mbOK], 0);
      exit;
    end;
  end;}

  FileWriteLn(F,ConversionToChaine('0 TRLR',fCharSet));
  FileClose(F);
  cloture;
  dm.doMAJTableJournal('Export GEDCOM du fichier '+SaveDialog.FileName);
  p_Finished;
end;

procedure TFExportGedcom.PrepareTexte(Blob:TMemoField;List:TStringlistUTF8;TagName:string;LevelTag:integer);
begin
  List.Clear;
  if not Blob.IsNull then
    PrepareMemo(Blob.AsString,List,TagName,LevelTag);
end;

procedure TFExportGedcom.PrepareMemo(Texte:string;List:TStringlistUTF8;TagName:string;LevelTag:integer);
const
  l=248;//longueur maxi d'une ligne
var
  s:string;
  n,p:integer;
begin
  List.Clear;
  if length(Texte)>0 then
  begin
    fTempLines.Text:=Texte;
    for n:=0 to fTempLines.Count-1 do
    begin
      s:=fTempLines[n];
      p:=1;
      repeat
        if List.Count=0 then
          List.Add(IntToStr(LevelTag)+' '+TagName+' '+Copy(s,1,l))
        else if p=1 then
          List.Add(IntToStr(LevelTag+1)+' '+'CONT'+' '+Copy(s,1,l))
        else
          List.Add(IntToStr(LevelTag+1)+' '+'CONC'+' '+Copy(s,1,l));
        if Length(s)>l then
          Delete(s,1,l)
        else
          s:='';
        inc(p);
      until s='';
    end;
  end;
end;

procedure TFExportGedcom.doExportHeader;
var
  s:string;
  n:integer;
  annees,mois,jour:Word;
begin
  FileWriteLn(F,ConversionToChaine('0 HEAD',fCharSet));
  FileWriteLn(F,ConversionToChaine('1 SOUR Ancestromania',fCharSet));
  FileWriteLn(F,ConversionToChaine('2 VERS Version '+gci_context.VersionExe,fCharSet));
  FileWriteLn(F,ConversionToChaine('2 NAME Ancestromania',fCharSet));
//  FileWriteLn(F,ConversionToChaine('2 CORP PCM. Universal',fCharSet)); // PCM.Universal, on ne se mouche pas du coude...
  FileWriteLn(F,ConversionToChaine('3 ADDR http://ancestrosphere.free.fr/forum/index.php',fCharSet));
//  FileWriteLn(F,ConversionToChaine('3 ADDR www.Ancestromania.net',fCharSet));
//  FileWriteLn(F,ConversionToChaine('3 PHON ',fCharSet));
  DecodeDate(now,annees,mois,jour);
  s:=inttostr(DayOfWeek(now))+' '+_GDate.MonthNum2MonthGedcom(mois)+' '+inttostr(annees);
  FileWriteLn(F,ConversionToChaine('1 DATE '+s,fCharSet));
  FileWriteLn(F,ConversionToChaine('2 TIME '+FormatDateTime('hh:nn:ss',now),fCharSet));
  FileWriteLn(F,ConversionToChaine('1 GEDC',fCharSet));
  FileWriteLn(F,ConversionToChaine('2 VERS 5.5',fCharSet));
  FileWriteLn(F,ConversionToChaine('2 FORM LINEAGE-LINKED',fCharSet));
  case fCharSet of
    ccWindows:FileWriteLn(F,ConversionToChaine('1 CHAR ANSI',fCharSet));
    ccMacintosh:FileWriteLn(F,ConversionToChaine('1 CHAR MACINTOSH',fCharSet));
    ccDOS:FileWriteLn(F,ConversionToChaine('1 CHAR IBMPC',fCharSet));
    ccANSEL:FileWriteLn(F,ConversionToChaine('1 CHAR ANSEL',fCharSet));
    ccUTF8:FileWriteLn(F,ConversionToChaine('1 CHAR UTF-8',fCharSet));
  end;
  FileWriteLn(F,ConversionToChaine('1 LANG FRENCH',fCharSet));
  FileWriteLn(F,ConversionToChaine('1 PLAC',fCharSet));
  if rbFormatGedcom.ItemIndex=0 then
    FileWriteLn(F,ConversionToChaine('2 FORM Ville,Code postal,Département,Région,Pays,Subdivision',fCharSet))
  else
    FileWriteLn(F,ConversionToChaine('2 FORM Ville,Code INSEE,Département,Région,Pays,Subdivision',fCharSet));
  if length(NotesAuteur.Text)>0 then
  begin
    PrepareMemo(NotesAuteur.Text,lignes,'NOTE',1);
    if lignes.count>0 then
      for n:=0 to lignes.count-1 do
        FileWriteLn(F,ConversionToChaine(lignes[n],fCharSet));
  end;

  if cbIndiquerCoord.checked then
    if length(trim(lbHeaderNom.Text)+trim(lbHeaderAddr1.Text)+trim(lbHeaderAddr2.Text)+trim(lbHeaderAddr3.Text)
      +trim(lbHeaderTel.Text)+trim(lbHeaderEMail.Text)+trim(lbHeaderSiteWeb.Text))>0 then
    begin
      FileWriteLn(F,ConversionToChaine('1 SUBM @S0@',fCharSet));
      FileWriteLn(F,ConversionToChaine('0 @S0@ SUBM',fCharSet));
      if length(trim(lbHeaderNom.text))>0 then
        FileWriteLn(F,ConversionToChaine('1 NAME '+trim(lbHeaderNom.Text),fCharSet));
      if length(trim(lbHeaderAddr1.text))>0 then
        FileWriteLn(F,ConversionToChaine('1 ADDR '+trim(lbHeaderAddr1.Text),fCharSet));
      if length(trim(lbHeaderAddr2.text))>0 then
        FileWriteLn(F,ConversionToChaine('2 CONT '+trim(lbHeaderAddr2.Text),fCharSet));
      if length(trim(lbHeaderAddr3.text))>0 then
        FileWriteLn(F,ConversionToChaine('2 CONT '+trim(lbHeaderAddr3.Text),fCharSet));
      if length(trim(lbHeaderTel.text))>0 then
        FileWriteLn(F,ConversionToChaine('1 PHON '+trim(lbHeaderTel.Text),fCharSet));
      if length(trim(lbHeaderEMail.text))>0 then
        FileWriteLn(F,ConversionToChaine('1 EMAIL '+trim(lbHeaderEMail.Text),fCharSet));
      if length(trim(lbHeaderSiteWeb.text))>0 then
        FileWriteLn(F,ConversionToChaine('1 WWW '+trim(lbHeaderSiteWeb.Text),fCharSet));
    end;
end;

procedure TFExportGedcom.rbJeuCarWindowsClick(Sender:TObject);
begin
  fCharSet:=ccWindows;
end;

procedure TFExportGedcom.rbJeuCarMacintoshClick(Sender:TObject);
begin
  fCharSet:=ccMacintosh;
end;

procedure TFExportGedcom.rbJeuCarMSDOSClick(Sender:TObject);
begin
  fCharSet:=ccDOS;
end;

procedure TFExportGedcom.rbJeuCarAnselClick(Sender:TObject);
begin
  fCharSet:=ccANSEL;
end;

procedure TFExportGedcom.rbJeuCarUtf8Click(Sender: TObject);
begin
  fCharSet:=ccUTF8;
end;

procedure TFExportGedcom.btnSelectFileClick(Sender:TObject);
var
  ok:boolean;
  s:string;
  annees,mois,jour:Word;
begin
  SaveDialog.InitialDir:=gci_context.PathImportExport;
  s:=CorrigeNomFich(fNomDossier);
  if cbAjouterDate.Checked then //AL 2009
   Begin
     DecodeDate(now,annees,mois,jour);
     SaveDialog.FileName:=s+IntToStr(annees)
       +RightStr('0'+IntToStr(mois),2)+RightStr('0'+IntToStr(jour),2)
   end
  else
    SaveDialog.FileName:=s;
  with SaveDialog do
  if execute then
  begin
    if FileExistsUTF8(FileName) then
     Begin
       // verify
       FDirectoryImages := SaveDialog.FileName;
       if  ( rbCheminImages.ItemIndex > 0 )
       and dm.PrepareExportImages ( RepBaseMedia,FDirectoryImages )
       and DirectoryExistsUTF8(FDirectoryImages)
         then Ok:=MyMessageDlg(fs_remplaceMsg(rs_Warning_file_and_directory_already_exists_do_you_overwrite_it,
                                              [FileName,FDirectoryImages])
                               ,mtWarning, [mbYes,mbNo])=mrYes;


         end
         Else Ok:=MyMessageDlg(rs_Warning_file_already_exists_do_you_overwrite_it,mtWarning, [mbYes,mbNo])=mrYes
     end
    else
      ok:=true;
  if ok then
    begin
      edPathFileNameGED.Text:=SaveDialog.FileName;
      fMaxNumEtapePossible:=1000;
    end;
  DoRefreshControls;
end;

procedure TFExportGedcom.btnSelectIndiDepartClick(Sender:TObject);
var
  aFIndividuRepertoire:TFIndividuRepertoire;
begin
  aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
  try
    aFIndividuRepertoire.Position:=poMainFormCenter;
    aFIndividuRepertoire.InitIndividuPrenom('A','',0,0,False,True);
    aFIndividuRepertoire.Caption:=rs_Caption_Select_starting_person;

    if aFIndividuRepertoire.ShowModal=mrOk then
    begin
      fCleIndiDepart:=aFIndividuRepertoire.ClefIndividuSelected;
      fNameIndiDepart:=aFIndividuRepertoire.NomPrenomIndividuSelected;
    end;
  finally
    FreeAndNil(aFIndividuRepertoire);
  end;
  DoRefreshControls;
end;

procedure TFExportGedcom.btnNewExportClick(Sender:TObject);
begin
  fMaxNumEtapePossible:=4;
  btnNewExport.visible:=false;
  lbEportEnCours.visible:=true;
  lbExportOk.visible:=false;
  FWFSee.Visible:=False;
  edPathFileNameGED.Text:='';
  GoToPage(0);
end;

function TFExportGedcom.CanSetCleFicheFromFavoris:boolean;
begin
  result:=rbExportBranche.checked and(Notebook.PageIndex=0);
end;

procedure TFExportGedcom.LabelMediasClick(Sender:TObject);
begin
  MyShowMessage(fs_remplaceMsg(rs_Message_Exporting_Medias,[ShapeMedias.Hint]));
end;

procedure TFExportGedcom.cbIndisConfidentielsClick(Sender:TObject);
begin
  cbIdentConfidentiels.Enabled:=cbIndisConfidentiels.Checked;
end;

procedure TFExportGedcom.cbImportEventClick(Sender: TObject);
begin
  cbExportDomiciles.Enabled:=cbImportEvent.Checked;
end;

end.
