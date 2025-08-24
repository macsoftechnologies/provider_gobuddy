import 'package:flutter/material.dart';

import '../../../../components/button.dart';



class ReferAndEarnPage extends StatefulWidget {
  @override
  _ReferAndEarnPageState createState() => _ReferAndEarnPageState();
}

class _ReferAndEarnPageState extends State<ReferAndEarnPage> {
  final referralCode = "AKSHI007";

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refer & Earn"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFC8BB47), // Golden Yellow
                Color(0xFF25AC2C),], // 👈 Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset("assets/images/referAndEarn.png", height: 200), // Replace with your asset
            SizedBox(height: 30),
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
            SizedBox(height: 25),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.green,
            //       minimumSize: Size(double.infinity, 50)),
            //   onPressed: () {
            //     // share logic here
            //   },
            //   child: Text("Refer Now"),
            // )
            GradientButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => InstructionsTwo()),
                // );
              },
              child: Text(
                'Refer Now',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth * 0.04,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
