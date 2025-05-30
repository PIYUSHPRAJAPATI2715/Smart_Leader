import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/LocalDatabase/modals/expense.dart';

class ExpenseController extends ChangeNotifier {
  bool isAdded = false;

  void addExpense(Expense expense) async {
    int response = await DBHelper.insertExpense(expense);
    getExpense();
    notifyListeners();
  }

  List<Expense> expenseList = [];
  List<Expense> expenseFilteredList = [];
  List<String> monthList = [];
  String expenseSelectedMonth = '';

  double totalAmount = 0;
  double expenseAmount = 0;
  double remainingAmount = 0;

  Future<void> getExpense() async {
    expenseList.clear();
    expenseList = await DBHelper.getExpense();

    for (var expense in expenseList) {
      if (!monthList.contains(expense.readableDate)) {
        monthList.add(expense.readableDate!);
      }
    }
    expenseSelectedMonth = monthList[0];
    getExpenseByMonth(expenseSelectedMonth);

    notifyListeners();
  }

  Future<void> getExpenseByMonth(String date) async {
    totalAmount = 0;
    expenseAmount = 0;
    remainingAmount = 0;
    expenseSelectedMonth = date;
    expenseFilteredList = await DBHelper.getExpenseByMonth(date);

    expenseFilteredList.sort((a, b) => a.date!.compareTo(b.date!));

    //  expenseFilteredList = expenseFilteredList.reversed.toList();

    for (var expense in expenseFilteredList) {
      if (expense.type!.toLowerCase() == 'income') {
        totalAmount += double.parse(expense.amount ?? '0');
      } else {
        expenseAmount += double.parse(expense.amount ?? '0');
      }
    }

    remainingAmount = totalAmount - expenseAmount;

    notifyListeners();
  }

  List<Expense> weeklyExpenseList = [];
  double weeklyTotalAmount = 0;
  String filterWeeklyInEx = 'Expense';

  Future<void> getWeeklyExpense(int days, String filter) async {
    weeklyExpenseList.clear();
    weeklyTotalAmount = 0;
    filterWeeklyInEx = filter;

    List<Expense> expenseList = await DBHelper.getExpense();

    for (var expense in expenseList) {
      Expense updateExpense = Expense(
        id: expense.id,
        other: expense.other,
        readableDate: expense.readableDate,
        type: expense.type,
        note: expense.note,
        category: expense.category,
        amount: expense.amount,
        date: expense.date,
        dateTime: Helper.stringToDate(expense.date!),
        color: Helper.getRandomColor(),
      );
      weeklyExpenseList.add(updateExpense);
    }

    //todo: Filter transactions for the current week
    List<Expense> filteredList = [];
    if (days == 7) {
      DateTime now = DateTime.now();
      // Get the start date of the current week (Monday)
      DateTime thisMonday = now.subtract(Duration(days: now.weekday - 1));
      filteredList = weeklyExpenseList.where((transaction) {
        return transaction.dateTime!
                .isAfter(thisMonday.subtract(const Duration(days: 1))) &&
            transaction.dateTime!.isBefore(now.add(const Duration(days: 1)));
      }).toList();
    } else {
      DateTime firstDayOfMonth =
          DateTime.now().subtract(Duration(days: DateTime.now().day - 1));
      // Get the end date of the current month
      DateTime lastDayOfMonth =
          DateTime(firstDayOfMonth.year, firstDayOfMonth.month + 1, 0);

      // Filter transactions for the current month
      filteredList = weeklyExpenseList.where((transaction) {
        return transaction.dateTime!
                .isAfter(firstDayOfMonth.subtract(const Duration(days: 1))) &&
            transaction.dateTime!
                .isBefore(lastDayOfMonth.add(const Duration(days: 1)));
      }).toList();
    }

    weeklyExpenseList.clear();

    /*for (var week in filteredList) {
      if (week.type!.toLowerCase() == 'expense') {
        weeklyExpenseList.add(week);
      }
    }

    for (var filter in filteredList) {
      if (filter.type!.toLowerCase() == 'income') {
        weeklyTotalAmount += double.parse(filter.amount!);
      }
    }*/

    //todo: merging weekly data...
    Map<String, Expense> mergedTransactions = {};
    for (var week in filteredList) {
      if (week.type!.toLowerCase() == filter.toLowerCase()) {
        weeklyTotalAmount += double.parse(week.amount ?? '0.0');

        String category = week.category ?? '';
        double amount = double.parse(week.amount ?? '0.0');

        if (mergedTransactions.containsKey(category)) {
          // mergedTransactions[category] = mergedTransactions[category]! + amount;

          Expense updateExpense = Expense(
              id: week.id,
              other: week.other,
              readableDate: week.readableDate,
              type: week.type,
              note: week.note,
              category: week.category,
              amount:
                  '${double.parse(mergedTransactions[category]!.amount ?? '0') + amount}',
              //expense.amount,
              date: week.date,
              dateTime: Helper.stringToDate(week.date!),
              color: Helper.getRandomColor());

          mergedTransactions[category] = updateExpense;
        } else {
          // Otherwise, create a new entry
          // mergedTransactions[category] = amount;
          Expense updateExpense = Expense(
              id: week.id,
              other: week.other,
              readableDate: week.readableDate,
              type: week.type,
              note: week.note,
              category: week.category,
              amount: '$amount',
              //expense.amount,
              date: week.date,
              dateTime: Helper.stringToDate(week.date!),
              color: Helper.getRandomColor());

          mergedTransactions[category] = updateExpense;
        }
      }
    }

    //todo: Print merged transactions
    mergedTransactions.forEach((category, expense) {
      Expense updateExpense = Expense(
          id: expense.id,
          other: expense.other,
          readableDate: expense.readableDate,
          type: expense.type,
          note: expense.note,
          category: expense.category,
          amount: expense.amount,
          date: expense.date,
          dateTime: Helper.stringToDate(expense.date!),
          color: Helper.getRandomColor());
      weeklyExpenseList.add(updateExpense);
    });

    notifyListeners();
  }

  String analysisMonth = "";
  List<Expense> monthlyAnalysisList = [];
  double monthlyExIncAmount = 0;
  String filterIncEx = 'Expense';
  List<String> expenseCategoryList = [
    'Shopping',
    'Entertainment',
    'Travel',
    'Food',
    'Bills',
    'Motor Vehicle',
    'House',
    'Health',
    'Other'
  ];

  List<String> incomeCategoryList = [
    'Direct Selling',
    'Active Business',
    'Salary',
    'Portfolio Income',
    'Other'
  ];

  Future<void> filterExpenseByMonth(String date, String filter) async {
    analysisMonth = date;
    monthlyAnalysisList.clear();
    monthlyExIncAmount = 0;
    filterIncEx = filter;
    List<Expense> monthExpenses = await DBHelper.getExpenseByMonth(date);

    Map<String, Expense> mergedTransactions = {};

    for (var expense in monthExpenses) {
      if (expense.type!.toLowerCase() == filter.toLowerCase()) {
        monthlyExIncAmount += double.parse(expense.amount!);

        // Expense updateExpense = Expense(
        //     id: expense.id,
        //     other: expense.other,
        //     readableDate: expense.readableDate,
        //     type: expense.type,
        //     note: expense.note,
        //     category: expense.category,
        //     amount: expense.amount,
        //     date: expense.date,
        //     dateTime: Helper.stringToDate(expense.date!),
        //     color: Helper.getRandomColor());
        // monthlyAnalysisList.add(updateExpense);

        //todo: merging code
        // If category exists, add the amount to it
        String category = expense.category ?? '';
        double amount = double.parse(expense.amount ?? '0.0');
        if (mergedTransactions.containsKey(category)) {
          // mergedTransactions[category] = mergedTransactions[category]! + amount;

          Expense updateExpense = Expense(
              id: expense.id,
              other: expense.other,
              readableDate: expense.readableDate,
              type: expense.type,
              note: expense.note,
              category: expense.category,
              amount:
                  '${double.parse(mergedTransactions[category]!.amount ?? '0') + amount}',
              //expense.amount,
              date: expense.date,
              dateTime: Helper.stringToDate(expense.date!),
              color: Helper.getRandomColor());

          mergedTransactions[category] = updateExpense;
        } else {
          // Otherwise, create a new entry
          // mergedTransactions[category] = amount;
          Expense updateExpense = Expense(
              id: expense.id,
              other: expense.other,
              readableDate: expense.readableDate,
              type: expense.type,
              note: expense.note,
              category: expense.category,
              amount: '$amount',
              //expense.amount,
              date: expense.date,
              dateTime: Helper.stringToDate(expense.date!),
              color: Helper.getRandomColor());

          mergedTransactions[category] = updateExpense;
        }
      }
    }

    //todo: Print merged transactions
    mergedTransactions.forEach((category, expense) {
      Expense updateExpense = Expense(
          id: expense.id,
          other: expense.other,
          readableDate: expense.readableDate,
          type: expense.type,
          note: expense.note,
          category: expense.category,
          amount: expense.amount,
          date: expense.date,
          dateTime: Helper.stringToDate(expense.date!),
          color: Helper.getRandomColor());
      monthlyAnalysisList.add(updateExpense);
    });
    notifyListeners();
  }
}
