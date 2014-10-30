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

unit u_form_TriEvent;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,DB,
  IBUpdateSQL,IBQuery,u_comp_TYLanguage,ExtCtrls,U_ExtDBGrid,Forms, u_ancestropictimages,
  u_buttons_appli;

type
  TFTriEvent=class(TF_FormAdapt)
    Language:TYLanguage;
    pBorder:TPanel;
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    Panel1:TPanel;
    Image1:TIATitle;
    qTri:TIBQuery;
    IBUTri:TIBUpdateSQL;
    dsTri:TDataSource;
    dxDBGrid1:TExtDBGrid;
    fpBoutons:TPanel;
    bsfbSelection:TFWOK;
    btnFermer:TFWClose;
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormClose(Sender: TObject; var Action: TCloseAction);
    procedure bsfbSelectionClick(Sender: TObject);
    procedure dsTriStateChange(Sender: TObject);
    procedure dxDBGrid1MouseEnter(Sender: TObject);
    procedure dxDBGrid1MouseLeave(Sender: TObject);
  private
    fModif:boolean;
  public
    property Modif:boolean read fModif write fModif;
    procedure doInit(iKey:Integer;TypEvent:string);
  end;

implementation

uses u_common_const,
     u_common_functions,
     u_genealogy_context,
     u_common_ancestro;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFTriEvent.SuperFormCreate(Sender:TObject);

begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  pGeneral.Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
end;

procedure TFTriEvent.doInit(iKey:Integer;TypEvent:string);
begin
  qTri.Close;
  if TypEvent='I' then
  begin
    qTri.SQL.Text:='select e.ev_ind_clef as ev_clef'
      +',iif(char_length(e.ev_ind_titre_event)>0,e.ev_ind_titre_event,r.ref_eve_lib_long)'
      +'||coalesce('' (''||e.EV_IND_DATE_WRITEN||'')'','''') as ref_eve_lib_long'
      +',e.ev_ind_ordre as ev_ordre'
      +' from  EVENEMENTS_IND e'
      +' inner join ref_evenements r on r.ref_eve_lib_court=e.EV_IND_TYPE'
      +' and r.ref_eve_langue=:langue'
      +' where  e.ev_ind_kle_fiche=:KEY'
      +' order by e.ev_ind_ordre nulls last'
      +'   ,e.ev_ind_datecode nulls last'
      +'   ,r.ref_eve_ecran';
    IBUTri.ModifySQL.Text:='update evenements_ind set EV_IND_ORDRE=:EV_ORDRE'
      +' where EV_IND_CLEF=:EV_CLEF';
  end
  else
  begin
    qTri.SQL.Text:='select e.ev_fam_clef as ev_clef'
      +',iif(char_length(e.ev_fam_titre_event)>0,e.ev_fam_titre_event,r.ref_eve_lib_long)'
      +'||coalesce('' (''||e.EV_fam_DATE_WRITEN||'')'','''') as ref_eve_lib_long'
      +',e.ev_fam_ordre as ev_ordre'
      +' from  EVENEMENTS_fam e'
      +' inner join ref_evenements r on r.ref_eve_lib_court=e.EV_fam_TYPE'
      +' and r.ref_eve_langue=:langue'
      +' where  e.ev_fam_kle_famille=:KEY'
      +' order by e.ev_fam_ordre nulls last'
      +'   ,e.ev_fam_datecode nulls last';
    IBUTri.ModifySQL.Text:='update evenements_fam set EV_fam_ORDRE=:EV_ORDRE'
      +' where EV_fam_CLEF=:EV_CLEF';
  end;
  qTri.Params[0].AsString:=gci_context.Langue;
  qTri.Params[1].AsInteger:=iKey;
  qTri.Open;
end;

procedure TFTriEvent.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_Events_order;
end;

procedure TFTriEvent.SuperFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qTri.Close;
end;

procedure TFTriEvent.bsfbSelectionClick(Sender: TObject);
begin
  if fModif then
    qTri.Post;
  Close;
end;

procedure TFTriEvent.dsTriStateChange(Sender: TObject);
begin
  if dsTri.State in [dsInsert,dsEdit] then
  begin
    bsfbSelection.Enabled:=True;
    fModif:=true;
  end;
end;

procedure TFTriEvent.dxDBGrid1MouseEnter(Sender: TObject);
begin
  // Matthieu pas de style
//dm.ControleurHint.HintStyle.Standard:=true;
end;

procedure TFTriEvent.dxDBGrid1MouseLeave(Sender: TObject);
begin
  // Matthieu pas de style
//dm.ControleurHint.HintStyle.Standard:=false;
end;

end.

