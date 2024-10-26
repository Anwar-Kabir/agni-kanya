import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woman_safety/views/home/home.dart';

class FamilyController extends GetxController {
  var familyNameController = TextEditingController();
  var familyPhoneController = TextEditingController();
  var familyWhatsAppController = TextEditingController();

  var friendNameController = TextEditingController();
  var friendPhoneController = TextEditingController();
  var friendWhatsAppController = TextEditingController();

  var whatsAppGroupLink = TextEditingController();

  var isFamilyCreated = false.obs;
  var isFriendsCreated = false.obs;
  var isWhatsAppGrouplinkCreated = false.obs;
  var isWhatsAppUpdated = false.obs;

  bool isWhatsapp = false;

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
 

 //create family

  Future<void> createFamily() async {
    String name = familyNameController.text;
    String phone = familyPhoneController.text;
    String whatsapp = familyWhatsAppController.text;

    if (name.isNotEmpty && phone.isNotEmpty && whatsapp.isNotEmpty) {
      final url = Uri.parse('https://agnikanya.rudraganga.com/api/create-family');

      //final url = Uri.parse('https://agnikanya.rudraganga.com/api/create-family');


      final userid = await _getUserId();

      final body = {
        'name': name,
        'phone_number': phone,
        'whatsapp_number': whatsapp,
        'user_id': userid
      };

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
          if (data['message'] == 'success') {
            isFamilyCreated.value = true;
            Get.snackbar('Success', 'Family contact created successfully',
                backgroundColor: Colors.green, colorText: Colors.white);
            debugPrint(
                "API Response Success: Family contact created successfully. Response: ${response.body}");
          } else {
            Get.snackbar('Error', 'Failed to create family contact',
                backgroundColor: Colors.red, colorText: Colors.white);
            debugPrint("API Response Error: ${data['message']}");
          }
        } else {
          Get.snackbar('Error', 'Failed to create family contact',
              backgroundColor: Colors.red, colorText: Colors.white);
          debugPrint(
              "API Response Error: Status Code ${response.statusCode}, Response: ${response.body}");
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred while creating family contact',
            backgroundColor: Colors.red, colorText: Colors.white);
        debugPrint("API Response Error: Exception occurred - $e");
      }
    } else {
      Get.snackbar('Error', 'All fields are required',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint("Error: All fields are required");
    }
  }
 

 //create friends
  Future<void> createFriends() async {
    String name = friendNameController.text;
    String phone = friendPhoneController.text;
    String whatsapp = friendWhatsAppController.text;

    if (name.isNotEmpty && phone.isNotEmpty) {
      final url = Uri.parse('https://agnikanya.rudraganga.com/api/create-friend');
      final userid = await _getUserId();
      final body = {
        'name': name,
        'phone_number': phone,
        'whatsapp_number': whatsapp,
        'user_id': userid
      };

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
          if (data['message'] == 'success') {
            isFriendsCreated.value = true;
            Get.snackbar('Success', 'Friend contact created successfully',
                backgroundColor: Colors.green, colorText: Colors.white);
            debugPrint(
                "API Response Success: Friend contact created successfully. Response: ${response.body}");
            //await updateWhatsApp();
          } else {
            Get.snackbar('Error', 'Failed to create friend contact',
                backgroundColor: Colors.red, colorText: Colors.white);
            debugPrint("API Response Error: ${data['message']}");
          }
        } else {
          Get.snackbar('Error', 'Failed to create friend contact',
              backgroundColor: Colors.red, colorText: Colors.white);
          debugPrint(
              "API Response Error: Status Code ${response.statusCode}, Response: ${response.body}");
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred while creating friend contact',
            backgroundColor: Colors.red, colorText: Colors.white);
        debugPrint("API Response Error: Exception occurred - $e");
      }
    } else {
      Get.snackbar('Error', 'All fields are required',
          backgroundColor: Colors.red, colorText: Colors.white);
      debugPrint("Error: All fields are required");
    }
  }



  //create whats app group
    Future<void> createWhatsAppGroupLink() async {
    String groupLink = whatsAppGroupLink.text;

    if (groupLink.isNotEmpty) {
      final url = Uri.parse('https://agnikanya.rudraganga.com/api/whatsapp');
      final userid = await _getUserId();
      final body = {'whatsapp_number': groupLink, 'user_id': userid};

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
          if (data['message'] == 'Group link created') {
            // isWhatsAppGrouplinkCreated = true;
            isWhatsAppGrouplinkCreated.value = true;
            Get.snackbar('Success', 'WhatsApp group link created successfully',
                backgroundColor: Colors.green, colorText: Colors.white);

            // Navigate to home screen after success
            Get.offAll(() => const Home());
          } else {
            Get.snackbar('Error', 'Failed to create WhatsApp group link',
                backgroundColor: Colors.red, colorText: Colors.white);
            debugPrint("API Response Error: ${data['message']}");
          }
        } else {
          Get.snackbar('Error', 'Failed to create WhatsApp group link',
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


  @override
  void onClose() {
    familyNameController.dispose();
    familyPhoneController.dispose();
    familyWhatsAppController.dispose();

    friendNameController.dispose();
    friendPhoneController.dispose();
    friendWhatsAppController.dispose();

    super.onClose();
  }
}
