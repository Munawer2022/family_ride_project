import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;

import '../config/palette.dart';
import 'otp.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
        body: Container(
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
                        "Welcome To\nFamily Ride",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                            color: Palette.primaryColor),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: const Text(
                          "Enter your mobile number to continue",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .5),
                              blurRadius: 10.0,
                              offset: Offset(1, 1))
                        ]),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: IntlPhoneField(
                        initialCountryCode: 'PK',
                        disableLengthCheck: true,
                        autofocus: true,
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Mobile number",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        onChanged: (value) {
                          countryCode = value.countryCode;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: AnimatedOpacity(
                      opacity: mobileValid ? 0 : 1,
                      duration: Duration(milliseconds: 200),
                      child: Text(
                        "Please enter valid mobile number",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    color: Palette.primaryColor,
                    disabledColor: Colors.grey,
                    onPressed: isMainButtonEnabled
                        ? () {
                            String mobile = mobileController.text;

                            if (mobile.length < 10) {
                              setState(() {
                                mobileValid = false;
                              });
                            } else {
                              setState(() {
                                mobileValid = true;
                              });
                              if (mobile.substring(0, 1) == "0") {
                                mobile = mobile.substring(1);
                              }

                              // mobile = countryCode + mobile;
                              setState(() {
                                isMainButtonEnabled = false;
                              });
                              checkNumberR(mobile);
                            }
                          }
                        : null,
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
    );
  }
}
