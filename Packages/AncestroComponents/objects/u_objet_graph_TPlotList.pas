{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{           Ancestromania est un Logiciel Libre                         }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{           v#    ,Date       ,Author Name            ,Description      }
{                                                                       }
{-----------------------------------------------------------------------}

unit u_objet_graph_TPlotList;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes,
  u_objet_graph_TPlot;

const
  MaxListSize=Maxint div 16;
  SListIndexError='Index hors borne !';
  SListCapacityError='Erreur de capacite !';
  SListCountError='Erreur de Count';

type
  PPlotArray=^TPlotArray;
  TPlotArray=array[0..MaxListSize-1] of TPlot;

  PPointerList=^TPointerList;
  TPointerList=array[0..MaxListSize-1] of Pointer;

  TPlotList=class(TObject)

  private
    FList:PPlotArray;
    FCount:Integer;
    FCapacity:Integer;
  protected
    function Get(Index:Integer):TPlot;
    procedure Grow; virtual;
    procedure Put(Index:Integer;Item:TPlot);
    procedure SetCapacity(NewCapacity:Integer);
    procedure SetCount(NewCount:Integer);
  public
    destructor Destroy; override;
    function Add(Item:TPlot):Integer;
    procedure Clear;
    procedure Delete(Index:Integer);
    class procedure Error(const Msg:string;Data:Integer); virtual;
    procedure Exchange(Index1,Index2:Integer);
    function Expand:TPlotList;
    function First:TPlot;
    function IndexOf(Item:TPlot):Integer;
    procedure Insert(Index:Integer;Item:TPlot);
    function Last:TPlot;
    procedure Move(CurIndex,NewIndex:Integer);
    function Remove(Item:TPlot):Integer;
    property Capacity:Integer read FCapacity write SetCapacity;
    property Count:Integer read FCount write SetCount;
    property Items[Index:Integer]:TPlot read Get write Put;default;
    property List:PPlotArray read FList;
  end;

implementation

uses
  u_common_graph_const,
 // u_common_graph_var,
//  inifiles,
  SysUtils;

destructor TPlotList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TPlotList.Add(Item:TPlot):Integer;
begin
  Result:=FCount;
  if Result=FCapacity then Grow;
  FList^[Result]:=Item;
  Inc(FCount);
end;

procedure TPlotList.Clear;
var
  n:integer;
begin
  for n:=1 to FCount do
    FList^[n-1].Free;
  SetCount(0);
  SetCapacity(0);
end;

procedure TPlotList.Delete(Index:Integer);
begin
  if (Index>=0)or(Index<FCount) then
  begin
    Dec(FCount);
    FList^[Index].Free;

    if Index<FCount then
    begin
      System.Move(FList^[Index+1],FList^[Index],(FCount-Index)*SizeOf(Pointer));
    end;
  end;
end;

class procedure TPlotList.Error(const Msg:string;Data:Integer);

  {$IFNDEF CPU64}
  function ReturnAddr:Pointer;
  asm
          MOV     EAX,[EBP+4]
  end;
  {$ENDIF}
begin
  raise EListError.CreateFmt(Msg, [Data]){$IFNDEF CPU64}at ReturnAddr{$ENDIF};
end;

procedure TPlotList.Exchange(Index1,Index2:Integer);
var
  Item:TPlot;
begin
  if (Index1<0)or(Index1>=FCount) then Error(SListIndexError,Index1);
  if (Index2<0)or(Index2>=FCount) then Error(SListIndexError,Index2);
  Item:=FList^[Index1];
  FList^[Index1]:=FList^[Index2];
  FList^[Index2]:=Item;
end;

function TPlotList.Expand:TPlotList;
begin
  if FCount=FCapacity then Grow;
  Result:=Self;
end;

function TPlotList.First:TPlot;
begin
  if FCount=0 then
    result:=nil
  else
    Result:=Get(0);
end;

function TPlotList.Get(Index:Integer):TPlot;
begin
  if (Index<0)or(Index>=FCount) then Error(SListIndexError,Index);
  Result:=FList^[Index];
end;

procedure TPlotList.Grow;
var
  Delta:Integer;
begin
  if FCapacity>64 then
    Delta:=FCapacity div 4
  else if FCapacity>8 then
    Delta:=16
  else
    Delta:=4;
  SetCapacity(FCapacity+Delta);
end;

function TPlotList.IndexOf(Item:TPlot):Integer;
begin
  Result:=0;
  while (Result<FCount)and(FList^[Result]<>Item) do
    Inc(Result);
  if Result=FCount then Result:=-1;
end;

procedure TPlotList.Insert(Index:Integer;Item:TPlot);
begin
  if (Index<0)or(Index>FCount) then Error(SListIndexError,Index);
  if FCount=FCapacity then Grow;
  if Index<FCount then
    System.Move(FList^[Index],FList^[Index+1],
      (FCount-Index)*SizeOf(Pointer));
  FList^[Index]:=Item;
  Inc(FCount);
end;

function TPlotList.Last:TPlot;
begin
  if FCount=0 then
    result:=nil
  else
    Result:=Get(FCount-1);
end;

procedure TPlotList.Move(CurIndex,NewIndex:Integer);
var
  Item:TPlot;
begin
  if CurIndex<>NewIndex then
  begin
    if (NewIndex<0)or(NewIndex>=FCount) then Error(SListIndexError,NewIndex);
    Item:=Get(CurIndex);
    Delete(CurIndex);
    Insert(NewIndex,Item);
  end;
end;

procedure TPlotList.Put(Index:Integer;Item:TPlot);
begin
  if (Index<0)or(Index>=FCount) then Error(SListIndexError,Index);
  FList^[Index]:=Item;
end;

function TPlotList.Remove(Item:TPlot):Integer;
begin
  Result:=IndexOf(Item);
  if Result<>-1 then Delete(Result);
end;

procedure TPlotList.SetCapacity(NewCapacity:Integer);
begin
  if (NewCapacity<FCount)or(NewCapacity>MaxListSize) then
    Error(SListCapacityError,NewCapacity);
  if NewCapacity<>FCapacity then
  begin
    ReallocMem(FList,NewCapacity*SizeOf(Pointer));
    FCapacity:=NewCapacity;
  end;
end;

procedure TPlotList.SetCount(NewCount:Integer);
begin
  if (NewCount<0)or(NewCount>MaxListSize) then
    Error(SListCountError,NewCount);
  if NewCount>FCapacity then SetCapacity(NewCount);
  if NewCount>FCount then
    FillChar(FList^[FCount],(NewCount-FCount)*SizeOf(Pointer),0);
  FCount:=NewCount;
end;

end.

