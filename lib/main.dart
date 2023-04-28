import 'package:flutter/material.dart';
import 'package:rider/resources/font.dart';
import 'package:rider/utils/route/routes.dart';
import 'package:rider/utils/route/routes_name.dart';

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
      theme: ThemeData(
        colorSchemeSeed: Colors.grey.shade200,
        fontFamily: firstfont,
        useMaterial3: true,
      ),
      initialRoute: RoutesName.dashboardScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}