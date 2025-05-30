import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_floting_button.dart';
import 'package:smart_leader/Componants/popup_menuBar.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/events.dart';
import 'package:smart_leader/Screen/view_meeting_screen.dart';
import 'package:smart_leader/Widget/addEvent.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:smart_leader/Widget/edit_event_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../Modal/new_event.dart';
import '../Widget/add_meeting_widget.dart';
import 'branch_screen.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  bool isLoading = false;

  Map<String, List> mySelectedEvents = {};
  List dateList = [];

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = _focusedDay;
    getNewEvent();
  }

  /*
  void getEvents() async {
    mySelectedEvents.clear();
    setState(() {
      isLoading = true;
    });
    Events events = await ApiHelper.showEvent('');

    setState(() {
      isLoading = false;
    });
    for (EventDate date in events.data!) {
      mySelectedEvents[date.date!] = date.toJson()['data'];
    }
  }
  */

  void getNewEvent() async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> body = {'user_id': SessionManager.getUserID()};
    NewEvent events = await ApiHelper.getNewEvent(body);

    setState(() {
      isLoading = false;
    });

    events.result!.sort((a, b) {
      // Compare dates
      int dateComparison = a.date!.compareTo(b.date!);
      if (dateComparison == 0) {
        // If dates are the same, compare times
        return a.time!.compareTo(b.time!);
      }
      return dateComparison;
    });

    Map<String, List<Map<String, dynamic>>> groupedEvents =
        groupBy(events.toJson()['result'], (event) => event["date"]);

    mySelectedEvents = groupedEvents;

  }

  Map<K, List<V>> groupBy<K, V>(List<V> list, K Function(V) getKey) {
    Map<K, List<V>> result = {};

    for (var item in list) {
      var key = getKey(item);
      result.putIfAbsent(key, () => []).add(item);
    }

    return result;
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('dd-MM-yyyy').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('dd-MM-yyyy').format(dateTime)]!

          .toList();
    } else {
      return [];
    }
  }

  _showEventDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: AddEventWidget(
              selectedDate: _selectedDate!,
            ),
          );
        }).then((value) {
      if (value == true) {
        getNewEvent();
      }
    });
  }

  _showEditEventDialog(Map<String, dynamic> map) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: EditEventWidget(map: map),
          );
        }).then((value) {
      if (value == true) {
        getNewEvent();
      }
    });
  }

  //todo: delete event
  void deleteEvent(String id) {
    Map<String, String> body = {'id': id};

    Helper.showLoaderDialog(context, message: 'Deleting');

    ApiHelper.deleteNewEvent(body).then((value) {
      Navigator.pop(context);
      if (value.status!.toLowerCase() == 'true') {
        Helper.showSnackVar(value.massage!, Colors.green, context);
        getNewEvent();
      } else {
        Helper.showSnackVar(value.massage!, Colors.red, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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

          Expanded(
            child: SingleChildScrollView(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        TableCalendar(

                          calendarStyle:  CalendarStyle(
                            markerDecoration: BoxDecoration(
                                color:KBoxNewColor, shape: BoxShape.circle),
                            selectedDecoration: BoxDecoration(
                              color: Color(0xffEFE4B0),
                              border: Border.all(
                                color: KBoxNewColor,
                                width: 2.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color:   Color(0xffEFE4B0),
                              shape: BoxShape.circle,
                            ),
                            todayTextStyle: const TextStyle(
                              color: Colors.black,
                            ) ,
                            selectedTextStyle: const TextStyle(
                              color: Colors.black,
                            ),
                          ),

                          headerStyle: HeaderStyle(
                              leftChevronIcon: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    gradient: SessionManager.getTheme() == true
                                        ? k2Gradient
                                        : kGradient,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 20,
                                  color: SessionManager.getTheme() == true
                                      ? kBlackColor
                                      : kWhiteColor,
                                )),
                              ),
                              rightChevronIcon: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    gradient: SessionManager.getTheme() == true
                                        ? k2Gradient
                                        : kGradient,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 20,
                                  color: SessionManager.getTheme() == true
                                      ? kBlackColor
                                      : kWhiteColor,
                                )),
                              ),
                              titleCentered: true,
                              formatButtonVisible: false),
                          firstDay: DateTime(2022),
                          lastDay: DateTime(2060),
                          focusedDay: _focusedDay,
                          calendarFormat: CalendarFormat.month,
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!isSameDay(_selectedDate, selectedDay)) {
                              // Call `setState()` when updating the selected day
                              setState(() {
                                _selectedDate = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            }
                          },
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDate, day);
                          },
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              // Call `setState()` when updating calendar format
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            // No need to call `setState()` here
                            _focusedDay = focusedDay;
                          },
                          eventLoader: _listOfDayEvents,
                        ),
                        ..._listOfDayEvents(_selectedDate!).map(
                          (myEvents) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 4),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: true,
                                  child: customtext(
                                    fontWeight: FontWeight.w800,
                                    text: myEvents['time'],
                                    fontsize: 16,
                                    color: SessionManager.getTheme() == true
                                        ? kWhiteColor
                                        : kbuttonColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(8),
                                      color: SessionManager.getTheme() == true
                                          ? kscafolledColor
                                          : const  Color(0xffEFE4B0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: customtext(
                                                    fontWeight: FontWeight.w600,
                                                    text:
                                                        '${myEvents['meeting_type']} with ${myEvents['title']}',
                                                    fontsize: 15,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Visibility(
                                                        visible: false,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 2),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: SessionManager
                                                                        .getTheme() ==
                                                                    true
                                                                ? kBlackColor
                                                                : kWhiteColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              customtext(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                text: myEvents[
                                                                    'added_type'],
                                                                fontsize: 9,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                              const SizedBox(
                                                                width: 2,
                                                              ),
                                                              /*
                                                        Image.asset(
                                                          "assest/png_icon/onlinemettingIcon.png",
                                                          height: 17,
                                                          width: 14,
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                        )*/
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Visibility(
                                                        visible: myEvents[
                                                                'added_type'] !=
                                                            'CONNECTION',
                                                        child: SizedBox(
                                                            width: 25,
                                                            height: 25,
                                                            child: SimplePopUp(
                                                                onChanged:
                                                                    (value) {
                                                                  print(value);
                                                                  if (value ==
                                                                      1) {
                                                                    _showEditEventDialog(
                                                                        myEvents);
                                                                  } else if (value ==
                                                                      2) {
                                                                  } else if (value ==
                                                                      3) {
                                                                    showDeleteDialog( myEvents[
                                                                    'id']);

                                                                  }
                                                                },
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              customtext(
                                                fontWeight: FontWeight.w500,
                                                text: myEvents['description'],
                                                fontsize: 12,
                                                color:
                                                    SessionManager.getTheme() ==
                                                            true
                                                        ? kWhiteColor
                                                        : kbuttonColor,
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                        /* Divider(
                                          thickness: 2,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    customtext(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      text: myEvents['time'],
                                                      fontsize: 10,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .watch_later_outlined,
                                                      size: 12,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              customtext(
                                                fontWeight: FontWeight.w400,
                                                text: getEventType(myEvents),
                                                fontsize: 10,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        */
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  builder: (context) => const AddMeetingWidget(),
                ),
              );
            },
            label: customtext(
              fontWeight: FontWeight.w700,
              text: 'Add Event',
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
                  builder: (context) => const ViewMeeting(),
                ),
              );
            },
            label: customtext(
              fontWeight: FontWeight.w700,
              text: 'View Event',
              fontsize: 14.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  void showDeleteDialog(String deleteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Confirm Deletion ?",
          fontsize: 22,
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
                  deleteEvent(deleteId);
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

  String getEventType(Map<String, dynamic> map) {
    if (map['type'] == 'Meeting') {
      return map['meeting_place'];
    }

    if (map['type'] == 'Birthday') {
      return map['birthday_parson'];
    }

    if (map['type'] == 'General') {
      return map['place'];
    }

    return '';
  }
}

/*
_showAddEventDialog() async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Add New Event',
        textAlign: TextAlign.center,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: descpController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          child: const Text('Add Event'),
          onPressed: () {
            if (titleController.text.isEmpty &&
                descpController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Required title and description'),
                  duration: Duration(seconds: 2),
                ),
              );
              //Navigator.pop(context);
              return;
            } else {
              print(titleController.text);
              print(descpController.text);

              setState(() {
                if (mySelectedEvents[
                DateFormat('yyyy-MM-dd').format(_selectedDate!)] !=
                    null) {
                  mySelectedEvents[
                  DateFormat('yyyy-MM-dd').format(_selectedDate!)]
                      ?.add({
                    "eventTitle": titleController.text,
                    "eventDescp": descpController.text,
                  });
                } else {
                  mySelectedEvents[
                  DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
                    {
                      "eventTitle": titleController.text,
                      "eventDescp": descpController.text,
                    }
                  ];
                }
              });

              print(
                  "New Event for backend developer ${json.encode(mySelectedEvents)}");
              titleController.clear();
              descpController.clear();
              Navigator.pop(context);
              return;
            }
          },
        )
      ],
    ),
  );
}
*/

//   ListView.builder(
//                       itemCount: 4,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 10),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               customtext(
//                                 fontWeight: FontWeight.w400,
//                                 text: "8 OCT 2022",
//                                 fontsize: 20,
//                                 color: SessionManager.getTheme() == true
//                                     ? kWhiteColor
//                                     : kbuttonColor,
//                               ),
//                               ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: 4,
//                                   itemBuilder: (context, index) {
//                                     return Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 5, vertical: 4),
//                                       child: Row(
//                                         children: [
//                                           customtext(
//                                             fontWeight: FontWeight.w500,
//                                             text: "6 AM",
//                                             fontsize: 16,
//                                             color: SessionManager.getTheme() ==
//                                                     true
//                                                 ? kWhiteColor
//                                                 : kbuttonColor,
//                                           ),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           Expanded(
//                                             child: Container(
//                                               margin:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 3),
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 10),
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.rectangle,
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                                 color:
//                                                     SessionManager.getTheme() ==
//                                                             true
//                                                         ? kscafolledColor
//                                                         : const Color(
//                                                             0xffE6E6E6),
//                                               ),
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Padding(
//                                                     padding: const EdgeInsets
//                                                             .symmetric(
//                                                         horizontal: 10),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Expanded(
//                                                                 child:
//                                                                     customtext(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               text: "Breakfast",
//                                                               fontsize: 15,
//                                                               color: Theme.of(
//                                                                       context)
//                                                                   .primaryColor,
//                                                             )),
//                                                             Row(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Container(
//                                                                   padding: const EdgeInsets
//                                                                           .symmetric(
//                                                                       horizontal:
//                                                                           5,
//                                                                       vertical:
//                                                                           2),
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     color: SessionManager.getTheme() ==
//                                                                             true
//                                                                         ? kBlackColor
//                                                                         : kWhiteColor,
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             10),
//                                                                   ),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .center,
//                                                                     children: [
//                                                                       customtext(
//                                                                         fontWeight:
//                                                                             FontWeight.w500,
//                                                                         text:
//                                                                             "Online",
//                                                                         fontsize:
//                                                                             9,
//                                                                         color: Theme.of(context)
//                                                                             .primaryColor,
//                                                                       ),
//                                                                       const SizedBox(
//                                                                         width:
//                                                                             2,
//                                                                       ),
//                                                                       Image
//                                                                           .asset(
//                                                                         "assest/png_icon/onlinemettingIcon.png",
//                                                                         height:
//                                                                             17,
//                                                                         width:
//                                                                             14,
//                                                                         color: Theme.of(context)
//                                                                             .primaryColor,
//                                                                       )
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                                 const SizedBox(
//                                                                   width: 10,
//                                                                 ),
//                                                                 SizedBox(
//                                                                     width: 10,
//                                                                     height: 12,
//                                                                     child: SimplePopUp(
//                                                                         onChanged: (value) {
//                                                                           if (value ==
//                                                                               1) {
//                                                                           } else if (value ==
//                                                                               2) {
//                                                                           } else if (value ==
//                                                                               3) {
//                                                                             setState(() {});
//                                                                           }
//                                                                         },
//                                                                         color: Theme.of(context).primaryColor)),
//                                                               ],
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         const SizedBox(
//                                                             height: 10),
//                                                         customtext(
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           text:
//                                                               "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
//                                                           fontsize: 12,
//                                                           color: SessionManager
//                                                                       .getTheme() ==
//                                                                   true
//                                                               ? kWhiteColor
//                                                               : kbuttonColor,
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 3,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Divider(
//                                                     thickness: 2,
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets
//                                                             .symmetric(
//                                                         horizontal: 10),
//                                                     child: Row(
//                                                       children: [
//                                                         Expanded(
//                                                           child: Row(
//                                                             children: [
//                                                               customtext(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w400,
//                                                                 text:
//                                                                     "06:05 PM",
//                                                                 fontsize: 10,
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .primaryColor,
//                                                               ),
//                                                               const SizedBox(
//                                                                 width: 5,
//                                                               ),
//                                                               Icon(
//                                                                 Icons
//                                                                     .watch_later_outlined,
//                                                                 size: 12,
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .primaryColor,
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         customtext(
//                                                           fontWeight:
//                                                               FontWeight.w400,
//                                                           text: "Zoom",
//                                                           fontsize: 10,
//                                                           color:
//                                                               Theme.of(context)
//                                                                   .primaryColor,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     );
//                                   }),
//                             ],
//                           ),
//                         );
//                       }),
