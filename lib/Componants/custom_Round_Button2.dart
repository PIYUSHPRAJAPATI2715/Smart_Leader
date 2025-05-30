import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';

class CustomRoundedBottun2 extends StatelessWidget {

  // IconData icon;
  VoidCallback ontap;
  double height;
  double width;
  Widget widget;


  CustomRoundedBottun2({Key? key, required this.widget,required this.height,required this.width,required this.ontap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed:ontap, icon: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: SessionManager.getTheme()== true?kWhiteColor:kbuttonColor,
          shape: BoxShape.circle
      ),
      child:Center(child: widget),
    ));
  }
}
