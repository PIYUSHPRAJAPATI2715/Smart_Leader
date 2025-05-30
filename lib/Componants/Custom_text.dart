import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class customtext extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontsize;
  final Color color;
  final TextAlign alignment;
  final int maxLine;

  const customtext({
    this.alignment = TextAlign.start,
    required this.fontWeight,
    required this.text,
    required this.fontsize,
    this.color = Colors.black,
    this.maxLine = 10,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment,
      maxLines: maxLine,
      style: GoogleFonts.abhayaLibre(
        color: color,
        fontSize: fontsize,
        fontWeight: fontWeight,
      ),
    );
  }
}
