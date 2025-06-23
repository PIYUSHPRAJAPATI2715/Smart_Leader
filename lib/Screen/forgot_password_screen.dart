import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Screen/login_screen.dart';
import 'package:smart_leader/Widget/common_text_field.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool otpSent = false;
  bool isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> sendOtp() async {
    setState(() => isSubmitting = true);
    final response = await http.post(
      Uri.parse("https://ruparnatechnology.com/Smartleader/Api/process.php?action=forgot_password_request"),
      body: {"email": emailController.text.trim()},
    );

    setState(() => isSubmitting = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("API response: $data");

      if (data['result']?.toString().toLowerCase().contains("otp") == true) {
        Fluttertoast.showToast(msg: "OTP sent to your email");
        setState(() {
          otpSent = true;
        });
      } else {
        Fluttertoast.showToast(msg: data['result'] ?? "Failed to send OTP");
      }

    } else {
      Fluttertoast.showToast(msg: "Server error");
    }
  }

  Future<void> resetPassword() async {
    setState(() => isSubmitting = true);

    final response = await http.post(
      Uri.parse("https://ruparnatechnology.com/Smartleader/Api/process.php?action=reset_password"),
      body: {
        "email": emailController.text.trim(),
        "otp": otpController.text.trim(),
        "new_password": newPasswordController.text.trim(),
      },
    );

    setState(() => isSubmitting = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == "Password has been reset successfully") {
        Fluttertoast.showToast(msg: "Password reset successful");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      } else {
        Fluttertoast.showToast(msg: data['result'] ?? "Reset failed");
      }
    } else {
      Fluttertoast.showToast(msg: "Server error");
    }
  }

  Widget topContainer() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assest/images/OnBordScreenTopScreen.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget bottomContainer() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assest/images/OnBordScreenBottumImage.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              topContainer(),
              Positioned(
                  top: 60,
                  left: 20,
                  child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white)))
            ]),
            const SizedBox(height: 30),
            customtext(
              text: "Forgot Password",
              fontsize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CommonTextField(
                      controller: emailController,
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter email';
                        }
                        if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                            .hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                          if (_formKey.currentState?.validate() ??
                              false) {
                            sendOtp();
                          }
                        },
                        child: const Text("Send OTP"),
                      ),
                    ),
                  if (otpSent ==false) ...[
                    const SizedBox(height: 250),],
                    if (otpSent) ...[
                      const SizedBox(height: 10),
                      CommonTextField(
                        controller: otpController,
                        label: "OTP",
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Enter OTP' : null,
                      ),
                      const SizedBox(height: 10),
                      CommonTextField(
                        controller: newPasswordController,
                        label: "New Password",
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter new password';
                          }
                          if (value.length < 8) {
                            return 'Min 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : () {
                            if (_formKey.currentState?.validate() ??
                                false) {
                              resetPassword();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF795548),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSubmitting
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text("Reset Password"),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            bottomContainer(),
          ],
        ),
      ),
    );
  }
}
