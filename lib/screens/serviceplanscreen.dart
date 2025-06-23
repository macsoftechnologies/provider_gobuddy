import 'package:flutter/material.dart';

class ServicePlanScreen extends StatefulWidget {
  @override
  _ServicePlanScreenState createState() => _ServicePlanScreenState();
}

class _ServicePlanScreenState extends State<ServicePlanScreen> {
  final Color green = Color(0xFF4CAF50);
  final Color orange = Colors.orange;

  int selectedCategoryIndex = 0;
  List<String> categories = ['Split AC', 'Cassette AC'];

  TextEditingController price1Controller = TextEditingController(text: "499");
  TextEditingController discount1Controller = TextEditingController(text: "20");

  TextEditingController price2Controller = TextEditingController(text: "1299");
  TextEditingController discount2Controller = TextEditingController();

  double calculateTotal(String price, String discount) {
    final p = double.tryParse(price) ?? 0.0;
    final d = double.tryParse(discount) ?? 0.0;
    return p - (p * d / 100);
  }

  @override
  Widget build(BuildContext context) {
    double total1 = calculateTotal(price1Controller.text, discount1Controller.text);
    double total2 = calculateTotal(price2Controller.text, discount2Controller.text);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Image
            Stack(
              children: [
                Image.asset('assets/ac.png', height: 180, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 16,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 16,
                  child: Text("AC Technician", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                )
              ],
            ),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  children: [
                    // Plan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Basic Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text("₹ 999", style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(width: 10),
                            Text("20 Jobs"),
                            SizedBox(width: 10),
                            Icon(Icons.check_circle, color: green),
                            Text(" Added", style: TextStyle(color: green)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),

                    // Category Selector
                    Row(
                      children: List.generate(categories.length, (index) {
                        bool selected = selectedCategoryIndex == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => selectedCategoryIndex = index);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: selected ? green : Colors.grey),
                                color: selected ? Colors.green.shade50 : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    index == 0 ? 'assets/ac.png' : 'assets/ac.png',
                                    height: 50,
                                  ),
                                  SizedBox(height: 5),
                                  Text(categories[index], style: TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20),

                    // Service Card 1
                    serviceItem(
                      image: 'assets/ac.png',
                      title: 'Dry Servicing a Split Ac',
                      priceController: price1Controller,
                      discountController: discount1Controller,
                      total: total1,
                    ),
                    SizedBox(height: 10),

                    // Service Card 2
                    serviceItem(
                      image: 'assets/ac.png',
                      title: 'AC Installation',
                      priceController: price2Controller,
                      discountController: discount2Controller,
                      total: total2,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AC Technician", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Basic Plan (20 Jobs)", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 10),
                  Text("₹ 999", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, side: BorderSide(color: green)),
                      child: Text("Add More", style: TextStyle(color: green)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: green),
                      child: Text("View Summary"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget serviceItem({
    required String image,
    required String title,
    required TextEditingController priceController,
    required TextEditingController discountController,
    required double total,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(image, height: 50, width: 50),
              SizedBox(width: 10),
              Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Discount (%)'),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(width: 10),
              Text("Total ₹ ${total.toStringAsFixed(0)}"),
            ],
          ),
        ],
      ),
    );
  }
}
