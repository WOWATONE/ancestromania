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

unit u_gedcom_func;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses u_common_resources,LazUTF8Classes,Classes;

type
  TSetCodageCaracteres=(ccNone,ccANSEL,ccDOS,ccWindows,ccMacintosh,ccUTF8);

//function AssembleString(s:array of string;Separator:string):string;
//function AssembleAllString(s:array of string;Separator:string):string;
function TestAnselMatching(c1,c2:char;var cc:char):boolean;

function Ansel2Ansi(SBefore:string):string;
function Ansi2Ansel(SBefore:string):string;
function Ansi2Mac(SBefore:string):string;
function MacToAnsi(SBefore:string):string;

function MacToIso(C:char):char;
function IsoToMac(C:char):char;

function ConversionChaine(const aChaine:string;const FromFormat:TSetCodageCaracteres=ccUTF8):utf8string;
function ConversionToChaine(const aChaine:string;const ToFormat:TSetCodageCaracteres=ccUTF8):string;
function fs_convert_from_utf8_to_windows ( const as_chaine : String ) : String;

function FileReadlnOriginal(const AFile : THandle; var as_chaine : String ; const JeuCaractere :TSetCodageCaracteres ):Longint;
function FileReadlnUTF8(const AFile : THandle; var as_chaine : String ; const JeuCaractere :TSetCodageCaracteres ):Longint;
procedure FileWrite0(const AFile : TFileStreamUTF8; const as_chaine : UTF8String = '' );
function FileCreateDeleteFile0 ( const as_filename : String ) :TFileStreamUTF8;
procedure AddCharsetsToStrings ( const aST_Strings : TStrings );

const
  MAXTABLE=47;
  ANSELTABLE:array[0..MAXTABLE] of string=
  ('âe','áe','ãe','èe','âo','áo','ão','èo','âa','áa','ãa','èa','âu','áu','ãu','èu','âi','ái','ãi','èi','ây','èy','ðc','~n',
    'âE','áE','ãE','èE','âO','áO','ãO','èO','âA','áA','ãA','èA','âU','áU','ãU','èU','âI','áI','ãI','èI','âY','èY','ðC','~N');
  ANSITABLE:array[0..MAXTABLE] of char=
  ('é','è','ê','ë','ó','ò','ô','ö','á','à','â','ä','ú','ù','û','ü','í','ì','î','ï','ý','ÿ','ç','ñ',
    'É','È','Ê','Ë','Ó','Ò','Ô','Ö','Á','À','Â','Ä','Ú','Ù','Û','Ü','Í','Ì','Î','Ï','Ý','Ÿ','Ç','Ñ');

  NONE=$2E;{ Car. Mac pour remplacer les inexistants }

  MacToIso1:array[0..255] of byte=(
    $00,$01,$02,$03,$04,$05,$06,$07,
    $08,$09,$0A,$0B,$0C,$0D,$0E,$0F,
    $10,$11,$12,$13,$14,$15,$16,$17,
    $18,$19,$1A,$1B,$1C,$1D,$1E,$1F,
    $20,$21,$22,$23,$24,$25,$26,$27,
    $28,$29,$2A,$2B,$2C,$2D,$2E,$2F,
    $30,$31,$32,$33,$34,$35,$36,$37,
    $38,$39,$3A,$3B,$3C,$3D,$3E,$3F,
    $40,$41,$42,$43,$44,$45,$46,$47,
    $48,$49,$4A,$4B,$4C,$4D,$4E,$4F,
    $50,$51,$52,$53,$54,$55,$56,$57,
    $58,$59,$5A,$5B,$5C,$5D,$5E,$5F,
    $60,$61,$62,$63,$64,$65,$66,$67,
    $68,$69,$6A,$6B,$6C,$6D,$6E,$6F,
    $70,$71,$72,$73,$74,$75,$76,$77,
    $78,$79,$7A,$7B,$7C,$7D,$7E,$7F,
    $C4,$C5,$C7,$C9,$D1,$D6,$DC,$E1,//80
    $E0,$E2,$E4,$E3,$E5,$E7,$E9,$E8,//88
    $EA,$EB,$ED,$EC,$EE,$EF,$F1,$F3,//90
    $F2,$F4,$F6,$F5,$FA,$F9,$FB,$FC,//98
    NONE,$B0,$A2,$A3,$A7,$2E,$B6,$DF,//A0
    $AE,$A9,NONE,$B4,$A8,NONE,$C6,$D8,//A8
    NONE,$B1,NONE,NONE,$A5,$B5,NONE,NONE,//B0
    NONE,NONE,NONE,$AA,$BA,NONE,$E6,$F8,//B8
    $BF,$A1,$AC,NONE,NONE,NONE,NONE,$AB,//C0
    $BB,NONE,$A0,$C0,$C3,$D5,$8C,$9C,//C8
    $2D,$2D,$22,$22,$27,$27,$F7,NONE,//D0
    $FF,NONE,NONE,$80,NONE,NONE,NONE,NONE,//D8
    NONE,$B7,NONE,NONE,NONE,$C2,$CA,$C1,//E0
    $CB,$C8,$CD,$CE,$CF,$CC,$D3,$D4,//E8
    NONE,$D2,$DA,$DB,$D9,NONE,NONE,NONE,//F0
    $AF,NONE,NONE,NONE,$B8,NONE,NONE,NONE//F8
    );

//  NOPE = $B7;
  NOPE=$2E;
  Iso1ToMac:array[0..255] of byte=(
    $00,$01,$02,$03,$04,$05,$06,$07,
    $08,$09,$0A,$0B,$0C,$0D,$0E,$0F,
    $10,$11,$12,$13,$14,$15,$16,$17,
    $18,$19,$1A,$1B,$1C,$1D,$1E,$1F,
    $20,$21,$22,$23,$24,$25,$26,$27,
    $28,$29,$2A,$2B,$2C,$2D,$2E,$2F,
    $30,$31,$32,$33,$34,$35,$36,$37,
    $38,$39,$3A,$3B,$3C,$3D,$3E,$3F,
    $40,$41,$42,$43,$44,$45,$46,$47,
    $48,$49,$4A,$4B,$4C,$4D,$4E,$4F,
    $50,$51,$52,$53,$54,$55,$56,$57,
    $58,$59,$5A,$5B,$5C,$5D,$5E,$5F,
    $60,$61,$62,$63,$64,$65,$66,$67,
    $68,$69,$6A,$6B,$6C,$6D,$6E,$6F,
    $70,$71,$72,$73,$74,$75,$76,$77,
    $78,$79,$7A,$7B,$7C,$7D,$7E,$7F,
    $DB,NOPE,NOPE,NOPE,NOPE,NOPE,NOPE,NOPE,//80
    NOPE,NOPE,NOPE,NOPE,$CE,NOPE,NOPE,NOPE,//88
    NOPE,NOPE,NOPE,NOPE,NOPE,NOPE,NOPE,NOPE,//90
    NOPE,NOPE,NOPE,NOPE,$CF,NOPE,NOPE,NOPE,//98
    $CA,$C1,$A2,$A3,NOPE,$B4,$7C,$A4,//A0
    $AC,$A9,$BB,$C7,$C2,$2D,$A8,$F8,//A8
    $A1,$B1,NOPE,NOPE,$AB,$B5,$A6,$A5,//B0
    $FC,NOPE,$BC,$C8,NOPE,NOPE,NOPE,$C0,//B8
    $CB,$E7,$E5,$CC,$80,$81,$AE,$82,//C0
    $E9,$83,$E6,$E8,$ED,$EA,$EB,$EC,//C8
    NOPE,$84,$F1,$EE,$EF,$CD,$85,NOPE,//D0
    $AF,$F4,$F2,$F3,$86,NOPE,NOPE,$A7,//D8
    $88,$87,$89,$8B,$8A,$8C,$BE,$8D,//E0
    $8F,$8E,$90,$91,$93,$92,$94,$95,//E8
    NOPE,$96,$98,$97,$99,$9B,$9A,$D6,//F0
    $BF,$9D,$9C,$9E,$9F,NOPE,NOPE,$D8//F8
    );

var
  StrAnsi:string;
  gs_GedcomCharsetTo   : String = rs_charset_gedcom;
  gs_GedcomCharsetFrom : String = rs_charset_gedcom;

const CST_SEPARATE_WORDS = #9;
    CST_SEPARATE_LINES_INT = 0;
    CST_SEPARATE_LINES = #0;
    CST_CHARSET_TO_CONVERT : Array [ 0..{$IFNDEF DisableAsianCodePages}21{$ELSE}17{$ENDIF}, 0..1 ] of String =
    (('iso88591','ISO_8859_1'),
    ('iso885915','ISO_8859_15'),
    ('iso88592','ISO_8859_2'),
    ('cp1250','CP1250'),
    ('cp1251','CP1251'),
    ('cp1252','CP1252'),
    ('cp1253','CP1253'),
    ('cp1254','CP1254'),
    ('cp1255','CP1255'),
    ('cp1256','CP1256'),
    ('cp1257','CP1257'),
    ('cp1258','CP1258'),
    ('cp437','CP437'),
    ('cp850','CP850'),
    ('cp852','CP852'),
    ('cp866','CP866'),
    ('cp874','CP874'),
    {$IFNDEF DisableAsianCodePages}
    ('cp936','CP936'),
    ('cp950','CP950'),
    ('cp949','CP949'),
    ('cp932','CP932'),
    {$ENDIF}
    ('koi8','KOI8'));


implementation

uses
{$IFNDEF FPC}
  windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, LConvEncoding,
  LazUTF8,
  FileUtil,
  fonctions_file,
  u_objet_TMotsClesDate;

var
  aze:integer;



{function AssembleString(s:array of string;Separator:string):string;
var  //identique Ã  AssembleStringWithSep de u_common_func
  i:Integer; //et dÃ©claration en conflit avec la version AssembleString de u_common_func  AL
  sub:string;
begin
  result:='';
  for i:=0 to High(s) do
  begin
    sub:=trim(s[i]);
    if sub<>'' then
    begin
      if (result<>'')and(i>0) then  //and(i>0) inutile, result='' quand i=0!
        result:=result+Separator;
      result:=result+sub;
    end;
  end;
end;

function AssembleAllString(s:array of string;Separator:string):string;
var
  i:Integer;
  sub:string;
begin
  result:='';
  for i:=0 to High(s) do
  begin
    sub:=trim(s[i]);
    if (i>0) then result:=result+Separator;
    result:=result+sub;
  end;
end;}

function TestAnselMatching(c1,c2:char;var cc:char):boolean;
var
  i:integer;
begin
  Result:=false;
  if (ord(c1)>=128) then
  begin
    for i:=0 to MAXTABLE do
      if (ANSELTABLE[i]=(string(c1)+string(c2))) then
      begin
        cc:=ANSITABLE[i];
        Result:=true;
        break;
      end;
  end;
end;

function Ansel2Ansi(SBefore:string):string;
var
  n,k:integer;
  c1,c2,cc:char;
begin
  k:=length(SBefore);
  if k<2 then
    Result:=SBefore
  else
  begin
    Result:='';
    c1:=SBefore[1];
    n:=2;

    repeat
      c2:=SBefore[n];
      inc(n);
      if TestAnselMatching(c1,c2,cc) then //les 2 caractères forment un Ansel
      begin
        Result:=Result+cc;
        if n<=k then
        begin
          c1:=SBefore[n];
          if n=k then
            Result:=Result+c1;//correction AL 09/2011 dernier caractère oublié
          inc(n);
        end;
      end
      else
      begin
        Result:=Result+c1;
        if n>k then
          Result:=Result+c2;
        c1:=c2;
      end;
    until n>k;
  end;
end;

function fs_convert_from_to_utf8 ( const as_chaine, as_charset : String ) : String;
Begin
      //ANSI->UTF8
    if as_charset='iso88591' then begin
      Result:=ISO_8859_1ToUTF8(as_chaine);
    end
    else if as_charset='iso88592' then begin
      Result:=ISO_8859_2ToUTF8(as_chaine);
    end
    else if as_charset='cp1250' then begin
      Result:=CP1250ToUTF8(as_chaine);
    end
    else if as_charset='cp1251' then begin
      Result:=CP1251ToUTF8(as_chaine);
    end
    else if as_charset='cp1252' then begin
      Result:=CP1252ToUTF8(as_chaine);
    end
    else if as_charset='cp1253' then begin
      Result:=CP1253ToUTF8(as_chaine);
    end
    else if as_charset='cp1254' then begin
      Result:=CP1254ToUTF8(as_chaine);
    end
    else if as_charset='cp1255' then begin
      Result:=CP1255ToUTF8(as_chaine);
    end
    else if as_charset='cp1256' then begin
      Result:=CP1256ToUTF8(as_chaine);
    end
    else if as_charset='cp1257' then begin
      Result:=CP1257ToUTF8(as_chaine);
    end
    else if as_charset='cp1258' then begin
      Result:=CP1258ToUTF8(as_chaine);
    end
    else if as_charset='cp850' then begin
      Result:=CP850ToUTF8(as_chaine);
    end
    else if as_charset='cp852' then begin
      Result:=CP852ToUTF8(as_chaine);
    end
    else if as_charset='cp866' then begin
      Result:=CP866ToUTF8(as_chaine);
    end
    else if as_charset='cp874' then begin
      Result:=CP874ToUTF8(as_chaine);
    end
    {$IFNDEF DisableAsianCodePages}
    else if as_charset = 'cp936' then
    begin
      Result  := CP936ToUTF8(as_chaine);
    end
    else if as_charset = 'cp950' then
    begin
      Result  := CP950ToUTF8(as_chaine);
    end
    else if as_charset = 'cp949' then
    begin
      Result  := CP949ToUTF8(as_chaine);
    end
    else if as_charset = 'cp932' then
    begin
      Result  := CP932ToUTF8(as_chaine);
    end
    {$ENDIF}
    else if as_charset='koi8' then begin
      Result:=KOI8ToUTF8(as_chaine);
    end;
end;
function fs_convert_from_utf8_to ( const as_chaine, as_charset : String ) : String;
Begin
  if as_charset='iso88591' then begin
    Result:=UTF8ToISO_8859_1(as_chaine);
  end
  else if as_charset='iso88592' then begin
    Result:=UTF8ToISO_8859_2(as_chaine);
  end
  else if as_charset='cp1250' then begin
    Result:=UTF8ToCP1250(as_chaine);
  end
  else if as_charset='cp1251' then begin
    Result:=UTF8ToCP1251(as_chaine);
  end
  else if as_charset='cp1252' then begin
    Result:=UTF8ToCP1252(as_chaine);
  end
  else if as_charset='cp1253' then begin
    Result:=UTF8ToCP1253(as_chaine);
  end
  else if as_charset='cp1254' then begin
    Result:=UTF8ToCP1254(as_chaine);
  end
  else if as_charset='cp1255' then begin
    Result:=UTF8ToCP1255(as_chaine);
  end
  else if as_charset='cp1256' then begin
    Result:=UTF8ToCP1256(as_chaine);
  end
  else if as_charset='cp1257' then begin
    Result:=UTF8ToCP1257(as_chaine);
  end
  else if as_charset='cp1258' then begin
    Result:=UTF8ToCP1258(as_chaine);
  end
  else if as_charset='cp850' then begin
    Result:=UTF8ToCP850(as_chaine);
  end
  else if as_charset='cp852' then begin
    Result:=UTF8ToCP852(as_chaine);
  end
  else if as_charset='cp866' then begin
    Result:=UTF8ToCP866(as_chaine);
  end
  else if as_charset='cp874' then begin
    Result:=UTF8ToCP874(as_chaine);
  end
  {$IFNDEF DisableAsianCodePages}
  else if as_charset = 'cp936' then
  begin
    Result  := UTF8ToCP936(as_chaine);
  end
  else if as_charset = 'cp950' then
  begin
    Result  := UTF8ToCP950(as_chaine);
  end
  else if as_charset = 'cp949' then
  begin
    Result  := UTF8ToCP949(as_chaine);
  end
  else if as_charset = 'cp932' then
  begin
    Result  := UTF8ToCP932(as_chaine);
  end
  {$ENDIF}
  else if as_charset='koi8' then begin
    Result:=UTF8ToKOI8(as_chaine);
  end;
end;

// used to convert to windows charset
function fs_convert_from_utf8_to_windows ( const as_chaine : String ) : String;
Begin
  Result:=fs_convert_from_utf8_to(as_chaine, rs_charset_windows);
End;

function ConversionChaine(const aChaine:string;const FromFormat:TSetCodageCaracteres=ccUTF8):utf8string;
begin

 // Result := ConvertEncoding(aChaine, GuessEncoding(aChaine), EncodingUTF8);
  case FromFormat of
    ccANSEL:Result:=fs_convert_from_to_utf8 ( Ansel2Ansi(aChaine), rs_charset_gedcom);
    ccWindows:Result:=fs_convert_from_to_utf8(aChaine, gs_GedcomCharsetFrom);
    ccDOS:Result:=fs_convert_from_to_utf8(aChaine, gs_GedcomCharsetFrom);
    ccMacintosh:Result:=fs_convert_from_to_utf8(MacToAnsi(aChaine), rs_charset_gedcom);
    ccNone:Result:=aChaine;
    else
      result:=UTF8String(aChaine);
  end;
end;

function ConversionToChaine(const aChaine:string;const ToFormat:TSetCodageCaracteres=ccUTF8):string;
begin
  case ToFormat of
    ccANSEL:Result:=Ansi2Ansel(fs_convert_from_utf8_to(aChaine, rs_charset_gedcom));
    ccWindows:Result:=fs_convert_from_utf8_to(aChaine, gs_GedcomCharsetTo);
    ccDOS:Result:=fs_convert_from_utf8_to(aChaine, gs_GedcomCharsetTo);
    ccMacintosh:Result:=Ansi2Mac(fs_convert_from_utf8_to(aChaine, rs_charset_gedcom));
    ccUTF8:Begin
            Result:=aChaine;
            UTF8FixBroken(Result);
           End;
    else
      result:=aChaine;
  end;
end;

function Ansi2Ansel(SBefore:string):string;
var
  n,k:integer;
begin
  result:='';
  for n:=1 to length(SBefore) do
  begin
    k:=pos(SBefore[n],StrAnsi);
    if k=0 then
      result:=result+SBefore[n]
    else
      result:=result+ANSELTABLE[k-1];
  end;
end;

function MacToIso(C:char):char;
begin
  result:=chr(MacToIso1[ord(C)]);
end;

function IsoToMac(C:char):char;
begin
  result:=chr(Iso1ToMac[ord(C)]);
end;

function Ansi2Mac(SBefore:string):string;
var
  n:integer;
begin
  result:='';
  for n:=1 to length(SBefore) do
    result:=result+IsoToMac(SBefore[n]);
end;

function MacToAnsi(SBefore:string):string;
var
  n:integer;
begin
  result:='';
  for n:=1 to length(SBefore) do
    result:=result+MacToIso(SBefore[n]);
end;

procedure AddCharsetsToStrings ( const aST_Strings : TStrings );
var i :Integer;
begin
  if aST_Strings.Count = 0 Then
    for i :=0 to high ( CST_CHARSET_TO_CONVERT ) do
      aST_Strings.Add(CST_CHARSET_TO_CONVERT[i,1]);
End;
    // function FileCreateDeleteUTF8
// Deletes and create a file to result handle
function FileCreateDeleteFile0 ( const as_filename : String ) :TFileStreamUTF8;
var Buffer:Byte;
    lbom : String;
Begin
  if FileExistsUTF8(as_filename) Then
    DeleteFileUTF8(as_filename);
  Result:=TFileStreamUTF8.Create(as_filename,fmCreate);
  lbom:=UTF8BOM;
  Result.Write(lbom[1],Length(lbom));
  Buffer:=CST_SEPARATE_LINES_INT;
  Result.Write(Buffer,SizeOf(1));
end;


procedure FileWrite0(const AFile : TFileStreamUTF8; const as_chaine : UTF8String = '' );
var Buffer:Byte;
    astring : UTF8String;
Begin
  astring:=as_chaine;
  AFile.Write(astring[1],Length(astring));
  Buffer:=CST_SEPARATE_LINES_INT;
  AFile.Write(Buffer,SizeOf(1));
end;

function FileReadlnOriginal(const AFile : THandle; var as_chaine : String ; const JeuCaractere :TSetCodageCaracteres ):Longint;
Begin
  Result:=FileReadln(AFile,as_chaine);
  //if JeuCaractere <> ccUTF8 Then
    as_chaine:=ConversionChaine(as_chaine,JeuCaractere);
end;

function FileReadlnUTF8(const AFile : THandle; var as_chaine : String ; const JeuCaractere :TSetCodageCaracteres ):Longint;
Begin
  Result:=FileReadln(AFile,as_chaine);
  //if JeuCaractere <> ccUTF8 Then
    as_chaine:=ConversionChaine(as_chaine,JeuCaractere);
end;


initialization
  StrAnsi:='';
  for aze:=0 to MAXTABLE do
    AppendStr(StrAnsi,ANSITABLE[aze]);

end.