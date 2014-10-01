unit u_objet_TMotsClesDate;

interface

uses
  Classes,u_gedcom_const,Db,lazutf8classes;


type
  TMotsClesDate=Class
    Token_mots:array [_TYPE_TOKEN_JANVIER.._TYPE_TOKEN_JULIEN] of TStringlistUTF8;
    Token_mots_maj:array [_TYPE_TOKEN_JANVIER.._TYPE_TOKEN_VERS] of TStringlistUTF8;
    Token_mots_ST:array [_TYPE_TOKEN_DU.._TYPE_TOKEN_VERS] of TStringlistUTF8;
    Token_Julien_maj:TStringlistUTF8;
  private

  public
    constructor create;
    destructor Destroy; override;
    procedure LoadMotClefDate(const QueryToClone:TDataset;const Langue:String);
    function CommenceParToken(ChaineDate:string):boolean;

  end;

implementation

uses
  u_objet_TGedcomDate,
  Forms,
  fonctions_string,
  fonctions_dbcomponents,
  SysUtils,
  u_common_functions;

constructor TMotsClesDate.create;
var
  i:integer;
begin
  for i:=_TYPE_TOKEN_JANVIER to _TYPE_TOKEN_JULIEN do
  begin
    Token_mots[i]:=TStringlistUTF8.create;
    if i<=_TYPE_TOKEN_VERS then
    begin
      Token_mots_maj[i]:=TStringlistUTF8.Create;
      if i>=_TYPE_TOKEN_DU then
        Token_mots_ST[i]:=TStringlistUTF8.Create;
    end;
    if i=_TYPE_TOKEN_JULIEN then
      Token_Julien_maj:=TStringlistUTF8.create;
  end;
end;

destructor TMotsClesDate.Destroy;
var
  i:integer;
begin
  for i:=_TYPE_TOKEN_JANVIER to _TYPE_TOKEN_JULIEN do
  begin
    Token_mots[i].free;
    if i<=_TYPE_TOKEN_VERS then
    begin
      Token_mots_maj[i].free;
      if i>=_TYPE_TOKEN_DU then
        Token_mots_ST[i].free;
    end;
    if i=_TYPE_TOKEN_JULIEN then
      Token_Julien_maj.free;
  end;
  inherited;
end;

procedure TMotsClesDate.LoadMotClefDate(const QueryToClone:TDataset;const Langue:String);
  procedure ClearListToken;
  var
    i:integer;
  begin
    for i:=_TYPE_TOKEN_JANVIER to _TYPE_TOKEN_JULIEN do
    begin
      Token_mots[i].Clear;
      if i<=_TYPE_TOKEN_VERS then
      begin
        Token_mots_maj[i].Clear;
        if i>=_TYPE_TOKEN_DU then
          Token_mots_ST[i].Clear;
      end;
      if i=_TYPE_TOKEN_JULIEN then
        Token_Julien_maj.Clear;
    end;
  end;

var
  s,t:string;
  ASousType:Boolean;
  i:integer;
  q:TDataSet;
begin
  Q:=fdat_CloneDatasetWithoutSQL(QueryToClone,nil);
  with q do
  try
    p_OpenSQLQuery(q,'select 1 from rdb$relation_fields where rdb$relation_name=''REF_TOKEN_DATE'''
      +' and rdb$field_name=''SOUS_TYPE''');
    ASousType:=not Eof;
    Close;
    if ASousType then
      p_SetSQLQuery(q,'select type_token,token,sous_type from ref_token_date where langue=:langue'
        +' order by id')
    else
      p_SetSQLQuery(q,'select type_token,token,'''' as sous_type from ref_token_date where langue=:langue'
        +' order by id');
    p_setParamDataset (q,'LANGUE',Langue);
    Open;
    if Eof then
    begin
      Close;
      if ASousType then
        p_OpenSQLQuery(q,'select type_token,token,sous_type from ref_token_date'
          +' order by id')
      else
        p_OpenSQLQuery(q,'select type_token,token,'''' as sous_type from ref_token_date'
          +' order by id');
    end;
    ClearListToken;
    while not Eof do
    begin
      t:=Trim(FieldByName('TOKEN').AsString);
      s:=Trim(FieldByName('sous_type').AsString);
      i:=FieldByName('TYPE_TOKEN').AsInteger;
      if (i in [_TYPE_TOKEN_JANVIER.._TYPE_TOKEN_JULIEN]) and (t>'') then
      begin
        Token_mots[i].Add(t);
        if i<=_TYPE_TOKEN_VERS then
        begin
          Token_mots_maj[i].Add(fs_FormatText(t,mftUpper,True));
          if i>=_TYPE_TOKEN_DU then
            Token_mots_ST[i].Add(s);
        end;
        if i=_TYPE_TOKEN_JULIEN then
          Token_Julien_maj.Add(fs_FormatText(t,mftUpper,True));
      end;
      Next;
    end;
    Close;
  finally
    Destroy;
  end;

  if Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE].Count=0 then
     Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE].Add(DateSeparator);
  if Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE].IndexOf(' ')=-1 then
     Token_mots[_TYPE_TOKEN_SEPARATEUR_DATE].Add(' ');
  while Token_mots[_TYPE_TOKEN_FORME].Count>1 do
    Token_mots[_TYPE_TOKEN_FORME].Delete(Token_mots[_TYPE_TOKEN_FORME].Count-1);
  if Token_mots[_TYPE_TOKEN_FORME].Count=0 then
    Token_mots[_TYPE_TOKEN_FORME].Add('LIT');
  if Token_mots[_TYPE_TOKEN_ORDRE].Count=0 then //Token_Ordre[0] pour LIT, Token_Ordre[1] pour NUM
    Token_mots[_TYPE_TOKEN_ORDRE].Add('DMY');
  if Token_mots[_TYPE_TOKEN_ORDRE].Count=1 then
    Token_mots[_TYPE_TOKEN_ORDRE].Add(Token_mots[_TYPE_TOKEN_ORDRE][0]);
  if Token_mots[_TYPE_TOKEN_JULIEN].Count=0 then
  begin
    Token_mots[_TYPE_TOKEN_JULIEN].Add('Ju');
    Token_mots[_TYPE_TOKEN_JULIEN].Add('julien');
    Token_Julien_maj.Add('JU');
    Token_Julien_maj.Add('JULIEN');
  end;
end;

function TMotsClesDate.CommenceParToken(ChaineDate:string):boolean;
var//on pourrait utiliser _GDate.Key1='' à la place mais serait plus long
  n,i:integer;

  function DansList(fTokenDate:TStringlistUTF8):boolean;
  var
    i,l:integer;
  begin
    Result:=False;
    for i:=0 to fTokenDate.count-1 do
    begin
      l:=length(fTokenDate[i])+1;
      if n>l then
        if copy(ChaineDate,1,l)=fTokenDate[i]+' ' then
        begin
          Result:=True;
          Break;
        end;
    end;
  end;

begin
  n:=length(ChaineDate);
  for i:=_TYPE_TOKEN_DU to _TYPE_TOKEN_VERS do
  begin
    Result:=DansList(Token_mots[i]);
    if Result then Break;
  end;
end;

end.
