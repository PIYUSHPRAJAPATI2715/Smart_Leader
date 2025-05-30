import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/buy_bottum.dart';
import 'package:smart_leader/Componants/custom_Round_Bottun.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/downloaded_book_modal.dart';
import 'package:smart_leader/Modal/show_added_video_modal.dart';
import 'package:smart_leader/Provider/app_controller.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';
import 'package:smart_leader/Screen/dowloaded_book_discription_screen.dart';
import 'package:smart_leader/Screen/new_added_books_screen.dart';
import 'package:smart_leader/Screen/vedio_discription_screen.dart';
import 'package:smart_leader/Screen/view_book_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:smart_leader/Widget/vocabsy_book_widget.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  bool loading = false;
  Dio dio = Dio();
  String filePath = "";
  bool isSubmit = false;
  List<DownloadEbooksModalData> showBookList = [];
  List<ShowVideoModalData> showVideoList = [];

  @override
  void initState() {
    super.initState();
    showBook();
    showVideo();
  }

  download(String url, name) async {
    if (Platform.isAndroid || Platform.isIOS) {
      await downloadFile(url, name);
    } else {
      loading = false;
    }

    VocsyEpub.setConfig(
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode: false,
    );

    // get current locator
    VocsyEpub.locatorStream.listen((locator) {
      print('LOCATOR: $locator');
    });

    VocsyEpub.open(
      filePath,
      lastLocation: EpubLocator.fromJson({
        "bookId": "2239",
        "href": "/OEBPS/ch06.xhtml",
        "created": 1539934158390,
        "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
      }),
    );
  }

  void showBook() {
    ApiHelper.showeDowloadedList("1").then((value) {
      setState(() {
        isSubmit = false;
      });
      showBookList = value.data!;
    });
  }

  void showVideo() {
    ApiHelper.showaddedVideo().then((value) {
      setState(() {
        isSubmit = false;
      });
      showVideoList = value.data!;
    });
  }

  void delete(String id) async {
    Map<String, String> body = {
      "id": id,
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.removeVideo(body).then((login) {
      if (login.message == " Successfully Deleted") {
        Helper.showSnackVar("Remove Successfully", Colors.green, context);

        // Helper.showLoaderDialog(context);

        setState(() {
          isSubmit = false;
        });

        showVideo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data1 = Provider.of<AppController>(context);
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
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

            Container(
              height: 42,
              margin: EdgeInsets.symmetric(horizontal: 21, vertical: 12),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffE7E7E7), width: 2),
                  color: SessionManager.getTheme() == true
                      ? kscafolledColor
                      : kWhiteColor,
                  borderRadius: BorderRadius.circular(5)),
              child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: SessionManager.getTheme() == true
                          ? k2Gradient
                          : kGradient),
                  unselectedLabelColor: kWhiteColor,
                  onTap: (index) {
                    data1.tabBarStatus(index);
                  },
                  tabs: [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: customtext(
                          fontWeight: FontWeight.w500,
                          text: "Books",
                          fontsize: 18,
                          color: data1.tabBarIndex == 0
                              ? SessionManager.getTheme() == true
                                  ? k2BlackColor
                                  : kWhiteColor
                              : kBlackColor,
                        ),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: customtext(
                            fontWeight: FontWeight.w500,
                            text: "video",
                            fontsize: 18,
                            color: data1.tabBarIndex == 1
                                ? SessionManager.getTheme() == true
                                    ? k2BlackColor
                                    : kWhiteColor
                                : kBlackColor),
                      ),
                    ),
                  ]),
            ),
            Expanded(
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [booksContainer(context), videoContainer(context)]),
            )
          ],
        ),
      ),
    );
  }

  Widget booksContainer(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return isSubmit == true
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: showBookList.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewBookScreen()));
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>VocapsyBookWidget()));
                  },
                  child: Card(
                    color: SessionManager.getTheme() == true
                        ? kscafolledColor
                        : kWhiteColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3)],
                          borderRadius: BorderRadius.circular(20),
                          color: SessionManager.getTheme() == true
                              ? kscafolledColor
                              : kWhiteColor),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            showBookList[index].path! +
                                showBookList[index].book!.image!,
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
                                  text: showBookList[index].book!.bookName!,
                                  fontsize: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                // customtext(
                                //   fontWeight: FontWeight.w400,
                                //   text: showBookList[index].writerName!,
                                //   fontsize: 10,
                                //   color: Theme.of(context).primaryColor,
                                // ),
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    BuyBottun(
                                        title: "Read More",
                                        horizontalWidth: 18,
                                        onTap: () async {
                                          // print("jhjdhjkh${showBookList[index].eBook!.file!}");
                                          // download(showBookList[index].path!+showBookList[index].eBook!.file!,showBookList[index].eBook!.file!);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DownloadedBookDiscriptionScreen(
                                                        downloadEbooksModalData:
                                                            showBookList[index],
                                                      )));
                                        },
                                        verticleHight: 9)
                                  ],
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
                                  text: showBookList[index].book!.writerName!,
                                  fontsize: 10,
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
  }

  Future downloadFile(String url, name) async {
    if (await Permission.storage.isGranted) {
      await Permission.storage.request();
      await startDownload(url, name);
    } else {
      await startDownload(url, name);
    }
  }

  startDownload(String url, name) async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = appDocDir!.path + '/text.epub';
    File file = File(path);

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        url,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          print((receivedBytes / totalBytes * 100).toStringAsFixed(0));
          setState(() {
            loading = true;
          });
        },
      ).whenComplete(() {
        setState(() {
          loading = false;
          filePath = path;
        });
      });
    } else {
      setState(() {
        loading = false;
        filePath = path;
      });
    }
  }

  Widget videoContainer(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return isSubmit == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: showVideoList.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        title: customtext(
                          fontWeight: FontWeight.w500,
                          text: showVideoList[index].video!.videoName!,
                          fontsize: 22,
                          color: Theme.of(context).primaryColor,
                        ),
                        content: customtext(
                          fontWeight: FontWeight.w400,
                          text: "Are you sure delete this video",
                          fontsize: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  color: Colors.green,
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("No"),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  delete(showVideoList[index].id!);
                                  showVideo();
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  color: Colors.green,
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("Yes"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  child: Card(
                    color: SessionManager.getTheme() == true
                        ? kscafolledColor
                        : kWhiteColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: SessionManager.getTheme() == true
                              ? kscafolledColor
                              : kWhiteColor),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 110,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        showVideoList[index].path! +
                                            showVideoList[index].video!.image!),
                                    fit: BoxFit.fill)),
                            child: Center(
                              child: Image.asset(
                                "assest/png_icon/playIvon.png",
                                height: 28,
                                width: 26,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: customtext(
                                        fontWeight: FontWeight.w100,
                                        text: showVideoList[index]
                                            .video!
                                            .videoName!,
                                        fontsize: 15,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Container(
                                      width: 20,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // customtext(
                                        //   fontWeight: FontWeight.w400,
                                        //   text: "10:30",
                                        //   fontsize: 12,
                                        //   color: Theme.of(context).primaryColor,
                                        // ),
                                        SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    )),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomRoundedBottun(
                                  widget: Icon(
                                    Icons.play_arrow_rounded,
                                    color: SessionManager.getTheme() == true
                                        ? k2BlackColor
                                        : kWhiteColor,
                                  ),
                                  height: 52,
                                  width: 52,
                                  ontap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoDiscriptionScreen(
                                                  showVideoModalData:
                                                      showVideoList[index],
                                                )));
                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
  }
}
