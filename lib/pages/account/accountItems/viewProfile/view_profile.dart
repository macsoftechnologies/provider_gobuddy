import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gobuddy/data/preferences.dart';
import 'package:gobuddy/services/end_points.dart';
import 'package:gobuddy/services/repository.dart';
import 'package:gobuddy/utils/config.dart';
import 'package:gobuddy/utils/util_class.dart';

import '../../../../components/button.dart';

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  dynamic profileDetails = [];
  dynamic userData= {};
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController altPhoneController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController addressController = TextEditingController(text: "");
  @override
  void initState() {
    super.initState();

     var userDataValue = Preferences.getUserDetails();
      userData =  json.decode(userDataValue!);
    callgetProfileAPI();
  }

  void callpostProfileAPI() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty) {
      UtilClass.showAlertDialog(
        // ignore: use_build_context_synchronously
        context: context,
        message: "Enter all required fields",
      );

      return;
    }

    dynamic inputData = {
      "name": nameController.text,
      "email": emailController.text,
      "terms_and_conditions": "testing",
      "latitude": "17.740678937225038",
      "longitude": "83.3093623816967",
      "place_id": "5",
      "landmark": "Vizag",
      "location": "Vizag",
      "dob": "24-05-1998",
      "address": addressController.text,
       "user_id": userData["user_id"],
      "alternate_phone_number": "7794954112",
    };

    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.updateProfile, inputData).then((
        value,
      ) async {
        UtilClass.hideProgress();
        dynamic parsed = {};
        try {
          parsed = await json.decode(value);
          if (parsed["status"] == "valid") {
            UtilClass.showAlertDialog(
              // ignore: use_build_context_synchronously
              context: context,
              message: "Profile updated successfully",
            );
          } else {
            // ignore: use_build_context_synchronously
            UtilClass.showAlertDialog(
              // ignore: use_build_context_synchronously
              context: context,
              message: parsed["message"],
            );
          }
        } catch (e) {
          print(e);
        }
        print(parsed["message"]);
      });
    } else {
      // ignore: use_build_context_synchronously
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  void callgetProfileAPI() async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.profile, {
        "user_id": userData["user_id"],
      }).then((value) async {
        UtilClass.hideProgress();
        dynamic parsed = {};
        try {
          parsed = await json.decode(value);
          if (parsed["status"] == "valid") {
            profileDetails = parsed["profile"];

            nameController.text = profileDetails["name"] ?? "";
            phoneController.text = profileDetails["phone_number"] ?? "";

            emailController.text = profileDetails["email"] ?? "";
            addressController.text = profileDetails["address"] ?? "";
          } else {
            // ignore: use_build_context_synchronously
            UtilClass.showAlertDialog(
              // ignore: use_build_context_synchronously
              context: context,
              message: parsed["message"],
            );
          }
        } catch (e) {
          print(e);
        }
        print(parsed["message"]);
      });
    } else {
      // ignore: use_build_context_synchronously
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Profile"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFC8BB47), // Golden Yellow
                Color(0xFF25AC2C),
              ], // 👈 Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                "assets/images/user.jpg",
              ), // Replace with your image
            ),
            SizedBox(height: 20),
            _buildTextField("Name", false,nameController),
            _buildTextField("Phone Number",true, phoneController),
            _buildTextField("Alternative Phone Number", true,altPhoneController),
            _buildTextField("Email", false,emailController),
            _buildTextField(
              "Address",
              false,
              addressController,
              suffixIcon: Icon(Icons.edit),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green,
            //     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            //   ),
            //   onPressed: () {
            //     // Update address logic here
            //   },
            //   child: Text("Update Address"),
            // ),
            GradientButton(
              onPressed: () {

                callpostProfileAPI();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => InstructionsTwo()),
                // );
              },
              child: Text(
                'Update Address',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth * 0.04,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
     bool readonlyval,
    TextEditingController controller, {
    Widget? suffixIcon
    
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: readonlyval,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
