import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../config/palette.dart';
import 'bids_model.dart';

class BidsService {
  final box = GetStorage();
  Future<List<BidsModel>> getAll() async {
    String url = Palette.baseUrl +
        Palette.getBidUrl +
        '?offer_id=' +
        box.read('offerId').toString() +
        '&user_latitude=' +
        box.read('lat') +
        '&user_longitude=' +
        box.read('lng');
    final uri = Uri.parse(
      url,
    );
    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + box.read('token'),
    });

    print(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      final data = json.map((e) {
        return BidsModel(
          id: e['bid']['id'],
          counterOffer: e['bid']['counter_offer'],
          riderId: e['bid']['rider_id'],
          riderName: e['bid']['rider_name'],
          vehicleType: e['bid']['vehicle_type'],
          vehicleNumber: e['bid']['vehicle_number'],
          distance: e['distance'],
          time: e['time'],
          stars: e['avg_stars'],
          totalReviews: e['reviews_count'],
          riderProfile:
              e['rider_profile_img']['profile'].toString() == "NULL" ||
                      e['rider_profile_img']['profile'].toString() == ""
                  ? e['rider_profile_img']['profile']
                  : "default.png",
        );
      }).toList();
      return data;
    }
    return [];
  }
}
