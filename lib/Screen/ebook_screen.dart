import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/buy_bottum.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/ExtractClasses/ebooks_widget.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_book_list_modal.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';
import 'package:smart_leader/Screen/book_description_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class EbookScreen extends StatefulWidget {
  const EbookScreen({Key? key}) : super(key: key);

  @override
  State<EbookScreen> createState() => _EbookScreenState();
}

class _EbookScreenState extends State<EbookScreen> {

  late Future<ShowBookListModal>ebooks;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ebooks = ApiHelper.showebookList('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopContainer(title: "Books",onTap: (){
            Navigator.pop(context);
          }),
          FutureBuilder<ShowBookListModal>(
            future: ebooks,
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
            return Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.data!.length,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
               itemBuilder: (BuildContext, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: EbooksWidget(
                    showBookListModalData: snapshot.data!.data![index],
                  ),
                );
              }),
            );
          })



        ],

      ),
    );
  }
}
/*
GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.data!.length,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 240,
                      childAspectRatio: 5 / 2
                  ), itemBuilder: (BuildContext, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: EbooksWidget(
                    showBookListModalData: snapshot.data!.data![index],
                  ),
                );
              }),
 */