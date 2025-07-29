import 'package:flutter/material.dart';

PreferredSizeWidget customTitleAppBar(BuildContext context, String titleTop, String titleBottom) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(70),
    child: AppBar(
      elevation: 0, scrolledUnderElevation: 0, // Disable elevation change on scroll
      surfaceTintColor: Colors.transparent, // Disable surface tint
      shadowColor: Colors.transparent, // Disable shadow
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$titleTop\n',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF626262),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: titleBottom,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Divider(
              thickness: 1,
              height: 1,
              color: Colors.grey[300],
              indent: MediaQuery.of(context).size.width * 0.05,
              endIndent: MediaQuery.of(context).size.width * 0.05,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}
