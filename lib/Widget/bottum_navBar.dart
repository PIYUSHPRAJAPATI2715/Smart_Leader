import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';
import 'package:smart_leader/Screen/add_events_screen.dart';
import 'package:smart_leader/Screen/add_mytask_screen.dart';
import 'package:smart_leader/Screen/creat_connection_folder.dart';
import 'package:smart_leader/Screen/home_screen.dart';
import 'package:smart_leader/Screen/tools_screen.dart';
import 'package:smart_leader/Screen/vedio_screen.dart';
import 'package:smart_leader/Screen/view_meeting_screen.dart';

import '../Componants/neumorphism_widget.dart';
import '../main.dart';

class BottumNavBar extends StatefulWidget {
  @override
  State<BottumNavBar> createState() => _BottumNavBarState();
}
class _BottumNavBarState extends State<BottumNavBar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[

    const EventCalendarScreen(),
    const HomeScreen(),
    VedioScreen(),

    // SessionManager.isLoggedIn() ? const ProfileScreen() : const Login_Screen(),
  ];

  void _onItemTapped(int index) {
    if (index == 0 & 1) {}
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkForNotification();

  }

  void checkForNotification() async
  {
    NotificationAppLaunchDetails? details =
        await notificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null) {
      if (details.didNotificationLaunchApp) {
        NotificationResponse? response = details.notificationResponse;

        if (response != null) {
          String? payload = response.payload;
          print('PayLoad $payload');

          if (payload == Helper.kTaskScreen) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const AddMyTaskScreen()));
          } else if (payload == Helper.kEventScreen) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddEventScreen()));
          } else if (payload == Helper.kConnectionScreen) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const CreatConnectionFolder()));
          } else if (payload == Helper.kMeetingScreen) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewMeeting(),
              ),
            );
          }
        }
      }
    }
  }

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      extendBody: true,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        child: BottomNeumorphismWidget(
          padding: EdgeInsets.all(0),
          child: Card(
            color: SessionManager.getTheme() == false
                ? kWhiteColor
                : kscafolledColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            shadowColor: kblueColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomNavigationBar(
                  backgroundColor: SessionManager.getTheme() == false
                      ? kWhiteColor
                      : kscafolledColor,
                  onTap: _onItemTapped,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 0
                          ? Image.asset(
                        SessionManager.getTheme() == true
                            ? "assest/png_icon/Whitenav_icon3.png"
                            : "assest/png_icon/navicon3.png",color: Colors.black,
                        height: 20,
                        width: 20,
                      )
                          : Image.asset(
                        SessionManager.getTheme() == true
                            ? "assest/png_icon/whitenav_icon3blank.png"
                            : "assest/png_icon/navicon3blank.png",
                        height: 20,
                        width: 20,
                      ),
                      label: "Tools",
                    ),
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 1
                          ? Image.asset(
                              SessionManager.getTheme() == true
                                  ? "assest/png_icon/whitenav_icon1blank.png"
                                  : "assest/png_icon/navicon1.png",color: Colors.black,
                              height: 20,
                              width: 20,
                            )
                          : Image.asset(
                              SessionManager.getTheme() == true
                                  ? "assest/png_icon/whitenav_icon1blank.png"
                                  : "assest/png_icon/whitenav_icon1blank.png",
                              height: 20,
                              width: 20,
                            ),
                      label: "Books",
                    ),
                    BottomNavigationBarItem(
                      icon: _selectedIndex == 2
                          ? Image.asset(
                              SessionManager.getTheme() == true
                                  ? "assest/png_icon/whitenav_icon2.png"
                                  : "assest/png_icon/navicon2.png",color: Colors.black,
                              height: 20,
                              width: 20,
                            )
                          : Image.asset(
                              SessionManager.getTheme() == true
                                  ? "assest/png_icon/whitenav_icon2blank.png"
                                  : "assest/png_icon/navicon2blank.png",
                              height: 20,
                              width: 20,
                            ),
                      label: "Videos",
                    ),

                  ],
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  selectedItemColor: SessionManager.getTheme() == true
                      ? kWhiteColor
                      : Colors.black,
                  selectedFontSize: 12,
                  unselectedItemColor: KBoxNewColor.withOpacity(0.85),
                  selectedLabelStyle: TextStyle(
                      fontFamily: "SplineSans",
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                  unselectedLabelStyle: TextStyle(
                      fontFamily: "SplineSans",
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                  iconSize: 40,
                  elevation: 5),
            ),
          ),
        ),
      ),
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.signal_wifi_statusbar_connected_no_internet_4),
              SizedBox(
                width: 8,
              ),
              const Text('No Connection'),
            ],
          ),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
