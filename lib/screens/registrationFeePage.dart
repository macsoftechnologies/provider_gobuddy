import 'package:flutter/material.dart';
import 'package:providerapp_gobuddy/screens/dashboardpage.dart';

class RegistrationFeePage extends StatefulWidget {
  @override
  _RegistrationFeePageState createState() => _RegistrationFeePageState();
}

class _RegistrationFeePageState extends State<RegistrationFeePage> {
  TextEditingController _referralCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A9D58), Color(0xFF05642A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(height: 10),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset("assets/onetimefee.png"), // Replace with your image
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "One Time Registration Fee",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "₹ 300",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Your one-time registration fee will cover detailed App training to manage jobs and view your financial growth, and other materials supply.\nFor any inquiries Contact: 9177746889",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),

                    Text(
                      "Enter referral code  ( Optional )",
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _referralCodeController,
                            decoration: InputDecoration(
                              hintText: "Enter code",
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // handle apply
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text("Apply"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom Center Arrow Button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: FloatingActionButton(
                    onPressed: () {
                      // proceed to next page
                     Navigator.push(context, MaterialPageRoute(builder: (_)=> RegistrationSuccessPage(),),);
                    },
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_forward, color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class RegistrationSuccessPage extends StatefulWidget {
  @override
  _RegistrationSuccessPageState createState() => _RegistrationSuccessPageState();
}

class _RegistrationSuccessPageState extends State<RegistrationSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       backgroundColor: Color(0xFFEBF3FA),
     ),
      body: SafeArea(
        child: Column(
          children: [

            Container(
              width:double.infinity,
              height: 200,
              color: Color(0xFFEBF3FA),
             child:  Image.asset(
                'assets/congrulations.png', // Replace with your actual asset
                height: 80,
              ),
            ),

            SizedBox(height: 10),
            Expanded(child: Container(


              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              margin: EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.green, Colors.teal],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'We will get back to you',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Thank you for Registering! We will contact you as early as possible after validation of your information. Meanwhile, if any questions please contact us at 9177746889.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(height: 16),
                  // Text(
                  //   "నమోదు చేసుకోవడానికి ధన్యవాదాలు!\nమీ సమాచారం ధృవీకరణం తర్వాత మేము వీలైనంత త్వరగా మిమ్మల్ని సంప్రదిస్తాము. Meanwhile, ఎలాంటి సందేహాలు ఉంటే దయచేసి 9177746889 కి ఫోన్ చేసి సంప్రదించండి.",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 14, color: Colors.black87),
                  // ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                         // or navigate elsewhere
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DashboardPage(),),);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFd4c900), Color(0xFF00ad20)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Ok',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}

