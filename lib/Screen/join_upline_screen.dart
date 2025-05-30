import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/join_team.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Screen/join_team_screen.dart';
import 'package:smart_leader/Screen/my_join_team_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

import 'join_upline_bottom_sheet.dart';

class JoinUplineScreen extends StatefulWidget {
  const JoinUplineScreen({super.key});

  @override
  State<JoinUplineScreen> createState() => _JoinUplineScreenState();
}

class _JoinUplineScreenState extends State<JoinUplineScreen> {



  late Future<JoinedTeam> joinedFuture;

  Future<JoinedTeam> getJoinedTeam() {
    Map<String, String> body = {'user_id': SessionManager.getUserID()};
    return ApiHelper.myJoinTeam(body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AppController>(context, listen: false).unitFormat = '0';
    joinedFuture = getJoinedTeam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 102,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                        AssetImage("assest/images/OnBordScreenTopScreen.png"),
                        fit: BoxFit.fill)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: kWhiteColor,
                          )),
                      Expanded(
                        child: Center(
                          child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Smart Leader",
                            fontsize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {

                            Navigator.pop(context);

                          },
                          child: Image.asset(
                            "assest/png_icon/home_removebg_preview.png",
                            height: 25,
                            width: 25,
                          ))

                    ],
                  ),
                ),
              ),

            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 15.0),
                  getJoinedTeamWidget(),
                ],
              ),
            ),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              context: context,
              builder: (context) {
                return const JoinUplineBottomSheet();
              }).then((value) {
            if (value == true) {
              setState(() {
                // _futureTeam = getTeamList();
                joinedFuture = getJoinedTeam();
              });
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
              gradient:
              SessionManager.getTheme() == true ? k2Gradient : kGradient,
              shape: BoxShape.circle),
          child: Center(
              child: Icon(
                Icons.add,
                color:
                SessionManager.getTheme() == true ? kBlackColor : kWhiteColor,
                size: 45,
              )),
        ),
      ),

    );
  }

  Widget getJoinedTeamWidget() {
    return FutureBuilder<JoinedTeam>(
      future: joinedFuture,
      builder: (context, response) {
        if (response.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<JoinedTeamData> teamList = response.data!.data!;

        if (teamList.isEmpty) {
          return const Center(
            child: customtext(
                fontWeight: FontWeight.w600,
                text: 'No Team Joined',
                fontsize: 16.0),
          );
        }

        return ListView.builder(
          itemCount: teamList.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            JoinedTeamData joinedTeamData = teamList[index];
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                      color: kblueColor, width: 0.5)),
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customtext(
                              fontWeight: FontWeight.w700,
                              text: joinedTeamData.teamName ?? '',
                              fontsize: 14.0,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 8.0),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                        text: joinedTeamData.memberUnqiueId!))
                                    .then((_) {
                                  Helper.toastMassage(
                                      'Team ${joinedTeamData.memberUnqiueId!} copied.',
                                      Colors.black);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 0.0, bottom: 8.0),
                                child: customtext(
                                  fontWeight: FontWeight.w500,
                                  text: 'Id: ${joinedTeamData.memberUnqiueId!}',
                                  fontsize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            customtext(
                              fontWeight: FontWeight.w400,
                              text: 'Target',
                              fontsize: 12.0,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 8.0),
                            customtext(
                              fontWeight: FontWeight.w600,
                              text:
                                  '₹${Helper.formatUnitType(int.parse(joinedTeamData.memberTarget ?? '0'))}',
                              fontsize: 14.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            customtext(
                              fontWeight: FontWeight.w400,
                              text: 'Actual',
                              fontsize: 12.0,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 8.0),
                            customtext(
                              fontWeight: FontWeight.w500,
                              text: getCompleteAmount(joinedTeamData),
                              fontsize: 14.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 8.0, vertical: 2),
                      //   decoration:
                      //       const BoxDecoration(color: kblueColor),
                      //   child: customtext(
                      //     fontWeight: FontWeight.w500,
                      //     text:
                      //         'My Target: ${Helper.formatUnitType(int.parse(joinedTeamData.myAmount ?? '0'))}',
                      //     fontsize: 12.0,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      const Spacer(),
                      InkWell(
                        child: const Icon(Icons.refresh),
                        onTap: () {
                          // updateTeamTarget(joinedTeamData);
                          //  updateCompletedAmount(joinedTeamData);
                          setState(() {
                            joinedFuture = getJoinedTeam();
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2),
                        decoration: const BoxDecoration(color: kblueColor),
                        child: customtext(
                          fontWeight: FontWeight.w500,
                          text: joinedTeamData.monthYear!,
                          fontsize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (joinedTeamData.status == "1") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyJoinTeamScreen(
                                    type: 'child',
                                    teamId: joinedTeamData.memberUnqiueId!,
                                    month: joinedTeamData.monthYear!,
                                  ),
                                ));
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 15.0),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyJoinTeamScreen(
                                                    type: 'child',
                                                    teamId: joinedTeamData
                                                        .memberUnqiueId!,
                                                    month: joinedTeamData
                                                            .monthYear ??
                                                        '',
                                                  ),
                                                ));
                                          },
                                          style: TextButton.styleFrom(
                                              side: const BorderSide(
                                                  color: kblueColor,
                                                  width: 0.5),
                                              minimumSize: const Size(
                                                  double.infinity, 45.0)),
                                          child: const customtext(
                                            fontWeight: FontWeight.w500,
                                            text: 'View Detail',
                                            fontsize: 14.0,
                                            color: kblueColor,
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              joinedTeamData.targetStatus ==
                                                  '0',
                                          child: const SizedBox(height: 15.0),
                                        ),
                                        Visibility(
                                          visible:
                                              joinedTeamData.targetStatus ==
                                                  '0',
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return UpdateJoinCompletedAmount(
                                                      joinedTeamData:
                                                          joinedTeamData,
                                                      type: 'Target',
                                                    );
                                                  }).then((value) {
                                                setState(() {
                                                  joinedFuture =
                                                      getJoinedTeam();
                                                });
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                                side: const BorderSide(
                                                    color: kblueColor,
                                                    width: 0.5),
                                                minimumSize: const Size(
                                                    double.infinity, 45.0)),
                                            child: const customtext(
                                              fontWeight: FontWeight.w500,
                                              text: 'Update Target Business',
                                              fontsize: 14.0,
                                              color: kblueColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15.0),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return UpdateJoinCompletedAmount(
                                                    joinedTeamData:
                                                        joinedTeamData,
                                                    type: 'Actual',
                                                  );
                                                }).then((value) {
                                              setState(() {
                                                joinedFuture = getJoinedTeam();
                                              });
                                            });
                                          },
                                          style: TextButton.styleFrom(
                                              side: const BorderSide(
                                                color: kblueColor,
                                                width: 0.5,
                                              ),
                                              minimumSize: const Size(
                                                  double.infinity, 45.0)),
                                          child: const customtext(
                                            fontWeight: FontWeight.w500,
                                            text: 'Update Actual Business',
                                            fontsize: 14.0,
                                            color: kblueColor,
                                          ),
                                        ),
                                        const SizedBox(height: 15.0),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            deleteDialog(
                                                joinedTeamData.memberUnqiueId!);
                                          },
                                          style: TextButton.styleFrom(
                                            side: const BorderSide(
                                                color: kredColor, width: 0.5),
                                            minimumSize: const Size(
                                                double.infinity, 40.0),
                                          ),
                                          child: const customtext(
                                            fontWeight: FontWeight.w500,
                                            text: 'Delete',
                                            fontsize: 14.0,
                                            color: kredColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: customtext(
                            fontWeight: FontWeight.w500,
                            text:
                                joinedTeamData.status == "1" ? 'View' : 'Edit',
                            fontsize: 12.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  void updateCompletedAmount(JoinedTeamData joinedTeamData) {
    Map<String, String> body = {
      'id': joinedTeamData.id!,
      'member_completed': joinedTeamData.myCompleteAmt ?? '0',
      'team_id': joinedTeamData.memberUnqiueId!
    };

    ApiHelper.updateJoinTeamAmount(body).then((value) {
      if (value.message == 'Update  Sub Team Successfully') {
        //   Helper.toastMassage(value.message!, Colors.green);
      } else {
        // Helper.toastMassage(value.message!, Colors.red);
      }
    });
  }

  void updateTeamTarget(JoinedTeamData joinedTeamData) {
    Map<String, String> body = {
      'id': joinedTeamData.id!,
      'member_target': joinedTeamData.myAmount ?? joinedTeamData.memberTarget!,
      'member_unqiue_id': joinedTeamData.memberUnqiueId!
    };

    ApiHelper.updateMemberSubTeamTarget(body).then((value) {
      if (value.message == 'Update  Member Target Successfully') {
        setState(() {
          joinedFuture = getJoinedTeam();
        });
      } else {
        //  Helper.toastMassage(value.message!, Colors.red);
      }
    });
  }

  String getCompleteAmount(JoinedTeamData joinedTeamData) {
    if (joinedTeamData.memberCompleted == null) {
      return '₹0';
    }
    return '₹${Helper.formatUnitType(int.parse(joinedTeamData.memberCompleted ?? '0'))}';
  }

  void deleteDialog(String memberUniqueId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Delete Key Leaders",
          fontsize: 22,
          color: Theme.of(context).primaryColor,
        ),
        content: customtext(
          fontWeight: FontWeight.w400,
          text: "Are you sure delete this team",
          fontsize: 15,
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const customtext(
                    fontWeight: FontWeight.w600, text: 'No', fontsize: 12),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  deleteTeam(memberUniqueId);
                },
                child: const customtext(
                  fontWeight: FontWeight.w600,
                  text: 'Yes',
                  fontsize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void deleteTeam(String memberUniqueId) {
    Map<String, String> map = {'member_unqiue_id': memberUniqueId};

    print(map);

    Helper.showLoaderDialog(context, message: 'Deleting...');

    ApiHelper.deleteSubTeam(map).then((value) {
      Navigator.pop(context);
      if (value.result == 'Deleted Successfully') {
        Helper.showSnackVar(value.result!, Colors.green, context);
        setState(() {
          joinedFuture = getJoinedTeam();
        });
      } else {
        Helper.showSnackVar(value.result!, Colors.red, context);
      }
    });
  }
}
