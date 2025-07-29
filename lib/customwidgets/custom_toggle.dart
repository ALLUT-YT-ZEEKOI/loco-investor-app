import 'package:flutter/material.dart';

class MonthToggle extends StatefulWidget {
  final Function(String) onToggle;

  const MonthToggle({super.key, required this.onToggle});

  @override
  State<MonthToggle> createState() => _MonthToggleState();
}

class _MonthToggleState extends State<MonthToggle> {
  bool isThisMonth = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isThisMonth = !isThisMonth;
          widget.onToggle(isThisMonth ? 'This Month' : 'Last Month');
        });
      },
      child: Container(
        width: 174,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF737373), width: 1),
          borderRadius: BorderRadius.circular(41.16),
        ),
        child: Stack(
          children: [
            /// Animated toggle background
            AnimatedAlign(
              alignment: isThisMonth ? Alignment.centerLeft : Alignment.centerRight,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Container(
                width: 87, // Half of 174 to match each section
                height: 30,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(41.16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3529263A),
                      blurRadius: 8.79,
                      offset: Offset(0, 3.19),
                    )
                  ],
                ),
              ),
            ),

            /// Labels
            Row(
              children: [
                /// This Month
                Expanded(
                  child: Center(
                    child: Text(
                      'This Month',
                      style: TextStyle(
                        color: isThisMonth ? Colors.white : Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),

                /// Last Month
                Expanded(
                  child: Center(
                    child: Text(
                      'Last Month',
                      style: TextStyle(
                        color: isThisMonth ? Colors.black : Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
