import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenditureAnalysisScreen extends StatefulWidget {
  const ExpenditureAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<ExpenditureAnalysisScreen> createState() =>
      _ExpenditureAnalysisScreenState();
}

class _ExpenditureAnalysisScreenState extends State<ExpenditureAnalysisScreen> {


  final List<ChartData> chartData = <ChartData>[
    ChartData('Jan', 128, 129, 101),
    ChartData('Feb', 123, 92, 93),
    ChartData('Mar', 107, 106, 90),
    ChartData('Apr', 87, 95, 71),
    ChartData('Jan', 128, 129, 101),
    ChartData('Feb', 123, 92, 93),
    ChartData('Mar', 107, 106, 90),
    ChartData('Apr', 87, 95, 71),
  ];
  // final List<ChartData> chartData1 = <ChartData>[
  //   ChartData('Jan', 128, 129, 101),
  //   ChartData('Feb', 123, 92, 93),
  //   ChartData('Mar', 107, 106, 90),
  //   ChartData('Apr', 87, 95, 71),
  // ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 102,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image:
                    AssetImage("assest/images/OnBordScreenTopScreen.png"),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: kWhiteColor,
                      )),
                  Expanded(
                    child: Center(
                      child: customtext(
                        fontWeight: FontWeight.w500,
                        text: "Smart Leader",
                        fontsize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {

                        Navigator.pop(context);

                      },
                      child: Image.asset(
                        "assest/png_icon/home_removebg_preview.png",
                        height: 25,
                        width: 25,
                      ))

                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customtext(
                  fontWeight: FontWeight.w700,
                  text: "Week Analysis",
                  fontsize: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 20,),
                Container(
                  height: 400,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SfCartesianChart(
                        enableAxisAnimation: true,
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePanning: true,
                        ),
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          header: 'Heart Rate (bpm)',
                        ),
                        primaryXAxis: CategoryAxis(
                          labelStyle: const TextStyle(fontSize: 15),
                          maximumLabels: chartData.length,
                          autoScrollingDelta: chartData.length,
                          majorGridLines: const MajorGridLines(width: 0),
                          majorTickLines: const MajorTickLines(width: 0),
                        ),
                        series: <CartesianSeries>[
                          // ColumnSeries<ChartData, String>(
                          //     legendItemText: "TeamA",
                          //     xAxisName: "shush",
                          //     color: kblueColor,
                          //     borderRadius: BorderRadius.only(
                          //         topRight: Radius.circular(3),
                          //         topLeft: Radius.circular(3)),
                          //     dataSource: chartData,
                          //     xValueMapper: (ChartData data, _) => data.x,
                          //     yValueMapper: (ChartData data, _) => data.y),
                          // ColumnSeries<ChartData, String>(
                          //     color: Color(0xffAFAEFE),
                          //     borderRadius: BorderRadius.only(
                          //         topRight: Radius.circular(3),
                          //         topLeft: Radius.circular(3)),
                          //     dataSource: chartData,
                          //     xValueMapper: (ChartData data, _) => data.x,
                          //     yValueMapper: (ChartData data, _) => data.y1),
                          ColumnSeries<ChartData, String>(
                              emptyPointSettings: EmptyPointSettings(
                                // Mode of empty point
                                  mode: EmptyPointMode.average),
                            width: .3,
                            trackPadding: 10,
                              color: kblueColor,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5)),
                              dataSource: chartData,

                              dataLabelMapper: (ChartData data, _) => data.x,
                              dataLabelSettings: DataLabelSettings(
                                  labelAlignment: ChartDataLabelAlignment.outer,
                                  isVisible: true,
                                  // Templating the data label

                                  builder: (dynamic data,
                                      dynamic point,
                                      dynamic series,
                                      int pointIndex,
                                      int seriesIndex) {
                                    return Container(
                                        height: 30,
                                        width: 30,
                                        child: customtext(fontWeight: FontWeight.w400, text: "TeamA", fontsize: 7));
                                  }),
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y),

                          // ColumnSeries<ChartData, String>(
                          //     color: Color(0xffAFAEFE),
                          //     borderRadius: BorderRadius.only(
                          //         topRight: Radius.circular(3),
                          //         topLeft: Radius.circular(3)),
                          //     dataLabelMapper: (ChartData data, _) => data.x,
                          //     dataSource: chartData1,
                          //     dataLabelSettings: DataLabelSettings(
                          //         labelAlignment: ChartDataLabelAlignment.outer,
                          //         isVisible: true,
                          //         // Templating the data label
                          //         builder: (dynamic data,
                          //             dynamic point,
                          //             dynamic series,
                          //             int pointIndex,
                          //             int seriesIndex) {
                          //           return Container(
                          //               height: 30,
                          //               width: 30,
                          //               child: customtext(
                          //                 fontWeight: FontWeight.w400,
                          //                 text: "TeamA",
                          //                 fontsize: 7,
                          //                 color: kblueColor,
                          //               ));
                          //         }),
                          //     xValueMapper: (ChartData data, _) => data.x,
                          //     yValueMapper: (ChartData data, _) => data.y1),
                        ]),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2);

  final String x;
  final double? y;
  final double? y1;
  final double? y2;
}
