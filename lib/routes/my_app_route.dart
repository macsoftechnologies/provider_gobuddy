
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:gobuddy/pages/splash/splash_screen.dart';
import 'package:gobuddy/pages/onboard/onboard_screen.dart';
import 'package:gobuddy/pages/authentication/login/login_screen.dart';
import 'package:gobuddy/pages/authentication/signup/signup_screen.dart';
import 'package:gobuddy/utils/config.dart';
import 'package:gobuddy/utils/my_colors.dart';

import '../pages/account/accountItems/mySubscription/create_package_screen.dart';
import '../pages/account/accountItems/mySubscription/my_subscriptions.dart';
import '../pages/account/accountItems/mySubscription/subscriptions.dart';
import '../pages/account/accountItems/mySubscription/summary_screen.dart';
import '../pages/account/accountItems/mySubscription/technician_services_prices.dart';
import '../pages/account/accountItems/privacyPolicy/privacy_policy.dart';
import '../pages/account/accountItems/referAndEarn/refer_earn.dart';
import '../pages/account/accountItems/requestTool/request_tool_page.dart';
import '../pages/account/accountItems/support/support_screen.dart';
import '../pages/account/accountItems/termsAndConditions/terms_conditions.dart';
import '../pages/account/accountItems/viewProfile/view_profile.dart';
import '../pages/account/account_screen.dart';
import '../pages/dashboard/dashboard_screen.dart';
import '../pages/displayQRCode/provider_qr_code.dart';
import '../pages/ekycVerification/ekyc_verification.dart';
import '../pages/jobCalendar/create_vacation_days.dart';
import '../pages/notifications/notifications_screen.dart';
import '../pages/orders/job_calendar.dart';
import '../pages/orders/my_orders.dart';
import '../pages/orders/order_details.dart';
import '../pages/otpVerification/otp_verification.dart';
import '../pages/paymentGateway/payment_screen.dart';
import '../pages/ratings/customer_ratings.dart';
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

        Config.accountRouteName: (ctx) =>  AccountPage(),
        Config.viewProfileRouteName: (ctx) =>  ViewProfilePage(),
        Config.mySubscriptionsRouteName: (ctx) =>  SubscriptionScreen(),
        Config.referEarnRouteName: (ctx) =>  ReferAndEarnPage(), //requestToolRouteName
        Config.requestToolRouteName: (ctx) =>  RequestToolScreen(),
        //Config.myOrdersRouteName: (ctx) =>  MyOrdersScreen(),
        Config.myOrdersRouteName: (ctx) =>  MyOrdersScreen(),
        Config.orderDetailsRouteName: (ctx) =>  OrderDetailsScreen(),//
        Config.jobCalendarRouteName: (ctx) =>  JobCalendarScreen(),//JobCalendarScreen
        Config.notificationsRouteName: (ctx) =>  NotificationsScreen(),
        Config.customerReviewsRouteName: (ctx) =>  CustomerReviewsScreen(),//customerReviewsRouteName
        Config.showQRCodeRouteName: (ctx) =>  MyQRCodeScreen(),
        Config.createVacationRouteName: (ctx) =>  SetOnVacationScreen(),
        Config.termsConditionsRouteName: (ctx) =>  TermsAndConditionsScreen(),
        Config.privacyPolicyRouteName: (ctx) =>  PrivacyAndPolicyScreen(),
        Config.supportRouteName: (ctx) =>  SupportScreen(),
        Config.createPackageRouteName: (ctx) =>  CreatePackageScreen(),
        Config.planSummaryRouteName: (ctx) =>  SummaryScreen(),

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
              userid:args['user_id'] ?? '4361',
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

        if (settings.name == Config.technicianServicesPricesRouteName) {
          final args = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(
            builder: (_) => TechnicianServicesPrices(
              categoryName: args ,
              planType: args['planType'] ?? '',

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