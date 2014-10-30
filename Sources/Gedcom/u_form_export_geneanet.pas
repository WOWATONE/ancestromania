{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
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

unit u_form_export_geneanet;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  jpeg, Windows,
{$ELSE}
{$ENDIF}
  U_FormAdapt,u_comp_TYLanguage,Dialogs,DB,
  IBCustomDataSet,IBQuery,StdCtrls,DBGrids,ExtCtrls,u_buttons_appli, Classes;

type

  { TFExportGeneanet }

  TFExportGeneanet=class(TF_FormAdapt)
    FWSee: TFWFolder;
    IBQPatronymes:TIBQuery;
    IBQPatronymesNOM:TIBStringField;
    DSPatronymes:TDataSource;
    QGeneanet:TIBQuery;
    Panel1:TPanel;
    Panel2:TPanel;
    Panel3:TPanel;
    Panel4:TPanel;
    Panel5:TPanel;
    grid:TDBGrid;
    Panel6:TPanel;
    Label37:TLabel;
    Panel7:TPanel;
    Image1:TImage;
    SaveDialog:TSaveDialog;
    Language:TYLanguage;
    btnExport:TFWExport;
    Memo1:TMemo;
    procedure btnExportClick(Sender:TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FWSeeClick(Sender: TObject);
    procedure IBQPatronymesAfterScroll(DataSet: TDataSet);
    procedure Image1Click(Sender:TObject);
    procedure SuperFormRefreshControls(Sender:TObject);
    procedure SuperFormCreate(Sender:TObject);
  private

  public
    procedure doPrepare;
  end;

implementation

uses u_dm,
  u_objet_TCut,u_common_functions,
  u_common_ancestro,u_common_ancestro_functions,
  lazutf8classes,
  fonctions_dialogs,
  fonctions_system,
  u_genealogy_context,
  u_common_const;

{$IFDEF FPC}{$R *.lfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TFExportGeneanet }

procedure TFExportGeneanet.doPrepare;
begin
  IBQPatronymes.DisableControls;
  IBQPatronymes.Close;
  IBQPatronymes.Params[0].AsInteger:=dm.NumDossier;
  IBQPatronymes.Open;
  IBQPatronymes.Last;
  IBQPatronymes.First;
  IBQPatronymes.EnableControls;
  doRefreshControls;
end;

procedure TFExportGeneanet.btnExportClick(Sender:TObject);
var
  k,tot:integer;
  fContent:TStringlistUTF8;
  fCut:TCut;
begin
  tot:=0;
  btnExport.Enabled:=false;
  if (IBQPatronymes.Active)and(not IBQPatronymes.IsEmpty) then
  begin
    fContent:=TStringlistUTF8.create;

    fCut:=TCut.create;
    fCut.ParamSeparator:=';';
    fCut.SetTotalStringParams(10);

    IBQPatronymes.DisableControls;
    try
      doShowWorking(rs_Please_Wait);
      try
        QGeneanet.Close;
        QGeneanet.ParamByName('I_DOSSIER').AsInteger:=dm.NumDossier;
        for k:=0 to grid.SelectedRows.Count-1 do
        begin
          IBQPatronymes.GotoBookMark(grid.SelectedRows [k]);
          QGeneanet.ParamByName('S_PATRONYME').AsString:=IBQPatronymesNOM.AsString;
          QGeneanet.Open;
          while not QGeneanet.Eof do
          begin
            fCut.Params[0].AsString:=IBQPatronymesNOM.AsString;
            fCut.Params[1].AsString:='';
            fCut.Params[2].AsString:=QGeneanet.FieldByName('DATE_DEBUT').AsString;
            fCut.Params[3].AsString:=QGeneanet.FieldByName('DATE_FIN').AsString;
            fCut.Params[4].AsString:=QGeneanet.FieldByName('COMBIEN').AsString;
            fCut.Params[5].AsString:=QGeneanet.FieldByName('VILLE').AsString;
            fCut.Params[6].AsString:=QGeneanet.FieldByName('CP').AsString;
            fCut.Params[7].AsString:='';
            fCut.Params[8].AsString:=QGeneanet.FieldByName('PAYS_CODE').AsString;
            fCut.Params[9].AsString:='F';

            fCut.ParamsToStr;
            fContent.Add(fCut.Line);
            inc(tot);

            QGeneanet.Next;
          end;
          QGeneanet.Close;
        end;
      finally
        doCloseWorking;
      end;
      if tot>0 then
      begin
        SaveDialog.InitialDir:=gci_context.PathImportExport;

        if SaveDialog.Execute then
        begin
          fContent.SaveToFile(SaveDialog.FileName);
          MyMessageDlg(rs_Info_Geneanet_Export_is_a_success_Import_it_on_geneanet_org
            ,mtInformation, [mbOK]);
        end;
      end
      else
      begin
        MyMessageDlg(rs_Info_Nobody_to_export,mtInformation, [mbOK]);
      end;
    finally
      IBQPatronymes.EnableControls;
      fCut.Free;
      fContent.free;
    end;
  end;
  DoRefreshControls;
end;

procedure TFExportGeneanet.FormDestroy(Sender: TObject);
begin
  grid.SelectedRows.Clear;
end;

procedure TFExportGeneanet.FWSeeClick(Sender: TObject);
begin
  p_OpenFileOrDirectory(gci_context.PathImportExport);
end;

procedure TFExportGeneanet.IBQPatronymesAfterScroll(DataSet: TDataSet);
begin
  doRefreshControls;
end;

procedure TFExportGeneanet.Image1Click(Sender:TObject);
begin
  GotoThisURL('www.geneanet.org');
end;

procedure TFExportGeneanet.SuperFormRefreshControls(Sender:TObject);
begin
  btnExport.enabled:=(IBQPatronymes.Active)and(not IBQPatronymes.IsEmpty)
    and(Grid.SelectedRows.Count>0);
end;

procedure TFExportGeneanet.SuperFormCreate(Sender:TObject);
begin
  OnRefreshControls := SuperFormRefreshControls;
  Color:=gci_context.ColorLight;
  Memo1.Color:=gci_context.ColorLight;
  Language.RessourcesFileName:=_REL_PATH_TRADUCTIONS+_FileNameTraduction;
  Language.Translate;
end;

end.

