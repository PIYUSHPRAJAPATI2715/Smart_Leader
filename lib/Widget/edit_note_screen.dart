import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../Componants/Custom_text.dart';
import '../Componants/custom_bottun.dart';
import '../Componants/custom_description_textfield.dart';
import '../Componants/custom_textField.dart';
import '../Helper/theme_colors.dart';

class EditNoteScreen extends StatefulWidget {
  final String id;
  final String folderName;

  const EditNoteScreen({super.key,
    required this.id,
    required this.folderName,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  bool isSubmit = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selecteddate = 'Select Date';
  String selectedtime = "Select Time";
  bool newLine = false;
  final QuillController _controller = QuillController.basic();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text=widget.folderName;
  }

  final FocusNode _focus = FocusNode();

  String hintTitle = 'Title';
  String hintDesc = 'Description';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
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
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  customtext(
                      fontWeight: FontWeight.w500,
                      text: "Edit Note",
                      color: Theme.of(context).primaryColor,
                      fontsize: 20),
                  const SizedBox(height: 15),
                  CustomTextField(
                      hight: 50,
                      title: "Enter Title",
                      controller: titleController,
                      hint: hintTitle,
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      lableName: hintTitle,
                      hintfont: 13,
                      lablefont: 15),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: customtext(
                        fontWeight: FontWeight.w500,
                        text: hintDesc,
                        color: Colors.black,
                        fontsize: 15),
                  ),
                   const SizedBox(height: 15),
                  // CustomDescriptionTextfield(
                  //     focusNode: FocusNode(),
                  //     onchanged: (value) {
                  //
                  //     },
                  //     boxHight: 150,
                  //     title: "",
                  //     controller: descriptionController,
                  //     hint: "Enter Description",
                  //     inputAction: TextInputAction.newline,
                  //     inputType: TextInputType.multiline,
                  //     lableName: "Description",
                  //     hintfont: 13,
                  //     lablefont: 14),
                  // const SizedBox(height: 7.0),


                  //todo: uncomment these lines : for quill editor
                  /*Expanded(
                    child: QuillProvider(
                      configurations: QuillConfigurations(
                        controller: _controller,
                        sharedConfigurations: const QuillSharedConfigurations(
                          locale: Locale('en'),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: QuillEditor.basic(
                                configurations: const QuillEditorConfigurations(
                                  readOnly: false,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const QuillToolbar(
                            configurations: QuillToolbarConfigurations(
                              showCenterAlignment: false,
                              showSubscript: false,
                              showSuperscript: false,
                              showRedo: false,
                              showUndo: false,
                              showFontFamily: false,
                              showFontSize: false,
                              showHeaderStyle: false,
                              showInlineCode: false,
                              showIndent: false,
                              showLink: false,
                              showSearchButton: false,
                              showBackgroundColorButton: false,
                              showCodeBlock: false,
                              showDividers: false,
                              showColorButton: false,
                              showJustifyAlignment: false,
                              showQuote: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),*/


                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: KBoxNewColor),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: QuillEditor.basic(
                        controller: _controller,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),
                  //todo: uncomment these lines : for quill editor
                  /*
                  QuillToolbar.basic(
                    controller: _controller,
                    showRedo: false,
                    showUndo: false,
                    showFontFamily: false,
                    showFontSize: false,
                    showHeaderStyle: false,
                    showInlineCode: false,
                    showIndent: false,
                    showLink: false,
                    showSearchButton: false,
                    showBackgroundColorButton: false,
                    showCodeBlock: false,
                    showDividers: false,
                    showColorButton: false,
                    showJustifyAlignment: false,
                    showQuote: false,
                  ),
                  */
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
        height: 50,
        child: isSubmit == true
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : custom_Button(
            onTap: () {
              setState(() {
                //addNote();
              });
            },
            title: "Save",
            hight: 45,
            width: double.infinity,
            fontSize: 20),
      ),
    );
  }
}
