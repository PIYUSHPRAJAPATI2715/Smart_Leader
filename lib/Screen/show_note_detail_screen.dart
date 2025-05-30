import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

// import 'package:flutter_quill/flutter_quill.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/add_note.dart';
import 'package:smart_leader/Modal/show_note_modal.dart';

import '../Helper/helper.dart';
import '../Widget/add_myNote_widget.dart';
import '../Widget/edit_note_screen.dart';
import '../Widget/edit_note_widget.dart';

class ShowNoteDetailScreen extends StatefulWidget {
  final ShowNoteModalData noteModalData;
  final String folderName;

  const ShowNoteDetailScreen(
      {Key? key, required this.noteModalData, required this.folderName})
      : super(key: key);

  @override
  State<ShowNoteDetailScreen> createState() => _ShowNoteDetailScreenState();
}

class _ShowNoteDetailScreenState extends State<ShowNoteDetailScreen> {
  //todo: uncomment these lines : for quill editor
  QuillController _controller = QuillController.basic();

  bool isSubmit = false;
  bool isNetwork = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var myJSON =
        jsonDecode(widget.noteModalData.description!.replaceAll('\n', '\\n'));

    //todo: uncomment these lines : for quill editor
    _controller = QuillController(
        document: Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0),
    readOnly: true);

    print('Myjson $myJSON');
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
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: customtext(
                                fontWeight: FontWeight.w600,
                                text: widget.noteModalData.title!,
                                color: Theme.of(context).primaryColor,
                                fontsize: 18.0),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          customtext(
                            fontWeight: FontWeight.w400,
                            text: widget.noteModalData.date!,
                            fontsize: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),


                      //todo: uncomment these lines : for quill editor
                      /*QuillProvider(
                        configurations: QuillConfigurations(
                          controller: _controller,
                          sharedConfigurations: const QuillSharedConfigurations(
                            locale: Locale('en'),
                          ),
                        ),
                        child: QuillEditor.basic(
                          configurations: const QuillEditorConfigurations(
                            readOnly: false,
                          ),
                        ),
                      ),*/
                      Container(
                        padding: EdgeInsets.all(8),
                        child: QuillEditor.basic(
                          controller: _controller,
                          // true for view-only mode
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
          height: 50,
          child: isSubmit
              ? Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    Expanded(
                      child: custom_Button(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditNoteWidget(
                                          showNoteModalData:
                                              widget.noteModalData,
                                          folderName: widget.folderName,
                                        ))).then((value) => {
                                  setState(() {
                                    // showNaote(folderid);
                                    //checkInternet(widget.folderName);
                                  })
                                });
                          },
                          title: "Edit Note",
                          hight: 45,
                          width: 140,
                          fontSize: 20),
                    ),
                    Expanded(
                      child: custom_Button(
                          onTap: () {
                            showDeleteDialog(widget.noteModalData.id!);
                          },
                          title: "Delete Note",
                          hight: 45,
                          width: 140,
                          fontSize: 20),
                    ),
                  ],
                )),
    );
  }

  void editNote() async {
    //todo: uncomment these lines : for quill editor
    if (_controller.document.toPlainText().isEmpty) {
      Helper.toastMassage('Please Enter Description', Colors.red);
      return;
    }
    setState(() {
      isSubmit = true;
    });

    bool isNetwork = await Helper.isNetworkAvailable();
//todo: uncomment these lines : for quill editor
    var description = jsonEncode(_controller.document.toDelta().toJson());

    if (!isNetwork) {
      updateNoteOffline();
    } else {
      Map<String, String> body = {
        "id": widget.noteModalData.id!,
        'title': widget.noteModalData.title!,
        "description": description,
        ////todo: uncomment these lines : for quill editor
        "user_id": SessionManager.getUserID(),
      };
      ApiHelper.editNote(body).then((login) {
        setState(() {
          isSubmit = false;
        });

        if (login.message == 'Update Note Successfully') {
          updateNoteOffline();
        } else {
          Helper.showSnackVar('Error', Colors.red, context);
        }
      });
    }
  }
  void showDeleteDialog(String deleteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Confirm Deletion ?",
          fontsize: 22,
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
    print("Deleting Note ID: $id");

    setState(() {
      isSubmit = true;
    });

    ApiHelper.deleteNote(body).then((response) {
      setState(() {
        isSubmit = false;
      });

      if (response.message?.trim() == "Successfully Deleted") {
        Navigator.pop(context);
        Helper.showSnackVar("Deleted Successfully", Colors.green, context);

        // Optionally refresh the list
        // showNote(folderid);
      } else {
        Helper.showSnackVar(response.message ?? "Deletion failed", Colors.red, context);
      }
    });
  }

  void updateNoteOffline() {
    //todo: uncomment these lines : for quill editor
    var description = jsonEncode(_controller.document.toDelta().toJson());

    AddNote addNote = AddNote(
        id: int.parse(widget.noteModalData.id!),
        description: description,
        ////todo: uncomment these lines : for quill editor
        title: widget.noteModalData.title,
        folderName: widget.folderName,
        createdDate: Helper.formattedDate());

    DBHelper.updateNote(addNote).then((value) {
      Navigator.pop(context, true);
      Helper.showSnackVar('Successfully Updated', Colors.green, context);
    });
  }
}
