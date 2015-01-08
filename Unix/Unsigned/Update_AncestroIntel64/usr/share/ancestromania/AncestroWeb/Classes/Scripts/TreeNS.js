
function arrange() {
        nextY = document.layers[firstInd].pageY + document.layers[firstInd].document.height;
        for (i=firstInd+1; i<document.layers.length; i++) {
                whichEl = document.layers[i];
                if (whichEl.visibility != "hide") {
                        whichEl.pageY = nextY;
                        nextY += whichEl.document.height;
                }
        }
	if (nextY>0)
		arrangeBottom(nextY);
	return nextY;
}

function getIndexNS(el) {
	        ind = null;
        	for (j=0; j<document.layers.length; j++) {
	                if (document.layers[j].id == el) {
        	                ind = j;
                	        break;
		                }
	        }
	        return ind;
}

function showElement ( whichEl )
{
   if (whichEl.visibility == "hide")
     {
       whichEl.visibility = "show";
       An_Image = document.layers[k-1].document.images[document.layers[k-1].name];
       if ( An_Image != null )
        {
        if ( An_Image.src.indexOf("+.gif") != -1 ) An_Image.src = "-.gif"
        else if ( An_Image.src.indexOf("p.gif") != -1 ) An_Image.src = "m.gif";
        }
    }
}
function expand_Levels ( NoLevel )
  {
  for (k=firstInd; k<document.layers.length; k++)
          {
          whichEl = document.layers[k];
          if (whichEl.name.length > NoLevel )
             {
              if (whichEl.visibility == "show")
                  {
                  whichEl.visibility = "hide";
                  An_Image = document.layers[k-1].document.images[document.layers[k-1].name];
                  if ( An_Image != null )
                     {
                           if ( An_Image.src.indexOf("-.gif") != -1 ) An_Image.src = "+.gif"
                      else if ( An_Image.src.indexOf("m.gif") != -1 ) An_Image.src = "p.gif";
                      }
                  }
             }
          else
             {
		showElement ( whichEl );
             }

          }
  arrange();
  }

function expand_AllLevels ()
  {
  for (k=firstInd; k<document.layers.length; k++)
          {
          whichEl = document.layers[k];
          if (whichEl.visibility == "hide")
               {
               showElement ( whichEl );
	       adaptLevel ( whichEl.name );
               }

          }
  arrange();
  }

function showNS(Name_Root)
  {
	whichEl = document.layers[Name_Root] ;
  	for (l=getIndexNS(Name_Root)+1; l<document.layers.length;l++)
        {
        which_El = document.layers[i];
	if (Name_Root.length + 1 == which_El.name.length)
		{
        		if (which_El.visibility == "hide")
				{
                		which_El.visibility = "show";
        			}
                }
		  	else
	                if ( Name_Root.length >= which_El.name.length )
                          break;
                        else
                          if ( Name_Root.length <= which_El.name.length )
                          {
	       	        	which_El.visibility = "hide";
                           An_Image = document.layers[l-1].document.images[document.layers[l-1].name];
			  if ( An_Image != null )
				{
				if ( An_Image.src.indexOf("-.gif") != -1 )
			                An_Image.src = "+.gif"
				else    An_Image.src = "p.gif";
				}
			}
        }
  }

function hideNS(Name_Root)
  {
	whichEl = document.layers[Name_Root] ;
  	for (m=getIndexNS(Name_Root)+1; m<document.layers.length;m++)
        {
        which_El = document.layers[m];
	if (Name_Root.length < which_El.name.length)
		{
        		if (which_El.visibility == "show")
				{
                		which_El.visibility = "hide";
	                        if (Name_Root.length +1 == which_El.name.length) continue;
                           An_Image = document.layers[m-1].document.images[document.layers[m-1].name];
			  if ( An_Image != null )
				{
				if ( An_Image.src.indexOf("+.gif") != -1 )
			                An_Image.src = "-.gif"
				else    An_Image.src = "m.gif";
				}
        			}
                }
	  	else
	                if ( Name_Root.length >= which_El.name.length )
                          break;
        }
  }
function expandNS(Name_Root)
{
        Root_Image = document.layers[Name_Root].document.images[Name_Root];
        if (Root_Image != null)
        {
          if (Root_Image.src.indexOf("-.gif")>0)
                  {
                  Root_Image.src = "+.gif";
                  hideNS(Name_Root);
                  }
          else if (Root_Image.src.indexOf("p.gif")>0)
                  {
                  Root_Image.src = "m.gif";
                  showNS(Name_Root);
                  }
          else if (Root_Image.src.indexOf("m.gif")>0)
                  {
                  Root_Image.src = "p.gif";
                  hideNS(Name_Root);
                  }
          else
                  {
                  Root_Image.src = "-.gif";
                  showNS(Name_Root);
                  }
        }

        arrange();
}

function showAll() {
        for (o=firstInd; o<document.layers.length; o++) {
                document.layers[o].visibility = "show";
        }
}

function expand_Show_NS(which_Name)
	{
	for (n=getIndexNS(which_Name) + 1; n<document.layers.length;n++)
	if (which_Name.length <= document.layers[n].name.length )
		{
                if ( which_Name.length == document.layers[n].name.length )
               		document.layers[n].visibility = "show";
		if ( document.images[which_Name] != null )
			{
			if ( document.images[which_Name].src.indexOf("i_Explorer_T") != -1 )
		                document.images[which_Name].src = "+.gif"
			else
		                document.images[which_Name].src = "p.gif";
			}
		}
	else break;
	}
