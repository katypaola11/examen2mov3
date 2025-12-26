import 'package:firebase_database/firebase_database.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Guardarscreen extends StatelessWidget {
  const Guardarscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Realizar Transferencia"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: formulario(context),
    );
  }
}

Widget formulario(context) {
  TextEditingController idTransferencia = TextEditingController();
  TextEditingController destinatario = TextEditingController();
  TextEditingController monto = TextEditingController();

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),

          TextField(
            controller: idTransferencia,
            decoration: InputDecoration(
              label: const Text("ID de la transferencia"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.confirmation_number),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: destinatario,
            decoration: InputDecoration(
              label: const Text("Nombre del destinatario"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: monto,
            decoration: InputDecoration(
              label: const Text("Monto a transferir"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () => guardarTransferencia(
                idTransferencia.text,
                destinatario.text,
                monto.text,
                context,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Transferir",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> guardarTransferencia(
  String id,
  String destinatario,
  String monto,
  context,
) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  DatabaseReference ref =
      FirebaseDatabase.instance.ref("transferencias/${user.uid}/$id");

  await ref.set({
    "destinatario": destinatario,
    "monto": monto,
  });

  Navigator.pushNamed(context, '/leer');
}
