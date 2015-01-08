unit Unit1; 

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, u_buttons_flat,
  TJvXpCheckBoxUnit, TFlatMemoUnit, TFlatGaugeUnit, TFlatPanelUnit,
  TRadioButtonUnit, RLReport;

type

  { TForm1 }

  TForm1 = class(TForm)
    JvXpChecks1: TJvXpCheckBox;
    JvXpChecks2: TJvXpCheckBox;
    FlatGauge1: TFlatGauge;
    FlatMemo1: TFlatMemo;
    FlatPanel1: TFlatPanel;
    FlatRadioButton1: TRadioButton;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

end.

