unit u_form_calendriers;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, TPanelUnit, Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
  CompSuperForm, u_ancestropictimages,u_comp_TYLanguage,DateUtils,
  ExtCtrls,Controls,StdCtrls,SysUtils,
  u_buttons_appli, MaskEdit,
  u_common_const,lazutf8classes,u_framework_components, U_OnFormInfoIni;

type

  { TFCalendriers }

  TFCalendriers=class(TSuperForm)
    IATitle1: TIATitle;
    OnFormInfoIni: TOnFormInfoIni;
    pBorder:TPanel;
    Panel3:TPanel;
    FlatGroupBox1:TGroupBox;
    radGregorien:TRadioButton;
    radJulien:TRadioButton;
    radMusulman:TRadioButton;
    radRepublicain:TRadioButton;
    radIsraelien:TRadioButton;
    radCopte:TRadioButton;
    FlatGroupBox2:TGroupBox;
    Label7:TLabel;
    Label6:TLabel;
    Label5:TLabel;
    Label4:TLabel;
    Label3:TLabel;
    Label2:TLabel;
    FlatGroupBox3:TGroupBox;
    Label1:TLabel;
    Label8:TLabel;
    Label9:TLabel;
    Language:TYLanguage;
    FlatPanel1:TPanel;
    btnContribution:TXAInfo;
    Panel9:TPanel;
    Panel10:TPanel;
    btnInfoGre:TXAInfo;
    btnInfoJul:TXAInfo;
    btnInfoIsr:TXAInfo;
    btnInfoCop:TXAInfo;
    btnInfoRep:TXAInfo;
    btnInfoMus:TXAInfo;
    dateCop:TMaskEdit;
    dateIsr:TMaskEdit;
    dateMus:TMaskEdit;
    dateRep:TMaskEdit;
    dateJul:TMaskEdit;
    dateGreg:TMaskEdit;
    bsfbSelection:TFWOK;
    btnFermer:TFWClose;
    lemois:TFWComboBox;
    lejour: TFWSpinEdit;
    lan: TFWSpinEdit;
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure SuperFormDestroy(Sender:TObject);
    procedure sbCloseClick(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure radGregorienClick(Sender:TObject);
    procedure radRepublicainClick(Sender:TObject);
    procedure radIsraelienClick(Sender:TObject);
    procedure radMusulmanClick(Sender:TObject);
    procedure radCopteClick(Sender:TObject);
    procedure radJulienClick(Sender:TObject);
    procedure CalculerDates(Sender:TObject);
    procedure refreshCalendriers;
    procedure bsfbSelectionClick(Sender:TObject);
    procedure btnContributionClick(Sender:TObject);
    procedure btnInfoCalClick(Sender:TObject);
  private
    { Déclarations privées }
    fCanSelect,bCalcAuto:boolean;
    fDate:string;
    radio:integer;
    moisGre,moisJul,moisRep,moisMus,moisIsr,moisCop:TStringlistUTF8;
    procedure initCalendriers;

  public
    { Déclarations publiques }

    //En entrée
    property CanSelect:boolean read fCanSelect write fCanSelect;
    //en retour
    property ladate:string read fDate write fDate;

    procedure doInit(ans,mois,jours:integer;Cal:TCalendrier);
  end;

implementation

uses 
  u_common_resources,
  u_common_functions,
  fonctions_dialogs,
  u_calendriers_gregorien,
  u_objet_TGedcomDate,
  Dialogs;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFCalendriers.initCalendriers;
var
  i:integer;
begin
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  fCanSelect:=true;

  moisGre:=TStringlistUTF8.Create;
  moisJul:=TStringlistUTF8.Create;
  for i:=1 to 12 do
  begin
    moisGre.Add(LongMonthNames[i]);
    moisJul.Add(LongMonthNames[i]);
  end;

  moisRep:=TStringlistUTF8.Create;
  for i:=1 to 13 do
  begin
    moisRep.Add(lmoisr[i]);
  end;

  moisCop:=TStringlistUTF8.Create;
  for i:=1 to 13 do
  begin
    moisCop.Add(lmoisc[i]);
  end;

  moisMus:=TStringlistUTF8.Create;
  for i:=1 to 12 do
  begin
    moisMus.Add(lmoism[i]);
  end;

  moisIsr:=TStringlistUTF8.Create;
  for i:=1 to 13 do
  begin
    moisIsr.Add(lmoisie[i]);
  end;
end;

procedure TFCalendriers.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  OnShowFirstTime:=SuperFormShowFirstTime;
  Panel3.Color:=gcol_Forms;
  btnInfoCop.Color:=gcol_Forms;
  btnInfoGre.Color:=gcol_Forms;
  btnInfoIsr.Color:=gcol_Forms;
  btnInfoJul.Color:=gcol_Forms;
  btnInfoMus.Color:=gcol_Forms;
  btnInfoRep.Color:=gcol_Forms;
  btnContribution.Color:=gcol_Forms;
  btnInfoCop.ColorFrameFocus:=gcol_Forms;
  btnInfoGre.ColorFrameFocus:=gcol_Forms;
  btnInfoIsr.ColorFrameFocus:=gcol_Forms;
  btnInfoJul.ColorFrameFocus:=gcol_Forms;
  btnInfoMus.ColorFrameFocus:=gcol_Forms;
  btnInfoRep.ColorFrameFocus:=gcol_Forms;
  btnContribution.ColorFrameFocus:=gcol_Forms;
  initCalendriers;
  bCalcAuto:=false;
end;

procedure TFCalendriers.SuperFormRefreshControls(Sender:TObject);
begin
  bsfbSelection.visible:=fCanSelect;
end;

procedure TFCalendriers.SuperFormDestroy(Sender:TObject);
begin
  moisGre.Free;
  moisJul.Free;
  moisRep.Free;
  moisIsr.Free;
  moisMus.Free;
  moisCop.Free;
end;

procedure TFCalendriers.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Caption_Universal_calendar;
  doRefreshControls;
end;

procedure TFCalendriers.sbCloseClick(Sender:TObject);
begin
  ModalResult:=mrCancel;
  Close;
end;

procedure TFCalendriers.radGregorienClick(Sender:TObject);
begin
  bCalcAuto:=false;
  radio:=0;
  lemois.Items.Clear;
  lemois.Clear;
  lemois.Items.AddStrings(moisGre);
  lan.Text:=IntToStr(dateCal.anGre);
  lemois.ItemIndex:=dateCal.moisGre-1;
  lejour.Text:=IntToStr(dateCal.jourGre);
  bsfbSelection.Enabled:=(dateCal.erreur='');
  bCalcAuto:=true;
  if self.Showing then
    lejour.SetFocus;
end;

procedure TFCalendriers.radRepublicainClick(Sender:TObject);
begin
  bCalcAuto:=false;
  radio:=2;
  lemois.Items.Clear;
  lemois.Clear;
  lemois.Items.addStrings(moisRep);
  lan.Text:=IntToStr(dateCal.anRep);
  lemois.ItemIndex:=dateCal.moisRep-1;
  lejour.Text:=IntToStr(dateCal.jourRep);
  bsfbSelection.Enabled:=(dateCal.erreur='');
  bCalcAuto:=true;
  if self.Showing then
    lejour.SetFocus;
end;

procedure TFCalendriers.radIsraelienClick(Sender:TObject);
begin
  bCalcAuto:=false;
  radio:=4;
  lemois.Items.Clear;
  lemois.Clear;
  lemois.Items.addStrings(moisIsr);
  lan.Text:=IntToStr(dateCal.anIsr);
  if dateCal.moisIsr<7 then
    lemois.ItemIndex:=dateCal.moisIsr-1
  else if dateCal.typeai=1 then 
    lemois.ItemIndex:=dateCal.moisIsr-1
  else
    lemois.ItemIndex:=dateCal.moisIsr;
  lejour.Text:=IntToStr(dateCal.jourIsr);
  bsfbSelection.Enabled:=(dateCal.erreur='');
  bCalcAuto:=true;
  if self.Showing then
    lejour.SetFocus;
end;

procedure TFCalendriers.radMusulmanClick(Sender:TObject);
begin
  bCalcAuto:=false;
  radio:=3;
  lemois.Items.Clear;
  lemois.Clear;
  lemois.Items.addStrings(moisMus);
  lan.Text:=IntToStr(dateCal.anMus);
  lemois.ItemIndex:=dateCal.moisMus-1;
  lejour.Text:=IntToStr(dateCal.jourMus);
  bsfbSelection.Enabled:=(dateCal.erreur='');
  bCalcAuto:=true;
  if self.Showing then
    lejour.SetFocus;
end;

procedure TFCalendriers.radCopteClick(Sender:TObject);
begin
  bCalcAuto:=false;
  radio:=5;
  lemois.Items.Clear;
  lemois.Clear;
  lemois.Items.addStrings(moisCop);
  lan.Text:=IntToStr(dateCal.anCop);
  lemois.ItemIndex:=dateCal.moisCop-1;
  lejour.Text:=IntToStr(dateCal.jourCop);
  bsfbSelection.Enabled:=(dateCal.erreur='');
  bCalcAuto:=true;
  if self.Showing then
    lejour.SetFocus;
end;

procedure TFCalendriers.radJulienClick(Sender:TObject);
begin
  bCalcAuto:=false;
  radio:=1;
  lemois.Items.Clear;
  lemois.Clear;
  lemois.Items.addStrings(moisJul);
  lan.Text:=IntToStr(dateCal.anJul);
  lemois.ItemIndex:=dateCal.moisJul-1;
  lejour.Text:=IntToStr(dateCal.jourJul);
  bsfbSelection.Enabled:=(dateCal.erreur='');
  bCalcAuto:=true;
  if self.Showing then
    lejour.SetFocus;
end;

procedure TFCalendriers.refreshCalendriers;
const
  CstDateIncorrecte='Date saisie incorrecte';
begin
  if (dateCal.erreur<>'') then
  begin
    if radio=0 then
      dateGreg.Text:=CstDateIncorrecte
    else
      dateGreg.Text:='';
    if radio=1 then
      dateJul.Text:=CstDateIncorrecte
    else
      dateJul.Text:='';
    if radio=2 then
      dateRep.Text:=CstDateIncorrecte
    else
      dateRep.Text:='';
    if radio=3 then
      dateMus.Text:=CstDateIncorrecte
    else
      dateMus.Text:='';
    if radio=4 then
      dateIsr.Text:=CstDateIncorrecte
    else
      dateIsr.Text:='';
    if radio=5 then
      dateCop.Text:=CstDateIncorrecte
    else
      dateCop.Text:='';

    bsfbSelection.Enabled:=false;
  end
  else
  begin
    dateGreg.Text:=dateCal.valeurGre;
    dateRep.Text:=dateCal.valeurRep;
    dateJul.Text:=dateCal.valeurJul;
    dateMus.Text:=dateCal.valeurMus;
    dateIsr.Text:=dateCal.valeurIsr;
    dateCop.Text:=dateCal.valeurCop;
    bsfbSelection.Enabled:=dateCal.valeurJul<>CstPasEnUsage;
  end;
end;

procedure TFCalendriers.CalculerDates(Sender:TObject);
begin
  if bCalcAuto then
  begin
    dateCal.an:=StrToIntDef(lan.Text,0);
    dateCal.mois:=lemois.ItemIndex+1;
    dateCal.jour:=StrToIntDef(lejour.Text,0);
    dateCal.erreur:='';
    case radio of
      0:// grégorien
        calculerGregorien;
      1:// julien
        calculerJulien;
      2:// républicain
        calculerRepublicain;
      3:// musulman
        calculerMusulman;
      4://israélien
        calculerIsraelien;
      5://copte
        calculerCopte;
    end;
    refreshCalendriers;
  end;
end;

procedure TFCalendriers.bsfbSelectionClick(Sender:TObject);
var
  MaDate:TGedcomDate;
begin
  if fCanSelect then
  begin
    MaDate:=TGedcomDate.Create;
    Madate.InitTGedcomDate(_MotsClesDate,_MotsClesDate);
    try
      if radJulien.Checked then
        MaDate.DecodeHumanDate(datecal.anJul,datecal.moisJul,datecal.jourJul,0,cJUL)
      else
        MaDate.DecodeHumanDate(datecal.anGre,datecal.moisGre,datecal.jourGre,0,cGRE);
      fDate:=MaDate.HumanDate;
    finally
      MaDate.Free;
    end;
    ModalResult:=mrOk;
  end;
end;

procedure TFCalendriers.btnContributionClick(Sender:TObject);
begin
  AMessageDlg(rs_Function_by_Thierry_Colier,mtInformation, [mbOK],Self);
end;


procedure TFCalendriers.doInit(ans,mois,jours:integer;Cal:TCalendrier);
var
  sDate:TDateTime;
begin
  //Vérification que la date passée est bonne, si non on la remplace par la date du jour
  bCalcAuto:=false;
  if not _TryEncodeDate(ans,mois,jours,Cal,sDate) then
  begin
    DecodeDateCode(trunc(today),ans,mois,jours,Cal);
  end;
  if Cal=cJUL then
  begin
    radio:=1;
    radJulien.Checked:=true;
  end
  else
  begin
    radio:=0;
    radGregorien.Checked:=true;
  end;
  lemois.items.Clear;
  lemois.items.AddStrings(moisGre);

  lan.Value:=ans;
  lemois.ItemIndex:=mois-1;
  lejour.Value:=jours;
  bCalcAuto:=true;
  CalculerDates(self);
end;

procedure TFCalendriers.btnInfoCalClick(Sender:TObject);
var
  letexte:string;
begin
  if sender=btnInfoGre
    then letexte:=rs_Info_Calendar_Gregorian
  else if sender=btnInfoJul
    then letexte:=rs_Info_Calendar_Julian
  else if sender=btnInfoIsr
    then letexte:=rs_Info_Calendar_Juive
  else if sender=btnInfoCop
    then letexte:=rs_Info_Calendar_Copt
  else if sender=btnInfoRep
    then letexte:=rs_Info_Calendar_Republican
  else if sender=btnInfoMus
    then letexte:=rs_Info_Calendar_Musulman
  else exit;

  AMessageDlg(letexte,mtInformation,[mbOK],Self);
end;

end.
