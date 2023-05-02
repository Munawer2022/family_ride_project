import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:rider/view/rider_dahboard/rider_screen_rider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;

import '../../config/palette.dart';
import '../../resources/widgets/drawer_widget.dart';
import '../../rider/check_rider.dart';

class RiderDashboard extends StatefulWidget {
  RiderDashboard({Key? key}) : super(key: key);
  @override
  State<RiderDashboard> createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard> {
  final box = GetStorage();
  TextEditingController pickController = new TextEditingController();
  TextEditingController dropController = new TextEditingController();

  bool online = false, accountActivated = false;
  int riderStatus = 0;

  String message = "Account activated",
      total = "70",
      feePrice = "",
      isLocationEnabled = "1";

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

    if (responseData['user']['vehicle_type'] == 1) {
      feePrice = "2000";
    } else if (responseData['user']['vehicle_type'] == 2) {
      feePrice = "3000";
    } else if (responseData['user']['vehicle_type'] == 3) {
      feePrice = "4000";
    }

    if (responseData['user']['status'] == 1) {
      accountActivated = true;
    } else {
      accountActivated = false;
    }

    setState(() {});

    // print(responseData);
    checkEarning();
    runOffersTimer();
    runRideTimer();
  }

  Future<List<Items>> getAllOffers() async {
    var url = Uri.parse(Palette.baseUrl +
        Palette.getAllOffersUrl +
        "?user_id=" +
        box.read('userId').toString());
    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var JsonData = json.decode(response.body);

    final List<Items> rows = [];

    for (var u in JsonData) {
      Items item = Items(
        u["id"],
        u["offer_price"],
        u["user_name"],
        u["pickup_location"],
        u["pickup_latitude"],
        u["pickup_longitude"],
        u["drop_off_location"],
        u["drop_off_latitude"],
        u["drop_off_longitude"],
        u["vehicle_type"],
        u["distance"],
      );
      rows.add(item);
    }

    return rows;
  }

  void checkDialog() {
    Dialogs.materialDialog(
        color: Colors.white,
        msg:
            "Family Ride needs location permission to enable location sharing between customer and rider/driver. This enables us to provide you our best services.\n\nDo you want to enable location service?",
        title: "Permission",
        context: context,
        barrierDismissible: false,
        actions: [
          IconsButton(
            onPressed: () async {
              Navigator.pop(context);
              locationPermission();
            },
            text: "Yes",
            iconData: Icons.done,
            color: Palette.primaryColor,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: () {
              Navigator.pop(context);
              isLocationEnabled = "0";
              setState(() {});
            },
            text: "No",
            iconData: Icons.cancel,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  void checkPermission() async {
    var isPermission = await Permission.location.status;

    if (isPermission.isGranted) {
      print("granted");
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          currentLocation();
        });
      });
    } else {
      checkDialog();
    }
  }

  void locationPermission() async {
    print("gettting location");
    var status = await Permission.location.request();
    if (status.isDenied) {
      isLocationEnabled = "2";
    } else if (status.isRestricted || status.isPermanentlyDenied) {
      isLocationEnabled = "0";
    } else if (status.isGranted) {
      isLocationEnabled = "1";
      // ShowResponse("location run", context);

      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          currentLocation();
        });
      });
    }

    setState(() {});
  }

  Future<Position> getUserCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  void currentLocation() {
    getUserCurrentLocation().then(
      (value) async {
        updateUserState(value.latitude, value.longitude);
      },
    );
  }

  Timer? updateRiderLocation, offersTimers, isRideIntiatedTimer;

  void runOffersTimer() {
    offersTimers = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {});
    });
  }

  void runRideTimer() {
    isRideIntiatedTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      rideInitiated();
    });
  }

  void rideInitiated() async {
    var url = Uri.parse(Palette.baseUrl +
        Palette.isRideInitiated +
        "?rider_id=" +
        box.read('userId').toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var responseData = json.decode(response.body);
    if (responseData['ride_accepted'] == true) {
      int rideId = responseData['ride_id']['id'];

      isRideIntiatedTimer?.cancel();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => RideScreenRider(
                    rideId: rideId,
                  )),
          (Route<dynamic> route) => false);
    }
  }

  void updateUserState(double lat, double lng) async {
    var url = Uri.parse(Palette.baseUrl + Palette.userStateUpdateUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'user_id': box.read('userId').toString(),
          'current_location': "Rider location",
          'current_latitude': lat.toString(),
          'current_longitude': lng.toString(),
          'status': "0",
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });
    var responseData = json.decode(response.body);
    // print(responseData);

    // updateRiderLocation = Timer.periodic(Duration(seconds: 10), (timer) {
    //   currentLocation();
    // });
  }

  String doneRide = "0", totalEarning = "0";

  void checkEarning() async {
    var url = Uri.parse(Palette.baseUrl +
        Palette.checkEarningUrl +
        "?rider_id=" +
        box.read('userId').toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var responseData = json.decode(response.body);

    doneRide = responseData['rides_count'].toString();
    totalEarning = responseData['fare_sum'].toString();

    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    rideInitiated();
    getUserDetails();

    checkPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bodyWidth = MediaQuery.of(context).size.width;
    double bodyHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Rider Panel"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu)),
      ),
      drawer: DrawerWidget(
          scaffoldKey: _scaffoldKey,
          firstName: box.read('firstName') + " (Rider)",
          mobileNumber: box.read('mobileNumber'),
          userProfile: box.read('userProfile'),
          pageName: "RiderDashboard"),
      body: Column(
        children: [
          isLocationEnabled == "1"
              ? Container(
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: Container(
                                  height: 70,
                                  width: bodyWidth - 20,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  accountActivated
                                                      ? message
                                                      : "Your account is \nnot activated",
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "Earning: PKR $totalEarning",
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Avaialable rides: $doneRide/$total",
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                                accountActivated
                                                    ? Row(
                                                        children: [
                                                          AvatarGlow(
                                                              glowColor:
                                                                  Colors.green,
                                                              endRadius: 20.0,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      2000),
                                                              repeat: true,
                                                              showTwoGlows:
                                                                  true,
                                                              repeatPauseDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          100),
                                                              child: Container(
                                                                width: 15,
                                                                height: 15,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    shape: BoxShape
                                                                        .circle),
                                                              )),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          AvatarGlow(
                                                              glowColor:
                                                                  Colors.red,
                                                              endRadius: 20.0,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      2000),
                                                              repeat: true,
                                                              showTwoGlows:
                                                                  true,
                                                              repeatPauseDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          100),
                                                              child: Container(
                                                                width: 15,
                                                                height: 15,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    shape: BoxShape
                                                                        .circle),
                                                              )),
                                                        ],
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
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ToggleSwitch(
                                    minWidth: bodyWidth,
                                    minHeight: 60,
                                    animate: true,
                                    animationDuration: 300,
                                    initialLabelIndex: riderStatus,
                                    cornerRadius: 20.0,
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.grey,
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    labels: ['Offline', 'I am available'],
                                    icons: [FontAwesomeIcons.powerOff, null],
                                    activeBgColors: [
                                      [Colors.red],
                                      [Palette.primaryColor]
                                    ],
                                    onToggle: (index) {
                                      if (index == 0) {
                                        setState(() {
                                          online = false;
                                          riderStatus = 0;
                                        });
                                      } else {
                                        // ShowResponse(
                                        //     "Cannot get offers without paying fee",
                                        //     context);
                                        checkPermission();
                                        setState(() {
                                          online = true;
                                          riderStatus = 1;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "New Offers",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              online
                                  ? Visibility(
                                      visible: accountActivated,
                                      child: FutureBuilder(
                                        future: getAllOffers(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.data == null) {
                                            return Container(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: Palette.primaryColor,
                                              )),
                                            );
                                          } else if (snapshot.data.length ==
                                              0) {
                                            return Center(
                                              child: Text(
                                                "No offers",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            );
                                          } else {
                                            return ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: snapshot.data.length,
                                              itemBuilder:
                                                  (BuildContext, index) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 10),
                                                  child: Container(
                                                    width: bodyWidth - 10,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          offset: Offset(0, 2),
                                                          blurRadius: 6.0,
                                                        ),
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  right: 15,
                                                                  left: 15,
                                                                  bottom: 0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        "assets/images/a.png"),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .pick_up_location,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  right: 15,
                                                                  left: 15,
                                                                  bottom: 0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        "assets/images/b.png"),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .drop_off_location,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  right: 15,
                                                                  left: 15,
                                                                  bottom: 0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Text(
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        "Customer: " +
                                                                            snapshot.data[index].user_name,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            "Distance " +
                                                                                snapshot.data[index].distance.toStringAsFixed(2) +
                                                                                " KM",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w800,
                                                                                fontSize: 14,
                                                                                color: Colors.black),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            "Offered price: PKR " +
                                                                                snapshot.data[index].offer_price.toString(),
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w800,
                                                                                fontSize: 14,
                                                                                color: Palette.primaryColor),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10,
                                                                  left: 10,
                                                                  right: 10,
                                                                  bottom: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              // MaterialButton(
                                                              //   minWidth: 60,
                                                              //   height: 40,
                                                              //   color: Colors.red,
                                                              //   onPressed: () {},
                                                              //   shape: RoundedRectangleBorder(
                                                              //       borderRadius:
                                                              //           BorderRadius
                                                              //               .circular(
                                                              //                   10)),
                                                              //   child: const Text(
                                                              //     "Skip",
                                                              //     style: TextStyle(
                                                              //         fontWeight:
                                                              //             FontWeight
                                                              //                 .w400,
                                                              //         fontSize:
                                                              //             16,
                                                              //         color: Colors
                                                              //             .black),
                                                              //   ),
                                                              // ),

                                                              MaterialButton(
                                                                minWidth: 60,
                                                                height: 40,
                                                                color: Palette
                                                                    .primaryColor,
                                                                onPressed:
                                                                    () async {
                                                                  // status = 1;
                                                                  // goback();
                                                                  offersTimers
                                                                      ?.cancel();
                                                                  final routeResponse =
                                                                      await Navigator
                                                                          .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              checkRide(
                                                                        id: snapshot
                                                                            .data[index]
                                                                            .id,
                                                                        lat: double.parse(snapshot
                                                                            .data[index]
                                                                            .pickup_latitude),
                                                                        lng: double.parse(snapshot
                                                                            .data[index]
                                                                            .pickup_longitude),
                                                                        lat2: double.parse(snapshot
                                                                            .data[index]
                                                                            .drop_off_latitude),
                                                                        lng2: double.parse(snapshot
                                                                            .data[index]
                                                                            .drop_off_longitude),
                                                                        distance: snapshot
                                                                            .data[index]
                                                                            .distance
                                                                            .toStringAsFixed(2),
                                                                        pick: snapshot
                                                                            .data[index]
                                                                            .pick_up_location
                                                                            .toString(),
                                                                        drop: snapshot
                                                                            .data[index]
                                                                            .drop_off_location
                                                                            .toString(),
                                                                        price: snapshot
                                                                            .data[index]
                                                                            .offer_price
                                                                            .toString(),
                                                                        currency:
                                                                            "PKR",
                                                                        paymentMothod:
                                                                            "Cash",
                                                                      ),
                                                                    ),
                                                                  );
                                                                  runOffersTimer();
                                                                },
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child:
                                                                    const Text(
                                                                  "Open",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            "No Offers",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Stay online for new offers",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ))),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 10),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      color: Palette.primaryColor,
                      onPressed: () async {
                        checkPermission();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Enable location",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
        ],
      ),
      // floatingActionButton: InkWell(
      //   onTap: () async {
      //     final routeResponse = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => PayFee(feePrice: feePrice),
      //       ),
      //     );
      //     // setState(() {
      //     //   riderStatus = 1;
      //     //   accountActivated = true;
      //     //   message = "Account Activated";
      //     //   total = "70";
      //     // });
      //   },
      //   child: new Container(
      //     child: Visibility(
      //       visible: true,
      //       child: Container(
      //         padding: const EdgeInsets.symmetric(
      //           vertical: 8.0,
      //           horizontal: 12.0,
      //         ),
      //         decoration: BoxDecoration(
      //           color: Palette.primaryColor,
      //           borderRadius: BorderRadius.circular(10.0),
      //           boxShadow: const [
      //             BoxShadow(
      //               color: Colors.black26,
      //               offset: Offset(0, 2),
      //               blurRadius: 6.0,
      //             )
      //           ],
      //         ),
      //         child: Text(
      //           "Pay Rs $feePrice to activate your account",
      //           style: const TextStyle(
      //               fontSize: 14.0,
      //               fontWeight: FontWeight.w600,
      //               color: Colors.white),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}

class Items {
  final int id;
  final int offer_price;
  final String user_name;
  final String pick_up_location;
  final String pickup_latitude;
  final String pickup_longitude;
  final String drop_off_location;
  final String drop_off_latitude;
  final String drop_off_longitude;
  final int vehicle_type;
  final double distance;
  Items(
    this.id,
    this.offer_price,
    this.user_name,
    this.pick_up_location,
    this.pickup_latitude,
    this.pickup_longitude,
    this.drop_off_location,
    this.drop_off_latitude,
    this.drop_off_longitude,
    this.vehicle_type,
    this.distance,
  );
}
