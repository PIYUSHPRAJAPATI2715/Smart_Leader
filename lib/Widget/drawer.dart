import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/notification_api.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';
import 'package:smart_leader/Screen/about_us_screen.dart';
import 'package:smart_leader/Screen/contactUs_screen.dart';
import 'package:smart_leader/Screen/download_screen.dart';
import 'package:smart_leader/Screen/privecy_policy_screen.dart';
import 'package:smart_leader/Screen/profile_screen.dart';
import 'package:smart_leader/Screen/termand_condition_screen.dart';
import 'package:smart_leader/Screen/welcome_screen.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  signOutGoogle() async {
    await _googleSignIn.signOut().then((value) {
      SessionManager.logout();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false);
    });
  }

  Future<void> signOutWithFacebook() async {
    await FacebookAuth.instance.logOut().then((value) {
      SessionManager.logout();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    });
    // print("User Signed Out");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          topContainer(context),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                // ListTile(
                //   leading: Image(
                //     image: const AssetImage(
                //       "assest/png_icon/profile_icon.png",
                //     ),
                //     height: 20,
                //     width: 20,
                //     color: Theme.of(context).primaryColor,
                //   ),
                //   title: customtext(
                //     fontWeight: FontWeight.w600,
                //     text: "Profile",
                //     fontsize: 20,
                //     color: Theme.of(context).primaryColor,
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     // Navigator.push(
                //     //     context,
                //     //     MaterialPageRoute(
                //     //         builder: (context) => const ProfileScreen()));
                //
                //
                //   },
                // ),
                ListTile(
                  leading: Image(
                    image: const AssetImage("assest/png_icon/download_icon.png"),
                    height: 20,
                    width: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: customtext(
                    fontWeight: FontWeight.w600,
                    text: "My Library",
                    fontsize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DownloadScreen()));
                  },
                ),
                ListTile(
                  leading: Image(
                    image: const AssetImage("assest/png_icon/rating_icon.png"),
                    height: 20,
                    width: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: customtext(
                    fontWeight: FontWeight.w600,
                    text: "Rating Us on Play Store",
                    fontsize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Image(
                    image:
                        const AssetImage("assest/png_icon/termscondition_icon.png"),
                    height: 20,
                    width: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: customtext(
                    fontWeight: FontWeight.w600,
                    text: "Terms And Condition",
                    fontsize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermAndConditionScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: customtext(
                    fontWeight: FontWeight.w600,
                    text: "Privacy Policy",
                    fontsize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivecyPolicyScreen()));
                  },
                ),
                ListTile(
                  leading: Image(
                    image: const AssetImage("assest/png_icon/contactus_icon.png"),
                    height: 20,
                    width: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: customtext(
                    fontWeight: FontWeight.w600,
                    text: "Contact Us",
                    fontsize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ContactUsScreen()));
                  },
                ),
                ListTile(
                  leading: Image(
                    image: const AssetImage("assest/png_icon/about_icon.png"),
                    height: 20,
                    width: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: customtext(
                    fontWeight: FontWeight.w600,
                    text: "About Us",
                    fontsize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutUsScreen()));
                  },
                ),
                ListTile(
                  leading: Image(
                    image: const AssetImage("assest/png_icon/about_icon.png"),
                    height: 20,
                    width: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: customtext(
                    fontWeight: FontWeight.w600,
                    text: "Notifications",
                    fontsize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const AboutUsScreen()));
                  },
                ),

                ListTile(
                  leading: Image(
                    image: const AssetImage("assest/png_icon/contactus_icon.png"),
                    height: 20,
                    width: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: customtext(
                    fontWeight: FontWeight.w600,
                    text: "Video List",
                    fontsize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const AboutUsScreen()));
                  },
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image(
                              image:
                                  const AssetImage("assest/png_icon/theme_icon.png"),
                              height: 25,
                              width: 25,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            customtext(
                              fontWeight: FontWeight.w600,
                              text: "ThemeMode",
                              fontsize: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                      FlutterSwitch(
                        width: 45.0,
                        height: 25.0,
                        valueFontSize: 10.0,
                        toggleSize: 18.0,
                        value: SessionManager.getTheme(),
                        //themeProvider.isDarkMode,
                        borderRadius: 30.0,
                        activeIcon: const Icon(Icons.dark_mode_outlined),
                        inactiveIcon: const Icon(Icons.light_mode_outlined),
                        onToggle: (val) {
                          final provider = Provider.of<ThemeProvider>(context,
                              listen: false);
                          // provider.toggleTheme(val);
                          provider.setTheme(val);
                          // notificationServices.displayNotification(title: "Theme Changed",
                          //     body: SessionManager.getTheme() == true ?"Activate Dark Mode":"Activate Light Mode"
                          // );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: InkWell(
                    onTap: () {
                      signOutGoogle();
                      //  signOutWithFacebook();
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.logout, color: kredColor),
                              const SizedBox(
                                width: 30,
                              ),
                              customtext(
                                  fontWeight: FontWeight.w500,
                                  text: "LogOut",
                                  fontsize: 18,
                                  color: kredColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget topContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assest/images/OnBordScreenTopScreen.png"),
              fit: BoxFit.fill)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Image(
                    image: AssetImage("assest/png_icon/crosIcon.png"),
                    height: 34,
                    width: 34,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
