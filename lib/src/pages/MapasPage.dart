import 'package:flutter/material.dart';
import 'package:qrscanner/src/bloc/ScansBloc.dart';
import 'package:qrscanner/src/models/Scan.dart';
import 'package:qrscanner/src/utils/Utils.dart';

class MapasPage extends StatelessWidget {

  //Obtenemos el flujo del stream
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    //Obtiene el stream de los scans
    scansBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot){
        if(!snapshot.hasData)
          return Center(child: CircularProgressIndicator(),);
        
        final scans = snapshot.data;
        if(scans.length == 0)
          return Center(child: Text("No hay información"),);

        return ListView.builder(
          itemCount: scans.length,
          //El dismissible permite deslizar un elemento ya sea a la izquierda o la derecha para realizar un evento
          itemBuilder: (BuildContext context, int index) => Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
            ),
            //Evento cuando se deslice (Borra el elemento de la db y actualiza el stream)
            onDismissed: (DismissDirection direction) => scansBloc.borrarScan(scans[index].id),
            child: ListTile(
              leading: Icon(Icons.map, color: Theme.of(context).primaryColor,),
              title: Text(scans[index].valor),
              subtitle: Text("ID: ${scans[index].id}"),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
              //Al presionar sobre el elemento lo abre con la informacion que contiene
              onTap: (){
                abrirScan(context, scans[index]);
              },
            ),
          ),
        );
      },
    );
  }
}