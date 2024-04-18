import 'package:flutter/material.dart';
import 'package:example/utils/routes/route_name.dart';
import 'package:example/view/login_view.dart';
import 'package:example/view/signup_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.loginScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginView());
      case RouteNames.signUpScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUpView());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Text("No Route"),
          );
        });
    }
  }
}
