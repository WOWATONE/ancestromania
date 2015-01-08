unit U_FormTree;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Spin, u_ancestrotree, u_ancestroviewer, u_ancestroarc;

type

  { TForm1 }

  TForm1 = class(TForm)
    GraphTree: TGraphTree;
    GraphData: TGraphTreeData;
    GraphMiniature: TGraphTree;
    GraphViewer: TGraphViewer;
    PanelButtons: TPanel;
    PanelGraph: TPanel;
    Zoom: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure ZoomChange(Sender: TObject);
  private
    procedure AddPerson(const indi, indiParent, indiBegin: TPersonTree; const i,
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

procedure TForm1.AddPerson(const indi, indiParent, indiBegin: TPersonTree;
  const i, lastLevel: integer);

begin
  with GraphTree,GraphData do
  begin


    //1=Homme, 2=Femme
    indi.Sexe := i mod 2 + 1;

    indi.KeyPerson := i;
    indi.KeyFather := i * 2;
    indi.KeyMother := i * 2 + 1;

    if (indiParent <> nil) then
    begin
      Persons.Add(indi);
      indi.Parent:=indiParent;
      indiParent.Childs.Add ( indi );
      indi.NumSosa:=indi.NumSosa*2+indi.sexe-1;
    end
     else indi.NumSosa:=0;
    case i of
      0:
      begin
        indi.level := LEVEL_BEGIN;
        indi.FTexts[ttName] := 'GIROUX';
        indi.FTexts[ttJob] := 'Informaticien';
        indi.FTexts[ttLastName] := 'Matthieu';
        indi.FTexts[ttBirthDay] := '16/12/1975';
        indi.FTexts[ttDeathDay] := '';
        AddPerson(TPersonTree.Create, indi, indiBegin, i + 1, indi.level );
      end;
      1:
      begin
        indi.level := LEVEL_BEGIN + 1;
        indi.FTexts[ttName] := 'PHILIPPE';
        indi.FTexts[ttJob] := 'Agricultrice';
        indi.FTexts[ttLastName] := 'Justine';
        indi.FTexts[ttBirthDay] := '16/12/1949';
        indi.FTexts[ttDeathDay] := '';
        AddPerson(TPersonTree.Create, indi, indiBegin, i + 1, indi.level );
      end;
      2:
      begin
        indi.level := LEVEL_BEGIN + 2;
        indi.FTexts[ttName] := 'PHILIPPE';
        indi.FTexts[ttJob] := 'Agriculteur';
        indi.FTexts[ttLastName] := 'Michel';
        indi.FTexts[ttBirthDay] := '16/11/1905';
        indi.FTexts[ttDeathDay] := '';
        AddPerson(TPersonTree.Create, indiParent, indiBegin, i + 1, indi.level );
      end;
      3:
      begin
        indi.level:=LEVEL_BEGIN+2;
        indi.FTexts[ttName] := 'BASTI';
        indi.FTexts[ttJob] := 'Agricultrice';
        indi.FTexts[ttLastName] := 'Genevièvre';
        indi.FTexts[ttBirthDay] := '12/17/1909';
        indi.FTexts[ttDeathDay] := '';
        AddPerson(TPersonTree.Create, indiBegin, indiBegin, i + 1, indiBegin.level )
      end;
      4:
      begin
        indi.level := LEVEL_BEGIN + 1;
        indi.FTexts[ttName] := 'GIROUX';
        indi.FTexts[ttJob] := 'Informaticien';
        indi.FTexts[ttLastName] := 'Philippe';
        indi.FTexts[ttBirthDay] := '16/01/1945';
        indi.FTexts[ttDeathDay] := '';
        AddPerson(TPersonTree.Create, indi, indiBegin, i + 1, indi.level );
      end;
      5:
      begin
        indi.level := LEVEL_BEGIN + 2;
        indi.FTexts[ttName] := 'BELLE';
        indi.FTexts[ttJob] := 'Agricultrice';
        indi.FTexts[ttLastName] := 'Genevièvre';
        indi.FTexts[ttBirthDay] := '12/12/1909';
        indi.FTexts[ttDeathDay] := '';
        AddPerson(TPersonTree.Create, indiParent, indiBegin, i + 1, indi.level );
      end;
      6:
      begin
        indi.level:=LEVEL_BEGIN+2;
        indi.FTexts[ttName] := 'GIROUX';
        indi.FTexts[ttJob] := 'Agriculteur';
        indi.FTexts[ttLastName] := 'André';
        indi.FTexts[ttBirthDay] := '16/11/1905';
        indi.FTexts[ttDeathDay] := '';
      end;
    end;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  indi: TPersonTree;
begin
{  GraphTree.Data := GraphData;
  GraphMiniature.Data := GraphData;
  GraphTree.Viewer := GraphViewer;
  GraphMiniature.Viewer := GraphViewer;}
  with GraphTree, GraphData do
  begin
    Persons.Clear;
    FirstPerson.Clear;
    indi := FirstPerson;
    Generations := 3;

    //celui de départ
    Persons.Add(FirstPerson);

    AddPerson(indi, nil, indi, 0, -1);

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
