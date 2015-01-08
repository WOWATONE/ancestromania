unit U_FormArc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Spin, u_ancestroarc, u_ancestroviewer, U_OnFormInfoIni, u_buttons_appli;

type

  { TForm1 }

  TForm1 = class(TForm)
    GraphArc: TGraphArc;
    GraphData: TGraphArcData;
    GraphMiniature: TGraphArc;
    GraphViewer: TGraphViewer;
    OnFormInfoIni: TOnFormInfoIni;
    PanelButtons: TPanel;
    PanelGraph: TPanel;
    Zoom: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure ZoomChange(Sender: TObject);
  private
    procedure AddPerson(const indi, indiParent, indiBegin: TPersonArc; const i,
      lastLevel: integer);
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }

const
  LEVEL_BEGIN = 0;

procedure TForm1.AddPerson(const indi, indiParent, indiBegin: TPersonArc;
  const i, lastLevel: integer);
var
  k, level: integer;

begin
  with GraphArc, GraphData do
  begin
    //1=Homme, 2=Femme
    indi.Sexe := i mod 2 + 1;

    indi.Angle := 0;
    indi.KeyPerson := i;
    indi.KeyFather := i * 2;
    indi.KeyMother := i * 2 + 1;
    if (indiParent <> nil) then
    begin
      Persons.Add(indi);
      k := indiParent.Childs.Add(indi);
      indi.idxOrder := (indiParent.idxOrder * 2) + k;
      indi.idxPlotCenter := (indi.idxOrder * 2) + 1;
    end
    else
    begin
      indi.idxOrder := 0;
      indi.idxPlotCenter := 1;
    end;
    case i of
      0:
      begin
        indi.level := LEVEL_BEGIN;
        indi.FTexts[atName] := 'GIROUX';
        indi.FTexts[atJob] := 'Informaticien';
        indi.FTexts[atLastName] := 'Matthieu';
        indi.FTexts[atBirthDay] := '16/12/1975';
        indi.FTexts[atDeathDay] := '';
        AddPerson(TPersonArc.Create, indi, indiBegin, i + 1, indi.level );
      end;
      1:
      begin
        indi.level := LEVEL_BEGIN + 1;
        indi.FTexts[atName] := 'PHILIPPE';
        indi.FTexts[atJob] := 'Agricultrice';
        indi.FTexts[atLastName] := 'Justine';
        indi.FTexts[atBirthDay] := '16/12/1949';
        indi.FTexts[atDeathDay] := '';
        AddPerson(TPersonArc.Create, indi, indiBegin, i + 1, indi.level );
      end;
      2:
      begin
        indi.level := LEVEL_BEGIN + 2;
        indi.FTexts[atName] := 'PHILIPPE';
        indi.FTexts[atJob] := 'Agriculteur';
        indi.FTexts[atLastName] := 'Michel';
        indi.FTexts[atBirthDay] := '16/11/1905';
        indi.FTexts[atDeathDay] := '';
        AddPerson(TPersonArc.Create, indiParent, indiBegin, i + 1, indi.level );
      end;
      3:
      begin
        indi.level:=LEVEL_BEGIN+2;
        indi.FTexts[atName] := 'BASTI';
        indi.FTexts[atJob] := 'Agricultrice';
        indi.FTexts[atLastName] := 'Genevièvre';
        indi.FTexts[atBirthDay] := '12/17/1909';
        indi.FTexts[atDeathDay] := '';
        AddPerson(TPersonArc.Create, indiBegin, indiBegin, i + 1, indiBegin.level )
      end;
      4:
      begin
        indi.level := LEVEL_BEGIN + 1;
        indi.FTexts[atName] := 'GIROUX';
        indi.FTexts[atJob] := 'Informaticien';
        indi.FTexts[atLastName] := 'Philippe';
        indi.FTexts[atBirthDay] := '16/01/1945';
        indi.FTexts[atDeathDay] := '';
        AddPerson(TPersonArc.Create, indi, indiBegin, i + 1, indi.level );
      end;
      5:
      begin
        indi.level := LEVEL_BEGIN + 2;
        indi.FTexts[atName] := 'BELLE';
        indi.FTexts[atJob] := 'Agricultrice';
        indi.FTexts[atLastName] := 'Genevièvre';
        indi.FTexts[atBirthDay] := '12/12/1909';
        indi.FTexts[atDeathDay] := '';
        AddPerson(TPersonArc.Create, indiParent, indiBegin, i + 1, indi.level );
      end;
      6:
      begin
        indi.level:=LEVEL_BEGIN+2;
        indi.FTexts[atName] := 'GIROUX';
        indi.FTexts[atJob] := 'Agriculteur';
        indi.FTexts[atLastName] := 'André';
        indi.FTexts[atBirthDay] := '16/11/1905';
        indi.FTexts[atDeathDay] := '';
      end;
    end;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  indi: TPersonArc;
begin
  with GraphArc, GraphData do
  begin
    Persons.Clear;
    FirstPerson.Clear;
    indi := FirstPerson;
    indi.idxOrder := 0;
    indi.idxPlotCenter := 1;
    Generations := 3;

    //celui de d?part
    Persons.Add(FirstPerson);

    AddPerson(indi, nil, indi, 0, -1);

    //on s'assure que les hommes sont ? droite, et les femmes ? gauche
    Order;
    GraphViewer.Refresh;
    GraphViewer.ZoomAll;
  end;
end;


procedure TForm1.ZoomChange(Sender: TObject);
begin
  GraphViewer.Zoom:=Zoom.Value;
  GraphViewer.Refresh;
end;

end.
