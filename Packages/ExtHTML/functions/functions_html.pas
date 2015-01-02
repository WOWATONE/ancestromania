unit functions_html;

{$IFDEF FPC}
  {$MODE objfpc}{$H+}
{$ELSE}
 {$DEFINE WINDOWS}
{$ENDIF}

interface

uses
  Classes,
  {$IFDEF FPC}
  FileUtil,
  {$ELSE}
  fonctions_system,
  {$ENDIF}
  fonctions_file,
  fonctions_string,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  SysUtils;

type THTMLULTabSheet = Record
      s_Title, s_link, s_info : String ;
      b_SheetSelected : Boolean ;
      a_Pages : Array of Record
                          s_Key, s_link : String ;
                          b_PageSelected : Boolean ;
                         End;
    end;
  TAHTMLULTabSheet = Array of THTMLULTabSheet;

const CST_HTML_DIV                 = 'DIV' ;
      CST_HTML_CENTER              = 'CENTER' ;
      CST_HTML_DIV_BEGIN           = '<'+CST_HTML_DIV+'>' ;
      CST_HTML_DIV_END             = '</'+CST_HTML_DIV+'>' ;
      CST_HTML_UL                  = 'UL' ;
      CST_HTML_MENU                 = 'tabsheets' ;
      CST_HTML_SUBMENU              = 'subsheets' ;
      CST_HTML_UL_BEGIN            = '<'+CST_HTML_UL+'>' ;
      CST_HTML_UL_END              = '</'+CST_HTML_UL+'>' ;
      CST_HTML_TABLE               = 'TABLE' ;
      CST_HTML_TABLE_BEGIN         = '<'+CST_HTML_TABLE+'>' ;
      CST_HTML_STRONG              = 'STRONG' ;
      CST_HTML_STRONG_BEGIN        = '<'+CST_HTML_STRONG+'>' ;
      CST_HTML_STRONG_END          = '</'+CST_HTML_STRONG+'>' ;
      CST_HTML_TABLE_END           = '</'+CST_HTML_TABLE+'>' ;
      CST_HTML_TR                  = 'TR' ;
      CST_HTML_TR_BEGIN            = '<'+CST_HTML_TR+'>' ;
      CST_HTML_TR_END              = '</'+CST_HTML_TR+'>' ;
      CST_HTML_TD                  = 'TD' ;
      CST_HTML_TD_BEGIN            = '<'+CST_HTML_TD+'>' ;
      CST_HTML_TD_END              = '</'+CST_HTML_TD+'>' ;
      CST_HTML_LI                  = 'LI' ;
      CST_HTML_LI_BEGIN            = '<'+CST_HTML_LI+'>' ;
      CST_HTML_LI_LEFT             = '<'+CST_HTML_LI+' CLASS="tab_left">' ;
      CST_HTML_LI_MIDDLE           = '<'+CST_HTML_LI+' CLASS="tab_middle">' ;
      CST_HTML_LI_RIGHT            = '<'+CST_HTML_LI+' CLASS="tab_right">' ;
      CST_HTML_LI_END              = '</'+CST_HTML_LI+'>' ;
      CST_HTML_A_BEGIN             = '<A' ;
      CST_HTML_A_BEGIN_LOWER       = '<a' ;
      CST_HTML_A_BEGIN_LINK        = 'www.' ;
      CST_HTML_A_BEGIN_LINK_HTTP   = 'http://' ;
      CST_HTML_A_BEGIN_LINK_HTTPS  = 'https://' ;
      CST_HTML_A_BEGIN_LINKS       : Array [0..1] of String = (CST_HTML_A_BEGIN_LINK_HTTP, CST_HTML_A_BEGIN_LINK_HTTPS) ;
      CST_HTML_A_END               = '</A>' ;
      CST_HTML_AHREF               = CST_HTML_A_BEGIN + ' HREF="' ;
      CST_HTML_SPAN                = 'SPAN' ;
      CST_HTML_SPAN_END            = '</'+CST_HTML_SPAN+'>' ;
      CST_HTML_SPAN_BEGIN          = '<'+CST_HTML_SPAN+'>' ;
      CST_HTML_Paragraph           = 'P';
      CST_HTML_Paragraph_BEGIN     = '<P>';
      CST_HTML_Paragraph_END       = '</P>';
      CST_HTML_Body_END            = '</BODY>';
      CST_HTML_HTML_END            = '</HTML>';
      CST_HTML_CENTER_BEGIN        = '<'+CST_HTML_CENTER+'>';
      CST_HTML_CENTER_END          = '</'+CST_HTML_CENTER+'>';
      CST_HTML_IMAGE_BEGIN         = '<IMG';
      CST_HTML_IMAGE_SRC           = '<IMG SRC="';
      CST_HTML_ID_EQUAL            = ' ID=';
      CST_HTML_NAME_EQUAL          = ' NAME=';
      CST_HTML_REL_EQUAL           = ' REL=';
      CST_HTML_TARGET_EQUAL        = ' TARGET=';
      CST_HTML_TARGET_BLANK        = '_blank';
      CST_HTML_TARGET_TOP          = '_top';
      CST_HTML_TARGET_PARENT       = '_parent';
      CST_HTML_CLASS_EQUAL         = ' CLASS=';
      CST_HTML_COLSPAN_EQUAL       = ' COLSPAN=';
      CST_HTML_BR                  = '<BR>';
      CST_HTML_H1                 = 'H1';
      CST_HTML_H1_BEGIN            = '<'+ CST_HTML_H1 + '>';
      CST_HTML_H1_END              = '</'+ CST_HTML_H1 + '>';
      CST_HTML_H2                 = 'H2';
      CST_HTML_H2_BEGIN            = '<'+ CST_HTML_H2 + '>';
      CST_HTML_H2_END              = '</'+ CST_HTML_H2 + '>';
      CST_HTML_H3                 = 'H3';
      CST_HTML_H3_BEGIN            = '<'+ CST_HTML_H3 + '>';
      CST_HTML_H3_END              = '</'+ CST_HTML_H3 + '>';
      CST_HTML_H4                 = 'H4';
      CST_HTML_H4_BEGIN            = '<'+ CST_HTML_H4 + '>';
      CST_HTML_H4_END              = '</'+ CST_HTML_H4 + '>';
      CST_HTML_DIV_SHOW            = ' STYLE="display:block"';

      CST_EXTENSION_HTML           = '.htm' ;
      CST_EXTENSION_JS             = '.js' ;
      CST_EXTENSION_PHP            = '.php' ;

      CST_HTML_DIR_SEPARATOR       = '/' ;
      CST_HTML_OUTDIR_SEPARATOR     = '..' + CST_HTML_DIR_SEPARATOR;

      // to replace
      CST_HTML_HEAD_IN_LANG_FILE   :Array [0..1] of String= ('Author','Keywords');
      CST_HTML_HEAD_AUTOKEYS       = 'AutoKeywords';
      CST_HTML_HEAD_DESCRIBE       = 'Description';
      CST_HTML_HEAD_TITLE          = 'Title';
      CST_HTML_HEAD_CHARSET        = 'Charset';
      CST_HTML_SECURITY            = 'Security';
      CST_HTML_LANG                = 'Lang';
      CST_HTML_LANGUAGE            = 'Language';
      CST_HTML_NAME                = 'Name';
      CST_HTML_CAPTION             = 'Caption';
      CST_HTML_RESET               = 'Reset';
      CST_HTML_SEND                = 'Send';
      CST_HTML_MAIL_IN_LANG_FILE   :Array [0..8] of String=  (CST_HTML_LANG,CST_HTML_LANGUAGE,'MailFrom','MailSentMessage','MailSubject','Message',CST_HTML_NAME,CST_HTML_RESET,CST_HTML_SEND);


      // files
      CST_HTML_FILE_HEAD         = 'Head.htm';
      {$IFDEF VERSIONS}
       gver_fonctions_html : T_Version = ( Component : 'Static Web Site Management' ;
                                           FileUnit : 'fonctions_languages' ;
                    			   Owner : 'Matthieu Giroux' ;
                    			   Comment : 'Static Web Site Management' ;
                    			   BugsStory : 'Version 0.9.0.0 : Created from old project.' + #13#10;
                    			   UnitType : 1 ;
                    			   Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );
      {$ENDIF}

function fs_CreateULTabsheets ( const at_TabSheets : TAHTMLULTabSheet ;
                               const as_Subdir : String ; const as_idMenu : String = CST_HTML_MENU ;
                               const ab_ShowPages : Boolean = True;
                               const ab_NoLink   : Boolean = False;
                               const ai_PageBegin : Longint = 1 ;
                               const as_Target    : String  = '') : String;
function fs_CreateElementWithId ( const as_ElementType   : String ;
                                       const as_idElement     : String ;
                                       const as_OptionToSetId : String = CST_HTML_ID_EQUAL ) : String;
procedure p_LoadStringList ( const astl_ToLoad : TStrings ; const as_File : String );

function  fs_Create_Image           ( const as_Image       : String;
                                      const as_Alt         : String  = '';
                                      const as_Id          : String  = ''):String ;
function  fs_Create_TD             ( const as_Name        : String  = ''  ;
                                     const as_IdEqual  : String = CST_HTML_ID_EQUAL;
                                     const ai_Colspan     : Integer = 1  ):String ;
function fs_exchange_special_chars ( const as_AnchorNotFormatted : String ):String;
function fs_create_anchor ( const as_AnchorNotFormatted : String ):String;
function  fs_Create_Link           ( const as_href        : String   ;
                                     const as_Text        : String   ;
                                     const as_Target      : String = '';
                                     const as_Options     : String = ''):String ;
function  fb_Link_has_got_http     ( const as_href_Text   : String   ):Boolean;
function  fs_Create_simple_Link    ( const as_href_Text   : String   ;
                                     const as_Target      : String = ''):String ;
function  fs_Create_DIV             ( const as_Name        : String      ;
                                      const as_IdEqual  : String = CST_HTML_ID_EQUAL;
                                      const Is_Visible  : Boolean   = False ):String ;
function  fs_Create_Text            ( const as_Text        : String      ;
                                      const as_Option      : String = '' ):String ;
function  fs_html_Lines             ( const as_Text        : String      ;
                                      const as_endoflinereplacing: String =CST_ENDOFLINE):String ;

function fs_createHead (const as_Describe, as_Keywords, as_title, as_language : String): String;
procedure p_CreateHTMLFile ( const at_TabSheets : TAHTMLULTabSheet ;
                             const astl_Destination : TStrings ;
                             const as_EndPage,
                                   as_Describe, as_Keywords,
                                   as_title, as_LongTitle : String ;
                             const as_FileBeforeHead, as_FileAfterHead,
                                   as_FileAfterMenu  , as_FileAfterBody,
                                   as_Subdir ,
                                   as_BeforeHTML, as_language : String ;
                             const astl_Body : TStrings = nil;
                             const ab_HtmlTitle : boolean = True );
function fs_GetSheetLink ( const at_TabSheets : TAHTMLULTabSheet ;
                           const as_Title : String ;
                           const as_KeyPage : String ):String;
function fb_FindTabSheet ( const at_TabSheets : TAHTMLULTabSheet ;
                           const as_Title : String ;
                                 as_KeyPage : String ;
                           var   ai_Main, ai_Page : Longint):Boolean;
procedure p_FreeKeyWords;
procedure p_addKeyWord ( as_KeyWord : String; const ach_Separator : Char = ' ' );
procedure p_ClearKeyWords;
procedure p_CreateKeyWords;
procedure p_AddTabSheet ( var  at_TabSheets : TAHTMLULTabSheet ;
                          const as_Title, as_link : String ; const as_info : String = '' );
procedure p_AddTabSheetPage ( var  at_TabSheets : TAHTMLULTabSheet ;
                             const ai_pos : Longint ;
                             const as_link : String ;
                             const as_keyPage : String = '');
procedure p_SelectTabSheet ( const at_TabSheets : TAHTMLULTabSheet ;
                             const as_Title : String ;
                             const as_KeyPage : String = '' ;
                             const ab_Select : Boolean = True );

var  gs_html_source_file : String = 'Files' + DirectorySeparator;
     gs_Root : String ;
     gstl_HeadKeyWords             : TStringlist = nil ;



implementation

uses Dialogs,fonctions_languages,
     unite_html_resources, StrUtils;


function fb_FindTabSheet ( const at_TabSheets : TAHTMLULTabSheet ;
                           const as_Title : String ;
                                 as_KeyPage : String ;
                           var   ai_Main, ai_Page : Longint):Boolean;
var li_i, li_j          : Integer;
Begin
 Result := False;
 for li_i := 0 to high ( at_TabSheets ) do
  with at_TabSheets [ li_i ] do
    Begin
      if s_Title=as_Title Then
        Begin
          ai_Main := li_i;
          if ( as_KeyPage = '' )
          or ( High(a_Pages) < 0 )
           Then Exit
           Else
            Begin
              as_KeyPage:=fs_exchange_special_chars (as_KeyPage);
              for li_j := 0 to High(a_Pages) do
               with a_Pages [ li_j ] do
                if ( as_KeyPage = s_Key )
                or ( li_j = high ( a_Pages ))
                or (( as_KeyPage < a_Pages [ li_j +1].s_Key ) and ( as_KeyPage >= s_Key )) Then
                Begin
                  ai_Page := li_j;
                  Result := True;
                  Exit;
                end;

            end;
          Exit;
        end;
    end;
end;



function fs_GetSheetLink ( const at_TabSheets : TAHTMLULTabSheet ;
                           const as_Title : String ;
                           const as_KeyPage : String ):String;
var li_i, li_j          : LongInt;
    lb_IsPage : Boolean ;
Begin
 li_i := -1 ;
 li_j := -1 ;
 lb_Ispage := fb_FindTabSheet ( at_TabSheets, as_Title, as_KeyPage, li_i, li_j );
 if li_i >= 0 Then
  with at_TabSheets [ li_i ] do
   if lb_IsPage
   Then Result := a_Pages [ li_j ].s_link
   Else Result := s_link;
end;
procedure p_SelectTabSheet ( const at_TabSheets : TAHTMLULTabSheet ;
                             const as_Title : String ;
                             const as_KeyPage : String = '' ;
                             const ab_Select : Boolean = True );
var li_i, li_j          : LongInt;
    lb_IsPage : Boolean ;
Begin
 li_i := -1 ;
 li_j := -1 ;
 lb_Ispage := fb_FindTabSheet ( at_TabSheets, as_Title, as_KeyPage, li_i, li_j );
 if li_i >= 0 Then
  with at_TabSheets [ li_i ] do
   if lb_IsPage
   Then a_Pages [ li_j ].b_PageSelected:=ab_Select
   Else b_SheetSelected:=ab_Select;
end;

procedure p_AddTabSheet ( var  at_TabSheets : TAHTMLULTabSheet ;
                          const as_Title, as_link : String ; const as_info : String = '' );
begin
  SetLength(at_TabSheets, high ( at_TabSheets ) + 2);
  with at_TabSheets [ High(at_TabSheets)] do
    Begin
      s_Title:=as_Title;
      s_info :=as_info;
      s_link :={$IFDEF WINDOWS}fs_RemplaceChar ( {$ENDIF}as_link{$IFDEF WINDOWS}, DirectorySeparator, CST_HTML_DIR_SEPARATOR ){$ENDIF};
    end;
end;
function fs_exchange_special_chars ( const as_AnchorNotFormatted : String ):String;
Begin
 Result:=fs_FormatText(as_AnchorNotFormatted,mftNone,True);
End;
function fs_create_anchor ( const as_AnchorNotFormatted : String ):String;
Begin
 Result := CST_HTML_A_BEGIN + CST_HTML_NAME_EQUAL + '"' + fs_exchange_special_chars (as_AnchorNotFormatted) + '" />'
end;

procedure p_AddTabSheetPage ( var  at_TabSheets : TAHTMLULTabSheet ;
                             const ai_pos : Longint ;
                             const as_link : String ;
                             const as_keyPage : String = '');

begin
 with at_TabSheets [ ai_pos ] do
  Begin
    SetLength ( a_Pages, high ( a_Pages ) + 2);
    with a_Pages [ High(a_Pages)] do
      Begin
       s_link := {$IFDEF WINDOWS}fs_RemplaceChar ( {$ENDIF}as_link{$IFDEF WINDOWS}, DirectorySeparator, CST_HTML_DIR_SEPARATOR ){$ENDIF};
       s_Key  := fs_exchange_special_chars (as_keyPage);
      end;
  end;
end;

procedure p_addKeyWord ( as_KeyWord : String; const ach_Separator : Char = ' ' );
var lstl_Keywords : TStrings;
    ls_KeyWord    : String;
    li_i          : Integer;
Begin
  lstl_Keywords := nil;
  as_KeyWord:=StringReplace(Trim(as_KeyWord),'"', '\"', [rfReplaceAll]);
  p_ChampsVersListe ( lstl_Keywords, as_KeyWord, ach_Separator );
  try
    if assigned ( gstl_HeadKeyWords ) Then
      for li_i:= 0 to lstl_Keywords.Count-1 do
        Begin
          ls_KeyWord := Trim ( lstl_Keywords [ li_i ] );
          if gstl_HeadKeyWords.IndexOf(ls_KeyWord)<0 Then
            gstl_HeadKeyWords.add (ls_KeyWord);
        end;

  finally
    lstl_Keywords.Free;
  end;
end;

procedure p_FreeKeyWords;
Begin
  gstl_HeadKeyWords.Free;
  gstl_HeadKeyWords := nil;
end;

procedure p_CreateKeyWords;
Begin
  gstl_HeadKeyWords.Free;
  gstl_HeadKeyWords := TStringList.Create;
end;

procedure p_ClearKeyWords;
Begin
  gstl_HeadKeyWords.Clear;
end;


function  fs_Create_DIV             ( const as_Name        : String      ;
                                      const as_IdEqual  : String = CST_HTML_ID_EQUAL;
                                      const Is_Visible  : Boolean   = False ):String ;
Begin
  If Is_Visible
    Then
      Result := '<' + CST_HTML_DIV + as_IdEqual + '"' + as_Name + '"' + CST_HTML_DIV_SHOW + '>'
    Else
      Result := '<' + CST_HTML_DIV + as_IdEqual + '"' +  as_Name +  '"' + '>' ;
End ;
function  fs_Create_TD             ( const as_Name        : String  = ''  ;
                                      const as_IdEqual  : String = CST_HTML_ID_EQUAL;
                                      const ai_Colspan     : Integer = 1  ):String ;
Begin
  Result := '<' + CST_HTML_TD ;
  if as_Name    > '' Then AppendStr(Result, as_IdEqual + '"' + as_Name + '"' );
  if ai_Colspan >  1  Then AppendStr(Result, CST_HTML_COLSPAN_EQUAL + '"' + IntToStr(ai_Colspan) + '"' );
  AppendStr(Result, '>' );
End ;

function fb_CreateAFromLink ( var as_Text        : String;
                              const ai_pos1 : Longint; ai_pos2 : Longint ):Boolean;
Begin

   inc( ai_Pos2 );
   Result := False;
   while ( ai_Pos2 <= length ( as_Text) )
   and ( fb_isFileChar(as_Text[ai_Pos2]) or (as_Text[ai_Pos2] = CST_HTML_DIR_SEPARATOR)) do
     Begin
       if not Result Then // is there a dot
         Result := (as_Text[ai_Pos2] = '.') and ( ai_Pos2 < length ( as_Text)) and fb_isFileChar(as_Text[ai_Pos2+1]);
       inc(ai_Pos2);
     end;
   dec ( ai_pos2 );
   if Result Then
    if ai_pos1 = 1 Then
     Begin
       if ai_pos2 >= Length(as_Text)
        Then as_Text:=fs_Create_simple_Link(as_Text,CST_HTML_TARGET_BLANK)
        Else as_Text:=fs_Create_simple_Link(copy(as_Text,1,ai_pos2), CST_HTML_TARGET_BLANK) +copy ( as_Text, ai_pos2 +1, Length ( as_Text ) - ai_pos2 );
      End
    Else
    if ai_pos2 >= Length(as_Text)
     Then as_Text:=copy ( as_Text, 1, ai_pos1 - 1 )+fs_Create_simple_Link(copy(as_Text,ai_pos1,ai_pos2-ai_pos1+1), CST_HTML_TARGET_BLANK)
     Else as_Text:=copy ( as_Text, 1, ai_pos1 - 1 )+fs_Create_simple_Link(copy(as_Text,ai_pos1,ai_pos2-ai_pos1+1), CST_HTML_TARGET_BLANK)+copy ( as_Text, ai_pos2 +1, Length ( as_Text ) - ai_pos2 );
End;

function  fs_html_Lines       ( const as_Text        : String      ;
                                const as_endoflinereplacing: String =CST_ENDOFLINE):String ;
var li_Pos1, li_Pos2, li_lengthlink, li_i : Longint;
begin
  Result := StringReplace ( as_Text, CST_ENDOFLINE, CST_HTML_BR+as_endoflinereplacing,[rfReplaceAll] );
  if  ( pos ( CST_HTML_A_BEGIN, Result ) = 0 )
  and ( pos ( CST_HTML_A_BEGIN_LOWER, Result ) = 0 ) Then
   begin
     for li_i := 0 to high(CST_HTML_A_BEGIN_LINKS) do
      Begin
       li_Pos1 := 1;
       li_lengthlink:=length( CST_HTML_A_BEGIN_LINKS[li_i]);
       while ( posex ( CST_HTML_A_BEGIN_LINKS[li_i], Result, li_Pos1 ) > 0 ) do
        Begin
         li_Pos1 :=posex ( CST_HTML_A_BEGIN_LINKS[li_i], Result, li_Pos1 );
         li_Pos2 := li_Pos1 + li_lengthlink;
         if  ( length ( Result ) > li_Pos2 )
         and fb_isFileChar(Result[li_Pos2]) Then
            fb_CreateAFromLink ( Result, li_Pos1, li_Pos2 );
         li_Pos1 := PosEx( CST_HTML_A_END, Result, li_Pos2 );
        end;
      end;
     li_Pos1 := 1;
     while ( posex ( CST_HTML_A_BEGIN_LINK, Result, li_Pos1 ) > 0 ) do
     Begin
       li_Pos1 :=posex ( CST_HTML_A_BEGIN_LINK, Result, li_Pos1 );
       if ( li_Pos1 = 1 )
       or ( Result[li_Pos1-1] <> '/' ) then
        Begin
          li_Pos2 := li_Pos1 + 4;
          if  ( length ( Result ) > li_Pos2 )
          and fb_isFileChar(Result[li_Pos2]) Then
           Begin
             fb_CreateAFromLink ( Result, li_Pos1, li_Pos2 );
           end;
          li_Pos1 := PosEx( CST_HTML_A_END, Result, li_Pos2 + li_Pos2 - li_Pos1 );
        end
       Else li_Pos1:=li_Pos1+4;
     end;
   end;
end;

function  fs_Create_Text            ( const as_Text        : String      ;
                                      const as_Option      : String = '' ):String ;

  Begin
    If length (as_Text) = 0
      Then
        Exit ;

    If as_Text [1] = '@'
      Then
        If pos ( '#', as_Text ) > 2
          Then
            Result := CST_HTML_A_BEGIN + copy ( as_Text, 2, pos ( '#', as_Text ) - 2 ) + '><' + CST_HTML_SPAN  + as_Option + '>'
                            + copy ( as_Text   , pos ( '#', as_Text ) + 1 , length (as_Text) - pos ( '#', as_Text )) + CST_HTML_SPAN_END+CST_HTML_A_END
          Else
            Result := CST_HTML_AHREF + copy ( as_Text, 2, length ( as_Text ) - 1 ) + '"><' + CST_HTML_SPAN  + as_Option + '>' + as_Text + CST_HTML_SPAN_END+CST_HTML_A_END
      Else
            Result := '<' + CST_HTML_SPAN  + as_Option + '>' + as_Text + CST_HTML_SPAN_END ;
  End ;


procedure p_LoadStringList ( const astl_ToLoad : TStrings ; const as_File : String );
begin
// Charge le fichier de base
  try
    if FileExistsUTF8(gs_Root + gs_html_source_file + as_File)
     Then p_LoadStrings( astl_ToLoad, gs_Root + gs_html_source_file + as_File, StringReplace ( gs_StringsHTML_cantOpenFile, '@ARG', gs_Root + gs_html_source_file + as_File, [rfReplaceAll] ))
     Else astl_ToLoad.Clear;
  Except
    Abort ;
  End ;
End;

function fs_CreateElementWithId ( const as_ElementType   : String ;
                                       const as_idElement     : String ;
                                       const as_OptionToSetId : String = CST_HTML_ID_EQUAL ) : String;
Begin
  Result := '<' + as_ElementType + as_OptionToSetId + '"' + as_idElement + '">';
end;
function  fb_Link_has_got_http     ( const as_href_Text   : String   ):Boolean;
var li_i : Integer;
Begin
  Result:=False;
  for li_i := 0 to high ( CST_HTML_A_BEGIN_LINKS ) do
   if pos ( CST_HTML_A_BEGIN_LINKS [li_i], as_href_Text ) > 0 Then
    Begin
      Result:=True;
      Exit;
    end;
end;

function  fs_Create_simple_Link    ( const as_href_Text   : String   ;
                                     const as_Target      : String = ''):String ;
Begin
  if fb_Link_has_got_http ( as_href_Text )
   Then Result := fs_Create_Link ( as_href_Text, as_href_Text, as_Target )
   Else Result := fs_Create_Link ( CST_HTML_A_BEGIN_LINK_HTTP + as_href_Text, as_href_Text, as_Target );
end;

function  fs_Create_Link           ( const as_href        : String   ;
                                     const as_Text        : String   ;
                                     const as_Target      : String = '';
                                     const as_Options     : String = ''):String ;
begin
  Result := CST_HTML_AHREF + as_href + '"' ;
  if as_Target > '' Then
    AppendStr(Result,CST_HTML_TARGET_EQUAL+'"' + as_Target + '"');
  if as_Options > '' Then
    AppendStr(Result, as_Options );
  AppendStr(Result,'>'+as_Text+CST_HTML_A_END);
end;

function fs_CreateULTabsheets ( const at_TabSheets : TAHTMLULTabSheet ;
                               const as_Subdir : String ;
                               const as_idMenu : String = CST_HTML_MENU ;
                               const ab_ShowPages : Boolean = True;
                               const ab_NoLink   : Boolean = False;
                               const ai_PageBegin : Longint = 1 ;
                               const as_Target    : String  = '') : String;
var li_i, li_j : Longint;
    lhut_sheet, la_Pages : THTMLULTabSheet;
    ls_Link : String ;
Begin
   if ( at_TabSheets <> nil )
   and ( high ( at_TabSheets ) > 0 ) Then
    Begin
      Result := fs_CreateElementWithId ( CST_HTML_DIV, as_idMenu )
             +  fs_CreateElementWithId ( CST_HTML_UL , as_idMenu ) +CST_ENDOFLINE;
      for li_i := 0 to  high ( at_TabSheets ) do
        Begin
          lhut_sheet := at_TabSheets [ li_i ];
          if li_i = 0 Then
            AppendStr(Result,CST_HTML_LI_LEFT)
          else if li_i = high ( at_TabSheets ) Then
            AppendStr(Result,CST_HTML_LI_RIGHT)
          else
            AppendStr(Result,CST_HTML_LI_MIDDLE);
          with lhut_sheet do
            Begin
              if b_SheetSelected
              Then AppendStr(Result,s_Title)
              Else
               Begin
                 if ab_NoLink
                  Then ls_Link := ''
                  else ls_Link := as_Subdir + s_Link;
                 AppendStr(Result,fs_Create_Link( ls_link + '#' + s_Title ,  s_Title, as_Target ))
               end;
              if ab_ShowPages
              and ( high ( a_Pages ) >= 0 ) Then
               Begin
                 AppendStr(Result, ' (' );
                 for li_j := 0 to high ( a_Pages ) do
                   with a_Pages [ li_j ] do
                    Begin
                       if ab_NoLink
                        Then ls_Link := ''
                        else ls_Link := as_Subdir + s_Link;
                      if b_PageSelected
                      Then AppendStr(Result,' ' + IntToStr(ai_PageBegin+li_j))
                      Else AppendStr(Result,' ' +fs_Create_Link( ls_link + '#' + s_Title , IntToStr(ai_PageBegin+li_j), as_Target ));
                    end;
                 AppendStr(Result, ' )' );
               end;
            end;
          AppendStr(Result,CST_HTML_LI_END+CST_ENDOFLINE);
        end;
      AppendStr(Result,CST_HTML_UL_END+CST_HTML_DIV_End+CST_HTML_BR+CST_ENDOFLINE);
    end
  Else Result := '' ;
end;

function fs_createHead (const as_Describe, as_Keywords, as_title, as_language : String ): String;
var  lstl_Head : TStringList;
Begin
  lstl_Head := TStringList.Create;
  try
    p_LoadStringList ( lstl_Head, CST_HTML_FILE_HEAD );
    p_ReplaceLanguagesStrings ( lstl_Head, CST_HTML_HEAD_IN_LANG_FILE );
    p_ReplaceLanguagesStrings ( lstl_Head, CST_HTML_HEAD_IN_LANG_FILE );
    p_ReplaceLanguageString(lstl_Head,CST_HTML_HEAD_DESCRIBE,StringReplace (as_Describe, CST_ENDOFLINE, '', [rfReplaceAll]));
    p_ReplaceLanguageString(lstl_Head,CST_HTML_HEAD_CHARSET,gs_HtmlCharset);
    p_ReplaceLanguageString(lstl_Head,CST_HTML_HEAD_TITLE,as_title);
    p_ReplaceLanguageString(lstl_Head,CST_HTML_LANG,gs_Lang);
    p_ReplaceLanguageString(lstl_Head,CST_HTML_LANGUAGE,as_language);
    p_ReplaceLanguageString(lstl_Head,CST_HTML_HEAD_AUTOKEYS,StringReplace (as_Keywords, CST_ENDOFLINE, ',', [rfReplaceAll]));
    Result := lstl_Head.Text;
  finally
    lstl_Head.Free;
  end;
end;

procedure p_CreateHTMLFile ( const at_TabSheets : TAHTMLULTabSheet ;
                             const astl_Destination : TStrings ;
                             const as_EndPage,
                                   as_Describe, as_Keywords,
                                   as_title, as_LongTitle : String ;
                             const as_FileBeforeHead, as_FileAfterHead,
                                   as_FileAfterMenu  , as_FileAfterBody,
                                   as_Subdir ,
                                   as_BeforeHTML, as_language : String ;
                             const astl_Body : TStrings = nil;
                             const ab_HtmlTitle : boolean = True );
var  lstl_HTML : TStringList;
     ls_Text1, ls_Text2, ls_Text3, ls_Text4, ls_Text5  : String ;
  procedure p_LoadText3 ( const astl_Strings : TStrings );
  begin
    p_ReplaceLanguageString(astl_Strings,CST_HTML_CAPTION,as_LongTitle);
    ls_Text3:=astl_Strings.Text
  end;

Begin
  lstl_HTML := TStringList.Create;
  try
    if as_FileBeforeHead > '' Then
      Begin
        p_LoadStringList ( lstl_HTML, as_FileBeforeHead );
        ls_Text1 := lstl_HTML.Text;
      end
     Else ls_Text1 := '' ;
    if as_FileAfterHead > '' Then
      Begin
        p_LoadStringList ( lstl_HTML, as_FileAfterHead );
        ls_Text2 := lstl_HTML.Text;
      end
     Else ls_Text2 := '' ;
    if astl_Body <> nil then
      Begin
        p_LoadText3 ( astl_Body );
      end
     Else
      if as_FileAfterMenu > '' Then
        Begin
          p_LoadStringList ( lstl_HTML, as_FileAfterMenu );
          p_LoadText3 ( lstl_HTML );
        end
       Else ls_Text3 := '' ;
    if as_FileAfterBody > '' Then
      Begin
        p_LoadStringList ( lstl_HTML, as_FileAfterBody );
        ls_Text4 := lstl_HTML.Text;
      end
     Else ls_Text4 := '';
    ls_Text5              := as_BeforeHTML + CST_ENDOFLINE + ls_Text1 + CST_ENDOFLINE + fs_createHead(as_Describe, as_Keywords, as_title, as_language) + CST_ENDOFLINE + ls_Text2 ;
    if ab_HtmlTitle Then
      AppendStr(ls_Text5, fs_CreateElementWithId(CST_HTML_DIV, 'title', CST_HTML_CLASS_EQUAL ) + CST_HTML_H1_BEGIN + as_title + CST_HTML_H1_END + CST_HTML_DIV_End);
    if assigned ( at_TabSheets ) Then
      AppendStr(ls_Text5, CST_ENDOFLINE + fs_CreateULTabsheets ( at_TabSheets, as_Subdir ) + CST_ENDOFLINE );
    astl_Destination.Insert(0, ls_Text5 + ls_Text3
                          +  CST_ENDOFLINE );
    astl_Destination.Add(  CST_ENDOFLINE + fs_html_Lines(as_EndPage)
                          +  CST_ENDOFLINE + ls_Text4);
  finally
    lstl_HTML.Destroy;
  end;
end;

function  fs_Create_Image           ( const as_Image       : String;
                                      const as_Alt         : String  = '';
                                      const as_Id          : String  = ''):String ;
  Begin
    Result := CST_HTML_IMAGE_SRC + as_Image + '"' ;
    If as_Alt > '' Then AppendStr ( Result, ' ALT="' + as_Alt + '"' );
    If as_Id  > '' Then AppendStr ( Result, CST_HTML_ID_EQUAL + '"' + as_id + '"' );
    AppendStr ( Result, ' />' );
  End ;



initialization
{$IFDEF VERSIONS}
  p_ConcatVersion ( gver_fonctions_html );
{$ENDIF}
finalization
  p_FreeKeyWords;
end.

