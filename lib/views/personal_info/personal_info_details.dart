
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woman_safety/controllers/profile_details_controller.dart';
import 'package:woman_safety/utils/images.dart';
import 'package:woman_safety/views/personal_info/edit_profile.dart';
import 'package:woman_safety/widgets/custom_button.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileDetailsController controller =
        Get.put(ProfileDetailsController());
    controller.fetchPersonalInfo();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile Details'),
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

                    const SizedBox(height: 15.0),

                    CustomButton(
                      onPressed: () {
                        Get.to(() => const EditProfilePage());
                      },
                      text: "Edit Profile",
                      icon: Icons.edit,
                    ),

                    const SizedBox(height: 15.0),
                    Card(
                      child: ListTile(
                        title: Text("Email: ${controller.email.value}"),
                        leading: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      child: ListTile(
                        title: Text("Phone: ${controller.phone.value}"),
                        leading: const Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      child: ListTile(
                        title: Text("State: ${controller.state.value}"),
                        leading: const Icon(Icons.location_city),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      child: ListTile(
                        title: Text("City: ${controller.city.value}"),
                        leading: const Icon(Icons.location_city),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      child: ListTile(
                        title: Text("Zip Code: ${controller.zipCode.value}"),
                        leading: const Icon(Icons.code),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      child: ListTile(
                        title: Text("Address: ${controller.address.value}"),
                        leading: const Icon(Icons.home),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Edit Profile Button

                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
