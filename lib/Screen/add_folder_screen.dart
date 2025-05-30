import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Button2.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/folder.dart';
import 'package:smart_leader/Modal/show_folder_modal.dart';
import 'package:smart_leader/Modal/show_folder_modal.dart';
import 'package:smart_leader/Modal/show_folder_modal.dart';
import 'package:smart_leader/Modal/show_folder_modal.dart';
import 'package:smart_leader/Modal/show_static_folder_modal.dart';
import 'package:smart_leader/Screen/add_note_screen.dart';
import 'package:smart_leader/Widget/add_folder_widget.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class AddFolderScreen extends StatefulWidget {
  const AddFolderScreen({Key? key}) : super(key: key);

  @override
  State<AddFolderScreen> createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  bool isSubmit = true;
  late Future<ShowFolderModal> showFolder;
  late Future<ShowFolderModal> staticFolder;
  List<ShowFolderModalData> allFolderList = [];
  List<ShowFolderModalData> staticFolderList = [];
  List<ShowFolderModalData> showFolderList = [];

  bool isNetwork = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
  }

  void checkInternet() async {
    isNetwork = await Helper.isNetworkAvailable();
    setState(() {});

    print('isNetwork $isNetwork');
    if (isNetwork) {
      showFolder = ApiHelper.showFolder();
      staticFolder = ApiHelper.showstaticFolder();
    } else {
      showOfflineFolder();
    }
  }

  void showOfflineFolder() async {
    showFolderList.clear();

    List<Folder> offlineFolder = [];
    List<Map<String, dynamic>> tasks = await DBHelper.getFolder();
    offlineFolder
        .assignAll(tasks.map((data) => Folder.fromJson(data)).toList());

    for (var folder in offlineFolder) {
      ShowFolderModalData folders = ShowFolderModalData(
          id: folder.id.toString(),
          userId: SessionManager.getUserID(),
          folderName: folder.folderName,
          strtotime: ' ',
          noteCount: 0,
          path: '');
      showFolderList.add(folders);
    }
    setState(() {});
  }

  void delete(String id) async {
    if (!isNetwork) {
      delete(id);
    } else {
      Map<String, String> body = {"id": id};

      setState(() {
        isSubmit = true;
      });

      ApiHelper.deleteFolder(body).then((login) {
        if (login.message == " Successfully Deleted") {
          // Helper.showSnackVar("Delete Successfully", Colors.green, context);
          deleteOfflineFolder(id);
          // Helper.showLoaderDialog(context);

          setState(() {
            isSubmit = false;
          });

          // showFolder = ApiHelper.showFolder();
          // staticFolder = ApiHelper.showstaticFolder();
        }
      });
    }
  }

  void deleteOfflineFolder(String id) {
    DBHelper.deleteFolder(int.parse(id)).then((value) {
      if (value == 1) {
        Helper.showSnackVar("Deleted Successfully", Colors.green, context);
        checkInternet();
      }
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

          SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    !isNetwork
                        ? const SizedBox()
                        : FutureBuilder<ShowFolderModal>(
                            future: staticFolder,
                            builder: (context, snapShot) {
                              if (snapShot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              staticFolderList = snapShot.data!.data!;
                              return GridView.builder(
                                itemCount: staticFolderList.length,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 7.0,
                                        mainAxisSpacing: 7.0,
                                        childAspectRatio: MediaQuery.of(context)
                                                .size
                                                .width /
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.9)),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      // refreshDetails1(snapShot.data!.data!, snapShot.data!.data![index].id!, index);
                                      createList(
                                          snapShot.data!.data![index].id!,
                                          index,
                                          snapShot
                                              .data!.data![index].folderName!);
                                    },
                                    child: Container(
                                      width: 60,
                                      padding: EdgeInsets.all(5),

                                      decoration: BoxDecoration(
                                        color: SessionManager.getTheme() == true
                                            ? kscafolledColor
                                            :Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Image.network(
                                              height: 60,
                                              width: 120,
                                              snapShot.data!.data![index]
                                                  .path!,
                                            ),
                                          ),
                                          customtext(
                                              fontWeight: FontWeight.w800,
                                              text: snapShot.data!.data![index]
                                                  .folderName!,
                                              fontsize: 16,
                                              alignment: TextAlign.center,
                                              color:
                                                  SessionManager.getTheme() ==
                                                          true
                                                      ? kWhiteColor
                                                      : kbuttonColor),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          /* customtext(
                                        fontWeight: FontWeight.w500,
                                        text:
                                            "${snapShot.data!.data![index].noteCount} Notes",
                                        fontsize: 12,
                                        color: Theme.of(context).primaryColor,
                                      )*/
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                    SizedBox(height: 15),
                    // customtext(
                    //   fontWeight: FontWeight.w500,
                    //   text: !isNetwork ? 'Offline Folder' : "Your Folder",
                    //   fontsize: 18,
                    //   color: Theme.of(context).primaryColor,
                    // ),
                    // SizedBox(height: 15),
                    // !isNetwork
                    //     ? GridView.builder(
                    //         padding: EdgeInsets.zero,
                    //         physics: NeverScrollableScrollPhysics(),
                    //         shrinkWrap: true,
                    //         gridDelegate:
                    //             SliverGridDelegateWithFixedCrossAxisCount(
                    //                 crossAxisCount: 2,
                    //                 crossAxisSpacing: 7.0,
                    //                 mainAxisSpacing: 7.0,
                    //                 childAspectRatio: MediaQuery.of(context)
                    //                         .size
                    //                         .width /
                    //                     (MediaQuery.of(context).size.height /
                    //                         4.0)),
                    //         itemCount: showFolderList.length,
                    //         itemBuilder: (context, index) {
                    //           return InkWell(
                    //             onTap: () {
                    //               //  refreshDetails1(snapshot.data!.data!, snapshot.data!.data![index].id!, index);
                    //               createList(showFolderList[index].id!, index,
                    //                   showFolderList[index].folderName!);
                    //             },
                    //             child: Container(
                    //               padding: EdgeInsets.symmetric(
                    //                 horizontal: 15,
                    //               ),
                    //               decoration: BoxDecoration(
                    //                 color: SessionManager.getTheme() == true
                    //                     ? kscafolledColor
                    //                     : kgreen2Color,
                    //                 borderRadius: BorderRadius.circular(20),
                    //               ),
                    //               child: Column(
                    //                 children: [
                    //                   SizedBox(
                    //                     height: 2,
                    //                   ),
                    //                   Row(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     children: [
                    //                       Expanded(flex: 7, child: Container()),
                    //                       InkWell(
                    //                         onTap: () {
                    //                           showDialog(
                    //                             context: context,
                    //                             builder: (ctx) => AlertDialog(
                    //                               backgroundColor: Theme.of(
                    //                                       context)
                    //                                   .scaffoldBackgroundColor,
                    //                               title: customtext(
                    //                                 fontWeight: FontWeight.w500,
                    //                                 text:
                    //                                     "${showFolderList[index].folderName}",
                    //                                 fontsize: 22,
                    //                                 color: Theme.of(context)
                    //                                     .primaryColor,
                    //                               ),
                    //                               content: customtext(
                    //                                 fontWeight: FontWeight.w400,
                    //                                 text:
                    //                                     "Are you sure delete this folder",
                    //                                 fontsize: 15,
                    //                                 color: Theme.of(context)
                    //                                     .primaryColor,
                    //                               ),
                    //                               actions: <Widget>[
                    //                                 Row(
                    //                                   mainAxisAlignment:
                    //                                       MainAxisAlignment
                    //                                           .center,
                    //                                   children: [
                    //                                     TextButton(
                    //                                       onPressed: () {
                    //                                         Navigator.of(ctx)
                    //                                             .pop();
                    //                                       },
                    //                                       child: Container(
                    //                                         color: Colors.green,
                    //                                         padding:
                    //                                             const EdgeInsets
                    //                                                 .all(14),
                    //                                         child: const Text(
                    //                                             "No"),
                    //                                       ),
                    //                                     ),
                    //                                     TextButton(
                    //                                       onPressed: () {
                    //                                         delete(
                    //                                             showFolderList[
                    //                                                     index]
                    //                                                 .id!);
                    //                                         // showFolder = ApiHelper
                    //                                         //     .showFolder();
                    //                                         checkInternet();
                    //                                         Navigator.of(ctx)
                    //                                             .pop();
                    //                                       },
                    //                                       child: Container(
                    //                                         color: Colors.green,
                    //                                         padding:
                    //                                             const EdgeInsets
                    //                                                 .all(14),
                    //                                         child: const Text(
                    //                                             "Yes"),
                    //                                       ),
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           );
                    //                         },
                    //                         child: Expanded(
                    //                           child: Icon(
                    //                             Icons.dangerous_outlined,
                    //                             color: Theme.of(context)
                    //                                 .primaryColor,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                   Column(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.center,
                    //                     children: [
                    //                       customtext(
                    //                           alignment: TextAlign.center,
                    //                           fontWeight: FontWeight.w500,
                    //                           text: showFolderList[index]
                    //                               .folderName!,
                    //                           fontsize: 18,
                    //                           color:
                    //                               SessionManager.getTheme() ==
                    //                                       true
                    //                                   ? kWhiteColor
                    //                                   : kbuttonColor),
                    //                       SizedBox(
                    //                         height: 5,
                    //                       ),
                    //                       customtext(
                    //                         alignment: TextAlign.center,
                    //                         fontWeight: FontWeight.w500,
                    //                         text:
                    //                             "${showFolderList[index].noteCount} Notes",
                    //                         fontsize: 12,
                    //                         color:
                    //                             Theme.of(context).primaryColor,
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       )
                    //     : FutureBuilder<ShowFolderModal>(
                    //         future: showFolder,
                    //         builder: (context, snapshot) {
                    //           if (snapshot.connectionState ==
                    //               ConnectionState.waiting) {
                    //             return Center(
                    //               child: CircularProgressIndicator(),
                    //             );
                    //           }
                    //           showFolderList = snapshot.data!.data!;
                    //           return GridView.builder(
                    //             padding: EdgeInsets.zero,
                    //             physics: NeverScrollableScrollPhysics(),
                    //             shrinkWrap: true,
                    //             gridDelegate:
                    //                 SliverGridDelegateWithFixedCrossAxisCount(
                    //                     crossAxisCount: 2,
                    //                     crossAxisSpacing: 7.0,
                    //                     mainAxisSpacing: 7.0,
                    //                     childAspectRatio: MediaQuery.of(context)
                    //                             .size
                    //                             .width /
                    //                         (MediaQuery.of(context)
                    //                                 .size
                    //                                 .height /
                    //                             4.0)),
                    //             itemCount: snapshot.data!.data!.length,
                    //             itemBuilder: (context, index) {
                    //               return InkWell(
                    //                 onTap: () {
                    //                   //  refreshDetails1(snapshot.data!.data!, snapshot.data!.data![index].id!, index);
                    //                   createList(
                    //                       snapshot.data!.data![index].id!,
                    //                       index,
                    //                       snapshot
                    //                           .data!.data![index].folderName!);
                    //                 },
                    //                 child: Container(
                    //                   padding: EdgeInsets.symmetric(
                    //                     horizontal: 15,
                    //                   ),
                    //                   decoration: BoxDecoration(
                    //                     color: SessionManager.getTheme() == true
                    //                         ? kscafolledColor
                    //                         : kgreen2Color,
                    //                     borderRadius: BorderRadius.circular(20),
                    //                   ),
                    //                   child: Column(
                    //                     children: [
                    //                       SizedBox(
                    //                         height: 2,
                    //                       ),
                    //                       Row(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.center,
                    //                         children: [
                    //                           Expanded(
                    //                               flex: 7, child: Container()),
                    //                           InkWell(
                    //                             onTap: () {
                    //                               showDialog(
                    //                                 context: context,
                    //                                 builder: (ctx) =>
                    //                                     AlertDialog(
                    //                                   backgroundColor: Theme.of(
                    //                                           context)
                    //                                       .scaffoldBackgroundColor,
                    //                                   title: customtext(
                    //                                     fontWeight:
                    //                                         FontWeight.w500,
                    //                                     text:
                    //                                         "${snapshot.data!.data![index].folderName}",
                    //                                     fontsize: 22,
                    //                                     color: Theme.of(context)
                    //                                         .primaryColor,
                    //                                   ),
                    //                                   content: customtext(
                    //                                     fontWeight:
                    //                                         FontWeight.w400,
                    //                                     text:
                    //                                         "Are you sure delete this folder",
                    //                                     fontsize: 15,
                    //                                     color: Theme.of(context)
                    //                                         .primaryColor,
                    //                                   ),
                    //                                   actions: <Widget>[
                    //                                     Row(
                    //                                       mainAxisAlignment:
                    //                                           MainAxisAlignment
                    //                                               .center,
                    //                                       children: [
                    //                                         TextButton(
                    //                                           onPressed: () {
                    //                                             Navigator.of(
                    //                                                     ctx)
                    //                                                 .pop();
                    //                                           },
                    //                                           child: Container(
                    //                                             color: Colors
                    //                                                 .green,
                    //                                             padding:
                    //                                                 const EdgeInsets
                    //                                                     .all(14),
                    //                                             child:
                    //                                                 const Text(
                    //                                                     "No"),
                    //                                           ),
                    //                                         ),
                    //                                         TextButton(
                    //                                           onPressed: () {
                    //                                             delete(
                    //                                                 showFolderList[
                    //                                                         index]
                    //                                                     .id!);
                    //                                             // showFolder =
                    //                                             //     ApiHelper
                    //                                             //         .showFolder();
                    //                                             checkInternet();
                    //                                             Navigator.of(
                    //                                                     ctx)
                    //                                                 .pop();
                    //                                           },
                    //                                           child: Container(
                    //                                             color: Colors
                    //                                                 .green,
                    //                                             padding:
                    //                                                 const EdgeInsets
                    //                                                     .all(14),
                    //                                             child:
                    //                                                 const Text(
                    //                                                     "Yes"),
                    //                                           ),
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               );
                    //                             },
                    //                             child: Expanded(
                    //                               child: Icon(
                    //                                 Icons.dangerous_outlined,
                    //                                 color: Theme.of(context)
                    //                                     .primaryColor,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                       Column(
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.center,
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.center,
                    //                         children: [
                    //                           customtext(
                    //                               alignment: TextAlign.center,
                    //                               fontWeight: FontWeight.w500,
                    //                               text: snapshot.data!
                    //                                   .data![index].folderName!,
                    //                               fontsize: 18,
                    //                               color: SessionManager
                    //                                           .getTheme() ==
                    //                                       true
                    //                                   ? kWhiteColor
                    //                                   : kbuttonColor),
                    //                           SizedBox(
                    //                             height: 5,
                    //                           ),
                    //                           customtext(
                    //                             alignment: TextAlign.center,
                    //                             fontWeight: FontWeight.w500,
                    //                             text:
                    //                                 "${snapshot.data!.data![index].noteCount} Notes",
                    //                             fontsize: 12,
                    //                             color: Theme.of(context)
                    //                                 .primaryColor,
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           );
                    //         })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     refreshDetails();
      //   },
      //   child: Container(
      //     decoration: BoxDecoration(
      //         gradient:
      //             SessionManager.getTheme() == true ? k2Gradient : kGradient,
      //         shape: BoxShape.circle),
      //     child: Center(
      //         child: Icon(
      //       Icons.add,
      //       color:
      //           SessionManager.getTheme() == true ? kBlackColor : kWhiteColor,
      //       size: 45,
      //     )),
      //   ),
      // ),
    );
  }

  void refreshDetails() {
    final result = showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AddFolderWidget();
        }).then((value) {
      setState(() {
        // showFolder = ApiHelper.showFolder();
        checkInternet();
      });
    });
  }

  void createList(String id, int index, String folderName) {
    allFolderList.clear();
    for (int i = 0; i < staticFolderList.length; i++) {
      allFolderList.add(staticFolderList[i]);
    }

    for (int j = 0; j < showFolderList.length; j++) {
      allFolderList.add(showFolderList[j]);
    }

    refreshDetails1(allFolderList, id, index, folderName);
  }

  void refreshDetails1(List<ShowFolderModalData> showList, String id, int index,
      String folderName) {
    final result = Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddNoteScreen(
                  id: id,
                  folderName: folderName,
                  showfolderData: showList,
                  index: index,
                ))).then((value) {
      setState(() {
        // showFolder = ApiHelper.showFolder();
        checkInternet();
      });
    });
  }
}

/*
Row(
                       children: [
                         SizedBox(
                           height: 80,
                           child: ListView.builder(
                             padding: EdgeInsets.zero,
                             itemCount: snapShot.data!.data!.length,
                               shrinkWrap: true,
                               scrollDirection: Axis.horizontal,
                               itemBuilder: (context, index){
                             return InkWell(
                               onTap: () {
                                // refreshDetails1(snapShot.data!.data!, snapShot.data!.data![index].id!, index);
                                 createList(snapShot.data!.data![index].id!, index);
                               },
                               child: Container(
                                 padding: EdgeInsets.symmetric(horizontal:40),
                                 margin: EdgeInsets.symmetric(horizontal: 5),
                                 decoration: BoxDecoration(
                                   color: SessionManager.getTheme() == true
                                       ? kscafolledColor
                                       : kyelloColor,
                                   borderRadius: BorderRadius.circular(20),
                                 ),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     customtext(
                                         fontWeight: FontWeight.w500,
                                         text: snapShot.data!.data![index].folderName!,
                                         fontsize: 18,
                                         color:
                                         SessionManager.getTheme() ==
                                             true
                                             ? kWhiteColor
                                             : kbuttonColor),
                                     SizedBox(
                                       height: 5,
                                     ),
                                     customtext(
                                       fontWeight: FontWeight.w500,
                                       text: "${snapShot.data!.data![index].noteCount} Notes",
                                       fontsize: 12,
                                       color: Theme.of(context)
                                           .primaryColor,
                                     )
                                   ],
                                 ),
                               ),
                             );
                           }),
                         ),
                       ],
                     );
 */
