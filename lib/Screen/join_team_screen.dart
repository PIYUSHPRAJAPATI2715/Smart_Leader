import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/ExtractClasses/bottom_sheet_screen.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/join_team.dart';
import 'package:smart_leader/Modal/my_team.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Screen/my_join_team_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:smart_leader/fragment/my_team_fragment.dart';

class JoinTeamScreen extends StatefulWidget {
  const JoinTeamScreen({Key? key}) : super(key: key);

  @override
  State<JoinTeamScreen> createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _teamIdController = TextEditingController();
  final TextEditingController _targetAmtController = TextEditingController();

  late TabController _tabController;

  String readableAmount = '';

  int selectedTab = 0;

  final _tabs = const [
    Tab(text: 'My Team'),
    Tab(text: 'My Downline'),
  ];

  late Future<JoinedTeam> joinedFuture;
  late Future<MyTeam> _futureTeam;

  Future<MyTeam> getTeamList() {
    return ApiHelper.showTeam();
  }

  Future<JoinedTeam> getJoinedTeam() {
    //SessionManager.getUserID()
    Map<String, String> body = {'user_id': SessionManager.getUserID()};
    return ApiHelper.myJoinTeam(body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AppController>(context, listen: false).unitFormat = '0';
    _tabController = TabController(length: _tabs.length, vsync: this);
    joinedFuture = getJoinedTeam();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
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

              Positioned(
                right: 20,
                top: 35,
                child: SafeArea(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 0.5),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                          context: context,
                          builder: (context) {
                            return const BottomScreen(teamType: 'Joined');
                          }).then((value) {
                        if (value == true) {
                          setState(() {
                            _futureTeam = getTeamList();
                          });
                        }
                      });
                    },
                    child: customtext(
                      fontWeight: FontWeight.w600,
                      text: 'Create Team',
                      fontsize: 15.0,
                      color: Colors.white,
                    ),
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
                  CustomTextField(
                      hight: 50.0,
                      title: 'Enter Team Id',
                      controller: _teamIdController,
                      hint: '',
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      lableName: 'Team Id',
                      hintfont: 12,
                      lablefont: 12),
                  const SizedBox(height: 15.0),
                  CustomAmountTextField(
                    hight: 50,
                    title: "Enter amount",
                    controller: _targetAmtController,
                    hint: "fff",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    lableName: "Target Amount",
                    hintfont: 12,
                    lablefont: 14,
                    gapHight: 10,
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          int number = int.parse(value);
                          // data.formatUnitType(number);
                          readableAmount = Helper.formatUnitType(number);
                        } else {
                          //  data.formatUnitType(0);
                          readableAmount = '';
                        }
                      });
                    },
                    unitType: readableAmount,
                  ),
                  const SizedBox(width: 15.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: custom_Button(
                        onTap: joinTeam,
                        title: 'Join',
                        hight: 50,
                        width: 120,
                        fontSize: 14.0),
                  ),
                  const SizedBox(height: 15.0),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 15.0),
                  Container(
                    height: 45.0,
                    padding: const EdgeInsets.all(3.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 0.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                      labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 12),
                      controller: _tabController,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.black),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: _tabs,
                    ),
                  ),
                  selectedTab == 0
                      ? const MyTeamFragment()
                      : getJoinedTeamWidget(),
                ],
              ),
            ),
          )
        ],
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
          return Center(
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
                      color: Theme.of(context).primaryColor, width: 0.5)),
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
                              text: joinedTeamData.teamName!,
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
                                      Colors.green);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 0.0, bottom: 8.0),
                                child: customtext(
                                  fontWeight: FontWeight.w500,
                                  text: 'Id: ${joinedTeamData.memberUnqiueId!}',
                                  fontsize: 14.0,
                                  color: Colors.green,
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
                              color: Colors.green,
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
                              text: 'Completed',
                              fontsize: 12.0,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 8.0),
                            customtext(
                              fontWeight: FontWeight.w500,
                              text: getCompleteAmount(joinedTeamData),
                              fontsize: 14.0,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2),
                        decoration:
                            const BoxDecoration(color: Colors.deepPurple),
                        child: customtext(
                          fontWeight: FontWeight.w500,
                          text:
                              'My Target: ${Helper.formatUnitType(int.parse(joinedTeamData.myAmount ?? joinedTeamData.memberTarget!))}',
                          fontsize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        child: const Icon(Icons.refresh),
                        onTap: () {
                          print('object');
                          updateTeamTarget(joinedTeamData);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2),
                        decoration: const BoxDecoration(color: Colors.red),
                        child: customtext(
                          fontWeight: FontWeight.w500,
                          text: joinedTeamData.monthYear!,
                          fontsize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
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
                                                    type: 'Target',
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
                                                  width: 0.5),
                                              minimumSize: const Size(
                                                  double.infinity, 45.0)),
                                          child: const customtext(
                                            fontWeight: FontWeight.w500,
                                            text: 'Update Target Amount',
                                            fontsize: 14.0,
                                            color: kblueColor,
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
                                                    type: 'Complete',
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
                                            text: 'Update Complete Amount',
                                            fontsize: 14.0,
                                            color: kblueColor,
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

  void updateTeamTarget(JoinedTeamData joinedTeamData) {
    Map<String, String> body = {
      'id': joinedTeamData.id!,
      'member_target': joinedTeamData.myAmount ?? joinedTeamData.memberTarget!,
      'member_unqiue_id': joinedTeamData.memberUnqiueId!
    };

    ApiHelper.updateMemberSubTeamTarget(body).then((value) {
      if (value.message == 'Update  Member Target Successfully') {
        //  Helper.toastMassage(value.message!, Colors.green);
        setState(() {
          joinedFuture = getJoinedTeam();
        });
      } else {
        //  Helper.toastMassage(value.message!, Colors.red);
      }
    });
  }

  void deleteDialog(String teamId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Delete Team",
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
                child: customtext(
                    fontWeight: FontWeight.w600, text: 'No', fontsize: 12),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  deleteTeam(teamId);
                },
                child: customtext(
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

  void deleteTeam(String teamId) {
    Map<String, String> map = {
      'team_id': teamId,
    };

    Helper.showLoaderDialog(context, message: 'Deleting...');

    ApiHelper.deleteTeam(map).then((value) {
      Navigator.pop(context);
      if (value.message == ' Successfully Deleted') {
        Helper.showSnackVar(value.message!, Colors.green, context);
        setState(() {
          _futureTeam = getTeamList();
        });
      } else {
        Helper.showSnackVar(value.message!, Colors.red, context);
      }
    });
  }

  void joinTeam() {
    if (_teamIdController.text.isEmpty) {
      Helper.showSnackVar('Enter Team Id', Colors.red, context);
      return;
    }

    if (_targetAmtController.text.isEmpty) {
      Helper.showSnackVar('Enter Target Amount', Colors.red, context);
      return;
    }

    Map<String, String> body = {
      'user_id': SessionManager.getUserID(),
      'team_id': _teamIdController.text,
      'member_name': SessionManager.getFirstName(),
      'member_target': _targetAmtController.text,
      'my_amount': _targetAmtController.text
    };

    Helper.showLoaderDialog(context, message: 'Adding...');

    ApiHelper.joinTeam(body).then((value) {
      Navigator.pop(context);
      if (value.message == ' Sub Team Add Successfully ') {
        _teamIdController.clear();
        _targetAmtController.clear();

        Helper.showSnackVar(value.message!, Colors.green, context);
        setState(() {
          joinedFuture = getJoinedTeam();
        });
      } else {
        Helper.showSnackVar(value.message!, Colors.red, context);
      }
    });
  }

  String getCompleteAmount(JoinedTeamData joinedTeamData) {
    if (joinedTeamData.memberCompleted == null) {
      return '₹0';
    }
    return '₹${Helper.formatUnitType(int.parse(joinedTeamData.memberCompleted ?? '0'))}';
  }

  //todo: lock complete amount
  void showLockCompleteAmount(MyTeamData myTeamData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Lock amount",
          fontsize: 22,
          color: Theme.of(context).primaryColor,
        ),
        content: customtext(
          fontWeight: FontWeight.w400,
          text: "Do you want to lock amount for this month",
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
                child: customtext(
                    fontWeight: FontWeight.w600, text: 'No', fontsize: 12),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  lockCompleteAmount(myTeamData);
                },
                child: customtext(
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

  void lockCompleteAmount(MyTeamData myTeamData) async {
    Map<String, String> body = {
      'id': myTeamData.id!,
      'amount': "0",
      'team_id': myTeamData.teamId!,
      "status": "1"
    };

    Helper.showLoaderDialog(context, message: 'Locking...please wait.');

    await ApiHelper.updateTeam(body);

    Map<String, String> copyBody = {'team_id': myTeamData.teamId!};

    ApiHelper.copyTeam(copyBody).then((value) {
      Navigator.pop(context);
      if (value.message == 'Team Coupy Successfully ') {
        Helper.toastMassage(value.message!, Colors.green);
        setState(() {
          _futureTeam = getTeamList();
        });
      } else {
        Helper.toastMassage(value.message!, Colors.red);
      }
    });

    /*ApiHelper.updateTeam(body).then((value) {
      Navigator.pop(context);
      if (value.message == 'Update Team Successfully') {
        Helper.toastMassage(value.message!, Colors.green);
        setState(() {
          _futureTeam = getTeamList();
        });
      } else {
        Helper.toastMassage(value.message!, Colors.red);
      }
    });*/
  }
}

//todo--------------------------- UPDATE ---------------------------------

//todo:-------------------------- UPDATE ---------------------------------

class UpdateJoinCompletedAmount extends StatefulWidget {
  const UpdateJoinCompletedAmount({
    Key? key,
    required this.joinedTeamData,
    required this.type,
  }) : super(key: key);

  final JoinedTeamData joinedTeamData;
  final String type;

  @override
  State<UpdateJoinCompletedAmount> createState() =>
      _UpdateJoinCompletedAmountState();
}

class _UpdateJoinCompletedAmountState extends State<UpdateJoinCompletedAmount> {
  final TextEditingController _amountController = TextEditingController();

  bool isLoading = false;
  String readableAmount = '';

  @override
  void initState() {
    super.initState();

    if (widget.type == 'Target') {
      _amountController.text = widget.joinedTeamData.myAmount ?? '';
    } else {
      _amountController.text = widget.joinedTeamData.myCompleteAmt == null
          ? ''
          : widget.joinedTeamData.myCompleteAmt!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            children: [
              Expanded(
                child: customtext(
                    fontWeight: FontWeight.w500,
                    text: "Update ${widget.type} Business",
                    color: Theme.of(context).primaryColor,
                    fontsize: 20),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear))
            ],
          ),
        ),
        const Divider(),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: CustomAmountTextField(
            hight: 50,
            title: "Enter Business",
            controller: _amountController,
            hint: "fff",
            inputAction: TextInputAction.next,
            inputType: TextInputType.number,
            lableName: "${widget.type} Business",
            hintfont: 12,
            lablefont: 14,
            gapHight: 10,
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  int number = int.parse(value);
                  // data.formatUnitType(number);
                  readableAmount = Helper.formatUnitType(number);
                } else {
                  //  data.formatUnitType(0);
                  readableAmount = '';
                }
              });
            },
            unitType: readableAmount,
          ),
        ),
        const SizedBox(height: 25),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : custom_Button(
                onTap: () {
                  if (widget.type == 'Target') {
                    updateTeamTarget();
                  } else {
                    updateTeam();
                  }
                },
                title: "Update",
                hight: 45,
                width: 150,
                fontSize: 14,
              ),
        const SizedBox(height: 25),
      ],
    );
  }

  void updateTeam() {
    if (_amountController.text.isEmpty) {
      Helper.toastMassage('Enter complete amount', Colors.red);
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, String> body = {
      'id': widget.joinedTeamData.id!,
      'member_completed': _amountController.text,
      'team_id': widget.joinedTeamData.memberUnqiueId!
    };

    print(body);
    ApiHelper.updateJoinTeamAmount(body).then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context, true);
      if (value.message == 'Update  Sub Team Successfully') {
        Helper.toastMassage(value.message!, Colors.green);
      } else {
        Helper.toastMassage(value.message!, Colors.red);
      }
    });
  }

  void updateTeamTarget() {
    if (_amountController.text.isEmpty) {
      Helper.toastMassage('Enter target amount', Colors.red);
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, String> body = {
      'id': widget.joinedTeamData.id!,
      'member_target': _amountController.text,
      'team_id': widget.joinedTeamData.memberUnqiueId!
    };

    print(body);

    ApiHelper.updateMemberSubTeamTarget(body).then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context, true);
      if (value.message == 'Update  Member Target Successfully') {
        Helper.toastMassage(value.message!, Colors.green);
      } else {
        Helper.toastMassage(value.message!, Colors.red);
      }
    });

  }

}

/*
CustomTextField(
            hight: 50,
            title: "Enter Complete Amount",
            controller: _amountController,
            hint: "fff",
            inputAction: TextInputAction.done,
            inputType: TextInputType.number,
            lableName: "Complete Amount",
            hintfont: 12,
            lablefont: 14,
            gapHight: 10,)
 */
