import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  List frequencyContainer = ["Credit Card", "Debit Card", "Net Banking"];



  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
    return Scaffold(
      body: Column(
        children: [
          topContainer(context),
          SizedBox(height: 15,),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                             List.generate(frequencyContainer.length, (index) => Padding(
                               padding: const EdgeInsets.symmetric(vertical: 10),
                               child: InkWell(
                                 onTap: (){
                                   data.selectedPaymentOneContainer(index);
                                 },
                                 child: Container(
                                   width: double.infinity,
                                   decoration: BoxDecoration(
                                       color: SessionManager.getTheme() == true
                                           ? kscafolledColor
                                           : Color(0xffEBEBEB),
                                       shape: BoxShape.rectangle,
                                       borderRadius: BorderRadius.circular(10),
                                       border: Border.all(color:SessionManager.getTheme() == true
                                           ? data.selectedPaymentContainer == index?kWhiteColor:Colors.transparent
                                           : data.selectedPaymentContainer == index?Color(0xff011638):Colors.transparent, width: 1)),
                                   child: Padding(
                                     padding: const EdgeInsets.only(
                                       left: 20,top: 12,bottom: 12,
                                     ),
                                     child: Row(
                                       children: [
                                         Icon(
                                           data.selectedPaymentContainer == index?Icons.radio_button_on_outlined: Icons.radio_button_off_outlined,size: 17,
                                           color: SessionManager.getTheme() == true
                                               ? kWhiteColor
                                               :Color(0xff011638,
                                           ),
                                         ),
                                         SizedBox(width: 10,),
                                         customtext(
                                           fontWeight: FontWeight.w400,
                                           text: frequencyContainer[index],
                                           fontsize: 15,
                                           color: Theme.of(context).primaryColor,
                                         )
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             )),
                      ),
                    ),
                    SizedBox(height: 25,),
                    Divider(color: Theme.of(context).primaryColor,thickness: 1.2,),
                    SizedBox(height: 25,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          customtext(
                            fontWeight: FontWeight.w500,
                            text: "Payment",
                            fontsize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: customtext(
                                  fontWeight: FontWeight.w400,
                                  text: "Amount",
                                  fontsize: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              customtext(
                                fontWeight: FontWeight.w400,
                                text: "Rs 650",
                                fontsize: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: customtext(
                                  fontWeight: FontWeight.w400,
                                  text: "Discount",
                                  fontsize: 15,
                                  color: Colors.green,
                                ),
                              ),
                              customtext(
                                fontWeight: FontWeight.w400,
                                text: "- Rs 50",
                                fontsize: 15,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: customtext(
                                  fontWeight: FontWeight.w500,
                                  text: "Total",
                                  fontsize: 17,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: "Rs 600",
                                fontsize: 17,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 20,)
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          custom_Button(
            width: 200,
            hight: 55,
            onTap: () {
            },
            title: "Pay Now",
            fontSize: 15,
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget topContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assest/images/OnBordScreenTopScreen.png"),
              fit: BoxFit.fill)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 120),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: kWhiteColor,
                        )),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: customtext(
                      fontWeight: FontWeight.w500,
                      text: "Payment Method",
                      fontsize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
