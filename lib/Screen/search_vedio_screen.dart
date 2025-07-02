import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_videos_modal.dart';
import 'package:smart_leader/Screen/vedio_screen.dart';
import 'package:smart_leader/Screen/video_player_screen.dart';

class SearchVideoScreen extends StatefulWidget {
  String? selectedLanguageId;
   SearchVideoScreen(this.selectedLanguageId, {Key? key}) : super(key: key);

  @override
  State<SearchVideoScreen> createState() => _SearchVideoScreenState();
}

class _SearchVideoScreenState extends State<SearchVideoScreen> {
  List<ShowVideosModalData> videoList = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String? noDataMessage;
  bool isSearching = false;
  Map<String, String> languageMap = {
    "1": "hindi",
    "2": "english",
    "3": "bengali",
    "4": "malayalam",
    "5": "telugu",
  };
  void searchVideo(String query, String languageId) {

    setState(() {
      isSearching = true;
      noDataMessage = null;
    });
    String languageKey = languageMap[languageId] ?? "hindi";
    final String url =
        'https://ruparnatechnology.com/Smartleader/Api/process.php?action=video_search&keyword=$query&language_key=$languageKey';

    print("📡 API URL: $url");

    http.get(Uri.parse(url)).then((response) {
      print("📥 API Response: ${response.body}");

      setState(() {
        isSearching = false;

        final json = jsonDecode(response.body);
        if (json["status"] == true && json["data"] != null && json["data"].isNotEmpty) {
          videoList = List<ShowVideosModalData>.from(
            json["data"].map((item) => ShowVideosModalData.fromJson(item)),
          );
        } else {
          videoList.clear();
          noDataMessage = "No videos found for \"$query\"";
        }
      });
    }).catchError((e) {
      setState(() {
        isSearching = false;
        videoList.clear();
        noDataMessage = "Something went wrong. Please try again.";
      });
      print("❌ Error fetching data: $e");
    });
  }







  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              decoration: BoxDecoration(
                color: SessionManager.getTheme() ? kscafolledColor : kWhiteColor,
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (text) => searchVideo(text,widget.selectedLanguageId.toString()),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                  hintText: "Search Videos",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Expanded(
              child: isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : videoList.isNotEmpty
                  ? ListView.builder(
                itemCount: videoList.length,
                itemBuilder: (context, index) {
                  return SearchVideoItem(video: videoList[index]);
                },
              )
                  : Center(
                child: Text(
                  noDataMessage ?? "Start typing to search videos",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class SearchVideoItem extends StatelessWidget {
  const SearchVideoItem({Key? key, required this.video}) : super(key: key);

  final ShowVideosModalData video;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreens(
              videoUrls: [video.videoLink ?? ''],
              initialIndex: 0,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 0.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                (video.path ?? '') + (video.image ?? ''),
                width: 100,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customtext(
                    fontWeight: FontWeight.w600,
                    text: video.videoName ?? '',
                    fontsize: 14,
                    color: Theme.of(context).primaryColor,
                    maxLine: 2,
                  ),
                  const SizedBox(height: 5),
                  customtext(
                    fontWeight: FontWeight.w400,
                    text: video.time ?? '',
                    fontsize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
