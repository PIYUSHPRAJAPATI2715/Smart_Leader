import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class CustomToolButton extends StatelessWidget {
  VoidCallback ontap;
  double height;
  double width;
  // Widget widget;
  double radius;
  String word;
  String imagePath;
  double verticleHightpad;
  double horizontalWidthpad;

  CustomToolButton({
    Key? key,
    // required this.widget,
    required this.width,
    required this.height,
    required this.ontap,
    required this.radius,
    required this.word,
    required this.imagePath,
    required this.horizontalWidthpad,
    required this.verticleHightpad
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: ontap,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : kblueColor,
                      width: 1.0),
                  color: SessionManager.getTheme() == true
                      ? kscafolledColor
                      : kWhiteColor),
              child: Center(
                child: Padding(
                  padding:  EdgeInsets.symmetric(
                    horizontal: horizontalWidthpad,vertical: verticleHightpad
                  ),
                  child: Image.asset(imagePath,color: SessionManager.getTheme() == true
                      ? kWhiteColor
                      : kblueColor,),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          customtext(
            fontWeight: FontWeight.w400,
            text: word,
            alignment: TextAlign.center,
            fontsize: 12,
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
