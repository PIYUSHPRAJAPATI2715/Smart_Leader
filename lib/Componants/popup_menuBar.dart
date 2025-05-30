import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class SimplePopUp extends StatefulWidget {
  final ValueChanged<int> onChanged;

  const SimplePopUp(
      {Key? key,
      required this.color,
      required this.onChanged,
      this.isMoveShow = false,
      this.isEditShow = true})
      : super(key: key);

  final Color color;
  final bool isMoveShow;
  final bool isEditShow;

  @override
  State<SimplePopUp> createState() => _SimplePopUpState();
}

class _SimplePopUpState extends State<SimplePopUp> {
  bool isSummited = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: PopupMenuButton<int>(
        onSelected: widget.onChanged,
        padding: EdgeInsets.zero,
        icon: Icon(Icons.more_vert_rounded, color: widget.color),
        offset: Offset(-15, 0),
        iconSize: 20,
        color: widget.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: () {},
            height: 3,
            value: 1,
            child: Visibility(
              visible: widget.isEditShow,
              child: Center(
                child: customtext(
                  fontWeight: FontWeight.w500,
                  text: "Edit",
                  fontsize: 15,
                  color: SessionManager.getTheme() == true
                      ? kBlackColor
                      : kWhiteColor,
                  alignment: TextAlign.center,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            onTap: () {},
            height: 3,
            value: 2,
            child: Visibility(
              visible: widget.isEditShow,
              child: Column(
                children: [
                  Divider(
                    thickness: 2,
                    color: SessionManager.getTheme() == true
                        ? kBlackColor
                        : kWhiteColor,
                  )
                ],
              ),
            ),
          ),
          PopupMenuItem(
            onTap: () {},
            height: 3,
            value: 3,
            child: Center(
              child: customtext(
                fontWeight: FontWeight.w500,
                text: "Delete",
                fontsize: 15,
                color: SessionManager.getTheme() == true
                    ? kBlackColor
                    : kWhiteColor,
                alignment: TextAlign.center,
              ),
            ),
          ),
          PopupMenuItem(
            onTap: () {},
            height: 3,
            value: 2,
            child: Visibility(
              visible: widget.isMoveShow,
              child: Column(
                children: [
                  Divider(
                    thickness: 2,
                    color: SessionManager.getTheme() == true
                        ? kBlackColor
                        : kWhiteColor,
                  )
                ],
              ),
            ),
          ),
          // PopupMenuItem(
          //   onTap: () {},
          //   height: 3,
          //   value: 4,
          //   child: Visibility(
          //     visible: widget.isMoveShow,
          //     child: Center(
          //       child: customtext(
          //         fontWeight: FontWeight.w500,
          //         text: "Move",
          //         fontsize: 15,
          //         color: SessionManager.getTheme() == true
          //             ? kBlackColor
          //             : kWhiteColor,
          //         alignment: TextAlign.center,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
    ;
  }
}
