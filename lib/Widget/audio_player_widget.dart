import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/downloaded_book_modal.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class AudioPlayerWidget extends StatefulWidget {
  DownloadEbooksModalData downloadEbooksModalData;

  AudioPlayerWidget({Key? key, required this.downloadEbooksModalData})
      : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
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

  Future setAudio()async{
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    String url = "https://file-examples.com/storage/feefe3d0dd63b5a899e4775/2017/11/file_example_MP3_700KB.mp3";
    audioPlayer.setSourceUrl(widget.downloadEbooksModalData.path!+widget.downloadEbooksModalData.book!.audioFile!);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  String formatTime(Duration duration){
    String twoDigits(int n)=>n.toString().padLeft(2,"0");
    final hours = twoDigits(duration.inHours);
    final minute = twoDigits(duration.inMinutes.remainder(60));
    final secound = twoDigits(duration.inSeconds.remainder(60));

    return [
      if(duration.inHours > 0) hours,
      minute,secound,
    ].join(":");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopContainer(
              onTap: () {
                Navigator.pop(context);
              },
              title: ""),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: SessionManager.getTheme() == true
                                ? kscafolledColor
                                : kWhiteColor,
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(
                                  widget.downloadEbooksModalData.path! +
                                      widget.downloadEbooksModalData.book!.image!,
                                ),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customtext(
                                      fontWeight: FontWeight.w600,
                                      text: widget
                                          .downloadEbooksModalData.book!.bookName!,
                                      fontsize: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    // SizedBox(
                                    //   height: 4,
                                    // ),
                                    // customtext(
                                    //   fontWeight: FontWeight.w400,
                                    //   text: "Paperback-1",
                                    //   fontsize: 15,
                                    //   color: Theme.of(context).primaryColor,
                                    // ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    customtext(
                                      fontWeight: FontWeight.w400,
                                      text: widget
                                          .downloadEbooksModalData.book!.writerName!,
                                      fontsize: 14,
                                      color: Theme.of(context).primaryColor,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Divider(
                        thickness: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            customtext(
                              fontWeight: FontWeight.w600,
                              text: "Description",
                              fontsize: 19,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            customtext(
                              fontWeight: FontWeight.w400,
                              text: widget.downloadEbooksModalData.book!.description!,
                              fontsize: 13,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Slider(
                                    min: 0,
                                    max: duration.inSeconds.toDouble(),
                                    value: position.inSeconds.toDouble(),
                                    onChanged: (value) async {
                                      final position = Duration(seconds: value.toInt());
                                      await audioPlayer.seek(position);

                                      await audioPlayer.resume();
                                    }),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customtext(
                                        fontWeight: FontWeight.w400,
                                        text: formatTime(duration-position),
                                        fontsize: 13,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      customtext(
                                        fontWeight: FontWeight.w400,
                                        text:formatTime(duration),
                                        fontsize: 13,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: CircleAvatar(
                                    radius: 27,
                                    backgroundColor: kblueColor,
                                    child: IconButton(
                                      icon: Icon(isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow),
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
                                )
                              ],
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
}
