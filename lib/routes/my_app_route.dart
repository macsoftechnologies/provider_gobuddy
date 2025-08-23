
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:gobuddy/pages/splash/splash_screen.dart';
import 'package:gobuddy/pages/onboard/onboard_screen.dart';
import 'package:gobuddy/pages/authentication/login/login_screen.dart';
import 'package:gobuddy/pages/authentication/signup/signup_screen.dart';
import 'package:gobuddy/utils/config.dart';
import 'package:gobuddy/utils/my_colors.dart';

import '../pages/dashboard/dashboard_screen.dart';
import '../pages/ekycVerification/ekyc_verification.dart';
import '../pages/otpVerification/otp_verification.dart';
import '../pages/paymentGateway/payment_screen.dart';
import '../pages/registrationFee/registaration_fee_screen.dart';
import '../pages/registrationFee/registration_success_screen.dart';//OTPVerificationScreen
//EKYCVerificationPage

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
        //OnBoardScreenOne

        Config.splashRouteName: (ctx) => const SplashScreen(),
        Config.onBoardRouteName: (ctx) => OnBoardScreenOne(),
        Config.loginRouteName: (ctx) => LoginScreen(),
        Config.registrationRouteName: (ctx) =>  SignupScreen(),
        Config.ekycRouteName: (ctx) =>  EKYCVerificationPage(),
        Config.regiFeeRouteName: (ctx) =>  RegistrationFeeScreen(),
        Config.regiSuccessRouteName: (ctx) =>  RegistrationSuccessPage(),
        Config.dashboardcRouteName: (ctx) =>  DashboardPage(),
       // Config.otpRouteName: (ctx) =>  OTPVerificationScreen(fromScreen: '',),
        // Config.viewMemRouteName: (ctx) => const ViewMemberScreen()



      },
      // onGenerateRoute: (settings) {
      //   return MaterialPageRoute(
      //     builder: (_) => const SplashScreen(),
      //   );
      // },
      onGenerateRoute: (settings) {
        if (settings.name == Config.otpRouteName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => OTPVerificationScreen(
              phoneNumber: args['phone'] ?? '',
              fromScreen: args['fromScreen'] ?? '',
            ),
          );
        }


        if (settings.name == Config.paymentMethodRouteName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => PaymentMethodScreen(
              amount: args["amount"] ?? 0.0,
              fromScreen: args['fromScreen'] ?? '',

            ),
          );
        }


        // default
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      },
    );
  }
}