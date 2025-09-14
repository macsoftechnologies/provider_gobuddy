import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gobuddy/data/preferences.dart';
import 'package:gobuddy/services/end_points.dart';
import 'package:gobuddy/services/repository.dart';
import 'package:gobuddy/utils/config.dart';
import 'package:gobuddy/utils/util_class.dart';

import '../account/account_screen.dart';
import '../orders/my_orders.dart';
// import 'package:providerapp_gobuddy/screens/accountpage.dart';
//
// import 'myOrders/my_orders.dart';
// import 'package:providerapp_gobuddy/screens/myorderscreen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentIndex = 0;
  dynamic profileDetails = {};
  Color green = Color(0xFF4CAF50);
  dynamic userData = {};

  @override
  void initState() {
    super.initState();

    var userDataValue = Preferences.getUserDetails();
    if (userDataValue != null) {
      userData = json.decode(userDataValue);
    }

    callgetProfileAPI();
  }

  void callgetProfileAPI() async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.profile, {
        "user_id": userData["user_id"] ?? "4361",
      }).then((value) async {
        UtilClass.hideProgress();
        dynamic parsed = {};
        try {
          parsed = await json.decode(value);
          if (parsed["status"] == "valid") {
            profileDetails = parsed["profile"];

            setState(() {
              profileDetails = parsed["profile"];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green,
      //
      // ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: currentIndex,
        // ✅ Green color for selected item
        selectedItemColor: green,

        // ✅ Grey color for unselected items
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: getBody(currentIndex),
    );
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return dashboardScreen();
      case 1:
        return MyOrdersScreen(); //MyOrdersScreen
      case 2:
        return AccountPage(); //AccountPage
      default:
        return dashboardScreen();
    }
  }

  Widget dashboardScreen() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 1),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFC8BB47), // green
                    Color(0xFF25AC2C), // light green
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ), //BorderRadius.vertical(bottom: Radius.circular(25)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/user.jpg'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             profileDetails["name"]??"",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "AC Technician / Electrician",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "PENDING",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF7F7F7), Color(0xFFFFFFFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Left side Image
                          Image.asset(
                            "assets/images/coins.png", // Replace with your image path
                            height: 70,
                            width: 70,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 20),

                          // Right side container
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // GB Coins row
                                Row(
                                  children: [
                                    const Text(
                                      "GB Coins",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.monetization_on,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 2),
                                        const Text(
                                          "125",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Price
                                const Text(
                                  "₹ 0.0/0",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Button
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    "Total Earnings",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "35/08-PM Palem, Madhurawada, Visakhapatnam...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.calendar_today),
                          label: Text(
                            "My job calendar",
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: green,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.qr_code),
                          label: Text(
                            "Show my QR code",
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  statusCard("₹ 2,500\n(20)", "Current Month", Color(0xFFFF7DA7)),
                  statusCard("₹ 700\n(10)", "Pending Orders", Color(0xFF62D5F8)),
                  statusCard("₹ 500\n(5)", "Today Orders", Color(0xFF58C75E)),
                  statusCard("₹ 100\n(2)", "Missed Orders", Color(0xFFFF913C)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statusCard(String amount, String title, Color color) {
    return Container(
      height: 90, // Add this line for height
      width: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            amount,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
