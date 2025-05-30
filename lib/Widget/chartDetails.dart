
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Provider/app_controller.dart';

class chartDetail extends StatefulWidget {
  const chartDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<chartDetail> createState() => _chartDetailState();
}

class _chartDetailState extends State<chartDetail>  {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.teamDetailList.length,
        itemBuilder: (BuildContext, index) {
          return Row(
            children: [
              Container(
                width: 137,
                padding: EdgeInsets.symmetric(horizontal: 37, vertical: 20.5),
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
                    text: data.teamDetailList[index].name!,
                    fontsize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                          flex: 4,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: data.teamDetailList[index].price!,
                                fontsize: 12,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              customtext(
                                fontWeight: FontWeight.w500,
                                text: data.teamDetailList[index].value!,
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
                              SizedBox(
                                width: 25,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                data.teamDetailList.removeAt(index);
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
