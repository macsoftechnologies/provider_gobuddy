import 'package:flutter/material.dart';

class ReferAndEarnPage extends StatefulWidget {
  @override
  _ReferAndEarnPageState createState() => _ReferAndEarnPageState();
}

class _ReferAndEarnPageState extends State<ReferAndEarnPage> {
  final referralCode = "AKSHI007";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refer & Earn"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset("assets/refer.png", height: 200), // Replace with your asset
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.looks_one),
                SizedBox(width: 10),
                Expanded(child: Text("Refer a friend or family member")),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.looks_two),
                SizedBox(width: 10),
                Expanded(
                    child: Text(
                        "When they register or order:\nA. You receive 5 GB coins\nB. They get ₹100 off")),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(referralCode, style: TextStyle(fontSize: 16)),
                  TextButton(onPressed: () {}, child: Text("Copy"))
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50)),
              onPressed: () {
                // share logic here
              },
              child: Text("Refer Now"),
            )
          ],
        ),
      ),
    );
  }
}
