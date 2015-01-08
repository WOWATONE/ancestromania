
{*******************************************************}
{                                                       }
{       TBooleanList			                }
{                                                       }
{       Copyright (c) 1998,Yann UHEL                    }
{                                                       }
{*******************************************************}

unit u_objet_TBooleanList;

interface

uses
     Classes;


const

     MaxListSize = Maxint div 16;
     SListIndexError = 'Index hors borne !';
     SListCapacityError = 'Erreur de capacite !';
     SListCountError = 'Erreur de Count';


Type

     PBooleanArray = ^TBooleanArray;
     TBooleanArray = array[0..MaxListSize - 1] of Boolean;


	PPointerList = ^TPointerList;
	TPointerList = array[0..MaxListSize - 1] of Pointer;

	TBooleanList = class(TObject)

	private
		FList: PBooleanArray;
		FCount: Integer;
		FCapacity: Integer;
	protected
		function Get(Index: Integer): Boolean;
		procedure Grow; virtual;
		procedure Put(Index: Integer; Item: Boolean);
		procedure SetCapacity(NewCapacity: Integer);
		procedure SetCount(NewCount: Integer);
	public
		destructor Destroy; override;
		function Add(Item: Boolean): Integer;
		procedure Clear;
		procedure Delete(Index: Integer);
		class procedure Error(const Msg: string; Data: Integer); virtual;
		procedure Exchange(Index1, Index2: Integer);
		function Expand: TBooleanList;
		function First: Boolean;
	  //	function IndexOf(Item: Boolean): Integer;
		procedure Insert(Index: Integer; Item: Boolean);
		function Last: Boolean;
		procedure Move(CurIndex, NewIndex: Integer);
	   //	function Remove(Item: Boolean): Integer;
		procedure Sort;
		procedure DeleteDoublons;
          procedure assign(source: TBooleanList);
          property Capacity: Integer read FCapacity write SetCapacity;
		property Count: Integer read FCount write SetCount;
          property Items[Index: Integer]: Boolean read Get write Put; default;
          property List: PBooleanArray read FList;


     end;


implementation

{
uses
	u_routine;
}

destructor TBooleanList.Destroy;
begin
     Clear;
end;

function TBooleanList.Add(Item: Boolean): Integer;
begin
     Result := FCount;
     if Result = FCapacity then Grow;
     FList^[Result] := Item;
     Inc(FCount);
end;

procedure TBooleanList.Clear;
begin
     SetCount(0);
     SetCapacity(0);
end;

procedure TBooleanList.Delete(Index: Integer);
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     Dec(FCount);
     if Index < FCount then
          System.Move(FList^[Index + 1], FList^[Index],
               (FCount - Index) * SizeOf(Pointer));
end;

class procedure TBooleanList.Error(const Msg: string; Data: Integer);

begin
     raise EListError.CreateFmt(Msg, [Data]);
end;

procedure TBooleanList.Exchange(Index1, Index2: Integer);
var
     Item: Boolean;
begin
     if (Index1 < 0) or (Index1 >= FCount) then Error(SListIndexError, Index1);
     if (Index2 < 0) or (Index2 >= FCount) then Error(SListIndexError, Index2);
     Item := FList^[Index1];
     FList^[Index1] := FList^[Index2];
     FList^[Index2] := Item;
end;

function TBooleanList.Expand: TBooleanList;
begin
     if FCount = FCapacity then Grow;
     Result := Self;
end;

function TBooleanList.First: Boolean;
begin
     Result := Get(0);
end;

function TBooleanList.Get(Index: Integer): Boolean;
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     Result := FList^[Index];
end;

procedure TBooleanList.Grow;
var
     Delta: Integer;
begin
     if FCapacity > 64 then Delta := FCapacity div 4 else
          if FCapacity > 8 then Delta := 16 else
          Delta := 4;
     SetCapacity(FCapacity + Delta);
end;

{
function TBooleanList.IndexOf(Item: Boolean): Integer;
begin
	Result := 0;
	while (Result < FCount) and (not FloatIsEqual(FList^[Result], Item)) do Inc(Result);
	if Result = FCount then Result := -1;
end;

}
procedure TBooleanList.Insert(Index: Integer; Item: Boolean);
begin
     if (Index < 0) or (Index > FCount) then Error(SListIndexError, Index);
     if FCount = FCapacity then Grow;
     if Index < FCount then
          System.Move(FList^[Index], FList^[Index + 1],
               (FCount - Index) * SizeOf(Pointer));
     FList^[Index] := Item;
     Inc(FCount);
end;

function TBooleanList.Last: Boolean;
begin
     Result := Get(FCount - 1);
end;

procedure TBooleanList.Move(CurIndex, NewIndex: Integer);
var
     Item: Boolean;
begin
     if CurIndex <> NewIndex then
     begin
          if (NewIndex < 0) or (NewIndex >= FCount) then Error(SListIndexError, NewIndex);
          Item := Get(CurIndex);
          Delete(CurIndex);
          Insert(NewIndex, Item);
     end;
end;

procedure TBooleanList.Put(Index: Integer; Item: Boolean);
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     FList^[Index] := Item;
end;

{
function TBooleanList.Remove(Item: Boolean): Integer;
begin
	Result := IndexOf(Item);
	if Result <> -1 then Delete(Result);
end;
 }

procedure TBooleanList.SetCapacity(NewCapacity: Integer);
begin
     if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
          Error(SListCapacityError, NewCapacity);
     if NewCapacity <> FCapacity then
     begin
          ReallocMem(FList, NewCapacity * SizeOf(Pointer));
          FCapacity := NewCapacity;
     end;
end;

procedure TBooleanList.SetCount(NewCount: Integer);
begin
     if (NewCount < 0) or (NewCount > MaxListSize) then
          Error(SListCountError, NewCount);
     if NewCount > FCapacity then SetCapacity(NewCount);
     if NewCount > FCount then
          FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0);
     FCount := NewCount;
end;


procedure TBooleanList.Sort;
var
     n: integer;
     temp: Boolean;
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



procedure TBooleanList.DeleteDoublons;
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


procedure TBooleanList.assign(source: TBooleanList);
var
     n: integer;
begin
     Clear;
     for n := 1 to source.Count do add(source[n - 1]);
end;


end.

