import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:providerapp_gobuddy/screens/ekycVerificationPage.dart';
import 'package:providerapp_gobuddy/utilites/button.dart';

import '../utilites/custombackbutton.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String phone = '';
  String altPhone = '';
  String dob = '';
  String email = '';
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
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Select Technician Categories",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...technicianCategories.keys.map((category) {
                  return CheckboxListTile(
                    title: Text(category),
                    value: technicianCategories[category],
                    onChanged: (value) {
                      setModalState(() {
                        technicianCategories[category] = value!;
                      });
                    },
                  );
                }).toList(),
                TextButton(
                  child: Text("Done"),
                  onPressed: () {
                    final selected = technicianCategories.entries
                        .where((e) => e.value)
                        .map((e) => e.key)
                        .join(', ');
                    _techCategoryController.text = selected;
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  void _showWorkingCategoryDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String? tempCategory = workingCategory;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Select Working Category",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                RadioListTile<String>(
                  title: Text("Independent"),
                  value: "Independent",
                  groupValue: tempCategory,
                  onChanged: (value) {
                    setModalState(() => tempCategory = value);
                  },
                ),
                RadioListTile<String>(
                  title: Text("Organisation"),
                  value: "Organisation",
                  groupValue: tempCategory,
                  onChanged: (value) {
                    setModalState(() => tempCategory = value);
                  },
                ),
                TextButton(
                  child: Text("Done"),
                  onPressed: () {
                    setState(() {
                      workingCategory = tempCategory;
                      _workingCategoryController.text = workingCategory ?? '';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey),
      floatingLabelStyle: TextStyle(color: Colors.green),
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),

      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
         backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Container(
        color: Colors.white,
       child:SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
              Image.asset('assets/logo.png',height: 70,width: 100,),
              SizedBox(height: 5,),
              Text('Register',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily:
              'Urbanist',color: Colors.black),),
              SizedBox(height: 5,),
              Text('Lets create an account',style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal,fontFamily:
              'Urbanist',color: Colors.grey),),
              SizedBox(height: 20,),
             ],
              ),
              ),
             // Profile Image Picker
              Center(
                child: Stack(
                  children: [


                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null
                          ? Icon(Icons.person, size: 60)
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
              SizedBox(height: 15),

              // Name
              TextFormField(
                decoration: _inputDecoration('Name'),
                onChanged: (value) => name = value,cursorColor: Colors.green,
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              SizedBox(height: 10),
              // Phone
              TextFormField(
                decoration: _inputDecoration( 'Phone Number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => phone = value,cursorColor: Colors.green,
                validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
              ),
              SizedBox(height: 10),
              // Alternative Phone
              TextFormField(
                decoration: _inputDecoration('Alternative Phone Number',

                ),
                keyboardType: TextInputType.phone,
                cursorColor: Colors.green,
                onChanged: (value) => altPhone = value,
              ),

              SizedBox(height: 10),
              // DOB
              TextFormField(
                decoration:
                _inputDecoration( 'Date of Birth (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,cursorColor: Colors.green,
                onChanged: (value) => dob = value,
              ),

              // Email
              SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration( 'Email'),
                keyboardType: TextInputType.emailAddress,cursorColor: Colors.green,
                onChanged: (value) => email = value,
              ),

              SizedBox(height: 10),

              // Technician Category Dropdown
              GestureDetector(
                onTap: () => _showTechnicianCategoryDialog(),
                child: AbsorbPointer(
                  child:
                  TextFormField(
                    controller: _techCategoryController,
                    decoration: InputDecoration(
                      labelText: 'Technician Categories',

                      suffixIcon: Icon(Icons.arrow_drop_down),

                    ),
                    keyboardType: TextInputType.text,cursorColor: Colors.green,
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Working Category Dropdown
              GestureDetector(
                onTap: () => _showWorkingCategoryDialog(),
                child: AbsorbPointer(
                  child:
                  TextFormField(
                    controller: _workingCategoryController,
                    decoration: InputDecoration(
                      labelText: 'Working Category',
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'Select a working category' : null,
                    keyboardType: TextInputType.text,cursorColor: Colors.green,
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Accept Terms Checkbox
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("Terms and Conditions",style:
                TextStyle(
                  color: Colors.deepOrange,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.deepOrange, // Make underline green
                  decorationThickness: 1.5,       // Optional: thickness of underline
                ),),
                value: acceptTerms,
                onChanged: (value) {
                  setState(() {
                    acceptTerms = value ?? false;
                  });
                },
              ),

              SizedBox(height: 10),

              // Submit Button
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 50, // You can adjust the height as needed
                    width: double.infinity,
                    child: GradientButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (!acceptTerms) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("You must accept the Terms and Conditions"),
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) =>OtpPage()),
                          );
                          // Proceed with form submission
                        }
                      },
                      child: Text("Register"),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

               Row(

                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text("Already have an account please",style: TextStyle(fontSize: 15),),
                   SizedBox(width: 5,),
                   Text(
                     'Sign up',
                     style:
                     TextStyle(
                       fontSize: 15,
                       color: Colors.green,
                       decoration: TextDecoration.underline,
                       decorationColor: Colors.green, // Make underline green
                       decorationThickness: 1.5,       // Optional: thickness of underline
                     ),
                   ),

                 ],
               ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
      ),
    );
  }
}


class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otpCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Verification")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 40),

            // Top Center Image
            Center(
              child: Image.asset(
                'assets/otp.png', // Replace with your own image asset
                height: 120,
              ),
            ),

            SizedBox(height: 40),

            Text(
              "Enter the 4-digit OTP sent to your phone",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            // OTP Input
            PinCodeTextField(
              appContext: context,
              length: 4,
              onChanged: (value) {
                setState(() {
                  otpCode = value;
                });
              },
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 60,
                fieldWidth: 60,
                activeColor: Colors.green,
                selectedColor: Colors.green,
                inactiveColor: Colors.grey,
              ),
            ),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Did'nt recieve the OTP?",style: TextStyle(fontSize: 12,fontFamily: 'Urbanist'),),
                 SizedBox(width: 5,),
                 Text("Resend Otp",style: TextStyle(fontSize: 12,fontFamily: 'Urbanist',

                       color: Colors.green,
                       decoration: TextDecoration.underline,
                       decorationColor: Colors.green, // Make underline green
                       decorationThickness: 1.5, ),),

               ],
             ),
            SizedBox(height: 30),

            // Submit Button
            Padding(padding: EdgeInsets.symmetric(horizontal: 16),
           child:  SizedBox(
              width: double.infinity,
              child: GradientButton(

                  // padding: EdgeInsets.symmetric(vertical: 16),

                onPressed: () {
                  if (otpCode.length == 4) {
                    // Validate OTP here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("OTP Verified: $otpCode")),

                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>EKYCVerificationPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter 4-digit OTP")),
                    );
                  }
                },
                child: Text("Verify OTP"),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
