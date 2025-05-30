import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/buy_bottum.dart';
import 'package:smart_leader/Componants/neumorphism_widget.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/ExtractClasses/ebooks_widget.dart';
import 'package:smart_leader/ExtractClasses/new_added_ebook_widget.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/book_tags.dart';
import 'package:smart_leader/Modal/downloaded_book_modal.dart';
import 'package:smart_leader/Modal/show_book_list_modal.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';
import 'package:smart_leader/Screen/dowloaded_book_discription_screen.dart';
import 'package:smart_leader/Screen/ebook_screen.dart';
import 'package:smart_leader/Screen/new_added_books_screen.dart';
import 'package:smart_leader/Screen/search_book_screen.dart';
import 'package:smart_leader/Widget/drawer.dart';
import 'package:smart_leader/Widget/top_header_container.dart';

import '../Helper/size_config.dart';
import '../Widget/new_bottom_sheet_content_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final drawerKey = GlobalKey<ScaffoldState>();

  late Future<ShowBookListModal> ebooks;
  late Future<ShowBookListModal> newebooks;
  late Future<DownloadEbooksModal> myLibrary;
  late Future<BooksTags> bookTagFuture;

  int selectedTab = -1;

  String? selectedLanguageId="1";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedLanguageId = '1';
    ebooks = ApiHelper.showebookList('');
    //   newebooks = ApiHelper.newaddedbookList();
    myLibrary = ApiHelper.showeDowloadedList(selectedLanguageId.toString());
    bookTagFuture = ApiHelper.getBookTags();
    //getConnectivity();
  }

  /*
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;


  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );
  */

  @override
  void dispose() {
    //  subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        key: drawerKey,
        drawer: const HomeDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopHeaderContainer(drawerKey: drawerKey),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchBookScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: KBoxNewColor,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 15.0),
                          customtext(
                            fontWeight: FontWeight.w600,
                            text: 'Search',
                            fontsize: 15.0,
                            color: Colors.black,
                          ),
                          Spacer(),
                          Container(
                            height: 30,

                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: SessionManager.getTheme() == true ? kscafolledColor : kWhiteColor,
                              border: Border.all(color: kblueColor,width: 0.9),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(

                                value: selectedLanguageId,
                                hint: customtext(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  alignment: TextAlign.center,
                                  fontsize: 13,
                                  text: "Select Language",
                                ),
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 10,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLanguageId = newValue;
                                    print('Selected Language ID: $selectedLanguageId');
                                    myLibrary = ApiHelper.showeDowloadedList(selectedLanguageId.toString());
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: "1",
                                    child: customtext(
                              
                                      fontWeight: FontWeight.w400,
                                      fontsize: 13,
                                      text: "Hindi",
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "2",
                                    child: customtext(
                                      fontWeight: FontWeight.w400,
                                      fontsize: 13,
                                      text: "English",
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "3",
                                    child: customtext(
                                      fontWeight: FontWeight.w400,
                                      fontsize: 13,
                                      text: "Bengali",
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "4",
                                    child: customtext(
                                      fontWeight: FontWeight.w400,
                                      fontsize: 13,
                                      text: "Malayalam",
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "5",
                                    child: customtext(
                                      fontWeight: FontWeight.w400,
                                      fontsize: 13,
                                      text: "Telugu",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FutureBuilder<DownloadEbooksModal>(
                      //   future: myLibrary,
                      //   builder: (context, response) {
                      //     if (response.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return const Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     }
                      //     if (response.hasError) {
                      //       return Center(
                      //         child: Text('Error: ${response.error}'),
                      //       );
                      //     }
                      //
                      //     if (!response.hasData ||
                      //         response.data!.data == null) {
                      //       return Center(
                      //         child: Text('No data available'),
                      //       );
                      //     }
                      //
                      //     List<DownloadEbooksModalData> downloadList =
                      //         response.data!.data!;
                      //
                      //     if (downloadList.isEmpty) {
                      //       return Container();
                      //     }
                      //
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             customtext(
                      //               fontWeight: FontWeight.w500,
                      //               text: "My Library",
                      //               fontsize: 20,
                      //               color: KBoxNewColor,
                      //             ),
                      //             selectedLanguageId == null
                      //                 ? IconButton(
                      //                     onPressed: () async {
                      //                       selectedLanguageId =
                      //                           await showModalBottomSheet<
                      //                               String>(
                      //                         context: context,
                      //                         builder: (BuildContext context) {
                      //                           return const NewBottomSheetContentWidget();
                      //                         },
                      //                       );
                      //                       if (selectedLanguageId != null) {
                      //                         print(
                      //                             'Selected Language ID: $selectedLanguageId');
                      //                         setState(() {
                      //                           myLibrary = ApiHelper
                      //                               .showeDowloadedList(
                      //                                   selectedLanguageId
                      //                                       .toString());
                      //                         });
                      //                       }
                      //                     },
                      //                     icon:
                      //                         Icon(Icons.filter_list_outlined),
                      //                   )
                      //                 : InkWell(
                      //                     onTap: () async {
                      //                       selectedLanguageId =
                      //                           await showModalBottomSheet<
                      //                               String>(
                      //                         context: context,
                      //                         builder: (BuildContext context) {
                      //                           return const NewBottomSheetContentWidget();
                      //                         },
                      //                       );
                      //                       if (selectedLanguageId != null) {
                      //                         print(
                      //                             'Selected Language ID: $selectedLanguageId');
                      //                         setState(() {
                      //                           myLibrary = ApiHelper
                      //                               .showeDowloadedList(
                      //                                   selectedLanguageId
                      //                                       .toString());
                      //                         });
                      //                       }
                      //                     },
                      //                     child: customtext(
                      //                       fontWeight: FontWeight.w500,
                      //                       text: selectedLanguageId == '1'
                      //                           ? "Hindi"
                      //                           : selectedLanguageId == "2"
                      //                               ? "English"
                      //                               : selectedLanguageId == "3"
                      //                                   ? "Bengali"
                      //                                   : selectedLanguageId ==
                      //                                           "4"
                      //                                       ? "Malayalam"
                      //                                       : selectedLanguageId ==
                      //                                               "5"
                      //                                           ? "Telugu"
                      //                                           : "Select the Language First From The Filter.",
                      //                       fontsize: 20,
                      //                       color: selectedLanguageId == null
                      //                           ? Colors.red
                      //                           : Theme.of(context)
                      //                               .primaryColor,
                      //                     ),
                      //                   ),
                      //           ],
                      //         ),
                      //         const SizedBox(height: 15.0),
                      //         SingleChildScrollView(
                      //           scrollDirection: Axis.horizontal,
                      //           physics: const BouncingScrollPhysics(),
                      //           child: Row(
                      //             children: List.generate(
                      //               downloadList.length,
                      //               (index) => MyLibraryWidget(
                      //                 myEbooks: downloadList[index],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // ),
                      // const SizedBox(height: 20.0),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     customtext(
                      //       fontWeight: FontWeight.w500,
                      //       text : "Books",
                      //       fontsize: 20,
                      //       color: KBoxNewColor,
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     const EbookScreen()));
                      //       },
                      //       child: customtext(
                      //         fontWeight: FontWeight.w400,
                      //         text: "See All",
                      //         fontsize: 15,
                      //         color: KBoxNewColor,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 20),
                      FutureBuilder<BooksTags>(
                        future: bookTagFuture,
                        builder: (context, response) {
                          if (response.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (response.data!.data!.isEmpty) {
                            return Container();
                          }

                          return Row(
                            children: List.generate(
                              response.data!.data!.length,
                              (index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedTab = index;
                                    ebooks = ApiHelper.showebookList(
                                        response.data!.data![index].tags!);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                      color: selectedTab == index
                                          ? KBoxNewColor
                                          : Colors.white,
                                      border: Border.all(
                                          color: KBoxNewColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: customtext(
                                      fontWeight: FontWeight.w500,
                                      text: response.data!.data![index].tags!,
                                      color: selectedTab == index
                                          ? Colors.white
                                          : KBoxNewColor,
                                      fontsize: 12.0),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder<ShowBookListModal>(
                          future: ebooks,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            //MediaQuery.of(context).size.height * 0.33
                            return ListView.builder(
                                itemCount: snapshot.data!.data!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return EbooksWidget(
                                    showBookListModalData:
                                        snapshot.data!.data![index],
                                  );
                                });
                          }),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
              color: SessionManager.getTheme() == true
                  ? kscafolledColor
                  : kWhiteColor,
              borderRadius: BorderRadius.circular(20)),
          child: TextFormField(
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
              hintText: "Search",
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
      ),
    );
  }
}

class MyLibraryWidget extends StatelessWidget {
  const MyLibraryWidget({Key? key, required this.myEbooks}) : super(key: key);

  final DownloadEbooksModalData myEbooks;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 10.0, bottom: 3, top: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: SessionManager.getTheme() == true
          ? kscafolledColor
          : KBoxNewColor.withOpacity(0.7),
      child: NeumorphismWidget(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: '${myEbooks.path}${myEbooks.book!.image}',
                height: 120,
              ),
              const SizedBox(height: 5.0),
              customtext(
                fontWeight: FontWeight.w600,
                text: '${myEbooks.book!.bookName}',
                fontsize: 12.0,
                color: kWhiteColor,
              ),
              customtext(
                fontWeight: FontWeight.w400,
                maxLine: 1,
                text: '${myEbooks.book!.writerName}',
                fontsize: 8,
                color: kWhiteColor, //Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 5.0),
              BuyBottun(
                  title: "Read",
                  horizontalWidth: 35,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DownloadedBookDiscriptionScreen(
                                    downloadEbooksModalData: myEbooks)));
                  },
                  fontSize: 9,
                  verticleHight: 9),
              const SizedBox(height: 5.0),
            ],
          ),
          padding: const EdgeInsets.all(5.0)),
    );
  }
}
