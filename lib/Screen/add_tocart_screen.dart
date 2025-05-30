import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Button2.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_cart_book_modal.dart';
import 'package:smart_leader/Screen/download_screen.dart';
import 'package:smart_leader/Screen/home_screen.dart';
import 'package:smart_leader/Screen/payment_screen.dart';
import 'package:smart_leader/Widget/bottum_navBar.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({Key? key}) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  bool isSubmit = true;
  List<ShowCartBookModalData> showCartList = [];
  String totalAmount = "";
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCart();
  }

  void showCart() {
    ApiHelper.showCart().then((value) {
      setState(() {
        isSubmit = false;
      });
      showCartList = value.data!;
      totalAmount = "${value.totalPrice}";
    });
  }

  void delete(String id) async {
    Map<String, String> body = {
      "id": id,
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.deleteCart(body).then((login) {
      if (login.message == " Successfully Deleted") {
        Helper.showSnackVar("Remove Successfully", Colors.green, context);

        // Helper.showLoaderDialog(context);

        setState(() {
          isSubmit = false;
        });

        showCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopContainer(
              onTap: () {
                Navigator.pop(context);
              },
              title: "Checkout"),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    booksContainer(context),
                    SizedBox(
                      height: 20,
                    ),
                    // customtext(
                    //   fontWeight: FontWeight.w500,
                    //   text: "Payment",
                    //   fontsize: 20,
                    //   color: Theme.of(context).primaryColor,
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: customtext(
                    //         fontWeight: FontWeight.w400,
                    //         text: "Sub Total",
                    //         fontsize: 15,
                    //         color: Theme.of(context).primaryColor,
                    //       ),
                    //     ),
                    //     customtext(
                    //       fontWeight: FontWeight.w400,
                    //       text: "Rs 650",
                    //       fontsize: 15,
                    //       color: Theme.of(context).primaryColor,
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: customtext(
                    //         fontWeight: FontWeight.w400,
                    //         text: "Discount",
                    //         fontsize: 15,
                    //         color: Colors.green,
                    //       ),
                    //     ),
                    //     customtext(
                    //       fontWeight: FontWeight.w400,
                    //       text: "- Rs 50",
                    //       fontsize: 15,
                    //       color: Colors.green,
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: customtext(
                    //         fontWeight: FontWeight.w500,
                    //         text: "Total",
                    //         fontsize: 17,
                    //         color: Theme.of(context).primaryColor,
                    //       ),
                    //     ),
                    //     customtext(
                    //       fontWeight: FontWeight.w500,
                    //       text: "Rs 600",
                    //       fontsize: 17,
                    //       color: Theme.of(context).primaryColor,
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                    child: isSubmit == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: "Total",
                                fontsize: 17,
                                color: Theme.of(context).primaryColor,
                              ),
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: "Rs ${totalAmount}",
                                fontsize: 17,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          )),
                isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : custom_Button(
                        width: 200,
                        hight: 55,
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen()));
                          order();
                        },
                        title: "Go To Checkout",
                        fontSize: 15,
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget booksContainer(BuildContext context) {
    return isSubmit == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: showCartList.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 7),
                color: SessionManager.getTheme() == true
                    ? kscafolledColor
                    : kWhiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        showCartList[index].path! + showCartList[index].image!,
                        height: 70,
                        width: 57,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customtext(
                              fontWeight: FontWeight.w500,
                              text: showCartList[index].bookName!,
                              fontsize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                            customtext(
                              fontWeight: FontWeight.w400,
                              text: showCartList[index].writerName!,
                              fontsize: 10,
                              color: Theme.of(context).primaryColor,
                            ),
                            customtext(
                              fontWeight: FontWeight.w400,
                              text: "",
                              fontsize: 10,
                              color: Theme.of(context).primaryColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue.shade100),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    child: Center(
                                        child: customtext(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            text:
                                                "Rs ${showCartList[index].bookPrice!}",
                                            fontsize: 13)),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            delete(showCartList[index].id!);
                          });
                          showCart();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: SessionManager.getTheme() == true
                                    ? kWhiteColor
                                    : kbuttonColor),
                            child: Icon(
                              Icons.clear,
                              size: 16,
                              color: SessionManager.getTheme() == true
                                  ? kBlackColor
                                  : kWhiteColor,
                            )),
                      )
                    ],
                  ),
                ),
              );
            });
  }

  void order() async {

    Map<String, String> body = {
      "user_id": SessionManager.getUserID(),
      "payment_status": "1",
      "grand_total": totalAmount
    };

    setState(() {
      isLoading = true;
    });

    ApiHelper.placeOrder(body).then((login) {
      setState(() {
        isLoading = false;
      });

      if (login.result == 'Order Successfull') {
        // Helper.showSnackVar(
        //     'Successfully Placed Ordre', Colors.green, context);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: customtext(
              fontWeight: FontWeight.w500,
              text: "Your Order Placed Successfully",
              fontsize: 20,
              color: Theme.of(context).primaryColor,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (ctx) => BottumNavBar()),
                          (route) => false);
                    },
                    child: Container(
                      color: Colors.green,
                      padding: const EdgeInsets.all(14),
                      child: const Text("Done"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        Helper.showSnackVar('Error', Colors.red, context);
      }

      showCart();
    });
  }
}
