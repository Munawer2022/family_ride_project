import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:rider/resources/components/custom_text_field.dart';

import '../config/palette.dart';
import '../resources/components/appbar.dart';
import '../utils/route/routes_name.dart';
import 'otp.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final box = GetStorage();
  TextEditingController mobileController = new TextEditingController();

  bool mobileValid = true, isMainButtonEnabled = true;

  String countryCode = "+92";

  void checkNumberR(String mobile) async {
    // ShowResponse(mobile, context);
    var url = Uri.parse(
        Palette.baseUrl + Palette.checkMobile + "?mobile_number=" + mobile);
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
    });
    var responseData = json.decode(response.body);

    print(responseData);
    check(responseData['status'], mobile);
  }

  void check(bool data, String mobile) {
    setState(() {
      isMainButtonEnabled = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => otp(
          mobile: mobile,
          countryCode: countryCode,
          isNew: data,
        ),
      ),
    );
    // if (mobile == "3112616413") {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => password(
    //         mobile: mobile,
    //       ),
    //     ),
    //   );
    // } else {

    // }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bodyWidth = double.infinity;
    double bodyHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MyAppBarWidget(
          ontap: [
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.loginScreen);
                },
                child: const Text('Logout'))
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: '',
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Palette.primaryColor.withOpacity(0.1),
            width: bodyWidth,
            height: bodyHeight,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 28,
                              color: Palette.primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // Container(
                    //   child: AnimatedOpacity(
                    //     opacity: mobileValid ? 0 : 1,
                    //     duration: Duration(milliseconds: 200),
                    //     child: Text(
                    //       "Please enter valid mobile number",
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 12,
                    //           color: Colors.red),
                    //     ),
                    //   ),
                    // ),
                    CustomTextField(
                        label: 'Email',
                        controller: mobileController,
                        placeholder: 'Email',
                        isValid: false,
                        errorText: 'Enter You Valid Email'),
                    CustomTextField(
                        label: 'Name',
                        controller: mobileController,
                        placeholder: 'Name',
                        isValid: false,
                        errorText: 'Enter You Valid Name'),
                    CustomTextField(
                        label: 'Referral Code',
                        controller: mobileController,
                        placeholder: 'Referral Code',
                        isValid: false,
                        errorText: 'Enter You Valid Referral Code'),
                    CustomTextField(
                        label: 'Activation Code',
                        controller: mobileController,
                        placeholder: 'Activation Code',
                        isValid: false,
                        errorText: 'Enter You Valid Activation Code'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      color: Palette.primaryColor,
                      disabledColor: Colors.grey,
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:rider/resources/padding.dart';
// import 'package:rider/resources/components/text_field.dart';

// import '../resources/components/appbar.dart';
// import '../resources/images.dart';
// import '../utils/route/routes_name.dart';

// class Profile extends StatelessWidget {
//   const Profile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var size = MediaQuery.of(context).size;
//     return SafeArea(
//         child: Scaffold(
//       appBar: MyAppBarWidget(
//         title: '',
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back_ios)),

//         // title: Image.asset(
//         //   profilescreen_familyImage,
//         //   scale: 15,
//         // ),
//         ontap: [
//           TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, RoutesName.loginScreen);
//               },
//               child: const Text('Logout'))
//         ],
//       ),
//       // appBar: appBar(
//       //     Image.asset(
//       //       profilescreen_familyImage,
//       //       scale: 15,
//       //     ),
//       //     [
//       //       TextButton(
//       //           onPressed: () {
//       //             Navigator.pushNamed(context, RoutesName.loginScreen);
//       //           },
//       //           child: const Text('Logout'))
//       //     ],
//       //     true),
//       body: Padding(
//         padding: screenPadding,
//         //copyWith(left: 30.0, right: 30.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 profilescreen_familyImage,
//                 scale: 5,
//               ),
//               SizedBox(
//                 height: size.height * 0.07,
//               ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Profile',
//                   style: theme.textTheme.headline4?.copyWith(
//                       color: Colors.black, fontWeight: FontWeight.w800),
//                 ),
//               ),
//               SizedBox(
//                 height: size.height * 0.02,
//               ),
//               const TextFieldComponent(
//                   icon: Icon(Icons.person_rounded),
//                   validator: null,
//                   controller: null,
//                   keyboardType: TextInputType.text,
//                   hintText: 'Name'),
//               SizedBox(
//                 height: size.height * 0.02,
//               ),
//               const TextFieldComponent(
//                   icon: Icon(Icons.alternate_email),
//                   validator: null,
//                   controller: null,
//                   keyboardType: TextInputType.emailAddress,
//                   hintText: 'Email'),
//               SizedBox(
//                 height: size.height * 0.02,
//               ),
//               const TextFieldComponent(
//                   icon: Icon(Icons.pin),
//                   validator: null,
//                   controller: null,
//                   keyboardType: TextInputType.number,
//                   hintText: 'Activation Code'),
//               SizedBox(
//                 height: size.height * 0.02,
//               ),
//               const TextFieldComponent(
//                   icon: Icon(Icons.pin),
//                   validator: null,
//                   controller: null,
//                   keyboardType: TextInputType.number,
//                   hintText: 'Referral Code'),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }
