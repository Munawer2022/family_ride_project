import 'package:flutter/material.dart';

import 'package:rider/resources/padding.dart';
import 'package:rider/view/dashboard_screen.dart';

class CardComponent extends StatelessWidget {
  final color;
  final shadeColor;
  final containerText;
  final titleText;
  final subTitleText;
  const CardComponent(
      {super.key,
      required this.color,
      required this.containerText,
      required this.titleText,
      required this.subTitleText,
      required this.shadeColor});
//  height: size.height * 1 / 5,
//         width: size.width * 1 / 3,
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
        child: Padding(
          padding: screenPadding.copyWith(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: shadeColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Container(
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            containerText,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )),
                  )),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(titleText, style: theme.textTheme.titleMedium),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(subTitleText,
                  style: theme.textTheme.headline6?.copyWith(
                    // color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
