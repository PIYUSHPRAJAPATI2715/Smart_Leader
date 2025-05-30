class ShowSubTeam {
  ShowSubTeamData? data;
  String? message;

  ShowSubTeam({this.data, this.message});

  ShowSubTeam.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ShowSubTeamData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }

}

class ShowSubTeamData {
  String? id;
  String? teamId;
  String? userId;
  String? memberName;
  String? memberTarget;
  String? memberCompleted;
  String? memberUnqiueId;
  String? monthYear;
  String? totalAmount;
  String? status;
  String? targetStatus;
  List<Teamdata>? teamdata;

  ShowSubTeamData(
      {this.id,
        this.teamId,
        this.userId,
        this.memberName,
        this.memberTarget,
        this.memberCompleted,
        this.memberUnqiueId,
        this.monthYear,
        this.totalAmount,
        this.status,
        this.targetStatus,
        this.teamdata});

  ShowSubTeamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    userId = json['user_id'];
    memberName = json['member_name'];
    memberTarget = json['member_target'];
    memberCompleted = json['member_completed'];
    memberUnqiueId = json['member_unqiue_id'];
    monthYear = json['month_year'];
    totalAmount = json['total_amount'];
    status = json['status'];
    targetStatus = json['target_status'];
    if (json['teamdata'] != null) {
      teamdata = <Teamdata>[];
      json['teamdata'].forEach((v) {
        teamdata!.add(Teamdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['team_id'] = teamId;
    data['user_id'] = userId;
    data['member_name'] = memberName;
    data['member_target'] = memberTarget;
    data['member_completed'] = memberCompleted;
    data['member_unqiue_id'] = memberUnqiueId;
    data['month_year'] = monthYear;
    data['total_amount'] = totalAmount;
    data['status'] = status;
    data['target_status'] = targetStatus;
    if (teamdata != null) {
      data['teamdata'] = teamdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teamdata {
  String? id;
  String? teamId;
  String? userId;
  String? memberName;
  String? memberTarget;
  String? memberCompleted;
  String? memberUnqiueId;
  String? monthYear;
  int? totalAmount;
  String? status;
  String? targetStatus;
  String? path;

  Teamdata(
      {this.id,
        this.teamId,
        this.userId,
        this.memberName,
        this.memberTarget,
        this.memberCompleted,
        this.memberUnqiueId,
        this.monthYear,
        this.totalAmount,
        this.status,
        this.targetStatus,
        this.path});

  Teamdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    userId = json['user_id'];
    memberName = json['member_name'];
    memberTarget = json['member_target'];
    memberCompleted = json['member_completed'];
    memberUnqiueId = json['member_unqiue_id'];
    monthYear = json['month_year'];
    totalAmount = json['total_amount'];
    status = json['status'];
    targetStatus = json['target_status'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['team_id'] = teamId;
    data['user_id'] = userId;
    data['member_name'] = memberName;
    data['member_target'] = memberTarget;
    data['member_completed'] = memberCompleted;
    data['member_unqiue_id'] = memberUnqiueId;
    data['month_year'] = monthYear;
    data['total_amount'] = totalAmount;
    data['status'] = status;
    data['target_status'] = targetStatus;
    data['path'] = path;
    return data;
  }
}
