import 'package:direccion_general_flutter/login_screean.dart';
import 'package:direccion_general_flutter/oauth/google.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:direccion_general_flutter/View/sign_up_page.dart'; // Adjust the path as necessary

class HomeScreen2 extends StatelessWidget {

final GoogleSignInAccount user;

  const HomeScreen2({super.key, required this.user});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Google Sign In'),
      centerTitle: true,
      actions: [
        TextButton(
          child: Text('Logout', style: GoogleFonts.roboto(color: Colors.white),),
          onPressed: () async {
            await GoogleSignInApi.logout();

            Navigator.of(context).pushReplacement( MaterialPageRoute(
              builder: (context) => LoginScreen(), 
            ));
          }, 
          
        )
      ],
    ),
    body: Container(
      alignment: Alignment.center,
      color: Colors.blueGrey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Profile',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 32),
          CircleAvatar(
            radius: 60,
            backgroundImage: user.photoUrl != null
                ? NetworkImage(user.photoUrl!)
                : AssetImage('assets/default_avatar.png') as ImageProvider,
          ),
          SizedBox(height: 8),
          Text(
            'Name: ${user.displayName}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 8),
          Text(
            'Email: ${user.email}',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    )
  );
}