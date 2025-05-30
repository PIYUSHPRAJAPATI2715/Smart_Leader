class MyJoinedTeam {
  List<MyJoinedTeamData>? data;
  String? message;

  MyJoinedTeam({this.data, this.message});

  MyJoinedTeam.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MyJoinedTeamData>[];
      json['data'].forEach((v) {
        data!.add(MyJoinedTeamData.fromJson(v));
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

class MyJoinedTeamData {
  String? id;
  String? teamId;
  String? userId;
  String? memberName;
  String? memberTarget;
  String? memberCompleted;
  String? memberUnqiueId;
  String? monthYear;
  String? path;
  String? totalAmount;
  String? teamName;

  MyJoinedTeamData(
      {this.id,
      this.teamId,
      this.userId,
      this.memberName,
      this.memberTarget,
      this.memberCompleted,
      this.memberUnqiueId,
      this.monthYear,
      this.path,
      this.teamName,
      this.totalAmount});

  MyJoinedTeamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['team_id'];
    userId = json['user_id'];
    memberName = json['member_name'];
    memberTarget = json['member_target'];
    memberCompleted = json['member_completed'];
    memberUnqiueId = json['member_unqiue_id'];
    monthYear = json['month_year'];
    path = json['path'];
    totalAmount = json['total_amount'];
    teamName = json['team_name'];
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
    data['path'] = path;
    data['total_amount'] = totalAmount;
    data['team_name'] = teamName;
    return data;
  }
}
