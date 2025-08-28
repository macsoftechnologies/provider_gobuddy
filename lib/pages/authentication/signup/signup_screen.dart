import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gobuddy/data/preferences.dart';
import 'package:gobuddy/utils/util_class.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import '../../../components/button.dart';
import '../../../components/custom_back_button.dart';
import '../../../utils/config.dart';

import 'package:gobuddy/services/end_points.dart';
import 'package:gobuddy/services/repository.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

   dynamic catageories = [];
   @override
  void initState() {
    super.initState();
    callCatDetailsAPI();
  }


callCatDetailsAPI() async {


  var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.locaCatApi, {
        "pincode": "530017"
       
      }).then((value) async {
        UtilClass.hideProgress();
        dynamic parsed = {};
        try {
          parsed = await json.decode(value);
          if (parsed["status"] == "valid") {
           catageories = parsed["categories"];
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

  final _formKey = GlobalKey<FormState>();

  bool _submitted = false;

  String name = '';
  String phone = '';
  String altPhone = '';
  String dob = '';
  String email = '';
  String address = '';
  String referralCode = '';
  String? workingCategory;
  String? companyName;
  String? teamCount;
  bool acceptTerms = false;

  File? _profileImage;

  final TextEditingController _techCategoryController = TextEditingController();
  final TextEditingController _workingCategoryController = TextEditingController();

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Select Technician Categories",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...technicianCategories.keys.map((category) {
                    return CheckboxListTile(
                      title: Text(
                        category,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
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
                  }),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasSelection
                              ? Colors.green
                              : Colors.grey.shade300,
                          foregroundColor: hasSelection
                              ? Colors.white
                              : Colors.black54,
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showWorkingCategoryDialog() {
    String? tempCategory = workingCategory;
    TextEditingController companyController = TextEditingController(
      text: companyName ?? "",
    );
    TextEditingController teamCountController = TextEditingController(
      text: teamCount ?? "",
    );

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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                    ),
                    RadioListTile<String>(
                      title: Text("Organisation"),
                      value: "Organisation",
                      groupValue: tempCategory,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setModalState(() => tempCategory = value);
                      },
                    ),
                    if (tempCategory == "Organisation") ...[
                      TextField(
                        controller: companyController,
                        onChanged: (_) => setModalState(() {}),
                        decoration: InputDecoration(
                          hintText: "Enter Company Name",
                          border: OutlineInputBorder(),
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

                                      if (workingCategory == "Organisation") {
                                        companyName = companyController.text
                                            .trim();
                                        teamCount = teamCountController.text
                                            .trim();
                                      } else {
                                        companyName = null;
                                        teamCount = null;
                                      }
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
      errorStyle: TextStyle(color: Colors.red, fontSize: 12),
      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
      floatingLabelStyle: TextStyle(color: Colors.green, fontSize: 14),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  String? _validateName(String? value) {
    if (!_submitted) return null;
    if (value == null || value.isEmpty) return 'Enter your name';
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Name must contain only alphabets';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (!_submitted) return null;
    if (value == null || value.isEmpty) return 'Enter phone number';
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Phone must be 10 digits';
    }
    return null;
  }

  String? _validateDob(String? value) {
    if (!_submitted) return null;
    if (value == null || value.isEmpty) return 'Enter date of birth';
    if (!RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(value)) {
      return 'Format must be DD-MM-YYYY';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (!_submitted) return null;
    if (value == null || value.isEmpty) return null;
    final regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!regex.hasMatch(value)) return 'Enter valid email';
    return null;
  }

  void _showSummaryDialog() {
    print("""
Name: $name
Phone: $phone
Alt Phone: $altPhone
DOB: $dob
Email: $email
Tech Category: ${_techCategoryController.text}
Working Category: ${_workingCategoryController.text}
Company Name: $companyName
Team Count: $teamCount
Address: $address
Referral: $referralCode
""");

    Navigator.pushNamed(
      context,
      Config.otpRouteName,
      arguments: {"phone": phone, "fromScreen": "register"},
    );
  }

  void callProviderRegisterAPI() async {
    print("""
Name: $name
Phone: $phone
Alt Phone: $altPhone
DOB: $dob
Email: $email
Tech Category: ${_techCategoryController.text}
Working Category: ${_workingCategoryController.text}
Company Name: $companyName
Team Count: $teamCount
Address: $address
Referral: $referralCode
""");
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.providerRegisterApi, {
        "name": name,
        "email": email,
        "phone_number": phone,
        "password": "123456",
        "terms_and_conditions": "testing",
        "latitude": "17.740678937225038",
        "longitude": "83.3093623816967",
        "place_id": "5",
        "landmark": "Vizag",
        "location": "Vizag",
        "token": "testing",
        "dob": "24-05-1998",
        "address": "vizag",
        "working_category": _workingCategoryController.text,
        "company_name": "Yamuna Cooling Service",
        "team_count": "6",
        "referral_code": referralCode,
        "skills": "1,2,3",
      }).then((value) async {
        UtilClass.hideProgress();
        dynamic parsed = {};
        try {
          parsed = await json.decode(value);
          if (parsed["status"] == "valid") {

             dynamic parsedconvert = await json.decode(value);
             parsedconvert["user_id"] = parsed["user_id"].toString();
             parsedconvert =  json.encode(parsedconvert);
             Preferences.setUserDetails(parsedconvert);
            Navigator.pushNamed(
              // ignore: use_build_context_synchronously
              context,
              Config.otpRouteName,
              arguments: {
                "phone": parsed["phone_number"],
                "user_id": parsed["user_id"].toString(),
                "fromScreen": "register",
              },
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

  @override
  Widget build(BuildContext context) {
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
            deviceWidth * 0.04,
            0,
            deviceWidth * 0.04,
            deviceWidth * 0.04,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                // Profile Image
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: deviceWidth * 0.14,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
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
                SizedBox(height: 20),

                TextFormField(
                  decoration: _inputDecoration('Name'),
                  onChanged: (v) => setState(() => name = v),
                  validator: _validateName,
                ),
                SizedBox(height: 15),

                TextFormField(
                  decoration: _inputDecoration('Phone Number'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (v) => setState(() => phone = v),
                  validator: _validatePhone,
                ),
                SizedBox(height: 15),

                TextFormField(
                  decoration: _inputDecoration('Alternative Phone Number'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (v) => setState(() => altPhone = v),
                  validator: _validatePhone,
                ),
                SizedBox(height: 15),

                TextFormField(
                  decoration: _inputDecoration('Date of Birth (DD/MM/YYYY)'),
                  keyboardType: TextInputType.datetime,
                  onChanged: (v) => setState(() => dob = v),
                  validator: _validateDob,
                ),
                SizedBox(height: 15),

                TextFormField(
                  decoration: _inputDecoration('Email (Optional)'),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => setState(() => email = v),
                  validator: _validateEmail,
                ),
                SizedBox(height: 15),

                GestureDetector(
                  onTap: _showTechnicianCategoryDialog,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _techCategoryController,
                      decoration: _inputDecoration(
                        'Technician Category',
                      ).copyWith(suffixIcon: Icon(Icons.arrow_drop_down)),
                      validator: (v) {
                        if (!_submitted) return null;
                        return v == null || v.isEmpty
                            ? 'Select a category'
                            : null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),

                GestureDetector(
                  onTap: _showWorkingCategoryDialog,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _workingCategoryController,
                      decoration: _inputDecoration(
                        'Working Category',
                      ).copyWith(suffixIcon: Icon(Icons.arrow_drop_down)),
                      validator: (v) {
                        if (!_submitted) return null;
                        return v == null || v.isEmpty
                            ? 'Select working category'
                            : null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),

                TextFormField(
                  decoration: _inputDecoration('Address'),
                  onChanged: (v) => setState(() => address = v),
                  validator: (v) {
                    if (!_submitted) return null;
                    return v == null || v.isEmpty ? 'Enter address' : null;
                  },
                ),
                SizedBox(height: 15),

                TextFormField(
                  decoration: _inputDecoration('Referral Code (Optional)'),
                  onChanged: (v) => referralCode = v,
                ),
                SizedBox(height: 15),

                Row(
                  children: [
                    Checkbox(
                      value: acceptTerms,
                      onChanged: (val) {
                        setState(() => acceptTerms = val ?? false);
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Accept Terms and Conditions",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                if (_submitted && !acceptTerms)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "You must accept terms",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 20),

                GradientButton(
                  onPressed: () {
                    setState(() => _submitted = true);
                    if (_formKey.currentState!.validate() && acceptTerms) {
                      callProviderRegisterAPI();
                    }
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
