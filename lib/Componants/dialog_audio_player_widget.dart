import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class DialogAudioPlayerWidget extends StatefulWidget {
  const DialogAudioPlayerWidget({
    Key? key,
    required this.url,
    required this.title,
    required this.auther,
  }) : super(key: key);

  final String url;
  final String title;
  final String auther;

  @override
  State<DialogAudioPlayerWidget> createState() =>
      _DialogAudioPlayerWidgetState();
}

class _DialogAudioPlayerWidgetState extends State<DialogAudioPlayerWidget> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setupAudio();
  }

  Future<void> setupAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.stop);
    await audioPlayer.setSourceUrl(widget.url);

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        position = Duration.zero;
        isPlaying = false;
      });
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
            color: kblueDarkColor,
            child: Row(
              children: [
                Expanded(
                  child: customtext(
                    fontWeight: FontWeight.w500,
                    text: '${widget.title} - by ${widget.auther}',
                    fontsize: 14.0,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.0),
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
            activeColor: kblueColor,
            inactiveColor: Colors.grey,
            onChanged: (value) async {
              final newPosition = Duration(seconds: value.toInt());
              await audioPlayer.seek(newPosition);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customtext(
                  fontWeight: FontWeight.w400,
                  text: formatTime(position),
                  fontsize: 13,
                  color: Theme.of(context).primaryColor,
                ),
                customtext(
                  fontWeight: FontWeight.w400,
                  text: formatTime(duration),
                  fontsize: 13,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: CircleAvatar(
              radius: 27,
              backgroundColor: kblueColor,
              child: isLoading
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    setState(() {
                      isLoading = true;
                    });

                    await audioPlayer.play(UrlSource(widget.url)).whenComplete(() {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  }
                },
              ),

            ),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
