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
{  refonte quasi totale de la logique par André Langlet décembre 2009   }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_form_individu_Affecte_Enfant;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLType,
{$ENDIF}
  U_FormAdapt,Sysutils,
  Controls,ExtCtrls,StdCtrls,Forms,Classes,Graphics,Dialogs,
  u_buttons_appli,
  u_ancestropictimages;

type

  { TFAffecte_Enfant }

  TFAffecte_Enfant=class(TF_FormAdapt)
    pGeneral:TPanel;
    pGlobal:TPanel;
    pBottom:TPanel;
    Panel1:TPanel;
    Image1:TIATitle;
    lPere:TLabel;
    lMere:TLabel;
    lEnfant:TLabel;
    Label1:TLabel;
    Label2:TLabel;
    Label3:TLabel;
    rg:TRadioGroup;
    Panel2:TPanel;
    fpBoutons:TPanel;
    bsfbAbandon:TFWClose;
    btnFermer:TFWOK;

    procedure FormShow(Sender: TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure SuperFormKeyDown(Sender:TObject;var Key:Word;
      Shift:TShiftState);
    function ChercheAutreParent(SexeParent:Integer):boolean;
    procedure rgClick(Sender:TObject);
    procedure SuperFormClose(Sender:TObject;var Action:TCloseAction);
  private
    fDialogMode:boolean;
    fClefPere,fClefMere,ClefEnfant:integer;
    NomEnfant:string;
    iLastIndex:Integer;
    bM:boolean;
    iCleConjoint:array of Integer;

  public
    creation:boolean;
    property ClefMere:integer read fClefMere write fClefMere;
    property ClefPere:integer read fClefPere write fClefPere;
    procedure DoInit(i_clef,i_conjoint,i_enfant,SexeIndi:Integer;NomIndi:string);
  end;

implementation

uses u_dm,
     u_form_individu_repertoire,
     fonctions_dialogs,
     fonctions_string,
     u_common_functions,
     u_common_ancestro,
     u_genealogy_context,
     u_common_ancestro_functions,
     IBSQL;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFAffecte_Enfant.SuperFormCreate(Sender:TObject);
begin
  Color:=gci_context.ColorLight;
  pBottom.Color:=gci_context.ColorDark;

  fDialogMode:=false;
  Panel2.top:=75;
  rg.top:=-7;
  rg.height:=10;
  Panel2.Left:=91;
  rg.Left:=-6;
  rg.width:=300;
  rg.Font.Style:= [fsBold];
  rg.Visible:=False;
  fClefPere:=-1;
  fClefMere:=-1;
  creation:=false;
  iLastIndex:=-2;
  lmere.Visible:=False;
  rg.visible:=true;
end;

procedure TFAffecte_Enfant.FormShow(Sender: TObject);
begin
  if Application.ModalLevel>0
   Then DefaultCloseAction:=caHide
   Else DefaultCloseAction:=caFree;
end;

procedure TFAffecte_Enfant.DoInit(i_clef,i_conjoint,i_enfant,SexeIndi:Integer;NomIndi:string);
var
  i:integer;
  q:TIBSQL;
begin
  Screen.Cursor:=crHourglass;
  bM:=SexeIndi=1;
  ClefEnfant:=i_enfant;
  fClefPere:=i_clef;
  lPere.Caption:=NomIndi;
  if bM then
  begin
    lPere.font.Color:=gci_context.ColorHomme;
    Label1.Caption:=rs_Caption_Has_got_father;
    Label2.Caption:=rs_Caption_Has_got_mother;
    rg.Font.Color:=gci_context.ColorFemme;
    Caption:=rs_Caption_Select_the_mother;
  end
  else
  begin
    lPere.font.Color:=gci_context.ColorFemme;
    Label1.Caption:=rs_Caption_Has_got_mother;
    Label2.Caption:=rs_Caption_Has_got_father;
    rg.Font.Color:=gci_context.ColorHomme;
    Caption:=rs_Caption_Select_the_Father;
  end;
  q:=TIBSQL.Create(self);
  with q do
  try
    Database:=dm.ibd_BASE;
    Transaction:=dm.IBT_BASE;
    SQL.Add('select nom,prenom,sexe from individu where cle_fiche=:i_enfant');
    Params[0].AsInteger:=ClefEnfant;
    ExecQuery;
    NomEnfant:=FieldByName('nom').AsString;
    lEnfant.Caption:=AssembleString([NomEnfant,FieldByName('prenom').AsString]);

    if FieldByName('sexe').AsInteger=1 then
      lEnfant.Font.Color:=gci_context.ColorHomme
    else if FieldByName('sexe').AsInteger=2 then
      lEnfant.Font.Color:=gci_context.ColorFemme
    else
      lEnfant.Font.Color:=clWindowText;

    Close;
    SQL.Clear;

    SQL.Add('select p.conjoint,c.nom,c.prenom from proc_conjoints_ordonnes(:indi,0) p'
      +' inner join individu c on c.cle_fiche=p.conjoint order by p.ordre');
    ParamByName('indi').AsInteger:=i_clef;
    ExecQuery;

    SetLength(iCleConjoint,0);
    i:=-1;
    rg.ItemIndex:=-1;
    while not Eof do
    begin
      inc(i);
      SetLength(iCleConjoint,i+1);
      ClientHeight:=ClientHeight+20;
      rg.Height:=rg.Height+20;
      rg.Items.Add(AssembleString([FieldByName('nom').AsString,FieldByName('prenom').AsString]));
      if (rg.Width<Length(rg.Items[i])*7) then
        rg.Width:=Length(rg.Items[i])*7;
      iCleConjoint[i]:=FieldByName('conjoint').AsInteger;
      if iCleConjoint[i]=i_conjoint then
        rg.ItemIndex:=i;
      Next;
    end;
  finally
    Free;
    Screen.Cursor:=crDefault;
  end;

  rg.Height:=rg.Height+40;
  Panel2.Width:=rg.Width-10;
  Panel2.Height:=Rg.Height-10;

  SetLength(iCleConjoint,i+3);
  iCleConjoint[i+1]:=0;
  iCleConjoint[i+2]:=0;
  iLastIndex:=i+2;
  if bM then
  begin
    rg.Items.Add(rs_Item_Other_known_mother);
    rg.Items.Add(rs_Unknown_mother);
  end
  else
  begin
    rg.Items.Add(rs_Item_Other_known_father);
    rg.Items.Add(rs_Unknown_father);
  end;
  if rg.ItemIndex=-1 then
    rg.ItemIndex:=iLastIndex;
end;

procedure TFAffecte_Enfant.SuperFormKeyDown(Sender:TObject;
  var Key:Word;Shift:TShiftState);
begin
  if Key=VK_ESCAPE then
    ModalResult:=mrCancel;
end;

function TFAffecte_Enfant.ChercheAutreParent(SexeParent:Integer):boolean;
var
  aFIndividuRepertoire:TFIndividuRepertoire;
  aLettre,TexteShow:string;
begin
  if SexeParent=1 then
    TexteShow:='son père'
  else
    TexteShow:='sa mère';
  aFIndividuRepertoire:=TFIndividuRepertoire.create(self);
  try
    aFIndividuRepertoire.Position:=poMainFormCenter;
    aFIndividuRepertoire.NomIndi:=NomEnfant;
    aLettre:=Copy(fs_FormatText(NomEnfant,mftUpper,True),1,1);
    aFIndividuRepertoire.InitIndividuPrenom(aLettre,'',SexeParent,0,False,True);
    if SexeParent=1 then
      aFIndividuRepertoire.Caption:=rs_caption_Select_Father
    else
      aFIndividuRepertoire.Caption:=rs_caption_Select_Mother;
    aFIndividuRepertoire.Creation:=false;
    if aFIndividuRepertoire.ShowModal=mrOk then
      if (aFIndividuRepertoire.ClefIndividuSelected=ClefEnfant) then
      begin
        MyMessageDlg(rs_Error_person_cannot_be_itself_and+TexteShow,mtError, [mbOK],Self);
        result:=false
      end
      else
      begin
        rg.Items[rg.ItemIndex]:=aFIndividuRepertoire.NomPrenomIndividuSelected;
        iCleConjoint[rg.ItemIndex]:=aFIndividuRepertoire.ClefIndividuSelected;
        result:=true
      end
    else
      result:=false;
    creation:=aFIndividuRepertoire.Creation;
  finally
    FreeAndNil(aFIndividuRepertoire);
  end
end;

procedure TFAffecte_Enfant.rgClick(Sender:TObject);
begin
  if rg.ItemIndex=iLastIndex-1 then
  begin
    if bM then
    begin
      if not ChercheAutreParent(2) then
        rg.ItemIndex:=iLastIndex;
    end
    else
    begin
      if not ChercheAutreParent(1) then
        rg.ItemIndex:=iLastIndex;
    end;
  end;
end;

procedure TFAffecte_Enfant.SuperFormClose(Sender:TObject;
  var Action:TCloseAction);
begin
  if bM then
  begin
    if rg.ItemIndex<>-1 then
    begin
      fClefMere:=icleConjoint[rg.Itemindex];
      lMere.Caption:=rg.Items[rg.Itemindex]
    end
    else
      fClefMere:=0;
  end
  else
  begin
    if rg.ItemIndex<>-1 then
    begin
      fClefMere:=fClefPere;
      fClefPere:=icleConjoint[rg.Itemindex];
      lMere.Caption:=lPere.Caption;
      lPere.Caption:=rg.Items[rg.Itemindex]
    end
    else
      fClefPere:=0;
  end;
end;

end.
