import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import '../../utils/config.dart';
import 'package:gobuddy/utils/config.dart';
// import 'package:providerapp_gobuddy/screens/referandearnpage.dart';
// import 'package:providerapp_gobuddy/screens/requesttoolpage.dart';
// import 'package:providerapp_gobuddy/screens/subscriptionScreens/create_subscription.dart';
// import 'package:providerapp_gobuddy/screens/subscriptionscreen.dart';
// import 'package:providerapp_gobuddy/screens/viewprofilepage.dart';
//
// import 'loginscreen.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // A reusable builder for the list tiles
  Widget _buildListTile(IconData icon, String title,
      {Color color = Colors.black, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, color: color),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double cardPadding = deviceWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient and header
          Container(
            height: deviceHeight * 0.28,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC8BB47), // Golden Yellow
                  Color(0xFF25AC2C),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                    child: Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // User Profile Card
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
                    child: Container(
                      padding: EdgeInsets.all(cardPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile image with checkmark icon
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: deviceWidth * 0.08,
                                    backgroundImage: AssetImage('assets/images/user.jpg'),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: deviceWidth * 0.04),
                              // User details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Akshay Kumar',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: deviceHeight * 0.005),
                                    const Text(
                                      'AC Technician / Electrician',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: deviceHeight * 0.005),
                                    const Text(
                                      'ID: AKSHI007',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: deviceHeight * 0.02),
                          // GB Coins section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'GB Coins',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white, // 👈 White background
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Color(0xFFFFD050), // 👈 Yellow border
                                    width: 1,             // Border thickness
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.monetization_on,
                                      color: Colors.orange,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '125',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Menu options
                  SizedBox(height: deviceHeight * 0.02),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  _buildListTile(Icons.person_outline, "View Profile",
                      onTap: () {
                         Navigator.pushNamed(
                        context,
                        Config.viewProfileRouteName,
                        );
                      }),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  _buildListTile(
                      Icons.subscriptions_outlined, "My Subscriptions",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Config.mySubscriptionsRouteName,
                        );
                      }),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  _buildListTile(
                      Icons.description_outlined, "Terms & Conditions",
                      onTap: () {
                        // Handle tap
                      }),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  _buildListTile(Icons.shield_outlined, "Privacy & Policy",
                      onTap: () {
                        // Handle tap
                      }),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  _buildListTile(Icons.support_agent_outlined, "Support",
                      onTap: () {
                        // Handle tap
                      }),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  _buildListTile(Icons.emoji_events_outlined, "Refer & Earn",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Config.referEarnRouteName,
                        );
                      }),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  _buildListTile(Icons.handyman_outlined, "Request Tool",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Config.requestToolRouteName,
                        );
                      }),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  _buildListTile(Icons.logout, "Logout", color: Colors.red,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm Logout"),
                              content:
                              const Text("Are you sure you want to logout?"),
                              actions: [
                                TextButton(
                                  child: const Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("Yes"),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed(
                                      Config.loginRouteName,);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }),
                  const Divider(height: 1, color: Color(0xFFE0E0E0)),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}
