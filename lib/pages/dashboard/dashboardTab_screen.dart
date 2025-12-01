import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gobuddy/data/preferences.dart';
import 'package:gobuddy/services/end_points.dart';
import 'package:gobuddy/services/repository.dart';
import 'package:gobuddy/utils/util_class.dart';
import '../../utils/config.dart';
import '../../utils/my_colors.dart';



class DashboardTabScreen extends StatefulWidget {
  const DashboardTabScreen({super.key});

  @override
  State<DashboardTabScreen> createState() => _DashboardTabScreenState();
}

class _DashboardTabScreenState extends State<DashboardTabScreen> {

 int currentIndex = 0;
  dynamic profileDetails = {};
  Color green = Color(0xFF4CAF50);
  dynamic userData = {};
  //sk 
  // Assume the data is flattened for easier calculation
  late List<Map<String, dynamic>> _allEarningsData;
  late int
  _currentIndex; // Index of the month currently displayed in the calendar header
  /////

  // Placeholder for a global color variable, assuming 'green' is defined elsewhere.
  //static const Color green = Color(0xFF388E3C);
  static const Color orange = Color(0xFFFF8C00);
  static const Color lightGreenBackground = Color(0xFFC8E6C9);
  // Using viewportFraction to show part of the next slide, matching the slider look
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;
  // Using colors found in the image

  static const Color lightBlue = Color(0xFFBBDEFB); // Light blue for inactive dots
  static const Color offerGreenBackground = Color(0xFFC4E047); // Specific green from image
  static const Color textOrange = Color(0xFFFF913C); // Orange for '20% OFF' and fire icon
  static const Color offerBgColor = Color(0xFFC4E047); // The lime green background color

  // JSON Data Structure for Dynamic Screen
  Map<String, dynamic> dashboardData = {
    "isVerified": false, // false for PENDING, true for Verified
    "rating": 3.0,
    "totalEarnings": "75,000",
    "gbCoins": "125",
    "jobsGoal": "120",
    "location": "35/08-PM Palem, Madhurawada, Visakhapatnam...",
    "profileImageUrl": 'assets/images/user.jpg',

    "statusCards": [
      {
        "title": "Current Month",
        "amount": "12,000",
        "count": "5",
        "color": 0xFFFF7DA7,
        "icon": "calendar_today",
      },
      {
        "title": "Pending Orders",
        "amount": "38,000",
        "count": "15",
        "color": 0xFF62D5F8,
        "icon": "assignment_outlined",
      },
      {
        "title": "Today Orders",
        "amount": "5,000",
        "count": "2",
        "color": 0xFF58C75E,
        "icon": "today_outlined",
      },
      {
        "title": "Missed Orders",
        "amount": "15,000",
        "count": "3",
        "color": 0xFFFF913C,
        "icon": "inventory_outlined",
      },
    ],

    // UPDATED STRUCTURE: List of Subscription Categories
    "currentSubscriptions": [
      {
        "category": "AC Technician",
        "plans": [
          {
            "type": "Split AC",
            "totalJobs": 60,
            "usedJobs": 35,
            "missedJobs": 5,
            "price": 999,
          },
          {
            "type": "Cassette AC",
            "totalJobs": 60,
            "usedJobs": 35,
            "missedJobs": 5,
            "price": 999,
          },
        ],
      },
      {
        "category": "Plumbing Service",
        "plans": [
          {
            "type": "General Repair",
            "totalJobs": 40,
            "usedJobs": 10,
            "missedJobs": 2,
            "price": 750,
          },
          {
            "type": "Fixture Installation",
            "totalJobs": 20,
            "usedJobs": 5,
            "missedJobs": 0,
            "price": 850,
          },
        ],
      },
    ],

    "statistics": {
      "currentMonth": "May", // Default selected month
      "currentYear": 2025,
      "earnings": [
        {"month": "Dec", "year": 2024, "earning": 48000},
        {"month": "Jan", "year": 2025, "earning": 45000},
        {"month": "Feb", "year": 2025, "earning": 38000},
        {"month": "Mar", "year": 2025, "earning": 12000},
        {"month": "Apr", "year": 2025, "earning": 43000},
        {"month": "May", "year": 2025, "earning": 63000},
        {"month": "Jun", "year": 2025, "earning": 56000},
        {"month": "Jul", "year": 2025, "earning": 75000},
        {"month": "Aug", "year": 2025, "earning": 68000},
        {"month": "Sep", "year": 2025, "earning": 52000},
        {"month": "Oct", "year": 2025, "earning": 59000},
        {"month": "Nov", "year": 2025, "earning": 61000},
      ],
    },

    "offers": [
      {
        "text": "20% OFF",
        "subText": "On Plumbing Service Pack",
        "buttonText": "Create",
         "offerImage":"assets/images/home_cleaning.png",
        // NOTE: Removed imageAsset as we'll use a fixed background image for all
        "backgroundColor": 0xFFC4E047,
      },
      // Adding more offers to show the scrolling
      {
        "text": "30% OFF",
        "subText": "On AC Service Combo",
        "buttonText": "Book Now",
        "offerImage":"assets/images/hair_cut.png",
        "backgroundColor": 0xFF62D5F8, // Example: Blue for next offer
      },
      {
        "text": "FREE",
        "subText": "Water Tank Cleaning",
        "buttonText": "Claim",
        "offerImage":"assets/images/home_cleaning.png",
        "backgroundColor": 0xFFFF7DA7, // Example: Pink for third offer
      },
    ]
  };




 
 void initState() {
    super.initState();

    var userDataValue = Preferences.getUserDetails();
    if (userDataValue != null) {
      userData = json.decode(userDataValue);
    }

    callgetProfileAPI();
    //sk
     _allEarningsData = dashboardData["statistics"]["earnings"]
        .cast<Map<String, dynamic>>();

    // Set initial index to the 'currentMonth' from JSON (e.g., 'May')
    String initialMonth = dashboardData["statistics"]["currentMonth"];
    _currentIndex = _allEarningsData.indexWhere(
      (data) => data["month"] == initialMonth,
    );

    // Fallback in case currentMonth is not found
    if (_currentIndex == -1) {
      _currentIndex = _allEarningsData.length > 0
          ? _allEarningsData.length - 1
          : 0;
    }
    //sliders
    _currentPage = 0;
    _startAutoScroll();

    _pageController.addListener(() {
      int? next = _pageController.page?.round();
      if (next != null && _currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

   @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
void _startAutoScroll() {
    final offers = dashboardData["offers"] as List<dynamic>;
    if (offers.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % offers.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }
    void _changeMonth(int direction) {
    setState(() {
      int newIndex = _currentIndex + direction;
      if (newIndex >= 0 && newIndex < _allEarningsData.length) {
        _currentIndex = newIndex;
      }
    });
  }
    // Slice the data to show only 5 months centered around the selected month
  List<Map<String, dynamic>> _getVisibleData() {
    int centerIndex = _currentIndex;
    int startIndex = max(0, centerIndex - 2);
    int endIndex = min(_allEarningsData.length, startIndex + 5);

    // Adjust start index if we hit the end bound
    if (endIndex - startIndex < 5) {
      startIndex = max(0, endIndex - 5);
    }

    return _allEarningsData.sublist(startIndex, endIndex);
  }

  void callgetProfileAPI() async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      // ignore: use_build_context_synchronously
      UtilClass.showProgress(context: context);
      await Repository.postApiService(EndPoints.profile, {
        "user_id": userData["user_id"] ?? "4361",
      }).then((value) async {
        UtilClass.hideProgress();
        dynamic parsed = {};
        try {
          parsed = await json.decode(value);
          if (parsed["status"] == "valid") {
            profileDetails = parsed["profile"];

            setState(() {
              profileDetails = parsed["profile"];
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
        print(parsed["message"]);
      });
    } else {
      // ignore: use_build_context_synchronously
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }
  @override
  Widget build(BuildContext context) {
   final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isVerified = dashboardData["isVerified"] as bool;

    // The logic is now passed the selected month/year data
    final selectedMonthData = _allEarningsData[_currentIndex];
    final selectedMonthName = selectedMonthData["month"];
    final selectedYear = selectedMonthData["year"];

 
 

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header Container with Gradient and Profile Info
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: screenHeight * 0.02,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF38B03F), const Color(0xFFC7BB47)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isVerified)
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Red dot container outside
                          Container(
                            width: screenWidth * 0.04,
                            height: screenWidth * 0.04,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          // PENDING text container
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "PENDING",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.028,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  //add pending status
                  // Profile Row with Notification Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: screenWidth * 0.075,
                                backgroundImage: AssetImage(
                                  dashboardData["profileImageUrl"],
                                ),
                              ),
                              // Green Tick for Verified Provider (Below Profile Image)
                              if (isVerified)
                                Positioned(
                                  bottom: -2,
                                  left: 0,
                                  right: -21,
                                  child: Center(
                                    child: Container(
                                      // decoration: BoxDecoration(
                                      //   color: Colors.white,
                                      //   shape: BoxShape.circle,
                                      // ),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: green,
                                        size: screenWidth * 0.05,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileDetails["name"] ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.048,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "AC Technician / Electrician",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: screenWidth * 0.035,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines:
                                    2, // Allow up to 2 lines before ellipsis
                                softWrap: true,
                              ),
                              // Provider Rating (Only if Verified)
                              if (isVerified)
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (index) => Icon(
                                        index <
                                                (dashboardData["rating"] ?? 0)
                                                    .toInt()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.yellow,
                                        size: screenWidth * 0.035,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${dashboardData["rating"] ?? 0}/5",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                      // Notification Icon and PENDING Tag
                      Row(
                        children: [


                          // Notification Icon
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.notifications,
                                color: green,
                                size: screenWidth * 0.09,
                              ),
                              padding: EdgeInsets.all(8),
                              constraints: BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Total Earnings Card
                  _buildTotalEarningsCard(screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  // Location Row
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Expanded(
                        child: Text(
                          dashboardData["location"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  // Job Calendar and QR Code Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.calendar_month  ,
                          label: "My job calendar",
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.qr_code,
                          label: "Show my QR code",
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Status Cards Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.04,
                  mainAxisSpacing: screenHeight * 0.02,
                  childAspectRatio: 1.5,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dashboardData["statusCards"].length,
                itemBuilder: (context, index) {
                  var card = dashboardData["statusCards"][index];
                  return _buildStatusCard(card, screenWidth);
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Current Subscriptions Section
            _buildCurrentSubscriptionsSection(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),

            // Statistics Graph
            _buildStatisticsGraph(
              screenWidth,
              screenHeight,
              _getVisibleData(),
              selectedMonthName,
              selectedYear,
              _changeMonth,
              _currentIndex > 0, // canMoveBack
              _currentIndex < _allEarningsData.length - 1, // canMoveForward
            ),
            SizedBox(height: screenHeight * 0.03),

            // Offers Card Section
           // _buildOffersSection(screenWidth, screenHeight),
           // SizedBox(height: screenHeight * 0.02),
            _buildOffersCarousel(screenWidth, screenHeight),
            SizedBox(height:screenHeight * 0.015),
            _buildPaginationDots(),
           SizedBox(height:screenHeight * 0.015),
          ],
        ),
      ),
    ),
    );
  }



  
  Widget statusCard(String amount, String title, Color color) {
    return Container(
      height: 90, // Add this line for height
      width: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            amount,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTotalEarningsCard(double screenWidth) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            // Left side Image
            Image.asset(
              "assets/images/coins.png",
              height: screenWidth * 0.18,
              width: screenWidth * 0.18,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: screenWidth * 0.18,
                  width: screenWidth * 0.18,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.monetization_on,
                    color: Colors.orange,
                    size: screenWidth * 0.1,
                  ),
                );
              },
            ),
            SizedBox(width: screenWidth * 0.04),

            // Right side container
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GB Coins row
                  Row(
                    children: [
                      const Text(
                        "GB Coins",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/gobuddyIcon.png",
                              width: 18,
                              height: 18,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.monetization_on,
                                  color: Colors.orange,
                                  size: 16,
                                );
                              },
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                "${dashboardData["gbCoins"]}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price
                  RichText(
                    text: TextSpan(

                      children: <TextSpan>[
                        const TextSpan(
                          text: "₹ ",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: dashboardData["totalEarnings"],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: " /${dashboardData["jobsGoal"]}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Button
                  SizedBox(
                    height: screenWidth * 0.08,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Total Earnings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 38,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: Colors.black),
        label: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.transparent, // Remove green tint
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _getImageFromString(String imageName, double size) {
    switch (imageName) {
      case "Current Month":
        return Image.asset(
          "assets/images/current_month.png",
          width: size,
          height: size,
          // Removed color property to keep original image colors
        );
      case "Pending Orders":
        return Image.asset(
          "assets/images/pending_orders.png",
          width: size,
          height: size,
        );
      case "Today Orders":
        return Image.asset(
          "assets/images/today_orders.png",
          width: size,
          height: size,
        );
      case "Missed Orders":
        return Image.asset(
          "assets/images/missed_orders.png",
          width: size,
          height: size,
        );
      default:
        return Image.asset(
          "assets/images/orders.png",
          width: size,
          height: size,
        );
    }
  }

  Widget _buildStatusCard(Map<String, dynamic> card, double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(card["color"] as int),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹${card["amount"]}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "(${card["count"]})",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _getImageFromString(card["title"] as String, screenWidth * 0.12),

            ],
          ),
          Text(
            card["title"] as String,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.036,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for a single subscription plan tile
  Widget _buildSubscriptionPlanTile(
    Map<String, dynamic> plan,
    double screenWidth,
    double screenHeight,
  ) {
    final remainingJobs =
        plan["totalJobs"] - plan["usedJobs"] - plan["missedJobs"];

    // Custom widget for stats (Used, Missed, Remaining)
    Widget buildStatColumn(
      String label,
      String value, {
      bool isRemaining = false,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: isRemaining ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Plan Name, Active Tag, Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plan["type"] as String,
                    style: TextStyle(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // Active Tag (Light Green background, Dark Green text)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: lightGreenBackground, // Light Green color
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Active',
                          style: TextStyle(
                            color: green, // Dark Green text color
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      // Price
                      Text(
                        '₹ ${plan["price"]}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.005),

              // Row 2: Total Jobs Info
              Text(
                '${plan["totalJobs"]} Jobs',
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              // Row 3: Used, Missed, Remaining Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Used Jobs
                  buildStatColumn('Used', '${plan["usedJobs"]}'),
                  // Missed Jobs
                  buildStatColumn('Missed', '${plan["missedJobs"]}'),
                  // Remaining Jobs - Label and Value on separate lines
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Remaining:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${remainingJobs} Jobs',
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Divider for separation between plans
        if (plan !=
            (dashboardData["currentSubscriptions"] as List<dynamic>)
                .first["plans"]
                .last)
          const Divider(height: 1, thickness: 0.5, indent: 15, endIndent: 15),
      ],
    );
  }

  // Main function to build the subscriptions section
  Widget _buildCurrentSubscriptionsSection(
    double screenWidth,
    double screenHeight,
  ) {
    final subscriptions =
        dashboardData["currentSubscriptions"] as List<dynamic>;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Current Subscriptions and See All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current Subscriptions",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "See All",
                  style: TextStyle(
                    color: green,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),

          if (subscriptions.isEmpty)
            // Existing logic for No Active Subscription Card (untouched)
            // ... (No Active Subscription Card)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "No Active Subscription",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Please create your package",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: green,
                          side: BorderSide(color: green, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Create Package",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.038,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            // Reworked Active Subscriptions List to handle categories
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subscriptions.length, // Number of Categories
              itemBuilder: (context, index) {
                final category = subscriptions[index];
                final plans = category["plans"] as List<dynamic>;

                return Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation:
                        5, // Added elevation for the "lifted" card effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Orange Header: AC Technician
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.orange, // Orange color
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              category["category"] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // List of Plans
                        ...plans.map((plan) {
                          return _buildSubscriptionPlanTile(
                            plan,
                            screenWidth,
                            screenHeight,
                          );
                        }).toList(),

                        // 'View more' button at the bottom of the card
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight * 0.01,
                            bottom: screenHeight * 0.02,
                          ),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                            ),
                            child: Text(
                              'View more',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: screenWidth * 0.038,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }



  Widget _buildStatisticsGraph(
    double screenWidth,
    double screenHeight,
    List<Map<String, dynamic>> visibleEarningsData,
    String selectedMonthName,
    int selectedYear,
    Function(int) changeMonth,
    bool canMoveBack,
    bool canMoveForward,
  ) {
    const double maxScale = 100000.0; // Fixed max scale for Y-axis
    final graphHeight =
        screenHeight * 0.3; // Increased graph height for better visibility

    // Adjusted Y-axis labels and steps to match the image
    List<String> yLabels = [
      "₹ 0k",
      "₹ 10k",
      "₹ 20k",
      "₹ 30k",
      "₹ 40k",
      "₹ 50k",
      "₹ 60k",
      "₹ 70k",
      "₹ 80k",
      "₹ 90k",
      "₹ 100k",
    ];
    final yStep = maxScale / (yLabels.length - 1); // 10k per step

    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Statistics",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.045,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          // Custom Calendar Header
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.008,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9), // Light Green background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: canMoveBack ? () => changeMonth(-1) : null,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: canMoveBack ? Colors.black : Colors.grey,
                      size: screenWidth * 0.045,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "$selectedMonthName, $selectedYear",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: canMoveForward ? () => changeMonth(1) : null,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: canMoveForward ? Colors.black : Colors.grey,
                      size: screenWidth * 0.045,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          // Graph Area
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Y-Axis Labels
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: yLabels.reversed
                    .map(
                      (label) => SizedBox(
                        height: (graphHeight / (yLabels.length - 1)),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            // Padding to separate from grid
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: screenWidth * 0.025,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(width: screenWidth * 0.005), // Reduced space
              // Main Graph Area
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    height: graphHeight + screenHeight * 0.06,
                    // Extra space for labels and dot
                    width: max(
                      screenWidth * 0.85,
                      visibleEarningsData.length * screenWidth * 0.15,
                    ),
                    child: Stack(
                      children: [
                        // Horizontal Grid Lines
                        ...List.generate(yLabels.length, (index) {
                          final segmentHeight =
                              graphHeight / (yLabels.length - 1);
                          // The lines start from 0k (bottom) up to 100k (top)
                          final topPosition = index * segmentHeight;

                          return Positioned(
                            top: graphHeight - topPosition,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: index == 0
                                  ? Colors.black26
                                  : Colors.grey.shade200, // Blacker line for 0k
                            ),
                          );
                        }),

                        // Vertical Bars and Labels
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: visibleEarningsData.map((data) {
                              final earning = data["earning"].toDouble();
                              final month = data["month"];
                              final barHeight =
                                  (earning / maxScale) * graphHeight;
                              final isSelectedMonth =
                                  month == selectedMonthName;

                              return SizedBox(
                                width: screenWidth * 0.12,
                                // Fixed width for each bar column
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Earning Value Label (e.g., ₹63.000)
                                    if (earning > 0)
                                      Text(
                                        "₹${(earning / 1000).toStringAsFixed(3)}", // Format: ₹X.XXX
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    SizedBox(height: 4),
                                    // Bar
                                    Container(
                                      width: screenWidth * 0.08,
                                      height: max(barHeight, 0),
                                      decoration: BoxDecoration(
                                        color: green,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(3),
                                          topRight: Radius.circular(3),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Month Label
                                    Text(
                                      month,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: isSelectedMonth
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                    // Orange Dot for Selected Month
                                    SizedBox(height: 4),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: isSelectedMonth
                                            ? orange
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection(double screenWidth, double screenHeight) {
    final offers = dashboardData["offers"] as List<dynamic>;

    return SizedBox(
      height: screenHeight * 0.16,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.04,
              right: index == offers.length - 1 ? screenWidth * 0.04 : 0,
            ),
            child: Container(
              width: screenWidth * 0.85,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.015,
              ),
              decoration: BoxDecoration(
                color: Color(offer["backgroundColor"] as int),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                offer["text"],
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: screenWidth * 0.055,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.red,
                              size: 18,
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          offer["subText"],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Let's Create your package",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: screenWidth * 0.028,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        SizedBox(
                          height: 28,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              offer["buttonText"],
                              style: TextStyle(
                                fontSize: screenWidth * 0.032,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  // Offer Image
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      offer["imageAsset"],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                            size: screenWidth * 0.12,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Core Logic: Offer Carousel with Image Background ---
  // --- Core Logic: Offer Carousel with Dynamic Image ---
// --- Core Logic: Offer Carousel with Dynamic Image and 40% Width ---
  // --- Core Logic: Offer Carousel with Dynamic Image and 80% Height ---
  Widget _buildOffersCarousel(double screenWidth, double screenHeight) {
    final offers = dashboardData["offers"] as List<dynamic>;

    if (offers.isEmpty) {
      return SizedBox(
        height: screenHeight * 0.18,
        child: Center(
          child: Text(
            "No offers available at the moment.",
            style: TextStyle(fontSize: screenWidth * 0.04),
          ),
        ),
      );
    }

    return SizedBox(
      height: screenHeight * 0.18, // Card Height
      child: PageView.builder(
        controller: _pageController,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          final String imagePath = offer["offerImage"] ?? 'assets/images/default_offer.png'; // Get dynamic path

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.015,
              ),
              decoration: BoxDecoration(
                // Use background color from JSON
                color: Color(offer["backgroundColor"] as int),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // --- Offer Text and Button (Left Side - 60% Width) ---
                  Expanded(
                    flex: 3, // 60%
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                offer["text"],
                                style: TextStyle(
                                    color: textOrange,
                                    fontSize: screenWidth * 0.055,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Flame icon (Orange)
                            const Icon(Icons.local_fire_department,
                                color: textOrange, size: 18),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          offer["subText"],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          "Let's Create your package",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: screenWidth * 0.028),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        SizedBox(
                          height: screenHeight * 0.04,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: textOrange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              elevation: 0,
                            ),
                            child: Text(
                              offer["buttonText"],
                              style: TextStyle(
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),

                  // --- Image/Background (Right Side - 40% Width, 80% Height) ---
                  Expanded(
                    flex: 2, // 40%
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.bottomRight,
                      child: FractionallySizedBox(
                        heightFactor: 0.99, // Set image height to 80% of the available vertical space
                        child: Image.asset(
                          imagePath, // Dynamic image path from JSON
                          fit: BoxFit.fitHeight,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.error, color: Colors.white, size: screenWidth * 0.12),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Pagination Dots (Untouched from previous change) ---
  Widget _buildPaginationDots() {
    final offers = dashboardData["offers"] as List<dynamic>;
    if (offers.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        offers.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 6.0,
          width: _currentPage == index ? 20.0 : 6.0,
          decoration: BoxDecoration(
            color: _currentPage == index ? green : lightBlue,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

 
}