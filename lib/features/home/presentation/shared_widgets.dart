import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go/features/home/logic/cubit.dart';
import 'package:go/features/home/logic/states.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => MapSampleState();
}

class MapSampleState extends State<Map> {
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
          floatingActionButton: FloatingActionButton(
            onPressed: () => cubit.moveTo(),
          ),
          body: GoogleMap(
            style: state.mapStyle,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) =>
                cubit.onMapCreated(controller),
          ),
        );
      },
    );
  }
}
