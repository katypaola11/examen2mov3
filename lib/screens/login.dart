import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: formulario(context),
    );
  }
}

Widget formulario(context) {
  TextEditingController correo = TextEditingController();
  TextEditingController contrasenia = TextEditingController();

  return Container(
    height: 200,
    color: const Color.fromARGB(255, 100, 123, 255),
    child: Column(
      children: [
        TextField(
          controller: correo,
          decoration: InputDecoration(
            hintText: "Ingresar Correo",
          ),
        ),
        TextField(
          controller: contrasenia,
          decoration: InputDecoration(
            hintText: "Contraseña",
          ),
        ),
        ElevatedButton(
          onPressed: () => login(correo, contrasenia, context),
          child: Text("Iniciar Sesion"),
        )
      ],
    ),
  );
}

Future<void> login(correo, contrasenia, context) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: correo.text,
      password: contrasenia.text,
    );

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
      } else {
        print("No hay usuario logeado");
      }
    });

    Navigator.pushNamed(context, '/guardar');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Error al iniciar Sesion"),
        );
      },
    );
  }
}
