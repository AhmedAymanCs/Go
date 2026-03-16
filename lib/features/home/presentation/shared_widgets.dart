import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go/core/constants/color_manager.dart';
import 'package:go/features/home/logic/cubit.dart';
import 'package:go/features/home/logic/states.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(30.101474, 31.240202),
    zoom: 16,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return Scaffold(
          body: GoogleMap(
            style: state.mapStyle,
            markers: state.markers,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) =>
                cubit.onMapCreated(controller),
          ),
        );
      },
    );
  }
}

class PlaceItem extends StatelessWidget {
  final String placeName;
  final VoidCallback onTap;
  const PlaceItem({super.key, required this.placeName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: ColorManager.backgroundLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(title: Text(placeName)),
      ),
    );
  }
}
