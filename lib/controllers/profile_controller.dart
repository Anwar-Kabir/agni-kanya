 


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var userName = ''.obs;
  var avatarUrl = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchProfileInfo();
    super.onInit();
  }

  Future<void> fetchProfileInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      String? userId = prefs.getString('user_id');

      if (accessToken == null || userId == null) {
        Get.snackbar("Error", "User not logged in or access token missing.", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final url = Uri.parse('https://test.shuvobhowmik.xyz/api/personal-info');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Print the raw API response to the terminal
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['personal_info'] != null) {
          // Assign the values only if they exist
          userName.value = data['personal_info']['name'] ?? 'Unknown User';
          avatarUrl.value = data['personal_info']['avatar'] ?? '';
        } else {
          Get.snackbar("Error", "Profile information missing in API response.", backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch profile info.", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (error) {
      Get.snackbar("Error", "Error fetching profile info: $error",
      backgroundColor: Colors.red, colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }
}
