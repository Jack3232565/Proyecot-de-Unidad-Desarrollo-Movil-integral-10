import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AreaSelector extends StatefulWidget {
  final Function(String?) onAreaSelected; // Callback para manejar el área seleccionada
  const AreaSelector({super.key, required this.onAreaSelected});

  @override
  _AreaSelectorState createState() => _AreaSelectorState();
}

class _AreaSelectorState extends State<AreaSelector> {
  String? _selectedArea;
  List<String> _areas = [];

  @override
  void initState() {
    super.initState();
    _fetchAreas();
  }

  Future<void> _fetchAreas() async {
    try {
      final response = await http.get(Uri.parse('https://back-end-hospital2-0.onrender.com/departamentos/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _areas = data.map((area) => area['Nombre'] as String).toList();
        });
      } else {
        throw Exception('Error al cargar las áreas');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las áreas: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedArea,
      hint: Text('Seleccione un Área', style: GoogleFonts.comicNeue(fontSize: 16)),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.area_chart),
      ),
      items: _areas.map((String area) {
        return DropdownMenuItem<String>(
          value: area,
          child: Text(area, style: GoogleFonts.comicNeue(fontSize: 16)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedArea = newValue;
          widget.onAreaSelected(newValue);
        });
      },
    );
  }
}
