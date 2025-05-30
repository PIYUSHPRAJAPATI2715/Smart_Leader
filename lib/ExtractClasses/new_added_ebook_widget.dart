import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/buy_bottum.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_book_list_modal.dart';
import 'package:smart_leader/Screen/book_description_screen.dart';

import '../Widget/bottum_navBar.dart';

class NewAddedEbookWidget extends StatefulWidget {
  ShowBookListModalData showBookListModalData;

  NewAddedEbookWidget({Key? key, required this.showBookListModalData})
      : super(key: key);

  @override
  State<NewAddedEbookWidget> createState() => _NewAddedEbookWidgetState();
}

class _NewAddedEbookWidgetState extends State<NewAddedEbookWidget> {
  void addtoCart() {
    Map<String, String> map = {
      "user_id": SessionManager.getUserID(),
      "book_id": widget.showBookListModalData.id!,
      "book_price": widget.showBookListModalData.bookPrice!
    };

    Helper.showLoaderDialog(context, message: 'Please wait...');

    ApiHelper.addtoCart(map).then((login) {
      print('message cart ${login.result}');
    //  order(widget.showBookListModalData.bookPrice!);

      //  Helper.showSnackVar(login.result!, Colors.green, context);
    });
  }

  void order(String totalAmount,String bookId) async {
    Map<String, String> body = {
      "user_id": SessionManager.getUserID(),
      "payment_status": "1",
      "grand_total": totalAmount,
      "book_id": bookId
    };

    Helper.showLoaderDialog(context,message: 'Please wait..');

    ApiHelper.placeOrder(body).then((login) {
      Navigator.pop(context);
      if (login.result == 'Order Successfull') {
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

    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookDescriptionScreen(
                        showBookListModalData: widget.showBookListModalData)));
          },
          child: Card(
            color: SessionManager.getTheme() == true
                ? kscafolledColor
                : kWhiteColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: SessionManager.getTheme() == true
                    ? kscafolledColor
                    : kWhiteColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.showBookListModalData.path! +
                        widget.showBookListModalData.image!,
                    height: 86,
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
                          text: widget.showBookListModalData.bookName!,
                          fontsize: 12,
                          color: Theme.of(context).primaryColor,
                          maxLine: 2,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        // customtext(
                        //   fontWeight: FontWeight.w400,
                        //   text: "Paperback-1",
                        //   fontsize: 10,
                        //   color:Theme.of(context).primaryColor,
                        // ),
                        SizedBox(
                          height: 35,
                        ),
                        RatingBar.builder(
                          itemSize: 15,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => Icon(
                            Icons.star_rounded,
                            color: Color(0xffFFC107),
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        customtext(
                          fontWeight: FontWeight.w400,
                          text: widget.showBookListModalData.writerName!,
                          fontsize: 8,
                          color: Theme.of(context).primaryColor,
                          maxLine: 1,
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      customtext(
                        fontWeight: FontWeight.w500,
                        text: "₹${widget.showBookListModalData.bookPrice!}",
                        fontsize: 20,
                        color: SessionManager.getTheme() == true
                            ? kblueColor
                            : kgreenColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BuyBottun(
                          title: "Buy Now",
                          horizontalWidth: 7,
                          onTap: () {
                            //  addtoCart();
                            order(widget.showBookListModalData.bookPrice!,
                                widget.showBookListModalData.id!);
                          },
                          verticleHight: 9)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 4,
          top: 5,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                color: kyelloColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: customtext(
              fontWeight: FontWeight.w400,
              text: "New",
              fontsize: 10,
              color: kBlackColor,
            ),
          ),
        )
      ],
    );
  }
}
