import 'package:flutter/material.dart';
import 'package:investorapp/extrafunction/reusable.dart';

class HorizontalBikeCards extends StatefulWidget {
  const HorizontalBikeCards({super.key});

  @override
  State<HorizontalBikeCards> createState() => _HorizontalBikeCardsState();
}

class _HorizontalBikeCardsState extends State<HorizontalBikeCards> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final ScrollController _dotController = ScrollController();
  int _currentPage = 0;

  final List<Widget> cards = [
    const MainBikecard(
      status: 'In Trip',
      statusColor: Color(0xFF5DC452),
      bgStatusColor: Color(0xFF2F9623),
      borderClr: Color(0xFF5DC452),
      iconPath: 'assets/motorbike.png',
    ),
    const MainBikecard(
      status: 'Idle',
      statusColor: Color(0xFFFD880B),
      bgStatusColor: Color(0xFFBA6204),
      borderClr: Color(0xFFFD880B),
      iconPath: 'assets/idel_icon.png', // Add a suitable icon to your assets
    ),
    const MainBikecard(
      status: 'In Service',
      statusColor: Color(0xFFFF4E47),
      bgStatusColor: Color(0xFFD21B14),
      borderClr: Color(0xFFFF4E47),
      iconPath: 'assets/service_icon (2).png', // Add a suitable icon to your assets
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_updateDotPosition);
  }

  @override
  void dispose() {
    _pageController.removeListener(_updateDotPosition);
    _pageController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  void _updateDotPosition() {
    const double dotWidth = 6 + 6;
    final double targetPosition = (_currentPage * dotWidth) - (MediaQuery.of(context).size.width / 2) + (dotWidth / 2);

    _dotController.animateTo(
      targetPosition.clamp(0.0, _dotController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        SizedBox(
          height: 355,
          child: PageView.builder(
            controller: _pageController,
            itemCount: cards.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _updateDotPosition();
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: cards[index],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        if (cards.length > 1)
          SizedBox(
            height: 8,
            child: SingleChildScrollView(
              controller: _dotController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    cards.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == index ? 14 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? Colors.orange : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MainBikecard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final Color bgStatusColor;
  final Color borderClr;
  final String iconPath;

  const MainBikecard({super.key, required this.status, required this.statusColor, required this.bgStatusColor, required this.borderClr, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF3F3F3)],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.8, color: borderClr),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/tvslogo.png', width: 50, height: 50),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TVS', textScaler: noTextScaler, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                      SizedBox(height: 2),
                      Text('Jupiter BS6 2025...', maxLines: 1, overflow: TextOverflow.ellipsis, textScaler: noTextScaler, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: bgStatusColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3529263A),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            status,
                            textScaler: noTextScaler,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Image.asset(iconPath, width: 20, height: 20),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Bike Image Stack
          SizedBox(
            height: 210,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/flat_img.png', fit: BoxFit.fitWidth, width: double.infinity),
                Positioned(
                  top: 10,
                  child: Image.asset('assets/TVS Jupiter.png', width: 290, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          /// Bottom Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Today’s Earnings:', style: totalEarning),
                    Text('₹1500', style: totalEarningamt),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total KM:', style: totalEarning),
                    Text('130km', style: totalEarningamtred),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
