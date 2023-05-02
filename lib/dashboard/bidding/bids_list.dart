import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../config/palette.dart';
import '../../resources/widgets/response.dart';
import 'bids_provider.dart';

class BidsList extends StatefulWidget {
  String pick, drop, distance, time;
  double lat, lng, lat2, lng2;
  BidsList(
      {required this.pick,
      required this.drop,
      required this.distance,
      required this.time,
      required this.lat,
      required this.lng,
      required this.lat2,
      required this.lng2,
      Key? key})
      : super(key: key);

  @override
  State<BidsList> createState() => _BidsListState();
}

class _BidsListState extends State<BidsList> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<BidsProvider>(context, listen: false).getAllBids();
    });
    start();
  }

  Timer? timer;

  void start() {
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      // addItem("Item ${items.length + 1}");
      Provider.of<BidsProvider>(context, listen: false).getAllBids();
    });
  }

  void declineBid(int id) async {
    var url = Uri.parse(
        Palette.baseUrl + Palette.declineBidUrl + "?bid_id=" + id.toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });
    var responseData = json.decode(response.body);

    print(responseData);
    totalBids--;
  }

  void acceptBid(int id, int rideId) async {
    var url = Uri.parse(
        Palette.baseUrl + Palette.acceptBidUrl + "?bid_id=" + id.toString());

    var response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
    });

    // updateRiderState(rideId);
    var responseData = json.decode(response.body);

    print(responseData);
  }

  // void updateRiderState(int riderId) async {
  //   var url = Uri.parse(Palette.baseUrl + Palette.userStateUpdateUrl);

  //   var response = await http.post(url,
  //       body: jsonEncode({
  //         'user_id': riderId.toString(),
  //         'status': "1",
  //       }),
  //       headers: {
  //         HttpHeaders.contentTypeHeader: "application/json",
  //         HttpHeaders.acceptHeader: "application/json",
  //         HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
  //       });
  //   updateRiderState(riderId);
  //   var responseData = json.decode(response.body);
  //   print(response.body);
  //   // if (response.statusCode == 201) {}
  // }

  void deleteOffer() async {
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
  }

  void initRide(int offerId, int riderId, int counterOffer) async {
    var url = Uri.parse(Palette.baseUrl + Palette.initialRideUrl);

    var response = await http.post(url,
        body: jsonEncode({
          'user_id': box.read('userId'),
          'rider_id': riderId.toString(),
          'pickup_location': widget.pick,
          'pickup_latitude': widget.lat,
          'pickup_longitude': widget.lng,
          'drop_off_location': widget.drop,
          'drop_off_latitude': widget.lat2,
          'drop_off_longitude': widget.lng2,
          'status': 1,
          'fare': counterOffer,
          'distance': widget.distance,
          'discount': 0.0,
          'payment_method_id': 1,
          'estimated_time': widget.time,
          'offer_id': offerId,
        }),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer " + box.read('token')
        });
    var responseData = json.decode(response.body);
    box.write('rideId', responseData['id']);
    box.write('riderId', riderId);

    print(responseData);
    deleteOffer();
  }

  void goBack() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context, 1);
    });
  }

  int totalBids = 0;

  // void delayFunction(int time, String fun) {
  //   Future.delayed(Duration(seconds: time), () {
  //     // getOffers();
  //     fun;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double bodyWidth = MediaQuery.of(context).size.width;
    double bodyHeight = MediaQuery.of(context).size.height;

    return Consumer<BidsProvider>(
      builder: (context, value, child) {
        // If the loading it true then it will show the circular progressbar
        if (value.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // If loading is false then this code will show the list of todo item
        final dataResponse = value.bids;
        return ListView.builder(
          itemCount: dataResponse.length,
          itemBuilder: (context, index) {
            int gotBids = dataResponse.length;
            if (gotBids > totalBids) {
              FlutterRingtonePlayer.playNotification();
              totalBids = gotBids;
            }

            final data = dataResponse[index];
            return Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                          top: 5, right: 15, left: 15, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/loading.gif',
                                    image: Palette.imgUrl + data.riderProfile,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 150,
                                // color: Colors.red,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.riderName,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      data.vehicleNumber,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "PKR " + data.counterOffer.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    color: Palette.primaryColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 5, right: 15, left: 15, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/images/star.png"),
                                backgroundColor: Colors.white,
                                radius: 12,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                data.stars.toString() +
                                    " (" +
                                    data.totalReviews.toString() +
                                    ")",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    data.distance,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    data.time,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 2, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            minWidth: 60,
                            height: 40,
                            color: Colors.red,
                            onPressed: () {
                              declineBid(data.id);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              "Decline",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ),
                          MaterialButton(
                            minWidth: 60,
                            height: 40,
                            color: Palette.primaryColor,
                            onPressed: () {
                              // status = 1;
                              // goback();
                              ShowResponse("Loading", context);
                              acceptBid(data.id, data.riderId);
                              initRide(
                                  data.id, data.riderId, data.counterOffer);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              "Accept",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.black),
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
      },
    );
  }
}
