import 'package:flutter/material.dart';
import 'login_screean.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importa intl para inicializar el formato de fecha
import 'View/home_screen.dart';
import 'splash_screen.dart';

void main() async { // Se inicializa la aplicación con Run App
  WidgetsFlutterBinding.ensureInitialized(); // Asegúrate de que los widgets estén inicializados
  await initializeDateFormatting('es_ES', null); // Inicializa el formato de fecha para español
  runApp(const HospitalApp());
}

class HospitalApp extends StatelessWidget {
  const HospitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hospital App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // Ruta inicial para mostrar el SplashScreen
      routes: {
        '/': (context) => const SplashScreen(), // SplashScreen como ruta inicial
        '/login': (context) => const LoginScreen(), // Ruta para la pantalla de login
        '/home': (context) => const HomeScreen(area: '', personaId: 0,), // Ruta para la pantalla principal
      },
    );
  }
}