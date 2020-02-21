import 'dart:async';

import 'package:qrscanner/src/models/Scan.dart';
import 'package:qrscanner/src/providers/DBProvider.dart';

//Clase Singleton
class ScansBloc
{
  static final ScansBloc _singleton = new ScansBloc._internal();

  //Factory regresa ya sea una nueva instancia o una ya existente al estar en el constructor
  factory ScansBloc()
  {
    return _singleton;
  }

  ScansBloc._internal(){
    //Obtener Scans de la Base de datos al iniciar el constructor
    obtenerScans();
  }

  //Flujo de datos que emite (Stream)
  final _scansStreamController = StreamController<List<ScanModel>>.broadcast();

  //Especifica lo que escucha el stream
  Stream<List<ScanModel>> get scansStream => _scansStreamController.stream;

  dispose(){
    _scansStreamController?.close();
  }

  obtenerScans() async
  {
    //Coloca todos los elementos en el stream
    _scansStreamController.sink.add(await DBProvider.db.getTodosScans());
  }

  agregarScan(ScanModel scan) async
  {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async
  {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTodos() async
  {
    await DBProvider.db.deleteAll();
    _scansStreamController.sink.add([]);
  }

}