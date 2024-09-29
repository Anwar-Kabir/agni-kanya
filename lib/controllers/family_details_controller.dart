import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FamilyDetailsController extends GetxController {
  RxList familyList = [].obs;
  var isLoading = true.obs;

  

  @override
  void onInit() {
    fetchFamilyDetails();
    super.onInit();
  }

  Future<void> fetchFamilyDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      String? accessToken = prefs.getString('access_token');

      if (userId == null || accessToken == null) {
        Get.snackbar("Error", "User ID or Access token missing", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final url =
          Uri.parse('https://test.shuvobhowmik.xyz/api/find-family/$userId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          familyList.assignAll(
              data['data']); // Store the family details in the observable list
        } else {
          Get.snackbar("Error", "No family data found", backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch family details", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (error) {
      Get.snackbar("Error", "Error fetching family details: $error", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
