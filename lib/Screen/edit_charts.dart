import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/ExtractClasses/bottom_sheet_screen.dart';
import 'package:smart_leader/ExtractClasses/esitChart_bottom_sheet_screen.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Widget/chartDetails.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:smart_leader/Widget/editChart_details.dart';

class EditChartScreen extends StatefulWidget {
  const EditChartScreen({Key? key}) : super(key: key);

  @override
  State<EditChartScreen> createState() => _EditChartScreenState();
}

class _EditChartScreenState extends State<EditChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 102,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image:
                    AssetImage("assest/images/OnBordScreenTopScreen.png"),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: kWhiteColor,
                      )),
                  Expanded(
                    child: Center(
                      child: customtext(
                        fontWeight: FontWeight.w500,
                        text: "Smart Leader",
                        fontsize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {

                        Navigator.pop(context);

                      },
                      child: Image.asset(
                        "assest/png_icon/home_removebg_preview.png",
                        height: 25,
                        width: 25,
                      ))

                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                        hight: 50,
                        title: "Enter Title",
                        controller: TextEditingController(),
                        hint: "Title",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        lableName: "Chart Title",
                        hintfont: 12,
                        lablefont: 14),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15)),
                                    color: kblueColor),
                                child: Center(
                                  child: customtext(
                                    fontWeight: FontWeight.w500,
                                    text: "Team Name",
                                    fontsize: 12,
                                    color:kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 26, horizontal: 0.5),
                              decoration: BoxDecoration(color: kWhiteColor),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                    color: kblueColor),
                                child: Center(
                                  child: customtext(
                                    fontWeight: FontWeight.w500,
                                    text: "Target Business",
                                    fontsize: 12,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 26, horizontal: 0.5),
                              decoration: BoxDecoration(color: kWhiteColor),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15)),
                                    color: kblueColor),
                                child: Center(
                                  child: customtext(
                                    fontWeight: FontWeight.w500,
                                    text: "Actual Business",
                                    fontsize: 12,
                                    color:kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        EditChartDetail(),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15)),
                                    color: Color(
                                      0xffAFAEFE,
                                    )),
                                child: Center(
                                  child: customtext(
                                    fontWeight: FontWeight.w700,
                                    text: "Total",
                                    fontsize: 13,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 26, horizontal: 0.5),
                              decoration: BoxDecoration(color: kWhiteColor),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                    color: Color(
                                      0xffAFAEFE,
                                    )),
                                child: Center(
                                  child: customtext(
                                    fontWeight: FontWeight.w700,
                                    text: "9 Lakh",
                                    fontsize: 13,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 26, horizontal: 0.5),
                              decoration: BoxDecoration(color: kWhiteColor),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(15)),
                                    color: Color(
                                      0xffAFAEFE,
                                    )),
                                child: Center(
                                  child: customtext(
                                    fontWeight: FontWeight.w700,
                                    text: "9 Lakh",
                                    fontsize: 13,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              custom_Button(
                                  onTap: () {},
                                  title: "Save",
                                  hight: 45,
                                  width: 78,
                                  fontSize: 14),
                            ],
                          ),
                        ),
                        custom_Button(
                            onTap: () {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      )),
                                  context: context,
                                  builder: (context) {
                                    return EditChartBottumSheet();
                                  });
                            },
                            title: "AddTeam +",
                            hight: 45,
                            width: 87,
                            fontSize: 12),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
