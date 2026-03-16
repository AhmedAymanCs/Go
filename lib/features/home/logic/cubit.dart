import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go/core/constants/styles_manager.dart';
import 'package:go/features/home/data/models/destnation_model.dart';
import 'package:go/features/home/data/repository/repo.dart';
import 'package:go/features/home/logic/states.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  HomeCubit(this._homeRepository) : super(HomeState());

  void init(BuildContext context) async {
    final mapStyle = await setMapStyle(context);
    emit(state.copyWith(mapStyle: mapStyle));
  }

  void onMapCreated(GoogleMapController controller) async {
    emit(state.copyWith(controller: controller));
  }

  void moveTo(DestinationModel destination) {
    state.controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(destination.lat, destination.lon),
          zoom: 16,
        ),
      ),
    );
  }

  Future<String> setMapStyle(BuildContext context) async {
    return await DefaultAssetBundle.of(
      context,
    ).loadString(StylesManager.mapStyles);
  }

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(places: []));
    } else {
      final res = await _homeRepository.searchPlaces(query);
      res.fold(
        (error) => emit(state.copyWith(error: error)),
        (places) => emit(state.copyWith(places: places)),
      );
    }
  }
}
