import "package:flutter/material.dart";

class CustomTextField extends StatelessWidget {
  String label, placeholder, errorText;
  TextEditingController controller;
  bool isValid, enabled;
  TextInputType textType;
  CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.isValid,
    required this.errorText,
    this.enabled = true,
    this.textType = TextInputType.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.black),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(143, 148, 251, .2),
                  blurRadius: 20.0,
                  offset: Offset(0, 10))
            ],
          ),
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 5),
            child: TextField(
              enabled: enabled,
              controller: controller,
              keyboardType: textType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          child: AnimatedOpacity(
            opacity: isValid ? 0 : 1,
            duration: Duration(milliseconds: 200),
            child: Text(
              errorText,
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 12, color: Colors.red),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
