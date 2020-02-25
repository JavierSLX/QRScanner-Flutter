import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrscanner/src/models/Scan.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  final map = new MapController();
  String tipoMapa = "streets";

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
            //Mueve el mapa de nuevo a donde se encontraba
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: crearFlutterMap(scan),
      floatingActionButton: crearBotonFlotante(context),
    );
  }

  Widget crearFlutterMap(ScanModel scan)
  {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        //El punto central del mapa
        center: scan.getLatLng(),
        zoom: 15
      ),
      //Las capas de informacion (en forma de pila)
      layers: [
        crearMapa(),
        crearMarcadores(scan),
      ],
    );
  }

  TileLayerOptions crearMapa()
  {
    return TileLayerOptions(
      urlTemplate: "https://api.mapbox.com/v4/"
      "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
      additionalOptions: {
        'accessToken': "pk.eyJ1IjoiamF2aWVyc2x4IiwiYSI6ImNrNnZvZzZ3cjAzem8zZ3FraGE4NzNsNXYifQ.FjGagkqw-aYRdSSQ4zGSdQ",
        "id": "mapbox.$tipoMapa" //streets, dark, light, outdoors, satellite 
      }
    );
  }

  crearMarcadores(ScanModel scan)
  {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100,
          height: 100,
          point: scan.getLatLng(),
          //Se dibuja el marcador
          builder: (BuildContext context){
            return Container(
              child: Icon(Icons.location_on, size: 45, color: Theme.of(context).primaryColor,),
            );
          }
        )
      ]
    );
  }

  crearBotonFlotante(BuildContext context)
  {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        //streets, dark, light, outdoors, satellite
        if(tipoMapa == "streets")
          tipoMapa = "dark";
        else if(tipoMapa == "dark")
          tipoMapa = "light";
        else if (tipoMapa == "light")
          tipoMapa = "outdoors";
        else if(tipoMapa == "outdoors")
          tipoMapa = "satellite";
        else
          tipoMapa = "streets";

        setState((){});
      },
    );
  }
}