function writeImage ( url, alt, height, id )
{
var tmp= new Image();

tmp.src=url;

// it never goes in the if part of the statement

if (tmp.complete)
	{
	tmp.height = height;
	tmp.title = alt;
	document.getElementById(id).appendChild(tmp);
	}
}
