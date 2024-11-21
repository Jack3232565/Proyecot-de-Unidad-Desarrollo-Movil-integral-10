// custom_drawer.dart
import 'package:direccion_general_flutter/View/estadisiticas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../View/home_screen.dart';
import 'package:direccion_general_flutter/View/aprobacionesSM.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomDrawer extends StatelessWidget {
  final Future<Map<String, dynamic>> userDataFuture;
  final String area;
  final int personaId;
  final Function logout;

  const CustomDrawer({
    super.key,
    required this.userDataFuture,
    required this.area,
    required this.personaId,
    required this.logout,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        FutureBuilder<Map<String, dynamic>>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(child: Text("Error al cargar datos del usuario")),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(child: Text("No se encontró información del usuario")),
              );
            } else {
              final userData = snapshot.data!;
              String userPhotoPath = userData['fotografia'] ?? '';
              userPhotoPath = userPhotoPath.replaceAll(RegExp(r'\.+$'), '').replaceAll(RegExp(r'^\.+'), '');
              final photoUrl = 'https://back-end-hospital2-0.onrender.com$userPhotoPath';

              return DrawerHeader(
                decoration: const BoxDecoration(color: Color.fromARGB(255, 248, 248, 248)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/HPC-DG.png',
                      fit: BoxFit.contain,
                      height: 30,
                    ),
                    const SizedBox(height: 5),
                    userData['fotografia'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              photoUrl,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                return Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error, color: Colors.red),
                                );
                              },
                            ),
                          )
                        : const Text("No hay fotografía disponible"),
                    const SizedBox(height: 10),
                    Text(
                      'Bienvenid@: ${userData['correo']}',
                      style: GoogleFonts.comicNeue(fontSize: 10),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Área: $area',
                      style: GoogleFonts.comicNeue(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );


            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: Text('Inicio', style: GoogleFonts.comicNeue(fontSize: 16)),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(area: area, personaId: personaId),
              ),
            );
          },
        ),
        
            ListTile(
              leading: SizedBox(
                width: 25,
                height: 25,
                child: Image.asset('assets/logo-DG.png'),
              ),
              title: Text('Aprobaciones Servicio Médico', style: GoogleFonts.comicNeue(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AprobacionesScreen(
                      area: area,
                      personaId: personaId,
                    ),
                  ),
                );
              },
            ),


            ListTile(
              leading: SizedBox(
                width: 25, // Ajusta el ancho
                height: 25, // Ajusta la altura
                child: Image.asset('assets/Estadisitica.png'), // Ícono personalizado
              ),
              title: Text('Estadistica', style: GoogleFonts.comicNeue(fontSize: 16)),
              onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EstadisticaScreen(area: area, personaId: personaId),
                        ),
                      );
                    },
                  ),

            
            ListTile(
              leading: SizedBox(
                width: 25, // Ajusta el ancho
                height: 25, // Ajusta la altura
                child: Image.asset('assets/Bitacora.png'), // Ícono personalizado
              ),
              title: Text('Bitácora', style: GoogleFonts.comicNeue(fontSize: 16)),
              onTap: () {
                // Acción para el botón personalizado
              },
            ),


            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Configuración', style: GoogleFonts.comicNeue(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
        // Agrega más ListTile como en tu ejemplo
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text('Salir', style: GoogleFonts.comicNeue(fontSize: 16)),
          onTap: () {
            Navigator.pop(context);
            logout();
          },
        ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Dirección General © 2024',
                    style: GoogleFonts.comicNeue(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 15, 12, 12),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

      ],
      
    );
    
  }
}

Future<Map<String, dynamic>> fetchUserData(int personaId) async {
  try {
    final usuarioResponse = await http.get(
      Uri.parse('https://back-end-hospital2-0.onrender.com/tbb_usuarios/'),
    );
    final personaResponse = await http.get(
      Uri.parse('https://back-end-hospital2-0.onrender.com/persons/'),
    );

    // Verifica el estado de las respuestas
    print('Usuario Response Status: ${usuarioResponse.statusCode}');
    print('Persona Response Status: ${personaResponse.statusCode}');

    if (usuarioResponse.statusCode == 200 && personaResponse.statusCode == 200) {
      final List<dynamic> usuarios = jsonDecode(usuarioResponse.body);
      final List<dynamic> personas = jsonDecode(personaResponse.body);

      final userData = usuarios.firstWhere((user) => user['ID'] == personaId, orElse: () => null);
      final personaData = personas.firstWhere((persona) => persona['id'] == personaId, orElse: () => null);

      if (userData == null) {
        throw Exception("User with ID $personaId not found");
      }
      if (personaData == null) {
        throw Exception("Persona with ID $personaId not found");
      }

      return {
        'correo': userData['Correo_Electronico'],
        'fotografia': personaData['Fotografia'],
      };
    }

    throw Exception("Failed to load user data");
  } catch (e) {
    // Manejo de excepciones
    print("Error fetching user data: $e");
    throw Exception("Error fetching user data");
  }
}