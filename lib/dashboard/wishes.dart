import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../config/palette.dart';

class Wishes extends StatefulWidget {
  String value;
  Wishes({required this.value, Key? key}) : super(key: key);
  @override
  State<Wishes> createState() => _WishesState();
}

class _WishesState extends State<Wishes> {
  TextEditingController priceController = new TextEditingController();

  String status = "";

  @override
  void initState() {
    super.initState();

    initController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initController() {
    if (widget.value != "Your wishes") {
      setState(() {
        priceController.text = widget.value.toString();
      });
    }
  }

  Future<bool> _willPopCallback() async {
    status = priceController.text.toString();
    if (status.isNotEmpty && status != "0") {
      Navigator.pop(context, status);
      return true;
    } else {
      status = "0";
      Navigator.pop(context, status);
      return true;
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double bodyWidth = MediaQuery.of(context).size.width;
    double bodyHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: Container(
          color: Palette.primaryColor.withOpacity(0.1),
          width: bodyWidth,
          height: bodyHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            padding: EdgeInsets.only(
                                top: 5, bottom: 3, left: 8, right: 5),
                            child: TextField(
                              controller: priceController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your wishses",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.comment,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      color: Palette.primaryColor,
                      onPressed: () {
                        _willPopCallback();
                      },
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
