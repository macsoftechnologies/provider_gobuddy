import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:gobuddy/utils/my_colors.dart';
import 'package:gobuddy/utils/config.dart';
import 'dart:convert';
import 'package:gobuddy/data/preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override

void initState() {
    super.initState();
    Preferences.initSharedPreference();

    startTimer();
  }

  startTimer() {
    var duration = const Duration(
      seconds: 4,
    );
    return Timer(duration, checkConditions);
  }

  checkConditions() {
//  var user = Preferences.getUserDetails();
    // try{
    //   var decoded = json.decode(user!);
    //   final payload = UserL.fromJson(decoded);


    //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    //         MenuScreen()), (Route<dynamic> route) => false);



    // }catch(err){
    //   navigateToLogin();

    // }
    navigateToonBoard();
  }
  //regiFeeRouteName  onBoardRouteName

   void navigateToonBoard() {
    Navigator.of(context).pushReplacementNamed(
      Config.ekycRouteName,
    );
  }


  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(MyColors.white),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Image.asset("assets/images/logo.png"),
          ),
        ),
      ),
    );
  }
}