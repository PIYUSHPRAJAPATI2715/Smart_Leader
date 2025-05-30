import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/dialog_audio_player_widget.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/ExtractClasses/ebooks_widget.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_book_list_modal.dart';
import 'package:smart_leader/Screen/add_tocart_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widget/bottum_navBar.dart';

class BookDescriptionScreen extends StatefulWidget {
  final ShowBookListModalData showBookListModalData;

  const BookDescriptionScreen({Key? key, required this.showBookListModalData})
      : super(key: key);

  @override
  State<BookDescriptionScreen> createState() => _BookDescriptionScreenState();
}

class _BookDescriptionScreenState extends State<BookDescriptionScreen> {
  String bookType = '';

  void addtoCart() {
    Map<String, String> map = {
      "user_id": SessionManager.getUserID(),
      "book_id": widget.showBookListModalData.id!,
      "book_price": widget.showBookListModalData.bookPrice!
    };

    Helper.showLoaderDialog(context, message: 'Please wait...');

    ApiHelper.addtoCart(map).then((login) {
      print('message cart ${login.result}');

      // order(widget.showBookListModalData.bookPrice!);

      //  Helper.showSnackVar(login.result!, Colors.green, context);
    });
  }

  void showBuyBottomSheet(String price) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: kblueColor,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: customtext(
                        fontWeight: FontWeight.w500,
                        text: widget.showBookListModalData.bookName!,
                        fontsize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear, color: Colors.white))
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          widget.showBookListModalData.path! +
                              widget.showBookListModalData.image!,
                          height: 180,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: widget.showBookListModalData.bookName!,
                                fontsize: 16,
                                maxLine: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: 5.0),
                              customtext(
                                fontWeight: FontWeight.w500,
                                text:
                                    'By ${widget.showBookListModalData.writerName!}',
                                fontsize: 14,
                                maxLine: 1,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 5.0),
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: "₹$price",
                                fontsize: 17,
                                color: SessionManager.getTheme() == true
                                    ? kblueColor
                                    : kgreenColor,
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.blueGrey),
                                child: customtext(
                                  fontWeight: FontWeight.w600,
                                  text:
                                      widget.showBookListModalData.tagId ?? '',
                                  fontsize: 10.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              custom_Button(
                                  onTap: () {
                                    Navigator.pop(context);
                                    order(price,
                                        widget.showBookListModalData.id!);
                                  },
                                  title: 'Buy $bookType',
                                  hight: 45,
                                  width: double.infinity,
                                  fontSize: 14)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  void order(String totalAmount, String bookId) async {
    Map<String, String> body = {
      "user_id": SessionManager.getUserID(),
      "payment_status": "1",
      "grand_total": totalAmount,
      "book_id": bookId,
      'type': bookType,
    };

    Helper.showLoaderDialog(context, message: 'Please wait..');

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

  String selectedBook = '';

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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          height: 200,
                          fit: BoxFit.cover,
                          widget.showBookListModalData.path! +
                              widget.showBookListModalData.image!,
                        ),
                      ),
                      /*Container(
                        height: 260,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: SessionManager.getTheme() == true
                                ? kscafolledColor
                                : kWhiteColor,
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(
                                  widget.showBookListModalData.path! +
                                      widget.showBookListModalData.image!,
                                ),
                                fit: BoxFit.fill)),
                      ),*/
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: customtext(
                                      fontWeight: FontWeight.w600,
                                      text: widget
                                          .showBookListModalData.bookName!,
                                      fontsize: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 15.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.blueGrey),
                                    child: customtext(
                                      fontWeight: FontWeight.w600,
                                      text:
                                          widget.showBookListModalData.tagId ??
                                              '',
                                      fontsize: 10.0,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              customtext(
                                fontWeight: FontWeight.w400,
                                text: widget.showBookListModalData.writerName!,
                                fontsize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  BookAmountWidget(
                                    amount: widget
                                        .showBookListModalData.eBookPrice!,
                                    image: 'ebook.png',
                                    onClick: () {
                                      bookType = 'Ebook';
                                      showBuyBottomSheet(widget
                                          .showBookListModalData.eBookPrice!);
                                      // setState(() {
                                      //   bookType = 'Ebook';
                                      // });
                                      // order(widget
                                      //     .showBookListModalData
                                      //     .eBookPrice!, widget
                                      //     .showBookListModalData.id!);
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  BookAmountWidget(
                                    amount: widget
                                        .showBookListModalData.audioPrice!,
                                    image: 'audio_book.png',
                                    onClick: () {
                                      bookType = 'Audio';
                                      showBuyBottomSheet(widget
                                          .showBookListModalData.audioPrice!);
                                      // setState(() {
                                      //   bookType = 'Audio';
                                      // });
                                      // order(widget
                                      //     .showBookListModalData
                                      //     .audioPrice!, widget
                                      //     .showBookListModalData.id!);
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  BookAmountWidget(
                                    amount: widget
                                        .showBookListModalData.amazonPrice!,
                                    image: 'amazon_icon.png',
                                    onClick: () async {
                                      String url = widget
                                          .showBookListModalData.amazonLink!;
                                      await launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  BookAmountWidget(
                                    amount: widget
                                        .showBookListModalData.flipkartPrice!,
                                    image: 'flipkart.png',
                                    onClick: () async {
                                      String url = widget
                                          .showBookListModalData.flipkartLink!;
                                      await launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              const SizedBox(height: 10.0),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        String url =
                                            widget.showBookListModalData.path! +
                                                widget.showBookListModalData
                                                    .audioFile!;
                                        return DialogAudioPlayerWidget(
                                            url: url);
                                      });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  child: customtext(
                                    fontWeight: FontWeight.w600,
                                    text: 'Book Summary (Audio)',
                                    fontsize: 15,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(
                        thickness: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            customtext(
                              fontWeight: FontWeight.w600,
                              text: "Description",
                              fontsize: 19,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            customtext(
                              fontWeight: FontWeight.w400,
                              text: widget.showBookListModalData.description!,
                              fontsize: 13,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                            /*
                            custom_Button(
                                onTap: () {
                                  order(widget.showBookListModalData.bookPrice!,
                                      widget.showBookListModalData.id!);
                                },
                                title: "Buy Book",
                                hight: 55,
                                width: 200,
                                fontSize: 20),*/
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
