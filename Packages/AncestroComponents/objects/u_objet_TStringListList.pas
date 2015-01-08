unit u_objet_TStringlistList;

interface


uses
     Classes,
     graphics,lazutf8classes;



const

     MaxListSize = Maxint div 16;
     SListIndexError = 'Index hors borne !';
     SListCapacityError = 'Erreur de capacite !';
     SListCountError = 'Erreur de Count';


type

     PStringListArray = ^TStringlistArray;
     TStringlistArray = array[0..MaxListSize - 1] of TStringlistUTF8;


     PPointerList = ^TPointerList;
     TPointerList = array[0..MaxListSize - 1] of Pointer;

     TStringlistList = class(TObject)

     private
          FList: PStringListArray;
          FCount: Integer;
          FCapacity: Integer;
     protected
          function Get(Index: Integer): TStringlistUTF8;
          procedure Grow; virtual;
          procedure Put(Index: Integer; Item: TStringlistUTF8);
          procedure SetCapacity(NewCapacity: Integer);
          procedure SetCount(NewCount: Integer);
     public
          destructor Destroy; override;
          function Add(Item: TStringlistUTF8): Integer;
          procedure Clear;
          procedure Delete(Index: Integer);
          class procedure Error(const Msg: string; Data: Integer); virtual;
          procedure Exchange(Index1, Index2: Integer);
          function Expand: TStringlistList;
          function First: TStringlistUTF8;
          function IndexOf(Item: TStringlistUTF8): Integer;
          procedure Insert(Index: Integer; Item: TStringlistUTF8);
          function Last: TStringlistUTF8;
          procedure Move(CurIndex, NewIndex: Integer);
          function Remove(Item: TStringlistUTF8): Integer;
          property Capacity: Integer read FCapacity write SetCapacity;
          property Count: Integer read FCount write SetCount;
          property Items[Index: Integer]: TStringlistUTF8 read Get write Put; default;
          property List: PStringListArray read FList;
     end;


implementation

uses
     SysUtils,
     inifiles,
     u_objet_TRectangleElement,
     u_objet_TCircleElement,
     u_objet_TLineElement,
     u_objet_TTextElement;



destructor TStringlistList.Destroy;
begin
     Clear;

     inherited Destroy;
end;

function TStringlistList.Add(Item: TStringlistUTF8): Integer;
begin
     Result := FCount;
     if Result = FCapacity then Grow;
     FList^[Result] := Item;
     Inc(FCount);
end;

procedure TStringlistList.Clear;
var
     n: integer;
begin
     for n := Count downto 1 do
     begin
          try
               FList^[n - 1].Free;
          except
          end;
     end;

     SetCount(0);
     SetCapacity(0);
end;

procedure TStringlistList.Delete(Index: Integer);
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     Dec(FCount);
     if Index < FCount then
     begin
          FList^[index].Free;
          System.Move(FList^[Index + 1], FList^[Index], (FCount - Index) * SizeOf(Pointer));
     end;
end;

class procedure TStringlistList.Error(const Msg: string; Data: Integer);

begin
     raise EListError.CreateFmt(Msg, [Data]);
end;

procedure TStringlistList.Exchange(Index1, Index2: Integer);
var
     Item: TStringlistUTF8;
begin
     if (Index1 < 0) or (Index1 >= FCount) then Error(SListIndexError, Index1);
     if (Index2 < 0) or (Index2 >= FCount) then Error(SListIndexError, Index2);
     Item := FList^[Index1];
     FList^[Index1] := FList^[Index2];
     FList^[Index2] := Item;
end;

function TStringlistList.Expand: TStringlistList;
begin
     if FCount = FCapacity then Grow;
     Result := Self;
end;

function TStringlistList.First: TStringlistUTF8;
begin
     Result := Get(0);
end;

function TStringlistList.Get(Index: Integer): TStringlistUTF8;
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     Result := FList^[Index];
end;

procedure TStringlistList.Grow;
var
     Delta: Integer;
begin
     if FCapacity > 64 then Delta := FCapacity div 4 else
          if FCapacity > 8 then Delta := 16 else
          Delta := 4;
     SetCapacity(FCapacity + Delta);
end;

function TStringlistList.IndexOf(Item: TStringlistUTF8): Integer;
begin
     Result := 0;
     while (Result < FCount) and (FList^[Result] <> Item) do Inc(Result);
     if Result = FCount then Result := -1;
end;

procedure TStringlistList.Insert(Index: Integer; Item: TStringlistUTF8);
begin
     if (Index < 0) or (Index > FCount) then Error(SListIndexError, Index);
     if FCount = FCapacity then Grow;
     if Index < FCount then
          System.Move(FList^[Index], FList^[Index + 1],
               (FCount - Index) * SizeOf(Pointer));
     FList^[Index] := Item;
     Inc(FCount);
end;

function TStringlistList.Last: TStringlistUTF8;
begin
     Result := Get(FCount - 1);
end;

procedure TStringlistList.Move(CurIndex, NewIndex: Integer);
var
     Item: TStringlistUTF8;
begin
     if CurIndex <> NewIndex then
     begin
          if (NewIndex < 0) or (NewIndex >= FCount) then Error(SListIndexError, NewIndex);
          Item := Get(CurIndex);
          Delete(CurIndex);
          Insert(NewIndex, Item);
     end;
end;

procedure TStringlistList.Put(Index: Integer; Item: TStringlistUTF8);
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     FList^[Index] := Item;
end;

function TStringlistList.Remove(Item: TStringlistUTF8): Integer;
begin
     Result := IndexOf(Item);
     if Result <> -1 then Delete(Result);
end;


procedure TStringlistList.SetCapacity(NewCapacity: Integer);
begin
     if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
          Error(SListCapacityError, NewCapacity);
     if NewCapacity <> FCapacity then
     begin
          ReallocMem(FList, NewCapacity * SizeOf(Pointer));
          FCapacity := NewCapacity;
     end;
end;

procedure TStringlistList.SetCount(NewCount: Integer);
begin
     if (NewCount < 0) or (NewCount > MaxListSize) then
          Error(SListCountError, NewCount);
     if NewCount > FCapacity then SetCapacity(NewCount);
     if NewCount > FCount then
          FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0);
     FCount := NewCount;
end;




end.

