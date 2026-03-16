import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final String error;
  final String mapStyle;
  final GoogleMapController? controller;
  const HomeState({
    this.status = HomeStatus.initial,
    this.error = '',
    this.controller,
    this.mapStyle = '',
  });
  HomeState copyWith({
    HomeStatus? status,
    String? error,
    GoogleMapController? controller,
    String? mapStyle,
  }) {
    return HomeState(
      status: status ?? this.status,
      error: error ?? this.error,
      controller: controller ?? this.controller,
      mapStyle: mapStyle ?? this.mapStyle,
    );
  }

  @override
  List<Object?> get props => [status, error, controller, mapStyle];
}
