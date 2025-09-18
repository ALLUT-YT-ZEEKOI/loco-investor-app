import 'package:flutter/material.dart';
import 'package:investorapp/provider/api_provider.dart';
import 'package:investorapp/view/bottom_bar_screens/bottom_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otpCode = '';
  bool isLoading = false;

  void verifyOtp() async {
    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a 6-digit OTP")),
      );
      return;
    }

    setState(() => isLoading = true);

    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    final result = await apiProvider.submitOtp(otpCode);

    setState(() => isLoading = false);

    result.fold((success) {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const BottomBar(),
            duration: const Duration(milliseconds: 300)),
        (route) => false,
      );
    }, (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFA50F),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Verify your number',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter OTP received on Whatsapp',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 32),

            const Text('ENTER THE 6 DIGIT OTP',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // ✅ OTP Input Field
            PinCodeTextField(
              appContext: context,
              length: 6,
              autoFocus: true,
              cursorColor: Colors.black,
              obscureText: false,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: size.width * 0.15,
                fieldWidth: size.width * 0.12,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveColor: Colors.white,
                activeColor: Colors.white,
                selectedColor: Colors.white,
              ),
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              onChanged: (value) {
                otpCode = value;
              },
            ),

            const SizedBox(height: 12),

            const Text(
              'Resend in 58 seconds',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),

            const Spacer(),

            // ✅ Verify Button with loading
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading ? null : verifyOtp,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                    : const Text('Verify',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                'By verifying OTP, you agree to our Terms & Conditions',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
