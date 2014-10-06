var firstLetter="a";
var gName;
function arrangeNS6() {
  gName = '';
  whichEl=getNextIdNS6(firstInd.id);
  for ( i=0;i<document.images.count;i++)
    if ( document.images[i].src=="a.gif")
      {
      firstInd.style.top=document.images[i].offsetTop+document.images[i].offsetHeight;
      break;
      }
  nextY =firstInd.offsetTop + firstInd.offsetHeight;
  allHeights=nextY;
  while (whichEl!=null)
      {

        if (whichEl.style.visibility != "hidden") 
        	{
              whichEl.style.top = nextY;
              nextY+= whichEl.offsetHeight;
	      if ( allHeights < nextY ) 
	         allHeights = nextY ; 
            }
		whichEl=getNextIdNS6(whichEl.id);
      }
  arrangeBottom(allHeights);
  return nextY;
}

function getIndexNS6(el)
{
	return document.getElementById(el);
}
function getNextIdNS6(name)
{
	var alength = name.length;
	var nextName = '';
        nextName = name + firstLetter ;
	if (document.getElementById (nextName)!=null)
		{
		gName = nextName;
		return document.getElementById (nextName);
		}
	else
		{
		while (alength>0)
			{
			if (alength==1)
		    	 nextName = String.fromCharCode(gName.charCodeAt(0)+1);
		    else nextName = gName.substr(0,alength-1)+String.fromCharCode(gName.charCodeAt(alength-1)+1);

			if (document.getElementById(nextName)!=null)
				{ 
                                  gName = nextName;
				return document.getElementById(nextName);
				}
			alength--;
		    }
		}
	return null;
}
function expand_LevelsNS6( NoLevel )
  {
  whichEl=getNextIdNS6(firstInd.id);
  while (whichEl!=null)
          {
          if (whichEl.style.visibility=="")
          	whichEl.style.visibility="visible";
          if (whichEl.id.length > NoLevel )
             {
              if (whichEl.style.visibility == "visible")
                  {
                  whichEl.style.visibility = "hidden";
                  }
             }
          else
             {

             if (whichEl.style.visibility == "hidden")
                  {
                  whichEl.style.visibility = "visible";
                  }
             }
			whichEl=getNextIdNS6(whichEl.id);
          }
  arrangeNS6();
  }
function expand_AllNS6()
  {
  whichEl=getNextIdNS6(firstInd.id);
  while (whichEl!=null)
          {
          	whichEl.style.visibility="visible";
		adaptLevel ( whichEl.id );
		whichEl=getNextIdNS6(whichEl.id);
          }
  arrangeNS6();
  }

function showNS6(Name_Root)
  {
    which_El = getNextIdNS6(Name_Root);
	if (Name_Root.length + 1 == which_El.id.length)
		{
   		if (which_El.style.visibility == "hidden")
			{
         		which_El.style.visibility = "visible";
   			}
        }
  	else
        if ( Name_Root.length <= which_El.id.length )
           {
        		which_El.style.visibility = "hidden";
              	An_Image = document.images[which_El.id];
			  	if ( An_Image != undefined )
					{
					if ( An_Image.src.indexOf("-.gif") != -1 )
			                An_Image.src = "+.gif"
					else    An_Image.src = "p.gif";
					}
			}
  arrangeNS6();
  }

function showHideNS6(Name_Root)
  {
    var show=false;
    which_El = getNextIdNS6(Name_Root);
    while ((which_El!=null) && (Name_Root.length < which_El.id.length))
          {
	if (Name_Root.length + 1 == which_El.id.length)
		{
		   		if (which_El.style.visibility == "hidden")
					{
					show=true;
		         		which_El.style.visibility = "visible";
		   			}
		   		else
		   			{
	        		which_El.style.visibility = "hidden";
					}
        }
  	else
   		if (!show)
			{
	       		which_El.style.visibility = "hidden";
			}
	which_El=getNextIdNS6(which_El.id);
	}
  arrangeNS6();
  }
function expandNS6(Name_Root)
{
        Root_Image = document.images[Name_Root];
        if (Root_Image != undefined)
        {
          if (Root_Image.src.indexOf("-.gif")>0)
                  {
                  Root_Image.src = "+.gif";
                  showHideNS6(Name_Root);
                  }
          else if (Root_Image.src.indexOf("p.gif")>0)
                  {
                  Root_Image.src = "m.gif";
                  showHideNS6(Name_Root);
                  }
          else if (Root_Image.src.indexOf("m.gif")>0)
                  {
                  Root_Image.src = "p.gif";
                  showHideNS6(Name_Root);
                  }
          else
                  {
                  Root_Image.src = "-.gif";
                  showHideNS6(Name_Root);
                  }
        }

        arrangeNS6();
}

function showAllNS6()
{
        for (o=firstInd; o<document.getElementById.alength; o++) {
                document.getElementById[o].style.visibility = "visible";
        }
}

function expand_ShowNS6(which_Name)
{
	whichEl=getNextIdNS6(which_Name);
	while (whichEl!=null)
        {
		if (which_name.length <= whichEl.id.length )
			{
             if ( which_name.length == whichEl.id.length )
           		whichEl.style.visibility = "visible";
			 if ( document.images[which_Name] != undefined )
				{
				if ( document.images[which_Name].src.indexOf("-.gif") != -1 )
			                document.images[which_Name].src = "+.gif"
				else
			                document.images[which_Name].src = "p.gif";
				}
			}
		else break;
		whichEl=getNextIdNS6(whichEl.id);
		}
	arrangeNS6();
}
