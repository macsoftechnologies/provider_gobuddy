import 'package:flutter/material.dart';
import 'package:gobuddy/pages/account/accountItems/mySubscription/plan_selection_screen.dart';
// import 'package:providerapp_gobuddy/screens/subscriptionScreens/plan_selection_screen.dart';

class CreatePackageScreen extends StatefulWidget {
  const CreatePackageScreen({super.key});

  @override
  State<CreatePackageScreen> createState() => _CreatePackageScreenState();
}

class _CreatePackageScreenState extends State<CreatePackageScreen> {
  final List<Map<String, String>> categories = [
    {
      "title": "AC  Technician",
      "image": "assets/ac.png", // replace with your asset
    },
    {
      "title": "Electrician",
      "image": "assets/ac.png",
    },
    {
      "title": "Cleaning Service",
      "image": "assets/ac.png",
    },
    {
      "title": "Plumber",
      "image": "assets/ac.png",
    },
    {
      "title": "Beauty Service",
      "image": "assets/ac.png",
    },
    {
      "title": "Painting",
      "image": "assets/ac.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Header with Gradient
            Container(
              width: deviceWidth,
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.05,
                vertical: deviceHeight * 0.02,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFC8BB47), // green
                    Color(0xFF25AC2C), // light green
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildBackButton(),
                      SizedBox(width: deviceWidth * 0.03),
                      const Text(
                        "Create Your Packege",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceHeight * 0.03),
                  const Text(
                    "Select Your Skill Category",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                ],
              ),
            ),

            SizedBox(height: deviceHeight * 0.02),

            /// Category List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
                itemCount: categories.length,

                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: deviceHeight * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to PlanSelectionScreen with the category title
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlanSelectionScreen(
                              categoryTitle: categories[index]["title"]!,
                            ),
                          ),
                        );
                      },
                      child: _buildCategoryCard(
                        categories[index]["title"]!,
                        categories[index]["image"]!,
                        deviceWidth,
                        deviceHeight,
                      ),
                    )

                  );
                },

              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Back Button
  Widget _buildBackButton() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
        size: 18,
      ),
    );
  }

  /// Category Card
  Widget _buildCategoryCard(
      String title, String imagePath, double deviceWidth, double deviceHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.04,
        vertical: deviceHeight * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Service Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: deviceWidth * 0.05),

          /// Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          /// Arrow
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: const Color(0xFFE9FFE9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.green,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
