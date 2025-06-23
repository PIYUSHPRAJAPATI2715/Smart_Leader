import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/Custom_text.dart';

import '../Helper/theme_colors.dart';
import '../Modal/show_videos_modal.dart';
import '../Modal/vidoes_name_model.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import '../Helper/theme_colors.dart';
import '../Modal/vidoes_name_model.dart';

class CategoreyDropDownWidget extends StatelessWidget {
  const CategoreyDropDownWidget({
    Key? key,
    required this.initialValue,
    required this.items,
    required this.onChange,
  }) : super(key: key);

  final ShowVideosModalData initialValue;
  final List<ShowVideosModalData> items;
  final ValueChanged<ShowVideosModalData?> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.brown),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton<ShowVideosModalData>(
        isExpanded: true,
        icon:Icon( Icons.arrow_drop_down,color: Colors.brown,),
        value: initialValue,
        style: TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        underline: const SizedBox(),
        onChanged: onChange,
        items: items.map((ShowVideosModalData value) {
          return DropdownMenuItem<ShowVideosModalData>(
            value: value,
            child: customtext(
              text: value.tagName ?? '',
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontsize: 14,
            ),
          );
        }).toList(),
      ),
    );
  }
}

