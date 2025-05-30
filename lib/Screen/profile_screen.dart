import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
import 'package:smart_leader/Widget/custom_top_container.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSummited = true;
  bool isupdated = false;
  File? pickedImage1;

  late ShowProfileImageModal showProfileImageModal;
  late UpdateProfileImageModal updateProfileImageModal;

  String url = "";

  @override
  void initState() {
    super.initState();
    getMyProfileInfo();
  }

  Future<void> getMyProfileInfo() async {
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
        SessionManager.setProfileImage(path!+showProfileImageModal.data!.file!);
        print(path!+showProfileImageModal.data!.file!);
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                  child: isSummited == true
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
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
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 35,
                                ),
                                customtext(
                                  fontWeight: FontWeight.w400,
                                  text: showProfileImageModal.data!.username!,
                                  fontsize: 24,
                                  color: Theme.of(context).primaryColor,
                                ),
                                IconButton(
                                    onPressed: () {
                                      refreshDetails();
                                    },
                                    icon: Image(
                                      image: const AssetImage(
                                          "assest/png_icon/add_icon.png"),
                                      color: Theme.of(context).primaryColor,
                                      height: 18,
                                      width: 18,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Center(
                                child: customtext(
                              fontWeight: FontWeight.w400,
                              text: showProfileImageModal.data!.email!,
                              fontsize: 13,
                              color: Theme.of(context).primaryColor,
                            )),
                            const SizedBox(
                              height: 45,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: customtext(
                                      fontWeight: FontWeight.w400,
                                      text: "My Data",
                                      fontsize: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddFolderScreen()));
                                    },
                                    child: Card(
                                      color: SessionManager.getTheme() == true
                                          ? kscafolledColor
                                          : kWhiteColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  CustomRoundedBottun(
                                                      widget: Image(
                                                        image: const AssetImage(
                                                            "assest/png_icon/note_icon.png"),
                                                        color: SessionManager
                                                                    .getTheme() ==
                                                                true
                                                            ? kBlackColor
                                                            : kWhiteColor,
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                      height: 35,
                                                      width: 35,
                                                      ontap: () {}),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  customtext(
                                                    fontWeight: FontWeight.w400,
                                                    text: "My Notes",
                                                    fontsize: 18,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                            CustomRoundedBottun(
                                                widget: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: SessionManager
                                                              .getTheme() ==
                                                          true
                                                      ? kBlackColor
                                                      : kWhiteColor,
                                                  size: 20,
                                                ),
                                                height: 35,
                                                width: 35,
                                                ontap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddFolderScreen()));
                                                })
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddMyTaskScreen()));
                                    },
                                    child: Card(
                                      color: SessionManager.getTheme() == true
                                          ? kscafolledColor
                                          : kWhiteColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  CustomRoundedBottun(
                                                      widget: Image(
                                                        image: const AssetImage(
                                                            "assest/png_icon/maytask_icon.png"),
                                                        height: 20,
                                                        width: 20,
                                                        color: SessionManager
                                                                    .getTheme() ==
                                                                true
                                                            ? kBlackColor
                                                            : kWhiteColor,
                                                      ),
                                                      height: 35,
                                                      width: 35,
                                                      ontap: () {}),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  customtext(
                                                    fontWeight: FontWeight.w400,
                                                    text: "My Task",
                                                    fontsize: 18,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                            CustomRoundedBottun(
                                                widget: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: SessionManager
                                                              .getTheme() ==
                                                          true
                                                      ? kBlackColor
                                                      : kWhiteColor,
                                                  size: 20,
                                                ),
                                                height: 35,
                                                width: 35,
                                                ontap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddMyTaskScreen()));
                                                })
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ))),
        ],
      ),
    );
  }

  void refreshDetails() {
    final result = Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ManageProfileScreen()));
    result.then((value) {
      if (value == true) {
        getMyProfileInfo();
      }
    });
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
}

//
// pickedImage1 != null
// ? ClipRRect(
// borderRadius:
// BorderRadius.circular(100),
// child: Image.file(
// pickedImage1!,
// fit: BoxFit.fill,
// ))
