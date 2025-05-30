import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class AnalysisContainerWidget extends StatelessWidget {
  const AnalysisContainerWidget(
      {super.key,
      required this.icon,
      required this.text,
      required this.onClick});

  final IconData icon;
  final String text;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        decoration: BoxDecoration(
            color: kblueColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 15.0),
            customtext(
              alignment: TextAlign.center,
              fontWeight: FontWeight.w600,
              text: text,
              fontsize: 13.0,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
