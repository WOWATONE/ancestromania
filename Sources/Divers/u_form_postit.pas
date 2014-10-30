{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{ auteur du pourquoi faire simple quand on peut faire compliqué.        }
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

unit u_form_postit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
{$IFDEF WINDOWS}
  Messages,
{$ENDIF}
  U_FormAdapt,u_comp_TYLanguage,DB,Dialogs,
  IBUpdateSQL,IBQuery,Forms,ExtCtrls,Controls,u_buttons_flat,
  Classes,u_buttons_appli,ExtJvXPButtons,
  u_ancestropictimages,u_framework_dbcomponents;

type

  { TFPostit }

  TFPostit=class(TF_FormAdapt)
    query:TIBQuery;
    IBUpdateSQL:TIBUpdateSQL;
    DataSource:TDataSource;
    Panel5:TPanel;
    Panel15:TPanel;
    SpeedButton2:TCSpeedButton;
    Panel4:TPanel;
    fpBoutons:TPanel;
    Panel1:TPanel;
    Panel2:TPanel;
    Panel3:TPanel;
    Panel6:TPanel;
    GoodBtn2:TJvXPButton;
    Image1:TIAQuestion;
    queryM_CLEF:TLongintField;
    queryM_MEMO:TBlobField;
    queryM_DOSSIER:TLongintField;
    Language:TYLanguage;
    bsfbDelete:TFWErase;
    GoodBtn3:TFWClose;
    Shape1:TShape;
    memo:TFWDBMemo;
    procedure bsfbDeleteClick(Sender:TObject);
    procedure GoodBtn2Click(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure SuperFormCreate(Sender:TObject);
    procedure Panel6MouseDown(Sender:TObject;Button:TMouseButton;
      Shift:TShiftState;X,Y:Integer);
    procedure SuperFormClose(Sender: TObject; var Action: TCloseAction);
    procedure SuperFormShowFirstTime(Sender: TObject);
  private

  public
    function doOpenQuery:boolean;

  end;

implementation

uses u_dm,u_common_functions,
     u_common_ancestro,
     u_common_ancestro_functions,
     fonctions_dialogs,
     u_common_const;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

function TFPostit.doOpenQuery:boolean;
var
  k:integer;
  s:string;
begin
  result:=false;
  s:='Ceci est un pense-bête, vous pouvez taper autant de texte que vous voulez.';
  query.Close;
  query.ParamByName('KLE_DOSSIER').AsInteger:=dm.NumDossier;
  query.Open;

  if query.IsEmpty then
  begin
      //On en créé un
    k:=dm.uf_GetClefUnique('MEMO_INFOS');
    if k<>-1 then
    begin
      query.Insert;
      QueryM_CLEF.AsInteger:=k;
      QueryM_DOSSIER.AsInteger:=dm.NumDossier;
      QueryM_MEMO.AsString:=s;
      Query.Post;
      result:=true;
    end;
  end
  else
    result:=true;
end;

procedure TFPostit.bsfbDeleteClick(Sender:TObject);
begin
  if MyMessageDlg(rs_Do_you_delete_the_content_of_this_notebook,mtConfirmation, [mbYes,mbNo],self)=mrYes then
  begin
    try
      if Query.Active then
      begin
        if not(Query.State in [dsInsert,dsEdit]) then
          Query.Edit;
        queryM_MEMO.Clear;
        Query.Post;
      end;
    except
    end;
  end;
end;

procedure TFPostit.GoodBtn2Click(Sender:TObject);
begin
  Close;
end;

procedure TFPostit.SuperFormKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  case Key of
    // VK_ESCAPE: ModalResult := mrOk;
    _KEY_HELP:p_ShowHelp(_ID_POSTIT);
  end;
end;

procedure TFPostit.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
end;

procedure TFPostit.Panel6MouseDown(Sender:TObject;Button:TMouseButton;
  Shift:TShiftState;X,Y:Integer);
begin
  ReleaseCapture;
  {$IFDEF WINDOWS}
  TForm(Self).perform(WM_SYSCOMMAND,$F012,0);
  {$ENDIF}
end;

procedure TFPostit.SuperFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  try
    if (Query.State in [dsInsert,dsEdit]) then
    begin
      Query.Post;
      dm.IBTrans_Secondaire.CommitRetaining;
    end;
  except
  end;
  Query.Close;
  Action:=caFree;
  DoSendMessage(Owner,'FERME_POSTIT');
end;

procedure TFPostit.SuperFormShowFirstTime(Sender: TObject);
begin
  Caption:=rs_Post_it;
end;

end.

