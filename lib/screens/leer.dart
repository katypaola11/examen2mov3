import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeerDepositoScreen extends StatelessWidget {
  const LeerDepositoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis transferencias"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/deposito'),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: listaDepositos(),
    );
  }
}

// Leer transferencias desde Firebase
Future<List> leerDepositos() async {
  List transferencias = [];
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return transferencias;

  DatabaseReference ref = FirebaseDatabase.instance.ref('transferencias/${user.uid}');
  final snapshot = await ref.get();
  final data = snapshot.value;

  if (data != null) {
    Map mapTransferencias = data as Map;
    mapTransferencias.forEach((clave, value) {
      transferencias.add({
        "id": clave,
        "destinatario": value['destinatario'],
        "monto": value['monto'],
      });
    });
  }

  return transferencias;
}

// Widget que muestra la lista
Widget listaDepositos() {
  return FutureBuilder(
    future: leerDepositos(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List data = snapshot.data!;
        if (data.isEmpty) {
          return const Center(
            child: Text(
              "No hay transferencias registradas",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    item['id'],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                title: Text(
                  item['destinatario'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Monto: \$${item['monto']}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => eliminarDeposito(item['id']),
                ),
              ),
            );
          },
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

// Eliminar transferencia
Future<void> eliminarDeposito(String id) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  DatabaseReference ref = FirebaseDatabase.instance.ref("transferencias/${user.uid}/$id");
  await ref.remove();
}
