import 'package:flutter/material.dart';
import 'package:providerapp_gobuddy/screens/loginscreen.dart';
import 'package:providerapp_gobuddy/screens/referandearnpage.dart';
import 'package:providerapp_gobuddy/screens/requesttoolpage.dart';
import 'package:providerapp_gobuddy/screens/subscriptionscreen.dart';
import 'package:providerapp_gobuddy/screens/viewprofilepage.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Account"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/avatar.png"), // Replace with actual image
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Akshay Kumar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("AC Technician / Electrician"),
                    Text("ID: AKSH007", style: TextStyle(color: Colors.grey)),
                    Row(
                      children: [
                        Icon(Icons.monetization_on, color: Colors.orange),
                        SizedBox(width: 4),
                        Text("125 GB Coins"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildListTile(Icons.person, "View Profile"),
                _buildListTile(Icons.subscriptions, "My Subscriptions"),
                _buildListTile(Icons.article, "Terms & Conditions"),
                _buildListTile(Icons.privacy_tip, "Privacy & Policy"),
                _buildListTile(Icons.support_agent, "Support"),
                _buildListTile(Icons.share, "Refer & Earn"),
                _buildListTile(Icons.build, "Request Tool"),
                _buildListTile(Icons.logout, "Logout", color: Colors.red),
              ],
            ),
          )
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 2,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      //     BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Account"),
      //   ],
      // ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {Color color = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (title == "View Profile") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfilePage()));
        }
       else if (title == "My Subscriptions") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => EmptySubscriptionScreen()));
        }
        else if (title == "Refer & Earn") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ReferAndEarnPage()));
        }
        else if (title == "Request Tool") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => RequestToolPage()));
        }
        else if (title == "Logout") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Logout"),
                content: Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));

                      // Navigate to login screen
                      // Or use:
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                  ),
                ],
              );
            },
          );
        }

      },
    );
  }
}
