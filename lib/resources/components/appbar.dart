import 'package:flutter/material.dart';

appBar(dynamic text, dynamic ontap, dynamic bool) {
  return AppBar(
    automaticallyImplyLeading: bool,
    actions: ontap,
    backgroundColor: Colors.transparent,
    title: text,
  );
}
