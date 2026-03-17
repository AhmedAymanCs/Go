import 'package:go/core/utils/typedef.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

abstract class HomeDataSource {
  Places searchPlaces(String query);
  Future<List<LatLng>> getRouteCoordinates({
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
  Future<List<LatLng>> getRouteCoordinates({
    required LatLng destination,
    required LatLng position,
  }) async {
    final coordinates = await _ors.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
      endCoordinate: ORSCoordinate(
        latitude: destination.latitude,
        longitude: destination.longitude,
      ),
    );

    return coordinates.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }
}
