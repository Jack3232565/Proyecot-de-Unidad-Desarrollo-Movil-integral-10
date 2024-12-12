import 'package:direccion_general_flutter/Drawer/google_costom_drawer.dart';
import 'package:direccion_general_flutter/login_screean.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BitacoraScreen2 extends StatefulWidget {
  final String area;
  final GoogleSignInAccount user; // Agrega el parámetro de usuario

  BitacoraScreen2({required this.area, required this.user});

  @override
  _BitacoraScreen2State createState() => _BitacoraScreen2State();
}


class _BitacoraScreen2State extends State<BitacoraScreen2> {

late Future<Map<String, dynamic>> userDataFuture; // Cambiado a late para inicializar en initState

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  List<dynamic> solicitudes = [];
  String searchInput = "";
  int currentPage = 1;
  int resultsPerPage = 10;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSolicitudes();
  }

  Future<void> fetchSolicitudes() async {
    final apiUrl = 'https://back-end-hospital2-0.onrender.com/bitacora/';
    final token = 'Bearer ${await _getToken()}';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        setState(() {
          solicitudes = json.decode(Utf8Decoder().convert(response.bodyBytes));
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  String formatDate(String? date) {
    if (date == null) return "Fecha no registrada";
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(parsedDate);
    } catch (e) {
      return "Fecha inválida";
    }
  }

  // Método para mostrar el diálogo con todos los detalles de la fila
  void _showDetailsDialog(Map<String, dynamic> solicitud) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles de la Solicitud'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${solicitud['ID']}'),
                Text('Usuario: ${solicitud['Usuario'] ?? 'No disponible'}'),
                Text('Operación: ${solicitud['Operacion'] ?? 'No especificada'}'),
                Text('Tabla: ${solicitud['Tabla'] ?? 'No definida'}'),
                Text('Descripción: ${solicitud['Descripcion'] ?? 'Sin descripción'}'),
                Text('Estatus: ${solicitud['Estatus'] == true ? 'Activo' : 'Inactivo'}'),
                Text('Fecha de Registro: ${formatDate(solicitud['Fecha_Registro'])}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginatedData = solicitudes
        .where((solicitud) => solicitud.values
            .any((value) => value.toString().toLowerCase().contains(searchInput.toLowerCase())))
        .skip((currentPage - 1) * resultsPerPage)
        .take(resultsPerPage)
        .toList();

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
              'Bitácora',
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




      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchInput = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.blue,
                        ),
                        headingTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                        columns: const [
                          DataColumn(label: Text('No°')),
                          DataColumn(label: Text('Usuario')),
                          DataColumn(label: Text('Operación')),
                          DataColumn(label: Text('Tabla')),
                          DataColumn(label: Text('Descripción')),
                          DataColumn(label: Text('Estatus')),
                          DataColumn(label: Text('Fecha de Registro')),
                          DataColumn(label: Text('Acciones')),
                        ],
                        rows: paginatedData.map((solicitud) {
                          Icon operacionIcon;
                          switch (solicitud['Operacion']) {
                            case 'Create':
                              operacionIcon = Icon(Icons.check, color: Colors.green);
                              break;
                            case 'Update':
                              operacionIcon = Icon(Icons.update, color: Colors.yellow);
                              break;
                            case 'Delete':
                              operacionIcon = Icon(Icons.close, color: Colors.red);
                              break;
                            default:
                              operacionIcon = Icon(Icons.help_outline, color: Colors.grey);
                          }

                          return DataRow(cells: [
                            DataCell(Text(solicitud['ID']?.toString() ?? '0')),
                            DataCell(Text(solicitud['Usuario'] ?? 'No disponible')),
                            DataCell(Row(
                              children: [
                                Text(solicitud['Operacion'] ?? 'No especificada'),
                                SizedBox(width: 5),
                                operacionIcon,
                              ],
                            )),
                            DataCell(Text(solicitud['Tabla'] ?? 'No definida')),
                            DataCell(
                              Container(
                                width: 150,
                                child: Text(
                                  solicitud['Descripcion'] ?? 'Sin descripción',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              (solicitud['Estatus'] == true)
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : const Icon(Icons.add_task_outlined, color: Color.fromARGB(255, 244, 225, 54)),
                            ),
                            DataCell(Text(formatDate(solicitud['Fecha_Registro']))),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  _showDetailsDialog(solicitud); // Mostrar el diálogo con detalles
                                },
                                child: Text('Ver'),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentPage > 1
                            ? () {
                                setState(() {
                                  currentPage--;
                                });
                              }
                            : null,
                        child: const Text('Anterior'),
                      ),
                      ElevatedButton(
                        onPressed: solicitudes.length > currentPage * resultsPerPage
                            ? () {
                                setState(() {
                                  currentPage++;
                                });
                              }
                            : null,
                        child: const Text('Siguiente'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
