import 'package:get/get.dart';

class PermissionController extends GetxController {
  // Reactive boolean variables for switches
  var familyCallPermission = true.obs;
  var friendsCallPermission = true.obs;
  var policeCallPermission = true.obs;

  var familyMessagePermission = true.obs;
  var friendsMessagePermission = true.obs;
  var policeMessagePermission = true.obs;

  // You can also add methods if you want to perform any specific logic
  void toggleFamilyCallPermission() {
    familyCallPermission.value = !familyCallPermission.value;
  }

  void toggleFriendsCallPermission() {
    friendsCallPermission.value = !friendsCallPermission.value;
  }

  void togglePoliceCallPermission() {
    policeCallPermission.value = !policeCallPermission.value;
  }

  void toggleFamilyMessagePermission() {
    familyMessagePermission.value = !familyMessagePermission.value;
  }

  void toggleFriendsMessagePermission() {
    friendsMessagePermission.value = !friendsMessagePermission.value;
  }

  void togglePoliceMessagePermission() {
    policeMessagePermission.value = !policeMessagePermission.value;
  }
}
