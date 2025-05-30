import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/join_team.dart';
import 'package:smart_leader/Screen/joined_bar_graph_detail_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Helper/helper.dart';
import '../Modal/ShowGraph.dart';

class BusinessJoinerFragment extends StatefulWidget {
  const BusinessJoinerFragment({Key? key}) : super(key: key);

  @override
  State<BusinessJoinerFragment> createState() => _BusinessJoinerFragmentState();
}

class _BusinessJoinerFragmentState extends State<BusinessJoinerFragment> {
  List<String> frequencyContainer = ["Bar Chart", "Line Chart"];

  int selectedChart = 0;

  late Future<JoinedTeam> joinedFuture;

  Future<JoinedTeam> getJoinedTeam() {
    //SessionManager.getUserID()
    Map<String, String> body = {'user_id': SessionManager.getUserID()};
    return ApiHelper.myJoinTeam(body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    joinedFuture = getJoinedTeam();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          const SizedBox(height: 2),
          // Row(
          //     children: List.generate(
          //   growable: true,
          //   frequencyContainer.length,
          //   (index) => InkWell(
          //     onTap: () {
          //       //data.getchartContainer(index);
          //       setState(() {
          //         selectedChart = index;
          //       });
          //     },
          //     child: Card(
          //       color: SessionManager.getTheme() == true
          //           ? kscafolledColor
          //           : kWhiteColor,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(20)),
          //       child: Container(
          //         decoration: BoxDecoration(
          //             gradient: SessionManager.getTheme() == true
          //                 ? selectedChart == index
          //                     ? kGradient
          //                     : kgreyGradient
          //                 : selectedChart == index
          //                     ? kGradient
          //                     : k2Gradient,
          //             borderRadius: BorderRadius.circular(40),
          //             border: Border.all(
          //                 color: SessionManager.getTheme() == true
          //                     ? kscafolledColor
          //                     : kblueColor)),
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 22, vertical: 10),
          //           child: Center(
          //             child: customtext(
          //               fontWeight: FontWeight.w400,
          //               text: frequencyContainer[index],
          //               fontsize: 12,
          //               color: selectedChart == index
          //                   ? kWhiteColor
          //                   : Theme.of(context).primaryColor,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // )),
          Expanded(
            child: FutureBuilder<JoinedTeam>(
              future: joinedFuture,
              builder: (context, response) {
                if (response.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<JoinedTeamData> teamList = response.data!.data!;

                if (teamList.isEmpty) {
                  return Center(
                    child: customtext(
                        fontWeight: FontWeight.w500,
                        text: 'No Data found',
                        fontsize: 12.0),
                  );
                }

                List<ChartData>? chartList = [];

                for (var team in teamList) {
                  String readableAmount = Helper.formatUnitType(
                      int.parse(team.memberTarget ?? '0'));
                  String readableComplete = Helper.formatUnitType(
                      int.parse(team.memberCompleted ?? '0'));
                  double target = double.parse(team.memberTarget!);
                  double completed = double.parse(team.memberCompleted ?? '0');
                  chartList.add(ChartData(
                      team.teamName ?? '',
                      target,
                      completed,
                      readableAmount,
                      team.monthYear ?? '',
                      readableComplete,
                      teamId: team.memberUnqiueId));
                }

                return
                     getBarChart(chartList);

              },
            ),
          )
        ],
      ),
    );
  }

  Widget getBarChart(List<ChartData>? chartList) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: chartList!.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 15.0),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        margin: const EdgeInsets.only(left: 15),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color( 0xffC3C3C3)),
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
                        margin: const EdgeInsets.only(left: 15),
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



              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Expanded(
              //       child: customtext(
              //         fontWeight: FontWeight.w700,
              //         text: chartList[index].x,
              //         fontsize: 14.0,
              //         color: Theme.of(context).primaryColor,
              //       ),
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => JoinedBarGraphDetailScreen(
              //                       type: 'bar',
              //                       teamId: chartList[index].teamId!,
              //                     )));
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
              const SizedBox(height: 8.0),
              Container(
                decoration:BoxDecoration(
                  border: Border.all(color: KBoxNewColor,width: 1)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JoinedBarGraphDetailScreen(
                                                  type: 'bar',
                                                  teamId: chartList[index].teamId!,
                                                )));
                      },
                      child: Row(
                        children: [
                          Container(

                            child: Padding(
                              padding:  EdgeInsets.only(left: 10.0,right: 10,bottom: 4,top: 4),
                              child: customtext(
                                fontWeight: FontWeight.w700,
                                text: chartList[index].x,
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
                          zoomPanBehavior: ZoomPanBehavior(enablePanning: false),
                          primaryXAxis: CategoryAxis(),
                          series: <CartesianSeries>[
                            ColumnSeries<ChartData, String>(
                                color: Color(0xffC3C3C3),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(3),
                                    topLeft: Radius.circular(3)),
                                dataSource: chartList,
                                xValueMapper: (ChartData data, _) =>
                                    chartList[index].month,
                                yValueMapper: (ChartData data, _) =>
                                    chartList[index].y,
                                dataLabelSettings: DataLabelSettings(
                                    labelAlignment: ChartDataLabelAlignment.auto,
                                    isVisible: true,
                                    // Templating the data label
                                    builder: (dynamic data,
                                        dynamic point,
                                        dynamic series,
                                        int pointIndex,
                                        int seriesIndex) {
                                      ChartData chartData = data;
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 40.0),
                                        child: customtext(
                                            fontWeight: FontWeight.w600,
                                            text: "${chartList[index].amount}",
                                            color: Colors.black,
                                            fontsize: 10),
                                      );
                                    })),
                            ColumnSeries<ChartData, String>(
                                color: const Color(0xffAFAEFE),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(3),
                                    topLeft: Radius.circular(3)),
                                dataSource: chartList,
                                xValueMapper: (ChartData data, _) =>
                                    chartList[index].month,
                                yValueMapper: (ChartData data, _) =>
                                    chartList[index].y1,
                                dataLabelSettings: DataLabelSettings(
                                    labelAlignment: ChartDataLabelAlignment.auto,
                                    isVisible: true,
                                    // Templating the data label
                                    builder: (dynamic data,
                                        dynamic point,
                                        dynamic series,
                                        int pointIndex,
                                        int seriesIndex) {
                                      ChartData chartData = data;
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 40),
                                        child: customtext(
                                            fontWeight: FontWeight.w600,
                                            text:
                                                "${chartList[index].readableCompleteAmount}",
                                            color: Colors.purple,
                                            fontsize: 10),
                                      );
                                    })),
                          ]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15.0),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,

          );
        },
      ),
    );
  }

  Widget getLineChart(List<ChartData>? chartList) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: chartList!.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: customtext(
                      fontWeight: FontWeight.w700,
                      text: chartList[index].x,
                      fontsize: 14.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JoinedBarGraphDetailScreen(
                                  type: 'line',
                                  teamId: chartList[index].teamId!)));
                    },
                    child: customtext(
                      fontWeight: FontWeight.w500,
                      text: 'View Detail',
                      fontsize: 14.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                child: SfCartesianChart(
                  // isTransposed: true,
                  zoomPanBehavior: ZoomPanBehavior(enablePanning: false),
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    SplineSeries<ChartData, String>(
                        color: kblueColor,
                        dataSource: chartList,
                        xValueMapper: (ChartData data, _) => data.month,
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
                              ChartData chartData = data;
                              return SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: customtext(
                                      fontWeight: FontWeight.w400,
                                      text: "${chartData.amount}",
                                      fontsize: 7));
                            }),
                        markerSettings: const MarkerSettings(isVisible: true)),
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
                        dataSource: chartList,
                        xValueMapper: (ChartData data, _) => data.month,
                        yValueMapper: (ChartData data, _) => data.y1,
                        emptyPointSettings: EmptyPointSettings(
                            // Mode of empty point
                            mode: EmptyPointMode.average),
                        markerSettings: const MarkerSettings(isVisible: true)),
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
                              margin: const EdgeInsets.only(left: 15),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: kblueColor),
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
            ],
          );
        },
      ),
    );
  }
}
