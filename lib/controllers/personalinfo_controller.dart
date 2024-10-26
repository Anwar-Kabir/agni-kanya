 

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woman_safety/views/family_contact/family_contact.dart';
import 'package:woman_safety/views/personal_info/personal_info.dart';
import 'package:woman_safety/views/personal_info/personal_info_details.dart';

class PersonalinfoController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final zipeController = TextEditingController();
  final addressController = TextEditingController();

  var avaterlink = "".obs;

  var isCustomZipCode = false.obs; // Observable for switch state
  //final TextEditingController zipController = TextEditingController();

  //final cityNameController = TextEditingController();

  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;

  var isLoading = false.obs; // Add loading state

  Future<void> submitPersonalInfo(String imagePath, {String? pageNmae}) async {
    isLoading.value = true; // Set loading to true when API call starts
    final url = Uri.parse('https://agnikanya.rudraganga.com/api/personal-info');
   //final url = Uri.parse('https://test.shuvobhowmik.xyz/api/personal-info');


    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        isLoading.value = false; // Stop loading
        Get.snackbar("Error", "Access token not found. Please log in again.",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      var request = http.MultipartRequest('POST', url);

      // Add text fields
      request.fields['name'] = nameController.text;
      request.fields['email'] = emailController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['state'] = selectedState.value;
      request.fields['city'] = selectedCity.value;
      request.fields['zip_code'] = zipeController.text;
      request.fields['address'] = addressController.text;

      print(request.fields.toString());
      // Add image file if present
      if (imagePath.isNotEmpty) {
        var imageFile = await http.MultipartFile.fromPath('avatar', imagePath);
        request.files.add(imageFile);
      }

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        final jsonResponse = json.decode(responseData.body);

        // Save user ID in SharedPreferences
        String userId = jsonResponse['user']['id'];
        await prefs.setString('user_id', userId);

        isLoading.value = false;
        Get.snackbar("Success", jsonResponse['message'],
            backgroundColor: Colors.green, colorText: Colors.white);
        if (pageNmae == "editprofile") {
          Get.off(const ProfileDetailsPage());
        } else {
          Get.to(const FamilyContact());
        }
      } else if (response.statusCode == 422){
          // Handle validation errors
        var responseData = await http.Response.fromStream(response);
        final jsonResponse = json.decode(responseData.body);

        // Check if 'errors' field exists and display specific error messages
        if (jsonResponse.containsKey('errors')) {
          var errors = jsonResponse['errors'];
          String errorMessage = '';
          errors.forEach((key, value) {
            errorMessage += '${value[0]}\n'; // Collect all error messages
          });

          Get.snackbar("Validation Error", errorMessage.trim(),
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          Get.snackbar("Error", "Failed to update information.",
              backgroundColor: Colors.red, colorText: Colors.white);
        }

        isLoading.value = false;
      }
      else {
        isLoading.value = false;
        print("Failed with status code: ${response.statusCode}");
        final responseData = await http.Response.fromStream(response);
        print("Response body: ${responseData.body}");
        Get.snackbar("Error", "Failed to update information.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (error) {
      isLoading.value = false;
      print("Error occurred: $error");
      Get.snackbar("Error", error.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
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

      final url = Uri.parse('https://agnikanya.rudraganga.com/api/personal-info');
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
          nameController.text = data['personal_info']['name'] ?? 'Unknown User';
          emailController.text = data['personal_info']['email'] ?? '';
          phoneController.text = data['personal_info']['phone'] ?? '';
          // selectedState.value = data['personal_info']['state'] ?? '';
          // selectedCity.value= data['personal_info']['city'] ?? '';
         // zipeController.text = data['personal_info']['zip_code'] ?? '';
          addressController.text = data['personal_info']['address'] ?? '';
          avaterlink.value = data['personal_info']['avatar'] ?? '';

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
