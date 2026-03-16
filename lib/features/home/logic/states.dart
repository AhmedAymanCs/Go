import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final String error;
  final String mapStyle;
  final GoogleMapController? controller;
  final List<Place> places;
  const HomeState({
    this.status = HomeStatus.initial,
    this.error = '',
    this.controller,
    this.mapStyle = '',
    this.places = const [],
  });
  HomeState copyWith({
    HomeStatus? status,
    String? error,
    GoogleMapController? controller,
    String? mapStyle,
    List<Place>? places,
  }) {
    return HomeState(
      status: status ?? this.status,
      error: error ?? this.error,
      controller: controller ?? this.controller,
      mapStyle: mapStyle ?? this.mapStyle,
      places: places ?? this.places,
    );
  }

  @override
  List<Object?> get props => [status, error, controller, mapStyle, places];
}
