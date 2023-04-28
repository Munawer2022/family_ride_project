import 'package:flutter/material.dart';
import 'package:rider/resources/images.dart';
import 'package:rider/resources/padding.dart';

import '../resources/components/text_field.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: screenPadding.copyWith(left: 30.0, right: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logoImage,
              scale: 20,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Login',
                style: theme.textTheme.headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            const TextFieldComponent(
                validator: null,
                controller: null,
                keyboardType: TextInputType.number,
                hintText: 'Mobile Number'),
            SizedBox(
              height: size.height * 0.02,
            ),
            const TextFieldComponent(
                validator: null,
                controller: null,
                keyboardType: TextInputType.number,
                hintText: 'Activation Code'),
            SizedBox(
              height: size.height * 0.05,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Login',
                      ))),
            )
          ],
        ),
      ),
    ));
  }
}
