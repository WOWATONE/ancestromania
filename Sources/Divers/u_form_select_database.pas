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

unit u_form_select_database;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, ShlObj, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,Forms,u_comp_TYLanguage,
  Dialogs,u_buttons_defs,StdCtrls,
  ExtCtrls,Graphics,Controls,SysUtils,
  u_buttons_appli,
  u_framework_components, u_ancestropictimages,
  Menus, Classes;

type

  { TFSelectDatabase }

  TFSelectDatabase=class(TF_FormAdapt)
    BtnParcourir: TFWFolder;
    BtnEffacer: TFWErase;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label4: TLabel;
    Panel3:TPanel;
    Panel4:TPanel;
    Panel1:TPanel;
    Image2:TIAMouse;
    Label7:TLabel;
    Label2:TLabel;
    Image3:TImage;
    StatusConnect:TLabel;
    Label3:TLabel;
    Label11:TLabel;
    Language:TYLanguage;
    BtnOuvrir:TFWOK;
    lbEmplacementbdd:TFWComboBox;
    procedure BtnParcourirClick(Sender: TObject);
    procedure SuperFormShowFirstTime(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
    procedure BtnOuvrirClick(Sender:TObject);
    procedure lbEmplacementbddPropertiesButtonClick(Sender:TObject);
    procedure Effacerhistorique1Click(Sender:TObject);
    procedure SuperFormClose(Sender: TObject; var Action: TCloseAction);

  public

  end;

implementation

uses u_dm,
     u_form_main,
     u_common_functions,
     u_common_ancestro,
     u_common_const,
     u_genealogy_context,IniFiles,
     fonctions_init,
     fonctions_dialogs,
     FileUtil,
     u_common_ancestro_functions,
     fonctions_string;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TFSelectDatabase.SuperFormShowFirstTime(Sender:TObject);
begin
  screen.Cursor:=crDefault;
  if dm.ibd_BASE.Connected then
  begin
    StatusConnect.Font.Color:=clGreen;
    StatusConnect.Caption:=fs_RemplaceMsg(rs_Ancestromania_is_connected_to_this_database,[gci_context.PathFileNameBdd]);
  end
  else
  begin
    StatusConnect.Font.Color:=clRed;
    StatusConnect.Caption:=rs_Ancestromania_is_not_connected_to_a_database;
  end;
end;

procedure TFSelectDatabase.BtnParcourirClick(Sender: TObject);
var
  NewFileName:string;
begin
  NewFileName:=lbEmplacementbdd.Text;
  with dm.OpenFirebird do
   Begin
    FileName:='';
      //préparation de la boite OpenDialog
    if DirectoryExistsUTF8(ExtractFilePath(lbEmplacementbdd.Text)) then
      begin
        InitialDir:=ExtractFilePath(lbEmplacementbdd.Text);
        if FileExistsUTF8(lbEmplacementbdd.Text)  then
          FileName:=ExtractFileName(lbEmplacementbdd.Text);
      end
      else
      begin
        if FileExistsUTF8(dm.ibd_BASE.DatabaseName) then
        begin
          InitialDir:=ExtractFilePath(dm.ibd_BASE.DatabaseName);
          FileName:=ExtractFileName(dm.ibd_BASE.DatabaseName);
        end
        else
          {$IFDEF WINDOWS}
          InitialDir:=fPath_MesDocuments;
          {$ELSE}
          InitialDir:=DEFAULT_FIREBIRD_DATA_DIR;
          {$ENDIF}
      end;

    if Execute then
     Begin
      p_AddToCombo ( lbEmplacementbdd,FileName,True);
      lbEmplacementbddPropertiesButtonClick(Self);
     end;
   end;
end;


procedure TFSelectDatabase.SuperFormCreate(Sender:TObject);
begin
  f_GetMemIniFile;
  p_ReadComboBoxItems(lbEmplacementbdd,lbEmplacementbdd.Items);
  lbEmplacementbdd.ItemIndex := f_IniReadSectionInt(Name,lbEmplacementbdd.name,lbEmplacementbdd.ItemIndex);
  Color:=gci_context.ColorLight;
  BtnOuvrir.Color:=gci_context.ColorLight;
  BtnOuvrir.ColorFrameFocus:=gci_context.ColorLight;
  screen.Cursor:=crHourglass;
  OnShowFirstTime:=SuperFormShowFirstTime;

  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;

  lbEmplacementbdd.Text:=gci_context.PathFileNameBdd;

  BtnOuvrir.Hint:=rs_Hint_if_server_version_is_used_maj_will_open_connexion_dialog;
end;

procedure TFSelectDatabase.BtnOuvrirClick(Sender:TObject);
begin
  BtnOuvrir.Enabled:=false;
  try
    gci_context.PathFileNameBdd:=trim(lbEmplacementbdd.Text);

    dm.doCloseDatabase;
    p_AddToCombo(lbEmplacementbdd,lbEmplacementbdd.Text);

    dm.doOpenDatabase;
    Application.ProcessMessages;
    FMain.doRefreshControls;

    doCloseWorking;
    if dm.ibd_BASE.Connected then
    begin
      f_GetMemIniFile();
      //sauvegarde si la base est connectée uniquement
      gci_context.WritePathNameBddIntoIni;
      StatusConnect.Font.Color:=clGreen;
      StatusConnect.Caption:=fs_RemplaceMsg(rs_Ancestromania_is_connected_to_this_database,[gci_context.PathFileNameBdd]);

      DoSendMessage(Owner,'DO_AFTER_SELECT_DATABASE');
      Close;
    end
    else
    begin
      StatusConnect.Font.Color:=clRed;
      StatusConnect.Caption:=rs_Ancestromania_is_not_connected_to_a_database;
      BtnOuvrir.Enabled:=true;
    end;
  finally
    screen.Cursor:=crDefault;
  end;
end;

procedure TFSelectDatabase.lbEmplacementbddPropertiesButtonClick(
  Sender:TObject);
Begin
  BtnOuvrir.Enabled:=True;
end;

procedure TFSelectDatabase.Effacerhistorique1Click(Sender:TObject);
begin
  lbEmplacementbdd.Items.Clear;
end;

procedure TFSelectDatabase.SuperFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  f_GetMemIniFile;
  p_writeComboBoxItems(lbEmplacementbdd,lbEmplacementbdd.Items);
  p_IniWriteSectionInt(Name,lbEmplacementbdd.name,lbEmplacementbdd.ItemIndex);
  fb_iniWriteFile(FIniFile,False);
  Action:=caFree;
  FreeAndNil(FIniFile);
end;

end.

