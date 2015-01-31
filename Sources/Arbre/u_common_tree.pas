unit u_common_tree;

{$mode delphi}

interface

uses
  VirtualTrees;

type
  TIndivTree=record
    cle:integer;
    Niveau:Smallint;
    Sosa:Int64;
    Implexe:Integer;
    Enfants:Integer;
    Ordre:Integer;
    Sexe : Integer;
    libelle : String;
    famille : String;
  end;
  PIndivTree=^TIndivTree;



procedure p_FindNodeWithKey ( const ATree : TBaseVirtualTree; const ANode : PVirtualNode; const acle : Integer ; var FoundNode : PVirtualNode );

implementation

procedure p_FindNodeWithKey ( const ATree : TBaseVirtualTree; const ANode : PVirtualNode; const acle : Integer ; var FoundNode : PVirtualNode );
var AData : PIndivTree;
Begin
  with ATree,ANode^ do
   Begin
    if ANode <> RootNode Then
      Begin
       AData:=GetNodeData(ANode);
       if AData^.cle = acle Then
         FoundNode:=ANode;
       if FoundNode   <> nil Then Exit;
       if NextSibling <> nil Then p_FindNodeWithKey(ATree,NextSibling,acle,FoundNode);
      end;
    if FoundNode   <> nil Then Exit;
    if FirstChild  <> nil Then p_FindNodeWithKey(ATree,FirstChild ,acle,FoundNode);
   end;
End;


end.

