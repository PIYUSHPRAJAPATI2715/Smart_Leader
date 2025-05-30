import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Screen/home_screen.dart';

import 'bottum_navBar.dart';

class TopContainer extends StatelessWidget {
  VoidCallback onTap;
  String title;

  TopContainer({Key? key, required this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 102,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assest/images/OnBordScreenTopScreen.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        // Add padding for spacing
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Space between icons
          children: [
            // Start Icon
            IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons.arrow_back,
                color: kWhiteColor,
              ),
            ),

            // Centered Text
            Expanded(
              child: Center(
                child: customtext(
                  fontWeight: FontWeight.w500,
                  text: title,
                  fontsize: 20,
                  color: Colors.white,
                ),
              ),
            ),

            // End Icon
            InkWell(
              onTap: () {

                 Navigator.pop(context);

              },
                child: Image.asset(
              "assest/png_icon/home_removebg_preview.png",
              height: 25,
              width: 25,
            ))
          ],
        ),
      ),
    );
  }
}
