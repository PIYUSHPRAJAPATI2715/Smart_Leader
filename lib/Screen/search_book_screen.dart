import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/buy_bottum.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_book_list_modal.dart';
import 'package:smart_leader/Screen/book_description_screen.dart';

class SearchBookScreen extends StatefulWidget {
  const SearchBookScreen({Key? key}) : super(key: key);

  @override
  State<SearchBookScreen> createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  List<ShowBookListModalData> bookList = [];
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

  final ShowBookListModalData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 0.5),
          borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              data.path! + data.image!,
              height: 86,
              width: 57,
            ),
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customtext(
                  fontWeight: FontWeight.w500,
                  text: data.bookName!,
                  fontsize: 14,
                  color: Theme.of(context).primaryColor,
                  maxLine: 2,
                ),
                SizedBox(height: 10.0),
                customtext(
                  fontWeight: FontWeight.w500,
                  text: data.writerName!,
                  fontsize: 12,
                  color: Theme.of(context).primaryColor,
                  maxLine: 1,
                ),
                SizedBox(height: 15.0),
                BuyBottun(
                    title: "View Detail",
                    horizontalWidth: 7,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookDescriptionScreen(
                                  showBookListModalData: data)));
                    },
                    verticleHight: 9)
              ],
            ),
          ),
          SizedBox(width: 15.0),
          customtext(
            fontWeight: FontWeight.w700,
            text: '₹${data.bookPrice!}',
            fontsize: 14,
            color: Theme.of(context).primaryColor,
            maxLine: 1,
          ),
        ],
      ),
    );
  }
}
