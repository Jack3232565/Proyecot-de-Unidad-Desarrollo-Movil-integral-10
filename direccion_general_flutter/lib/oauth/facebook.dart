import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Asegúrate de que esta línea esté presente
import 'package:direccion_general_flutter/View/home_screen2.dart';
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
                    builder: (context) => HomeScreen2(area: selectedArea!, user: user), // cambiar personaId por el user de Facebook
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

class FacebookSignInApi {
  static Future<Map<String, dynamic>?> login() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // Obtén los datos del usuario
        final userData = await FacebookAuth.instance.getUserData();
        debugPrint('Inicio de sesión exitoso: ${userData['name']}');
        return userData; // Puedes devolver los datos del usuario, como el nombre
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



// // Este archivo incluye la lógica y la interfaz de usuario de Facebook

// class FacebookScreen extends StatelessWidget {
//   const FacebookScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     String? selectedArea;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Facebook Sign In'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 60),
//             Image.asset(
//               'assets/HPC-DG.png',
//               fit: BoxFit.contain,
//               height: 90,
//             ),
//             const SizedBox(height: 60),
//             AreaSelector(
//               onAreaSelected: (area) {
//                 selectedArea = area;
//               },
//             ),
//             const SizedBox(height: 60),
//             ElevatedButton.icon(
//               onPressed: () async {
//                 if (selectedArea == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Por favor, seleccione un área antes de continuar.')),
//                   );
//                   return;
//                 }

//                 // Realizar login con Facebook
//                 final result = await FacebookAuth.instance.login(permissions: ['email']);

//                 if (result.status == LoginStatus.success) {
//                   // Si el login fue exitoso, obtenemos el token y los datos del usuario
//                   final accessToken = result.accessToken;
//                   final userData = await FacebookAuth.instance.getUserData();

//                   if (userData == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('No se pudieron obtener los datos del usuario.')),
//                     );
//                     return;
//                   }

//                   // Realiza el login en la aplicación usando el token de acceso
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => HomeScreen2(area: selectedArea!, user: userData),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Error al iniciar sesión con Facebook.')),
//                   );
//                 }
//               },
//               icon: Image.asset(
//                 'assets/icono_facebook.png',
//                 height: 24.0,
//                 width: 24.0,
//               ),
//               label: Text('Facebook', style: GoogleFonts.comicNeue()),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 side: const BorderSide(color: Colors.black),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Servicio de FacebookSignInApi dentro del mismo archivo
// class FacebookSignInApi {
//   // Método para autenticar con un token de acceso
//   static Future<Map<String, dynamic>?> loginWithToken(String token) async {
//     try {
//       // Usamos FacebookAuth.instance.login() para hacer login
//       final result = await FacebookAuth.instance.login(permissions: ['email']);

//       if (result.status == LoginStatus.success) {
//         // Si el login fue exitoso, obtenemos los datos del usuario
//         final userData = await FacebookAuth.instance.getUserData();
//         debugPrint('Inicio de sesión exitoso: ${userData['name']}');
//         return userData; // Retorna los datos del usuario
//       } else {
//         debugPrint('Error en el inicio de sesión con Facebook');
//         return null; // En caso de error
//       }
//     } catch (error) {
//       debugPrint('Error durante el inicio de sesión con Facebook: $error');
//       return null; // En caso de error
//     }
//   }

//   // Método para cerrar sesión
//   static Future<void> logout() async {
//     await FacebookAuth.instance.logOut();
//     debugPrint('Cerrado sesión de Facebook');
//   }
// }

// // Widget para seleccionar un área
// class AreaSelector extends StatelessWidget {
//   final Function(String) onAreaSelected;

//   const AreaSelector({required this.onAreaSelected, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       hint: Text('Seleccione un área'),
//       onChanged: (value) {
//         if (value != null) {
//           onAreaSelected(value);
//         }
//       },
//       items: <String>['Área 1', 'Área 2', 'Área 3'] // Áreas para seleccionar
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }

// // Pantalla de destino HomeScreen2
// class HomeScreen2 extends StatelessWidget {
//   final String area;
//   final Map<String, dynamic> user;

//   const HomeScreen2({required this.area, required this.user, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bienvenido, ${user['name']}'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Área seleccionada: $area'),
//             const SizedBox(height: 20),
//             Text('Nombre del usuario: ${user['name']}'),
//           ],
//         ),
//       ),
//     );
//   }
// }
