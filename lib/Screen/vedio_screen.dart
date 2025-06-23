import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:chewie/chewie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_added_video_modal.dart';
import 'package:smart_leader/Modal/show_videos_modal.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';
import 'package:smart_leader/Screen/search_book_screen.dart';
import 'package:smart_leader/Screen/search_vedio_screen.dart';
import 'package:smart_leader/Screen/vedio_discription_screen.dart';
import 'package:smart_leader/Screen/video_player_screen.dart';
import 'package:smart_leader/Widget/drawer.dart';
import 'package:smart_leader/Widget/new_bottom_sheet_content_widget.dart';
import 'package:smart_leader/Widget/top_header_container.dart';
import 'package:video_player/video_player.dart';

import '../Componants/neumorphism_widget.dart';
import '../Helper/Api.network.dart';
import '../Modal/vidoes_name_model.dart';
import '../Widget/string_drop_down_widget.dart';
import '../Widget/vedio_player_screen.dart';
import '../Widget/youtube_player.dart';

class VedioScreen extends StatefulWidget {
  const VedioScreen({Key? key}) : super(key: key);

  @override
  State<VedioScreen> createState() => _VedioScreenState();
}

class _VedioScreenState extends State<VedioScreen> {
  final drawerKey = GlobalKey<ScaffoldState>();

  bool isSubmit = true;
  bool isLoading = false;
  bool iscategorires = false;
  bool isVideoLoading = false;
  List<ShowVideosModalData> allVideosList = [];
  List<ShowVideosModalData> showVideoList = [];
  List<ShowVideoModalData> downloadedVideoList = [];


  ShowVideosModalData initialValue = ShowVideosModalData(videoName: "All");
  List<ShowVideosModalData> categoriesList = [];

  final audioPlayer = audio.AudioPlayer();
  Duration duration = Duration.zero;

  String videoId = "";
  String? selectedLanguageId = "1";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showVideos();
    showDownloadedVideo();
    getConnectivity();
    getVideoname();
  }


  void showVideos() {
    setState(() {
      isSubmit = true;
      showVideoList.clear();      // 🧼 Clear old list
      allVideosList.clear();      // 🧼 Clear old data
      categoriesList.clear();     // 🧼 Clear old tags
    });

    final body = {
      'language_id': selectedLanguageId,
    };

    print("Fetching videos with body: $body");

    ApiHelper.showeVideoList(body).then((value) {
      print("API Response: ${value.message}");

      if (value.showVideosModalData != null) {
        final filteredList = value.showVideosModalData!
            .where((video) => video.languageKey?.toString() == selectedLanguageId.toString())
            .toList();

        setState(() {
          allVideosList = filteredList;
          showVideoList = List.from(filteredList);

          // 🖼 Print all video data
          print("🧮 Filtered Videos Count: ${filteredList.length}");
          for (var v in filteredList) {
            print("📽️ ID: ${v.id} | Name: ${v.videoName} | Lang: ${v.languageName} (${v.languageKey})");
          }

          // 🎯 Build category list (tags)
          final tagNames = filteredList
              .map((video) => video.tagName?.trim())
              .where((tag) => tag != null && tag!.isNotEmpty && tag!.toLowerCase() != 'no tag')
              .toSet()
              .toList()
            ..sort();

          categoriesList = [
            ShowVideosModalData(tagName: 'select playlist'),
            ...tagNames.map((tag) => ShowVideosModalData(tagName: tag))
          ];

          initialValue = categoriesList.first;

          print("📌 Unique Tag Names from API:");
          for (var tag in tagNames) {
            print("➡️ $tag");
          }
        });
      } else {
        // No data case
        setState(() {
          allVideosList.clear();
          showVideoList.clear();
          categoriesList = [ShowVideosModalData(tagName: 'select playlist')];
          initialValue = categoriesList.first;
        });
      }
    }).catchError((error) {
      print("❌ API error: $error");
      setState(() {
        isSubmit = false;
      });
    }).whenComplete(() {
      setState(() {
        isSubmit = false;
      });
    });
  }





  void showDownloadedVideo() {
    setState(() {
      isVideoLoading = true;
    });
    ApiHelper.showaddedVideo().then((value) {
      setState(() {
        isVideoLoading = false;
      });
      downloadedVideoList = value.data!;
    });
  }

  void addVideo(String id) {
    // setState(() {
    //   isLoading = true;
    // });
    Map<String, String> body = {"user_id": SessionManager.getUserID(), "video_id": id};
    print("fghs${body}");
    Helper.showLoaderDialog(context);
    ApiHelper.addVideo(body).then((login) {
      Navigator.pop(context);
      if (login.message == 'Video Download Add Successfully ') {
        setState(() {
          showDownloadedVideo();
        });
      }

      Helper.showSnackVar(login.message!, Colors.black, context);
      // } else {
      //   Helper.toastMassage(
      //     'Error',
      //     Colors.red,
      //   );
      // }
    });
  }

  void getVideoname() {
    setState(() {
      iscategorires = true;
    });

    categoriesList.clear();

    // Ensure the default value is set
    ShowVideosModalData categoriesData = ShowVideosModalData(videoName: 'select playlist');
    categoriesList.add(categoriesData);
    initialValue = categoriesData; // Set initial value safely

    ApiHelper.getvideosName().then(
          (value) {
            if (value.showVideosModalData != null) {
              allVideosList = value.showVideosModalData!;
              showVideoList = List.from(allVideosList);
              getTagDropdownList(); // <== Populate tag dropdown here
            } else {
          print("Error: ${value.message}");
        }
      },
    ).catchError((error) {
      print("Exception: $error");
    }).whenComplete(() {
      setState(() {
        iscategorires = false;
      });
    });
  }
  void getTagDropdownList() {
    final uniqueTags = <String>{};
    categoriesList.clear();

    // Add default dropdown option
    categoriesList.add(ShowVideosModalData(tagName: 'select playlist'));

    for (var video in allVideosList) {
      final tag = video.tagName ?? '';
      if (tag.isNotEmpty && !uniqueTags.contains(tag)) {
        uniqueTags.add(tag);
        categoriesList.add(ShowVideosModalData(tagName: tag));
      }
    }

    setState(() {
      initialValue = categoriesList.first;
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minute = twoDigits(duration.inMinutes.remainder(60));
    final secound = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minute,
      secound,
    ].join(":");
  }

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() => subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: const HomeDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopHeaderContainer(drawerKey: drawerKey),
          // searchBar(context),
          // const SizedBox(
          //   height: 20,
          // ),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///TODO: Continue watching section:: uncomment to unhide
                  /*isVideoLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customtext(
                              fontWeight: FontWeight.w500,
                              text: "Continue Watching",
                              fontsize: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            downloadedVideoList.isEmpty
                                ? Center(
                                    child: customtext(
                                        fontWeight: FontWeight.w500,
                                        text: 'No Downloaded video found',
                                        fontsize: 14.0),
                                  )
                                : continueWatchingContainer(context),
                          ],
                        ),*/
                  /* const SizedBox(
                        height: 28,
                      ),*/
                  Row(
                    children: [
                      // 🔍 Search box
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchVideoScreen()));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: KBoxNewColor,
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.black),
                                const SizedBox(width: 15.0),
                                const customtext(
                                  fontWeight: FontWeight.w600,
                                  text: 'Search Videos',
                                  fontsize: 15.0,
                                  color: Colors.black,
                                ),
                                Spacer(),
                                Container(
                                  height: 30,
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: SessionManager.getTheme() == true ? kscafolledColor : kWhiteColor,
                                    border: Border.all(color: kblueColor, width: 0.9),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedLanguageId,
                                      hint: const customtext(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        alignment: TextAlign.center,
                                        fontsize: 13,
                                        text: "Select Language",
                                      ),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 10,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            selectedLanguageId = newValue;
                                            print('Selected Language ID: $selectedLanguageId');
                                            showVideos();
                                          });
                                        }
                                      },

                                      items: [
                                        const DropdownMenuItem<String>(
                                          value: "1",
                                          child: customtext(
                                            fontWeight: FontWeight.w600,
                                            fontsize: 15,
                                            text: "Hindi",
                                          ),
                                        ),
                                        const DropdownMenuItem<String>(
                                          value: "2",
                                          child: customtext(
                                            fontWeight: FontWeight.w600,
                                            fontsize: 15,
                                            text: "English",
                                          ),
                                        ),
                                        const DropdownMenuItem<String>(
                                          value: "3",
                                          child: customtext(
                                            fontWeight: FontWeight.w600,
                                            fontsize: 15,
                                            text: "Bengali",
                                          ),
                                        ),
                                        const DropdownMenuItem<String>(
                                          value: "4",
                                          child: customtext(
                                            fontWeight: FontWeight.w600,
                                            fontsize: 15,
                                            text: "Malayalam",
                                          ),
                                        ),
                                        const DropdownMenuItem<String>(
                                          value: "5",
                                          child: customtext(
                                            fontWeight: FontWeight.w600,
                                            fontsize: 15,
                                            text: "Telugu",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 🌐 Language dropdown

                    ],
                  )
,

                  const SizedBox(height: 10),
                  CategoreyDropDownWidget(
                    initialValue: initialValue,
                    items: categoriesList,
                    onChange: (value) {
                      setState(() {
                        initialValue = value!;
                        final selected = value.tagName?.trim().toLowerCase() ?? '';

                        if (selected == 'all' || selected == 'select playlist') {
                          showVideoList = List.from(allVideosList);
                        } else {
                          showVideoList = allVideosList.where((video) {
                            final tag = video.tagName?.trim().toLowerCase() ?? '';
                            return tag == selected;
                          }).toList();
                        }

                        print("Selected Tag: $selected");
                        print("Filtered Videos: ${showVideoList.length}");
                      });
                    },
                  ),
                  NewAddedVedioContainer(context)
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: SessionManager.getTheme() == true ? kscafolledColor : kWhiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: "SplineSans",
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: SessionManager.getTheme() == true ? kscafolledColor : kWhiteColor,
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              hintText: "Search",
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              suffixIcon: Container(
                padding: const EdgeInsets.only(right: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLanguageId,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    dropdownColor: kWhiteColor,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedLanguageId = newValue;
                        print('Selected Language ID: $selectedLanguageId');
                        showVideos();
                      }
                    },
                    items: [
                      const DropdownMenuItem<String>(
                        value: "1",
                        child: Text("Hindi", style: TextStyle(fontSize: 13)),
                      ),
                      const DropdownMenuItem<String>(
                        value: "2",
                        child: Text("English", style: TextStyle(fontSize: 13)),
                      ),
                      const DropdownMenuItem<String>(
                        value: "3",
                        child: Text("Bengali", style: TextStyle(fontSize: 13)),
                      ),
                      const DropdownMenuItem<String>(
                        value: "4",
                        child: Text("Malayalam", style: TextStyle(fontSize: 13)),
                      ),
                      const DropdownMenuItem<String>(
                        value: "5",
                        child: Text("Telugu", style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
              hintStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: "SplineSans",
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: SessionManager.getTheme() == true
                      ? kscafolledColor
                      : const Color(0xffBFBFBF),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: SessionManager.getTheme() == true
                      ? kscafolledColor
                      : Colors.grey.shade50,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: SessionManager.getTheme() == true
                      ? kscafolledColor
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget continueWatchingContainer(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: ToolsNeumorphismWidget(
        padding: const EdgeInsets.only(left: 0),
        child: Row(
          children: List.generate(
              downloadedVideoList.length,
              (index) => InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => VideoDiscriptionScreen(
                      //               showVideoModalData: downloadedVideoList[index],
                      //             )));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(8.0),
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade400, width: 0.5),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              downloadedVideoList[index].path! + downloadedVideoList[index].video!.image!,
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          customtext(
                            fontWeight: FontWeight.w600,
                            text: downloadedVideoList[index].video!.videoName!,
                            fontsize: 15,
                            maxLine: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                          customtext(
                            fontWeight: FontWeight.w400,
                            text: downloadedVideoList[index].video!.time!,
                            fontsize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }

  Widget NewAddedVedioContainer(BuildContext context) {
    return isSubmit
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: showVideoList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final videoData = showVideoList[index];
        return GestureDetector(
          onTap: () {
            final isYouTube = videoData.videoLink?.contains("youtube.com") == true ||
                videoData.videoLink?.contains("youtu.be") == true;

            if (isYouTube) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YouTubePlayerScreen(
                    showVideoModalData: videoData,
                  ),
                ),
              );
            } else {
              final serverVideo = videoData.video;
              final basePath = videoData.path;

              if (serverVideo != null && serverVideo.trim().isNotEmpty) {
                final videoUrl = basePath + serverVideo;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreens(
                      videoUrls: [videoUrl],
                      initialIndex: 0,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Video not available")),
                );
              }
            }
          }


          ,
            child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade400, width: 0.5),
              color: SessionManager.getTheme() == true
                  ? kscafolledColor
                  : kWhiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                    image: DecorationImage(
                      image: NetworkImage(
                        (videoData.path != null && videoData.image != null)
                            ? '${videoData.path}${videoData.image}'
                            : 'https://peach.blender.org/wp-content/uploads/bbb-splash.png',
                      ),

                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(Icons.play_circle_fill,
                            size: 60, color: Colors.white70),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: customtext(
                            fontWeight: FontWeight.w600,
                            text: videoData.time ?? '',
                            fontsize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5),
                        child: customtext(
                          fontWeight: FontWeight.w700,
                          text: videoData.videoName ?? '',
                          fontsize: 16,
                          maxLine: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Share.share(videoData.videoLink ?? '');
                      },
                      child: const Icon(Icons.more_vert,
                          color: Colors.black, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }



  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.signal_wifi_statusbar_connected_no_internet_4),
              SizedBox(
                width: 8,
              ),
              Text('No Connection'),
            ],
          ),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected = await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}

class VideoListItem extends StatefulWidget {
  final String videoUrl;
  final String videoName;
  final String time;

  const VideoListItem({
    Key? key,
    required this.videoUrl,
    required this.videoName,
    required this.time,
  }) : super(key: key);

  @override
  State<VideoListItem> createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          _initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    children: [
                      VideoPlayer(_controller),
                      Center(
                        child: IconButton(
                          icon: Icon(
                            _controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                            size: 48,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _controller.value.isPlaying ? _controller.pause() : _controller.play();
                            });
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: customtext(
                          fontWeight: FontWeight.w400,
                          text: widget.time,
                          fontsize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(
                  height: 170,
                  child: Center(child: CircularProgressIndicator()),
                ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customtext(
                        fontWeight: FontWeight.w600,
                        text: widget.videoName,
                        fontsize: 15,
                        color: Colors.black,
                      ),
                      customtext(
                        fontWeight: FontWeight.w600,
                        text: "PlayList-Proper",
                        fontsize: 15,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerScreens extends StatefulWidget {
  final List<String> videoUrls; // List of video URLs
  final int initialIndex; // Start index of the video list

  const VideoPlayerScreens({required this.videoUrls, required this.initialIndex});

  @override
  _VideoPlayerScreensState createState() => _VideoPlayerScreensState();
}

class _VideoPlayerScreensState extends State<VideoPlayerScreens> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // Set the initial video index
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    print(widget.videoUrls[currentIndex]);
    _videoPlayerController = VideoPlayerController.network(widget.videoUrls[currentIndex]);

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
    );

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position == _videoPlayerController.value.duration) {
        // Check if the video has finished
        if (currentIndex + 1 < widget.videoUrls.length) {
          // If there is a next video, move to it
          setState(() {
            currentIndex++;
          });
          _playNextVideo();
        }
      }
    });

    setState(() {});
  }

  void _playNextVideo() async {
    await _videoPlayerController.pause();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrls[currentIndex]);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: _chewieController != null ? Chewie(controller: _chewieController!) : const CircularProgressIndicator(),
      ),
    );
  }
}
