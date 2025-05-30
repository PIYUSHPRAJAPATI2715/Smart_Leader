
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/LocalDatabase/Db/dp_helper.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Provider/expense_controller.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';
import 'package:smart_leader/Screen/onboard_screen1.dart';
import 'package:smart_leader/Screen/welcome_screen.dart';
import 'package:smart_leader/Widget/bottum_navBar.dart';
import 'package:smart_leader/firebase_options.dart';
import 'package:smart_leader/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification(); // Ensure 4     it's properly set up
  await SessionManager.init();
  await DBHelper.initDb();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget  {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (create) => AppController()),
        ChangeNotifierProvider(create: (create) => ExpenseController()),
        ChangeNotifierProvider(
          create: (create) => ThemeProvider(),
          builder: (context, _) {
            return const MaterialAppWidget();
          },
        ),
      ],
    );
  }
}
class MaterialAppWidget extends StatefulWidget {
  const MaterialAppWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MaterialAppWidget> createState() => _MaterialAppWidgetState();
}
class _MaterialAppWidgetState extends State<MaterialAppWidget> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      themeMode: SessionManager.getTheme() ? ThemeMode.dark : ThemeMode.light,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      // ✅ Add the localization delegates here
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        quill.FlutterQuillLocalizations.delegate, // ✅ Required for Quill
      ],
      supportedLocales: const [
        Locale('en'), // ✅ You can add other locales if needed
      ],
      home: getPage(),
    );
  }

  Widget getPage() {
    if (!SessionManager.getwelcome()) {
      return const OnboardScreen1();
    }

    if (!SessionManager.getisLoggedIn()) {
      return const WelcomeScreen();
    }

    // Uncomment this if you need to handle profile completion
    // if (!SessionManager.isProfileComplete()) {
    //   return const ProfileDetailsScreen();
    // }

    return BottumNavBar();
  }
}
 

/*
  flutter_quill: used in

  add_note_screen.dart          DONE
  show_note_detail_screen.dart  DONE
  add_myNote_widget.dart        DONE
  edit_note_widget.dart
 */
