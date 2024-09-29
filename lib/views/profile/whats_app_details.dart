import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woman_safety/controllers/family_controller.dart';
import 'package:woman_safety/controllers/whats_app_details_controller.dart';
import 'package:woman_safety/widgets/custom_button.dart';

class WhatsAppDetailsPage extends StatelessWidget {
  final WhatsAppDetailsController controller = Get.put(WhatsAppDetailsController());

    WhatsAppDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whats App Details'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // if (controller.whatsappNumber.isEmpty) {
        //   return Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       children: [
        //         const Center(child: Text('No WhatsApp details available')),
        //          Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             const Text('Add Whats app group link', style: TextStyle(fontSize: 16)),
        //             FloatingActionButton(
        //               onPressed: () {
        //                 _showAddwhatsaAppGroupModal(context);
        //               },
        //               backgroundColor: Colors.yellow,
        //               mini: true,
        //               child: const Icon(Icons.add, color: Colors.black),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   );
        // }

        return Column(
          children: [
          controller.whatsappNumber.isEmpty?const SizedBox.shrink():  Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: ListTile(
                  title: const Text('WhatsApp Number'),
                  subtitle: Text(controller.whatsappNumber.value),
                ),
              ),
            ),
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
               controller.whatsappNumber.isEmpty? const Center(child: Text('No WhatsApp details available')):const Text(""),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add Whats app group link', style: TextStyle(fontSize: 16)),
                    FloatingActionButton(
                      onPressed: () {
                        _showAddwhatsaAppGroupModal(context);
                      },
                      backgroundColor: Colors.yellow,
                      mini: true,
                      child: const Icon(Icons.add, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          )
          ],
        );
      }),
    );
  }
  
  void _showAddwhatsaAppGroupModal(BuildContext context) {
    String whatsAppnGroupLink = '';
     
    final infocontroller=Get.find<WhatsAppDetailsController>();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, // Adjusts for keyboard
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Add Whats app group link',
                        style: TextStyle(fontSize: 18)),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Whats app group link'),
                      onChanged: (value) {
                        whatsAppnGroupLink = value;
                      },
                    ),
                     
                     
                     
                    const SizedBox(height: 20),
                     
                    CustomButton(
                        text: "Add Whats app group link",
                        onPressed: () async {
                       
                         infocontroller.createWhatsAppGroupLinks(whatsAppnGroupLink);
                          
                          Navigator.pop(context); // Close the bottom sheet
                        }),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  // Future<void> createWhatsAppGroupLink() async {
  //   String groupLink = whatsAppGroupLink.text;

  //   if (groupLink.isNotEmpty) {
  //     final url = Uri.parse('https://test.shuvobhowmik.xyz/api/whatsapp');
  //     final userid = await _getUserId();
  //     final body = {'whatsapp_number': groupLink, 'user_id': userid};

  //     try {
  //       final token = await getAccessToken();
  //       final response = await http.post(
  //         url,
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token'
  //         },
  //         body: jsonEncode(body),
  //       );

  //       if (response.statusCode == 200) {
  //         final data = jsonDecode(response.body);
  //         if (data['message'] == 'Group link created') {
  //           // isWhatsAppGrouplinkCreated = true;
  //           isWhatsAppGrouplinkCreated.value = true;
  //           Get.snackbar('Success', 'WhatsApp group link created successfully',
  //               backgroundColor: Colors.green, colorText: Colors.white);

  //           // Navigate to home screen after success
            
  //         } else {
  //           Get.snackbar('Error', 'Failed to create WhatsApp group link',
  //               backgroundColor: Colors.red, colorText: Colors.white);
  //           debugPrint("API Response Error: ${data['message']}");
  //         }
  //       } else {
  //         Get.snackbar('Error', 'Failed to create WhatsApp group link',
  //             backgroundColor: Colors.red, colorText: Colors.white);
  //         debugPrint(
  //             "API Response Error: Status Code ${response.statusCode}, Response: ${response.body}");
  //       }
  //     } catch (e) {
  //       Get.snackbar(
  //           'Error', 'An error occurred while creating WhatsApp group link',
  //           backgroundColor: Colors.red, colorText: Colors.white);
  //       debugPrint("API Response Error: Exception occurred - $e");
  //     }
  //   } else {
  //     Get.snackbar('Error', 'WhatsApp group link is required',
  //         backgroundColor: Colors.red, colorText: Colors.white);
  //     debugPrint("Error: WhatsApp group link is required");
  //   }
  // }

}
