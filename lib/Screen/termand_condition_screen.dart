import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Modal/termsCondition_modal.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class TermAndConditionScreen extends StatefulWidget {
  const TermAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermAndConditionScreen> createState() => _TermAndConditionScreenState();
}

class _TermAndConditionScreenState extends State<TermAndConditionScreen> {

  late Future<TermsConditionModal>termsCondi;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    termsCondi = ApiHelper.termCondition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          TopContainer(onTap: (){
            Navigator.pop(context);
          }, title: ""),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customtext(fontsize: 20,fontWeight: FontWeight.w500,text: "Terms and Condition",color: Theme.of(context).primaryColor,),
                    SizedBox(height: 20,),

                    FutureBuilder<TermsConditionModal>(
                        future: termsCondi,
                        builder: (context, snapshot){
                          if(snapshot.connectionState==ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator(),);
                          }
                      return Column(
                        children: [
                          HtmlWidget(snapshot.data!.description!,
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
