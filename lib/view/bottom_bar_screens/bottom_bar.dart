import 'package:flutter/material.dart';
import 'package:investorapp/provider/earning_provider.dart';
import 'package:investorapp/view/bottom_bar_screens/home_screen.dart';
import 'package:investorapp/view/bottom_bar_screens/my_earnigns.dart';
import 'package:investorapp/view/bottom_bar_screens/my_deductions.dart';
import 'package:investorapp/view/bottom_bar_screens/my_profile.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  final List<Widget> _pages = const [
    EarningScreen(),
    MyEarnigns(),
    MyDeductions(),
    MyProfile(),
  ];

  final List<Map<String, dynamic>> _navBarItems = [
    {
      'icon': 'assets/bottombar_icons/home_icon (2).png',
      'label': 'Home',
      'color': const Color.fromARGB(255, 255, 165, 15),
    },
    {
      'icon': 'assets/bottombar_icons/earing_icon.png',
      'label': 'Earnings',
      'color': const Color.fromARGB(255, 255, 165, 15),
    },
    {'icon': 'assets/bottombar_icons/dedeuctuons.png', 'label': 'Deductions', 'color': const Color.fromARGB(255, 255, 165, 15)},
    {'icon': 'assets/bottombar_icons/profile_icon.png', 'label': 'Profile', 'color': const Color.fromARGB(255, 255, 165, 15)},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index, EarningProvider provider) {
    if (index != provider.selectedIndex) {
      _bounceController.forward().then((_) {
        _bounceController.reverse();
      });
      provider.setIndex(index);
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<EarningProvider>(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey<int>(bottomNavProvider.selectedIndex),
          child: _pages[bottomNavProvider.selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        height: 85,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C2C2E),
              Color(0xFF1C1C1E),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.black.withOpacity(0.4),
            //   blurRadius: 25,
            //   offset: const Offset(0, -8),
            //   spreadRadius: 0,
            // ),
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navBarItems.length, (index) {
                final isSelected = index == bottomNavProvider.selectedIndex;
                final item = _navBarItems[index];

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabTapped(index, bottomNavProvider),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Clean icon without background
                          AnimatedBuilder(
                            animation: _bounceAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: isSelected ? _bounceAnimation.value : 1.0,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  child: Image.asset(
                                    item['icon'],
                                    width: isSelected ? 26 : 24,
                                    height: isSelected ? 26 : 24,
                                    color: isSelected ? item['color'] : Colors.grey[500],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 2),

                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 350),
                            style: TextStyle(
                              fontSize: isSelected ? 10 : 8,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? item['color'] : Colors.grey[500],
                              fontFamily: 'Montserrat',
                              letterSpacing: isSelected ? 0.2 : 0.0,
                            ),
                            child: Text(
                              item['label'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 1),
                          // Professional animated indicator with smooth curve
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            width: isSelected ? 6 : 0,
                            height: isSelected ? 2 : 0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        item['color'],
                                        item['color'].withOpacity(0.8),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
