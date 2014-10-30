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

unit u_form_individu_observations;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Classes,Controls,StdCtrls,
  ExtCtrls,Db, u_framework_dbcomponents, U_OnFormInfoIni;

type

  { TFIndividuObservations }

  TFIndividuObservations=class(TF_FormAdapt)
    OnFormInfoIni: TOnFormInfoIni;
    Panel10:TPanel;
    Panel13:TPanel;
    DataSource:TDataSource;
    lNom:TLabel;
    Label8:TLabel;
    Panel1:TPanel;
    Panel2:TPanel;
    Panel3:TPanel;
    Panel4:TPanel;
    Label1:TLabel;
    Label2:TLabel;
    Notes: TFWDBMemo;
    Sources: TFWDBMemo;
    Splitter1: TSplitter;
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure cxSplitter1Moved(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure NotesKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    procedure NotesDblClick(Sender:TObject);
    procedure SourcesDblClick(Sender:TObject);
    procedure NotesKeyPress(Sender:TObject;var Key:Char);
    procedure NotesEnter(Sender: TObject);
    procedure NotesExit(Sender: TObject);

  private
    BloqueCar:boolean;
  end;

implementation

uses u_form_individu,u_dm,
     u_common_functions,
     u_genealogy_context,
     u_common_ancestro;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

var    fFormIndividu:TFIndividu;


procedure TFIndividuObservations.SuperFormRefreshControls(Sender:TObject);
begin
  DataSource.AutoEdit:=not FFormIndividu.DialogMode;
end;

procedure TFIndividuObservations.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  Color:=gci_context.ColorLight;
  Panel3.Color:=gci_context.ColorDark;
  Panel4.Color:=gci_context.ColorDark;
  Label1.Font.Color:=gci_context.ColorTexteOnglets;
  Label2.Font.Color:=gci_context.ColorTexteOnglets;
  BloqueCar:=false;
  Notes.Hint:=rs_Hint_Notes;
  Sources.Hint:=rs_Hint_Notes;
  fFormIndividu:=TFIndividu(Owner);
  DataSource.DataSet:=FFormIndividu.QueryIndividu;
  lNom.PopupMenu:=FFormIndividu.pmNom;
  lNom.OnMouseEnter:=FFormIndividu.lNomMouseEnter;
  lNom.OnMouseLeave:=FFormIndividu.lNomMouseLeave;
  lNom.OnMouseMove:=FFormIndividu.lNomMouseMove;
  lNom.OnClick:=FFormIndividu.lNomClick;
end;

procedure TFIndividuObservations.cxSplitter1Moved(Sender:TObject);
begin
  gci_context.PanelInfosHeight:=Panel2.Height;
end;

procedure TFIndividuObservations.SuperFormShow(Sender:TObject);
begin
  Panel2.Height:=gci_context.PanelInfosHeight;
end;

procedure TFIndividuObservations.NotesKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
var
  s:string;
  k:integer;
  memo:TFWDBMemo;
begin
  if not FFormIndividu.DialogMode then
  begin
    memo:=sender as TFWDBMemo;
    s:=memo.Text;
    k:=memo.SelStart;
    if dm.RemplaceRaccourcis(Key,Shift,s,k) then
    begin
      memo.Lines.Text:=s;
      memo.SelStart:=k;
      BloqueCar:=true;
    end;
  end;
end;

procedure TFIndividuObservations.NotesDblClick(Sender:TObject);
begin
  ExecuteChaineDansChaine(Notes.Text,Notes.SelStart,Notes.SelLength);
end;

procedure TFIndividuObservations.SourcesDblClick(Sender:TObject);
begin
  ExecuteChaineDansChaine(Sources.Text,Sources.SelStart,Sources.SelLength);
end;

procedure TFIndividuObservations.NotesKeyPress(Sender:TObject;
  var Key:Char);
begin
  if BloqueCar then
  begin
    BloqueCar:=false;
    Key:=#0;
  end;
end;

procedure TFIndividuObservations.NotesEnter(Sender: TObject);
begin
  (Sender as TControl).ShowHint:=False;
end;

procedure TFIndividuObservations.NotesExit(Sender: TObject);
begin
  (Sender as TControl).ShowHint:=True;
end;

end.

