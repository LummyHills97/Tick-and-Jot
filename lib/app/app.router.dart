import 'package:flutter/material.dart';
import '../ui/views/home/home_view.dart';

class Routes {
  static const String homeView = '/home';
  static const String startup = '/';
}

class StackedRouter {
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.startup:
      case Routes.homeView:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const HomeView(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const HomeView(),
          settings: settings,
        );
    }
  }
}