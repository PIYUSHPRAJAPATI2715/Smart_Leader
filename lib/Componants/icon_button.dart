import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class CustomIconButton extends StatelessWidget {

  String title;
  double hight;
  double width;
  VoidCallback onTap;
  double fontSize;
  Widget widget;
  double verticleHightpad;
  double horizontalWidthpad;


  CustomIconButton({
    Key? key,required this.onTap,required this.title,required this.hight,required this.width,required this.fontSize,
    required this.widget,required this.verticleHightpad,required this.horizontalWidthpad
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 4,
        shadowColor: Color(0xff000E87),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: hight,width: width,
            decoration: BoxDecoration(
              gradient: kGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(
                horizontal: horizontalWidthpad,
                vertical: verticleHightpad
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customtext(fontWeight: FontWeight.w500, text: title, fontsize:fontSize,color: kWhiteColor,),
                  SizedBox(width: 2,),
                  widget,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}