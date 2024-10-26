import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WhatsAppDetailsController extends GetxController {
  RxString whatsappNumber = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchWhatsAppDetails();
    super.onInit();
  }

  Future<void> fetchWhatsAppDetails() async {
    print("data is calling . form whats app");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        Get.snackbar("Error", "Access token missing",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final url = Uri.parse('https://agnikanya.rudraganga.com/api/find-whatsapp');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print("WhatsApp API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final whatsappData = data['data'];

        if (whatsappData != null && whatsappData['whatsapp_group_link'] != null) {
          whatsappNumber.value = whatsappData['whatsapp_group_link'];
        } else {
          Get.snackbar("Error", "WhatsApp number not available",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch WhatsApp details",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (error) {
      Get.snackbar("Error", "Error fetching WhatsApp details: $error",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
    Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

      Future<void> createWhatsAppGroupLinks(link) async {
    String groupLink = link;

    if (groupLink.isNotEmpty) {
      final url = Uri.parse('https://agnikanya.rudraganga.com/api/whatsapp');
      final body = {'whatsapp_group_link': groupLink};
      log(jsonEncode(body));
      try {
        final token = await getAccessToken();
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
                      Get.snackbar('Success', 'WhatsApp group link created successfully',
                backgroundColor: Colors.green, colorText: Colors.white);

            // Navigate to home screen after success
            fetchWhatsAppDetails();
        } else {
          Get.snackbar('Error', 'Formate invalid',
              backgroundColor: Colors.red, colorText: Colors.white);
          debugPrint(
              "API Response Error: Status Code ${response.statusCode}, Response: ${response.body}");
        }
      } catch (e) {
        Get.snackbar(
            'Error', 'An error occurred while creating WhatsApp group link',
            backgroundColor: Colors.red, colorText: Colors.white);
        debugPrint("API Response Error: Exception occurred - $e");
      }
    } else {
      Get.snackbar('Error', 'WhatsApp group link is required',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint("Error: WhatsApp group link is required");
    }
  }
}
