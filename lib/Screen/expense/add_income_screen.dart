import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_dropdown.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/LocalDatabase/modals/expense.dart';
import 'package:smart_leader/Provider/expense_controller.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

import '../../Helper/helper.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({Key? key}) : super(key: key);

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  String selectedDate = 'Select Date';
  String readableAmount = '';
  String readableDate = '';

  List<String> categoryList = [
    'Select Category',
    'Direct Selling',
    'Traditional Business',
    'Salary',
    'Portfolio Income',
    'Other'
  ];
  String selectedCat = 'Select Category';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopContainer(
              onTap: () {
                Navigator.pop(context);
              },
              title: "SmartLeader"),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customtext(
                    fontWeight: FontWeight.w500,
                    text: 'New Income',
                    fontsize: 22.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 25.0),
                  const customtext(
                    fontWeight: FontWeight.w500,
                    text: 'Date',
                    fontsize: 13.0,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1800),
                        lastDate: DateTime(2050),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: KBoxNewColor, // Header background color
                                onPrimary: Colors.white, // Header text color
                                onSurface: Colors.black, // Body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: KBoxNewColor, // Button text color
                                ),
                              ),
                            ),
                            child: Builder(
                              builder: (context) => child == null
                                  ? const SizedBox()
                                  : Theme(
                                data: Theme.of(context).copyWith(
                                  // Customizing decorations
                                  dialogBackgroundColor: Colors.white, // Calendar background
                                  highlightColor: KBoxNewColor, // Today/Selected highlight
                                ),
                                child: child,
                              ),
                            ),
                          );
                        },
                      ).then((value) {
                        if (value != null) {
                          selectedDate = DateFormat('yyyy-MM-dd').format(value);
                          readableDate = DateFormat('MMMM-yy').format(value);
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: kblueColor, width: 1.2),
                          color: SessionManager.getTheme() == true
                              ? kblueColor
                              : kWhiteColor),
                      child: Center(
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: customtext(
                                fontWeight: FontWeight.w500,
                                text: (selectedDate),
                                fontsize: 13,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  CustomAmountTextField(
                    hight: 50,
                    title: "Enter amount",
                    controller: amountController,
                    hint: "fff",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.number,
                    lableName: "Income Amount",
                    hintfont: 11,
                    lablefont: 12,
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
                  const SizedBox(height: 15.0),
                  const customtext(
                    fontWeight: FontWeight.w500,
                    text: 'Category',
                    fontsize: 13.0,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: FilterDropDownWidget(
                        height: 50,
                        initialValue: selectedCat,
                        items: categoryList,
                        onChange: (value) {
                          setState(() {
                            selectedCat = value;
                          });
                        }),
                  ),
                  Visibility(
                    visible: selectedCat.toLowerCase() == 'other',
                    child: Column(
                      children: [
                        const SizedBox(height: 15.0),
                        CustomTextField(
                            hight: 50,
                            title: "Enter other type",
                            controller: otherController,
                            hint: "Number",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.text,
                            lableName: "Other",
                            hintfont: 12,
                            lablefont: 14),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  CustomTextField(
                      hight: 50,
                      title: "Enter note",
                      controller: reasonController,
                      hint: "Number",
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      lableName: "Note",
                      hintfont: 12,
                      lablefont: 14),
                  const SizedBox(height: 25.0),
                  custom_Button(
                      onTap: addIncome,
                      title: "Add Income",
                      hight: 45,
                      width: 180,
                      fontSize: 15)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void addIncome() {
    final expenseController =
        Provider.of<ExpenseController>(context, listen: false);

    String amount = amountController.text;
    String note = reasonController.text;
    String other = otherController.text;

    if (selectedDate == 'Select Date') {
      Helper.showSnackVar('Select date', Colors.red, context);
      return;
    }

    if (amount.isEmpty) {
      Helper.showSnackVar('Enter amount', Colors.red, context);
      return;
    }

    if (selectedCat == 'Select Category') {
      Helper.showSnackVar('Select category', Colors.red, context);
      return;
    }

    if (selectedCat.toLowerCase() == 'other') {
      if (other.isEmpty) {
        Helper.showSnackVar('Enter other type', Colors.red, context);
        return;
      }
    }

    if (note.isEmpty) {
      note = '';
    }

    Expense expense = Expense(
        date: selectedDate,
        amount: amount,
        category: selectedCat,
        note: note,
        type: 'Income',
        readableDate: readableDate,
        other: other ?? '');

    expenseController.addExpense(expense);
    clear();
    Helper.showSnackVar(
      'Income added successfully',
      Colors.green.shade600,
      context,
    );
    Navigator.pop(context);
  }

  void clear() {
    setState(() {});
    selectedCat = 'Select Category';
    amountController.clear();
    readableDate = '';
    readableAmount = '';
    otherController.clear();
    reasonController.clear();
    selectedDate = 'Select Date';
  }
}
