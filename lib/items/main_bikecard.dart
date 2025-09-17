import 'package:flutter/material.dart';
import 'package:investorapp/extrafunction/reusable.dart';
import 'package:investorapp/provider/api_provider.dart';
import 'package:investorapp/provider/objects.dart';
import 'package:provider/provider.dart';

class HorizontalBikeCards extends StatefulWidget {
  const HorizontalBikeCards({super.key});

  @override
  State<HorizontalBikeCards> createState() => _HorizontalBikeCardsState();
}

class _HorizontalBikeCardsState extends State<HorizontalBikeCards> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final ScrollController _dotController = ScrollController();
  int _currentPage = 0;

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

  // Helper method to get status colors
  Map<String, dynamic> _getStatusColors(String status) {
    switch (status.toLowerCase()) {
      case 'idle':
        return {
          'statusColor': const Color(0xFFFD880B),
          'bgStatusColor': const Color(0xFFBA6204),
          'borderClr': const Color(0xFFFD880B),
          'iconPath': 'assets/idel_icon.png',
        };
      case 'in trip':
      case 'active':
        return {
          'statusColor': const Color(0xFF5DC452),
          'bgStatusColor': const Color(0xFF2F9623),
          'borderClr': const Color(0xFF5DC452),
          'iconPath': 'assets/motorbike.png',
        };
      case 'in service':
      case 'maintenance':
        return {
          'statusColor': const Color(0xFFFF4E47),
          'bgStatusColor': const Color(0xFFD21B14),
          'borderClr': const Color(0xFFFF4E47),
          'iconPath': 'assets/service_icon (2).png',
        };
      default:
        return {
          'statusColor': const Color(0xFF5DC452),
          'bgStatusColor': const Color(0xFF2F9623),
          'borderClr': const Color(0xFF5DC452),
          'iconPath': 'assets/motorbike.png',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(
      builder: (context, apiProvider, child) {
        if (apiProvider.getAssets.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            const SizedBox(height: 5),
            SizedBox(
              height: 355,
              child: PageView.builder(
                controller: _pageController,
                itemCount: apiProvider.getAssets.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  _updateDotPosition();
                },
                itemBuilder: (context, index) {
                  Asset asset = apiProvider.getAssets[index];
                  Map<String, dynamic> statusColors = _getStatusColors(asset.status);

                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: MainBikecard(
                        asset: asset,
                        statusColor: statusColors['statusColor'],
                        bgStatusColor: statusColors['bgStatusColor'],
                        borderClr: statusColors['borderClr'],
                        iconPath: statusColors['iconPath'],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            if (apiProvider.getAssets.length > 1)
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
                        apiProvider.getAssets.length,
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
      },
    );
  }
}

class MainBikecard extends StatelessWidget {
  final Asset asset;
  final Color statusColor;
  final Color bgStatusColor;
  final Color borderClr;
  final String iconPath;

  const MainBikecard({super.key, required this.asset, required this.statusColor, required this.bgStatusColor, required this.borderClr, required this.iconPath});

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
                // Manufacturer logo from API with fast loading
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    asset.manufacturerLogo,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    cacheWidth: 100, // Cache at 2x resolution for crisp display
                    cacheHeight: 100,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.motorcycle, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.manufacturer,
                        textScaler: noTextScaler,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        asset.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaler: noTextScaler,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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
                            asset.status,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      asset.image,
                      width: 290,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/TVS Jupiter.png', width: 290, fit: BoxFit.contain);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          /// Bottom Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Owner Profit:', style: totalEarning),
                    Text('₹${asset.ownerProfitAmt.toStringAsFixed(0)}', style: totalEarningamt),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Asset ID:', style: totalEarning),
                    Text(asset.assetIdentifier, style: totalEarningamtred),
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
