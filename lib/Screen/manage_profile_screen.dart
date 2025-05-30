import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_bottun.dart';
import 'package:smart_leader/Componants/custom_new_edit.dart';
import 'package:smart_leader/Componants/custom_textField.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/Api.network.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Modal/showprofile_image_modal.dart';
import 'package:smart_leader/Screen/tools_screen.dart';
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/custom_Round_Bottun.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/Api.network.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/showprofile_image_modal.dart';
import 'package:smart_leader/Modal/updateprofile_image_modal.dart';
import 'package:smart_leader/Provider/theme_changer_provider.dart';
import 'package:smart_leader/Screen/add_folder_screen.dart';
import 'package:smart_leader/Screen/add_mytask_screen.dart';
import 'package:smart_leader/Screen/manage_profile_screen.dart';
import 'package:http/http.dart' as http;
import '../Helper/theme_colors.dart';
import '../Modal/updateprofile_image_modal.dart';

class ManageProfileScreen extends StatefulWidget {
  const ManageProfileScreen({Key? key}) : super(key: key);

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  TextEditingController NameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController PhoneNumberController = TextEditingController();
  bool isSummited = true;
  bool isupdated = false;
  File? pickedImage1;

  late ShowProfileImageModal showProfileImageModal;
  late UpdateProfileImageModal updateProfileImageModal;

  String url = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyProfileInfo();
    getMyProfileInfo1();
  }

  Future<void> getMyProfileInfo1() async {
    final response = await http.post(Uri.parse(ApiNetwork.showprofile),
        body: {'user_id': SessionManager.getUserID()});

    if (response.statusCode == 200) {
      setState(() {
        isSummited = false;
      });
      showProfileImageModal =
          ShowProfileImageModal.fromJson(jsonDecode(response.body));
      if (showProfileImageModal.data!.file!.contains(".jpg") |
      showProfileImageModal.data!.file!.contains(".png")) {
        url = showProfileImageModal.data!.path! +
            showProfileImageModal.data!.file!;
        SessionManager.setProfileImage(url);
        print(url);
      } else {
        url = showProfileImageModal.data!.file!;
        SessionManager.setProfileImage(url);

      }
    } else {}
  }


  Future<ShowProfileImageModal> getMyProfileInfo() async {
    final response = await http.post(Uri.parse(ApiNetwork.showprofile),
        body: {'user_id': SessionManager.getUserID()});
    if (response.statusCode == 200) {
      return ShowProfileImageModal.fromJson(jsonDecode(response.body));
    } else {
      return ShowProfileImageModal();
    }
  }

  void updatename() {
    if (NameController.text.isEmpty) {
      Helper.showSnackVar("Please Enter First Name", Colors.red, context);
      return;
    }
    Map<String, String> body = {
      "user_id": SessionManager.getUserID(),
      "username": NameController.text
    };

    Helper.showLoaderDialog(context, message: "Updating...");
    ApiHelper.updatedName(body).then((login) {
      Navigator.pop(context);
      if (login.message == 'Update Name Successfully') {
        SessionManager.setFirstName(NameController.text);
        Helper.showSnackVar('Successfully Login', Colors.green, context);
      } else {
        Helper.showSnackVar('Error', Colors.red, context);
      }
    });
  }

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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const EventCalendarScreen()));
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
                child: FutureBuilder<ShowProfileImageModal>(
                    future: getMyProfileInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      NameController.text = snapshot.data!.data!.username!;
                      emailController.text = snapshot.data!.data!.email!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: customtext(
                                fontWeight: FontWeight.w500,
                                text: "Update Profile",
                                fontsize: 20,
                                color: Theme.of(context).primaryColor,
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100)),
                            width: MediaQuery.of(context).size.width / 1.15,
                            height: MediaQuery.of(context).size.height / 4.2,
                            child: Stack(
                              children: [
                                isupdated == true
                                    ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                    : Center(
                                  child: Container(
                                    height: 160,
                                    width: 160,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        child: Image.network(
                                          url,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 95,
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return imagePickerOption();
                                          });
                                    },
                                    child: const CircleAvatar(
                                      radius: 23,
                                      backgroundColor: Color(0xffD9D9D9),
                                      child: Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: kBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          CustomTextField(
                              hintfont: 14,
                              lablefont: 18,
                              hight: 50,
                              title: "Afsar Khan",
                              controller: NameController,
                              hint: "Afsar Khan",
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
                              enable: false,
                              title: "AfsarKhan@gmail.c0m",
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
                              title: "Phone Number",
                              controller: PhoneNumberController,
                              hint: "Afsar Khan",
                              inputAction: TextInputAction.next,
                              inputType: TextInputType.text,
                              lableName: "Phone Number"),
                          SizedBox(height: 10),
                          // CustomNewEdit(
                          //     hight: 50,
                          //     title: "Phone Number",
                          //     controller: TextEditingController(),
                          //     hint: "hint",
                          //     inputAction: TextInputAction.next,
                          //     inputType: TextInputType.text,
                          //     lableName: "",
                          //     hintfont: 14,
                          //     lablefont: 18),
                          const SizedBox(
                            height: 30,
                          ),
                          custom_Button(
                            width: 200,
                            hight: 55,
                            onTap: () {
                              updatename();
                            },
                            title: "Submit",
                            fontSize: 20,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      );
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget imagePickerOption() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        color: Colors.white,
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.indigo,
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: () {
                  Navigator.pop(context);
                  pickImage1(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text(
                  "CAMERA",
                  style: TextStyle(fontSize: 16, fontFamily: "Montserrat"),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: () {
                  Navigator.pop(context);
                  pickImage1(ImageSource.gallery);
                },
                icon: const Icon(Icons.image),
                label: const Text(
                  "GALLERY",
                  style: TextStyle(fontSize: 16, fontFamily: "Montserrat"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickImage1(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      final tempImages = await _cropImage(pickedImage1: tempImage);
      // setState(() {
      //   pickedImage1 = tempImages;
      // });

      print('PATH ${pickedImage1!.path}');
      setState(() {});
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _cropImage({required File pickedImage1}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedImage1.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    // if(croppedImage == null){
    //
    // }
    //

    getUpdateProfile(File(croppedImage!.path).path);
    //return File(croppedImage!.path);
  }

  void getUpdateProfile(String path) async {
    Helper.showLoaderDialog(context, message: "Updating...");

    print("giuiush${path}");
    Uri uri = Uri.parse(ApiNetwork.updateprofile);
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll({"user_id": SessionManager.getUserID()});
    request.files.add(await http.MultipartFile.fromPath('file', path));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp = await response.stream.bytesToString();
      UpdateProfileImageModal updateProfileModal =
          UpdateProfileImageModal.fromJson(jsonDecode(resp));
      Navigator.pop(context);
      if (updateProfileModal.message == "Update Successfully") {
        getMyProfileInfo();
        SessionManager.setProfileImage(
            path! + showProfileImageModal.data!.file!);
        print(path! + showProfileImageModal.data!.file!);
        // setState((){
        //   url = updateProfileModal.path!+showProfileImageModal.data!.file!;
        // });
      } else {
        Helper.showSnackVar("Failed", Colors.red, context);
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}

class FlatCorneredBackgroundPainter extends CustomPainter {
  double radius, strokeWidth;
  Color strokeColor;

  FlatCorneredBackgroundPainter(
      {this.radius = 10, this.strokeWidth = 4, this.strokeColor = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = strokeColor;

    Path path = Path()
      ..addPolygon([
        Offset(radius, 0),
        Offset(w - radius, 0),
        Offset(w, radius),
        Offset(w, h - radius),
        Offset(w - radius, h),
        Offset(radius, h),
        Offset(0, h - radius),
        Offset(0, radius),
      ], true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
