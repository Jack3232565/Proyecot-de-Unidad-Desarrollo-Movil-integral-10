import 'package:direccion_general_flutter/Drawer/facebook_costom_draware.dart';
import 'package:direccion_general_flutter/View/aprobacionesSM3.dart';
import 'package:direccion_general_flutter/View/estadisticas3.dart';
import 'package:direccion_general_flutter/login_screean.dart';
import 'package:direccion_general_flutter/oauth/facebook.dart' as fb;
import 'package:direccion_general_flutter/oauth/facebook.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:direccion_general_flutter/View/sign_up_page.dart'; // Adjust the path as necessary

class HomeScreen3 extends StatelessWidget {
  final String area;
  final fb.FacebookUser user;

  const HomeScreen3({super.key, required this.user, required this.area});

  @override
  Widget build(BuildContext context) {
    final String photoUrl = user.pictureUrl ?? '';
    final String displayName = user.name ?? 'Usuario';
    final String email = user.email ?? 'Correo no disponible';

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
                area,
                style: GoogleFonts.comicNeue(fontSize: 18),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text('Logout', style: GoogleFonts.roboto(color: Colors.white)),
            onPressed: () async {
              await FacebookSignInApi.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer3(
        user: user,
        area: area,
        logout: () async {
          await FacebookSignInApi.logout();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/HPC-DG.png',
              fit: BoxFit.contain,
              height: 60,
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: photoUrl.isNotEmpty
                  ? Image.network(photoUrl)
                  : Image.asset('assets/default_avatar.png'),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 8),
            Text(
              'Bienvenid@: $displayName',
              style: GoogleFonts.comicNeue(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $email',
              style: GoogleFonts.comicNeue(fontSize: 12),
            ),
            const SizedBox(height: 15),
            Text(
              'Área: $area',
              style: GoogleFonts.comicNeue(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AprobacionesScreen3(
                      area: area,
                      user: user,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset('assets/logo-DG.png'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Aprobaciones Servicio Médico',
                    style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acciones cuando se toca el botón
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset('assets/EOrganicaH.png'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Estrucutura Orgánica Hospitalaria',
                    style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acciones cuando se toca el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EstadisticaScreen3(
                      area: area,
                      user: user, personaId: 0,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset('assets/Estadisitica.png'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Estadística',
                    style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acciones cuando se toca el botón
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset('assets/Bitacora.png'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bitácora',
                    style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
