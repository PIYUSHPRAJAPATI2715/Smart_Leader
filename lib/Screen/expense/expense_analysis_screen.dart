import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/modals/expense.dart';
import 'package:smart_leader/Modal/ShowGraph.dart';
import 'package:smart_leader/Provider/expense_controller.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Componants/custom_dropdown.dart';

class ExpenseAnalysisScreen extends StatefulWidget {
  const ExpenseAnalysisScreen({
    Key? key,
    required this.type,
    required this.days,
  }) : super(key: key);

  final String type;
  final int days;

  @override
  State<ExpenseAnalysisScreen> createState() => _ExpenseAnalysisScreenState();
}

class _ExpenseAnalysisScreenState extends State<ExpenseAnalysisScreen>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;

  int selectedTab = 0;

  final _tabs = const [
    Tab(text: 'Pie Chart'),
    Tab(text: 'Bar Chart'),
    Tab(text: 'Line Chart'),
  ];

  late TabController _tabController;

  List<ExpenseChart> chartList = [];
  final filterList = ['Expense', 'Income'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final data = Provider.of<ExpenseController>(context, listen: false);
    data.filterWeeklyInEx = 'Expense';
    data.getWeeklyExpense(widget.days, data.filterWeeklyInEx);
    _tabController = TabController(length: _tabs.length, vsync: this);

    getBarChart(data);
  }

  void getBarChart(ExpenseController data) {
    for (var element in data.weeklyExpenseList) {
      ExpenseChart expenseChart = ExpenseChart(
        amount: element.amount,
        category: element.category,
        date: element.date,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ExpenseController>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopContainer(
              onTap: () {
                Navigator.pop(context);
              },
              title: "SmartLeader"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customtext(
                      fontWeight: FontWeight.w600,
                      text: '${widget.type} Analysis',
                      color: Theme.of(context).primaryColor,
                      fontsize: 20),
                  const Divider(),
                  FilterDropDownWidget(
                      initialValue: data.filterWeeklyInEx,
                      items: filterList,
                      onChange: (value) {
                        data.getWeeklyExpense(widget.days, value);
                        //data.filterExpenseByMonth(value);
                      }),
                  const Divider(),
                  customtext(
                    fontWeight: FontWeight.w700,
                    text: 'Total ${data.filterWeeklyInEx}',
                    fontsize: 12.0,
                  ),
                  customtext(
                      fontWeight: FontWeight.w700,
                      text:
                          '₹${Helper.formatUnitType(data.weeklyTotalAmount.toInt())}',
                      color: Theme.of(context).primaryColor,
                      fontsize: 22.0),
                  const SizedBox(height: 15.0),
                  data.weeklyExpenseList.isEmpty
                      ? Center(
                          child: customtext(
                              fontWeight: FontWeight.w600,
                              text: 'No Weekly ${data.filterWeeklyInEx} found',
                              color: Colors.red,
                              fontsize: 16.0),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 45.0,
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TabBar(
                                onTap: (index) {
                                  setState(() {
                                    selectedTab = index;
                                  });
                                },
                                labelStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                                controller: _tabController,
                                isScrollable: true,
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: kblueDarkColor),
                                labelColor: Colors.white,
                                unselectedLabelColor: kblueDarkColor,
                                tabs: _tabs,
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            getSelectedWidget(),
                            const SizedBox(height: 25.0),
                            MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.weeklyExpenseList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20.0,
                                          width: 20.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            color: data
                                                .weeklyExpenseList[index].color,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        customtext(
                                          fontWeight: FontWeight.w700,
                                          text:
                                              '${data.weeklyExpenseList[index].category} - ₹${data.weeklyExpenseList[index].amount}',
                                          fontsize: 15.0,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
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

  Widget getSelectedWidget() {
    if (selectedTab == 1) {
      return getBarChartWidget();
    }

    if (selectedTab == 2) {
      return getLineChartWidget();
    }

    return getPieWidget();
  }

  Widget getPieWidget() {
    final data = Provider.of<ExpenseController>(context);
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: getPieChart(data),
        ),
      ),
    );
  }

  Widget getBarChartWidget() {
    final data = Provider.of<ExpenseController>(context);
    return SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(enablePanning: false),
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          ColumnSeries<Expense, String>(
              xAxisName: "shush",
              color: kblueColor,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(3), topLeft: Radius.circular(3)),
              dataSource: data.weeklyExpenseList,
              xValueMapper: (Expense data, _) => data.category!,
              // Helper.formatExpenseChartDate(data.date!),
              yValueMapper: (Expense data, _) =>
                  double.parse(data.amount ?? '0'),
              dataLabelSettings: DataLabelSettings(
                  labelAlignment: ChartDataLabelAlignment.auto,
                  isVisible: true,
                  // Templating the data label
                  builder: (dynamic data, dynamic point, dynamic series,
                      int pointIndex, int seriesIndex) {
                    Expense chartData = data;
                    return Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: customtext(
                          fontWeight: FontWeight.w600,
                          text: Helper.formatUnitType(
                              double.parse(chartData.amount ?? '0').toInt()),
                          color: Colors.black,
                          fontsize: 10),
                    );
                  })),
        ]);
  }

  Widget getLineChartWidget() {
    final data = Provider.of<ExpenseController>(context);

    return SfCartesianChart(
      // isTransposed: true,
      zoomPanBehavior: ZoomPanBehavior(enablePanning: false),
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        SplineSeries<Expense, String>(
            color: kblueColor,
            dataSource: data.weeklyExpenseList,
            xValueMapper: (Expense data, _) => data.category,
            //Helper.formatExpenseChartDate(data.date!),
            yValueMapper: (Expense data, _) => double.parse(data.amount ?? '0'),
            emptyPointSettings: EmptyPointSettings(
                // Mode of empty point
                mode: EmptyPointMode.average),
            dataLabelSettings: DataLabelSettings(
                labelAlignment: ChartDataLabelAlignment.outer,
                isVisible: true,
                // Templating the data label
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  Expense chartData = data;
                  return customtext(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: Helper.formatUnitType(
                          double.parse(chartData.amount ?? '0').toInt()),
                      fontsize: 10);
                }),
            markerSettings: const MarkerSettings(isVisible: true)),
      ],
    );
  }

  List<PieChartSectionData> getPieChart(ExpenseController data) {
    return List.generate(data.weeklyExpenseList.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 10.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final percentage =
          getPercentage(data.weeklyExpenseList[index], data.weeklyTotalAmount);
      return PieChartSectionData(
        color: data.weeklyExpenseList[index].color!.withOpacity(0.8),
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: GoogleFonts.nunito(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  double getPercentage(Expense expense, double totalAmount) {
    double amount = double.parse(expense.amount!);
    return (amount / totalAmount) * 100;
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: GoogleFonts.nunito(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.amber,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

/*
ColumnSeries<ChartData, String>(
              color: const Color(0xffAFAEFE),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(3), topLeft: Radius.circular(3)),
              dataSource: filteredList!,
              xValueMapper: (ChartData data, _) => data.month,
              yValueMapper: (ChartData data, _) => data.y1,
              dataLabelSettings: DataLabelSettings(
                  labelAlignment: ChartDataLabelAlignment.auto,
                  isVisible: true,
                  // Templating the data label
                  builder: (dynamic data, dynamic point, dynamic series,
                      int pointIndex, int seriesIndex) {
                    ChartData chartData = data;
                    return Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: customtext(
                          fontWeight: FontWeight.w600,
                          text: "${chartData.readableCompleteAmount}",
                          color: Colors.purple,
                          fontsize: 10),
                    );
                  })),
   */

