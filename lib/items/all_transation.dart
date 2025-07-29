import 'package:flutter/material.dart';
import 'package:investorapp/customwidgets/custom_toggle.dart';

class AllTransation extends StatelessWidget {
  const AllTransation({super.key});

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
      body: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: MonthToggle(
                    onToggle: (p0) {},
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/transaction 1 (1).png',
                      width: 35,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Transations',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.35,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const TransationItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransationItem extends StatelessWidget {
  const TransationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Container(
                padding: const EdgeInsets.all(15),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.all(color: Colors.grey, width: 1)),
                child: Center(child: Image.asset('assets/Vector (4).png', width: 12))),
            const SizedBox(width: 18),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('10% Earned Commission', style: TextStyle(color: Color(0xFF1D2730), fontSize: 15, fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text('Jul 11 2022, 21:00', style: TextStyle(color: Color(0xFF676767), fontSize: 11, fontFamily: 'Montserrat', fontWeight: FontWeight.w400)),
                    SizedBox(width: 8),
                    Text('O_Id: 56576565577', style: TextStyle(color: Color(0xFF006EFF), fontSize: 11, fontFamily: 'Montserrat', fontWeight: FontWeight.w400))
                  ],
                )
              ],
            )
          ],
        ),
        const Text('₹1000', style: TextStyle(color: Color(0xFF2F9623), fontSize: 20, fontFamily: 'Calibri', fontWeight: FontWeight.w700))
      ]),
      const SizedBox(
        height: 10,
      ),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 2,
          decoration: ShapeDecoration(color: const Color.fromARGB(205, 240, 240, 240), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)))),
      const SizedBox(height: 10)
    ]);
  }
}
