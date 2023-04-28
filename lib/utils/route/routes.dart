import 'package:flutter/material.dart';
import 'package:rider/utils/route/routes_name.dart';
import 'package:rider/view/commission.dart';
import 'package:rider/view/login.dart';
import 'package:rider/view/profile.dart';

import '../../view/dashboard_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.commissionScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Commission());
      case RoutesName.profileScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Profile());
      case RoutesName.loginScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Login());
      case RoutesName.dashboardScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const DashboardScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
