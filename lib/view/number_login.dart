import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:investorapp/view/otp_screen.dart';
import 'package:page_transition/page_transition.dart';

class NumberLogin extends StatelessWidget {
  const NumberLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            automaticallyImplyLeading: false,
          )),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background circles
          Positioned(
            top: 40,
            left: 0,
            child: Image.asset('assets/right_circle.png', width: 100),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/circle-2 2.png', width: 100),
          ),

          // Main content column
          Column(
            children: [
              const SizedBox(height: 60),
              // Top image and title
              Container(
                padding: const EdgeInsets.only(left: 80),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset('assets/otp_screen_img.png', width: 280),
                    ),
                    const Text(
                      'Your Journey Our Wheels',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFA50F),
                        fontSize: 19,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Blurred white card
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 5.0),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.10),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            border: Border.all(
                              color: const Color(0xFFF1F1F1),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          child: SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Image.asset('assets/Loco-Rides-Secondary-Logo_PNG 1 (1).png', width: 220),
                                    const SizedBox(height: 3),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color.fromARGB(255, 12, 12, 12)),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Investor Hub',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(height: 100),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Enter your login information',
                                            textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: 293,
                                          height: 53,
                                          decoration: const ShapeDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [Color(0xFFE6E6E6), Color(0xFFF1F1F1)],
                                            ),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(width: 2, color: Colors.white),
                                              borderRadius: BorderRadius.all(Radius.circular(9.75)),
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0x3F000000),
                                                blurRadius: 31.50,
                                                offset: Offset(0, 4),
                                                spreadRadius: -7,
                                              )
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Text('+91', style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w700)),
                                              const SizedBox(width: 10),
                                              Container(
                                                width: 2,
                                                height: 27,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFD9D9D9),
                                                  borderRadius: BorderRadius.circular(58),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Expanded(
                                                child: Text(
                                                  'Enter Your Phone Number',
                                                  style: TextStyle(
                                                    color: Color(0xFF8E8E8E),
                                                    fontSize: 12,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 35),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(type: PageTransitionType.rightToLeft, child: const OtpScreen(), duration: const Duration(milliseconds: 300)),
                                        );
                                      },
                                      child: Container(
                                        width: 293,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF23300),
                                          borderRadius: BorderRadius.circular(9.75),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'GET OTP',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )))),
                ),
              ),
            ],
          ),

          // Bottom terms and conditions
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'By clicking through, I agree with the\n',
                      style: TextStyle(
                        color: Color(0xFF8E8E8E),
                        fontSize: 10,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        color: Color(0xFF418BFF),
                        fontSize: 10,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(
                        color: Color(0xFF8E8E8E),
                        fontSize: 10,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFF418CFF),
                        fontSize: 10,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
