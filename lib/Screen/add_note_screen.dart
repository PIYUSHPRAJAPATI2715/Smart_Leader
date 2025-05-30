import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/popup_menuBar.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/ExtractClasses/move_notes_widget.dart';
import 'package:smart_leader/ExtractClasses/short_dialog_widget.dart';
import 'package:smart_leader/ExtractClasses/tools_searchbar.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/add_note.dart';
import 'package:smart_leader/Modal/show_folder_modal.dart';
import 'package:smart_leader/Modal/show_note_modal.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Screen/show_note_detail_screen.dart';
import 'package:smart_leader/Widget/add_myNote_widget.dart';
import 'package:smart_leader/Widget/edit_note_widget.dart';

class AddNoteScreen extends StatefulWidget {
  final String id;
  final String folderName;
  final List<ShowFolderModalData> showfolderData;
  final int index;

  const AddNoteScreen(
      {Key? key,
      required this.id,
      required this.showfolderData,
      required this.folderName,
      required this.index})
      : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  List<String> frequencyContainer = [
    "General",
    "Important",
    "Container1",
    "Container2",
    "Container3"
  ];

  bool isSubmit = false;

  late Future<ShowNoteModal> showNote;
  List<ShowNoteModalData> showNoteList = [];
  List<ShowNoteModalData> tampList = [];
  String lastInputValue = "";
  String folderid = "";
  String folderName = "";
  List<ShowNoteModalData> selectedList = [];
  List<String> idList = [];

  bool isNetwork = false;

  //todo: uncomment these lines : for quill editor
  QuillController _controller = QuillController.basic();
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final data = Provider.of<AppController>(context, listen: false);
    data.selectedContainer = widget.index;
    folderid = widget.id;
    folderName = widget.folderName;

    int scrollIndex = widget.showfolderData
        .indexWhere((element) => element.folderName == widget.folderName);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.scrollTo(
          index: scrollIndex,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOutCubic);
    });

    checkInternet(folderid);
  }

  void checkInternet(String id) async {
    isNetwork = await Helper.isNetworkAvailable();
    if (isNetwork) {
      showNaote(id);
    } else {
      showOfflineNotes();
    }
  }

  void showNaote(String folderId) {
    selectedList.clear();
    idList.clear();

    setState(() {
      isSubmit = true;
    });
    showNoteList.clear();
    tampList.clear();

    Map<String, String> body = {
      "user_id": SessionManager.getUserID(),
      "folder_id": folderId
    };
    print('BODYXZZZz $body');
    ApiHelper.showNote(body).then((value) {
      setState(() {
        isSubmit = false;
      });
      if (value.message == " Note's Showing Is Successfully") {
        showNoteList = value.data!;
        tampList = showNoteList;
      }
    });
  }

  //todo: getting offline notes
  void showOfflineNotes() async {
    showNoteList.clear();
    selectedList.clear();
    idList.clear();

    List<AddNote> offlineNotes = [];
    List<Map<String, dynamic>> notes = await DBHelper.getNotes(folderName);
    offlineNotes
        .assignAll(notes.map((data) => AddNote.fromJson(data)).toList());

    //19-01-2023
    for (var note in offlineNotes) {
      ShowNoteModalData noteModel = ShowNoteModalData(
        id: note.id.toString(),
        folderId: folderid,
        title: note.title,
        description: note.description,
        date: note.createdDate,
        time: '10',
        strtotime: '',
        userId: SessionManager.getUserID(),
        isSelected: false,
      );
      showNoteList.add(noteModel);
    }
    setState(() {});
  }

  //todo: delete dialog3e
  void showDeleteDialog(String deleteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Delete Note",
          fontsize: 22,
          color: Theme.of(context).primaryColor,
        ),
        content: customtext(
          fontWeight: FontWeight.w400,
          text: "Are you sure delete this note",
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

      Map<String, String> body = {"id": id};

      setState(() {
        isSubmit = true;
      });

      ApiHelper.deleteNote(body).then((login) {
        if (login.message == " Successfully Deleted") {
          deleteOfflineNotes(id);
          // Helper.showSnackVar("Delete Successfully", Colors.green, context);
          setState(() {
            isSubmit = false;
          });
          // showNaote(folderid);
        }
      });

  }

  void deleteOfflineNotes(String id) {
    DBHelper.deleteNote(int.parse(id)).then((value) {
      if (value == 1) {
        checkInternet(folderid);
        Helper.showSnackVar("Delete Successfully", Colors.green, context);
      }
    });
  }

  void multipledelete() async {
    String deleteid = idList.join(",");
    Map<String, String> body = {
      "id": deleteid,
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.multideleteNote(body).then((login) {
      setState(() {
        isSubmit = false;
      });

      if (login.message == "  Successfully Deleted") {
        Helper.showSnackVar("Deleted Successfully", Colors.green, context);

        // Helper.showLoaderDialog(context);

        idList.clear();
        folderid = widget.id;
        showNaote(widget.id);
      } else {
        Helper.showSnackVar(login.message!, Colors.green, context);
      }
    });
  }

  void searchNote(String value) {
    final suggestions = showNoteList.where((element) {
      final taskTitle = element.title!.toLowerCase();
      final input = value.toLowerCase();

      return taskTitle.startsWith(input);
    }).toList();

    setState(() {
      showNoteList = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
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
                if (value.length == 0) {
                  setState(() {
                    showNoteList = tampList;
                  });
                } else {
                  searchNote(value);
                }
              }
            },
            ontapIcon: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ShortDialogWidget(
                      onFrequencyTap: () {},
                      onDSCDateTap: () {
                        setState(() {
                          showNoteList
                              .sort((a, b) => b.date!.compareTo(a.date!));
                        });
                        Navigator.pop(context);
                      },
                      onZtoATap: () {
                        setState(() {
                          showNoteList
                              .sort((a, b) => b.title!.compareTo(a.title!));
                        });
                        Navigator.pop(context);
                      },
                      alphaOntap: () {
                        setState(() {
                          showNoteList
                              .sort((a, b) => a.title!.compareTo(b.title!));
                        });
                        Navigator.pop(context);
                      },
                      dateOntap: () {
                        setState(() {
                          showNoteList
                              .sort((a, b) => a.date!.compareTo(b.date!));
                        });
                        Navigator.pop(context);
                      },
                    );
                  });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: ScrollablePositionedList.builder(
                          scrollDirection: Axis.horizontal,
                          itemScrollController: _scrollController,
                          shrinkWrap: true,
                          itemCount: widget.showfolderData.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                data.selectedOneContainer(index);
                                folderid = widget.showfolderData[index].id!;
                                folderName =
                                    widget.showfolderData[index].folderName!;

                                //showNaote(folderid);
                                checkInternet(folderid);
                              },
                              child: Card(
                                color: SessionManager.getTheme() == true
                                    ? kscafolledColor
                                    : kWhiteColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient:
                                          SessionManager.getTheme() == true
                                              ? widget.showfolderData[index]
                                                          .folderName ==
                                                      folderName
                                                  ? kGradient
                                                  : kgreyGradient
                                              : widget.showfolderData[index]
                                                          .folderName ==
                                                      folderName
                                                  ? kGradient
                                                  : k2Gradient,
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                          color:
                                              SessionManager.getTheme() == true
                                                  ? kscafolledColor
                                                  : kblueColor)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 22, vertical: 10),
                                    child: Center(
                                      child: customtext(
                                        fontWeight: FontWeight.w400,
                                        text: widget
                                            .showfolderData[index].folderName!,
                                        fontsize: 15,
                                        color: widget.showfolderData[index]
                                                    .folderName ==
                                                folderName
                                            ? kWhiteColor
                                            : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    Visibility(
                      visible: false,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: List.generate(
                          growable: true,
                          widget.showfolderData.length,
                          (index) => InkWell(
                            onTap: () {
                              data.selectedOneContainer(index);
                              folderid = widget.showfolderData[index].id!;
                              folderName =
                                  widget.showfolderData[index].folderName!;

                              //showNaote(folderid);
                              checkInternet(folderid);
                            },
                            child: Card(
                              color: SessionManager.getTheme() == true
                                  ? kscafolledColor
                                  : kWhiteColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: SessionManager.getTheme() == true
                                        ? widget.showfolderData[index]
                                                    .folderName ==
                                                folderName
                                            ? kGradient
                                            : kgreyGradient
                                        : widget.showfolderData[index]
                                                    .folderName ==
                                                folderName
                                            ? kGradient
                                            : k2Gradient,
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                        color: SessionManager.getTheme() == true
                                            ? kscafolledColor
                                            : kblueColor)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 10),
                                  child: Center(
                                    child: customtext(
                                      fontWeight: FontWeight.w400,
                                      text: widget
                                          .showfolderData[index].folderName!,
                                      fontsize: 15,
                                      color: widget.showfolderData[index]
                                                  .folderName ==
                                              folderName
                                          ? kWhiteColor
                                          : Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    isSubmit == true
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
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
                                            1.58)),
                            itemCount: showNoteList.length,
                            itemBuilder: (context, index) {
                              var myJSON = jsonDecode(showNoteList[index].description!.replaceAll('\n', '\\n'));

                              //todo: uncomment these lines : for quill editor
                              _controller = QuillController(

                                readOnly: true,
                                document: Document.fromJson(myJSON),
                                selection:
                                    const TextSelection.collapsed(offset: 0),
                              );

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShowNoteDetailScreen(
                                                noteModalData:
                                                    showNoteList[index],
                                                folderName: folderName,
                                              ))).then((value) => {
                                        setState(() {
                                          // showNaote(
                                          //     folderid);
                                          checkInternet(folderid);
                                        })
                                      });
                                  ;
                                },
                                onLongPress: () {
                                  bool isSelected =
                                      !showNoteList[index].isSelected;
                                  ShowNoteModalData showNote =
                                      ShowNoteModalData(
                                    isSelected: isSelected,
                                    title: showNoteList[index].title,
                                    userId: showNoteList[index].userId,
                                    strtotime: showNoteList[index].strtotime,
                                    date: showNoteList[index].date,
                                    id: showNoteList[index].id,
                                    time: showNoteList[index].time,
                                    path: showNoteList[index].path,
                                    description:
                                        showNoteList[index].description,
                                    folderId: showNoteList[index].folderId,
                                  );

                                  int idx = showNoteList.indexWhere(
                                      (element) => element.id == showNote.id);
                                  showNoteList[idx].isSelected =
                                      !showNoteList[idx].isSelected;
                                  setState(() {
                                    if (idList
                                        .contains(showNoteList[index].id)) {
                                      idList.remove(showNoteList[index].id);
                                    } else {
                                      idList.add(showNoteList[index].id!);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    border:Border.all(color: KBoxNewColor,width: 1),
                                    color: SessionManager.getTheme() == true
                                        ? kscafolledColor
                                        :Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                showNoteList[index]
                                                            .isSelected ==
                                                        true
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: SessionManager
                                                                            .getTheme() ==
                                                                        true
                                                                    ? kWhiteColor
                                                                    : kBlackColor,
                                                                width: 2),
                                                            color: kredColor,
                                                            shape: BoxShape
                                                                .circle),
                                                        child: const Center(
                                                            child: Icon(
                                                          Icons.done,
                                                          size: 15,
                                                          color: kWhiteColor,
                                                        )))
                                                    : Container(),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: customtext(
                                                    fontWeight: FontWeight.w500,
                                                    text: showNoteList[index]

                                                        .title!,
                                                    maxLine: 2,
                                                    fontsize: 16,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Column(
                                          //   children: [
                                          //     showNoteList[index].isSelected ==
                                          //             true
                                          //         ? Container()
                                          //         : SizedBox(
                                          //             width: 25,
                                          //             height: 25,
                                          //             child: SimplePopUp(
                                          //                 isMoveShow: isNetwork,
                                          //                 onChanged: (value) {
                                          //                   if (value == 1) {
                                          //                     Map<String,
                                          //                             String>
                                          //                         map = {
                                          //                       "user_id":
                                          //                           SessionManager
                                          //                               .getUserID(),
                                          //                       "folder_id":
                                          //                           folderid
                                          //                     };
                                          //                     Navigator.push(
                                          //                         context,
                                          //                         MaterialPageRoute(
                                          //                             builder: (context) => EditNoteWidget(
                                          //                                 folderName:
                                          //                                     folderName,
                                          //                                 showNoteModalData:
                                          //                                     showNoteList[index]))).then(
                                          //                         (value) => {
                                          //                               setState(
                                          //                                   () {
                                          //                                 // showNaote(
                                          //                                 //     folderid);
                                          //                                 checkInternet(
                                          //                                     folderid);
                                          //                               })
                                          //                             });
                                          //                   } else if (value ==
                                          //                       2) {
                                          //                   } else if (value ==
                                          //                       3) {
                                          //                     /*
                                          //                     setState(() {
                                          //                       delete(
                                          //                           showNoteList[
                                          //                                   index]
                                          //                               .id!);
                                          //                     });
                                          //                     */
                                          //                     showDeleteDialog(
                                          //                         showNoteList[
                                          //                                 index]
                                          //                             .id!);
                                          //                     return;
                                          //                   } else if (value ==
                                          //                       4) {
                                          //                     showDialog(
                                          //                         context:
                                          //                             context,
                                          //                         builder:
                                          //                             (context) {
                                          //                           return MoveNoteWidget(
                                          //                             showfolderData:
                                          //                                 widget
                                          //                                     .showfolderData,
                                          //                             noteId: showNoteList[
                                          //                                     index]
                                          //                                 .id!,
                                          //                           );
                                          //                         }).then((value) {
                                          //                       if (value ==
                                          //                           true) {
                                          //                         setState(() {
                                          //                           showNaote(
                                          //                               folderid);
                                          //                         });
                                          //                       }
                                          //                     });
                                          //                   }
                                          //                 },
                                          //                 color: Theme.of(
                                          //                         context)
                                          //                     .primaryColor)),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                      /*Expanded(
                                        child: quill.QuillProvider(
                                          configurations: QuillConfigurations(
                                            controller: _controller,
                                            sharedConfigurations:
                                                const QuillSharedConfigurations(
                                              locale: Locale('de'),
                                            ),
                                          ),
                                          child: Expanded(
                                            child: QuillEditor.basic(
                                              configurations:
                                                  const QuillEditorConfigurations(
                                                readOnly: true, controller: _controller,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ),*/
                                      //todo: uncomment these lines : for quill editor

                                      Divider(
                                        thickness: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [

                                          Expanded(
                                            child: Row(
                                              children: [
                                                customtext(
                                                    fontWeight: FontWeight.w500,
                                                    text: 'Last Edited : ',
                                                    fontsize: 10),
                                                customtext(
                                                  fontWeight: FontWeight.w400,
                                                  text:
                                                      showNoteList[index].date!,
                                                  fontsize: 10,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.calendar_month,
                                                  size: 12,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )
                                              ],
                                            ),
                                          ),
                                          // customtext(
                                          //     fontWeight: FontWeight.w600,
                                          //     text: 'View',
                                          //     fontsize: 12)
                                        ],
                                      ),

                                      Expanded(
                                        child: QuillEditor.basic(
                                          controller: _controller,
                                          // readOnly:
                                          // true // true for view only mode
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Map<String, String> map = {
            "user_id": SessionManager.getUserID(),
            "folder_id": folderid
          };

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddMyNoteWidget(
                        id: folderid,
                        folderName: folderName,
                      ))).then((value) => {
                setState(() {
                  // showNaote(folderid);
                  checkInternet(folderid);
                })
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

  Widget searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
              color: SessionManager.getTheme() == true
                  ? kscafolledColor
                  : kWhiteColor,
              borderRadius: BorderRadius.circular(20)),
          child: TextFormField(
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: "SplineSans",
                fontSize: 18,
                fontWeight: FontWeight.w400),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: SessionManager.getTheme() == true
                  ? kscafolledColor
                  : kWhiteColor,
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              suffixIcon: Icon(
                Icons.filter_alt_outlined,
                color: Theme.of(context).primaryColor,
              ),
              hintText: "Search",
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              hintStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: "SplineSans",
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : const Color(0xffBFBFBF))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : Colors.grey.shade50)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}

class topContainer extends StatelessWidget {
  const topContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
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
                )),

            // Container(
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     border: Border.all(color: kWhiteColor)
            //   ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(3.0),
            //       child: Center(
            //           child: Icon(
            //   Icons.delete,
            //   size: 20,
            //   color: kWhiteColor,
            // )),
            //     ))
          ],
        ),
      ),
    );
  }
}
