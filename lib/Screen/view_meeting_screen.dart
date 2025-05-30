import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/popup_menuBar.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/events.dart';
import 'package:smart_leader/Screen/add_events_screen.dart';
import 'package:smart_leader/Widget/edit_event_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Modal/new_event.dart';
import '../Widget/custom_top_container.dart';

class ViewMeeting extends StatefulWidget {
  const ViewMeeting({Key? key}) : super(key: key);

  @override
  State<ViewMeeting> createState() => _ViewMeetingState();
}

class _ViewMeetingState extends State<ViewMeeting> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  DateTime selectedMonth = DateTime.now();

  Map<String, List> mySelectedEvents = {};

  bool isLoading = false;
  bool isMeetingEmpty = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
    getNewEvent();
  }

  void getNewEvent() async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> body = {'user_id': SessionManager.getUserID()};
    NewEvent events = await ApiHelper.getNewEvent(body);

    events.result!.sort((a, b) {
      int dateComparison = a.date!.compareTo(b.date!);
      if (dateComparison == 0) {
        return a.time!.compareTo(b.time!);
      }
      return dateComparison;
    });
    setState(() {
      isLoading = false;
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
    List events = [];

    mySelectedEvents.forEach((dateString, eventList) {
      try {
        if (dateString.trim().isEmpty) return;

        DateTime eventDate = DateFormat('dd-MM-yyyy').parse(dateString.trim());

        if (eventDate.year == dateTime.year &&
            eventDate.month == dateTime.month) {
          events.addAll(eventList);
        }
      } catch (e) {
        debugPrint("Invalid date format: '$dateString' | Error: $e");
      }
    });

    events.sort((a, b) {
      int dateComparison = a['date'].compareTo(b['date']);
      if (dateComparison == 0) {
        return a['time'].compareTo(b['time']);
      }
      return dateComparison;
    });

    isMeetingEmpty = events.isEmpty;
    return events;
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
                image: AssetImage("assest/images/OnBordScreenTopScreen.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: kWhiteColor),
                  ),
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
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedMonth = DateTime(
                              selectedMonth.year,
                              selectedMonth.month - 1,
                            );
                          });
                        },
                        child: Expanded(
                          child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: KBoxNewColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 25,
                              )),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Center(
                          child: customtext(
                            fontWeight: FontWeight.w700,
                            text: DateFormat.yMMMM().format(selectedMonth),
                            fontsize: 22,
                            color: SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kbuttonColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedMonth = DateTime(
                              selectedMonth.year,
                              selectedMonth.month + 1,
                            );
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: KBoxNewColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Icon(Icons.chevron_right, color: Colors.white)),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...() {
                          Map<String, List<dynamic>> groupedMonthlyEvents = {};
                          for (var event in _listOfDayEvents(selectedMonth)) {
                            String date = event['date'];
                            if (!groupedMonthlyEvents.containsKey(date)) {
                              groupedMonthlyEvents[date] = [];
                            }
                            groupedMonthlyEvents[date]!.add(event);
                          }
                          return groupedMonthlyEvents.entries.map((entry) {
                            String date = entry.key;
                            List eventsForDate = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customtext(
                                    fontWeight: FontWeight.w900,
                                    text: date,
                                    fontsize: 18,
                                    color: SessionManager.getTheme() == true ? kWhiteColor : kbuttonColor,
                                  ),
                                  ...eventsForDate.map((myEvents) {
                                    return Row(
                                      children: [
                                        customtext(
                                          fontWeight: FontWeight.w500,
                                          text: myEvents['time'],
                                          fontsize: 16,
                                          color: SessionManager.getTheme() == true ? kWhiteColor : kbuttonColor,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(vertical: 3),
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.circular(8),
                                              color: getMeetingColor(myEvents['meeting_type']),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: customtext(
                                                              fontWeight: FontWeight.w600,
                                                              text: '${myEvents['meeting_type']} with ${myEvents['title']}',
                                                              fontsize: 15,
                                                              color: Theme.of(context).primaryColor,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Visibility(
                                                            visible: myEvents['added_type'] != 'CONNECTION',
                                                            child: SizedBox(
                                                              width: 25,
                                                              height: 25,
                                                              child: SimplePopUp(
                                                                onChanged: (value) {
                                                                  if (value == 1) {
                                                                    _showEditEventDialog(myEvents);
                                                                  } else if (value == 3) {
                                                                    deleteEvent(myEvents['id']);
                                                                  }
                                                                },
                                                                color: Theme.of(context).primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10),
                                                      customtext(
                                                        fontWeight: FontWeight.w500,
                                                        text: myEvents['description'],
                                                        fontsize: 12,
                                                        color: SessionManager.getTheme() == true ? kWhiteColor : kbuttonColor,
                                                      ),
                                                      const SizedBox(height: 3),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )

                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          }).toList();
                        }(),
                        Visibility(
                          visible: isMeetingEmpty,
                          child: Container(
                            margin: const EdgeInsets.only(top: 100),
                            child: customtext(
                              fontWeight: FontWeight.w600,
                              text: 'No Events',
                              fontsize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getEventType(Map<String, dynamic> map) {
    if (map['type'] == 'Meeting') return map['meeting_place'];
    if (map['type'] == 'Birthday') return map['birthday_parson'];
    if (map['type'] == 'General') return map['place'];
    return '';
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
      },
    ).then((value) {
      if (value == true) {
        getNewEvent();
      }
    });
  }
  Color getMeetingColor(String type) {
    switch (type) {
      case 'Counselling':
        return kblueColor;
      case 'Open Seminar':
        return Colors.blue.shade200;
      case 'One to One':
        return Colors.green.shade200;
      case 'Training Program':
        return Colors.yellow.shade300;
      case 'Other':
        return Colors.pink.shade200;
      default:
        return SessionManager.getTheme() == true
            ? kscafolledColor
            : const Color(0xffEFE4B0);
    }
  }

  void deleteEvent(String id) {
    Map<String, String> body = {'id': id};
    Helper.showLoaderDialog(context, message: 'Deleting');

    ApiHelper.deleteNewEvent(body).then((value) {
      Navigator.pop(context);
      if (value.status!.toLowerCase() == 'true') {
        Helper.showSnackVar("Deleted Successfully", Colors.green, context);
        getNewEvent();
      } else {
        Helper.showSnackVar(value.massage!, Colors.red, context);
      }
    });
  }
}

class topContainer extends StatelessWidget {
  const topContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assest/images/OnBordScreenTopScreen.png"),
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
            InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.delete,
                  size: 20,
                  color: kWhiteColor,
                )
                // Container(
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(color: kWhiteColor)
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(3.0),
                //       child: Center(
                //           child: Icon(
                //             Icons.filter_list,
                //             size: 20,
                //             color: kWhiteColor,
                //           )),
                //     ))
                ),
          ],
        ),
      ),
    );
  }
}

/*
Scaffold(
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assest/images/OnBordScreenTopScreen.png"),
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
                        Visibility(
                          visible: idList.isNotEmpty,
                          child: IconButton(
                            onPressed: () {
                              multipledelete();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: kWhiteColor,
                              size: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchMeetingWidget()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            color: SessionManager.getTheme() == true
                                ? kscafolledColor
                                : kWhiteColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          onChanged: (value) {},
                          enabled: false,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: "SplineSans",
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: SessionManager.getTheme() == true
                                ? kscafolledColor
                                : kWhiteColor,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Search",
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: "SplineSans",
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: SessionManager.getTheme() == true
                                        ? kscafolledColor
                                        : Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: SessionManager.getTheme() == true
                                        ? kscafolledColor
                                        : Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: SessionManager.getTheme() == true
                                        ? kscafolledColor
                                        : Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                isSubmit == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: showMeetingList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext, value) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customtext(
                                      fontWeight: FontWeight.w400,
                                      text: showMeetingList[value].date!,
                                      fontsize: 20,
                                      color: SessionManager.getTheme() == true
                                          ? kWhiteColor
                                          : kbuttonColor,
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            home.data![value].data!.length,
                                        itemBuilder: (BuildContext, index) {
                                          return InkWell(
                                            onLongPress: () {
                                              bool isSelected = !home
                                                  .data![value]
                                                  .data![index]
                                                  .isSelected!;
                                              DataMeeting show = DataMeeting(
                                                isSelected: isSelected,
                                                time: home.data![value]
                                                    .data![index].time,
                                                id: home.data![value]
                                                    .data![index].id,
                                                date: home.data![value]
                                                    .data![index].date,
                                                strtotime: home.data![value]
                                                    .data![index].strtotime,
                                                userId: home.data![value]
                                                    .data![index].userId,
                                                title: home.data![value]
                                                    .data![index].title,
                                                leaderName: home.data![value]
                                                    .data![index].leaderName,
                                                reminder: home.data![value]
                                                    .data![index].reminder,
                                                selectType: home.data![value]
                                                    .data![index].selectType,
                                              );
                                              int idx = home.data![value].data!
                                                  .indexWhere((element) =>
                                                      element.id == show.id);
                                              home.data![value].data![idx]
                                                      .isSelected =
                                                  !home.data![value].data![idx]
                                                      .isSelected!;
                                              setState(() {
                                                if (idList.contains(home
                                                    .data![value]
                                                    .data![index]
                                                    .id)) {
                                                  idList.remove(home
                                                      .data![value]
                                                      .data![index]
                                                      .id);
                                                } else {
                                                  idList.add(home.data![value]
                                                      .data![index].id!);
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 4),
                                              child: Row(
                                                children: [
                                                  home.data![value].data![index]
                                                              .isSelected ==
                                                          true
                                                      ? Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: SessionManager
                                                                              .getTheme() ==
                                                                          true
                                                                      ? kWhiteColor
                                                                      : kBlackColor,
                                                                  width: 2),
                                                              color: kredColor,
                                                              shape: BoxShape
                                                                  .circle),
                                                          child: const Center(
                                                              child: Icon(
                                                            Icons.done,
                                                            size: 15,
                                                            color: kWhiteColor,
                                                          )))
                                                      : customtext(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          text: home
                                                              .data![value]
                                                              .data![index]
                                                              .time!,
                                                          fontsize: 16,
                                                          color: SessionManager
                                                                      .getTheme() ==
                                                                  true
                                                              ? kWhiteColor
                                                              : kbuttonColor,
                                                        ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8,
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15),
                                                          ),
                                                          color: SessionManager
                                                                      .getTheme() ==
                                                                  true
                                                              ? kscafolledColor
                                                              : const Color(
                                                                  0xffBBB5F1)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              customtext(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  text: home
                                                                      .data![
                                                                          value]
                                                                      .data![
                                                                          index]
                                                                      .title!,
                                                                  fontsize: 16,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                              const SizedBox(
                                                                height: 3,
                                                              ),
                                                              customtext(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                text: home
                                                                    .data![
                                                                        value]
                                                                    .data![
                                                                        index]
                                                                    .leaderName!,
                                                                fontsize: 13,
                                                                color: SessionManager
                                                                            .getTheme() ==
                                                                        true
                                                                    ? kWhiteColor
                                                                    : kbuttonColor,
                                                              ),
                                                              const SizedBox(
                                                                height: 3,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .watch_later_outlined,
                                                                    size: 15,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  customtext(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    text: home
                                                                        .data![
                                                                            value]
                                                                        .data![
                                                                            index]
                                                                        .reminder!,
                                                                    fontsize:
                                                                        13,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )),
                                                          customtext(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            text: home
                                                                .data![value]
                                                                .data![index]
                                                                .selectType!,
                                                            fontsize: 16,
                                                            color: SessionManager
                                                                        .getTheme() ==
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
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              );
                            }),
                      )
              ],
            ),
    );
 */
