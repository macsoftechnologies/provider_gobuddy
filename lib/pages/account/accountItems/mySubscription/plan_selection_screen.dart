import 'package:flutter/material.dart';

import 'Ac_tec_basic_plan.dart';

class PlanSelectionScreen extends StatefulWidget {
  //const PlanSelectionScreen({Key? key}) : super(key: key);
  final String categoryTitle;  // Add this parameter
  @override
  final Key? key;

  const PlanSelectionScreen({
    this.key,  // Optional key parameter
    required this.categoryTitle,  // Required category title
  }) : super(key: key);  // Pass key to super


  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  int? selectedIndex; // track selected card index

  final List<Map<String, String>> plans = [
    {"title": "Basic Plan", "subtitle": "Split AC & Tower AC"},
    {"title": "Advanced Plan", "subtitle": "All AC Services"},
  ];

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: deviceHeight * 0.02),

              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // to balance the close button
                  const Text(
                    "AC Technician",
                    style: TextStyle(
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

              SizedBox(height: deviceHeight * 0.03),

              /// Subheading
              const Text(
                "Choose Your Plan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),

              SizedBox(height: deviceHeight * 0.04),

              /// Plans List
              Column(
                children: List.generate(plans.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: deviceHeight * 0.02),
                    child:GestureDetector(
                      onTap: () {
                        // Navigate to PlanSelectionScreen with the category title
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => PlanSelectionScreen(
                        //       categoryTitle: categories[index]["title"]!,
                        //     ),
                        //   ),
                        // );
                      },
                      child: _buildPlanCard(
                        index,
                        plans[index]["title"]!,
                        plans[index]["subtitle"]!,
                        deviceWidth,
                        deviceHeight,
                      ),
                    )
                  );
                }),
              ),

              const Spacer(),

              /// Continue Button
              GestureDetector(
                onTap: selectedIndex != null
                    ? () {
                 // Navigate to PlanSelectionScreen with the category title
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AcTechnicianScreen(),
                    ),
                  );
                  // Handle continue action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "${plans[selectedIndex!]['title']} Selected"),
                    ),
                  );
                }
                    : null,
                child: Container(
                  width: double.infinity,
                  height: deviceHeight * 0.065,
                  decoration: BoxDecoration(
                    color: selectedIndex != null
                        ? const Color(0xFF429321) // green when enabled
                        : Colors.grey.shade300, // grey when disabled
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
