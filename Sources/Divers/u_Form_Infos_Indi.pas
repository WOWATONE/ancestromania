unit u_Form_Infos_Indi;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
{$ENDIF}
  SysUtils,Forms,StdCtrls,ExtCtrls, u_ancestropictimages,u_buttons_appli,
  IBSQL;

type

  { TFInfosIndi }

  TFInfosIndi=class(TForm)
    btnClose: TFWClose;
    Panel1: TPanel;
    Panel2:TPanel;
    Panel3:TPanel;
    Image1:TIATitle;
    l11:TLabel;
    cxGroupBox1:TGroupBox;
    l2:TLabel;
    l3:TLabel;
    l4:TLabel;
    l5:TLabel;
    l6:TLabel;
    l8:TLabel;
    l9:TLabel;
    l10:TLabel;
    lConjoints:TLabel;
    lEnfants:TLabel;
    lfreres:TLabel;
    lOncles:TLabel;
    lCousins:TLabel;
    lEvenements:TLabel;
    lMedias:TLabel;
    lAdresses:TLabel;
    IBQComptage:TIBSQL;
    lPtEnfants: TLabel;
    Label2: TLabel;
    lNeveux: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure doInit(clef:Integer);
  end;

implementation

uses
     u_genealogy_context,
     u_common_ancestro;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFInfosIndi.doInit(clef:Integer);
begin
  Caption:=rs_Information;
  with IBQComptage do
  begin
    ParamByName('iclef').AsInteger:=Clef;
    ExecQuery;
    while not eof do
    begin
      if FieldByName('Titre').AsString='UNION' then
        lConjoints.Caption:=IntToStr(FieldByName('Combien').AsInteger)
      else if FieldByName('Titre').AsString='ENFAN' then
        lEnfants.Caption:=IntToStr(FieldByName('Combien').AsInteger)
      else if FieldByName('Titre').AsString='PTENF' then
        lPtEnfants.Caption:=IntToStr(FieldByName('Combien').AsInteger)
      else if FieldByName('Titre').AsString='NEVEU' then
        lNeveux.Caption:=IntToStr(FieldByName('Combien').AsInteger)
      else if FieldByName('Titre').AsString='FRERE' then
        lFreres.Caption:=IntToStr(FieldByName('Combien').AsInteger)
      else if FieldByName('Titre').AsString='ONCLE' then
        lOncles.Caption:=IntToStr(FieldByName('Combien').AsInteger)
      else if FieldByName('Titre').AsString='COUSI' then
        lCousins.Caption:=IntToStr(FieldByName('Combien').AsInteger)
      else if FieldByName('Titre').AsString='EVENT' then
        lEvenements.Caption:=IntToStr(FieldByName('Combien').AsInteger)
      else if FieldByName('Titre').AsString='MEDIA' then
        lMedias.Caption:=IntToStr(FieldByName('Combien').AsInteger)
      else if FieldByName('Titre').AsString='ADRES' then
        lAdresses.Caption:=IntToStr(FieldByName('Combien').AsInteger);
      next;
    end;
    Close;
  end;
end;

procedure TFInfosIndi.FormCreate(Sender: TObject);
begin
  Color:=gci_context.ColorLight;
end;

end.

