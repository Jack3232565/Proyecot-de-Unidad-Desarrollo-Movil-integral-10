import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Asegúrate de que esta línea esté presente
import 'package:direccion_general_flutter/View/home_screen3.dart';
import 'package:direccion_general_flutter/View/Areas/areas_screean.dart';

class FacebookScreen extends StatelessWidget {
  const FacebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? selectedArea;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Sign In'),
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

                // Lógica para manejar Facebook Sign-In
                final user = await FacebookSignInApi.login();
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al iniciar sesión con Facebook.')),
                  );
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen3(area: selectedArea!, user: FacebookUser.fromMap(user)), // cambiar personaId por el user de Facebook
                  ),
                );
              },
              icon: Image.asset(
                'assets/icono_facebook.png',
                height: 24.0,
                width: 24.0,
              ),
              label: Text('Facebook', style: GoogleFonts.comicNeue()),
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

class FacebookUser {
  final String name;
  final String email;
  final String pictureUrl;

  FacebookUser({required this.name, required this.email, required this.pictureUrl});

  factory FacebookUser.fromMap(Map<String, dynamic> map) {
    return FacebookUser(
      name: map['name'],
      email: map['email'],
      pictureUrl: map['picture']['data']['url'],
    );
  }
}

class FacebookSignInApi {
  static Future<Map<String, dynamic>?> login() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // Obtén los datos del usuario
        final userData = await FacebookAuth.instance.getUserData(
          fields: 'name,email,picture.width(200).height(200)',
        );
        debugPrint('Inicio de sesión exitoso: ${userData['name']}');
        return userData; // Puedes devolver los datos del usuario, como el nombre, el correo electrónico y la URL de la imagen de perfil

      } else {
        debugPrint('Inicio de sesión cancelado por el usuario o error');
        return null;
      }
    } catch (error) {
      debugPrint('Error durante el inicio de sesión con Facebook: $error');
      return null;
    }
  }

  static Future<void> logout() async {
    await FacebookAuth.instance.logOut();
    debugPrint('Cerrado sesión de Facebook');
  }
}

