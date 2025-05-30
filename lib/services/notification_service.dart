import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        print('Response ${response.payload}');
      },
    );
  }

  Future<void> showNotification(int id, String title, String body,
      String remindMe, String dateTime, String screenName) async {
    //todo: date time schedule
    //DateTime scheduleDate = Helper.stringToDate(dateTime).add(const Duration(seconds: 1));

    DateTime testingDate = Helper.stringToDate(dateTime);

    DateTime scheduleDate = Helper.stringToDate(dateTime).subtract(
        Duration(minutes: int.parse(remindMe.replaceAll('min', '').trim())));

    print('Schedule DATA $scheduleDate');
    //.add(Duration(seconds: int.parse(remindMe.replaceAll('min', '').trim())));
    //DateTime.now().add(const Duration(seconds: 5));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Test Title',
      'Test Body',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          channelDescription: "Test Channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'test_screen',
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        //  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
        tz.TZDateTime.from(scheduleDate, tz.local),
        //todo: schedule the notification to show after 2 seconds.
        const NotificationDetails(
          // Android details
          android: AndroidNotificationDetails('main_channel', 'Main Channel',
              channelDescription: "SmartLeader",
              importance: Importance.max,
              priority: Priority.high,
              channelShowBadge: true,
              enableVibration: true,
              playSound: true),
          // iOS details
          iOS: DarwinNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),

        // Type of time interpretation
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: screenName);
  }
}
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//
//     await _notificationsPlugin.initialize(initializationSettings);
//   }
//
//   void showNotification(
//       int id,
//       String title,
//       String body,
//       String remindType,
//       String dateTimeString,
//       String payload,
//       ) async {
//     final scheduledTime = parseDateTime(dateTimeString); // Parse to DateTime
//     if (scheduledTime == null) return;
//
//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'channel_id',
//           'channel_name',
//           channelDescription: 'channel_description',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       payload: payload,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//   static DateTime? parseDateTime(String dateTimeStr) {
//     try {
//       return DateFormat('dd-MM-yyyy HH:mm').parse(dateTimeStr);
//     } catch (e) {
//       debugPrint('DateTime parse error: $e');
//       return null;
//     }
//   }
//
// }
