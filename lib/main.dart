import 'package:flutter/material.dart';
import 'package:providerapp_gobuddy/screens/Instructions_one.dart';
import 'package:providerapp_gobuddy/screens/dashboardpage.dart';
import 'package:providerapp_gobuddy/screens/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      title: 'Flutter Demo',
      theme: ThemeData(
      highlightColor: Colors.orange,
        fontFamily: 'Urbanist',
      ),
      home : DashboardPage(),
    );
  }
}


