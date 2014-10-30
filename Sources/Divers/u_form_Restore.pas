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
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_form_Restore;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt, u_ancestropictimages,
  u_comp_TYLanguage, Dialogs, StdCtrls, Controls, ExtCtrls,
  forms, SysUtils, u_buttons_appli;

type

  { TFRestore }

  TFRestore=class(TF_FormAdapt)
    IAMouse1: TIAMouse;
    IATitle1: TIATitle;
    Label7: TLabel;
    Panel3:TPanel;
    Panel4:TPanel;
    Panel1:TPanel;
    Notebook:TNotebook;
    page1:TPage;
    GoodBtn1:TFWOK;
    Language:TYLanguage;
    Memo1:TMemo;
    uPath: TLabel;
    procedure GoodBtn1Click(Sender:TObject);
    procedure NotebookChange(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
  private

  public

  end;

implementation

uses u_dm,
     u_common_functions,
     fonctions_dialogs,
     u_common_ancestro,u_common_const,
     u_genealogy_context,
     u_common_ancestro_functions,
     IBServices,IBSQL, FileUtil, fonctions_string;
{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFRestore.GoodBtn1Click(Sender:TObject);
var
  DiskSize:Int64;
  sr:TSearchRec;
  TailleFichier:LongInt;
  Pos:integer;
  Save_Cursor:TCursor;
  ibRestore:TIBRestoreService;
  IBBackup:TIBBackupService;
  FileNameGBK,PathNameGBK,BackFile,Serveur,NomBase:string;
  lecteur:string;
  Prot:TProtocol;
  q:TIBSQL;
begin
  GoodBtn1.Enabled:=False;
  dm.doCloseDatabase;

  SendFocus(Memo1);

  {$IFDEF WINDOWS}
  Pos:=AnsiPos(':',gci_context.PathFileNameBdd);
  if Pos>2 then
  {$ELSE}
  Pos:=AnsiPos(DirectorySeparator,gci_context.PathFileNameBdd);
  if Pos <> 1 then
  {$ENDIF}
  begin
    Prot:=TCP;
    Serveur:=copy(gci_context.PathFileNameBdd,1,Pos-1);
    NomBase:=copy(gci_context.PathFileNameBdd,Pos+1,250);
    BackFile:='optimisation.fbk';
  end
  else
  begin
    Prot:=Local;
    Serveur:='';
    NomBase:=gci_context.PathFileNameBdd;
    FileNameGBK:=ExtractFileNameOnly(gci_context.PathFileNameBdd)+FormatDateTime('yymmddhh',Now);
    FileNameGBK:=ChangeFileExt(FileNameGBK,'.FBK');
{$IFDEF WINDOWS}
    if Pos=2 then
{$ELSE}
    if ( gci_context.PathFileNameBdd > '' )
    and ( gci_context.PathFileNameBdd [1] = DirectorySeparator ) Then
{$ENDIF}
     begin
      lecteur:=AnsiUpperCase(gci_context.PathSauvegarde);
      DiskSize:=DiskFree({$IFDEF WINDOWS}ord(lecteur[1])-ord('A')+1{$ELSE}0{$ENDIF});
      FindFirstUTF8(NomBase, faAnyFile, sr); { *Converted from FindFirstUTF8*  }
      TailleFichier:=sr.Size;
      FindCloseUTF8(sr); { *Converted from FindCloseUTF8*  }
      if DiskSize>TailleFichier
       then PathNameGBK:=gci_context.PathSauvegarde
       else PathNameGBK:=ExtractFilePath(NomBase)+_REL_PATH_BACKUP;
     end
      else
        PathNameGBK:=gci_context.PathSauvegarde;
    if not ForceDirectoriesUTF8(PathNameGBK) { *Converted from ForceDirectories*  } then
    begin
      MyMessageDlg(fs_RemplaceMsg(rs_Error_Restore_Directory_does_not_exists,[PathNameGBK]),mtError,[mbOK]);
      DefaultCloseAction:=caFree;
      dm.doOpenDatabase;
      DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
      Close;
      exit;
    end;
    BackFile:=ExcludeTrailingPathDelimiter(PathNameGBK)+DirectorySeparator+FileNameGBK;
  end;
  if FileExistsUTF8(BackFile) Then
    DeleteFileUTF8(BackFile);
  Save_Cursor:=Screen.Cursor;
  Screen.Cursor:=crHourglass;
  try
    IBBackup:=TIBBackupService.Create(Self);
    with IBBackup do
    begin
      LoginPrompt:=False;
      with Params do
       Begin
        Add('user_name='+_user_name);
        Add('password='+_password);
        //Add('lc_ctype='_lc_ctypeUTF8);
       end;
      Protocol:=Prot;
      ServerName:=Serveur;
      Active:=True;
      try
        Verbose:=True;
        Options:= [IgnoreLimbo];
        DatabaseName:=NomBase;
        BackupFile.Add(BackFile);
        uPath.Caption:=fs_RemplaceMsg(rs_Caption_Save_in,[BackFile]);
        Memo1.Clear;
        ServiceStart;
        while not Eof do
          Memo1.Lines.Append(GetNextLine);
      finally
        Active:=False;
        Destroy;
      end;
    end;

    ibRestore:=TIBRestoreService.Create(Self);
    with IBRestore do
    begin
      LoginPrompt:=False;
      Params.Add('user_name='+_user_name);
      Params.Add('password='+_password);
      Protocol:=Prot;
      ServerName:=Serveur;
      Active:=True;
      try
        Verbose:=True;
        Options:= [Replace];
        PageBuffers:=32000;
        PageSize:=4096;
        DatabaseName.Add(NomBase);
        BackupFile.Add(BackFile);
        uPath.Caption:=fs_RemplaceMsg(rs_Caption_Restore_database,[gci_context.PathFileNameBdd]);
        Memo1.Clear;
        ServiceStart;
        while not Eof do
          Memo1.Lines.Append(GetNextLine);
      finally
        Active:=False;
        FreeAndNil(ibRestore);
      end;
    end;

    dm.ibd_BASE.Connected:=true;
    dm.IBT_base.Active:=true;
    q:=TIBSQL.Create(self);
    try
      q.Database:=dm.ibd_BASE;
      q.Transaction:=dm.IBT_BASE;
      q.SQL.Add('select rdb$get_context(''USER_SESSION'',''RATIO_TAILLE'') from rdb$database');
      q.ExecQuery;
      if not q.Fields[0].IsNull then
      begin
        q.Close;
        q.SQL.Clear;
        q.SQL.Add('update t_version_base set octets_fichier=null');
        q.ExecQuery;
      end;
      q.Close;
    finally
      q.Free;
    end;
    dm.IBT_base.Commit;
    dm.ibd_BASE.Connected:=false;

    Memo1.Lines.Clear;

    Screen.Cursor:=Save_Cursor;
   
    dm.doOpenDatabase;

    dm.doMAJTableJournal(rs_Log_Optimising_database);
    MyMessageDlg(rs_Optimising_database_is_a_success,mtInformation, [mbOK]);
  Except
    Screen.Cursor:=Save_Cursor;
    MyMessageDlg(rs_Error_One_Error_has_occured_while_optimising_Verify_if_you_are_admin
      ,mtError, [mbOK]);
    if not dm.ibd_BASE.Connected then
      dm.doOpenDatabase;
  end;
  DefaultCloseAction:=caFree;;
  DoSendMessage(Owner,'OPEN_MODULE_INDIVIDU');
  Close;
end;

procedure TFRestore.NotebookChange(Sender: TObject);
begin

end;

procedure TFRestore.SuperFormCreate(Sender:TObject);
begin
  Panel4.Color:=gci_context.ColorLight;
  GoodBtn1.Color:=gci_context.ColorLight;
  GoodBtn1.ColorFrameFocus:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  uPath.Caption:=rs_Database+': '+gci_context.PathFileNameBdd;
end;

end.

