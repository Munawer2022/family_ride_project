import 'package:flutter/material.dart';
import 'package:rider/resources/components/card_component.dart';
import 'package:rider/resources/components/appbar.dart';
import 'package:rider/resources/images.dart';

import 'package:rider/resources/padding.dart';

import '../resources/components/lisview_component.dart';
import '../utils/route/routes_name.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: MyAppBarWidget(
          title: 'Dashboard',
          ontap: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.profileScreen);
                },
                icon: const Icon(Icons.person_pin))
          ],
        ),
        body: Padding(
          padding: screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // width: double.infinity,
              //     height: size.height * 0.3,
              GridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                children: [
                  CardComponent(
                      color: Colors.blue,
                      containerText: 'A',
                      titleText: 'Active Riders',
                      subTitleText: '50',
                      shadeColor: Colors.blue.shade50),
                  CardComponent(
                      color: Colors.red,
                      containerText: 'O',
                      titleText: 'OFF Riders',
                      subTitleText: '70',
                      shadeColor: Colors.red.shade50),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Card(
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.commissionScreen);
                    },
                    title: const Text('Commision'),
                    subtitle: const Text('Earned'),
                    trailing: const Text(
                      'Rs: 100',
                    )),
              ),
              ListTile(
                title: Text('Rider/Driver List',
                    style: theme.textTheme.titleMedium?.copyWith(
                      // fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Card(
                      child: ListTile(
                        dense: false,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            SizedBox(
                              height: size.height * 0.005,
                            ),
                            Image.asset(
                              car,
                              scale: 7,
                            )
                          ],
                        ),
                        // leading: Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "Rs " + "100",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 14,
                        //           color: Colors.grey),
                        //     ),
                        //     SizedBox(
                        //       height: 2,
                        //     ),
                        //     Text(
                        //       '1 he',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 14,
                        //           color: Colors.black),
                        //     ),
                        //   ],
                        // ),
                        title: const Text('Rider ID'),
                        subtitle: const Text('Rider Name'),

                        // title: Text(
                        //   "pickup",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w400,
                        //       fontSize: 16,
                        //       color: Colors.black),
                        // ),
                        // subtitle: Padding(
                        //   padding: EdgeInsets.only(top: 5),
                        //   child: Text(
                        //     "drop",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.w400,
                        //         fontSize: 14,
                        //         color: Colors.grey),
                        //   ),
                        // ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        dense: false,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            SizedBox(
                              height: size.height * 0.005,
                            ),
                            Image.asset(
                              ac_car,
                              scale: 7,
                            )
                          ],
                        ),
                        // leading: Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "Rs " + "100",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 14,
                        //           color: Colors.grey),
                        //     ),
                        //     SizedBox(
                        //       height: 2,
                        //     ),
                        //     Text(
                        //       '1 he',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 14,
                        //           color: Colors.black),
                        //     ),
                        //   ],
                        // ),
                        // title: Text(
                        //   "pickup",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w400,
                        //       fontSize: 16,
                        //       color: Colors.black),
                        // ),
                        // subtitle: Padding(
                        //   padding: EdgeInsets.only(top: 5),
                        //   child: Text(
                        //     "drop",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.w400,
                        //         fontSize: 14,
                        //         color: Colors.grey),
                        //   ),
                        // ),
                        title: const Text('Rider ID'),
                        subtitle: const Text('Rider Name'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        dense: false,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            SizedBox(
                              height: size.height * 0.005,
                            ),
                            Image.asset(
                              bike,
                              scale: 7,
                            )
                          ],
                        ),
                        // leading: Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "Rs " + "100",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 14,
                        //           color: Colors.grey),
                        //     ),
                        //     SizedBox(
                        //       height: 2,
                        //     ),
                        //     Text(
                        //       '1 he',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 14,
                        //           color: Colors.black),
                        //     ),
                        //   ],
                        // ),
                        // title: Text(
                        //   "pickup",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w400,
                        //       fontSize: 16,
                        //       color: Colors.black),
                        // ),
                        // subtitle: Padding(
                        //   padding: EdgeInsets.only(top: 5),
                        //   child: Text(
                        //     "drop",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.w400,
                        //         fontSize: 14,
                        //         color: Colors.grey),
                        //   ),
                        // ),
                        title: const Text('Rider ID'),
                        subtitle: const Text('Rider Name'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        dense: false,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            SizedBox(
                              height: size.height * 0.005,
                            ),
                            Image.asset(
                              rakhsha,
                              scale: 7,
                            )
                          ],
                        ),
                        // leading: Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       "Rs " + "100",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 14,
                        //           color: Colors.grey),
                        //     ),
                        //     SizedBox(
                        //       height: 2,
                        //     ),
                        //     Text(
                        //       '1 he',
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 14,
                        //           color: Colors.black),
                        //     ),
                        //   ],
                        // ),
                        // title: Text(
                        //   "pickup",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w400,
                        //       fontSize: 16,
                        //       color: Colors.black),
                        // ),
                        // subtitle: Padding(
                        //   padding: EdgeInsets.only(top: 5),
                        //   child: Text(
                        //     "drop",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.w400,
                        //         fontSize: 14,
                        //         color: Colors.grey),
                        //   ),
                        // ),
                        title: const Text('Rider ID'),
                        subtitle: const Text('Rider Name'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
