import 'package:doodh_app/Routes%20Service/route_name.dart';
import 'package:doodh_app/Screens/add_entry_screen.dart';
import 'package:doodh_app/Screens/add_khata_screen.dart';
import 'package:doodh_app/Screens/entry_screen.dart';
import 'package:doodh_app/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case RouteName.addKhataScreen:
        return MaterialPageRoute(builder: (context) => const AddKhataScreen());

      case RouteName.entryScreen:
        return MaterialPageRoute(
            builder: (context) => EntryScreen(date: settings.arguments as Map));

      case RouteName.addEntryScreen:
        return MaterialPageRoute(builder: (context) => const AddEntryScreen());

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('No Route Defined'),
            ),
          ),
        );
    }
  }
}
