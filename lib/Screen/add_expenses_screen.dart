import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Button2.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:intl/intl.dart';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({Key? key}) : super(key: key);

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  String selecteddate = 'Select Date';
  String priority = '';


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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                            flex: 4,
                            child: customtext(
                                fontWeight: FontWeight.w500,
                                text: "+Add Expenses",
                                color: Theme.of(context).primaryColor,
                                fontsize: 20)),
                        Expanded(
                            child: CustomRoundedBottun2(
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
                                }))
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    CustomTextField(
                        hight: 50,
                        title: "Enter Amount",
                        controller: amountController,
                        hint: "Name",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        lableName: "Amount",
                        hintfont: 12,
                        lablefont: 14),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        hight: 50,
                        title: "Enter Reason",
                        controller: reasonController,
                        hint: "Number",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        lableName: "Reason",
                        hintfont: 12,
                        lablefont: 14),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Date",
                            fontsize: 14,
                            color: SessionManager.getTheme() == true
                                ? kWhiteColor
                                : kbuttonColor,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1800),
                                    lastDate: DateTime(2050))
                                .then((value) {
                              print(value);
                              selecteddate =
                                  DateFormat('yyyy-MM-dd').format(value!);
                              setState(() {});
                              print(selecteddate);
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: kBlackColor, width: 1.2),
                                color: SessionManager.getTheme() == true
                                    ? kscafolledColor
                                    : kWhiteColor),
                            child: Center(
                                child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: customtext(
                                    fontWeight: FontWeight.w700,
                                    text: (selecteddate),
                                    fontsize: 12,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: customtext(
                        fontWeight: FontWeight.w500,
                        text: "Priority",
                        fontsize: 14,
                        color: SessionManager.getTheme() == true
                            ? kWhiteColor
                            : kbuttonColor,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                                color: kredColor,
                                border: Border.all(
                                    color: priority == 'High'
                                        ? Colors.black
                                        : kredColor,
                                    width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            child: customtext(
                              fontWeight: FontWeight.w700,
                              text: "High",
                              fontsize: 14,
                              color: kWhiteColor,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              priority = 'High';
                            });
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              priority = 'Medium';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: priority == 'Medium'
                                        ? Colors.black
                                        : kyelloColor,
                                    width: 2),
                                color: kyelloColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: customtext(
                              fontWeight: FontWeight.w700,
                              text: "Medium",
                              fontsize: 14,
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              priority = 'Low';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: priority == 'Low'
                                        ? Colors.black
                                        : kgreen2Color,
                                    width: 2),
                                color: kgreen2Color,
                                borderRadius: BorderRadius.circular(10)),
                            child: customtext(
                              fontWeight: FontWeight.w700,
                              text: "Low",
                              fontsize: 14,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    custom_Button(
                        onTap: _addExpense,
                        title: "Save",
                        hight: 45,
                        width: 140,
                        fontSize: 20)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addExpense() {
    String amount = amountController.text;
    String reason = reasonController.text;

    if (amount.isEmpty) {
      Helper.showSnackVar('Enter amount', Colors.red, context);
      return;
    }

    if (reason.isEmpty) {
      Helper.showSnackVar('Enter reason', Colors.red, context);
      return;
    }

    if (selecteddate == 'Select Date') {
      Helper.showSnackVar('Select date', Colors.red, context);
      return;
    }

    if (priority.isEmpty) {
      Helper.showSnackVar('Select prioroty', Colors.red, context);
      return;
    }

    Helper.showLoaderDialog(context, message: 'Add...');

    Map<String, String> body = {
      'user_id': SessionManager.getUserID(),
      'amount': amount,
      'reason': reason,
      'date': selecteddate,
      'priority': priority
    };

    ApiHelper.addExpense(body).then((value) {
      Navigator.pop(context);
      if (value.message == 'Expense Add Successfully ') {
        Helper.showSnackVar(value.message!, Colors.green, context);
        clear();
      } else {
        Helper.showSnackVar('Failed to add expense', Colors.red, context);
      }
    });
  }

  void clear() {
    amountController.clear();
    reasonController.clear();
    selecteddate = 'Select Date';
    priority = '';
    setState(() {});
  }
}
