{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit CompoPerso;

interface

uses
  AdvStatusBar, RunLabel, u_comp_TYLanguage, URLLink, EMailLabel, 
  u_comp_TBlueFlatSpeedButton, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('AdvStatusBar', @AdvStatusBar.Register);
  RegisterUnit('RunLabel', @RunLabel.Register);
  RegisterUnit('u_comp_TYLanguage', @u_comp_TYLanguage.Register);
  RegisterUnit('URLLink', @URLLink.Register);
  RegisterUnit('EMailLabel', @EMailLabel.Register);
  RegisterUnit('u_comp_TBlueFlatSpeedButton', 
    @u_comp_TBlueFlatSpeedButton.Register);
end;

initialization
  RegisterPackage('CompoPerso', @Register);
end.
