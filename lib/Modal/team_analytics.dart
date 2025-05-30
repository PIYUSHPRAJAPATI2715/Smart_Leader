import 'package:smart_leader/Modal/show_analytics.dart';

class TeamAnalytics {
  String? branchName;
  String? monthYear;
  List<ShowAnalyticsData>? teamList;

  TeamAnalytics({this.branchName, this.monthYear, this.teamList});
}

class TeamAnalyticsData {
  String? teamId;
  String? teamName;
  String? targetAmount;
  String? completeAmount;
  String? percentage;
  String? gaps;

  TeamAnalyticsData({
    this.teamId,
    this.teamName,
    this.targetAmount,
    this.completeAmount,
    this.gaps,
    this.percentage,
  });
}
