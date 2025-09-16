import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:investorapp/extrafunction/reusable.dart';
import 'package:investorapp/items/main_bikecard.dart';
import 'package:investorapp/items/items.dart';
import 'package:investorapp/provider/api_provider.dart';
import 'package:investorapp/provider/earning_provider.dart';
import 'package:investorapp/provider/objects.dart';
import 'package:provider/provider.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
    _shimmerController.repeat();

    // Defer the API call until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApiProvider>(context, listen: false).getAllAssets();
      Provider.of<ApiProvider>(context, listen: false).getUser();
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Widget _buildShimmerCard() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFF3F3F3)],
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.8, color: Colors.grey),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row shimmer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Row(
                  children: [
                    _buildShimmerBox(50, 50, borderRadius: 8),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShimmerBox(40, 10),
                          const SizedBox(height: 2),
                          _buildShimmerBox(120, 16),
                        ],
                      ),
                    ),
                    _buildShimmerBox(80, 30, borderRadius: 50),
                  ],
                ),
              ),
              // Image area shimmer
              Container(
                height: 210,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildShimmerBox(double.infinity, 210, borderRadius: 8),
              ),
              const SizedBox(height: 10),
              // Bottom info shimmer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerBox(80, 12),
                        const SizedBox(height: 4),
                        _buildShimmerBox(60, 16),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerBox(60, 12),
                        const SizedBox(height: 4),
                        _buildShimmerBox(80, 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerInvestmentCard() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerBox(60, 20),
                const SizedBox(height: 8),
                _buildShimmerBox(100, 16),
                const Spacer(),
                _buildShimmerBox(80, 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerBox(double width, double height, {double borderRadius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
            Colors.grey.shade300,
          ],
          stops: [
            _shimmerAnimation.value - 0.3,
            _shimmerAnimation.value,
            _shimmerAnimation.value + 0.3,
          ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
        ),
      ),
    );
  }

  // Calculate total earnings from all assets
  String _calculateTotalEarnings(List<Asset> assets) {
    if (assets.isEmpty) return "0";

    double total = assets.fold(0.0, (sum, asset) => sum + asset.ownerProfitAmt);
    return total.toStringAsFixed(0);
  }

  // Calculate total payout from all assets
  String _calculateTotalPayout(List<Asset> assets) {
    if (assets.isEmpty) return "0";

    double total = assets.fold(0.0, (sum, asset) => sum + asset.payoutSum);
    return total.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = Provider.of<EarningProvider>(context);
    final apiProvider = Provider.of<ApiProvider>(context);

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
                                blurRadius: 31.50,
                                offset: Offset(0, 4),
                                spreadRadius: -7,
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 4),
                              const CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage('assets/maskperson.png'),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
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
                                    apiProvider.currentUser?.name ?? '',
                                    textScaler: noTextScaler,
                                    style: const TextStyle(
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
        body: Consumer<ApiProvider>(
          builder: (context, apiProvider, child) {
            // Show full page loading with shimmer effect
            if (apiProvider.isLoading) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    // Shimmer effect for bike cards
                    SizedBox(
                      height: 355,
                      child: PageView.builder(
                        itemCount: 2, // Show 2 shimmer cards
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: _buildShimmerCard(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Shimmer dots
                    SizedBox(
                      height: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            2,
                            (index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Shimmer for investment cards
                    Container(
                      padding: const EdgeInsets.all(13),
                      child: Column(
                        children: [
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(child: _buildShimmerInvestmentCard()),
                              const SizedBox(width: 18),
                              Expanded(child: _buildShimmerInvestmentCard()),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(child: _buildShimmerInvestmentCard()),
                              const SizedBox(width: 18),
                              Expanded(child: _buildShimmerInvestmentCard()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Show content when loaded
            return SingleChildScrollView(
              child: Column(
                children: [
                  const HorizontalBikeCards(),
                  Container(
                      padding: const EdgeInsets.all(13),
                      child: Column(children: [
                        const DottedLine(
                          dashColor: Colors.grey,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Row(
                          children: [
                            HomePageInvesteCard(bigText: apiProvider.getAssets.length.toString(), description: "Total Assets\nInvested", imagePath: 'assets/earning_icon.png'),
                            const Spacer(),
                            HomePageInvesteCard(bigText: "₹${_calculateTotalEarnings(apiProvider.getAssets)}", description: "Total Earnings\n(Lifetime)", imagePath: 'assets/earning_icon.png'),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Row(
                          children: [
                            HomePageInvesteCard(bigText: "₹${_calculateTotalPayout(apiProvider.getAssets)}", description: "Total Payout \n(Lifetime)", imagePath: 'assets/earning_icon.png'),
                            const Spacer(),
                            HomePageInvesteCard(bigText: "₹${_calculateTotalEarnings(apiProvider.getAssets)}", description: "Total Remaining \n(Lifetime)", imagePath: 'assets/earning_icon.png'),
                          ],
                        )
                      ])),
                ],
              ),
            );
          },
        ));
  }
}
