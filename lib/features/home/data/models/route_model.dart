import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  final List<LatLng> points;
  final double distanceKm;
  final double durationMin;

  const RouteModel({
    required this.points,
    required this.distanceKm,
    required this.durationMin,
  });
}
