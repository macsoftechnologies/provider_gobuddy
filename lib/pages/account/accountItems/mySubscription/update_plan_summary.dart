import 'package:flutter/material.dart';

import '../../../../components/custom_back_button.dart';
import '../../../paymentGateway/payment_screen.dart';

// import '../../utilites/custombackbutton.dart';
// import '../payment_screen.dart';

class UpdateSummaryScreen extends StatefulWidget {
  final String title;
  final String oldPlan;
  final int oldPrice;
  final String newPlan;
  final int newPrice;
  final String couponCode;
  final int discount;

  const UpdateSummaryScreen({
    super.key,
    this.title = "Summary",
    this.oldPlan = "AC Technician\nBasic Plan (20 Jobs)",
    this.oldPrice = 999,
    this.newPlan = "AC Technician\nBasic Plan (40 Jobs)",
    this.newPrice = 1499,
    this.couponCode = "AKSH1007",
    this.discount = 150,
  });

  @override
  State<UpdateSummaryScreen> createState() => _UpdateSummaryScreenState();
}

class _UpdateSummaryScreenState extends State<UpdateSummaryScreen> {
  bool isCouponApplied = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;
    final double height = size.height;

    int total = widget.newPrice;
    int discount = isCouponApplied ? widget.discount : 0;
    int toPay = total - discount;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// ---------- HEADER ----------
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.015),
              child: Row(
                children: [
                  CustomBackButton(),
                  SizedBox(width: width * 0.03),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: width * 0.055,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ---------- UPDATE PLAN ----------
                      Row(
                        children: [
                          Icon(Icons.sync,
                              color: Colors.orange, size: width * 0.06),
                          SizedBox(width: width * 0.02),
                          Text(
                            "Update Plan",
                            style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.015),

                      /// ---------- PLAN CARD ----------
                      Container(
                        padding: EdgeInsets.all(width * 0.04),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildPlanText(widget.oldPlan,
                                      widget.oldPrice, width, isOld: true),
                                  SizedBox(height: height * 0.01),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  _buildPlanText(widget.newPlan,
                                      widget.newPrice, width),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),

                      /// ---------- OFFERS ----------
                      _buildOfferSection(width, height),

                      SizedBox(height: height * 0.02),

                      /// ---------- PRICE SUMMARY ----------
                      _buildPriceSection(total, discount, toPay, width, height),

                      SizedBox(height: height * 0.12),
                    ],
                  ),
                ),
              ),
            ),

            /// ---------- BOTTOM BAR ----------
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.015),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹ $toPay",
                        style: TextStyle(
                          fontSize: width * 0.055,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "To be paid now",
                        style: TextStyle(
                          fontSize: width * 0.035,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.1, vertical: height * 0.018),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // Handle payment
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentMethodScreen(amount: toPay.toDouble(), fromScreen: '',)),
                      );
                    },
                    child: Text(
                      "Proceed to Pay",
                      style: TextStyle(
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- Helper Widgets ----------
  Widget _buildPlanText(String title, int price, double width,
      {bool isOld = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: width * 0.04,
            fontWeight: FontWeight.w600,
            color: isOld ? Colors.black87 : Colors.black,
          ),
        ),
        Text(
          "₹ $price",
          style: TextStyle(
            fontSize: width * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildOfferSection(double width, double height) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer,
                  color: Colors.green, size: width * 0.06),
              SizedBox(width: width * 0.02),
              Text(
                "Offers",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          Text(
            "Enter coupon code and save on this Packages",
            style: TextStyle(
              fontSize: width * 0.04,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: height * 0.01),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.015),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade200,
                  ),
                  child: Text(
                    widget.couponCode,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                ),
              ),
              SizedBox(width: width * 0.03),
              if (isCouponApplied)
                Text("✔ Applied",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(
      int total, int discount, int toPay, double width, double height) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long,
                  color: Colors.green, size: width * 0.06),
              SizedBox(width: width * 0.02),
              Text(
                "To pay  ₹ $total",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.015),
          Divider(thickness: 1, color: Colors.grey.shade300),
          _buildPriceRow("Total", "₹ $total", width),
          _buildPriceRow("Discount on coupon", "- ₹ $discount", width,
              isDiscount: true),
          Divider(thickness: 1, color: Colors.grey.shade300),
          _buildPriceRow("To Pay", "₹ $toPay", width, isBold: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, double width,
      {bool isDiscount = false, bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: isBold ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: width * 0.045,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isDiscount ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
