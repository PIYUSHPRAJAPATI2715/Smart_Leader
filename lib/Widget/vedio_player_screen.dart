import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_added_video_modal.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Modal/show_videos_modal.dart';

class VedioPlayerScreen extends StatefulWidget {
  final ShowVideosModalData showVideoModalData;

  const VedioPlayerScreen({Key? key, required this.showVideoModalData})
      : super(key: key);

  @override
  State<VedioPlayerScreen> createState() => _VedioPlayerScreenState();
}

class _VedioPlayerScreenState extends State<VedioPlayerScreen> {
  late String videoUrl;
  bool isYoutube = false;

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();

    videoUrl = widget.showVideoModalData.path! +
        widget.showVideoModalData.videoLink!;
    isYoutube = _isYoutubeUrl(videoUrl);

    if (isYoutube) {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      }
    } else {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.blue,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightGreen,
        ),
      );

      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.position ==
            _videoPlayerController.value.duration) {
          print('Video Ended');
        }
      });
    }
  }

  bool _isYoutubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  @override
  void dispose() {
    if (!isYoutube) {
      _videoPlayerController.dispose();
      _chewieController.dispose();
    } else {
      _youtubeController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscafolledColor,
      body: SafeArea(
        child: isYoutube
            ? _youtubeController == null
            ? const Center(child: CircularProgressIndicator())
            : YoutubePlayerBuilder(
          player: YoutubePlayer(controller: _youtubeController!),
          builder: (context, player) {
            return player;
          },
        )
            : Chewie(controller: _chewieController),
      ),
    );
  }
}
