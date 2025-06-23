import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/buy_bottum.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_book_list_modal.dart';
import 'package:smart_leader/Screen/book_description_screen.dart';

import '../Componants/dialog_audio_player_widget.dart';

class SearchBookScreen extends StatefulWidget {
  const SearchBookScreen({Key? key}) : super(key: key);

  @override
  State<SearchBookScreen> createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  List<Data> bookList = [];
  final TextEditingController _searchController = TextEditingController();

  bool isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  void searchBook(String word) {
    bookList.clear();
    setState(() {
      isSearch = true;
    });
    ApiHelper.searchBook(word).then((value) {
      setState(() {
        isSearch = false;
      });
      if (value.data!.isNotEmpty) {
        setState(() {
          bookList = value.data!;
        });
      }
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
              margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: SessionManager.getTheme() == true
                      ? kscafolledColor
                      : kWhiteColor,
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (search) {
                  searchBook(search);
                },
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: "SplineSans",
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: SessionManager.getTheme() == true
                      ? kscafolledColor
                      : kWhiteColor,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: "Search Books",
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  hintStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: "SplineSans",
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: SessionManager.getTheme() == true
                              ? kscafolledColor
                              : const Color(0xffBFBFBF))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: SessionManager.getTheme() == true
                              ? kscafolledColor
                              : Colors.grey.shade50)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: SessionManager.getTheme() == true
                              ? kscafolledColor
                              : Colors.white)),
                ),
              ),
            ),
            Expanded(
              child: isSearch
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: bookList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SearchBookWidget(data: bookList[index]);
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchBookWidget extends StatelessWidget {
  const SearchBookWidget({Key? key, required this.data}) : super(key: key);

  final Data data;

  @override
  Widget build(BuildContext context) {
    final imageUrl = data.path! + data.image!;
    final audioUrl = data.path! + data.bookAudio!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      // Book Image
      ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
      bottomLeft: Radius.circular(15),
    ),
    child: InkWell(
    onTap: () {
    showDialog(
    context: context,
    builder: (context) => DialogAudioPlayerWidget(
    url: audioUrl,
    title: data.bookName!,
    auther: data.writerName!,
    ),
    );
    },
    child: Image.network(
    imageUrl,
    height: 160,
    width: 110,
    fit: BoxFit.cover,
    ),
    ),
    ),
    // Book Info + Buttons
    Expanded(
    child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Book Title
    Text(
    data.bookName ?? '',
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.bold,
    color: Theme.of(context).primaryColor,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    ),
    const SizedBox(height: 5),
    // Author
    Text(
    'By ${data.writerName ?? ""}',
    style: Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: Colors.grey[600]),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    ),
    const SizedBox(height: 50),
    // Buttons
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    // Play Button
    Expanded(
    child: ElevatedButton.icon(
    onPressed: () {
    showDialog(
    context: context,
    builder: (context) => DialogAudioPlayerWidget(
    url: audioUrl,
    title: data.bookName!,
    auther: data.writerName!,
    ),
    );
    },
    style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    backgroundColor: KBoxNewColor,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    ),
    ),
    icon: const Icon(Icons.play_arrow, size: 18),
    label: const Text("Play"),
    ),
    ),
    const SizedBox(width: 10),
    // Share Button
    Expanded(
    child: OutlinedButton.icon(
    onPressed: () {
    Share.share('Check this out: $audioUrl');
    },
    style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    side: BorderSide(color: KBoxNewColor),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    ),
    ),
    icon: const Icon(Icons.share, size: 18),
    label: const Text("Share"),
    ),
    ),
    ],
    )
    ],
    ),
    ),
    )]));
  }
}
