import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Provider/app_controller.dart';

class EditChartDetail extends StatefulWidget {
  const EditChartDetail({Key? key}) : super(key: key);

  @override
  State<EditChartDetail> createState() => _EditChartDetailState();
}

class _EditChartDetailState extends State<EditChartDetail> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.editteamDetailList.length,
        itemBuilder: (BuildContext, index) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20.5),
                  decoration: BoxDecoration(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : kWhiteColor,
                      border: Border.all(
                          color: SessionManager.getTheme() == true
                              ? kWhiteColor
                              : k2BlackColor)),
                  child: Center(
                    child: customtext(
                      fontWeight: FontWeight.w500,
                      text: data.editteamDetailList[index].name!,
                      fontsize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : kWhiteColor,
                      border: Border.all(
                          color: SessionManager.getTheme() == true
                              ? kWhiteColor
                              : k2BlackColor)),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: data.editteamDetailList[index].price!,
                                fontsize: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: data.editteamDetailList[index].value!,
                                fontsize: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_sharp,
                                size: 15,
                                color: Theme.of(context).primaryColor,
                              ),

                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: InkWell(
                        //     onTap: () {
                        //       setState(() {
                        //         data.editteamDetailList.removeAt(index);
                        //       });
                        //       Helper.showSnackVar(
                        //           "Remove", Colors.green, context);
                        //     },
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.highlight_remove,
                        //           size: 15,
                        //           color: Theme.of(context).primaryColor,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 4),
                  decoration: BoxDecoration(
                      color: SessionManager.getTheme() == true
                          ? kscafolledColor
                          : kWhiteColor,
                      border: Border.all(
                          color: SessionManager.getTheme() == true
                              ? kWhiteColor
                              : k2BlackColor)),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: data.editteamDetailList[index].price2!,
                                fontsize: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(width: 5,),
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: data.editteamDetailList[index].value2!,
                                fontsize: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_sharp,
                                size: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),


                        InkWell(
                          onTap: () {
                            setState(() {
                              data.editteamDetailList.removeAt(index);
                            });
                            Helper.showSnackVar(
                                "Remove", Colors.green, context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.highlight_remove,
                                size: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
