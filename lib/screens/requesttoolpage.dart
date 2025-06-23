import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../utilites/dailogbox.dart';
class RequestToolPage extends StatefulWidget {
  @override
  _RequestToolPageState createState() => _RequestToolPageState();
}

class _RequestToolPageState extends State<RequestToolPage> {
  TextEditingController toolNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool imageSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request Tool"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: toolNameController,
              decoration: InputDecoration(labelText: "Tool Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  imageSelected = !imageSelected;
                });
              },
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: imageSelected
                      ? Icon(Icons.check_circle, color: Colors.green, size: 40)
                      : Icon(Icons.add_photo_alternate_outlined, size: 40),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // submit logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
class RequestToolFilledPage extends StatefulWidget {
  @override
  _RequestToolFilledPageState createState() => _RequestToolFilledPageState();
}

class _RequestToolFilledPageState extends State<RequestToolFilledPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request Tool"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              decoration: InputDecoration(labelText: "Tool Name", hintText: "Tube Bender"),
            ),
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              maxLines: 3,
              decoration: InputDecoration(
                  labelText: "Description",
                  hintText:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
            ),
            SizedBox(height: 20),
            Container(
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Image.asset("assets/tube_bender.png"), // Replace with your image
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => RequestSubmittedPage()));
                showCustomDialog(
                  context: context,
                  message: 'Request Tool Submitted ',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
