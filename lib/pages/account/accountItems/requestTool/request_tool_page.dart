import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gobuddy/components/dailogbox.dart';
import 'package:gobuddy/data/preferences.dart';
import 'package:gobuddy/services/end_points.dart';
import 'package:gobuddy/services/repository.dart';
import 'package:gobuddy/utils/config.dart';
import 'package:gobuddy/utils/util_class.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RequestToolScreen extends StatefulWidget {
  const RequestToolScreen({super.key});

  @override
  State<RequestToolScreen> createState() => _RequestToolScreenState();
}

class _RequestToolScreenState extends State<RequestToolScreen> {
  final TextEditingController _toolNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;

  int _selectedTabIndex = 0; // 0 = Send Request, 1 = Requested Tools

   List<dynamic> toolsDetails  =[];

  dynamic userData = {};

  void callgetgetToolsAPI() async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.tools, {
        "user_id": "4355" ?? "4361",
      }).then((value) async {
        UtilClass.hideProgress();
        dynamic parsed = {};
        try {
          parsed = await json.decode(value);
          if (parsed["status"] == "valid") {
            toolsDetails = parsed["requesttools"];

            setState(() {
              toolsDetails = parsed["requesttools"];
            });
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
  void initState() {
    super.initState();
    _toolNameController.addListener(_updateButtonState);
    _descriptionController.addListener(_updateButtonState);

    var userDataValue = Preferences.getUserDetails();
    if (userDataValue != null) {
      userData = json.decode(userDataValue);
    }

    callgetgetToolsAPI();
  }

  @override
  void dispose() {
    _toolNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  bool get _isFormComplete {
    return _toolNameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedImage != null;
  }


   void callRequestToolAPI() async {
    
    var formData = FormData.fromMap({
       "provider_id": userData["user_id"] ?? "4361",
       "tool_name":_toolNameController.text,
      "description": _descriptionController.text,
      "tool_image": await MultipartFile.fromFile(
        _selectedImage!.path,
        filename: "aadhar_front",
      ),
      
    });

    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postimagesApiService(EndPoints.addrequesttool, formData).then((
        value,
      ) async {
        UtilClass.hideProgress();
        dynamic parsed = {};
        try {
          parsed = await json.decode(value);
          if (parsed["status"] == "valid") {
          } else {
            // ignore: use_build_context_synchronously
            // UtilClass.showAlertDialog(
            //   // ignore: use_build_context_synchronously
            //   context: context,
            //   message: parsed["message"],
            // );
          }

          setState(() {
                _toolNameController.clear();
                _descriptionController.clear();
                _selectedImage = null;
              });


               UtilClass.showAlertDialog(
              // ignore: use_build_context_synchronously
              context: context,
              message: parsed["message"] ?? "Added successfully",
            );

         
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
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Colors.green, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Request Tool",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.04,
            vertical: deviceHeight * 0.02,
          ),
          child: Column(
            children: [
              /// Tab Row
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = 0),
                      child: Column(
                        children: [
                          Text(
                            "Send Request",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedTabIndex == 0
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          if (_selectedTabIndex == 0)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 3,
                              color: Colors.green,
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedTabIndex = 1);
                        callgetgetToolsAPI();
                      },
                      child: Column(
                        children: [
                          Text(
                            "Requested Tools",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedTabIndex == 1
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          if (_selectedTabIndex == 1)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 3,
                              color: Colors.green,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: deviceHeight * 0.02),

              /// Tab Content
              _selectedTabIndex == 0
                  ? _buildSendRequestForm(deviceWidth, deviceHeight)
                  : _buildRequestedToolsList(deviceWidth, deviceHeight),
            ],
          ),
        ),
      ),
    );
  }

  /// Send Request Form
  Widget _buildSendRequestForm(double deviceWidth, double deviceHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.04,
        vertical: deviceHeight * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Tool Name
          const Text(
            "Tool Name",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          SizedBox(height: deviceHeight * 0.01),
          CustomInputField(
            controller: _toolNameController,
            hintText: "Enter Tool Name",
            maxLines: 1,
          ),
          SizedBox(height: deviceHeight * 0.02),

          /// Description
          const Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          SizedBox(height: deviceHeight * 0.01),
          CustomInputField(
            controller: _descriptionController,
            hintText: "Enter Description",
            maxLines: 4,
          ),
          SizedBox(height: deviceHeight * 0.02),

          /// Tool Image
          const Text(
            "Tool Image",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          SizedBox(height: deviceHeight * 0.01),
          Row(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: deviceHeight * 0.15,
                  width: deviceWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? const Icon(Icons.image, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(width: deviceWidth * 0.04),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: deviceHeight * 0.03),

          /// Submit Button
          CustomSubmitButton(
            deviceWidth: deviceWidth,
            text: "Submit",
            enabled: _isFormComplete,
            onTap: () {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text("Tool request submitted successfully!"),
              //     backgroundColor: Colors.green,
              //   ),
              // );

              callRequestToolAPI();

              
            },
          ),
        ],
      ),
    );
  }

  /// Requested Tools List UI
  Widget _buildRequestedToolsList(double deviceWidth, double deviceHeight) {
    return Column(children:<Widget>[for(var item in toolsDetails ) Container(
      width: double.infinity,
      padding: EdgeInsets.all(deviceWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Status Badge
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child:  item["status"] == "1"?const Text(
                "Accepted",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ):const Text(
                "Pending",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /// Tool Name
          const Text(
            "Tool Name",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            item["tool_name"]??"",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: deviceHeight * 0.01),

          /// Description
          Text(
           item["description"]??"",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          
          SizedBox(height: deviceHeight * 0.01),

          /// Tool Image
          const Text(
            "Tool Image",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(height: 8),
          Container(
            height: deviceHeight * 0.1,
            width: deviceWidth * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                11,
              ), // Slightly smaller to account for border
              child: Padding(
                padding: EdgeInsets.all(8), // Inner padding
                child: Image.network(
                                      item["tool_image"],
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
              ),
            ),
          ),
        ],
      ),
    )]);
  }
}

/// Reusable Input Field Widget
class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// Reusable Submit Button Widget
class CustomSubmitButton extends StatelessWidget {
  final double deviceWidth;
  final String text;
  final bool enabled;
  final VoidCallback onTap;

  const CustomSubmitButton({
    super.key,
    required this.deviceWidth,
    required this.text,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: deviceWidth,
      height: 50,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: enabled
                ? const LinearGradient(
                    colors: [Colors.green, Colors.yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [Colors.grey.shade300, Colors.grey.shade300],
                  ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            width: deviceWidth,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
