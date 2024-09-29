import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:woman_safety/controllers/login_controller.dart';
import 'package:woman_safety/utils/images.dart';
import 'package:woman_safety/utils/strings.dart';
import 'package:woman_safety/widgets/custom_button.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    AppImages.login2,
                    height: 230,
                    width: 171,
                  ),
                ),
                const SizedBox(height: 150),
                const Text(
                  AppStrings.login,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                const Text(AppStrings.loginPhoneNumber),
                const SizedBox(height: 20),

                IntlPhoneField(
                  showDropdownIcon: false,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    // Extract only the 10-digit phone number
                    String phoneNumber =
                        phone.number; 
                    loginController.phoneController.text = phoneNumber;
                    debugPrint('Phone number: $phoneNumber');
                  },
                ),

               

                const SizedBox(height: 15),

                // Observe the loading state
                Obx(() {
                  return loginController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomButton(
                          text: AppStrings.login,
                          onPressed: () {
                            if (loginController
                                .phoneController.text.isNotEmpty) {
                              loginController
                                  .sendOtp(); // Send OTP when button pressed
                            } else {
                              Get.snackbar(
                                  "Error", "Please enter a valid phone number.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            }
                          },
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
