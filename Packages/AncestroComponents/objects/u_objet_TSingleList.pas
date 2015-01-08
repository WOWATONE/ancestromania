
{*******************************************************}
{                                                       }
{       TSingleList			                }
{                                                       }
{       Copyright (c) 1998,Yann UHEL                    }
{                                                       }
{*******************************************************}

unit u_objet_TSingleList;

interface

uses
     Classes;


const

     MaxListSize = Maxint div 16;
     SListIndexError = 'Index hors borne !';
     SListCapacityError = 'Erreur de capacite !';
     SListCountError = 'Erreur de Count';


Type

     PSingleArray = ^TSingleArray;
     TSingleArray = array[0..MaxListSize - 1] of Single;


     PPointerList = ^TPointerList;
	TPointerList = array[0..MaxListSize - 1] of Pointer;

	TSingleList = class(TObject)

	private
		FList: PSingleArray;
		FCount: Integer;
		FCapacity: Integer;
	protected
		function Get(Index: Integer): Single;
		procedure Grow; virtual;
		procedure Put(Index: Integer; Item: Single);
		procedure SetCapacity(NewCapacity: Integer);
		procedure SetCount(NewCount: Integer);
	public
		destructor Destroy; override;
		function Add(Item: Single): Integer;
		procedure Clear;
		procedure Delete(Index: Integer);
		class procedure Error(const Msg: string; Data: Integer); virtual;
		procedure Exchange(Index1, Index2: Integer);
		function Expand: TSingleList;
		function First: Single;
	  //	function IndexOf(Item: Single): Integer;
		procedure Insert(Index: Integer; Item: Single);
		function Last: Single;
		procedure Move(CurIndex, NewIndex: Integer);
	   //	function Remove(Item: Single): Integer;
		procedure Sort;
		procedure DeleteDoublons;
          procedure assign(source: TSingleList);
          property Capacity: Integer read FCapacity write SetCapacity;
		property Count: Integer read FCount write SetCount;
          property Items[Index: Integer]: Single read Get write Put; default;
          property List: PSingleArray read FList;


     end;


implementation

{
uses
	u_routine;
}

destructor TSingleList.Destroy;
begin
     Clear;
end;

function TSingleList.Add(Item: Single): Integer;
begin
     Result := FCount;
     if Result = FCapacity then Grow;
     FList^[Result] := Item;
     Inc(FCount);
end;

procedure TSingleList.Clear;
begin
     SetCount(0);
     SetCapacity(0);
end;

procedure TSingleList.Delete(Index: Integer);
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     Dec(FCount);
     if Index < FCount then
          System.Move(FList^[Index + 1], FList^[Index],
               (FCount - Index) * SizeOf(Pointer));
end;

class procedure TSingleList.Error(const Msg: string; Data: Integer);

begin
     raise EListError.CreateFmt(Msg, [Data]);
end;

procedure TSingleList.Exchange(Index1, Index2: Integer);
var
     Item: Single;
begin
     if (Index1 < 0) or (Index1 >= FCount) then Error(SListIndexError, Index1);
     if (Index2 < 0) or (Index2 >= FCount) then Error(SListIndexError, Index2);
     Item := FList^[Index1];
     FList^[Index1] := FList^[Index2];
     FList^[Index2] := Item;
end;

function TSingleList.Expand: TSingleList;
begin
     if FCount = FCapacity then Grow;
     Result := Self;
end;

function TSingleList.First: Single;
begin
     Result := Get(0);
end;

function TSingleList.Get(Index: Integer): Single;
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     Result := FList^[Index];
end;

procedure TSingleList.Grow;
var
     Delta: Integer;
begin
     if FCapacity > 64 then Delta := FCapacity div 4 else
          if FCapacity > 8 then Delta := 16 else
          Delta := 4;
     SetCapacity(FCapacity + Delta);
end;

{
function TSingleList.IndexOf(Item: Single): Integer;
begin
	Result := 0;
	while (Result < FCount) and (not FloatIsEqual(FList^[Result], Item)) do Inc(Result);
	if Result = FCount then Result := -1;
end;

}
procedure TSingleList.Insert(Index: Integer; Item: Single);
begin
     if (Index < 0) or (Index > FCount) then Error(SListIndexError, Index);
     if FCount = FCapacity then Grow;
     if Index < FCount then
          System.Move(FList^[Index], FList^[Index + 1],
               (FCount - Index) * SizeOf(Pointer));
     FList^[Index] := Item;
     Inc(FCount);
end;

function TSingleList.Last: Single;
begin
     Result := Get(FCount - 1);
end;

procedure TSingleList.Move(CurIndex, NewIndex: Integer);
var
     Item: Single;
begin
     if CurIndex <> NewIndex then
     begin
          if (NewIndex < 0) or (NewIndex >= FCount) then Error(SListIndexError, NewIndex);
          Item := Get(CurIndex);
          Delete(CurIndex);
          Insert(NewIndex, Item);
     end;
end;

procedure TSingleList.Put(Index: Integer; Item: Single);
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     FList^[Index] := Item;
end;

{
function TSingleList.Remove(Item: Single): Integer;
begin
	Result := IndexOf(Item);
	if Result <> -1 then Delete(Result);
end;
 }

procedure TSingleList.SetCapacity(NewCapacity: Integer);
begin
     if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
          Error(SListCapacityError, NewCapacity);
     if NewCapacity <> FCapacity then
     begin
          ReallocMem(FList, NewCapacity * SizeOf(Pointer));
          FCapacity := NewCapacity;
     end;
end;

procedure TSingleList.SetCount(NewCount: Integer);
begin
     if (NewCount < 0) or (NewCount > MaxListSize) then
          Error(SListCountError, NewCount);
     if NewCount > FCapacity then SetCapacity(NewCount);
     if NewCount > FCount then
          FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0);
     FCount := NewCount;
end;


procedure TSingleList.Sort;
var
     n: integer;
     temp: Single;
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



procedure TSingleList.DeleteDoublons;
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


procedure TSingleList.assign(source: TSingleList);
var
     n: integer;
begin
     Clear;
     for n := 1 to source.Count do add(source[n - 1]);
end;


end.
