import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gobuddy/services/end_points.dart';
import 'package:gobuddy/services/repository.dart';

import 'package:gobuddy/utils/config.dart';
import 'package:gobuddy/utils/my_colors.dart';
import 'package:gobuddy/utils/util_class.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneFocus.dispose();
    super.dispose();
  }


  void callLoginAPI() async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(
         EndPoints.newLoginApi,
        {"phone_number":"9346222599"},
      ).then((value) async{
        UtilClass.hideProgress();
        dynamic parsed = {};
    try{
      parsed = await json.decode(value);
    }catch(e){
      print(e);
    }
        print( parsed["message"]);
       


      });
    } else {
      // ignore: use_build_context_synchronously
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.02),

                // Custom Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: screenHeight * 0.055,
                      width: screenHeight * 0.055,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFd4c900), Color(0xFF00ad20)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Logo
                Image.asset(
                  'assets/images/gobuddyIcon.png', // replace with your logo
                  height: screenHeight * 0.12,
                ),

                SizedBox(height: screenHeight * 0.01),

                // Login Title
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // Subtitle
                Text(
                  "Enter your phone number",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  "We will send you the 4 digit verification code",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // Phone Number Field
                // Phone Number Field
                _buildTextField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  label: "Phone Number",
                  prefix: "+91 ",
                  keyboardType: TextInputType.phone,
                ),


                SizedBox(height: screenHeight * 0.1),

                // Gradient Button
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.065,
                  child: ElevatedButton(
                    onPressed: () {

                      callLoginAPI();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (_) =>
                      //       //OTPScreen(phone: _phoneController.text),
                      //       DashboardPage()
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFd4c900), Color(0xFF00ad20)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Get Verification Code",
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // Register Here
                GestureDetector(

                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New User? ",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black54,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Register Page
                            Navigator.of(context).pushReplacementNamed(
                              Config.registrationRouteName,
                            );
                          },
                          child: Text(
                            "Register Here",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    // Navigator.of(context).pushReplacementNamed(
                    //   Config.SignupScreen,
                    // );

                  },
                ),

                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );


  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required FocusNode focusNode,
  required String label,
  String? prefix,
  Widget? suffixIcon,
  TextInputType? keyboardType,
}) {
  bool isFocused = focusNode.hasFocus;
  Color activeColor =Colors.red;
  Color inactiveColor = Colors.grey;

  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    keyboardType: keyboardType ?? TextInputType.text,
    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontSize: 14,
        color: isFocused ? activeColor : inactiveColor,
      ),
      prefixText: prefix,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: MyColors.cardColor,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: inactiveColor, width: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: activeColor, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  );
}


