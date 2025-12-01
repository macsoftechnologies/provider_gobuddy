import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gobuddy/data/preferences.dart';
import 'package:gobuddy/pages/dashboard/dashboardTab_screen.dart';
//mr
import '../account/account_screen.dart';
import '../orders/my_orders.dart';
// import 'package:providerapp_gobuddy/screens/accountpage.dart';
//
// import 'myOrders/my_orders.dart';
// import 'package:providerapp_gobuddy/screens/myorderscreen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentIndex = 0;
  dynamic profileDetails = {};
  Color green = Color(0xFF4CAF50);
  dynamic userData = {};



  // JSON Data Structure for Dynamic Screen
  

  @override
  void initState() {
    super.initState();

    var userDataValue = Preferences.getUserDetails();
    if (userDataValue != null) {
      userData = json.decode(userDataValue);
    }

    
    //sk
    

    // Fallback in case currentMonth is not found
    
  }

    @override
  void dispose() {
  
    super.dispose();
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
        return DashboardTabScreen();
      case 1:
        return MyOrdersScreen(); //MyOrdersScreen
      case 2:
        return AccountPage(); //AccountPage
      default:
        return DashboardTabScreen();
    }
  }

  
}
