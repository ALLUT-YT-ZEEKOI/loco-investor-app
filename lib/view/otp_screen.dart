import 'package:flutter/material.dart';
import 'package:investorapp/view/bottom_bar_screens/bottom_bar.dart';
import 'package:page_transition/page_transition.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFA50F), // Orange background
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              'Verify your number',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Enter OTP received on Whatsapp',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 32),

            // OTP input boxes
            const Text(
              'ENTER THE 6 DIGIT OTP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return Container(
                  width: size.width * 0.12,
                  height: size.width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),

            const SizedBox(height: 12),

            // Resend
            const Text(
              'Resend in 58 seconds',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),

            const Spacer(),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(type: PageTransitionType.rightToLeft, child:  BottomBar(), duration: const Duration(milliseconds: 300)),
                  );
                },
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Terms and Conditions
            const Center(
              child: Text(
                'By verifying OTP, you agree to our Terms & Conditions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
