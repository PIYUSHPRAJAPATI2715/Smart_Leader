import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:smart_leader/services/notification_service.dart';

class AddEventWidget extends StatefulWidget {
  const AddEventWidget({Key? key, required this.selectedDate})
      : super(key: key);

  final DateTime selectedDate;

  @override
  State<AddEventWidget> createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget> {
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
  String notificationTime = '';

  bool isSubmit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selecteddate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                      flex: 2,
                      child: customtext(
                          fontWeight: FontWeight.w500,
                          text: "+Add Event",
                          color: Theme.of(context).primaryColor,
                          fontsize: 20)),
                  Expanded(
                      child: CustomRoundedBottun2(
                          widget: Icon(
                            Icons.clear,
                            color: SessionManager.getTheme() == true
                                ? kBlackColor
                                : kWhiteColor,
                          ),
                          height: 25,
                          width: 25,
                          ontap: () {
                            Navigator.pop(context);
                          }))
                ],
              ),
              const SizedBox(height: 5),
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
                  hint: "Describe the event (optional)",
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
          ),
        ),
      ),
    );
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
            height: 8,
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

  void addEvent() {
    String title = titleController.text;
    String description = descriptionController.text;

    if (title.isEmpty) {
      Helper.toastMassage('Enter Title', Colors.red);
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
    bool isTimeGone =
    Helper.checkPassedDateTime(dateTime);

    print('IS TIME GONE $isTimeGone');

    if (isTimeGone) {
      Helper.toastMassage(
          'Select future date time', Colors.red);
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

   /* if (description.isEmpty) {
      Helper.toastMassage('Enter Description', Colors.red);
      return;
    }
    */

    Map<String, String> body = {
      'user_id': SessionManager.getUserID(),
      'title': title,
      'description': description,
      'date': selecteddate,
      'type': type,
      'time': selectedtime,
      'meeting_type': ' ',
      'meeting_place':' ',
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
          1, 'SmartLeader - Event', titleController.text, remindMe, dateTime,Helper.kEventScreen);

      Navigator.pop(context, true);
      Helper.showSnackVar('Event Added', kblueColor, context);
    });

  }
}

class OnlineMeeting extends StatefulWidget {
  const OnlineMeeting({
    Key? key,
    required this.onOnlineMeetingSelected,
    required this.value,
  }) : super(key: key);

  final String value;
  final ValueChanged<String?> onOnlineMeetingSelected;

  @override
  State<OnlineMeeting> createState() => _OnlineMeetingState();
}

class _OnlineMeetingState extends State<OnlineMeeting> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropDown(
            gapHight: 0,
            hint: "",
            onChange: widget.onOnlineMeetingSelected,
            items: const ['Zoom', 'Google Meet', "Skype"],
            valueType: widget.value),
      ],
    );
  }
}

class oflineMeeting extends StatefulWidget {
  const oflineMeeting({Key? key, required this.meetingPlaceController})
      : super(key: key);

  final TextEditingController meetingPlaceController;

  @override
  State<oflineMeeting> createState() => _oflineMeetingState();
}

class _oflineMeetingState extends State<oflineMeeting> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          hight: 50,
          title: "Enter Place",
          controller: widget.meetingPlaceController,
          hint: "fff",
          inputAction: TextInputAction.next,
          inputType: TextInputType.text,
          lableName: "",
          hintfont: 12,
          lablefont: 14,
          gapHight: 0,
        ),
      ],
    );
  }
}

class GeneralPlace extends StatelessWidget {
  const GeneralPlace({
    Key? key,
    required this.placeController,
  }) : super(key: key);

  final TextEditingController placeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hight: 50,
          title: "Enter Place",
          controller: placeController,
          hint: "fff",
          inputAction: TextInputAction.next,
          inputType: TextInputType.text,
          lableName: "Place",
          hintfont: 12,
          lablefont: 14,
          gapHight: 10,
        ),
      ],
    );
  }
}

class BirthdayPerson extends StatelessWidget {
  const BirthdayPerson({Key? key, required this.birthdayController})
      : super(key: key);

  final TextEditingController birthdayController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hight: 50,
          title: "Name",
          controller: birthdayController,
          hint: "fff",
          inputAction: TextInputAction.next,
          inputType: TextInputType.text,
          lableName: "Birthday Person",
          hintfont: 12,
          lablefont: 14,
          gapHight: 10,
        ),
      ],
    );
  }
}

//todo:-------------------------------------------------

class MeetingPlace extends StatefulWidget {
  const MeetingPlace({
    Key? key,
  }) : super(key: key);

  @override
  State<MeetingPlace> createState() => _MeetingPlaceState();
}

class _MeetingPlaceState extends State<MeetingPlace> {
  String meetingType = "Online Meeting";

  @override
  Widget build(BuildContext context) {
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
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: customtext(
            fontWeight: FontWeight.w500,
            text: "Meeting Place",
            fontsize: 14,
            color:
                SessionManager.getTheme() == true ? kWhiteColor : kbuttonColor,
          ),
        ),
        // SizedBox(
        //   height: 8,
        // ),
        getMeetingType(),
      ],
    );
  }

  Widget getMeetingType() {
    if (meetingType == 'Online Meeting') {
      return OnlineMeeting(
        value: 'meetingPlace',
        onOnlineMeetingSelected: (value) {},
      );
    }

    if (meetingType == 'Offline Meeting') {
      return oflineMeeting(
        meetingPlaceController: TextEditingController(),
      );
    }
    return OnlineMeeting(
      value: 'meetingPlace',
      onOnlineMeetingSelected: (value) {},
    );
  }
}

/*
Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                      flex: 2,
                      child: customtext(
                          fontWeight: FontWeight.w500,
                          text: "+Add Event",
                          color: Theme.of(context).primaryColor,
                          fontsize: 20)),
                  Expanded(
                      child: CustomRoundedBottun2(
                          widget: Icon(
                            Icons.clear,
                            color: SessionManager.getTheme() == true
                                ? kBlackColor
                                : kWhiteColor,
                          ),
                          height: 25,
                          width: 25,
                          ontap: () {
                            Navigator.pop(context);
                          }))
                ],
              ),
              const SizedBox(height: 5),
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
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050))
                          .then((value) {
                        selecteddate = DateFormat('yyyy-MM-dd').format(value!);
                        setState(() {});
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: kBlackColor, width: 1.2),
                          color: SessionManager.getTheme() == true
                              ? kscafolledColor
                              : kWhiteColor),
                      child: Center(
                          child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: customtext(
                              fontWeight: FontWeight.w700,
                              text: (selecteddate),
                              fontsize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ],
                      )),
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
                        String second = date.second.toString().padLeft(2, '0');
                        List timeSplit = pickedTime.format(context).split(' ');
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
                          selectedtime = pickedTime
                              .format(context); //set the value of text field.
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: kBlackColor, width: 1.2),
                          color: SessionManager.getTheme() == true
                              ? kscafolledColor
                              : kWhiteColor),
                      child: Center(
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropDown(
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
                  const SizedBox(
                    height: 10,
                  ),
                  getType()
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
                  items: const ['0 min', '5 min', '15 min', "30 min", "60 min"],
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
          ),
 */