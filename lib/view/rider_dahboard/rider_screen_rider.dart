import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../chat.dart';
import '../../config/palette.dart';
import '../../dashboard/safety.dart';
import '../../resources/widgets/response.dart';
import 'dashboard.dart';

class RideScreenRider extends StatefulWidget {
  int rideId;
  RideScreenRider({required this.rideId, Key? key}) : super(key: key);
  @override
  State<RideScreenRider> createState() => _RideScreenRiderState();
}

class _RideScreenRiderState extends State<RideScreenRider> {
  final box = GetStorage();
  late GoogleMapController _googleMapController;
  Marker? _origin, _rider;

  int rideStatus = 1;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.3753, 69.3451),
    zoom: 9.4746,
  );

  String isLocationEnabled = "1",
      riderName = "",
      vehicleName = "",
      vehicleNumber = "",
      price = "",
      mobile = "",
      message = "Have a nice trip",
      comingTime = "10 mins",
      profile = "default.png",
      ridePrice = "0",
      total = "",
      avg = "",
      pickLat = "",
      pickLng = "",
      dropLat = "",
      dropLng = "";

  bool apiLoaded = true, rideStarted = false;

  Timer? rideStatusTimer;

  late LatLng myLatLng, riderLatLng;

  // void currentLocation() {
  //   setState(() {
  //     mylocationMarker(myLatLng.latitude, myLatLng.longitude);
  //     riderMarker(riderLatLng.latitude, riderLatLng.longitude);
  //   });
  //   animateCamera(myLatLng.latitude, myLatLng.longitude, 17.5);
  //   // enterCurrentLocation(value.latitude, value.longitude);
  // }

  void animateCamera(double lat, double lng, double zoom) {
    LatLng latLng = LatLng(lat, lng);
    final CameraPosition position = CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      zoom: zoom,
    );

    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(position),
    );
    // animateBounds();
  }

  void mylocationMarker(double lat, double lng) async {
    LatLng latLng = LatLng(lat, lng);

    _origin = Marker(
      markerId: MarkerId('Origin'),
      infoWindow: InfoWindow(title: 'Origin'),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 5), "assets/images/origin.png"),
      position: latLng,
    );

    // setState(() {});
  }

  void riderMarker(double lat, double lng) async {
    LatLng latLng = LatLng(lat, lng);

    _rider = Marker(
      markerId: MarkerId('Destination'),
      infoWindow: InfoWindow(title: 'Destination'),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 5),
          "assets/images/destination.png"),
      position: latLng,
    );
  }

  void initializePrice() {
    // riderId = 1;
    // time = 2;
    // myLatLng = LatLng(widget.offerDetails['myLatLng'].latitude,
    //     widget.offerDetails['myLatLng'].longitude);
    // riderLatLng = LatLng(widget.offerDetails['riderLatLng'].latitude,
    //     widget.offerDetails['riderLatLng'].longitude);
    // offeredPrice = widget.offerDetails['offeredPrice'];
  }

  void updateRide(int operation) async {
    Navigator.pop(context);
    var url = Uri.parse(Palette.baseUrl + Palette.updateRideUrl);

    int rideStatusX = 0;

    if (operation == 1) {
      rideStatusX = 5;
      rideStatus = 5;
    } else if (operation == 2) {
      rideStatusX = 3;
      rideStatus = 3;
    }

    var response = await http.post(url,
        body: jsonEncode({
          'ride_id': widget.rideId.toString(),
          'status': rideStatusX.toString(),
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RiderDashboard()),
        (Route<dynamic> route) => false);
    // Navigator.pop(context);
  }

  void iAmArrived() async {
    var url = Uri.parse(Palette.baseUrl + Palette.updateIamArrivedUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'ride_id': widget.rideId.toString(),
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });

    var responseData = json.decode(response.body);
    print(responseData);
  }

  void dialog(
      String title, String msg, String btn1, String btn2, int operation) {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: msg,
        title: title,
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              if (operation == 2) {
                // ShowResponse("rideComplets", context);
                updateRide(2);
              } else {
                Navigator.pop(context);
              }
            },
            text: btn1,
            iconData: Icons.done,
            color: Palette.primaryColor,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: () {
              if (operation == 1) {
                updateRide(1);
              } else {
                Navigator.pop(context);
              }
            },
            text: btn2,
            iconData: Icons.cancel,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  void messageBox(
      String title, String msg, String btn1, int operation, bool dismiss) {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: msg,
        title: title,
        context: context,
        barrierDismissible: dismiss,
        actions: [
          IconsButton(
            onPressed: () {
              if (operation == 1) {
                Navigator.pop(context);
              } else if (operation == 2) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => RiderDashboard()),
                    (Route<dynamic> route) => false);
              }
            },
            text: btn1,
            iconData: Icons.done,
            color: Palette.primaryColor,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  void launchCaller() async {
    String url = "tel:0$mobile";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {}
  }

  void checkRideStatus() async {
    var url = Uri.parse(Palette.baseUrl +
        Palette.getRideStatusUrl +
        "?ride_id=" +
        widget.rideId.toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var responseData = json.decode(response.body);

    print(responseData);
    if (responseData['status'] == 6) {
      rideStatusTimer?.cancel;
      messageBox("Alert", "Ride is canceled by user please go to home",
          "Go to home", 2, false);
    }
  }

  void getRideDetails() async {
    var url = Uri.parse(Palette.baseUrl +
        Palette.getRideUrl +
        "?ride_id=" +
        widget.rideId.toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var responseData = json.decode(response.body);

    ridePrice = responseData['ride']['fare'].toString();
    riderName = responseData['ride']['user']['first_name'] +
        " " +
        responseData['ride']['user']['last_name'];

    mobile = responseData['ride']['user']['mobile_number'];
    profile = responseData['ride']['user']['profile'];

    pickLat = responseData['ride']['pickup_latitude'];
    pickLng = responseData['ride']['pickup_longitude'];

    dropLat = responseData['ride']['drop_off_latitude'];
    dropLng = responseData['ride']['drop_off_longitude'];

    mylocationMarker(double.parse(pickLat), double.parse(pickLng));

    animateCamera(double.parse(pickLat), double.parse(pickLng), 17.5);

    statusTimer();

    setState(() {});

    // print(responseData);
  }

  void statusTimer() {
    rideStatusTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkRideStatus();
    });
  }

  Future<bool> goBack() async {
    messageBox(
        "Warning", "You cannot go back until ride is running", "OK", 1, true);
    return true;
  }

  final markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();

    // getRiderDetails();
    getRideDetails();

    // initializePrice();
  }

  @override
  void dispose() {
    _googleMapController.dispose();

    rideStatusTimer?.cancel();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double bodyWidth = MediaQuery.of(context).size.width;
    double bodyHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: goBack,
      child: Scaffold(
        key: _scaffoldKey,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: isLocationEnabled == "1"
              ? Container(
                  color: Palette.primaryColor.withOpacity(0.1),
                  width: bodyWidth,
                  height: bodyHeight,
                  child: apiLoaded
                      ? Stack(
                          key: Key("loading"),
                          children: [
                            Container(
                              width: bodyWidth,
                              height: bodyHeight,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: _kGooglePlex,
                                myLocationEnabled: true,
                                mapToolbarEnabled: false,
                                tiltGesturesEnabled: false,
                                compassEnabled: false,
                                scrollGesturesEnabled: true,
                                zoomGesturesEnabled: true,
                                zoomControlsEnabled: false,
                                myLocationButtonEnabled: false,
                                buildingsEnabled: false,
                                markers: {
                                  if (_origin != null) _origin!,
                                  if (_rider != null) _rider!,
                                },
                                onMapCreated: (GoogleMapController controller) {
                                  _googleMapController = controller;
                                  // currentLocation();
                                },
                              ),
                            ),
                            Positioned(
                              top: 50,
                              right: 20,
                              child: GestureDetector(
                                onTap: () {
                                  dialog(
                                      "Confirmation",
                                      "Do you want to cancel ride?",
                                      "No",
                                      "Yes",
                                      1);
                                },
                                child: Material(
                                  shape:
                                      const CircleBorder(side: BorderSide.none),
                                  elevation: 10,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 25,
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/cancel.png'),
                                              fit: BoxFit.contain)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 130,
                              right: 20,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var uri = Uri.parse(
                                          "google.navigation:q=+" +
                                              pickLat +
                                              "," +
                                              pickLng +
                                              "&mode=d");
                                      if (await canLaunchUrl(
                                          Uri.parse(uri.toString()))) {
                                        await launchUrl(
                                            Uri.parse(uri.toString()));
                                      } else {
                                        throw 'Could not launch ${uri.toString()}';
                                      }
                                    },
                                    child: Material(
                                      shape: const CircleBorder(
                                          side: BorderSide.none),
                                      elevation: 10,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 30,
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/start.png'),
                                                  fit: BoxFit.contain)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      var uri = Uri.parse(
                                          "google.navigation:q=+" +
                                              dropLat +
                                              "," +
                                              dropLng +
                                              "&mode=d");
                                      if (await canLaunchUrl(
                                          Uri.parse(uri.toString()))) {
                                        await launchUrl(
                                            Uri.parse(uri.toString()));
                                      } else {
                                        throw 'Could not launch ${uri.toString()}';
                                      }
                                    },
                                    child: Material(
                                      shape: const CircleBorder(
                                          side: BorderSide.none),
                                      elevation: 10,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 30,
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/measure-distance.png'),
                                                  fit: BoxFit.contain)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 20,
                              bottom: 200,
                              child: GestureDetector(
                                onTap: () {
                                  dialog(
                                      "Confirmation",
                                      "Do you want to complete ride?",
                                      "Yes",
                                      "No",
                                      2);
                                },
                                child: Material(
                                  shape:
                                      const CircleBorder(side: BorderSide.none),
                                  elevation: 10,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 25,
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/checked.png'),
                                              fit: BoxFit.contain)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 120,
                              right: 20,
                              child: Visibility(
                                visible: rideStarted ? true : false,
                                child: GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => safetyPage(
                                          id: 1,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Material(
                                    shape: const CircleBorder(
                                        side: BorderSide.none),
                                    elevation: 10,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                      child: Container(
                                        height: 28,
                                        width: 28,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/help.png'),
                                                fit: BoxFit.contain)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Container(
                                      height: 160,
                                      width: bodyWidth - 20,
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
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 15,
                                                right: 15,
                                                left: 15,
                                                bottom: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder:
                                                              'assets/images/loading.gif',
                                                          image:
                                                              Palette.imgUrl +
                                                                  profile,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    // CircleAvatar(
                                                    //   backgroundImage: AssetImage(
                                                    //       "assets/images/user.png"),
                                                    //   backgroundColor:
                                                    //       Colors.white,
                                                    //   radius: 20,
                                                    // ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: bodyWidth - 120,
                                                      // color: Colors.red,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            riderName,
                                                            style: TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          Text(
                                                            vehicleName,
                                                            style: TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 15,
                                                                color: Palette
                                                                    .primaryColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 5,
                                                right: 15,
                                                left: 15,
                                                bottom: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [],
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "Fares: PKR $ridePrice",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 16,
                                                              color: Palette
                                                                  .primaryColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 10, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                MaterialButton(
                                                  minWidth: 60,
                                                  height: 40,
                                                  color: Palette.primaryColor,
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            RideChat(
                                                          name: riderName,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: const Text(
                                                    "Chat",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  minWidth: 60,
                                                  height: 40,
                                                  color: Palette.primaryColor,
                                                  onPressed: () {
                                                    launchCaller();
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: const Text(
                                                    "Call",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  minWidth: 60,
                                                  height: 40,
                                                  color: Palette.primaryColor,
                                                  onPressed: () {
                                                    ShowResponse(
                                                        "Please wait", context);
                                                    iAmArrived();
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: const Text(
                                                    "Arrived",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                )
              : Stack(
                  key: Key("no location"),
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          "Location is disabled",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
