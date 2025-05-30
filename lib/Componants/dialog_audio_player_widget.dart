import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';

class DialogAudioPlayerWidget extends StatefulWidget {
  const DialogAudioPlayerWidget({Key? key, required this.url})
      : super(key: key);

  final String url;

  @override
  State<DialogAudioPlayerWidget> createState() =>
      _DialogAudioPlayerWidgetState();
}

class _DialogAudioPlayerWidgetState extends State<DialogAudioPlayerWidget> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAudio();
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
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    String url =
        "https://file-examples.com/storage/feefe3d0dd63b5a899e4775/2017/11/file_example_MP3_700KB.mp3";
    audioPlayer.setSourceUrl(widget.url);
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
                      text: 'Book Summary',
                      fontsize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.clear, color: Colors.white))
                ],
              )),
          SizedBox(height: 15.0),
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            activeColor: kblueColor, // Set the color for the active part of the slider
            inactiveColor: Colors.grey, // Set the color for the inactive part of the slider
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);

              await audioPlayer.resume();
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customtext(
                  fontWeight: FontWeight.w400,
                  text: formatTime(duration - position),
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
              child: IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    String url =
                        "https://file-examples.com/storage/feefe3d0dd63b5a899e4775/2017/11/file_example_MP3_700KB.mp3";
                    await audioPlayer.play(audioPlayer.source!);
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
    // TODO: implement dispose
    super.dispose();
  }
}
