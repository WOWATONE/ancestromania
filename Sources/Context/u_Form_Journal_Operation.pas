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
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_Form_Journal_Operation;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,
  u_comp_TYLanguage,Dialogs,DB,IBCustomDataSet,IBQuery,
  StdCtrls,Controls,ExtCtrls,U_ExtDBGrid,
  u_buttons_appli,IBSQL,
  u_ancestropictimages, u_extcomponent, Menus;

type

  { TFJournalOperations }

  TFJournalOperations=class(TF_FormAdapt)
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    IBQJournal:TIBQuery;
    DSJournal:TDataSource;
    dxDBGrid1:TExtDBGrid;
    Panel3:TPanel;
    Image1:TIATitle;
    Panel2:TPanel;
    Language:TYLanguage;
    Label1:TLabel;
    IBQJournalQUI:TIBStringField;
    IBQJournalLE:TDateTimeField;
    IBQJournalTEXTE:TIBStringField;
    fpBoutons:TPanel;
    GoodBtn7:TFWClose;
    btnPurge:TFWInit;

    procedure dxDBGrid1BeforePopup(Sender: TObject; var APopupMenu: TPopupMenu;
      var AHandled: Boolean);
    procedure SuperFormCreate(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);

    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
    procedure btnPurgeClick(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
  private
  public

  end;

implementation

uses  u_dm,
      u_common_const,
      u_common_functions,
      fonctions_dialogs,
      u_common_ancestro_functions,
      u_genealogy_context,
      u_common_ancestro;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFJournalOperations.SuperFormCreate(Sender:TObject);
begin
  pGeneral.Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  IBQJournal.Params[0].AsInteger:=dm.NumDossier;
  IBQJournal.Open;
end;

procedure TFJournalOperations.dxDBGrid1BeforePopup(Sender: TObject;
  var APopupMenu: TPopupMenu; var AHandled: Boolean);
begin

end;

procedure TFJournalOperations.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  IBQJournal.Close;
//  Action:=caFree; //libération par la fonction qui l'appelle
end;

//procedure TFJournalOperations.SetDialogMode(const Value:boolean);
//begin
//  fDialogMode:=Value;
//end;

procedure TFJournalOperations.sbCloseClick(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFJournalOperations.btnPurgeClick(Sender:TObject);
var
  q:TIBSQL;
begin
  if MyMessageDlg(rs_Do_you_want_to_delete_logbook,mtConfirmation, [mbYes,mbNo],Self)=mrYes then
  begin
    IBQJournal.DisableControls;
    IBQJournal.Close;
    q:=TIBSQL.Create(self);
    try
      q.Database:=dm.ibd_BASE;
      q.Transaction:=dm.IBTrans_Secondaire;
      q.Sql.Text:='DELETE FROM T_JOURNAL where KLE_DOSSIER=:dossier';
      q.Params[0].AsInteger:=dm.NumDossier;
      try
        q.ExecQuery;
      except
        showmessage(rs_Error_Cannot_delete_Logbook);
      end;
      q.Close;
    finally
      q.Free;
    end;
    dm.IBTrans_Secondaire.CommitRetaining;
    dm.doMAJTableJournal('Purge du journal des opérations');
    IBQJournal.Open;
    IBQJournal.EnableControls;
  end;
end;

procedure TFJournalOperations.SuperFormShow(Sender:TObject);
begin
  Height:=round(TControl(Owner).height*gci_context.TailleFenetre/100);
  width:=round(TControl(Owner).width*gci_context.TailleFenetre/100);
  caption:=rs_Processes_Logbook;
end;

end.

