import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Modal/branch.dart';
import 'package:smart_leader/Modal/team_branch.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

import '../Componants/custom_dropdown.dart';
import '../Helper/theme_colors.dart';
import '../Modal/my_team.dart';

class TeamByBranchScreen extends StatefulWidget {
  const TeamByBranchScreen({Key? key, required this.branchData})
      : super(key: key);

  final BranchData branchData;

  @override
  State<TeamByBranchScreen> createState() => _TeamByBranchScreenState();
}

class _TeamByBranchScreenState extends State<TeamByBranchScreen> {
  late Future<TeamBranch> _branchByTeamFuture;

  Future<TeamBranch> getTeamByBranch() {
    return ApiHelper.showBranchByTeam(widget.branchData.id!);
  }

  String selectedMonth = 'All Months';
  String selectedBranch = 'All Teams';
  List<String> monthList = [];
  List<String> branchList = [];

  List<MyTeamData> myTeamList = [];
  List<MyTeamData> filteredList = [];

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _branchByTeamFuture = getTeamByBranch();
    getMyTeam();

  }

  void getMyTeam() {
    monthList.clear();
    branchList.clear();
    myTeamList.clear();
    filteredList.clear();

    setState(() {
      isLoading = true;
    });

    monthList.add("All Months");
    branchList.add('All Teams');

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
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10,right: 15),
            child: Row(
              children: [
                customtext(
                  fontWeight: FontWeight.w500,
                  text: '${widget.branchData.btanchName}',
                  fontsize: 14.0,
                  color: Theme.of(context).primaryColor,
                ),
                Spacer(),
                SizedBox(
                  width: 120.0,
                  child: FilterDropDownWidget(
                    onChange: (value) {
                      setState(() {
                        selectedMonth = value;

                        if (value == 'All Months') {
                          filteredList = myTeamList;
                        } else {
                          filterMonth(value);
                        }
                      });
                    },
                    items: monthList,
                    initialValue: selectedMonth,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<TeamBranch>(
                future: _branchByTeamFuture,
                builder: (context, response) {
                  if (response.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<TeamBranchData> teamList = response.data!.data!;
                  if (teamList.isEmpty) {
                    return Center(
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: 'No Team Found',
                            fontsize: 14.0));
                  }
                  return ListView.builder(
                    itemCount: teamList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: KBoxNewColor,
                                width: 0.5)),
                        margin: const EdgeInsets.only(
                            top: 15, left: 15.0, right: 15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customtext(
                                        fontWeight: FontWeight.w700,
                                        text: teamList[index].teamName!,
                                        fontsize: 14.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(height: 8.0),
                                      customtext(
                                        fontWeight: FontWeight.w500,
                                        text: 'Id:${teamList[index].teamId!}',
                                        fontsize: 14.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      customtext(
                                        fontWeight: FontWeight.w400,
                                        text: 'Target',
                                        fontsize: 12.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(height: 8.0),
                                      customtext(
                                        fontWeight: FontWeight.w500,
                                        text:
                                            '₹${teamList[index].targetAmount!}',
                                        fontsize: 14.0,
                                        color: Colors.black,
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
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(height: 8.0),
                                      customtext(
                                        fontWeight: FontWeight.w500,
                                        text: '₹${teamList[index].amount}',
                                        fontsize: 14.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
/*
  Expanded(
                              child: TextButton(
                                  onPressed: () {
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
                                                                teamId:
                                                                myTeamList[index]
                                                                    .teamId!,
                                                              ),
                                                        ));
                                                  },
                                                  style: TextButton.styleFrom(
                                                    minimumSize: const Size(
                                                        double.infinity, 40.0),
                                                    side: const BorderSide(
                                                        color: kblueColor,
                                                        width: 0.5),
                                                  ),
                                                  child: customtext(
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
                                                      shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                            Radius.circular(20),
                                                            topRight:
                                                            Radius.circular(20),
                                                          )),
                                                      context: context,
                                                      builder: (context) {
                                                        return UpdateTeamTargetWidget(
                                                          data: myTeamList[index],
                                                          type: 'Target',
                                                        );
                                                      },
                                                    ).then((value) {
                                                      if (value == true) {
                                                        setState(() {
                                                          _futureTeam =
                                                              getTeamList();
                                                        });
                                                      }
                                                    });
                                                  },
                                                  style: TextButton.styleFrom(
                                                    side: const BorderSide(
                                                        color: kblueColor,
                                                        width: 0.5),
                                                    minimumSize: const Size(
                                                        double.infinity, 40.0),
                                                  ),
                                                  child: customtext(
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
                                                      shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                            Radius.circular(20),
                                                            topRight:
                                                            Radius.circular(20),
                                                          )),
                                                      context: context,
                                                      builder: (context) {
                                                        return UpdateTeamTargetWidget(
                                                          data: myTeamList[index],
                                                          type: 'Complete',
                                                        );
                                                      },
                                                    ).then((value) {
                                                      if (value == true) {
                                                        setState(() {
                                                          _futureTeam =
                                                              getTeamList();
                                                        });
                                                      }
                                                    });
                                                  },
                                                  style: TextButton.styleFrom(
                                                    side: const BorderSide(
                                                        color: kblueColor,
                                                        width: 0.5),
                                                    minimumSize: const Size(
                                                        double.infinity, 40.0),
                                                  ),
                                                  child: customtext(
                                                    fontWeight: FontWeight.w500,
                                                    text: 'Update Complete Amount',
                                                    fontsize: 14.0,
                                                    color: kblueColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 15.0),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    deleteDialog(
                                                      myTeamList[index].teamId!,
                                                    );
                                                  },
                                                  style: TextButton.styleFrom(
                                                    side: const BorderSide(
                                                        color: kredColor,
                                                        width: 0.5),
                                                    minimumSize: const Size(
                                                        double.infinity, 40.0),
                                                  ),
                                                  child: customtext(
                                                    fontWeight: FontWeight.w500,
                                                    text: 'Delete Team',
                                                    fontsize: 14.0,
                                                    color: kredColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: customtext(
                                    fontWeight: FontWeight.w500,
                                    text: 'Edit',
                                    fontsize: 12.0,
                                    color: Theme.of(context).primaryColor,
                                  )))
 */
