unit u_Form_ChercheNIP;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
{$ENDIF}
  SysUtils,Forms,
  Dialogs,StdCtrls,u_buttons_appli,IBSQL,MaskEdit;

type
  TFChercheNIP=class(TForm)
    bsfbAppliquer:TFWOK;
    eNIP:TMaskEdit;
    Label1:TLabel;
    procedure FormCreate(Sender:TObject);
    procedure bsfbAppliquerClick(Sender:TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    iNip:integer;
  end;

var
  FChercheNIP:TFChercheNIP;

implementation

uses u_Dm,
     u_common_ancestro_functions,
     fonctions_dialogs,
     u_genealogy_context,
     u_common_ancestro;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFChercheNIP.FormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  iNip:=-1;
end;

procedure TFChercheNIP.bsfbAppliquerClick(Sender:TObject);
var
  q:TIBSQL;
  ok:boolean;
begin
  ok:=false;
  if tryStrToInt(Trim(eNip.text),iNip) then
  begin
    q:=TIBSQL.Create(Application);
    try
      q.DataBase:=dm.ibd_BASE;
      q.SQL.ADD('select cle_fiche from individu where kle_dossier=:i_dossier and cle_fiche=:NIP');
      q.Params[0].AsInteger:=dm.NumDossier;
      q.Params[1].AsInteger:=iNip;
      q.ExecQuery;
      iNip:=q.Fields[0].AsInteger;
      q.close;
    finally
      q.Free;
    end;
    ok:=iNip>0;
  end;
  if not ok then
  begin
    MyMessageDlg(rs_No_person_with_this_key,mtInformation,[mbOK],Self);
    iNip:=-1;
  end;
  Close;
end;

end.

