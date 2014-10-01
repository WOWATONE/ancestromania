{-----------------------------------------------------------------------}
{                                                                       }
{           Subprogram Name:                                            }
{           Purpose:          Ancestromania                             }
{           Source Language:  Francais                                  }
{           Auteurs :                                                   }
{           Andr? Langlet (Main), Matthieu Giroux (LAZARUS),            }
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

unit u_common_graph_func;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

function norme(P1x,P1y,P2x,P2y:single{en m}):extended;//en m

procedure TrouvePoint(x1,y1,x2,y2,d:extended;var x,y:extended);
procedure TrouveCoords(xc,yc,x1,y1,x0,y0,x2,y2,decal_de_P0:extended;var xa,ya,xb,yb:extended);
function TrouveIntersectionCercleDroite(x1,y1,x2,y2,xc,yc,rayon:extended;var xa,ya,xb,yb:extended):boolean;
function LargeurPossibleTexte(x1,y1,x2,y2,xc,yc,rayon:extended;var d:extended):boolean;
procedure PointLePlusProcheDeP(x1,y1,x2,y2,x,y:extended;var xp,yp:extended);

implementation

function norme(P1x,P1y,P2x,P2y:single):extended;
begin
  //diagonale du rectangle
  result:=sqrt(sqr(P2x-P1x)+sqr(P2y-P1y));
end;

procedure TrouvePoint(x1,y1,x2,y2,d:extended;var x,y:extended);
var
  //coef de l'?quation de la droite (y=_a*x+_b)
  dx,dy:extended;
begin
  if x1<>x2 then
  begin
    dx:=(d*(x2-x1))/norme(x1,y1,x2,y2);
  end
  else
  begin
    dx:=0;
  end;

  if y1<>y2 then
  begin
    dy:=(d*(y2-y1))/norme(x1,y1,x2,y2);
  end
  else
  begin
    dy:=0;
  end;

  x:=x1+dx;
  y:=y1+dy;
end;

procedure TrouveCoords(xc,yc,x1,y1,x0,y0,x2,y2,decal_de_P0:extended;var xa,ya,xb,yb:extended);
var
  xi,yi:extended;
  a0:extended;
  ai,bi:extended;
  Di_vert:boolean;
  a1,b1:extended;
  D1_vert:boolean;
  a2,b2:extended;
  D2_vert:boolean;
begin
  a1:=0;
  a2:=0;
  b1:=0;
  b2:=0;
  //on cherche le point I
  TrouvePoint(x0,y0,xc,yc,decal_de_P0,xi,yi);

  //equation de (C,xiyi)
  if (x0<>xc) then
  begin
    if (y0<>yc) then
    begin
      a0:=(y0-yc)/(x0-xc);//m?me que pour (Cx0y0)
      ai:=-1/a0;
      bi:=yi-(ai*xi);
    end
    else
    begin
      ai:=0;
      bi:=yi;
    end;
  end
  else
  begin
    ai:=0;
    bi:=yi;
  end;

  Di_vert:=(yc=y0);

  //Droite passant par (C,x1y1)
  if x1<>xc then
  begin
    D1_vert:=false;
    a1:=(y1-yc)/(x1-xc);
    b1:=y1-(a1*x1);
  end
  else
  begin
    D1_vert:=true;
  end;

  //Droite passant par (C,x2y2)
  if x2<>xc then
  begin
    D2_vert:=false;
    a2:=(y2-yc)/(x2-xc);
    b2:=y2-(a2*x2);
  end
  else
  begin
    D2_vert:=true;
  end;

  //intersection de Di et (Cxy1)
  if (D1_vert=false)and(Di_vert=false) then
  begin
    if a1<>ai then
    begin
      xa:=(bi-b1)/(a1-ai);
      ya:=(a1*xa)+b1;
    end
    else
    begin
      xa:=x1;
      ya:=yi;
    end;
  end
  else if (D1_vert=false)and(Di_vert=true) then
  begin
    xa:=xi;
    ya:=(a1*xa)+b1;
  end
  else if (D1_vert=true)and(Di_vert=false) then
  begin
    xa:=x1;
    ya:=(ai*xa)+bi;
  end
  else if (D1_vert=true)and(Di_vert=true) then
  begin
    xa:=xi;
    ya:=y1;
  end;

  if (D2_vert=false)and(Di_vert=false) then
  begin
    if (a2<>ai) then
    begin
      xb:=(bi-b2)/(a2-ai);
      yb:=(a2*xb)+b2;
    end
    else
    begin
      xb:=x2;
      yb:=yi;
    end;
  end
  else if (D2_vert=false)and(Di_vert=true) then
  begin
    xb:=xi;
    yb:=(a2*xb)+b2;
  end
  else if (D2_vert=true)and(Di_vert=false) then
  begin
    xb:=x2;
    yb:=(ai*xb)+bi;
  end
  else if (D2_vert=true)and(Di_vert=true) then
  begin
    //impossible
    xb:=xi;
    yb:=y2;
  end;

end;

function TrouveIntersectionCercleDroite(x1,y1,x2,y2,xc,yc,rayon:extended;var xa,ya,xb,yb:extended):boolean;
var
  a,b:extended;
  GA,GB,GC,delta:extended;
begin
  result:=false;
  try
    if (x1<>x2) then
    begin
      a:=(y1-y2)/(x1-x2);
      b:=y1-(a*x1);

      GA:=1+(a*a);
      GB:=(-2*xc)+(2*a*b)-(2*yc*a);
      GC:=(xc*xc)+(yc*yc)-(rayon*rayon)-(2*yc*b)+(b*b);
    end
    else
    begin
      a:=x1;
      b:=0;

      GA:=1;
      GB:=-2*yc;
      GC:=(a*a)+(xc*xc)+(yc*yc)-(rayon*rayon)-(2*a*xc);
    end;

    delta:=(GB*GB)-(4*GA*GC);

    if delta>=0 then
    begin
      if delta=0 then
      begin
        if (x1<>x2) then
        begin
          xa:=-GB/(2*GA);
          ya:=(a*xa)+b;

          xb:=xa;
          yb:=ya;
        end
        else
        begin
          ya:=-GB/(2*GA);
          xa:=x1;

          yb:=xa;
          xb:=x1;

        end;
      end
      else
      begin
        if (x1<>x2) then
        begin
          xa:=(-GB+sqrt(delta))/(2*GA);
          ya:=(a*xa)+b;

          xb:=(-GB-sqrt(delta))/(2*GA);
          yb:=(a*xb)+b;
        end
        else
        begin
          ya:=(-GB+sqrt(delta))/(2*GA);
          xa:=x1;

          yb:=(-GB-sqrt(delta))/(2*GA);
          xb:=x1;
        end;
      end;

      result:=true;
    end;
  except
  end;
end;

function LargeurPossibleTexte(x1,y1,x2,y2,xc,yc,rayon:extended;var d:extended):boolean;
var
  xa,ya,xb,yb:extended;
begin
  result:=TrouveIntersectionCercleDroite(x1,y1,x2,y2,xc,yc,rayon,xa,ya,xb,yb);
  if result then d:=norme(xa,ya,xb,yb);
end;

procedure PointLePlusProcheDeP(x1,y1,x2,y2,x,y:extended;var xp,yp:extended);
var
  n1,n2:extended;
begin
  n1:=norme(x1,y1,x,y);
  n2:=norme(x2,y2,x,y);
  if n1<n2 then
  begin
    xp:=x1;
    yp:=y1;
  end
  else
  begin
    xp:=x2;
    yp:=y2;
  end;
end;

end.

