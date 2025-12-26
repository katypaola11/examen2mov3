import 'dart:convert';

import 'package:flutter/material.dart';

class Listalocal extends StatelessWidget {
  const Listalocal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista Local")),
      body: Listar(context),
    );
  }
}

Future<List> leerLista(context) async {
  final jsonString = await DefaultAssetBundle.of(
    context,
  ).loadString("assets/data/depositosJ.json");

  return json.decode(jsonString);
}

Widget Listar(context) {
  return FutureBuilder(
    future: leerLista(context),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List data = snapshot.data!;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return ListTile(
              title: Text("Monto: ${item['monto'].toString()}"),
              subtitle: Text("Banco: ${item['banco']}"),
              leading: Image.network(
                item['detalles']['imagen_comprobante'],
                width: 50,
                height: 50,
              ),
              onTap: () => mostrar(context, item),
            );
            
          },
        );
      } else {
        return Text("No hay Texto");
      }
    },
  );
}

void mostrar(context, item) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Detalle del Depósito"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha: ${item['fecha']}"),
            Text("Nombre: ${item['origen']['nombre']}"),
            Text("Origen: ${item['origen']['número_cuenta']}"),
          ],
        ),
      );
    },
  );
}
