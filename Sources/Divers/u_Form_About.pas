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

unit u_Form_About;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, ShellApi, Windows,
{$ELSE}
{$ENDIF}
  Forms,SysUtils,StdCtrls, RichView, RVStyle,
  u_buttons_appli,Graphics,
  ExtCtrls,Controls, DbCtrls,IBDatabaseInfo, ComCtrls, U_ExtImage;

type

  { TFAbout }

  TFAbout=class(TForm)
    btnClose: TFWClose;
    cxImage1: TExtImage;
    cxListBox1: TDBListBox;
    cxPageControl1:TPageControl;
    cxTabSheet1: TTabSheet;
    Image4: TImage;
    Label2: TLabel;
    Label3: TLabel;
    MemoVersions: TMemo;
    n1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    RVStyle: TRVStyle;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Timer1:TTimer;
    RV:TRichView;
    IBDatabaseInfo:TIBDatabaseInfo;

    procedure FormCreate(Sender:TObject);
    procedure btnCloseClick(Sender:TObject);
    procedure FormClose(Sender:TObject;var Action:TCloseAction);
    procedure Timer1Timer(Sender:TObject);
    procedure cxPageControlDrawTabEx(AControl:TCustomTabControl;
      ATab:TTabSheet;Font:TFont);
    procedure Image4Click(Sender:TObject);
    procedure cxPageControl1Change(Sender:TObject);//BT
  private
    bFirstTime:boolean;
  public

  end;

implementation

uses u_dm,
     u_common_functions,
     u_common_ancestro,
     FileUtil, u_genealogy_context,
     StrUtils,
     fonctions_net,
     fonctions_system,
     fonctions_string,
     fonctions_dialogs,
     u_common_resources;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFAbout.FormCreate(Sender:TObject);
const
  crlf:string=chr(13)+chr(10);
var
  S,PathExe:string;
  i:integer;
  procedure InfosFichier(s:string);
  var f:String;
  begin
    f:=PathExe+s;
    if FileExistsUTF8(f) { *Converted from FileExistsUTF8*  } then
    begin
      MemoVersions.Lines.Add(rs_Version+' '+s+': '+fs_VersionExe);
    end
    else
      MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_Not_present_at_install, [s]));
  end;

begin
  Color:=gci_context.ColorLight;
  screen.Cursor:=crHourglass;
  cxPageControl1.ActivePageIndex:=0;
  Label2.Caption:='André Langlet'+crlf+crlf+'Matthieu GIROUX'+crlf+crlf+'Marc Duport'+crlf+crlf+'Claude Rolain';

  rv.Clear;

  rv.FirstJumpNo:=0;
  rv.Add(' ',rvsNormal);

  rv.Add('Philippe Cazaux-Moutou',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'Créateur du projet en 1995',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'Conception et développement du projet',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'avec Yann Uhel.',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'De 2001 à 2003 développement avec de',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'nombreux bénévoles sous licence GPL.',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  //- Remerciements 
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('Remerciements particuliers à',rvsSubheading);

  // Bruno Trufier 
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('Bruno Trufier et François David',rvsHeading);

  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'Des corrections de bugs...',rvsNormal);

  // Matthieu
  rv.AddTextFromNewLine(' ',rvsNormal);

  // Ransac
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('Ransac',rvsHeading);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'Pour les améliorations importantes sur la gestion des lieux...',rvsNormal);

  // Lya -
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('Lya',rvsHeading);

  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'Pour son aide aux utilisateurs sur le forum et ses jolies images',rvsNormal);

  // Claude Rolain 
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('Claude Rolain',rvsHeading);

  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'Des corrections de bugs et la mise à jour des composants...',rvsNormal);

  // Thierry Collier 
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('Thierry Collier',rvsHeading);

  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'Module de calendrier et de conversion des dates',rvsNormal);

  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('Laurent Robbe',rvsHeading);

  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'Créateur du BOA (version initiale de l''outil de requêtes intégré)',rvsNormal);
  
  //Pierre Garnier
  rv.Add('Pierre Garnier',rvsHeading);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'Pour la conception des dictionnaires d''Histoire',rvsNormal);

  // Facon 
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('Christian Facon',rvsHeading);

  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('  '+'Pour son aide aux utilisateurs et les nombreux tests de déverminage',rvsNormal);

  //groupes de news Delphi
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('Les développeurs des groupes de news Delphi',rvsNormal);

  //membres des forum Ancestrologie, Ancestromania, La Guilde
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('Tous les membres des forum Ancestromania, Ancestromania',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('et La Guilde Ancestrologique pour leur entr''aide',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('et leurs connaissances de la généalogie.',rvsNormal);

  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);

  //les anonymes
  rv.Add('Et tous ceux oubliés ou qui ont voulu rester anonymes.',rvsNormal);
  rv.AddTextFromNewLine(' ',rvsNormal);
  rv.Add('pour leur aide, leurs tests et leur contribution.',rvsNormal);
  rv.AddTextFromNewLine(DupeString(' '+crlf,20),rvsNormal);

  rv.VSmallStep:=1;
  rv.format;
  rv.Paint;

  MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_OS,fs_GetFullArchitecture));
  if gci_context.CDSVersion>'' then
  begin
    MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_Version,[gci_context.CDSVersion]));
    MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_Build,[gci_context.Build]));
  end;
  MemoVersions.Lines.Add('');

  s:=Application.ExeName;
  // Matthieu : Gestion de version dans Extended
//  GetFileBuildInfo(S,V[0],V[1],V[2],V[3]);
  MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_Ancestromania_version,[IntToStr(gr_ExeVersion[0])+'.'+IntToStr(gr_ExeVersion[1])+'.'+IntToStr(gr_ExeVersion[2])+'.'+IntToStr(gr_ExeVersion[3])]));
  MemoVersions.Lines.Add('');
  PathExe:=ExtractFilePath(s);

  {$IFDEF WINDOWS}
  s:='gds32.dll';
  if FileExistsUTF8(PathExe+s) { *Converted from FileExistsUTF8*  } then
  begin
    MemoVersions.Lines.Add(rs_Info_Firebird_embedded_is_installed);
    MemoVersions.Lines.Add(rs_Info_Files_library_versions);
    InfosFichier(s);
    s:='ib_util.dll';
    InfosFichier(s);
    s:='fbclient.dll';
    InfosFichier(s);
    MemoVersions.Lines.Add('');
  end;
  s:='isql.exe';
  InfosFichier(s);
  MemoVersions.Lines.Add('');
  {$ENDIF}

  if dm.ibd_BASE.Connected then
  begin
    with IBDatabaseInfo do
    begin
      MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Firebird_Version,[Version]));
      MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Server_Side,[DBSiteName]));
      MemoVersions.Lines.Add('');
      MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_Connected_Database,[DBFileName]));
      MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_Database_version,[gci_context.VersionBase]));
      if UserNames.Count>1 then
      begin
        MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_Users,[UserNames[0]]));
        for I:=1 to UserNames.Count-1 do
          MemoVersions.Lines.Add('                    '+UserNames[I]);
      end
      else
        MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_User,[UserNames[0]]));
      MemoVersions.Lines.Add('');
      MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_File_size,[FormatFloat('#,',Allocation*PageSize)]));
      MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_Used_memory,[FormatFloat('#,',CurrentMemory)]));
      MemoVersions.Lines.Add(fs_RemplaceMsg(rs_Info_File_structure_version,[IntToStr(ODSMajorVersion)+'.'+IntToStr(ODSMinorVersion)]));

      if ForcedWrites=1 then
        MemoVersions.Lines.Add(rs_Info_Forced_Writing_on)
      else
        MemoVersions.Lines.Add(rs_Info_Forced_Writing_off);
    end;
  end
  else
    MemoVersions.Lines.Add(rs_Not_Connected_To_Database);

  Application.ProcessMessages;
  screen.Cursor:=crDefault;
  bFirstTime:=true;
end;

procedure TFAbout.btnCloseClick(Sender:TObject);
begin
  Close;
end;

procedure TFAbout.FormClose(Sender:TObject;var Action:TCloseAction);
begin
  Timer1.Free;
  Action:=caFree;
end;

procedure TFAbout.Timer1Timer(Sender:TObject);
begin
  if bFirstTime then
  begin
    Timer1.Interval:=500;
    bFirstTime:=false;
  end
  else
  begin
    if rv.VScrollPos<>rv.VScrollMax then
      rv.VScrollPos:=rv.VScrollPos+1
    else
    begin
      rv.VScrollPos:=0;
      Timer1.Interval:=1000;
      bFirstTime:=true;
    end;
  end;
  Application.ProcessMessages;
end;

procedure TFAbout.cxPageControlDrawTabEx(AControl:TCustomTabControl;
  ATab:TTabSheet;Font:TFont);
begin
  Font.Color:=gci_context.ColorTexteOnglets;
  if AControl.PageIndex=ATab.PageIndex then
    ATab.Color:=gci_context.ColorLight
  else
    ATab.Color:=gci_context.ColorDark;
end;

procedure TFAbout.Image4Click(Sender:TObject);
begin
  GoToThisUrl('http://www.firebirdsql.org');
end;

procedure TFAbout.cxPageControl1Change(Sender:TObject);
begin
  if cxPageControl1.ActivePageIndex=0 then
  begin
    rv.VScrollPos:=0;
    Timer1.Interval:=1000;
    bFirstTime:=true;
    Timer1.Enabled:=true;
  end
  else
    Timer1.Enabled:=false;
end;

end.

