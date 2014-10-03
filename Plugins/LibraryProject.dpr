library LibraryProject;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{--------------------------------------------------------------------------------------------------------
Stucture d un model de dll pour integration dans Ancestrologie

Il vous faut impérativement garder cette strcuture sauf la fenetre Main  qui
n est pas obligatoire
Ainsi que le module DM si vous ne vous servez pas de base de données
--------------------------------------------------------------------------------------------------------}
uses
  Classes,
  SYSUtils,
  DefObjet in 'defobjet.pas',
  U_Form_Main in 'U_Form_Main.pas' {FMain},
  u_dm_plugin in 'u_dm_plugin.pas' {DM: TDataModule};


exports
  InitStartDll,
  InitTitreDll;
begin
end.

