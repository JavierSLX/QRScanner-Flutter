import 'package:flutter/material.dart';
import 'package:qrscanner/src/pages/HomePage.dart';
import 'package:qrscanner/src/pages/MapaPage.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Reader',
      initialRoute: "home", 
      routes: {
        "home": (BuildContext context) => HomePage(),
        "mapa": (BuildContext context) => MapaPage()
      },
      //Crea un tema para la aplicación y poder cambiar los colores de manera general
      theme: ThemeData(
        primaryColor: Colors.deepPurple
      ),
    );
  }
}