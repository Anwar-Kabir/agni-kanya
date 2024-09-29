import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woman_safety/controllers/profile_controller.dart';
import 'package:woman_safety/utils/images.dart';
import 'package:woman_safety/views/login/login.dart';
import 'package:woman_safety/views/personal_info/personal_info_details.dart';
import 'package:woman_safety/views/profile/family_deatils.dart';
import 'package:woman_safety/views/profile/friends_details.dart';
import 'package:woman_safety/views/profile/sos_customize.dart';
import 'package:woman_safety/views/profile/whats_app_details.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

   final bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    controller.fetchProfileInfo();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('My Profile'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    Center(
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.green[100],
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.yellow,
                          backgroundImage: controller.avatarUrl.isNotEmpty
                              ? NetworkImage(controller.avatarUrl.value)
                              : const AssetImage(AppImages.personallogo)
                                  as ImageProvider,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Center(
                      child: Text(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value
                            : 'Unknown User',
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      child: ListTile(
                        title: const Text("Personal Info"),
                        leading: const Icon(Icons.info),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Get.to(const ProfileDetailsPage());
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      child: ListTile(
                        title: const Text("SOS Customize"),
                        leading: const Icon(Icons.fact_check),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Get.to(  SosCustomize());
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      child: ListTile(
                        title: const Text("Family Info"),
                        leading: const Icon(Icons.family_restroom),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Get.to(FamilyDetailsPage());
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      child: ListTile(
                        title: const Text("Friends Info"),
                        leading: const Icon(Icons.diversity_3),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Get.to(FriendsDetailsPage());
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Card(
                      child: ListTile(
                        title: const Text("Whats App Info"),
                        leading: const Icon(Icons.call),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Get.to(WhatsAppDetailsPage());
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                     Card(
                      child: ListTile(
                        title: const Text("Log out"),
                        leading: const Icon(Icons.logout),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          _showLogoutDialog();
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      child: ListTile(
                        title: const Text("Delete Account"),
                        leading: const Icon(Icons.delete),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () async {
                          // Show the alert dialog
                          _showDeleteDialog( );
                           
                        },
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
 
   void _showDeleteDialog() {
    RxBool isDeleting = false.obs;

    Get.dialog(
      Obx(
        () => AlertDialog(
          title: const Text("Delete Account"),
          content: isDeleting.value
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 16),
                    //Text("Processing..."),
                  ],
                )
              : const Text("Are you sure you want to delete your account?"),
          actions: isDeleting.value
              ? [] // Disable buttons while processing
              : [
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Start showing the progress indicator
                      isDeleting.value = true;

                      // Wait for 2 seconds to simulate processing
                      await Future.delayed(const Duration(seconds: 2));

                      // Simulate the deletion process by removing the token
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('access_token');

                      // After deleting the token, navigate to the login page with a smooth transition
                      Get.offAll(() => const Login(),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 500));

                      // Optionally show success message
                      Get.snackbar(
                        'Success',
                        'Account deleted successfully',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );

                      // Close the dialog after success
                      Get.back();
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    RxBool isDeleting = false.obs;

    Get.dialog(
      Obx(
        () => AlertDialog(
          title: const Text("Logout"),
          content: isDeleting.value
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 16),
                    //Text("Processing..."),
                  ],
                )
              : const Text("Are you sure you want to Logout?"),
          actions: isDeleting.value
              ? [] // Disable buttons while processing
              : [
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Start showing the progress indicator
                      isDeleting.value = true;

                      // Wait for 2 seconds to simulate processing
                      await Future.delayed(const Duration(seconds: 2));

                      // Simulate the deletion process by removing the token
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('access_token');

                      // After deleting the token, navigate to the login page with a smooth transition
                      Get.offAll(() => const Login(),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 500));

                      // Optionally show success message
                      Get.snackbar(
                        'Success',
                        'Account Logout successfully',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );

                      // Close the dialog after success
                      Get.back();
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
        ),
      ),
    );
  }

}


