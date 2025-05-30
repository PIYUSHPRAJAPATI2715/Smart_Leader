import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_dropdown.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/branch.dart';
import 'package:smart_leader/Provider/app_controller.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({Key? key, required this.teamType}) : super(key: key);

  final String teamType;

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<BranchData> branchList = [];
  bool isBranchLoading = false;
  late BranchData selectedBranch = BranchData();

  String readableAmount = '';

  // String type = 'Hundred';

  String selecteddate = 'Select Month';

  bool isSubmit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AppController>(context, listen: false).unitFormat = '0';

    selecteddate = DateFormat('MMM-yyyy').format(DateTime.now());
    getBranches();
  }

  void getBranches() {
    setState(() {
      isBranchLoading = true;
    });
    ApiHelper.showBranch().then((value) {
      setState(() {
        isBranchLoading = false;
      });
      branchList = value.data!;
      if (branchList.isNotEmpty) {
        selectedBranch = branchList[0];
      } else {
        Navigator.pop(context);
        Helper.toastMassage('Please add at least one team', Colors.red);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
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
                          text: "Add Key Leader",
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
                isBranchLoading
                    ? const Center(child: CircularProgressIndicator())
                    : BranchDropDown(
                        lableName: 'Select Team',
                        color: Colors.black,
                        hint: 'Select Team',
                        onSelect: (value) {
                          BranchData data = value as BranchData;
                          selectedBranch = data;
                          setState(() {});
                        },
                        items: branchList,
                        valueType: selectedBranch),
                const SizedBox(height: 15.0),
                CustomTextField(
                  hight: 50,

                  title: "Enter Key Leader Name",
                  controller: titleController,
                  hint: "fff",
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.text,
                  lableName: "Key Leader Name",
                  hintfont: 13,
                  lablefont: 13,
                  gapHight: 10,
                ),
                const SizedBox(height: 15),
                CustomAmountTextField(
                  hight: 50,
                  title: "Enter amount",
                  controller: priceController,
                  hint: "fff",

                  inputAction: TextInputAction.next,
                  inputType: TextInputType.number,
                  lableName: "Target Business",
                  hintfont: 11,
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
                const SizedBox(height: 25.0),
                isSubmit
                    ? const Center(child: CircularProgressIndicator())
                    : custom_Button(
                        onTap: () {
                          if (widget.teamType == 'Individual') {
                            addIndividualTeam();
                          } else {
                            addTeam();
                          }
                        },
                        title: "Save",
                        hight: 45,
                        width: 150,
                        fontSize: 14),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTeam() {
    if (titleController.text.isEmpty) {
      toastMassage("Please Enter Key Leader Name", Colors.red);
      return;
    }
    if (priceController.text.isEmpty) {
      toastMassage("Please Enter Target Amount", Colors.red);
      return;
    }

    if (selecteddate == 'Select Month') {
      toastMassage("Please Select Month", Colors.red);
      return;
    }

    Map<String, String> body = {
      'team_name': titleController.text,
      'user_id': SessionManager.getUserID(),
      'target_amount': priceController.text.trim(),
      'my_amount': priceController.text.trim(),
      'month_year': selecteddate,
      'branch_id': selectedBranch.id!
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.addTeam(body).then((value) {
      setState(() {
        isSubmit = false;
      });

      if (value.message == 'Team Add Successfully ') {
        toastMassage(value.message!, Colors.green);
        Navigator.pop(context, true);
      } else {
        toastMassage(value.message!, Colors.red);
      }
    });
  }

  void addIndividualTeam() {
    if (titleController.text.isEmpty) {
      toastMassage("Please Enter Title", Colors.red);
      return;
    }
    if (priceController.text.isEmpty) {
      toastMassage("Please Enter Price", Colors.red);
      return;
    }

    if (selecteddate == 'Select Month') {
      toastMassage("Please Select Month", Colors.red);
      return;
    }

    Map<String, String> body = {
      'team_name': titleController.text,
      'user_id': SessionManager.getUserID(),
      'target_amount': priceController.text.trim(),
      'month_year': selecteddate
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.addIndividualTeam(body).then((value) {
      setState(() {
        isSubmit = false;
      });

      if (value.message == 'Team Add Successfully ') {
        toastMassage(value.message!, Colors.green);
        Navigator.pop(context, true);
      } else {
        toastMassage(value.message!, Colors.red);
      }
    });
  }

  void toastMassage(String Massage, Color color) {
    Fluttertoast.showToast(
        msg: Massage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

/*
   Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hight: 50,
                      title: "Enter Price",
                      controller: priceController,
                      hint: "fff",
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.number,
                      lableName: "Price",
                      hintfont: 12,
                      lablefont: 14,
                      gapHight: 10,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CustomDropDown(
                        lableName: "Type",
                        hint: "",
                        onChange: (String? value) {
                          setState(() {
                            type = value!;
                          });
                        },
                        items: <String>['Hundred', 'Thousand', 'Lakh', "Crore"],
                        valueType: type),
                  ),
                ],
              ),
   */
