import 'package:flutter/material.dart';
import 'package:providerapp_gobuddy/screens/oderDetailsscreen.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> with SingleTickerProviderStateMixin {
  int _bottomNavIndex = 0;
  late TabController _tabController;

  final List<Tab> orderTabs = [
    Tab(text: "Pending"),
    Tab(text: "Open"),
    Tab(text: "Completed"),
    Tab(text: "Canceled"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: orderTabs.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      if (_tabController.index == 1) {
        // If "Open" tab is selected (index 1)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderDetailsScreen()),
        );
      }
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildOrderCard(String title, String price, String status) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset('assets/ac.png', width: 50, height: 100), // placeholder image
        title: Text(title),
        subtitle: Text("Location • Date • Time"),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("₹ $price", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor(status),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Open':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildOrderList(String status) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        buildOrderCard("AC Installation", "599", status),
        buildOrderCard("Jet servicing split AC", "899", status),
        buildOrderCard("Dry servicing", "499", status),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          tabs: orderTabs,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrderList("Pending"),
          buildOrderList("Open"),
          buildOrderList("Completed"),
          buildOrderList("Canceled"),
        ],
      ),

    );
  }
}
