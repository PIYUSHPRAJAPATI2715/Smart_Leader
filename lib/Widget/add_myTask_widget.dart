import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Button2.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_description_textfield.dart';
import 'package:smart_leader/Componants/custom_dropdown.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:intl/intl.dart';
import 'package:smart_leader/LocalDatabase/controller/task_controller.dart';
import 'package:smart_leader/LocalDatabase/modals/Task.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:get/get.dart';
import 'package:smart_leader/services/notification_service.dart';

class AddMyTaskWidget extends StatefulWidget {
  const AddMyTaskWidget({Key? key}) : super(key: key);

  @override
  State<AddMyTaskWidget> createState() => _AddMyTaskWidgetState();
}

class _AddMyTaskWidgetState extends State<AddMyTaskWidget> {
  final TaskController taskController = Get.put(TaskController());

  bool isSubmit = false;
  String selecteddate = 'Starting Date';
  String selectedtime = "Select Time";
  String type = 'Select Type';
  String reminderTime = "Set Reminder";

  final TextEditingController titleController = TextEditingController();

  String notificationTime = '';

  static List<Color> circleColor = [
    const Color(0xffec9c9c),
    const Color(0xffB4C6A6),
    const Color(0xffF4ABC4),
    const Color(0xffc6efdd),
    const Color(0xffb8d8ee),
    const Color(0xffeeb1b1),
    const Color(0xffafccfa),
    const Color(0xffcaf0f5),
    const Color(0xfff3deb5),
    const Color(0xfffaf8ca),
  ];

  String color = "ffec9c9c";

  void addTask() async {
    if (titleController.text.isEmpty) {
      Helper.toastMassage("Please Enter Title", kredColor);
      return;
    }
    if (type == "Select Type") {
      Helper.toastMassage("Please Select Type", kredColor);
      return;
    }
    if (selecteddate == "Select Date") {
      Helper.toastMassage(
        "Please Select Date",
        kredColor,
      );
      return;
    }
    if (selectedtime == "Select Time") {
      Helper.toastMassage(
        "Please Select Time",
        kredColor,
      );
      return;
    }
    if (reminderTime == "Set Reminder") {
      Helper.toastMassage(
        'Please Select Reminder',
        Colors.red,
      );
      return;
    }
    Map<String, String> body = {
      'summary': titleController.text,
      "date": selecteddate,
      "time": selectedtime,
      "user_id": SessionManager.getUserID(),
      "color": color,
      "type": type,
      "reminder": reminderTime
    };

    bool isNetwork = await Helper.isNetworkAvailable();
    if (isNetwork) {
      ApiHelper.addTask(body).then((login) {
        setState(() {
          isSubmit = false;
        });

        if (login.message == 'Task Add Successfully ') {
          _addTaskToDb();
        } else {
          Helper.toastMassage(
            'Error',
            Colors.red,
          );
        }
      });
    } else {
      _addTaskToDb();
    }
  }

  void selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.blueGrey.shade100, // Change background color
            colorScheme: ColorScheme.light(
              primary: Color(0xffA16E4B).withOpacity(0.5), // Change header color
              onPrimary: Colors.black, // Change header text color
              surface: Colors.white, // Change surface color
              onSurface: Colors.black, // Change OK/CANCEL text color
            ),
            timePickerTheme: TimePickerThemeData(
              dayPeriodColor:Color(0xffA16E4B).withOpacity(0.5), // Change AM/PM background color
              dayPeriodTextColor: Colors.black, // Change AM/PM text color
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // OK and CANCEL button text color
              ),
            ),
          ),
          child: child!,
        );
      },
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

      notificationTime = Helper.formatTime(pickedTime.format(context));

      print('Noti ${pickedTime.hour}'); // Output 7:10:00 PM
      setState(() {
        selectedtime = pickedTime.format(context); // Set the value of text field.
      });
    } else {
      print("Time is not selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
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
                            text: "Add Activity",
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
                CustomDescriptionTextfield(
                    focusNode: FocusNode(),
                    onchanged: (value) {},
                    boxHight: 80,
                    title: "",
                    controller: titleController,
                    hint: "Add activity details . . .",
                    inputAction: TextInputAction.newline,
                    inputType: TextInputType.multiline,
                    lableName: "Add activity details",
                    hintfont: 14,
                    lablefont: 14),
                // CustomTextField(
                //     hight: 50,
                //     title: "Enter Title",
                //     controller: titleController,
                //     hint: "Enter Title",
                //     inputAction: TextInputAction.next,
                //     inputType: TextInputType.text,
                //     lableName: "Title",
                //     hintfont: 12,
                //     lablefont: 14),
                const SizedBox(height: 8),
                CustomDropDown(
                    lableName: "Type",
                    hint: "",
                    onChange: (String? value) {
                      setState(() {
                        type = value!;
                      });
                    },
                    items: <String>[
                      "Select Type",
                      'Daily',
                      'Weekly',
                      'Monthly',
                    ],
                    color: type == "Select Type"
                        ? Colors.black
                        : SessionManager.getTheme() == true
                            ? kWhiteColor
                            : Colors.black,
                    valueType: type),
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
                        text: "Starting Date",
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
                                  primary:KBoxNewColor, // Header background color
                                  onPrimary: Colors.white, // Header text color
                                  onSurface: Colors.black, // Body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: KBoxNewColor, // Button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        ).then((value) {
                          if (value != null) {
                            selecteddate = DateFormat('dd-MM-yyyy').format(value);
                            setState(() {});
                          }
                        });

                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                            Border.all(color: KBoxNewColor, width: 1.2),
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
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () async {
                        selectTime();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: KBoxNewColor, width: 1.2),
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
                  ],
                ),
                const SizedBox(height: 8),
                CustomDropDown(
                    lableName: "Remind Me",

                    hint: "",
                    onChange: (String? value) {
                      setState(() {
                        reminderTime = value!;
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
                    color: reminderTime == "Set Reminder"
                        ? kscafolledColor
                        : SessionManager.getTheme() == true
                            ? kWhiteColor
                            :Colors.black ,
                    valueType: reminderTime),
                const SizedBox(height: 8),
                Visibility(
                  visible: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Color",
                            fontsize: 14,
                            color: SessionManager.getTheme() == true
                                ? kWhiteColor
                                : Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: List.generate(
                                circleColor.length,
                                (index) => InkWell(
                                      onTap: () {
                                        data.selectedColorOneContainer(index);
                                        String colorString = circleColor[index]
                                            .toString(); // Color(0x12345678)
                                        color = colorString
                                            .split('(0x')[1]
                                            .split(')')[0];
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        margin: const EdgeInsets.only(left: 15),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: circleColor[index]),
                                        child: Center(
                                            child: Icon(
                                          Icons.check,
                                          size: 15,
                                          color: data.selectedColorContainer ==
                                                  index
                                              ? Colors.white
                                              : Colors.transparent,
                                        )),
                                      ),
                                    ))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                isSubmit == true
                    ? const Center(child: CircularProgressIndicator())
                    : custom_Button(
                        onTap: () {
                          setState(() {
                            addTask();
                          });
                          // String dateTime =
                          //     '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';

                          //  print('DATE ${dateTime}');
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

  void _addTaskToDb() async {
    int value = await taskController.addTask(
        task: Task(
      summary: titleController.text,
      date: selecteddate,
      time: selectedtime,
      color: color,
      type: type,
      reminder: reminderTime,
      isCompleted: 0,
    ));

    //'2023-01-02 10:10:41'
    String dateTime =
        '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';

    NotificationService().showNotification(value, 'SmartLeader - Task',
        titleController.text, reminderTime, dateTime, Helper.kTaskScreen);

    titleController.clear();
    Navigator.pop(context, true);
    Helper.showSnackVar('Successfully Added', Colors.green, context);
  }
}
// Obx(() {
//                         return ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: _taskController.taskList.length,
//                             itemBuilder: (_, index) {
//                               print(_taskController.taskList.length);
//                               return Container(
//                                 margin: EdgeInsets.symmetric(vertical: 5),
//                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.rectangle,
//                                     borderRadius: BorderRadius.circular(8),
//                                     // color: SessionManager.getTheme() == true
//                                     //     ? kscafolledColor
//                                     //     : kyelloColor,
//                                     color: parseColor(_taskController
//                                         .taskList[index].color!)),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Expanded(
//                                               child: Row(
//                                             children: [
//                                               showTaskList[index].isSelected ==
//                                                       true
//                                                   ? Container(
//                                                       padding:
//                                                           EdgeInsets.all(2),
//                                                       decoration: BoxDecoration(
//                                                           border: Border.all(
//                                                               color: SessionManager
//                                                                           .getTheme() ==
//                                                                       true
//                                                                   ? kWhiteColor
//                                                                   : kBlackColor,
//                                                               width: 2),
//                                                           color: kredColor,
//                                                           shape:
//                                                               BoxShape.circle),
//                                                       child: Center(
//                                                           child: Icon(
//                                                         Icons.done,
//                                                         size: 15,
//                                                         color: kWhiteColor,
//                                                       )))
//                                                   : Container(),
//                                               SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Expanded(
//                                                 child: customtext(
//                                                   fontWeight: FontWeight.w600,
//                                                   text: _taskController
//                                                       .taskList[index].summary!,
//                                                   fontsize: 15,
//                                                   color: Theme.of(context)
//                                                       .primaryColor,
//                                                 ),
//                                               ),
//                                             ],
//                                           )),
//                                           showTaskList[index].isSelected == true
//                                               ? Container()
//                                               : SizedBox(
//                                                   width: 26,
//                                                   height: 12,
//                                                   child: SimplePopUp(
//                                                       onChanged: (value) {
//                                                         if (value == 1) {
//                                                           showDialog(
//                                                               context: context,
//                                                               builder:
//                                                                   (BuildContext
//                                                                       context) {
//                                                                 return EditTaskWidget(
//                                                                   showTaskModalData:
//                                                                       showTaskList[
//                                                                           index],
//                                                                 );
//                                                               }).then((value) {
//                                                             setState(() {
//                                                               showTasks();
//                                                             });
//                                                           });
//                                                         } else if (value == 2) {
//                                                         } else if (value == 3) {
//                                                           setState(() {
//                                                             delete(showTaskList[
//                                                                     index]
//                                                                 .id!);
//                                                           });
//                                                         }
//                                                       },
//                                                       color: Theme.of(context)
//                                                           .primaryColor)),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 3,
//                                     ),
//                                     Divider(
//                                       thickness: 2,
//                                       color: Theme.of(context).primaryColor,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             customtext(
//                                               fontWeight: FontWeight.w400,
//                                               text: _taskController
//                                                   .taskList[index].time!,
//                                               fontsize: 12,
//                                               color: Theme.of(context)
//                                                   .primaryColor,
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                             Icon(
//                                               Icons.watch_later_outlined,
//                                               size: 14,
//                                               color: Theme.of(context)
//                                                   .primaryColor,
//                                             )
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             customtext(
//                                               fontWeight: FontWeight.w400,
//                                               text: _taskController
//                                                   .taskList[index].date!,
//                                               fontsize: 12,
//                                               color: Theme.of(context)
//                                                   .primaryColor,
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                             Icon(
//                                               Icons.calendar_month,
//                                               size: 14,
//                                               color: Theme.of(context)
//                                                   .primaryColor,
//                                             )
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             customtext(
//                                               fontWeight: FontWeight.w400,
//                                               text: _taskController
//                                                   .taskList[index].type!,
//                                               fontsize: 12,
//                                               color: Theme.of(context)
//                                                   .primaryColor,
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                           ],
//                                         ),
//                                         customtext(
//                                           fontWeight: FontWeight.w400,
//                                           text: _taskController
//                                               .taskList[index].reminder!,
//                                           fontsize: 12,
//                                           color: Theme.of(context).primaryColor,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             });
//                       }),
