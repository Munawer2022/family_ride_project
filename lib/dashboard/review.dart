import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

import '../config/palette.dart';
import '../resources/widgets/drawer_widget.dart';
import '../resources/widgets/response.dart';

class ReviewPage extends StatefulWidget {
  int rideId;
  ReviewPage({required this.rideId, Key? key}) : super(key: key);
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  TextEditingController reviewController = TextEditingController();

  double stars = 0;

  void submitReview() async {
    ShowResponse("Please wait", context);
    var url = Uri.parse(Palette.baseUrl + Palette.endRideUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'ride_id': widget.rideId.toString(),
          'review': reviewController.text,
          'rating_stars': stars.toString(),
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });
    var responseData = json.decode(response.body);

    print(responseData);
    Navigator.pop(context);
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
          pageName: "review"),
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
              top: 100,
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
                                  image: AssetImage('assets/images/star.png'),
                                  fit: BoxFit.contain)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Please review the ride",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RatingBar.builder(
                        initialRating: 3,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                            default:
                              return Container();
                          }
                        },
                        onRatingUpdate: (rating) {
                          stars = rating;
                        },
                        updateOnDrag: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: TextField(
                          controller: reviewController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Write your review',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        height: 60,
                        color: Palette.primaryColor,
                        onPressed: () {
                          if (reviewController.text.isEmpty) {
                            ShowResponse(
                                "Please enter atleast 1 word review", context);
                          } else {
                            submitReview();
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: bodyWidth / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.star_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Submit",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.white),
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
                        color: Colors.grey.shade300,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: bodyWidth / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Skip",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.black),
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
