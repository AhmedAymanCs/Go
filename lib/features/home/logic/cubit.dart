import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go/core/constants/styles_manager.dart';
import 'package:go/features/home/logic/states.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void init(BuildContext context) async {
    final mapStyle = await setMapStyle(context);
    emit(state.copyWith(mapStyle: mapStyle));
  }

  void onMapCreated(GoogleMapController controller) async {
    emit(state.copyWith(controller: controller));
  }

  void moveTo() {
    state.controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(30.101474, 31.240202), zoom: 16),
      ),
    );
  }

  Future<String> setMapStyle(BuildContext context) async {
    return await DefaultAssetBundle.of(
      context,
    ).loadString(StylesManager.mapStyles);
  }
}
