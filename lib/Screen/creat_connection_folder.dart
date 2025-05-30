import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/connection_type.dart';
import 'package:smart_leader/Modal/show_connection_folder_modal.dart';
import 'package:smart_leader/Screen/creat_connection_screen.dart';
import 'package:smart_leader/Widget/add_connection_folder_widget.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class CreatConnectionFolder extends StatefulWidget {
  const CreatConnectionFolder({Key? key}) : super(key: key);

  @override
  State<CreatConnectionFolder> createState() => _CreatConnectionFolderState();
}

class _CreatConnectionFolderState extends State<CreatConnectionFolder> {
  bool isSubmit = true;
  List<ShowConnectionFolderModalData> showconnecFolderList = [];

  bool isNetwork = false;
  int totcoun=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
  }

  void checkInternet() async {
    isNetwork = await Helper.isNetworkAvailable();

    if (isNetwork) {
      showConnFolder();
    } else {
      showOfflineConnection();
    }
  }

  void showConnFolder() {

    ApiHelper.showConnectionFolder().then((value) async {

      if (value.message == "Connection Type Showing Is Successfully") {
        if (value.data!.isNotEmpty) {
          totcoun=value.totalConnections!;
          showconnecFolderList = value.data!;


          print("jasaasasaha${value.data}");

          for (var connectionType in showconnecFolderList) {
            ConnectionType connection = ConnectionType(
                name: connectionType.name!,
                connectionCount: connectionType.connectionCount.toString());
            DBHelper.insertConnectionType(connection);
          }
        }
      }
      setState(() {
        isSubmit = false;
      });
    });
  }

  void showOfflineConnection() async {
    showconnecFolderList.clear();

    List<ConnectionType> offlineConnection = [];
    List<Map<String, dynamic>> tasks = await DBHelper.getConnectionType();
    offlineConnection
        .assignAll(tasks.map((data) => ConnectionType.fromJson(data)).toList());

    for (var connection in offlineConnection) {
      // ShowTaskModalData showTaskModalData = ShowTaskModalData(
      //     id: task.id.toString(),
      //     userId: SessionManager.getUserID(),
      //     summary: task.summary,
      //     date: task.date,
      //     time: task.time,
      //     type: task.type,
      //     reminder: task.reminder,
      //     strtotime: '',
      //     path: '',
      //     isSelected: false,
      //     color: task.color);
      // showTaskList.add(showTaskModalData);

      ShowConnectionFolderModalData connectionFolder =
          ShowConnectionFolderModalData(
              id: connection.id.toString(),
              name: connection.name,
              connectionCount: int.parse(connection.connectionCount!),
              path: ' ');
      showconnecFolderList.add(connectionFolder);
    }

    setState(() {
      isSubmit = false;
    });
  }

  void delete(String id) async {
    Map<String, String> body = {"id": id};

    setState(() {
      isSubmit = true;
    });

    ApiHelper.deleteConnectFolder(body).then((login) {
      if (login.message == " Successfully Deleted") {
        Helper.showSnackVar("Delete Successfully", Colors.green, context);

        // Helper.showLoaderDialog(context);

        setState(() {
          isSubmit = false;
        });
        showConnFolder();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     refreshDetails();
      //   },
      //   child: Container(
      //     decoration: BoxDecoration(
      //         gradient:
      //         SessionManager.getTheme() == true ? k2Gradient : kGradient,
      //         shape: BoxShape.circle),
      //     child: Center(
      //         child: Icon(
      //           Icons.add,
      //           color:
      //           SessionManager.getTheme() == true ? kBlackColor : kWhiteColor,
      //           size: 45,
      //         )),
      //   ),
      // ),
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

          const SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: isSubmit == true
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: customtext(
                              fontWeight: FontWeight.w800,
                              text: "Total - ${totcoun.toString()} Prospects",
                              fontsize: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 7.0,
                                    mainAxisSpacing: 7.0,
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            1.9)),
                            itemCount: showconnecFolderList.length,
                            itemBuilder: (context, index) {
                              int position = int.parse(showconnecFolderList[index].id!);
                              return InkWell(
                                onTap: () {
                                  //  refreshDetails1(snapshot.data!.data!, snapshot.data!.data![index].id!, index);
                                  // createList(snapshot.data!.data![index].id!, index);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreatConnectionScreen(
                                                showConnectionFolderModalData:
                                                    showconnecFolderList[index],
                                              ))).then((value) {
                                    setState(() {
                                      showConnFolder();
                                    });
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: SessionManager.getTheme() == true
                                        ? kscafolledColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: 120,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          height: 80,
                                          width: double.infinity,
                                          showconnecFolderList[index]
                                              .path!,
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              title: customtext(
                                                fontWeight: FontWeight.w500,
                                                text:
                                                    showconnecFolderList[index]
                                                        .name!,
                                                fontsize: 22,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              content: customtext(
                                                fontWeight: FontWeight.w400,
                                                text:
                                                    "Are you sure delete this folder",
                                                fontsize: 15,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              actions: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        color: Colors.green,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        child: const Text("No"),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        delete(
                                                            showconnecFolderList[
                                                                    index]
                                                                .id!);
                                                        showConnFolder();
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      child: Container(
                                                        color: Colors.green,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14),
                                                        child:
                                                            const Text("Yes"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Visibility(
                                          visible: false,//position > 4 ? true : false,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                              Icons.dangerous_outlined,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          customtext(
                                              alignment: TextAlign.center,
                                              fontWeight: FontWeight.w500,
                                              text: showconnecFolderList[index]
                                                  .name!,
                                              fontsize: 16,
                                              color:
                                                  SessionManager.getTheme() ==
                                                          true
                                                      ? kWhiteColor
                                                      : Colors.black),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          customtext(
                                            alignment: TextAlign.center,
                                            fontWeight: FontWeight.w500,
                                            text:
                                                "${showconnecFolderList[index].connectionCount} Prospects",
                                            fontsize: 12,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void refreshDetails() {
    final result = showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddConnectionFolderWidget();
        }).then((value) {
      setState(() {
        showConnFolder();
      });
    });
  }
}
