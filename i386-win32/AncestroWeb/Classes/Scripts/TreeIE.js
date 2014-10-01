function Search_DIV(Name_DIV)
	{
	Divisions = document.all.tags("DIV");
	for (the_div=0;the_div<Divisions.count;the_div++)
		{
		if (Divisions(the_div).name == Name_DIV)
			{
			return the_div;
			}
		}
	}

function getIndexIE(el)
{
        ind = null;
       	for (the_index=0; the_index<document.all.tags("DIV").length; the_index++)
            {
	      if (  (document.all.tags("DIV")(the_index).id != null)
		 && (document.all.tags("DIV")(the_index).id == el  ))
                  {
        	  ind = the_index;
                  break;
		  }
              }
        return ind;
}
function changeImage ( One_Image, source1,source2,dest1,dest2)
{
if (One_Image.src.indexOf(source1)>0)
	One_Image.src = dest1;
else if (One_Image.src.indexOf(source2)>0)
	One_Image.src = dest2;
}
function Show_Nodes(Level)
	{
         The_DIVS = document.all.tags("DIV");

	for (the_current=0;the_current<The_DIVS.length;the_current++)
		{
		One_DIV = The_DIVS[the_current];
                if (One_DIV.id.length<=Level)
                      {
                      One_DIV.style.display = "block";
                      }
                 else
                      {
                      One_DIV.style.display = "none";
                      }
		}
	The_Images = document.images;

	for (the_current=0;the_current<The_Images.length;the_current++)
		{
		One_Image = The_Images(the_current);
		if (One_Image.name!='')
		    if (One_Image.name.length<Level)
			{
			changeImage (One_Image,"p.gif","+.gif","m.gif","-.gif");
			}
		    else
			{
			changeImage (One_Image,"m.gif","-.gif","p.gif","+.gif");
			}
		}
	}
function Show_AllNodes()
	{
         The_DIVS = document.all.tags("DIV");

	for (the_current=0;the_current<The_DIVS.length;the_current++)
		{
		One_DIV = The_DIVS[the_current];
                One_DIV.style.display = "block";
		adaptLevel ( One_DIV.id );
		}
	The_Images = document.images;

	for (the_current=0;the_current<The_Images.length;the_current++)
		{
		One_Image = The_Images(the_current);
		if (One_Image.name!='')
			{
			changeImage (One_Image,"p.gif","+.gif","m.gif","-.gif");
			}
		}
	}

function Change_Display_Nodes(Name_Root,Display)
	{
	Divisions  = document.all.tags("DIV");
	The_Images = document.all.tags("IMG");

	for (the_display=getIndexIE(Name_Root)+1;the_display<document.all.tags("DIV").length;the_display++)
		{
		if (Divisions(the_display).id.length <= Name_Root.length)
			{
			break;
			}
		else
			if (Divisions(the_display).id.length == Name_Root.length+1)
                        {
				Divisions(the_display).style.display=Display;
                                }
			else
				Divisions(the_display).style.display="none";
		}
	An_Image_Name = document.images(Name_Root).name;

	for (the_display=0;the_display<The_Images.length;the_display++)
		{
		if (   (The_Images(the_display).name!='')
		    && (The_Images(the_display).name == Name_Root))
			{
                        No_Image=the_display+1;
			break;
			}
		}
	for (the_display=No_Image;the_display<The_Images.length;the_display++)
		{
		One_Image = The_Images(the_display);
		if (One_Image.id!='')
			{
			if (One_Image.id.length>Name_Root.length)
				{
				if (One_Image.src.indexOf("-.gif")>0)	One_Image.src = "+.gif";
				if (One_Image.src.indexOf("m.gif")>0)	One_Image.src = "p.gif";
				}
			if (One_Image.id.length<Name_Root.length)
				return true;
			}
		}
	}

function expandIE(Name_Root)
	{
	Root_Image = document.images(Name_Root);
        if (Root_Image != null)
          {
	  if (Root_Image.src.indexOf("-.gif")>0)
		{
		Change_Display_Nodes(Name_Root,"none");
		Root_Image.src = "+.gif";
		}
          else if (Root_Image.src.indexOf("p.gif")>0)
		{
		Change_Display_Nodes(Name_Root,"block");
		Root_Image.src = "m.gif";
		}
          else if (Root_Image.src.indexOf("m.gif")>0)
		{
		Change_Display_Nodes(Name_Root,"none");
		Root_Image.src = "p.gif";
		}
          else
		{
		Change_Display_Nodes(Name_Root,"block");
		Root_Image.src = "-.gif";
		}
          }
	}


function expand_Show_IE(which_Name)
	{
        div_Coll = document.all.tags("DIV");
        for (the_thing=getIndexIE(which_Name) + 1; the_thing<div_Coll.length; the_thing++)
	if (which_Name.length <= div_Coll(the_thing).id.length ) 
		{
                if ( which_Name.length == div_Coll(the_thing).id.length )
               		div_Coll(the_thing).style.display = "block";
		}
	else break;
	}
