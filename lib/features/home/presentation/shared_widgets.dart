import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go/core/constants/color_manager.dart';
import 'package:go/features/home/data/models/route_model.dart';
import 'package:go/features/home/logic/cubit.dart';
import 'package:go/features/home/logic/states.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return Scaffold(
          body: GoogleMap(
            buildingsEnabled: false,
            mapType: MapType.normal,
            style: state.mapStyle,
            markers: state.markers,
            polylines: state.polylines,
            initialCameraPosition: CameraPosition(
              target: state.position != null
                  ? LatLng(state.position!.latitude, state.position!.longitude)
                  : const LatLng(30.0444, 31.2357),
              zoom: 16,
            ),
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

class RouteItem extends StatelessWidget {
  final RouteModel route;
  const RouteItem({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorManager.gray200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorManager.greenSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.location_on,
              color: ColorManager.greenAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route.placeName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.straighten,
                      size: 12,
                      color: ColorManager.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${route.distanceKm.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ColorManager.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: ColorManager.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      route.formattedDuration,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ColorManager.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${route.price.toStringAsFixed(0)} EGP',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: ColorManager.greenAccent,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: ColorManager.gray500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
