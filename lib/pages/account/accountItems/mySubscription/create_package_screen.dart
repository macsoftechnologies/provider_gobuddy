import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gobuddy/data/preferences.dart';
import 'package:gobuddy/pages/account/accountItems/mySubscription/technician_services_prices.dart';
import 'package:gobuddy/services/end_points.dart';
import 'package:gobuddy/services/repository.dart';

import 'package:gobuddy/utils/util_class.dart';
import '../../../../utils/config.dart';
import 'Ac_tec_basic_plan.dart';

class CreatePackageScreen extends StatefulWidget {
  const CreatePackageScreen({super.key});

  @override
  State<CreatePackageScreen> createState() => _CreatePackageScreenState();
}

class _CreatePackageScreenState extends State<CreatePackageScreen> {
  final List<Map<String, String>> categories = [
    {
      "title": "AC Technician",
      "image": "assets/images/ac.png",
    },
    {
      "title": "Electrician",
      "image": "assets/images/ac.png",
    },
    {
      "title": "Cleaning Service",
      "image": "assets/images/ac.png",
    },
    {
      "title": "Plumber",
      "image": "assets/images/ac.png",
    },
    {
      "title": "Beauty Service",
      "image": "assets/images/ac.png",
    },
    {
      "title": "Painting",
      "image": "assets/images/ac.png",
    },
  ];

  List<dynamic> packageDetails  =[];

  dynamic userData = {};
@override
  void initState() {
    super.initState();
   

    var userDataValue = Preferences.getUserDetails();
    if (userDataValue != null) {
      userData = json.decode(userDataValue);
    }

    callgetPackagesAPI();
  }

  void callgetPackagesAPI() async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.locaCatApi, {
        "pincode": "530017",
      }).then((value) async {
        UtilClass.hideProgress();
        dynamic parsed = {};
        try {
          parsed = await json.decode(value);
          if (parsed["status"] == "valid") {
            packageDetails = parsed["categories"];

            setState(() {
              packageDetails = parsed["categories"];
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


  void _showPlanSelectionDialog(dynamic category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlanSelectionDialog(category: category);
      },
    );
  }

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
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: _buildBackButton(),
                      ),
                      SizedBox(width: deviceWidth * 0.03),
                      const Text(
                        "Create Your Package",
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
                itemCount: packageDetails.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: deviceHeight * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        _showPlanSelectionDialog(packageDetails[index]!);
                      },
                      child: _buildCategoryCard(
                        packageDetails[index]["category"]!,
                        "assets/images/noimage124.png",
                        deviceWidth,
                        deviceHeight,
                      ),
                    ),
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

// Dialog version of PlanSelectionScreen
class PlanSelectionDialog extends StatefulWidget {
  final dynamic category;

  const PlanSelectionDialog({super.key, required this.category});

  @override
  State<PlanSelectionDialog> createState() => _PlanSelectionDialogState();
}

class _PlanSelectionDialogState extends State<PlanSelectionDialog> {
  int? selectedIndex;
  final List<Map<String, String>> plans = [
    {"title": "Basic Plan", "subtitle": "Split AC & Tower AC"},
    {"title": "Advanced Plan", "subtitle": "All AC Services"},
  ];

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: deviceHeight * 0.02),

            /// Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // to balance the close button
                Text(
                  widget.category["category"]??"",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            SizedBox(height: deviceHeight * 0.02),

            /// Subheading
            const Text(
              "Choose Your Plan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),

            SizedBox(height: deviceHeight * 0.03),

            /// Plans List
            Column(
              children: List.generate(plans.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: deviceHeight * 0.015),
                  child: _buildPlanCard(
                    index,
                    plans[index]["title"]!,
                    plans[index]["subtitle"]!,
                    deviceWidth,
                    deviceHeight,
                  ),
                );
              }),
            ),

            SizedBox(height: deviceHeight * 0.02),

            /// Continue Button
            GestureDetector(
              onTap: selectedIndex != null
                  ? () {
                Navigator.pop(context); // Close the dialog
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => AcTechnicianScreen(),
                //   ),
                // );
                Navigator.pushNamed(
                  // ignore: use_build_context_synchronously
                  context,
                  Config.technicianServicesPricesRouteName,
                  arguments: {
                    "categoryName": widget.category,
                    "planType": plans[selectedIndex!]['title']!,

                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${plans[selectedIndex!]['title']} Selected"),
                  ),
                );
              }
                  : null,
              child: Container(
                width: double.infinity,
                height: deviceHeight * 0.06,
                decoration: BoxDecoration(
                  color: selectedIndex != null
                      ? const Color(0xFF429321)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: selectedIndex != null
                        ? Colors.white
                        : Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            SizedBox(height: deviceHeight * 0.03),
          ],
        ),
      ),
    );
  }

  /// Plan Card Widget
  Widget _buildPlanCard(
      int index, String title, String subtitle, double w, double h) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: h * 0.02,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFFFFF176), Color(0xFF66BB6A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            /// Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: h * 0.005),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            /// Tick Mark if selected
            if (isSelected)
              Container(
                height: 26,
                width: 26,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}