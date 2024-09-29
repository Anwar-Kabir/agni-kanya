

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woman_safety/service/api_service.dart';
import 'package:woman_safety/views/family_contact/family_contact.dart';
import 'package:woman_safety/views/home/home.dart';
import 'package:woman_safety/views/login/login.dart';
import 'package:woman_safety/views/personal_info/personal_info.dart';

class SplashController extends GetxController {
  var textOpacity = 0.0.obs;
  var imageOpacity = 0.0.obs;
  var indicatorOpacity = 0.0.obs;

  void splashToLoginOrHome() async {
    final personaldata = await Apiservice.fetchPersonalInfo();
    // Animate the text opacity
    await Future.delayed(const Duration(milliseconds: 500), () {
      textOpacity.value = 1.0;
    });

    // Animate the image opacity
    await Future.delayed(const Duration(milliseconds: 500), () {
      imageOpacity.value = 1.0;
    });

    // Animate the circular progress indicator
    await Future.delayed(const Duration(milliseconds: 500), () {
      indicatorOpacity.value = 1.0;
    });

    //Get.offAll(() => const Login());

    // Check for saved token in SharedPreferences
    await Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      final response = await Apiservice.getFriendFamilyDetails();
      print("data is here : $response");
      if (accessToken != null) {
        // If token exists, go to Home page
        if (personaldata == true ) {
          Get.offAll(() => const PersonalInfo());
        } else if (response == true) {
          Get.offAll(() => const Home());
        } else if (response == false) {
          Get.offAll(() => const FamilyContact());
        }
      } else {
        // If no token, go to Login page
        Get.offAll(() => const Login());
      }
    });
  }
}
