unit functions_html_tree;


{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  SysUtils, functions_html,
  fonctions_system;

var   gs_TreeLetterBegin : Char = 'a' ;

const CST_TREE_LETTER_BEGIN  = 'a' ;
      CST_TREE_LETTER_BARS  = 'B' ;
      CST_TREE_LETTER_SPACE = ' ' ;
      CST_TREE_LETTER_BLANK = '\' ;
      CST_TREE_LEVEL_BEGIN  = 0 ;
      CST_TREE_GIF_EXT      = '.gif';
      CST_TREE_LINK         = '<A HREF="javascript:b(''';
      CST_FILE_TREE         = 'Tree';
      {$IFDEF VERSIONS}
       gver_fonctions_html_tree : T_Version = ( Component : 'Static Web Tree Management' ;
                                           FileUnit : 'fonctions_languages' ;
                    			   Owner : 'Matthieu Giroux' ;
                    			   Comment : 'Static Web Tree Management' ;
                    			   BugsStory : 'Version 0.9.0.0 : Created from old project.' + #13#10;
                    			   UnitType : 1 ;
                    			   Major : 0 ; Minor : 9 ; Release : 0 ; Build : 0 );
      {$ENDIF}


var gs_HTMLTreeNodeLink : String;
function fs_GetNodeLink ( const as_NodeLink : String; const ai_CurrentLevel : Integer ): String;
function  fs_Create_Tree_DIV        ( const as_Name        : String      ;
                                      const as_IdEqual  : String = CST_HTML_ID_EQUAL;
                                      const Is_Visible  : Boolean   = False ):String ;
procedure p_setLevel ( const astl_HTMLTree : TStrings;
                       const as_NodeLink : String;
                       const ab_IsFirst : Boolean;
                       const ai_CurrentLevel, ai_PreviousLevel : Integer ;
                       const ab_div : Boolean );
function fs_CreateLineImages ( const as_LettersImages : String; const ai_CurrentLevel : Integer ): String;
function fs_NewLineImages ( const as_LettersImages : String; const ab_HasNext : Boolean; const ai_CurrentLevel : Integer ): String;
procedure p_setEndHTMLFile(const astl_HTMLTree : TStrings);
procedure p_setEndLine ( var as_Line : String;
                         const as_Text, as_NodeLink : String;
                         const ab_HasNext, ab_IsEnd : Boolean;
                         const ai_CurrentLevel, ai_NextLevel : Integer ;
                         const ab_Link, ab_div : Boolean );
function  fs_Create_Tree_Image      ( const as_Image       : String;
                                      const as_Text        : String  = ''):String ;

implementation

uses fonctions_string;

function  fs_Create_Tree_Image           ( const as_Image       : String;
                                      const as_Text        : String  = ''):String ;
  Begin
    If as_Text = ''
      Then
        Result := CST_HTML_IMAGE_SRC + as_Image + '">'
      Else
        Result := CST_HTML_IMAGE_SRC + as_Image + '">' + as_Text ;
  End ;

function  fs_Create_Image_Link      ( const Image       ,
                                            Name        : String;
                                      const Text        : String = ''     ) :String ;
  Begin
    If Text = ''
      Then
        Result := CST_TREE_LINK + Name + ''')" NAME=' + Name + ' >' +CST_HTML_IMAGE_SRC + Image + '" ' + CST_HTML_ID_EQUAL + Name + '></A>'
      Else
        Result := CST_TREE_LINK + Name + ''')" NAME=' + Name + ' >' +CST_HTML_IMAGE_SRC + Image + '" ' + CST_HTML_ID_EQUAL + Name + '>' + Text + '</A>' ;
  End ;


function fs_GetNodeLink ( const as_NodeLink : String; const ai_CurrentLevel : Integer ): String;

  function fs_getNewNodeLink : String;
  Begin
    Result :=  as_NodeLink + CST_TREE_LETTER_BEGIN
  end;

Begin
  If length ( gs_HTMLTreeNodeLink ) >= ai_CurrentLevel + 1
    Then
      If chr ( ord (gs_HTMLTreeNodeLink[ai_CurrentLevel + 1 ]) + 1 ) <> CST_TREE_LETTER_BLANK
        Then
          Begin
            gs_HTMLTreeNodeLink := Copy ( gs_HTMLTreeNodeLink, 1, ai_CurrentLevel )+ chr ( ord (gs_HTMLTreeNodeLink[ai_CurrentLevel + 1 ]) + 1 )
                                +  fs_RepeteChar(chr(ord(CST_TREE_LETTER_BEGIN)-1),Length(gs_HTMLTreeNodeLink)-ai_CurrentLevel-1);
            Result := copy ( gs_HTMLTreeNodeLink, 1, ai_CurrentLevel +1 );
          end
        Else
          Result := fs_getNewNodeLink
    Else
      If length ( as_NodeLink ) < ai_CurrentLevel + 1
        Then
          Result :=  fs_getNewNodeLink ;
End;

function fs_NewLineImages ( const as_LettersImages : String; const ab_HasNext : Boolean; const ai_CurrentLevel : Integer ): String;
Begin
  Result := as_LettersImages;
  If ab_HasNext
    Then
      Begin
        If ai_CurrentLevel >= length (as_LettersImages)
          Then
            Result := Result + CST_TREE_LETTER_BARS
          Else
            Result [ai_CurrentLevel + 1] := CST_TREE_LETTER_BARS ;
      End
    Else
      Begin
        If ai_CurrentLevel >= length (as_LettersImages)
          Then
            Result := Result + CST_TREE_LETTER_SPACE
          Else
            Result [ai_CurrentLevel + 1] := CST_TREE_LETTER_SPACE ;
      End ;
end;
function fs_CreateLineImages ( const as_LettersImages : String; const ai_CurrentLevel : Integer ): String;
var li_j           : Integer     ;
Begin
  Result := '';
  For li_j := 1 to ai_CurrentLevel do
   If as_LettersImages [li_j] = ' '
     Then
       Result := Result + fs_Create_Tree_Image ( 's' + CST_TREE_GIF_EXT )
     Else
       Result := Result + fs_Create_Tree_Image ( 'i' + CST_TREE_GIF_EXT );
end;

procedure p_setEndLine ( var as_Line : String;
                         const as_Text, as_NodeLink : String;
                         const ab_HasNext, ab_IsEnd : Boolean;
                         const ai_CurrentLevel, ai_NextLevel : Integer ;
                         const ab_Link, ab_div : Boolean );
Begin
  if not ab_IsEnd Then
    Begin
      If ( ai_NextLevel > ai_CurrentLevel )
        Then
          if ab_Link Then
            Begin
              If ab_HasNext
                Then as_Line := as_Line + fs_Create_Image_Link ( '+' + CST_TREE_GIF_EXT, as_NodeLink )
                Else as_Line := as_Line + fs_Create_Image_Link ( 'p' + CST_TREE_GIF_EXT, as_NodeLink );
            end
          else
           If ab_HasNext
            Then as_Line := as_Line + fs_Create_Tree_Image ( '+' + CST_TREE_GIF_EXT )
            Else as_Line := as_Line + fs_Create_Tree_Image ( 'p' + CST_TREE_GIF_EXT );

      If ai_NextLevel = ai_CurrentLevel
        Then
          as_Line := as_Line + fs_Create_Tree_Image ( 't' + CST_TREE_GIF_EXT ) ;
    end;

  If ab_IsEnd
  or ( ai_NextLevel < ai_CurrentLevel )
    Then
       as_Line := as_Line + fs_Create_Tree_Image ( 'l' + CST_TREE_GIF_EXT );


  AppendStr ( as_Line, fs_Create_Tree_Image ( 'r' + CST_TREE_GIF_EXT ) + fs_Create_Text ( as_Text ));
  if ab_div
  and ( ai_CurrentLevel <> ai_NextLevel )
   then AppendStr ( as_Line, CST_HTML_DIV_End )
   Else AppendStr ( as_Line, CST_HTML_BR );
end;

procedure p_setEndHTMLFile(const astl_HTMLTree : TStrings);
begin
  astl_HTMLTree.Add('<SCRIPT LANGUAGE="JavaScript1.2">arrangeNetscape("'+gs_TreeLetterBegin+'");</SCRIPT>' );
end;

procedure p_setLevel ( const astl_HTMLTree : TStrings;
                       const as_NodeLink : String;
                       const ab_IsFirst : Boolean;
                       const ai_CurrentLevel, ai_PreviousLevel : Integer ;
                       const ab_div : Boolean );
Begin
  If ai_CurrentLevel = 0
    Then
      Begin
        If ab_IsFirst
          Then
            astl_HTMLTree.Add ( fs_Create_Tree_Image ( 'a' + CST_TREE_GIF_EXT, '') +CST_HTML_BR );
        if ab_div
         Then
          astl_HTMLTree.Add ( fs_Create_Tree_DIV ( as_NodeLink, CST_HTML_ID_EQUAL, True ));
      End
    Else
      If ( ai_PreviousLevel <> ai_CurrentLevel )
      and ab_div
        Then
          astl_HTMLTree.Add ( fs_Create_Tree_DIV ( as_NodeLink, CST_HTML_ID_EQUAL, False ));
end;

function  fs_Create_Tree_DIV        ( const as_Name        : String      ;
                                      const as_IdEqual  : String = CST_HTML_ID_EQUAL;
                                      const Is_Visible  : Boolean   = False ):String ;
Begin
  if length ( gs_HTMLTreeNodeLink ) < length ( as_Name )
   Then
    gs_HTMLTreeNodeLink := as_Name ;
  If Is_Visible
    Then
      Result := '<' + CST_HTML_DIV + as_IdEqual + as_Name + CST_HTML_DIV_SHOW + '>'
    Else
      Result := '<' + CST_HTML_DIV + as_IdEqual + as_Name + '>' ;
End ;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gver_fonctions_html_tree );
{$ENDIF}
end.

