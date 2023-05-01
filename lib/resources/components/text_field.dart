import 'package:flutter/material.dart';
import 'package:rider/resources/padding.dart';

class TextFieldComponent extends StatelessWidget {
  final validator;
  final controller;
  final keyboardType;
  final hintText;
  final icon;

  const TextFieldComponent({
    super.key,
    required this.validator,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    required this.icon,

    // this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return
        // Container(
        //   decoration: BoxDecoration(
        //     boxShadow: [
        //       BoxShadow(
        //         // color: theme.colorScheme.shadow.withOpacity(0.1),
        //         color: Colors.grey.withOpacity(0.1),
        //         spreadRadius: 2,
        //         blurRadius: 5,
        //         offset: Offset(0, 3),
        //       ),
        //     ],
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        // );
        TextFormField(
      textInputAction: TextInputAction.next,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        icon: icon,
        // contentPadding: const EdgeInsets.all(10),
        // border: const OutlineInputBorder(),
        // enabledBorder: InputBorder.none,
        // fillColor: theme.backgroundColor,
        // filled: false,
        hintText: hintText,
        // labelText: hintText,
      ),
    );
  }
}
