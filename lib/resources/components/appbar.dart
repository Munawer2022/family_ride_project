import 'package:flutter/material.dart';

// appBar(dynamic text, dynamic ontap, dynamic bool) {
//   return AppBar(
//     automaticallyImplyLeading: bool,
//     actions: ontap,
//     backgroundColor: Colors.transparent,
//     title: text,
//   );
// }

class MyAppBarWidget extends StatelessWidget implements PreferredSize {
  final title;
  final ontap;

  final leading;
  const MyAppBarWidget({super.key, this.title, this.ontap, this.leading});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      actions: ontap,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Text(title),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
