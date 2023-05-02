import 'package:flutter/material.dart';

void ShowResponse(String Response, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(Response),
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.black,
  );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
