import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:investorapp/customwidgets/custom_title_app_bar.dart';
import 'package:investorapp/customwidgets/custom_toggle.dart';
import 'package:investorapp/items/items.dart';
import 'package:investorapp/provider/api_provider.dart';
import 'package:investorapp/provider/objects.dart';
import 'package:provider/provider.dart';

class MyEarnigns extends StatefulWidget {
  const MyEarnigns({super.key});

  @override
  State<MyEarnigns> createState() => _MyBikeScreenState();
}

class _MyBikeScreenState extends State<MyEarnigns> {
  bool isLoading = true;
  bool isVehicleEarningsLoading =
      false; // Separate loading state for vehicle earnings section
  String currentMonthFilter = 'this_month'; // Track current filter state

  @override
  void initState() {
    super.initState();
    // Load all necessary data for earnings screen
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);

      // Load all assets first (for total earnings card)
      await apiProvider.getAllAssets();

      // Then load current month filtered data
      await apiProvider.filterAssetsByMonth('this_month');

      if (mounted) {
        setState(() {
          isLoading = false; // Hide initial loading after data is loaded
        });
      }
    });
  }

  // Calculate total earnings from filtered assets
  String _calculateTotalEarnings(List<Asset> assets) {
    if (assets.isEmpty) return "0";
    double total = assets.fold(0.0, (sum, asset) => sum + asset.ownerProfitAmt);
    return total.toStringAsFixed(0);
  }

  // Count assets with profit > 0
  int _countProfitableAssets(List<Asset> assets) {
    return assets.where((asset) => asset.ownerProfitAmt > 0).length;
  }

  // Handle month toggle
  void _handleMonthToggle(String monthType) async {
    setState(() {
      currentMonthFilter =
          monthType == 'This Month' ? 'this_month' : 'last_month';
      isVehicleEarningsLoading =
          true; // Show shimmer for vehicle earnings section
    });

    // Filter assets based on selected month
    await Provider.of<ApiProvider>(context, listen: false)
        .filterAssetsByMonth(currentMonthFilter);

    // Hide shimmer after loading is complete
    if (mounted) {
      setState(() {
        isVehicleEarningsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customTitleAppBar(context, "My", "Earnings"),
      body: Consumer<ApiProvider>(
        builder: (context, apiProvider, child) {
          // Show shimmer if API is loading or local loading state
          if (apiProvider.isLoading || isLoading) {
            return _buildShimmerLoading();
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Refresh all assets data and current month data
              await apiProvider.getAllAssets();
              await apiProvider.filterAssetsByMonth(currentMonthFilter);
            },
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          HomePageInvesteCard(
                            bigText: apiProvider.allAssets.length.toString(),
                            description: "Total Bikes\ninvested",
                            imagePath: 'assets/transport 1 (1).png',
                          ),
                          const Spacer(),
                          HomePageInvesteCard(
                            bigText:
                                "₹${_calculateTotalEarnings(apiProvider.allAssets)}",
                            description: "Total Earnings\n(Lifetime)",
                            imagePath: 'assets/earning_icon.png',
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      MonthToggle(
                        isThisMonth: currentMonthFilter == 'this_month',
                        onToggle: _handleMonthToggle,
                      ),
                      const SizedBox(height: 18),
                      _summaryCard(apiProvider),
                      const SizedBox(height: 18),
                      isVehicleEarningsLoading
                          ? shimmerBox(width: double.infinity, height: 70)
                          : _earningRow(apiProvider.getAssets),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(ApiProvider apiProvider) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Total Bookings\n${currentMonthFilter == 'this_month' ? '(This Month)' : '(Last Month)'}',
                  style: const TextStyle(
                      color: Color(0xFF7B7B7B),
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500)),
              Text(_countProfitableAssets(apiProvider.getAssets).toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.w800)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  'Total Rental Income\n${currentMonthFilter == 'this_month' ? '(This Month)' : '(Last Month)'}',
                  style: const TextStyle(
                      color: Color(0xFF7B7B7B),
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500)),
              Text("₹${_calculateTotalEarnings(apiProvider.getAssets)}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _earningRow(List<Asset> assets) {
    if (assets.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: const Center(
          child: Text(
            'No assets found',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentMonthFilter == 'this_month'
                ? 'This Month Vehicle Earnings'
                : 'Last Month Vehicle Earnings',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...assets.map((asset) => _buildVehicleRow(asset)),
        ],
      ),
    );
  }

  Widget _buildVehicleRow(Asset asset) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                asset.manufacturerLogo,
                width: 55,
                height: 55,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Image.asset('assets/small_scooter.png'));
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.assetIdentifier,
                  style: const TextStyle(
                    color: Color(0xFF7B7B7B),
                    fontSize: 11,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  asset.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(asset.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    asset.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${asset.ownerProfitAmt.toStringAsFixed(0)}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Calibri',
                    fontWeight: FontWeight.w700),
              ),
              const Text(
                'Profit',
                style: TextStyle(
                    color: Color(0xFF7B7B7B),
                    fontSize: 10,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'idle':
        return const Color(0xFFFD880B);
      case 'in trip':
      case 'active':
        return const Color(0xFF5DC452);
      case 'in service':
      case 'maintenance':
        return const Color(0xFFFF4E47);
      default:
        return const Color(0xFF6B7280);
    }
  }

  // 🔧 Shimmer Loading for entire page
  Widget _buildShimmerLoading() {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          child: Column(
            children: [
              // Top cards shimmer
              Row(
                children: [
                  Expanded(
                    child: shimmerBox(width: double.infinity, height: 100),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: shimmerBox(width: double.infinity, height: 100),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Month toggle shimmer
              shimmerBox(width: double.infinity, height: 50),
              const SizedBox(height: 18),
              // Summary card shimmer
              shimmerBox(width: double.infinity, height: 80),
              const SizedBox(height: 18),
              // Vehicle earnings shimmer
              shimmerBox(width: double.infinity, height: 200),
            ],
          ),
        ),
      ),
    );
  }

  // 🔧 Shimmer Box Generator
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
