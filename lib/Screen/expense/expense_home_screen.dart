import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_button_widget.dart';
import 'package:smart_leader/Componants/custom_dropdown.dart';
import 'package:smart_leader/Provider/expense_controller.dart';
import 'package:smart_leader/Screen/expense/add_expense_screen.dart';
import 'package:smart_leader/Screen/expense/add_income_screen.dart';
import 'package:smart_leader/Screen/expense/all_expense_transaction_screen.dart';
import 'package:smart_leader/Screen/expense/expense_analysis_screen.dart';
import 'package:smart_leader/Screen/expense/monthly_expense_analysis_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:smart_leader/Widget/expense/analysis_container_widget.dart';
import 'package:smart_leader/Widget/expense/expense_amount_widget.dart';
import 'package:smart_leader/Widget/expense_transaction_widget.dart';

import '../../Helper/helper.dart';

class ExpenseHomeScreen extends StatefulWidget {
  const ExpenseHomeScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseHomeScreen> createState() => _ExpenseHomeScreenState();
}

class _ExpenseHomeScreenState extends State<ExpenseHomeScreen> {
  late Future expenseFuture;

  Future<void> getExpense() async {
    return Provider.of<ExpenseController>(context, listen: false).getExpense();
  }

  @override
  void initState() {
    super.initState();
    expenseFuture = getExpense();
  }

  @override
  Widget build(BuildContext context) {
    final expenseData = Provider.of<ExpenseController>(context);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: expenseFuture,
                          builder: (context, response) {
                            if (response.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (expenseData.expenseList.isEmpty) {
                              return const Center(
                                child: customtext(
                                    fontWeight: FontWeight.w600,
                                    text: 'No monthly transaction',
                                    color: Colors.red,
                                    fontsize: 15.0),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FilterDropDownWidget(
                                    initialValue:
                                        expenseData.expenseSelectedMonth,
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
                                        amount:
                                            '₹${Helper.formatUnitType(int.parse(expenseData.totalAmount.toInt().toString()))}',
                                        textColor: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 15.0),
                                    Expanded(
                                      child: ExpenseAmountWidget(
                                        title: 'Expenses',
                                        amount:
                                            '₹${Helper.formatUnitType(int.parse(expenseData.expenseAmount.toInt().toString()))}',
                                        textColor: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 15.0),
                                    Expanded(
                                      child: ExpenseAmountWidget(
                                          title: 'Net Balance',
                                          amount:
                                              '₹${Helper.formatUnitType(int.parse(expenseData.remainingAmount.toInt().toString()))}',
                                          textColor:
                                              expenseData.remainingAmount > 0
                                                  ? Colors.green
                                                  : Colors.red),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    customtext(
                                        fontWeight: FontWeight.w700,
                                        text: 'Monthly Transaction',
                                        color: Theme.of(context).primaryColor,
                                        fontsize: 14.0),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AllExpenseTransactionScreen(
                                                        selectedMonth: expenseData
                                                            .expenseSelectedMonth)));
                                      },
                                      child: const customtext(
                                          fontWeight: FontWeight.w700,
                                          text: 'View All',
                                          color: Colors.blue,
                                          fontsize: 12.0),
                                    )
                                  ],
                                ),
                                MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.builder(
                                    itemCount: expenseData
                                                .expenseFilteredList.length <
                                            3
                                        ? expenseData.expenseFilteredList.length
                                        : 3,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ExpenseTransactionWidget(
                                        expense: expenseData
                                            .expenseFilteredList[index],
                                      );
                                    },
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5),
                                ),
                                customtext(
                                    fontWeight: FontWeight.w700,
                                    text: 'Analysis',
                                    color: Theme.of(context).primaryColor,
                                    fontsize: 20.0),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: AnalysisContainerWidget(
                                      icon: Icons.calendar_view_week_rounded,
                                      text: 'Weekly Analysis',
                                      onClick: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ExpenseAnalysisScreen(
                                              type: 'Weekly',
                                              days: 7,
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                                    const SizedBox(width: 15.0),
                                    Expanded(
                                      child: AnalysisContainerWidget(
                                        icon: Icons.calendar_month_rounded,
                                        text: 'Monthly Analysis',
                                        onClick: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MonthlyExpenseAnalysisScreen()));
                                        },
                                      ),
                                    ),
                                    /* const SizedBox(width: 15.0),
                                    Expanded(
                                        child: AnalysisContainerWidget(
                                      icon: Icons.calendar_today_rounded,
                                      text: 'Overall Analysis',
                                      onClick: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ExpenseAnalysisScreen(
                                                      type: 'Yearly',
                                                      days: 365,
                                                    )));
                                      },
                                    )),*/
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          title: 'Expense',
                          btnColor: Colors.red.shade600,
                          onClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddExpenseScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: CustomButtonWidget(
                          btnColor: Colors.green.shade600,
                          title: 'Income',
                          onClick: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddIncomeScreen()));
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
