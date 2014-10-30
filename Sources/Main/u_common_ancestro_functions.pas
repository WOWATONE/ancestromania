{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{AL 2009 création nouvelles variables date, suppression _LastPosMiniature}
{-----------------------------------------------------------------------}

unit u_common_ancestro_functions;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
  {$IFNDEF FPC}
    Windows, Shlobj,
  {$ELSE}
    LCLIntf, LCLType,
  {$ENDIF}
  dialogs,
  IniFiles,
  classes,
  u_form_individu_Navigation,
  u_Form_Histoire,
  u_genealogy_context,
  u_objet_TGedcomDate,
  VirtualTrees,
  u_scrollclones,
  Forms,u_form_individu,
  u_common_const,IBSQL,
  DB,
  Process,
  URLLink,
  Controls,
  StdCtrls,
  U_ExtImage,
  fonctions_dialogs,
  U_ExtFileCopy,
  IBQuery;

type
  TTVNodeEve = record
     FKey,
     ImageIdx : Integer;
     FCaption : String ;
  end;
  PTVNodeEve = ^TTVNodeEve;


procedure p_RenameMediasPaths ( const IBMultimedia : TIBQuery; const IBMultimediaMULTI_NOM, IBMultimediaMULTI_PATH : TField ; const mem_full_renaming : TMemo ; const acontrol : TControl );
procedure p_AddToCombo ( const acb_combo : TComboBox; const as_Base : String ; const ab_SetIndex :Boolean = True);
function fb_getMediaFile ( const IBQ_Media : TIBQuery;
                           const afc_FileCopy : TExtFileCopy ;
                           const as_ExportPath, as_FolderPath : string ;
                           var as_FileNameBegin : String ;
                           const ab_noOriginal : Boolean ) : Boolean;
function SelectRepertoire(const TitreFonction:string;Var APath:string;Proprio:TForm=nil):Boolean;
procedure DefContextLangue;
procedure OuvreFicheIndividuModale(aCleFiche:integer);
procedure OpenFicheIndividuInBox(aCleFiche:integer);
procedure VisualiseMedia(NumMedia:integer;const IBQuery:TIBSQL);
function ComprImageInMS(const Fichier:string;var MS1:TMemoryStream;var MS2:TMemoryStream;
  const OkImg1:boolean=true;const H1:integer=140;const W1:integer=120;//vue réduite
  const OkImg2:boolean=false;const H2:integer=1024;const W2:integer=1024;//vue si image chargée, pas redimentionnée si H2 ou W2=0
  const Comprime:Boolean=True//si False MS2 sans compression
  ):boolean;
procedure ImprimeImage(NumMedia:integer;Nom:string);
function fb_FocusNode ( const tree : TVirtualStringTree; const SomeNode : PVirtualNode; const ai_cle : Integer ):Boolean;
procedure CloseFicheIndividuInBox;
function DefDateWriten(const LaDate:TDateTime):string;
function Age_Vivant(const Date_Nais:string;var AgeTexte:String):Integer;
function fs_Date2Str(const ADate:TDateTime):String;
function fs_Str2Date(const ADateStr:String):TDateTime;
function fs_DateTime2Str(const ADate:TDateTime):String;
function fs_Str2DateTime(const ADateStr:String):TDateTime;
function TreeAjouterEnfant(const TreeView:TVirtualStringTree;const Aparent:PVirtualNode):PVirtualNode;
//procedure p_FillTreeEvent ( const IBQEve : TIBQuery ; const tvEve : TVirtualStringTree ;  const ibqtitrevent : TField; const as_indfam : String = 'ind' );
function NbrProcess(NomExe:string):Integer;
function BcdIsValide(const Value:Variant;const Precision:Integer=11;const Echelle:Integer=8):Boolean;
function MSimage2FichTemp(MS:TMemoryStream;var NomFich:string):Boolean;
procedure p_FillClonesEvent ( const IBQEve : TIBQuery ; const GdEve : TExtClonedPanel ; const ALabel : TLabel; const URLink1,URLink2 : TURLLink; const Image1, Image2, Image3 : TExtImage; const ibqtitrevent : TField; const as_indfam : String = 'ind' );


var
  aFIndDlg:TFIndividu;
  _FormNavigation:TFIndividuNavigation;
  _FormHistoire:TFHistoire=nil;
  _SeparateurDate:string;
  _FileNamePartenaires:string;
  _TempPath:string;
  _Ok_Supprime_TempPath:boolean;
  _Mutex:THandle;
   AProcess : TProcess;
  _utilEstAdmin:boolean;

implementation

uses
  SysUtils,
  LazUTF8,
  u_connexion,
  u_common_functions,
  u_firebird_functions,
  u_Form_select_rep,
  u_form_main,
  fonctions_net,
  fonctions_languages,
  fonctions_system,u_extimagelist, u_dm,
  ExtCtrls,
  u_form_biblio_Multimedia_Edit,
  {$IFNDEF IMAGING}
  bgrabitmap,
  bgrabitmaptypes,
  FPWriteJpeg,
  {$ELSE}
    ImagingTypes,
    Imaging,
  {$ENDIF}
  Math,
  {$IFDEF WINDOWS}
  {$IFDEF FPC}
  JwaTlHelp32, Windows,
  {$ENDIF}
  {$ENDIF}
  fonctions_string, FileUtil,
  u_common_ancestro,
  IBIntf, fonctions_init,
  fonctions_images, u_objet_TMotsClesDate,
  u_gedcom_const,
  fonctions_reports,
  fonctions_db,fonctions_file,FMTBcd;

const CST_DateFormat =  'YYYY-mm-dd';
      CST_DateTimeFormat =  'YYYY/MM/DD hh:nn:ss';
      CST_TimeFormat =  'hh:nn:ss';

var
  BaseReseau:boolean;


{
procedure p_FillTreeEvent ( const IBQEve : TIBQuery ; const tvEve : TVirtualStringTree ; const ibqtitrevent : TField; const as_indfam : String = 'ind' );
var ANode : PVirtualNode;
    AbookMark : TBookmark;
  procedure AppendCaption( var FCaption : String );
  Begin
    if FCaption > '' Then AppendStr(FCaption, ' - ' );
  end;
Begin
  with IBQEve,tvEve do
   Begin
    TreeOptions.MiscOptions:=TreeOptions.MiscOptions-[toReadOnly];
    Clear;
    if not IsEmpty Then
     Begin
      AbookMark := GetBookmark;
      First;
      DisableControls;
      try
        while not Eof do
         Begin
          ANode := AddChild(nil,nil);
          with Anode^ do
           Begin
            CheckType :=ctCheckBox;
    //         States:=States+[vsDisabled];
            if not FieldByName('ev_' + as_indfam + '_source').IsNull Then
             Begin
               CheckState:=csCheckedNormal;
             end;
           end;
          ValidateNode(ANode,False);
          with PTVNodeEve ( GetNodeData ( Anode ))^ do
           Begin
            ImageIdx:=FieldByName('REF_EVE_CAT').AsInteger;
            FKey :=  FieldByName('ev_' + as_indfam + '_clef' ).AsInteger;
            FCaption:=FieldByName('ev_' + as_indfam + '_description').AsString;
             if not FieldByName('ev_' + as_indfam + '_date_writen').IsNull Then
              Begin
                AppendCaption(FCaption);
                if ibqtitrevent.AsString > ''
                Then FCaption := ibqtitrevent.AsString + ' - ' + FCaption;
                if FieldByName('ev_' + as_indfam + '_date' ).IsNull
                 Then AppendStr(FCaption, FieldByName('ev_' + as_indfam + '_date_writen').AsString)
                 Else AppendStr(FCaption, fs_FormatText(rs_on_date, mftFirstIsMaj) + ' ' + FieldByName('ev_' + as_indfam + '_date_writen').AsString);
              end;
             if not FieldByName('ev_' + as_indfam + '_ville').IsNull Then
              Begin
                AppendCaption(FCaption);
                AppendStr(FCaption, FieldByName('ev_' + as_indfam + '_cp').AsString+ ' ' + FieldByName('ev_' + as_indfam + '_ville').AsString);
              end;
           end;
          Next;
         end;
      finally
        GotoBookmark(AbookMark);
        EnableControls;
      end;
     end;
    TreeOptions.MiscOptions:=TreeOptions.MiscOptions+[toReadOnly];
    FocusedNode:=RootNode.FirstChild;
   end;
End;
}
procedure p_FillClonesEvent ( const IBQEve : TIBQuery ; const GdEve : TExtClonedPanel ; const ALabel : TLabel; const URLink1,URLink2 : TURLLink; const Image1, Image2, Image3 : TExtImage; const ibqtitrevent : TField; const as_indfam : String = 'ind' );
var
    AbookMark : TBookmark;
    li_i : Integer;
  procedure AppendCaption( var FCaption : String );
  Begin
    if FCaption > '' Then AppendStr(FCaption, ' - ' );
  end;
  procedure SetControl ( const ANode : TControl );
  Begin
    with IBQEve,Anode do
     Begin
       Tag:=Tag-(Tag div CST_MAX_CLONED_COLS ) * CST_MAX_CLONED_COLS;
       RecNo:=Tag;
       if ANode is  TExtImageList Then
        with ANode as TExtImageList do
          Begin
           if pos ( '_type', name ) > 0
            Then Begin Images := dm.ImgCat;     ImageIndex:=FieldByName('REF_EVE_CAT').AsInteger; End
            Else Begin Images := dm.imageEvent; ImageIndex:=FieldByName('QUID_IMAGE').AsInteger; End;
          End
      else if ANode is TExtImage Then
        Begin
          if not FieldByName('ev_' + as_indfam + '_source').IsNull
           Then p_FieldToImage ( FieldByName('ev_' + as_indfam + '_source'),( ANode as TExtImage ).Picture.Bitmap)
           Else Visible := False;
         end
      else if ANode is TURLLink Then
        Begin
          if pos ( 'A', name ) > 0 Then
            Begin
              if FieldByName('ev_' + as_indfam + '_ville').AsString > '' Then
               Begin
                 Caption := FieldByName('ev_' + as_indfam + '_cp').AsString+ ' ' + FieldByName('ev_' + as_indfam + '_ville').AsString;
               end
              else if FieldByName('ev_' + as_indfam + '_date_writen').AsString > ''
               Then
                 Begin
                  Caption := fs_FormatText(rs_on_date, mftFirstIsMaj) + ' ' + FieldByName('ev_' + as_indfam + '_date_writen').AsString;
                  Parent.Height:=(ALabel.Height+4)*2;
                 End
                Else
                 Begin
                   Parent.Height:=ALabel.Height+4;
                   Visible := False;
                 end;
             End
           Else
             if  ( FieldByName('ev_' + as_indfam + '_ville').AsString > '' )
             and ( FieldByName('ev_' + as_indfam + '_date_writen').AsString > '' )
              Then Caption := fs_FormatText(rs_on_date, mftFirstIsMaj) + ' ' + FieldByName('ev_' + as_indfam + '_date_writen').AsString
              Else Visible := False
        end
      else if ANode is TLabel Then
       Begin
         Caption:=ibqtitrevent.AsString;
         if FieldByName('ev_' + as_indfam + '_description').AsString > ''
          Then
           Begin
             if Caption > '' Then Caption := Caption + ' - ';
            Caption:= Caption + FieldByName('ev_' + as_indfam + '_description').AsString;
           End;
       End;
     End;
  end;

Begin
  with IBQEve,GdEve do
   Begin
    Rows := 1;
    PanelCloned.Visible:=not IsEmpty;
    if not IsEmpty Then
     Begin
      AbookMark := GetBookmark;
      First;
      DisableControls;
      try
        Rows := RecordCount;
        SetControl(ALabel);
        SetControl(URLink1);
        SetControl(URLink2);
        SetControl(Image1);
        SetControl(Image2);
        SetControl(Image3);
        for li_i := 0 to AutoControlCount - 1 do
          SetControl ( AutoControls[li_i] );
      finally
        GotoBookmark(AbookMark);
        EnableControls;
      end;
     end;
   end;
End;
function TreeAjouterEnfant(const TreeView:TVirtualStringTree;const Aparent:PVirtualNode):PVirtualNode;
begin
  with TreeView do
    Begin
     Result := AddChild(Aparent,nil);
     ValidateNode(Result,False);
    end;
end;


function fs_Str2Date(const ADateStr:String):TDateTime;
Begin
  Result := StrToDate(ADateStr,CST_DateFormat,'-');
end;

function fs_Str2DateTime(const ADateStr:String):TDateTime;
Begin
  if length ( ADateStr ) <= 8
   Then Result := StrToTime(ADateStr)
   Else Result := StrToDate(ADateStr,CST_DateTimeFormat,'-');
end;

function fs_Date2Str(const ADate:TDateTime):String;
Begin
  Result:=FormatDateTime(CST_DateFormat,Adate);
end;

function fs_DateTime2Str(const ADate:TDateTime):String;
Begin
  Result:=FormatDateTime(CST_DateTimeFormat,Adate);
end;

function DefDateWriten(const LaDate:TDateTime):string;
var//adaptation au calendrier inutile, utilisée uniquement avec "Maintenant" dans Age_Vivant
  y,m,d,vy,vm,vd:Word;
  sy,sm,sd:string;
begin
  y:=Pos('Y',_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][1]);
  m:=Pos('M',_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][1]);
  d:=Pos('D',_MotsClesDate.Token_mots[_TYPE_TOKEN_ORDRE][1]);
  DecodeDate(LaDate,vy,vm,vd);
  sy:=IntToStr(vy);
  sm:=IntToStr(vm);
  sd:=IntToStr(vd);
  if (d<m)and(d<y) then
  begin
    if m<y then
      Result:=AssembleStringWithSep([sd,sm,sy],' ')
    else
      Result:=AssembleStringWithSep([sd,sy,sm],' ');
  end
  else if (m<d)and(m<y) then
  begin
    if d<y then
      Result:=AssembleStringWithSep([sm,sd,sy],' ')
    else
      Result:=AssembleStringWithSep([sm,sy,sd],' ');
  end
  else
  begin
    if d<m then
      Result:=AssembleStringWithSep([sy,sd,sm],' ')
    else
      Result:=AssembleStringWithSep([sy,sm,sd],' ');
  end;
end;

function Age_Vivant(const Date_Nais:string;var AgeTexte:String):Integer;
var
  Maintenant:String;
begin
  Result:=-1;
  Maintenant:=DefDateWriten(Date);
  AgeTexte:=Age_Texte(Date_Nais,Maintenant);
  If Length(AgeTexte)>0 then
    Result:=_DateEv.DateCode1-_DateN.DateCode1;
end;


procedure CloseFicheIndividuInBox;
begin
  if Assigned(aFIndDlg) then
    aFIndDlg:=nil;
end;

function fb_FocusNode ( const tree : TVirtualStringTree; const SomeNode : PVirtualNode; const ai_cle : Integer ):Boolean;
  var ANode : PVirtualNode;
  function fb_selectnode:Boolean;
  Begin
    with tree do
 {   if PDBVTData(GetNodeData(ANode))^.ID=ai_cle then
    begin
      Selected[ANode]:=true;
      FocusedNode:=ANode;
      VisiblePath[ANode]:=True;
    end;}
  End;
Begin
  Result:=False;
  with tree do
    Begin
      ANode:=SomeNode;
      if fb_selectnode Then
        Begin
          Result:=true;
          Exit;
        end;
      ANode:=SomeNode.FirstChild;
      while ANode <> nil do
      begin
        if fb_FocusNode(tree,ANode,ai_cle) then
          Begin
            Result:=true;
            Exit;
          end;
        ANode:=ANode.NextSibling;
      end;
    end;
end;


procedure ImprimeImage(NumMedia:integer;Nom:string);
var
  aFMultimediEdit:TFBiblio_Multimedia_Edit;
begin
  aFMultimediEdit:=TFBiblio_Multimedia_Edit.create(Application);
  try
    aFMultimediEdit.doInitialise(NumMedia,Nom);
    Application.ProcessMessages;
    aFMultimediEdit.ShowModal;
  finally
    FreeAndNil(aFMultimediEdit);
  end;
end;


function ComprImageInMS(const Fichier:string;var MS1:TMemoryStream;var MS2:TMemoryStream;
  const OkImg1:boolean=true;const H1:integer=140;const W1:integer=120;//vue réduite
  const OkImg2:boolean=false;const H2:integer=1024;const W2:integer=1024;//vue si image chargée, pas redimentionnée si H2 ou W2=0
  const Comprime:Boolean=True//si False MS2 sans compression
  ):boolean;
var
  Img:{$IFNDEF IMAGING}TBGRABitmap{$ELSE}TImageData{$ENDIF};
  s:{$IFNDEF IMAGING}TBGRAImageFormat{$ELSE}string{$ENDIF};
  {$IFNDEF IMAGING}
  AWriter:TFPWriterJPEG;
  {$ENDIF}
  H,W:Integer;
  echelle:Single;
begin
  result:=false;
  MS1.Clear;
  MS2.Clear;
  {$IFDEF IMAGING}
  SetOption(ImagingJpegProgressive,0);
  {$ENDIF}
  if (OkImg1 or OkImg2)and FileExistsUTF8(Fichier) then
  begin
   {$IFNDEF IMAGING}
   s:=SuggestImageFormat(Fichier);
   if s>ifUnknown then
    begin
   {$ELSE}
   s:=DetermineFileFormat(Fichier);
    if s>'' then
    begin
     InitImage(Img);
     {$ENDIF}
      try
        try
          {$IFNDEF IMAGING}
          Img:=TBGRABitmap.Create(Fichier);
          if not Img.empty Then
           begin
            AWriter :=TFPWriterJPEG.create;
          {$ELSE}
          if LoadImageFromFile(Fichier,Img) then
           begin
          {$ENDIF}
            if OkImg2 then
            begin
              if (H2>0)and(W2>0) then
              begin
                H:=Img.Height;
                W:=Img.Width;
                if (H>H2)or(W>W2) then
                begin
                  if H2/H<W2/W then
                    echelle:=H2/H
                  else
                    echelle:=W2/W;
                  fb_ResizeImage(Img,trunc(echelle*W),trunc(echelle*H));
                end;
              end;
              if Comprime
              {$IFNDEF IMAGING}
               Then AWriter.CompressionQuality:=gci_context.TauxCompressionJPeg
               else AWriter.CompressionQuality:=100;
              Img.SaveToStream(MS2,AWriter);
              {$ELSE}
               then SetOption(ImagingJpegQuality,gci_context.TauxCompressionJPeg)
               else SetOption(ImagingJpegQuality,100);
               SaveImageToStream('jpg',MS2,Img);
              {$ENDIF}
            end;
            if OkImg1 and(H1>0)and(W1>0) then
            begin
              H:=Img.Height;
              W:=Img.Width;
              if (H>H1)or(W>W1) then
              begin
                if H1/H<W1/W then
                  echelle:=H1/H
                else
                  echelle:=W1/W;
                fb_ResizeImage(Img,trunc(echelle*W),trunc(echelle*H));
              end;
              {$IFNDEF IMAGING}
              AWriter.CompressionQuality:=90;
              Img.SaveToStream(MS1,AWriter);
              {$ELSE}
               SetOption(ImagingJpegQuality,90);//toujours en bonne qualité permet de sauvegarder image scannée
               SaveImageToStream('jpg',MS1,Img);
              {$ENDIF}
            end;
            result:=true;
          end;
        except
        end;
      finally
        p_FreeCustomImage(Img);
        {$IFNDEF IMAGING}
        AWriter.CompressionQuality:=gci_context.TauxCompressionJPeg;
        {$ELSE}
        SetOption(ImagingJpegQuality,gci_context.TauxCompressionJPeg);
        {$ENDIF}
      end;
    end;
  end;
end;



procedure VisualiseMedia(NumMedia:integer;const IBQuery:TIBSQL);
var
  nomfich,nomtemp:string;
  i,reduite,complete:integer;
begin
  if NumMedia<=0 then
    exit;
  nomfich:='';
  reduite:=0;
  complete:=0;
  with IBQuery do
  begin
    Close;
    SQL.Text:='select multi_path,octet_length(multi_reduite)as reduite,octet_length(multi_media)as complete';
    SQL.Add('from multimedia where multi_clef='+IntToStr(NumMedia));
    try
      ExecQuery;
      nomfich:=FieldByName('multi_path').AsString;
      reduite:=FieldByName('reduite').AsInteger;
      complete:=FieldByName('complete').AsInteger;
    except
    end;
    Close;
    if not FileExistsUTF8(nomfich) then
    begin
      if FichEstImage(nomfich)and(reduite>0) then
      begin
        nomtemp:=TimeToStr(now);
        nomfich:='';
        for i:=1 to length(nomtemp) do
          if nomtemp[i]in ['0'..'9'] then
            nomfich:=nomfich+nomtemp[i];
        nomfich:=_TempPath+nomfich+'.jpg';
        if reduite>complete then
          SQL.Strings[0]:='select multi_reduite'
        else
          SQL.Strings[0]:='select multi_media';
        try
          ExecQuery;
          Fields[0].SaveToFile(nomfich);
        except
        end;
        Close;
      end;
    end;
  end;
  if FileExistsUTF8(nomfich) then
    p_OpenFileOrDirectory(nomfich)
//    ShellExecute(0,nil,PChar(nomfich),nil,nil,SW_SHOWDEFAULT)
  else
    MyMessageDlg(fs_RemplaceMsg(rs_Error_None_File,[nomfich]),mtError, [mbCancel]);
end;

procedure OpenFicheIndividuInBox(aCleFiche:integer);
begin
  if not Assigned(aFIndDlg) then
  begin
    aFIndDlg:=TFIndividu.create(Application);
    aFIndDlg.DialogMode:=true;
  end;
  if aFIndDlg.doOpenFiche(aCleFiche) then
    aFIndDlg.Show
  else
    aFIndDlg.Close;
end;

procedure DefContextLangue;
const
  Langues:array[0..4] of string=('FRA','ENG','DEU','ITA','SPA');
begin
  gci_context.Langue:=UTF8UpperCase(gci_context.Langue);
  if PosStringDansListe(gci_context.Langue,Langues)=-1 then
    gci_context.Langue:='FRA';
end;

procedure OuvreFicheIndividuModale(aCleFiche:integer);
var
  aFIndividu:TFIndividu;
begin
  aFIndividu:=TFIndividu.create(Application);
  try
    aFIndividu.bModale:=true;
    aFIndividu.DialogMode:=true;
    if aFIndividu.doOpenFiche(aCleFiche) then
      aFIndividu.ShowModal;
  finally
    FreeAndNil(aFIndividu);
  end;
end;



function SelectRepertoire(const TitreFonction:string;Var APath:string;Proprio:TForm=nil):Boolean;
var
  afSelectRep:TfSelect_rep;
begin
  Result:=False;
  if (proprio=nil)and Assigned(Application.MainForm) then
    proprio:=Application.MainForm;
  if proprio<>nil then
    afSelectRep:=TfSelect_rep.Create(proprio)
  else
    afSelectRep:=TfSelect_rep.Create(Application);
  with afSelectRep,ShellTV do
    try
      if proprio<>nil then
        CentreLaFiche(afSelectRep,proprio,0,0);
      lFonction.Caption:=TitreFonction;
      ShowModal;
      if ( ModalResult=mrOk )
      and Assigned ( Selected ) then
      begin
        APath:=GetSelectedNodePath;
        Result:=True;
      end;
    finally
      FreeAndNil(afSelectRep);
    end;
end;


procedure FaitTempPath;//AL
var
  TmpDir:String;
begin
  TmpDir := GetTempDir;
  _TempPath:=TmpDir+ExtractFileNameOnly(Application.ExeName)+DirectorySeparator;
  if not DirectoryExistsUTF8(_TempPath) then
    ForceDirectoriesUTF8(_TempPath);
  _Ok_Supprime_TempPath:=true;
end;

procedure SupprimeTempPath;
var
  sr:TSearchRec;
  ls_File : String;
begin
  if _Ok_Supprime_TempPath and DirectoryExistsUTF8(_TempPath) then //suppression du répertoire temporaire
  begin
    FindFirstUTF8(_TempPath+'*.*',faAnyFile,sr);
    FindNextUTF8(sr);
    while (FindNextUTF8(sr)=0) do
      Begin
       ls_File :=_TempPath+sr.Name;
        DeleteFileUTF8(ls_File);
      end;
    FindCloseUTF8(sr);
    RemoveDirUTF8(_TempPath);
  end;
end;


// function TF_AncestroWeb.fb_getMediaFile
// creating a non-existing Media File
function fb_getMediaFile ( const IBQ_Media : TIBQuery;
                           const afc_FileCopy : TExtFileCopy ;
                           const as_ExportPath, as_FolderPath : string ;
                           var as_FileNameBegin : String ;
                           const ab_noOriginal : Boolean ) : Boolean;
var ls_Path : String;
Begin
  Result := False;

  // verifying existing file copy
  if {$IFDEF WINDOWS}(pos(':',as_ExportPath)=2) and {$ENDIF}
   FileExistsUTF8(as_ExportPath + as_FileNameBegin + CST_EXTENSION_JPEG ) Then
    Begin
      Result := True;
      Exit;
    end;
  // verifying existing original file copy
  if {$IFDEF WINDOWS}(pos(':',as_ExportPath)=2) and {$ENDIF}
   FileExistsUTF8(as_ExportPath + as_FileNameBegin + rs_FileName_NotACopy + CST_EXTENSION_JPEG ) Then
    Begin
      AppendStr ( as_FileNameBegin, rs_FileName_NotACopy ); // setting correct link name
      Result := True;
      Exit;
    end;
  try
      ls_Path := fs_getMediaPath ( nil,IBQ_Media, as_FolderPath, ab_noOriginal );
      // simple copy ?
      if  ( ls_Path > '' )
      and (   FileExistsUTF8(ls_Path))
       Then
         Begin
           afc_FileCopy.Source:=ls_Path;
           AppendStr ( as_FileNameBegin, rs_FileName_NotACopy );
           afc_FileCopy.Destination:=as_ExportPath + as_FileNameBegin + CST_EXTENSION_JPEG;
           afc_FileCopy.CopySourceToDestination;
           Result:=True;
           Exit;
         end;
    // unless creating file from database
     Result := fb_ImageFieldToFile(IBQ_Media.FieldByName(MEDIAS_MULTI_MEDIA), as_ExportPath + as_FileNameBegin + CST_EXTENSION_JPEG);
  Except
   Result:=False;
  end;
End;

procedure p_RenameMediasPaths ( const IBMultimedia : TIBQuery; const IBMultimediaMULTI_NOM, IBMultimediaMULTI_PATH : TField ; const mem_full_renaming : TMemo ; const acontrol : TControl );
var Abookmark : TBookmark;
    ls_newPath,
    ls_FolderPath : String;
begin
  if IBMultimedia.IsEmpty
  or ( MyMessageDlg(rs_Confirm_executing_full_medias_renaming,mtConfirmation,mbYesNo) = mrNo ) then
    Exit;
  Abookmark:=IBMultimedia.GetBookmark;
  IBMultimedia.DisableControls;
  ls_FolderPath := fPathBaseMedias;
  with IBMultimedia, mem_full_renaming do
   try
     Lines.Clear;
     acontrol.Visible:=False;
     Align:=alClient;
     Visible:=True;
     IBMultimedia.First;
     while not EOF do
       Begin
         // Searching original copy with partial name
         if IBMultimediaMULTI_NOM.AsString > '' Then
          Begin
           ls_newPath := DirectorySeparator + fs_GetCorrectPath ( IBMultimediaMULTI_NOM.AsString );
           // simple copy ?
           with IBMultimediaMULTI_PATH do
             if not IBMultimediaMULTI_NOM.IsNull Then
              Begin
               if    FileExistsUTF8(ls_FolderPath+ls_newPath) Then
                Begin
                 if ( AsString <> ls_FolderPath+ ls_newPath )
                  Then
                    Begin
                      Lines.Add ( fs_RemplaceMsg ( rs_File_Replacing, [AsString] ));
                      Edit;
                      IBMultimediaMULTI_PATH.AsString:=ls_FolderPath+ls_newPath;
                      Post;
                    end;
                end
               else
                Lines.Add ( fs_RemplaceMsg ( rs_File_Not_Found_in, [ls_newPath,ls_FolderPath] ));
             End;
           End;
         Next;
       end;
   finally
     try
       if MyMessageDlg(rs_Confirm_update,mtConfirmation,mbOKCancel) = mrOK
       Then Transaction.CommitRetaining
       Else Transaction.RollbackRetaining;
     Except
       MyMessageDlg(rs_Error_Cannot_Update_Database,mtError,[mbOK]);
     end;
     GotoBookmark(Abookmark);
     EnableControls;
     Visible:=False;
     acontrol.Visible:=True;
   end;
end;

// procedure TF_AncestroWeb.p_AddABase
// add and set a database
procedure p_AddToCombo ( const acb_combo : TComboBox; const as_Base : String ; const ab_SetIndex :Boolean = True);
var li_i : Integer;
    lb_found : Boolean;
Begin
  lb_found:=False;
  for li_i := 0 to acb_combo.Items.Count - 1 do
    if acb_combo.Items [ li_i ] = as_Base Then
      Begin
        lb_found:=True;
        if ab_SetIndex Then
          acb_combo.ItemIndex:=li_i;
        Break;
      end;
  if not lb_found  then
    Begin
      acb_combo.Items.Add(as_Base);
      if ab_SetIndex Then
        acb_combo.ItemIndex:=acb_combo.Items.Count-1;
    end;
End;

function MSimage2FichTemp(MS:TMemoryStream;var NomFich:string):Boolean;
var
  Img:{$IFNDEF IMAGING}TBGRABitmap{$ELSE}TImageData{$ENDIF};
  i:Integer;
begin
  Result:=False;
  {$IFNDEF IMAGING}
  Img:=nil;
  {$ELSE}
  InitImage(Img);
  {$ENDIF}
  try
    try
     MS.Position:=0;
     {$IFNDEF IMAGING}
     Img:=TBGRABitmap.Create(MS);
     if not Img.Empty then
     {$ELSE}
     if LoadImageFromStream(MS,Img) then
     {$ENDIF}
      begin
        NomFich:=TimeToStr(now);
        for i:=length(NomFich)downto 1 do
          if not(NomFich[i]in ['0'..'9']) then
            Delete(NomFich,i,1);
        NomFich:=_TempPath+NomFich+'.jpg';
        {$IFNDEF IMAGING}
        TFPWriterJPEG(DefaultBGRAImageWriter[ifJpeg]).CompressionQuality:=100;
        {$ELSE}
        SetOption(ImagingJpegQuality,100);
        {$ENDIF}
        Img.SaveToFile(NomFich);
        Result:=True;
      end;
    except
    end;
  finally

    {$IFNDEF IMAGING}
    TFPWriterJPEG(DefaultBGRAImageWriter[ifJpeg]).CompressionQuality:=gci_context.TauxCompressionJPeg;
    {$ELSE}
    SetOption(ImagingJpegQuality,gci_context.TauxCompressionJPeg);
    {$ENDIF}
    p_FreeCustomImage(Img);
  end;
end;

function BcdIsValide(const Value:Variant;const Precision:Integer=11;const Echelle:Integer=8):Boolean;
 var
  ext:Extended;
  bi:int64;
Begin
  Result:=True;
  Try
    if Value>'' then
     begin
      bi:=Abs(Trunc(Double(Value)));
      if bi<Intpower(10,Precision-Echelle) then
       begin
        ext:=Value*Intpower(10,Echelle);
        if Frac(ext)>0 then
          Result:=False
         else
          DoubleToBcd(ext);
      end
      else
        Result:=False;
     end;
  except
    Result:=False;
  end;
 end;


function NbrProcess(NomExe:string):Integer;
var
  SnapShot:Cardinal;
{$IFDEF WINDOWS}
  ProcessEntry:TProcessEntry32;//nécessite TlHelp32 dans les Uses
begin
  Result:=0;
  SnapShot:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
  if SnapShot=0 then
    exit;
  ProcessEntry.dwSize:=SizeOf(ProcessEntry);
  if Process32First(SnapShot,ProcessEntry) then
  begin
    repeat
      if ProcessEntry.szExeFile=NomExe then
        inc(Result);
    until not Process32Next(SnapShot,ProcessEntry);
  end;
  CloseHandle(SnapShot);
{$ELSE}
Begin
{$ENDIF}
end;


initialization
  _REP_PATH_REPORT[_REP_ASCENDANCE_COMPLET]:='_REP_ASCENDANCE'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_ASCENDANCE_PAR_HOMMES]:='_REP_ASCENDANCE'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_ASCENDANCE_PAR_FEMMES]:='_REP_ASCENDANCE'+DirectorySeparator;

  _REP_PATH_REPORT[_REP_DESCENDANCE_COMPLET]:='_REP_DESCENDANCE_COMPLET'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_DESCENDANCE_PATRONYMIQUE]:='_REP_DESCENDANCE_PATRONYMIQUE'+DirectorySeparator;

  _REP_PATH_REPORT[_REP_LISTE_ALPHA_TOUS]:='_REP_LISTE_ALPHA'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_LISTE_ALPHA_HOMME]:='_REP_LISTE_ALPHA'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_LISTE_ALPHA_FEMME]:='_REP_LISTE_ALPHA'+DirectorySeparator;

  _REP_PATH_REPORT[_REP_LISTE_DIVERS_UNION]:='_REP_LISTE_DIVERS_UNION'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_LISTE_DIVERS_ECLAIR]:='_REP_LISTE_DIVERS_ECLAIR'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_LISTE_DIVERS_EVENEMENT]:='_REP_LISTE_DIVERS_EVENEMENT'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_LISTE_DIVERS_ANNIVERSAIRE]:='_REP_LISTE_DIVERS_ANNIVERSAIRE'+DirectorySeparator;

  _REP_PATH_REPORT[_REP_LISTE_DIVERS_ENFANTS]:='_REP_LISTE_DIVERS_ENFANTS'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_LISTE_DIVERS_FRATRIE]:='_REP_LISTE_DIVERS_FRATRIE'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_LISTE_DIVERS_ONCLES_TANTES]:='_REP_LISTE_DIVERS_ONCLES_TANTES'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_LISTE_DIVERS_COUSINAGE]:='_REP_LISTE_DIVERS_COUSINAGE'+DirectorySeparator;

  _REP_PATH_REPORT[_REP_FICHE_INDIVIDUELLE]:='_REP_FICHE_INDIVIDUELLE'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_FICHE_FAMILIALE]:='_REP_FICHE_FAMILIALE'+DirectorySeparator;

  _REP_PATH_REPORT[_REP_STAT_PATRONYME]:='_REP_STAT_PATRONYME'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_STAT_PRENOM]:='_REP_STAT_PRENOM'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_STAT_AGE_PREMIERE_UNION]:='_REP_STAT_AGE_PREMIERE_UNION'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_STAT_LONGEVITE]:='_REP_STAT_LONGEVITE'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_STAT_NB_ENFANT_UNION]:='_REP_STAT_NB_ENFANT_UNION'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_STAT_RECENSEMENT]:='_REP_STAT_RECENSEMENT'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_STAT_DENOMBREMENT_ASCENDANCE]:='_REP_STAT_DENOMBREMENT_ASCENDANCE'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_STAT_DENOMBREMENT_DESCENDANCE]:='_REP_STAT_DENOMBREMENT_DESCENDANCE'+DirectorySeparator;

  _REP_PATH_REPORT[_REP_STAT_GRAPH_NAISS_DEPT]:='_REP_STAT_GRAPH_NAISS_DEPT'+DirectorySeparator;
  _REP_PATH_REPORT[_REP_STAT_PROFESSIONS]:='_REP_STAT_PROFESSIONS'+DirectorySeparator;

  FaitTempPath;//création du répertoire temporaire _TempPath

  _Path_Appli:=ExtractFilePath(Application.ExeName);//À créer avant d'initialiser gci_context
  AIniFile := TIniFile.Create(fs_getAppDir+ANCESTROMANIA+CST_EXTENSION_INI);
  gr_ExeVersion := IniVersionExe ( AIniFile );
  AIniFile.free;
  gci_context:=TContextIni.create(Application);
  gci_context.LoadIni;

  gb_btnCancel:=false;

  BaseReseau:=(length(gci_context.PathFileNameBdd)>0)and(pos(':',gci_context.PathFileNameBdd)<>2);
  if length(gci_context.PathFileNameBdd)=0 then
  begin
    {$IFDEF WINDOWS}
    gci_context.PathFileNameBdd:=fPath_MesDocuments+_REL_PATH_DATABASE;
    ForceDirectories(gci_context.PathFileNameBdd);
    gci_context.PathFileNameBdd:=GetAppConfigDir(True)+rs_MyDatabase+EXTENSION_FIREBIRD;
    fBaseEmbedded := False;
    {$ELSE}
    if      DirectoryExistsUTF8(DEFAULT_FIREBIRD_SERVER_DIR+'system')
    and not DirectoryExistsUTF8(DEFAULT_FIREBIRD_DATA_DIR) Then
       Begin
         AProcess := TProcess.Create(nil);
         with AProcess do
           try
             CommandLine:='sh "'+ExtractFileDir(Application.ExeName)+DirectorySeparator+
               {$IFDEF DARWIN}'osx'{$ELSE}'linux'{$ENDIF}+'.sh"';
             Execute;
           finally
           end;
         AProcess.Free;
         MyMessageDlg(rs_Warning_If_cannot_access_to_database_please_reopen_session,mtWarning,[mbOK]);
       end;
     gci_context.PathFileNameBdd:=ANCESTROMANIA_DATABASE;
    {$ENDIF}
  end
  else if (not BaseReseau)
    and(not DirectoryExistsUTF8(ExtractFilePath(gci_context.PathFileNameBdd)))
    and gci_context.CreateRepDefaut then
    if not ForceDirectories(ExtractFilePath(gci_context.PathFileNameBdd)) then
      showmessage(fs_RemplaceMsg(rs_Message_Database_Directory_which_is_used_to_set_database_site,
      [ExtractFilePath(gci_context.PathFileNameBdd)]));

  //chemin vers le répertoire d'import/Export
  if length(gci_context.PathImportExport)=0 then
  begin
    gci_context.PathImportExport:=fPath_MesDocuments+_REL_PATH_IMPORT_EXPORT;
    ForceDirectories(gci_context.PathImportExport);
  end
  else if gci_context.CreateRepDefaut and not DirectoryExistsUTF8(gci_context.PathImportExport) then
    ForceDirectories(gci_context.PathImportExport);

  //chemin vers le répertoire des documents
  if length(gci_context.PathDocs)=0 then
  begin
    gci_context.PathDocs:=fPath_MesDocuments+_REL_PATH_DOC;
    ForceDirectories(gci_context.PathDocs);
  end
  else if gci_context.CreateRepDefaut and not DirectoryExistsUTF8(gci_context.PathDocs) then
    ForceDirectories(gci_context.PathDocs);

  //Chemin vers les traductions
  if not DirectoryExistsUTF8(_Path_Appli+_REL_PATH_TRADUCTIONS) then
    CreateDirUTF8(_Path_Appli+_REL_PATH_TRADUCTIONS);

  //Chemin vers les Plugins
  if not DirectoryExistsUTF8(_Path_Appli+_REL_PATH_PLUGINS) then
    CreateDirUTF8(_Path_Appli+_REL_PATH_PLUGINS);

  //Nom du fichier de traduction ? utiliser
  _FileNameTraduction:='';
  _FileNameHelp:='HelpAncestrologie.fr.chm';
  _FileNamePartenaires:='Partners.fr.htm';

  _utilEstAdmin:=False;
                     {
  if FileExistsUTF8(_Path_Appli+_REL_PATH_TRADUCTIONS+gs_lang+_EXT_TRADUC) then
  begin
    _FileNameTraduction:=gci_context.Language+_EXT_TRADUC;
  end;}
  if FileExistsUTF8(_Path_Appli+_REL_PATH_HELP+'HelpAncestrologie.'+gs_lang+'.chm') then
  begin
    _FileNameHelp:='HelpAncestrologie.'+gs_lang+'.chm';
  end;
  if FileExistsUTF8(_Path_Appli+_REL_PATH_GOODIES+'Partners.'+gs_lang+'.htm') then
  begin
    _FileNamePartenaires:='Partners.'+gs_lang+'.htm';
  end;

  {$IFDEF FPC}
  OnGetLibraryName:= TOnGetLibraryName( p_setLibrary);
  {$ENDIF}

finalization
// M GIROUX
//  if _Mutex<>0 then
//    CloseHandle(_Mutex);
  SupprimeTempPath;

end.

