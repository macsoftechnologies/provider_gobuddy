import 'package:flutter/material.dart';

import '../../../../components/button.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _issueDescriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // If validation passes, print user input
      print("Issue Title: ${_issueTitleController.text}");
      print("Issue Description: ${_issueDescriptionController.text}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Submitted Successfully!")),
      );

      _issueTitleController.clear();
      _issueDescriptionController.clear();
    } else {
      // Show alert dialog if fields are empty
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Missing Information"),
          content: const Text("Please fill in both fields before submitting."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Support"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFC8BB47), // Golden Yellow
                Color(0xFF25AC2C),], // 👈 Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.02,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Issue Title",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                controller: _issueTitleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Enter the title of your issue",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter issue title";
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.03),

              Text(
                "Describe the issue you have encountered",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                controller: _issueDescriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Describe your issue in detail",
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please describe the issue";
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.05),

              GradientButton(
                onPressed: () {
                  _handleSubmit();
                },
                child: Text(
                  'Submit To Support',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
