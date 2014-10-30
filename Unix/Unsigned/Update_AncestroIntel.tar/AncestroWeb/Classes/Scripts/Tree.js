Level=1;

var bV   = parseInt(navigator.appVersion);
var NS4  = (document.layers)         ? true : false;
var IE4  = ((document.all)&&(bV>=4)) ? true : false;
var NS6	 = (!IE4 && !NS4) ? true : false;
var ver4 = (NS4 || IE4)              ? true : false;

function arrangeNetscape(indice)
	{
	if (NS4)
		{
		firstInd=getIndexNS(indice);
		showAll();
		bottomAlign = arrange();
		}
	else if (NS6)
		{
		firstInd=getIndexNS6(indice);
		showAllNS6();
		bottomAlign = arrangeNS6();
		}
	}
function arrangeBottomNetscape(indice,nextY)
	{
        var whichEl = null;
	if (NS4)
		{
                whichEl = document.layers[indice];
                whichEl.pageY = nextY;
		}
	else if (NS6)
		{
                whichEl = document.getElementById (indice);
                whichEl.style.top = nextY;
		}
	}
function expandToLevel()
	{

        if (NS4) expand_Levels (Level)
        else if (IE4) Show_Nodes(Level)
        else if (NS6) expand_LevelsNS6(Level);
	}
function Change_Levels(Type)
	{
	if (Type=="-")
		{
		Level--;
		}
	else
		{
		Level++;
		}
	if (Level==0)
		{
		Level=1;
		}
        expandToLevel();
	}
function refresh()
{
    window.location.reload( false );
}
function adaptLevel ( whichElID )
{
if (whichElID.length > Level )
	Level = whichElID.length;
}

function b(Name_Root)
	{
	if (NS4) expandNS(Name_Root)
    else if (IE4)     expandIE(Name_Root)
	else if (NS6) expandNS6(Name_Root);
	}

function expandRoot()
{
	Level=1;
	expandToLevel();
        if (NS4)
		{
    	         scrollTo(0,document.layers[firstInd].pageY);
        	}
}
function expandAll()
        {
        if (NS4)
		{
	         expand_AllLevels();
		 scrollTo(0,document.layers[firstInd].pageY);
        	}
        else if (IE4) 
        	{
               Show_AllNodes();
            }
        else if (NS6) 
        	{
         	expand_AllNS6();
            }
}

with (document)
  {
        write("<STYLE TYPE='text/css'>");
        if (NS4) {
                write("div      {position:absolute; visibility:visible}");
                write("img,span,a,br    {border:0;vertical-align: top}");
        }
        else if (IE4){
                write("div      {position:relative;display:block}");
                write("img      {vertical-align: top;border:0}");
        }
        else {
                write("div      {position:absolute; visibility:visible}");
                write("img,span,a,br    {vertical-align: top}");
        }
        write("</STYLE>");
  }


