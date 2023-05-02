import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../config/palette.dart';
import '../dashboard/index.dart';

class register extends StatefulWidget {
  String mobile;
  register({required this.mobile, Key? key}) : super(key: key);
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final box = GetStorage();
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController referenceController = new TextEditingController();
  TextEditingController discountController = new TextEditingController();

  bool passwordValid = true, nameValid = true, isMainButtonEnabled = true;

  void registerAccount() async {
    setState(() {
      isMainButtonEnabled = false;
    });

    String mobile = widget.mobile,
        name = nameController.text,
        password = passwordController.text;

    var url = Uri.parse(Palette.baseUrl + Palette.registerUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'mobile_number': mobile,
          'first_name': name,
          'user_type': 2,
          'date_of_birth': '1970-12-01',
          'status': 1,
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json"
        });

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      saveStorage(responseData);
    }

    setState(() {
      isMainButtonEnabled = true;
    });

    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => dashboard(id: 1)));
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

    box.write('oldProfile', 0);
    box.write('userType', 2);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => dashboard()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double bodyWidth = double.infinity;
    double bodyHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "Create new account",
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: const Text(
                          "Enter your name",
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
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ],
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 5),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: AnimatedOpacity(
                      opacity: nameValid ? 0 : 1,
                      duration: Duration(milliseconds: 200),
                      child: Text(
                        "Please enter valid name",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Flexible(
                  //       child: const Text(
                  //         "Enter new password",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.normal,
                  //             fontSize: 15,
                  //             color: Colors.black),
                  //       ),
                  //     ),
                  //     // SizedBox(
                  //     //   width: 10,
                  //     // ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //     boxShadow: [
                  //       BoxShadow(
                  //           color: Color.fromRGBO(143, 148, 251, .2),
                  //           blurRadius: 20.0,
                  //           offset: Offset(0, 10))
                  //     ],
                  //   ),
                  //   child: Container(
                  //     padding:
                  //         EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 5),
                  //     child: TextField(
                  //       controller: passwordController,
                  //       obscureText: true,
                  //       decoration: InputDecoration(
                  //         border: InputBorder.none,
                  //         hintText: "Password",
                  //         hintStyle: TextStyle(color: Colors.grey[400]),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Container(
                  //   child: AnimatedOpacity(
                  //     opacity: passwordValid ? 0 : 1,
                  //     duration: Duration(milliseconds: 200),
                  //     child: Text(
                  //       "Password must be 6 characters long",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 12,
                  //           color: Colors.red),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: const Text(
                          "Enter reference code (Optional)",
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
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ],
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 5),
                      child: TextField(
                        controller: referenceController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Reference code",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: const Text(
                          "Enter discount code (Optional)",
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
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ],
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 5),
                      child: TextField(
                        controller: discountController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Discount code",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
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
                            String password = passwordController.text;
                            String name = nameController.text;
                            if (name.isEmpty) {
                              setState(() {
                                nameValid = false;
                              });
                            }
                            // else if (password.length < 6) {
                            //   setState(() {
                            //     passwordValid = false;
                            //     nameValid = true;
                            //   });
                            // }
                            else {
                              setState(() {
                                // passwordValid = true;
                                nameValid = true;
                              });
                              registerAccount();
                            }
                          }
                        : null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "Create account",
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
