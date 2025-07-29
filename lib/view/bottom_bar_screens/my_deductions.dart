import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:investorapp/customwidgets/custom_title_app_bar.dart';
import 'package:investorapp/customwidgets/custom_toggle.dart';
import 'package:investorapp/items/items.dart';

class MyDeductions extends StatefulWidget {
  const MyDeductions({super.key});

  @override
  State<MyDeductions> createState() => _MyDeductionsState();
}

class _MyDeductionsState extends State<MyDeductions> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customTitleAppBar(context, "My", "Deductions"),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            child: Column(
              children: [
                isLoading
                    ? shimmerBox(width: double.infinity, height: 100)
                    : const HomePageInvesteCard_2(
                        bigText: "15000",
                        description: "Total Earnings\n(Lifetime)",
                        imagePath: 'assets/earning_icon.png',
                      ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    isLoading
                        ? shimmerBox(width: 150, height: 100)
                        : const HomePageInvesteCard(
                            bigText: "1",
                            description: "Total Earnings\n(Lifetime)",
                            imagePath: 'assets/earning_icon.png',
                          ),
                    const Spacer(),
                    isLoading
                        ? shimmerBox(width: 150, height: 100)
                        : const HomePageInvesteCard(
                            bigText: "₹1500",
                            description: "Total Deductions \n(Lifetime)",
                            imagePath: 'assets/earning_icon.png',
                          ),
                  ],
                ),
                const SizedBox(height: 18),
                isLoading ? shimmerBox(width: double.infinity, height: 40) : MonthToggle(onToggle: (p) {}),
                const SizedBox(height: 18),
                isLoading ? shimmerBox(width: double.infinity, height: 100) : _summaryCard(),
                const SizedBox(height: 18),
                isLoading ? shimmerBox(width: double.infinity, height: 70) : _deductionRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [Colors.white, Color(0xFFE7E7E7)],
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [BoxShadow(color: Color(0x3F000000), blurRadius: 20, offset: Offset(0, 4), spreadRadius: -7)],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Bookings', style: TextStyle(color: Color(0xFF7B7B7B), fontSize: 12, fontFamily: 'Montserrat', fontWeight: FontWeight.w500)),
              Text('15', style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Calibri', fontWeight: FontWeight.w800)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total Bookings', style: TextStyle(color: Color(0xFF7B7B7B), fontSize: 12, fontFamily: 'Montserrat', fontWeight: FontWeight.w500)),
              Text('₹5,000', style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Calibri', fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deductionRow() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: const ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, -0.00),
                end: Alignment(0.50, 1.00),
                colors: [Color(0xFFE7E7E7), Colors.white],
              ),
              shape: OvalBorder(
                side: BorderSide(width: 2, color: Colors.white),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                  spreadRadius: -5,
                )
              ],
            ),
            child: Center(child: Image.asset('assets/small_scooter.png')),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TVS Jupiter BS6 2025',
                style: TextStyle(
                  color: Color(0xFF7B7B7B),
                  fontSize: 11,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Title',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            '₹1,000',
            style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Calibri', fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  // 🔧 Shimmer Box Utility
  Widget shimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
