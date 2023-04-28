import 'package:flutter/material.dart';
import 'package:rider/resources/padding.dart';
import 'package:rider/resources/components/text_field.dart';

import '../resources/components/appbar.dart';
import '../resources/images.dart';
import '../utils/route/routes_name.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: appBar(
          Image.asset(
            profilescreen_familyImage,
            scale: 15,
          ),
          [
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.loginScreen);
                },
                child: const Text('Logout'))
          ],
          true),
      body: Padding(
        padding: screenPadding.copyWith(left: 30.0, right: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile',
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
                keyboardType: TextInputType.text,
                hintText: 'Name'),
            SizedBox(
              height: size.height * 0.02,
            ),
            const TextFieldComponent(
                validator: null,
                controller: null,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email'),
            SizedBox(
              height: size.height * 0.02,
            ),
            const TextFieldComponent(
                validator: null,
                controller: null,
                keyboardType: TextInputType.number,
                hintText: 'Activation Code'),
            SizedBox(
              height: size.height * 0.02,
            ),
            const TextFieldComponent(
                validator: null,
                controller: null,
                keyboardType: TextInputType.number,
                hintText: 'Referral Code'),
          ],
        ),
      ),
    ));
  }
}
