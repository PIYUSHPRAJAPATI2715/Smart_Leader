import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:smart_leader/LocalDatabase/modals/Task.dart';
import 'package:smart_leader/Modal/show_task_modal.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:intl/intl.dart';
import 'package:smart_leader/services/notification_service.dart';

class EditTaskWidget extends StatefulWidget {
  final ShowTaskModalData showTaskModalData;

  const EditTaskWidget({Key? key, required this.showTaskModalData})
      : super(key: key);

  @override
  State<EditTaskWidget> createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  bool isSubmit = false;
  String selecteddate = 'Select Day of Week';
  String selectedtime = "Select Time";
  String type = 'Select Type';
  String dropdownValue4 = "Set Reminder";
  final TextEditingController titleController = TextEditingController();
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

  String notificationTime = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.showTaskModalData.summary!;
    type = widget.showTaskModalData.type!;
    selecteddate = widget.showTaskModalData.date!;
    selectedtime = widget.showTaskModalData.time!;
    color = widget.showTaskModalData.color!;
    dropdownValue4 = widget.showTaskModalData.reminder!;
  }

  void editTask() async {
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
    if (dropdownValue4 == "Set Reminder") {
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
      "id": widget.showTaskModalData.id!,
      "color": color,
      "type": type,
      "reminder": dropdownValue4
    };

    bool isNetwork = await Helper.isNetworkAvailable();

    if (isNetwork) {
      ApiHelper.editTask(body).then((login) {
        setState(() {
          isSubmit = false;
        });

        if (login.message == 'Update Task Successfully') {
          _updateTaskToDb();
        } else {
          Helper.toastMassage(
            'Error',
            Colors.red,
          );
        }
      });
    } else {
      _updateTaskToDb();
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
        padding: EdgeInsets.only(bottom: 5),
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
                            text: "Edit Activity",
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
                SizedBox(
                  height: 15,
                ),
                CustomDescriptionTextfield(
                    focusNode: FocusNode(),
                    onchanged: (value) {},
                    boxHight: 100,
                    title: "",
                    controller: titleController,
                    hint: "Write Something . . .",
                    inputAction: TextInputAction.newline,
                    inputType: TextInputType.multiline,
                    lableName: "Title",
                    hintfont: 12,
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
                SizedBox(
                  height: 8,
                ),
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
                        ? klableColor
                        : SessionManager.getTheme() == true
                            ? kWhiteColor
                            : kscafolledColor,
                    valueType: type),
                SizedBox(
                  height: 8,
                ),
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
                    SizedBox(
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
                          print(value);
                          selecteddate =
                              DateFormat('yyyy-MM-dd').format(value!);
                          setState(() {});
                          print(selecteddate);
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: InkWell(
                                child: customtext(
                                  fontWeight: FontWeight.w700,
                                  text: (selecteddate),
                                  fontsize: 12,
                                  color: selecteddate == "Select Day of Week"
                                      ? klableColor
                                      : SessionManager.getTheme() == true
                                          ? kWhiteColor
                                          : kscafolledColor,
                                ),
                              ),
                            )
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                    SizedBox(
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
                          /*
                          if (pickedTime.hour == 0) {
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
                SizedBox(
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
                SizedBox(
                  height: 8,
                ),
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
                                : kbuttonColor),
                      ),
                      SizedBox(
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
                                        margin: EdgeInsets.only(left: 15),
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
                SizedBox(
                  height: 30,
                ),
                isSubmit == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : custom_Button(
                        onTap: () {
                          setState(() {
                            editTask();
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
    );
  }

  void _updateTaskToDb() async {
    Task task = Task(
      id: int.parse(widget.showTaskModalData.id!),
      summary: titleController.text,
      date: selecteddate,
      time: selectedtime,
      color: color,
      type: type,
      reminder: dropdownValue4,
      isCompleted: 0,
    );

    DBHelper.updateTask(task).then((value) {
      String dateTime =
          '$selecteddate ${notificationTime.replaceAll('AM', '').replaceAll('PM', '').trim()}';

      NotificationService().showNotification(value, 'SmartLeader - Task',
          titleController.text, dropdownValue4, dateTime, Helper.kTaskScreen);
      Navigator.pop(context, true);
      Helper.showSnackVar('Successfully Updated', Colors.green, context);
    });
  }
}
