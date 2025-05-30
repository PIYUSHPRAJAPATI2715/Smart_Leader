import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class CustomDescriptionTextfield extends StatelessWidget {



  String lableName;
  String title;
  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  double lablefont;
  double hintfont;
  double gapHight;
  double boxHight;
  final ValueChanged<String?> onchanged;
  final FocusNode focusNode;


  CustomDescriptionTextfield({Key? key,
    required this.boxHight,
    this.gapHight = 8,
    required this.title,
    required this.controller,
    required this.hint,
    required this.inputAction,
    required this.inputType,
    required this.lableName,
    required this.hintfont,
    required this.lablefont,
    required this.onchanged,
    required this.focusNode

  }) : super(key: key);

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
                  : Colors.black),
        ),
        SizedBox(
          height: gapHight,
        ),
        Container(
          height: boxHight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border:
              Border.all(color: KBoxNewColor, width: 1.2),
              color: SessionManager.getTheme() == true
                  ? kscafolledColor
                  : kWhiteColor),
          child: TextFormField(
            maxLines: null,
            focusNode: focusNode,
            autovalidateMode: AutovalidateMode.always,
            controller: controller,
            onChanged: onchanged,
            textInputAction: inputAction,
            textCapitalization: TextCapitalization.sentences,
            style: GoogleFonts.splineSans(
                color: SessionManager.getTheme() == true
                    ? kWhiteColor
                    : Colors.black ,
                fontSize: 12,
                fontWeight: FontWeight.w500),
            keyboardType: inputType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 15, vertical: 10),
              hintText: hint,
              hintStyle: GoogleFonts.splineSans(
                  color: SessionManager.getTheme() == true
                      ? kWhiteColor
                      :kscafolledColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : Color(0xffBFBFBF))),
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
      ],
    );
  }
}

class NewCustomDescriptionTextfield extends StatelessWidget {



  String lableName;
  String title;
  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  double lablefont;
  double hintfont;
  double gapHight;
  double boxHight;
  final ValueChanged<String?> onchanged;
  final FocusNode focusNode;


  NewCustomDescriptionTextfield({Key? key,
    required this.boxHight,
    this.gapHight = 8,
    required this.title,
    required this.controller,
    required this.hint,
    required this.inputAction,
    required this.inputType,
    required this.lableName,
    required this.hintfont,
    required this.lablefont,
    required this.onchanged,
    required this.focusNode

  }) : super(key: key);

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
        SizedBox(
          height: gapHight,
        ),
        CustomPaint(
          painter: FlatCorneredBackgroundPainter(
              radius: 10.0, strokeColor: KBoxNewColor, strokeWidth: 1),
          child: Container(
            height: boxHight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border:
                Border.all(color: KBoxNewColor, width: 1),
                color: SessionManager.getTheme() == true
                    ? kscafolledColor
                    : kWhiteColor),
            child: TextFormField(
              maxLines: null,
              focusNode: focusNode,
              autovalidateMode: AutovalidateMode.always,
              controller: controller,
              onChanged: onchanged,
              textInputAction: inputAction,
              textCapitalization: TextCapitalization.sentences,
              style: GoogleFonts.splineSans(
                  color: SessionManager.getTheme() == true
                      ? kWhiteColor
                      : kscafolledColor ,
                  fontSize: hintfont,
                  fontWeight: FontWeight.w700),
              keyboardType: inputType,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 15, vertical: 10),
                hintText: hint,
                hintStyle: GoogleFonts.splineSans(
                    color: SessionManager.getTheme() == true
                        ? kWhiteColor
                        : klableColor,
                    fontSize: hintfont,
                    fontWeight: FontWeight.w700),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: SessionManager.getTheme() == true
                            ? kscafolledColor
                            : Color(0xffBFBFBF))),
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
