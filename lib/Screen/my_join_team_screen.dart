import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/ShowGraph.dart';
import 'package:smart_leader/Modal/my_joined_team.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyJoinTeamScreen extends StatefulWidget {
  const MyJoinTeamScreen({
    Key? key,
    required this.teamId,
    required this.month,
    required this.type,
  }) : super(key: key);

  final String teamId;
  final String month;
  final String type;

  @override
  State<MyJoinTeamScreen> createState() => _MyJoinTeamScreenState();
}

class _MyJoinTeamScreenState extends State<MyJoinTeamScreen> {
  late Future<MyJoinedTeam> _future;

  List<ChartData> chartList = [];

  Future<MyJoinedTeam> getMyTeam(String teamId) async {
    return ApiHelper.showMyJoinedTeam({'team_id': teamId});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = getMyTeam(widget.teamId);
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

          Expanded(
            child: FutureBuilder<MyJoinedTeam>(
              future: _future,
              builder: (context, response) {
                if (response.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<MyJoinedTeamData> joinList = response.data!.data!;

                if (joinList.isEmpty) {
                  return Center(
                    child: customtext(
                        fontWeight: FontWeight.w600,
                        text: 'No Futher Joining',
                        fontsize: 16.0),
                  );
                }

                chartList.clear();
                for (MyJoinedTeamData data in joinList) {
                  String readableAmount = '0';
                  String readableComplete = '0';
                  double memberTarget = 0.0;
                  double memberComplete = 0.0;
                  if (data.memberTarget != null &&
                      data.memberTarget!.isNotEmpty) {
                    readableAmount = Helper.formatUnitType(
                        int.parse(data.memberTarget ?? '0'));

                    memberTarget = double.parse(data.memberTarget ?? '0');
                  }
                  if (data.memberCompleted != null &&
                      data.memberCompleted!.isNotEmpty) {
                    readableComplete = Helper.formatUnitType(
                        int.parse(data.memberCompleted ?? '0'));
                    memberComplete = double.parse(data.memberCompleted ?? '0');
                  }

                  chartList.add(ChartData(
                    data.teamId!,
                    memberTarget,
                    memberComplete,
                    readableAmount,
                    data.monthYear!,
                    readableComplete,
                  ));
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SfCartesianChart(
                          zoomPanBehavior:
                              ZoomPanBehavior(enablePanning: false),
                          primaryXAxis: CategoryAxis(),
                          series: <CartesianSeries>[
                            ColumnSeries<ChartData, String>(
                                color: kblueColor,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(3),
                                    topLeft: Radius.circular(3)),
                                dataSource: chartList,
                                xValueMapper: (ChartData data, _) => data.month,
                                yValueMapper: (ChartData data, _) => data.y,
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
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 40.0),
                                        child: customtext(
                                            fontWeight: FontWeight.w600,
                                            text: "${chartData.amount}",
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
                                xValueMapper: (ChartData data, _) => data.month,
                                yValueMapper: (ChartData data, _) => data.y1,
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
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 40),
                                        child: customtext(
                                            fontWeight: FontWeight.w600,
                                            text:
                                                "${chartData.readableCompleteAmount}",
                                            color: Colors.purple,
                                            fontsize: 10),
                                      );
                                    })),
                          ]),
                      ListView.builder(
                        itemCount: joinList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                    color:kblueColor,
                                    width: 0.5)),
                            margin: const EdgeInsets.only(
                                top: 10, left: 20.0, right: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customtext(
                                            fontWeight: FontWeight.w700,
                                            text: joinList[index].teamName!,
                                            fontsize: 14.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(height: 8.0),
                                          customtext(
                                            fontWeight: FontWeight.w800,
                                            text:
                                                '${joinList[index].memberName}',
                                            fontsize: 14.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          customtext(
                                            fontWeight: FontWeight.w400,
                                            text: 'Target',
                                            fontsize: 12.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(height: 8.0),
                                          customtext(
                                            fontWeight: FontWeight.w500,
                                            text:
                                                '₹${getMemberTargetAmount(joinList[index])}',
                                            fontsize: 14.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          customtext(
                                            fontWeight: FontWeight.w400,
                                            text: 'Completed',
                                            fontsize: 12.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(height: 8.0),
                                          customtext(
                                            fontWeight: FontWeight.w500,
                                            text: getCompleteAmount(
                                                joinList[index]),
                                            fontsize: 14.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                    /* Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  customtext(
                                    fontWeight: FontWeight.w600,
                                    text: 'Total',
                                    fontsize: 12.0,
                                  ),
                                  const SizedBox(height: 8.0),
                                  customtext(
                                    fontWeight: FontWeight.w500,
                                    text: getTotalAmount(joinList[index]),
                                    fontsize: 14.0,
                                  ),
                                ],
                              ),
                            ),*/
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Visibility(
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                            side: const BorderSide(
                                                color: kblueColor, width: 0.5),
                                          ),
                                          onPressed: () {
                                            deleteDialog(joinList[index]
                                                .memberUnqiueId!);
                                          },
                                          child: customtext(
                                              fontWeight: FontWeight.w600,
                                              text: 'Delete downline',
                                              fontsize: 14.0)),
                                      visible: widget.type == 'parent',
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _future = getMyTeam(joinList[index]
                                                .memberUnqiueId!);
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          side: const BorderSide(
                                              color: kblueColor, width: 0.5),
                                        ),
                                        child: customtext(
                                          fontWeight: FontWeight.w500,
                                          text: 'View Detail',
                                          fontsize: 14.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String getCompleteAmount(MyJoinedTeamData joinedTeamData) {
    if (joinedTeamData.memberCompleted == null) {
      return '₹0';
    }

    return '₹${Helper.formatUnitType(int.parse(joinedTeamData.memberCompleted ?? '0'))}';
  }

  String getMemberTargetAmount(MyJoinedTeamData joinedTeamData) {
    if (joinedTeamData.memberTarget == null ||
        joinedTeamData.memberTarget!.isEmpty) {
      return '0';
    }
    return Helper.formatUnitType(int.parse(joinedTeamData.memberTarget ?? '0'));
  }

  void deleteDialog(String memberUniqueId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Delete Key Leaders",
          fontsize: 22,
          color: Theme.of(context).primaryColor,
        ),
        content: customtext(
          fontWeight: FontWeight.w400,
          text: "Are you sure delete this team",
          fontsize: 15,
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: customtext(
                    fontWeight: FontWeight.w600, text: 'No', fontsize: 12),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  deleteTeam(memberUniqueId);
                },
                child: customtext(
                  fontWeight: FontWeight.w600,
                  text: 'Yes',
                  fontsize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void deleteTeam(String memberUniqueId) {
    Map<String, String> map = {'member_unqiue_id': memberUniqueId};

    print(map);

    Helper.showLoaderDialog(context, message: 'Deleting...');

    ApiHelper.deleteSubTeam(map).then((value) {
      Navigator.pop(context);
      if (value.result == 'Deleted Successfully') {
        Helper.showSnackVar(value.result!, Colors.green, context);
        Navigator.pop(context);
      } else {
        Helper.showSnackVar(value.result!, Colors.red, context);
      }
    });
  }
}
