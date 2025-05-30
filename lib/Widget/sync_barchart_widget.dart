import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_dropdown.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/ShowGraph.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Screen/bar_graph_detail_screen.dart';
import 'package:smart_leader/Screen/business_analysis_screen.dart';
import 'package:smart_leader/Screen/business_analytics_screen.dart';
import 'package:smart_leader/Screen/expenditure_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SynnBarChart extends StatefulWidget {
  const SynnBarChart({Key? key}) : super(key: key);

  @override
  State<SynnBarChart> createState() => _SynnBarChartState();
}

class _SynnBarChartState extends State<SynnBarChart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Provider.of<AppController>(context, listen: false).getBarGraphList();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          data.isGraphSearch
              ? const Center(child: CircularProgressIndicator())
              : Visibility(
                  visible: data.currentMonthCharList.isNotEmpty,
                  child: Column(
                    children: [
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.currentMonthCharList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
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
                                              color: Color(
                                                0xffC3C3C3,
                                              )),
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
                                    Visibility(
                                      visible: false,
                                      child: TextButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BusinessAnalyticScreen(
                                                          showGraph:
                                                              data.teamGraphList[
                                                                  index])));
                                        },
                                        label: customtext(
                                            fontWeight: FontWeight.w600,
                                            text: 'Show Analytics',
                                            color: kblueColor,
                                            fontsize: 12.0),
                                        icon: const Icon(
                                          Icons.analytics_outlined,
                                          color: kblueColor,
                                        ),
                                        style: TextButton.styleFrom(
                                            side:
                                                BorderSide(color: kblueColor)),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: customtext(
                                        fontWeight: FontWeight.w700,
                                        text: data.currentMonthCharList[index]
                                            .branchName!,
                                        fontsize: 14.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BarGraphDetailScreen(
                                                        type: 'bar',
                                                        showGraph:
                                                            data.teamGraphList[
                                                                index])));
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
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: KBoxNewColor, width: 1)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10,
                                                  bottom: 4,
                                                  top: 4),
                                              child: customtext(
                                                fontWeight: FontWeight.w500,
                                                text: 'Team A',
                                                fontsize: 14.0,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.shade200,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3)),
                                            ),
                                            margin: EdgeInsets.all(15),
                                          ),
                                          Spacer(),
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10,
                                                  bottom: 4,
                                                  top: 4),
                                              child: customtext(
                                                fontWeight: FontWeight.w500,
                                                text: 'All Leaders',
                                                fontsize: 14.0,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.shade200,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3)),
                                            ),
                                            margin: EdgeInsets.all(15),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        child: SfCartesianChart(
                                            zoomPanBehavior: ZoomPanBehavior(
                                                enablePanning: false),
                                            primaryXAxis: CategoryAxis(),
                                            series: <CartesianSeries>[
                                              ColumnSeries<ChartData, String>(
                                                  color: kblueColor,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  3),
                                                          topLeft:
                                                              Radius.circular(
                                                                  3)),
                                                  dataSource: data
                                                      .currentMonthCharList[
                                                          index]
                                                      .chartList!,
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
                                                          builder: (dynamic
                                                                  data,
                                                              dynamic point,
                                                              dynamic series,
                                                              int pointIndex,
                                                              int seriesIndex) {
                                                            ChartData
                                                                chartData =
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
                                                  color:
                                                      const Color(0xffAFAEFE),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  3),
                                                          topLeft:
                                                              Radius.circular(
                                                                  3)),
                                                  dataSource: data
                                                      .currentMonthCharList[
                                                          index]
                                                      .chartList!,
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
                                                            ChartData
                                                                chartData =
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
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15.0)
                              ],
                            );
                          },
                        ),
                      ),
                    ],
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
                      SizedBox(
                        child: SfCartesianChart(
                            zoomPanBehavior:
                                ZoomPanBehavior(enablePanning: true),
                            primaryXAxis: CategoryAxis(),
                            series: <CartesianSeries>[
                              ColumnSeries<ChartData, String>(
                                xAxisName: "shush",
                                color: kblueColor,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(3),
                                    topLeft: Radius.circular(3)),
                                dataSource: subTeamChartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                              ),
                              ColumnSeries<ChartData, String>(
                                color: const Color(0xffAFAEFE),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(3),
                                    topLeft: Radius.circular(3)),
                                dataSource: subTeamChartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y1,
                              ),
                            ]),
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
                      )
                    ],
                  ),
                ),
 */

/*
ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: customtext(
                        fontWeight: FontWeight.w700,
                        text: "Report",
                        fontsize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => EditChartScreen()));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AddBusinessTeamScreen()),
                        );
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
                                const SizedBox(width: 4),
                                Image.asset(
                                  "assest/png_icon/edit_icon.png",
                                  height: 17,
                                  width: 17,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  child: SfCartesianChart(
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      primaryXAxis: CategoryAxis(),
                      series: <CartesianSeries>[
                        ColumnSeries<ChartData, String>(
                            legendItemText: "TeamA",
                            xAxisName: "shush",
                            color: kblueColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(3),
                                topLeft: Radius.circular(3)),
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y),
                        ColumnSeries<ChartData, String>(
                            color: const Color(0xffAFAEFE),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(3),
                                topLeft: Radius.circular(3)),
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y1),
                        ColumnSeries<ChartData, String>(
                            color: kblueColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(3),
                                topLeft: Radius.circular(3)),
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
                                  return SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: customtext(
                                          fontWeight: FontWeight.w400,
                                          text: "TeamA",
                                          fontsize: 7));
                                }),
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y),
                        ColumnSeries<ChartData, String>(
                            color: const Color(0xffAFAEFE),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(3),
                                topLeft: Radius.circular(3)),
                            dataLabelMapper: (ChartData data, _) => data.x,
                            dataSource: chartData1,
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
                                      child: customtext(
                                        fontWeight: FontWeight.w400,
                                        text: "TeamA",
                                        fontsize: 7,
                                        color: kblueColor,
                                      ));
                                }),
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y1),
                      ]),
                ),
                const SizedBox(height: 15),
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
                              const SizedBox(
                                width: 4,
                              ),
                              Image.asset(
                                "assest/png_icon/analysis_icon.png",
                                height: 17,
                                width: 17,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const DottedLine(
                  dashLength: 30,
                  dashGapLength: 12,
                  lineThickness: 2,
                  dashColor: Colors.blue,
                ),
              ],
            ),
          );
        })
 */
