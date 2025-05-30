import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class BuyBottun extends StatelessWidget {

  String title;
  double verticleHight;
  double horizontalWidth;
  VoidCallback onTap;
  double fontSize;


   BuyBottun({
    Key? key,required this.title,required this.horizontalWidth,required this.onTap,required this.verticleHight,
     this.fontSize = 9
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(9),
      elevation: 4,
      shadowColor: Color(0xffA16E4B),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalWidth,vertical: verticleHight),
          decoration: BoxDecoration(
            gradient: kGradient,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: customtext(fontWeight: FontWeight.w500, text: title, fontsize:fontSize,color: kWhiteColor,),
          ),
        ),
      ),
    );
  }
}