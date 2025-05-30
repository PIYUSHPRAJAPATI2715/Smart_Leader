import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_leader/Componants/Custom_tools_Button.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/neumorphism_widget.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Screen/add_events_screen.dart';
import 'package:smart_leader/Screen/add_folder_screen.dart';
import 'package:smart_leader/Screen/add_mytask_screen.dart';
import 'package:smart_leader/Screen/creat_connection_folder.dart';
import 'package:smart_leader/Screen/expense/expense_home_screen.dart';
import 'package:smart_leader/Screen/show_barchart_screen.dart';
import 'package:smart_leader/Screen/view_meeting_screen.dart';
import 'package:smart_leader/Widget/add_meeting_widget.dart';
import 'package:smart_leader/Widget/drawer.dart';
import 'package:smart_leader/Widget/top_header_container.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../Componants/Custom_text.dart';
import '../Modal/new_event.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  final drawerKey = GlobalKey<ScaffoldState>();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = _focusedDay;
    //getEvents();
    getNewEvent();
  }

  /* void getEvents() async {
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
    Map<String, List<Map<String, dynamic>>> groupedEvents =
        groupBy(events.toJson()['result'], (event) => event["date"]);

    mySelectedEvents = groupedEvents;

    // Print the result
  }

  Map<K, List<V>> groupBy<K, V>(List<V> list, K Function(V) getKey) {
    Map<K, List<V>> result = {};

    for (var item in list) {
      var key = getKey(item);
      result.putIfAbsent(key, () => []).add(item);
    }

    return result;
  }

  loadPreviousEvents() {
    mySelectedEvents = {
      "2023-01-31": [
        {"eventDescp": "11", "eventTitle": "asdasd"},
        {"eventDescp": "22", "eventTitle": "22"}
      ],
      "2023-02-10": [
        {"eventDescp": "22", "eventTitle": "22"}
      ],
      "2023-02-08": [
        {"eventTitle": "ss", "eventDescp": "ss"}
      ]
    };
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('dd-MM-yyyy').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('dd-MM-yyyy').format(dateTime)]!;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      key: drawerKey,
      drawer: const HomeDrawer(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              TopHeaderContainer(drawerKey: drawerKey),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Expanded(
                                child: Container(
                                  height: 400, // Set your desired height
                                  width: 270,
                                  child: SingleChildScrollView(
                                    scrollDirection:Axis.vertical,// Wrap in scroll view

                                    child: Column(
                                      children: [
                                        TableCalendar(
                                          calendarStyle: CalendarStyle(
                                            markerDecoration: const BoxDecoration(
                                              color: KBoxNewColor,
                                              shape: BoxShape.circle,
                                            ),
                                            selectedDecoration: BoxDecoration(
                                              color: Color(0xffEFE4B0),
                                              border: Border.all(
                                                color: KBoxNewColor,
                                                width: 2.0,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            todayDecoration: BoxDecoration(
                                              color: Color(0xffEFE4B0),
                                              shape: BoxShape.circle,
                                            ),
                                            selectedTextStyle: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          headerStyle: HeaderStyle(
                                            leftChevronIcon: Icon(Icons.arrow_back_ios_new, size: 20),
                                            rightChevronIcon: Icon(Icons.arrow_forward_ios_outlined, size: 20),
                                            titleCentered: true,
                                            formatButtonVisible: false,
                                          ),
                                          firstDay: DateTime(2000, 1, 1),
                                          lastDay: DateTime(2060),
                                          focusedDay: _focusedDay,
                                          calendarFormat: CalendarFormat.month,
                                          onDaySelected: (selectedDay, focusedDay) {
                                            setState(() {
                                              _selectedDate = selectedDay;
                                              _focusedDay = focusedDay;
                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => const AddEventScreen()));
                                          },
                                          selectedDayPredicate: (day) {
                                            return isSameDay(_selectedDate, day);
                                          },
                                          onPageChanged: (focusedDay) {
                                            setState(() {
                                              _focusedDay = focusedDay;
                                            });
                                          },
                                          eventLoader: _listOfDayEvents,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildToolTile(
                        context,
                        imagePath: 'assest/png_icon/event_new.png',
                        label: 'Add Event',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddMeetingWidget()),
                        ),
                      ),
                      _buildToolTile(
                        context,
                        imagePath: 'assest/png_icon/new_note.png',
                        label: 'Notes',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddFolderScreen()),
                        ),
                      ),
                      _buildToolTile(
                        context,
                        imagePath: 'assest/png_icon/new_schedule.png',
                        label: 'Scheduler',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddMyTaskScreen()),
                        ),
                      ),
                    ],
                  ),

                  // Second Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildToolTile(
                        context,
                        imagePath: 'assest/png_icon/new_list.png',
                        label: 'Prospect\nList',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CreatConnectionFolder()),
                        ),
                      ),
                      _buildToolTile(
                        context,
                        imagePath: 'assest/png_icon/new_bussiness.png',
                        label: 'Business\nAnalysis',
                        labelColor: Theme.of(context).primaryColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ShowBarChartScreen()),
                        ),
                      ),
                      _buildToolTile(
                        context,
                        imagePath: 'assest/png_icon/new_expanse.png',
                        label: 'Expenses\nTracking',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ExpenseHomeScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) =>
              //               const ViewMeeting()));
              //     },
              //     child: Column(
              //       children: [
              //         Container(
              //           height: 75,
              //           width: 80,
              //           child: Center(
              //             child:Image.asset(
              //               height:double.infinity,
              //               width: double.infinity,
              //               'assest/png_icon/event_new.png',
              //             ),
              //           ),
              //         ),
              //         SizedBox(height: 7),
              //         customtext(
              //           fontWeight: FontWeight.w800,
              //           text: "View Events",
              //           alignment: TextAlign.center,
              //           fontsize: 15,
              //           color: Colors.black,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => _showAddEventDialog(),
      //   label: const Text('Add Event'),
      // ),
    );
  }
}
Widget _buildToolTile(
    BuildContext context, {
      required String imagePath,
      required String label,
      required VoidCallback onTap,
      Color labelColor = Colors.black,
    }) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 62,
              width: 75,
              child: Center(
                child: Image.asset(
                  imagePath,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 5),
            customtext(
              fontWeight: FontWeight.w800,
              text: label,
              alignment: TextAlign.center,
              fontsize: 15,
              color: labelColor,
            ),
          ],
        ),
      ),
    ),
  );
}

//todo: old calendar code
// TableCalendar(
//             onHeaderTapped: (dateTime) {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AddEventScreen()));
//             },
//             headerStyle: HeaderStyle(
//                 leftChevronIcon: Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                       gradient: SessionManager.getTheme() == true
//                           ? k2Gradient
//                           : kGradient,
//                       shape: BoxShape.circle),
//                   child: Center(
//                       child: Icon(
//                     Icons.arrow_back_ios_new,
//                     size: 20,
//                     color: SessionManager.getTheme() == true
//                         ? kBlackColor
//                         : kWhiteColor,
//                   )),
//                 ),
//                 rightChevronIcon: Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                       gradient: SessionManager.getTheme() == true
//                           ? k2Gradient
//                           : kGradient,
//                       shape: BoxShape.circle),
//                   child: Center(
//                       child: Icon(
//                     Icons.arrow_forward_ios_outlined,
//                     size: 20,
//                     color: SessionManager.getTheme() == true
//                         ? kBlackColor
//                         : kWhiteColor,
//                   )),
//                 ),
//                 titleCentered: true,
//                 formatButtonVisible: false),
//             firstDay: DateTime.now(),
//             lastDay: DateTime(2060),
//             focusedDay: _focusedDay,
//             calendarFormat: CalendarFormat.week,
//             onDaySelected: (selectedDay, focusedDay) {
//               if (!isSameDay(_selectedDate, selectedDay)) {
//                 setState(() {
//                   _selectedDate = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               }
//             },
//             selectedDayPredicate: (day) {
//               return isSameDay(_selectedDate, day);
//             },
//             onFormatChanged: (format) {
//               if (_calendarFormat != format) {
//                 // Call `setState()` when updating calendar format
//                 setState(() {
//                   _calendarFormat = format;
//                 });
//               }
//             },
//             onPageChanged: (focusedDay) {
//               // No need to call `setState()` here
//               _focusedDay = focusedDay;
//             },
//             eventLoader: _listOfDayEvents,
//           ),
//           ..._listOfDayEvents(_selectedDate!).map(
//             (myEvents) => ListTile(
//               leading: const Icon(
//                 Icons.done,
//                 color: Colors.teal,
//               ),
//               title: Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: Text('Event Title:   ${myEvents['eventTitle']}'),
//               ),
//               subtitle: Text('Description:   ${myEvents['eventDescp']}'),
//             ),
//           ),
