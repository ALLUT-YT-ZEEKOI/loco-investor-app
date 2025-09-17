import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investorapp/extrafunction/reusable.dart';
import 'package:investorapp/provider/api_provider.dart';
import 'package:investorapp/view/login_page.dart';
import 'package:investorapp/view/screens/view_profile_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(children: [
                  Expanded(
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
                              Text(
                                apiProvider.currentUser?.name ?? 'User Name',
                                textScaler: noTextScaler,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Invester since 2025',
                                textScaler: noTextScaler,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                            _showLogoutConfirmation(context, apiProvider);
                          },
                          icon: Image.asset('assets/Power_btn.png', width: 22)))
                ])),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(type: PageTransitionType.rightToLeft, child: const ViewProfileScreen(), duration: const Duration(milliseconds: 300)),
                    );
                  },
                  child: Container(
                      height: 59.09,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1.07, color: const Color(0xFFE8E8E8)),
                      ),
                      child: Row(children: [
                        const ProfileIcon(path: "assets/myProfileImages/profile_icon.png"),
                        const SizedBox(width: 15),
                        const Text(
                          'View Profile',
                          style: TextStyle(fontSize: 15, fontFamily: 'Montserrat', fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Container(
                            width: 70,
                            height: 40,
                            decoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(0.50, -0.00),
                                end: Alignment(0.50, 1.00),
                                colors: [Color(0xFFE7E7E7), Colors.white],
                              ),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 2, color: Colors.white),
                                borderRadius: BorderRadius.circular(56.95),
                              ),
                              shadows: const [
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
                                  Navigator.push(
                                    context,
                                    PageTransition(type: PageTransitionType.rightToLeft, child: const ViewProfileScreen(), duration: const Duration(milliseconds: 300)),
                                  );
                                },
                                icon: Image.asset('assets/myProfileImages/arrow-larrow.png', width: 34, height: 24))),
                      ])),
                ),
                const SizedBox(
                  height: 18,
                ),
                legalSection()
              ],
            ),
          ),
          Positioned(
              bottom: 25,
              left: 5,
              right: 5,
              child: Image.asset(
                'assets/profile_bottom_img.png',
                width: 500,
                fit: BoxFit.contain,
              ))
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, ApiProvider apiProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                apiProvider.logout();
                Get.offAll(const LoginPage());
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Container legalSection() {
  return Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(width: 1.07, color: const Color(0xFFE8E8E8)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            'Legal',
            style: TextStyle(
              fontSize: 15.04,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 7),
        const Divider(color: Color(0xFFD0D0D0), thickness: 1.07),
        const SizedBox(height: 7),
        buildListItem('assets/myProfileImages/terms_condition.png', 'Terms & Conditions'),
        const Divider(color: Color(0xFFD0D0D0), thickness: 1.07),
        buildListItem("assets/myProfileImages/privacy&policy.png", 'Privacy Policy'),
        const Divider(color: Color(0xFFD0D0D0), thickness: 1.07),
        buildListItem('assets/myProfileImages/help_support.png', 'Help & Support'),
      ],
    ),
  );
}

Widget buildListItem(String path, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
    child: Row(
      children: [
        Image.asset(path, width: 25, height: 25, fit: BoxFit.cover),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
