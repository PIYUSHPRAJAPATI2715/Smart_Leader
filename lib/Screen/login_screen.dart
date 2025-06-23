import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Screen/welcome_screen.dart';
import 'package:smart_leader/Widget/bottum_navBar.dart';
import 'package:http/http.dart' as http;

import '../Widget/common_text_field.dart';
import '../repo/signup_repo.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSubmit = false;
  final TextEditingController emailController = TextEditingController();


  final TextEditingController passwordController = TextEditingController();

  // bool isSubmit = false;
  Future<void> _getToken() async {
    try {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
      print("Permission: ${settings.authorizationStatus}");

      String? token = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $token");
    } catch (e) {
      print("Error getting token: $e");
    }
  }

  final _formKey = GlobalKey<FormState>();
  final SignupRepository signupRepository = SignupRepository();
  Future<void> submit() async {
    setState(() => isSubmit = true);

    final Map<String, String> bodyData = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    print("📤 Sending data to API: $bodyData");

    try {
      final response = await http.post(
        Uri.parse("https://ruparnatechnology.com/Smartleader/Api/process.php?action=user_login"),
        body: bodyData,
      );

      setState(() => isSubmit = false);

      print("📥 Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          print("✅ Decoded JSON: $data");

          if (data['result'] != null && data['result'] == "Login Successful") {
            final user = data['user'];

            // Save session data
            SessionManager.setUserLoggedIn(true);
            SessionManager.setUserID(user['id']);
            SessionManager.setFirstName(user['username']);

            Fluttertoast.showToast(msg: "Login Successful");
            Helper.showSnackVar('Successfully Login', Colors.green, context);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottumNavBar()),
            );
          } else if (data['error'] != null) {
            Fluttertoast.showToast(msg: data['error']);
          } else {
            Fluttertoast.showToast(msg: data);
            print("⚠️ Unexpected data format: $data");
          }
        } catch (e) {
          print("❌ JSON decode error: $e");
          Fluttertoast.showToast(msg: "Invalid JSON response");
        }
      } else {
        print("❌ API call failed with status code: ${response.statusCode}");
        Fluttertoast.showToast(msg: "Failed to connect to server");
      }
    } catch (e) {
      setState(() => isSubmit = false);
      print("❌ Exception during API call: $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: topContainer(),
            ),
            SizedBox(
              height: 30,
            ),
            customtext(
              fontWeight: FontWeight.w700,
              text: "Login",
              fontsize: 40,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 30,
            ),


            CommonTextField(
              controller: emailController,
              label: "Email",
              hintText: "Enter your email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required";
                }
                return null;
              },
            ),

            CommonPasswordField(
              controller: passwordController,
              label: "Password",
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmit ? null : () {
                    // Validate fields manually before submitting

                    // _getToken();
                    if (emailController.text.trim().isEmpty) {
                      Fluttertoast.showToast(msg: "Email is required");
                      return;
                    }

                    if (passwordController.text.trim().isEmpty) {
                      Fluttertoast.showToast(msg: "Password is required");
                      return;
                    }

                    // All validations passed, call submit function
                    submit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548), // Brown color
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: isSubmit
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit'),
                ),
              ),
            )

            ,
            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customtext(
                  fontWeight: FontWeight.w300,
                  text: "If your are not registered ? ",
                  fontsize: 18,
                  color: Theme.of(context).primaryColor,
                ),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                  },
                  child: customtext(
                      color: SessionManager.getTheme() == true
                          ? kWhiteColor
                          : Color(0xff2036B4),
                      fontWeight: FontWeight.w400,
                      text: "Signup",
                      fontsize: 22),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customtext(
                  fontWeight: FontWeight.w300,
                  text: "If your are forgot password ? ",
                  fontsize: 18,
                  color: Theme.of(context).primaryColor,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassScreen()),
                    );

                  },
                  child: customtext(
                      color: SessionManager.getTheme() == true
                          ? kWhiteColor
                          : Color(0xff2036B4),
                      fontWeight: FontWeight.w400,
                      text: "Click here",

                      fontsize: 22),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),


            Expanded(
              child: bottumContainer(),
            )
          ],
        ),
      ),
    );
  }

  Widget topContainer() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assest/images/OnBordScreenTopScreen.png"),
              fit: BoxFit.fill)),
    );
  }

  Widget bottumContainer() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assest/images/OnBordScreenBottumImage.png"),
              fit: BoxFit.fill)),
    );
  }
}
