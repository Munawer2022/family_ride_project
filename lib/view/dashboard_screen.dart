import 'package:flutter/material.dart';
import 'package:rider/resources/components/card_component.dart';
import 'package:rider/resources/components/appbar.dart';

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
        // appBar(
        //     const Text(
        //       'Dashboard',
        //     ),
        //     [
        //       IconButton(
        //           onPressed: () {
        //             Navigator.pushNamed(context, RoutesName.profileScreen);
        //           },
        //           icon: const Icon(Icons.person_pin))
        //     ],
        //     false),
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
                    ListViewComponent(
                      title: const Text('Rider ID'),
                      subtitle: const Text('Rider Name'),
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
                          Icon(
                            Icons.pedal_bike_outlined,
                            size: size.height * 0.04,
                          ),
                        ],
                      ),
                    ),
                    ListViewComponent(
                      title: const Text('Rider ID'),
                      subtitle: const Text('Rider Name'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          Icon(
                            Icons.car_repair,
                            size: size.height * 0.04,
                          ),
                        ],
                      ),
                    ),
                    ListViewComponent(
                      title: const Text('Rider ID'),
                      subtitle: const Text('Rider Name'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          Icon(
                            Icons.electric_bike_sharp,
                            size: size.height * 0.04,
                          ),
                        ],
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
