import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/LocalDatabase/modals/expense.dart';

import '../Helper/helper.dart';

class ExpenseTransactionWidget extends StatelessWidget {
  const ExpenseTransactionWidget({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: expense.type == 'Income'
              ? Colors.green.shade50
              : Colors.red.shade50,
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: customtext(
                fontWeight: FontWeight.w700,
                text: expense.category!,
                fontsize: 13.0,
                color: Theme.of(context).primaryColor,
              )),
              customtext(
                fontWeight: FontWeight.w600,
                text: expense.date!,
                fontsize: 10.0,
                color: Colors.black,
              )
            ],
          ),
          const SizedBox(height: 5.0),
          customtext(
            fontWeight: FontWeight.w700,
            text:
                '₹${Helper.formatUnitType(int.parse(expense.amount.toString()))}',
            fontsize: 18.0,
            color: expense.type == 'Income'
                ? Colors.green.shade600
                : Colors.red.shade600,
          ),
          Row(
            children: [
              Expanded(
                  child: customtext(
                fontWeight: FontWeight.w700,
                text: 'Note:${expense.note}',
                fontsize: 10.0,
                color: Colors.black54,
              )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                decoration: BoxDecoration(
                    color: expense.type == 'Income'
                        ? Colors.green.shade600
                        : Colors.red.shade600,
                    borderRadius: BorderRadius.circular(10.0)),
                child: customtext(
                  fontWeight: FontWeight.w600,
                  text: expense.type!,
                  fontsize: 12.0,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
