import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';

class CustomTextField extends StatelessWidget {
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

  CustomTextField(
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
                  : Colors.black),
        ),
        SizedBox(height: gapHight),
        Container(
          height: hight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: KBoxNewColor, width: 1.3),
              color: SessionManager.getTheme() == true
                  ? kscafolledColor
                  : kWhiteColor),
          child: TextFormField(
            enabled: enable,
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(numberformate),
            ],
            textCapitalization: TextCapitalization.sentences,
            textInputAction: inputAction,
            style: GoogleFonts.splineSans(
                color: SessionManager.getTheme() == true
                    ? kWhiteColor
                    : Colors.black,
                fontSize: hintfont,
                fontWeight: FontWeight.w500),
            keyboardType: inputType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              hintText: title,
              hintStyle: GoogleFonts.splineSans(
                  color: SessionManager.getTheme() == true
                      ? kWhiteColor
                      :kscafolledColor,
                  fontSize: hintfont,
                  fontWeight: FontWeight.w500),
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
      ],
    );
  }
}

class CustomAmountTextField extends StatelessWidget {
  const CustomAmountTextField(
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
      required this.unitType,
      required this.onChanged,
      this.numberformate = 200})
      : super(key: key);

  final String lableName;
  final String title;
  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final double hight;
  final double lablefont;
  final double hintfont;
  final double gapHight;
  final bool enable;
  final int numberformate;
  final ValueChanged<String> onChanged;
  final String unitType;

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
        SizedBox(height: gapHight),
        Container(
          height: hight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: kblueColor, width: 1.0),
              color: SessionManager.getTheme() == true
                  ? kblueColor
                  : kWhiteColor),
          child: TextFormField(
            enabled: enable,
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(numberformate),
            ],
            textCapitalization: TextCapitalization.sentences,
            textInputAction: inputAction,
            style: GoogleFonts.splineSans(
                color: SessionManager.getTheme() == true
                    ? kWhiteColor
                    : Colors.black,

                fontSize: hintfont,
                fontWeight: FontWeight.w500),
            keyboardType: inputType,
            onChanged: onChanged,
            decoration: InputDecoration(
              suffixIcon: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: customtext(
                  fontWeight: FontWeight.w500,
                  text: unitType,
                  fontsize: 13,
                  color: unitType == '0' ? Colors.white : Colors.black,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              hintText: title,
              hintStyle: GoogleFonts.splineSans(
                  color: SessionManager.getTheme() == true
                      ? klableColor
                      : Colors.black,
                  fontSize: hintfont,
                  fontWeight: FontWeight.w500),
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
      ],
    );
  }
}
