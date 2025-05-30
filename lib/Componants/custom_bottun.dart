import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class custom_Button extends StatelessWidget {

 final String title;
 final  double hight;
 final  double width;
 final VoidCallback onTap;
 final double fontSize;


   const custom_Button({
    Key? key,required this.onTap,required this.title,required this.hight,required this.width,required this.fontSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 4,
        shadowColor: Color(0xff000E87),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: hight,width: width,
            decoration: BoxDecoration(
              gradient: kGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: customtext(fontWeight: FontWeight.w500, text: title, fontsize:fontSize,color: kWhiteColor,),
            ),
          ),
        ),
      ),
    );
  }
}