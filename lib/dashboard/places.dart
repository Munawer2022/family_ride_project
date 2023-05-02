import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../config/palette.dart';

class places extends StatefulWidget {
  String location, value;
  places({required this.location, required this.value, Key? key})
      : super(key: key);
  @override
  State<places> createState() => _placesState();
}

class _placesState extends State<places> {
  TextEditingController searchController = new TextEditingController();

  var uuid = Uuid();

  String isLocationEnabled = "1", sessionToken = "123", status = "";

  List<dynamic> placesList = [];

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      onChange();
    });

    initController();
  }

  void initController() {
    if (widget.value != "Pickup location" &&
        widget.value != "Drop off location") {
      setState(() {
        searchController.text = widget.value;
      });
    }
  }

  void onChange() {
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }

    getSuggestion(searchController.text);
  }

  void getSuggestion(String text) async {
    String googleAPI = "AIzaSyBu9KtvU5R8rMK1gSqnoHshugw5ogWxj0s";
    String baseURL =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =
        '$baseURL?input=$text&key=$googleAPI&components=country:pk&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      print("rin");
      print(response.body.toString());
      setState(() {
        placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('failed');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    if (status == "") {
      Navigator.pop(context, widget.value);
      return true;
    } else {
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
        key: _scaffoldKey,
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
                                controller: searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search ${widget.location}",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.my_location_rounded,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: placesList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        status =
                                            placesList[index]['description'];
                                        _willPopCallback();
                                      },
                                      child: ListTile(
                                        title: Text(
                                            placesList[index]['description']),
                                      ),
                                    ),
                                    Divider()
                                  ],
                                );
                              },
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
      ),
    );
  }
}
