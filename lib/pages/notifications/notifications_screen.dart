import 'package:flutter/material.dart';
import 'dart:convert';

// JSON Data Model
class NotificationItem {
  final String id;
  final String title;
  final String service;
  final String location;
  final String provider;
  final String date;
  final String time;
  final double price;
  final String status; // "YTA", "EXP", "CNCL", "ACPT"
  final String? countdown;
  final String timeAgo;

  NotificationItem({
    required this.id,
    required this.title,
    required this.service,
    required this.location,
    required this.provider,
    required this.date,
    required this.time,
    required this.price,
    required this.status,
    this.countdown,
    required this.timeAgo,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      service: json['service'],
      location: json['location'],
      provider: json['provider'],
      date: json['date'],
      time: json['time'],
      price: json['price'].toDouble(),
      status: json['status'],
      countdown: json['countdown'],
      timeAgo: json['timeAgo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'service': service,
      'location': location,
      'provider': provider,
      'date': date,
      'time': time,
      'price': price,
      'status': status,
      'countdown': countdown,
      'timeAgo': timeAgo,
    };
  }
}

// Complete JSON Data for all notification types
const String allNotificationsJson = '''
{
  "notifications": [
    {
      "id": "1",
      "title": "AC Installation",
      "service": "AC Service",
      "location": "Sheela Nagar, Gajuwaka, Visakhapatnam",
      "provider": "R. Siva Prasad Rao",
      "date": "10/8/2024",
      "time": "12:00 AM",
      "price": 599,
      "status": "YTA",
      "countdown": "59:15",
      "timeAgo": "Now"
    },
    {
      "id": "2",
      "title": "Plumbing Repair",
      "service": "Plumbing Service",
      "location": "MVP Colony, Visakhapatnam",
      "provider": "K. Ravi Kumar",
      "date": "10/8/2024",
      "time": "11:30 AM",
      "price": 750,
      "status": "YTA",
      "countdown": "45:30",
      "timeAgo": "15 min ago"
    },
    {
      "id": "3",
      "title": "Wash Basin Installation",
      "service": "Plumbing Service",
      "location": "Maddilapalem, Visakhpatnam",
      "provider": "T. Gnaneswari",
      "date": "10/8/2024",
      "time": "09:00 AM",
      "price": 499,
      "status": "CNCL",
      "timeAgo": "10:23 AM"
    },
    {
      "id": "4",
      "title": "Electrical Wiring",
      "service": "Electrical Service",
      "location": "Dwaraka Nagar, Visakhapatnam",
      "provider": "S. Venkat Rao",
      "date": "09/8/2024",
      "time": "02:00 PM",
      "price": 850,
      "status": "ACPT",
      "timeAgo": "Yesterday"
    },
    {
      "id": "5",
      "title": "Kitchen Sink Repair",
      "service": "Plumbing Service",
      "location": "Siripuram, Visakhapatnam",
      "provider": "M. Lakshmi",
      "date": "08/8/2024",
      "time": "10:00 AM",
      "price": 300,
      "status": "EXP",
      "timeAgo": "2 days ago"
    },
    {
      "id": "6",
      "title": "Fan Installation",
      "service": "Electrical Service",
      "location": "Rushikonda, Visakhapatnam",
      "provider": "P. Suresh",
      "date": "09/8/2024",
      "time": "04:30 PM",
      "price": 400,
      "status": "ACPT",
      "timeAgo": "Yesterday"
    },
    {
      "id": "7",
      "title": "Water Heater Service",
      "service": "Plumbing Service",
      "location": "Akkayyapalem, Visakhapatnam",
      "provider": "R. Krishna",
      "date": "07/8/2024",
      "time": "03:15 PM",
      "price": 650,
      "status": "EXP",
      "timeAgo": "3 days ago"
    },
    {
      "id": "8",
      "title": "Switch Board Repair",
      "service": "Electrical Service",
      "location": "Beach Road, Visakhapatnam",
      "provider": "N. Ramesh",
      "date": "10/8/2024",
      "time": "01:45 PM",
      "price": 200,
      "status": "CNCL",
      "timeAgo": "2 hours ago"
    }
  ]
}
''';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> allNotifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    try {
      print('Loading notifications...');
      final Map<String, dynamic> jsonData = json.decode(allNotificationsJson);
      final List<dynamic> notificationsList = jsonData['notifications'];
      print('Found ${notificationsList.length} notifications');

      setState(() {
        allNotifications = notificationsList
            .map((json) => NotificationItem.fromJson(json))
            .toList();
        _isLoading = false;
        print('Notifications loaded: ${allNotifications.length}');
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(deviceWidth * 0.02),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7CB342), Color(0xFF8BC34A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: deviceWidth * 0.05,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : allNotifications.isEmpty
          ? Center(
        child: Text(
          'No notifications available',
          style: TextStyle(
            fontSize: deviceWidth * 0.04,
            color: Colors.grey,
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(deviceWidth * 0.04),
        itemCount: allNotifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(
            allNotifications[index],
            deviceWidth,
            deviceHeight,
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
      NotificationItem notification, double deviceWidth, double deviceHeight) {
    return Container(
      margin: EdgeInsets.only(bottom: deviceHeight * 0.015),
      padding: EdgeInsets.all(deviceWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: deviceWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.005),
                    Text(
                      notification.service,
                      style: TextStyle(
                        fontSize: deviceWidth * 0.035,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                notification.timeAgo,
                style: TextStyle(
                  fontSize: deviceWidth * 0.035,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          SizedBox(height: deviceHeight * 0.015),

          // Location
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: deviceWidth * 0.04,
                color: Colors.grey[600],
              ),
              SizedBox(width: deviceWidth * 0.02),
              Expanded(
                child: Text(
                  notification.location,
                  style: TextStyle(
                    fontSize: deviceWidth * 0.035,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: deviceHeight * 0.01),

          // Provider and Date
          Row(
            children: [
              Icon(
                Icons.person,
                size: deviceWidth * 0.04,
                color: Colors.grey[600],
              ),
              SizedBox(width: deviceWidth * 0.02),
              Text(
                notification.provider,
                style: TextStyle(
                  fontSize: deviceWidth * 0.035,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.calendar_today,
                size: deviceWidth * 0.035,
                color: Colors.grey[600],
              ),
              SizedBox(width: deviceWidth * 0.01),
              Text(
                "${notification.date}  ${notification.time}",
                style: TextStyle(
                  fontSize: deviceWidth * 0.03,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          SizedBox(height: deviceHeight * 0.02),

          // Action buttons and price based on status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusSection(notification, deviceWidth, deviceHeight),
              _buildPriceSection(notification, deviceWidth, deviceHeight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(NotificationItem notification, double deviceWidth, double deviceHeight) {
    switch (notification.status) {
      case 'YTA': // Yet to Accept
        return Row(
          children: [
            _buildActionButton(
              "Cancel",
              Colors.grey[300]!,
              Colors.grey[700]!,
              deviceWidth,
                  () => _updateNotificationStatus(notification.id, "CNCL"),
            ),
            SizedBox(width: deviceWidth * 0.03),
            _buildActionButton(
              "Accept",
              const Color(0xFF4CAF50),
              Colors.white,
              deviceWidth,
                  () => _updateNotificationStatus(notification.id, "ACPT"),
            ),
          ],
        );

      case 'ACPT': // Accepted
        return _buildStatusBadge(
          "Accepted",
          const Color(0xFF4CAF50),
          deviceWidth,
        );

      case 'CNCL': // Cancelled
        return _buildStatusBadge(
          "Canceled",
          const Color(0xFFFF5252),
          deviceWidth,
        );

      case 'EXP': // Expired
        return _buildStatusBadge(
          "Expired",
          const Color(0xFFFF9800),
          deviceWidth,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPriceSection(NotificationItem notification, double deviceWidth, double deviceHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "₹ ${notification.price.toInt()}",
          style: TextStyle(
            fontSize: deviceWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (notification.countdown != null)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.02,
              vertical: deviceHeight * 0.002,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              notification.countdown!,
              style: TextStyle(
                fontSize: deviceWidth * 0.03,
                color: const Color(0xFFFF9800),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(String text, Color color, double deviceWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.03,
        vertical: deviceWidth * 0.015,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: deviceWidth * 0.03,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color backgroundColor, Color textColor,
      double deviceWidth, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.06,
          vertical: deviceWidth * 0.025,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: deviceWidth * 0.035,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _updateNotificationStatus(String id, String newStatus) {
    setState(() {
      final index = allNotifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final notification = allNotifications[index];
        allNotifications[index] = NotificationItem(
          id: notification.id,
          title: notification.title,
          service: notification.service,
          location: notification.location,
          provider: notification.provider,
          date: notification.date,
          time: notification.time,
          price: notification.price,
          status: newStatus,
          countdown: null, // Remove countdown when status changes
          timeAgo: notification.timeAgo,
        );
      }
    });

    // Show feedback to user
    String message = '';
    Color backgroundColor = Colors.grey;

    switch (newStatus) {
      case 'ACPT':
        message = 'Booking accepted';
        backgroundColor = const Color(0xFF4CAF50);
        break;
      case 'CNCL':
        message = 'Booking canceled';
        backgroundColor = const Color(0xFFFF5252);
        break;
      case 'EXP':
        message = 'Booking expired';
        backgroundColor = const Color(0xFFFF9800);
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: backgroundColor,
      ),
    );
  }
}