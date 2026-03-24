import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go/core/constants/app_constants.dart';
import 'package:go/core/constants/color_manager.dart';
import 'package:go/core/constants/image_manager.dart';
import 'package:go/core/constants/styles_manager.dart';
import 'package:go/core/constants/trip_keywords.dart';
import 'package:go/features/home/data/models/order_model.dart';
import 'package:go/features/home/data/models/route_prams.dart';
import 'package:go/features/home/data/repository/repo.dart';
import 'package:go/features/home/logic/states.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  final FlutterSecureStorage _secureStorage;
  HomeCubit(this._homeRepository, this._secureStorage) : super(HomeState());

  StreamSubscription<Position>? _positionStream;
  StreamSubscription<OrderModel>? _orderStream;

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
    await _loadLocationIcon();
    await getCurrentStreamLocation();
  }

  void moveTo(
    LatLng destination, {
    bool isCurrentLocation = false,
    double zoom = 16,
  }) {
    state.controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: destination, zoom: zoom),
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
      ...state.markers,
      Marker(markerId: const MarkerId('destination'), position: latLng),
    };
    emit(state.copyWith(markers: markers));
  }

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty || query.length < 3) {
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

  Future<void> _loadLocationIcon() async {
    final currentLocationIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(28, 28), devicePixelRatio: 2.0),
      ImageManager.currentLocation,
    );
    final carIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(28, 28), devicePixelRatio: 2.0),
      ImageManager.car,
    );
    emit(
      state.copyWith(
        currentLocationIcon: currentLocationIcon,
        carIcon: carIcon,
      ),
    );
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
        anchor: const Offset(0.5, 0.5),
      ),
    };
    emit(state.copyWith(markers: updatedMarkers));
  }

  Future<void> drawRoute(
    LatLng destination, {
    required String placeName,
  }) async {
    if (state.position == null) return;
    emit(state.copyWith(polylines: {}));
    moveTo(destination, zoom: 12);
    final res = await _homeRepository.getRouteCoordinates(
      RoutePrams(
        destination: destination,
        position: LatLng(state.position!.latitude, state.position!.longitude),
        placeName: placeName,
      ),
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

  Future<String> reverseGeocoding(LatLng position) async {
    final res = await _homeRepository.reverseGeocoding(position);
    return res.fold((error) {
      emit(state.copyWith(error: error, status: HomeStatus.error));
      return 'Unknown';
    }, (placeName) => placeName);
  }

  Future<void> createOrder(OrderModel order) async {
    final userSession = await _secureStorage.read(
      key: AppConstants.userSession,
    );
    final updatedOrder = order.copyWith(
      passengerName: jsonDecode(userSession!)['name'],
      passengerPhone: jsonDecode(userSession)['phone'],
    );
    final res = await _homeRepository.createOrder(updatedOrder);
    res.fold(
      (error) {
        emit(state.copyWith(error: error, status: HomeStatus.error));
      },
      (orderId) {
        final orderWithId = updatedOrder.copyWith(id: orderId);
        emit(
          state.copyWith(tripStatus: TripStatus.searching, order: orderWithId),
        );
        listenToOrder(orderId);
      },
    );
  }

  Future<void> cancelOrder() async {
    if (state.order?.id == null) return;
    emit(state.copyWith(status: HomeStatus.loading));
    _orderStream?.cancel();
    emit(state.copyWith(tripStatus: TripStatus.cancelled));
    final res = await _homeRepository.cancelOrder(state.order!.id!);
    res.fold(
      (error) => emit(state.copyWith(error: error, status: HomeStatus.error)),
      (_) {
        emit(state.copyWith(clearOrder: true, tripStatus: TripStatus.idle));
      },
    );
  }

  Future<void> listenToOrder(String orderId) async {
    final res = await _homeRepository.listenToOrder(orderId);
    bool retry = true;

    res.fold(
      (error) => emit(state.copyWith(error: error, status: HomeStatus.error)),
      (stream) {
        _orderStream = stream.listen((order) {
          if (order.status == TripKeywords.accepted &&
              order.driverLat != null &&
              order.driverLng != null) {
            emit(state.copyWith(tripStatus: TripStatus.accepted, order: order));
            _updateDriverMarker(
              LatLng(order.driverLat!, order.driverLng!),
              order.driverHeading,
            );
          } else if (order.status == TripKeywords.driverArrived) {
            emit(state.copyWith(tripStatus: TripStatus.arrived, order: order));
            _updateDriverMarker(
              LatLng(order.driverLat!, order.driverLng!),
              order.driverHeading,
            );
          } else if (order.status == TripKeywords.inProgress) {
            if (retry) {
              emit(
                state.copyWith(
                  tripStatus: TripStatus.inProgress,
                  order: order,
                  markers: {state.markers.first},
                ),
              );
              retry = false;
            }
          } else if (order.status == TripKeywords.ended) {
            emit(
              state.copyWith(
                tripStatus: TripStatus.cancelled,
                order: order,
                polylines: {},
                markers: {state.markers.last},
              ),
            );
            _orderStream?.cancel();
          }
        });
      },
    );
  }

  void _updateDriverMarker(LatLng driverLocation, double? driverHeading) {
    final updatedMarkers = {
      ...state.markers.where((m) => m.markerId.value != 'driver'),
      Marker(
        markerId: const MarkerId('driver'),
        position: driverLocation,
        icon: state.carIcon ?? BitmapDescriptor.defaultMarker,
        rotation: driverHeading ?? 0,
        flat: true,
      ),
    };
    emit(state.copyWith(markers: updatedMarkers));
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    _orderStream?.cancel();
    return super.close();
  }
}
