import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

const noTextScaler = TextScaler.noScaling;

// font Style
const TextStyle totalEarning = TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w500);
const TextStyle totalEarningamt = TextStyle(color: Color(0xFF2F9623), fontSize: 30, fontWeight: FontWeight.w700);
const TextStyle totalEarningamtred = TextStyle(color: Color(0xFFD7443E), fontSize: 30, fontWeight: FontWeight.w700);

// media quary width
double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// navigateWithSlide
void navigateWithFade(BuildContext context, Widget page) {
  Navigator.of(context).push(PageTransition(child: page, type: PageTransitionType.fade));
}

void PageNav(BuildContext context, Widget destination) {
  Navigator.of(context).push(PageTransition(child: destination, type: PageTransitionType.fade));
}

//  profile icon reusable
class ProfileIcon extends StatelessWidget {
  final String path;
  final double width;
  final double? height;
  final BoxFit fit;

  const ProfileIcon({super.key, required this.path, this.width = 25, this.height, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, width: width, height: height, fit: fit);
  }
}

class CircularIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String assetPath;
  final double size;
  final double iconSize;

  const CircularIconButton({
    super.key,
    required this.onPressed,
    required this.assetPath,
    this.size = 50,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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
        onPressed: onPressed,
        icon: Image.asset(assetPath, width: iconSize),
      ),
    );
  }
}
