import 'package:direccion_general_flutter/Drawer/google_costom_drawer.dart';
import 'package:direccion_general_flutter/View/home_screen2.dart'as home;
import 'package:direccion_general_flutter/login_screean.dart'; // Corrección en el nombre del archivo; // Import the HomeScreen class with alias
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;



// ------------ Extraccion de datos de los medicos -----------------
class Doctor {
  final String nombre;
  final String primerApellido;
  final String segundoApellido;
  final int id;

  Doctor({
    required this.nombre,
    required this.primerApellido,
    required this.segundoApellido,
    required this.id,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      nombre: json['Nombre'],
      primerApellido: json['Primer_Apellido'],
      segundoApellido: json['Segundo_Apellido'],
      id: json['id'],
    );
  }
}
//-----------------------------------------------------------------
// ------------ Extraccion de datos de las solicitudes -----------------

class Solicitud {
  final int solicitud;
  final String prioridad;
  final String descripcion;
  final String estado;

    Solicitud({
    required this.solicitud,
    required this.prioridad,
    required this.descripcion,
    required this.estado,
    });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      solicitud: json['id'],
      prioridad: json['Prioridad'],
      descripcion: json['Descripcion'],
      estado: json['Estado'],
    );
  }
}
//-----------------------------------------------------------




class AprobacionesScreen2 extends StatefulWidget {
  final String area;
  final GoogleSignInAccount user; // Agrega el parámetro de usuario

  const AprobacionesScreen2({super.key, required this.area, required this.user});

  @override
  _AprobacionesScreen2State createState() => _AprobacionesScreen2State();
}

class _AprobacionesScreen2State extends State<AprobacionesScreen2> {
  
  late Future<Map<String, dynamic>> userDataFuture; // Cambiado a late para inicializar en initState
  List<dynamic> aprobaciones = [];// Cambiado a List<dynamic> para que coincida con el tipo de retorno
  Map<int, Map<String, dynamic>> personalMedicoData = {};// Cambiado a Map<int, Map<String, dynamic>> para que coincida con el tipo de retorno

  List<Doctor> listaMedicos = [];  // Cambiado a List<Doctor> para que coincida con el tipo de retorno

  Map<int, Map<String, dynamic>> solicitudesRealizadas = {};  // Cambiado a map de tipo Solicitud

  

@override
void initState() {
  super.initState();
  fetchAprobaciones();
  fetchPersonalMedicoData();

  fetchDoctors().then((doctors) {
    setState(() {
      listaMedicos = doctors;
    });
  });


  fetchSolicitudes().then((_){
    setState(() {
      setState(() {});
    });
  });
}

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('personaId');
    await prefs.remove('selectedArea');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> fetchAprobaciones() async {
    try {
      final response = await http.get(
        Uri.parse('https://back-end-hospital2-0.onrender.com/tbb_aprobaciones/'),
      );
      if (response.statusCode == 200) {
        setState(() {
          aprobaciones = json.decode(response.body);
        });
      } else {
        throw Exception('Error al obtener aprobaciones');
      }
    } catch (e) {
      print('Error: $e');
    }
  }




  Future<void> fetchPersonalMedicoData() async {
    try {
      final response = await http.get(
        Uri.parse('https://back-end-hospital2-0.onrender.com/persons/'),
      );
      if (response.statusCode == 200) {
        List<dynamic> persons = json.decode(utf8.decode(response.bodyBytes));// Cambiado a utf8.decode para la interpretacion de caracteres especiales
        setState(() {
          // Crear un mapa donde el id del personal médico es la clave y los detalles son el valor
          personalMedicoData = {
            for (var person in persons) person['id']: {
              'titulo': person['Titulo_Cortesia'],
              'nombre': person['Nombre'],
              'primerApellido': person['Primer_Apellido'],
              'segundoApellido': person['Segundo_Apellido'],
            }
          };
        });
      } else {
        throw Exception('Error al obtener datos de personal médico');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


//------------------------------------------------------------------------
//Estraccion de los datos de los medicos

Future<List<Doctor>> fetchDoctors() async {
  try {
    final response = await http.get(Uri.parse('https://back-end-hospital2-0.onrender.com/persons/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Doctor.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load doctors: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error fetching doctors: $e');
    throw Exception('Error fetching doctors: $e');
  }
}


//------------------------------------------------------------------------
//Estraccion de los datos de las solicitudes
  // Función para obtener las solicitudes
// Función para obtener las solicitudes
Future<void> fetchSolicitudes() async {
  // Hacer la solicitud HTTP
  final response = await http.get(Uri.parse('https://back-end-hospital2-0.onrender.com/solicitudes/'));

  if (response.statusCode == 200) {
    // Decodificar la respuesta JSON
    List<dynamic> solicitudesData = json.decode(response.body);
    
    // Imprimir los datos crudos de las solicitudes recibidas
    print('Datos de las solicitudes recibidos correctamente : $solicitudesData');

    setState(() {
      solicitudesRealizadas = {
        for (var solicitud in solicitudesData) 
        solicitud['ID']: solicitud
      };
      print('se imprimenlas solicitude desde fechSolicitudes$solicitudesData');
    });



    // Ahora accedemos a las solicitudes usando el ID
    int solicitudIdBuscada = 1;  // Ejemplo: buscar la solicitud con ID 1
    if (solicitudesRealizadas.containsKey(solicitudIdBuscada)) {
      var solicitud = solicitudesRealizadas[solicitudIdBuscada];
      print('Solicitud encontrada: $solicitud');
    } else {
      print('No se encontró solicitud con ID: $solicitudIdBuscada');
    }
  } else {
    print('Error en la respuesta: ${response.statusCode}');
  }
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Cierra el drawer si es necesario
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => home.HomeScreen2(
                      area: widget.area,  // Reemplaza con el valor adecuado
                      user: widget.user , // Reemplaza con el valor adecuado
                    ),
                  ),
                );
              },
              child: Image.asset(
                'assets/direccion_general_logo.png',
                fit: BoxFit.contain,
                height: 40,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Aprobaciones de Solicitudes',
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


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Área: ${widget.area}',
              style: GoogleFonts.comicNeue(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Solicitudes Pendientes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            ElevatedButton(
                      onPressed: () => _showCreateAprobacionModal(context),
                      child: const Text('Crear Aprobación'),
                    ),

            _buildSolicitudesTable(), //Agregar el widget _buildSolicitudesTable para mostrar la tabla de solicitudes
          ],
        ),
      ),
    );
  }
  
Widget _buildSolicitudesTable() {
  return Expanded(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView( 
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('N°')),
          DataColumn(label: Text('Personal Médico')),
          DataColumn(label: Text('Solicitud')), // Nueva columna
          DataColumn(label: Text('Comentario')),
          DataColumn(label: Text('Estatus')),
          DataColumn(label: Text('Tipo')),
          DataColumn(label: Text('Fecha de Registro')),
          DataColumn(label: Text('Fecha de Aprobación')),
        ],
        rows: _buildDataRows(),
      ),
    ),
    ),
  );
}





List<DataRow> _buildDataRows() {// Cambiado a List<DataRow> para que coincida con el tipo de retorno

  intl.Intl.defaultLocale = 'es_ES';
  final dateFormat = DateFormat('EEEE, d MMMM yyyy');

  return aprobaciones.map<DataRow>((item) {
    final medicoId = item['Personal_Medico_ID'];
    final medicoData = personalMedicoData[medicoId];
    final solicitudId = item['Solicitud_id'];
    final solicitudData = solicitudId != null ? solicitudesRealizadas[solicitudId] : null;
    if (solicitudData == null) {
      print('Solicitud con ID $solicitudId no encontrada.');
      print('SolicitudData _buldDAtarows $solicitudData no encontrada.');
    }
    print('Prueba de que estallegando $solicitudData');
    print('Solicitudes realizadas (no resive datos): $solicitudesRealizadas');
    
  //-----------------------------------
    // Formateo de fechas
    String fechaRegistroFormateada = '';
    String fechaActualizacionFormateada = '';

    if (item['Fecha_Registro'] != null) {
      fechaRegistroFormateada = dateFormat.format(DateTime.parse(item['Fecha_Registro']));
    }
    if (item['Fecha_Actualizacion'] != null) {
      fechaActualizacionFormateada = dateFormat.format(DateTime.parse(item['Fecha_Actualizacion']));
    }

    //-------------
    // Construcción del texto formateado para la solicitud
      String decodeUtf8(dynamic input) {
        return input != null ? utf8.decode(input.toString().runes.toList()) : 'N/A';
      }

      final String solicitudTexto = solicitudData != null
          ? 'Solicitud: $solicitudId, Prioridad: ${decodeUtf8(solicitudData['Prioridad'])}, Descripción: ${decodeUtf8(solicitudData['Descripcion'])}, Estatus: ${decodeUtf8(solicitudData['Estatus'])}'
          : 'Solicitud no disponible';
    //-------------

    return DataRow(// Se agrega el DataRow para mostrar los datos de cada fila
      cells: [
        // N° de la solicitud
        DataCell(GestureDetector(
          onTap: () {
            _showOptionsModal(context, item, medicoData, solicitudData != null ? {
              'prioridad': solicitudData['Prioridad'],
              'descripcion': solicitudData['Descripcion'],
              'estado': solicitudData['Estado'],
              'solicitud': solicitudData['Solicitud'],
            } : null);
          },
          child: Text(item['id'].toString()),
        )),
        
        // Personal Médico
        DataCell(GestureDetector(// Se agrega el GestureDetector para detectar el tap
          onTap: () {
            _showOptionsModal(context, item, medicoData, solicitudData != null ? {
              'prioridad': solicitudData['Prioridad'],
              'descripcion': solicitudData['Descripcion'],
              'estado': solicitudData['Estado'],
              'solicitud': solicitudData['Solicitud'],
            } : null);
          },
          child: Text(medicoData != null
              ? '${medicoData['titulo']} ${medicoData['nombre']} ${medicoData['primerApellido']} ${medicoData['segundoApellido']}'
              : 'Nombre no disponible'),
        )),

        // Detalles de la Solicitud (Prioridad, Descripción, Estado)
        DataCell(
                GestureDetector(
                    onTap: () {
                      _showOptionsModal(
                        context, 
                        item, 
                        medicoData, 
                        solicitudData != null 
                          ? {
                              'prioridad': solicitudData['Prioridad'],
                              'descripcion': solicitudData['Descripcion'],
                              'estado': solicitudData['Estado'],
                              'solicitud': solicitudData['Solcitud'],
                            } 
                          : null
                      );
                    },
                    child: Text(
                      solicitudTexto,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),

        // Comentario
        DataCell(GestureDetector(
          onTap: () {
            _showOptionsModal(context, item, medicoData, solicitudData != null ? {
              'prioridad': solicitudData['Prioridad'],
              'descripcion': solicitudData['Descripcion'],
              'estado': solicitudData['Estado'],
              'solicitud': solicitudData['Solicitud'],
            } : null);
          },
          child: Text(item['Comentario'] ?? ''),
        )),

        // Estatus de la Solicitud
        DataCell(GestureDetector(
          onTap: () {
            _showOptionsModal(context, item, medicoData, solicitudData != null ? {
              'prioridad': solicitudData['Prioridad'],
              'descripcion': solicitudData['Descripcion'],
              'estado': solicitudData['Estado'],
              'solicitud': solicitudData['Solicitud'],
            } : null);
          },
          child: Text(item['Estatus'] ?? ''),
        )),

        // Tipo de Solicitud
        DataCell(GestureDetector(
          onTap: () {
            _showOptionsModal(context, item, medicoData, solicitudData != null ? {
              'prioridad': solicitudData['Prioridad'],
              'descripcion': solicitudData['Descripcion'],
              'estado': solicitudData['Estado'],
              'solicitud': solicitudData['Solicitud'],
            } : null);
          },
          child: Text(item['Tipo'] ?? ''),
        )),

        // Fecha de Registro
        DataCell(GestureDetector(
          onTap: () {
            _showOptionsModal(context, item, medicoData, solicitudData != null ? {
              'prioridad': solicitudData['Prioridad'],
              'descripcion': solicitudData['Descripcion'],
              'estado': solicitudData['Estado'],
              'solicitud': solicitudData['Solicitud'],
            } : null);
          },
          child: Text(fechaRegistroFormateada),
        )),

        // Fecha de Aprobación
        DataCell(GestureDetector(
          onTap: () {
            _showOptionsModal(context, item, medicoData, solicitudData != null ? {
              'prioridad': solicitudData['Prioridad'],
              'descripcion': solicitudData['Descripcion'],
              'estado': solicitudData['Estado'],
            'solicitud': solicitudData['Solicitud'],
            } : null);
          },
          child: Text(fechaActualizacionFormateada),
        )),
      ],
    );
  }).toList();
}





// Función para mostrar el modal de opciones
void _showOptionsModal(BuildContext context, dynamic item, Map<String, dynamic>? medicoData, Map<String, dynamic>? solicitudData) {
  final dateFormat = DateFormat('yyyy-MM-dd');
  TextEditingController comentarioController = TextEditingController(text: item['Comentario'] ?? '');
  TextEditingController estatusController = TextEditingController(text: item['Estatus'] ?? '');
  TextEditingController tipoController = TextEditingController(text: item['Tipo'] ?? '');
  TextEditingController fechaRegistroController = TextEditingController(
    text: item['Fecha_Registro'] != null ? dateFormat.format(DateTime.parse(item['Fecha_Registro'])) : '',
  );
  TextEditingController fechaAprobacionController = TextEditingController(
    text: item['Fecha_Actualizacion'] != null ? dateFormat.format(DateTime.parse(item['Fecha_Actualizacion'])) : '',
  );

  DateTime? selectedDate;

  showDialog(// Se agrega el showDialog para mostrar el modal de opciones
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Solicitud: ${item['id']}, por ${(medicoData?['titulo'] == 'Doctor' ? 'el' : 'la')} ${medicoData?['titulo'] ?? ''} ${medicoData?['nombre'] ?? ''} ${medicoData?['primerApellido'] ?? ''} ${medicoData?['segundoApellido'] ?? ''}',
          style: GoogleFonts.comicNeue(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(controller: comentarioController, decoration: const InputDecoration(labelText: 'Comentario')),
              
              // TextField(
              //   controller: estatusController, 
              //   decoration: const InputDecoration(labelText: 'Estatus')),

              DropdownButtonFormField<String>(
                value: estatusController.text,
                decoration: InputDecoration(
                  labelText: 'Estatus',
                  labelStyle: GoogleFonts.comicNeue(fontSize: 16),
                ),
                items: [
                  {
                    'value': 'Registrada',
                    'icon': Icons.check_circle,
                    'color': Colors.green,
                  },
                  {
                    'value': 'Programada',
                    'icon': Icons.schedule,
                    'color': Colors.blue,
                  },
                  {
                    'value': 'Cancelada',
                    'icon': Icons.cancel,
                    'color': Colors.red,
                  },
                  {
                    'value': 'Reprogramada',
                    'icon': Icons.refresh,
                    'color': Colors.orange,
                  },
                  {
                    'value': 'En Proceso',
                    'icon': Icons.hourglass_empty,
                    'color': Colors.yellow,
                  },
                  {
                    'value': 'Realizada',
                    'icon': Icons.done_all,
                    'color': Colors.purple,
                  },
                  {
                    'value': 'Aprobado',
                    'icon': Icons.thumb_up,
                    'color': Colors.teal,
                  },
                ].map((item) {
                  return DropdownMenuItem<String>(
                    value: item['value'] as String?,
                    child: Row(
                      children: [
                        Icon(item['icon'] as IconData?, color: item['color'] as Color?), // Ícono con color
                        SizedBox(width: 10),
                        Text(item['value'] as String, style: GoogleFonts.comicNeue(fontSize: 16)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => estatusController.text = value ?? ''),
              ),




              // TextField(controller: tipoController, decoration: const InputDecoration(labelText: 'Tipo')),

              DropdownButtonFormField<String>(
                value: tipoController.text,
                decoration: InputDecoration(
                  labelText: 'Tipo',
                  labelStyle: GoogleFonts.comicNeue(fontSize: 16),
                ),
                items: [
                  {
                    'value': 'Servicio Interno',
                    'icon': Icons.local_hospital,
                    'color': Colors.blue,
                  },
                  {
                    'value': 'Traslados',
                    'icon': Icons.transfer_within_a_station,
                    'color': Colors.green,
                  },
                  {
                    'value': 'Subrogado',
                    'icon': Icons.people,
                    'color': Colors.orange,
                  },
                  {
                    'value': 'Administrativo',
                    'icon': Icons.account_balance,
                    'color': Colors.red,
                  },
                ].map((item) {
                  return DropdownMenuItem<String>(
                    value: item['value'] as String?,
                    child: Row(
                      children: [
                        Icon(item['icon'] as IconData?, color: item['color'] as Color?), // Icono con color
                        const SizedBox(width: 10),
                        Text(item['value'] as String, style: GoogleFonts.comicNeue(fontSize: 16)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => tipoController.text = value ?? ''),
              ),


              TextField(
                controller: fechaRegistroController,
                decoration: const InputDecoration(labelText: 'Fecha de Registro'),
                onTap: () async {
                  selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      fechaRegistroController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
                    });
                  }
                },
              ),
              TextField(
                controller: fechaAprobacionController,
                decoration: const InputDecoration(labelText: 'Fecha de Aprobación'),
                onTap: () async {
                  selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      fechaAprobacionController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
                    });
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _updateAprobacion(
                    item['id'],
                    comentarioController.text,
                    estatusController.text,
                    tipoController.text,
                    fechaRegistroController.text,
                    fechaAprobacionController.text,
                    item['Personal_Medico_ID'],
                    item['Solicitud_id'], // Asegúrate de pasar la solicitud al actualizar
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Actualizar'),
              ),

          ElevatedButton(
            onPressed: () {
              _showDeleteConfirmation(context, item['id']);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    ),
  );
},
  );
}


void _showDeleteConfirmation(BuildContext context, int id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('¿Estás seguro?'),
        content: const Text('¿Seguro que deseas eliminar esta aprobación? Esta acción no se puede deshacer.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el modal de confirmación
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _deleteAprobacion(id);
              Navigator.of(context).pop(); // Cierra el modal de confirmación
              Navigator.of(context).pop(); // Cierra el modal de opciones
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}



Future<void> _updateAprobacion(int id, String comentario, String estatus, String tipo, String fechaRegistro, String fechaAprobacion, int personalMedicoId, int solicitudId) async {
  try {
    final response = await http.put(
      Uri.parse('https://back-end-hospital2-0.onrender.com/tbb_aprobaciones/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'Comentario': comentario,
        'Estatus': estatus,
        'Tipo': tipo,
        'Fecha_Registro': fechaRegistro,
        'Fecha_Actualizacion': fechaAprobacion,
        'Personal_Medico_ID': personalMedicoId,
        'Solicitud_id': solicitudId,
      }),
    );
    if (response.statusCode == 200) {
      fetchAprobaciones(); // Recargar los datos después de la actualización
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Actualización exitosa')));
    } else {
      print('Error en la respuesta: ${response.body}');
      throw Exception('Error al actualizar');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  Future<void> _deleteAprobacion(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://back-end-hospital2-0.onrender.com/tbb_aprobaciones/$id'),
      );
      if (response.statusCode == 200) {
        fetchAprobaciones(); // Recargar los datos después de la eliminación
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Eliminación exitosa')));
      } else {
        throw Exception('Error al eliminar');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


//------------------Creacion del la Aprobación-------------------------------------------------------------------------------------------

Future<void> _createAprobacion(
    String comentario,
    String estatus,
    String tipo,
    String fechaRegistro,
    String fechaAprobacion,
    int personalMedicoId,
    int solicitudId
    ) async {
  try {
    if (comentario.isEmpty || estatus.isEmpty || tipo.isEmpty) {
      throw Exception('Por favor, complete todos los campos.');
    }

    final response = await http.post(
      Uri.parse('https://back-end-hospital2-0.onrender.com/tbb_aprobaciones/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'Personal_Medico_ID': personalMedicoId,
        'Solicitud_id': solicitudId,
        'Comentario': comentario,
        'Estatus': estatus,
        'Tipo': tipo,
        'Fecha_Registro': fechaRegistro,
        'Fecha_Actualizacion': fechaAprobacion,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      fetchAprobaciones(); // Recargar los datos después de la creación
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Creación exitosa')));
    } else {
      throw Exception('Error al crear la aprobación: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al crear la aprobación: ${e.toString()}')),
    );
  }
}







//--------------------------------------------------------------------------------------------------
// Opciones para el campo Tipo
List<String> tipos = [
  'Servicio Interno', 
  'Traslados', 
  'Subrogado', 
  'Administrativo'
  ];

// Opciones para el campo Estatus
List<String> estatus = [
  'Registrada',
  'Programada',
  'Cancelada',
  'Reprogramada',
  'En_Proceso',
  'Realizada',
  'Aprobado'
];

// Opciones para el campo Prioridad
final List<String> prioridades = [
  'Urgente', 'Alta', 'Moderada', 'Emergente', 'Normal'
];

// -----------------------------Activacion del modal de creacion de aprobacion--------------------------------------------

// Función para abrir el modal de creación de aprobación
Future<void> _createNewAprobacion(
  BuildContext context,
  String comentario,
  String estatus,
  String tipo,
  String fechaRegistro,
  String fechaAprobacion,
  int? personalMedicoId,
  int? solicitudId,
) async {
  try {
    if (comentario.isEmpty || estatus.isEmpty || tipo.isEmpty || fechaRegistro.isEmpty || fechaAprobacion.isEmpty || personalMedicoId == null || solicitudId == null) {// Se agrega la validación de fechaRegistro y fechaAprobacion
      throw Exception('Por favor, complete todos los campos.');
    }

    final response = await http.post(
      Uri.parse('https://back-end-hospital2-0.onrender.com/tbb_aprobaciones/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'Comentario': comentario,
        'Estatus': estatus,
        'Tipo': tipo,
        'Fecha_Registro': fechaRegistro,
        'Fecha_Actualizacion': fechaAprobacion,
        'Personal_Medico_ID': personalMedicoId,
        'Solicitud_id': solicitudId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final aprobacionesScreenState = context.findAncestorStateOfType<_AprobacionesScreen2State>();
      aprobacionesScreenState?.fetchAprobaciones();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Creación exitosa')));
      Navigator.of(context).pop();
    } else {
      throw Exception('Error al crear la aprobación: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear la aprobación: $e')));
  }
}


// -----------------------------Activacion del modal de creacion de aprobacion--------------------------------------------
void _showCreateAprobacionModal(BuildContext context) {
  final comentarioController = TextEditingController();
  final fechaRegistroController = TextEditingController();
  final fechaAprobacionController = TextEditingController();

  
  String? tipoSeleccionado;
  String? estatusSeleccionado;
  int? medicoSeleccionado;
  int? solicitudSeleccionado;
  

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(picked);
    }
  }


  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Crear Aprobación'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(controller: comentarioController, label: 'Comentario'),
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: tipos.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (String? nuevoTipo) {
                  tipoSeleccionado = nuevoTipo;
                },
              ),
              DropdownButtonFormField<String>(
                value: estatusSeleccionado,
                decoration: const InputDecoration(labelText: 'Estatus'),
                items: estatus.map((String estatusItem) {
                  return DropdownMenuItem<String>(
                    value: estatusItem,
                    child: Text(estatusItem),
                  );
                }).toList(),
                onChanged: (String? nuevoEstatus) {
                  estatusSeleccionado = nuevoEstatus;
                },
              ),
              GestureDetector(
                onTap: () => selectDate(context, fechaRegistroController),
                child: AbsorbPointer(
                  child: TextField(
                    controller: fechaRegistroController,
                    decoration: const InputDecoration(labelText: 'Fecha de Registro'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => selectDate(context, fechaAprobacionController),
                child: AbsorbPointer(
                  child: TextField(
                    controller: fechaAprobacionController,
                    decoration: const InputDecoration(labelText: 'Fecha de Aprobación'),
                  ),
                ),
              ),
              DropdownButtonFormField<int>(
                value: medicoSeleccionado,
                decoration: const InputDecoration(labelText: 'Seleccionar Médico'),
                items: listaMedicos.map((Doctor medico) {
                  return DropdownMenuItem<int>(
                    value: medico.id,
                    child: Text('${medico.nombre} ${medico.primerApellido} ${medico.segundoApellido}', style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
                onChanged: (int? nuevoMedico) {
                  medicoSeleccionado = nuevoMedico;
                },
              ),
              DropdownButtonFormField<int>(
                value: solicitudSeleccionado,
                decoration: const InputDecoration(labelText: 'Prioridad de la Solicitud'),
                items: solicitudesRealizadas.entries.map((entry) {
                  final solicitudId = entry.key;
                  final prioridad = entry.value['Prioridad'] ?? 'Sin Prioridad';  // Extrae la prioridad del JSON recibido

                  return DropdownMenuItem<int>(
                    value: solicitudId,
                    child: Text('ID: $solicitudId - Prioridad: $prioridad', style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
                onChanged: (int? nuevaSolicitud) {
                  setState(() {
                    solicitudSeleccionado = nuevaSolicitud;

                    // Accede a la prioridad de la solicitud seleccionada para usarla en tu lógica
                    final prioridadSeleccionada = solicitudesRealizadas[nuevaSolicitud]?['Prioridad'];
                    print('Prioridad seleccionada: $prioridadSeleccionada');
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
            if (comentarioController.text.isEmpty || 
                estatusSeleccionado == null || 
                tipoSeleccionado == null || 
                fechaRegistroController.text.isEmpty || 
                fechaAprobacionController.text.isEmpty || 
                medicoSeleccionado == null  ||
                solicitudSeleccionado == null
                )
                
                 {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, complete todos los campos.')));
              return;
            }

              _createNewAprobacion(
                context,
                comentarioController.text,
                estatusSeleccionado!,
                tipoSeleccionado!,
                fechaRegistroController.text,
                fechaAprobacionController.text,
                medicoSeleccionado!,
                solicitudSeleccionado!,
              );
            },
            child: const Text('Crear Aprobación'),
          ),
        ],
      );
    },
  );
}

// Función auxiliar para crear TextField
Widget _buildTextField({required TextEditingController controller, required String label}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
  );
}
}