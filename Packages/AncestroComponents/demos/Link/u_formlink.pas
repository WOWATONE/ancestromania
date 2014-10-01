unit u_formlink;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Spin, u_ancestrolink, u_ancestroviewer, u_ancestroarc;


type

  { TFormLink }

  TFormLink = class(TForm)
    GraphLink: TGraphLink;
    GraphData: TGraphLinkData;
    GraphMiniature: TGraphLink;
    GraphViewer: TGraphViewer;
    PanelButtons: TPanel;
    PanelGraph: TPanel;
    Zoom: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure ZoomChange(Sender: TObject);
  private
    procedure AddPerson(const indi, indiBegin: TPersonLink; const i,
      lastLevel: integer);
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormLink: TFormLink;

implementation

{$R *.lfm}

{ TFormLink }

const
  LEVEL_BEGIN = 0;

procedure TFormLink.AddPerson(const indi, indiBegin: TPersonLink;
  const i, lastLevel: integer);

begin
  with GraphLink,GraphData do
  begin


    //1=Homme, 2=Femme
    indi.Sexe := i mod 2 + 1;

    indi.KeyPerson := i;
    indi.KeyFather := i * 2;
    indi.KeyMother := i * 2 + 1;
    indi.NumSosa := i;
    Persons.Add(indi);

    if (indi <> GraphData.FirstPerson) then
    begin
      indi.NumSosa:=indi.NumSosa*2+indi.sexe-1;
    end
     else indi.NumSosa:=0;
    case i of
      5:
      begin
        indi.level := LEVEL_BEGIN + 2;
        indi.FTexts[ltName] := 'MILA';
        indi.FTexts[ltJob] := 'Aide ménagère';
        indi.FTexts[ltLastName] := 'Mathilde';
        indi.Colonne := 1;
        indi.FTexts[ltBirthDay] := '16/11/1969';
        indi.FTexts[ltDeathDay] := '';
      end;
      4:
      begin
        indi.level := LEVEL_BEGIN + 1;
        indi.FTexts[ltName] := 'PHILIPPE';
        indi.FTexts[ltJob] := 'Agricultrice';
        indi.FTexts[ltLastName] := 'Justine';
        indi.FTexts[ltBirthDay] := '16/12/1949';
        indi.FTexts[ltDeathDay] := '';
        indi.Colonne := 1;
        AddPerson(TPersonLink.Create, indi, i + 1, indi.level );
      end;
      3:
      begin
        indi.level := LEVEL_BEGIN;
        indi.FTexts[ltName] := 'BELLE';
        indi.FTexts[ltJob] := 'Agricultrice';
        indi.FTexts[ltLastName] := 'Genevièvre';
        indi.FTexts[ltBirthDay] := '12/12/1909';
        indi.FTexts[ltDeathDay] := '';
        indi.Colonne := 0.5;
        AddPerson(TPersonLink.Create, indi, i + 1, indi.level );
      end;
      2:
      begin
        indi.level := LEVEL_BEGIN + 1;
        indi.FTexts[ltName] := 'GIROUX';
        indi.FTexts[ltJob] := 'Informaticien';
        indi.FTexts[ltLastName] := 'Philippe';
        indi.FTexts[ltBirthDay] := '16/01/1945';
        indi.FTexts[ltDeathDay] := '';
        indi.Colonne := 0;
        AddPerson(TPersonLink.Create, indi, i + 1, indi.level );
      end;
      1:
      begin
        indi.level := LEVEL_BEGIN + 2;
        indi.FTexts[ltName] := 'GIROUX';
        indi.FTexts[ltJob] := 'Informaticien';
        indi.FTexts[ltLastName] := 'Matthieu';
        indi.FTexts[ltBirthDay] := '16/12/1975';
        indi.FTexts[ltDeathDay] := '';
        indi.Colonne := 0;
        AddPerson(TPersonLink.Create, indi, i + 1, indi.level );
      end;
    end;
//    writeln('indi ' + IntToStr(indi.Level) + ' ');
  end;

end;

procedure TFormLink.FormCreate(Sender: TObject);
begin
//  GraphLink.Data := GraphData;
//  GraphMiniature.Data := GraphData;
//  GraphLink.Viewer := GraphViewer;
//  GraphMiniature.Viewer := GraphViewer;
  GraphViewer.GraphMiniature:=GraphMiniature;
  GraphViewer.Graph:=GraphLink;
  with GraphLink, GraphData do
  begin
    Persons.Clear;
    FirstPerson.Clear;
    Generations := 3;

    AddPerson(FirstPerson, nil, 1, -1 );

    GraphViewer.Refresh;
    GraphViewer.ZoomAll;
  end;
end;

procedure TFormLink.ZoomChange(Sender: TObject);
begin
  GraphViewer.Zoom:=Zoom.Value;
  GraphViewer.Refresh;
end;

end.
