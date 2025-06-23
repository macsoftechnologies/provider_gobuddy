import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Image.asset('assets/logo.png', height: 80), // Placeholder for GB Logo
            SizedBox(height: 20),
            Text(
              "Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Enter your phone number\nWe will send you the 4-digit verification code",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixText: "+91 ",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OTPScreen(phone: _phoneController.text)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50), // green
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Get Verification Code"),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to register screen if needed
              },
              child: Text("New User? Register Here"),
            ),
          ],
        ),
      ),
    );
  }
}


class OTPScreen extends StatefulWidget {
  final String phone;

  OTPScreen({required this.phone});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  List<String> otp = ['', '', '', ''];
  FocusNode? focusNode1, focusNode2, focusNode3, focusNode4;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
    focusNode4 = FocusNode();
  }

  @override
  void dispose() {
    focusNode1?.dispose();
    focusNode2?.dispose();
    focusNode3?.dispose();
    focusNode4?.dispose();
    super.dispose();
  }

  void _onOTPComplete() {
    String enteredOTP = otp.join();
    print("Entered OTP: $enteredOTP");

    // Add verification logic here
  }

  Widget _buildOTPField(int index, FocusNode currentFocus, FocusNode? nextFocus) {
    return SizedBox(
      width: 50,
      child: TextField(
        focusNode: currentFocus,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(counterText: ''),
        onChanged: (val) {
          if (val.isNotEmpty) {
            setState(() {
              otp[index] = val;
            });
            if (index == 3) {
              _onOTPComplete();
            } else {
              FocusScope.of(context).requestFocus(nextFocus);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 80),
            Image.asset('assets/otp.png', height: 100), // Placeholder image
            SizedBox(height: 20),
            Text("OTP Verification", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Enter the code we sent to the number", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 5),
            Text(widget.phone, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOTPField(0, focusNode1!, focusNode2),
                _buildOTPField(1, focusNode2!, focusNode3),
                _buildOTPField(2, focusNode3!, focusNode4),
                _buildOTPField(3, focusNode4!, null),
              ],
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Resend OTP Logic
              },
              child: Text("Didn't receive the OTP? Resend OTP"),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onOTPComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Verify Code"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
