class ShowGraph {
  String? branchId;
  String? branchName;
  List<String>? monthList;
  List<String>? teamList;
  String? selectedMonth;
  String? selectedTeam;
  List<ChartData>? chartList;

  ShowGraph(
      {this.branchId,
      this.branchName,
      this.chartList,
      this.selectedTeam,
      this.selectedMonth,
      this.teamList,
      this.monthList});
}

class ChartData {
  ChartData(this.x, this.y, this.y1, this.amount, this.month,
      this.readableCompleteAmount,
      {this.teamId});

  final String x;
  final double? y;
  final double? y1;
  final String? amount;
  final String? month;
  final String? readableCompleteAmount;
  final String? teamId;
}

class ExpenseChart {
  String? amount;
  String? date;
  String? category;

  ExpenseChart({
    this.amount,
    this.date,
    this.category,
  });
}
