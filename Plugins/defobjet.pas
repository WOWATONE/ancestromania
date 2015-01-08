unit DefObjet;
{--------------------------------------------------------------------------------------------------------
Stucture d un model de dll pour integration dans Ancestrologie

Il vous faut impérativement garder les 2 methodes
InitTitreDll
et
InitStartDll

et ne pas changer le parametre passé dans InitStartDll, celui ci est le nom et le chemin de la
base de données d Ancestrologie
Si vous n avez pas besoin de base de données, ce n est pas grave
--------------------------------------------------------------------------------------------------------}

interface
uses Dialogs,
  Forms,
  u_form_main,
  fonctions_string,
  classes;
procedure InitStartDll(value: Pchar);
function InitTitreDll: Pchar;
function RetourDll: PInteger;

var gb_isDLL : Boolean = False ;

implementation
uses U_DM_Plugin;

function InitTitreDll: pchar;
begin
  result := PChar( fs_getCorrectString ( 'My Ancestro Plugin' ));
end;

function RetourDll: PInteger;
begin
  Result := PInteger(-10)
end;

procedure InitStartDll(value: Pchar);
{--------------------------------------------------------------------------------------------------------
Cette fonction est celle qui lance la DLL quand on clique sur l'option deu menu des ADD'ons
C'est ici que vous lancez ce que vous voulez

Ne pas supprimer le parametre passé a cette fonction, si vous ne vous en servez pas, ce n'est pas
grave, celui ci recoit le nom et chemin de la base de donnée D ancestrologie
--------------------------------------------------------------------------------------------------------}
var aFMain: TF_PluginAncestro;
  sBase: string;
begin
  gb_isDLL := True;
  sbase := value;
  aFMain := TF_PluginAncestro.create(Application);
  aFMain.ShowModal;
  aFMain.Free;
end;
end.
