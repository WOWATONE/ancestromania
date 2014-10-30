function includeJS(incFile)
{
  document.write('<script type="text/javascript" src="'+ incFile+ '"></script>'); 
}

function getQuerystring(key, default_) {
  if (default_==null) default_="";
  key = key.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regex = new RegExp("[\\?&]"+key+"=([^&#]*)");
  var qs = regex.exec(window.location.href);
  if(qs == null) return default_; else return qs[1];
}