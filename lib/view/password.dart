import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rider/view/rider_dahboard/dashboard.dart';

import '../config/palette.dart';
import '../dashboard/index.dart';
import '../resources/widgets/response.dart';

class password extends StatefulWidget {
  String mobile;
  password({required this.mobile, Key? key}) : super(key: key);
  @override
  State<password> createState() => _passwordState();
}

class _passwordState extends State<password> {
  final box = GetStorage();
  TextEditingController passwordController = new TextEditingController();

  bool passwordValid = true, isMainButtonEnabled = true;

  void loginAccount() async {
    // setState(() {
    //   isMainButtonEnabled = false;
    // });

    String mobile = widget.mobile, password = passwordController.text;

    var url = Uri.parse(Palette.baseUrl + Palette.loginUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'mobile_number': mobile,
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json"
        });

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData['error'].toString() == "null") {
        if (responseData['user']['user_type'] == 1 ||
            responseData['user']['user_type'] == 3 ||
            responseData['user']['user_type'] == 4) {
          ShowResponse("Cannot login", context);
        } else {
          saveStorage(responseData);
        }
      } else {}
    } else {
      ShowResponse("Invalid credentials", context);
    }

    // setState(() {
    //   isMainButtonEnabled = true;
    // });
  }

  void saveStorage(var data) {
    box.write('token', data['token']);
    box.write('firstName', data['user']['first_name']);
    box.write('lastName', data['user']['last_name']);
    box.write('mobileNumber', data['user']['mobile_number']);
    box.write('address', data['user']['address']);
    box.write('userId', data['user']['id']);
    if (data['user']['profile'].toString() == "null" ||
        data['user']['profile'].toString() == "") {
      box.write('userProfile', Palette.defaultImg);
    } else {
      box.write('userProfile', data['user']['profile'].toString());
    }
    if (data['user']['user_type'] == 2) {
      if (data['user']['cnic_number'].toString() == "null" ||
          data['user']['cnic_number'].toString() == "") {
        box.write('oldProfile', 0);
      } else {
        box.write('oldProfile', 4);
      }

      box.write('userType', 2);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => dashboard()),
          (Route<dynamic> route) => false);
    } else if (data['user']['user_type'] == 4) {
      box.write('oldProfile', 2);
      box.write('userType', 4);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RiderDashboard()),
          (Route<dynamic> route) => false);
    }

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => dashboard()),
    //     (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double bodyWidth = double.infinity;
    double bodyHeight = MediaQuery.of(context).size.height;
    loginAccount();
    // return Scaffold(
    //   body: Container(
    //     color: Palette.primaryColor.withOpacity(0.1),
    //     width: bodyWidth,
    //     height: bodyHeight,
    //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: <Widget>[
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             IconButton(
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //               icon: const Icon(
    //                 Icons.arrow_back_ios,
    //                 size: 20,
    //                 color: Colors.black,
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 const Text(
    //                   "One more step",
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.w600,
    //                       fontSize: 28,
    //                       color: Palette.primaryColor),
    //                 ),
    //                 // SizedBox(
    //                 //   width: 10,
    //                 // ),
    //               ],
    //             ),
    //             const SizedBox(
    //               height: 15,
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 Flexible(
    //                   child: const Text(
    //                     "Enter your password to login",
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.normal,
    //                         fontSize: 15,
    //                         color: Colors.black),
    //                   ),
    //                 ),
    //                 // SizedBox(
    //                 //   width: 10,
    //                 // ),
    //               ],
    //             ),
    //             const SizedBox(
    //               height: 5,
    //             ),
    //             Container(
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(10),
    //                 boxShadow: [
    //                   BoxShadow(
    //                       color: Color.fromRGBO(143, 148, 251, .2),
    //                       blurRadius: 20.0,
    //                       offset: Offset(0, 10))
    //                 ],
    //               ),
    //               child: Container(
    //                 padding:
    //                     EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 5),
    //                 child: TextField(
    //                   controller: passwordController,
    //                   obscureText: true,
    //                   decoration: InputDecoration(
    //                     border: InputBorder.none,
    //                     hintText: "Password",
    //                     hintStyle: TextStyle(color: Colors.grey[400]),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: 5,
    //             ),
    //             Container(
    //               child: AnimatedOpacity(
    //                 opacity: passwordValid ? 0 : 1,
    //                 duration: Duration(milliseconds: 200),
    //                 child: Text(
    //                   "Password must be 6 characters long",
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.w600,
    //                       fontSize: 12,
    //                       color: Colors.red),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: 5,
    //             ),
    //             GestureDetector(
    //               onTap: () {
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) => NewPassword(
    //                       mobile: widget.mobile,
    //                     ),
    //                   ),
    //                 );
    //               },
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   Flexible(
    //                     child: const Text(
    //                       "Forget Password?",
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.normal,
    //                           fontSize: 15,
    //                           color: Colors.black),
    //                     ),
    //                   ),
    //                   // SizedBox(
    //                   //   width: 10,
    //                   // ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //         Column(
    //           children: <Widget>[
    //             MaterialButton(
    //               minWidth: double.infinity,
    //               height: 60,
    //               color: Palette.primaryColor,
    //               disabledColor: Colors.grey,
    //               onPressed: isMainButtonEnabled
    //                   ? () {
    //                       String password = passwordController.text;

    //                       if (password.length < 6) {
    //                         setState(() {
    //                           passwordValid = false;
    //                         });
    //                       } else {
    //                         setState(() {
    //                           passwordValid = true;
    //                         });

    //                         loginAccount();
    //                       }
    //                     }
    //                   : null,
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(10)),
    //               child: const Text(
    //                 "Continue",
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.w400,
    //                     fontSize: 16,
    //                     color: Colors.white),
    //               ),
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
