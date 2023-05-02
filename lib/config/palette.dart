import 'package:flutter/material.dart';

class Palette {
  static const Color primaryColor = Color(0xFF8CD14E);
  static const Color secondaryColor = Color(0xFFCD5C5C);
  static const Color IconColour = Color(0xFFA3A3A4);
  static const Color DefaultIconColour = Color(0xFF848484);
  static const Color DefaultBackgroundColour = Color(0xFFFEFEFE);
  static const Color lightGrey = Color(0xffE2E3E5);
  static const Color white = Color(0xFFFFFFFF);

  static const String baseUrl = "https://blockchainride.pk/public/api/";
  static const String imgUrl = "https://blockchainride.pk/public/rider_data/";
  static const String defaultImg = "default.png";

  static const String toggleUser = "update-user-type";
  static const String checkMobile = "check-user-number";
  static const String registerUrl = "register";
  static const String loginUrl = "login";
  static const String updateUserUrl = "update/user";
  static const String getUserProfile = "get/user";
  static const String userStateUpdateUrl = "user-state/update";
  static const String getAllOffersUrl = "fetch-offers";
  static const String storeOfferUrl = "send/offer";
  static const String deleteOfferUrl = "delete/offers";
  static const String sendBidUrl = "store-bid";
  static const String updateDeclineBidUrl = "update-declined-bid";
  static const String getBidUrl = "get-bids";
  static const String getDeclinedBidUrl = "get-declined-bids";
  static const String declineBidUrl = "decline-bid";
  static const String acceptBidUrl = "accept-bid";
  static const String initialRideUrl = "store/initial/ride";
  static const String isRideInitiated = "check-ride-initiated";
  static const String endRideUrl = "store/end/ride";
  static const String getRideUrl = "ride/view";
  static const String getAllRideUrl = "get-all-rides";
  static const String updateRideUrl = "update-ride-status";
  static const String getRideStatusUrl = "get-ride-status";
  static const String updateIamArrivedUrl = "update/is-arrived";
  static const String checkEarningUrl = "rider-rides-count";

  static const String checkUpdateUrl = "update-available";
}
