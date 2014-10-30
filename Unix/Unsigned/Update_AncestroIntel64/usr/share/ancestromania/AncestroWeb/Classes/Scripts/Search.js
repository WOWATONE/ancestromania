function callsearch(domain){
searchwords=document.getElementById("q").value.toLowerCase();
pos=searchwords.indexOf(' site:');
if ( pos < 0 )
	searchwords=searchwords+" site:"+domain;
document.getElementById("q").value=searchwords;
return true;
} 
