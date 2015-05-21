{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania GPL                             }
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
{           refaite par AL2009                                                            }
{-----------------------------------------------------------------------}

unit u_form_Modif_Favoris;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  TPanelUnit, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  U_FormAdapt,Forms,SysUtils,Variants,
  u_comp_TYLanguage, MaskEdit, u_buttons_appli,
  ExtCtrls, ComCtrls,
  StdCtrls,Graphics,Controls,
  Classes,Dialogs,u_buttons_defs,ExtJvXPButtons,Menus,
  U_ExtImage,u_framework_components,
  u_framework_dbcomponents,
  u_extsearchedit,
  IBQuery, db,u_ancestropictimages,
  u_ancestropictbuttons;

type

  { TFModifFavoris }

  TFModifFavoris=class(TF_FormAdapt)
    DSCountries: TDatasource;
    dxInsee: TFWEdit;
    dxLATITUDE: TFWEdit;
    dxLONGITUDE: TFWEdit;
    dxSubd: TFWEdit;
    IBQCountries: TIBQuery;
    pBorder:TPanel;
    Panel7:TPanel;
    Panel9:TPanel;
    Image2:TIATitle;
    Panel10:TPanel;
    Panel11:TPanel;
    Language:TYLanguage;
    fpAdresses:TPanel;
    Label1:TLabel;
    Label3:TLabel;
    Label4:TLabel;
    Label2:TLabel;
    Label9:TLabel;
    fbInfosVilles:TFWXPButton;
    FlatPanel2:TPanel;
    Label5:TLabel;
    Label6:TLabel;
    Label7:TLabel;
    Label8:TLabel;
    Label11:TLabel;
    edCP:TFWEdit;
    edRegion:TFWEdit;
    edDept:TFWEdit;
    edVille_f:TFWEdit;
    dxCPr:TFWEdit;
    dxRegionr:TFWEdit;
    dxPaysr:TFWEdit;
    dxDeptr:TFWEdit;
    edViller:TFWEdit;
    Label13:TLabel;
    Label12:TLabel;
    Label14:TLabel;
    edInsee:TFWEdit;
    Label15:TLabel;
    dxInseer:TFWEdit;
    Label16:TLabel;
    GoodBtnToutCopier:TFWCopy;
    dxSubdr:TFWEdit;
    dxViller:TFWEdit;
    Label10:TLabel;
    edSubd:TFWEdit;
    Label17:TLabel;
    dxLatituder:TFWEdit;
    dxLongituder:TFWEdit;
    Label18:TLabel;
    Label19:TLabel;
    Label20:TLabel;
    Label21:TLabel;
    edLATITUDE:TFWEdit;
    edLONGITUDE:TFWEdit;
    FlatPanel1:TPanel;
    btnFermer:TFWClose;
    btnTousSaufCord:TJvXPButton;
    btnCPVilleSubd:TXAWorld;
    btnVilleSubd:TXAWorld;
    edPays:TExtSearchDBEdit;
    btnInternet:TXAWeb;
    btnVillesVoisines:TXANeighbor;
    pmGoogle: TPopupMenu;
    mAcquerir: TMenuItem;
    dxStatusBar: TStatusBar;
    procedure btnTousSaufCordClick(Sender:TObject);
    procedure fbInfosVillesClick(Sender:TObject);
    procedure GoodBtnToutCopierClick(Sender:TObject);
    procedure doBoutons(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure edLATITUDEPropertiesExit(Sender:TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure btnInternetPopupMenuPopup(Sender:TObject;
      var APopupMenu:TPopupMenu;var AHandled:Boolean);
    procedure mAcquerirClick(Sender: TObject);
    procedure pmGooglePopup(Sender: TObject);
    procedure EffaceBarreEtat(Sender: TObject);
    procedure InfoCopieBas(Sender: TObject);
    procedure CopyVersBas(Sender: TObject);
    procedure HautKeyDown(Sender: TObject; var Key: Word;
       Shift: TShiftState);
    procedure BasKeyDown(Sender: TObject; var Key: Word;
       Shift: TShiftState);
    procedure InfoCopieHaut(Sender: TObject);
  private
    procedure doModeBoutons(iMode:Boolean);
    procedure p_AfterDownloadCoord;
  public
    procedure doInit(sParam:array of string);
  end;

implementation

uses u_dm,
     u_common_const,
     u_genealogy_context,
     LazUTF8,
     u_common_functions,
     u_common_ancestro,
     fonctions_dialogs,
     u_form_main,
     IBSQL,
     IB,FMTBcd,
     u_common_ancestro_functions,
     Messages;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFModifFavoris.doInit(sParam:array of string);
begin
  dxCPr.Text:=sParam[0];
  dxInseer.Text:=sParam[1];
  dxViller.Text:=sParam[2];
  dxDeptr.Text:=sParam[3];
  dxRegionr.Text:=sParam[4];
  dxPaysr.Text:=sParam[5];
  dxSubdr.Text:=sParam[6];
  dxLatituder.Text:=sParam[7];
  dxLongituder.Text:=sParam[8];
end;

procedure TFModifFavoris.fbInfosVillesClick(Sender:TObject);
var
  Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long:string;
begin
  if FMain.ChercheVille(self,-1,'','',
    Pays,Region,Dept,Code,Insee,Ville,Subd,Lat,Long) then
  begin
    edPays.Text:=Pays;
    edRegion.Text:=Region;
    edDept.Text:=Dept;
    edCP.Text:=Code;
    edInsee.Text:=Insee;
    edVille_f.Text:=Ville;
    edSubd.Text:=Subd;
    edLATITUDE.Text:=Lat;
    edLONGITUDE.Text:=Long;

    doModeBoutons(True);
  end;
end;

procedure TFModifFavoris.GoodBtnToutCopierClick(Sender:TObject);
// on recopie tous les champs du haut en bas d'un seul coup
begin
  edCP.Text:=dxCPr.Text;
  edVille_f.Text:=dxViller.Text;
  edInsee.Text:=dxInseer.Text;
  edDept.Text:=dxDeptr.Text;
  edRegion.Text:=dxRegionr.Text;
  edPays.Text:=dxPaysr.Text;
  edSubd.Text:=dxSubdr.Text;
  edLatitude.Text:=dxLatituder.Text;
  edLongitude.Text:=dxLongituder.Text;

  doModeBoutons(True);
end;

procedure TFModifFavoris.doBoutons(Sender:TObject);
var
  curseur:TCursor;
  i:Integer;
 begin
   doModeBoutons(True);
  btnVillesVoisines.Visible:=(length(edLatitude.Text)>0)and(length(edLongitude.Text)>0);
  btnInternet.Visible:=not((length(trim(dxViller.Text))=0)
            and(not fCassiniDll or(UTF8UpperCase(edPays.Text)<>'FRANCE'))
            and(not btnVillesVoisines.Visible));
  pmGoogle.AutoPopup:=Trim(dxViller.Text)>'';
  if pmGoogle.AutoPopup then
    curseur:=_CURPOPUP
  else
    curseur:=crDefault;
  For i:=0 to fpAdresses.ControlCount-1 do
    if (fpAdresses.Controls[i] is TMaskEdit)or(fpAdresses.Controls[i] is TFWDBLookupCombo)then
      TControl(fpAdresses.Controls[i]).Cursor:=curseur;
end;

procedure TFModifFavoris.doModeBoutons(iMode:Boolean);
begin
  if dxViller.Text>'' then
  begin
    btnCPVilleSubd.Enabled:=iMode;
    btnVilleSubd.Enabled:=iMode;
  end
  else
  begin
    btnCPVilleSubd.Enabled:=False;
    btnVilleSubd.Enabled:=False;
  end;
  btnTousSaufCord.Enabled:=iMode;
end;

procedure TFModifFavoris.btnTousSaufCordClick(Sender:TObject);
var
  q:TIBSQL;
  iTag:integer;
  sErreur:string;

  function ExecuteRequete:string;
  begin
    result:='';
    //nouvelles valeurs
    try
      if Length(edCP.Text)>0 then
        q.ParamByName('EV_IND_CP').AsString:=edCP.Text
      else
        q.ParamByName('EV_IND_CP').Value:=Null;

      if Length(edVille_f.Text)>0 then
        q.ParamByName('EV_IND_VILLE').AsString:=edVille_f.Text
      else
        q.ParamByName('EV_IND_VILLE').Value:=Null;

      if Length(edDept.Text)>0 then
        q.ParamByName('EV_IND_DEPT').AsString:=edDept.Text
      else
        q.ParamByName('EV_IND_DEPT').Value:=Null;

      if Length(edRegion.Text)>0 then
        q.ParamByName('EV_IND_REGION').AsString:=edRegion.Text
      else
        q.ParamByName('EV_IND_REGION').Value:=Null;

      if Length(edPays.Text)>0 then
        q.ParamByName('EV_IND_PAYS').AsString:=edPays.Text
      else
        q.ParamByName('EV_IND_PAYS').Value:=Null;

      if Length(edInsee.Text)>0 then
        q.ParamByName('EV_IND_INSEE').AsString:=edInsee.Text
      else
        q.ParamByName('EV_IND_INSEE').Value:=Null;

      if Length(edSubd.Text)>0 then
        q.ParamByName('EV_IND_SUBD').AsString:=edSubd.Text
      else
        q.ParamByName('EV_IND_SUBD').Value:=Null;

      if not VarIsNull(dxLatituder.Text)and(Length(dxLatituder.Text)<>0) then
        q.ParamByName('EV_IND_LATITUDE').AsDouble:=StrToBcd(dxLatituder.Text)
      else
        q.ParamByName('EV_IND_LATITUDE').Value:=Null;

      if not VarIsNull(dxLongituder.Text)and(Length(dxLongituder.Text)<>0) then
        q.ParamByName('EV_IND_LONGITUDE').AsDouble:=StrToBcd(dxLongituder.Text)
      else
        q.ParamByName('EV_IND_LONGITUDE').Value:=Null;

    // Paramètres de sélection
      q.ParamByName('DOSSIER').AsInteger:=dm.NumDossier;

      if Length(dxViller.Text)>0 then
        q.ParamByName('EV_IND_VILLE_OLD').AsString:=dxViller.Text
      else
        q.ParamByName('EV_IND_VILLE_OLD').AsString:='';

      if Length(dxSubdr.Text)>0 then
        q.ParamByName('EV_IND_SUBD_OLD').AsString:=dxSubdr.Text
      else
        q.ParamByName('EV_IND_SUBD_OLD').AsString:='';

      if iTag>0 then
        if Length(dxCPr.Text)>0 then
          q.ParamByName('EV_IND_CP_OLD').AsString:=dxCPr.Text
        else
          q.ParamByName('EV_IND_CP_OLD').AsString:='';

      if iTag>1 then
      begin
        if Length(dxDeptr.Text)>0 then
          q.ParamByName('EV_IND_DEPT_OLD').AsString:=dxDeptr.Text
        else
          q.ParamByName('EV_IND_DEPT_OLD').AsString:='';

        if Length(dxRegionr.Text)>0 then
          q.ParamByName('EV_IND_REGION_OLD').AsString:=dxRegionr.Text
        else
          q.ParamByName('EV_IND_REGION_OLD').AsString:='';

        if Length(dxPaysr.Text)>0 then
          q.ParamByName('EV_IND_PAYS_OLD').AsString:=dxPaysr.Text
        else
          q.ParamByName('EV_IND_PAYS_OLD').AsString:='';
      end;

      q.ExecQuery;
    except
      on E:EIBError do
      begin
        result:=q.SQL.GetText+_CRLF+_CRLF+E.Message;
      end;
    end;
    q.Close;
    q.SQL.Clear;
  end;

begin
  Screen.Cursor:=crHourGlass;
  iTag:=(sender as TControl).Tag;
  doModeBoutons(False);

  q:=TIBSQL.create(self);
  try
    q.Database:=dm.ibd_BASE;
    q.Transaction:=dm.IBTrans_Secondaire;
    q.SQL.Add('UPDATE EVENEMENTS_IND SET'
      +' EV_IND_CP=:EV_CP'
      +',EV_IND_VILLE=:EV_VILLE'
      +',EV_IND_DEPT=:EV_DEPT'
      +',EV_IND_REGION=:EV_REGION'
      +',EV_IND_PAYS=:EV_PAYS'
      +',EV_IND_INSEE=:EV_INSEE'
      +',EV_IND_SUBD=:EV_SUBD'
      +',EV_IND_LATITUDE=:EV_LATITUDE'
      +',EV_IND_LONGITUDE=:EV_LONGITUDE'
      +' WHERE'
      +' EV_IND_KLE_DOSSIER=:DOSSIER'
      +' AND coalesce(UPPER(EV_IND_VILLE),'''')=UPPER(:EV_VILLE_OLD)'
      +' AND coalesce(UPPER(EV_IND_SUBD),'''')=UPPER(:EV_SUBD_OLD)');
    if iTag>0 then
      q.SQL.Add('AND coalesce(EV_IND_CP,'''')=:EV_CP_OLD');
    if iTag>1 then
      q.SQL.Add('AND coalesce(UPPER(EV_IND_DEPT),'''')=UPPER(:EV_DEPT_OLD)'
        +' AND coalesce(UPPER(EV_IND_REGION),'''')=UPPER(:EV_REGION_OLD)'
        +' AND coalesce(UPPER(EV_IND_PAYS),'''')=UPPER(:EV_PAYS_OLD)');

    sErreur:=ExecuteRequete;
    if sErreur>'' then
      MyMessageDlg(rs_Error_Individual_events_have_not_been_updated+_CRLF+_CRLF+sErreur
        ,mtError, [mbCancel],Self)
    else
    begin
      q.SQL.Add('UPDATE EVENEMENTS_FAM SET'
        +' EV_FAM_CP=:EV_CP'
        +',EV_FAM_VILLE=:EV_VILLE'
        +',EV_FAM_DEPT=:EV_DEPT'
        +',EV_FAM_REGION=:EV_REGION'
        +',EV_FAM_PAYS=:EV_PAYS'
        +',EV_FAM_INSEE=:EV_INSEE'
        +',EV_FAM_SUBD=:EV_SUBD'
        +',EV_FAM_LATITUDE=:EV_LATITUDE'
        +',EV_FAM_LONGITUDE=:EV_LONGITUDE'
        +' WHERE'
        +' EV_FAM_KLE_DOSSIER=:DOSSIER'
        +' AND coalesce(UPPER(EV_FAM_VILLE),'''')=UPPER(:EV_VILLE_OLD)'
        +' AND coalesce(UPPER(EV_FAM_SUBD),'''')=UPPER(:EV_SUBD_OLD)');
      if iTag>0 then
        q.SQL.Add('AND coalesce(EV_FAM_CP,'''')=:EV_CP_OLD');
      if iTag>1 then
        q.SQL.Add('AND coalesce(UPPER(EV_FAM_DEPT),'''')=UPPER(:EV_DEPT_OLD)'
          +' AND coalesce(UPPER(EV_FAM_REGION),'''')=UPPER(:EV_REGION_OLD)'
          +' AND coalesce(UPPER(EV_FAM_PAYS),'''')=UPPER(:EV_PAYS_OLD)');

      sErreur:=ExecuteRequete;
      if sErreur>'' then
        MyMessageDlg(rs_Error_Family_events_have_not_been_updated+_CRLF+_CRLF+sErreur
          ,mtError, [mbCancel],Self);
    end;
  finally
    q.Free;
    if sErreur>'' then
      dm.IBTrans_Secondaire.RollbackRetaining
    else
      dm.IBTrans_Secondaire.CommitRetaining;
    doModeBoutons(True);
    Screen.Cursor:=crDefault;
  end;

  ModalResult:=mrOk;
end;

procedure TFModifFavoris.SuperFormCreate(Sender:TObject);
begin
  OnShowFirstTime:=SuperFormShowFirstTime;
  Color:=gci_context.ColorLight;
  fbInfosVilles.Color:=gci_context.ColorLight;
  fbInfosVilles.ColorFrameFocus:=gci_context.ColorLight;
  btnInternet.PopupMenu:=FMain.pmLieuInternet;
  btnVillesVoisines.PopupMenu:=FMain.pmVillesVoisines;
  GoodBtnToutCopier.Hint:=rs_Hint_Copy_every_fields+rs_Hint_Copy_Field;
  if dm.IBBaseParam.Connected Then
   Begin
     DSCountries.DataSet:=IBQCountries;
     IBQCountries.Open;
   end;
end;

procedure TFModifFavoris.edLATITUDEPropertiesExit(Sender:TObject);
var
  s:string;
  l:Double;
begin
  s:=(Sender as TCustomMaskEdit).Text;
  if Length(s)>0 then
  begin
    if StrToFloatDef(s,3141592)=3141592 then
    begin
      MyMessageDlg(rs_Error_Latitud_must_be_a_number, mtError, [mbOK],Self);
      Abort;
    end
    else
    begin
      l:=StrToFloat(s);
      if (l>90)or(l<-90) then
      begin
        if Sender = edLATITUDE
         Then s := rs_Error_Latitud_interval
         Else s := rs_Error_Longitud_interval;
        MyMessageDlg(s, mtError, [mbOK],Self);
        Abort;
      end;
    end;
  end;
end;

procedure TFModifFavoris.SuperFormShowFirstTime(Sender:TObject);
begin
  Caption:=rs_Modify_an_used_site;
end;

procedure TFModifFavoris.btnInternetPopupMenuPopup(Sender:TObject;
  var APopupMenu:TPopupMenu;var AHandled:Boolean);
begin
  FMain.Lieu_Pays:=edPays.Text;
  FMain.Lieu_Region:=edRegion.Text;
  FMain.Lieu_CP:=edCP.Text;
  FMain.Lieu_Ville:=dxViller.Text;
  FMain.Lieu_Latitude:=edLatitude.Text;
  FMain.Lieu_Longitude:=edLongitude.Text;
  FMain.Lieu_Subdivision:=edSubd.Text;
end;

procedure TFModifFavoris.p_AfterDownloadCoord;
begin
  if dm.UneSubd>'' then
    edSubd.Text:=dm.UneSubd;
  edLATITUDE.Text:=dm.UneLatitude;
  edLONGITUDE.Text:=dm.UneLongitude;
End;
procedure TFModifFavoris.mAcquerirClick(Sender: TObject);
begin
  if pmGoogle.AutoPopup then
  begin
    dm.UneLatitude:=edLATITUDE.Text;
    dm.UneLongitude:=edLONGITUDE.Text;
    dm.UneSubd:=edSubd.Text;
    DoCoordNext:=TProcedureOfObject(p_AfterDownloadCoord);
    dm.GetCoordonneesInternet(dxViller.Text,edDept.Text,edRegion.Text,edPays.Text,self);
  end;
end;

procedure TFModifFavoris.pmGooglePopup(Sender: TObject);
begin
  if pmGoogle.AutoPopup then
    dxStatusBar.Panels[0].Text:=mAcquerir.Hint;
end;

procedure TFModifFavoris.EffaceBarreEtat(Sender: TObject);
begin
  dxStatusBar.Panels[0].Text:='';
end;

procedure TFModifFavoris.InfoCopieBas(Sender: TObject);
begin
  dxStatusBar.Panels[0].Text:=rs_Hint_Copy_Field;
end;

procedure TFModifFavoris.CopyVersBas(Sender: TObject);
var
  de,en:TEdit;
  lwin_Next : TWinControl ;
begin
  if (Sender=dxCPr)or(Sender=edCP) then
  begin
    de:=TEdit(dxCPr);
    en:=TEdit(edCP);
  end
  else if (Sender=dxViller)or(Sender=dxViller) then
  begin
    de:=TEdit(dxViller);
    en:=TEdit(dxViller);
  end
  else if (Sender=dxInseer)or(Sender=edInsee) then
  begin
    de:=TEdit(dxInseer);
    en:=TEdit(edInsee);
  end
  else if (Sender=dxDeptr)or(Sender=edDept) then
  begin
    de:=TEdit(dxDeptr);
    en:=TEdit(edDept);
  end
  else if (Sender=dxRegionr)or(Sender=edRegion) then
  begin
    de:=TEdit(dxRegionr);
    en:=TEdit(edRegion);
  end
  else if (Sender=dxPaysr)or(Sender=edPays) then
  begin
    de:=TEdit(dxPaysr);
    en:=TEdit(edPays);
  end
  else if (Sender=dxSubdr)or(Sender=edSubd) then
  begin
    de:=TEdit(dxSubdr);
    en:=TEdit(edSubd);
  end
  else if (Sender=dxLatituder)or(Sender=edLATITUDE) then
  begin
    de:=TEdit(dxLatituder);
    en:=TEdit(edLATITUDE);
  end
  else if (Sender=dxLongituder)or(Sender=edLONGITUDE) then
  begin
    de:=TEdit(dxLongituder);
    en:=TEdit(edLONGITUDE);
  end
  else
  begin
    de:=nil;
    en:=nil;
  end;
  en.Text:=de.Text;
  if Sender=dxPaysr then
    dxCPr.SetFocus
  else if Sender=edPays then
    edCP.SetFocus
  else
  Begin
    lwin_Next := FindNextControl( ActiveControl, True, False, True );
    if ( lwin_Next <> nil ) Then
      SetFocusedControl ( lwin_Next );
    //SelectNext ne fonctionne pas avec les compos DevExpress
  End;
end;

procedure TFModifFavoris.HautKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    if key=Ord('D')then
      CopyVersBas(Sender);
  end;
end;

procedure TFModifFavoris.BasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    case key of
      Ord('D'):CopyVersBas(Sender);
      Ord('G'):mAcquerirClick(Sender);
    end;
  end;
end;

procedure TFModifFavoris.InfoCopieHaut(Sender: TObject);
begin
  dxStatusBar.Panels[0].Text:=rs_Hint_Copy_Top_Coord;
end;

end.

