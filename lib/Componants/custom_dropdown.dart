import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/branch.dart';

class CustomDropDown extends StatefulWidget {
  final ValueChanged<String?> onChange;
  final List<String> items;
  final String hint;
  final String lableName;
  final String valueType;
  final double gapHight;
  final Color color;

  const CustomDropDown(
      {Key? key,
      this.lableName = "",
      required this.hint,
      required this.onChange,
      this.gapHight = 8,
      required this.items,
      required this.valueType,
      this.color = kscafolledColor})
      : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: customtext(
          fontWeight: FontWeight.w500,
          text: widget.lableName,
          fontsize: 14,
          color: SessionManager.getTheme() == true ? kWhiteColor : Colors.black,
        ),
      ),
      SizedBox(height: widget.gapHight),
      Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: KBoxNewColor, width: 1.2),
              color: SessionManager.getTheme() == true
                  ? kscafolledColor
                  : kWhiteColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: const Icon(Icons.arrow_drop_down_rounded),
                iconEnabledColor: SessionManager.getTheme() == true
                    ? kWhiteColor
                    : klableColor,
                dropdownColor: SessionManager.getTheme() == true
                    ? Colors.black87
                    : Colors.yellow.shade50,
                itemHeight: kMinInteractiveDimension,
                style: GoogleFonts.splineSans(
                    color: SessionManager.getTheme() == true
                        ? kWhiteColor
                        : klableColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
                elevation: 5,
                value: widget.valueType,
                hint: customtext(
                  fontWeight: FontWeight.w700,
                  text: widget.hint,
                  fontsize: 14,
                  color: SessionManager.getTheme() == true
                      ? kWhiteColor
                      : kscafolledColor,
                ),
                borderRadius: BorderRadius.circular(14),
                items:
                    widget.items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: customtext(
                      fontWeight: FontWeight.w700,
                      text: value,
                      fontsize: 12,
                      color: SessionManager.getTheme() == true
                          ? kWhiteColor
                          : Colors.black,
                    ),
                  );
                }).toList(),
                onChanged: widget.onChange,
              ),
            ),
          ))
    ]);
  }
}

class BranchDropDown extends StatelessWidget {
  const BranchDropDown(
      {Key? key,
      this.lableName = "",
      required this.hint,
      required this.onSelect,
      this.gapHight = 8,
      required this.items,
      required this.valueType,
      this.color = kscafolledColor})
      : super(key: key);

  final ValueChanged onSelect;
  final List<BranchData> items;
  final String hint;
  final String lableName;
  final BranchData valueType;
  final double gapHight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: customtext(
          fontWeight: FontWeight.w500,
          text: lableName,
          fontsize: 13,
          color: SessionManager.getTheme() == true ? kWhiteColor : Colors.black,
        ),
      ),
      SizedBox(height: gapHight),
      Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: kblueColor, width: 1.2),
              color: SessionManager.getTheme() == true
                  ? kblueColor
                  : kWhiteColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  iconEnabledColor: SessionManager.getTheme() == true
                      ? kWhiteColor
                      : klableColor,
                  dropdownColor: SessionManager.getTheme() == true
                      ? Colors.indigo
                      : Colors.yellow.shade50,
                  itemHeight: kMinInteractiveDimension,
                  style: GoogleFonts.splineSans(
                      color: SessionManager.getTheme() == true
                          ? kWhiteColor
                          : Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                  elevation: 5,
                  value: valueType,
                  hint: customtext(
                    fontWeight: FontWeight.w500,
                    text: hint,
                    fontsize: 13,
                    color: SessionManager.getTheme() == true
                        ? kWhiteColor
                        : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  items: items.map<DropdownMenuItem<BranchData>>((value) {
                    return DropdownMenuItem<BranchData>(
                      value: value,
                      child: customtext(
                        fontWeight: FontWeight.w500,
                        text: value.btanchName!,
                        fontsize: 13,
                        color: color,
                      ),
                    );
                  }).toList(),
                  onChanged: onSelect),
            ),
          ))
    ]);
  }
}

class FilterDropDownWidget extends StatelessWidget {
  const FilterDropDownWidget({
    Key? key,
    required this.initialValue,
    required this.items,
    required this.onChange,
    this.height = 35
  }) : super(key: key);

  final String initialValue;
  final List<String> items;
  final ValueChanged onChange;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:
              SessionManager.getTheme() == true ? kscafolledColor : kWhiteColor,
          border: Border.all(color:KBoxNewColor)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            icon: const Icon(Icons.arrow_drop_down_rounded),
            iconEnabledColor:
                SessionManager.getTheme() == true ? kWhiteColor : kbuttonColor,
            dropdownColor: SessionManager.getTheme() == true
                ? Colors.indigo
                : Colors.yellow.shade50,
            itemHeight: kMinInteractiveDimension,
            style: TextStyle(
                color: SessionManager.getTheme() == true
                    ? kWhiteColor
                    : kBlackColor,
                fontFamily: "NunitoSans",
                fontWeight: FontWeight.w700,
                fontSize: 12),
            elevation: 5,
            value: initialValue,
            hint: customtext(
              fontWeight: FontWeight.w700,
              text: "",
              fontsize: 12,
              color: SessionManager.getTheme() == true
                  ? kWhiteColor
                  : kbuttonColor,
            ),
            borderRadius: BorderRadius.circular(14),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: customtext(
                  fontWeight: FontWeight.w700,
                  text: value,
                  fontsize: 12,
                  color: SessionManager.getTheme() == true
                      ? kWhiteColor
                      : kBlackColor,
                ),
              );
            }).toList(),
            onChanged: onChange),
      ),
    );
  }
}

class CustomNewDropDown extends StatefulWidget {
  final ValueChanged<String?> onChange;
  final List<String> items;
  final String hint;
  final String lableName;
  final String valueType;
  final double gapHight;
  final Color color;

  const CustomNewDropDown(
      {Key? key,
        this.lableName = "",
        required this.hint,
        required this.onChange,
        this.gapHight = 8,
        required this.items,
        required this.valueType,
        this.color = kscafolledColor})
      : super(key: key);

  @override
  State<CustomNewDropDown> createState() => _NewCustomDropDownState();
}
class _NewCustomDropDownState extends State<CustomNewDropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: customtext(
          fontWeight: FontWeight.w500,
          text: widget.lableName,
          fontsize: 14,
          color: SessionManager.getTheme() == true ? kWhiteColor : kbuttonColor,
        ),
      ),
      SizedBox(height: widget.gapHight),
      CustomPaint(
        painter: FlatCorneredBackgroundPainter(
            radius: 10.0, strokeColor: KBoxNewColor, strokeWidth: 1),
        child: Container(
            height: 50,
            width: double.infinity,

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  iconEnabledColor: SessionManager.getTheme() == true
                      ? kWhiteColor
                      : klableColor,
                  dropdownColor: SessionManager.getTheme() == true
                      ? Colors.black87
                      : Colors.yellow.shade50,
                  itemHeight: kMinInteractiveDimension,
                  style: GoogleFonts.splineSans(
                      color: SessionManager.getTheme() == true
                          ? kWhiteColor
                          : klableColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                  elevation: 5,
                  value: widget.valueType,
                  hint: customtext(
                    fontWeight: FontWeight.w700,
                    text: widget.hint,
                    fontsize: 12,
                    color: SessionManager.getTheme() == true
                        ? kWhiteColor
                        : kscafolledColor,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  items:
                  widget.items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: customtext(
                        fontWeight: FontWeight.w700,
                        text: value,
                        fontsize: 12,
                        color: SessionManager.getTheme() == true
                            ? kWhiteColor
                            : Colors.black,
                      ),
                    );
                  }).toList(),
                  onChanged: widget.onChange,
                ),
              ),
            )),
      )
    ]);
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
