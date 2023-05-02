import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../config/palette.dart';
import '../dashboard/price.dart';
import '../resources/widgets/response.dart';

class checkRide extends StatefulWidget {
  int id;
  double lat, lng, lat2, lng2;
  String distance, pick, drop, price, currency, paymentMothod;
  checkRide(
      {required this.id,
      required this.lat,
      required this.lng,
      required this.lat2,
      required this.lng2,
      required this.distance,
      required this.pick,
      required this.drop,
      required this.price,
      required this.currency,
      required this.paymentMothod,
      Key? key})
      : super(key: key);
  @override
  State<checkRide> createState() => _checkRideState();
}

class _checkRideState extends State<checkRide> {
  final box = GetStorage();

  late GoogleMapController _googleMapController;
  Marker? _origin;

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(widget.lng, 67.259658),
  //   zoom: 9.4746,
  // );

  String isLocationEnabled = "1", timeUnit = "min";
  bool enableDecrease = false,
      showRequests = false,
      mapVisible = false,
      offersVisible = false,
      riderAccepted = true;

  int status = 0,
      price = 0,
      actualPrice = 0,
      riderId = 2,
      time = 2,
      offeredPrice = 350,
      bidId = 0;

  String riderPrice = "Offer your price", paymentMothod = "", currency = "";

  // void currentLocation() {
  //   mylocationMarker(widget.lat, widget.lng);

  //   animateCamera(widget.lat, widget.lng, 17.5);
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

    setState(() {});
  }

  void initializePrice() {
    price = int.parse(widget.price);
    actualPrice = price;

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        mapVisible = true;
      });
    });
  }

  void getOffers() {
    setState(() {
      offersVisible = true;
    });
  }

  void dialog(String title, String msg, String btn1, String btn2) {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: msg,
        title: title,
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: btn1,
            iconData: Icons.done,
            color: Palette.primaryColor,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            text: btn2,
            iconData: Icons.cancel,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  Future<bool> goback() async {
    if (status == 1) {
      var offerDetails = {
        'riderId': riderId,
        'offeredPrice': offeredPrice,
        'time': time,
        'timeUnit': timeUnit,
        'myLatLng': LatLng(widget.lat, widget.lng),
        'riderLatLng': LatLng(24.847223, 67.031454),
      };

      Navigator.pop(context, offerDetails);
      return true;
    } else {
      Navigator.pop(context, null);
      return true;
    }
  }

  void sendBid(int price) async {
    var url = Uri.parse(Palette.baseUrl + Palette.sendBidUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'offer_id': widget.id.toString(),
          'counter_offer': price.toString(),
          'rider_id': box.read('userId').toString(),
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });
    var responseData = json.decode(response.body);
    bidId = responseData['id'];
    print(responseData);
  }

  void updateDeclineBid(int price) async {
    var url = Uri.parse(Palette.baseUrl + Palette.updateDeclineBidUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'new_offer': price.toString(),
          'bid_id': bidId.toString(),
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });
    var responseData = json.decode(response.body);
    // print(responseData);
  }

  bool bidDeclined = false;

  void getDeclineBid() async {
    var url = Uri.parse(Palette.baseUrl +
        Palette.getDeclinedBidUrl +
        "?bid_id=" +
        bidId.toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var responseData = json.decode(response.body);
    if (responseData['status'] == true) {
      bidDeclined = true;
      bidsTimers?.cancel();
      ShowResponse("Your offer declined", context);
    }
    print(responseData);
  }

  Timer? bidsTimers;

  void runDeclineBids() {
    bidsTimers = Timer.periodic(Duration(seconds: 5), (timer) {
      getDeclineBid();
    });
  }

  @override
  void initState() {
    super.initState();
    initializePrice();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double bodyWidth = MediaQuery.of(context).size.width;
    double bodyHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: goback,
      child: Scaffold(
        key: _scaffoldKey,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: isLocationEnabled == "1"
              ? Container(
                  color: Palette.primaryColor.withOpacity(0.1),
                  width: bodyWidth,
                  height: bodyHeight,
                  child: Stack(
                    key: Key("loading"),
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1000),
                        child: mapVisible
                            ? Container(
                                width: bodyWidth,
                                height: bodyHeight / 1.5,
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(widget.lat, widget.lng),
                                    zoom: 16.4746,
                                  ),
                                  myLocationEnabled: false,
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
                                  },
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _googleMapController = controller;
                                    // currentLocation();
                                    mylocationMarker(widget.lat, widget.lng);
                                  },
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                      riderAccepted
                          ? Positioned(
                              top: 130,
                              right: 20,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var uri = Uri.parse(
                                          "google.navigation:q=+" +
                                              widget.lat.toString() +
                                              "," +
                                              widget.lng.toString() +
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
                                              widget.lat2.toString() +
                                              "," +
                                              widget.lng2.toString() +
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
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12.0,
                              ),
                              decoration: BoxDecoration(
                                color: Palette.primaryColor,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 6.0,
                                  )
                                ],
                              ),
                              child: Text(
                                'Customer is ${widget.distance} KM away',
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
                        bottom: 0,
                        left: 0,
                        child: Container(
                          height: bodyHeight / 2.8,
                          width: bodyWidth,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    LinearProgressIndicator(),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.trip_origin_sharp,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Text(
                                              "${widget.pick}",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.trip_origin_sharp,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Text(
                                              "${widget.drop}",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20, left: 10),
                                            child: Text(
                                              "Customer offer is ${widget.currency} ${widget.price} ${widget.paymentMothod}",
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final routeResponse =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PriceChange(
                                                value: riderPrice,
                                              ),
                                            ),
                                          );
                                          if (routeResponse != "0") {
                                            setState(() {
                                              riderPrice = routeResponse;
                                              price = int.parse(riderPrice);
                                            });
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/pkr.png"),
                                              backgroundColor: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child: Container(
                                                  width: bodyWidth,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          width: 2,
                                                          color: Palette
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    currency +
                                                        " " +
                                                        riderPrice +
                                                        paymentMothod,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, top: 15),
                                      child: MaterialButton(
                                        minWidth: double.infinity,
                                        height: 60,
                                        color: Palette.primaryColor,
                                        disabledColor: Colors.grey,
                                        onPressed: price != actualPrice
                                            ? () {
                                                if (bidDeclined) {
                                                  updateDeclineBid(price);
                                                } else {
                                                  sendBid(price);
                                                }

                                                runDeclineBids();
                                                setState(() {
                                                  actualPrice = price;
                                                });
                                              }
                                            : null,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Text(
                                          "Update fares",
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
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
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
