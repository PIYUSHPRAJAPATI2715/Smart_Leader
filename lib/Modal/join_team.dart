class JoinedTeam {
  List<JoinedTeamData>? data;
  String? message;

  JoinedTeam({this.data, this.message});

  JoinedTeam.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <JoinedTeamData>[];
      json['data'].forEach((v) {
        data!.add(JoinedTeamData.fromJson(v));
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

class JoinedTeamData {
  String? id;
  String? teamId;
  String? teamName;
  String? userId;
  String? memberName;
  String? memberTarget;
  String? memberCompleted;
  String? memberUnqiueId;
  String? monthYear;
  String? totalAmount;
  String? status;
  String? targetStatus;
  String? path;
  String?myAmount;
  String?myCompleteAmt;

  JoinedTeamData(
      {this.id,
        this.teamId,
        this.teamName,
        this.userId,
        this.memberName,
        this.memberTarget,
        this.memberCompleted,
        this.memberUnqiueId,
        this.monthYear,
        this.totalAmount,
        this.status,
        this.targetStatus,
        this.myAmount,
        this.myCompleteAmt,
        this.path});

  JoinedTeamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    teamName = json['team_name'];
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
    myAmount = json['my_amount'];
    myCompleteAmt = json['my_target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['team_id'] = teamId;
    data['team_name'] = teamName;
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
    data['my_amount'] = myAmount;
    data['my_target'] = myCompleteAmt;
    return data;
  }
}
