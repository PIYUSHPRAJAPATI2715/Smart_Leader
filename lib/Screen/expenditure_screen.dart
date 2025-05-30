import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_floting_button.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_expense.dart';
import 'package:smart_leader/Screen/add_expenses_screen.dart';
import 'package:smart_leader/Screen/expenditure_analysis_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class ExpenditureScreen extends StatefulWidget {
  const ExpenditureScreen({Key? key}) : super(key: key);

  @override
  State<ExpenditureScreen> createState() => _ExpenditureScreenState();
}

class _ExpenditureScreenState extends State<ExpenditureScreen> {
  String type = 'Jan';

  List<ShowExpenseData> _showExpenseList = [];

  bool isLoading = false;

  double totalExpenditure = 0;

  void getShowExpense() {
    setState(() {
      isLoading = true;
    });
    ApiHelper.showExpense().then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.data!.isNotEmpty) {
        _showExpenseList = value.data!;

        for (var element in _showExpenseList) {
          totalExpenditure += double.parse(element.amount!);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShowExpense();
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

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: _showExpenseList.isEmpty
                      ? Center(
                          child: customtext(
                              fontWeight: FontWeight.w600,
                              text: 'No Expense Found',
                              fontsize: 15.0),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: SessionManager.getTheme() == true
                                          ? kscafolledColor
                                          : kWhiteColor),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        icon:
                                            Icon(Icons.arrow_drop_down_rounded),
                                        iconEnabledColor:
                                            SessionManager.getTheme() == true
                                                ? kWhiteColor
                                                : kbuttonColor,
                                        dropdownColor:
                                            SessionManager.getTheme() == true
                                                ? Colors.indigo
                                                : Colors.yellow.shade50,
                                        itemHeight: kMinInteractiveDimension,
                                        style: TextStyle(
                                            color: SessionManager.getTheme() ==
                                                    true
                                                ? kWhiteColor
                                                : kBlackColor,
                                            fontFamily: "NunitoSans",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17),
                                        elevation: 5,
                                        value: type,
                                        hint: customtext(
                                          fontWeight: FontWeight.w700,
                                          text: "",
                                          fontsize: 15,
                                          color:
                                              SessionManager.getTheme() == true
                                                  ? kWhiteColor
                                                  : kbuttonColor,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        items: <String>[
                                          'Jan',
                                          'Fab',
                                          'Mar',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: customtext(
                                              fontWeight: FontWeight.w700,
                                              text: value,
                                              fontsize: 15,
                                              color:
                                                  SessionManager.getTheme() ==
                                                          true
                                                      ? kWhiteColor
                                                      : kBlackColor,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            type = value!;
                                          });
                                        }),
                                  ),
                                ),
                                customtext(
                                  fontWeight: FontWeight.w600,
                                  text: "Total Expenditure",
                                  fontsize: 23,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                customtext(
                                  fontWeight: FontWeight.w600,
                                  text: "₹${totalExpenditure}",
                                  fontsize: 19,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: customtext(
                                        fontWeight: FontWeight.w600,
                                        text: "Recent Transection",
                                        fontsize: 19,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    customtext(
                                      fontWeight: FontWeight.w400,
                                      text: "See All",
                                      fontsize: 15,
                                      color: SessionManager.getTheme() == true
                                          ? kWhiteColor
                                          : kblueColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _showExpenseList.length,
                                    itemBuilder: (context, index) {
                                      return ShowExpenseWidget(
                                        data: _showExpenseList[index],
                                      );
                                    }),
                                SizedBox(height: 20),
                                customtext(
                                  fontWeight: FontWeight.w600,
                                  text: "Analysis",
                                  fontsize: 19,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExpenditureAnalysisScreen()));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 25),
                                          decoration: BoxDecoration(
                                              color:
                                                  SessionManager.getTheme() ==
                                                          true
                                                      ? kscafolledColor
                                                      : klightblue,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: customtext(
                                              alignment: TextAlign.center,
                                              fontWeight: FontWeight.w600,
                                              text: "Week\nAnalysis",
                                              fontsize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExpenditureAnalysisScreen()));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 25),
                                          decoration: BoxDecoration(
                                              color:
                                                  SessionManager.getTheme() ==
                                                          true
                                                      ? kscafolledColor
                                                      : klightblue,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: customtext(
                                              alignment: TextAlign.center,
                                              fontWeight: FontWeight.w600,
                                              text: "Month\nAnalysis",
                                              fontsize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExpenditureAnalysisScreen()));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 25),
                                          decoration: BoxDecoration(
                                              color:
                                                  SessionManager.getTheme() ==
                                                          true
                                                      ? kscafolledColor
                                                      : klightblue,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: customtext(
                                              alignment: TextAlign.center,
                                              fontWeight: FontWeight.w600,
                                              text: "Year\nAnalysis",
                                              fontsize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
        ],
      ),
      floatingActionButton: Custom_flowting_action_button(onTap: () {
        goToExpense();
      }),
    );
  }

  void goToExpense() {
    final data = Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddExpensesScreen()));

    print('Data $data');
  }
}

class ShowExpenseWidget extends StatelessWidget {
  const ShowExpenseWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ShowExpenseData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          color: getColor(data.priority!),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              customtext(
                fontWeight: FontWeight.w500,
                text: "Date:",
                fontsize: 14,
                color: kWhiteColor,
              ),
              SizedBox(
                width: 10,
              ),
              customtext(
                fontWeight: FontWeight.w500,
                text: data.date!,
                fontsize: 17,
                color: kWhiteColor,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              customtext(
                fontWeight: FontWeight.w500,
                text: "Amount:",
                fontsize: 14,
                color: kWhiteColor,
              ),
              SizedBox(
                width: 10,
              ),
              customtext(
                fontWeight: FontWeight.w500,
                text: '₹${data.amount!}',
                fontsize: 17,
                color: kWhiteColor,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              customtext(
                fontWeight: FontWeight.w500,
                text: "Reason:",
                fontsize: 14,
                color: kWhiteColor,
              ),
              SizedBox(
                width: 10,
              ),
              customtext(
                fontWeight: FontWeight.w500,
                text: data.reason!,
                fontsize: 17,
                color: kWhiteColor,
              ),
            ],
          )
        ],
      ),
    );
  }

  Color getColor(String priority) {
    if (priority == 'High') {
      return kredColor;
    }

    if (priority == 'Medium') {
      return kyelloColor;
    }
    return Colors.green.shade700;
  }
}
//  Row(
//                       children: [
//                         Expanded(
//                           child: customtext(
//                             fontWeight: FontWeight.w600,
//                             text: "Recommendations",
//                             fontsize: 19,
//                             color: Theme
//                                 .of(context)
//                                 .primaryColor,
//                           ),
//                         ),
//                         customtext(
//                           fontWeight: FontWeight.w500,
//                           text: "All",
//                           fontsize: 19,
//                           color: Theme
//                               .of(context)
//                               .primaryColor,
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     ListView.builder(
//                         padding: EdgeInsets.zero,
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: 3,
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             onTap: () {
//                               Navigator.push(context, MaterialPageRoute(
//                                   builder: (context) => RecommandedScreen()));
//                             },
//                             child: Container(
//                               margin: EdgeInsets.symmetric(vertical: 5),
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 10
//                               ),
//                               decoration: BoxDecoration(
//                                   color: SessionManager.getTheme() == true
//                                       ? kscafolledColor
//                                       : klightblue,
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: Row(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 40,
//                                     backgroundColor: kWhiteColor,
//                                     child: Center(
//                                         child: Image.asset(
//                                           "assest/images/recommimage.png",
//                                           height: 35,
//                                           width: 35,
//                                         )),
//                                   ),
//                                   SizedBox(width: 20,),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment
//                                           .start,
//                                       children: [
//                                         customtext(
//                                           fontWeight: FontWeight.w600,
//                                           text: "Lorem Ipsum is Simply Dummy",
//                                           fontsize: 15,
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor,
//                                         ),
//                                         customtext(
//
//                                           fontWeight: FontWeight.w400,
//                                           text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
//                                           fontsize: 7,
//                                           color: Theme
//                                               .of(context)
//                                               .primaryColor,
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         })
