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
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/connections.dart';
import 'package:smart_leader/Modal/show_connection_modal.dart';
import 'package:intl/intl.dart';
import 'package:smart_leader/services/notification_service.dart';

import '../Modal/new_event.dart';

class EditCreatConnectionWidget extends StatefulWidget {
  // final ShowConnectionModalData showConnectionModalData;
  final NewEventData showConnectionModalData;
  final String connectionTypeId;

  const EditCreatConnectionWidget({
    Key? key,
    required this.showConnectionModalData,
    required this.connectionTypeId,
  }) : super(key: key);

  @override
  State<EditCreatConnectionWidget> createState() =>
      _EditCreatConnectionWidgetState();
}

class _EditCreatConnectionWidgetState extends State<EditCreatConnectionWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  String category = 'Select Type';
  bool isSubmit = false;
  String occupation = "Select Occupation";

  String selecteddate = 'Select Date';
  String selectedtime = "Select Time";
  String dropdownValue4 = "Set Reminder";

  bool isMeetYes = false;
  bool isMeetNo = false;
  String meetingRequired = '';
  String meetingHappen = '';
  bool isHappenYes = false;
  bool isHappenNo = false;
  bool isHappenTBD = false;

  String notificationTime = '';

  bool isDateTimePassed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.showConnectionModalData.name!;
    numberController.text = widget.showConnectionModalData.mobile!;
    occupation = widget.showConnectionModalData.occupation!;

    notesController.text = widget.showConnectionModalData.notes == null
        ? ''
        : widget.showConnectionModalData.notes!;
    meetingRequired = widget.showConnectionModalData.meetingRequired!;

    /*if (meetingRequired == 'Yes') {
      selectedtime = widget.showConnectionModalData.time!;
      selecteddate = widget.showConnectionModalData.date!;
      dropdownValue4 = widget.showConnectionModalData.remind!;
      String passDateTime = '$selecteddate $selectedtime';
      isDateTimePassed = Helper.checkPassedDateTime(passDateTime);
      // isMeetYes = true;
      // isMeetNo = false;
    } else {
      // isMeetYes = false;
      // isMeetNo = true;
    }*/

    if (meetingRequired == 'Yes') {
      selectedtime = widget.showConnectionModalData.time!;
      selecteddate = widget.showConnectionModalData.date!;
      dropdownValue4 = widget.showConnectionModalData.remind!;
      String passDateTime = '$selecteddate $selectedtime';
      isDateTimePassed = Helper.checkPassedDateTime(passDateTime);
      isMeetYes = true;
      isMeetNo = false;
      isHappenTBD = false;
    } else if (meetingRequired == "TBD") {
      isMeetYes = false;
      isMeetNo = false;
      isHappenTBD = true;
    } else {
      isMeetYes = false;
      isMeetNo = true;
      isHappenTBD = false;
    }
  }

  void updateNewConnection() async {
    if (nameController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Name', Colors.red, context);
      return;
    }

    if (numberController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Mobile Number', Colors.red, context);
      return;
    }
    if (meetingHappen.isEmpty) {
      Helper.toastMassage('Select meeting happened', Colors.red);
      return;
    }
    if (notesController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Notes', Colors.red, context);
      return;
    }

    if (meetingRequired.isEmpty) {
      Helper.toastMassage('Select meeting required', Colors.red);
      return;
    }

    if (meetingRequired == 'Yes') {
      if (selecteddate == 'Select Date') {
        Helper.showSnackVar('Please Select Date', Colors.red, context);
        return;
      }

      if (selectedtime == 'Select Time') {
        Helper.showSnackVar('Please Select Time', Colors.red, context);
        return;
      }
      if (dropdownValue4 == 'Set Reminder') {
        Helper.showSnackVar('Please Select Remind', Colors.red, context);
        return;
      }
    } else {
      selecteddate = widget.showConnectionModalData.date!;
      selectedtime = widget.showConnectionModalData.time!;
      dropdownValue4 = widget.showConnectionModalData.occupation!;
    }

    int meetingCount =
        int.parse(widget.showConnectionModalData.meetingCount!) + 1;

    Map<String, String> body = {
      'id': widget.showConnectionModalData.id!,
      "name": nameController.text,
      "mobile": numberController.text,
      "occupation": occupation,
      'time': selectedtime,
      'date': selecteddate,
      'remind': dropdownValue4,
      'notes': notesController.text,
      'meeting_required': meetingRequired,
      'meeting_happen': meetingHappen,
      'meeting_count': meetingRequired == 'Yes' && meetingHappen == 'Yes'
          ? meetingCount.toString()
          : widget.showConnectionModalData.meetingCount!,
      'user_id': SessionManager.getUserID(),
      'connection_id': widget.showConnectionModalData.connectionId!,
      'title': nameController.text,
      'description': '',
      'meeting_type': 'One to One',
      'meeting_place': '',
      'birthday_parson': '',
      'place': '',
      'added_type': 'CONNECTION'
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.updateNewEvent(body).then((value) {
      setState(() {
        isSubmit = true;
      });

      String dateTime =
          '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';

      NotificationService().showNotification(
          1,
          'SmartLeader - Connection',
          nameController.text,
          dropdownValue4,
          dateTime,
          Helper.kConnectionScreen);

      Navigator.pop(context, true);
      Helper.showSnackVar('Connection Updated', kblueColor, context);
    });
  }

  void editconnection() async {
    if (nameController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Name', Colors.red, context);
      return;
    }

    if (numberController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Mobile Number', Colors.red, context);
      return;
    }
    if (meetingHappen.isEmpty) {
      Helper.toastMassage('Select meeting happened', Colors.red);
      return;
    }
    if (notesController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Notes', Colors.red, context);
      return;
    }

    if (meetingRequired.isEmpty) {
      Helper.toastMassage('Select meeting required', Colors.red);
      return;
    }

    if (meetingRequired == 'Yes') {
      if (selecteddate == 'Select Date') {
        Helper.showSnackVar('Please Select Date', Colors.red, context);
        return;
      }

      if (selectedtime == 'Select Time') {
        Helper.showSnackVar('Please Select Time', Colors.red, context);
        return;
      }
      if (dropdownValue4 == 'Set Reminder') {
        Helper.showSnackVar('Please Select Remind', Colors.red, context);
        return;
      }
    } else {
      selecteddate = " ";
      selectedtime = " ";
      dropdownValue4 = " ";
    }

    bool isNetwork = await Helper.isNetworkAvailable();

    int meetingCount =
        int.parse(widget.showConnectionModalData.meetingCount!) + 1;

    if (isNetwork) {
      Map<String, String> body = {
        "id": widget.showConnectionModalData.id!,
        "name": nameController.text,
        "mobile": numberController.text,
        "occupation": occupation,
        'time': selectedtime,
        'date': selecteddate,
        'remind': dropdownValue4,
        'notes': notesController.text,
        'meeting_required': meetingRequired,
        'meeting_happen': meetingHappen,
        'meeting_count': meetingRequired == 'Yes'
            ? meetingCount.toString()
            : widget.showConnectionModalData.meetingCount!
      };

      setState(() {
        isSubmit = true;
      });

      ApiHelper.editConnection(body).then((login) {
        setState(() {
          isSubmit = false;
        });

        if (login.message == 'Update Connection Successfully') {
          // clearText();
          // Navigator.pop(context, true);
          // Helper.showSnackVar('Update Successfully', Colors.green, context);
          updateConnection();
        } else {
          Helper.showSnackVar('Error', Colors.red, context);
        }
      });
    } else {
      updateConnection();
    }
  }

  void updateConnection() {
    int meetingCount =
        int.parse(widget.showConnectionModalData.meetingCount!) + 1;

    Connections connections = Connections(
        id: int.parse(widget.showConnectionModalData.id!),
        name: nameController.text,
        number: numberController.text,
        time: selectedtime,
        date: selecteddate,
        remind: dropdownValue4,
        connectionId: widget.connectionTypeId,
        occupation: occupation,
        meetingRequired: meetingRequired,
        meetingCount: meetingRequired == 'Yes'
            ? meetingCount.toString()
            : widget.showConnectionModalData.meetingCount!);

    DBHelper.updateConnection(connections).then((value) {
      //todo: here we set notification...

      if (meetingRequired == 'Yes') {
        String dateTime =
            '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';

        NotificationService().showNotification(
            value,
            'SmartLeader - Connection',
            nameController.text,
            dropdownValue4,
            dateTime,
            Helper.kConnectionScreen);

        //addEvent();
        setState(() {
          isSubmit = false;
        });
        Navigator.pop(context);
        Helper.showSnackVar('Updated', kblueColor, context);
      } else {
        setState(() {
          isSubmit = false;
        });

        Navigator.pop(context, true);
        Helper.showSnackVar('Successfully Updated', Colors.green, context);
        descriptionController.clear();
        clearText();
      }
    });
  }

  void addEvent() {
    Map<String, String> body = {
      'user_id': SessionManager.getUserID(),
      'title': nameController.text,
      'description': numberController.text,
      'date': selecteddate,
      'type': 'One to One',
      'time': selectedtime,
      'meeting_type': ' ',
      'meeting_place': ' ',
      'birthday_parson': ' ',
      'place': ' ',
      'remind_me': dropdownValue4
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.addEvents(body).then((value) {
      setState(() {
        isSubmit = false;
      });

      Navigator.pop(context, true);
      Helper.showSnackVar('Updated', kblueColor, context);
    });
  }

  void clearText() {
    nameController.clear();
    emailController.clear();
    numberController.clear();
    occupationController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
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
                    Expanded(
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Edit Prospect",
                            alignment: TextAlign.center,
                            color: Theme.of(context).primaryColor,
                            fontsize: 20)),
                    CustomRoundedBottun2(
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
                        })
                  ],
                ),
                const SizedBox(height: 15),
                CustomTextField(
                    hight: 50,
                    title: "Enter Name",
                    controller: nameController,
                    hint: "Name",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    lableName: "Name",
                    hintfont: 12,
                    lablefont: 14),
                const SizedBox(height: 8),
                CustomTextField(
                    hight: 50,
                    title: "Enter Number",
                    numberformate: 10,
                    controller: numberController,
                    hint: "Number",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    lableName: "Number",
                    hintfont: 12,
                    lablefont: 14),
                const SizedBox(height: 8),
                const SizedBox(height: 8),
                CustomDropDown(
                    lableName: "Occupation",
                    hint: "",
                    onChange: (String? value) {
                      setState(() {
                        occupation = value!;
                      });
                    },
                    items: const [
                      "Select Occupation",
                      'Private Job',
                      'Government Job',
                      'Student',
                      "Business",
                      "Other"
                    ],
                    color: occupation == "Select Occupation"
                        ? klableColor
                        : SessionManager.getTheme() == true
                            ? kWhiteColor
                            : kscafolledColor,
                    valueType: occupation),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /* customtext(
                      fontWeight: FontWeight.w600,
                      text:
                          'Meeting No: #${widget.showConnectionModalData.meetingCount}',
                      color: Theme.of(context).primaryColor,
                      fontsize: 14.0,
                    ),*/
                    const SizedBox(height: 5.0),
                    customtext(
                      fontWeight: FontWeight.w600,
                      text: 'Has meeting happened?',
                      color: Theme.of(context).primaryColor,
                      fontsize: 12.0,
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        CustomRadioWidget(
                          text: 'Yes',
                          isSelected: isHappenYes,
                          onClick: () {
                            setState(() {
                              isHappenYes = true;
                              isHappenNo = false;
                              isHappenTBD = false;
                              meetingHappen = 'Yes';
                              // isMeetYes = false;
                              // isMeetNo = true;
                              // meetingRequired = 'No';
                            });
                          },
                        ),
                        CustomRadioWidget(
                          text: 'No',
                          isSelected: isHappenNo,
                          onClick: () {
                            setState(() {
                              isHappenYes = false;
                              isHappenNo = true;
                              meetingHappen = 'No';
                              isHappenTBD = false;

                              // isMeetYes = false;
                              // isMeetNo = true;
                              // meetingRequired = 'No';
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                CustomDescriptionTextfield(
                    focusNode: FocusNode(),
                    onchanged: (value) {},
                    boxHight: 80,
                    title: "",
                    controller: notesController,
                    hint: "Enter note",
                    inputAction: TextInputAction.newline,
                    inputType: TextInputType.multiline,
                    lableName: "Notes",
                    hintfont: 12,
                    lablefont: 14),
                const SizedBox(height: 15),
                Visibility(
                  visible: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customtext(
                        fontWeight: FontWeight.w600,
                        text: 'Meeting Required',
                        color: Theme.of(context).primaryColor,
                        fontsize: 12.0,
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          CustomRadioWidget(
                            text: 'Yes',
                            isSelected: isMeetYes,
                            onClick: () {
                              setState(() {
                                isMeetYes = true;
                                isMeetNo = false;
                                isHappenTBD = false;
                                meetingRequired = 'Yes';
                              });
                            },
                          ),
                          CustomRadioWidget(
                            text: 'No',
                            isSelected: isMeetNo,
                            onClick: () {
                              setState(() {
                                isMeetYes = false;
                                isMeetNo = true;
                                isHappenTBD = false;
                                meetingRequired = 'No';
                              });
                            },
                          ),
                          CustomRadioWidget(
                            text: 'TBD',
                            isSelected: isHappenTBD,
                            onClick: () {
                              setState(() {
                                isMeetYes = false;
                                isMeetNo = false;
                                isHappenTBD = true;
                                meetingRequired = 'TBD';
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                Visibility(
                  visible: meetingRequired == 'Yes',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
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

                          )


                              .then((value) {
                            selecteddate =
                                DateFormat('dd-MM-yyyy').format(value!);
                            //DateFormat('dd-MM-yyyy').format(value!);
                            setState(() {});
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(color: kblueColor, width: 1.2),
                              color: SessionManager.getTheme() == true
                                  ? kblueColor
                                  : kWhiteColor),
                          child: Center(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: customtext(
                                    fontWeight: FontWeight.w700,
                                    text: selecteddate,
                                    fontsize: 12,
                                    color: selecteddate == "Select Date"
                                        ? klableColor
                                        : SessionManager.getTheme() == true
                                            ? kWhiteColor
                                            : Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                                  dialogBackgroundColor: Colors.blueGrey
                                      .shade100, // Dialog background
                                  colorScheme: ColorScheme.light(
                                    primary:
                                    Color(0xffA16E4B).withOpacity(0.5),
                                    // Header color
                                    onPrimary: Colors.black,
                                    // Header text color
                                    surface: Colors.white,
                                    // Surface color
                                    onSurface: Colors
                                        .black, // OK/CANCEL text color
                                  ),
                                  timePickerTheme: TimePickerThemeData(
                                    dayPeriodColor:
                                    Color(0xffA16E4B).withOpacity(0.5),
                                    // AM/PM background color
                                    dayPeriodTextColor: Colors.black,
                                    // AM/PM text color
                                    dayPeriodShape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: Colors.grey
                                              .shade400), // Border styling
                                    ),
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors
                                          .black, // OK and CANCEL button text color
                                    ),
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
                            /*if (pickedTime.hour == 0) {
                          notificationTime = time;
                          print('if $notificationTime');
                        } else if (pickedTime.hour < 10) {
                          notificationTime = '0$time';
                          print('else if $notificationTime');
                        } else {
                          print('else $notificationTime');
                          notificationTime = time;
                        }*/

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
                                  Border.all(color: kblueColor, width: 1.2),
                              color: SessionManager.getTheme() == true
                                  ? kblueColor
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
                                  color: selectedtime == "Select Time"
                                      ? klableColor
                                      : SessionManager.getTheme() == true
                                          ? kWhiteColor
                                          : Colors.black,
                                ),
                              )
                            ],
                          )),
                        ),
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
                          items: const <String>[
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                isSubmit == true
                    ? const Center(child: CircularProgressIndicator())
                    : custom_Button(
                        onTap: () {
                          // connection();

                          if (meetingRequired == 'Yes') {
                            if (selecteddate == "Select Date" &&
                                selectedtime == 'Select Time') {
                              Helper.toastMassage(
                                  'Select date and time', Colors.red);
                              return;
                            }

                            String dateTime = '$selecteddate $selectedtime';
                            bool isTimeGone =
                                Helper.checkPassedDateTime(dateTime);

                            if (isTimeGone) {
                              Helper.toastMassage(
                                  'Select future date time', Colors.red);
                              return;
                            }
                          }

                          updateNewConnection();
                        },
                        title: "Update",
                        hight: 45,
                        width: 140,
                        fontSize: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRadioWidget extends StatelessWidget {
  const CustomRadioWidget(
      {Key? key,
      required this.text,
      required this.onClick,
      required this.isSelected})
      : super(key: key);

  final VoidCallback onClick;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 15.0,
              width: 15.0,
              decoration: BoxDecoration(
                  border: Border.all(color: kblueColor),
                  shape: BoxShape.circle,
                  color: isSelected ? kblueColor : Colors.white),
            ),
            const SizedBox(width: 3.0),
            customtext(
              fontWeight: FontWeight.w600,
              text: text,
              fontsize: 12.0,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}

//todo:------------------------------------------------------------------------

//todo: this will come only when time not passed
class EditCreateConnectionNoWidget extends StatefulWidget {
  const EditCreateConnectionNoWidget(
      {Key? key,
      required this.showConnectionModalData,
      required this.connectionTypeId})
      : super(key: key);

  //final ShowConnectionModalData showConnectionModalData;
  final NewEventData showConnectionModalData;
  final String connectionTypeId;

  @override
  State<EditCreateConnectionNoWidget> createState() =>
      _EditCreateConnectionNoWidgetState();
}

class _EditCreateConnectionNoWidgetState
    extends State<EditCreateConnectionNoWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  String category = 'Select Type';
  bool isSubmit = false;
  String occupation = "Select Occupation";

  String selecteddate = 'Select Date';
  String selectedtime = "Select Time";
  String dropdownValue4 = "Set Reminder";

  bool isMeetYes = false;
  bool isMeetNo = false, isHappenTBD = false;
  String meetingRequired = '';

  String notificationTime = '';

  bool isDateTimePassed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController.text = widget.showConnectionModalData.name!;
    numberController.text = widget.showConnectionModalData.mobile!;
    occupation = widget.showConnectionModalData.occupation!;

    notesController.text = widget.showConnectionModalData.notes == null
        ? ''
        : widget.showConnectionModalData.notes!;
    meetingRequired = widget.showConnectionModalData.meetingRequired!;

    if (meetingRequired == 'Yes') {
      selectedtime = widget.showConnectionModalData.time!;
      selecteddate = widget.showConnectionModalData.date!;
      dropdownValue4 = widget.showConnectionModalData.remind!;
      String passDateTime = '$selecteddate $selectedtime';
      isDateTimePassed = Helper.checkPassedDateTime(passDateTime);
      isMeetYes = true;
      isMeetNo = false;
      isHappenTBD = false;
    } else if (meetingRequired == "TBD") {
      isMeetYes = false;
      isMeetNo = false;
      isHappenTBD = true;
    } else {
      isMeetYes = false;
      isMeetNo = true;
      isHappenTBD = false;
    }

    /*
    if (meetingRequired.isNotEmpty) {
      if (meetingRequired == 'Yes') {
        isMeetYes = true;

        if (selecteddate.isNotEmpty) {
          String passDateTime = '$selecteddate $selectedtime';
          isDateTimePassed = Helper.checkPassedDateTime(passDateTime);
        }
      } else {
        isMeetNo = false;
      }
    }

     */
  }

  void editconnection() async {
    if (nameController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Name', Colors.red, context);
      return;
    }

    if (numberController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Mobile Number', Colors.red, context);
      return;
    }
    if (meetingRequired.isEmpty) {
      Helper.toastMassage('Select meeting required', Colors.red);
      return;
    }

    if (meetingRequired == 'Yes') {
      if (selecteddate == 'Select Date') {
        Helper.showSnackVar('Please Select Date', Colors.red, context);
        return;
      }

      if (selecteddate == 'Select Date') {
        Helper.showSnackVar('Please Select Date', Colors.red, context);
        return;
      }

      if (selectedtime == 'Select Time') {
        Helper.showSnackVar('Please Select Time', Colors.red, context);
        return;
      }
      if (dropdownValue4 == 'Set Reminder') {
        Helper.showSnackVar('Please Select Remind', Colors.red, context);
        return;
      }
    } else {
      selecteddate = " ";
      selectedtime = " ";
      dropdownValue4 = " ";
    }
    bool isNetwork = await Helper.isNetworkAvailable();

    int meetingCount =
        int.parse(widget.showConnectionModalData.meetingCount!) + 1;

    if (isNetwork) {
      Map<String, String> body = {
        "id": widget.showConnectionModalData.id!,
        "name": nameController.text,
        "mobile": numberController.text,
        "occupation": occupation,
        'time': selectedtime,
        'date': selecteddate,
        'remind': dropdownValue4,
        'notes': ' ',
        'meeting_required': meetingRequired,
        'meeting_happen': '',
        'meeting_count': meetingRequired.toLowerCase() == 'yes'
            ? '$meetingCount'
            : widget.showConnectionModalData.meetingCount!
      };
      /*

       */

      print('Map $body');
      setState(() {
        isSubmit = true;
      });

      ApiHelper.editConnection(body).then((login) {
        setState(() {
          isSubmit = false;
        });

        if (login.message == 'Update Connection Successfully') {
          // clearText();
          // Navigator.pop(context, true);
          // Helper.showSnackVar('Update Successfully', Colors.green, context);
          updateConnection();
        } else {
          Helper.showSnackVar('Error', Colors.red, context);
        }
      });
    } else {
      updateConnection();
    }
  }

  void updateNewConnection() async {
    if (nameController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Name', Colors.red, context);
      return;
    }

    if (numberController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Mobile Number', Colors.red, context);
      return;
    }

    if (meetingRequired.isEmpty) {
      Helper.toastMassage('Select meeting required', Colors.red);
      return;
    }

    if (meetingRequired == 'Yes') {
      if (selecteddate == 'Select Date') {
        Helper.showSnackVar('Please Select Date', Colors.red, context);
        return;
      }

      if (selecteddate == 'Select Date') {
        Helper.showSnackVar('Please Select Date', Colors.red, context);
        return;
      }

      if (selectedtime == 'Select Time') {
        Helper.showSnackVar('Please Select Time', Colors.red, context);
        return;
      }
      if (dropdownValue4 == 'Set Reminder') {
        Helper.showSnackVar('Please Select Remind', Colors.red, context);
        return;
      }
    } else {
      selecteddate = " ";
      selectedtime = " ";
      dropdownValue4 = " ";
    }

    int meetingCount = 1;

    if (widget.showConnectionModalData.meetingHappen!.isNotEmpty) {
      meetingCount = int.parse(widget.showConnectionModalData.meetingCount!);
    }

    print('OK $meetingCount');
    //int.parse(widget.showConnectionModalData.meetingCount!) + 1;

    Map<String, String> body = {
      'id': widget.showConnectionModalData.id!,
      "name": nameController.text,
      "mobile": numberController.text,
      "occupation": occupation,
      'time': selectedtime,
      'date': selecteddate,
      'remind': dropdownValue4,
      'notes': notesController.text.trim(),
      'meeting_required': meetingRequired,
      'meeting_happen': '',
      'meeting_count': meetingRequired.toLowerCase() == 'yes'
          ? '$meetingCount'
          : widget.showConnectionModalData.meetingCount!,
      'user_id': SessionManager.getUserID(),
      'connection_id': widget.showConnectionModalData.connectionId!,
      'title': nameController.text,
      'description': '',
      'meeting_type': 'One to One',
      'meeting_place': '',
      'birthday_parson': '',
      'place': '',
      'added_type': 'CONNECTION'
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.updateNewEvent(body).then((value) {
      setState(() {
        isSubmit = true;
      });

      String dateTime =
          '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';

      NotificationService().showNotification(
          1,
          'SmartLeader - Connection',
          nameController.text,
          dropdownValue4,
          dateTime,
          Helper.kConnectionScreen);

      Navigator.pop(context, true);
      Helper.showSnackVar('Connection Updated', kblueColor, context);
    });
  }

  void updateConnection() {
    int meetingCount =
        int.parse(widget.showConnectionModalData.meetingCount!) + 1;

    Connections connections = Connections(
        id: int.parse(widget.showConnectionModalData.id!),
        name: nameController.text,
        number: numberController.text,
        time: selectedtime,
        date: selecteddate,
        remind: dropdownValue4,
        connectionId: widget.connectionTypeId,
        occupation: occupation,
        meetingRequired: meetingRequired,
        meetingCount: meetingRequired == 'Yes'
            ? meetingCount.toString()
            : widget.showConnectionModalData.meetingCount!);

    DBHelper.updateConnection(connections).then((value) {
      //todo: here we set notification...

      if (meetingRequired == 'Yes') {
        String dateTime =
            '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';

        NotificationService().showNotification(
            value,
            'SmartLeader - Connection',
            nameController.text,
            dropdownValue4,
            dateTime,
            Helper.kConnectionScreen);

        //   addEvent();
        Helper.showSnackVar('Connection updated', kblueColor, context);
        Navigator.pop(context);
        setState(() {
          isSubmit = false;
        });
      } else {
        setState(() {
          isSubmit = false;
        });

        Navigator.pop(context, true);
        Helper.showSnackVar('Successfully Updated', Colors.green, context);
        descriptionController.clear();
        clearText();
      }
    });
  }

  void addEvent() {
    Map<String, String> body = {
      'user_id': SessionManager.getUserID(),
      'title': nameController.text,
      'description': numberController.text,
      'date': selecteddate,
      'type': 'One to One',
      'time': selectedtime,
      'meeting_type': ' ',
      'meeting_place': ' ',
      'birthday_parson': ' ',
      'place': ' ',
      'remind_me': dropdownValue4
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.addEvents(body).then((value) {
      setState(() {
        isSubmit = false;
      });

      Navigator.pop(context, true);
      Helper.showSnackVar(
          'Connection update successfully', kblueColor, context);
    });
  }

  void clearText() {
    nameController.clear();
    emailController.clear();
    numberController.clear();
    occupationController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
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
                    Expanded(
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Edit Prospect",
                            alignment: TextAlign.center,
                            color: Theme.of(context).primaryColor,
                            fontsize: 20)),
                    CustomRoundedBottun2(
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
                        })
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    hight: 50,
                    title: "Enter Name",
                    controller: nameController,
                    hint: "Name",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    lableName: "Name",
                    hintfont: 12,
                    lablefont: 14),
                const SizedBox(height: 8),
                CustomTextField(
                    hight: 50,
                    title: "Enter Number",
                    numberformate: 10,
                    controller: numberController,
                    hint: "Number",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    lableName: "Number",
                    hintfont: 12,
                    lablefont: 14),
                const SizedBox(height: 8),
                CustomDescriptionTextfield(
                    focusNode: FocusNode(),
                    onchanged: (value) {},
                    boxHight: 80,
                    title: "",
                    controller: notesController,
                    hint: "Enter note",
                    inputAction: TextInputAction.newline,
                    inputType: TextInputType.multiline,
                    lableName: "Notes",
                    hintfont: 12,
                    lablefont: 14),
                const SizedBox(height: 8),
                CustomDropDown(
                    lableName: "Occupation",
                    hint: "",
                    onChange: (String? value) {
                      setState(() {
                        occupation = value!;
                      });
                    },
                    items: const [
                      "Select Occupation",
                      'Private Job',
                      'Government Job',
                      'Student',
                      "Business",
                      "Other"
                    ],
                    color: occupation == "Select Occupation"
                        ? klableColor
                        : SessionManager.getTheme() == true
                            ? kWhiteColor
                            : kscafolledColor,
                    valueType: occupation),
                const SizedBox(height: 8),
                customtext(
                  fontWeight: FontWeight.w600,
                  text: 'Meeting Required',
                  color: Theme.of(context).primaryColor,
                  fontsize: 12.0,
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    CustomRadioWidget(
                      text: 'Yes',
                      isSelected: isMeetYes,
                      onClick: () {
                        setState(() {
                          isMeetYes = true;
                          isMeetNo = false;
                          isHappenTBD = false;
                          meetingRequired = 'Yes';
                        });
                      },
                    ),
                    CustomRadioWidget(
                      text: 'No',
                      isSelected: isMeetNo,
                      onClick: () {
                        setState(() {
                          isMeetYes = false;
                          isMeetNo = true;
                          isHappenTBD = false;
                          meetingRequired = 'No';
                        });
                      },
                    ),
                    CustomRadioWidget(
                      text: 'TBD',
                      isSelected: isHappenTBD,
                      onClick: () {
                        setState(() {
                          isMeetYes = false;
                          isMeetNo = false;
                          isHappenTBD = true;
                          meetingRequired = 'TBD';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Visibility(
                  visible: meetingRequired == 'Yes',
                  child: Column(
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
                            //DateFormat('dd-MM-yyyy').format(value!);
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: customtext(
                                  fontWeight: FontWeight.w700,
                                  text: selecteddate,
                                  fontsize: 12,
                                  color: selecteddate == "Select Date"
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
                      const SizedBox(height: 8),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                      const SizedBox(
                        height: 8,
                      ),
                      CustomDropDown(
                          lableName: "Remind Me",
                          hint: "",
                          onChange: (String? value) {
                            setState(() {
                              dropdownValue4 = value!;
                            });
                          },
                          items: const <String>[
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                isSubmit == true
                    ? const Center(child: CircularProgressIndicator())
                    : custom_Button(
                        onTap: () {
                          if (meetingRequired == 'Yes') {
                            if (selecteddate == "Select Date" &&
                                selectedtime == 'Select Time') {
                              Helper.toastMassage(
                                  'Select date and time', Colors.red);
                              return;
                            }

                            String dateTime = '$selecteddate $selectedtime';
                            bool isTimeGone =
                                Helper.checkPassedDateTime(dateTime);

                            if (isTimeGone) {
                              Helper.toastMassage(
                                  'Select future date time', Colors.red);
                              return;
                            }
                          }

                          //editconnection();
                          updateNewConnection();
                        },
                        title: "Update",
                        hight: 45,
                        width: 140,
                        fontSize: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
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
                        flex: 4,
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "+Edit Connection",
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
                const SizedBox(height: 15),
                Visibility(
                  visible: isDateTimePassed,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                          hight: 50,
                          title: "Enter Notes",
                          controller: notesController,
                          hint: "Meeting notes",
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.text,
                          lableName: "Meeting Notes",
                          hintfont: 12,
                          lablefont: 14),
                      const SizedBox(height: 15),
                      customtext(
                        fontWeight: FontWeight.w600,
                        text: 'Next Meeting Required',
                        color: Theme.of(context).primaryColor,
                        fontsize: 12.0,
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          CustomRadioWidget(
                            text: 'Yes',
                            isSelected: isMeetYes,
                            onClick: () {
                              setState(() {
                                isMeetYes = true;
                                isMeetNo = false;
                                meetingRequired = 'Yes';
                              });
                            },
                          ),
                          CustomRadioWidget(
                            text: 'No',
                            isSelected: isMeetNo,
                            onClick: () {
                              setState(() {
                                isMeetYes = false;
                                isMeetNo = true;
                                meetingRequired = 'No';
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                CustomTextField(
                    hight: 50,
                    title: "Enter Name",
                    controller: nameController,
                    hint: "Name",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    lableName: "Name",
                    hintfont: 12,
                    lablefont: 14),
                const SizedBox(height: 8),
                CustomTextField(
                    hight: 50,
                    title: "Enter Number",
                    numberformate: 10,
                    controller: numberController,
                    hint: "Number",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    lableName: "Number",
                    hintfont: 12,
                    lablefont: 14),
                const SizedBox(height: 8),
                // CustomTextField(hight: 50,
                //     title: "Enter Email",
                //     controller: emailController,
                //     hint: "Email",
                //     inputAction: TextInputAction.next,
                //     inputType: TextInputType.text,
                //     lableName: "Email",
                //     hintfont: 12,
                //     lablefont: 14),
                // SizedBox(
                //   height: 8,
                // ),
                CustomDropDown(
                    lableName: "Occupation",
                    hint: "",
                    onChange: (String? value) {
                      setState(() {
                        occupation = value!;
                      });
                    },
                    items: const [
                      "Select Occupation",
                      'Private Job',
                      'Government Job',
                      'Student',
                      "Business",
                      "Other"
                    ],
                    color: occupation == "Select Occupation"
                        ? klableColor
                        : SessionManager.getTheme() == true
                            ? kWhiteColor
                            : kscafolledColor,
                    valueType: occupation),

                const SizedBox(
                  height: 8,
                ),
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
                      selecteddate = DateFormat('yyyy-MM-dd').format(value!);
                      //DateFormat('dd-MM-yyyy').format(value!);
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
                            text: selecteddate,
                            fontsize: 12,
                            color: selecteddate == "Select Date"
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
                const SizedBox(height: 8),
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
                const SizedBox(height: 8),
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

                      print(time); //output 7:10:00 PM
                      notificationTime =
                          Helper.formatTime(pickedTime.format(context));

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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                const SizedBox(
                  height: 8,
                ),
                CustomDropDown(
                    lableName: "Remind Me",
                    hint: "",
                    onChange: (String? value) {
                      setState(() {
                        dropdownValue4 = value!;
                      });
                    },
                    items: const <String>[
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

                const SizedBox(height: 20),
                // isSubmit == true?Center(child: CircularProgressIndicator(),):
                isSubmit == true
                    ? const Center(child: CircularProgressIndicator())
                    : custom_Button(
                        onTap: () {
                          String dateTime = '$selecteddate $selectedtime';
                          bool isTimeGone =
                              Helper.checkPassedDateTime(dateTime);

                          if (isTimeGone) {
                            Helper.toastMassage(
                                'Select future date time', Colors.red);
                            return;
                          }

                          editconnection();
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
    );
 */
