import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qrscanner/src/models/Scan.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Clase Singleton
class DBProvider
{
  static Database _database;
  static final DBProvider db = DBProvider._();

  //Constructor privado
  DBProvider._();

  //Getter de database
  Future<Database> get database async {
    if(_database != null)
      return _database;
    
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "ScansDB.db");

    //Crea la db
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {
        //Crea la tabla scans
        await db.execute("CREATE TABLE scans(id INTEGER PRIMARY KEY, tipo TEXT, valor TEXT)");
      }
    );
  }

  //Crear registros en la db
  Future<int> nuevoScanRaw(ScanModel nuevoScan) async{
    final db = await database;

    final result = await db.rawInsert("INSERT INTO scans(id, tipo, valor) VALUES (${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}')");

    return result;
  }

  //Inserta tambien en la db
  Future<int> nuevoScan(ScanModel nuevoScan) async
  {
    final db = await database;
    final result = await db.insert('scans', nuevoScan.toJson());

    return result;
  }

  //SELECT
  Future<ScanModel> getScanID(int id) async {
    final db = await database;
    final response = await db.query("scans", where: "id = ?", whereArgs: [id]);

    return response.isNotEmpty ? ScanModel.fromJson(response.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final response = await db.query('scans');

    List<ScanModel> list = response.isNotEmpty ? response.map((scan) => ScanModel.fromJson(scan)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final response = await db.rawQuery("SELECT * FROM scans WHERE tipo = $tipo");

    List<ScanModel> list = response.isNotEmpty ? response.map((scan) => ScanModel.fromJson(scan)).toList() : [];
    return list;
  }

  //Actualizar registros
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final response = await db.update("scans", nuevoScan.toJson(), where: "id = ?", whereArgs: [nuevoScan.id]);

    return response;
  }

  //Eliminar registros
  Future<int> deleteScan(int id) async {
    final db = await database;
    final response = await db.delete("scans", where: "id = ?", whereArgs: [id]);

    return response;
  }

  //Eliminar todos registros
  Future<int> deleteAll() async {
    final db = await database;
    final response = await db.rawDelete("DELETE FROM scans");

    return response;
  }
}