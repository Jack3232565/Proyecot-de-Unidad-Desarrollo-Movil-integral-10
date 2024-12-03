import 'package:direccion_general_flutter/oauth/facebook.dart';
import 'package:direccion_general_flutter/oauth/google.dart';
import 'package:direccion_general_flutter/register_screean.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'View/home_screen.dart'; // Importa la pantalla de inicio
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _selectedArea;
  List<String> _areas = [];
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _keepSessionOpen = false; // Variable para mantener la sesión abierta

  @override
  void initState() {
    super.initState();
    _fetchAreas();
  }

  Future<void> _fetchAreas() async {
    final response = await http.get(Uri.parse('https://back-end-hospital2-0.onrender.com/departamentos/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        _areas = data.map((area) => area['Nombre'] as String).toList();
      });
    } else {
      throw Exception('Error al cargar las áreas');
    }
  }

  Future<void> _validateUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final response = await http.get(Uri.parse('https://back-end-hospital2-0.onrender.com/tbb_usuarios/'));

    if (response.statusCode == 200) {
      List<dynamic> users = json.decode(utf8.decode(response.bodyBytes));
      final user = users.firstWhere(
        (user) => user['Nombre_Usuario'] == username && user['Contrasena'] == password,
        orElse: () => null,
      );

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (_keepSessionOpen) {
          // Si se selecciona mantener la sesión abierta, guardar credenciales
          await prefs.setBool('keepSessionOpen', true);
        } else {
          await prefs.setBool('keepSessionOpen', false);
        }

        await prefs.setInt('personaId', user['Persona_ID']);
        await prefs.setString('selectedArea', _selectedArea!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso!')),
        );

        await Future.delayed(const Duration(seconds: 1));

        int personaId = user['Persona_ID'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              area: _selectedArea ?? 'Área no seleccionada',
              personaId: personaId,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos!')),
        );
      }
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }


  // Función para manejar la autenticación con Facebook
      // Función para manejar la autenticación con Google
  // void _handleFacebookSignIn() {
  //   // Aquí iría la lógica para autenticación con Google
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => HomeScreen(area: _selectedArea ?? 'Área no seleccionada', personaId: 0)),
  //   );
  // }

//----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Inicio de Sesión')),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                DropdownButtonFormField<String>(
                  value: _selectedArea,
                  hint: Text('Seleccione un Área', style: GoogleFonts.comicNeue(fontSize: 16)),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.area_chart),
                  ),
                  items: _areas.map((String area) {
                    return DropdownMenuItem<String>(
                      value: area,
                      child: Text(area, style: GoogleFonts.comicNeue(fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedArea = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de Usuario',
                    labelStyle: GoogleFonts.comicNeue(fontSize: 16),
                    hintStyle: GoogleFonts.comicNeue(fontSize: 16),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: GoogleFonts.comicNeue(fontSize: 16),
                    hintStyle: GoogleFonts.comicNeue(fontSize: 16),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _validateUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 12, 76, 128),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Iniciar Sesión', style: GoogleFonts.comicNeue(fontSize: 15)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 2, 20, 35),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Regístrate', style: GoogleFonts.comicNeue(fontSize: 15)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Switch para mantener la sesión abierta
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Alinea los elementos al lado derecho
                  children: [
                    Text(
                      'Mantener sesión abierta',
                      style: GoogleFonts.comicNeue(fontSize: 14),
                    ),
                    const SizedBox(width: 8), // Espacio entre el texto y el switch
                    Switch(
                      value: _keepSessionOpen,
                      onChanged: (bool value) {
                        setState(() {
                          _keepSessionOpen = value;
                        });
                      },
                      activeTrackColor: const Color.fromARGB(255, 12, 76, 128),// Color de la barra del switch
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón para iniciar sesión con Google
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GoogleScreen()),
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
                    
                    const SizedBox(width: 16), // Espacio entre los botones

                    // Botón para iniciar sesión con Facebook
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FacebookScreen()),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
