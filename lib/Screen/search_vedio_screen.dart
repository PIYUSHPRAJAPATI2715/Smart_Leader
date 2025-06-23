import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_videos_modal.dart';
import 'package:smart_leader/Screen/vedio_screen.dart';
import 'package:smart_leader/Screen/video_player_screen.dart';

class SearchVideoScreen extends StatefulWidget {
  const SearchVideoScreen({Key? key}) : super(key: key);

  @override
  State<SearchVideoScreen> createState() => _SearchVideoScreenState();
}

class _SearchVideoScreenState extends State<SearchVideoScreen> {
  List<ShowVideosModalData> videoList = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool isSearching = false;

  void searchVideo(String query) {
    videoList.clear();
    setState(() {
      isSearching = true;
    });
    ApiHelper.searchVideo(query).then((value) {
      setState(() {
        isSearching = false;
        if (value.showVideosModalData != null && value.showVideosModalData!.isNotEmpty) {
          videoList = value.showVideosModalData!;
        }
      });
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
                onChanged: (text) => searchVideo(text),
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
                  : ListView.builder(
                itemCount: videoList.length,
                itemBuilder: (context, index) {
                  return SearchVideoItem(video: videoList[index]);
                },
              ),
            )
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
