import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smart_leader/Componants/Custom_text.dart';

class Helper {
  static showSnackVar(String message, Color color, BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16.0),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static showLoaderDialog(BuildContext context, {String message = 'Loading'}) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: customtext(
              fontWeight: FontWeight.w500,
              text: message,
              fontsize: 12,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static toastMassage(String Massage, Color color) {
    Fluttertoast.showToast(
        msg: Massage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Future<bool> isNetworkAvailable() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  static String formattedDate() {
    final DateFormat formatter = DateFormat('dd-MMM-yy');
    final String formatted = formatter.format(DateTime.now());
    return formatted;
  }

  static String formatExpenseDate(String inputDate) {
    DateFormat inputFormatter = DateFormat('yyyy-MM-dd');
    DateFormat outputFormatter = DateFormat('MMMM-yy');

    DateTime date = inputFormatter.parse(inputDate);
    return outputFormatter.format(date);
  }

  static String formatExpenseChartDate(String inputDate) {
    DateFormat inputFormatter = DateFormat('yyyy-MM-dd');
    DateFormat outputFormatter = DateFormat('dd MMM yy');

    DateTime date = inputFormatter.parse(inputDate);
    return outputFormatter.format(date);
  }

  static DateTime stringToDate(String dateTime) {
    DateTime dt = DateTime.parse(dateTime);
    return dt;
  }

  static String formatTime(String time) {
    DateTime start;
    if (time.contains('AM') || time.contains('PM')) {
      start = DateFormat("H:m a").parse(time);
    } else {
      start = DateFormat("H:m").parse(time);
    }

    final DateFormat formatter = DateFormat('HH:mm:ss');
    final String formatted = formatter.format(start);

    print('formatted time $formatted');
    return formatted;
  }

  static bool checkPassedDateTime(String checkDateTime) {
    final DateFormat formatter;
    if (checkDateTime.contains('AM') || checkDateTime.contains('PM')) {
      formatter = DateFormat('dd-MM-yyy H:m a');
    } else {
      formatter = DateFormat('dd-MM-yyy H:m');
    }

    DateTime checkDT = formatter.parse(checkDateTime);
    return DateTime.now().isAfter(checkDT);
  }

  /*
   NumberFormat.compactCurrency(
        decimalDigits: 1,
        symbol: 'k',
      ).format(number / 1000);
   */
  static String formatUnitType(int number) {
    final formatter = NumberFormat('#,##,###.##');
    if (number < 1000) {
      return formatter.format(number);
    } else if (number < 100000) {
      return '${formatter.format(number / 1000)} k';
    } else if (number < 10000000) {
      return '${formatter.format(number / 100000)} L';
    } else {
      return '${formatter.format(number / 10000000)} cr';
    }
  }

  static Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    ).withOpacity(1);
  }

  static void baseArray()async{
    final String imagePath = 'assest/png_icon/add_icon.png';

    // Read the image file as bytes
    ByteData data = await rootBundle.load(imagePath);

    // Convert the ByteData to a Uint8List
    Uint8List bytes = data.buffer.asUint8List();

    // Now you have the image bytes in the Uint8List
    print('Image bytes: $bytes');
  }

  static Future<Uint8List> readImageAsBytes(String imagePath) async {
    File file = File(imagePath);

    if (await file.exists()) {
      // Read the file as bytes
      List<int> imageBytes = await file.readAsBytes();

      // Convert the list of ints to a Uint8List
      Uint8List uint8List = Uint8List.fromList(imageBytes);

      return uint8List;
    } else {
      throw FileSystemException('File not found: $imagePath');
    }
  }
  //todo: ------------------- Notification Screen ------------------------

  static const kMeetingScreen = 'Meeting';
  static const kTaskScreen = 'Task';
  static const kConnectionScreen = 'connection';
  static const kEventScreen = 'Event';

  static bool isMobileNumberValid(String mobileNumber) {
    RegExp mobilePattern = RegExp(r"^[0-9]*$");
    return mobilePattern.hasMatch(mobileNumber);
  }

}
