// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';

import 'package:gobuddy/utils/config.dart';
import 'package:hexcolor/hexcolor.dart';

import 'my_colors.dart';

class UtilClass {
  static Widget getSizedBox(var valueHeight, valueWidth) {
    return SizedBox(height: valueHeight, width: valueWidth);
  }

  static writeLog({
    required Response<dynamic> response,
    required FormData? formValues,
  }) {
    if (kDebugMode) {
      if (formValues != null) {
        log(
          "\n"
          'Response:  ${response.data}',
          name: response.realUri.toString(),
        );
        log("parameteres${formValues.fields}");
      } else {
        log(
          "\n"
          'Response:  ${response.data}',
          name: response.realUri.toString(),
        );
      }
    }
  }

  static Future<bool> checkInternet() async {
    final Connectivity connectivity = Connectivity();
    List<ConnectivityResult> result;
    try {
      result = await connectivity.checkConnectivity();
      return true;
    } on PlatformException {
      return false;
    }
  }

  static showProgress({required BuildContext context}) {
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    SVProgressHUD.show(status: Config.pleaseWait);
  }

  static hideProgress({BuildContext? context}) {
    SVProgressHUD.dismiss();
  }

  static showAlertDialog({
    required BuildContext context,
    required String? message,
    Function()? onOkClick,
  }) {
    UtilClass.hideProgress(context: context);
    Dialog alertDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                color: HexColor(MyColors.darkIndigo),
              ),
              alignment: Alignment.center,
              child: Text(
                Config.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontFamily: Config.fontFamilyPoppinsBold,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              alignment: Alignment.center,
              child: Text(
                message ?? 'empty message',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: HexColor(MyColors.colorBlack),
                  fontFamily: Config.fontFamilyPoppinsMedium,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (onOkClick != null) {
                  await onOkClick();
                }
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: HexColor(MyColors.darkIndigo),
                    fontSize: 18.0,
                    fontFamily: Config.fontFamilyPoppinsBold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          child: alertDialog,
          onWillPop: () async {
            return false;
          },
        );
      },
      barrierDismissible: false,
    );
  }

  static Future dialogueWithProceedCancelButton({
    required BuildContext context,
    required String title,
    required String msg,
    required String positiveBtnTitle,
    required String negativeBtnTitle,
    required Function()? onCancel,
    required Function()? onProceed,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title.isNotEmpty ? title : Config.appName,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: HexColor(MyColors.colorBlack),
                      fontFamily: Config.fontFamilyPoppinsBold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              const Divider(color: Colors.grey, height: 4.0),
              const SizedBox(height: 15.0),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Text(
                    msg,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: HexColor(MyColors.colorBlack),
                      fontFamily: Config.fontFamilyPoppinsMedium,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        if (onCancel != null) {
                          await onCancel();
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        negativeBtnTitle.isNotEmpty
                            ? negativeBtnTitle
                            : Config.cancel,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontFamily: Config.fontFamilyPoppinsBold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (onProceed != null) {
                          await onProceed();
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        positiveBtnTitle.isNotEmpty
                            ? positiveBtnTitle
                            : Config.submit,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: HexColor(MyColors.darkIndigo),
                          fontFamily: Config.fontFamilyPoppinsBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static bool isCheckPass(String value) {
    String passwordRegExp =
        r'^.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[a-z])(^[a-zA-Z0-9@\$=!:.#%]+$)';
    RegExp regExp = RegExp(passwordRegExp);
    bool isPasw = regExp.hasMatch(value);
    return isPasw;
  }

  static bool isCheckEmail(String value) {
    String emailRegExp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(emailRegExp);
    bool isEml = regExp.hasMatch(value);
    return isEml;
  }

  static bool isValidateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
