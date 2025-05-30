import 'package:flutter/material.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(

      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',

      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        isLive: false,
        forceHD: true,
        enableCaption: false,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        onReady: () {
          print('Player is ready.');
        },
        onEnded: (YoutubeMetaData metaData) {
          _controller.seekTo(Duration(seconds: 0));
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Video Player'),
            backgroundColor: kblueColor,
          ),
          body: Column(
            children: [
              // Align(
              //   alignment: Alignment.topRight,
              //   child: IconButton(
              //     icon: const Icon(Icons.fullscreen),
              //     onPressed: () {
              //       _controller.toggleFullScreenMode();
              //     },
              //   ),
              // ),
              Container(
                height: 180,
                  child:player),
            ],
          ),
        );
      },
    );
  }
}
