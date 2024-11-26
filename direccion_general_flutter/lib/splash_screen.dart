import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'View/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();// Cambiado de _SplashScreenState
}

class _SplashScreenState extends State<SplashScreen> {// Cambiado de _SplashScreenState
  @override
  void initState() {// Cambiado de _SplashScreenState
    super.initState();// Cambiado de _SplashScreenState
    _navigateToNextScreen();// Cambiado de _SplashScreenState
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 5)); // Tiempo de la carga
    final sessionData = await _checkSession();

    if (sessionData != null) {
      // Navega a la pantalla principal con los datos de sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            area: sessionData['selectedArea'],
            personaId: sessionData['personaId'],
          ),
        ),
      );
    } else {
      // Navega a la pantalla de inicio de sesión si no hay sesión activa
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<Map<String, dynamic>?> _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? personaId = prefs.getInt('personaId');
    final String? selectedArea = prefs.getString('selectedArea');

    if (personaId != null && selectedArea != null) {
      return {'personaId': personaId, 'selectedArea': selectedArea};
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/HPC-DG.png', width: 350),
                  const SizedBox(height: 90),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Image.asset(
                'assets/Jaguar Negro - Corporation.png',
                width: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
