import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyQRCodeScreen extends StatefulWidget {
  const MyQRCodeScreen({Key? key}) : super(key: key);

  @override
  State<MyQRCodeScreen> createState() => _MyQRCodeScreenState();
}

class _MyQRCodeScreenState extends State<MyQRCodeScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  /// Function to show bottom sheet options
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOption(Icons.camera_alt, "Camera", () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              }),
              _buildOption(Icons.image, "Gallery", () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              }),
              _buildOption(Icons.folder, "Folder", () {
                Navigator.pop(context);
                // You can implement folder picker here if needed
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Folder picker not implemented")),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// Function to pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Image Picker Error: $e");
    }
  }

  /// Widget for picker options
  Widget _buildOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            radius: 30,
            child: Icon(icon, color: Colors.black, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFFFFEB3B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back button and title
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "My QR code",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Profile image
              CircleAvatar(
                radius: screenWidth * 0.15,
                backgroundImage: const AssetImage("assets/images/avatar.png"),
              ),
              const SizedBox(height: 10),
              const Text(
                "Akshay Kumar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

              SizedBox(height: screenHeight * 0.04),

              // QR Upload Container
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Container(
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _selectedImage == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined,
                          color: Colors.green, size: 50),
                      const SizedBox(height: 10),
                      const Text(
                        "Upload Your QR Code",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Change button
              ElevatedButton(
                onPressed:
                _selectedImage != null ? _showImagePickerOptions : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  "Change",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
