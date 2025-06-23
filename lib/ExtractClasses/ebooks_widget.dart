import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/dialog_audio_player_widget.dart';
import 'package:smart_leader/Componants/neumorphism_widget.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_book_list_modal.dart';
import 'package:smart_leader/Screen/book_description_screen.dart';
import 'package:smart_leader/Widget/bottum_navBar.dart';
import 'package:url_launcher/url_launcher.dart';

class EbooksWidget extends StatefulWidget {
  Data showBookListModalData;

  EbooksWidget({Key? key, required this.showBookListModalData})
      : super(key: key);

  @override
  State<EbooksWidget> createState() => _EbooksWidgetState();
}

class _EbooksWidgetState extends State<EbooksWidget> {
  bool isSubmit = false;

  String bookType = '';

  void addtoCart() {
    Map<String, String> map = {
      "user_id": SessionManager.getUserID(),
      "book_id": widget.showBookListModalData.id!,
      // "book_price": widget.showBookListModalData.bookPrice!
    };

    Helper.showLoaderDialog(context, message: 'Please wait...');

    ApiHelper.addtoCart(map).then((login) {
      print('message cart ${login.result}');
      //  order(widget.showBookListModalData.bookPrice!);

      //  Helper.showSnackVar(login.result!, Colors.green, context);
    });
  }
  Future<void> _shareOnWhatsApp(String videoUrl) async {
    final Uri whatsappUrl = Uri.parse("whatsapp://send?text=Check out this video: $videoUrl");
    final Uri playStoreUrl = Uri.parse("https://play.google.com/store/apps/details?id=com.whatsapp");

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        // Redirect to Play Store if WhatsApp is not installed
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('WhatsApp not found. Redirecting to Play Store...')));
        await launchUrl(playStoreUrl);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
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
                padding: EdgeInsets.symmetric(horizontal: 15.0),
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
                        SizedBox(width: 15.0),
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
                              SizedBox(height: 5.0),
                              customtext(
                                fontWeight: FontWeight.w500,
                                text:
                                    'By ${widget.showBookListModalData.writerName!}',
                                fontsize: 14,
                                maxLine: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 5.0),
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: "₹$price",
                                fontsize: 17,
                                color: SessionManager.getTheme() == true
                                    ? kblueColor
                                    : kgreenColor,
                              ),
                              SizedBox(height: 15.0),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 10, vertical: 8.0),
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(25),
                              //       color: Colors.blueGrey),
                              //   child: customtext(
                              //     fontWeight: FontWeight.w600,
                              //     text:
                              //         widget.showBookListModalData.tagId ?? '',
                              //     fontsize: 10.0,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              SizedBox(height: 15.0),
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
      'type': bookType
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 9.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: InkWell(
                onTap: (){
                  final url = widget.showBookListModalData.path! + widget.showBookListModalData.bookAudio!;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DialogAudioPlayerWidget(
                        url: url,
                        title: widget.showBookListModalData.bookName!,
                        auther: widget.showBookListModalData.writerName!,
                      );
                    },
                  );
                },
                child: Image.network(
                  widget.showBookListModalData.path! + widget.showBookListModalData.image!,
                  height: 160,
                  width: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.showBookListModalData.bookName ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'By ${widget.showBookListModalData.writerName}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final url = widget.showBookListModalData.path! + widget.showBookListModalData.bookAudio!;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogAudioPlayerWidget(
                                    url: url,
                                    title: widget.showBookListModalData.bookName!,
                                    auther: widget.showBookListModalData.writerName!,
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              backgroundColor: KBoxNewColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            icon: const Icon(Icons.play_arrow, size: 18),
                            label: const Text("Play"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final url = widget.showBookListModalData.path! + widget.showBookListModalData.bookAudio!;
                              Share.share('Check this out: $url');
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              side: BorderSide(color: KBoxNewColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            icon: const Icon(Icons.share, size: 18),
                            label: const Text("Share"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

class BookAmountWidget extends StatelessWidget {
  const BookAmountWidget(
      {Key? key,
      required this.amount,
      required this.image,
      required this.onClick})
      : super(key: key);

  final String amount;
  final String image;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200, width: 0.5)),
        child: Column(
          children: [
            Image.asset('assest/png_icon/$image',
                height: 45.0, fit: BoxFit.cover),
            const SizedBox(height: 5.0),
            customtext(
              fontWeight: FontWeight.w500,
              text: "₹${amount}",
              fontsize: 14,
              color:
                  SessionManager.getTheme() == true ? kblueColor : kgreenColor,
            ),
          ],
        ),
      ),
    );
  }
}
/*
Card(
        color:
            SessionManager.getTheme() == true ? kscafolledColor : kWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(),
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 150,
                color: SessionManager.getTheme() == true
                    ? kscafolledColor
                    : kWhiteColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          widget.showBookListModalData.path! +
                              widget.showBookListModalData.image!,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      customtext(
                        fontWeight: FontWeight.w500,
                        text: widget.showBookListModalData.bookName!,
                        fontsize: 12,
                        maxLine: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      customtext(
                        fontWeight: FontWeight.w500,
                        text: "₹${widget.showBookListModalData.bookPrice!}",
                        fontsize: 20,
                        color: SessionManager.getTheme() == true
                            ? kblueColor
                            : kgreenColor,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RatingBar.builder(
                                  itemSize: 15,
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xffFFC107),
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                customtext(
                                  fontWeight: FontWeight.w400,
                                  maxLine: 1,
                                  text:
                                      widget.showBookListModalData.writerName!,
                                  fontsize: 8,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                          BuyBottun(
                              title: "Buy Book",
                              horizontalWidth: 4,
                              onTap: () {
                                order(widget.showBookListModalData.bookPrice!,
                                    widget.showBookListModalData.id!);
                              },
                              fontSize: 9,
                              verticleHight: 9),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
 */
