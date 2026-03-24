import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go/features/home/data/models/order_model.dart';
import 'package:go/features/home/data/models/route_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

enum HomeStatus { initial, loading, success, error }

enum TripStatus { idle, searching, accepted, inProgress, arrived, cancelled }

class HomeState extends Equatable {
  final HomeStatus status;
  final TripStatus tripStatus;
  final String error;
  final String mapStyle;
  final GoogleMapController? controller;
  final List<Place> places;
  final Set<Marker> markers;
  final Position? position;
  final bool isPermissionGranted;
  final BitmapDescriptor currentLocationIcon;
  final BitmapDescriptor? carIcon;
  final bool hasMoved;
  final Set<Polyline> polylines;
  final RouteModel? route;
  final OrderModel? order;
  const HomeState({
    this.status = HomeStatus.initial,
    this.tripStatus = TripStatus.idle,
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
    this.route,
    this.carIcon,
    this.order,
  });
  HomeState copyWith({
    HomeStatus? status,
    TripStatus? tripStatus,
    String? error,
    GoogleMapController? controller,
    String? mapStyle,
    List<Place>? places,
    Set<Marker>? markers,
    Position? position,
    bool? isPermissionGranted,
    BitmapDescriptor? currentLocationIcon,
    BitmapDescriptor? carIcon,
    bool? hasMoved,
    Set<Polyline>? polylines,
    RouteModel? route,
    OrderModel? order,
    bool clearOrder = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      tripStatus: tripStatus ?? this.tripStatus,
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
      route: clearOrder ? null : (route ?? this.route),
      order: clearOrder ? null : (order ?? this.order),
      carIcon: carIcon ?? this.carIcon,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tripStatus,
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
    route,
    order,
    carIcon,
  ];
}
