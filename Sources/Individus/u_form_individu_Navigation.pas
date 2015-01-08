{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_form_individu_Navigation;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
  Forms,Controls,StdCtrls,Classes,SysUtils,Graphics,
  ExtCtrls,Dialogs,DB,IBCustomDataSet,IBQuery,Math,IBSQL,
  Menus,ExtJvXPButtons, CompSuperForm,
  u_framework_components, u_ancestropictbuttons,
  PrintersDlgs, U_ExtDBImage, U_ExtImage,
  U_FormAdapt, u_ancestropictimages;

type

  { TFIndividuNavigation }

  TFIndividuNavigation=class(TF_FormAdapt)
    btnConjoints: TJvXPButton;
    btnCousins: TJvXPButton;
    btnEnfants: TJvXPButton;
    btnFreres: TJvXPButton;
    btnHistoire: TXAHistory;
    btnListeActe: TJvXPButton;
    btnNeveux: TJvXPButton;
    btnOncles: TJvXPButton;
    btnPetitsEnfants: TJvXPButton;
    gbEnfant1: TPanel;
    gbEnfant2: TPanel;
    gbEnfant3: TPanel;
    gbEnfant4: TPanel;
    gbEnfant5: TPanel;
    gbEpouse1: TPanel;
    gbEpouse2: TPanel;
    gbEpouse3: TPanel;
    gbGMM: TPanel;
    gbGMP: TPanel;
    gbGPM: TPanel;
    gbGPP: TPanel;
    gbIndi: TPanel;
    gbMere: TPanel;
    gbpere: TPanel;
    GMMPlus: TLabel;
    GMPPlus: TLabel;
    GPMPlus: TLabel;
    GPPPlus: TLabel;
    iPhotoEnfant1: TExtImage;
    iPhotoEnfant2: TExtImage;
    iPhotoEnfant3: TExtImage;
    iPhotoEnfant4: TExtImage;
    iPhotoEnfant5: TExtImage;
    iPhotoEpouse1: TExtImage;
    iPhotoEpouse2: TExtImage;
    iPhotoEpouse3: TExtImage;
    iPhotoGMM: TExtImage;
    iPhotoGMP: TExtImage;
    iPhotoGPM: TExtImage;
    iPhotoGPP: TExtImage;
    iPhotoIndi: TExtImage;
    iPhotoMere: TExtImage;
    iPhotoPere: TExtImage;
    lAge: TLabel;
    lDecesIndi: TFWLabel;
    lDecesMere: TLabel;
    lDecesPere: TLabel;
    lIndiNe: TFWLabel;
    lInfosCouple1: TLabel;
    lInfosCouple2: TLabel;
    lInfosCouple3: TLabel;
    lNeEnfant1: TLabel;
    lNeEnfant2: TLabel;
    lNeEnfant3: TLabel;
    lNeEnfant4: TLabel;
    lNeEnfant5: TLabel;
    lNeEpouse1: TLabel;
    lNeEpouse2: TLabel;
    lNeEpouse3: TLabel;
    lNeGMM: TLabel;
    lNeGMP: TLabel;
    lNeGPM: TLabel;
    lNeGPP: TLabel;
    lNeMere: TLabel;
    lNePere: TLabel;
    lNomEnfant1: TLabel;
    lNomEnfant2: TLabel;
    lNomEnfant3: TLabel;
    lNomEnfant4: TLabel;
    lNomEnfant5: TLabel;
    lNomEpouse1: TLabel;
    lNomEpouse2: TLabel;
    lNomEpouse3: TLabel;
    lNomGMM: TLabel;
    lNomGMP: TLabel;
    lNomGPM: TLabel;
    lNomGPP: TLabel;
    lNomIndi: TFWLabel;
    lNomMere: TLabel;
    lNomPere: TLabel;
    lPlusdeFemme: TLabel;
    lPrenomIndi: TFWLabel;
    lProfIndi: TFWLabel;
    lProfMere: TLabel;
    lProfPere: TLabel;
    lSosaIndi: TLabel;
    lUnionEpouse1: TLabel;
    lUnionEpouse2: TLabel;
    lUnionEpouse3: TLabel;
    nbEnfants1: TLabel;
    nbEnfants2: TLabel;
    nbEnfants3: TLabel;
    nbEnfants4: TLabel;
    nbEnfants5: TLabel;
    nbEnfantsConjoint1: TLabel;
    nbEnfantsConjoint2: TLabel;
    nbEnfantsConjoint3: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    pBouton: TPanel;
    pEnsemble:TPanel;
    dsNaviguer:TDataSource;
    ibNaviguer:TIBQuery;
    popup_Enfants:TPopupMenu;
    ImageList1:TImageList;
    lPlusEnfants:TLabel;
    popup_Conjoints:TPopupMenu;
    Image1:TIAHuman;
    cxDBImage1:TExtDBImage;
    Popup_PetitsEnfants:TPopupMenu;
    Popup_Neveux:TPopupMenu;
    popup_FreresSoeurs:TPopupMenu;
    popup_CousinsCousines:TPopupMenu;
    Popup_Oncles:TPopupMenu;
    ibNaviguerNIVEAU:TLongintField;
    ibNaviguerCLE_FICHE:TLongintField;
    ibNaviguerNOM:TIBStringField;
    ibNaviguerPRENOM:TIBStringField;
    ibNaviguerDATE_NAISSANCE:TIBStringField;
    ibNaviguerDATE_DECES:TIBStringField;
    ibNaviguerSEXE:TLongintField;
    ibNaviguerCLE_PERE:TLongintField;
    ibNaviguerCLE_MERE:TLongintField;
    ibNaviguerSOSA:TFloatField;
    ibNaviguerDECEDE:TLongintField;
    ibNaviguerVILLE_NAISSANCE:TIBStringField;
    ibNaviguerVILLE_DECES:TIBStringField;
    ibNaviguerPROFESSION:TIBStringField;
    ibNaviguerDATE_UNION:TIBStringField;
    ibNaviguerVILLE_UNION:TIBStringField;
    ibNaviguerPHOTO:TBlobField;
    ibNaviguerENFANTS:TLongintField;
    ibNaviguerNUM_SOSA:TFloatField;
    ibNaviguerPERIODE_VIE:TIBStringField;
    pConjoints:TPanel;
    dxComponentPrinter1:TPrinterSetupDialog;
    Shape1: TShape;
    Shape2: TShape;
    Shape4: TShape;
    Shape5: TShape;
    sSosaEnfant1: TShape;
    sSosaEnfant2: TShape;
    sSosaEnfant3: TShape;
    sSosaEnfant4: TShape;
    sSosaEnfant5: TShape;
    sSosaEpouse1: TShape;
    sSosaEpouse2: TShape;
    sSosaEpouse3: TShape;
    sSosaGMM: TShape;
    sSosaGMP: TShape;
    sSosaGPM: TShape;
    sSosaGPP: TShape;
    pEnfants:TPanel;
    PmImprime: TPopupMenu;
    mImpression: TMenuItem;
    sSosaIndi: TShape;
    sSosaMere: TShape;
    sSosaPere: TShape;
    procedure SuperFormCreate(Sender:TObject);
    procedure doChangeIndi(Sender:TObject);
    procedure SuperFormShow(Sender:TObject);
    procedure btnEnfantsClick(Sender:TObject);
    procedure lPlusEnfantsClick(Sender:TObject);
    procedure lPlusdeFemmeClick(Sender:TObject);
    procedure btnConjointsClick(Sender:TObject);
    procedure btnPetitsEnfantsClick(Sender:TObject);
    procedure btnNeveuxClick(Sender:TObject);
    procedure btnFreresClick(Sender:TObject);
    procedure btnCousinsClick(Sender:TObject);
    procedure btnOnclesClick(Sender:TObject);
    procedure FormClose(Sender:TObject;var Action:TCloseAction);
    procedure btnHistoireClick(Sender:TObject);
    procedure btnListeActeClick(Sender:TObject);
    procedure mImpressionClick(Sender: TObject);

  private
    fFirstShow:boolean;
    GFormIndividu : TSuperForm;
    iIndiActif,lnbEnfants,lnbEpouses,SexeIndi:integer;
    procedure OnSelectIndividu(Sender:TObject);
    procedure ImprimeLaFiche;
  public
    property FirstShow:boolean read fFirstShow write fFirstShow;
    procedure doInitialize(iFiche:integer);
    function doOpenQuerys:boolean;
  end;

implementation

uses u_dm,u_form_individu,
     u_Common_Const,u_Form_Main,
     u_common_functions,u_common_ancestro,
     u_genealogy_context,
     u_common_ancestro_functions,
     u_form_Actes_Liste,fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFIndividuNavigation.SuperFormCreate(Sender:TObject);
begin
  GFormIndividu:=(owner as TFMain).aFIndividu;
  color:=gci_context.ColorLight;
  Width:=670;

  lNomGPP.Font.Color:=gci_context.ColorHomme;
  lNomGMP.Font.Color:=gci_context.ColorFemme;
  lNomGPM.Font.Color:=gci_context.ColorHomme;
  lNomGMM.Font.Color:=gci_context.ColorFemme;

  iIndiActif:=-1;
  fFirstShow:=true;
end;

procedure TFIndividuNavigation.doInitialize(iFiche:integer);
begin
  if iIndiActif<>iFiche then
  begin
    iIndiActif:=iFiche;
    doOpenQuerys;
  end;
end;

function TFIndividuNavigation.doOpenQuerys:boolean;
var
  nbEpouse,nbEnfants,nbPetitsEnfants,nbNeveux,nbFreres,nbCousins,nbOncles:integer;
  NewItem:TMenuItem;
  sNom,s_Naiss,sHint,s,sNaisIndi:string;
  iSosa,i:integer;
  test:boolean;
  Menfant1,Menfant2,Menfant3,Menfant4,Menfant5:integer;
  procedure p_setEnfants (const gbEnfant : TWinControl; const MEnfant:Integer);
  Begin
    with gbEnfant1 do
    if (HelpContext=gbEpouse1.Tag)or(MEnfant=gbEpouse1.Tag) then
      Font.Color:=gbEpouse1.Font.Color
    else if (gbEnfant1.HelpContext=gbEpouse2.Tag)or(MEnfant=gbEpouse2.Tag) then
      Font.Color:=gbEpouse2.Font.Color
    else if (gbEnfant1.HelpContext=gbEpouse3.Tag)or(MEnfant=gbEpouse3.Tag) then
      Font.Color:=gbEpouse3.Font.Color
    else
      Font.Color:=clGray;
  End;
begin
  ibNaviguer.close;
  ibNaviguer.Params[0].AsInteger:=iIndiActif;

  iPhotoIndi.Stretch:=gci_context.Photos;
  if gci_context.Photos then
  begin
// Matthieu ?
    ibNaviguer.Params[1].AsInteger:=1
  end
  else
  begin
    ibNaviguer.Params[1].AsInteger:=3;
  end;

  ibNaviguer.Open;

  gbPere.Tag:=-1;
  gbMere.Tag:=-1;

  iPhotoIndi.Picture.Assign(Image1.Picture);
  lProfIndi.caption:='';
  lNomIndi.caption:='';
  lPrenomIndi.caption:='';
  lIndiNe.caption:='';
  lDecesIndi.caption:='';
  lAge.caption:='';

  iPhotoPere.Picture.Assign(Image1.Picture);
  iPhotoMere.Picture.Assign(Image1.Picture);
  lNomPere.Caption:='';
  lNomMere.Caption:='';
  lNePere.Caption:='';
  lNeMere.Caption:='';
  lDecesPere.Caption:='';
  lDecesMere.Caption:='';

  iPhotoEpouse1.Picture.Assign(Image1.Picture);
  lNomEpouse1.Caption:='';
  lNeEpouse1.Caption:='';
  lUnionEpouse1.Caption:='';

  iPhotoEpouse2.Picture.Assign(Image1.Picture);
  lNomEpouse2.Caption:='';
  lNeEpouse2.Caption:='';
  lUnionEpouse2.Caption:='';

  iPhotoEpouse3.Picture.Assign(Image1.Picture);
  lNomEpouse3.Caption:='';
  lNeEpouse3.Caption:='';
  lUnionEpouse3.Caption:='';

  lNomEnfant1.Caption:='';
  lNeEnfant1.Caption:='';
  iPhotoEnfant1.Picture.Assign(Image1.Picture);
  Menfant1:=0;

  lNomEnfant2.Caption:='';
  lNeEnfant2.Caption:='';
  iPhotoEnfant2.Picture.Assign(Image1.Picture);
  Menfant2:=0;

  lNomEnfant3.Caption:='';
  lNeEnfant3.Caption:='';
  iPhotoEnfant3.Picture.Assign(Image1.Picture);
  Menfant3:=0;

  lNomEnfant4.Caption:='';
  lNeEnfant4.Caption:='';
  iPhotoEnfant4.Picture.Assign(Image1.Picture);
  Menfant4:=0;

  lNomEnfant5.Caption:='';
  lNeEnfant5.Caption:='';
  iPhotoEnfant5.Picture.Assign(Image1.Picture);
  Menfant5:=0;

  lNomGPP.Caption:='';
  lNomGMP.Caption:='';
  lNomGPM.Caption:='';
  lNomGMM.Caption:='';
  lNeGPP.Caption:='';
  lNeGMP.Caption:='';
  lNeGPM.Caption:='';
  lNeGMM.Caption:='';
  iPhotoGPP.Picture.Assign(Image1.Picture);
  iPhotoGMP.Picture.Assign(Image1.Picture);
  iPhotoGPM.Picture.Assign(Image1.Picture);
  iPhotoGMM.Picture.Assign(Image1.Picture);

  lInfosCouple1.Caption:='';
  lInfosCouple2.Caption:='';
  lInfosCouple3.Caption:='';
  lProfPere.caption:='';
  lProfMere.caption:='';

  gbEpouse1.Hide;
  gbEpouse2.Hide;
  gbEpouse3.Hide;

  gbEnfant1.Hide;
  gbEnfant2.Hide;
  gbEnfant3.Hide;
  gbEnfant4.Hide;
  gbEnfant5.Hide;

  btnEnfants.Enabled:=False;
  btnConjoints.Enabled:=False;
  btnPetitsEnfants.Enabled:=False;

  nbEpouse:=0;
  nbEnfants:=0;
  nbPetitsEnfants:=0;
  nbNeveux:=0;
  nbFreres:=0;
  nbCousins:=0;
  nbOncles:=0;

  nbEnfantsConjoint1.Visible:=false;
  nbEnfantsConjoint2.Visible:=false;
  nbEnfantsConjoint3.Visible:=false;

  lPlusdeFemme.Hide;
  lPlusEnfants.Hide;

  GPPPlus.Visible:=false;
  GMPPlus.Visible:=false;
  GPMPlus.Visible:=false;
  GMMPlus.Visible:=false;

  popup_Enfants.Items.Clear;
  popup_Conjoints.Items.Clear;
  Popup_PetitsEnfants.Items.Clear;
  Popup_Neveux.Items.Clear;
  popup_FreresSoeurs.Items.Clear;
  popup_CousinsCousines.Items.Clear;
  Popup_Oncles.Items.Clear;

  sSosaEpouse1.Visible:=false;
  sSosaEpouse2.Visible:=false;
  sSosaEpouse3.Visible:=false;
  sSosaEnfant1.Visible:=false;
  sSosaEnfant2.Visible:=false;
  sSosaEnfant3.Visible:=false;
  sSosaEnfant4.Visible:=false;
  sSosaEnfant5.Visible:=false;
  sSosaPere.Visible:=false;
  sSosaMere.Visible:=false;
  sSosaGPP.Visible:=false;
  sSosaGMP.Visible:=false;
  sSosaGPM.Visible:=false;
  sSosaGMM.Visible:=false;
  sSosaIndi.Visible:=false;

  lSosaIndi.Caption:='';

  Caption:=' '+TFIndividu(GFormIndividu).GetNomIndividu;

  gbPere.Hint:='';
  gbMere.Hint:='';
  gbGPP.Hint:='';
  gbGPM.Hint:='';
  gbGMP.Hint:='';
  gbGMM.Hint:='';

  with ibNaviguer do
  while not eof do
  begin
      // -- calcul du sosa et génération ----------------------------------
    if FieldByName('NUM_SOSA').AsFloat>=1 then
      iSosa:=Trunc(Log2(FieldByName('NUM_SOSA').AsFloat))+1
    else
      iSosa:=0;

      //---------------------------------------------------------------------

      // -- Génération du hint ------------------------------------
    sHint:=
      AssembleString([
      FieldByName('NOM').AsString,
        FieldByName('PRENOM').AsString]);

    if FieldByName('NUM_SOSA').AsFloat>=1 then
      sHint:=sHint+_CRLF+fs_RemplaceMsg(rs_Caption_SOSA_No_Generation_mini,[FieldByName('NUM_SOSA').AsString,IntToStr(iSosa)]);

    if FieldByName('PROFESSION').AsString>'' then
      sHint:=sHint+_CRLF+_CRLF+fs_RemplaceMsg(rs_Job_is,[FieldByName('PROFESSION').AsString]);

    if FieldByName('DATE_NAISSANCE').AsString>'' then
      sHint:=sHint+_CRLF+_CRLF+fs_RemplaceMsg(rs_Born_on,[FieldByName('DATE_NAISSANCE').AsString]);
    if FieldByName('VILLE_NAISSANCE').AsString>'' then
      sHint:=sHint+' '+rs_at_where+' '+FieldByName('VILLE_NAISSANCE').AsString;

    if FieldByName('DATE_DECES').AsString>'' then
      sHint:=sHint+_CRLF+fs_RemplaceMsg(rs_Death_on,[FieldByName('DATE_DECES').AsString]);
    if FieldByName('VILLE_DECES').AsString>'' then
      sHint:=sHint+' '+rs_at_where+' '+FieldByName('VILLE_DECES').AsString;

    if FieldByName('DATE_UNION').AsString>'' then
      sHint:=sHint+_CRLF+fs_RemplaceMsg(rs_Married_on,[FieldByName('DATE_UNION').AsString]);
    if FieldByName('VILLE_UNION').AsString>'' then
      sHint:=sHint+' '+rs_at_where+' '+FieldByName('VILLE_UNION').AsString;

      // ---------------------------------------------------------

    sNom:=AssembleString([ibNaviguerNOM.AsString,ibNaviguerPRENOM.AsString]);

    case FieldByName('NIVEAU').AsInteger of
      0:// l'individu
        begin
          gbIndi.Tag:=FieldByName('CLE_FICHE').AsInteger;
//          Panel1.Tag:=gbIndi.Tag;
          sNaisIndi:=FieldByName('DATE_NAISSANCE').AsString;
          btnHistoire.Visible:=sNaisIndi>'';
          btnHistoire.Hint:=fs_RemplaceMsg(rs_Hint_History_on_year_of_birth_of,[sNom]);

          lNomIndi.Caption:=FieldByName('NOM').AsString;
          lPreNomIndi.Caption:=FieldByName('PRENOM').AsString;

          if FieldByName('NUM_SOSA').AsFloat>=1 then
            lSosaIndi.Caption:=fs_RemplaceMsg(rs_Caption_SOSA_No_Generation_mini,[FieldByName('NUM_SOSA').AsString,floattostr(iSosa)]);

          if cxDBImage1.Picture.Height>0 then
            iPhotoIndi.Picture.Assign(cxDBImage1.Picture);

          SexeIndi:=ibNaviguerSEXE.AsInteger;

          if FieldByName('SEXE').AsInteger=2 then
          begin
//            gbIndi.BorderStyle.:=gci_context.ColorFemme;

            if sNaisIndi>'' then
              lIndiNe.Caption:=fs_RemplaceMsg(rs_Born_on_female,[sNaisIndi]);
            if FieldByName('DATE_DECES').AsString>'' then
              lDecesIndi.Caption:=fs_RemplaceMsg(rs_Death_on_female,[FieldByName('DATE_DECES').AsString]);

            lNomIndi.Font.Color:=gci_context.ColorFemme;
            lPrenomIndi.Font.Color:=gci_context.ColorFemme;
          end
          else
          begin
//            gbIndi.style.BorderColor:=gci_context.ColorHomme;

            if sNaisIndi>'' then
              lIndiNe.Caption:=fs_RemplaceMsg(rs_Born_on_male,[sNaisIndi]);
            if FieldByName('DATE_DECES').AsString>'' then
              lDecesIndi.Caption:=fs_RemplaceMsg(rs_Death_on_male,[FieldByName('DATE_DECES').AsString]);

            lNomIndi.Font.Color:=gci_context.ColorHomme;
            lPrenomIndi.Font.Color:=gci_context.ColorHomme;
          end;

          if FieldByName('VILLE_NAISSANCE').AsString>'' then
            lIndiNe.Caption:=lIndiNe.Caption+' '+rs_at_where+' '+FieldByName('VILLE_NAISSANCE').AsString;
          if FieldByName('VILLE_DECES').AsString>'' then
            lDecesIndi.Caption:=lDecesIndi.Caption+' '+rs_at_where+' '+FieldByName('VILLE_DECES').AsString;

          lProfIndi.caption:=FieldByName('PROFESSION').AsString;

          if (FieldByName('DECEDE').AsInteger<>1)or(Trim(FieldByName('DATE_DECES').AsString)='') then
          begin
            i:=Age_Vivant(sNaisIndi,s);
            if i>0 then
            begin
              if ((FieldByName('SEXE').AsInteger=2)and ((i/365.25)<gci_context.AgeMaxiAuDecesFemmes))
                or ((FieldByName('SEXE').AsInteger<>2)and ((i/365.25)<gci_context.AgeMaxiAuDecesHommes))then
                lAge.Caption:=s;
            end;
            lAge.Visible:=Length(lAge.Caption)>0;
          end;

          sSosaIndi.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
        end;
      1:// les parents
        begin
          if Length(sNom)>35 then
            sNom:=Copy(sNom,1,35)+' ...';

          if FieldByName('SOSA').AsInteger=2 then
          begin
            lNomPere.Caption:=sNom;

                // -- Affectation du hint ------------------------------------
            gbPere.Hint:=sHint;
                // -----------------------------------------------------------

            if cxDBImage1.Picture.Height>0 then
              iPhotoPere.Picture.Assign(cxDBImage1.Picture);

            gbPere.Tag:=FieldByName('CLE_FICHE').AsInteger;
            lNomPere.Font.Color:=gci_context.ColorHomme;

            lProfPere.caption:=FieldByName('PROFESSION').AsString;

            if FieldByName('DATE_NAISSANCE').AsString>'' then
              lNePere.Caption:=fs_RemplaceMsg(rs_Born_on_male,[FieldByName('DATE_NAISSANCE').AsString]);

            if FieldByName('VILLE_NAISSANCE').AsString>'' then
            begin
              if Length(lNePere.Caption)>38 then
                lNePere.Caption:=Copy(lNePere.Caption,1,38)+'...'
              else
                lNePere.Caption:=lNePere.Caption;
            end;

            if FieldByName('DATE_DECES').AsString>'' then
              lDecesPere.Caption:=fs_RemplaceMsg(rs_Death_on_male,[FieldByName('DATE_DECES').AsString]);

            if FieldByName('VILLE_DECES').AsString>'' then
            begin
              if Length(lDecesPere.Caption)>38 then
                lDecesPere.Caption:=Copy(lDecesPere.Caption,1,38)+'...'
              else
                lDecesPere.Caption:=lDecesPere.Caption;
            end;

            sSosaPere.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
          end
          else if FieldByName('SOSA').AsInteger=3 then
          begin
            lNomMere.Caption:=sNom;

                // -- Affectation du hint ------------------------------------
            gbMere.Hint:=sHint;
                // -----------------------------------------------------------

            if cxDBImage1.Picture.Height>0 then
              iPhotoMere.Picture.Assign(cxDBImage1.Picture);

            gbMere.Tag:=FieldByName('CLE_FICHE').AsInteger;
            lNomMere.Font.Color:=gci_context.ColorFemme;

            lProfMere.caption:=FieldByName('PROFESSION').AsString;

            if FieldByName('DATE_NAISSANCE').AsString>'' then
              lNeMere.Caption:=fs_RemplaceMsg(rs_Born_on_female,[FieldByName('DATE_NAISSANCE').AsString]);

            if FieldByName('VILLE_NAISSANCE').AsString>'' then
            begin
              if Length(lNeMere.Caption)>38 then
                lNeMere.Caption:=Copy(lNeMere.Caption,1,38)+'...'
              else
                lNeMere.Caption:=lNeMere.Caption;
            end;

            if FieldByName('DATE_DECES').AsString>'' then
              lDecesMere.Caption:=fs_RemplaceMsg(rs_Death_on_female,[FieldByName('DATE_DECES').AsString]);

            if FieldByName('VILLE_DECES').AsString>'' then
            begin
              if Length(lDecesMere.Caption)>38 then
                lDecesMere.Caption:=Copy(lDecesMere.Caption,1,38)+'...'
              else
                lDecesMere.Caption:=lDecesMere.Caption;
            end;

            sSosaMere.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
          end
        end;
      7:// les epouses
        begin
          inc(nbEpouse);

          NewItem:=TMenuItem.create(self);
          popup_Conjoints.Items.Add(NewItem);
          NewItem.Tag:=FieldByName('CLE_FICHE').AsInteger;

          if FieldByName('ENFANTS').AsInteger>0 then
            NewItem.Caption:=sNom+' - a '+FieldByName('ENFANTS').AsString+' enfant(s)'
          else
            NewItem.Caption:=sNom;

          NewItem.Onclick:=OnSelectIndividu;

          if FieldByName('SEXE').AsInteger=1 then
            NewItem.ImageIndex:=1
          else
            NewItem.ImageIndex:=0;

          if FieldByName('NUM_SOSA').AsFloat>0 then
            NewItem.ImageIndex:=NewItem.ImageIndex+2;

          if Length(sNom)>39 then
            sNom:=Copy(sNom,1,39)+' ...';

            // -- Dans les GB -----------------------------------------------
            // -- Conjoint 1 -----------------------------------------------
          if length(lNomEpouse1.Caption)<=0 then
          begin
            gbEpouse1.tag:=FieldByName('CLE_FICHE').AsInteger;

            if cxDBImage1.Picture.Height>0 then
              iPhotoEpouse1.Picture.Assign(cxDBImage1.Picture);

            lNomEpouse1.Caption:=sNom;
            lNeEpouse1.Caption:=FieldByName('PERIODE_VIE').AsString;

                // -- Affectation du hint ------------------------------------
            gbEpouse1.Hint:=sHint;
                // -----------------------------------------------------------

            if FieldByName('DATE_UNION').AsString>'' then
              lUnionEpouse1.caption:='x '+AssembleString([
                FieldByName('DATE_UNION').AsString,
                  FieldByName('VILLE_UNION').AsString]);

            nbEnfantsConjoint1.Caption:=FieldByName('ENFANTS').AsString;
            nbEnfantsConjoint1.Hint:=fs_RemplaceMsg(rs_Hint_This_person_has_got_child_ren,[FieldByName('ENFANTS').AsString]);
            nbEnfantsConjoint1.Visible:=FieldByName('ENFANTS').AsInteger>0;

            if FieldByName('ENFANTS').AsInteger>0 then
              gbEpouse1.Font.Color:=clRed
            else
              gbEpouse1.Font.Color:=clWindowText;

            if FieldByName('SEXE').AsInteger=2 then
            begin
              lNomEpouse1.Font.Color:=gci_context.ColorFemme;
              s:=Age_Texte(sNaisIndi,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                lInfosCouple1.Caption:=fs_RemplaceMsg(rs_Caption_Herself,[s]);
              s:=Age_Texte(FieldByName('DATE_NAISSANCE').AsString,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                if Length(lInfosCouple1.Caption)>0 then
                  lInfosCouple1.Caption:=lInfosCouple1.Caption+' - '+fs_RemplaceMsg(rs_Caption_Itself_union,[s])
                else
                  lInfosCouple1.Caption:=fs_RemplaceMsg(rs_Caption_Itself_union,[s]);
            end
            else
            begin
              lNomEpouse1.Font.Color:=gci_context.ColorHomme;
              s:=Age_Texte(FieldByName('DATE_NAISSANCE').AsString,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                lInfosCouple1.Caption:=fs_RemplaceMsg(rs_Caption_Himself,[s]);
              s:=Age_Texte(sNaisIndi,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                if Length(lInfosCouple1.Caption)>0 then
                  lInfosCouple1.Caption:=lInfosCouple1.Caption+' - '+fs_RemplaceMsg(rs_Caption_Itself_union,[s])
                else
                  lInfosCouple1.Caption:=fs_RemplaceMsg(rs_Caption_Itself_union,[s]);
            end;

            gbEpouse1.Visible:=Length(lNomEpouse1.Caption)>0;
            sSosaEpouse1.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
          end;
            // -- Conjoint 2 -----------------------------------------------
          if (length(lNomEpouse2.Caption)<=0)and
            (gbEpouse1.tag<>FieldByName('CLE_FICHE').AsInteger) then
          begin
            gbEpouse2.tag:=FieldByName('CLE_FICHE').AsInteger;

            lNomEpouse2.Caption:=sNom;

                // -- Affectation du hint ------------------------------------
            gbEpouse2.Hint:=sHint;
                // -----------------------------------------------------------

            if cxDBImage1.Picture.Height>0 then
              iPhotoEpouse2.Picture.Assign(cxDBImage1.Picture);

            lNeEpouse2.Caption:=FieldByName('PERIODE_VIE').AsString;
            if FieldByName('DATE_UNION').AsString>'' then
              lUnionEpouse2.caption:='x '+AssembleString([
                FieldByName('DATE_UNION').AsString,
                  FieldByName('VILLE_UNION').AsString]);

            nbEnfantsConjoint2.Caption:=FieldByName('ENFANTS').AsString;
            nbEnfantsConjoint2.Hint:=fs_RemplaceMsg(rs_Hint_This_person_has_got_child_ren,[FieldByName('ENFANTS').AsString]);
            nbEnfantsConjoint2.Visible:=FieldByName('ENFANTS').AsInteger>0;

            if FieldByName('ENFANTS').AsInteger>0 then
              gbEpouse2.Font.Color:=clLime
            else
              gbEpouse2.Font.Color:=clWindowText;

            if FieldByName('SEXE').AsInteger=2 then
            begin
              lNomEpouse2.Font.Color:=gci_context.ColorFemme;
              s:=Age_Texte(sNaisIndi,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                lInfosCouple2.Caption:=fs_RemplaceMsg(rs_Caption_Herself,[s]);
              s:=Age_Texte(FieldByName('DATE_NAISSANCE').AsString,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                if Length(lInfosCouple2.Caption)>0 then
                  lInfosCouple2.Caption:=lInfosCouple2.Caption+' - '+fs_RemplaceMsg(rs_Caption_Itself_union,[s])
                else
                  lInfosCouple2.Caption:=fs_RemplaceMsg(rs_Caption_Itself_union,[s]);
            end
            else
            begin
              lNomEpouse2.Font.Color:=gci_context.ColorHomme;
              s:=Age_Texte(FieldByName('DATE_NAISSANCE').AsString,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                lInfosCouple2.Caption:=fs_RemplaceMsg(rs_Caption_Himself,[s]);
              s:=Age_Texte(sNaisIndi,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                if Length(lInfosCouple2.Caption)>0 then
                  lInfosCouple2.Caption:=lInfosCouple2.Caption+' - '+fs_RemplaceMsg(rs_Caption_Itself_union,[s])
                else
                  lInfosCouple2.Caption:=fs_RemplaceMsg(rs_Caption_Itself_union,[s]);
            end;

            gbEpouse2.Visible:=Length(lNomEpouse2.Caption)>0;
            sSosaEpouse2.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
          end;
            // -- Conjoint 3 -----------------------------------------------
          if (length(lNomEpouse3.Caption)<=0)and
            (gbEpouse1.tag<>FieldByName('CLE_FICHE').AsInteger)and
            (gbEpouse2.tag<>FieldByName('CLE_FICHE').AsInteger) then
          begin
            gbEpouse3.tag:=FieldByName('CLE_FICHE').AsInteger;

            lNomEpouse3.Caption:=sNom;

                // -- Affectation du hint ------------------------------------
            gbEpouse3.Hint:=sHint;
                // -----------------------------------------------------------

            if cxDBImage1.Picture.Height>0 then
              iPhotoEpouse3.Picture.Assign(cxDBImage1.Picture);

            lNeEpouse3.Caption:=FieldByName('PERIODE_VIE').AsString;
            if FieldByName('DATE_UNION').AsString>'' then
              lUnionEpouse3.caption:='x '+AssembleString([
                FieldByName('DATE_UNION').AsString,
                  FieldByName('VILLE_UNION').AsString]);

            nbEnfantsConjoint3.Caption:=FieldByName('ENFANTS').AsString;
            nbEnfantsConjoint3.Hint:=fs_RemplaceMsg(rs_Hint_This_person_has_got_child_ren,[FieldByName('ENFANTS').AsString]);
            nbEnfantsConjoint3.Visible:=FieldByName('ENFANTS').AsInteger>0;

            if FieldByName('ENFANTS').AsInteger>0 then
              gbEpouse3.Font.Color:=clBlue
            else
              gbEpouse3.Font.Color:=clWindowText;

            if FieldByName('SEXE').AsInteger=2 then
            begin
              lNomEpouse3.Font.Color:=gci_context.ColorFemme;
              s:=Age_Texte(sNaisIndi,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                lInfosCouple3.Caption:=fs_RemplaceMsg(rs_Caption_Herself,[s]);
              s:=Age_Texte(FieldByName('DATE_NAISSANCE').AsString,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                if Length(lInfosCouple3.Caption)>0 then
                  lInfosCouple3.Caption:=lInfosCouple3.Caption+' - '+fs_RemplaceMsg(rs_Caption_Itself_union,[s])
                else
                  lInfosCouple3.Caption:=fs_RemplaceMsg(rs_Caption_Itself_union,[s]);
            end
            else
            begin
              lNomEpouse3.Font.Color:=gci_context.ColorHomme;
              s:=Age_Texte(FieldByName('DATE_NAISSANCE').AsString,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                lInfosCouple3.Caption:=fs_RemplaceMsg(rs_Caption_Himself,[s]);
              s:=Age_Texte(sNaisIndi,FieldByName('DATE_UNION').AsString);
              if Length(s)>0 then
                if Length(lInfosCouple3.Caption)>0 then
                  lInfosCouple3.Caption:=lInfosCouple3.Caption+' - '+fs_RemplaceMsg(rs_Caption_Itself_union,[s])
                else
                  lInfosCouple3.Caption:=fs_RemplaceMsg(rs_Caption_Itself_union,[s]);
            end;

            gbEpouse3.Visible:=Length(lNomEpouse3.Caption)>0;
            sSosaEpouse3.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
          end;
            // --------------------------------------------------------------
        end;

      5:// Enfants
        begin

            //on fabrique la chaine de caracteres -------
          inc(nbEnfants);
          s_Naiss:=GetStringNaissanceDeces(trim(FieldByName('DATE_NAISSANCE').AsString)
            ,trim(FieldByName('DATE_DECES').AsString));

          NewItem:=TMenuItem.create(self);
          popup_Enfants.Items.Add(NewItem);
          NewItem.Tag:=FieldByName('CLE_FICHE').AsInteger;
          NewItem.Caption:=AssembleString([FieldByName('NOM').AsString,FieldByName('PRENOM').AsString])
            +s_Naiss;
          if s_Naiss>'' then
            s_Naiss:=copy(s_Naiss,2,length(s_Naiss));

          NewItem.Onclick:=OnSelectIndividu;

          if FieldByName('SEXE').AsInteger=1 then
            NewItem.ImageIndex:=1
          else
            NewItem.ImageIndex:=0;

          if FieldByName('NUM_SOSA').AsFloat>0 then
            NewItem.ImageIndex:=NewItem.ImageIndex+2;

          if Length(sNom)>36 then
            sNom:=Copy(sNom,1,36)+' ...';

            // -- Dans les GB -----------------------------------------------
          if length(lNomEnfant1.Caption)<=0 then
          begin
            gbEnfant1.tag:=FieldByName('CLE_FICHE').AsInteger;
            gbEnfant1.HelpContext:=FieldByName('CLE_PERE').AsInteger;
            MEnfant1:=FieldByName('CLE_MERE').AsInteger;

            lNomEnfant1.Caption:=sNom;

                // -- Affectation du hint ------------------------------------
            gbEnfant1.Hint:=sHint;
                // -----------------------------------------------------------

            if cxDBImage1.Picture.Height>0 then
              iPhotoEnfant1.Picture.Assign(cxDBImage1.Picture);

            if FieldByName('SEXE').AsInteger=2 then
              lNomEnfant1.Font.Color:=gci_context.ColorFemme
            else
              lNomEnfant1.Font.Color:=gci_context.ColorHomme;

            lNeEnfant1.Caption:=s_Naiss;

            nbEnfants1.Caption:=FieldByName('ENFANTS').AsString;
            nbEnfants1.Hint:=fs_RemplaceMsg(rs_Hint_This_person_has_got_child_ren,[FieldByName('ENFANTS').AsString]);
            nbEnfants1.Visible:=FieldByName('ENFANTS').AsInteger>0;

            gbEnfant1.Visible:=Length(lNomEnfant1.Caption)>0;
            sSosaEnfant1.Visible:=FieldByName('NUM_SOSA').AsFloat>0;

          end;

          if (length(lNomEnfant2.Caption)<=0)and
            (gbEnfant1.tag<>FieldByName('CLE_FICHE').AsInteger) then
          begin
            gbEnfant2.tag:=FieldByName('CLE_FICHE').AsInteger;
            gbEnfant2.HelpContext:=FieldByName('CLE_PERE').AsInteger;
            MEnfant2:=FieldByName('CLE_MERE').AsInteger;

            lNomEnfant2.Caption:=sNom;

                // -- Affectation du hint ------------------------------------
            gbEnfant2.Hint:=sHint;
                // -----------------------------------------------------------

            if cxDBImage1.Picture.Height>0 then
              iPhotoEnfant2.Picture.Assign(cxDBImage1.Picture);

            if FieldByName('SEXE').AsInteger=2 then
              lNomEnfant2.Font.Color:=gci_context.ColorFemme
            else
              lNomEnfant2.Font.Color:=gci_context.ColorHomme;

            lNeEnfant2.Caption:=s_Naiss;

            nbEnfants2.Caption:=FieldByName('ENFANTS').AsString;
            nbEnfants2.Hint:=fs_RemplaceMsg(rs_Hint_This_person_has_got_child_ren,[FieldByName('ENFANTS').AsString]);
            nbEnfants2.Visible:=FieldByName('ENFANTS').AsInteger>0;

            gbEnfant2.Visible:=Length(lNomEnfant2.Caption)>0;
            sSosaEnfant2.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
          end;

          if (length(lNomEnfant3.Caption)<=0)and
            (gbEnfant1.tag<>FieldByName('CLE_FICHE').AsInteger)and
            (gbEnfant2.tag<>FieldByName('CLE_FICHE').AsInteger) then
          begin
            gbEnfant3.tag:=FieldByName('CLE_FICHE').AsInteger;
            gbEnfant3.HelpContext:=FieldByName('CLE_PERE').AsInteger;
            MEnfant3:=FieldByName('CLE_MERE').AsInteger;

            lNomEnfant3.Caption:=sNom;

                // -- Affectation du hint ------------------------------------
            gbEnfant3.Hint:=sHint;
                // -----------------------------------------------------------

            if cxDBImage1.Picture.Height>0 then
              iPhotoEnfant3.Picture.Assign(cxDBImage1.Picture);

            if FieldByName('SEXE').AsInteger=2 then
              lNomEnfant3.Font.Color:=gci_context.ColorFemme
            else
              lNomEnfant3.Font.Color:=gci_context.ColorHomme;

            lNeEnfant3.Caption:=s_Naiss;

            nbEnfants3.Caption:=FieldByName('ENFANTS').AsString;
            nbEnfants3.Hint:=fs_RemplaceMsg(rs_Hint_This_person_has_got_child_ren,[FieldByName('ENFANTS').AsString]);
            nbEnfants3.Visible:=FieldByName('ENFANTS').AsInteger>0;

            gbEnfant3.Visible:=Length(lNomEnfant3.Caption)>0;
            sSosaEnfant3.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
          end;

          if (length(lNomEnfant4.Caption)<=0)and
            (gbEnfant1.tag<>FieldByName('CLE_FICHE').AsInteger)and
            (gbEnfant2.tag<>FieldByName('CLE_FICHE').AsInteger)and
            (gbEnfant3.tag<>FieldByName('CLE_FICHE').AsInteger) then
          begin

            gbEnfant4.tag:=FieldByName('CLE_FICHE').AsInteger;
            gbEnfant4.HelpContext:=FieldByName('CLE_PERE').AsInteger;
            MEnfant4:=FieldByName('CLE_MERE').AsInteger;

            lNomEnfant4.Caption:=sNom;

                // -- Affectation du hint ------------------------------------
            gbEnfant4.Hint:=sHint;
                // -----------------------------------------------------------

            if cxDBImage1.Picture.Height>0 then
              iPhotoEnfant4.Picture.Assign(cxDBImage1.Picture);

            if FieldByName('SEXE').AsInteger=2 then
              lNomEnfant4.Font.Color:=gci_context.ColorFemme
            else
              lNomEnfant4.Font.Color:=gci_context.ColorHomme;

            lNeEnfant4.Caption:=s_Naiss;

            nbEnfants4.Caption:=FieldByName('ENFANTS').AsString;
            nbEnfants4.Hint:=fs_RemplaceMsg(rs_Hint_This_person_has_got_child_ren,[FieldByName('ENFANTS').AsString]);
            nbEnfants4.Visible:=FieldByName('ENFANTS').AsInteger>0;

            gbEnfant4.Visible:=Length(lNomEnfant4.Caption)>0;
            sSosaEnfant4.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
          end;

          if (length(lNomEnfant5.Caption)<=0)and
            (gbEnfant1.tag<>FieldByName('CLE_FICHE').AsInteger)and
            (gbEnfant2.tag<>FieldByName('CLE_FICHE').AsInteger)and
            (gbEnfant3.tag<>FieldByName('CLE_FICHE').AsInteger)and
            (gbEnfant4.tag<>FieldByName('CLE_FICHE').AsInteger) then
          begin

            gbEnfant5.tag:=FieldByName('CLE_FICHE').AsInteger;
            gbEnfant5.HelpContext:=FieldByName('CLE_PERE').AsInteger;
            MEnfant5:=FieldByName('CLE_MERE').AsInteger;

            lNomEnfant5.Caption:=sNom;

                // -- Affectation du hint ------------------------------------
            gbEnfant5.Hint:=sHint;
                // -----------------------------------------------------------

            if cxDBImage1.Picture.Height>0 then
              iPhotoEnfant5.Picture.Assign(cxDBImage1.Picture);

            if FieldByName('SEXE').AsInteger=2 then
              lNomEnfant5.Font.Color:=gci_context.ColorFemme
            else
              lNomEnfant5.Font.Color:=gci_context.ColorHomme;

            lNeEnfant5.Caption:=s_Naiss;

            nbEnfants5.Caption:=FieldByName('ENFANTS').AsString;
            nbEnfants5.Hint:=fs_RemplaceMsg(rs_Hint_This_person_has_got_child_ren,[FieldByName('ENFANTS').AsString]);
            nbEnfants5.Visible:=FieldByName('ENFANTS').AsInteger>0;

            gbEnfant5.Visible:=Length(lNomEnfant5.Caption)>0;
            sSosaEnfant5.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
          end;
            // --------------------------------------------------------------
        end;

      2:// Grands parents
        begin
            //on fabrique la chaine de caracteres -------

          if Length(sNom)>17 then
            sNom:=Copy(sNom,1,17)+' ...';

          case FieldByName('SOSA').AsInteger of
            4:// GP Paternel
              begin
                gbGPP.tag:=FieldByName('CLE_FICHE').AsInteger;

                lNomGPP.Caption:=sNom;

                  // -- Affectation du hint ------------------------------------
                gbGPP.Hint:=sHint;
                  // -----------------------------------------------------------

                lNeGPP.Caption:=ConvertDeathDate(FieldByName('PERIODE_VIE').AsString);

                if cxDBImage1.Picture.Height>0 then
                  iPhotoGPP.Picture.Assign(cxDBImage1.Picture);

                GPPPlus.Visible:=(FieldByName('CLE_PERE').AsInteger>0)or(FieldByName('CLE_MERE').AsInteger>0);
                sSoSaGPP.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
              end;

            5:// GM Paternelle
              begin
                gbGMP.tag:=FieldByName('CLE_FICHE').AsInteger;

                lNomGMP.Caption:=sNom;

                  // -- Affectation du hint ------------------------------------
                gbGMP.Hint:=sHint;
                  // -----------------------------------------------------------

                lNeGMP.Caption:=ConvertDeathDate(FieldByName('PERIODE_VIE').AsString);

                if cxDBImage1.Picture.Height>0 then
                  iPhotoGMP.Picture.Assign(cxDBImage1.Picture);

                GMPPlus.Visible:=(FieldByName('CLE_PERE').AsInteger>0)or(FieldByName('CLE_MERE').AsInteger>0);
                sSoSaGMP.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
              end;
            6:// GP Maternel
              begin
                gbGPM.tag:=FieldByName('CLE_FICHE').AsInteger;

                lNomGPM.Caption:=sNom;

                  // -- Affectation du hint ------------------------------------
                gbGPM.Hint:=sHint;
                  // -----------------------------------------------------------

                lNeGPM.Caption:=ConvertDeathDate(FieldByName('PERIODE_VIE').AsString);

                if cxDBImage1.Picture.Height>0 then
                  iPhotoGPM.Picture.Assign(cxDBImage1.Picture);

                GPMPlus.Visible:=(FieldByName('CLE_PERE').AsInteger>0)or(FieldByName('CLE_MERE').AsInteger>0);
                sSoSaGPM.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
              end;
            7:// GM Maternelle
              begin
                gbGMM.tag:=FieldByName('CLE_FICHE').AsInteger;

                lNomGMM.Caption:=sNom;

                  // -- Affectation du hint ------------------------------------
                gbGMM.Hint:=sHint;
                  // -----------------------------------------------------------

                lNeGMM.Caption:=ConvertDeathDate(FieldByName('PERIODE_VIE').AsString);

                if cxDBImage1.Picture.Height>0 then
                  iPhotoGMM.Picture.Assign(cxDBImage1.Picture);

                GMMPlus.Visible:=(FieldByName('CLE_PERE').AsInteger>0)or(FieldByName('CLE_MERE').AsInteger>0);
                sSoSaGMM.Visible:=FieldByName('NUM_SOSA').AsFloat>0;
              end;
          end;
        end;
      8:// Petits enfants
        begin
          inc(nbPetitsEnfants);

            //on fabrique la chaine de caracteres -------
          s_Naiss:=GetStringNaissanceDeces(trim(FieldByName('DATE_NAISSANCE').AsString)
            ,trim(FieldByName('DATE_DECES').AsString));

          NewItem:=TMenuItem.create(self);
          Popup_PetitsEnfants.Items.Add(NewItem);
          NewItem.Tag:=FieldByName('CLE_FICHE').AsInteger;
          NewItem.Caption:=AssembleString([FieldByName('NOM').AsString,FieldByName('PRENOM').AsString])
            +s_Naiss;

          NewItem.Onclick:=OnSelectIndividu;

          if FieldByName('SEXE').AsInteger=1 then
            NewItem.ImageIndex:=1
          else
            NewItem.ImageIndex:=0;

          if FieldByName('NUM_SOSA').AsFloat>0 then
            NewItem.ImageIndex:=NewItem.ImageIndex+2;

        end;

      9:// Neveux et nieces
        begin
          inc(nbNeveux);

            //on fabrique la chaine de caracteres -------
          s_Naiss:=GetStringNaissanceDeces(trim(FieldByName('DATE_NAISSANCE').AsString)
            ,trim(FieldByName('DATE_DECES').AsString));

          NewItem:=TMenuItem.create(self);
          popup_Neveux.Items.Add(NewItem);
          NewItem.Tag:=FieldByName('CLE_FICHE').AsInteger;
          NewItem.Caption:=AssembleString([FieldByName('NOM').AsString,FieldByName('PRENOM').AsString])
            +s_Naiss;

          NewItem.Onclick:=OnSelectIndividu;

          if FieldByName('SEXE').AsInteger=1 then
            NewItem.ImageIndex:=1
          else
            NewItem.ImageIndex:=0;

          if FieldByName('NUM_SOSA').AsFloat>0 then
            NewItem.ImageIndex:=NewItem.ImageIndex+2;

        end;

      4:// Freres et soeurs
        begin
          inc(nbFreres);

            //on fabrique la chaine de caracteres -------
          s_Naiss:=GetStringNaissanceDeces(trim(FieldByName('DATE_NAISSANCE').AsString)
            ,trim(FieldByName('DATE_DECES').AsString));

          NewItem:=TMenuItem.create(self);
          popup_FreresSoeurs.Items.Add(NewItem);
          NewItem.Tag:=FieldByName('CLE_FICHE').AsInteger;
          NewItem.Caption:=AssembleString([FieldByName('NOM').AsString,FieldByName('PRENOM').AsString])
            +s_Naiss;

          NewItem.Onclick:=OnSelectIndividu;

          if FieldByName('SEXE').AsInteger=1 then
            NewItem.ImageIndex:=1
          else if FieldByName('SEXE').AsInteger=2 then
            NewItem.ImageIndex:=0;

          if FieldByName('NUM_SOSA').AsFloat>0 then
            NewItem.ImageIndex:=NewItem.ImageIndex+2;

        end;

      6:// Cousins Cousines
        begin
          test:=true;
          for i:=0 to popup_CousinsCousines.Items.Count-1 do
            if popup_CousinsCousines.Items[i].Tag=FieldByName('CLE_FICHE').AsInteger then
            begin
              test:=false;
              break;
            end;//AL2009 pour éviter cousins en double (ex: enfants de 2 frères mariés avec 2 surs)
          if test then
          begin
            inc(nbCousins);
              //on fabrique la chaine de caracteres -------
            s_Naiss:=GetStringNaissanceDeces(trim(FieldByName('DATE_NAISSANCE').AsString)
              ,trim(FieldByName('DATE_DECES').AsString));
            NewItem:=TMenuItem.create(self);
            popup_CousinsCousines.Items.Add(NewItem);
            NewItem.Tag:=FieldByName('CLE_FICHE').AsInteger;
            NewItem.Caption:=AssembleString([FieldByName('NOM').AsString,FieldByName('PRENOM').AsString])
              +s_Naiss;
            NewItem.Onclick:=OnSelectIndividu;
            if FieldByName('SEXE').AsInteger=1 then
              NewItem.ImageIndex:=1
            else
              NewItem.ImageIndex:=0;
            if FieldByName('NUM_SOSA').AsFloat>0 then
              NewItem.ImageIndex:=NewItem.ImageIndex+2;
          end;
        end;

      3:// Oncles et tantes
        begin

          inc(nbOncles);

            //on fabrique la chaine de caracteres -------
          s_Naiss:=GetStringNaissanceDeces(trim(FieldByName('DATE_NAISSANCE').AsString)
            ,trim(FieldByName('DATE_DECES').AsString));

          NewItem:=TMenuItem.create(self);
          popup_Oncles.Items.Add(NewItem);
          NewItem.Tag:=FieldByName('CLE_FICHE').AsInteger;
          NewItem.Caption:=AssembleString([FieldByName('NOM').AsString,FieldByName('PRENOM').AsString])
            +s_Naiss;
          NewItem.Onclick:=OnSelectIndividu;

          if FieldByName('SEXE').AsInteger=1 then
            NewItem.ImageIndex:=1
          else
            NewItem.ImageIndex:=0;

          if FieldByName('NUM_SOSA').AsFloat>0 then
            NewItem.ImageIndex:=NewItem.ImageIndex+2;

        end;

    end;

    Next;
  end;

  lnbEnfants:=nbEnfants;
  lnbEpouses:=nbEpouse;

  btnEnfants.Caption:=fs_RemplaceMsg(rs_Caption_Children,[IntToStr(nbEnfants)]);
  lPlusEnfants.Visible:=nbEnfants>5;
  btnEnfants.Enabled:=nbEnfants>0;

  btnConjoints.Caption:=fs_RemplaceMsg(rs_Caption_Joints,[IntToStr(nbEpouse)]);
  lPlusdeFemme.Visible:=nbEpouse>3;
  btnConjoints.Enabled:=nbEpouse>0;

  btnPetitsEnfants.Caption:=fs_RemplaceMsg(rs_Caption_Grandchildren,[IntToStr(nbPetitsEnfants)]);
  btnPetitsEnfants.Enabled:=nbPetitsEnfants>0;

  btnNeveux.Caption:=fs_RemplaceMsg(rs_Caption_Nephews_Nieces,[IntToStr(nbNeveux)]);
  btnNeveux.Enabled:=nbNeveux>0;

  btnFreres.Caption:=fs_RemplaceMsg(rs_Caption_Brothers_Sisters,[IntToStr(nbFreres)]);
  btnFreres.Enabled:=nbFreres>0;

  btnCousins.Caption:=fs_RemplaceMsg(rs_Caption_Cousins,[IntToStr(nbCousins)]);
  btnCousins.Enabled:=nbCousins>0;

  btnOncles.Caption:=fs_RemplaceMsg(rs_Caption_Uncles_Aunts,[IntToStr(nbOncles)]);
  btnOncles.Enabled:=nbOncles>0;

  p_setEnfants ( gbEnfant1, Menfant1 );
  p_setEnfants ( gbEnfant2, Menfant2 );
  p_setEnfants ( gbEnfant3, Menfant3 );
  p_setEnfants ( gbEnfant4, Menfant4 );
  p_setEnfants ( gbEnfant5, Menfant5 );

  result:=true;
end;

procedure TFIndividuNavigation.doChangeIndi(Sender:TObject);
var
  aTag:integer;
begin
  if (TComponent(Sender).ClassType=TLabel) then
    aTag:=TComponent(Sender).GetParentComponent.Tag
  else if (TComponent(Sender).ClassType=TExtImage) then
    aTag:=TComponent(Sender).GetParentComponent.Tag
  else if (TComponent(Sender).ClassType=tPanel) then
    aTag:=TComponent(Sender).GetParentComponent.Tag
  else if (TComponent(Sender).ClassType=TFWLabel) then
    aTag:=TComponent(Sender).GetParentComponent.Tag
  else
    aTag:=TComponent(Sender).Tag;

  if aTag>0 then
  begin
    dm.individu_clef:=aTag;
    DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
  end;
end;

procedure TFIndividuNavigation.SuperFormShow(Sender:TObject);
begin
  iPhotoIndi.Stretch:=gci_context.Photos;

  color:=gci_context.ColorLight;
  fFirstShow:=false;
end;

procedure TFIndividuNavigation.btnEnfantsClick(Sender:TObject);
var
  p:tpoint;
begin
  p.x:=0;
  p.y:=0;
  p:=TControl(Sender).clienttoscreen(p);
  popup_Enfants.popup(p.x,p.y+btnEnfants.height);
end;

procedure TFIndividuNavigation.OnSelectIndividu(Sender:TObject);
begin
  dm.individu_clef:=TComponent(Sender).Tag;
  DoSendMessage(FMain,'OPEN_MODULE_INDIVIDU');
end;

procedure TFIndividuNavigation.lPlusEnfantsClick(Sender:TObject);
begin
  btnEnfantsClick(btnEnfants);
end;

procedure TFIndividuNavigation.lPlusdeFemmeClick(Sender:TObject);
begin
  btnConjointsClick(btnConjoints);
end;

procedure TFIndividuNavigation.btnConjointsClick(Sender:TObject);
var
  p:tpoint;
begin
  p.x:=0;
  p.y:=0;
  p:=TControl(Sender).clienttoscreen(p);
  popup_Conjoints.popup(p.x,p.y+btnConjoints.height);
end;

procedure TFIndividuNavigation.btnPetitsEnfantsClick(Sender:TObject);
var
  p:tpoint;
begin
  p.x:=0;
  p.y:=0;
  p:=TControl(Sender).clienttoscreen(p);
  Popup_PetitsEnfants.popup(p.x,p.y+btnPetitsEnfants.height);
end;

procedure TFIndividuNavigation.btnNeveuxClick(Sender:TObject);
var
  p:tpoint;
begin
  p.x:=0;
  p.y:=0;
  p:=TControl(Sender).clienttoscreen(p);
  Popup_Neveux.popup(p.x,p.y+btnNeveux.height);
end;

procedure TFIndividuNavigation.btnFreresClick(Sender:TObject);
var
  p:tpoint;
begin
  p.x:=0;
  p.y:=0;
  p:=TControl(Sender).clienttoscreen(p);
  popup_FreresSoeurs.popup(p.x,p.y+btnFreres.height);
end;

procedure TFIndividuNavigation.btnCousinsClick(Sender:TObject);
var
  p:tpoint;
begin
  p.x:=0;
  p.y:=0;
  p:=TControl(Sender).clienttoscreen(p);
  popup_CousinsCousines.popup(p.x,p.y+btnCousins.height);
end;

procedure TFIndividuNavigation.btnOnclesClick(Sender:TObject);
var
  p:tpoint;
begin
  p.x:=0;
  p.y:=0;
  p:=TControl(Sender).clienttoscreen(p);
  popup_Oncles.popup(p.x,p.y+btnOncles.height);
end;

procedure TFIndividuNavigation.FormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  ibNaviguer.close;
  FMain.NavigationLeft:=Left;
  FMain.NavigationTop:=Top;
  Action:=caFree;
  DoSendMessage(FMain,'FERME_NAVIGATION');
end;

procedure TFIndividuNavigation.btnHistoireClick(Sender:TObject);
var
  s_Query:TIBSQL;
  iID:integer;
begin
  s_Query:=TIBSQL.Create(Application);

  with s_Query do
  begin
    DataBase:=dm.ibd_BASE;
    SQL.ADD('SELECT FIRST(1) ANNEE_NAISSANCE AS QUI FROM INDIVIDU WHERE CLE_FICHE = :CLEF');
    Params[0].AsInteger:=gbIndi.Tag;
    ExecQuery;
    iID:=FieldByName('QUI').asInteger;
    Close;
  end;
  s_Query.Free;

  GoToThisUrl(URL_WIKIPEDIA+IntToStr(iID));
end;

procedure TFIndividuNavigation.btnListeActeClick(Sender:TObject);
var
  aFActesListe:TFActesListe;
  bModified:boolean;
begin

  if FMain.aFIndividu.bsfbAppliquer.Enabled then
  begin
    ShowMessage('Enregistrez d''abord vos données.');
    exit;
  end;

  aFActesListe:=TFActesListe.create(self);
  try
    aFActesListe.doInit(iIndiActif,coupechaine(Caption,aFActesListe.lNom),SexeIndi);
    aFActesListe.ShowModal;

    bModified:=aFActesListe.bModified;

  finally
    FreeAndNil(aFActesListe);
  end;

  if bModified then
  begin
    FMain.aFIndividu.Modified:=true;
    FMain.aFIndividu.DoRefreshControls;
  end;
end;

procedure TFIndividuNavigation.ImprimeLaFiche;
begin
  btnListeActe.Hide;
  btnHistoire.Hide;
  pBouton.Hide;
  lPlusdeFemme.Hide;
  lPlusEnfants.Hide;

  Color:=clWhite;

  gbIndi.Color:=clWhite;
  gbpere.Color:=clWhite;
  gbMere.Color:=clWhite;
  gbGPP.Color:=clWhite;
  gbGMP.Color:=clWhite;
  gbGPM.Color:=clWhite;
  gbGMM.Color:=clWhite;
  gbEpouse1.Color:=clWhite;
  gbEpouse2.Color:=clWhite;
  gbEpouse3.Color:=clWhite;
  gbEnfant1.Color:=clWhite;
  gbEnfant2.Color:=clWhite;
  gbEnfant3.Color:=clWhite;
  gbEnfant4.Color:=clWhite;
  gbEnfant5.Color:=clWhite;

// Matthieu Après
//dxComponentPrinter1.Preview(True,nil);

  lPlusEnfants.Visible:=lnbEnfants>5;
  lPlusdeFemme.Visible:=lnbEpouses>3;

  color:=gci_context.ColorLight;

  gbIndi.Color:=color;
  gbpere.Color:=color;
  gbMere.Color:=color;
  gbGPP.Color:=color;
  gbGMP.Color:=color;
  gbGPM.Color:=color;
  gbGMM.Color:=color;
  gbEpouse1.Color:=color;
  gbEpouse2.Color:=color;
  gbEpouse3.Color:=color;
  gbEnfant1.Color:=color;
  gbEnfant2.Color:=color;
  gbEnfant3.Color:=color;
  gbEnfant4.Color:=color;
  gbEnfant5.Color:=color;

  pBouton.Show;
  btnListeActe.Show;
  btnHistoire.Show;
end;

procedure TFIndividuNavigation.mImpressionClick(Sender: TObject);
begin
  ImprimeLaFiche;
end;

end.

