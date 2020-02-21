import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrscanner/src/models/Scan.dart';
import 'package:latlong/latlong.dart';

class MapaPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //Obtenemos el modelo por medio del argumento
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Coordenadas QR"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){},
          )
        ],
      ),
      body: crearFlutterMap(scan)
    );
  }

  //Crea el widget del mapa
  Widget crearFlutterMap(ScanModel scan)
  {
    return FlutterMap(
      options: MapOptions(
        //El punto central del mapa
        center: scan.getLatLng(),
        zoom: 10
      ),
      //Las capas de informacion
      layers: [
        crearMapa(),
      ],
    );
  }

  //Informacion para crear el mapa
  TileLayerOptions crearMapa()
  {
    return TileLayerOptions(
      urlTemplate: "https://api.mapbox.com/v4/"
      "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
      additionalOptions: {
        'accessToken': "pk.eyJ1IjoiamF2aWVyc2x4IiwiYSI6ImNrNnZvZzZ3cjAzem8zZ3FraGE4NzNsNXYifQ.FjGagkqw-aYRdSSQ4zGSdQ",
        "id": "mapbox.streets"
      }
    );
  }
}