import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_description_textfield.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';

import '../Helper/theme_colors.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);
  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  bool isSubmit = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController massageController = TextEditingController();

  void contact() async {
    if (nameController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Name', Colors.red, context);
      return;
    }
    if (emailController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Email', Colors.red, context);
      return;
    }
    if (numberController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Mobile Number', Colors.red, context);
      return;
    }
    if (subjectController.text.isEmpty) {
      Helper.showSnackVar('Please Enter Subject', Colors.red, context);
      return;
    }
    if (massageController.text.isEmpty) {
      Helper.showSnackVar('Please Write Something', Colors.red, context);
      return;
    }

    Map<String, String> body = {
      "name": nameController.text,
      'email': emailController.text,
      "mobile": numberController.text,
      "subject": subjectController.text,
      "user_id": "1",
      "message": massageController.text,
    };

    setState(() {
      isSubmit = true;
    });

    ApiHelper.contacTUs(body).then((login) {
      setState(() {
        isSubmit = false;
      });

      if (login.massage == ' Successfully Added') {
        clearText();
        Helper.showSnackVar('Successfully Added', Colors.green, context);
      } else {
        Helper.showSnackVar('Error', Colors.red, context);
      }
    });
  }

  void clearText() {
    nameController.clear();
    emailController.clear();
    numberController.clear();
    subjectController.clear();
    massageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    Center(
                        child: customtext(
                      fontWeight: FontWeight.w500,
                      text: "Contact Us",
                      fontsize: 20,
                      color: Theme.of(context).primaryColor,
                    )),
                    const SizedBox(height: 30.0),
                    CustomTextField(
                        hintfont: 14,
                        lablefont: 18,
                        hight: 50,
                        title: "Enter Name",
                        controller: nameController,
                        hint: "Enter Name",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        lableName: "Name"),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        hintfont: 14,
                        lablefont: 18,
                        hight: 50,
                        title: "Enter Email",
                        controller: emailController,
                        hint: "Afsar Khan",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        lableName: "Email"),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        hintfont: 14,
                        lablefont: 18,
                        hight: 50,
                        title: "Enter Mobile Number",
                        controller: numberController,
                        hint: "Afsar Khan",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        lableName: "Mobile Number"),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        hintfont: 14,
                        lablefont: 18,
                        hight: 50,
                        title: "Enter Subject",
                        controller: subjectController,
                        hint: "Afsar Khan",
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        lableName: "Subject"),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomDescriptionTextfield(
                        focusNode: FocusNode(),
                        onchanged: (value) {},
                        boxHight: 150,
                        title: "",
                        controller: massageController,
                        hint: "Write Something . . .",
                        inputAction: TextInputAction.newline,
                        inputType: TextInputType.multiline,
                        lableName: "Description",
                        hintfont: 14,
                        lablefont: 18),
                    const SizedBox(
                      height: 30,
                    ),
                    isSubmit == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : custom_Button(
                            width: 200,
                            hight: 55,
                            onTap: () {
                              contact();
                            },
                            title: "Submit",
                            fontSize: 20,
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
