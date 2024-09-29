import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:woman_safety/controllers/sos_customize_controller.dart';

class SosCustomize extends StatelessWidget {
  SosCustomize({super.key});

  final PermissionController permissionController =
      Get.put(PermissionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SOS Customize"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Call Permissions Section
              const Text(
                'Call',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Obx(() => buildPermissionToggle(
                    title: 'Family',
                    subtitle: 'Give call permission to family',
                    icon: const Icon(
                      Icons.family_restroom,
                      color: Colors.black,
                    ),
                    value: permissionController.familyCallPermission.value,
                    onChanged: (newValue) {
                      permissionController.familyCallPermission.value =
                          newValue;
                    },
                  )),
              Obx(() => buildPermissionToggle(
                    title: 'Friend\'s',
                    subtitle: 'Give call permission to friend\'s',
                    icon: const Icon(Icons.diversity_3),
                    value: permissionController.friendsCallPermission.value,
                    onChanged: (newValue) {
                      permissionController.friendsCallPermission.value =
                          newValue;
                    },
                  )),
              Obx(() => buildPermissionToggle(
                    title: 'Police',
                    subtitle: 'Give call permission to police',
                    icon: const Icon(Icons.local_police),
                    value: permissionController.policeCallPermission.value,
                    onChanged: (newValue) {
                      permissionController.policeCallPermission.value =
                          newValue;
                    },
                  )),
            
              const SizedBox(height: 24),
            
              // Message Permissions Section
              const Text(
                'Message',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Obx(() => buildPermissionToggle(
                    title: 'Family',
                    subtitle: 'Give Massage permission to family',
                    icon: const Icon(Icons.family_restroom),
                    value: permissionController.familyMessagePermission.value,
                    onChanged: (newValue) {
                      permissionController.familyMessagePermission.value =
                          newValue;
                    },
                  )),
              Obx(() => buildPermissionToggle(
                    title: 'Friend\'s',
                    subtitle: 'Give Massage permission to friend\'s',
                    icon: const Icon(Icons.diversity_3),
                    value: permissionController.friendsMessagePermission.value,
                    onChanged: (newValue) {
                      permissionController.friendsMessagePermission.value =
                          newValue;
                    },
                  )),
              Obx(() => buildPermissionToggle(
                    title: 'Police',
                    subtitle: 'Give Massage permission to police',
                    icon: const Icon(Icons.local_police),
                    value: permissionController.policeMessagePermission.value,
                    onChanged: (newValue) {
                      permissionController.policeMessagePermission.value =
                          newValue;
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build a permission toggle
  Widget buildPermissionToggle({
    required String title,
    required String subtitle,
    required Widget icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      leading: CircleAvatar(
          backgroundColor:
              const Color(0xffD1C4E9), // You can change the color as needed
          child: icon),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: Colors.yellow,
      ),
    );
  }
}



 