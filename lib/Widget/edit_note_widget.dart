import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Button2.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_description_textfield.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/add_note.dart';
import 'package:smart_leader/Modal/show_note_modal.dart';

class EditNoteWidget extends StatefulWidget {
  final ShowNoteModalData showNoteModalData;
  final String folderName;

  const EditNoteWidget({
    Key? key,
    required this.showNoteModalData,
    required this.folderName,
  }) : super(key: key);

  @override
  State<EditNoteWidget> createState() => _EditNoteWidgetState();
}

class _EditNoteWidgetState extends State<EditNoteWidget> {
  bool isSubmit = false;
  final TextEditingController titleController = TextEditingController();
  final HtmlEditorController htmlController = HtmlEditorController();
  bool isNetwork = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.showNoteModalData.title!;
  }

  void editNote() async {
    if (titleController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Title', Colors.red, context);
      return;
    }

    String description = await htmlController.getText();
    if (description.trim().isEmpty || description.trim() == "<p></p>") {
      Helper.toastMassage('Please Enter Description', Colors.red);
      return;
    }

    isNetwork = await Helper.isNetworkAvailable();

    if (!isNetwork) {
      updateNoteOffline(description);
    } else {
      Map<String, String> body = {
        "id": widget.showNoteModalData.id!,
        'title': titleController.text,
        'folder_id': widget.showNoteModalData.folderId!,
        "description": description,
        "user_id": SessionManager.getUserID(),
      };

      ApiHelper.editNote(body).then((login) {
        setState(() {
          isSubmit = false;
        });

        if (login.message == 'Update Note Successfully') {
          titleController.clear();
          Navigator.pop(context, true);
          Helper.showSnackVar('Successfully Updated', Colors.green, context);
          updateNoteOffline(description);
        } else {
          Helper.showSnackVar('Error', Colors.red, context);
        }
      });
    }
  }

  void updateNoteOffline(String description) {
    AddNote addNote = AddNote(
      id: int.parse(widget.showNoteModalData.id!),
      description: description,
      title: titleController.text,
      folderName: widget.folderName,
      createdDate: Helper.formattedDate(),
    );

    DBHelper.updateNote(addNote).then((value) {
      Navigator.pop(context, true);
      Helper.showSnackVar('Successfully Updated (Offline)', Colors.green, context);
      titleController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 102,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assest/images/OnBordScreenTopScreen.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: kWhiteColor),
                  ),
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
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      "assest/png_icon/home_removebg_preview.png",
                      height: 25,
                      width: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: customtext(
                        fontWeight: FontWeight.w500,
                        text: "Edit Note",
                        color: Theme.of(context).primaryColor,
                        fontsize: 20,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      hight: 50,
                      title: "Enter Title",
                      controller: titleController,
                      hint: "Title",
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      lableName: "Title",
                      hintfont: 12,
                      lablefont: 14,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: customtext(
                        fontWeight: FontWeight.w500,
                        text: "Description",
                        color: Theme.of(context).primaryColor,
                        fontsize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    HtmlEditor(
                      controller: htmlController,
                      htmlEditorOptions: HtmlEditorOptions(
                        hint: 'Start typing...',
                        shouldEnsureVisible: true,
                        initialText: widget.showNoteModalData.description ?? '',
                      ),
                      htmlToolbarOptions: HtmlToolbarOptions(
                        defaultToolbarButtons: [
                          FontButtons(),
                          ParagraphButtons(),
                          InsertButtons(),
                          OtherButtons()
                        ],
                      ),
                      otherOptions: OtherOptions(height: 300),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        height: 50,
        child: custom_Button(
          onTap: () => editNote(),
          title: "Save",
          hight: 45,
          width: 140,
          fontSize: 20,
        ),
      ),
    );
  }
}
