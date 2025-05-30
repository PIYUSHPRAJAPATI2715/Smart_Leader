import 'package:flutter/material.dart';
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

class AddFolderWidget extends StatefulWidget {
  const AddFolderWidget({Key? key}) : super(key: key);

  @override
  State<AddFolderWidget> createState() => _AddFolderWidgetState();
}

class _AddFolderWidgetState extends State<AddFolderWidget> {
  bool isSubmit = false;

  final TextEditingController foldernameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addFold() async {
    if (foldernameController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Folder Name', Colors.red, context);
      return;
    }

    bool isNetwork = await Helper.isNetworkAvailable();
    if (isNetwork) {
      Map<String, String> body = {
        "folder_name": foldernameController.text,
        "user_id": SessionManager.getUserID()
      };

      setState(() {
        isSubmit = true;
      });

      ApiHelper.addFolder(body).then((login) {
        setState(() {
          isSubmit = false;
        });

        if (login.message == 'Folder Add Successfully ') {
          //Helper.showSnackVar('Successfully Added', Colors.green, context);
          addFolderOffline();
        } else {
          Helper.showSnackVar('Error', Colors.red, context);
        }
      });
    } else {
      addFolderOffline();
    }
  }

  void addFolderOffline() async {
    Folder folder = Folder(
        folderName: foldernameController.text,
        createdOn: Helper.formattedDate());

    int value = await DBHelper.insertFolder(folder);
    Helper.toastMassage('Folder added', Colors.green);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).scaffoldBackgroundColor,
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
                            text: "Add Folder",
                            color: Theme.of(context).primaryColor,
                            alignment: TextAlign.center,
                            fontsize: 20)),
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
                const SizedBox(height: 20),
                CustomTextField(
                    hight: 50,
                    title: "Enter Folder Name",
                    controller: foldernameController,
                    hint: "Folder Name",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.text,
                    lableName: "Folder Name",
                    hintfont: 12,
                    lablefont: 14),
                const SizedBox(height: 30),
                custom_Button(
                    onTap: () {
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
