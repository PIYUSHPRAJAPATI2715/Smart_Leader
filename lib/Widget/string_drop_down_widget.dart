import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/Custom_text.dart';

import '../Helper/theme_colors.dart';
import '../Modal/vidoes_name_model.dart';

class CategoreyDropDownWidget extends StatelessWidget {
  const CategoreyDropDownWidget(
      {Key? key,
        required this.initialValue,
        required this.items,
        required this.onChange})
      : super(key: key);

  final VideosNameData initialValue;
  final List<VideosNameData> items;
  final ValueChanged onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kblueColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton<VideosNameData>(
        isExpanded: true,
        value: initialValue,
        style: GoogleFonts.abhayaLibre(
            color: Theme.of(context).primaryColorLight,
            fontSize: 12,
            fontWeight: FontWeight.w400),
        underline: const SizedBox(),
        onChanged: onChange,
        items: items.map<DropdownMenuItem<VideosNameData>>((VideosNameData value) {
          return DropdownMenuItem<VideosNameData>(
            value: value,
            child: customtext(

              text: value.videoName!,
              color: Colors.black,
              fontWeight: FontWeight.w600, fontsize: 14,
            ),
          );
        }).toList(),
      ),
    );
  }
}
