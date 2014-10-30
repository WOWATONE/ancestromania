unit u_Form_Histoire;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms, U_FormAdapt,
  Dialogs, DB,
  u_framework_components,
  U_ExtDBImage, u_extdbgrid, ExtCtrls,
  u_framework_dbcomponents, u_ancestropictbuttons,
  u_buttons_appli, U_OnFormInfoIni, IBQuery, IBUpdateSQL,
  Menus, IBDatabase, DBCtrls;

type

  { TFHistoire }

  TFHistoire = class(TF_FormAdapt)
    btnAjout: TFWAdd;
    btnCategorie: TFWFolder;
    btnDelete: TFWDelete;
    btnExport: TFWExport;
    btnHistoire: TXAHistory;
    btnImport: TFWImport;
    cxDBImage1: TExtDBImage;
    cxLabel2: TFWLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    dsHistoire: TDataSource;
    OnFormInfoIni: TOnFormInfoIni;
    Panel2: TPanel;
    Panel3: TPanel;
    pListe: TPanel;
    cxGrid1: TExtDBGrid;
    pPhotoDate: TPanel;
    ibHistoire: TIBQuery;
    Panel1: TPanel;
    PanelTexte: TPanel;
    Splitter1: TSplitter;
    uHistoire: TIBUpdateSQL;
    cxDBMemo1: TFWDBMemo;
    ibHistoireHI_ID: TLongintField;
    ibHistoireHI_DOSSIER: TLongintField;
    ibHistoireHI_DICORIGINE: TStringField;
    ibHistoireHI_DATE_TEXTE: TStringField;
    ibHistoireHI_CAT: TLongintField;
    ibHistoireHI_TITRE: TStringField;
    ibHistoireHI_DATE_CODE_DEBUT: TLongintField;
    QBlob: TIBQuery;
    DSBlob: TDataSource;
    QBlobHI_TEXTE: TMemoField;
    QBlobHI_IMAGE: TBlobField;
    pmCategories: TPopupMenu;
    mTous: TMenuItem;
    mActivitesEconomiques: TMenuItem;
    mArtsEtLettres: TMenuItem;
    mCalamites: TMenuItem;
    Histoire1: TMenuItem;
    mPersonnalites: TMenuItem;
    mReligions: TMenuItem;
    mSciencesTechniques: TMenuItem;
    mVieQuotidienne: TMenuItem;
    mInfosGenealogiques: TMenuItem;
    TransHistoire: TIBTransaction;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure colDateDrawColumnCell(Sender: TObject;
      ACanvas: TCanvas; AViewInfo: longint; var ADone: boolean);
    procedure btnAjoutClick(Sender: TObject);
    procedure dbListeDblClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnHistoireClick(Sender: TObject);
    procedure cxComboBox1PropertiesChange(Sender: TObject);
    procedure doMajBouton;
    procedure ibHistoireAfterScroll(DataSet: TDataSet);
    procedure lTitreClick(Sender: TObject);
    procedure mTousClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure doOpenQueries;
    function Categorie: integer;

  public
    { Déclarations publiques }
    procedure doPosition(iID, iMode: integer);
  end;

implementation

uses  u_Dm,
      u_Form_Histoire_Detail,
      u_Form_Main,
      u_common_functions,
      u_Common_Const,
      u_common_ancestro,
      u_Form_Histoire_Export,
      u_Form_Histoire_Import,
      u_common_ancestro_functions,
      u_genealogy_context,
      lazutf8classes,
      IBSQL,
      fonctions_string,
      fonctions_dialogs,
      FileUtil;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFHistoire.FormCreate(Sender: TObject);
begin
  Color := gci_context.ColorLight;
  DBText2.Color := gci_context.ColorMedium;
  cxDBImage1.ShowHint := True;
  cxGrid1.ShowHint := True;
  ibHistoire.Database:=dm.ibd_BASE;
  QBlob.Database:=dm.ibd_BASE;
  TransHistoire.DefaultDatabase:=dm.ibd_BASE;
  TransHistoire.Active := True;
end;

procedure TFHistoire.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ibHistoire.Close;
  TransHistoire.Commit;
  Action := caFree;
  DoSendMessage(FMain, 'FERME_HISTOIRE');
end;

procedure TFHistoire.FormActivate(Sender: TObject);
begin
  ibHistoire.AfterScroll := ibHistoireAfterScroll;
  ibHistoireAfterScroll ( ibHistoire );
end;

procedure TFHistoire.FormDeactivate(Sender: TObject);
begin
  ibHistoire.AfterScroll := nil;
end;



procedure TFHistoire.FormShow(Sender: TObject);
//var l_c_memory_stream: TMemoryStream;
begin
  //FMain.MemeMoniteur(self);
  doOpenQueries;
{  QBlob1.Open;
  l_c_memory_stream:= TMemoryStream.Create;
  try
  while not QBlob1.Eof do
   Begin
    if not QBlob1.FieldbyName ('hi_image').ISNull Then
     Begin
       QBlob.Close;
       QBlob.Params[1].Asinteger:=QBlob1.FieldByname ( 'hi_id' ).AsInteger;
       QBlob.Open;
       (TBlobField(QBlob1.FieldbyName ('hi_image'))).SaveToStream ( l_c_memory_stream );
       QBlob.Edit;
       l_c_memory_stream.Position:=0;
       (TBlobField(QBlob.FieldbyName ('hi_image'))).LoadFromStream ( l_c_memory_stream );
       QBlob.Post;
     end;
    QBlob1.Next;
   end;
  Finally
    l_c_memory_stream.Free;
  End;
  transhistoire.CommitRetaining;}
end;

procedure TFHistoire.colDateDrawColumnCell(Sender: TObject;
  ACanvas: TCanvas; AViewInfo: longint; var ADone: boolean);
begin
  acanvas.Font.Style := [fsBold];
  acanvas.Brush.Color := $00F4FFE6;
end;

procedure TFHistoire.btnAjoutClick(Sender: TObject);
var
  aFormHistoireDetail: TFormHistoireDetail;
begin
  aFormHistoireDetail := TFormHistoireDetail.Create(self);
  try
    CentreLaFiche(aFormHistoireDetail, self, 0, 0);
    aFormHistoireDetail.ShowModal;
    if aFormHistoireDetail.bModif then
    begin
      doOpenQueries;
      with aFormHistoireDetail.qHistoireHI_ID do
        if AsInteger > 0 then
          ibHistoire.locate('HI_ID', AsInteger, []);
    end;
  finally
    FreeAndNil(aFormHistoireDetail);
  end;
  SendFocus(cxGrid1);
end;

procedure TFHistoire.dbListeDblClick(Sender: TObject);
begin
  btnAjoutClick(Sender);
end;

procedure TFHistoire.btnDeleteClick(Sender: TObject);
begin
  if MyMessageDlg(rs_Youll_delete_the_record_of_this_event + _CRLF + _CRLF +
    rs_Do_you_continue, mtWarning, [mbYes, mbNo], self) = mrYes then
  begin
    ibHistoire.Delete;
    TransHistoire.CommitRetaining;
    btnDelete.Enabled := not ibHistoire.IsEmpty;
  end;
end;

procedure TFHistoire.btnExportClick(Sender: TObject);
var
  q: TIBQuery;
  sChaine: string;
  iVal: integer;
  B: TFileStreamUTF8;
  T: TMemoryStream;
  L: longint;
  aFHistoireExport: TFHistoireExport;
  bImport: boolean;
  iNumDossier: integer;
  sDico, sFichier: string;
begin
  aFHistoireExport := TFHistoireExport.Create(self);
  try
    aFHistoireExport.ShowModal;
    bImport := aFHistoireExport.bImport;
    iNumDossier := aFHistoireExport.iNumDossier;
    sDico := aFHistoireExport.sDico;
    sFichier := aFHistoireExport.sFichier;
  finally
    FreeAndNil(aFHistoireExport);
  end;

  if bImport then
  begin
    if length(sFichier) < 5 then
      sFichier := 'Histoire.dica';

    q := TIBQuery.Create(self);
    with q do
    try
      Database := dm.ibd_BASE;
      Transaction := TransHistoire;
      SQL.Clear;
      SQL.Add('select hi_dicorigine' + ',hi_date_texte' +
        ',hi_cat' + ',hi_titre' + ',hi_texte' + ',hi_image'
        + ' from ref_histoire' + ' where hi_dossier=' + IntToStr(iNumDossier));

      if Length(sDico) > 0 then
        SQL.Add('and hi_dicorigine=''' + sDico + '''');

      SQL.Add('order by hi_date_code_debut');
      Open;
      Last;
      First;

      if IsEmpty then
      begin
        ShowMessage('Rien à exporter');
        Close;
        exit;
      end;

      sFichier := ChangeFileExt(sFichier, '.dica');
      Screen.Cursor := crHourGlass;
      B := TFileStreamUTF8.Create(sFichier, fmCreate);
      try
        T := TMemoryStream.Create;
        try
          while not EOF do
          begin
            sChaine := '';
            sChaine := (FieldByName('hi_dicorigine').AsString);
            L := Length(sChaine);
            B.WriteBuffer(L, SizeOf(L));
            B.WriteBuffer(Pointer(sChaine)^, L);

            sChaine := '';
            sChaine := (FieldByName('hi_date_texte').AsString);

            L := Length(sChaine);
            B.WriteBuffer(L, SizeOf(L));
            B.WriteBuffer(Pointer(sChaine)^, L);

            iVal := FieldByName('hi_cat').AsInteger;
            B.WriteBuffer(iVal, sizeOf(ival));

            sChaine := '';
            sChaine := (FieldByName('hi_titre').AsString);
            L := Length(sChaine);
            B.WriteBuffer(L, SizeOf(L));
            B.WriteBuffer(Pointer(sChaine)^, L);

            T.Clear;
            TBlobField(FieldByName('hi_texte')).SaveToStream(T);
            iVal := T.Position;
            B.WriteBuffer(iVal, 4);

            if not FieldByName('hi_texte').IsNull then
              TBlobField(FieldByName('hi_texte')).SaveToStream(B);

            T.Clear;
            TBlobField(FieldByName('hi_image')).SaveToStream(T);
            iVal := T.Position;
            B.WriteBuffer(iVal, 4);

            if not FieldByName('hi_image').IsNull then
              TBlobField(FieldByName('hi_image')).SaveToStream(B);

            Next;
          end;
          Close;
        finally
          T.Free;
        end;
      finally
        B.Free;
        Screen.Cursor := crDefault;
      end;
      MyMessageDlg(rs_History_File_has_got_this_name + _CRLF + sFichier, mtInformation,
        [mbOK], self);
    finally
      Free;
    end;
  end;
end;

procedure TFHistoire.btnImportClick(Sender: TObject);
var
  q: TIBQuery;
  dossier, dico, chaine: string;
  L: integer;
  B: TFileStreamUTF8;
  Tampon: TMemoryStream;
  aFHistoireImport: TFHistoireImport;
  bImport: boolean;
  sFichier: string;
  iNumDossier: integer;

  function ReadAnsiString(Stream: TFileStreamUTF8): string;
  var
    Len: integer;
  begin
    Stream.ReadBuffer(Len, 4);
    SetLength(Result, Len);
    Stream.ReadBuffer(Result[1], Len);
  end;

begin
  L := 0;

  aFHistoireImport := TFHistoireImport.Create(self);
  try
    aFHistoireImport.ShowModal;
    bImport := aFHistoireImport.bImport;
    iNumDossier := aFHistoireImport.iNumDossier;
    sFichier := aFHistoireImport.sFichier;
  finally
    FreeAndNil(aFHistoireImport);
  end;

  if bImport then
  begin
    if not FileExistsUTF8(sFichier) { *Converted from FileExistsUTF8*  } then
    begin
      ShowMessage('Le fichier : ' + sFichier + ' est introuvable...');
      exit;
    end;

    screen.Cursor := crHourGlass;
    try

      B := TFileStreamUTF8.Create(sFichier, fmOpenRead);
      try
        B.Seek(0, soFromBeginning);
        dossier := IntToStr(iNumDossier);
        q := TIBQuery.Create(self);
        try
          q.database := dm.ibd_BASE;
          q.Transaction := TransHistoire;

          if dossier = '0' then
          begin
            dico := ReadAnsiString(B);
            q.SQL.Add('delete from ref_histoire' +
              ' where hi_dossier = 0 and hi_dicorigine=''' + dico + '''');
            q.ExecSQL;
          end;

          q.SQL.Clear;
          q.SQL.Add('insert into ref_histoire (' + 'hi_dossier'
            + ',hi_dicorigine' + ',hi_date_texte' +
            ',hi_cat' + ',hi_titre' + ',hi_texte' +
            ',hi_image' + ')' + ' values(' + dossier
            + ',:hi_dicorigine' + ',:hi_date_texte' +
            ',:hi_cat' + ',:hi_titre' + ',:hi_texte' +
            ',:hi_image' + ')');

          Tampon := TMemoryStream.Create;
          try
            B.Seek(0, soFromBeginning);
            while B.Position < B.Size do
            begin
              chaine := '';
              chaine := ReadAnsiString(B);
              q.ParamByName('hi_dicorigine').AsString := chaine;

              chaine := '';
              chaine := ReadAnsiString(B);
              q.ParamByName('hi_date_texte').AsString := chaine;

              B.ReadBuffer(L, 4);

              q.ParamByName('hi_cat').AsInteger := L;

              chaine := '';
              chaine := ReadAnsiString(B);
              q.ParamByName('hi_titre').AsString := chaine;

              B.ReadBuffer(L, 4);

              if L = 0 then
                q.ParamByName('hi_texte').Value := Null
              else
              begin
                tampon.Clear;
                tampon.CopyFrom(B, L);
                tampon.Seek(0, soFromBeginning);
                q.ParamByName('hi_texte').LoadFromStream(tampon, ftMemo);
              end;

              B.ReadBuffer(L, 4);

              if L = 0 then
                q.ParamByName('hi_image').Value := Null
              else
              begin
                tampon.Clear;
                tampon.CopyFrom(B, L);
                tampon.Seek(0, soFromBeginning);
                q.ParamByName('hi_image').LoadFromStream(tampon, ftBlob);
              end;
              q.ExecSQL;
            end;
            tampon.Clear;
          finally
            tampon.Free;
          end;
          q.Close;
        finally
          q.Free;
        end;
      finally
        B.Free;
      end;
      TransHistoire.CommitRetaining;

      doOpenQueries;
    finally
      screen.Cursor := crDefault;
    end;
    MyMessageDlg(rs_This_file_has_been_imported_with_success, mtInformation,
      [mbOK], self);
  end;
end;

procedure TFHistoire.doPosition(iID, iMode: integer);
var
  q: TIBSQL;
  ilID: integer;
begin
  q := TIBSQL.Create(Application);
  try
    q.DataBase := dm.ibd_BASE;
    q.Transaction := TransHistoire;
    if iMode = 0 then
      q.SQL.Text := 'select first(1)hi_id from ref_histoire h' +
        ',(select ev_ind_date_year as ev_year' + ',ev_ind_date_mois as ev_mois'
        + ',ev_ind_date_jour as ev_jour ' +
          ',ev_ind_calendrier1 as ev_cal ' +
        'from evenements_ind where ev_ind_clef=:evenement)e'
    else
      q.SQL.Text := 'select first(1)hi_id from ref_histoire h' +
        ',(select ev_fam_date_year as ev_year' + ',ev_fam_date_mois as ev_mois'
        + ',ev_fam_date_jour as ev_jour ' +
          ',ev_fam_calendrier1 as ev_cal ' +
        'from evenements_fam where ev_fam_clef=:evenement)e';

    q.SQL.Add('where h.hi_dossier in (0,' + IntToStr(dm.NumDossier) +
      ')' + 'and h.hi_date_code_debut<=(select date_code from proc_date_code(e.ev_year,e.ev_mois,e.ev_jour,2,ev_cal))');
    if Categorie <> 0 then
      q.SQL.Add('and HI_CAT=' + IntToStr(Categorie));
    q.SQL.Add('order by hi_date_code_debut desc');
    q.Params[0].AsInteger := iID;
    try
      q.ExecQuery;
      ilID := q.Fields[0].AsInteger;
    except
      ilID := 0;
    end;
    q.Close;
  finally
    q.Free;
  end;

  if not ibHistoire.Active then
    doOpenQueries;
  ibHistoire.AfterScroll:=nil;
  ibHistoire.DisableControls;
  try
    if ilID > 0 then
      ibHistoire.locate('HI_ID', ilID, []);
  finally
    ibHistoire.EnableControls;
  end;
  doMajBouton;
  if Active and Visible then
    cxGrid1.SetFocus;
end;

procedure TFHistoire.doOpenQueries;
begin
  ibHistoire.DisableControls;
  with ibHistoire do
    try
      QBlob.DisableControls;
      QBlob.Close;
      Close;
      SQL.Text := 'select hi_id,hi_dossier,hi_dicorigine,hi_date_texte,hi_cat,hi_titre'
        + ',hi_date_code_debut' + ' from ref_histoire where hi_dossier in (0,' +
        IntToStr(dm.NumDossier) + ')';

      if Categorie <> 0 then
        SQL.Add('and hi_cat=' + IntToStr(Categorie));

      SQL.Add('order by hi_date_code_debut');
      Open;
      QBlob.EnableControls;
    finally
      ibHistoire.EnableControls;
    end;

  case ibHistoire.RecordCount of
    0: Caption := rs_Caption_History_No_event;
    1: Caption := rs_Caption_History_One_event;
    else
      Caption := fs_RemplaceMsg(rs_Caption_History_Events,
        [IntToStr(ibHistoire.RecordCount)]);
  end;
  cxLabel2.Visible := IBHistoire.RecordCount <= 0;
  if Categorie = 0 then
  begin
    cxLabel2.Font.Style := [fsBold];
    cxLabel2.Caption := rs_Caption_History_module_is_empty_Clic_on_Import_button;
  end
  else
  begin
    cxLabel2.Font.Style := [];
    cxLabel2.Caption := rs_Caption_History_No_event_in_folder_change_folder_or_import;
  end;
  with ibHistoire do
    Begin
      btnExport.Enabled := not IsEmpty;
      btnHistoire.Enabled := not IsEmpty;
      btnDelete.Enabled := not IsEmpty;
    end;
end;

procedure TFHistoire.btnHistoireClick(Sender: TObject);
var
  an, mois, jour: integer;
begin
  DecodeDateCode(ibHistoireHI_DATE_CODE_DEBUT.AsInteger, an, mois, jour,cGRE);
  GoToThisUrl(URL_WIKIPEDIA + IntToStr(an));
end;

procedure TFHistoire.cxComboBox1PropertiesChange(Sender: TObject);
begin
  doOpenQueries;
end;

procedure TFHistoire.doMajBouton;
var
  an, mois, jour: integer;
begin
  DecodeDateCode(ibHistoireHI_DATE_CODE_DEBUT.AsInteger, an, mois, jour,cGRE);
  btnHistoire.Hint := rs_Hint_Story_of_year + IntToStr(an);
  QBlob.DisableControls;
  with QBlob do
    try
      Close;
      Params[0].AsInteger := ibHistoirehi_id.AsInteger;
      Open;

    finally
      EnableControls;
    end;
end;

procedure TFHistoire.ibHistoireAfterScroll(DataSet: TDataSet);
begin
  doMajBouton;
end;

procedure TFHistoire.lTitreClick(Sender: TObject);
begin

end;

function TFHistoire.Categorie: integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to pmCategories.Items.Count - 1 do
    if pmCategories.Items[i].Checked then
    begin
      Result := i;
      Break;
    end;
end;

procedure TFHistoire.mTousClick(Sender: TObject);
var
  i: integer;
begin
  btnCategorie.Hint := rs_Hint_Events_folder + (Sender as TMenuItem).Caption;
  for i := 0 to pmCategories.Items.Count - 1 do
    pmCategories.Items[i].Checked := (pmCategories.Items[i] = (Sender as TMenuItem));
  doOpenQueries;
end;

end.


















