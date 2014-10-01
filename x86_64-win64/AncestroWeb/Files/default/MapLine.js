
var marker[n] = new L.Marker(new L.LatLng([Latitud],[Longitud]), {icon: [Icon]});
map.addLayer(marker[n]);
marker[n].bindPopup('[NameOrCity]').openPopup();