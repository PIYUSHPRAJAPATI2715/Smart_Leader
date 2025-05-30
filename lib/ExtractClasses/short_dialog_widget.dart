import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Button2.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class ShortDialogWidget extends StatelessWidget {
  final VoidCallback dateOntap;
  final VoidCallback alphaOntap;
  final VoidCallback onZtoATap;
  final VoidCallback onDSCDateTap;
  final VoidCallback onFrequencyTap;
  final bool isFrequencyVisible;

  const ShortDialogWidget(
      {Key? key,
      required this.alphaOntap,
      required this.dateOntap,
      required this.onZtoATap,
      required this.onDSCDateTap,
      required this.onFrequencyTap,
      this.isFrequencyVisible = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(color: kblueColor),
                child: Row(
                  children: [
                    Expanded(
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Filter",
                            color: Colors.white,
                            fontsize: 20)),
                    CustomRoundedBottun2(
                        widget: Icon(
                          Icons.clear,
                          size: 12,
                          color: SessionManager.getTheme() == true
                              ? kBlackColor
                              : kWhiteColor,
                        ),
                        height: 18,
                        width: 18,
                        ontap: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: onDSCDateTap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Sort by Date (DSC)",
                            color: Theme.of(context).primaryColor,
                            fontsize: 15),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: dateOntap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Sort by Date (ASC)",
                            color: Theme.of(context).primaryColor,
                            fontsize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: alphaOntap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Sort by A to Z",
                            color: Theme.of(context).primaryColor,
                            fontsize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: onZtoATap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "Sort by Z to A",
                            color: Theme.of(context).primaryColor,
                            fontsize: 15),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: isFrequencyVisible,
                      child: InkWell(
                        onTap: onFrequencyTap,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10)),
                          child: customtext(
                              fontWeight: FontWeight.w500,
                              text: "Sort Frequency",
                              color: Theme.of(context).primaryColor,
                              fontsize: 15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
