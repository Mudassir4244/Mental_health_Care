import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mental_healthcare/resources/nearest_practitioner/nearest_doctor_model.dart';
// import '../models/hospital.dart';

class OverpassService {
  static const String apiUrl =
      'https://overpass-api.de/api/interpreter?data=%2F*%0AThis%20is%20an%20example%20Overpass%20query.%0ATry%20it%20out%20by%20pressing%20the%20Run%20button%20above%21%0AYou%20can%20find%20more%20examples%20with%20the%20Load%20tool.%0A*%2F%0A%5Bout%3Ajson%5D%3B%0A%28%0A%20%20node%5B%22amenity%22%3D%22hospital%22%5D%28around%3A70000%2C33.6844%2C73.0479%29%3B%0A%20%20node%5B%22amenity%22%3D%22clinic%22%5D%28around%3A70000%2C33.6844%2C73.0479%29%3B%0A%29%3B%0Aout%20body%3B%0A';

  Future<List<Hospital>> fetchHospitals() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List elements = data['elements'];

      return elements
          .where((e) => e['lat'] != null && e['lon'] != null)
          .map((e) => Hospital.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load hospitals');
    }
  }
}
