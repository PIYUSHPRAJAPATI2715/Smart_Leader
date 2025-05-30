import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Button2.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class AddConnectionFolderWidget extends StatefulWidget {
  const AddConnectionFolderWidget({Key? key}) : super(key: key);

  @override
  State<AddConnectionFolderWidget> createState() => _AddConnectionFolderWidgetState();
}

class _AddConnectionFolderWidgetState extends State<AddConnectionFolderWidget> {
  bool isSubmit = false;

  final TextEditingController foldernameController = TextEditingController();

  void addFold() async {

    if (foldernameController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Folder Name', Colors.red, context);
      return;
    }


    Map<String, String> body = {
      "name":foldernameController.text,
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.addConnectFolder(body).then((login) {
      setState(() {
        isSubmit = false;
      });


      if (login.message == 'Connection Type Add Successfully ') {

        Navigator.pop(context,true,);

        Helper.showSnackVar(
            'Successfully Added', Colors.green, context);

      } else {
        Helper.showSnackVar(
            'Error', Colors.red, context);
      }

    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme
              .of(context)
              .scaffoldBackgroundColor,
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
                    Expanded(
                      child: customtext(
                          fontWeight: FontWeight.w500,
                          text: "Add Connection Folder",
                          alignment: TextAlign.center,
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontsize: 18),
                    ),
                    CustomRoundedBottun2(
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
                        })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(hight: 50,
                    title: "Enter Folder Name",
                    controller: foldernameController,
                    hint: "Folder Name",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    lableName: "Folder Name",
                    hintfont: 12,
                    lablefont: 14),
                SizedBox(
                  height: 8,
                ),
                SizedBox(height: 30,),
                isSubmit==true?Center(child: CircularProgressIndicator(),):custom_Button(onTap: () {
                  setState(() {
                    addFold();
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
}
