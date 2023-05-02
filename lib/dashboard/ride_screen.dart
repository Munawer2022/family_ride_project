import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:rider/dashboard/safety.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../chat.dart';
import '../config/palette.dart';

class rideScreen extends StatefulWidget {
  const rideScreen({Key? key}) : super(key: key);
  @override
  State<rideScreen> createState() => _rideScreenState();
}

class _rideScreenState extends State<rideScreen> {
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
      comingTime = "10 to 20 mins ",
      profile = "default.png",
      ridePrice = "0",
      total = "",
      avg = "",
      pickLat = "",
      pickLng = "";

  bool apiLoaded = true, rideStarted = false;

  Timer? rideDetailsTimer, rideStatusTimer;

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

  // void animateBounds() {
  //   ShowResponse("sdsdsds", context);
  //   _googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
  //       LatLngBounds(
  //           southwest: LatLng(riderLatLng.latitude, riderLatLng.longitude),
  //           northeast: LatLng(myLatLng.latitude, myLatLng.longitude)),
  //       120.0));
  // }

  void initializePrice() {
    // riderId = 1;
    // time = 2;
    // myLatLng = LatLng(widget.offerDetails['myLatLng'].latitude,
    //     widget.offerDetails['myLatLng'].longitude);
    // riderLatLng = LatLng(widget.offerDetails['riderLatLng'].latitude,
    //     widget.offerDetails['riderLatLng'].longitude);
    // offeredPrice = widget.offerDetails['offeredPrice'];

    Timer(Duration(seconds: 5), () {
      bottomSheet();
    });
  }

  void updateRide(int operation) async {
    Navigator.pop(context);
    var url = Uri.parse(Palette.baseUrl + Palette.updateRideUrl);

    int rideStatusX = 0;

    if (operation == 1) {
      rideStatusX = 6;
      rideStatus = 6;
    } else if (operation == 2) {
      rideStatusX = 4;
      rideStatus = 4;
    }

    var response = await http.post(url,
        body: jsonEncode({
          'ride_id': box.read('rideId').toString(),
          'status': rideStatusX.toString(),
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });

    Navigator.pop(context);
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

  void bottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.4,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade500,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(50, 50),
                                  blurRadius: 100.0,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "$riderName has arrived",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "$vehicleName, $vehicleNumber",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Text(
                          "Arrive within 5:00 Mins",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "If your are late your rating may be affected",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        color: Palette.primaryColor,
                        onPressed: () async {
                          Navigator.pop(context);
                          rideStarted = true;
                          setState(() {});
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "I'm coming",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        color: Colors.grey.shade300,
                        onPressed: () async {
                          launchCaller();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.call,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              "Call rider",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void launchCaller() async {
    String url = "tel:0$mobile";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {}
  }

  // void getRiderDetails() async {
  //   var url = Uri.parse(Palette.baseUrl +
  //       Palette.getUserProfile +
  //       "?user_id=" +
  //       box.read('riderId').toString());

  //   var response = await http.get(url, headers: {
  //     HttpHeaders.contentTypeHeader: "application/json",
  //     HttpHeaders.acceptHeader: "application/json",
  //     HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
  //   });
  //   var responseData = json.decode(response.body);

  //   riderName =
  //       responseData['user']['first_name'] + " " + responseData['last_name'];
  //   vehicleName = responseData['user']['vehicle_number'];
  //   vehicleNumber = responseData['user']['vehicle_number'];
  //   mobile = responseData['user']['mobile_number'];
  //   profile = responseData['user']['profile'];

  //   setState(() {});

  //   print(responseData);
  // }

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
                Navigator.pop(context, 5);
              } else if (operation == 2) {
                Navigator.pop(context);
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

  void checkRideStatus() async {
    var url = Uri.parse(Palette.baseUrl +
        Palette.getRideStatusUrl +
        "?ride_id=" +
        box.read('rideId').toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var responseData = json.decode(response.body);

    // if (responseData['ride']['is_arrived'] == 1) {
    //   rideDetailsTimer?.cancel();
    //   bottomSheet();
    // }

    if (responseData['status'] == 5) {
      rideStatusTimer?.cancel;
      box.write('rideId', 0);
      messageBox("Alert", "Ride is canceled by rider please go to home",
          "Go to home", 1, false);
    }

    // print(responseData);
  }

  void checkArrived() async {
    var url = Uri.parse(Palette.baseUrl +
        Palette.getRideUrl +
        "?ride_id=" +
        box.read('rideId').toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var responseData = json.decode(response.body);

    if (responseData['ride']['is_arrived'] == 1) {
      rideDetailsTimer?.cancel();

      bottomSheet();
    }

    print(responseData);
  }

  void getRideDetails() async {
    var url = Uri.parse(Palette.baseUrl +
        Palette.getRideUrl +
        "?ride_id=" +
        box.read('rideId').toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var responseData = json.decode(response.body);

    ridePrice = responseData['ride']['fare'].toString();
    riderName = responseData['ride']['rider']['first_name'] +
        " " +
        responseData['ride']['rider']['last_name'];

    String vehicleDate = responseData['ride']['rider']['vehicle_number'];
    vehicleName = vehicleDate.split(',')[0];
    vehicleNumber = vehicleDate.split(',')[1];
    mobile = responseData['ride']['rider']['mobile_number'];
    profile = responseData['ride']['rider']['profile'];
    total = responseData['ride_rider_reviews_count'].toString();
    avg = responseData['ride_rider_avg_stars'].toString();

    pickLat = responseData['ride']['pickup_latitude'];
    pickLng = responseData['ride']['pickup_longitude'];

    mylocationMarker(double.parse(pickLat), double.parse(pickLng));

    animateCamera(double.parse(pickLat), double.parse(pickLng), 17.5);

    if (responseData['ride']['is_arrived'] != 1) {
      arrivedTimer();
    }
    statusTimer();

    setState(() {});

    // print(responseData);
  }

  void arrivedTimer() {
    rideDetailsTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkArrived();
    });
  }

  void statusTimer() {
    rideStatusTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkRideStatus();
    });
  }

  Future<bool> goBack() async {
    // if (status == 1) {
    //   Navigator.pop(context, 1);
    //   return true;
    // } else {

    //   return true;
    // }
    messageBox("Alert", "Cannot go back while ride is running", "OK", 2, false);
    // Navigator.pop(context, rideStatus);
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
    rideDetailsTimer?.cancel();
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
                              left: 10,
                              top: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: bodyWidth / 1.4,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 12.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Palette.primaryColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 6.0,
                                        )
                                      ],
                                    ),
                                    child: Text(
                                      rideStarted
                                          ? message
                                          : "$riderName"
                                              " is coming. Keep PKR $ridePrice for ride. $riderName will arrive in ~ $comingTime",
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
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
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          "assets/images/star.png"),
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: 12,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "$avg ($total)",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "Number: $vehicleNumber",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 14,
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
