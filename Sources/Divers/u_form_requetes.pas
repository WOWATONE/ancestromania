unit u_form_requetes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf, LCLType,
  SysUtils,Classes,Graphics,Controls,Forms,
  Dialogs,U_FormAdapt,ExtCtrls,
  DB, ComCtrls,IBQuery,Menus,
  StdCtrls,u_buttons_appli, VirtualTrees, u_ancestropictimages,
  DBGrids, U_OnFormInfoIni, IBSQL,IBDatabase, Grids;

type
  TCustField = Record
    Nom ,
    Def : String;
  end;
  PCustField = ^TCustField ;

  { TFRequete }

  TFRequete=class(TF_FormAdapt)
    cxSplitter2: TSplitter;
    OnFormInfoIni: TOnFormInfoIni;
    PageControlRequete:TPageControl;
    PageRequete:TTabSheet;
    PageResultats:TTabSheet;
    PanelBas:TPanel;
    PanReferences:TPanel;
    TVProcedures:TVirtualStringTree;
    QResultats:TIBQuery;
    PanTables:TPanel;
    PanProcedures:TPanel;
    TVTables:TVirtualStringTree;
    cxSplitter1:TSplitter;
    btnFermer:TFWClose;
    BtnInformations:TIAInfo;
    MemoSQL:TMemo;
    PmEditSQL:TPopupMenu;
    mEditCouper:TMenuItem;
    mEditCopier:TMenuItem;
    mEditColler:TMenuItem;
    N1:TMenuItem;
    mEditSelectionnerTout:TMenuItem;
    mEditAnnuler:TMenuItem;
    N2:TMenuItem;
    OpenDialogSQL:TOpenDialog;
    N3:TMenuItem;
    mChargerSQL:TMenuItem;
    mSauvegarderSQL:TMenuItem;
    SaveDialogSQL:TSaveDialog;
    GridResultats:TDBGrid;
    DataSource:TDataSource;
    btnAppliquer:TFWOK;
    pmResultats:TPopupMenu;
    mExportHTML:TMenuItem;
    SaveDialogHTML:TSaveDialog;
    mExportXLS:TMenuItem;
    TransactionPropre:TIBTransaction;
    mExcuterScript: TMenuItem;
    N4: TMenuItem;
    IBQuery: TIBSQL;
    procedure GridResultatsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure PageControlRequeteDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
    procedure TVProceduresDrawColumnCell(Sender:TObject;
      ACanvas:TCanvas;
      var ADone:Boolean);
    procedure TVProceduresDblClick(Sender:TObject);
    procedure TVProceduresPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure TVTablesDblClick(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure PanReferencesResize(Sender:TObject);
    procedure BtnInformationsClick(Sender:TObject);
    procedure PmEditSQLPopup(Sender:TObject);
    procedure mEditCouperClick(Sender:TObject);
    procedure mEditCopierClick(Sender:TObject);
    procedure mEditCollerClick(Sender:TObject);
    procedure mEditSelectionnerToutClick(Sender:TObject);
    procedure mEditAnnulerClick(Sender:TObject);
    procedure mChargerSQLClick(Sender:TObject);
    procedure mSauvegarderSQLClick(Sender:TObject);
    procedure btnAppliquerClick(Sender:TObject);
    procedure mExportHTMLClick(Sender:TObject);
    procedure mExportXLSClick(Sender:TObject);
    procedure PageControlRequeteChange(Sender:TObject);
    procedure pmResultatsPopup(Sender:TObject);
    procedure mExcuterScriptClick(Sender: TObject);
    procedure IBQueryExecuteError(Sender: TObject; Error, SQLText: String;
      LineIndex: Integer; var Ignore: Boolean);
    procedure IBQueryParseError(Sender: TObject; Error, SQLText: String;
      LineIndex: Integer);
    procedure TVTablesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
  private
    { Déclarations privées }
    NomFichierSQL:string;
    bExecReq:boolean;
    NbErreur:Integer;
    IgnoreErreur:Word;
    procedure p_TrimBeginingOfSQLMemo;
    procedure RempliTVTables;
    procedure RempliTVProcedures;
    procedure MetDansMemo(NouvText:string);
    procedure AfficherResultats;
    procedure InterroCommitOuRollback;
  public
    { Déclarations publiques }
    procedure InitRequete(TextReq:string;Execute:boolean);
  end;

implementation

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

uses u_dm,
     fonctions_components,
     fonctions_dialogs,
     u_common_ancestro,u_common_const,u_genealogy_context,
     u_common_ancestro_functions,
     IB,StrUtils,Clipbrd,fonctions_string;

procedure TFRequete.SuperFormCreate(Sender:TObject);
begin
  PageRequete.Color:=gci_context.ColorLight;
  PageResultats.Color:=gci_context.ColorLight;
  PanelBas.Color:=gci_context.ColorLight;
  //FMain.MemeMoniteur(self);
  PageResultats.Enabled:=false;
  NomFichierSQL:='';
  TVTables    .NodeDataSize := Sizeof(TCustField)+1;
  TVProcedures.NodeDataSize := Sizeof(TCustField)+1;
  if not dm.ibd_BASE.Connected then
  begin
    try
      dm.ibd_BASE.Open;
    except
    end;
  end;
  if not dm.ibd_BASE.Connected then
  begin
    MyMessageDlg( rs_Must_Select_A_Database
      ,mtError, [mbCancel],Self);
    Close;
    exit;
  end;
  Caption := fs_RemplaceMsg ( rs_Caption_Executing_requests_on_database, [dm.ibd_BASE.DatabaseName]);
  TransactionPropre.StartTransaction;
  bExecReq:=false;
end;

procedure TFRequete.GridResultatsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column=GridResultats.SelectedColumn then
    GridResultats.canvas.Brush.Color:=gci_context.ColorMedium;
end;

procedure TFRequete.SuperFormShow(Sender:TObject);
begin
  Screen.Cursor:=crSQLWait;
  PageControlRequete.ActivePage:=PageRequete;
  try
    RempliTVTables;
    RempliTVProcedures;
  finally
    Screen.Cursor:=crDefault;
  end;
  TVTables.ShowHint:=true;
  TVProcedures.ShowHint:=true;
  Application.ProcessMessages;
  if bExecReq then
    btnAppliquerClick(self)
  else
    BtnInformationsClick(self);
end;

procedure TFRequete.InitRequete(TextReq:string;Execute:boolean);
begin
  MemoSQL.Text:=TextReq;
  bExecReq:=Execute;
end;

procedure TFRequete.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  InterroCommitOuRollback;
end;

procedure TFRequete.PageControlRequeteDrawTabEx(
  AControl:TCustomTabControl;ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  // Matthieu
  {
  if ATab.IsMainTab then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
   }
end;

procedure TFRequete.TVProceduresDrawColumnCell(Sender: TObject;
  ACanvas: TCanvas; var ADone: Boolean);
begin

end;

{$WARNINGS OFF}

procedure TFRequete.RempliTVTables;
var
  q:TIBSQL;
  nom_table:string;
  Noeud,NoeudParent:PVirtualNode;
begin
  TVTables.BeginUpdate;
  TVTables.DisableAlign;
  with TVTables do
  try
    Clear;
    if not TransactionPropre.Active then
      TransactionPropre.StartTransaction;
    q:=TIBSQL.Create(self);
    with q do
    try
      Database:=dm.ibd_BASE;
      Transaction:=TransactionPropre;
      ParamCheck:=false;
      SQL.Text:='select trim(r.rdb$relation_name)'
        +',trim(p.rdb$field_name)||'' ['''
        +'||case f.rdb$field_type'
        +'  when 14 then ''CHAR(''||f.rdb$field_length||'')'''
        +'  when 37 then ''VARCHAR(''||f.rdb$field_length||'')'''
        +'  when 7 then ''SMALLINT'''
        +'  when 8 then ''INTEGER'''
        +'  when 16 then'
        +'    case f.rdb$field_sub_type'
        +'      when 1 then ''NUMERIC(''||f.rdb$field_precision||'',''||(-f.rdb$field_scale)||'')'''
        +'      when 2 then ''DECIMAL(''||f.rdb$field_precision||'',''||(-f.rdb$field_scale)||'')'''
        +'      else ''BIGINT'''
        +'    end'
        +'  when 27 then ''DOUBLE PRECISION'''
        +'  when 261 then ''BLOB SUB_TYPE ''||'
        +'    trim(case f.rdb$field_sub_type'
        +'      when 1 then ''TEXT'''
        +'      when 2 then ''BINARY'''
        +'      else ''INCONNU'''
        +'    end)'
        +'  else (select trim(rdb$type_name) from rdb$types where rdb$field_name=''RDB$FIELD_TYPE'''
        +'    and rdb$type=f.rdb$field_type)'
        +' end ||'']'''
        +',trim(p.rdb$field_name) '
        +'from rdb$relations r '
        +'left join rdb$relation_fields p on p.rdb$relation_name=r.rdb$relation_name '
        +'left join rdb$fields f on f.rdb$field_name=p.rdb$field_source '
        +'where r.rdb$system_flag=0 '
        +'order by r.rdb$relation_name,p.rdb$field_position';
      try
        ExecQuery;
        nom_table:='';
        while not Eof do
        begin
          if Fields[0].AsString<>nom_table then //nouvelle table
          begin
            NoeudParent:=TVTables.AddChild(nil);
            ValidateNode(NoeudParent,False);
            nom_table:=Fields[0].AsString;
            with PCustField ( GetNodeData( NoeudParent))^ do
             Begin
              Def := nom_table;
              Nom := '';
             end;
          end;
          if Fields[1].AsString>'' then
          begin
            Noeud:=TVTables.AddChild(NoeudParent);
            ValidateNode(Noeud,False);
            with PCustField ( GetNodeData( Noeud))^ do
             Begin
              Def := Fields[1].AsString;
              Nom := Fields[2].AsString;
             end;
          end;
          Next;
        end;
        Close;
        FullCollapse;
        FocusedNode := RootNode.FirstChild;
      except
        ShowMessage(fs_RemplaceMsg(rs_Error_request_execute,['"'+rs_List_of_tables+'"']));
      end;
    finally
      Free;
    end;
  finally
    EndUpdate;
    EnableAlign;
  end;
end;

procedure TFRequete.RempliTVProcedures;
var
  q:TIBSQL;
  nom_proc:string;
  Noeud,NoeudParent:PVirtualNode;
begin
  TVProcedures.BeginUpdate;
  TVProcedures.DisableAlign;
  with TVProcedures do
  try
    Clear;
    if not TransactionPropre.Active then
      TransactionPropre.StartTransaction;
    q:=TIBSQL.Create(self);
    with q do
    try
      Database:=dm.ibd_BASE;
      Transaction:=TransactionPropre;
      ParamCheck:=false;
      SQL.Text:='select trim(r.rdb$procedure_name)'
        +',trim(''(''||iif(p.rdb$parameter_type=0,''E'',''S'')||'') ''||p.rdb$parameter_name)||'' ['''
        +'||case f.rdb$field_type'
        +'  when 14 then ''CHAR(''||f.rdb$field_length||'')'''
        +'  when 37 then ''VARCHAR(''||f.rdb$field_length||'')'''
        +'  when 7 then ''SMALLINT'''
        +'  when 8 then ''INTEGER'''
        +'  when 16 then'
        +'    case f.rdb$field_sub_type'
        +'      when 1 then ''NUMERIC(''||f.rdb$field_precision||'',''||(-f.rdb$field_scale)||'')'''
        +'      when 2 then ''DECIMAL(''||f.rdb$field_precision||'',''||(-f.rdb$field_scale)||'')'''
        +'      else ''BIGINT'''
        +'    end'
        +'  when 27 then ''DOUBLE PRECISION'''
        +'  when 261 then ''BLOB SUB_TYPE ''||'
        +'    trim(case f.rdb$field_sub_type'
        +'      when 1 then ''TEXT'''
        +'      when 2 then ''BINARY'''
        +'      else ''INCONNU'''
        +'    end)'
        +'  else (select trim(rdb$type_name) from rdb$types where rdb$field_name=''RDB$FIELD_TYPE'''
        +'    and rdb$type=f.rdb$field_type)'
        +' end ||'']'''
        +',trim(p.rdb$parameter_name) '
        +'from rdb$procedures r '
        +'left join rdb$procedure_parameters p on p.rdb$procedure_name=r.rdb$procedure_name '
        +'left join rdb$fields f on f.rdb$field_name=p.rdb$field_source '
        +'where r.rdb$system_flag=0 '
        +'order by r.rdb$procedure_name,p.rdb$parameter_type,p.rdb$parameter_number';
      try
        ExecQuery;
        nom_proc:='';
        while not Eof do
        begin
          if Fields[0].AsString<>nom_proc then //nouvelle procédure
          begin
            nom_proc:=Fields[0].AsString;
            NoeudParent:=AddChild(nil);
            ValidateNode(NoeudParent,False);
            with PCustField ( GetNodeData( NoeudParent))^ do
             Begin
              Def := nom_proc;
              Nom := '';
             end;
          end;
          if Fields[1].AsString>'' then
          begin
            Noeud:=AddChild(NoeudParent);
            ValidateNode(Noeud,False);
            with PCustField ( GetNodeData( Noeud))^ do
             Begin
              Def := Fields[1].AsString;
              Nom := Fields[2].AsString;
             end;
          end;
          Next;
        end;
        Close;
        FullCollapse;
        FocusedNode := RootNode.FirstChild;
      except
        ShowMessage(fs_RemplaceMsg(rs_Error_request_execute,['"'+rs_List_of_procedures+'"']));
      end;
    finally
      Free;
    end;
  finally
    EndUpdate;
    EnableAlign;
  end;
end;

{$WARNINGS ON}

procedure TFRequete.TVProceduresDblClick(Sender:TObject);
var
  nom_objet,s:string;
  noeud,noeudfils:PVirtualNode;
  CustomerRecord : PCustField;
begin
  noeud:=TVProcedures.FocusedNode;
  CustomerRecord := TVProcedures.GetNodeData(noeud);
  nom_objet:=CustomerRecord.Def;
  if noeud.Parent=nil then
  begin
    nom_objet:=nom_objet+'(';
    s:='';
    noeudfils:=noeud.FirstChild;
    CustomerRecord := TVProcedures.GetNodeData(noeud);
    while noeudfils<>nil do
    begin
      if LeftStr(CustomerRecord.Nom,4)<>'(E) ' then
        Break;
      if s>'' then
        s:=s+',';
      s:=s+' :'+CustomerRecord.Def+' ';
      noeudfils:=noeudfils.NextSibling;
    end;
    nom_objet:=nom_objet+s+')';
  end;
  MetDansMemo(nom_objet);
end;

procedure TFRequete.TVProceduresPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Sender.Selected[Node] then
    TargetCanvas.Brush.Color:=gci_context.ColorMedium;

end;

procedure TFRequete.TVTablesDblClick(Sender:TObject);
var
  noeud:PVirtualNode;
  CustomerRecord : PCustField;
begin
  noeud:=TVTables.FocusedNode;
  CustomerRecord := TVProcedures.GetNodeData(noeud);
  MetDansMemo(CustomerRecord.Def);
end;

procedure TFRequete.MetDansMemo(NouvText:string);
begin
  MemoSQL.SelText:=' '+NouvText+' ';
  MemoSQL.SetFocus;
end;

procedure TFRequete.PanReferencesResize(Sender:TObject);
begin
  PanTables.Height:=PanReferences.ClientHeight div 2;
end;

procedure TFRequete.BtnInformationsClick(Sender:TObject);
begin
  MyMessageDlg(rs_Greetings_BOA
    ,mtInformation, [mbOK],Self);
end;

procedure TFRequete.PmEditSQLPopup(Sender:TObject);
var
  selection:boolean;
begin
  selection:=MemoSQL.SelLength>0;
  mEditCouper.Enabled:=selection;
  mEditCopier.Enabled:=selection;
  mEditColler.Enabled:=Clipboard.HasFormat(CF_TEXT);
  mEditAnnuler.Enabled:=MemoSQL.Modified;
end;

procedure TFRequete.mEditCouperClick(Sender:TObject);
begin
  MemoSQL.CutToClipboard;
end;

procedure TFRequete.mEditCopierClick(Sender:TObject);
begin
  MemoSQL.CopyToClipboard;
end;

procedure TFRequete.mEditCollerClick(Sender:TObject);
begin
  MemoSQL.PasteFromClipboard;
end;

procedure TFRequete.mEditSelectionnerToutClick(Sender:TObject);
begin
  MemoSQL.SelectAll;
end;

procedure TFRequete.mEditAnnulerClick(Sender:TObject);
begin
  MemoSQL.Undo;
end;

procedure TFRequete.mChargerSQLClick(Sender:TObject);
begin
  OpenDialogSQL.FileName:=NomFichierSQL;
  if NomFichierSQL>'' then
    OpenDialogSQL.InitialDir:=ExtractFileDir(NomFichierSQL)
  else
    OpenDialogSQL.InitialDir:=gci_context.PathDocs;
  if OpenDialogSQL.Execute then
  begin
    NomFichierSQL:=OpenDialogSQL.FileName;
    MemoSQL.Lines.LoadFromFile(NomFichierSQL);
  end;
end;

procedure TFRequete.mSauvegarderSQLClick(Sender:TObject);
begin
  SaveDialogSQL.FileName:=NomFichierSQL;
  if NomFichierSQL>'' then
    SaveDialogSQL.InitialDir:=ExtractFileDir(NomFichierSQL)
  else
    SaveDialogSQL.InitialDir:=gci_context.PathDocs;
  if SaveDialogSQL.Execute then
  begin
    NomFichierSQL:=SaveDialogSQL.FileName;
    MemoSQL.Lines.SaveToFile(NomFichierSQL);
  end;
end;

procedure TFRequete.AfficherResultats;
var
  NouvColonne:TColumn;
  i:integer;
  ok:boolean;
  s:string;
begin
  ok:=false;
  QResultats.DisableControls;
  try
    p_TrimBeginingOfSQLMemo;
    QResultats.SQL.Text:=MemoSQL.Text;
    try
      Screen.Cursor:=crSQLWait;
      try
        QResultats.Open;
        QResultats.Last;
        QResultats.First;
      finally
        Screen.Cursor:=crDefault;
      end;
      if not QResultats.IsEmpty then
      begin
        for i:=0 to QResultats.FieldCount-1 do
        begin
          NouvColonne:=GridResultats.Columns.Add;
          NouvColonne.FieldName:=QResultats.FieldDefs[i].Name;
          NouvColonne.Title.Caption:=NouvColonne.FieldName;
        end;
        if QResultats.RecordCount=1 then
          s:=rs_One_Record_Selected
        else
          s:=IntToStr(QResultats.RecordCount)+rs_Records_Selected;
        MyMessageDlg(s,mtInformation, [mbOK],self);
        ok:=true;
      end
      else
        MyMessageDlg(rs_No_result_With_Request,mtInformation, [mbOK],self);
    except
      on E:EIBError do
      begin
        MyMessageDlg(fs_RemplaceMsg(rs_Error_request_execute,[_CRLF+E.Message])
          ,mtError, [mbOK],self);
        ok:=false;
      end;
    end;
  finally
    QResultats.EnableControls;
  end;
  if ok then
  begin
    GridResultats.AutoSizeColumns();
    PageResultats.Enabled:=true;
    PageControlRequete.ActivePage:=PageResultats;
  end;
end;

procedure TFRequete.btnAppliquerClick(Sender:TObject);
var
  q:TIBSQL;
begin
  QResultats.DisableControls;
  InterroCommitOuRollback;//ferme QResultat
  PageControlRequete.ActivePage:=PageRequete;
  PageResultats.Enabled:=false;
  GridResultats.Clear;
  QResultats.EnableControls;
  Application.ProcessMessages;
  if not TransactionPropre.Active then
    TransactionPropre.StartTransaction;

  q:=TIBSQL.Create(self);
  with q do
  try
    Database:=dm.ibd_BASE;
    Transaction:=TransactionPropre;
    ParamCheck:=false;
    SQL.Text:=MemoSQL.Text;
    try
      Prepare;
      if SQLType=SQLSelect then
      begin
        Close;
        AfficherResultats
      end
      else
      begin
        try
          Screen.Cursor:=crSQLWait;
          try
            ExecQuery;
          finally
            Screen.Cursor:=crDefault;
          end;
          if SQL.count > 0 Then
            if pos ( 'select', LowerCase(SQL [ 0 ])) = 1
             Then TransactionPropre.RollbackRetaining
             Else if MyMessageDlg(rs_Request_Executed+_CRLF+_CRLF
              +rs_Do_you_Validate
              ,mtConfirmation, [mbYes,mbNo],Self)=mrYes
             then TransactionPropre.CommitRetaining
             else TransactionPropre.RollbackRetaining;
          Close;
          RempliTVTables;//rafraîchissement si modifications des tables ou procédures
          RempliTVProcedures;
        except
          on E:EIBError do
          begin
            MyMessageDlg(fs_RemplaceMsg(rs_Error_request_execute,[_CRLF+E.Message])
              ,mtError, [mbOK],Self);
          end;
        end;
      end;
    except
      on E:EIBError do
      begin
        MyMessageDlg(rs_Error_request_syntax+_CRLF+E.Message
          ,mtError, [mbOK],Self);
      end;
    end;
  finally
    Free;
  end;
end;

procedure TFRequete.PageControlRequeteChange(Sender:TObject);
begin
  if PageControlRequete.ActivePage=PageRequete then
  begin
    if MemoSQL.CanFocus then
      MemoSQL.SetFocus;
  end;
end;

procedure TFRequete.InterroCommitOuRollback;
begin
  with TransactionPropre,QResultats do
  if Active then
  begin
    if SQL.Count > 0 Then
      if pos ( 'select', LowerCase(QResultats.SQL [ 0 ])) = 1
       Then RollbackRetaining
        else if MyMessageDlg(rs_Previous_request_May_Modify_data+_CRLF+_CRLF
          +rs_Do_you_Validate
          ,mtConfirmation, [mbYes,mbNo],Self)=mrYes
        then CommitRetaining
        else RollbackRetaining;
  end;
  QResultats.Close;
end;


procedure TFRequete.mExportHTMLClick(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialogHTML.DefaultExt:=END_EXTENSION_HTML;
  SaveDialogHTML.FilterIndex:=1;
  SaveDialogHTML.FileName:=rs_File_Request_Result+EXTENSION_HTML;
  SaveDialogHTML.InitialDir:=gci_context.PathDocs;
  if SaveDialogHTML.Execute then
  begin
    QResultats.DisableControls;
    try
      SavePlace:=QResultats.GetBookmark;
      ExportGridToHTML(SaveDialogHTML.FileName,GridResultats,True,True);
    finally
      QResultats.GotoBookmark(SavePlace);
      QResultats.FreeBookmark(SavePlace);
      QResultats.EnableControls;
    end;
  end;
end;

procedure TFRequete.mExportXLSClick(Sender:TObject);
var
  SavePlace:TBookmark;
begin
  SavePlace:=nil;
  SaveDialogHTML.DefaultExt:='xls';
  SaveDialogHTML.FilterIndex:=2;
  SaveDialogHTML.FileName:='Resultat_requete.xls';
  SaveDialogHTML.InitialDir:=gci_context.PathDocs;
  if SaveDialogHTML.Execute then
  begin
    QResultats.DisableControls;
    try
      SavePlace:=QResultats.GetBookmark;
      ExportGridToCSV(SaveDialogHTML.FileName,GridResultats,True,True);
    finally
      QResultats.GotoBookmark(SavePlace);
      QResultats.FreeBookmark(SavePlace);
      QResultats.EnableControls;
    end;
  end;
end;

procedure TFRequete.pmResultatsPopup(Sender:TObject);
var
  b:boolean;
begin
  b:=not QResultats.IsEmpty;
  mExportHTML.enabled:=b;
  mExportXLS.Enabled:=b;
end;

procedure TFRequete.p_TrimBeginingOfSQLMemo;
Begin
  with MemoSQL,Lines do
   Begin
    while ( count > 0 ) and ( trim ( Lines [ 0 ]) = '' )
     do Delete(0);
    Lines [ 0 ]:=trim ( Lines [ 0 ]);
   end;

end;

procedure TFRequete.mExcuterScriptClick(Sender: TObject);
begin
  QResultats.DisableControls;
  InterroCommitOuRollback;//ferme QResultat
  PageControlRequete.ActivePage:=PageRequete;
  PageResultats.Enabled:=false;
  GridResultats.Clear;
  QResultats.EnableControls;
  Application.ProcessMessages;

  p_TrimBeginingOfSQLMemo;

  IBQuery.SQL.Text:=MemoSQL.Text;
  // Matthieu : IBSQL ?
//  IBQuery.Terminator:=';';
  NbErreur:=0;
  IgnoreErreur:=mrNo;
  if not TransactionPropre.Active then
    TransactionPropre.StartTransaction;
  try
    Screen.Cursor:=crSQLWait;
    try
      IBQuery.ExecQuery();
    finally
      Screen.Cursor:=crDefault;
    end;
    if NbErreur=0 then
    begin
      If TransactionPropre.Active then
      begin
        if MyMessageDlg(rs_Script_Executed+_CRLF+_CRLF
          +rs_Only_Modifying_from_last_commit_can_be_valided+_CRLF
          +rs_Do_you_Validate+_CRLF
          ,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
          TransactionPropre.Commit
        else
          TransactionPropre.Rollback;
      end
      else
      begin
        If TransactionPropre.Active then
          TransactionPropre.Commit;
        MyMessageDlg(rs_Script_Executed_Valided
          ,mtInformation, [mbOK],Self);
      end;
    end
    else
    begin
      if TransactionPropre.Active then
        TransactionPropre.Rollback;
      MyMessageDlg(rs_Execute_cancelled_due_to_error+_CRLF
        +rs_actions_executed_from_commit_have_been_cancelled
        ,mtError, [mbOK],Self);
    end;
  except
    on E:EIBError do
    begin
      if TransactionPropre.Active then
        TransactionPropre.Rollback;
      MyMessageDlg(rs_Error_script_execute+','+_CRLF
        +rs_actions_executed_from_commit_have_been_cancelled+_CRLF+E.Message
        ,mtError, [mbOK],Self);
    end;
  end;
  if dm.ibd_BASE.Connected then
    dm.ibd_BASE.Close; //permet de valider le script, sans celà conflit de transaction
  dm.ibd_BASE.Open;    //à l'exécution du script suivant
  RempliTVTables;//rafraîchissement si modifications des tables ou procédures
  RempliTVProcedures;
end;

procedure TFRequete.IBQueryExecuteError(Sender: TObject; Error,
  SQLText: String; LineIndex: Integer; var Ignore: Boolean);
begin
  if IgnoreErreur<>mrYesToAll then
  begin
    IgnoreErreur:=MyMessageDlg(rs_Error_execute_line+IntToStr(LineIndex)+'.'+_CRLF+Error+_CRLF+SQLText+_CRLF
      +rs_Do_you_continue_executing
      ,mtError,[mbYes,mbYesToAll,mbNo],Self);
    Application.ProcessMessages;
  end;

  Ignore:=IgnoreErreur<>mrNo;
  if not Ignore then
    Inc(NbErreur);
end;

procedure TFRequete.IBQueryParseError(Sender: TObject; Error,
  SQLText: String; LineIndex: Integer);
begin
  Inc(NbErreur);
  MyMessageDlg(rs_Error_syntax+_CRLF+Error+_CRLF+SQLText+_CRLF+'Ligne '+IntToStr(LineIndex)
    ,mtError,[mbOK],Self);
end;

procedure TFRequete.TVTablesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  with PCustField ( Sender.GetNodeData(Node))^ do
    Begin
      CellText:=def;
      if ( CellText > '' ) and ( Nom > '' ) Then
        AppendStr(CellText, ' - ' + nom);
    end;
end;


end.

