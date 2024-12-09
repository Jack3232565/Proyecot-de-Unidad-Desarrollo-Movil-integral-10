import 'package:direccion_general_flutter/View/aprobacionesSM2.dart';
import 'package:direccion_general_flutter/View/bitacora_screen2.dart';
import 'package:direccion_general_flutter/View/estadisticas2.dart';
import 'package:direccion_general_flutter/View/home_screen2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CustomDrawer2 extends StatelessWidget {
  final String area;
  final GoogleSignInAccount user;
  final Function logout;

  const CustomDrawer2({
    super.key,
    required this.area,
    required this.user,
    required this.logout,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.7, // Drawer ocupará el 70% del ancho de la pantalla
        child: Drawer(
          child: Container(
            color: Colors.white, // Fondo sólido blanco
            child: Column(
              children: [
                // Encabezado del Drawer
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 248, 248, 248),// Fondo azul sólido
                    
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/HPC-DG.png',
                        fit: BoxFit.contain,
                        height: 30,
                      ),
                      const SizedBox(height: 10),
                      // Imagen de perfil del usuario
                      ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: user.photoUrl != null
                                  ? Image.network(user.photoUrl!, height: 50, width: 50, fit: BoxFit.cover)
                                  : Image.asset('assets/default_avatar.png', height: 50),
                            ),
                      const SizedBox(height: 10),
                      // Nombre del usuario
                      Text(
                        'Bienvenid@: ${user.displayName ?? 'Usuario'}',
                          style: GoogleFonts.comicNeue(fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      // Área del usuario
                      Text(
                        'Área: $area',
                style: GoogleFonts.comicNeue(fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Opciones del Drawer
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _drawerTile(
                        context,
                        icon: Icons.home,
                        label: 'Inicio',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen2(area: area, user: user),
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
                                  builder: (context) => AprobacionesScreen2(
                                    area: area,
                                    user: user
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
                                    builder: (context) => EstadisticaScreen2(area: area, user: user),
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

                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BitacoraScreen2(area: area, user: user),
                                    ),
                                  );
                          },
                        ),

                      _drawerTile(
                        context,
                        icon: Icons.logout,
                        label: 'Salir',
                        onTap: () {
                          Navigator.pop(context);
                          logout();
                        },
                      ),
                    ],
                  ),
                ),

                // Pie de página
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
            ),
          ),
        ),
      ),
    );
  }

  // Método para crear un ListTile estilizado
  Widget _drawerTile(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 99, 105, 110)),
      title: Text(
        label,
        style: GoogleFonts.comicNeue(fontSize: 16, color: Colors.black87),
      ),
      onTap: onTap,
    );
  }
}
