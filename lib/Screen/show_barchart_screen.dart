import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_floting_button.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Screen/add_business_team.dart';
import 'package:smart_leader/Screen/add_mytask_screen.dart';
import 'package:smart_leader/Screen/branch_screen.dart';
import 'package:smart_leader/Screen/business_analysis_screen.dart';
import 'package:smart_leader/Screen/create_key_leaders_screen.dart';
import 'package:smart_leader/Screen/join_team_screen.dart';
import 'package:smart_leader/Screen/join_upline_screen.dart';
import 'package:smart_leader/Widget/bar_chart_widget.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:smart_leader/Widget/sync_barchart_widget.dart';
import 'package:smart_leader/Widget/sync_linechart_widget.dart';
import 'package:smart_leader/fragment/business_creator_fragment.dart';
import 'package:smart_leader/fragment/business_joiner_fragment.dart';

class ShowBarChartScreen extends StatefulWidget {
  const ShowBarChartScreen({Key? key}) : super(key: key);

  @override
  State<ShowBarChartScreen> createState() => _ShowBarChartScreenState();
}

class _ShowBarChartScreenState extends State<ShowBarChartScreen>
    with SingleTickerProviderStateMixin {
  int selectedTab = 0;

  final _tabs = const [
    Tab(text: 'My Key Leaders'),
    Tab(text: 'Joined through Upline'),
  ];
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
        crossAxisAlignment: CrossAxisAlignment.start,
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

              /*Visibility(
                visible: true,
                child: Positioned(
                  right: 20,
                  top: 35,
                  child: SafeArea(
                    child: Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            side: const BorderSide(
                                color: Colors.white, width: 0.5),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const JoinTeamScreen()));
                          },
                          child: customtext(
                            fontWeight: FontWeight.w600,
                            text: 'View Key Leaders',
                            fontsize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        /*TextButton(
                          style: TextButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.white, width: 0.5),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const JoinTeamScreen()));
                          },
                          child: customtext(
                            fontWeight: FontWeight.w600,
                            text: 'Join Team',
                            fontsize: 15.0,
                            color: Colors.white,
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),*/
            ],
          ),
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
                BusinessCreatorFragment(),
                BusinessJoinerFragment()
              ],
            ),
          )
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 60,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: kblueColor,
        type: ExpandableFabType.up,
        closeButtonStyle: ExpandableFabCloseButtonStyle(
          backgroundColor: kblueColor, // Close button background color
          child: Icon(
            Icons.close,
            color: Colors.white, // Close button icon color
          ),
        ),
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            backgroundColor: KBoxNewColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JoinUplineScreen(),
                ),
              );
            },
            label: customtext(
              fontWeight: FontWeight.w700,
              text: 'Join through Upline',
              fontsize: 14.0,
              color: Colors.white,
            ),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            backgroundColor: KBoxNewColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BranchScreen(),
                ),
              );
            },
            label: customtext(
              fontWeight: FontWeight.w700,
              text: 'Track My Team',
              fontsize: 14.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
/*
Text(
                'Add Key Leaders', //Create/Join Team
                style: TextStyle(color: Colors.white),
              )
 */

/*
SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customtext(
                            fontWeight: FontWeight.w500,
                            text: "Chart",
                            fontsize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            height: 2
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: List.generate(
                              growable: true,
                              frequencyContainer.length,
                              (index) => InkWell(
                                onTap: () {
                                  data.getchartContainer(index);
                                },
                                child: Card(
                                  color: SessionManager.getTheme() == true
                                      ? kscafolledColor
                                      : kWhiteColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient:
                                            SessionManager.getTheme() == true
                                                ? data.chartContainer == index
                                                    ? kGradient
                                                    : kgreyGradient
                                                : data.chartContainer == index
                                                    ? kGradient
                                                    : k2Gradient,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                            color: SessionManager.getTheme() ==
                                                    true
                                                ? kscafolledColor
                                                : kblueColor)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22, vertical: 10),
                                      child: Center(
                                        child: customtext(
                                          fontWeight: FontWeight.w400,
                                          text: frequencyContainer[index],
                                          fontsize: 12,
                                          color: data.chartContainer == index
                                              ? kWhiteColor
                                              : Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                              visible: data.chartContainer == 0,
                              child: const SynnBarChart()),
                          const SizedBox(
                            height: 20,
                          ),
                          Visibility(
                              visible: data.chartContainer == 1,
                              child: const SyncLineChartWidget()),
                        ],
                      ),
                    ),
                  ),
 */
