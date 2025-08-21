
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:gobuddy/pages/splash/splash_screen.dart';
import 'package:gobuddy/pages/onboard/onboard_screen.dart';
import 'package:gobuddy/pages/authentication/login/login_screen.dart';
import 'package:gobuddy/pages/authentication/signup/signup_screen.dart';
import 'package:gobuddy/utils/config.dart';
import 'package:gobuddy/utils/my_colors.dart';

class MyAppRoute extends StatefulWidget {
  const MyAppRoute({super.key});

  @override
  State<MyAppRoute> createState() => MyAppRouteState();
}

class MyAppRouteState extends State<MyAppRoute> {
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Config.appName,
      initialRoute: Config.splashRouteName,
      theme: ThemeData(
        primaryColor: HexColor(MyColors.colorPrimary),
       
        fontFamily: Config.fontFamilyPoppinsRegular,
        appBarTheme: AppBarTheme(
          backgroundColor: HexColor(MyColors.navColor),
        ),
      ),
      routes: {

        Config.splashRouteName: (ctx) =>  SplashScreen(),
        Config.onBoardRouteName: (ctx) => OnBoardScreen(),
        Config.loginRouteName: (ctx) =>  LoginScreen(),
        Config.registrationRouteName: (ctx) => SignupScreen(),
        // Config.viewMemRouteName: (ctx) => const ViewMemberScreen()


      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      },
    );
  }
}