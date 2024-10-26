import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetailsController extends GetxController {
  var userName = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var state = ''.obs;
  var city = ''.obs;
  var zipCode = ''.obs;
  var address = ''.obs;
  var avatarUrl = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchPersonalInfo();
    super.onInit();
  }

  Future<void> fetchPersonalInfo() async {
    print("data is calling................................................");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      //String? userId = prefs.getString('user_id');

      // print(accessToken);
      // print(userId);
      if (accessToken == null) {
        Get.snackbar("Error", "User not logged in or access token missing.",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final url = Uri.parse('hhttps://agnikanya.rudraganga.com/api/personal-info');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Print the raw API response to the terminal for debugging
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['personal_info'] != null) {
          // Assign the API response values to the observables
          userName.value = data['personal_info']['name'] ?? 'Unknown User';
          email.value = data['personal_info']['email'] ?? '';
          phone.value = data['personal_info']['phone'] ?? '';
          state.value = data['personal_info']['state'] ?? '';
          city.value = data['personal_info']['city'] ?? '';
          zipCode.value = data['personal_info']['zip_code'] ?? '';
          address.value = data['personal_info']['address'] ?? '';
          avatarUrl.value = data['personal_info']['avatar'] ?? '';

          await prefs.setString("user_id", data["personal_info"]["id"]);
        } else {
          Get.snackbar("Error", "Profile information missing in API response.",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch personal info.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (error) {
      Get.snackbar("Error", "Error fetching personal info: $error",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
