import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/downloaded_book_modal.dart';
import 'package:smart_leader/Widget/audio_player_widget.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class DownloadedBookDiscriptionScreen extends StatefulWidget {
  DownloadEbooksModalData downloadEbooksModalData;

  DownloadedBookDiscriptionScreen(
      {Key? key, required this.downloadEbooksModalData})
      : super(key: key);

  @override
  State<DownloadedBookDiscriptionScreen> createState() =>
      _DownloadedBookDiscriptionScreenState();
}

class _DownloadedBookDiscriptionScreenState
    extends State<DownloadedBookDiscriptionScreen> {
  bool isSubmit = false;
  bool loading = false;
  Dio dio = Dio();
  String filePath = "";

  void download(String url, name) async {
    if (Platform.isAndroid || Platform.isIOS) {
      Helper.showLoaderDialog(context, message: 'Please wait..');
      await downloadFile(url, name);
    } else {
      loading = false;
    }

    if (mounted) {}
    Navigator.pop(context);
    print('File PATH $filePath');

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
      //
      // lastLocation: EpubLocator.fromJson({
      //   "bookId": "2239",
      //   "href": "/OEBPS/ch06.xhtml",
      //   "created": 1539934158390,
      //   "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
      // }),
    );
  }

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
                        child: Image.network(widget.downloadEbooksModalData.path! +
                            widget.downloadEbooksModalData.book!.image!),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        thickness: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start,
                            children: [
                              Expanded(
                                child: customtext(
                                  fontWeight: FontWeight.w600,
                                  text: widget
                                      .downloadEbooksModalData.book!.bookName!,
                                  fontsize: 20,
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        25),
                                    color: Colors.blueGrey),
                                child: customtext(
                                  fontWeight: FontWeight.w600,
                                  text:
                                  widget.downloadEbooksModalData.book!.tagId ??
                                      '',
                                  fontsize: 10.0,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          customtext(
                            fontWeight: FontWeight.w400,
                            text: widget.downloadEbooksModalData.book!
                                .writerName!,
                            fontsize: 14,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            customtext(
                              fontWeight: FontWeight.w600,
                              text: "Description",
                              fontsize: 19,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            customtext(
                              fontWeight: FontWeight.w400,
                              text: widget
                                  .downloadEbooksModalData.book!.description!,
                              fontsize: 13,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              height: 70,
                            ),
                            isSubmit == true
                                ? Center(
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator()),
                                  )
                                : custom_Button(
                                    onTap: () {
                                      String url =
                                          "https://github.com/IDPF/epub3-samples/releases/download/20170606/epub30-spec.epub";

                                      // download(url, 'epub30-spec.epub');

                                      if (widget
                                              .downloadEbooksModalData.type! ==
                                          'Audio') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AudioPlayerWidget(
                                                      downloadEbooksModalData:
                                                          widget
                                                              .downloadEbooksModalData,
                                                    )));
                                      } else {
                                        download(
                                            widget.downloadEbooksModalData
                                                    .path! +
                                                widget.downloadEbooksModalData
                                                    .book!.file!,
                                            widget.downloadEbooksModalData.book!
                                                .file!);
                                      }
                                    },
                                    title:
                                        widget.downloadEbooksModalData.type! ==
                                                'Audio'
                                            ? "Play Now"
                                            : 'Read Now',
                                    hight: 55,
                                    width: 200,
                                    fontSize: 20),
                            SizedBox(
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

  Future downloadFile(String url, name) async {
    if (await Permission.storage.isGranted) {
      await Permission.storage.request();
      await startDownload(url, name);
    } else {
      await startDownload(url, name);
    }
  }

  Future<void> startDownload(String url, name) async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    // String path = '${appDocDir!.path}/text.epub';

    print('URL $url');
    print('NAME $name');
    String path = '${appDocDir!.path}/$name';
    File file = File(path);

    print('IS_FILE)EXIST ${file.existsSync()}');

    if (!file.existsSync()) {
      print('NOT EXIST');
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
      print('EXIST');
      setState(() {
        loading = false;
        filePath = path;
      });
    }
  }
}
