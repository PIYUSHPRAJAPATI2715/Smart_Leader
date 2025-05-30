import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Helper/theme_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    Key? key,
    required this.title,
    required this.onClick,
    this.width = double.infinity,
    this.height = 50,
    this.btnColor = kblueDarkColor,
    this.fontSize = 15.0,
    this.radius = 5.0
  }) : super(key: key);

  final String title;
  final VoidCallback onClick;
  final double width;
  final double height;
  final Color btnColor;
  final double fontSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          minimumSize:  Size(width, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          )
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: fontSize),
      ),
    );
  }
}