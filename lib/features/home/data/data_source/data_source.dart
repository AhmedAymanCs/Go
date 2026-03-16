import 'package:go/core/utils/typedef.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

abstract class HomeDataSource {
  Places searchPlaces(String query);
}

class HomeDataSourceImpl implements HomeDataSource {
  final Nominatim nominatim;
  HomeDataSourceImpl(this.nominatim);

  @override
  Places searchPlaces(String query) async {
    return nominatim.searchByName(query: query, limit: 5, countryCodes: ['eg']);
  }
}
