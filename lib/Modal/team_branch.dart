class TeamBranch {
  List<TeamBranchData>? data;
  String? message;

  TeamBranch({this.data, this.message});

  TeamBranch.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TeamBranchData>[];
      json['data'].forEach((v) {
        data!.add(TeamBranchData.fromJson(v));
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

class TeamBranchData {
  String? id;
  String? branchId;
  String? userId;
  String? teamId;
  String? teamName;
  String? targetAmount;
  String? amount;
  String? monthYear;
  String? path;

  TeamBranchData(
      {this.id,
      this.branchId,
      this.userId,
      this.teamId,
      this.teamName,
      this.targetAmount,
      this.amount,
      this.monthYear,
      this.path});

  TeamBranchData.fromJson(Map<String, dynamic> json) {
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
