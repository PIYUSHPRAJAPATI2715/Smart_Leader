import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/ShowGraph.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Screen/bar_graph_detail_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncLineChartWidget extends StatefulWidget {

  const SyncLineChartWidget({Key? key}) : super(key: key);

  @override
  State<SyncLineChartWidget> createState() => _SyncLineChartWidgetState();
}

class _SyncLineChartWidgetState extends State<SyncLineChartWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  Provider.of<AppController>(context, listen: false).getBarGraphList();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          data.isGraphSearch
              ? const Center(child: CircularProgressIndicator())
              : Visibility(
                  visible: data.currentMonthCharList.isNotEmpty,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              decoration:BoxDecoration(
                                  border: Border.all(color: KBoxNewColor,width: 1)
                              ),
                              child: Column(
                                children: [
                                  // Row(
                                  //
                                  //   children: [
                                  //     Expanded(
                                  //       child: customtext(
                                  //         fontWeight: FontWeight.w700,
                                  //         text: data
                                  //             .currentMonthCharList[index].branchName!,
                                  //         fontsize: 14.0,
                                  //         color: Theme.of(context).primaryColor,
                                  //       ),
                                  //     ),
                                  //     TextButton(
                                  //       onPressed: () {
                                  //         Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //                 builder: (context) =>
                                  //                     BarGraphDetailScreen(
                                  //                         type: 'line',
                                  //                         showGraph: data
                                  //                             .teamGraphList[index])));
                                  //       },
                                  //       child: customtext(
                                  //         fontWeight: FontWeight.w500,
                                  //         text: 'View Detail',
                                  //         fontsize: 14.0,
                                  //         color: Theme.of(context).primaryColor,
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BarGraphDetailScreen(
                                                      type: 'line',
                                                      showGraph: data
                                                          .teamGraphList[index])));
                                    },
                                    child: Row(
                                      children: [
                                        Container(

                                          child: Padding(
                                            padding:  EdgeInsets.only(left: 10.0,right: 10,bottom: 4,top: 4),
                                            child:  customtext(
                                              fontWeight: FontWeight.w700,
                                              text: data
                                                  .currentMonthCharList[index].branchName!,
                                              fontsize: 14.0,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.shade200,
                                            borderRadius:BorderRadius.all(Radius.circular(3)),
                                          ),
                                          margin: EdgeInsets.all(15),
                                        ),
                                        Spacer(),

                                        Container(

                                          child: Padding(
                                            padding:  EdgeInsets.only(left: 10.0,right: 10,bottom: 4,top: 4),
                                            child:customtext(
                                              fontWeight: FontWeight.w500,
                                              text: 'View Detail',
                                              fontsize: 14.0,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.shade200,
                                            borderRadius:BorderRadius.all(Radius.circular(3)),
                                          ),
                                          margin: EdgeInsets.all(15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: SfCartesianChart(
                                      // isTransposed: true,
                                      zoomPanBehavior:
                                          ZoomPanBehavior(enablePanning: false),
                                      primaryXAxis: CategoryAxis(),
                                      series: <ChartSeries>[
                                        SplineSeries<ChartData, String>(
                                            color: kblueColor,
                                            dataSource: data
                                                .currentMonthCharList[index].chartList!,
                                            xValueMapper: (ChartData data, _) =>
                                                data.month,
                                            yValueMapper: (ChartData data, _) => data.y,
                                            emptyPointSettings: EmptyPointSettings(
                                                // Mode of empty point
                                                mode: EmptyPointMode.average),
                                            dataLabelSettings: DataLabelSettings(
                                                labelAlignment:
                                                    ChartDataLabelAlignment.outer,
                                                isVisible: true,
                                                // Templating the data label
                                                builder: (dynamic data,
                                                    dynamic point,
                                                    dynamic series,
                                                    int pointIndex,
                                                    int seriesIndex) {
                                                  ChartData chartData = data;
                                                  return SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: customtext(
                                                          fontWeight: FontWeight.w400,
                                                          text: "${chartData.amount}",
                                                          fontsize: 7));
                                                }),
                                            markerSettings:
                                                const MarkerSettings(isVisible: true)),
                                        SplineSeries<ChartData, String>(
                                            color: const Color(0xffAFAEFE),
                                            dataLabelSettings: DataLabelSettings(
                                                labelAlignment:
                                                    ChartDataLabelAlignment.auto,
                                                isVisible: true,
                                                // Templating the data label
                                                builder: (dynamic data,
                                                    dynamic point,
                                                    dynamic series,
                                                    int pointIndex,
                                                    int seriesIndex) {
                                                  ChartData chartData = data;
                                                  return SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: customtext(
                                                          fontWeight: FontWeight.w400,
                                                          text:
                                                              "${chartData.readableCompleteAmount}",
                                                          fontsize: 7));
                                                }),
                                            dataSource: data
                                                .currentMonthCharList[index].chartList!,
                                            xValueMapper: (ChartData data, _) =>
                                                data.month,
                                            yValueMapper: (ChartData data, _) => data.y1,
                                            emptyPointSettings: EmptyPointSettings(
                                                // Mode of empty point
                                                mode: EmptyPointMode.average),
                                            markerSettings:
                                                const MarkerSettings(isVisible: true)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xffC3C3C3)),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          customtext(
                                            fontWeight: FontWeight.w500,
                                            text: "Target Business",
                                            fontsize: 13,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(
                                                  0xffA8F3AE,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          customtext(
                                            fontWeight: FontWeight.w500,
                                            text: "Actual Business",
                                            fontsize: 13,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                          ],
                        );
                      },
                      shrinkWrap: true,
                      itemCount: data.teamGraphList.length,
                    ),
                  ),
                ),
          const SizedBox(height: 25.0),
        ],
      ),
    );
  }
}
/*
 isSubLoading
              ? const Center(child: CircularProgressIndicator())
              : Visibility(
            visible: subTeamChartData.isNotEmpty,
                child: Column(
                    children: [
                      SfCartesianChart(
                          // isTransposed: true,
                          primaryXAxis: CategoryAxis(),
                          series: <ChartSeries>[
                            SplineSeries<ChartData, String>(
                                color: kblueColor,
                                dataSource: subTeamChartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                emptyPointSettings: EmptyPointSettings(
                                    // Mode of empty point
                                    mode: EmptyPointMode.average),
                                dataLabelSettings: DataLabelSettings(
                                    labelAlignment: ChartDataLabelAlignment.outer,
                                    isVisible: true,
                                    // Templating the data label
                                    builder: (dynamic data,
                                        dynamic point,
                                        dynamic series,
                                        int pointIndex,
                                        int seriesIndex) {
                                      return SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: customtext(
                                              fontWeight: FontWeight.w400,
                                              text: "",
                                              fontsize: 7));
                                    }),
                                markerSettings:
                                    const MarkerSettings(isVisible: true)),
                            SplineSeries<ChartData, String>(
                                color: const Color(0xffAFAEFE),
                                dataLabelSettings: DataLabelSettings(
                                    labelAlignment: ChartDataLabelAlignment.auto,
                                    isVisible: true,
                                    // Templating the data label
                                    builder: (dynamic data,
                                        dynamic point,
                                        dynamic series,
                                        int pointIndex,
                                        int seriesIndex) {
                                      return SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: customtext(
                                              fontWeight: FontWeight.w400,
                                              text: "",
                                              fontsize: 7));
                                    }),
                                dataSource: subTeamChartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y1,
                                emptyPointSettings: EmptyPointSettings(
                                    // Mode of empty point
                                    mode: EmptyPointMode.average),
                                markerSettings:
                                    const MarkerSettings(isVisible: true)),
                          ]),
                      const SizedBox(height: 15.0),
                      Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    margin: const EdgeInsets.only(left: 15),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kblueColor),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  customtext(
                                    fontWeight: FontWeight.w500,
                                    text: "Target",
                                    fontsize: 13,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    margin: const EdgeInsets.only(left: 15),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(
                                          0xffAFAEFE,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  customtext(
                                    fontWeight: FontWeight.w500,
                                    text: "Actual",
                                    fontsize: 13,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
                    ],
                  ),
              )
 */

// class ChartData {
//   ChartData(this.x, this.y, this.y1, this.y2, this.y3, this.month);
//
//   final String x;
//   final double? y;
//   final double? y1;
//   final double? y2;
//   final double? y3;
//   final String? month;
// }

/*
ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child:  Column(
              children: [
                Row(children: [
                  Expanded(
                    child: customtext(
                      fontWeight: FontWeight.w700,
                      text: "Report",
                      fontsize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditChartScreen()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: klightgrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        child: Center(
                          child: Row(
                            children: [
                              customtext(
                                fontWeight: FontWeight.w400,
                                text: "Edit",
                                fontsize: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(width: 4,),
                              Image.asset("assest/png_icon/edit_icon.png",height: 17,width: 17,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],),
                SizedBox(height: 15,),
                Container(
                    height: 200,
                    child: SfCartesianChart(
                      // isTransposed: true,
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries>[
                          SplineSeries<ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              emptyPointSettings: EmptyPointSettings(
                                // Mode of empty point
                                  mode: EmptyPointMode.average
                              ),
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
                              markerSettings: MarkerSettings(
                                  isVisible: true
                              )
                          ),
                          SplineSeries<ChartData, String>(
                              dataLabelSettings: DataLabelSettings(
                                  labelAlignment: ChartDataLabelAlignment.auto,
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
                                        child: customtext(fontWeight: FontWeight.w400, text: "TeamB", fontsize: 7));
                                  }),
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y1,
                              emptyPointSettings: EmptyPointSettings(
                                // Mode of empty point
                                  mode: EmptyPointMode.average
                              ),
                              markerSettings: MarkerSettings(
                                  isVisible: true
                              )
                          ),
                          SplineSeries<ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y2,
                              emptyPointSettings: EmptyPointSettings(
                                // Mode of empty point
                                  mode: EmptyPointMode.average
                              ),
                              markerSettings: MarkerSettings(
                                  isVisible: true
                              )
                          ),
                          SplineSeries<ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y3,
                              emptyPointSettings: EmptyPointSettings(
                                // Mode of empty point
                                  mode: EmptyPointMode.average
                              ),
                              markerSettings: MarkerSettings(
                                  isVisible: true
                              )
                          )
                        ]
                    )
                ),
                SizedBox(height: 15,),
                Row(children: [
                  Expanded(
                      child: Row(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  margin: EdgeInsets.only(left:15),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kblueColor),
                                ),
                                SizedBox(width:10,),
                                customtext(
                                  fontWeight: FontWeight.w500,
                                  text: "Target",
                                  fontsize: 13,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  margin: EdgeInsets.only(left:15),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(
                                        0xffAFAEFE,
                                      )),
                                ),
                                SizedBox(width:10,),
                                customtext(
                                  fontWeight: FontWeight.w500,
                                  text: "Actual",
                                  fontsize: 13,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: klightgrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      child: Center(
                        child: Row(
                          children: [
                            customtext(
                              fontWeight: FontWeight.w400,
                              text: "Analytics",
                              fontsize: 15,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 4,),
                            Image.asset("assest/png_icon/analysis_icon.png",height: 17,width: 17,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],),
              ],
            ),
          );
        })
 */
