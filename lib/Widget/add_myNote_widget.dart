import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/add_note.dart';
import 'custom_top_container.dart';

class AddMyNoteWidget extends StatefulWidget {
  final String id;
  final String folderName;

  const AddMyNoteWidget({
    Key? key,
    required this.id,
    required this.folderName,
  }) : super(key: key);

  @override
  State<AddMyNoteWidget> createState() => _AddMyNoteWidgetState();
}

class _AddMyNoteWidgetState extends State<AddMyNoteWidget> {
  final TextEditingController titleController = TextEditingController();
  final HtmlEditorController htmlController = HtmlEditorController();

  String hintTitle = 'Title';
  String hintDesc = 'Description';
  bool isSubmit = false;

  @override
  void initState() {
    super.initState();

    if (widget.folderName == 'Book Notes') {
      hintTitle = 'Book Notes';
      hintDesc = 'Book Description';
    } else if (widget.folderName == 'Meeting Notes') {
      hintTitle = 'Leader name';
      hintDesc = 'Meeting Notes';
    } else if (widget.folderName == 'To Do List') {
      hintTitle = 'Things to do';
      titleController.text = 'Things to do';
    }
  }

  void addNote() async {
    if (titleController.text.isEmpty) {
      Helper.toastMassage('Please Enter Title', Colors.red);
      return;
    }

    String htmlDesc = await htmlController.getText();
    if (htmlDesc.trim().isEmpty || htmlDesc == "<p><br></p>") {
      Helper.toastMassage('Please Enter Description', Colors.red);
      return;
    }

    bool isNetwork = await Helper.isNetworkAvailable();

    if (isNetwork) {
      Map<String, String> body = {
        "folder_id": widget.id,
        'title': titleController.text,
        "description": htmlDesc,
        "user_id": SessionManager.getUserID(),
      };

      ApiHelper.addNote(body).then((login) {
        setState(() => isSubmit = false);

        if (login.message == 'Note Add Successfully ') {
          addNoteOffline(htmlDesc);
        } else {
          Helper.toastMassage('Note Add Successfully', Colors.green);
          Navigator.pop(context, true);
        }
      });
    } else {
      addNoteOffline(htmlDesc);
    }
  }

  void addNoteOffline(String htmlDesc) async {
    AddNote addNote = AddNote(
      title: titleController.text,
      description: htmlDesc,
      folderName: widget.folderName,
      createdDate: Helper.formattedDate(),
    );

    await DBHelper.insertNote(addNote);
    Helper.toastMassage('Note Added', Colors.green);
    titleController.clear();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopContainer(
            title: "SmartLeader",
            onTap: () => Navigator.pop(context),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    customtext(
                      fontWeight: FontWeight.w500,
                      text: "Add Note",
                      color: Theme.of(context).primaryColor,
                      fontsize: 20,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hight: 50,
                      title: "Enter Title",
                      controller: titleController,
                      hint: hintTitle,
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      lableName: hintTitle,
                      hintfont: 12,
                      lablefont: 14,
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: customtext(
                        fontWeight: FontWeight.w500,
                        text: hintDesc,
                        color: Theme.of(context).primaryColor,
                        fontsize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: kblueColor),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: HtmlEditor(
                        controller: htmlController,
                        htmlEditorOptions: HtmlEditorOptions(
                          hint: "Your note here...",
                          shouldEnsureVisible: true,
                        ),
                        htmlToolbarOptions: HtmlToolbarOptions(
                          toolbarPosition: ToolbarPosition.aboveEditor,
                          defaultToolbarButtons: [
                             FontButtons(),
                            // ColorButtons(),
                            // ListButtons(),

                            // ParagraphButtons(),
                            InsertButtons(),
                            // OtherButtons(codeview: false),
                          ],
                        ),
                        otherOptions: OtherOptions(
                          height: 300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: isSubmit
                ? const Center(child: CircularProgressIndicator())
                : custom_Button(
              onTap: addNote,
              title: "Save",
              hight: 45,
              width: double.infinity,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
