import 'package:flutter/material.dart';
import 'package:investorapp/provider/earning_provider.dart';
import 'package:investorapp/view/bottom_bar_screens/home_screen.dart';
import 'package:investorapp/view/bottom_bar_screens/my_earnigns.dart';
import 'package:investorapp/view/bottom_bar_screens/my_deductions.dart';
import 'package:investorapp/view/bottom_bar_screens/my_profile.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  BottomBar({super.key});

  final List<Widget> _pages = const [
    EarningScreen(),
    MyEarnigns(),
    MyDeductions(),
    MyProfile(),
  ];

  final List<BottomNavigationBarItem> _navBarItems = [
    const BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/bottombar_icons/home_icon (2).png'), color: Colors.white),
      activeIcon: ImageIcon(AssetImage('assets/bottombar_icons/home_icon (2).png'), color: Colors.orange),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/bottombar_icons/earing_icon.png'), color: Colors.white),
      activeIcon: ImageIcon(AssetImage('assets/bottombar_icons/earing_icon.png'), color: Colors.orange),
      label: 'Earnings',
    ),
    const BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/bottombar_icons/dedeuctuons.png'), color: Colors.white),
      activeIcon: ImageIcon(AssetImage('assets/bottombar_icons/dedeuctuons.png'), color: Colors.orange),
      label: 'Deductions',
    ),
    const BottomNavigationBarItem(
      icon: ImageIcon(AssetImage('assets/bottombar_icons/profile_icon.png'), color: Colors.white),
      activeIcon: ImageIcon(AssetImage('assets/bottombar_icons/profile_icon.png'), color: Colors.orange),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<EarningProvider>(context);

    return Scaffold(
      body: _pages[bottomNavProvider.selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          height: 80,
          color: Colors.black,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              items: _navBarItems,
              currentIndex: bottomNavProvider.selectedIndex,
              onTap: (index) {
                bottomNavProvider.setIndex(index);
              },
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              iconSize: 28,
              selectedLabelStyle: const TextStyle(fontSize: 11, height: 1.5),
              unselectedLabelStyle: const TextStyle(fontSize: 11, height: 1.5),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
