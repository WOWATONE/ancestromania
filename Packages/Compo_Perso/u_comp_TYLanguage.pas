unit u_comp_TYLanguage;

interface

uses
  {$IFDEF FPC}
  LCLType,
  {$ELSE}
  Windows,
  {$ENDIF} Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Menus,
  stdctrls, inifiles, typinfo, comctrls, extctrls, buttons;

const
  _SECTION_CONFIG = 'Configuration';
  _SECTION_MESSAGES = 'Messages';
  _FONT = '$$FONT$$';
  _HINT = '$$HINT$$';


type
  TMyCompo = class(TComponent)
  private
    fFont: TFont;
  public

  published
    property Font: TFont read fFont write fFont;
  end;



  TMyIniFile = class(TIniFile)
  protected
    function FontToString(Font: TFont): string;
    procedure StringToFont(Str: string; Font: TFont);
  public
    procedure ReadFont(const Section, Ident: string; Default: TFont; Font: TFont);
    procedure WriteFont(const Section, Ident: string; Value: TFont);
  end;


  TMethod = (mRead, mWrite);



  TYLanguage = class(TComponent)
  private
    fPathFromApplication: boolean;
    fRessourcesFileName: string;
    //          fLangue: string;
    fWindow: string;
    fMethod: TMethod;
    fMenu: TMenuItem;
    FOnSelectLangue: TNotifyEvent;
    FUseThisDefaultMDIFormName: string;
    fDefaultFont: TFont;
    fMsg: TStringList;
    fListFileTraduction: TStringList;
    fListNameLanguage: TStringList;



    fDoMenu: boolean;
    fCharSet: TFontCharset;

    //          procedure ClickMenuItemLangue(Sender: TObject);
    procedure SetDefaultFont(const Value: TFont);
    //          procedure LoadListFileTraduction;


  protected
    procedure DoSelectLangue; dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure OnLanguageDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);

  public
    CurrentFontName: string;
    property Msg: TStringList read fMsg write fMsg;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //	  procedure InstallMenu;
    procedure Translate;

  published
    property Menu: TMenuItem read fMenu write fMenu;
    property RessourcesFileName: string read fRessourcesFileName write fRessourcesFileName;
    property PathFromApplication: boolean read fPathFromApplication write fPathFromApplication;
    //          property Langue: string read fLangue;
    property OnSelectLangue: TNotifyEvent read FOnSelectLangue write FOnSelectLangue;
    property UseThisDefaultMDIFormName: string read FUseThisDefaultMDIFormName write FUseThisDefaultMDIFormName;
    property DefaultFont: TFont read fDefaultFont write SetDefaultFont;
    property Method: TMethod read fMethod write fMethod;

    //   property TranslateMenu: boolean read fDoMenu write fDoMenu;
  end;


procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('YannPak', [TYLanguage]);
end;


procedure GetDirContent(InThisDir: string; aList: TStrings; What: string);
var
  SearchRec: TSearchRec;
  found: word;
begin
  InThisDir := InThisDir + What;
  aList.Clear;
  try
    found := findfirst(InThisDir, faArchive, searchrec);
    while found = 0 do
      begin
        aList.Add(searchrec.Name);

        found := findnext(searchrec);
      end;
  finally
    findclose(searchrec);
  end;
end;



{ TYLanguage }


constructor TYLanguage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fMenu := nil;
  fPathFromApplication := True;
  //     fLangue := '';
  fRessourcesFileName := '';
  fMethod := mRead;
  fWindow := (self.owner as TComponent).name;
  fDefaultFont := TFont.create;
  fMsg := TStringList.create;

  if SysLocale.FarEast then
    fCharset := SHIFTJIS_CHARSET
  else
    fCharset := DEFAULT_CHARSET;

  fListFileTraduction := TStringList.create;
  fListNameLanguage := TStringList.create;

end;


destructor TYLanguage.Destroy;
begin
  fDefaultFont.free;
  fMsg.free;

  fListFileTraduction.free;
  fListNameLanguage.free;

  inherited Destroy;
end;


{
procedure TYLanguage.ClickMenuItemLangue(Sender: TObject);
var
 n: integer;
 fIni: TIniFile;
 k: integer;
 fLangue, s: string;
begin
 if (fMenu <> nil) then
  if (fMenu is TMenuItem) then
  begin
   fLangue := (Sender as TMenuItem).caption;
   k := (Sender as TMenuItem).Tag;

   for n := 1 to fMenu.count do
    fMenu.Items[n - 1].Checked := (fMenu.Items[n - 1].Caption = fLangue);

   try
    if fPathFromApplication
     then
     fIni := TiniFile.Create(ExtractFilePath(Application.ExeName) + fRessourcesFileName)
    else
     fIni := TIniFile.Create(fRessourcesFileName);

    try
     if (k >= 1) and (k <= fListFileTraduction.count)
      then s := fListFileTraduction[k - 1]
     else s := '';

     fIni.WriteString(_SECTION_CONFIG, 'FileNameActifLanguage', s);
     fIni.UpdateFile;

    finally
     fIni.Free;
    end;

   except

   end;

   DoSelectLangue;
  end;
end;
}

procedure TYLanguage.DoSelectLangue;
begin
  if Assigned(FOnSelectLangue) then FOnSelectLangue(Self);
end;

{
procedure TYLanguage.InstallMenu;
var
     fIni: TIniFile;
     n, k: integer;
     MenuItem: TMenuItem;
     fFileNameLangue: string;
begin
     if (fMenu <> nil) then
          if (fMenu is TMenuItem) then
          begin
               //destruction des items précédants
               try
                    for n := fMenu.Count downto 1 do
                         fMenu.remove(fMenu.items[n - 1]);
               except
               end;

               //On charge les langages disponibles
   LoadListFileTraduction;


               try
                    if fPathFromApplication
                         then
                         fIni := TiniFile.Create(ExtractFilePath(Application.ExeName) + fRessourcesFileName)
                    else
                         fIni := TIniFile.Create(fRessourcesFileName);

                    try
                         fFileNameLangue := fIni.ReadString(_SECTION_CONFIG, 'FileNameActifLanguage', '');
                    finally
                         fIni.Free;
                    end;

                    k := fListFileTraduction.IndexOf(fFileNameLangue);

                    for n := 0 to fListNameLanguage.Count - 1 do
                    begin
                         MenuItem := TMenuItem.Create(Self.Owner);
                         MenuItem.Caption := fListNameLanguage[n];
                         MenuItem.GroupIndex := 123;
                         MenuItem.Checked := (k = n);
                         MenuItem.Tag := n + 1;
                         fMenu.Add(MenuItem);
                         MenuItem.OnClick := ClickMenuItemLangue;
                    end;


                    DoSelectLangue;

               except

               end;
          end;
end;

}



///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////




procedure TYLanguage.SetDefaultFont(const Value: TFont);
begin
  fDefaultFont.Assign(Value);
end;

procedure TYLanguage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = fMenu) then fMenu := nil;
end;

procedure TYLanguage.OnLanguageDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
begin
  Acanvas.Font.name := (Self.Owner as TForm).Font.name;
  Acanvas.Font.Color := (Self.Owner as TForm).Font.Color;
  Acanvas.TextRect(Arect, Arect.Left, ARect.Top, (Sender as TMenuitem).Caption);
end;


{
procedure TYLanguage.LoadListFileTraduction;
var
 s, w: string;
 n: integer;
 fIni: TIniFile;
begin
 fListFileTraduction.Clear;
 fListNameLanguage.Clear;

 if fPathFromApplication
  then s := ExtractFilePath(Application.ExeName)
 else s := ExtractFilePath(fRessourcesFileName);

 GetDirContent(s, fListFileTraduction, '*.traduc');

 for n := 0 to fListFileTraduction.Count - 1 do
 begin
  w := '';
  try
   //On ouvre le fichier pour récupérer les libellés des langues
   fIni := TIniFile.create(s + fListFileTraduction[n]);
   try
    w := fIni.ReadString(_SECTION_CONFIG, 'Name', '');
   finally
    fIni.Free;
   end;
  except
  end;
  fListNameLanguage.Add(w);
 end;
end;
 }

{TMyIniFile}

procedure TMyIniFile.ReadFont(const Section, Ident: string; Default: TFont;
  Font: TFont);
var
  Str: string;
begin
  Str := inherited ReadString(Section, Ident, FontToString(Default));
  try
    StringToFont(Str, Font);
  except
    on EConvertError do Font.Assign(Default);
    else
      raise;
  end;
end;

procedure TMyIniFile.WriteFont(const Section, Ident: string; Value: TFont);
begin
  inherited WriteString(Section, Ident, FontToString(Value));
end;

function TMyIniFile.FontToString(Font: TFont): string;
begin
  Result := Format('%s,%d,%d%d%d%d,%s', [Font.Name, Font.Size,
    Integer(fsBold in Font.Style), Integer(fsItalic in Font.Style),
      Integer(fsUnderline in Font.Style), Integer(fsStrikeOut in Font.Style),
      ColorToString(Font.Color)]);
end;

procedure TMyIniFile.StringToFont(Str: string; Font: TFont);
const
  SEP = ',';
  EXCEPT_MSG = 'Invalid string to font conversion.';
var
  i: Integer;
begin
  // name
  i := Pos(SEP, Str);
  if i = 0 then raise EConvertError.Create(EXCEPT_MSG);
  Font.Name := Copy(Str, 1, i - 1);
  Delete(Str, 1, i);

  // size
  i := Pos(SEP, Str);
  if i = 0 then raise EConvertError.Create(EXCEPT_MSG);
  Font.Size := StrToInt(Copy(Str, 1, i - 1));
  Delete(Str, 1, i);

  // bold, italic, underline, strikethrough
  if Pos(SEP, Str) <> 5 then raise EConvertError.Create(EXCEPT_MSG);
  Font.Style := [];
  if Boolean(StrToInt(Copy(Str, 1, 1))) then Font.Style := Font.Style + [fsBold];
  if Boolean(StrToInt(Copy(Str, 2, 1))) then Font.Style := Font.Style + [fsItalic];
  if Boolean(StrToInt(Copy(Str, 3, 1))) then Font.Style := Font.Style + [fsUnderline];
  if Boolean(StrToInt(Copy(Str, 4, 1))) then Font.Style := Font.Style + [fsStrikeOut];

  Delete(Str, 1, 5);

  // colour
  Font.Color := StringToColor(Str);
end;

///////////////////////////////////////////////////////////////////
//
//
//
///////////////////////////////////////////////////////////////////

procedure TYLanguage.Translate;
var
  fIni: TMyIniFile;
  fPreviousMethod: TMethod;
  n: integer;
  i, k, w, idx: integer;
  c: tcomponent;
  FList: PPropList;
  FCount: Integer;
  FSize: Integer;
  fn: string;
  fContent: TStringList;
  PropInfo: PPropInfo;
  //     myName: string;
       //     myObj: TObject;
       //     myFont: TFont;
       //     MySize: integer;
            //    FFont : TFont;
  s: string;

  procedure ReadFormFont;
  var
    s: string;
  begin
    s := fIni.ReadString(fn, _FONT, '');
    if s <> '' then
      fIni.ReadFont(fn, _FONT, fDefaultFont, TForm(self.owner).Font);
  end;

  procedure WriteFormFont;
  begin
    fIni.WriteFont(fn, _FONT, TForm(self.owner).Font);
  end;

begin
  try
    if FUseThisDefaultMDIFormName <> '' then
      fn := FUseThisDefaultMDIFormName
    else
      fn := fWindow;

    if fPathFromApplication
      then s := ExtractFilePath(Application.ExeName) + fRessourcesFileName
    else s := ExtractFilePath(fRessourcesFileName) + fRessourcesFileName;

    if FileExists(s) then
      begin
        fContent := TStringList.create;
        fIni := TMyiniFile.Create(s);
        try
          fPreviousMethod := fMethod;

          if fMethod = mRead then
            if AnsiUpperCase(fIni.ReadString(_SECTION_CONFIG, 'Method', '')) = 'WRITE' then fMethod := mWrite;

          if fMethod = mRead then
            begin
              //on s'occupe de la font de la form
              if (self.Owner is TForm) then
                begin
                  s := fIni.ReadString(fn, _FONT, '');
                  if s <> '' then
                    fIni.ReadFont(fn, _FONT, fDefaultFont, TForm(self.owner).Font);
                end;

              //on lit le nom de la form
              if (self.Owner is TForm) then TForm(self.owner).Caption := fIni.ReadString(fn, TForm(self.owner).Name + '.Caption', '');

              //si on est en lecture, on charge toute la section
              fIni.ReadSectionValues(fn, fContent);

              //Lecture des messages
              fIni.ReadSectionValues(fn + '/' + _SECTION_MESSAGES, fMsg);
            end
          else
            begin
              //on s'occupe de la font de la form
              if (self.Owner is TForm) then fIni.WriteFont(fn, _FONT, TForm(self.owner).Font);

              //on écrit le nom de la form
              if (self.Owner is TForm) then fIni.WriteString(fn, TForm(self.owner).Name + '.Caption', TForm(self.owner).Caption);
            end;


          //on boucle sur tous les composants de la fiche
          for n := 0 to self.owner.ComponentCount - 1 do
            begin
              c := self.owner.components[n];
              //                    if (self.Owner is TForm) then                         myName := (self.Owner as TForm).Font.Name;

              if c <> self then
                begin

                  FCount := GetPropList(c.ClassInfo, [tkString, tkLString, tkWString], nil);
                  FSize := FCount * SizeOf(Pointer);

                  GetMem(FList, FSize);
                  try
                    k := GetPropList(c.ClassInfo, [tkString, tkLString, tkWString], FList);
                    for w := 1 to k do
                      begin
                        try
                          if UpperCase(FList^[w - 1].Name) <> 'NAME' then
                            begin
                              //on tient une property d'un compo, de type string
                              if fMethod = mRead then
                                begin
                                  idx := fContent.IndexOfName(c.Name + '.' + FList^[w - 1].Name);
                                  if idx >= 0 then
                                    begin
                                      PropInfo := GetPropInfo(c.ClassInfo, FList^[w - 1].Name);
                                      if PropInfo <> nil then
                                        if propinfo^.PropType^.Kind = tkLString then
                                          begin
                                            if propinfo^.SetProc <> nil then
                                              begin
                                                setStrProp(c, propInfo, fContent.Values[c.Name + '.' + FList^[w - 1].Name]);
                                              end;
                                          end;
                                    end;
                                end
                              else
                                begin
                                  fIni.WriteString(fn, c.Name + '.' + FList^[w - 1].Name, GetStrProp(c, FList^[w - 1]));
                                end;
                            end;
                          //                                        if (self.Owner is TForm) then myName := (self.Owner as TForm).Font.Name;
                        except
                        end;
                      end;

                    {$IFNDEF FPC}
                    if fDoMenu then
                      begin
                        if (c is TMainMenu) then
                          begin
                            (c as TMainMenu).OwnerDraw := true;
                            for i := 0 to (c as TMainMenu).Items.Count - 1 do
                              begin
                                (c as TMainMenu).Items[0].OnClick := OnLanguageDrawItem;
                              end;
                          end;


                        if (c is TPopupMenu) then
                          begin
                            (c as TPopupMenu).OwnerDraw := true;
                            for i := 0 to (c as TPopupMenu).Items.Count - 1 do
                              begin
                                (c as TPopupMenu).Items[0].OnDrawItem := OnLanguageDrawItem;
                              end;
                          end;
                      end;

                    if fDoMenu then
                      begin

                        if (c is TMenuItem) then
                          begin
                            (c as TMenuItem).OnDrawItem := OnLanguageDrawItem;

                          end;
                      end;
                    {$ENDIF}
                  finally
                    if FList <> nil then FreeMem(FList, FSize);
                  end;
                end;
            end;


          if fMethod = mWrite then fIni.UpdateFile;

          fMethod := fPreviousMethod;

        finally
          fIni.free;
          fContent.free;
        end;
      end;

  except
  end;
end;

end.
