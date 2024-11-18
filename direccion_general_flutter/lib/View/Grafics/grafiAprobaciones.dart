// grafiAprobaciones.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String estatus;
  final String tipo;
  final double count;

  ChartData(this.estatus, this.tipo, this.count);
}

class GraficoAprobaciones extends StatelessWidget {
  final List<ChartData> chartData;

  const GraficoAprobaciones({super.key, required this.chartData});

@override
Widget build(BuildContext context) {
  return SizedBox(
    height: 300,
    width: 500,
    child: SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelStyle: const TextStyle(
          fontSize: 5, // Ajusta el tamaño del texto de las etiquetas en el eje X
        ),
      ),
      primaryYAxis: NumericAxis(),
      legend: Legend(isVisible: false),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => '${data.estatus} ',
          yValueMapper: (ChartData data, _) => data.count,
          name: 'Estadísticas',
          color: Colors.blue,
        ),
      ],
    ),
  );
}
}