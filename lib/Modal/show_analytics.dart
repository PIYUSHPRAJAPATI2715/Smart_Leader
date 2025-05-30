class ShowAnalytics {
  List<ShowAnalyticsData>? data;
  String? message;

  ShowAnalytics({this.data, this.message});

  ShowAnalytics.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowAnalyticsData>[];
      json['data'].forEach((v) {
        data!.add(ShowAnalyticsData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class ShowAnalyticsData {
  String? monthYear;
  List<AnalyticsTeamData>? teamData;

  ShowAnalyticsData({this.monthYear, this.teamData});

  ShowAnalyticsData.fromJson(Map<String, dynamic> json) {
    monthYear = json['month_year'];
    if (json['team_data'] != null) {
      teamData = <AnalyticsTeamData>[];
      json['team_data'].forEach((v) {
        teamData!.add(AnalyticsTeamData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month_year'] = monthYear;
    if (teamData != null) {
      data['team_data'] = teamData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnalyticsTeamData {
  String? id;
  String? branchId;
  String? userId;
  String? teamId;
  String? teamName;
  String? targetAmount;
  String? amount;
  String? monthYear;
  String? status;
  String? percentage;
  int? gaps;
  String? path;

  AnalyticsTeamData(
      {this.id,
        this.branchId,
        this.userId,
        this.teamId,
        this.teamName,
        this.targetAmount,
        this.amount,
        this.monthYear,
        this.status,
        this.percentage,
        this.gaps,
        this.path});

  AnalyticsTeamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    userId = json['user_id'];
    teamId = json['team_id'];
    teamName = json['team_name'];
    targetAmount = json['target_amount'];
    amount = json['amount'];
    monthYear = json['month_year'];
    status = json['status'];
    percentage = json['percentage'];
    gaps = json['gaps'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['branch_id'] = branchId;
    data['user_id'] = userId;
    data['team_id'] = teamId;
    data['team_name'] = teamName;
    data['target_amount'] = targetAmount;
    data['amount'] = amount;
    data['month_year'] = monthYear;
    data['status'] = status;
    data['percentage'] = percentage;
    data['gaps'] = gaps;
    data['path'] = path;
    return data;
  }
}
