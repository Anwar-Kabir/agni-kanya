import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woman_safety/controllers/login_controller.dart';
import 'package:woman_safety/utils/colors.dart';
import 'package:woman_safety/utils/images.dart';
import 'package:woman_safety/utils/strings.dart';
import 'package:woman_safety/widgets/custom_button.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final loginController = Get.put(LoginController());

  static const int maxTime = 60; // 1 minute in seconds
  int _start = maxTime;
  Timer? _timer;
  bool isResendVisible =
      false; // Controls the visibility of the Resend OTP button

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = maxTime; // Reset timer
    isResendVisible = false; // Hide resend button initially
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          isResendVisible = true; // Show resend button when timer ends
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String phoneNumber = loginController.phoneController.text;
    String timerText =
        "${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}";

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.otpImage,
                    height: 235,
                    width: 229,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    AppStrings.otpVerification,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  // Display dynamic phone number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.otpyourotp,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "+91 $phoneNumber",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // OTP input field
                  TextField(
                    controller: loginController.otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter OTP',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 4, // Assuming the OTP length is 4 digits
                  ),

                  const SizedBox(height: 10),

                  // Verify OTP button
                  CustomButton(
                    text: AppStrings.otpVerify,
                    onPressed: () {
                      loginController.verifyOtp();
                    },
                  ),

                  const SizedBox(height: 10),

                  // Display timer
                  Text(
                    "Resend OTP in $timerText",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.appTextGrayColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Resend OTP button, only visible after the timer ends
                  if (isResendVisible)
                    TextButton(
                      onPressed: () {
                        // Resend OTP logic
                        loginController.sendOtp();
                        startTimer(); // Restart the timer after resending OTP
                      },
                      child:   const Text(
                        AppStrings.otpResend,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
