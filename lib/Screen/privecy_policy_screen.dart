import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Modal/privecy_policy_screen.dart';
import 'package:smart_leader/Modal/termsCondition_modal.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

import '../Helper/theme_colors.dart';

class PrivecyPolicyScreen extends StatefulWidget {
  const PrivecyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivecyPolicyScreen> createState() => _PrivecyPolicyScreenState();
}

class _PrivecyPolicyScreenState extends State<PrivecyPolicyScreen> {

  late Future<PrivecyPolicyModal>privecyPolicy1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    privecyPolicy1 = ApiHelper.privecyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customtext(fontsize: 20,fontWeight: FontWeight.w500,text: "Privacy Policy",color: Theme.of(context).primaryColor,),
                    SizedBox(height: 20,),

                    FutureBuilder<PrivecyPolicyModal>(
                        future: privecyPolicy1,
                        builder: (context, snapshot){
                          if(snapshot.connectionState==ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator(),);
                          }
                          return Column(
                            children: [
                              HtmlWidget(snapshot.data!.description??"",
                                textStyle:GoogleFonts.splineSans(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              
                            ],
                          );

                        })

                  ],
                ),
              ),
            ),
          ),
          bottumContainer()

        ],
      ),

    );
  }

  Widget bottumContainer() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assest/images/OnBordScreenBottumImage.png"),
              fit: BoxFit.fill)),
    );
  }
}
