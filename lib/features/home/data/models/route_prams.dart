import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutePrams {
  final LatLng position;
  final LatLng destination;
  final String placeName;
  const RoutePrams({
    required this.position,
    required this.destination,
    required this.placeName,
  });
}
