import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../images.dart';

class ListViewCard extends StatelessWidget {
  final iamge;
  const ListViewCard({super.key, required this.iamge});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(143, 148, 251, .2),
              blurRadius: 20.0,
              offset: Offset(0, 10))
        ],
      ),
      child: Card(
        elevation: 0,
        child: ListTile(
          dense: false,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(50)),
              ),
              SizedBox(
                height: size.height * 0.005,
              ),
              Image.asset(
                iamge,
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
    );
  }
}
