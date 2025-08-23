
import 'package:flutter/material.dart';
import 'package:gobuddy/routes/my_app_route.dart';
import 'package:gobuddy/data/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initSharedPreference();
  runApp(const MyAppRoute());
}

