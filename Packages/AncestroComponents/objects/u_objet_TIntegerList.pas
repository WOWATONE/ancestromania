//------------------------------------------------------------------------------
// Auteur : Yann UHEL - MKO pour SOLETANCHE-BACHY
// Date : 1998
//------------------------------------------------------------------------------


{*******************************************************}
{                                                       }
{       TIntegerList			                }
{                                                       }
{       Copyright (c) 1998,Yann UHEL                    }
{                                                       }
{*******************************************************}

unit u_objet_TIntegerList;

interface

uses
     Classes;


const

     MaxListSize = Maxint div 16;
     SListIndexError = 'Index hors borne !';
     SListCapacityError = 'Erreur de capacite !';
     SListCountError = 'Erreur de Count';


type

     PIntegerArray = ^TIntegerArray;
     TIntegerArray = array[0..MaxListSize - 1] of Integer;


     PPointerList = ^TPointerList;
     TPointerList = array[0..MaxListSize - 1] of Pointer;

     TIntegerList = class(TObject)

     private
          FList: PIntegerArray;
          FCount: Integer;
          FCapacity: Integer;

     protected
          function Get(Index: Integer): Integer;
          procedure Grow; virtual;
          procedure Put(Index: Integer; Item: Integer);
          procedure SetCapacity(NewCapacity: Integer);
          procedure SetCount(NewCount: Integer);
     public
          destructor Destroy; override;
          function Add(Item: Integer): Integer;
          procedure Clear;
          procedure Delete(Index: Integer);
          class procedure Error(const Msg: string; Data: Integer); virtual;
          procedure Exchange(Index1, Index2: Integer);
          function Expand: TIntegerList;
          function First: Integer;
          function IndexOf(Item: Integer): Integer;
          procedure Insert(Index: Integer; Item: Integer);
          function Last: Integer;
          procedure Move(CurIndex, NewIndex: Integer);
          function Remove(Item: Integer): Integer;
          procedure Sort;
          procedure DeleteDoublons;
          property Capacity: Integer read FCapacity write SetCapacity;
          property Count: Integer read FCount write SetCount;
          property Items[Index: Integer]: Integer read Get write Put; default;
          property List: PIntegerArray read FList;

          procedure assign(source: TintegerList);
     end;


implementation



destructor TIntegerList.Destroy;
begin
     Clear;
end;

function TIntegerList.Add(Item: Integer): Integer;
begin
     Result := FCount;
     if Result = FCapacity then Grow;
     FList^[Result] := Item;
     Inc(FCount);
end;

procedure TIntegerList.Clear;
begin
     SetCount(0);
     SetCapacity(0);
end;

procedure TIntegerList.Delete(Index: Integer);
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     Dec(FCount);
     if Index < FCount then
          System.Move(FList^[Index + 1], FList^[Index],
               (FCount - Index) * SizeOf(Pointer));
end;

class procedure TIntegerList.Error(const Msg: string; Data: Integer);

begin
     raise EListError.CreateFmt(Msg, [Data]);
end;

procedure TIntegerList.Exchange(Index1, Index2: Integer);
var
     Item: Integer;
begin
     if (Index1 < 0) or (Index1 >= FCount) then Error(SListIndexError, Index1);
     if (Index2 < 0) or (Index2 >= FCount) then Error(SListIndexError, Index2);
     Item := FList^[Index1];
     FList^[Index1] := FList^[Index2];
     FList^[Index2] := Item;
end;

function TIntegerList.Expand: TIntegerList;
begin
     if FCount = FCapacity then Grow;
     Result := Self;
end;

function TIntegerList.First: Integer;
begin
     Result := Get(0);
end;

function TIntegerList.Get(Index: Integer): Integer;
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     Result := FList^[Index];
end;

procedure TIntegerList.Grow;
var
     Delta: Integer;
begin
     if FCapacity > 64 then Delta := FCapacity div 4 else
          if FCapacity > 8 then Delta := 16 else
          Delta := 4;
     SetCapacity(FCapacity + Delta);
end;

function TIntegerList.IndexOf(Item: Integer): Integer;
begin
     Result := 0;
     while (Result < FCount) and (FList^[Result] <> Item) do Inc(Result);
     if Result = FCount then Result := -1;
end;

procedure TIntegerList.Insert(Index: Integer; Item: Integer);
begin
     if (Index < 0) or (Index > FCount) then Error(SListIndexError, Index);
     if FCount = FCapacity then Grow;
     if Index < FCount then
          System.Move(FList^[Index], FList^[Index + 1],
               (FCount - Index) * SizeOf(Pointer));
     FList^[Index] := Item;
     Inc(FCount);
end;

function TIntegerList.Last: Integer;
begin
     Result := Get(FCount - 1);
end;

procedure TIntegerList.Move(CurIndex, NewIndex: Integer);
var
     Item: Integer;
begin
     if CurIndex <> NewIndex then
     begin
          if (NewIndex < 0) or (NewIndex >= FCount) then Error(SListIndexError, NewIndex);
          Item := Get(CurIndex);
          Delete(CurIndex);
          Insert(NewIndex, Item);
     end;
end;

procedure TIntegerList.Put(Index: Integer; Item: Integer);
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     FList^[Index] := Item;
end;

function TIntegerList.Remove(Item: Integer): Integer;
begin
     Result := IndexOf(Item);
     if Result <> -1 then Delete(Result);
end;


procedure TIntegerList.SetCapacity(NewCapacity: Integer);
begin
     if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
          Error(SListCapacityError, NewCapacity);
     if NewCapacity <> FCapacity then
     begin
          ReallocMem(FList, NewCapacity * SizeOf(Pointer));
          FCapacity := NewCapacity;
     end;
end;

procedure TIntegerList.SetCount(NewCount: Integer);
begin
     if (NewCount < 0) or (NewCount > MaxListSize) then
          Error(SListCountError, NewCount);
     if NewCount > FCapacity then SetCapacity(NewCount);
     if NewCount > FCount then
          FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0);
     FCount := NewCount;
end;


procedure TIntegerList.Sort;
var
     n, temp: integer;
     ok: boolean;
begin
     if (FList <> nil) and (Count > 1) then
     begin
          repeat
               ok := true;
               for n := 1 to Count - 1 do
               begin
                    if FList^[n - 1] > FList^[n] then
                    begin
                         temp := FList^[n - 1];
                         FList^[n - 1] := FList^[n];
                         FList^[n] := temp;
                         ok := false;
                    end;
               end;
          until ok;
     end;
end;



procedure TintegerList.DeleteDoublons;
var
     n: integer;
begin
     if (FList <> nil) and (Count > 1) then
     begin
          for n := Count - 1 downto 1 do
          begin
               if FList^[n] = FList^[n - 1] then delete(n);
          end;
     end;
end;

procedure TintegerList.assign(source: TintegerList);
var
     n: integer;
begin
     Clear;
     for n := 1 to source.Count do add(source[n - 1]);
end;



end.

