import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go/core/constants/app_constants.dart';
import 'package:go/core/utils/typedef.dart';
import 'package:go/features/home/data/models/order_model.dart';
import 'package:go/features/home/data/models/route_model.dart';
import 'package:go/features/home/data/models/route_prams.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

abstract class HomeDataSource {
  Places searchPlaces(String query);
  Future<String> reverseGeocoding(LatLng position);
  Future<RouteModel> getRouteCoordinates(RoutePrams params);
  Future<void> createOrder(OrderModel order);
}

class HomeDataSourceImpl implements HomeDataSource {
  final Nominatim nominatim;
  final OpenRouteService ors;
  final FirebaseFirestore firestore;
  HomeDataSourceImpl({
    required this.nominatim,
    required this.ors,
    required this.firestore,
  });

  @override
  Places searchPlaces(String query) async {
    return nominatim.searchByName(query: query, limit: 5, countryCodes: ['eg']);
  }

  @override
  Future<RouteModel> getRouteCoordinates(RoutePrams params) async {
    final response = await ors.directionsRouteGeoJsonGet(
      startCoordinate: ORSCoordinate(
        latitude: params.position.latitude,
        longitude: params.position.longitude,
      ),
      endCoordinate: ORSCoordinate(
        latitude: params.destination.latitude,
        longitude: params.destination.longitude,
      ),
    );

    final summary =
        response.features[0].properties['summary'] as Map<String, dynamic>;
    final double distanceKm = (summary['distance'] as num).toDouble() / 1000;
    return RouteModel(
      placeName: params.placeName,
      points: response.features[0].geometry.coordinates
          .expand((e) => e)
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList(),
      distanceKm: distanceKm,
      price: distanceKm * AppConstants.pricePerKm,
      durationMin: (summary['duration'] as num).toDouble() / 600,
    );
  }

  @override
  Future<String> reverseGeocoding(LatLng position) async {
    final place = await nominatim.reverseSearch(
      lat: position.latitude,
      lon: position.longitude,
      language: 'ar',
    );
    return place.displayName;
  }

  @override
  Future<void> createOrder(OrderModel order) async {
    final doc = firestore.collection(AppConstants.ordersCollectionName).doc();
    final json = order.toJson();
    json['id'] = doc.id;
    await doc.set(json);
  }
}
