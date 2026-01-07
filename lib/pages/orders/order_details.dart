import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gobuddy/data/preferences.dart';
import 'package:gobuddy/services/end_points.dart';
import 'package:gobuddy/services/repository.dart';
import 'package:gobuddy/utils/util_class.dart';
import '../../models/cancel_reasons.dart';
import '../../components/button.dart';
import '../../utils/config.dart';
import 'package:image_picker/image_picker.dart';

class OrderDetailsScreen extends StatefulWidget {
  final dynamic order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Map<String, dynamic> orderData;
  dynamic orderDetails = {};
  final TextEditingController _orderCodeController = TextEditingController();
  int _selectedPaymentIndex = 0;
  bool _isVerified = false; // 🔹 New flag for Verify button state
  bool _isloaderservice = false;
  // New variables for extra service charge

  ////////services
  late Map<String, dynamic> serviceData;
  final TextEditingController _serviceCodeController = TextEditingController();
  // ---------- SERVICES LIST (MULTIPLE SERVICE ORDERS) ----------
  List<dynamic> servicesData = [];

  int selectedServiceIndex = 0;
  dynamic userData = {};
  List<Map<String, dynamic>> _extraCharges = [];
  double _extraServiceTotal = 0.0;


  final Map<String, dynamic> cancelReasonsJson = {
    "cancelReasons": [
      {"id": "1", "reason": "Changed my mind"},
      {"id": "2", "reason": "Service not required"},
      {"id": "3", "reason": "Price is high"},
      {"id": "4", "reason": "Booked by mistake"},
      {"id": "999", "reason": "Others"}, // <-- always last
    ],
  };

  GetCancelOrderReasons? cancelReasonsData;

  // ------------------ IMAGE PICKER ------------------
  final ImagePicker picker = ImagePicker();

  Future<void> pickServiceImage(bool isBefore) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isBefore) {
          servicesData[selectedServiceIndex]["beforeImages"].add(
            File(pickedFile.path),
          );
        } else {
          servicesData[selectedServiceIndex]["afterImages"].add(
            File(pickedFile.path),
          );
        }
      });
    }
  }
  /////////services end

  @override
  void initState() {
    super.initState();
    // Simulating fetched JSON data
_getCancelReasons();
    var userDataValue = Preferences.getUserDetails();
    if (userDataValue != null) {
      userData = json.decode(userDataValue);
    }

    callOrdersPI();
  }
   void _getCancelReasons() async {
    try {
      // TODO: Replace with your GET API logic
      await Future.delayed(const Duration(milliseconds: 300));

      cancelReasonsData = GetCancelOrderReasons.fromJson(cancelReasonsJson);

      setState(() {});
    } catch (e) {
      debugPrint("Cancel reasons API error: $e");
    }
  }

  void submitOrdersPI() async {
    print(_extraCharges);

    final List<dynamic> labels = _extraCharges
        .map((city) => city["description"])
        .toList();
    final List<dynamic> amounts = _extraCharges
        .map((city) => city["amount"])
        .toList();
    var finalData = {
      "job_calender_id": widget.order["id"],
      "payment_type": _selectedPaymentIndex == 0 ? "phonepay" : "cash",
      "travelling_charges": "50",
      "add_extra_charges": amounts,
      "reason_for_extracharges": labels,
    };

    bool isallimages = true;

    List<dynamic> finalServices = [];
    for (int i = 0; i < servicesData.length; i++) {
      List<dynamic> beforeImages = servicesData[i]["beforeImages"];
      List<dynamic> afterImages = servicesData[i]["afterImages"];
      List<MultipartFile> multipartFilesbefore = [];
      List<MultipartFile> multipartFilesafter = [];
      if (afterImages.isNotEmpty && beforeImages.isNotEmpty) {
        multipartFilesbefore = beforeImages.map((image) {
          // Extract the filename from the path
          String fileName = image.path.split('/').last;
          return MultipartFile.fromFileSync(
            image.path,
            filename: "before$fileName",
            // contentType: MediaType('image', 'jpeg'), // Optional: specify media type
          );
        }).toList();

        multipartFilesafter = afterImages.map((image) {
          // Extract the filename from the path
          String fileName = image.path.split('/').last;
          return MultipartFile.fromFileSync(
            image.path,
            filename: "after$fileName",
            // contentType: MediaType('image', 'jpeg'), // Optional: specify media type
          );
        }).toList();
      } else {
        isallimages = false;
        // UtilClass.showAlertDialog(context: context, message:"P[lease]");

        //         return;
      }

      if (!isallimages) {
        UtilClass.showAlertDialog(
          context: context,
          message: "Please upload all services required Images",
        );
        return;
      }

      List<dynamic> combinedList = [
        ...multipartFilesbefore,
        ...multipartFilesafter,
      ];

      var formData = FormData.fromMap({
        "provider_id": "4434",
        "images[]": combinedList,
        "service_id": servicesData[i]["service_id"],
        'order_id': widget.order["id"],
      });

      finalServices.add(
        Repository.postimagesApiService(EndPoints.addImages, formData),
      );
    }

    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      List<dynamic> resultsd = await Future.wait(
        finalServices.cast<Future<dynamic>>(),
      );

      print(resultsd);
      print("completed");
      //  UtilClass.showAlertDialog(context: context, message:"uplaoded");

      UtilClass.showProgress(context: context);

      await Repository.postApiServiceWithJson(
        EndPoints.submitDetails,
        finalData,
      ).then((value) async {
        UtilClass.hideProgress();

        dynamic parsed = value;
        try {
          if (parsed["status"] == "success") {
            Navigator.pushNamed(
              // ignore: use_build_context_synchronously
              context,
              Config.myOrdersRouteName,
            );
            Future.delayed(const Duration(seconds: 1), () {
              UtilClass.showAlertDialog(
                // ignore: use_build_context_synchronously
                context: context,
                message: parsed["message"],
              );
            });
          } else {
            // ignore: use_build_context_synchronously
            UtilClass.showAlertDialog(
              // ignore: use_build_context_synchronously
              context: context,
              message: parsed["message"],
            );
          }
        } catch (e) {
          print(e);
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  void callOrdersPI() async {
    print(widget.order);
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.orderDetails, {
        "order_id": widget.order["id"],
      }).then((value) async {
        UtilClass.hideProgress();

        dynamic parsed = await json.decode(value);
        try {
          if (parsed["status"] == true) {
            for (int i = 0; i < parsed["data"]["services"].length; i++) {
              parsed["data"]["services"][i]["beforeImages"] = [];
              parsed["data"]["services"][i]["afterImages"] = [];
              parsed["data"]["services"][i]["is_photos_upload"] = false;
            }

            setState(() {
              orderDetails = parsed["data"];
              servicesData = parsed["data"]["services"];
              serviceData = parsed["data"]["services"][0];
            });

            setState(() {
              _isloaderservice = true;
            });
            ;
          } else {
            // ignore: use_build_context_synchronously
            UtilClass.showAlertDialog(
              // ignore: use_build_context_synchronously
              context: context,
              message: parsed["message"],
            );
          }
        } catch (e) {
          print(e);
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  void callVerifyAPI(code) async {
    print(widget.order);
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.verifyCode, {
        "order_id": widget.order["id"],
        "code": code,
      }).then((value) async {
        UtilClass.hideProgress();

        dynamic parsed = await json.decode(value);
        try {
          if (parsed["status"] == true) {
            setState(() {
              _isVerified = true;
            });
          } else {
            // ignore: use_build_context_synchronously
            UtilClass.showAlertDialog(
              // ignore: use_build_context_synchronously
              context: context,
              message: parsed["message"],
            );
          }
        } catch (e) {
          print(e);
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }
 void callCancelAPI(code) async {
    print(widget.order);
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.cancelOrders, {
        "order_id": widget.order["id"],
       
      }).then((value) async {
        UtilClass.hideProgress();

        dynamic parsed = await json.decode(value);
        try {
          if (parsed["status"] == true) {
           _showCancelRequestPopup(context);
            


             Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushNamed(
              // ignore: use_build_context_synchronously
              context,
              Config.myOrdersRouteName,
            );
            });
            
          } else {
            // ignore: use_build_context_synchronously
            UtilClass.showAlertDialog(
              // ignore: use_build_context_synchronously
              context: context,
              message: parsed["message"],
            );
          }
        } catch (e) {
          print(e);
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
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
    // final totalAmount = _parseDouble(orderData["price"]) +
    //     _parseDouble(orderData["travelingCharge"]) +
    //     _extraServiceTotal;
    ////ser
    ///
    ///
    ///
    ///if
    ///
    ///
    ///
    ///

    double servicesTotal = 0;
    for (var item in servicesData) {
      servicesTotal += _parseDouble(item["price"]);
    }

    // double travelingTotal = 0;
    // for (var item in servicesData) {
    //   travelingTotal += _parseDouble(item["travelingCharge"]);
    // }

    final totalAmount = servicesTotal + _extraServiceTotal;
    //ser end

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
            ),
          },
        ),
      ),
      body: _isloaderservice
          ? SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderCard(size),
                  SizedBox(height: size.height * 0.02),
                  _buildCustomerDetails(size),
                  // SizedBox(height: size.height * 0.02),
                  // _buildOrderCodeSection(size),
                  SizedBox(height: size.height * 0.02),

                  //serv
                  // ---------------- SERVICE TABS ----------------
                  Text(
                    'Order Have ${servicesData.length} Services',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,

                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildServiceTabs(size), // servicesData.length

                          const SizedBox(height: 20),

                          // ---------------- SELECTED SERVICE CARD ----------------
                          _buildSelectedServiceCard(size),

                          const SizedBox(height: 25),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: _buildUploadImageTitle(size),
                          ),

                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: _imageUploadSection(size),
                          ),

                          const SizedBox(height: 15),

                          _buildActionButtons(size),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //old price
                  _buildPriceDetails(size, totalAmount),
                  SizedBox(height: size.height * 0.03),
                  GradientButton(
                    onPressed: () {
                      // Navigator.of(context).pushReplacementNamed(
                      //   Config.jobCalendarRouteName,
                      // );

                      submitOrdersPI();
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
            )
          : Container(),
    );
  }

  //cancel order
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: height * 0.03,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cancel Service ?',
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: height * 0.015),
                Text(
                  'Are you sure you want to Cancel your service',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: width * 0.3,
                      height: height * 0.055,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.3,
                      height: height * 0.055,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showCancelReasonSheet(context, cancelReasonsData);

                          // callCancelAPI("");
                          // ;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCancelRequestPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap OK
      builder: (BuildContext context) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: height * 0.03,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: width * 0.22,
                  width: width * 0.22,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFA726), // light orange background
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: width * 0.12,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.025),
                Text(
                  "Cancel Request Submitted",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: height * 0.015),
                Text(
                  "Your cancellation request has been submitted. Sorry to see you go, one of our representatives will contact you to initiate cancellation or you can message/call us at 9347785705.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: height * 0.035),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // close popup
                      // Navigator.pushReplacementNamed(context, '/nextScreen');
                      // Replace '/nextScreen' with your actual screen route
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A651), // green
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(vertical: height * 0.018),
                    ),
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          // Column(
          //   children: [
          //     // ClipRRect(
          //     //   borderRadius: BorderRadius.circular(12),
          //     //   child: Image.network(
          //     //     orderData["imageUrl"],
          //     //     width: size.width * 0.2,
          //     //     height: size.width * 0.2,
          //     //     fit: BoxFit.cover,
          //     //   ),
          //     // ),
          //     SizedBox(height: size.height * 0.01),
          //     Container(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 12,
          //         vertical: 6,
          //       ),
          //       decoration: BoxDecoration(
          //         color: Colors.blue.shade100,
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       child: Text(
          //         orderDetails["status"],
          //         style: const TextStyle(
          //           color: Colors.blue,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(width: size.width * 0.04),

          /// RIGHT COLUMN (Details + Price + Icon)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Details",
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 Text(
                  "Status: ${orderDetails["status"]}",
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Order id: ${orderDetails["order_txn"]}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.005),

                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: size.width * 0.04,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        orderDetails["landmark"] ?? orderDetails["location"],
                        style: TextStyle(fontSize: size.width * 0.035),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.005),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: size.width * 0.04,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 4),
                    Text(
                      orderDetails["updated_at"],
                      style: TextStyle(fontSize: size.width * 0.035),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.005),

                // Text(
                //   "Order id: ${orderData["orderId"]}",
                //   style: TextStyle(fontSize: size.width * 0.035, color: Colors.black87),
                // ),
                SizedBox(height: size.height * 0.01),

                /// PRICE & NAVIGATION ICON ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${orderDetails["sub_total"]}",
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.navigation,
                      color: Colors.orange,
                      size: 28,
                    ),
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
        Text(
          "Enter Order Code",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.045,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _orderCodeController,
                decoration: InputDecoration(
                  hintText: "Enter code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            ElevatedButton(
              onPressed: _isVerified
                  ? null
                  : () {
                      callVerifyAPI(_orderCodeController.text);
                      print("Order Code: ${_orderCodeController.text}");
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
          Text(
            "Customer Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.045,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            "Name: ${orderDetails["name"]}",
            style: TextStyle(fontSize: size.width * 0.04),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Phone Number: ${orderDetails["phone_number"]}",
                style: TextStyle(fontSize: size.width * 0.04),
              ),
              const Icon(Icons.call, color: Colors.green, size: 20.0),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Email: ${orderDetails["email"]}",
                style: TextStyle(fontSize: size.width * 0.04),
              ),
              const Icon(Icons.email, color: Colors.green, size: 20.0),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.message, color: Colors.grey),
            label: const Text("Send message"),
          ),

          SizedBox(height: size.height * 0.01),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _orderCodeController,
                  decoration: InputDecoration(
                    hintText: "Enter code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              ElevatedButton(
                onPressed: _isVerified
                    ? null
                    : () {
                        callVerifyAPI(_orderCodeController.text);
                      print("Order Code: ${_orderCodeController.text}");
                     
                      },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
      ),
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

double sum = 0;
    for (var i=0; i<servicesData.length; i++) {
       sum = sum +  double.parse(servicesData[i]["discount"])?? 0.0;
}

  
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
          // Each service price
          Column(
            children: servicesData.map((service) {
              double price = double.parse(service["price"])+ double.parse(service["discount"])?? 0.0;
              return _priceRow(
                service["service_name"],
                price,
              );
            }).toList(),
          ),

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
           
         _priceRow(
                 'Discount',
                 sum,
                ),
          // _priceRow("Traveling Charge", _parseDouble(orderData["travelingCharge"])),
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
                const Text(
                  "Payment via",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _paymentOption(0, "Payment via PhonePe"),
                _paymentOption(1, "By hand cash"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String title,
    double? amount, {
    bool isBold = false,
    bool isAdd = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            double amount = double.parse(amountController.text);
                            String description = descController.text;

                            // Add the extra charge
                            setState(() {
                              _extraCharges.add({
                                'amount': amount,
                                'description': description,
                              });
                              _extraServiceTotal += amount;
                            });

                            print(
                              "Extra Charge Added: ₹$amount, Desc: $description",
                            );
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // Remove backgroundColor and use foregroundColor for text color
          foregroundColor: Colors.white,
          // Set transparent background to allow the gradient to show
          backgroundColor: Colors.transparent,
          // Remove shadow
          elevation: 0,
        ),
        onPressed: () {
          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text("Details Submitted")));
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

  ///services
  Widget _buildServiceTabs(Size size) {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: servicesData.length,
        separatorBuilder: (_, __) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          bool isSelected = selectedServiceIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedServiceIndex = index;
                serviceData = servicesData[index];
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                servicesData[index]["service_name"],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- SELECTED SERVICE CARD ----------------
  Widget _buildSelectedServiceCard(Size size) {
    final service = servicesData[selectedServiceIndex];

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 5,
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              "https://admin.gobuddyindia.com/assets/images/" +
                  service["service_image"],
              errorBuilder: (context, error, stackTrace) {
                // Returns this widget if the image fails to load
                return const Icon(Icons.broken_image, size: 50);
              },
              width: size.width * 0.22,
              height: size.width * 0.22,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service["service_name"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.043,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "location",
                  maxLines: 2,
                  style: TextStyle(fontSize: size.width * 0.035),
                ),

                SizedBox(height: 8),

                Text(
                  "₹${service['price']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.045,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadImageTitle(Size size) {
    return Text(
      "Upload Service Images",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: size.width * 0.045,
      ),
    );
  }

  // ---------------- UPLOAD BOXES ----------------
  Widget _imageUploadSection(Size size) {
    final currentService = servicesData[selectedServiceIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Before Service", style: TextStyle(fontSize: size.width * 0.04)),
        SizedBox(height: 8),

        _serviceImageGrid(currentService["beforeImages"], true),

        SizedBox(height: 15),

        Text("After Service", style: TextStyle(fontSize: size.width * 0.04)),
        SizedBox(height: 8),

        _serviceImageGrid(currentService["afterImages"], false),
      ],
    );
  }

  Widget _serviceImageGrid(List images, bool isBefore) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var img in images)
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: FileImage(img), fit: BoxFit.cover),
            ),
          ),

        GestureDetector(
          onTap: () => pickServiceImage(isBefore),
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Icon(Icons.add, size: 35, color: Colors.green),
          ),
        ),
      ],
    );
  }

  // ---------------- ACTION BUTTONS ----------------
  Widget _buildActionButtons(Size size) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              _showCancelDialog(context);
            },
            child: const Text(
              "Cancel Service",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        SizedBox(width: 12),
        // Expanded(
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        //     onPressed: () {},
        //     child: const Text("Service Completed"),
        //   ),
        // ),
      ],
    );
  }


  void _showCancelReasonSheet(
    BuildContext context,
    GetCancelOrderReasons? getCancelReasons,
  ) {


    
    if (getCancelReasons == null || getCancelReasons.cancelReasons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cancel reasons not available")),
      );
      return;
    }

    int? _selectedReason;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: width * 0.06,
                right: width * 0.06,
                top: height * 0.02,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  Text(
                    "Why do you want to cancel order?",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    "Please provide the reason",
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.black54,
                    ),
                  ),
                  Divider(),

                  ...getCancelReasons.cancelReasons.map((reason) {
                    return ListTile(
                      dense: true,
                      title: Text(reason.reason),
                      trailing: Radio<int>(
                        value: int.parse(reason.id),
                        groupValue: _selectedReason,
                        activeColor: Colors.orange,
                        onChanged: (val) {
                          setSheetState(() {
                            _selectedReason = val;
                          });
                        },
                      ),
                    );
                  }),

                  SizedBox(height: height * 0.02),

                  ElevatedButton(
                    onPressed: _selectedReason == null
                        ? null
                        : () {
                            Navigator.pop(context);

                            int lastId = int.parse(
                              getCancelReasons.cancelReasons.last.id,
                            );

                            if (_selectedReason == lastId) {
                              _showCustomCancelReasonPopup(
                                context,
                                _selectedReason!,
                              );
                            } else {
                              final selectedText = getCancelReasons
                                  .cancelReasons
                                  .firstWhere(
                                    (r) => int.parse(r.id) == _selectedReason,
                                  )
                                  .reason;

                              _ConfirmCancellation(
                                _selectedReason!,
                                selectedText,
                                "123",
                              );
                            }
                          },
                    child: Text("Cancel Plan"),
                  ),

                  SizedBox(height: height * 0.03),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCustomCancelReasonPopup(
    BuildContext context,
    int selectedReasonId,
  ) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Please write reason",
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height * 0.02),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: reasonController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Write here",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.03),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final text = reasonController.text.trim();

                      if (text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a reason"),
                          ),
                        );
                        return;
                      }

                      Navigator.pop(context);

                      _ConfirmCancellation(
                        selectedReasonId,
                        text,
                        "",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text("Cancel"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 
void _ConfirmCancellation(
      int reasonId, String reasonText, String jobCalendarId) async {
    try {
      debugPrint("📌 Cancel API Called:");
      debugPrint("Reason ID: $reasonId");
      debugPrint("Reason: $reasonText");
      debugPrint("Job Calendar ID: $jobCalendarId");

      // TODO: Replace with real API
      await Future.delayed(const Duration(seconds: 1));
      _showCancelRequestPopup(context);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Order Cancelled Successfully")),
      // );
    } catch (e) {
      debugPrint("Cancel API Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to cancel order")));
    }
  }
  //cancel order
  

 
  //services end
}
