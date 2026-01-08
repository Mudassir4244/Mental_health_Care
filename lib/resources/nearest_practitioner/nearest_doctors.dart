// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;

// class NearestHospitalsScreen extends StatefulWidget {
//   const NearestHospitalsScreen({super.key});

//   @override
//   _NearestHospitalsScreenState createState() => _NearestHospitalsScreenState();
// }

// class _NearestHospitalsScreenState extends State<NearestHospitalsScreen> {
//   bool loading = true;
//   List hospitals = [];
//   double? userLat;
//   double? userLng;

//   @override
//   void initState() {
//     super.initState();
//     fetchNearestHospitals();
//   }

//   Future<void> fetchNearestHospitals() async {
//     try {
//       await Geolocator.requestPermission();
//       Position pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       userLat = pos.latitude;
//       userLng = pos.longitude;

//       print("USER LOCATION: $userLat, $userLng");

//       await getHospitalsFromGoogle(userLat!, userLng!);
//     } catch (e) {
//       print("Error: $e");
//       setState(() => loading = false);
//     }
//   }

//   Future<void> getHospitalsFromGoogle(double lat, double lng) async {
//     String apiKey = "YOUR_GOOGLE_API_KEY"; // <-- Replace with your key

//     String url =
//         "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
//         "?location=$lat,$lng"
//         "&radius=20000" // 20 km
//         "&type=hospital"
//         "&key=$apiKey";

//     print("REQUEST URL: $url");

//     final response = await http.get(Uri.parse(url));
//     final data = jsonDecode(response.body);

//     print("API RESPONSE ===> ${data["results"].length} hospitals found");

//     setState(() {
//       hospitals = data["results"];
//       loading = false;
//     });
//   }

//   double getDistanceKm(double lat, double lng) {
//     return Geolocator.distanceBetween(userLat!, userLng!, lat, lng) / 1000;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Nearest Hospitals")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : hospitals.isEmpty
//               ? const Center(child: Text("No hospitals found nearby"))
//               : ListView.builder(
//                   itemCount: hospitals.length,
//                   itemBuilder: (context, index) {
//                     var hospital = hospitals[index];

//                     double lat = hospital["geometry"]["location"]["lat"];
//                     double lng = hospital["geometry"]["location"]["lng"];
//                     double distance = getDistanceKm(lat, lng);

//                     String name = hospital["name"] ?? "Unknown Hospital";
//                     String address = hospital["vicinity"] ?? "No address";

//                     return Card(
//                       elevation: 3,
//                       margin: const EdgeInsets.all(10),
//                       child: ListTile(
//                         leading: const Icon(
//                           Icons.local_hospital,
//                           color: Colors.red,
//                           size: 35,
//                         ),
//                         title: Text(name),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(address),
//                             Text(
//                               "${distance.toStringAsFixed(2)} km away",
//                               style: TextStyle(color: Colors.blueGrey.shade600),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class NearestHospitalsScreen extends StatefulWidget {
  const NearestHospitalsScreen({super.key});

  @override
  _NearestHospitalsScreenState createState() => _NearestHospitalsScreenState();
}

class _NearestHospitalsScreenState extends State<NearestHospitalsScreen> {
  bool loading = true;
  List hospitals = [];
  double? userLat;
  double? userLng;

  @override
  void initState() {
    super.initState();
    fetchUserLocationAndHospitals();
  }

  Future<void> fetchUserLocationAndHospitals() async {
    try {
      // Request location permission
      await Geolocator.requestPermission();

      // Get current position
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userLat = pos.latitude;
      userLng = pos.longitude;

      print("User Location: $userLat, $userLng");

      // Load JSON file
      String jsonString = await rootBundle.loadString('assets/hospitals.json');
      print("JSON Loaded: $jsonString"); // Debug print

      List jsonList = jsonDecode(jsonString);

      // Calculate distance for each hospital
      for (var hospital in jsonList) {
        double lat = hospital["lat"];
        double lng = hospital["lng"];
        hospital["distance"] =
            Geolocator.distanceBetween(userLat!, userLng!, lat, lng) /
            1000; // km
      }

      // Sort by nearest
      jsonList.sort((a, b) => a["distance"].compareTo(b["distance"]));

      setState(() {
        hospitals = jsonList;
        loading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearest Hospitals")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : hospitals.isEmpty
          ? const Center(child: Text("No hospitals found nearby"))
          : ListView.builder(
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                var hospital = hospitals[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(
                      Icons.local_hospital,
                      color: Colors.red,
                      size: 35,
                    ),
                    title: Text(hospital["name"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hospital["address"]),
                        Text(
                          "${hospital["distance"].toStringAsFixed(2)} km away",
                          style: TextStyle(color: Colors.blueGrey.shade600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
