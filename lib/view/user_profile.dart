import 'dart:convert';
import 'dart:io';
import '../config/palette.dart';
// import 'package:blockchain_ride_user/animation/animation.dart';

// import 'package:blockchain_ride_user/home/password.dart';
// import 'package:blockchain_ride_user/widget/custom-text-field-hint.dart';

// import 'package:blockchain_ride_user/widget/drawer-widget.dart';
// import 'package:blockchain_ride_user/widget/profile-upload.dart';
// import 'package:blockchain_ride_user/widget/response.dart';
// import 'package:blockchain_ride_user/widget/upload-widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

import '../resources/components/custom_text_field.dart';
import '../resources/components/custom_text_field_hint.dart';
import '../resources/widgets/drawer_widget.dart';
import '../resources/widgets/response.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final box = GetStorage();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController mobileNumberController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController activationCodeController = new TextEditingController();

  bool passwordValid = true, priceVisible = false;

  String firstName = "",
      lastName = "",
      mobile = "",
      userImg = "default.png",
      dob = "",
      status = "";

  bool isPaymentSelected = false, isMainButtonEnabled = true;
  bool nameValid = true,
      firstValid = true,
      lastValid = true,
      mobileValid = true,
      paswordValid = true,
      profileValid = true;

  File? _profile;

  Future _pickImage(ImageSource source, String receiver) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: source, requestFullMetadata: false);
      if (image == null) return;

      File? img = File(image.path);

      setState(() {
        if (receiver == "profile") {
          _profile = img;
        }
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void getUserDetails() async {
    var url = Uri.parse(Palette.baseUrl +
        Palette.getUserProfile +
        "?user_id=" +
        box.read('userId').toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var responseData = json.decode(response.body);

    firstNameController.text = responseData['user']['first_name'].toString();
    lastNameController.text =
        responseData['user']['last_name'].toString() == "null"
            ? ""
            : responseData['user']['last_name'].toString();
    mobileNumberController.text =
        "0" + responseData['user']['mobile_number'].toString();
    userImg = responseData['user']['profile'].toString() == "null"
        ? "default.png"
        : responseData['user']['profile'].toString();
    dob = responseData['user']['date_of_birth'].toString();
    status = responseData['user']['status'].toString();

    setState(() {});

    print(responseData);
  }

  void updateAccount() async {
    ShowResponse("Updating", context);
    setState(() {
      // isMainButtonEnabled = false;
    });

    String mobile = mobileNumberController.text;
    ;

    if (mobile.substring(0, 1) == "0") {
      mobile = mobile.substring(1);
    }

    var url = Uri.parse(Palette.baseUrl + Palette.updateUserUrl);

    var request = new http.MultipartRequest('POST', url);
    request.fields['user_id'] = box.read('userId').toString();
    request.fields['mobile_number'] = mobile;
    request.fields['status'] = status;
    request.fields['date_of_birth'] = dob;
    request.fields['first_name'] = firstNameController.text;
    if (lastNameController.text.isNotEmpty) {
      request.fields['last_name'] = lastNameController.text;
    }

    if (passwordController.text.isNotEmpty) {
      request.fields['password'] = passwordController.text;
    }

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + box.read('token'),
    };

    if (_profile != null) {
      var profile = await http.MultipartFile.fromPath(
          "profile", File(_profile!.path).path);

      request.files.add(profile);
    }

    request.headers.addAll(headers);

    var sendRequest = await request.send();
    var response = await http.Response.fromStream(sendRequest).then((value) {
      if (value.statusCode == 200) {
        ShowResponse("Updated", context);
      } else {
        ShowResponse("An error occured", context);
      }

      print(value.body);
    });

    setState(() {
      isMainButtonEnabled = true;
    });
  }

  void bottomSheet(String receiver) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, receiver);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/camera.png'),
                                fit: BoxFit.contain)),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Camera",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, receiver);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/gallery.png'),
                                fit: BoxFit.contain)),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Gallery",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    getUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bodyWidth = double.infinity;
    double bodyHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(
          scaffoldKey: _scaffoldKey,
          firstName: box.read('firstName'),
          mobileNumber: box.read('mobileNumber'),
          userProfile: box.read('userProfile'),
          pageName: "UserProfile"),
      body: Container(
        color: Palette.primaryColor.withOpacity(0.1),
        width: bodyWidth,
        height: bodyHeight,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25,
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/left-arrow.png'),
                                      fit: BoxFit.contain)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 150,
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 8, right: 5),
                            child: Text(
                              "Need dicsount code?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            "My Profile",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 28,
                                color: Palette.primaryColor),
                          ),
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: InkWell(
                            onTap: () {
                              bottomSheet("profile");
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: _profile == null
                                  ? FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/loading.gif',
                                      image: Palette.imgUrl + userImg,
                                      fit: BoxFit.cover,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 100,
                                      backgroundImage: Image.file(
                                        _profile!,
                                        fit: BoxFit.cover,
                                      ).image,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        label: "Enter your first name",
                        controller: firstNameController,
                        placeholder: "First name",
                        isValid: firstValid,
                        errorText: "Please enter valid first name"),
                    CustomTextField(
                        label: "Enter your last name",
                        controller: lastNameController,
                        placeholder: "Last name",
                        isValid: lastValid,
                        errorText: "Please enter valid last name"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            ShowResponse(
                                "Cannot update mobile number", context);
                          },
                          child: CustomTextFieldHint(
                            label: "Enter your mobile number",
                            controller: mobileNumberController,
                            placeholder: "Mobile number",
                            isValid: mobileValid,
                            errorText: "Enter valid mobile number",
                            hint: "This number will be used for login",
                            textType: TextInputType.phone,
                            enabled: false,
                          ),
                        ),
                        CustomTextFieldHint(
                          label: "Enter your discount code (optional)",
                          controller: activationCodeController,
                          placeholder: "Discount code",
                          isValid: mobileValid,
                          errorText: "Enter valid activation code",
                          hint: "Activation code is used for discounts",
                          enabled: true,
                        ),
                        // CustomTextFieldHint(
                        //   label: "Enter your referral code (optional)",
                        //   controller: activationCodeController,
                        //   placeholder: "Refferal code",
                        //   isValid: mobileValid,
                        //   errorText: "Enter valid referral code",
                        //   hint: "",
                        //   enabled: true,
                        // ),
                        Container(
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: Palette.primaryColor,
                            disabledColor: Colors.grey,
                            onPressed: isMainButtonEnabled
                                ? () {
                                    bool ready = true;

                                    if (firstNameController.text.isEmpty) {
                                      setState(() {
                                        firstValid = false;
                                      });
                                      ready = false;
                                    }
                                    if (lastNameController.text.isNotEmpty) {
                                      if (lastNameController.text.isEmpty) {
                                        setState(() {
                                          lastValid = false;
                                        });
                                        ready = false;
                                      }
                                    }

                                    if (mobileNumberController.text.length <
                                        11) {
                                      setState(() {
                                        mobileValid = false;
                                      });
                                      ready = false;
                                    }
                                    if (passwordController.text.isNotEmpty) {
                                      if (passwordController.text.length < 6) {
                                        setState(() {
                                          passwordValid = false;
                                        });
                                        ready = false;
                                      }
                                    }

                                    if (ready) {
                                      updateAccount();
                                    }
                                  }
                                : null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
