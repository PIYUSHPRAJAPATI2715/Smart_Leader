import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_dropdown.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/my_team.dart';
import 'package:smart_leader/Screen/my_join_team_screen.dart';
import 'package:smart_leader/Widget/update_team_widget.dart';

class MyTeamFragment extends StatefulWidget {
  const MyTeamFragment({Key? key}) : super(key: key);

  @override
  State<MyTeamFragment> createState() => _MyTeamFragmentState();
}

class _MyTeamFragmentState extends State<MyTeamFragment> {
  List<String> monthList = [];
  List<String> branchList = [];
  String selectedMonth = 'All Month';
  String selectedBranch = 'All Branch';

  List<MyTeamData> myTeamList = [];
  List<MyTeamData> filteredList = [];

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyTeam();
  }

  void getMyTeam() {
    monthList.clear();
    branchList.clear();

    setState(() {
      isLoading = true;
    });

    monthList.add("All Month");
    branchList.add('All Branch');

    ApiHelper.showTeam().then((value) {
      setState(() {
        isLoading = false;
      });

      if (value.data!.isNotEmpty) {
        myTeamList = value.data!;
        filteredList = myTeamList;

        for (var element in myTeamList) {
          if (!monthList.contains(element.monthYear)) {
            monthList.add(element.monthYear!);
          }

          if (!branchList.contains(element.branchId)) {
            branchList.add(element.branchId!);
          }
        }
      }
    });
  }

  void filterMonth(String month) {
    List<MyTeamData> localList = [];
    for (var myTeam in myTeamList) {
      if (myTeam.monthYear!.contains(month)) {
        localList.add(myTeam);
      }
    }
    setState(() {
      filteredList = localList;
    });
  }

  void filterBranch(String branch) {
    List<MyTeamData> localList = [];
    for (var myTeam in myTeamList) {
      if (myTeam.branchId! == branch) {
        print(branch);
        localList.add(myTeam);
      }
    }
    setState(() {
      filteredList = localList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              const SizedBox(height: 10.0),
              Visibility(
                visible: myTeamList.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      FilterDropDownWidget(
                        onChange: (value) {
                          setState(() {
                            selectedMonth = value;

                            if (value == 'All Month') {
                              filteredList = myTeamList;
                            } else {
                              filterMonth(value);
                            }
                          });
                        },
                        items: monthList,
                        initialValue: selectedMonth,
                      ),
                      const SizedBox(width: 20.0),
                      FilterDropDownWidget(
                        onChange: (value) {
                          setState(() {
                            selectedBranch = value;

                            if (value == 'All Branch') {
                              filteredList = myTeamList;
                            } else {
                              filterBranch(value);
                            }
                          });
                        },
                        items: branchList,
                        initialValue: selectedBranch,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              myTeamList.isEmpty
                  ? Center(
                      child: customtext(
                          fontWeight: FontWeight.w500,
                          text: 'No team found',
                          fontsize: 12.0))
                  : MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 0.5)),
                            margin: const EdgeInsets.only(
                                top: 5, left: 15.0, right: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: filteredList[index]
                                                      .teamId!))
                                              .then((_) {
                                            Helper.toastMassage(
                                                'Team ${filteredList[index].teamId!} copied.',
                                                Colors.green);
                                          });
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customtext(
                                              fontWeight: FontWeight.w700,
                                              text:
                                                  filteredList[index].teamName!,
                                              fontsize: 14.0,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            const SizedBox(height: 8.0),
                                            customtext(
                                              fontWeight: FontWeight.w500,
                                              text:
                                                  'Id: ${filteredList[index].teamId}',
                                              fontsize: 14.0,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          customtext(
                                            fontWeight: FontWeight.w400,
                                            text: 'Target',
                                            fontsize: 12.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(height: 8.0),
                                          customtext(
                                            fontWeight: FontWeight.w500,
                                            text:
                                                '₹${Helper.formatUnitType(int.parse(filteredList[index].targetAmount ?? '0'))}',
                                            fontsize: 14.0,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          customtext(
                                            fontWeight: FontWeight.w400,
                                            text: 'Completed',
                                            fontsize: 12.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(height: 8.0),
                                          customtext(
                                            fontWeight: FontWeight.w500,
                                            text:
                                                '₹${Helper.formatUnitType(int.parse(filteredList[index].amount ?? '0'))}',
                                            fontsize: 14.0,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          if (filteredList[index].status ==
                                              '1') {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyJoinTeamScreen(
                                                    type: 'parent',
                                                    teamId: filteredList[index]
                                                        .teamId!,
                                                    month: filteredList[index]
                                                        .monthYear!,
                                                  ),
                                                ));
                                          } else {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const SizedBox(
                                                            height: 15.0),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          MyJoinTeamScreen(
                                                                    type:
                                                                        'parent',
                                                                    teamId: filteredList[
                                                                            index]
                                                                        .teamId!,
                                                                    month: filteredList[
                                                                            index]
                                                                        .monthYear!,
                                                                  ),
                                                                ));
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            minimumSize:
                                                                const Size(
                                                                    double
                                                                        .infinity,
                                                                    40.0),
                                                            side: const BorderSide(
                                                                color:
                                                                    kblueColor,
                                                                width: 0.5),
                                                          ),
                                                          child: customtext(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            text: 'View Detail',
                                                            fontsize: 14.0,
                                                            color: kblueColor,
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: filteredList[
                                                                          index]
                                                                      .targetStatus ==
                                                                  '0'
                                                              ? true
                                                              : false,
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(
                                                                  height: 15.0),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showModalBottomSheet(
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                    )),
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return UpdateTeamTargetWidget(
                                                                        data: filteredList[
                                                                            index],
                                                                        type:
                                                                            'Target',
                                                                      );
                                                                    },
                                                                  ).then(
                                                                      (value) {
                                                                    if (value ==
                                                                        true) {
                                                                      setState(
                                                                          () {
                                                                        //_futureTeam = getTeamList();
                                                                        getMyTeam();
                                                                      });
                                                                    }
                                                                  });
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  side: const BorderSide(
                                                                      color:
                                                                          kblueColor,
                                                                      width:
                                                                          0.5),
                                                                  minimumSize:
                                                                      const Size(
                                                                          double
                                                                              .infinity,
                                                                          40.0),
                                                                ),
                                                                child:
                                                                    customtext(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  text:
                                                                      'Update Target Amount',
                                                                  fontsize:
                                                                      14.0,
                                                                  color:
                                                                      kblueColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: filteredList[
                                                                          index]
                                                                      .targetStatus ==
                                                                  '0'
                                                              ? true
                                                              : false,
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(
                                                                  height: 15.0),
                                                              TextButton(
                                                                onPressed: () {
                                                                  if (filteredList[
                                                                              index]
                                                                          .targetAmount ==
                                                                      '0') {
                                                                    Helper.toastMassage(
                                                                        'Your target amount is 0',
                                                                        Colors
                                                                            .red);
                                                                    return;
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                  showLockTargetAmountDialog(
                                                                      filteredList[
                                                                          index]);
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          0.5),
                                                                  minimumSize:
                                                                      const Size(
                                                                          double
                                                                              .infinity,
                                                                          40.0),
                                                                ),
                                                                child:
                                                                    customtext(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  text:
                                                                      'Lock Target Amount',
                                                                  fontsize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 15.0),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            showModalBottomSheet(
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20),
                                                              )),
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return UpdateTeamTargetWidget(
                                                                  data:
                                                                      filteredList[
                                                                          index],
                                                                  type:
                                                                      'Complete',
                                                                );
                                                              },
                                                            ).then((value) {
                                                              if (value ==
                                                                  true) {
                                                                setState(() {
                                                                  // _futureTeam = getTeamList();
                                                                  getMyTeam();
                                                                });
                                                              }
                                                            });
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            side: const BorderSide(
                                                                color:
                                                                    kblueColor,
                                                                width: 0.5),
                                                            minimumSize:
                                                                const Size(
                                                                    double
                                                                        .infinity,
                                                                    40.0),
                                                          ),
                                                          child: customtext(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            text:
                                                                'Update Complete Amount',
                                                            fontsize: 14.0,
                                                            color: kblueColor,
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: filteredList[
                                                                          index]
                                                                      .amount ==
                                                                  '0'
                                                              ? false
                                                              : true,
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(
                                                                  height: 15.0),
                                                              TextButton(
                                                                onPressed: () {
                                                                  if (filteredList[
                                                                              index]
                                                                          .amount ==
                                                                      '0') {
                                                                    Helper.toastMassage(
                                                                        'Your complete amount is 0',
                                                                        Colors
                                                                            .red);
                                                                    return;
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                  showLockCompleteAmount(
                                                                      filteredList[
                                                                          index]);
                                                                },
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          0.5),
                                                                  minimumSize:
                                                                      const Size(
                                                                          double
                                                                              .infinity,
                                                                          40.0),
                                                                ),
                                                                child:
                                                                    customtext(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  text:
                                                                      'Lock Complete Amount',
                                                                  fontsize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 15.0),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            deleteDialog(
                                                              filteredList[
                                                                      index]
                                                                  .teamId!,
                                                            );
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            side: const BorderSide(
                                                                color:
                                                                    kredColor,
                                                                width: 0.5),
                                                            minimumSize:
                                                                const Size(
                                                                    double
                                                                        .infinity,
                                                                    40.0),
                                                          ),
                                                          child: customtext(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            text: 'Delete Team',
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
                                        child: customtext(
                                          fontWeight: FontWeight.w500,
                                          text:
                                              filteredList[index].status == '0'
                                                  ? 'Edit'
                                                  : 'View',
                                          fontsize: 12.0,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 1),
                                  decoration: const BoxDecoration(
                                      color: Colors.deepPurple),
                                  child: customtext(
                                    fontWeight: FontWeight.w500,
                                    text:
                                        'My Target: ₹${Helper.formatUnitType(int.parse(filteredList[index].myAmount ?? '0'))}',
                                    fontsize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0, vertical: 1),
                                      decoration: const BoxDecoration(
                                          color: Colors.red),
                                      child: customtext(
                                        fontWeight: FontWeight.w500,
                                        text: filteredList[index].monthYear!,
                                        fontsize: 12.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0, vertical: 1),
                                      decoration: const BoxDecoration(
                                          color: Colors.green),
                                      child: customtext(
                                        fontWeight: FontWeight.w500,
                                        text: filteredList[index].branchId!,
                                        fontsize: 12.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      child: const Icon(Icons.refresh),
                                      onTap: () {
                                        updateTargetAmount(
                                            filteredList[index].id!,
                                            filteredList[index].myAmount!);
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
            ],
          );
  }

  void updateTargetAmount(String id, String amount) {
    Helper.showLoaderDialog(context, message: 'Refresh...');
    Map<String, String> body = {'id': id, 'target_amount': amount};

    ApiHelper.updateTargetTeam(body).then((value) {
      Navigator.pop(context);
      if (value.message == ' Target Amount Update Successfully') {
        setState(() {
          getMyTeam();
        });
        //Helper.toastMassage(value.message!, Colors.green);
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
    Map<String, String> map = {'team_id': teamId};

    Helper.showLoaderDialog(context, message: 'Deleting...');

    ApiHelper.deleteTeam(map).then((value) {
      Navigator.pop(context);
      if (value.message == ' Successfully Deleted') {
        Helper.showSnackVar(value.message!, Colors.green, context);
        setState(() {
          getMyTeam();
        });
      } else {
        Helper.showSnackVar(value.message!, Colors.red, context);
      }
    });
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

    print(copyBody);
    ApiHelper.copyTeam(copyBody).then((value) {
      Navigator.pop(context);
      if (value.message == 'Team Coupy Successfully ') {
        Helper.toastMassage(value.message!, Colors.green);
        setState(() {
          getMyTeam();
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

  //todo: lock target amount
  void showLockTargetAmountDialog(MyTeamData myTeamData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Lock target amount",
          fontsize: 22,
          color: Theme.of(context).primaryColor,
        ),
        content: customtext(
          fontWeight: FontWeight.w400,
          text: "Do you want to lock target amount for this month",
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
                  lockTargetAmount(myTeamData);
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

  void lockTargetAmount(MyTeamData myTeamData) async {
    Map<String, String> body = {
      'id': myTeamData.id!,
    };

    Helper.showLoaderDialog(context, message: 'Locking...please wait.');

    ApiHelper.updateTargetLock(body).then((value) {
      Navigator.pop(context);
      if (value.message == 'Update Target Amount Lock Successfully') {
        Helper.toastMassage(value.message!, Colors.green);
        setState(() {
          getMyTeam();
        });
      } else {
        Helper.toastMassage(value.message!, Colors.red);
      }
    });
  }
}
