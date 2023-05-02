import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rider/view/password.dart';
import 'package:rider/view/register.dart';

import '../config/palette.dart';
import '../resources/widgets/response.dart';
import '../utils/route/routes_name.dart';

class otp extends StatefulWidget {
  String mobile, countryCode;
  bool isNew;
  otp(
      {required this.mobile,
      required this.countryCode,
      required this.isNew,
      Key? key})
      : super(key: key);
  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  TextEditingController otp1 = new TextEditingController();
  TextEditingController otp2 = new TextEditingController();
  TextEditingController otp3 = new TextEditingController();
  TextEditingController otp4 = new TextEditingController();
  TextEditingController otp5 = new TextEditingController();
  TextEditingController otp6 = new TextEditingController();

  bool resentEnabled = false, otpValid = true, otpBtnEnabled = true;

  late Timer _timer;

  int start = 59;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            _timer.cancel();
            resentEnabled = true;
          });
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }

  late String verId;

  // void checkOtp() async {
  //   String otpCode =
  //       otp1.text + otp2.text + otp3.text + otp4.text + otp5.text + otp6.text;

  //   PhoneAuthCredential credential =
  //       PhoneAuthProvider.credential(verificationId: verId, smsCode: otpCode);
  //   try {
  //     await FirebaseAuth.instance.signInWithCredential(credential);

  //     if (widget.isNew) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => password(
  //             mobile: widget.mobile,
  //           ),
  //         ),
  //       );
  //     } else {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => register(
  //             mobile: widget.mobile,
  //           ),
  //         ),
  //       );
  //     }

  //     ShowResponse("Mobile number verified", context);
  //   } on FirebaseAuthException catch (e) {
  //     ShowResponse("Invalid OTP", context);
  //     setState(() {
  //       otpValid = false;
  //       otpBtnEnabled = true;
  //     });
  //   }
  // }

  // void checkOtp() {
  //   if (widget.isNew) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => password(
  //           mobile: widget.mobile,
  //         ),
  //       ),
  //     );
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => register(
  //           mobile: widget.mobile,
  //         ),
  //       ),
  //     );
  //   }
  // }

  // void sendOtp() async {
  //   print("otp");
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: widget.countryCode + widget.mobile,
  //     verificationCompleted: (PhoneAuthCredential credential) {},
  //     verificationFailed: (FirebaseAuthException e) {},
  //     codeSent: (String verificationId, int? resendToken) {
  //       ShowResponse("OTP sent", context);
  //       verId = verificationId;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       setState(() {
  //         verId = verificationId;
  //       });
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    startTimer();
    // sendOtp();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bodyWidth = double.infinity;
    double bodyHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                    const Text(
                      "Verification code",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: const Text(
                        "We have sent verification code to",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        "${widget.countryCode}${widget.mobile}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Change mobile number?",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Palette.primaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 50,
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
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 8, right: 5),
                          child: TextField(
                            controller: otp1,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            autofocus: true,
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty) {
                                // FocusScope.of(context).previousFocus();
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
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
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 8, right: 5),
                          child: TextField(
                            controller: otp2,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
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
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 8, right: 5),
                          child: TextField(
                            controller: otp3,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
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
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 8, right: 5),
                          child: TextField(
                            controller: otp4,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
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
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 8, right: 5),
                          child: TextField(
                            controller: otp5,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
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
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 8, right: 5),
                          child: TextField(
                            controller: otp6,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              if (value.length == 1) {
                                // FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Resend code in 00:" + "$start",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: AnimatedOpacity(
                        opacity: otpValid ? 0 : 1,
                        duration: Duration(milliseconds: 200),
                        child: Text(
                          "Please enter valid OTP",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        disabledColor: Colors.grey,
                        color: Palette.primaryColor,
                        onPressed: resentEnabled
                            ? () {
                                // sendOtp();
                                setState(() {
                                  startTimer();
                                  start = 59;
                                  resentEnabled = false;
                                });
                              }
                            : null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Resend",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                      flex: 3,
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        disabledColor: Colors.grey,
                        color: Palette.primaryColor,
                        onPressed: otpBtnEnabled
                            ? () {
                                setState(() {
                                  otpValid = true;
                                  otpBtnEnabled = true;
                                });
                                // checkOtp();
                                Navigator.pushNamed(
                                    context, RoutesName.dashboardScreen);
                              }
                            : null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Verify",
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
            )
          ],
        ),
      ),
    );
  }
}
