import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Modal/ShowGraph.dart';
import 'package:smart_leader/Modal/add_team_detail_modal.dart';
import 'package:smart_leader/Modal/editadd_team_details_modal.dart';
import 'package:smart_leader/Modal/team_graph.dart';

class AppController with ChangeNotifier {
  int getPage = 0;

  void getPageIndex(int index) {
    getPage = index;
    notifyListeners();
  }

  int slider = 0;

  void getslider(int index) {
    slider = index;
    notifyListeners();
  }

  int bannerslider = 0;

  void getbannerslider(int index) {
    bannerslider = index;
    notifyListeners();
  }

  int tabBarIndex = 0;

  void tabBarStatus(int index) {
    tabBarIndex = index;
    notifyListeners();
  }

  int selectedContainer = 0;

  void selectedOneContainer(int value) {
    selectedContainer = value;
    notifyListeners();
  }

  int chartContainer = 0;

  void getchartContainer(int index) {
    chartContainer = index;
    notifyListeners();
  }

  int selectedColorContainer = 0;

  void selectedColorOneContainer(int value) {
    selectedColorContainer = value;
    notifyListeners();
  }

  int selectedPaymentContainer = 0;

  void selectedPaymentOneContainer(int value) {
    selectedPaymentContainer = value;
    notifyListeners();
  }

  List<AddTeamDetailModal> teamDetailList = [];

  void addTeam(AddTeamDetailModal data) {
    teamDetailList.add(data);
    notifyListeners();
  }

  void removeTeam(int index) {
    teamDetailList.removeAt(index);
    notifyListeners();
  }

  List<EditAddTeamDetailModal> editteamDetailList = [];

  void editaddTeam(EditAddTeamDetailModal data) {
    editteamDetailList.add(data);
    notifyListeners();
  }

  void removeeditTeam(int index) {
    editteamDetailList.removeAt(index);
    notifyListeners();
  }

  String unitFormat = '0';

  void formatUnitType(int number) {
    // final formatter = NumberFormat('#,##,###');
    // if (number < 1000) {
    //   unitFormat = formatter.format(number);
    // } else if (number < 100000) {
    //   unitFormat = '${formatter.format(number ~/ 1000)} thousand';
    // } else if (number < 10000000) {
    //   unitFormat = '${formatter.format(number ~/ 100000)} lakh';
    // } else {
    //   unitFormat = '${formatter.format(number ~/ 10000000)} crore';
    // }
    final formatter = NumberFormat('#,##,###.##');
    if (number < 1000) {
      unitFormat = formatter.format(number);
    } else if (number < 100000) {
      unitFormat = '${formatter.format(number / 1000)} k';
    } else if (number < 10000000) {
      unitFormat = '${formatter.format(number / 100000)} L';
    } else {
      unitFormat = '${formatter.format(number / 10000000)} cr';
    }
    notifyListeners();
  }

  //todo:---------------------------------------------------
  List<ShowGraph> teamGraphList = [];
  List<ShowGraph> currentMonthCharList = [];
  bool isGraphSearch = false;
  String selectedMonth = '';
  String selectedTeam = '';

  double monthTarget = 0, monthCompleted = 0;

  void getBarGraphList() async {
    final DateFormat formatter = DateFormat('MMM-yyyy');
    final String formatted = formatter.format(DateTime.now());

    teamGraphList.clear();
    currentMonthCharList.clear();
    monthTarget = 0;
    monthCompleted = 0;
    isGraphSearch = true;

    TeamGraph teamGraph = await ApiHelper.showTeamGraph();

    isGraphSearch = false;

    if (teamGraph.data != null) {
      if (teamGraph.data!.isNotEmpty) {
        for (var team in teamGraph.data!) {
          List<ChartData> chartList = [];
          List<String> monthList = [];
          List<String> teamList = [];
          List<ChartData> currentMonthChartList = [];

          teamList.add('All');

          if (team.teamData!.isNotEmpty) {

            monthTarget = 0;
            monthCompleted = 0;

            for (var graph in team.teamData!) {
              double target = double.parse(graph.targetAmount!);
              double completed = double.parse(graph.amount!);

              if (!monthList.contains(graph.monthYear!)) {
                monthList.add(graph.monthYear!);
              }

              if (!teamList.contains(graph.teamName!)) {
                teamList.add(graph.teamName!);
              }

              String readableAmount = Helper.formatUnitType(target.toInt());
              String readableComplete =
                  Helper.formatUnitType(completed.toInt());
              chartList.add(ChartData(
                graph.teamName!,
                target,
                completed,
                readableAmount,
                graph.monthYear,
                readableComplete,
              ));

              //todo:here we update...home graph total amount
              if (formatted == graph.monthYear) {
                monthTarget += double.parse(graph.targetAmount!);
                monthCompleted += double.parse(graph.amount!);
              }
            }

            teamGraphList.add(ShowGraph(
                branchId: team.id!,
                branchName: team.btanchName,
                chartList: chartList,
                monthList: monthList,
                teamList: teamList,
                selectedMonth: monthList[0],
                selectedTeam: teamList[0]));

            selectedTeam = teamList[0];
            selectedMonth = monthList[0];

            //todo:here we calculate total amount per month with branch wise
            String readableAmount = Helper.formatUnitType(monthTarget.toInt());
            String readableComplete =
                Helper.formatUnitType(monthCompleted.toInt());
            currentMonthChartList.add(ChartData('team', monthTarget,
                monthCompleted, readableAmount, formatted, readableComplete));

            currentMonthCharList.add(ShowGraph(
                branchId: team.id!,
                branchName: team.btanchName,
                chartList: currentMonthChartList,
                monthList: monthList,
                teamList: teamList,
                selectedMonth: monthList[0],
                selectedTeam: teamList[0]));
          }
        }
      }
    }

    notifyListeners();
  }

  void selectMonth(String month) {
    selectedMonth = month;
    notifyListeners();
  }
}
