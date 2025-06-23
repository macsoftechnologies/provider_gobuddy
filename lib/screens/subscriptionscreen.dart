import 'package:flutter/material.dart';
import 'package:providerapp_gobuddy/screens/serviceplanscreen.dart';

class EmptySubscriptionScreen extends StatefulWidget {
  @override
  _EmptySubscriptionScreenState createState() => _EmptySubscriptionScreenState();
}

class _EmptySubscriptionScreenState extends State<EmptySubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create My Subscription"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset('assets/empty_subscription.png', height: 200), // Replace with your image
            SizedBox(height: 20),
            Text(
              "Select your Service Category/Type and add prices for the services you want to provide to create the package.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Watch ‘How to Create Subscription Package’ video in tutorials for detailed assistance.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectSkillCategoryScreen()),
                );
              },
              child: Text("Get Started"),
            )
          ],
        ),
      ),
    );
  }
}
class SelectSkillCategoryScreen extends StatefulWidget {
  @override
  _SelectSkillCategoryScreenState createState() => _SelectSkillCategoryScreenState();
}

class _SelectSkillCategoryScreenState extends State<SelectSkillCategoryScreen> {
  final List<String> skills = [
    "AC Technician",
    "Electrician",
    "Cleaning Service",
    "Plumber",
    "Beauty Service",
    "Painting"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Your Package"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: skills.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/icon${index + 1}.png'), // Replace with actual images
            ),
            title: Text(skills[index]),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChoosePlanScreen(category: skills[index])),
              );
            },
          );
        },
      ),
    );
  }
}


class ChoosePlanScreen extends StatefulWidget {
  final String category;
  ChoosePlanScreen({required this.category});

  @override
  _ChoosePlanScreenState createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  String selectedPlan = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildPlanCard("Basic Plan", "Split AC & Tower AC"),
            SizedBox(height: 10),
            buildPlanCard("Advanced Plan", "All AC Services"),
            Spacer(),
            ElevatedButton(
              onPressed: selectedPlan.isNotEmpty
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServicePlanScreen(),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor:
                selectedPlan.isNotEmpty ? Colors.green : Colors.grey,
              ),
              child: Text("Continue"),
            )

          ],
        ),
      ),
    );
  }

  Widget buildPlanCard(String title, String subtitle) {
    bool isSelected = selectedPlan == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = title;
        });
      },
      child: Container (
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration (
          color: isSelected ? Colors.green.shade100 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.green : Colors.black)),
                  Text(subtitle,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
