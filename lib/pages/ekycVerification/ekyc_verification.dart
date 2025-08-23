import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/custom_back_button.dart';
import '../../components/appcolor.dart';
import '../../components/dailogbox.dart';
import '../../utils/config.dart';


class EKYCVerificationPage extends StatefulWidget {
  @override
  _EKYCVerificationPageState createState() => _EKYCVerificationPageState();
}

class _EKYCVerificationPageState extends State<EKYCVerificationPage> {
  bool acceptConditions = false;
  final ImagePicker _picker = ImagePicker();

  // Store selected images
  File? aadharFront;
  File? aadharBack;
  File? panOrDl;
  File? skillCert1;
  File? skillCert2;

  Future<void> pickImage(Function(File) onSelected) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      onSelected(File(image.path));
    }
  }

  Widget uploadBox(File? file, String label, Function(File) onSelected) {
    return GestureDetector(
      onTap: () => pickImage(onSelected),
      child: Container(
        height: 100,
        width: 130,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          border: Border.all(color: Colors.grey, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8),
        ),
        child: file != null
            ? Image.file(file, fit: BoxFit.cover)
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file, color: Colors.green, size: 30),
              SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  bool isFormValid() {
    return aadharFront != null &&
        aadharBack != null &&
        panOrDl != null &&
        acceptConditions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.verified_user, size: 60, color: Colors.green)),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "e-KYC Verification",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Center(child: Text("Upload your documents below")),
              SizedBox(height: 20),

              sectionTitle("Upload your Aadhar:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      uploadBox(aadharFront, "Front", (file) {
                        setState(() => aadharFront = file);
                      }),
                      SizedBox(height: 5),
                      Text("Front side")
                    ],
                  ),
                  Column(
                    children: [
                      uploadBox(aadharBack, "Back", (file) {
                        setState(() => aadharBack = file);
                      }),
                      SizedBox(height: 5),
                      Text("Back side")
                    ],
                  ),
                ],
              ),

              sectionTitle("Upload PAN or Driving License :"),
              uploadBox(panOrDl, "PAN/DL", (file) {
                setState(() => panOrDl = file);
              }),

              sectionTitle("Upload any skills or Training Certificates : (Optional)"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  uploadBox(skillCert1, "Skill 1", (file) {
                    setState(() => skillCert1 = file);
                  }),
                  uploadBox(skillCert2, "Skill 2", (file) {
                    setState(() => skillCert2 = file);
                  }),
                ],
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: acceptConditions,
                    onChanged: (value) {
                      setState(() => acceptConditions = value ?? false);
                    },
                  ),
                  Text("Accept "),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Validity Conditions",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: isFormValid()
                      ? AppColors.buttonGradient
                      : LinearGradient(colors: [Colors.grey, Colors.grey[400]!]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: isFormValid()
                      ? () {
                    showCustomDialog(
                      context: context,
                      message: 'Documents Submitted Successfully!',
                    );

                    // Delay navigation by 2 seconds
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushNamed(
                        context,
                        Config.regiFeeRouteName,

                      );
                      //RegistrationFeePage
                    });
                  }


                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
