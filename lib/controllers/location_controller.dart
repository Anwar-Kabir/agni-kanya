import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:woman_safety/models/polish_model.dart';
import 'package:woman_safety/service/api_service.dart';

class LocationController extends GetxController {
  Rx<LatLng> currentLocation = const LatLng(22.572645, 88.363892).obs;  
  RxBool isSosActive = false.obs;  
  late GoogleMapController mapController;
  Timer? _timer;  
  var isLoading=false.obs;

  var isRipple=false.obs;
  RxList<NearestPoliceStations> polishstation=<NearestPoliceStations>[].obs;
  var sosButtonColor=false.obs;
  @override
  void onInit() {
    super.onInit();
    checkSosButton();
    _startUpdatingLocation();
    
    //getFriendFamilyDetails();
  }

  checkSosButton()async{

    log("i am soso button ");
    if(await Apiservice.getFriendFamilyDetails()==true){
      print("button color mill giya");
      sosButtonColor.value=true;
    }
  }

  Future<void> _startUpdatingLocation() async {
    SharedPreferences sh=await SharedPreferences.getInstance();
    print( await sh.get('access_token'));
    await _determinePosition(); // Ensure permissions are granted and fetch initial location

    // Periodically update location in real-time
    Stream<Position> positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    positionStream.listen((Position position) {
      currentLocation.value = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(currentLocation.value));
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings(); 
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentLocation.value = LatLng(position.latitude, position.longitude);
  }
void nofirend()async{
  Get.snackbar("No Friends and Familly", "Please Add Your Friends & Familly",colorText: Colors.white,backgroundColor: Colors.red,snackPosition: SnackPosition.TOP,duration: Duration(seconds: 1));
}
  // SOS button toggling logic
  void toggleSos()async {
    if (isSosActive.value) {
      isRipple.value=false;
      // If SOS is already active, stop it
      stopSos();
    } else {
      isRipple.value=true;
      // If SOS is not active, start it
     startSos();
    }
  }

  void startSos() {
    Get.snackbar("SOS", "Status Running",colorText: Colors.white,backgroundColor: Colors.green,snackPosition: SnackPosition.TOP,duration: Duration(seconds: 1));
    isSosActive.value = true;
    _sendLocationToApi(); // Send the first location immediately

    // Schedule API calls every 1 minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      print(timer);
      _sendLocationToApi();
    });
  }

  void stopSos() {
    isSosActive.value = false;
     Get.snackbar("SOS", "Status Off",colorText: Colors.white,backgroundColor: Colors.green,snackPosition: SnackPosition.TOP,duration: Duration(seconds: 1));
    // Cancel the timer if it's running
    if (_timer != null) {
      _timer!.cancel();
      // _timer = null;
    }
  }

  Future<void> _sendLocationToApi() async {
    isLoading.value=true;
    const apiUrl = 'https://test.shuvobhowmik.xyz/api/find-location';

    // Prepare the request body
    final body = json.encode({
      'latitude': currentLocation.value.latitude.toString(),
      //'latitude': "23.6794968",
     'longitude': currentLocation.value.longitude.toString(),
      // 'longitude': "90.4251845",
    });

    try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
     //String accessToken="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3Rlc3Quc2h1dm9iaG93bWlrLnh5ei9hcGkvdmVyaWZ5LW90cCIsImlhdCI6MTcyNjg2NzIzMCwiZXhwIjoxNzQyNDE5MjMwLCJuYmYiOjE3MjY4NjcyMzAsImp0aSI6IktmeENHTURBSWp6VFBlbDciLCJzdWIiOiI5ZDBiYWM3Ny02MDRmLTQ5ZGItYWJlMi1hMmFjNTMxYmI3MDEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.ngpbCfZu4TtWsBsEp1WrcdCDcsMVStEwjPFYn0eCADo";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json",'Authorization': 'Bearer $accessToken',},
        body: body,
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data=PolishModel.fromJson(jsonDecode(response.body));
        polishstation.value=data.nearestPoliceStations!;
        isLoading.value=false;
        print('Location sent successfully');
      } else {
        print('Failed to send location. Status code: $response');
        isLoading.value=false;
      }
    } catch (e) {
      print('Error sending location: $e');
      isLoading.value=false;
    }
  }

  // Handle map creation
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
