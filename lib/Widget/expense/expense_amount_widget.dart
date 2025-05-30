import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';

class ExpenseAmountWidget extends StatelessWidget {
  const ExpenseAmountWidget({
    super.key,
    required this.title,
    required this.amount,
    required this.textColor,
  });

  final String title;
  final String amount;
  final Color textColor;

  // final String amountColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 1.5)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customtext(
              fontWeight: FontWeight.w400,
              text:title,
              color: Theme.of(context).primaryColor,
              fontsize: 12.0),
          customtext(
              fontWeight: FontWeight.w700,
              text: amount,
              color: textColor,
              fontsize: 15.0),
        ],
      ),
    );
  }
}
