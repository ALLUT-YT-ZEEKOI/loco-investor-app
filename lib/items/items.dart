import 'package:flutter/material.dart';
import 'package:investorapp/extrafunction/reusable.dart';

class HomePageInvesteCard extends StatelessWidget {
  final String bigText;
  final String description;
  final String imagePath;

  const HomePageInvesteCard({
    super.key,
    required this.bigText,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth(context) * .4 + 20,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-1.00, 0.90),
          end: Alignment(1.00, 0.50),
          colors: [Colors.white, Color(0xFFE7E7E7)],
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [BoxShadow(color: Color(0x3F000000), blurRadius: 20, offset: Offset(0, 4), spreadRadius: -7)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bigText,
            style: const TextStyle(
              color: Color(0xFF222222),
              fontSize: 28,
              fontFamily: 'Calibri',
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Image.asset(
                imagePath,
                width: 25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomePageInvesteCard2 extends StatelessWidget {
  final String bigText;
  final String description;
  final String imagePath;

  const HomePageInvesteCard2({
    super.key,
    required this.bigText,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: getScreenWidth(context) * .9,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-1.00, 0.90),
          end: Alignment(1.00, 0.50),
          colors: [Colors.white, Color(0xFFE7E7E7)],
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [BoxShadow(color: Color(0x3F000000), blurRadius: 20, offset: Offset(0, 4), spreadRadius: -7)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bigText,
            style: const TextStyle(
              color: Color(0xFF222222),
              fontSize: 32,
              fontFamily: 'Calibri',
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Image.asset(
                imagePath,
                width: 25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
