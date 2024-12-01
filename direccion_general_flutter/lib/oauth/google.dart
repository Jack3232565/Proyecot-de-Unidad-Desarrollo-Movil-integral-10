import 'dart:io'; // Para detectar si es Android o iOS
import 'package:flutter/foundation.dart'; // Para detectar si es web
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:direccion_general_flutter/View/home_screen2.dart';
import 'package:direccion_general_flutter/View/Areas/areas_screean.dart';

class GoogleScreen extends StatelessWidget {
  const GoogleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? selectedArea;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Image.asset(
              'assets/HPC-DG.png',
              fit: BoxFit.contain,
              height: 90,
            ),
            const SizedBox(height: 60),
            AreaSelector(
              onAreaSelected: (area) {
                selectedArea = area;
              },
            ),
            const SizedBox(height: 60),
            ElevatedButton.icon(
              onPressed: () async {
                if (selectedArea == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, seleccione un área antes de continuar.')),
                  );
                  return;
                }

                // Lógica para manejar Google Sign-In
                final user = await GoogleSignInApi.login();
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al iniciar sesión con Google.')),
                  );
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen2(area: selectedArea!, user: user), // cambiar personaId por el user de google
                  ),
                );
              },
              icon: Image.asset(
                'assets/icono_google.png',
                height: 24.0,
                width: 24.0,
              ),
              label: Text('Google', style: GoogleFonts.comicNeue()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  // Función para manejar la autenticación con Google
  Future<void> _handleGoogleSignIn(BuildContext context, String selectedArea) async {
    final user = await GoogleSignInApi.login();

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inicio de sesión exitoso, ${user.displayName}'),
        ),
      );
      // Redirige a HomeScreen si la autenticación es exitosa
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen2(area: selectedArea, user: user),
      ));
    } else {
      // Maneja el caso de error o cancelación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión cancelado')),
      );
    }
  }

class GoogleSignInButtonWeb extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButtonWeb({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Iniciar sesión con Google'),
    );
  }
}

class GoogleSignInApi {
  // Configura los client IDs para web y Android
  static const _serverClientIdWeb =
      '930523576022-5ndtgbclull8usogrloj4qlfqusk8d8j.apps.googleusercontent.com';
  static const _serverClientIdAndroid =
      '510929384792-oql3avrc130ndcbvinfdd5bhm21fqsv7.apps.googleusercontent.com';

  static GoogleSignIn get _googleSignIn {
    if (kIsWeb) {
      // Configuración para web
      return GoogleSignIn(
        clientId: _serverClientIdWeb,
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
        serverClientId: _serverClientIdAndroid,
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
    // Intenta iniciar sesión directamente en lugar de hacerlo en silencio.
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
