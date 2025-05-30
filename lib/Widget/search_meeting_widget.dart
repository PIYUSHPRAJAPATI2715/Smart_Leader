import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/ExtractClasses/short_dialog_widget.dart';
import 'package:smart_leader/ExtractClasses/tools_searchbar.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_search_meeting_modal.dart';

class SearchMeetingWidget extends StatefulWidget {
  const SearchMeetingWidget({Key? key}) : super(key: key);

  @override
  State<SearchMeetingWidget> createState() => _SearchMeetingWidgetState();
}

class _SearchMeetingWidgetState extends State<SearchMeetingWidget> {
  bool isSubmit = true;
  late Future<ShowSearchMeetingModal> showMeeting;
  List<ShowSearchMeetingModalData> showMeetingList = [];
  List<ShowSearchMeetingModalData> tampList = [];
  String lastInputValue = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showMeetings();
  }

  void showMeetings() {


    ApiHelper.showsearchMeeting().then((value) {
      setState(() {
        isSubmit = false;
      });
      if (value.message == "Search Meeting showing Is Successfully") {
        showMeetingList = value.data!;
        tampList = showMeetingList;

      }
    });
  }

  void searchTask(String value) {
    final suggestions = showMeetingList.where((element) {
      final taskTitle = element.title!.toLowerCase();
      final input = value.toLowerCase();

      return taskTitle.startsWith(input);
    }).toList();

    setState(() {
      showMeetingList = suggestions;
    });

    print("djuduijhdsohoh${showMeetingList.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
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
                      child: Icon(
                        Icons.arrow_back,
                        color: kWhiteColor,
                      )),

                ],
              ),
            ),
          ),
          ToolsSearchBarWidget(
            enable: true,
            onchange: (value) {
              if (lastInputValue != value) {
                lastInputValue = value;
                print("New value inserted in textField ${value.length}");
                if (value.length == 0) {
                  setState(() {
                    showMeetingList = tampList;
                  });
                } else {
                  searchTask(value);
                }
              }
            },
            ontapIcon: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ShortDialogWidget(
                      onDSCDateTap: (){
                        setState(() {
                          showMeetingList
                              .sort((a, b) => b.date!.compareTo(a.date!));
                        });
                        Navigator.pop(context);
                      },
                      onFrequencyTap: (){},
                      onZtoATap: (){
                        setState(() {
                          showMeetingList
                              .sort((a, b) => b.title!.compareTo(a.title!));
                        });
                        Navigator.pop(context);
                      },
                      alphaOntap: () {
                        setState(() {
                          showMeetingList
                              .sort((a, b) => a.title!.compareTo(b.title!));
                        });
                        Navigator.pop(context);
                      },
                      dateOntap: () {
                        setState(() {
                          showMeetingList
                              .sort((a, b) => a.date!.compareTo(b.date!));
                        });
                        Navigator.pop(context);
                      },
                    );
                  });
            },
          ),
          isSubmit == true
              ? Center(
            child: CircularProgressIndicator(),
          )
              :Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  physics:NeverScrollableScrollPhysics(),
                  itemCount: showMeetingList.length,
                  itemBuilder: (BuildContext, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 4),
                      child: Row(
                        children: [
                          customtext(
                            fontWeight: FontWeight.w500,
                            text: showMeetingList[index].time!,
                            fontsize: 16,
                            color: SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kbuttonColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  color: SessionManager.getTheme() ==
                                      true
                                      ? kscafolledColor
                                      : Color(0xffBBB5F1)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          customtext(
                                              fontWeight: FontWeight.w500,
                                              text: showMeetingList[index].title!,
                                              fontsize: 16,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          customtext(
                                            fontWeight: FontWeight.w600,
                                            text: showMeetingList[index].leaderName!,
                                            fontsize: 13,
                                            color: SessionManager
                                                .getTheme() ==
                                                true
                                                ? kWhiteColor
                                                : kbuttonColor,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .watch_later_outlined,
                                                size: 15,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              customtext(
                                                fontWeight:
                                                FontWeight.w400,
                                                text: showMeetingList[index].reminder!,
                                                fontsize: 13,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  customtext(
                                    fontWeight: FontWeight.w500,
                                    text: showMeetingList[index].selectType!,
                                    fontsize: 16,
                                    color:
                                    SessionManager.getTheme() ==
                                        true
                                        ? kWhiteColor
                                        : kbuttonColor,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
