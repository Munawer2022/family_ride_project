import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:http/http.dart' as http;

import '../config/palette.dart';
import '../resources/components/appbar.dart';
import '../resources/components/lisview_component.dart';
import '../resources/widgets/drawer_widget.dart';
import 'history_detail.dart';

class Commission extends StatefulWidget {
  Commission({Key? key}) : super(key: key);
  @override
  State<Commission> createState() => _CommissionState();
}

class _CommissionState extends State<Commission> {
  final box = GetStorage();
  TextEditingController pickController = new TextEditingController();
  TextEditingController dropController = new TextEditingController();

  void dialog() {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: "Do you want to rate the ride?s",
        title: "Ride Completed",
        context: context,
        actions: [
          IconsButton(
            onPressed: () async {
              Navigator.pop(context);
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
            },
            text: "No",
            iconData: Icons.cancel,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.black),
            iconColor: Colors.white,
          ),
        ]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double bodyWidth = MediaQuery.of(context).size.width;
    double bodyHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBarWidget(
          ontap: null,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: 'Commission',
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                    child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                      ListViewComponent(
                          title: Text('Date'),
                          subtitle: Text('Rs: 100'),
                          trailing: Text('Type')),
                      ListViewComponent(
                          title: Text('Date'),
                          subtitle: Text('Rs: 100'),
                          trailing: Text('Type')),
                      ListViewComponent(
                          title: Text('Date'),
                          subtitle: Text('Rs: 100'),
                          trailing: Text('Type')),
                      // Card(
                      //   child: ListTile(
                      //     dense: false,
                      //     trailing: Text(
                      //       "Canceled",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w800,
                      //           fontSize: 13,
                      //           color: Colors.green),
                      //     ),
                      //     leading: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Rs " + "100",
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w800,
                      //               fontSize: 14,
                      //               color: Colors.grey),
                      //         ),
                      //         SizedBox(
                      //           height: 2,
                      //         ),
                      //         Text(
                      //           '1 he',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w800,
                      //               fontSize: 14,
                      //               color: Colors.black),
                      //         ),
                      //       ],
                      //     ),
                      //     title: Text(
                      //       "pickup",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 16,
                      //           color: Colors.black),
                      //     ),
                      //     subtitle: Padding(
                      //       padding: EdgeInsets.only(top: 5),
                      //       child: Text(
                      //         "drop",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w400,
                      //             fontSize: 14,
                      //             color: Colors.grey),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Card(
                      //   child: ListTile(
                      //     dense: false,
                      //     trailing: Text(
                      //       "Canceled",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w800,
                      //           fontSize: 13,
                      //           color: Colors.green),
                      //     ),
                      //     leading: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Rs " + "100",
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w800,
                      //               fontSize: 14,
                      //               color: Colors.grey),
                      //         ),
                      //         SizedBox(
                      //           height: 2,
                      //         ),
                      //         Text(
                      //           '1 he',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w800,
                      //               fontSize: 14,
                      //               color: Colors.black),
                      //         ),
                      //       ],
                      //     ),
                      //     title: Text(
                      //       "pickup",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 16,
                      //           color: Colors.black),
                      //     ),
                      //     subtitle: Padding(
                      //       padding: EdgeInsets.only(top: 5),
                      //       child: Text(
                      //         "drop",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w400,
                      //             fontSize: 14,
                      //             color: Colors.grey),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Card(
                      //   child: ListTile(
                      //     dense: false,
                      //     trailing: Text(
                      //       "Canceled",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w800,
                      //           fontSize: 13,
                      //           color: Colors.green),
                      //     ),
                      //     leading: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Rs " + "100",
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w800,
                      //               fontSize: 14,
                      //               color: Colors.grey),
                      //         ),
                      //         SizedBox(
                      //           height: 2,
                      //         ),
                      //         Text(
                      //           '1 he',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w800,
                      //               fontSize: 14,
                      //               color: Colors.black),
                      //         ),
                      //       ],
                      //     ),
                      //     title: Text(
                      //       "pickup",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 16,
                      //           color: Colors.black),
                      //     ),
                      //     subtitle: Padding(
                      //       padding: EdgeInsets.only(top: 5),
                      //       child: Text(
                      //         "drop",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w400,
                      //             fontSize: 14,
                      //             color: Colors.grey),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Items {
  final int id;
  final int rider_id;
  final String pickup_location;
  final String drop_off_location;
  final int status;
  final int fare;
  final String created_at;
  Items(
    this.id,
    this.rider_id,
    this.pickup_location,
    this.drop_off_location,
    this.status,
    this.fare,
    this.created_at,
  );
}
