import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_added_video_modal.dart';
import 'package:smart_leader/Screen/video_player_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:smart_leader/Widget/vedio_player_screen.dart';
import 'package:smart_leader/Widget/youtube_player.dart';

import '../Helper/Api.helper.dart';

class VideoDiscriptionScreen extends StatefulWidget {
  ShowVideoModalData showVideoModalData;
   VideoDiscriptionScreen({Key? key,required this.showVideoModalData}) : super(key: key);

  @override
  State<VideoDiscriptionScreen> createState() => _VideoDiscriptionScreenState();
}

class _VideoDiscriptionScreenState extends State<VideoDiscriptionScreen> {
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

          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                margin: EdgeInsets.symmetric(horizontal:5),
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(image: NetworkImage(
                        widget.showVideoModalData.path! +
                            widget.showVideoModalData.video!.image!),fit: BoxFit.fill)
                ),
                child: Center(
                  child:Image.asset("assest/png_icon/playIvon.png",height: 48,width: 48,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    customtext(fontWeight: FontWeight.w600, text: widget.showVideoModalData.video!.videoName!, fontsize: 20,
                    color: Theme.of(context).primaryColor,),
                    SizedBox(height: 30,),
                    // customtext(fontWeight: FontWeight.w400, text: "10:30", fontsize: 15,
                    //   color: Theme.of(context).primaryColor,)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>YouTubePlayerScreen(
                                      showVideoModalData: widget.showVideoModalData,
                                    )));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    height: 100,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: SessionManager.getTheme() == true
                                                ? kscafolledColor
                                                : kblueColor,
                                            width: 1.0),
                                        color: SessionManager.getTheme() == true
                                            ? kscafolledColor
                                            : kWhiteColor),
                                    child: Center(
                                      child: Image.asset("assest/png_icon/youtube_icon.png",),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                customtext(
                                  fontWeight: FontWeight.w400,
                                  text: "Play",
                                  alignment: TextAlign.center,
                                  fontsize: 14,
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>VedioPlayerScreen(
                                      showVideoModalData: widget.showVideoModalData,
                                    )));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    height: 100,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: SessionManager.getTheme() == true
                                                ? kscafolledColor
                                                : kblueColor,
                                            width: 1.0),
                                        color: SessionManager.getTheme() == true
                                            ? kscafolledColor
                                            : kWhiteColor),
                                    child: Center(
                                      child: Image.asset("assest/png_icon/video_player_icon.png",
                                      color:SessionManager.getTheme() == true
                                          ? kWhiteColor
                                          : kBlackColor ,),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                customtext(
                                  fontWeight: FontWeight.w400,
                                  text: "Play",
                                  alignment: TextAlign.center,
                                  fontsize: 14,
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              )

            ],
          ),
          )

        ],
      ),
    );
  }
}
