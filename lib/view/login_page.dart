import 'package:flutter/material.dart';
import 'package:investorapp/view/number_login.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Left Decoration
          Positioned(
            child: Image.asset(
              'assets/right_circle.png',
              width: 100,
            ),
          ),

          // Bottom Right Decoration
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/circle-2 2.png', width: 100),
          ),
          Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(type: PageTransitionType.rightToLeft, child: const NumberLogin(), duration: const Duration(milliseconds: 300)),
                        );
                      },
                      child: Image.asset('assets/next_btn.png', width: 100)))),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/Loco-Rides-Secondary-Logo_PNG 1 (1).png', width: 250),
                  const Text(
                    'WHERE EVERY RIDE BEGINS',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Montserrat', fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
