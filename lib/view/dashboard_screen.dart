import 'package:flutter/material.dart';
import 'package:rider/resources/components/card_component.dart';
import 'package:rider/resources/components/appbar.dart';
import 'package:rider/resources/components/listview_card_component.dart';
import 'package:rider/resources/images.dart';

import 'package:rider/resources/padding.dart';

import '../config/palette.dart';
import '../resources/components/lisview_component.dart';
import '../utils/route/routes_name.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double bodyWidth = double.infinity;
    double bodyHeight = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
        body: Container(
          color: Palette.primaryColor.withOpacity(0.1),
          width: bodyWidth,
          height: bodyHeight,
          child: Padding(
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
                InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.commissionScreen);
                    },
                    child: ListViewComponent(
                        title: Text('Commission'),
                        subtitle: Text('Earned'),
                        trailing: Text('Rs: 100'))),
                // Card(
                //   child: ListTile(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       onTap: () {
                //         Navigator.pushNamed(context, RoutesName.commissionScreen);
                //       },
                //       title: const Text('Commision'),
                //       subtitle: const Text('Earned'),
                //       trailing: const Text(
                //         'Rs: 100',
                //       )),
                // ),
                ListTile(
                  title: Text('Rider/Driver List',
                      style: theme.textTheme.titleMedium?.copyWith(
                        // fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Expanded(
                  child: Column(
                    // physics: const NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    children: [
                      ListViewCard(iamge: car),
                      ListViewCard(iamge: ac_car),
                      ListViewCard(iamge: bike),
                      ListViewCard(iamge: rakhsha),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
