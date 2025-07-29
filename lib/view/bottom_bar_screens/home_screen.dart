import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:investorapp/extrafunction/reusable.dart';
import 'package:investorapp/items/main_bikecard.dart';
import 'package:investorapp/items/items.dart';
import 'package:investorapp/provider/functiion.dart';
import 'package:provider/provider.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = Provider.of<EarningProvider>(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedIndex.setIndex(3);
                        },
                        child: Container(
                          height: 55,
                          decoration: ShapeDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(0.00, 0.50),
                              end: Alignment(1.00, 0.50),
                              colors: [Color(0xFFE7E7E7), Colors.white],
                            ),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 20,
                                offset: Offset(0, 4),
                                spreadRadius: -7,
                              )
                            ],
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 4),
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage('assets/maskperson.png'),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hello',
                                    textScaler: noTextScaler,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Qureshi Abrahm',
                                    textScaler: noTextScaler,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                            blurRadius: 31.5,
                            offset: Offset(0, 4),
                            spreadRadius: -7,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Notification action
                        },
                        icon: Image.asset('assets/notification_icon.png', width: 22),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const HorizontalBikeCards(),
            Container(
                padding: const EdgeInsets.all(13),
                child: const Column(children: [
                  DottedLine(
                    dashColor: Colors.grey,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      HomePageInvesteCard(bigText: "1", description: "Total Earnings\n(Lifetime)", imagePath: 'assets/earning_icon.png'),
                      Spacer(),
                      HomePageInvesteCard(bigText: "₹1500", description: "Total Deductions \n(Lifetime)", imagePath: 'assets/earning_icon.png'),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      HomePageInvesteCard(bigText: "₹5000", description: "Total Payout \n(Lifetime)", imagePath: 'assets/earning_icon.png'),
                      Spacer(),
                      HomePageInvesteCard(bigText: "₹50000", description: "Total Remaining \n(Lifetime)", imagePath: 'assets/earning_icon.png'),
                    ],
                  )
                ])),
          ],
        )));
  }
}
