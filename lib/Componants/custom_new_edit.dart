import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/session_manager.dart';

import '../Helper/theme_colors.dart';
import 'Custom_text.dart';

class CustomNewEdit extends StatelessWidget {
  String lableName;
  String title;
  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  double hight;
  double lablefont;
  double hintfont;
  double gapHight;
  bool enable;
  final int numberformate;

  CustomNewEdit(
      {Key? key,
        this.gapHight = 8,
        required this.hight,
        required this.title,
        required this.controller,
        required this.hint,
        required this.inputAction,
        required this.inputType,
        required this.lableName,
        required this.hintfont,
        required this.lablefont,
        this.enable = true,
        this.numberformate = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: customtext(
              fontWeight: FontWeight.w500,
              text: lableName,
              fontsize: lablefont,
              color: SessionManager.getTheme() == true
                  ? kWhiteColor
                  : kbuttonColor),
        ),
        SizedBox(height: gapHight),
        CustomPaint(
          painter: FlatCorneredBackgroundPainter(
              radius: 10.0, strokeColor: KBoxNewColor, strokeWidth: 1),
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              enabled: true,
              controller: TextEditingController(),
              inputFormatters: [
                LengthLimitingTextInputFormatter(numberformate),
              ],
              textCapitalization: TextCapitalization.sentences,
              textInputAction: inputAction,
              style: GoogleFonts.splineSans(
                  color: SessionManager.getTheme() == true
                      ? kWhiteColor
                      : kscafolledColor,
                  fontSize: hintfont,
                  fontWeight: FontWeight.w700),
              keyboardType: inputType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: title,
                hintStyle: GoogleFonts.splineSans(
                    color: SessionManager.getTheme() == true
                        ? klableColor
                        : klableColor,
                    fontSize: hintfont,
                    fontWeight: FontWeight.w700),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: SessionManager.getTheme() == true
                            ? kscafolledColor
                            : const Color(0xffBFBFBF))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: SessionManager.getTheme() == true
                            ? kscafolledColor
                            : Colors.grey.shade50)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: SessionManager.getTheme() == true
                            ? kscafolledColor
                            : Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FlatCorneredBackgroundPainter extends CustomPainter {
  double radius, strokeWidth;
  Color strokeColor;

  FlatCorneredBackgroundPainter(
      {this.radius = 10, this.strokeWidth = 4, this.strokeColor = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = strokeColor;

    Path path = Path()
      ..addPolygon([
        Offset(radius, 0),
        Offset(w - radius, 0),
        Offset(w, radius),
        Offset(w, h - radius),
        Offset(w - radius, h),
        Offset(radius, h),
        Offset(0, h - radius),
        Offset(0, radius),
      ], true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
