import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Screen/add_tocart_screen.dart';

import '../Screen/manage_profile_screen.dart';

class TopHeaderContainer extends StatelessWidget {
  TopHeaderContainer({Key? key, required this.drawerKey}) : super(key: key);

  final GlobalKey<ScaffoldState> drawerKey;
  final profileImage = SessionManager.getProfileImage();
  String userName = SessionManager.getFirstName() ?? "User";
  String _getInitials(String name) {
    List<String> names = name.trim().split(" ");
    String initials = names.length > 1
        ? '${names[0][0]}${names[1][0]}'
        : names[0][0];
    return initials.toUpperCase();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 102,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(
          builder: (BuildContext, constrains) {
            return Container(
                height: 100,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assest/images/OnBordScreenTopScreen.png"),
                        fit: BoxFit.fill)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                drawerKey.currentState!.openDrawer();
                              },
                              child: Image.asset(
                                "assest/png_icon/drawer_icon.png",
                                height: 33,
                                width: 38,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: customtext(
                                  fontWeight: FontWeight.w500,
                                  text: "Smart Leader",
                                  fontsize: 20,
                                  color: kWhiteColor,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ManageProfileScreen()));
                              },
                              child: profileImage != null && profileImage.isNotEmpty
                                  ? CircleAvatar(
                                backgroundImage: NetworkImage(profileImage),
                                radius: 18,
                              )
                                  : CircleAvatar(
                                backgroundColor: Colors.grey[700],
                                radius: 18,
                                child: Text(
                                  _getInitials(userName),
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),

                            Visibility(
                              visible: false,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddToCart()));
                                  },
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: kWhiteColor,
                                    size: 26,
                                  )),
                            )
                          ],
                        ),
                      )
                    ]));
          },
        ));
  }
}
