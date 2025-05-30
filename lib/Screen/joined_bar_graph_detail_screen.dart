import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Componants/Custom_text.dart';
import '../Componants/custom_dropdown.dart';
import '../Modal/ShowGraph.dart';

class JoinedBarGraphDetailScreen extends StatefulWidget {
  const JoinedBarGraphDetailScreen({
    Key? key,
    required this.type,
    required this.teamId,
  }) : super(key: key);

  final String type;
  final String teamId;

  @override
  State<JoinedBarGraphDetailScreen> createState() =>
      _JoinedBarGraphDetailScreenState();
}

class _JoinedBarGraphDetailScreenState
    extends State<JoinedBarGraphDetailScreen> {
  String selectedMonth = 'Select';
  String selectedTeam = 'All';

  List<String> monthList = [];
  List<String> selectedTeamList = [];

  List<ChartData> chartList = [];
  List<ChartData> filteredList = [];

  bool isSearch = false;

  void filterMonthBarGraph(String month) {
    List<ChartData> localList = [];
    for (var chart in chartList) {
      if (chart.month!.contains(month)) {
        localList.add(chart);
      }
    }
    setState(() {
      filteredList = localList;
    });
  }

  void filterTeamBarGraph(String team) {
    List<ChartData> localList = [];
    for (var chart in chartList) {
      if (chart.x.contains(team)) {
        localList.add(chart);
      }
    }

    setState(() {
      filteredList = localList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getShowSubTeam();
    getTeamMember();
  }

  void getTeamMember() {
    monthList.add('Select');
    selectedTeamList.add('All');
    setState(() {
      isSearch = true;
    });

    ApiHelper.showMyJoinedTeam({'team_id': widget.teamId}).then(
      (value) {
        setState(() {
          isSearch = false;
        });
        if (value.data!.isNotEmpty) {
          for (var team in value.data!) {
            String month = team.monthYear ?? '';
            String memberName = team.memberName ?? '';

            if (!monthList.contains(month)) {
              if (month.isNotEmpty) {
                monthList.add(month);
              }
            }

            if (!selectedTeamList.contains(memberName)) {
              selectedTeamList.add(memberName);
            }

            String readableAmount =
                Helper.formatUnitType(int.parse(team.memberTarget ?? '0'));
            String readableComplete =
                Helper.formatUnitType(int.parse(team.memberCompleted ?? '0'));
            double target = double.parse(team.memberTarget!);
            double completed = double.parse(team.memberCompleted ?? '0');

            chartList.add(ChartData(
              team.memberName!,
              target,
              completed,
              readableAmount,
              team.monthYear ?? '',
              readableComplete,
            ));

            filteredList = chartList;
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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

          isSearch
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 20.0,
                    ),
                    child: chartList.isEmpty
                        ? Center(
                            child: customtext(
                                fontWeight: FontWeight.w600,
                                text: 'No data found',
                                fontsize: 13.0),
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          customtext(
                                            fontWeight: FontWeight.w500,
                                            text: "Select Month",
                                            fontsize: 10.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(height: 5.0),
                                          FilterDropDownWidget(
                                              initialValue: selectedMonth,
                                              items: monthList,
                                              onChange: (value) {
                                                //data.selectMonth(value);
                                                setState(() {
                                                  selectedMonth = value!;
                                                });
                                                filterMonthBarGraph(
                                                    selectedMonth);
                                              })
                                        ],
                                      ),
                                      const SizedBox(width: 20.0),
                                      Column(
                                        children: [
                                          customtext(
                                            fontWeight: FontWeight.w500,
                                            text: "Select Member",
                                            fontsize: 10,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(height: 5.0),
                                          FilterDropDownWidget(
                                              initialValue: selectedTeam,
                                              items: selectedTeamList,
                                              onChange: (value) {
                                                setState(() {
                                                  selectedTeam = value!;
                                                });
                                                if (selectedTeam == 'All') {
                                                  filteredList = chartList;
                                                } else {
                                                  filterTeamBarGraph(
                                                      selectedTeam);
                                                }
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                child: widget.type == 'bar'
                                    ? SfCartesianChart(
                                        zoomPanBehavior: ZoomPanBehavior(
                                            enablePanning: false),
                                        primaryXAxis: CategoryAxis(),
                                        series: <CartesianSeries>[
                                            ColumnSeries<ChartData, String>(
                                                xAxisName: "shush",
                                                color: kblueColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(3),
                                                        topLeft:
                                                            Radius.circular(3)),
                                                dataSource: filteredList,
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.month,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y,
                                                dataLabelSettings:
                                                    DataLabelSettings(
                                                        labelAlignment:
                                                            ChartDataLabelAlignment
                                                                .auto,
                                                        isVisible: true,
                                                        // Templating the data label
                                                        builder: (dynamic data,
                                                            dynamic point,
                                                            dynamic series,
                                                            int pointIndex,
                                                            int seriesIndex) {
                                                          ChartData chartData =
                                                              data;
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right:
                                                                        40.0),
                                                            child: customtext(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                text:
                                                                    "${chartData.amount}",
                                                                color: Colors
                                                                    .black,
                                                                fontsize: 10),
                                                          );
                                                        })),
                                            ColumnSeries<ChartData, String>(
                                                color: const Color(0xffAFAEFE),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(3),
                                                        topLeft:
                                                            Radius.circular(3)),
                                                dataSource: filteredList!,
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.month,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y1,
                                                dataLabelSettings:
                                                    DataLabelSettings(
                                                        labelAlignment:
                                                            ChartDataLabelAlignment
                                                                .auto,
                                                        isVisible: true,
                                                        // Templating the data label
                                                        builder: (dynamic data,
                                                            dynamic point,
                                                            dynamic series,
                                                            int pointIndex,
                                                            int seriesIndex) {
                                                          ChartData chartData =
                                                              data;
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 40),
                                                            child: customtext(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                text:
                                                                    "${chartData.readableCompleteAmount}",
                                                                color: Colors
                                                                    .purple,
                                                                fontsize: 10),
                                                          );
                                                        })),
                                          ])
                                    : SfCartesianChart(
                                        // isTransposed: true,
                                        zoomPanBehavior: ZoomPanBehavior(
                                            enablePanning: false),
                                        primaryXAxis: CategoryAxis(),
                                        series: <ChartSeries>[
                                          SplineSeries<ChartData, String>(
                                              color: kblueColor,
                                              dataSource: filteredList!,
                                              xValueMapper: (ChartData data,
                                                      _) =>
                                                  data.month,
                                              yValueMapper:
                                                  (ChartData data, _) => data.y,
                                              emptyPointSettings:
                                                  EmptyPointSettings(
                                                      // Mode of empty point
                                                      mode: EmptyPointMode
                                                          .average),
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                      labelAlignment:
                                                          ChartDataLabelAlignment
                                                              .outer,
                                                      isVisible: true,
                                                      // Templating the data label
                                                      builder: (dynamic data,
                                                          dynamic point,
                                                          dynamic series,
                                                          int pointIndex,
                                                          int seriesIndex) {
                                                        ChartData chartData =
                                                            data;
                                                        return Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: customtext(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                text:
                                                                    "${chartData.amount}",
                                                                fontsize: 7));
                                                      }),
                                              markerSettings:
                                                  const MarkerSettings(
                                                      isVisible: true)),
                                          SplineSeries<ChartData, String>(
                                              color: const Color(0xffAFAEFE),
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                      labelAlignment:
                                                          ChartDataLabelAlignment
                                                              .auto,
                                                      isVisible: true,
                                                      // Templating the data label
                                                      builder: (dynamic data,
                                                          dynamic point,
                                                          dynamic series,
                                                          int pointIndex,
                                                          int seriesIndex) {
                                                        ChartData chartData =
                                                            data;
                                                        return SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child: customtext(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                text:
                                                                    "${chartData.readableCompleteAmount}",
                                                                fontsize: 7));
                                                      }),
                                              dataSource: filteredList,
                                              xValueMapper:
                                                  (ChartData data, _) =>
                                                      data.month,
                                              yValueMapper:
                                                  (ChartData data, _) =>
                                                      data.y1,
                                              emptyPointSettings:
                                                  EmptyPointSettings(
                                                      // Mode of empty point
                                                      mode: EmptyPointMode
                                                          .average),
                                              markerSettings:
                                                  const MarkerSettings(
                                                      isVisible: true)),
                                        ],
                                      ),
                              ),
                              Row(
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
                                      const SizedBox(width: 10.0),
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
                            ],
                          ),
                  ),
                )
        ],
      ),
    );
  }

  void getShowSubTeam() {
    monthList.add('All');
    selectedTeamList.add('All');
    setState(() {
      isSearch = true;
    });

    //SessionManager.getUserID()
    Map<String, String> body = {'user_id': '19'};

    ApiHelper.showSubTeam(body).then((value) {
      setState(() {
        isSearch = false;
      });

      if (value.data!.teamdata!.isNotEmpty) {
        for (var team in value.data!.teamdata!) {
          String month = team.monthYear ?? '';
          String memberName = team.memberName ?? '';

          if (!monthList.contains(month)) {
            if (month.isNotEmpty) {
              monthList.add(month);
            }
          }

          if (!selectedTeamList.contains(memberName)) {
            selectedTeamList.add(memberName);
          }

          String readableAmount =
              Helper.formatUnitType(int.parse(team.memberTarget ?? '0'));
          String readableComplete =
              Helper.formatUnitType(int.parse(team.memberCompleted ?? '0'));
          double target = double.parse(team.memberTarget!);
          double completed = double.parse(team.memberCompleted ?? '0');

          chartList.add(ChartData(
            team.memberName!,
            target,
            completed,
            readableAmount,
            team.monthYear ?? '',
            readableComplete,
          ));

          filteredList = chartList;
        }
      }
    });
  }
}
