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
    return Card(
      // elevation: 0,
      // color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(title: title, subtitle: subtitle, trailing: trailing),
      ),
    );
  }
}
