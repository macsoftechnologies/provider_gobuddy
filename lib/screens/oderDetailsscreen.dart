import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? selectedPaymentMethod;
  TextEditingController orderCodeController = TextEditingController();

  @override
  void dispose() {
    orderCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text("Order Details", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Order Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset('assets/ac.png', width: 70, height: 70, fit: BoxFit.cover),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("AC Installation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text("AC Service"),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Expanded(child: Text("Sheela Nagar, Gajuwaka, Visakhapatnam")),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text("10/8/2024 12:00 AM"),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text("In Progress", style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Order id: #356234"),
                            Text("₹ 599", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            /// Customer Details
            Text("Customer Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Name: D. Viswak Varma"),
            Text("Phone Number: 9876543210"),
            Text("Alternative Number: 9075643210"),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Send message",
                prefixIcon: Icon(Icons.message),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            SizedBox(height: 20),

            /// Enter Order Code
            Text("Enter Order Code", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: orderCodeController,
              decoration: InputDecoration(
                hintText: "Enter code",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                minimumSize: Size(double.infinity, 45),
              ),
              child: Text("Verify", style: TextStyle(color: Colors.grey)),
            ),

            SizedBox(height: 24),

            /// Image Upload Section
            Text("Upload Before and After Service Images", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Before"),
                    SizedBox(height: 6),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.green.shade100,
                  child: Icon(Icons.add, color: Colors.green),
                )
              ],
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("After"),
                    SizedBox(height: 6),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.green.shade100,
                  child: Icon(Icons.add, color: Colors.green),
                )
              ],
            ),

            SizedBox(height: 20),

            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: Text("Issue with service"),
            ),

            SizedBox(height: 20),

            /// Payment Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.radio_button_checked, size: 16),
                        SizedBox(width: 8),
                        Text("Pay after service"),
                      ],
                    ),
                    Divider(height: 20),
                    Text("Service Price Details", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    rowItem("AC Installation", "₹ 599"),
                    rowItem("Extra Service charge", "ADD", color: Colors.green),
                    rowItem("Traveling Charge", "₹ 60"),
                    Divider(height: 20),
                    rowItem("Total Amount", "₹ 659", isBold: true),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Payment via", style: TextStyle(fontWeight: FontWeight.bold)),
                          RadioListTile(
                            value: "phonepe",
                            groupValue: selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentMethod = value.toString();
                              });
                            },
                            title: Text("Payment via phonepe"),
                          ),
                          RadioListTile(
                            value: "cash",
                            groupValue: selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentMethod = value.toString();
                              });
                            },
                            title: Text("By hand cash"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            /// Submit Button
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                minimumSize: Size(double.infinity, 45),
              ),
              child: Text("Submit Details", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowItem(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? TextStyle(fontWeight: FontWeight.bold) : null),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
