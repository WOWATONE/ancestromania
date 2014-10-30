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

unit u_Form_Infos;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  U_FormAdapt,u_comp_TYLanguage,StdCtrls,
  Controls,ExtCtrls,Classes, u_buttons_appli,
  u_ancestropictimages,SysUtils,u_buttons_defs;

type
  TFInfos=class(TF_FormAdapt)
    pBorder:TPanel;
    Panel7:TPanel;
    Panel9:TPanel;
    Image2:TIATitle;
    Panel10:TPanel;
    Panel11:TPanel;
    Label3:TLabel;
    Label1:TLabel;
    Label2:TLabel;
    Label4:TLabel;
    Label6:TLabel;
    Label7:TLabel;
    Label8:TLabel;
    Label9:TLabel;
    Label11:TLabel;
    Label12:TLabel;
    Label13:TLabel;
    Label14:TLabel;
    Label15:TLabel;
    Label16:TLabel;
    lHommes:TLabel;
    lFemmes:TLabel;
    lIndeter:TLabel;
    lUnions:TLabel;
    lEveInd:TLabel;
    lEveFam:TLabel;
    lAdresses:TLabel;
    lPatronymes:TLabel;
    lImages:TLabel;
    lPays:TLabel;
    lRegions:TLabel;
    lDepts:TLabel;
    lVilles:TLabel;
    lIndividus:TLabel;
    Panel8:TPanel;
    Panel4:TPanel;
    Language:TYLanguage;
    btnCarto:TFWXPButton;
    Label10:TLabel;
    Label20:TLabel;
    lDossier:TLabel;
    FlatPanel1:TPanel;
    btnFermer:TFWClose;
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);

    procedure SpeedButton1Click(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure btnCartoClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
  private

  public
    procedure ShowStats;
  end;

implementation

uses u_dm,
     u_common_const,
     fonctions_dialogs,
     u_genealogy_context,
     u_common_ancestro,
     u_common_ancestro_functions,
     u_Form_Compte_Villes,IBSQL, u_common_functions;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFInfos.ShowStats;
var
  s_Proc:TIBSQL;
begin
  doShowWorking(rs_Please_Wait);
  s_Proc:=TIBSQL.Create(self);
  try
    with s_Proc do
    begin
      DataBase:=dm.ibd_BASE;
      SQL.ADD('SELECT * FROM PROC_COMPTAGE(:DOSSIER)');
      Params[0].AsInteger:=dm.NumDossier;
      ExecQuery;

      while not Eof do
      begin
        if FieldByName('LIBELLE').AsString='INDIVID' then
          lIndividus.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='TUNIONS' then
          lUnions.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='_HOMMES' then
          lHommes.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='_FEMMES' then
          lFemmes.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='INDETER' then
          lIndeter.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='EVE_IND' then
          lEveInd.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='EVE_FAM' then
          lEveFam.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='_VILLES' then
          lVilles.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='PATRONY' then
          lPatronymes.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='___PAYS' then
          lPays.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='REGIONS' then
          lRegions.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='DEPARTE' then
          lDepts.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='MULTIME' then
          lImages.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger)
        else if FieldByName('LIBELLE').AsString='ADRESSE' then
          lAdresses.Caption:=IntToStr(FieldByName('COMPTAGE').AsInteger);

        next;
      end;
      Close;
    end;
  finally
    s_Proc.Free;
    doCloseWorking;
  end;
end;

procedure TFInfos.SuperFormKeyDown(Sender:TObject;var Key:Word;
  Shift:TShiftState);
begin
  case Key of
    VK_ESCAPE:ModalResult:=mrOk;
    _KEY_HELP:p_ShowHelp(_ID_INFOS_DOSSIER);
  end;
end;

procedure TFInfos.SpeedButton1Click(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFInfos.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  btnCarto.Color:=gci_context.ColorLight;
  btnCarto.ColorFrameFocus:=gci_context.ColorLight;
  lDossier.Caption:=fNomDossier;
  Label1.Font.Color:=gci_context.ColorHomme;
  Label2.Font.Color:=gci_context.ColorFemme;

  lHommes.Font.Color:=gci_context.ColorHomme;
  lFemmes.Font.Color:=gci_context.ColorFemme;

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
end;

procedure TFInfos.btnCartoClick(Sender:TObject);
var
  aFCompteVilles:TFCompteVilles;
begin
  aFCompteVilles:=TFCompteVilles.create(self);
  try
    aFCompteVilles.ShowModal;
  finally
    FreeAndNil(aFCompteVilles);
  end;
end;

procedure TFInfos.SuperFormShowFirstTime(Sender:TObject);
begin
  caption:=rs_Caption_folder_infos;
end;

end.

