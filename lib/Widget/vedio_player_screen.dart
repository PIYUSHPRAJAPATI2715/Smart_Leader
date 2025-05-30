import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_added_video_modal.dart';
import 'package:video_player/video_player.dart';

class VedioPlayerScreen extends StatefulWidget {
  ShowVideoModalData showVideoModalData;
   VedioPlayerScreen({Key? key,required this.showVideoModalData}) : super(key: key);

  @override
  State<VedioPlayerScreen> createState() => _VedioPlayerScreenState();
}

class _VedioPlayerScreenState extends State<VedioPlayerScreen> {

  int adEvery = 0;
  List<int> adIntervalSeconds = []; //timestamps at which ad will be shown
  bool throttle = false;


  String  videoUrl = '';


  late TargetPlatform _platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  late ChewieController _chewieController;

  @override
  void initState() {

    super.initState();
    videoUrl = widget.showVideoModalData.path!+widget.showVideoModalData.video!.video!;
    _videoPlayerController1 = VideoPlayerController.network(videoUrl);
    _videoPlayerController2 = VideoPlayerController.network((videoUrl));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 16/9,
      autoPlay: true,
      looping: false,
      // Try playing around with some of these other options:

      // showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );

    _videoPlayerController1.addListener(() {
      if (_videoPlayerController1.value.position ==
          _videoPlayerController1.value.duration) {
        print('video Ended');
        // int durationInSec = _chewieController!.videoPlayerController.value.duration.inSeconds;
        // int positionInSec = _chewieController!.videoPlayerController.value.position.inSeconds;
        //
        // //1500 sec = 25 minutes, isDurationLoaded bool used to make sure it run just once.
        // if (durationInSec > 1500 && isDurationLoaded == false) {
        //   isDurationLoaded = true;
        //
        //   //if duration > 25 mins then show ad every 20 mins approx.
        //   totalAds = (durationInSec ~/ 1200).toInt();
        //   adEvery = (durationInSec ~/ totalAds).toInt();
        //
        //   //get timestamps in seconds list at which ad should be shown
        //   for (int i = 1; i < totalAds; i++) {
        //     adIntervalSeconds.add(adEvery * i);
        //   }
        //
        // }
        //
        // if (videoPlayerController.value.isPlaying &&
        //     adIntervalSeconds.isNotEmpty &&
        //     adIntervalSeconds.contains(positionInSec) &&
        //     throttle == false) {
        //   throttle = true;
        //
        //   Future.delayed(const Duration(seconds: 2), () {
        //     throttle = false;
        //   });
        //
        //   adIntervalSeconds.remove(positionInSec);
        //   showInterstitial();
        // }
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(backgroundColor: kscafolledColor,elevation: 0,),
      backgroundColor: kscafolledColor,
      body: SafeArea(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
