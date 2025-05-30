import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: SizedBox(
        height: 30.0,
        child: Row(
          children: [
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: kblueColor,
              checkColor: Colors.white,
              side: const BorderSide(color: kblueColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
            Expanded(
              child: customtext(
                fontWeight: FontWeight.normal,
                text: label,
                fontsize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
 text: label,
              textColor: kScaffoldColor,
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
 */
