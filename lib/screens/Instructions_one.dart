import 'package:flutter/material.dart';
import 'package:providerapp_gobuddy/screens/registrationPage.dart';
import 'package:providerapp_gobuddy/utilites/button.dart';

class InstructionsOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            SizedBox(height: 20,),
            // Top illustration image
            Center(
              child: Image.asset(
                'assets/instruction.png', // Replace with your actual image
                height: 180,
              ),
            ),
            SizedBox(height: 20),

            // Title
            Center(
              child: Text(
                'Steps to Onboard and Receive Jobs',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 6),
            Center(
              child: Text(
                'ఆన్‌బోర్డ్ కావడానికి మరియు జాబ్స్ పొందడానికి స్టెప్స్',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 24),

            // Steps with icons on left
            StepItem(
              image: 'assets/checkbox.png',
              title: '1. Register by entering your name and number',
              subtitle: 'మీ పేరు మరియు నంబర్ నమోదు చేయండి',
            ),
            StepItem(
              image: 'assets/checkbox.png',
              title: '2. Provide details for eKYC',
              subtitle: 'e-KYC వివరాలను నమోదు చేయండి',
            ),
            StepItem(
              image: 'assets/payment.png',
              title: '3. Pay one-time registration fee of ₹300/-',
              subtitle: 'రూ. 300/- రిజిస్ట్రేషన్ చార్జ్ చెల్లించండి',
            ),

            Spacer(),

            // Bottom Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: handle skip
                  },
                  child: Text('Skip'),
                ),
                GradientButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InstructionsTwo()),
                    );
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}
class StepItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const StepItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enlarged image
          Image.asset(
            image,
            height: 48, // Increased from 36
            width: 48,  // Increased from 36
          ),
          SizedBox(width: 16), // Slightly wider spacing

          // Enlarged text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16, // Increased from 14
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15, // Increased from 13
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Placeholder for next screen
class InstructionsTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 20,),
            // Top illustration image
            Center(
              child: Image.asset(
                'assets/instruction.png', // Replace with your actual image
                height: 180,
              ),
            ),
            SizedBox(height: 20),

            // Title
            Center(
              child: Text(
                'Steps to Onboard and Receive Jobs',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 6),
            Center(
              child: Text(
                'ఆన్‌బోర్డ్ కావడానికి మరియు జాబ్స్ పొందడానికి స్టెప్స్',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 24),

            // Steps with icons on left
            StepItem(
              image: 'assets/check.png',
              title: '4. Complete background check to purchase subscription',
              subtitle: 'మీ పేరు మరియు నంబర్ నమోదు చేయండి',
            ),
            StepItem(
              image: 'assets/subscribe.png',
              title: '5. Purchase Subscription',
               subtitle: 'e-KYC వివరాలను నమోదు చేయండి',
            ),
            StepItem(
              image: 'assets/financial-statement.png',

              title: '6. Start receiving your jobs and increase your earnings-',
              subtitle: 'రూ. 300/- రిజిస్ట్రేషన్ చార్జ్ చెల్లించండి',
            ),

            Spacer(),

            // Bottom Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: handle skip
                  },
                  child: Text('Skip'),
                ),
        GradientButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RegistrationPage()),
            );
          },
          child: Text(
            'Get Started',
            style: TextStyle(
              fontFamily: 'Urbanist',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),




              ],
            ),
          ],
        ),
      ),
    );
  }
}
