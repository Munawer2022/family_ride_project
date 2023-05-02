import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rider/dashboard/places.dart';
import 'package:rider/dashboard/price.dart';
import 'package:rider/dashboard/review.dart';
import 'package:rider/dashboard/ride_screen.dart';
import 'package:rider/dashboard/wishes.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../config/palette.dart';
import '../resources/widgets/drawer_widget.dart';
import '../resources/widgets/response.dart';
import 'direction_model.dart';
import 'direction_repository.dart';
import 'find_driver.dart';

class dashboard extends StatefulWidget {
  dashboard({Key? key}) : super(key: key);
  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  final box = GetStorage();
  TextEditingController pickController = new TextEditingController();
  TextEditingController dropController = new TextEditingController();

  var uuid = Uuid();

  late GoogleMapController _googleMapController;
  Marker? _origin, _destination;
  Directions? _info;

  bool normalBikeSelected = false,
      acCarSelected = false,
      miniCarSelected = false,
      heavyBikeSelected = true,
      isMyPosition = true,
      mapVisible = false,
      rideExist = false;

  String isLocationEnabled = "1",
      pickupLocation = "Pickup location",
      dropOffLocation = "Drop off location",
      userPrice = "Offer your price",
      distance = "0",
      duration = "0",
      address = "",
      city = "",
      estimatedText = "",
      paymentMothod = "",
      currency = "",
      userWish = "Your wishes";

  Timer? rideCheckTimer;

  double normalKM = 21.0, acCarKM = 73.0, miniCarKM = 61.0, heavyKM = 42.6;
  int estimatedFare = 0, vehicleType = 4;

  late LatLng myCoordinates;

  late List<Location> pickupLatLng, dropOffLatLng;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.082742, 67.259658),
    zoom: 9.4746,
  );

  Future<Position> getUserCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
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
          mapVisible = true;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            currentLocation();
          });
        });
      });
    }

    setState(() {});
  }

  void currentLocation() {
    getUserCurrentLocation().then(
      (value) async {
        setState(() {
          mylocationMarker(value.latitude, value.longitude);
        });
        animateCamera(value.latitude, value.longitude, 17.5);
        enterCurrentLocation(value.latitude, value.longitude);
      },
    );
  }

  void enterCurrentLocation(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    address = placemarks.first.name! +
        " " +
        placemarks.first.subLocality! +
        " " +
        placemarks.first.subAdministrativeArea! +
        " " +
        placemarks.first.thoroughfare!;

    myCoordinates = LatLng(lat, lng);
    // pickupLatLng = await locationFromAddress(address);

    setState(() {
      pickupLocation = address;
    });
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

  void addMarker(double lat, double lng, way) async {
    LatLng latLng = LatLng(lat, lng);
    if (way == "origin") {
      _origin = Marker(
          markerId: MarkerId('Origin'),
          infoWindow: InfoWindow(title: 'Origin'),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 5),
              "assets/images/origin.png"),
          position: latLng);

      if (dropOffLatLng.isNotEmpty) {
        addPolyline();
      }
    } else if (way == "destination") {
      _destination = Marker(
          markerId: MarkerId('Destination'),
          infoWindow: InfoWindow(title: 'Destination'),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 5),
              "assets/images/destination.png"),
          position: latLng);

      addPolyline();
    }
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
  }

  void animateBounds() {
    _googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(_info!.bounds, 120.0));

    setState(() {
      distance = _info!.totalDistance;
      duration = _info!.totalDuration;
      calculateFares();
    });
  }

  void calculateFares() {
    if (normalBikeSelected) {
      estimatedFare =
          (normalKM * double.parse(distance.substring(0, distance.length - 3)))
              .round();
    } else if (heavyBikeSelected) {
      estimatedFare =
          (heavyKM * double.parse(distance.substring(0, distance.length - 3)))
              .round();
    } else if (acCarSelected) {
      estimatedFare =
          (acCarKM * double.parse(distance.substring(0, distance.length - 3)))
              .round();
    } else if (miniCarSelected) {
      estimatedFare =
          (miniCarKM * double.parse(distance.substring(0, distance.length - 3)))
              .round();
    }

    setState(() {
      estimatedText = "Estimated fares, adjustable";
      userPrice = estimatedFare.toString();
      currency = "PKR";
      paymentMothod = ", cash";
    });
  }

  void addPolyline() async {
    LatLng pos1;
    if (isMyPosition) {
      // ShowResponse("default", context);
      pos1 = LatLng(myCoordinates.latitude, myCoordinates.longitude);
    } else {
      // ShowResponse("cahge", context);
      pos1 = LatLng(pickupLatLng.last.latitude, pickupLatLng.last.longitude);
    }

    LatLng pos2 =
        LatLng(dropOffLatLng.last.latitude, dropOffLatLng.last.longitude);

    final directions = await DirectionsRepository()
        .getDirections(origin: pos1, destination: pos2);

    setState(() {
      _info = directions;
    });
    if (_info != null) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        animateBounds();
      });
    }
  }

  void toRideSreen() async {
    final routeResponse = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const rideScreen(),
      ),
    );
    if (routeResponse == 1 || routeResponse == 2) {
      isRideExistTimer();
      rideExist = true;
      setState(() {});
    } else if (routeResponse == 4) {
      setState(() {
        rideExist = false;
      });
      dialog();
    } else {
      setState(() {
        rideExist = false;
      });
    }
  }

  void dialog() {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: "Do you want to rate the ride?",
        title: "Ride Completed",
        context: context,
        barrierDismissible: false,
        actions: [
          IconsButton(
            onPressed: () async {
              int xxx = box.read('rideId');
              box.write('rideId', 0);
              Navigator.pop(context);
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReviewPage(rideId: xxx)));
            },
            text: "Yes",
            iconData: Icons.done,
            color: Palette.primaryColor,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: () {
              box.write('rideId', 0);
              Navigator.pop(context);
            },
            text: "No",
            iconData: Icons.cancel,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  void isRideExistTimer() {
    if (box.read('rideId') != null && box.read('rideId') != 0) {
      rideCheckTimer = Timer.periodic(Duration(seconds: 10), (timer) {
        isRideExist();
      });
    } else {
      rideCheckTimer?.cancel();
    }
  }

  void isRideExist() async {
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

    if (responseData['ride']['status'] == 1 ||
        responseData['ride']['status'] == 2) {
      rideExist = true;
      setState(() {});
    } else {
      rideCheckTimer?.cancel();
      rideExist = false;
      box.write('rideId', 0);
      setState(() {});
    }

    // print(responseData);
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
          mapVisible = true;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            currentLocation();
          });
        });
      });
    } else {
      checkDialog();
    }
  }

  @override
  void initState() {
    super.initState();
    // locationPermission();
    checkPermission();
    isRideExistTimer();
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

    print(box.read('userProfile'));

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(
          scaffoldKey: _scaffoldKey,
          firstName: box.read('firstName'),
          mobileNumber: box.read('mobileNumber'),
          userProfile: box.read('userProfile'),
          pageName: "dashboard"),
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
                              height: bodyHeight / 1.6,
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
                                  if (_destination != null) _destination!
                                },
                                polylines: {
                                  if (_info != null)
                                    Polyline(
                                      polylineId:
                                          const PolylineId('overview_polyline'),
                                      color: Colors.red,
                                      width: 5,
                                      points: _info!.polylinePoints
                                          .map((e) =>
                                              LatLng(e.latitude, e.longitude))
                                          .toList(),
                                    ),
                                },
                                onMapCreated: (GoogleMapController controller) {
                                  _googleMapController = controller;
                                  // locationPermission();
                                  checkPermission();
                                },
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
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
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/menu.png'),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 20,
                      child: Visibility(
                        visible: rideExist,
                        child: AvatarGlow(
                          glowColor: Colors.green,
                          endRadius: 50.0,
                          duration: Duration(milliseconds: 2000),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration: Duration(milliseconds: 100),
                          child: GestureDetector(
                            onTap: () {
                              toRideSreen();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/fast-forward.png'),
                                      fit: BoxFit.contain),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: bodyHeight / 1.9,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          currentLocation();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/my-location.png'),
                                    fit: BoxFit.contain)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        height: bodyHeight / 2,
                        width: bodyWidth,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (!heavyBikeSelected) {
                                                vehicleType = 4;
                                                setState(() {
                                                  normalBikeSelected = false;
                                                  acCarSelected = false;
                                                  miniCarSelected = false;
                                                  heavyBikeSelected = true;
                                                });
                                                calculateFares();
                                              }
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: heavyBikeSelected
                                                    ? Palette.primaryColor
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 3,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 2,
                                                    left: 5,
                                                    child: Container(
                                                      width: 60,
                                                      child: Image.asset(
                                                          "assets/images/6.png"),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 11,
                                                    left: 5,
                                                    child: Text(
                                                      "Rickshaw",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (!normalBikeSelected) {
                                                vehicleType = 1;
                                                setState(() {
                                                  normalBikeSelected = true;
                                                  acCarSelected = false;
                                                  miniCarSelected = false;
                                                  heavyBikeSelected = false;
                                                });
                                                calculateFares();
                                              }
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: normalBikeSelected
                                                    ? Palette.primaryColor
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 3,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 2,
                                                    left: 5,
                                                    child: Container(
                                                      width: 60,
                                                      child: Image.asset(
                                                          "assets/images/3.png"),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 11,
                                                    left: 5,
                                                    child: Text(
                                                      "Bike",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (!acCarSelected) {
                                                vehicleType = 2;
                                                setState(() {
                                                  normalBikeSelected = false;
                                                  acCarSelected = true;
                                                  miniCarSelected = false;
                                                  heavyBikeSelected = false;
                                                });
                                                calculateFares();
                                              }
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: acCarSelected
                                                    ? Palette.primaryColor
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 3,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 2,
                                                    left: 5,
                                                    child: Container(
                                                      width: 60,
                                                      child: Image.asset(
                                                          "assets/images/2.png"),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 11,
                                                    left: 5,
                                                    child: Text(
                                                      "AC Car",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (!miniCarSelected) {
                                                vehicleType = 3;
                                                setState(() {
                                                  normalBikeSelected = false;
                                                  acCarSelected = false;
                                                  miniCarSelected = true;
                                                  heavyBikeSelected = false;
                                                });
                                                calculateFares();
                                              }
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: miniCarSelected
                                                    ? Palette.primaryColor
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 3,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 2,
                                                    left: 5,
                                                    child: Container(
                                                      width: 60,
                                                      child: Image.asset(
                                                          "assets/images/1.png"),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 11,
                                                    left: 5,
                                                    child: Text(
                                                      "Mini Car",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      // _settingModalBottomSheet(context,
                                      //     pickController, "Serch location");
                                      final routeResponse =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => places(
                                            location: "Pickup location",
                                            value: pickupLocation,
                                          ),
                                        ),
                                      );
                                      if (routeResponse == dropOffLocation) {
                                        ShowResponse(
                                            "Pickup and drop off location are same",
                                            context);
                                      } else if (routeResponse !=
                                          pickupLocation) {
                                        isMyPosition = false;
                                        pickupLatLng =
                                            await locationFromAddress(
                                                routeResponse);

                                        addMarker(
                                            pickupLatLng.last.latitude,
                                            pickupLatLng.last.longitude,
                                            "origin");

                                        animateCamera(
                                            pickupLatLng.last.latitude,
                                            pickupLatLng.last.longitude,
                                            17.5);

                                        setState(() {
                                          pickupLocation = routeResponse;
                                        });
                                      } else {
                                        // ShowResponse("same location", context);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                            child: Container(
                                              width: bodyWidth,
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: 2,
                                                      color:
                                                          Palette.primaryColor),
                                                ),
                                              ),
                                              child: Text(
                                                "$pickupLocation",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: Colors.grey),
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
                                  GestureDetector(
                                    onTap: () async {
                                      final routeResponse =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => places(
                                            location: "Drop off location",
                                            value: dropOffLocation,
                                          ),
                                        ),
                                      );
                                      if (routeResponse == pickupLocation) {
                                        ShowResponse(
                                            "Pickup and drop off location are same",
                                            context);
                                      } else if (routeResponse !=
                                          dropOffLocation) {
                                        dropOffLatLng =
                                            await locationFromAddress(
                                                routeResponse);

                                        addMarker(
                                            dropOffLatLng.last.latitude,
                                            dropOffLatLng.last.longitude,
                                            "destination");

                                        animateCamera(
                                            dropOffLatLng.last.latitude,
                                            dropOffLatLng.last.longitude,
                                            17.5);

                                        setState(() {
                                          dropOffLocation = routeResponse;
                                        });
                                      } else {
                                        // ShowResponse("same drop", context);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                            child: Container(
                                              width: bodyWidth,
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: 2,
                                                      color:
                                                          Palette.primaryColor),
                                                ),
                                              ),
                                              child: Text(
                                                "$dropOffLocation",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 10, right: 10),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: [
                                  //       Flexible(
                                  //         child: AnimatedOpacity(
                                  //           opacity: _info != null ? 1 : 0,
                                  //           duration:
                                  //               Duration(milliseconds: 1000),
                                  //           child: Container(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //               vertical: 8.0,
                                  //               horizontal: 12.0,
                                  //             ),
                                  //             decoration: BoxDecoration(
                                  //               color: Palette.primaryColor,
                                  //               borderRadius:
                                  //                   BorderRadius.circular(5.0),
                                  //               boxShadow: const [
                                  //                 BoxShadow(
                                  //                   color: Colors.black26,
                                  //                   offset: Offset(0, 2),
                                  //                   blurRadius: 6.0,
                                  //                 )
                                  //               ],
                                  //             ),
                                  //             child: Text(
                                  //               '$estimatedText',
                                  //               style: const TextStyle(
                                  //                   fontSize: 14.0,
                                  //                   fontWeight: FontWeight.w600,
                                  //                   color: Colors.white),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (pickupLocation.isEmpty ||
                                          pickupLocation == "Pickup location" ||
                                          dropOffLocation.isEmpty ||
                                          dropOffLocation ==
                                              "Drop off location") {
                                        ShowResponse(
                                            "Please select Pickup and Drop Off location first.",
                                            context);
                                      } else {
                                        final routeResponse =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PriceChange(
                                              value: userPrice,
                                            ),
                                          ),
                                        );
                                        if (routeResponse != "0") {
                                          setState(() {
                                            userPrice = routeResponse;
                                          });
                                        }
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
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: 2,
                                                      color:
                                                          Palette.primaryColor),
                                                ),
                                              ),
                                              child: Text(
                                                currency +
                                                    " " +
                                                    userPrice +
                                                    paymentMothod,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: Colors.grey),
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
                                  GestureDetector(
                                    onTap: () async {
                                      final routeResponse =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Wishes(
                                            value: userWish,
                                          ),
                                        ),
                                      );
                                      if (routeResponse != "0") {
                                        setState(() {
                                          userWish = routeResponse;
                                        });
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          onPressed: () async {},
                                          icon: const Icon(
                                            Icons.comment,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: Container(
                                              width: bodyWidth,
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      width: 2,
                                                      color:
                                                          Palette.primaryColor),
                                                ),
                                              ),
                                              child: Text(
                                                "$userWish",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 10),
                                    child: MaterialButton(
                                      minWidth: double.infinity,
                                      height: 60,
                                      color: Palette.primaryColor,
                                      onPressed: () async {
                                        if (rideExist) {
                                          ShowResponse(
                                              "Ride is already running",
                                              context);
                                        } else if (pickupLocation.isEmpty ||
                                            pickupLocation ==
                                                "Pickup location" ||
                                            dropOffLocation.isEmpty ||
                                            dropOffLocation ==
                                                "Drop off location") {
                                          ShowResponse(
                                              "Please select Pickup and Drop Off location first.",
                                              context);
                                        } else if (userPrice ==
                                            "Offer your price") {
                                          ShowResponse(
                                              "Please wait for price calculation",
                                              context);
                                        } else {
                                          rideCheckTimer?.cancel();
                                          final routeResponse =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => findDriver(
                                                id: 1,
                                                lat: isMyPosition
                                                    ? myCoordinates.latitude
                                                    : pickupLatLng
                                                        .last.latitude,
                                                lng: isMyPosition
                                                    ? myCoordinates.longitude
                                                    : pickupLatLng
                                                        .last.longitude,
                                                lat2:
                                                    dropOffLatLng.last.latitude,
                                                lng2: dropOffLatLng
                                                    .last.longitude,
                                                distance: distance,
                                                duration: duration,
                                                pick: pickupLocation,
                                                drop: dropOffLocation,
                                                price: userPrice,
                                                currency: currency,
                                                paymentMothod: paymentMothod,
                                                vehicleType: vehicleType,
                                              ),
                                            ),
                                          );
                                          // ShowResponse(routeResponse.toString(), context);
                                          if (routeResponse == 1) {
                                            toRideSreen();
                                          }
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Text(
                                        "Find rider",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity: _info != null ? 1 : 0,
                            duration: Duration(milliseconds: 1000),
                            child: Container(
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
                                '$distance, $duration',
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
            : Stack(
                key: Key("no location"),
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        color: Palette.primaryColor,
                        onPressed: () async {
                          // locationPermission();
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
      ),
    );
  }
}
