import 'package:direccion_general_flutter/View/aprobacionesSM3.dart';
import 'package:direccion_general_flutter/View/bitacora_screen3.dart';
import 'package:direccion_general_flutter/View/estadisticas3.dart';
import 'package:direccion_general_flutter/View/home_screen3.dart';
import 'package:direccion_general_flutter/View/nosotros_screen3.dart';
import 'package:direccion_general_flutter/View/terminosCondiciones3.dart';
import 'package:direccion_general_flutter/oauth/facebook.dart' as fb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer3 extends StatelessWidget {
  final fb.FacebookUser user; // Cambiado a FacebookUser
  final String area;

  final Future<void> Function() logout;

  // ignore: use_super_parameters
  const CustomDrawer3({
    Key? key,
    required this.area,
    required this.user,
    required this.logout,
  }): super(key: key);

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
                              // ignore: unnecessary_null_comparison
                              child: user.pictureUrl != null
                                  ? Image.network(user.pictureUrl!, height: 50, width: 50, fit: BoxFit.cover)
                                  : Image.asset('assets/default_avatar.png', height: 50),
                            ),
                      const SizedBox(height: 10),
                      // Nombre del usuario
                      Text(
                        'Bienvenid@: ${user.name}',
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
                              builder: (context) => HomeScreen3(area: area, user: user),
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
                                  builder: (context) => AprobacionesScreen3(
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
                                      builder: (context) => EstadisticaScreen3(area: area, user: user),
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
                                      builder: (context) => BitacoraScreen3(area: area, user: user),
                                    ),
                                  );
                          },
                        ),


                          ListTile(
                            leading: const Icon(Icons.people_sharp),
                            title: Text('Nosotros', style: GoogleFonts.comicNeue(fontSize: 16)),
                            onTap: () {
                              Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NosotrosScreen3(area: area, user: user),
                                      ),
                                    );
                            },
                          ),

                                                    ListTile(
                            leading: const Icon(Icons.privacy_tip),
                            title: Text('Términos y Condiciones', style: GoogleFonts.comicNeue(fontSize: 16)),
                            onTap: () {
                              Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TerminosScreen3(area: area, user: user),
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
