import 'package:dartz/dartz.dart';
import 'package:go/core/utils/typedef.dart';
import 'package:go/features/home/data/data_source/data_source.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

abstract class HomeRepository {
  ServerResponse<List<Place>> searchPlaces(String query);
  ServerResponse<List<LatLng>> getRouteCoordinates({
    required LatLng destination,
    required LatLng position,
  });
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _homeDataSource;
  HomeRepositoryImpl(this._homeDataSource);

  @override
  ServerResponse<List<Place>> searchPlaces(String query) async {
    try {
      final res = await _homeDataSource.searchPlaces(query);
      return Right(res);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<List<LatLng>> getRouteCoordinates({
    required LatLng destination,
    required LatLng position,
  }) async {
    try {
      final res = await _homeDataSource.getRouteCoordinates(
        destination: destination,
        position: position,
      );
      return Right(res);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
