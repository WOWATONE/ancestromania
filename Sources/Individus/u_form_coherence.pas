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

unit u_form_coherence;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  forms,StdCtrls;

type
  TFCoherence=class(TForm)
    Msg: TLabel;
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormShow(Sender: TObject);
  private
    fFormIndividu:TForm;
    Messages:array[1..19] of string;//même nombre de messages que d'alertes dans u_objet_CoherenceDate

  public
    property FormIndividu:TForm read fFormIndividu write fFormIndividu;
    procedure InitMessages;
    procedure Refresh;
  end;

implementation

uses u_form_individu,
     u_common_const, fonctions_string,
     u_genealogy_context,SysUtils,u_common_ancestro;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFCoherence.SuperFormCreate(Sender:TObject);
begin
  fFormIndividu:=nil;
  InitMessages;
end;

procedure TFCoherence.Refresh;
var
  i:integer;
begin
  if fFormIndividu<>nil then
  begin
    Msg.Caption:='';
    for i:=1 to length(Messages) do
    begin
      if TFIndividu(fFormIndividu).CoherenceDate.Pb[i] then
      begin
        Msg.Caption:=Msg.Caption+_CRLF+Messages[i]+_CRLF;
      end;
    end;
  end;
end;

procedure TFCoherence.InitMessages;
begin
  Messages[ 1  ] := rs_integrity_dead_before_birth_man;
  Messages[ 2  ] := rs_integrity_dead_before_birth_woman;
  Messages[ 3  ] := fs_remplacemsg(rs_integrity_age_hope_to_much_man,[IntToStr(gci_context.AgeMaxiAuDecesHommes)]);
  Messages[ 4  ] := fs_remplacemsg(rs_integrity_age_hope_to_much_woman,[IntToStr(gci_context.AgeMaxiAuDecesFemmes)]);
  Messages[ 5  ] := fs_remplacemsg(rs_integrity_married_age_less_than_minimum_man,[IntToStr(gci_context.AgeMiniMariageHommes)]);
  Messages[ 6  ] := fs_remplacemsg(rs_integrity_married_age_less_than_minimum_woman,[IntToStr(gci_context.AgeMiniMariageFemmes)]);
  Messages[ 7  ] := fs_remplacemsg(rs_integrity_married_more_than_maximum_man,[IntToStr(gci_context.AgeMaxiMariageHommes)]);
  Messages[ 8  ] := fs_remplacemsg(rs_integrity_married_more_than_maximum_woman,[IntToStr(gci_context.AgeMaxiMariageFemmes)]);
  Messages[ 9  ] := fs_remplacemsg(rs_integrity_child_birth_date_less_than_man_mini,[IntToStr(gci_context.AgeMiniNaissanceEnfantHommes)]);
  Messages[ 10 ] := fs_remplacemsg(rs_integrity_child_birth_date_less_than_woman_mini,[IntToStr(gci_context.AgeMiniNaissanceEnfantFemmes)]);
  Messages[ 11 ] := fs_remplacemsg(rs_integrity_child_birth_date_more_than_man_maxi,[IntToStr(gci_context.AgeMaxiNaissanceEnfantHommes)]);
  Messages[ 12 ] := fs_remplacemsg(rs_integrity_child_birth_date_more_than_woman_maxi,[IntToStr(gci_context.AgeMaxiNaissanceEnfantFemmes)]);
  Messages[ 13 ] := rs_integrity_individual_event_before_birth;
  Messages[ 14 ] := rs_integrity_individual_event_after_death;
  Messages[ 15 ] := rs_integrity_family_event_before_birth;
  Messages[ 16 ] := rs_integrity_family_event_after_death;
  Messages[ 17 ] := fs_remplacemsg(rs_integrity_woman_must_have_two_children_in_more_than_days,[IntToStr(gci_context.NbJourEntre2NaissancesNormales)]);
  Messages[ 18 ] := rs_integrity_child_born_more_than_270_days_after_father_death;
  Messages[ 19 ] := rs_integrity_child_born_after_mother_death;
end;

procedure TFCoherence.SuperFormShow(Sender: TObject);
begin
  Caption:=rs_Caption_Bad_dates;
  ClientWidth:=Msg.Width+2;
  ClientHeight:=Msg.Height;
end;

end.

