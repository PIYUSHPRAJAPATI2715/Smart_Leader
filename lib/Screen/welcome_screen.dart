import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:smart_leader/Screen/login_screen.dart';
import 'package:smart_leader/Widget/bottum_navBar.dart';
import 'package:http/http.dart' as http;

import '../Widget/common_text_field.dart';
import '../repo/signup_repo.dart';
import 'otp_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isSubmit = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: (['email', 'public_profile']));
      final token = result.accessToken!.token;
      print(
          'Facebook token userID : ${result.accessToken!.grantedPermissions}');
      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/'
          'v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));

      final profile = jsonDecode(graphResponse.body);
      print("Profile is equal to $profile");
      try {
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookCredential);
        Map<String, String> body = {
          "auth_id": userCredential.user!.uid,
          "provider": userCredential.user!.uid,
          "username": userCredential.user!.displayName!,
          "email": userCredential.user!.email!,
          "file": userCredential.user!.photoURL!,
        };
        socialLogin(body);
      } catch (e) {
        final snackBar = SnackBar(
          margin: const EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
          backgroundColor: (Colors.redAccent),
          action: SnackBarAction(
            label: 'dismiss',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print("error occurred");
      print(e.toString());
    }
  }

  Future<void> googleLogin() async {

    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var result = await googleSignIn.signIn();
      if (result == null) {
        return;
      }

      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("firbase data for Social Login $credential");

      Map<String, String> body = {
        "auth_id": finalResult.user!.uid,
        "provider": finalResult.user!.uid,
        "username": finalResult.user!.displayName!,
        "email": finalResult.user!.email!,
        "file": finalResult.user!.photoURL!,
      };
      socialLogin(body);
    } catch (error) {
      print("Google login error: ${error.toString()}");
      // Map<String, String> body = {
      //   "auth_id": 'Remi Note 7',
      //   "provider": 'Remi Note 7',
      //   "username": 'Remi Note 7',
      //   "email": 'redmi@test.com',
      //   "file":
      //       'https://www.shutterstock.com/image-photo/word-demo-appearing-behind-torn-260nw-1782295403.jpg',
      // };
      //
      // socialLogin(body);
    }
  }
  // bool isSubmit = false;
  final _formKey = GlobalKey<FormState>();
  final SignupRepository signupRepository = SignupRepository();
  Future<void> submit() async {
    setState(() => isSubmit = true);

    final Map<String, String> bodyData = {
      "username": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "password": passwordController.text.trim(),
    };

    print("Sending data to API: $bodyData");

    final response = await http.post(
      Uri.parse("https://ruparnatechnology.com/Smartleader/Api/process.php?action=user_signup"),
      body: bodyData,
    );

    setState(() => isSubmit = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] != null) {
        final String resultMessage = data['result'];
        Fluttertoast.showToast(msg: resultMessage);

        if (resultMessage == "OTP Sent to your Email") {
          // Navigate to OTP screen if OTP was sent
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OtpScreen(email: emailController.text.trim(),),),
          );
        } else {
          // Show a success message but don't navigate
          Helper.showSnackVar(resultMessage, Colors.green, context);
        }

      } else if (data['error'] != null) {
        Fluttertoast.showToast(msg: data['error']);
      } else {
        Fluttertoast.showToast(msg: "Unexpected response from server");
      }
    } else {
      Fluttertoast.showToast(msg: "Failed to connect to server");
    }
  }


  // void submit() async {
 //    if (!_formKey.currentState!.validate()) return;
 //
 //    setState(() {
 //      isSubmit = true;
 //    });
 //
 //    try {
 //      final response = await signupRepository.signup(
 //        name: nameController.text.trim(),
 //        username: nameController.text.trim(),
 //        email: emailController.text.trim(),
 //        phone: phoneController.text.trim(),
 //        password: passwordController.text.trim(),
 //      );
 //
 //      ScaffoldMessenger.of(context).showSnackBar(
 //        SnackBar(content: Text(response.result)),
 //      );
 //    } catch (e) {
 //      ScaffoldMessenger.of(context).showSnackBar(
 //        SnackBar(content: Text('Signup failed: ${e.toString()}')),
 //      );
 //    } finally {
 //      setState(() {
 //        isSubmit = false;
 //      });
 //    }
 //  }
  void socialLogin(Map<String, String> body) {
    print('TESTSET $body');
    setState(() {
      isSubmit = true;
    });

    ApiHelper.login(body).then((login) {
      setState(() {
        isSubmit = false;
      });
      if (login.result == 'Login Successfull') {
        SessionManager.setUserLoggedIn(true);
        SessionManager.setUserID(login.id!);
        SessionManager.setFirstName(login.username!);
        Helper.showSnackVar('Successfully Login', Colors.green, context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottumNavBar()));
      } else {
        Helper.showSnackVar('Error', Colors.red, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
          child: Column(
            children: [
              topContainer(),
              SizedBox(
                height: 10,
              ),
              customtext(
                fontWeight: FontWeight.w700,
                text: "Welcome",
                fontsize: 40,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 20,
              ),
        
              CommonTextField(
                controller: nameController,
                label: "Name",
                hintText: "Enter your Name",
                keyboardType: TextInputType.name,
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "name is required";
                  }
                  return null;
                },
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
              CommonTextField(
                controller: phoneController,
                label: "Phone Number",
                hintText: "Enter your phone number",
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required";
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
                      if (nameController.text.trim().isEmpty) {
                        Fluttertoast.showToast(msg: "Name is required");
                        return;
                      }
                      if (emailController.text.trim().isEmpty) {
                        Fluttertoast.showToast(msg: "Email is required");
                        return;
                      }
                      if (phoneController.text.trim().isEmpty) {
                        Fluttertoast.showToast(msg: "Phone number is required");
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customtext(
                    fontWeight: FontWeight.w300,
                    text: "If your are already registered ? ",
                    fontsize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: customtext(
        
                        color: SessionManager.getTheme() == true
                            ? kWhiteColor
                            : Color(0xff2036B4),
                        fontWeight: FontWeight.w400,
                        text: "Login",
                        fontsize: 22),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              customtext(
                  color: SessionManager.getTheme() == true
                      ? kWhiteColor
                      : Color(0xff2036B4),
                  fontWeight: FontWeight.w400,
                  text: "Signup",
                  fontsize: 30),
              SizedBox(
                height: 10,
              ),
              customtext(
                fontWeight: FontWeight.w300,
                text: "With",
                fontsize: 18,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: 10,
              ),
              isSubmit == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            googleLogin();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: SessionManager.getTheme() == true
                                      ? kWhiteColor
                                      : Color(0xff156064),
                                  width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Image.asset("assest/png_icon/googleicon.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        InkWell(
                          onTap: () {
                            signInWithFacebook();
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: SessionManager.getTheme() == true
                                      ? kWhiteColor
                                      : Color(0xff156064),
                                  width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child:
                                  Image.asset("assest/png_icon/facebookicon.png"),
                            ),
                          ),
                        )
                      ],
                    ),
              SizedBox(
                height: 35,
              ),
              bottumContainer()
            ],
          ),
        ),
      ),
    );
  }

  Widget topContainer() {
    return Container(
      width: double.infinity,
      height: 80,
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
