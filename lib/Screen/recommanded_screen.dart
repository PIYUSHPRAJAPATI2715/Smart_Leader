import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class RecommandedScreen extends StatefulWidget {
  const RecommandedScreen({Key? key}) : super(key: key);

  @override
  State<RecommandedScreen> createState() => _RecommandedScreenState();
}

class _RecommandedScreenState extends State<RecommandedScreen> {
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

          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: kWhiteColor,
              child: Center(
                  child: Image.asset(
                    "assest/images/recommimage.png",
                    height: 55,
                    width: 55,
                  )),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),),
                color:SessionManager.getTheme() == true
                    ? kscafolledColor
                    : klightblue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customtext(
                    fontWeight: FontWeight.w600,
                    text: "Lorem Ipsum is Simply Dummy",
                    fontsize: 2,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                  SizedBox(height: 20,),
                  customtext(

                    fontWeight: FontWeight.w400,
                    text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
                    fontsize: 12,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ],
              ),
            ),
          )
          
        ],
      ),
    );
  }
}
