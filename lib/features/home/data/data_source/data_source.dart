import 'package:go/core/utils/typedef.dart';
import 'package:go/features/home/data/models/route_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

abstract class HomeDataSource {
  Places searchPlaces(String query);
  Future<RouteModel> getRouteCoordinates({
    required LatLng destination,
    required LatLng position,
  });
}

class HomeDataSourceImpl implements HomeDataSource {
  final Nominatim _nominatim;
  final OpenRouteService _ors;
  HomeDataSourceImpl(this._nominatim, this._ors);

  @override
  Places searchPlaces(String query) async {
    return _nominatim.searchByName(
      query: query,
      limit: 5,
      countryCodes: ['eg'],
    );
  }

  @override
  Future<RouteModel> getRouteCoordinates({
    required LatLng destination,
    required LatLng position,
  }) async {
    final response = await _ors.directionsRouteGeoJsonGet(
      startCoordinate: ORSCoordinate(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
      endCoordinate: ORSCoordinate(
        latitude: destination.latitude,
        longitude: destination.longitude,
      ),
    );

    final summary =
        response.features[0].properties['summary'] as Map<String, dynamic>;

    return RouteModel(
      points: response.features[0].geometry.coordinates
          .expand((e) => e)
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList(),
      distanceKm: (summary['distance'] as num).toDouble() / 1000,
      durationMin: (summary['duration'] as num).toDouble() / 60,
    );
  }
}
