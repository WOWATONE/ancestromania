unit u_Form_select_rep;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  ShlObj, Windows,
{$ELSE}
{$ENDIF}
  SysUtils, Forms,
  StdCtrls, ShellCtrls, ExtCtrls, u_buttons_appli, U_OnFormInfoIni;

type

  { TfSelect_rep }

  TfSelect_rep = class(TForm)
    btnclose: TFWClose;
    btnGO: TFWOK;
    lFonction: TLabel;
    OnFormInfoIni: TOnFormInfoIni;
    Panel1: TPanel;
    Panel2: TPanel;
    ShellTV: TShellTreeView;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    fPathInit:string;
  public
    { Déclarations publiques }
    Property PathInit:String Write fPathInit;
  end;

implementation

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}
Uses
     u_genealogy_context;

procedure TfSelect_rep.FormCreate(Sender: TObject);
begin
   Color:=gci_context.ColorLight;
   {$IFNDEF WINDOWS}
   ShellTV.Root:=GetUserDir;
   {$ENDIF}
end;

end.
