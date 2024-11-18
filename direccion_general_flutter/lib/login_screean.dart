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
  String? _selectedArea; // Variable para almacenar la selección del área
  List<String> _areas = []; // Lista para almacenar los nombres de las áreas
  final TextEditingController _usernameController = TextEditingController(); // Controlador para el nombre de usuario
  final TextEditingController _passwordController = TextEditingController(); // Controlador para la contraseña

  @override
  void initState() {
    super.initState();
    _fetchAreas(); // Llamar a la función para obtener las áreas al inicializar el estado
  }

  // Función para obtener las áreas del endpoint
  Future<void> _fetchAreas() async {
    final response = await http.get(Uri.parse('https://back-end-hospital2-0.onrender.com/departamentos/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes)); // Cambiado a utf8.decode
      setState(() {
        _areas = data.map((area) => area['Nombre'] as String).toList();
      });
    } else {
      throw Exception('Error al cargar las áreas');
    }
  }

  // Función para validar las credenciales del usuario
  Future<void> _validateUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final response = await http.get(Uri.parse('https://back-end-hospital2-0.onrender.com/tbb_usuarios/'));

    if (response.statusCode == 200) {
      List<dynamic> users = json.decode(utf8.decode(response.bodyBytes));
      // Verificar si el usuario y la contraseña son correctos
      final user = users.firstWhere(
        (user) => user['Nombre_Usuario'] == username && user['Contrasena'] == password,
        orElse: () => null,
      );

      if (user != null) {

        // Guardar el estado de la sesión
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('personaId', user['Persona_ID']);
        await prefs.setString('selectedArea', _selectedArea!);

        // Mostrar mensaje de éxito antes de redirigir
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso!')),
        );

        // Espera breve para mostrar el SnackBar antes de redirigir
        await Future.delayed(const Duration(seconds: 1));

        // Obtener el personaId del usuario encontrado
        int personaId = user['Persona_ID']; // Asegúrate de que tu respuesta contenga este campo

        // Redirige a la pantalla HomeScreen y pasa el área seleccionada y personaId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              area: _selectedArea ?? 'Área no seleccionada',
              personaId: personaId, // Pasa el personaId correcto aquí
            ),
          ),
        );
      } else {
        // Usuario no encontrado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos!')),
        );
      }
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }

  // Función para manejar la autenticación con Google
  void _handleGoogleSignIn() {
    // Aquí iría la lógica para autenticación con Google
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(area: _selectedArea ?? 'Área no seleccionada', personaId: 0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Inicio de Sesión')),
      ),
      body: SingleChildScrollView( // Envuelve el contenido en un SingleChildScrollView
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 const SizedBox(height: 60),
                // Imagen del logo
                Image.asset(
                  'assets/HPC-DG.png',
                  fit: BoxFit.contain,
                  height: 90,
                ),
                const SizedBox(height: 60),

                // Dropdown para seleccionar área
                DropdownButtonFormField<String>(
                  value: _selectedArea,
                  hint: Text('Seleccione un Área',  style: GoogleFonts.comicNeue(fontSize: 16)),
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
                      _selectedArea = newValue; // Actualiza el área seleccionada
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Campo de entrada para el nombre de usuario
                TextField(
                  controller: _usernameController, // Asignar controlador
                  decoration: InputDecoration(
                    labelText: 'Nombre de Usuario',
                    labelStyle: GoogleFonts.comicNeue(fontSize: 16),
                    hintStyle: GoogleFonts.comicNeue(fontSize: 16),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),

                // Campo de entrada para la contraseña
                TextField(
                  controller: _passwordController, // Asignar controlador
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

                // Botones de inicio de sesión y registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _validateUser(); // Llama a la función para validar el usuario
                      },
                      child: Text('Iniciar Sesión', style: GoogleFonts.comicNeue(fontSize: 15)),
                    ),
                    const SizedBox(width: 16), // Espacio entre los dos botones
                    ElevatedButton(
                      onPressed: () {
                        // Aquí puedes implementar la lógica para el registro
                      },
                      child: Text('Regístrate', style: GoogleFonts.comicNeue(fontSize: 15)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Botón para iniciar sesión con Google
                ElevatedButton.icon(
                  onPressed: _handleGoogleSignIn,
                  icon: Image.asset(
                    'assets/icono_google.png',
                    height: 24.0,
                    width: 24.0,
                  ),
                  label: Text('Iniciar sesión con Google', style: GoogleFonts.comicNeue()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

