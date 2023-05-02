import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:rider/dashboard/privacy.dart';
import 'package:rider/dashboard/terms.dart';

import '../resources/widgets/drawer_widget.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final box = GetStorage();
  TextEditingController pickController = new TextEditingController();
  TextEditingController dropController = new TextEditingController();

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

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(
          scaffoldKey: _scaffoldKey,
          firstName: box.read('firstName'),
          mobileNumber: box.read('mobileNumber'),
          userProfile: box.read('userProfile'),
          pageName: "settings"),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.menu)),
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => ChangePassword()));
              //   },
              //   child: Card(
              //     child: ListTile(
              //       dense: true,
              //       title: Text(
              //         "Change Password",
              //         style: TextStyle(
              //             fontWeight: FontWeight.w400,
              //             fontSize: 16,
              //             color: Colors.black),
              //       ),
              //     ),
              //   ),
              // ),

              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PrivacyPolicy()));
                },
                child: Card(
                  child: ListTile(
                    dense: true,
                    title: Text(
                      "Privacy Policy",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Terms()));
                },
                child: Card(
                  child: ListTile(
                    dense: true,
                    title: Text(
                      "Terms and conditions",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),

              // Card(
              //   child: ListTile(
              //     dense: true,
              //     trailing: Text(
              //       "Completed",
              //       style: TextStyle(
              //           fontWeight: FontWeight.w400,
              //           fontSize: 13,
              //           color: Colors.green),
              //     ),
              //     title: Text(
              //       "Theme",
              //       style: TextStyle(
              //           fontWeight: FontWeight.w400,
              //           fontSize: 16,
              //           color: Colors.black),
              //     ),
              //   ),
              // ),
            ],
          ),
        )),
      ),
    );
  }
}
