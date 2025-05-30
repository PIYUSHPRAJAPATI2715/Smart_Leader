import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_connection_modal.dart';

import '../Componants/custom_bottun.dart';
import '../Helper/Api.helper.dart';
import '../Helper/helper.dart';
import '../LocalDatabase/Db/dp_helper.dart';
import '../Modal/new_event.dart';
import '../Widget/edit_creat_connection_widget.dart';

class ViewConnectionScreen extends StatefulWidget {
  final NewEventData showConnectionModalData;

  const ViewConnectionScreen({
    Key? key,
    required this.showConnectionModalData,
  }) : super(key: key);

  @override
  State<ViewConnectionScreen> createState() => _ViewConnectionScreenState();
}

class _ViewConnectionScreenState extends State<ViewConnectionScreen> {
  bool isSubmit = false;
  bool isNetwork = false;
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35.0),
                    const customtext(
                      fontWeight: FontWeight.w500,
                      text: 'Name',
                      fontsize: 14,
                      color: Colors.black54,
                    ),
                    const SizedBox(height: 5.0),
                    customtext(
                      fontWeight: FontWeight.w600,
                      text: widget.showConnectionModalData.name!,
                      fontsize: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 15.0),
                    customtext(
                      fontWeight: FontWeight.w500,
                      text: 'Number',
                      fontsize: 14,
                      color: Colors.black54,
                    ),
                    const SizedBox(height: 5.0),
                    customtext(
                      fontWeight: FontWeight.w600,
                      text: widget.showConnectionModalData.mobile!,
                      fontsize: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 15.0),
                    customtext(
                      fontWeight: FontWeight.w500,
                      text: 'Occupation',
                      fontsize: 14,
                      color: Colors.black54,
                    ),
                    customtext(
                      fontWeight: FontWeight.w600,
                      text: widget.showConnectionModalData.occupation!,
                      fontsize: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 5.0),
                    Visibility(
                      visible: widget.showConnectionModalData.meetingRequired == 'Yes',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15.0),
                          customtext(
                            fontWeight: FontWeight.w500,
                            text: 'Date',
                            fontsize: 14,
                            color: Colors.black54,
                          ),
                          const SizedBox(height: 5.0),
                          customtext(
                            fontWeight: FontWeight.w600,
                            text: widget.showConnectionModalData.date!,
                            fontsize: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 15.0),
                          customtext(
                            fontWeight: FontWeight.w500,
                            text: 'Time',
                            fontsize: 14,
                            color: Colors.black54,
                          ),
                          const SizedBox(height: 5.0),
                          customtext(
                            fontWeight: FontWeight.w600,
                            text: widget.showConnectionModalData.time!,
                            fontsize: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 15.0),
                          customtext(
                            fontWeight: FontWeight.w500,
                            text: 'Remind Me',
                            fontsize: 14,
                            color: Colors.black54,
                          ),
                          const SizedBox(height: 5.0),
                          customtext(
                            fontWeight: FontWeight.w600,
                            text: widget.showConnectionModalData.remind!,
                            fontsize: 16,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    customtext(
                      fontWeight: FontWeight.w500,
                      text: 'Notes',
                      fontsize: 14,
                      color: Colors.black54,
                    ),
                    const SizedBox(height: 5.0),
                    customtext(
                      fontWeight: FontWeight.w600,
                      text: widget.showConnectionModalData.notes == null
                          ? ''
                          : widget.showConnectionModalData.notes!,
                      fontsize: 16,
                      color: Colors.black,
                    ),

                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
          height: 50,
          child: Row(
                  children: [
                    Expanded(
                      child: custom_Button(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCreatConnectionWidget(
                                    showConnectionModalData:
                                        widget.showConnectionModalData,
                                    connectionTypeId:
                                        widget.showConnectionModalData.id.toString()),
                              ),
                            );
                          },
                          title: "Edit Note",
                          hight: 45,
                          width: 140,
                          fontSize: 20),
                    ),
                    Expanded(
                      child: custom_Button(
                          onTap: () {
                            showDeleteDialog(widget.showConnectionModalData.id!);
                          },
                          title: "Delete Note",
                          hight: 45,
                          width: 140,
                          fontSize: 20),
                    ),
                  ],
                )),
    );
  }

  void showDeleteDialog(String deleteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Confirm Deletion ?",
          fontsize: 22,
          color: Theme.of(context).primaryColor,
        ),

        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: customtext(
                    fontWeight: FontWeight.w600, text: 'No', fontsize: 12),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  delete(deleteId);
                },
                child: customtext(
                  fontWeight: FontWeight.w600,
                  text: 'Yes',
                  fontsize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void delete(String id) async {
    isNetwork = await Helper.isNetworkAvailable();

    if (isNetwork) {
      Map<String, String> body = {"id": id};

      setState(() {
        isSubmit = true;
      });

      ApiHelper.deleteNewEvent(body).then((login) {
        if (login.status == "true") {
          Helper.showSnackVar("Successfully Deleted", Colors.green, context);
          Navigator.pop(context);

          // Helper.showLoaderDialog(context);

          setState(() {
            isSubmit = false;
          });
          // Map<String, String> body = {
          //   "connection_type_id": widget.showConnectionFolderModalData.id,
          //   "user_id": SessionManager.getUserID(),
          // };
          // showConnection = ApiHelper.showConnection(body);

          //todo: getting data after delete

        }
      });
    } else {
      await DBHelper.deleteConnections(int.parse(id));

    }
  }

}
