// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:woman_safety/service/api_service.dart';
// import 'package:woman_safety/views/family_contact/family_contact.dart';
// import 'package:woman_safety/views/home/home.dart';
// import 'package:woman_safety/views/opt/opt.dart';
// import 'package:woman_safety/views/personal_info/personal_info.dart';

// class LoginController extends GetxController {
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController otpController = TextEditingController();
//   TextEditingController verificationIdController = TextEditingController();

//   RxBool isLoading = false.obs;

//   // Send OTP API call
//   Future<void> sendOtp() async {
//     // Extract only the last 10 digits (assuming Indian number format)
//     String phone = phoneController.text.replaceAll(RegExp(r'^\+91'), '');
    
//     //https://agnikanya.rudraganga.com/api/
//     final url = Uri.parse('https://agnikanya.rudraganga.com/api/send-otp');
//     Map<String, String> body = {
//       "phone": phone, // Send the phone without the country code
//     };

//     isLoading.value = true;

//     try {
//       debugPrint("Sending OTP to phone: $phone");
//       debugPrint("Request body: $body");

//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(body),
//       );

//       debugPrint("Response status: ${response.statusCode}");
//       debugPrint("Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         debugPrint("OTP sent successfully. Response: $responseData");

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         // Save verificationId as String, not int
//         await prefs.setString(
//             'verificationId', responseData['verificationId'].toString());

//         Get.snackbar("Success", "OTP sent successfully!",
//             backgroundColor: Colors.green, colorText: Colors.white);
//         isLoading.value = false;
//         Get.to(const OTP()); // Navigate to OTP screen
//       } else {
//         final errorResponse = json.decode(response.body);
//         debugPrint("Error response: $errorResponse");

//         isLoading.value = false;
//         Get.snackbar("Error",
//             errorResponse['errors']['phone'][0] ?? "Failed to send OTP.",
//             backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       debugPrint("Unexpected error: $e");
//       isLoading.value = false;
//       Get.snackbar("Error", "An unexpected error occurred: ${e.toString()}",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     }
//   }

//   // Verify OTP API call
//   Future<void> verifyOtp() async {
//     final url = Uri.parse('https://agnikanya.rudraganga.com/api/verify-otp');
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     // Extract the 10-digit phone number
//     String phone = phoneController.text.replaceAll(RegExp(r'^\+91'), '');
//     String otp = otpController.text;
//     // Get verificationId from SharedPreferences
//     String verificationId = prefs.getString('verificationId') ?? '';

//     try {
//       var headers = {
//         'Content-Type': 'application/json'
//       };
//       var request = http.Request('GET', url);
//       request.body = json.encode({
//         "phone": phone,
//         "otp": otp,
//         "verificationId": verificationId
//       });
//       request.headers.addAll(headers);

// //       http.StreamedResponse response = await request.send();
// //       if (response.statusCode == 200) {
// //         final data=await response.stream.bytesToString();
// //         print(data.runtimeType);
// //         final responseData = json.decode(data);
// //         String accessToken = responseData['access_token'];
// //         String refreshToken = responseData['refresh_token'];
// //         print(accessToken);
// //         //
// //         // Save tokens to SharedPreferences
// //         await prefs.setString('access_token', accessToken);
// //         await prefs.setString('refresh_token', refreshToken);
// // final personaldata=await Apiservice.fetchPersonalInfo();
// //         Get.snackbar("Success", "OTP verified successfully!", backgroundColor: Colors.green, colorText: Colors.white);
// //         final infodata=await Apiservice.getFriendFamilyDetails();
// //         if(personaldata == true){
// //           Get.offAll(() => const PersonalInfo());
// //         }else if(infodata==true){
// //           Get.offAll(() => const Home());
// //         }else if (infodata == false){
// //           Get.offAll(()=>const FamilyContact());
// //         }

//              http.StreamedResponse response = await request.send();
//       print(response.statusCode);
//       if (response.statusCode == 200) {
//         final data = await response.stream.bytesToString();
//         print(data.runtimeType);
//         final responseData = json.decode(data);
//         String accessToken = responseData['access_token'];
//         String refreshToken = responseData['refresh_token'];
//         print(accessToken);
//         //

//         // Save tokens to SharedPreferences
//         await prefs.setString('access_token', accessToken);
//         await prefs.setString('refresh_token', refreshToken);

//         final personaldata = await Apiservice.fetchPersonalInfo();

//       }
//       else {
//         Get.snackbar("Error", "Failed to verify OTP.",
//             backgroundColor: Colors.red, colorText: Colors.white);
//       }

       
//     } catch (error) {
//       print(error);
//       Get.snackbar("Error", error.toString());
//     }
//   }

// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woman_safety/service/api_service.dart';
import 'package:woman_safety/views/family_contact/family_contact.dart';
import 'package:woman_safety/views/home/home.dart';
import 'package:woman_safety/views/opt/opt.dart';
import 'package:woman_safety/views/personal_info/personal_info.dart';

class LoginController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController verificationIdController = TextEditingController();

  RxBool isLoading = false.obs;

  // Send OTP API call
  Future<void> sendOtp() async {
    // Extract only the last 10 digits (assuming Indian number format)
    String phone = phoneController.text.replaceAll(RegExp(r'^\+91'), '');

    final url = Uri.parse('https://agnikanya.rudraganga.com/api/send-otp');
    Map<String, String> body = {
      "phone": phone, // Send the phone without the country code
    };

    isLoading.value = true;

    try {
      debugPrint("Sending OTP to phone: $phone");
      debugPrint("Request body: $body");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint("OTP sent successfully. Response: $responseData");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Save verificationId as String, not int
        await prefs.setString(
            'verificationId', responseData['verificationId'].toString());

        Get.snackbar("Success", "OTP sent successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
        isLoading.value = false;

        Get.to(const OTP()); // Navigate to OTP screen
      } else {
        final errorResponse = json.decode(response.body);
        debugPrint("Error response: $errorResponse");

        isLoading.value = false;

        Get.snackbar("Error",
            errorResponse['errors']['phone'][0] ?? "Failed to send OTP.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Unexpected error: $e");
      isLoading.value = false;
      Get.snackbar("Error", "An unexpected error occurred: ${e.toString()}",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Verify OTP API call
  Future<void> verifyOtp() async {
    final url = Uri.parse('https://agnikanya.rudraganga.com/api/verify-otp');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Extract the 10-digit phone number
    String phone = phoneController.text.replaceAll(RegExp(r'^\+91'), '');
    String otp = otpController.text;
    // Get verificationId from SharedPreferences
    String verificationId = prefs.getString('verificationId') ?? '';

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('GET', url);
      request.body = json.encode(
          {"phone": phone, "otp": otp, "verificationId": verificationId});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        print(data.runtimeType);
        final responseData = json.decode(data);
        String accessToken = responseData['access_token'];
        String refreshToken = responseData['refresh_token'];
        print(accessToken);
        //

        // Save tokens to SharedPreferences
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        final personaldata = await Apiservice.fetchPersonalInfo();
        Get.snackbar("Success", "OTP verified successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
        final infodata = await Apiservice.getFriendFamilyDetails();
        if (personaldata == true) {
          Get.offAll(() => const PersonalInfo());
        } else if (infodata == true) {
          Get.offAll(() => const Home());
        } else if (infodata == false) {
          Get.offAll(() => const FamilyContact());
        }
      } else {
        Get.snackbar("Error", "Failed to verify OTP.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (error) {
      print(error);
      Get.snackbar("Error", error.toString());
    }
  }
}
