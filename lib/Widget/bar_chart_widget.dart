// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'dart:math';
//
// class BarChartWidget extends StatefulWidget {
//   const BarChartWidget({Key? key}) : super(key: key);
//
//   @override
//   State<BarChartWidget> createState() => _BarChartWidgetState();
// }
//
// class _BarChartWidgetState extends State<BarChartWidget> {
//
//   late List<charts.Series<Sales, String>> seriesList;
//
//   static List<charts.Series<Sales, String>> _createRandomData() {
//     final random = Random();
//
//     final desktopSalesData = [
//     Sales('2015', random.nextInt(1000)),
//     Sales('2016', random.nextInt(1000)),
//     Sales('2017', random.nextInt(1000)),
//     Sales('2018', random.nextInt(1000)),
//     Sales('2019', random.nextInt(1000)),
//     ];
//
//     final tabletSalesData = [
//       Sales('2015', random.nextInt(1000)),
//       Sales('2016', random.nextInt(1000)),
//       Sales('2017', random.nextInt(1000)),
//       Sales('2018', random.nextInt(1000)),
//       Sales('2019', random.nextInt(1000)),
//     ];
//
//
//
//     return [
//     charts.Series<Sales, String>(
//     id: "Sales",
//     domainFn: (Sales sales, _) => sales.year,
//     measureFn: (Sales sales, _) => sales.sales,
//     data: desktopSalesData,
//     // fillColorFn: (Sales sales, _) {
//     // return charts.MaterialPalette.blue.shadeDefault;
//     // },
//     ),
//     charts.Series<Sales, String>(
//     id: "Sales",
//     domainFn: (Sales sales, _) => sales.year,
//     measureFn: (Sales sales, _) => sales.sales,
//     data: tabletSalesData,
//     // fillColorFn: (Sales sales, _) {
//     // return charts.MaterialPalette.green.shadeDefault;
//     // },
//     ),
//
//     ];
//   }
//
//   barChart() {
//     return charts.BarChart(
//       seriesList,
//       animate: true,
//       vertical: true,
//       barGroupingType: charts.BarGroupingType.grouped,
//       defaultRenderer: charts.BarRendererConfig(
//         groupingType: charts.BarGroupingType.grouped,
//         strokeWidthPx:0,
//       ),
//       domainAxis: charts.OrdinalAxisSpec(
//         renderSpec: charts.NoneRenderSpec(),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     seriesList = _createRandomData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(height: 250,width: double.infinity,
//         child: barChart(),
//         )
//       ],
//     );
//   }
// }
// class Sales {
//   final String year;
//   final int sales;
//
//   Sales(this.year, this.sales);
// }
//
