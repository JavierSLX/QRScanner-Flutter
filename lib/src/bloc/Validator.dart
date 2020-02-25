

import 'dart:async';

import 'package:qrscanner/src/models/Scan.dart';

class Validators
{
  //El stream recibe cierta información y solo procesa la información que se le solicita (Entra una lista y sale una lista)
  final validarGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink){
      final geoScans = scans.where((s) => s.tipo == 'geo').toList();
      sink.add(geoScans);
    }
  );

  //El stream recibe cierta información y solo procesa la información que se le solicita (Entra una lista y sale una lista)
  final validarHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink){
      final httpScans = scans.where((s) => s.tipo == 'http').toList();
      sink.add(httpScans);
    }
  );
}