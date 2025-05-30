import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_dropdown.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Modal/editadd_team_details_modal.dart';
import 'package:smart_leader/Provider/app_controller.dart';

class EditChartBottumSheet extends StatefulWidget {
  const EditChartBottumSheet({Key? key}) : super(key: key);

  @override
  State<EditChartBottumSheet> createState() => _EditChartBottumSheetState();
}

class _EditChartBottumSheetState extends State<EditChartBottumSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController priceController2 = TextEditingController();
  String type = 'Hundrad';
  String type2 = 'Hundrad';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 25, right: 25),
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customtext(
                  fontWeight: FontWeight.w500,
                  text: "+Add ",
                  color: Theme
                      .of(context)
                      .primaryColor,
                  fontsize: 20),
              SizedBox(
                height: 29,
              ),
              CustomTextField(
                hight: 50,
                title: "Enter Team Name",
                controller: titleController,
                hint: "fff",
                inputAction: TextInputAction.next,
                inputType: TextInputType.text,
                lableName: "Team Name",
                hintfont: 12,
                lablefont: 14,
                gapHight: 10,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hight: 50,
                      title: "Enter Actual Price",
                      controller: priceController,
                      hint: "fff",
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.number,
                      lableName: "Price",
                      hintfont: 12,
                      lablefont: 14,
                      gapHight: 10,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CustomDropDown(
                        lableName: "Type",
                        hint: "",
                        onChange: (String? value) {
                          setState(() {
                            type = value!;
                          });
                        },
                        items: <String>['Hundrad', 'Thousand', 'Lakh', "Crore"],
                        valueType: type),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hight: 50,
                      title: "Enter Target Price",
                      controller: priceController2,
                      hint: "fff",
                      inputAction: TextInputAction.next,
                      inputType: TextInputType.number,
                      lableName: "Price",
                      hintfont: 12,
                      lablefont: 14,
                      gapHight: 10,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CustomDropDown(
                        lableName: "Type",
                        hint: "",
                        onChange: (String? value) {
                          setState(() {
                            type2 = value!;
                          });
                        },
                        items: <String>['Hundrad', 'Thousand', 'Lakh', "Crore"],
                        valueType: type2),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              custom_Button(
                  onTap: () {
                    addTeam();

                  },
                  title: "Save",
                  hight: 45,
                  width: 150,
                  fontSize: 14),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTeam() {
    if (titleController.text.isEmpty) {
      toastMassage("Please Enter TeamName",Colors.red);
      return;
    }
    if (priceController.text.isEmpty) {
      toastMassage("Please Enter Price",Colors.red);
      return;
    }
    if (priceController2.text.isEmpty) {
      toastMassage("Please Enter Price",Colors.red);
      return;
    }
    if (type.isEmpty) {
      toastMassage("Please Enter Type",Colors.red);
      return;
    }
    final data = Provider.of<AppController>(context, listen: false);
    EditAddTeamDetailModal addTeamDetail = EditAddTeamDetailModal(
        name: titleController.text, price: priceController.text, value: type,price2: priceController2.text,value2:type2 );
    data.editaddTeam(addTeamDetail);

    Navigator.pop(context);
    toastMassage("Successfully Added",Colors.green);
    print("afaf${titleController.text}");
  }


  void toastMassage (String Massage,Color color){
    Fluttertoast.showToast(
        msg: Massage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
