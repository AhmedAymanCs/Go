import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final String error;
  final String mapStyle;
  final GoogleMapController? controller;
  final List<Place> places;
  final Set<Marker> markers;
  final Position? position;
  final bool isPermissionGranted;
  final BitmapDescriptor currentLocationIcon;
  final bool hasMoved;
  final Set<Polyline> polylines;
  const HomeState({
    this.status = HomeStatus.initial,
    this.error = '',
    this.controller,
    this.mapStyle = '',
    this.places = const [],
    this.markers = const {},
    this.position,
    this.isPermissionGranted = false,
    this.currentLocationIcon = BitmapDescriptor.defaultMarker,
    this.hasMoved = false,
    this.polylines = const {},
  });
  HomeState copyWith({
    HomeStatus? status,
    String? error,
    GoogleMapController? controller,
    String? mapStyle,
    List<Place>? places,
    Set<Marker>? markers,
    Position? position,
    bool? isPermissionGranted,
    BitmapDescriptor? currentLocationIcon,
    bool? hasMoved,
    Set<Polyline>? polylines,
  }) {
    return HomeState(
      status: status ?? this.status,
      error: error ?? this.error,
      controller: controller ?? this.controller,
      mapStyle: mapStyle ?? this.mapStyle,
      places: places ?? this.places,
      markers: markers ?? this.markers,
      position: position ?? this.position,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      currentLocationIcon: currentLocationIcon ?? this.currentLocationIcon,
      hasMoved: hasMoved ?? this.hasMoved,
      polylines: polylines ?? this.polylines,
    );
  }

  @override
  List<Object?> get props => [
    status,
    error,
    controller,
    mapStyle,
    places,
    markers,
    position,
    isPermissionGranted,
    currentLocationIcon,
    hasMoved,
    polylines,
  ];
}
