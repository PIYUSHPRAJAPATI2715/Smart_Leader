import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Button2.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_description_textfield.dart';
import 'package:smart_leader/Componants/custom_dropdown.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:intl/intl.dart';
import 'package:smart_leader/Widget/addEvent.dart';
import 'package:smart_leader/services/notification_service.dart';

import 'custom_top_container.dart';

class AddMeetingWidget extends StatefulWidget {
  const AddMeetingWidget({Key? key}) : super(key: key);

  @override
  State<AddMeetingWidget> createState() => _AddMeetingWidgetState();
}

class _AddMeetingWidgetState extends State<AddMeetingWidget> {
  /* final TextEditingController titleController = TextEditingController();
  final TextEditingController leaderController = TextEditingController();

  String selecteddate = 'Select Date';
  String selectedtime = "Select Time";
  String meetingType = "Select Meeting Type";
  String dropdownValue4 = "Set Reminder";
  bool isSubmit = false;

  String notificationTime = '';

  void addMeeting() async {
    if (titleController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Title Name', Colors.red, context);
      return;
    }
    if (leaderController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Leader Name', Colors.red, context);
      return;
    }
    if (meetingType == "Select Meeting Type") {
      Helper.showSnackVar('Please Select Type', Colors.red, context);
      return;
    }
    if (selecteddate == 'Select Date') {
      Helper.showSnackVar('Please Select Date', Colors.red, context);
      return;
    }
    if (selectedtime == "Select Time") {
      Helper.showSnackVar('Please Select Time', Colors.red, context);
      return;
    }
    if (dropdownValue4 == "Set Reminder") {
      Helper.showSnackVar('Please Select Reminder', Colors.red, context);
      return;
    }

    Map<String, String> body = {
      "time": selectedtime,
      "user_id": SessionManager.getUserID(),
      "leader_name": leaderController.text,
      "select_type": meetingType,
      "date": selecteddate,
      "title": titleController.text,
      "reminder": dropdownValue4,
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.addMeeting(body).then((login) {
      setState(() {
        isSubmit = false;
      });

      if (login.message == 'Meeting Add Successfully ') {
        String dateTime =
            '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';

        NotificationService().showNotification(
            int.parse(login.id!),
            'Meeting: ${titleController.text}',
            'Meeting With ${leaderController.text}',
            dropdownValue4,
            dateTime);

        Navigator.pop(context, true);

        Helper.showSnackVar('Successfully Added', Colors.green, context);
      } else {
        Helper.showSnackVar('Error', Colors.red, context);
      }
    });
  }
  */

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController meetingPlaceController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController generalPlaceController = TextEditingController();

  String selecteddate = 'Select Date';
  String selectedtime = "Select Time";
  String type = 'Open Seminar';

  //String meetingType = "Online Meeting";
  // String meetingPlace = "Zoom";
  String remindMe = "5 min";

  //Open Seminar, Counselling, One to One, Training Program, Other
  String notificationTime = '';

  bool isSubmit = false;

  //Change Add New Meeting to Add Event. Meeting Type (Open Seminar, Counselling,
  // One to One, Training Program, Other), Meeting With, Meeting Date, Meeting Time,
  // Remind Me In, Description. Meeting with Connections should be tagged as One to One

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopContainer(
              title: "SmartLeader",
              onTap: () {
                Navigator.pop(context);
              }),
          Expanded(
            child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customtext(
                        fontWeight: FontWeight.w500,
                        text: "Add Event",
                        color: Theme.of(context).primaryColor,
                        fontsize: 20),
                    const SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropDown(
                            lableName: "Meeting Type",
                            hint: "",
                            onChange: (String? value) {
                              setState(() {
                                type = value!;
                                // meetingType = "Online Meeting";
                                // meetingPlace = "Zoom";
                                birthPlaceController.clear();
                                generalPlaceController.clear();
                              });
                            },
                            items: const [
                              'Open Seminar',
                              'Counselling',
                              'One to One',
                              'Training Program',
                              'Other',
                            ],
                            valueType: type),

                        //getType()
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    CustomTextField(
                      hight: 50,
                      title: "Enter Name",
                      controller: titleController,
                      hint: "fff",
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      lableName: "Meeting With",
                      hintfont: 12,
                      lablefont: 14,
                      gapHight: 10,
                    ),
                    const SizedBox(height: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Date",
                            fontsize: 14,
                            color: SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kbuttonColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: KBoxNewColor,
                                      // Header background color
                                      onPrimary: Colors.white,
                                      // Header text color
                                      onSurface:
                                          Colors.black, // Body text color
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            KBoxNewColor, // Button text color
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            ).then((value) {
                              selecteddate =
                                  DateFormat('dd-MM-yyyy').format(value!);
                              setState(() {});
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: kblueDarkColor, width: 1.2),
                                color: SessionManager.getTheme() == true
                                    ? kblueDarkColor
                                    : kWhiteColor),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: customtext(
                                      fontWeight: FontWeight.w700,
                                      text: (selecteddate),
                                      fontsize: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Time",
                            fontsize: 14,
                            color: SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kbuttonColor,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: kblueColor,
                                      // 🔴 Header background color
                                      onPrimary: Colors.white,
                                      // 🏷 Header text color
                                      onSurface:
                                          Colors.black, // ⌛ Body text color
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            kblueColor, // 🔴 Button text color
                                      ),
                                    ),
                                    timePickerTheme: TimePickerThemeData(
                                      backgroundColor: Colors.white,
                                      // ⏳ Background color
                                      hourMinuteColor: kblueColor,
                                      // ⏲️ Hour & Minute box background
                                      hourMinuteTextColor: Colors.white,
                                      // ⏲️ Hour & Minute text
                                      dayPeriodColor: kblueColor,
                                      // 🌙 AM/PM background color
                                      dayPeriodTextColor: Colors.black,
                                      // 🌙 AM/PM text color
                                      dialHandColor: kblueColor,
                                      // 🔴 Dial hand color
                                      dialBackgroundColor: Colors
                                          .grey[200], // 🎛 Dial background
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedTime != null) {
                              DateTime date = DateTime.now();
                              String second =
                                  date.second.toString().padLeft(2, '0');
                              List timeSplit =
                                  pickedTime.format(context).split(' ');
                              String formattedTime = timeSplit[0];
                              String time = '$formattedTime:$second';
                              String type = '';
                              if (timeSplit.length > 1) {
                                type = timeSplit[1];
                                time = '$time $type';
                              }

                              notificationTime =
                                  Helper.formatTime(pickedTime.format(context));

                              setState(() {
                                selectedtime = pickedTime.format(context);
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: kblueColor, width: 1.2),
                                color: SessionManager.getTheme() == true
                                    ? kblueDarkColor
                                    : kWhiteColor),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: customtext(
                                      fontWeight: FontWeight.w700,
                                      text: (selectedtime),
                                      fontsize: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomDropDown(
                        lableName: "Remind Me",
                        hint: "",
                        onChange: (String? value) {
                          setState(() {
                            remindMe = value!;
                          });
                        },
                        items: const [
                          '0 min',
                          '5 min',
                          '15 min',
                          "30 min",
                          "60 min"
                        ],
                        valueType: remindMe),
                    const SizedBox(height: 10),
                    CustomDescriptionTextfield(
                        focusNode: FocusNode(),
                        onchanged: (value) {},
                        boxHight: 100,
                        title: "",
                        controller: descriptionController,
                        hint: "Describe the event (Optional)",
                        inputAction: TextInputAction.newline,
                        inputType: TextInputType.multiline,
                        lableName: "Description",
                        hintfont: 12,
                        lablefont: 14),
                    const SizedBox(height: 30),
                    isSubmit
                        ? const Center(child: CircularProgressIndicator())
                        : custom_Button(
                            onTap: addNewEvent,
                            title: "Save",
                            hight: 45,
                            width: 140,
                            fontSize: 18)
                  ],
                )),
          )
        ],
      ),
    );
  }

  void addEvent() {
    String title = titleController.text;
    String description = descriptionController.text;

    if (title.isEmpty) {
      Helper.toastMassage('Enter Name', Colors.red);
      return;
    }

    if (selecteddate == 'Select Date') {
      Helper.toastMassage('Select Date', Colors.red);
      return;
    }

    if (selectedtime == 'Select Time') {
      Helper.toastMassage('Select Time', Colors.red);
      return;
    }

    /*
    if (type == 'Birthday') {
      meetingType = '';
      meetingPlace = '';
      meetingPlaceController.clear();
      generalPlaceController.clear();

      if (birthPlaceController.text.isEmpty) {
        Helper.toastMassage('Enter birthday person name', Colors.red);
        return;
      }
    }

    if (type == 'General') {
      meetingType = '';
      meetingPlace = '';
      meetingPlaceController.clear();
      birthPlaceController.clear();

      if (generalPlaceController.text.isEmpty) {
        Helper.toastMassage('Enter general place', Colors.red);
        return;
      }
    }
    */

    if (description.isEmpty) {
      description = " ";
    }

    Map<String, String> body = {
      'user_id': SessionManager.getUserID(),
      'title': title,
      'description': description,
      'date': selecteddate,
      'type': type,
      'time': selectedtime,
      'meeting_type': ' ',
      'meeting_place': ' ',
      'birthday_parson': birthPlaceController.text,
      'place': generalPlaceController.text,
      'remind_me': remindMe,
      "connection_type": 'EVENT',
      "connection_id": ''
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.addEvents(body).then((value) {
      setState(() {
        isSubmit = true;
      });

      String dateTime =
          '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';

      NotificationService().showNotification(
        1,
        'SmartLeader - Meeting',
        titleController.text,
        remindMe,
        dateTime,
        Helper.kMeetingScreen,
      );

      Navigator.pop(context, true);
      Helper.showSnackVar('Event Added', kblueColor, context);
    });
    print('Body $body');
    //user_id:1
    // title:dgdfgfgfgfdg
    // description:bfdfggdfgddxvvsdfsgdgd
    // date:01-12-2022
    // type:bvvdvdvdxcv
    // time:4:31
    // meeting_type:ghfgf
    // meeting_place:bhopal
    // //birthday_parson:gffgfg
    // place:fgbff
    // remind_me:12 min
  }

  void addNewEvent() {
    String title = titleController.text;
    String description = descriptionController.text;

    if (title.isEmpty) {
      Helper.toastMassage('Enter Name', Colors.red);
      return;
    }

    if (selecteddate == 'Select Date') {
      Helper.toastMassage('Select Date', Colors.red);
      return;
    }

    if (selectedtime == 'Select Time') {
      Helper.toastMassage('Select Time', Colors.red);
      return;
    }

    String dateTime = '$selecteddate $selectedtime';
    bool isTimeGone = Helper.checkPassedDateTime(dateTime);

    print('IS TIME GONE $isTimeGone');

    // if (isTimeGone) {
    //   Helper.toastMassage('Select future date time', Colors.red);
    //   return;
    // }

    if (description.isEmpty) {
      description = " ";
    }

    Map<String, String> body = {
      'user_id': SessionManager.getUserID(),
      'name': '',
      'mobile': '',
      'occupation': '',
      'time': selectedtime,
      'date': selecteddate,
      'remind': remindMe,
      'meeting_required': '',
      'meeting_count': '',
      'meeting_happen': '',
      'notes': '',
      'connection_id': '',
      'title': title,
      'description': description,
      'meeting_type': type,
      'meeting_place': '',
      'birthday_parson': birthPlaceController.text,
      'place': generalPlaceController.text.trim(),
      'added_type': 'EVENT'
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.addNewEvents(body).then((value) {
      setState(() {
        isSubmit = true;
      });

      String dateTime =
          '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';

      NotificationService().showNotification(
        1,
        'SmartLeader - Meeting',
        titleController.text,
        remindMe,
        dateTime,
        Helper.kMeetingScreen,
      );

      Navigator.pop(context, true);
      Helper.showSnackVar('Event Added', kblueColor, context);
    });
  }

/*
  Widget getType() {
    if (type == 'Meeting') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropDown(
              lableName: "Meeting Type",
              hint: "",
              onChange: (String? value) {
                setState(() {
                  meetingType = value!;
                });
              },
              items: const [
                'Online Meeting',
                'Offline Meeting',
              ],
              valueType: meetingType),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: customtext(
              fontWeight: FontWeight.w500,
              text: "Meeting Place",
              fontsize: 14,
              color: SessionManager.getTheme() == true
                  ? kWhiteColor
                  : kbuttonColor,
            ),
          ),
          getMeetingType(),
        ],
      );
    }

    if (type == 'Birthday') {
      return BirthdayPerson(
        birthdayController: birthPlaceController,
      );
    }

    if (type == 'General') {
      return GeneralPlace(placeController: generalPlaceController);
    }

    return const MeetingPlace();
  }

  Widget getMeetingType() {
    if (meetingType == 'Online Meeting') {
      return OnlineMeeting(
        value: meetingPlace,
        onOnlineMeetingSelected: (value) {
          setState(() {
            meetingPlace = value!;
          });
        },
      );
    }

    if (meetingType == 'Offline Meeting') {
      return oflineMeeting(
        meetingPlaceController: meetingPlaceController,
      );
    }
    return OnlineMeeting(
      value: meetingPlace,
      onOnlineMeetingSelected: (value) {
        setState(() {
          meetingPlace = value!;
        });
      },
    );
  }


  */
}

// class AddMeetingWidget extends StatefulWidget {
//   const AddMeetingWidget({Key? key}) : super(key: key);
//
//   @override
//   State<AddMeetingWidget> createState() => _AddMeetingWidgetState();
// }
//
// class _AddMeetingWidgetState extends State<AddMeetingWidget> {
//   /* final TextEditingController titleController = TextEditingController();
//   final TextEditingController leaderController = TextEditingController();
//
//   String selecteddate = 'Select Date';
//   String selectedtime = "Select Time";
//   String meetingType = "Select Meeting Type";
//   String dropdownValue4 = "Set Reminder";
//   bool isSubmit = false;
//
//   String notificationTime = '';
//
//   void addMeeting() async {
//     if (titleController.text.isEmpty) {
//       Helper.showSnackVar('Please Enter Title Name', Colors.red, context);
//       return;
//     }
//     if (leaderController.text.isEmpty) {
//       Helper.showSnackVar('Please Enter Leader Name', Colors.red, context);
//       return;
//     }
//     if (meetingType == "Select Meeting Type") {
//       Helper.showSnackVar('Please Select Type', Colors.red, context);
//       return;
//     }
//     if (selecteddate == 'Select Date') {
//       Helper.showSnackVar('Please Select Date', Colors.red, context);
//       return;
//     }
//     if (selectedtime == "Select Time") {
//       Helper.showSnackVar('Please Select Time', Colors.red, context);
//       return;
//     }
//     if (dropdownValue4 == "Set Reminder") {
//       Helper.showSnackVar('Please Select Reminder', Colors.red, context);
//       return;
//     }
//
//     Map<String, String> body = {
//       "time": selectedtime,
//       "user_id": SessionManager.getUserID(),
//       "leader_name": leaderController.text,
//       "select_type": meetingType,
//       "date": selecteddate,
//       "title": titleController.text,
//       "reminder": dropdownValue4,
//     };
//
//     setState(() {
//       isSubmit = true;
//     });
//
//     ApiHelper.addMeeting(body).then((login) {
//       setState(() {
//         isSubmit = false;
//       });
//
//       if (login.message == 'Meeting Add Successfully ') {
//         String dateTime =
//             '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';
//
//         NotificationService().showNotification(
//             int.parse(login.id!),
//             'Meeting: ${titleController.text}',
//             'Meeting With ${leaderController.text}',
//             dropdownValue4,
//             dateTime);
//
//         Navigator.pop(context, true);
//
//         Helper.showSnackVar('Successfully Added', Colors.green, context);
//       } else {
//         Helper.showSnackVar('Error', Colors.red, context);
//       }
//     });
//   }
//   */
//
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController _placeController = TextEditingController();
//   final TextEditingController meetingPlaceController = TextEditingController();
//   final TextEditingController birthPlaceController = TextEditingController();
//   final TextEditingController generalPlaceController = TextEditingController();
//
//   String selecteddate = 'Select Date';
//   String selectedtime = "Select Time";
//   String type = 'Open Seminar';
//
//   //String meetingType = "Online Meeting";
//   // String meetingPlace = "Zoom";
//   String remindMe = "5 min";
//
//   //Open Seminar, Counselling, One to One, Training Program, Other
//   String notificationTime = '';
//
//   bool isSubmit = false;
//
//   //Change Add New Meeting to Add Event. Meeting Type (Open Seminar, Counselling,
//   // One to One, Training Program, Other), Meeting With, Meeting Date, Meeting Time,
//   // Remind Me In, Description. Meeting with Connections should be tagged as One to One
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           TopContainer(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               title: "Smart Leader"),
//           Expanded(
//             child: SingleChildScrollView(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     customtext(
//                         fontWeight: FontWeight.w500,
//                         text: "Add Event",
//                         color: Theme.of(context).primaryColor,
//                         fontsize: 20),
//                     const SizedBox(height: 25),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomDropDown(
//                             lableName: "Meeting Type",
//                             color: Colors.black,
//                             hint: "",
//                             onChange: (String? value) {
//                               setState(() {
//                                 type = value!;
//                                 // meetingType = "Online Meeting";
//                                 // meetingPlace = "Zoom";
//                                 birthPlaceController.clear();
//                                 generalPlaceController.clear();
//                               });
//                             },
//                             items: const [
//                               'Open Seminar',
//                               'Counselling',
//                               'One to One',
//                               'Training Program',
//                               'Other',
//                             ],
//                             valueType: type),
//
//                         //getType()
//                       ],
//                     ),
//                     const SizedBox(height: 15.0),
//                     CustomTextField(
//                       hight: 50,
//                       title: "Enter Name",
//                       controller: titleController,
//                       hint: "fff",
//                       inputAction: TextInputAction.next,
//                       inputType: TextInputType.text,
//                       lableName: "Meeting With",
//                       hintfont: 11,
//                       lablefont: 14,
//                       gapHight: 10,
//                     ),
//                     const SizedBox(height: 15.0),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 13),
//                           child: customtext(
//                             fontWeight: FontWeight.w500,
//                             text: "Date",
//                             fontsize: 14,
//                             color: SessionManager.getTheme() == true
//                                 ? kWhiteColor
//                                 : Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         InkWell(
//                           onTap: () {
//                             showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime.now(),
//                               lastDate: DateTime(2050),
//                               builder: (BuildContext context, Widget? child) {
//                                 return Theme(
//                                   data: ThemeData.light().copyWith(
//                                     colorScheme: ColorScheme.light(
//                                       primary: KBoxNewColor,
//                                       // Header background color
//                                       onPrimary: Colors.white,
//                                       // Header text color
//                                       onSurface:
//                                           Colors.black, // Body text color
//                                     ),
//                                     textButtonTheme: TextButtonThemeData(
//                                       style: TextButton.styleFrom(
//                                         foregroundColor:
//                                             KBoxNewColor, // Button text color
//                                       ),
//                                     ),
//                                   ),
//                                   child: child!,
//                                 );
//                               },
//                             ).then((value) {
//                               if (value != null) {
//                                 selecteddate =
//                                     DateFormat('yyyy-MM-dd').format(value);
//                                 setState(() {});
//                               }
//                             });
//                           },
//                           child: Container(
//                             height: 50,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 border:
//                                     Border.all(color: KBoxNewColor, width: 1.2),
//                                 color: SessionManager.getTheme() == true
//                                     ? kscafolledColor
//                                     : kWhiteColor),
//                             child: Center(
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 20),
//                                     child: customtext(
//                                       fontWeight: FontWeight.w700,
//                                       text: (selecteddate),
//                                       fontsize: 12,
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 13),
//                           child: customtext(
//                             fontWeight: FontWeight.w500,
//                             text: "Time",
//                             fontsize: 14,
//                             color: SessionManager.getTheme() == true
//                                 ? kWhiteColor
//                                 : Colors.black,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         InkWell(
//                           onTap: () async {
//                             TimeOfDay? pickedTime = await showTimePicker(
//                               initialTime: TimeOfDay.now(),
//                               context: context,
//                             );
//                             if (pickedTime != null) {
//                               DateTime date = DateTime.now();
//                               String second =
//                                   date.second.toString().padLeft(2, '0');
//                               List timeSplit =
//                                   pickedTime.format(context).split(' ');
//                               String formattedTime = timeSplit[0];
//                               String time = '$formattedTime:$second';
//                               String type = '';
//                               if (timeSplit.length > 1) {
//                                 type = timeSplit[1];
//                                 time = '$time $type';
//                               }
//
//                               notificationTime =
//                                   Helper.formatTime(pickedTime.format(context));
//
//                               setState(() {
//                                 selectedtime = pickedTime.format(context);
//                                 print("Time is not selected$selectedtime");
//
//                                 //set the value of text field.
//                               });
//                             } else {
//                               print("Time is not selected");
//                             }
//                           },
//                           child: Container(
//                             height: 50,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 border:
//                                     Border.all(color: KBoxNewColor, width: 1.2),
//                                 color: SessionManager.getTheme() == true
//                                     ? kscafolledColor
//                                     : kWhiteColor),
//                             child: Center(
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 20),
//                                     child: customtext(
//                                       fontWeight: FontWeight.w700,
//                                       text: (selectedtime),
//                                       fontsize: 12,
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     CustomDropDown(
//                         lableName: "Remind Me",
//                         color: Colors.black,
//                         hint: "",
//                         onChange: (String? value) {
//                           setState(() {
//                             remindMe = value!;
//                           });
//                         },
//                         items: const [
//                           '0 min',
//                           '5 min',
//                           '15 min',
//                           "30 min",
//                           "60 min"
//                         ],
//                         valueType: remindMe),
//                     const SizedBox(height: 10),
//                     CustomDescriptionTextfield(
//                         focusNode: FocusNode(),
//                         onchanged: (value) {},
//                         boxHight: 100,
//                         title: "",
//                         controller: descriptionController,
//                         hint: "Describe the event (Optional)",
//                         inputAction: TextInputAction.newline,
//                         inputType: TextInputType.multiline,
//                         lableName: "Description",
//                         hintfont: 12,
//                         lablefont: 14),
//                     const SizedBox(height: 30),
//                     isSubmit
//                         ? const Center(child: CircularProgressIndicator())
//                         : custom_Button(
//                             onTap: addNewEvent,
//                             title: "Save",
//                             hight: 45,
//                             width: 140,
//                             fontSize: 18)
//                   ],
//                 )),
//           )
//         ],
//       ),
//     );
//   }
//
//   void addNewEvent() {
//     String title = titleController.text;
//     String description = descriptionController.text;
//
//     if (title.isEmpty) {
//       Helper.toastMassage('Enter Name', Colors.red);
//       return;
//     }
//
//     if (selecteddate == 'Select Date') {
//       Helper.toastMassage('Select Date', Colors.red);
//       return;
//     }
//
//     if (selectedtime == 'Select Time') {
//       Helper.toastMassage('Select Time', Colors.red);
//       return;
//     }
//
//     String dateTime = '$selecteddate $selectedtime';
//     bool isTimeGone = Helper.checkPassedDateTime(dateTime);
//
//     print('IS TIME GONE $isTimeGone');
//
//     if (isTimeGone) {
//       Helper.toastMassage('Select future date time', Colors.red);
//       return;
//     }
//
//     if (description.isEmpty) {
//       description = " ";
//     }
//
//     Map<String, String> body = {
//       'user_id': SessionManager.getUserID(),
//       'name': '',
//       'mobile': '',
//       'occupation': '',
//       'time': selectedtime,
//       'date': selecteddate,
//       'remind': remindMe,
//       'meeting_required': '',
//       'meeting_count': '',
//       'meeting_happen': '',
//       'notes': '',
//       'connection_id': '',
//       'title': title,
//       'description': description,
//       'meeting_type': type,
//       'meeting_place': '',
//       'birthday_parson': birthPlaceController.text,
//       'place': generalPlaceController.text.trim(),
//       'added_type': 'EVENT'
//     };
//
//     setState(() {
//       isSubmit = true;
//     });
//
//     ApiHelper.addNewEvents(body).then((value) {
//       setState(() {
//         isSubmit = true;
//       });
//
//       String dateTime =
//           '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';
//       print("Scheduling notification at $dateTime");
//       // String  dateTimesss = DateTime.parse(dateTime) as String;
//       // print("dateTimesss notification at $dateTimesss");
//
//       NotificationService().showNotification(
//         1,
//         'SmartLeader - Meeting',
//         titleController.text,
//         remindMe,
//         dateTime,
//         Helper.kMeetingScreen,
//       );
//       print("Notification scheduled successfully");
//
//       Navigator.pop(context, true);
//       Helper.showSnackVar('Event Added', kblueColor, context);
//     });
//   }
//
// /*
//   Widget getType() {
//     if (type == 'Meeting') {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomDropDown(
//               lableName: "Meeting Type",
//               hint: "",
//               onChange: (String? value) {
//                 setState(() {
//                   meetingType = value!;
//                 });
//               },
//               items: const [
//                 'Online Meeting',
//                 'Offline Meeting',
//               ],
//               valueType: meetingType),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 13),
//             child: customtext(
//               fontWeight: FontWeight.w500,
//               text: "Meeting Place",
//               fontsize: 14,
//               color: SessionManager.getTheme() == true
//                   ? kWhiteColor
//                   : kbuttonColor,
//             ),
//           ),
//           getMeetingType(),
//         ],
//       );
//     }
//
//     if (type == 'Birthday') {
//       return BirthdayPerson(
//         birthdayController: birthPlaceController,
//       );
//     }
//
//     if (type == 'General') {
//       return GeneralPlace(placeController: generalPlaceController);
//     }
//
//     return const MeetingPlace();
//   }
//
//   Widget getMeetingType() {
//     if (meetingType == 'Online Meeting') {
//       return OnlineMeeting(
//         value: meetingPlace,
//         onOnlineMeetingSelected: (value) {
//           setState(() {
//             meetingPlace = value!;
//           });
//         },
//       );
//     }
//
//     if (meetingType == 'Offline Meeting') {
//       return oflineMeeting(
//         meetingPlaceController: meetingPlaceController,
//       );
//     }
//     return OnlineMeeting(
//       value: meetingPlace,
//       onOnlineMeetingSelected: (value) {
//         setState(() {
//           meetingPlace = value!;
//         });
//       },
//     );
//   }
//
//
//   */
// }

/*
Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
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
                  // InkWell(
                  //     onTap: () {},
                  //     child: Icon(
                  //       Icons.delete,
                  //       size: 20,
                  //       color: kWhiteColor,
                  //     )),

                  // Container(
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     border: Border.all(color: kWhiteColor)
                  //   ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(3.0),
                  //       child: Center(
                  //           child: Icon(
                  //   Icons.delete,
                  //   size: 20,
                  //   color: kWhiteColor,
                  // )),
                  //     ))
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: customtext(
                          fontWeight: FontWeight.w500,
                          text: "+Add Meeting",
                          color: Theme.of(context).primaryColor,
                          fontsize: 20),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        hight: 50,
                        title: "Enter Title",
                        controller: titleController,
                        hint: "Title",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        lableName: "Title",
                        hintfont: 12,
                        lablefont: 14),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextField(
                        hight: 50,
                        title: "Enter Name",
                        controller: leaderController,
                        hint: "hh",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        lableName: "Leader Name",
                        hintfont: 12,
                        lablefont: 14),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomDropDown(
                        lableName: "Select Type",
                        hint: "",
                        onChange: (String? value) {
                          setState(() {
                            meetingType = value!;
                          });
                        },
                        items: const [
                          "Select Meeting Type",
                          'Online ',
                          'Offline ',
                        ],
                        color: meetingType == "Select Meeting Type"
                            ? klableColor
                            : SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kscafolledColor,
                        valueType: meetingType),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Date",
                            fontsize: 14,
                            color: SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kbuttonColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2050))
                                .then((value) {
                              print(value);
                              selecteddate =
                                  DateFormat('yyyy-MM-dd').format(value!);

                              setState(() {});
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: kBlackColor, width: 1.2),
                                color: SessionManager.getTheme() == true
                                    ? kscafolledColor
                                    : kWhiteColor),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: customtext(
                                      fontWeight: FontWeight.w700,
                                      text: (selecteddate),
                                      fontsize: 12,
                                      color: selecteddate == "Select Date"
                                          ? klableColor
                                          : SessionManager.getTheme() == true
                                              ? kWhiteColor
                                              : kscafolledColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Time",
                            fontsize: 14,
                            color: SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kbuttonColor,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );
                            if (pickedTime != null) {
                              DateTime date = DateTime.now();
                              String second =
                                  date.second.toString().padLeft(2, '0');
                              List timeSplit =
                                  pickedTime.format(context).split(' ');
                              String formattedTime = timeSplit[0];
                              String time = '$formattedTime:$second';
                              String type = '';
                              if (timeSplit.length > 1) {
                                type = timeSplit[1];
                                time = '$time $type';
                              }

                              notificationTime =
                                  Helper.formatTime(pickedTime.format(context));
                              // if (pickedTime.hour == 0) {
                              //   notificationTime = time;
                              // } else if (pickedTime.hour < 10) {
                              //   notificationTime = '0$time';
                              // } else {
                              //   notificationTime = time;
                              // }
                              print(
                                  '= ${Helper.formatTime(pickedTime.format(context))}');
                              print(pickedTime.hour); //output 7:10:00 PM
                              setState(() {
                                selectedtime = pickedTime.format(
                                    context); //set the value of text field.
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: kBlackColor, width: 1.2),
                                color: SessionManager.getTheme() == true
                                    ? kscafolledColor
                                    : kWhiteColor),
                            child: Center(
                                child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: customtext(
                                    fontWeight: FontWeight.w700,
                                    text: (selectedtime),
                                    fontsize: 12,
                                    color: selectedtime == "Select Time"
                                        ? klableColor
                                        : SessionManager.getTheme() == true
                                            ? kWhiteColor
                                            : kscafolledColor,
                                  ),
                                )
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomDropDown(
                        lableName: "Remind Me",
                        hint: "",
                        onChange: (String? value) {
                          setState(() {
                            dropdownValue4 = value!;
                          });
                        },
                        items: const [
                          "Set Reminder",
                          '0 min',
                          '5 min',
                          '15 min',
                          "30 min",
                          "60 min"
                        ],
                        color: dropdownValue4 == "Set Reminder"
                            ? klableColor
                            : SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kscafolledColor,
                        valueType: dropdownValue4),
                    const SizedBox(
                      height: 30,
                    ),
                    isSubmit == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : custom_Button(
                            onTap: () {
                              setState(() {
                                addMeeting();
                              });
                            },
                            title: "Save",
                            hight: 45,
                            width: 140,
                            fontSize: 20)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
 */

/*
Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customtext(
                        fontWeight: FontWeight.w500,
                        text: "+Add Event",
                        color: Theme.of(context).primaryColor,
                        fontsize: 20),
                    const SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          child: CustomDropDown(
                              lableName: "Type",
                              hint: "",
                              onChange: (String? value) {
                                setState(() {
                                  type = value!;
                                  meetingType = "Online Meeting";
                                  meetingPlace = "Zoom";
                                  birthPlaceController.clear();
                                  generalPlaceController.clear();
                                });
                              },
                              items: const ['Meeting', 'Birthday', 'General'],
                              valueType: type),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        getType()
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hight: 50,
                      title: "Enter Title",
                      controller: titleController,
                      hint: "fff",
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      lableName: "Title",
                      hintfont: 12,
                      lablefont: 14,
                      gapHight: 10,
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Date",
                            fontsize: 14,
                            color: SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kbuttonColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1800),
                                    lastDate: DateTime(2050))
                                .then((value) {
                              selecteddate =
                                  DateFormat('yyyy-MM-dd').format(value!);
                              setState(() {});
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: kBlackColor, width: 1.2),
                                color: SessionManager.getTheme() == true
                                    ? kscafolledColor
                                    : kWhiteColor),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: customtext(
                                      fontWeight: FontWeight.w700,
                                      text: (selecteddate),
                                      fontsize: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Time",
                            fontsize: 14,
                            color: SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kbuttonColor,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );
                            if (pickedTime != null) {
                              DateTime date = DateTime.now();
                              String second =
                                  date.second.toString().padLeft(2, '0');
                              List timeSplit =
                                  pickedTime.format(context).split(' ');
                              String formattedTime = timeSplit[0];
                              String time = '$formattedTime:$second';
                              String type = '';
                              if (timeSplit.length > 1) {
                                type = timeSplit[1];
                                time = '$time $type';
                              }

                              notificationTime =
                                  Helper.formatTime(pickedTime.format(context));

                              print(time); //output 7:10:00 PM
                              setState(() {
                                selectedtime = pickedTime.format(
                                    context); //set the value of text field.
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: kBlackColor, width: 1.2),
                                color: SessionManager.getTheme() == true
                                    ? kscafolledColor
                                    : kWhiteColor),
                            child: Center(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: customtext(
                                      fontWeight: FontWeight.w700,
                                      text: (selectedtime),
                                      fontsize: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    CustomDropDown(
                        lableName: "Remind Me",
                        hint: "",
                        onChange: (String? value) {
                          setState(() {
                            remindMe = value!;
                          });
                        },
                        items: const [
                          '0 min',
                          '5 min',
                          '15 min',
                          "30 min",
                          "60 min"
                        ],
                        valueType: remindMe),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDescriptionTextfield(
                        focusNode: FocusNode(),
                        onchanged: (value) {},
                        boxHight: 100,
                        title: "",
                        controller: descriptionController,
                        hint: "Write Something...",
                        inputAction: TextInputAction.newline,
                        inputType: TextInputType.multiline,
                        lableName: "Description",
                        hintfont: 12,
                        lablefont: 14),
                    const SizedBox(height: 30),
                    isSubmit
                        ? const Center(child: CircularProgressIndicator())
                        : custom_Button(
                            onTap: addEvent,
                            title: "Save",
                            hight: 45,
                            width: 140,
                            fontSize: 18)
                  ],
                )
 */
