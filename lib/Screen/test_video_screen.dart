import 'package:flutter/material.dart';
import 'package:smart_leader/Screen/video_player_screen.dart';

import '../Componants/Custom_text.dart';
import '../Helper/Api.helper.dart';
import '../Helper/theme_colors.dart';
import '../Widget/custom_top_container.dart';

class TestVideoScreen extends StatefulWidget {
  const TestVideoScreen({Key? key}) : super(key: key);

  @override
  State<TestVideoScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<TestVideoScreen> {
  bool isVideoLoading = false;
  List<ShowVideoModalData> downloadedVideoList = [];

  @override
  void initState() {
    super.initState();
    showDownloadedVideo();
  }

  void showDownloadedVideo() {
    setState(() {
      isVideoLoading = true;
    });
    ApiHelper.showaddedVideo().then((value) {
      setState(() {
        isVideoLoading = false;
      });
      downloadedVideoList = value.data!.cast<ShowVideoModalData>();
    });
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: isVideoLoading
                  ? Center(child: CircularProgressIndicator()) // Show loading
                  : downloadedVideoList.isEmpty
                  ? Center(child: Text("No videos available")) // Handle empty state
                  : ListView.builder(
                itemCount: downloadedVideoList.length,
                itemBuilder: (context, index) {
                  return VideoItem(videoData: downloadedVideoList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  final ShowVideoModalData videoData;

  const VideoItem({Key? key, required this.videoData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoUrl: videoData.videoUrl!),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(videoData.thumbnail!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_fill,
                  size: 60,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              videoData.videoName!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Model (Ensure API data structure matches this)
class ShowVideoModalData {
  String? videoName;
  String? videoUrl;
  String? thumbnail;

  ShowVideoModalData({this.videoName, this.videoUrl, this.thumbnail});

  factory ShowVideoModalData.fromJson(Map<String, dynamic> json) {
    return ShowVideoModalData(
      videoName: json['videoName'],
      videoUrl: json['videoUrl'],
      thumbnail: json['thumbnail'],
    );
  }
}
