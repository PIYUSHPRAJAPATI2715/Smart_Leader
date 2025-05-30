import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/buy_bottum.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/ExtractClasses/new_added_ebook_widget.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_book_list_modal.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';
import 'package:smart_leader/Screen/book_description_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

class NewAddedBookScreen extends StatefulWidget {

  const NewAddedBookScreen({Key? key}) : super(key: key);

  @override
  State<NewAddedBookScreen> createState() => _NewAddedBookScreenState();
}

class _NewAddedBookScreenState extends State<NewAddedBookScreen> {

  late Future<ShowBookListModal>newebooks;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newebooks = ApiHelper.newaddedbookList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopContainer(
              title: "New Added",
              onTap: () {
                Navigator.pop(context);
              }),
          FutureBuilder<ShowBookListModal>(
              future: newebooks,
              builder: (context, snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                return ListView.builder(
                    itemCount: snapshot.data!.data!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      return  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: NewAddedEbookWidget(showBookListModalData: snapshot.data!.data![index],),
                      );
                    });
              })
        ],
      ),
    );
  }
}
