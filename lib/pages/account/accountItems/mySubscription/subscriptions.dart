import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gobuddy/pages/account/accountItems/mySubscription/update_plan.dart';
import '../../../../components/custom_back_button.dart';
import '../../../../utils/config.dart';
import 'change_prices.dart';
import 'create_package_screen.dart';

// Global variable to track if there are active or expired subscriptions
bool hasSubscriptions = true; // Set this based on your actual data

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return hasSubscriptions
        ? MySubscriptionsScreen()
        : CreateSubscriptionScreen();
  }
}

class MySubscriptionsScreen extends StatefulWidget {
  const MySubscriptionsScreen({super.key});

  @override
  State<MySubscriptionsScreen> createState() => _MySubscriptionsScreenState();
}

class _MySubscriptionsScreenState extends State<MySubscriptionsScreen> {
  // Sample JSON (you can fetch this from API)
  final String subscriptionJson = '''
  {
    "subscriptions": [
      {
        "title": "AC Technician",
        "plan": "Basic Plan",
        "totalJobs": 20,
        "used": 10,
        "missed": 0,
        "remaining": 10,
        "price": 999,
        "status": "Active",
        "subscribedOn": "12/03/2025"
      },
      {
        "title": "Plumbing",
        "plan": "Basic Plan",
        "totalJobs": 20,
        "used": 15,
        "missed": 5,
        "remaining": 0,
        "price": 700,
        "status": "Expired",
        "subscribedOn": "10/04/2024"
      }
    ]
  }
  ''';

  bool isPackageSelected = false; // for Add button state
  int? selectedPackage; // selected package index

  // Job Packages JSON
  final List<Map<String, dynamic>> jobPackages = [
    {"jobs": 20, "price": 999},
    {"jobs": 40, "price": 1499},
    {"jobs": 60, "price": 2399},
  ];

  late List subscriptions;
  int selectedIndex = 0; // Default tab selected

  @override
  void initState() {
    super.initState();
    final data = json.decode(subscriptionJson);
    subscriptions = data["subscriptions"];

    // Update global subscription status
    hasSubscriptions = subscriptions.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final subscription = subscriptions[selectedIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CustomBackButton(),
                  SizedBox(width: size.width * 0.03),
                  Text(
                    "My Subscriptions",
                    style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),

              // Create New Subscription Package
              GestureDetector(
                onTap: () {
                  // Navigate to create subscription screen
                  Navigator.pushNamed(
                    // ignore: use_build_context_synchronously
                    context,
                    Config.createPackageRouteName,
                  );

                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.015),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: const Offset(1, 2))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Create New Subscription Package",
                          style: TextStyle(fontSize: size.width * 0.04)),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.add,
                            color: Colors.green, size: size.width * 0.06),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),

              // Tabs
              Row(
                children: [
                  _buildTab("AC Technician", 0, subscription["title"], size),
                  SizedBox(width: size.width * 0.03),
                  _buildTab("Plumbing", 1, subscription["title"], size),
                ],
              ),
              SizedBox(height: size.height * 0.02),

              // Subscription Card
              _buildSubscriptionCard(subscription, size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index, String activeTitle, Size size) {
    final isActive = index == selectedIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.012),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontSize: size.width * 0.04),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(Map subscription, Size size) {
    final status = subscription["status"];
    final isActive = status == "Active";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(1, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Price + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${subscription["title"]}\n${subscription["plan"]}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.045)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.005),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.035,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text("₹ ${subscription["price"]}",
                      style: TextStyle(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),

          // Job Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildJobInfo(
                  "Total Jobs", subscription["totalJobs"].toString(), size),
              _buildJobInfo("Used", subscription["used"].toString(), size),
              _buildJobInfo("Missed", subscription["missed"].toString(), size),
              _buildJobInfo(
                  "Remaining", subscription["remaining"].toString(), size),
            ],
          ),
          Divider(height: size.height * 0.03, thickness: 1),

          // Subscribed Date
          Text("Subscribed on",
              style:
              TextStyle(color: Colors.grey, fontSize: size.width * 0.035)),
          Text(subscription["subscribedOn"],
              style: TextStyle(
                  fontSize: size.width * 0.04, fontWeight: FontWeight.bold)),

          SizedBox(height: size.height * 0.02),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isActive)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChangePricesScreen()),
                    );
                  },
                  child: const Text("Change Prices"),
                ),
              SizedBox(width: size.width * 0.03),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: isActive ? Colors.green : Colors.black87,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: () {
                  _showJobPackageBottomSheet();
                },
                child: Text(isActive ? "Update" : "Renew"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildJobInfo(String label, String value, Size size) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey, fontSize: size.width * 0.035)),
        SizedBox(height: size.height * 0.005),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: size.width * 0.04)),
      ],
    );
  }

  void _showJobPackageBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Plan Update to",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Select job package",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(jobPackages.length, (index) {
                    return Column(
                      children: [
                        RadioListTile<int>(
                          value: index,
                          groupValue: selectedPackage,
                          onChanged: (val) {
                            setModalState(() {
                              selectedPackage = val;
                            });
                          },
                          title: Text(
                              "${jobPackages[index]["jobs"]} Jobs / ₹ ${jobPackages[index]["price"]}"),
                        ),
                        const Divider(),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const UpdatePlanScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedPackage != null
                          ? Colors.green
                          : Colors.grey.shade300,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      "Proceed",
                      style: TextStyle(
                          color: selectedPackage != null
                              ? Colors.white
                              : Colors.black54),
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
}

class CreateSubscriptionScreen extends StatefulWidget {
  const CreateSubscriptionScreen({super.key});

  @override
  State<CreateSubscriptionScreen> createState() =>
      _CreateSubscriptionScreenState();
}

class _CreateSubscriptionScreenState extends State<CreateSubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: deviceHeight,
          width: deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Top Bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth * 0.04,
                  vertical: deviceHeight * 0.015,
                ),
                child: Row(
                  children: [
                    CustomBackButton(),
                    SizedBox(width: deviceWidth * 0.02),
                    const Text(
                      "Create My Subscription",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: deviceHeight * 0.05),

              /// Illustration
              SizedBox(
                height: deviceHeight * 0.25,
                child: Image.asset(
                  "assets/images/subscription.png", // replace with your image asset
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: deviceHeight * 0.05),

              /// English Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.08),
                child: _buildText(
                  "Select your Service Category/Type and add prices to the services you want to provide to create the package.",
                ),
              ),

              SizedBox(height: deviceHeight * 0.015),

              /// Telugu Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.08),
                child: _buildText(
                  "మీ చెక్కౌట్ క్యాటగిరీ/రకాన్ని ఎంచుకుని, మీరు అందించాలనుకుంటున్న సర్వీస్ ఆర్డర్లకు ధరలను ఇన్పుట్ చేసిన ప్యాకేజీని సృష్టించండి.",
                ),
              ),

              SizedBox(height: deviceHeight * 0.04),

              /// Footer text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.08),
                child: _buildText(
                  'Watch "How to Create Subscription Package" video in tutorials for detailed assistance.',
                ),
              ),

              const Spacer(),

              /// Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth * 0.08,
                  vertical: deviceHeight * 0.03,
                ),
                child: _buildYellowButton(
                  title: "Get Started",
                  onPressed: () {
                    Navigator.pushNamed(
                      // ignore: use_build_context_synchronously
                      context,
                      Config.createPackageRouteName,
                    );

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Text
  Widget _buildText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
        height: 1.4,
      ),
    );
  }

  /// Reusable Button
  Widget _buildYellowButton({required String title, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD731), // Yellow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}