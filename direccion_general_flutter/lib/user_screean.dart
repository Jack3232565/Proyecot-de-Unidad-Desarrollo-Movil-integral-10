import 'dart:convert';
import 'package:direccion_general_flutter/login_screean.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String username = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String repeatPassword = '';
  String errorMessage = '';
  String successMessage = '';
  int? personaID; // Esto debe estar asignado a un valor válido

  // Validación para los campos vacíos
  bool validateFields() {
    if (username.isEmpty || email.isEmpty || phoneNumber.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      setState(() {
        errorMessage = 'Todos los campos son obligatorios.';
        successMessage = '';
      });
      return false;
    }

    if (password != repeatPassword) {
      setState(() {
        errorMessage = 'Las contraseñas no coinciden.';
        successMessage = '';
      });
      return false;
    }

    if (personaID == null || personaID! <= 0) {
      setState(() {
        errorMessage = 'Persona_ID debe ser un entero válido.';
        successMessage = '';
      });
      return false;
    }

    return true;
  }

  Future<void> registerUser() async {
    // Validar que los campos no estén vacíos
    if (!validateFields()) {
      return; // Si alguna validación falla, no se ejecuta el registro
    }

    final user = {
      'Persona_ID': personaID,
      'Nombre_Usuario': username,
      'Correo_Electronico': email,
      'Numero_Telefonico_Movil': phoneNumber,
      'Contrasena': password,
      'Estatus': 'Activo',
      'Fecha_Registro': DateTime.now().toIso8601String(),
      'Fecha_Actualizacion': DateTime.now().toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse('https://back-end-hospital2-0.onrender.com/tbb_usuarios/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user),
      );

      if (response.statusCode == 200) {
        setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario registrada exitosamente.')),
          );
          errorMessage = '';
        });
        resetForm();

        // Esperamos 2 segundos antes de redirigir a la pantalla de login
        await Future.delayed(const Duration(seconds: 3));

        // Redirigir a la pantalla de Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // Si la respuesta no es exitosa, intenta manejarla
        try {
          final errorData = json.decode(response.body);
          setState(() {
            errorMessage = errorData['detail'] ?? 'Error desconocido';
            successMessage = '';
          });
        } catch (e) {
          setState(() {
            errorMessage = 'Error desconocido. No se pudo procesar la respuesta.';
            successMessage = '';
          });
        }
        resetForm();  // Resetear el formulario en caso de error
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error al registrar usuario: $error';
        successMessage = '';
      });
      resetForm();  // Resetear el formulario en caso de error
    }
  }

  Future<void> fetchPersonaID() async {
    try {
      final response = await http.get(Uri.parse('https://back-end-hospital2-0.onrender.com/persons/'));
      final personas = json.decode(response.body) as List;
      if (personas.isNotEmpty) {
        setState(() {
          personaID = personas.last['id'] as int; // asuma que el ID está en una propiedad llamada 'id'
        });
      } else {
        setState(() {
          personaID = 0;
        });
      }
    } catch (error) {
      print('Error al obtener Persona_ID: $error');
      setState(() {
        errorMessage = 'Error al obtener Persona_ID';
      });
      resetForm();  // Resetear el formulario en caso de error
    }
  }

  void resetForm() {
    setState(() {
      username = '';
      email = '';
      phoneNumber = '';
      password = '';
      repeatPassword = '';
      errorMessage = '';
      successMessage = '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPersonaID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: Row(
          children: [
            Image.asset(
              'assets/direccion_general_logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Formulario de Registro de Usuario',
                style: GoogleFonts.comicNeue(fontSize: 15),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) => username = value,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              onChanged: (value) => email = value,
              decoration: const InputDecoration(labelText: 'Correo Electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              onChanged: (value) => phoneNumber = value,
              decoration: const InputDecoration(labelText: 'Número Telefónico Móvil'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              onChanged: (value) => password = value,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              onChanged: (value) => repeatPassword = value,
              decoration: const InputDecoration(labelText: 'Repetir Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: const Text('Registrar Usuario'),
            ),
            const SizedBox(height: 20),
            if (successMessage.isNotEmpty)
              Text(
                successMessage,
                style: const TextStyle(color: Colors.green),
              ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}