// Police Station Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:woman_safety/controllers/location_controller.dart';

class PoliceStationPage extends StatelessWidget {
  const PoliceStationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final polishcontroller = Get.put(LocationController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Nearest Police Station'),
      ),
      // body: ListView.builder(
      //   itemBuilder: const [
      // PoliceStationItem(
      //   title: 'Kilkhet Police Station',
      //   address: '850 Bryant St, Nikunja, Khilkhet, CA 94103',
      //   distance: 0.4,
      //   location: LatLng(23.8103, 90.4125),
      // ),
      //     // PoliceStationItem(
      //     //   title: 'Kilkhet Police Station',
      //     //   address: '850 Bryant St, Nikunja, Khilkhet, CA 94103',
      //     //   distance: 0.4,
      //     //   location: LatLng(23.8103, 90.4125),
      //     // ),
      //     // Add more PoliceStationItem widgets as needed
      //   ],
      // ),
      body: 
      
      const Center(
                      child: Text("Coming soon...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
      
      //this feature will be add on next version ========================<<<<<<<<<<<<<<<<
      // Obx(
      //   () {
      //     return polishcontroller.isLoading.value
      //         ? const Center(
      //             child: CircularProgressIndicator(),
      //           )
      //         : polishcontroller.polishstation.isEmpty
      //             ? const Center(
      //                 child: Text("No Police Station Found"),
      //               )
      //             : ListView.builder(
      //                 itemCount: polishcontroller.polishstation.length,
      //                 itemBuilder: (context, index) {
      //                   return PoliceStationItem(
      //                     title: polishcontroller.polishstation[index].name!,
      //                     address:
      //                         polishcontroller.polishstation[index].address!,
      //                     distance: 3,
      //                     location: LatLng(
      //                         polishcontroller
      //                             .polishstation[index].location!.lat!,
      //                         polishcontroller
      //                             .polishstation[index].location!.lng!),
      //                   );
      //                 });
      //   },
      // ),
    );
  }
}

// Police Station Item Widget
class PoliceStationItem extends StatelessWidget {
  final String title;
  final String address;
  final double distance; // Distance in miles
  final LatLng location; // Location for the map

  const PoliceStationItem({
    super.key,
    required this.title,
    required this.address,
    required this.distance,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              address,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SizedBox(
                height: 150,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: location, zoom: 11),
                  markers: {
                    Marker(
                      markerId: const MarkerId("current_location"),
                      position: location,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed), // Marker color
                    ),
                  },
                ),
                // child: FlutterMap(
                //   options: const MapOptions(
                //     initialCenter:
                //         LatLng(23.8103, 90.4125), // Centering on Dhaka
                //     initialZoom: 13.0,
                //     // Disable map interactions
                //   ),
                //   children: [
                //     TileLayer(
                //       urlTemplate:
                //           "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                //       subdomains: const ['a', 'b', 'c'],
                //     ),
                //     // MarkerLayer(
                //     //   markers: [
                //     //     Marker(
                //     //       width: 80.0,
                //     //       height: 80.0,
                //     //       point: location,
                //     //       builder: (ctx) => const Icon(
                //     //         Icons.location_on,
                //     //         color: Colors.red,
                //     //         size: 40,
                //     //       ),
                //     //     ),
                //     //   ],
                //     // ),
                //   ],
                // ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${distance.toStringAsFixed(1)} mi away',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
