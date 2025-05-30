import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/icon_button.dart';
import 'package:smart_leader/Componants/popup_menuBar.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/connections.dart';
import 'package:smart_leader/Modal/new_event.dart';
import 'package:smart_leader/Modal/show_connection_folder_modal.dart';
import 'package:smart_leader/Modal/show_connection_modal.dart';
import 'package:smart_leader/Screen/add_prospect_screen.dart';
import 'package:smart_leader/Screen/view_connections_screen.dart';
import 'package:smart_leader/Widget/add_new_connection_widget.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:smart_leader/Widget/edit_creat_connection_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CreatConnectionScreen extends StatefulWidget {
  final ShowConnectionFolderModalData showConnectionFolderModalData;

  const CreatConnectionScreen(
      {Key? key, required this.showConnectionFolderModalData})
      : super(key: key);

  @override
  State<CreatConnectionScreen> createState() => _CreatConnectionScreenState();
}

class _CreatConnectionScreenState extends State<CreatConnectionScreen> {
  late Future<ShowConnectionModal> showConnection;

  bool isSubmit = false;
  bool isNetwork = false;

  bool isConnection = false;

  // List<ShowConnectionModalData> _showConnectionList = [];
  List<NewEventData> _showConnectionList = [];
  List<NewEventData> _filterConnectionList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkNetwork();
    getNewEvent();
  }

  /*
  void checkNetwork() async {
    isNetwork = await Helper.isNetworkAvailable();
    if (isNetwork) {
      setState(() {
        isConnection = true;
      });

      Map<String, String> body = {
        "connection_type_id": widget.showConnectionFolderModalData.id,
        "user_id": SessionManager.getUserID(),
      };

      ApiHelper.showConnection(body).then((value) {
        setState(() {
          isConnection = false;
        });
        _showConnectionList = value.data!;

        //todo:
        filter();
      });
    } else {
      getOfflineConnection();
    }
  }

  void getOfflineConnection() async {
    _showConnectionList.clear();

    List<Connections> connections = [];
    List<Map<String, dynamic>> notes =
        await DBHelper.getConnections(widget.showConnectionFolderModalData.id!);
    connections
        .assignAll(notes.map((data) => Connections.fromJson(data)).toList());

    for (var connect in connections) {
      ShowConnectionModalData connectionModalData = ShowConnectionModalData(
          id: connect.id!.toString(),
          occupation: connect.occupation,
          remind: connect.remind,
          name: connect.name,
          userId: SessionManager.getUserID(),
          connectionTypeId: connect.connectionId!,
          time: connect.time,
          date: connect.date,
          path: '',
          mobile: connect.number);

      _showConnectionList.add(connectionModalData);
    }
    setState(() {
      isConnection = false;
    });
  }
  */

  void getNewEvent() {
    setState(() {
      isConnection = true;
    });
    Map<String, String> body = {
      'user_id': SessionManager.getUserID(),
      'connection_id': widget.showConnectionFolderModalData.id,
    };
    ApiHelper.getNewEvent(body).then((value) {
      setState(() {
        isConnection = false;
      });
      _showConnectionList = value.result ?? [];
      _filterConnectionList = value.result ?? [];
      filter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 102,
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
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: CupertinoSearchTextField(
              backgroundColor: Colors.grey.shade50,
              onChanged: (value) {
                setState(() {
                  _filterConnectionList = _showConnectionList.where((element) {
                    final name = element.name!.toLowerCase().contains(value);
                    final phone = element.mobile!.toLowerCase().contains(value);
                    final occupation =
                        element.occupation!.toLowerCase().contains(value);
                    return name || phone || occupation;
                  }).toList();
                });
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: isConnection
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 7.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 2.0)),
                      itemCount: _filterConnectionList.length,
                      itemBuilder: (context, index) {
                        String passDateTime = "";
                        if (_filterConnectionList[index]
                            .date!
                            .trim()
                            .isNotEmpty) {
                          passDateTime =
                              '${_filterConnectionList[index].date} ${_filterConnectionList[index].time}';
                        }

                        String meetingHappen =
                            _filterConnectionList[index].meetingHappen == null
                                ? 'Yes'
                                : _filterConnectionList[index].meetingHappen!;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewConnectionScreen(
                                  showConnectionModalData:
                                      _filterConnectionList[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: passDateTime.isEmpty
                                ? const Color(0xffF2F4F6)
                                : getCardColor(
                                    passDateTime,
                                    _filterConnectionList[index].meetingCount!,
                                    meetingHappen,
                                    _filterConnectionList[index]
                                            .meetingRequired ??
                                        'No',
                                    _filterConnectionList[index].meetingCount!,
                                  ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: getCardColor(
                                      passDateTime,
                                      _filterConnectionList[index]
                                          .meetingCount!,
                                      meetingHappen,
                                      _filterConnectionList[index]
                                              .meetingRequired! ??
                                          'No',
                                      _filterConnectionList[index].list_type! ??
                                          'null',
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customtext(
                                        fontWeight: FontWeight.w800,
                                        text:
                                            _filterConnectionList[index].name!,
                                        fontsize: 16,
                                        maxLine: 2,
                                        color: Colors.black87,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          customtext(
                                            fontWeight: FontWeight.w500,
                                            text: _filterConnectionList[index]
                                                .occupation!,
                                            fontsize: 12,
                                            color: Colors.black87,
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(height: 8),
                                      // customtext(
                                      //   fontWeight: FontWeight.w300,
                                      //   text: _filterConnectionList[index]
                                      //       .mobile!,
                                      //   fontsize: 12,
                                      //   color: Colors.black87,
                                      // ),
                                      const SizedBox(height: 8),
                                      customtext(
                                          fontWeight: FontWeight.bold,
                                          text: _filterConnectionList[index].list_type!,
                                          fontsize: 12.0),

                                      const SizedBox(height: 8),
                                      Visibility(
                                        visible: _filterConnectionList[index]
                                                    .meetingCount ==
                                                '0'
                                            ? false
                                            : true,
                                        child: customtext(
                                            fontWeight: FontWeight.bold,
                                            text:
                                                'Meeting  #${_filterConnectionList[index].meetingCount!}',
                                            fontsize: 12.0),
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: customtext(
                                          fontWeight: FontWeight.bold,
                                          text:
                                              'Meeting Date : ${_filterConnectionList[index].date??""}',
                                          fontsize: 11,
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 6.0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 3.0),
                                            decoration: BoxDecoration(
                                              color: kblueDarkColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: const customtext(
                                              fontWeight: FontWeight.w600,
                                              text: 'Review',
                                              fontsize: 12.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              await launchUrl(Uri.parse(
                                                  'tel:${_filterConnectionList[index].mobile!}'));
                                            },
                                            child: Center(
                                              child: Expanded(
                                                child: const Icon(
                                                  Icons.wifi_calling_3_outlined,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                                // child: CustomIconButton(
                                                //   onTap: () async {
                                                //     await launchUrl(Uri.parse(
                                                //         'tel:${_filterConnectionList[index].mobile!}'));
                                                //   },
                                                //   title: "Call",
                                                //   verticleHightpad: 3,
                                                //   horizontalWidthpad: 8,
                                                //   hight: 30,
                                                //   width: 80,
                                                //   fontSize: 12,
                                                //   widget:
                                                // ),
                                              ),
                                            ),
                                          ),

                                          // InkWell(
                                          //   onTap: () async {
                                          //     showDeleteDialog(
                                          //         _filterConnectionList[index]
                                          //             .id!);
                                          //   },
                                          //   child: Center(
                                          //     child: Expanded(
                                          //       child: const Icon(
                                          //         Icons.delete,
                                          //         size: 20,
                                          //         color: Colors.black,
                                          //       ),
                                          //       // child: CustomIconButton(
                                          //       //   onTap: () async {
                                          //       //     await launchUrl(Uri.parse(
                                          //       //         'tel:${_filterConnectionList[index].mobile!}'));
                                          //       //   },
                                          //       //   title: "Call",
                                          //       //   verticleHightpad: 3,
                                          //       //   horizontalWidthpad: 8,
                                          //       //   hight: 30,
                                          //       //   width: 80,
                                          //       //   fontSize: 12,
                                          //       //   widget:
                                          //       // ),
                                          //     ),
                                          //   ),
                                          // ),
                                          // SizedBox(width: 10),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddProspectScreen(
                        showConnectionFolderModalData:
                            widget.showConnectionFolderModalData,
                      ))).then((value) {
            setState(() {
              getNewEvent();
            });
          });
          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return AddNewConnectionWidget(
          //         showConnectionFolderModalData:
          //             widget.showConnectionFolderModalData,
          //       );
          //     }).then(
          //   (value) {
          //     setState(() {
          //       // checkNetwork();
          //       getNewEvent();
          //     });
          //   },
          // );
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

  //todo: delete dialog
  void showDeleteDialog(String deleteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Delete Connections",
          fontsize: 22,
          color: Theme.of(context).primaryColor,
        ),
        // content: customtext(
        //   fontWeight: FontWeight.w400,
        //   text: "Do you want to delete this connection",
        //   fontsize: 15,
        //   color: Theme.of(context).primaryColor,
        // ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const customtext(
                    fontWeight: FontWeight.w600, text: 'No', fontsize: 12),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  delete(deleteId);
                },
                child: const customtext(
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
    isNetwork = await Helper.isNetworkAvailable();

    if (isNetwork) {
      Map<String, String> body = {"id": id};

      setState(() {
        isSubmit = true;
      });

      ApiHelper.deleteNewEvent(body).then((login) {
        if (login.status == "true") {
          Helper.showSnackVar("Successfully Deleted", Colors.green, context);

          // Helper.showLoaderDialog(context);

          setState(() {
            isSubmit = false;
          });
          // Map<String, String> body = {
          //   "connection_type_id": widget.showConnectionFolderModalData.id,
          //   "user_id": SessionManager.getUserID(),
          // };
          // showConnection = ApiHelper.showConnection(body);

          //todo: getting data after delete
          getNewEvent();
        }
      });
    } else {
      await DBHelper.deleteConnections(int.parse(id));
      getNewEvent();
    }
  }

  void meetingHappened(String value) {
    final filtersList = _filterConnectionList.where((element) {
      final taskTitle = element.meetingHappen!.toLowerCase();
      final input = value.toLowerCase();

      return taskTitle.startsWith(input);
    }).toList();

    filtersList.forEach((element) {
      print('Element ${element.name}');
    });
    setState(() {
      _filterConnectionList = filtersList;
    });
  }

  void completedMeeting(String value) {
    final filtersList = _filterConnectionList.where((element) {
      final taskTitle = element.meetingCount!.toLowerCase();
      final input = value.toLowerCase();
      return taskTitle.startsWith(input);
    }).toList();

    filtersList.forEach((element) {
      print('Element ${element.name}');
    });

    setState(() {
      _filterConnectionList = filtersList;
    });
  }

  Widget checkEdit(NewEventData showConnectionModal) {
    print(
        'MEETING HAPP ${showConnectionModal.meetingRequired == 'TBD' && showConnectionModal.meetingHappen!.isEmpty}');

    if (showConnectionModal.date!.trim().isNotEmpty) {
      String passDateTime =
          '${showConnectionModal.date} ${showConnectionModal.time}';
      if (!Helper.checkPassedDateTime(passDateTime)) {
        return EditCreateConnectionNoWidget(
          showConnectionModalData: showConnectionModal,
          connectionTypeId: widget.showConnectionFolderModalData.id!,
        );
      }
    }

    if (showConnectionModal.meetingRequired == 'TBD' &&
        showConnectionModal.meetingHappen!.isEmpty) {
      return EditCreateConnectionNoWidget(
        showConnectionModalData: showConnectionModal,
        connectionTypeId: widget.showConnectionFolderModalData.id!,
      );
    }

    if (showConnectionModal.meetingRequired == 'TBD' &&
        showConnectionModal.meetingHappen!.isNotEmpty) {
      return EditCreatConnectionWidget(
        showConnectionModalData: showConnectionModal,
        connectionTypeId: widget.showConnectionFolderModalData.id!,
      );
    }

    return EditCreatConnectionWidget(
        showConnectionModalData: showConnectionModal,
        connectionTypeId: widget.showConnectionFolderModalData.id!);
//_showConnectionList[
//                                                                             index]
//                                                                         .meetingRequired ==
//                                                                     'No'
//                                                                 ? EditCreateConnectionNoWidget(
//                                                                     showConnectionModalData:
//                                                                         _showConnectionList[
//                                                                             index],
//                                                                     connectionTypeId:
//                                                                         widget
//                                                                             .showConnectionFolderModalData
//                                                                             .id!,
//                                                                   )
//                                                                 : EditCreatConnectionWidget(
//                                                                     showConnectionModalData:
//                                                                         _showConnectionList[
//                                                                             index],
//                                                                     connectionTypeId:
//                                                                         widget
//                                                                             .showConnectionFolderModalData
//                                                                             .id!,
//                                                                   );
  }

  //todo: meetingCount == 3 =>red  meetingHappened = "no" => red / dateTime pass => yellow
  // final List<ShowConnectionModalData> _filteredList = [];
  final List<NewEventData> _filteredList = [];

  void filter() {
    _filteredList.clear();
    for (var element in _filterConnectionList) {
      String meetingHappened =
          element.meetingRequired == null ? '' : element.meetingRequired!;
      if (meetingHappened == 'No') {
        _filteredList.add(element);
      }
    }

    for (var element3 in _filterConnectionList) {
      String date = element3.date!.trim().isEmpty ? "" : element3.date!;
      String meetingHappened =
          element3.meetingRequired == null ? '' : element3.meetingRequired!;
      //  String meetingCount = element2.meetingCount!;
      bool isTimeGone = false;
      if (date.isNotEmpty) {
        String passDateTime = '${element3.date} ${element3.time}';
        isTimeGone = Helper.checkPassedDateTime(passDateTime);
      }

      if (meetingHappened != 'No' && isTimeGone == false) {
        _filteredList.add(element3);
      }
    }

    for (var element2 in _filterConnectionList) {
      String date = element2.date!.trim().isEmpty ? "" : element2.date!;
      String meetingHappened =
          element2.meetingRequired == null ? '' : element2.meetingRequired!;
      //  String meetingCount = element2.meetingCount!;

      if (meetingHappened != 'No') {
        if (date.isNotEmpty) {
          String passDateTime = '${element2.date} ${element2.time}';
          bool isTimeGone = Helper.checkPassedDateTime(passDateTime);
          if (isTimeGone) {
            _filteredList.add(element2);
          } else {
            //_filteredList.add(element2);
          }
        } else {
          //  _filteredList.add(element2);
        }
      }
    }

    setState(() {
      _filterConnectionList =
          List.from(_filteredList.reversed); //_filteredList.reversed!;
    });
  }

  Color getCardColor(String passedTime, String meetingCount,
      String meetingHappend, String meetingReq, String list_type) {
    // if (meetingCount == '3') {
    //   return Colors.red.shade100;
    // }
    print('passDateTime: $passedTime');
    if (list_type == 'Hot List') {
      return const Color(0xffFF7F27);
    }

    if (list_type == 'Warm List') {
      return const Color(0xffFFFB97);
    }
    if (list_type == 'Cold List') {
      return const Color(0xff8FFCFF);
    }

    if (Helper.checkPassedDateTime(passedTime)) {
      return const Color(0xffA8F3AE);
    }

    if (meetingReq.toLowerCase() == 'yes' && meetingHappend == 'No') {
      return const Color(0xffF2F4F6);
    }

    // if (meetingHappend == 'No') {
    //   return Colors.red.shade100;
    // }

    if (meetingReq == 'No') {
      return Colors.red.shade100;
    }

    if (SessionManager.getTheme()) {
      if (Helper.checkPassedDateTime(passedTime)) {
        return Colors.amber;
      }
      return Colors.grey;
    }

    return const Color(0xffF2F4F6);
    //Helper.checkPassedDateTime(
    //passDateTime)
  }

  bool isEditHide(
      String meetingCount, String meetingHappened, String meetingReq) {
    // if (meetingCount == '3') {
    //   return false;
    // }

    if (meetingReq.toLowerCase() == 'no') {
      return false;
    }
    if (meetingReq.toLowerCase() == 'yes' && meetingHappened == 'No') {
      return true;
    }

    // if (meetingHappened == 'No') {
    //   return false;
    // }

    return true;
  }
}

//FutureBuilder<ShowConnectionModal>(
//                       future: showConnection,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 7),
//                               child: GridView.builder(
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 2,
//                                         crossAxisSpacing: 7.0,
//                                         mainAxisSpacing: 10.0,
//                                         childAspectRatio: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                             (MediaQuery.of(context)
//                                                     .size
//                                                     .height /
//                                                 2.3)),
//                                 itemCount: snapshot.data!.data!.length,
//                                 itemBuilder: (context, index) {
//                                   return Card(
//                                     color: SessionManager.getTheme() == true
//                                         ? kscafolledColor
//                                         : Color(0xffF2F4F6),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Center(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             color: SessionManager.getTheme() ==
//                                                     true
//                                                 ? kscafolledColor
//                                                 : Color(0xffF2F4F6)),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Align(
//                                                 alignment: Alignment.topRight,
//                                                 child: SizedBox(
//                                                     width: 20,
//                                                     height: 12,
//                                                     child: SimplePopUp(
//                                                         onChanged: (value) {
//                                                           if (value == 1) {
//                                                             showDialog(
//                                                                     context:
//                                                                         context,
//                                                                     builder:
//                                                                         (BuildContext
//                                                                             context) {
//                                                                       return EditCreatConnectionWidget(
//                                                                         showConnectionModalData: snapshot
//                                                                             .data!
//                                                                             .data![index],
//                                                                       );
//                                                                     })
//                                                                 .then(
//                                                                     (value) => {
//                                                                           setState(
//                                                                               () {
//                                                                             Map<String, String>
//                                                                                 body =
//                                                                                 {
//                                                                               "connection_type_id": widget.showConnectionFolderModalData.id,
//                                                                               "user_id": SessionManager.getUserID(),
//                                                                             };
//                                                                             showConnection =
//                                                                                 ApiHelper.showConnection(body);
//                                                                           })
//                                                                         });
//                                                           } else if (value ==
//                                                               2) {
//                                                           } else if (value ==
//                                                               3) {
//                                                             setState(() {
//                                                               delete(snapshot
//                                                                   .data!
//                                                                   .data![index]
//                                                                   .id!);
//                                                             });
//                                                           }
//                                                         },
//                                                         color: Theme.of(context)
//                                                             .primaryColor)),
//                                               ),
//                                               const SizedBox(height: 2),
//                                               customtext(
//                                                 fontWeight: FontWeight.w600,
//                                                 text: snapshot
//                                                     .data!.data![index].name!,
//                                                 fontsize: 16,
//                                                 color: Theme.of(context)
//                                                     .primaryColor,
//                                               ),
//                                               const SizedBox(height: 8),
//                                               customtext(
//                                                 fontWeight: FontWeight.w500,
//                                                 text: snapshot.data!
//                                                     .data![index].occupation!,
//                                                 fontsize: 12,
//                                                 color: Theme.of(context)
//                                                     .primaryColor,
//                                               ),
//                                               const SizedBox(height: 8),
//                                               customtext(
//                                                 fontWeight: FontWeight.w300,
//                                                 text: snapshot
//                                                     .data!.data![index].mobile!,
//                                                 fontsize: 12,
//                                                 color: Theme.of(context)
//                                                     .primaryColor,
//                                               ),
//                                               const SizedBox(height: 8),
//                                               customtext(
//                                                   fontWeight: FontWeight.w600,
//                                                   text:
//                                                       'Meeting  #${snapshot.data!.data![index].id!}',
//                                                   fontsize: 12.0),
//                                               const SizedBox(height: 8),
//                                               // customtext(fontWeight: FontWeight.w300,
//                                               //   alignment:TextAlign.start,
//                                               //   text: snapshot.data!.data![index].email!,
//                                               //   fontsize: 10,
//                                               //   color: Theme
//                                               //       .of(context)
//                                               //       .primaryColor,),
//                                               // SizedBox(height: 5,),
//                                               // customtext(
//                                               //   fontWeight: FontWeight.w300, text: snapshot.data!.data![index].category!, fontsize: 10,
//                                               //   color: Theme
//                                               //       .of(context)
//                                               //       .primaryColor,),
//                                               // SizedBox(height: 5,),
//                                               // customtext(fontWeight: FontWeight.w400,
//                                               //   text: snapshot.data!.data![index].description!,
//                                               //   fontsize: 10,
//                                               //   color: Theme
//                                               //       .of(context)
//                                               //       .primaryColor,),
//                                               // SizedBox(height:9,),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   CustomIconButton(
//                                                     onTap: () async {
//                                                       await launchUrl(Uri.parse(
//                                                           'tel:${snapshot.data!.data![index].mobile!}'));
//                                                     },
//                                                     title: "Call",
//                                                     verticleHightpad: 3,
//                                                     horizontalWidthpad: 8,
//                                                     hight: 30,
//                                                     width: 80,
//                                                     fontSize: 12,
//                                                     widget: Icon(
//                                                       Icons.phone,
//                                                       size: 13,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                   // SizedBox(width: 10,),
//                                                   // CustomIconButton(onTap: ()async {
//                                                   //   await launchUrl(Uri.parse('mailto:${snapshot.data!.data![index].email!}'));
//                                                   // },
//                                                   //     title: "Email",verticleHightpad: 3,horizontalWidthpad:8 ,
//                                                   //     hight: 30,
//                                                   //     width: 62,
//                                                   //     fontSize: 12,
//                                                   //     widget:Icon(Icons.mail_sharp,size:13,color: Colors.white,)
//                                                   // ),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
