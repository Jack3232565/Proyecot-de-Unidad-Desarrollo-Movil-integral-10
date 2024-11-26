import 'package:direccion_general_flutter/Drawer/costom_drawer.dart';
import 'package:direccion_general_flutter/View/Grafics/GrafiAprobaciones.dart';
import 'package:direccion_general_flutter/login_screean.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EstadisticaScreen extends StatefulWidget {
  final String area;
  final int personaId;

  const EstadisticaScreen({super.key, required this.area, required this.personaId});

  @override
  _EstadisticaScreenState createState() => _EstadisticaScreenState();
}

class _EstadisticaScreenState extends State<EstadisticaScreen> {
  late Future<Map<String, dynamic>> userDataFuture;
  Map<String, Map<String, int>> estatusTipoCount = {
    'Aprobado': {'Administrativo': 0, 'Traslados': 0, 'Servicio Interno': 0, 'Subrogado': 0},
    'En Proceso': {'Administrativo': 0, 'Traslados': 0, 'Servicio Interno': 0, 'Subrogado': 0},
    'Reprogramada': {'Administrativo': 0, 'Traslados': 0, 'Servicio Interno': 0, 'Subrogado': 0},
    'Pausado': {'Administrativo': 0, 'Traslados': 0, 'Servicio Interno': 0, 'Subrogado': 0},
    'Cancelada': {'Administrativo': 0, 'Traslados': 0, 'Servicio Interno': 0, 'Subrogado': 0},
    'Programada': {'Administrativo': 0, 'Traslados': 0, 'Servicio Interno': 0, 'Subrogado': 0},
    'Registrada': {'Administrativo': 0, 'Traslados': 0, 'Servicio Interno': 0, 'Subrogado': 0},
    'Realizada': {'Administrativo': 0, 'Traslados': 0, 'Servicio Interno': 0, 'Subrogado': 0},
  };

  List<RoleData> roleData = [];

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData(widget.personaId);
    fetchChartData();
    fetchRoleData();
  }

  Future<void> fetchChartData() async {
    try {
      final response = await http.get(
        Uri.parse('https://back-end-hospital2-0.onrender.com/tbb_aprobaciones/'),
      );
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        for (var item in data) {
          if (estatusTipoCount.containsKey(item['Estatus']) &&
              estatusTipoCount[item['Estatus']]!.containsKey(item['Tipo'])) {
            estatusTipoCount[item['Estatus']]![item['Tipo']] =
                estatusTipoCount[item['Estatus']]![item['Tipo']]! + 1;
          }
        }
      });
    } catch (e) {
      print("Error fetching chart data: $e");
    }
  }

  Future<void> fetchRoleData() async {
    try {
      final rolesResponse = await http.get(Uri.parse('https://back-end-hospital2-0.onrender.com/roles/'));
      final userRolesResponse = await http.get(Uri.parse('https://back-end-hospital2-0.onrender.com/usuario_roles/'));

      final List<dynamic> roles = jsonDecode(rolesResponse.body);
      final List<dynamic> userRoles = jsonDecode(userRolesResponse.body);

      Map<String, int> roleCounts = {};

      for (var role in roles) {
        final roleId = role['id'];
        final roleName = role['Nombre'];
        final count = userRoles.where((userRole) => userRole['Rol_ID'] == roleId).length;
        roleCounts[roleName] = count;
      }

      setState(() {
        roleData = roleCounts.entries.map((entry) => RoleData(entry.key, entry.value)).toList();
      });
    } catch (error) {
      print("Error fetching role data: $error");
    }
  }

  List<ChartData> generateChartData() {
    List<ChartData> chartData = [];
    estatusTipoCount.forEach((estatus, tipos) {
      tipos.forEach((tipo, count) {
        chartData.add(ChartData(estatus, tipo, count.toDouble()));
      });
    });
    return chartData;
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
              'Estadisticas',
              style: GoogleFonts.comicNeue(fontSize: 15),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      ),
    ),
    drawer: Drawer(
      child: CustomDrawer(
        userDataFuture: userDataFuture,
        area: widget.area,
        personaId: widget.personaId,
        logout: _logout,
      ),
    ),
    body: SingleChildScrollView( // Agregar SingleChildScrollView para permitir el desplazamiento
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Área: ${widget.area}',
              style: GoogleFonts.comicNeue(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Registro de Estadisticas',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            GraficoAprobaciones(chartData: generateChartData()), // Primer gráfico
            const SizedBox(height: 10),
            SfCircularChart(
              title: ChartTitle(text: 'Distribución de Usuarios por Rol'),
              legend: Legend(isVisible: true, position: LegendPosition.left),
              series: <CircularSeries>[
                PieSeries<RoleData, String>(
                  dataSource: roleData,
                  xValueMapper: (RoleData data, _) => data.role,
                  yValueMapper: (RoleData data, _) => data.count,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ), // Segundo gráfico
            const SizedBox(height: 20), // Espacio adicional si es necesario
          ],
        ),
      ),
    ),
  );
}
}
// Removed duplicate ChartData class definition


class RoleData {
  final String role;
  final int count;

  RoleData(this.role, this.count);
}
