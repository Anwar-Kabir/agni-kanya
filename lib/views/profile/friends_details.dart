import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:woman_safety/controllers/friends_details_controller.dart';
import 'package:woman_safety/widgets/custom_button.dart';

class FriendsDetailsPage extends StatelessWidget {
  final FriendsDetailsController controller =
      Get.put(FriendsDetailsController());

  FriendsDetailsPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends Details'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of family details
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.friendsList.isEmpty) {
                return Column(
                  children: [
                    const Center(child: Text('No friend details available')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Add Friend',
                            style: TextStyle(fontSize: 16)),
                        FloatingActionButton(
                          onPressed: () {
                            _showAddPersonModal(context);
                          },
                          backgroundColor: Colors.yellow,
                          mini: true,
                          child: const Icon(Icons.add, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap:
                        true, // Added to let the ListView wrap its content
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevents ListView from scrolling inside Column
                    itemCount: controller.friendsList.length,
                    itemBuilder: (context, index) {
                      var family = controller.friendsList[index];
                      return Card(
                        child: ListTile(
                          title: Text('Friends ${index + 1}:'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(family['name']),
                              Text('Phone: ${family['phone_number']}'),
                              Text(
                                  'WhatsApp: ${family['whatsapp_number'] ?? 'Not available'}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.lightBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white),
                                  onPressed: () {
                                    _showEditPersonModal(
                                        context, family, index);
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                        context, family['id']);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                      height:
                          10), // Adds some space between the list and the button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Add another Friends',
                          style: TextStyle(fontSize: 16)),
                      FloatingActionButton(
                        onPressed: () {
                          _showAddPersonModal(context);
                        },
                        backgroundColor: Colors.yellow,
                        mini: true,
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  
  // Function to show the bottom sheet for adding a new family member
  void _showAddPersonModal(BuildContext context) {
    String name = '';
    String phoneNumber = '';
    String whatsappNumber = '';
    bool isFriendWhatsapp = false;

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
                    Form(
                     key: _formKey,
                      child: Column(
                        children: [
                          const Text('Add Friends Member',
                              style: TextStyle(fontSize: 18)),
                              TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                            onChanged: (value) {
                              name = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Phone Number'),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            onChanged: (value) {
                              phoneNumber = value;
                            },
                            validator: (value) {
                              final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Phone';
                              } else if (!phoneRegex.hasMatch(value)) {
                                return 'Enter a valid 10-digit phone number';
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: [
                              const Text('Is this your WhatsApp?',
                                  style: TextStyle(fontSize: 16)),
                              const Spacer(),
                              Switch(
                                value: isFriendWhatsapp,
                                activeTrackColor: Colors.yellow,
                                onChanged: (value) {
                                  setModalState(() {
                                    isFriendWhatsapp = value;
                                    if (isFriendWhatsapp) {
                                      // Copy phone number to WhatsApp when toggled on
                                      whatsappNumber = phoneNumber;
                                    } else {
                                      // Clear WhatsApp number when toggled off
                                      whatsappNumber = '';
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'WhatsApp Number'),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            onChanged: (value) {
                              whatsappNumber = value;
                            },
                            validator: (value) {
                              final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Whats App number';
                              } else if (!phoneRegex.hasMatch(value)) {
                                return 'Enter a valid 10-digit phone number';
                              }
                              return null;
                            },
                            enabled: !isFriendWhatsapp,
                            controller: TextEditingController(
                                text: isFriendWhatsapp
                                    ? phoneNumber
                                    : whatsappNumber), // Sync with toggle
                          ),
                          const SizedBox(height: 20),
                          
                          CustomButton(
                              text: "Add Friends",
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await _addFriendsMember(
                                      name, phoneNumber, whatsappNumber);
                                  Navigator.pop(context);
                                }
                              }),
                        ],
                      ),
                    ),
                    
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

  // Function to show the bottom sheet for editing a family member
  void _showEditPersonModal(BuildContext context, dynamic family, int index) {
    String name = family['name'];
    String phoneNumber = family['phone_number'];
    String whatsappNumber = family['whatsapp_number'];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
                const Text('Edit Friends Member',
                    style: TextStyle(fontSize: 18)),
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                  controller: TextEditingController(text: name),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  controller: TextEditingController(text: phoneNumber),
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'WhatsApp Number'),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  onChanged: (value) {
                    whatsappNumber = value;
                  },
                  controller: TextEditingController(text: whatsappNumber),
                ),
                const SizedBox(height: 20),
                 
                CustomButton(
                    text: "Update Friends",
                    onPressed: () async {
                      await _updateFriendsMember(
                          family['id'], name, phoneNumber, whatsappNumber);
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
  }

  // Function to show a confirmation dialog before deleting a family member
  void _showDeleteConfirmationDialog(BuildContext context, int familyId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to delete this friends member?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteFriendsMember(familyId);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Function to add a new family member using the API
  
 //29/09/24
  Future<void> _addFriendsMember(
      String name, String phoneNumber, String whatsappNumber) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      String? userId = prefs.getString('user_id');

      if (token == null || userId == null) {
        Get.snackbar('Error', 'User ID or token not found',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Create the API request
      var response = await http.post(
        Uri.parse('https://test.shuvobhowmik.xyz/api/create-friend'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'phone_number': phoneNumber,
          'whatsapp_number': whatsappNumber,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['message'] == 'success') {
          controller.fetchFriendsDetails(); // Refresh the friends list
          Get.snackbar('Success', 'Friends member added successfully',
              backgroundColor: Colors.green, colorText: Colors.white);
        }
      } else if (response.statusCode == 422) {
        // Handle validation error for 422 status code
        var data = jsonDecode(response.body);
        if (data.containsKey('errors')) {
          String errorMessage = '';
          data['errors'].forEach((key, value) {
            errorMessage += '${value[0]}\n'; // Collect all error messages
          });

          Get.snackbar('Validation Error', errorMessage.trim(),
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          Get.snackbar('Error', 'Failed to add friends member',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to add friends member',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


  // Function to update a family member using the API
  Future<void> _updateFriendsMember(int friendsId, String name,
      String phoneNumber, String whatsappNumber) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        Get.snackbar('Error', 'Token not found',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Create the API request
      var response = await http.put(
        Uri.parse('https://test.shuvobhowmik.xyz/api/update-friend/$friendsId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'phone_number': phoneNumber,
          'whatsapp_number': whatsappNumber,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['message'] == 'success') {
          controller.fetchFriendsDetails(); // Refresh the family list
          Get.snackbar('Success', 'friends member updated successfully',
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.snackbar('Error', 'Failed to update friends member',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to update friends member',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Function to delete a family member using the API
  Future<void> _deleteFriendsMember(int familyId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        Get.snackbar('Error', 'Token not found',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Create the API request
      var response = await http.delete(
        Uri.parse('https://test.shuvobhowmik.xyz/api/delete-friend/$familyId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['message'] == 'Data deleted successfully') {
          controller.fetchFriendsDetails(); // Refresh the family list
          Get.snackbar('Success', 'friends member deleted successfully',
              backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.snackbar('Error', 'Failed to delete friends member',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to delete friends member',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
