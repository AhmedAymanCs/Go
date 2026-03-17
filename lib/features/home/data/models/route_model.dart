import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  final String placeName;
  final List<LatLng> points;
  final double distanceKm;
  final double durationMin;
  final double price;
  const RouteModel({
    required this.points,
    required this.distanceKm,
    required this.durationMin,
    required this.placeName,
    required this.price,
  });

  String get formattedDuration {
    final hours = (durationMin / 60).floor();
    final minutes = (durationMin % 60).floor();
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '$minutes min';
  }
}
