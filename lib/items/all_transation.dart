import 'package:flutter/material.dart';
import 'package:investorapp/customwidgets/custom_toggle.dart';
import 'package:investorapp/provider/api_provider.dart';
import 'package:investorapp/provider/objects.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AllTransation extends StatefulWidget {
  const AllTransation({super.key});

  @override
  State<AllTransation> createState() => _AllTransationState();
}

class _AllTransationState extends State<AllTransation> {
  bool isLoading = true;
  String currentMonthFilter = 'this_month';

  @override
  void initState() {
    super.initState();
    // Load transactions data for current month by default
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ApiProvider>(context, listen: false).filterTransactionsByMonth('this_month');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  // Handle month toggle
  void _handleMonthToggle(String monthType) async {
    setState(() {
      currentMonthFilter = monthType == 'This Month' ? 'this_month' : 'last_month';
      isLoading = true;
    });

    // Filter transactions based on selected month
    await Provider.of<ApiProvider>(context, listen: false).filterTransactionsByMonth(currentMonthFilter);

    // Hide loading after data is loaded
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Format date from API response
  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dateTime.month - 1]} ${dateTime.day} ${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          scrolledUnderElevation: 0, // Disable elevation change on scroll
          surfaceTintColor: Colors.transparent, // Disable surface tint
          shadowColor: Colors.transparent, // Disable shadow
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32.89,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(53),
                ),
                child: const Center(
                  child: Image(
                    image: AssetImage('assets/new_back_btn.png'),
                    width: 27,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'All',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF626262),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "Transactions",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
        ),
      ),
      body: isLoading
          ? _buildShimmerLoading()
          : Consumer<ApiProvider>(
              builder: (context, apiProvider, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: MonthToggle(
                            isThisMonth: currentMonthFilter == 'this_month',
                            onToggle: _handleMonthToggle,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              'assets/transaction 1 (1).png',
                              width: 35,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Transactions',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.35,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (apiProvider.allTransactions.isEmpty)
                          _buildEmptyState()
                        else
                          ...apiProvider.allTransactions.map((transaction) => TransationItem(transaction: transaction, formatDate: _formatDate)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No transactions found',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Transactions will appear here when available',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Month toggle shimmer
            shimmerBox(width: double.infinity, height: 50),
            const SizedBox(height: 20),
            // Title shimmer
            shimmerBox(width: 150, height: 20),
            const SizedBox(height: 20),
            // Transaction items shimmer
            ...List.generate(
                5,
                (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: shimmerBox(width: double.infinity, height: 80),
                    )),
          ],
        ),
      ),
    );
  }

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

class TransationItem extends StatelessWidget {
  final Transaction transaction;
  final String Function(String) formatDate;

  const TransationItem({
    super.key,
    required this.transaction,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(15),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.all(color: Colors.grey, width: 1)),
                    child: Center(child: Image.asset('assets/Vector (4).png', width: 12))),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Earned Commission', style: TextStyle(color: Color(0xFF1D2730), fontSize: 15, fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            formatDate(transaction.bookingStartDateTime),
                            style: const TextStyle(color: Color(0xFF676767), fontSize: 11, fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                          )),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(
                            'Invoice: ${transaction.invoiceNo}',
                            style: const TextStyle(color: Color(0xFF006EFF), fontSize: 11, fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Asset: ${transaction.assetIdentifier}',
                        style: const TextStyle(color: Color(0xFF676767), fontSize: 10, fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(transaction.ownerProfitAmt != null ? '₹${transaction.ownerProfitAmt!.toStringAsFixed(0)}' : '₹0',
                  style: const TextStyle(color: Color(0xFF2F9623), fontSize: 20, fontFamily: 'Calibri', fontWeight: FontWeight.w700)),
              const Text('Earnings', style: TextStyle(color: Color(0xFF676767), fontSize: 10, fontFamily: 'Montserrat', fontWeight: FontWeight.w400))
            ],
          )
        ],
      ),
      const SizedBox(height: 10),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 2,
          decoration: const ShapeDecoration(color: Color.fromARGB(205, 240, 240, 240), shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1000))))),
      const SizedBox(height: 10)
    ]);
  }
}
