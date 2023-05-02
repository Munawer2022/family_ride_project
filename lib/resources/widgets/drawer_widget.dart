import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import '../../config/palette.dart';
import '../../dashboard/chat_page.dart';
import '../../dashboard/fqs.dart';
import '../../dashboard/index.dart';
import '../../dashboard/safety.dart';
import '../../dashboard/setting.dart';
import '../../view/history.dart';
import '../../view/index.dart';
import '../../view/rider_dahboard/dashboard.dart';
import '../../view/user_profile.dart';

final box = GetStorage();

class DrawerWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  String firstName, mobileNumber, userProfile, pageName;

  DrawerWidget(
      {Key? key,
      required this.scaffoldKey,
      required this.firstName,
      required this.mobileNumber,
      required this.userProfile,
      required this.pageName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    void askLogout() {
      Dialogs.materialDialog(
          color: Colors.white,
          msg: "Do you want to logout Family Ride",
          title: "Confirmation",
          context: context,
          actions: [
            IconsButton(
              onPressed: () async {
                Navigator.pop(context);
                box.erase();
                Future.delayed(const Duration(milliseconds: 200), () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false);
                });
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
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ]);
    }

    void move(Widget pageWidget, String name) {
      scaffoldKey.currentState?.closeDrawer();
      if (name != pageName) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => pageWidget));
      }
    }

    return Drawer(
      child: ListView(
        children: [
          new UserAccountsDrawerHeader(
            accountName: new Text(firstName),
            accountEmail: new Text("Mobile Number: $mobileNumber"),
            currentAccountPicture: InkWell(
              onTap: () {
                move(UserProfile(), "userProfile");
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(Palette.imgUrl + userProfile),
                backgroundColor: Colors.white,
              ),
            ),
            otherAccountsPictures: [
              GestureDetector(
                onTap: () {
                  scaffoldKey.currentState?.closeDrawer();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/cancel.png'),
                            fit: BoxFit.contain)),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              if (box.read('userType') == 2) {
                move(dashboard(), "dashboard");
              } else {
                move(RiderDashboard(), "RiderDashboard");
              }
            },
            child: new ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/home.png"),
                    backgroundColor: Colors.white,
                    radius: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              move(Commission(), "history");
            },
            child: new ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/history.png"),
                    backgroundColor: Colors.white,
                    radius: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Ride History",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              move(safetyPage(id: 1), "safety");
            },
            child: new ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/shield.png"),
                    backgroundColor: Colors.white,
                    radius: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Safety",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              move(Settings(), "settings");
            },
            child: new ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/settings.png"),
                    backgroundColor: Colors.white,
                    radius: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              move(Faqs(), "faqs");
            },
            child: new ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/question.png"),
                    backgroundColor: Colors.white,
                    radius: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "FAQ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              move(ChatPage(), "support");
            },
            child: new ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/support.png"),
                    backgroundColor: Colors.white,
                    radius: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Support",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // box.read('userType') == 2
          //     ? InkWell(
          //         onTap: () {
          //           if (box.read('oldProfile') == 4) {
          //             box.write('userType', 4);
          //             move(RiderDashboard(), "RiderDashboard");
          //           } else {
          //             move(riderRegister(), "riderRegister");
          //           }
          //         },
          //         child: new ListTile(
          //           title: Row(
          //             children: [
          //               CircleAvatar(
          //                 backgroundImage:
          //                     AssetImage("assets/images/helmet.png"),
          //                 backgroundColor: Colors.white,
          //                 radius: 15,
          //               ),
          //               SizedBox(
          //                 width: 5,
          //               ),
          //               Text(
          //                 "Become a rider",
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 15,
          //                     color: Colors.black),
          //               ),
          //             ],
          //           ),
          //         ),
          //       )
          //     : InkWell(
          //         onTap: () {
          //           box.write('oldProfile', 4);
          //           box.write('userType', 2);
          //           move(dashboard(), "dashboard");
          //         },
          //         child: new ListTile(
          //           title: Row(
          //             children: [
          //               CircleAvatar(
          //                 backgroundImage: AssetImage("assets/images/user.png"),
          //                 backgroundColor: Colors.white,
          //                 radius: 15,
          //               ),
          //               SizedBox(
          //                 width: 5,
          //               ),
          //               Text(
          //                 "Switch to user",
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 15,
          //                     color: Colors.black),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),

          InkWell(
            onTap: () {
              // scaffoldKey.currentState?.closeDrawer();
              askLogout();
            },
            child: new ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/shutdown.png"),
                    backgroundColor: Colors.white,
                    radius: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
