import 'dart:io'; // Para detectar si es Android o iOS
import 'package:flutter/foundation.dart'; // Para detectar si es web
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:direccion_general_flutter/View/home_screen2.dart';

class GoogleScreen extends StatelessWidget {
  const GoogleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _handleGoogleSignIn(context);
          },
          child: const Text('Sign In with Google'),
        ),
      ),
    );
  }

  // Función para manejar la autenticación con Google
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final user = await GoogleSignInApi.login();

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inicio de sesión exitoso, ${user.displayName}'),
        ),
      );
      // Redirige a HomeScreen si la autenticación es exitosa
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen2(user: user),
      ));
    } else {
      // Maneja el caso de error o cancelación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión cancelado')),
      );
    }
  }
}

class GoogleSignInApi {
  // Configura los client IDs para web y Android
  static final _serverClientIdweb =
      '930523576022-5ndtgbclull8usogrloj4qlfqusk8d8j.apps.googleusercontent.com';
  static final _serverClientIdandroid =
      "510929384792-68v17grotis8hm52l4fjbieoste6s5rb.apps.googleusercontent.com";

  static GoogleSignIn get _googleSignIn {
    if (kIsWeb) {
      // Configuración para web
      return GoogleSignIn(
        serverClientId: _serverClientIdweb,
        scopes: [
          'email',
          'profile',
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email',
        ],
      );
    } else if (Platform.isAndroid) {
      // Configuración para Android
      return GoogleSignIn(
        serverClientId: _serverClientIdandroid,
        scopes: [
          'email',
          'profile',
        ],
      );
    } else {
      // Configuración para otras plataformas
      return GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
      );
    }
  }

static Future<GoogleSignInAccount?> login() async {
  try {
    debugPrint('Iniciando sesión con Google...');
    final account = await _googleSignIn.signIn();
    if (account != null) {
      debugPrint('Inicio de sesión exitoso: ${account.displayName}');
    } else {
      debugPrint('Inicio de sesión cancelado por el usuario.');
    }
    return account;
  } catch (error) {
    debugPrint('Error durante el inicio de sesión: $error');
    return null;
  }
}



  static Future<void> logout() => _googleSignIn.disconnect(); // Cierra la sesión de Google
}
