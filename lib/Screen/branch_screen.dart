import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/branch.dart';
import 'package:smart_leader/Screen/team_by_branch_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

import '../Helper/helper.dart';
import '../fragment/key_leader_details_fragment.dart';
import '../fragment/team_details_fragment.dart';
import 'create_key_leaders_screen.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen({Key? key}) : super(key: key);

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> with SingleTickerProviderStateMixin{
  final TextEditingController _branchNameController = TextEditingController();
  int selectedTab = 0;
  late TabController _tabController;

  late Future<Branch> _branchFuture;
  final _tabs = const [
    Tab(text: 'Team Details'),
    Tab(text: 'Key Leader Details'),
  ];

  // Future<Branch> getBranch() {
  //   return ApiHelper.showBranch();
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    //_branchFuture = getBranch();

  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopContainer(
              onTap: () {
                Navigator.pop(context);
              },
              title: "Smart Leader"),
          Container(
            height: 45.0,
            padding: const EdgeInsets.all(3.0),
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            decoration: BoxDecoration(
              border: Border.all(color: KBoxNewColor,width: 1),
              color: Colors.white,
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
                  color:KBoxNewColor),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: _tabs,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                TeamDetailsFragment(),
                CreateKeyLeaderScreen()
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Expanded(
          //         child: CustomTextField(
          //             hight: 50.0,
          //             title: 'Enter Team Name',
          //             controller: _branchNameController,
          //             hint: '',
          //             inputAction: TextInputAction.done,
          //             inputType: TextInputType.text,
          //             lableName: 'Team Name (Max 6 team allowed)',
          //             hintfont: 14,
          //             lablefont: 14),
          //       ),
          //       const SizedBox(width: 10.0),
          //       Container(
          //         margin: const EdgeInsets.only(top: 12.0),
          //         child: custom_Button(
          //           onTap: addBranch,
          //           title: 'Add Team',
          //           hight: 50.0,
          //           width: 100,
          //           fontSize: 12.0,
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // const Divider(),
          // Expanded(
          //   child: FutureBuilder<Branch>(
          //     future: _branchFuture,
          //     builder: (context, response) {
          //       if (response.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //
          //       List<BranchData> branchList = response.data!.data!;
          //
          //       if (branchList.isEmpty) {
          //         return Center(
          //           child: customtext(
          //               fontWeight: FontWeight.w500,
          //               text: 'No Team added',
          //               fontsize: 14.0),
          //         );
          //       }
          //
          //       return ListView.builder(
          //         itemCount: branchList.length,
          //         itemBuilder: (context, index) {
          //           return InkWell(
          //             onTap: () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => TeamByBranchScreen(
          //                     branchData: branchList[index],
          //                   ),
          //                 ),
          //               );
          //             },
          //             child: Container(
          //               margin: const EdgeInsets.symmetric(
          //                   horizontal: 15.0, vertical: 8.0),
          //               padding: const EdgeInsets.symmetric(
          //                   horizontal: 10.0, vertical: 10.0),
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(8.0),
          //                   border: Border.all(color: KBoxNewColor)),
          //               child: Row(
          //                 children: [
          //                   Expanded(
          //                     child: customtext(
          //                       fontWeight: FontWeight.w500,
          //                       text: branchList[index].btanchName!,
          //                       fontsize: 12.0,
          //                       color: Theme.of(context).primaryColor,
          //                     ),
          //                   ),
          //                   Row(
          //                     children: [
          //                       InkWell(
          //                         child: const Icon(
          //                           Icons.edit,
          //                           color: kblueColor,
          //                         ),
          //                         onTap: () {
          //                           showModalBottomSheet(
          //                               context: context,
          //                               builder: (context) {
          //                                 return UpdateBranchWidget(
          //                                   branchData: branchList[index],
          //                                 );
          //                               }).then((value) {
          //                             if (value == true) {
          //                               setState(() {
          //                                 _branchFuture = getBranch();
          //                               });
          //                             }
          //                           });
          //                         },
          //                       ),
          //                       const SizedBox(width: 15.0),
          //                       InkWell(
          //                         child: const Icon(Icons.delete,
          //                             color: kredColor),
          //                         onTap: () {
          //                           deleteDialog(branchList[index].id!);
          //                         },
          //                       ),
          //                     ],
          //                   )
          //                 ],
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
  }
