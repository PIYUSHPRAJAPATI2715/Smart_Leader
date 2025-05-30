import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_floting_button.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/ExtractClasses/bottom_sheet_screen.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/my_team.dart';
import 'package:smart_leader/Screen/my_join_team_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:smart_leader/Widget/update_team_widget.dart';

class AddBusinessTeamScreen extends StatefulWidget {
  const AddBusinessTeamScreen({Key? key}) : super(key: key);

  @override
  State<AddBusinessTeamScreen> createState() => _AddBusinessTeamScreenState();
}

class _AddBusinessTeamScreenState extends State<AddBusinessTeamScreen> {
  late Future<MyTeam> _futureTeam;

  Future<MyTeam> getTeamList() {
    return ApiHelper.showIndividualTeam();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureTeam = getTeamList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: FutureBuilder<MyTeam>(
              future: _futureTeam,
              builder: (context, response) {
                if (response.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (response.data!.data!.isEmpty) {
                  return Center(
                    child: customtext(
                        fontWeight: FontWeight.w600,
                        text: 'No Team added',
                        fontsize: 16.0),
                  );
                }

                List<MyTeamData> myTeamList = response.data!.data!;
                return ListView.builder(
                  itemCount: myTeamList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 0.5)),
                      margin: const EdgeInsets.only(
                          top: 10, left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customtext(
                                      fontWeight: FontWeight.w700,
                                      text: myTeamList[index].teamName!,
                                      fontsize: 14.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(height: 8.0),
                                    customtext(
                                      fontWeight: FontWeight.w500,
                                      text: 'Id: ${myTeamList[index].teamId}',
                                      fontsize: 14.0,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    customtext(
                                      fontWeight: FontWeight.w400,
                                      text: 'Target',
                                      fontsize: 12.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(height: 8.0),
                                    customtext(
                                      fontWeight: FontWeight.w500,
                                      text:
                                          '₹${myTeamList[index].targetAmount}',
                                      fontsize: 14.0,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    customtext(
                                      fontWeight: FontWeight.w400,
                                      text: 'Completed',
                                      fontsize: 12.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(height: 8.0),
                                    customtext(
                                      fontWeight: FontWeight.w500,
                                      text: '₹${myTeamList[index].amount}',
                                      fontsize: 14.0,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      )),
                                      context: context,
                                      builder: (context) {
                                        return UpdateIndividualTeamWidget(
                                          data: myTeamList[index],
                                          type: 'Target',
                                        );
                                      },
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          _futureTeam = getTeamList();
                                        });
                                      }
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    side: const BorderSide(
                                        color: kblueColor, width: 0.5),
                                  ),
                                  child: customtext(
                                    fontWeight: FontWeight.w500,
                                    text: 'Target',
                                    fontsize: 14.0,
                                    color: kblueColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      )),
                                      context: context,
                                      builder: (context) {
                                        return UpdateIndividualTeamWidget(
                                          data: myTeamList[index],
                                          type: 'Complete',
                                        );
                                      },
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          _futureTeam = getTeamList();
                                        });
                                      }
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    side: const BorderSide(
                                        color: kblueColor, width: 0.5),
                                  ),
                                  child: customtext(
                                    fontWeight: FontWeight.w500,
                                    text: 'Complete',
                                    fontsize: 12.0,
                                    color: kblueColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    deleteTeam(myTeamList[index].id!);
                                  },
                                  style: TextButton.styleFrom(
                                    side: const BorderSide(
                                        color: kredColor, width: 0.5),
                                  ),
                                  child: customtext(
                                    fontWeight: FontWeight.w500,
                                    text: 'Delete',
                                    fontsize: 14.0,
                                    color: kredColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Custom_flowting_action_button(onTap: () {
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
            context: context,
            builder: (context) {
              return const BottomScreen(
                teamType: 'Individual',
              );
            }).then((value) {
          if (value == true) {
            setState(() {
              _futureTeam = getTeamList();
            });
          }

        });
      }),
    );
  }

  void deleteTeam(String teamId) {
    Map<String, String> map = {
      'id': teamId,
    };

    Helper.showLoaderDialog(context, message: 'Deleting...');

    ApiHelper.deleteIndividualTeam(map).then((value) {
      Navigator.pop(context);
      if (value.message == ' Successfully Deleted') {
        Helper.showSnackVar(value.message!, Colors.green, context);
        setState(() {
          _futureTeam = getTeamList();
        });
      } else {
        Helper.showSnackVar(value.message!, Colors.red, context);
      }
    });
  }
}

//todo: ------------------------------------------------------------------

class UpdateIndividualTeamWidget extends StatefulWidget {
  const UpdateIndividualTeamWidget({
    Key? key,
    required this.data,
    required this.type,
  }) : super(key: key);

  final MyTeamData data;
  final String type;

  @override
  State<UpdateIndividualTeamWidget> createState() =>
      _UpdateIndividualTeamWidgetState();
}

class _UpdateIndividualTeamWidgetState
    extends State<UpdateIndividualTeamWidget> {
  final TextEditingController _amountController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            children: [
              Expanded(
                child: customtext(
                    fontWeight: FontWeight.w500,
                    text: "Update ${widget.type} Amount",
                    color: Theme.of(context).primaryColor,
                    fontsize: 20),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear))
            ],
          ),
        ),
        const Divider(),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: CustomTextField(
            hight: 50,
            title: "Enter Amount",
            controller: _amountController,
            hint: "fff",
            inputAction: TextInputAction.done,
            inputType: TextInputType.number,
            lableName: "Amount",
            hintfont: 12,
            lablefont: 14,
            gapHight: 10,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : custom_Button(
                onTap: () {
                  if (widget.type == 'Complete') {
                    updateTeam();
                  } else {
                    updateTargetAmount();
                  }
                },
                title: "Update",
                hight: 45,
                width: 150,
                fontSize: 14,
              ),
        const SizedBox(height: 25),
      ],
    );
  }

  void updateTeam() {
    if (_amountController.text.isEmpty) {
      Helper.toastMassage('Enter complete amount', Colors.red);
      return;
    }

    // int targetAmount = int.parse(widget.data.targetAmount!);
    // int completeAmt = int.parse(_amountController.text);
    //
    // if (completeAmt > targetAmount) {
    //   Helper.toastMassage(
    //       'Enter complete amount less than or equal to target amount',
    //       Colors.red);
    //   return;
    // }

    setState(() {
      isLoading = true;
    });

    Map<String, String> body = {
      'id': widget.data.id!,
      'amount': _amountController.text
    };

    ApiHelper.updateIndividualTeamAmount(body).then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context, true);
      if (value.message == 'Update Successfully') {
        Helper.toastMassage(value.message!, Colors.green);
      } else {
        Helper.toastMassage(value.message!, Colors.red);
      }
    });
  }

  void updateTargetAmount() {
    if (_amountController.text.isEmpty) {
      Helper.toastMassage('Enter complete amount', Colors.red);
      return;
    }

    // int targetAmount = int.parse(widget.data.targetAmount!);
    // int completeAmt = int.parse(_amountController.text);
    //
    // if (completeAmt > targetAmount) {
    //   Helper.toastMassage(
    //       'Enter complete amount less than or equal to target amount',
    //       Colors.red);
    //   return;
    // }

    setState(() {
      isLoading = true;
    });

    Map<String, String> body = {
      'id': widget.data.id!,
      'target_amount': _amountController.text
    };

    ApiHelper.updateIndividualTeamAmount(body).then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context, true);
      if (value.message == 'Update Successfully') {
        Helper.toastMassage(value.message!, Colors.green);
      } else {
        Helper.toastMassage(value.message!, Colors.red);
      }
    });
  }
}
