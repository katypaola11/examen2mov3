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
    msjerror(context, e.code);
  }
}

void msjerror(BuildContext context, String code) {
  String mensaje = '';

  if (code == 'user-not-found') {
    mensaje = 'No existe un usuario con ese correo';
  } else if (code == 'wrong-password') {
    mensaje = 'Contraseña incorrecta';
  } else if (code == 'invalid-email') {
    mensaje = 'Correo inválido';
  } else if (code == 'too-many-requests') {
    mensaje = 'Demasiados intentos, intenta más tarde';
  } else {
    mensaje = 'Error al iniciar sesión';
  }

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Error'),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
