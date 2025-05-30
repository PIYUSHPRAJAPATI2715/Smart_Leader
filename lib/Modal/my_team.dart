class MyTeam {
  List<MyTeamData>? data;
  String? message;

  MyTeam({this.data, this.message});

  MyTeam.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MyTeamData>[];
      json['data'].forEach((v) {
        data!.add(MyTeamData.fromJson(v));
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

class MyTeamData {
  String? id;
  String? branchId;
  String? userId;
  String? teamId;
  String? teamName;
  String? targetAmount;
  String? amount;
  String? monthYear;
  String? status;
  String? path;
  String? targetStatus;
  String? myAmount;
  String?myCompletedAmount;

  MyTeamData({
    this.id,
    this.branchId,
    this.userId,
    this.teamId,
    this.teamName,
    this.targetAmount,
    this.amount,
    this.monthYear,
    this.status,
    this.path,
    this.targetStatus,
    this.myAmount,
    this.myCompletedAmount,
  });

  MyTeamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    userId = json['user_id'];
    teamId = json['team_id'];
    teamName = json['team_name'];
    targetAmount = json['target_amount'];
    amount = json['amount'];
    monthYear = json['month_year'];
    status = json['status'];
    path = json['path'];
    targetStatus = json['target_status'];
    myAmount = json['my_amount'];
    myCompletedAmount = json['my_target'];
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
    data['path'] = path;
    data['target_status'] = targetStatus;
    data['my_amount'] = myAmount;
    data['my_target'] = myCompletedAmount;
    return data;
  }
}
