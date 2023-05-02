import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:http/http.dart' as http;

import '../config/palette.dart';
import 'bidding/bids_list.dart';

class findDriver extends StatefulWidget {
  int id, vehicleType;
  double lat, lng, lat2, lng2;
  String distance, duration, pick, drop, price, currency, paymentMothod;
  findDriver(
      {required this.id,
      required this.lat,
      required this.lng,
      required this.lat2,
      required this.lng2,
      required this.distance,
      required this.duration,
      required this.pick,
      required this.drop,
      required this.price,
      required this.currency,
      required this.paymentMothod,
      required this.vehicleType,
      Key? key})
      : super(key: key);
  @override
  State<findDriver> createState() => _findDriverState();
}

class _findDriverState extends State<findDriver> {
  final box = GetStorage();
  late GoogleMapController _googleMapController;
  Marker? _origin;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.082742, 67.259658),
    zoom: 9.4746,
  );

  String isLocationEnabled = "1", timeUnit = "min";
  bool enableDecrease = false,
      showRequests = false,
      mapVisible = false,
      offersVisible = false;

  int price = 0, actualPrice = 0, riderId = 2, time = 2, offeredPrice = 350;

  void currentLocation() {
    mylocationMarker(widget.lat, widget.lng);

    animateCamera(widget.lat, widget.lng, 17.5);
    // enterCurrentLocation(value.latitude, value.longitude);
  }

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

    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        mapVisible = true;
      });
    });

    updateUserState();
  }

  void updateUserState() async {
    var url = Uri.parse(Palette.baseUrl + Palette.userStateUpdateUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'user_id': box.read('userId'),
          'current_location': widget.pick,
          'current_latitude': widget.lat,
          'current_longitude': widget.lng,
          'status': "0",
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });
    var responseData = json.decode(response.body);
    print(response.statusCode);
    if (response.statusCode == 201) {
      storeOffer();
    }
  }

  void storeOffer() async {
    var url = Uri.parse(Palette.baseUrl + Palette.storeOfferUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'user_id': box.read('userId'),
          'user_name': box.read('firstName'),
          'offer_price': actualPrice,
          'pickup_location': widget.pick,
          'pickup_latitude': widget.lat,
          'pickup_longitude': widget.lng,
          'drop_off_location': widget.drop,
          'drop_off_latitude': widget.lat2,
          'drop_off_longitude': widget.lng2,
          'vehicle_type': widget.vehicleType.toString()
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });
    var responseData = json.decode(response.body);
    box.write('offerId', responseData['id']);
    box.write('lat', widget.lat.toString());
    box.write('lng', widget.lng.toString());
    print(responseData);
  }

  void getBids() {
    setState(() {
      offersVisible = true;
    });
  }

  void deleteOffer() async {
    Navigator.pop(context);
    var url = Uri.parse(Palette.baseUrl + Palette.deleteOfferUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'offer_id': box.read('offerId'),
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });
    goBack();
    // print(responseData);
    // Navigator.pop(context);
  }

  // void delayFunction(time) {
  //   Future.delayed(Duration(milliseconds: time), () {
  //     // getOffers();
  //   });
  // }

  void goBack() {
    Navigator.pop(context, null);
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
              deleteOffer();
            },
            text: btn2,
            iconData: Icons.cancel,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  Future<bool> onBackAction() async {
    dialog("Confirmation", "Do you want to cancel ride?", "No", "Yes");
    // Navigator.pop(context, null);
    return true;
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
      onWillPop: onBackAction,
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
                                  initialCameraPosition: _kGooglePlex,
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
                                    currentLocation();
                                  },
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
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
                                '${widget.distance}, ${widget.duration}',
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          child: BidsList(
                        pick: widget.pick,
                        drop: widget.drop,
                        distance: widget.distance,
                        time: widget.duration,
                        lat: widget.lat,
                        lng: widget.lng,
                        lat2: widget.lat2,
                        lng2: widget.lng2,
                      )),
                      // Positioned(
                      //   top: 50,
                      //   right: 20,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       dialog("Confirmation",
                      //           "Do you want to cancel ride?", "No", "Yes");
                      //     },
                      //     child: CircleAvatar(
                      //       backgroundColor: Colors.white,
                      //       radius: 25,
                      //       child: Container(
                      //         height: 28,
                      //         width: 28,
                      //         decoration: const BoxDecoration(
                      //             image: DecorationImage(
                      //                 image: AssetImage(
                      //                     'assets/images/cancel.png'),
                      //                 fit: BoxFit.contain)),
                      //       ),
                      //     ),
                      //   ),
                      // ),

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
                                              "${widget.currency} $price ${widget.paymentMothod}",
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
                                    Divider(
                                      thickness: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          MaterialButton(
                                            minWidth: 60,
                                            height: 60,
                                            color: Palette.primaryColor,
                                            disabledColor: Colors.grey,
                                            onPressed: enableDecrease
                                                ? () {
                                                    if (actualPrice < price) {
                                                      setState(() {
                                                        price -= 10;
                                                      });
                                                    }
                                                    if (actualPrice == price) {
                                                      setState(() {
                                                        enableDecrease = false;
                                                      });
                                                    }
                                                  }
                                                : null,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: const Text(
                                              "-10",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            child: Center(
                                              child: Text(
                                                "${widget.currency} " +
                                                    price.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          MaterialButton(
                                            minWidth: 60,
                                            height: 60,
                                            color: Palette.primaryColor,
                                            onPressed: () {
                                              setState(() {
                                                enableDecrease = true;
                                                price += 10;
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: const Text(
                                              "+10",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
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
                                        onPressed: price > actualPrice
                                            ? () {
                                                setState(() {
                                                  actualPrice = price;
                                                  enableDecrease = false;
                                                });

                                                storeOffer();
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
                              fontSize: 20,
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
