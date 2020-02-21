
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrscanner/src/bloc/ScansBloc.dart';
import 'package:qrscanner/src/models/Scan.dart';
import 'package:qrscanner/src/pages/DireccionesPage.dart';
import 'package:qrscanner/src/pages/MapasPage.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrscanner/src/utils/Utils.dart' as utils;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
        //Coloca un pequeño icono para borrar
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: (){
              //Borra todos los elementos y actualiza el stream
              scansBloc.borrarScanTodos();
            },
          )
        ],
      ),
      body: callPage(currentIndex),
      bottomNavigationBar: crearBottomNavigationBar(),
      //Coloca el el boton flotante en el centro
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        //Ejecuta la accion de la función
        onPressed: () => scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  scanQR(BuildContext context) async
  {
    //https://google.com
    //geo:40.7242,-74.0073
    
    String futureString = "https://google.com";
    /*try
    {
      futureString = await BarcodeScanner.scan();
    }catch(error)
    {
      futureString = error.toString();
    }*/


    if(futureString != null)
   {
     //Inserta a la db
     ScanModel scan = ScanModel(valor: futureString);

     //Agrega el elemento y lo manda al flujo del stream
     scansBloc.agregarScan(scan);

     //Inserta a la db
     //ScanModel scan2 = ScanModel(valor: "geo:40.7242,-74.0073");

     //Agrega el elemento y lo manda al flujo del stream
     //scansBloc.agregarScan(scan2);

     //En iOS espera un poco de tiempo para evitar un error con la lectura de la camara
    if(Platform.isIOS)
      Future.delayed(Duration(milliseconds: 750), () => utils.abrirScan(context, scan));

     //utils.abrirScan(scan);

   } 
  }

  //Páginas a mostrar dependiendo de la barra de navegación
  Widget callPage(int paginaActual)
  {
    switch(paginaActual)
    {
      case 0:
        return MapasPage();
        break;

      case 1:
        return DireccionesPage();
        break;

      default:
        return MapasPage();
    }
  }

  Widget crearBottomNavigationBar()
  {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      //Al dar click sobre un elemento
      onTap: (index){
        //Refresca la pagina mientras asigna el valor
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text("Mapas")
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text("Direcciones")
        ),
      ],
    );
  }
}