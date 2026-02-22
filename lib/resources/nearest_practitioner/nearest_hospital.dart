// import 'package:flutter/material.dart';
// import 'package:mental_healthcare/resources/nearest_practitioner/nearest_doctor_model.dart';
// import 'package:mental_healthcare/resources/nearest_practitioner/nearest_doctors.dart';


// class HospitalListScreen extends StatelessWidget {
//   final OverpassService service = OverpassService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Nearby Hospitals')),
//       body: FutureBuilder<List<Hospital>>(
//         future: service.fetchHospitals(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text(snapshot.error.toString()));
//           }

//           final hospitals = snapshot.data!;

//           return ListView.builder(
//             itemCount: hospitals.length,
//             itemBuilder: (context, index) {
//               final h = hospitals[index];
//               return ListTile(
//                 leading: Icon(
//                   h.type == 'hospital'
//                       ? Icons.local_hospital
//                       : Icons.local_pharmacy,
//                 ),
//                 title: Text(h.name),
//                 subtitle: Text(
//                     'Lat: ${h.lat}, Lon: ${h.lon}'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Hospital {
  final String id;
  final String name;
  final double lat;
  final double lon;
  final String type;

  Hospital({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.type,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'].toString(),
      name: json['tags']?['name'] ?? 'Unknown',
      lat: json['lat'],
      lon: json['lon'],
      type: json['tags']?['amenity'] ?? 'unknown',
    );
  }
}

class OverpassService {
  // 10 km radius around Islamabad (example)
  static const String apiUrl =
      'https://overpass-api.de/api/interpreter?data=[out:json];(node["amenity"="hospital"](around:10000,33.6844,73.0479);node["amenity"="clinic"](around:10000,33.6844,73.0479););out body;';

  Future<List<Hospital>> fetchHospitals() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List elements = data['elements'];
        return elements
            .where((e) => e['lat'] != null && e['lon'] != null)
            .map((e) => Hospital.fromJson(e))
            .toList();
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Overpass API failed: $e");
      return [];
    }
  }
}

// Haversine formula to calculate distance in km
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371; // Earth radius in km
  final dLat = _deg2rad(lat2 - lat1);
  final dLon = _deg2rad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
          sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _deg2rad(double deg) => deg * (pi / 180);

class NearbyHospitalsScreen extends StatefulWidget {
  const NearbyHospitalsScreen({super.key});

  @override
  State<NearbyHospitalsScreen> createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  bool isLoading = true;
  List<Hospital> hospitals = [];
  Position? userLocation;

  @override
  void initState() {
    super.initState();
    loadNearbyHospitals();
  }

  Future<void> loadNearbyHospitals() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 1. Get user location
      userLocation = await _getUserLocation();

      // 2. Fetch hospitals from Overpass
      final allHospitals = await OverpassService().fetchHospitals();

      // 3. Filter by nearby distance (10 km)
      final nearby = allHospitals.where((h) {
        final distance = calculateDistance(
            userLocation!.latitude, userLocation!.longitude, h.lat, h.lon);
        return distance <= 10;
      }).toList();

      // 4. Sort by distance
      nearby.sort((a, b) {
        final distA = calculateDistance(
            userLocation!.latitude, userLocation!.longitude, a.lat, a.lon);
        final distB = calculateDistance(
            userLocation!.latitude, userLocation!.longitude, b.lat, b.lon);
        return distA.compareTo(distB);
      });

      setState(() {
        hospitals = nearby;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading hospitals: $e");
      setState(() {
        hospitals = [];
        isLoading = false;
      });
    }
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Hospitals/Clinics")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hospitals.isEmpty
              ? const Center(child: Text("No nearby hospitals found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: hospitals.length,
                  itemBuilder: (context, index) {
                    final h = hospitals[index];
                    final distance = calculateDistance(
                        userLocation!.latitude,
                        userLocation!.longitude,
                        h.lat,
                        h.lon);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(h.name),
                        subtitle: Text(
                            "${h.type} • ${distance.toStringAsFixed(2)} km away"),
                      ),
                    );
                  },
                ),
    );
  }
}
