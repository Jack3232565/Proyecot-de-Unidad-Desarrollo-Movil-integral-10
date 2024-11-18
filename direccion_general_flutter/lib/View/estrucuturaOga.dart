import 'package:direccion_general_flutter/View/home_screen.dart';
import 'package:direccion_general_flutter/login_screean.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Asegúrate de importar esto
import 'package:google_fonts/google_fonts.dart';

class AprobacionesScreen extends StatefulWidget {
  final String area; // Agrega el parámetro de área
  final int personaId;//Agrega el parametro de personaId

  const AprobacionesScreen({super.key, required this.area, required this.personaId});

  @override
  _AprobacionesScreenState createState() => _AprobacionesScreenState();
  
}


class _AprobacionesScreenState extends State<AprobacionesScreen> {
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
                'Aprobaciones de Solicitudes',
                style: GoogleFonts.comicNeue(fontSize: 15), // Apliacando la fuente y Ajusta el tamaño de fuente
                overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es demasiado largo
                softWrap: false, // Evita el salto de línea
              ),
            ),
          ],
        ),
      ),
     
     
drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      // Encabezado del Drawer que utiliza FutureBuilder
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
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Área: ${widget.area}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }
        },
      ),

      // Opciones de menú
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Inicio'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                area: widget.area,
                personaId: widget.personaId,
              ),
            ),
          );
        },
      ),

ListTile(
              leading: SizedBox(
                width: 25, // Ajusta el ancho
                height: 25, // Ajusta la altura
                child: Image.asset('assets/logo-DG.png'), // Ícono personalizado
              ),
              title: const Text('Aprobaciones Servicio Médico'),
              onTap: () {
                                // Cierra el Drawer
                Navigator.pop(context);

                    // Navega a la pantalla de inicio reemplazando la actual
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AprobacionesScreen(
                      area: widget.area, // Usa widget.area para obtener el área actual
                      personaId: widget.personaId, // Usa widget.personaId para el ID de persona actual
                    ),
                  ),
                );
              },
            ),


            ListTile(
              leading: SizedBox(
                width: 25, // Ajusta el ancho
                height: 25, // Ajusta la altura
                child: Image.asset('assets/EOrganicaH.png'), // Ícono personalizado
              ),
              title: const Text('Estrucutura Orgánica Hospitalaria'),
              onTap: () {
                // Acción para el botón personalizado
              },
            ),


            ListTile(
              leading: SizedBox(
                width: 25, // Ajusta el ancho
                height: 25, // Ajusta la altura
                child: Image.asset('assets/Estadisitica.png'), // Ícono personalizado
              ),
              title: const Text('Estadistica'),
              onTap: () {
                // Acción para el botón personalizado
              },
            ),

            
            ListTile(
              leading: SizedBox(
                width: 25, // Ajusta el ancho
                height: 25, // Ajusta la altura
                child: Image.asset('assets/Bitacora.png'), // Ícono personalizado
              ),
              title: const Text('Bitácora'),
              onTap: () {
                // Acción para el botón personalizado
              },
            ),


            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Salir'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),


      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Área: ${widget.area}', // se imprime el area seleccionada por el usuario
                style: GoogleFonts.comicNeue(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),//Espaciado
              const Text('Solicitudes Pendientes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),//Titulo de la tabla
              //llamado de la tabla de solicitudes
              _buildSolicitudesTable(),
            ],
          ),
        ),

      );
  }
}


//Estrucutura de la tabla de Solicitudes
  Widget _buildSolicitudesTable() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('N°')),
            DataColumn(label: Text('Personal Médico')),
            DataColumn(label: Text('Comentario')),
            DataColumn(label: Text('Estatus')),
            DataColumn(label: Text('Tipo')),
          ],
          rows: _buildDataRows(),
        ),
      ),
    );
  }

  List<DataRow> _buildDataRows() {
    // Datos de ejemplo para la tabla
    List<Map<String, dynamic>> data = [
      {'ID': 1, 'Descripción': 'Solicitud A', 'Estatus': 'Pendiente', 'Fecha': '2024-11-04'},
      {'ID': 2, 'Descripción': 'Solicitud B', 'Estatus': 'Aprobada', 'Fecha': '2024-11-03'},
      {'ID': 3, 'Descripción': 'Solicitud C', 'Estatus': 'Rechazada', 'Fecha': '2024-11-02'},
    ];

    return data.map((item) {
      return DataRow(cells: [
        DataCell(Text(item['ID'].toString())),
        DataCell(Text(item['Descripción'])),
        DataCell(Text(item['Estatus'])),
        DataCell(Text(item['Fecha'])),
        
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Acción para editar
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Acción para eliminar
                },
              ),
            ],
          ),
        ),
      ]);
    }).toList();
  }

  Widget _buildDrawerContent(BuildContext context) {
    return const Drawer(
      // Contenido del Drawer
    );
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
