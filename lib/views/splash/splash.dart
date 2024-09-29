import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:woman_safety/controllers/personalinfo_controller.dart';
import 'package:woman_safety/controllers/profile_details_controller.dart';
import 'package:woman_safety/controllers/splash_controller.dart';
import 'package:woman_safety/utils/colors.dart';
import 'package:woman_safety/utils/images.dart';
import 'package:woman_safety/utils/strings.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final splashController = Get.put(SplashController());

  @override
  void initState() {
    //splashController.splashToLogin();
     splashController.splashToLoginOrHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: AppColor.appSplashScreenBG,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => AnimatedOpacity(
                opacity: splashController.textOpacity.value,
                duration: const Duration(seconds: 1),
                child: const Text(
                  AppStrings.splashScreenIntro,
                  style: TextStyle(
                    color: AppColor.appPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Obx(
              () => AnimatedOpacity(
                opacity: splashController.imageOpacity.value,
                duration: const Duration(seconds: 1),
                child: Image.asset(
                  AppImages.splash2,
                  height: 353,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Obx(
              () => AnimatedOpacity(
                opacity: splashController.indicatorOpacity.value,
                duration: const Duration(seconds: 1),
                child: const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
