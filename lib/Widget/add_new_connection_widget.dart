import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Button2.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_dropdown.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/connections.dart';
import 'package:smart_leader/Modal/show_connection_folder_modal.dart';
import 'package:intl/intl.dart';
import 'package:smart_leader/Widget/edit_creat_connection_widget.dart';
import 'package:smart_leader/services/notification_service.dart';

import '../Componants/custom_description_textfield.dart';

class AddNewConnectionWidget extends StatefulWidget {
  final ShowConnectionFolderModalData showConnectionFolderModalData;

  const AddNewConnectionWidget(
      {Key? key, required this.showConnectionFolderModalData})
      : super(key: key);

  @override
  State<AddNewConnectionWidget> createState() => _AddNewConnectionWidgetState();
}

class _AddNewConnectionWidgetState extends State<AddNewConnectionWidget> {
  bool isSubmit = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String category = 'Select Type';
  String occupation = "Select Occupation";
  String location = "";

  String selecteddate = 'Select Date';
  String selectedtime = "Select Time";
  String dropdownValue4 = "Set Reminder";

  String notificationTime = '';

  bool isMeetYes = false;
  bool isMeetNo = false;
  bool isHappenTBD = false;
  String meetingRequired = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void connection() async {
    if (nameController.text.isEmpty) {
      Helper.toastMassage('Please Enter Name', Colors.red);
      return;
    }

    if (numberController.text.length != 10) {
      Helper.toastMassage('Please Check Phone Number', Colors.red);
      return;
    }

    // if(!Helper.isEmailValid(emailController.text)){
    //   Helper.showSnackVar("Please Enter Valid Email", kredColor, context);
    //   return;
    // }
    // if (occupationController.text.isEmpty) {
    //   Helper.showSnackVar('Please Enter Occupation', Colors.red, context);
    //   return;
    // }

    // if(category == "Select Type"){
    //   Helper.showSnackVar('Please Select Type', Colors.red, context);
    //   return;
    // }

    if (occupation == "Select Occupation") {
      Helper.toastMassage('Please Select Type', Colors.red);
      return;
    }

    if (meetingRequired.isEmpty) {
      Helper.toastMassage('Select meeting required', Colors.red);
      return;
    }
    if (meetingRequired == 'Yes') {
      if (selecteddate == 'Select Date') {
        Helper.toastMassage('Please Select Date', Colors.red);
        return;
      }

      if (selectedtime == 'Select Time') {
        Helper.toastMassage('Please Select Time', Colors.red);
        return;
      }
      if (dropdownValue4 == 'Set Reminder') {
        Helper.toastMassage('Please Select Remind', Colors.red);
        return;
      }
    } else {
      selecteddate = " ";
      selectedtime = " ";
      dropdownValue4 = " ";
    }

    // if (descriptionController.text.isEmpty) {
    //   Helper.showSnackVar('Please Write Short Description', Colors.red, context);
    //   return;
    // }

    bool isNetwork = await Helper.isNetworkAvailable();

    if (isNetwork) {
      Map<String, String> body = {
        "name": '${nameController.text} (${widget.showConnectionFolderModalData.name})',
        "mobile": numberController.text,
        "occupation": occupation,
        'time': selectedtime,
        'date': selecteddate,
        'remind': dropdownValue4,
        "user_id": SessionManager.getUserID(),
        "connection_type_id": widget.showConnectionFolderModalData.id,
        'meeting_required': meetingRequired,
        'meeting_count': meetingRequired == 'Yes' ? '1' : '0',
      };

      setState(() {
        isSubmit = true;
      });

      ApiHelper.addConnection(body).then((login) {
        // setState(() {
        //   isSubmit = false;
        // });

        if (login.message == 'Connection Add Successfully ') {
          addOfflineConnection();
        } else {
          Helper.showSnackVar('Error', Colors.red, context);
        }
      });
    } else {
      addOfflineConnection();
    }
  }

  void addNewConnection() async {
    if (nameController.text.isEmpty) {
      Helper.toastMassage('Please Enter Name', Colors.red);
      return;
    }

    if (numberController.text.length != 10) {
      Helper.toastMassage('Please Check Phone Number', Colors.red);
      return;
    }

    if (occupation == "Select Occupation") {
      Helper.toastMassage('Please Select Type', Colors.red);
      return;
    }

    if (meetingRequired.isEmpty) {
      Helper.toastMassage('Select meeting required', Colors.red);
      return;
    }
    if (meetingRequired == 'Yes') {
      if (selecteddate == 'Select Date') {
        Helper.toastMassage('Please Select Date', Colors.red);
        return;
      }

      if (selectedtime == 'Select Time') {
        Helper.toastMassage('Please Select Time', Colors.red);
        return;
      }

      String dateTime = '$selecteddate $selectedtime';
      bool isTimeGone = Helper.checkPassedDateTime(dateTime);

      if (isTimeGone) {
        Helper.toastMassage('Select future date time', Colors.red);
        return;
      }

      if (dropdownValue4 == 'Set Reminder') {
        Helper.toastMassage('Please Select Remind', Colors.red);
        return;
      }
    } else {
      selecteddate = " ";
      selectedtime = " ";
      dropdownValue4 = " ";
    }

    bool isNetwork = await Helper.isNetworkAvailable();

    if (isNetwork) {
      Map<String, String> body = {
        // "name": nameController.text,
        // "mobile": numberController.text,
        // "occupation": occupation,
        // 'time': selectedtime,
        // 'date': selecteddate,
        // 'remind': dropdownValue4,
        // "user_id": SessionManager.getUserID(),
        // "connection_type_id": widget.showConnectionFolderModalData.id,
        // 'meeting_required': meetingRequired,
        // 'meeting_count': meetingRequired == 'Yes' ? '1' : '0',
        'user_id': SessionManager.getUserID(),
        "name": '${nameController.text} (${widget.showConnectionFolderModalData.name})',
        'mobile': numberController.text,
        'occupation': occupation,
        'time': selectedtime,
        'date': selecteddate,
        'remind': dropdownValue4,
        'meeting_required': meetingRequired,
        'meeting_count': meetingRequired == 'Yes' ? '1' : '0',
        'meeting_happen': '',
        'notes': descriptionController.text.trim(),
        'connection_id': widget.showConnectionFolderModalData.id,
        'title': '${nameController.text} (${widget.showConnectionFolderModalData.name})',
        'description': '',
        'meeting_type': 'One to One',
        'meeting_place': '',
        'birthday_parson': '',
        'place': '',
        'added_type': 'CONNECTION'
      };

      print(body);

      setState(() {
        isSubmit = true;
      });

      ApiHelper.addNewEvents(body).then((login) {
        // setState(() {
        //   isSubmit = false;
        // });

        if (login.status == 'true') {
          addOfflineConnection();
        } else {
          Helper.showSnackVar('Error', Colors.red, context);
        }
      });
    } else {
      addOfflineConnection();
    }
  }

  void addOfflineConnection() async {
    Connections connections = Connections(
        name: nameController.text,
        number: numberController.text,
        time: selectedtime,
        date: selecteddate,
        remind: dropdownValue4,
        connectionId: widget.showConnectionFolderModalData.id,
        occupation: occupation,
        meetingCount: '0',
        meetingRequired: meetingRequired);
    int value = await DBHelper.insertConnection(connections);

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

      addEvent();
    } else {
      setState(() {
        isSubmit = false;
      });

      clearText();
      Navigator.pop(context, true);
      Helper.showSnackVar('Successfully Added', Colors.green, context);
    }
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
      'remind_me': dropdownValue4,
      "connection_type": 'CONNECTION',
      "connection_id": ''
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.addEvents(body).then((value) {
      setState(() {
        isSubmit = false;
      });

      print('ADD EVENTS ${value.message}');
      Navigator.pop(context, true);
      Helper.showSnackVar('Connection added successfully', kblueColor, context);
    });
    print('Body $body');
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
                            text: 'Add Prospect',
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
                    title: "Enter Phone Number",
                    numberformate: 10,
                    controller: numberController,
                    hint: "Number",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    lableName: "Number",
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
                CustomDescriptionTextfield(
                    focusNode: FocusNode(),
                    onchanged: (value) {},
                    boxHight: 80,
                    title: "",
                    controller: descriptionController,
                    hint: "Enter note",
                    inputAction: TextInputAction.newline,
                    inputType: TextInputType.multiline,
                    lableName: "Notes",
                    hintfont: 12,
                    lablefont: 14),
                const SizedBox(height: 8),
                customtext(
                  fontWeight: FontWeight.w600,
                  text: 'Meeting Required',
                  color: Theme.of(context).primaryColor,
                  fontsize: 12.0,
                ),
                const SizedBox(height: 5.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 0),
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
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : custom_Button(
                        onTap: () {
                          // connection();
                          addNewConnection();
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
  }
}
