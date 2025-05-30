import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_check_box.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Modal/my_team.dart';
import 'package:smart_leader/Provider/app_controller.dart';

class UpdateTeamTargetWidget extends StatefulWidget {
  const UpdateTeamTargetWidget(
      {Key? key, required this.data, required this.type})
      : super(key: key);

  final MyTeamData data;
  final String type;

  @override
  State<UpdateTeamTargetWidget> createState() => _UpdateTeamTargetWidgetState();
}

class _UpdateTeamTargetWidgetState extends State<UpdateTeamTargetWidget> {
  final TextEditingController _amountController = TextEditingController();

  bool isLoading = false;
  bool isComplete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AppController>(context, listen: false).unitFormat = '0';

    if (widget.type == 'Target') {
      _amountController.text = widget.data.myAmount ?? '';
    } else {
      _amountController.text = widget.data.myCompletedAmount ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppController>(context);
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
                    text: "Update ${widget.type} Business",
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
          child: CustomAmountTextField(
            hight: 50,
            title: "Enter Business",
            controller: _amountController,
            hint: "fff",
            inputAction: TextInputAction.next,
            inputType: TextInputType.number,
            lableName: "${widget.type} Business",
            hintfont: 12,
            lablefont: 14,
            gapHight: 10,
            onChanged: (value) {
              if (value.isNotEmpty) {
                int number = int.parse(value);
                data.formatUnitType(number);
              } else {
                data.formatUnitType(0);
              }
            },
            unitType: data.unitFormat,
          ),
        ),
        const SizedBox(height: 15),
        Visibility(
          visible: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CustomCheckBox(
              label: 'Please check when your target completed for this month.',
              value: isComplete,
              onChanged: (value) {
                setState(() {
                  isComplete = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 25),
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
                fontSize: 14),
        const SizedBox(height: 25),
      ],
    );
  }

  void updateTeam() {

    if (_amountController.text.isEmpty) {
      Helper.toastMassage('Enter complete amount', Colors.red);
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, String> body = {
      'id': widget.data.id!,
      'amount': _amountController.text.trim(),
      'team_id': widget.data.teamId!,
      "status": isComplete ? "1" : "0"
    };

    ApiHelper.updateTeam(body).then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context, true);
      if (value.message == 'Update Team Successfully') {
        Provider.of<AppController>(context, listen: false).getBarGraphList();

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

    setState(() {
      isLoading = true;
    });

    Map<String, String> body = {
      'id': widget.data.id!,
      'target_amount': _amountController.text
    };

    ApiHelper.updateTargetTeam(body).then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context, true);
      if (value.message == ' Target Amount Update Successfully') {
        Provider.of<AppController>(context, listen: false).getBarGraphList();
        Helper.toastMassage(value.message!, Colors.green);
      } else {
        Helper.toastMassage(value.message!, Colors.red);
      }
    });
  }
}
