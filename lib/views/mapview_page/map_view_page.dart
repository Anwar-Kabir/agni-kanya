import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:woman_safety/controllers/location_controller.dart';
import 'package:woman_safety/controllers/profile_details_controller.dart'; // Import the controller

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = Get.put(LocationController()); // Initialize controller
    
    return Stack(
      children: [
        Obx(() => GoogleMap(
              onMapCreated: locationController.onMapCreated, // Google Map controller
              initialCameraPosition: CameraPosition(
                target: locationController.currentLocation.value, // Initial position
                zoom: 13.0,
              ),
              myLocationEnabled: false, // Enable blue dot for user location
              markers: {
                Marker(
                  markerId: const MarkerId("current_location"),
                  position: locationController.currentLocation.value,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed), // Marker color
                ),
              },
            )),
        // Custom Positioned SOS Button
          Obx((){
            return      locationController.sosButtonColor.value==false?   Positioned(
          left: 20, // Distance from the left edge
          bottom: 120, // Adjusted distance from the bottom edge
          child: GestureDetector(
              onTap: () {
                locationController.nofirend();
              },
              child:
               Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  border: Border.all(
                    color: Colors.pink.shade100,
                    width: 5,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
        ):


        Positioned(
          left: 20, // Distance from the left edge
          bottom: 120, // Adjusted distance from the bottom edge
          child: GestureDetector(
              onTap: () {
                locationController.toggleSos();
              },
              child:locationController.isRipple.value==true?
               RippleAnimation(
            color: Colors.red.withOpacity(0.2),
            delay: const Duration(milliseconds: 300),
            repeat: true,
            minRadius: 75,
            ripplesCount: 6,
            duration: const Duration(milliseconds: 6 * 300),
            child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  border: Border.all(
                    color: Colors.pink.shade100,
                    width: 5,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          )
              :
               Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  border: Border.all(
                    color: Colors.pink.shade100,
                    width: 5,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
        );
          })
      ],
    );
  }
}
