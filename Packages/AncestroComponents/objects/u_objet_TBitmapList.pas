unit u_objet_TBitmapList;

interface

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}



uses
        Classes,
        graphics;



const

        MaxListSize = Maxint div 16;
        SListIndexError = 'Index hors borne !';
        SListCapacityError = 'Erreur de capacite !';
        SListCountError = 'Erreur de Count';


Type

        PBitmapArray = ^TBitmapArray;
        TBitmapArray = array[0..MaxListSize - 1] of TBitmap;


        PPointerList = ^TPointerList;
        TPointerList = array[0..MaxListSize - 1] of Pointer;

        TBitmapList = class(TObject)

        private
                FList: PBitmapArray;
                FCount: Integer;
                FCapacity: Integer;
        protected
                function Get(Index: Integer): TBitmap;
                procedure Grow; virtual;
                procedure Put(Index: Integer; Item: TBitmap);
                procedure SetCapacity(NewCapacity: Integer);
                procedure SetCount(NewCount: Integer);
        public
                destructor Destroy; override;
                function Add(Item: TBitmap): Integer;
                procedure Clear;
                procedure Delete(Index: Integer);
                class procedure Error(const Msg: string; Data: Integer); virtual;
                procedure Exchange(Index1, Index2: Integer);
                function Expand: TBitmapList;
                function First: TBitmap;
                function IndexOf(Item: TBitmap): Integer;
                procedure Insert(Index: Integer; Item: TBitmap);
                function Last: TBitmap;
                procedure Move(CurIndex, NewIndex: Integer);
                function Remove(Item: TBitmap): Integer;
                property Capacity: Integer read FCapacity write SetCapacity;
                property Count: Integer read FCount write SetCount;
                property Items[Index: Integer]: TBitmap read Get write Put; default;
                property List: PBitmapArray read FList;
        end;


implementation



destructor TBitmapList.Destroy;
begin
        Clear;
end;

function TBitmapList.Add(Item: TBitmap): Integer;
begin
        Result := FCount;
        if Result = FCapacity then Grow;
        FList^[Result] := Item;
        Inc(FCount);
end;

procedure TBitmapList.Clear;
var
        n: integer;
begin
        for n := 1 to FCount do FList^[n - 1].Free;
        SetCount(0);
        SetCapacity(0);
end;

procedure TBitmapList.Delete(Index: Integer);
begin
        if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
        Dec(FCount);
        if Index < FCount then
                System.Move(FList^[Index + 1], FList^[Index],
                        (FCount - Index) * SizeOf(Pointer));
end;

class procedure TBitmapList.Error(const Msg: string; Data: Integer);


begin
        raise EListError.CreateFmt(Msg, [Data]);
end;

procedure TBitmapList.Exchange(Index1, Index2: Integer);
var
        Item: TBitmap;
begin
        if (Index1 < 0) or (Index1 >= FCount) then Error(SListIndexError, Index1);
        if (Index2 < 0) or (Index2 >= FCount) then Error(SListIndexError, Index2);
        Item := FList^[Index1];
        FList^[Index1] := FList^[Index2];
        FList^[Index2] := Item;
end;

function TBitmapList.Expand: TBitmapList;
begin
        if FCount = FCapacity then Grow;
        Result := Self;
end;

function TBitmapList.First: TBitmap;
begin
        Result := Get(0);
end;

function TBitmapList.Get(Index: Integer): TBitmap;
begin
        if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
        Result := FList^[Index];
end;

procedure TBitmapList.Grow;
var
        Delta: Integer;
begin
        if FCapacity > 64 then Delta := FCapacity div 4 else
                if FCapacity > 8 then Delta := 16 else
                Delta := 4;
        SetCapacity(FCapacity + Delta);
end;

function TBitmapList.IndexOf(Item: TBitmap): Integer;
begin
        Result := 0;
        while (Result < FCount) and (FList^[Result] <> Item) do Inc(Result);
        if Result = FCount then Result := -1;
end;

procedure TBitmapList.Insert(Index: Integer; Item: TBitmap);
begin
        if (Index < 0) or (Index > FCount) then Error(SListIndexError, Index);
        if FCount = FCapacity then Grow;
        if Index < FCount then
                System.Move(FList^[Index], FList^[Index + 1],
                        (FCount - Index) * SizeOf(Pointer));
        FList^[Index] := Item;
        Inc(FCount);
end;

function TBitmapList.Last: TBitmap;
begin
        Result := Get(FCount - 1);
end;

procedure TBitmapList.Move(CurIndex, NewIndex: Integer);
var
        Item: TBitmap;
begin
        if CurIndex <> NewIndex then
        begin
                if (NewIndex < 0) or (NewIndex >= FCount) then Error(SListIndexError, NewIndex);
                Item := Get(CurIndex);
                Delete(CurIndex);
                Insert(NewIndex, Item);
        end;
end;

procedure TBitmapList.Put(Index: Integer; Item: TBitmap);
begin
        if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
        FList^[Index] := Item;
end;

function TBitmapList.Remove(Item: TBitmap): Integer;
begin
        Result := IndexOf(Item);
        if Result <> -1 then Delete(Result);
end;


procedure TBitmapList.SetCapacity(NewCapacity: Integer);
begin
        if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
                Error(SListCapacityError, NewCapacity);
        if NewCapacity <> FCapacity then
        begin
                ReallocMem(FList, NewCapacity * SizeOf(Pointer));
                FCapacity := NewCapacity;
        end;
end;

procedure TBitmapList.SetCount(NewCount: Integer);
begin
        if (NewCount < 0) or (NewCount > MaxListSize) then
                Error(SListCountError, NewCount);
        if NewCount > FCapacity then SetCapacity(NewCount);
        if NewCount > FCount then
                FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0);
        FCount := NewCount;
end;




end.
