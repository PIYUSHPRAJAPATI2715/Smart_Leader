import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/popup_menuBar.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/ExtractClasses/short_dialog_widget.dart';
import 'package:smart_leader/ExtractClasses/tools_searchbar.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/notification_api.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/controller/task_controller.dart';
import 'package:smart_leader/LocalDatabase/modals/Task.dart';
import 'package:smart_leader/Modal/show_task_modal.dart';
import 'package:smart_leader/Widget/add_myTask_widget.dart';
import 'package:smart_leader/Widget/edit_task_widget.dart';

class AddMyTaskScreen extends StatefulWidget {
  const AddMyTaskScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddMyTaskScreen> createState() => _AddMyTaskScreenState();
}
class _AddMyTaskScreenState extends State<AddMyTaskScreen> {
  bool isSubmit = false;
  late Future<ShowTaskModal> showTask;
  List<ShowTaskModalData> showTaskList = [];
  List<ShowTaskModalData> tampList = [];
  String lastInputValue = "";
  List<ShowTaskModalData> selectedList = [];
  List<String> idList = [];

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  bool isNetwork = false;

  //final _taskController = Get.put(TaskController());
  var notifyHelper;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
  }

  void checkInternet() async {
    isNetwork = await Helper.isNetworkAvailable();

    if (isNetwork) {
      showTasks();
    } else {
      showOfflineTask();
    }
    /*
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;

        print('Is Device connected $isDeviceConnected');

        if (isDeviceConnected) {
          showTasks();
        } else {
          // _taskController.getTasks();
          showOfflineTask();
        }
      },
    );*/
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void showTasks() {
    selectedList.clear();
    idList.clear();

    setState(() {
      isSubmit = true;
    });
    ApiHelper.showTask().then((value) {
      setState(() {
        isSubmit = false;
      });
      if (value.message == "Task showing Is Successfully") {
        showTaskList = value.data!;
        tampList = showTaskList;
      }
    });
  }

  void showOfflineTask() async {
    showTaskList.clear();
    idList.clear();

    List<Task> offlineTask = [];
    List<Map<String, dynamic>> tasks = await DBHelper.getData();
    offlineTask.assignAll(tasks.map((data) => Task.fromJson(data)).toList());

    for (var task in offlineTask) {
      ShowTaskModalData showTaskModalData = ShowTaskModalData(
          id: task.id.toString(),
          userId: SessionManager.getUserID(),
          summary: task.summary,
          date: task.date,
          time: task.time,
          type: task.type,
          reminder: task.reminder,
          strtotime: '',
          path: '',
          isSelected: false,
          color: task.color);
      showTaskList.add(showTaskModalData);
    }

    setState(() {
      isSubmit = false;
    });
  }

  Color parseColor(String color) {
    String hex = color.replaceAll("#", "");
    if (hex.isEmpty) hex = "ffffff";
    if (hex.length == 3) {
      hex =
          '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
    }
    Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
    return col;
  }

  //todo: delete dialog
  void showDeleteDialog(String deleteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Delete Task",
          fontsize: 22,
          color: Theme.of(context).primaryColor,
        ),
        content: customtext(
          fontWeight: FontWeight.w400,
          text: "Are you sure delete this Activity",
          fontsize: 15,
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
                  delete(deleteId);
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

  void delete(String id) async {
    if (isNetwork) {
      Map<String, String> body = {"id": id};

      setState(() {
        isSubmit = true;
      });

      ApiHelper.deleteTask(body).then((login) {
        if (login.message == " Successfully Deleted") {
          Helper.showSnackVar("Delete Successfully", Colors.green, context);
          setState(() {
            isSubmit = false;
          });

          showTasks();
        }
      });
    } else {
      DBHelper.deleteTask(int.parse(id)).then((value) {
        if (value == 1) {
          showOfflineTask();
          Helper.showSnackVar("Delete Successfully", Colors.green, context);
        }
      });
    }
  }

  void multipledelete() async {
    String deleteid = idList.join(",");
    Map<String, String> body = {
      "id": deleteid,
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.multideleteTask(body).then((login) {
      if (login.message == " Successfully Deleted") {
        Helper.showSnackVar("Deleted Successfully", Colors.green, context);

        // Helper.showLoaderDialog(context);

        setState(() {
          isSubmit = false;
        });

        idList.clear();
        showTasks();
      }
    });
  }

  void searchTask(String value) {
    final suggestions = showTaskList.where((element) {
      final taskTitle = element.summary!.toLowerCase();
      final input = value.toLowerCase();

      return taskTitle.startsWith(input);
    }).toList();

    setState(() {
      showTaskList = suggestions;
    });

    print("djuduijhdsohoh${showTaskList.length}");
  }

  // void shortTask(String value){
  //
  //   final suggestions = showTaskList.where((element){
  //     final taskTitle = element.summary!.toLowerCase();
  //     input.sort((a, b) => a.toUpperCase().compareTo(b.toUpperCase()));
  //     // final input = value.toLowerCase();
  //
  //
  //     return taskTitle.startsWith(input);
  //   }).toList();
  //
  //
  //
  //   setState(() {
  //     showTaskList = suggestions;
  //   });
  //
  //   print("djuduijhdsohoh${showTaskList.length}");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 120,
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
                          ))),
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
          ToolsSearchBarWidget(
            onchange: (value) {
              if (lastInputValue != value) {
                lastInputValue = value;
                if (value.isEmpty) {
                  setState(() {
                    showTaskList = tampList;
                  });
                } else {
                  searchTask(value);
                }
              }
            },
            ontapIcon: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ShortDialogWidget(
                    isFrequencyVisible: true,

                    // Descending Date Sort (Newest first)
                    onDSCDateTap: () {
                      Navigator.pop(context);
                      setState(() {
                        showTaskList.sort((a, b) => b.old_date!.compareTo(a.old_date!));
                      });
                    },

                    // Ascending Date Sort (Oldest first)
                    dateOntap: () {
                      Navigator.pop(context);
                      setState(() {
                        showTaskList.sort((a, b) => a.old_date!.compareTo(b.old_date!));
                      });
                    },

                    // Frequency Sort: Daily > Weekly > Monthly
                    onFrequencyTap: () {
                      Navigator.pop(context);
                      setState(() {
                        final orderMap = {
                          'daily': 1,
                          'weekly': 2,
                          'monthly': 3,
                        };

                        showTaskList.sort((a, b) {
                          final aOrder = orderMap[a.type?.toLowerCase()] ?? 99;
                          final bOrder = orderMap[b.type?.toLowerCase()] ?? 99;
                          return aOrder.compareTo(bOrder);
                        });
                      });
                    },

                    // Z to A
                    onZtoATap: () {
                      Navigator.pop(context);
                      setState(() {
                        showTaskList.sort((a, b) => b.summary!.compareTo(a.summary!));
                      });
                    },

                    // A to Z
                    alphaOntap: () {
                      Navigator.pop(context);
                      setState(() {
                        showTaskList.sort((a, b) => a.summary!.compareTo(b.summary!));
                      });
                      Navigator.pop(context);
                    },
                  );

                },
              );
            },
          ),
          const SizedBox(height: 5),
          isSubmit == true
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  itemCount: showTaskList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return InkWell(
                      onLongPress: () {
                        bool isSelected = !showTaskList[index].isSelected;
                        ShowTaskModalData showTask = ShowTaskModalData(
                          isSelected: isSelected,
                          color: showTaskList[index].color,
                          path: showTaskList[index].path,
                          time: showTaskList[index].time,
                          id: showTaskList[index].id,
                          type: showTaskList[index].type,
                          date: showTaskList[index].date,
                          strtotime: showTaskList[index].strtotime,
                          summary: showTaskList[index].summary,
                          userId: showTaskList[index].userId,
                        );
                        int idx = showTaskList.indexWhere((element) => element.id == showTask.id);
                        showTaskList[idx].isSelected = !showTaskList[idx].isSelected;
                        setState(() {
                          if (idList.contains(showTaskList[index].id)) {
                            idList.remove(showTaskList[index].id);
                          } else {
                            idList.add(showTaskList[index].id!);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: KBoxNewColor, width: 1.2),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15),
                            color: SessionManager.getTheme() == true
                                ? kscafolledColor
                                : Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          showTaskList[index].isSelected
                                              ? Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: SessionManager.getTheme() == true
                                                    ? kWhiteColor
                                                    : kBlackColor,
                                                width: 2,
                                              ),
                                              color: kredColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.done,
                                                size: 15,
                                                color: kWhiteColor,
                                              ),
                                            ),
                                          )
                                              : Container(),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: customtext(
                                              fontWeight: FontWeight.w800,
                                              text: showTaskList[index].summary!,
                                              fontsize: 15,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    showTaskList[index].isSelected
                                        ? Container()
                                        : SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: SimplePopUp(
                                        onChanged: (value) {
                                          if (value == 1) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return EditTaskWidget(
                                                  showTaskModalData:
                                                  showTaskList[index],
                                                );
                                              },
                                            ).then((value) {
                                              setState(() {
                                                checkInternet();
                                              });
                                            });
                                          } else if (value == 3) {
                                            setState(() {
                                              showDeleteDialog(showTaskList[index].id!);
                                            });
                                          }
                                        },
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                              Divider(
                                thickness: 1.5,
                                color: Theme.of(context).primaryColor,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      customtext(
                                        fontWeight: FontWeight.w800,
                                        text: showTaskList[index].time!,
                                        fontsize: 12,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(
                                        Icons.watch_later_outlined,
                                        size: 14,
                                        color: Theme.of(context).primaryColor,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      customtext(
                                        fontWeight: FontWeight.w800,
                                        text:
                                        'Start - ${showTaskList[index].old_date ?? 'No date'}',
                                        fontsize: 12,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 5),
                                      customtext(
                                        fontWeight: FontWeight.w800,
                                        text:
                                        ' Next - ${showTaskList[index].date!}',
                                        fontsize: 12,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                  customtext(
                                    fontWeight: FontWeight.w800,
                                    text: showTaskList[index].type!,
                                    fontsize: 12,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddMyTaskWidget();
              }).then((value) {
            setState(() {
              checkInternet();
              // _taskController.getTasks();
            });
          });
        },
        child: Container(
          decoration: BoxDecoration(
              gradient:
                  SessionManager.getTheme() == true ? k2Gradient : kGradient,
              shape: BoxShape.circle),
          child: Center(
              child: Icon(
            Icons.add,
            color:
                SessionManager.getTheme() == true ? kBlackColor : kWhiteColor,
            size: 45,
          )),
        ),
      ),
    );
  }
}
class topContainer extends StatelessWidget {
  VoidCallback onTap;

  topContainer({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
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
//todo data get from api postman
//Column(
//                           children: [
//                             ListView.builder(
//                                 padding: EdgeInsets.symmetric(vertical: 0),
//                                 itemCount: showTaskList.length,
//                                 shrinkWrap: true,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 itemBuilder: (BuildContext context, index) {
//                                   // DateTime date = DateFormat.jm().parse(showTaskList[index].time.toString());
//                                   // var myTime = DateFormat("HH:mm").format(date);
//                                   // notificationServices.scheduledNotification(
//                                   //   int.parse(myTime.toString().split(":")[0]),
//                                   //   int.parse(myTime.toString().split(":")[1]),
//                                   //   showTaskList[index]
//                                   // );
//                                   return InkWell(
//                                     onLongPress: () {
//                                       bool isSelected =
//                                           !showTaskList[index].isSelected;
//                                       ShowTaskModalData showTask =
//                                           ShowTaskModalData(
//                                         isSelected: isSelected,
//                                         color: showTaskList[index].color,
//                                         path: showTaskList[index].path,
//                                         time: showTaskList[index].time,
//                                         id: showTaskList[index].id,
//                                         type: showTaskList[index].type,
//                                         date: showTaskList[index].date,
//                                         strtotime:
//                                             showTaskList[index].strtotime,
//                                         summary: showTaskList[index].summary,
//                                         userId: showTaskList[index].userId,
//                                       );
//                                       int idx = showTaskList.indexWhere(
//                                           (element) =>
//                                               element.id == showTask.id);
//                                       showTaskList[idx].isSelected =
//                                           !showTaskList[idx].isSelected;
//                                       setState(() {
//                                         if (idList
//                                             .contains(showTaskList[index].id)) {
//                                           idList.remove(showTaskList[index].id);
//                                         } else {
//                                           idList.add(showTaskList[index].id!);
//                                         }
//                                       });
//                                     },
//                                     child: Container(
//                                       margin: EdgeInsets.symmetric(vertical: 5),
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 10),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.rectangle,
//                                         borderRadius: BorderRadius.circular(8),
//                                         // color: SessionManager.getTheme() == true
//                                         //     ? kscafolledColor
//                                         //     : kyelloColor,
//                                         color: parseColor(
//                                             showTaskList[index]
//                                                 .color!)
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 10),
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                     child: Row(
//                                                       children: [
//                                                         showTaskList[index]
//                                                             .isSelected ==
//                                                             true
//                                                             ? Container(
//                                                             padding:
//                                                             EdgeInsets.all(2),
//                                                             decoration: BoxDecoration(
//                                                                 border: Border.all(
//                                                                     color: SessionManager
//                                                                         .getTheme() ==
//                                                                         true
//                                                                         ? kWhiteColor
//                                                                         : kBlackColor,
//                                                                     width: 2),
//                                                                 color: kredColor,
//                                                                 shape: BoxShape
//                                                                     .circle),
//                                                             child: Center(
//                                                                 child: Icon(
//                                                                   Icons.done,
//                                                                   size: 15,
//                                                                   color: kWhiteColor,
//                                                                 )))
//                                                             :Container(),
//                                                         SizedBox(width: 10,),
//                                                         Expanded(
//                                                           child: customtext(
//                                                   fontWeight: FontWeight.w600,
//                                                   text: showTaskList[index]
//                                                             .summary!,
//                                                   fontsize: 15,
//                                                   color: Theme.of(context)
//                                                             .primaryColor,
//                                                 ),
//                                                         ),
//                                                       ],
//                                                     )),
//                                                 showTaskList[index]
//                                                     .isSelected ==
//                                                     true
//                                                     ?Container(): SizedBox(
//                                                         width: 26,
//                                                         height: 12,
//                                                         child: SimplePopUp(
//                                                             onChanged: (value) {
//                                                               if (value == 1) {
//                                                                 showDialog(
//                                                                     context:
//                                                                         context,
//                                                                     builder:
//                                                                         (BuildContext
//                                                                             context) {
//                                                                       return EditTaskWidget(
//                                                                         showTaskModalData:
//                                                                             showTaskList[index],
//                                                                       );
//                                                                     }).then((value) {
//                                                                   setState(() {
//                                                                     showTasks();
//                                                                   });
//                                                                 });
//                                                               } else if (value ==
//                                                                   2) {
//                                                               } else if (value ==
//                                                                   3) {
//                                                                 setState(() {
//                                                                   delete(showTaskList[
//                                                                           index]
//                                                                       .id!);
//                                                                 });
//                                                               }
//                                                             },
//                                                             color: Theme.of(
//                                                                     context)
//                                                                 .primaryColor)),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 3,
//                                           ),
//                                           Divider(
//                                             thickness: 2,
//                                             color:
//                                                 Theme.of(context).primaryColor,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   customtext(
//                                                     fontWeight: FontWeight.w400,
//                                                     text: showTaskList[index]
//                                                         .time!,
//                                                     fontsize: 12,
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   Icon(
//                                                     Icons.watch_later_outlined,
//                                                     size: 14,
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   )
//                                                 ],
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   customtext(
//                                                     fontWeight: FontWeight.w400,
//                                                     text: showTaskList[index]
//                                                         .date!,
//                                                     fontsize: 12,
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   Icon(
//                                                     Icons.calendar_month,
//                                                     size: 14,
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   )
//                                                 ],
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   customtext(
//                                                     fontWeight: FontWeight.w400,
//                                                     text: showTaskList[index]
//                                                         .type!,
//                                                     fontsize: 12,
//                                                     color: Theme.of(context)
//                                                         .primaryColor,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                 ],
//                                               ),
//                                               customtext(
//                                                 fontWeight: FontWeight.w400,
//                                                 text: showTaskList[index]
//                                                     .reminder!,
//                                                 fontsize: 12,
//                                                 color: Theme.of(context)
//                                                     .primaryColor,
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                           ],
//                         )

//todo: --------------------- OFFLINE DB ----------------------------------------------------

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
class FlatCorneredBackgroundPainter extends CustomPainter {
  double radius, strokeWidth;
  Color strokeColor;

  FlatCorneredBackgroundPainter(
      {this.radius = 10, this.strokeWidth = 4, this.strokeColor = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = strokeColor;

    Path path = Path()
      ..addPolygon([
        Offset(radius, 0),
        Offset(w - radius, 0),
        Offset(w, radius),
        Offset(w, h - radius),
        Offset(w - radius, h),
        Offset(radius, h),
        Offset(0, h - radius),
        Offset(0, radius),
      ], true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
