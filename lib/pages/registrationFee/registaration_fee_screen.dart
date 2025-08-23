import 'package:flutter/material.dart';

import '../../components/coupon_applied_alert.dart';
import '../../utils/config.dart';

class RegistrationFeeScreen extends StatefulWidget {
  const RegistrationFeeScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationFeeScreen> createState() => _RegistrationFeeScreenState();
}

class _RegistrationFeeScreenState extends State<RegistrationFeeScreen> {
  final TextEditingController _referralController = TextEditingController();

  @override
  void dispose() {
    _referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: SafeArea(
        child: Container(
          width: deviceWidth,
          height: deviceHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF66BB6A),
                Color(0xFF4CAF50),
                Color(0xFF388E3C),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.08),
              child: Column(
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, right: deviceWidth * 0.02),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: deviceHeight * 0.04),

                  // Main Icon container
                  Container(
                    width: deviceWidth * 0.35,
                    height: deviceWidth * 0.35,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Charts/graphs background
                        Container(
                          width: deviceWidth * 0.18,
                          height: deviceWidth * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomPaint(
                            painter: ChartPainter(),
                          ),
                        ),
                        // Hand holding card
                        Positioned(
                          bottom: deviceWidth * 0.08,
                          right: deviceWidth * 0.05,
                          child: Container(
                            width: deviceWidth * 0.15,
                            height: deviceWidth * 0.08,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade800,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        // Person figure
                        Positioned(
                          bottom: deviceWidth * 0.06,
                          left: deviceWidth * 0.12,
                          child: SizedBox(
                            width: 20,
                            height: 30,
                            child: CustomPaint(
                              painter: PersonPainter(),
                            ),
                          ),
                        ),
                        // Checkmark
                        Positioned(
                          top: deviceWidth * 0.05,
                          right: deviceWidth * 0.08,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFA726),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: deviceHeight * 0.03),

                  // Title
                  const Text(
                    'One Time Registration Fee',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: deviceHeight * 0.01),

                  // Price
                  const Text(
                    '₹ 300',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: deviceHeight * 0.02),

                  // Description in English
                  const Text(
                    'Your one-time registration fee will cover detailed App training to manage jobs and view your financial growth, and other materials supply.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: deviceHeight * 0.015),

                  // Contact number
                  const Text(
                    'For any inquiries Contact: 9177746889',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: deviceHeight * 0.025),

                  // Telugu text
                  const Text(
                    'మీ ఒక-సారి రిజిస్ట్రేషన్ ఫీజు ఉద్యోగాలను నిర్వహించడానికి మరియు మీ ఆర్థిక వృద్ధిని చూడటానికి వివరణాత్మక యాప్ శిక్షణను మరియు ఇతర సామగ్రి సరఫరాను కవర్ చేస్తుంది.\nఏవైనా విచారణలు కోసం సంప్రదించండి: 9177746889',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: deviceHeight * 0.04),

                  // Referral code section
                  const Text(
                    'Enter referral code ( Optional )',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: deviceHeight * 0.015),

                  // Input field and button
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: _referralController,
                            style: const TextStyle(color: Colors.white),
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(FocusNode()); // Hides keyboard
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter code',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth * 0.04),
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            // ✅ Hide keyboard first
                            FocusScope.of(context).unfocus();
                            showDialog(
                              context: context,
                              builder: (_) => const ReferralDialog(
                                title: "Offer code applied",
                                subtitle: "₹ 100 savings with this code",
                                image: "assets/images/couponCode.png",
                              ),
                            );
                            //regiSuccessRouteName
                            // Delay for 4 seconds then navigate
                            Future.delayed(const Duration(seconds: 4), () {
                              Navigator.of(context).pop(); // Close the dialog


                            });

                            print('Apply pressed with code: ${_referralController.text}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF4CAF50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: deviceHeight * 0.05),

                  // Continue button
                 GestureDetector(
                   onTap: (){
                     Future.delayed(const Duration(seconds: 4), () {
                       Navigator.of(context).pop(); // Close the dialog
                       // Navigator.of(context).pushReplacementNamed(
                       //   Config.regiSuccessRouteName,);
                       Navigator.pushNamed(
                         context,
                         Config.paymentMethodRouteName,
                         arguments: {
                           "amount": 200.0,
                           "fromScreen": "reg_fee",
                         },
                       );

                     });
                   },
                   child:  Container(
                     width: 55,
                     height: 55,
                     decoration: const BoxDecoration(
                       color: Colors.white,
                       shape: BoxShape.circle,
                     ),
                     child: const Icon(
                       Icons.arrow_forward_ios,
                       color: Color(0xFF4CAF50),
                       size: 20,
                     ),
                   ),
                 ),

                  SizedBox(height: deviceHeight * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for the chart/graph illustration
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 2;

    final barWidth = size.width * 0.15;
    final spacing = size.width * 0.1;

    for (int i = 0; i < 3; i++) {
      final height = size.height * (0.3 + i * 0.2);
      final x = spacing + i * (barWidth + spacing);

      if (i == 0) {
        paint.color = Colors.red.shade400;
      } else if (i == 1) {
        paint.color = Colors.orange.shade400;
      } else {
        paint.color = Colors.blue.shade400;
      }

      final rect = Rect.fromLTWH(x, size.height - height, barWidth, height);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for the person figure
class PersonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.orange.shade600;

    // Head
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.25),
      size.width * 0.15,
      paint,
    );

    // Body
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.35,
        size.height * 0.35,
        size.width * 0.3,
        size.height * 0.4,
      ),
      paint,
    );

    // Arms
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.4,
        size.width * 0.8,
        size.width * 0.1,
      ),
      paint,
    );

    // Legs
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.35,
        size.height * 0.75,
        size.width * 0.12,
        size.height * 0.25,
      ),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.53,
        size.height * 0.75,
        size.width * 0.12,
        size.height * 0.25,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
