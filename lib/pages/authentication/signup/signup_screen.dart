import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gobuddy/components/components/custom_back_button.dart';
import 'package:gobuddy/components/components/gradient_button.dart';
import 'package:gobuddy/utils/config.dart';
import 'package:gobuddy/utils/my_colors.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:providerapp_gobuddy/screens/ekycVerificationPage.dart';
// import 'package:providerapp_gobuddy/utilites/button.dart';
// import '../utilites/custombackbutton.dart';
// import 'loginscreen.dart';
// import 'otpScreen/otp_verification.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String phone = '';
  String altPhone = '';
  String dob = '';
  String email = '';
  String address = '';
  String referralCode = '';
  String? workingCategory;
  bool acceptTerms = false;

  File? _profileImage;

  TextEditingController _techCategoryController = TextEditingController();
  TextEditingController _workingCategoryController = TextEditingController();

  Map<String, bool> technicianCategories = {
    'AC Technician': false,
    'Plumber': false,
    'Electrician': false,
    'Cleaning Service': false,
    'Painter': false,
    'Beauty Service': false,
  };

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showTechnicianCategoryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            bool hasSelection = technicianCategories.values.any((v) => v);

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Select Technician Categories",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...technicianCategories.keys.map((category) {
                      return CheckboxListTile(
                        title: Text(
                          category,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        value: technicianCategories[category],
                        activeColor: Colors.green,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        onChanged: (value) {
                          setModalState(() {
                            technicianCategories[category] = value!;
                          });
                        },
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasSelection ? Colors.green : Colors.grey.shade300,
                            foregroundColor: hasSelection ? Colors.white : Colors.black54,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: hasSelection
                              ? () {
                            final selected = technicianCategories.entries
                                .where((e) => e.value)
                                .map((e) => e.key)
                                .join(', ');
                            _techCategoryController.text = selected;
                            Navigator.pop(context);
                          }
                              : null,
                          child: const Text(
                            "Proceed",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  void _showWorkingCategoryDialog() {
    String? tempCategory = workingCategory;
    TextEditingController companyController = TextEditingController();
    TextEditingController teamCountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            bool isValidSelection = () {
              if (tempCategory == null) return false;
              if (tempCategory == "Organisation") {
                return companyController.text.trim().isNotEmpty &&
                    teamCountController.text.trim().isNotEmpty;
              }
              return true;
            }();

            return Dialog(
              insetPadding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Working Category",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    RadioListTile<String>(
                      title: Text("Independent"),
                      value: "Independent",
                      groupValue: tempCategory,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setModalState(() => tempCategory = value);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      title: Text("Organisation"),
                      value: "Organisation",
                      groupValue: tempCategory,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setModalState(() => tempCategory = value);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (tempCategory == "Organisation") ...[
                      SizedBox(height: 16),
                      Text(
                        "Company Details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: companyController,
                        onChanged: (_) => setModalState(() {}),
                        decoration: InputDecoration(
                          hintText: "Enter Company Name",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: teamCountController,
                        onChanged: (_) => setModalState(() {}),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Team Count",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                        ),
                      ),
                    ],
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel"),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isValidSelection
                                  ? Colors.green
                                  : Colors.grey.shade300,
                              foregroundColor: isValidSelection
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                            onPressed: isValidSelection
                                ? () {
                              setState(() {
                                workingCategory = tempCategory;
                                _workingCategoryController.text =
                                    workingCategory ?? '';
                              });
                              Navigator.pop(context);
                            }
                                : null,
                            child: Text("Proceed"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
      floatingLabelStyle: TextStyle(color: Colors.green, fontSize: 14),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  InputDecoration _inputDecorationWithIcon(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
      floatingLabelStyle: TextStyle(color: Colors.green, fontSize: 14),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      suffixIcon: Icon(
        Icons.location_on_outlined,
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              deviceWidth * 0.04, 0, deviceWidth * 0.04, deviceWidth * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      Image.asset('assets/images/gobuddyIcon.png',
                          height: deviceHeight * 0.12),
                      SizedBox(height: 5),
                      Text('Register',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist')),
                      SizedBox(height: 5),
                      Text("Let's create an account",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      SizedBox(height: deviceHeight * 0.02),
                    ],
                  ),
                ),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: deviceWidth * 0.14,
                        backgroundImage:
                        _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, size: deviceWidth * 0.14)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: PopupMenuButton<ImageSource>(
                          icon: Icon(Icons.camera_alt, color: Colors.blue),
                          onSelected: _pickImage,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: ImageSource.camera,
                              child: Text("Take Photo"),
                            ),
                            PopupMenuItem(
                              value: ImageSource.gallery,
                              child: Text("Choose from Gallery"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.019),
                TextFormField(
                  decoration: _inputDecoration('Name'),
                  style: TextStyle(fontSize: 14),
                  onChanged: (value) => name = value,
                  validator: (value) =>
                  value!.isEmpty ? 'Enter your name' : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: _inputDecoration('Phone Number'),
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => phone = value,
                  validator: (value) =>
                  value!.isEmpty ? 'Enter phone number' : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: _inputDecoration('Alternative Phone Number'),
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => altPhone = value,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: _inputDecoration('Date of Birth (YYYY/MM/DD)'),
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.datetime,
                  onChanged: (value) => dob = value,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: _inputDecoration('Email (Optional)'),
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => email = value,
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: _showTechnicianCategoryDialog,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _techCategoryController,
                      style: TextStyle(fontSize: 14),
                      decoration: _inputDecoration('Technician Category').copyWith(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: _showWorkingCategoryDialog,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _workingCategoryController,
                      style: TextStyle(fontSize: 14),
                      decoration: _inputDecoration('Working Category').copyWith(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? 'Select a working category' : null,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: _inputDecorationWithIcon('Address'),
                  style: TextStyle(fontSize: 14),
                  onChanged: (value) => address = value,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration:
                  _inputDecoration('Enter Referral Code (Optional)'),
                  style: TextStyle(fontSize: 14),
                  onChanged: (value) => referralCode = value,
                ),
                SizedBox(height: 22),
                Row(
                  children: [
                    Checkbox(
                        value: acceptTerms,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          setState(() {
                            acceptTerms = val ?? false;
                          });
                        }),
                    GestureDetector(
                      onTap: () {},
                      child: Text("Accept ",
                          style: TextStyle(color: Colors.black)),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text("Terms and Conditions",
                          style: TextStyle(
                              color: Colors.orange,
                              decoration: TextDecoration.underline)),
                    )
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: deviceHeight * 0.07,
                  child: GradientButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (!acceptTerms) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Accept terms first")));
                          return;
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => OTPVerificationScreen()),
                        // );
                      }
                    },
                    child: Text("Register",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),

                    GestureDetector(
                      child: Text("Login here",
                          style: TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline)),
                      onTap: (){
                        Navigator.of(context).pushReplacementNamed(
                          Config.loginRouteName,
                        );
                      },
                    ),
                    SizedBox(height: 15),
                  ],

                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}