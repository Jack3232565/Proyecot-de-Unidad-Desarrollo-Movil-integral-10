import 'dart:convert';
import 'dart:io';
import 'package:direccion_general_flutter/user_screean.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Importar image_picker
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:google_fonts/google_fonts.dart'; // Importar google_fonts


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para campos
  String? tituloCortesia;
  String? nombre;
  String? primerApellido;
  String? segundoApellido;
  String? curp;
  String? genero;
  String? tipoSangre;
  String? fechaNacimiento;
  File? fotografia;

  String message = '';
  bool success = false;

  // Instancia de ImagePicker
  final ImagePicker _picker = ImagePicker();

  // Método para seleccionar una fecha
  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (picked != null && picked != currentDate) {
      setState(() {
        fechaNacimiento = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Método para tomar una foto con la cámara
  Future<void> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera); // Usamos la cámara

    if (photo != null) {
      setState(() {
        fotografia = File(photo.path); // Guardar la imagen en el estado
      });
    }
  }

  // Método para seleccionar una imagen de la galería
  Future<void> pickImageFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery); // Usamos la galería

    if (photo != null) {
      setState(() {
        fotografia = File(photo.path); // Guardar la imagen en el estado

      });
    }
  }

  // Método para validar si la persona ya existe
  Future<bool> validatePerson(String curp) async {
    try {
      final response = await http.post(
        Uri.parse('https://back-end-hospital2-0.onrender.com/persons/validate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'curp': curp}),
      );
      final data = json.decode(response.body);
      return data['exists'] ?? false;
    } catch (error) {
      setState(() {
        message = 'Error al validar la CURP.';
        success = false;
      });
      return false;
    }
  }

  // Método para registrar a la persona
  Future<void> registerPerson() async {
    if (!_formKey.currentState!.validate()) return;

    final exists = await validatePerson(curp!);
    if (exists) {
      setState(() {
        message = 'La persona ya está registrada.';
        success = false;
      });
      return;
    }

    try {
      final uri = Uri.parse('https://back-end-hospital2-0.onrender.com/person/');
      final request = http.MultipartRequest('POST', uri);

      // Adjuntar datos
      request.fields['Titulo_Cortesia'] = tituloCortesia!;
      request.fields['Nombre'] = nombre!;
      request.fields['Primer_Apellido'] = primerApellido!;
      request.fields['Segundo_Apellido'] = segundoApellido!;
      request.fields['CURP'] = curp!;
      request.fields['Genero'] = genero!;
      request.fields['Tipo_Sangre'] = tipoSangre!;
      request.fields['Fecha_Nacimiento'] = fechaNacimiento!;
      request.fields['Estatus'] = 'true';
      request.fields['Fecha_Registro'] = DateTime.now().toIso8601String();
      request.fields['Fecha_Actualizacion'] = DateTime.now().toIso8601String();

      // Adjuntar imagen
      if (fotografia != null) {
        request.files.add(await http.MultipartFile.fromPath('Fotografia', fotografia!.path));
      }

      final response = await request.send(); // Enviar la solicitud

      if (response.statusCode == 200) {
        setState(() {
          message = 'Persona registrada exitosamente.';
          success = true;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Persona registrada exitosamente.')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const UserScreen(), // Cambiar a UserScreen
            ),
          );
        });
      } else {
        throw Exception('Error al registrar.');
      }
    } catch (error) {
      setState(() {
        message = 'Error al registrar la persona.';
        success = false;
      });
    }
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
                'Formulario de Registro',
                style: GoogleFonts.comicNeue(fontSize: 15),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: tituloCortesia,
                decoration: InputDecoration(labelText: 'Título de Cortesía', labelStyle: GoogleFonts.comicNeue(fontSize: 16)),
                items: [
                  'Señor',
                  'Señora',
                  'Doctor',
                  'Doctora',
                  'Ingeniero',
                  'Licenciado',
                  'Enfermera',
                  'Químico',
                  'Otro', 
                ].map((titulo) {
                  return DropdownMenuItem(value: titulo, child: Text(titulo,  style: GoogleFonts.comicNeue(fontSize: 16)));
                }).toList(),
                onChanged: (value) => setState(() => tituloCortesia = value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre',  labelStyle: GoogleFonts.comicNeue(fontSize: 16) ),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                onChanged: (value) => nombre = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Primer Apellido',  labelStyle: GoogleFonts.comicNeue(fontSize: 16)),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                onChanged: (value) => primerApellido = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Segundo Apellido', labelStyle: GoogleFonts.comicNeue(fontSize: 16)),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                onChanged: (value) => segundoApellido = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'CURP',  labelStyle: GoogleFonts.comicNeue(fontSize: 16)),
                maxLength: 18,
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                onChanged: (value) => curp = value,
              ),
              DropdownButtonFormField<String>(
                value: tipoSangre,
                decoration: InputDecoration(labelText: 'Tipo Sangre',  labelStyle: GoogleFonts.comicNeue(fontSize: 16)),
                items: [
                  'A+',
                  'A-',
                  'B+',
                  'B-',
                  'AB+',
                  'AB-',
                  'O+',
                  'O-',
                ].map((tipoSangre) {
                  return DropdownMenuItem(value: tipoSangre, child: Text(tipoSangre, style: GoogleFonts.comicNeue(fontSize: 16)));
                }).toList(),
                onChanged: (value) => setState(() => tipoSangre = value),
              ),
              DropdownButtonFormField<String>(
                value: genero,
                decoration: InputDecoration(labelText: 'Genero', labelStyle: GoogleFonts.comicNeue(fontSize: 16)),
                items: [
                  'Masculino',
                  'Femenino',
                  'N/B'
                ].map((genero) {
                  return DropdownMenuItem(value: genero, child: Text(genero, style: GoogleFonts.comicNeue(fontSize: 16)));
                }).toList(),
                onChanged: (value) => setState(() => genero = value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fecha de Nacimiento', labelStyle: GoogleFonts.comicNeue(fontSize: 16)),
                keyboardType: TextInputType.datetime,
                controller: TextEditingController(text: fechaNacimiento),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
                onTap: () {
                  // Deshabilitar la edición del campo de texto y abrir el calendario
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectDate(context);
                },
              ),

              const SizedBox(height: 16.0),// Espacio entre campos

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye los elementos
                crossAxisAlignment: CrossAxisAlignment.center,    // Alineación vertical
                children: [
                  fotografia == null
                      ? Text(
                          'Sin imagen.',
                          style: GoogleFonts.comicNeue(fontSize: 16),
                        )
                      : ClipOval(
                          child: SizedBox(
                            width: 120, // Ancho de la imagen
                            height: 120, // Alto de la imagen
                            child: Image.file(
                              fotografia!,
                              fit: BoxFit.cover, // Ajusta la imagen para que se recorte adecuadamente
                            ),
                          ),
                        ),
                        
                        Column( // Columna para los botones
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, // Alinea los botones al centro
                          children: [
                            ElevatedButton(   // Botón para tomar una foto
                              onPressed: takePhoto,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 12, 76, 128), // Color de fondo
                                foregroundColor: Colors.white, // Color del texto
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), // Tamaño del botón
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                                ),
                                shadowColor: Colors.black.withOpacity(0.3), // Sombra
                                elevation: 5, // Altura de la sombra
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenido
                                children: [
                                  const Icon(Icons.camera_alt, size: 18, color: Colors.white), // Ícono de cámara
                                  const SizedBox(width: 8), // Espacio entre ícono y texto
                                  Text(
                                    'Tomar Foto',
                                    style: GoogleFonts.comicNeue(fontSize: 16), // Estilo de texto
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 10), // Espacio entre botones

                            ElevatedButton(// Botón para seleccionar una imagen de la galería
                              onPressed: pickImageFromGallery, // Llamar a la función para seleccionar de la galería
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 12, 76, 128),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), // Tamaño del botón
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                                ),
                                shadowColor: Colors.black.withOpacity(0.3), // Sombra
                                elevation: 5, // Altura de la sombra
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenido
                                children: [
                                  const Icon(Icons.image, size: 18, color: Colors.white), // Ícono de imagen
                                  const SizedBox(width: 8), // Espacio entre ícono y texto
                                  Text(
                                    'Seleccionar Imagen',
                                    style: GoogleFonts.comicNeue(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                ],
              ),


              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: registerPerson, // Llamar a la función de registro
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 2, 20, 35),
                  foregroundColor: Colors.white
                ),
                child: Text('Registrar Persona', style: GoogleFonts.comicNeue(fontSize: 16)),
              ),
              if (message.isNotEmpty)
                Text(
                  message,
                  style: TextStyle(
                    color: success ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
