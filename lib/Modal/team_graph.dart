class TeamGraph {
  String? message;
  List<TeamGraphData>? data;

  TeamGraph({this.message, this.data});

  TeamGraph.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <TeamGraphData>[];
      json['data'].forEach((v) {
        data!.add(TeamGraphData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamGraphData {
  String? id;
  String? userId;
  String? btanchName;
  List<TeamData>? teamData;

  TeamGraphData({this.id, this.userId, this.btanchName, this.teamData});

  TeamGraphData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    btanchName = json['btanch_name'];
    if (json['team_data'] != null) {
      teamData = <TeamData>[];
      json['team_data'].forEach((v) {
        teamData!.add(TeamData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['btanch_name'] = btanchName;
    if (teamData != null) {
      data['team_data'] = teamData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamData {
  String? id;
  String? branchId;
  String? userId;
  String? teamId;
  String? teamName;
  String? targetAmount;
  String? amount;
  String? monthYear;
  String? path;

  TeamData(
      {this.id,
        this.branchId,
        this.userId,
        this.teamId,
        this.teamName,
        this.targetAmount,
        this.amount,
        this.monthYear,
        this.path});

  TeamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    userId = json['user_id'];
    teamId = json['team_id'];
    teamName = json['team_name'];
    targetAmount = json['target_amount'];
    amount = json['amount'];
    monthYear = json['month_year'];
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
    data['path'] = path;
    return data;
  }
}
