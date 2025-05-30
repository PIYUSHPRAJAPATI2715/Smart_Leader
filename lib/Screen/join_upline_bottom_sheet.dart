import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Componants/Custom_text.dart';
import '../Componants/custom_bottun.dart';
import '../Componants/custom_textField.dart';
import '../Componants/session_manager.dart';
import '../Helper/Api.helper.dart';
import '../Helper/helper.dart';
import '../Helper/theme_colors.dart';

class JoinUplineBottomSheet extends StatefulWidget {
  const JoinUplineBottomSheet({super.key});

  @override
  State<JoinUplineBottomSheet> createState() => _JoinUplineBottomSheetState();
}

class _JoinUplineBottomSheetState extends State<JoinUplineBottomSheet> {
  final TextEditingController _teamIdController = TextEditingController();
  final TextEditingController _targetAmtController = TextEditingController();
  String readableAmount = '';
  String selecteddate = 'Select Month';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selecteddate = DateFormat('MMM-yyyy').format(DateTime.now());

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 25, right: 25,bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(width: 2,color: kblueColor),
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: customtext(
                          fontWeight: FontWeight.w500,
                          text: "Join Through Upline",
                          color: Theme.of(context).primaryColor,
                          fontsize: 20),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
                const Divider(),
                CustomTextField(
                    hight: 50.0,
                    title: 'Enter Team Id',
                    controller: _teamIdController,
                    hint: '',
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.text,
                    lableName: 'Team Id',
                    hintfont: 12,
                    lablefont: 12),
                const SizedBox(height: 15.0),
                CustomAmountTextField(
                  hight: 50,
                  title: "Enter Business",
                  controller: _targetAmtController,
                  hint: "fff",
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.number,
                  lableName: "Target Business",
                  hintfont: 12,
                  lablefont: 14,
                  gapHight: 10,
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        int number = int.parse(value);
                        // data.formatUnitType(number);
                        readableAmount = Helper.formatUnitType(number);
                      } else {
                        //  data.formatUnitType(0);
                        readableAmount = '';
                      }
                    });
                  },
                  unitType: readableAmount,
                ),
                const SizedBox(height: 15),
                customtext(
                    fontWeight: FontWeight.w500,
                    text: 'Month',
                    fontsize: 13,
                    color: SessionManager.getTheme() == true
                        ? kWhiteColor
                        : Colors.black),
                const SizedBox(height: 8.0),
                InkWell(
                  onTap: () {
                    // showDatePicker(
                    //   context: context,
                    //   initialDate: DateTime.now(),
                    //   firstDate: DateTime.now(),
                    //   lastDate: DateTime(
                    //       DateTime.now().year, DateTime.now().month + 1, 0),
                    //
                    // ).then((value) {
                    //   selecteddate = DateFormat('MMM-yyyy').format(value!);
                    //   setState(() {});
                    // });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: kblueColor, width: 1.0),
                        color: SessionManager.getTheme() == true
                            ? kblueColor
                            : kWhiteColor),
                    child: Center(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: customtext(
                              fontWeight: FontWeight.w500,
                              text: selecteddate,
                              fontsize: 13,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: custom_Button(
                      onTap: joinTeam,
                      title: 'Join',
                      hight: 50,
                      width: 120,
                      fontSize: 14.0),
                ),
                const SizedBox(height: 15.0),
                const Divider(color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void joinTeam() {
    if (_teamIdController.text.isEmpty) {
      Helper.showSnackVar('Enter Team Id', Colors.red, context);
      return;
    }

    if (_targetAmtController.text.isEmpty) {
      Helper.showSnackVar('Enter Target Amount', Colors.red, context);
      return;
    }

    Map<String, String> body = {
      //SessionManager.getUserID()
      'user_id': SessionManager.getUserID(),
      'team_id': _teamIdController.text,
      'member_name': SessionManager.getFirstName(),
      'member_target': _targetAmtController.text,
      'my_amount': _targetAmtController.text
    };

    Helper.showLoaderDialog(context, message: 'Adding...');

    ApiHelper.joinTeam(body).then((value) {
      Navigator.pop(context);
      if (value.message == 'Sub team added successfully') {
        _teamIdController.clear();
        _targetAmtController.clear();

        Helper.showSnackVar(value.message!, Colors.green, context);
        Navigator.pop(context);
        // setState(() {
        //   joinedFuture = getJoinedTeam();
        // });
      } else {
        Helper.showSnackVar(value.message!, Colors.red, context);
      }
    });
  }

}
