import 'package:flutter/material.dart';

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  TextEditingController nameController = TextEditingController(text: "Akshay Kumar");
  TextEditingController phoneController = TextEditingController(text: "+91 9876543210");
  TextEditingController altPhoneController = TextEditingController(text: "+91 9087654321");
  TextEditingController emailController = TextEditingController(text: "akshaykumarpadala@gmail.com");
  TextEditingController addressController = TextEditingController(text: "Venkateswara Colony, visakhapatnam");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Profile"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/avatar.png"), // Replace with your image
            ),
            SizedBox(height: 20),
            _buildTextField("Name", nameController),
            _buildTextField("Phone Number", phoneController),
            _buildTextField("Alternative Phone Number", altPhoneController),
            _buildTextField("Email", emailController),
            _buildTextField("Address", addressController, suffixIcon: Icon(Icons.edit)),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              onPressed: () {
                // Update address logic here
              },
              child: Text("Update Address"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
