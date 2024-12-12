import 'package:direccion_general_flutter/Drawer/google_costom_drawer.dart';
import 'package:direccion_general_flutter/View/home_screen2.dart';
import 'package:direccion_general_flutter/login_screean.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NosotrosScreen2 extends StatefulWidget {
  final String area;
  final GoogleSignInAccount user; // Agrega el parámetro de usuario

  const NosotrosScreen2({super.key, required this.area, required this.user});

  @override
  _NosotrosScreen2State createState() => _NosotrosScreen2State();
}

class _NosotrosScreen2State extends State<NosotrosScreen2> {
  late Future<Map<String, dynamic>> userDataFuture;

  @override
  void initState() {
    super.initState();
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen2(area: widget.area, user: widget.user),
      ),
    );
  }

  // Función para mostrar la imagen más grande con scroll
  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView( // Hacemos la imagen desplazable
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagen grande
                Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: double.infinity, // Usa todo el espacio disponible
                    height: 600, // Tamaño grande de la imagen
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
              height: 30,
            ),
            const SizedBox(width: 18),
            Flexible(
              child: Text(
                'Nosotros',
                style: GoogleFonts.comicNeue(fontSize: 15),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),

        drawer: CustomDrawer2(// se agrega el drawer para el usuario lo geado con google
          area: widget.area, // Reemplaza con el valor adecuado
          user: widget.user, // Reemplaza con el valor adecuado
          logout: () async {
            await GoogleSignIn().signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
        ),//


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/direccion_general_logo.png',
                    fit: BoxFit.contain,
                    height: 100,
                  ),
                  const SizedBox(width: 15),
                  Image.asset(
                    'assets/Jaguar Negro - Corporation.png',
                    fit: BoxFit.contain,
                    height: 100,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                      'Acerca de Nosotros',
                      style: GoogleFonts.comicNeue(
                        fontSize: 12,
                        fontWeight: FontWeight.bold, // Establecer el texto en negrita
                      ),
                    ),
              
              const SizedBox(height: 15),

              Text( 'Somos una empresa dedicada a ofrecer soluciones de software integrales. Nuestra misión es garantizar la excelencia en el desarrollo de herramientas tecnológicas que impulsen la eficiencia y productividad de nuestros clientes.',
                style: GoogleFonts.comicNeue(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              Text('Empresa Desarrolladora',
                    style: GoogleFonts.comicNeue(
                      fontSize: 12,
                      fontWeight: FontWeight.bold, // Establecer el texto en negrita
                    ),
                  ),
              
              const SizedBox(height: 15),

              Text('Jaguar Corporation ha sido líder en innovación y desarrollo, entregando productos de alta calidad diseñados para satisfacer las necesidades del mercado moderno.',
                style: GoogleFonts.comicNeue(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              Text("Equipo de Desarrollo",
                    style: GoogleFonts.comicNeue(
                      fontSize: 12,
                      fontWeight: FontWeight.bold, // Establecer el texto en negrita
                    ),
                  ),
              
              const SizedBox(height: 15),

              Text("Nuestro equipo de desarrollo está conformado por profesionales altamente capacitados y comprometidos con la calidad y la innovación. Trabajamos en conjunto para ofrecer soluciones tecnológicas de vanguardia.",
                style: GoogleFonts.comicNeue(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              // Usamos GestureDetector para detectar el toque y mostrar la imagen grande
              GestureDetector(
                onTap: () {
                  // Aquí se llama a la función para mostrar la imagen grande con scroll
                  _showImageDialog(context, 'assets/OrganigramaEquipo.png');
                },
                child: Image.asset(
                  'assets/OrganigramaEquipo.png',
                  fit: BoxFit.contain,
                  height: 210, // Tamaño pequeño de la imagen en la pantalla principal
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen2(area: widget.area, user: widget.user),
                    ),
                  );
                },
                icon: Icon(Icons.home, color: const Color.fromARGB(255, 6, 57, 105)),
                label: Text('Inicio',
                            style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
