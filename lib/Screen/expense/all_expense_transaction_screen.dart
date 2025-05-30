import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_dropdown.dart';
import 'package:smart_leader/Provider/expense_controller.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:smart_leader/Widget/expense/analysis_container_widget.dart';
import 'package:smart_leader/Widget/expense/expense_amount_widget.dart';
import 'package:smart_leader/Widget/expense_transaction_widget.dart';

import '../../Helper/helper.dart';

class AllExpenseTransactionScreen extends StatefulWidget {
  const AllExpenseTransactionScreen({Key? key,required this.selectedMonth}) : super(key: key);

  final String selectedMonth;
  @override
  State<AllExpenseTransactionScreen> createState() =>
      _AllExpenseTransactionScreenState();
}

class _AllExpenseTransactionScreenState
    extends State<AllExpenseTransactionScreen> {
  late Future expenseFuture;

  Future<void> getExpense() async {
    return Provider.of<ExpenseController>(context, listen: false).getExpenseByMonth(widget.selectedMonth);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expenseFuture = getExpense();
  }

  @override
  Widget build(BuildContext context) {
    final expenseData = Provider.of<ExpenseController>(context);
    return Scaffold(
      body: Column(
        children: [
          TopContainer(
              onTap: () {
                Navigator.pop(context);
              },
              title: ""),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customtext(
                      fontWeight: FontWeight.w700,
                      text: 'Monthly Transaction',
                      color: Theme.of(context).primaryColor,
                      fontsize: 18.0),
                  const SizedBox(height: 15.0),
                  FilterDropDownWidget(
                      initialValue: expenseData.expenseSelectedMonth,
                      items: expenseData.monthList,
                      onChange: (value) {
                        expenseData.getExpenseByMonth(value);
                      }),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: ExpenseAmountWidget(
                          title: 'Income',
                          amount: '₹${Helper.formatUnitType(int.parse(expenseData.totalAmount.toInt().toString()))}',
                          textColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: ExpenseAmountWidget(
                          title: 'Expenses',
                          amount: '₹${Helper.formatUnitType(int.parse(expenseData.expenseAmount.toInt().toString()))}',
                          textColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: ExpenseAmountWidget(
                          title: 'Net Balance',
                          amount: '₹${Helper.formatUnitType(int.parse(expenseData.remainingAmount.toInt().toString()))}',
                          textColor:
                            expenseData.remainingAmount > 0
                            ? Colors.green
                                : Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                     itemCount: expenseData.expenseFilteredList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ExpenseTransactionWidget(
                          expense: expenseData.expenseFilteredList[index],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
