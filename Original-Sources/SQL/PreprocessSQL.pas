{
 Preprocess SQL
 Using FSQL, process the typed SQL and put the process SQL
 in FProcessedSQL and parameter names in FSQLParams
}
procedure TIBSQL.PreprocessSQL;
var
  cCurChar, cNextChar, cQuoteChar: Char;
  sSQL, sProcessedSQL, sParamName,MSQL: String; //AL2011
  i, iLenSQL, iSQLPos: Integer;
  iCurState, iCurParamState: Integer;
  iParamSuffix: Integer;
  slNames: TStrings;
  Continuer,IsExecBlock:boolean;//AL2011
  s:string;
const
  DefaultState = 0;
  CommentState = 1;
  QuoteState = 2;
  ParamState = 3;
  CommentLineState=4;//AL2011
  ParamDefaultState = 0;
  ParamQuoteState = 1;

  procedure AddToProcessedSQL(cChar: Char);
  begin
    sProcessedSQL[iSQLPos] := cChar;
    Inc(iSQLPos);
  end;

begin
  slNames := TStringList.Create;
  try
    { Do some initializations of variables }
    iParamSuffix := 0;
    cQuoteChar := '''';
    sSQL := FSQL.Text;
    MSQL:=UpperCase(sSQL);
    iLenSQL := Length(sSQL);
    SetString(sProcessedSQL, nil, iLenSQL + 1);
    i := 1;
    iSQLPos := 1;
    iCurState := DefaultState;
    iCurParamState := ParamDefaultState;
    Continuer:=true;
    IsExecBlock:=false;
    { Now, traverse through the SQL string, character by character,
     picking out the parameters and formatting correctly for InterBase }
    while (i <= iLenSQL) do begin
      { Get the current token and a look-ahead }
      cCurChar := sSQL[i];
      if i = iLenSQL then
        cNextChar := #0
      else
        cNextChar := sSQL[i + 1];
      { Now act based on the current state }
      case iCurState of
        DefaultState: begin
          s:=TrimRight(Copy(MSQL,i,8)); //AL2011
          if IsExecBlock then
          begin
            if (s='RETURNS') or (s='RETURNS(') then
            begin
              s:=Trim(string(MSQL[i-1]));
              if (s='')or(s=')') then
                Continuer:=false;
            end
            else
            begin
              s:=TrimRight(LeftStr(s,3));
              if s='AS' then
              begin
                s:=Trim(string(MSQL[i-1]));
                if (s='')or(s=')') then
                  Continuer:=false;
              end;
            end;
            if not Continuer then
              repeat
                AddToProcessedSQL(sSQL[i]);
                inc(i);
              until
                i>iLenSQL;
          end
          else
          begin
            if s='EXECUTE' then
            begin
              if (i=1)or(Trim(string(MSQL[i-1]))='')then
              begin
                s:=TrimRight(LeftStr(TrimLeft(copy(MSQL,i+8,MaxInt)),6));
                if (s='BLOCK') or (s='BLOCK(') then
                  IsExecBlock:=true;
              end;
            end;
          end;

          if Continuer then
          case cCurChar of
            '''', '"': begin
              cQuoteChar := cCurChar;
              iCurState := QuoteState;
            end;
            '?', ':': begin
              iCurState := ParamState;
              AddToProcessedSQL('?');
            end;
            '/': if (cNextChar = '*') then begin
              AddToProcessedSQL(cCurChar);
              Inc(i);
              iCurState := CommentState;
            end;
            '-': if (cNextChar = '-') then begin //AL2011
              AddToProcessedSQL(cCurChar);
              Inc(i);
              iCurState := CommentLineState;
            end;
          end;
        end;
        CommentState: begin
          if (cNextChar = #0) then
            IBError(ibxeSQLParseError, [SEOFInComment])
          else if (cCurChar = '*') then begin
            if (cNextChar = '/') then
              iCurState := DefaultState;
          end;
        end;
        CommentLineState: begin //AL2011
          if (cNextChar = #13) or (cNextChar = #10) or (cNextChar = #0) then
            iCurState := DefaultState;
        end;
        QuoteState: begin
          if cNextChar = #0 then
            IBError(ibxeSQLParseError, [SEOFInString])
          else if (cCurChar = cQuoteChar) then begin
            if (cNextChar = cQuoteChar) then begin
              AddToProcessedSQL(cCurChar);
              Inc(i);
            end else
              iCurState := DefaultState;
          end;
        end;
        ParamState:
        begin
          { collect the name of the parameter }
          if iCurParamState = ParamDefaultState then
          begin
            if cCurChar = '"' then
              iCurParamState := ParamQuoteState
            else if (cCurChar in ['A'..'Z', 'a'..'z', '0'..'9', '_', '$']) then
                sParamName := sParamName + cCurChar
            else if FGenerateParamNames then
            begin
              sParamName := 'IBXParam' + IntToStr(iParamSuffix); {do not localize}
              Inc(iParamSuffix);
              iCurState := DefaultState;
              slNames.Add(sParamName);
              sParamName := '';
            end
            else
              IBError(ibxeSQLParseError, [SParamNameExpected]);
          end
          else begin
            { determine if Quoted parameter name is finished }
            if cCurChar = '"' then
            begin
              Inc(i);
              slNames.Add(sParamName);
              SParamName := '';
              iCurParamState := ParamDefaultState;
              iCurState := DefaultState;
            end
            else
              sParamName := sParamName + cCurChar
          end;
          { determine if the unquoted parameter name is finished }
          if (iCurParamState <> ParamQuoteState) and
            (iCurState <> DefaultState) then
          begin
            if not (cNextChar in ['A'..'Z', 'a'..'z',
                                  '0'..'9', '_', '$']) then begin
              Inc(i);
              iCurState := DefaultState;
              slNames.Add(sParamName);
              sParamName := '';
            end;
          end;
        end;
      end;
      if Continuer //AL2011
        and (iCurState <> ParamState) then
        AddToProcessedSQL(sSQL[i]);
      Inc(i);
    end;
    AddToProcessedSQL(#0);
    FSQLParams.Count := slNames.Count;
    for i := 0 to slNames.Count - 1 do
      FSQLParams.AddName(slNames[i], i);
    FProcessedSQL.Text := sProcessedSQL;
  finally
    slNames.Free;
  end;
end;
