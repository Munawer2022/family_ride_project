import 'package:flutter/material.dart';

class ListViewComponent extends StatelessWidget {
  final title;
  final subtitle;

  final trailing;
  const ListViewComponent(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.trailing});

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(8.0),
          child: ListTile(title: title, subtitle: subtitle, trailing: trailing),
        ),
      ),
    );
  }
}
