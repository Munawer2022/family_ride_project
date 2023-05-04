import 'package:flutter/material.dart';

import 'package:rider/resources/font.dart';
import 'package:rider/utils/route/routes.dart';
import 'package:rider/utils/route/routes_name.dart';

import 'config/palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      // darkTheme: ThemeData.dark(useMaterial3: true),
      theme: ThemeData(
        // scaffoldBackgroundColor: Palette.primaryColor.withOpacity(0.1),
        // colorSchemeSeed: Colors.grey.shade200,
        fontFamily: fonts.firstfont,
        useMaterial3: true,
      ),
      initialRoute: RoutesName.loginScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
