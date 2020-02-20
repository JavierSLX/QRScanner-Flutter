import 'package:flutter/material.dart';
import 'package:qrscanner/src/models/Scan.dart';
import 'package:qrscanner/src/providers/DBProvider.dart';

class MapasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScanModel>>(
      future: DBProvider.db.getTodosScans(),
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot){
        if(!snapshot.hasData)
          return Center(child: CircularProgressIndicator(),);
        
        final scans = snapshot.data;
        if(scans.length == 0)
          return Center(child: Text("No hay información"),);

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
            leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor,),
            title: Text(scans[index].valor),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
          )
        );
      },
    );
  }
}