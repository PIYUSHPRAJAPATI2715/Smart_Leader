import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class Custom_flowting_action_button extends StatelessWidget {
  VoidCallback onTap;
  Custom_flowting_action_button({
    Key? key,required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed:onTap,
      child: Container(
        decoration: BoxDecoration(
            gradient:
            SessionManager.getTheme() == true ? k2Gradient : kGradient,
            shape: BoxShape.circle),
        child: Center(
            child: Icon(
              Icons.add,
              color:
              SessionManager.getTheme() == true ? kBlackColor : kWhiteColor,
              size: 45,
            )),
      ),
    );
  }
}
