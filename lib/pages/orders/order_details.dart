import 'dart:convert';
import 'package:flutter/material.dart';

import '../../components/button.dart';
import '../../utils/config.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Map<String, dynamic> orderData;
  final TextEditingController _orderCodeController = TextEditingController();
  int _selectedPaymentIndex = -1;
  bool _isVerified = false; // 🔹 New flag for Verify button state

  // New variables for extra service charge
  List<Map<String, dynamic>> _extraCharges = [];
  double _extraServiceTotal = 0.0;

  @override
  void initState() {
    super.initState();
    // Simulating fetched JSON data
    const String jsonData = '''
    {
      "serviceTitle": "AC Installation",
      "serviceType": "AC Service",
      "location": "Sheela Nagar, Gajuwaka, Visakhapatnam",
      "dateTime": "10/8/2024  12:00 AM",
      "orderId": "#356234",
      "price": 599.0,
      "travelingCharge": 60.0,
      "status": "In Progress",
      "customerName": "D. Viswak Varma",
      "phoneNumber": "9876543210",
      "altPhoneNumber": "9075643210",
      "imageUrl": "https://img.freepik.com/free-photo/man-installing-air-conditioner_53876-13823.jpg"
    }
    ''';
    orderData = json.decode(jsonData);
  }

  // Helper method to safely convert dynamic values to double
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final totalAmount = _parseDouble(orderData["price"]) +
        _parseDouble(orderData["travelingCharge"]) +
        _extraServiceTotal;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => {
            Navigator.pushNamed(
              // ignore: use_build_context_synchronously
              context,
              Config.myOrdersRouteName,

            )
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderCard(size),
            SizedBox(height: size.height * 0.02),
            _buildCustomerDetails(size),
            SizedBox(height: size.height * 0.02),
            _buildOrderCodeSection(size),
            SizedBox(height: size.height * 0.02),
            _buildUploadImagesSection(size),
            SizedBox(height: size.height * 0.02),
            _buildIssueButton(size),
            SizedBox(height: size.height * 0.02),
            _buildPriceDetails(size, totalAmount),
            SizedBox(height: size.height * 0.03),
            GradientButton(
              onPressed: () {

                Navigator.of(context).pushReplacementNamed(
                  Config.jobCalendarRouteName,
                );


              },
              child: Text(
                'Submit Details',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.04,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Order Card
  Widget _buildOrderCard(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT COLUMN (Image + Status)
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  orderData["imageUrl"],
                  width: size.width * 0.2,
                  height: size.width * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  orderData["status"],
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: size.width * 0.04),

          /// RIGHT COLUMN (Details + Price + Icon)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderData["serviceTitle"],
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  orderData["serviceType"],
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: size.width * 0.035,
                  ),
                ),
                SizedBox(height: size.height * 0.005),

                Row(
                  children: [
                    Icon(Icons.location_on, size: size.width * 0.04, color: Colors.black54),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        orderData["location"],
                        style: TextStyle(fontSize: size.width * 0.035),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.005),

                Row(
                  children: [
                    Icon(Icons.calendar_today, size: size.width * 0.04, color: Colors.black54),
                    SizedBox(width: 4),
                    Text(
                      orderData["dateTime"],
                      style: TextStyle(fontSize: size.width * 0.035),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.005),

                Text(
                  "Order id: ${orderData["orderId"]}",
                  style: TextStyle(fontSize: size.width * 0.035, color: Colors.black87),
                ),

                SizedBox(height: size.height * 0.01),

                /// PRICE & NAVIGATION ICON ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${orderData["price"]}",
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.navigation, color: Colors.orange, size: 28),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Order Code Section with Verify Button Logic
  Widget _buildOrderCodeSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Enter Order Code",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: size.width * 0.045)),
        SizedBox(height: size.height * 0.01),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _orderCodeController,
                decoration: InputDecoration(
                  hintText: "Enter code",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            ElevatedButton(
              onPressed: _isVerified
                  ? null
                  : () {
                setState(() {
                  _isVerified = true;
                });
                print("Order Code: ${_orderCodeController.text}");
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: _isVerified ? Colors.green : Colors.blue,
              ),
              child: Text(
                _isVerified ? "Verified" : "Verify",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Customer Details
  Widget _buildCustomerDetails(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Customer Details",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.045)),
          SizedBox(height: size.height * 0.01),
          Text("Name: ${orderData["customerName"]}",
              style: TextStyle(fontSize: size.width * 0.04)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Phone Number: ${orderData["phoneNumber"]}",
                  style: TextStyle(fontSize: size.width * 0.04)),
              const Icon(Icons.call, color: Colors.green, size: 20.0),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Alternative Number: ${orderData["altPhoneNumber"]}",
                  style: TextStyle(fontSize: size.width * 0.04)),
              const Icon(Icons.call, color: Colors.green, size: 20.0),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.message, color: Colors.grey),
            label: const Text("Send message"),
          ),
        ],
      ),
    );
  }

  /// Upload Images
  Widget _buildUploadImagesSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Upload Before and After Service Images",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.045)),
        SizedBox(height: size.height * 0.015),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Before",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: size.width * 0.035)),
            _imageBox(size),
            SizedBox(height: size.height * 0.015),
            Text("After",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: size.width * 0.035)),
            _imageBox(size),
          ],
        ),
      ],
    );
  }

  Widget _imageBox(Size size) {
    return Row(
      children: [
        Container(
          width: size.width * 0.35,
          height: size.width * 0.35,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.image, size: 40, color: Colors.grey),
        ),
        SizedBox(width: size.width * 0.03),
        const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  /// Issue Button
  Widget _buildIssueButton(Size size) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        child: const Text("Issue with service"),
      ),
    );
  }

  /// Price Details
  Widget _buildPriceDetails(Size size, double totalAmount) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.circle, size: 10),
              SizedBox(width: 5),
              Text("Pay after service"),
            ],
          ),
          const Divider(),
          _priceRow("AC Installation", _parseDouble(orderData["price"])),

          // Display extra service charges
          if (_extraCharges.isNotEmpty)
            Column(
              children: _extraCharges.map((charge) {
                return _priceRow(
                  charge['description'] ?? 'Extra Service',
                  _parseDouble(charge['amount']),
                );
              }).toList(),
            ),

          _priceRow("Extra Service charge", null, isAdd: true),
          _priceRow("Traveling Charge", _parseDouble(orderData["travelingCharge"])),
          const Divider(),
          _priceRow("Total Amount", totalAmount, isBold: true),
          SizedBox(height: size.height * 0.02),
          Container(
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Payment via",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _paymentOption(0, "Payment via PhonePe"),
                _paymentOption(1, "By hand cash"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String title, double? amount,
      {bool isBold = false, bool isAdd = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          GestureDetector(
            onTap: isAdd
                ? () {
              _showAddServiceChargeDialog();
            }
                : null,
            child: Text(
              isAdd
                  ? "ADD"
                  : amount != null
                  ? "₹${amount.toStringAsFixed(2)}"
                  : "",
              style: TextStyle(
                color: isAdd ? Colors.green : Colors.black,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Popup for Adding Extra Service Charge - FIXED VERSION
  void _showAddServiceChargeDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Extra Service Charge",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Enter Amount
                            TextFormField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter Amount",
                                prefixIcon: const Icon(Icons.currency_rupee),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an amount';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 13),

                            /// Add Description
                            TextFormField(
                              controller: descController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: "Add Description",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            double amount = double.parse(amountController.text);
                            String description = descController.text;

                            // Add the extra charge
                            setState(() {
                              _extraCharges.add({
                                'amount': amount,
                                'description': description
                              });
                              _extraServiceTotal += amount;
                            });

                            print("Extra Charge Added: ₹$amount, Desc: $description");
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _paymentOption(int index, String title) {
    return RadioListTile<int>(
      title: Text(title),
      value: index,
      groupValue: _selectedPaymentIndex,
      onChanged: (val) {
        setState(() {
          _selectedPaymentIndex = val!;
        });
      },
    );
  }

  /// Submit Button
  Widget _buildSubmitButton(Size size) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // Remove backgroundColor and use foregroundColor for text color
          foregroundColor: Colors.white,
          // Set transparent background to allow the gradient to show
          backgroundColor: Colors.transparent,
          // Remove shadow
          elevation: 0,
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Details Submitted")));
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFd4c900), Color(0xFF00ad20)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(
              minWidth: double.infinity,
              minHeight: size.height * 0.035 * 2, // Match button padding
            ),
            child: const Text(
              "Submit Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16, // Optional: adjust font size if needed
              ),
            ),
          ),
        ),
      ),
    );
  }
}