import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_faq/flutter_faq.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../config/palette.dart';

class Faqs extends StatefulWidget {
  const Faqs({super.key});

  @override
  State<Faqs> createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  // void sendMessage() async {
  //   var url = Uri.parse("https://familyride.pk/public/api/message-store");

  //   var response = await http.post(url,
  //       body: jsonEncode({
  //         'rider_id': '70',
  //         'ride_id': '1',
  //         'message': messageController.text,
  //       }),
  //       headers: {
  //         HttpHeaders.contentTypeHeader: "application/json",
  //         HttpHeaders.acceptHeader: "application/json",
  //         HttpHeaders.authorizationHeader:
  //             "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiY2Y4NTNhN2ZlNjMyZTkzMGQ3NjNhYmZlMGMyM2Q1ZGQ5NWU5MWY4ZGRiYTI2YzI3MmQwMDQ1NTlkNTZiN2E5YWMxZWMwZGMyZWE4ZjNiYzYiLCJpYXQiOjE2NzQ3MzYyMDMuMDQ0MDc1LCJuYmYiOjE2NzQ3MzYyMDMuMDQ0MDc3LCJleHAiOjE3MDYyNzIyMDMuMDQwODg4LCJzdWIiOiI2OCIsInNjb3BlcyI6W119.QF9_1p5E0A1bkQY3jNkXE_jI_1F38LMlUxCyHfU4DEn-2lkCDpSZv-vqooGecQ_6CroBji2Ut40Ng-tjFntBIEuKEdHjX2ooBWy_BPtT7eYkVwYLIihSa6gAGQk2BhvSVL4VP9k4mm2pr9bK6IR0PCNz_ZMmo5rfJr-hhuwPc1bT7ZQSBY69ECDlm0_x3t7r9LCOc6cZ7JJ3z32W-eOkSNc7TLz4MnbThpyAujOo4xRQdz7BG9IpgC-1KLHjErmJWXc6D5D9I_31rdG4z3V8fFDVD5JPoOI-tNXw84lAMerr5PCc4x6aurZ2lUm2AsJ5yYthtFk0oXPISzOeh3jGcc6JnwZhRceP0lIeRLA6BV8c-r_w3MGmPsbev88pNk9MN_11U68QA0RA4nHXBWwEMKT_Fk4A9oG7Zj5RVlEpuxYEVWzu4FpS2SraSqIbiGIIKpt1mEzdhC2Vix0ciaSELoVrlkoiFPkLHaXnvA83MKu2hweIf4Pf0fujkzvxbnlbl_STK_CVxWPqD3zxhhzZsd-nNpZiILQnEPiIA_C4KxijMjScS3g9PDZJuGuQNq9KVCldncGuenQgEdekUDMxGyS2qxC4eWTBCO0RrUD2c3Ro_cdU6bCjsU-AS-RKMPyIrzRFAsNphwi-Q5ks9MfKGnci4MWgZ5KAqDOVt0CePVs"
  //       });

  //   var responseData = jsonDecode(response.body);
  //   print(responseData);

  //   // print(responseData);
  //   // Navigator.pop(context);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Provider.of<getMessageProvider>(context, listen: false).getAllMessages();
  //   });
  //   start();
  // }

  // Timer? timer;

  // void start() {
  //   timer = Timer.periodic(Duration(seconds: 5), (timer) {
  //     // addItem("Item ${items.length + 1}");
  //     Provider.of<getMessageProvider>(context, listen: false).getAllMessages();
  //   });
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   Provider.of<getMessageProvider>(context, listen: false).getAllMessages();
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          actions: [],
          elevation: 0,
          title: Text(
            'Faqs',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FAQ(
                question: "How to contact us?",
                queStyle: const TextStyle(color: Colors.black, fontSize: 15),
                ansStyle: const TextStyle(color: Colors.black, fontSize: 15),
                answer:
                    "you can contact us using followings:\n\nMobile: +92 300 2486212\nEmail: support@familyride.pk",
                ansDecoration: BoxDecoration(
                    color: Colors.grey[550],
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                queDecoration: BoxDecoration(
                    color: Palette.primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FAQ(
                question: "Is Family Ride free to install?",
                queStyle: const TextStyle(color: Colors.black, fontSize: 15),
                ansStyle: const TextStyle(color: Colors.black, fontSize: 15),
                answer:
                    "Yes it's free to install but customers have to pay for ride services.",
                ansDecoration: BoxDecoration(
                    color: Colors.grey[550],
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                queDecoration: BoxDecoration(
                    color: Palette.primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FAQ(
                question: "How can I earn money with Family Ride",
                queStyle: const TextStyle(color: Colors.black, fontSize: 15),
                ansStyle: const TextStyle(color: Colors.black, fontSize: 15),
                answer:
                    "Yes can earn money with us by signing up as rider/driver and offer ride services.",
                ansDecoration: BoxDecoration(
                    color: Colors.grey[550],
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                queDecoration: BoxDecoration(
                    color: Palette.primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FAQ(
                question: "Do we have a website?",
                queStyle: const TextStyle(color: Colors.black, fontSize: 15),
                ansStyle: const TextStyle(color: Colors.black, fontSize: 15),
                answer: "https://familyride.pk/",
                ansDecoration: BoxDecoration(
                    color: Colors.grey[550],
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                queDecoration: BoxDecoration(
                    color: Palette.primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
              ),
            ),
          ],
        ),
      );
}
