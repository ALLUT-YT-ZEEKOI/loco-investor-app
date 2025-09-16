import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

import 'package:investorapp/customwidgets/custom_title_app_bar.dart';
import 'package:investorapp/customwidgets/custom_toggle.dart';
import 'package:investorapp/items/items.dart';
import 'package:investorapp/provider/api_provider.dart';
import 'package:investorapp/provider/objects.dart';

class MyDeductions extends StatefulWidget {
  const MyDeductions({super.key});

  @override
  State<MyDeductions> createState() => _MyDeductionsState();
}

class _MyDeductionsState extends State<MyDeductions> {
  bool isLoading = true;
  bool isVehicleDeductionsLoading =
      false; // Separate loading state for vehicle deductions section
  String currentMonthFilter = 'this_month'; // Track current filter state

  @override
  void initState() {
    super.initState();

    // Load all assets data and current month data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);

      // Load all assets first (for total deductions card)
      if (apiProvider.allAssets.isEmpty) {
        await apiProvider.getAllAssets();
      }

      // Then load current month data
      await apiProvider.filterAssetsByMonth('this_month');

      if (mounted) {
        setState(() {
          isLoading = false; // Hide initial loading after data is loaded
        });
      }
    });
  }

  // Calculate total deductions from filtered assets
  String _calculateTotalDeductions(List<Asset> assets) {
    if (assets.isEmpty) return "0";

    double total = assets.fold(0.0, (sum, asset) => sum + asset.deductionSum);
    print(
        '🔍 Deduction calculation: ${assets.length} assets, total deduction: $total');
    return total.toStringAsFixed(0);
  }

  // Format number with commas for better readability
  String _formatNumber(double number) {
    if (number == 0) return "0";

    String formatted = number.toStringAsFixed(0);
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return formatted.replaceAllMapped(reg, (Match match) => '${match[1]},');
  }

  // Count assets with deductions > 0
  int _countAssetsWithDeductions(List<Asset> assets) {
    return assets.where((asset) => asset.deductionSum > 0).length;
  }

  // Get assets with deductions (filter out assets with 0 deductions)
  List<Asset> _getAssetsWithDeductions(List<Asset> assets) {
    return assets.where((asset) => asset.deductionSum > 0).toList();
  }

  // Handle month toggle
  void _handleMonthToggle(String monthType) async {
    setState(() {
      currentMonthFilter =
          monthType == 'This Month' ? 'this_month' : 'last_month';
      isVehicleDeductionsLoading =
          true; // Show shimmer for vehicle deductions section
    });

    // Filter assets based on selected month
    await Provider.of<ApiProvider>(context, listen: false)
        .filterAssetsByMonth(currentMonthFilter);

    // Hide shimmer after loading is complete
    if (mounted) {
      setState(() {
        isVehicleDeductionsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customTitleAppBar(context, "My", "Deductions"),
      body: isLoading
          ? _buildShimmerLoading()
          : Consumer<ApiProvider>(
              builder: (context, apiProvider, child) {
                return ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 8),
                      child: Column(
                        children: [
                          HomePageInvesteCard_2(
                            bigText:
                                "₹${_formatNumber(double.parse(_calculateTotalDeductions(apiProvider.allAssets)))}",
                            description: "Total\nDeductions",
                            imagePath: 'assets/earning_icon.png',
                          ),
                          const SizedBox(height: 18),
                          MonthToggle(
                            isThisMonth: currentMonthFilter == 'this_month',
                            onToggle: _handleMonthToggle,
                          ),
                          const SizedBox(height: 18),
                          _summaryCard(apiProvider.getAssets),
                          const SizedBox(height: 18),
                          isVehicleDeductionsLoading
                              ? shimmerBox(width: double.infinity, height: 70)
                              : _deductionsList(apiProvider.getAssets),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _summaryCard(List<Asset> assets) {
    final totalDeductions = _calculateTotalDeductions(assets);

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
        shadows: const [
          BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 20,
              offset: Offset(0, 4),
              spreadRadius: -7)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assets with Deductions\n${currentMonthFilter == 'this_month' ? '(This Month)' : '(Last Month)'}',
                style: const TextStyle(
                    color: Color(0xFF7B7B7B),
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500),
              ),
              Text(_countAssetsWithDeductions(assets).toString(),
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
                'Total Deductions\n${currentMonthFilter == 'this_month' ? '(This Month)' : '(Last Month)'}',
                style: const TextStyle(
                    color: Color(0xFF7B7B7B),
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500),
              ),
              Text('₹${_formatNumber(double.parse(totalDeductions))}',
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

  Widget _deductionsList(List<Asset> assets) {
    final assetsWithDeductions = _getAssetsWithDeductions(assets);

    if (assetsWithDeductions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            currentMonthFilter == 'this_month'
                ? 'No deductions found this month'
                : 'No deductions found last month',
            style: const TextStyle(
              color: Color(0xFF7B7B7B),
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            currentMonthFilter == 'this_month'
                ? 'This Month Vehicle Deductions'
                : 'Last Month Vehicle Deductions',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...assetsWithDeductions.map((asset) => _deductionRow(asset)),
      ],
    );
  }

  Widget _deductionRow(Asset asset) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top section with vehicle info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Circular vehicle image container
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5), // Light grey background
                    borderRadius: BorderRadius.circular(27.5),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: asset.manufacturerLogo.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(27.5),
                            child: Image.network(
                              asset.manufacturerLogo,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/small_scooter.png',
                                  width: 30,
                                  height: 30,
                                );
                              },
                            ),
                          )
                        : Image.asset(
                            'assets/small_scooter.png',
                            width: 30,
                            height: 30,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle registration number
                      Text(
                        asset.assetIdentifier,
                        style: const TextStyle(
                          color: Color(0xFF7B7B7B),
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Vehicle name/type
                      Text(
                        asset.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider line
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          // Bottom section with financial breakdown
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Total Column
                Column(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: Color(0xFF5DC452),
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      asset.ownerProfitAmt > 0
                          ? asset.ownerProfitAmt.toStringAsFixed(0)
                          : '0',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                // Company Column
                Column(
                  children: [
                    const Text(
                      'Company',
                      style: TextStyle(
                        color: Color(0xFF5DC452),
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      asset.payoutSum > 0
                          ? asset.payoutSum.toStringAsFixed(0)
                          : '0',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                // Deduction Column
                Column(
                  children: [
                    const Text(
                      'Deduction',
                      style: TextStyle(
                        color: Color(0xFFFF4E47),
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      asset.deductionSum > 0
                          ? '₹${_formatNumber(asset.deductionSum)}'
                          : '₹0',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
              // Main deduction card shimmer
              shimmerBox(width: double.infinity, height: 100),
              const SizedBox(height: 18),
              // Month toggle shimmer
              shimmerBox(width: double.infinity, height: 50),
              const SizedBox(height: 18),
              // Summary card shimmer
              shimmerBox(width: double.infinity, height: 80),
              const SizedBox(height: 18),
              // Vehicle deductions shimmer
              shimmerBox(width: double.infinity, height: 200),
            ],
          ),
        ),
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
