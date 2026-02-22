class Hospital {
  final String id;
  final String name;
  final double lat;
  final double lon;
  final String type; // hospital / clinic

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
