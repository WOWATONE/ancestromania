unit u_objet_TGraphicElementList;

interface


uses
     Classes,
     graphics,
     db,
     u_objet_TGraphicElement;



const

     MaxListSize = Maxint div 16;
     SListIndexError = 'Index hors borne !';
     SListCapacityError = 'Erreur de capacite !';
     SListCountError = 'Erreur de Count';


type

     PGraphicElementArray = ^TGraphicElementArray;
     TGraphicElementArray = array[0..MaxListSize - 1] of TGraphicElement;


     PPointerList = ^TPointerList;
     TPointerList = array[0..MaxListSize - 1] of Pointer;

     TGraphicElementList = class(TObject)

     private
          FList: PGraphicElementArray;
          FCount: Integer;
          FCapacity: Integer;
     protected
          function Get(Index: Integer): TGraphicElement;
          procedure Grow; virtual;
          procedure Put(Index: Integer; Item: TGraphicElement);
          procedure SetCapacity(NewCapacity: Integer);
          procedure SetCount(NewCount: Integer);
     public
          destructor Destroy; override;
          function Add(Item: TGraphicElement): Integer;
          procedure Clear;
          procedure Delete(Index: Integer);
          class procedure Error(const Msg: string; Data: Integer); virtual;
          procedure Exchange(Index1, Index2: Integer);
          function Expand: TGraphicElementList;
          function First: TGraphicElement;
          function IndexOf(Item: TGraphicElement): Integer;
          procedure Insert(Index: Integer; Item: TGraphicElement);
          function Last: TGraphicElement;
          procedure Move(CurIndex, NewIndex: Integer);
          function Remove(Item: TGraphicElement): Integer;
          property Capacity: Integer read FCapacity write SetCapacity;
          property Count: Integer read FCount write SetCount;
          property Items[Index: Integer]: TGraphicElement read Get write Put; default;
          property List: PGraphicElementArray read FList;

          function GetWherePointBelongTo(X, Y: integer): TGraphicElement;

          function SaveToIni(memoField: TMemoField; aText: TStrings): boolean;
          function LoadFromIni(memoField: TMemoField; aText: TStrings; aCanvas: TCanvas): boolean;
     end;


implementation

uses
     SysUtils,
     u_objet_TIniMem,
     u_objet_TRectangleElement,
     u_objet_TCircleElement,
     u_objet_TLineElement,
     FileUtil,lazutf8classes,
     u_objet_TTextElement;



destructor TGraphicElementList.Destroy;
begin
     Clear;

     inherited Destroy;
end;

function TGraphicElementList.Add(Item: TGraphicElement): Integer;
begin
     Result := FCount;
     if Result = FCapacity then Grow;
     FList^[Result] := Item;
     Inc(FCount);
end;

procedure TGraphicElementList.Clear;
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

procedure TGraphicElementList.Delete(Index: Integer);
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     Dec(FCount);
     if Index < FCount then
     begin
          FList^[index].Free;
          System.Move(FList^[Index + 1], FList^[Index], (FCount - Index) * SizeOf(Pointer));
     end;
end;

class procedure TGraphicElementList.Error(const Msg: string; Data: Integer);


begin
     raise EListError.CreateFmt(Msg, [Data]);
end;

procedure TGraphicElementList.Exchange(Index1, Index2: Integer);
var
     Item: TGraphicElement;
begin
     if (Index1 < 0) or (Index1 >= FCount) then Error(SListIndexError, Index1);
     if (Index2 < 0) or (Index2 >= FCount) then Error(SListIndexError, Index2);
     Item := FList^[Index1];
     FList^[Index1] := FList^[Index2];
     FList^[Index2] := Item;
end;

function TGraphicElementList.Expand: TGraphicElementList;
begin
     if FCount = FCapacity then Grow;
     Result := Self;
end;

function TGraphicElementList.First: TGraphicElement;
begin
     Result := Get(0);
end;

function TGraphicElementList.Get(Index: Integer): TGraphicElement;
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     Result := FList^[Index];
end;

procedure TGraphicElementList.Grow;
var
     Delta: Integer;
begin
     if FCapacity > 64 then Delta := FCapacity div 4 else
          if FCapacity > 8 then Delta := 16 else
          Delta := 4;
     SetCapacity(FCapacity + Delta);
end;

function TGraphicElementList.IndexOf(Item: TGraphicElement): Integer;
begin
     Result := 0;
     while (Result < FCount) and (FList^[Result] <> Item) do Inc(Result);
     if Result = FCount then Result := -1;
end;

procedure TGraphicElementList.Insert(Index: Integer; Item: TGraphicElement);
begin
     if (Index < 0) or (Index > FCount) then Error(SListIndexError, Index);
     if FCount = FCapacity then Grow;
     if Index < FCount then
          System.Move(FList^[Index], FList^[Index + 1],
               (FCount - Index) * SizeOf(Pointer));
     FList^[Index] := Item;
     Inc(FCount);
end;

function TGraphicElementList.Last: TGraphicElement;
begin
     Result := Get(FCount - 1);
end;

procedure TGraphicElementList.Move(CurIndex, NewIndex: Integer);
var
     Item: TGraphicElement;
begin
     if CurIndex <> NewIndex then
     begin
          if (NewIndex < 0) or (NewIndex >= FCount) then Error(SListIndexError, NewIndex);
          Item := Get(CurIndex);
          Delete(CurIndex);
          Insert(NewIndex, Item);
     end;
end;

procedure TGraphicElementList.Put(Index: Integer; Item: TGraphicElement);
begin
     if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
     FList^[Index] := Item;
end;

function TGraphicElementList.Remove(Item: TGraphicElement): Integer;
begin
     Result := IndexOf(Item);
     if Result <> -1 then Delete(Result);
end;


procedure TGraphicElementList.SetCapacity(NewCapacity: Integer);
begin
     if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
          Error(SListCapacityError, NewCapacity);
     if NewCapacity <> FCapacity then
     begin
          ReallocMem(FList, NewCapacity * SizeOf(Pointer));
          FCapacity := NewCapacity;
     end;
end;

procedure TGraphicElementList.SetCount(NewCount: Integer);
begin
     if (NewCount < 0) or (NewCount > MaxListSize) then
          Error(SListCountError, NewCount);
     if NewCount > FCapacity then SetCapacity(NewCount);
     if NewCount > FCount then
          FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0);
     FCount := NewCount;
end;




function TGraphicElementList.GetWherePointBelongTo(X, Y: integer): TGraphicElement;
var
     n: integer;
begin
     result := nil;

     for n := FCount downto 1 do
          if FList^[n - 1].PointBelongToElement(X, Y) then
          begin
               result := FList^[n - 1];
               break;
          end;
end;



function TGraphicElementList.SaveToIni(memoField: TMemoField; aText: TStrings): boolean;
var
     n: integer;
     fIni: TIniMem;
     LList: TStrings;
begin
     fIni := TIniMem.create;
     try
          //Tous les éléments
          fIni.WriteInteger('Elements', 'Nb', FCount);

          for n := 0 to FCount - 1 do
          begin
               FList^[n].SaveToIni(fIni, 'Elements', n);
          end;

          //Le texte qui accompagne l'image
          if assigned(aText) then
          begin
               fIni.WriteInteger('Memo', 'Nb', aText.Count);
               for n := 0 to aText.Count - 1 do
               begin
                    fIni.WriteString('Memo', 'Line' + inttostr(n), aText[n]);
               end;
          end;

          //On écrit le contenu du ini dans le memofield
          LList := TStringlistUTF8.create;
          try
               fIni.GetStrings(LList);
               if (FCount = 0) and (aText.Count = 0) then memoField.Clear
               else memoField.AsString := LList.Text;
          finally
               LList.Free;
          end;



     finally
          fIni.Free;
     end;

     result := true;
end;



function TGraphicElementList.LoadFromIni(memoField: TMemoField; aText: TStrings; aCanvas: TCanvas): boolean;
var
     n, k: integer;
     fIni: TIniMem;
     Item: TGraphicElement;
     s: string;
     LList: TStrings;
begin
     //On efface tout
     Clear;
     aText.Clear;

     fIni := TIniMem.create;
     try
          //remplissage du ini
          LList := TStringlistUTF8.create;
          try
               LList.Text := memoField.AsString;
               fIni.SetStrings(LList);
          finally
               LList.Free;
          end;



          //lecture du ini
          k := fIni.ReadInteger('Elements', 'Nb', 0);

          //Tous les éléments
          for n := 0 to k - 1 do
          begin
               s := fIni.ReadString('Elements', 'Type' + Inttostr(n), '');

               if s = 'rectangle' then
               begin
                    Item := TRectangleElement.create;
                    Item.Canvas := aCanvas;
                    Item.LoadFromIni(fIni, 'Elements', n);
                    Item.CalcHandsRect;
                    Add(Item);
               end
               else
                    if s = 'texte' then
               begin
                    Item := TTextElement.create;
                    Item.Canvas := aCanvas;
                    Item.LoadFromIni(fIni, 'Elements', n);
                    Item.CalcHandsRect;
                    Add(Item);
               end
               else
                    if s = 'ellipse' then
               begin
                    Item := TCircleElement.create;
                    Item.Canvas := aCanvas;
                    Item.LoadFromIni(fIni, 'Elements', n);
                    Item.CalcHandsRect;
                    Add(Item);
               end
               else
                    if s = 'line' then
               begin
                    Item := TLineElement.create;
                    Item.Canvas := aCanvas;
                    Item.LoadFromIni(fIni, 'Elements', n);
                    Item.CalcHandsRect;
                    Add(Item);
               end;
          end;

          //Le texte qui accompagne l'image
          if assigned(aText) then
          begin

               k := fIni.ReadInteger('Memo', 'Nb', 0);
               for n := 0 to k - 1 do
               begin
                    aText.Add(fIni.ReadString('Memo', 'Line' + inttostr(n), ''));
               end;
          end;



     finally
          fIni.Free;
     end;

     result := true;
end;

end.

