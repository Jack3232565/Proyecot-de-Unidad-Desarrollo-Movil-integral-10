import 'package:direccion_general_flutter/Drawer/costom_drawer.dart';
import 'package:direccion_general_flutter/View/aprobacionesSM.dart';
import 'package:direccion_general_flutter/login_screean.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Asegúrate de importar esto
import 'package:google_fonts/google_fonts.dart'; // Importa Google Fonts

class HomeScreen extends StatefulWidget {
  final String area; // Agrega el parámetro de área
  final int personaId;

  const HomeScreen({super.key, required this.area, required this.personaId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
  
}


class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> userDataFuture;
  

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData(widget.personaId);
  }

    Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('personaId');
    await prefs.remove('selectedArea');

    // Redirige a la pantalla de inicio de sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo
            Image.asset(
              'assets/direccion_general_logo.png', // Asegúrate de que esta ruta sea correcta
              fit: BoxFit.contain,
              height: 40, // Ajusta la altura como prefieras
            ),
            const SizedBox(width: 8), // Espacio entre el logo y el texto

            // Texto del área con ajuste automático
            Flexible(
              child: Text(
                widget.area,
                style: GoogleFonts.comicNeue(fontSize: 18), // Ajusta el tamaño de fuente
                overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es demasiado largo
                softWrap: false, // Evita el salto de línea
              ),
            ),
          ],
        ),
      ),

      
      drawer: Drawer(
        child:CustomDrawer( // Se agrega el widget CustomDrawer que es el menu lateral desde el archivo costom_drawer.dart
          userDataFuture: userDataFuture,
          area: widget.area,
          personaId: widget.personaId,
          logout: _logout
        ),
      ),

      

      body: Center(  
        child: FutureBuilder<Map<String, dynamic>>(
          future: userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text("No se encontró información del usuario");
            } else {
              final userData = snapshot.data!;
              // Imprime el valor de la fotografía para depuración
              print('Fotografía URL: ${userData['fotografia']}');

              // Obtiene la ruta de la fotografía y limpia los puntos finales
              String userPhotoPath = userData['fotografia'] ?? '';
              userPhotoPath = userPhotoPath.replaceAll(RegExp(r'\.+$'), ''); // Elimina puntos al final
              userPhotoPath = userPhotoPath.replaceAll(RegExp(r'^\.+'), ''); // Elimina puntos al inicio

              final photoUrl = 'https://back-end-hospital2-0.onrender.com$userPhotoPath';

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                        'assets/HPC-DG.png', // Asegúrate de que esta ruta sea correcta
                        fit: BoxFit.contain,
                        height: 60, // Ajusta la altura como prefieras
                      ),

                      const SizedBox(height: 20),//Espaciado entre el logo y la imagen de usuario

                  userData['fotografia'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            photoUrl,
                            height: 110,
                            width: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Container(
                                height: 150,
                                width: 150,
                                color: Colors.grey[300], // Color de fondo para el contenedor de la imagen
                                child: const Icon(Icons.error, color: Colors.red), // Icono de error
                              );
                            },
                          ),
                        )
                      : Text("No hay fotografía disponible"),
                      
                      const SizedBox(height: 20),//Espaciado entre la imagen del usuario y el correo del usuario
                    
                    Text(
                        'Bienvenid@: ${userData['correo']}',
                          style: GoogleFonts.comicNeue(fontSize: 12),
                        ),

                      const SizedBox(height: 15),//Espaciado entre el logo y la imagen de usuario

                    Text(
                        'Área: ${widget.area}',// se imprime el area seleccionada por el usuario
                          style: GoogleFonts.comicNeue(fontSize: 12, fontWeight: FontWeight.bold,  ),
                        ),

                    
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        // Navega a la pantalla de AprobacionesSM
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AprobacionesScreen(
                              area: widget.area, // Pasa el área actual si es necesario
                              personaId: widget.personaId, // Pasa el ID de persona si es necesario
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
                        children: [
                          SizedBox(
                            width: 25, // Ajusta el ancho
                            height: 25, // Ajusta la altura
                            child: Image.asset('assets/logo-DG.png'), // Ícono personalizado
                          ),
                          const SizedBox(width: 8), // Espacio entre la imagen y el texto
                                Text('Aprobaciones Servicio Médico',
                          style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          // Acciones cuando se toca el botón
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
                          children: [
                            SizedBox(
                              width: 25, // Ajusta el ancho
                              height: 25, // Ajusta la altura
                              child: Image.asset('assets/EOrganicaH.png'), // Ícono personalizado
                            ),
                            const SizedBox(width: 8), // Espacio entre la imagen y el texto
                                  Text('Estrucutura Orgánica Hospitalaria',
                            style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105))),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          // Acciones cuando se toca el botón
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
                          children: [
                            SizedBox(
                              width: 25, // Ajusta el ancho
                              height: 25, // Ajusta la altura
                              child: Image.asset('assets/Estadisitica.png'), // Ícono personalizado
                            ),
                            const SizedBox(width: 8), // Espacio entre la imagen y el texto
                                  Text('Estadística',
                            style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105))),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          // Acciones cuando se toca el botón
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
                          children: [
                            SizedBox(
                              width: 25, // Ajusta el ancho
                              height: 25, // Ajusta la altura
                              child: Image.asset('assets/Bitacora.png'), // Ícono personalizado
                            ),
                            const SizedBox(width: 8), // Espacio entre la imagen y el texto
                                  Text('Bitácora',
                                  style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105)),),
                          ],
                        ),
                      ),

                ],
              );
            }
          },
        ),
      ),
    );
  }
}

//----------------------------------------------------------------------------------------

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
