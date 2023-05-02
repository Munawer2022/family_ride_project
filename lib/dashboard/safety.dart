import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

import '../config/palette.dart';
import '../resources/widgets/drawer_widget.dart';

class safetyPage extends StatefulWidget {
  int id;
  safetyPage({required this.id, Key? key}) : super(key: key);
  @override
  State<safetyPage> createState() => _safetyPageState();
}

class _safetyPageState extends State<safetyPage> {
  final box = GetStorage();
  String number1 = "+923002486212", number2 = "+923412427708";

  void launchCaller(String number) async {
    final url = "tel:" + number;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double bodyWidth = MediaQuery.of(context).size.width;
    double bodyHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(
          scaffoldKey: _scaffoldKey,
          firstName: box.read('firstName'),
          mobileNumber: box.read('mobileNumber'),
          userProfile: box.read('userProfile'),
          pageName: "safety"),
      body: Container(
        color: Palette.primaryColor.withOpacity(0.1),
        width: bodyWidth,
        height: bodyHeight,
        child: Stack(
          children: [
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/menu.png'),
                            fit: BoxFit.contain)),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200,
              child: Container(
                width: bodyWidth,
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Palette.primaryColor.withOpacity(0.3),
                        radius: 50,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/shield.png'),
                                  fit: BoxFit.contain)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "24/7 Online support",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        height: 60,
                        color: Palette.primaryColor,
                        onPressed: () {
                          launchCaller(number1);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: bodyWidth / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      launchCaller(number1);
                                    },
                                    icon: const Icon(
                                      Icons.phone,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    number1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        height: 60,
                        color: Palette.primaryColor,
                        onPressed: () {
                          launchCaller(number2);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: bodyWidth / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.phone,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    number2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      launchCaller(number2);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
