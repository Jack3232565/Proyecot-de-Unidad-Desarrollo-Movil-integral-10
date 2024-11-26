import 'package:direccion_general_flutter/Drawer/google_costom_drawer.dart';
import 'package:direccion_general_flutter/View/aprobacionesSM2.dart';
import 'package:direccion_general_flutter/login_screean.dart';
import 'package:direccion_general_flutter/oauth/google.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:direccion_general_flutter/View/sign_up_page.dart'; // Adjust the path as necessary

class HomeScreen2 extends StatelessWidget {
    
    final String area; // Agrega el parámetro de área
    final GoogleSignInAccount user; // Agrega el parámetro de usuario

  const HomeScreen2({super.key, required this.user, required this.area});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
        title: Row(
          children:[
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
                area,
                style: GoogleFonts.comicNeue(fontSize: 18), // Ajusta el tamaño de fuente
                overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es demasiado largo
                softWrap: false, // Evita el salto de línea
              ),
            ),
          ],
        ),


      centerTitle: true,// 
      actions: [// 
        TextButton(
          child: Text('Logout', style: GoogleFonts.roboto(color: Colors.white),),
          onPressed: () async {
            await GoogleSignInApi.logout();

            Navigator.of(context).pushReplacement( MaterialPageRoute(
              builder: (context) => const LoginScreen(), 
            ));
          }, 
          
        )
      ],
    ),


    drawer: CustomDrawer2(// se agrega el drawer para el usuario lo geado con google
      user: user, // Replace with your actual future
      area: area,
      logout: () async {
        await GoogleSignInApi.logout();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
    ),//

    body: Container(
      alignment: Alignment.center,
      // color: Colors.blueGrey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
                'assets/HPC-DG.png', // Asegúrate de que esta ruta sea correcta
                fit: BoxFit.contain,
                height: 60, // Ajusta la altura como prefieras
              ),

          const SizedBox(height: 20),//Espaciado entre el logo y la imagen de usuario
          
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: user.photoUrl != null
                ? Image.network(user.photoUrl!)
                : Image.asset('assets/default_avatar.png'),
          ),

          const SizedBox(height: 20),//Espaciado entre el logo y la imagen de usuario


          const SizedBox(height: 8),
          Text(
            'Bienvenid@: ${user.displayName}',
            style: GoogleFonts.comicNeue(fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            'Email: ${user.email}',
            
            style: GoogleFonts.comicNeue(fontSize: 12),
          ),
          const SizedBox(height: 15),
          Text(
          'Área: ${area}',// se imprime el area seleccionada por el usuario
            style: GoogleFonts.comicNeue(fontSize: 12, fontWeight: FontWeight.bold,  ),
          ),

          const SizedBox(height: 20),

                              ElevatedButton(
                      onPressed: () {
                        // Navega a la pantalla de AprobacionesSM
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AprobacionesScreen2(
                              area: area, // Pasa el área actual si es necesario
                              user: user, // Pasa el usuario actual
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
                        children: [
                          SizedBox(
                            width: 25, // Ajusta el ancho
                            height: 25, // Ajusta la altura
                            child: Image.asset('assets/logo-DG.png'), // Ícono personalizado
                          ),
                          const SizedBox(width: 8), // Espacio entre la imagen y el texto
                                Text('Aprobaciones Servicio Médico',
                          style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105))),
                        ],
                      ),
                    ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          // Acciones cuando se toca el botón
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
                          children: [
                            SizedBox(
                              width: 25, // Ajusta el ancho
                              height: 25, // Ajusta la altura
                              child: Image.asset('assets/EOrganicaH.png'), // Ícono personalizado
                            ),
                            const SizedBox(width: 8), // Espacio entre la imagen y el texto
                                  Text('Estrucutura Orgánica Hospitalaria',
                            style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105))),
                          ],
                        ),
                      ),
                    
                      const SizedBox(height: 20),
                      
                      ElevatedButton(
                        onPressed: () {
                          // Acciones cuando se toca el botón
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
                          children: [
                            SizedBox(
                              width: 25, // Ajusta el ancho
                              height: 25, // Ajusta la altura
                              child: Image.asset('assets/Estadisitica.png'), // Ícono personalizado
                            ),
                            const SizedBox(width: 8), // Espacio entre la imagen y el texto
                                  Text('Estadística',
                            style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105))),
                          ],
                        ),
                      ),


                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          // Acciones cuando se toca el botón
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
                          children: [
                            SizedBox(
                              width: 25, // Ajusta el ancho
                              height: 25, // Ajusta la altura
                              child: Image.asset('assets/Bitacora.png'), // Ícono personalizado
                            ),
                            const SizedBox(width: 8), // Espacio entre la imagen y el texto
                                  Text('Bitácora',
                                  style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 57, 105)),),
                          ],
                        ),
                      ),

        ],
      ),
    )
  );
}