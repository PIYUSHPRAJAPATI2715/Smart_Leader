import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_leader/Componants/custom_new_edit.dart';
import '../Componants/Custom_text.dart';
import '../Componants/custom_Round_Button2.dart';
import '../Componants/custom_bottun.dart';
import '../Componants/custom_description_textfield.dart';
import '../Componants/custom_dropdown.dart';
import '../Componants/custom_textField.dart';
import '../Componants/session_manager.dart';
import '../Helper/Api.helper.dart';
import '../Helper/helper.dart';
import '../Helper/theme_colors.dart';
import '../LocalDatabase/Db/dp_helper.dart';
import '../LocalDatabase/modals/connections.dart';
import '../Modal/show_connection_folder_modal.dart';
import '../Widget/custom_top_container.dart';
import '../Widget/edit_creat_connection_widget.dart';
import '../services/notification_service.dart';

class AddProspectScreen extends StatefulWidget {
  final ShowConnectionFolderModalData showConnectionFolderModalData;

  const AddProspectScreen(
      {super.key, required this.showConnectionFolderModalData});

  @override
  State<AddProspectScreen> createState() => _AddProspectScreenState();
}

class _AddProspectScreenState extends State<AddProspectScreen> {
  bool isSubmit = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String category = 'Select Type';
  String occupation = "Select Profession";
  String listType = "Select ListType";
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
        "name":
            '${nameController.text} (${widget.showConnectionFolderModalData.name})',
        "mobile": numberController.text,
        "occupation": occupation,
        'time': selectedtime,
        'date': selecteddate,
        'remind': dropdownValue4,
        'list_type': listType,
        "user_id": SessionManager.getUserID(),
        "connection_type_id": widget.showConnectionFolderModalData.id,
        'meeting_required': meetingRequired,
        'meeting_count': meetingRequired == 'Yes' ? '1' : '0',
      };
      print(listType);
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

      // if (isTimeGone) {
      //   Helper.toastMassage('Select future date time', Colors.red);
      //   return;
      // }

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
        "name":
            '${nameController.text} (${widget.showConnectionFolderModalData.name})',
        'mobile': numberController.text,
        'occupation': occupation,
        'list_type': listType,
        'time': selectedtime,
        'date': selecteddate,
        'remind': dropdownValue4,
        'meeting_required': meetingRequired,
        'meeting_count': meetingRequired == 'Yes' ? '1' : '0',
        'meeting_happen': '',
        'notes': descriptionController.text.trim(),
        'connection_id': widget.showConnectionFolderModalData.id,
        'title':
            '${nameController.text} (${widget.showConnectionFolderModalData.name})',
        'description': '',
        'meeting_type': 'One to One',

        'meeting_place': '',
        'birthday_parson': '',
        'place': '',
        'added_type': 'CONNECTION'
      };

      print("deememmemememe$body");

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
      'list_type': listType,

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopContainer(
                onTap: () {
                  Navigator.pop(context);
                },
                title: "Smart Leader"),
            SizedBox(height: 10.0),
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        // CustomRoundedBottun2(
                        //     widget: Icon(
                        //       Icons.clear,
                        //       color: SessionManager.getTheme() == true
                        //           ? kBlackColor
                        //           : kWhiteColor,
                        //     ),
                        //     height: 25,
                        //     width: 25,
                        //     ontap: () {
                        //       Navigator.pop(context);
                        //     })
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        hight: 50,
                        title: "Enter Name & Place",
                        controller: nameController,
                        hint: "Name & Address",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        lableName: "Name & Place",
                        hintfont: 12,
                        lablefont: 14),
                    const SizedBox(height: 8),
                    CustomTextField(
                        hight: 50,
                        title: "Enter Contact Number",
                        numberformate: 10,
                        controller: numberController,
                        hint: "Contact Number",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        lableName: "Contact Number",
                        hintfont: 12,
                        lablefont: 14),
                    const SizedBox(height: 8),
                    CustomDropDown(
                        lableName: "Profession",
                        hint: "",
                        onChange: (String? value) {
                          setState(() {
                            occupation = value!;
                          });
                        },
                        items: const [
                          "Select Profession",
                          'Private Job',
                          'Government Job',
                          'Student',
                          "Business",
                          "Other"
                        ],
                        color: occupation == "Select Profession"
                            ? klableColor
                            : SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kscafolledColor,
                        valueType: occupation),
                    const SizedBox(height: 8),
                    CustomDropDown(
                        lableName: "List Type",
                        hint: "",
                        onChange: (String? value) {
                          setState(() {
                            listType = value!;
                          });
                        },
                        items: const [
                          "Select ListType",
                          'Hot List',
                          'Warm List',
                          'Cold List',
                        ],
                        color: listType == "Select ListType"
                            ? klableColor
                            : SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kscafolledColor,
                        valueType: listType),
                    const SizedBox(height: 8),
                    CustomDescriptionTextfield(
                        focusNode: FocusNode(),
                        onchanged: (value) {},
                        boxHight: 80,
                        title: "",
                        controller: descriptionController,
                        hint: "Add note",
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
                                  : Colors.black,
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
                                if (value != null) {
                                  selecteddate =
                                      DateFormat('dd-MM-yyyy').format(value);
                                  setState(() {});
                                }
                              });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: KBoxNewColor, width: 1.2),
                                  color: SessionManager.getTheme() == true
                                      ? KBoxNewColor
                                      : kWhiteColor),
                              child: Center(
                                  child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: customtext(
                                      fontWeight: FontWeight.w500,
                                      text: selecteddate,
                                      fontsize: 14,
                                      color: selecteddate == "Select Date"
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: customtext(
                              fontWeight: FontWeight.w500,
                              text: "Time",
                              fontsize: 14,
                              color: SessionManager.getTheme() == true
                                  ? kWhiteColor
                                  : Colors.black,
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

                                notificationTime = Helper.formatTime(
                                    pickedTime.format(context));

                                print(time); // Output e.g., 7:10:00 PM
                                setState(() {
                                  selectedtime = pickedTime.format(
                                      context); // Update the UI with selected time
                                });
                              } else {
                                print("Time is not selected");
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: KBoxNewColor, width: 1.2),
                                  color: SessionManager.getTheme() == true
                                      ? KBoxNewColor
                                      : kWhiteColor),
                              child: Center(
                                  child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: customtext(
                                      fontWeight: FontWeight.w500,
                                      text: (selectedtime),
                                      fontsize: 14,
                                      color: selectedtime == "Select Time"
                                          ? Colors.black
                                          : SessionManager.getTheme() == true
                                              ? kWhiteColor
                                              : Colors.black,
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
          ],
        ),
      ),
    );
  }
}
