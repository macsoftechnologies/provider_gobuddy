import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gobuddy/data/preferences.dart';
import 'package:gobuddy/services/end_points.dart';
import 'package:gobuddy/services/repository.dart';
import 'package:gobuddy/utils/util_class.dart';
import '../../utils/config.dart';
import '../../utils/my_colors.dart';



class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String selectedTab = "Pending";

  // Sample JSON Data
  final String jsonData = '''
  {
    "orders": [
      {
        "id": 1,
        "title": "AC Installation",
        "service": "AC Service",
        "address": "Sheela Nagar, Gajuwaka, Visakhapatnam",
        "date": "10/8/2024",
        "time": "12:00 AM",
        "price": 599,
        "status": "Pending",
        "image": "assets/images/ACInstallation.jpg"
      },
      {
        "id": 2,
        "title": "Wash basin installation",
        "service": "Plumbing service",
        "address": "Sheela Nagar, Gajuwaka, Visakhapatnam",
        "date": "10/8/2024",
        "time": "12:00 AM",
        "price": 399,
        "status": "Open",
        "expiry": 3600,
        "image": "assets/images/washBasin.png"
      },
      {
        "id": 3,
        "title": "Cassette AC repair",
        "service": "AC Service",
        "address": "1-45-24, Simhachalam, Visakhapatnam",
        "date": "11/8/2024",
        "time": "10:30 AM",
        "price": 399,
        "status": "Open",
        "expiry": -90,
        "image": "assets/images/ACInstallation.jpg"
      },
      {
        "id": 4,
        "title": "Jet servicing split AC",
        "service": "AC Service",
        "address": "25-45-76, Shankaramatam, Visakhapatnam",
        "date": "11/8/2024",
        "time": "04:00 PM",
        "price": 599,
        "status": "Completed",
        "image": "assets/images/ACInstallation.jpg"
      },
      {
        "id": 5,
        "title": "Pipe Leakage Fix",
        "service": "Plumbing service",
        "address": "MVP Colony, Visakhapatnam",
        "date": "12/8/2024",
        "time": "02:00 PM",
        "price": 250,
        "status": "Cancelled",
        "image": "assets/images/washBasin.png"
      }
    ]
  }
  ''';

  List<dynamic> allOrders = [];
  Map<int, int> countdowns = {}; // orderId -> seconds remaining
  Timer? timer;

   dynamic userData = {};
 
   List<dynamic> orders = [];
   dynamic selectType = "pending";

  @override
  void initState() {
    super.initState();

 var userDataValue = Preferences.getUserDetails();
    if (userDataValue != null) {
      userData = json.decode(userDataValue);
    }
callOrdersPI(selectType);



    final data = jsonDecode(jsonData);
    allOrders = data["orders"];

    // Initialize countdown timers
    for (var order in allOrders) {
      if (order["status"] == "Open" && order["expiry"] != null) {
        countdowns[order["id"]] = order["expiry"];
      }
    }

    // Start countdown timer
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      bool updated = false;
      countdowns.forEach((id, seconds) {
        if (seconds > 0) {
          countdowns[id] = seconds - 1;
          updated = true;
        }
      });
      if (updated) setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  void callOrdersPI(tab) async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.getOrders, {
            "user_id": "4434" ?? "4361",
             "status": tab.toLowerCase() ?? "pending",
          }).then((value) async {
        UtilClass.hideProgress();
         
        dynamic parsed = await json.decode(value);
        try {
        
          if (parsed["status"] == "valid") {
          
            setState(() {

              selectType = tab.toLowerCase();
              orders = parsed["data"];
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

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    List<dynamic> filteredOrders =
    allOrders.where((order) => order["status"] == selectedTab).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(deviceWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushNamed(
                        // ignore: use_build_context_synchronously
                        context,
                        Config.dashboardcRouteName,

                      )
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: deviceWidth * 0.04),
                  const Text(
                    "My orders",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: deviceHeight * 0.02),

              // Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ["Pending", "Open", "Completed", "Cancelled"]
                    .map((tab) {
                  final isSelected = selectedTab == tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          
                           setState(() {
            
               selectedTab = tab;
            });
            callOrdersPI(tab);
                         
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.white,
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          tab,
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,fontSize: 11
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: deviceHeight * 0.02),

              // Orders List
              Expanded(
                child: orders.isEmpty
                    ? const Center(
                  child: Text(
                    "No orders found",
                    style:
                    TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(order, deviceWidth);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(dynamic order, double deviceWidth) {
    final status = order["status"];

    return
      GestureDetector(
        onTap: (){
          Navigator.of(context).pushReplacementNamed(
          
             arguments: order,
            Config.orderDetailsRouteName, //loginRouteName dashboardcRouteName
          );

        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(8),
                  //   child: Image.asset(
                  //     order["image"],
                  //     width: deviceWidth * 0.25,
                  //     height: deviceWidth * 0.25,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  SizedBox(width: deviceWidth * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Number :  ${order["id"]}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(  "Services",
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.black54),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(order["landmark"],
                                  style: const TextStyle(fontSize: 13),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text("${order["updated_at"]}",
                                style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(),

              // Bottom UI depends on Status
              if (selectType == "pending") _buildPendingUI(order),
              if (selectType == "open") _buildOpenUI(order),
              if (selectType == "completed") _buildCompletedUI(order),
              if (selectType == "cancelled") _buildCancelledUI(order),
            ],
          ),
        ),
      );
  }

  /// UI for Pending Orders
  Widget _buildPendingUI(dynamic order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.lightBluebackgroundColor,
            foregroundColor: Colors.deepPurple,//Colors.purple.shade100
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {},
          child: const Text("Start"),
        ),
        Text("₹ ${order["total_amount"]}",
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// UI for Open Orders
  Widget _buildOpenUI(dynamic order) {
    int seconds = countdowns[order["id"]] ?? 0;
    bool expired = seconds <= 0;

    String timeLeft =
        "${(seconds ~/ 60).toString().padLeft(2, "0")}:${(seconds % 60).toString().padLeft(2, "0")}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black26),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {},
            child: const Text("Cancel"),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: expired ? Colors.grey : Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: expired ? null : () {},
            child: const Text("Accept"),
          ),
        ]),
        expired
            ? const Text("Expired",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
            : Row(
          children: [
            const Icon(Icons.timer, color: Colors.orange, size: 18),
            const SizedBox(width: 4),
            Text(timeLeft,
                style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 12),
            Text("₹ ${order["total_amount"]}",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  /// UI for Completed Orders
  Widget _buildCompletedUI(dynamic order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor : MyColors.lightGreen2,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {},
          child: const Text("Completed",style: TextStyle(color: Colors.green),),
        ),
        Text("₹ ${order["total_amount"]}",
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// UI for Cancelled Orders
  Widget _buildCancelledUI(dynamic order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor : Color(0xFFf79999),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {},
          child: const Text("Cancelled",style: TextStyle(color: Colors.red),),
        ),
        Text("₹ ${order["price"]}",
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}