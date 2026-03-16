import 'package:dartz/dartz.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

typedef ServerResponse<T> = Future<Either<String, T>>;

typedef Places = Future<List<Place>>;
