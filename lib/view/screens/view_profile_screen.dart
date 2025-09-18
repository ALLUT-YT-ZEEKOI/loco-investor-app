import 'package:flutter/material.dart';
import 'package:investorapp/customwidgets/profile_picture_update.dart';
import 'package:investorapp/extrafunction/reusable.dart';
import 'package:investorapp/items/all_transation.dart';
import 'package:investorapp/provider/api_provider.dart';
import 'package:provider/provider.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load user data after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApiProvider>(context, listen: false).getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          color: Colors.white,
          child: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0, // Disable elevation change on scroll
            surfaceTintColor: Colors.transparent, // Disable surface tint
            shadowColor: Colors.transparent, // Disable shadow
            // systemOverlayStyle: SystemUiOverlayStyle.dark, // Ensures status bar icons are dark
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const SizedBox(
                  width: 32.89,
                  height: 32,
                  child: Center(
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
                  'My',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF626262),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Profile",
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ProfilePictureUpdate(),
                  const SizedBox(height: 12),
                  Text(
                    apiProvider.currentUser!.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Investor since 2025',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Contact Info
            _infoCard(icon: 'assets/call_icon.png', label: 'Phone Number', value: apiProvider.currentUser!.phone),
            const SizedBox(height: 12),
            _infoCard(
              icon: 'assets/mail_icon.png',
              label: 'Email',
              value: apiProvider.currentUser!.email,
            ),

            const SizedBox(height: 16),

            // Bank Info Custom Card
            _bankInfoCard(context),

            const SizedBox(height: 16),

            // Documents Section
            _documentCard(),
          ],
        ),
      ),
    );
  }

  // Custom Bank Info Card
  Widget _bankInfoCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pageNav(context, const AllTransation());
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1.08),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bank Account for Payouts',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/bank_icon.png", color: Colors.black54, width: 28),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank : Federal Bank',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Acc/No : 999XXXXXXXX9650',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset("assets/arrow-left-right.png", color: Colors.black54, width: 28),
                const SizedBox(width: 10),
                const Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Reusable Info Card
  Widget _infoCard({
    required String icon,
    required String label,
    required String value,
    bool multiline = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.08),
      ),
      child: Row(
        crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Image.asset(icon, color: Colors.black54, width: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF525252),
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Document Card Section
  Widget _documentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Documents',
            style: TextStyle(
              fontSize: 15.08,
              fontWeight: FontWeight.w700,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 16),
          _documentRow('Payment Invoice', 'assets/invoice_icon.png'),
          const Divider(thickness: 1.08, color: Color(0xFFD0D0D0)),
          _documentRow('Vehicle Deed', 'assets/legal-document-01.png'),
        ],
      ),
    );
  }

  // Document Row
  Widget _documentRow(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.asset(iconPath, width: 26, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          CircularIconButton(onPressed: () {}, assetPath: 'assets/download_icon.png'),
        ],
      ),
    );
  }
}
