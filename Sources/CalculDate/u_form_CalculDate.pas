unit u_form_CalculDate;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  U_FormAdapt,SysUtils,Forms,
  u_buttons_appli,
  StdCtrls,ExtCtrls,MaskEdit, u_framework_dbcomponents,
  u_framework_components,
  u_ancestropictimages;

type

  { TFCalculDate }

  TFCalculDate=class(TF_FormAdapt)
    Ajouter: TRadioButton;
    an1: TFWSpinEdit;
    an2: TFWSpinEdit;
    an3: TFWSpinEdit;
    an4: TFWSpinEdit;
    btnContribution: TXAInfo;
    btnCopierPP: TFWCopy;
    btnFermer: TFWClose;
    btnInfos1: TXAInfo;
    btnInfos2: TXAInfo;
    ChampCopie: TEdit;
    dateErreur1: TLabel;
    dateErreur2: TLabel;
    Enlever: TRadioButton;
    FlatGroupBox1: TGroupBox;
    FlatGroupBox3: TGroupBox;
    FlatPanel1: TPanel;
    Jour1: TFWSpinEdit;
    jour2: TFWSpinEdit;
    jour3: TFWSpinEdit;
    jour4: TFWSpinEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    mois1: TFWComboBox;
    mois2: TFWComboBox;
    mois3: TFWComboBox;
    mois4: TFWSpinEdit;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    resan1: TMaskEdit;
    resan2: TMaskEdit;
    resjour1: TMaskEdit;
    resjour2: TMaskEdit;
    resmois1: TMaskEdit;
    resmois2: TMaskEdit;
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure btnCopierPPClick(Sender:TObject);
    procedure btnContributionClick(Sender:TObject);
    procedure btnInfos1Click(Sender:TObject);
    procedure btnInfos2Click(Sender:TObject);
    procedure an4PropertiesChange(Sender: TObject);
    procedure SuperFormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFermerClick(Sender: TObject);
    procedure jour3PropertiesChange(Sender: TObject);
    procedure AjouterClick(Sender: TObject);
    procedure Jour1PropertiesChange(Sender: TObject);
    procedure AjouterEnter(Sender: TObject);
    procedure AjouterExit(Sender: TObject);
    procedure AjouterKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    bChange:Boolean;
    procedure Calculer1;
    procedure Calculer2;
    procedure CopierResultat;
  public
    { Déclarations publiques }
    procedure InitDates(an,mois,jour:integer);
  end;

implementation

uses 
  u_common_const,
  u_common_resources,
  fonctions_dialogs,
  u_genealogy_context,
  u_common_functions,
  u_common_ancestro,u_common_ancestro_functions,
  Graphics,
  Dialogs;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFCalculDate.SuperFormCreate(Sender:TObject);
var
  i:Integer;
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Panel3.Color:=gci_context.ColorLight;
  btnInfos1.Color:=gci_context.ColorLight;
  btnInfos2.Color:=gci_context.ColorLight;
  btnContribution.Color:=gci_context.ColorLight;
  btnInfos1.ColorFrameFocus:=gci_context.ColorLight;
  btnInfos2.ColorFrameFocus:=gci_context.ColorLight;
  btnContribution.ColorFrameFocus:=gci_context.ColorLight;
  for i:=1 to 12 do
  begin
    mois1.Items.Add(LongMonthNames[i]);
    mois2.Items.Add(LongMonthNames[i]);
    mois3.Items.Add(LongMonthNames[i]);
  end;

end;

procedure TFCalculDate.InitDates(an,mois,jour:integer);
begin
  bChange:=True;
  an1.Text:=IntToStr(an);
  mois1.ItemIndex:=mois-1;
  jour1.Text:=IntToStr(jour);
  an2.Text:=IntToStr(an);
  mois2.ItemIndex:=mois-1;
  jour2.Text:=IntToStr(jour);
  an3.Text:=IntToStr(an);
  mois3.ItemIndex:=mois-1;
  jour3.Text:=IntToStr(jour);
  bChange:=False;
  Calculer1;
  Calculer2;
end;

procedure TFCalculDate.SuperFormShowFirstTime(Sender:TObject);
var
  j,m,a:word;
begin
  Caption:=rs_Caption_Calculate_dates;
  if mois1.ItemIndex<0 then
  begin
    DecodeDate(now,a,m,j);
    InitDates(a,m,j);
  end;
end;

procedure TFCalculDate.Calculer1;
var
  itemp,ladate1,ladate2,an,mois,jour,ian1,imois1,ijour1,ian2,imois2,ijour2:Integer;
begin
  if bChange then
    exit;
  dateErreur1.Caption:='';
  imois1:=mois1.ItemIndex+1;
  imois2:=mois2.ItemIndex+1;
  if TryStrToInt(an1.Text,ian1)
    and (imois1>0)
    and TryStrToInt(jour1.Text,ijour1)
    and TryStrToInt(an2.Text,ian2)
    and (imois2>0)
    and TryStrToInt(jour2.Text,ijour2)
    and DefDateCode(ian1,imois1,ijour1,cGRE,1,ladate1)
    and DefDateCode(ian2,imois2,ijour2,cGRE,1,ladate2)then
  begin
    if ladate1>ladate2 then //inversion des dates
    begin
      itemp:=ladate1;
      ladate1:=ladate2;
      ladate2:=itemp;

      itemp:=ian1;
      ian1:=ian2;
      ian2:=itemp;

      itemp:=imois1;
      imois1:=imois2;
      imois2:=itemp;

      itemp:=ijour1;
      ijour1:=ijour2;
      ijour2:=itemp;
    end;

    if ijour2>=ijour1 then
      jour:=ijour2-ijour1
    else
    begin
      DefDateCode(ian2,imois2,1,cGRE,0,ladate2);
      if imois2>1 then
      begin
        dec(imois2);
      end
      else
      begin
        imois2:=12;
        dec(ian2);
      end;
      DefDateCode(ian2,imois2,1,cGRE,0,ladate1);
      jour:=ijour2+ladate2-ladate1-ijour1;
    end;

    if imois2>=imois1 then
      mois:=imois2-imois1
    else
    begin
      mois:=imois2+12-imois1;
      dec(ian2);
    end;

    an:=ian2-ian1;

    resan1.Text:=IntToStr(an);
    resmois1.Text:=IntToStr(mois);
    resjour1.Text:=IntToStr(jour);
  end
  else
    dateErreur1.Caption:=rs_Caption_Error_on_a_date;
end;

procedure TFCalculDate.btnCopierPPClick(Sender:TObject);
begin
  CopierResultat;
end;

procedure TFCalculDate.Calculer2;
var
  ladate,an,mois,jour,ian,imois,ijour:integer;
begin
  if bChange then
    exit;
  dateErreur2.Caption:='';
  mois:=mois3.ItemIndex+1;
  if TryStrToInt(an3.Text,an)
    and (mois>0)
    and TryStrToInt(jour3.Text,jour)
    and TryStrToInt(an4.Text,ian)
    and TryStrToInt(mois4.Text,imois)
    and TryStrToInt(jour4.Text,ijour)
    and DefDateCode(an,mois,jour,cGRE,0,ladate)then
  begin
    if Ajouter.Checked then
      ladate:=ladate+ijour
    else
      ladate:=ladate-ijour;
    DecodeDateCode(ladate,an,mois,jour,cGRE);
    if Ajouter.Checked then
      mois:=mois+imois
    else
      mois:=mois-imois;
    if mois>12 then
    begin
      ian:=(mois-1) div 12;
      mois:=((mois-1) mod 12)+1;
      an:=an+ian;
    end
    else if mois<1 then
    begin
      ian:=(mois div 12)-1;
      mois:=(mois mod 12)+12;
      an:=an+ian;
    end;
    ian:=StrToInt(an4.Text);
    if Ajouter.Checked then
    begin
      an:=an+ian;
    end
    else
    begin
      an:=an-ian;
    end;
    resan2.Text:=IntToStr(an);
    resmois2.Text:=LongMonthNames[mois];
    resjour2.Text:=IntToStr(jour);
  end
  else
    dateErreur2.Caption:=rs_Caption_Invalid_date_or_value;
end;

procedure TFCalculDate.btnContributionClick(Sender:TObject);
begin
  MyMessageDlg(rs_Function_by_Thierry_Colier,mtInformation, [mbOK],Self);
end;

procedure TFCalculDate.btnInfos1Click(Sender:TObject);
begin
  MyMessageDlg(rs_Function_to_calculate_Dates_Infos1,mtInformation, [mbOK],self);
end;

procedure TFCalculDate.btnInfos2Click(Sender:TObject);
begin
  MyMessageDlg( rs_Function_to_calculate_Dates_Infos2
    ,mtInformation, [mbOK],self);
end;

procedure TFCalculDate.an4PropertiesChange(Sender: TObject);
begin
  if (Sender as TFWSpinEdit).Value<0 then
    (Sender as TFWSpinEdit).Value:=0;
  Calculer2;
end;

procedure TFCalculDate.CopierResultat;
var
  i:integer;
begin
  if Length(resmois2.Text)=0 then
    exit;
  for i:=Low(LongMonthNames) to High(LongMonthNames) do
    if resmois2.Text=LongMonthNames[i] then
      Break;
  if _GDate.DecodeHumanDate(StrToInt(resan2.Text),i,StrToInt(resjour2.Text),0,cGRE)then
  begin
    ChampCopie.Text:=_GDate.HumanDate;
    ChampCopie.SelectAll;
    ChampCopie.CopyToClipboard;
  end;
end;

procedure TFCalculDate.SuperFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
  DoSendMessage(Owner,'FERME_CALCULDATES');
end;

procedure TFCalculDate.btnFermerClick(Sender: TObject);
begin
  Close;
end;

procedure TFCalculDate.jour3PropertiesChange(Sender: TObject);
begin
  Calculer2;
end;

procedure TFCalculDate.AjouterClick(Sender: TObject);
begin
  Calculer2;
end;

procedure TFCalculDate.Jour1PropertiesChange(Sender: TObject);
begin
  Calculer1;
end;

procedure TFCalculDate.AjouterEnter(Sender: TObject);
var
  LeBouton:TRadioButton;
begin
  LeBouton:=(Sender as TRadioButton);
  if LeBouton.Checked then
  begin
    if LeBouton=Ajouter then
      Enlever.SetFocus
    else
      Ajouter.SetFocus;
    exit;
  end;
  (Sender as TRadioButton).Font.Style:=[fsBold];
end;

procedure TFCalculDate.AjouterExit(Sender: TObject);
begin
  (Sender as TRadioButton).Font.Style:=[];
end;

procedure TFCalculDate.AjouterKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) in [VK_RETURN,VK_SPACE] then
  begin
    (Sender as TRadioButton).Checked:=True;
    SelectNext(Sender as TRadioButton,true,true);
  end;
end;

end.

