{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania LGPL                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Matthieu Giroux (LAZARUS), André Langlet (2003 to 2013),    }
{           Philippe Cazaux-Moutou (Old Ancestro GPL)                   }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Description:                                                }
{                                                                       }
{-----------------------------------------------------------------------}
{                                                                       }
{           Revision History                                            }
{AL 2009 création nouvelles variables date, suppression _LastPosMiniature}
{-----------------------------------------------------------------------}

unit u_common_treeind;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
  VirtualTrees;


type
  TNodeIndividu=record
    fSexe,
    fOrdre,
    fOrdre2,
    fImageIndex,
    fCleFiche,
    fClefUnion:integer;
    fSosa:Double;//André 17/12/07 était Int64 (limité à 63 générations)
    FHasSosa:Boolean;
    fCaption,
    fNomComplet,
    fDateNaissanceDeces,
    fDateDeces,
    fNom,
    fHint:string;
  end;
  PNodeIndividu=^TNodeIndividu;


procedure TreeSelectNode(const ATree : TBaseVirtualTree; const ANode: PVirtualNode; const ACleFiche:integer);
procedure TreeFindNode(const ATree : TBaseVirtualTree; const ANode: PVirtualNode; const ACleFiche:integer;var FoundNode:PVirtualNode);
function TreeNodeIsPresent ( const ATree : TBaseVirtualTree; const iclefiche : Integer):Boolean;


implementation


function TreeNodeIsPresent ( const ATree : TBaseVirtualTree; const iclefiche : Integer):Boolean;
var
  LNode:PVirtualNode;
Begin
  LNode:=nil;
  TreeFindNode(ATree,ATree.RootNode,iclefiche,LNode);
  Result:=LNode <> nil;
end;



procedure TreeSelectNode(const ATree : TBaseVirtualTree; const ANode: PVirtualNode; const ACleFiche:integer);
var
  LNode:PVirtualNode;
begin
  LNode:=nil;
  TreeFindNode(ATree,ATree.RootNode,ACleFiche,LNode);
  with ATree do
  if LNode <> nil Then
   Begin
     FocusedNode:=LNode;
   end;
end;

procedure TreeFindNode(const ATree : TBaseVirtualTree; const ANode: PVirtualNode; const ACleFiche:integer;var FoundNode:PVirtualNode);
var
  LNode:PVirtualNode;
begin
  if ( ANode = nil )
  or ( ANode = ATree.RootNode ) Then
   Exit;
  with ATree,PNodeIndividu(GetNodeData(ANode))^ do
  if fCleFiche=ACleFiche Then
    Begin
      FoundNode := Anode;
      Exit;
    end;
  if FoundNode <> nil Then Exit;
  LNode:=ANode^.FirstChild;
  while LNode<>nil do
    Begin
      TreeFindNode(ATree,LNode,ACleFiche,FoundNode);
      LNode:=LNode.NextSibling;
    end;
end;

end.

