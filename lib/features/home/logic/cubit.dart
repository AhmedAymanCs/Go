import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go/core/constants/color_manager.dart';
import 'package:go/core/constants/image_manager.dart';
import 'package:go/core/constants/styles_manager.dart';
import 'package:go/features/home/data/repository/repo.dart';
import 'package:go/features/home/logic/states.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  HomeCubit(this._homeRepository) : super(HomeState());

  StreamSubscription<Position>? _positionStream;

  void init(BuildContext context) async {
    final mapStyle = await setMapStyle(context);
    emit(state.copyWith(mapStyle: mapStyle));
  }

  Future<String> setMapStyle(BuildContext context) async {
    return await DefaultAssetBundle.of(
      context,
    ).loadString(StylesManager.mapStyles);
  }

  void onMapCreated(GoogleMapController controller) async {
    emit(state.copyWith(controller: controller));
    await _loadCurrentLocationIcon();
    await getCurrentStreamLocation();
  }

  void moveTo(LatLng destination, {bool isCurrentLocation = false}) {
    state.controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: destination, zoom: 16),
      ),
    );
    if (isCurrentLocation) {
      _updateMarker();
    } else {
      addMarker(destination);
    }
  }

  void addMarker(LatLng latLng) {
    final markers = {
      Marker(markerId: const MarkerId('destination'), position: latLng),
    };
    emit(state.copyWith(markers: markers));
  }

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(places: []));
    } else {
      final res = await _homeRepository.searchPlaces(query);
      res.fold(
        (error) => emit(state.copyWith(error: error, status: HomeStatus.error)),
        (places) =>
            emit(state.copyWith(places: places, status: HomeStatus.success)),
      );
    }
  }

  Future<void> _checkPermission() async {
    final PermissionStatus permission = await Permission.location.request();
    if (permission == PermissionStatus.granted) {
      emit(state.copyWith(isPermissionGranted: true));
    } else {
      emit(state.copyWith(isPermissionGranted: false));
    }
  }

  Future<void> getCurrentStreamLocation() async {
    await _checkPermission();
    if (state.isPermissionGranted) {
      _positionStream = Geolocator.getPositionStream().listen((position) {
        final bool alreadyMoved = state.hasMoved;
        emit(state.copyWith(position: position, hasMoved: true));
        _updateMarker();
        if (!alreadyMoved) {
          state.controller?.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          );
        }
      });
    }
  }

  Future<void> _loadCurrentLocationIcon() async {
    final icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(60, 60)),
      ImageManager.currentLocation,
    );
    emit(state.copyWith(currentLocationIcon: icon));
  }

  void _updateMarker() {
    if (state.position == null) return;

    final latLng = LatLng(state.position!.latitude, state.position!.longitude);

    final updatedMarkers = {
      ...state.markers,
      Marker(
        markerId: const MarkerId('current_location'),
        position: latLng,
        icon: state.currentLocationIcon,
      ),
    };

    emit(state.copyWith(markers: updatedMarkers));
  }

  Future<void> drawRoute(LatLng destination) async {
    if (state.position == null) return;

    final res = await _homeRepository.getRouteCoordinates(
      destination: destination,
      position: LatLng(state.position!.latitude, state.position!.longitude),
    );
    res.fold(
      (error) => emit(state.copyWith(error: error)),
      (coordinates) => emit(
        state.copyWith(
          polylines: {
            Polyline(
              polylineId: const PolylineId('route'),
              points: coordinates.points,
              color: ColorManager.greenAccent,
              width: 5,
            ),
          },
          route: coordinates,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    return super.close();
  }
}
